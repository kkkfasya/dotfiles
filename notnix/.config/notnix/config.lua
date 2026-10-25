local confdir = debug.getinfo(1, "S").source:sub(2):match("^(.-notnix[/\\])")
package.path = ("%s;%s/?.lua;%s/modules/?.lua"):format(package.path, confdir, confdir)

local Config = {}

Config.pkgs = {
	-- what the fuck are these name bro, linux dev shouldn't name software
	"grim",
	"slurp",

	"nix",
	"zsync",

	"rclone",
	"noctalia",

	"sshfs",
	"golang",
	"nodejs24",
	"code",
	"wireguard-tools",
	"rustfmt",
	"inkscape",
	"helium",
	"antigravity",
	"hledger",
	"vicinae",
	"chafa",
	"telegram-desktop",
	"steam",
	"uncrustify",
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
	"brightnessctl",
	"niri",
    "wl-mirror",
	"cava",
	"mpv",
	"haruna",
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
	"nvim",
	"zen-browser",
	"gitui",
	"torbrowser-launcher",
	"tor",
	"obs-studio",
	"vlc",
	"qbittorrent",
	"picard",
	"kitty",
	"xxd",
	"uv",
	"flameshot",

	"podman",
	"podman-compose",

	"docker",
	"docker-compose",

	"kvantum",
	"kruler",

	-- NOTE: must be put at the end otherwise wouldn't return all
	-- iterables items because fuck you and fuck lua and fuck prabowo
	require("util").add_module({
		require("modules.dotnet"),
		require("modules.php"),
		require("modules.dnf-plugins"),
		require("modules.qemu"),
		require("modules.db"),
		require("modules.cyber"),
	}),
}

Config.flatpaks = {
	-- "com.google.AndroidStudio",
	-- "com.jetbrains.Rider",
    "org.zotero.Zotero",
	"dev.zed.Zed",
	"md.obsidian.Obsidian",
	"com.strlen.TreeSheets",
	"hu.irl.cameractrls",
	"org.localsend.localsend_app",
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
	"org.onlyoffice.desktopeditors",
	"us.zoom.Zoom",
    "com.bilingify.readest",
}

Config.repos = {
	"yalter/niri",
	"errornointernet/quickshell",
	"atim/lazygit",
	"sneexy/zen-browser",
	"chenxiaolong/sbctl",
	"matinlotfali/KDE-Rounded-Corners",
	"zeno/scrcpy",
	"scottames/vicinae",
	"imput/helium",
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
