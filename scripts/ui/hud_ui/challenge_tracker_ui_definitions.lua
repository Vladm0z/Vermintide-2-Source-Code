-- chunkname: @scripts/ui/hud_ui/challenge_tracker_ui_definitions.lua

local num = 1920
local num_2 = 1080
local tbl = {
	260,
	75
}
local num_3 = 20
local flag = true
local tbl_2 = {
	screen = {
		scale = "hud_scale_fit",
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			num,
			num_2
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
		size = tbl
	}
}
local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name("objective_detail")
local get_atlas_settings_by_texture_name_2 = UIAtlasHelper.get_atlas_settings_by_texture_name("lily")
local tbl_3 = {
	scenegraph_id = "quest",
	element = {
		passes = {
			{
				style_id = "background_rect",
				pass_type = "rect",
				retained_mode = flag
			},
			{
				pass_type = "texture",
				style_id = "background_lilies",
				texture_id = "background_id",
				retained_mode = flag
			},
			{
				pass_type = "texture",
				style_id = "corner_top_right",
				texture_id = "corner_id",
				retained_mode = flag
			},
			{
				pass_type = "texture",
				style_id = "corner_bot_right",
				texture_id = "corner_id",
				retained_mode = flag
			},
			{
				pass_type = "texture",
				style_id = "lily",
				texture_id = "lily_id",
				retained_mode = flag
			},
			{
				pass_type = "texture",
				style_id = "progress",
				texture_id = "progress_id",
				retained_mode = flag
			},
			{
				pass_type = "texture",
				style_id = "progress_bg",
				texture_id = "progress_bg_id",
				retained_mode = flag
			},
			{
				pass_type = "texture",
				style_id = "reward_icon",
				texture_id = "reward_icon",
				retained_mode = flag
			},
			{
				style_id = "progress_text",
				pass_type = "text",
				text_id = "progress_text",
				retained_mode = flag
			},
			{
				style_id = "challenge_name",
				pass_type = "text",
				text_id = "challenge_name",
				retained_mode = flag
			},
			{
				style_id = "challenge_name_shadow",
				pass_type = "text",
				text_id = "challenge_name",
				retained_mode = flag
			},
			{
				style_id = "reward_name",
				pass_type = "text",
				text_id = "reward_name",
				retained_mode = flag
			},
			{
				style_id = "reward_name_shadow",
				pass_type = "text",
				text_id = "reward_name",
				retained_mode = flag
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
		lily_id = get_atlas_settings_by_texture_name_2.texture_name,
		corner_id = get_atlas_settings_by_texture_name.texture_name
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
				0.5 * get_atlas_settings_by_texture_name.size[2],
				1
			},
			texture_size = get_atlas_settings_by_texture_name.size,
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
				-0.5 * get_atlas_settings_by_texture_name.size[2],
				1
			},
			texture_size = get_atlas_settings_by_texture_name.size,
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
				-0.5 * get_atlas_settings_by_texture_name_2.size[1] + 3,
				0,
				5
			},
			texture_size = get_atlas_settings_by_texture_name_2.size,
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
				tbl[1] - 95,
				tbl[2] * 0.5
			},
			text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				20,
				tbl[2] * 0.5,
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
				tbl[1] - 95,
				tbl[2] * 0.5
			},
			text_color = {
				255,
				0,
				0,
				0
			},
			offset = {
				22,
				tbl[2] * 0.5 - 2,
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
				tbl[1] - 95,
				tbl[2] * 0.5
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
				tbl[1] - 95,
				tbl[2] * 0.5
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
				tbl[1] * 0.5 - 40,
				10,
				1
			}
		}
	}
}

local function fn(self, arg_1_1)
	-- function 1
	return {
		self[1],
		self[2] - (tbl[2] + num_3) * (arg_1_1 - 1),
		self[3]
	}
end

local function fn_2(self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local var_2_0 = UIWidget.init(tbl_3)

	var_2_0.offset = fn(arg_2_2, arg_2_3)

	local content = var_2_0.content

	content.challenge = self
	content.challenge_name = Localize(self:get_challenge_name())

	if not self:is_repeatable() then
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

	local get_reward = self:get_reward()
	local get_reward_name = self:get_reward_name()

	content.reward_name = UIUtils.format_localized_description(get_reward_name, get_reward.description_values)
	content.reward_icon = get_reward.icon

	local get_progress, var_2_5 = self:get_progress()

	content.progress = get_progress
	content.last_progress = get_progress
	content.max_progress = var_2_5
	content.start_anim_progress = get_progress / var_2_5
	content.last_milestone = math.floor(content.start_anim_progress * 4)

	local progress_id = content.progress_id
	local str = content.progress_id .. math.uuid()

	Gui.clone_material_from_template(arg_2_1, str, progress_id)

	content.progress_id = str
	content.progress_text = tostring(var_2_5 - get_progress)

	return var_2_0
end

local tbl_4 = {
	on_enter = {
		{
			name = "ease_in",
			delay = 0.5,
			duration = 1,
			init = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				-- function 3
				local offset = arg_3_2.offset

				arg_3_3.src = {
					offset[1] + 1.5 * tbl[2],
					offset[2]
				}
				arg_3_3.dst = {
					offset[1],
					offset[2]
				}
				arg_3_2.content.alpha_multiplier = 0
				arg_3_2.offset[1] = arg_3_3.src[1]
				arg_3_2.offset[2] = arg_3_3.src[2]

				local gui_retained

				if not flag then
					gui_retained = arg_3_3.ui_renderer.gui_retained

					if not gui_retained then
						-- Nothing
					end
				end

				gui_retained = arg_3_3.ui_renderer.gui

				::label_3_0::

				local content = arg_3_2.content
				local material = Gui.material(gui_retained, arg_3_2.content.progress_id)

				Material.set_scalar(material, "angle", (content.start_anim_progress - 0.5) * math.pi * 2)
			end,
			update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
				-- function 4
				local easeOutCubic = math.easeOutCubic(arg_4_3)

				arg_4_2.content.alpha_multiplier = easeOutCubic
				arg_4_2.offset[1] = math.floor(math.lerp(arg_4_4.src[1], arg_4_4.dst[1], easeOutCubic))
				arg_4_2.offset[2] = math.floor(math.lerp(arg_4_4.src[2], arg_4_4.dst[2], easeOutCubic))
			end,
			on_complete = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				-- function 5
				arg_5_3.view:_play_sound("Play_hud_grail_knight_quest_start")
			end
		}
	},
	on_progress = {
		{
			name = "update circle",
			duration = 0.2,
			init = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				local content = arg_6_2.content
				local progress = content.progress
				local max_progress = content.max_progress
				local start_anim_progress = content.start_anim_progress

				start_anim_progress = start_anim_progress or 0
				content.start_anim_progress = start_anim_progress
				content.end_anim_progress = progress / max_progress
				content.progress_text = tostring(max_progress - progress)
			end,
			update = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
				-- function 7
				local content = arg_7_2.content
				local gui_retained

				if not flag then
					gui_retained = arg_7_4.ui_renderer.gui_retained

					if not gui_retained then
						-- Nothing
					end
				end

				gui_retained = arg_7_4.ui_renderer.gui

				::label_7_0::

				local material = Gui.material(gui_retained, arg_7_2.content.progress_id)
				local start_anim_progress = content.start_anim_progress
				local end_anim_progress = content.end_anim_progress
				local lerp = math.lerp(start_anim_progress, end_anim_progress, arg_7_3)

				Material.set_scalar(material, "angle", (lerp - 0.5) * math.pi * 2)

				if not (not (end_anim_progress > (content.last_milestone + 1) / 4) or not (end_anim_progress < 1)) then
					arg_7_4.view:_play_sound("Play_hud_grail_knight_quest_milestone_finish")

					content.last_milestone = math.floor(end_anim_progress * 4)
				end
			end,
			on_complete = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				-- function 8
				local content = arg_8_2.content

				content.start_anim_progress = content.end_anim_progress
			end
		}
	},
	on_done = {
		{
			name = "fade and play sound",
			delay = 0.5,
			duration = 1,
			init = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				-- function 9
				arg_9_3.view:_play_sound("Play_hud_grail_knight_quest_finish")
			end,
			update = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
				-- function 10
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
				-- function 11
				local challenge = arg_11_2.content.challenge
				local sound = challenge:get_reward().sound

				if not sound then
					arg_11_3.view:_play_sound(sound)
				end

				arg_11_3.view:_cb_on_done(arg_11_2, challenge)
			end
		}
	},
	on_cancel = {
		{
			name = "fade",
			delay = 0.5,
			duration = 1,
			init = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				-- function 12
				return
			end,
			update = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
				-- function 13
				arg_13_2.content.alpha_multiplier = 1 - arg_13_3
			end,
			on_complete = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				-- function 14
				local challenge = arg_14_2.content.challenge

				arg_14_3.view:_cb_on_done(arg_14_2, challenge)
			end
		}
	}
}

return {
	animation_definitions = tbl_4,
	scenegraph_definition = tbl_2,
	create_objective = fn_2,
	get_widget_position = fn,
	RETAINED_MODE_ENABLED = flag
}
