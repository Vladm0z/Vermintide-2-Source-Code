-- chunkname: @scripts/unit_extensions/human/player_bot_unit/player_bot_unit_first_person.lua

PlayerBotUnitFirstPerson = class(PlayerBotUnitFirstPerson)

PlayerBotUnitFirstPerson.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.unit = arg_1_2
	arg_1_0.world = arg_1_1.world

	local var_1_0 = arg_1_3.profile

	arg_1_0.profile = var_1_0

	local var_1_1 = 1
	local var_1_2 = var_1_0.careers[var_1_1]
	local var_1_3 = var_1_0.base_units.first_person_bot
	local var_1_4 = arg_1_3.skin_name
	local var_1_5 = Cosmetics[var_1_4].first_person_attachment or var_1_0.first_person_attachment
	local var_1_6 = var_1_5.unit
	local var_1_7 = var_1_5.attachment_node_linking
	local var_1_8 = Managers.state.unit_spawner
	local var_1_9 = var_1_8:spawn_local_unit(var_1_3)

	arg_1_0.first_person_unit = var_1_9
	arg_1_0.first_person_attachment_unit = var_1_8:spawn_local_unit(var_1_6)

	local var_1_10 = var_1_0.default_state_machine

	if var_1_10 then
		Unit.set_animation_state_machine(var_1_9, var_1_10)
	end

	Unit.set_flow_variable(var_1_9, "character_vo", var_1_0.character_vo)
	Unit.set_flow_variable(var_1_9, "sound_character", var_1_2.sound_character)
	Unit.set_flow_variable(var_1_9, "is_bot", true)
	Unit.flow_event(var_1_9, "character_vo_set")
	AttachmentUtils.link(arg_1_1.world, var_1_9, arg_1_0.first_person_attachment_unit, var_1_7)

	arg_1_0.look_rotation = QuaternionBox(Unit.local_rotation(arg_1_2, 0))

	Unit.set_local_position(var_1_9, 0, Unit.local_position(arg_1_2, 0))
	Unit.set_local_rotation(var_1_9, 0, Unit.local_rotation(arg_1_2, 0))

	arg_1_0.player_height_wanted = arg_1_0:_player_height_from_name("stand")
	arg_1_0.player_height_current = arg_1_0.player_height_wanted
	arg_1_0.player_height_previous = arg_1_0.player_height_wanted
	arg_1_0.player_height_time_to_change = 0
	arg_1_0.player_height_change_start_time = 0
	arg_1_0.has_look_delta = false
	arg_1_0.look_delta = Vector3Box()

	local var_1_11 = math.pi / 15

	arg_1_0.MAX_MIN_PITCH = math.pi / 2 - var_1_11
	arg_1_0.drawer = Managers.state.debug:drawer({
		mode = "immediate",
		name = "PlayerBotUnitFirstPerson"
	})

	if Development.parameter("attract_mode") then
		Unit.animation_event(arg_1_0.first_person_unit, "enable_headbob")
	end
end

PlayerBotUnitFirstPerson.reset = function (arg_2_0)
	return
end

PlayerBotUnitFirstPerson.extensions_ready = function (arg_3_0)
	arg_3_0.locomotion_extension = ScriptUnit.extension(arg_3_0.unit, "locomotion_system")
	arg_3_0.inventory_extension = ScriptUnit.extension(arg_3_0.unit, "inventory_system")
	arg_3_0.attachment_extension = ScriptUnit.extension(arg_3_0.unit, "attachment_system")
	arg_3_0.cosmetic_extension = ScriptUnit.extension(arg_3_0.unit, "cosmetic_system")

	arg_3_0:set_first_person_mode(true)
end

PlayerBotUnitFirstPerson.destroy = function (arg_4_0)
	AttachmentUtils.unlink(arg_4_0.world, arg_4_0.first_person_attachment_unit)

	local var_4_0 = Managers.state.unit_spawner

	var_4_0:mark_for_deletion(arg_4_0.first_person_unit)
	var_4_0:mark_for_deletion(arg_4_0.first_person_attachment_unit)
end

PlayerBotUnitFirstPerson.set_state_machine = function (arg_5_0, arg_5_1)
	return
end

local function var_0_0(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_0 = arg_6_0 / arg_6_3

	return -arg_6_2 * arg_6_0 * (arg_6_0 - 2) + arg_6_1
end

PlayerBotUnitFirstPerson.update_player_height = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1 - arg_7_0.player_height_change_start_time

	if var_7_0 < arg_7_0.player_height_time_to_change then
		arg_7_0.player_height_current = var_0_0(var_7_0, arg_7_0.player_height_previous, arg_7_0.player_height_wanted - arg_7_0.player_height_previous, arg_7_0.player_height_time_to_change)
	else
		arg_7_0.player_height_current = arg_7_0.player_height_wanted
	end

	if script_data.camera_debug then
		Debug.text("self.player_height_wanted = " .. tostring(arg_7_0.player_height_wanted))
		Debug.text("self.player_height_current = " .. tostring(arg_7_0.player_height_current))
		Debug.text("self.player_height_previous = " .. tostring(arg_7_0.player_height_previous))
		Debug.text("self.player_height_time_to_change = " .. tostring(arg_7_0.player_height_time_to_change))
		Debug.text("self.player_height_change_start_time = " .. tostring(arg_7_0.player_height_change_start_time))
		Debug.text("time_changing_height = " .. tostring(var_7_0))
	end
end

PlayerBotUnitFirstPerson._player_height_from_name = function (arg_8_0, arg_8_1)
	return arg_8_0.profile.first_person_heights[arg_8_1]
end

PlayerBotUnitFirstPerson.update = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	arg_9_0:update_player_height(arg_9_5)
	arg_9_0:update_rotation(arg_9_5, arg_9_3)
	arg_9_0:update_position()
end

PlayerBotUnitFirstPerson.update_rotation = function (arg_10_0, arg_10_1, arg_10_2)
	if arg_10_0.has_look_delta then
		local var_10_0 = arg_10_0.look_rotation:unbox()
		local var_10_1 = arg_10_0.look_delta:unbox()

		arg_10_0.has_look_delta = false

		local var_10_2 = Quaternion.yaw(var_10_0) - var_10_1.x
		local var_10_3 = math.clamp(Quaternion.pitch(var_10_0) + var_10_1.y, -arg_10_0.MAX_MIN_PITCH, arg_10_0.MAX_MIN_PITCH)
		local var_10_4 = Quaternion(Vector3.up(), var_10_2)
		local var_10_5 = Quaternion(Vector3.right(), var_10_3)
		local var_10_6 = Quaternion.multiply(var_10_4, var_10_5)

		arg_10_0.look_rotation:store(var_10_6)

		local var_10_7 = arg_10_0.first_person_unit

		Unit.set_local_rotation(var_10_7, 0, var_10_6)
	end
end

PlayerBotUnitFirstPerson.update_position = function (arg_11_0)
	local var_11_0 = Unit.local_position(arg_11_0.unit, 0) + Vector3(0, 0, arg_11_0.player_height_current)

	Unit.set_local_position(arg_11_0.first_person_unit, 0, var_11_0)
end

PlayerBotUnitFirstPerson.apply_recoil = function (arg_12_0)
	return
end

PlayerBotUnitFirstPerson.get_first_person_unit = function (arg_13_0)
	return arg_13_0.first_person_unit
end

PlayerBotUnitFirstPerson.get_first_person_mesh_unit = function (arg_14_0)
	return arg_14_0.first_person_attachment_unit
end

PlayerBotUnitFirstPerson.set_look_delta = function (arg_15_0, arg_15_1)
	arg_15_0.has_look_delta = true

	Vector3Box.store(arg_15_0.look_delta, arg_15_1)
end

PlayerBotUnitFirstPerson.play_animation_event = function (arg_16_0, arg_16_1)
	Unit.animation_event(arg_16_0.first_person_unit, arg_16_1)
end

PlayerBotUnitFirstPerson.current_position = function (arg_17_0)
	return Unit.local_position(arg_17_0.first_person_unit, 0)
end

PlayerBotUnitFirstPerson.current_rotation = function (arg_18_0)
	return Unit.local_rotation(arg_18_0.first_person_unit, 0)
end

PlayerBotUnitFirstPerson.current_camera_position = function (arg_19_0)
	return Unit.local_position(arg_19_0.first_person_unit, 0)
end

PlayerBotUnitFirstPerson.camera_position_rotation = function (arg_20_0)
	local var_20_0 = Unit.local_position(arg_20_0.first_person_unit, 0)
	local var_20_1 = Unit.local_rotation(arg_20_0.first_person_unit, 0)

	return var_20_0, var_20_1
end

PlayerBotUnitFirstPerson.get_projectile_start_position_rotation = function (arg_21_0)
	local var_21_0 = arg_21_0:current_position()
	local var_21_1 = arg_21_0:current_rotation()

	return var_21_0, var_21_1
end

PlayerBotUnitFirstPerson.set_rotation = function (arg_22_0, arg_22_1)
	Unit.set_local_rotation(arg_22_0.first_person_unit, 0, arg_22_1)
	Unit.set_local_rotation(arg_22_0.unit, 0, arg_22_1)
	arg_22_0.look_rotation:store(arg_22_1)
end

PlayerBotUnitFirstPerson.force_look_rotation = function (arg_23_0)
	return
end

PlayerBotUnitFirstPerson.stop_force_look_rotation = function (arg_24_0)
	return
end

PlayerBotUnitFirstPerson.set_wanted_player_height = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	return
end

PlayerBotUnitFirstPerson.set_weapon_sway_settings = function (arg_26_0)
	return
end

PlayerBotUnitFirstPerson.toggle_visibility = function (arg_27_0)
	arg_27_0:set_first_person_mode(not arg_27_0.first_person_mode)
end

PlayerBotUnitFirstPerson.set_first_person_mode = function (arg_28_0, arg_28_1)
	arg_28_0.first_person_mode = arg_28_1

	if not arg_28_0.first_person_debug then
		Unit.set_unit_visibility(arg_28_0.unit, true)
		Unit.set_unit_visibility(arg_28_0.first_person_attachment_unit, false)
		arg_28_0.inventory_extension:show_first_person_inventory(false)
		arg_28_0.inventory_extension:show_first_person_inventory_lights(false)
		arg_28_0.inventory_extension:show_third_person_inventory(true)
		arg_28_0.attachment_extension:show_attachments(true)
		arg_28_0.cosmetic_extension:show_third_person_mesh(true)
	end
end

PlayerBotUnitFirstPerson.debug_set_first_person_mode = function (arg_29_0, arg_29_1, arg_29_2)
	if arg_29_1 then
		Unit.set_unit_visibility(arg_29_0.unit, not arg_29_2)
		Unit.set_unit_visibility(arg_29_0.first_person_attachment_unit, arg_29_2)
		arg_29_0.inventory_extension:show_first_person_inventory(arg_29_2)
		arg_29_0.inventory_extension:show_first_person_inventory_lights(arg_29_2)
		arg_29_0.inventory_extension:show_third_person_inventory(not arg_29_2)
		arg_29_0.attachment_extension:show_attachments(not arg_29_2)
		arg_29_0.cosmetic_extension:show_third_person_mesh(not arg_29_2)

		arg_29_0.first_person_debug = true
	else
		arg_29_0.first_person_debug = false

		arg_29_0:set_first_person_mode(arg_29_0.first_person_mode)
	end
end

PlayerBotUnitFirstPerson.hide_weapons = function (arg_30_0)
	return
end

PlayerBotUnitFirstPerson.unhide_weapons = function (arg_31_0)
	return
end

PlayerBotUnitFirstPerson.show_first_person_ammo = function (arg_32_0, arg_32_1)
	return
end

PlayerBotUnitFirstPerson.animation_set_variable = function (arg_33_0, arg_33_1, arg_33_2)
	if arg_33_0.first_person_debug then
		local var_33_0 = Unit.animation_find_variable(arg_33_0.first_person_unit, arg_33_1)

		Unit.animation_set_variable(arg_33_0.first_person_unit, var_33_0, arg_33_2)
	end
end

PlayerBotUnitFirstPerson.animation_event = function (arg_34_0, arg_34_1)
	if arg_34_0.first_person_debug then
		Unit.animation_event(arg_34_0.first_person_unit, arg_34_1)
	end
end

PlayerBotUnitFirstPerson.increase_aim_assist_multiplier = function (arg_35_0)
	return
end

PlayerBotUnitFirstPerson.reset_aim_assist_multiplier = function (arg_36_0)
	return
end

PlayerBotUnitFirstPerson.is_in_view = function (arg_37_0, arg_37_1)
	return true
end

PlayerBotUnitFirstPerson.is_within_custom_view = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5)
	return true
end

PlayerBotUnitFirstPerson.is_within_default_view = function (arg_39_0, arg_39_1)
	return true
end

PlayerBotUnitFirstPerson.create_screen_particles = function (arg_40_0, ...)
	return
end

PlayerBotUnitFirstPerson.stop_spawning_screen_particles = function (arg_41_0, ...)
	return
end

PlayerBotUnitFirstPerson.destroy_screen_particles = function (arg_42_0, ...)
	return
end

PlayerBotUnitFirstPerson.play_hud_sound_event = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	arg_43_0:play_remote_hud_sound_event(arg_43_1, arg_43_2, arg_43_3)
end

PlayerBotUnitFirstPerson.play_remote_hud_sound_event = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	if arg_44_3 and not LEVEL_EDITOR_TEST then
		arg_44_0:play_sound_event(arg_44_1)

		local var_44_0 = Managers.state.network
		local var_44_1 = var_44_0.network_transmit
		local var_44_2 = var_44_0:unit_game_object_id(arg_44_0.unit)
		local var_44_3 = NetworkLookup.sound_events[arg_44_1]

		var_44_1:send_rpc_clients("rpc_play_husk_sound_event", var_44_2, var_44_3)
	end
end

PlayerBotUnitFirstPerson.play_sound_event = function (arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = arg_45_2 or arg_45_0:current_position()
	local var_45_1, var_45_2 = WwiseUtils.make_position_auto_source(arg_45_0.world, var_45_0)

	WwiseWorld.set_switch(var_45_2, "husk", "true", var_45_1)
	WwiseWorld.trigger_event(var_45_2, arg_45_1, var_45_1)
end

PlayerBotUnitFirstPerson.play_unit_sound_event = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4)
	if arg_46_4 then
		local var_46_0 = NetworkLookup.sound_events[arg_46_1]
		local var_46_1 = Managers.state.network

		if var_46_1:game() and not LEVEL_EDITOR_TEST then
			local var_46_2 = var_46_1.network_transmit
			local var_46_3 = Managers.player.is_server
			local var_46_4 = var_46_1:unit_game_object_id(arg_46_2)

			if var_46_3 then
				var_46_2:send_rpc_clients("rpc_play_husk_unit_sound_event", var_46_4, arg_46_3, var_46_0)
			else
				var_46_2:send_rpc_server("rpc_play_husk_unit_sound_event", var_46_4, arg_46_3, var_46_0)
			end
		end
	end

	local var_46_5, var_46_6 = WwiseUtils.make_unit_auto_source(arg_46_0.world, arg_46_2, arg_46_3)

	WwiseWorld.set_switch(var_46_6, "husk", "true", var_46_5)
	WwiseWorld.trigger_event(var_46_6, arg_46_1, var_46_5)
end

PlayerBotUnitFirstPerson.play_remote_unit_sound_event = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3)
	arg_47_0:play_unit_sound_event(arg_47_1, arg_47_2, arg_47_3, true)
end

PlayerBotUnitFirstPerson.first_person_mode_active = function (arg_48_0)
	return arg_48_0.first_person_debug
end

PlayerBotUnitFirstPerson.play_camera_effect_sequence = function (arg_49_0, arg_49_1, arg_49_2)
	return
end

PlayerBotUnitFirstPerson.enable_rig_movement = function (arg_50_0)
	return
end

PlayerBotUnitFirstPerson.disable_rig_movement = function (arg_51_0)
	return
end

PlayerBotUnitFirstPerson.enable_rig_offset = function (arg_52_0)
	return
end

PlayerBotUnitFirstPerson.disable_rig_offset = function (arg_53_0)
	return
end

PlayerBotUnitFirstPerson.change_state = function (arg_54_0, arg_54_1)
	return
end

PlayerBotUnitFirstPerson.play_camera_effect_sequence = function (arg_55_0)
	return
end

PlayerBotUnitFirstPerson.play_camera_recoil = function (arg_56_0)
	return
end
