#!/bin/sh -l

echo "Running openapi-diff with $1 and $2 args"
result=$(java -jar /app/openapi-diff.jar $1 $2 2>&1)
echo $result
echo "::set-output name=openapi-diff-result::$result"