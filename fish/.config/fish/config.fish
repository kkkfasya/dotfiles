fastfetch
# ~/scripts/./days.sh


# ENV VARIABLE
set -gx BUN_INSTALL "$HOME/.bun"
set -gx ZSH "$HOME/.oh-my-zsh"
set -gx NVM_DIR "$HOME/.nvm"
set -gx PATH $PATH:/usr/local/go/bin
set -gx PATH $PATH:~/.local/bin
set -gx PATH $PATH:~/.cargo/bin
set -gx PATH $BUN_INSTALL/bin:$PATH

set -gx PIP_BREAK_SYSTEM_PACKAGES 1


set -gx FZF_DEFAULT_OPTS "--tmux center --info=inline --margin=1 --padding=1"
set -gx DESKTOP_ENTRY "~/.local/share/applications/"

set -gx BAT_THEME gruvbox-dark
set -gx PNPM_HOME "$HOME/.local/share/pnpm"

# Remove all dup path, yes i know it's preferred to use fish_add_path but fuck it
set -gx PATH (printf "%s\n" $PATH | sort -u)


if test $SSH_CONNECTION
    set -gx EDITOR vi
else
    set -gx EDITOR nvim
end

set -U fish_prompt_pwd_dir_length 0


# ALIAS
alias pkg='nvim ~/.config/notnix/config.lua'

alias sudo='sudo '
alias gce='git checkout $(git branch | fzf)'
alias spkg='sudo dnf search '
alias :q='exit'
alias wcc='warp-cli connect'
alias wdc='warp-cli disconnect'
alias tmuxks='tmux kill-server'
alias tmuxa='tmux a '
alias ll='ls -alFh'
alias icat='kitten icat'
alias cat='bat'
alias ez='nvim ~/.zshrc'
alias ef='nvim ~/.zshrc'
alias fm='nautilus'
# alias cal='ncal -C'
alias ffd='cd "$(fd -t d . $HOME | fzf)"'
alias qd='cd "$(fd -t d . | fzf)"'
alias eb='nvim ~/.bashrc'
alias sb='source ~/.bashrc'
alias sz='source ~/.zshrc'
alias ts='tmux source ~/.config/tmux/tmux.conf'
alias c='clear'
alias ytdl='youtube-dl'
alias eiv='nvim ~/.config/nvim/init.vim'
alias clipb='xsel -i -b'
alias vim='nvim'
alias virtualenv='python3 -m virtualenv'
alias ocd='cd "$OLDPWD"'
alias cp='cp -i -v'
alias mv='mv -i -v'
alias rm='trash -v'
alias mkdir='mkdir -p -v'
alias ping='ping -c 10'
alias less='less -R'
alias multitail='multitail --no-repeat -c'
alias cpd='pwd | tr -d "\n" | xsel -i -b'
alias cd..='cd ..'


# FUNCTIONS

function bonsai -a text --description "Display bonsai, with my preference"
     cbonsai -S -t 0.125 -m $text
 end


function @qrcode --description 'Generate a QR code; use -p or --png for PNG output']
    argparse 'p/png' -- $argv 
    or return 

    # Check if an argument (the data to encode) was provided
    if test (count $argv) -eq 0
        echo "[ERROR]: Please provide a string to qr-encode"
        return 1
    end

    # Store the input string
    set input $argv[1]

    if set -q _flag_png
        set output_file "qrcode_"(date +%s)".png"
        qrencode -o $output_file "$input"
        echo "QR code saved as $output_file"
    else
        qrencode -t ANSI "$input"
    end
end

function @url_short --description 'Shorten a URL'

    if test (count $argv) -eq 0
        echo "Error: Please provide a URL to shorten."
        return 1
    end

    # Check if the string starts with https:// and add it if missing
    if string match 'https://*' "$input"
        set url $argv[1]
    else
        set url "https://$argv[1]"
    end

    # Send the URL to the shortening service
    curl -F"shorten=$url" https://envs.sh
end



# MISC
set -g fish_greeting

if status is-interactive
    # Commands to run in interactive sessions can go here
end
