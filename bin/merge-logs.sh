#!/bin/sh
[ $# -eq 1 ] || { echo "Usage: $0 <logs folder>"; exit 1; }
set -ue
FOLDER=$1

TODAY=$(date "+%s")
YESTERDAY=$(expr ${TODAY} - 86400)

DATE=$(date -u --date "1970-01-01 00:00:00 ${TODAY} sec" "+%Y-%m-%d")
DATE_YESTERDAY=$(date -u --date "1970-01-01 00:00:00 ${YESTERDAY} sec" "+%Y-%m-%d")

LOGDIR=${PWD}/logs/

# Removing empty files, so zcat will not exit with error
find ${LOGDIR}/${FOLDER}/ -type f -size 0k | xargs -r rm

# There are two type of files. CloudFront logs and S3 logs.
# Checking one by one
find ${LOGDIR}/${FOLDER}/ -type f -name \*${DATE_YESTERDAY}\*.gz | sort > /tmp/filelist.$$
[ -s /tmp/filelist.$$ ] && { cat /tmp/filelist.$$ | xargs -r zcat; exit; }

find ${LOGDIR}/${FOLDER}/ -type f -name \*${DATE_YESTERDAY}\* | sort > /tmp/filelist.$$
[ -s /tmp/filelist.$$ ] && { cat /tmp/filelist.$$ | xargs -r cat; exit; }

rm /tmp/filelist.$$

