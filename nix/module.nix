# nix/module.nix
{ wlib, pkgs, ... }: {
  # wlib is nix-wrapper-module's custom lib
  imports = [ wlib.wrapperModules.neovim ];

  specs.general = import ./plugins.nix pkgs;
  runtimePkgs = import ./runtime-pkgs.nix pkgs;

  settings.config_directory = ../.;
  settings.aliases = [
    "vi"
    "vim"
  ];

  wrapperVariants.vimdiff = {
    binName = "vimdiff";
    addFlag = [ "-d" ];
  };
}
