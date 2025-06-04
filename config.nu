# Simple command aliases (still valid)
alias cd = zoxide
alias pkg = nvim ~/.config/notnix/config.lua
alias tks = tmux kill-server
alias l = ls -alh
alias cpudebug = sudo auto-cpufreq --debug
alias sudo = sudo 
alias gls = git ls-files
alias spkg = sudo dnf search
alias :q = exit
alias wcc = warp-cli connect
alias wdc = warp-cli disconnect
alias ll = ls -alh
alias icat = kitten icat
alias ez = nvim ~/.zshrc
alias ef = nvim ~/.config/fish/config.fish
alias fm = nautilus
alias cat = bat
alias eb = nvim ~/.bashrc
alias c = clear
alias ytdl = youtube-dl
alias eiv = nvim ~/.config/nvim/init.lua
alias clipb = xsel -i -b
alias vim = nvim
alias virtualenv = python3 -m virtualenv
alias cp = cp -i -v
alias mv = mv -i -v
alias rm = trash -v
alias mkdir = mkdir -v
alias ping = ping -c 10
alias less = less -R
alias multitail = multitail --no-repeat -c
alias cd.. = cd ..

# Convert these to functions
def t [] {
    do {
        tmux attach
    } catch {
        tmux
    }
}

def ffd [] {
    let dir = (fd -t d . $nu.home-path | fzf)
    if $dir != "" {
        cd $dir
    }
}

def qd [] {
    let dir = (fd -t d . | fzf)
    if $dir != "" {
        cd $dir
    }
}

def ocd [] {
    if ($env.dirprev? | is-some) {
        cd ($env.dirprev | last)
    }
}

def cpd [] {
    pwd | str trim | xsel -i -b
}

def copydir [] {
    pwd | str trim | xsel -i -b
}
