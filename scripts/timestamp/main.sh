#!/bin/bash

ts=$(date -u +"%Y/%m/%d_%H:%M:%S UTC")
echo -n "$ts" | pbcopy
echo "$ts"
