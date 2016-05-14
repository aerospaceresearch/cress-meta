#!/bin/bash

# run all available tests at once

dir=$(dirname $0)
for testFile in $dir/*.bats; do
echo Testing file $testFile
$testFile
done
