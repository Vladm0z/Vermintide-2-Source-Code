-- chunkname: @scripts/ui/views/lobby_item_list.lua

require("foundation/scripts/util/local_require")
require("scripts/managers/telemetry/iso_country_names")
require("scripts/settings/level_settings")

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.background
local var_0_2 = var_0_0.frame
local var_0_3 = var_0_0.size
local var_0_4 = var_0_0.spacing
local var_0_5 = UIFrameSettings[var_0_2].texture_sizes.vertical[1]
local var_0_6 = UIFrameSettings[var_0_2].texture_sizes.horizontal[2]
local var_0_7 = var_0_3[1] + var_0_4
local var_0_8 = var_0_3[1] - (var_0_5 * 2 + 60)
local var_0_9 = var_0_0.large_window_frame
local var_0_10 = UIFrameSettings[var_0_9].texture_sizes.vertical[1]
local var_0_11 = {
	var_0_3[1] * 3 + var_0_4 * 2 + var_0_10 * 2,
	var_0_3[2] + var_0_10 * 2
}
local var_0_12 = {
	400,
	var_0_11[2]
}
local var_0_13 = {
	400,
	var_0_11[2]
}
local var_0_14 = {
	var_0_11[1] - var_0_12[1] - var_0_13[1] + 12,
	var_0_11[2] - 60
}
local var_0_15 = {
	height_spacing = 7,
	height = 45,
	width = var_0_14[1] - 50
}
local var_0_16 = {
	font_size = 18
}
local var_0_17 = 22
local var_0_18 = 100
local var_0_19 = 5
local var_0_20 = {
	20,
	0,
	2
}
local var_0_21 = {
	var_0_14[1] * 0.3,
	0,
	2
}
local var_0_22 = {
	var_0_14[1] * 0.6,
	0,
	2
}
local var_0_23 = {
	var_0_14[1] * 0.8,
	0,
	2
}
local var_0_24 = {
	var_0_14[1] * 0.6,
	0,
	2
}
local var_0_25 = {
	-5,
	0,
	2
}
local var_0_26 = {
	-50,
	0,
	2
}
local var_0_27 = {
	var_0_21[1] - 25,
	10,
	3
}
local var_0_28 = {
	var_0_22[1] - 25,
	10,
	3
}
local var_0_29 = {
	var_0_24[1] - 25,
	10,
	3
}
local var_0_30 = {
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
			size = var_0_11,
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
				var_0_14[1],
				var_0_14[2]
			},
			position = {
				var_0_12[1] + 8,
				12,
				1
			}
		},
		loading_overlay = {
			vertical_alignment = "bottom",
			parent = "item_list",
			horizontal_alignment = "left",
			size = {
				var_0_14[1] - 16,
				var_0_14[2] + 7
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
				var_0_14[1],
				40
			}
		},
		host_text_button = {
			vertical_alignment = "top",
			parent = "label_root",
			horizontal_alignment = "left",
			position = var_0_20,
			size = {
				100,
				40
			}
		},
		level_text_button = {
			parent = "label_root",
			horizontal_alignment = "left",
			position = var_0_21,
			size = {
				100,
				40
			}
		},
		difficulty_text_button = {
			parent = "label_root",
			horizontal_alignment = "left",
			position = var_0_22,
			size = {
				130,
				40
			}
		},
		players_text_button = {
			parent = "label_root",
			horizontal_alignment = "left",
			position = var_0_23,
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
								click_function = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
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
								content_check_function = function(arg_2_0)
									local var_2_0 = arg_2_0.button_hotspot

									return var_2_0.is_hover and not var_2_0.is_selected
								end
							},
							{
								pass_type = "texture",
								style_id = "background",
								texture_id = "background_selected",
								content_check_function = function(arg_3_0)
									local var_3_0 = arg_3_0.button_hotspot

									return var_3_0.is_selected and not var_3_0.is_hover
								end
							},
							{
								pass_type = "texture",
								style_id = "background",
								texture_id = "background_selected_hover",
								content_check_function = function(arg_4_0)
									local var_4_0 = arg_4_0.button_hotspot

									return var_4_0.is_selected and var_4_0.is_hover
								end
							},
							{
								pass_type = "texture",
								style_id = "locked_level",
								texture_id = "locked_level",
								content_check_function = function(arg_5_0)
									return arg_5_0.level_is_locked
								end
							},
							{
								pass_type = "texture",
								style_id = "locked_difficulty",
								texture_id = "locked_difficulty",
								content_check_function = function(arg_6_0)
									return arg_6_0.difficulty_is_locked
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
		host_text_button = UIWidgets.create_text_button("host_text_button", "lb_host", var_0_16.font_size),
		level_text_button = UIWidgets.create_text_button("level_text_button", "lb_level", var_0_16.font_size),
		difficulty_text_button = UIWidgets.create_text_button("difficulty_text_button", "lb_difficulty", var_0_16.font_size),
		players_text_button = UIWidgets.create_text_button("players_text_button", "lb_players", var_0_16.font_size),
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

local function var_0_31(arg_7_0, arg_7_1)
	local var_7_0 = var_0_30.widget_definitions.inventory_list_widget
	local var_7_1 = var_7_0.element.passes[2]
	local var_7_2 = var_7_0.style.hover
	local var_7_3 = var_7_2.size
	local var_7_4 = var_7_2.offset

	var_7_3[1] = arg_7_0
	var_7_3[2] = arg_7_1
	var_7_4[2] = 0
end

local function var_0_32(arg_8_0, arg_8_1)
	var_0_30.scenegraph_definition.scrollbar_root.size[2] = arg_8_1

	local var_8_0 = "mouse_scroll_field"
	local var_8_1 = {
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

	var_8_1.parent = "scrollbar_root"
	var_0_30.scenegraph_definition[var_8_0] = var_8_1
	var_0_30.widget_definitions.scroll_field = {
		element = {
			passes = {
				{
					pass_type = "scroll",
					scroll_function = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
						local var_9_0 = arg_9_2.scroll_step or 0.1
						local var_9_1 = arg_9_2.internal_scroll_value + var_9_0 * -arg_9_4.y

						arg_9_2.internal_scroll_value = math.clamp(var_9_1, 0, 1)
					end
				}
			}
		},
		content = {
			scroll_step = 0.05,
			internal_scroll_value = 0
		},
		style = {},
		scenegraph_id = var_8_0
	}
end

local function var_0_33(arg_10_0)
	local var_10_0 = arg_10_0.selected_mission_id or arg_10_0.mission_id
	local var_10_1 = arg_10_0.mechanism
	local var_10_2 = tonumber(arg_10_0.matchmaking_type)
	local var_10_3 = table.clone(NetworkLookup.matchmaking_types, true)
	local var_10_4

	var_10_4 = var_10_2 and var_10_3[var_10_2]

	if var_10_1 == "weave" then
		if var_10_0 ~= "false" and arg_10_0.weave_quick_game == "false" then
			local var_10_5 = string.split_deprecated(var_10_0, "_")

			return "Weave " .. var_10_5[2]
		elseif arg_10_0.weave_quick_game == "true" then
			return Localize("start_game_window_weave_quickplay_title")
		else
			return Localize("lb_unknown")
		end
	else
		local var_10_6 = var_10_0
		local var_10_7

		if var_10_6 == "n/a" then
			var_10_7 = "lb_unknown"
		elseif var_10_6 == "any" then
			var_10_7 = "map_screen_quickplay_button"
		else
			local var_10_8 = rawget(LevelSettings, var_10_6)

			if var_10_8 then
				var_10_7 = var_10_8.display_name
			end
		end

		return Localize(var_10_7 or "lb_unknown")
	end
end

local function var_0_34(arg_11_0)
	local var_11_0 = arg_11_0.selected_mission_id or arg_11_0.mission_id
	local var_11_1 = Application.make_hash(var_11_0)

	return Application.hex64_to_dec(var_11_1) or 0
end

local function var_0_35(arg_12_0)
	local var_12_0 = arg_12_0.difficulty
	local var_12_1 = var_12_0 and DifficultySettings[var_12_0]
	local var_12_2 = var_12_0 and var_12_1.display_name

	return var_12_0 and Localize(var_12_2) or "-"
end

local function var_0_36(arg_13_0)
	local var_13_0 = arg_13_0.difficulty
	local var_13_1 = var_13_0 and DifficultySettings[var_13_0]

	return var_13_0 and var_13_1.rank or 0
end

local function var_0_37(arg_14_0)
	local var_14_0 = arg_14_0.country_code

	return var_14_0 and iso_countries[var_14_0] or ""
end

local function var_0_38(arg_15_0)
	local var_15_0 = Managers.player
	local var_15_1 = var_15_0:local_player()
	local var_15_2 = var_15_0:statistics_db()
	local var_15_3 = var_15_1:stats_id()
	local var_15_4 = arg_15_0.weave_quick_game == "true"
	local var_15_5 = MatchmakingManager.is_lobby_private(arg_15_0)
	local var_15_6 = arg_15_0.mechanism
	local var_15_7 = var_15_6 and MechanismSettings[var_15_6]

	if var_15_5 then
		return true
	end

	local var_15_8 = arg_15_0.selected_mission_id or arg_15_0.mission_id

	if not var_15_8 then
		return false
	end

	if not WeaveSettings.templates[var_15_8] then
		local var_15_9 = rawget(LevelSettings, var_15_8)

		if not var_15_9 then
			return true
		end

		if var_15_9.hub_level then
			return false
		end
	end

	if var_15_7 and var_15_7.extra_requirements_function and not var_15_7.extra_requirements_function() then
		return true
	end

	if var_15_6 == "weave" then
		if not var_15_4 then
			local var_15_10 = false
			local var_15_11 = var_15_8

			if LevelUnlockUtils.weave_disabled(var_15_11) then
				return true
			end

			if LevelUnlockUtils.weave_unlocked(var_15_2, var_15_3, var_15_11, var_15_10) then
				return false
			end

			if LevelUnlockUtils.current_weave(var_15_2, var_15_3, var_15_10) == var_15_11 then
				return false
			end
		end

		return false
	end

	if not LevelUnlockUtils.level_unlocked(var_15_2, var_15_3, var_15_8) then
		return true
	end
end

local function var_0_39(arg_16_0)
	local var_16_0 = tonumber(arg_16_0.matchmaking_type)
	local var_16_1 = table.clone(NetworkLookup.matchmaking_types, true)[var_16_0]

	if arg_16_0.mechanism == "weave" then
		return false
	end

	local var_16_2 = arg_16_0.selected_mission_id or arg_16_0.mission_id
	local var_16_3 = Managers.player
	local var_16_4 = var_16_3:local_player()
	local var_16_5 = var_16_3:statistics_db()
	local var_16_6 = var_16_4:stats_id()
	local var_16_7 = arg_16_0.difficulty

	if not var_16_7 or not var_16_2 then
		return false
	end

	if var_16_7 then
		local var_16_8 = DifficultySettings[var_16_7]

		if var_16_8.extra_requirement_name then
			local var_16_9 = ExtraDifficultyRequirements[var_16_8.extra_requirement_name]

			if not Development.parameter("unlock_all_difficulties") and not var_16_9.requirement_function() then
				return true
			end
		end

		if var_16_8.dlc_requirement and not Managers.unlock:is_dlc_unlocked(var_16_8.dlc_requirement) then
			return true
		end
	end

	if not MatchmakingManager.is_lobby_private(arg_16_0) then
		local var_16_10 = var_16_4:profile_display_name()
		local var_16_11 = var_16_4:career_name()

		if not Managers.matchmaking:has_required_power_level(arg_16_0, var_16_10, var_16_11) then
			return true
		end
	end

	return false
end

local function var_0_40(arg_17_0)
	local var_17_0 = Managers.matchmaking.get_matchmaking_settings_for_mechanism(arg_17_0.mechanism)
	local var_17_1 = arg_17_0.num_players
	local var_17_2 = arg_17_0.matchmaking

	if not var_17_1 or not var_17_2 then
		return false
	end

	local var_17_3 = arg_17_0.matchmaking == "false"
	local var_17_4 = arg_17_0.num_players == var_17_0.MAX_NUMBER_OF_PLAYERS

	return arg_17_0.is_broken or var_17_4 or var_17_3
end

local var_0_41 = UIFrameSettings.menu_frame_12

local function var_0_42(arg_18_0)
	local var_18_0 = Network.peer_id()
	local var_18_1 = arg_18_0.host
	local var_18_2 = arg_18_0.server_name or arg_18_0.unique_server_name or arg_18_0.name or arg_18_0.host

	if var_18_1 == var_18_0 or not var_18_2 then
		return
	end

	local var_18_3 = var_0_33(arg_18_0)
	local var_18_4 = arg_18_0.num_players or 0
	local var_18_5 = var_0_35(arg_18_0)
	local var_18_6 = LobbyItemsList.lobby_status_text(arg_18_0)
	local var_18_7 = not arg_18_0.valid and "[INV]" .. var_18_6 or var_18_6
	local var_18_8 = var_0_37(arg_18_0)

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
		lobby_data = arg_18_0,
		title_text = var_18_2,
		level_text = var_18_3,
		difficulty_text = var_18_5,
		num_players_text = var_18_4 .. "/4",
		status_text = var_18_7,
		country_text = var_18_8,
		level_is_locked = var_0_38(arg_18_0),
		difficulty_is_locked = var_0_39(arg_18_0),
		status_is_locked = var_0_40(arg_18_0),
		frame = var_0_41.texture
	}
end

local function var_0_43()
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
		frame = var_0_41.texture
	}
end

local function var_0_44()
	return {
		frame = {
			texture_size = var_0_41.texture_size,
			texture_sizes = var_0_41.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			size = {
				var_0_15.width,
				var_0_15.height
			},
			offset = {
				0,
				0,
				5
			}
		},
		background = {
			size = {
				var_0_15.width,
				var_0_15.height
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
			offset = var_0_27
		},
		locked_difficulty = {
			size = {
				20,
				26
			},
			offset = var_0_28
		},
		locked_status = {
			size = {
				20,
				26
			},
			offset = var_0_29
		},
		title_text = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			font_type = "arial",
			size = {
				var_0_15.width,
				var_0_15.height
			},
			text_color = Colors.color_definitions.white,
			font_size = var_0_16.font_size,
			offset = var_0_20
		},
		level_text = {
			word_wrap = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = "arial",
			size = {
				var_0_15.width,
				var_0_15.height
			},
			text_color = Colors.color_definitions.white,
			font_size = var_0_16.font_size,
			area_size = {
				240,
				50
			},
			offset = var_0_21
		},
		difficulty_text = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			font_type = "arial",
			size = {
				var_0_15.width,
				var_0_15.height
			},
			text_color = Colors.color_definitions.white,
			font_size = var_0_16.font_size,
			offset = var_0_22
		},
		num_players_text = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			font_type = "arial",
			size = {
				var_0_15.width,
				var_0_15.height
			},
			text_color = Colors.color_definitions.white,
			font_size = var_0_16.font_size,
			offset = {
				var_0_23[1] + 5,
				var_0_23[2],
				var_0_23[3]
			}
		},
		status_text = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			font_type = "arial",
			size = {
				var_0_15.width,
				var_0_15.height
			},
			text_color = Colors.color_definitions.white,
			font_size = var_0_16.font_size,
			offset = var_0_24
		},
		country_text = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			font_type = "arial",
			size = {
				var_0_15.width,
				var_0_15.height
			},
			text_color = Colors.color_definitions.white,
			font_size = var_0_16.font_size,
			offset = var_0_25
		}
	}
end

LobbyItemsList = class(LobbyItemsList)

function LobbyItemsList.init(arg_21_0, arg_21_1, arg_21_2)
	arg_21_0.ui_renderer = arg_21_1.ui_top_renderer
	arg_21_0.input_manager = arg_21_1.input_manager

	local var_21_0 = arg_21_2.num_list_items

	if arg_21_2.use_top_renderer then
		arg_21_0.ui_renderer = arg_21_1.ui_top_renderer
	else
		arg_21_0.ui_renderer = arg_21_1.ui_renderer
	end

	arg_21_0.world_manager = arg_21_1.world_manager

	local var_21_1 = arg_21_0.world_manager:world("level_world")

	arg_21_0.wwise_world = Managers.world:wwise_world(var_21_1)

	local var_21_2 = var_0_30.scenegraph_definition
	local var_21_3 = var_21_2.item_list
	local var_21_4 = var_21_3.size[1]
	local var_21_5 = var_21_3.size[2]

	arg_21_2.list_size = {
		var_21_3.size[1],
		var_21_3.size[2]
	}

	var_0_32(var_21_4, var_21_5)
	var_0_31(var_21_4, var_21_5)

	arg_21_0.settings = arg_21_2
	arg_21_0.widget_definitions = var_0_30.widget_definitions
	arg_21_0.bar_animations = {}
	arg_21_0.inventory_list_animations = {}
	arg_21_0.scenegraph_definition = var_21_2
	arg_21_0.lobby_list = {}
	arg_21_0.input_service_name = arg_21_2.input_service_name

	arg_21_0:create_ui_elements(arg_21_2.offset)

	arg_21_0.list_style = {
		vertical_alignment = "top",
		scenegraph_id = "item_list",
		size = arg_21_2.list_size,
		list_member_offset = {
			0,
			-(var_0_15.height + var_0_15.height_spacing),
			0
		},
		item_styles = {}
	}
	arg_21_0.selected_list_index = 1
end

function LobbyItemsList.destroy(arg_22_0)
	return
end

function LobbyItemsList.lobby_status_text(arg_23_0)
	local var_23_0 = arg_23_0.server_info ~= nil
	local var_23_1 = Managers.matchmaking.get_matchmaking_settings_for_mechanism(arg_23_0.mechanism)
	local var_23_2 = arg_23_0.mission_id
	local var_23_3 = var_23_0 and arg_23_0.server_info.password or not var_23_0 and arg_23_0.matchmaking == "false"
	local var_23_4 = arg_23_0.num_players == var_23_1.MAX_NUMBER_OF_PLAYERS
	local var_23_5 = tonumber(arg_23_0.matchmaking_type)
	local var_23_6 = table.clone(NetworkLookup.matchmaking_types, true)
	local var_23_7 = var_23_5 and var_23_6[var_23_5]
	local var_23_8 = var_23_2

	if var_23_7 == "weave" then
		local var_23_9 = WeaveSettings.templates[var_23_2]

		if var_23_9 then
			local var_23_10 = var_23_9.objectives[1].level_id
		end
	end

	local var_23_11 = LevelSettings[var_23_2].hub_level
	local var_23_12 = arg_23_0.is_broken and "lb_broken" or var_23_3 and "lb_private" or var_23_4 and "lb_full" or var_23_11 and "lb_in_inn" or "lb_started"

	return var_23_12 and Localize(var_23_12) or ""
end

function LobbyItemsList.create_ui_elements(arg_24_0, arg_24_1)
	arg_24_0.ui_scenegraph = UISceneGraph.init_scenegraph(arg_24_0.scenegraph_definition)

	local var_24_0 = "scrollbar_root"
	local var_24_1 = arg_24_0.scenegraph_definition[var_24_0]

	arg_24_0.scrollbar_widget = UIWidget.init(UIWidgets.create_scrollbar(var_24_0, var_24_1.size))
	arg_24_0.item_list_widget = UIWidget.init(arg_24_0.widget_definitions.inventory_list_widget)
	arg_24_0.scroll_field_widget = UIWidget.init(arg_24_0.widget_definitions.scroll_field)
	arg_24_0.test = UIWidget.init(arg_24_0.widget_definitions.test)
	arg_24_0.window = UIWidget.init(arg_24_0.widget_definitions.window)
	arg_24_0.host_text_button = UIWidget.init(arg_24_0.widget_definitions.host_text_button)
	arg_24_0.level_text_button = UIWidget.init(arg_24_0.widget_definitions.level_text_button)
	arg_24_0.difficulty_text_button = UIWidget.init(arg_24_0.widget_definitions.difficulty_text_button)
	arg_24_0.players_text_button = UIWidget.init(arg_24_0.widget_definitions.players_text_button)
	arg_24_0.loading_overlay = UIWidget.init(arg_24_0.widget_definitions.loading_overlay)
	arg_24_0.loading_icon = UIWidget.init(arg_24_0.widget_definitions.loading_icon)
	arg_24_0.loading_text = UIWidget.init(arg_24_0.widget_definitions.loading_text)

	UIRenderer.clear_scenegraph_queue(arg_24_0.ui_renderer)

	if arg_24_1 then
		local var_24_2 = arg_24_0.ui_scenegraph.window.local_position

		var_24_2[1] = var_24_2[1] + arg_24_1[1]
		var_24_2[2] = var_24_2[2] + arg_24_1[2]
		var_24_2[3] = var_24_2[3] + arg_24_1[3]
	end
end

local function var_0_45(arg_25_0, arg_25_1)
	return (arg_25_0.server_name or arg_25_0.unique_server_name or arg_25_0.host or "") < (arg_25_1.server_name or arg_25_1.unique_server_name or arg_25_1.host or "")
end

local function var_0_46(arg_26_0, arg_26_1)
	return (arg_26_0.server_name or arg_26_0.unique_server_name or arg_26_0.host or "") > (arg_26_1.server_name or arg_26_1.unique_server_name or arg_26_1.host or "")
end

local function var_0_47(arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0.selected_mission_id or arg_27_0.mission_id or "lb_unknown"
	local var_27_1 = arg_27_1.selected_mission_id or arg_27_1.mission_id or "lb_unknown"

	return Localize(var_27_0) < Localize(var_27_1)
end

local function var_0_48(arg_28_0, arg_28_1)
	local var_28_0 = var_0_34(arg_28_0)
	local var_28_1 = var_0_34(arg_28_1)
	local var_28_2 = arg_28_0.selected_mission_id or arg_28_0.mission_id or "lb_unknown"
	local var_28_3 = arg_28_1.selected_mission_id or arg_28_1.mission_id or "lb_unknown"

	return Localize(var_28_2) > Localize(var_28_3)
end

local function var_0_49(arg_29_0, arg_29_1)
	return var_0_36(arg_29_0) < var_0_36(arg_29_1)
end

local function var_0_50(arg_30_0, arg_30_1)
	return var_0_36(arg_30_0) > var_0_36(arg_30_1)
end

local function var_0_51(arg_31_0, arg_31_1)
	return LobbyItemsList.lobby_status_text(arg_31_0) < LobbyItemsList.lobby_status_text(arg_31_1)
end

local function var_0_52(arg_32_0, arg_32_1)
	return LobbyItemsList.lobby_status_text(arg_32_0) > LobbyItemsList.lobby_status_text(arg_32_1)
end

local function var_0_53(arg_33_0, arg_33_1)
	return (tonumber(arg_33_0.num_players) or 0) < (tonumber(arg_33_1.num_players) or 0)
end

local function var_0_54(arg_34_0, arg_34_1)
	return (tonumber(arg_34_0.num_players) or 0) > (tonumber(arg_34_1.num_players) or 0)
end

local function var_0_55(arg_35_0, arg_35_1)
	return var_0_37(arg_35_0) < var_0_37(arg_35_1)
end

local function var_0_56(arg_36_0, arg_36_1)
	return var_0_37(arg_36_0) > var_0_37(arg_36_1)
end

function LobbyItemsList.update(arg_37_0, arg_37_1, arg_37_2)
	if arg_37_2 then
		if not arg_37_0._loading_previous_frame then
			arg_37_0:loading_overlay_fade_in(180)
		end

		arg_37_0:rotate_loading_icon(arg_37_1)
	elseif arg_37_0._loading_previous_frame then
		arg_37_0:loading_overlay_fade_out()
	end

	arg_37_0._loading_previous_frame = arg_37_2

	local var_37_0 = arg_37_0.item_list_widget
	local var_37_1 = var_37_0.content.list_content
	local var_37_2 = var_37_0.style.list_style
	local var_37_3 = arg_37_0.selected_list_index
	local var_37_4 = arg_37_0.hover_list_index
	local var_37_5 = arg_37_0.number_of_items_in_list
	local var_37_6 = arg_37_0.input_manager:is_device_active("gamepad")

	arg_37_0.lobby_list_index_changed = nil
	arg_37_0.inventory_list_index_pressed = nil

	local var_37_7 = #var_37_1

	if var_37_6 then
		if var_37_5 > 0 then
			arg_37_0:update_gamepad_list_scroll()
		end
	else
		arg_37_0.gamepad_changed_selected_list_index = nil
	end

	for iter_37_0 = 1, var_37_7 do
		local var_37_8 = var_37_1[iter_37_0]
		local var_37_9 = var_37_8.button_hotspot

		if not var_37_8.fake then
			if var_37_9.on_hover_enter then
				arg_37_0:play_sound("Play_hud_hover")

				var_37_9.on_hover_enter = false
			end

			if (var_37_9.is_selected or arg_37_0.gamepad_changed_selected_list_index == iter_37_0) and iter_37_0 ~= var_37_3 then
				arg_37_0.lobby_list_index_changed = iter_37_0

				arg_37_0:play_sound("Play_hud_select")

				break
			end
		end
	end

	arg_37_0:update_scroll()

	local var_37_10 = arg_37_0.host_text_button.content.button_text
	local var_37_11 = arg_37_0.level_text_button.content.button_text
	local var_37_12 = arg_37_0.difficulty_text_button.content.button_text
	local var_37_13 = arg_37_0.players_text_button.content.button_text

	if var_37_10.on_hover_enter or var_37_11.on_hover_enter or var_37_12.on_hover_enter or var_37_13.on_hover_enter then
		arg_37_0:play_sound("Play_hud_hover")
	end

	if var_37_10.on_pressed then
		local var_37_14 = arg_37_0:_pick_sort_func(var_0_45, var_0_46)
		local var_37_15 = arg_37_0.lobbies

		arg_37_0:populate_lobby_list(var_37_15, var_37_14)
		arg_37_0:play_sound("Play_hud_select")
	end

	if var_37_11.on_pressed then
		local var_37_16 = arg_37_0:_pick_sort_func(var_0_47, var_0_48)
		local var_37_17 = arg_37_0.lobbies

		arg_37_0:populate_lobby_list(var_37_17, var_37_16)
		arg_37_0:play_sound("Play_hud_select")
	end

	if var_37_12.on_pressed then
		local var_37_18 = arg_37_0:_pick_sort_func(var_0_49, var_0_50)
		local var_37_19 = arg_37_0.lobbies

		arg_37_0:populate_lobby_list(var_37_19, var_37_18)
		arg_37_0:play_sound("Play_hud_select")
	end

	if var_37_13.on_pressed then
		local var_37_20 = arg_37_0:_pick_sort_func(var_0_53, var_0_54)
		local var_37_21 = arg_37_0.lobbies

		arg_37_0:populate_lobby_list(var_37_21, var_37_20)
		arg_37_0:play_sound("Play_hud_select")
	end
end

function LobbyItemsList.handle_gamepad_input(arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = arg_38_0.input_manager:get_service(arg_38_0.input_service_name)
	local var_38_1 = arg_38_0.controller_cooldown

	if var_38_1 and var_38_1 > 0 then
		arg_38_0.controller_cooldown = var_38_1 - arg_38_1

		local var_38_2 = arg_38_0.speed_multiplier or 1
		local var_38_3 = GamepadSettings.menu_speed_multiplier_frame_decrease
		local var_38_4 = GamepadSettings.menu_min_speed_multiplier

		arg_38_0.speed_multiplier = math.max(var_38_2 - var_38_3, var_38_4)

		return
	else
		local var_38_5 = arg_38_0.selected_list_index or 1

		if var_38_5 then
			local var_38_6 = arg_38_0.speed_multiplier or 1
			local var_38_7
			local var_38_8 = var_38_0:get("move_up")
			local var_38_9 = var_38_0:get("move_up_hold")

			if var_38_8 or var_38_9 then
				var_38_7 = math.max(var_38_5 - 1, 1)
				arg_38_0.controller_cooldown = GamepadSettings.menu_cooldown * var_38_6
			else
				local var_38_10 = var_38_0:get("move_down")
				local var_38_11 = var_38_0:get("move_down_hold")

				if var_38_10 or var_38_11 then
					arg_38_0.controller_cooldown = GamepadSettings.menu_cooldown * var_38_6
					var_38_7 = math.min(var_38_5 + 1, arg_38_2)
				end
			end

			if var_38_7 and var_38_7 ~= var_38_5 then
				arg_38_0.gamepad_changed_selected_list_index = var_38_7

				return
			end
		end
	end

	arg_38_0.speed_multiplier = 1
end

function LobbyItemsList.update_gamepad_list_scroll(arg_39_0)
	local var_39_0 = arg_39_0.selected_list_index

	if not var_39_0 then
		return
	end

	local var_39_1, var_39_2 = arg_39_0:is_entry_outside(var_39_0)

	while var_39_1 do
		local var_39_3 = arg_39_0.scrollbar_widget.content.button_scroll_step
		local var_39_4 = arg_39_0.scroll_value

		if var_39_2 == "below" then
			var_39_4 = math.min(var_39_4 + var_39_3, 1)
		else
			var_39_4 = math.max(var_39_4 - var_39_3, 0)
		end

		if var_39_4 ~= arg_39_0.scroll_value then
			arg_39_0:set_scroll_amount(var_39_4)
		end

		var_39_1, var_39_2 = arg_39_0:is_entry_outside(arg_39_0.selected_list_index)
	end
end

function LobbyItemsList.is_entry_outside(arg_40_0, arg_40_1)
	local var_40_0 = arg_40_0.item_list_widget

	if var_40_0 then
		local var_40_1 = var_40_0.content.list_content
		local var_40_2 = var_40_0.style.list_style
		local var_40_3 = var_40_2.num_draws
		local var_40_4 = #var_40_1
		local var_40_5 = var_40_2.start_index

		if arg_40_1 < var_40_5 then
			return true, "above"
		elseif arg_40_1 > math.min(var_40_5 + var_40_3 - 1, var_40_4) then
			return true, "below"
		end
	end

	return false
end

function LobbyItemsList._pick_sort_func(arg_41_0, arg_41_1, arg_41_2)
	local var_41_0 = arg_41_0.sort_lobbies_function

	if var_41_0 and var_41_0 == arg_41_1 then
		var_41_0 = arg_41_2
	else
		var_41_0 = arg_41_1
	end

	arg_41_0.sort_lobbies_function = var_41_0

	return var_41_0
end

function LobbyItemsList.rotate_loading_icon(arg_42_0, arg_42_1)
	local var_42_0 = arg_42_0.loading_icon.style.texture_id
	local var_42_1 = ((var_42_0.fraction or 0) + arg_42_1) % 1

	var_42_0.angle = math.easeOutCubic(var_42_1) * math.degrees_to_radians(360)
	var_42_0.fraction = var_42_1
end

function LobbyItemsList.loading_overlay_fade_in(arg_43_0, arg_43_1)
	local var_43_0 = arg_43_0.loading_icon
	local var_43_1 = var_43_0.style.texture_id.color
	local var_43_2 = UIAnimation.init(UIAnimation.function_by_time, var_43_1, 1, var_43_1[1], 255, 0.3, math.easeOutCubic)

	table.clear(var_43_0.animations)

	var_43_0.animations[var_43_2] = true

	table.clear(arg_43_0.loading_overlay.animations)

	arg_43_0.loading_overlay.style.rect.color[1] = arg_43_1
end

function LobbyItemsList.loading_overlay_fade_out(arg_44_0)
	local function var_44_0(arg_45_0, arg_45_1)
		local var_45_0 = UIAnimation.init(UIAnimation.function_by_time, arg_45_1, 1, arg_45_1[1], 0, 0.3, math.easeOutCubic)

		table.clear(arg_45_0.animations)

		arg_45_0.animations[var_45_0] = true
	end

	var_44_0(arg_44_0.loading_overlay, arg_44_0.loading_overlay.style.rect.color)
	var_44_0(arg_44_0.loading_icon, arg_44_0.loading_icon.style.texture_id.color)
	var_44_0(arg_44_0.loading_text, arg_44_0.loading_text.style.text.text_color)
end

function LobbyItemsList.animate_loading_text(arg_46_0)
	local var_46_0 = arg_46_0.loading_text
	local var_46_1 = var_46_0.style.text.text_color

	if var_46_1[1] ~= 255 then
		local var_46_2 = UIAnimation.init(UIAnimation.function_by_time, var_46_1, 1, var_46_1[1], 255, 0.3, math.easeOutCubic, UIAnimation.wait, 3.2, UIAnimation.function_by_time, var_46_1, 1, 255, 0, 0.3, math.easeOutCubic)

		table.clear(var_46_0.animations)

		var_46_0.animations[var_46_2] = true
	end
end

function LobbyItemsList.draw(arg_47_0, arg_47_1)
	local var_47_0 = arg_47_0.ui_renderer
	local var_47_1 = arg_47_0.ui_scenegraph
	local var_47_2 = arg_47_0.input_manager:get_service(arg_47_0.input_service_name)

	UIRenderer.begin_pass(var_47_0, var_47_1, var_47_2, arg_47_1)
	UIRenderer.draw_widget(var_47_0, arg_47_0.item_list_widget)
	UIRenderer.draw_widget(var_47_0, arg_47_0.scroll_field_widget)
	UIRenderer.draw_widget(var_47_0, arg_47_0.scrollbar_widget)
	UIRenderer.draw_widget(var_47_0, arg_47_0.host_text_button)
	UIRenderer.draw_widget(var_47_0, arg_47_0.level_text_button)
	UIRenderer.draw_widget(var_47_0, arg_47_0.difficulty_text_button)
	UIRenderer.draw_widget(var_47_0, arg_47_0.players_text_button)
	UIRenderer.draw_widget(var_47_0, arg_47_0.loading_overlay)
	UIRenderer.draw_widget(var_47_0, arg_47_0.loading_icon)
	UIRenderer.draw_widget(var_47_0, arg_47_0.loading_text)
	UIRenderer.end_pass(var_47_0)
end

function LobbyItemsList.sort_lobbies(arg_48_0, arg_48_1, arg_48_2)
	table.sort(arg_48_1, arg_48_2)
end

function LobbyItemsList.remove_invalid_lobbies(arg_49_0, arg_49_1)
	local var_49_0 = {}
	local var_49_1 = #arg_49_1

	for iter_49_0 = 1, var_49_1 do
		local var_49_2 = arg_49_1[iter_49_0]

		if var_49_2 then
			var_49_0[#var_49_0 + 1] = var_49_2
		end
	end

	return var_49_0
end

function LobbyItemsList.populate_lobby_list(arg_50_0, arg_50_1, arg_50_2)
	local var_50_0 = arg_50_0.settings
	local var_50_1 = arg_50_0.item_list_widget
	local var_50_2 = {}
	local var_50_3 = arg_50_0.list_style
	local var_50_4 = 0
	local var_50_5 = arg_50_0.sort_lobbies_function
	local var_50_6 = arg_50_0:selected_lobby()
	local var_50_7 = arg_50_0:remove_invalid_lobbies(arg_50_1)

	if var_50_5 then
		arg_50_0:sort_lobbies(var_50_7, var_50_5)
	end

	for iter_50_0, iter_50_1 in pairs(var_50_7) do
		local var_50_8 = var_0_44()
		local var_50_9 = var_0_42(iter_50_1)

		if var_50_9 then
			var_50_4 = var_50_4 + 1
			var_50_2[var_50_4] = var_50_9
			var_50_3.item_styles[var_50_4] = var_50_8

			if var_50_4 >= var_0_18 then
				break
			end
		end
	end

	arg_50_0.lobbies = var_50_7
	arg_50_0.number_of_items_in_list = var_50_4
	var_50_1.content.list_content = var_50_2
	var_50_1.style.list_style = var_50_3
	var_50_1.style.list_style.start_index = 1
	var_50_1.style.list_style.num_draws = var_50_0.num_list_items
	var_50_1.element.pass_data[1].num_list_elements = nil

	local var_50_10 = var_50_1.style.list_style.num_draws

	if var_50_4 < var_50_10 then
		local var_50_11 = var_50_10 - var_50_4 % var_50_10

		if var_50_11 <= var_50_10 then
			for iter_50_2 = 1, var_50_11 do
				local var_50_12 = var_0_43()
				local var_50_13 = var_0_44()
				local var_50_14 = #var_50_2 + 1

				var_50_2[var_50_14] = var_50_12
				var_50_3.item_styles[var_50_14] = var_50_13
			end
		end
	end

	arg_50_0:set_scrollbar_length(nil, arg_50_2)

	arg_50_0.selected_list_index = nil
end

function LobbyItemsList.update_scroll(arg_51_0)
	local var_51_0 = arg_51_0.scrollbar_widget.content.scroll_bar_info.value
	local var_51_1 = arg_51_0.scroll_field_widget.content.internal_scroll_value
	local var_51_2 = arg_51_0.scroll_value

	if var_51_2 ~= var_51_1 then
		arg_51_0:set_scroll_amount(var_51_1)
	elseif var_51_2 ~= var_51_0 then
		arg_51_0:set_scroll_amount(var_51_0)
	end
end

function LobbyItemsList.set_scroll_amount(arg_52_0, arg_52_1)
	local var_52_0 = arg_52_0.scroll_value

	if not var_52_0 or arg_52_1 ~= var_52_0 then
		arg_52_0.scrollbar_widget.content.scroll_bar_info.value = arg_52_1
		arg_52_0.scroll_field_widget.content.internal_scroll_value = arg_52_1
		arg_52_0.scroll_value = arg_52_1

		arg_52_0:scroll_inventory_list(arg_52_1)
	end
end

function LobbyItemsList.set_scrollbar_length(arg_53_0, arg_53_1, arg_53_2)
	local var_53_0 = arg_53_0.settings
	local var_53_1 = var_53_0.columns
	local var_53_2 = var_53_0.num_list_items
	local var_53_3 = arg_53_0.number_of_items_in_list
	local var_53_4 = math.max(var_53_3 - var_53_2, 0)
	local var_53_5 = arg_53_0.scrollbar_widget.content
	local var_53_6 = var_53_5.scroll_bar_info
	local var_53_7 = 0
	local var_53_8 = 0

	if var_53_4 > 0 then
		local var_53_9 = var_53_1 and var_53_1 or 1
		local var_53_10 = math.ceil(var_53_4 / var_53_9)

		var_53_7 = 1 - 1 / math.ceil(var_53_3 / var_53_9) * var_53_10
		var_53_8 = 1 / var_53_10
	else
		var_53_7 = 1
		var_53_8 = 1
	end

	var_53_6.bar_height_percentage = var_53_7
	arg_53_0.scroll_field_widget.content.scroll_step = var_53_8
	var_53_5.button_scroll_step = var_53_8

	if arg_53_2 then
		local var_53_11 = arg_53_0.scroll_value

		arg_53_0.scroll_value = nil

		arg_53_0:set_scroll_amount(var_53_11 or 0)
	else
		arg_53_0:set_scroll_amount(arg_53_1 or 0)
	end
end

function LobbyItemsList.scroll_inventory_list(arg_54_0, arg_54_1)
	local var_54_0 = arg_54_0.item_list_widget

	if var_54_0 then
		local var_54_1 = var_54_0.content.list_content
		local var_54_2 = var_54_0.style.list_style
		local var_54_3 = var_54_2.num_draws
		local var_54_4 = var_54_2.columns
		local var_54_5 = #var_54_1

		if var_54_3 and var_54_3 < var_54_5 then
			local var_54_6 = var_54_5 - var_54_3
			local var_54_7 = math.max(0, math.round(arg_54_1 * var_54_6)) + 1

			if var_54_4 and var_54_7 % var_54_4 == 0 then
				var_54_7 = var_54_7 + var_54_4 - 1
			end

			var_54_2.start_index = var_54_7
		end
	end
end

function LobbyItemsList.on_lobby_selected(arg_55_0, arg_55_1, arg_55_2)
	local var_55_0 = arg_55_0.item_list_widget.content.list_content
	local var_55_1 = arg_55_0.number_of_items_in_list

	if not var_55_1 or var_55_1 < 1 then
		return
	end

	if arg_55_2 then
		arg_55_0:play_sound(arg_55_0.item_select_sound_event)
	end

	if arg_55_1 and var_55_0[arg_55_1] then
		for iter_55_0 = 1, #var_55_0 do
			var_55_0[iter_55_0].button_hotspot.is_selected = iter_55_0 == arg_55_1
		end

		arg_55_0.lobby_list_select_animation_time = 0
		arg_55_0.selected_list_index = arg_55_1
	end
end

function LobbyItemsList.selected_lobby(arg_56_0)
	local var_56_0 = arg_56_0.selected_list_index

	if not var_56_0 then
		return
	end

	local var_56_1 = arg_56_0.item_list_widget.content.list_content[var_56_0]

	if not var_56_1 then
		return
	end

	return var_56_1.lobby_data
end

function LobbyItemsList.set_selected_lobby(arg_57_0, arg_57_1)
	arg_57_0.selected_list_index = nil

	local var_57_0 = arg_57_1.id
	local var_57_1 = arg_57_0.item_list_widget.content.list_content
	local var_57_2 = arg_57_0.number_of_items_in_list

	for iter_57_0 = 1, var_57_2 do
		if var_57_0 == var_57_1[iter_57_0].lobby_data.id then
			arg_57_0:on_lobby_selected(iter_57_0, false)
		end
	end
end

function LobbyItemsList.animate_element_by_time(arg_58_0, arg_58_1, arg_58_2, arg_58_3, arg_58_4, arg_58_5)
	return (UIAnimation.init(UIAnimation.function_by_time, arg_58_1, arg_58_2, arg_58_3, arg_58_4, arg_58_5, math.easeInCubic))
end

function LobbyItemsList.play_sound(arg_59_0, arg_59_1)
	WwiseWorld.trigger_event(arg_59_0.wwise_world, arg_59_1)
end
