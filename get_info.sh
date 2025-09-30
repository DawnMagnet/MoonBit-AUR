#!/bin/bash

# Create a temporary directory
tmpdir=$(mktemp -d)

# Download the moonbit tar.gz file
curl -L https://cli.moonbitlang.cn/binaries/latest/moonbit-linux-x86_64.tar.gz -o "$tmpdir/moonbit-linux-x86_64.tar.gz"

# Extract the tar.gz file
tar -xzf "$tmpdir/moonbit-linux-x86_64.tar.gz" -C "$tmpdir"

# Get the version number
chmod +x "$tmpdir/bin/moon"
version=$(cd "$tmpdir" && ./bin/moon version | grep 'moon ' | sed 's/.*moon \([0-9.]*\).*/\1/')

# Download the core tar.gz file
curl -L https://cli.moonbitlang.cn/cores/core-latest.tar.gz -o "$tmpdir/core-latest.tar.gz"

# Calculate sha256sums
sha1=$(sha256sum "$tmpdir/moonbit-linux-x86_64.tar.gz" | cut -d' ' -f1)
sha2=$(sha256sum "$tmpdir/core-latest.tar.gz" | cut -d' ' -f1)

# Output version and sha256sums
echo "$version"
echo "$sha1 $sha2"

# Replace placeholders in PKGBUILD
sed -i "s/__VERSION__/$version/g" PKGBUILD
sed -i "s/__SHA256SUM__/$sha1 $sha2/g" PKGBUILD

# Clean up the temporary directory
rm -rf "$tmpdir"