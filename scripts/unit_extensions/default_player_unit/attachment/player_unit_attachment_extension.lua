-- chunkname: @scripts/unit_extensions/default_player_unit/attachment/player_unit_attachment_extension.lua

require("scripts/helpers/attachment_utils")
require("scripts/managers/backend/backend_utils")

PlayerUnitAttachmentExtension = class(PlayerUnitAttachmentExtension)
script_data.attachment_debug = script_data.attachment_debug or Development.parameter("attachment_debug")

PlayerUnitAttachmentExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._world = arg_1_1.world
	arg_1_0._unit = arg_1_2
	arg_1_0._profile = arg_1_3.profile
	arg_1_0._is_server = arg_1_3.is_server
	arg_1_0._player = arg_1_3.player
	arg_1_0._profile_index = FindProfileIndex(arg_1_0._profile.display_name)
	arg_1_0.current_item_buffs = {}
	arg_1_0._attachments = {
		slots = {}
	}
	arg_1_0._synced_slot_buffs = {}
end

PlayerUnitAttachmentExtension.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.buff_extension = ScriptUnit.extension(arg_2_2, "buff_system")
	arg_2_0.career_extension = ScriptUnit.extension(arg_2_2, "career_system")
	arg_2_0._cosmetic_extension = ScriptUnit.extension(arg_2_2, "cosmetic_system")
	arg_2_0._tp_unit_mesh = arg_2_0._cosmetic_extension:get_third_person_mesh_unit()

	local var_2_0 = arg_2_0._attachments
	local var_2_1 = arg_2_0._profile
	local var_2_2 = InventorySettings.attachment_slots
	local var_2_3 = #var_2_2
	local var_2_4 = arg_2_0.career_extension:career_name()
	local var_2_5 = arg_2_0._player.bot_player

	for iter_2_0 = 1, var_2_3 do
		repeat
			local var_2_6 = var_2_2[iter_2_0].name
			local var_2_7 = BackendUtils.get_loadout_item(var_2_4, var_2_6, var_2_5)

			if var_2_7 then
				local var_2_8 = table.clone(var_2_7.data)

				var_2_8.backend_id = var_2_7.backend_id

				arg_2_0:create_attachment(var_2_6, var_2_8)
			end
		until true
	end

	arg_2_0:show_attachments(false)
end

PlayerUnitAttachmentExtension.game_object_initialized = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_0._attachments.slots
	local var_3_1 = Managers.state.network
	local var_3_2 = arg_3_0._is_server

	for iter_3_0, iter_3_1 in pairs(var_3_0) do
		local var_3_3 = NetworkLookup.equipment_slots[iter_3_0]
		local var_3_4 = NetworkLookup.item_names[iter_3_1.item_data.name]

		if var_3_2 then
			var_3_1.network_transmit:send_rpc_clients("rpc_create_attachment", arg_3_2, var_3_3, var_3_4)
		else
			var_3_1.network_transmit:send_rpc_server("rpc_create_attachment", arg_3_2, var_3_3, var_3_4)
		end

		local var_3_5 = iter_3_1.item_data.backend_id
		local var_3_6 = arg_3_0:_get_property_and_trait_buffs(var_3_5)
		local var_3_7 = {}
		local var_3_8 = table.merge(var_3_7, var_3_6.server)
		local var_3_9 = table.merge(var_3_8, var_3_6.both)

		if table.size(var_3_9) > 0 then
			arg_3_0:_send_rpc_add_attachment_buffs(arg_3_2, var_3_3, var_3_9)

			arg_3_0._synced_slot_buffs[iter_3_0] = var_3_9
		end
	end
end

PlayerUnitAttachmentExtension.destroy = function (arg_4_0)
	local var_4_0 = arg_4_0._attachments.slots

	for iter_4_0, iter_4_1 in pairs(var_4_0) do
		AttachmentUtils.destroy_attachment(arg_4_0._world, arg_4_0._unit, iter_4_1)
	end
end

PlayerUnitAttachmentExtension.update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	arg_5_0:update_resync_loadout()
end

PlayerUnitAttachmentExtension.hot_join_sync = function (arg_6_0, arg_6_1)
	AttachmentUtils.hot_join_sync(arg_6_1, arg_6_0._unit, arg_6_0._attachments.slots, arg_6_0._synced_slot_buffs)
end

PlayerUnitAttachmentExtension.create_attachment = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0._attachments
	local var_7_1 = arg_7_0._unit
	local var_7_2 = BackendUtils.get_item_template(arg_7_2)
	local var_7_3 = var_7_1

	if var_7_2.link_to_skin then
		var_7_3 = arg_7_0._tp_unit_mesh
	end

	local var_7_4 = AttachmentUtils.create_attachment(arg_7_0._world, var_7_3, var_7_0, arg_7_1, arg_7_2, false)

	var_7_0.slots[arg_7_1] = var_7_4

	local var_7_5 = var_7_4.item_data
	local var_7_6 = BackendUtils.get_item_template(var_7_5)
	local var_7_7 = ScriptUnit.extension(var_7_1, "first_person_system").first_person_mode
	local var_7_8 = arg_7_0._player.bot_player

	if not var_7_7 or var_7_8 then
		local var_7_9 = var_7_6.show_attachments_event

		if var_7_9 then
			Unit.flow_event(arg_7_0._tp_unit_mesh, var_7_9)
			Unit.flow_event(arg_7_0._unit, var_7_9)

			if arg_7_0._show_attachments then
				arg_7_0:_show_attachment(arg_7_1, var_7_4, true)
			end
		end
	end

	local var_7_10 = var_7_5.backend_id
	local var_7_11 = arg_7_0:_get_property_and_trait_buffs(var_7_10)

	arg_7_0:_apply_buffs(var_7_11, var_7_5.name, arg_7_1, var_7_5.name)

	local var_7_12 = ScriptUnit.has_extension(var_7_1, "cosmetic_system")

	if var_7_12 and arg_7_1 == "slot_hat" then
		local var_7_13 = var_7_6.character_material_changes

		if var_7_13 then
			var_7_12:change_skin_materials(var_7_13)
		end
	end

	CosmeticUtils.update_cosmetic_slot(arg_7_0._player, arg_7_1, var_7_5.name)

	local var_7_14 = Managers.backend:get_interface("items"):get_item_from_id(var_7_10)

	LoadoutUtils.sync_loadout_slot(arg_7_0._player, arg_7_1, var_7_14)
end

PlayerUnitAttachmentExtension.remove_attachment = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._attachments.slots[arg_8_1]

	if var_8_0 == nil then
		return
	end

	AttachmentUtils.destroy_attachment(arg_8_0._world, arg_8_0._unit, var_8_0)
	arg_8_0:_remove_buffs(arg_8_1)

	local var_8_1 = var_8_0.item_data

	arg_8_0._attachments.slots[arg_8_1] = nil

	local var_8_2 = Managers.state.network
	local var_8_3 = var_8_2:unit_game_object_id(arg_8_0._unit)
	local var_8_4 = NetworkLookup.equipment_slots[arg_8_1]

	if arg_8_0._is_server then
		var_8_2.network_transmit:send_rpc_clients("rpc_remove_attachment", var_8_3, var_8_4)
	else
		var_8_2.network_transmit:send_rpc_server("rpc_remove_attachment", var_8_3, var_8_4)
	end
end

PlayerUnitAttachmentExtension.attachments = function (arg_9_0)
	return arg_9_0._attachments
end

PlayerUnitAttachmentExtension.get_slot_data = function (arg_10_0, arg_10_1)
	return arg_10_0._attachments.slots[arg_10_1]
end

PlayerUnitAttachmentExtension._show_attachment = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = arg_11_3

	if arg_11_0._cosmetic_extension:always_hide_attachment_slot(arg_11_1) then
		var_11_0 = false
	end

	local var_11_1 = arg_11_2.unit

	Unit.set_unit_visibility(var_11_1, var_11_0)

	if var_11_0 then
		Unit.flow_event(var_11_1, "lua_attachment_unhidden")

		local var_11_2 = arg_11_2.item_data
		local var_11_3 = BackendUtils.get_item_template(var_11_2).show_attachments_event

		if var_11_3 then
			Unit.flow_event(arg_11_0._tp_unit_mesh, var_11_3)
			Unit.flow_event(arg_11_0._unit, var_11_3)
		end

		arg_11_0._cosmetic_extension:trigger_equip_events(arg_11_1, var_11_1)
	else
		Unit.flow_event(var_11_1, "lua_attachment_hidden")
	end
end

PlayerUnitAttachmentExtension.show_attachments = function (arg_12_0, arg_12_1)
	if arg_12_0._show_attachments ~= arg_12_1 then
		local var_12_0 = arg_12_0._attachments.slots

		for iter_12_0, iter_12_1 in pairs(var_12_0) do
			if iter_12_1.unit then
				arg_12_0:_show_attachment(iter_12_0, iter_12_1, arg_12_1)
			end
		end

		local var_12_1 = arg_12_1 and "lua_attachment_unhidden" or "lua_attachment_hidden"

		Unit.flow_event(arg_12_0._tp_unit_mesh, var_12_1)

		arg_12_0._show_attachments = arg_12_1
	end
end

PlayerUnitAttachmentExtension.create_attachment_in_slot = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = BackendUtils.get_item_from_masterlist(arg_13_2)

	if not var_13_0 then
		Crashify.print_exception("PlayerUnitAttachmentExtension", "Tried to create attachment %q in slot %q but was unable to find item", arg_13_2, arg_13_1)

		return
	end

	local var_13_1 = arg_13_0._attachments.slots[arg_13_1]
	local var_13_2 = var_13_1 and var_13_1.item_data == var_13_0
	local var_13_3 = var_13_0.name

	if var_13_2 then
		return
	end

	arg_13_0:remove_attachment(arg_13_1)

	arg_13_0._item_to_spawn = {
		slot_id = arg_13_1,
		item_data = var_13_0
	}
	arg_13_0.resync_loadout_needed = true
end

PlayerUnitAttachmentExtension.update_resync_loadout = function (arg_14_0)
	local var_14_0 = arg_14_0._item_to_spawn

	if not var_14_0 then
		return
	end

	local var_14_1 = Managers.state.network.profile_synchronizer
	local var_14_2 = arg_14_0._player:network_id()
	local var_14_3 = arg_14_0._player:local_player_id()

	if arg_14_0.resync_loadout_needed then
		local var_14_4 = arg_14_0._player.bot_player
		local var_14_5 = true

		var_14_1:resync_loadout(var_14_2, var_14_3, var_14_4, var_14_5)

		arg_14_0.resync_loadout_needed = false
	end

	if var_14_1:all_ingame_synced_for_peer(var_14_2, var_14_3) then
		arg_14_0:spawn_resynced_loadout(var_14_0)

		arg_14_0._item_to_spawn = nil
	end
end

PlayerUnitAttachmentExtension.spawn_resynced_loadout = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_1.slot_id
	local var_15_1 = arg_15_1.item_data
	local var_15_2 = Managers.state.network
	local var_15_3 = Managers.state.unit_storage:go_id(arg_15_0._unit)
	local var_15_4 = NetworkLookup.equipment_slots[var_15_0]
	local var_15_5 = NetworkLookup.item_names[var_15_1.name]

	if arg_15_0._is_server then
		var_15_2.network_transmit:send_rpc_clients("rpc_create_attachment", var_15_3, var_15_4, var_15_5)
	else
		var_15_2.network_transmit:send_rpc_server("rpc_create_attachment", var_15_3, var_15_4, var_15_5)
	end

	local var_15_6 = var_15_1.backend_id
	local var_15_7 = arg_15_0:_get_property_and_trait_buffs(var_15_6)
	local var_15_8 = {}
	local var_15_9 = table.merge(var_15_8, var_15_7.server)
	local var_15_10 = table.merge(var_15_9, var_15_7.both)

	if table.size(var_15_10) > 0 then
		arg_15_0:_send_rpc_add_attachment_buffs(var_15_3, var_15_4, var_15_10)

		arg_15_0._synced_slot_buffs[var_15_0] = var_15_10
	end

	arg_15_0:create_attachment(var_15_0, var_15_1)
end

PlayerUnitAttachmentExtension._send_rpc_add_attachment_buffs = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0 = BuffUtils.buffs_to_rpc_params(arg_16_3)
	local var_16_1, var_16_2, var_16_3, var_16_4 = unpack(var_16_0)

	if #var_16_2 ~= #var_16_3 or #var_16_3 ~= #var_16_4 then
		fassert(false, "[PlayerUnitAttachmentExtension] Length of arrays buff_names(%d) and buff_value_types(%d) and buff_values(%d) are not equal!", #var_16_2, #var_16_3, #var_16_4)
	end

	if var_16_1 > 0 then
		local var_16_5 = Managers.state.network.network_transmit

		if arg_16_0._is_server then
			var_16_5:send_rpc_clients("rpc_add_attachment_buffs", arg_16_1, arg_16_2, var_16_1, var_16_2, var_16_3, var_16_4)
		else
			var_16_5:send_rpc_server("rpc_add_attachment_buffs", arg_16_1, arg_16_2, var_16_1, var_16_2, var_16_3, var_16_4)
		end
	end
end

local var_0_0 = {
	client = {},
	server = {},
	both = {}
}

PlayerUnitAttachmentExtension._get_property_and_trait_buffs = function (arg_17_0, arg_17_1)
	local var_17_0 = Managers.backend:get_interface("items")

	table.clear(var_0_0.client)
	table.clear(var_0_0.server)
	table.clear(var_0_0.both)

	return GearUtils.get_property_and_trait_buffs(var_17_0, arg_17_1, var_0_0)
end

local var_0_1 = {}

PlayerUnitAttachmentExtension._apply_buffs = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local var_18_0 = arg_18_0.buff_extension
	local var_18_1 = arg_18_0.current_item_buffs[arg_18_3] or {}
	local var_18_2 = 1

	for iter_18_0, iter_18_1 in pairs(arg_18_1) do
		if arg_18_0._is_server or iter_18_0 == "client" or iter_18_0 == "both" then
			for iter_18_2, iter_18_3 in pairs(iter_18_1) do
				local var_18_3 = BuffUtils.get_buff_template(iter_18_2)

				fassert(var_18_3, "buff name %s does not exist on item %s, typo?", iter_18_2, arg_18_2)
				table.clear(var_0_1)

				for iter_18_4, iter_18_5 in pairs(iter_18_3) do
					var_0_1[iter_18_4] = iter_18_5
				end

				var_18_1[var_18_2] = var_18_0:add_buff(iter_18_2, var_0_1)
				var_18_2 = var_18_2 + 1
			end
		end
	end

	arg_18_0.current_item_buffs[arg_18_3] = var_18_1
end

PlayerUnitAttachmentExtension._remove_buffs = function (arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0.buff_extension
	local var_19_1 = arg_19_0.current_item_buffs[arg_19_1]

	if var_19_1 then
		for iter_19_0 = 1, #var_19_1 do
			local var_19_2 = var_19_1[iter_19_0]

			var_19_0:remove_buff(var_19_2)
		end

		table.clear(var_19_1)
	end
end
