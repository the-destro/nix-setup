#!/usr/bin/env zsh
set -e
sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume --daemon
source ~/.nix-profile/etc/profile.d/nix.sh
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer && rm -Rf result
. /etc/zshrc
nix-channel --add https://github.com/nix-community/home-manager/archive/release-21.05.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

mkdir -p ~/.config/nixpkgs
cp config.nix ~/.config/nixpkgs/config.nix

cp ./darwin-configuration.nix ~/.nixpkgs

export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
export NIX_PATH=darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:$HOME/.nix-defexpr/channels:$NIX_PATH
. /etc/zshenv
echo "RUNNING REBUILD"
darwin-rebuild switch
echo "DONE"


sed s/\<user\>/$USER/g ./home.nix | tee ~/.config/nixpkgs/home.nix

home-manager switch
