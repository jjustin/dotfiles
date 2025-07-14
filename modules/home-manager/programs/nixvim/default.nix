{ pkgs, ... }:
{

  programs = {
    nixvim = {
      # https://nix-community.github.io/nixvim/NeovimOptions/index.html
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

      diagnostic.settings = {
        # NOTE: Opt-in with 0.11
        virtual_lines = true; # for lsp-lines
      };

      plugins = {
        lualine.enable = true;

        lsp-format.enable = true;

        lsp = {
          enable = true;
          servers = {
            # Typescript
            ts_ls.enable = true;
            # Lua
            lua_ls.enable = true;
            # Golang
            golangci_lint_ls.enable = true;
            gopls.enable = true;

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

        hardtime.enable = true; # Bad habit notifications

        # TODO: figure this out.
        # LSP-enabled preview
        goto-preview = {
          enable = true;
        };

        # in-line LSP error reporting
        lsp-lines.enable = true;

        telescope.enable = true; # Fuzzy search
        web-devicons.enable = true; # Needed by telescope
        oil.enable = true;
        treesitter.enable = true;
      };
    };
  };
}
