-- chunkname: @scripts/ui/views/lobby_browser_console_ui_definitions.lua

local var_0_0 = 2
local var_0_1 = 10
local var_0_2 = 58
local var_0_3 = 1200
local var_0_4 = 520
local var_0_5 = 15
local var_0_6 = 40
local var_0_7 = 40
local var_0_8 = {
	width = var_0_3 - var_0_5 - var_0_0,
	height = var_0_2,
	spacing = var_0_0,
	num_visible_entries = var_0_1,
	window_height = var_0_1 * var_0_2 + var_0_0 * (var_0_1 - 1),
	window_width = var_0_3 + var_0_4 + var_0_0,
	filter_height = var_0_6,
	bottom_border_size = var_0_7
}
local var_0_9 = {
	root = {
		is_root = true,
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.default
		}
	},
	dead_space_filler = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			0
		}
	},
	screen = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.default
		}
	},
	lobby_browser_background = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			var_0_8.window_width,
			90
		},
		position = {
			100,
			-100,
			0
		}
	},
	lobby_browser_divider = {
		vertical_alignment = "top",
		parent = "lobby_browser_background",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-55,
			1
		}
	},
	lobby_browser_frame = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			var_0_3,
			40
		},
		position = {
			100,
			-300,
			0
		}
	},
	lobby_entry_anchor = {
		vertical_alignment = "bottom",
		parent = "lobby_browser_frame",
		horizontal_alignment = "left",
		size = {
			var_0_8.width,
			var_0_8.height
		},
		position = {
			0,
			0,
			0
		}
	},
	filter_base = {
		vertical_alignment = "top",
		parent = "lobby_browser_frame",
		horizontal_alignment = "left",
		size = {
			var_0_8.window_width,
			200
		},
		position = {
			0,
			80 + var_0_8.spacing * 2,
			20
		}
	},
	lobby_browser_window = {
		vertical_alignment = "top",
		parent = "filter_base",
		horizontal_alignment = "left",
		size = {
			var_0_3 + var_0_4 + var_0_0,
			var_0_8.window_height + var_0_6 * 3 + var_0_0 * 3
		},
		position = {
			0,
			-0,
			-20
		}
	},
	details_base = {
		vertical_alignment = "top",
		parent = "lobby_browser_frame",
		horizontal_alignment = "left",
		size = {
			520,
			var_0_8.window_height
		},
		position = {
			var_0_3 + var_0_8.spacing,
			-40 + var_0_0,
			1
		}
	},
	details_level_frame = {
		vertical_alignment = "top",
		parent = "details_base",
		horizontal_alignment = "center",
		size = {
			200,
			200
		},
		position = {
			0,
			-25,
			2
		}
	},
	details_level_image = {
		vertical_alignment = "center",
		parent = "details_level_frame",
		horizontal_alignment = "center",
		size = {
			180,
			180
		},
		position = {
			0,
			0,
			-1
		}
	},
	custom_details_level_frame = {
		vertical_alignment = "top",
		parent = "details_base",
		horizontal_alignment = "left",
		size = {
			100,
			100
		},
		position = {
			40,
			-12.5,
			2
		}
	},
	custom_details_level_image = {
		vertical_alignment = "center",
		parent = "custom_details_level_frame",
		horizontal_alignment = "center",
		size = {
			90,
			90
		},
		position = {
			0,
			0,
			-1
		}
	},
	details_level_decoration = {
		vertical_alignment = "bottom",
		parent = "details_level_frame",
		horizontal_alignment = "right",
		position = {
			0,
			0,
			2
		},
		size = {
			60,
			60
		}
	},
	details_level_name = {
		vertical_alignment = "bottom",
		parent = "details_level_image",
		horizontal_alignment = "center",
		position = {
			0,
			-200,
			-1
		},
		size = {
			520,
			170
		}
	},
	custom_details_level_name = {
		vertical_alignment = "bottom",
		parent = "custom_details_level_image",
		horizontal_alignment = "left",
		position = {
			0,
			-100,
			-1
		},
		size = {
			260,
			85
		}
	},
	details_hero_tabs = {
		vertical_alignment = "bottom",
		parent = "details_level_image",
		horizontal_alignment = "center",
		position = {
			88,
			-160,
			-1
		}
	},
	details_locked_reason = {
		vertical_alignment = "bottom",
		parent = "details_base",
		horizontal_alignment = "center",
		position = {
			0,
			50,
			-1
		},
		size = {
			520,
			170
		}
	},
	details_level_info = {
		vertical_alignment = "bottom",
		parent = "details_base",
		horizontal_alignment = "center",
		position = {
			0,
			10,
			-1
		}
	},
	details_game_type = {
		vertical_alignment = "bottom",
		parent = "details_level_info",
		horizontal_alignment = "right",
		size = {
			220,
			50
		}
	},
	details_status = {
		vertical_alignment = "bottom",
		parent = "details_level_info",
		horizontal_alignment = "right",
		size = {
			220,
			50
		}
	},
	details_players_anchor = {
		vertical_alignment = "bottom",
		parent = "details_level_name",
		horizontal_alignment = "center",
		position = {
			0,
			-60,
			-1
		},
		size = {
			520,
			170
		}
	},
	details_players = {
		parent = "details_players_anchor",
		position = {
			0,
			0,
			0
		}
	},
	custom_settings_frame = {
		vertical_alignment = "bottom",
		parent = "details_locked_reason",
		horizontal_alignment = "center",
		position = {
			0,
			110,
			200
		},
		size = {
			420,
			130
		}
	},
	custom_settings_label = {
		vertical_alignment = "top",
		parent = "custom_settings_frame",
		horizontal_alignment = "center",
		position = {
			0,
			20,
			0
		}
	},
	custom_settings_anchor = {
		vertical_alignment = "center",
		parent = "custom_settings_frame",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			0
		},
		size = {
			450,
			125
		}
	},
	custom_settings_window = {
		parent = "custom_settings_anchor"
	},
	weave_details_base = {
		vertical_alignment = "top",
		parent = "lobby_browser_frame",
		horizontal_alignment = "left",
		size = {
			520,
			var_0_8.window_height
		},
		position = {
			var_0_3 + var_0_8.spacing,
			-40 + var_0_0,
			1
		}
	},
	weave_details_level_frame = {
		vertical_alignment = "top",
		parent = "weave_details_base",
		horizontal_alignment = "right",
		size = {
			180,
			180
		},
		position = {
			-5,
			-5,
			2
		}
	},
	weave_details_level_image = {
		vertical_alignment = "center",
		parent = "weave_details_level_frame",
		horizontal_alignment = "center",
		size = {
			160,
			160
		},
		position = {
			0,
			0,
			-1
		}
	},
	weave_details_level_name = {
		vertical_alignment = "top",
		parent = "weave_details_base",
		horizontal_alignment = "left",
		position = {
			15,
			-15,
			-1
		},
		size = {
			520,
			170
		}
	},
	deus_level_icon = {
		vertical_alignment = "center",
		parent = "details_level_frame",
		horizontal_alignment = "center",
		size = {
			180,
			180
		},
		position = {
			0,
			-20,
			-1
		}
	},
	weave_details_hero_tabs = {
		vertical_alignment = "top",
		parent = "weave_details_level_name",
		horizontal_alignment = "left",
		position = {
			150,
			10,
			-1
		}
	},
	weave_details_locked_reason = {
		vertical_alignment = "bottom",
		parent = "weave_details_base",
		horizontal_alignment = "center",
		position = {
			0,
			50,
			-1
		},
		size = {
			520,
			170
		}
	},
	weave_details_level_info = {
		vertical_alignment = "bottom",
		parent = "weave_details_base",
		horizontal_alignment = "center",
		position = {
			0,
			10,
			-1
		}
	},
	weave_game_type = {
		vertical_alignment = "bottom",
		parent = "weave_details_level_info",
		horizontal_alignment = "right",
		size = {
			220,
			50
		}
	},
	weave_status = {
		vertical_alignment = "bottom",
		parent = "weave_details_level_info",
		horizontal_alignment = "right",
		size = {
			220,
			50
		}
	},
	wind_icon_bg = {
		vertical_alignment = "bottom",
		parent = "weave_details_level_frame",
		horizontal_alignment = "center",
		size = {
			62.05,
			62.05
		},
		position = {
			0,
			-20,
			2
		}
	},
	wind_icon_slot = {
		vertical_alignment = "center",
		parent = "wind_icon_bg",
		horizontal_alignment = "center",
		size = {
			54.4,
			54.4
		},
		position = {
			0,
			0,
			1
		}
	},
	wind_icon_glow = {
		vertical_alignment = "center",
		parent = "wind_icon_slot",
		horizontal_alignment = "center",
		size = {
			43.35,
			45.05
		},
		position = {
			0,
			0,
			1
		}
	},
	wind_icon = {
		vertical_alignment = "center",
		parent = "wind_icon_slot",
		horizontal_alignment = "center",
		size = {
			54.4,
			54.4
		},
		position = {
			0,
			0,
			2
		}
	},
	wind_name = {
		vertical_alignment = "top",
		parent = "weave_details_level_name",
		horizontal_alignment = "left",
		size = {
			520,
			32
		},
		position = {
			0,
			-40,
			0
		}
	},
	wind_mutator_window = {
		vertical_alignment = "top",
		parent = "details_level_frame",
		horizontal_alignment = "center",
		size = {
			520,
			0
		},
		position = {
			0,
			-150,
			1
		}
	},
	wind_mutator_icon = {
		vertical_alignment = "top",
		parent = "wind_mutator_window",
		horizontal_alignment = "left",
		size = {
			28,
			36
		},
		position = {
			25,
			-75,
			5
		}
	},
	wind_mutator_icon_frame = {
		vertical_alignment = "center",
		parent = "wind_mutator_icon",
		horizontal_alignment = "center",
		size = {
			60,
			60
		},
		position = {
			0,
			0,
			1
		}
	},
	wind_mutator_title_text = {
		vertical_alignment = "top",
		parent = "wind_mutator_window",
		horizontal_alignment = "left",
		size = {
			312,
			50
		},
		position = {
			10,
			-5,
			1
		}
	},
	wind_mutator_title_divider = {
		vertical_alignment = "bottom",
		parent = "wind_mutator_title_text",
		horizontal_alignment = "left",
		size = {
			450,
			4
		},
		position = {
			0,
			10,
			1
		}
	},
	wind_mutator_description_text = {
		vertical_alignment = "top",
		parent = "wind_mutator_icon",
		horizontal_alignment = "left",
		size = {
			430,
			100
		},
		position = {
			60,
			15,
			1
		}
	},
	objective_title = {
		vertical_alignment = "bottom",
		parent = "wind_mutator_icon",
		horizontal_alignment = "left",
		size = {
			520,
			40
		},
		position = {
			-20,
			-90,
			3
		}
	},
	objective_title_bg = {
		vertical_alignment = "center",
		parent = "objective_title",
		horizontal_alignment = "center",
		size = {
			467,
			59
		},
		position = {
			0,
			0,
			-1
		}
	},
	objective_1 = {
		vertical_alignment = "bottom",
		parent = "objective_title",
		horizontal_alignment = "center",
		size = {
			520,
			30
		},
		position = {
			0,
			-35,
			3
		}
	},
	objective_2 = {
		vertical_alignment = "bottom",
		parent = "objective_1",
		horizontal_alignment = "center",
		size = {
			520,
			30
		},
		position = {
			0,
			-35,
			0
		}
	},
	twitch_logo = {
		vertical_alignment = "center",
		parent = "objective_2",
		horizontal_alignment = "center",
		size = {
			130,
			29
		},
		position = {
			0,
			15,
			1
		}
	},
	filter_game_type_entry_anchor = {
		vertical_alignment = "top",
		parent = "filter_base",
		horizontal_alignment = "left",
		size = {
			var_0_8.window_width / 5,
			var_0_8.filter_height
		},
		position = {
			0,
			-var_0_8.filter_height - var_0_8.spacing,
			1
		}
	},
	filter_level_entry_anchor = {
		vertical_alignment = "top",
		parent = "filter_base",
		horizontal_alignment = "left",
		size = {
			var_0_8.window_width / 5,
			var_0_8.filter_height
		},
		position = {
			var_0_8.window_width / 5 * 1,
			-var_0_8.filter_height - var_0_8.spacing,
			1
		}
	},
	filter_level_scroller = {
		vertical_alignment = "top",
		parent = "filter_base",
		horizontal_alignment = "left",
		size = {
			var_0_8.window_width / 5,
			var_0_8.filter_height
		},
		position = {
			var_0_8.window_width / 5 * 1,
			-var_0_8.filter_height - var_0_8.spacing,
			1
		}
	},
	filter_difficulty_entry_anchor = {
		vertical_alignment = "top",
		parent = "filter_base",
		horizontal_alignment = "left",
		size = {
			var_0_8.window_width / 5,
			var_0_8.filter_height
		},
		position = {
			var_0_8.window_width / 5 * 2 + var_0_8.spacing,
			-var_0_8.filter_height - var_0_8.spacing,
			1
		}
	},
	filter_lobby_entry_anchor = {
		vertical_alignment = "top",
		parent = "filter_base",
		horizontal_alignment = "left",
		size = {
			var_0_8.window_width / 5,
			var_0_8.filter_height
		},
		position = {
			var_0_8.window_width / 5 * 3 + var_0_8.spacing,
			-var_0_8.filter_height - var_0_8.spacing,
			1
		}
	},
	filter_distance_entry_anchor = {
		vertical_alignment = "top",
		parent = "filter_base",
		horizontal_alignment = "left",
		size = {
			var_0_8.window_width / 5,
			var_0_8.filter_height
		},
		position = {
			var_0_8.window_width / 5 * 4 + var_0_8.spacing,
			-var_0_8.filter_height - var_0_8.spacing,
			1
		}
	},
	join_button = {
		vertical_alignment = "bottom",
		parent = "lobby_browser_window",
		horizontal_alignment = "right",
		size = {
			200,
			65
		},
		position = {
			0,
			-120,
			1
		}
	},
	refresh_button = {
		vertical_alignment = "center",
		parent = "join_button",
		horizontal_alignment = "center",
		size = {
			200,
			65
		},
		position = {
			-225,
			0,
			1
		}
	}
}
local var_0_10 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = IS_WINDOWS and 0.05 or 0.5,
			init = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				arg_1_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = math.easeInCubic(arg_2_3)

				arg_2_4.render_settings.alpha_multiplier = var_2_0
			end,
			on_complete = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				arg_4_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				arg_5_4.render_settings.alpha_multiplier = 1
			end,
			on_complete = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		}
	}
}
local var_0_11 = {
	"ad",
	"ae",
	"af",
	"ag",
	"al",
	"am",
	"ao",
	"ar",
	"at",
	"au",
	"az",
	"ba",
	"bb",
	"bd",
	"be",
	"bf",
	"bg",
	"bh",
	"bi",
	"bj",
	"bn",
	"bo",
	"br",
	"bs",
	"bt",
	"bw",
	"by",
	"bz",
	"ca",
	"cd",
	"cf",
	"cg",
	"ch",
	"ci",
	"cl",
	"cm",
	"cn",
	"co",
	"cr",
	"cu",
	"cv",
	"cy",
	"cz",
	"de",
	"dj",
	"dk",
	"dm",
	"do",
	"dz",
	"ec",
	"ee",
	"eg",
	"eh",
	"er",
	"es",
	"et",
	"fi",
	"fj",
	"fm",
	"fr",
	"ga",
	"gb",
	"gd",
	"ge",
	"gh",
	"gm",
	"gn",
	"gq",
	"gr",
	"gt",
	"gw",
	"gy",
	"hn",
	"hr",
	"ht",
	"hu",
	"id",
	"ie",
	"il",
	"in",
	"iq",
	"ir",
	"is",
	"it",
	"jm",
	"jo",
	"jp",
	"ke",
	"kg",
	"kh",
	"ki",
	"km",
	"kn",
	"kp",
	"kr",
	"ks",
	"kw",
	"kz",
	"la",
	"lb",
	"lc",
	"li",
	"lk",
	"lr",
	"ls",
	"lt",
	"lu",
	"lv",
	"ly",
	"ma",
	"mc",
	"md",
	"me",
	"mg",
	"mh",
	"mk",
	"ml",
	"mm",
	"mn",
	"mr",
	"mt",
	"mu",
	"mv",
	"mw",
	"mx",
	"my",
	"mz",
	"na",
	"ne",
	"ng",
	"ni",
	"nl",
	"no",
	"np",
	"nr",
	"nz",
	"om",
	"pa",
	"pe",
	"pg",
	"ph",
	"pk",
	"pl",
	"pt",
	"pw",
	"py",
	"qa",
	"ro",
	"rs",
	"ru",
	"rw",
	"sa",
	"sb",
	"sc",
	"sd",
	"se",
	"sg",
	"si",
	"sk",
	"sl",
	"sm",
	"sn",
	"so",
	"sr",
	"st",
	"sv",
	"sy",
	"sz",
	"td",
	"tg",
	"th",
	"tj",
	"tl",
	"tm",
	"tn",
	"to",
	"tr",
	"tt",
	"tv",
	"tw",
	"tz",
	"ua",
	"ug",
	"us",
	"uy",
	"uz",
	"va",
	"vc",
	"ve",
	"vn",
	"vu",
	"ws",
	"ye",
	"za",
	"zm",
	"zw"
}

local function var_0_12(arg_7_0)
	return {
		element = {
			passes = {
				{
					pass_type = "rect",
					style_id = "info_bar"
				},
				{
					style_id = "dimmer",
					pass_type = "rect",
					content_check_function = function(arg_8_0, arg_8_1)
						return arg_8_0.filter_active
					end
				},
				{
					pass_type = "rect",
					style_id = "top_bar"
				},
				{
					pass_type = "rect",
					style_id = "left_bar"
				},
				{
					pass_type = "rect",
					style_id = "right_bar"
				},
				{
					pass_type = "rect",
					style_id = "bottom"
				},
				{
					style_id = "scroller_hotspot",
					pass_type = "hotspot",
					content_id = "scroller_hotspot"
				},
				{
					style_id = "scroll_bar",
					pass_type = "rect",
					content_change_function = function(arg_9_0, arg_9_1)
						if not arg_9_0.inner_scroller_hotspot.is_hover and arg_9_0.scrollbar_hotspot.is_hover then
							arg_9_1.color = arg_9_1.selected_color
						else
							arg_9_1.color = arg_9_1.base_color
						end
					end
				},
				{
					style_id = "scrollbar_hotspot",
					pass_type = "hotspot",
					content_id = "scrollbar_hotspot"
				},
				{
					pass_type = "rect",
					style_id = "details_background"
				},
				{
					pass_type = "texture",
					style_id = "mask",
					texture_id = "mask_id"
				},
				{
					pass_type = "texture",
					style_id = "filter_mask",
					texture_id = "mask_id",
					content_check_function = function(arg_10_0, arg_10_1)
						return arg_10_0.filter_active
					end
				},
				{
					pass_type = "texture",
					style_id = "host_mask",
					texture_id = "mask_id"
				},
				{
					pass_type = "texture",
					style_id = "country_mask",
					texture_id = "mask_id"
				},
				{
					pass_type = "texture",
					style_id = "difficulty_mask",
					texture_id = "mask_id"
				},
				{
					style_id = "host_label",
					pass_type = "text",
					text_id = "host_label"
				},
				{
					style_id = "country_label",
					pass_type = "text",
					text_id = "country_label"
				},
				{
					style_id = "difficulty_label",
					pass_type = "text",
					text_id = "difficulty_label"
				},
				{
					style_id = "players_label",
					pass_type = "text",
					text_id = "players_label"
				},
				{
					style_id = "info_text",
					pass_type = "text",
					text_id = "info_text_id"
				},
				{
					style_id = "timer_text",
					pass_type = "text",
					text_id = "timer_text_id",
					content_change_function = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
						arg_11_0.timer = (arg_11_0.timer or 0) + arg_11_3

						local var_11_0 = math.max(arg_11_0.timer, 0)
						local var_11_1 = math.floor(var_11_0 / 60)
						local var_11_2 = math.floor(var_11_1 / 60)

						arg_11_0.timer_text_id = string.format("%02d:%02d:%02d", var_11_2, var_11_1 - var_11_2 * 60, var_11_0 % 60)
					end
				},
				{
					style_id = "time_since_refresh",
					pass_type = "text",
					text_id = "time_since_refresh_id"
				},
				{
					style_id = "details_label",
					pass_type = "text",
					text_id = "details_label"
				},
				{
					style_id = "scroller",
					pass_type = "rect",
					content_check_function = function(arg_12_0, arg_12_1)
						return arg_12_0.show_scroller and not arg_12_0.filter_active
					end,
					content_change_function = function(arg_13_0, arg_13_1)
						local var_13_0 = var_0_8.window_height
						local var_13_1 = var_0_8.spacing
						local var_13_2 = arg_13_0.scrollbar_progress
						local var_13_3 = arg_13_1.texture_size[2]
						local var_13_4 = -var_13_1 - var_13_2 * (var_13_0 + var_13_3)

						arg_13_1.offset[2] = var_13_4
						arg_13_1.offset[1] = Math.is_valid(arg_13_1.offset[1]) and arg_13_1.offset[1] or 0
						arg_13_1.offset[2] = Math.is_valid(arg_13_1.offset[2]) and arg_13_1.offset[2] or 0
						arg_13_1.offset[3] = Math.is_valid(arg_13_1.offset[3]) and arg_13_1.offset[3] or 0
					end
				},
				{
					style_id = "inner_scroller",
					pass_type = "rect",
					content_check_function = function(arg_14_0, arg_14_1)
						return arg_14_0.show_scroller and not arg_14_0.filter_active
					end,
					content_change_function = function(arg_15_0, arg_15_1)
						local var_15_0 = var_0_8.window_height
						local var_15_1 = -var_0_8.spacing - arg_15_0.scrollbar_progress * (var_15_0 + arg_15_1.texture_size[2])

						arg_15_1.offset[2] = var_15_1
						arg_15_1.offset[1] = Math.is_valid(arg_15_1.offset[1]) and arg_15_1.offset[1] or 0
						arg_15_1.offset[2] = Math.is_valid(arg_15_1.offset[2]) and arg_15_1.offset[2] or 0
						arg_15_1.offset[3] = Math.is_valid(arg_15_1.offset[3]) and arg_15_1.offset[3] or 0

						if arg_15_0.inner_scroller_hotspot.is_hover then
							arg_15_1.color = arg_15_1.selected_color
						else
							arg_15_1.color = arg_15_1.base_color
						end
					end
				},
				{
					style_id = "inner_scroller_hotspot",
					pass_type = "hotspot",
					content_id = "inner_scroller_hotspot",
					content_check_function = function(arg_16_0, arg_16_1)
						return arg_16_0.parent.show_scroller and not arg_16_0.parent.filter_active
					end,
					content_change_function = function(arg_17_0, arg_17_1)
						local var_17_0 = arg_17_1.parent.inner_scroller

						arg_17_1.offset[2] = var_17_0.offset[2] - arg_17_1.area_size[2]
					end
				}
			}
		},
		content = {
			players_label = "lb_players",
			filter_active = false,
			timer_text_id = "0:00:00",
			details_label = "lb_details",
			difficulty_label = "lb_difficulty",
			info_text_id = " ",
			scrollbar_progress = 0,
			show_scroller = true,
			host_label = "lb_host",
			mask_id = "mask_rect",
			country_label = "lb_country",
			wanted_scroller_offset = 0,
			time_since_refresh_id = Localize("time_since_last_refresh") .. ":",
			inner_scroller_hotspot = {},
			scrollbar_hotspot = {},
			scroller_hotspot = {}
		},
		style = {
			info_bar = {
				color = {
					224,
					0,
					0,
					0
				},
				texture_size = {
					var_0_8.window_width + var_0_8.spacing * 2,
					var_0_6
				},
				offset = {
					-var_0_8.spacing,
					0,
					0
				}
			},
			dimmer = {
				color = {
					196,
					0,
					0,
					0
				},
				texture_size = {
					var_0_8.window_width,
					-var_0_8.window_height - var_0_6
				},
				offset = {
					0,
					var_0_6,
					20
				}
			},
			top_bar = {
				color = {
					224,
					0,
					0,
					0
				},
				size = {
					var_0_8.window_width + var_0_8.spacing * 7,
					var_0_8.spacing * 2
				},
				offset = {
					-var_0_8.spacing * 3.5,
					126,
					0
				}
			},
			bottom = {
				color = {
					224,
					0,
					0,
					0
				},
				size = {
					var_0_8.window_width + var_0_8.spacing * 2,
					-var_0_7
				},
				offset = {
					-var_0_8.spacing,
					-var_0_8.window_height - var_0_8.spacing * 1.5,
					0
				}
			},
			right_bar = {
				color = {
					224,
					0,
					0,
					0
				},
				size = {
					5,
					-var_0_8.window_height - 127 - var_0_7 - var_0_8.spacing * 2
				},
				offset = {
					var_0_8.window_width + var_0_8.spacing,
					124 + var_0_8.spacing * 2,
					0
				}
			},
			left_bar = {
				color = {
					224,
					0,
					0,
					0
				},
				size = {
					5,
					-var_0_8.window_height - 127 - var_0_7 - var_0_8.spacing * 2
				},
				offset = {
					-var_0_8.spacing - 5,
					124 + var_0_8.spacing * 2,
					0
				}
			},
			details_bar = {
				texture_size = {
					var_0_4,
					40
				},
				color = {
					0,
					0,
					0,
					0
				},
				offset = {
					1200 + var_0_8.spacing,
					0,
					0
				}
			},
			scroll_bar = {
				texture_size = {
					var_0_5,
					-var_0_8.window_height
				},
				color = {
					224,
					0,
					0,
					0
				},
				base_color = {
					224,
					0,
					0,
					0
				},
				selected_color = {
					255,
					0,
					0,
					0
				},
				offset = {
					var_0_3 - var_0_5,
					-var_0_8.spacing,
					0
				}
			},
			scrollbar_hotspot = {
				area_size = {
					var_0_5,
					var_0_8.window_height
				},
				color = {
					224,
					0,
					0,
					0
				},
				offset = {
					var_0_3 - var_0_5,
					-var_0_8.spacing - var_0_8.window_height,
					0
				}
			},
			scroller = {
				texture_size = {
					var_0_5,
					-100
				},
				color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_0_3 - var_0_5,
					-var_0_8.spacing,
					0
				}
			},
			inner_scroller = {
				texture_size = {
					var_0_5 - 4,
					-100
				},
				color = Colors.get_color_table_with_alpha("font_default", 255),
				base_color = Colors.get_color_table_with_alpha("font_default", 255),
				selected_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_0_3 - var_0_5 + 2,
					-var_0_8.spacing,
					0
				},
				base_offset = {
					var_0_3 - var_0_5 + 2,
					-var_0_8.spacing,
					0
				}
			},
			inner_scroller_hotspot = {
				area_size = {
					var_0_5 - 4,
					-100
				},
				offset = {
					var_0_3 - var_0_5 + 2,
					-var_0_8.spacing,
					0
				}
			},
			scroller_hotspot = {
				vertical_alignment = "bottom",
				area_size = {
					var_0_3,
					var_0_2 * var_0_1 + (var_0_1 - 1) * var_0_0
				},
				offset = {
					0,
					-var_0_8.window_height,
					0
				}
			},
			details_background = {
				texture_size = {
					var_0_4,
					-var_0_8.window_height
				},
				color = {
					168,
					0,
					0,
					0
				},
				offset = {
					1200 + var_0_8.spacing,
					-var_0_8.spacing,
					0
				}
			},
			mask = {
				texture_size = {
					var_0_3 - var_0_5 - var_0_8.spacing,
					-var_0_8.window_height
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					-var_0_8.spacing,
					0
				}
			},
			filter_mask = {
				texture_size = {
					var_0_8.window_width,
					-var_0_8.window_height - var_0_8.filter_height
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					-var_0_8.spacing + var_0_8.filter_height + var_0_8.spacing,
					5
				}
			},
			host_mask = {
				texture_size = {
					var_0_8.spacing * 0.33,
					-var_0_8.window_height
				},
				color = {
					1,
					0,
					0,
					0
				},
				offset = {
					620,
					-var_0_8.spacing,
					0
				}
			},
			country_mask = {
				texture_size = {
					var_0_8.spacing * 0.33,
					-var_0_8.window_height
				},
				color = {
					1,
					0,
					0,
					0
				},
				offset = {
					775,
					-var_0_8.spacing,
					0
				}
			},
			difficulty_mask = {
				texture_size = {
					var_0_8.spacing * 0.33,
					-var_0_8.window_height
				},
				color = {
					1,
					0,
					0,
					0
				},
				offset = {
					1030,
					-var_0_8.spacing,
					0
				}
			},
			host_label = {
				vertical_alignment = "center",
				upper_case = true,
				localize = true,
				horizontal_alignment = "left",
				font_size = 20,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					20,
					-2,
					1
				}
			},
			country_label = {
				vertical_alignment = "center",
				upper_case = true,
				localize = true,
				horizontal_alignment = "center",
				font_size = 20,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					100,
					-2,
					1
				}
			},
			difficulty_label = {
				vertical_alignment = "center",
				upper_case = true,
				localize = true,
				horizontal_alignment = "center",
				font_size = 20,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					305,
					-2,
					1
				}
			},
			players_label = {
				vertical_alignment = "center",
				upper_case = true,
				localize = true,
				horizontal_alignment = "center",
				font_size = 20,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					510,
					-2,
					1
				}
			},
			details_label = {
				vertical_alignment = "center",
				upper_case = true,
				localize = true,
				horizontal_alignment = "left",
				font_size = 20,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					1220,
					-2,
					1
				}
			},
			info_text = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				localize = false,
				font_size = 24,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					13,
					-var_0_8.window_height - var_0_7 - 2,
					5
				}
			},
			timer_text = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				localize = false,
				font_size = 24,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					var_0_3 - 105,
					-var_0_8.window_height - var_0_7 - 2,
					5
				}
			},
			time_since_refresh = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				localize = false,
				font_size = 24,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					-110,
					-var_0_8.window_height - var_0_7 - 2,
					5
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_7_0
	}
end

local function var_0_13(arg_18_0)
	local var_18_0 = var_0_8.window_width / 5

	return {
		element = {
			passes = {
				{
					pass_type = "rect",
					style_id = "info_bar"
				},
				{
					style_id = "game_type_left_triangle",
					pass_type = "triangle",
					content_check_function = function(arg_19_0, arg_19_1)
						if arg_19_0.filter_hotspot_1.disable_button then
							return false
						else
							local var_19_0 = Managers.input:is_device_active("gamepad")

							return arg_19_0.filter_selection and arg_19_0.filter_index == 1 or not var_19_0
						end
					end,
					content_change_function = function(arg_20_0, arg_20_1)
						if arg_20_0.filter_selection and arg_20_0.filter_index == 1 or arg_20_0.filter_hotspot_1.is_hover then
							arg_20_1.color = arg_20_1.select_color
						else
							arg_20_1.color = arg_20_1.base_color
						end
					end
				},
				{
					style_id = "game_type_right_triangle",
					pass_type = "triangle",
					content_check_function = function(arg_21_0, arg_21_1)
						if arg_21_0.filter_hotspot_1.disable_button then
							return false
						else
							local var_21_0 = Managers.input:is_device_active("gamepad")

							return arg_21_0.filter_selection and arg_21_0.filter_index == 1 or not var_21_0
						end
					end,
					content_change_function = function(arg_22_0, arg_22_1)
						if arg_22_0.filter_selection and arg_22_0.filter_index == 1 or arg_22_0.filter_hotspot_1.is_hover then
							arg_22_1.color = arg_22_1.select_color
						else
							arg_22_1.color = arg_22_1.base_color
						end
					end
				},
				{
					style_id = "level_left_triangle",
					pass_type = "triangle",
					content_check_function = function(arg_23_0, arg_23_1)
						if arg_23_0.filter_hotspot_2.disable_button then
							return false
						else
							local var_23_0 = Managers.input:is_device_active("gamepad")

							return arg_23_0.filter_selection and arg_23_0.filter_index == 2 or not var_23_0
						end
					end,
					content_change_function = function(arg_24_0, arg_24_1)
						if arg_24_0.filter_selection and arg_24_0.filter_index == 2 or arg_24_0.filter_hotspot_2.is_hover then
							arg_24_1.color = arg_24_1.select_color
						else
							arg_24_1.color = arg_24_1.base_color
						end
					end
				},
				{
					style_id = "level_right_triangle",
					pass_type = "triangle",
					content_check_function = function(arg_25_0, arg_25_1)
						if arg_25_0.filter_hotspot_2.disable_button then
							return false
						else
							local var_25_0 = Managers.input:is_device_active("gamepad")

							return arg_25_0.filter_selection and arg_25_0.filter_index == 2 or not var_25_0
						end
					end,
					content_change_function = function(arg_26_0, arg_26_1)
						if arg_26_0.filter_selection and arg_26_0.filter_index == 2 or arg_26_0.filter_hotspot_2.is_hover then
							arg_26_1.color = arg_26_1.select_color
						else
							arg_26_1.color = arg_26_1.base_color
						end
					end
				},
				{
					style_id = "difficulty_left_triangle",
					pass_type = "triangle",
					content_check_function = function(arg_27_0, arg_27_1)
						if arg_27_0.filter_hotspot_3.disable_button then
							return false
						else
							local var_27_0 = Managers.input:is_device_active("gamepad")

							return arg_27_0.filter_selection and arg_27_0.filter_index == 3 or not var_27_0
						end
					end,
					content_change_function = function(arg_28_0, arg_28_1)
						if arg_28_0.filter_selection and arg_28_0.filter_index == 3 or arg_28_0.filter_hotspot_3.is_hover then
							arg_28_1.color = arg_28_1.select_color
						else
							arg_28_1.color = arg_28_1.base_color
						end
					end
				},
				{
					style_id = "difficulty_right_triangle",
					pass_type = "triangle",
					content_check_function = function(arg_29_0, arg_29_1)
						if arg_29_0.filter_hotspot_3.disable_button then
							return false
						else
							local var_29_0 = Managers.input:is_device_active("gamepad")

							return arg_29_0.filter_selection and arg_29_0.filter_index == 3 or not var_29_0
						end
					end,
					content_change_function = function(arg_30_0, arg_30_1)
						if arg_30_0.filter_selection and arg_30_0.filter_index == 3 or arg_30_0.filter_hotspot_3.is_hover then
							arg_30_1.color = arg_30_1.select_color
						else
							arg_30_1.color = arg_30_1.base_color
						end
					end
				},
				{
					style_id = "lobby_filter_left_triangle",
					pass_type = "triangle",
					content_check_function = function(arg_31_0, arg_31_1)
						if arg_31_0.filter_hotspot_4.disable_button then
							return false
						else
							local var_31_0 = Managers.input:is_device_active("gamepad")

							return arg_31_0.filter_selection and arg_31_0.filter_index == 4 or not var_31_0
						end
					end,
					content_change_function = function(arg_32_0, arg_32_1)
						if arg_32_0.filter_selection and arg_32_0.filter_index == 4 or arg_32_0.filter_hotspot_4.is_hover then
							arg_32_1.color = arg_32_1.select_color
						else
							arg_32_1.color = arg_32_1.base_color
						end
					end
				},
				{
					style_id = "lobby_filter_right_triangle",
					pass_type = "triangle",
					content_check_function = function(arg_33_0, arg_33_1)
						if arg_33_0.filter_hotspot_4.disable_button then
							return false
						else
							local var_33_0 = Managers.input:is_device_active("gamepad")

							return arg_33_0.filter_selection and arg_33_0.filter_index == 4 or not var_33_0
						end
					end,
					content_change_function = function(arg_34_0, arg_34_1)
						if arg_34_0.filter_selection and arg_34_0.filter_index == 4 or arg_34_0.filter_hotspot_4.is_hover then
							arg_34_1.color = arg_34_1.select_color
						else
							arg_34_1.color = arg_34_1.base_color
						end
					end
				},
				{
					style_id = "distance_left_triangle",
					pass_type = "triangle",
					content_check_function = function(arg_35_0, arg_35_1)
						if arg_35_0.filter_hotspot_5.disable_button then
							return false
						else
							local var_35_0 = Managers.input:is_device_active("gamepad")

							return arg_35_0.filter_selection and arg_35_0.filter_index == 5 or not var_35_0
						end
					end,
					content_change_function = function(arg_36_0, arg_36_1)
						if arg_36_0.filter_selection and arg_36_0.filter_index == 5 or arg_36_0.filter_hotspot_5.is_hover then
							arg_36_1.color = arg_36_1.select_color
						else
							arg_36_1.color = arg_36_1.base_color
						end
					end
				},
				{
					style_id = "distance_right_triangle",
					pass_type = "triangle",
					content_check_function = function(arg_37_0, arg_37_1)
						if arg_37_0.filter_hotspot_5.disable_button then
							return false
						else
							local var_37_0 = Managers.input:is_device_active("gamepad")

							return arg_37_0.filter_selection and arg_37_0.filter_index == 5 or not var_37_0
						end
					end,
					content_change_function = function(arg_38_0, arg_38_1)
						if arg_38_0.filter_selection and arg_38_0.filter_index == 5 or arg_38_0.filter_hotspot_5.is_hover then
							arg_38_1.color = arg_38_1.select_color
						else
							arg_38_1.color = arg_38_1.base_color
						end
					end
				},
				{
					style_id = "background_1",
					pass_type = "hotspot",
					content_id = "filter_hotspot_1"
				},
				{
					style_id = "background_1",
					pass_type = "rect",
					content_change_function = function(arg_39_0, arg_39_1)
						if arg_39_0.filter_selection and arg_39_0.filter_index == 1 or arg_39_0.filter_hotspot_1.is_hover then
							arg_39_1.color = arg_39_1.selection_color
						else
							arg_39_1.color = arg_39_1.base_color
						end
					end
				},
				{
					style_id = "background_2",
					pass_type = "hotspot",
					content_id = "filter_hotspot_2"
				},
				{
					style_id = "background_2",
					pass_type = "rect",
					content_change_function = function(arg_40_0, arg_40_1)
						if arg_40_0.filter_selection and arg_40_0.filter_index == 2 or arg_40_0.filter_hotspot_2.is_hover then
							arg_40_1.color = arg_40_1.selection_color
						else
							arg_40_1.color = arg_40_1.base_color
						end
					end
				},
				{
					style_id = "background_3",
					pass_type = "hotspot",
					content_id = "filter_hotspot_3"
				},
				{
					style_id = "background_3",
					pass_type = "rect",
					content_change_function = function(arg_41_0, arg_41_1)
						if arg_41_0.filter_selection and arg_41_0.filter_index == 3 or arg_41_0.filter_hotspot_3.is_hover then
							arg_41_1.color = arg_41_1.selection_color
						else
							arg_41_1.color = arg_41_1.base_color
						end
					end
				},
				{
					style_id = "background_4",
					pass_type = "hotspot",
					content_id = "filter_hotspot_4"
				},
				{
					style_id = "background_4",
					pass_type = "rect",
					content_change_function = function(arg_42_0, arg_42_1)
						if arg_42_0.filter_selection and arg_42_0.filter_index == 4 or arg_42_0.filter_hotspot_4.is_hover then
							arg_42_1.color = arg_42_1.selection_color
						else
							arg_42_1.color = arg_42_1.base_color
						end
					end
				},
				{
					style_id = "background_5",
					pass_type = "hotspot",
					content_id = "filter_hotspot_5"
				},
				{
					style_id = "background_5",
					pass_type = "rect",
					content_change_function = function(arg_43_0, arg_43_1)
						if arg_43_0.filter_selection and arg_43_0.filter_index == 5 or arg_43_0.filter_hotspot_5.is_hover then
							arg_43_1.color = arg_43_1.selection_color
						else
							arg_43_1.color = arg_43_1.base_color
						end
					end
				},
				{
					style_id = "game_type_label",
					pass_type = "text",
					text_id = "game_type_id"
				},
				{
					style_id = "mission_label",
					pass_type = "text",
					text_id = "mission_id"
				},
				{
					style_id = "difficulty_label",
					pass_type = "text",
					text_id = "difficulty_id"
				},
				{
					style_id = "show_lobbies_label",
					pass_type = "text",
					text_id = "show_lobbies_id"
				},
				{
					style_id = "distance_label",
					pass_type = "text",
					text_id = "distance_id"
				},
				{
					style_id = "game_type_name",
					pass_type = "text",
					text_id = "game_type_name",
					content_change_function = function(arg_44_0, arg_44_1)
						if arg_44_0.filter_hotspot_1.disable_button then
							arg_44_1.text_color = arg_44_1.disabled_color
						elseif arg_44_0.filter_selection and arg_44_0.filter_index == 1 or arg_44_0.filter_hotspot_1.is_hover then
							arg_44_1.text_color = arg_44_1.selection_color
						else
							arg_44_1.text_color = arg_44_1.base_color
						end
					end
				},
				{
					style_id = "mission_name",
					pass_type = "text",
					text_id = "mission_name",
					content_change_function = function(arg_45_0, arg_45_1)
						if arg_45_0.filter_hotspot_2.disable_button then
							arg_45_1.text_color = arg_45_1.disabled_color
						elseif arg_45_0.filter_selection and arg_45_0.filter_index == 2 or arg_45_0.filter_hotspot_2.is_hover then
							arg_45_1.text_color = arg_45_1.selection_color
						else
							arg_45_1.text_color = arg_45_1.base_color
						end
					end
				},
				{
					style_id = "difficulty_name",
					pass_type = "text",
					text_id = "difficulty_name",
					content_change_function = function(arg_46_0, arg_46_1)
						if arg_46_0.filter_hotspot_3.disable_button then
							arg_46_1.text_color = arg_46_1.disabled_color
						elseif arg_46_0.filter_selection and arg_46_0.filter_index == 3 or arg_46_0.filter_hotspot_3.is_hover then
							arg_46_1.text_color = arg_46_1.selection_color
						else
							arg_46_1.text_color = arg_46_1.base_color
						end
					end
				},
				{
					style_id = "show_lobbies_name",
					pass_type = "text",
					text_id = "show_lobbies_name",
					content_change_function = function(arg_47_0, arg_47_1)
						if arg_47_0.filter_hotspot_4.disable_button then
							arg_47_1.text_color = arg_47_1.disabled_color
						elseif arg_47_0.filter_selection and arg_47_0.filter_index == 4 or arg_47_0.filter_hotspot_4.is_hover then
							arg_47_1.text_color = arg_47_1.selection_color
						else
							arg_47_1.text_color = arg_47_1.base_color
						end
					end
				},
				{
					style_id = "distance_name",
					pass_type = "text",
					text_id = "distance_name",
					content_change_function = function(arg_48_0, arg_48_1)
						if arg_48_0.filter_hotspot_5.disable_button then
							arg_48_1.text_color = arg_48_1.disabled_color
						elseif arg_48_0.filter_selection and arg_48_0.filter_index == 5 or arg_48_0.filter_hotspot_5.is_hover then
							arg_48_1.text_color = arg_48_1.selection_color
						else
							arg_48_1.text_color = arg_48_1.base_color
						end
					end
				}
			}
		},
		content = {
			mission_name = "-",
			difficulty_name = "-",
			background_id = "rect_masked",
			game_type_name = "-",
			distance_name = "-",
			mask_id = "mask_rect",
			show_lobbies_name = "-",
			filter_hotspot_1 = {},
			filter_hotspot_2 = {},
			filter_hotspot_3 = {},
			filter_hotspot_4 = {},
			filter_hotspot_5 = {},
			game_type_id = Utf8.upper(Localize("lb_game_type")),
			mission_id = Utf8.upper(Localize("lb_mission")),
			difficulty_id = Utf8.upper(Localize("lb_difficulty")),
			show_lobbies_id = Utf8.upper(Localize("lb_show_lobbies")),
			distance_id = Utf8.upper(Localize("lb_search_distance"))
		},
		style = {
			info_bar = {
				vertical_alignment = "top",
				color = {
					224,
					0,
					0,
					0
				},
				texture_size = {
					var_0_8.window_width,
					40
				},
				offset = {
					0,
					0,
					0
				}
			},
			game_type_left_triangle = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				triangle_alignment = "top_left",
				texture_size = {
					7.5,
					10
				},
				select_color = {
					196,
					0,
					0,
					0
				},
				base_color = Colors.get_color_table_with_alpha("font_default", 128),
				color = Colors.get_color_table_with_alpha("font_default", 128),
				offset = {
					-25 + var_18_0 * 1,
					0 - var_0_8.filter_height * 1 - var_0_8.spacing * 2 - 15,
					1
				}
			},
			game_type_right_triangle = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				triangle_alignment = "top_right",
				texture_size = {
					7.5,
					10
				},
				select_color = {
					196,
					0,
					0,
					0
				},
				base_color = Colors.get_color_table_with_alpha("font_default", 128),
				color = Colors.get_color_table_with_alpha("font_default", 128),
				offset = {
					-25 + var_18_0 * 1 - 7.5,
					0 - var_0_8.filter_height * 1 - var_0_8.spacing * 2 - 15,
					1
				}
			},
			level_left_triangle = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				triangle_alignment = "top_left",
				texture_size = {
					7.5,
					10
				},
				select_color = {
					196,
					0,
					0,
					0
				},
				base_color = Colors.get_color_table_with_alpha("font_default", 128),
				color = Colors.get_color_table_with_alpha("font_default", 128),
				offset = {
					-25 + var_18_0 * 2,
					0 - var_0_8.filter_height * 1 - var_0_8.spacing * 2 - 15,
					1
				}
			},
			level_right_triangle = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				triangle_alignment = "top_right",
				texture_size = {
					7.5,
					10
				},
				select_color = {
					196,
					0,
					0,
					0
				},
				base_color = Colors.get_color_table_with_alpha("font_default", 128),
				color = Colors.get_color_table_with_alpha("font_default", 128),
				offset = {
					-25 + var_18_0 * 2 - 7.5,
					0 - var_0_8.filter_height * 1 - var_0_8.spacing * 2 - 15,
					1
				}
			},
			difficulty_left_triangle = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				triangle_alignment = "top_left",
				texture_size = {
					7.5,
					10
				},
				select_color = {
					196,
					0,
					0,
					0
				},
				base_color = Colors.get_color_table_with_alpha("font_default", 128),
				color = Colors.get_color_table_with_alpha("font_default", 128),
				offset = {
					-25 + var_18_0 * 3,
					0 - var_0_8.filter_height * 1 - var_0_8.spacing * 2 - 15,
					1
				}
			},
			difficulty_right_triangle = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				triangle_alignment = "top_right",
				texture_size = {
					7.5,
					10
				},
				select_color = {
					196,
					0,
					0,
					0
				},
				base_color = Colors.get_color_table_with_alpha("font_default", 128),
				color = Colors.get_color_table_with_alpha("font_default", 128),
				offset = {
					-25 + var_18_0 * 3 - 7.5,
					0 - var_0_8.filter_height * 1 - var_0_8.spacing * 2 - 15,
					1
				}
			},
			lobby_filter_left_triangle = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				triangle_alignment = "top_left",
				texture_size = {
					7.5,
					10
				},
				select_color = {
					196,
					0,
					0,
					0
				},
				base_color = Colors.get_color_table_with_alpha("font_default", 128),
				color = Colors.get_color_table_with_alpha("font_default", 128),
				offset = {
					-25 + var_18_0 * 4,
					0 - var_0_8.filter_height * 1 - var_0_8.spacing * 2 - 15,
					1
				}
			},
			lobby_filter_right_triangle = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				triangle_alignment = "top_right",
				texture_size = {
					7.5,
					10
				},
				select_color = {
					196,
					0,
					0,
					0
				},
				base_color = Colors.get_color_table_with_alpha("font_default", 128),
				color = Colors.get_color_table_with_alpha("font_default", 128),
				offset = {
					-25 + var_18_0 * 4 - 7.5,
					0 - var_0_8.filter_height * 1 - var_0_8.spacing * 2 - 15,
					1
				}
			},
			distance_left_triangle = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				triangle_alignment = "top_left",
				texture_size = {
					7.5,
					10
				},
				select_color = {
					196,
					0,
					0,
					0
				},
				base_color = Colors.get_color_table_with_alpha("font_default", 128),
				color = Colors.get_color_table_with_alpha("font_default", 128),
				offset = {
					-25 + var_18_0 * 5,
					0 - var_0_8.filter_height * 1 - var_0_8.spacing * 2 - 15,
					1
				}
			},
			distance_right_triangle = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				triangle_alignment = "top_right",
				texture_size = {
					7.5,
					10
				},
				select_color = {
					196,
					0,
					0,
					0
				},
				base_color = Colors.get_color_table_with_alpha("font_default", 128),
				color = Colors.get_color_table_with_alpha("font_default", 128),
				offset = {
					-25 + var_18_0 * 5 - 7.5,
					0 - var_0_8.filter_height * 1 - var_0_8.spacing * 2 - 15,
					1
				}
			},
			mask = {
				vertical_alignment = "top",
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = {
					var_0_8.window_width,
					40
				},
				offset = {
					0,
					-40 - var_0_8.spacing,
					0
				}
			},
			divider_1 = {
				vertical_alignment = "top",
				color = {
					1,
					0,
					0,
					0
				},
				texture_size = {
					var_0_8.spacing,
					40
				},
				offset = {
					var_0_8.window_width / 4,
					-40 - var_0_8.spacing,
					0
				}
			},
			divider_2 = {
				vertical_alignment = "top",
				color = {
					1,
					0,
					0,
					0
				},
				texture_size = {
					var_0_8.spacing,
					40
				},
				offset = {
					var_0_8.window_width / 4 * 2,
					-40 - var_0_8.spacing,
					0
				}
			},
			divider_3 = {
				vertical_alignment = "top",
				color = {
					1,
					0,
					0,
					0
				},
				texture_size = {
					var_0_8.spacing,
					40
				},
				offset = {
					var_0_8.window_width / 4 * 3,
					-40 - var_0_8.spacing,
					0
				}
			},
			background_1 = {
				vertical_alignment = "top",
				color = {
					196,
					0,
					0,
					0
				},
				base_color = {
					196,
					0,
					0,
					0
				},
				selection_color = {
					255,
					128,
					128,
					128
				},
				texture_size = {
					var_18_0,
					40
				},
				size = {
					var_18_0,
					40
				},
				offset = {
					0,
					var_0_6 * 3 - var_0_8.spacing,
					0
				}
			},
			background_2 = {
				vertical_alignment = "top",
				color = {
					196,
					0,
					0,
					0
				},
				base_color = {
					196,
					0,
					0,
					0
				},
				selection_color = {
					255,
					128,
					128,
					128
				},
				texture_size = {
					var_18_0 - var_0_8.spacing * 0.5,
					40
				},
				size = {
					var_18_0,
					40
				},
				offset = {
					var_18_0 * 1 + var_0_8.spacing,
					var_0_6 * 3 - var_0_8.spacing,
					0
				}
			},
			background_3 = {
				vertical_alignment = "top",
				color = {
					196,
					0,
					0,
					0
				},
				base_color = {
					196,
					0,
					0,
					0
				},
				selection_color = {
					255,
					128,
					128,
					128
				},
				texture_size = {
					var_18_0 - var_0_8.spacing * 0.5,
					40
				},
				size = {
					var_18_0,
					40
				},
				offset = {
					var_18_0 * 2 + var_0_8.spacing,
					var_0_6 * 3 - var_0_8.spacing,
					0
				}
			},
			background_4 = {
				vertical_alignment = "top",
				color = {
					196,
					0,
					0,
					0
				},
				base_color = {
					196,
					0,
					0,
					0
				},
				selection_color = {
					255,
					128,
					128,
					128
				},
				texture_size = {
					var_18_0 - var_0_8.spacing * 0.5,
					40
				},
				size = {
					var_18_0,
					40
				},
				offset = {
					var_18_0 * 3 + var_0_8.spacing,
					var_0_6 * 3 - var_0_8.spacing,
					0
				}
			},
			background_5 = {
				vertical_alignment = "top",
				color = {
					196,
					0,
					0,
					0
				},
				base_color = {
					196,
					0,
					0,
					0
				},
				selection_color = {
					255,
					128,
					128,
					128
				},
				texture_size = {
					var_18_0 - var_0_8.spacing * 0.5,
					40
				},
				size = {
					var_18_0,
					40
				},
				offset = {
					var_18_0 * 4 + var_0_8.spacing,
					var_0_6 * 3 - var_0_8.spacing,
					0
				}
			},
			game_type_label = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				localize = false,
				font_size = 24,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				size = {
					var_0_8.window_width,
					40
				},
				offset = {
					15 + var_18_0 * 0,
					158,
					1
				}
			},
			game_type_name = {
				localize = false,
				font_size = 24,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				base_color = Colors.get_color_table_with_alpha("font_default", 255),
				selection_color = Colors.get_color_table_with_alpha("black", 224),
				disabled_color = {
					255,
					60,
					60,
					60
				},
				size = {
					var_0_8.window_width,
					40
				},
				offset = {
					15 + var_18_0 * 0,
					118,
					1
				}
			},
			mission_label = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				localize = false,
				font_size = 24,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				size = {
					var_0_8.window_width,
					40
				},
				offset = {
					15 + var_18_0 * 1,
					158,
					1
				}
			},
			mission_name = {
				font_size = 24,
				localize = false,
				horizontal_alignment = "left",
				font_type = "hell_shark",
				vertical_alignment = "center",
				dynamic_font_size = true,
				area_size = {
					var_18_0 - 60,
					100
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				base_color = Colors.get_color_table_with_alpha("font_default", 255),
				selection_color = Colors.get_color_table_with_alpha("black", 224),
				disabled_color = {
					255,
					60,
					60,
					60
				},
				size = {
					var_0_8.window_width,
					40
				},
				offset = {
					15 + var_18_0 * 1,
					118,
					1
				}
			},
			difficulty_label = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				localize = false,
				font_size = 24,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				size = {
					var_0_8.window_width,
					40
				},
				offset = {
					15 + var_18_0 * 2,
					158,
					1
				}
			},
			difficulty_name = {
				localize = false,
				font_size = 24,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				base_color = Colors.get_color_table_with_alpha("font_default", 255),
				selection_color = Colors.get_color_table_with_alpha("black", 224),
				disabled_color = {
					255,
					60,
					60,
					60
				},
				size = {
					var_0_8.window_width,
					40
				},
				offset = {
					15 + var_18_0 * 2,
					118,
					1
				}
			},
			show_lobbies_label = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				localize = false,
				font_size = 24,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				size = {
					var_0_8.window_width,
					40
				},
				offset = {
					15 + var_18_0 * 3,
					158,
					1
				}
			},
			show_lobbies_name = {
				localize = false,
				font_size = 24,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				base_color = Colors.get_color_table_with_alpha("font_default", 255),
				selection_color = Colors.get_color_table_with_alpha("black", 224),
				disabled_color = {
					255,
					60,
					60,
					60
				},
				size = {
					var_0_8.window_width,
					40
				},
				offset = {
					15 + var_18_0 * 3,
					118,
					1
				}
			},
			distance_label = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				localize = false,
				font_size = 24,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				size = {
					var_0_8.window_width,
					40
				},
				offset = {
					15 + var_18_0 * 4,
					158,
					1
				}
			},
			distance_name = {
				localize = false,
				font_size = 24,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				base_color = Colors.get_color_table_with_alpha("font_default", 255),
				selection_color = Colors.get_color_table_with_alpha("black", 224),
				disabled_color = {
					255,
					60,
					60,
					60
				},
				size = {
					var_0_8.window_width,
					40
				},
				offset = {
					15 + var_18_0 * 4,
					118,
					1
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_18_0
	}
end

local function var_0_14(arg_49_0)
	local var_49_0 = var_0_8.window_height + var_0_8.filter_height + var_0_8.spacing
	local var_49_1 = math.ceil(var_49_0 / (var_0_8.filter_height + var_0_8.spacing) - 1)
	local var_49_2 = var_49_1 < arg_49_0 and math.max(var_49_0 / (arg_49_0 / var_49_1), 30) or 0
	local var_49_3 = math.clamp(arg_49_0 * (var_0_8.filter_height + var_0_8.spacing), 0, var_49_0)

	return {
		scenegraph_id = "filter_level_scroller",
		element = {
			passes = {
				{
					pass_type = "rect",
					style_id = "background"
				},
				{
					pass_type = "rect",
					style_id = "border"
				},
				{
					style_id = "scroller_hotspot",
					pass_type = "hotspot",
					content_id = "scroller_hotspot",
					content_check_function = function(arg_50_0, arg_50_1)
						return arg_50_0.parent.show_scroller and arg_50_0.parent.active
					end,
					content_change_function = function(arg_51_0, arg_51_1)
						local var_51_0 = var_0_8.window_height - var_0_8.spacing * 2
						local var_51_1 = -var_0_8.filter_height - var_0_8.spacing
						local var_51_2 = var_51_1 - arg_51_0.parent.scrollbar_progress * var_51_0
						local var_51_3 = var_51_1 - var_0_8.spacing - arg_51_0.parent.scrollbar_progress * (var_51_0 - arg_51_1.area_size[2] - var_51_1)

						arg_51_1.offset[2] = var_51_3
						arg_51_1.offset[1] = Math.is_valid(arg_51_1.offset[1]) and arg_51_1.offset[1] or 0
						arg_51_1.offset[2] = Math.is_valid(arg_51_1.offset[2]) and arg_51_1.offset[2] or 0
						arg_51_1.offset[3] = Math.is_valid(arg_51_1.offset[3]) and arg_51_1.offset[3] or 0
					end
				},
				{
					style_id = "bar_hotspot",
					pass_type = "hotspot",
					content_id = "bar_hotspot"
				},
				{
					style_id = "inner_scroller",
					pass_type = "rect",
					content_check_function = function(arg_52_0, arg_52_1)
						return arg_52_0.show_scroller and arg_52_0.active
					end,
					content_change_function = function(arg_53_0, arg_53_1)
						local var_53_0 = var_0_8.window_height - var_0_8.spacing * 2
						local var_53_1 = -var_0_8.filter_height - var_0_8.spacing
						local var_53_2 = var_53_1 - arg_53_0.scrollbar_progress * var_53_0
						local var_53_3 = var_53_1 - var_0_8.spacing - arg_53_0.scrollbar_progress * (var_53_0 - arg_53_1.texture_size[2] - var_53_1)

						arg_53_1.offset[2] = var_53_3
						arg_53_1.offset[1] = Math.is_valid(arg_53_1.offset[1]) and arg_53_1.offset[1] or 0
						arg_53_1.offset[2] = Math.is_valid(arg_53_1.offset[2]) and arg_53_1.offset[2] or 0
						arg_53_1.offset[3] = Math.is_valid(arg_53_1.offset[3]) and arg_53_1.offset[3] or 0
						arg_53_1.color = arg_53_0.scroller_hotspot.is_hover and arg_53_1.highlight_color or arg_53_1.default_color
					end
				}
			}
		},
		content = {
			active = true,
			scrollbar_progress = 0,
			show_scroller = true,
			visible = true,
			bar_hotspot = {},
			scroller_hotspot = {}
		},
		style = {
			background = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				color = {
					224,
					0,
					0,
					0
				},
				texture_size = {
					var_0_5 - var_0_8.spacing,
					var_49_3 - var_0_8.spacing
				},
				offset = {
					0,
					-var_0_8.spacing - var_0_8.filter_height,
					0
				}
			},
			bar_hotspot = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				area_size = {
					var_0_5 - var_0_8.spacing,
					var_0_8.window_height + var_0_8.filter_height
				},
				offset = {
					var_0_8.spacing,
					-var_0_8.spacing - var_0_8.filter_height,
					-1
				}
			},
			border = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				color = {
					255,
					96,
					96,
					96
				},
				texture_size = {
					var_0_5 + var_0_8.spacing * 1,
					var_49_3
				},
				offset = {
					var_0_8.spacing,
					-var_0_8.spacing - var_0_8.filter_height,
					-1
				}
			},
			scroller_hotspot = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				area_size = {
					var_0_5 - 4,
					var_49_2
				},
				offset = {
					-1,
					-var_0_8.spacing - var_0_8.filter_height,
					2
				}
			},
			inner_scroller = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					var_0_5 - 4,
					var_49_2
				},
				color = Colors.get_color_table_with_alpha("font_default", 255),
				default_color = Colors.get_color_table_with_alpha("font_default", 255),
				highlight_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					-1,
					-var_0_8.spacing - var_0_8.filter_height,
					2
				}
			}
		},
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_15(arg_54_0, arg_54_1, arg_54_2)
	local var_54_0 = var_0_8.window_width / 5
	local var_54_1 = Localize(arg_54_1)

	print(arg_54_0, arg_54_1, var_54_1)

	return {
		scenegraph_id = "filter_game_type_entry_anchor",
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "background",
					texture_id = "texture_id",
					pass_type = "texture",
					content_change_function = function(arg_55_0, arg_55_1)
						if arg_55_0.selected or arg_55_0.button_hotspot.is_hover then
							arg_55_1.color = arg_55_1.selection_color
						else
							arg_55_1.color = arg_55_1.base_color
						end
					end
				},
				{
					pass_type = "texture",
					style_id = "background_border",
					texture_id = "texture_id"
				},
				{
					style_id = "game_type",
					pass_type = "text",
					text_id = "game_type_id",
					content_change_function = function(arg_56_0, arg_56_1)
						if arg_56_0.selected or arg_56_0.button_hotspot.is_hover then
							arg_56_1.text_color = arg_56_1.selection_color
						else
							arg_56_1.text_color = arg_56_1.base_color
						end
					end
				}
			}
		},
		content = {
			texture_id = "rect_masked",
			button_hotspot = {},
			game_type_id = var_54_1,
			game_type = arg_54_0
		},
		style = {
			button_hotspot = {
				area_size = {
					var_0_8.window_width / 5,
					var_0_8.filter_height
				}
			},
			background = {
				vertical_alignment = "top",
				color = {
					255,
					96,
					96,
					96
				},
				base_color = {
					255,
					0,
					0,
					0
				},
				selection_color = {
					255,
					96,
					96,
					96
				},
				texture_size = {
					var_54_0 - var_0_8.spacing,
					var_0_8.filter_height
				},
				offset = {
					var_0_8.spacing,
					0,
					1
				}
			},
			background_border = {
				vertical_alignment = "top",
				color = {
					255,
					96,
					96,
					96
				},
				texture_size = {
					var_54_0 - var_0_8.spacing + var_0_8.spacing * 2,
					var_0_8.filter_height + var_0_8.spacing * 2
				},
				offset = {
					0,
					var_0_8.spacing,
					0
				}
			},
			game_type = {
				font_size = 28,
				localize = false,
				font_type = "hell_shark_masked",
				horizontal_alignment = "center",
				vertical_alignment = "top",
				dynamic_font_size = true,
				area_size = {
					400,
					100
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				base_color = Colors.get_color_table_with_alpha("font_default", 255),
				selection_color = Colors.get_color_table_with_alpha("black", 224),
				offset = {
					0,
					0,
					2
				}
			}
		},
		offset = {
			0,
			arg_54_2,
			0
		}
	}
end

local function var_0_16(arg_57_0, arg_57_1)
	local var_57_0 = var_0_8.window_width / 5
	local var_57_1 = arg_57_0

	if arg_57_0 ~= "any" then
		local var_57_2 = LevelSettings[arg_57_0]

		var_57_1 = Localize(var_57_2.display_name)
	else
		var_57_1 = Localize("lobby_browser_mission")
	end

	return {
		scenegraph_id = "filter_level_entry_anchor",
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "background",
					texture_id = "texture_id",
					pass_type = "texture",
					content_change_function = function(arg_58_0, arg_58_1)
						if arg_58_0.selected or arg_58_0.button_hotspot.is_hover then
							arg_58_1.color = arg_58_1.selection_color
						else
							arg_58_1.color = arg_58_1.base_color
						end
					end
				},
				{
					pass_type = "texture",
					style_id = "background_border",
					texture_id = "texture_id"
				},
				{
					style_id = "level_name",
					pass_type = "text",
					text_id = "level_name_id",
					content_check_function = function(arg_59_0, arg_59_1)
						return arg_59_0.unlocked
					end,
					content_change_function = function(arg_60_0, arg_60_1)
						if arg_60_0.selected or arg_60_0.button_hotspot.is_hover then
							arg_60_1.text_color = arg_60_1.selection_color
						else
							arg_60_1.text_color = arg_60_1.base_color
						end
					end
				},
				{
					style_id = "level_name_locked",
					pass_type = "text",
					text_id = "level_name_id",
					content_check_function = function(arg_61_0, arg_61_1)
						return not arg_61_0.unlocked
					end
				}
			}
		},
		content = {
			texture_id = "rect_masked",
			button_hotspot = {},
			level_name_id = var_57_1,
			level = arg_57_0,
			unlocked = arg_57_1
		},
		style = {
			button_hotspot = {
				area_size = {
					var_0_8.window_width / 5 - 15,
					var_0_8.filter_height
				}
			},
			background = {
				vertical_alignment = "top",
				color = {
					255,
					96,
					96,
					96
				},
				base_color = {
					255,
					0,
					0,
					0
				},
				selection_color = {
					255,
					96,
					96,
					96
				},
				texture_size = {
					var_57_0 - var_0_8.spacing - var_0_5,
					var_0_8.filter_height
				},
				offset = {
					var_0_8.spacing,
					0,
					1
				}
			},
			background_border = {
				vertical_alignment = "top",
				color = {
					255,
					96,
					96,
					96
				},
				texture_size = {
					var_57_0 - var_0_8.spacing - var_0_5 + var_0_8.spacing * 2,
					var_0_8.filter_height + var_0_8.spacing * 2
				},
				offset = {
					0,
					var_0_8.spacing,
					0
				}
			},
			level_name = {
				font_size = 28,
				localize = false,
				font_type = "hell_shark_masked",
				horizontal_alignment = "center",
				vertical_alignment = "top",
				dynamic_font_size = true,
				area_size = {
					var_57_0 - var_0_8.spacing - var_0_5 - 20,
					100
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				base_color = Colors.get_color_table_with_alpha("font_default", 255),
				selection_color = Colors.get_color_table_with_alpha("black", 224),
				offset = {
					0,
					0,
					2
				}
			},
			level_name_locked = {
				font_size = 28,
				font_type = "hell_shark_masked",
				localize = false,
				horizontal_alignment = "center",
				vertical_alignment = "top",
				dynamic_font_size = true,
				area_size = {
					var_57_0 - var_0_8.spacing - var_0_5 - 20,
					100
				},
				text_color = Colors.get_color_table_with_alpha("very_dark_gray", 255),
				offset = {
					0,
					0,
					2
				}
			}
		},
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_17(arg_62_0, arg_62_1)
	local var_62_0 = var_0_8.window_width / 5
	local var_62_1
	local var_62_2 = true

	if arg_62_0 ~= "any" then
		local var_62_3 = Managers.player:human_players()
		local var_62_4 = DifficultyManager.players_below_required_power_level(arg_62_0, var_62_3)
		local var_62_5 = DifficultySettings[arg_62_0]

		var_62_1 = Localize(var_62_5.display_name)
		var_62_2 = #var_62_4 == 0
	else
		var_62_1 = Localize("lobby_browser_mission")
	end

	return {
		scenegraph_id = "filter_difficulty_entry_anchor",
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "background",
					pass_type = "rect",
					content_change_function = function(arg_63_0, arg_63_1)
						if arg_63_0.selected or arg_63_0.button_hotspot.is_hover then
							arg_63_1.color = arg_63_1.selection_color
						else
							arg_63_1.color = arg_63_1.base_color
						end
					end
				},
				{
					pass_type = "rect",
					style_id = "background_border"
				},
				{
					style_id = "difficulty_name",
					pass_type = "text",
					text_id = "difficulty_name_id",
					content_check_function = function(arg_64_0, arg_64_1)
						return arg_64_0.unlocked
					end,
					content_change_function = function(arg_65_0, arg_65_1)
						if arg_65_0.selected or arg_65_0.button_hotspot.is_hover then
							arg_65_1.text_color = arg_65_1.selection_color
						else
							arg_65_1.text_color = arg_65_1.base_color
						end
					end
				},
				{
					style_id = "difficulty_name_locked",
					pass_type = "text",
					text_id = "difficulty_name_id",
					content_check_function = function(arg_66_0, arg_66_1)
						return not arg_66_0.unlocked
					end
				}
			}
		},
		content = {
			button_hotspot = {},
			difficulty_name_id = var_62_1,
			difficulty = arg_62_0,
			unlocked = var_62_2
		},
		style = {
			background = {
				vertical_alignment = "top",
				color = {
					255,
					96,
					96,
					96
				},
				base_color = {
					255,
					0,
					0,
					0
				},
				selection_color = {
					255,
					96,
					96,
					96
				},
				texture_size = {
					var_62_0 - var_0_8.spacing,
					var_0_8.filter_height
				},
				offset = {
					0,
					0,
					1
				}
			},
			background_border = {
				vertical_alignment = "top",
				color = {
					255,
					96,
					96,
					96
				},
				texture_size = {
					var_62_0 - var_0_8.spacing + var_0_8.spacing * 2,
					var_0_8.filter_height + var_0_8.spacing * 2
				},
				offset = {
					-var_0_8.spacing,
					var_0_8.spacing,
					0
				}
			},
			difficulty_name = {
				localize = false,
				font_size = 28,
				horizontal_alignment = "center",
				vertical_alignment = "top",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				base_color = Colors.get_color_table_with_alpha("font_default", 255),
				selection_color = Colors.get_color_table_with_alpha("black", 224),
				offset = {
					0,
					0,
					2
				}
			},
			difficulty_name_locked = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				localize = false,
				font_size = 28,
				font_type = "hell_shark_masked",
				text_color = Colors.get_color_table_with_alpha("very_dark_gray", 255),
				offset = {
					0,
					0,
					2
				}
			}
		},
		offset = {
			0,
			arg_62_1,
			0
		}
	}
end

local function var_0_18(arg_67_0, arg_67_1)
	local var_67_0 = var_0_8.window_width / 5

	return {
		scenegraph_id = "filter_lobby_entry_anchor",
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "background",
					pass_type = "rect",
					content_change_function = function(arg_68_0, arg_68_1)
						if arg_68_0.selected or arg_68_0.button_hotspot.is_hover then
							arg_68_1.color = arg_68_1.selection_color
						else
							arg_68_1.color = arg_68_1.base_color
						end
					end
				},
				{
					pass_type = "rect",
					style_id = "background_border"
				},
				{
					style_id = "lobby_filter_name",
					pass_type = "text",
					text_id = "lobby_filter_name_id",
					content_change_function = function(arg_69_0, arg_69_1)
						if arg_69_0.selected or arg_69_0.button_hotspot.is_hover then
							arg_69_1.text_color = arg_69_1.selection_color
						else
							arg_69_1.text_color = arg_69_1.base_color
						end
					end
				}
			}
		},
		content = {
			button_hotspot = {},
			lobby_filter_name_id = Localize(arg_67_0),
			lobby_filter = arg_67_0
		},
		style = {
			background = {
				vertical_alignment = "top",
				color = {
					255,
					96,
					96,
					96
				},
				base_color = {
					255,
					0,
					0,
					0
				},
				selection_color = {
					255,
					96,
					96,
					96
				},
				texture_size = {
					var_67_0 - var_0_8.spacing,
					var_0_8.filter_height
				},
				size = {
					var_67_0 - var_0_8.spacing,
					var_0_8.filter_height
				},
				offset = {
					0,
					0,
					1
				}
			},
			background_border = {
				vertical_alignment = "top",
				color = {
					255,
					96,
					96,
					96
				},
				texture_size = {
					var_67_0 - var_0_8.spacing + var_0_8.spacing * 2,
					var_0_8.filter_height + var_0_8.spacing * 2
				},
				offset = {
					-var_0_8.spacing,
					var_0_8.spacing,
					0
				}
			},
			lobby_filter_name = {
				localize = false,
				font_size = 28,
				horizontal_alignment = "center",
				vertical_alignment = "top",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				base_color = Colors.get_color_table_with_alpha("font_default", 255),
				selection_color = Colors.get_color_table_with_alpha("black", 224),
				offset = {
					0,
					0,
					2
				}
			}
		},
		offset = {
			0,
			arg_67_1,
			0
		}
	}
end

local function var_0_19(arg_70_0, arg_70_1)
	local var_70_0 = var_0_8.window_width / 5

	return {
		scenegraph_id = "filter_distance_entry_anchor",
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "background",
					pass_type = "rect",
					content_change_function = function(arg_71_0, arg_71_1)
						if arg_71_0.selected or arg_71_0.button_hotspot.is_hover then
							arg_71_1.color = arg_71_1.selection_color
						else
							arg_71_1.color = arg_71_1.base_color
						end
					end
				},
				{
					pass_type = "rect",
					style_id = "background_border"
				},
				{
					style_id = "distance_name",
					pass_type = "text",
					text_id = "distance_name_id",
					content_change_function = function(arg_72_0, arg_72_1)
						if arg_72_0.selected or arg_72_0.button_hotspot.is_hover then
							arg_72_1.text_color = arg_72_1.selection_color
						else
							arg_72_1.text_color = arg_72_1.base_color
						end
					end
				}
			}
		},
		content = {
			button_hotspot = {},
			distance_name_id = Localize(arg_70_0),
			distance = arg_70_0
		},
		style = {
			background = {
				vertical_alignment = "top",
				color = {
					255,
					96,
					96,
					96
				},
				base_color = {
					255,
					0,
					0,
					0
				},
				selection_color = {
					255,
					96,
					96,
					96
				},
				texture_size = {
					var_70_0 - var_0_8.spacing,
					var_0_8.filter_height
				},
				offset = {
					0,
					0,
					1
				}
			},
			background_border = {
				vertical_alignment = "top",
				color = {
					255,
					96,
					96,
					96
				},
				texture_size = {
					var_70_0 - var_0_8.spacing + var_0_8.spacing * 2,
					var_0_8.filter_height + var_0_8.spacing * 2
				},
				offset = {
					-var_0_8.spacing,
					var_0_8.spacing,
					0
				}
			},
			distance_name = {
				localize = false,
				font_size = 28,
				horizontal_alignment = "center",
				vertical_alignment = "top",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				base_color = Colors.get_color_table_with_alpha("font_default", 255),
				selection_color = Colors.get_color_table_with_alpha("black", 224),
				offset = {
					0,
					0,
					2
				}
			}
		},
		offset = {
			0,
			arg_70_1,
			0
		}
	}
end

local function var_0_20(arg_73_0, arg_73_1, arg_73_2, arg_73_3, arg_73_4)
	local var_73_0 = IS_WINDOWS and (arg_73_1.unique_server_name or arg_73_1.host) or arg_73_1.name or "UNKNOWN"
	local var_73_1 = var_73_0

	if arg_73_1.custom_server_name and arg_73_1.custom_server_name ~= "n/a" and arg_73_1.custom_server_name ~= "" then
		var_73_1 = string.format("%s: %s", var_73_0, arg_73_1.custom_server_name)
	end

	local var_73_2 = arg_73_1.num_players or 0
	local var_73_3 = arg_73_1.mechanism
	local var_73_4 = var_73_3 == "versus" and NetworkLookup.matchmaking_types[tonumber(arg_73_1.matchmaking_type)] == "custom"
	local var_73_5 = arg_73_1.difficulty or "UNKNOWN"
	local var_73_6 = DifficultySettings[var_73_5]

	if var_73_6 then
		local var_73_7 = var_73_6.display_name

		var_73_5 = Localize(var_73_7)
	end

	local var_73_8 = "UNKNOWN"
	local var_73_9 = "any_small_image"
	local var_73_10 = arg_73_1.selected_mission_id

	if var_73_3 == "weave" and var_73_10 ~= "" and var_73_10 ~= "false" then
		var_73_9 = "weaves_small_image"

		local var_73_11 = var_73_10
		local var_73_12 = WeaveSettings.templates[var_73_11]
		local var_73_13 = table.find(WeaveSettings.templates_ordered, var_73_12)

		if not var_73_12 then
			local var_73_14 = LevelSettings[var_73_10]

			var_73_8 = Localize(var_73_14.display_name or "UNKNOWN")
		elseif arg_73_1.weave_quick_game == "true" then
			var_73_8 = var_73_12 and Localize(var_73_12.display_name) or Localize("start_game_window_weave_quickplay_title")
		else
			var_73_8 = var_73_13 .. ". " .. Localize(var_73_12.display_name)
		end
	elseif var_73_3 == "deus" then
		var_73_9 = "deus_small_image"

		local var_73_15 = LevelSettings[var_73_10]

		var_73_8 = Localize(var_73_15.display_name or "UNKNOWN")
	elseif var_73_3 == "versus" then
		if var_73_10 and var_73_10 ~= "any" then
			local var_73_16 = LevelSettings[var_73_10]

			var_73_8 = Localize(var_73_16.display_name or "UNKNOWN")
			var_73_9 = LevelHelper:get_small_level_image(var_73_10)
		else
			var_73_9 = "any_small_image"
			var_73_8 = Localize("random_level")
		end

		if var_73_4 then
			var_73_5 = Localize("lb_game_type_versus_custom_game")
		else
			var_73_5 = Localize("carousel_keep_info")
		end
	elseif var_73_10 then
		local var_73_17 = LevelSettings[var_73_10]

		var_73_8 = Localize(var_73_17.display_name or "UNKNOWN")
		var_73_9 = LevelHelper:get_small_level_image(var_73_10)
	end

	local var_73_18 = "UNKNOWN"
	local var_73_19 = arg_73_1.mission_id

	if var_73_19 then
		local var_73_20 = var_73_19
		local var_73_21 = WeaveSettings.templates[var_73_20]

		if var_73_21 then
			var_73_20 = var_73_21.objectives[1].level_id
		end

		local var_73_22 = LevelSettings[var_73_20]
		local var_73_23 = Localize(var_73_22.display_name or "UNKNOWN")
	end

	local var_73_24 = arg_73_1.country_code and string.lower(arg_73_1.country_code) or Localize("lb_unknown")
	local var_73_25 = {
		30,
		50
	}
	local var_73_26

	if UIAtlasHelper.has_texture_by_name(var_73_24) then
		local var_73_27 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_73_24)

		var_73_25 = {
			var_73_27.size[1] * 1.5,
			var_73_27.size[2] * 1.5
		}
		var_73_26 = var_73_24
	end

	if rawget(_G, "Steam") then
		local var_73_28 = Managers.account:region()

		if (var_73_28 == "cn" or var_73_28 == "hk") and var_73_24 == "tw" then
			var_73_25 = {
				30,
				50
			}
			var_73_26 = nil
			var_73_24 = ""
		end
	end

	local var_73_29 = "map_frame_00"

	if arg_73_4 > 0 then
		local var_73_30 = DefaultDifficulties[arg_73_4]
		local var_73_31 = DifficultySettings[var_73_30].completed_frame_texture
	end

	return {
		scenegraph_id = "lobby_entry_anchor",
		element = {
			passes = {
				{
					style_id = "background",
					pass_type = "hotspot",
					content_id = "lobby_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background_id",
					content_check_function = function(arg_74_0, arg_74_1)
						return not arg_74_0.selected and not Managers.matchmaking:is_game_matchmaking()
					end
				},
				{
					style_id = "lock_icon",
					texture_id = "lock_icon_id",
					pass_type = "texture",
					content_check_function = function(arg_75_0, arg_75_1)
						return not arg_75_0.joinable
					end,
					content_change_function = function(arg_76_0, arg_76_1)
						if arg_76_0.selected or arg_76_0.lobby_hotspot.is_hover then
							arg_76_1.color = arg_76_1.selected_color
						else
							arg_76_1.color = arg_76_1.base_color
						end
					end
				},
				{
					pass_type = "texture",
					style_id = "lock_icon_shadow",
					texture_id = "lock_icon_id",
					content_check_function = function(arg_77_0, arg_77_1)
						return not arg_77_0.selected and not arg_77_0.lobby_hotspot.is_hover and not arg_77_0.joinable
					end
				},
				{
					style_id = "custom_game_settings",
					pass_type = "texture",
					texture_id = "custom_game_settings",
					content_change_function = function(arg_78_0, arg_78_1)
						if arg_78_0.selected or arg_78_0.lobby_hotspot.is_hover then
							arg_78_1.color = arg_78_1.selected_color
						else
							arg_78_1.color = arg_78_1.base_color
						end
					end,
					content_check_function = function(arg_79_0, arg_79_1)
						if not Managers.mechanism:current_mechanism_name() == "versus" then
							return false
						end

						local var_79_0 = arg_73_1.custom_game_settings

						return (var_79_0 and var_79_0 ~= "n/a" or false) and arg_79_0.joinable
					end
				},
				{
					pass_type = "texture",
					style_id = "custom_game_settings_shadow",
					texture_id = "custom_game_settings",
					content_check_function = function(arg_80_0, arg_80_1)
						if not Managers.mechanism:current_mechanism_name() == "versus" then
							return false
						end

						local var_80_0 = arg_73_1.custom_game_settings

						return (var_80_0 and var_80_0 ~= "n/a" or false) and arg_80_0.joinable
					end
				},
				{
					pass_type = "texture",
					style_id = "selected_background",
					texture_id = "background_id",
					content_check_function = function(arg_81_0, arg_81_1)
						return (arg_81_0.selected or arg_81_0.lobby_hotspot.is_hover) and not Managers.matchmaking:is_game_matchmaking()
					end
				},
				{
					pass_type = "texture",
					style_id = "disabled_background",
					texture_id = "background_id",
					content_check_function = function(arg_82_0, arg_82_1)
						return Managers.matchmaking:is_game_matchmaking()
					end
				},
				{
					style_id = "host_name",
					pass_type = "text",
					text_id = "host_name"
				},
				{
					style_id = "selected_level_name",
					pass_type = "text",
					text_id = "selected_level_name",
					content_change_function = function(arg_83_0, arg_83_1)
						if arg_83_0.joinable then
							arg_83_1.text_color = arg_83_1.joinable_color
						elseif arg_83_0.selected or arg_83_0.lobby_hotspot.is_hover then
							arg_83_1.text_color = arg_83_1.selected_unjoinable_color
						else
							arg_83_1.text_color = arg_83_1.base_color
						end
					end
				},
				{
					style_id = "selected_level_name_shadow",
					pass_type = "text",
					text_id = "selected_level_name",
					content_check_function = function(arg_84_0, arg_84_1)
						return not not arg_84_0.joinable or not arg_84_0.selected and not arg_84_0.lobby_hotspot.is_hover
					end
				},
				{
					pass_type = "texture",
					style_id = "level_image",
					texture_id = "level_image_id",
					content_check_function = function(arg_85_0, arg_85_1)
						return arg_85_0.level_image_id
					end
				},
				{
					pass_type = "texture",
					style_id = "flag",
					texture_id = "flag_id",
					content_check_function = function(arg_86_0)
						return arg_86_0.flag_id
					end
				},
				{
					style_id = "no_flag",
					pass_type = "text",
					text_id = "no_flag_id",
					content_check_function = function(arg_87_0)
						return not arg_87_0.flag_id
					end,
					content_change_function = function(arg_88_0, arg_88_1)
						if arg_88_0.joinable then
							arg_88_1.text_color = arg_88_1.joinable_color
						elseif arg_88_0.selected or arg_88_0.lobby_hotspot.is_hover then
							arg_88_1.text_color = arg_88_1.selected_unjoinable_color
						else
							arg_88_1.text_color = arg_88_1.base_color
						end
					end
				},
				{
					style_id = "no_flag_shadow",
					pass_type = "text",
					text_id = "no_flag_id",
					content_check_function = function(arg_89_0, arg_89_1)
						return (arg_89_0.joinable or not arg_89_0.selected and not arg_89_0.lobby_hotspot.is_hover) and not arg_89_0.flag_id
					end
				},
				{
					style_id = "difficulty",
					pass_type = "text",
					text_id = "difficulty_id",
					content_change_function = function(arg_90_0, arg_90_1)
						if arg_90_0.joinable then
							arg_90_1.text_color = arg_90_1.joinable_color
						elseif arg_90_0.selected or arg_90_0.lobby_hotspot.is_hover then
							arg_90_1.text_color = arg_90_1.selected_unjoinable_color
						else
							arg_90_1.text_color = arg_90_1.base_color
						end
					end
				},
				{
					style_id = "num_players",
					pass_type = "text",
					text_id = "num_players_id",
					content_change_function = function(arg_91_0, arg_91_1)
						if arg_91_0.joinable then
							arg_91_1.text_color = arg_91_1.joinable_color
						elseif arg_91_0.selected or arg_91_0.lobby_hotspot.is_hover then
							arg_91_1.text_color = arg_91_1.selected_unjoinable_color
						else
							arg_91_1.text_color = arg_91_1.base_color
						end
					end
				},
				{
					style_id = "difficulty_shadow",
					pass_type = "text",
					text_id = "difficulty_id",
					content_check_function = function(arg_92_0, arg_92_1)
						return not not arg_92_0.joinable or not arg_92_0.selected and not arg_92_0.lobby_hotspot.is_hover
					end
				},
				{
					style_id = "num_players_shadow",
					pass_type = "text",
					text_id = "num_players_id",
					content_check_function = function(arg_93_0, arg_93_1)
						return not not arg_93_0.joinable or not arg_93_0.selected and not arg_93_0.lobby_hotspot.is_hover
					end
				}
			}
		},
		content = {
			frame_id = "rect_masked",
			background_id = "rect_masked",
			selected = false,
			custom_game_settings = "versus_custom_settings",
			lock_icon_id = "lobby_icon_lock",
			lobby_hotspot = {},
			host_name = var_73_1,
			num_players_id = var_73_2 .. "/" .. (var_73_4 and "8" or "4"),
			difficulty_id = var_73_5,
			selected_level_name = var_73_8,
			current_level_name = var_73_18,
			lobby_data = arg_73_1,
			level_image_id = var_73_9,
			flag_id = var_73_26,
			flag_index = arg_73_2,
			no_flag_id = var_73_24,
			joinable = arg_73_3
		},
		style = {
			background = {
				color = {
					96,
					0,
					0,
					0
				},
				size = {
					var_0_8.width,
					var_0_8.height
				},
				offset = {
					0,
					0,
					0
				}
			},
			selected_background = {
				color = Colors.get_color_table_with_alpha("font_default", 96),
				size = {
					var_0_8.width,
					var_0_8.height
				},
				offset = {
					0,
					0,
					0
				}
			},
			disabled_background = {
				color = {
					196,
					0,
					0,
					0
				},
				size = {
					var_0_8.width,
					var_0_8.height
				},
				offset = {
					0,
					0,
					11
				}
			},
			lock_icon = {
				vertical_alignment = "center",
				masked = true,
				horizontal_alignment = "left",
				color = Colors.get_color_table_with_alpha("font_default", 96),
				base_color = Colors.get_color_table_with_alpha("font_default", 96),
				selected_color = {
					255,
					0,
					0,
					0
				},
				texture_size = {
					29,
					42
				},
				offset = {
					580,
					-0,
					3
				}
			},
			lock_icon_shadow = {
				vertical_alignment = "center",
				masked = true,
				horizontal_alignment = "left",
				color = {
					255,
					0,
					0,
					0
				},
				texture_size = {
					29,
					42
				},
				offset = {
					582,
					-0 - 2,
					2
				}
			},
			custom_game_settings = {
				vertical_alignment = "center",
				masked = true,
				horizontal_alignment = "left",
				color = Colors.get_color_table_with_alpha("font_default", 96),
				base_color = Colors.get_color_table_with_alpha("font_default", 96),
				selected_color = Colors.get_color_table_with_alpha("font_title", 255),
				texture_size = {
					45,
					45
				},
				offset = {
					570,
					-0,
					3
				}
			},
			custom_game_settings_shadow = {
				vertical_alignment = "center",
				masked = true,
				horizontal_alignment = "left",
				color = {
					255,
					0,
					0,
					0
				},
				texture_size = {
					45,
					45
				},
				offset = {
					572,
					-0 - 2,
					2
				}
			},
			host_name = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				localize = false,
				font_size = 22,
				font_type = "arial_masked",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					110 + var_0_8.spacing,
					0,
					2
				}
			},
			selected_level_name = {
				vertical_alignment = "bottom",
				localize = false,
				font_size = 32,
				horizontal_alignment = "left",
				font_type = "hell_shark_masked",
				text_color = {
					255,
					255,
					255,
					255
				},
				selected_unjoinable_color = {
					255,
					0,
					0,
					0
				},
				base_color = {
					255,
					128,
					128,
					128
				},
				joinable_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					110 + var_0_8.spacing,
					-5,
					2
				}
			},
			selected_level_name_shadow = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				localize = false,
				font_size = 32,
				font_type = "hell_shark_masked",
				text_color = {
					255,
					0,
					0,
					0
				},
				offset = {
					110 + var_0_8.spacing + 2,
					-7,
					1
				}
			},
			host_name_shadow = {
				vertical_alignment = "top",
				localize = false,
				font_size = 26,
				horizontal_alignment = "left",
				font_type = "arial_masked",
				text_color = {
					255,
					0,
					0,
					0
				},
				selected_unjoinable_color = {
					255,
					0,
					0,
					0
				},
				base_color = {
					255,
					128,
					128,
					128
				},
				joinable_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					132,
					-4,
					1
				}
			},
			difficulty = {
				vertical_alignment = "center",
				localize = false,
				font_size = 26,
				horizontal_alignment = "center",
				font_type = "hell_shark_masked",
				text_color = {
					255,
					255,
					255,
					255
				},
				selected_unjoinable_color = {
					255,
					0,
					0,
					0
				},
				base_color = {
					255,
					128,
					128,
					128
				},
				joinable_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					315,
					-4,
					2
				}
			},
			difficulty_shadow = {
				vertical_alignment = "center",
				localize = false,
				font_size = 26,
				horizontal_alignment = "center",
				font_type = "hell_shark_masked",
				text_color = {
					255,
					0,
					0,
					0
				},
				selected_unjoinable_color = {
					255,
					0,
					0,
					0
				},
				base_color = {
					255,
					128,
					128,
					128
				},
				joinable_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					317,
					-6,
					1
				}
			},
			num_players = {
				vertical_alignment = "center",
				localize = false,
				font_size = 26,
				horizontal_alignment = "left",
				font_type = "hell_shark_masked",
				text_color = {
					255,
					255,
					255,
					255
				},
				selected_unjoinable_color = {
					255,
					0,
					0,
					0
				},
				base_color = {
					255,
					128,
					128,
					128
				},
				joinable_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					1090,
					-4,
					2
				}
			},
			num_players_shadow = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				localize = false,
				font_size = 26,
				font_type = "hell_shark_masked",
				text_color = {
					255,
					0,
					0,
					0
				},
				offset = {
					1092,
					-6,
					1
				}
			},
			level_image = {
				vertical_alignment = "center",
				masked = true,
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = {
					(var_0_8.height - 10) * 1.6724137931034482,
					var_0_8.height - 10
				},
				offset = {
					10,
					0,
					1
				}
			},
			level_image_frame = {
				vertical_alignment = "center",
				masked = true,
				color = {
					255,
					0,
					0,
					0
				},
				texture_size = {
					(var_0_8.height - 10) * 1.6724137931034482 + 4,
					var_0_8.height - 10 + 4
				},
				offset = {
					8,
					0,
					0
				}
			},
			flag = {
				vertical_alignment = "center",
				masked = true,
				horizontal_alignment = "center",
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = var_73_25,
				offset = {
					105,
					0,
					10
				}
			},
			flag_shadow = {
				vertical_alignment = "center",
				color = {
					255,
					0,
					0,
					0
				},
				texture_size = {
					90,
					45
				},
				offset = {
					659,
					-4,
					9
				}
			},
			no_flag = {
				vertical_alignment = "center",
				localize = false,
				font_size = 26,
				horizontal_alignment = "center",
				font_type = "hell_shark_masked",
				text_color = {
					255,
					255,
					255,
					255
				},
				selected_unjoinable_color = {
					255,
					0,
					0,
					0
				},
				base_color = {
					255,
					128,
					128,
					128
				},
				joinable_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					110,
					-5,
					10
				}
			},
			no_flag_shadow = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				localize = false,
				font_size = 26,
				font_type = "hell_shark_masked",
				text_color = {
					255,
					0,
					0,
					0
				},
				offset = {
					112,
					-7,
					9
				}
			}
		},
		offset = {
			0,
			arg_73_0,
			0
		}
	}
end

local function var_0_21(arg_94_0)
	return {
		scenegraph_id = "lobby_entry_anchor",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background_id"
				}
			}
		},
		content = {
			background_id = "rect_masked"
		},
		style = {
			background = {
				color = {
					96,
					0,
					0,
					0
				},
				size = {
					var_0_8.width,
					var_0_8.height
				},
				offset = {
					0,
					0,
					0
				}
			}
		},
		offset = {
			0,
			arg_94_0,
			0
		}
	}
end

local function var_0_22(arg_95_0)
	return {
		scenegraph_id = "lobby_entry_anchor",
		element = {
			passes = {
				{
					style_id = "background",
					pass_type = "hotspot",
					content_id = "lobby_hotspot"
				},
				{
					style_id = "unavailable_text",
					pass_type = "text",
					text_id = "unavailable_text"
				},
				{
					style_id = "unavailable_text_shadow",
					pass_type = "text",
					text_id = "unavailable_text"
				},
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background_id",
					content_check_function = function(arg_96_0, arg_96_1)
						return not arg_96_0.selected and not arg_96_0.lobby_hotspot.is_hover or Managers.matchmaking:is_game_matchmaking()
					end
				},
				{
					pass_type = "texture",
					style_id = "selected_background",
					texture_id = "background_id",
					content_check_function = function(arg_97_0, arg_97_1)
						return (arg_97_0.selected or arg_97_0.lobby_hotspot.is_hover) and not Managers.matchmaking:is_game_matchmaking()
					end
				}
			}
		},
		content = {
			selected = false,
			background_id = "rect_masked",
			lobby_hotspot = {},
			unavailable_text = string.upper(Localize("level_display_name_unavailable"))
		},
		style = {
			background = {
				color = {
					96,
					0,
					0,
					0
				},
				size = {
					var_0_8.width,
					var_0_8.height
				},
				offset = {
					0,
					0,
					0
				}
			},
			selected_background = {
				color = {
					128,
					50,
					50,
					50
				},
				size = {
					var_0_8.width,
					var_0_8.height
				},
				offset = {
					0,
					0,
					1
				}
			},
			unavailable_text = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				localize = false,
				font_size = 24,
				font_type = "hell_shark_header_masked",
				text_color = {
					255,
					90,
					90,
					90
				},
				offset = {
					110 + var_0_8.spacing,
					-5,
					2
				}
			},
			unavailable_text_shadow = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				localize = false,
				font_size = 24,
				font_type = "hell_shark_header_masked",
				text_color = {
					255,
					20,
					20,
					20
				},
				offset = {
					110 + var_0_8.spacing + 2,
					-7,
					1
				}
			}
		},
		offset = {
			0,
			arg_95_0,
			0
		}
	}
end

local function var_0_23(arg_98_0, arg_98_1, arg_98_2)
	return {
		element = {
			passes = {
				{
					pass_type = "rounded_background",
					style_id = "background"
				},
				{
					pass_type = "rounded_background",
					style_id = "inner_background"
				},
				{
					style_id = "game_type_label",
					pass_type = "text",
					text_id = "game_type_label_id"
				},
				{
					style_id = "status_label",
					pass_type = "text",
					text_id = "status_label_id"
				},
				{
					style_id = "game_type",
					pass_type = "text",
					text_id = "game_type_id"
				},
				{
					style_id = "status",
					pass_type = "text",
					text_id = "status_id"
				}
			}
		},
		content = {
			game_type_label_id = "lb_game_type",
			status_label_id = "lb_status",
			game_type_id = "lb_game_type_none",
			status_id = "lb_in_inn"
		},
		style = {
			background = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				corner_radius = 10,
				color = {
					128,
					60,
					60,
					60
				},
				offset = {
					0,
					0,
					1
				},
				rect_size = {
					400,
					100
				}
			},
			inner_background = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				corner_radius = 10,
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					0,
					2,
					1
				},
				rect_size = {
					396,
					96
				}
			},
			game_type_label = {
				vertical_alignment = "bottom",
				upper_case = true,
				localize = true,
				horizontal_alignment = "left",
				font_size = 26,
				font_type = "hell_shark",
				text_color = {
					255,
					128,
					128,
					128
				},
				offset = {
					75,
					50,
					2
				}
			},
			status_label = {
				vertical_alignment = "bottom",
				upper_case = true,
				localize = true,
				horizontal_alignment = "left",
				font_size = 26,
				font_type = "hell_shark",
				text_color = {
					255,
					128,
					128,
					128
				},
				offset = {
					75,
					15,
					2
				}
			},
			game_type = {
				font_size = 26,
				localize = true,
				horizontal_alignment = "right",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				font_type = "hell_shark",
				scenegraph_id = arg_98_1,
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					-75,
					50,
					2
				}
			},
			status = {
				font_size = 26,
				localize = true,
				horizontal_alignment = "right",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				font_type = "hell_shark",
				scenegraph_id = arg_98_2,
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					-75,
					15,
					2
				}
			}
		},
		scenegraph_id = arg_98_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_24(arg_99_0, arg_99_1)
	return {
		element = {
			passes = {
				{
					texture_id = "background",
					style_id = "background",
					pass_type = "texture",
					content_check_function = function(arg_100_0)
						return arg_100_0.text ~= "tutorial_no_text"
					end
				},
				{
					texture_id = "icon",
					style_id = "icon",
					pass_type = "texture",
					content_check_function = function(arg_101_0)
						return arg_101_0.text ~= "tutorial_no_text"
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function(arg_102_0)
						return arg_102_0.text ~= "tutorial_no_text"
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text",
					content_check_function = function(arg_103_0)
						return arg_103_0.text ~= "tutorial_no_text"
					end
				}
			}
		},
		content = {
			text = "-",
			icon = "trial_gem",
			background = "chest_upgrade_fill_glow"
		},
		style = {
			background = {
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					0
				}
			},
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					49,
					44
				},
				color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					0,
					0,
					1
				}
			},
			text = {
				word_wrap = true,
				localize = true,
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				size = {
					arg_99_1[1] - 60,
					arg_99_1[2]
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					50,
					2,
					2
				}
			},
			text_shadow = {
				word_wrap = true,
				localize = true,
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				size = {
					arg_99_1[1] - 60,
					arg_99_1[2]
				},
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					52,
					0,
					1
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_99_0
	}
end

local function var_0_25(arg_104_0)
	local var_104_0 = {
		scenegraph_id = arg_104_0,
		element = {
			passes = {
				{
					style_id = "team_1_name",
					pass_type = "text",
					text_id = "team_1_name"
				},
				{
					style_id = "team_2_name",
					pass_type = "text",
					text_id = "team_2_name"
				}
			}
		},
		content = {
			team_1_name = "vs_team_name_1",
			team_2_name = "vs_team_name_2"
		},
		style = {
			team_1_name = {
				vertical_alignment = "top",
				upper_case = true,
				localize = true,
				horizontal_alignment = "left",
				font_size = 22,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					50,
					0,
					2
				}
			},
			team_2_name = {
				vertical_alignment = "top",
				upper_case = true,
				localize = true,
				horizontal_alignment = "right",
				font_size = 22,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					-50,
					0,
					2
				}
			}
		}
	}
	local var_104_1 = var_104_0.element.passes
	local var_104_2 = var_104_0.content
	local var_104_3 = var_104_0.style

	for iter_104_0 = 1, 2 do
		local var_104_4 = 1
		local var_104_5 = "left"

		if iter_104_0 == 2 then
			var_104_4, var_104_5 = -1, "right"
		end

		for iter_104_1 = 1, 4 do
			local var_104_6 = string.format("player_%d_%d", iter_104_0, iter_104_1)

			var_104_1[#var_104_1 + 1] = {
				pass_type = "text",
				text_id = var_104_6,
				style_id = var_104_6
			}
			var_104_2[var_104_6] = "---"
			var_104_3[var_104_6] = {
				font_size = 22,
				upper_case = false,
				localize = false,
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "arial",
				horizontal_alignment = var_104_5,
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					50 * var_104_4,
					0 - 27 * iter_104_1,
					2
				},
				area_size = {
					205,
					25
				}
			}
		end
	end

	return var_104_0
end

local function var_0_26(arg_105_0, arg_105_1)
	return {
		scenegraph_id = "details_level_decoration",
		element = {
			passes = {
				{
					pass_type = "hover"
				},
				{
					pass_type = "texture",
					texture_id = "icon"
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "tooltip_text",
					content_check_function = function(arg_106_0)
						return arg_106_0.is_hover and arg_106_0.tooltip_text
					end
				}
			}
		},
		content = {
			icon = arg_105_0 or "icons_placeholder",
			tooltip_text = arg_105_1
		},
		style = {
			tooltip_text = {
				font_type = "hell_shark",
				localize = true,
				font_size = 24,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				cursor_side = "left",
				max_width = 600,
				cursor_offset = {
					-10,
					-27
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					0,
					0,
					0
				}
			}
		}
	}
end

local function var_0_27()
	return {
		scenegraph_id = "custom_settings_frame",
		element = {
			passes = {
				{
					pass_type = "rounded_background",
					style_id = "background"
				},
				{
					pass_type = "rounded_background",
					style_id = "inner_background"
				},
				{
					pass_type = "texture",
					style_id = "mask",
					texture_id = "mask"
				}
			}
		},
		content = {
			mask = "mask_rect"
		},
		style = {
			background = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				corner_radius = 10,
				color = {
					128,
					60,
					60,
					60
				},
				offset = {
					0,
					0,
					1
				},
				rect_size = {
					430,
					130
				}
			},
			inner_background = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				corner_radius = 10,
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					0,
					2,
					1
				},
				rect_size = {
					426,
					126
				}
			},
			mask = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				corner_radius = 10,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					1
				},
				texture_size = {
					430,
					120
				}
			}
		},
		offset = {
			0,
			0,
			0
		}
	}
end

local var_0_28 = DLCSettings.carousel.custom_game_ui_settings

local function var_0_29(arg_108_0, arg_108_1, arg_108_2, arg_108_3)
	local var_108_0 = var_0_28[arg_108_0]
	local var_108_1 = var_108_0 and var_108_0.localization_options and var_108_0.localization_options[arg_108_1]

	arg_108_1 = var_108_1 and Localize(var_108_1) or arg_108_1

	return {
		scenegraph_id = "custom_settings_window",
		element = {
			passes = {
				{
					style_id = "setting_name",
					pass_type = "text",
					text_id = "setting_name"
				},
				{
					style_id = "setting_value",
					pass_type = "text",
					text_id = "setting_value"
				}
			}
		},
		content = {
			setting_name = "menu_settings_" .. arg_108_0,
			setting_value = string.format("%s", arg_108_1),
			setting_template = arg_108_2
		},
		style = {
			setting_name = {
				word_wrap = false,
				use_shadow = true,
				localize = true,
				font_size = 24,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_masked",
				area_size = {
					300,
					40
				},
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					20,
					0,
					4
				}
			},
			setting_value = {
				font_size = 24,
				upper_case = true,
				localize = false,
				use_shadow = true,
				word_wrap = false,
				horizontal_alignment = "right",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_masked",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					-20,
					0,
					4
				}
			}
		},
		offset = {
			0,
			arg_108_3,
			0
		}
	}
end

local var_0_30 = {
	font_size = 50,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = false,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		-10,
		2
	}
}
local var_0_31 = true
local var_0_32 = {
	background = UIWidgets.create_simple_rect("lobby_browser_window", {
		50,
		0,
		0,
		0
	}, -10),
	lobby_browser_background = UIWidgets.create_rect_with_outer_frame("lobby_browser_background", var_0_9.lobby_browser_background.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color),
	lobby_browser_title = UIWidgets.create_simple_text(Localize("menu_title_lobby_browser"), "lobby_browser_background", nil, nil, var_0_30),
	custom_game_divider = UIWidgets.create_simple_texture("divider_01_top", "lobby_browser_divider"),
	join_button = UIWidgets.create_default_button("join_button", var_0_9.join_button.size, nil, nil, Localize("lb_join"), 28, nil, nil, nil, var_0_31),
	refresh_button = UIWidgets.create_default_button("refresh_button", var_0_9.refresh_button.size, nil, nil, Localize("menu_description_refresh"), 28, nil, nil, nil, var_0_31),
	frame = var_0_12("lobby_browser_frame"),
	filter_frame = var_0_13("filter_base")
}
local var_0_33 = {}

for iter_0_0 = 1, #ProfilePriority do
	local var_0_34 = ProfilePriority[iter_0_0]
	local var_0_35 = SPProfiles[var_0_34]

	var_0_33[#var_0_33 + 1] = var_0_35.ui_portrait
end

local var_0_36 = 0.75
local var_0_37 = 96 * var_0_36
local var_0_38 = 112 * var_0_36
local var_0_39 = 5 * var_0_36
local var_0_40 = {
	86 * var_0_36,
	108 * var_0_36
}
local var_0_41 = 0.6
local var_0_42 = 96 * var_0_41
local var_0_43 = 112 * var_0_41
local var_0_44 = 5 * var_0_41
local var_0_45 = {
	86 * var_0_41,
	108 * var_0_41
}
local var_0_46 = {
	font_size = 28,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_47 = {
	use_shadow = true,
	upper_case = true,
	localize = false,
	font_size = 32,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_48 = {
	use_shadow = true,
	upper_case = true,
	localize = false,
	font_size = 32,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	},
	size = {
		350,
		var_0_9.weave_details_level_name[2]
	}
}
local var_0_49 = {
	font_size = 24,
	upper_case = true,
	localize = true,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = {
		255,
		255,
		62,
		62
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_50 = {
	font_size = 28,
	upper_case = false,
	localize = true,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		-5,
		2
	}
}
local var_0_51 = {
	font_size = 20,
	use_shadow = true,
	localize = true,
	dynamic_font_size_word_wrap = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_52 = {
	font_size = 24,
	upper_case = true,
	localize = true,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_53 = {
	use_shadow = true,
	upper_case = true,
	localize = true,
	font_size = 24,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		30,
		10,
		2
	}
}
local var_0_54 = {
	use_shadow = true,
	upper_case = true,
	localize = false,
	font_size = 42,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		110,
		75,
		2
	}
}
local var_0_55 = {
	level_image_frame = UIWidgets.create_simple_texture("map_frame_00", "details_level_frame"),
	level_image = UIWidgets.create_simple_texture("level_image_any", "details_level_image"),
	level_name = UIWidgets.create_simple_text(" ", "details_level_name", nil, nil, var_0_47),
	locked_reason = UIWidgets.create_simple_text("tutorial_no_text", "details_locked_reason", nil, nil, var_0_49),
	details_information = var_0_23("details_level_info", "details_game_type", "details_status"),
	twitch_logo = UIWidgets.create_simple_texture("twitch_logo_new", "twitch_logo"),
	hero_tabs = UIWidgets.create_icon_selector("details_hero_tabs", {
		var_0_37,
		var_0_38
	}, var_0_33, var_0_39, true, var_0_40, true)
}
local var_0_56 = {
	expedition_icon = UIWidgets.create_expedition_widget_func("deus_level_icon", nil, DeusJourneySettings.journey_cave, "journey_cave", {
		width = 800,
		spacing_x = 40
	}, 1.2),
	level_name = UIWidgets.create_simple_text(" ", "details_level_name", nil, nil, var_0_47),
	locked_reason = UIWidgets.create_simple_text("tutorial_no_text", "details_locked_reason", nil, nil, var_0_49),
	details_information = var_0_23("details_level_info", "details_game_type", "details_status"),
	twitch_logo = UIWidgets.create_simple_texture("twitch_logo_new", "twitch_logo"),
	hero_tabs = UIWidgets.create_icon_selector("details_hero_tabs", {
		var_0_37,
		var_0_38
	}, var_0_33, var_0_39, true, var_0_40, true)
}
local var_0_57 = {
	level_image_frame = UIWidgets.create_simple_texture("map_frame_00", "weave_details_level_frame"),
	level_image = UIWidgets.create_simple_texture("level_image_any", "weave_details_level_image"),
	wind_icon = UIWidgets.create_simple_texture("icon_wind_azyr", "wind_icon"),
	wind_icon_glow = UIWidgets.create_simple_texture("winds_icon_background_glow", "wind_icon_glow"),
	wind_icon_bg = UIWidgets.create_simple_texture("weave_item_icon_border_selected", "wind_icon_bg"),
	wind_icon_slot = UIWidgets.create_simple_texture("weave_item_icon_border_center", "wind_icon_slot"),
	wind_name = UIWidgets.create_simple_text("wind_name", "wind_name", nil, nil, var_0_46),
	level_name = UIWidgets.create_simple_text(" ", "weave_details_level_name", nil, nil, var_0_48),
	hero_tabs = UIWidgets.create_icon_selector("weave_details_hero_tabs", {
		var_0_42,
		var_0_43
	}, var_0_33, var_0_44, true, var_0_45, true),
	wind_mutator_icon = UIWidgets.create_simple_texture("icons_placeholder", "wind_mutator_icon"),
	wind_mutator_icon_frame = UIWidgets.create_simple_texture("talent_frame", "wind_mutator_icon_frame"),
	wind_mutator_title_text = UIWidgets.create_simple_text("n/a", "wind_mutator_title_text", nil, nil, var_0_50),
	wind_mutator_title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "wind_mutator_title_divider"),
	wind_mutator_description_text = UIWidgets.create_simple_text("n/a", "wind_mutator_description_text", nil, nil, var_0_51),
	objective_title_bg = UIWidgets.create_simple_texture("menu_subheader_bg", "objective_title_bg"),
	objective_title = UIWidgets.create_simple_text("weave_objective_title", "objective_title", nil, nil, var_0_52),
	objective_1 = var_0_24("objective_1", var_0_9.objective_1.size),
	objective_2 = var_0_24("objective_2", var_0_9.objective_2.size),
	locked_reason = UIWidgets.create_simple_text("tutorial_no_text", "weave_details_locked_reason", nil, nil, var_0_49),
	details_information = var_0_23("weave_details_level_info", "weave_game_type", "weave_status")
}
local var_0_58 = {
	level_image_frame = UIWidgets.create_simple_texture("map_frame_00", "details_level_frame"),
	level_image = UIWidgets.create_simple_texture("level_image_any", "details_level_image"),
	level_name = UIWidgets.create_simple_text(" ", "details_level_name", nil, nil, var_0_47),
	locked_reason = UIWidgets.create_simple_text("tutorial_no_text", "details_locked_reason", nil, nil, var_0_49),
	details_information = var_0_23("details_level_info", "details_game_type", "details_status"),
	players = var_0_25("details_players"),
	custom_level_image_frame = UIWidgets.create_simple_texture("map_frame_00", "custom_details_level_frame"),
	custom_level_image = UIWidgets.create_simple_texture("level_image_any", "custom_details_level_image"),
	custom_level_name = UIWidgets.create_simple_text("THis is a test", "custom_details_level_name", nil, nil, var_0_54),
	custom_settings = var_0_27(),
	custom_settings_label = UIWidgets.create_simple_text("versus_custom_game_custom_ruleset", "custom_settings_label", nil, nil, var_0_53),
	custom_settings_icon = UIWidgets.create_simple_texture("versus_custom_settings", "custom_settings_label", nil, nil, nil, {
		0,
		115,
		60
	}, {
		25,
		25
	})
}

return {
	animation_definitions = var_0_10,
	scenegraph_definition = var_0_9,
	base_widget_definition = var_0_32,
	adventure_details_widget_definition = var_0_55,
	weave_details_widget_definition = var_0_57,
	deus_details_widget_definition = var_0_56,
	versus_details_widget_definition = var_0_58,
	create_lobby_entry_func = var_0_20,
	create_empty_lobby_entry_func = var_0_21,
	create_unavailable_lobby_entry_func = var_0_22,
	create_game_type_filter_entry_func = var_0_15,
	create_level_filter_entry_func = var_0_16,
	create_difficulty_filter_entry_func = var_0_17,
	create_lobby_filter_entry_func = var_0_18,
	create_distance_filter_entry_func = var_0_19,
	create_level_filter_scroller_func = var_0_14,
	create_custom_setting_func = var_0_29,
	element_settings = var_0_8
}
