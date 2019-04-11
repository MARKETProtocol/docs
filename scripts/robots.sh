#!/usr/bin/env bash

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail;
IFS=$'\n\t';

echo "ENV_DOC: $ENV_DOC";

## create the robots file
# http://www.robotstxt.org/robotstxt.html
if [ "$ENV_DOC" = 'production' ]; then
# configure production, all access
tee ./build/robots.txt >/dev/null <<-'ENDOFTXT'
  User-agent: *
  Disallow:
  Sitemap: https://marketprotocol.io/docs_sitemap.xml
ENDOFTXT
else
# configure all else, no access
tee ./build/robots.txt >/dev/null <<-'ENDOFTXT'
  User-agent: *
  Disallow: /
ENDOFTXT
fi
