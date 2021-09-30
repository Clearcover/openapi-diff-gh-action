#!/bin/bash -l

state=$(/usr/local/openjdk-8/bin/java -jar /app/openapi-diff.jar --fail-on-incompatible --state "$1" "$2" 2>&1)

echo "::set-output name=openapi-diff-state::$state"

if [ "$state" = 'incompatible' ]
then
  echo "::warning ::Breaking/Incompatible OpenAPI changes found!!"
fi

/usr/local/openjdk-8/bin/java -jar /app/openapi-diff.jar --fail-on-incompatible --html openapi-diff-results.html "$1" "$2"

echo "::set-output name=openapi-html-result::openapi-diff-results.html"