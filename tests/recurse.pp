class { 'linux_postinstall':
  upload_file => 'test',
  upload_recursive => true,
  execute_file_command => 'cat test/foo',
}


