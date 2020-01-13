#!/bin/bash

# Copyright 2019 The Openstack-Helm Authors.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

set -xe

#NOTE: Lint and package chart
make prometheus-process-exporter

#NOTE: Deploy command
tee /tmp/prometheus-process-exporter.yaml << EOF
pod:
  mandatory_access_control:
    type: apparmor
    process-exporter:
      process-exporter: runtime/default
EOF
helm upgrade --install prometheus-process-exporter ./prometheus-process-exporter \
    --namespace=kube-system \
    --values=/tmp/prometheus-process-exporter.yaml

#NOTE: Wait for deploy
./tools/deployment/common/wait-for-pods.sh kube-system

#NOTE: Validate Deployment info
helm status prometheus-process-exporter
