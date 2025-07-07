# ENV VARIABLE
set -gx PATH $HOME/usr/local/go/bin $PATH # GOROOT i assume?
set -gx PATH $HOME/.local/bin $PATH
set -gx PATH $HOME/.cargo/bin $PATH
set -gx PATH $HOME/.bun/bin $PATH
set -gx PATH $HOME/.local/share/pnpm $PATH
set -gx PATH $HOME/.local/bin/flutter-dev/bin $PATH
set -gx PATH $HOME/.local/bin/phpenv/bin $PATH

set -gx GOPATH $HOME/.local/go
set -gx GOBIN $GOPATH/bin
set -gx PATH $GOBIN $PATH

set -gx BUN_INSTALL $HOME/.bun
set -gx ZSH $HOME/.oh-my-zsh
set -gx NVM_DIR $HOME/.nvm

set -gx FZF_DEFAULT_OPTS "--tmux center --info=inline --margin=1 --padding=1"
set -gx DESKTOP_ENTRY "~/.local/share/applications/"
set -gx BAT_THEME gruvbox-dark

# Remove all dup path, yes i know it's preferred to use fish_add_path but fuck it
set -gx PATH (printf "%s\n" $PATH | sort -u)
set -gx LC_ALL en_US.UTF-8

if test $SSH_CONNECTION
    set -gx EDITOR vi
else
    set -gx EDITOR nvim
end

set -U fish_prompt_pwd_dir_length 0

# ALIAS
# alias code="code --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform-hint=auto"

zoxide init fish | source

alias pkg='nvim ~/.config/notnix/config.lua'
alias t='tmux attach || tmux'
alias tks='tmux kill-server'
alias l='ls -alFh'
alias cpudebug='sudo auto-cpufreq --debug'
alias note='nvim $HOME/NOTES/notes.md'
alias lks='nvim $HOME/NOTES/done.md'
alias notes='nvim $HOME/NOTES/notes.md'
alias sudo='sudo '

alias gls='git ls-files'
alias ga='git add .'
alias gs='git status'
alias gwip ='git commit -m "work in progress"'

alias spkg='sudo dnf search '
alias :q='exit'
alias wcc='warp-cli connect'
alias wdc='warp-cli disconnect'
alias ll='ls -alFh'
alias icat='kitten icat'
alias ez='nvim ~/.zshrc'
alias ef='nvim ~/.config/fish/config.fish'
alias fm='nautilus'
alias cat='bat'
# alias cal='ncal -C'
alias ffd='cd "$(fd -t d . $HOME | fzf)"'
alias cd="z"
alias qd='cd "$(fd -t d . | fzf)"'
alias eb='nvim ~/.bashrc'
alias sb='source ~/.bashrc'
alias sz='source ~/.zshrc'
alias sf='source ~/.config/fish/config.fish'
alias ts='tmux source ~/.config/tmux/tmux.conf'
alias c='clear'
alias ytdl='youtube-dl'
alias eiv='nvim ~/.config/nvim/init.lua'
alias clipb='xsel -i -b'
alias vim='nvim'
alias virtualenv='python3 -m virtualenv'
alias ocd='cd "$dirprev[-1]"'
alias cp='cp -i -v'
alias mv='mv -i -v'
alias rm='trash -v'
alias mkdir='mkdir -p -v'
alias ping='ping -c 10'
alias less='less -R'
alias multitail='multitail --no-repeat -c'
alias cpd='pwd | tr -d "\n" | xsel -i -b'
alias copydir='pwd | tr -d "\n" | xsel -i -b'
alias cd..='cd ..'

# KEYBINDING || MAPPING
bind --key btab true

bind \e\[Z forward-bigword
bind \cF complete-and-search

#this is for kitty, apparently ghostty handle shortcut input differently
bind shift-tab forward-bigword
bind ctrl-f complete-and-search

#this is for tmux
bind --key btab forward-bigword

# FUNCTIONS
function bonsai -a text --description "Display bonsai, with my preference"
    cbonsai -S -t 0.125 -m $text
end

function @note
    doctoc "$HOME/NOTES/notes.md"
    markdown-it "$HOME/NOTES/notes.md" > "/tmp/notes.html"
    xdg-open "/tmp/notes.html"
end

function @lks
    doctoc "$HOME/NOTES/done.md"
    markdown-it "$HOME/NOTES/done.md" > "/tmp/done.html"
    xdg-open "/tmp/done.html"
end

function gl --description "pretty git log"
    git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'
end

function tnew -a session_name --description "new Tmux session with name"
    tmux new -s "$session_name"
end

function ta -a session_name --description "attach to named session"
    tmux a -t "$session_name"
end

function tk -a session_name --description "kill named session"
    tmux kill-session -t "$session_name"
end

function fish_fmt -a file_name --description "Fish formatter"
    fish_indent -w $file_name
end

function @compress -a filename folder --description "Compress with zstd"
    tar -v \
        --use-compress-program "zstd --threads=12 -13" \
        --create \
        --file $filename $folder
end

function @decompress -a filename folder --description "Decompress with zstd"
    tar --use-compress-program=unzstd -xvf $filename
end

function bind_bang
    switch (commandline --current-token)[-1]
    case "!"
        # Without the `--`, the functionality can break when completing
        # flags used in the history (since, in certain edge cases
        # `commandline` will assume that *it* should try to interpret
        # the flag)
        commandline --current-token -- $history[1]
        commandline --function repaint
    case "*"
        commandline --insert !
    end
end

function fish_user_key_bindings
    bind ! bind_bang
end

function @qrcode --description 'Generate a QR code; use -p or --png for PNG output']
    argparse p/png -- $argv
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
   curl -F"shorten=$url" https://envs.sh
end


# MISC
set -g fish_greeting
set fish_cursor_default block

if status is-interactive
    fastfetch -l pacbsd
    ~/scripts/./days.sh
    # Commands to run in interactive sessions can go here
end

# pnpm
set -gx PNPM_HOME "/home/ovhell/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
