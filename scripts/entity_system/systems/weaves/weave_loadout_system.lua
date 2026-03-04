-- chunkname: @scripts/entity_system/systems/weaves/weave_loadout_system.lua

require("scripts/unit_extensions/default_player_unit/weaves/player_unit_weave_loadout_extension")
require("scripts/unit_extensions/default_player_unit/weaves/player_husk_weave_loadout_extension")

WeaveLoadoutSystem = class(WeaveLoadoutSystem, ExtensionSystemBase)

local var_0_0 = {
	"rpc_add_weave_buffs"
}
local var_0_1 = {
	"PlayerUnitWeaveLoadoutExtension",
	"PlayerHuskWeaveLoadoutExtension"
}

WeaveLoadoutSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	WeaveLoadoutSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_0))
end

WeaveLoadoutSystem.destroy = function (arg_2_0)
	arg_2_0.network_event_delegate:unregister(arg_2_0)

	arg_2_0.network_event_delegate = nil
end

WeaveLoadoutSystem.rpc_add_weave_buffs = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	if arg_3_0.is_server then
		local var_3_0 = CHANNEL_TO_PEER_ID[arg_3_1]

		arg_3_0.network_transmit:send_rpc_clients_except("rpc_add_weave_buffs", var_3_0, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	end

	local var_3_1 = arg_3_0.unit_storage:unit(arg_3_2)

	ScriptUnit.extension(var_3_1, "weave_loadout_system"):add_buffs(arg_3_3, arg_3_4, arg_3_5, arg_3_6)
end
