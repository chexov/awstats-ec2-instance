#!/bin/sh
[ $# -eq 2 ] || { echo "Usage: $0 s3://bucket/prefix <destination folder>"; exit 1; }
set -xue
S3PATH=$1
DEST=$2

TODAY=$(date "+%s")
YESTERDAY=$(expr ${TODAY} - 86400)

DATE=$(date -u --date "1970-01-01 00:00:00 ${TODAY} sec" "+%Y-%m-%d")
DATE_YESTERDAY=$(date -u --date "1970-01-01 00:00:00 ${YESTERDAY} sec" "+%Y-%m-%d")

[ -d "${DEST}" ] || mkdir "${DEST}"
#LOGFILTER="${S3PATH}${DATE}"
#s3cmd -c /home/backup/.s3cfg sync ${LOGFILTER} ${DEST} --include="*${DATE}*" --skip-existing --no-progress

LOGFILTER="${S3PATH}${DATE_YESTERDAY}"
s3cmd -c ./etc/s3cfg sync ${LOGFILTER} ${DEST}  --skip-existing --no-progress

