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
# get_oc.py is a python 3 script that gets the latest version of the oc
# files that got built.
#
source ../notes/info
IPADDR=`echo ${1} | tr '.' '-'`
REGION=${REGION:-us-east-2}
PEMFILE=${PEMFILE:-aardvark.pem}
temp1=`mktemp`
temp2=`mktemp`
x=`python3 get_oc.py`
echo "export OCLIENT='${x}'" > ${temp1}
cat ../notes/info ${temp1} > ${temp2}
scp -i ../notes/${PEMFILE} ${temp2} ec2-user@ec2-${IPADDR}.${REGION}.compute.amazonaws.com:info
scp -i ../notes/${PEMFILE} ../notes/pull-secret ec2-user@ec2-${IPADDR}.${REGION}.compute.amazonaws.com:.
scp -i ../notes/${PEMFILE} ../aws_helper/install_oc_and_ocsci.sh ec2-user@ec2-${IPADDR}.${REGION}.compute.amazonaws.com:.
rm -rf ${temp1} ${temp2}
