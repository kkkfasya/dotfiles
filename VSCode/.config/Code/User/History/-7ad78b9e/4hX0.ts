import type { Theme } from "./shared.types.ts";

export const loadTheme = (theme: Theme) => {
	document.documentElement.style.setProperty(
		"--body-background",
		theme.background,
	);
	document.documentElement.style.setProperty(
		"--card-background",
		theme.cardBackground,
	);

	document.documentElement.style.setProperty(
		"--card-element",
		theme.cardElement,
	);
	document.documentElement.style.setProperty(
		"--secondary-color",
		theme.secondaryColor,
	);

	document.documentElement.style.setProperty("--text-color", theme.text);
	document.documentElement.style.setProperty("--nsfw", theme.nsfw);
	document.documentElement.style.setProperty("--crosspost", theme.crosspost);
	document.documentElement.style.setProperty("--primary-color", theme.primary);
	document.documentElement.style.setProperty("--success-color", theme.success);
};
