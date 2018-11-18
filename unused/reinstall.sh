#!/bin/sh
./shan-ocp-dep-hw-v2/uninstall.sh
rm -rf shan-ocp-dep-hw-v2/
git clone https://github.com/TechGolla/shan-ocp-dep-hw-v2
cd shan-ocp-dep-hw-v2
chmod 777 *.sh
./install.sh
