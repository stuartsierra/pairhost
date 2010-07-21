## env.sh - setup local environment variables for pairhost scripts

# This script must be sourced by each script in the project. The
# current directory must be the parent of the directory containing
# this file.

EC2_API_BIN_DIR=`ls -d ec2-api-tools-*`
EC2_AMI_BIN_DIR=`ls -d ec2-ami-tools-*`

ERROR=0

if [ -z "$EC2_API_BIN_DIR" ]; then
    echo "============================================================"
    echo "ERROR: Missing ec2-api-tools-* directory."
    echo "    Download ec2-api-tools.zip from"
    echo "    http://developer.amazonwebservices.com/connect/entry.jspa?externalID=351"
    echo "    and expand it in this directory."
    ERROR=1
fi

if [ -z "$EC2_AMI_BIN_DIR" ]; then
    echo "============================================================"
    echo "ERROR: Missing ec2-ami-tools-* directory."
    echo "    Download ec2-ami-tools.zip from"
    echo "    http://developer.amazonwebservices.com/connect/entry.jspa?externalID=368"
    echo "    and expand it in this directory."
    ERROR=1
fi

if [ $ERROR == 1 ]; then exit -1; fi
