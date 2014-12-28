define redis::sentinel (
  $sentinel_port        = '26379',           # Sentinel tcp port, defaults to 26379
  $redis_master_port	= '6379',           # Redis tcp port, defaults to 6379
  $redis_master_ip 	= '',  	            # Is this a master node? Default no.
  $redis_master_name    = 'redis01',        # Name of the master instance - defaults to redis01
  $init_script          = "$title",
  ) {

# Create Sentinel init script based on our template (uses '$title' as instance name)
  file { "/etc/init.d/$init_script":
    content => template('redis/sentinel.init.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '755',
    require => Package['redis-server'],
    before => Exec["/etc/init.d/$init_script restart"],
  }
# Create Sentinel configuration, based on our template and provided variables
  file { "/etc/redis/$init_script.conf":
    content => template('redis/sentinel.conf.erb'),
    owner   => 'redis',
    group   => 'redis',
    mode    => '755',
    require => Package['redis-server'],
    notify  => Exec["/etc/init.d/$init_script restart"],
  }  
# Make sure that this instance of Sentinel will start after reboot
  exec { "/usr/sbin/update-rc.d $init_script defaults":
    alias => "update-rc.d_$init_script",
    require => Package['redis-server'],
  }
# Restart this instance on notify
  exec { "/etc/init.d/$init_script restart":
    require => File["/etc/init.d/$init_script"],
    before => Exec["update-rc.d_$init_script"],
  }
}
