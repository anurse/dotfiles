# We should be inside the DOTFILES_INSTALL context
if [ "$DOTFILES_INSTALL" != "1" ]; then
    echo "This script should be run during Dotfiles Installation only!" 1>&2
    exit 1
fi

link_file "$DOTFILES_ROOT/starship/starship.toml" "$HOME/.config/starship.toml"
