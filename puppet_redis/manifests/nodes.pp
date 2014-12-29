node 'default' {


# install redis-server package from Chris Lea PPA channel
  include redis::install

# Configure master or single redis instance		
  redis::server {'redis01':
    redis_bind_ip      =>  $::ipaddress_eth0,
    redis_port         => '6379',                
  }
# Configure sentinel 01, requires redis_master_ip and redis_master_port arguments
  redis::sentinel { 'sentinel01':
    sentinel_port      => '26379',
    redis_master_ip    => $::ipaddress_eth0,
    redis_master_port  => '6379',
    redis_master_name  => 'redis01',
  }
# Configure slave redis instance, slave configuration requires redis_master_ip and redis_master_port arguments
  redis::server { 'redis02':
    redis_bind_ip      => $::ipaddress_eth0,
    redis_port         => '16379',
    redis_master_ip    => $::ipaddress_eth0,
    redis_master_port  => '6379',
  }
# Configure sentinel 02, requires redis_master_ip and redis_master_port arguments
  redis::sentinel { 'sentinel02':
    sentinel_port      => '36379',
    redis_master_ip    => $::ipaddress_eth0,
    redis_master_port  => '6379',
    redis_master_name  => 'redis01',
  }
}
