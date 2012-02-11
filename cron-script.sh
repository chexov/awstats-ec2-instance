#!/bin/sh
#
. /opt/amazon/profile
. ~/.bashrc

set -ue
echo "Creating EC2 instance.."
eval "ec2-run-instances ${RUN_INSTANCE_PARAMS}"
ec2i=$(grep '^INSTANCE' /tmp/ec2ir.$$.out | awk '{ print $2}')
echo "EC2 instance ID is ${ec2i}"


status=""
hostname=""
echo "Wating for instance ${ec2i} to start..."
while [ "${status}" != "running" ]; do
   echo "Sleeping 30 secs"
   sleep 30
   ec2-describe-instances ${ec2i} | grep '^INSTANCE' > /tmp/ec2id.$$.out 2>&1
   status=$(awk '{ print $6}' /tmp/ec2id.$$.out)
done


echo "Sleeping 30 sec to let the server boot up..."
sleep 30


echo "Installing the awstats-ec2 package..."
hostname=$(awk '{ print $4 }' /tmp/ec2id.$$.out)
scp awstats-ec2-instance.tar.gz root@${hostname}:

echo "Running the AWStats EC2 Instance scripts..."
ssh root@${hostname} "tar xzf awstats-ec2-instance.tar.gz && cd awstats-ec2-instance && ./run.sh"

ec2-terminate-instances ${ec2i}

rm  /tmp/ec2ir.$$.out /tmp/ec2id.$$.out | true

