{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage. This is meant to be used by the setup script
  # If you are using it manually, please overwrite <user> with your username
  home.username = "<user>";
  home.homeDirectory = "/Users/<user>";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
  home.packages = [
    pkgs.beam.packages.erlangR24.elixir_1_12
    pkgs.postgresql_12
    pkgs.coreutils
    pkgs.git
    pkgs.gh
    pkgs.vault
    pkgs.autoconf
    pkgs.automake
    pkgs.awscli
    pkgs.curl
    pkgs.wget
    pkgs.gnupg
  ];
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  # optional for nix flakes support
  programs.direnv.nix-direnv.enableFlakes = true;
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    shellAliases = {
      pginit="initdb --no-locale --encoding=UTF-8 && pg_ctl -l \"$PGDATA/server.log\" start && createuser postgres --superuser";
      pgstart="pg_ctl -l \"$PGDATA/server.log\" start";
      pgstop="pg_ctl stop";
      pgswitch="killall postgres && pgstart";    
    };
    # workaround for nix-darwin bug
    initExtra=''
      export NIX_PATH=darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:$HOME/.nix-defexpr/channels:$NIX_PATH
      source /Users/$USER/.nix-profile/etc/profile.d/nix.sh
    '';
  };

}