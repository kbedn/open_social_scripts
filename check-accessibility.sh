#!/usr/bin/env bash

COMMAND_OR_URL=$1

if [ "$COMMAND_OR_URL" == "install" ]; then
  apt-get install -y npm libfontconfig1
  ln -s /usr/bin/nodejs /usr/bin/node
  npm cache clean -f
  npm install -g n
  n stable
  npm i -g phantomjs grunt-cli

  cd /var/www/vendor/squizlabs/html_codesniffer
  npm i
  grunt build
  cd -

  PAGES=( "/" "/explore" "/all-groups" "/community-events" "/all-topics" "/user/register" "/user/login" )
elif [ -z $COMMAND_OR_URL ]; then
  PAGES=( "/" )
else
  PAGES=( $COMMAND_OR_URL )
fi

FILE="/tmp/accessibility.html"

for PAGE in ${PAGES[@]}; do
  URL="http://localhost${PAGE}"
  echo "Checking page: ${URL}"
  curl -L $URL > $FILE
  phantomjs /var/www/vendor/squizlabs/html_codesniffer/Contrib/PhantomJS/HTMLCS_Run.js $FILE WCAG2AAA table
done
