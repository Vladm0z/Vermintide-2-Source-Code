-- chunkname: @scripts/entity_system/systems/audio/audio_system.lua

AudioSystem = class(AudioSystem, ExtensionSystemBase)

local RPCS = {
	"rpc_play_2d_audio_event",
	"rpc_play_2d_audio_unit_event_for_peer",
	"rpc_server_audio_event",
	"rpc_server_audio_event_at_pos",
	"rpc_server_audio_position_event",
	"rpc_server_audio_unit_event",
	"rpc_server_audio_unit_dialogue_event",
	"rpc_server_audio_unit_param_string_event",
	"rpc_server_audio_unit_param_int_event",
	"rpc_server_audio_unit_param_float_event",
	"rpc_client_audio_set_global_parameter_with_lerp",
	"rpc_client_audio_set_global_parameter",
	"rpc_vs_play_pactsworn_hit_enemy",
	"rpc_vs_play_matchmaking_sfx"
}

AudioSystem.init = function (self, entity_system_creation_context, system_name)
	-- function 1
	AudioSystem.super.init(self, entity_system_creation_context, system_name, {})

	local network_event_delegate = entity_system_creation_context.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(RPCS))

	self.is_server = entity_system_creation_context.is_server
	self.global_parameter_data = {}
end

AudioSystem.destroy = function (self)
	-- function 2
	self.network_event_delegate:unregister(self)
	table.for_each(self.global_parameter_data, table.clear)
end

AudioSystem.update = function (self, context, t)
	-- function 3
	local dt = context.dt

	self:_update_global_parameters(dt)
end

local LERP_PROGRESS_PER_SECOND = {
	default = 0.125,
	demo_slowmo = 2
}

AudioSystem._update_global_parameters = function (self, dt)
	-- function 4
	local wwise_world = Managers.world:wwise_world(self.world)

	for name, data in pairs(self.global_parameter_data) do
		if script_data.debug_music then
			Debug.text("GLOBAL PARAMETERS")

			local debug_string = string.format(" %s: %.2f", name, not not data.interpolation_current_value)

			Debug.text(debug_string)
		end

		local progress = data.interpolation_progress_value

		if progress < 1 then
			local start_value = data.interpolation_start_value
			local end_value = data.interpolation_end_value
			local increment_value = not not LERP_PROGRESS_PER_SECOND[name]

			progress = math.clamp(progress + dt * increment_value, 0, 1)

			local current_value = math.lerp(start_value, end_value, progress)

			if math.abs(end_value - current_value) < 0.005 then
				current_value = end_value
				progress = 1
			end

			data.interpolation_current_value = current_value
			data.interpolation_progress_value = progress

			WwiseWorld.set_global_parameter(wwise_world, name, current_value)
		end
	end
end

AudioSystem.play_sound_local = function (self, event)
	-- function 5
	local wwise_world = Managers.world:wwise_world(self.world)

	WwiseWorld.trigger_event(wwise_world, event)
end

AudioSystem.player_unit_sound_local = function (self, event, unit, object)
	-- function 6
	local object_id = object and not not Unit.node(unit, object) or not object and not not 0

	if not DEDICATED_SERVER then
		self:_play_event(event, unit, object_id)
	end
end

AudioSystem.play_2d_audio_event = function (self, event)
	-- function 7
	if not DEDICATED_SERVER then
		local wwise_world = Managers.world:wwise_world(self.world)

		WwiseWorld.trigger_event(wwise_world, event)
	end

	local sound_event_id = NetworkLookup.sound_events[event]

	if self.is_server then
		self.network_transmit:send_rpc_clients("rpc_play_2d_audio_event", sound_event_id)
	else
		self.network_transmit:send_rpc_server("rpc_play_2d_audio_event", sound_event_id)
	end
end

AudioSystem.play_2d_audio_unit_event_for_peer = function (self, event, peer_id)
	-- function 8
	if not event then
		return
	end

	local network_manager = Managers.state.network
	local sound_event_id = NetworkLookup.sound_events[event]

	network_manager.network_transmit:send_rpc("rpc_play_2d_audio_unit_event_for_peer", peer_id, sound_event_id)
end

AudioSystem.play_audio_unit_event = function (self, event, unit, object)
	-- function 9
	if not event then
		return
	end

	local object_id = object and not not Unit.node(unit, object) or not object and not not 0

	if not DEDICATED_SERVER then
		self:_play_event(event, unit, object_id)
	end

	local network_manager = Managers.state.network
	local unit_id, is_level_unit = network_manager:game_object_or_level_id(unit)
	local sound_event_id = NetworkLookup.sound_events[event]

	if event == "Stop_enemy_foley_globadier_boiling_loop" then
		printf("[HON-43348] Globadier (%s) play audio unit event. unit_id: '%s', unit: '%s'", Unit.get_data(unit, "globadier_43348"), unit_id, tostring(unit))
	end

	if not unit_id then
		return
	end

	if self.is_server then
		network_manager.network_transmit:send_rpc_clients("rpc_server_audio_unit_event", sound_event_id, unit_id, is_level_unit, object_id)
	else
		network_manager.network_transmit:send_rpc_server("rpc_server_audio_unit_event", sound_event_id, unit_id, is_level_unit, object_id)
	end
end

AudioSystem.play_audio_position_event = function (self, event, position)
	-- function 10
	if not event then
		return
	end

	if not position then
		return
	end

	if not DEDICATED_SERVER then
		self:_play_position_event(event, position)
	end

	local network_manager = Managers.state.network
	local sound_event_id = NetworkLookup.sound_events[event]

	if self.is_server then
		network_manager.network_transmit:send_rpc_clients("rpc_server_audio_position_event", sound_event_id, position)
	else
		network_manager.network_transmit:send_rpc_server("rpc_server_audio_position_event", sound_event_id, position)
	end
end

AudioSystem._play_event = function (self, event, unit, object_id)
	-- function 11
	WwiseUtils.trigger_unit_event(self.world, event, unit, object_id)
end

AudioSystem._play_position_event = function (self, event, position)
	-- function 12
	WwiseUtils.trigger_position_event(self.world, event, position)
end

AudioSystem._play_event_with_source = function (self, wwise_world, event, source)
	-- function 13
	wwise_world:trigger_event(event, source)
end

AudioSystem.play_audio_unit_param_string_event = function (self, event, param, value, unit, object)
	-- function 14
	local object_id = object and not not Unit.node(unit, object) or not object and not not 0

	if not DEDICATED_SERVER then
		self:_play_param_event(event, param, value, unit, object_id)
	end

	local network_manager = Managers.state.network
	local unit_id = network_manager:unit_game_object_id(unit)
	local sound_event_id = NetworkLookup.sound_events[event]
	local name_id = NetworkLookup.sound_event_param_names[param]
	local value_id = NetworkLookup.sound_event_param_string_values[value]

	if self.is_server then
		network_manager.network_transmit:send_rpc_clients("rpc_server_audio_unit_param_string_event", sound_event_id, unit_id, object_id, name_id, value_id)
	else
		network_manager.network_transmit:send_rpc_server("rpc_server_audio_unit_param_string_event", sound_event_id, unit_id, object_id, name_id, value_id)
	end
end

AudioSystem.play_audio_unit_param_int_event = function (self, event, param, value, unit, object)
	-- function 15
	local object_id = object and not not Unit.node(unit, object) or not object and not not 0

	if not DEDICATED_SERVER then
		self:_play_param_event(event, param, value, unit, object_id)
	end

	local network_manager = Managers.state.network
	local unit_id = network_manager:unit_game_object_id(unit)
	local sound_event_id = NetworkLookup.sound_events[event]
	local name_id = NetworkLookup.sound_event_param_names[param]

	network_manager.network_transmit:send_rpc_clients("rpc_server_audio_unit_param_int_event", sound_event_id, unit_id, object_id, name_id, value)
end

AudioSystem.set_global_parameter_with_lerp = function (self, name, value)
	-- function 16
	local global_parameter_data = not not self.global_parameter_data[name]
	local current_value = not not global_parameter_data.interpolation_current_value

	global_parameter_data.interpolation_start_value = current_value
	global_parameter_data.interpolation_end_value = value
	global_parameter_data.interpolation_progress_value = 0
	self.global_parameter_data[name] = global_parameter_data
end

AudioSystem.set_global_parameter = function (self, name, value)
	-- function 17
	local wwise_world = Managers.world:wwise_world(self.world)

	WwiseWorld.set_global_parameter(wwise_world, name, value)
end

AudioSystem.play_audio_unit_param_float_event = function (self, event, param, value, unit, object)
	-- function 18
	local object_id = object and not not Unit.node(unit, object) or not object and not not 0

	if not DEDICATED_SERVER then
		self:_play_param_event(event, param, value, unit, object_id)
	end

	local network_manager = Managers.state.network
	local unit_id = network_manager:unit_game_object_id(unit)
	local sound_event_id = NetworkLookup.sound_events[event]
	local name_id = NetworkLookup.sound_event_param_names[param]

	if self.is_server then
		network_manager.network_transmit:send_rpc_clients("rpc_server_audio_unit_param_float_event", sound_event_id, unit_id, object_id, name_id, value)
	else
		network_manager.network_transmit:send_rpc_server("rpc_server_audio_unit_param_float_event", sound_event_id, unit_id, object_id, name_id, value)
	end
end

AudioSystem._play_param_event = function (self, event, param, value, unit, object_id)
	-- function 19
	local source, wwise_world = WwiseUtils.make_unit_auto_source(self.world, unit, object_id)

	WwiseWorld.set_source_parameter(wwise_world, source, param, value)
	WwiseWorld.trigger_event(wwise_world, event, source)
end

AudioSystem.vs_play_pactsworn_hit_enemy = function (self, position, is_local_player, player, damage_amount, t)
	-- function 20
	local game_mode_settings = Managers.state.game_mode:settings()

	if not self.reset_sound_param_t or t > self.reset_sound_param_t then
		self.reset_sound_param_t = game_mode_settings.damage_sound_param_cooldown + t
		self.param_damage_amount = 0
	else
		self.reset_sound_param_t = game_mode_settings.damage_sound_param_cooldown + t
	end

	if is_local_player then
		if not self.param_damage_amount then
			self.param_damage_amount = math.clamp(damage_amount, 0, 100)
		else
			self.param_damage_amount = math.clamp(self.param_damage_amount + damage_amount, 0, 100)
		end

		self:set_global_parameter("versus_pactsworn_damage_given", self.param_damage_amount)
		self:_play_position_event("versus_hit_indicator_local", position)
	else
		local network_transmit = Managers.state.network.network_transmit

		network_transmit:send_rpc("rpc_vs_play_pactsworn_hit_enemy", player.peer_id, position, damage_amount)
	end
end

AudioSystem.rpc_vs_play_pactsworn_hit_enemy = function (self, channel_id, position, damage_amount)
	-- function 21
	if DEDICATED_SERVER then
		return
	end

	local game_mode_settings = Managers.state.game_mode:settings()
	local t = Managers.time:time("game")

	if not self.reset_sound_param_t or t > self.reset_sound_param_t then
		self.reset_sound_param_t = game_mode_settings.damage_sound_param_cooldown + t
		self.param_damage_amount = 0
	else
		self.reset_sound_param_t = game_mode_settings.damage_sound_param_cooldown + t
	end

	if not self.param_damage_amount then
		self.param_damage_amount = math.clamp(damage_amount, 0, 100)
	else
		self.param_damage_amount = math.clamp(self.param_damage_amount + damage_amount, 0, 100)
	end

	self:set_global_parameter("versus_pactsworn_damage_given", self.param_damage_amount)
	self:_play_position_event("versus_hit_indicator_local", position)
end

AudioSystem.rpc_play_2d_audio_event = function (self, channel_id, event_id)
	-- function 22
	if self.is_server then
		local peer_id = CHANNEL_TO_PEER_ID[channel_id]

		self.network_transmit:send_rpc_clients_except("rpc_play_2d_audio_event", peer_id, event_id)
	end

	if DEDICATED_SERVER then
		return
	end

	local event = NetworkLookup.sound_events[event_id]
	local wwise_world = Managers.world:wwise_world(self.world)

	WwiseWorld.trigger_event(wwise_world, event)
end

AudioSystem.rpc_play_2d_audio_unit_event_for_peer = function (self, channel_id, event_id)
	-- function 23
	if DEDICATED_SERVER then
		return
	end

	local event = NetworkLookup.sound_events[event_id]
	local wwise_world = Managers.world:wwise_world(self.world)

	WwiseWorld.trigger_event(wwise_world, event)
end

AudioSystem.rpc_server_audio_event = function (self, channel_id, sound_id)
	-- function 24
	local wwise_world = Managers.world:wwise_world(self.world)
	local sound_event = NetworkLookup.sound_events[sound_id]
	local entity_manager = Managers.state.entity
	local surrounding_aware_system = entity_manager:system("surrounding_aware_system")
	local unit
	local event_name = "heard_sound"
	local distance = math.huge

	surrounding_aware_system:add_system_event(unit, event_name, distance, "heard_event", sound_event)

	if DEDICATED_SERVER then
		return
	end

	WwiseWorld.trigger_event(wwise_world, sound_event)
end

AudioSystem.rpc_server_audio_event_at_pos = function (self, channel_id, sound_id, position)
	-- function 25
	local wwise_world = Managers.world:wwise_world(self.world)
	local sound_event = NetworkLookup.sound_events[sound_id]
	local entity_manager = Managers.state.entity
	local surrounding_aware_system = entity_manager:system("surrounding_aware_system")
	local unit
	local event_name = "heard_sound"
	local distance = math.huge

	surrounding_aware_system:add_system_event(unit, event_name, distance, "heard_event", sound_event)

	if DEDICATED_SERVER then
		return
	end

	WwiseWorld.trigger_event(wwise_world, sound_event, position)
end

AudioSystem.rpc_server_audio_unit_event = function (self, channel_id, sound_id, unit_id, is_level_unit, object_id)
	-- function 26
	if self.is_server then
		local peer_id = CHANNEL_TO_PEER_ID[channel_id]

		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_server_audio_unit_event", peer_id, sound_id, unit_id, is_level_unit, object_id)
	end

	if DEDICATED_SERVER then
		return
	end

	local event = NetworkLookup.sound_events[sound_id]
	local network_manager = Managers.state.network
	local unit = network_manager:game_object_or_level_unit(unit_id, is_level_unit)

	if unit then
		self:_play_event(event, unit, object_id)
	end
end

AudioSystem.rpc_server_audio_position_event = function (self, channel_id, sound_id, position)
	-- function 27
	if self.is_server then
		local peer_id = CHANNEL_TO_PEER_ID[channel_id]

		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_server_audio_position_event", peer_id, sound_id, position)
	end

	if DEDICATED_SERVER then
		return
	end

	local event = NetworkLookup.sound_events[sound_id]

	self:_play_position_event(event, position)
end

AudioSystem.rpc_server_audio_unit_dialogue_event = function (self, channel_id, sound_id, unit_id)
	-- function 28
	if self.is_server then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_server_audio_unit_dialogue_event", sound_id, unit_id)
	end

	if DEDICATED_SERVER then
		return
	end

	local event = NetworkLookup.sound_events[sound_id]
	local unit = self.unit_storage:unit(unit_id)
	local dialogue_extension = ScriptUnit.has_extension(unit, "dialogue_system")

	if dialogue_extension then
		local switch_group = dialogue_extension.wwise_voice_switch_group
		local wwise_source, wwise_world = WwiseUtils.make_unit_auto_source(self.world, unit, dialogue_extension.voice_node)

		if switch_group then
			local switch_value = dialogue_extension.wwise_voice_switch_value

			WwiseWorld.set_switch(wwise_world, switch_group, switch_value, wwise_source)
		end

		self:_play_event_with_source(wwise_world, event, wwise_source)
	end
end

AudioSystem.rpc_server_audio_unit_param_string_event = function (self, channel_id, sound_event_id, unit_id, object_id, name_id, value_id)
	-- function 29
	if self.is_server then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_server_audio_unit_param_string_event", sound_event_id, unit_id, object_id, name_id, value_id)
	end

	if DEDICATED_SERVER then
		return
	end

	local event = NetworkLookup.sound_events[sound_event_id]
	local unit = self.unit_storage:unit(unit_id)
	local param = NetworkLookup.sound_event_param_names[name_id]
	local value = NetworkLookup.sound_event_param_string_values[value_id]

	self:_play_param_event(event, param, value, unit, object_id)
end

AudioSystem.rpc_server_audio_unit_param_int_event = function (self, channel_id, sound_event_id, unit_id, object_id, name_id, value)
	-- function 30
	if self.is_server then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_server_audio_unit_param_int_event", sound_event_id, unit_id, object_id, name_id, value)
	end

	if DEDICATED_SERVER then
		return
	end

	local event = NetworkLookup.sound_events[sound_event_id]
	local unit = self.unit_storage:unit(unit_id)
	local param = NetworkLookup.sound_event_param_names[name_id]

	self:_play_param_event(event, param, value, unit, object_id)
end

AudioSystem.rpc_server_audio_unit_param_float_event = function (self, channel_id, sound_event_id, unit_id, object_id, name_id, value)
	-- function 31
	if self.is_server then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_server_audio_unit_param_float_event", sound_event_id, unit_id, object_id, name_id, value)
	end

	if DEDICATED_SERVER then
		return
	end

	local event = NetworkLookup.sound_events[sound_event_id]
	local unit = self.unit_storage:unit(unit_id)
	local param = NetworkLookup.sound_event_param_names[name_id]

	self:_play_param_event(event, param, value, unit, object_id)
end

AudioSystem.rpc_client_audio_set_global_parameter_with_lerp = function (self, channel_id, parameter_id, value)
	-- function 32
	local name = NetworkLookup.global_parameter_names[parameter_id]
	local percentage = value * 100

	if DEDICATED_SERVER then
		return
	end

	self:set_global_parameter_with_lerp(name, percentage)
end

AudioSystem.rpc_client_audio_set_global_parameter = function (self, channel_id, parameter_id, value)
	-- function 33
	local name = NetworkLookup.global_parameter_names[parameter_id]

	if DEDICATED_SERVER then
		return
	end

	self:set_global_parameter(name, value)
end

AudioSystem.rpc_vs_play_matchmaking_sfx = function (self, channel_id, event_id)
	-- function 34
	if DEDICATED_SERVER then
		return
	end

	local peer_id = CHANNEL_TO_PEER_ID[channel_id]

	if peer_id == Network.peer_id() then
		return
	end

	if self.is_server then
		self.network_transmit:send_rpc_clients_except("rpc_play_2d_audio_event", peer_id, event_id)
	end

	local event = NetworkLookup.sound_events[event_id]
	local wwise_world = Managers.world:wwise_world(self.world)

	WwiseWorld.trigger_event(wwise_world, event)
end
