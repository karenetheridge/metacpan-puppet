# == Class: elasticsearch
#
# This class is able to install or remove elasticsearch on a node.
# It manages the status of the related service.
#
# === Parameters
#
# [*ensure*]
#   String. Controls if the managed resources shall be <tt>present</tt> or
#   <tt>absent</tt>. If set to <tt>absent</tt>:
#   * The managed software packages are being uninstalled.
#   * Any traces of the packages will be purged as good as possible. This may
#     include existing configuration files. The exact behavior is provider
#     dependent. Q.v.:
#     * Puppet type reference: {package, "purgeable"}[http://j.mp/xbxmNP]
#     * {Puppet's package provider source code}[http://j.mp/wtVCaL]
#   * System modifications (if any) will be reverted as good as possible
#     (e.g. removal of created users, services, changed log settings, ...).
#   * This is thus destructive and should be used with care.
#   Defaults to <tt>present</tt>.
#
# [*autoupgrade*]
#   Boolean. If set to <tt>true</tt>, any managed package gets upgraded
#   on each Puppet run when the package provider is able to find a newer
#   version than the present one. The exact behavior is provider dependent.
#   Q.v.:
#   * Puppet type reference: {package, "upgradeable"}[http://j.mp/xbxmNP]
#   * {Puppet's package provider source code}[http://j.mp/wtVCaL]
#   Defaults to <tt>false</tt>.
#
# [*status*]
#   String to define the status of the service. Possible values:
#   * <tt>enabled</tt>: Service is running and will be started at boot time.
#   * <tt>disabled</tt>: Service is stopped and will not be started at boot
#     time.
#   * <tt>running</tt>: Service is running but will not be started at boot time.
#     You can use this to start a service on the first Puppet run instead of
#     the system startup.
#   * <tt>unmanaged</tt>: Service will not be started at boot time and Puppet
#     does not care whether the service is running or not. For example, this may
#     be useful if a cluster management software is used to decide when to start
#     the service plus assuring it is running on the desired node.
#   Defaults to <tt>enabled</tt>. The singular form ("service") is used for the
#   sake of convenience. Of course, the defined status affects all services if
#   more than one is managed (see <tt>service.pp</tt> to check if this is the
#   case).
#
# [*version*]
#   String to set the specific version you want to install.
#   Defaults to <tt>false</tt>.
#
# [*restart_on_change*]
#   Boolean that determines if the application should be automatically restarted
#   whenever the configuration changes. Disabling automatic restarts on config
#   changes may be desired in an environment where you need to ensure restarts
#   occur in a controlled/rolling manner rather than during a Puppet run.
#
#   Defaults to <tt>true</tt>, which will restart the application on any config
#   change. Setting to <tt>false</tt> disables the automatic restart.
#
# [*configdir*]
#   Path to directory containing the elasticsearch configuration.
#   Use this setting if your packages deviate from the norm (/etc/elasticsearch)
#
# [*plugindir*]
#   Path to directory containing the elasticsearch plugins
#   Use this setting if your packages deviate from the norm (/usr/share/elasticsearch/plugins)
#
# [*plugintool*]
#   Path to directory containing the elasticsearch plugin installation script
#   Use this setting if your packages deviate from the norm (/usr/share/elasticsearch/bin/plugin)
#
# [*package_url*]
#   Url to the package to download.
#   This can be a http,https or ftp resource for remote packages
#   puppet:// resource or file:/ for local packages
#
# [*package_provider*]
#   Way to install the packages, currently only packages are supported.
#
# [*package_dir*]
#   Directory where the packages are downloaded to
#
# [*package_name*]
#   Name of the package to install
#
# [*purge_package_dir*]
#   Purge package directory on removal
#
# [*package_dl_timeout*]
#   For http,https and ftp downloads you can set howlong the exec resource may take.
#   Defaults to: 600 seconds
#
# [*elasticsearch_user*]
#   The user Elasticsearch should run as. This also sets the file rights.
#
# [*elasticsearch_group*]
#   The group Elasticsearch should run as. This also sets the file rights
#
# [*purge_configdir*]
#   Purge the config directory for any unmanaged files
#
# [*service_provider*]
#   Service provider to use. By Default when a single service provider is possibe that one is selected.
#
# [*init_defaults*]
#   Defaults file content in hash representation
#
# [*init_defaults_file*]
#   Defaults file as puppet resource
#
# [*init_template*]
#   Service file as a template
#
# [*config*]
#   Elasticsearch configuration hash
#
# [*datadir*]
#   Allows you to set the data directory of Elasticsearch
#
# [*java_install*]
#  Install java which is required for Elasticsearch.
#  Defaults to: false
#
# [*java_package*]
#   If you like to install a custom java package, put the name here.
#
# [*manage_repo*]
#   Enable repo management by enabling our official repositories
#
# [*repo_version*]
#   Our repositories are versioned per major version (0.90, 1.0) select here which version you want
#
# [*logging_config*]
#   Hash representation of information you want in the logging.yml file
#
# [*logging_file*]
#   Instead of a hash you can supply a puppet:// file source for the logging.yml file
#
# [*default_logging_level*]
#   Default logging level for Elasticsearch.
#   Defaults to: INFO
#
# [*repo_stage*]
#   Use stdlib stage setup for managing the repo, instead of anchoring
#
# The default values for the parameters are set in elasticsearch::params. Have
# a look at the corresponding <tt>params.pp</tt> manifest file if you need more
# technical information about them.
#
# === Examples
#
# * Installation, make sure service is running and will be started at boot time:
#     class { 'elasticsearch': }
#
# * Removal/decommissioning:
#     class { 'elasticsearch':
#       ensure => 'absent',
#     }
#
# * Install everything but disable service(s) afterwards
#     class { 'elasticsearch':
#       status => 'disabled',
#     }
#
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard.pijnenburg@elasticsearch.com>
#
class elasticsearch(
  $ensure                = $elasticsearch::params::ensure,
  $status                = $elasticsearch::params::status,
  $restart_on_change     = $elasticsearch::params::restart_on_change,
  $autoupgrade           = $elasticsearch::params::autoupgrade,
  $version               = false,
  $package_provider      = 'package',
  $package_url           = undef,
  $package_dir           = $elasticsearch::params::package_dir,
  $package_name          = $elasticsearch::params::package,
  $purge_package_dir     = $elasticsearch::params::purge_package_dir,
  $package_dl_timeout    = $elasticsearch::params::package_dl_timeout,
  $elasticsearch_user    = $elasticsearch::params::elasticsearch_user,
  $elasticsearch_group   = $elasticsearch::params::elasticsearch_group,
  $configdir             = $elasticsearch::params::configdir,
  $purge_configdir       = $elasticsearch::params::purge_configdir,
  $service_provider      = 'init',
  $init_defaults         = undef,
  $init_defaults_file    = undef,
  $init_template         = undef,
  $config                = undef,
  $datadir               = $elasticsearch::params::datadir,
  $plugindir             = $elasticsearch::params::plugindir,
  $plugintool            = $elasticsearch::params::plugintool,
  $java_install          = false,
  $java_package          = undef,
  $manage_repo           = false,
  $repo_version          = false,
  $logging_file          = undef,
  $logging_config        = undef,
  $default_logging_level = $elasticsearch::params::default_logging_level,
  $repo_stage            = false
) inherits elasticsearch::params {

  anchor {'elasticsearch::begin': }
  anchor {'elasticsearch::end': }


  Elasticsearch::Instance <| |> -> Elasticsearch::Template <| |>
  #### Validate parameters

  # ensure
  if ! ($ensure in [ 'present', 'absent' ]) {
    fail("\"${ensure}\" is not a valid ensure parameter value")
  }

  # autoupgrade
  validate_bool($autoupgrade)

  # service status
  if ! ($status in [ 'enabled', 'disabled', 'running', 'unmanaged' ]) {
    fail("\"${status}\" is not a valid status parameter value")
  }

  # restart on change
  validate_bool($restart_on_change)

  # purge conf dir
  validate_bool($purge_configdir)

  if is_array($elasticsearch::params::service_providers) {
    # Verify the service provider given is in the array
    if ! ($service_provider in $elasticsearch::params::service_providers) {
      fail("\"${service_provider}\" is not a valid provider for \"${::operatingsystem}\"")
    }
    $real_service_provider = $service_provider
  } else {
    # There is only one option so simply set it
    $real_service_provider = $elasticsearch::params::service_providers
  }

  if ($package_url != undef and $version != false) {
    fail('Unable to set the version number when using package_url option.')
  }

  if $ensure == 'present' {
    # validate config hash
    if ($config != undef) {
      validate_hash($config)
    }
  }

  # java install validation
  validate_bool($java_install)

  validate_bool($manage_repo)

  if ($manage_repo == true) {
    validate_string($repo_version)
  }

  #### Manage actions

  # package(s)
  class { 'elasticsearch::package': }

  # configuration
  class { 'elasticsearch::config': }

  if $java_install == true {
    # Install java
    class { 'elasticsearch::java': }

    # ensure we first java java and then manage the service
    Anchor['elasticsearch::begin']
    -> Class['elasticsearch::java']
    -> Class['elasticsearch::package']
  }

  if ($manage_repo == true) {

    if ($repo_stage == false) {
      # use anchor for ordering

      # Set up repositories
      class { 'elasticsearch::repo': }

      # Ensure that we set up the repositories before trying to install
      # the packages
      Anchor['elasticsearch::begin']
      -> Class['elasticsearch::repo']
      -> Class['elasticsearch::package']

    } else {
      # use staging for ordering

      if !(defined(Stage[$repo_stage])) {
        stage { $repo_stage:  before => Stage['main'] }
      }

      class { 'elasticsearch::repo':
        stage => $repo_stage
      }
    }
  }

  #### Manage relationships

  if $ensure == 'present' {

    # we need the software before configuring it
    Anchor['elasticsearch::begin']
    -> Class['elasticsearch::package']
    -> Class['elasticsearch::config']

  } else {

    # make sure all services are getting stopped before software removal
    Class['elasticsearch::config']
    -> Class['elasticsearch::package']

  }

}
