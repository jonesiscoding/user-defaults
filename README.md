# macOS User Defaults (`user-defaults`)
Wrapper for macOS defaults, designed for running with admin privileges to read/write the defaults of another user while properly handling permissions and reloading of defaults to reflect and apply any changes.

## Usage

Usage remains the same as the native macOS defaults command, with the following additional flags, which may be used with a single or double dash:

| Flag      | Description                                                                                          |
|-----------|------------------------------------------------------------------------------------------------------|
| `user`    | The user to read/write the preferences with.                                                         |
| `quiet`   | Does not show error output or confirmations. In the case of a read command, only the value is shown. |
| `force`   | When writing, will ignore the existence of a Managed Preference and write the value anyway.          |
| `version` | Displays the version                                                                                 |

When using the `user` flag, written preferences are stored in the user's library unless the domain specified is an absolute path.

## Additional Conveniences

* If writing, the user's defaults are automatically reloaded.  This ensures the following:
  * The change is effective immediately.
  * The System Settings (or System Preferences) shows the updated value.
* If writing, warns about attempting to modify Managed Preferences and aborts unless `--force` flag is used
* Any boolean-like value is automatically saved as a boolean, unless a different type is specified.
  * Includes: `YES|Yes|yes|NO|No|no|TRUE|True|true|FALSE|False|false|1|0`
* A domain of `.GlobalPreferences` is automatically changed to `-g` for compatibility.

## Optional Installer Script
If your script is running as root, you can silently install the library using the 1-liner below:

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/jonesiscoding/user-defaults/HEAD/bin/install.sh)" || exit 1

The installer will check this repo for the most recent release, then if needed, download & install to `/usr/local/sbin/user-defaults`.
