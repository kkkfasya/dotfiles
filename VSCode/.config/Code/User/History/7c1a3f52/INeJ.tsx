import { useCallback, useEffect, useState, type FormEvent } from "react";
import {
	useNavigate,
	Link,
	useMatch,
	createSearchParams,
} from "react-router-dom";


import "./Nav.css";
import TitleHeading from "./TitleHeading.tsx";
import {loadTheme } from "@/assets/themes/theme-utils.ts"

// making svg as react component is actually quite common pattern, but for static ones it's not needed
import MenuSvg from "../../assets/menu.svg";
import SearchSvg from "../../assets/search.svg";
import SettingsSvg from "../../assets/settings.svg";

import { BrowserView, MobileView } from "react-device-detect";

export function Nav() {
	const navigate = useNavigate();
	const [searchValue, setSearchValue] = useState("");
	const [showSearch, setShowSearch] = useState(false);
	const [scrolled, setScrolled] = useState(false);

	const [title, setTitle] = useState("");
	const [showSettings, setShowSettings] = useState(false);
	const [showSidebar, setShowSidebar] = useState(false);

	const matchSub = useMatch("/r/:sub/*");
	const matchUser = useMatch("/u/:user/");

	function handleSubmit(e: FormEvent) {
		e.preventDefault();
		setShowSearch(false);

		navigate({
			pathname: "/search",
			// TODO: change to query instead of q for clarity perhaps
			search: createSearchParams({ q: searchValue }), // creates e.g q=reddit+meme+dank
		});
	}

	// eslint-disable-next-line react-hooks/exhaustive-deps
	useEffect(() => {
		const theme = localStorage.getItem("theme") || "{}";
		loadTheme(JSON.parse(theme));
	}, []);

	useEffect(() => {
		if (matchSub) {
			setTitle(`r/${matchSub.params.sub}`);
		} else if (matchUser) {
			setTitle(`u/${matchUser.params.user}`);
		} else {
			setTitle("Reddi🅱️");
		}
	}, [matchSub, matchUser]);

	// TODO: do we need this
	useEffect(() => {
		const handleScroll = () => {
			if (window.scrollY > 0) {
				setScrolled(true);
			} else {
				setScrolled(false);
			}
		};

		window.addEventListener("scroll", handleScroll);

		return () => {
			window.removeEventListener("scroll", handleScroll);
		};
	}, []);

	return (
		<>
			<div
				className="navsize"
				// className="header"
			></div>
			<div className={`header ${scrolled ? "header-border" : ""}`}>
				<BrowserView>
					<div className="header-content">
						<div style={{ display: "flex", alignItems: "center" }}>
							{/* XXX: fix this style bullcrap, just use tailwind next-time */}
							<button
								type="button"
								className="menu-btn"
								onClick={() => setShowSidebar((val) => !val)}
								style={{
									width: "35px",
									height: "35px",
									opacity: ".8",
									marginRight: "12px",
									background: "none",
									border: "none",
								}}
							>
								<MenuSvg />
							</button>

							{/* <span
                className="material-symbols-outlined"
                style={{
                  fontSize: "clamp(20px, 2vw,35px)",
                  // opacity: "0.4",
                  marginRight: "20px",
                }}
              >
                menu
              </span> */}
							<Link
								className="noselect"
								style={{ height: "clamp(20px, 2vw,30px)" }}
								to="/"
							>
								<img
									src="/reddiculous/icon_small.png"
									width={"100%"}
									height={"100%"}
									alt=""
								/>
							</Link>

							<Link className="noselect" to="/" style={{ width: "400px" }}>
								<TitleHeading title={title} />
								{/* <h1
                style={{ padding: "10px", fontSize: "clamp(20px, 2vw,25px)" }}
              >
                Reddiculous
              </h1> */}
							</Link>
						</div>
						<form
							className="browser-form"
							// style={{ display: "flex" }}
							action=""
							onSubmit={(e) => handleSubmit(e)}
						>
							{/* <h1>r/</h1> */}
							<div className="sub-input">
								<input
									type="search"
									name="search"
									placeholder="Search posts, title, users..."
									value={searchValue}
									onChange={(e) => setSearchValue(e.target.value)}
								/>
								<div
									className="search"
									style={{ width: "35px", height: "35px" }}
								>
									<SearchSvg />
								</div>
								{/* <span className="search">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    height="35px"
                    viewBox="0 -960 960 960"
                    width="35px"
                    fill="#e8eaed"
                  >
                    <path d="M380.72-353.69q-95.58 0-162-66.32-66.41-66.32-66.41-161.53 0-95.2 66.32-161.52 66.32-66.32 161.48-66.32 95.17 0 161.79 66.32 66.61 66.32 66.61 161.44 0 41.36-14.77 80.77t-40.41 68.39l242.16 241.33q4.79 4.5 5.18 11.93.38 7.43-5.18 12.74-5.57 5.31-12.61 5.31-7.05 0-12.32-5.57L529.08-408.21q-29.8 26.4-69.18 40.46-39.37 14.06-79.18 14.06Zm-.16-33.85q81.65 0 137.88-56.09 56.23-56.09 56.23-137.91t-56.23-137.91q-56.23-56.09-137.88-56.09-81.77 0-138.09 56.09-56.32 56.09-56.32 137.91t56.32 137.91q56.32 56.09 138.09 56.09Z" />
                  </svg>
                </span> */}
							</div>
							{/* <Link to={`/r/${searchValue}`}>Go</Link> */}
						</form>
						<div
							onClick={() => setShowSettings((val) => !val)}
							className="label noselect clickable settings-icon"
						>
							<div style={{ width: "30px", height: "30px" }}>
								<SettingsSvg />
							</div>
							<h3 style={{ fontSize: "clamp(10px, 2vw,20px)" }}>Settings</h3>
						</div>
					</div>
				</BrowserView>
				<MobileView>
					<div className="header-content">
						<div style={{ display: "flex", alignItems: "center", flex: "1" }}>
							<div
								onClick={() => setShowSidebar((val) => !val)}
								className="menu-btn"
								style={{
									width: "35px",
									height: "35px",
									marginRight: "12px",
								}}
							>
								<MenuSvg />
							</div>
							<Link
								className="noselect"
								style={{ display: "flex", alignItems: "center" }}
								to="/"
							>
								<img
									src="/reddiculous/icon_small.png"
									width={"25px"}
									height={"25px"}
									alt=""
								/>
							</Link>

							<Link to="/" style={{ width: "100%" }}>
								<TitleHeading title={title} />
								{/* <h1
                style={{ padding: "10px", fontSize: "clamp(20px, 2vw,25px)" }}
              >
                Reddiculous
              </h1> */}
							</Link>
						</div>
						<div style={{ display: "flex", alignItems: "center" }}>
							<div
								style={{ height: "30px", width: "30px", marginRight: "10px" }}
								onClick={() => setShowSearch(true)}
							>
								<SearchSvg />
							</div>
							<div
								className="settings-icon"
								onClick={() => {
									setShowSettings((val) => !val);
								}}
								style={{ width: "28px", height: "28px" }}
							>
								<SettingsSvg />
							</div>
						</div>
						@types/node
						{
							/* TODO: extract this svg */

							showSearch && (
								<div
									style={{
										position: "absolute",
										inset: "0",
										background: "var(--body-background)",
										display: "flex",
										alignItems: "center",
										justifyContent: "space-evenly",
									}}
								>
									<svg
										style={{ marginInline: "10px" }}
										onClick={() => setShowSearch(false)}
										xmlns="http://www.w3.org/2000/svg"
										height="30px"
										viewBox="0 -960 960 960"
										width="30px"
										fill="#e8eaed"
									>
										<path d="M275.84-454.87 497.9-233.08q7.18 7.49 7.39 17.53.22 10.04-7.6 17.75-7.82 7.72-17.69 7.82-9.87.11-17.69-7.71L201.87-458.13q-4.89-4.9-7-10.21-2.1-5.32-2.1-11.69 0-6.38 2.1-11.66 2.11-5.28 7-10.18l260.44-260.44q7.23-7.23 17.34-7.42 10.12-.19 18.04 7.42 7.82 7.93 7.82 17.85 0 9.92-7.82 17.49L275.84-505.13h479.03q10.87 0 18 7.14Q780-490.86 780-480q0 10.87-7.13 18-7.13 7.13-18 7.13H275.84Z" />
									</svg>
									<form
										// style={{ width: "90%" }}
										className="mobile-form"
										action=""
										onSubmit={(e) => handleSubmit(e)}
									>
										<div className="mobile-sub-input">
											<input
												type="search"
												name="search"
												autoFocus
												placeholder="Search posts, title, users..."
												value={searchValue}
												onChange={(e) => setSearchValue(e.target.value)}
											/>
											<span className="search">
												<div style={{ width: "25px", height: "25px" }}>
													<SearchSvg />
												</div>
												{/* <svg
                        xmlns="http://www.w3.org/2000/svg"
                        height="25px"
                        viewBox="0 -960 960 960"
                        width="25px"
                        fill="#e8eaed"
                      >
                        <path d="M380.72-353.69q-95.58 0-162-66.32-66.41-66.32-66.41-161.53 0-95.2 66.32-161.52 66.32-66.32 161.48-66.32 95.17 0 161.79 66.32 66.61 66.32 66.61 161.44 0 41.36-14.77 80.77t-40.41 68.39l242.16 241.33q4.79 4.5 5.18 11.93.38 7.43-5.18 12.74-5.57 5.31-12.61 5.31-7.05 0-12.32-5.57L529.08-408.21q-29.8 26.4-69.18 40.46-39.37 14.06-79.18 14.06Zm-.16-33.85q81.65 0 137.88-56.09 56.23-56.09 56.23-137.91t-56.23-137.91q-56.23-56.09-137.88-56.09-81.77 0-138.09 56.09-56.32 56.09-56.32 137.91t56.32 137.91q56.32 56.09 138.09 56.09Z" />
                      </svg> */}
											</span>
										</div>
									</form>
								</div>
							)
						}
					</div>
				</MobileView>
			</div>

			{/* {showSettings && ( */}
			<div>
				<div>
					<div
						className={`settings ${
							showSettings ? "show-settings" : "no-interact"
						}`}
					>
						<Settings />
					</div>
				</div>
				<div
					onClick={() => {
						setShowSettings(false);
						// document.body.style.overflow = "visible";
					}}
					className={`settings-backdrop ${
						showSettings ? "show-backdrop" : "no-interact"
					}`}
				></div>
			</div>
			{/* )} */}

			<div
				className={`sidebar-holder ${
					showSidebar ? "sidebar-show" : "sidebar-hide"
				}`}
			>
				<SideBar setShowSidebar={showSidebar} />
			</div>
			<MobileView>
				<div
					onClick={() => {
						setShowSidebar(false);
						// document.body.style.overflow = "visible";
					}}
					className={`settings-backdrop ${
						showSidebar ? "show-backdrop" : "no-interact"
					}`}
				></div>
			</MobileView>
		</>
	);
}
