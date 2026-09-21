# nix/plugins.nix
pkgs: with pkgs.vimPlugins; [
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

]
