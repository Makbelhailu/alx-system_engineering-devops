# execute pkill on spacific process

exec { 'killmenow':
  command  => 'pkill killmenow',
  provider => 'shell',
}
