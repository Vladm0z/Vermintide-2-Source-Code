-- chunkname: @scripts/unit_extensions/human/player_bot_unit/player_bot_unit_first_person.lua

PlayerBotUnitFirstPerson = class(PlayerBotUnitFirstPerson)

PlayerBotUnitFirstPerson.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	self.unit = unit
	self.world = extension_init_context.world

	local profile = extension_init_data.profile

	self.profile = profile

	local career_index = 1
	local career = profile.careers[career_index]
	local unit_name = profile.base_units.first_person_bot
	local skin_name = extension_init_data.skin_name
	local first_person_attachment = Cosmetics[skin_name].first_person_attachment
	local attachment_unit_name = first_person_attachment.unit
	local attachment_node_linking = first_person_attachment.attachment_node_linking
	local unit_spawner = Managers.state.unit_spawner
	local fp_unit = unit_spawner:spawn_local_unit(unit_name)

	self.first_person_unit = fp_unit
	self.first_person_attachment_unit = unit_spawner:spawn_local_unit(attachment_unit_name)

	local default_state_machine = profile.default_state_machine

	if default_state_machine then
		Unit.set_animation_state_machine(fp_unit, default_state_machine)
	end

	Unit.set_flow_variable(fp_unit, "character_vo", profile.character_vo)
	Unit.set_flow_variable(fp_unit, "sound_character", career.sound_character)
	Unit.set_flow_variable(fp_unit, "is_bot", true)
	Unit.flow_event(fp_unit, "character_vo_set")
	AttachmentUtils.link(extension_init_context.world, fp_unit, self.first_person_attachment_unit, attachment_node_linking)

	self.look_rotation = QuaternionBox(Unit.local_rotation(unit, 0))

	Unit.set_local_position(fp_unit, 0, Unit.local_position(unit, 0))
	Unit.set_local_rotation(fp_unit, 0, Unit.local_rotation(unit, 0))

	self.player_height_wanted = self:_player_height_from_name("stand")
	self.player_height_current = self.player_height_wanted
	self.player_height_previous = self.player_height_wanted
	self.player_height_time_to_change = 0
	self.player_height_change_start_time = 0
	self.has_look_delta = false
	self.look_delta = Vector3Box()

	local small_delta = math.pi / 15

	self.MAX_MIN_PITCH = math.pi / 2 - small_delta
	self.drawer = Managers.state.debug:drawer({
		mode = "immediate",
		name = "PlayerBotUnitFirstPerson"
	})

	if Development.parameter("attract_mode") then
		Unit.animation_event(self.first_person_unit, "enable_headbob")
	end
end

PlayerBotUnitFirstPerson.reset = function (self)
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

PlayerBotUnitFirstPerson.set_state_machine = function (self, new_state_machine)
	-- function 5
	return
end

local function ease_out_quad(t, b, c, d)
	-- function 6
	t = t / d

	local res = -c * t * (t - 2) + b

	return res
end

PlayerBotUnitFirstPerson.update_player_height = function (self, t)
	-- function 7
	local time_changing_height = t - self.player_height_change_start_time

	if time_changing_height < self.player_height_time_to_change then
		self.player_height_current = ease_out_quad(time_changing_height, self.player_height_previous, self.player_height_wanted - self.player_height_previous, self.player_height_time_to_change)
	else
		self.player_height_current = self.player_height_wanted
	end

	if script_data.camera_debug then
		Debug.text("self.player_height_wanted = " .. tostring(self.player_height_wanted))
		Debug.text("self.player_height_current = " .. tostring(self.player_height_current))
		Debug.text("self.player_height_previous = " .. tostring(self.player_height_previous))
		Debug.text("self.player_height_time_to_change = " .. tostring(self.player_height_time_to_change))
		Debug.text("self.player_height_change_start_time = " .. tostring(self.player_height_change_start_time))
		Debug.text("time_changing_height = " .. tostring(time_changing_height))
	end
end

PlayerBotUnitFirstPerson._player_height_from_name = function (self, name)
	-- function 8
	local profile = self.profile

	return profile.first_person_heights[name]
end

PlayerBotUnitFirstPerson.update = function (self, unit, input, dt, context, t)
	-- function 9
	self:update_player_height(t)
	self:update_rotation(t, dt)
	self:update_position()
end

PlayerBotUnitFirstPerson.update_rotation = function (self, t, dt)
	-- function 10
	if self.has_look_delta then
		local rotation = self.look_rotation:unbox()
		local look_delta = self.look_delta:unbox()

		self.has_look_delta = false

		local yaw = Quaternion.yaw(rotation) - look_delta.x
		local pitch = math.clamp(Quaternion.pitch(rotation) + look_delta.y, -self.MAX_MIN_PITCH, self.MAX_MIN_PITCH)
		local yaw_rotation = Quaternion(Vector3.up(), yaw)
		local pitch_rotation = Quaternion(Vector3.right(), pitch)
		local look_rotation = Quaternion.multiply(yaw_rotation, pitch_rotation)

		self.look_rotation:store(look_rotation)

		local first_person_unit = self.first_person_unit

		Unit.set_local_rotation(first_person_unit, 0, look_rotation)
	end
end

PlayerBotUnitFirstPerson.update_position = function (self)
	-- function 11
	local position_root = Unit.local_position(self.unit, 0)
	local offset_height = Vector3(0, 0, self.player_height_current)
	local position = position_root + offset_height

	Unit.set_local_position(self.first_person_unit, 0, position)
end

PlayerBotUnitFirstPerson.apply_recoil = function (self)
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

PlayerBotUnitFirstPerson.set_look_delta = function (self, look_delta)
	-- function 15
	self.has_look_delta = true

	Vector3Box.store(self.look_delta, look_delta)
end

PlayerBotUnitFirstPerson.play_animation_event = function (self, anim_event)
	-- function 16
	Unit.animation_event(self.first_person_unit, anim_event)
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
	local camera_position = Unit.local_position(self.first_person_unit, 0)
	local camera_rotation = Unit.local_rotation(self.first_person_unit, 0)

	return camera_position, camera_rotation
end

PlayerBotUnitFirstPerson.get_projectile_start_position_rotation = function (self)
	-- function 21
	local position = self:current_position()
	local rotation = self:current_rotation()

	return position, rotation
end

PlayerBotUnitFirstPerson.set_rotation = function (self, new_rotation)
	-- function 22
	Unit.set_local_rotation(self.first_person_unit, 0, new_rotation)
	Unit.set_local_rotation(self.unit, 0, new_rotation)
	self.look_rotation:store(new_rotation)
end

PlayerBotUnitFirstPerson.force_look_rotation = function (self)
	-- function 23
	return
end

PlayerBotUnitFirstPerson.stop_force_look_rotation = function (self)
	-- function 24
	return
end

PlayerBotUnitFirstPerson.set_wanted_player_height = function (self, state, t, time_to_change)
	-- function 25
	return
end

PlayerBotUnitFirstPerson.set_weapon_sway_settings = function (self)
	-- function 26
	return
end

PlayerBotUnitFirstPerson.toggle_visibility = function (self)
	-- function 27
	self:set_first_person_mode(not self.first_person_mode)
end

PlayerBotUnitFirstPerson.set_first_person_mode = function (self, active)
	-- function 28
	self.first_person_mode = active

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

PlayerBotUnitFirstPerson.debug_set_first_person_mode = function (self, active, override)
	-- function 29
	if active then
		Unit.set_unit_visibility(self.unit, not override)
		Unit.set_unit_visibility(self.first_person_attachment_unit, override)
		self.inventory_extension:show_first_person_inventory(override)
		self.inventory_extension:show_first_person_inventory_lights(override)
		self.inventory_extension:show_third_person_inventory(not override)
		self.attachment_extension:show_attachments(not override)
		self.cosmetic_extension:show_third_person_mesh(not override)

		self.first_person_debug = true
	else
		self.first_person_debug = false

		self:set_first_person_mode(self.first_person_mode)
	end
end

PlayerBotUnitFirstPerson.hide_weapons = function (self)
	-- function 30
	return
end

PlayerBotUnitFirstPerson.unhide_weapons = function (self)
	-- function 31
	return
end

PlayerBotUnitFirstPerson.show_first_person_ammo = function (self, show)
	-- function 32
	return
end

PlayerBotUnitFirstPerson.animation_set_variable = function (self, variable_name, value)
	-- function 33
	if self.first_person_debug then
		local variable = Unit.animation_find_variable(self.first_person_unit, variable_name)

		Unit.animation_set_variable(self.first_person_unit, variable, value)
	end
end

PlayerBotUnitFirstPerson.animation_event = function (self, event)
	-- function 34
	if self.first_person_debug then
		Unit.animation_event(self.first_person_unit, event)
	end
end

PlayerBotUnitFirstPerson.increase_aim_assist_multiplier = function (self)
	-- function 35
	return
end

PlayerBotUnitFirstPerson.reset_aim_assist_multiplier = function (self)
	-- function 36
	return
end

PlayerBotUnitFirstPerson.is_in_view = function (self, position)
	-- function 37
	return true
end

PlayerBotUnitFirstPerson.is_within_custom_view = function (self, position, camera_position, camera_rotation, vertical_fov_rad, horizontal_fov_rad)
	-- function 38
	return true
end

PlayerBotUnitFirstPerson.is_within_default_view = function (self, position)
	-- function 39
	return true
end

PlayerBotUnitFirstPerson.create_screen_particles = function (self, ...)
	-- function 40
	return
end

PlayerBotUnitFirstPerson.stop_spawning_screen_particles = function (self, ...)
	-- function 41
	return
end

PlayerBotUnitFirstPerson.destroy_screen_particles = function (self, ...)
	-- function 42
	return
end

PlayerBotUnitFirstPerson.play_hud_sound_event = function (self, event, wwise_source_id, play_on_husk)
	-- function 43
	self:play_remote_hud_sound_event(event, wwise_source_id, play_on_husk)
end

PlayerBotUnitFirstPerson.play_remote_hud_sound_event = function (self, event, wwise_source_id, play_on_husk)
	-- function 44
	if play_on_husk and not LEVEL_EDITOR_TEST then
		self:play_sound_event(event)

		local network_manager = Managers.state.network
		local network_transmit = network_manager.network_transmit
		local unit_id = network_manager:unit_game_object_id(self.unit)
		local event_id = NetworkLookup.sound_events[event]

		network_transmit:send_rpc_clients("rpc_play_husk_sound_event", unit_id, event_id)
	end
end

PlayerBotUnitFirstPerson.play_sound_event = function (self, event, position)
	-- function 45
	local sound_position = position or self:current_position()
	local wwise_source_id, wwise_world = WwiseUtils.make_position_auto_source(self.world, sound_position)

	WwiseWorld.set_switch(wwise_world, "husk", "true", wwise_source_id)
	WwiseWorld.trigger_event(wwise_world, event, wwise_source_id)
end

PlayerBotUnitFirstPerson.play_unit_sound_event = function (self, event, unit, node_id, play_on_husk)
	-- function 46
	if play_on_husk then
		local event_id = NetworkLookup.sound_events[event]
		local network_manager = Managers.state.network
		local game = network_manager:game()

		if game and not LEVEL_EDITOR_TEST then
			local network_transmit = network_manager.network_transmit
			local is_server = Managers.player.is_server
			local unit_id = network_manager:unit_game_object_id(unit)

			if is_server then
				network_transmit:send_rpc_clients("rpc_play_husk_unit_sound_event", unit_id, node_id, event_id)
			else
				network_transmit:send_rpc_server("rpc_play_husk_unit_sound_event", unit_id, node_id, event_id)
			end
		end
	end

	local wwise_source_id, wwise_world = WwiseUtils.make_unit_auto_source(self.world, unit, node_id)

	WwiseWorld.set_switch(wwise_world, "husk", "true", wwise_source_id)
	WwiseWorld.trigger_event(wwise_world, event, wwise_source_id)
end

PlayerBotUnitFirstPerson.play_remote_unit_sound_event = function (self, event, unit, node_id)
	-- function 47
	self:play_unit_sound_event(event, unit, node_id, true)
end

PlayerBotUnitFirstPerson.first_person_mode_active = function (self)
	-- function 48
	return self.first_person_debug
end

PlayerBotUnitFirstPerson.play_camera_effect_sequence = function (self, event, t)
	-- function 49
	return
end

PlayerBotUnitFirstPerson.enable_rig_movement = function (self)
	-- function 50
	return
end

PlayerBotUnitFirstPerson.disable_rig_movement = function (self)
	-- function 51
	return
end

PlayerBotUnitFirstPerson.enable_rig_offset = function (self)
	-- function 52
	return
end

PlayerBotUnitFirstPerson.disable_rig_offset = function (self)
	-- function 53
	return
end

PlayerBotUnitFirstPerson.change_state = function (self, state)
	-- function 54
	return
end

PlayerBotUnitFirstPerson.play_camera_effect_sequence = function (self)
	-- function 55
	return
end

PlayerBotUnitFirstPerson.play_camera_recoil = function (self)
	-- function 56
	return
end
