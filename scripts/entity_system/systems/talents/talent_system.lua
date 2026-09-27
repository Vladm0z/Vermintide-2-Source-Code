-- chunkname: @scripts/entity_system/systems/talents/talent_system.lua

require("scripts/helpers/talent_utils")

TalentSystem = class(TalentSystem, ExtensionSystemBase)

local tbl = {
	"rpc_sync_talents"
}
local tbl_2 = {
	"TalentExtension",
	"HuskTalentExtension"
}

TalentSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	TalentSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))
end

TalentSystem.destroy = function (self)
	-- function 2
	self.network_event_delegate:unregister(self)

	self.network_event_delegate = nil
end

TalentSystem.on_add_extension = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	return (TalentSystem.super.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4))
end

TalentSystem.rpc_sync_talents = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	printf("TalentSystem:rpc_sync_talents %d %d", arg_4_1, arg_4_2)

	local unit = self.unit_storage:unit(arg_4_2)
	local extension = ScriptUnit.extension(unit, "talent_system")

	extension:set_talent_ids(arg_4_3)
	extension:apply_buffs_from_talents()

	if not self.is_server then
		local var_4_2 = CHANNEL_TO_PEER_ID[arg_4_1]

		self.network_transmit:send_rpc_clients_except("rpc_sync_talents", var_4_2, arg_4_2, arg_4_3)
	end
end

TalentSystem.hot_join_sync = function (self, arg_5_1)
	-- function 5
	if not self.is_server then
		return
	end

	local network_transmit = self.network_transmit
	local unit_storage = self.unit_storage

	for i, v in ipairs(tbl_2) do
		local get_entities = self.entity_manager:get_entities(v)

		for k, v_2 in pairs(get_entities) do
			local go_id = unit_storage:go_id(k)
			local get_talent_ids = v_2:get_talent_ids()

			network_transmit:send_rpc("rpc_sync_talents", arg_5_1, go_id, get_talent_ids)
		end
	end
end
