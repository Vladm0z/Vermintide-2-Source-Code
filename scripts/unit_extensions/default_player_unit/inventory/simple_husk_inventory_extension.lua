-- chunkname: @scripts/unit_extensions/default_player_unit/inventory/simple_husk_inventory_extension.lua

SimpleHuskInventoryExtension = class(SimpleHuskInventoryExtension)

function SimpleHuskInventoryExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._world = arg_1_1.world
	arg_1_0._game_object_id = arg_1_3.id
	arg_1_0._game = arg_1_3.game
	arg_1_0._unit = arg_1_2
	arg_1_0._equipment = {
		slots = {}
	}
	arg_1_0._attached_units = {}
	arg_1_0._slot_buffs = {
		wield = {
			slot_ranged = {},
			slot_melee = {}
		},
		equip = {
			slot_melee = {},
			slot_ranged = {}
		}
	}
	arg_1_0._weapon_fx = {}
	arg_1_0.current_item_buffs = {
		wield = {},
		equip = {
			slot_melee = {},
			slot_ranged = {}
		}
	}
	arg_1_0._additional_items = {}

	local var_1_0 = arg_1_3.player

	arg_1_0._player = var_1_0

	if var_1_0 then
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
	end

	arg_1_0._show_third_person = true
end

function SimpleHuskInventoryExtension.ammo_percentage(arg_2_0)
	if GameSession.game_object_exists(arg_2_0._game, arg_2_0._game_object_id) then
		return (GameSession.game_object_field(arg_2_0._game, arg_2_0._game_object_id, "ammo_percentage"))
	end
end

function SimpleHuskInventoryExtension.ammo_status(arg_3_0)
	if GameSession.game_object_exists(arg_3_0._game, arg_3_0._game_object_id) then
		local var_3_0 = GameSession.game_object_field(arg_3_0._game, arg_3_0._game_object_id, "current_ammo")
		local var_3_1 = GameSession.game_object_field(arg_3_0._game, arg_3_0._game_object_id, "max_ammo")

		return var_3_0, var_3_1
	end
end

function SimpleHuskInventoryExtension.destroy(arg_4_0)
	if Managers.player.is_server then
		for iter_4_0, iter_4_1 in pairs(arg_4_0._equipment.slots) do
			if iter_4_1.limited_item_data then
				arg_4_0:evaluate_limited_item_state(iter_4_1)
			elseif iter_4_0 == "slot_level_event" then
				arg_4_0:drop_level_event_item(iter_4_1)
			end
		end
	end

	GearUtils.destroy_equipment(arg_4_0._world, arg_4_0._equipment)
	arg_4_0:_despawn_attached_units()
	arg_4_0:_stop_all_weapon_fx()
end

function SimpleHuskInventoryExtension.get_weapon_unit(arg_5_0)
	local var_5_0 = arg_5_0._equipment

	return var_5_0.left_hand_wielded_unit_3p or var_5_0.right_hand_wielded_unit_3p
end

function SimpleHuskInventoryExtension.get_all_weapon_unit(arg_6_0)
	local var_6_0 = arg_6_0._equipment

	return var_6_0.left_hand_wielded_unit_3p, var_6_0.right_hand_wielded_unit_3p
end

function SimpleHuskInventoryExtension.drop_level_event_item(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0:get_item_template(arg_7_1)

	if var_7_0.no_drop then
		return
	end

	local var_7_1 = var_7_0.actions.action_dropped.default
	local var_7_2 = var_7_1.projectile_info

	if var_7_2.drop_on_player_destroyed then
		local var_7_3 = arg_7_0._unit
		local var_7_4 = arg_7_0._equipment.right_hand_wielded_unit_3p or arg_7_0._equipment.left_hand_wielded_unit_3p
		local var_7_5 = Unit.world_position(var_7_3, 0) + Vector3(0, 0, 2)
		local var_7_6 = Quaternion.identity()
		local var_7_7 = Vector3(math.random(), math.random(), math.random())
		local var_7_8 = Vector3(math.random(), math.random(), math.random())
		local var_7_9 = arg_7_1.item_data.name
		local var_7_10 = "dropped"

		ActionUtils.spawn_pickup_projectile(arg_7_0._world, var_7_4, var_7_2.projectile_unit_name, var_7_2.projectile_unit_template_name, var_7_1, var_7_3, var_7_5, var_7_6, var_7_7, var_7_8, var_7_9, var_7_10)
	end

	arg_7_0:destroy_slot("slot_level_event")
end

function SimpleHuskInventoryExtension._unlink_unit(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	World.unlink_unit(arg_8_0._world, arg_8_1)

	local var_8_0 = arg_8_3.wielded or arg_8_3

	for iter_8_0, iter_8_1 in ipairs(var_8_0) do
		local var_8_1 = iter_8_1.target

		if var_8_1 ~= 0 then
			local var_8_2 = type(var_8_1) == "string" and Unit.node(arg_8_1, var_8_1) or var_8_1
			local var_8_3 = Unit.scene_graph_parent(arg_8_1, var_8_2)

			Unit.scene_graph_link(arg_8_1, var_8_2, 0)
			Unit.set_local_pose(arg_8_1, var_8_2, Matrix4x4.identity())
		end
	end

	Unit.set_flow_variable(arg_8_1, "lua_drop_reason", arg_8_2)
	Unit.set_shader_pass_flag_for_meshes_in_unit_and_childs(arg_8_1, "outline_unit", false)
	Unit.flow_event(arg_8_1, "lua_dropped")

	local var_8_4 = Unit.create_actor(arg_8_1, "rp_dropped")

	Actor.add_angular_velocity(var_8_4, Vector3(math.random(), math.random(), math.random()) * 5)
	Actor.add_velocity(var_8_4, Vector3(2 * math.random() - 0.5, 2 * math.random() - 0.5, 4.5))
end

function SimpleHuskInventoryExtension.drop_equipped_weapons(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._equipment
	local var_9_1 = var_9_0.wielded
	local var_9_2 = var_9_1.template
	local var_9_3 = AttachmentNodeLinking[var_9_2]
	local var_9_4 = var_9_1.left_hand_unit
	local var_9_5 = var_9_1.right_hand_unit

	if var_9_4 then
		local var_9_6 = var_9_3.left and var_9_3.left.third_person or var_9_3.third_person
		local var_9_7 = var_9_0.left_hand_wielded_unit_3p

		arg_9_0:_unlink_unit(var_9_7, arg_9_1, var_9_6)
	end

	if var_9_5 then
		local var_9_8 = var_9_3.right and var_9_3.right.third_person or var_9_3.third_person
		local var_9_9 = var_9_0.right_hand_wielded_unit_3p

		arg_9_0:_unlink_unit(var_9_9, arg_9_1, var_9_8)
	end
end

function SimpleHuskInventoryExtension.equipment(arg_10_0)
	return arg_10_0._equipment
end

function SimpleHuskInventoryExtension.add_equipment(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = ItemMasterList[arg_11_2]

	arg_11_0:clear_buffs_on_slot("equip", arg_11_1)
	arg_11_0:clear_buffs_on_slot("wield", arg_11_1)

	if var_11_0.slot_to_use then
		local var_11_1 = arg_11_0._equipment.slots[var_11_0.slot_to_use]
		local var_11_2
		local var_11_3

		if WeaponUtils.is_valid_weapon_override(var_11_1, var_11_0) then
			var_11_2 = var_11_1.item_data
			var_11_3 = var_11_1.skin
		else
			local var_11_4 = var_11_0.default_item_to_replace

			var_11_2 = ItemMasterList[var_11_4]
		end

		local var_11_5 = BackendUtils.get_item_units(var_11_2, nil, var_11_3, arg_11_0._career_name)

		arg_11_3 = nil

		for iter_11_0, iter_11_1 in pairs(var_11_0.item_units_to_replace) do
			var_11_0[iter_11_0] = var_11_5[iter_11_0]
		end
	end

	local var_11_6 = BackendUtils.get_item_template(var_11_0)

	arg_11_0._equipment.slots[arg_11_1] = {
		item_data = var_11_0,
		id = arg_11_1,
		skin = arg_11_3,
		item_template = var_11_6,
		item_template_name = var_11_6.name
	}
end

function SimpleHuskInventoryExtension.add_equipment_limited_item(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = ItemMasterList[arg_12_2]
	local var_12_1 = BackendUtils.get_item_template(var_12_0)

	arg_12_0._equipment.slots[arg_12_1] = {
		item_data = var_12_0,
		id = arg_12_1,
		limited_item_data = {
			spawner_unit = arg_12_3,
			id = arg_12_4
		},
		item_template_name = var_12_1.name
	}
end

function SimpleHuskInventoryExtension.destroy_item_by_name(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0:get_slot_data(arg_13_1)

	if var_13_0 and var_13_0.item_data.name == arg_13_2 then
		arg_13_0:destroy_slot(arg_13_1)
	end
end

function SimpleHuskInventoryExtension.destroy_slot(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0._equipment
	local var_14_1 = var_14_0.slots[arg_14_1]

	if var_14_1 == nil then
		return
	end

	if Managers.player.is_server and var_14_1.limited_item_data then
		arg_14_0:evaluate_limited_item_state(var_14_1)
	end

	GearUtils.destroy_slot(arg_14_0._world, arg_14_0._unit, var_14_1, var_14_0, true)
end

function SimpleHuskInventoryExtension.evaluate_limited_item_state(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_1.limited_item_data
	local var_15_1 = var_15_0.spawner_unit

	if var_15_1 then
		local var_15_2 = ScriptUnit.extension(var_15_1, "limited_item_track_system")
		local var_15_3 = var_15_0.id

		if var_15_2:is_transformed(var_15_3) then
			Managers.state.entity:system("limited_item_track_system"):held_limited_item_destroyed(var_15_1, var_15_3)
		end
	end
end

function SimpleHuskInventoryExtension._setup_equipment(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	return {
		slots = {}
	}
end

function SimpleHuskInventoryExtension.update(arg_17_0)
	return
end

local var_0_0 = {}

function SimpleHuskInventoryExtension._reapply_fade(arg_18_0, arg_18_1)
	table.clear(var_0_0)

	if arg_18_1.right_hand_wielded_unit_3p then
		var_0_0[#var_0_0 + 1] = arg_18_1.right_hand_wielded_unit_3p
	end

	if arg_18_1.right_hand_ammo_unit_3p then
		var_0_0[#var_0_0 + 1] = arg_18_1.right_hand_ammo_unit_3p
	end

	if arg_18_1.left_hand_wielded_unit_3p then
		var_0_0[#var_0_0 + 1] = arg_18_1.left_hand_wielded_unit_3p
	end

	if arg_18_1.left_hand_ammo_unit_3p then
		var_0_0[#var_0_0 + 1] = arg_18_1.left_hand_ammo_unit_3p
	end

	Managers.state.entity:system("fade_system"):new_linked_units(arg_18_0._unit, var_0_0)
end

function SimpleHuskInventoryExtension.wield(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0._equipment

	arg_19_0:_stop_all_weapon_fx()
	arg_19_0:_despawn_attached_units()
	arg_19_0:_wield_slot(arg_19_0._world, var_19_0, arg_19_1, nil, arg_19_0._unit)

	arg_19_0.wielded_slot = arg_19_1

	if arg_19_1 then
		local var_19_1 = var_19_0.slots[arg_19_1]

		if var_19_1 then
			local var_19_2 = arg_19_0:get_item_template(var_19_1)

			arg_19_0:_spawn_attached_units(var_19_2.third_person_attached_units)

			if ScriptUnit.has_extension(arg_19_0._unit, "outline_system") then
				ScriptUnit.extension(arg_19_0._unit, "outline_system"):reapply_outline()
			end

			if arg_19_1 == "slot_packmaster_claw" then
				local var_19_3 = arg_19_0:get_weapon_unit()
				local var_19_4 = ScriptUnit.extension(arg_19_0._unit, "status_system"):get_pack_master_grabber()
				local var_19_5 = Managers.player:unit_owner(var_19_4)
				local var_19_6 = CosmeticUtils.get_cosmetic_slot(var_19_5, "slot_skin")

				if var_19_6 then
					if var_19_6.item_name ~= "skaven_pack_master_skin_1001" then
						Unit.flow_event(var_19_3, "lua_wield_0000")
					else
						Unit.flow_event(var_19_3, "lua_wield_1001")
					end
				end
			end

			arg_19_0:_reapply_fade(var_19_0)

			local var_19_7 = "wield"
			local var_19_8 = arg_19_0._slot_buffs[var_19_7][arg_19_1]

			if Managers.player.is_server and var_19_8 then
				arg_19_0:_refresh_buffs(var_19_8, var_19_7, arg_19_1)
			end

			Unit.flow_event(arg_19_0._unit, "lua_wield")
			arg_19_0:start_weapon_fx("wield")
			Managers.state.event:trigger("on_weapon_wield", var_19_0)
		end
	end
end

function SimpleHuskInventoryExtension._despawn_attached_units(arg_20_0)
	local var_20_0 = arg_20_0._attached_units
	local var_20_1 = arg_20_0._world

	for iter_20_0, iter_20_1 in pairs(var_20_0) do
		Managers.state.unit_spawner:mark_for_deletion(iter_20_1)

		var_20_0[iter_20_0] = nil
	end
end

function SimpleHuskInventoryExtension._spawn_attached_units(arg_21_0, arg_21_1)
	if arg_21_1 == nil then
		return
	end

	local var_21_0 = arg_21_0._unit
	local var_21_1 = arg_21_0._world
	local var_21_2 = arg_21_0._attached_units

	for iter_21_0, iter_21_1 in pairs(arg_21_1) do
		var_21_2[iter_21_0] = AttachmentUtils.create_weapon_visual_attachment(var_21_1, var_21_0, iter_21_1.unit, iter_21_1.attachment_node_linking)
	end
end

function SimpleHuskInventoryExtension.clear_buffs_on_slot(arg_22_0, arg_22_1, arg_22_2)
	if arg_22_2 == "slot_ranged" or arg_22_2 == "slot_melee" then
		local var_22_0 = arg_22_0._slot_buffs[arg_22_1][arg_22_2]

		table.clear(var_22_0)
	end
end

function SimpleHuskInventoryExtension.set_buffs_to_slot(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	if arg_23_2 == "slot_ranged" or arg_23_2 == "slot_melee" then
		arg_23_0._slot_buffs[arg_23_1][arg_23_2] = arg_23_3

		arg_23_0:_refresh_buffs(arg_23_3, arg_23_1, arg_23_2)
	end
end

local var_0_1 = {}

function SimpleHuskInventoryExtension._refresh_buffs(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	local var_24_0 = ScriptUnit.extension(arg_24_0._unit, "buff_system")
	local var_24_1 = arg_24_0.current_item_buffs[arg_24_2]

	if arg_24_2 == "equip" then
		var_24_1 = var_24_1[arg_24_3]
	end

	for iter_24_0 = 1, #var_24_1 do
		local var_24_2 = var_24_1[iter_24_0]

		var_24_0:remove_buff(var_24_2)
	end

	table.clear(var_24_1)

	local var_24_3 = 1

	for iter_24_1, iter_24_2 in pairs(arg_24_1) do
		table.clear(var_0_1)

		for iter_24_3, iter_24_4 in pairs(iter_24_2) do
			var_0_1[iter_24_3] = iter_24_4
		end

		var_24_1[var_24_3] = var_24_0:add_buff(iter_24_1, var_0_1)
		var_24_3 = var_24_3 + 1
	end
end

function SimpleHuskInventoryExtension.has_inventory_item(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_0:get_slot_data(arg_25_1)

	if var_25_0 and arg_25_2 == var_25_0.item_data.name then
		return true
	end

	local var_25_1 = arg_25_0:get_additional_items(arg_25_1)

	if var_25_1 then
		for iter_25_0 = 1, #var_25_1 do
			if arg_25_2 == var_25_1[iter_25_0].name then
				return true
			end
		end
	end

	return false
end

function SimpleHuskInventoryExtension.show_third_person_inventory(arg_26_0, arg_26_1)
	arg_26_0._show_third_person = arg_26_1

	local var_26_0 = arg_26_0._equipment.right_hand_wielded_unit_3p

	if var_26_0 then
		if Unit.has_visibility_group(var_26_0, "normal") then
			Unit.set_visibility(var_26_0, "normal", arg_26_1)
		else
			Unit.set_unit_visibility(var_26_0, arg_26_1)
		end

		local var_26_1 = arg_26_0._equipment.right_hand_ammo_unit_3p

		if var_26_1 then
			Unit.set_unit_visibility(var_26_1, arg_26_1)
		end

		if arg_26_1 then
			Unit.flow_event(var_26_0, "lua_wield")

			if var_26_1 then
				Unit.flow_event(var_26_1, "lua_wield")
			end
		else
			Unit.flow_event(var_26_0, "lua_unwield")

			if var_26_1 then
				Unit.flow_event(var_26_1, "lua_unwield")
			end
		end
	end

	local var_26_2 = arg_26_0._equipment.left_hand_wielded_unit_3p

	if var_26_2 then
		if Unit.has_visibility_group(var_26_2, "normal") then
			Unit.set_visibility(var_26_2, "normal", arg_26_1)
		else
			Unit.set_unit_visibility(var_26_2, arg_26_1)
		end

		local var_26_3 = arg_26_0._equipment.left_hand_ammo_unit_3p

		if var_26_3 then
			Unit.set_unit_visibility(var_26_3, arg_26_1)
		end

		if arg_26_1 then
			Unit.flow_event(var_26_2, "lua_wield")

			if var_26_3 then
				Unit.flow_event(var_26_3, "lua_wield")
			end
		else
			Unit.flow_event(var_26_2, "lua_unwield")

			if var_26_3 then
				Unit.flow_event(var_26_3, "lua_unwield")
			end
		end
	end

	arg_26_0:_despawn_attached_units()

	local var_26_4 = arg_26_0._equipment
	local var_26_5 = arg_26_0.wielded_slot

	if var_26_5 then
		local var_26_6 = var_26_4.slots[var_26_5]

		if var_26_6 and arg_26_1 then
			local var_26_7 = arg_26_0:get_item_template(var_26_6)

			arg_26_0:_spawn_attached_units(var_26_7.third_person_attached_units)
		end
	end
end

function SimpleHuskInventoryExtension.get_item_template(arg_27_0, arg_27_1)
	local var_27_0 = arg_27_1.item_data

	return (BackendUtils.get_item_template(var_27_0))
end

function SimpleHuskInventoryExtension.get_wielded_slot_data(arg_28_0)
	local var_28_0 = arg_28_0:get_wielded_slot_name()

	return (arg_28_0:get_slot_data(var_28_0))
end

function SimpleHuskInventoryExtension.get_wielded_slot_item_template(arg_29_0)
	local var_29_0 = arg_29_0.wielded_slot
	local var_29_1 = arg_29_0._equipment.slots[var_29_0]

	if not var_29_1 then
		return nil
	end

	return (arg_29_0:get_item_template(var_29_1))
end

function SimpleHuskInventoryExtension.hot_join_sync(arg_30_0, arg_30_1)
	GearUtils.hot_join_sync(arg_30_1, arg_30_0._unit, arg_30_0._equipment, arg_30_0._additional_items)
end

function SimpleHuskInventoryExtension.get_wielded_slot_name(arg_31_0)
	return arg_31_0._equipment.wielded_slot
end

function SimpleHuskInventoryExtension.get_slot_data(arg_32_0, arg_32_1)
	return arg_32_0._equipment.slots[arg_32_1]
end

function SimpleHuskInventoryExtension.get_wielded_slot_data(arg_33_0)
	local var_33_0 = arg_33_0:get_wielded_slot_name()

	return (arg_33_0:get_slot_data(var_33_0))
end

function SimpleHuskInventoryExtension.set_loaded_projectile_override(arg_34_0)
	return
end

function SimpleHuskInventoryExtension._override_career_skill_item_template(arg_35_0, arg_35_1)
	local var_35_0
	local var_35_1 = arg_35_1.slot_to_use

	if var_35_1 then
		local var_35_2 = arg_35_0._equipment.slots[var_35_1]

		if WeaponUtils.is_valid_weapon_override(var_35_2, arg_35_1) then
			var_35_0 = arg_35_0:get_item_template(var_35_2)
		else
			local var_35_3 = arg_35_1.default_item_to_replace
			local var_35_4 = ItemMasterList[var_35_3]

			var_35_0 = WeaponUtils.get_weapon_template(var_35_4.template)
		end

		local var_35_5 = BackendUtils.get_item_template(arg_35_1)

		var_35_5.left_hand_attachment_node_linking = var_35_0.left_hand_attachment_node_linking
		var_35_5.right_hand_attachment_node_linking = var_35_0.right_hand_attachment_node_linking
		var_35_5.wield_anim = var_35_0.wield_anim
		var_35_5.wield_anim_no_ammo = var_35_0.wield_anim_no_ammo
		var_35_0 = var_35_5
	end

	return var_35_0
end

local function var_0_2(arg_36_0, arg_36_1, arg_36_2)
	return arg_36_1 and arg_36_1[arg_36_2] or arg_36_0
end

function SimpleHuskInventoryExtension._wield_slot(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5)
	local var_37_0 = arg_37_2.slots[arg_37_3]

	if not var_37_0 then
		print("Cannot wield item from " .. tostring(arg_37_3) .. " since this slot does not exist.")

		return
	end

	local var_37_1 = var_37_0.item_data

	if not var_37_1 then
		print("Cannot wield item from " .. tostring(arg_37_3) .. " since it is empty.")

		return
	end

	GearUtils.destroy_equipment(arg_37_1, arg_37_2)

	local var_37_2 = arg_37_0:_override_career_skill_item_template(var_37_1) or BackendUtils.get_item_template(var_37_1)
	local var_37_3 = BackendUtils.get_item_units(var_37_1, nil, var_37_0.skin, arg_37_0._career_name)
	local var_37_4
	local var_37_5
	local var_37_6
	local var_37_7
	local var_37_8
	local var_37_9
	local var_37_10
	local var_37_11

	if var_37_3.right_hand_unit then
		var_37_4, var_37_8, var_37_5, var_37_9 = GearUtils.spawn_inventory_unit(arg_37_1, "right", var_37_2, var_37_3, arg_37_3, var_37_1, arg_37_4, arg_37_5, nil, nil, nil, var_37_3.material_settings_name)
	end

	if var_37_3.left_hand_unit then
		var_37_6, var_37_10, var_37_7, var_37_11 = GearUtils.spawn_inventory_unit(arg_37_1, "left", var_37_2, var_37_3, arg_37_3, var_37_1, arg_37_4, arg_37_5, nil, nil, nil, var_37_3.material_settings_name)
	end

	if var_37_3.is_ammo_weapon then
		local var_37_12 = var_37_3.material_settings_name or var_37_2.material_settings_name

		if var_37_12 then
			if var_37_8 then
				GearUtils.apply_material_settings(var_37_8, var_37_12)
			end

			if var_37_10 then
				GearUtils.apply_material_settings(var_37_10, var_37_12)
			end

			if arg_37_4 then
				if var_37_9 then
					GearUtils.apply_material_settings(var_37_9, var_37_12)
				end

				if var_37_11 then
					GearUtils.apply_material_settings(var_37_11, var_37_12)
				end
			end
		end
	end

	local var_37_13 = ScriptUnit.extension(arg_37_5, "career_system"):career_index()

	if Unit.animation_has_variable(arg_37_5, "career_index") then
		local var_37_14 = Unit.animation_find_variable(arg_37_5, "career_index")

		Unit.animation_set_variable(arg_37_5, var_37_14, var_37_13)
	end

	local var_37_15 = BackendUtils.get_item_template(var_37_1)
	local var_37_16 = var_0_2(var_37_15.wield_anim, var_37_15.wield_anim_career, arg_37_0._career_name)
	local var_37_17 = var_0_2(var_37_15.wield_anim_3p, var_37_15.wield_anim_career_3p, arg_37_0._career_name) or var_37_16

	if var_37_4 or var_37_6 then
		if arg_37_0:ammo_percentage() == 0 and var_37_15.wield_anim_no_ammo_on_husk then
			local var_37_18 = var_0_2(var_37_15.wield_anim_no_ammo, var_37_15.wield_anim_no_ammo_career, arg_37_0._career_name)

			var_37_16 = var_37_18 or var_37_16
			var_37_17 = var_0_2(var_37_15.wield_anim_no_ammo_3p, var_37_15.wield_anim_no_ammo_career_3p, arg_37_0._career_name) or var_37_18 or var_37_17
		end

		Unit.flow_event(arg_37_5, "lua_wield")
		Unit.animation_event(arg_37_5, var_37_17)

		if var_37_4 then
			Unit.set_flow_variable(var_37_4, "owner", arg_37_5)
			Unit.flow_event(var_37_4, "lua_wield")
		end

		if var_37_6 then
			Unit.set_flow_variable(var_37_6, "owner", arg_37_5)
			Unit.flow_event(var_37_6, "lua_wield")
		end
	end

	if var_37_5 or var_37_7 then
		if Unit.animation_has_variable(arg_37_4, "animation_variation_id") then
			local var_37_19 = WeaponSkins.skins[var_37_0.skin]
			local var_37_20 = var_37_19 and var_37_19.action_anim_overrides
			local var_37_21 = var_37_20 and var_37_20.animation_variation_id or 0
			local var_37_22 = Unit.animation_find_variable(arg_37_4, "animation_variation_id")

			Unit.animation_set_variable(arg_37_4, var_37_22, var_37_21)
		end

		Unit.animation_event(arg_37_4, var_37_16)
	end

	if var_37_5 then
		Unit.set_unit_visibility(var_37_4, false)

		if var_37_9 then
			Unit.set_unit_visibility(var_37_8, false)
		end
	end

	if var_37_7 then
		Unit.set_unit_visibility(var_37_6, false)

		if var_37_11 then
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
	arg_37_2.wielded = var_37_1
	arg_37_2.wielded_slot = arg_37_3

	local var_37_23 = BLACKBOARDS[arg_37_0._unit]

	if not var_37_23.weapon_unit then
		var_37_23.weapon_unit = arg_37_0:get_weapon_unit()
	end

	return var_37_1
end

function SimpleHuskInventoryExtension.is_showing_third_person_inventory(arg_38_0)
	return arg_38_0._show_third_person
end

function SimpleHuskInventoryExtension.start_weapon_fx(arg_39_0, arg_39_1)
	local var_39_0 = arg_39_0._equipment
	local var_39_1 = var_39_0.wielded_slot
	local var_39_2 = var_39_0.slots[var_39_1]
	local var_39_3 = arg_39_0:get_item_template(var_39_2).particle_fx
	local var_39_4 = var_39_3 and var_39_3[arg_39_1]

	if var_39_4 then
		arg_39_0._weapon_fx[arg_39_1] = GearUtils.create_attached_particles(arg_39_0._world, var_39_4, var_39_0, arg_39_0._unit, nil, false)
	end
end

function SimpleHuskInventoryExtension.stop_weapon_fx(arg_40_0, arg_40_1)
	arg_40_0._weapon_fx[arg_40_1] = GearUtils.destroy_attached_particles(arg_40_0._world, arg_40_0._weapon_fx[arg_40_1])
end

function SimpleHuskInventoryExtension._stop_all_weapon_fx(arg_41_0)
	local var_41_0 = arg_41_0._world
	local var_41_1 = arg_41_0._weapon_fx

	for iter_41_0, iter_41_1 in pairs(var_41_1) do
		GearUtils.destroy_attached_particles(var_41_0, iter_41_1)

		var_41_1[iter_41_0] = nil
	end
end

function SimpleHuskInventoryExtension.has_additional_item_slots(arg_42_0, arg_42_1)
	return arg_42_0._additional_items[arg_42_1] ~= nil
end

function SimpleHuskInventoryExtension.can_store_additional_item(arg_43_0, arg_43_1)
	local var_43_0 = arg_43_0._additional_items[arg_43_1]

	return var_43_0 and #var_43_0.items < var_43_0.max_slots
end

function SimpleHuskInventoryExtension.has_additional_items(arg_44_0, arg_44_1)
	local var_44_0 = arg_44_0._additional_items[arg_44_1]

	return var_44_0 and #var_44_0.items > 0
end

function SimpleHuskInventoryExtension.get_additional_items(arg_45_0, arg_45_1)
	local var_45_0 = arg_45_0._additional_items[arg_45_1]

	return var_45_0 and var_45_0.items
end

function SimpleHuskInventoryExtension.get_additional_items_table(arg_46_0)
	return arg_46_0._additional_items
end

function SimpleHuskInventoryExtension.get_total_item_count(arg_47_0, arg_47_1)
	local var_47_0 = 0

	if arg_47_0._equipment.slots[arg_47_1] then
		var_47_0 = 1
	end

	local var_47_1 = arg_47_0:get_additional_items(arg_47_1)

	if var_47_1 then
		var_47_0 = var_47_0 + #var_47_1
	end

	return var_47_0
end

function SimpleHuskInventoryExtension.update_additional_items(arg_48_0, arg_48_1, arg_48_2)
	local var_48_0 = arg_48_0._additional_items[arg_48_1]

	if var_48_0 then
		table.clear(var_48_0.items)

		for iter_48_0 = 1, #arg_48_2 do
			local var_48_1 = arg_48_2[iter_48_0]

			var_48_0.items[#var_48_0.items + 1] = ItemMasterList[var_48_1]
		end
	end
end
