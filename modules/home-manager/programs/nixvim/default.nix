{ pkgs, ... }: {

  programs = {
    nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      extraConfigVim = ''
        syntax on
        set spell spelllang=en_us
        autocmd Filetype gitcommit set textwidth=72
      '';

      colorschemes.gruvbox.enable = true;

      plugins = {
        lualine.enable = true;

        lsp = {
          enable = true;
          servers = {
            ts_ls.enable = true;
            lua_ls.enable = true;
            rust_analyzer = {
              enable = true;
              installRustc = false;
              installCargo = false;
            };
            nil_ls.enable = true;
          };
        };

        cmp = {
          enable = true;
          autoEnableSources = true;
          settings = {
            sources = [
              { name = "nvim_lsp"; }
              { name = "path"; }
              { name = "buffer"; }
            ];
            mapping = {
              "<C-Space>" = "cmp.mapping.complete()";
              "<C-d>" = "cmp.mapping.scroll_docs(-4)";
              "<C-e>" = "cmp.mapping.close()";
              "<C-f>" = "cmp.mapping.scroll_docs(4)";
              "<CR>" = "cmp.mapping.confirm({ select = true })";
              "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
              "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            };
          };
        };

        telescope.enable = true;
        web-devicons.enable = true; # Needed by telescope
        oil.enable = true;
        treesitter.enable = true;
      };
    };
  };
}
