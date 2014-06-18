# Add support for postinstall file and script:
class linux_postinstall(
  $install_packages = undef,
  $upload_share     = undef,
  $upload_file      = undef,
  $upload_recursive = false,
  $execute_file_command,
  $yum_proxy        = undef,
) {

  $path = "${vardir}/staging:${vardir}/staging/${file}:${::path}"
  $vardir = $::puppet_vardir
  if $upload_share {
    $mod_path = $upload_share
  } else {
    $mod_path = 'puppet:///modules/linux_postinstall'
  }

  if $install_packages {
    $packages = split($install_packages, ',')

    package { $packages:
      ensure => present,
    }
  }

  if $upload_file {
    $staging = "${vardir}/staging"
    file { $staging:
      ensure => directory,
      mode   => 755,
    }

    file { "${staging}/${upload_file}":
      source  => "${mod_path}/${upload_file}",
      recurse => $upload_recursive,
      before  => Exec[postinstall],
    }

    if $upload_recursive {
      $cwd = "${staging}/${file}"
    } else {
      $cwd = $staging
    }
  }

  $exec_lck = "${vardir}/postinstall.lck"

  if $execute_file_command{
    exec { postinstall:
      command   => $execute_file_command,
      path      => $path,
      cwd       => $cwd,
      creates   => $exec_lck,
      logoutput => true,
    }

    file { $exec_lck:
      ensure  => file,
      require => Exec[postinstall],
    }
  }
  
  if $yum_proxy {
    file_line { yum_proxy :
      ensure => present,
      line   => "proxy=${yum_proxy}",
      path   => '/etc/yum.conf',
      before => Package[$packages],
    }
  }
}
