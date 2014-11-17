# == Define hyperic::rpm_gpg_key
#
# This define is a repurposed version of stahma's epel beauty and imports the RPM GPG keys for vFabric
#
# === Parameters
#
# [*path*]
#   Path of the RPM GPG key to import
#
# === Sample usage
#
# hyperic::rpm_gpg_key{
#   path => "/etc/pki/rpm-gpg/RPM-GPG-KEY-VFABRIC-5.3-EL6"
# }
#
define hyperic::rpm_gpg_key($path) {
  # Given the path to a key, see if it is imported, and if not, import it
  exec {  "import-${name}":
    path      => '/bin:/usr/bin:/sbin:/usr/sbin',
    command   => "rpm --import ${path}",
    unless    => "rpm -q gpg-pubkey-$(echo $(gpg --throw-keyids < ${path}) | cut --characters=11-18 | tr '[A-Z]' '[a-z]')",
    require   => File[$path],
    logoutput => on_failure,
  }
}