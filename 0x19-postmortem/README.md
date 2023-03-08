# Postmortem

After ALX released their System Engineering & DevOps project 0x19, an outage happened on an Ubuntu 14.04 container with an Apache web server in Ethiopia around 09:00 East African Time (EAT). Accessing the server through GET requests resulted in 500 Internal Server Errors, even though the anticipated response was an HTML file containing a Holberton WordPress site definition.

## Debugging process

The bug debugger, whose initials are coincidentally BDM, discovered an issue when opening the project and was instructed to address it Without delay, BDM set out to solve the problem and debug with the following steps.

1. Checked running processes using `ps aux`. Two `apache2` processes - `root` and `www-data` -
were properly running.

2. Looked in the `sites-available` folder of the `/etc/apache2/` directory. Determined that
the web server was serving content located in `/var/www/html/`.

3. In one terminal, ran `strace` on the PID of the `root` Apache process. In another, curled
the server. Expected great things... only to be disappointed. `strace` gave no useful
information.

4. Repeated step 3, except on the PID of the `www-data` process. Kept expectations lower this
time... but was rewarded! `strace` revelead an `-1 ENOENT (No such file or directory)` error
occurring upon an attempt to access the file `/var/www/html/wp-includes/class-wp-locale.php`.

5. Looked through files in the `/var/www/html/` directory one-by-one, using Vim pattern
matching to try and locate the erroneous `.phpp` file extension. Located it in the
`wp-settings.php` file. (Line 137, `require_once( ABSPATH . WPINC . '/class-wp-locale.php' );`).

6. Removed the trailing `p` from the line.

7. Tested another `curl` on the server. 200 A-ok!

8. Wrote a Puppet manifest to automate fixing of the error.

## SUMMATION

To put it succinctly, the problem encountered was a typo which had amusingly caused the issue. Going into more detail, the WordPress application was encountering a severe error in wp-settings.php when attempting to load the class-wp-locale.phpp file. The correct file name was class-wp-locale.php, which was situated in the wp-content directory within the application folder.

The solution to the problem was quite straightforward as it just involved correcting the typo. Essentially, the trailing p was removed.

## PREVENTION

The outage that occurred was not due to the web server experiencing errors, but instead, it was an application malfunction. To prevent similar outages from happening in the future, we advise that you keep the following points in mind:

* Perform testing before releasing. Test the application before it is deployed. If the app had been tested beforehand, this error would have been detected earlier and could have been resolved in advance.

* Monitor the status of the system regularly. Enable uptime monitoring services such as UptimeRobot that can instantly notify you if there is an outage on your website.
