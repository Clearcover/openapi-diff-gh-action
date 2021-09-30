#!/bin/bash -l

echo "Running openapi-diff with $1,$2,$3 args"
state_only=$3

if [ "$state_only" = 'true' ]
then
  result=$(/usr/local/openjdk-8/bin/java -jar /app/openapi-diff.jar --fail-on-incompatible --state "$1" "$2" 2>&1)
fi

echo "$result"
echo "::set-output name=openapi-diff-result::$result"