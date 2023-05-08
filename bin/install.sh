#!/bin/bash

#!/bin/bash

## region ############################################## Destination

# Allow setting of destination via prefix, verify that it's writable
destDir="/usr/local/sbin"
[ -n "$LOCAL_SBIN" ] && destDir="$LOCAL_SBIN"
if [ ! -w "$destDir" ]; then

  # Exit with error if this was specified path
  [ -n "$LOCAL_SBIN" ] && exit 1

  # Otherwise use an alternate path
  userDir=$(/usr/bin/dscl . -read /Users/"$USER" NFSHomeDirectory 2>/dev/null | /usr/bin/awk -F ': ' '{print $2}')
  if [ -z "$userDir" ] && [ -d "/Users/$USER/Desktop" ]; then
    userDir="/Users/$USER/Desktop"
  fi

  destDir="$userDir/.local/sbin"
fi

## endregion ########################################### End Destination

## region ############################################## Main Code

installed=""
if [ -f "$destDir/user-defaults" ]; then
  installed="$("$destDir/user-defaults" --version | cut -d' ' -f2)"
  if [ "$1" == "--replace" ]; then
    installed=""
    rm "$destDir/user-defaults" || exit 1
  fi
fi

repoUrl="https://github.com/jonesiscoding/user-defaults/releases/latest"
effectiveUrl=$(curl -Ls -o /dev/null -I -w '%{url_effective}' "$repoUrl")
tag=$(echo "$effectiveUrl" | /usr/bin/rev | /usr/bin/cut -d'/' -f1 | /usr/bin/rev)
[ "$tag" == "releases" ] && tag="v1.0"
if [ -n "$tag" ]; then
  # Exit successfully if same version
  [ "$tag" == "$installed" ] && exit 0
  dlUrl="https://github.com/jonesiscoding/user-defaults/archive/refs/tags/${tag}.zip"
  repoFile=$(basename "$dlUrl")
  tmpDir="/private/tmp/user-defaults/${tag}"
  [ -d "$tmpDir" ] && rm -R "$tmpDir"
  if mkdir -p "$tmpDir"; then
    if curl -Ls -o "$tmpDir/$repoFile" "$dlUrl"; then
      cd "$tmpDir" || exit 1
      if unzip -qq "$tmpDir/$repoFile"; then
        rm "$tmpDir/$repoFile"
        if cp "$tmpDir/user-defaults-${tag//v/}/src/user-defaults" "$destDir/"; then
          rm -R "$tmpDir"
          # Success - Exit Gracefully
          exit 0
        fi
      fi
    fi
  fi
fi

# All Paths that lead here indicate we couldn't install
exit 1

## endregion ########################################### End Main Code
