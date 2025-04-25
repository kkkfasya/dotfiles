local Config = {}

Config.pkgs = {
    "distrobox",
    "git", -- git is not preinstalled in fedora lmaoo
    "libavcodec-freeworld",
    "mesa-va-drivers-freeworld",
    "bat",
    "pigz",
    "g++",
    "zstd",
    "cmake",
    "extra-cmake-modules",
    "ninja-build",
    "nginx",
    "fd-find",
    "fzf",
    "ripgrep",
    "gh",
    "rustup",
    "hwinfo",
    "qrencode",
    "fastfetch",
    "openssh",
    "awscli",
    "unrar",
    "tmux",
    "trash-cli",
    "ocrmypdf",
    "fish",
    "zen-browser",
    "gitui",
    "lazygit",
    "torbrowser-launcher",
    "tor",
    "neovim",
    "obs-studio",
    "vlc",
    "qbittorrent",
    "picard",
    "kitty",
    "xxd",
    "uv",
    "flameshot",
    "docker",
    "docker-compose",

    "golang",
    "code",

    -- optional
    "waydroid",

    "sherlock-project",

    "kvantum",
    "kruler",

    "kernel-cachyos",
    "sbctl",
    "ananicy-cpp",
    "cachyos-settings",
    "scx-scheds",

    "postgresql",
    "postgresql-contrib",

    "php-mysqlnd",
    "php-xml",
    "php-json",
    "php-gd",
    "php-mbstring",
    "phpMyAdmin",
}

Config.flatpaks = {
    -- "com.google.AndroidStudio",
    -- "com.jetbrains.Rider",
    "org.signal.Signal",
    "org.gnome.World.PikaBackup",
    "io.gitlab.theevilskeleton.Upscaler",
    "org.upscayl.Upscayl",
    "com.spotify.Client",
    "dev.vencord.Vesktop",
}

Config.repos = {
    "atim/lazygit",
    "bieszczaders/kernel-cachyos-addons",
    "bieszczaders/kernel-cachyos",
    "sneexy/zen-browser",
    "chenxiaolong/sbctl",
    "pgdev/ghostty",
}

Config.install = "sudo dnf install"
Config.remove = "sudo dnf remove"
Config.upgrade = "sudo dnf upgrade"

Config.add_repo = "sudo dnf copr enable"
Config.remove_repo = "sudo dnf copr remove"
Config.update_cache = "sudo dnf mc"

Config.assume_yes_install = true
Config.assume_yes_remove = true

return Config
