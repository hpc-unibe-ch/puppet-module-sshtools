# @summary Deploy private and public ssh host key files
#
# This module install a ssh host key in the server (basically, it is
# a file resource. Keep in mind to notify the sshd service you are
# using, i.e. Service['sshd_service'] when using ghoneycutt-ssh.
#
# @example
#   sshtools::server::host_key { 'ssh_host_key_ecdsa':
#      ensure              => 'present',
#      public_key_content  => 'AAAAE2VjZHNhLXNoYTItbmlzdHAyNTY...',
#      private_key_content => '-----BEGIN EC PRIV...',
#   }
#   Sshtools::Server::Host_key<| |> ~ Service['sshd_service']
#
# @param ensure Set to either 'present' or 'absent' to remove host_key files
# @param public_key_content The contentn for the public key file
# @param private_key_content The contentn for the private key file
#
# [*public_key_content*]
#   Sets the content for the public key file.
#   Note public_key_source and public_key_content are mutually exclusive.

# [*private_key_content*]
#   Sets the content for the private key file.
#   Note private_key_source and private_key_content are mutually exclusive.
#
define sshtools::server::host_key (
  Enum['present','absent'] $ensure = 'present',
  String $public_key_content       = '',
  String $private_key_content      = '',
) {
  if $public_key_content == '' and $ensure == 'present' {
    fail('You must provide either public_key_source or public_key_content parameter')
  }
  if $private_key_content == '' and $ensure == 'present' {
    fail('You must provide either private_key_source or private_key_content parameter')
  }

  if $ensure == 'present' {
    file {"${name}_pub":
      ensure  => $ensure,
      owner   => 0,
      group   => 0,
      mode    => '0644',
      path    => "/etc/ssh/${name}.pub",
      content => $public_key_content,
    }

    file {"${name}_priv":
      ensure  => $ensure,
      owner   => 0,
      group   => 'ssh_keys',
      mode    => '0640',
      path    => "/etc/ssh/${name}",
      content => $private_key_content,
    }
  } else {
    file {"${name}_pub":
      ensure => $ensure,
      owner  => 0,
      group  => 0,
      mode   => '0644',
      path   => "/etc/ssh/${name}.pub",
    }

    file {"${name}_priv":
      ensure => $ensure,
      owner  => 0,
      group  => 'ssh_keys',
      mode   => '0640',
      path   => "/etc/ssh/${name}",
    }
  }
}
