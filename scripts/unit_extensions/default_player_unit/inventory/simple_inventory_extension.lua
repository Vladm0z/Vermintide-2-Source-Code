-- chunkname: @scripts/unit_extensions/default_player_unit/inventory/simple_inventory_extension.lua

require("scripts/utils/strict_table")
require("scripts/unit_extensions/default_player_unit/inventory/gear_utils")
require("scripts/managers/backend/backend_utils")

SimpleInventoryExtension = class(SimpleInventoryExtension)

local SwapFromStorageType = SwapFromStorageType

SwapFromStorageType = SwapFromStorageType or CreateStrictEnumTable("First", "Unique", "Same", "SameOrAny", "UnwieldPrio", "LowestUnwieldPrio")
SwapFromStorageType = SwapFromStorageType

local tbl = {
	"slot_potion",
	"slot_grenade",
	"slot_healthkit"
}

SimpleInventoryExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._world = arg_1_1.world
	self._unit = arg_1_2
	self._profile = arg_1_3.profile
	self._profile_index = FindProfileIndex(self._profile.display_name)
	self._additional_items = {}
	self._attached_units = {}
	self._equipment = {
		slots = {},
		item_data = {}
	}

	local player = arg_1_3.player

	self.is_server = Managers.player.is_server

	local bot_player = player.bot_player

	bot_player = bot_player or false
	self.is_bot = bot_player
	self.player = player

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
	self.initial_inventory = arg_1_3.initial_inventory
	self.initial_ammo_percent = arg_1_3.ammo_percent
	self._show_first_person = true
	self._show_third_person = false
	self._show_first_person_lights = true
	self.current_item_buffs = {
		wield = {},
		equip = {
			slot_melee = {},
			slot_ranged = {}
		}
	}
	self._blocked_wield_slots = {}
	self._weapon_fx = {}
	self._items_to_spawn = {}
	self.recently_acquired_list = {}
	self._loaded_projectile_settings = {}
	self._selected_consumable_slot = nil
	self._previously_wielded_weapon_slot = "slot_melee"
	self._previously_wielded_slot = "slot_melee"
	self._previously_wielded_non_level_slot = "slot_melee"
	self._backend_items = Managers.backend:get_interface("items")
end

SimpleInventoryExtension.get_weapon_unit = function (self)
	-- function 2
	local _equipment = self._equipment
	local left_hand_wielded_unit = _equipment.left_hand_wielded_unit

	left_hand_wielded_unit = left_hand_wielded_unit or _equipment.right_hand_wielded_unit

	return left_hand_wielded_unit
end

SimpleInventoryExtension.get_weapon_unit_3p = function (self)
	-- function 3
	local _equipment = self._equipment
	local left_hand_wielded_unit_3p = _equipment.left_hand_wielded_unit_3p

	left_hand_wielded_unit_3p = left_hand_wielded_unit_3p or _equipment.right_hand_wielded_unit_3p

	return left_hand_wielded_unit_3p
end

SimpleInventoryExtension.get_all_weapon_unit = function (self)
	-- function 4
	local _equipment = self._equipment

	return _equipment.left_hand_wielded_unit, _equipment.right_hand_wielded_unit
end

SimpleInventoryExtension.extensions_ready = function (self, arg_5_1, arg_5_2)
	-- function 5
	local extension = ScriptUnit.extension(arg_5_2, "first_person_system")

	self.first_person_extension = extension
	self._first_person_unit = extension:get_first_person_unit()
	self.buff_extension = ScriptUnit.extension(arg_5_2, "buff_system")

	local extension_2 = ScriptUnit.extension(arg_5_2, "career_system")

	self.career_extension = extension_2

	local has_extension = ScriptUnit.has_extension(arg_5_2, "talent_system")

	self.talent_extension = has_extension

	local _equipment = self._equipment
	local _profile = self._profile
	local _first_person_unit = self._first_person_unit
	local _unit = self._unit

	self:add_equipment_by_category("weapon_slots")
	self:add_equipment_by_category("enemy_weapon_slots")

	local get_talent_career_skill_index

	if not has_extension then
		get_talent_career_skill_index = has_extension:get_talent_career_skill_index()

		if not get_talent_career_skill_index then
			-- Nothing
		end
	end

	get_talent_career_skill_index = 1

	::label_5_0::

	local flag = not has_extension and has_extension:get_talent_career_weapon_index()

	self.initial_inventory.slot_career_skill_weapon = extension_2:career_skill_weapon_name(get_talent_career_skill_index, flag)

	self:add_equipment_by_category("career_skill_weapon_slots")

	local additional_items = self.initial_inventory.additional_items

	if not additional_items then
		for k, v in pairs(additional_items) do
			for k_2 = 1, #v.items do
				local var_5_10 = v.items[k_2]

				if not self:get_slot_data(k) then
					local flag_2 = true

					self:store_additional_item(k, var_5_10, flag_2)
				else
					self:add_equipment(k, var_5_10)
				end
			end
		end
	end

	local career_settings = extension_2:career_settings()

	if not career_settings.additional_inventory then
		for k_3, v_2 in pairs(career_settings.additional_inventory) do
			for i5 = 1, #v_2 do
				local var_5_13 = ItemMasterList[v_2[i5]]

				if not self:get_slot_data(k_3) then
					local flag_3 = true

					self:store_additional_item(k_3, var_5_13, flag_3)
				else
					self:add_equipment(k_3, var_5_13)
				end
			end
		end
	end

	Unit.set_data(self._first_person_unit, "equipment", self._equipment)

	if not _profile.default_wielded_slot then
		local default_wielded_slot = _profile.default_wielded_slot
		local var_5_16 = self._equipment.slots[default_wielded_slot]

		if not var_5_16 then
			table.dump(self._equipment.slots, "self._equipment.slots", 1)

			local career_name = extension_2:career_name()
			local get_loadout_by_career_name = Managers.backend:get_interface("items"):get_loadout_by_career_name(career_name, self.is_bot)

			table.dump(get_loadout_by_career_name, "career_loadout", 1)
			ferror("Tried to wield default slot %s for %s that contained no weapon.", default_wielded_slot, career_name)
		end

		self:_wield_slot(_equipment, var_5_16, _first_person_unit, _unit)

		local item_data = var_5_16.item_data
		local get_item_template = BackendUtils.get_item_template(item_data)

		self:_spawn_attached_units(get_item_template.first_person_attached_units)

		local backend_id = item_data.backend_id
		local _get_property_and_trait_buffs = self:_get_property_and_trait_buffs(backend_id)

		if not get_item_template.server_buffs then
			for k_4, v_3 in pairs(get_item_template.server_buffs) do
				_get_property_and_trait_buffs.server[k_4] = v_3
			end
		end

		self:apply_buffs(_get_property_and_trait_buffs, "wield", item_data.name, default_wielded_slot)

		local _equipment_2 = self._equipment
		local has_extension_2 = ScriptUnit.has_extension(_equipment_2.left_hand_wielded_unit, "weapon_system")

		if not has_extension_2 then
			has_extension_2:on_wield("left")
		end

		local has_extension_3 = ScriptUnit.has_extension(_equipment_2.right_hand_wielded_unit, "weapon_system")

		if not has_extension_3 then
			has_extension_3:on_wield("right")
		end
	end

	self._equipment.wielded_slot = _profile.default_wielded_slot
end

SimpleInventoryExtension._update_career_skill_weapon_slot = function (self)
	-- function 6
	if not self._first_person_unit then
		self._first_person_unit = ScriptUnit.extension(unit, "first_person_system"):get_first_person_unit()
	end

	local career_extension = self.career_extension
	local talent_extension = self.talent_extension
	local get_talent_career_skill_index

	if not talent_extension then
		get_talent_career_skill_index = talent_extension:get_talent_career_skill_index()

		if not get_talent_career_skill_index then
			-- Nothing
		end
	end

	get_talent_career_skill_index = 1

	::label_6_0::

	local flag = not talent_extension and talent_extension:get_talent_career_weapon_index()
	local career_skill_weapon_name = career_extension:career_skill_weapon_name(get_talent_career_skill_index, flag)

	if not career_skill_weapon_name then
		if not career_extension:should_reload_career_weapon() then
			local var_6_5 = rawget(ItemMasterList, career_skill_weapon_name)

			if self._equipment.wielded_slot == "slot_career_skill_weapon" then
				self:wield_previous_weapon()
			end

			self:destroy_slot("slot_career_skill_weapon", true)
			self:_queue_item_spawn("slot_career_skill_weapon", var_6_5)
		else
			self.initial_inventory.slot_career_skill_weapon = career_skill_weapon_name

			self:add_equipment_by_category("career_skill_weapon_slots")
			Unit.set_data(self._first_person_unit, "equipment", self._equipment)
		end
	end
end

SimpleInventoryExtension.update_career_skill_weapon_slot_safe = function (self)
	-- function 7
	self._queue_update_career_skill_weapon_slot = true
end

SimpleInventoryExtension.game_object_initialized = function (self, arg_8_1, arg_8_2)
	-- function 8
	local network = Managers.state.network
	local is_server = self.is_server
	local _equipment = self._equipment
	local slots = _equipment.slots

	for k, v in pairs(slots) do
		local item_data = v.item_data
		local var_8_5 = NetworkLookup.equipment_slots[k]
		local var_8_6 = NetworkLookup.item_names[item_data.name]
		local weapon_skins = NetworkLookup.weapon_skins
		local skin = v.skin

		skin = skin or "n/a"

		local var_8_9 = weapon_skins[skin]

		if not is_server then
			network.network_transmit:send_rpc_clients("rpc_add_equipment", arg_8_2, var_8_5, var_8_6, var_8_9)
		else
			network.network_transmit:send_rpc_server("rpc_add_equipment", arg_8_2, var_8_5, var_8_6, var_8_9)

			if not (k == "slot_ranged" or k ~= "slot_melee") then
				local backend_id = item_data.backend_id

				self:_send_rpc_add_equipment_buffs(arg_8_2, var_8_5, backend_id)
			end
		end

		self:swap_equipment_from_storage(k, SwapFromStorageType.UnwieldPrio, v.item_data)
	end

	local wielded_slot = _equipment.wielded_slot
	local var_8_12 = NetworkLookup.equipment_slots[wielded_slot]

	if not is_server then
		network.network_transmit:send_rpc_clients("rpc_wield_equipment", arg_8_2, var_8_12)
	else
		network.network_transmit:send_rpc_server("rpc_wield_equipment", arg_8_2, var_8_12)
	end

	BLACKBOARDS[arg_8_1].weapon_unit = self:get_weapon_unit()

	for k_2, v_2 in pairs(self._additional_items) do
		self:_resync_stored_items(k_2)
	end
end

SimpleInventoryExtension._send_rpc_add_equipment_buffs = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local function fn(arg_10_0, arg_10_1)
		-- function 10
		local tbl = {}
		local merge = table.merge(tbl, arg_10_1.server)
		local merge_2 = table.merge(merge, arg_10_1.both)
		local buffs_to_rpc_params = BuffUtils.buffs_to_rpc_params(merge_2)
		local var_10_4, var_10_5, var_10_6, var_10_7 = unpack(buffs_to_rpc_params)

		if not (#var_10_5 ~= #var_10_6 or #var_10_6 == #var_10_7) then
			fassert(false, "[SimpleInventoryExtension] Length of arrays buff_names(%d) and buff_value_types(%d) and buff_values(%d) are not equal!", #var_10_5, #var_10_6, #var_10_7)
		end

		if var_10_4 > 0 then
			Managers.state.network.network_transmit:send_rpc_server(arg_10_0, arg_9_1, arg_9_2, var_10_4, var_10_5, var_10_6, var_10_7)
		end
	end

	local _get_property_and_trait_buffs = self:_get_property_and_trait_buffs(arg_9_3)
	local get_item_from_masterlist = BackendUtils.get_item_from_masterlist(arg_9_3)
	local get_item_template = BackendUtils.get_item_template(get_item_from_masterlist)

	if not get_item_template.server_buffs then
		for k, v in pairs(get_item_template.server_buffs) do
			_get_property_and_trait_buffs.server[k] = v
		end
	end

	fn("rpc_add_equipment_buffs", _get_property_and_trait_buffs)

	local _get_no_wield_required_property_and_trait_buffs = self:_get_no_wield_required_property_and_trait_buffs(arg_9_3)

	fn("rpc_add_no_wield_required_equipment_buffs", _get_no_wield_required_property_and_trait_buffs)
end

SimpleInventoryExtension._override_career_skill_item_template = function (self, arg_11_1)
	-- function 11
	local var_11_0
	local var_11_1
	local slot_to_use = arg_11_1.slot_to_use

	if not slot_to_use then
		local var_11_3 = self._equipment.slots[slot_to_use]
		local var_11_4
		local var_11_5

		if not WeaponUtils.is_valid_weapon_override(var_11_3, arg_11_1) then
			var_11_4 = self:get_item_template(var_11_3)
			var_11_5 = var_11_3.item_data
		else
			local default_item_to_replace = arg_11_1.default_item_to_replace

			var_11_5 = ItemMasterList[default_item_to_replace]
			var_11_4 = WeaponUtils.get_weapon_template(var_11_5.template)
		end

		local get_item_template = BackendUtils.get_item_template(arg_11_1)

		get_item_template.left_hand_attachment_node_linking = var_11_4.left_hand_attachment_node_linking
		get_item_template.right_hand_attachment_node_linking = var_11_4.right_hand_attachment_node_linking
		get_item_template.wield_anim = var_11_4.wield_anim
		get_item_template.wield_anim_no_ammo = var_11_4.wield_anim_no_ammo
		get_item_template.wield_anim_career = var_11_4.wield_anim_career
		get_item_template.wield_anim_no_ammo_career = var_11_4.wield_anim_no_ammo_career
		var_11_1 = BackendUtils.get_item_units(arg_11_1)

		local get_item_units = BackendUtils.get_item_units(var_11_5)

		for k, v in pairs(arg_11_1.item_units_to_replace) do
			var_11_1[k] = get_item_units[k]
		end

		var_11_0 = get_item_template
	end

	return var_11_0, var_11_1
end

SimpleInventoryExtension.add_equipment_by_category = function (self, arg_12_1)
	-- function 12
	local career_name = self.career_extension:career_name()
	local var_12_1 = InventorySettings[arg_12_1]
	local count = #var_12_1

	for i = 1, count do
		repeat
			local var_12_3 = var_12_1[i]
			local name = var_12_3.name
			local get_loadout_item = BackendUtils.get_loadout_item(career_name, name, self.is_bot)
			local var_12_6
			local var_12_7 = self.initial_inventory[name]
			local var_12_8

			if not get_loadout_item then
				var_12_6 = table.clone(get_loadout_item.data)
				var_12_6.backend_id = get_loadout_item.backend_id
			else
				var_12_6 = rawget(ItemMasterList, var_12_7)

				if not var_12_6 then
					if not var_12_3.stored_in_backend then
						local get_loadout_item_id = BackendUtils.get_loadout_item_id(career_name, name, self.is_bot)
						local var_12_10

						if not get_loadout_item_id then
							var_12_10 = tostring(get_loadout_item_id)

							if not var_12_10 then
								-- Nothing
							end
						end

						var_12_10 = "No backend ID"

						::label_12_0::

						local get_interface = Managers.backend:get_interface("items")
						local str = "No item"

						if not get_loadout_item_id then
							local get_item_from_id = get_interface:get_item_from_id(get_loadout_item_id)

							str = not get_item_from_id and get_item_from_id.name and "Item exists"
						end

						local flag = Managers.backend._current_loadout_interface_override or "No override"
						local get_loadout_by_career_name = get_interface:get_loadout_by_career_name(career_name, self.is_bot)

						printf("self.initial_inventory: \n%s", table.tostring(self.initial_inventory))
						printf("Tried add_equipment_by_category for category <%s> for career <%s> at slot <%s>.\n BackendUtils.get_loadout_item didnt return a item.\n backend_id_string: %s\n item_string: %s\n loadout_interface_override_string: %s\n", arg_12_1, career_name, name, var_12_10, str, flag)
						table.dump(get_loadout_by_career_name, "career_loadout", 1)
					end

					break
				end
			end

			if not var_12_6.slot_to_use then
				local var_12_16 = self._equipment.slots[var_12_6.slot_to_use]

				if not var_12_16 then
					break
				end

				local var_12_17

				if not WeaponUtils.is_valid_weapon_override(var_12_16, var_12_6) then
					var_12_17 = var_12_16.item_data
				else
					local default_item_to_replace = var_12_6.default_item_to_replace

					var_12_17 = ItemMasterList[default_item_to_replace]
				end

				var_12_6.left_hand_unit = var_12_17.left_hand_unit
				var_12_6.right_hand_unit = var_12_17.right_hand_unit
			end

			self:add_equipment(name, var_12_6, nil, nil, self.initial_ammo_percent[name])
		until true
	end
end

SimpleInventoryExtension.destroy = function (self)
	-- function 13
	local system = Managers.state.entity:system("pickup_system")
	local system_2 = Managers.state.entity:system("projectile_system")
	local network_id = self.player:network_id()

	for k, v in pairs(self._equipment.slots) do
		if not system then
			local link_pickup_template_name = v.link_pickup_template_name

			if not link_pickup_template_name then
				system:delete_limited_owned_pickup_type(network_id, link_pickup_template_name)
			end
		end

		if not v.destroy_indexed_projectiles and not system_2 then
			system_2:delete_indexed_projectiles(self._unit)
		end

		GearUtils.destroy_slot(self._world, self._unit, v, self._equipment, true)
	end

	self:_despawn_attached_units()
	self:_stop_all_weapon_fx()
end

SimpleInventoryExtension._unlink_unit = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	World.unlink_unit(self._world, arg_14_1)

	local wielded = arg_14_3.wielded

	wielded = wielded or arg_14_3

	for i, v in ipairs(wielded) do
		local target = v.target

		if target ~= 0 then
			local node

			if type(target) == "string" then
				node = Unit.node(arg_14_1, target)

				if not node then
					-- Nothing
				end
			end

			node = target

			::label_14_0::

			local scene_graph_parent = Unit.scene_graph_parent(arg_14_1, node)

			Unit.scene_graph_link(arg_14_1, node, 0)
		end
	end

	Unit.set_flow_variable(arg_14_1, "lua_drop_reason", arg_14_2)
	Unit.set_shader_pass_flag_for_meshes_in_unit_and_childs(arg_14_1, "outline_unit", false)
	Unit.flow_event(arg_14_1, "lua_dropped")

	local create_actor = Unit.create_actor(arg_14_1, "rp_dropped")

	Actor.add_angular_velocity(create_actor, Vector3(math.random(), math.random(), math.random()) * 5)
	Actor.add_velocity(create_actor, Vector3(2 * math.random() - 0.5, 2 * math.random() - 0.5, 4.5))
end

SimpleInventoryExtension.drop_equipped_weapons = function (arg_15_0, arg_15_1, arg_15_2)
	-- function 15
	return
end

SimpleInventoryExtension.equipment = function (self)
	-- function 16
	return self._equipment
end

SimpleInventoryExtension.update = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	-- function 17
	if not self._queue_update_career_skill_weapon_slot then
		self:_update_career_skill_weapon_slot()

		self._queue_update_career_skill_weapon_slot = false
	end

	self:_update_selected_consumable_slot()
	self:_update_loaded_projectile_settings()
	self:_update_resync_loadout()

	local current_ammo_status, var_17_1 = self:current_ammo_status("slot_ranged")
	local num = 1
	local game = Managers.state.network:game()
	local go_id = Managers.state.unit_storage:go_id(arg_17_1)

	if not current_ammo_status and not var_17_1 then
		num = current_ammo_status / var_17_1

		GameSession.set_game_object_field(game, go_id, "current_ammo", current_ammo_status)
		GameSession.set_game_object_field(game, go_id, "max_ammo", var_17_1)
	end

	local min = math.min(1, num)

	GameSession.set_game_object_field(game, go_id, "ammo_percentage", min)
end

SimpleInventoryExtension.recently_acquired = function (self, arg_18_1)
	-- function 18
	local var_18_0 = self.recently_acquired_list[arg_18_1]

	self.recently_acquired_list[arg_18_1] = nil

	return var_18_0
end

SimpleInventoryExtension._update_resync_loadout = function (self)
	-- function 19
	local var_19_0, var_19_1 = next(self._items_to_spawn)

	if not var_19_1 then
		return
	end

	local profile_synchronizer = Managers.state.network.profile_synchronizer
	local network_id = self.player:network_id()
	local local_player_id = self.player:local_player_id()

	if not self.resync_loadout_needed then
		local flag = true

		profile_synchronizer:resync_loadout(network_id, local_player_id, self.is_bot, flag)

		self.resync_loadout_needed = false
	end

	if not profile_synchronizer:all_ingame_synced_for_peer(network_id, local_player_id) then
		self:_spawn_resynced_loadout(var_19_1)

		self._items_to_spawn[var_19_0] = nil
	end
end

SimpleInventoryExtension.can_wield = function (self)
	-- function 20
	local _equipment = self._equipment
	local wielded_slot = self._equipment.wielded_slot
	local item_data = _equipment.slots[wielded_slot].item_data
	local get_item_template = BackendUtils.get_item_template(item_data)
	local flag = true

	if not get_item_template.block_wielding then
		flag = false
	end

	return flag
end

SimpleInventoryExtension.wield_previous_slot = function (self)
	-- function 21
	local _previously_wielded_slot = self._previously_wielded_slot

	if not self:wield(_previously_wielded_slot) then
		return self:wield_previous_non_level_slot()
	end

	return true
end

SimpleInventoryExtension.wield_previous_non_level_slot = function (self)
	-- function 22
	local _previously_wielded_non_level_slot = self._previously_wielded_non_level_slot

	if not self:wield(_previously_wielded_non_level_slot) then
		return self:wield_previous_weapon()
	end

	return true
end

SimpleInventoryExtension.wield_previous_weapon = function (self)
	-- function 23
	local _previously_wielded_weapon_slot = self._previously_wielded_weapon_slot

	if not self:wield(_previously_wielded_weapon_slot) then
		return self:rewield_wielded_slot()
	end

	return true
end

SimpleInventoryExtension.rewield_wielded_slot = function (self)
	-- function 24
	local wielded_slot = self._equipment.wielded_slot

	return self:wield(wielded_slot)
end

SimpleInventoryExtension.wield = function (self, arg_25_1)
	-- function 25
	local _equipment = self._equipment
	local var_25_1 = _equipment.slots[arg_25_1]

	if var_25_1 == nil then
		return false
	end

	if _equipment.wielded_slot ~= arg_25_1 then
		self.buff_extension:trigger_procs("on_unwield")

		local has_extension = ScriptUnit.has_extension(_equipment.left_hand_wielded_unit, "weapon_system")

		if not has_extension then
			has_extension:on_unwield("left")
		end

		local has_extension_2 = ScriptUnit.has_extension(_equipment.right_hand_wielded_unit, "weapon_system")

		if not has_extension_2 then
			has_extension_2:on_unwield("right")
		end

		local var_25_4 = _equipment.slots[_equipment.wielded_slot]

		if not var_25_4 then
			self:swap_equipment_from_storage(_equipment.wielded_slot, SwapFromStorageType.UnwieldPrio, var_25_4.item_data)
		end
	end

	self:_stop_all_weapon_fx()
	self:_despawn_attached_units()

	local career_extension = self.career_extension

	CharacterStateHelper.stop_weapon_actions(self, "weapon_wielded")
	CharacterStateHelper.stop_career_abilities(career_extension, "weapon_wielded")

	local item_data = var_25_1.item_data
	local get_item_template = BackendUtils.get_item_template(item_data)
	local _wield_slot = self:_wield_slot(_equipment, var_25_1, self._first_person_unit, self._unit)

	_equipment.wielded_slot = arg_25_1

	local backend_id = item_data.backend_id
	local _get_property_and_trait_buffs = self:_get_property_and_trait_buffs(backend_id)

	if not get_item_template.buffs then
		for k, v in pairs(get_item_template.buffs) do
			_get_property_and_trait_buffs.client[k] = v
		end
	end

	if not get_item_template.server_buffs then
		for k_2, v_2 in pairs(get_item_template.server_buffs) do
			_get_property_and_trait_buffs.server[k_2] = v_2
		end
	end

	self:apply_buffs(_get_property_and_trait_buffs, "wield", item_data.name, arg_25_1)
	self.buff_extension:trigger_procs("on_inventory_post_apply_buffs", _equipment)

	if not _wield_slot then
		self:show_first_person_inventory(self._show_first_person)
		self:show_first_person_inventory_lights(self._show_first_person_lights)
		self:show_third_person_inventory(self._show_third_person)

		if arg_25_1 == "slot_packmaster_claw" then
			local get_pack_master_grabber = ScriptUnit.extension(self._unit, "status_system"):get_pack_master_grabber()
			local unit_owner = Managers.player:unit_owner(get_pack_master_grabber)
			local get_cosmetic_slot = CosmeticUtils.get_cosmetic_slot(unit_owner, "slot_skin")

			if not get_cosmetic_slot then
				if get_cosmetic_slot.item_name ~= "skaven_pack_master_skin_1001" then
					Unit.flow_event(self._equipment.right_hand_wielded_unit_3p, "lua_wield_0000")
				else
					Unit.flow_event(self._equipment.right_hand_wielded_unit_3p, "lua_wield_1001")
				end
			end
		end
	end

	local network = Managers.state.network
	local game = network:game()
	local var_25_16 = NetworkLookup.equipment_slots[arg_25_1]
	local go_id = Managers.state.unit_storage:go_id(self._unit)

	if not (not game and LEVEL_EDITOR_TEST) then
		if not self.is_server then
			network.network_transmit:send_rpc_clients("rpc_wield_equipment", go_id, var_25_16)
		else
			network.network_transmit:send_rpc_server("rpc_wield_equipment", go_id, var_25_16)
		end
	end

	self:_spawn_attached_units(get_item_template.first_person_attached_units)

	if not (arg_25_1 == "slot_melee" or arg_25_1 ~= "slot_ranged") then
		self._previously_wielded_weapon_slot = arg_25_1
	end

	if not (arg_25_1 == "slot_melee" or arg_25_1 == "slot_ranged" or arg_25_1 == "slot_grenade" or arg_25_1 == "slot_healthkit" or arg_25_1 == "slot_potion" or arg_25_1 ~= "slot_level_event") then
		self._previously_wielded_slot = arg_25_1
	end

	if not (arg_25_1 == "slot_melee" or arg_25_1 == "slot_ranged" or arg_25_1 == "slot_grenade" or arg_25_1 == "slot_healthkit" or arg_25_1 ~= "slot_potion") then
		self._previously_wielded_non_level_slot = arg_25_1
	end

	self:start_weapon_fx("wield")

	local has_extension_3 = ScriptUnit.has_extension(_equipment.left_hand_wielded_unit, "weapon_system")

	if not has_extension_3 then
		has_extension_3:on_wield("left")
	end

	local has_extension_4 = ScriptUnit.has_extension(_equipment.right_hand_wielded_unit, "weapon_system")

	if not has_extension_4 then
		has_extension_4:on_wield("right")
	end

	self.buff_extension:trigger_procs("on_wield")

	return true
end

SimpleInventoryExtension._despawn_attached_units = function (self)
	-- function 26
	local _attached_units = self._attached_units

	for k, v in pairs(_attached_units) do
		Managers.state.unit_spawner:mark_for_deletion(v)

		_attached_units[k] = nil
	end
end

SimpleInventoryExtension._spawn_attached_units = function (self, arg_27_1)
	-- function 27
	if arg_27_1 == nil then
		return
	end

	local _unit = self._unit
	local _world = self._world
	local _attached_units = self._attached_units

	for k, v in pairs(arg_27_1) do
		_attached_units[k] = AttachmentUtils.create_weapon_visual_attachment(_world, _unit, v.unit, v.attachment_node_linking)
	end
end

local tbl_2 = {}

SimpleInventoryExtension.apply_buffs = function (self, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	-- function 28
	local buff_extension = self.buff_extension
	local var_28_1 = self.current_item_buffs[arg_28_2]

	if arg_28_2 == "wield" then
		for i = 1, #var_28_1 do
			local var_28_2 = var_28_1[i]

			buff_extension:remove_buff(var_28_2)
		end

		table.clear(var_28_1)
	elseif arg_28_2 == "equip" then
		var_28_1 = var_28_1[arg_28_4]

		if not var_28_1 then
			for j = 1, #var_28_1 do
				local var_28_3 = var_28_1[j]

				buff_extension:remove_buff(var_28_3)
			end

			table.clear(var_28_1)
		end
	end

	local num = 1

	for k, v in pairs(arg_28_1) do
		if not (self.is_server or k == "client" or k ~= "both") then
			for k_2, v_2 in pairs(v) do
				local get_buff_template = BuffUtils.get_buff_template(k_2)

				fassert(get_buff_template, "buff name %s does not exist on item %s, typo?", k_2, arg_28_3)
				table.clear(tbl_2)

				for k_3, v_3 in pairs(v_2) do
					tbl_2[k_3] = v_3
				end

				var_28_1[num] = buff_extension:add_buff(k_2, tbl_2)
				num = num + 1
			end
		end
	end
end

SimpleInventoryExtension.has_inventory_item = function (self, arg_29_1, arg_29_2)
	-- function 29
	local get_slot_data = self:get_slot_data(arg_29_1)

	if not (not get_slot_data and arg_29_2 ~= get_slot_data.item_data.name) then
		return true
	end

	local get_additional_items = self:get_additional_items(arg_29_1)

	if not get_additional_items then
		for i = 1, #get_additional_items do
			if arg_29_2 == get_additional_items[i].name then
				return true
			end
		end
	end

	return false
end

SimpleInventoryExtension.add_equipment = function (self, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5)
	-- function 30
	local var_30_0

	if type(arg_30_2) == "string" then
		var_30_0 = ItemMasterList[arg_30_2]
	else
		var_30_0 = arg_30_2
	end

	local _world = self._world
	local _equipment = self._equipment
	local _first_person_unit = self._first_person_unit
	local _unit = self._unit
	local is_bot = self.is_bot
	local _career_name = self._career_name
	local _override_career_skill_item_template, var_30_8 = self:_override_career_skill_item_template(var_30_0)
	local create_equipment = GearUtils.create_equipment(_world, arg_30_1, var_30_0, _first_person_unit, _unit, is_bot, arg_30_3, arg_30_4, arg_30_5, _override_career_skill_item_template, var_30_8, _career_name)

	create_equipment.master_item = var_30_0
	_equipment.slots[arg_30_1] = create_equipment
	self.recently_acquired_list[arg_30_1] = create_equipment

	CosmeticUtils.update_cosmetic_slot(self.player, arg_30_1, var_30_0.name, create_equipment.skin)

	local get_item_from_id = Managers.backend:get_interface("items"):get_item_from_id(var_30_0.backend_id)

	get_item_from_id = get_item_from_id or rawget(ItemMasterList, var_30_0.name)

	LoadoutUtils.sync_loadout_slot(self.player, arg_30_1, get_item_from_id)

	local name = var_30_0.name
	local _get_no_wield_required_property_and_trait_buffs = self:_get_no_wield_required_property_and_trait_buffs(var_30_0.backend_id)

	self:apply_buffs(_get_no_wield_required_property_and_trait_buffs, "equip", name, arg_30_1)
end

SimpleInventoryExtension.show_first_person_inventory_lights = function (self, arg_31_1)
	-- function 31
	self._show_first_person_lights = arg_31_1

	local right_hand_wielded_unit = self._equipment.right_hand_wielded_unit

	if not right_hand_wielded_unit and not Unit.alive(right_hand_wielded_unit) and not Unit.has_visibility_group(right_hand_wielded_unit, "normal") then
		local num_lights = Unit.num_lights(right_hand_wielded_unit)

		for i = 1, num_lights do
			Light.set_enabled(Unit.light(right_hand_wielded_unit, i - 1), arg_31_1)
		end
	end

	local left_hand_wielded_unit = self._equipment.left_hand_wielded_unit

	if not left_hand_wielded_unit and not Unit.alive(left_hand_wielded_unit) and not Unit.has_visibility_group(left_hand_wielded_unit, "normal") then
		local num_lights_2 = Unit.num_lights(left_hand_wielded_unit)

		for j = 1, num_lights_2 do
			Light.set_enabled(Unit.light(left_hand_wielded_unit, j - 1), arg_31_1)
		end
	end
end

SimpleInventoryExtension.show_first_person_inventory = function (self, arg_32_1)
	-- function 32
	self._show_first_person = arg_32_1

	local right_hand_wielded_unit = self._equipment.right_hand_wielded_unit

	if not right_hand_wielded_unit and not Unit.alive(right_hand_wielded_unit) then
		if not Unit.has_visibility_group(right_hand_wielded_unit, "normal") then
			Unit.set_visibility(right_hand_wielded_unit, "normal", arg_32_1)
		else
			Unit.set_unit_visibility(right_hand_wielded_unit, arg_32_1)
		end

		if not arg_32_1 then
			Unit.flow_event(right_hand_wielded_unit, "lua_wield")
		else
			Unit.flow_event(right_hand_wielded_unit, "lua_unwield")
		end
	end

	local left_hand_wielded_unit = self._equipment.left_hand_wielded_unit

	if not left_hand_wielded_unit and not Unit.alive(left_hand_wielded_unit) then
		if not Unit.has_visibility_group(left_hand_wielded_unit, "normal") then
			Unit.set_visibility(left_hand_wielded_unit, "normal", arg_32_1)
		else
			Unit.set_unit_visibility(left_hand_wielded_unit, arg_32_1)
		end

		if not arg_32_1 then
			Unit.flow_event(left_hand_wielded_unit, "lua_wield")
		else
			Unit.flow_event(left_hand_wielded_unit, "lua_unwield")
		end
	end

	self:show_first_person_ammo(arg_32_1)
	self:_despawn_attached_units()

	local _equipment = self._equipment
	local wielded_slot = _equipment.wielded_slot

	if not wielded_slot then
		local var_32_4 = _equipment.slots[wielded_slot]

		if not var_32_4 then
			local item_data = var_32_4.item_data
			local get_item_template = BackendUtils.get_item_template(item_data)

			if not arg_32_1 then
				self:_spawn_attached_units(get_item_template.first_person_attached_units)
			else
				self:_spawn_attached_units(get_item_template.third_person_attached_units)
			end
		end
	end

	if not arg_32_1 then
		Unit.flow_event(self._first_person_unit, "lua_wield")
	else
		Unit.flow_event(self._first_person_unit, "lua_unwield")
	end
end

SimpleInventoryExtension.show_first_person_ammo = function (self, arg_33_1)
	-- function 33
	local _equipment = self._equipment
	local right_hand_wielded_unit = _equipment.right_hand_wielded_unit
	local left_hand_wielded_unit = _equipment.left_hand_wielded_unit

	if not right_hand_wielded_unit and not Unit.alive(right_hand_wielded_unit) then
		local right_hand_ammo_unit_1p = _equipment.right_hand_ammo_unit_1p

		if not right_hand_ammo_unit_1p then
			Unit.set_unit_visibility(right_hand_ammo_unit_1p, arg_33_1)

			if not arg_33_1 then
				Unit.flow_event(right_hand_ammo_unit_1p, "lua_wield")
			else
				Unit.flow_event(right_hand_ammo_unit_1p, "lua_unwield")
			end
		end
	end

	if not left_hand_wielded_unit and not Unit.alive(left_hand_wielded_unit) then
		local left_hand_ammo_unit_1p = _equipment.left_hand_ammo_unit_1p

		if not left_hand_ammo_unit_1p then
			Unit.set_unit_visibility(left_hand_ammo_unit_1p, arg_33_1)

			if not arg_33_1 then
				Unit.flow_event(left_hand_ammo_unit_1p, "lua_wield")
			else
				Unit.flow_event(left_hand_ammo_unit_1p, "lua_unwield")
			end
		end
	end
end

SimpleInventoryExtension.show_third_person_inventory = function (self, arg_34_1)
	-- function 34
	self._show_third_person = arg_34_1

	local right_hand_wielded_unit_3p = self._equipment.right_hand_wielded_unit_3p

	if not right_hand_wielded_unit_3p then
		if not Unit.has_visibility_group(right_hand_wielded_unit_3p, "normal") then
			Unit.set_visibility(right_hand_wielded_unit_3p, "normal", arg_34_1)
		else
			Unit.set_unit_visibility(right_hand_wielded_unit_3p, arg_34_1)
		end

		local right_hand_ammo_unit_3p = self._equipment.right_hand_ammo_unit_3p

		if not right_hand_ammo_unit_3p then
			Unit.set_unit_visibility(right_hand_ammo_unit_3p, arg_34_1)
		end

		if not arg_34_1 then
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
			Unit.set_visibility(left_hand_wielded_unit_3p, "normal", arg_34_1)
		else
			Unit.set_unit_visibility(left_hand_wielded_unit_3p, arg_34_1)
		end

		local left_hand_ammo_unit_3p = self._equipment.left_hand_ammo_unit_3p

		if not left_hand_ammo_unit_3p then
			Unit.set_unit_visibility(left_hand_ammo_unit_3p, arg_34_1)
		end

		if not arg_34_1 then
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
	local wielded_slot = self._equipment.wielded_slot

	if not wielded_slot then
		local var_34_6 = _equipment.slots[wielded_slot]

		if not var_34_6 then
			local item_data = var_34_6.item_data
			local get_item_template = BackendUtils.get_item_template(item_data)

			if not arg_34_1 then
				self:_spawn_attached_units(get_item_template.third_person_attached_units)
			else
				self:_spawn_attached_units(get_item_template.first_person_attached_units)
			end
		end
	end

	if not arg_34_1 then
		Unit.flow_event(self._unit, "lua_wield")
	else
		Unit.flow_event(self._unit, "lua_unwield")
	end
end

SimpleInventoryExtension.is_showing_third_person_inventory = function (self)
	-- function 35
	return self._show_third_person
end

SimpleInventoryExtension.hot_join_sync = function (self, arg_36_1)
	-- function 36
	GearUtils.hot_join_sync(arg_36_1, self._unit, self._equipment, self._additional_items)
end

SimpleInventoryExtension.destroy_item_by_name = function (self, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
	-- function 37
	local get_slot_data = self:get_slot_data(arg_37_1)

	if not (not get_slot_data and get_slot_data.item_data.name ~= arg_37_2) then
		self:destroy_slot(arg_37_1, arg_37_3, arg_37_4)
	else
		local get_additional_items = self:get_additional_items(arg_37_1)

		if not get_additional_items then
			for i = #get_additional_items, 1, -1 do
				local var_37_2 = get_additional_items[i]

				if var_37_2.name == arg_37_2 then
					self:remove_additional_item(arg_37_1, var_37_2)

					break
				end
			end
		end
	end
end

SimpleInventoryExtension.destroy_slot = function (self, arg_38_1, arg_38_2, arg_38_3)
	-- function 38
	local _equipment = self._equipment
	local var_38_1 = _equipment.slots[arg_38_1]

	if var_38_1 == nil then
		if not arg_38_3 then
			self:swap_equipment_from_storage(arg_38_1)
		end

		return
	end

	local right_unit_1p = var_38_1.right_unit_1p

	right_unit_1p = right_unit_1p or var_38_1.left_unit_1p

	if not Managers.player.is_server and not ScriptUnit.has_extension(right_unit_1p, "limited_item_track_system") then
		local extension = ScriptUnit.extension(right_unit_1p, "limited_item_track_system")

		if not extension.thrown then
			local spawner_unit = extension.spawner_unit
			local extension_2 = ScriptUnit.extension(spawner_unit, "limited_item_track_system")
			local id = extension.id

			if not extension_2:is_transformed(id) then
				Managers.state.entity:system("limited_item_track_system"):held_limited_item_destroyed(spawner_unit, id)
			end
		end
	end

	local link_pickup_template_name = var_38_1.link_pickup_template_name
	local system = Managers.state.entity:system("pickup_system")

	if not link_pickup_template_name then
		system:delete_limited_owned_pickup_type(self.player:network_id(), link_pickup_template_name)
	end

	if not var_38_1.destroy_indexed_projectiles then
		Managers.state.entity:system("projectile_system"):delete_indexed_projectiles(self._unit)
	end

	local go_id = Managers.state.unit_storage:go_id(self._unit)
	local var_38_10 = NetworkLookup.equipment_slots[arg_38_1]
	local network = Managers.state.network

	if not (not Managers.state.network:game() and LEVEL_EDITOR_TEST) then
		if not self.is_server then
			network.network_transmit:send_rpc_clients("rpc_destroy_slot", go_id, var_38_10)
		else
			network.network_transmit:send_rpc_server("rpc_destroy_slot", go_id, var_38_10)
		end
	end

	GearUtils.destroy_slot(self._world, self._unit, var_38_1, _equipment, arg_38_2)

	if not arg_38_3 then
		self:swap_equipment_from_storage(arg_38_1, SwapFromStorageType.SameOrAny, var_38_1.item_data)
	end
end

SimpleInventoryExtension.current_ammo_status = function (self, arg_39_1)
	-- function 39
	local var_39_0 = self._equipment.slots[arg_39_1]

	if not var_39_0 then
		return
	end

	if not self:get_item_template(var_39_0).ammo_data then
		local right_unit_1p = var_39_0.right_unit_1p
		local left_unit_1p = var_39_0.left_unit_1p
		local get_ammo_extension = GearUtils.get_ammo_extension(right_unit_1p, left_unit_1p)

		if not get_ammo_extension then
			local total_remaining_ammo = get_ammo_extension:total_remaining_ammo()
			local max_ammo = get_ammo_extension:max_ammo()

			return total_remaining_ammo, max_ammo
		end
	end
end

SimpleInventoryExtension.ammo_percentage = function (self)
	-- function 40
	local current_ammo_status, var_40_1 = self:current_ammo_status("slot_ranged")
	local num = 1

	if not current_ammo_status and not var_40_1 then
		num = current_ammo_status / var_40_1
	end

	return num
end

SimpleInventoryExtension.ammo_status = function (self)
	-- function 41
	local current_ammo_status, var_41_1 = self:current_ammo_status("slot_ranged")

	return current_ammo_status, var_41_1
end

SimpleInventoryExtension.current_ammo_kind = function (self, arg_42_1)
	-- function 42
	local var_42_0 = self._equipment.slots[arg_42_1]

	if not var_42_0 then
		return
	end

	if not self:get_item_template(var_42_0).ammo_data then
		local right_unit_1p = var_42_0.right_unit_1p
		local left_unit_1p = var_42_0.left_unit_1p
		local get_ammo_extension = GearUtils.get_ammo_extension(right_unit_1p, left_unit_1p)

		if not get_ammo_extension then
			return (get_ammo_extension:ammo_kind())
		end
	end
end

SimpleInventoryExtension.add_ammo_from_pickup = function (self, arg_43_1)
	-- function 43
	local slots = self._equipment.slots
	local refill_percentage = arg_43_1.refill_percentage
	local refill_amount = arg_43_1.refill_amount

	fassert(not refill_percentage and not refill_amount, "ammo pickups has to contain either refill_percentage or refill_amount, not both")

	for k, v in pairs(slots) do
		local ammo_data = self:get_item_template(v).ammo_data

		if not (not ammo_data and ammo_data.ignore_ammo_pickup) then
			self:_add_ammo_to_slot(k, v, refill_percentage, refill_amount)
		end
	end
end

SimpleInventoryExtension._add_ammo_to_slot = function (self, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
	-- function 44
	local left_unit_1p = arg_44_2.left_unit_1p
	local right_unit_1p = arg_44_2.right_unit_1p
	local var_44_2

	if not left_unit_1p and not ScriptUnit.has_extension(left_unit_1p, "ammo_system") then
		var_44_2 = ScriptUnit.extension(left_unit_1p, "ammo_system")
	end

	if not right_unit_1p then
		if not ScriptUnit.has_extension(right_unit_1p, "ammo_system") then
			var_44_2 = ScriptUnit.extension(right_unit_1p, "ammo_system")
		elseif not var_44_2 then
			return
		end
	elseif not var_44_2 then
		return
	end

	local max_ammo = var_44_2:max_ammo()

	if not arg_44_3 then
		arg_44_4 = max_ammo * arg_44_3
	end

	var_44_2:add_ammo(arg_44_4)

	local reload_on_ammo_pickup = var_44_2:reload_on_ammo_pickup()

	reload_on_ammo_pickup = reload_on_ammo_pickup or var_44_2:ammo_count() == 0

	if not reload_on_ammo_pickup and self._equipment.wielded_slot ~= arg_44_1 or not var_44_2:can_reload() then
		local flag = true

		var_44_2:start_reload(flag)

		if not var_44_2:reload_on_ammo_pickup() then
			CharacterStateHelper.stop_weapon_actions(self, "reload")
		end
	end
end

SimpleInventoryExtension.get_item_template = function (arg_45_0, arg_45_1)
	-- function 45
	if not arg_45_1 then
		local item_data = arg_45_1.item_data

		return (BackendUtils.get_item_template(item_data))
	end

	return nil
end

SimpleInventoryExtension.get_wielded_slot_item_template = function (self)
	-- function 46
	local get_wielded_slot_name = self:get_wielded_slot_name()
	local get_slot_data = self:get_slot_data(get_wielded_slot_name)

	return self:get_item_template(get_slot_data)
end

SimpleInventoryExtension.get_wielded_slot_name = function (self)
	-- function 47
	return self._equipment.wielded_slot
end

SimpleInventoryExtension.get_slot_data = function (self, arg_48_1)
	-- function 48
	return self._equipment.slots[arg_48_1]
end

SimpleInventoryExtension.get_wielded_slot_data = function (self)
	-- function 49
	local get_wielded_slot_name = self:get_wielded_slot_name()

	return (self:get_slot_data(get_wielded_slot_name))
end

SimpleInventoryExtension.get_item_name = function (self, arg_50_1)
	-- function 50
	local get_slot_data = self:get_slot_data(arg_50_1)
	local flag = not get_slot_data and get_slot_data.item_data

	return not flag and flag.name
end

SimpleInventoryExtension.get_item_data = function (self, arg_51_1)
	-- function 51
	local get_slot_data = self:get_slot_data(arg_51_1)

	return not get_slot_data and get_slot_data.item_data
end

SimpleInventoryExtension.create_equipment_in_slot = function (self, arg_52_1, arg_52_2, arg_52_3)
	-- function 52
	local get_item_from_masterlist = BackendUtils.get_item_from_masterlist(arg_52_2)

	if not get_item_from_masterlist then
		Crashify.print_exception("SimpleInventoryExtension", "Tried create equip %q in slot %q but was unable to find item", arg_52_2, arg_52_1)

		return
	end

	local var_52_1 = self._equipment.slots[arg_52_1]
	local var_52_2
	local flag

	if not var_52_1 then
		print("[SimpleInventoryExtension] create_equipment_in_slot called on " .. arg_52_1 .. "that is empty")

		flag = false
	else
		flag = var_52_1.item_data == get_item_from_masterlist
	end

	local get_item_units = BackendUtils.get_item_units(get_item_from_masterlist, nil, nil, self._career_name)

	if not flag then
		return
	end

	self:destroy_slot(arg_52_1, true)

	if arg_52_1 == self._equipment.wielded_slot then
		local default_state_machine = self._profile.default_state_machine

		if not default_state_machine then
			self.first_person_extension:set_state_machine(default_state_machine)
		end
	end

	self:_queue_item_spawn(arg_52_1, get_item_from_masterlist, get_item_units.skin, arg_52_3)

	local talent_extension = self.talent_extension
	local get_talent_career_skill_index

	if not talent_extension then
		get_talent_career_skill_index = talent_extension:get_talent_career_skill_index()

		if not get_talent_career_skill_index then
			-- Nothing
		end
	end

	get_talent_career_skill_index = 1

	::label_52_0::

	local flag_2 = not talent_extension and talent_extension:get_talent_career_weapon_index()
	local career_skill_weapon_name = self.career_extension:career_skill_weapon_name(get_talent_career_skill_index, flag_2)

	if not career_skill_weapon_name then
		local var_52_10 = rawget(ItemMasterList, career_skill_weapon_name)

		if not (not var_52_10 and var_52_10.slot_to_use ~= arg_52_1) then
			self:destroy_slot("slot_career_skill_weapon", true)

			var_52_10.left_hand_unit = get_item_from_masterlist.left_hand_unit
			var_52_10.right_hand_unit = get_item_from_masterlist.right_hand_unit

			self:_queue_item_spawn("slot_career_skill_weapon", var_52_10, get_item_units.skin)
		end
	end
end

SimpleInventoryExtension._queue_item_spawn = function (self, arg_53_1, arg_53_2, arg_53_3, arg_53_4)
	-- function 53
	if not (not arg_53_1 and arg_53_2) then
		return
	end

	self._items_to_spawn[arg_53_1] = {
		slot_id = arg_53_1,
		item_data = arg_53_2,
		skin = arg_53_3,
		ammo_percent = arg_53_4
	}
	self.resync_loadout_needed = true
end

SimpleInventoryExtension._spawn_resynced_loadout = function (self, arg_54_1, arg_54_2)
	-- function 54
	local item_data = arg_54_1.item_data
	local slot_id = arg_54_1.slot_id
	local ammo_percent = arg_54_1.ammo_percent
	local network = Managers.state.network
	local go_id = Managers.state.unit_storage:go_id(self._unit)
	local var_54_5 = NetworkLookup.equipment_slots[slot_id]
	local var_54_6 = NetworkLookup.item_names[item_data.name]
	local weapon_skins = NetworkLookup.weapon_skins
	local skin = arg_54_1.skin

	skin = skin or "n/a"

	local var_54_9 = weapon_skins[skin]

	if not self.is_server then
		network.network_transmit:send_rpc_clients("rpc_add_equipment", go_id, var_54_5, var_54_6, var_54_9)
	else
		network.network_transmit:send_rpc_server("rpc_add_equipment", go_id, var_54_5, var_54_6, var_54_9)

		if not (slot_id == "slot_ranged" or slot_id ~= "slot_melee") then
			local backend_id = item_data.backend_id

			self:_send_rpc_add_equipment_buffs(go_id, var_54_5, backend_id)
		end
	end

	local var_54_11
	local var_54_12

	self:add_equipment(slot_id, item_data, var_54_11, var_54_12, ammo_percent)

	if not (arg_54_2 or slot_id == "slot_career_skill_weapon" or slot_id == "slot_level_event") then
		self:wield(slot_id)
	end
end

local tbl_3 = {
	slot_ranged = true,
	slot_melee = true
}

SimpleInventoryExtension.has_unique_ammo_type_weapon_equipped = function (self)
	-- function 55
	local slots = self._equipment.slots

	for k, v in pairs(slots) do
		if not tbl_3[k] then
			local get_item_template = self:get_item_template(v)

			if not get_item_template then
				local ammo_data = get_item_template.ammo_data

				if not ammo_data and not ammo_data.unique_ammo_type then
					return true
				end
			end
		end
	end

	return false
end

SimpleInventoryExtension.has_ammo_consuming_weapon_equipped = function (self, arg_56_1)
	-- function 56
	local slots = self._equipment.slots
	local flag = false

	for k, v in pairs(slots) do
		if not tbl_3[k] then
			local left_unit_1p = v.left_unit_1p
			local flag_2 = not left_unit_1p and ScriptUnit.has_extension(left_unit_1p, "ammo_system")

			if not flag_2 then
				if not arg_56_1 then
					flag = flag_2:ammo_type() == arg_56_1
				else
					flag = true
				end
			end

			local right_unit_1p = v.right_unit_1p
			local flag_3 = not right_unit_1p and ScriptUnit.has_extension(right_unit_1p, "ammo_system")

			if not flag_3 then
				if not arg_56_1 then
					flag = flag_3:ammo_type() == arg_56_1
				else
					flag = true
				end
			end
		end

		if not flag then
			return true
		end
	end

	return false
end

SimpleInventoryExtension.has_infinite_ammo = function (self)
	-- function 57
	local slots = self._equipment.slots
	local flag = false

	for k, v in pairs(slots) do
		if not tbl_3[k] then
			local left_unit_1p = v.left_unit_1p
			local flag_2 = not left_unit_1p and ScriptUnit.has_extension(left_unit_1p, "ammo_system")

			if not flag_2 and not flag_2:infinite_ammo() then
				return true
			end

			local right_unit_1p = v.right_unit_1p
			local flag_3 = not right_unit_1p and ScriptUnit.has_extension(right_unit_1p, "ammo_system")

			if not flag_3 and not flag_3:infinite_ammo() then
				return true
			end
		end
	end

	return false
end

SimpleInventoryExtension.reset_ammo = function (self, arg_58_1)
	-- function 58
	local var_58_0 = self._equipment.slots[arg_58_1]
	local right_unit_1p = var_58_0.right_unit_1p
	local has_extension = ScriptUnit.has_extension(right_unit_1p, "ammo_system")

	has_extension = not has_extension and ScriptUnit.extension(right_unit_1p, "ammo_system")

	if not has_extension then
		has_extension:reset()
	end

	local left_unit_1p = var_58_0.left_unit_1p
	local has_extension_2 = ScriptUnit.has_extension(left_unit_1p, "ammo_system")

	has_extension_2 = not has_extension_2 and ScriptUnit.extension(left_unit_1p, "ammo_system")

	if not has_extension_2 then
		has_extension_2:reset()
	end
end

SimpleInventoryExtension.has_full_ammo = function (self)
	-- function 59
	local slots = self._equipment.slots
	local flag = true

	for k, v in pairs(slots) do
		if not tbl_3[k] then
			local left_unit_1p = v.left_unit_1p
			local right_unit_1p = v.right_unit_1p
			local has_extension = ScriptUnit.has_extension(right_unit_1p, "ammo_system")

			has_extension = not has_extension and ScriptUnit.extension(right_unit_1p, "ammo_system")
			has_extension = has_extension or not ScriptUnit.has_extension(left_unit_1p, "ammo_system") or ScriptUnit.extension(left_unit_1p, "ammo_system")

			if not (not has_extension and has_extension:full_ammo()) then
				flag = false

				break
			end
		end
	end

	return flag
end

SimpleInventoryExtension.is_ammo_blocked = function (self)
	-- function 60
	local slots = self._equipment.slots
	local flag = false

	for k, v in pairs(slots) do
		if not tbl_3[k] then
			local left_unit_1p = v.left_unit_1p
			local right_unit_1p = v.right_unit_1p
			local has_extension = ScriptUnit.has_extension(right_unit_1p, "ammo_system")

			has_extension = not has_extension and ScriptUnit.extension(right_unit_1p, "ammo_system")
			has_extension = has_extension or not ScriptUnit.has_extension(left_unit_1p, "ammo_system") or ScriptUnit.extension(left_unit_1p, "ammo_system")

			if not has_extension and not has_extension:ammo_blocked() then
				flag = true

				break
			end
		end
	end

	return flag
end

SimpleInventoryExtension.apply_buffs_to_ammo = function (self)
	-- function 61
	local slots = self._equipment.slots

	for k, v in pairs(slots) do
		if not tbl_3[k] then
			local left_unit_1p = v.left_unit_1p
			local right_unit_1p = v.right_unit_1p
			local has_extension = ScriptUnit.has_extension(left_unit_1p, "ammo_system")

			if not has_extension then
				has_extension:apply_buffs()
			end

			local has_extension_2 = ScriptUnit.has_extension(right_unit_1p, "ammo_system")

			if not has_extension_2 then
				has_extension_2:apply_buffs()
			end
		end
	end
end

SimpleInventoryExtension.refresh_buffs_on_ammo = function (self)
	-- function 62
	local slots = self._equipment.slots

	for k, v in pairs(slots) do
		if not tbl_3[k] then
			local left_unit_1p = v.left_unit_1p
			local right_unit_1p = v.right_unit_1p
			local has_extension = ScriptUnit.has_extension(left_unit_1p, "ammo_system")

			if not has_extension then
				has_extension:refresh_buffs()
			end

			local has_extension_2 = ScriptUnit.has_extension(right_unit_1p, "ammo_system")

			if not has_extension_2 then
				has_extension_2:refresh_buffs()
			end
		end
	end
end

SimpleInventoryExtension.drop_level_event_item = function (self, arg_63_1)
	-- function 63
	local get_item_template = self:get_item_template(arg_63_1)

	if not get_item_template.no_drop then
		return
	end

	local right_unit_1p = arg_63_1.right_unit_1p

	right_unit_1p = right_unit_1p or arg_63_1.left_unit_1p

	local default = get_item_template.actions.action_dropped.default

	fassert(default, "Action template needs a action_dropped defined if it's supposed to be force-dropped")

	local projectile_info = default.projectile_info
	local _unit = self._unit
	local num = Unit.world_position(_unit, 0) + Vector3(0, 0, 2)

	if not NetworkUtils.network_safe_position(num) then
		local identity = Quaternion.identity()
		local var_63_7 = Vector3(math.random(), math.random(), math.random())
		local var_63_8 = Vector3(math.random(), math.random(), math.random())
		local name = arg_63_1.item_data.name
		local str = "dropped"

		ActionUtils.spawn_pickup_projectile(self._world, right_unit_1p, projectile_info.projectile_unit_name, projectile_info.projectile_unit_template_name, default, _unit, num, identity, var_63_7, var_63_8, name, str)
	end

	self:destroy_slot("slot_level_event")
end

local function fn(arg_64_0, arg_64_1, arg_64_2)
	-- function 64
	local flag = arg_64_1 or Vector3(math.random(-1, 1) * arg_64_2, math.random(-1, 1) * arg_64_2, 2)
	local normalize = Vector3.normalize(flag)

	return arg_64_0 + flag * 0.2, normalize
end

local function fn_2(arg_65_0, arg_65_1, arg_65_2, arg_65_3)
	-- function 65
	if not NetworkUtils.network_safe_position(arg_65_2) then
		local num = math.random(-math.half_pi, math.half_pi) / 2
		local axis_angle = Quaternion.axis_angle(arg_65_3, num)
		local pickup_name = arg_65_1.pickup_name
		local var_65_3 = NetworkLookup.pickup_names[pickup_name]
		local str = "dropped"
		local var_65_5 = NetworkLookup.pickup_spawn_types[str]

		Managers.state.network.network_transmit:send_rpc_server("rpc_spawn_pickup_with_physics", var_65_3, arg_65_2, axis_angle, var_65_5)
	end
end

SimpleInventoryExtension.check_and_drop_pickups = function (self, arg_66_1, arg_66_2, arg_66_3)
	-- function 66
	local _unit = self._unit
	local slots = self._equipment.slots
	local slots_by_name = InventorySettings.slots_by_name
	local get_wielded_slot_name = self:get_wielded_slot_name()
	local num = 0
	local flag = arg_66_2 or POSITION_LOOKUP[_unit]

	for k, v in pairs(slots) do
		if not v then
			local item_data = v.item_data
			local pickup_data = BackendUtils.get_item_template(item_data).pickup_data
			local drop_reasons = slots_by_name[k].drop_reasons

			if not (not drop_reasons and drop_reasons[arg_66_1]) then
				if not (not pickup_data and k == "slot_level_event") then
					local var_66_9, var_66_10 = fn(flag, arg_66_3, num)

					fn_2(_unit, pickup_data, var_66_9, var_66_10)

					num = num + 1
				elseif k == "slot_level_event" then
					self:drop_level_event_item(v)
				end

				local get_additional_items = self:get_additional_items(k)

				if not get_additional_items then
					for k_2 = #get_additional_items, 1, -1 do
						local var_66_12 = get_additional_items[k_2]
						local pickup_data_2 = BackendUtils.get_item_template(var_66_12).pickup_data

						if not pickup_data_2 then
							local var_66_14, var_66_15 = fn(flag, arg_66_3, num)

							fn_2(_unit, pickup_data_2, var_66_14, var_66_15)

							num = num + 1
						end

						local flag_2 = k_2 > 1

						self:remove_additional_item(k, var_66_12, flag_2)
					end
				end

				self:destroy_slot(k)

				if k == get_wielded_slot_name then
					self:wield_previous_weapon()
				end
			end
		end
	end
end

SimpleInventoryExtension.set_loaded_projectile_override = function (self, arg_67_1)
	-- function 67
	self._loaded_projectile_settings_override = arg_67_1
end

SimpleInventoryExtension._update_loaded_projectile_settings = function (self)
	-- function 68
	local var_68_0
	local get_wielded_slot_item_template = self:get_wielded_slot_item_template()
	local _loaded_projectile_settings_override = self._loaded_projectile_settings_override

	if not _loaded_projectile_settings_override then
		if _loaded_projectile_settings_override ~= "none" then
			var_68_0 = _loaded_projectile_settings_override
		end
	elseif not get_wielded_slot_item_template then
		var_68_0 = get_wielded_slot_item_template.default_loaded_projectile_settings
	end

	self._loaded_projectile_settings = var_68_0
end

SimpleInventoryExtension.get_loaded_projectile_settings = function (self)
	-- function 69
	return self._loaded_projectile_settings
end

SimpleInventoryExtension._update_selected_consumable_slot = function (self)
	-- function 70
	local slots = self._equipment.slots

	if not slots[self._selected_consumable_slot] then
		self._selected_consumable_slot = nil
	end

	if not self._selected_consumable_slot then
		for i = 1, #tbl do
			local var_70_1 = tbl[i]

			if not slots[var_70_1] then
				self._selected_consumable_slot = var_70_1

				break
			end
		end
	end

	if not self._selected_consumable_slot then
		local extension = ScriptUnit.extension(self._unit, "input_system")

		for k, v in pairs(InventorySettings.slots_by_wield_input) do
			if (v.loadout_slot or not extension:get(v.wield_input)) and not slots[v.name] then
				self._selected_consumable_slot = v.name

				break
			end
		end
	end
end

SimpleInventoryExtension.get_selected_consumable_slot_template = function (self)
	-- function 71
	local _selected_consumable_slot = self._selected_consumable_slot
	local var_71_1 = self._equipment.slots[_selected_consumable_slot]
	local var_71_2

	if not var_71_1 then
		local item_data = var_71_1.item_data

		var_71_2 = BackendUtils.get_item_template(item_data)
	end

	return var_71_2
end

SimpleInventoryExtension.get_selected_consumable_slot_name = function (self)
	-- function 72
	return self._selected_consumable_slot
end

SimpleInventoryExtension.resyncing_loadout = function (self)
	-- function 73
	local profile_synchronizer = Managers.state.network.profile_synchronizer
	local network_id = self.player:network_id()
	local local_player_id = self.player:local_player_id()

	return not profile_synchronizer:all_ingame_synced_for_peer(network_id, local_player_id)
end

SimpleInventoryExtension.get_item_slot_extension = function (self, arg_74_1, arg_74_2)
	-- function 74
	local get_slot_data = self:get_slot_data(arg_74_1)
	local right_unit_1p = get_slot_data.right_unit_1p
	local left_unit_1p = get_slot_data.left_unit_1p
	local has_extension = ScriptUnit.has_extension(right_unit_1p, arg_74_2)

	has_extension = not has_extension and ScriptUnit.extension(right_unit_1p, arg_74_2)

	local has_extension_2 = ScriptUnit.has_extension(left_unit_1p, arg_74_2)

	has_extension_2 = not has_extension_2 and ScriptUnit.extension(left_unit_1p, arg_74_2)

	local var_74_5 = has_extension

	if var_74_5 or not has_extension_2 then
		var_74_5 = has_extension_2
	end

	return var_74_5
end

SimpleInventoryExtension.get_num_grimoires = function (self)
	-- function 75
	local extension = ScriptUnit.extension(self._unit, "buff_system")
	local num_buff_perk = extension:num_buff_perk("skaven_grimoire")
	local num_buff_perk_2 = extension:num_buff_perk("twitch_grimoire")

	return num_buff_perk, num_buff_perk_2
end

local tbl_4 = {
	client = {},
	server = {},
	both = {}
}

SimpleInventoryExtension._get_property_and_trait_buffs = function (self, arg_76_1)
	-- function 76
	local _backend_items = self._backend_items

	table.clear(tbl_4.client)
	table.clear(tbl_4.server)
	table.clear(tbl_4.both)

	return GearUtils.get_property_and_trait_buffs(_backend_items, arg_76_1, tbl_4)
end

SimpleInventoryExtension._get_no_wield_required_property_and_trait_buffs = function (self, arg_77_1)
	-- function 77
	local _backend_items = self._backend_items

	table.clear(tbl_4.client)
	table.clear(tbl_4.server)
	table.clear(tbl_4.both)

	local flag = true

	return GearUtils.get_property_and_trait_buffs(_backend_items, arg_77_1, tbl_4, flag)
end

local function fn_3(arg_78_0, arg_78_1, arg_78_2)
	-- function 78
	local var_78_0

	if not arg_78_1 then
		var_78_0 = arg_78_1[arg_78_2]

		if not var_78_0 then
			-- Nothing
		end
	end

	var_78_0 = arg_78_0

	::label_78_0::

	return var_78_0
end

SimpleInventoryExtension._wield_slot = function (self, arg_79_1, arg_79_2, arg_79_3, arg_79_4, arg_79_5)
	-- function 79
	Unit.flow_event(arg_79_3, "lua_unwield")
	self.first_person_extension:animation_event("unwield")

	if not arg_79_1.right_hand_wielded_unit then
		Unit.flow_event(arg_79_1.right_hand_wielded_unit, "lua_unwield")
		Unit.set_unit_visibility(arg_79_1.right_hand_wielded_unit, false)

		if not ScriptUnit.has_extension(arg_79_1.right_hand_wielded_unit, "ammo_system") then
			local extension = ScriptUnit.extension(arg_79_1.right_hand_wielded_unit, "ammo_system")

			if not extension:is_reloading() then
				extension:abort_reload()
			end
		end
	end

	if not arg_79_1.right_hand_ammo_unit_1p then
		Unit.set_unit_visibility(arg_79_1.right_hand_ammo_unit_1p, false)
	end

	if not arg_79_1.left_hand_wielded_unit then
		Unit.flow_event(arg_79_1.left_hand_wielded_unit, "lua_unwield")
		Unit.set_unit_visibility(arg_79_1.left_hand_wielded_unit, false)

		if not ScriptUnit.has_extension(arg_79_1.left_hand_wielded_unit, "ammo_system") then
			local extension_2 = ScriptUnit.extension(arg_79_1.left_hand_wielded_unit, "ammo_system")

			if not extension_2:is_reloading() then
				extension_2:abort_reload()
			end
		end
	end

	if not arg_79_1.left_hand_ammo_unit_1p then
		Unit.flow_event(arg_79_1.left_hand_ammo_unit_1p, "lua_unwield")
		Unit.set_unit_visibility(arg_79_1.left_hand_ammo_unit_1p, false)
	end

	if not arg_79_1.right_hand_wielded_unit_3p then
		Unit.flow_event(arg_79_1.right_hand_wielded_unit_3p, "lua_unwield")
		Unit.set_unit_visibility(arg_79_1.right_hand_wielded_unit_3p, false)
	end

	if not arg_79_1.right_hand_ammo_unit_3p then
		Unit.flow_event(arg_79_1.right_hand_ammo_unit_3p, "lua_unwield")
		Unit.set_unit_visibility(arg_79_1.right_hand_ammo_unit_3p, false)
	end

	if not arg_79_1.left_hand_wielded_unit_3p then
		Unit.flow_event(arg_79_1.left_hand_wielded_unit_3p, "lua_unwield")
		Unit.set_unit_visibility(arg_79_1.left_hand_wielded_unit_3p, false)
	end

	if not arg_79_1.left_hand_ammo_unit_3p then
		Unit.flow_event(arg_79_1.left_hand_ammo_unit_3p, "lua_unwield")
		Unit.set_unit_visibility(arg_79_1.left_hand_ammo_unit_3p, false)
	end

	if not arg_79_2 then
		return
	end

	local item_data = arg_79_2.item_data

	arg_79_1.wielded = item_data
	arg_79_1.wielded_slot = arg_79_2.id
	arg_79_1.right_hand_wielded_unit_3p = arg_79_2.right_unit_3p
	arg_79_1.right_hand_ammo_unit_3p = arg_79_2.right_ammo_unit_3p
	arg_79_1.left_hand_wielded_unit_3p = arg_79_2.left_unit_3p
	arg_79_1.left_hand_ammo_unit_3p = arg_79_2.left_ammo_unit_3p

	local career_index = ScriptUnit.extension(arg_79_4, "career_system"):career_index()

	if not Unit.animation_has_variable(arg_79_4, "career_index") then
		local animation_find_variable = Unit.animation_find_variable(arg_79_4, "career_index")

		Unit.animation_set_variable(arg_79_4, animation_find_variable, career_index)
	end

	local get_item_template = BackendUtils.get_item_template(item_data)
	local var_79_6 = fn_3(get_item_template.wield_anim, get_item_template.wield_anim_career, self._career_name)

	if not script_data.disable_third_person_weapon_animation_events then
		local var_79_7 = fn_3(get_item_template.wield_anim_3p, get_item_template.wield_anim_career_3p, self._career_name)

		var_79_7 = var_79_7 or var_79_6

		Unit.animation_event(arg_79_4, var_79_7)
	end

	if arg_79_2.right_unit_1p or not arg_79_2.left_unit_1p then
		arg_79_1.right_hand_wielded_unit = arg_79_2.right_unit_1p
		arg_79_1.right_hand_ammo_unit_1p = arg_79_2.right_ammo_unit_1p
		arg_79_1.left_hand_wielded_unit = arg_79_2.left_unit_1p
		arg_79_1.left_hand_ammo_unit_1p = arg_79_2.left_ammo_unit_1p

		local var_79_8 = BLACKBOARDS[self._unit]

		if not var_79_8 then
			var_79_8.weapon_unit = self:get_weapon_unit()
		end

		if not arg_79_1.right_hand_wielded_unit then
			Unit.flow_event(arg_79_1.right_hand_wielded_unit, "lua_wield")
		end

		if not arg_79_1.right_hand_ammo_unit_1p then
			Unit.flow_event(arg_79_1.right_hand_ammo_unit_1p, "lua_wield")
		end

		if not arg_79_1.left_hand_wielded_unit then
			Unit.flow_event(arg_79_1.left_hand_wielded_unit, "lua_wield")
		end

		if not arg_79_1.left_hand_ammo_unit_1p then
			Unit.flow_event(arg_79_1.left_hand_ammo_unit_1p, "lua_wield")
		end

		local flag = true

		if not ScriptUnit.has_extension(arg_79_1.right_hand_wielded_unit, "ammo_system") then
			local extension_3 = ScriptUnit.extension(arg_79_1.right_hand_wielded_unit, "ammo_system")

			if not (not extension_3:can_reload() and extension_3:ammo_count() ~= 0) then
				var_79_6 = fn_3(get_item_template.wield_anim_not_loaded, get_item_template.wield_anim_not_loaded_career, self._career_name) or var_79_6

				local play_reload_anim_on_wield_reload = extension_3:play_reload_anim_on_wield_reload()
				local has_wield_reload_anim = extension_3:has_wield_reload_anim()
				local var_79_13

				if not has_wield_reload_anim then
					var_79_13 = var_79_6
					flag = not play_reload_anim_on_wield_reload
				end

				extension_3:start_reload(play_reload_anim_on_wield_reload, nil, var_79_13)
			else
				var_79_6 = extension_3:total_remaining_ammo() ~= 0 or not fn_3(get_item_template.wield_anim_no_ammo, get_item_template.wield_anim_no_ammo_career, self._career_name) or var_79_6
			end
		end

		if not ScriptUnit.has_extension(arg_79_1.left_hand_wielded_unit, "ammo_system") then
			local extension_4 = ScriptUnit.extension(arg_79_1.left_hand_wielded_unit, "ammo_system")

			if not (not extension_4:can_reload() and extension_4:ammo_count() ~= 0) then
				var_79_6 = fn_3(get_item_template.wield_anim_not_loaded, get_item_template.wield_anim_not_loaded_career, self._career_name) or var_79_6

				local play_reload_anim_on_wield_reload_2 = extension_4:play_reload_anim_on_wield_reload()
				local has_wield_reload_anim_2 = extension_4:has_wield_reload_anim()
				local var_79_17

				if not has_wield_reload_anim_2 then
					var_79_17 = var_79_6
					flag = not play_reload_anim_on_wield_reload_2
				end

				extension_4:start_reload(play_reload_anim_on_wield_reload_2, nil, var_79_17)
			else
				var_79_6 = extension_4:total_remaining_ammo() ~= 0 or not fn_3(get_item_template.wield_anim_no_ammo, get_item_template.wield_anim_no_ammo_career, self._career_name) or var_79_6
			end
		end

		local get_item_state_machine = WeaponUtils.get_item_state_machine(get_item_template, self._career_name)

		get_item_state_machine = get_item_state_machine or self._profile.default_state_machine

		if not get_item_state_machine then
			self.first_person_extension:set_state_machine(get_item_state_machine)
		end

		if not flag then
			if not Unit.animation_has_variable(arg_79_3, "animation_variation_id") then
				local var_79_19 = WeaponSkins.skins[arg_79_2.skin]
				local flag_2 = not var_79_19 and var_79_19.action_anim_overrides
				local animation_variation_id

				if not flag_2 then
					animation_variation_id = flag_2.animation_variation_id

					if not animation_variation_id then
						-- Nothing
					end
				end

				animation_variation_id = 0

				::label_79_0::

				self.first_person_extension:animation_set_variable("animation_variation_id", animation_variation_id, true)
			end

			self.first_person_extension:animation_event(var_79_6)
		end

		if not arg_79_2.right_unit_1p then
			if not Unit.has_visibility_group(arg_79_2.right_unit_1p, "normal") then
				Unit.set_visibility(arg_79_2.right_unit_1p, "normal", true)
			else
				Unit.set_unit_visibility(arg_79_2.right_unit_1p, true)
			end

			if not arg_79_2.right_ammo_unit_1p then
				Unit.set_unit_visibility(arg_79_2.right_ammo_unit_1p, true)
			end
		end

		if not arg_79_2.left_unit_1p then
			if not Unit.has_visibility_group(arg_79_2.left_unit_1p, "normal") then
				Unit.set_visibility(arg_79_2.left_unit_1p, "normal", true)
			else
				Unit.set_unit_visibility(arg_79_2.left_unit_1p, true)
			end

			if not arg_79_2.left_ammo_unit_1p then
				Unit.set_unit_visibility(arg_79_2.left_ammo_unit_1p, true)
			end
		end
	else
		if not arg_79_1.right_hand_wielded_unit_3p then
			Unit.flow_event(arg_79_1.right_hand_wielded_unit_3p, "lua_wield")
			Unit.set_unit_visibility(arg_79_1.right_hand_wielded_unit_3p, true)

			if not arg_79_2.right_ammo_unit_3p then
				Unit.set_unit_visibility(arg_79_2.right_ammo_unit_3p, true)
			end
		end

		if not arg_79_1.left_hand_wielded_unit_3p then
			Unit.flow_event(arg_79_1.left_hand_wielded_unit_3p, "lua_wield")
			Unit.set_unit_visibility(arg_79_1.left_hand_wielded_unit_3p, true)

			if not arg_79_2.left_ammo_unit_3p then
				Unit.set_unit_visibility(arg_79_2.left_ammo_unit_3p, true)
			end
		end
	end

	Unit.flow_event(arg_79_3, "lua_wield")
	Managers.state.event:trigger("on_weapon_wield", arg_79_1)

	return true
end

SimpleInventoryExtension.get_equipped_item_names = function (self)
	-- function 80
	local tbl = {}

	for k, v in pairs(self._equipment.slots) do
		tbl[#tbl + 1] = v.item_data.name
	end

	return tbl
end

SimpleInventoryExtension.testify_wield_weapon = function (self, arg_81_1)
	-- function 81
	local backend_id = arg_81_1.backend_id
	local career_name = ScriptUnit.extension(self._unit, "career_system"):career_name()
	local str = "slot_" .. arg_81_1.data.slot_type

	BackendUtils.set_loadout_item(backend_id, career_name, str)
	self:create_equipment_in_slot(str, backend_id)
end

SimpleInventoryExtension.start_weapon_fx = function (self, arg_82_1, arg_82_2)
	-- function 82
	local _equipment = self._equipment
	local wielded_slot = _equipment.wielded_slot
	local var_82_2 = _equipment.slots[wielded_slot]
	local get_item_template = self:get_item_template(var_82_2)
	local particle_fx = get_item_template.particle_fx
	local flag = not particle_fx and particle_fx[arg_82_1]

	if not flag then
		self._weapon_fx[arg_82_1] = GearUtils.create_attached_particles(self._world, flag, _equipment, self._unit, self._first_person_unit, not self.is_bot)

		if not arg_82_2 then
			local item_data = var_82_2.item_data
			local go_id = Managers.state.unit_storage:go_id(self._unit)
			local var_82_8 = NetworkLookup.item_names[item_data.name]
			local var_82_9 = get_item_template.particle_fx_lookup[arg_82_1]

			if not go_id and not var_82_8 and not var_82_9 then
				local network = Managers.state.network

				if not self.is_server then
					network.network_transmit:send_rpc_clients("rpc_start_weapon_fx", go_id, var_82_8, var_82_9)
				else
					network.network_transmit:send_rpc_server("rpc_start_weapon_fx", go_id, var_82_8, var_82_9)
				end
			end
		end
	end
end

SimpleInventoryExtension.stop_weapon_fx = function (self, arg_83_1, arg_83_2)
	-- function 83
	local var_83_0 = self._weapon_fx[arg_83_1]

	if not var_83_0 then
		self._weapon_fx[arg_83_1] = GearUtils.destroy_attached_particles(self._world, var_83_0)

		if not arg_83_2 then
			local _equipment = self._equipment
			local wielded_slot = _equipment.wielded_slot
			local var_83_3 = _equipment.slots[wielded_slot]
			local get_item_template = self:get_item_template(var_83_3)
			local flag = not get_item_template and get_item_template.particle_fx

			if not (not flag and flag[arg_83_1]) then
				local item_data = var_83_3.item_data
				local go_id = Managers.state.unit_storage:go_id(self._unit)
				local var_83_8 = NetworkLookup.item_names[item_data.name]
				local var_83_9 = get_item_template.particle_fx_lookup[arg_83_1]

				if not go_id and not var_83_8 and not var_83_9 then
					local network = Managers.state.network

					if not self.is_server then
						network.network_transmit:send_rpc_clients("rpc_stop_weapon_fx", go_id, var_83_8, var_83_9)
					else
						network.network_transmit:send_rpc_server("rpc_stop_weapon_fx", go_id, var_83_8, var_83_9)
					end
				end
			end
		end
	end
end

SimpleInventoryExtension._stop_all_weapon_fx = function (self)
	-- function 84
	local _world = self._world
	local _weapon_fx = self._weapon_fx

	for k, v in pairs(_weapon_fx) do
		GearUtils.destroy_attached_particles(_world, v)

		_weapon_fx[k] = nil
	end
end

SimpleInventoryExtension.has_additional_item_slots = function (self, arg_85_1)
	-- function 85
	return self._additional_items[arg_85_1] ~= nil
end

SimpleInventoryExtension.can_store_additional_item = function (self, arg_86_1)
	-- function 86
	local var_86_0 = self._additional_items[arg_86_1]

	return not var_86_0 and #var_86_0.items < var_86_0.max_slots
end

SimpleInventoryExtension.has_additional_items = function (self, arg_87_1)
	-- function 87
	local var_87_0 = self._additional_items[arg_87_1]

	return not var_87_0 and #var_87_0.items > 0
end

SimpleInventoryExtension.get_additional_items = function (self, arg_88_1)
	-- function 88
	local var_88_0 = self._additional_items[arg_88_1]

	return not var_88_0 and var_88_0.items
end

SimpleInventoryExtension.get_additional_items_table = function (self)
	-- function 89
	return self._additional_items
end

SimpleInventoryExtension.get_total_item_count = function (self, arg_90_1)
	-- function 90
	local num = 0

	if not self:get_item_data(arg_90_1) then
		num = 1
	end

	local get_additional_items = self:get_additional_items(arg_90_1)

	if not get_additional_items then
		num = num + #get_additional_items
	end

	return num
end

SimpleInventoryExtension.store_additional_item = function (self, arg_91_1, arg_91_2, arg_91_3)
	-- function 91
	if not arg_91_2 and not self:can_store_additional_item(arg_91_1) then
		local get_additional_items = self:get_additional_items(arg_91_1)

		get_additional_items[#get_additional_items + 1] = arg_91_2

		if not arg_91_3 then
			self:_resync_stored_items(arg_91_1)
		end

		return true
	end

	return false
end

SimpleInventoryExtension.remove_additional_item = function (self, arg_92_1, arg_92_2, arg_92_3)
	-- function 92
	local get_additional_items = self:get_additional_items(arg_92_1)
	local get_additional_item_swap_id = self:get_additional_item_swap_id(get_additional_items, SwapFromStorageType.Same, arg_92_2)

	table.remove(get_additional_items, get_additional_item_swap_id)

	if not arg_92_3 then
		self:_resync_stored_items(arg_92_1)
	end
end

SimpleInventoryExtension.has_droppable_item = function (self, arg_93_1, arg_93_2)
	-- function 93
	local flag = false
	local flag_2 = false
	local get_item_data = self:get_item_data(arg_93_1)

	if (not get_item_data and get_item_data.is_not_droppable or not arg_93_2) and not arg_93_2(get_item_data) then
		flag = true
		flag_2 = false

		return flag, flag_2, get_item_data
	end

	local get_additional_items = self:get_additional_items(arg_93_1)

	if not get_additional_items then
		for i = 1, #get_additional_items do
			local var_93_4 = get_additional_items[i]

			if (var_93_4.is_not_droppable or not arg_93_2) and not arg_93_2(var_93_4) then
				flag = true
				flag_2 = true

				return flag, flag_2, var_93_4
			end
		end
	end

	return flag, flag_2, nil
end

SimpleInventoryExtension.get_additional_item_swap_id = function (arg_94_0, arg_94_1, arg_94_2, arg_94_3)
	-- function 94
	local var_94_0

	if not arg_94_1 then
		if arg_94_2 == SwapFromStorageType.First then
			var_94_0 = 1
		elseif arg_94_2 == SwapFromStorageType.Unique then
			for i = 1, #arg_94_1 do
				if arg_94_1[i] ~= arg_94_3 then
					var_94_0 = i

					break
				end
			end
		elseif not (arg_94_2 == SwapFromStorageType.Same or arg_94_2 ~= SwapFromStorageType.SameOrAny) then
			if arg_94_2 == SwapFromStorageType.SameOrAny then
				var_94_0 = 1
			end

			for j = 1, #arg_94_1 do
				if arg_94_1[j] == arg_94_3 then
					var_94_0 = j

					break
				end
			end
		elseif arg_94_2 == SwapFromStorageType.UnwieldPrio then
			local unwield_prio

			if not arg_94_3 then
				unwield_prio = arg_94_3.unwield_prio

				if not unwield_prio then
					unwield_prio = 0
				end
			else
				unwield_prio = -1
			end

			local var_94_2

			for k = 1, #arg_94_1 do
				local unwield_prio_2 = arg_94_1[k].unwield_prio

				unwield_prio_2 = unwield_prio_2 or 0

				if unwield_prio < unwield_prio_2 then
					unwield_prio = unwield_prio_2
					var_94_2 = k
				end
			end

			return var_94_2
		elseif arg_94_2 == SwapFromStorageType.LowestUnwieldPrio then
			local unwield_prio_3

			if not arg_94_3 then
				unwield_prio_3 = arg_94_3.unwield_prio

				if not unwield_prio_3 then
					unwield_prio_3 = 0
				end
			else
				unwield_prio_3 = math.huge
			end

			local var_94_5

			for l = 1, #arg_94_1 do
				local unwield_prio_4 = arg_94_1[l].unwield_prio

				unwield_prio_4 = unwield_prio_4 or 0

				if unwield_prio_4 < unwield_prio_3 then
					unwield_prio_3 = unwield_prio_4
					var_94_5 = l
				end
			end

			return var_94_5
		end
	end

	return var_94_0
end

SimpleInventoryExtension.can_swap_from_storage = function (self, arg_95_1, arg_95_2, arg_95_3)
	-- function 95
	if not self:has_additional_items(arg_95_1) then
		arg_95_2 = arg_95_2 or SwapFromStorageType.First
		arg_95_3 = arg_95_3 or self:get_item_data(arg_95_1)

		local get_additional_items = self:get_additional_items(arg_95_1)
		local get_additional_item_swap_id = self:get_additional_item_swap_id(get_additional_items, arg_95_2, arg_95_3)

		return get_additional_items[get_additional_item_swap_id] ~= nil, get_additional_item_swap_id, get_additional_items
	end

	return false
end

SimpleInventoryExtension.swap_equipment_from_storage = function (self, arg_96_1, arg_96_2, arg_96_3)
	-- function 96
	local can_swap_from_storage, var_96_1, var_96_2 = self:can_swap_from_storage(arg_96_1, arg_96_2, arg_96_3)

	if not can_swap_from_storage then
		local var_96_3 = var_96_2[var_96_1]

		table.remove(var_96_2, var_96_1)

		local get_slot_data = self:get_slot_data(arg_96_1)

		if not get_slot_data then
			self:store_additional_item(arg_96_1, get_slot_data.item_data, true)
			self:destroy_slot(arg_96_1)
		end

		self:_resync_stored_items(arg_96_1)

		local tbl = {
			slot_id = arg_96_1,
			item_data = var_96_3
		}

		self:_spawn_resynced_loadout(tbl, true)

		return true
	end

	return false
end

local tbl_5 = {}

SimpleInventoryExtension._resync_stored_items = function (self, arg_97_1)
	-- function 97
	local get_additional_items = self:get_additional_items(arg_97_1)

	if not get_additional_items then
		local go_id = Managers.state.unit_storage:go_id(self._unit)

		if not go_id then
			local network = Managers.state.network
			local var_97_3 = NetworkLookup.equipment_slots[arg_97_1]

			table.clear(tbl_5)

			for i = 1, #get_additional_items do
				local var_97_4 = get_additional_items[i]

				tbl_5[#tbl_5 + 1] = NetworkLookup.item_names[var_97_4.name]
			end

			if not self.is_server then
				network.network_transmit:send_rpc_clients("rpc_update_additional_slot", go_id, var_97_3, tbl_5)
			else
				network.network_transmit:send_rpc_server("rpc_update_additional_slot", go_id, var_97_3, tbl_5)
			end
		end
	end
end
