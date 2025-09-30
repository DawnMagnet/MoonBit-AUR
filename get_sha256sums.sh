#!/bin/bash

# Create a temporary directory
tmpdir=$(mktemp -d)

# Download the first source file
curl -L https://cli.moonbitlang.cn/binaries/latest/moonbit-linux-x86_64.tar.gz -o "$tmpdir/moonbit-linux-x86_64.tar.gz"

# Download the second source file
curl -L https://cli.moonbitlang.cn/cores/core-latest.tar.gz -o "$tmpdir/core-latest.tar.gz"

# Calculate and output sha256sums for the remote files only
sha256sum "$tmpdir/moonbit-linux-x86_64.tar.gz" | cut -d' ' -f1
sha256sum "$tmpdir/core-latest.tar.gz" | cut -d' ' -f1

# Clean up the temporary directory
rm -rf "$tmpdir"
rm -rf "$tmpdir"