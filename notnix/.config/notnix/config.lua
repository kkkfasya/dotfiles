local Config = {}

Config.pkgs = {
	"hugo",
	"easyeffects",
	"aircrack-ng",
	"audacity",
	"trivy",
	"git-delta",
	"snapper",
	"kwin-effect-roundcorners",
	"btrfs-assistant",
	"zoxide",
	"pnpm",
	"btop",
	"ruff",
	"pdfarranger",
	"distrobox",
	"git", -- git is not preinstalled in fedora lmaoo
	"libavcodec-freeworld",
	"mesa-va-drivers-freeworld",
	"bat",
	"pigz",
	"g++",
	"clang",
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
	"sherlock-project",

	"kvantum",
	"kruler",

	"kernel-cachyos",
	--"ananicy-cpp",
	"cachyos-settings",
	"scx-scheds",
	"scx-manager",

	"postgresql",
	"postgresql-contrib",

	"php",
	"php-mysqlnd",
	"php-xml",
	"php-json",
	"php-gd",
	"php-mbstring",
	"phpMyAdmin",

    -- dnf plugins
    "python3-dnf-plugin-versionlock"
}

Config.flatpaks = {
	-- "com.google.AndroidStudio",
	-- "com.jetbrains.Rider",
	"org.signal.Signal",
	"org.gnome.World.PikaBackup",
	"io.gitlab.theevilskeleton.Upscaler",
	"com.spotify.Client",
	"dev.vencord.Vesktop",
	"com.google.Chrome",
	"fm.reaper.Reaper",
	"com.voxdsp.TuxFishing",
}

Config.repos = {
	"atim/lazygit",
	"bieszczaders/kernel-cachyos-addons",
	"bieszczaders/kernel-cachyos",
	"sneexy/zen-browser",
	"chenxiaolong/sbctl",
	"pgdev/ghostty",
	"matinlotfali/KDE-Rounded-Corners",
	"zeno/scrcpy",
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
