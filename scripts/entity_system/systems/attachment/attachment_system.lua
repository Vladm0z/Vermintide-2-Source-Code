-- chunkname: @scripts/entity_system/systems/attachment/attachment_system.lua

require("scripts/unit_extensions/default_player_unit/attachment/player_unit_attachment_extension")
require("scripts/unit_extensions/default_player_unit/attachment/player_husk_attachment_extension")

AttachmentSystem = class(AttachmentSystem, ExtensionSystemBase)

local var_0_0 = {
	"rpc_create_attachment",
	"rpc_remove_attachment",
	"rpc_add_attachment_buffs"
}
local var_0_1 = {
	"PlayerUnitAttachmentExtension",
	"PlayerHuskAttachmentExtension"
}

function AttachmentSystem.init(arg_1_0, arg_1_1, arg_1_2)
	AttachmentSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_0))
end

function AttachmentSystem.destroy(arg_2_0)
	arg_2_0.network_event_delegate:unregister(arg_2_0)

	arg_2_0.network_event_delegate = nil
end

function AttachmentSystem.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_4.is_server = arg_3_0.is_server

	return AttachmentSystem.super.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
end

function AttachmentSystem.create_attachment(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = ScriptUnit.extension(arg_4_1, "attachment_system")
	local var_4_1 = NetworkLookup.equipment_slots[arg_4_2]
	local var_4_2 = NetworkLookup.item_names[arg_4_3]
	local var_4_3 = ItemMasterList[var_4_2]

	var_4_0:create_attachment(var_4_1, var_4_3)
end

function AttachmentSystem.remove_attachment(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = ScriptUnit.extension(arg_5_1, "attachment_system")
	local var_5_1 = NetworkLookup.equipment_slots[arg_5_2]

	var_5_0:remove_attachment(var_5_1)
end

function AttachmentSystem.add_attachment_buffs(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6)
	local var_6_0 = NetworkLookup.equipment_slots[arg_6_2]
	local var_6_1 = BuffUtils.buffs_from_rpc_params(arg_6_3, arg_6_4, arg_6_5, arg_6_6)

	ScriptUnit.extension(arg_6_1, "attachment_system"):set_buffs_to_slot(var_6_0, var_6_1)
end

function AttachmentSystem.rpc_create_attachment(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	if arg_7_0.is_server then
		local var_7_0 = CHANNEL_TO_PEER_ID[arg_7_1]

		arg_7_0.network_transmit:send_rpc_clients_except("rpc_create_attachment", var_7_0, arg_7_2, arg_7_3, arg_7_4)
	end

	local var_7_1 = arg_7_0.unit_storage:unit(arg_7_2)

	arg_7_0:create_attachment(var_7_1, arg_7_3, arg_7_4)
end

function AttachmentSystem.rpc_remove_attachment(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	if arg_8_0.is_server then
		local var_8_0 = CHANNEL_TO_PEER_ID[arg_8_1]

		arg_8_0.network_transmit:send_rpc_clients_except("rpc_remove_attachment", var_8_0, arg_8_2, arg_8_3)
	end

	local var_8_1 = arg_8_0.unit_storage:unit(arg_8_2)

	arg_8_0:remove_attachment(var_8_1, arg_8_3)
end

function AttachmentSystem.rpc_add_attachment_buffs(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
	if arg_9_0.is_server then
		local var_9_0 = CHANNEL_TO_PEER_ID[arg_9_1]

		arg_9_0.network_transmit:send_rpc_clients_except("rpc_add_attachment_buffs", var_9_0, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
	end

	local var_9_1 = arg_9_0.unit_storage:unit(arg_9_2)

	arg_9_0:add_attachment_buffs(var_9_1, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
end
