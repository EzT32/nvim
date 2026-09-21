# nix/module.nix
{
  pkgs,
  self,
  wlib,
  ...
}:
{
  # wlib is nix-wrapper-module's custom lib
  imports = [ wlib.wrapperModules.neovim ];

  specs.general = import ./plugins.nix pkgs;
  runtimePkgs = import ./runtime-pkgs.nix pkgs;

  settings.config_directory = self;
  settings.aliases = [
    "vi"
    "vim"
  ];

  wrapperVariants.vimdiff = {
    binName = "vimdiff";
    addFlag = [ "-d" ];
  };
}
