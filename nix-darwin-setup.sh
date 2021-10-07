sudo ln -s private/var/run /run

# Configure the channel
nix-channel --add https://github.com/LnL7/nix-darwin/archive/master.tar.gz darwin
nix-channel --update
export NIX_PATH=darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:$HOME/.nix-defexpr/channels:$NIX_PATH

cp ~/.nix-defexpr/darwin/modules/examples/simple.nix ~/.nixpkgs/darwin-configuration.nix

# you can also use this to rebootstrap nix-darwin in case
# darwin-rebuild is to old to activate the system.
$(nix-build '<darwin>' -A system --no-out-link)/sw/bin/darwin-rebuild build
$(nix-build '<darwin>' -A system --no-out-link)/sw/bin/darwin-rebuild switch

. ~/.zshrc