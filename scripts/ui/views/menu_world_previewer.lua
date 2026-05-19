-- chunkname: @scripts/ui/views/menu_world_previewer.lua

require("scripts/ui/views/world_hero_previewer")

local var_0_0 = math.degrees_to_radians(0)

MenuWorldPreviewer = class(MenuWorldPreviewer, HeroPreviewer)

local var_0_1 = {
	witch_hunter = {
		z = 0.4,
		x = 0,
		y = 0.8
	},
	bright_wizard = {
		z = 0.2,
		x = 0,
		y = 0.4
	},
	dwarf_ranger = {
		z = 0,
		x = 0,
		y = 0
	},
	wood_elf = {
		z = 0.16,
		x = 0,
		y = 0.45
	},
	empire_soldier = {
		z = 0.4,
		x = 0,
		y = 1
	},
	empire_soldier_tutorial = {
		z = 0.4,
		x = 0,
		y = 1
	},
	vs_rat_ogre = {
		z = 0.6,
		x = 1.2,
		y = 0.5
	},
	vs_chaos_troll = {
		z = 0.4,
		x = 0,
		y = 1
	},
	vs_gutter_runner = {
		z = 0,
		x = 0,
		y = 0
	},
	vs_packmaster = {
		z = 0,
		x = 0,
		y = 0
	},
	vs_ratling_gunner = {
		z = 0,
		x = 0,
		y = 0
	},
	vs_warpfire_thrower = {
		z = 0,
		x = 0,
		y = 0
	},
	vs_poison_wind_globadier = {
		z = 0,
		x = 0,
		y = 0
	},
	default = {
		z = 0.4,
		x = 0,
		y = 1
	}
}

function MenuWorldPreviewer.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	MenuWorldPreviewer.super.init(arg_1_0, arg_1_1, arg_1_3, arg_1_4)

	arg_1_0.input_manager = arg_1_1.input_manager
	arg_1_0.ui_renderer = arg_1_1.ui_renderer
	arg_1_0._character_camera_positions = arg_1_2 or var_0_1
	arg_1_0.player_manager = Managers.player
	arg_1_0.peer_id = arg_1_1.peer_id
	arg_1_0._camera_default_position = {
		z = 0.9,
		x = 0,
		y = 2.8
	}
	arg_1_0._default_animation_data = {
		x = {
			value = 0
		},
		y = {
			value = 0
		},
		z = {
			value = 0
		}
	}
	arg_1_0._camera_position_animation_data = table.clone(arg_1_0._default_animation_data)
	arg_1_0._camera_character_position_animation_data = table.clone(arg_1_0._default_animation_data)
	arg_1_0._camera_rotation_animation_data = table.clone(arg_1_0._default_animation_data)
	arg_1_0._camera_gamepad_offset_data = {
		0,
		0,
		0
	}
	arg_1_0._units = {}
	arg_1_0._requested_unit_spawn_queue = {}
end

function MenuWorldPreviewer.set_default_position(arg_2_0, arg_2_1)
	arg_2_0._camera_default_position = arg_2_1
end

function MenuWorldPreviewer.set_lookat_target(arg_3_0, arg_3_1)
	arg_3_0._lookat_target = arg_3_1
end

function MenuWorldPreviewer.destroy(arg_4_0)
	MenuWorldPreviewer.super.destroy(arg_4_0)
	Renderer.set_automatic_streaming(true)
	GarbageLeakDetector.register_object(arg_4_0, "MenuWorldPreviewer")
end

function MenuWorldPreviewer.on_enter(arg_5_0, arg_5_1, arg_5_2)
	MenuWorldPreviewer.super.on_enter(arg_5_0)
	arg_5_0:setup_viewport(arg_5_1, arg_5_2)
end

function MenuWorldPreviewer.setup_viewport(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0.viewport_widget = arg_6_1

	local var_6_0 = arg_6_1.element.pass_data[1]

	arg_6_0.world = var_6_0.world
	arg_6_0.level = var_6_0.level
	arg_6_0.viewport = var_6_0.viewport
	arg_6_0.camera = ScriptViewport.camera(arg_6_0.viewport)
	arg_6_0.character_camera_position_adjustments = {}
	arg_6_0.hero_name = arg_6_2
	arg_6_0.character_look_current = {
		0,
		3,
		1
	}
	arg_6_0.character_look_target = {
		0,
		3,
		1
	}
	arg_6_0.camera_xy_angle_current = var_0_0
	arg_6_0.camera_xy_angle_target = var_0_0
	arg_6_0._requested_unit_spawn_queue = {}
	arg_6_0._units = {}
end

local var_0_2 = {}

function MenuWorldPreviewer.activate(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	if not arg_7_0._delayed_spawn then
		return
	end

	if arg_7_0._activated == arg_7_1 then
		return
	end

	if arg_7_1 then
		arg_7_0:setup_viewport(arg_7_2, arg_7_3)

		arg_7_0._requested_hero_spawn_data = arg_7_0._delayed_hero_spawn_data or var_0_2
		arg_7_0._requested_unit_spawn_queue = arg_7_0._delayed_unit_spawn_queue or var_0_2
	else
		local var_7_0 = true

		arg_7_0:clear_units(var_7_0)

		arg_7_0.world = nil
	end

	arg_7_0._activated = arg_7_1
end

function MenuWorldPreviewer.trigger_level_event(arg_8_0, arg_8_1)
	Level.trigger_event(arg_8_0.level, arg_8_1)
end

function MenuWorldPreviewer.show_level_units(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0.level

	for iter_9_0, iter_9_1 in pairs(arg_9_1) do
		local var_9_1 = Level.unit_by_index(var_9_0, iter_9_1)

		if Unit.alive(var_9_1) then
			Unit.set_unit_visibility(var_9_1, arg_9_2)

			if arg_9_2 then
				Unit.flow_event(var_9_1, "unit_object_set_enabled")
			else
				Unit.flow_event(var_9_1, "unit_object_set_disabled")
			end
		end
	end
end

function MenuWorldPreviewer.has_units_spawned(arg_10_0)
	return arg_10_0.character_unit ~= nil
end

function MenuWorldPreviewer.on_exit(arg_11_0)
	MenuWorldPreviewer.super.on_exit(arg_11_0)
	Renderer.set_automatic_streaming(true)
end

function MenuWorldPreviewer.update(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	arg_12_0._requested_unit_spawn_queue = arg_12_0._delayed_unit_spawn_queue or var_0_2

	MenuWorldPreviewer.super.update(arg_12_0, arg_12_1, arg_12_2)

	if not arg_12_0._activated then
		return
	end

	local var_12_0 = arg_12_0.character_unit

	if var_12_0 then
		if arg_12_0.camera_xy_angle_target > math.pi * 2 then
			arg_12_0.camera_xy_angle_current = arg_12_0.camera_xy_angle_current - math.pi * 2
			arg_12_0.camera_xy_angle_target = arg_12_0.camera_xy_angle_target - math.pi * 2
		end

		local var_12_1 = math.lerp(arg_12_0.camera_xy_angle_current, arg_12_0.camera_xy_angle_target, 0.1)

		arg_12_0.camera_xy_angle_current = var_12_1

		local var_12_2 = Quaternion.axis_angle(Vector3(0, 0, 1), -var_12_1)

		Unit.set_local_rotation(var_12_0, 0, var_12_2)

		local var_12_3 = Vector3Aux.unbox(arg_12_0.character_look_current)
		local var_12_4 = Unit.animation_find_constraint_target(var_12_0, "aim_constraint_target")
		local var_12_5 = Quaternion.rotate(var_12_2, var_12_3)

		Unit.animation_set_constraint_target(var_12_0, var_12_4, var_12_5)
	end

	arg_12_0:_update_camera_animation_data(arg_12_0._camera_position_animation_data, arg_12_1)
	arg_12_0:_update_camera_animation_data(arg_12_0._camera_rotation_animation_data, arg_12_1)
	arg_12_0:_update_camera_animation_data(arg_12_0._camera_character_position_animation_data, arg_12_1)

	local var_12_6 = arg_12_0._camera_default_position
	local var_12_7 = Vector3.zero()

	var_12_7.x = var_12_6.x
	var_12_7.y = var_12_6.y
	var_12_7.z = var_12_6.z

	local var_12_8 = arg_12_0._lookat_target and arg_12_0._lookat_target:unbox() or Vector3(0, 0, 0.9)
	local var_12_9 = Vector3.normalize(var_12_8 - var_12_7)
	local var_12_10 = arg_12_0._camera_rotation_animation_data

	var_12_9.x = var_12_9.x + var_12_10.x.value
	var_12_9.y = var_12_9.y + var_12_10.y.value
	var_12_9.z = var_12_9.z + var_12_10.z.value

	local var_12_11 = Quaternion.look(var_12_9)

	ScriptCamera.set_local_rotation(arg_12_0.camera, var_12_11)

	local var_12_12 = arg_12_0._camera_position_animation_data
	local var_12_13 = arg_12_0._camera_character_position_animation_data
	local var_12_14 = arg_12_0._camera_gamepad_offset_data

	var_12_7.x = var_12_7.x + var_12_12.x.value + var_12_13.x.value + var_12_14[1]
	var_12_7.y = var_12_7.y + var_12_12.y.value + var_12_13.y.value + var_12_14[2]
	var_12_7.z = var_12_7.z + var_12_12.z.value + var_12_13.z.value + var_12_14[3]

	ScriptCamera.set_local_position(arg_12_0.camera, var_12_7)

	local var_12_15 = arg_12_0.input_manager:get_service("hero_view")

	if not arg_12_3 and arg_12_0.character_unit_visible then
		arg_12_0:handle_mouse_input(var_12_15, arg_12_1)
		arg_12_0:handle_controller_input(var_12_15, arg_12_1)
	end
end

function MenuWorldPreviewer.post_update(arg_13_0, arg_13_1, arg_13_2)
	arg_13_0:_handle_unit_spawn_request()
	MenuWorldPreviewer.super.post_update(arg_13_0, arg_13_1, arg_13_2)
end

function MenuWorldPreviewer.force_stream_highest_mip_levels(arg_14_0)
	arg_14_0._use_highest_mip_levels = true
end

function MenuWorldPreviewer.force_hide_character(arg_15_0)
	arg_15_0._force_hide_character = true
end

function MenuWorldPreviewer.force_unhide_character(arg_16_0)
	arg_16_0._force_hide_character = false
end

function MenuWorldPreviewer._update_units_visibility(arg_17_0, arg_17_1)
	if arg_17_0._force_hide_character then
		return
	end

	MenuWorldPreviewer.super._update_units_visibility(arg_17_0, arg_17_1)
end

function MenuWorldPreviewer._set_character_visibility(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	MenuWorldPreviewer.super._set_character_visibility(arg_18_0, arg_18_1)

	if arg_18_3 then
		return
	end

	local var_18_0 = arg_18_2 or arg_18_0._camera_move_duration

	if var_18_0 then
		local var_18_1 = 0
		local var_18_2 = 0
		local var_18_3 = 0

		if arg_18_1 then
			local var_18_4 = arg_18_0._current_profile_name

			if var_18_4 then
				local var_18_5 = arg_18_0._character_camera_positions
				local var_18_6 = var_18_5[var_18_4] or var_18_5.default

				var_18_1 = var_18_6.x
				var_18_2 = var_18_6.y
				var_18_3 = var_18_6.z
			end
		end

		arg_18_0:set_character_axis_offset("x", var_18_1, var_18_0, math.easeOutCubic)
		arg_18_0:set_character_axis_offset("y", var_18_2, var_18_0, math.easeOutCubic)
		arg_18_0:set_character_axis_offset("z", var_18_3, var_18_0, math.easeOutCubic)
	end
end

function MenuWorldPreviewer._update_camera_animation_data(arg_19_0, arg_19_1, arg_19_2)
	for iter_19_0, iter_19_1 in pairs(arg_19_1) do
		if iter_19_1.total_time then
			local var_19_0 = iter_19_1.time

			iter_19_1.time = math.min(var_19_0 + arg_19_2, iter_19_1.total_time)

			local var_19_1 = math.min(1, iter_19_1.time / iter_19_1.total_time)
			local var_19_2 = iter_19_1.func

			iter_19_1.value = (iter_19_1.to - iter_19_1.from) * (var_19_2 and var_19_2(var_19_1) or var_19_1) + iter_19_1.from

			if var_19_1 == 1 then
				iter_19_1.total_time = nil
			end
		end
	end
end

function MenuWorldPreviewer.set_camera_axis_offset(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	local var_20_0 = arg_20_0._camera_position_animation_data[arg_20_1]
	local var_20_1 = arg_20_0._camera_default_position

	var_20_0.from = arg_20_3 and var_20_0.value or arg_20_2
	var_20_0.to = arg_20_5 and arg_20_2 + -var_20_1[arg_20_1] or arg_20_2
	var_20_0.total_time = arg_20_3
	var_20_0.time = 0
	var_20_0.func = arg_20_4
	var_20_0.value = var_20_0.from
end

function MenuWorldPreviewer.set_camera_gamepad_offset(arg_21_0, arg_21_1)
	arg_21_0._camera_gamepad_offset_data = arg_21_1
end

function MenuWorldPreviewer.set_camera_rotation_axis_offset(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	local var_22_0 = arg_22_0._camera_rotation_animation_data[arg_22_1]

	var_22_0.from = arg_22_3 and var_22_0.value or arg_22_2
	var_22_0.to = arg_22_2
	var_22_0.total_time = arg_22_3
	var_22_0.time = 0
	var_22_0.func = arg_22_4
	var_22_0.value = var_22_0.from
end

function MenuWorldPreviewer.set_character_axis_offset(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	local var_23_0 = arg_23_0._camera_character_position_animation_data[arg_23_1]

	var_23_0.from = arg_23_3 and var_23_0.value or arg_23_2
	var_23_0.to = arg_23_2
	var_23_0.total_time = arg_23_3
	var_23_0.time = 0
	var_23_0.func = arg_23_4
	var_23_0.value = var_23_0.from
end

local var_0_3 = {}

function MenuWorldPreviewer.handle_mouse_input(arg_24_0, arg_24_1, arg_24_2)
	if arg_24_0.character_unit == nil then
		return
	end

	if not arg_24_0.input_manager:is_device_active("mouse") then
		return
	end

	local var_24_0 = arg_24_1:get("cursor")

	if not var_24_0 then
		return
	end

	local var_24_1 = arg_24_0.viewport_widget.content.button_hotspot

	if var_24_1 and var_24_1.is_hover then
		if arg_24_1:get("left_press") then
			arg_24_0.is_moving_camera = true
			arg_24_0.last_mouse_position = nil
		elseif arg_24_1:get("right_press") then
			arg_24_0.camera_xy_angle_target = var_0_0
		end
	end

	local var_24_2 = arg_24_0.is_moving_camera
	local var_24_3 = arg_24_1:get("left_hold")

	if var_24_2 and var_24_3 then
		if arg_24_0.last_mouse_position then
			arg_24_0.camera_xy_angle_target = arg_24_0.camera_xy_angle_target - (var_24_0.x - arg_24_0.last_mouse_position[1]) * 0.01
		end

		var_0_3[1] = var_24_0.x
		var_0_3[2] = var_24_0.y
		arg_24_0.last_mouse_position = var_0_3
	elseif var_24_2 then
		arg_24_0.is_moving_camera = false
	end
end

function MenuWorldPreviewer.handle_controller_input(arg_25_0, arg_25_1, arg_25_2)
	if arg_25_0.character_unit == nil then
		return
	end

	if not arg_25_0.input_manager:is_device_active("gamepad") then
		return
	end

	local var_25_0 = arg_25_1:get("gamepad_right_axis")

	if var_25_0 and Vector3.length(var_25_0) > 0.01 then
		arg_25_0.camera_xy_angle_target = arg_25_0.camera_xy_angle_target + -var_25_0.x * arg_25_2 * 5
	end
end

function MenuWorldPreviewer.start_character_rotation(arg_26_0, arg_26_1)
	if arg_26_1 then
		arg_26_0.rotation_direction = arg_26_1
	end
end

function MenuWorldPreviewer.end_character_rotation(arg_27_0)
	print("end_character_rotation", arg_27_0.rotation_direction)
end

function MenuWorldPreviewer.request_spawn_hero_unit(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6, arg_28_7, arg_28_8)
	arg_28_0:clear_asynchronous_data()

	arg_28_0._requested_hero_spawn_data = {
		frame_delay = 1,
		profile_name = arg_28_1,
		career_index = arg_28_2,
		state_character = arg_28_3,
		callback = arg_28_4,
		optional_scale = arg_28_5,
		camera_move_duration = arg_28_6,
		optional_skin = arg_28_7
	}

	if arg_28_0._delayed_spawn then
		arg_28_0._delayed_hero_spawn_data = table.clone(arg_28_0._requested_hero_spawn_data)
	end

	arg_28_0:clear_units(arg_28_8)

	arg_28_0._draw_character = true
end

function MenuWorldPreviewer.request_spawn_unit(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	local var_29_0 = arg_29_0._requested_unit_spawn_queue

	var_29_0[#var_29_0 + 1] = {
		frame_delay = 1,
		unit_name = arg_29_1,
		unit_type = arg_29_2,
		callback = arg_29_3
	}

	if arg_29_0._delayed_spawn then
		arg_29_0._delayed_unit_spawn_queue = table.clone(var_29_0)
	end
end

function MenuWorldPreviewer._handle_hero_spawn_request(arg_30_0)
	if arg_30_0._requested_hero_spawn_data then
		local var_30_0 = arg_30_0._requested_hero_spawn_data
		local var_30_1 = var_30_0.frame_delay

		if var_30_1 == 0 then
			local var_30_2 = var_30_0.profile_name
			local var_30_3 = var_30_0.career_index
			local var_30_4 = var_30_0.state_character
			local var_30_5 = var_30_0.callback
			local var_30_6 = var_30_0.optional_scale
			local var_30_7 = var_30_0.camera_move_duration
			local var_30_8 = var_30_0.optional_skin

			arg_30_0:_load_hero_unit(var_30_2, var_30_3, var_30_4, var_30_5, var_30_6, var_30_7, var_30_8)

			arg_30_0._requested_hero_spawn_data = nil
		else
			var_30_0.frame_delay = var_30_1 - 1
		end
	end
end

function MenuWorldPreviewer._handle_unit_spawn_request(arg_31_0)
	if #arg_31_0._requested_unit_spawn_queue < 1 then
		return
	end

	local var_31_0 = arg_31_0._requested_unit_spawn_queue[1]
	local var_31_1 = var_31_0.frame_delay

	if var_31_1 == 0 then
		arg_31_0:_spawn_unit(var_31_0.unit_name, var_31_0)
		table.remove(arg_31_0._requested_unit_spawn_queue, 1)
	else
		var_31_0.frame_delay = var_31_1 - 1
	end
end

function MenuWorldPreviewer._load_hero_unit(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6, arg_32_7)
	arg_32_0.camera_xy_angle_target = var_0_0

	if not arg_32_0._delayed_spawn then
		arg_32_0:_unload_all_packages()
	end

	arg_32_6 = arg_32_6 or 0.01

	local var_32_0 = arg_32_0._character_camera_positions
	local var_32_1 = var_32_0[arg_32_1] or var_32_0.default

	arg_32_0:set_character_axis_offset("x", var_32_1.x, arg_32_6, math.easeOutCubic)
	arg_32_0:set_character_axis_offset("y", var_32_1.y, arg_32_6, math.easeOutCubic)
	arg_32_0:set_character_axis_offset("z", var_32_1.z, arg_32_6, math.easeOutCubic)

	arg_32_0._camera_move_duration = arg_32_6
	arg_32_0._current_profile_name = arg_32_1

	local var_32_2 = FindProfileIndex(arg_32_1)
	local var_32_3 = SPProfiles[var_32_2].careers[arg_32_2]
	local var_32_4 = var_32_3.name
	local var_32_5 = BackendUtils.get_loadout_item(var_32_4, "slot_skin")
	local var_32_6 = var_32_5 and var_32_5.data
	local var_32_7 = arg_32_7 or var_32_6 and var_32_6.name or var_32_3.base_skin

	GlobalShaderFlags.set_global_shader_flag("NECROMANCER_CAREER_REMAP", var_32_4 == "bw_necromancer")

	if arg_32_3 then
		var_32_7 = var_32_3.base_skin
	end

	arg_32_0._current_career_name = var_32_4
	arg_32_0.character_unit_skin_data = nil

	local var_32_8 = CosmeticsUtils.retrieve_skin_packages_for_preview(var_32_7)
	local var_32_9 = Cosmetics[var_32_7]

	arg_32_0._hero_loading_package_data = {
		num_loaded_packages = 0,
		career_name = var_32_4,
		skin_data = var_32_9,
		career_index = arg_32_2,
		optional_scale = arg_32_5,
		package_names = var_32_8,
		num_packages = #var_32_8,
		callback = arg_32_4
	}, arg_32_0:_load_packages(var_32_8)
end

function MenuWorldPreviewer._spawn_hero_unit(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	MenuWorldPreviewer.super._spawn_hero_unit(arg_33_0, arg_33_1, arg_33_2, arg_33_3)

	if arg_33_0._use_highest_mip_levels or UISettings.wait_for_mip_streaming_character then
		arg_33_0:_request_mip_streaming_for_unit(arg_33_0.character_unit)
	end
end

function MenuWorldPreviewer.respawn_hero_unit(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5)
	local var_34_0 = true

	arg_34_0:request_spawn_hero_unit(arg_34_1, arg_34_2, arg_34_3, arg_34_4, nil, arg_34_5, nil, var_34_0)
end

function MenuWorldPreviewer._spawn_item(arg_35_0, arg_35_1, arg_35_2)
	if MenuWorldPreviewer.super._spawn_item(arg_35_0, arg_35_1, arg_35_2) and (arg_35_0._use_highest_mip_levels or UISettings.wait_for_mip_streaming_character) then
		arg_35_0:_request_mip_streaming_for_unit(arg_35_0.character_unit)
	end
end

function MenuWorldPreviewer._spawn_item_unit(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6, arg_36_7)
	MenuWorldPreviewer.super._spawn_item_unit(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6, arg_36_7)

	if arg_36_0._use_highest_mip_levels or UISettings.wait_for_mip_streaming_items then
		arg_36_0:_request_mip_streaming_for_unit(arg_36_1)
	end
end

function MenuWorldPreviewer._spawn_unit(arg_37_0, arg_37_1, arg_37_2)
	local var_37_0 = World.spawn_unit(arg_37_0.world, arg_37_1)

	arg_37_0._units[#arg_37_0._units + 1] = var_37_0
	arg_37_0._hidden_units[var_37_0] = true

	Unit.set_unit_visibility(var_37_0, false)

	local var_37_1 = arg_37_2.callback

	if var_37_1 then
		var_37_1(var_37_0)
	end
end

function MenuWorldPreviewer.set_unit_location(arg_38_0, arg_38_1, arg_38_2)
	if arg_38_2 and arg_38_1 and Unit.alive(arg_38_1) then
		Unit.set_local_position(arg_38_1, 0, Vector3Aux.unbox(arg_38_2))
	end
end

function MenuWorldPreviewer._destroy_item_units_by_slot(arg_39_0, arg_39_1)
	local var_39_0 = arg_39_0.world
	local var_39_1 = arg_39_0._hidden_units
	local var_39_2 = arg_39_0._requested_mip_streaming_units
	local var_39_3 = arg_39_0._item_info_by_slot[arg_39_1].spawn_data

	if var_39_3 then
		for iter_39_0, iter_39_1 in ipairs(var_39_3) do
			local var_39_4 = iter_39_1.item_slot_type
			local var_39_5 = iter_39_1.slot_index

			if var_39_4 == "melee" or var_39_4 == "ranged" then
				if iter_39_1.right_hand or iter_39_1.despawn_both_hands_units then
					local var_39_6 = arg_39_0._equipment_units[var_39_5].right

					if var_39_6 ~= nil then
						var_39_1[var_39_6] = nil
						var_39_2[var_39_6] = nil

						World.destroy_unit(var_39_0, var_39_6)

						arg_39_0._equipment_units[var_39_5].right = nil
					end
				end

				if iter_39_1.left_hand or iter_39_1.despawn_both_hands_units then
					local var_39_7 = arg_39_0._equipment_units[var_39_5].left

					if var_39_7 ~= nil then
						var_39_1[var_39_7] = nil
						var_39_2[var_39_7] = nil

						World.destroy_unit(var_39_0, var_39_7)

						arg_39_0._equipment_units[var_39_5].left = nil
					end
				end
			else
				local var_39_8 = arg_39_0._equipment_units[var_39_5]

				if var_39_8 ~= nil then
					var_39_1[var_39_8] = nil
					var_39_2[var_39_8] = nil

					World.destroy_unit(var_39_0, var_39_8)

					arg_39_0._equipment_units[var_39_5] = nil
				end
			end
		end
	end
end

function MenuWorldPreviewer._reference_name(arg_40_0)
	local var_40_0 = "MenuWorldPreviewer"

	if arg_40_0.unique_id then
		var_40_0 = var_40_0 .. tostring(arg_40_0.unique_id)
	end

	return var_40_0
end

function MenuWorldPreviewer.clear_units(arg_41_0, arg_41_1)
	MenuWorldPreviewer.super.clear_units(arg_41_0)

	if arg_41_1 then
		local var_41_0 = arg_41_0._default_animation_data

		arg_41_0:set_character_axis_offset("x", var_41_0.x.value, 0.5, math.easeOutCubic)
		arg_41_0:set_character_axis_offset("y", var_41_0.y.value, 0.5, math.easeOutCubic)
		arg_41_0:set_character_axis_offset("z", var_41_0.z.value, 0.5, math.easeOutCubic)
	end

	local var_41_1 = arg_41_0._units

	if var_41_1 then
		for iter_41_0 = 1, #var_41_1 do
			World.destroy_unit(arg_41_0.world, var_41_1[iter_41_0])
		end
	end

	arg_41_0._units = {}
end

function MenuWorldPreviewer.hide_character(arg_42_0)
	arg_42_0._draw_character = false
end

function MenuWorldPreviewer.trigger_unit_flow_event(arg_43_0, arg_43_1, arg_43_2)
	if arg_43_1 and Unit.alive(arg_43_1) then
		Unit.flow_event(arg_43_1, arg_43_2)
	end
end

function MenuWorldPreviewer.trigger_level_flow_event(arg_44_0, arg_44_1)
	return Level.trigger_event(arg_44_0.level, arg_44_1)
end
