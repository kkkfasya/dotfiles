local confdir = debug.getinfo(1, "S").source:sub(2):match("^(.-notnix[/\\])")
package.path = ("%s;%s/?.lua;%s/modules/?.lua"):format(package.path, confdir, confdir)

local Config = {}

Config.pkgs = {
	"chafa",
	"telegram-desktop",
	"pandoc",
	"steam",
	"uncrustify",
	"tito",
	"kdenlive",
	"alsa-tools",
	"pavucontrol",
	"qpwgraph",
	"elisa-player",
	"qt5ct",
	"qt6ct",
	"meson",
	"difftastic",
	"wev",
	"wlsunset",
	"quickshell",
	"brightnessctl",
	"niri",
	"cava",
	"mpv",
	"haruna",
	"hugo",
	"scrcpy",
	"easyeffects",
	"audacity",
	"trivy",
	"git-delta",
	"snapper",
	"btrfs-assistant",
	"zoxide",
	"pnpm",
	"btop",
	"ruff",
	"pdfarranger",
	"distrobox",
	"git",
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
	"code",

	"kvantum",
	"kruler",

	"postgresql",
	"postgresql-contrib",

	-- NOTE: must be put at the end otherwise wouldn't return all
	-- iterables items because fuck you and fuck lua and fuck prabowo
	require("util").add_module({
		require("modules.dotnet"),
		require("modules.php"),
		require("modules.dnf-plugins"),
		require("modules.cachyos"),
		require("modules.qemu"),
	}),
}

Config.flatpaks = {
	-- "com.google.AndroidStudio",
	-- "com.jetbrains.Rider",
	"org.localsend.localsend_app",
	"net.agalwood.Motrix",
	"org.jousse.vincent.Pomodorolm",
	"dev.bragefuglseth.Fretboard",
	"com.github.tchx84.Flatseal",
	"org.signal.Signal",
	"org.gnome.World.PikaBackup",
	"io.gitlab.theevilskeleton.Upscaler",
	"com.spotify.Client",
	"dev.vencord.Vesktop",
	"com.google.Chrome",
	"fm.reaper.Reaper",
	"us.zoom.Zoom",
	"com.brave.Browser",
	"org.onlyoffice.desktopeditors",
}

Config.repos = {
	"yalter/niri",
	"errornointernet/quickshell",
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
