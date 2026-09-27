-- chunkname: @scripts/ui/hud_ui/world_marker_templates/world_marker_template_versus_hero_status.lua

local WorldMarkerTemplates = WorldMarkerTemplates

WorldMarkerTemplates = WorldMarkerTemplates or {}
WorldMarkerTemplates = WorldMarkerTemplates

local str = "versus_hero_status"
local var_0_2 = WorldMarkerTemplates[str]

var_0_2 = var_0_2 or {}
WorldMarkerTemplates[str] = var_0_2

local function fn(arg_1_0)
	-- function 1
	if not arg_1_0 then
		return 255
	end

	return 165 + 90 * math.sin(5 * Managers.time:time("ui"))
end

var_0_2.max_distance = 50
var_0_2.unit_node = "j_head"
var_0_2.screen_clamp = false
var_0_2.position_offset = {
	0,
	0,
	0.4
}
var_0_2.screen_margins = {
	down = 150,
	up = 150,
	left = 150,
	right = 150
}

var_0_2.create_widget_definition = function (arg_2_0)
	-- function 2
	local tbl = {
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
					content_check_function = function (self)
						-- function 3
						return self.streak_damage_percent > 0
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
				texture_size = tbl,
				default_size = tbl,
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
					tbl[1] - 4,
					tbl[2] - 3
				},
				default_size = {
					tbl[1] - 4,
					tbl[2] - 3
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
					tbl[1] - 4,
					tbl[2] - 3
				},
				default_size = {
					tbl[1] - 4,
					tbl[2] - 3
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
					tbl[1] - 4,
					tbl[2] - 3
				},
				default_size = {
					tbl[1] - 4,
					tbl[2] - 3
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
					tbl[1] - 4,
					tbl[2] - 3
				},
				default_size = {
					tbl[1] - 4,
					tbl[2] - 3
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

var_0_2.on_enter = function (arg_4_0)
	-- function 4
	arg_4_0.content.spawn_progress_timer = 0
end

var_0_2.update_function = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local unit = arg_5_2.unit

	if not Unit.alive(unit) then
		return false
	end

	local extensions = arg_5_2.extensions

	if not extensions then
		extensions = {
			career = ScriptUnit.extension(unit, "career_system"),
			health = ScriptUnit.extension(unit, "health_system"),
			status = ScriptUnit.extension(unit, "status_system"),
			inventory = ScriptUnit.extension(unit, "inventory_system"),
			buff = ScriptUnit.extension(unit, "buff_system")
		}
		arg_5_2.extensions = extensions
	end

	local content = arg_5_1.content
	local style = arg_5_1.style
	local status = extensions.status
	local health = extensions.health
	local inventory = extensions.inventory
	local is_knocked_down = status:is_knocked_down()
	local is_ready_for_assisted_respawn = status:is_ready_for_assisted_respawn()
	local is_dead = status:is_dead()
	local flag

	flag = not is_dead and 0 and health:current_health_percent()

	local flag_2

	flag_2 = not status:is_dead() and 0 and health:current_permanent_health_percent()

	if not is_ready_for_assisted_respawn then
		flag = 0
	end

	local total_health_bar = style.total_health_bar
	local var_5_13 = total_health_bar.default_size[1]
	local num = var_5_13 * flag

	total_health_bar.texture_size[1] = num
	total_health_bar.offset[1] = -(var_5_13 - num) / 2

	local color

	if not is_knocked_down then
		color = OutlineSettingsVS.colors.hero_dying.color

		if not color then
			-- Nothing
		end
	end

	color = total_health_bar.base_color

	::label_5_0::

	total_health_bar.color = color

	local streak_health_bar = style.streak_health_bar

	if not (not not is_knocked_down or not not is_dead or not is_ready_for_assisted_respawn) then
		if flag_2 > content.stored_health_percent then
			streak_health_bar.color[1] = 0
			content.streak_damage_timestamp = nil
			content.stored_health_percent = flag_2
			content.streak_damage_percent = 0
		elseif flag_2 < 1 then
			local num_2 = content.stored_health_percent - flag_2

			if num_2 > content.streak_damage_percent then
				content.streak_damage_percent = num_2
				content.streak_damage_timestamp = arg_5_5 + 2.2
			end
		else
			streak_health_bar.color[1] = 0
			content.streak_damage_timestamp = nil
			content.stored_health_percent = flag_2
			content.streak_damage_percent = 0
		end
	else
		streak_health_bar.color[1] = 0
		content.streak_damage_timestamp = nil
		content.stored_health_percent = flag_2
		content.streak_damage_percent = 0
	end

	if not content.streak_damage_timestamp then
		local num_3 = 0.5
		local clamp = math.clamp(content.streak_damage_timestamp + num_3 - arg_5_5, 0, 1)
		local lerp = math.lerp(0, 1, clamp)
		local num_4 = streak_health_bar.default_size[1] * content.streak_damage_percent * math.easeCubic(lerp)

		streak_health_bar.color[1] = 255
		streak_health_bar.texture_size[1] = num_4
		streak_health_bar.offset[1] = -var_5_13 / 2 + num + num_4 / 2

		if arg_5_5 > content.streak_damage_timestamp + num_3 then
			content.streak_damage_timestamp = nil
			streak_health_bar.color[1] = 0
			content.streak_damage_percent = 0
			content.stored_health_percent = flag_2
		end
	end

	local perm_health_bar = style.perm_health_bar
	local var_5_23 = perm_health_bar.default_size[1]
	local num_5 = var_5_23 * flag_2

	perm_health_bar.texture_size[1] = num_5
	perm_health_bar.offset[1] = -(var_5_23 - num_5) / 2

	local wounded_and_on_last_wound = status:wounded_and_on_last_wound()
	local var_5_26 = fn(wounded_and_on_last_wound)

	perm_health_bar.color[1] = var_5_26
	total_health_bar.color[1] = var_5_26

	local owner = Managers.player:owner(unit)
	local name

	if not owner then
		name = owner:name()

		if not name then
			-- Nothing
		end
	end

	name = ""

	::label_5_1::

	if Utf8.length(name) > 18 then
		name = string.sub(name, 1, 18) .. "..."
	end

	content.player_name = name
	arg_5_1.alpha_multiplier = 1 - content.distance / arg_5_3.max_distance

	return not is_dead
end

var_0_2.check_widget_visible = function (self, arg_6_1, arg_6_2)
	-- function 6
	local texture_size = self.style.frame.texture_size

	if not (not arg_6_2 and not (arg_6_2 > texture_size[1] * 0.5)) then
		return false
	end

	if not (not arg_6_1 and not (arg_6_1 > texture_size[2] * 0.5)) then
		return false
	end

	return true
end
