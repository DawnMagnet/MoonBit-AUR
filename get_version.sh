#!/bin/bash

# Create a temporary directory
tmpdir=$(mktemp -d)

# Download the tar.gz file to the tmp directory
curl -L https://cli.moonbitlang.cn/binaries/latest/moonbit-linux-x86_64.tar.gz -o "$tmpdir/moonbit-linux-x86_64.tar.gz"

# Extract the tar.gz file
tar -xzf "$tmpdir/moonbit-linux-x86_64.tar.gz" -C "$tmpdir"

# Get the version number using the specified command
chmod +x "$tmpdir/bin/moon"
version=$(cd "$tmpdir" && ./bin/moon version | grep 'moon ' | sed 's/.*moon \([0-9.]*\).*/\1/')

# Output the version to stdout
echo "$version"

# Clean up the temporary directory
rm -rf "$tmpdir"