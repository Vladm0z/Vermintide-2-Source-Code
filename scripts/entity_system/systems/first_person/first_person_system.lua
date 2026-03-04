-- chunkname: @scripts/entity_system/systems/first_person/first_person_system.lua

require("scripts/unit_extensions/default_player_unit/player_unit_first_person")
require("scripts/unit_extensions/human/player_bot_unit/player_bot_unit_first_person")

FirstPersonSystem = class(FirstPersonSystem, ExtensionSystemBase)

local var_0_0 = {
	"rpc_play_hud_sound_event",
	"rpc_play_first_person_sound",
	"rpc_play_husk_sound_event",
	"rpc_play_husk_unit_sound_event",
	"rpc_first_person_flow_event"
}
local var_0_1 = {
	"PlayerUnitFirstPerson",
	"PlayerBotUnitFirstPerson"
}

function FirstPersonSystem.init(arg_1_0, arg_1_1, arg_1_2)
	FirstPersonSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_0))
end

function FirstPersonSystem.destroy(arg_2_0)
	arg_2_0.network_event_delegate:unregister(arg_2_0)

	arg_2_0.network_event_delegate = nil
end

function FirstPersonSystem.rpc_play_first_person_sound(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = NetworkLookup.sound_events[arg_3_3]
	local var_3_1 = arg_3_0.unit_storage:unit(arg_3_2)

	if not var_3_1 then
		printf("unit from game_object_id %d is nil", arg_3_2)

		return
	end

	ScriptUnit.extension(var_3_1, "first_person_system"):play_sound_event(var_3_0, arg_3_4)
end

function FirstPersonSystem.rpc_play_hud_sound_event(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_0.unit_storage:unit(arg_4_2)

	if not var_4_0 then
		printf("unit from game_object_id %d is nil", arg_4_2)

		return
	end

	local var_4_1 = NetworkLookup.sound_events[arg_4_3]

	ScriptUnit.extension(var_4_0, "first_person_system"):play_hud_sound_event(var_4_1)
end

function FirstPersonSystem.rpc_play_husk_sound_event(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	if arg_5_0.is_server then
		local var_5_0 = CHANNEL_TO_PEER_ID[arg_5_1]

		arg_5_0.network_transmit:send_rpc_clients_except("rpc_play_husk_sound_event", var_5_0, arg_5_2, arg_5_3)
	end

	local var_5_1 = arg_5_0.unit_storage:unit(arg_5_2)

	if not var_5_1 then
		printf("unit from game_object_id %d is nil", arg_5_2)

		return
	end

	local var_5_2 = NetworkLookup.sound_events[arg_5_3]
	local var_5_3, var_5_4 = WwiseUtils.make_unit_auto_source(arg_5_0.world, var_5_1)

	WwiseWorld.set_switch(var_5_4, "husk", "true", var_5_3)
	WwiseWorld.trigger_event(var_5_4, var_5_2, var_5_3)
end

function FirstPersonSystem.rpc_play_husk_unit_sound_event(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	if arg_6_0.is_server then
		local var_6_0 = CHANNEL_TO_PEER_ID[arg_6_1]

		arg_6_0.network_transmit:send_rpc_clients_except("rpc_play_husk_unit_sound_event", var_6_0, arg_6_2, arg_6_3, arg_6_4)
	end

	local var_6_1 = arg_6_0.unit_storage:unit(arg_6_2)

	if not var_6_1 then
		printf("unit from game_object_id %d is nil", arg_6_2)

		return
	end

	local var_6_2 = NetworkLookup.sound_events[arg_6_4]
	local var_6_3, var_6_4 = WwiseUtils.make_unit_auto_source(arg_6_0.world, var_6_1, arg_6_3)

	WwiseWorld.set_switch(var_6_4, "husk", "true", var_6_3)
	WwiseWorld.trigger_event(var_6_4, var_6_2, var_6_3)
end

function FirstPersonSystem.rpc_first_person_flow_event(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_0.unit_storage:unit(arg_7_2)

	if not var_7_0 then
		printf("unit from game_object_id %d is nil", arg_7_2)

		return
	end

	local var_7_1 = ScriptUnit.has_extension(var_7_0, "first_person_system")

	if var_7_1 then
		local var_7_2 = var_7_1:get_first_person_unit()
		local var_7_3 = NetworkLookup.flow_events[arg_7_3]

		Unit.flow_event(var_7_2, var_7_3)
	end
end
