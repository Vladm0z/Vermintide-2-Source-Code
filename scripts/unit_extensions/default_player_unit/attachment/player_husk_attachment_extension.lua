-- chunkname: @scripts/unit_extensions/default_player_unit/attachment/player_husk_attachment_extension.lua

PlayerHuskAttachmentExtension = class(PlayerHuskAttachmentExtension)

PlayerHuskAttachmentExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._world = arg_1_1.world
	self._unit = arg_1_2

	local profile = arg_1_3.profile

	self._slots, self._profile = arg_1_3.slots, profile
	self._attachments = {
		slots = {}
	}
	self._synced_slot_buffs = {}
	self.current_item_buffs = {}
end

PlayerHuskAttachmentExtension.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	self.buff_extension = ScriptUnit.extension(arg_2_2, "buff_system")
	self._cosmetic_extension = ScriptUnit.extension(arg_2_2, "cosmetic_system")
	self._tp_unit_mesh = self._cosmetic_extension:get_third_person_mesh_unit()

	Unit.flow_event(self._tp_unit_mesh, "lua_attachment_unhidden")
end

PlayerHuskAttachmentExtension.destroy = function (self)
	-- function 3
	local slots = self._attachments.slots

	for k, v in pairs(slots) do
		AttachmentUtils.destroy_attachment(self._world, self._unit, v)
	end
end

PlayerHuskAttachmentExtension.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	return
end

PlayerHuskAttachmentExtension.hot_join_sync = function (self, arg_5_1)
	-- function 5
	AttachmentUtils.hot_join_sync(arg_5_1, self._unit, self._attachments.slots, self._synced_slot_buffs)
end

PlayerHuskAttachmentExtension.create_attachment = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not self._profile then
		return
	end

	local _unit = self._unit
	local _attachments = self._attachments

	if not _attachments.slots[arg_6_1] then
		self:remove_attachment(arg_6_1)
	end

	local get_item_template = BackendUtils.get_item_template(arg_6_2)
	local var_6_3 = _unit

	if not get_item_template.link_to_skin then
		var_6_3 = self._tp_unit_mesh
	end

	local create_attachment = AttachmentUtils.create_attachment(self._world, var_6_3, _attachments, arg_6_1, arg_6_2, true)
	local show_attachments_event = get_item_template.show_attachments_event

	if not show_attachments_event then
		Unit.flow_event(self._tp_unit_mesh, show_attachments_event)
		Unit.flow_event(_unit, show_attachments_event)
	end

	self:_show_attachment(arg_6_1, create_attachment, true)

	_attachments.slots[arg_6_1] = create_attachment

	if not DEDICATED_SERVER then
		ScriptUnit.extension(_unit, "outline_system"):reapply_outline()
	end

	local has_extension = ScriptUnit.has_extension(_unit, "cosmetic_system")

	if not (not has_extension and arg_6_1 ~= "slot_hat") then
		local character_material_changes = get_item_template.character_material_changes

		if not character_material_changes then
			has_extension:change_skin_materials(character_material_changes)
		end
	end
end

PlayerHuskAttachmentExtension.remove_attachment = function (self, arg_7_1)
	-- function 7
	local var_7_0 = self._attachments.slots[arg_7_1]

	AttachmentUtils.destroy_attachment(self._world, self._unit, var_7_0)

	if not self.current_item_buffs[arg_7_1] then
		self:_remove_buffs(arg_7_1)
	end

	self._attachments.slots[arg_7_1] = nil
end

PlayerHuskAttachmentExtension.attachments = function (self)
	-- function 8
	return self._attachments
end

PlayerHuskAttachmentExtension.get_slot_data = function (self, arg_9_1)
	-- function 9
	return self._attachments.slots[arg_9_1]
end

PlayerHuskAttachmentExtension.show_attachments = function (self, arg_10_1)
	-- function 10
	if self._show_attachments ~= arg_10_1 then
		local slots = self._attachments.slots

		for k, v in pairs(slots) do
			if not v.unit then
				self:_show_attachment(k, v, arg_10_1)
			end
		end

		local flag

		flag = not arg_10_1 and "lua_attachment_unhidden" and "lua_attachment_hidden"

		Unit.flow_event(self._tp_unit_mesh, flag)

		self._show_attachments = arg_10_1
	end
end

PlayerHuskAttachmentExtension._show_attachment = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local var_11_0 = arg_11_3

	if not self._cosmetic_extension:always_hide_attachment_slot(arg_11_1) then
		var_11_0 = false
	end

	local unit = arg_11_2.unit

	if not unit then
		Unit.set_unit_visibility(unit, var_11_0)

		if not var_11_0 then
			Unit.flow_event(unit, "lua_attachment_unhidden")
			self._cosmetic_extension:trigger_equip_events(arg_11_1, unit)
		else
			Unit.flow_event(unit, "lua_attachment_hidden")
		end
	end
end

local tbl = {}

PlayerHuskAttachmentExtension._apply_buffs = function (self, arg_12_1, arg_12_2)
	-- function 12
	local extension = ScriptUnit.extension(self._unit, "buff_system")
	local var_12_1 = self.current_item_buffs[arg_12_2]

	var_12_1 = var_12_1 or {}

	local num = 1

	for k, v in pairs(arg_12_1) do
		table.clear(tbl)

		for k_2, v_2 in pairs(v) do
			tbl[k_2] = v_2
		end

		var_12_1[num] = extension:add_buff(k, tbl)
		num = num + 1
	end

	self.current_item_buffs[arg_12_2] = var_12_1
end

PlayerHuskAttachmentExtension._remove_buffs = function (self, arg_13_1)
	-- function 13
	local extension = ScriptUnit.extension(self._unit, "buff_system")
	local var_13_1 = self.current_item_buffs[arg_13_1]

	for i = 1, #var_13_1 do
		local var_13_2 = var_13_1[i]

		extension:remove_buff(var_13_2)
	end

	table.clear(var_13_1)
end

PlayerHuskAttachmentExtension.set_buffs_to_slot = function (self, arg_14_1, arg_14_2)
	-- function 14
	local var_14_0 = self._synced_slot_buffs[arg_14_1]

	var_14_0 = var_14_0 or {}

	table.clear(var_14_0)

	self._synced_slot_buffs[arg_14_1] = arg_14_2

	self:_apply_buffs(arg_14_2, arg_14_1)
end
