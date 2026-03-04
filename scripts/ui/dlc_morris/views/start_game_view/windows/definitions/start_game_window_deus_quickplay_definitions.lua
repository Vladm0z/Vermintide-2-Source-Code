-- chunkname: @scripts/ui/dlc_morris/views/start_game_view/windows/definitions/start_game_window_deus_quickplay_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.frame
local var_0_2 = var_0_0.size
local var_0_3 = UIFrameSettings[var_0_1].texture_sizes.horizontal[2]
local var_0_4 = {
	var_0_2[1],
	194
}
local var_0_5 = var_0_2[1]
local var_0_6 = {
	500,
	200
}
local var_0_7 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				arg_1_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = math.easeOutCubic(arg_2_3)

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
	},
	gamemode_text_swap = {
		{
			name = "gamemode_swap_text_fade_out",
			start_progress = 0,
			end_progress = 0.2,
			init = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				return
			end,
			update = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				local var_8_0 = math.easeOutCubic(arg_8_3)

				arg_8_2.style.game_mode_text.text_color[1] = 255 * (1 - var_8_0)
				arg_8_2.style.press_key_text.text_color[1] = 255 * (1 - var_8_0)

				if arg_8_2.content.show_note then
					arg_8_2.style.note_text.text_color[1] = 255 * (1 - var_8_0)
				end
			end,
			on_complete = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				return
			end
		},
		{
			name = "gamemode_swap_text_fade_in",
			start_progress = 0.2,
			end_progress = 0.4,
			init = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				return
			end,
			update = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				if arg_11_2.content.is_showing_info then
					arg_11_2.content.game_mode_text = Localize("expedition_info")
					arg_11_2.content.show_note = true
				else
					arg_11_2.content.game_mode_text = string.gsub(Localize("start_game_window_deus_quickplay_desc"), Localize("expedition_highlight_text"), "{#color(255,168,0)}" .. Localize("expedition_highlight_text") .. "{#reset()}")
					arg_11_2.content.show_note = false
				end

				arg_11_2.style.game_mode_text.text_color[1] = 255 * math.easeOutCubic(arg_11_3)
				arg_11_2.style.press_key_text.text_color[1] = 255 * math.easeOutCubic(arg_11_3)

				if arg_11_2.content.show_note then
					arg_11_2.style.note_text.text_color[1] = 255 * math.easeOutCubic(arg_11_3)
				end
			end,
			on_complete = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				return
			end
		}
	},
	right_arrow_flick = {
		{
			name = "right_arrow_flick",
			start_progress = 0,
			end_progress = 0.6,
			init = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				return
			end,
			update = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
				arg_14_4.right_key.color[1] = 255 * (1 - math.easeOutCubic(arg_14_3))
			end,
			on_complete = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				arg_15_2.content.right_arrow_pressed = false
			end
		}
	},
	left_arrow_flick = {
		{
			name = "left_arrow_flick",
			start_progress = 0,
			end_progress = 0.6,
			init = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				return
			end,
			update = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				arg_17_4.left_key.color[1] = 255 * (1 - math.easeOutCubic(arg_17_3))
			end,
			on_complete = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				arg_18_2.content.left_arrow_pressed = false
			end
		}
	},
	difficulty_info_enter = {
		{
			name = "difficulty_info_enter",
			start_progress = 0,
			end_progress = 0.6,
			init = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				arg_19_2.difficulty_info.content.visible = true

				local var_19_0 = arg_19_2.difficulty_info.style

				var_19_0.background.color[1] = 0
				var_19_0.border.color[1] = 0
				var_19_0.difficulty_description.text_color[1] = 0
				var_19_0.highest_obtainable_level.text_color[1] = 0
				var_19_0.difficulty_separator.color[1] = 0
			end,
			update = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
				local var_20_0 = math.easeOutCubic(arg_20_3)
				local var_20_1 = arg_20_2.difficulty_info
				local var_20_2 = arg_20_2.difficulty_info.style
				local var_20_3 = arg_20_2.difficulty_info.content

				var_20_1.offset[1] = 50 * var_20_0
				arg_20_2.upsell_button.offset[1] = 50 * var_20_0

				local var_20_4 = 200 * var_20_0

				var_20_2.background.color[1] = var_20_4
				var_20_2.border.color[1] = var_20_4

				local var_20_5 = 255 * var_20_0

				var_20_2.difficulty_description.text_color[1] = var_20_5
				var_20_2.highest_obtainable_level.text_color[1] = var_20_5
				var_20_2.difficulty_separator.color[1] = var_20_5

				if var_20_3.should_show_diff_lock_text then
					var_20_2.difficulty_lock_text.text_color[1] = var_20_5
				end

				if var_20_3.should_show_dlc_lock then
					var_20_2.dlc_lock_text.text_color[1] = var_20_5
				end
			end,
			on_complete = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				return
			end
		}
	}
}
local var_0_8 = {
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
	root_fit = {
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
		horizontal_alignment = "left",
		size = var_0_2,
		position = {
			220,
			0,
			1
		}
	},
	window_game_mode_root = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_2[1],
			var_0_3
		},
		position = {
			0,
			-var_0_3,
			1
		}
	},
	adventure_background = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_2[1] + 70,
			260
		},
		position = {
			0,
			-75,
			1
		}
	},
	game_option_3 = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_4[1],
			var_0_4[2]
		},
		position = {
			-15,
			-15,
			1
		}
	},
	game_option_2 = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_4[1],
			var_0_4[2]
		},
		position = {
			-15,
			-15 + var_0_4[2],
			1
		}
	},
	game_option_1 = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_4[1],
			var_0_4[2]
		},
		position = {
			-15,
			-105 + var_0_4[2] * 2,
			1
		}
	},
	play_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_4[1],
			72
		},
		position = {
			0,
			-40,
			1
		}
	},
	difficulty_stepper = {
		vertical_alignment = "bottom",
		parent = "game_option_1",
		horizontal_alignment = "center",
		size = {
			var_0_4[1],
			var_0_4[2]
		},
		position = {
			17.5,
			0,
			0
		}
	},
	difficulty_info = {
		vertical_alignment = "center",
		parent = "difficulty_stepper",
		horizontal_alignment = "center",
		size = var_0_6,
		position = {
			500,
			-10,
			0
		}
	},
	upsell_button = {
		vertical_alignment = "center",
		parent = "difficulty_info",
		horizontal_alignment = "center",
		size = {
			28,
			28
		},
		position = {
			218,
			0,
			2
		}
	}
}
local var_0_9 = true
local var_0_10 = {
	quickplay_gamemode_info_box = UIWidgets.create_start_game_deus_gamemode_info_box("adventure_background", var_0_8.adventure_background.size, Localize("start_game_window_adventure_title"), string.gsub(Localize("start_game_window_deus_quickplay_desc"), Localize("expedition_highlight_text"), "{#color(255,168,0)}" .. Localize("expedition_highlight_text") .. "{#reset()}"), false),
	difficulty_stepper = UIWidgets.create_start_game_difficulty_stepper("difficulty_stepper", Localize("start_game_window_difficulty"), "difficulty_option_1"),
	difficulty_info = UIWidgets.create_start_game_deus_difficulty_info_box("difficulty_info", var_0_8.difficulty_info.size),
	upsell_button = UIWidgets.create_simple_two_state_button("upsell_button", "icon_redirect", "icon_redirect_hover"),
	play_button = UIWidgets.create_start_game_deus_play_button("play_button", var_0_8.play_button.size, Localize("start_game_window_play"), 34, var_0_9)
}
local var_0_11 = {
	{
		widget_name = "difficulty_stepper",
		enter_requirements = function(arg_22_0)
			return true
		end,
		on_enter = function(arg_23_0, arg_23_1, arg_23_2)
			arg_23_0._widgets_by_name.difficulty_stepper.content.is_selected = true
		end,
		update = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
			local var_24_0 = arg_24_0._widgets_by_name.difficulty_stepper
			local var_24_1 = {
				difficulty_info = arg_24_0._widgets_by_name.difficulty_info,
				upsell_button = arg_24_0._widgets_by_name.upsell_button
			}

			if not arg_24_0.diff_info_anim_played then
				arg_24_0._diff_anim_id = arg_24_0._ui_animator:start_animation("difficulty_info_enter", var_24_1, var_0_8)
				arg_24_0.diff_info_anim_played = true
			end

			local var_24_2 = {}

			if arg_24_1:get("move_left") then
				arg_24_0:_option_selected("difficulty_stepper", "left_arrow", arg_24_3)

				var_24_0.content.left_arrow_pressed = true
				var_24_2.left_key = var_24_0.style.left_arrow_gamepad_highlight

				if arg_24_0._arrow_anim_id then
					arg_24_0._ui_animator:stop_animation(arg_24_0._arrow_anim_id)

					var_24_0.style.right_arrow_gamepad_highlight.color[1] = 0
				end

				arg_24_0._arrow_anim_id = arg_24_0._ui_animator:start_animation("left_arrow_flick", var_24_0, var_0_8, var_24_2)
			elseif arg_24_1:get("move_right") then
				arg_24_0:_option_selected("difficulty_stepper", "right_arrow", arg_24_3)

				var_24_0.content.right_arrow_pressed = true
				var_24_2.right_key = var_24_0.style.right_arrow_gamepad_highlight

				if arg_24_0._arrow_anim_id then
					arg_24_0._ui_animator:stop_animation(arg_24_0._arrow_anim_id)

					var_24_0.style.left_arrow_gamepad_highlight.color[1] = 0
				end

				arg_24_0._arrow_anim_id = arg_24_0._ui_animator:start_animation("right_arrow_flick", var_24_0, var_0_8, var_24_2)
			end

			if arg_24_1:get("confirm_press", true) and arg_24_0._dlc_locked then
				Managers.unlock:open_dlc_page(arg_24_0._dlc_name)
			end

			arg_24_0:_update_difficulty_lock()
		end,
		on_exit = function(arg_25_0, arg_25_1, arg_25_2)
			arg_25_0._widgets_by_name.difficulty_stepper.content.is_selected = false

			local var_25_0 = arg_25_0._widgets_by_name.upsell_button
			local var_25_1 = arg_25_0._widgets_by_name.difficulty_info

			if arg_25_0._diff_anim_id then
				arg_25_0._ui_animator:stop_animation(arg_25_0._diff_anim_id)
			end

			var_25_1.content.visible = false
			var_25_0.content.visible = false
			arg_25_0.diff_info_anim_played = false
		end
	},
	{
		widget_name = "play_button",
		enter_requirements = function(arg_26_0)
			return not Managers.input:is_device_active("gamepad")
		end,
		on_enter = function(arg_27_0, arg_27_1, arg_27_2)
			arg_27_0._widgets_by_name.play_button.content.is_selected = true
		end,
		update = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
			if arg_28_1:get("confirm_press") or arg_28_1:get("skip_press") then
				arg_28_0:_option_selected("play_button", nil, arg_28_3)
			end
		end,
		on_exit = function(arg_29_0, arg_29_1, arg_29_2)
			arg_29_0._widgets_by_name.play_button.content.is_selected = false
		end
	}
}

return {
	scenegraph_definition = var_0_8,
	widget_definitions = var_0_10,
	animation_definitions = var_0_7,
	selector_input_definitions = var_0_11
}
