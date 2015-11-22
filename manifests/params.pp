#
# Class: phpmyadmin::params
#
# This module contains defaults for phpmyadmin
#
class phpmyadmin::params {

  # general phpmyadmin settings
  $ensure         = 'present'

  # module specific settings (agent)
  $file_owner     = 'root'
  $file_group     = 'root'
  $file_mode      = '0644'

  # module dependencies
  $dependency_class = undef
  $my_class         = undef

  # install package depending on major version
  case $::osfamily {
    default: {
    }
    /(RedHat|redhat|amazon)/: {
      $package = 'phpMyAdmin'
      $version = 'present'
      $config_inc_template = 'phpmyadmin/rhel_config.inc.php.erb'
    }
    /(Debian|debian|Ubuntu|ubuntu)/: {
      $package = 'phpmyadmin'
      $version = 'present'
      $config_inc_template = 'phpmyadmin/debian_config.inc.php.erb'
    }
  }

}
