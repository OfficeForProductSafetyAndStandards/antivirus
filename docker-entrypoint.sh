#!/usr/bin/env bash
set -ex

# Ensure all gems are installed.
bundle check || bundle install

# Download initial virus signature files which are required before starting the ClamAV daemon
freshclam

# Start ClamAV and keep virus signature files up to date
freshclam -d &
clamd &

ruby server.rb
