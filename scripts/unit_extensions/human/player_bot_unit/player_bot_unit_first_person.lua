-- chunkname: @scripts/unit_extensions/human/player_bot_unit/player_bot_unit_first_person.lua

PlayerBotUnitFirstPerson = class(PlayerBotUnitFirstPerson)

PlayerBotUnitFirstPerson.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.unit = arg_1_2
	self.world = arg_1_1.world

	local profile = arg_1_3.profile

	self.profile = profile

	local num = 1
	local var_1_2 = profile.careers[num]
	local first_person_bot = profile.base_units.first_person_bot
	local skin_name = arg_1_3.skin_name
	local first_person_attachment = Cosmetics[skin_name].first_person_attachment

	first_person_attachment = first_person_attachment or profile.first_person_attachment

	local unit = first_person_attachment.unit
	local attachment_node_linking = first_person_attachment.attachment_node_linking
	local unit_spawner = Managers.state.unit_spawner
	local spawn_local_unit = unit_spawner:spawn_local_unit(first_person_bot)

	self.first_person_unit = spawn_local_unit
	self.first_person_attachment_unit = unit_spawner:spawn_local_unit(unit)

	local default_state_machine = profile.default_state_machine

	if not default_state_machine then
		Unit.set_animation_state_machine(spawn_local_unit, default_state_machine)
	end

	Unit.set_flow_variable(spawn_local_unit, "character_vo", profile.character_vo)
	Unit.set_flow_variable(spawn_local_unit, "sound_character", var_1_2.sound_character)
	Unit.set_flow_variable(spawn_local_unit, "is_bot", true)
	Unit.flow_event(spawn_local_unit, "character_vo_set")
	AttachmentUtils.link(arg_1_1.world, spawn_local_unit, self.first_person_attachment_unit, attachment_node_linking)

	self.look_rotation = QuaternionBox(Unit.local_rotation(arg_1_2, 0))

	Unit.set_local_position(spawn_local_unit, 0, Unit.local_position(arg_1_2, 0))
	Unit.set_local_rotation(spawn_local_unit, 0, Unit.local_rotation(arg_1_2, 0))

	self.player_height_wanted = self:_player_height_from_name("stand")
	self.player_height_current = self.player_height_wanted
	self.player_height_previous = self.player_height_wanted
	self.player_height_time_to_change = 0
	self.player_height_change_start_time = 0
	self.has_look_delta = false
	self.look_delta = Vector3Box()

	local num_2 = math.pi / 15

	self.MAX_MIN_PITCH = math.pi / 2 - num_2
	self.drawer = Managers.state.debug:drawer({
		mode = "immediate",
		name = "PlayerBotUnitFirstPerson"
	})

	if not Development.parameter("attract_mode") then
		Unit.animation_event(self.first_person_unit, "enable_headbob")
	end
end

PlayerBotUnitFirstPerson.reset = function (arg_2_0)
	-- function 2
	return
end

PlayerBotUnitFirstPerson.extensions_ready = function (self)
	-- function 3
	self.locomotion_extension = ScriptUnit.extension(self.unit, "locomotion_system")
	self.inventory_extension = ScriptUnit.extension(self.unit, "inventory_system")
	self.attachment_extension = ScriptUnit.extension(self.unit, "attachment_system")
	self.cosmetic_extension = ScriptUnit.extension(self.unit, "cosmetic_system")

	self:set_first_person_mode(true)
end

PlayerBotUnitFirstPerson.destroy = function (self)
	-- function 4
	AttachmentUtils.unlink(self.world, self.first_person_attachment_unit)

	local unit_spawner = Managers.state.unit_spawner

	unit_spawner:mark_for_deletion(self.first_person_unit)
	unit_spawner:mark_for_deletion(self.first_person_attachment_unit)
end

PlayerBotUnitFirstPerson.set_state_machine = function (arg_5_0, arg_5_1)
	-- function 5
	return
end

local function fn(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	arg_6_0 = arg_6_0 / arg_6_3

	return -arg_6_2 * arg_6_0 * (arg_6_0 - 2) + arg_6_1
end

PlayerBotUnitFirstPerson.update_player_height = function (self, arg_7_1)
	-- function 7
	local num = arg_7_1 - self.player_height_change_start_time

	if num < self.player_height_time_to_change then
		self.player_height_current = fn(num, self.player_height_previous, self.player_height_wanted - self.player_height_previous, self.player_height_time_to_change)
	else
		self.player_height_current = self.player_height_wanted
	end

	if not script_data.camera_debug then
		Debug.text("self.player_height_wanted = " .. tostring(self.player_height_wanted))
		Debug.text("self.player_height_current = " .. tostring(self.player_height_current))
		Debug.text("self.player_height_previous = " .. tostring(self.player_height_previous))
		Debug.text("self.player_height_time_to_change = " .. tostring(self.player_height_time_to_change))
		Debug.text("self.player_height_change_start_time = " .. tostring(self.player_height_change_start_time))
		Debug.text("time_changing_height = " .. tostring(num))
	end
end

PlayerBotUnitFirstPerson._player_height_from_name = function (self, arg_8_1)
	-- function 8
	return self.profile.first_person_heights[arg_8_1]
end

PlayerBotUnitFirstPerson.update = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	-- function 9
	self:update_player_height(arg_9_5)
	self:update_rotation(arg_9_5, arg_9_3)
	self:update_position()
end

PlayerBotUnitFirstPerson.update_rotation = function (self, arg_10_1, arg_10_2)
	-- function 10
	if not self.has_look_delta then
		local unbox = self.look_rotation:unbox()
		local unbox_2 = self.look_delta:unbox()

		self.has_look_delta = false

		local num = Quaternion.yaw(unbox) - unbox_2.x
		local clamp = math.clamp(Quaternion.pitch(unbox) + unbox_2.y, -self.MAX_MIN_PITCH, self.MAX_MIN_PITCH)
		local var_10_4 = Quaternion(Vector3.up(), num)
		local var_10_5 = Quaternion(Vector3.right(), clamp)
		local multiply = Quaternion.multiply(var_10_4, var_10_5)

		self.look_rotation:store(multiply)

		local first_person_unit = self.first_person_unit

		Unit.set_local_rotation(first_person_unit, 0, multiply)
	end
end

PlayerBotUnitFirstPerson.update_position = function (self)
	-- function 11
	local num = Unit.local_position(self.unit, 0) + Vector3(0, 0, self.player_height_current)

	Unit.set_local_position(self.first_person_unit, 0, num)
end

PlayerBotUnitFirstPerson.apply_recoil = function (arg_12_0)
	-- function 12
	return
end

PlayerBotUnitFirstPerson.get_first_person_unit = function (self)
	-- function 13
	return self.first_person_unit
end

PlayerBotUnitFirstPerson.get_first_person_mesh_unit = function (self)
	-- function 14
	return self.first_person_attachment_unit
end

PlayerBotUnitFirstPerson.set_look_delta = function (self, arg_15_1)
	-- function 15
	self.has_look_delta = true

	Vector3Box.store(self.look_delta, arg_15_1)
end

PlayerBotUnitFirstPerson.play_animation_event = function (self, arg_16_1)
	-- function 16
	Unit.animation_event(self.first_person_unit, arg_16_1)
end

PlayerBotUnitFirstPerson.current_position = function (self)
	-- function 17
	return Unit.local_position(self.first_person_unit, 0)
end

PlayerBotUnitFirstPerson.current_rotation = function (self)
	-- function 18
	return Unit.local_rotation(self.first_person_unit, 0)
end

PlayerBotUnitFirstPerson.current_camera_position = function (self)
	-- function 19
	return Unit.local_position(self.first_person_unit, 0)
end

PlayerBotUnitFirstPerson.camera_position_rotation = function (self)
	-- function 20
	local local_position = Unit.local_position(self.first_person_unit, 0)
	local local_rotation = Unit.local_rotation(self.first_person_unit, 0)

	return local_position, local_rotation
end

PlayerBotUnitFirstPerson.get_projectile_start_position_rotation = function (self)
	-- function 21
	local current_position = self:current_position()
	local current_rotation = self:current_rotation()

	return current_position, current_rotation
end

PlayerBotUnitFirstPerson.set_rotation = function (self, arg_22_1)
	-- function 22
	Unit.set_local_rotation(self.first_person_unit, 0, arg_22_1)
	Unit.set_local_rotation(self.unit, 0, arg_22_1)
	self.look_rotation:store(arg_22_1)
end

PlayerBotUnitFirstPerson.force_look_rotation = function (arg_23_0)
	-- function 23
	return
end

PlayerBotUnitFirstPerson.stop_force_look_rotation = function (arg_24_0)
	-- function 24
	return
end

PlayerBotUnitFirstPerson.set_wanted_player_height = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	-- function 25
	return
end

PlayerBotUnitFirstPerson.set_weapon_sway_settings = function (arg_26_0)
	-- function 26
	return
end

PlayerBotUnitFirstPerson.toggle_visibility = function (self)
	-- function 27
	self:set_first_person_mode(not self.first_person_mode)
end

PlayerBotUnitFirstPerson.set_first_person_mode = function (self, arg_28_1)
	-- function 28
	self.first_person_mode = arg_28_1

	if not self.first_person_debug then
		Unit.set_unit_visibility(self.unit, true)
		Unit.set_unit_visibility(self.first_person_attachment_unit, false)
		self.inventory_extension:show_first_person_inventory(false)
		self.inventory_extension:show_first_person_inventory_lights(false)
		self.inventory_extension:show_third_person_inventory(true)
		self.attachment_extension:show_attachments(true)
		self.cosmetic_extension:show_third_person_mesh(true)
	end
end

PlayerBotUnitFirstPerson.debug_set_first_person_mode = function (self, arg_29_1, arg_29_2)
	-- function 29
	if not arg_29_1 then
		Unit.set_unit_visibility(self.unit, not arg_29_2)
		Unit.set_unit_visibility(self.first_person_attachment_unit, arg_29_2)
		self.inventory_extension:show_first_person_inventory(arg_29_2)
		self.inventory_extension:show_first_person_inventory_lights(arg_29_2)
		self.inventory_extension:show_third_person_inventory(not arg_29_2)
		self.attachment_extension:show_attachments(not arg_29_2)
		self.cosmetic_extension:show_third_person_mesh(not arg_29_2)

		self.first_person_debug = true
	else
		self.first_person_debug = false

		self:set_first_person_mode(self.first_person_mode)
	end
end

PlayerBotUnitFirstPerson.hide_weapons = function (arg_30_0)
	-- function 30
	return
end

PlayerBotUnitFirstPerson.unhide_weapons = function (arg_31_0)
	-- function 31
	return
end

PlayerBotUnitFirstPerson.show_first_person_ammo = function (arg_32_0, arg_32_1)
	-- function 32
	return
end

PlayerBotUnitFirstPerson.animation_set_variable = function (self, arg_33_1, arg_33_2)
	-- function 33
	if not self.first_person_debug then
		local animation_find_variable = Unit.animation_find_variable(self.first_person_unit, arg_33_1)

		Unit.animation_set_variable(self.first_person_unit, animation_find_variable, arg_33_2)
	end
end

PlayerBotUnitFirstPerson.animation_event = function (self, arg_34_1)
	-- function 34
	if not self.first_person_debug then
		Unit.animation_event(self.first_person_unit, arg_34_1)
	end
end

PlayerBotUnitFirstPerson.increase_aim_assist_multiplier = function (arg_35_0)
	-- function 35
	return
end

PlayerBotUnitFirstPerson.reset_aim_assist_multiplier = function (arg_36_0)
	-- function 36
	return
end

PlayerBotUnitFirstPerson.is_in_view = function (arg_37_0, arg_37_1)
	-- function 37
	return true
end

PlayerBotUnitFirstPerson.is_within_custom_view = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5)
	-- function 38
	return true
end

PlayerBotUnitFirstPerson.is_within_default_view = function (arg_39_0, arg_39_1)
	-- function 39
	return true
end

PlayerBotUnitFirstPerson.create_screen_particles = function (arg_40_0, ...)
	-- function 40
	return
end

PlayerBotUnitFirstPerson.stop_spawning_screen_particles = function (arg_41_0, ...)
	-- function 41
	return
end

PlayerBotUnitFirstPerson.destroy_screen_particles = function (arg_42_0, ...)
	-- function 42
	return
end

PlayerBotUnitFirstPerson.play_hud_sound_event = function (self, arg_43_1, arg_43_2, arg_43_3)
	-- function 43
	self:play_remote_hud_sound_event(arg_43_1, arg_43_2, arg_43_3)
end

PlayerBotUnitFirstPerson.play_remote_hud_sound_event = function (self, arg_44_1, arg_44_2, arg_44_3)
	-- function 44
	if not (not arg_44_3 and LEVEL_EDITOR_TEST) then
		self:play_sound_event(arg_44_1)

		local network = Managers.state.network
		local network_transmit = network.network_transmit
		local unit_game_object_id = network:unit_game_object_id(self.unit)
		local var_44_3 = NetworkLookup.sound_events[arg_44_1]

		network_transmit:send_rpc_clients("rpc_play_husk_sound_event", unit_game_object_id, var_44_3)
	end
end

PlayerBotUnitFirstPerson.play_sound_event = function (self, arg_45_1, arg_45_2)
	-- function 45
	local flag = arg_45_2 or self:current_position()
	local make_position_auto_source, var_45_2 = WwiseUtils.make_position_auto_source(self.world, flag)

	WwiseWorld.set_switch(var_45_2, "husk", "true", make_position_auto_source)
	WwiseWorld.trigger_event(var_45_2, arg_45_1, make_position_auto_source)
end

PlayerBotUnitFirstPerson.play_unit_sound_event = function (self, arg_46_1, arg_46_2, arg_46_3, arg_46_4)
	-- function 46
	if not arg_46_4 then
		local var_46_0 = NetworkLookup.sound_events[arg_46_1]
		local network = Managers.state.network

		if not (not network:game() and LEVEL_EDITOR_TEST) then
			local network_transmit = network.network_transmit
			local is_server = Managers.player.is_server
			local unit_game_object_id = network:unit_game_object_id(arg_46_2)

			if not is_server then
				network_transmit:send_rpc_clients("rpc_play_husk_unit_sound_event", unit_game_object_id, arg_46_3, var_46_0)
			else
				network_transmit:send_rpc_server("rpc_play_husk_unit_sound_event", unit_game_object_id, arg_46_3, var_46_0)
			end
		end
	end

	local make_unit_auto_source, var_46_6 = WwiseUtils.make_unit_auto_source(self.world, arg_46_2, arg_46_3)

	WwiseWorld.set_switch(var_46_6, "husk", "true", make_unit_auto_source)
	WwiseWorld.trigger_event(var_46_6, arg_46_1, make_unit_auto_source)
end

PlayerBotUnitFirstPerson.play_remote_unit_sound_event = function (self, arg_47_1, arg_47_2, arg_47_3)
	-- function 47
	self:play_unit_sound_event(arg_47_1, arg_47_2, arg_47_3, true)
end

PlayerBotUnitFirstPerson.first_person_mode_active = function (self)
	-- function 48
	return self.first_person_debug
end

PlayerBotUnitFirstPerson.play_camera_effect_sequence = function (arg_49_0, arg_49_1, arg_49_2)
	-- function 49
	return
end

PlayerBotUnitFirstPerson.enable_rig_movement = function (arg_50_0)
	-- function 50
	return
end

PlayerBotUnitFirstPerson.disable_rig_movement = function (arg_51_0)
	-- function 51
	return
end

PlayerBotUnitFirstPerson.enable_rig_offset = function (arg_52_0)
	-- function 52
	return
end

PlayerBotUnitFirstPerson.disable_rig_offset = function (arg_53_0)
	-- function 53
	return
end

PlayerBotUnitFirstPerson.change_state = function (arg_54_0, arg_54_1)
	-- function 54
	return
end

PlayerBotUnitFirstPerson.play_camera_effect_sequence = function (arg_55_0)
	-- function 55
	return
end

PlayerBotUnitFirstPerson.play_camera_recoil = function (arg_56_0)
	-- function 56
	return
end
