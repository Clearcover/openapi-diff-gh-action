#!/bin/bash -l

echo "Running openapi-diff with $1,$2,$3 args"

state=$(/usr/local/openjdk-8/bin/java -jar /app/openapi-diff.jar --fail-on-incompatible --state "$1" "$2" 2>&1)

echo "$state"
echo "::set-output name=openapi-diff-state::$state"

if [ "$state" = 'incompatible' ]
then
  echo "::warning ::Breaking/Incompatible OpenAPI changes found!!"
fi

pwd
/usr/local/openjdk-8/bin/java -jar /app/openapi-diff.jar --fail-on-incompatible --html openapi-diff-results.html "$1" "$2"
ls -l *.html