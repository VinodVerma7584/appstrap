#!/bin/bash
# cloudinit script
# https://help.ubuntu.com/community/CloudInit
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
yum -y update    # for security
yum -y install git
yum -y groupinstall "Development Tools"
easy_install pip
pip install virtualenv
pip install boto_rsync      # put this in the system python
yum -y install python-devel  # needed to install(init?) virtualenv with local python
yum -y install ncurses-devel # needed to install pkgsrc python
yum -y install dialog
yum -y install openssl-devel
yum -y install libjpeg-devel
yum -y install freetype-devel
yum -y install libtiff-devel
yum -y install lcms-devel

su - ec2-user -c 'curl -L https://raw.github.com/ucldc/appstrap/master/cdl/ucldc-operator-keys.txt >> ~/.ssh/authorized_keys'

useradd nuxeo
touch ~nuxeo/init.sh
chown nuxeo:nuxeo ~nuxeo/init.sh
chmod 700 ~nuxeo/init.sh
# write the file
cat > ~nuxeo/init.sh <<EOSETUP
#!/usr/bin/env bash
cd
git clone https://github.com/ucldc/appstrap.git
./appstrap/cronic/atnow ./appstrap/stacks/stack_nuxeo
EOSETUP
su - nuxeo -c ~nuxeo/init.sh
rm ~nuxeo/init.sh 
