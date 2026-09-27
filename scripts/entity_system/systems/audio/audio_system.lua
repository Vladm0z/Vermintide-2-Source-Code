-- chunkname: @scripts/entity_system/systems/audio/audio_system.lua

AudioSystem = class(AudioSystem, ExtensionSystemBase)

local tbl = {
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

AudioSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	AudioSystem.super.init(self, arg_1_1, arg_1_2, {})

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))

	self.is_server = arg_1_1.is_server
	self.global_parameter_data = {}
end

AudioSystem.destroy = function (self)
	-- function 2
	self.network_event_delegate:unregister(self)
	table.for_each(self.global_parameter_data, table.clear)
end

AudioSystem.update = function (self, arg_3_1, arg_3_2)
	-- function 3
	local dt = arg_3_1.dt

	self:_update_global_parameters(dt)
end

local tbl_2 = {
	default = 0.125,
	demo_slowmo = 2
}

AudioSystem._update_global_parameters = function (self, arg_4_1)
	-- function 4
	local wwise_world = Managers.world:wwise_world(self.world)

	for k, v in pairs(self.global_parameter_data) do
		if not script_data.debug_music then
			Debug.text("GLOBAL PARAMETERS")

			local format = string.format
			local str = " %s: %.2f"
			local var_4_3 = k
			local interpolation_current_value = v.interpolation_current_value

			interpolation_current_value = interpolation_current_value or 0

			local var_4_5 = format(str, var_4_3, interpolation_current_value)

			Debug.text(var_4_5)
		end

		local interpolation_progress_value = v.interpolation_progress_value

		if interpolation_progress_value < 1 then
			local interpolation_start_value = v.interpolation_start_value
			local interpolation_end_value = v.interpolation_end_value
			local var_4_9 = tbl_2[k]

			var_4_9 = var_4_9 or tbl_2.default

			local clamp = math.clamp(interpolation_progress_value + arg_4_1 * var_4_9, 0, 1)
			local lerp = math.lerp(interpolation_start_value, interpolation_end_value, clamp)

			if math.abs(interpolation_end_value - lerp) < 0.005 then
				lerp = interpolation_end_value
				clamp = 1
			end

			v.interpolation_current_value = lerp
			v.interpolation_progress_value = clamp

			WwiseWorld.set_global_parameter(wwise_world, k, lerp)
		end
	end
end

AudioSystem.play_sound_local = function (self, arg_5_1)
	-- function 5
	local wwise_world = Managers.world:wwise_world(self.world)

	WwiseWorld.trigger_event(wwise_world, arg_5_1)
end

AudioSystem.player_unit_sound_local = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local node

	if not arg_6_3 then
		node = Unit.node(arg_6_2, arg_6_3)

		if not node then
			-- Nothing
		end
	end

	node = 0

	::label_6_0::

	if not DEDICATED_SERVER then
		self:_play_event(arg_6_1, arg_6_2, node)
	end
end

AudioSystem.play_2d_audio_event = function (self, arg_7_1)
	-- function 7
	if not DEDICATED_SERVER then
		local wwise_world = Managers.world:wwise_world(self.world)

		WwiseWorld.trigger_event(wwise_world, arg_7_1)
	end

	local var_7_1 = NetworkLookup.sound_events[arg_7_1]

	if not self.is_server then
		self.network_transmit:send_rpc_clients("rpc_play_2d_audio_event", var_7_1)
	else
		self.network_transmit:send_rpc_server("rpc_play_2d_audio_event", var_7_1)
	end
end

AudioSystem.play_2d_audio_unit_event_for_peer = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	if not arg_8_1 then
		return
	end

	local network = Managers.state.network
	local var_8_1 = NetworkLookup.sound_events[arg_8_1]

	network.network_transmit:send_rpc("rpc_play_2d_audio_unit_event_for_peer", arg_8_2, var_8_1)
end

AudioSystem.play_audio_unit_event = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	if not arg_9_1 then
		return
	end

	local node

	if not arg_9_3 then
		node = Unit.node(arg_9_2, arg_9_3)

		if not node then
			-- Nothing
		end
	end

	node = 0

	::label_9_0::

	if not DEDICATED_SERVER then
		self:_play_event(arg_9_1, arg_9_2, node)
	end

	local network = Managers.state.network
	local game_object_or_level_id, var_9_3 = network:game_object_or_level_id(arg_9_2)
	local var_9_4 = NetworkLookup.sound_events[arg_9_1]

	if arg_9_1 == "Stop_enemy_foley_globadier_boiling_loop" then
		printf("[HON-43348] Globadier (%s) play audio unit event. unit_id: '%s', unit: '%s'", Unit.get_data(arg_9_2, "globadier_43348"), game_object_or_level_id, tostring(arg_9_2))
	end

	if not game_object_or_level_id then
		return
	end

	if not self.is_server then
		network.network_transmit:send_rpc_clients("rpc_server_audio_unit_event", var_9_4, game_object_or_level_id, var_9_3, node)
	else
		network.network_transmit:send_rpc_server("rpc_server_audio_unit_event", var_9_4, game_object_or_level_id, var_9_3, node)
	end
end

AudioSystem.play_audio_position_event = function (self, arg_10_1, arg_10_2)
	-- function 10
	if not arg_10_1 then
		return
	end

	if not arg_10_2 then
		return
	end

	if not DEDICATED_SERVER then
		self:_play_position_event(arg_10_1, arg_10_2)
	end

	local network = Managers.state.network
	local var_10_1 = NetworkLookup.sound_events[arg_10_1]

	if not self.is_server then
		network.network_transmit:send_rpc_clients("rpc_server_audio_position_event", var_10_1, arg_10_2)
	else
		network.network_transmit:send_rpc_server("rpc_server_audio_position_event", var_10_1, arg_10_2)
	end
end

AudioSystem._play_event = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	WwiseUtils.trigger_unit_event(self.world, arg_11_1, arg_11_2, arg_11_3)
end

AudioSystem._play_position_event = function (self, arg_12_1, arg_12_2)
	-- function 12
	WwiseUtils.trigger_position_event(self.world, arg_12_1, arg_12_2)
end

AudioSystem._play_event_with_source = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	arg_13_1:trigger_event(arg_13_2, arg_13_3)
end

AudioSystem.play_audio_unit_param_string_event = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	-- function 14
	local node

	if not arg_14_5 then
		node = Unit.node(arg_14_4, arg_14_5)

		if not node then
			-- Nothing
		end
	end

	node = 0

	::label_14_0::

	if not DEDICATED_SERVER then
		self:_play_param_event(arg_14_1, arg_14_2, arg_14_3, arg_14_4, node)
	end

	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(arg_14_4)
	local var_14_3 = NetworkLookup.sound_events[arg_14_1]
	local var_14_4 = NetworkLookup.sound_event_param_names[arg_14_2]
	local var_14_5 = NetworkLookup.sound_event_param_string_values[arg_14_3]

	if not self.is_server then
		network.network_transmit:send_rpc_clients("rpc_server_audio_unit_param_string_event", var_14_3, unit_game_object_id, node, var_14_4, var_14_5)
	else
		network.network_transmit:send_rpc_server("rpc_server_audio_unit_param_string_event", var_14_3, unit_game_object_id, node, var_14_4, var_14_5)
	end
end

AudioSystem.play_audio_unit_param_int_event = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	local node

	if not arg_15_5 then
		node = Unit.node(arg_15_4, arg_15_5)

		if not node then
			-- Nothing
		end
	end

	node = 0

	::label_15_0::

	if not DEDICATED_SERVER then
		self:_play_param_event(arg_15_1, arg_15_2, arg_15_3, arg_15_4, node)
	end

	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(arg_15_4)
	local var_15_3 = NetworkLookup.sound_events[arg_15_1]
	local var_15_4 = NetworkLookup.sound_event_param_names[arg_15_2]

	network.network_transmit:send_rpc_clients("rpc_server_audio_unit_param_int_event", var_15_3, unit_game_object_id, node, var_15_4, arg_15_3)
end

AudioSystem.set_global_parameter_with_lerp = function (self, arg_16_1, arg_16_2)
	-- function 16
	local var_16_0 = self.global_parameter_data[arg_16_1]

	var_16_0 = var_16_0 or {}

	local interpolation_current_value = var_16_0.interpolation_current_value

	interpolation_current_value = interpolation_current_value or 0
	var_16_0.interpolation_start_value = interpolation_current_value
	var_16_0.interpolation_end_value = arg_16_2
	var_16_0.interpolation_progress_value = 0
	self.global_parameter_data[arg_16_1] = var_16_0
end

AudioSystem.set_global_parameter = function (self, arg_17_1, arg_17_2)
	-- function 17
	local wwise_world = Managers.world:wwise_world(self.world)

	WwiseWorld.set_global_parameter(wwise_world, arg_17_1, arg_17_2)
end

AudioSystem.play_audio_unit_param_float_event = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	-- function 18
	local node

	if not arg_18_5 then
		node = Unit.node(arg_18_4, arg_18_5)

		if not node then
			-- Nothing
		end
	end

	node = 0

	::label_18_0::

	if not DEDICATED_SERVER then
		self:_play_param_event(arg_18_1, arg_18_2, arg_18_3, arg_18_4, node)
	end

	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(arg_18_4)
	local var_18_3 = NetworkLookup.sound_events[arg_18_1]
	local var_18_4 = NetworkLookup.sound_event_param_names[arg_18_2]

	if not self.is_server then
		network.network_transmit:send_rpc_clients("rpc_server_audio_unit_param_float_event", var_18_3, unit_game_object_id, node, var_18_4, arg_18_3)
	else
		network.network_transmit:send_rpc_server("rpc_server_audio_unit_param_float_event", var_18_3, unit_game_object_id, node, var_18_4, arg_18_3)
	end
end

AudioSystem._play_param_event = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	-- function 19
	local make_unit_auto_source, var_19_1 = WwiseUtils.make_unit_auto_source(self.world, arg_19_4, arg_19_5)

	WwiseWorld.set_source_parameter(var_19_1, make_unit_auto_source, arg_19_2, arg_19_3)
	WwiseWorld.trigger_event(var_19_1, arg_19_1, make_unit_auto_source)
end

AudioSystem.vs_play_pactsworn_hit_enemy = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	-- function 20
	local settings = Managers.state.game_mode:settings()

	if not (not self.reset_sound_param_t and not (arg_20_5 > self.reset_sound_param_t)) then
		self.reset_sound_param_t = settings.damage_sound_param_cooldown + arg_20_5
		self.param_damage_amount = 0
	else
		self.reset_sound_param_t = settings.damage_sound_param_cooldown + arg_20_5
	end

	if not arg_20_2 then
		if not self.param_damage_amount then
			self.param_damage_amount = math.clamp(arg_20_4, 0, 100)
		else
			self.param_damage_amount = math.clamp(self.param_damage_amount + arg_20_4, 0, 100)
		end

		self:set_global_parameter("versus_pactsworn_damage_given", self.param_damage_amount)
		self:_play_position_event("versus_hit_indicator_local", arg_20_1)
	else
		Managers.state.network.network_transmit:send_rpc("rpc_vs_play_pactsworn_hit_enemy", arg_20_3.peer_id, arg_20_1, arg_20_4)
	end
end

AudioSystem.rpc_vs_play_pactsworn_hit_enemy = function (self, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	if not DEDICATED_SERVER then
		return
	end

	local settings = Managers.state.game_mode:settings()
	local time = Managers.time:time("game")

	if not (not self.reset_sound_param_t and not (time > self.reset_sound_param_t)) then
		self.reset_sound_param_t = settings.damage_sound_param_cooldown + time
		self.param_damage_amount = 0
	else
		self.reset_sound_param_t = settings.damage_sound_param_cooldown + time
	end

	if not self.param_damage_amount then
		self.param_damage_amount = math.clamp(arg_21_3, 0, 100)
	else
		self.param_damage_amount = math.clamp(self.param_damage_amount + arg_21_3, 0, 100)
	end

	self:set_global_parameter("versus_pactsworn_damage_given", self.param_damage_amount)
	self:_play_position_event("versus_hit_indicator_local", arg_21_2)
end

AudioSystem.rpc_play_2d_audio_event = function (self, arg_22_1, arg_22_2)
	-- function 22
	if not self.is_server then
		local var_22_0 = CHANNEL_TO_PEER_ID[arg_22_1]

		self.network_transmit:send_rpc_clients_except("rpc_play_2d_audio_event", var_22_0, arg_22_2)
	end

	if not DEDICATED_SERVER then
		return
	end

	local var_22_1 = NetworkLookup.sound_events[arg_22_2]
	local wwise_world = Managers.world:wwise_world(self.world)

	WwiseWorld.trigger_event(wwise_world, var_22_1)
end

AudioSystem.rpc_play_2d_audio_unit_event_for_peer = function (self, arg_23_1, arg_23_2)
	-- function 23
	if not DEDICATED_SERVER then
		return
	end

	local var_23_0 = NetworkLookup.sound_events[arg_23_2]
	local wwise_world = Managers.world:wwise_world(self.world)

	WwiseWorld.trigger_event(wwise_world, var_23_0)
end

AudioSystem.rpc_server_audio_event = function (self, arg_24_1, arg_24_2)
	-- function 24
	local wwise_world = Managers.world:wwise_world(self.world)
	local var_24_1 = NetworkLookup.sound_events[arg_24_2]
	local system = Managers.state.entity:system("surrounding_aware_system")
	local var_24_3
	local str = "heard_sound"
	local huge = math.huge

	system:add_system_event(var_24_3, str, huge, "heard_event", var_24_1)

	if not DEDICATED_SERVER then
		return
	end

	WwiseWorld.trigger_event(wwise_world, var_24_1)
end

AudioSystem.rpc_server_audio_event_at_pos = function (self, arg_25_1, arg_25_2, arg_25_3)
	-- function 25
	local wwise_world = Managers.world:wwise_world(self.world)
	local var_25_1 = NetworkLookup.sound_events[arg_25_2]
	local system = Managers.state.entity:system("surrounding_aware_system")
	local var_25_3
	local str = "heard_sound"
	local huge = math.huge

	system:add_system_event(var_25_3, str, huge, "heard_event", var_25_1)

	if not DEDICATED_SERVER then
		return
	end

	WwiseWorld.trigger_event(wwise_world, var_25_1, arg_25_3)
end

AudioSystem.rpc_server_audio_unit_event = function (self, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5)
	-- function 26
	if not self.is_server then
		local var_26_0 = CHANNEL_TO_PEER_ID[arg_26_1]

		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_server_audio_unit_event", var_26_0, arg_26_2, arg_26_3, arg_26_4, arg_26_5)
	end

	if not DEDICATED_SERVER then
		return
	end

	local var_26_1 = NetworkLookup.sound_events[arg_26_2]
	local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(arg_26_3, arg_26_4)

	if not game_object_or_level_unit then
		self:_play_event(var_26_1, game_object_or_level_unit, arg_26_5)
	end
end

AudioSystem.rpc_server_audio_position_event = function (self, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
	if not self.is_server then
		local var_27_0 = CHANNEL_TO_PEER_ID[arg_27_1]

		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_server_audio_position_event", var_27_0, arg_27_2, arg_27_3)
	end

	if not DEDICATED_SERVER then
		return
	end

	local var_27_1 = NetworkLookup.sound_events[arg_27_2]

	self:_play_position_event(var_27_1, arg_27_3)
end

AudioSystem.rpc_server_audio_unit_dialogue_event = function (self, arg_28_1, arg_28_2, arg_28_3)
	-- function 28
	if not self.is_server then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_server_audio_unit_dialogue_event", arg_28_2, arg_28_3)
	end

	if not DEDICATED_SERVER then
		return
	end

	local var_28_0 = NetworkLookup.sound_events[arg_28_2]
	local unit = self.unit_storage:unit(arg_28_3)
	local has_extension = ScriptUnit.has_extension(unit, "dialogue_system")

	if not has_extension then
		local wwise_voice_switch_group = has_extension.wwise_voice_switch_group
		local make_unit_auto_source, var_28_5 = WwiseUtils.make_unit_auto_source(self.world, unit, has_extension.voice_node)

		if not wwise_voice_switch_group then
			local wwise_voice_switch_value = has_extension.wwise_voice_switch_value

			WwiseWorld.set_switch(var_28_5, wwise_voice_switch_group, wwise_voice_switch_value, make_unit_auto_source)
		end

		self:_play_event_with_source(var_28_5, var_28_0, make_unit_auto_source)
	end
end

AudioSystem.rpc_server_audio_unit_param_string_event = function (self, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6)
	-- function 29
	if not self.is_server then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_server_audio_unit_param_string_event", arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6)
	end

	if not DEDICATED_SERVER then
		return
	end

	local var_29_0 = NetworkLookup.sound_events[arg_29_2]
	local unit = self.unit_storage:unit(arg_29_3)
	local var_29_2 = NetworkLookup.sound_event_param_names[arg_29_5]
	local var_29_3 = NetworkLookup.sound_event_param_string_values[arg_29_6]

	self:_play_param_event(var_29_0, var_29_2, var_29_3, unit, arg_29_4)
end

AudioSystem.rpc_server_audio_unit_param_int_event = function (self, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5, arg_30_6)
	-- function 30
	if not self.is_server then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_server_audio_unit_param_int_event", arg_30_2, arg_30_3, arg_30_4, arg_30_5, arg_30_6)
	end

	if not DEDICATED_SERVER then
		return
	end

	local var_30_0 = NetworkLookup.sound_events[arg_30_2]
	local unit = self.unit_storage:unit(arg_30_3)
	local var_30_2 = NetworkLookup.sound_event_param_names[arg_30_5]

	self:_play_param_event(var_30_0, var_30_2, arg_30_6, unit, arg_30_4)
end

AudioSystem.rpc_server_audio_unit_param_float_event = function (self, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5, arg_31_6)
	-- function 31
	if not self.is_server then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_server_audio_unit_param_float_event", arg_31_2, arg_31_3, arg_31_4, arg_31_5, arg_31_6)
	end

	if not DEDICATED_SERVER then
		return
	end

	local var_31_0 = NetworkLookup.sound_events[arg_31_2]
	local unit = self.unit_storage:unit(arg_31_3)
	local var_31_2 = NetworkLookup.sound_event_param_names[arg_31_5]

	self:_play_param_event(var_31_0, var_31_2, arg_31_6, unit, arg_31_4)
end

AudioSystem.rpc_client_audio_set_global_parameter_with_lerp = function (self, arg_32_1, arg_32_2, arg_32_3)
	-- function 32
	local var_32_0 = NetworkLookup.global_parameter_names[arg_32_2]
	local num = arg_32_3 * 100

	if not DEDICATED_SERVER then
		return
	end

	self:set_global_parameter_with_lerp(var_32_0, num)
end

AudioSystem.rpc_client_audio_set_global_parameter = function (self, arg_33_1, arg_33_2, arg_33_3)
	-- function 33
	local var_33_0 = NetworkLookup.global_parameter_names[arg_33_2]

	if not DEDICATED_SERVER then
		return
	end

	self:set_global_parameter(var_33_0, arg_33_3)
end

AudioSystem.rpc_vs_play_matchmaking_sfx = function (self, arg_34_1, arg_34_2)
	-- function 34
	if not DEDICATED_SERVER then
		return
	end

	local var_34_0 = CHANNEL_TO_PEER_ID[arg_34_1]

	if var_34_0 == Network.peer_id() then
		return
	end

	if not self.is_server then
		self.network_transmit:send_rpc_clients_except("rpc_play_2d_audio_event", var_34_0, arg_34_2)
	end

	local var_34_1 = NetworkLookup.sound_events[arg_34_2]
	local wwise_world = Managers.world:wwise_world(self.world)

	WwiseWorld.trigger_event(wwise_world, var_34_1)
end
