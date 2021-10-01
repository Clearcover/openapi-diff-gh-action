#!/bin/bash -l
service_name=$1
new_spec=$2
current_spec=$3
html_file="$service_name"-openapi-diff.md

state=$(/usr/local/openjdk-8/bin/java -jar /app/openapi-diff.jar --fail-on-incompatible --state "$current_spec" "$new_spec" 2>&1)

echo "::set-output name=diff-state::$state"

if ! [[ "$state" =~ ^(incompatible|compatible|no_changes)$ ]]; then
  echo "::error ::openapi-diff tool had issues performing comparison, error follows: $state"
  exit 1
fi

if [ "$state" = 'incompatible' ]
then
  echo "::warning ::Breaking/Incompatible OpenAPI changes found for $service_name!!"
fi

/usr/local/openjdk-8/bin/java -jar /app/openapi-diff.jar --fail-on-incompatible --markdown "$html_file" "$current_spec" "$new_spec"

echo "::set-output name=diff-html-result::$html_file"