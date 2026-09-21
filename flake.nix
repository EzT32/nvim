{
  description = "Root flake for repository";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    nix-wrapper-modules = {
      url = "github:nix-community/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-wrapper-modules,
    }:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = nix-wrapper-modules.lib.evalPackage [
            (
              { wlib, ... }:
              {
                imports = [ wlib.wrapperModules.neovim ];

                specs.general = with pkgs.vimPlugins; [
                  nvim-lspconfig
                  (nvim-treesitter.withPlugins (
                    p: with p; [
                      lua
                      nix
                      bash
                      vhdl
                      asm
                      python
                      c
                      java
                    ]
                  ))

                  telescope-nvim
                  plenary-nvim

                  neodev-nvim

                  gruvbox-nvim
                  lualine-nvim

                  indent-blankline-nvim
                  comment-nvim

                  conform-nvim

                  nvim-cmp
                  cmp-nvim-lsp
                  cmp-buffer
                  cmp-path
                  luasnip
                  cmp_luasnip

                ];

                runtimePkgs = with pkgs; [
                  lua-language-server
                  stylua
                  luaPackages.luacheck

                  nil
                  statix

                  wl-clipboard

                  vhdl-ls
                  ghdl

                  asm-lsp
                  asmfmt

                  pyright
                  black

                  clang-tools

                  jdt-language-server
                ];

                settings.config_directory = ./.;
                settings.aliases = [
                  "vi"
                  "vim"
                ];

                wrapperVariants.vimdiff = {
                  binName = "vimdiff";
                  addFlag = [ "-d" ];
                };
              }
            )
            { inherit pkgs; }
          ];
        }
      );
    };
}
