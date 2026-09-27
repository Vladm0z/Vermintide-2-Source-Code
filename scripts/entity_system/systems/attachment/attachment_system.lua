-- chunkname: @scripts/entity_system/systems/attachment/attachment_system.lua

require("scripts/unit_extensions/default_player_unit/attachment/player_unit_attachment_extension")
require("scripts/unit_extensions/default_player_unit/attachment/player_husk_attachment_extension")

AttachmentSystem = class(AttachmentSystem, ExtensionSystemBase)

local tbl = {
	"rpc_create_attachment",
	"rpc_remove_attachment",
	"rpc_add_attachment_buffs"
}
local tbl_2 = {
	"PlayerUnitAttachmentExtension",
	"PlayerHuskAttachmentExtension"
}

AttachmentSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	AttachmentSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))
end

AttachmentSystem.destroy = function (self)
	-- function 2
	self.network_event_delegate:unregister(self)

	self.network_event_delegate = nil
end

AttachmentSystem.on_add_extension = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	arg_3_4.is_server = self.is_server

	return AttachmentSystem.super.on_add_extension(self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
end

AttachmentSystem.create_attachment = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local extension = ScriptUnit.extension(arg_4_1, "attachment_system")
	local var_4_1 = NetworkLookup.equipment_slots[arg_4_2]
	local var_4_2 = NetworkLookup.item_names[arg_4_3]
	local var_4_3 = ItemMasterList[var_4_2]

	extension:create_attachment(var_4_1, var_4_3)
end

AttachmentSystem.remove_attachment = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	local extension = ScriptUnit.extension(arg_5_1, "attachment_system")
	local var_5_1 = NetworkLookup.equipment_slots[arg_5_2]

	extension:remove_attachment(var_5_1)
end

AttachmentSystem.add_attachment_buffs = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6)
	-- function 6
	local var_6_0 = NetworkLookup.equipment_slots[arg_6_2]
	local buffs_from_rpc_params = BuffUtils.buffs_from_rpc_params(arg_6_3, arg_6_4, arg_6_5, arg_6_6)

	ScriptUnit.extension(arg_6_1, "attachment_system"):set_buffs_to_slot(var_6_0, buffs_from_rpc_params)
end

AttachmentSystem.rpc_create_attachment = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	if not self.is_server then
		local var_7_0 = CHANNEL_TO_PEER_ID[arg_7_1]

		self.network_transmit:send_rpc_clients_except("rpc_create_attachment", var_7_0, arg_7_2, arg_7_3, arg_7_4)
	end

	local unit = self.unit_storage:unit(arg_7_2)

	self:create_attachment(unit, arg_7_3, arg_7_4)
end

AttachmentSystem.rpc_remove_attachment = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	if not self.is_server then
		local var_8_0 = CHANNEL_TO_PEER_ID[arg_8_1]

		self.network_transmit:send_rpc_clients_except("rpc_remove_attachment", var_8_0, arg_8_2, arg_8_3)
	end

	local unit = self.unit_storage:unit(arg_8_2)

	self:remove_attachment(unit, arg_8_3)
end

AttachmentSystem.rpc_add_attachment_buffs = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
	-- function 9
	if not self.is_server then
		local var_9_0 = CHANNEL_TO_PEER_ID[arg_9_1]

		self.network_transmit:send_rpc_clients_except("rpc_add_attachment_buffs", var_9_0, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
	end

	local unit = self.unit_storage:unit(arg_9_2)

	self:add_attachment_buffs(unit, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
end
