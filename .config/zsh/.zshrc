bindkey -v
zstyle :compinstall filename '/home/rasul/.config/zsh/.zshrc'
autoload -Uz compinit
compinit
autoload -Uz promptinit
promptinit
prompt walters
function precmd {
    print -Pn "\e[ q"
}

# alias
alias ls='ls --color=auto'
alias vi='nvim'
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
