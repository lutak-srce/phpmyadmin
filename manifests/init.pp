#
# = Class: phpmyadmin
#
# This modules installs phpmyadmin
#
class phpmyadmin (
  $ensure               = 'present',
  $package              = $::phpmyadmin::params::package,
  $version              = $::phpmyadmin::params::version,
  $file_owner           = $::phpmyadmin::params::file_owner,
  $file_group           = $::phpmyadmin::params::file_group,
  $file_mode            = $::phpmyadmin::params::file_mode,
  $manage_config        = true,
  $config_inc_template  = $::phpmyadmin::params::config_inc_template,
  $manage_apache        = false,
  $allow_access         = [ '127.0.0.1', '::1' ],
  $allow_setup          = [ '127.0.0.1', '::1' ],
) inherits phpmyadmin::params {

  ### Internal variables (that map class parameters)
  if $ensure == 'present' {
    $package_ensure = $version ? {
      ''      => 'present',
      default => $version,
    }
    $file_ensure    = 'present'
  } else {
    $package_ensure = 'absent'
    $file_ensurea   = 'absent'
  }

  ### Module code
  package { 'phpmyadmin':
    ensure => $package_ensure,
    name   => $package,
  }

  file { '/etc/phpmyadmin/config.php.inc':
    ensure  => file,
    path    => "/etc/${package}/config.inc.php",
    content => template($config_inc_template),
    require => Package['phpmyadmin'],
  }

  # put apache conf in place
  if ( $manage_apache ) {
    include ::apache
    file { 'phpmyadmin.conf':
      ensure  => file,
      path    => "${::apache::confd_dir}/${package}.conf",
      content => template('phpmyadmin/phpmyadmin.conf.erb'),
      require => Package['phpmyadmin'],
      notify  => Service['httpd'],
    }
  }

}
