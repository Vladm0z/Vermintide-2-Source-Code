-- chunkname: @scripts/ui/views/lobby_item_list.lua

require("foundation/scripts/util/local_require")
require("scripts/managers/telemetry/iso_country_names")
require("scripts/settings/level_settings")

local game_start_windows = UISettings.game_start_windows
local background = game_start_windows.background
local frame = game_start_windows.frame
local size = game_start_windows.size
local spacing = game_start_windows.spacing
local var_0_5 = UIFrameSettings[frame].texture_sizes.vertical[1]
local var_0_6 = UIFrameSettings[frame].texture_sizes.horizontal[2]
local num = size[1] + spacing
local num_2 = size[1] - (var_0_5 * 2 + 60)
local large_window_frame = game_start_windows.large_window_frame
local var_0_10 = UIFrameSettings[large_window_frame].texture_sizes.vertical[1]
local tbl = {
	size[1] * 3 + spacing * 2 + var_0_10 * 2,
	size[2] + var_0_10 * 2
}
local tbl_2 = {
	400,
	tbl[2]
}
local tbl_3 = {
	400,
	tbl[2]
}
local tbl_4 = {
	tbl[1] - tbl_2[1] - tbl_3[1] + 12,
	tbl[2] - 60
}
local tbl_5 = {
	height_spacing = 7,
	height = 45,
	width = tbl_4[1] - 50
}
local tbl_6 = {
	font_size = 18
}
local num_3 = 22
local num_4 = 100
local num_5 = 5
local tbl_7 = {
	20,
	0,
	2
}
local tbl_8 = {
	tbl_4[1] * 0.3,
	0,
	2
}
local tbl_9 = {
	tbl_4[1] * 0.6,
	0,
	2
}
local tbl_10 = {
	tbl_4[1] * 0.8,
	0,
	2
}
local tbl_11 = {
	tbl_4[1] * 0.6,
	0,
	2
}
local tbl_12 = {
	-5,
	0,
	2
}
local tbl_13 = {
	-50,
	0,
	2
}
local tbl_14 = {
	tbl_8[1] - 25,
	10,
	3
}
local tbl_15 = {
	tbl_9[1] - 25,
	10,
	3
}
local tbl_16 = {
	tbl_11[1] - 25,
	10,
	3
}
local tbl_17 = {
	scenegraph_definition = {
		root = {
			is_root = true,
			size = {
				1920,
				1080
			},
			position = {
				0,
				0,
				UILayer.default + 20
			}
		},
		menu_root = {
			vertical_alignment = "center",
			parent = "root",
			horizontal_alignment = "center",
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
		window = {
			vertical_alignment = "center",
			parent = "menu_root",
			horizontal_alignment = "center",
			size = tbl,
			position = {
				0,
				0,
				1
			}
		},
		item_list = {
			vertical_alignment = "bottom",
			parent = "window",
			horizontal_alignment = "left",
			size = {
				tbl_4[1],
				tbl_4[2]
			},
			position = {
				tbl_2[1] + 8,
				12,
				1
			}
		},
		loading_overlay = {
			vertical_alignment = "bottom",
			parent = "item_list",
			horizontal_alignment = "left",
			size = {
				tbl_4[1] - 16,
				tbl_4[2] + 7
			},
			position = {
				-4,
				-8,
				6
			}
		},
		loading_icon = {
			vertical_alignment = "center",
			parent = "loading_overlay",
			horizontal_alignment = "center",
			position = {
				0,
				0,
				1
			},
			size = {
				50,
				50
			}
		},
		loading_text = {
			vertical_alignment = "center",
			parent = "loading_icon",
			horizontal_alignment = "center",
			position = {
				0,
				-90,
				1
			},
			size = {
				800,
				50
			}
		},
		scrollbar_root = {
			vertical_alignment = "top",
			parent = "item_list",
			horizontal_alignment = "right",
			position = {
				-24,
				-7,
				20
			},
			size = {
				22,
				520
			}
		},
		label_root = {
			vertical_alignment = "top",
			parent = "item_list",
			horizontal_alignment = "left",
			position = {
				0,
				35,
				0
			},
			size = {
				tbl_4[1],
				40
			}
		},
		host_text_button = {
			vertical_alignment = "top",
			parent = "label_root",
			horizontal_alignment = "left",
			position = tbl_7,
			size = {
				100,
				40
			}
		},
		level_text_button = {
			parent = "label_root",
			horizontal_alignment = "left",
			position = tbl_8,
			size = {
				100,
				40
			}
		},
		difficulty_text_button = {
			parent = "label_root",
			horizontal_alignment = "left",
			position = tbl_9,
			size = {
				130,
				40
			}
		},
		players_text_button = {
			parent = "label_root",
			horizontal_alignment = "left",
			position = tbl_10,
			size = {
				120,
				40
			}
		}
	},
	widget_definitions = {
		inventory_list_widget = {
			scenegraph_id = "item_list",
			element = {
				passes = {
					{
						style_id = "list_style",
						pass_type = "list_pass",
						content_id = "list_content",
						passes = {
							{
								style_id = "background",
								pass_type = "hotspot",
								content_id = "button_hotspot"
							},
							{
								pass_type = "on_click",
								click_check_content_id = "button_hotspot",
								click_function = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
									-- function 1
									arg_1_2.button_hotspot.is_selected = true
								end
							},
							{
								pass_type = "texture_frame",
								style_id = "frame",
								texture_id = "frame"
							},
							{
								pass_type = "texture",
								style_id = "background",
								texture_id = "background_normal_hover",
								content_check_function = function (self)
									-- function 2
									local button_hotspot = self.button_hotspot
									local is_hover = button_hotspot.is_hover

									is_hover = not is_hover and not button_hotspot.is_selected

									return is_hover
								end
							},
							{
								pass_type = "texture",
								style_id = "background",
								texture_id = "background_selected",
								content_check_function = function (self)
									-- function 3
									local button_hotspot = self.button_hotspot
									local is_selected = button_hotspot.is_selected

									is_selected = not is_selected and not button_hotspot.is_hover

									return is_selected
								end
							},
							{
								pass_type = "texture",
								style_id = "background",
								texture_id = "background_selected_hover",
								content_check_function = function (self)
									-- function 4
									local button_hotspot = self.button_hotspot
									local is_selected = button_hotspot.is_selected

									is_selected = not is_selected and button_hotspot.is_hover

									return is_selected
								end
							},
							{
								pass_type = "texture",
								style_id = "locked_level",
								texture_id = "locked_level",
								content_check_function = function (self)
									-- function 5
									return self.level_is_locked
								end
							},
							{
								pass_type = "texture",
								style_id = "locked_difficulty",
								texture_id = "locked_difficulty",
								content_check_function = function (self)
									-- function 6
									return self.difficulty_is_locked
								end
							},
							{
								style_id = "title_text",
								pass_type = "text",
								text_id = "title_text"
							},
							{
								style_id = "level_text",
								pass_type = "text",
								text_id = "level_text"
							},
							{
								style_id = "difficulty_text",
								pass_type = "text",
								text_id = "difficulty_text"
							},
							{
								style_id = "num_players_text",
								pass_type = "text",
								text_id = "num_players_text"
							}
						}
					},
					{
						style_id = "hover",
						pass_type = "hover",
						content_id = "hotspot"
					}
				}
			},
			content = {
				list_content = {}
			},
			style = {
				list_style = {},
				hover = {
					offset = {
						0,
						306
					},
					size = {
						1100,
						530
					}
				}
			}
		},
		test = UIWidgets.create_simple_rect("item_list", {
			200,
			0,
			255,
			0
		}),
		window = UIWidgets.create_simple_rect("window", {
			200,
			255,
			0,
			0
		}),
		host_text_button = UIWidgets.create_text_button("host_text_button", "lb_host", tbl_6.font_size),
		level_text_button = UIWidgets.create_text_button("level_text_button", "lb_level", tbl_6.font_size),
		difficulty_text_button = UIWidgets.create_text_button("difficulty_text_button", "lb_difficulty", tbl_6.font_size),
		players_text_button = UIWidgets.create_text_button("players_text_button", "lb_players", tbl_6.font_size),
		loading_overlay = UIWidgets.create_simple_rect("loading_overlay", {
			100,
			0,
			0,
			0
		}),
		loading_icon = UIWidgets.create_simple_rotated_texture("matchmaking_connecting_icon", 0, {
			25,
			25
		}, "loading_icon"),
		loading_text = UIWidgets.create_simple_text("matchmaking_status_cannot_find_game", "loading_text", 28, Colors.get_color_table_with_alpha("cheeseburger", 0))
	}
}

local function fn(arg_7_0, arg_7_1)
	-- function 7
	local inventory_list_widget = tbl_17.widget_definitions.inventory_list_widget
	local var_7_1 = inventory_list_widget.element.passes[2]
	local hover = inventory_list_widget.style.hover
	local size = hover.size
	local offset = hover.offset

	size[1] = arg_7_0
	size[2] = arg_7_1
	offset[2] = 0
end

local function fn_2(arg_8_0, arg_8_1)
	-- function 8
	tbl_17.scenegraph_definition.scrollbar_root.size[2] = arg_8_1

	local str = "mouse_scroll_field"
	local tbl = {
		horizontal_alignment = "right",
		position = {
			0,
			-2,
			1
		},
		size = {
			arg_8_0 + 24,
			arg_8_1
		}
	}

	tbl.parent = "scrollbar_root"
	tbl_17.scenegraph_definition[str] = tbl
	tbl_17.widget_definitions.scroll_field = {
		element = {
			passes = {
				{
					pass_type = "scroll",
					scroll_function = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
						-- function 9
						local scroll_step = arg_9_2.scroll_step

						scroll_step = scroll_step or 0.1

						local num = arg_9_2.internal_scroll_value + scroll_step * -arg_9_4.y

						arg_9_2.internal_scroll_value = math.clamp(num, 0, 1)
					end
				}
			}
		},
		content = {
			scroll_step = 0.05,
			internal_scroll_value = 0
		},
		style = {},
		scenegraph_id = str
	}
end

local function fn_3(self)
	-- function 10
	local selected_mission_id = self.selected_mission_id

	selected_mission_id = selected_mission_id or self.mission_id

	local mechanism = self.mechanism
	local var_10_2 = tonumber(self.matchmaking_type)
	local clone = table.clone(NetworkLookup.matchmaking_types, true)
	local flag

	flag = not var_10_2 and clone[var_10_2]

	if mechanism == "weave" then
		if not (selected_mission_id == "false" or self.weave_quick_game ~= "false") then
			local split_deprecated = string.split_deprecated(selected_mission_id, "_")

			return "Weave " .. split_deprecated[2]
		elseif self.weave_quick_game == "true" then
			return Localize("start_game_window_weave_quickplay_title")
		else
			return Localize("lb_unknown")
		end
	else
		local var_10_6 = selected_mission_id
		local var_10_7

		if var_10_6 == "n/a" then
			var_10_7 = "lb_unknown"
		elseif var_10_6 == "any" then
			var_10_7 = "map_screen_quickplay_button"
		else
			local var_10_8 = rawget(LevelSettings, var_10_6)

			if not var_10_8 then
				var_10_7 = var_10_8.display_name
			end
		end

		return Localize(var_10_7 or "lb_unknown")
	end
end

local function fn_4(self)
	-- function 11
	local selected_mission_id = self.selected_mission_id

	selected_mission_id = selected_mission_id or self.mission_id

	local make_hash = Application.make_hash(selected_mission_id)

	return Application.hex64_to_dec(make_hash) or 0
end

local function fn_5(self)
	-- function 12
	local difficulty = self.difficulty
	local flag = not difficulty and DifficultySettings[difficulty]
	local flag_2 = not difficulty and flag.display_name
	local var_12_3

	if not difficulty then
		var_12_3 = Localize(flag_2)

		if not var_12_3 then
			-- Nothing
		end
	end

	var_12_3 = "-"

	::label_12_0::

	return var_12_3
end

local function fn_6(self)
	-- function 13
	local difficulty = self.difficulty
	local flag = not difficulty and DifficultySettings[difficulty]
	local rank

	if not difficulty then
		rank = flag.rank

		if not rank then
			-- Nothing
		end
	end

	rank = 0

	::label_13_0::

	return rank
end

local function fn_7(self)
	-- function 14
	local country_code = self.country_code
	local var_14_1

	if not country_code then
		var_14_1 = iso_countries[country_code]

		if not var_14_1 then
			-- Nothing
		end
	end

	var_14_1 = ""

	::label_14_0::

	return var_14_1
end

local function fn_8(self)
	-- function 15
	local player = Managers.player
	local local_player = player:local_player()
	local statistics_db = player:statistics_db()
	local stats_id = local_player:stats_id()
	local flag = self.weave_quick_game == "true"
	local is_lobby_private = MatchmakingManager.is_lobby_private(self)
	local mechanism = self.mechanism
	local flag_2 = not mechanism and MechanismSettings[mechanism]

	if not is_lobby_private then
		return true
	end

	local selected_mission_id = self.selected_mission_id

	selected_mission_id = selected_mission_id or self.mission_id

	if not selected_mission_id then
		return false
	end

	if not WeaveSettings.templates[selected_mission_id] then
		local var_15_9 = rawget(LevelSettings, selected_mission_id)

		if not var_15_9 then
			return true
		end

		if not var_15_9.hub_level then
			return false
		end
	end

	if not (not flag_2 and not flag_2.extra_requirements_function and flag_2.extra_requirements_function()) then
		return true
	end

	if mechanism == "weave" then
		if not flag then
			local flag_3 = false
			local var_15_11 = selected_mission_id

			if not LevelUnlockUtils.weave_disabled(var_15_11) then
				return true
			end

			if not LevelUnlockUtils.weave_unlocked(statistics_db, stats_id, var_15_11, flag_3) then
				return false
			end

			if LevelUnlockUtils.current_weave(statistics_db, stats_id, flag_3) == var_15_11 then
				return false
			end
		end

		return false
	end

	if not LevelUnlockUtils.level_unlocked(statistics_db, stats_id, selected_mission_id) then
		return true
	end
end

local function fn_9(self)
	-- function 16
	local var_16_0 = tonumber(self.matchmaking_type)
	local var_16_1 = table.clone(NetworkLookup.matchmaking_types, true)[var_16_0]

	if self.mechanism == "weave" then
		return false
	end

	local selected_mission_id = self.selected_mission_id

	selected_mission_id = selected_mission_id or self.mission_id

	local player = Managers.player
	local local_player = player:local_player()
	local statistics_db = player:statistics_db()
	local stats_id = local_player:stats_id()
	local difficulty = self.difficulty

	if not (not difficulty and selected_mission_id) then
		return false
	end

	if not difficulty then
		local var_16_8 = DifficultySettings[difficulty]

		if not var_16_8.extra_requirement_name then
			local var_16_9 = ExtraDifficultyRequirements[var_16_8.extra_requirement_name]

			if not (Development.parameter("unlock_all_difficulties") or var_16_9.requirement_function()) then
				return true
			end
		end

		if not (not var_16_8.dlc_requirement and Managers.unlock:is_dlc_unlocked(var_16_8.dlc_requirement)) then
			return true
		end
	end

	if not MatchmakingManager.is_lobby_private(self) then
		local profile_display_name = local_player:profile_display_name()
		local career_name = local_player:career_name()

		if not Managers.matchmaking:has_required_power_level(self, profile_display_name, career_name) then
			return true
		end
	end

	return false
end

local function fn_10(self)
	-- function 17
	local get_matchmaking_settings_for_mechanism = Managers.matchmaking.get_matchmaking_settings_for_mechanism(self.mechanism)
	local num_players = self.num_players
	local matchmaking = self.matchmaking

	if not (not num_players and matchmaking) then
		return false
	end

	local flag = self.matchmaking == "false"
	local flag_2 = self.num_players == get_matchmaking_settings_for_mechanism.MAX_NUMBER_OF_PLAYERS

	return self.is_broken or flag_2 or flag
end

local menu_frame_12 = UIFrameSettings.menu_frame_12

local function fn_11(self)
	-- function 18
	local peer_id = Network.peer_id()
	local host = self.host
	local server_name = self.server_name

	if not server_name then
		server_name = self.unique_server_name

		if not server_name then
			server_name = self.name
			server_name = server_name or self.host
		end
	end

	if not (host == peer_id or server_name) then
		return
	end

	local var_18_3 = fn_3(self)
	local num_players = self.num_players

	num_players = num_players or 0

	local var_18_5 = fn_5(self)
	local lobby_status_text = LobbyItemsList.lobby_status_text(self)
	local str

	if not not self.valid then
		str = "[INV]" .. lobby_status_text

		if not str then
			-- Nothing
		end
	end

	str = lobby_status_text

	::label_18_0::

	local var_18_8 = fn_7(self)

	return {
		locked_difficulty = "locked_icon_01",
		locked_status = "locked_icon_01",
		background_selected = "lb_list_item_clicked",
		background_normal_hover = "lb_list_item_hover",
		visible = true,
		background_selected_hover = "lb_list_item_clicked",
		background_normal = "lb_list_item_normal",
		locked_level = "locked_icon_01",
		button_hotspot = {},
		lobby_data = self,
		title_text = server_name,
		level_text = var_18_3,
		difficulty_text = var_18_5,
		num_players_text = num_players .. "/4",
		status_text = str,
		country_text = var_18_8,
		level_is_locked = fn_8(self),
		difficulty_is_locked = fn_9(self),
		status_is_locked = fn_10(self),
		frame = menu_frame_12.texture
	}
end

local function fn_12()
	-- function 19
	return {
		difficulty_text = "",
		title_text = "",
		num_players_text = "",
		background_normal = "lb_list_item_bg",
		fake = true,
		country_text = "",
		background_normal_hover = "lb_list_item_bg",
		background_selected = "lb_list_item_bg",
		level_text = "",
		status_text = "",
		background_selected_hover = "lb_list_item_bg",
		button_hotspot = {
			allow_multi_hover = true
		},
		frame = menu_frame_12.texture
	}
end

local function fn_13()
	-- function 20
	return {
		frame = {
			texture_size = menu_frame_12.texture_size,
			texture_sizes = menu_frame_12.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			size = {
				tbl_5.width,
				tbl_5.height
			},
			offset = {
				0,
				0,
				5
			}
		},
		background = {
			size = {
				tbl_5.width,
				tbl_5.height
			},
			offset = {
				0,
				0,
				1
			}
		},
		locked_level = {
			size = {
				20,
				26
			},
			offset = tbl_14
		},
		locked_difficulty = {
			size = {
				20,
				26
			},
			offset = tbl_15
		},
		locked_status = {
			size = {
				20,
				26
			},
			offset = tbl_16
		},
		title_text = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			font_type = "arial",
			size = {
				tbl_5.width,
				tbl_5.height
			},
			text_color = Colors.color_definitions.white,
			font_size = tbl_6.font_size,
			offset = tbl_7
		},
		level_text = {
			word_wrap = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = "arial",
			size = {
				tbl_5.width,
				tbl_5.height
			},
			text_color = Colors.color_definitions.white,
			font_size = tbl_6.font_size,
			area_size = {
				240,
				50
			},
			offset = tbl_8
		},
		difficulty_text = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			font_type = "arial",
			size = {
				tbl_5.width,
				tbl_5.height
			},
			text_color = Colors.color_definitions.white,
			font_size = tbl_6.font_size,
			offset = tbl_9
		},
		num_players_text = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			font_type = "arial",
			size = {
				tbl_5.width,
				tbl_5.height
			},
			text_color = Colors.color_definitions.white,
			font_size = tbl_6.font_size,
			offset = {
				tbl_10[1] + 5,
				tbl_10[2],
				tbl_10[3]
			}
		},
		status_text = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			font_type = "arial",
			size = {
				tbl_5.width,
				tbl_5.height
			},
			text_color = Colors.color_definitions.white,
			font_size = tbl_6.font_size,
			offset = tbl_11
		},
		country_text = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			font_type = "arial",
			size = {
				tbl_5.width,
				tbl_5.height
			},
			text_color = Colors.color_definitions.white,
			font_size = tbl_6.font_size,
			offset = tbl_12
		}
	}
end

LobbyItemsList = class(LobbyItemsList)

LobbyItemsList.init = function (self, arg_21_1, arg_21_2)
	-- function 21
	self.ui_renderer = arg_21_1.ui_top_renderer
	self.input_manager = arg_21_1.input_manager

	local num_list_items = arg_21_2.num_list_items

	if not arg_21_2.use_top_renderer then
		self.ui_renderer = arg_21_1.ui_top_renderer
	else
		self.ui_renderer = arg_21_1.ui_renderer
	end

	self.world_manager = arg_21_1.world_manager

	local world = self.world_manager:world("level_world")

	self.wwise_world = Managers.world:wwise_world(world)

	local scenegraph_definition = tbl_17.scenegraph_definition
	local item_list = scenegraph_definition.item_list
	local var_21_4 = item_list.size[1]
	local var_21_5 = item_list.size[2]

	arg_21_2.list_size = {
		item_list.size[1],
		item_list.size[2]
	}

	fn_2(var_21_4, var_21_5)
	fn(var_21_4, var_21_5)

	self.settings = arg_21_2
	self.widget_definitions = tbl_17.widget_definitions
	self.bar_animations = {}
	self.inventory_list_animations = {}
	self.scenegraph_definition = scenegraph_definition
	self.lobby_list = {}
	self.input_service_name = arg_21_2.input_service_name

	self:create_ui_elements(arg_21_2.offset)

	self.list_style = {
		vertical_alignment = "top",
		scenegraph_id = "item_list",
		size = arg_21_2.list_size,
		list_member_offset = {
			0,
			-(tbl_5.height + tbl_5.height_spacing),
			0
		},
		item_styles = {}
	}
	self.selected_list_index = 1
end

LobbyItemsList.destroy = function (arg_22_0)
	-- function 22
	return
end

LobbyItemsList.lobby_status_text = function (self)
	-- function 23
	local flag = self.server_info ~= nil
	local get_matchmaking_settings_for_mechanism = Managers.matchmaking.get_matchmaking_settings_for_mechanism(self.mechanism)
	local mission_id = self.mission_id
	local password

	if not flag then
		password = self.server_info.password

		if not password then
			-- Nothing
		end
	end

	password = not not flag or self.matchmaking == "false"

	::label_23_0::

	local flag_2 = self.num_players == get_matchmaking_settings_for_mechanism.MAX_NUMBER_OF_PLAYERS
	local var_23_5 = tonumber(self.matchmaking_type)
	local clone = table.clone(NetworkLookup.matchmaking_types, true)
	local flag_3 = not var_23_5 and clone[var_23_5]
	local var_23_8 = mission_id

	if flag_3 == "weave" then
		local var_23_9 = WeaveSettings.templates[mission_id]

		if not var_23_9 then
			local level_id = var_23_9.objectives[1].level_id
		end
	end

	local hub_level = LevelSettings[mission_id].hub_level
	local flag_4

	flag_4 = not self.is_broken and "lb_broken" and not password or "lb_private" and (not flag_2 and "lb_full" and not hub_level or "lb_in_inn" and "lb_started")

	local var_23_13

	if not flag_4 then
		var_23_13 = Localize(flag_4)

		if not var_23_13 then
			-- Nothing
		end
	end

	var_23_13 = ""

	::label_23_1::

	return var_23_13
end

LobbyItemsList.create_ui_elements = function (self, arg_24_1)
	-- function 24
	self.ui_scenegraph = UISceneGraph.init_scenegraph(self.scenegraph_definition)

	local str = "scrollbar_root"
	local var_24_1 = self.scenegraph_definition[str]

	self.scrollbar_widget = UIWidget.init(UIWidgets.create_scrollbar(str, var_24_1.size))
	self.item_list_widget = UIWidget.init(self.widget_definitions.inventory_list_widget)
	self.scroll_field_widget = UIWidget.init(self.widget_definitions.scroll_field)
	self.test = UIWidget.init(self.widget_definitions.test)
	self.window = UIWidget.init(self.widget_definitions.window)
	self.host_text_button = UIWidget.init(self.widget_definitions.host_text_button)
	self.level_text_button = UIWidget.init(self.widget_definitions.level_text_button)
	self.difficulty_text_button = UIWidget.init(self.widget_definitions.difficulty_text_button)
	self.players_text_button = UIWidget.init(self.widget_definitions.players_text_button)
	self.loading_overlay = UIWidget.init(self.widget_definitions.loading_overlay)
	self.loading_icon = UIWidget.init(self.widget_definitions.loading_icon)
	self.loading_text = UIWidget.init(self.widget_definitions.loading_text)

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	if not arg_24_1 then
		local local_position = self.ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_24_1[1]
		local_position[2] = local_position[2] + arg_24_1[2]
		local_position[3] = local_position[3] + arg_24_1[3]
	end
end

local function fn_14(self, arg_25_1)
	-- function 25
	local server_name = self.server_name

	if not server_name then
		server_name = self.unique_server_name

		if not server_name then
			server_name = self.host
			server_name = server_name or ""
		end
	end

	local server_name_2 = arg_25_1.server_name

	if not server_name_2 then
		server_name_2 = arg_25_1.unique_server_name

		if not server_name_2 then
			server_name_2 = arg_25_1.host
			server_name_2 = server_name_2 or ""
		end
	end

	return server_name < server_name_2
end

local function fn_15(self, arg_26_1)
	-- function 26
	local server_name = self.server_name

	if not server_name then
		server_name = self.unique_server_name

		if not server_name then
			server_name = self.host
			server_name = server_name or ""
		end
	end

	local server_name_2 = arg_26_1.server_name

	if not server_name_2 then
		server_name_2 = arg_26_1.unique_server_name

		if not server_name_2 then
			server_name_2 = arg_26_1.host
			server_name_2 = server_name_2 or ""
		end
	end

	return server_name_2 < server_name
end

local function fn_16(self, arg_27_1)
	-- function 27
	local selected_mission_id = self.selected_mission_id

	if not selected_mission_id then
		selected_mission_id = self.mission_id
		selected_mission_id = selected_mission_id or "lb_unknown"
	end

	local selected_mission_id_2 = arg_27_1.selected_mission_id

	if not selected_mission_id_2 then
		selected_mission_id_2 = arg_27_1.mission_id
		selected_mission_id_2 = selected_mission_id_2 or "lb_unknown"
	end

	return Localize(selected_mission_id) < Localize(selected_mission_id_2)
end

local function fn_17(self, arg_28_1)
	-- function 28
	local var_28_0 = fn_4(self)
	local var_28_1 = fn_4(arg_28_1)
	local selected_mission_id = self.selected_mission_id

	if not selected_mission_id then
		selected_mission_id = self.mission_id
		selected_mission_id = selected_mission_id or "lb_unknown"
	end

	local selected_mission_id_2 = arg_28_1.selected_mission_id

	if not selected_mission_id_2 then
		selected_mission_id_2 = arg_28_1.mission_id
		selected_mission_id_2 = selected_mission_id_2 or "lb_unknown"
	end

	return Localize(selected_mission_id) > Localize(selected_mission_id_2)
end

local function fn_18(arg_29_0, arg_29_1)
	-- function 29
	return fn_6(arg_29_0) < fn_6(arg_29_1)
end

local function fn_19(arg_30_0, arg_30_1)
	-- function 30
	return fn_6(arg_30_0) > fn_6(arg_30_1)
end

local function fn_20(arg_31_0, arg_31_1)
	-- function 31
	return LobbyItemsList.lobby_status_text(arg_31_0) < LobbyItemsList.lobby_status_text(arg_31_1)
end

local function fn_21(arg_32_0, arg_32_1)
	-- function 32
	return LobbyItemsList.lobby_status_text(arg_32_0) > LobbyItemsList.lobby_status_text(arg_32_1)
end

local function fn_22(self, arg_33_1)
	-- function 33
	local var_33_0 = tonumber(self.num_players)

	var_33_0 = var_33_0 or 0

	local var_33_1 = tonumber(arg_33_1.num_players)

	var_33_1 = var_33_1 or 0

	return var_33_0 < var_33_1
end

local function fn_23(self, arg_34_1)
	-- function 34
	local var_34_0 = tonumber(self.num_players)

	var_34_0 = var_34_0 or 0

	local var_34_1 = tonumber(arg_34_1.num_players)

	var_34_1 = var_34_1 or 0

	return var_34_1 < var_34_0
end

local function fn_24(arg_35_0, arg_35_1)
	-- function 35
	return fn_7(arg_35_0) < fn_7(arg_35_1)
end

local function fn_25(arg_36_0, arg_36_1)
	-- function 36
	return fn_7(arg_36_0) > fn_7(arg_36_1)
end

LobbyItemsList.update = function (self, arg_37_1, arg_37_2)
	-- function 37
	if not arg_37_2 then
		if not self._loading_previous_frame then
			self:loading_overlay_fade_in(180)
		end

		self:rotate_loading_icon(arg_37_1)
	elseif not self._loading_previous_frame then
		self:loading_overlay_fade_out()
	end

	self._loading_previous_frame = arg_37_2

	local item_list_widget = self.item_list_widget
	local list_content = item_list_widget.content.list_content
	local list_style = item_list_widget.style.list_style
	local selected_list_index = self.selected_list_index
	local hover_list_index = self.hover_list_index
	local number_of_items_in_list = self.number_of_items_in_list
	local is_device_active = self.input_manager:is_device_active("gamepad")

	self.lobby_list_index_changed = nil
	self.inventory_list_index_pressed = nil

	local count = #list_content

	if not is_device_active then
		if number_of_items_in_list > 0 then
			self:update_gamepad_list_scroll()
		end
	else
		self.gamepad_changed_selected_list_index = nil
	end

	for i = 1, count do
		local var_37_8 = list_content[i]
		local button_hotspot = var_37_8.button_hotspot

		if not var_37_8.fake then
			if not button_hotspot.on_hover_enter then
				self:play_sound("Play_hud_hover")

				button_hotspot.on_hover_enter = false
			end

			if not ((button_hotspot.is_selected or self.gamepad_changed_selected_list_index == i) and i == selected_list_index) then
				self.lobby_list_index_changed = i

				self:play_sound("Play_hud_select")

				break
			end
		end
	end

	self:update_scroll()

	local button_text = self.host_text_button.content.button_text
	local button_text_2 = self.level_text_button.content.button_text
	local button_text_3 = self.difficulty_text_button.content.button_text
	local button_text_4 = self.players_text_button.content.button_text

	if button_text.on_hover_enter or button_text_2.on_hover_enter or button_text_3.on_hover_enter or not button_text_4.on_hover_enter then
		self:play_sound("Play_hud_hover")
	end

	if not button_text.on_pressed then
		local _pick_sort_func = self:_pick_sort_func(fn_14, fn_15)
		local lobbies = self.lobbies

		self:populate_lobby_list(lobbies, _pick_sort_func)
		self:play_sound("Play_hud_select")
	end

	if not button_text_2.on_pressed then
		local _pick_sort_func_2 = self:_pick_sort_func(fn_16, fn_17)
		local lobbies_2 = self.lobbies

		self:populate_lobby_list(lobbies_2, _pick_sort_func_2)
		self:play_sound("Play_hud_select")
	end

	if not button_text_3.on_pressed then
		local _pick_sort_func_3 = self:_pick_sort_func(fn_18, fn_19)
		local lobbies_3 = self.lobbies

		self:populate_lobby_list(lobbies_3, _pick_sort_func_3)
		self:play_sound("Play_hud_select")
	end

	if not button_text_4.on_pressed then
		local _pick_sort_func_4 = self:_pick_sort_func(fn_22, fn_23)
		local lobbies_4 = self.lobbies

		self:populate_lobby_list(lobbies_4, _pick_sort_func_4)
		self:play_sound("Play_hud_select")
	end
end

LobbyItemsList.handle_gamepad_input = function (self, arg_38_1, arg_38_2)
	-- function 38
	local get_service = self.input_manager:get_service(self.input_service_name)
	local controller_cooldown = self.controller_cooldown

	if not (not controller_cooldown and not (controller_cooldown > 0)) then
		self.controller_cooldown = controller_cooldown - arg_38_1

		local speed_multiplier = self.speed_multiplier

		speed_multiplier = speed_multiplier or 1

		local menu_speed_multiplier_frame_decrease = GamepadSettings.menu_speed_multiplier_frame_decrease
		local menu_min_speed_multiplier = GamepadSettings.menu_min_speed_multiplier

		self.speed_multiplier = math.max(speed_multiplier - menu_speed_multiplier_frame_decrease, menu_min_speed_multiplier)

		return
	else
		local selected_list_index = self.selected_list_index

		selected_list_index = selected_list_index or 1

		if not selected_list_index then
			local speed_multiplier_2 = self.speed_multiplier

			speed_multiplier_2 = speed_multiplier_2 or 1

			local var_38_7
			local get = get_service:get("move_up")
			local get_2 = get_service:get("move_up_hold")

			if get or not get_2 then
				var_38_7 = math.max(selected_list_index - 1, 1)
				self.controller_cooldown = GamepadSettings.menu_cooldown * speed_multiplier_2
			else
				local get_3 = get_service:get("move_down")
				local get_4 = get_service:get("move_down_hold")

				if get_3 or not get_4 then
					self.controller_cooldown = GamepadSettings.menu_cooldown * speed_multiplier_2
					var_38_7 = math.min(selected_list_index + 1, arg_38_2)
				end
			end

			if not (not var_38_7 and var_38_7 == selected_list_index) then
				self.gamepad_changed_selected_list_index = var_38_7

				return
			end
		end
	end

	self.speed_multiplier = 1
end

LobbyItemsList.update_gamepad_list_scroll = function (self)
	-- function 39
	local selected_list_index = self.selected_list_index

	if not selected_list_index then
		return
	end

	local is_entry_outside, var_39_2 = self:is_entry_outside(selected_list_index)

	while not is_entry_outside do
		local button_scroll_step = self.scrollbar_widget.content.button_scroll_step
		local scroll_value = self.scroll_value

		if var_39_2 == "below" then
			scroll_value = math.min(scroll_value + button_scroll_step, 1)
		else
			scroll_value = math.max(scroll_value - button_scroll_step, 0)
		end

		if scroll_value ~= self.scroll_value then
			self:set_scroll_amount(scroll_value)
		end

		is_entry_outside, var_39_2 = self:is_entry_outside(self.selected_list_index)
	end
end

LobbyItemsList.is_entry_outside = function (self, arg_40_1)
	-- function 40
	local item_list_widget = self.item_list_widget

	if not item_list_widget then
		local list_content = item_list_widget.content.list_content
		local list_style = item_list_widget.style.list_style
		local num_draws = list_style.num_draws
		local count = #list_content
		local start_index = list_style.start_index

		if arg_40_1 < start_index then
			return true, "above"
		elseif arg_40_1 > math.min(start_index + num_draws - 1, count) then
			return true, "below"
		end
	end

	return false
end

LobbyItemsList._pick_sort_func = function (self, arg_41_1, arg_41_2)
	-- function 41
	local sort_lobbies_function = self.sort_lobbies_function

	if not (not sort_lobbies_function and sort_lobbies_function ~= arg_41_1) then
		sort_lobbies_function = arg_41_2
	else
		sort_lobbies_function = arg_41_1
	end

	self.sort_lobbies_function = sort_lobbies_function

	return sort_lobbies_function
end

LobbyItemsList.rotate_loading_icon = function (self, arg_42_1)
	-- function 42
	local texture_id = self.loading_icon.style.texture_id
	local fraction = texture_id.fraction

	fraction = fraction or 0

	local num = (fraction + arg_42_1) % 1

	texture_id.angle = math.easeOutCubic(num) * math.degrees_to_radians(360)
	texture_id.fraction = num
end

LobbyItemsList.loading_overlay_fade_in = function (self, arg_43_1)
	-- function 43
	local loading_icon = self.loading_icon
	local color = loading_icon.style.texture_id.color
	local var_43_2 = UIAnimation.init(UIAnimation.function_by_time, color, 1, color[1], 255, 0.3, math.easeOutCubic)

	table.clear(loading_icon.animations)

	loading_icon.animations[var_43_2] = true

	table.clear(self.loading_overlay.animations)

	self.loading_overlay.style.rect.color[1] = arg_43_1
end

LobbyItemsList.loading_overlay_fade_out = function (self)
	-- function 44
	local function fn(self, arg_45_1)
		-- function 45
		local var_45_0 = UIAnimation.init(UIAnimation.function_by_time, arg_45_1, 1, arg_45_1[1], 0, 0.3, math.easeOutCubic)

		table.clear(self.animations)

		self.animations[var_45_0] = true
	end

	fn(self.loading_overlay, self.loading_overlay.style.rect.color)
	fn(self.loading_icon, self.loading_icon.style.texture_id.color)
	fn(self.loading_text, self.loading_text.style.text.text_color)
end

LobbyItemsList.animate_loading_text = function (self)
	-- function 46
	local loading_text = self.loading_text
	local text_color = loading_text.style.text.text_color

	if text_color[1] ~= 255 then
		local var_46_2 = UIAnimation.init(UIAnimation.function_by_time, text_color, 1, text_color[1], 255, 0.3, math.easeOutCubic, UIAnimation.wait, 3.2, UIAnimation.function_by_time, text_color, 1, 255, 0, 0.3, math.easeOutCubic)

		table.clear(loading_text.animations)

		loading_text.animations[var_46_2] = true
	end
end

LobbyItemsList.draw = function (self, arg_47_1)
	-- function 47
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service(self.input_service_name)

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_47_1)
	UIRenderer.draw_widget(ui_renderer, self.item_list_widget)
	UIRenderer.draw_widget(ui_renderer, self.scroll_field_widget)
	UIRenderer.draw_widget(ui_renderer, self.scrollbar_widget)
	UIRenderer.draw_widget(ui_renderer, self.host_text_button)
	UIRenderer.draw_widget(ui_renderer, self.level_text_button)
	UIRenderer.draw_widget(ui_renderer, self.difficulty_text_button)
	UIRenderer.draw_widget(ui_renderer, self.players_text_button)
	UIRenderer.draw_widget(ui_renderer, self.loading_overlay)
	UIRenderer.draw_widget(ui_renderer, self.loading_icon)
	UIRenderer.draw_widget(ui_renderer, self.loading_text)
	UIRenderer.end_pass(ui_renderer)
end

LobbyItemsList.sort_lobbies = function (arg_48_0, arg_48_1, arg_48_2)
	-- function 48
	table.sort(arg_48_1, arg_48_2)
end

LobbyItemsList.remove_invalid_lobbies = function (arg_49_0, arg_49_1)
	-- function 49
	local tbl = {}
	local count = #arg_49_1

	for i = 1, count do
		local var_49_2 = arg_49_1[i]

		if not var_49_2 then
			tbl[#tbl + 1] = var_49_2
		end
	end

	return tbl
end

LobbyItemsList.populate_lobby_list = function (self, arg_50_1, arg_50_2)
	-- function 50
	local settings = self.settings
	local item_list_widget = self.item_list_widget
	local tbl = {}
	local list_style = self.list_style
	local num = 0
	local sort_lobbies_function = self.sort_lobbies_function
	local selected_lobby = self:selected_lobby()
	local remove_invalid_lobbies = self:remove_invalid_lobbies(arg_50_1)

	if not sort_lobbies_function then
		self:sort_lobbies(remove_invalid_lobbies, sort_lobbies_function)
	end

	for k, v in pairs(remove_invalid_lobbies) do
		local var_50_8 = fn_13()
		local var_50_9 = fn_11(v)

		if not var_50_9 then
			num = num + 1
			tbl[num] = var_50_9
			list_style.item_styles[num] = var_50_8

			if num >= num_4 then
				break
			end
		end
	end

	self.lobbies = remove_invalid_lobbies
	self.number_of_items_in_list = num
	item_list_widget.content.list_content = tbl
	item_list_widget.style.list_style = list_style
	item_list_widget.style.list_style.start_index = 1
	item_list_widget.style.list_style.num_draws = settings.num_list_items
	item_list_widget.element.pass_data[1].num_list_elements = nil

	local num_draws = item_list_widget.style.list_style.num_draws

	if num < num_draws then
		local num_2 = num_draws - num % num_draws

		if num_2 <= num_draws then
			for k_2 = 1, num_2 do
				local var_50_12 = fn_12()
				local var_50_13 = fn_13()
				local num_3 = #tbl + 1

				tbl[num_3] = var_50_12
				list_style.item_styles[num_3] = var_50_13
			end
		end
	end

	self:set_scrollbar_length(nil, arg_50_2)

	self.selected_list_index = nil
end

LobbyItemsList.update_scroll = function (self)
	-- function 51
	local value = self.scrollbar_widget.content.scroll_bar_info.value
	local internal_scroll_value = self.scroll_field_widget.content.internal_scroll_value
	local scroll_value = self.scroll_value

	if scroll_value ~= internal_scroll_value then
		self:set_scroll_amount(internal_scroll_value)
	elseif scroll_value ~= value then
		self:set_scroll_amount(value)
	end
end

LobbyItemsList.set_scroll_amount = function (self, arg_52_1)
	-- function 52
	local scroll_value = self.scroll_value

	if not (not scroll_value and arg_52_1 == scroll_value) then
		self.scrollbar_widget.content.scroll_bar_info.value = arg_52_1
		self.scroll_field_widget.content.internal_scroll_value = arg_52_1
		self.scroll_value = arg_52_1

		self:scroll_inventory_list(arg_52_1)
	end
end

LobbyItemsList.set_scrollbar_length = function (self, arg_53_1, arg_53_2)
	-- function 53
	local settings = self.settings
	local columns = settings.columns
	local num_list_items = settings.num_list_items
	local number_of_items_in_list = self.number_of_items_in_list
	local max = math.max(number_of_items_in_list - num_list_items, 0)
	local content = self.scrollbar_widget.content
	local scroll_bar_info = content.scroll_bar_info
	local num = 0
	local num_2 = 0

	if max > 0 then
		local flag = not columns and columns and 1
		local ceil = math.ceil(max / flag)

		num = 1 - 1 / math.ceil(number_of_items_in_list / flag) * ceil
		num_2 = 1 / ceil
	else
		num = 1
		num_2 = 1
	end

	scroll_bar_info.bar_height_percentage = num
	self.scroll_field_widget.content.scroll_step = num_2
	content.button_scroll_step = num_2

	if not arg_53_2 then
		local scroll_value = self.scroll_value

		self.scroll_value = nil

		self:set_scroll_amount(scroll_value or 0)
	else
		self:set_scroll_amount(arg_53_1 or 0)
	end
end

LobbyItemsList.scroll_inventory_list = function (self, arg_54_1)
	-- function 54
	local item_list_widget = self.item_list_widget

	if not item_list_widget then
		local list_content = item_list_widget.content.list_content
		local list_style = item_list_widget.style.list_style
		local num_draws = list_style.num_draws
		local columns = list_style.columns
		local count = #list_content

		if not (not num_draws and not (num_draws < count)) then
			local num = count - num_draws
			local num_2 = math.max(0, math.round(arg_54_1 * num)) + 1

			if not (not columns and num_2 % columns ~= 0) then
				num_2 = num_2 + columns - 1
			end

			list_style.start_index = num_2
		end
	end
end

LobbyItemsList.on_lobby_selected = function (self, arg_55_1, arg_55_2)
	-- function 55
	local list_content = self.item_list_widget.content.list_content
	local number_of_items_in_list = self.number_of_items_in_list

	if not (not number_of_items_in_list and not (number_of_items_in_list < 1)) then
		return
	end

	if not arg_55_2 then
		self:play_sound(self.item_select_sound_event)
	end

	if not arg_55_1 and not list_content[arg_55_1] then
		for i = 1, #list_content do
			list_content[i].button_hotspot.is_selected = i == arg_55_1
		end

		self.lobby_list_select_animation_time = 0
		self.selected_list_index = arg_55_1
	end
end

LobbyItemsList.selected_lobby = function (self)
	-- function 56
	local selected_list_index = self.selected_list_index

	if not selected_list_index then
		return
	end

	local var_56_1 = self.item_list_widget.content.list_content[selected_list_index]

	if not var_56_1 then
		return
	end

	return var_56_1.lobby_data
end

LobbyItemsList.set_selected_lobby = function (self, arg_57_1)
	-- function 57
	self.selected_list_index = nil

	local id = arg_57_1.id
	local list_content = self.item_list_widget.content.list_content
	local number_of_items_in_list = self.number_of_items_in_list

	for i = 1, number_of_items_in_list do
		if id == list_content[i].lobby_data.id then
			self:on_lobby_selected(i, false)
		end
	end
end

LobbyItemsList.animate_element_by_time = function (arg_58_0, arg_58_1, arg_58_2, arg_58_3, arg_58_4, arg_58_5)
	-- function 58
	return (UIAnimation.init(UIAnimation.function_by_time, arg_58_1, arg_58_2, arg_58_3, arg_58_4, arg_58_5, math.easeInCubic))
end

LobbyItemsList.play_sound = function (self, arg_59_1)
	-- function 59
	WwiseWorld.trigger_event(self.wwise_world, arg_59_1)
end
