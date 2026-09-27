-- chunkname: @scripts/unit_extensions/default_player_unit/inventory/simple_husk_inventory_extension.lua

SimpleHuskInventoryExtension = class(SimpleHuskInventoryExtension)

SimpleHuskInventoryExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._world = arg_1_1.world
	self._game_object_id = arg_1_3.id
	self._game = arg_1_3.game
	self._unit = arg_1_2
	self._equipment = {
		slots = {}
	}
	self._attached_units = {}
	self._slot_buffs = {
		wield = {
			slot_ranged = {},
			slot_melee = {}
		},
		equip = {
			slot_melee = {},
			slot_ranged = {}
		}
	}
	self._weapon_fx = {}
	self.current_item_buffs = {
		wield = {},
		equip = {
			slot_melee = {},
			slot_ranged = {}
		}
	}
	self._additional_items = {}

	local player = arg_1_3.player

	self._player = player

	if not player then
		local career_name = player:career_name()
		local flag = not career_name and CareerSettings[career_name]
		local flag_2 = not flag and flag.additional_item_slots

		if not flag_2 then
			for k, v in pairs(flag_2) do
				self._additional_items[k] = {
					max_slots = v,
					items = {}
				}
			end
		end

		self._career_name = career_name
	end

	self._show_third_person = true
end

SimpleHuskInventoryExtension.ammo_percentage = function (self)
	-- function 2
	if not GameSession.game_object_exists(self._game, self._game_object_id) then
		return (GameSession.game_object_field(self._game, self._game_object_id, "ammo_percentage"))
	end
end

SimpleHuskInventoryExtension.ammo_status = function (self)
	-- function 3
	if not GameSession.game_object_exists(self._game, self._game_object_id) then
		local game_object_field = GameSession.game_object_field(self._game, self._game_object_id, "current_ammo")
		local game_object_field_2 = GameSession.game_object_field(self._game, self._game_object_id, "max_ammo")

		return game_object_field, game_object_field_2
	end
end

SimpleHuskInventoryExtension.destroy = function (self)
	-- function 4
	if not Managers.player.is_server then
		for k, v in pairs(self._equipment.slots) do
			if not v.limited_item_data then
				self:evaluate_limited_item_state(v)
			elseif k == "slot_level_event" then
				self:drop_level_event_item(v)
			end
		end
	end

	GearUtils.destroy_equipment(self._world, self._equipment)
	self:_despawn_attached_units()
	self:_stop_all_weapon_fx()
end

SimpleHuskInventoryExtension.get_weapon_unit = function (self)
	-- function 5
	local _equipment = self._equipment
	local left_hand_wielded_unit_3p = _equipment.left_hand_wielded_unit_3p

	left_hand_wielded_unit_3p = left_hand_wielded_unit_3p or _equipment.right_hand_wielded_unit_3p

	return left_hand_wielded_unit_3p
end

SimpleHuskInventoryExtension.get_all_weapon_unit = function (self)
	-- function 6
	local _equipment = self._equipment

	return _equipment.left_hand_wielded_unit_3p, _equipment.right_hand_wielded_unit_3p
end

SimpleHuskInventoryExtension.drop_level_event_item = function (self, arg_7_1)
	-- function 7
	local get_item_template = self:get_item_template(arg_7_1)

	if not get_item_template.no_drop then
		return
	end

	local default = get_item_template.actions.action_dropped.default
	local projectile_info = default.projectile_info

	if not projectile_info.drop_on_player_destroyed then
		local _unit = self._unit
		local right_hand_wielded_unit_3p = self._equipment.right_hand_wielded_unit_3p

		right_hand_wielded_unit_3p = right_hand_wielded_unit_3p or self._equipment.left_hand_wielded_unit_3p

		local num = Unit.world_position(_unit, 0) + Vector3(0, 0, 2)
		local identity = Quaternion.identity()
		local var_7_7 = Vector3(math.random(), math.random(), math.random())
		local var_7_8 = Vector3(math.random(), math.random(), math.random())
		local name = arg_7_1.item_data.name
		local str = "dropped"

		ActionUtils.spawn_pickup_projectile(self._world, right_hand_wielded_unit_3p, projectile_info.projectile_unit_name, projectile_info.projectile_unit_template_name, default, _unit, num, identity, var_7_7, var_7_8, name, str)
	end

	self:destroy_slot("slot_level_event")
end

SimpleHuskInventoryExtension._unlink_unit = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	World.unlink_unit(self._world, arg_8_1)

	local wielded = arg_8_3.wielded

	wielded = wielded or arg_8_3

	for i, v in ipairs(wielded) do
		local target = v.target

		if target ~= 0 then
			local node

			if type(target) == "string" then
				node = Unit.node(arg_8_1, target)

				if not node then
					-- Nothing
				end
			end

			node = target

			::label_8_0::

			local scene_graph_parent = Unit.scene_graph_parent(arg_8_1, node)

			Unit.scene_graph_link(arg_8_1, node, 0)
			Unit.set_local_pose(arg_8_1, node, Matrix4x4.identity())
		end
	end

	Unit.set_flow_variable(arg_8_1, "lua_drop_reason", arg_8_2)
	Unit.set_shader_pass_flag_for_meshes_in_unit_and_childs(arg_8_1, "outline_unit", false)
	Unit.flow_event(arg_8_1, "lua_dropped")

	local create_actor = Unit.create_actor(arg_8_1, "rp_dropped")

	Actor.add_angular_velocity(create_actor, Vector3(math.random(), math.random(), math.random()) * 5)
	Actor.add_velocity(create_actor, Vector3(2 * math.random() - 0.5, 2 * math.random() - 0.5, 4.5))
end

SimpleHuskInventoryExtension.drop_equipped_weapons = function (self, arg_9_1)
	-- function 9
	local _equipment = self._equipment
	local wielded = _equipment.wielded
	local template = wielded.template
	local var_9_3 = AttachmentNodeLinking[template]
	local left_hand_unit = wielded.left_hand_unit
	local right_hand_unit = wielded.right_hand_unit

	if not left_hand_unit then
		local third_person

		if not var_9_3.left then
			third_person = var_9_3.left.third_person

			if not third_person then
				-- Nothing
			end
		end

		third_person = var_9_3.third_person

		::label_9_0::

		local left_hand_wielded_unit_3p = _equipment.left_hand_wielded_unit_3p

		self:_unlink_unit(left_hand_wielded_unit_3p, arg_9_1, third_person)
	end

	if not right_hand_unit then
		local third_person_2

		if not var_9_3.right then
			third_person_2 = var_9_3.right.third_person

			if not third_person_2 then
				-- Nothing
			end
		end

		third_person_2 = var_9_3.third_person

		::label_9_1::

		local right_hand_wielded_unit_3p = _equipment.right_hand_wielded_unit_3p

		self:_unlink_unit(right_hand_wielded_unit_3p, arg_9_1, third_person_2)
	end
end

SimpleHuskInventoryExtension.equipment = function (self)
	-- function 10
	return self._equipment
end

SimpleHuskInventoryExtension.add_equipment = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local var_11_0 = ItemMasterList[arg_11_2]

	self:clear_buffs_on_slot("equip", arg_11_1)
	self:clear_buffs_on_slot("wield", arg_11_1)

	if not var_11_0.slot_to_use then
		local var_11_1 = self._equipment.slots[var_11_0.slot_to_use]
		local var_11_2
		local var_11_3

		if not WeaponUtils.is_valid_weapon_override(var_11_1, var_11_0) then
			var_11_2 = var_11_1.item_data
			var_11_3 = var_11_1.skin
		else
			local default_item_to_replace = var_11_0.default_item_to_replace

			var_11_2 = ItemMasterList[default_item_to_replace]
		end

		local get_item_units = BackendUtils.get_item_units(var_11_2, nil, var_11_3, self._career_name)

		arg_11_3 = nil

		for k, v in pairs(var_11_0.item_units_to_replace) do
			var_11_0[k] = get_item_units[k]
		end
	end

	local get_item_template = BackendUtils.get_item_template(var_11_0)

	self._equipment.slots[arg_11_1] = {
		item_data = var_11_0,
		id = arg_11_1,
		skin = arg_11_3,
		item_template = get_item_template,
		item_template_name = get_item_template.name
	}
end

SimpleHuskInventoryExtension.add_equipment_limited_item = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	-- function 12
	local var_12_0 = ItemMasterList[arg_12_2]
	local get_item_template = BackendUtils.get_item_template(var_12_0)

	arg_12_0._equipment.slots[arg_12_1] = {
		item_data = var_12_0,
		id = arg_12_1,
		limited_item_data = {
			spawner_unit = arg_12_3,
			id = arg_12_4
		},
		item_template_name = get_item_template.name
	}
end

SimpleHuskInventoryExtension.destroy_item_by_name = function (self, arg_13_1, arg_13_2)
	-- function 13
	local get_slot_data = self:get_slot_data(arg_13_1)

	if not (not get_slot_data and get_slot_data.item_data.name ~= arg_13_2) then
		self:destroy_slot(arg_13_1)
	end
end

SimpleHuskInventoryExtension.destroy_slot = function (self, arg_14_1)
	-- function 14
	local _equipment = self._equipment
	local var_14_1 = _equipment.slots[arg_14_1]

	if var_14_1 == nil then
		return
	end

	if not Managers.player.is_server and not var_14_1.limited_item_data then
		self:evaluate_limited_item_state(var_14_1)
	end

	GearUtils.destroy_slot(self._world, self._unit, var_14_1, _equipment, true)
end

SimpleHuskInventoryExtension.evaluate_limited_item_state = function (arg_15_0, arg_15_1)
	-- function 15
	local limited_item_data = arg_15_1.limited_item_data
	local spawner_unit = limited_item_data.spawner_unit

	if not spawner_unit then
		local extension = ScriptUnit.extension(spawner_unit, "limited_item_track_system")
		local id = limited_item_data.id

		if not extension:is_transformed(id) then
			Managers.state.entity:system("limited_item_track_system"):held_limited_item_destroyed(spawner_unit, id)
		end
	end
end

SimpleHuskInventoryExtension._setup_equipment = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	return {
		slots = {}
	}
end

SimpleHuskInventoryExtension.update = function (arg_17_0)
	-- function 17
	return
end

local tbl = {}

SimpleHuskInventoryExtension._reapply_fade = function (self, arg_18_1)
	-- function 18
	table.clear(tbl)

	if not arg_18_1.right_hand_wielded_unit_3p then
		tbl[#tbl + 1] = arg_18_1.right_hand_wielded_unit_3p
	end

	if not arg_18_1.right_hand_ammo_unit_3p then
		tbl[#tbl + 1] = arg_18_1.right_hand_ammo_unit_3p
	end

	if not arg_18_1.left_hand_wielded_unit_3p then
		tbl[#tbl + 1] = arg_18_1.left_hand_wielded_unit_3p
	end

	if not arg_18_1.left_hand_ammo_unit_3p then
		tbl[#tbl + 1] = arg_18_1.left_hand_ammo_unit_3p
	end

	Managers.state.entity:system("fade_system"):new_linked_units(self._unit, tbl)
end

SimpleHuskInventoryExtension.wield = function (self, arg_19_1)
	-- function 19
	local _equipment = self._equipment

	self:_stop_all_weapon_fx()
	self:_despawn_attached_units()
	self:_wield_slot(self._world, _equipment, arg_19_1, nil, self._unit)

	self.wielded_slot = arg_19_1

	if not arg_19_1 then
		local var_19_1 = _equipment.slots[arg_19_1]

		if not var_19_1 then
			local get_item_template = self:get_item_template(var_19_1)

			self:_spawn_attached_units(get_item_template.third_person_attached_units)

			if not ScriptUnit.has_extension(self._unit, "outline_system") then
				ScriptUnit.extension(self._unit, "outline_system"):reapply_outline()
			end

			if arg_19_1 == "slot_packmaster_claw" then
				local get_weapon_unit = self:get_weapon_unit()
				local get_pack_master_grabber = ScriptUnit.extension(self._unit, "status_system"):get_pack_master_grabber()
				local unit_owner = Managers.player:unit_owner(get_pack_master_grabber)
				local get_cosmetic_slot = CosmeticUtils.get_cosmetic_slot(unit_owner, "slot_skin")

				if not get_cosmetic_slot then
					if get_cosmetic_slot.item_name ~= "skaven_pack_master_skin_1001" then
						Unit.flow_event(get_weapon_unit, "lua_wield_0000")
					else
						Unit.flow_event(get_weapon_unit, "lua_wield_1001")
					end
				end
			end

			self:_reapply_fade(_equipment)

			local str = "wield"
			local var_19_8 = self._slot_buffs[str][arg_19_1]

			if not Managers.player.is_server and not var_19_8 then
				self:_refresh_buffs(var_19_8, str, arg_19_1)
			end

			Unit.flow_event(self._unit, "lua_wield")
			self:start_weapon_fx("wield")
			Managers.state.event:trigger("on_weapon_wield", _equipment)
		end
	end
end

SimpleHuskInventoryExtension._despawn_attached_units = function (self)
	-- function 20
	local _attached_units = self._attached_units
	local _world = self._world

	for k, v in pairs(_attached_units) do
		Managers.state.unit_spawner:mark_for_deletion(v)

		_attached_units[k] = nil
	end
end

SimpleHuskInventoryExtension._spawn_attached_units = function (self, arg_21_1)
	-- function 21
	if arg_21_1 == nil then
		return
	end

	local _unit = self._unit
	local _world = self._world
	local _attached_units = self._attached_units

	for k, v in pairs(arg_21_1) do
		_attached_units[k] = AttachmentUtils.create_weapon_visual_attachment(_world, _unit, v.unit, v.attachment_node_linking)
	end
end

SimpleHuskInventoryExtension.clear_buffs_on_slot = function (self, arg_22_1, arg_22_2)
	-- function 22
	if not (arg_22_2 == "slot_ranged" or arg_22_2 ~= "slot_melee") then
		local var_22_0 = self._slot_buffs[arg_22_1][arg_22_2]

		table.clear(var_22_0)
	end
end

SimpleHuskInventoryExtension.set_buffs_to_slot = function (self, arg_23_1, arg_23_2, arg_23_3)
	-- function 23
	if not (arg_23_2 == "slot_ranged" or arg_23_2 ~= "slot_melee") then
		self._slot_buffs[arg_23_1][arg_23_2] = arg_23_3

		self:_refresh_buffs(arg_23_3, arg_23_1, arg_23_2)
	end
end

local tbl_2 = {}

SimpleHuskInventoryExtension._refresh_buffs = function (self, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	local extension = ScriptUnit.extension(self._unit, "buff_system")
	local var_24_1 = self.current_item_buffs[arg_24_2]

	if arg_24_2 == "equip" then
		var_24_1 = var_24_1[arg_24_3]
	end

	for i = 1, #var_24_1 do
		local var_24_2 = var_24_1[i]

		extension:remove_buff(var_24_2)
	end

	table.clear(var_24_1)

	local num = 1

	for k, v in pairs(arg_24_1) do
		table.clear(tbl_2)

		for k_2, v_2 in pairs(v) do
			tbl_2[k_2] = v_2
		end

		var_24_1[num] = extension:add_buff(k, tbl_2)
		num = num + 1
	end
end

SimpleHuskInventoryExtension.has_inventory_item = function (self, arg_25_1, arg_25_2)
	-- function 25
	local get_slot_data = self:get_slot_data(arg_25_1)

	if not (not get_slot_data and arg_25_2 ~= get_slot_data.item_data.name) then
		return true
	end

	local get_additional_items = self:get_additional_items(arg_25_1)

	if not get_additional_items then
		for i = 1, #get_additional_items do
			if arg_25_2 == get_additional_items[i].name then
				return true
			end
		end
	end

	return false
end

SimpleHuskInventoryExtension.show_third_person_inventory = function (self, arg_26_1)
	-- function 26
	self._show_third_person = arg_26_1

	local right_hand_wielded_unit_3p = self._equipment.right_hand_wielded_unit_3p

	if not right_hand_wielded_unit_3p then
		if not Unit.has_visibility_group(right_hand_wielded_unit_3p, "normal") then
			Unit.set_visibility(right_hand_wielded_unit_3p, "normal", arg_26_1)
		else
			Unit.set_unit_visibility(right_hand_wielded_unit_3p, arg_26_1)
		end

		local right_hand_ammo_unit_3p = self._equipment.right_hand_ammo_unit_3p

		if not right_hand_ammo_unit_3p then
			Unit.set_unit_visibility(right_hand_ammo_unit_3p, arg_26_1)
		end

		if not arg_26_1 then
			Unit.flow_event(right_hand_wielded_unit_3p, "lua_wield")

			if not right_hand_ammo_unit_3p then
				Unit.flow_event(right_hand_ammo_unit_3p, "lua_wield")
			end
		else
			Unit.flow_event(right_hand_wielded_unit_3p, "lua_unwield")

			if not right_hand_ammo_unit_3p then
				Unit.flow_event(right_hand_ammo_unit_3p, "lua_unwield")
			end
		end
	end

	local left_hand_wielded_unit_3p = self._equipment.left_hand_wielded_unit_3p

	if not left_hand_wielded_unit_3p then
		if not Unit.has_visibility_group(left_hand_wielded_unit_3p, "normal") then
			Unit.set_visibility(left_hand_wielded_unit_3p, "normal", arg_26_1)
		else
			Unit.set_unit_visibility(left_hand_wielded_unit_3p, arg_26_1)
		end

		local left_hand_ammo_unit_3p = self._equipment.left_hand_ammo_unit_3p

		if not left_hand_ammo_unit_3p then
			Unit.set_unit_visibility(left_hand_ammo_unit_3p, arg_26_1)
		end

		if not arg_26_1 then
			Unit.flow_event(left_hand_wielded_unit_3p, "lua_wield")

			if not left_hand_ammo_unit_3p then
				Unit.flow_event(left_hand_ammo_unit_3p, "lua_wield")
			end
		else
			Unit.flow_event(left_hand_wielded_unit_3p, "lua_unwield")

			if not left_hand_ammo_unit_3p then
				Unit.flow_event(left_hand_ammo_unit_3p, "lua_unwield")
			end
		end
	end

	self:_despawn_attached_units()

	local _equipment = self._equipment
	local wielded_slot = self.wielded_slot

	if not wielded_slot then
		local var_26_6 = _equipment.slots[wielded_slot]

		if not var_26_6 and not arg_26_1 then
			local get_item_template = self:get_item_template(var_26_6)

			self:_spawn_attached_units(get_item_template.third_person_attached_units)
		end
	end
end

SimpleHuskInventoryExtension.get_item_template = function (arg_27_0, arg_27_1)
	-- function 27
	local item_data = arg_27_1.item_data

	return (BackendUtils.get_item_template(item_data))
end

SimpleHuskInventoryExtension.get_wielded_slot_data = function (self)
	-- function 28
	local get_wielded_slot_name = self:get_wielded_slot_name()

	return (self:get_slot_data(get_wielded_slot_name))
end

SimpleHuskInventoryExtension.get_wielded_slot_item_template = function (self)
	-- function 29
	local wielded_slot = self.wielded_slot
	local var_29_1 = self._equipment.slots[wielded_slot]

	if not var_29_1 then
		return nil
	end

	return (self:get_item_template(var_29_1))
end

SimpleHuskInventoryExtension.hot_join_sync = function (self, arg_30_1)
	-- function 30
	GearUtils.hot_join_sync(arg_30_1, self._unit, self._equipment, self._additional_items)
end

SimpleHuskInventoryExtension.get_wielded_slot_name = function (self)
	-- function 31
	return self._equipment.wielded_slot
end

SimpleHuskInventoryExtension.get_slot_data = function (self, arg_32_1)
	-- function 32
	return self._equipment.slots[arg_32_1]
end

SimpleHuskInventoryExtension.get_wielded_slot_data = function (self)
	-- function 33
	local get_wielded_slot_name = self:get_wielded_slot_name()

	return (self:get_slot_data(get_wielded_slot_name))
end

SimpleHuskInventoryExtension.set_loaded_projectile_override = function (arg_34_0)
	-- function 34
	return
end

SimpleHuskInventoryExtension._override_career_skill_item_template = function (self, arg_35_1)
	-- function 35
	local var_35_0
	local slot_to_use = arg_35_1.slot_to_use

	if not slot_to_use then
		local var_35_2 = self._equipment.slots[slot_to_use]

		if not WeaponUtils.is_valid_weapon_override(var_35_2, arg_35_1) then
			var_35_0 = self:get_item_template(var_35_2)
		else
			local default_item_to_replace = arg_35_1.default_item_to_replace
			local var_35_4 = ItemMasterList[default_item_to_replace]

			var_35_0 = WeaponUtils.get_weapon_template(var_35_4.template)
		end

		local get_item_template = BackendUtils.get_item_template(arg_35_1)

		get_item_template.left_hand_attachment_node_linking = var_35_0.left_hand_attachment_node_linking
		get_item_template.right_hand_attachment_node_linking = var_35_0.right_hand_attachment_node_linking
		get_item_template.wield_anim = var_35_0.wield_anim
		get_item_template.wield_anim_no_ammo = var_35_0.wield_anim_no_ammo
		var_35_0 = get_item_template
	end

	return var_35_0
end

local function fn(arg_36_0, arg_36_1, arg_36_2)
	-- function 36
	local var_36_0

	if not arg_36_1 then
		var_36_0 = arg_36_1[arg_36_2]

		if not var_36_0 then
			-- Nothing
		end
	end

	var_36_0 = arg_36_0

	::label_36_0::

	return var_36_0
end

SimpleHuskInventoryExtension._wield_slot = function (self, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5)
	-- function 37
	local var_37_0 = arg_37_2.slots[arg_37_3]

	if not var_37_0 then
		print("Cannot wield item from " .. tostring(arg_37_3) .. " since this slot does not exist.")

		return
	end

	local item_data = var_37_0.item_data

	if not item_data then
		print("Cannot wield item from " .. tostring(arg_37_3) .. " since it is empty.")

		return
	end

	GearUtils.destroy_equipment(arg_37_1, arg_37_2)

	local flag = self:_override_career_skill_item_template(item_data) or BackendUtils.get_item_template(item_data)
	local get_item_units = BackendUtils.get_item_units(item_data, nil, var_37_0.skin, self._career_name)
	local var_37_4
	local var_37_5
	local var_37_6
	local var_37_7
	local var_37_8
	local var_37_9
	local var_37_10
	local var_37_11

	if not get_item_units.right_hand_unit then
		var_37_4, var_37_8, var_37_5, var_37_9 = GearUtils.spawn_inventory_unit(arg_37_1, "right", flag, get_item_units, arg_37_3, item_data, arg_37_4, arg_37_5, nil, nil, nil, get_item_units.material_settings_name)
	end

	if not get_item_units.left_hand_unit then
		var_37_6, var_37_10, var_37_7, var_37_11 = GearUtils.spawn_inventory_unit(arg_37_1, "left", flag, get_item_units, arg_37_3, item_data, arg_37_4, arg_37_5, nil, nil, nil, get_item_units.material_settings_name)
	end

	if not get_item_units.is_ammo_weapon then
		local material_settings_name = get_item_units.material_settings_name

		material_settings_name = material_settings_name or flag.material_settings_name

		if not material_settings_name then
			if not var_37_8 then
				GearUtils.apply_material_settings(var_37_8, material_settings_name)
			end

			if not var_37_10 then
				GearUtils.apply_material_settings(var_37_10, material_settings_name)
			end

			if not arg_37_4 then
				if not var_37_9 then
					GearUtils.apply_material_settings(var_37_9, material_settings_name)
				end

				if not var_37_11 then
					GearUtils.apply_material_settings(var_37_11, material_settings_name)
				end
			end
		end
	end

	local career_index = ScriptUnit.extension(arg_37_5, "career_system"):career_index()

	if not Unit.animation_has_variable(arg_37_5, "career_index") then
		local animation_find_variable = Unit.animation_find_variable(arg_37_5, "career_index")

		Unit.animation_set_variable(arg_37_5, animation_find_variable, career_index)
	end

	local get_item_template = BackendUtils.get_item_template(item_data)
	local var_37_16 = fn(get_item_template.wield_anim, get_item_template.wield_anim_career, self._career_name)
	local var_37_17 = fn(get_item_template.wield_anim_3p, get_item_template.wield_anim_career_3p, self._career_name)

	var_37_17 = var_37_17 or var_37_16

	if var_37_4 or not var_37_6 then
		if self:ammo_percentage() ~= 0 or not get_item_template.wield_anim_no_ammo_on_husk then
			local var_37_18 = fn(get_item_template.wield_anim_no_ammo, get_item_template.wield_anim_no_ammo_career, self._career_name)

			var_37_16 = var_37_18 or var_37_16

			local var_37_19 = fn(get_item_template.wield_anim_no_ammo_3p, get_item_template.wield_anim_no_ammo_career_3p, self._career_name)

			var_37_19 = var_37_19 or var_37_18
			var_37_17 = var_37_19 or var_37_17
		end

		Unit.flow_event(arg_37_5, "lua_wield")
		Unit.animation_event(arg_37_5, var_37_17)

		if not var_37_4 then
			Unit.set_flow_variable(var_37_4, "owner", arg_37_5)
			Unit.flow_event(var_37_4, "lua_wield")
		end

		if not var_37_6 then
			Unit.set_flow_variable(var_37_6, "owner", arg_37_5)
			Unit.flow_event(var_37_6, "lua_wield")
		end
	end

	if var_37_5 or not var_37_7 then
		if not Unit.animation_has_variable(arg_37_4, "animation_variation_id") then
			local var_37_20 = WeaponSkins.skins[var_37_0.skin]
			local flag_2 = not var_37_20 and var_37_20.action_anim_overrides
			local animation_variation_id

			if not flag_2 then
				animation_variation_id = flag_2.animation_variation_id

				if not animation_variation_id then
					-- Nothing
				end
			end

			animation_variation_id = 0

			::label_37_0::

			local animation_find_variable_2 = Unit.animation_find_variable(arg_37_4, "animation_variation_id")

			Unit.animation_set_variable(arg_37_4, animation_find_variable_2, animation_variation_id)
		end

		Unit.animation_event(arg_37_4, var_37_16)
	end

	if not var_37_5 then
		Unit.set_unit_visibility(var_37_4, false)

		if not var_37_9 then
			Unit.set_unit_visibility(var_37_8, false)
		end
	end

	if not var_37_7 then
		Unit.set_unit_visibility(var_37_6, false)

		if not var_37_11 then
			Unit.set_unit_visibility(var_37_10, false)
		end
	end

	arg_37_2.right_hand_wielded_unit_3p = var_37_4
	arg_37_2.right_hand_ammo_unit_3p = var_37_8
	arg_37_2.right_hand_wielded_unit = var_37_5
	arg_37_2.right_hand_ammo_unit_1p = var_37_9
	arg_37_2.left_hand_wielded_unit_3p = var_37_6
	arg_37_2.left_hand_ammo_unit_3p = var_37_10
	arg_37_2.left_hand_wielded_unit = var_37_7
	arg_37_2.left_hand_ammo_unit_1p = var_37_11
	arg_37_2.wielded = item_data
	arg_37_2.wielded_slot = arg_37_3

	local var_37_24 = BLACKBOARDS[self._unit]

	if not var_37_24.weapon_unit then
		var_37_24.weapon_unit = self:get_weapon_unit()
	end

	return item_data
end

SimpleHuskInventoryExtension.is_showing_third_person_inventory = function (self)
	-- function 38
	return self._show_third_person
end

SimpleHuskInventoryExtension.start_weapon_fx = function (self, arg_39_1)
	-- function 39
	local _equipment = self._equipment
	local wielded_slot = _equipment.wielded_slot
	local var_39_2 = _equipment.slots[wielded_slot]
	local particle_fx = self:get_item_template(var_39_2).particle_fx
	local flag = not particle_fx and particle_fx[arg_39_1]

	if not flag then
		self._weapon_fx[arg_39_1] = GearUtils.create_attached_particles(self._world, flag, _equipment, self._unit, nil, false)
	end
end

SimpleHuskInventoryExtension.stop_weapon_fx = function (self, arg_40_1)
	-- function 40
	self._weapon_fx[arg_40_1] = GearUtils.destroy_attached_particles(self._world, self._weapon_fx[arg_40_1])
end

SimpleHuskInventoryExtension._stop_all_weapon_fx = function (self)
	-- function 41
	local _world = self._world
	local _weapon_fx = self._weapon_fx

	for k, v in pairs(_weapon_fx) do
		GearUtils.destroy_attached_particles(_world, v)

		_weapon_fx[k] = nil
	end
end

SimpleHuskInventoryExtension.has_additional_item_slots = function (self, arg_42_1)
	-- function 42
	return self._additional_items[arg_42_1] ~= nil
end

SimpleHuskInventoryExtension.can_store_additional_item = function (self, arg_43_1)
	-- function 43
	local var_43_0 = self._additional_items[arg_43_1]

	return not var_43_0 and #var_43_0.items < var_43_0.max_slots
end

SimpleHuskInventoryExtension.has_additional_items = function (self, arg_44_1)
	-- function 44
	local var_44_0 = self._additional_items[arg_44_1]

	return not var_44_0 and #var_44_0.items > 0
end

SimpleHuskInventoryExtension.get_additional_items = function (self, arg_45_1)
	-- function 45
	local var_45_0 = self._additional_items[arg_45_1]

	return not var_45_0 and var_45_0.items
end

SimpleHuskInventoryExtension.get_additional_items_table = function (self)
	-- function 46
	return self._additional_items
end

SimpleHuskInventoryExtension.get_total_item_count = function (self, arg_47_1)
	-- function 47
	local num = 0

	if not self._equipment.slots[arg_47_1] then
		num = 1
	end

	local get_additional_items = self:get_additional_items(arg_47_1)

	if not get_additional_items then
		num = num + #get_additional_items
	end

	return num
end

SimpleHuskInventoryExtension.update_additional_items = function (self, arg_48_1, arg_48_2)
	-- function 48
	local var_48_0 = self._additional_items[arg_48_1]

	if not var_48_0 then
		table.clear(var_48_0.items)

		for i = 1, #arg_48_2 do
			local var_48_1 = arg_48_2[i]

			var_48_0.items[#var_48_0.items + 1] = ItemMasterList[var_48_1]
		end
	end
end
