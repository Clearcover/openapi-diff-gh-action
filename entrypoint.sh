#!/bin/bash -l
service_name=$1
new_spec=$2
current_spec=$3
html_file="$service_name"-openapi-diff.html

state=$(/usr/local/openjdk-8/bin/java -jar /app/openapi-diff.jar --fail-on-incompatible --state "$current_spec" "$new_spec" 2>&1)

echo "::set-output name=openapi-diff-state::$state"

if ! [[ "$state" =~ ^(incompatible|compatible|no_changes)$ ]]; then
  echo "::error ::openapi-diff tool had issues performing comparison: $state"
  exit 1
fi

if [ "$state" = 'incompatible' ]
then
  echo "::warning ::Breaking/Incompatible OpenAPI changes found for $service_name!!"
fi

/usr/local/openjdk-8/bin/java -jar /app/openapi-diff.jar --fail-on-incompatible --html "$html_file" "$current_spec" "$new_spec"

echo "::set-output name=openapi-html-result::$html_file"