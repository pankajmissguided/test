#!/bin/bash

shopt -s nocasematch

help () {
  echo ' This tool is to set the environment for Cypress
  it will copy distributed environment files in the /fixtures folder to the .json files required
  WARINING cp -f is used and it will overwrite existing files
  To set an environment specify with -e flag, availiable params = LOCAL, TEST, SIT
  If using test, an optional -t flag can be provided to set a specific environment e.g. -t TESTECT

  Usage exampes:
  local : ./env_config.sh -e local
  test  : ./env_config.sh -e test -t testect'
}

while getopts ":e::t::h" opt; do
  case $opt in
    e)
      echo "-e was triggered with parameter: $OPTARG"
      env=$OPTARG
      ;;
    t)
      echo "-t was triggered with parameter: $OPTARG"
      test_env=$OPTARG
      ;;
    h)
      help
      exit 1
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      echo "Running with -h"
      help
      exit 1
      ;;
    :)
      help
      exit 1
      ;;
  esac
done

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

cd "$parent_path"


copy_dist_files () {
  cp -f ./cypress/fixtures/categoryData.json.$env ./cypress/fixtures/categoryData.json
  cp -f ./cypress/fixtures/productData.json.$env ./cypress/fixtures/productData.json
  cp -f ./cypress/fixtures/websiteUrls.json.$env ./cypress/fixtures/websiteUrls.json
  cp -f ./cypress.json.$env ./cypress.json
}

set_test_env () {
  sed -i '' -e "s|sit|$test_env|g" ./cypress/fixtures/websiteUrls.json
  sed -i '' -e "s|sit|$test_env|g" ./cypress.json
}

case $env in
test)
  echo 'setting fixture date for TEST'
  copy_dist_files
  if [[ -n "$test_env" ]];
  then
    echo "seting test env to $test_env"
    set_test_env
  else
    echo 'no test env set, default = SIT
    if a specific test env is required, use -t
    example : ./env_config.sh -e test -t testect'
  fi
;;
local)
  echo 'setting fixture data for LOCAL'
  copy_dist_files
;;
sit)
  echo 'setting fixture data for SIT'
  copy_dist_files
;;
*)
echo '-e flag does not match a valid environment!'
echo 'Please specify an environment'
echo 'LOCAL, TEST, SIT'
;;
esac
