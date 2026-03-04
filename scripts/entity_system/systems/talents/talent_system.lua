-- chunkname: @scripts/entity_system/systems/talents/talent_system.lua

require("scripts/helpers/talent_utils")

TalentSystem = class(TalentSystem, ExtensionSystemBase)

local var_0_0 = {
	"rpc_sync_talents"
}
local var_0_1 = {
	"TalentExtension",
	"HuskTalentExtension"
}

TalentSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	TalentSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_0))
end

TalentSystem.destroy = function (arg_2_0)
	arg_2_0.network_event_delegate:unregister(arg_2_0)

	arg_2_0.network_event_delegate = nil
end

TalentSystem.on_add_extension = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	return (TalentSystem.super.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4))
end

TalentSystem.rpc_sync_talents = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	printf("TalentSystem:rpc_sync_talents %d %d", arg_4_1, arg_4_2)

	local var_4_0 = arg_4_0.unit_storage:unit(arg_4_2)
	local var_4_1 = ScriptUnit.extension(var_4_0, "talent_system")

	var_4_1:set_talent_ids(arg_4_3)
	var_4_1:apply_buffs_from_talents()

	if arg_4_0.is_server then
		local var_4_2 = CHANNEL_TO_PEER_ID[arg_4_1]

		arg_4_0.network_transmit:send_rpc_clients_except("rpc_sync_talents", var_4_2, arg_4_2, arg_4_3)
	end
end

TalentSystem.hot_join_sync = function (arg_5_0, arg_5_1)
	if not arg_5_0.is_server then
		return
	end

	local var_5_0 = arg_5_0.network_transmit
	local var_5_1 = arg_5_0.unit_storage

	for iter_5_0, iter_5_1 in ipairs(var_0_1) do
		local var_5_2 = arg_5_0.entity_manager:get_entities(iter_5_1)

		for iter_5_2, iter_5_3 in pairs(var_5_2) do
			local var_5_3 = var_5_1:go_id(iter_5_2)
			local var_5_4 = iter_5_3:get_talent_ids()

			var_5_0:send_rpc("rpc_sync_talents", arg_5_1, var_5_3, var_5_4)
		end
	end
end
