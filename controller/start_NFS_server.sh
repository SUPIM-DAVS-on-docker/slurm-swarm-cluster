#!/bin/sh

echo "/home/supim-davs $(hostname)(rw,root_squash,no_root_squash)" > /etc/exports
/etc/init.d/nfs restart
