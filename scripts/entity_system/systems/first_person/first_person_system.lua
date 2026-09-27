-- chunkname: @scripts/entity_system/systems/first_person/first_person_system.lua

require("scripts/unit_extensions/default_player_unit/player_unit_first_person")
require("scripts/unit_extensions/human/player_bot_unit/player_bot_unit_first_person")

FirstPersonSystem = class(FirstPersonSystem, ExtensionSystemBase)

local tbl = {
	"rpc_play_hud_sound_event",
	"rpc_play_first_person_sound",
	"rpc_play_husk_sound_event",
	"rpc_play_husk_unit_sound_event",
	"rpc_first_person_flow_event"
}
local tbl_2 = {
	"PlayerUnitFirstPerson",
	"PlayerBotUnitFirstPerson"
}

FirstPersonSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	FirstPersonSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))
end

FirstPersonSystem.destroy = function (self)
	-- function 2
	self.network_event_delegate:unregister(self)

	self.network_event_delegate = nil
end

FirstPersonSystem.rpc_play_first_person_sound = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local var_3_0 = NetworkLookup.sound_events[arg_3_3]
	local unit = self.unit_storage:unit(arg_3_2)

	if not unit then
		printf("unit from game_object_id %d is nil", arg_3_2)

		return
	end

	ScriptUnit.extension(unit, "first_person_system"):play_sound_event(var_3_0, arg_3_4)
end

FirstPersonSystem.rpc_play_hud_sound_event = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local unit = self.unit_storage:unit(arg_4_2)

	if not unit then
		printf("unit from game_object_id %d is nil", arg_4_2)

		return
	end

	local var_4_1 = NetworkLookup.sound_events[arg_4_3]

	ScriptUnit.extension(unit, "first_person_system"):play_hud_sound_event(var_4_1)
end

FirstPersonSystem.rpc_play_husk_sound_event = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	if not self.is_server then
		local var_5_0 = CHANNEL_TO_PEER_ID[arg_5_1]

		self.network_transmit:send_rpc_clients_except("rpc_play_husk_sound_event", var_5_0, arg_5_2, arg_5_3)
	end

	local unit = self.unit_storage:unit(arg_5_2)

	if not unit then
		printf("unit from game_object_id %d is nil", arg_5_2)

		return
	end

	local var_5_2 = NetworkLookup.sound_events[arg_5_3]
	local make_unit_auto_source, var_5_4 = WwiseUtils.make_unit_auto_source(self.world, unit)

	WwiseWorld.set_switch(var_5_4, "husk", "true", make_unit_auto_source)
	WwiseWorld.trigger_event(var_5_4, var_5_2, make_unit_auto_source)
end

FirstPersonSystem.rpc_play_husk_unit_sound_event = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	if not self.is_server then
		local var_6_0 = CHANNEL_TO_PEER_ID[arg_6_1]

		self.network_transmit:send_rpc_clients_except("rpc_play_husk_unit_sound_event", var_6_0, arg_6_2, arg_6_3, arg_6_4)
	end

	local unit = self.unit_storage:unit(arg_6_2)

	if not unit then
		printf("unit from game_object_id %d is nil", arg_6_2)

		return
	end

	local var_6_2 = NetworkLookup.sound_events[arg_6_4]
	local make_unit_auto_source, var_6_4 = WwiseUtils.make_unit_auto_source(self.world, unit, arg_6_3)

	WwiseWorld.set_switch(var_6_4, "husk", "true", make_unit_auto_source)
	WwiseWorld.trigger_event(var_6_4, var_6_2, make_unit_auto_source)
end

FirstPersonSystem.rpc_first_person_flow_event = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local unit = self.unit_storage:unit(arg_7_2)

	if not unit then
		printf("unit from game_object_id %d is nil", arg_7_2)

		return
	end

	local has_extension = ScriptUnit.has_extension(unit, "first_person_system")

	if not has_extension then
		local get_first_person_unit = has_extension:get_first_person_unit()
		local var_7_3 = NetworkLookup.flow_events[arg_7_3]

		Unit.flow_event(get_first_person_unit, var_7_3)
	end
end
