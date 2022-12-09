# check file on tmp
fie { '/tmp/school':
  mode => '0744',
  owner => 'www-data',
  group => 'www-data',
  content => 'I love Puppet',
}
