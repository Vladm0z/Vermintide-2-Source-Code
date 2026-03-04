-- chunkname: @scripts/ui/hud_ui/challenge_tracker_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = {
	260,
	75
}
local var_0_3 = 20
local var_0_4 = true
local var_0_5 = {
	screen = {
		scale = "hud_scale_fit",
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			var_0_0,
			var_0_1
		}
	},
	pivot = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "right",
		position = {
			1,
			155,
			0
		},
		size = {
			0,
			0
		}
	},
	quest = {
		vertical_alignment = "top",
		parent = "pivot",
		horizontal_alignment = "right",
		position = {
			0,
			0,
			0
		},
		size = var_0_2
	}
}
local var_0_6 = UIAtlasHelper.get_atlas_settings_by_texture_name("objective_detail")
local var_0_7 = UIAtlasHelper.get_atlas_settings_by_texture_name("lily")
local var_0_8 = {
	scenegraph_id = "quest",
	element = {
		passes = {
			{
				style_id = "background_rect",
				pass_type = "rect",
				retained_mode = var_0_4
			},
			{
				pass_type = "texture",
				style_id = "background_lilies",
				texture_id = "background_id",
				retained_mode = var_0_4
			},
			{
				pass_type = "texture",
				style_id = "corner_top_right",
				texture_id = "corner_id",
				retained_mode = var_0_4
			},
			{
				pass_type = "texture",
				style_id = "corner_bot_right",
				texture_id = "corner_id",
				retained_mode = var_0_4
			},
			{
				pass_type = "texture",
				style_id = "lily",
				texture_id = "lily_id",
				retained_mode = var_0_4
			},
			{
				pass_type = "texture",
				style_id = "progress",
				texture_id = "progress_id",
				retained_mode = var_0_4
			},
			{
				pass_type = "texture",
				style_id = "progress_bg",
				texture_id = "progress_bg_id",
				retained_mode = var_0_4
			},
			{
				pass_type = "texture",
				style_id = "reward_icon",
				texture_id = "reward_icon",
				retained_mode = var_0_4
			},
			{
				style_id = "progress_text",
				pass_type = "text",
				text_id = "progress_text",
				retained_mode = var_0_4
			},
			{
				style_id = "challenge_name",
				pass_type = "text",
				text_id = "challenge_name",
				retained_mode = var_0_4
			},
			{
				style_id = "challenge_name_shadow",
				pass_type = "text",
				text_id = "challenge_name",
				retained_mode = var_0_4
			},
			{
				style_id = "reward_name",
				pass_type = "text",
				text_id = "reward_name",
				retained_mode = var_0_4
			},
			{
				style_id = "reward_name_shadow",
				pass_type = "text",
				text_id = "reward_name",
				retained_mode = var_0_4
			}
		}
	},
	content = {
		last_milestone = 0,
		progress_bg_id = "challenge_ui_progress_arc_bg",
		progress = 0,
		challenge_name = "NO CHALLENGE NAME",
		is_done = false,
		progress_text = "0/0",
		background_id = "challenge_ui_questingknight_bg",
		reward_name = "NO REWARD NAME",
		alpha_multiplier = 1,
		max_progress = 0,
		progress_id = "challenge_ui_progress_arc",
		last_progress = 0,
		lily_id = var_0_7.texture_name,
		corner_id = var_0_6.texture_name
	},
	style = {
		background_rect = {
			color = {
				200,
				0,
				0,
				0
			}
		},
		background_lilies = {
			color = {
				175,
				255,
				255,
				255
			}
		},
		corner_top_right = {
			vertical_alignment = "top",
			horizontal_alignment = "right",
			offset = {
				0,
				0.5 * var_0_6.size[2],
				1
			},
			texture_size = var_0_6.size,
			color = {
				255,
				255,
				255,
				255
			}
		},
		corner_bot_right = {
			vertical_alignment = "bottom",
			horizontal_alignment = "right",
			offset = {
				0,
				-0.5 * var_0_6.size[2],
				1
			},
			texture_size = var_0_6.size,
			color = {
				255,
				255,
				255,
				255
			}
		},
		lily = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			offset = {
				-0.5 * var_0_7.size[1] + 3,
				0,
				5
			},
			texture_size = var_0_7.size,
			color = {
				255,
				255,
				255,
				255
			}
		},
		progress = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			color = Colors.get_color_table_with_alpha("es_questingknight", 255),
			offset = {
				-5,
				0,
				1
			},
			texture_size = {
				70,
				70
			}
		},
		progress_bg = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			color = {
				200,
				200,
				200,
				200
			},
			offset = {
				-5,
				0,
				0
			},
			texture_size = {
				70,
				70
			}
		},
		challenge_name = {
			font_size = 22,
			upper_case = false,
			localize = false,
			word_wrap = false,
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			dynamic_font_size = true,
			font_type = "hell_shark_header",
			size = {
				var_0_2[1] - 95,
				var_0_2[2] * 0.5
			},
			text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				20,
				var_0_2[2] * 0.5,
				1
			}
		},
		challenge_name_shadow = {
			font_size = 22,
			upper_case = false,
			localize = false,
			word_wrap = false,
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			dynamic_font_size = true,
			font_type = "hell_shark_header",
			size = {
				var_0_2[1] - 95,
				var_0_2[2] * 0.5
			},
			text_color = {
				255,
				0,
				0,
				0
			},
			offset = {
				22,
				var_0_2[2] * 0.5 - 2,
				0
			}
		},
		reward_name = {
			word_wrap = true,
			upper_case = false,
			localize = false,
			dynamic_font_size_word_wrap = true,
			font_size = 20,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			font_type = "hell_shark_header",
			size = {
				var_0_2[1] - 95,
				var_0_2[2] * 0.5
			},
			text_color = Colors.get_color_table_with_alpha("es_questingknight", 255),
			offset = {
				20,
				5,
				1
			}
		},
		reward_name_shadow = {
			word_wrap = true,
			upper_case = false,
			localize = false,
			dynamic_font_size_word_wrap = true,
			font_size = 20,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			font_type = "hell_shark_header",
			size = {
				var_0_2[1] - 95,
				var_0_2[2] * 0.5
			},
			text_color = {
				255,
				0,
				0,
				0
			},
			offset = {
				22,
				3,
				0
			}
		},
		reward_icon = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			texture_size = {
				60,
				60
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-10,
				7,
				50
			}
		},
		progress_text = {
			font_size = 12,
			upper_case = false,
			localize = false,
			word_wrap = false,
			horizontal_alignment = "center",
			vertical_alignment = "bottom",
			dynamic_font_size = true,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				var_0_2[1] * 0.5 - 40,
				10,
				1
			}
		}
	}
}

local function var_0_9(arg_1_0, arg_1_1)
	return {
		arg_1_0[1],
		arg_1_0[2] - (var_0_2[2] + var_0_3) * (arg_1_1 - 1),
		arg_1_0[3]
	}
end

local function var_0_10(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = UIWidget.init(var_0_8)

	var_2_0.offset = var_0_9(arg_2_2, arg_2_3)

	local var_2_1 = var_2_0.content

	var_2_1.challenge = arg_2_0
	var_2_1.challenge_name = Localize(arg_2_0:get_challenge_name())

	if arg_2_0:is_repeatable() then
		var_2_0.style.background_rect.color = {
			200,
			15,
			10,
			5
		}
		var_2_0.style.background_lilies.color = {
			200,
			255,
			255,
			255
		}
	end

	local var_2_2 = arg_2_0:get_reward()
	local var_2_3 = arg_2_0:get_reward_name()

	var_2_1.reward_name = UIUtils.format_localized_description(var_2_3, var_2_2.description_values)
	var_2_1.reward_icon = var_2_2.icon

	local var_2_4, var_2_5 = arg_2_0:get_progress()

	var_2_1.progress = var_2_4
	var_2_1.last_progress = var_2_4
	var_2_1.max_progress = var_2_5
	var_2_1.start_anim_progress = var_2_4 / var_2_5
	var_2_1.last_milestone = math.floor(var_2_1.start_anim_progress * 4)

	local var_2_6 = var_2_1.progress_id
	local var_2_7 = var_2_1.progress_id .. math.uuid()

	Gui.clone_material_from_template(arg_2_1, var_2_7, var_2_6)

	var_2_1.progress_id = var_2_7
	var_2_1.progress_text = tostring(var_2_5 - var_2_4)

	return var_2_0
end

local var_0_11 = {
	on_enter = {
		{
			name = "ease_in",
			delay = 0.5,
			duration = 1,
			init = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				local var_3_0 = arg_3_2.offset

				arg_3_3.src = {
					var_3_0[1] + 1.5 * var_0_2[2],
					var_3_0[2]
				}
				arg_3_3.dst = {
					var_3_0[1],
					var_3_0[2]
				}
				arg_3_2.content.alpha_multiplier = 0
				arg_3_2.offset[1] = arg_3_3.src[1]
				arg_3_2.offset[2] = arg_3_3.src[2]

				local var_3_1 = var_0_4 and arg_3_3.ui_renderer.gui_retained or arg_3_3.ui_renderer.gui
				local var_3_2 = arg_3_2.content
				local var_3_3 = Gui.material(var_3_1, arg_3_2.content.progress_id)

				Material.set_scalar(var_3_3, "angle", (var_3_2.start_anim_progress - 0.5) * math.pi * 2)
			end,
			update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
				local var_4_0 = math.easeOutCubic(arg_4_3)

				arg_4_2.content.alpha_multiplier = var_4_0
				arg_4_2.offset[1] = math.floor(math.lerp(arg_4_4.src[1], arg_4_4.dst[1], var_4_0))
				arg_4_2.offset[2] = math.floor(math.lerp(arg_4_4.src[2], arg_4_4.dst[2], var_4_0))
			end,
			on_complete = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				arg_5_3.view:_play_sound("Play_hud_grail_knight_quest_start")
			end
		}
	},
	on_progress = {
		{
			name = "update circle",
			duration = 0.2,
			init = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				local var_6_0 = arg_6_2.content
				local var_6_1 = var_6_0.progress
				local var_6_2 = var_6_0.max_progress

				var_6_0.start_anim_progress = var_6_0.start_anim_progress or 0
				var_6_0.end_anim_progress = var_6_1 / var_6_2
				var_6_0.progress_text = tostring(var_6_2 - var_6_1)
			end,
			update = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
				local var_7_0 = arg_7_2.content
				local var_7_1 = var_0_4 and arg_7_4.ui_renderer.gui_retained or arg_7_4.ui_renderer.gui
				local var_7_2 = Gui.material(var_7_1, arg_7_2.content.progress_id)
				local var_7_3 = var_7_0.start_anim_progress
				local var_7_4 = var_7_0.end_anim_progress
				local var_7_5 = math.lerp(var_7_3, var_7_4, arg_7_3)

				Material.set_scalar(var_7_2, "angle", (var_7_5 - 0.5) * math.pi * 2)

				if var_7_4 > (var_7_0.last_milestone + 1) / 4 and var_7_4 < 1 then
					arg_7_4.view:_play_sound("Play_hud_grail_knight_quest_milestone_finish")

					var_7_0.last_milestone = math.floor(var_7_4 * 4)
				end
			end,
			on_complete = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				local var_8_0 = arg_8_2.content

				var_8_0.start_anim_progress = var_8_0.end_anim_progress
			end
		}
	},
	on_done = {
		{
			name = "fade and play sound",
			delay = 0.5,
			duration = 1,
			init = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				arg_9_3.view:_play_sound("Play_hud_grail_knight_quest_finish")
			end,
			update = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
				arg_10_2.content.alpha_multiplier = 1 - arg_10_3
			end,
			on_complete = NOP
		},
		{
			name = "play sound",
			delay = 2.2,
			duration = 0.1,
			init = NOP,
			update = NOP,
			on_complete = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				local var_11_0 = arg_11_2.content.challenge
				local var_11_1 = var_11_0:get_reward().sound

				if var_11_1 then
					arg_11_3.view:_play_sound(var_11_1)
				end

				arg_11_3.view:_cb_on_done(arg_11_2, var_11_0)
			end
		}
	},
	on_cancel = {
		{
			name = "fade",
			delay = 0.5,
			duration = 1,
			init = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				return
			end,
			update = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
				arg_13_2.content.alpha_multiplier = 1 - arg_13_3
			end,
			on_complete = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				local var_14_0 = arg_14_2.content.challenge

				arg_14_3.view:_cb_on_done(arg_14_2, var_14_0)
			end
		}
	}
}

return {
	animation_definitions = var_0_11,
	scenegraph_definition = var_0_5,
	create_objective = var_0_10,
	get_widget_position = var_0_9,
	RETAINED_MODE_ENABLED = var_0_4
}
