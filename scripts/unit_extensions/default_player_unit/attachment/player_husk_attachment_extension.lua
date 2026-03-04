-- chunkname: @scripts/unit_extensions/default_player_unit/attachment/player_husk_attachment_extension.lua

PlayerHuskAttachmentExtension = class(PlayerHuskAttachmentExtension)

function PlayerHuskAttachmentExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._world = arg_1_1.world
	arg_1_0._unit = arg_1_2

	local var_1_0 = arg_1_3.profile

	arg_1_0._slots, arg_1_0._profile = arg_1_3.slots, var_1_0
	arg_1_0._attachments = {
		slots = {}
	}
	arg_1_0._synced_slot_buffs = {}
	arg_1_0.current_item_buffs = {}
end

function PlayerHuskAttachmentExtension.extensions_ready(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.buff_extension = ScriptUnit.extension(arg_2_2, "buff_system")
	arg_2_0._cosmetic_extension = ScriptUnit.extension(arg_2_2, "cosmetic_system")
	arg_2_0._tp_unit_mesh = arg_2_0._cosmetic_extension:get_third_person_mesh_unit()

	Unit.flow_event(arg_2_0._tp_unit_mesh, "lua_attachment_unhidden")
end

function PlayerHuskAttachmentExtension.destroy(arg_3_0)
	local var_3_0 = arg_3_0._attachments.slots

	for iter_3_0, iter_3_1 in pairs(var_3_0) do
		AttachmentUtils.destroy_attachment(arg_3_0._world, arg_3_0._unit, iter_3_1)
	end
end

function PlayerHuskAttachmentExtension.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	return
end

function PlayerHuskAttachmentExtension.hot_join_sync(arg_5_0, arg_5_1)
	AttachmentUtils.hot_join_sync(arg_5_1, arg_5_0._unit, arg_5_0._attachments.slots, arg_5_0._synced_slot_buffs)
end

function PlayerHuskAttachmentExtension.create_attachment(arg_6_0, arg_6_1, arg_6_2)
	if not arg_6_0._profile then
		return
	end

	local var_6_0 = arg_6_0._unit
	local var_6_1 = arg_6_0._attachments

	if var_6_1.slots[arg_6_1] then
		arg_6_0:remove_attachment(arg_6_1)
	end

	local var_6_2 = BackendUtils.get_item_template(arg_6_2)
	local var_6_3 = var_6_0

	if var_6_2.link_to_skin then
		var_6_3 = arg_6_0._tp_unit_mesh
	end

	local var_6_4 = AttachmentUtils.create_attachment(arg_6_0._world, var_6_3, var_6_1, arg_6_1, arg_6_2, true)
	local var_6_5 = var_6_2.show_attachments_event

	if var_6_5 then
		Unit.flow_event(arg_6_0._tp_unit_mesh, var_6_5)
		Unit.flow_event(var_6_0, var_6_5)
	end

	arg_6_0:_show_attachment(arg_6_1, var_6_4, true)

	var_6_1.slots[arg_6_1] = var_6_4

	if not DEDICATED_SERVER then
		ScriptUnit.extension(var_6_0, "outline_system"):reapply_outline()
	end

	local var_6_6 = ScriptUnit.has_extension(var_6_0, "cosmetic_system")

	if var_6_6 and arg_6_1 == "slot_hat" then
		local var_6_7 = var_6_2.character_material_changes

		if var_6_7 then
			var_6_6:change_skin_materials(var_6_7)
		end
	end
end

function PlayerHuskAttachmentExtension.remove_attachment(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._attachments.slots[arg_7_1]

	AttachmentUtils.destroy_attachment(arg_7_0._world, arg_7_0._unit, var_7_0)

	if arg_7_0.current_item_buffs[arg_7_1] then
		arg_7_0:_remove_buffs(arg_7_1)
	end

	arg_7_0._attachments.slots[arg_7_1] = nil
end

function PlayerHuskAttachmentExtension.attachments(arg_8_0)
	return arg_8_0._attachments
end

function PlayerHuskAttachmentExtension.get_slot_data(arg_9_0, arg_9_1)
	return arg_9_0._attachments.slots[arg_9_1]
end

function PlayerHuskAttachmentExtension.show_attachments(arg_10_0, arg_10_1)
	if arg_10_0._show_attachments ~= arg_10_1 then
		local var_10_0 = arg_10_0._attachments.slots

		for iter_10_0, iter_10_1 in pairs(var_10_0) do
			if iter_10_1.unit then
				arg_10_0:_show_attachment(iter_10_0, iter_10_1, arg_10_1)
			end
		end

		local var_10_1 = arg_10_1 and "lua_attachment_unhidden" or "lua_attachment_hidden"

		Unit.flow_event(arg_10_0._tp_unit_mesh, var_10_1)

		arg_10_0._show_attachments = arg_10_1
	end
end

function PlayerHuskAttachmentExtension._show_attachment(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = arg_11_3

	if arg_11_0._cosmetic_extension:always_hide_attachment_slot(arg_11_1) then
		var_11_0 = false
	end

	local var_11_1 = arg_11_2.unit

	if var_11_1 then
		Unit.set_unit_visibility(var_11_1, var_11_0)

		if var_11_0 then
			Unit.flow_event(var_11_1, "lua_attachment_unhidden")
			arg_11_0._cosmetic_extension:trigger_equip_events(arg_11_1, var_11_1)
		else
			Unit.flow_event(var_11_1, "lua_attachment_hidden")
		end
	end
end

local var_0_0 = {}

function PlayerHuskAttachmentExtension._apply_buffs(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = ScriptUnit.extension(arg_12_0._unit, "buff_system")
	local var_12_1 = arg_12_0.current_item_buffs[arg_12_2] or {}
	local var_12_2 = 1

	for iter_12_0, iter_12_1 in pairs(arg_12_1) do
		table.clear(var_0_0)

		for iter_12_2, iter_12_3 in pairs(iter_12_1) do
			var_0_0[iter_12_2] = iter_12_3
		end

		var_12_1[var_12_2] = var_12_0:add_buff(iter_12_0, var_0_0)
		var_12_2 = var_12_2 + 1
	end

	arg_12_0.current_item_buffs[arg_12_2] = var_12_1
end

function PlayerHuskAttachmentExtension._remove_buffs(arg_13_0, arg_13_1)
	local var_13_0 = ScriptUnit.extension(arg_13_0._unit, "buff_system")
	local var_13_1 = arg_13_0.current_item_buffs[arg_13_1]

	for iter_13_0 = 1, #var_13_1 do
		local var_13_2 = var_13_1[iter_13_0]

		var_13_0:remove_buff(var_13_2)
	end

	table.clear(var_13_1)
end

function PlayerHuskAttachmentExtension.set_buffs_to_slot(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0._synced_slot_buffs[arg_14_1] or {}

	table.clear(var_14_0)

	arg_14_0._synced_slot_buffs[arg_14_1] = arg_14_2

	arg_14_0:_apply_buffs(arg_14_2, arg_14_1)
end
