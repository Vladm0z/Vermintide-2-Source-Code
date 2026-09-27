-- chunkname: @scripts/entity_system/systems/weaves/weave_loadout_system.lua

require("scripts/unit_extensions/default_player_unit/weaves/player_unit_weave_loadout_extension")
require("scripts/unit_extensions/default_player_unit/weaves/player_husk_weave_loadout_extension")

WeaveLoadoutSystem = class(WeaveLoadoutSystem, ExtensionSystemBase)

local tbl = {
	"rpc_add_weave_buffs"
}
local tbl_2 = {
	"PlayerUnitWeaveLoadoutExtension",
	"PlayerHuskWeaveLoadoutExtension"
}

WeaveLoadoutSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	WeaveLoadoutSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))
end

WeaveLoadoutSystem.destroy = function (self)
	-- function 2
	self.network_event_delegate:unregister(self)

	self.network_event_delegate = nil
end

WeaveLoadoutSystem.rpc_add_weave_buffs = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	if not self.is_server then
		local var_3_0 = CHANNEL_TO_PEER_ID[arg_3_1]

		self.network_transmit:send_rpc_clients_except("rpc_add_weave_buffs", var_3_0, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	end

	local unit = self.unit_storage:unit(arg_3_2)

	ScriptUnit.extension(unit, "weave_loadout_system"):add_buffs(arg_3_3, arg_3_4, arg_3_5, arg_3_6)
end
