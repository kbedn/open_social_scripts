#!/bin/sh

REPORT=--report=summary

if [ ${1:-"summary"} = "full" ]; then
  REPORT=--report-full
fi

# Set some configurations.
# @todo add this to the Dockerfile at some point and remove the ignore flags.
/var/www/vendor/squizlabs/php_codesniffer/scripts/phpcs --config-set installed_paths /var/www/vendor/drupal/coder/coder_sniffer
/var/www/vendor/squizlabs/php_codesniffer/scripts/phpcs --config-set ignore_errors_on_exit 0
/var/www/vendor/squizlabs/php_codesniffer/scripts/phpcs --config-set ignore_warnings_on_exit 0

# Run PHP Code Sniffer.
echo "Running PHP Code Sniffer with Drupal sniffer."
/var/www/vendor/squizlabs/php_codesniffer/scripts/phpcs $REPORT --standard=Drupal --extensions=php,module,inc,install,test,profile,theme /var/www/html/profiles/contrib/social --ignore=*/node_modules/* --ignore=*.css --ignore=social.info.yml --ignore=.github/PULL_REQUEST_TEMPLATE.md

# Ignore warnings on exit for DrupalPractice.
/var/www/vendor/squizlabs/php_codesniffer/scripts/phpcs --config-set ignore_warnings_on_exit 1

# Run PHP Code Sniffer.
echo "Running PHP Code Sniffer with DrupalPractice sniffer."
/var/www/vendor/squizlabs/php_codesniffer/scripts/phpcs $REPORT --standard=DrupalPractice --extensions=php,module,inc,install,test,profile,theme /var/www/html/profiles/contrib/social --ignore=*/node_modules/* --ignore=*.css --ignore=social.info.yml --ignore=.github/PULL_REQUEST_TEMPLATE.md
