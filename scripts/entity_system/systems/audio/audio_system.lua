-- chunkname: @scripts/entity_system/systems/audio/audio_system.lua

AudioSystem = class(AudioSystem, ExtensionSystemBase)

local var_0_0 = {
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

function AudioSystem.init(arg_1_0, arg_1_1, arg_1_2)
	AudioSystem.super.init(arg_1_0, arg_1_1, arg_1_2, {})

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_0))

	arg_1_0.is_server = arg_1_1.is_server
	arg_1_0.global_parameter_data = {}
end

function AudioSystem.destroy(arg_2_0)
	arg_2_0.network_event_delegate:unregister(arg_2_0)
	table.for_each(arg_2_0.global_parameter_data, table.clear)
end

function AudioSystem.update(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_1.dt

	arg_3_0:_update_global_parameters(var_3_0)
end

local var_0_1 = {
	default = 0.125,
	demo_slowmo = 2
}

function AudioSystem._update_global_parameters(arg_4_0, arg_4_1)
	local var_4_0 = Managers.world:wwise_world(arg_4_0.world)

	for iter_4_0, iter_4_1 in pairs(arg_4_0.global_parameter_data) do
		if script_data.debug_music then
			Debug.text("GLOBAL PARAMETERS")

			local var_4_1 = string.format(" %s: %.2f", iter_4_0, iter_4_1.interpolation_current_value or 0)

			Debug.text(var_4_1)
		end

		local var_4_2 = iter_4_1.interpolation_progress_value

		if var_4_2 < 1 then
			local var_4_3 = iter_4_1.interpolation_start_value
			local var_4_4 = iter_4_1.interpolation_end_value
			local var_4_5 = var_0_1[iter_4_0] or var_0_1.default
			local var_4_6 = math.clamp(var_4_2 + arg_4_1 * var_4_5, 0, 1)
			local var_4_7 = math.lerp(var_4_3, var_4_4, var_4_6)

			if math.abs(var_4_4 - var_4_7) < 0.005 then
				var_4_7 = var_4_4
				var_4_6 = 1
			end

			iter_4_1.interpolation_current_value = var_4_7
			iter_4_1.interpolation_progress_value = var_4_6

			WwiseWorld.set_global_parameter(var_4_0, iter_4_0, var_4_7)
		end
	end
end

function AudioSystem.play_sound_local(arg_5_0, arg_5_1)
	local var_5_0 = Managers.world:wwise_world(arg_5_0.world)

	WwiseWorld.trigger_event(var_5_0, arg_5_1)
end

function AudioSystem.player_unit_sound_local(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_3 and Unit.node(arg_6_2, arg_6_3) or 0

	if not DEDICATED_SERVER then
		arg_6_0:_play_event(arg_6_1, arg_6_2, var_6_0)
	end
end

function AudioSystem.play_2d_audio_event(arg_7_0, arg_7_1)
	if not DEDICATED_SERVER then
		local var_7_0 = Managers.world:wwise_world(arg_7_0.world)

		WwiseWorld.trigger_event(var_7_0, arg_7_1)
	end

	local var_7_1 = NetworkLookup.sound_events[arg_7_1]

	if arg_7_0.is_server then
		arg_7_0.network_transmit:send_rpc_clients("rpc_play_2d_audio_event", var_7_1)
	else
		arg_7_0.network_transmit:send_rpc_server("rpc_play_2d_audio_event", var_7_1)
	end
end

function AudioSystem.play_2d_audio_unit_event_for_peer(arg_8_0, arg_8_1, arg_8_2)
	if not arg_8_1 then
		return
	end

	local var_8_0 = Managers.state.network
	local var_8_1 = NetworkLookup.sound_events[arg_8_1]

	var_8_0.network_transmit:send_rpc("rpc_play_2d_audio_unit_event_for_peer", arg_8_2, var_8_1)
end

function AudioSystem.play_audio_unit_event(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	if not arg_9_1 then
		return
	end

	local var_9_0 = arg_9_3 and Unit.node(arg_9_2, arg_9_3) or 0

	if not DEDICATED_SERVER then
		arg_9_0:_play_event(arg_9_1, arg_9_2, var_9_0)
	end

	local var_9_1 = Managers.state.network
	local var_9_2, var_9_3 = var_9_1:game_object_or_level_id(arg_9_2)
	local var_9_4 = NetworkLookup.sound_events[arg_9_1]

	if arg_9_1 == "Stop_enemy_foley_globadier_boiling_loop" then
		printf("[HON-43348] Globadier (%s) play audio unit event. unit_id: '%s', unit: '%s'", Unit.get_data(arg_9_2, "globadier_43348"), var_9_2, tostring(arg_9_2))
	end

	if not var_9_2 then
		return
	end

	if arg_9_0.is_server then
		var_9_1.network_transmit:send_rpc_clients("rpc_server_audio_unit_event", var_9_4, var_9_2, var_9_3, var_9_0)
	else
		var_9_1.network_transmit:send_rpc_server("rpc_server_audio_unit_event", var_9_4, var_9_2, var_9_3, var_9_0)
	end
end

function AudioSystem.play_audio_position_event(arg_10_0, arg_10_1, arg_10_2)
	if not arg_10_1 then
		return
	end

	if not arg_10_2 then
		return
	end

	if not DEDICATED_SERVER then
		arg_10_0:_play_position_event(arg_10_1, arg_10_2)
	end

	local var_10_0 = Managers.state.network
	local var_10_1 = NetworkLookup.sound_events[arg_10_1]

	if arg_10_0.is_server then
		var_10_0.network_transmit:send_rpc_clients("rpc_server_audio_position_event", var_10_1, arg_10_2)
	else
		var_10_0.network_transmit:send_rpc_server("rpc_server_audio_position_event", var_10_1, arg_10_2)
	end
end

function AudioSystem._play_event(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	WwiseUtils.trigger_unit_event(arg_11_0.world, arg_11_1, arg_11_2, arg_11_3)
end

function AudioSystem._play_position_event(arg_12_0, arg_12_1, arg_12_2)
	WwiseUtils.trigger_position_event(arg_12_0.world, arg_12_1, arg_12_2)
end

function AudioSystem._play_event_with_source(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	arg_13_1:trigger_event(arg_13_2, arg_13_3)
end

function AudioSystem.play_audio_unit_param_string_event(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	local var_14_0 = arg_14_5 and Unit.node(arg_14_4, arg_14_5) or 0

	if not DEDICATED_SERVER then
		arg_14_0:_play_param_event(arg_14_1, arg_14_2, arg_14_3, arg_14_4, var_14_0)
	end

	local var_14_1 = Managers.state.network
	local var_14_2 = var_14_1:unit_game_object_id(arg_14_4)
	local var_14_3 = NetworkLookup.sound_events[arg_14_1]
	local var_14_4 = NetworkLookup.sound_event_param_names[arg_14_2]
	local var_14_5 = NetworkLookup.sound_event_param_string_values[arg_14_3]

	if arg_14_0.is_server then
		var_14_1.network_transmit:send_rpc_clients("rpc_server_audio_unit_param_string_event", var_14_3, var_14_2, var_14_0, var_14_4, var_14_5)
	else
		var_14_1.network_transmit:send_rpc_server("rpc_server_audio_unit_param_string_event", var_14_3, var_14_2, var_14_0, var_14_4, var_14_5)
	end
end

function AudioSystem.play_audio_unit_param_int_event(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	local var_15_0 = arg_15_5 and Unit.node(arg_15_4, arg_15_5) or 0

	if not DEDICATED_SERVER then
		arg_15_0:_play_param_event(arg_15_1, arg_15_2, arg_15_3, arg_15_4, var_15_0)
	end

	local var_15_1 = Managers.state.network
	local var_15_2 = var_15_1:unit_game_object_id(arg_15_4)
	local var_15_3 = NetworkLookup.sound_events[arg_15_1]
	local var_15_4 = NetworkLookup.sound_event_param_names[arg_15_2]

	var_15_1.network_transmit:send_rpc_clients("rpc_server_audio_unit_param_int_event", var_15_3, var_15_2, var_15_0, var_15_4, arg_15_3)
end

function AudioSystem.set_global_parameter_with_lerp(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0.global_parameter_data[arg_16_1] or {}

	var_16_0.interpolation_start_value = var_16_0.interpolation_current_value or 0
	var_16_0.interpolation_end_value = arg_16_2
	var_16_0.interpolation_progress_value = 0
	arg_16_0.global_parameter_data[arg_16_1] = var_16_0
end

function AudioSystem.set_global_parameter(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = Managers.world:wwise_world(arg_17_0.world)

	WwiseWorld.set_global_parameter(var_17_0, arg_17_1, arg_17_2)
end

function AudioSystem.play_audio_unit_param_float_event(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	local var_18_0 = arg_18_5 and Unit.node(arg_18_4, arg_18_5) or 0

	if not DEDICATED_SERVER then
		arg_18_0:_play_param_event(arg_18_1, arg_18_2, arg_18_3, arg_18_4, var_18_0)
	end

	local var_18_1 = Managers.state.network
	local var_18_2 = var_18_1:unit_game_object_id(arg_18_4)
	local var_18_3 = NetworkLookup.sound_events[arg_18_1]
	local var_18_4 = NetworkLookup.sound_event_param_names[arg_18_2]

	if arg_18_0.is_server then
		var_18_1.network_transmit:send_rpc_clients("rpc_server_audio_unit_param_float_event", var_18_3, var_18_2, var_18_0, var_18_4, arg_18_3)
	else
		var_18_1.network_transmit:send_rpc_server("rpc_server_audio_unit_param_float_event", var_18_3, var_18_2, var_18_0, var_18_4, arg_18_3)
	end
end

function AudioSystem._play_param_event(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	local var_19_0, var_19_1 = WwiseUtils.make_unit_auto_source(arg_19_0.world, arg_19_4, arg_19_5)

	WwiseWorld.set_source_parameter(var_19_1, var_19_0, arg_19_2, arg_19_3)
	WwiseWorld.trigger_event(var_19_1, arg_19_1, var_19_0)
end

function AudioSystem.vs_play_pactsworn_hit_enemy(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	local var_20_0 = Managers.state.game_mode:settings()

	if not arg_20_0.reset_sound_param_t or arg_20_5 > arg_20_0.reset_sound_param_t then
		arg_20_0.reset_sound_param_t = var_20_0.damage_sound_param_cooldown + arg_20_5
		arg_20_0.param_damage_amount = 0
	else
		arg_20_0.reset_sound_param_t = var_20_0.damage_sound_param_cooldown + arg_20_5
	end

	if arg_20_2 then
		if not arg_20_0.param_damage_amount then
			arg_20_0.param_damage_amount = math.clamp(arg_20_4, 0, 100)
		else
			arg_20_0.param_damage_amount = math.clamp(arg_20_0.param_damage_amount + arg_20_4, 0, 100)
		end

		arg_20_0:set_global_parameter("versus_pactsworn_damage_given", arg_20_0.param_damage_amount)
		arg_20_0:_play_position_event("versus_hit_indicator_local", arg_20_1)
	else
		Managers.state.network.network_transmit:send_rpc("rpc_vs_play_pactsworn_hit_enemy", arg_20_3.peer_id, arg_20_1, arg_20_4)
	end
end

function AudioSystem.rpc_vs_play_pactsworn_hit_enemy(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	if DEDICATED_SERVER then
		return
	end

	local var_21_0 = Managers.state.game_mode:settings()
	local var_21_1 = Managers.time:time("game")

	if not arg_21_0.reset_sound_param_t or var_21_1 > arg_21_0.reset_sound_param_t then
		arg_21_0.reset_sound_param_t = var_21_0.damage_sound_param_cooldown + var_21_1
		arg_21_0.param_damage_amount = 0
	else
		arg_21_0.reset_sound_param_t = var_21_0.damage_sound_param_cooldown + var_21_1
	end

	if not arg_21_0.param_damage_amount then
		arg_21_0.param_damage_amount = math.clamp(arg_21_3, 0, 100)
	else
		arg_21_0.param_damage_amount = math.clamp(arg_21_0.param_damage_amount + arg_21_3, 0, 100)
	end

	arg_21_0:set_global_parameter("versus_pactsworn_damage_given", arg_21_0.param_damage_amount)
	arg_21_0:_play_position_event("versus_hit_indicator_local", arg_21_2)
end

function AudioSystem.rpc_play_2d_audio_event(arg_22_0, arg_22_1, arg_22_2)
	if arg_22_0.is_server then
		local var_22_0 = CHANNEL_TO_PEER_ID[arg_22_1]

		arg_22_0.network_transmit:send_rpc_clients_except("rpc_play_2d_audio_event", var_22_0, arg_22_2)
	end

	if DEDICATED_SERVER then
		return
	end

	local var_22_1 = NetworkLookup.sound_events[arg_22_2]
	local var_22_2 = Managers.world:wwise_world(arg_22_0.world)

	WwiseWorld.trigger_event(var_22_2, var_22_1)
end

function AudioSystem.rpc_play_2d_audio_unit_event_for_peer(arg_23_0, arg_23_1, arg_23_2)
	if DEDICATED_SERVER then
		return
	end

	local var_23_0 = NetworkLookup.sound_events[arg_23_2]
	local var_23_1 = Managers.world:wwise_world(arg_23_0.world)

	WwiseWorld.trigger_event(var_23_1, var_23_0)
end

function AudioSystem.rpc_server_audio_event(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = Managers.world:wwise_world(arg_24_0.world)
	local var_24_1 = NetworkLookup.sound_events[arg_24_2]
	local var_24_2 = Managers.state.entity:system("surrounding_aware_system")
	local var_24_3
	local var_24_4 = "heard_sound"
	local var_24_5 = math.huge

	var_24_2:add_system_event(var_24_3, var_24_4, var_24_5, "heard_event", var_24_1)

	if DEDICATED_SERVER then
		return
	end

	WwiseWorld.trigger_event(var_24_0, var_24_1)
end

function AudioSystem.rpc_server_audio_event_at_pos(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	local var_25_0 = Managers.world:wwise_world(arg_25_0.world)
	local var_25_1 = NetworkLookup.sound_events[arg_25_2]
	local var_25_2 = Managers.state.entity:system("surrounding_aware_system")
	local var_25_3
	local var_25_4 = "heard_sound"
	local var_25_5 = math.huge

	var_25_2:add_system_event(var_25_3, var_25_4, var_25_5, "heard_event", var_25_1)

	if DEDICATED_SERVER then
		return
	end

	WwiseWorld.trigger_event(var_25_0, var_25_1, arg_25_3)
end

function AudioSystem.rpc_server_audio_unit_event(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5)
	if arg_26_0.is_server then
		local var_26_0 = CHANNEL_TO_PEER_ID[arg_26_1]

		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_server_audio_unit_event", var_26_0, arg_26_2, arg_26_3, arg_26_4, arg_26_5)
	end

	if DEDICATED_SERVER then
		return
	end

	local var_26_1 = NetworkLookup.sound_events[arg_26_2]
	local var_26_2 = Managers.state.network:game_object_or_level_unit(arg_26_3, arg_26_4)

	if var_26_2 then
		arg_26_0:_play_event(var_26_1, var_26_2, arg_26_5)
	end
end

function AudioSystem.rpc_server_audio_position_event(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	if arg_27_0.is_server then
		local var_27_0 = CHANNEL_TO_PEER_ID[arg_27_1]

		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_server_audio_position_event", var_27_0, arg_27_2, arg_27_3)
	end

	if DEDICATED_SERVER then
		return
	end

	local var_27_1 = NetworkLookup.sound_events[arg_27_2]

	arg_27_0:_play_position_event(var_27_1, arg_27_3)
end

function AudioSystem.rpc_server_audio_unit_dialogue_event(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	if arg_28_0.is_server then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_server_audio_unit_dialogue_event", arg_28_2, arg_28_3)
	end

	if DEDICATED_SERVER then
		return
	end

	local var_28_0 = NetworkLookup.sound_events[arg_28_2]
	local var_28_1 = arg_28_0.unit_storage:unit(arg_28_3)
	local var_28_2 = ScriptUnit.has_extension(var_28_1, "dialogue_system")

	if var_28_2 then
		local var_28_3 = var_28_2.wwise_voice_switch_group
		local var_28_4, var_28_5 = WwiseUtils.make_unit_auto_source(arg_28_0.world, var_28_1, var_28_2.voice_node)

		if var_28_3 then
			local var_28_6 = var_28_2.wwise_voice_switch_value

			WwiseWorld.set_switch(var_28_5, var_28_3, var_28_6, var_28_4)
		end

		arg_28_0:_play_event_with_source(var_28_5, var_28_0, var_28_4)
	end
end

function AudioSystem.rpc_server_audio_unit_param_string_event(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6)
	if arg_29_0.is_server then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_server_audio_unit_param_string_event", arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6)
	end

	if DEDICATED_SERVER then
		return
	end

	local var_29_0 = NetworkLookup.sound_events[arg_29_2]
	local var_29_1 = arg_29_0.unit_storage:unit(arg_29_3)
	local var_29_2 = NetworkLookup.sound_event_param_names[arg_29_5]
	local var_29_3 = NetworkLookup.sound_event_param_string_values[arg_29_6]

	arg_29_0:_play_param_event(var_29_0, var_29_2, var_29_3, var_29_1, arg_29_4)
end

function AudioSystem.rpc_server_audio_unit_param_int_event(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5, arg_30_6)
	if arg_30_0.is_server then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_server_audio_unit_param_int_event", arg_30_2, arg_30_3, arg_30_4, arg_30_5, arg_30_6)
	end

	if DEDICATED_SERVER then
		return
	end

	local var_30_0 = NetworkLookup.sound_events[arg_30_2]
	local var_30_1 = arg_30_0.unit_storage:unit(arg_30_3)
	local var_30_2 = NetworkLookup.sound_event_param_names[arg_30_5]

	arg_30_0:_play_param_event(var_30_0, var_30_2, arg_30_6, var_30_1, arg_30_4)
end

function AudioSystem.rpc_server_audio_unit_param_float_event(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5, arg_31_6)
	if arg_31_0.is_server then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_server_audio_unit_param_float_event", arg_31_2, arg_31_3, arg_31_4, arg_31_5, arg_31_6)
	end

	if DEDICATED_SERVER then
		return
	end

	local var_31_0 = NetworkLookup.sound_events[arg_31_2]
	local var_31_1 = arg_31_0.unit_storage:unit(arg_31_3)
	local var_31_2 = NetworkLookup.sound_event_param_names[arg_31_5]

	arg_31_0:_play_param_event(var_31_0, var_31_2, arg_31_6, var_31_1, arg_31_4)
end

function AudioSystem.rpc_client_audio_set_global_parameter_with_lerp(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	local var_32_0 = NetworkLookup.global_parameter_names[arg_32_2]
	local var_32_1 = arg_32_3 * 100

	if DEDICATED_SERVER then
		return
	end

	arg_32_0:set_global_parameter_with_lerp(var_32_0, var_32_1)
end

function AudioSystem.rpc_client_audio_set_global_parameter(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	local var_33_0 = NetworkLookup.global_parameter_names[arg_33_2]

	if DEDICATED_SERVER then
		return
	end

	arg_33_0:set_global_parameter(var_33_0, arg_33_3)
end

function AudioSystem.rpc_vs_play_matchmaking_sfx(arg_34_0, arg_34_1, arg_34_2)
	if DEDICATED_SERVER then
		return
	end

	local var_34_0 = CHANNEL_TO_PEER_ID[arg_34_1]

	if var_34_0 == Network.peer_id() then
		return
	end

	if arg_34_0.is_server then
		arg_34_0.network_transmit:send_rpc_clients_except("rpc_play_2d_audio_event", var_34_0, arg_34_2)
	end

	local var_34_1 = NetworkLookup.sound_events[arg_34_2]
	local var_34_2 = Managers.world:wwise_world(arg_34_0.world)

	WwiseWorld.trigger_event(var_34_2, var_34_1)
end
