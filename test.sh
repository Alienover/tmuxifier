#! /usr/bin/env bash

resolve_link() {
  $(type -p greadlink readlink | head -1) $1
}

abs_dirname() {
  local cwd="$(pwd)"
  local path="$1"

  while [ -n "$path" ]; do
    cd "${path%/*}"
    local name="${path##*/}"
    path="$(resolve_link "$name" || true)"
  done

  pwd
  cd "$cwd"
}


testdir="$(abs_dirname "$0")/test"
testfiles="$(find "$testdir" -name "*-test.sh")"

RET=0
for testfile in $testfiles; do
  echo ""
  echo -en "\033[0;35mrunning: "
  echo -e "\033[0;36m${testfile/#$(dirname "$testdir")\//}\033[0m"
  cd "$(dirname "$testfile")"
  "$testfile"
  if [ "$?" != "0" ]; then RET=1; fi
done
echo ""
exit $RET
