# Copyright 2016 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# == Class: tripleo::profile::base::haproxy
#
# Loadbalancer profile for tripleo
#
# === Parameters
#
# [*step*]
#   (Optional) The current step in deployment. See tripleo-heat-templates
#   for more details.
#   Defaults to hiera('step')
#
# [*enable_load_balancer*]
#   (Optional) Whether or not loadbalancer is enabled.
#   Defaults to hiera('enable_load_balancer', true).
#
# [*generate_service_certificates*]
#   (Optional) Whether or not certmonger will generate certificates for
#   HAProxy. This could be as many as specified by the $certificates_specs
#   variable.
#   Note that this doesn't configure the certificates in haproxy, it merely
#   creates the certificates.
#   Defaults to hiera('generate_service_certificate', false).
#
# [*certmonger_ca*]
#   (Optional) The CA that certmonger will use to generate the certificates.
#   Defaults to hiera('certmonger_ca', 'local').
#
# [*certificates_specs*]
#   (Optional) The specifications to give to certmonger for the certificate(s)
#   it will create.
#   Example with hiera:
#     tripleo::profile::base::haproxy::certificates_specs:
#       undercloud-haproxy-public-cert:
#         service_pem: <haproxy ready pem file>
#         service_certificate: <service certificate path>
#         service_key: <service key path>
#         hostname: <undercloud fqdn>
#         postsave_cmd: <command to update certificate on resubmit>
#         principal: "haproxy/<undercloud fqdn>"
#   Defaults to {}.
#
class tripleo::profile::base::haproxy (
  $enable_load_balancer          = hiera('enable_load_balancer', true),
  $step                          = hiera('step'),
  $generate_service_certificates = hiera('generate_service_certificates', false),
  $certmonger_ca                 = hiera('certmonger_ca', 'local'),
  $certificates_specs            = {},
) {

  if $step >= 1 {
    if $enable_load_balancer {
      if str2bool($generate_service_certificates) {
        include ::certmonger
        # This is only needed for certmonger's local CA. For any other CA this
        # operation (trusting the CA) should be done by the deployer.
        if $certmonger_ca == 'local' {
          include ::tripleo::certmonger::ca::local
        }

        Certmonger_certificate {
          ca          => $certmonger_ca,
          ensure      => 'present',
          wait        => true,
          require     => Class['::certmonger'],
        }
        create_resources('::tripleo::certmonger::haproxy', $certificates_specs)
      }

      include ::tripleo::haproxy
    }
  }

}

