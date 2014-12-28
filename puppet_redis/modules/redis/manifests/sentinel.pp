define redis::sentinel (
  $sentinel_port 		= '26379',            # Sentinel tcp port, defaults to 26379
  $redis_master_port		    = '6379',             # Redis tcp port, defaults to 6379
  $redis_master_ip 	= '',  								# Is this a master node? Default no.
  $redis_master_name  = 'redis01',        # Name of the master instance - defaults to redis01
  $init_script      = "$title",
  ) {
  file { "/etc/init.d/$init_script":
    content => template('redis/sentinel.init.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '755',
    require => Package['redis-server'],
    notify  => Exec["/etc/init.d/$init_script restart"],
  }
  
  file { "/etc/redis/$init_script.conf":
    content => template('redis/sentinel.conf.erb'),
    owner   => 'redis',
    group   => 'redis',
    mode    => '755',
    require => Package['redis-server'],
    notify  => Exec["/etc/init.d/$init_script restart"],
  }  
  exec { "/usr/sbin/update-rc.d $init_script defaults":
    alias => "sentinel_init",
    require => Package["redis-server"],
  }
  exec { "/etc/init.d/$init_script restart":
    require => Package["redis-server"],
  }

}
