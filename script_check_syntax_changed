#!/bin/bash
set -e
set -u
# This is a simple script that will check the syntax of changed ruby files.
# It can be used as a git hook, to enable it copy the script to
# .git/hooks/pre-commit and ensure it has exec permissions

root=$(git rev-parse --show-toplevel)
check=$root/check_syntax.sh
exec 1>&2 # redir output to stderr

cleanup() {
    rm -rf $tmpdir
}

tmpdir=$(mktemp -d -t ops)
# be sure to remove files on exit
trap cleanup EXIT

for file in `git diff --cached --name-only HEAD --diff-filter=ACM`; do
    [[ $file == *.rb ]] || continue
    bname=$(basename $file)
    cp $file $tmpdir/$bname
    $check $tmpdir/$bname $file || exit 1
done

