pkgs:
{
  enable = true;
  vimAlias = true;
  extraConfig = ''
    luafile /home/jrgiacone/.config/nvim/lua/treesitter.lua
    luafile /home/jrgiacone/.config/nvim/lua/settings.lua
    luafile /home/jrgiacone/.config/nvim/lua/nvimtree.lua
    luafile /home/jrgiacone/.config/nvim/lua/whichkey.lua
    luafile /home/jrgiacone/.config/nvim/lua/toggleterm.lua
    luafile /home/jrgiacone/.config/nvim/lua/bufferline.lua
    luafile /home/jrgiacone/.config/nvim/lua/keymaps.lua
    luafile /home/jrgiacone/.config/nvim/lua/telescope.lua
    luafile /home/jrgiacone/.config/nvim/lua/dashboard.lua
  '';

  plugins = with pkgs.vimPlugins; [
    nvim-treesitter.withAllGrammars
    nord-vim
    indent-blankline-nvim
    nvim-web-devicons
    nvim-tree-lua
    which-key-nvim
    telescope-nvim
    telescope-fzf-native-nvim
    bufferline-nvim
    dashboard-nvim
    telescope-file-browser-nvim
    toggleterm-nvim
    lazygit-nvim
    vim-nix
  ];
}
