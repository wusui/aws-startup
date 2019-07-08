#
# install ocs-ci
#
echo 'Starting install'
#
# Prerequisites, Step 1
#
sudo yum -y install git wget python3
#
# Prerequisites, Step 2
#
source ./info
mkdir ~/.aws
cat <<EOF > ~/.aws/config
[default]
region=${REGION}
output=json
EOF
cat <<EOF > ~/.aws/credentials
[default]
aws_access_key_id=${AWS_ACCESS_KEY_ID}
aws_secret_access_key=${AWS_SECRET_ACCESS_KEY}
EOF
#
# Crudely get latest ocp client tar file
#
wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/
LATEST=`grep openshift-client-linux index.html | sed 's/^.*openshift-client-linux/openshift-client-linux/' | sed 's/.gz.*//'`
rm rf index.html
#
# Prerequisites, Step 3
#
wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/${LATEST}.gz
gunzip ${LATEST}
tar xvf ${LATEST}
sudo mv oc /usr/local/bin/oc
sudo mv kubectl /usr/local/bin/kubectl
#
# Installing, Step 1
#
git clone https://github.com/${MYNAME}/ocs-ci
#
# Installing, Step 2
#
cd ocs-ci
#
# Installing, Step 3
#
mkdir ~/venv
python3 -m venv ~/venv
source ~/venv/bin/activate
#
# Installing, Step 4
#
pip install --upgrade pip
#
# Installing, Step 5
#
pip install -r requirements.txt
#
# Initial Setup OCS-CI config
#
cp ocs_ci/framework/conf/default_config.yaml conf/default_config.yaml
#
# Initial Setup Pull-secret
#
mkdir data
cp ~/pull-secret data/pull-secret
chmod 0700 data/pull-secret
#
# Other stuff (set git name and email address)
#
git config --global user.name "${FULLNAME}"
git config --global user.email "${EMAIL}"
#
# Install will be something like:
#
# run-ci -m deployment --cluster-conf conf/ocs_basic_install.yml --cluster-name wusui-test --cluster-path /home/ec2-user/wusui/ --deploy --log-level=DEBUG
#
