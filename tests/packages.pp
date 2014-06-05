class { 'linux_postinstall':
  install_packages => 'ntp',
  execute_file_command => 'echo true',
}
