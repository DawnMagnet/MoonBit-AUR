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

# Generate PKGBUILD from template using safe delimiter |
if [ ! -f PKGBUILD.template ]; then
	echo "PKGBUILD.template not found in repository. Aborting."
	rm -rf "$tmpdir"
	exit 1
fi

# Generate PKGBUILD from template using safe delimiter |
# Only substitute the version placeholder
sed "s|__VERSION__|$version|g" PKGBUILD.template > PKGBUILD


echo "Generated PKGBUILD with version: $version revision: 1"

# Clean up
rm -rf "$tmpdir"