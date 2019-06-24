#
# Script to copy things to an aws machine.
#
# install_oc_and_ocsci.sh installs ocs-ci when run on an aws machine.
#
# ../notes/info is a file that exports MYNAME, AWS_ACCESS_KEY_ID, and
# AWS_SECRET_ACCESS_KEY. 
#
# ../notes/pull-secret contains a pull-secret (goes in data/pull-secret).
#
source ../notes/info
IPADDR=`echo ${1} | tr '.' '-'`
REGION=${REGION:-us-east-2}
PEMFILE=${PEMFILE:-wusui.pem}
scp -i ../notes/${PEMFILE} ../notes/info ec2-user@ec2-${IPADDR}.${REGION}.compute.amazonaws.com:info
scp -i ../notes/${PEMFILE} ../notes/pull-secret ec2-user@ec2-${IPADDR}.${REGION}.compute.amazonaws.com:.
scp -i ../notes/${PEMFILE} ./install_oc_and_ocsci.sh ec2-user@ec2-${IPADDR}.${REGION}.compute.amazonaws.com:.
rm -rf ${temp1} ${temp2}
