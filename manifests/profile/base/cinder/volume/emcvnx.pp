#
# == Class: tripleo::profile::base::cinder::volume::emcvnx
#
# Cinder Volume emcvnx profile for tripleo
#
# === Parameters
#
# [*backend_name*]
#   (optional) Name given to the Cinder backend stanza
#   Defaults to 'tripleo_emcvnx'
#
# [*emcvnx_san_login*]
#   (optional) SAN username, required if using password auth
#
# [*emcvnx_san_password*]
#   (optional) SAN password for username, required if using password auth
#
# [*emcvnx_volume_driver*]
#   (optional) defaults to cinder.volume.drivers.emc.vnx.driver.EMCVNXDriver
#
# [*emcvnx_storage_protocol*]
#   (required) fc or iscsi for Fibre Channel or iSCSI, respectively
#
# [*emcvnx_san_ip*]
#   (required) IP address of array SP
#
# [*emcvnx_authentication_type*]
#   (optional) authentication scope; defaults to global
#
# [*emcvnx_security_file_dir*]
#   (optional) required if using naviseccli security file
#
# [*emcvnx_naviseccli_path*]
#   (optional) defaults to /opt/Navisphere/bin/naviseccli
#
# [*emcvnx_storage_pool_names*]
#   (required) comma separated list of storage pools
#
# [*emcvnx_iscsi_initiators*]
#   (optional) mapping between hostnames and their initiator IPs
#
# [*emcvnx_io_port_list*]
#   (optional) comma separated list of iSCSI or FC ports to use
#
# [*emcvnx_default_timeout*]
#   (optional) timeout for naviseccli operations in minutes
#
# [*emcvnx_max_luns_per_storage_group*]
#   (optional) defaults to 255
#
# [*emcvnx_destroy_empty_storage_group*]
#   (optional) destroy storage group after last LUN removed; default false
#
# [*emcvnx_initiator_auto_registration*]
#   (optional) automatically register host initiators; default false
#
# [*emcvnx_initiator_auto_deregistration*]
#   (optional) automatically deregister host initiators; default false
#
# [*emcvnx_check_max_pool_luns_threshold*]
#   (optional) reports free_gb 0 when max LUNs in pool reached; default false
#
# [*emcvnx_force_delete_lun_in_storagegroup*]
#   (optional) delete LUN even if in storage group; default false
#
# [*emcvnx_ignore_pool_full_threshold*]
#   (optional) force LUN creation even if pool full capacity reached
#
# [*step*]
#   (optional) The current step in deployment. See tripleo-heat-templates
#   for more details.
#   Defaults to hiera('step')
#
class tripleo::profile::base::cinder::volume::emcvnx (
  $backend_name                            = hiera('cinder::backend::emcvnx::volume_backend_name', 'tripleo_emcvnx'),
  $emcvnx_san_login                        = hiera('cinder::backend::emcvnx::emcvnx_san_login', undef),
  $emcvnx_san_password                     = hiera('cinder::backend::emcvnx::emcvnx_san_password', undef),
  $emcvnx_volume_driver                    = hiera('cinder::backend::emcvnx::emcvnx_volume_driver', 'cinder.volume.drivers.emc.vnx.driver.EMCVNXDriver'),
  $emcvnx_storage_protocol                 = hiera('cinder::backend::emcvnx::emcvnx_storage_protocol', undef),
  $emcvnx_san_ip                           = hiera('cinder::backend::emcvnx::emcvnx_san_ip', undef),
  $emcvnx_authentication_type              = hiera('cinder::backend::emcvnx::emcvnx_authentication_type', 'global'),
  $emcvnx_security_file_dir                = hiera('cinder::backend::emcvnx::emcvnx_security_file_dir', undef),
  $emcvnx_naviseccli_path                  = hiera('cinder::backend::emcvnx::emcvnx_naviseccli_path', '/opt/Navisphere/bin/naviseccli'),
  $emcvnx_storage_pool_names               = hiera('cinder::backend::emcvnx::emcvnx_storage_pool_names', undef),
  $emcvnx_iscsi_initiators                 = hiera('cinder::backend::emcvnx::emcvnx_iscsi_initiators', undef),
  $emcvnx_io_port_list                     = hiera('cinder::backend::emcvnx::emcvnx_io_port_list', undef),
  $emcvnx_default_timeout                  = hiera('cinder::backend::emcvnx::emcvnx_default_timeout', 180),
  $emcvnx_max_luns_per_storage_group       = hiera('cinder::backend::emcvnx::emcvnx_max_luns_per_storage_group', 255),
  $emcvnx_destroy_empty_storage_group      = hiera('cinder::backend::emcvnx::emcvnx_destroy_empty_storage_group', false),
  $emcvnx_initiator_auto_registration      = hiera('cinder::backend::emcvnx::emcvnx_initiator_auto_registration', false),
  $emcvnx_initiator_auto_deregistration    = hiera('cinder::backend::emcvnx::emcvnx_initiator_auto_deregistration', false),
  $emcvnx_check_max_pool_luns_threshold    = hiera('cinder::backend::emcvnx::emcvnx_check_max_pool_luns_threshold', false),
  $emcvnx_force_delete_lun_in_storagegroup = hiera('cinder::backend::emcvnx::emcvnx_force_delete_lun_in_storagegroup', false),
  $emcvnx_ignore_pool_full_threshold       = hiera('cinder::backend::emcvnx::emcvnx_ignore_pool_full_threshold', false),
  $step                                    = hiera('step'),
) {
  include ::tripleo::profile::base::cinder::volume

  if $step >= 4 {
    cinder::backend::emcvnx { $backend_name :
      emcvnx_san_login                        => $emcvnx_san_login,
      emcvnx_san_password                     => $emcvnx_san_password,
      emcvnx_volume_driver                    => $emcvnx_volume_driver,
      emcvnx_storage_protocol                 => $emcvnx_storage_protocol,
      emcvnx_san_ip                           => $emcvnx_san_ip,
      emcvnx_authentication_type              => $emcvnx_authentication_type,
      emcvnx_security_file_dir                => $emcvnx_security_file_dir,
      emcvnx_naviseccli_path                  => $emcvnx_naviseccli_path,
      emcvnx_storage_pool_names               => $emcvnx_storage_pool_names,
      emcvnx_iscsi_initiators                 => $emcvnx_iscsi_initiators,
      emcvnx_io_port_list                     => $emcvnx_io_port_list,
      emcvnx_default_timeout                  => $emcvnx_default_timeout,
      emcvnx_max_luns_per_storage_group       => $emcvnx_max_luns_per_storage_group,
      emcvnx_destroy_empty_storage_group      => $emcvnx_destroy_empty_storage_group,
      emcvnx_initiator_auto_registration      => $emcvnx_initiator_auto_registration,
      emcvnx_initiator_auto_deregistration    => $emcvnx_initiator_auto_deregistration,
      emcvnx_check_max_pool_luns_threshold    => $emcvnx_check_max_pool_luns_threshold,
      emcvnx_force_delete_lun_in_storagegroup => $emcvnx_force_delete_lun_in_storagegroup,
      emcvnx_ignore_pool_full_threshold       => $emcvnx_ignore_pool_full_threshold,
    }
  }

}
