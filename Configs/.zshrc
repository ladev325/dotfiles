export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    docker
    sudo
)

source $ZSH/oh-my-zsh.sh

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

PROMPT="  %{$fg[cyan]%}%c%{$reset_color%} "

apply_wal_colors() {
    cat ~/.cache/wal/sequences 2>/dev/null
    #printf '\033]11;#181825\007' # custom background
}
apply_wal_colors > /dev/tty
precmd() { apply_wal_colors }


if [[ "$FASTFETCH_LOGO" == "0" ]]; then
    #fastfetch
    fastfetch --logo $(find ~/.config/fastfetch/images -name '*.png' -o -name '*.jpg' | shuf -n 1)
fi

if [[ "$FASTFETCH_LOGO" == "1" ]]; then
    #fastfetch
    fastfetch --logo $(find ~/.config/fastfetch/logos -name '*.txt' | shuf -n 1)
fi
