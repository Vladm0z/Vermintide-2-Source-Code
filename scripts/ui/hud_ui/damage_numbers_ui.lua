-- chunkname: @scripts/ui/hud_ui/damage_numbers_ui.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = {
	screen = {
		scale = "fit",
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
	text_root = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			3
		},
		size = {
			0,
			0
		}
	},
	damage_text = {
		vertical_alignment = "center",
		parent = "text_root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			300,
			150
		}
	}
}
local var_0_3 = GameModeSettings.versus and GameModeSettings.versus.min_streak_font_size or 36
local var_0_4 = GameModeSettings.versus and GameModeSettings.versus.max_streak_font_size or 64
local var_0_5 = {
	word_wrap = false,
	font_size = 24,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		1
	}
}
local var_0_6 = {
	damage_text = UIWidgets.create_simple_text("0", "damage_text", nil, nil, var_0_5)
}

DamageNumbersUI = class(DamageNumbersUI)

DamageNumbersUI.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0.ui_renderer = arg_1_2.ui_renderer
	arg_1_0.camera = Managers.camera
	arg_1_0.input_manager = arg_1_2.input_manager
	arg_1_0._time = 0
	arg_1_0._unit_text_size = 0.2
	arg_1_0._unit_text_time = math.huge
	arg_1_0._unit_texts = {}
	arg_1_0._unit_texts_summed = {}

	local var_1_0 = Managers.world
	local var_1_1 = "player_1"
	local var_1_2 = "level_world"
	local var_1_3 = var_1_0:world(var_1_2)
	local var_1_4 = ScriptWorld.viewport(var_1_3, var_1_1)

	arg_1_0.camera = ScriptViewport.camera(var_1_4)

	arg_1_0:create_ui_elements()
	Managers.state.event:register(arg_1_0, "add_damage_number", "event_add_damage_number")
	Managers.state.event:register(arg_1_0, "alter_damage_number", "event_alter_damage_number")

	local var_1_5 = Managers.state.game_mode:settings()
end

DamageNumbersUI.update = function (arg_2_0, arg_2_1)
	arg_2_0._time = arg_2_0._time + arg_2_1

	arg_2_0:draw(arg_2_1)
end

DamageNumbersUI.event_alter_damage_number = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	if arg_3_2 then
		arg_3_2.text = arg_3_3.text
		arg_3_2.time = arg_3_0._time + (arg_3_3.time or arg_3_0._unit_text_time)
		arg_3_2.starting_time = arg_3_0._time
		arg_3_2.color = arg_3_3.color or arg_3_2.color
		arg_3_2.color_saved = arg_3_3.color
		arg_3_2.size = arg_3_3.size or arg_3_2.size
		arg_3_2.damage = arg_3_3.damage or arg_3_2.damage
	end
end

local var_0_7 = {}
local var_0_8 = {
	default = function (arg_4_0, arg_4_1, arg_4_2)
		arg_4_0.random_x_offset = math.random(-60, 60)
		arg_4_0.random_y_offset = math.random(-60, 60)
	end,
	floating_damage = function (arg_5_0, arg_5_1)
		local var_5_0 = 50
		local var_5_1 = 125
		local var_5_2 = math.random() - 0.5

		arg_5_0.random_x_offset = var_5_2 * var_5_0
		arg_5_0.random_y_offset = math.sin(2 * var_5_2 + math.pi * 0.5) * var_5_1
	end,
	critical_strike = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		arg_6_0.unit = arg_6_3
	end,
	streak_damage = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
		arg_7_0.unit = arg_7_3
	end,
	floating_radial_damage = function (arg_8_0, arg_8_1, arg_8_2)
		local var_8_0 = arg_8_0.angle or (arg_8_2 - 1) * 0.5
		local var_8_1 = 150
		local var_8_2 = math.random(200, 700)
		local var_8_3 = math.cos(var_8_0)

		arg_8_0.random_x_offset = var_8_3 * var_8_1
		arg_8_0.floating_speed_x = var_8_3 * var_8_2

		local var_8_4 = math.sin(var_8_0)

		arg_8_0.random_y_offset = var_8_4 * var_8_1
		arg_8_0.floating_speed_y = var_8_4 * var_8_2
	end
}

local function var_0_9(arg_9_0, arg_9_1)
	return true
end

DamageNumbersUI.event_add_damage_number = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7, arg_10_8)
	arg_10_8 = arg_10_8 or var_0_7

	local var_10_0 = Camera.world_position(arg_10_0.camera)
	local var_10_1 = Unit.world_position(arg_10_3, 0)
	local var_10_2 = Vector3.normalize(var_10_1 - var_10_0)
	local var_10_3 = Quaternion.forward(Camera.world_rotation(arg_10_0.camera))
	local var_10_4 = Vector3.dot(var_10_3, var_10_2)

	if var_10_4 >= 0 and var_10_4 <= 1 then
		arg_10_2 = arg_10_2 or 1
		arg_10_5 = arg_10_5 or Vector3(255, 255, 255)

		local var_10_5 = DamageNumberVariants

		if not arg_10_0._unit_texts[arg_10_3] then
			arg_10_0._unit_texts[arg_10_3] = {}
		end

		local var_10_6 = #arg_10_0._unit_texts[arg_10_3] + 1
		local var_10_7 = arg_10_8.variant_name or "default"
		local var_10_8 = DamageNumberVariants[var_10_7]
		local var_10_9
		local var_10_10 = {
			random_y_offset = 0,
			alpha = 255,
			floating_speed_x = 0,
			random_x_offset = 0,
			floating_speed_y = 150,
			size = arg_10_2,
			text = arg_10_1,
			color = {
				255,
				arg_10_5.x,
				arg_10_5.y,
				arg_10_5.z
			},
			time = arg_10_0._time + (arg_10_4 or arg_10_0._unit_text_time),
			floating_speed = arg_10_8.floating_speed or 150,
			starting_time = arg_10_0._time,
			z_offset = arg_10_7,
			update_function = var_10_8.update,
			complete_function = var_10_8.complete or var_0_9,
			start_function = var_10_8.start,
			damage = arg_10_8.damage,
			using_bucket_damage = arg_10_8.using_bucket_damage
		}

		var_0_8[var_10_7](var_10_10, arg_10_8, var_10_6, arg_10_3)

		if arg_10_6 then
			arg_10_8.update_function = DamageNumberVariants.critical_strike.update
		end

		var_10_10.color_saved = var_10_10.color
		arg_10_0._unit_texts[arg_10_3][var_10_6] = var_10_10

		if arg_10_8.ref then
			arg_10_8.ref = var_10_10
		end
	end
end

DamageNumbersUI.destroy = function (arg_11_0)
	for iter_11_0, iter_11_1 in pairs(arg_11_0._unit_texts) do
		arg_11_0:_destroy_unit_texts(iter_11_0)
	end

	if Managers.state.event then
		Managers.state.event:unregister("add_damage_number", arg_11_0)
		Managers.state.event:unregister(arg_11_0, "alter_damage_number")
	end
end

DamageNumbersUI._destroy_unit_texts = function (arg_12_0, arg_12_1)
	arg_12_0._unit_texts[arg_12_1] = nil
end

DamageNumbersUI.create_ui_elements = function (arg_13_0)
	arg_13_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)
	arg_13_0.damage_text = UIWidget.init(var_0_6.damage_text)

	UIRenderer.clear_scenegraph_queue(arg_13_0.ui_renderer)
end

DamageNumberVariants = {
	default = {
		update = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
			local var_14_0 = arg_14_0.size

			arg_14_2.style.text.font_size = var_14_0
			arg_14_2.style.text_shadow.font_size = var_14_0
		end
	},
	floating_damage = {
		update = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6)
			local var_15_0 = arg_15_0.size

			arg_15_2.style.text.font_size = var_15_0
			arg_15_2.style.text_shadow.font_size = var_15_0

			local var_15_1 = arg_15_4.x * arg_15_3
			local var_15_2 = arg_15_4.z * arg_15_3
			local var_15_3 = arg_15_2.offset

			var_15_3[1] = var_15_1 + arg_15_0.random_x_offset
			var_15_3[2] = var_15_2 + arg_15_0.random_y_offset + arg_15_6 * arg_15_0.floating_speed
		end
	},
	critical_strike = {
		update = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6)
			local var_16_0 = arg_16_0.size
			local var_16_1 = math.easeOutCubic(math.min(arg_16_5 * 7, 1))
			local var_16_2 = var_16_0 + math.ease_pulse(var_16_1) * 60

			arg_16_2.style.text.font_size = var_16_2
			arg_16_2.style.text_shadow.font_size = var_16_2
		end
	},
	streak_damage = {
		update = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6)
			local var_17_0 = arg_17_0.size
			local var_17_1 = arg_17_4.x * arg_17_3
			local var_17_2 = arg_17_4.z * arg_17_3

			arg_17_2.offset[1] = var_17_1
			arg_17_2.offset[2] = var_17_2 + 60

			local var_17_3 = 255

			arg_17_2.style.text.text_color[1] = var_17_3
			arg_17_2.style.text_shadow.text_color[1] = var_17_3
		end,
		complete = function (arg_18_0, arg_18_1, arg_18_2)
			arg_18_0.update_function = DamageNumberVariants.streak_damage.pop_update
			arg_18_0.complete_function = DamageNumberVariants.streak_damage.pop_complete
			arg_18_0.time = arg_18_1 + 0.4
			arg_18_0.starting_time = arg_18_1

			if arg_18_0.using_bucket_damage then
				local var_18_0 = arg_18_0.damage
				local var_18_1 = math.floor(var_18_0)
				local var_18_2 = var_18_0 % 1 * 100

				arg_18_0.dmg_int = var_18_1
				arg_18_0.dmg_dec = var_18_2

				local var_18_3 = math.auto_lerp(0, 75, var_0_3, var_0_4, var_18_0)

				arg_18_0.size = var_18_3

				if var_18_2 > 0 then
					arg_18_0.text = string.format("{#size(%s)}%s{#size(%s)}.%s", var_18_3, var_18_1, math.floor(var_18_3 / 2), var_18_2)
				end
			end

			return false
		end,
		pop_update = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
			local var_19_0 = arg_19_0.size

			arg_19_2.style.text.font_size = var_19_0

			local var_19_1 = var_19_0 + (35 * math.sin(arg_19_5 * math.pi - math.pi * 2) + 0)
			local var_19_2 = arg_19_0.dmg_int
			local var_19_3 = arg_19_0.dmg_dec

			if var_19_3 > 0 then
				arg_19_0.text = string.format("{#size(%s)}%s{#size(%s)}.%s", var_19_1, var_19_2, math.floor(var_19_1 / 2), var_19_3)
			else
				arg_19_0.text = string.format("{#size(%s)}%s", var_19_1, var_19_2)
			end

			local var_19_4 = 255

			arg_19_2.style.text.text_color[1] = var_19_4
			arg_19_2.style.text_shadow.text_color[1] = var_19_4

			local var_19_5 = arg_19_4.x * arg_19_3
			local var_19_6 = arg_19_4.z * arg_19_3

			arg_19_2.offset[1] = var_19_5
			arg_19_2.offset[2] = var_19_6 + 60
		end,
		pop_complete = function (arg_20_0, arg_20_1, arg_20_2)
			arg_20_0.update_function = DamageNumberVariants.streak_damage_fadeout.update
			arg_20_0.complete_function = var_0_9
			arg_20_0.time = arg_20_1 + 2
			arg_20_0.starting_time = arg_20_1
			arg_20_0.floating_speed = 150

			if arg_20_0.using_bucket_damage then
				local var_20_0 = arg_20_0.damage
				local var_20_1 = math.floor(var_20_0)
				local var_20_2 = var_20_0 % 1 * 100

				if var_20_2 > 0 then
					local var_20_3 = math.auto_lerp(0, 75, var_0_3, var_0_4, var_20_0)

					arg_20_0.text = string.format("{#size(%s)}%s{#size(%s)}.%s", var_20_3, var_20_1, var_20_3 / 2, var_20_2)
				end
			end

			return false
		end
	},
	streak_damage_fadeout = {
		update = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6)
			arg_21_2.style.text.text_color = arg_21_0.color

			local var_21_0 = arg_21_0.size

			arg_21_2.style.text.font_size = var_21_0
			arg_21_2.style.text_shadow.font_size = var_21_0

			local var_21_1 = arg_21_4.x * arg_21_3
			local var_21_2 = arg_21_4.z * arg_21_3

			arg_21_2.offset[1] = var_21_1
			arg_21_2.offset[2] = var_21_2 + 60 + arg_21_6 * arg_21_0.floating_speed
		end
	},
	floating_radial_damage = {
		update = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6)
			local var_22_0 = arg_22_0.size

			arg_22_2.style.text.font_size = var_22_0
			arg_22_2.style.text_shadow.font_size = var_22_0

			local var_22_1 = arg_22_4.x * arg_22_3
			local var_22_2 = arg_22_4.z * arg_22_3

			arg_22_2.offset[1] = var_22_1 + arg_22_6 * arg_22_0.floating_speed_x
			arg_22_2.offset[2] = var_22_2 + arg_22_6 * arg_22_0.floating_speed_y

			if arg_22_5 > 0.5 then
				local var_22_3 = arg_22_2.style.text.text_color[1] * 0.99

				arg_22_2.style.text.text_color[1] = var_22_3
				arg_22_2.style.text_shadow.text_color[1] = var_22_3
			end
		end
	}
}

DamageNumbersUI.draw = function (arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0.ui_renderer
	local var_23_1 = arg_23_0.ui_scenegraph
	local var_23_2 = arg_23_0.input_manager:get_service("ingame_menu")

	UIRenderer.begin_pass(var_23_0, var_23_1, var_23_2, arg_23_1)

	local var_23_3 = arg_23_0.damage_text
	local var_23_4 = var_23_3.content
	local var_23_5 = var_23_3.offset
	local var_23_6 = Camera.world_to_screen
	local var_23_7 = RESOLUTION_LOOKUP.inv_scale
	local var_23_8 = Unit.world_position
	local var_23_9 = math.easeOutCubic
	local var_23_10 = arg_23_0.camera

	for iter_23_0, iter_23_1 in pairs(arg_23_0._unit_texts) do
		if Unit.alive(iter_23_0) then
			local var_23_11 = var_23_8(iter_23_0, 0)
			local var_23_12 = iter_23_1[1] and iter_23_1[1].z_offset or 1.85

			var_23_11[3] = var_23_11[3] + var_23_12

			local var_23_13 = var_23_6(var_23_10, var_23_11)

			for iter_23_2 = #iter_23_1, 1, -1 do
				local var_23_14 = iter_23_1[iter_23_2]

				if arg_23_0._time > var_23_14.time and var_23_14.complete_function(var_23_14, arg_23_0._time, var_23_3) then
					table.swap_delete(iter_23_1, iter_23_2)
				else
					local var_23_15 = var_23_14.text
					local var_23_16 = var_23_14.floating_lerp
					local var_23_17 = 1 - (var_23_14.time - arg_23_0._time) / (var_23_14.time - var_23_14.starting_time)
					local var_23_18 = var_23_9(var_23_17)
					local var_23_19 = var_23_13.x * var_23_7
					local var_23_20 = var_23_13.z * var_23_7

					var_23_5[1] = var_23_19 + var_23_14.random_x_offset
					var_23_5[2] = var_23_20 + var_23_14.random_y_offset + var_23_18 * var_23_14.floating_speed

					local var_23_21 = (1 - var_23_18) * 255

					var_23_4.text = var_23_15
					var_23_3.style.text.text_color = var_23_14.color
					var_23_3.style.text.text_color[1] = var_23_21
					var_23_3.style.text_shadow.text_color[1] = var_23_21

					var_23_14.update_function(var_23_14, arg_23_0._time, var_23_3, var_23_7, var_23_13, var_23_17, var_23_18)
					UIRenderer.draw_widget(var_23_0, var_23_3)
				end
			end
		else
			arg_23_0:_destroy_unit_texts(iter_23_0)
		end
	end

	UIRenderer.end_pass(var_23_0)
end
