-- chunkname: @scripts/flow/flow_callbacks_foundation.lua

require("foundation/scripts/util/table")
require("scripts/settings/attachment_node_linking")
require("scripts/settings/ai_inventory_templates")

local var_0_0 = Unit.alive

function flow_query_script_data(arg_1_0)
	local var_1_0

	if arg_1_0.table then
		var_1_0 = Unit.get_data(arg_1_0.unit, arg_1_0.table, arg_1_0.scriptdata)
	else
		var_1_0 = Unit.get_data(arg_1_0.unit, arg_1_0.scriptdata)
	end

	return {
		value = var_1_0
	}
end

function flow_set_script_data(arg_2_0)
	if arg_2_0.table then
		Unit.set_data(arg_2_0.unit, arg_2_0.table, arg_2_0.scriptdata, arg_2_0.value)
	else
		Unit.set_data(arg_2_0.unit, arg_2_0.scriptdata, arg_2_0.value)
	end
end

function flow_script_data_compare_bool(arg_3_0)
	local var_3_0
	local var_3_1 = arg_3_0.reference
	local var_3_2

	if arg_3_0.table then
		local var_3_3 = split(arg_3_0.table, "/")

		table.insert(var_3_3, arg_3_0.scriptdata)

		var_3_0 = Unit.get_data(arg_3_0.unit, unpack(var_3_3))
	else
		var_3_0 = Unit.get_data(arg_3_0.unit, arg_3_0.scriptdata)
	end

	if type(var_3_0) == "boolean" then
		if var_3_0 == var_3_1 then
			var_3_2 = {
				equal = true,
				unequal = false
			}
		else
			var_3_2 = {
				equal = false,
				unequal = true
			}
		end

		return var_3_2
	end
end

function flow_script_data_compare_string(arg_4_0)
	local var_4_0
	local var_4_1 = arg_4_0.reference
	local var_4_2

	if arg_4_0.table then
		local var_4_3 = split(arg_4_0.table, "/")

		table.insert(var_4_3, arg_4_0.scriptdata)

		var_4_0 = Unit.get_data(arg_4_0.unit, unpack(var_4_3))
	else
		var_4_0 = Unit.get_data(arg_4_0.unit, arg_4_0.scriptdata)
	end

	if type(var_4_0) == "string" then
		if var_4_0 == var_4_1 then
			var_4_2 = {
				equal = true
			}
		else
			var_4_2 = {
				unequal = true
			}
		end

		return var_4_2
	end
end

function flow_script_data_compare_number(arg_5_0)
	local var_5_0
	local var_5_1 = arg_5_0.reference
	local var_5_2

	if arg_5_0.table then
		local var_5_3 = split(arg_5_0.table, "/")

		table.insert(var_5_3, arg_5_0.scriptdata)

		var_5_0 = Unit.get_data(arg_5_0.unit, unpack(var_5_3))
	else
		var_5_0 = Unit.get_data(arg_5_0.unit, arg_5_0.scriptdata)
	end

	if type(var_5_0) == "number" then
		if var_5_0 < var_5_1 then
			var_5_2 = {
				less = true
			}
		elseif var_5_0 <= var_5_1 then
			var_5_2 = {
				less_or_equal = true
			}
		elseif var_5_0 == var_5_1 then
			var_5_2 = {
				equal = true
			}
		elseif var_5_0 ~= var_5_1 then
			var_5_2 = {
				unequal = true
			}
		elseif var_5_1 <= var_5_0 then
			var_5_2 = {
				more_or_equal = true
			}
		elseif var_5_1 < var_5_0 then
			var_5_2 = {
				more = true
			}
		end

		return var_5_2
	end
end

function flow_callback_state_false(arg_6_0)
	return {
		updated = true,
		state = false
	}
end

function flow_callback_state_true(arg_7_0)
	return {
		updated = true,
		state = true
	}
end

function flow_callback_construct_vector3(arg_8_0)
	local var_8_0 = Vector3(arg_8_0.x, arg_8_0.y, arg_8_0.z)

	return {
		vector = var_8_0
	}
end

function flow_callback_store_float(arg_9_0)
	local var_9_0 = arg_9_0.invalue

	return {
		updated = true,
		state = true,
		outvalue = var_9_0
	}
end

function flow_callback_store_boolean(arg_10_0)
	local var_10_0 = arg_10_0.inbool

	return {
		updated = true,
		state = true,
		outbool = var_10_0
	}
end

function flow_callback_switchcase(arg_11_0)
	local var_11_0 = {}
	local var_11_1 = "out"

	if arg_11_0.case ~= "" then
		for iter_11_0, iter_11_1 in pairs(arg_11_0) do
			if iter_11_0 ~= "case" and arg_11_0.case == iter_11_1 then
				var_11_0[var_11_1 .. string.sub(iter_11_0, -1)] = true
			end
		end
	end

	return var_11_0
end

function flow_callback_switchcase_special(arg_12_0)
	local var_12_0 = {}
	local var_12_1 = "out"

	if arg_12_0.case ~= "" then
		for iter_12_0, iter_12_1 in pairs(arg_12_0) do
			if iter_12_0 ~= "case" then
				local var_12_2 = string.sub(iter_12_0, -1)

				if arg_12_0.case == var_12_2 then
					var_12_0[var_12_1 .. var_12_2] = true
					var_12_0.out_number = var_12_2
				end
			end
		end
	end

	return var_12_0
end

function flow_callback_set_numeric_w_out(arg_13_0)
	local var_13_0 = {}
	local var_13_1 = "out"

	if arg_13_0.case ~= "" then
		for iter_13_0, iter_13_1 in pairs(arg_13_0) do
			if iter_13_0 ~= "case" then
				local var_13_2 = string.sub(iter_13_0, -1)

				if arg_13_0.case == var_13_2 then
					var_13_0[var_13_1 .. var_13_2] = true
					var_13_0.out_number = var_13_2
				end
			end
		end
	end

	return var_13_0
end

function flow_callback_switch_event_to_number_0(arg_14_0)
	return {
		out_number = 0
	}
end

function flow_callback_switch_event_to_number_1(arg_15_0)
	return {
		out_number = 1
	}
end

function flow_callback_switch_event_to_number_2(arg_16_0)
	return {
		out_number = 2
	}
end

function flow_callback_switch_event_to_number_3(arg_17_0)
	return {
		out_number = 3
	}
end

function flow_callback_switch_event_to_number_4(arg_18_0)
	return {
		out_number = 4
	}
end

function flow_callback_switch_event_to_number_5(arg_19_0)
	return {
		out_number = 5
	}
end

function flow_callback_switch_event_to_number_6(arg_20_0)
	return {
		out_number = 6
	}
end

function flow_callback_math_addition(arg_21_0)
	local var_21_0 = arg_21_0.term_one
	local var_21_1 = arg_21_0.term_two

	return {
		value = var_21_0 + var_21_1
	}
end

function flow_callback_rotate_vector3(arg_22_0)
	local var_22_0 = arg_22_0.direction
	local var_22_1 = arg_22_0.vector3
	local var_22_2 = Quaternion.rotate(var_22_0, var_22_1)

	return {
		vector = var_22_2
	}
end

function flow_callback_look(arg_23_0)
	local var_23_0 = arg_23_0.direction
	local var_23_1 = arg_23_0.up
	local var_23_2 = Quaternion.look(var_23_0, var_23_1)

	return {
		rotation = var_23_2
	}
end

function flow_callback_math_subtraction(arg_24_0)
	local var_24_0 = arg_24_0.term_one
	local var_24_1 = arg_24_0.term_two

	return {
		value = var_24_0 - var_24_1
	}
end

function flow_callback_math_multiplication(arg_25_0)
	local var_25_0 = arg_25_0.factor_one
	local var_25_1 = arg_25_0.factor_two

	return {
		value = var_25_0 * var_25_1
	}
end

function flow_callback_math_multiplication_vector3(arg_26_0)
	local var_26_0 = arg_26_0.vector
	local var_26_1 = arg_26_0.float

	return {
		value = var_26_0 * var_26_1
	}
end

function flow_callback_math_division(arg_27_0)
	local var_27_0 = arg_27_0.dividend
	local var_27_1 = arg_27_0.divisor

	fassert(var_27_1 ~= 0, "Trying to divide by 0 in division flow node.")

	return {
		value = var_27_0 / var_27_1
	}
end

function flow_callback_math_floor(arg_28_0)
	return {
		value = math.floor(arg_28_0.float)
	}
end

function flow_callback_math_ceil(arg_29_0)
	return {
		value = math.ceil(arg_29_0.float)
	}
end

function flow_query_ghost_mode_active(arg_30_0)
	return
end

function flow_callback_set_simple_animation_speed(arg_31_0)
	Unit.set_simple_animation_speed(arg_31_0.unit, arg_31_0.speed, arg_31_0.group)
end

function flow_callback_trigger_event(arg_32_0)
	if var_0_0(arg_32_0.unit) then
		Unit.flow_event(arg_32_0.unit, arg_32_0.event)
	else
		print("WARNING: flow_callback_trigger_event - unit:", arg_32_0.unit)
	end
end

function flow_callback_set_unit_visibility(arg_33_0)
	Unit.set_visibility(arg_33_0.unit, arg_33_0.group, arg_33_0.visibility)
end

function flow_callback_distance_between(arg_34_0)
	local var_34_0 = arg_34_0.unit
	local var_34_1 = arg_34_0.node1
	local var_34_2 = arg_34_0.node2
	local var_34_3 = Unit.node(var_34_0, var_34_1)
	local var_34_4 = Unit.node(var_34_0, var_34_2)
	local var_34_5 = Unit.world_position(var_34_0, var_34_3)
	local var_34_6 = Unit.world_position(var_34_0, var_34_4)
	local var_34_7 = Vector3.distance(var_34_5, var_34_6)

	return {
		distance = var_34_7
	}
end

function flow_callback_link_objects_in_units_and_store(arg_35_0)
	local var_35_0 = arg_35_0.parent_unit
	local var_35_1 = arg_35_0.child_unit
	local var_35_2 = split(arg_35_0.parent_nodes, ";")
	local var_35_3 = split(arg_35_0.child_nodes, ";")
	local var_35_4 = Unit.world(var_35_0)
	local var_35_5 = Script.index_offset()

	for iter_35_0 = 1, #var_35_2 - 1 do
		local var_35_6 = Unit.node(var_35_0, var_35_2[iter_35_0])
		local var_35_7 = var_35_3[iter_35_0]
		local var_35_8

		if string.find(var_35_7, "Index(.)") then
			var_35_8 = tonumber(string.match(var_35_7, "%d+") + var_35_5)
		else
			var_35_8 = Unit.node(var_35_1, var_35_7)
		end

		World.link_unit(var_35_4, var_35_1, var_35_8, var_35_0, var_35_6)

		if arg_35_0.parent_lod_object and arg_35_0.child_lod_object and Unit.has_lod_object(var_35_0, arg_35_0.parent_lod_object) and Unit.has_lod_object(var_35_1, arg_35_0.child_lod_object) then
			local var_35_9 = Unit.lod_object(var_35_0, arg_35_0.parent_lod_object)
			local var_35_10 = Unit.lod_object(var_35_1, arg_35_0.child_lod_object)

			LODObject.set_bounding_volume(var_35_10, LODObject.bounding_volume(var_35_9))
			World.link_unit(var_35_4, var_35_1, LODObject.node(var_35_10), var_35_0, LODObject.node(var_35_9))
		end
	end

	local var_35_11 = Unit.get_data(var_35_0, "flow_unit_attachments") or {}

	table.insert(var_35_11, var_35_1)
	Unit.set_data(var_35_0, "flow_unit_attachments", var_35_11)

	return {
		linked = true
	}
end

function flow_callback_unlink_objects_in_units_and_remove(arg_36_0)
	local var_36_0 = arg_36_0.parent_unit
	local var_36_1 = arg_36_0.child_unit
	local var_36_2 = Unit.world(var_36_0)

	World.unlink_unit(var_36_2, var_36_1)

	local var_36_3 = Unit.get_data(var_36_0, "flow_unit_attachments") or {}
	local var_36_4 = table.find(var_36_3, var_36_1)

	if var_36_4 then
		table.remove(var_36_3, var_36_4)
	end

	Unit.set_data(var_36_0, "flow_unit_attachments", var_36_3)

	return {
		unlinked = true
	}
end

function flow_callback_attach_unit(arg_37_0)
	local var_37_0 = AttachmentNodeLinking
	local var_37_1 = split(arg_37_0.node_link_template, "/")

	if not var_37_1 then
		print("No attachment node linking defined in flow!")

		return
	end

	for iter_37_0, iter_37_1 in ipairs(var_37_1) do
		var_37_0 = var_37_0[iter_37_1]
	end

	if type(var_37_0) ~= "table" then
		print("No attachment node linking with name %s", tostring(arg_37_0.node_link_template))

		return
	end

	local var_37_2 = arg_37_0.parent_unit
	local var_37_3 = arg_37_0.child_unit
	local var_37_4 = Script.index_offset()
	local var_37_5 = Unit.world(var_37_2)

	for iter_37_2, iter_37_3 in ipairs(var_37_0) do
		local var_37_6 = iter_37_3.source
		local var_37_7 = iter_37_3.target
		local var_37_8 = type(var_37_6) == "string" and Unit.node(var_37_2, var_37_6) or var_37_6 + var_37_4
		local var_37_9 = type(var_37_7) == "string" and Unit.node(var_37_3, var_37_7) or var_37_7 + var_37_4

		World.link_unit(var_37_5, var_37_3, var_37_9, var_37_2, var_37_8)
	end

	if arg_37_0.link_lod_groups and Unit.num_lod_objects(var_37_2) ~= 0 and Unit.num_lod_objects(var_37_3) ~= 0 then
		local var_37_10 = Unit.lod_object(var_37_2, var_37_4)
		local var_37_11 = Unit.lod_object(var_37_3, var_37_4)

		LODObject.set_bounding_volume(var_37_11, LODObject.bounding_volume(var_37_10))
		World.link_unit(var_37_5, var_37_3, LODObject.node(var_37_11), var_37_2, LODObject.node(var_37_10))
	end

	if arg_37_0.store_in_parent then
		local var_37_12 = Unit.get_data(var_37_2, "flow_unit_attachments") or {}

		table.insert(var_37_12, var_37_3)
		Unit.set_data(var_37_2, "flow_unit_attachments", var_37_12)
	end

	return {
		linked = true
	}
end

function flow_callback_attach_weapon_display(arg_38_0)
	if arg_38_0.item == nil then
		return {}
	end

	local var_38_0 = arg_38_0.unit
	local var_38_1
	local var_38_2
	local var_38_3 = Unit.world(var_38_0)
	local var_38_4 = "display"
	local var_38_5 = arg_38_0.show_right_hand
	local var_38_6 = arg_38_0.show_left_hand
	local var_38_7 = arg_38_0.show_ammo

	if ItemMasterList ~= nil then
		local var_38_8 = ItemMasterList[arg_38_0.item]

		if var_38_8 ~= nil and (var_38_8.slot_type == "melee" or var_38_8.slot_type == "ranged" or var_38_8.slot_type == "weapon_skin" or var_38_8.slot_type == "potion") then
			pcall(require, "scripts/settings/equipment/weapons")
			pcall(require, "scripts/settings/equipment/weapon_skins")

			if Weapons ~= nil then
				local var_38_9 = var_38_8.template
				local var_38_10 = rawget(Weapons, var_38_9)
				local var_38_11 = rawget(WeaponSkins.skins, arg_38_0.item)
				local var_38_12 = var_38_8.display_unit or nil
				local var_38_13 = var_38_8.right_hand_unit or nil
				local var_38_14 = var_38_8.left_hand_unit or nil

				if not var_38_8.ammo_unit then
					local var_38_15
				end

				if var_38_11 ~= nil then
					if var_38_11.right_hand_unit ~= nil then
						var_38_13 = var_38_11.right_hand_unit
					end

					if var_38_11.left_hand_unit ~= nil then
						var_38_14 = var_38_11.left_hand_unit
					end

					if var_38_11.ammo_unit ~= nil then
						ammo_unit_type = var_38_11.ammo_unit
					end

					if var_38_11.display_unit ~= nil then
						var_38_12 = var_38_11.display_unit
					end
				end

				if var_38_12 ~= nil then
					local var_38_16 = Script.index_offset()
					local var_38_17 = Unit.world_position(var_38_0, 0 + var_38_16)
					local var_38_18 = Unit.world_rotation(var_38_0, 0 + var_38_16)
					local var_38_19 = World.spawn_unit(var_38_3, var_38_12, var_38_17, var_38_18)

					World.link_unit(var_38_3, var_38_19, 0 + var_38_16, var_38_0, 0 + var_38_16)

					local var_38_20 = Unit.get_data(var_38_0, "flow_item_attachments") or {}

					if var_38_5 and var_38_13 ~= nil then
						var_38_2 = attach_player_item(var_38_19, var_38_13, var_38_10.right_hand_attachment_node_linking.third_person, "display", false)

						if var_38_11 ~= nil and var_38_11.material_settings_name ~= nil then
							apply_material_settings(var_38_2, var_38_11.material_settings_name)
						end

						Unit.flow_event(var_38_2, "spawn_display")
						table.insert(var_38_20, var_38_2)
						Unit.set_data(var_38_0, "flow_item_attachments", var_38_20)
					end

					if var_38_6 and var_38_14 ~= nil then
						local var_38_21

						if var_38_14 == ammo_unit_type then
							var_38_21 = var_38_10.right_hand_attachment_node_linking.third_person
						elseif var_38_10.left_hand_attachment_node_linking ~= nil then
							var_38_21 = var_38_10.left_hand_attachment_node_linking.third_person
						end

						if var_38_21 ~= nil then
							var_38_2 = attach_player_item(var_38_19, var_38_14, var_38_21, "display", false)

							if var_38_11 ~= nil and var_38_11.material_settings_name ~= nil then
								apply_material_settings(var_38_2, var_38_11.material_settings_name)
							end

							Unit.flow_event(var_38_2, "spawn_display")
							table.insert(var_38_20, var_38_2)
							Unit.set_data(var_38_0, "flow_item_attachments", var_38_20)
						end
					end

					if var_38_7 and var_38_10.ammo_data ~= nil and var_38_10.actions.action_one.default.projectile_info ~= nil then
						local var_38_22 = ProjectileUnits

						if var_38_22[var_38_10.actions.action_one.default.projectile_info.projectile_units_template].dummy_linker_unit_name ~= nil then
							var_38_2 = attach_player_item(var_38_19, var_38_22[var_38_10.actions.action_one.default.projectile_info.projectile_units_template].dummy_linker_unit_name, var_38_10.ammo_data.ammo_unit_attachment_node_linking.third_person, "display", false)

							if var_38_11 ~= nil and var_38_11.material_settings_name ~= nil then
								apply_material_settings(var_38_2, var_38_11.material_settings_name)
							end

							Unit.flow_event(var_38_2, "spawn_display")
							table.insert(var_38_20, var_38_2)
							Unit.set_data(var_38_0, "flow_item_attachments", var_38_20)
						end
					end

					Unit.set_data(var_38_0, "flow_item_attachments", var_38_20)
				else
					print("SKIPPED PLAYER WEAPON: Missing Display definition")
				end
			else
				print("SKIPPED PLAYER WEAPON: Missing Weapons table")
			end
		end
	end

	return {
		display_unit = var_38_1,
		item_unit = var_38_2
	}
end

function flow_callback_attach_player_item(arg_39_0)
	if arg_39_0.item == nil then
		return {}
	end

	local var_39_0
	local var_39_1 = arg_39_0.unit
	local var_39_2 = Unit.world(var_39_1)
	local var_39_3 = arg_39_0.node_linking or "wielded"

	if ItemMasterList ~= nil then
		local var_39_4 = ItemMasterList[arg_39_0.item]

		if var_39_4 ~= nil then
			if arg_39_0.career_filter and not table.is_empty(var_39_4.can_wield) and not table.find(var_39_4.can_wield, arg_39_0.career_filter) then
				print("SKIPPED ITEM! Career " .. arg_39_0.career_filter .. " can't wield " .. arg_39_0.item)
				table.dump(var_39_4.can_wield)

				return
			end

			if var_39_4.slot_type == "melee" or var_39_4.slot_type == "ranged" or var_39_4.slot_type == "weapon_skin" or var_39_4.slot_type == "potion" then
				pcall(require, "scripts/settings/equipment/weapons")
				pcall(require, "scripts/settings/equipment/weapon_skins")

				if Weapons ~= nil then
					local var_39_5 = "_3p"

					if var_39_3 == "display" then
						var_39_5 = ""
					end

					local var_39_6 = var_39_4.template
					local var_39_7 = rawget(Weapons, var_39_6)
					local var_39_8 = rawget(WeaponSkins.skins, arg_39_0.item)
					local var_39_9 = var_39_4.right_hand_unit
					local var_39_10 = var_39_4.left_hand_unit
					local var_39_11 = var_39_4.ammo_unit

					if var_39_8 ~= nil then
						if var_39_9 == nil then
							var_39_9 = var_39_8.right_hand_unit or nil
						end

						if var_39_10 == nil then
							var_39_10 = var_39_8.left_hand_unit or nil
						end

						if var_39_11 == nil then
							var_39_11 = var_39_8.ammo_unit or nil
						end
					end

					if var_39_9 ~= nil then
						var_39_0 = attach_player_item(var_39_1, var_39_9 .. var_39_5, var_39_7.right_hand_attachment_node_linking.third_person, var_39_3, false)

						if var_39_8 ~= nil and var_39_8.material_settings_name ~= nil then
							apply_material_settings(var_39_0, var_39_8.material_settings_name)
						end
					end

					if var_39_10 ~= nil then
						local var_39_12

						if var_39_10 == var_39_11 then
							var_39_12 = var_39_7.right_hand_attachment_node_linking.third_person
						elseif var_39_7.left_hand_attachment_node_linking ~= nil then
							var_39_12 = var_39_7.left_hand_attachment_node_linking.third_person
						end

						if var_39_12 ~= nil then
							var_39_0 = attach_player_item(var_39_1, var_39_10 .. var_39_5, var_39_12, var_39_3, false)

							if var_39_8 ~= nil and var_39_8.material_settings_name ~= nil then
								apply_material_settings(var_39_0, var_39_8.material_settings_name)
							end
						end
					end

					if var_39_7.ammo_data ~= nil and var_39_7.actions.action_one.default.projectile_info ~= nil then
						local var_39_13 = ProjectileUnits

						if var_39_13[var_39_7.actions.action_one.default.projectile_info.projectile_units_template].dummy_linker_unit_name ~= nil then
							var_39_0 = attach_player_item(var_39_1, var_39_13[var_39_7.actions.action_one.default.projectile_info.projectile_units_template].dummy_linker_unit_name, var_39_7.ammo_data.ammo_unit_attachment_node_linking.third_person, var_39_3, false)

							if var_39_8 ~= nil and var_39_8.material_settings_name ~= nil then
								apply_material_settings(var_39_0, var_39_8.material_settings_name)
							end
						end
					end

					if Unit.has_animation_state_machine(var_39_1) and var_39_7.wield_anim ~= nil and not arg_39_0.skip_wield_anim then
						Unit.animation_event(var_39_1, var_39_7.wield_anim)
					end
				else
					print("SKIPPED PLAYER WEAPON: Missing Weapons table")
				end
			elseif var_39_4.slot_type == "hat" then
				if var_39_4.unit ~= nil then
					if Attachments ~= nil then
						local var_39_14 = Attachments[var_39_4.template]

						var_39_0 = attach_player_item(var_39_1, var_39_4.unit, var_39_14.attachment_node_linking.slot_hat, nil, true)
						equip_event = Unit.get_data(var_39_0, "equip_event") or var_39_14.show_attachments_event or nil
						material_switches = nil

						if var_39_14.character_material_changes ~= nil then
							material_switches = var_39_14.character_material_changes.third_person
						end

						if equip_event then
							Unit.flow_event(var_39_1, equip_event)
						end

						local var_39_15 = Unit.get_data(var_39_1, "flow_item_attachments") or {}

						for iter_39_0, iter_39_1 in pairs(var_39_15) do
							if equip_event then
								Unit.flow_event(iter_39_1, equip_event)
							end

							if material_switches ~= nil then
								for iter_39_2, iter_39_3 in pairs(material_switches) do
									Unit.set_material(iter_39_1, iter_39_2, iter_39_3)
								end
							end
						end

						local var_39_16 = Unit.get_data(var_39_1, "skin_events") or {}

						for iter_39_4, iter_39_5 in pairs(var_39_16) do
							Unit.flow_event(var_39_0, iter_39_5)
						end
					else
						print("SKIPPED PLAYER ATTACHMENT: Missing Attachments table")
					end
				end
			elseif var_39_4.slot_type == "skin" then
				if Cosmetics ~= nil then
					local var_39_17 = Cosmetics[arg_39_0.item]

					if var_39_3 == "display" then
						if var_39_17.first_person_attachment ~= nil then
							var_39_0 = attach_player_item(var_39_1, var_39_17.first_person_attachment.unit, var_39_17.first_person_attachment.attachment_node_linking, nil, true)

							if var_39_17.material_changes ~= nil then
								for iter_39_6, iter_39_7 in pairs(var_39_17.material_changes.first_person) do
									Unit.set_material(var_39_0, iter_39_6, iter_39_7)
								end
							end
						end
					elseif var_39_17.third_person_attachment ~= nil then
						var_39_0 = attach_player_item(var_39_1, var_39_17.third_person_attachment.unit, var_39_17.third_person_attachment.attachment_node_linking, nil, true)

						if var_39_17.material_changes ~= nil then
							for iter_39_8, iter_39_9 in pairs(var_39_17.material_changes.third_person) do
								Unit.set_material(var_39_0, iter_39_8, iter_39_9)
							end
						end

						if var_39_17.material_settings_name ~= nil then
							apply_material_settings(var_39_0, var_39_17.material_settings_name)
						end

						local var_39_18 = var_39_17.equip_skin_event or "using_skin_default"

						Unit.flow_event(var_39_1, var_39_18)

						local var_39_19 = Unit.get_data(var_39_1, "skin_events") or {}

						if var_39_17.equip_hat_event ~= nil then
							table.insert(var_39_19, var_39_17.equip_hat_event)
						else
							table.insert(var_39_19, "using_skin_default")
						end

						Unit.set_data(var_39_1, "skin_events", var_39_19)
						Unit.set_data(var_39_0, "skin_events", var_39_19)

						if Unit.has_animation_state_machine(var_39_0) and Unit.has_animation_event(var_39_0, "enable") then
							Unit.animation_event(var_39_0, "enable")
						end
					end
				else
					print("SKIPPED PLAYER COSMETICS: Missing Cosmetics table")
				end
			else
				print("SKIPPED PLAYER ITEM: Unsupported slot type " .. var_39_4.slot_type)
			end
		else
			print("SKIPPED PLAYER ITEM: Missing item " .. arg_39_0.item)
		end
	else
		print("SKIPPED PLAYER INVENTORY: Missing ItemMasterList table")
	end

	return {
		item_unit = var_39_0
	}
end

function attach_player_item(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
	local var_40_0 = Script.index_offset()

	if arg_40_3 == "unwielded" then
		arg_40_2 = arg_40_2.unwielded or arg_40_2
	elseif arg_40_3 == "display" then
		arg_40_2 = arg_40_2.display or arg_40_2
	else
		arg_40_2 = arg_40_2.wielded or arg_40_2
	end

	local var_40_1
	local var_40_2

	for iter_40_0, iter_40_1 in pairs(arg_40_2) do
		if iter_40_0 == 0 then
			local var_40_3 = type(iter_40_1) == "string" and Unit.node(arg_40_0, iter_40_1) or iter_40_1 + var_40_0

			var_40_1 = Unit.world_position(arg_40_0, var_40_3)
			var_40_2 = Unit.world_rotation(arg_40_0, var_40_3)

			break
		end
	end

	local var_40_4 = Unit.world(arg_40_0)
	local var_40_5 = World.spawn_unit(var_40_4, arg_40_1, var_40_1, var_40_2)

	for iter_40_2, iter_40_3 in ipairs(arg_40_2) do
		local var_40_6 = iter_40_3.source
		local var_40_7 = iter_40_3.target
		local var_40_8 = type(var_40_6) == "string" and Unit.node(arg_40_0, var_40_6) or var_40_6 + var_40_0
		local var_40_9 = type(var_40_7) == "string" and Unit.node(var_40_5, var_40_7) or var_40_7 + var_40_0

		World.link_unit(var_40_4, var_40_5, var_40_9, arg_40_0, var_40_8)
	end

	if arg_40_4 and Unit.num_lod_objects(arg_40_0) ~= 0 and Unit.num_lod_objects(var_40_5) ~= 0 then
		local var_40_10 = Unit.lod_object(arg_40_0, var_40_0)
		local var_40_11 = Unit.lod_object(var_40_5, var_40_0)

		LODObject.set_bounding_volume(var_40_11, LODObject.bounding_volume(var_40_10))
		World.link_unit(var_40_4, var_40_5, LODObject.node(var_40_11), arg_40_0, LODObject.node(var_40_10))
	end

	local var_40_12 = Unit.get_data(arg_40_0, "flow_item_attachments") or {}

	table.insert(var_40_12, var_40_5)
	Unit.set_data(arg_40_0, "flow_item_attachments", var_40_12)

	return var_40_5
end

function apply_material_settings(arg_41_0, arg_41_1)
	local var_41_0 = MaterialSettingsTemplates[arg_41_1]

	for iter_41_0, iter_41_1 in pairs(var_41_0) do
		if iter_41_1.type == "color" then
			if iter_41_1.apply_to_children then
				Unit.set_color_for_materials_in_unit_and_childs(arg_41_0, iter_41_0, Quaternion(iter_41_1.alpha, iter_41_1.r, iter_41_1.g, iter_41_1.b))
			else
				Unit.set_color_for_materials(arg_41_0, iter_41_0, Quaternion(iter_41_1.alpha, iter_41_1.r, iter_41_1.g, iter_41_1.b))
			end
		elseif iter_41_1.type == "matrix4x4" then
			local var_41_1 = Matrix4x4(iter_41_1.xx, iter_41_1.xy, iter_41_1.xz, iter_41_1.yx, iter_41_1.yy, iter_41_1.yz, iter_41_1.zx, iter_41_1.zy, iter_41_1.zz, iter_41_1.tx, iter_41_1.ty, iter_41_1.tz)

			if iter_41_1.apply_to_children then
				Unit.set_matrix4x4_for_materials_in_unit_and_childs(arg_41_0, iter_41_0, var_41_1)
			else
				Unit.set_matrix4x4_for_materials(arg_41_0, iter_41_0, var_41_1)
			end
		elseif iter_41_1.type == "scalar" then
			if iter_41_1.apply_to_children then
				Unit.set_scalar_for_materials_in_unit_and_childs(arg_41_0, iter_41_0, iter_41_1.value)
			else
				Unit.set_scalar_for_materials(arg_41_0, iter_41_0, iter_41_1.value)
			end
		elseif iter_41_1.type == "vector2" then
			if iter_41_1.apply_to_children then
				Unit.set_vector2_for_materials_in_unit_and_childs(arg_41_0, iter_41_0, Vector3(iter_41_1.x, iter_41_1.y, 0))
			else
				Unit.set_vector2_for_materials(arg_41_0, iter_41_0, Vector3(iter_41_1.x, iter_41_1.y, 0))
			end
		elseif iter_41_1.type == "vector3" then
			if iter_41_1.apply_to_children then
				Unit.set_vector3_for_materials_in_unit_and_childs(arg_41_0, iter_41_0, Vector3(iter_41_1.x, iter_41_1.y, iter_41_1.z))
			else
				Unit.set_vector3_for_materials(arg_41_0, iter_41_0, Vector3(iter_41_1.x, iter_41_1.y, iter_41_1.z))
			end
		elseif iter_41_1.type == "vector4" then
			if iter_41_1.apply_to_children then
				Unit.set_vector4_for_materials_in_unit_and_childs(arg_41_0, iter_41_0, Quaternion(iter_41_1.x, iter_41_1.y, iter_41_1.z, iter_41_1.w))
			else
				Unit.set_vector4_for_materials(arg_41_0, iter_41_0, Quaternion(iter_41_1.x, iter_41_1.y, iter_41_1.z, iter_41_1.w))
			end
		elseif iter_41_1.type == "texture" and Application.can_get("texture", iter_41_1.texture) then
			Unit.set_texture_for_materials(arg_41_0, iter_41_0, iter_41_1.texture)
		end
	end
end

function flow_callback_remove_player_items(arg_42_0)
	local var_42_0 = arg_42_0.unit
	local var_42_1 = Unit.world(var_42_0)
	local var_42_2 = Unit.get_data(var_42_0, "flow_item_attachments") or {}

	for iter_42_0 = 1, #var_42_2 do
		arg_42_0.unit = var_42_2[iter_42_0]

		local var_42_3 = flow_callback_remove_player_items(arg_42_0)

		World.destroy_unit(var_42_1, var_42_2[iter_42_0])
	end

	Unit.set_data(var_42_0, "flow_item_attachments", {})

	return {}
end

function flow_callback_unattach_unit(arg_43_0)
	local var_43_0 = arg_43_0.parent_unit
	local var_43_1 = arg_43_0.child_unit
	local var_43_2 = Unit.world(var_43_0)

	World.unlink_unit(var_43_2, var_43_1)

	local var_43_3 = Unit.get_data(var_43_0, "flow_unit_attachments") or {}
	local var_43_4 = table.find(var_43_3, var_43_1)

	if var_43_4 then
		table.remove(var_43_3, var_43_4)
	end

	Unit.set_data(var_43_0, "flow_unit_attachments", var_43_3)

	return {
		unlinked = true
	}
end

function flow_callback_trigger_event_on_attachments(arg_44_0)
	local var_44_0 = Unit.get_data(arg_44_0.unit, "flow_unit_attachments") or {}

	for iter_44_0 = 1, #var_44_0 do
		Unit.flow_event(var_44_0[iter_44_0], arg_44_0.event)
	end

	return {
		triggered = true
	}
end

function flow_callback_unit_spawner_spawn_local_unit(arg_45_0)
	return
end

function flow_callback_unit_spawner_mark_for_deletion(arg_46_0)
	return
end

function flow_callback_set_actor_enabled(arg_47_0)
	local var_47_0 = arg_47_0.unit

	assert(var_47_0, "Set Actor Enabled flow node is missing unit")

	local var_47_1 = arg_47_0.actor or Unit.actor(var_47_0, arg_47_0.actor_name)

	fassert(var_47_1, "Set Actor Enabled flow node referring to unit %s is missing actor %s", tostring(var_47_0), tostring(arg_47_0.actor or arg_47_0.actor_name))
	Actor.set_collision_enabled(var_47_1, arg_47_0.enabled)
	Actor.set_scene_query_enabled(var_47_1, arg_47_0.enabled)
end

function flow_callback_set_actor_kinematic(arg_48_0)
	local var_48_0 = arg_48_0.unit

	assert(var_48_0, "Set Actor Kinematic flow node is missing unit")

	local var_48_1 = arg_48_0.actor or Unit.actor(var_48_0, arg_48_0.actor_name)

	fassert(var_48_1, "Set Actor Kinematic flow node referring to unit %s is missing actor %s", tostring(var_48_0), tostring(arg_48_0.actor or arg_48_0.actor_name))
	Actor.set_kinematic(var_48_1, arg_48_0.enabled)
end

function flow_callback_spawn_actor(arg_49_0)
	local var_49_0 = arg_49_0.unit

	assert(var_49_0, "Spawn Actor flow node is missing unit")

	local var_49_1 = arg_49_0.actor_name

	Unit.create_actor(var_49_0, var_49_1)
end

function flow_callback_destroy_actor(arg_50_0)
	local var_50_0 = arg_50_0.unit

	assert(var_50_0, "Destroy Actor flow node is missing unit")

	local var_50_1 = arg_50_0.actor_name

	Unit.destroy_actor(var_50_0, var_50_1)
end

function flow_callback_set_actor_initial_velocity(arg_51_0)
	local var_51_0 = arg_51_0.unit

	assert(var_51_0, "Set actor initial velocity has no unit")
	Unit.apply_initial_actor_velocities(var_51_0, true)
end

function flow_callback_set_actor_initial_velocity(arg_52_0)
	local var_52_0 = arg_52_0.unit

	assert(var_52_0, "Set actor initial velocity has no unit")
	Unit.apply_initial_actor_velocities(var_52_0, true)
end

function flow_callback_set_unit_material_variation(arg_53_0)
	local var_53_0 = arg_53_0.unit
	local var_53_1 = arg_53_0.material_variation

	Unit.set_material_variation(var_53_0, var_53_1)
end

function flow_callback_set_material_property_scalar(arg_54_0)
	local var_54_0 = arg_54_0.unit
	local var_54_1 = arg_54_0.all_meshes
	local var_54_2 = arg_54_0.mesh
	local var_54_3 = arg_54_0.material
	local var_54_4 = arg_54_0.variable
	local var_54_5 = arg_54_0.value

	if var_54_1 then
		for iter_54_0 = 0, Unit.num_meshes(var_54_0) - 1 do
			var_54_2 = Unit.mesh(var_54_0, iter_54_0)

			if Mesh.has_material(var_54_2, var_54_3) then
				local var_54_6 = Mesh.material(var_54_2, var_54_3)

				Material.set_scalar(var_54_6, var_54_4, var_54_5)
			end
		end
	else
		local var_54_7 = Unit.mesh(var_54_0, var_54_2)
		local var_54_8 = Mesh.material(var_54_7, var_54_3)

		Material.set_scalar(var_54_8, var_54_4, var_54_5)
	end
end

function flow_callback_set_material_property_vector2(arg_55_0)
	local var_55_0 = arg_55_0.unit
	local var_55_1 = arg_55_0.all_meshes
	local var_55_2 = arg_55_0.mesh
	local var_55_3 = arg_55_0.material
	local var_55_4 = arg_55_0.variable
	local var_55_5 = Vector2(arg_55_0.value.x, arg_55_0.value.y)

	if var_55_1 then
		for iter_55_0 = 0, Unit.num_meshes(var_55_0) - 1 do
			var_55_2 = Unit.mesh(var_55_0, iter_55_0)

			if Mesh.has_material(var_55_2, var_55_3) then
				local var_55_6 = Mesh.material(var_55_2, var_55_3)

				Material.set_vector2(var_55_6, var_55_4, var_55_5)
			end
		end
	else
		local var_55_7 = Unit.mesh(var_55_0, var_55_2)
		local var_55_8 = Mesh.material(var_55_7, var_55_3)

		Material.set_vector2(var_55_8, var_55_4, var_55_5)
	end
end

function flow_callback_set_material_property_vector3(arg_56_0)
	local var_56_0 = arg_56_0.unit
	local var_56_1 = arg_56_0.all_meshes
	local var_56_2 = arg_56_0.mesh
	local var_56_3 = arg_56_0.material
	local var_56_4 = arg_56_0.variable
	local var_56_5 = arg_56_0.value

	if var_56_1 then
		for iter_56_0 = 0, Unit.num_meshes(var_56_0) - 1 do
			var_56_2 = Unit.mesh(var_56_0, iter_56_0)

			if Mesh.has_material(var_56_2, var_56_3) then
				local var_56_6 = Mesh.material(var_56_2, var_56_3)

				Material.set_vector3(var_56_6, var_56_4, var_56_5)
			end
		end
	else
		local var_56_7 = Unit.mesh(var_56_0, var_56_2)
		local var_56_8 = Mesh.material(var_56_7, var_56_3)

		Material.set_vector3(var_56_8, var_56_4, var_56_5)
	end
end

function flow_callback_set_material_property_color(arg_57_0)
	local var_57_0 = arg_57_0.unit
	local var_57_1 = arg_57_0.all_meshes
	local var_57_2 = arg_57_0.mesh
	local var_57_3 = arg_57_0.material
	local var_57_4 = arg_57_0.variable
	local var_57_5 = arg_57_0.color

	if var_57_1 then
		for iter_57_0 = 0, Unit.num_meshes(var_57_0) - 1 do
			var_57_2 = Unit.mesh(var_57_0, iter_57_0)

			if Mesh.has_material(var_57_2, var_57_3) then
				local var_57_6 = Mesh.material(var_57_2, var_57_3)

				Material.set_color(var_57_6, var_57_4, var_57_5)
			end
		end
	else
		local var_57_7 = Unit.mesh(var_57_0, var_57_2)
		local var_57_8 = Mesh.material(var_57_7, var_57_3)

		Material.set_color(var_57_8, var_57_4, var_57_5)
	end
end

function do_material_dissolve(arg_58_0, arg_58_1, arg_58_2, arg_58_3, arg_58_4)
	Material.set_scalar(arg_58_0, arg_58_3, arg_58_4)
	Material.set_vector2(arg_58_0, arg_58_1, arg_58_2)
end

function flow_callback_set_material_property_scalar_all(arg_59_0)
	local var_59_0 = arg_59_0.unit
	local var_59_1 = arg_59_0.variable
	local var_59_2 = arg_59_0.value
	local var_59_3 = Script.index_offset()
	local var_59_4 = 1 - var_59_3
	local var_59_5 = Unit.num_meshes(var_59_0)

	for iter_59_0 = var_59_3, var_59_5 - var_59_4 do
		local var_59_6 = Unit.mesh(var_59_0, iter_59_0)
		local var_59_7 = Mesh.num_materials(var_59_6)

		for iter_59_1 = var_59_3, var_59_7 - var_59_4 do
			local var_59_8 = Mesh.material(var_59_6, iter_59_1)

			Material.set_scalar(var_59_8, var_59_1, var_59_2)
		end
	end
end

function flow_callback_material_scalar_set_chr_inventory(arg_60_0)
	assert(arg_60_0.unit, "[flow_callback_material_scalar_set_chr_inventory] You need to specify the Unit")
	assert(arg_60_0.variable, "[flow_callback_material_scalar_set_chr_inventory] You need to specify variable value")
	assert(arg_60_0.value, "[flow_callback_material_scalar_set_chr_inventory] You need to specify variable name")

	local var_60_0 = arg_60_0.unit
	local var_60_1 = {}

	for iter_60_0, iter_60_1 in ipairs({
		"outfit",
		"stump",
		"helmet",
		"skin",
		"other"
	}) do
		local var_60_2 = Unit.get_data(var_60_0, iter_60_1 .. "_items") or {}

		for iter_60_2 = 1, #var_60_2 do
			arg_60_0.unit = var_60_2[iter_60_2]

			flow_callback_set_material_property_scalar_all(arg_60_0)
		end
	end
end

function flow_callback_material_dissolve(arg_61_0)
	assert(arg_61_0.unit, "[flow_callback_material_dissolve] You need to specify the Unit")
	assert(arg_61_0.duration, "[flow_callback_material_dissolve] You need to specify duration")

	local var_61_0 = arg_61_0.timer_var_name or "dissolve_timer"
	local var_61_1 = World.time(Application.main_world())
	local var_61_2 = Vector2(var_61_1, var_61_1 + arg_61_0.duration)
	local var_61_3 = arg_61_0.dissolve_start_state_var_name or "dissolve_start_value"
	local var_61_4 = math.floor(0.5 + arg_61_0.dissolve_start_state or 1)
	local var_61_5 = arg_61_0.unit
	local var_61_6 = Script.index_offset()
	local var_61_7
	local var_61_8 = arg_61_0.mesh_name

	if var_61_8 then
		fassert(Unit.has_mesh(var_61_5, var_61_8), string.format("[flow_callback_material_dissolve] The mesh %s doesn't exist in unit %s", var_61_8, tostring(var_61_5)))

		var_61_7 = Unit.mesh(var_61_5, var_61_8)
	end

	local var_61_9
	local var_61_10 = arg_61_0.material_name

	if var_61_7 and var_61_10 then
		fassert(Mesh.has_material(var_61_7, var_61_10), string.format("[flow_callback_material_dissolve] The material %s doesn't exist for mesh %s", var_61_8, var_61_10))

		var_61_9 = Mesh.material(var_61_7, var_61_10)
	end

	if var_61_7 and var_61_9 then
		do_material_dissolve(var_61_9, var_61_0, var_61_2, var_61_3, var_61_4)
	elseif var_61_7 then
		local var_61_11 = Mesh.num_materials(var_61_7)

		for iter_61_0 = 0, var_61_11 - 1 do
			do_material_dissolve(Mesh.material(var_61_7, iter_61_0 + var_61_6), var_61_0, var_61_2, var_61_3, var_61_4)
		end
	elseif var_61_10 then
		local var_61_12 = Unit.num_meshes(var_61_5)

		for iter_61_1 = 0, var_61_12 - 1 do
			local var_61_13 = Unit.mesh(var_61_5, iter_61_1 + var_61_6)

			if Mesh.has_material(var_61_13, var_61_10) then
				do_material_dissolve(Mesh.material(var_61_13, var_61_10), var_61_0, var_61_2, var_61_3, var_61_4)
			end
		end
	else
		local var_61_14 = Unit.num_meshes(var_61_5)

		for iter_61_2 = 0, var_61_14 - 1 do
			local var_61_15 = Unit.mesh(var_61_5, iter_61_2 + var_61_6)
			local var_61_16 = Mesh.num_materials(var_61_15)

			for iter_61_3 = 0, var_61_16 - 1 do
				do_material_dissolve(Mesh.material(var_61_15, iter_61_3 + var_61_6), var_61_0, var_61_2, var_61_3, var_61_4)
			end
		end
	end
end

function flow_callback_material_dissolve_chr(arg_62_0)
	assert(arg_62_0.unit, "[flow_callback_material_dissolve_chr] You need to specify the Unit")
	assert(arg_62_0.duration, "[flow_callback_material_dissolve_chr] You need to specify duration")
	flow_callback_material_dissolve(arg_62_0)

	local var_62_0 = arg_62_0.unit
	local var_62_1 = {}

	for iter_62_0, iter_62_1 in ipairs({
		"outfit",
		"stump",
		"skin",
		"helmet"
	}) do
		local var_62_2 = Unit.get_data(var_62_0, iter_62_1 .. "_items") or {}

		for iter_62_2 = 1, #var_62_2 do
			arg_62_0.unit = var_62_2[iter_62_2]

			flow_callback_material_dissolve(arg_62_0)
		end
	end
end

function flow_callback_material_dissolve_chr_inventory(arg_63_0)
	assert(arg_63_0.unit, "[flow_callback_material_dissolve_chr_outfit] You need to specify the Unit")
	assert(arg_63_0.duration, "[flow_callback_material_dissolve_chr_outfit] You need to specify duration")
	assert(arg_63_0.inventory_type, "[flow_callback_material_dissolve_chr_inventory] You need to specify inventory type")

	local var_63_0 = arg_63_0.unit
	local var_63_1 = {}

	if arg_63_0.inventory_type == "weapon" then
		var_63_1 = Unit.get_data(var_63_0, "other_items") or {}
	else
		var_63_1 = Unit.get_data(var_63_0, arg_63_0.inventory_type .. "_items") or {}
	end

	for iter_63_0 = 1, #var_63_1 do
		arg_63_0.unit = var_63_1[iter_63_0]

		flow_callback_material_dissolve(arg_63_0)
	end
end

function do_material_fade(arg_64_0, arg_64_1, arg_64_2, arg_64_3, arg_64_4)
	Material.set_vector2(arg_64_0, arg_64_3, arg_64_4)
	Material.set_vector2(arg_64_0, arg_64_1, arg_64_2)
end

function flow_callback_material_fade(arg_65_0)
	assert(arg_65_0.unit, "[flow_callback_material_fade] You need to specify the Unit")
	assert(arg_65_0.duration, "[flow_callback_material_fade] You need to specify duration")

	local var_65_0 = arg_65_0.timer_var_name or "fade_timer"
	local var_65_1 = World.time(Application.main_world())
	local var_65_2 = Vector2(var_65_1, var_65_1 + arg_65_0.duration)
	local var_65_3 = arg_65_0.fade_range_var_name or "fade_interval"
	local var_65_4 = Vector2(arg_65_0.fade_range_from or 1, arg_65_0.fade_range_to or 0)
	local var_65_5 = arg_65_0.unit
	local var_65_6 = Script.index_offset()
	local var_65_7
	local var_65_8 = arg_65_0.mesh_name

	if var_65_8 then
		fassert(Unit.has_mesh(var_65_5, var_65_8), string.format("[flow_callback_material_fade] The mesh %s doesn't exist in unit %s", var_65_8, tostring(var_65_5)))

		var_65_7 = Unit.mesh(var_65_5, var_65_8)
	end

	local var_65_9
	local var_65_10 = arg_65_0.material_name

	if var_65_7 and var_65_10 then
		fassert(Mesh.has_material(var_65_7, var_65_10), string.format("[flow_callback_material_fade] The material %s doesn't exist for mesh %s", var_65_8, var_65_10))

		var_65_9 = Mesh.material(var_65_7, var_65_10)
	end

	if var_65_7 and var_65_9 then
		do_material_fade(var_65_9, var_65_0, var_65_2, var_65_3, var_65_4)
	elseif var_65_7 then
		local var_65_11 = Mesh.num_materials(var_65_7)

		for iter_65_0 = 0, var_65_11 - 1 do
			do_material_fade(Mesh.material(var_65_7, iter_65_0 + var_65_6), var_65_0, var_65_2, var_65_3, var_65_4)
		end
	elseif var_65_10 then
		local var_65_12 = Unit.num_meshes(var_65_5)

		for iter_65_1 = 0, var_65_12 - 1 do
			local var_65_13 = Unit.mesh(var_65_5, iter_65_1 + var_65_6)

			if Mesh.has_material(var_65_13, var_65_10) then
				do_material_fade(Mesh.material(var_65_13, var_65_10), var_65_0, var_65_2, var_65_3, var_65_4)
			end
		end
	else
		local var_65_14 = Unit.num_meshes(var_65_5)

		for iter_65_2 = 0, var_65_14 - 1 do
			local var_65_15 = Unit.mesh(var_65_5, iter_65_2 + var_65_6)
			local var_65_16 = Mesh.num_materials(var_65_15)

			for iter_65_3 = 0, var_65_16 - 1 do
				do_material_fade(Mesh.material(var_65_15, iter_65_3 + var_65_6), var_65_0, var_65_2, var_65_3, var_65_4)
			end
		end
	end
end

function flow_callback_material_fade_chr(arg_66_0)
	assert(arg_66_0.unit, "[flow_callback_material_fade_chr] You need to specify the Unit")
	assert(arg_66_0.duration, "[flow_callback_material_fade_chr] You need to specify duration")
	flow_callback_material_fade(arg_66_0)

	local var_66_0 = arg_66_0.unit
	local var_66_1 = {}

	for iter_66_0, iter_66_1 in ipairs({
		"outfit",
		"stump",
		"skin",
		"helmet"
	}) do
		local var_66_2 = Unit.get_data(var_66_0, iter_66_1 .. "_items") or {}

		for iter_66_2 = 1, #var_66_2 do
			arg_66_0.unit = var_66_2[iter_66_2]

			flow_callback_material_fade(arg_66_0)
		end
	end
end

function flow_callback_material_fade_chr_inventory(arg_67_0)
	assert(arg_67_0.unit, "[flow_callback_material_fade_chr_inventory] You need to specify the Unit")
	assert(arg_67_0.duration, "[flow_callback_material_fade_chr_inventory] You need to specify duration")
	assert(arg_67_0.inventory_type, "[flow_callback_material_fade_chr_inventory] You need to specify inventory type")

	local var_67_0 = arg_67_0.unit
	local var_67_1 = {}

	if arg_67_0.inventory_type == "weapon" then
		var_67_1 = Unit.get_data(var_67_0, "other_items") or {}
	else
		var_67_1 = Unit.get_data(var_67_0, arg_67_0.inventory_type .. "_items") or {}
	end

	for iter_67_0 = 1, #var_67_1 do
		arg_67_0.unit = var_67_1[iter_67_0]

		flow_callback_material_fade(arg_67_0)
	end
end

function flow_callback_visibility_chr_inventory(arg_68_0)
	assert(arg_68_0.unit, "[flow_callback_visibility_chr_inventory] You need to specify the Unit")

	local var_68_0 = arg_68_0.unit
	local var_68_1 = arg_68_0.visibility
	local var_68_2 = {}

	for iter_68_0, iter_68_1 in ipairs({
		"outfit",
		"stump",
		"helmet",
		"skin",
		"other"
	}) do
		local var_68_3 = Unit.get_data(var_68_0, iter_68_1 .. "_items") or {}

		for iter_68_2 = 1, #var_68_3 do
			Unit.set_unit_visibility(var_68_3[iter_68_2], var_68_1)
		end
	end
end

function flow_callback_get_chr_inventory_skin_unit(arg_69_0)
	assert(arg_69_0.unit, "[flow_callback_get_chr_inventory_skin_unit] You need to specify the Unit")

	local var_69_0 = arg_69_0.unit
	local var_69_1
	local var_69_2 = Unit.get_data(var_69_0, "skin_items") or {}

	for iter_69_0 = 1, #var_69_2 do
		var_69_1 = var_69_2[iter_69_0]
	end

	assert(var_69_1, "[flow_callback_get_chr_inventory_skin_unit] No skin found for unit ", tostring(var_69_0))

	return {
		skin_unit = var_69_1
	}
end

function start_material_fade(arg_70_0, arg_70_1, arg_70_2, arg_70_3, arg_70_4, arg_70_5, arg_70_6, arg_70_7, arg_70_8)
	if arg_70_5 and arg_70_6 then
		Material.set_scalar(arg_70_0, arg_70_5, arg_70_6)
	end

	if arg_70_7 and arg_70_8 then
		Material.set_scalar(arg_70_0, arg_70_7, arg_70_8)
	end

	Material.set_scalar(arg_70_0, arg_70_1, arg_70_2)
	Material.set_vector2(arg_70_0, arg_70_3, arg_70_4)
end

function flow_callback_start_fade(arg_71_0)
	assert(arg_71_0.unit, "[flow_callback_start_fade] You need to specify the Unit")
	assert(arg_71_0.duration, "[flow_callback_start_fade] You need to specify duration")
	assert(arg_71_0.fade_switch, "[flow_callback_start_fade] You need to specify whether to fade in or out (0 or 1)")

	local var_71_0 = World.time(Application.main_world())
	local var_71_1 = Vector2(var_71_0, var_71_0 + arg_71_0.duration)
	local var_71_2 = math.floor(arg_71_0.fade_switch + 0.5)
	local var_71_3 = arg_71_0.fade_switch_name or "fade_switch"
	local var_71_4 = arg_71_0.start_end_time_name or "start_end_time"
	local var_71_5 = arg_71_0.unit
	local var_71_6 = Script.index_offset()
	local var_71_7
	local var_71_8 = arg_71_0.mesh_name
	local var_71_9 = arg_71_0.start_fade_value_name or nil
	local var_71_10 = arg_71_0.start_fade_value or nil
	local var_71_11 = arg_71_0.end_fade_value_name or nil
	local var_71_12 = arg_71_0.end_fade_value or nil

	if var_71_8 then
		assert(Unit.has_mesh(var_71_5, var_71_8), string.format("[flow_callback_start_fade] The mesh %s doesn't exist in unit %s", var_71_8, tostring(var_71_5)))

		var_71_7 = Unit.mesh(var_71_5, var_71_8)
	end

	local var_71_13
	local var_71_14 = arg_71_0.material_name

	if var_71_7 and var_71_14 then
		assert(Mesh.has_material(var_71_7, var_71_14), string.format("[flow_callback_start_fade] The material %s doesn't exist for mesh %s", var_71_8, var_71_14))

		var_71_13 = Mesh.material(var_71_7, var_71_14)
	end

	if var_71_7 and var_71_13 then
		start_material_fade(var_71_13, var_71_3, var_71_2, var_71_4, var_71_1, var_71_9, var_71_10, var_71_11, var_71_12)
	elseif var_71_7 then
		local var_71_15 = Mesh.num_materials(var_71_7)

		for iter_71_0 = 0, var_71_15 - 1 do
			local var_71_16 = Mesh.material(var_71_7, iter_71_0 + var_71_6)

			start_material_fade(var_71_16, var_71_3, var_71_2, var_71_4, var_71_1, var_71_9, var_71_10, var_71_11, var_71_12)
		end
	elseif var_71_14 then
		local var_71_17 = Unit.num_meshes(var_71_5)

		for iter_71_1 = 0, var_71_17 - 1 do
			local var_71_18 = Unit.mesh(var_71_5, iter_71_1 + var_71_6)

			if Mesh.has_material(var_71_18, var_71_14) then
				local var_71_19 = Mesh.material(var_71_18, var_71_14)

				start_material_fade(var_71_19, var_71_3, var_71_2, var_71_4, var_71_1, var_71_9, var_71_10, var_71_11, var_71_12)
			end
		end
	else
		local var_71_20 = Unit.num_meshes(var_71_5)

		for iter_71_2 = 0, var_71_20 - 1 do
			local var_71_21 = Unit.mesh(var_71_5, iter_71_2 + var_71_6)
			local var_71_22 = Mesh.num_materials(var_71_21)

			for iter_71_3 = 0, var_71_22 - 1 do
				local var_71_23 = Mesh.material(var_71_21, iter_71_3 + var_71_6)

				start_material_fade(var_71_23, var_71_3, var_71_2, var_71_4, var_71_1, var_71_9, var_71_10, var_71_11, var_71_12)
			end
		end
	end
end

function flow_callback_chr_editor_inventory_spawn(arg_72_0)
	local var_72_0 = arg_72_0.unit
	local var_72_1 = Unit.world(var_72_0)
	local var_72_2 = arg_72_0.unwield
	local var_72_3 = InventoryConfigurations[arg_72_0.inventory_config]

	if var_72_3 ~= nil then
		local var_72_4 = Unit.get_data(var_72_0, "outfit_items") or {}
		local var_72_5 = Unit.get_data(var_72_0, "helmet_items") or {}
		local var_72_6 = Unit.get_data(var_72_0, "skin_items") or {}
		local var_72_7 = Unit.get_data(var_72_0, "other_items") or {}

		for iter_72_0 = 1, #var_72_3.items do
			local var_72_8 = var_72_3.items[iter_72_0][math.random(1, var_72_3.items[iter_72_0].count)]
			local var_72_9 = var_72_8.attachment_node_linking
			local var_72_10 = var_72_8.flow_event or nil
			local var_72_11 = var_72_9.wielded or var_72_9

			if var_72_2 then
				var_72_11 = var_72_9.unwielded or var_72_9
			end

			local var_72_12
			local var_72_13

			for iter_72_1, iter_72_2 in ipairs(var_72_11) do
				if iter_72_2.target == 0 then
					local var_72_14 = iter_72_2.source
					local var_72_15 = type(var_72_14) == "string" and Unit.node(var_72_0, var_72_14) or var_72_14 + 1

					var_72_12 = Unit.world_position(var_72_0, var_72_15)
					var_72_13 = Unit.world_rotation(var_72_0, var_72_15)

					break
				end
			end

			if var_72_10 then
				Unit.flow_event(var_72_0, var_72_10)
			end

			local var_72_16 = World.spawn_unit(var_72_1, var_72_8.unit_name, var_72_12, var_72_13)

			link_attachment(var_72_11, var_72_1, var_72_16, var_72_0)
			Unit.set_data(var_72_16, "node_linking_data", var_72_11)

			if Unit.has_animation_state_machine(var_72_16) then
				if Unit.has_animation_event(var_72_16, "linked") then
					Unit.animation_event(var_72_16, "linked")
				end

				if Unit.has_animation_event(var_72_16, "enable") then
					Unit.animation_event(var_72_16, "enable")
				end
			end

			local var_72_17 = var_72_8.unit_extension_template or "ai_inventory_item"

			if var_72_17 == "ai_helmet_unit" then
				table.insert(var_72_5, var_72_16)
			elseif var_72_17 == "ai_outfit_unit" then
				table.insert(var_72_4, var_72_16)
			elseif var_72_17 == "ai_skin_unit" then
				table.insert(var_72_6, var_72_16)
			else
				table.insert(var_72_7, var_72_16)
			end
		end

		if var_72_2 ~= true then
			local var_72_18 = var_72_3.anim_state_event

			if var_72_18 and Unit.has_animation_event(var_72_0, var_72_18) then
				Unit.animation_event(var_72_0, var_72_18)
			end
		end

		Unit.set_data(var_72_0, "outfit_items", var_72_4)
		Unit.set_data(var_72_0, "helmet_items", var_72_5)
		Unit.set_data(var_72_0, "skin_items", var_72_6)
		Unit.set_data(var_72_0, "other_items", var_72_7)
	end

	return {
		spawned = true
	}
end

function flow_callback_chr_editor_inventory_unspawn(arg_73_0)
	local var_73_0 = arg_73_0.unit
	local var_73_1 = Unit.world(var_73_0)
	local var_73_2 = Unit.get_data(var_73_0, "outfit_items") or {}
	local var_73_3 = Unit.get_data(var_73_0, "helmet_items") or {}
	local var_73_4 = Unit.get_data(var_73_0, "skin_items") or {}
	local var_73_5 = Unit.get_data(var_73_0, "other_items") or {}

	for iter_73_0 = 1, #var_73_2 do
		World.destroy_unit(var_73_1, var_73_2[iter_73_0])
	end

	for iter_73_1 = 1, #var_73_3 do
		World.destroy_unit(var_73_1, var_73_3[iter_73_1])
	end

	for iter_73_2 = 1, #var_73_4 do
		World.destroy_unit(var_73_1, var_73_4[iter_73_2])
	end

	for iter_73_3 = 1, #var_73_5 do
		World.destroy_unit(var_73_1, var_73_5[iter_73_3])
	end

	Unit.set_data(var_73_0, "outfit_items", {})
	Unit.set_data(var_73_0, "helmet_items", {})
	Unit.set_data(var_73_0, "skin_items", {})
	Unit.set_data(var_73_0, "other_items", {})

	return {
		unspawned = true
	}
end

function flow_callback_chr_editor_inventory_drop(arg_74_0)
	local var_74_0 = arg_74_0.unit
	local var_74_1 = Unit.world(var_74_0)
	local var_74_2 = Unit.get_data(var_74_0, "other_items") or {}

	for iter_74_0 = 1, #var_74_2 do
		local var_74_3 = var_74_2[iter_74_0]
		local var_74_4 = Unit.get_data(var_74_3, "node_linking_data") or {}

		if var_74_4 then
			unlink_attachment(var_74_4, var_74_1, var_74_3)
			Unit.flow_event(var_74_3, "lua_dropped")

			local var_74_5 = Unit.create_actor(var_74_3, "rp_dropped")

			Actor.add_angular_velocity(var_74_5, Vector3(math.random(), math.random(), math.random()) * 5)
			Actor.add_velocity(var_74_5, optional_drop_direction or Vector3(2 * math.random() - 0.5, 2 * math.random() - 0.5, 4.5))
		end
	end

	return {
		dropped = true
	}
end

function flow_callback_chr_enemy_inventory_send_event(arg_75_0)
	assert(arg_75_0.unit, "[flow_callback_chr_enemy_inventory_send_event] You need to specify the Unit")
	assert(arg_75_0.event, "[flow_callback_chr_enemy_inventory_send_event] You need to specify an event name")

	local var_75_0 = arg_75_0.unit
	local var_75_1 = arg_75_0.event
	local var_75_2 = Unit.get_data(var_75_0, "outfit_items") or {}

	for iter_75_0 = 1, #var_75_2 do
		Unit.flow_event(var_75_2[iter_75_0], var_75_1)
	end

	local var_75_3 = Unit.get_data(var_75_0, "helmet_items") or {}

	for iter_75_1 = 1, #var_75_3 do
		Unit.flow_event(var_75_3[iter_75_1], var_75_1)
	end

	local var_75_4 = Unit.get_data(var_75_0, "skin_items") or {}

	for iter_75_2 = 1, #var_75_4 do
		Unit.flow_event(var_75_4[iter_75_2], var_75_1)
	end

	local var_75_5 = Unit.get_data(var_75_0, "stump_items") or {}

	for iter_75_3 = 1, #var_75_5 do
		Unit.flow_event(var_75_5[iter_75_3], var_75_1)
	end

	local var_75_6 = Unit.get_data(var_75_0, "other_items") or {}

	for iter_75_4 = 1, #var_75_6 do
		Unit.flow_event(var_75_6[iter_75_4], var_75_1)
	end
end

function flow_callback_is_character_alive(arg_76_0)
	return {
		out_value = true
	}
end

function flow_callback_set_unit_light_state(arg_77_0)
	local var_77_0 = arg_77_0.unit
	local var_77_1 = arg_77_0.state

	if arg_77_0.all_lights then
		local var_77_2 = Unit.num_lights(var_77_0)

		if var_77_2 then
			for iter_77_0 = 1, var_77_2 do
				local var_77_3 = Unit.light(var_77_0, iter_77_0 - 1)

				Light.set_enabled(var_77_3, var_77_1)
			end
		else
			print("No Lights in unit")
		end
	else
		local var_77_4 = arg_77_0.light

		if var_77_4 then
			local var_77_5 = Unit.light(var_77_0, var_77_4)

			Light.set_enabled(var_77_5, var_77_1)
		else
			print("No light named ", var_77_4, " in scene")
		end
	end
end

function flow_callback_set_unit_light_color(arg_78_0)
	local var_78_0 = arg_78_0.unit
	local var_78_1 = arg_78_0.color

	if arg_78_0.all_lights then
		local var_78_2 = Unit.num_lights(var_78_0)

		if var_78_2 then
			for iter_78_0 = 1, var_78_2 do
				local var_78_3 = Unit.light(var_78_0, iter_78_0 - 1)

				Light.set_color(var_78_3, var_78_1)
			end
		else
			print("No Lights in unit")
		end
	else
		local var_78_4 = arg_78_0.light

		if var_78_4 then
			local var_78_5 = Unit.light(var_78_0, var_78_4)

			Light.set_color(var_78_5, var_78_1)
		else
			print("No light named ", var_78_4, " in scene")
		end
	end
end

function flow_callback_debug_print(arg_79_0)
	local var_79_0

	if arg_79_0.prefix then
		var_79_0 = string.format("[flow:%s]", arg_79_0.prefix)
	else
		var_79_0 = "[flow]"
	end

	if arg_79_0.unit then
		var_79_0 = var_79_0 .. string.format(" unit=%q", tostring(arg_79_0.unit))
	end

	if arg_79_0.actor then
		var_79_0 = var_79_0 .. string.format(" actor=%q", tostring(arg_79_0.actor))
	end

	if arg_79_0.bool then
		var_79_0 = var_79_0 .. string.format(" bool=%q", tostring(arg_79_0.bool))
	end

	if arg_79_0.string then
		var_79_0 = var_79_0 .. string.format(" string=%q", arg_79_0.string)
	end

	if arg_79_0.mover then
		var_79_0 = var_79_0 .. string.format(" mover=%q", tostring(arg_79_0.mover))
	end

	if arg_79_0.vector3 then
		var_79_0 = var_79_0 .. string.format(" vector3=%q", tostring(arg_79_0.vector3))
	end

	if arg_79_0.quaternion then
		var_79_0 = var_79_0 .. string.format(" quaternion=%q", tostring(arg_79_0.quaternion))
	end

	if arg_79_0.float then
		var_79_0 = var_79_0 .. string.format(" float=%f", arg_79_0.float)
	end

	print(var_79_0)
end

function flow_callback_link_objects_in_units(arg_80_0)
	local var_80_0 = arg_80_0.parent_unit
	local var_80_1 = arg_80_0.child_unit
	local var_80_2 = split(arg_80_0.parent_nodes, ";")
	local var_80_3 = split(arg_80_0.child_nodes, ";")
	local var_80_4 = Unit.world(var_80_0)

	for iter_80_0 = 1, #var_80_2 - 1 do
		local var_80_5 = Unit.node(var_80_0, var_80_2[iter_80_0])
		local var_80_6 = var_80_3[iter_80_0]
		local var_80_7

		if string.find(string.lower(var_80_6), "index(.)") then
			var_80_7 = tonumber(string.match(var_80_6, "%d+"))
		else
			var_80_7 = Unit.node(var_80_1, var_80_6)
		end

		World.link_unit(var_80_4, var_80_1, var_80_7, var_80_0, var_80_5)

		if arg_80_0.parent_lod_object and arg_80_0.child_lod_object and Unit.has_lod_object(var_80_0, arg_80_0.parent_lod_object) and Unit.has_lod_object(var_80_1, arg_80_0.child_lod_object) then
			local var_80_8 = Unit.lod_object(var_80_0, arg_80_0.parent_lod_object)
			local var_80_9 = Unit.lod_object(var_80_1, arg_80_0.child_lod_object)

			LODObject.set_bounding_volume(var_80_9, LODObject.bounding_volume(var_80_8))
			World.link_unit(var_80_4, var_80_1, LODObject.node(var_80_9), var_80_0, LODObject.node(var_80_8))
		end
	end
end

function flow_callback_get_local_transform(arg_81_0)
	local var_81_0 = arg_81_0.node
	local var_81_1 = arg_81_0.unit
	local var_81_2

	if string.find(string.lower(var_81_0), "index(.)") then
		var_81_2 = tonumber(string.match(var_81_0, "%d+"))
	else
		var_81_2 = Unit.node(var_81_1, var_81_0)
	end

	return {
		position = Unit.local_position(var_81_1, var_81_2),
		rotation = Unit.local_rotation(var_81_1, var_81_2),
		scale = Unit.local_scale(var_81_1, var_81_2)
	}
end

function flow_callback_get_world_transform(arg_82_0)
	local var_82_0 = arg_82_0.node
	local var_82_1 = arg_82_0.unit
	local var_82_2

	if string.find(string.lower(var_82_0), "index(.)") then
		var_82_2 = tonumber(string.match(var_82_0, "%d+"))
	else
		var_82_2 = Unit.node(var_82_1, var_82_0)
	end

	return {
		position = Unit.world_position(var_82_1, var_82_2),
		rotation = Unit.world_rotation(var_82_1, var_82_2)
	}
end

function flow_callback_set_local_scale(arg_83_0)
	local var_83_0 = Unit.node(arg_83_0.unit, arg_83_0.node)

	Unit.set_local_scale(arg_83_0.unit, var_83_0, arg_83_0.scale)
end

function flow_callback_render_cubemap(arg_84_0)
	local var_84_0 = arg_84_0.unit
	local var_84_1 = arg_84_0.path
	local var_84_2 = Unit.world_position(var_84_0, 0)

	LevelEditor.cubemap_generator:create(var_84_2, LevelEditor.shading_environment, var_84_1)
	Application.console_command("reload", "texture")
end

function flow_callback_store_parent(arg_85_0)
	local var_85_0 = arg_85_0.parent_unit
	local var_85_1 = arg_85_0.child_unit

	Unit.set_data(var_85_1, "parent_ref", var_85_0)
end

function flow_callback_stored_parent(arg_86_0)
	local var_86_0 = arg_86_0.child_unit
	local var_86_1 = Unit.get_data(var_86_0, "parent_ref")

	return {
		parent_unit = var_86_1
	}
end

function flow_callback_set_unit_enabled(arg_87_0)
	if arg_87_0.enabled then
		Unit.set_unit_visibility(arg_87_0.unit, true)
		Unit.enable_physics(arg_87_0.unit)
		Unit.enable_animation_state_machine(arg_87_0.unit)
	else
		Unit.set_unit_visibility(arg_87_0.unit, false)
		Unit.disable_physics(arg_87_0.unit)

		if Unit.has_animation_state_machine(arg_87_0.unit) then
			Unit.disable_animation_state_machine(arg_87_0.unit)
		end
	end
end

function flow_callback_set_unit_physics(arg_88_0)
	if arg_88_0.physics then
		Unit.enable_physics(arg_88_0.unit)
	else
		Unit.disable_physics(arg_88_0.unit)
	end
end

function flow_callback_disable_animation_state_machine(arg_89_0)
	Unit.disable_animation_state_machine(arg_89_0.unit)
end

function flow_callback_play_voice(arg_90_0)
	return
end

function flow_callback_relay_trigger(arg_91_0)
	return {
		out = true
	}
end

function flow_callback_set_shading_environment_scalar(arg_92_0)
	if GameSettingsDevelopment then
		return
	end

	local var_92_0 = arg_92_0.variable
	local var_92_1 = arg_92_0.value

	LevelEditor.camera_env_control = true

	local var_92_2 = LevelEditor.shading_environment

	ShadingEnvironment.set_scalar(var_92_2, var_92_0, var_92_1)
	ShadingEnvironment.apply(var_92_2)
end

function split(arg_93_0, arg_93_1)
	arg_93_1 = arg_93_1 or "\n"

	local var_93_0 = {}
	local var_93_1 = 1

	while true do
		local var_93_2, var_93_3 = arg_93_0:find(arg_93_1, var_93_1)

		if not var_93_2 then
			table.insert(var_93_0, arg_93_0:sub(var_93_1))

			break
		end

		table.insert(var_93_0, arg_93_0:sub(var_93_1, var_93_2 - 1))

		var_93_1 = var_93_3 + 1
	end

	return var_93_0
end

function link_attachment(arg_94_0, arg_94_1, arg_94_2, arg_94_3)
	local var_94_0 = Script.index_offset()

	for iter_94_0, iter_94_1 in ipairs(arg_94_0) do
		local var_94_1 = iter_94_1.source
		local var_94_2 = iter_94_1.target
		local var_94_3 = type(var_94_1) == "string" and Unit.node(arg_94_3, var_94_1) or var_94_1 + 1
		local var_94_4 = type(var_94_2) == "string" and Unit.node(arg_94_2, var_94_2) or var_94_2 + 1

		World.link_unit(arg_94_1, arg_94_2, var_94_4, arg_94_3, var_94_3)

		if Unit.num_lod_objects(arg_94_3) ~= 0 and Unit.num_lod_objects(arg_94_2) ~= 0 then
			local var_94_5 = Unit.lod_object(arg_94_3, var_94_0)
			local var_94_6 = Unit.lod_object(arg_94_2, var_94_0)

			LODObject.set_bounding_volume(var_94_6, LODObject.bounding_volume(var_94_5))
			World.link_unit(arg_94_1, arg_94_2, LODObject.node(var_94_6), arg_94_3, LODObject.node(var_94_5))
		end
	end
end

function unlink_attachment(arg_95_0, arg_95_1, arg_95_2)
	World.unlink_unit(arg_95_1, arg_95_2)

	local var_95_0 = arg_95_0.wielded or arg_95_0

	for iter_95_0, iter_95_1 in ipairs(var_95_0) do
		local var_95_1 = iter_95_1.target
		local var_95_2 = type(var_95_1) == "string" and Unit.node(arg_95_2, var_95_1) or var_95_1 + 1

		if var_95_2 > 1 then
			Unit.scene_graph_link(arg_95_2, var_95_2, 1)
		end
	end
end

function flow_callback_wwise_trigger_event_with_environment()
	return
end

function flow_query_global_listener()
	return
end
