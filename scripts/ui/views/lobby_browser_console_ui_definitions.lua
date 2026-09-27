-- chunkname: @scripts/ui/views/lobby_browser_console_ui_definitions.lua

local num = 2
local num_2 = 10
local num_3 = 58
local num_4 = 1200
local num_5 = 520
local num_6 = 15
local num_7 = 40
local num_8 = 40
local tbl = {
	width = num_4 - num_6 - num,
	height = num_3,
	spacing = num,
	num_visible_entries = num_2,
	window_height = num_2 * num_3 + num * (num_2 - 1),
	window_width = num_4 + num_5 + num,
	filter_height = num_7,
	bottom_border_size = num_8
}
local tbl_2 = {
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
			tbl.window_width,
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
			num_4,
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
			tbl.width,
			tbl.height
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
			tbl.window_width,
			200
		},
		position = {
			0,
			80 + tbl.spacing * 2,
			20
		}
	},
	lobby_browser_window = {
		vertical_alignment = "top",
		parent = "filter_base",
		horizontal_alignment = "left",
		size = {
			num_4 + num_5 + num,
			tbl.window_height + num_7 * 3 + num * 3
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
			tbl.window_height
		},
		position = {
			num_4 + tbl.spacing,
			-40 + num,
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
			tbl.window_height
		},
		position = {
			num_4 + tbl.spacing,
			-40 + num,
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
			tbl.window_width / 5,
			tbl.filter_height
		},
		position = {
			0,
			-tbl.filter_height - tbl.spacing,
			1
		}
	},
	filter_level_entry_anchor = {
		vertical_alignment = "top",
		parent = "filter_base",
		horizontal_alignment = "left",
		size = {
			tbl.window_width / 5,
			tbl.filter_height
		},
		position = {
			tbl.window_width / 5 * 1,
			-tbl.filter_height - tbl.spacing,
			1
		}
	},
	filter_level_scroller = {
		vertical_alignment = "top",
		parent = "filter_base",
		horizontal_alignment = "left",
		size = {
			tbl.window_width / 5,
			tbl.filter_height
		},
		position = {
			tbl.window_width / 5 * 1,
			-tbl.filter_height - tbl.spacing,
			1
		}
	},
	filter_difficulty_entry_anchor = {
		vertical_alignment = "top",
		parent = "filter_base",
		horizontal_alignment = "left",
		size = {
			tbl.window_width / 5,
			tbl.filter_height
		},
		position = {
			tbl.window_width / 5 * 2 + tbl.spacing,
			-tbl.filter_height - tbl.spacing,
			1
		}
	},
	filter_lobby_entry_anchor = {
		vertical_alignment = "top",
		parent = "filter_base",
		horizontal_alignment = "left",
		size = {
			tbl.window_width / 5,
			tbl.filter_height
		},
		position = {
			tbl.window_width / 5 * 3 + tbl.spacing,
			-tbl.filter_height - tbl.spacing,
			1
		}
	},
	filter_distance_entry_anchor = {
		vertical_alignment = "top",
		parent = "filter_base",
		horizontal_alignment = "left",
		size = {
			tbl.window_width / 5,
			tbl.filter_height
		},
		position = {
			tbl.window_width / 5 * 4 + tbl.spacing,
			-tbl.filter_height - tbl.spacing,
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
local tbl_3 = {}
local tbl_4 = {}
local tbl_5 = {
	name = "fade_in",
	start_progress = 0
}
local flag

flag = not IS_WINDOWS and 0.05 and 0.5
tbl_5.end_progress = flag

tbl_5.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	arg_1_3.render_settings.alpha_multiplier = 0
end

tbl_5.update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	local easeInCubic = math.easeInCubic(arg_2_3)

	arg_2_4.render_settings.alpha_multiplier = easeInCubic
end

tbl_5.on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	return
end

tbl_4[1] = tbl_5
tbl_3.on_enter = tbl_4

local tbl_6 = {
	{
		name = "fade_out",
		start_progress = 0,
		end_progress = 0.3,
		init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
			-- function 4
			arg_4_3.render_settings.alpha_multiplier = 1
		end,
		update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
			-- function 5
			arg_5_4.render_settings.alpha_multiplier = 1
		end,
		on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
			-- function 6
			return
		end
	}
}

tbl_3.on_exit = tbl_6

local tbl_7 = {
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

local function fn(arg_7_0)
	-- function 7
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
					content_check_function = function (self, arg_8_1)
						-- function 8
						return self.filter_active
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
					content_change_function = function (self, arg_9_1)
						-- function 9
						if self.inner_scroller_hotspot.is_hover or not self.scrollbar_hotspot.is_hover then
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
					content_check_function = function (self, arg_10_1)
						-- function 10
						return self.filter_active
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
					content_change_function = function (self, arg_11_1, arg_11_2, arg_11_3)
						-- function 11
						local timer = self.timer

						timer = timer or 0
						self.timer = timer + arg_11_3

						local max = math.max(self.timer, 0)
						local floor = math.floor(max / 60)
						local floor_2 = math.floor(floor / 60)

						self.timer_text_id = string.format("%02d:%02d:%02d", floor_2, floor - floor_2 * 60, max % 60)
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
					content_check_function = function (self, arg_12_1)
						-- function 12
						local show_scroller = self.show_scroller

						show_scroller = not show_scroller and not self.filter_active

						return show_scroller
					end,
					content_change_function = function (self, arg_13_1)
						-- function 13
						local window_height = tbl.window_height
						local spacing = tbl.spacing
						local scrollbar_progress = self.scrollbar_progress
						local var_13_3 = arg_13_1.texture_size[2]
						local num = -spacing - scrollbar_progress * (window_height + var_13_3)

						arg_13_1.offset[2] = num

						local offset = arg_13_1.offset
						local var_13_6

						if not Math.is_valid(arg_13_1.offset[1]) then
							var_13_6 = arg_13_1.offset[1]

							if not var_13_6 then
								-- Nothing
							end
						end

						var_13_6 = 0

						::label_13_0::

						offset[1] = var_13_6

						local offset_2 = arg_13_1.offset
						local var_13_8

						if not Math.is_valid(arg_13_1.offset[2]) then
							var_13_8 = arg_13_1.offset[2]

							if not var_13_8 then
								-- Nothing
							end
						end

						var_13_8 = 0

						::label_13_1::

						offset_2[2] = var_13_8

						local offset_3 = arg_13_1.offset
						local var_13_10

						if not Math.is_valid(arg_13_1.offset[3]) then
							var_13_10 = arg_13_1.offset[3]

							if not var_13_10 then
								-- Nothing
							end
						end

						var_13_10 = 0

						::label_13_2::

						offset_3[3] = var_13_10
					end
				},
				{
					style_id = "inner_scroller",
					pass_type = "rect",
					content_check_function = function (self, arg_14_1)
						-- function 14
						local show_scroller = self.show_scroller

						show_scroller = not show_scroller and not self.filter_active

						return show_scroller
					end,
					content_change_function = function (self, arg_15_1)
						-- function 15
						local window_height = tbl.window_height
						local num = -tbl.spacing - self.scrollbar_progress * (window_height + arg_15_1.texture_size[2])

						arg_15_1.offset[2] = num

						local offset = arg_15_1.offset
						local var_15_3

						if not Math.is_valid(arg_15_1.offset[1]) then
							var_15_3 = arg_15_1.offset[1]

							if not var_15_3 then
								-- Nothing
							end
						end

						var_15_3 = 0

						::label_15_0::

						offset[1] = var_15_3

						local offset_2 = arg_15_1.offset
						local var_15_5

						if not Math.is_valid(arg_15_1.offset[2]) then
							var_15_5 = arg_15_1.offset[2]

							if not var_15_5 then
								-- Nothing
							end
						end

						var_15_5 = 0

						::label_15_1::

						offset_2[2] = var_15_5

						local offset_3 = arg_15_1.offset
						local var_15_7

						if not Math.is_valid(arg_15_1.offset[3]) then
							var_15_7 = arg_15_1.offset[3]

							if not var_15_7 then
								-- Nothing
							end
						end

						var_15_7 = 0

						::label_15_2::

						offset_3[3] = var_15_7

						if not self.inner_scroller_hotspot.is_hover then
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
					content_check_function = function (self, arg_16_1)
						-- function 16
						local show_scroller = self.parent.show_scroller

						show_scroller = not show_scroller and not self.parent.filter_active

						return show_scroller
					end,
					content_change_function = function (arg_17_0, arg_17_1)
						-- function 17
						local inner_scroller = arg_17_1.parent.inner_scroller

						arg_17_1.offset[2] = inner_scroller.offset[2] - arg_17_1.area_size[2]
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
					tbl.window_width + tbl.spacing * 2,
					num_7
				},
				offset = {
					-tbl.spacing,
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
					tbl.window_width,
					-tbl.window_height - num_7
				},
				offset = {
					0,
					num_7,
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
					tbl.window_width + tbl.spacing * 7,
					tbl.spacing * 2
				},
				offset = {
					-tbl.spacing * 3.5,
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
					tbl.window_width + tbl.spacing * 2,
					-num_8
				},
				offset = {
					-tbl.spacing,
					-tbl.window_height - tbl.spacing * 1.5,
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
					-tbl.window_height - 127 - num_8 - tbl.spacing * 2
				},
				offset = {
					tbl.window_width + tbl.spacing,
					124 + tbl.spacing * 2,
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
					-tbl.window_height - 127 - num_8 - tbl.spacing * 2
				},
				offset = {
					-tbl.spacing - 5,
					124 + tbl.spacing * 2,
					0
				}
			},
			details_bar = {
				texture_size = {
					num_5,
					40
				},
				color = {
					0,
					0,
					0,
					0
				},
				offset = {
					1200 + tbl.spacing,
					0,
					0
				}
			},
			scroll_bar = {
				texture_size = {
					num_6,
					-tbl.window_height
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
					num_4 - num_6,
					-tbl.spacing,
					0
				}
			},
			scrollbar_hotspot = {
				area_size = {
					num_6,
					tbl.window_height
				},
				color = {
					224,
					0,
					0,
					0
				},
				offset = {
					num_4 - num_6,
					-tbl.spacing - tbl.window_height,
					0
				}
			},
			scroller = {
				texture_size = {
					num_6,
					-100
				},
				color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					num_4 - num_6,
					-tbl.spacing,
					0
				}
			},
			inner_scroller = {
				texture_size = {
					num_6 - 4,
					-100
				},
				color = Colors.get_color_table_with_alpha("font_default", 255),
				base_color = Colors.get_color_table_with_alpha("font_default", 255),
				selected_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					num_4 - num_6 + 2,
					-tbl.spacing,
					0
				},
				base_offset = {
					num_4 - num_6 + 2,
					-tbl.spacing,
					0
				}
			},
			inner_scroller_hotspot = {
				area_size = {
					num_6 - 4,
					-100
				},
				offset = {
					num_4 - num_6 + 2,
					-tbl.spacing,
					0
				}
			},
			scroller_hotspot = {
				vertical_alignment = "bottom",
				area_size = {
					num_4,
					num_3 * num_2 + (num_2 - 1) * num
				},
				offset = {
					0,
					-tbl.window_height,
					0
				}
			},
			details_background = {
				texture_size = {
					num_5,
					-tbl.window_height
				},
				color = {
					168,
					0,
					0,
					0
				},
				offset = {
					1200 + tbl.spacing,
					-tbl.spacing,
					0
				}
			},
			mask = {
				texture_size = {
					num_4 - num_6 - tbl.spacing,
					-tbl.window_height
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					-tbl.spacing,
					0
				}
			},
			filter_mask = {
				texture_size = {
					tbl.window_width,
					-tbl.window_height - tbl.filter_height
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					-tbl.spacing + tbl.filter_height + tbl.spacing,
					5
				}
			},
			host_mask = {
				texture_size = {
					tbl.spacing * 0.33,
					-tbl.window_height
				},
				color = {
					1,
					0,
					0,
					0
				},
				offset = {
					620,
					-tbl.spacing,
					0
				}
			},
			country_mask = {
				texture_size = {
					tbl.spacing * 0.33,
					-tbl.window_height
				},
				color = {
					1,
					0,
					0,
					0
				},
				offset = {
					775,
					-tbl.spacing,
					0
				}
			},
			difficulty_mask = {
				texture_size = {
					tbl.spacing * 0.33,
					-tbl.window_height
				},
				color = {
					1,
					0,
					0,
					0
				},
				offset = {
					1030,
					-tbl.spacing,
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
					-tbl.window_height - num_8 - 2,
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
					num_4 - 105,
					-tbl.window_height - num_8 - 2,
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
					-tbl.window_height - num_8 - 2,
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

local function fn_2(arg_18_0)
	-- function 18
	local num = tbl.window_width / 5

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
					content_check_function = function (self, arg_19_1)
						-- function 19
						if not self.filter_hotspot_1.disable_button then
							return false
						else
							local is_device_active = Managers.input:is_device_active("gamepad")

							return not self.filter_selection and self.filter_index == 1 or not is_device_active
						end
					end,
					content_change_function = function (self, arg_20_1)
						-- function 20
						if not self.filter_selection and self.filter_index == 1 and not self.filter_hotspot_1.is_hover then
							arg_20_1.color = arg_20_1.select_color
						else
							arg_20_1.color = arg_20_1.base_color
						end
					end
				},
				{
					style_id = "game_type_right_triangle",
					pass_type = "triangle",
					content_check_function = function (self, arg_21_1)
						-- function 21
						if not self.filter_hotspot_1.disable_button then
							return false
						else
							local is_device_active = Managers.input:is_device_active("gamepad")

							return not self.filter_selection and self.filter_index == 1 or not is_device_active
						end
					end,
					content_change_function = function (self, arg_22_1)
						-- function 22
						if not self.filter_selection and self.filter_index == 1 and not self.filter_hotspot_1.is_hover then
							arg_22_1.color = arg_22_1.select_color
						else
							arg_22_1.color = arg_22_1.base_color
						end
					end
				},
				{
					style_id = "level_left_triangle",
					pass_type = "triangle",
					content_check_function = function (self, arg_23_1)
						-- function 23
						if not self.filter_hotspot_2.disable_button then
							return false
						else
							local is_device_active = Managers.input:is_device_active("gamepad")

							return not self.filter_selection and self.filter_index == 2 or not is_device_active
						end
					end,
					content_change_function = function (self, arg_24_1)
						-- function 24
						if not self.filter_selection and self.filter_index == 2 and not self.filter_hotspot_2.is_hover then
							arg_24_1.color = arg_24_1.select_color
						else
							arg_24_1.color = arg_24_1.base_color
						end
					end
				},
				{
					style_id = "level_right_triangle",
					pass_type = "triangle",
					content_check_function = function (self, arg_25_1)
						-- function 25
						if not self.filter_hotspot_2.disable_button then
							return false
						else
							local is_device_active = Managers.input:is_device_active("gamepad")

							return not self.filter_selection and self.filter_index == 2 or not is_device_active
						end
					end,
					content_change_function = function (self, arg_26_1)
						-- function 26
						if not self.filter_selection and self.filter_index == 2 and not self.filter_hotspot_2.is_hover then
							arg_26_1.color = arg_26_1.select_color
						else
							arg_26_1.color = arg_26_1.base_color
						end
					end
				},
				{
					style_id = "difficulty_left_triangle",
					pass_type = "triangle",
					content_check_function = function (self, arg_27_1)
						-- function 27
						if not self.filter_hotspot_3.disable_button then
							return false
						else
							local is_device_active = Managers.input:is_device_active("gamepad")

							return not self.filter_selection and self.filter_index == 3 or not is_device_active
						end
					end,
					content_change_function = function (self, arg_28_1)
						-- function 28
						if not self.filter_selection and self.filter_index == 3 and not self.filter_hotspot_3.is_hover then
							arg_28_1.color = arg_28_1.select_color
						else
							arg_28_1.color = arg_28_1.base_color
						end
					end
				},
				{
					style_id = "difficulty_right_triangle",
					pass_type = "triangle",
					content_check_function = function (self, arg_29_1)
						-- function 29
						if not self.filter_hotspot_3.disable_button then
							return false
						else
							local is_device_active = Managers.input:is_device_active("gamepad")

							return not self.filter_selection and self.filter_index == 3 or not is_device_active
						end
					end,
					content_change_function = function (self, arg_30_1)
						-- function 30
						if not self.filter_selection and self.filter_index == 3 and not self.filter_hotspot_3.is_hover then
							arg_30_1.color = arg_30_1.select_color
						else
							arg_30_1.color = arg_30_1.base_color
						end
					end
				},
				{
					style_id = "lobby_filter_left_triangle",
					pass_type = "triangle",
					content_check_function = function (self, arg_31_1)
						-- function 31
						if not self.filter_hotspot_4.disable_button then
							return false
						else
							local is_device_active = Managers.input:is_device_active("gamepad")

							return not self.filter_selection and self.filter_index == 4 or not is_device_active
						end
					end,
					content_change_function = function (self, arg_32_1)
						-- function 32
						if not self.filter_selection and self.filter_index == 4 and not self.filter_hotspot_4.is_hover then
							arg_32_1.color = arg_32_1.select_color
						else
							arg_32_1.color = arg_32_1.base_color
						end
					end
				},
				{
					style_id = "lobby_filter_right_triangle",
					pass_type = "triangle",
					content_check_function = function (self, arg_33_1)
						-- function 33
						if not self.filter_hotspot_4.disable_button then
							return false
						else
							local is_device_active = Managers.input:is_device_active("gamepad")

							return not self.filter_selection and self.filter_index == 4 or not is_device_active
						end
					end,
					content_change_function = function (self, arg_34_1)
						-- function 34
						if not self.filter_selection and self.filter_index == 4 and not self.filter_hotspot_4.is_hover then
							arg_34_1.color = arg_34_1.select_color
						else
							arg_34_1.color = arg_34_1.base_color
						end
					end
				},
				{
					style_id = "distance_left_triangle",
					pass_type = "triangle",
					content_check_function = function (self, arg_35_1)
						-- function 35
						if not self.filter_hotspot_5.disable_button then
							return false
						else
							local is_device_active = Managers.input:is_device_active("gamepad")

							return not self.filter_selection and self.filter_index == 5 or not is_device_active
						end
					end,
					content_change_function = function (self, arg_36_1)
						-- function 36
						if not self.filter_selection and self.filter_index == 5 and not self.filter_hotspot_5.is_hover then
							arg_36_1.color = arg_36_1.select_color
						else
							arg_36_1.color = arg_36_1.base_color
						end
					end
				},
				{
					style_id = "distance_right_triangle",
					pass_type = "triangle",
					content_check_function = function (self, arg_37_1)
						-- function 37
						if not self.filter_hotspot_5.disable_button then
							return false
						else
							local is_device_active = Managers.input:is_device_active("gamepad")

							return not self.filter_selection and self.filter_index == 5 or not is_device_active
						end
					end,
					content_change_function = function (self, arg_38_1)
						-- function 38
						if not self.filter_selection and self.filter_index == 5 and not self.filter_hotspot_5.is_hover then
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
					content_change_function = function (self, arg_39_1)
						-- function 39
						if not self.filter_selection and self.filter_index == 1 and not self.filter_hotspot_1.is_hover then
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
					content_change_function = function (self, arg_40_1)
						-- function 40
						if not self.filter_selection and self.filter_index == 2 and not self.filter_hotspot_2.is_hover then
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
					content_change_function = function (self, arg_41_1)
						-- function 41
						if not self.filter_selection and self.filter_index == 3 and not self.filter_hotspot_3.is_hover then
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
					content_change_function = function (self, arg_42_1)
						-- function 42
						if not self.filter_selection and self.filter_index == 4 and not self.filter_hotspot_4.is_hover then
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
					content_change_function = function (self, arg_43_1)
						-- function 43
						if not self.filter_selection and self.filter_index == 5 and not self.filter_hotspot_5.is_hover then
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
					content_change_function = function (self, arg_44_1)
						-- function 44
						if not self.filter_hotspot_1.disable_button then
							arg_44_1.text_color = arg_44_1.disabled_color
						elseif not self.filter_selection and self.filter_index == 1 and not self.filter_hotspot_1.is_hover then
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
					content_change_function = function (self, arg_45_1)
						-- function 45
						if not self.filter_hotspot_2.disable_button then
							arg_45_1.text_color = arg_45_1.disabled_color
						elseif not self.filter_selection and self.filter_index == 2 and not self.filter_hotspot_2.is_hover then
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
					content_change_function = function (self, arg_46_1)
						-- function 46
						if not self.filter_hotspot_3.disable_button then
							arg_46_1.text_color = arg_46_1.disabled_color
						elseif not self.filter_selection and self.filter_index == 3 and not self.filter_hotspot_3.is_hover then
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
					content_change_function = function (self, arg_47_1)
						-- function 47
						if not self.filter_hotspot_4.disable_button then
							arg_47_1.text_color = arg_47_1.disabled_color
						elseif not self.filter_selection and self.filter_index == 4 and not self.filter_hotspot_4.is_hover then
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
					content_change_function = function (self, arg_48_1)
						-- function 48
						if not self.filter_hotspot_5.disable_button then
							arg_48_1.text_color = arg_48_1.disabled_color
						elseif not self.filter_selection and self.filter_index == 5 and not self.filter_hotspot_5.is_hover then
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
					tbl.window_width,
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
					-25 + num * 1,
					0 - tbl.filter_height * 1 - tbl.spacing * 2 - 15,
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
					-25 + num * 1 - 7.5,
					0 - tbl.filter_height * 1 - tbl.spacing * 2 - 15,
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
					-25 + num * 2,
					0 - tbl.filter_height * 1 - tbl.spacing * 2 - 15,
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
					-25 + num * 2 - 7.5,
					0 - tbl.filter_height * 1 - tbl.spacing * 2 - 15,
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
					-25 + num * 3,
					0 - tbl.filter_height * 1 - tbl.spacing * 2 - 15,
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
					-25 + num * 3 - 7.5,
					0 - tbl.filter_height * 1 - tbl.spacing * 2 - 15,
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
					-25 + num * 4,
					0 - tbl.filter_height * 1 - tbl.spacing * 2 - 15,
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
					-25 + num * 4 - 7.5,
					0 - tbl.filter_height * 1 - tbl.spacing * 2 - 15,
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
					-25 + num * 5,
					0 - tbl.filter_height * 1 - tbl.spacing * 2 - 15,
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
					-25 + num * 5 - 7.5,
					0 - tbl.filter_height * 1 - tbl.spacing * 2 - 15,
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
					tbl.window_width,
					40
				},
				offset = {
					0,
					-40 - tbl.spacing,
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
					tbl.spacing,
					40
				},
				offset = {
					tbl.window_width / 4,
					-40 - tbl.spacing,
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
					tbl.spacing,
					40
				},
				offset = {
					tbl.window_width / 4 * 2,
					-40 - tbl.spacing,
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
					tbl.spacing,
					40
				},
				offset = {
					tbl.window_width / 4 * 3,
					-40 - tbl.spacing,
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
					num,
					40
				},
				size = {
					num,
					40
				},
				offset = {
					0,
					num_7 * 3 - tbl.spacing,
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
					num - tbl.spacing * 0.5,
					40
				},
				size = {
					num,
					40
				},
				offset = {
					num * 1 + tbl.spacing,
					num_7 * 3 - tbl.spacing,
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
					num - tbl.spacing * 0.5,
					40
				},
				size = {
					num,
					40
				},
				offset = {
					num * 2 + tbl.spacing,
					num_7 * 3 - tbl.spacing,
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
					num - tbl.spacing * 0.5,
					40
				},
				size = {
					num,
					40
				},
				offset = {
					num * 3 + tbl.spacing,
					num_7 * 3 - tbl.spacing,
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
					num - tbl.spacing * 0.5,
					40
				},
				size = {
					num,
					40
				},
				offset = {
					num * 4 + tbl.spacing,
					num_7 * 3 - tbl.spacing,
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
					tbl.window_width,
					40
				},
				offset = {
					15 + num * 0,
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
					tbl.window_width,
					40
				},
				offset = {
					15 + num * 0,
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
					tbl.window_width,
					40
				},
				offset = {
					15 + num * 1,
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
					num - 60,
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
					tbl.window_width,
					40
				},
				offset = {
					15 + num * 1,
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
					tbl.window_width,
					40
				},
				offset = {
					15 + num * 2,
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
					tbl.window_width,
					40
				},
				offset = {
					15 + num * 2,
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
					tbl.window_width,
					40
				},
				offset = {
					15 + num * 3,
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
					tbl.window_width,
					40
				},
				offset = {
					15 + num * 3,
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
					tbl.window_width,
					40
				},
				offset = {
					15 + num * 4,
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
					tbl.window_width,
					40
				},
				offset = {
					15 + num * 4,
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

local function fn_3(arg_49_0)
	-- function 49
	local num = tbl.window_height + tbl.filter_height + tbl.spacing
	local ceil = math.ceil(num / (tbl.filter_height + tbl.spacing) - 1)
	local max

	if not (ceil < arg_49_0) then
		max = math.max(num / (arg_49_0 / ceil), 30)

		if not max then
			-- Nothing
		end
	end

	max = 0

	::label_49_0::

	local clamp = math.clamp(arg_49_0 * (tbl.filter_height + tbl.spacing), 0, num)

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
					content_check_function = function (self, arg_50_1)
						-- function 50
						local show_scroller = self.parent.show_scroller

						show_scroller = not show_scroller and self.parent.active

						return show_scroller
					end,
					content_change_function = function (self, arg_51_1)
						-- function 51
						local num = tbl.window_height - tbl.spacing * 2
						local num_2 = -tbl.filter_height - tbl.spacing
						local num_3 = num_2 - self.parent.scrollbar_progress * num
						local num_4 = num_2 - tbl.spacing - self.parent.scrollbar_progress * (num - arg_51_1.area_size[2] - num_2)

						arg_51_1.offset[2] = num_4

						local offset = arg_51_1.offset
						local var_51_5

						if not Math.is_valid(arg_51_1.offset[1]) then
							var_51_5 = arg_51_1.offset[1]

							if not var_51_5 then
								-- Nothing
							end
						end

						var_51_5 = 0

						::label_51_0::

						offset[1] = var_51_5

						local offset_2 = arg_51_1.offset
						local var_51_7

						if not Math.is_valid(arg_51_1.offset[2]) then
							var_51_7 = arg_51_1.offset[2]

							if not var_51_7 then
								-- Nothing
							end
						end

						var_51_7 = 0

						::label_51_1::

						offset_2[2] = var_51_7

						local offset_3 = arg_51_1.offset
						local var_51_9

						if not Math.is_valid(arg_51_1.offset[3]) then
							var_51_9 = arg_51_1.offset[3]

							if not var_51_9 then
								-- Nothing
							end
						end

						var_51_9 = 0

						::label_51_2::

						offset_3[3] = var_51_9
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
					content_check_function = function (self, arg_52_1)
						-- function 52
						local show_scroller = self.show_scroller

						show_scroller = not show_scroller and self.active

						return show_scroller
					end,
					content_change_function = function (self, arg_53_1)
						-- function 53
						local num = tbl.window_height - tbl.spacing * 2
						local num_2 = -tbl.filter_height - tbl.spacing
						local num_3 = num_2 - self.scrollbar_progress * num
						local num_4 = num_2 - tbl.spacing - self.scrollbar_progress * (num - arg_53_1.texture_size[2] - num_2)

						arg_53_1.offset[2] = num_4

						local offset = arg_53_1.offset
						local var_53_5

						if not Math.is_valid(arg_53_1.offset[1]) then
							var_53_5 = arg_53_1.offset[1]

							if not var_53_5 then
								-- Nothing
							end
						end

						var_53_5 = 0

						::label_53_0::

						offset[1] = var_53_5

						local offset_2 = arg_53_1.offset
						local var_53_7

						if not Math.is_valid(arg_53_1.offset[2]) then
							var_53_7 = arg_53_1.offset[2]

							if not var_53_7 then
								-- Nothing
							end
						end

						var_53_7 = 0

						::label_53_1::

						offset_2[2] = var_53_7

						local offset_3 = arg_53_1.offset
						local var_53_9

						if not Math.is_valid(arg_53_1.offset[3]) then
							var_53_9 = arg_53_1.offset[3]

							if not var_53_9 then
								-- Nothing
							end
						end

						var_53_9 = 0

						::label_53_2::

						offset_3[3] = var_53_9

						local highlight_color

						if not self.scroller_hotspot.is_hover then
							highlight_color = arg_53_1.highlight_color

							if not highlight_color then
								-- Nothing
							end
						end

						highlight_color = arg_53_1.default_color

						::label_53_3::

						arg_53_1.color = highlight_color
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
					num_6 - tbl.spacing,
					clamp - tbl.spacing
				},
				offset = {
					0,
					-tbl.spacing - tbl.filter_height,
					0
				}
			},
			bar_hotspot = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				area_size = {
					num_6 - tbl.spacing,
					tbl.window_height + tbl.filter_height
				},
				offset = {
					tbl.spacing,
					-tbl.spacing - tbl.filter_height,
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
					num_6 + tbl.spacing * 1,
					clamp
				},
				offset = {
					tbl.spacing,
					-tbl.spacing - tbl.filter_height,
					-1
				}
			},
			scroller_hotspot = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				area_size = {
					num_6 - 4,
					max
				},
				offset = {
					-1,
					-tbl.spacing - tbl.filter_height,
					2
				}
			},
			inner_scroller = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					num_6 - 4,
					max
				},
				color = Colors.get_color_table_with_alpha("font_default", 255),
				default_color = Colors.get_color_table_with_alpha("font_default", 255),
				highlight_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					-1,
					-tbl.spacing - tbl.filter_height,
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

local function fn_4(arg_54_0, arg_54_1, arg_54_2)
	-- function 54
	local num = tbl.window_width / 5
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
					content_change_function = function (self, arg_55_1)
						-- function 55
						if self.selected or not self.button_hotspot.is_hover then
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
					content_change_function = function (self, arg_56_1)
						-- function 56
						if self.selected or not self.button_hotspot.is_hover then
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
					tbl.window_width / 5,
					tbl.filter_height
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
					num - tbl.spacing,
					tbl.filter_height
				},
				offset = {
					tbl.spacing,
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
					num - tbl.spacing + tbl.spacing * 2,
					tbl.filter_height + tbl.spacing * 2
				},
				offset = {
					0,
					tbl.spacing,
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

local function fn_5(arg_57_0, arg_57_1)
	-- function 57
	local num = tbl.window_width / 5
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
					content_change_function = function (self, arg_58_1)
						-- function 58
						if self.selected or not self.button_hotspot.is_hover then
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
					content_check_function = function (self, arg_59_1)
						-- function 59
						return self.unlocked
					end,
					content_change_function = function (self, arg_60_1)
						-- function 60
						if self.selected or not self.button_hotspot.is_hover then
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
					content_check_function = function (self, arg_61_1)
						-- function 61
						return not self.unlocked
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
					tbl.window_width / 5 - 15,
					tbl.filter_height
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
					num - tbl.spacing - num_6,
					tbl.filter_height
				},
				offset = {
					tbl.spacing,
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
					num - tbl.spacing - num_6 + tbl.spacing * 2,
					tbl.filter_height + tbl.spacing * 2
				},
				offset = {
					0,
					tbl.spacing,
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
					num - tbl.spacing - num_6 - 20,
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
					num - tbl.spacing - num_6 - 20,
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

local function fn_6(arg_62_0, arg_62_1)
	-- function 62
	local num = tbl.window_width / 5
	local var_62_1
	local flag = true

	if arg_62_0 ~= "any" then
		local human_players = Managers.player:human_players()
		local players_below_required_power_level = DifficultyManager.players_below_required_power_level(arg_62_0, human_players)
		local var_62_5 = DifficultySettings[arg_62_0]

		var_62_1 = Localize(var_62_5.display_name)
		flag = #players_below_required_power_level == 0
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
					content_change_function = function (self, arg_63_1)
						-- function 63
						if self.selected or not self.button_hotspot.is_hover then
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
					content_check_function = function (self, arg_64_1)
						-- function 64
						return self.unlocked
					end,
					content_change_function = function (self, arg_65_1)
						-- function 65
						if self.selected or not self.button_hotspot.is_hover then
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
					content_check_function = function (self, arg_66_1)
						-- function 66
						return not self.unlocked
					end
				}
			}
		},
		content = {
			button_hotspot = {},
			difficulty_name_id = var_62_1,
			difficulty = arg_62_0,
			unlocked = flag
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
					num - tbl.spacing,
					tbl.filter_height
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
					num - tbl.spacing + tbl.spacing * 2,
					tbl.filter_height + tbl.spacing * 2
				},
				offset = {
					-tbl.spacing,
					tbl.spacing,
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

local function fn_7(arg_67_0, arg_67_1)
	-- function 67
	local num = tbl.window_width / 5

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
					content_change_function = function (self, arg_68_1)
						-- function 68
						if self.selected or not self.button_hotspot.is_hover then
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
					content_change_function = function (self, arg_69_1)
						-- function 69
						if self.selected or not self.button_hotspot.is_hover then
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
					num - tbl.spacing,
					tbl.filter_height
				},
				size = {
					num - tbl.spacing,
					tbl.filter_height
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
					num - tbl.spacing + tbl.spacing * 2,
					tbl.filter_height + tbl.spacing * 2
				},
				offset = {
					-tbl.spacing,
					tbl.spacing,
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

local function fn_8(arg_70_0, arg_70_1)
	-- function 70
	local num = tbl.window_width / 5

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
					content_change_function = function (self, arg_71_1)
						-- function 71
						if self.selected or not self.button_hotspot.is_hover then
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
					content_change_function = function (self, arg_72_1)
						-- function 72
						if self.selected or not self.button_hotspot.is_hover then
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
					num - tbl.spacing,
					tbl.filter_height
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
					num - tbl.spacing + tbl.spacing * 2,
					tbl.filter_height + tbl.spacing * 2
				},
				offset = {
					-tbl.spacing,
					tbl.spacing,
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

local function fn_9(arg_73_0, arg_73_1, arg_73_2, arg_73_3, arg_73_4)
	-- function 73
	local unique_server_name

	if not IS_WINDOWS then
		unique_server_name = arg_73_1.unique_server_name

		if not unique_server_name then
			-- Nothing
		end

		unique_server_name = arg_73_1.host

		if not unique_server_name then
			-- Nothing
		end
	end

	unique_server_name = arg_73_1.name
	unique_server_name = unique_server_name or "UNKNOWN"

	::label_73_0::

	local var_73_1 = unique_server_name

	if not (not arg_73_1.custom_server_name and arg_73_1.custom_server_name == "n/a" or arg_73_1.custom_server_name == "") then
		var_73_1 = string.format("%s: %s", unique_server_name, arg_73_1.custom_server_name)
	end

	local num_players = arg_73_1.num_players

	num_players = num_players or 0

	local mechanism = arg_73_1.mechanism
	local flag = mechanism ~= "versus" or NetworkLookup.matchmaking_types[tonumber(arg_73_1.matchmaking_type)] == "custom"
	local difficulty = arg_73_1.difficulty

	difficulty = difficulty or "UNKNOWN"

	local var_73_6 = DifficultySettings[difficulty]

	if not var_73_6 then
		local display_name = var_73_6.display_name

		difficulty = Localize(display_name)
	end

	local str = "UNKNOWN"
	local str_2 = "any_small_image"
	local selected_mission_id = arg_73_1.selected_mission_id

	if not (mechanism ~= "weave" or selected_mission_id == "" or selected_mission_id == "false") then
		str_2 = "weaves_small_image"

		local var_73_11 = selected_mission_id
		local var_73_12 = WeaveSettings.templates[var_73_11]
		local find = table.find(WeaveSettings.templates_ordered, var_73_12)

		if not var_73_12 then
			local var_73_14 = LevelSettings[selected_mission_id]
			local Localize = Localize
			local display_name_2 = var_73_14.display_name

			display_name_2 = display_name_2 or "UNKNOWN"
			str = Localize(display_name_2)
		elseif arg_73_1.weave_quick_game == "true" then
			str = not var_73_12 and Localize(var_73_12.display_name) and Localize("start_game_window_weave_quickplay_title")
		else
			str = find .. ". " .. Localize(var_73_12.display_name)
		end
	elseif mechanism == "deus" then
		str_2 = "deus_small_image"

		local var_73_17 = LevelSettings[selected_mission_id]
		local Localize_2 = Localize
		local display_name_3 = var_73_17.display_name

		display_name_3 = display_name_3 or "UNKNOWN"
		str = Localize_2(display_name_3)
	elseif mechanism == "versus" then
		if not (not selected_mission_id and selected_mission_id == "any") then
			local var_73_20 = LevelSettings[selected_mission_id]
			local Localize_3 = Localize
			local display_name_4 = var_73_20.display_name

			display_name_4 = display_name_4 or "UNKNOWN"
			str = Localize_3(display_name_4)
			str_2 = LevelHelper:get_small_level_image(selected_mission_id)
		else
			str_2 = "any_small_image"
			str = Localize("random_level")
		end

		if not flag then
			difficulty = Localize("lb_game_type_versus_custom_game")
		else
			difficulty = Localize("carousel_keep_info")
		end
	elseif not selected_mission_id then
		local var_73_23 = LevelSettings[selected_mission_id]
		local Localize_4 = Localize
		local display_name_5 = var_73_23.display_name

		display_name_5 = display_name_5 or "UNKNOWN"
		str = Localize_4(display_name_5)
		str_2 = LevelHelper:get_small_level_image(selected_mission_id)
	end

	local str_3 = "UNKNOWN"
	local mission_id = arg_73_1.mission_id

	if not mission_id then
		local var_73_28 = mission_id
		local var_73_29 = WeaveSettings.templates[var_73_28]

		if not var_73_29 then
			var_73_28 = var_73_29.objectives[1].level_id
		end

		local var_73_30 = LevelSettings[var_73_28]
		local Localize_5 = Localize
		local display_name_6 = var_73_30.display_name

		display_name_6 = display_name_6 or "UNKNOWN"

		local var_73_33 = Localize_5(display_name_6)
	end

	local lower

	if not arg_73_1.country_code then
		lower = string.lower(arg_73_1.country_code)

		if not lower then
			-- Nothing
		end
	end

	lower = Localize("lb_unknown")

	::label_73_1::

	local tbl_2 = {
		30,
		50
	}
	local var_73_36

	if not UIAtlasHelper.has_texture_by_name(lower) then
		local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(lower)

		tbl_2 = {
			get_atlas_settings_by_texture_name.size[1] * 1.5,
			get_atlas_settings_by_texture_name.size[2] * 1.5
		}
		var_73_36 = lower
	end

	if not rawget(_G, "Steam") then
		local region = Managers.account:region()

		if not ((region == "cn" or region == "hk") and lower ~= "tw") then
			tbl_2 = {
				30,
				50
			}
			var_73_36 = nil
			lower = ""
		end
	end

	local str_4 = "map_frame_00"

	if arg_73_4 > 0 then
		local var_73_40 = DefaultDifficulties[arg_73_4]
		local completed_frame_texture = DifficultySettings[var_73_40].completed_frame_texture
	end

	local tbl_3 = {
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
					content_check_function = function (self, arg_74_1)
						-- function 74
						return not not self.selected or not Managers.matchmaking:is_game_matchmaking()
					end
				},
				{
					style_id = "lock_icon",
					texture_id = "lock_icon_id",
					pass_type = "texture",
					content_check_function = function (self, arg_75_1)
						-- function 75
						return not self.joinable
					end,
					content_change_function = function (self, arg_76_1)
						-- function 76
						if self.selected or not self.lobby_hotspot.is_hover then
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
					content_check_function = function (self, arg_77_1)
						-- function 77
						return not not self.selected or not not self.lobby_hotspot.is_hover or not self.joinable
					end
				},
				{
					style_id = "custom_game_settings",
					pass_type = "texture",
					texture_id = "custom_game_settings",
					content_change_function = function (self, arg_78_1)
						-- function 78
						if self.selected or not self.lobby_hotspot.is_hover then
							arg_78_1.color = arg_78_1.selected_color
						else
							arg_78_1.color = arg_78_1.base_color
						end
					end,
					content_check_function = function (self, arg_79_1)
						-- function 79
						if not Managers.mechanism:current_mechanism_name() == "versus" then
							return false
						end

						local custom_game_settings = arg_73_1.custom_game_settings

						return not (not custom_game_settings and custom_game_settings ~= "n/a" or false) and self.joinable
					end
				},
				{
					pass_type = "texture",
					style_id = "custom_game_settings_shadow",
					texture_id = "custom_game_settings",
					content_check_function = function (self, arg_80_1)
						-- function 80
						if not Managers.mechanism:current_mechanism_name() == "versus" then
							return false
						end

						local custom_game_settings = arg_73_1.custom_game_settings

						return not (not custom_game_settings and custom_game_settings ~= "n/a" or false) and self.joinable
					end
				},
				{
					pass_type = "texture",
					style_id = "selected_background",
					texture_id = "background_id",
					content_check_function = function (self, arg_81_1)
						-- function 81
						local is_hover

						if not self.selected then
							is_hover = self.lobby_hotspot.is_hover

							if not is_hover then
								-- Nothing
							end
						end

						is_hover = not Managers.matchmaking:is_game_matchmaking()

						::label_81_0::

						return is_hover
					end
				},
				{
					pass_type = "texture",
					style_id = "disabled_background",
					texture_id = "background_id",
					content_check_function = function (arg_82_0, arg_82_1)
						-- function 82
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
					content_change_function = function (self, arg_83_1)
						-- function 83
						if not self.joinable then
							arg_83_1.text_color = arg_83_1.joinable_color
						elseif self.selected or not self.lobby_hotspot.is_hover then
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
					content_check_function = function (self, arg_84_1)
						-- function 84
						return not not self.joinable or not not self.selected or not self.lobby_hotspot.is_hover
					end
				},
				{
					pass_type = "texture",
					style_id = "level_image",
					texture_id = "level_image_id",
					content_check_function = function (self, arg_85_1)
						-- function 85
						return self.level_image_id
					end
				},
				{
					pass_type = "texture",
					style_id = "flag",
					texture_id = "flag_id",
					content_check_function = function (self)
						-- function 86
						return self.flag_id
					end
				},
				{
					style_id = "no_flag",
					pass_type = "text",
					text_id = "no_flag_id",
					content_check_function = function (self)
						-- function 87
						return not self.flag_id
					end,
					content_change_function = function (self, arg_88_1)
						-- function 88
						if not self.joinable then
							arg_88_1.text_color = arg_88_1.joinable_color
						elseif self.selected or not self.lobby_hotspot.is_hover then
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
					content_check_function = function (self, arg_89_1)
						-- function 89
						return (self.joinable or not not self.selected or not self.lobby_hotspot.is_hover) and not self.flag_id
					end
				},
				{
					style_id = "difficulty",
					pass_type = "text",
					text_id = "difficulty_id",
					content_change_function = function (self, arg_90_1)
						-- function 90
						if not self.joinable then
							arg_90_1.text_color = arg_90_1.joinable_color
						elseif self.selected or not self.lobby_hotspot.is_hover then
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
					content_change_function = function (self, arg_91_1)
						-- function 91
						if not self.joinable then
							arg_91_1.text_color = arg_91_1.joinable_color
						elseif self.selected or not self.lobby_hotspot.is_hover then
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
					content_check_function = function (self, arg_92_1)
						-- function 92
						return not not self.joinable or not not self.selected or not self.lobby_hotspot.is_hover
					end
				},
				{
					style_id = "num_players_shadow",
					pass_type = "text",
					text_id = "num_players_id",
					content_check_function = function (self, arg_93_1)
						-- function 93
						return not not self.joinable or not not self.selected or not self.lobby_hotspot.is_hover
					end
				}
			}
		}
	}
	local tbl_4 = {
		frame_id = "rect_masked",
		background_id = "rect_masked",
		selected = false,
		custom_game_settings = "versus_custom_settings",
		lock_icon_id = "lobby_icon_lock",
		lobby_hotspot = {},
		host_name = var_73_1
	}
	local var_73_44 = num_players
	local str_5 = "/"
	local flag_2

	flag_2 = not flag and "8" and "4"
	tbl_4.num_players_id = var_73_44 .. str_5 .. flag_2
	tbl_4.difficulty_id = difficulty
	tbl_4.selected_level_name = str
	tbl_4.current_level_name = str_3
	tbl_4.lobby_data = arg_73_1
	tbl_4.level_image_id = str_2
	tbl_4.flag_id = var_73_36
	tbl_4.flag_index = arg_73_2
	tbl_4.no_flag_id = lower
	tbl_4.joinable = arg_73_3
	tbl_3.content = tbl_4
	tbl_3.style = {
		background = {
			color = {
				96,
				0,
				0,
				0
			},
			size = {
				tbl.width,
				tbl.height
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
				tbl.width,
				tbl.height
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
				tbl.width,
				tbl.height
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
				110 + tbl.spacing,
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
				110 + tbl.spacing,
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
				110 + tbl.spacing + 2,
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
				(tbl.height - 10) * 1.6724137931034482,
				tbl.height - 10
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
				(tbl.height - 10) * 1.6724137931034482 + 4,
				tbl.height - 10 + 4
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
			texture_size = tbl_2,
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
	}
	tbl_3.offset = {
		0,
		arg_73_0,
		0
	}

	return tbl_3
end

local function fn_10(arg_94_0)
	-- function 94
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
					tbl.width,
					tbl.height
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

local function fn_11(arg_95_0)
	-- function 95
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
					content_check_function = function (self, arg_96_1)
						-- function 96
						return (self.selected or not self.lobby_hotspot.is_hover) and Managers.matchmaking:is_game_matchmaking()
					end
				},
				{
					pass_type = "texture",
					style_id = "selected_background",
					texture_id = "background_id",
					content_check_function = function (self, arg_97_1)
						-- function 97
						local is_hover

						if not self.selected then
							is_hover = self.lobby_hotspot.is_hover

							if not is_hover then
								-- Nothing
							end
						end

						is_hover = not Managers.matchmaking:is_game_matchmaking()

						::label_97_0::

						return is_hover
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
					tbl.width,
					tbl.height
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
					tbl.width,
					tbl.height
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
					110 + tbl.spacing,
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
					110 + tbl.spacing + 2,
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

local function fn_12(arg_98_0, arg_98_1, arg_98_2)
	-- function 98
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

local function fn_13(arg_99_0, arg_99_1)
	-- function 99
	return {
		element = {
			passes = {
				{
					texture_id = "background",
					style_id = "background",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 100
						return self.text ~= "tutorial_no_text"
					end
				},
				{
					texture_id = "icon",
					style_id = "icon",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 101
						return self.text ~= "tutorial_no_text"
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 102
						return self.text ~= "tutorial_no_text"
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 103
						return self.text ~= "tutorial_no_text"
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

local function fn_14(arg_104_0)
	-- function 104
	local tbl = {
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
	local passes = tbl.element.passes
	local content = tbl.content
	local style = tbl.style

	for i = 1, 2 do
		local num = 1
		local str = "left"

		if i == 2 then
			num, str = -1, "right"
		end

		for j = 1, 4 do
			local format = string.format("player_%d_%d", i, j)

			passes[#passes + 1] = {
				pass_type = "text",
				text_id = format,
				style_id = format
			}
			content[format] = "---"
			style[format] = {
				font_size = 22,
				upper_case = false,
				localize = false,
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "arial",
				horizontal_alignment = str,
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					50 * num,
					0 - 27 * j,
					2
				},
				area_size = {
					205,
					25
				}
			}
		end
	end

	return tbl
end

local function fn_15(arg_105_0, arg_105_1)
	-- function 105
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
					content_check_function = function (self)
						-- function 106
						local is_hover = self.is_hover

						is_hover = not is_hover and self.tooltip_text

						return is_hover
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

local function fn_16()
	-- function 107
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

local custom_game_ui_settings = DLCSettings.carousel.custom_game_ui_settings

local function fn_17(arg_108_0, arg_108_1, arg_108_2, arg_108_3)
	-- function 108
	local var_108_0 = custom_game_ui_settings[arg_108_0]

	if not var_108_0 then
		-- Nothing
	end

	::label_108_0::

	local localization_options = var_108_0.localization_options

	localization_options = not localization_options and var_108_0.localization_options[arg_108_1]

	::label_108_1::

	arg_108_1 = not localization_options and Localize(localization_options) and arg_108_1

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

local tbl_8 = {
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
local flag_2 = true
local tbl_9 = {
	background = UIWidgets.create_simple_rect("lobby_browser_window", {
		50,
		0,
		0,
		0
	}, -10),
	lobby_browser_background = UIWidgets.create_rect_with_outer_frame("lobby_browser_background", tbl_2.lobby_browser_background.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color),
	lobby_browser_title = UIWidgets.create_simple_text(Localize("menu_title_lobby_browser"), "lobby_browser_background", nil, nil, tbl_8),
	custom_game_divider = UIWidgets.create_simple_texture("divider_01_top", "lobby_browser_divider"),
	join_button = UIWidgets.create_default_button("join_button", tbl_2.join_button.size, nil, nil, Localize("lb_join"), 28, nil, nil, nil, flag_2),
	refresh_button = UIWidgets.create_default_button("refresh_button", tbl_2.refresh_button.size, nil, nil, Localize("menu_description_refresh"), 28, nil, nil, nil, flag_2),
	frame = fn("lobby_browser_frame"),
	filter_frame = fn_2("filter_base")
}
local tbl_10 = {}

for i = 1, #ProfilePriority do
	local var_0_38 = ProfilePriority[i]
	local var_0_39 = SPProfiles[var_0_38]

	tbl_10[#tbl_10 + 1] = var_0_39.ui_portrait
end

local num_9 = 0.75
local num_10 = 96 * num_9
local num_11 = 112 * num_9
local num_12 = 5 * num_9
local tbl_11 = {
	86 * num_9,
	108 * num_9
}
local num_13 = 0.6
local num_14 = 96 * num_13
local num_15 = 112 * num_13
local num_16 = 5 * num_13
local tbl_12 = {
	86 * num_13,
	108 * num_13
}
local tbl_13 = {
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
local tbl_14 = {
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
local tbl_15 = {
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
		tbl_2.weave_details_level_name[2]
	}
}
local tbl_16 = {
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
local tbl_17 = {
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
local tbl_18 = {
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
local tbl_19 = {
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
local tbl_20 = {
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
local tbl_21 = {
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
local tbl_22 = {
	level_image_frame = UIWidgets.create_simple_texture("map_frame_00", "details_level_frame"),
	level_image = UIWidgets.create_simple_texture("level_image_any", "details_level_image"),
	level_name = UIWidgets.create_simple_text(" ", "details_level_name", nil, nil, tbl_14),
	locked_reason = UIWidgets.create_simple_text("tutorial_no_text", "details_locked_reason", nil, nil, tbl_16),
	details_information = fn_12("details_level_info", "details_game_type", "details_status"),
	twitch_logo = UIWidgets.create_simple_texture("twitch_logo_new", "twitch_logo"),
	hero_tabs = UIWidgets.create_icon_selector("details_hero_tabs", {
		num_10,
		num_11
	}, tbl_10, num_12, true, tbl_11, true)
}
local tbl_23 = {
	expedition_icon = UIWidgets.create_expedition_widget_func("deus_level_icon", nil, DeusJourneySettings.journey_cave, "journey_cave", {
		width = 800,
		spacing_x = 40
	}, 1.2),
	level_name = UIWidgets.create_simple_text(" ", "details_level_name", nil, nil, tbl_14),
	locked_reason = UIWidgets.create_simple_text("tutorial_no_text", "details_locked_reason", nil, nil, tbl_16),
	details_information = fn_12("details_level_info", "details_game_type", "details_status"),
	twitch_logo = UIWidgets.create_simple_texture("twitch_logo_new", "twitch_logo"),
	hero_tabs = UIWidgets.create_icon_selector("details_hero_tabs", {
		num_10,
		num_11
	}, tbl_10, num_12, true, tbl_11, true)
}
local tbl_24 = {
	level_image_frame = UIWidgets.create_simple_texture("map_frame_00", "weave_details_level_frame"),
	level_image = UIWidgets.create_simple_texture("level_image_any", "weave_details_level_image"),
	wind_icon = UIWidgets.create_simple_texture("icon_wind_azyr", "wind_icon"),
	wind_icon_glow = UIWidgets.create_simple_texture("winds_icon_background_glow", "wind_icon_glow"),
	wind_icon_bg = UIWidgets.create_simple_texture("weave_item_icon_border_selected", "wind_icon_bg"),
	wind_icon_slot = UIWidgets.create_simple_texture("weave_item_icon_border_center", "wind_icon_slot"),
	wind_name = UIWidgets.create_simple_text("wind_name", "wind_name", nil, nil, tbl_13),
	level_name = UIWidgets.create_simple_text(" ", "weave_details_level_name", nil, nil, tbl_15),
	hero_tabs = UIWidgets.create_icon_selector("weave_details_hero_tabs", {
		num_14,
		num_15
	}, tbl_10, num_16, true, tbl_12, true),
	wind_mutator_icon = UIWidgets.create_simple_texture("icons_placeholder", "wind_mutator_icon"),
	wind_mutator_icon_frame = UIWidgets.create_simple_texture("talent_frame", "wind_mutator_icon_frame"),
	wind_mutator_title_text = UIWidgets.create_simple_text("n/a", "wind_mutator_title_text", nil, nil, tbl_17),
	wind_mutator_title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "wind_mutator_title_divider"),
	wind_mutator_description_text = UIWidgets.create_simple_text("n/a", "wind_mutator_description_text", nil, nil, tbl_18),
	objective_title_bg = UIWidgets.create_simple_texture("menu_subheader_bg", "objective_title_bg"),
	objective_title = UIWidgets.create_simple_text("weave_objective_title", "objective_title", nil, nil, tbl_19),
	objective_1 = fn_13("objective_1", tbl_2.objective_1.size),
	objective_2 = fn_13("objective_2", tbl_2.objective_2.size),
	locked_reason = UIWidgets.create_simple_text("tutorial_no_text", "weave_details_locked_reason", nil, nil, tbl_16),
	details_information = fn_12("weave_details_level_info", "weave_game_type", "weave_status")
}
local tbl_25 = {
	level_image_frame = UIWidgets.create_simple_texture("map_frame_00", "details_level_frame"),
	level_image = UIWidgets.create_simple_texture("level_image_any", "details_level_image"),
	level_name = UIWidgets.create_simple_text(" ", "details_level_name", nil, nil, tbl_14),
	locked_reason = UIWidgets.create_simple_text("tutorial_no_text", "details_locked_reason", nil, nil, tbl_16),
	details_information = fn_12("details_level_info", "details_game_type", "details_status"),
	players = fn_14("details_players"),
	custom_level_image_frame = UIWidgets.create_simple_texture("map_frame_00", "custom_details_level_frame"),
	custom_level_image = UIWidgets.create_simple_texture("level_image_any", "custom_details_level_image"),
	custom_level_name = UIWidgets.create_simple_text("THis is a test", "custom_details_level_name", nil, nil, tbl_21),
	custom_settings = fn_16(),
	custom_settings_label = UIWidgets.create_simple_text("versus_custom_game_custom_ruleset", "custom_settings_label", nil, nil, tbl_20),
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
	animation_definitions = tbl_3,
	scenegraph_definition = tbl_2,
	base_widget_definition = tbl_9,
	adventure_details_widget_definition = tbl_22,
	weave_details_widget_definition = tbl_24,
	deus_details_widget_definition = tbl_23,
	versus_details_widget_definition = tbl_25,
	create_lobby_entry_func = fn_9,
	create_empty_lobby_entry_func = fn_10,
	create_unavailable_lobby_entry_func = fn_11,
	create_game_type_filter_entry_func = fn_4,
	create_level_filter_entry_func = fn_5,
	create_difficulty_filter_entry_func = fn_6,
	create_lobby_filter_entry_func = fn_7,
	create_distance_filter_entry_func = fn_8,
	create_level_filter_scroller_func = fn_3,
	create_custom_setting_func = fn_17,
	element_settings = tbl
}
