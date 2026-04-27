{ config, pkgs, ... }:

{
  home.username = "bigyohann";
  home.homeDirectory = "/Users/bigyohann";
  home.stateVersion = "23.11";

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  home.packages = with pkgs; [
    git
    chezmoi
    bat
    jq
    fzf
    ripgrep
    fd
    eza
    ninja
    cmake
    gettext
    libtool
  ];

  programs.home-manager.enable = true;
}
