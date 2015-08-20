#!/bin/bash -eux

echo "Installing vbox vmtools requirements"
sudo yum --setopt=tsflags=nodocs -y install gcc kernel-devel kernel-headers make perl

