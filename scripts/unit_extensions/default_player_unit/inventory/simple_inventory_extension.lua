-- chunkname: @scripts/unit_extensions/default_player_unit/inventory/simple_inventory_extension.lua

require("scripts/utils/strict_table")
require("scripts/unit_extensions/default_player_unit/inventory/gear_utils")
require("scripts/managers/backend/backend_utils")

SimpleInventoryExtension = class(SimpleInventoryExtension)
SwapFromStorageType = SwapFromStorageType or CreateStrictEnumTable("First", "Unique", "Same", "SameOrAny", "UnwieldPrio", "LowestUnwieldPrio")

local var_0_0 = {
	"slot_potion",
	"slot_grenade",
	"slot_healthkit"
}

SimpleInventoryExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._world = arg_1_1.world
	arg_1_0._unit = arg_1_2
	arg_1_0._profile = arg_1_3.profile
	arg_1_0._profile_index = FindProfileIndex(arg_1_0._profile.display_name)
	arg_1_0._additional_items = {}
	arg_1_0._attached_units = {}
	arg_1_0._equipment = {
		slots = {},
		item_data = {}
	}

	local var_1_0 = arg_1_3.player

	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.is_bot = var_1_0.bot_player or false
	arg_1_0.player = var_1_0

	local var_1_1 = var_1_0:career_name()
	local var_1_2 = var_1_1 and CareerSettings[var_1_1]
	local var_1_3 = var_1_2 and var_1_2.additional_item_slots

	if var_1_3 then
		for iter_1_0, iter_1_1 in pairs(var_1_3) do
			arg_1_0._additional_items[iter_1_0] = {
				max_slots = iter_1_1,
				items = {}
			}
		end
	end

	arg_1_0._career_name = var_1_1
	arg_1_0.initial_inventory = arg_1_3.initial_inventory
	arg_1_0.initial_ammo_percent = arg_1_3.ammo_percent
	arg_1_0._show_first_person = true
	arg_1_0._show_third_person = false
	arg_1_0._show_first_person_lights = true
	arg_1_0.current_item_buffs = {
		wield = {},
		equip = {
			slot_melee = {},
			slot_ranged = {}
		}
	}
	arg_1_0._blocked_wield_slots = {}
	arg_1_0._weapon_fx = {}
	arg_1_0._items_to_spawn = {}
	arg_1_0.recently_acquired_list = {}
	arg_1_0._loaded_projectile_settings = {}
	arg_1_0._selected_consumable_slot = nil
	arg_1_0._previously_wielded_weapon_slot = "slot_melee"
	arg_1_0._previously_wielded_slot = "slot_melee"
	arg_1_0._previously_wielded_non_level_slot = "slot_melee"
	arg_1_0._backend_items = Managers.backend:get_interface("items")
end

SimpleInventoryExtension.get_weapon_unit = function (arg_2_0)
	local var_2_0 = arg_2_0._equipment

	return var_2_0.left_hand_wielded_unit or var_2_0.right_hand_wielded_unit
end

SimpleInventoryExtension.get_weapon_unit_3p = function (arg_3_0)
	local var_3_0 = arg_3_0._equipment

	return var_3_0.left_hand_wielded_unit_3p or var_3_0.right_hand_wielded_unit_3p
end

SimpleInventoryExtension.get_all_weapon_unit = function (arg_4_0)
	local var_4_0 = arg_4_0._equipment

	return var_4_0.left_hand_wielded_unit, var_4_0.right_hand_wielded_unit
end

SimpleInventoryExtension.extensions_ready = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = ScriptUnit.extension(arg_5_2, "first_person_system")

	arg_5_0.first_person_extension = var_5_0
	arg_5_0._first_person_unit = var_5_0:get_first_person_unit()
	arg_5_0.buff_extension = ScriptUnit.extension(arg_5_2, "buff_system")

	local var_5_1 = ScriptUnit.extension(arg_5_2, "career_system")

	arg_5_0.career_extension = var_5_1

	local var_5_2 = ScriptUnit.has_extension(arg_5_2, "talent_system")

	arg_5_0.talent_extension = var_5_2

	local var_5_3 = arg_5_0._equipment
	local var_5_4 = arg_5_0._profile
	local var_5_5 = arg_5_0._first_person_unit
	local var_5_6 = arg_5_0._unit

	arg_5_0:add_equipment_by_category("weapon_slots")
	arg_5_0:add_equipment_by_category("enemy_weapon_slots")

	local var_5_7 = var_5_2 and var_5_2:get_talent_career_skill_index() or 1
	local var_5_8 = var_5_2 and var_5_2:get_talent_career_weapon_index()

	arg_5_0.initial_inventory.slot_career_skill_weapon = var_5_1:career_skill_weapon_name(var_5_7, var_5_8)

	arg_5_0:add_equipment_by_category("career_skill_weapon_slots")

	local var_5_9 = arg_5_0.initial_inventory.additional_items

	if var_5_9 then
		for iter_5_0, iter_5_1 in pairs(var_5_9) do
			for iter_5_2 = 1, #iter_5_1.items do
				local var_5_10 = iter_5_1.items[iter_5_2]

				if arg_5_0:get_slot_data(iter_5_0) then
					local var_5_11 = true

					arg_5_0:store_additional_item(iter_5_0, var_5_10, var_5_11)
				else
					arg_5_0:add_equipment(iter_5_0, var_5_10)
				end
			end
		end
	end

	local var_5_12 = var_5_1:career_settings()

	if var_5_12.additional_inventory then
		for iter_5_3, iter_5_4 in pairs(var_5_12.additional_inventory) do
			for iter_5_5 = 1, #iter_5_4 do
				local var_5_13 = ItemMasterList[iter_5_4[iter_5_5]]

				if arg_5_0:get_slot_data(iter_5_3) then
					local var_5_14 = true

					arg_5_0:store_additional_item(iter_5_3, var_5_13, var_5_14)
				else
					arg_5_0:add_equipment(iter_5_3, var_5_13)
				end
			end
		end
	end

	Unit.set_data(arg_5_0._first_person_unit, "equipment", arg_5_0._equipment)

	if var_5_4.default_wielded_slot then
		local var_5_15 = var_5_4.default_wielded_slot
		local var_5_16 = arg_5_0._equipment.slots[var_5_15]

		if not var_5_16 then
			table.dump(arg_5_0._equipment.slots, "self._equipment.slots", 1)

			local var_5_17 = var_5_1:career_name()
			local var_5_18 = Managers.backend:get_interface("items"):get_loadout_by_career_name(var_5_17, arg_5_0.is_bot)

			table.dump(var_5_18, "career_loadout", 1)
			ferror("Tried to wield default slot %s for %s that contained no weapon.", var_5_15, var_5_17)
		end

		arg_5_0:_wield_slot(var_5_3, var_5_16, var_5_5, var_5_6)

		local var_5_19 = var_5_16.item_data
		local var_5_20 = BackendUtils.get_item_template(var_5_19)

		arg_5_0:_spawn_attached_units(var_5_20.first_person_attached_units)

		local var_5_21 = var_5_19.backend_id
		local var_5_22 = arg_5_0:_get_property_and_trait_buffs(var_5_21)

		if var_5_20.server_buffs then
			for iter_5_6, iter_5_7 in pairs(var_5_20.server_buffs) do
				var_5_22.server[iter_5_6] = iter_5_7
			end
		end

		arg_5_0:apply_buffs(var_5_22, "wield", var_5_19.name, var_5_15)

		local var_5_23 = arg_5_0._equipment
		local var_5_24 = ScriptUnit.has_extension(var_5_23.left_hand_wielded_unit, "weapon_system")

		if var_5_24 then
			var_5_24:on_wield("left")
		end

		local var_5_25 = ScriptUnit.has_extension(var_5_23.right_hand_wielded_unit, "weapon_system")

		if var_5_25 then
			var_5_25:on_wield("right")
		end
	end

	arg_5_0._equipment.wielded_slot = var_5_4.default_wielded_slot
end

SimpleInventoryExtension._update_career_skill_weapon_slot = function (arg_6_0)
	if not arg_6_0._first_person_unit then
		arg_6_0._first_person_unit = ScriptUnit.extension(unit, "first_person_system"):get_first_person_unit()
	end

	local var_6_0 = arg_6_0.career_extension
	local var_6_1 = arg_6_0.talent_extension
	local var_6_2 = var_6_1 and var_6_1:get_talent_career_skill_index() or 1
	local var_6_3 = var_6_1 and var_6_1:get_talent_career_weapon_index()
	local var_6_4 = var_6_0:career_skill_weapon_name(var_6_2, var_6_3)

	if var_6_4 then
		if var_6_0:should_reload_career_weapon() then
			local var_6_5 = rawget(ItemMasterList, var_6_4)

			if arg_6_0._equipment.wielded_slot == "slot_career_skill_weapon" then
				arg_6_0:wield_previous_weapon()
			end

			arg_6_0:destroy_slot("slot_career_skill_weapon", true)
			arg_6_0:_queue_item_spawn("slot_career_skill_weapon", var_6_5)
		else
			arg_6_0.initial_inventory.slot_career_skill_weapon = var_6_4

			arg_6_0:add_equipment_by_category("career_skill_weapon_slots")
			Unit.set_data(arg_6_0._first_person_unit, "equipment", arg_6_0._equipment)
		end
	end
end

SimpleInventoryExtension.update_career_skill_weapon_slot_safe = function (arg_7_0)
	arg_7_0._queue_update_career_skill_weapon_slot = true
end

SimpleInventoryExtension.game_object_initialized = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = Managers.state.network
	local var_8_1 = arg_8_0.is_server
	local var_8_2 = arg_8_0._equipment
	local var_8_3 = var_8_2.slots

	for iter_8_0, iter_8_1 in pairs(var_8_3) do
		local var_8_4 = iter_8_1.item_data
		local var_8_5 = NetworkLookup.equipment_slots[iter_8_0]
		local var_8_6 = NetworkLookup.item_names[var_8_4.name]
		local var_8_7 = NetworkLookup.weapon_skins[iter_8_1.skin or "n/a"]

		if var_8_1 then
			var_8_0.network_transmit:send_rpc_clients("rpc_add_equipment", arg_8_2, var_8_5, var_8_6, var_8_7)
		else
			var_8_0.network_transmit:send_rpc_server("rpc_add_equipment", arg_8_2, var_8_5, var_8_6, var_8_7)

			if iter_8_0 == "slot_ranged" or iter_8_0 == "slot_melee" then
				local var_8_8 = var_8_4.backend_id

				arg_8_0:_send_rpc_add_equipment_buffs(arg_8_2, var_8_5, var_8_8)
			end
		end

		arg_8_0:swap_equipment_from_storage(iter_8_0, SwapFromStorageType.UnwieldPrio, iter_8_1.item_data)
	end

	local var_8_9 = var_8_2.wielded_slot
	local var_8_10 = NetworkLookup.equipment_slots[var_8_9]

	if var_8_1 then
		var_8_0.network_transmit:send_rpc_clients("rpc_wield_equipment", arg_8_2, var_8_10)
	else
		var_8_0.network_transmit:send_rpc_server("rpc_wield_equipment", arg_8_2, var_8_10)
	end

	BLACKBOARDS[arg_8_1].weapon_unit = arg_8_0:get_weapon_unit()

	for iter_8_2, iter_8_3 in pairs(arg_8_0._additional_items) do
		arg_8_0:_resync_stored_items(iter_8_2)
	end
end

SimpleInventoryExtension._send_rpc_add_equipment_buffs = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local function var_9_0(arg_10_0, arg_10_1)
		local var_10_0 = {}
		local var_10_1 = table.merge(var_10_0, arg_10_1.server)
		local var_10_2 = table.merge(var_10_1, arg_10_1.both)
		local var_10_3 = BuffUtils.buffs_to_rpc_params(var_10_2)
		local var_10_4, var_10_5, var_10_6, var_10_7 = unpack(var_10_3)

		if #var_10_5 ~= #var_10_6 or #var_10_6 ~= #var_10_7 then
			fassert(false, "[SimpleInventoryExtension] Length of arrays buff_names(%d) and buff_value_types(%d) and buff_values(%d) are not equal!", #var_10_5, #var_10_6, #var_10_7)
		end

		if var_10_4 > 0 then
			Managers.state.network.network_transmit:send_rpc_server(arg_10_0, arg_9_1, arg_9_2, var_10_4, var_10_5, var_10_6, var_10_7)
		end
	end

	local var_9_1 = arg_9_0:_get_property_and_trait_buffs(arg_9_3)
	local var_9_2 = BackendUtils.get_item_from_masterlist(arg_9_3)
	local var_9_3 = BackendUtils.get_item_template(var_9_2)

	if var_9_3.server_buffs then
		for iter_9_0, iter_9_1 in pairs(var_9_3.server_buffs) do
			var_9_1.server[iter_9_0] = iter_9_1
		end
	end

	var_9_0("rpc_add_equipment_buffs", var_9_1)

	local var_9_4 = arg_9_0:_get_no_wield_required_property_and_trait_buffs(arg_9_3)

	var_9_0("rpc_add_no_wield_required_equipment_buffs", var_9_4)
end

SimpleInventoryExtension._override_career_skill_item_template = function (arg_11_0, arg_11_1)
	local var_11_0
	local var_11_1
	local var_11_2 = arg_11_1.slot_to_use

	if var_11_2 then
		local var_11_3 = arg_11_0._equipment.slots[var_11_2]
		local var_11_4
		local var_11_5

		if WeaponUtils.is_valid_weapon_override(var_11_3, arg_11_1) then
			var_11_4 = arg_11_0:get_item_template(var_11_3)
			var_11_5 = var_11_3.item_data
		else
			local var_11_6 = arg_11_1.default_item_to_replace

			var_11_5 = ItemMasterList[var_11_6]
			var_11_4 = WeaponUtils.get_weapon_template(var_11_5.template)
		end

		local var_11_7 = BackendUtils.get_item_template(arg_11_1)

		var_11_7.left_hand_attachment_node_linking = var_11_4.left_hand_attachment_node_linking
		var_11_7.right_hand_attachment_node_linking = var_11_4.right_hand_attachment_node_linking
		var_11_7.wield_anim = var_11_4.wield_anim
		var_11_7.wield_anim_no_ammo = var_11_4.wield_anim_no_ammo
		var_11_7.wield_anim_career = var_11_4.wield_anim_career
		var_11_7.wield_anim_no_ammo_career = var_11_4.wield_anim_no_ammo_career
		var_11_1 = BackendUtils.get_item_units(arg_11_1)

		local var_11_8 = BackendUtils.get_item_units(var_11_5)

		for iter_11_0, iter_11_1 in pairs(arg_11_1.item_units_to_replace) do
			var_11_1[iter_11_0] = var_11_8[iter_11_0]
		end

		var_11_0 = var_11_7
	end

	return var_11_0, var_11_1
end

SimpleInventoryExtension.add_equipment_by_category = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0.career_extension:career_name()
	local var_12_1 = InventorySettings[arg_12_1]
	local var_12_2 = #var_12_1

	for iter_12_0 = 1, var_12_2 do
		repeat
			local var_12_3 = var_12_1[iter_12_0]
			local var_12_4 = var_12_3.name
			local var_12_5 = BackendUtils.get_loadout_item(var_12_0, var_12_4, arg_12_0.is_bot)
			local var_12_6
			local var_12_7 = arg_12_0.initial_inventory[var_12_4]
			local var_12_8

			if var_12_5 then
				var_12_6 = table.clone(var_12_5.data)
				var_12_6.backend_id = var_12_5.backend_id
			else
				var_12_6 = rawget(ItemMasterList, var_12_7)

				if not var_12_6 then
					if var_12_3.stored_in_backend then
						local var_12_9 = BackendUtils.get_loadout_item_id(var_12_0, var_12_4, arg_12_0.is_bot)
						local var_12_10 = var_12_9 and tostring(var_12_9) or "No backend ID"
						local var_12_11 = Managers.backend:get_interface("items")
						local var_12_12 = "No item"

						if var_12_9 then
							local var_12_13 = var_12_11:get_item_from_id(var_12_9)

							var_12_12 = var_12_13 and var_12_13.name or "Item exists"
						end

						local var_12_14 = Managers.backend._current_loadout_interface_override or "No override"
						local var_12_15 = var_12_11:get_loadout_by_career_name(var_12_0, arg_12_0.is_bot)

						printf("self.initial_inventory: \n%s", table.tostring(arg_12_0.initial_inventory))
						printf("Tried add_equipment_by_category for category <%s> for career <%s> at slot <%s>.\n BackendUtils.get_loadout_item didnt return a item.\n backend_id_string: %s\n item_string: %s\n loadout_interface_override_string: %s\n", arg_12_1, var_12_0, var_12_4, var_12_10, var_12_12, var_12_14)
						table.dump(var_12_15, "career_loadout", 1)
					end

					break
				end
			end

			if var_12_6.slot_to_use then
				local var_12_16 = arg_12_0._equipment.slots[var_12_6.slot_to_use]

				if not var_12_16 then
					break
				end

				local var_12_17

				if WeaponUtils.is_valid_weapon_override(var_12_16, var_12_6) then
					var_12_17 = var_12_16.item_data
				else
					local var_12_18 = var_12_6.default_item_to_replace

					var_12_17 = ItemMasterList[var_12_18]
				end

				var_12_6.left_hand_unit = var_12_17.left_hand_unit
				var_12_6.right_hand_unit = var_12_17.right_hand_unit
			end

			arg_12_0:add_equipment(var_12_4, var_12_6, nil, nil, arg_12_0.initial_ammo_percent[var_12_4])
		until true
	end
end

SimpleInventoryExtension.destroy = function (arg_13_0)
	local var_13_0 = Managers.state.entity:system("pickup_system")
	local var_13_1 = Managers.state.entity:system("projectile_system")
	local var_13_2 = arg_13_0.player:network_id()

	for iter_13_0, iter_13_1 in pairs(arg_13_0._equipment.slots) do
		if var_13_0 then
			local var_13_3 = iter_13_1.link_pickup_template_name

			if var_13_3 then
				var_13_0:delete_limited_owned_pickup_type(var_13_2, var_13_3)
			end
		end

		if iter_13_1.destroy_indexed_projectiles and var_13_1 then
			var_13_1:delete_indexed_projectiles(arg_13_0._unit)
		end

		GearUtils.destroy_slot(arg_13_0._world, arg_13_0._unit, iter_13_1, arg_13_0._equipment, true)
	end

	arg_13_0:_despawn_attached_units()
	arg_13_0:_stop_all_weapon_fx()
end

SimpleInventoryExtension._unlink_unit = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	World.unlink_unit(arg_14_0._world, arg_14_1)

	local var_14_0 = arg_14_3.wielded or arg_14_3

	for iter_14_0, iter_14_1 in ipairs(var_14_0) do
		local var_14_1 = iter_14_1.target

		if var_14_1 ~= 0 then
			local var_14_2 = type(var_14_1) == "string" and Unit.node(arg_14_1, var_14_1) or var_14_1
			local var_14_3 = Unit.scene_graph_parent(arg_14_1, var_14_2)

			Unit.scene_graph_link(arg_14_1, var_14_2, 0)
		end
	end

	Unit.set_flow_variable(arg_14_1, "lua_drop_reason", arg_14_2)
	Unit.set_shader_pass_flag_for_meshes_in_unit_and_childs(arg_14_1, "outline_unit", false)
	Unit.flow_event(arg_14_1, "lua_dropped")

	local var_14_4 = Unit.create_actor(arg_14_1, "rp_dropped")

	Actor.add_angular_velocity(var_14_4, Vector3(math.random(), math.random(), math.random()) * 5)
	Actor.add_velocity(var_14_4, Vector3(2 * math.random() - 0.5, 2 * math.random() - 0.5, 4.5))
end

SimpleInventoryExtension.drop_equipped_weapons = function (arg_15_0, arg_15_1, arg_15_2)
	return
end

SimpleInventoryExtension.equipment = function (arg_16_0)
	return arg_16_0._equipment
end

SimpleInventoryExtension.update = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	if arg_17_0._queue_update_career_skill_weapon_slot then
		arg_17_0:_update_career_skill_weapon_slot()

		arg_17_0._queue_update_career_skill_weapon_slot = false
	end

	arg_17_0:_update_selected_consumable_slot()
	arg_17_0:_update_loaded_projectile_settings()
	arg_17_0:_update_resync_loadout()

	local var_17_0, var_17_1 = arg_17_0:current_ammo_status("slot_ranged")
	local var_17_2 = 1
	local var_17_3 = Managers.state.network:game()
	local var_17_4 = Managers.state.unit_storage:go_id(arg_17_1)

	if var_17_0 and var_17_1 then
		var_17_2 = var_17_0 / var_17_1

		GameSession.set_game_object_field(var_17_3, var_17_4, "current_ammo", var_17_0)
		GameSession.set_game_object_field(var_17_3, var_17_4, "max_ammo", var_17_1)
	end

	local var_17_5 = math.min(1, var_17_2)

	GameSession.set_game_object_field(var_17_3, var_17_4, "ammo_percentage", var_17_5)
end

SimpleInventoryExtension.recently_acquired = function (arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0.recently_acquired_list[arg_18_1]

	arg_18_0.recently_acquired_list[arg_18_1] = nil

	return var_18_0
end

SimpleInventoryExtension._update_resync_loadout = function (arg_19_0)
	local var_19_0, var_19_1 = next(arg_19_0._items_to_spawn)

	if not var_19_1 then
		return
	end

	local var_19_2 = Managers.state.network.profile_synchronizer
	local var_19_3 = arg_19_0.player:network_id()
	local var_19_4 = arg_19_0.player:local_player_id()

	if arg_19_0.resync_loadout_needed then
		local var_19_5 = true

		var_19_2:resync_loadout(var_19_3, var_19_4, arg_19_0.is_bot, var_19_5)

		arg_19_0.resync_loadout_needed = false
	end

	if var_19_2:all_ingame_synced_for_peer(var_19_3, var_19_4) then
		arg_19_0:_spawn_resynced_loadout(var_19_1)

		arg_19_0._items_to_spawn[var_19_0] = nil
	end
end

SimpleInventoryExtension.can_wield = function (arg_20_0)
	local var_20_0 = arg_20_0._equipment
	local var_20_1 = arg_20_0._equipment.wielded_slot
	local var_20_2 = var_20_0.slots[var_20_1].item_data
	local var_20_3 = BackendUtils.get_item_template(var_20_2)
	local var_20_4 = true

	if var_20_3.block_wielding then
		var_20_4 = false
	end

	return var_20_4
end

SimpleInventoryExtension.wield_previous_slot = function (arg_21_0)
	local var_21_0 = arg_21_0._previously_wielded_slot

	if not arg_21_0:wield(var_21_0) then
		return arg_21_0:wield_previous_non_level_slot()
	end

	return true
end

SimpleInventoryExtension.wield_previous_non_level_slot = function (arg_22_0)
	local var_22_0 = arg_22_0._previously_wielded_non_level_slot

	if not arg_22_0:wield(var_22_0) then
		return arg_22_0:wield_previous_weapon()
	end

	return true
end

SimpleInventoryExtension.wield_previous_weapon = function (arg_23_0)
	local var_23_0 = arg_23_0._previously_wielded_weapon_slot

	if not arg_23_0:wield(var_23_0) then
		return arg_23_0:rewield_wielded_slot()
	end

	return true
end

SimpleInventoryExtension.rewield_wielded_slot = function (arg_24_0)
	local var_24_0 = arg_24_0._equipment.wielded_slot

	return arg_24_0:wield(var_24_0)
end

SimpleInventoryExtension.wield = function (arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0._equipment
	local var_25_1 = var_25_0.slots[arg_25_1]

	if var_25_1 == nil then
		return false
	end

	if var_25_0.wielded_slot ~= arg_25_1 then
		arg_25_0.buff_extension:trigger_procs("on_unwield")

		local var_25_2 = ScriptUnit.has_extension(var_25_0.left_hand_wielded_unit, "weapon_system")

		if var_25_2 then
			var_25_2:on_unwield("left")
		end

		local var_25_3 = ScriptUnit.has_extension(var_25_0.right_hand_wielded_unit, "weapon_system")

		if var_25_3 then
			var_25_3:on_unwield("right")
		end

		local var_25_4 = var_25_0.slots[var_25_0.wielded_slot]

		if var_25_4 then
			arg_25_0:swap_equipment_from_storage(var_25_0.wielded_slot, SwapFromStorageType.UnwieldPrio, var_25_4.item_data)
		end
	end

	arg_25_0:_stop_all_weapon_fx()
	arg_25_0:_despawn_attached_units()

	local var_25_5 = arg_25_0.career_extension

	CharacterStateHelper.stop_weapon_actions(arg_25_0, "weapon_wielded")
	CharacterStateHelper.stop_career_abilities(var_25_5, "weapon_wielded")

	local var_25_6 = var_25_1.item_data
	local var_25_7 = BackendUtils.get_item_template(var_25_6)
	local var_25_8 = arg_25_0:_wield_slot(var_25_0, var_25_1, arg_25_0._first_person_unit, arg_25_0._unit)

	var_25_0.wielded_slot = arg_25_1

	local var_25_9 = var_25_6.backend_id
	local var_25_10 = arg_25_0:_get_property_and_trait_buffs(var_25_9)

	if var_25_7.buffs then
		for iter_25_0, iter_25_1 in pairs(var_25_7.buffs) do
			var_25_10.client[iter_25_0] = iter_25_1
		end
	end

	if var_25_7.server_buffs then
		for iter_25_2, iter_25_3 in pairs(var_25_7.server_buffs) do
			var_25_10.server[iter_25_2] = iter_25_3
		end
	end

	arg_25_0:apply_buffs(var_25_10, "wield", var_25_6.name, arg_25_1)
	arg_25_0.buff_extension:trigger_procs("on_inventory_post_apply_buffs", var_25_0)

	if var_25_8 then
		arg_25_0:show_first_person_inventory(arg_25_0._show_first_person)
		arg_25_0:show_first_person_inventory_lights(arg_25_0._show_first_person_lights)
		arg_25_0:show_third_person_inventory(arg_25_0._show_third_person)

		if arg_25_1 == "slot_packmaster_claw" then
			local var_25_11 = ScriptUnit.extension(arg_25_0._unit, "status_system"):get_pack_master_grabber()
			local var_25_12 = Managers.player:unit_owner(var_25_11)
			local var_25_13 = CosmeticUtils.get_cosmetic_slot(var_25_12, "slot_skin")

			if var_25_13 then
				if var_25_13.item_name ~= "skaven_pack_master_skin_1001" then
					Unit.flow_event(arg_25_0._equipment.right_hand_wielded_unit_3p, "lua_wield_0000")
				else
					Unit.flow_event(arg_25_0._equipment.right_hand_wielded_unit_3p, "lua_wield_1001")
				end
			end
		end
	end

	local var_25_14 = Managers.state.network
	local var_25_15 = var_25_14:game()
	local var_25_16 = NetworkLookup.equipment_slots[arg_25_1]
	local var_25_17 = Managers.state.unit_storage:go_id(arg_25_0._unit)

	if var_25_15 and not LEVEL_EDITOR_TEST then
		if arg_25_0.is_server then
			var_25_14.network_transmit:send_rpc_clients("rpc_wield_equipment", var_25_17, var_25_16)
		else
			var_25_14.network_transmit:send_rpc_server("rpc_wield_equipment", var_25_17, var_25_16)
		end
	end

	arg_25_0:_spawn_attached_units(var_25_7.first_person_attached_units)

	if arg_25_1 == "slot_melee" or arg_25_1 == "slot_ranged" then
		arg_25_0._previously_wielded_weapon_slot = arg_25_1
	end

	if arg_25_1 == "slot_melee" or arg_25_1 == "slot_ranged" or arg_25_1 == "slot_grenade" or arg_25_1 == "slot_healthkit" or arg_25_1 == "slot_potion" or arg_25_1 == "slot_level_event" then
		arg_25_0._previously_wielded_slot = arg_25_1
	end

	if arg_25_1 == "slot_melee" or arg_25_1 == "slot_ranged" or arg_25_1 == "slot_grenade" or arg_25_1 == "slot_healthkit" or arg_25_1 == "slot_potion" then
		arg_25_0._previously_wielded_non_level_slot = arg_25_1
	end

	arg_25_0:start_weapon_fx("wield")

	local var_25_18 = ScriptUnit.has_extension(var_25_0.left_hand_wielded_unit, "weapon_system")

	if var_25_18 then
		var_25_18:on_wield("left")
	end

	local var_25_19 = ScriptUnit.has_extension(var_25_0.right_hand_wielded_unit, "weapon_system")

	if var_25_19 then
		var_25_19:on_wield("right")
	end

	arg_25_0.buff_extension:trigger_procs("on_wield")

	return true
end

SimpleInventoryExtension._despawn_attached_units = function (arg_26_0)
	local var_26_0 = arg_26_0._attached_units

	for iter_26_0, iter_26_1 in pairs(var_26_0) do
		Managers.state.unit_spawner:mark_for_deletion(iter_26_1)

		var_26_0[iter_26_0] = nil
	end
end

SimpleInventoryExtension._spawn_attached_units = function (arg_27_0, arg_27_1)
	if arg_27_1 == nil then
		return
	end

	local var_27_0 = arg_27_0._unit
	local var_27_1 = arg_27_0._world
	local var_27_2 = arg_27_0._attached_units

	for iter_27_0, iter_27_1 in pairs(arg_27_1) do
		var_27_2[iter_27_0] = AttachmentUtils.create_weapon_visual_attachment(var_27_1, var_27_0, iter_27_1.unit, iter_27_1.attachment_node_linking)
	end
end

local var_0_1 = {}

SimpleInventoryExtension.apply_buffs = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	local var_28_0 = arg_28_0.buff_extension
	local var_28_1 = arg_28_0.current_item_buffs[arg_28_2]

	if arg_28_2 == "wield" then
		for iter_28_0 = 1, #var_28_1 do
			local var_28_2 = var_28_1[iter_28_0]

			var_28_0:remove_buff(var_28_2)
		end

		table.clear(var_28_1)
	elseif arg_28_2 == "equip" then
		var_28_1 = var_28_1[arg_28_4]

		if var_28_1 then
			for iter_28_1 = 1, #var_28_1 do
				local var_28_3 = var_28_1[iter_28_1]

				var_28_0:remove_buff(var_28_3)
			end

			table.clear(var_28_1)
		end
	end

	local var_28_4 = 1

	for iter_28_2, iter_28_3 in pairs(arg_28_1) do
		if arg_28_0.is_server or iter_28_2 == "client" or iter_28_2 == "both" then
			for iter_28_4, iter_28_5 in pairs(iter_28_3) do
				local var_28_5 = BuffUtils.get_buff_template(iter_28_4)

				fassert(var_28_5, "buff name %s does not exist on item %s, typo?", iter_28_4, arg_28_3)
				table.clear(var_0_1)

				for iter_28_6, iter_28_7 in pairs(iter_28_5) do
					var_0_1[iter_28_6] = iter_28_7
				end

				var_28_1[var_28_4] = var_28_0:add_buff(iter_28_4, var_0_1)
				var_28_4 = var_28_4 + 1
			end
		end
	end
end

SimpleInventoryExtension.has_inventory_item = function (arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = arg_29_0:get_slot_data(arg_29_1)

	if var_29_0 and arg_29_2 == var_29_0.item_data.name then
		return true
	end

	local var_29_1 = arg_29_0:get_additional_items(arg_29_1)

	if var_29_1 then
		for iter_29_0 = 1, #var_29_1 do
			if arg_29_2 == var_29_1[iter_29_0].name then
				return true
			end
		end
	end

	return false
end

SimpleInventoryExtension.add_equipment = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5)
	local var_30_0

	if type(arg_30_2) == "string" then
		var_30_0 = ItemMasterList[arg_30_2]
	else
		var_30_0 = arg_30_2
	end

	local var_30_1 = arg_30_0._world
	local var_30_2 = arg_30_0._equipment
	local var_30_3 = arg_30_0._first_person_unit
	local var_30_4 = arg_30_0._unit
	local var_30_5 = arg_30_0.is_bot
	local var_30_6 = arg_30_0._career_name
	local var_30_7, var_30_8 = arg_30_0:_override_career_skill_item_template(var_30_0)
	local var_30_9 = GearUtils.create_equipment(var_30_1, arg_30_1, var_30_0, var_30_3, var_30_4, var_30_5, arg_30_3, arg_30_4, arg_30_5, var_30_7, var_30_8, var_30_6)

	var_30_9.master_item = var_30_0
	var_30_2.slots[arg_30_1] = var_30_9
	arg_30_0.recently_acquired_list[arg_30_1] = var_30_9

	CosmeticUtils.update_cosmetic_slot(arg_30_0.player, arg_30_1, var_30_0.name, var_30_9.skin)

	local var_30_10 = Managers.backend:get_interface("items"):get_item_from_id(var_30_0.backend_id) or rawget(ItemMasterList, var_30_0.name)

	LoadoutUtils.sync_loadout_slot(arg_30_0.player, arg_30_1, var_30_10)

	local var_30_11 = var_30_0.name
	local var_30_12 = arg_30_0:_get_no_wield_required_property_and_trait_buffs(var_30_0.backend_id)

	arg_30_0:apply_buffs(var_30_12, "equip", var_30_11, arg_30_1)
end

SimpleInventoryExtension.show_first_person_inventory_lights = function (arg_31_0, arg_31_1)
	arg_31_0._show_first_person_lights = arg_31_1

	local var_31_0 = arg_31_0._equipment.right_hand_wielded_unit

	if var_31_0 and Unit.alive(var_31_0) and Unit.has_visibility_group(var_31_0, "normal") then
		local var_31_1 = Unit.num_lights(var_31_0)

		for iter_31_0 = 1, var_31_1 do
			Light.set_enabled(Unit.light(var_31_0, iter_31_0 - 1), arg_31_1)
		end
	end

	local var_31_2 = arg_31_0._equipment.left_hand_wielded_unit

	if var_31_2 and Unit.alive(var_31_2) and Unit.has_visibility_group(var_31_2, "normal") then
		local var_31_3 = Unit.num_lights(var_31_2)

		for iter_31_1 = 1, var_31_3 do
			Light.set_enabled(Unit.light(var_31_2, iter_31_1 - 1), arg_31_1)
		end
	end
end

SimpleInventoryExtension.show_first_person_inventory = function (arg_32_0, arg_32_1)
	arg_32_0._show_first_person = arg_32_1

	local var_32_0 = arg_32_0._equipment.right_hand_wielded_unit

	if var_32_0 and Unit.alive(var_32_0) then
		if Unit.has_visibility_group(var_32_0, "normal") then
			Unit.set_visibility(var_32_0, "normal", arg_32_1)
		else
			Unit.set_unit_visibility(var_32_0, arg_32_1)
		end

		if arg_32_1 then
			Unit.flow_event(var_32_0, "lua_wield")
		else
			Unit.flow_event(var_32_0, "lua_unwield")
		end
	end

	local var_32_1 = arg_32_0._equipment.left_hand_wielded_unit

	if var_32_1 and Unit.alive(var_32_1) then
		if Unit.has_visibility_group(var_32_1, "normal") then
			Unit.set_visibility(var_32_1, "normal", arg_32_1)
		else
			Unit.set_unit_visibility(var_32_1, arg_32_1)
		end

		if arg_32_1 then
			Unit.flow_event(var_32_1, "lua_wield")
		else
			Unit.flow_event(var_32_1, "lua_unwield")
		end
	end

	arg_32_0:show_first_person_ammo(arg_32_1)
	arg_32_0:_despawn_attached_units()

	local var_32_2 = arg_32_0._equipment
	local var_32_3 = var_32_2.wielded_slot

	if var_32_3 then
		local var_32_4 = var_32_2.slots[var_32_3]

		if var_32_4 then
			local var_32_5 = var_32_4.item_data
			local var_32_6 = BackendUtils.get_item_template(var_32_5)

			if arg_32_1 then
				arg_32_0:_spawn_attached_units(var_32_6.first_person_attached_units)
			else
				arg_32_0:_spawn_attached_units(var_32_6.third_person_attached_units)
			end
		end
	end

	if arg_32_1 then
		Unit.flow_event(arg_32_0._first_person_unit, "lua_wield")
	else
		Unit.flow_event(arg_32_0._first_person_unit, "lua_unwield")
	end
end

SimpleInventoryExtension.show_first_person_ammo = function (arg_33_0, arg_33_1)
	local var_33_0 = arg_33_0._equipment
	local var_33_1 = var_33_0.right_hand_wielded_unit
	local var_33_2 = var_33_0.left_hand_wielded_unit

	if var_33_1 and Unit.alive(var_33_1) then
		local var_33_3 = var_33_0.right_hand_ammo_unit_1p

		if var_33_3 then
			Unit.set_unit_visibility(var_33_3, arg_33_1)

			if arg_33_1 then
				Unit.flow_event(var_33_3, "lua_wield")
			else
				Unit.flow_event(var_33_3, "lua_unwield")
			end
		end
	end

	if var_33_2 and Unit.alive(var_33_2) then
		local var_33_4 = var_33_0.left_hand_ammo_unit_1p

		if var_33_4 then
			Unit.set_unit_visibility(var_33_4, arg_33_1)

			if arg_33_1 then
				Unit.flow_event(var_33_4, "lua_wield")
			else
				Unit.flow_event(var_33_4, "lua_unwield")
			end
		end
	end
end

SimpleInventoryExtension.show_third_person_inventory = function (arg_34_0, arg_34_1)
	arg_34_0._show_third_person = arg_34_1

	local var_34_0 = arg_34_0._equipment.right_hand_wielded_unit_3p

	if var_34_0 then
		if Unit.has_visibility_group(var_34_0, "normal") then
			Unit.set_visibility(var_34_0, "normal", arg_34_1)
		else
			Unit.set_unit_visibility(var_34_0, arg_34_1)
		end

		local var_34_1 = arg_34_0._equipment.right_hand_ammo_unit_3p

		if var_34_1 then
			Unit.set_unit_visibility(var_34_1, arg_34_1)
		end

		if arg_34_1 then
			Unit.flow_event(var_34_0, "lua_wield")

			if var_34_1 then
				Unit.flow_event(var_34_1, "lua_wield")
			end
		else
			Unit.flow_event(var_34_0, "lua_unwield")

			if var_34_1 then
				Unit.flow_event(var_34_1, "lua_unwield")
			end
		end
	end

	local var_34_2 = arg_34_0._equipment.left_hand_wielded_unit_3p

	if var_34_2 then
		if Unit.has_visibility_group(var_34_2, "normal") then
			Unit.set_visibility(var_34_2, "normal", arg_34_1)
		else
			Unit.set_unit_visibility(var_34_2, arg_34_1)
		end

		local var_34_3 = arg_34_0._equipment.left_hand_ammo_unit_3p

		if var_34_3 then
			Unit.set_unit_visibility(var_34_3, arg_34_1)
		end

		if arg_34_1 then
			Unit.flow_event(var_34_2, "lua_wield")

			if var_34_3 then
				Unit.flow_event(var_34_3, "lua_wield")
			end
		else
			Unit.flow_event(var_34_2, "lua_unwield")

			if var_34_3 then
				Unit.flow_event(var_34_3, "lua_unwield")
			end
		end
	end

	arg_34_0:_despawn_attached_units()

	local var_34_4 = arg_34_0._equipment
	local var_34_5 = arg_34_0._equipment.wielded_slot

	if var_34_5 then
		local var_34_6 = var_34_4.slots[var_34_5]

		if var_34_6 then
			local var_34_7 = var_34_6.item_data
			local var_34_8 = BackendUtils.get_item_template(var_34_7)

			if arg_34_1 then
				arg_34_0:_spawn_attached_units(var_34_8.third_person_attached_units)
			else
				arg_34_0:_spawn_attached_units(var_34_8.first_person_attached_units)
			end
		end
	end

	if arg_34_1 then
		Unit.flow_event(arg_34_0._unit, "lua_wield")
	else
		Unit.flow_event(arg_34_0._unit, "lua_unwield")
	end
end

SimpleInventoryExtension.is_showing_third_person_inventory = function (arg_35_0)
	return arg_35_0._show_third_person
end

SimpleInventoryExtension.hot_join_sync = function (arg_36_0, arg_36_1)
	GearUtils.hot_join_sync(arg_36_1, arg_36_0._unit, arg_36_0._equipment, arg_36_0._additional_items)
end

SimpleInventoryExtension.destroy_item_by_name = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
	local var_37_0 = arg_37_0:get_slot_data(arg_37_1)

	if var_37_0 and var_37_0.item_data.name == arg_37_2 then
		arg_37_0:destroy_slot(arg_37_1, arg_37_3, arg_37_4)
	else
		local var_37_1 = arg_37_0:get_additional_items(arg_37_1)

		if var_37_1 then
			for iter_37_0 = #var_37_1, 1, -1 do
				local var_37_2 = var_37_1[iter_37_0]

				if var_37_2.name == arg_37_2 then
					arg_37_0:remove_additional_item(arg_37_1, var_37_2)

					break
				end
			end
		end
	end
end

SimpleInventoryExtension.destroy_slot = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	local var_38_0 = arg_38_0._equipment
	local var_38_1 = var_38_0.slots[arg_38_1]

	if var_38_1 == nil then
		if arg_38_3 then
			arg_38_0:swap_equipment_from_storage(arg_38_1)
		end

		return
	end

	local var_38_2 = var_38_1.right_unit_1p or var_38_1.left_unit_1p

	if Managers.player.is_server and ScriptUnit.has_extension(var_38_2, "limited_item_track_system") then
		local var_38_3 = ScriptUnit.extension(var_38_2, "limited_item_track_system")

		if not var_38_3.thrown then
			local var_38_4 = var_38_3.spawner_unit
			local var_38_5 = ScriptUnit.extension(var_38_4, "limited_item_track_system")
			local var_38_6 = var_38_3.id

			if var_38_5:is_transformed(var_38_6) then
				Managers.state.entity:system("limited_item_track_system"):held_limited_item_destroyed(var_38_4, var_38_6)
			end
		end
	end

	local var_38_7 = var_38_1.link_pickup_template_name
	local var_38_8 = Managers.state.entity:system("pickup_system")

	if var_38_7 then
		var_38_8:delete_limited_owned_pickup_type(arg_38_0.player:network_id(), var_38_7)
	end

	if var_38_1.destroy_indexed_projectiles then
		Managers.state.entity:system("projectile_system"):delete_indexed_projectiles(arg_38_0._unit)
	end

	local var_38_9 = Managers.state.unit_storage:go_id(arg_38_0._unit)
	local var_38_10 = NetworkLookup.equipment_slots[arg_38_1]
	local var_38_11 = Managers.state.network

	if Managers.state.network:game() and not LEVEL_EDITOR_TEST then
		if arg_38_0.is_server then
			var_38_11.network_transmit:send_rpc_clients("rpc_destroy_slot", var_38_9, var_38_10)
		else
			var_38_11.network_transmit:send_rpc_server("rpc_destroy_slot", var_38_9, var_38_10)
		end
	end

	GearUtils.destroy_slot(arg_38_0._world, arg_38_0._unit, var_38_1, var_38_0, arg_38_2)

	if arg_38_3 then
		arg_38_0:swap_equipment_from_storage(arg_38_1, SwapFromStorageType.SameOrAny, var_38_1.item_data)
	end
end

SimpleInventoryExtension.current_ammo_status = function (arg_39_0, arg_39_1)
	local var_39_0 = arg_39_0._equipment.slots[arg_39_1]

	if not var_39_0 then
		return
	end

	if arg_39_0:get_item_template(var_39_0).ammo_data then
		local var_39_1 = var_39_0.right_unit_1p
		local var_39_2 = var_39_0.left_unit_1p
		local var_39_3 = GearUtils.get_ammo_extension(var_39_1, var_39_2)

		if var_39_3 then
			local var_39_4 = var_39_3:total_remaining_ammo()
			local var_39_5 = var_39_3:max_ammo()

			return var_39_4, var_39_5
		end
	end
end

SimpleInventoryExtension.ammo_percentage = function (arg_40_0)
	local var_40_0, var_40_1 = arg_40_0:current_ammo_status("slot_ranged")
	local var_40_2 = 1

	if var_40_0 and var_40_1 then
		var_40_2 = var_40_0 / var_40_1
	end

	return var_40_2
end

SimpleInventoryExtension.ammo_status = function (arg_41_0)
	local var_41_0, var_41_1 = arg_41_0:current_ammo_status("slot_ranged")

	return var_41_0, var_41_1
end

SimpleInventoryExtension.current_ammo_kind = function (arg_42_0, arg_42_1)
	local var_42_0 = arg_42_0._equipment.slots[arg_42_1]

	if not var_42_0 then
		return
	end

	if arg_42_0:get_item_template(var_42_0).ammo_data then
		local var_42_1 = var_42_0.right_unit_1p
		local var_42_2 = var_42_0.left_unit_1p
		local var_42_3 = GearUtils.get_ammo_extension(var_42_1, var_42_2)

		if var_42_3 then
			return (var_42_3:ammo_kind())
		end
	end
end

SimpleInventoryExtension.add_ammo_from_pickup = function (arg_43_0, arg_43_1)
	local var_43_0 = arg_43_0._equipment.slots
	local var_43_1 = arg_43_1.refill_percentage
	local var_43_2 = arg_43_1.refill_amount

	fassert(not var_43_1 or not var_43_2, "ammo pickups has to contain either refill_percentage or refill_amount, not both")

	for iter_43_0, iter_43_1 in pairs(var_43_0) do
		local var_43_3 = arg_43_0:get_item_template(iter_43_1).ammo_data

		if var_43_3 and not var_43_3.ignore_ammo_pickup then
			arg_43_0:_add_ammo_to_slot(iter_43_0, iter_43_1, var_43_1, var_43_2)
		end
	end
end

SimpleInventoryExtension._add_ammo_to_slot = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
	local var_44_0 = arg_44_2.left_unit_1p
	local var_44_1 = arg_44_2.right_unit_1p
	local var_44_2

	if var_44_0 and ScriptUnit.has_extension(var_44_0, "ammo_system") then
		var_44_2 = ScriptUnit.extension(var_44_0, "ammo_system")
	end

	if var_44_1 then
		if ScriptUnit.has_extension(var_44_1, "ammo_system") then
			var_44_2 = ScriptUnit.extension(var_44_1, "ammo_system")
		elseif not var_44_2 then
			return
		end
	elseif not var_44_2 then
		return
	end

	local var_44_3 = var_44_2:max_ammo()

	if arg_44_3 then
		arg_44_4 = var_44_3 * arg_44_3
	end

	var_44_2:add_ammo(arg_44_4)

	if (var_44_2:reload_on_ammo_pickup() or var_44_2:ammo_count() == 0) and arg_44_0._equipment.wielded_slot == arg_44_1 and var_44_2:can_reload() then
		local var_44_4 = true

		var_44_2:start_reload(var_44_4)

		if var_44_2:reload_on_ammo_pickup() then
			CharacterStateHelper.stop_weapon_actions(arg_44_0, "reload")
		end
	end
end

SimpleInventoryExtension.get_item_template = function (arg_45_0, arg_45_1)
	if arg_45_1 then
		local var_45_0 = arg_45_1.item_data

		return (BackendUtils.get_item_template(var_45_0))
	end

	return nil
end

SimpleInventoryExtension.get_wielded_slot_item_template = function (arg_46_0)
	local var_46_0 = arg_46_0:get_wielded_slot_name()
	local var_46_1 = arg_46_0:get_slot_data(var_46_0)

	return arg_46_0:get_item_template(var_46_1)
end

SimpleInventoryExtension.get_wielded_slot_name = function (arg_47_0)
	return arg_47_0._equipment.wielded_slot
end

SimpleInventoryExtension.get_slot_data = function (arg_48_0, arg_48_1)
	return arg_48_0._equipment.slots[arg_48_1]
end

SimpleInventoryExtension.get_wielded_slot_data = function (arg_49_0)
	local var_49_0 = arg_49_0:get_wielded_slot_name()

	return (arg_49_0:get_slot_data(var_49_0))
end

SimpleInventoryExtension.get_item_name = function (arg_50_0, arg_50_1)
	local var_50_0 = arg_50_0:get_slot_data(arg_50_1)
	local var_50_1 = var_50_0 and var_50_0.item_data

	return var_50_1 and var_50_1.name
end

SimpleInventoryExtension.get_item_data = function (arg_51_0, arg_51_1)
	local var_51_0 = arg_51_0:get_slot_data(arg_51_1)

	return var_51_0 and var_51_0.item_data
end

SimpleInventoryExtension.create_equipment_in_slot = function (arg_52_0, arg_52_1, arg_52_2, arg_52_3)
	local var_52_0 = BackendUtils.get_item_from_masterlist(arg_52_2)

	if not var_52_0 then
		Crashify.print_exception("SimpleInventoryExtension", "Tried create equip %q in slot %q but was unable to find item", arg_52_2, arg_52_1)

		return
	end

	local var_52_1 = arg_52_0._equipment.slots[arg_52_1]
	local var_52_2
	local var_52_3

	if not var_52_1 then
		print("[SimpleInventoryExtension] create_equipment_in_slot called on " .. arg_52_1 .. "that is empty")

		var_52_3 = false
	else
		var_52_3 = var_52_1.item_data == var_52_0
	end

	local var_52_4 = BackendUtils.get_item_units(var_52_0, nil, nil, arg_52_0._career_name)

	if var_52_3 then
		return
	end

	arg_52_0:destroy_slot(arg_52_1, true)

	if arg_52_1 == arg_52_0._equipment.wielded_slot then
		local var_52_5 = arg_52_0._profile.default_state_machine

		if var_52_5 then
			arg_52_0.first_person_extension:set_state_machine(var_52_5)
		end
	end

	arg_52_0:_queue_item_spawn(arg_52_1, var_52_0, var_52_4.skin, arg_52_3)

	local var_52_6 = arg_52_0.talent_extension
	local var_52_7 = var_52_6 and var_52_6:get_talent_career_skill_index() or 1
	local var_52_8 = var_52_6 and var_52_6:get_talent_career_weapon_index()
	local var_52_9 = arg_52_0.career_extension:career_skill_weapon_name(var_52_7, var_52_8)

	if var_52_9 then
		local var_52_10 = rawget(ItemMasterList, var_52_9)

		if var_52_10 and var_52_10.slot_to_use == arg_52_1 then
			arg_52_0:destroy_slot("slot_career_skill_weapon", true)

			var_52_10.left_hand_unit = var_52_0.left_hand_unit
			var_52_10.right_hand_unit = var_52_0.right_hand_unit

			arg_52_0:_queue_item_spawn("slot_career_skill_weapon", var_52_10, var_52_4.skin)
		end
	end
end

SimpleInventoryExtension._queue_item_spawn = function (arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4)
	if not arg_53_1 or not arg_53_2 then
		return
	end

	arg_53_0._items_to_spawn[arg_53_1] = {
		slot_id = arg_53_1,
		item_data = arg_53_2,
		skin = arg_53_3,
		ammo_percent = arg_53_4
	}
	arg_53_0.resync_loadout_needed = true
end

SimpleInventoryExtension._spawn_resynced_loadout = function (arg_54_0, arg_54_1, arg_54_2)
	local var_54_0 = arg_54_1.item_data
	local var_54_1 = arg_54_1.slot_id
	local var_54_2 = arg_54_1.ammo_percent
	local var_54_3 = Managers.state.network
	local var_54_4 = Managers.state.unit_storage:go_id(arg_54_0._unit)
	local var_54_5 = NetworkLookup.equipment_slots[var_54_1]
	local var_54_6 = NetworkLookup.item_names[var_54_0.name]
	local var_54_7 = NetworkLookup.weapon_skins[arg_54_1.skin or "n/a"]

	if arg_54_0.is_server then
		var_54_3.network_transmit:send_rpc_clients("rpc_add_equipment", var_54_4, var_54_5, var_54_6, var_54_7)
	else
		var_54_3.network_transmit:send_rpc_server("rpc_add_equipment", var_54_4, var_54_5, var_54_6, var_54_7)

		if var_54_1 == "slot_ranged" or var_54_1 == "slot_melee" then
			local var_54_8 = var_54_0.backend_id

			arg_54_0:_send_rpc_add_equipment_buffs(var_54_4, var_54_5, var_54_8)
		end
	end

	local var_54_9
	local var_54_10

	arg_54_0:add_equipment(var_54_1, var_54_0, var_54_9, var_54_10, var_54_2)

	if not arg_54_2 and var_54_1 ~= "slot_career_skill_weapon" and var_54_1 ~= "slot_level_event" then
		arg_54_0:wield(var_54_1)
	end
end

local var_0_2 = {
	slot_ranged = true,
	slot_melee = true
}

SimpleInventoryExtension.has_unique_ammo_type_weapon_equipped = function (arg_55_0)
	local var_55_0 = arg_55_0._equipment.slots

	for iter_55_0, iter_55_1 in pairs(var_55_0) do
		if var_0_2[iter_55_0] then
			local var_55_1 = arg_55_0:get_item_template(iter_55_1)

			if var_55_1 then
				local var_55_2 = var_55_1.ammo_data

				if var_55_2 and var_55_2.unique_ammo_type then
					return true
				end
			end
		end
	end

	return false
end

SimpleInventoryExtension.has_ammo_consuming_weapon_equipped = function (arg_56_0, arg_56_1)
	local var_56_0 = arg_56_0._equipment.slots
	local var_56_1 = false

	for iter_56_0, iter_56_1 in pairs(var_56_0) do
		if var_0_2[iter_56_0] then
			local var_56_2 = iter_56_1.left_unit_1p
			local var_56_3 = var_56_2 and ScriptUnit.has_extension(var_56_2, "ammo_system")

			if var_56_3 then
				if arg_56_1 then
					var_56_1 = var_56_3:ammo_type() == arg_56_1
				else
					var_56_1 = true
				end
			end

			local var_56_4 = iter_56_1.right_unit_1p
			local var_56_5 = var_56_4 and ScriptUnit.has_extension(var_56_4, "ammo_system")

			if var_56_5 then
				if arg_56_1 then
					var_56_1 = var_56_5:ammo_type() == arg_56_1
				else
					var_56_1 = true
				end
			end
		end

		if var_56_1 then
			return true
		end
	end

	return false
end

SimpleInventoryExtension.has_infinite_ammo = function (arg_57_0)
	local var_57_0 = arg_57_0._equipment.slots
	local var_57_1 = false

	for iter_57_0, iter_57_1 in pairs(var_57_0) do
		if var_0_2[iter_57_0] then
			local var_57_2 = iter_57_1.left_unit_1p
			local var_57_3 = var_57_2 and ScriptUnit.has_extension(var_57_2, "ammo_system")

			if var_57_3 and var_57_3:infinite_ammo() then
				return true
			end

			local var_57_4 = iter_57_1.right_unit_1p
			local var_57_5 = var_57_4 and ScriptUnit.has_extension(var_57_4, "ammo_system")

			if var_57_5 and var_57_5:infinite_ammo() then
				return true
			end
		end
	end

	return false
end

SimpleInventoryExtension.reset_ammo = function (arg_58_0, arg_58_1)
	local var_58_0 = arg_58_0._equipment.slots[arg_58_1]
	local var_58_1 = var_58_0.right_unit_1p
	local var_58_2 = ScriptUnit.has_extension(var_58_1, "ammo_system") and ScriptUnit.extension(var_58_1, "ammo_system")

	if var_58_2 then
		var_58_2:reset()
	end

	local var_58_3 = var_58_0.left_unit_1p
	local var_58_4 = ScriptUnit.has_extension(var_58_3, "ammo_system") and ScriptUnit.extension(var_58_3, "ammo_system")

	if var_58_4 then
		var_58_4:reset()
	end
end

SimpleInventoryExtension.has_full_ammo = function (arg_59_0)
	local var_59_0 = arg_59_0._equipment.slots
	local var_59_1 = true

	for iter_59_0, iter_59_1 in pairs(var_59_0) do
		if var_0_2[iter_59_0] then
			local var_59_2 = iter_59_1.left_unit_1p
			local var_59_3 = iter_59_1.right_unit_1p
			local var_59_4 = ScriptUnit.has_extension(var_59_3, "ammo_system") and ScriptUnit.extension(var_59_3, "ammo_system")

			var_59_4 = var_59_4 or ScriptUnit.has_extension(var_59_2, "ammo_system") and ScriptUnit.extension(var_59_2, "ammo_system")

			if var_59_4 and not var_59_4:full_ammo() then
				var_59_1 = false

				break
			end
		end
	end

	return var_59_1
end

SimpleInventoryExtension.is_ammo_blocked = function (arg_60_0)
	local var_60_0 = arg_60_0._equipment.slots
	local var_60_1 = false

	for iter_60_0, iter_60_1 in pairs(var_60_0) do
		if var_0_2[iter_60_0] then
			local var_60_2 = iter_60_1.left_unit_1p
			local var_60_3 = iter_60_1.right_unit_1p
			local var_60_4 = ScriptUnit.has_extension(var_60_3, "ammo_system") and ScriptUnit.extension(var_60_3, "ammo_system")

			var_60_4 = var_60_4 or ScriptUnit.has_extension(var_60_2, "ammo_system") and ScriptUnit.extension(var_60_2, "ammo_system")

			if var_60_4 and var_60_4:ammo_blocked() then
				var_60_1 = true

				break
			end
		end
	end

	return var_60_1
end

SimpleInventoryExtension.apply_buffs_to_ammo = function (arg_61_0)
	local var_61_0 = arg_61_0._equipment.slots

	for iter_61_0, iter_61_1 in pairs(var_61_0) do
		if var_0_2[iter_61_0] then
			local var_61_1 = iter_61_1.left_unit_1p
			local var_61_2 = iter_61_1.right_unit_1p
			local var_61_3 = ScriptUnit.has_extension(var_61_1, "ammo_system")

			if var_61_3 then
				var_61_3:apply_buffs()
			end

			local var_61_4 = ScriptUnit.has_extension(var_61_2, "ammo_system")

			if var_61_4 then
				var_61_4:apply_buffs()
			end
		end
	end
end

SimpleInventoryExtension.refresh_buffs_on_ammo = function (arg_62_0)
	local var_62_0 = arg_62_0._equipment.slots

	for iter_62_0, iter_62_1 in pairs(var_62_0) do
		if var_0_2[iter_62_0] then
			local var_62_1 = iter_62_1.left_unit_1p
			local var_62_2 = iter_62_1.right_unit_1p
			local var_62_3 = ScriptUnit.has_extension(var_62_1, "ammo_system")

			if var_62_3 then
				var_62_3:refresh_buffs()
			end

			local var_62_4 = ScriptUnit.has_extension(var_62_2, "ammo_system")

			if var_62_4 then
				var_62_4:refresh_buffs()
			end
		end
	end
end

SimpleInventoryExtension.drop_level_event_item = function (arg_63_0, arg_63_1)
	local var_63_0 = arg_63_0:get_item_template(arg_63_1)

	if var_63_0.no_drop then
		return
	end

	local var_63_1 = arg_63_1.right_unit_1p or arg_63_1.left_unit_1p
	local var_63_2 = var_63_0.actions.action_dropped.default

	fassert(var_63_2, "Action template needs a action_dropped defined if it's supposed to be force-dropped")

	local var_63_3 = var_63_2.projectile_info
	local var_63_4 = arg_63_0._unit
	local var_63_5 = Unit.world_position(var_63_4, 0) + Vector3(0, 0, 2)

	if NetworkUtils.network_safe_position(var_63_5) then
		local var_63_6 = Quaternion.identity()
		local var_63_7 = Vector3(math.random(), math.random(), math.random())
		local var_63_8 = Vector3(math.random(), math.random(), math.random())
		local var_63_9 = arg_63_1.item_data.name
		local var_63_10 = "dropped"

		ActionUtils.spawn_pickup_projectile(arg_63_0._world, var_63_1, var_63_3.projectile_unit_name, var_63_3.projectile_unit_template_name, var_63_2, var_63_4, var_63_5, var_63_6, var_63_7, var_63_8, var_63_9, var_63_10)
	end

	arg_63_0:destroy_slot("slot_level_event")
end

local function var_0_3(arg_64_0, arg_64_1, arg_64_2)
	local var_64_0 = arg_64_1 or Vector3(math.random(-1, 1) * arg_64_2, math.random(-1, 1) * arg_64_2, 2)
	local var_64_1 = Vector3.normalize(var_64_0)

	return arg_64_0 + var_64_0 * 0.2, var_64_1
end

local function var_0_4(arg_65_0, arg_65_1, arg_65_2, arg_65_3)
	if NetworkUtils.network_safe_position(arg_65_2) then
		local var_65_0 = math.random(-math.half_pi, math.half_pi) / 2
		local var_65_1 = Quaternion.axis_angle(arg_65_3, var_65_0)
		local var_65_2 = arg_65_1.pickup_name
		local var_65_3 = NetworkLookup.pickup_names[var_65_2]
		local var_65_4 = "dropped"
		local var_65_5 = NetworkLookup.pickup_spawn_types[var_65_4]

		Managers.state.network.network_transmit:send_rpc_server("rpc_spawn_pickup_with_physics", var_65_3, arg_65_2, var_65_1, var_65_5)
	end
end

SimpleInventoryExtension.check_and_drop_pickups = function (arg_66_0, arg_66_1, arg_66_2, arg_66_3)
	local var_66_0 = arg_66_0._unit
	local var_66_1 = arg_66_0._equipment.slots
	local var_66_2 = InventorySettings.slots_by_name
	local var_66_3 = arg_66_0:get_wielded_slot_name()
	local var_66_4 = 0
	local var_66_5 = arg_66_2 or POSITION_LOOKUP[var_66_0]

	for iter_66_0, iter_66_1 in pairs(var_66_1) do
		if iter_66_1 then
			local var_66_6 = iter_66_1.item_data
			local var_66_7 = BackendUtils.get_item_template(var_66_6).pickup_data
			local var_66_8 = var_66_2[iter_66_0].drop_reasons

			if var_66_8 and var_66_8[arg_66_1] then
				if var_66_7 and iter_66_0 ~= "slot_level_event" then
					local var_66_9, var_66_10 = var_0_3(var_66_5, arg_66_3, var_66_4)

					var_0_4(var_66_0, var_66_7, var_66_9, var_66_10)

					var_66_4 = var_66_4 + 1
				elseif iter_66_0 == "slot_level_event" then
					arg_66_0:drop_level_event_item(iter_66_1)
				end

				local var_66_11 = arg_66_0:get_additional_items(iter_66_0)

				if var_66_11 then
					for iter_66_2 = #var_66_11, 1, -1 do
						local var_66_12 = var_66_11[iter_66_2]
						local var_66_13 = BackendUtils.get_item_template(var_66_12).pickup_data

						if var_66_13 then
							local var_66_14, var_66_15 = var_0_3(var_66_5, arg_66_3, var_66_4)

							var_0_4(var_66_0, var_66_13, var_66_14, var_66_15)

							var_66_4 = var_66_4 + 1
						end

						local var_66_16 = iter_66_2 > 1

						arg_66_0:remove_additional_item(iter_66_0, var_66_12, var_66_16)
					end
				end

				arg_66_0:destroy_slot(iter_66_0)

				if iter_66_0 == var_66_3 then
					arg_66_0:wield_previous_weapon()
				end
			end
		end
	end
end

SimpleInventoryExtension.set_loaded_projectile_override = function (arg_67_0, arg_67_1)
	arg_67_0._loaded_projectile_settings_override = arg_67_1
end

SimpleInventoryExtension._update_loaded_projectile_settings = function (arg_68_0)
	local var_68_0
	local var_68_1 = arg_68_0:get_wielded_slot_item_template()
	local var_68_2 = arg_68_0._loaded_projectile_settings_override

	if var_68_2 then
		if var_68_2 ~= "none" then
			var_68_0 = var_68_2
		end
	elseif var_68_1 then
		var_68_0 = var_68_1.default_loaded_projectile_settings
	end

	arg_68_0._loaded_projectile_settings = var_68_0
end

SimpleInventoryExtension.get_loaded_projectile_settings = function (arg_69_0)
	return arg_69_0._loaded_projectile_settings
end

SimpleInventoryExtension._update_selected_consumable_slot = function (arg_70_0)
	local var_70_0 = arg_70_0._equipment.slots

	if not var_70_0[arg_70_0._selected_consumable_slot] then
		arg_70_0._selected_consumable_slot = nil
	end

	if not arg_70_0._selected_consumable_slot then
		for iter_70_0 = 1, #var_0_0 do
			local var_70_1 = var_0_0[iter_70_0]

			if var_70_0[var_70_1] then
				arg_70_0._selected_consumable_slot = var_70_1

				break
			end
		end
	end

	if arg_70_0._selected_consumable_slot then
		local var_70_2 = ScriptUnit.extension(arg_70_0._unit, "input_system")

		for iter_70_1, iter_70_2 in pairs(InventorySettings.slots_by_wield_input) do
			if not iter_70_2.loadout_slot and var_70_2:get(iter_70_2.wield_input) and var_70_0[iter_70_2.name] then
				arg_70_0._selected_consumable_slot = iter_70_2.name

				break
			end
		end
	end
end

SimpleInventoryExtension.get_selected_consumable_slot_template = function (arg_71_0)
	local var_71_0 = arg_71_0._selected_consumable_slot
	local var_71_1 = arg_71_0._equipment.slots[var_71_0]
	local var_71_2

	if var_71_1 then
		local var_71_3 = var_71_1.item_data

		var_71_2 = BackendUtils.get_item_template(var_71_3)
	end

	return var_71_2
end

SimpleInventoryExtension.get_selected_consumable_slot_name = function (arg_72_0)
	return arg_72_0._selected_consumable_slot
end

SimpleInventoryExtension.resyncing_loadout = function (arg_73_0)
	local var_73_0 = Managers.state.network.profile_synchronizer
	local var_73_1 = arg_73_0.player:network_id()
	local var_73_2 = arg_73_0.player:local_player_id()

	return not var_73_0:all_ingame_synced_for_peer(var_73_1, var_73_2)
end

SimpleInventoryExtension.get_item_slot_extension = function (arg_74_0, arg_74_1, arg_74_2)
	local var_74_0 = arg_74_0:get_slot_data(arg_74_1)
	local var_74_1 = var_74_0.right_unit_1p
	local var_74_2 = var_74_0.left_unit_1p
	local var_74_3, var_74_4 = ScriptUnit.has_extension(var_74_1, arg_74_2) and ScriptUnit.extension(var_74_1, arg_74_2), ScriptUnit.has_extension(var_74_2, arg_74_2) and ScriptUnit.extension(var_74_2, arg_74_2)

	if not var_74_3 and var_74_4 then
		var_74_3 = var_74_4
	end

	return var_74_3
end

SimpleInventoryExtension.get_num_grimoires = function (arg_75_0)
	local var_75_0 = ScriptUnit.extension(arg_75_0._unit, "buff_system")
	local var_75_1 = var_75_0:num_buff_perk("skaven_grimoire")
	local var_75_2 = var_75_0:num_buff_perk("twitch_grimoire")

	return var_75_1, var_75_2
end

local var_0_5 = {
	client = {},
	server = {},
	both = {}
}

SimpleInventoryExtension._get_property_and_trait_buffs = function (arg_76_0, arg_76_1)
	local var_76_0 = arg_76_0._backend_items

	table.clear(var_0_5.client)
	table.clear(var_0_5.server)
	table.clear(var_0_5.both)

	return GearUtils.get_property_and_trait_buffs(var_76_0, arg_76_1, var_0_5)
end

SimpleInventoryExtension._get_no_wield_required_property_and_trait_buffs = function (arg_77_0, arg_77_1)
	local var_77_0 = arg_77_0._backend_items

	table.clear(var_0_5.client)
	table.clear(var_0_5.server)
	table.clear(var_0_5.both)

	local var_77_1 = true

	return GearUtils.get_property_and_trait_buffs(var_77_0, arg_77_1, var_0_5, var_77_1)
end

local function var_0_6(arg_78_0, arg_78_1, arg_78_2)
	return arg_78_1 and arg_78_1[arg_78_2] or arg_78_0
end

SimpleInventoryExtension._wield_slot = function (arg_79_0, arg_79_1, arg_79_2, arg_79_3, arg_79_4, arg_79_5)
	Unit.flow_event(arg_79_3, "lua_unwield")
	arg_79_0.first_person_extension:animation_event("unwield")

	if arg_79_1.right_hand_wielded_unit then
		Unit.flow_event(arg_79_1.right_hand_wielded_unit, "lua_unwield")
		Unit.set_unit_visibility(arg_79_1.right_hand_wielded_unit, false)

		if ScriptUnit.has_extension(arg_79_1.right_hand_wielded_unit, "ammo_system") then
			local var_79_0 = ScriptUnit.extension(arg_79_1.right_hand_wielded_unit, "ammo_system")

			if var_79_0:is_reloading() then
				var_79_0:abort_reload()
			end
		end
	end

	if arg_79_1.right_hand_ammo_unit_1p then
		Unit.set_unit_visibility(arg_79_1.right_hand_ammo_unit_1p, false)
	end

	if arg_79_1.left_hand_wielded_unit then
		Unit.flow_event(arg_79_1.left_hand_wielded_unit, "lua_unwield")
		Unit.set_unit_visibility(arg_79_1.left_hand_wielded_unit, false)

		if ScriptUnit.has_extension(arg_79_1.left_hand_wielded_unit, "ammo_system") then
			local var_79_1 = ScriptUnit.extension(arg_79_1.left_hand_wielded_unit, "ammo_system")

			if var_79_1:is_reloading() then
				var_79_1:abort_reload()
			end
		end
	end

	if arg_79_1.left_hand_ammo_unit_1p then
		Unit.flow_event(arg_79_1.left_hand_ammo_unit_1p, "lua_unwield")
		Unit.set_unit_visibility(arg_79_1.left_hand_ammo_unit_1p, false)
	end

	if arg_79_1.right_hand_wielded_unit_3p then
		Unit.flow_event(arg_79_1.right_hand_wielded_unit_3p, "lua_unwield")
		Unit.set_unit_visibility(arg_79_1.right_hand_wielded_unit_3p, false)
	end

	if arg_79_1.right_hand_ammo_unit_3p then
		Unit.flow_event(arg_79_1.right_hand_ammo_unit_3p, "lua_unwield")
		Unit.set_unit_visibility(arg_79_1.right_hand_ammo_unit_3p, false)
	end

	if arg_79_1.left_hand_wielded_unit_3p then
		Unit.flow_event(arg_79_1.left_hand_wielded_unit_3p, "lua_unwield")
		Unit.set_unit_visibility(arg_79_1.left_hand_wielded_unit_3p, false)
	end

	if arg_79_1.left_hand_ammo_unit_3p then
		Unit.flow_event(arg_79_1.left_hand_ammo_unit_3p, "lua_unwield")
		Unit.set_unit_visibility(arg_79_1.left_hand_ammo_unit_3p, false)
	end

	if not arg_79_2 then
		return
	end

	local var_79_2 = arg_79_2.item_data

	arg_79_1.wielded = var_79_2
	arg_79_1.wielded_slot = arg_79_2.id
	arg_79_1.right_hand_wielded_unit_3p = arg_79_2.right_unit_3p
	arg_79_1.right_hand_ammo_unit_3p = arg_79_2.right_ammo_unit_3p
	arg_79_1.left_hand_wielded_unit_3p = arg_79_2.left_unit_3p
	arg_79_1.left_hand_ammo_unit_3p = arg_79_2.left_ammo_unit_3p

	local var_79_3 = ScriptUnit.extension(arg_79_4, "career_system"):career_index()

	if Unit.animation_has_variable(arg_79_4, "career_index") then
		local var_79_4 = Unit.animation_find_variable(arg_79_4, "career_index")

		Unit.animation_set_variable(arg_79_4, var_79_4, var_79_3)
	end

	local var_79_5 = BackendUtils.get_item_template(var_79_2)
	local var_79_6 = var_0_6(var_79_5.wield_anim, var_79_5.wield_anim_career, arg_79_0._career_name)

	if not script_data.disable_third_person_weapon_animation_events then
		local var_79_7 = var_0_6(var_79_5.wield_anim_3p, var_79_5.wield_anim_career_3p, arg_79_0._career_name) or var_79_6

		Unit.animation_event(arg_79_4, var_79_7)
	end

	if arg_79_2.right_unit_1p or arg_79_2.left_unit_1p then
		arg_79_1.right_hand_wielded_unit = arg_79_2.right_unit_1p
		arg_79_1.right_hand_ammo_unit_1p = arg_79_2.right_ammo_unit_1p
		arg_79_1.left_hand_wielded_unit = arg_79_2.left_unit_1p
		arg_79_1.left_hand_ammo_unit_1p = arg_79_2.left_ammo_unit_1p

		local var_79_8 = BLACKBOARDS[arg_79_0._unit]

		if var_79_8 then
			var_79_8.weapon_unit = arg_79_0:get_weapon_unit()
		end

		if arg_79_1.right_hand_wielded_unit then
			Unit.flow_event(arg_79_1.right_hand_wielded_unit, "lua_wield")
		end

		if arg_79_1.right_hand_ammo_unit_1p then
			Unit.flow_event(arg_79_1.right_hand_ammo_unit_1p, "lua_wield")
		end

		if arg_79_1.left_hand_wielded_unit then
			Unit.flow_event(arg_79_1.left_hand_wielded_unit, "lua_wield")
		end

		if arg_79_1.left_hand_ammo_unit_1p then
			Unit.flow_event(arg_79_1.left_hand_ammo_unit_1p, "lua_wield")
		end

		local var_79_9 = true

		if ScriptUnit.has_extension(arg_79_1.right_hand_wielded_unit, "ammo_system") then
			local var_79_10 = ScriptUnit.extension(arg_79_1.right_hand_wielded_unit, "ammo_system")

			if var_79_10:can_reload() and var_79_10:ammo_count() == 0 then
				var_79_6 = var_0_6(var_79_5.wield_anim_not_loaded, var_79_5.wield_anim_not_loaded_career, arg_79_0._career_name) or var_79_6

				local var_79_11 = var_79_10:play_reload_anim_on_wield_reload()
				local var_79_12 = var_79_10:has_wield_reload_anim()
				local var_79_13

				if var_79_12 then
					var_79_13 = var_79_6
					var_79_9 = not var_79_11
				end

				var_79_10:start_reload(var_79_11, nil, var_79_13)
			else
				var_79_6 = var_79_10:total_remaining_ammo() == 0 and var_0_6(var_79_5.wield_anim_no_ammo, var_79_5.wield_anim_no_ammo_career, arg_79_0._career_name) or var_79_6
			end
		end

		if ScriptUnit.has_extension(arg_79_1.left_hand_wielded_unit, "ammo_system") then
			local var_79_14 = ScriptUnit.extension(arg_79_1.left_hand_wielded_unit, "ammo_system")

			if var_79_14:can_reload() and var_79_14:ammo_count() == 0 then
				var_79_6 = var_0_6(var_79_5.wield_anim_not_loaded, var_79_5.wield_anim_not_loaded_career, arg_79_0._career_name) or var_79_6

				local var_79_15 = var_79_14:play_reload_anim_on_wield_reload()
				local var_79_16 = var_79_14:has_wield_reload_anim()
				local var_79_17

				if var_79_16 then
					var_79_17 = var_79_6
					var_79_9 = not var_79_15
				end

				var_79_14:start_reload(var_79_15, nil, var_79_17)
			else
				var_79_6 = var_79_14:total_remaining_ammo() == 0 and var_0_6(var_79_5.wield_anim_no_ammo, var_79_5.wield_anim_no_ammo_career, arg_79_0._career_name) or var_79_6
			end
		end

		local var_79_18 = WeaponUtils.get_item_state_machine(var_79_5, arg_79_0._career_name) or arg_79_0._profile.default_state_machine

		if var_79_18 then
			arg_79_0.first_person_extension:set_state_machine(var_79_18)
		end

		if var_79_9 then
			if Unit.animation_has_variable(arg_79_3, "animation_variation_id") then
				local var_79_19 = WeaponSkins.skins[arg_79_2.skin]
				local var_79_20 = var_79_19 and var_79_19.action_anim_overrides
				local var_79_21 = var_79_20 and var_79_20.animation_variation_id or 0

				arg_79_0.first_person_extension:animation_set_variable("animation_variation_id", var_79_21, true)
			end

			arg_79_0.first_person_extension:animation_event(var_79_6)
		end

		if arg_79_2.right_unit_1p then
			if Unit.has_visibility_group(arg_79_2.right_unit_1p, "normal") then
				Unit.set_visibility(arg_79_2.right_unit_1p, "normal", true)
			else
				Unit.set_unit_visibility(arg_79_2.right_unit_1p, true)
			end

			if arg_79_2.right_ammo_unit_1p then
				Unit.set_unit_visibility(arg_79_2.right_ammo_unit_1p, true)
			end
		end

		if arg_79_2.left_unit_1p then
			if Unit.has_visibility_group(arg_79_2.left_unit_1p, "normal") then
				Unit.set_visibility(arg_79_2.left_unit_1p, "normal", true)
			else
				Unit.set_unit_visibility(arg_79_2.left_unit_1p, true)
			end

			if arg_79_2.left_ammo_unit_1p then
				Unit.set_unit_visibility(arg_79_2.left_ammo_unit_1p, true)
			end
		end
	else
		if arg_79_1.right_hand_wielded_unit_3p then
			Unit.flow_event(arg_79_1.right_hand_wielded_unit_3p, "lua_wield")
			Unit.set_unit_visibility(arg_79_1.right_hand_wielded_unit_3p, true)

			if arg_79_2.right_ammo_unit_3p then
				Unit.set_unit_visibility(arg_79_2.right_ammo_unit_3p, true)
			end
		end

		if arg_79_1.left_hand_wielded_unit_3p then
			Unit.flow_event(arg_79_1.left_hand_wielded_unit_3p, "lua_wield")
			Unit.set_unit_visibility(arg_79_1.left_hand_wielded_unit_3p, true)

			if arg_79_2.left_ammo_unit_3p then
				Unit.set_unit_visibility(arg_79_2.left_ammo_unit_3p, true)
			end
		end
	end

	Unit.flow_event(arg_79_3, "lua_wield")
	Managers.state.event:trigger("on_weapon_wield", arg_79_1)

	return true
end

SimpleInventoryExtension.get_equipped_item_names = function (arg_80_0)
	local var_80_0 = {}

	for iter_80_0, iter_80_1 in pairs(arg_80_0._equipment.slots) do
		var_80_0[#var_80_0 + 1] = iter_80_1.item_data.name
	end

	return var_80_0
end

SimpleInventoryExtension.testify_wield_weapon = function (arg_81_0, arg_81_1)
	local var_81_0 = arg_81_1.backend_id
	local var_81_1 = ScriptUnit.extension(arg_81_0._unit, "career_system"):career_name()
	local var_81_2 = "slot_" .. arg_81_1.data.slot_type

	BackendUtils.set_loadout_item(var_81_0, var_81_1, var_81_2)
	arg_81_0:create_equipment_in_slot(var_81_2, var_81_0)
end

SimpleInventoryExtension.start_weapon_fx = function (arg_82_0, arg_82_1, arg_82_2)
	local var_82_0 = arg_82_0._equipment
	local var_82_1 = var_82_0.wielded_slot
	local var_82_2 = var_82_0.slots[var_82_1]
	local var_82_3 = arg_82_0:get_item_template(var_82_2)
	local var_82_4 = var_82_3.particle_fx
	local var_82_5 = var_82_4 and var_82_4[arg_82_1]

	if var_82_5 then
		arg_82_0._weapon_fx[arg_82_1] = GearUtils.create_attached_particles(arg_82_0._world, var_82_5, var_82_0, arg_82_0._unit, arg_82_0._first_person_unit, not arg_82_0.is_bot)

		if arg_82_2 then
			local var_82_6 = var_82_2.item_data
			local var_82_7 = Managers.state.unit_storage:go_id(arg_82_0._unit)
			local var_82_8 = NetworkLookup.item_names[var_82_6.name]
			local var_82_9 = var_82_3.particle_fx_lookup[arg_82_1]

			if var_82_7 and var_82_8 and var_82_9 then
				local var_82_10 = Managers.state.network

				if arg_82_0.is_server then
					var_82_10.network_transmit:send_rpc_clients("rpc_start_weapon_fx", var_82_7, var_82_8, var_82_9)
				else
					var_82_10.network_transmit:send_rpc_server("rpc_start_weapon_fx", var_82_7, var_82_8, var_82_9)
				end
			end
		end
	end
end

SimpleInventoryExtension.stop_weapon_fx = function (arg_83_0, arg_83_1, arg_83_2)
	local var_83_0 = arg_83_0._weapon_fx[arg_83_1]

	if var_83_0 then
		arg_83_0._weapon_fx[arg_83_1] = GearUtils.destroy_attached_particles(arg_83_0._world, var_83_0)

		if arg_83_2 then
			local var_83_1 = arg_83_0._equipment
			local var_83_2 = var_83_1.wielded_slot
			local var_83_3 = var_83_1.slots[var_83_2]
			local var_83_4 = arg_83_0:get_item_template(var_83_3)
			local var_83_5 = var_83_4 and var_83_4.particle_fx

			if var_83_5 and var_83_5[arg_83_1] then
				local var_83_6 = var_83_3.item_data
				local var_83_7 = Managers.state.unit_storage:go_id(arg_83_0._unit)
				local var_83_8 = NetworkLookup.item_names[var_83_6.name]
				local var_83_9 = var_83_4.particle_fx_lookup[arg_83_1]

				if var_83_7 and var_83_8 and var_83_9 then
					local var_83_10 = Managers.state.network

					if arg_83_0.is_server then
						var_83_10.network_transmit:send_rpc_clients("rpc_stop_weapon_fx", var_83_7, var_83_8, var_83_9)
					else
						var_83_10.network_transmit:send_rpc_server("rpc_stop_weapon_fx", var_83_7, var_83_8, var_83_9)
					end
				end
			end
		end
	end
end

SimpleInventoryExtension._stop_all_weapon_fx = function (arg_84_0)
	local var_84_0 = arg_84_0._world
	local var_84_1 = arg_84_0._weapon_fx

	for iter_84_0, iter_84_1 in pairs(var_84_1) do
		GearUtils.destroy_attached_particles(var_84_0, iter_84_1)

		var_84_1[iter_84_0] = nil
	end
end

SimpleInventoryExtension.has_additional_item_slots = function (arg_85_0, arg_85_1)
	return arg_85_0._additional_items[arg_85_1] ~= nil
end

SimpleInventoryExtension.can_store_additional_item = function (arg_86_0, arg_86_1)
	local var_86_0 = arg_86_0._additional_items[arg_86_1]

	return var_86_0 and #var_86_0.items < var_86_0.max_slots
end

SimpleInventoryExtension.has_additional_items = function (arg_87_0, arg_87_1)
	local var_87_0 = arg_87_0._additional_items[arg_87_1]

	return var_87_0 and #var_87_0.items > 0
end

SimpleInventoryExtension.get_additional_items = function (arg_88_0, arg_88_1)
	local var_88_0 = arg_88_0._additional_items[arg_88_1]

	return var_88_0 and var_88_0.items
end

SimpleInventoryExtension.get_additional_items_table = function (arg_89_0)
	return arg_89_0._additional_items
end

SimpleInventoryExtension.get_total_item_count = function (arg_90_0, arg_90_1)
	local var_90_0 = 0

	if arg_90_0:get_item_data(arg_90_1) then
		var_90_0 = 1
	end

	local var_90_1 = arg_90_0:get_additional_items(arg_90_1)

	if var_90_1 then
		var_90_0 = var_90_0 + #var_90_1
	end

	return var_90_0
end

SimpleInventoryExtension.store_additional_item = function (arg_91_0, arg_91_1, arg_91_2, arg_91_3)
	if arg_91_2 and arg_91_0:can_store_additional_item(arg_91_1) then
		local var_91_0 = arg_91_0:get_additional_items(arg_91_1)

		var_91_0[#var_91_0 + 1] = arg_91_2

		if not arg_91_3 then
			arg_91_0:_resync_stored_items(arg_91_1)
		end

		return true
	end

	return false
end

SimpleInventoryExtension.remove_additional_item = function (arg_92_0, arg_92_1, arg_92_2, arg_92_3)
	local var_92_0 = arg_92_0:get_additional_items(arg_92_1)
	local var_92_1 = arg_92_0:get_additional_item_swap_id(var_92_0, SwapFromStorageType.Same, arg_92_2)

	table.remove(var_92_0, var_92_1)

	if not arg_92_3 then
		arg_92_0:_resync_stored_items(arg_92_1)
	end
end

SimpleInventoryExtension.has_droppable_item = function (arg_93_0, arg_93_1, arg_93_2)
	local var_93_0 = false
	local var_93_1 = false
	local var_93_2 = arg_93_0:get_item_data(arg_93_1)

	if var_93_2 and not var_93_2.is_not_droppable and (not arg_93_2 or arg_93_2(var_93_2)) then
		var_93_0 = true
		var_93_1 = false

		return var_93_0, var_93_1, var_93_2
	end

	local var_93_3 = arg_93_0:get_additional_items(arg_93_1)

	if var_93_3 then
		for iter_93_0 = 1, #var_93_3 do
			local var_93_4 = var_93_3[iter_93_0]

			if not var_93_4.is_not_droppable and (not arg_93_2 or arg_93_2(var_93_4)) then
				var_93_0 = true
				var_93_1 = true

				return var_93_0, var_93_1, var_93_4
			end
		end
	end

	return var_93_0, var_93_1, nil
end

SimpleInventoryExtension.get_additional_item_swap_id = function (arg_94_0, arg_94_1, arg_94_2, arg_94_3)
	local var_94_0

	if arg_94_1 then
		if arg_94_2 == SwapFromStorageType.First then
			var_94_0 = 1
		elseif arg_94_2 == SwapFromStorageType.Unique then
			for iter_94_0 = 1, #arg_94_1 do
				if arg_94_1[iter_94_0] ~= arg_94_3 then
					var_94_0 = iter_94_0

					break
				end
			end
		elseif arg_94_2 == SwapFromStorageType.Same or arg_94_2 == SwapFromStorageType.SameOrAny then
			if arg_94_2 == SwapFromStorageType.SameOrAny then
				var_94_0 = 1
			end

			for iter_94_1 = 1, #arg_94_1 do
				if arg_94_1[iter_94_1] == arg_94_3 then
					var_94_0 = iter_94_1

					break
				end
			end
		elseif arg_94_2 == SwapFromStorageType.UnwieldPrio then
			local var_94_1 = arg_94_3 and (arg_94_3.unwield_prio or 0) or -1
			local var_94_2

			for iter_94_2 = 1, #arg_94_1 do
				local var_94_3 = arg_94_1[iter_94_2].unwield_prio or 0

				if var_94_1 < var_94_3 then
					var_94_1 = var_94_3
					var_94_2 = iter_94_2
				end
			end

			return var_94_2
		elseif arg_94_2 == SwapFromStorageType.LowestUnwieldPrio then
			local var_94_4 = arg_94_3 and (arg_94_3.unwield_prio or 0) or math.huge
			local var_94_5

			for iter_94_3 = 1, #arg_94_1 do
				local var_94_6 = arg_94_1[iter_94_3].unwield_prio or 0

				if var_94_6 < var_94_4 then
					var_94_4 = var_94_6
					var_94_5 = iter_94_3
				end
			end

			return var_94_5
		end
	end

	return var_94_0
end

SimpleInventoryExtension.can_swap_from_storage = function (arg_95_0, arg_95_1, arg_95_2, arg_95_3)
	if arg_95_0:has_additional_items(arg_95_1) then
		arg_95_2 = arg_95_2 or SwapFromStorageType.First
		arg_95_3 = arg_95_3 or arg_95_0:get_item_data(arg_95_1)

		local var_95_0 = arg_95_0:get_additional_items(arg_95_1)
		local var_95_1 = arg_95_0:get_additional_item_swap_id(var_95_0, arg_95_2, arg_95_3)

		return var_95_0[var_95_1] ~= nil, var_95_1, var_95_0
	end

	return false
end

SimpleInventoryExtension.swap_equipment_from_storage = function (arg_96_0, arg_96_1, arg_96_2, arg_96_3)
	local var_96_0, var_96_1, var_96_2 = arg_96_0:can_swap_from_storage(arg_96_1, arg_96_2, arg_96_3)

	if var_96_0 then
		local var_96_3 = var_96_2[var_96_1]

		table.remove(var_96_2, var_96_1)

		local var_96_4 = arg_96_0:get_slot_data(arg_96_1)

		if var_96_4 then
			arg_96_0:store_additional_item(arg_96_1, var_96_4.item_data, true)
			arg_96_0:destroy_slot(arg_96_1)
		end

		arg_96_0:_resync_stored_items(arg_96_1)

		local var_96_5 = {
			slot_id = arg_96_1,
			item_data = var_96_3
		}

		arg_96_0:_spawn_resynced_loadout(var_96_5, true)

		return true
	end

	return false
end

local var_0_7 = {}

SimpleInventoryExtension._resync_stored_items = function (arg_97_0, arg_97_1)
	local var_97_0 = arg_97_0:get_additional_items(arg_97_1)

	if var_97_0 then
		local var_97_1 = Managers.state.unit_storage:go_id(arg_97_0._unit)

		if var_97_1 then
			local var_97_2 = Managers.state.network
			local var_97_3 = NetworkLookup.equipment_slots[arg_97_1]

			table.clear(var_0_7)

			for iter_97_0 = 1, #var_97_0 do
				local var_97_4 = var_97_0[iter_97_0]

				var_0_7[#var_0_7 + 1] = NetworkLookup.item_names[var_97_4.name]
			end

			if arg_97_0.is_server then
				var_97_2.network_transmit:send_rpc_clients("rpc_update_additional_slot", var_97_1, var_97_3, var_0_7)
			else
				var_97_2.network_transmit:send_rpc_server("rpc_update_additional_slot", var_97_1, var_97_3, var_0_7)
			end
		end
	end
end
