# AWS_HELPER

This directory contains a small helper script to install the openshift
environment on an ec2 cluster.

It assumes that the directory ../notes exists and contains the following files:

* info -- a set of bash export lines that define variables needed
* pull-secret -- a copy of the pull secret

I also find it convenient to keep a copy of my pem file in notes.

The info file will look like (change values to suit your needs):

```
export MYNAME='imontoya'
export FULLNAME='Inigo Montoya'
export AWS_ACCESS_KEY_ID='something'
export AWS_SECRET_ACCESS_KEY='something-else'
```

Once you have an ec2 machine up, run the following (where W.X.Y.Z is the
ip4 address used by the ec2 machine):

```
./helper.sh W.X.Y.Z
```

After that, ssh to the ec2 machine and in ec2-user's home directory, run:

```
./install_oc_and_ocsci.sh
```

