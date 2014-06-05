class { 'linux_postinstall':
  upload_file => 'demo',
  execute_file_command => 'cat demo',
}

