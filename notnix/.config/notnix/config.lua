local Config = {}

Config.pkgs = {
    "pigz",
    "zstd",
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
	"ghostty",
	"telegram-desktop",
	"neovim",
	"obs-studio",
	"git",
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

	-- optional
	"waydroid",

	"sherlock-project",

	"kvantum",

	"kernel-cachyos",
	"sbctl",
	"uksmd",
	"ananicy-cpp",
	"cachyos-settings",

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
	"com.mikrotik.WinBox",
}

Config.repos = {
	"atim/lazygit",
	"bieszczaders/kernel-cachyos-addons",
	"bieszczaders/kernel-cachyos",
	"sneexy/zen-browser",
	"chenxiaolong/sbctl",
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
