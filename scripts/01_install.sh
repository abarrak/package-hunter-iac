#!/usr/bin/env bash
set -euo pipefail

## Setup depenedencies:
#

rpm --import https://falco.org/repo/falcosecurity-packages.asc
curl -s -o /etc/yum.repos.d/falcosecurity.repo https://falco.org/repo/falcosecurity-rpm.repo
yum update -y

yum install -y dkms make
yum install -y kernel-devel-$(uname -r)
yum install -y clang llvm
yum install -y dialog
yum install -y falco

yum groupinstall "Development Tools"
sudo yum module install nodejs

##
# @note:
# if the  system has UEFI SecureBoot enabled,
# and faclo fails to load, follow the setups:
#
#  1. Import the DKMS Machine Owner Key
#     $ sudo mokutil --import /var/lib/dkms/mok.pub
#  2. Restart the system and wait for the MOK key enrollment prompt
#  3. Choose the option:  Enroll MOK
#  4. Load the Falco driver
#     $ insmod /var/lib/dkms/falco/4.0.0+driver/$(uname -r)/x86_64/module/falco.ko.xz
#
# @ref:
# https://falco.org/docs/install-operate/installation/
