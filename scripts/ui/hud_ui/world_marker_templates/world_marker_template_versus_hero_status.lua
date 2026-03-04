-- chunkname: @scripts/ui/hud_ui/world_marker_templates/world_marker_template_versus_hero_status.lua

WorldMarkerTemplates = WorldMarkerTemplates or {}

local var_0_0 = "versus_hero_status"
local var_0_1 = WorldMarkerTemplates[var_0_0] or {}

WorldMarkerTemplates[var_0_0] = var_0_1

local function var_0_2(arg_1_0)
	if not arg_1_0 then
		return 255
	end

	return 165 + 90 * math.sin(5 * Managers.time:time("ui"))
end

var_0_1.max_distance = 50
var_0_1.unit_node = "j_head"
var_0_1.screen_clamp = false
var_0_1.position_offset = {
	0,
	0,
	0.4
}
var_0_1.screen_margins = {
	down = 150,
	up = 150,
	left = 150,
	right = 150
}

function var_0_1.create_widget_definition(arg_2_0)
	local var_2_0 = {
		80,
		10
	}

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "frame",
					texture_id = "frame"
				},
				{
					pass_type = "rect",
					style_id = "health_bg",
					texture_id = "rect"
				},
				{
					pass_type = "rect",
					style_id = "total_health_bar",
					texture_id = "rect"
				},
				{
					pass_type = "rect",
					style_id = "perm_health_bar",
					texture_id = "rect"
				},
				{
					pass_type = "rect",
					style_id = "streak_health_bar",
					texture_id = "rect",
					content_check_function = function(arg_3_0)
						return arg_3_0.streak_damage_percent > 0
					end
				},
				{
					style_id = "player_name",
					pass_type = "text",
					text_id = "player_name"
				},
				{
					style_id = "player_name_shadow",
					pass_type = "text",
					text_id = "player_name"
				}
			}
		},
		content = {
			rect = "versus_floating_hero_health_fill",
			player_name = "player_name",
			stored_health_percent = 1,
			streak_damage_percent = 0,
			frame = "versus_floating_hero_health_frame"
		},
		style = {
			frame = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = var_2_0,
				default_size = var_2_0,
				color = {
					255,
					45,
					33,
					27
				},
				offset = {
					0,
					0,
					5
				}
			},
			health_bg = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					var_2_0[1] - 4,
					var_2_0[2] - 3
				},
				default_size = {
					var_2_0[1] - 4,
					var_2_0[2] - 3
				},
				color = {
					100,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					2
				}
			},
			perm_health_bar = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					var_2_0[1] - 4,
					var_2_0[2] - 3
				},
				default_size = {
					var_2_0[1] - 4,
					var_2_0[2] - 3
				},
				color = {
					255,
					32,
					103,
					33
				},
				offset = {
					0,
					0,
					4
				}
			},
			streak_health_bar = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					var_2_0[1] - 4,
					var_2_0[2] - 3
				},
				default_size = {
					var_2_0[1] - 4,
					var_2_0[2] - 3
				},
				color = {
					255,
					139,
					0,
					0
				},
				offset = {
					0,
					0,
					4
				}
			},
			total_health_bar = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					var_2_0[1] - 4,
					var_2_0[2] - 3
				},
				default_size = {
					var_2_0[1] - 4,
					var_2_0[2] - 3
				},
				color = {
					255,
					195,
					195,
					195
				},
				base_color = {
					255,
					195,
					195,
					195
				},
				offset = {
					0,
					0,
					3
				}
			},
			player_name = {
				horizontal_alignment = "center",
				font_size = 18,
				use_shadow = true,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("opponent_team", 255),
				offset = {
					-100,
					-4,
					2
				},
				size = {
					200,
					40
				},
				shadow_offset = {
					-1,
					1,
					0
				}
			},
			player_name_shadow = {
				vertical_alignment = "center",
				font_size = 18,
				font_type = "hell_shark",
				dynamic_font_size = true,
				horizontal_alignment = "center",
				text_color = {
					255,
					0,
					0,
					0
				},
				offset = {
					-99,
					-5,
					1
				},
				size = {
					200,
					40
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_2_0
	}
end

function var_0_1.on_enter(arg_4_0)
	arg_4_0.content.spawn_progress_timer = 0
end

function var_0_1.update_function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_2.unit

	if not Unit.alive(var_5_0) then
		return false
	end

	local var_5_1 = arg_5_2.extensions

	if not var_5_1 then
		var_5_1 = {
			career = ScriptUnit.extension(var_5_0, "career_system"),
			health = ScriptUnit.extension(var_5_0, "health_system"),
			status = ScriptUnit.extension(var_5_0, "status_system"),
			inventory = ScriptUnit.extension(var_5_0, "inventory_system"),
			buff = ScriptUnit.extension(var_5_0, "buff_system")
		}
		arg_5_2.extensions = var_5_1
	end

	local var_5_2 = arg_5_1.content
	local var_5_3 = arg_5_1.style
	local var_5_4 = var_5_1.status
	local var_5_5 = var_5_1.health
	local var_5_6 = var_5_1.inventory
	local var_5_7 = var_5_4:is_knocked_down()
	local var_5_8 = var_5_4:is_ready_for_assisted_respawn()
	local var_5_9 = var_5_4:is_dead()
	local var_5_10 = var_5_9 and 0 or var_5_5:current_health_percent()
	local var_5_11 = var_5_4:is_dead() and 0 or var_5_5:current_permanent_health_percent()

	if var_5_8 then
		var_5_10 = 0
	end

	local var_5_12 = var_5_3.total_health_bar
	local var_5_13 = var_5_12.default_size[1]
	local var_5_14 = var_5_13 * var_5_10

	var_5_12.texture_size[1] = var_5_14
	var_5_12.offset[1] = -(var_5_13 - var_5_14) / 2
	var_5_12.color = var_5_7 and OutlineSettingsVS.colors.hero_dying.color or var_5_12.base_color

	local var_5_15 = var_5_3.streak_health_bar

	if not var_5_7 and not var_5_9 and not var_5_8 then
		if var_5_11 > var_5_2.stored_health_percent then
			var_5_15.color[1] = 0
			var_5_2.streak_damage_timestamp = nil
			var_5_2.stored_health_percent = var_5_11
			var_5_2.streak_damage_percent = 0
		elseif var_5_11 < 1 then
			local var_5_16 = var_5_2.stored_health_percent - var_5_11

			if var_5_16 > var_5_2.streak_damage_percent then
				var_5_2.streak_damage_percent = var_5_16
				var_5_2.streak_damage_timestamp = arg_5_5 + 2.2
			end
		else
			var_5_15.color[1] = 0
			var_5_2.streak_damage_timestamp = nil
			var_5_2.stored_health_percent = var_5_11
			var_5_2.streak_damage_percent = 0
		end
	else
		var_5_15.color[1] = 0
		var_5_2.streak_damage_timestamp = nil
		var_5_2.stored_health_percent = var_5_11
		var_5_2.streak_damage_percent = 0
	end

	if var_5_2.streak_damage_timestamp then
		local var_5_17 = 0.5
		local var_5_18 = math.clamp(var_5_2.streak_damage_timestamp + var_5_17 - arg_5_5, 0, 1)
		local var_5_19 = math.lerp(0, 1, var_5_18)
		local var_5_20 = var_5_15.default_size[1] * var_5_2.streak_damage_percent * math.easeCubic(var_5_19)

		var_5_15.color[1] = 255
		var_5_15.texture_size[1] = var_5_20
		var_5_15.offset[1] = -var_5_13 / 2 + var_5_14 + var_5_20 / 2

		if arg_5_5 > var_5_2.streak_damage_timestamp + var_5_17 then
			var_5_2.streak_damage_timestamp = nil
			var_5_15.color[1] = 0
			var_5_2.streak_damage_percent = 0
			var_5_2.stored_health_percent = var_5_11
		end
	end

	local var_5_21 = var_5_3.perm_health_bar
	local var_5_22 = var_5_21.default_size[1]
	local var_5_23 = var_5_22 * var_5_11

	var_5_21.texture_size[1] = var_5_23
	var_5_21.offset[1] = -(var_5_22 - var_5_23) / 2

	local var_5_24 = var_5_4:wounded_and_on_last_wound()
	local var_5_25 = var_0_2(var_5_24)

	var_5_21.color[1] = var_5_25
	var_5_12.color[1] = var_5_25

	local var_5_26 = Managers.player:owner(var_5_0)
	local var_5_27 = var_5_26 and var_5_26:name() or ""

	if UTF8Utils.string_length(var_5_27) > 18 then
		var_5_27 = string.sub(var_5_27, 1, 18) .. "..."
	end

	var_5_2.player_name = var_5_27
	arg_5_1.alpha_multiplier = 1 - var_5_2.distance / arg_5_3.max_distance

	return not var_5_9
end

function var_0_1.check_widget_visible(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0.style.frame.texture_size

	if arg_6_2 and arg_6_2 > var_6_0[1] * 0.5 then
		return false
	end

	if arg_6_1 and arg_6_1 > var_6_0[2] * 0.5 then
		return false
	end

	return true
end
