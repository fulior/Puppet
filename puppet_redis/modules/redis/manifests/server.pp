define redis::server (
  $redis_bind_ip      = '0.0.0.0',      # listenIP for Redis, defaults to 0.0.0.0
  $redis_port	      = '6379',         # Redis tcp port, defaults to 6379
  $redis_master_port  = '',             # Redis master port - used by slaves
  $redis_master_ip    = '',  		# Is this a master node? Defaults to no.
  $init_script        = "$title",
  ) {

# Check if we're configuring slave or master
  if $redis_master_ip == '' {
    $redis_config = "redis/redismaster.conf.erb"
  } else {
      $redis_config = "redis/redisslave.conf.erb"
    }
# Create init script for this instance of Redis
  file { "/etc/init.d/$init_script":
    content => template('redis/redis.init.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '755',
    require => Package['redis-server'],
    before => Exec["/etc/init.d/$init_script restart"],
    }
# Create configuration for this instance of Redis
  file { "/etc/redis/$init_script.conf":
    content => template($redis_config),
    owner   => 'redis',
    group   => 'redis',
    mode    => '755',
    require => Package['redis-server'],
    notify  => Exec["/etc/init.d/$init_script restart"],
  }  
# Make sure that this daemon will start after reboot
  exec { "/usr/sbin/update-rc.d $init_script defaults":
    alias   => "update_rc.d_$init_script",
    require => File["/etc/init.d/$init_script"],
  }
# Execute Redis restart on notify
  exec { "/etc/init.d/$init_script restart":
    require => File["/etc/init.d/$init_script"],
    before  => Exec["update_rc.d_$init_script"],
  }
}
