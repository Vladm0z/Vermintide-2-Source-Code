-- chunkname: @scripts/unit_extensions/default_player_unit/player_unit_first_person.lua

local var_0_0 = script_data.testify and require("scripts/unit_extensions/default_player_unit/player_unit_first_person_testify")

PlayerUnitFirstPerson = class(PlayerUnitFirstPerson)
script_data.disable_aim_lead_rig_motion = script_data.disable_aim_lead_rig_motion or Development.parameter("disable_aim_lead_rig_motion") or true

local var_0_1 = Unit.alive
local var_0_2 = Unit.animation_find_variable
local var_0_3 = Unit.animation_set_variable
local var_0_4 = 0.001
local var_0_5 = {
	recentering_lerp_speed = 2,
	camera_look_sensitivity = 1,
	sway_range = 1,
	look_sensitivity = 0.6,
	lerp_speed = math.huge
}

PlayerUnitFirstPerson.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.world = arg_1_1.world
	arg_1_0.unit = arg_1_2
	arg_1_0._nav_world = Managers.state.entity:system("ai_system"):nav_world()

	local var_1_0 = arg_1_3.profile
	local var_1_1 = arg_1_3.skin_name
	local var_1_2 = Managers.backend:get_interface("hero_attributes"):get(var_1_0.display_name, "career") or 1
	local var_1_3 = Cosmetics[var_1_1].first_person_attachment or var_1_0.first_person_attachment
	local var_1_4 = Cosmetics[var_1_1].first_person or var_1_0.base_units.first_person
	local var_1_5 = var_1_3.unit
	local var_1_6 = var_1_3.attachment_node_linking
	local var_1_7 = Managers.state.unit_spawner
	local var_1_8 = var_1_7:spawn_local_unit(var_1_4)
	local var_1_9 = var_1_0.careers[var_1_2]
	local var_1_10 = var_1_0.default_state_machine

	if var_1_10 then
		Unit.set_animation_state_machine(var_1_8, var_1_10)
	end

	arg_1_0.profile = var_1_0
	arg_1_0.first_person_unit = var_1_8

	Unit.set_flow_variable(var_1_8, "character_vo", var_1_0.character_vo)
	Unit.set_flow_variable(var_1_8, "sound_character", var_1_9.sound_character)
	Unit.flow_event(var_1_8, "character_vo_set")

	arg_1_0.first_person_attachment_unit = var_1_7:spawn_local_unit(var_1_5)

	Unit.set_flow_variable(var_1_8, "lua_first_person_mesh_unit", arg_1_0.first_person_attachment_unit)
	AttachmentUtils.link(arg_1_1.world, arg_1_0.first_person_unit, arg_1_0.first_person_attachment_unit, var_1_6)

	arg_1_0.first_person_mode = true
	arg_1_0._show_first_person_units = true
	arg_1_0._anim_var_id_lookup = {}
	arg_1_0._anim_var_values = {}
	arg_1_0.look_position = Vector3Box(Unit.local_position(arg_1_2, 0))
	arg_1_0.look_rotation = QuaternionBox(Unit.local_rotation(arg_1_2, 0))
	arg_1_0.forced_look_rotation = nil
	arg_1_0.forced_lerp_time = nil

	Unit.set_local_position(var_1_8, 0, Unit.local_position(arg_1_2, 0))
	Unit.set_local_rotation(var_1_8, 0, Unit.local_rotation(arg_1_2, 0))

	arg_1_0.has_look_delta = false
	arg_1_0.look_delta = Vector3Box()
	arg_1_0.player_height_wanted = arg_1_0:_player_height_from_name("stand")
	arg_1_0.player_height_current = arg_1_0.player_height_wanted
	arg_1_0.player_height_previous = arg_1_0.player_height_wanted
	arg_1_0.player_height_time_to_change = 0.001
	arg_1_0.player_height_change_start_time = 0
	arg_1_0.hide_weapon_reasons = {}
	arg_1_0.hide_weapon_lights_reasons = {}

	local var_1_11 = math.pi / 15

	arg_1_0.MAX_MIN_PITCH = math.pi / 2 - var_1_11
	arg_1_0.drawer = Managers.state.debug:drawer({
		mode = "immediate",
		name = "PlayerUnitFirstPerson"
	})
	arg_1_0._head_bob = true
	arg_1_0._game_options_dirty = true
	arg_1_0.aim_assist_multiplier = 1
	arg_1_0.aim_assist_ramp_multiplier = 0
	arg_1_0.aim_assist_ramp_multiplier_timer = 0

	if Unit.animation_has_constraint_target(var_1_8, "aim_target") then
		arg_1_0._aim_target_index = Unit.animation_find_constraint_target(var_1_8, "aim_target")
	end

	if script_data.disable_aim_lead_rig_motion then
		arg_1_0:disable_rig_movement()
	else
		arg_1_0:enable_rig_movement()
	end

	arg_1_0._rig_update_timestep = 0.016666666666666666
	arg_1_0._show_selected_jump = Managers.state.game_mode:setting("show_selected_jump")
	arg_1_0._current_jump_id = nil
	arg_1_0._move_y = 0
	arg_1_0._move_x = 0
	arg_1_0._move_z = 0
	arg_1_0._look_delta_y = 0
	arg_1_0._look_delta_x = 0
	arg_1_0._look_target_y = 0
	arg_1_0._look_target_x = 0
	arg_1_0._look_sensitivity = 1

	Managers.state.event:register(arg_1_0, "on_game_options_changed", "_set_game_options_dirty")
	arg_1_0:update_game_options()
	arg_1_0:animation_set_variable("career_index", var_1_2)
	arg_1_0:animation_set_variable("profile_index", var_1_0.index)

	local var_1_12 = var_1_9.animation_variables

	if var_1_12 then
		for iter_1_0, iter_1_1 in pairs(var_1_12) do
			arg_1_0:animation_set_variable(iter_1_0, iter_1_1)
		end
	end

	local var_1_13 = ScriptUnit.extension(arg_1_2, "career_system"):career_name()

	Wwise.set_state("current_career", var_1_13)
end

PlayerUnitFirstPerson.reset = function (arg_2_0)
	return
end

PlayerUnitFirstPerson.extensions_ready = function (arg_3_0)
	local var_3_0 = arg_3_0.unit

	arg_3_0.locomotion_extension = ScriptUnit.extension(var_3_0, "locomotion_system")
	arg_3_0.inventory_extension = ScriptUnit.extension(var_3_0, "inventory_system")
	arg_3_0.attachment_extension = ScriptUnit.extension(var_3_0, "attachment_system")
	arg_3_0.smart_targeting_extension = ScriptUnit.extension(var_3_0, "smart_targeting_system")
	arg_3_0.input_extension = ScriptUnit.extension(var_3_0, "input_system")
	arg_3_0.cosmetic_extension = ScriptUnit.extension(var_3_0, "cosmetic_system")

	local var_3_1 = ScriptUnit.extension(var_3_0, "career_system"):career_name()

	Unit.set_flow_variable(arg_3_0.first_person_unit, "lua_career_name", var_3_1)

	if script_data.debug_third_person then
		arg_3_0:set_first_person_mode(false)
	else
		arg_3_0.cosmetic_extension:show_third_person_mesh(false)
	end
end

PlayerUnitFirstPerson.destroy = function (arg_4_0)
	AttachmentUtils.unlink(arg_4_0.world, arg_4_0.first_person_attachment_unit)

	local var_4_0 = Managers.state.unit_spawner

	var_4_0:mark_for_deletion(arg_4_0.first_person_unit)
	var_4_0:mark_for_deletion(arg_4_0.first_person_attachment_unit)
	Managers.state.event:unregister("on_game_options_changed", arg_4_0)
end

PlayerUnitFirstPerson.set_state_machine = function (arg_5_0, arg_5_1)
	if arg_5_1 == arg_5_0._current_state_machine then
		return
	end

	local var_5_0 = arg_5_0.first_person_unit

	Unit.set_animation_state_machine_blend_base_layer(var_5_0, arg_5_1)

	if arg_5_0.profile.supports_motion_sickness_modes then
		Unit.animation_event(var_5_0, arg_5_0._head_bob and "enable_headbob" or "disable_headbob")
		Unit.animation_event(var_5_0, "motion_sickness_hit_" .. arg_5_0._motion_sickness_hit)
		Unit.animation_event(var_5_0, "motion_sickness_swing_" .. arg_5_0._motion_sickness_swing)
		Unit.animation_event(var_5_0, "motion_sickness_misc_" .. arg_5_0._motion_sickness_misc_cam)

		if arg_5_0._motion_sickness_swing == "off" and arg_5_0._motion_sickness_hit == "off" then
			Unit.animation_event(var_5_0, "motion_sickness_both_muted")
		end
	end

	table.clear(arg_5_0._anim_var_id_lookup)

	for iter_5_0, iter_5_1 in pairs(arg_5_0._anim_var_values) do
		arg_5_0:animation_set_variable(iter_5_0, iter_5_1)
	end

	arg_5_0._current_state_machine = arg_5_1
end

PlayerUnitFirstPerson._set_game_options_dirty = function (arg_6_0)
	arg_6_0._game_options_dirty = true
end

PlayerUnitFirstPerson.update_game_options = function (arg_7_0)
	if not arg_7_0._game_options_dirty then
		return
	end

	local var_7_0 = Application.user_setting("head_bob")

	if arg_7_0._head_bob ~= var_7_0 then
		Unit.animation_event(arg_7_0.first_person_unit, var_7_0 and "enable_headbob" or "disable_headbob")

		arg_7_0._head_bob = var_7_0
	end

	if arg_7_0.profile.supports_motion_sickness_modes then
		local var_7_1 = Application.user_setting("motion_sickness_hit")

		if arg_7_0._motion_sickness_hit ~= var_7_1 then
			local var_7_2 = "motion_sickness_hit_" .. var_7_1

			Unit.animation_event(arg_7_0.first_person_unit, var_7_2)

			arg_7_0._motion_sickness_hit = var_7_1
		end

		local var_7_3 = Application.user_setting("motion_sickness_swing")

		if arg_7_0._motion_sickness_swing ~= var_7_3 then
			local var_7_4 = "motion_sickness_swing_" .. var_7_3

			Unit.animation_event(arg_7_0.first_person_unit, var_7_4)

			arg_7_0._motion_sickness_swing = var_7_3
		end

		if var_7_3 == "off" and var_7_1 == "off" then
			Unit.animation_event(arg_7_0.first_person_unit, "motion_sickness_both_muted")
		end

		local var_7_5 = Application.user_setting("motion_sickness_misc_cam")

		if arg_7_0._motion_sickness_misc_cam ~= var_7_5 then
			local var_7_6 = "motion_sickness_misc_" .. var_7_5

			Unit.animation_event(arg_7_0.first_person_unit, var_7_6)

			arg_7_0._motion_sickness_misc_cam = var_7_5
		end
	end

	arg_7_0._gamepad_auto_aim_enabled = Application.user_setting("gamepad_auto_aim_enabled")

	local var_7_7

	if Application.user_setting("tobii_eyetracking") then
		var_7_7 = ScriptUnit.has_extension(arg_7_0.unit, "eyetracking_system")
	end

	arg_7_0._eyetracking_extension = var_7_7

	local var_7_8 = Application.user_setting("weapon_trails")

	Unit.set_data(arg_7_0.first_person_unit, "trails_enabled", var_7_8 ~= "none")

	arg_7_0._game_options_dirty = false
end

local var_0_6 = {}

PlayerUnitFirstPerson.check_for_jumps = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = POSITION_LOOKUP[arg_8_1]
	local var_8_1 = Managers.state.entity:system("nav_graph_system")
	local var_8_2 = var_8_1.jumps_broadphase_max_dist
	local var_8_3 = var_8_1.jumps_broadphase
	local var_8_4 = Broadphase.query(var_8_3, var_8_0, var_8_2, var_0_6)

	if var_8_4 <= 0 then
		return
	end

	local var_8_5 = arg_8_0.world
	local var_8_6 = var_8_1.level_jumps
	local var_8_7 = Managers.player:owner(arg_8_0.unit).viewport_name
	local var_8_8 = ScriptWorld.viewport(arg_8_0.world, var_8_7)
	local var_8_9 = ScriptViewport.camera(var_8_8)
	local var_8_10 = ScriptCamera.position(var_8_9)
	local var_8_11 = ScriptCamera.rotation(var_8_9)
	local var_8_12 = Quaternion.forward(var_8_11)
	local var_8_13
	local var_8_14
	local var_8_15 = 0

	for iter_8_0 = 1, var_8_4 do
		local var_8_16 = var_0_6[iter_8_0]
		local var_8_17 = var_8_6[var_8_16]
		local var_8_18 = var_8_17.jump_object_data
		local var_8_19 = var_8_17.swap_entrance_exit and var_8_18.pos1 or var_8_18.pos2
		local var_8_20 = Vector3(var_8_19[1], var_8_19[2], var_8_19[3])
		local var_8_21 = Vector3.normalize(Vector3.flat(var_8_20 - var_8_10))
		local var_8_22 = Vector3.dot(var_8_21, var_8_12)
		local var_8_23 = var_8_22 > 0.25
		local var_8_24 = Vector3.distance(var_8_20, var_8_0)

		if var_8_23 or var_8_24 < 0.25 then
			local var_8_25 = math.clamp(var_8_24, 1, 5)
			local var_8_26 = var_8_22 + 1.15 / (var_8_25 * var_8_25)

			if var_8_15 < var_8_26 and var_8_24 < 2 then
				var_8_15 = var_8_26

				local var_8_27 = var_8_20

				var_8_13 = var_8_16
			end
		end
	end

	if var_8_13 then
		if var_8_13 ~= arg_8_0._current_jump_id then
			arg_8_0._current_jump_id = var_8_13

			local var_8_28 = var_8_6[var_8_13]

			if var_8_28 then
				local var_8_29 = var_8_28.jump_object_data
				local var_8_30 = Vector3Aux.unbox(var_8_29.pos1)
				local var_8_31 = Vector3Aux.unbox(var_8_29.pos2)

				arg_8_0._valid_jump_id = var_8_13
				arg_8_0._valid_jump_data = var_8_28

				local var_8_32 = var_8_28.swap_entrance_exit and var_8_31 - var_8_30 or var_8_30 - var_8_31
				local var_8_33 = Vector3.flat(var_8_32)
				local var_8_34 = Quaternion.look(var_8_33)

				if arg_8_0._indicator_unit then
					Unit.flow_event(arg_8_0._indicator_unit, "disable_glow")
				end

				if arg_8_0._show_selected_jump then
					arg_8_0._indicator_unit = var_8_28.unit
				end

				if arg_8_0._show_selected_jump and arg_8_0._indicator_unit then
					Unit.flow_event(arg_8_0._indicator_unit, "enable_glow")
				end
			end
		end
	else
		arg_8_0:_reset_jump_indicator()
	end
end

PlayerUnitFirstPerson._reset_jump_indicator = function (arg_9_0)
	arg_9_0._valid_jump_id = nil
	arg_9_0._valid_jump_data = nil

	if arg_9_0._indicator_unit and var_0_1(arg_9_0._indicator_unit) then
		Unit.flow_event(arg_9_0._indicator_unit, "disable_glow")

		arg_9_0._indicator_unit = nil
	end

	arg_9_0._current_jump_id = nil
end

local var_0_7 = {}

PlayerUnitFirstPerson._draw_smart_objects = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	if not arg_10_1 then
		return
	end

	local var_10_0 = arg_10_1.jump_object_data
	local var_10_1 = var_10_0.smart_object_type

	var_0_7[1] = Vector3Aux.unbox(var_10_0.pos1)
	var_0_7[2] = Vector3Aux.unbox(var_10_0.pos2)

	local var_10_2 = math.clamp(1 - arg_10_3 / arg_10_4, 0, 1)
	local var_10_3 = math.clamp(255 * var_10_2, 1, 255)
	local var_10_4 = Managers.state.debug:drawer({
		mode = "immediate",
		name = "DarkPactPlayerJumpDrawer"
	})
	local var_10_5 = Color(var_10_3, 127, 255, 212)

	if var_10_1 == "ledges" or var_10_1 == "ledges_with_fence" then
		if var_10_0.data.ledge_position1 then
			var_10_4:line(var_0_7[1], Vector3Aux.unbox(var_10_0.data.ledge_position1), var_10_5)
			var_10_4:line(Vector3Aux.unbox(var_10_0.data.ledge_position1), Vector3Aux.unbox(var_10_0.data.ledge_position2), var_10_5)
			var_10_4:line(var_0_7[2], Vector3Aux.unbox(var_10_0.data.ledge_position2), var_10_5)
		else
			var_10_4:line(var_0_7[1], Vector3Aux.unbox(var_10_0.data.ledge_position), var_10_5)
			var_10_4:line(var_0_7[2], Vector3Aux.unbox(var_10_0.data.ledge_position), var_10_5)
		end

		if not var_10_0.data.is_bidirectional then
			var_10_4:vector(var_0_7[1], Vector3.up(), var_10_5)
		end
	elseif var_10_1 == "jumps" then
		var_10_4:line(var_0_7[1], var_0_7[2], var_10_5)
	else
		var_10_4:line(var_0_7[1], var_0_7[2], var_10_5)
	end

	local var_10_6 = arg_10_0._nav_world

	if GwNavQueries.triangle_from_position(var_10_6, var_0_7[1]) then
		var_10_4:sphere(var_0_7[1], 0.02, var_10_5)
	end

	if GwNavQueries.triangle_from_position(var_10_6, var_0_7[2]) then
		var_10_4:sphere(var_0_7[2], 0.02, var_10_5)
	end
end

PlayerUnitFirstPerson.get_valid_jump_id = function (arg_11_0)
	return arg_11_0._valid_jump_id, arg_11_0._valid_jump_data
end

PlayerUnitFirstPerson.update = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	if Managers.input:is_device_active("gamepad") then
		arg_12_0:update_aim_assist_multiplier(arg_12_3)
	end

	arg_12_0:update_game_options(arg_12_3, arg_12_5)
	arg_12_0:update_player_height(arg_12_5)
	arg_12_0:update_rotation(arg_12_5, arg_12_3)
	arg_12_0:update_position()

	local var_12_0 = Managers.player:owner(arg_12_1)

	if arg_12_0.toggle_visibility_timer and arg_12_5 >= arg_12_0.toggle_visibility_timer then
		arg_12_0.toggle_visibility_timer = nil

		arg_12_0:set_first_person_mode(not arg_12_0.first_person_mode)
	end

	if arg_12_0._first_person_units_visibility_timer and arg_12_5 >= arg_12_0._first_person_units_visibility_timer then
		arg_12_0:toggle_first_person_units_visibility(arg_12_0._first_person_units_visibility_reason)
	end

	if arg_12_0._want_to_show_first_person_ammo ~= nil then
		local var_12_1 = arg_12_0._show_first_person_units
		local var_12_2 = arg_12_0._want_to_show_first_person_ammo

		if var_12_1 and var_12_2 then
			arg_12_0.inventory_extension:show_first_person_inventory(true)

			arg_12_0._want_to_show_first_person_ammo = nil
		elseif var_12_1 and not var_12_2 then
			arg_12_0.inventory_extension:show_first_person_inventory(false)

			arg_12_0._want_to_show_first_person_ammo = nil
		elseif not var_12_1 and var_12_2 then
			-- Nothing
		elseif not var_12_1 and not var_12_2 then
			arg_12_0.inventory_extension:show_first_person_inventory(false)

			arg_12_0._want_to_show_first_person_ammo = nil
		end
	end

	if script_data.attract_mode_spectate and arg_12_0.first_person_mode then
		CharacterStateHelper.change_camera_state(Managers.player:local_player(), "attract")
		arg_12_0:set_first_person_mode(false, true)
	end

	if arg_12_0.first_person_unit then
		arg_12_0:_update_state_machine_variables(arg_12_3, arg_12_5)
	end

	if arg_12_0._check_for_jumps then
		arg_12_0:check_for_jumps(arg_12_1, arg_12_5)
	end

	if script_data.testify then
		Testify:poll_requests_through_handler(var_0_0, arg_12_0)
	end
end

PlayerUnitFirstPerson.update_aim_assist_multiplier = function (arg_13_0, arg_13_1)
	if arg_13_0._gamepad_auto_aim_enabled then
		local var_13_0 = arg_13_0.inventory_extension
		local var_13_1
		local var_13_2 = var_13_0:equipment()
		local var_13_3 = var_13_2.right_hand_wielded_unit or var_13_2.left_hand_wielded_unit

		if Unit.alive(var_13_3) then
			local var_13_4 = ScriptUnit.extension(var_13_3, "weapon_system")

			if var_13_4:has_current_action() then
				var_13_1 = var_13_4:get_current_action_settings()
			end
		end

		local var_13_5 = var_13_0:get_wielded_slot_item_template()
		local var_13_6

		if var_13_1 and var_13_1.aim_assist_settings then
			var_13_6 = var_13_1.aim_assist_settings
		else
			var_13_6 = var_13_5 and var_13_5.aim_assist_settings
		end

		local var_13_7 = var_13_6 and var_13_6.base_multiplier or 0
		local var_13_8 = var_13_6 and var_13_6.no_aim_input_multiplier or var_13_7 * 0.5
		local var_13_9 = arg_13_0.input_extension
		local var_13_10 = var_13_9:get("look_raw_controller")
		local var_13_11 = var_13_9:get("move_controller")
		local var_13_12 = true

		if (not var_13_6 or not var_13_6.always_auto_aim) and Vector3.length(var_13_10) < 0.01 then
			var_13_7 = var_13_8

			if Vector3.length(var_13_11) < 0.01 then
				var_13_12 = false
			end
		end

		local var_13_13 = math.max(arg_13_0.aim_assist_ramp_multiplier_timer - arg_13_1, 0)
		local var_13_14

		if var_13_13 > 0 then
			var_13_14 = arg_13_0.aim_assist_ramp_multiplier
		else
			var_13_14 = math.max(arg_13_0.aim_assist_ramp_multiplier - arg_13_1, 0)
		end

		arg_13_0.aim_assist_multiplier = var_13_12 and math.min(var_13_7 + var_13_14, 1) or 0
		arg_13_0.aim_assist_ramp_multiplier = var_13_14
		arg_13_0.aim_assist_ramp_multiplier_timer = var_13_13
	else
		arg_13_0.aim_assist_multiplier = 0
		arg_13_0.aim_assist_ramp_multiplier = 0
		arg_13_0.aim_assist_ramp_multiplier_timer = 0
	end
end

PlayerUnitFirstPerson.increase_aim_assist_multiplier = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	arg_14_0.aim_assist_ramp_multiplier_timer, arg_14_0.aim_assist_ramp_multiplier = arg_14_3 or 2, math.min(arg_14_0.aim_assist_ramp_multiplier + arg_14_1, arg_14_2)
end

PlayerUnitFirstPerson.reset_aim_assist_multiplier = function (arg_15_0)
	arg_15_0.aim_assist_ramp_multiplier = 0
	arg_15_0.aim_assist_ramp_multiplier_timer = 0
end

local function var_0_8(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	arg_16_0 = arg_16_0 / arg_16_3

	return -arg_16_2 * arg_16_0 * (arg_16_0 - 2) + arg_16_1
end

PlayerUnitFirstPerson.update_player_height = function (arg_17_0, arg_17_1)
	local var_17_0 = arg_17_1 - arg_17_0.player_height_change_start_time

	if var_17_0 < arg_17_0.player_height_time_to_change then
		arg_17_0.player_height_current = var_0_8(var_17_0, arg_17_0.player_height_previous, arg_17_0.player_height_wanted - arg_17_0.player_height_previous, arg_17_0.player_height_time_to_change)
	else
		arg_17_0.player_height_current = arg_17_0.player_height_wanted
	end
end

PlayerUnitFirstPerson.set_rotation = function (arg_18_0, arg_18_1)
	Unit.set_local_rotation(arg_18_0.first_person_unit, 0, arg_18_1)
	Unit.set_local_rotation(arg_18_0.unit, 0, arg_18_1)
	arg_18_0.look_rotation:store(arg_18_1)
end

PlayerUnitFirstPerson.force_look_rotation = function (arg_19_0, arg_19_1, arg_19_2)
	arg_19_0.forced_look_rotation = QuaternionBox(arg_19_1)
	arg_19_0.forced_lerp_timer = 0
	arg_19_0.forced_total_lerp_time = arg_19_2
end

PlayerUnitFirstPerson.stop_force_look_rotation = function (arg_20_0)
	arg_20_0.forced_look_rotation = nil
	arg_20_0.forced_lerp_timer = 0
	arg_20_0.forced_lerp_time = nil
end

PlayerUnitFirstPerson.update_rotation = function (arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_0.first_person_unit
	local var_21_1 = arg_21_0.smart_targeting_extension:get_targeting_data()

	if arg_21_0.forced_look_rotation ~= nil then
		local var_21_2 = arg_21_0.forced_total_lerp_time or 0.3

		arg_21_0.forced_lerp_timer = arg_21_0.forced_lerp_timer + arg_21_2

		local var_21_3 = 1 - arg_21_0.forced_lerp_timer / var_21_2
		local var_21_4 = 1 - var_21_3 * var_21_3
		local var_21_5 = Quaternion.lerp(arg_21_0.look_rotation:unbox(), arg_21_0.forced_look_rotation:unbox(), var_21_4)
		local var_21_6 = Quaternion.yaw(var_21_5)
		local var_21_7 = math.clamp(Quaternion.pitch(var_21_5), -arg_21_0.MAX_MIN_PITCH, arg_21_0.MAX_MIN_PITCH)
		local var_21_8 = Quaternion.roll(var_21_5)
		local var_21_9 = Quaternion(Vector3.up(), var_21_6)
		local var_21_10 = Quaternion(Vector3.right(), var_21_7)
		local var_21_11 = Quaternion(Vector3.forward(), var_21_8)
		local var_21_12 = Quaternion.multiply(var_21_9, var_21_10)
		local var_21_13 = Quaternion.multiply(var_21_12, var_21_11)

		arg_21_0.look_rotation:store(var_21_13)

		local var_21_14 = arg_21_0.first_person_unit

		Unit.set_local_rotation(var_21_14, 0, var_21_13)

		if var_21_2 <= arg_21_0.forced_lerp_timer then
			arg_21_0.has_look_delta = false
			arg_21_0.forced_look_rotation = nil
			arg_21_0.forced_lerp_time = nil
		end
	elseif arg_21_0.has_look_delta then
		local var_21_15 = var_21_1.unit
		local var_21_16 = arg_21_0.look_rotation:unbox()
		local var_21_17 = arg_21_0.look_delta:unbox()

		arg_21_0.has_look_delta = false

		local var_21_18 = (arg_21_0._weapon_sway_settings or var_0_5).camera_look_sensitivity or 1
		local var_21_19 = PlayerUnitMovementSettings.get_movement_settings_table(arg_21_0.unit)
		local var_21_20 = var_21_19.look_input_limit

		if var_21_20 ~= -1 then
			local var_21_21 = var_21_20 * var_21_19.look_input_limit_multiplier * arg_21_2
			local var_21_22 = Vector3.length(var_21_17)

			if var_21_21 < var_21_22 then
				var_21_17 = var_21_17 * (var_21_21 / var_21_22)
			end
		end

		local var_21_23 = arg_21_0:calculate_look_rotation(var_21_16, var_21_17 * var_21_18, arg_21_2)

		if var_21_15 and Managers.input:is_device_active("gamepad") then
			var_21_23 = arg_21_0:calculate_aim_assisted_rotation(var_21_23, var_21_1, var_21_17, arg_21_2)
		end

		if MotionControlSettings.use_motion_controls and arg_21_0.input_extension:get("reset_view") then
			local var_21_24, var_21_25 = Quaternion.forward(var_21_23)
			local var_21_26 = Vector3.normalize(Vector3.flat(var_21_24))

			var_21_23 = Quaternion.look(var_21_26, Vector3.up())
		end

		arg_21_0.look_rotation:store(var_21_23)

		local var_21_27 = arg_21_0.first_person_unit
		local var_21_28, var_21_29 = Managers.state.camera:is_recoiling()

		if var_21_28 and var_21_29 then
			var_21_23 = Quaternion.multiply(var_21_23, var_21_29:unbox())
		end

		Unit.set_local_rotation(var_21_27, 0, var_21_23)
		arg_21_0:update_rig_movement(var_21_17)
	end
end

PlayerUnitFirstPerson.tutorial_restrict_camera_rotation = function (arg_22_0, arg_22_1, arg_22_2)
	if arg_22_1 then
		arg_22_0.restrict_rotation_angle = math.degrees_to_radians(arg_22_2)
	else
		arg_22_0.restrict_rotation_angle = nil
	end
end

PlayerUnitFirstPerson.calculate_look_rotation = function (arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = Quaternion.yaw(arg_23_1) - arg_23_2.x

	if arg_23_0.restrict_rotation_angle then
		var_23_0 = math.clamp(var_23_0, -arg_23_0.restrict_rotation_angle, arg_23_0.restrict_rotation_angle)
	end

	local var_23_1 = math.clamp(Quaternion.pitch(arg_23_1) + arg_23_2.y, -arg_23_0.MAX_MIN_PITCH, arg_23_0.MAX_MIN_PITCH)
	local var_23_2 = Quaternion(Vector3.up(), var_23_0)
	local var_23_3 = Quaternion(Vector3.right(), var_23_1)

	return (Quaternion.multiply(var_23_2, var_23_3))
end

PlayerUnitFirstPerson.calculate_aim_assisted_rotation = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	local var_24_0 = arg_24_2.unit
	local var_24_1 = arg_24_2.target_position - arg_24_0:current_position()
	local var_24_2 = Quaternion.look(var_24_1, Vector3.up())
	local var_24_3 = arg_24_2.aim_score
	local var_24_4 = arg_24_0.aim_assist_multiplier
	local var_24_5 = arg_24_2.vertical_only and arg_24_1 or Quaternion.lerp(arg_24_1, var_24_2, arg_24_4 * 33 * var_24_3 * var_24_4)
	local var_24_6 = Quaternion.lerp(arg_24_1, var_24_2, var_24_4 * 0.5 * arg_24_4 * 33 * var_24_3 * var_24_4)
	local var_24_7 = Quaternion.yaw(var_24_5)
	local var_24_8 = Quaternion.pitch(var_24_6)
	local var_24_9 = Quaternion(Vector3.up(), var_24_7)
	local var_24_10 = Quaternion(Vector3.right(), var_24_8)

	return (Quaternion.multiply(var_24_9, var_24_10))
end

PlayerUnitFirstPerson.update_position = function (arg_25_0)
	local var_25_0 = Unit.local_position(arg_25_0.unit, 0) + Vector3(0, 0, arg_25_0.player_height_current)

	Unit.set_local_position(arg_25_0.first_person_unit, 0, var_25_0)
end

PlayerUnitFirstPerson.is_in_view = function (arg_26_0, arg_26_1)
	local var_26_0 = Managers.player:owner(arg_26_0.unit).viewport_name

	Managers.state.camera:is_in_view(var_26_0, arg_26_1)
end

PlayerUnitFirstPerson.is_infront = function (arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = Managers.player:owner(arg_27_0.unit).viewport_name
	local var_27_1 = ScriptWorld.viewport(arg_27_0.world, var_27_0)
	local var_27_2 = ScriptViewport.camera(var_27_1)
	local var_27_3 = ScriptCamera.position(var_27_2)
	local var_27_4 = ScriptCamera.rotation(var_27_2)
	local var_27_5 = Vector3.normalize(Quaternion.forward(var_27_4))
	local var_27_6 = Vector3.normalize(arg_27_1 - var_27_3)

	return Vector3.dot(var_27_6, var_27_5) > (arg_27_2 or 0)
end

PlayerUnitFirstPerson.is_within_custom_view = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	return math.point_is_inside_view(arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
end

PlayerUnitFirstPerson.is_within_default_view = function (arg_29_0, arg_29_1)
	local var_29_0, var_29_1 = arg_29_0:camera_position_rotation()
	local var_29_2 = CameraSettings.first_person._node.vertical_fov * math.pi / 180
	local var_29_3 = var_29_2 * 1.7777777777777777

	return math.point_is_inside_view(arg_29_1, var_29_0, var_29_1, var_29_2, var_29_3)
end

PlayerUnitFirstPerson.apply_recoil = function (arg_30_0, arg_30_1)
	local var_30_0 = Managers.player:owner(arg_30_0.unit).viewport_name
	local var_30_1 = ScriptWorld.viewport(arg_30_0.world, var_30_0)
	local var_30_2 = ScriptViewport.camera(var_30_1)
	local var_30_3 = ScriptCamera.rotation(var_30_2)
	local var_30_4 = arg_30_0.look_rotation:unbox()
	local var_30_5, var_30_6 = Managers.state.camera:is_recoiling()

	if var_30_5 and var_30_6 then
		var_30_3 = Quaternion.multiply(var_30_4, var_30_6:unbox())
	end

	local var_30_7 = arg_30_0._eyetracking_extension

	if arg_30_0._eyetracking_extension and var_30_7:get_is_feature_enabled("tobii_extended_view") then
		var_30_3 = var_30_7:get_direction_without_extended_view(var_30_3)
	end

	local var_30_8 = Quaternion.lerp(var_30_4, var_30_3, arg_30_1 or 1)

	Unit.set_local_rotation(arg_30_0.first_person_unit, 0, var_30_8)
	arg_30_0.look_rotation:store(var_30_8)
end

PlayerUnitFirstPerson.get_first_person_unit = function (arg_31_0)
	return arg_31_0.first_person_unit
end

PlayerUnitFirstPerson.get_first_person_mesh_unit = function (arg_32_0)
	return arg_32_0.first_person_attachment_unit
end

PlayerUnitFirstPerson.set_look_delta = function (arg_33_0, arg_33_1)
	if not Vector3.is_valid(arg_33_1) then
		print("HON-18240; set_look_delta called after PlayerUnitFirstPerson update")
		print(Script.callstack())
	end

	Vector3Box.store(arg_33_0.look_delta, arg_33_1)

	arg_33_0.has_look_delta = true
end

PlayerUnitFirstPerson.set_weapon_sway_settings = function (arg_34_0, arg_34_1)
	arg_34_0._weapon_sway_settings = arg_34_1
end

PlayerUnitFirstPerson.play_animation_event = function (arg_35_0, arg_35_1)
	Unit.animation_event(arg_35_0.first_person_unit, arg_35_1)
end

PlayerUnitFirstPerson.set_aim_constraint_target = function (arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = Unit.animation_find_constraint_target(arg_36_0.first_person_unit, arg_36_1)

	Unit.animation_set_constraint_target(arg_36_0.first_person_unit, var_36_0, arg_36_2)
end

PlayerUnitFirstPerson.current_rotation = function (arg_37_0)
	return Unit.local_rotation(arg_37_0.first_person_unit, 0)
end

PlayerUnitFirstPerson.current_position = function (arg_38_0)
	return Unit.local_position(arg_38_0.first_person_unit, 0)
end

PlayerUnitFirstPerson.camera_position_rotation = function (arg_39_0)
	local var_39_0 = Managers.player:owner(arg_39_0.unit).viewport_name
	local var_39_1 = ScriptWorld.viewport(arg_39_0.world, var_39_0)
	local var_39_2 = ScriptViewport.camera(var_39_1)
	local var_39_3 = ScriptCamera.position(var_39_2)
	local var_39_4 = ScriptCamera.rotation(var_39_2)

	return var_39_3, var_39_4
end

PlayerUnitFirstPerson.camera = function (arg_40_0)
	local var_40_0 = Managers.player:owner(arg_40_0.unit).viewport_name
	local var_40_1 = ScriptWorld.viewport(arg_40_0.world, var_40_0)

	return ScriptViewport.camera(var_40_1)
end

PlayerUnitFirstPerson.get_projectile_start_position_rotation = function (arg_41_0)
	local var_41_0

	if arg_41_0:first_person_mode_active() then
		local var_41_1 = Managers.player:owner(arg_41_0.unit).viewport_name
		local var_41_2 = ScriptWorld.viewport(arg_41_0.world, var_41_1)
		local var_41_3 = ScriptViewport.camera(var_41_2)

		var_41_0 = ScriptCamera.position(var_41_3)
	else
		var_41_0 = arg_41_0:current_position()
	end

	local var_41_4 = arg_41_0:current_rotation()

	return var_41_0, var_41_4
end

PlayerUnitFirstPerson.set_wanted_player_height = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	local var_42_0 = arg_42_0:_player_height_from_name(arg_42_1)
	local var_42_1 = 3

	arg_42_0.player_height_wanted = var_42_0
	arg_42_0.player_height_previous = arg_42_0.player_height_current

	if arg_42_3 == nil then
		arg_42_3 = math.abs(var_42_0 - arg_42_0.player_height_previous) / var_42_1
		arg_42_3 = math.clamp(arg_42_3, 0.001, 1000)
	end

	arg_42_0.player_height_time_to_change = arg_42_3
	arg_42_0.player_height_change_start_time = arg_42_2
end

PlayerUnitFirstPerson._player_height_from_name = function (arg_43_0, arg_43_1)
	return arg_43_0.profile.first_person_heights[arg_43_1]
end

PlayerUnitFirstPerson.toggle_visibility = function (arg_44_0, arg_44_1)
	local var_44_0 = Managers.time:time("game")

	if arg_44_0.toggle_visibility_timer then
		arg_44_0:set_first_person_mode(not arg_44_0.first_person_mode)
	end

	if arg_44_1 then
		arg_44_0.toggle_visibility_timer = var_44_0 + arg_44_1
	else
		arg_44_0:set_first_person_mode(not arg_44_0.first_person_mode)
	end
end

PlayerUnitFirstPerson.set_first_person_mode = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	if not arg_45_0.debug_first_person_mode and (arg_45_2 or not Development.parameter("third_person_mode") or not Development.parameter("attract_mode")) then
		if arg_45_0.first_person_mode ~= arg_45_1 then
			arg_45_0.cosmetic_extension:show_third_person_mesh(not arg_45_1)

			if not arg_45_0.tutorial_first_person then
				Unit.set_unit_visibility(arg_45_0.first_person_attachment_unit, arg_45_1)
			end
		end

		if arg_45_1 then
			arg_45_0:unhide_weapons("third_person_mode")

			if arg_45_0.first_person_mode ~= arg_45_1 then
				Unit.flow_event(arg_45_0.first_person_unit, "lua_exit_third_person_camera")
			end
		else
			arg_45_0:hide_weapons("third_person_mode", true)

			if arg_45_0.first_person_mode ~= arg_45_1 then
				Unit.flow_event(arg_45_0.first_person_unit, "lua_enter_third_person_camera")
			end
		end

		arg_45_0.inventory_extension:show_third_person_inventory(not arg_45_1 and not arg_45_3)
		arg_45_0.attachment_extension:show_attachments(not arg_45_1)
	end

	arg_45_0:abort_toggle_visibility_timer()
	arg_45_0:abort_first_person_units_visibility_timer()

	arg_45_0.first_person_mode = arg_45_1
	arg_45_0._show_first_person_units = arg_45_1
end

PlayerUnitFirstPerson.show_third_person_units = function (arg_46_0, arg_46_1)
	arg_46_0.inventory_extension:show_third_person_inventory(arg_46_1)
	arg_46_0.attachment_extension:show_attachments(arg_46_1)
	arg_46_0.cosmetic_extension:show_third_person_mesh(arg_46_1)
end

PlayerUnitFirstPerson.first_person_mode_active = function (arg_47_0)
	return arg_47_0.first_person_mode
end

PlayerUnitFirstPerson.abort_toggle_visibility_timer = function (arg_48_0)
	arg_48_0.toggle_visibility_timer = nil
end

PlayerUnitFirstPerson.first_person_units_visible = function (arg_49_0)
	return arg_49_0._show_first_person_units
end

PlayerUnitFirstPerson.abort_first_person_units_visibility_timer = function (arg_50_0)
	arg_50_0._first_person_units_visibility_timer = nil
	arg_50_0._first_person_units_visibility_reason = nil
end

PlayerUnitFirstPerson.toggle_first_person_units_visibility = function (arg_51_0, arg_51_1, arg_51_2)
	if arg_51_2 then
		arg_51_0._first_person_units_visibility_timer = Managers.time:time("game") + arg_51_2
		arg_51_0._first_person_units_visibility_reason = arg_51_1
	else
		local var_51_0 = not arg_51_0._show_first_person_units

		arg_51_0._first_person_units_visibility_timer = nil
		arg_51_0._first_person_units_visibility_reason = nil
		arg_51_0._show_first_person_units = var_51_0

		Unit.set_unit_visibility(arg_51_0.first_person_attachment_unit, var_51_0)

		if var_51_0 then
			arg_51_0:unhide_weapons(arg_51_1)
		else
			arg_51_0:hide_weapons(arg_51_1, var_51_0)
		end
	end
end

PlayerUnitFirstPerson.tutorial_show_first_person_units = function (arg_52_0, arg_52_1)
	Unit.set_unit_visibility(arg_52_0.first_person_attachment_unit, arg_52_1)

	arg_52_0.tutorial_first_person = not arg_52_1

	if arg_52_1 then
		arg_52_0:unhide_weapons("tutorial")
	else
		arg_52_0:hide_weapons("tutorial", arg_52_1)
	end
end

PlayerUnitFirstPerson.debug_set_first_person_mode = function (arg_53_0, arg_53_1, arg_53_2)
	local var_53_0 = arg_53_0.first_person_mode

	if arg_53_1 then
		arg_53_0.debug_first_person_mode = false

		arg_53_0:set_first_person_mode(arg_53_2)

		arg_53_0.first_person_mode = var_53_0
		arg_53_0.debug_first_person_mode = true
	else
		arg_53_0.debug_first_person_mode = false

		arg_53_0:set_first_person_mode(var_53_0)
	end
end

PlayerUnitFirstPerson.hide_weapons = function (arg_54_0, arg_54_1, arg_54_2)
	arg_54_0.hide_weapon_reasons[arg_54_1] = true

	if not table.is_empty(arg_54_0.hide_weapon_reasons) then
		arg_54_0.inventory_extension:show_first_person_inventory(false)
	end

	if arg_54_2 then
		arg_54_0.hide_weapon_lights_reasons[arg_54_1] = true

		if not table.is_empty(arg_54_0.hide_weapon_lights_reasons) then
			arg_54_0.inventory_extension:show_first_person_inventory_lights(false)
		end
	end
end

PlayerUnitFirstPerson.unhide_weapons = function (arg_55_0, arg_55_1)
	arg_55_0.hide_weapon_reasons[arg_55_1] = nil
	arg_55_0.hide_weapon_lights_reasons[arg_55_1] = nil

	if table.is_empty(arg_55_0.hide_weapon_reasons) then
		arg_55_0.inventory_extension:show_first_person_inventory(true)
	end

	if table.is_empty(arg_55_0.hide_weapon_lights_reasons) then
		arg_55_0.inventory_extension:show_first_person_inventory_lights(true)
	end
end

PlayerUnitFirstPerson.show_first_person_ammo = function (arg_56_0, arg_56_1)
	if arg_56_0._show_first_person_units then
		arg_56_0.inventory_extension:show_first_person_ammo(arg_56_1)
	else
		arg_56_0._want_to_show_first_person_ammo = arg_56_1
	end
end

PlayerUnitFirstPerson.animation_set_variable = function (arg_57_0, arg_57_1, arg_57_2, arg_57_3)
	local var_57_0 = arg_57_0.first_person_unit
	local var_57_1 = arg_57_0._anim_var_id_lookup[arg_57_1]

	if var_57_1 == nil then
		var_57_1 = var_0_2(var_57_0, arg_57_1) or false
		arg_57_0._anim_var_id_lookup[arg_57_1] = var_57_1
	end

	if var_57_1 then
		var_0_3(var_57_0, var_57_1, arg_57_2)

		arg_57_0._anim_var_values[arg_57_1] = arg_57_2
	end
end

PlayerUnitFirstPerson.animation_event = function (arg_58_0, arg_58_1)
	Unit.animation_event(arg_58_0.first_person_unit, arg_58_1)
end

PlayerUnitFirstPerson.create_screen_particles = function (arg_59_0, arg_59_1, arg_59_2, ...)
	if Development.parameter("screen_space_player_camera_reactions") == false then
		return
	end

	return World.create_particles(arg_59_0.world, arg_59_1, arg_59_2 or Vector3.zero(), ...)
end

PlayerUnitFirstPerson.stop_spawning_screen_particles = function (arg_60_0, arg_60_1)
	if Development.parameter("screen_space_player_camera_reactions") == false then
		return
	end

	World.stop_spawning_particles(arg_60_0.world, arg_60_1)
end

PlayerUnitFirstPerson.destroy_screen_particles = function (arg_61_0, arg_61_1)
	if Development.parameter("screen_space_player_camera_reactions") == false then
		return
	end

	World.destroy_particles(arg_61_0.world, arg_61_1)
end

PlayerUnitFirstPerson.play_hud_sound_event = function (arg_62_0, arg_62_1, arg_62_2, arg_62_3)
	if arg_62_3 then
		arg_62_0:play_remote_hud_sound_event(arg_62_1)
	end

	local var_62_0 = Managers.world:wwise_world(arg_62_0.world)

	if arg_62_2 then
		local var_62_1, var_62_2 = WwiseWorld.trigger_event(var_62_0, arg_62_1, arg_62_2)

		return var_62_1, var_62_2
	else
		local var_62_3, var_62_4 = WwiseWorld.trigger_event(var_62_0, arg_62_1)

		return var_62_3, var_62_4
	end
end

PlayerUnitFirstPerson.play_remote_hud_sound_event = function (arg_63_0, arg_63_1)
	if not LEVEL_EDITOR_TEST then
		local var_63_0 = Managers.state.network
		local var_63_1 = var_63_0.network_transmit
		local var_63_2 = Managers.player.is_server
		local var_63_3 = var_63_0:unit_game_object_id(arg_63_0.unit)
		local var_63_4 = NetworkLookup.sound_events[arg_63_1]

		if var_63_2 then
			var_63_1:send_rpc_clients("rpc_play_husk_sound_event", var_63_3, var_63_4)
		else
			var_63_1:send_rpc_server("rpc_play_husk_sound_event", var_63_3, var_63_4)
		end
	end
end

PlayerUnitFirstPerson.play_sound_event = function (arg_64_0, arg_64_1, arg_64_2)
	local var_64_0 = arg_64_2 or arg_64_0:current_position()
	local var_64_1, var_64_2 = WwiseUtils.make_position_auto_source(arg_64_0.world, var_64_0)

	WwiseWorld.set_switch(var_64_2, "husk", "false", var_64_1)
	WwiseWorld.trigger_event(var_64_2, arg_64_1, var_64_1)
end

PlayerUnitFirstPerson.play_unit_sound_event = function (arg_65_0, arg_65_1, arg_65_2, arg_65_3, arg_65_4)
	if arg_65_4 then
		arg_65_0:play_remote_unit_sound_event(arg_65_1, arg_65_2, arg_65_3)
	end

	local var_65_0, var_65_1 = WwiseUtils.make_unit_auto_source(arg_65_0.world, arg_65_2, arg_65_3)

	WwiseWorld.set_switch(var_65_1, "husk", "false", var_65_0)
	WwiseWorld.trigger_event(var_65_1, arg_65_1, var_65_0)
end

PlayerUnitFirstPerson.play_remote_unit_sound_event = function (arg_66_0, arg_66_1, arg_66_2, arg_66_3)
	local var_66_0 = NetworkLookup.sound_events[arg_66_1]
	local var_66_1 = Managers.state.network

	if var_66_1:game() and not LEVEL_EDITOR_TEST then
		local var_66_2 = var_66_1.network_transmit
		local var_66_3 = Managers.player.is_server
		local var_66_4 = var_66_1:unit_game_object_id(arg_66_2)

		if var_66_3 then
			var_66_2:send_rpc_clients("rpc_play_husk_unit_sound_event", var_66_4, arg_66_3, var_66_0)
		else
			var_66_2:send_rpc_server("rpc_play_husk_unit_sound_event", var_66_4, arg_66_3, var_66_0)
		end
	end
end

PlayerUnitFirstPerson.play_camera_effect_sequence = function (arg_67_0, arg_67_1, arg_67_2)
	Managers.state.camera:camera_effect_sequence_event(arg_67_1, arg_67_2)
end

PlayerUnitFirstPerson.set_aim_assist = function (arg_68_0, arg_68_1)
	if arg_68_1 == "" then
		arg_68_0.aim_assist_type = arg_68_1
	end
end

PlayerUnitFirstPerson.enable_rig_movement = function (arg_69_0)
	if script_data.disable_aim_lead_rig_motion then
		arg_69_0:disable_rig_movement()

		return
	end

	if not arg_69_0._rig_movement_enabled then
		arg_69_0._rig_movement_enabled = true

		Unit.animation_event(arg_69_0.first_person_unit, "activate_aim")
	end
end

PlayerUnitFirstPerson.disable_rig_movement = function (arg_70_0)
	if arg_70_0._rig_movement_enabled then
		arg_70_0._rig_movement_enabled = false

		Unit.animation_event(arg_70_0.first_person_unit, "deactivate_aim")
	end
end

PlayerUnitFirstPerson.enable_rig_offset = function (arg_71_0)
	if script_data.disable_aim_lead_rig_motion then
		arg_71_0:disable_rig_offset()

		return
	end

	if not arg_71_0._rig_offset_enabled then
		arg_71_0._rig_offset_enabled = true
	end
end

PlayerUnitFirstPerson.disable_rig_offset = function (arg_72_0)
	if arg_72_0._rig_offset_enabled then
		arg_72_0._rig_offset_enabled = false
	end
end

PlayerUnitFirstPerson.update_rig_movement = function (arg_73_0, arg_73_1)
	if script_data.disable_aim_lead_rig_motion then
		return
	end

	if not arg_73_0._aim_target_index then
		return
	end

	local var_73_0 = arg_73_0._rig_update_timestep
	local var_73_1 = arg_73_0.inventory_extension:get_wielded_slot_name()
	local var_73_2 = var_73_1 == "slot_ranged"
	local var_73_3 = not var_73_2
	local var_73_4 = arg_73_0.inventory_extension:get_item_data(var_73_1)
	local var_73_5 = var_73_4 and var_73_4.template
	local var_73_6 = WeaponUtils.get_weapon_template(var_73_5)
	local var_73_7 = Unit.local_position(arg_73_0.first_person_unit, 0)
	local var_73_8 = Unit.local_rotation(arg_73_0.first_person_unit, 0)
	local var_73_9 = Quaternion.forward(var_73_8)
	local var_73_10 = Quaternion.right(var_73_8)
	local var_73_11 = Quaternion.up(var_73_8)
	local var_73_12 = PlayerUnitMovementSettings.rig_movement
	local var_73_13 = var_73_12.mass
	local var_73_14 = var_73_12.tension
	local var_73_15 = var_73_12.damping
	local var_73_16 = var_73_12.motion_offset
	local var_73_17 = var_73_12.horizontal_motion_damping
	local var_73_18 = var_73_12.vertical_motion_damping
	local var_73_19 = var_73_2 and var_73_12.vertical_look_multiplier_ranged or var_73_12.vertical_look_multiplier_melee
	local var_73_20 = Vector3(10, 10, 0)
	local var_73_21 = 10
	local var_73_22 = Vector2(0.1, 0.1)

	if var_73_2 then
		var_73_20 = Vector3(5, 5, 0)
		var_73_21 = 4
		var_73_22 = Vector2(0.5, 0.5)
	end

	local var_73_23 = var_73_20 * (var_73_6 and var_73_6.rig_motion_multiplier or 1)
	local var_73_24 = var_73_21 * (var_73_6 and var_73_6.rig_motion_multiplier or 1)
	local var_73_25 = var_73_22 * (var_73_6 and var_73_6.rig_motion_multiplier or 1)
	local var_73_26 = 1 / var_73_13

	arg_73_0.spring_velocity = arg_73_0.spring_velocity or Vector3Box(0, 0, 0)
	arg_73_0.spring_position = arg_73_0.spring_position or Vector3Box(var_73_7)
	arg_73_0.lead_offset = arg_73_0.lead_offset or Vector3Box(0, 0, 0)

	local var_73_27 = arg_73_0.spring_velocity:unbox()
	local var_73_28 = arg_73_0.spring_position:unbox()
	local var_73_29 = arg_73_0.lead_offset:unbox()

	if arg_73_1 then
		var_73_29 = Vector3.lerp(var_73_29, Vector3.multiply_elements(arg_73_1, var_73_23), var_73_0)
	end

	local var_73_30 = Vector3.max(Vector3.min(var_73_25, var_73_29), -var_73_25)
	local var_73_31 = Vector3.lerp(var_73_30, Vector3.zero(), math.min(var_73_0 * var_73_24, 1))
	local var_73_32 = var_73_28 + var_73_27 * var_73_0
	local var_73_33 = var_73_32 - var_73_7
	local var_73_34 = var_73_27 - var_73_26 * var_73_14 * var_73_33 * var_73_0

	if Vector3.length(var_73_33) >= 0.5 and arg_73_0._state == "falling" then
		var_73_15 = var_73_15 / 10
	end

	local var_73_35 = 0.5 * var_73_13 * Vector3.length_squared(var_73_34) * var_73_15
	local var_73_36 = math.sqrt(var_73_35 / (0.5 * var_73_13))
	local var_73_37 = var_73_34 - Vector3.normalize(var_73_34) * var_73_36 * var_73_0

	if var_73_3 then
		var_73_32 = var_73_32 - var_73_10 * var_73_31.x + var_73_11 * var_73_31.y
	end

	local var_73_38 = var_73_32
	local var_73_39 = var_73_38 - var_73_10 * Vector3.dot(var_73_10, var_73_38 - var_73_7) * var_73_17
	local var_73_40 = var_73_39 - var_73_11 * Vector3.dot(var_73_11, var_73_39 - var_73_7) * var_73_18
	local var_73_41 = Vector3.dot(var_73_9, Vector3.up())
	local var_73_42 = var_73_40 + var_73_9 * var_73_16 - var_73_11 * var_73_41 * var_73_19

	if not var_73_3 then
		var_73_42 = var_73_42 + var_73_10 * var_73_31.x + var_73_11 * var_73_31.y
	end

	arg_73_0.spring_position:store(var_73_32)
	arg_73_0.spring_velocity:store(var_73_37)
	arg_73_0.lead_offset:store(var_73_31)

	if script_data.debug_rig_motion then
		local var_73_43 = Unit.world_position(arg_73_0.first_person_unit, Unit.node(arg_73_0.first_person_unit, "j_aim_target"))

		QuickDrawer:sphere(var_73_43 - var_73_9 * 3, 0.1, Color(255, 255, 255))
		QuickDrawer:sphere(var_73_32 + var_73_9 * Vector3.length(var_73_32 - (var_73_43 - var_73_9 * 3)), 0.1, Color(255, 0, 0))
		QuickDrawer:sphere(var_73_42 + var_73_9 * Vector3.length(var_73_42 - (var_73_43 - var_73_9 * 3)), 0.1, Color(0, 255, 0))
	end

	if arg_73_0._rig_offset_enabled then
		Managers.state.camera:set_offset(var_73_31.x, 0, 0)
	end

	Unit.animation_set_constraint_target(arg_73_0.first_person_unit, arg_73_0._aim_target_index, var_73_42)
end

PlayerUnitFirstPerson.change_state = function (arg_74_0, arg_74_1)
	arg_74_0._state = arg_74_1
end

PlayerUnitFirstPerson.play_camera_recoil = function (arg_75_0, arg_75_1, arg_75_2)
	if arg_75_0._current_recoil_data then
		Managers.state.camera:stop_weapon_recoil(arg_75_0._current_recoil_data)

		arg_75_0._current_recoil_data = nil
	end

	local var_75_0 = {
		vertical_climb = arg_75_1.vertical_climb,
		horizontal_climb = arg_75_1.horizontal_climb,
		climb_start_time = arg_75_2,
		climb_end_time = arg_75_2 + arg_75_1.climb_duration,
		restore_start_time = arg_75_2 + arg_75_1.climb_duration,
		restore_end_time = arg_75_2 + arg_75_1.climb_duration + arg_75_1.restore_duration,
		climb_function = arg_75_1.climb_function,
		restore_function = arg_75_1.restore_function
	}

	arg_75_0._current_recoil_data = Managers.state.camera:weapon_recoil(var_75_0)
end

local var_0_9 = {
	vs_packmaster = {
		5,
		5,
		5
	},
	vs_gutter_runner = {
		5,
		5,
		5
	},
	vs_poison_wind_globadier = {
		5,
		5,
		5
	},
	vs_warpfire_thrower = {
		5,
		5,
		5
	},
	vs_ratling_gunner = {
		5,
		5,
		5
	},
	vs_chaos_troll = {
		5,
		5,
		5
	},
	vs_rat_ogre = {
		5,
		5,
		5
	}
}
local var_0_10 = math.min
local var_0_11 = math.max
local var_0_12 = math.lerp
local var_0_13 = math.clamp

function bi_clamp(arg_76_0, arg_76_1, arg_76_2)
	if arg_76_2 < arg_76_1 then
		return var_0_11(arg_76_2, var_0_10(arg_76_1, arg_76_0))
	else
		return var_0_11(arg_76_1, var_0_10(arg_76_2, arg_76_0))
	end
end

PlayerUnitFirstPerson._update_state_machine_variables = function (arg_77_0, arg_77_1, arg_77_2)
	local var_77_0 = arg_77_0._weapon_sway_settings or var_0_5
	local var_77_1 = arg_77_0.input_extension
	local var_77_2 = var_77_1:get("look_raw_controller") or Vector3(0, 0, 0)
	local var_77_3 = var_77_1:get("look_raw") or Vector3(0, 0, 0)
	local var_77_4 = Vector3(var_77_3.x * var_0_4, -var_77_3.y * var_0_4, 0) + var_77_2 * arg_77_1
	local var_77_5 = arg_77_0._look_target_x + var_77_4.x * var_77_0.look_sensitivity
	local var_77_6 = arg_77_0._look_target_y + var_77_4.y * var_77_0.look_sensitivity
	local var_77_7 = var_0_10(var_77_0.lerp_speed * arg_77_1, 1)
	local var_77_8 = var_0_12(arg_77_0._look_delta_x, var_77_5, var_77_7)
	local var_77_9 = var_0_12(arg_77_0._look_delta_y, var_77_6, var_77_7)
	local var_77_10 = var_77_0.sway_range
	local var_77_11 = var_0_13(var_77_8, -var_77_10, var_77_10)
	local var_77_12 = var_0_13(var_77_9, -var_77_10, var_77_10)

	arg_77_0._look_delta_x = var_77_11
	arg_77_0._look_delta_y = var_77_12

	arg_77_0:animation_set_variable("look_delta_x", var_77_11)
	arg_77_0:animation_set_variable("look_delta_y", var_77_12)

	local var_77_13 = arg_77_0.look_rotation:unbox()
	local var_77_14 = math.clamp(Quaternion.pitch(var_77_13) / arg_77_0.MAX_MIN_PITCH, -1, 1)

	arg_77_0:animation_set_variable("world_look_delta_y", var_77_14)

	if var_77_0.recenter_acc then
		local var_77_15 = var_77_0.recenter_acc
		local var_77_16 = var_77_0.recetner_dampening or 1
		local var_77_17 = var_77_0.recenter_max_vel or 10
		local var_77_18 = arg_77_0._look_target_recentering_vel_x or 0
		local var_77_19 = arg_77_0._look_target_recentering_vel_y or 0
		local var_77_20 = var_77_18 - bi_clamp(var_77_18 * var_77_16 * arg_77_1, -var_77_18, var_77_18)
		local var_77_21 = var_77_19 - bi_clamp(var_77_19 * var_77_16 * arg_77_1, -var_77_19, var_77_19)
		local var_77_22 = var_77_20 + var_77_4.x * var_77_0.look_sensitivity
		local var_77_23 = var_77_21 + var_77_4.y * var_77_0.look_sensitivity
		local var_77_24 = var_0_13(var_77_22 - var_77_5 * var_77_15 * arg_77_1, -var_77_17, var_77_17)
		local var_77_25 = var_0_13(var_77_23 - var_77_6 * var_77_15 * arg_77_1, -var_77_17, var_77_17)

		arg_77_0._look_target_recentering_vel_x = var_77_24
		arg_77_0._look_target_recentering_vel_y = var_77_25
		arg_77_0._look_target_x = var_0_13(var_77_5 + var_77_24 * arg_77_1, -var_77_10, var_77_10)
		arg_77_0._look_target_y = var_0_13(var_77_6 + var_77_25 * arg_77_1, -var_77_10, var_77_10)
	else
		local var_77_26 = var_0_10((var_77_0.recentering_lerp_speed or 2) * arg_77_1, 1)

		arg_77_0._look_target_x = var_0_13(var_0_12(var_77_5, 0, var_77_26), -var_77_10, var_77_10)
		arg_77_0._look_target_y = var_0_13(var_0_12(var_77_6, 0, var_77_26), -var_77_10, var_77_10)
	end

	local var_77_27 = Vector3.normalize(var_77_3 + var_77_2)
	local var_77_28 = math.round(2 * var_77_27.x) * 0.5
	local var_77_29 = math.round(2 * var_77_27.y) * 0.5
	local var_77_30 = arg_77_0.locomotion_extension:current_velocity().z
	local var_77_31 = arg_77_0.profile.display_name
	local var_77_32 = 5
	local var_77_33 = 5
	local var_77_34 = 5
	local var_77_35 = var_0_9[var_77_31]

	if var_77_35 then
		var_77_32 = var_77_35[1]
		var_77_33 = var_77_35[2]
		var_77_34 = var_77_35[3]
	end

	if var_77_28 <= 0.3 then
		var_77_32 = 7.5
	end

	if var_77_29 <= 0.3 then
		var_77_33 = 7.5
	end

	if var_77_30 <= 0.3 then
		var_77_34 = 7.5
	end

	local var_77_36 = math.clamp(math.lerp(arg_77_0._move_x, var_77_28, var_77_32 * arg_77_1), -1, 1)
	local var_77_37 = math.clamp(math.lerp(arg_77_0._move_y, var_77_36, var_77_33 * arg_77_1), -1, 1)
	local var_77_38 = math.clamp(math.lerp(arg_77_0._move_z, var_77_30, var_77_34 * arg_77_1), -1, 1)

	arg_77_0._move_y = var_77_36
	arg_77_0._move_x = var_77_37
	arg_77_0._move_z = var_77_38

	arg_77_0:animation_set_variable("move_x", var_77_37)
	arg_77_0:animation_set_variable("move_y", var_77_36)
	arg_77_0:animation_set_variable("move_z", var_77_38)
end
