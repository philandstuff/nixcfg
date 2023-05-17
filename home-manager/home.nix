{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "philandstuff";
  home.homeDirectory = "/Users/philandstuff";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./emacs.nix
    ./yubikey-agent.nix
    ./replicate.nix
  ];

  launchd.enable = true;

  home.packages = [
    pkgs.csvkit
    pkgs.jq
    pkgs.shellcheck
    pkgs.watch
  ];

  programs = {
    direnv.enable = true;
    fzf.enable = true;
    starship.enable = true;

    git = {
      enable = true;
      userName = "Philip Potter";
      userEmail = "philip.g.potter@gmail.com";

      aliases = {
        st = "status -bs";
      };

      includes = [
        {
          condition = "gitdir:~/replicate/";
          contents = {
            user = {
              email = "phil@replicate.com";
            };
          };
        }
      ];
      extraConfig = {
        url = {
          "git@github.com:" = {
            pushInsteadOf = "https://github.com/";
          };
        };
        init = {
          defaultBranch = "main";
        };
        remote = {
          pushDefault = "origin";
        };
      };
    };

    zsh = {
      enable = true;
      initExtra = ''
        export PATH=$PATH:$HOME/go/bin
      '';
    };
  };
}
