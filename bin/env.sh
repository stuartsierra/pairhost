## env.sh - setup local environment variables for pairhost scripts

# This script must be sourced by each script in the project. The
# current directory must be the parent of the directory containing
# this file.

# 32-bit AMI: Alestic Ubuntu 10.04 Lucid, EBS boot
AMI_32BIT="ami-3e02f257"
# 64-bit AMI: Alestic Ubuntu 10.04 Lucid, EBS boot
AMI_64BIT="ami-3202f25b"  

# Default region: U.S. East
DEFAULT_REGION="us-east-1b"

EC2_API_DIR=`ls -d ec2-api-tools-*`
EC2_AMI_DIR=`ls -d ec2-ami-tools-*`
export EC2_PRIVATE_KEY=`ls pk-*.pem`
export EC2_CERT=`ls cert-*.pem`
ID_RSA_PRIVATE_KEY=`ls id_rsa-*`
PRIVATE_KEY_NAME=`echo $ID_RSA_PRIVATE_KEY | perl -pne 's/id_rsa-//go'`
GROUP_NAME="default"

ERROR=0

if [ -z "$EC2_API_DIR" ]; then
    echo "============================================================"
    echo "ERROR: Missing ec2-api-tools-* directory."
    echo "    Download ec2-api-tools.zip from"
    echo "    http://developer.amazonwebservices.com/connect/entry.jspa?externalID=351"
    echo "    and expand it in this directory."
    ERROR=1
fi

if [ -z "$EC2_AMI_DIR" ]; then
    echo "============================================================"
    echo "ERROR: Missing ec2-ami-tools-* directory."
    echo "    Download ec2-ami-tools.zip from"
    echo "    http://developer.amazonwebservices.com/connect/entry.jspa?externalID=368"
    echo "    and expand it in this directory."
    ERROR=1
fi

if [ -z "$EC2_PRIVATE_KEY" ]; then
    echo "============================================================"
    echo "ERROR: Missing EC2 private key file."
    echo "    Get the file with a name like pk-HKZYKTAIG2ECMXYIBH3HXV4ZBZQ55CLO.pem"
    echo "    and copy it to this directory."
    ERROR=1
fi

if [ -z "$EC2_CERT" ]; then
    echo "============================================================"
    echo "ERROR: Missing EC2 certificate file."
    echo "    Get the file with a name like cert-HKZYKTAIG2ECMXYIBH3HXV4ZBZQ55CLO.pem"
    echo "    and copy it to this directory."
    ERROR=1
fi

if [ -z "$ID_RSA_PRIVATE_KEY" ]; then
    echo "============================================================"
    echo "ERROR: Missing SSH private key file"
    echo "    Get the file with a name like id_rsa-*"
    echo "    and copy it to this directory."
    echo "    The file name, minus the id_rsa- part, should match"
    echo "    the name of your generated key pair."
    ERROR=1
fi

if [ $ERROR == 1 ]; then exit -1; fi

export PATH=$EC2_API_DIR/bin:$EC2_AMI_DIR/bin:$PATH
export EC2_HOME=$EC2_API_DIR
