## What is a wrapper?
A wrapper is a script with a closure of store paths it's been told to point the untouched program at.

## What does nix-wrapper-modules do then?
Nix-wrapper-modules is a nice toolset that let's one declaratively generate the wrapper throught the NixOS module system, as opposed to using `writeShellScriptBin` or `symlinkJoin`.


