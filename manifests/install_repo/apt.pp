##apt.pp

# Class: fluentd::install_repo::apt ()
#
#
class fluentd::install_repo::apt () {

  $location = $::lsbdistcodename? {
    'precise' => $::lsbdistcodename,
    'lucid'   => 'debian'
  }

    # Sorry for the different naming of the Rpository between debian and redhat.
    # But I dont want rename it to avoid a duplication.

    file { '/tmp/packages.treasure-data.com.key':
        ensure => file,
        source => 'puppet:///modules/fluentd/packages.treasure-data.com.key'
    }->
    exec { "import gpg key Treasure Data":
        command => "/bin/cat /tmp/packages.treasure-data.com.key | apt-key add -",
        unless  => "/usr/bin/apt-key list | grep -q 'Treasure Data'",
    } ->

    apt::source { 'treasure-data':
      location    => "http://packages.treasure-data.com/${location}",
      release     => $::lsbdistcodename,
      repos       => "contrib",
      include_src => false,
      notify      => Exec['apt-get_update']
    }
}
