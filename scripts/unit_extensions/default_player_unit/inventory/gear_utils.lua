-- chunkname: @scripts/unit_extensions/default_player_unit/inventory/gear_utils.lua

GearUtils = {}

local var_0_0 = Unit.node

function GearUtils.create_equipment(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8, arg_1_9, arg_1_10, arg_1_11)
	local var_1_0
	local var_1_1
	local var_1_2
	local var_1_3
	local var_1_4
	local var_1_5
	local var_1_6
	local var_1_7
	local var_1_8 = arg_1_9 or BackendUtils.get_item_template(arg_1_2)
	local var_1_9 = arg_1_10 or BackendUtils.get_item_units(arg_1_2, nil, nil, arg_1_11)

	if var_1_9.right_hand_unit then
		var_1_0, var_1_4, var_1_1, var_1_5 = GearUtils.spawn_inventory_unit(arg_1_0, "right", var_1_8, var_1_9, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_6, arg_1_7, arg_1_8, var_1_9.material_settings_name)
	end

	if var_1_9.left_hand_unit then
		var_1_2, var_1_6, var_1_3, var_1_7 = GearUtils.spawn_inventory_unit(arg_1_0, "left", var_1_8, var_1_9, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_6, arg_1_7, arg_1_8, var_1_9.material_settings_name)
	end

	if var_1_0 then
		Unit.set_flow_variable(var_1_0, "is_bot", arg_1_5)
		Unit.set_unit_visibility(var_1_0, false)

		if var_1_4 then
			Unit.set_unit_visibility(var_1_4, false)
		end
	end

	if var_1_1 then
		Unit.set_flow_variable(var_1_1, "is_bot", arg_1_5)
		Unit.set_unit_visibility(var_1_1, false)

		if var_1_5 then
			Unit.set_unit_visibility(var_1_5, false)
		end
	end

	if var_1_2 then
		Unit.set_flow_variable(var_1_2, "is_bot", arg_1_5)
		Unit.set_unit_visibility(var_1_2, false)

		if var_1_6 then
			Unit.set_unit_visibility(var_1_6, false)
		end
	end

	if var_1_3 then
		Unit.set_flow_variable(var_1_3, "is_bot", arg_1_5)
		Unit.set_unit_visibility(var_1_3, false)

		if var_1_7 then
			Unit.set_unit_visibility(var_1_7, false)
		end
	end

	if var_1_9.is_ammo_weapon then
		local var_1_10 = var_1_9.material_settings_name or var_1_8.material_settings_name

		if var_1_10 then
			if var_1_4 then
				GearUtils.apply_material_settings(var_1_4, var_1_10)
			end

			if var_1_6 then
				GearUtils.apply_material_settings(var_1_6, var_1_10)
			end

			if arg_1_3 then
				if var_1_5 then
					GearUtils.apply_material_settings(var_1_5, var_1_10)
				end

				if var_1_7 then
					GearUtils.apply_material_settings(var_1_7, var_1_10)
				end
			end
		end
	end

	return {
		id = arg_1_1,
		item_data = arg_1_2,
		item_template = var_1_8,
		item_template_name = var_1_8.name,
		skin = var_1_9.skin,
		right_unit_3p = var_1_0,
		right_ammo_unit_3p = var_1_4,
		right_unit_1p = var_1_1,
		right_ammo_unit_1p = var_1_5,
		left_unit_3p = var_1_2,
		left_ammo_unit_3p = var_1_6,
		left_unit_1p = var_1_3,
		left_ammo_unit_1p = var_1_7,
		projectile_units_template = var_1_9.projectile_units_template,
		pickup_template_name = var_1_9.pickup_template_name,
		link_pickup_template_name = var_1_9.link_pickup_template_name,
		destroy_indexed_projectiles = var_1_8.destroy_indexed_projectiles,
		right_hand_unit_name = var_1_9.right_hand_unit,
		left_hand_unit_name = var_1_9.left_hand_unit
	}
end

function GearUtils.apply_material_settings(arg_2_0, arg_2_1)
	local var_2_0 = MaterialSettingsTemplates[arg_2_1]

	for iter_2_0, iter_2_1 in pairs(var_2_0) do
		if iter_2_1.type == "color" then
			if iter_2_1.apply_to_children then
				Unit.set_color_for_materials_in_unit_and_childs(arg_2_0, iter_2_0, Quaternion(iter_2_1.alpha, iter_2_1.r, iter_2_1.g, iter_2_1.b))
			else
				Unit.set_color_for_materials(arg_2_0, iter_2_0, Quaternion(iter_2_1.alpha, iter_2_1.r, iter_2_1.g, iter_2_1.b))
			end
		elseif iter_2_1.type == "matrix4x4" then
			local var_2_1 = Matrix4x4(iter_2_1.xx, iter_2_1.xy, iter_2_1.xz, iter_2_1.yx, iter_2_1.yy, iter_2_1.yz, iter_2_1.zx, iter_2_1.zy, iter_2_1.zz, iter_2_1.tx, iter_2_1.ty, iter_2_1.tz)

			if iter_2_1.apply_to_children then
				Unit.set_matrix4x4_for_materials_in_unit_and_childs(arg_2_0, iter_2_0, var_2_1)
			else
				Unit.set_matrix4x4_for_materials(arg_2_0, iter_2_0, var_2_1)
			end
		elseif iter_2_1.type == "scalar" then
			if iter_2_1.apply_to_children then
				Unit.set_scalar_for_materials_in_unit_and_childs(arg_2_0, iter_2_0, iter_2_1.value)
			else
				Unit.set_scalar_for_materials(arg_2_0, iter_2_0, iter_2_1.value)
			end
		elseif iter_2_1.type == "vector2" then
			if iter_2_1.apply_to_children then
				Unit.set_vector2_for_materials_in_unit_and_childs(arg_2_0, iter_2_0, Vector3(iter_2_1.x, iter_2_1.y, 0))
			else
				Unit.set_vector2_for_materials(arg_2_0, iter_2_0, Vector3(iter_2_1.x, iter_2_1.y, 0))
			end
		elseif iter_2_1.type == "vector3" then
			if iter_2_1.apply_to_children then
				Unit.set_vector3_for_materials_in_unit_and_childs(arg_2_0, iter_2_0, Vector3(iter_2_1.x, iter_2_1.y, iter_2_1.z))
			else
				Unit.set_vector3_for_materials(arg_2_0, iter_2_0, Vector3(iter_2_1.x, iter_2_1.y, iter_2_1.z))
			end
		elseif iter_2_1.type == "vector4" then
			if iter_2_1.apply_to_children then
				Unit.set_vector4_for_materials_in_unit_and_childs(arg_2_0, iter_2_0, Quaternion(iter_2_1.x, iter_2_1.y, iter_2_1.z, iter_2_1.w))
			else
				Unit.set_vector4_for_materials(arg_2_0, iter_2_0, Quaternion(iter_2_1.x, iter_2_1.y, iter_2_1.z, iter_2_1.w))
			end
		elseif iter_2_1.type == "texture" and Application.can_get("texture", iter_2_1.texture) then
			Unit.set_texture_for_materials(arg_2_0, iter_2_0, iter_2_1.texture)
		end
	end
end

function GearUtils.spawn_inventory_unit(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7, arg_3_8, arg_3_9, arg_3_10, arg_3_11)
	local var_3_0 = arg_3_2.ammo_data
	local var_3_1 = arg_3_5.name
	local var_3_2 = arg_3_2[arg_3_1 .. "_hand_attachment_node_linking"]
	local var_3_3 = arg_3_3[arg_3_1 .. "_hand_unit"]
	local var_3_4 = arg_3_3.ammo_unit
	local var_3_5 = arg_3_3.ammo_unit_3p
	local var_3_6

	if var_3_0 and var_3_0.ammo_hand == arg_3_1 and var_3_4 then
		local var_3_7 = var_3_0.ammo_unit_attachment_node_linking

		fassert(var_3_7, "ammo unit: [\"%s\"] defined in weapon without attachment node linking", var_3_4)

		var_3_6 = GearUtils._attach_ammo_unit(arg_3_0, var_3_5 or var_3_4 .. "_3p", var_3_7.third_person.wielded, arg_3_7)
	end

	local var_3_8 = var_3_2.third_person.wielded
	local var_3_9 = arg_3_5.third_person_extension_template or arg_3_2.third_person_extension_template or "weapon_unit_3p"
	local var_3_10

	if arg_3_6 then
		var_3_9 = "weapon_unit_3p"
	end

	local var_3_11 = {
		weapon_system = {
			item_template = arg_3_2,
			item_name = var_3_1,
			owner_unit = arg_3_7,
			world = arg_3_0
		}
	}
	local var_3_12 = var_3_3 .. "_3p"
	local var_3_13 = Managers.state.unit_spawner:spawn_local_unit_with_extensions(var_3_12, var_3_9, var_3_11)
	local var_3_14 = {}

	GearUtils.link(arg_3_0, var_3_8, var_3_14, arg_3_7, var_3_13)

	arg_3_11 = arg_3_11 or arg_3_2.material_settings_name

	if arg_3_11 then
		GearUtils.apply_material_settings(var_3_13, arg_3_11)
	end

	if arg_3_6 then
		local var_3_15 = var_3_2.first_person.wielded
		local var_3_16 = {
			weapon_system = {
				first_person_rig = arg_3_6,
				owner_unit = arg_3_7,
				attach_nodes = var_3_15,
				item_name = var_3_1,
				item_template = arg_3_2,
				skin_name = arg_3_3.skin
			},
			ammo_system = {
				owner_unit = arg_3_7,
				ammo_data = var_3_0,
				ammo_percent = arg_3_10,
				reload_event = arg_3_2.reload_event,
				pickup_reload_event_1p = arg_3_2.pickup_reload_event_1p,
				no_ammo_reload_event = arg_3_2.no_ammo_reload_event,
				last_reload_event = arg_3_2.reload_end_event,
				item_name = var_3_1,
				slot_name = arg_3_4
			},
			spread_system = {
				owner_unit = arg_3_7,
				item_name = var_3_1
			},
			overcharge_system = {
				ammo_percent = arg_3_10,
				owner_unit = arg_3_7,
				item_name = var_3_1
			}
		}
		local var_3_17
		local var_3_18
		local var_3_19 = var_3_0 and var_3_0.ammo_hand

		if var_3_0 then
			fassert(var_3_19, "weapon [\"%s\"] does not have an ammo hand defined in its ammo_data", var_3_1)
		end

		local var_3_20 = arg_3_2.default_spread_template

		if var_3_0 and var_3_19 == arg_3_1 then
			if var_3_4 then
				local var_3_21 = var_3_0.ammo_unit_attachment_node_linking

				fassert(var_3_21, "ammo unit: [\"%s\"] defined in weapon without attachment node linking", var_3_4)

				var_3_18 = GearUtils._attach_ammo_unit(arg_3_0, var_3_4, var_3_21.first_person.wielded, arg_3_6)
			end

			var_3_17 = var_3_20 and "weapon_unit_ammo_spread" or "weapon_unit_ammo"
		else
			var_3_17 = var_3_20 and "weapon_unit_spread" or "weapon_unit"
		end

		if arg_3_8 then
			var_3_17 = arg_3_8

			table.merge(var_3_16, arg_3_9)
		elseif arg_3_2.unit_extension_template then
			var_3_17 = arg_3_2.unit_extension_template
		end

		local var_3_22 = Managers.state.unit_spawner:spawn_local_unit_with_extensions(var_3_3, var_3_17, var_3_16)
		local var_3_23 = {}

		GearUtils.link(arg_3_0, var_3_15, var_3_23, arg_3_6, var_3_22)

		if arg_3_11 then
			GearUtils.apply_material_settings(var_3_22, arg_3_11)
		end

		return var_3_13, var_3_6, var_3_22, var_3_18
	end

	return var_3_13, var_3_6
end

function GearUtils._attach_ammo_unit(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = Managers.state.unit_spawner:spawn_local_unit(arg_4_1)
	local var_4_1 = {}

	GearUtils.link(arg_4_0, arg_4_2, var_4_1, arg_4_3, var_4_0)

	return var_4_0
end

function GearUtils.link(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	table.clear(arg_5_2)
	GearUtils.link_units(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
end

function GearUtils.link_units(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	for iter_6_0, iter_6_1 in ipairs(arg_6_1) do
		local var_6_0 = iter_6_1.source
		local var_6_1 = iter_6_1.target
		local var_6_2 = type(var_6_0) == "string" and Unit.node(arg_6_3, var_6_0) or var_6_0
		local var_6_3 = type(var_6_1) == "string" and Unit.node(arg_6_4, var_6_1) or var_6_1

		arg_6_2[#arg_6_2 + 1] = {
			unit = arg_6_4,
			i = var_6_3,
			parent = Unit.scene_graph_parent(arg_6_4, var_6_3),
			local_pose = Matrix4x4Box(Unit.local_pose(arg_6_4, var_6_3))
		}

		World.link_unit(arg_6_0, arg_6_4, var_6_3, arg_6_3, var_6_2)
	end
end

function GearUtils.unlink(arg_7_0, arg_7_1)
	World.unlink_unit(arg_7_0, arg_7_1)

	local var_7_0 = ScriptUnit.has_extension(arg_7_1, "weapon_system")

	if var_7_0 and var_7_0.unlink_damage_unit then
		var_7_0:unlink_damage_unit()
	end
end

function GearUtils.restore_scene_graph(arg_8_0)
	if arg_8_0 then
		for iter_8_0, iter_8_1 in ipairs(arg_8_0) do
			if iter_8_1.parent then
				Unit.scene_graph_link(iter_8_1.unit, iter_8_1.i, iter_8_1.parent)
				Unit.set_local_pose(iter_8_1.unit, iter_8_1.i, iter_8_1.local_pose:unbox())
			end
		end
	end
end

function GearUtils.destroy_wielded(arg_9_0, arg_9_1)
	Unit.flow_event(arg_9_1, "lua_unwield")
	GearUtils.unlink(arg_9_0, arg_9_1)
	Managers.state.unit_spawner:mark_for_deletion(arg_9_1)
end

function GearUtils.get_ammo_extension(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0 and ScriptUnit.has_extension(arg_10_0, "ammo_system")
	local var_10_1 = arg_10_1 and ScriptUnit.has_extension(arg_10_1, "ammo_system")

	return var_10_0 or var_10_1
end

function GearUtils.destroy_equipment(arg_11_0, arg_11_1)
	local var_11_0 = Managers.state.unit_spawner

	if arg_11_1.right_hand_wielded_unit_3p and Unit.alive(arg_11_1.right_hand_wielded_unit_3p) then
		GearUtils.destroy_wielded(arg_11_0, arg_11_1.right_hand_wielded_unit_3p)
	end

	if arg_11_1.right_hand_ammo_unit_3p and Unit.alive(arg_11_1.right_hand_ammo_unit_3p) then
		GearUtils.unlink(arg_11_0, arg_11_1.right_hand_ammo_unit_3p)
		var_11_0:mark_for_deletion(arg_11_1.right_hand_ammo_unit_3p)
	end

	if arg_11_1.right_hand_wielded_unit and Unit.alive(arg_11_1.right_hand_wielded_unit) then
		GearUtils.destroy_wielded(arg_11_0, arg_11_1.right_hand_wielded_unit)
	end

	if arg_11_1.right_hand_ammo_unit_1p and Unit.alive(arg_11_1.right_hand_ammo_unit_1p) then
		GearUtils.unlink(arg_11_0, arg_11_1.right_hand_ammo_unit_1p)
		var_11_0:mark_for_deletion(arg_11_1.right_hand_ammo_unit_1p)
	end

	if arg_11_1.left_hand_wielded_unit_3p and Unit.alive(arg_11_1.left_hand_wielded_unit_3p) then
		GearUtils.destroy_wielded(arg_11_0, arg_11_1.left_hand_wielded_unit_3p)
	end

	if arg_11_1.left_hand_ammo_unit_3p and Unit.alive(arg_11_1.left_hand_ammo_unit_3p) then
		GearUtils.unlink(arg_11_0, arg_11_1.left_hand_ammo_unit_3p)
		var_11_0:mark_for_deletion(arg_11_1.left_hand_ammo_unit_3p)
	end

	if arg_11_1.left_hand_wielded_unit and Unit.alive(arg_11_1.left_hand_wielded_unit) then
		GearUtils.destroy_wielded(arg_11_0, arg_11_1.left_hand_wielded_unit)
	end

	if arg_11_1.left_hand_ammo_unit_1p and Unit.alive(arg_11_1.left_hand_ammo_unit_1p) then
		GearUtils.unlink(arg_11_0, arg_11_1.left_hand_ammo_unit_1p)
		var_11_0:mark_for_deletion(arg_11_1.left_hand_ammo_unit_1p)
	end

	arg_11_1.right_hand_wielded_unit_3p = nil
	arg_11_1.right_hand_ammo_unit_3p = nil
	arg_11_1.right_hand_wielded_unit = nil
	arg_11_1.right_hand_ammo_unit_1p = nil
	arg_11_1.left_hand_wielded_unit_3p = nil
	arg_11_1.left_hand_ammo_unit_3p = nil
	arg_11_1.left_hand_wielded_unit = nil
	arg_11_1.left_hand_ammo_unit_1p = nil
end

function GearUtils.destroy_slot(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = arg_12_2.item_data
	local var_12_1 = arg_12_2.id

	fassert(arg_12_4 or var_12_1 ~= "slot_ranged" and var_12_1 ~= "slot_melee", "Trying to destroy weapon without permission")

	if var_12_0 == arg_12_3.wielded then
		GearUtils.destroy_equipment(arg_12_0, arg_12_3)
	else
		local var_12_2 = arg_12_2.right_unit_3p
		local var_12_3 = arg_12_2.right_ammo_unit_3p
		local var_12_4 = arg_12_2.right_unit_1p
		local var_12_5 = arg_12_2.right_ammo_unit_1p
		local var_12_6 = arg_12_2.left_unit_3p
		local var_12_7 = arg_12_2.left_ammo_unit_3p
		local var_12_8 = arg_12_2.left_unit_1p
		local var_12_9 = arg_12_2.left_ammo_unit_1p
		local var_12_10 = Managers.state.unit_spawner

		if var_12_2 then
			GearUtils.unlink(arg_12_0, var_12_2)
			var_12_10:mark_for_deletion(var_12_2)
		end

		if var_12_3 then
			GearUtils.unlink(arg_12_0, var_12_3)
			var_12_10:mark_for_deletion(var_12_3)
		end

		if var_12_4 then
			GearUtils.unlink(arg_12_0, var_12_4)
			var_12_10:mark_for_deletion(var_12_4)
		end

		if var_12_5 then
			GearUtils.unlink(arg_12_0, var_12_5)
			var_12_10:mark_for_deletion(var_12_5)
		end

		if var_12_6 then
			GearUtils.unlink(arg_12_0, var_12_6)
			var_12_10:mark_for_deletion(var_12_6)
		end

		if var_12_7 then
			GearUtils.unlink(arg_12_0, var_12_7)
			var_12_10:mark_for_deletion(var_12_7)
		end

		if var_12_8 then
			GearUtils.unlink(arg_12_0, var_12_8)
			var_12_10:mark_for_deletion(var_12_8)
		end

		if var_12_9 then
			GearUtils.unlink(arg_12_0, var_12_9)
			var_12_10:mark_for_deletion(var_12_9)
		end
	end

	arg_12_3.slots[var_12_1] = nil
end

local var_0_1 = {}

function GearUtils.hot_join_sync(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if Managers.state.unit_spawner:is_marked_for_deletion(arg_13_1) then
		return
	end

	local var_13_0 = arg_13_2.slots
	local var_13_1 = Managers.state.unit_storage:go_id(arg_13_1)
	local var_13_2 = PEER_ID_TO_CHANNEL[arg_13_0]

	for iter_13_0, iter_13_1 in pairs(var_13_0) do
		repeat
			local var_13_3 = InventorySettings.slots_by_name[iter_13_0]

			if var_13_3.category ~= "weapon" and var_13_3.category ~= "career_skill_weapon" and var_13_3.category ~= "enemy_weapon" and var_13_3.category ~= "level_event" then
				break
			end

			local var_13_4 = NetworkLookup.equipment_slots[iter_13_0]
			local var_13_5 = iter_13_1.item_data
			local var_13_6 = NetworkLookup.item_names[var_13_5.name]
			local var_13_7 = NetworkLookup.weapon_skins[iter_13_1.skin or "n/a"]

			RPC.rpc_add_equipment(var_13_2, var_13_1, var_13_4, var_13_6, var_13_7)
		until true
	end

	if not not Managers.state.network.profile_synchronizer:is_peer_all_synced(arg_13_0) then
		if arg_13_2.wielded then
			RPC.rpc_wield_equipment(var_13_2, var_13_1, NetworkLookup.equipment_slots[arg_13_2.wielded_slot])
		end
	else
		Crashify.print_exception("[GearUtils] Hot joining peer has not fully synced player packages and cannot safely wield equipment. This has a high risk of crashing until the wielding player wields something else.")
	end

	for iter_13_2, iter_13_3 in pairs(arg_13_3) do
		local var_13_8 = NetworkLookup.equipment_slots[iter_13_2]

		table.clear(var_0_1)

		for iter_13_4 = 1, #iter_13_3.items do
			local var_13_9 = iter_13_3.items[iter_13_4]

			var_0_1[#var_0_1 + 1] = NetworkLookup.item_names[var_13_9.name]
		end

		RPC.rpc_update_additional_slot(var_13_2, var_13_1, var_13_8, var_0_1)
	end
end

function GearUtils._setup_extension_init_data_type_impact(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0.explosive_settings

	return {
		item_template_name = arg_14_0.name,
		invisible_projectile = var_14_0.invisible_projectile,
		impact_player_take_damage = var_14_0.impact_player_take_damage,
		impact_damage = var_14_0.impact_damage,
		impact_damage_radius = var_14_0.impact_damage_radius,
		impact_damage_min_radius_with_max_damage = var_14_0.impact_damage_min_radius_with_max_damage,
		impact_effect_name = var_14_0.impact_effect_name,
		impact_sound_event = var_14_0.impact_sound_event,
		impact_area_damage_template = var_14_0.impact_area_damage_template,
		item_name = arg_14_1
	}
end

function GearUtils._setup_extension_init_data_type_dot(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.dot_settings

	return {
		item_template_name = arg_15_0.name,
		invisible_projectile = var_15_0.invisible_projectile,
		aoe_dot_player_take_damage = var_15_0.aoe_dot_player_take_damage,
		aoe_dot_life_time = var_15_0.aoe_dot_life_time,
		aoe_dot_radius = var_15_0.aoe_dot_radius,
		aoe_dot_damage = var_15_0.aoe_dot_damage,
		aoe_dot_damage_interval = var_15_0.aoe_dot_damage_interval,
		impact_sound_event = var_15_0.impact_sound_event,
		dot_effect_name = var_15_0.dot_effect_name,
		player_screen_effect_name = var_15_0.player_screen_effect_name,
		area_damage_template = var_15_0.area_damage_template,
		area_ai_random_death_template = var_15_0.area_ai_random_death_template,
		item_name = arg_15_1
	}
end

function GearUtils.create_grenade_extension_init_data(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	local var_16_0 = AiAnimUtils.position_network_scale(arg_16_3.position, true)
	local var_16_1 = AiAnimUtils.rotation_network_scale(arg_16_3.rotation, true)
	local var_16_2 = AiAnimUtils.velocity_network_scale(arg_16_3.velocity, true)
	local var_16_3 = AiAnimUtils.velocity_network_scale(arg_16_3.angular_velocity, true)
	local var_16_4 = arg_16_2.projectile_info
	local var_16_5 = arg_16_2.lookup_data
	local var_16_6 = var_16_4.life_time
	local var_16_7 = Managers.time:time("game")
	local var_16_8 = arg_16_4 or var_16_7 + var_16_6
	local var_16_9 = {
		projectile_locomotion_system = {
			owner_unit = arg_16_0,
			network_position = var_16_0,
			network_rotation = var_16_1,
			network_velocity = var_16_2,
			network_angular_velocity = var_16_3,
			use_dynamic_collision = var_16_4.use_dynamic_collision,
			collision_filter = var_16_4.collision_filter,
			item_name = arg_16_1
		},
		projectile_system = {
			owner_unit = arg_16_0,
			stop_time = var_16_8,
			item_name = arg_16_1,
			item_template_name = var_16_5.item_template_name,
			action_name = var_16_5.action_name,
			sub_action_name = var_16_5.sub_action_name
		}
	}
	local var_16_10 = WeaponUtils.get_weapon_template(var_16_5.item_template_name)

	if arg_16_2.is_impact_type then
		var_16_9.area_damage_system = GearUtils._setup_extension_init_data_type_impact(var_16_10, arg_16_1)
	else
		var_16_9.area_damage_system = GearUtils._setup_extension_init_data_type_dot(var_16_10, arg_16_1)
	end

	return var_16_9
end

function GearUtils.get_property_and_trait_buffs(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	if Managers.state.game_mode:has_activated_mutator("whiterun") then
		return arg_17_2
	end

	local var_17_0 = arg_17_0:get_item_from_id(arg_17_1)
	local var_17_1 = var_17_0 and var_17_0.properties

	if var_17_1 then
		local var_17_2 = var_17_0.rarity == "magic" and WeaveProperties.properties or WeaponProperties.properties

		for iter_17_0, iter_17_1 in pairs(var_17_1) do
			local var_17_3 = var_17_2[iter_17_0]
			local var_17_4 = var_17_3.buff_name
			local var_17_5 = var_17_3.buffer or "client"
			local var_17_6 = var_17_3.no_wield_required

			if BuffTemplates[var_17_4] then
				if arg_17_3 and var_17_6 then
					arg_17_2[var_17_5][var_17_4] = {
						variable_value = iter_17_1
					}
				elseif not arg_17_3 and not var_17_6 then
					arg_17_2[var_17_5][var_17_4] = {
						variable_value = iter_17_1
					}
				end
			end
		end
	end

	local var_17_7 = var_17_0 and var_17_0.traits

	if var_17_7 then
		local var_17_8 = var_17_0.rarity == "magic" and WeaveTraits.traits or WeaponTraits.traits

		for iter_17_2, iter_17_3 in pairs(var_17_7) do
			local var_17_9 = var_17_8[iter_17_3]
			local var_17_10 = var_17_9.buff_name
			local var_17_11 = var_17_9.buffer or "client"
			local var_17_12 = var_17_8.no_wield_required

			if BuffTemplates[var_17_10] and (arg_17_3 and var_17_12 or not arg_17_3 and not var_17_12) then
				arg_17_2[var_17_11][var_17_10] = {
					variable_value = 1
				}
			end
		end
	end

	return arg_17_2
end

local function var_0_2(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	local var_18_0

	if arg_18_0.link_target == "left_weapon" then
		var_18_0 = arg_18_4 and arg_18_1.left_hand_wielded_unit or arg_18_1.left_hand_wielded_unit_3p
	elseif arg_18_0.link_target == "right_weapon" then
		var_18_0 = arg_18_4 and arg_18_1.right_hand_wielded_unit or arg_18_1.right_hand_wielded_unit_3p
	elseif arg_18_0.link_target == "owner_3p" then
		var_18_0 = arg_18_2
	elseif arg_18_0.link_target == "owner_1p" then
		var_18_0 = arg_18_3
	end

	return var_18_0
end

local function var_0_3(arg_19_0, arg_19_1)
	return arg_19_0.link_node and var_0_0(arg_19_1, arg_19_0.link_node) or 0
end

function GearUtils.create_attached_particles(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	if not arg_20_0 or not arg_20_1 or not arg_20_2 then
		return nil
	end

	local var_20_0 = {}
	local var_20_1 = {}
	local var_20_2 = {
		stop_fx = var_20_0,
		destroy_fx = var_20_1
	}

	for iter_20_0 = 1, #arg_20_1 do
		local var_20_3 = arg_20_1[iter_20_0]

		if arg_20_5 and var_20_3.first_person or not arg_20_5 and var_20_3.third_person then
			local var_20_4 = var_0_2(var_20_3, arg_20_2, arg_20_3, arg_20_4, arg_20_5)

			if var_20_4 then
				local var_20_5 = var_0_3(var_20_3, var_20_4)
				local var_20_6 = ScriptWorld.create_particles_linked(arg_20_0, var_20_3.effect, var_20_4, var_20_5, var_20_3.orphaned_policy)

				if var_20_3.destroy_policy == "stop_spawning" then
					var_20_0[#var_20_0 + 1] = var_20_6
				else
					var_20_1[#var_20_1 + 1] = var_20_6
				end
			end
		end
	end

	return var_20_2
end

function GearUtils.destroy_attached_particles(arg_21_0, arg_21_1)
	if arg_21_1 and arg_21_0 then
		local var_21_0 = arg_21_1.destroy_fx

		if var_21_0 then
			for iter_21_0 = 1, #var_21_0 do
				World.destroy_particles(arg_21_0, var_21_0[iter_21_0])
			end
		end

		local var_21_1 = arg_21_1.stop_fx

		if var_21_1 then
			for iter_21_1 = 1, #var_21_1 do
				World.stop_spawning_particles(arg_21_0, var_21_1[iter_21_1])
			end
		end
	end

	return nil
end
