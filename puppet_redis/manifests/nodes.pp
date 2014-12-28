node 'default' {
  include redis::install
		
  redis::server {'redis01':
    redis_bind_ip      =>  $::ipaddress_eth0,
    redis_port         => '6379',                
  }
  redis::sentinel { 'sentinel01':
    sentinel_port      => '26379',
    redis_master_ip    => $::ipaddress_eth0,
    redis_master_port  => '6379',
    redis_master_name  => 'redis01',
  }

  redis::server { 'redis02':
    redis_bind_ip      => $::ipaddress_eth0,
    redis_port         => '16379',
    redis_master_ip    => $::ipaddress_eth0,
    redis_master_port  => '6379',
  }
  redis::sentinel { 'sentinel02':
    sentinel_port      => '36379',
    redis_master_ip    => $::ipaddress_eth0,
    redis_master_port  => '6379',
    redis_master_name  => 'redis01',
  }
}
