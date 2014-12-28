class redis::install {
# Install redis-server package
  package { redis-server:
    ensure => installed,
    require => Exec["redis_repository"],
  }

# add Chris Lea ppa channel with Redis
  exec { "/usr/bin/add-apt-repository ppa:chris-lea/redis-server && apt-get update":
    alias => "redis_repository",
    require => Package["python-software-properties"],
    creates => "/etc/apt/sources.list.d/redis-${lsbdistcodename}.list",
  }

# add-apt-repository requires "python-software-properties" package
  package { "python-software-properties":
    ensure => installed,
  }
# Disabling autostart for redis-server - we'll be using modified init scripts
  exec { "/usr/sbin/update-rc.d -f redis-server remove":
    alias => "redis-server_remove",
    require => Package["redis-server"],
  }
}