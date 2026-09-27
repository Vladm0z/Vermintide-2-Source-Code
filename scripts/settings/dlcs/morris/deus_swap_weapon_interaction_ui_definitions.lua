-- chunkname: @scripts/settings/dlcs/morris/deus_swap_weapon_interaction_ui_definitions.lua

local console_menu_scenegraphs = UISettings.console_menu_scenegraphs
local tbl = {
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
local tbl_2 = {
	"equipped_item_title",
	"item_titles",
	"skin_applied",
	"fatigue",
	"item_power_level",
	"properties",
	"traits",
	"keywords"
}
local tbl_3 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.1,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				-- function 1
				arg_1_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				-- function 2
				local easeInCubic = math.easeInCubic(arg_2_3)

				arg_2_4.render_settings.alpha_multiplier = easeInCubic
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				-- function 3
				return
			end
		}
	},
	chest_unlock_failed = {
		{
			name = "bounce",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				arg_4_3.bounce_value = 1
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				-- function 5
				local easeInCubic = math.easeInCubic(arg_5_3)
				local time = Managers.time:time("main")

				arg_5_0.pivot.local_position[1] = math.sin(time * 50) * 10 * (arg_5_4.bounce_value - arg_5_3)
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				return
			end
		}
	}
}

local function fn()
	-- function 7
	return {
		scenegraph_id = "chest_content",
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "coin_icon",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 8
						return self.show_coin_icon
					end
				},
				{
					style_id = "cost_text",
					pass_type = "text",
					text_id = "cost_text",
					content_check_function = function (self)
						-- function 9
						return self.cost_text
					end
				},
				{
					style_id = "rarity",
					pass_type = "text",
					text_id = "rarity_text",
					content_check_function = function (self)
						-- function 10
						return self.rarity_text
					end
				},
				{
					style_id = "reward_info",
					pass_type = "text",
					text_id = "reward_info_text",
					content_check_function = function (self)
						-- function 11
						return self.reward_info_text
					end
				},
				{
					style_id = "disabled_text",
					pass_type = "text",
					text_id = "disabled_text",
					content_check_function = function (self)
						-- function 12
						return self.disabled_text
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

local flag = true
local tbl_4 = {
	chest_content = fn(),
	weapon_tooltip = UIWidgets.create_simple_item_presentation("item_tooltip", tbl_2, flag),
	background = UIWidgets.create_simple_rect("background", {
		255,
		0,
		0,
		0
	}),
	frame = UIWidgets.create_frame("background", tbl.background.size, "item_tooltip_frame_01")
}

return {
	animation_definitions = tbl_3,
	scenegraph_definition = tbl,
	widgets = tbl_4
}
