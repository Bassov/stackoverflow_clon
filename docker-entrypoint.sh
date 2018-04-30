#!/bin/bash
set -e
# cd ./services/content

bin/setup
bundle exec foreman start
