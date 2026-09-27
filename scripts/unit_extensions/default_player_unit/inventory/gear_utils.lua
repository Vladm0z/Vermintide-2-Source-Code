-- chunkname: @scripts/unit_extensions/default_player_unit/inventory/gear_utils.lua

GearUtils = {}

local node = Unit.node

GearUtils.create_equipment = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8, arg_1_9, arg_1_10, arg_1_11)
	-- function 1
	local var_1_0
	local var_1_1
	local var_1_2
	local var_1_3
	local var_1_4
	local var_1_5
	local var_1_6
	local var_1_7
	local flag = arg_1_9 or BackendUtils.get_item_template(arg_1_2)
	local flag_2 = arg_1_10 or BackendUtils.get_item_units(arg_1_2, nil, nil, arg_1_11)

	if not flag_2.right_hand_unit then
		var_1_0, var_1_4, var_1_1, var_1_5 = GearUtils.spawn_inventory_unit(arg_1_0, "right", flag, flag_2, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_6, arg_1_7, arg_1_8, flag_2.material_settings_name)
	end

	if not flag_2.left_hand_unit then
		var_1_2, var_1_6, var_1_3, var_1_7 = GearUtils.spawn_inventory_unit(arg_1_0, "left", flag, flag_2, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_6, arg_1_7, arg_1_8, flag_2.material_settings_name)
	end

	if not var_1_0 then
		Unit.set_flow_variable(var_1_0, "is_bot", arg_1_5)
		Unit.set_unit_visibility(var_1_0, false)

		if not var_1_4 then
			Unit.set_unit_visibility(var_1_4, false)
		end
	end

	if not var_1_1 then
		Unit.set_flow_variable(var_1_1, "is_bot", arg_1_5)
		Unit.set_unit_visibility(var_1_1, false)

		if not var_1_5 then
			Unit.set_unit_visibility(var_1_5, false)
		end
	end

	if not var_1_2 then
		Unit.set_flow_variable(var_1_2, "is_bot", arg_1_5)
		Unit.set_unit_visibility(var_1_2, false)

		if not var_1_6 then
			Unit.set_unit_visibility(var_1_6, false)
		end
	end

	if not var_1_3 then
		Unit.set_flow_variable(var_1_3, "is_bot", arg_1_5)
		Unit.set_unit_visibility(var_1_3, false)

		if not var_1_7 then
			Unit.set_unit_visibility(var_1_7, false)
		end
	end

	if not flag_2.is_ammo_weapon then
		local material_settings_name = flag_2.material_settings_name

		material_settings_name = material_settings_name or flag.material_settings_name

		if not material_settings_name then
			if not var_1_4 then
				GearUtils.apply_material_settings(var_1_4, material_settings_name)
			end

			if not var_1_6 then
				GearUtils.apply_material_settings(var_1_6, material_settings_name)
			end

			if not arg_1_3 then
				if not var_1_5 then
					GearUtils.apply_material_settings(var_1_5, material_settings_name)
				end

				if not var_1_7 then
					GearUtils.apply_material_settings(var_1_7, material_settings_name)
				end
			end
		end
	end

	return {
		id = arg_1_1,
		item_data = arg_1_2,
		item_template = flag,
		item_template_name = flag.name,
		skin = flag_2.skin,
		right_unit_3p = var_1_0,
		right_ammo_unit_3p = var_1_4,
		right_unit_1p = var_1_1,
		right_ammo_unit_1p = var_1_5,
		left_unit_3p = var_1_2,
		left_ammo_unit_3p = var_1_6,
		left_unit_1p = var_1_3,
		left_ammo_unit_1p = var_1_7,
		projectile_units_template = flag_2.projectile_units_template,
		pickup_template_name = flag_2.pickup_template_name,
		link_pickup_template_name = flag_2.link_pickup_template_name,
		destroy_indexed_projectiles = flag.destroy_indexed_projectiles,
		right_hand_unit_name = flag_2.right_hand_unit,
		left_hand_unit_name = flag_2.left_hand_unit
	}
end

GearUtils.apply_material_settings = function (arg_2_0, arg_2_1)
	-- function 2
	local var_2_0 = MaterialSettingsTemplates[arg_2_1]

	for k, v in pairs(var_2_0) do
		if v.type == "color" then
			if not v.apply_to_children then
				Unit.set_color_for_materials_in_unit_and_childs(arg_2_0, k, Quaternion(v.alpha, v.r, v.g, v.b))
			else
				Unit.set_color_for_materials(arg_2_0, k, Quaternion(v.alpha, v.r, v.g, v.b))
			end
		elseif v.type == "matrix4x4" then
			local var_2_1 = Matrix4x4(v.xx, v.xy, v.xz, v.yx, v.yy, v.yz, v.zx, v.zy, v.zz, v.tx, v.ty, v.tz)

			if not v.apply_to_children then
				Unit.set_matrix4x4_for_materials_in_unit_and_childs(arg_2_0, k, var_2_1)
			else
				Unit.set_matrix4x4_for_materials(arg_2_0, k, var_2_1)
			end
		elseif v.type == "scalar" then
			if not v.apply_to_children then
				Unit.set_scalar_for_materials_in_unit_and_childs(arg_2_0, k, v.value)
			else
				Unit.set_scalar_for_materials(arg_2_0, k, v.value)
			end
		elseif v.type == "vector2" then
			if not v.apply_to_children then
				Unit.set_vector2_for_materials_in_unit_and_childs(arg_2_0, k, Vector3(v.x, v.y, 0))
			else
				Unit.set_vector2_for_materials(arg_2_0, k, Vector3(v.x, v.y, 0))
			end
		elseif v.type == "vector3" then
			if not v.apply_to_children then
				Unit.set_vector3_for_materials_in_unit_and_childs(arg_2_0, k, Vector3(v.x, v.y, v.z))
			else
				Unit.set_vector3_for_materials(arg_2_0, k, Vector3(v.x, v.y, v.z))
			end
		elseif v.type == "vector4" then
			if not v.apply_to_children then
				Unit.set_vector4_for_materials_in_unit_and_childs(arg_2_0, k, Quaternion(v.x, v.y, v.z, v.w))
			else
				Unit.set_vector4_for_materials(arg_2_0, k, Quaternion(v.x, v.y, v.z, v.w))
			end
		elseif v.type ~= "texture" or not Application.can_get("texture", v.texture) then
			Unit.set_texture_for_materials(arg_2_0, k, v.texture)
		end
	end
end

GearUtils.spawn_inventory_unit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7, arg_3_8, arg_3_9, arg_3_10, arg_3_11)
	-- function 3
	local ammo_data = arg_3_2.ammo_data
	local name = arg_3_5.name
	local var_3_2 = arg_3_2[arg_3_1 .. "_hand_attachment_node_linking"]
	local var_3_3 = arg_3_3[arg_3_1 .. "_hand_unit"]
	local ammo_unit = arg_3_3.ammo_unit
	local ammo_unit_3p = arg_3_3.ammo_unit_3p
	local var_3_6

	if not ammo_data and ammo_data.ammo_hand ~= arg_3_1 or not ammo_unit then
		local ammo_unit_attachment_node_linking = ammo_data.ammo_unit_attachment_node_linking

		fassert(ammo_unit_attachment_node_linking, "ammo unit: [\"%s\"] defined in weapon without attachment node linking", ammo_unit)

		var_3_6 = GearUtils._attach_ammo_unit(arg_3_0, ammo_unit_3p or ammo_unit .. "_3p", ammo_unit_attachment_node_linking.third_person.wielded, arg_3_7)
	end

	local wielded = var_3_2.third_person.wielded
	local third_person_extension_template = arg_3_5.third_person_extension_template

	if not third_person_extension_template then
		third_person_extension_template = arg_3_2.third_person_extension_template
		third_person_extension_template = third_person_extension_template or "weapon_unit_3p"
	end

	local var_3_10

	if not arg_3_6 then
		third_person_extension_template = "weapon_unit_3p"
	end

	local tbl = {
		weapon_system = {
			item_template = arg_3_2,
			item_name = name,
			owner_unit = arg_3_7,
			world = arg_3_0
		}
	}
	local str = var_3_3 .. "_3p"
	local spawn_local_unit_with_extensions = Managers.state.unit_spawner:spawn_local_unit_with_extensions(str, third_person_extension_template, tbl)
	local tbl_2 = {}

	GearUtils.link(arg_3_0, wielded, tbl_2, arg_3_7, spawn_local_unit_with_extensions)

	arg_3_11 = arg_3_11 or arg_3_2.material_settings_name

	if not arg_3_11 then
		GearUtils.apply_material_settings(spawn_local_unit_with_extensions, arg_3_11)
	end

	if not arg_3_6 then
		local wielded_2 = var_3_2.first_person.wielded
		local tbl_3 = {
			weapon_system = {
				first_person_rig = arg_3_6,
				owner_unit = arg_3_7,
				attach_nodes = wielded_2,
				item_name = name,
				item_template = arg_3_2,
				skin_name = arg_3_3.skin
			},
			ammo_system = {
				owner_unit = arg_3_7,
				ammo_data = ammo_data,
				ammo_percent = arg_3_10,
				reload_event = arg_3_2.reload_event,
				pickup_reload_event_1p = arg_3_2.pickup_reload_event_1p,
				no_ammo_reload_event = arg_3_2.no_ammo_reload_event,
				last_reload_event = arg_3_2.reload_end_event,
				item_name = name,
				slot_name = arg_3_4
			},
			spread_system = {
				owner_unit = arg_3_7,
				item_name = name
			},
			overcharge_system = {
				ammo_percent = arg_3_10,
				owner_unit = arg_3_7,
				item_name = name
			}
		}
		local var_3_17
		local var_3_18
		local flag = not ammo_data and ammo_data.ammo_hand

		if not ammo_data then
			fassert(flag, "weapon [\"%s\"] does not have an ammo hand defined in its ammo_data", name)
		end

		local default_spread_template = arg_3_2.default_spread_template

		if not (not ammo_data and flag ~= arg_3_1) then
			if not ammo_unit then
				local ammo_unit_attachment_node_linking_2 = ammo_data.ammo_unit_attachment_node_linking

				fassert(ammo_unit_attachment_node_linking_2, "ammo unit: [\"%s\"] defined in weapon without attachment node linking", ammo_unit)

				var_3_18 = GearUtils._attach_ammo_unit(arg_3_0, ammo_unit, ammo_unit_attachment_node_linking_2.first_person.wielded, arg_3_6)
			end

			var_3_17 = not default_spread_template and "weapon_unit_ammo_spread" and "weapon_unit_ammo"
		else
			var_3_17 = not default_spread_template and "weapon_unit_spread" and "weapon_unit"
		end

		if not arg_3_8 then
			var_3_17 = arg_3_8

			table.merge(tbl_3, arg_3_9)
		elseif not arg_3_2.unit_extension_template then
			var_3_17 = arg_3_2.unit_extension_template
		end

		local spawn_local_unit_with_extensions_2 = Managers.state.unit_spawner:spawn_local_unit_with_extensions(var_3_3, var_3_17, tbl_3)
		local tbl_4 = {}

		GearUtils.link(arg_3_0, wielded_2, tbl_4, arg_3_6, spawn_local_unit_with_extensions_2)

		if not arg_3_11 then
			GearUtils.apply_material_settings(spawn_local_unit_with_extensions_2, arg_3_11)
		end

		return spawn_local_unit_with_extensions, var_3_6, spawn_local_unit_with_extensions_2, var_3_18
	end

	return spawn_local_unit_with_extensions, var_3_6
end

GearUtils._attach_ammo_unit = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local spawn_local_unit = Managers.state.unit_spawner:spawn_local_unit(arg_4_1)
	local tbl = {}

	GearUtils.link(arg_4_0, arg_4_2, tbl, arg_4_3, spawn_local_unit)

	return spawn_local_unit
end

GearUtils.link = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	table.clear(arg_5_2)
	GearUtils.link_units(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
end

GearUtils.link_units = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	for i, v in ipairs(arg_6_1) do
		local source = v.source
		local target = v.target
		local node

		if type(source) == "string" then
			node = Unit.node(arg_6_3, source)

			if not node then
				-- Nothing
			end
		end

		node = source

		do
			local node_2
		end

		::label_6_0::

		if type(target) == "string" then
			node_2 = Unit.node(arg_6_4, target)

			if not node_2 then
				-- Nothing
			end
		end

		node_2 = target

		::label_6_1::

		arg_6_2[#arg_6_2 + 1] = {
			unit = arg_6_4,
			i = node_2,
			parent = Unit.scene_graph_parent(arg_6_4, node_2),
			local_pose = Matrix4x4Box(Unit.local_pose(arg_6_4, node_2))
		}

		World.link_unit(arg_6_0, arg_6_4, node_2, arg_6_3, node)
	end
end

GearUtils.unlink = function (arg_7_0, arg_7_1)
	-- function 7
	World.unlink_unit(arg_7_0, arg_7_1)

	local has_extension = ScriptUnit.has_extension(arg_7_1, "weapon_system")

	if not has_extension and not has_extension.unlink_damage_unit then
		has_extension:unlink_damage_unit()
	end
end

GearUtils.restore_scene_graph = function (arg_8_0)
	-- function 8
	if not arg_8_0 then
		for i, v in ipairs(arg_8_0) do
			if not v.parent then
				Unit.scene_graph_link(v.unit, v.i, v.parent)
				Unit.set_local_pose(v.unit, v.i, v.local_pose:unbox())
			end
		end
	end
end

GearUtils.destroy_wielded = function (arg_9_0, arg_9_1)
	-- function 9
	Unit.flow_event(arg_9_1, "lua_unwield")
	GearUtils.unlink(arg_9_0, arg_9_1)
	Managers.state.unit_spawner:mark_for_deletion(arg_9_1)
end

GearUtils.get_ammo_extension = function (arg_10_0, arg_10_1)
	-- function 10
	local flag = not arg_10_0 and ScriptUnit.has_extension(arg_10_0, "ammo_system")
	local flag_2 = not arg_10_1 and ScriptUnit.has_extension(arg_10_1, "ammo_system")

	return flag or flag_2
end

GearUtils.destroy_equipment = function (arg_11_0, arg_11_1)
	-- function 11
	local unit_spawner = Managers.state.unit_spawner

	if not arg_11_1.right_hand_wielded_unit_3p and not Unit.alive(arg_11_1.right_hand_wielded_unit_3p) then
		GearUtils.destroy_wielded(arg_11_0, arg_11_1.right_hand_wielded_unit_3p)
	end

	if not arg_11_1.right_hand_ammo_unit_3p and not Unit.alive(arg_11_1.right_hand_ammo_unit_3p) then
		GearUtils.unlink(arg_11_0, arg_11_1.right_hand_ammo_unit_3p)
		unit_spawner:mark_for_deletion(arg_11_1.right_hand_ammo_unit_3p)
	end

	if not arg_11_1.right_hand_wielded_unit and not Unit.alive(arg_11_1.right_hand_wielded_unit) then
		GearUtils.destroy_wielded(arg_11_0, arg_11_1.right_hand_wielded_unit)
	end

	if not arg_11_1.right_hand_ammo_unit_1p and not Unit.alive(arg_11_1.right_hand_ammo_unit_1p) then
		GearUtils.unlink(arg_11_0, arg_11_1.right_hand_ammo_unit_1p)
		unit_spawner:mark_for_deletion(arg_11_1.right_hand_ammo_unit_1p)
	end

	if not arg_11_1.left_hand_wielded_unit_3p and not Unit.alive(arg_11_1.left_hand_wielded_unit_3p) then
		GearUtils.destroy_wielded(arg_11_0, arg_11_1.left_hand_wielded_unit_3p)
	end

	if not arg_11_1.left_hand_ammo_unit_3p and not Unit.alive(arg_11_1.left_hand_ammo_unit_3p) then
		GearUtils.unlink(arg_11_0, arg_11_1.left_hand_ammo_unit_3p)
		unit_spawner:mark_for_deletion(arg_11_1.left_hand_ammo_unit_3p)
	end

	if not arg_11_1.left_hand_wielded_unit and not Unit.alive(arg_11_1.left_hand_wielded_unit) then
		GearUtils.destroy_wielded(arg_11_0, arg_11_1.left_hand_wielded_unit)
	end

	if not arg_11_1.left_hand_ammo_unit_1p and not Unit.alive(arg_11_1.left_hand_ammo_unit_1p) then
		GearUtils.unlink(arg_11_0, arg_11_1.left_hand_ammo_unit_1p)
		unit_spawner:mark_for_deletion(arg_11_1.left_hand_ammo_unit_1p)
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

GearUtils.destroy_slot = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	-- function 12
	local item_data = arg_12_2.item_data
	local id = arg_12_2.id

	fassert(arg_12_4 or id == "slot_ranged" or id ~= "slot_melee", "Trying to destroy weapon without permission")

	if item_data == arg_12_3.wielded then
		GearUtils.destroy_equipment(arg_12_0, arg_12_3)
	else
		local right_unit_3p = arg_12_2.right_unit_3p
		local right_ammo_unit_3p = arg_12_2.right_ammo_unit_3p
		local right_unit_1p = arg_12_2.right_unit_1p
		local right_ammo_unit_1p = arg_12_2.right_ammo_unit_1p
		local left_unit_3p = arg_12_2.left_unit_3p
		local left_ammo_unit_3p = arg_12_2.left_ammo_unit_3p
		local left_unit_1p = arg_12_2.left_unit_1p
		local left_ammo_unit_1p = arg_12_2.left_ammo_unit_1p
		local unit_spawner = Managers.state.unit_spawner

		if not right_unit_3p then
			GearUtils.unlink(arg_12_0, right_unit_3p)
			unit_spawner:mark_for_deletion(right_unit_3p)
		end

		if not right_ammo_unit_3p then
			GearUtils.unlink(arg_12_0, right_ammo_unit_3p)
			unit_spawner:mark_for_deletion(right_ammo_unit_3p)
		end

		if not right_unit_1p then
			GearUtils.unlink(arg_12_0, right_unit_1p)
			unit_spawner:mark_for_deletion(right_unit_1p)
		end

		if not right_ammo_unit_1p then
			GearUtils.unlink(arg_12_0, right_ammo_unit_1p)
			unit_spawner:mark_for_deletion(right_ammo_unit_1p)
		end

		if not left_unit_3p then
			GearUtils.unlink(arg_12_0, left_unit_3p)
			unit_spawner:mark_for_deletion(left_unit_3p)
		end

		if not left_ammo_unit_3p then
			GearUtils.unlink(arg_12_0, left_ammo_unit_3p)
			unit_spawner:mark_for_deletion(left_ammo_unit_3p)
		end

		if not left_unit_1p then
			GearUtils.unlink(arg_12_0, left_unit_1p)
			unit_spawner:mark_for_deletion(left_unit_1p)
		end

		if not left_ammo_unit_1p then
			GearUtils.unlink(arg_12_0, left_ammo_unit_1p)
			unit_spawner:mark_for_deletion(left_ammo_unit_1p)
		end
	end

	arg_12_3.slots[id] = nil
end

local tbl = {}

GearUtils.hot_join_sync = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	if not Managers.state.unit_spawner:is_marked_for_deletion(arg_13_1) then
		return
	end

	local slots = arg_13_2.slots
	local go_id = Managers.state.unit_storage:go_id(arg_13_1)
	local var_13_2 = PEER_ID_TO_CHANNEL[arg_13_0]

	for k, v in pairs(slots) do
		repeat
			local var_13_3 = InventorySettings.slots_by_name[k]

			if not (var_13_3.category == "weapon" or var_13_3.category == "career_skill_weapon" or var_13_3.category == "enemy_weapon" or var_13_3.category == "level_event") then
				break
			end

			local var_13_4 = NetworkLookup.equipment_slots[k]
			local item_data = v.item_data
			local var_13_6 = NetworkLookup.item_names[item_data.name]
			local weapon_skins = NetworkLookup.weapon_skins
			local skin = v.skin

			skin = skin or "n/a"

			local var_13_9 = weapon_skins[skin]

			RPC.rpc_add_equipment(var_13_2, go_id, var_13_4, var_13_6, var_13_9)
		until true
	end

	if not not Managers.state.network.profile_synchronizer:is_peer_all_synced(arg_13_0) then
		if not arg_13_2.wielded then
			RPC.rpc_wield_equipment(var_13_2, go_id, NetworkLookup.equipment_slots[arg_13_2.wielded_slot])
		end
	else
		Crashify.print_exception("[GearUtils] Hot joining peer has not fully synced player packages and cannot safely wield equipment. This has a high risk of crashing until the wielding player wields something else.")
	end

	for k_2, v_2 in pairs(arg_13_3) do
		local var_13_10 = NetworkLookup.equipment_slots[k_2]

		table.clear(tbl)

		for i4 = 1, #v_2.items do
			local var_13_11 = v_2.items[i4]

			tbl[#tbl + 1] = NetworkLookup.item_names[var_13_11.name]
		end

		RPC.rpc_update_additional_slot(var_13_2, go_id, var_13_10, tbl)
	end
end

GearUtils._setup_extension_init_data_type_impact = function (self, arg_14_1)
	-- function 14
	local explosive_settings = self.explosive_settings

	return {
		item_template_name = self.name,
		invisible_projectile = explosive_settings.invisible_projectile,
		impact_player_take_damage = explosive_settings.impact_player_take_damage,
		impact_damage = explosive_settings.impact_damage,
		impact_damage_radius = explosive_settings.impact_damage_radius,
		impact_damage_min_radius_with_max_damage = explosive_settings.impact_damage_min_radius_with_max_damage,
		impact_effect_name = explosive_settings.impact_effect_name,
		impact_sound_event = explosive_settings.impact_sound_event,
		impact_area_damage_template = explosive_settings.impact_area_damage_template,
		item_name = arg_14_1
	}
end

GearUtils._setup_extension_init_data_type_dot = function (self, arg_15_1)
	-- function 15
	local dot_settings = self.dot_settings

	return {
		item_template_name = self.name,
		invisible_projectile = dot_settings.invisible_projectile,
		aoe_dot_player_take_damage = dot_settings.aoe_dot_player_take_damage,
		aoe_dot_life_time = dot_settings.aoe_dot_life_time,
		aoe_dot_radius = dot_settings.aoe_dot_radius,
		aoe_dot_damage = dot_settings.aoe_dot_damage,
		aoe_dot_damage_interval = dot_settings.aoe_dot_damage_interval,
		impact_sound_event = dot_settings.impact_sound_event,
		dot_effect_name = dot_settings.dot_effect_name,
		player_screen_effect_name = dot_settings.player_screen_effect_name,
		area_damage_template = dot_settings.area_damage_template,
		area_ai_random_death_template = dot_settings.area_ai_random_death_template,
		item_name = arg_15_1
	}
end

GearUtils.create_grenade_extension_init_data = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	-- function 16
	local position_network_scale = AiAnimUtils.position_network_scale(arg_16_3.position, true)
	local rotation_network_scale = AiAnimUtils.rotation_network_scale(arg_16_3.rotation, true)
	local velocity_network_scale = AiAnimUtils.velocity_network_scale(arg_16_3.velocity, true)
	local velocity_network_scale_2 = AiAnimUtils.velocity_network_scale(arg_16_3.angular_velocity, true)
	local projectile_info = arg_16_2.projectile_info
	local lookup_data = arg_16_2.lookup_data
	local life_time = projectile_info.life_time
	local time = Managers.time:time("game")
	local flag = arg_16_4 or time + life_time
	local tbl = {
		projectile_locomotion_system = {
			owner_unit = arg_16_0,
			network_position = position_network_scale,
			network_rotation = rotation_network_scale,
			network_velocity = velocity_network_scale,
			network_angular_velocity = velocity_network_scale_2,
			use_dynamic_collision = projectile_info.use_dynamic_collision,
			collision_filter = projectile_info.collision_filter,
			item_name = arg_16_1
		},
		projectile_system = {
			owner_unit = arg_16_0,
			stop_time = flag,
			item_name = arg_16_1,
			item_template_name = lookup_data.item_template_name,
			action_name = lookup_data.action_name,
			sub_action_name = lookup_data.sub_action_name
		}
	}
	local get_weapon_template = WeaponUtils.get_weapon_template(lookup_data.item_template_name)

	if not arg_16_2.is_impact_type then
		tbl.area_damage_system = GearUtils._setup_extension_init_data_type_impact(get_weapon_template, arg_16_1)
	else
		tbl.area_damage_system = GearUtils._setup_extension_init_data_type_dot(get_weapon_template, arg_16_1)
	end

	return tbl
end

GearUtils.get_property_and_trait_buffs = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	if not Managers.state.game_mode:has_activated_mutator("whiterun") then
		return arg_17_2
	end

	local get_item_from_id = self:get_item_from_id(arg_17_1)
	local flag = not get_item_from_id and get_item_from_id.properties

	if not flag then
		local properties

		if get_item_from_id.rarity == "magic" then
			properties = WeaveProperties.properties

			if not properties then
				-- Nothing
			end
		end

		properties = WeaponProperties.properties

		::label_17_0::

		for k, v in pairs(flag) do
			local var_17_3 = properties[k]
			local buff_name = var_17_3.buff_name
			local buffer = var_17_3.buffer

			buffer = buffer or "client"

			local no_wield_required = var_17_3.no_wield_required

			if not BuffTemplates[buff_name] then
				if not arg_17_3 and not no_wield_required then
					arg_17_2[buffer][buff_name] = {
						variable_value = v
					}
				elseif not (arg_17_3 or no_wield_required) then
					arg_17_2[buffer][buff_name] = {
						variable_value = v
					}
				end
			end
		end
	end

	local flag_2 = not get_item_from_id and get_item_from_id.traits

	if not flag_2 then
		local traits

		if get_item_from_id.rarity == "magic" then
			traits = WeaveTraits.traits

			if not traits then
				-- Nothing
			end
		end

		traits = WeaponTraits.traits

		::label_17_1::

		for k_2, v_2 in pairs(flag_2) do
			local var_17_9 = traits[v_2]
			local buff_name_2 = var_17_9.buff_name
			local buffer_2 = var_17_9.buffer

			buffer_2 = buffer_2 or "client"

			local no_wield_required_2 = traits.no_wield_required

			if not (not BuffTemplates[buff_name_2] and not arg_17_3 and no_wield_required_2 or arg_17_3 or no_wield_required_2) then
				arg_17_2[buffer_2][buff_name_2] = {
					variable_value = 1
				}
			end
		end
	end

	return arg_17_2
end

local function fn(self, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	-- function 18
	local var_18_0

	if self.link_target == "left_weapon" then
		var_18_0 = not arg_18_4 and arg_18_1.left_hand_wielded_unit and arg_18_1.left_hand_wielded_unit_3p
	elseif self.link_target == "right_weapon" then
		var_18_0 = not arg_18_4 and arg_18_1.right_hand_wielded_unit and arg_18_1.right_hand_wielded_unit_3p
	elseif self.link_target == "owner_3p" then
		var_18_0 = arg_18_2
	elseif self.link_target == "owner_1p" then
		var_18_0 = arg_18_3
	end

	return var_18_0
end

local function fn_2(self, arg_19_1)
	-- function 19
	local var_19_0

	if not self.link_node then
		var_19_0 = node(arg_19_1, self.link_node)

		if not var_19_0 then
			-- Nothing
		end
	end

	var_19_0 = 0

	::label_19_0::

	return var_19_0
end

GearUtils.create_attached_particles = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	-- function 20
	if not (not arg_20_0 and not arg_20_1 and arg_20_2) then
		return nil
	end

	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {
		stop_fx = tbl,
		destroy_fx = tbl_2
	}

	for i = 1, #arg_20_1 do
		local var_20_3 = arg_20_1[i]

		if not arg_20_5 and var_20_3.first_person and arg_20_5 or not var_20_3.third_person then
			local var_20_4 = fn(var_20_3, arg_20_2, arg_20_3, arg_20_4, arg_20_5)

			if not var_20_4 then
				local var_20_5 = fn_2(var_20_3, var_20_4)
				local create_particles_linked = ScriptWorld.create_particles_linked(arg_20_0, var_20_3.effect, var_20_4, var_20_5, var_20_3.orphaned_policy)

				if var_20_3.destroy_policy == "stop_spawning" then
					tbl[#tbl + 1] = create_particles_linked
				else
					tbl_2[#tbl_2 + 1] = create_particles_linked
				end
			end
		end
	end

	return tbl_3
end

GearUtils.destroy_attached_particles = function (arg_21_0, arg_21_1)
	-- function 21
	if not arg_21_1 and not arg_21_0 then
		local destroy_fx = arg_21_1.destroy_fx

		if not destroy_fx then
			for i = 1, #destroy_fx do
				World.destroy_particles(arg_21_0, destroy_fx[i])
			end
		end

		local stop_fx = arg_21_1.stop_fx

		if not stop_fx then
			for j = 1, #stop_fx do
				World.stop_spawning_particles(arg_21_0, stop_fx[j])
			end
		end
	end

	return nil
end
