#!/bin/bash -u
# make sure you make the file executable chmod +x

if ! [ -n "${REPL_USING_RLWRAP:-}" ]; then
  # Use `rlwrap` if available.
  if which rlwrap > /dev/null 2>&1; then
    exec env REPL_USING_RLWRAP=1 rlwrap "$0" "$@"
  else
    echo 'Install `rlwrap` and re-run this script to get command history.'
  fi
fi

echo "This is the Git REPL; exit via Ctrl-D."

while true; do
  echo -n "$(pwd)> git "
  read command || break

  # A command with `!` prefix executes directly via the shell, not `git`.
  if [ "${command:0:1}" = '!' ]; then
    ${command:1}
  else
    git $command
  fi
done

# Add a blank line at the end for a clean prompt when exiting.
echo