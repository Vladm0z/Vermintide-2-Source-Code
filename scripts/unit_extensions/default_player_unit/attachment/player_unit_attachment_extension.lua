-- chunkname: @scripts/unit_extensions/default_player_unit/attachment/player_unit_attachment_extension.lua

require("scripts/helpers/attachment_utils")
require("scripts/managers/backend/backend_utils")

PlayerUnitAttachmentExtension = class(PlayerUnitAttachmentExtension)

local script_data = script_data
local attachment_debug = script_data.attachment_debug

attachment_debug = attachment_debug or Development.parameter("attachment_debug")
script_data.attachment_debug = attachment_debug

PlayerUnitAttachmentExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._world = arg_1_1.world
	self._unit = arg_1_2
	self._profile = arg_1_3.profile
	self._is_server = arg_1_3.is_server
	self._player = arg_1_3.player
	self._profile_index = FindProfileIndex(self._profile.display_name)
	self.current_item_buffs = {}
	self._attachments = {
		slots = {}
	}
	self._synced_slot_buffs = {}
end

PlayerUnitAttachmentExtension.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	self.buff_extension = ScriptUnit.extension(arg_2_2, "buff_system")
	self.career_extension = ScriptUnit.extension(arg_2_2, "career_system")
	self._cosmetic_extension = ScriptUnit.extension(arg_2_2, "cosmetic_system")
	self._tp_unit_mesh = self._cosmetic_extension:get_third_person_mesh_unit()

	local _attachments = self._attachments
	local _profile = self._profile
	local attachment_slots = InventorySettings.attachment_slots
	local count = #attachment_slots
	local career_name = self.career_extension:career_name()
	local bot_player = self._player.bot_player

	for i = 1, count do
		repeat
			local name = attachment_slots[i].name
			local get_loadout_item = BackendUtils.get_loadout_item(career_name, name, bot_player)

			if not get_loadout_item then
				local clone = table.clone(get_loadout_item.data)

				clone.backend_id = get_loadout_item.backend_id

				self:create_attachment(name, clone)
			end
		until true
	end

	self:show_attachments(false)
end

PlayerUnitAttachmentExtension.game_object_initialized = function (self, arg_3_1, arg_3_2)
	-- function 3
	local slots = self._attachments.slots
	local network = Managers.state.network
	local _is_server = self._is_server

	for k, v in pairs(slots) do
		local var_3_3 = NetworkLookup.equipment_slots[k]
		local var_3_4 = NetworkLookup.item_names[v.item_data.name]

		if not _is_server then
			network.network_transmit:send_rpc_clients("rpc_create_attachment", arg_3_2, var_3_3, var_3_4)
		else
			network.network_transmit:send_rpc_server("rpc_create_attachment", arg_3_2, var_3_3, var_3_4)
		end

		local backend_id = v.item_data.backend_id
		local _get_property_and_trait_buffs = self:_get_property_and_trait_buffs(backend_id)
		local tbl = {}
		local merge = table.merge(tbl, _get_property_and_trait_buffs.server)
		local merge_2 = table.merge(merge, _get_property_and_trait_buffs.both)

		if table.size(merge_2) > 0 then
			self:_send_rpc_add_attachment_buffs(arg_3_2, var_3_3, merge_2)

			self._synced_slot_buffs[k] = merge_2
		end
	end
end

PlayerUnitAttachmentExtension.destroy = function (self)
	-- function 4
	local slots = self._attachments.slots

	for k, v in pairs(slots) do
		AttachmentUtils.destroy_attachment(self._world, self._unit, v)
	end
end

PlayerUnitAttachmentExtension.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	self:update_resync_loadout()
end

PlayerUnitAttachmentExtension.hot_join_sync = function (self, arg_6_1)
	-- function 6
	AttachmentUtils.hot_join_sync(arg_6_1, self._unit, self._attachments.slots, self._synced_slot_buffs)
end

PlayerUnitAttachmentExtension.create_attachment = function (self, arg_7_1, arg_7_2)
	-- function 7
	local _attachments = self._attachments
	local _unit = self._unit
	local get_item_template = BackendUtils.get_item_template(arg_7_2)
	local var_7_3 = _unit

	if not get_item_template.link_to_skin then
		var_7_3 = self._tp_unit_mesh
	end

	local create_attachment = AttachmentUtils.create_attachment(self._world, var_7_3, _attachments, arg_7_1, arg_7_2, false)

	_attachments.slots[arg_7_1] = create_attachment

	local item_data = create_attachment.item_data
	local get_item_template_2 = BackendUtils.get_item_template(item_data)
	local first_person_mode = ScriptUnit.extension(_unit, "first_person_system").first_person_mode
	local bot_player = self._player.bot_player

	if not first_person_mode and not bot_player then
		local show_attachments_event = get_item_template_2.show_attachments_event

		if not show_attachments_event then
			Unit.flow_event(self._tp_unit_mesh, show_attachments_event)
			Unit.flow_event(self._unit, show_attachments_event)

			if not self._show_attachments then
				self:_show_attachment(arg_7_1, create_attachment, true)
			end
		end
	end

	local backend_id = item_data.backend_id
	local _get_property_and_trait_buffs = self:_get_property_and_trait_buffs(backend_id)

	self:_apply_buffs(_get_property_and_trait_buffs, item_data.name, arg_7_1, item_data.name)

	local has_extension = ScriptUnit.has_extension(_unit, "cosmetic_system")

	if not (not has_extension and arg_7_1 ~= "slot_hat") then
		local character_material_changes = get_item_template_2.character_material_changes

		if not character_material_changes then
			has_extension:change_skin_materials(character_material_changes)
		end
	end

	CosmeticUtils.update_cosmetic_slot(self._player, arg_7_1, item_data.name)

	local get_item_from_id = Managers.backend:get_interface("items"):get_item_from_id(backend_id)

	LoadoutUtils.sync_loadout_slot(self._player, arg_7_1, get_item_from_id)
end

PlayerUnitAttachmentExtension.remove_attachment = function (self, arg_8_1)
	-- function 8
	local var_8_0 = self._attachments.slots[arg_8_1]

	if var_8_0 == nil then
		return
	end

	AttachmentUtils.destroy_attachment(self._world, self._unit, var_8_0)
	self:_remove_buffs(arg_8_1)

	local item_data = var_8_0.item_data

	self._attachments.slots[arg_8_1] = nil

	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(self._unit)
	local var_8_4 = NetworkLookup.equipment_slots[arg_8_1]

	if not self._is_server then
		network.network_transmit:send_rpc_clients("rpc_remove_attachment", unit_game_object_id, var_8_4)
	else
		network.network_transmit:send_rpc_server("rpc_remove_attachment", unit_game_object_id, var_8_4)
	end
end

PlayerUnitAttachmentExtension.attachments = function (self)
	-- function 9
	return self._attachments
end

PlayerUnitAttachmentExtension.get_slot_data = function (self, arg_10_1)
	-- function 10
	return self._attachments.slots[arg_10_1]
end

PlayerUnitAttachmentExtension._show_attachment = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local var_11_0 = arg_11_3

	if not self._cosmetic_extension:always_hide_attachment_slot(arg_11_1) then
		var_11_0 = false
	end

	local unit = arg_11_2.unit

	Unit.set_unit_visibility(unit, var_11_0)

	if not var_11_0 then
		Unit.flow_event(unit, "lua_attachment_unhidden")

		local item_data = arg_11_2.item_data
		local show_attachments_event = BackendUtils.get_item_template(item_data).show_attachments_event

		if not show_attachments_event then
			Unit.flow_event(self._tp_unit_mesh, show_attachments_event)
			Unit.flow_event(self._unit, show_attachments_event)
		end

		self._cosmetic_extension:trigger_equip_events(arg_11_1, unit)
	else
		Unit.flow_event(unit, "lua_attachment_hidden")
	end
end

PlayerUnitAttachmentExtension.show_attachments = function (self, arg_12_1)
	-- function 12
	if self._show_attachments ~= arg_12_1 then
		local slots = self._attachments.slots

		for k, v in pairs(slots) do
			if not v.unit then
				self:_show_attachment(k, v, arg_12_1)
			end
		end

		local flag

		flag = not arg_12_1 and "lua_attachment_unhidden" and "lua_attachment_hidden"

		Unit.flow_event(self._tp_unit_mesh, flag)

		self._show_attachments = arg_12_1
	end
end

PlayerUnitAttachmentExtension.create_attachment_in_slot = function (self, arg_13_1, arg_13_2)
	-- function 13
	local get_item_from_masterlist = BackendUtils.get_item_from_masterlist(arg_13_2)

	if not get_item_from_masterlist then
		Crashify.print_exception("PlayerUnitAttachmentExtension", "Tried to create attachment %q in slot %q but was unable to find item", arg_13_2, arg_13_1)

		return
	end

	local var_13_1 = self._attachments.slots[arg_13_1]
	local flag = not var_13_1 and var_13_1.item_data == get_item_from_masterlist
	local name = get_item_from_masterlist.name

	if not flag then
		return
	end

	self:remove_attachment(arg_13_1)

	self._item_to_spawn = {
		slot_id = arg_13_1,
		item_data = get_item_from_masterlist
	}
	self.resync_loadout_needed = true
end

PlayerUnitAttachmentExtension.update_resync_loadout = function (self)
	-- function 14
	local _item_to_spawn = self._item_to_spawn

	if not _item_to_spawn then
		return
	end

	local profile_synchronizer = Managers.state.network.profile_synchronizer
	local network_id = self._player:network_id()
	local local_player_id = self._player:local_player_id()

	if not self.resync_loadout_needed then
		local bot_player = self._player.bot_player
		local flag = true

		profile_synchronizer:resync_loadout(network_id, local_player_id, bot_player, flag)

		self.resync_loadout_needed = false
	end

	if not profile_synchronizer:all_ingame_synced_for_peer(network_id, local_player_id) then
		self:spawn_resynced_loadout(_item_to_spawn)

		self._item_to_spawn = nil
	end
end

PlayerUnitAttachmentExtension.spawn_resynced_loadout = function (self, arg_15_1)
	-- function 15
	local slot_id = arg_15_1.slot_id
	local item_data = arg_15_1.item_data
	local network = Managers.state.network
	local go_id = Managers.state.unit_storage:go_id(self._unit)
	local var_15_4 = NetworkLookup.equipment_slots[slot_id]
	local var_15_5 = NetworkLookup.item_names[item_data.name]

	if not self._is_server then
		network.network_transmit:send_rpc_clients("rpc_create_attachment", go_id, var_15_4, var_15_5)
	else
		network.network_transmit:send_rpc_server("rpc_create_attachment", go_id, var_15_4, var_15_5)
	end

	local backend_id = item_data.backend_id
	local _get_property_and_trait_buffs = self:_get_property_and_trait_buffs(backend_id)
	local tbl = {}
	local merge = table.merge(tbl, _get_property_and_trait_buffs.server)
	local merge_2 = table.merge(merge, _get_property_and_trait_buffs.both)

	if table.size(merge_2) > 0 then
		self:_send_rpc_add_attachment_buffs(go_id, var_15_4, merge_2)

		self._synced_slot_buffs[slot_id] = merge_2
	end

	self:create_attachment(slot_id, item_data)
end

PlayerUnitAttachmentExtension._send_rpc_add_attachment_buffs = function (self, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	local buffs_to_rpc_params = BuffUtils.buffs_to_rpc_params(arg_16_3)
	local var_16_1, var_16_2, var_16_3, var_16_4 = unpack(buffs_to_rpc_params)

	if not (#var_16_2 ~= #var_16_3 or #var_16_3 == #var_16_4) then
		fassert(false, "[PlayerUnitAttachmentExtension] Length of arrays buff_names(%d) and buff_value_types(%d) and buff_values(%d) are not equal!", #var_16_2, #var_16_3, #var_16_4)
	end

	if var_16_1 > 0 then
		local network_transmit = Managers.state.network.network_transmit

		if not self._is_server then
			network_transmit:send_rpc_clients("rpc_add_attachment_buffs", arg_16_1, arg_16_2, var_16_1, var_16_2, var_16_3, var_16_4)
		else
			network_transmit:send_rpc_server("rpc_add_attachment_buffs", arg_16_1, arg_16_2, var_16_1, var_16_2, var_16_3, var_16_4)
		end
	end
end

local tbl = {
	client = {},
	server = {},
	both = {}
}

PlayerUnitAttachmentExtension._get_property_and_trait_buffs = function (arg_17_0, arg_17_1)
	-- function 17
	local get_interface = Managers.backend:get_interface("items")

	table.clear(tbl.client)
	table.clear(tbl.server)
	table.clear(tbl.both)

	return GearUtils.get_property_and_trait_buffs(get_interface, arg_17_1, tbl)
end

local tbl_2 = {}

PlayerUnitAttachmentExtension._apply_buffs = function (self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	local buff_extension = self.buff_extension
	local var_18_1 = self.current_item_buffs[arg_18_3]

	var_18_1 = var_18_1 or {}

	local num = 1

	for k, v in pairs(arg_18_1) do
		if not (self._is_server or k == "client" or k ~= "both") then
			for k_2, v_2 in pairs(v) do
				local get_buff_template = BuffUtils.get_buff_template(k_2)

				fassert(get_buff_template, "buff name %s does not exist on item %s, typo?", k_2, arg_18_2)
				table.clear(tbl_2)

				for k_3, v_3 in pairs(v_2) do
					tbl_2[k_3] = v_3
				end

				var_18_1[num] = buff_extension:add_buff(k_2, tbl_2)
				num = num + 1
			end
		end
	end

	self.current_item_buffs[arg_18_3] = var_18_1
end

PlayerUnitAttachmentExtension._remove_buffs = function (self, arg_19_1)
	-- function 19
	local buff_extension = self.buff_extension
	local var_19_1 = self.current_item_buffs[arg_19_1]

	if not var_19_1 then
		for i = 1, #var_19_1 do
			local var_19_2 = var_19_1[i]

			buff_extension:remove_buff(var_19_2)
		end

		table.clear(var_19_1)
	end
end
