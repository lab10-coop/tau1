#!/bin/bash

set -e
set -u

VERSION="2.5.7"

BIN_LINUX="https://releases.parity.io/ethereum/v$VERSION/x86_64-unknown-linux-gnu/parity"
SHA256_LINUX="733943599b64b38f9fb580394ce7486d0d028bf3241a37e1ca59fa14c4683c79"

BIN_DARWIN="https://releases.parity.io/ethereum/v$VERSION/x86_64-apple-darwin/parity"
SHA256_DARWIN="2ca943b20350285c2bac1e8ce4747e42f5ac45b9ed5bacf58cb4b0273b70e501"

# param_1: message to be printed before exiting
function giving_up {
	echo $1
	exit 1
}

# calculates the checksum of file "parity" and compares it to the expected_checksum. Exits on mismatch.
# param_1: expected checksum
function check_integrity {
	expected_checksum=$1
	file_checksum=$(sha256sum parity | cut -f 1 -d " ")
	echo "file checksum: $file_checksum"

	if [[ $file_checksum != $expected_checksum ]]; then
		echo "### Checksum verification failed. calculated: $file_checksum | expected: $expected_checksum"
		rm parity
		giving_up ""
	fi
}

force=false
if [[ $# -eq 1 ]]; then
	if [[ $1 == "--force" ]]; then
		echo "force"
		force=true
	else
		giving_up "usage: $0 [--force]"
	fi
elif [[ $# != 0 ]]; then
	giving_up "usage: $0 [--force]"
fi
if [ -f parity ]; then
	if ! $force; then
		giving_up "A file named parity already exists in this folder. Run with argument '--force' in order to override."
	fi
fi


if [[ "$OSTYPE" == "linux-gnu" ]]; then
	echo "This looks like a Linux machine..."
	curl -f $BIN_LINUX > parity
	check_integrity $SHA256_LINUX
	chmod +x parity
elif [[ "$OSTYPE" == "darwin"* ]]; then
	echo "This looks like a Mac..."
	curl -f $BIN_DARWIN > parity
	# todo: find pre-installed tool for sha256 calc
#	check_integrity $SHA256_DARWIN
	chmod +x parity
else
	echo "### Sorry, I can't handle this platform: $OSTYPE"
	giving_up "Please manually download or build a parity binary compatible with your platform."
fi

echo
echo "Parity v$VERSION was successfully downloaded and verified!"
