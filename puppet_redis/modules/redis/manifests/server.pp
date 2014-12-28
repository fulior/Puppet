define redis::server (
  $redis_bind_ip	    = '0.0.0.0',          # listenIP for Redis, defaults to 0.0.0.0
  $redis_port		      = '6379',              # Redis tcp port, defaults to 6379
  $redis_master_port  = '',                 # Redis master port - used by slaves        
  $redis_master_ip 	  = '',  								# Is this a master node? Default no.
  $init_script        = "$title",
  ) {

  if $redis_master_ip == '' {
    $redis_config = "redis/redismaster.conf.erb"
  } else {
      $redis_config = "redis/redisslave.conf.erb"
    }
    
  file { "/etc/init.d/$init_script":
    content => template('redis/redis.init.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '755',
    require => Package['redis-server'],
    notify  => Exec["/etc/init.d/$init_script restart"],
  }
  
  file { "/etc/redis/$init_script.conf":
    content => template($redis_config),
    owner   => 'redis',
    group   => 'redis',
    mode    => '755',
    require => Package['redis-server'],
    require => Exec["exec_$init_script"],
    notify  => Exec["/etc/init.d/$init_script restart"],
  }  
  exec { "/usr/sbin/update-rc.d $init_script defaults":
    alias => "exec_$init_script",
    require => Package["redis-server"],
  }
  exec { "/etc/init.d/$init_script restart":
    require => Package["redis-server"],
  }

}
