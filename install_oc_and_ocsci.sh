#
# install ocs-ci
#
sudo yum -y install git wget make
# INSTALL python3.7
# taken from https://tecadmin.net/install-python-3-7-on-centos/
sudo yum -y install gcc openssl-devel bzip2-devel libffi-devel
cd /usr/src
sudo wget https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tgz
sudo tar xzf Python-3.7.3.tgz
cd Python-3.7.3
sudo ./configure --enable-optimizations
sudo make altinstall
sudo rm /usr/src/Python-3.7.3.tgz
python3.7 -V
python3.7 -m venv ~/venv

#preliminary stuff done
cd ~
source ./info
REGION=${REGION:-us-east-2}
# INSTALL OC -- gets latest oc from mirror.openshift.com
source ~/venv/bin/activate
# pip install requests
#OCLIENT=`python get_oc.py`
OCLIENT=${OCLIENT:-openshift-client-linux-4.1.0-rc.5.tar.gz}
sudo wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/${OCLIENT}
sudo gunzip ${OCLIENT}
TARFILE=`echo ${OCLIENT} | sed 's/.gz$//'` 
sudo tar xvf ${TARFILE}
sudo mv oc /usr/bin/oc
sudo mv kubectl /usr/bin/kubectl

# Get ocs-ci (from my forked repo)
cd ~
git clone https://github.com/${MYNAME}/ocs-ci
cd ocs-ci
pip install -r requirements.txt

# aws setup
mkdir ~/ocs-ci/.aws
mkdir ~/ocs-ci/data

cat <<EOF > ~/.gitconfig
[user]
name = ${FULLNAME}
email = ${MYNAME}@redhat.com
EOF

cat <<EOF > ~/dot-ocs-ci-yaml
email:
   address: ${MYNAME}@redhat.com
EOF

cat <<EOF > ~/aws_config
[default]
region=${REGION}
output=json
EOF

cat <<EOF > ~/aws_credentials
[default]
aws_access_key_id=${AWS_ACCESS_KEY_ID}
aws_secret_access_key=${AWS_SECRET_ACCESS_KEY}
EOF

cp ~/dot-ocs-ci-yaml ~/.ocs-ci.yaml
cp ~/aws_config ~/ocs-ci/.aws/config
cp ~/aws_credentials ~/ocs-ci/.aws/credentials
cp ~/pull-secret ~/ocs-ci/data/pull-secret
chmod 0400 ~/ocs-ci/data/pull-secret
rm ~/dot-ocs-ci-yaml
rm ~/aws_config
rm ~/aws_credentials
rm ~/pull-secret

sudo yum install postfix mailx -y
x=`hostname -f`
sudo sed -i "s/#myhostname = virtual.domain.tld/myhostname = ${x}/" /etc/postfix/main.cf
sudo systemctl start postfix
sudo systemctl enable postfix

