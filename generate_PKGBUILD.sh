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

# Generate PKGBUILD from template using safe delimiter |
if [ ! -f PKGBUILD.template ]; then
	echo "PKGBUILD.template not found in repository. Aborting."
	rm -rf "$tmpdir"
	exit 1
fi

sed "s|__VERSION__|$version|g; s|__SHA1__|$sha1|g; s|__SHA2__|$sha2|g" PKGBUILD.template > PKGBUILD


echo "Generated PKGBUILD with version: $version revision: 1"
echo "sha256 of moonbit-linux-x86_64.tar.gz: $sha1"
echo "sha256 of core-latest.tar.gz: $sha2"

# Clean up
rm -rf "$tmpdir"