-- chunkname: @scripts/settings/dlcs/morris/deus_swap_weapon_interaction_ui_definitions.lua

local var_0_0 = UISettings.console_menu_scenegraphs
local var_0_1 = {
	screen = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.interaction
		}
	},
	pivot = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			0
		}
	},
	background = {
		vertical_alignment = "bottom",
		parent = "pivot",
		horizontal_alignment = "left",
		size = {
			400,
			218
		},
		position = {
			50,
			-178,
			-1
		}
	},
	item_tooltip = {
		vertical_alignment = "top",
		parent = "pivot",
		horizontal_alignment = "left",
		size = {
			400,
			0
		},
		position = {
			50,
			-180,
			10
		}
	},
	chest_content = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "left",
		size = {
			400,
			100
		},
		position = {
			0,
			-80,
			10
		}
	}
}
local var_0_2 = {
	"equipped_item_title",
	"item_titles",
	"skin_applied",
	"fatigue",
	"item_power_level",
	"properties",
	"traits",
	"keywords"
}
local var_0_3 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.1,
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
	chest_unlock_failed = {
		{
			name = "bounce",
			start_progress = 0,
			end_progress = 0.5,
			init = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				arg_4_3.bounce_value = 1
			end,
			update = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = math.easeInCubic(arg_5_3)
				local var_5_1 = Managers.time:time("main")

				arg_5_0.pivot.local_position[1] = math.sin(var_5_1 * 50) * 10 * (arg_5_4.bounce_value - arg_5_3)
			end,
			on_complete = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		}
	}
}

local function var_0_4()
	return {
		scenegraph_id = "chest_content",
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "coin_icon",
					pass_type = "texture",
					content_check_function = function(arg_8_0)
						return arg_8_0.show_coin_icon
					end
				},
				{
					style_id = "cost_text",
					pass_type = "text",
					text_id = "cost_text",
					content_check_function = function(arg_9_0)
						return arg_9_0.cost_text
					end
				},
				{
					style_id = "rarity",
					pass_type = "text",
					text_id = "rarity_text",
					content_check_function = function(arg_10_0)
						return arg_10_0.rarity_text
					end
				},
				{
					style_id = "reward_info",
					pass_type = "text",
					text_id = "reward_info_text",
					content_check_function = function(arg_11_0)
						return arg_11_0.reward_info_text
					end
				},
				{
					style_id = "disabled_text",
					pass_type = "text",
					text_id = "disabled_text",
					content_check_function = function(arg_12_0)
						return arg_12_0.disabled_text
					end
				}
			}
		},
		content = {
			show_coin_icon = true,
			texture_id = "deus_icons_coin"
		},
		style = {
			coin_icon = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = {
					30,
					30
				},
				offset = {
					25,
					0,
					0
				}
			},
			cost_text = {
				vertical_alignment = "top",
				font_size = 28,
				localize = false,
				horizontal_alignment = "left",
				word_wrap = false,
				font_type = "hell_shark",
				text_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					60,
					0,
					0
				}
			},
			rarity = {
				vertical_alignment = "top",
				font_size = 18,
				localize = true,
				horizontal_alignment = "left",
				word_wrap = false,
				font_type = "hell_shark",
				text_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					25,
					-40,
					0
				}
			},
			reward_info = {
				vertical_alignment = "top",
				font_size = 28,
				localize = false,
				horizontal_alignment = "left",
				word_wrap = false,
				font_type = "hell_shark",
				text_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					25,
					-60,
					0
				}
			},
			disabled_text = {
				word_wrap = true,
				font_size = 28,
				localize = true,
				font_type = "hell_shark",
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				area_size = {
					350,
					200
				},
				text_color = {
					255,
					255,
					0,
					0
				},
				offset = {
					25,
					-20,
					0
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

local var_0_5 = true
local var_0_6 = {
	chest_content = var_0_4(),
	weapon_tooltip = UIWidgets.create_simple_item_presentation("item_tooltip", var_0_2, var_0_5),
	background = UIWidgets.create_simple_rect("background", {
		255,
		0,
		0,
		0
	}),
	frame = UIWidgets.create_frame("background", var_0_1.background.size, "item_tooltip_frame_01")
}

return {
	animation_definitions = var_0_3,
	scenegraph_definition = var_0_1,
	widgets = var_0_6
}
