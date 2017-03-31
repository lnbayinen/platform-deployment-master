#!/bin/bash

# Abort on ALL errors
set -e

URL='https://packages.chef.io/stable/el/7/chef-12.12.15-1.el7.x86_64.rpm'
SUM='ce1f216242f26d7274c108a9cb9d8add7095727e039bac968de9291f56a90c25'
PKG=$(mktemp chef-install.XXXXXXXXX)

cd /tmp
curl -Ls -o "$PKG" "$URL"
echo "$SUM  $PKG" | sha256sum -c
rpm -ivh "$PKG"
rm "$PKG"
