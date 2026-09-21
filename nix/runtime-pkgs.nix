# nix/runtime-packages.nix
pkgs: with pkgs; [
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
]
