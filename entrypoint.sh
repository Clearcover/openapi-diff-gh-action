#!/bin/bash -l
service_name=$1
new_spec=$2
current_spec=$3
html_file="$service_name"-openapi-diff.html

echo "::debug ::service_name = $service_name , new_spec = $new_spec , current_spec = $current_spec, html_file = $html_file"

state=$(/usr/local/openjdk-8/bin/java -jar /app/openapi-diff.jar --fail-on-incompatible --state "$current_spec" "$new_spec" 2>&1)

echo "::debug $state"

echo "::set-output name=openapi-diff-state::$state"

if [ "$state" = 'incompatible' ]
then
  echo "::warning ::Breaking/Incompatible OpenAPI changes found for $service_name!!"
fi

/usr/local/openjdk-8/bin/java -jar /app/openapi-diff.jar --fail-on-incompatible --html "$html_file" "$current_spec" "$new_spec"

echo "::set-output name=openapi-html-result::$html_file"