#!/bin/sh
set -x

chmod +x $PWD/awstats-7.0/tools/awstats_updateall.pl $PWD/awstats-7.0/wwwroot/cgi-bin/awstats.pl

$PWD/awstats-7.0/tools/awstats_updateall.pl now \
  -configdir="$PWD/etc/awstats"  \
  -awstatsprog=$PWD/awstats-7.0/wwwroot/cgi-bin/awstats.pl \
  2>&1
exit 0

