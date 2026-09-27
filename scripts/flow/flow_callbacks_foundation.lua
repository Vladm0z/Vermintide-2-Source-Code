-- chunkname: @scripts/flow/flow_callbacks_foundation.lua

require("foundation/scripts/util/table")
require("scripts/settings/attachment_node_linking")
require("scripts/settings/ai_inventory_templates")
require("scripts/settings/equipment/weapon_material_settings_templates")

local alive = Unit.alive

function flow_query_script_data(self)
	-- function 1
	local var_1_0

	if not self.table then
		var_1_0 = Unit.get_data(self.unit, self.table, self.scriptdata)
	else
		var_1_0 = Unit.get_data(self.unit, self.scriptdata)
	end

	return {
		value = var_1_0
	}
end

function flow_set_script_data(self)
	-- function 2
	if not self.table then
		Unit.set_data(self.unit, self.table, self.scriptdata, self.value)
	else
		Unit.set_data(self.unit, self.scriptdata, self.value)
	end
end

function flow_script_data_compare_bool(self)
	-- function 3
	local var_3_0
	local reference = self.reference
	local var_3_2

	if not self.table then
		local var_3_3 = split(self.table, "/")

		table.insert(var_3_3, self.scriptdata)

		var_3_0 = Unit.get_data(self.unit, unpack(var_3_3))
	else
		var_3_0 = Unit.get_data(self.unit, self.scriptdata)
	end

	if type(var_3_0) == "boolean" then
		if var_3_0 == reference then
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

function flow_script_data_compare_string(self)
	-- function 4
	local var_4_0
	local reference = self.reference
	local var_4_2

	if not self.table then
		local var_4_3 = split(self.table, "/")

		table.insert(var_4_3, self.scriptdata)

		var_4_0 = Unit.get_data(self.unit, unpack(var_4_3))
	else
		var_4_0 = Unit.get_data(self.unit, self.scriptdata)
	end

	if type(var_4_0) == "string" then
		if var_4_0 == reference then
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

function flow_script_data_compare_number(self)
	-- function 5
	local var_5_0
	local reference = self.reference
	local var_5_2

	if not self.table then
		local var_5_3 = split(self.table, "/")

		table.insert(var_5_3, self.scriptdata)

		var_5_0 = Unit.get_data(self.unit, unpack(var_5_3))
	else
		var_5_0 = Unit.get_data(self.unit, self.scriptdata)
	end

	if type(var_5_0) == "number" then
		if var_5_0 < reference then
			var_5_2 = {
				less = true
			}
		elseif var_5_0 <= reference then
			var_5_2 = {
				less_or_equal = true
			}
		elseif var_5_0 == reference then
			var_5_2 = {
				equal = true
			}
		elseif var_5_0 ~= reference then
			var_5_2 = {
				unequal = true
			}
		elseif reference <= var_5_0 then
			var_5_2 = {
				more_or_equal = true
			}
		elseif reference < var_5_0 then
			var_5_2 = {
				more = true
			}
		end

		return var_5_2
	end
end

function flow_callback_state_false(arg_6_0)
	-- function 6
	return {
		updated = true,
		state = false
	}
end

function flow_callback_state_true(arg_7_0)
	-- function 7
	return {
		updated = true,
		state = true
	}
end

function flow_callback_construct_vector3(self)
	-- function 8
	local var_8_0 = Vector3(self.x, self.y, self.z)

	return {
		vector = var_8_0
	}
end

function flow_callback_store_float(self)
	-- function 9
	local invalue = self.invalue

	return {
		updated = true,
		state = true,
		outvalue = invalue
	}
end

function flow_callback_store_boolean(self)
	-- function 10
	local inbool = self.inbool

	return {
		updated = true,
		state = true,
		outbool = inbool
	}
end

function flow_callback_switchcase(self)
	-- function 11
	local tbl = {}
	local str = "out"

	if self.case ~= "" then
		for k, v in pairs(self) do
			if not (k == "case" or self.case ~= v) then
				tbl[str .. string.sub(k, -1)] = true
			end
		end
	end

	return tbl
end

function flow_callback_switchcase_special(self)
	-- function 12
	local tbl = {}
	local str = "out"

	if self.case ~= "" then
		for k, v in pairs(self) do
			if k ~= "case" then
				local sub = string.sub(k, -1)

				if self.case == sub then
					tbl[str .. sub] = true
					tbl.out_number = sub
				end
			end
		end
	end

	return tbl
end

function flow_callback_set_numeric_w_out(self)
	-- function 13
	local tbl = {}
	local str = "out"

	if self.case ~= "" then
		for k, v in pairs(self) do
			if k ~= "case" then
				local sub = string.sub(k, -1)

				if self.case == sub then
					tbl[str .. sub] = true
					tbl.out_number = sub
				end
			end
		end
	end

	return tbl
end

function flow_callback_switch_event_to_number_0(arg_14_0)
	-- function 14
	return {
		out_number = 0
	}
end

function flow_callback_switch_event_to_number_1(arg_15_0)
	-- function 15
	return {
		out_number = 1
	}
end

function flow_callback_switch_event_to_number_2(arg_16_0)
	-- function 16
	return {
		out_number = 2
	}
end

function flow_callback_switch_event_to_number_3(arg_17_0)
	-- function 17
	return {
		out_number = 3
	}
end

function flow_callback_switch_event_to_number_4(arg_18_0)
	-- function 18
	return {
		out_number = 4
	}
end

function flow_callback_switch_event_to_number_5(arg_19_0)
	-- function 19
	return {
		out_number = 5
	}
end

function flow_callback_switch_event_to_number_6(arg_20_0)
	-- function 20
	return {
		out_number = 6
	}
end

function flow_callback_math_addition(self)
	-- function 21
	local term_one = self.term_one
	local term_two = self.term_two

	return {
		value = term_one + term_two
	}
end

function flow_callback_rotate_vector3(self)
	-- function 22
	local direction = self.direction
	local vector3 = self.vector3
	local rotate = Quaternion.rotate(direction, vector3)

	return {
		vector = rotate
	}
end

function flow_callback_look(self)
	-- function 23
	local direction = self.direction
	local up = self.up
	local look = Quaternion.look(direction, up)

	return {
		rotation = look
	}
end

function flow_callback_math_subtraction(self)
	-- function 24
	local term_one = self.term_one
	local term_two = self.term_two

	return {
		value = term_one - term_two
	}
end

function flow_callback_math_multiplication(self)
	-- function 25
	local factor_one = self.factor_one
	local factor_two = self.factor_two

	return {
		value = factor_one * factor_two
	}
end

function flow_callback_math_multiplication_vector3(self)
	-- function 26
	local vector = self.vector
	local float = self.float

	return {
		value = vector * float
	}
end

function flow_callback_math_division(self)
	-- function 27
	local dividend = self.dividend
	local divisor = self.divisor

	fassert(divisor ~= 0, "Trying to divide by 0 in division flow node.")

	return {
		value = dividend / divisor
	}
end

function flow_callback_math_floor(self)
	-- function 28
	return {
		value = math.floor(self.float)
	}
end

function flow_callback_math_ceil(self)
	-- function 29
	return {
		value = math.ceil(self.float)
	}
end

function flow_query_ghost_mode_active(arg_30_0)
	-- function 30
	return
end

function flow_callback_set_simple_animation_speed(self)
	-- function 31
	Unit.set_simple_animation_speed(self.unit, self.speed, self.group)
end

function flow_callback_trigger_event(self)
	-- function 32
	if not alive(self.unit) then
		Unit.flow_event(self.unit, self.event)
	else
		print("WARNING: flow_callback_trigger_event - unit:", self.unit)
	end
end

function flow_callback_set_unit_visibility(self)
	-- function 33
	Unit.set_visibility(self.unit, self.group, self.visibility)
end

function flow_callback_distance_between(self)
	-- function 34
	local unit = self.unit
	local node1 = self.node1
	local node2 = self.node2
	local node = Unit.node(unit, node1)
	local node_2 = Unit.node(unit, node2)
	local world_position = Unit.world_position(unit, node)
	local world_position_2 = Unit.world_position(unit, node_2)
	local distance = Vector3.distance(world_position, world_position_2)

	return {
		distance = distance
	}
end

function flow_callback_link_objects_in_units_and_store(self)
	-- function 35
	local parent_unit = self.parent_unit
	local child_unit = self.child_unit
	local var_35_2 = split(self.parent_nodes, ";")
	local var_35_3 = split(self.child_nodes, ";")
	local world = Unit.world(parent_unit)
	local index_offset = Script.index_offset()

	for i = 1, #var_35_2 - 1 do
		local node = Unit.node(parent_unit, var_35_2[i])
		local var_35_7 = var_35_3[i]
		local var_35_8

		if not string.find(var_35_7, "Index(.)") then
			var_35_8 = tonumber(string.match(var_35_7, "%d+") + index_offset)
		else
			var_35_8 = Unit.node(child_unit, var_35_7)
		end

		World.link_unit(world, child_unit, var_35_8, parent_unit, node)

		if not self.parent_lod_object and not self.child_lod_object and not Unit.has_lod_object(parent_unit, self.parent_lod_object) and not Unit.has_lod_object(child_unit, self.child_lod_object) then
			local lod_object = Unit.lod_object(parent_unit, self.parent_lod_object)
			local lod_object_2 = Unit.lod_object(child_unit, self.child_lod_object)

			LODObject.set_bounding_volume(lod_object_2, LODObject.bounding_volume(lod_object))
			World.link_unit(world, child_unit, LODObject.node(lod_object_2), parent_unit, LODObject.node(lod_object))
		end
	end

	local get_data = Unit.get_data(parent_unit, "flow_unit_attachments")

	get_data = get_data or {}

	table.insert(get_data, child_unit)
	Unit.set_data(parent_unit, "flow_unit_attachments", get_data)

	return {
		linked = true
	}
end

function flow_callback_unlink_objects_in_units_and_remove(self)
	-- function 36
	local parent_unit = self.parent_unit
	local child_unit = self.child_unit
	local world = Unit.world(parent_unit)

	World.unlink_unit(world, child_unit)

	local get_data = Unit.get_data(parent_unit, "flow_unit_attachments")

	get_data = get_data or {}

	local find = table.find(get_data, child_unit)

	if not find then
		table.remove(get_data, find)
	end

	Unit.set_data(parent_unit, "flow_unit_attachments", get_data)

	return {
		unlinked = true
	}
end

function flow_callback_attach_unit(self)
	-- function 37
	local AttachmentNodeLinking = AttachmentNodeLinking
	local var_37_1 = split(self.node_link_template, "/")

	if not var_37_1 then
		print("No attachment node linking defined in flow!")

		return
	end

	for i, v in ipairs(var_37_1) do
		AttachmentNodeLinking = AttachmentNodeLinking[v]
	end

	if type(AttachmentNodeLinking) ~= "table" then
		print("No attachment node linking with name %s", tostring(self.node_link_template))

		return
	end

	local parent_unit = self.parent_unit
	local child_unit = self.child_unit
	local index_offset = Script.index_offset()
	local world = Unit.world(parent_unit)

	for i_2, v_2 in ipairs(AttachmentNodeLinking) do
		local source = v_2.source
		local target = v_2.target
		local node

		if type(source) == "string" then
			node = Unit.node(parent_unit, source)

			if not node then
				-- Nothing
			end
		end

		node = source + index_offset

		do
			local node_2
		end

		::label_37_0::

		if type(target) == "string" then
			node_2 = Unit.node(child_unit, target)

			if not node_2 then
				-- Nothing
			end
		end

		node_2 = target + index_offset

		::label_37_1::

		World.link_unit(world, child_unit, node_2, parent_unit, node)
	end

	if not (not self.link_lod_groups and Unit.num_lod_objects(parent_unit) == 0 or Unit.num_lod_objects(child_unit) == 0) then
		local lod_object = Unit.lod_object(parent_unit, index_offset)
		local lod_object_2 = Unit.lod_object(child_unit, index_offset)

		LODObject.set_bounding_volume(lod_object_2, LODObject.bounding_volume(lod_object))
		World.link_unit(world, child_unit, LODObject.node(lod_object_2), parent_unit, LODObject.node(lod_object))
	end

	if not self.store_in_parent then
		local get_data = Unit.get_data(parent_unit, "flow_unit_attachments")

		get_data = get_data or {}

		table.insert(get_data, child_unit)
		Unit.set_data(parent_unit, "flow_unit_attachments", get_data)
	end

	return {
		linked = true
	}
end

function flow_callback_attach_weapon_display(self)
	-- function 38
	if self.item == nil then
		return {}
	end

	local unit = self.unit
	local var_38_1
	local var_38_2
	local world = Unit.world(unit)
	local str = "display"
	local show_right_hand = self.show_right_hand
	local show_left_hand = self.show_left_hand
	local show_ammo = self.show_ammo

	if ItemMasterList ~= nil then
		local var_38_8 = ItemMasterList[self.item]

		if not (var_38_8 == nil or var_38_8.slot_type == "melee" or var_38_8.slot_type == "ranged" or var_38_8.slot_type == "weapon_skin" or var_38_8.slot_type ~= "potion") then
			pcall(require, "scripts/settings/equipment/weapons")
			pcall(require, "scripts/settings/equipment/weapon_skins")

			if Weapons ~= nil then
				local template = var_38_8.template
				local var_38_10 = rawget(Weapons, template)
				local var_38_11 = rawget(WeaponSkins.skins, self.item)
				local display_unit = var_38_8.display_unit

				display_unit = display_unit or nil

				local right_hand_unit = var_38_8.right_hand_unit

				right_hand_unit = right_hand_unit or nil

				local left_hand_unit = var_38_8.left_hand_unit

				left_hand_unit = left_hand_unit or nil

				if not var_38_8.ammo_unit then
					local var_38_15
				end

				if var_38_11 ~= nil then
					if var_38_11.right_hand_unit ~= nil then
						right_hand_unit = var_38_11.right_hand_unit
					end

					if var_38_11.left_hand_unit ~= nil then
						left_hand_unit = var_38_11.left_hand_unit
					end

					if var_38_11.ammo_unit ~= nil then
						ammo_unit_type = var_38_11.ammo_unit
					end

					if var_38_11.display_unit ~= nil then
						display_unit = var_38_11.display_unit
					end
				end

				if display_unit ~= nil then
					local index_offset = Script.index_offset()
					local world_position = Unit.world_position(unit, 0 + index_offset)
					local world_rotation = Unit.world_rotation(unit, 0 + index_offset)
					local spawn_unit = World.spawn_unit(world, display_unit, world_position, world_rotation)

					World.link_unit(world, spawn_unit, 0 + index_offset, unit, 0 + index_offset)

					local get_data = Unit.get_data(unit, "flow_item_attachments")

					get_data = get_data or {}

					if not (not show_right_hand and right_hand_unit == nil) then
						var_38_2 = attach_player_item(spawn_unit, right_hand_unit, var_38_10.right_hand_attachment_node_linking.third_person, "display", false)

						if not (var_38_11 == nil or var_38_11.material_settings_name == nil) then
							apply_material_settings(var_38_2, var_38_11.material_settings_name)
						end

						Unit.flow_event(var_38_2, "spawn_display")
						table.insert(get_data, var_38_2)
						Unit.set_data(unit, "flow_item_attachments", get_data)
					end

					if not (not show_left_hand and left_hand_unit == nil) then
						local var_38_21

						if left_hand_unit == ammo_unit_type then
							var_38_21 = var_38_10.right_hand_attachment_node_linking.third_person
						elseif var_38_10.left_hand_attachment_node_linking ~= nil then
							var_38_21 = var_38_10.left_hand_attachment_node_linking.third_person
						end

						if var_38_21 ~= nil then
							var_38_2 = attach_player_item(spawn_unit, left_hand_unit, var_38_21, "display", false)

							if not (var_38_11 == nil or var_38_11.material_settings_name == nil) then
								apply_material_settings(var_38_2, var_38_11.material_settings_name)
							end

							Unit.flow_event(var_38_2, "spawn_display")
							table.insert(get_data, var_38_2)
							Unit.set_data(unit, "flow_item_attachments", get_data)
						end
					end

					if not (not show_ammo and var_38_10.ammo_data == nil or var_38_10.actions.action_one.default.projectile_info == nil) then
						local ProjectileUnits = ProjectileUnits

						if ProjectileUnits[var_38_10.actions.action_one.default.projectile_info.projectile_units_template].dummy_linker_unit_name ~= nil then
							var_38_2 = attach_player_item(spawn_unit, ProjectileUnits[var_38_10.actions.action_one.default.projectile_info.projectile_units_template].dummy_linker_unit_name, var_38_10.ammo_data.ammo_unit_attachment_node_linking.third_person, "display", false)

							if not (var_38_11 == nil or var_38_11.material_settings_name == nil) then
								apply_material_settings(var_38_2, var_38_11.material_settings_name)
							end

							Unit.flow_event(var_38_2, "spawn_display")
							table.insert(get_data, var_38_2)
							Unit.set_data(unit, "flow_item_attachments", get_data)
						end
					end

					Unit.set_data(unit, "flow_item_attachments", get_data)
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

function flow_callback_attach_player_item(self)
	-- function 39
	if self.item == nil then
		return {}
	end

	local var_39_0
	local unit = self.unit
	local world = Unit.world(unit)
	local node_linking = self.node_linking

	node_linking = node_linking or "wielded"

	if ItemMasterList ~= nil then
		local var_39_4 = ItemMasterList[self.item]

		if var_39_4 ~= nil then
			if not (not self.career_filter and table.is_empty(var_39_4.can_wield) or table.find(var_39_4.can_wield, self.career_filter)) then
				print("SKIPPED ITEM! Career " .. self.career_filter .. " can't wield " .. self.item)
				table.dump(var_39_4.can_wield)

				return
			end

			if not (var_39_4.slot_type == "melee" or var_39_4.slot_type == "ranged" or var_39_4.slot_type == "weapon_skin" or var_39_4.slot_type ~= "potion") then
				pcall(require, "scripts/settings/equipment/weapons")
				pcall(require, "scripts/settings/equipment/weapon_skins")

				if Weapons ~= nil then
					local str = "_3p"

					if node_linking == "display" then
						str = ""
					end

					local template = var_39_4.template
					local var_39_7 = rawget(Weapons, template)
					local var_39_8 = rawget(WeaponSkins.skins, self.item)
					local right_hand_unit = var_39_4.right_hand_unit
					local left_hand_unit = var_39_4.left_hand_unit
					local ammo_unit = var_39_4.ammo_unit

					if var_39_8 ~= nil then
						if right_hand_unit == nil then
							right_hand_unit = var_39_8.right_hand_unit or nil
						end

						if left_hand_unit == nil then
							left_hand_unit = var_39_8.left_hand_unit or nil
						end

						if ammo_unit == nil then
							ammo_unit = var_39_8.ammo_unit or nil
						end
					end

					if right_hand_unit ~= nil then
						var_39_0 = attach_player_item(unit, right_hand_unit .. str, var_39_7.right_hand_attachment_node_linking.third_person, node_linking, false)

						if not (var_39_8 == nil or var_39_8.material_settings_name == nil) then
							apply_material_settings(var_39_0, var_39_8.material_settings_name)
						end
					end

					if left_hand_unit ~= nil then
						local var_39_12

						if left_hand_unit == ammo_unit then
							var_39_12 = var_39_7.right_hand_attachment_node_linking.third_person
						elseif var_39_7.left_hand_attachment_node_linking ~= nil then
							var_39_12 = var_39_7.left_hand_attachment_node_linking.third_person
						end

						if var_39_12 ~= nil then
							var_39_0 = attach_player_item(unit, left_hand_unit .. str, var_39_12, node_linking, false)

							if not (var_39_8 == nil or var_39_8.material_settings_name == nil) then
								apply_material_settings(var_39_0, var_39_8.material_settings_name)
							end
						end
					end

					if not (var_39_7.ammo_data == nil or var_39_7.actions.action_one == nil or var_39_7.actions.action_one.default.projectile_info == nil) then
						local ProjectileUnits = ProjectileUnits

						if ProjectileUnits[var_39_7.actions.action_one.default.projectile_info.projectile_units_template].dummy_linker_unit_name ~= nil then
							var_39_0 = attach_player_item(unit, ProjectileUnits[var_39_7.actions.action_one.default.projectile_info.projectile_units_template].dummy_linker_unit_name, var_39_7.ammo_data.ammo_unit_attachment_node_linking.third_person, node_linking, false)

							if not (var_39_8 == nil or var_39_8.material_settings_name == nil) then
								apply_material_settings(var_39_0, var_39_8.material_settings_name)
							end
						end
					end

					if not (not Unit.has_animation_state_machine(unit) and var_39_7.wield_anim == nil or self.skip_wield_anim) then
						Unit.animation_event(unit, var_39_7.wield_anim)
					end
				else
					print("SKIPPED PLAYER WEAPON: Missing Weapons table")
				end
			elseif var_39_4.slot_type == "hat" then
				if var_39_4.unit ~= nil then
					if Attachments ~= nil then
						local var_39_14 = Attachments[var_39_4.template]

						var_39_0 = attach_player_item(unit, var_39_4.unit, var_39_14.attachment_node_linking.slot_hat, nil, true)

						local get_data = Unit.get_data(var_39_0, "equip_event")

						if not get_data then
							get_data = var_39_14.show_attachments_event
							get_data = get_data or nil
						end

						equip_event = get_data
						material_switches = nil

						if var_39_14.character_material_changes ~= nil then
							material_switches = var_39_14.character_material_changes.third_person
						end

						if not equip_event then
							Unit.flow_event(unit, equip_event)
						end

						local get_data_2 = Unit.get_data(unit, "flow_item_attachments")

						get_data_2 = get_data_2 or {}

						for k, v in pairs(get_data_2) do
							if not equip_event then
								Unit.flow_event(v, equip_event)
							end

							if material_switches ~= nil then
								for k_2, v_2 in pairs(material_switches) do
									Unit.set_material(v, k_2, v_2)
								end
							end
						end

						local get_data_3 = Unit.get_data(unit, "skin_events")

						get_data_3 = get_data_3 or {}

						for k_3, v_3 in pairs(get_data_3) do
							Unit.flow_event(var_39_0, v_3)
						end
					else
						print("SKIPPED PLAYER ATTACHMENT: Missing Attachments table")
					end
				end
			elseif var_39_4.slot_type == "skin" then
				if Cosmetics ~= nil then
					local var_39_18 = Cosmetics[self.item]

					if node_linking == "display" then
						if var_39_18.first_person_attachment ~= nil then
							var_39_0 = attach_player_item(unit, var_39_18.first_person_attachment.unit, var_39_18.first_person_attachment.attachment_node_linking, nil, true)

							if var_39_18.material_changes ~= nil then
								for k_4, v_4 in pairs(var_39_18.material_changes.first_person) do
									Unit.set_material(var_39_0, k_4, v_4)
								end
							end
						end
					elseif var_39_18.third_person_attachment ~= nil then
						var_39_0 = attach_player_item(unit, var_39_18.third_person_attachment.unit, var_39_18.third_person_attachment.attachment_node_linking, nil, true)

						if var_39_18.material_changes ~= nil then
							for k_5, v_5 in pairs(var_39_18.material_changes.third_person) do
								Unit.set_material(var_39_0, k_5, v_5)
							end
						end

						if var_39_18.material_settings_name ~= nil then
							apply_material_settings(var_39_0, var_39_18.material_settings_name)
						end

						local equip_skin_event = var_39_18.equip_skin_event

						equip_skin_event = equip_skin_event or "using_skin_default"

						Unit.flow_event(unit, equip_skin_event)

						local get_data_4 = Unit.get_data(unit, "skin_events")

						get_data_4 = get_data_4 or {}

						if var_39_18.equip_hat_event ~= nil then
							table.insert(get_data_4, var_39_18.equip_hat_event)
						else
							table.insert(get_data_4, "using_skin_default")
						end

						Unit.set_data(unit, "skin_events", get_data_4)
						Unit.set_data(var_39_0, "skin_events", get_data_4)

						if not Unit.has_animation_state_machine(var_39_0) and not Unit.has_animation_event(var_39_0, "enable") then
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
			print("SKIPPED PLAYER ITEM: Missing item " .. self.item)
		end
	else
		print("SKIPPED PLAYER INVENTORY: Missing ItemMasterList table")
	end

	return {
		item_unit = var_39_0
	}
end

function attach_player_item(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
	-- function 40
	local index_offset = Script.index_offset()

	if arg_40_3 == "unwielded" then
		arg_40_2 = arg_40_2.unwielded or arg_40_2
	elseif arg_40_3 == "display" then
		arg_40_2 = arg_40_2.display or arg_40_2
	else
		arg_40_2 = arg_40_2.wielded or arg_40_2
	end

	local var_40_1
	local var_40_2

	for k, v in pairs(arg_40_2) do
		if k == 0 then
			local node

			if type(v) == "string" then
				node = Unit.node(arg_40_0, v)

				if not node then
					-- Nothing
				end
			end

			node = v + index_offset

			::label_40_0::

			var_40_1 = Unit.world_position(arg_40_0, node)
			var_40_2 = Unit.world_rotation(arg_40_0, node)

			break
		end
	end

	local world = Unit.world(arg_40_0)
	local spawn_unit = World.spawn_unit(world, arg_40_1, var_40_1, var_40_2)

	for i, v_2 in ipairs(arg_40_2) do
		local source = v_2.source
		local target = v_2.target
		local node_2

		if type(source) == "string" then
			node_2 = Unit.node(arg_40_0, source)

			if not node_2 then
				-- Nothing
			end
		end

		node_2 = source + index_offset

		do
			local node_3
		end

		::label_40_1::

		if type(target) == "string" then
			node_3 = Unit.node(spawn_unit, target)

			if not node_3 then
				-- Nothing
			end
		end

		node_3 = target + index_offset

		::label_40_2::

		World.link_unit(world, spawn_unit, node_3, arg_40_0, node_2)
	end

	if not (not arg_40_4 and Unit.num_lod_objects(arg_40_0) == 0 or Unit.num_lod_objects(spawn_unit) == 0) then
		local lod_object = Unit.lod_object(arg_40_0, index_offset)
		local lod_object_2 = Unit.lod_object(spawn_unit, index_offset)

		LODObject.set_bounding_volume(lod_object_2, LODObject.bounding_volume(lod_object))
		World.link_unit(world, spawn_unit, LODObject.node(lod_object_2), arg_40_0, LODObject.node(lod_object))
	end

	local get_data = Unit.get_data(arg_40_0, "flow_item_attachments")

	get_data = get_data or {}

	table.insert(get_data, spawn_unit)
	Unit.set_data(arg_40_0, "flow_item_attachments", get_data)

	return spawn_unit
end

function apply_material_settings(arg_41_0, arg_41_1)
	-- function 41
	local var_41_0 = MaterialSettingsTemplates[arg_41_1]

	for k, v in pairs(var_41_0) do
		if v.type == "color" then
			if not v.apply_to_children then
				Unit.set_color_for_materials_in_unit_and_childs(arg_41_0, k, Quaternion(v.alpha, v.r, v.g, v.b))
			else
				Unit.set_color_for_materials(arg_41_0, k, Quaternion(v.alpha, v.r, v.g, v.b))
			end
		elseif v.type == "matrix4x4" then
			local var_41_1 = Matrix4x4(v.xx, v.xy, v.xz, v.yx, v.yy, v.yz, v.zx, v.zy, v.zz, v.tx, v.ty, v.tz)

			if not v.apply_to_children then
				Unit.set_matrix4x4_for_materials_in_unit_and_childs(arg_41_0, k, var_41_1)
			else
				Unit.set_matrix4x4_for_materials(arg_41_0, k, var_41_1)
			end
		elseif v.type == "scalar" then
			if not v.apply_to_children then
				Unit.set_scalar_for_materials_in_unit_and_childs(arg_41_0, k, v.value)
			else
				Unit.set_scalar_for_materials(arg_41_0, k, v.value)
			end
		elseif v.type == "vector2" then
			if not v.apply_to_children then
				Unit.set_vector2_for_materials_in_unit_and_childs(arg_41_0, k, Vector3(v.x, v.y, 0))
			else
				Unit.set_vector2_for_materials(arg_41_0, k, Vector3(v.x, v.y, 0))
			end
		elseif v.type == "vector3" then
			if not v.apply_to_children then
				Unit.set_vector3_for_materials_in_unit_and_childs(arg_41_0, k, Vector3(v.x, v.y, v.z))
			else
				Unit.set_vector3_for_materials(arg_41_0, k, Vector3(v.x, v.y, v.z))
			end
		elseif v.type == "vector4" then
			if not v.apply_to_children then
				Unit.set_vector4_for_materials_in_unit_and_childs(arg_41_0, k, Quaternion(v.x, v.y, v.z, v.w))
			else
				Unit.set_vector4_for_materials(arg_41_0, k, Quaternion(v.x, v.y, v.z, v.w))
			end
		elseif v.type ~= "texture" or not Application.can_get("texture", v.texture) then
			Unit.set_texture_for_materials(arg_41_0, k, v.texture)
		end
	end
end

function flow_callback_remove_player_items(self)
	-- function 42
	local unit = self.unit
	local world = Unit.world(unit)
	local get_data = Unit.get_data(unit, "flow_item_attachments")

	get_data = get_data or {}

	for i = 1, #get_data do
		self.unit = get_data[i]

		local var_42_3 = flow_callback_remove_player_items(self)

		World.unlink_unit(world, get_data[i])
		World.destroy_unit(world, get_data[i])
	end

	Unit.set_data(unit, "flow_item_attachments", {})

	return {}
end

function flow_callback_unattach_unit(self)
	-- function 43
	local parent_unit = self.parent_unit
	local child_unit = self.child_unit
	local world = Unit.world(parent_unit)

	World.unlink_unit(world, child_unit)

	local get_data = Unit.get_data(parent_unit, "flow_unit_attachments")

	get_data = get_data or {}

	local find = table.find(get_data, child_unit)

	if not find then
		table.remove(get_data, find)
	end

	Unit.set_data(parent_unit, "flow_unit_attachments", get_data)

	return {
		unlinked = true
	}
end

function flow_callback_trigger_event_on_attachments(self)
	-- function 44
	local get_data = Unit.get_data(self.unit, "flow_unit_attachments")

	get_data = get_data or {}

	for i = 1, #get_data do
		Unit.flow_event(get_data[i], self.event)
	end

	return {
		triggered = true
	}
end

function flow_callback_unit_spawner_spawn_local_unit(arg_45_0)
	-- function 45
	return
end

function flow_callback_unit_spawner_mark_for_deletion(arg_46_0)
	-- function 46
	return
end

function flow_callback_set_actor_enabled(self)
	-- function 47
	local unit = self.unit

	assert(unit, "Set Actor Enabled flow node is missing unit")

	local actor = self.actor

	actor = actor or Unit.actor(unit, self.actor_name)

	local fassert = fassert
	local var_47_3 = actor
	local str = "Set Actor Enabled flow node referring to unit %s is missing actor %s"
	local var_47_5 = tostring(unit)
	local tostring = tostring
	local actor_2 = self.actor

	actor_2 = actor_2 or self.actor_name

	fassert(var_47_3, str, var_47_5, tostring(actor_2))
	Actor.set_collision_enabled(actor, self.enabled)
	Actor.set_scene_query_enabled(actor, self.enabled)
end

function flow_callback_set_actor_kinematic(self)
	-- function 48
	local unit = self.unit

	assert(unit, "Set Actor Kinematic flow node is missing unit")

	local actor = self.actor

	actor = actor or Unit.actor(unit, self.actor_name)

	local fassert = fassert
	local var_48_3 = actor
	local str = "Set Actor Kinematic flow node referring to unit %s is missing actor %s"
	local var_48_5 = tostring(unit)
	local tostring = tostring
	local actor_2 = self.actor

	actor_2 = actor_2 or self.actor_name

	fassert(var_48_3, str, var_48_5, tostring(actor_2))
	Actor.set_kinematic(actor, self.enabled)
end

function flow_callback_spawn_actor(self)
	-- function 49
	local unit = self.unit

	assert(unit, "Spawn Actor flow node is missing unit")

	local actor_name = self.actor_name

	Unit.create_actor(unit, actor_name)
end

function flow_callback_destroy_actor(self)
	-- function 50
	local unit = self.unit

	assert(unit, "Destroy Actor flow node is missing unit")

	local actor_name = self.actor_name

	Unit.destroy_actor(unit, actor_name)
end

function flow_callback_set_actor_initial_velocity(self)
	-- function 51
	local unit = self.unit

	assert(unit, "Set actor initial velocity has no unit")
	Unit.apply_initial_actor_velocities(unit, true)
end

function flow_callback_set_actor_initial_velocity(self)
	-- function 52
	local unit = self.unit

	assert(unit, "Set actor initial velocity has no unit")
	Unit.apply_initial_actor_velocities(unit, true)
end

function flow_callback_set_unit_material_variation(self)
	-- function 53
	local unit = self.unit
	local material_variation = self.material_variation

	Unit.set_material_variation(unit, material_variation)
end

function flow_callback_set_material_property_scalar(self)
	-- function 54
	local unit = self.unit
	local all_meshes = self.all_meshes
	local mesh = self.mesh
	local material = self.material
	local variable = self.variable
	local value = self.value

	if not all_meshes then
		for i = 0, Unit.num_meshes(unit) - 1 do
			mesh = Unit.mesh(unit, i)

			if not Mesh.has_material(mesh, material) then
				local material_2 = Mesh.material(mesh, material)

				Material.set_scalar(material_2, variable, value)
			end
		end
	else
		local mesh_2 = Unit.mesh(unit, mesh)
		local material_3 = Mesh.material(mesh_2, material)

		Material.set_scalar(material_3, variable, value)
	end
end

function flow_callback_set_material_property_vector2(self)
	-- function 55
	local unit = self.unit
	local all_meshes = self.all_meshes
	local mesh = self.mesh
	local material = self.material
	local variable = self.variable
	local var_55_5 = Vector2(self.value.x, self.value.y)

	if not all_meshes then
		for i = 0, Unit.num_meshes(unit) - 1 do
			mesh = Unit.mesh(unit, i)

			if not Mesh.has_material(mesh, material) then
				local material_2 = Mesh.material(mesh, material)

				Material.set_vector2(material_2, variable, var_55_5)
			end
		end
	else
		local mesh_2 = Unit.mesh(unit, mesh)
		local material_3 = Mesh.material(mesh_2, material)

		Material.set_vector2(material_3, variable, var_55_5)
	end
end

function flow_callback_set_material_property_vector3(self)
	-- function 56
	local unit = self.unit
	local all_meshes = self.all_meshes
	local mesh = self.mesh
	local material = self.material
	local variable = self.variable
	local value = self.value

	if not all_meshes then
		for i = 0, Unit.num_meshes(unit) - 1 do
			mesh = Unit.mesh(unit, i)

			if not Mesh.has_material(mesh, material) then
				local material_2 = Mesh.material(mesh, material)

				Material.set_vector3(material_2, variable, value)
			end
		end
	else
		local mesh_2 = Unit.mesh(unit, mesh)
		local material_3 = Mesh.material(mesh_2, material)

		Material.set_vector3(material_3, variable, value)
	end
end

function flow_callback_set_material_property_color(self)
	-- function 57
	local unit = self.unit
	local all_meshes = self.all_meshes
	local mesh = self.mesh
	local material = self.material
	local variable = self.variable
	local color = self.color

	if not all_meshes then
		for i = 0, Unit.num_meshes(unit) - 1 do
			mesh = Unit.mesh(unit, i)

			if not Mesh.has_material(mesh, material) then
				local material_2 = Mesh.material(mesh, material)

				Material.set_color(material_2, variable, color)
			end
		end
	else
		local mesh_2 = Unit.mesh(unit, mesh)
		local material_3 = Mesh.material(mesh_2, material)

		Material.set_color(material_3, variable, color)
	end
end

function do_material_dissolve(arg_58_0, arg_58_1, arg_58_2, arg_58_3, arg_58_4)
	-- function 58
	Material.set_scalar(arg_58_0, arg_58_3, arg_58_4)
	Material.set_vector2(arg_58_0, arg_58_1, arg_58_2)
end

function flow_callback_set_material_property_scalar_all(self)
	-- function 59
	local unit = self.unit
	local variable = self.variable
	local value = self.value
	local index_offset = Script.index_offset()
	local num = 1 - index_offset
	local num_meshes = Unit.num_meshes(unit)

	for i = index_offset, num_meshes - num do
		local mesh = Unit.mesh(unit, i)
		local num_materials = Mesh.num_materials(mesh)

		for j = index_offset, num_materials - num do
			local material = Mesh.material(mesh, j)

			Material.set_scalar(material, variable, value)
		end
	end
end

function flow_callback_material_scalar_set_chr_inventory(self)
	-- function 60
	assert(self.unit, "[flow_callback_material_scalar_set_chr_inventory] You need to specify the Unit")
	assert(self.variable, "[flow_callback_material_scalar_set_chr_inventory] You need to specify variable value")
	assert(self.value, "[flow_callback_material_scalar_set_chr_inventory] You need to specify variable name")

	local unit = self.unit
	local tbl = {}

	for i, v in ipairs({
		"outfit",
		"stump",
		"helmet",
		"skin",
		"other"
	}) do
		local flag = Unit.get_data(unit, v .. "_items") or {}

		for k = 1, #flag do
			self.unit = flag[k]

			flow_callback_set_material_property_scalar_all(self)
		end
	end
end

function flow_callback_material_dissolve(self)
	-- function 61
	assert(self.unit, "[flow_callback_material_dissolve] You need to specify the Unit")
	assert(self.duration, "[flow_callback_material_dissolve] You need to specify duration")

	local timer_var_name = self.timer_var_name

	timer_var_name = timer_var_name or "dissolve_timer"

	local time = World.time(Application.main_world())
	local var_61_2 = Vector2(time, time + self.duration)
	local dissolve_start_state_var_name = self.dissolve_start_state_var_name

	dissolve_start_state_var_name = dissolve_start_state_var_name or "dissolve_start_value"

	local floor = math.floor
	local num = 0.5 + self.dissolve_start_state

	num = num or 1

	local var_61_6 = floor(num)
	local unit = self.unit
	local index_offset = Script.index_offset()
	local var_61_9
	local mesh_name = self.mesh_name

	if not mesh_name then
		fassert(Unit.has_mesh(unit, mesh_name), string.format("[flow_callback_material_dissolve] The mesh %s doesn't exist in unit %s", mesh_name, tostring(unit)))

		var_61_9 = Unit.mesh(unit, mesh_name)
	end

	local var_61_11
	local material_name = self.material_name

	if not var_61_9 and not material_name then
		fassert(Mesh.has_material(var_61_9, material_name), string.format("[flow_callback_material_dissolve] The material %s doesn't exist for mesh %s", mesh_name, material_name))

		var_61_11 = Mesh.material(var_61_9, material_name)
	end

	if not var_61_9 and not var_61_11 then
		do_material_dissolve(var_61_11, timer_var_name, var_61_2, dissolve_start_state_var_name, var_61_6)
	elseif not var_61_9 then
		local num_materials = Mesh.num_materials(var_61_9)

		for i = 0, num_materials - 1 do
			do_material_dissolve(Mesh.material(var_61_9, i + index_offset), timer_var_name, var_61_2, dissolve_start_state_var_name, var_61_6)
		end
	elseif not material_name then
		local num_meshes = Unit.num_meshes(unit)

		for j = 0, num_meshes - 1 do
			local mesh = Unit.mesh(unit, j + index_offset)

			if not Mesh.has_material(mesh, material_name) then
				do_material_dissolve(Mesh.material(mesh, material_name), timer_var_name, var_61_2, dissolve_start_state_var_name, var_61_6)
			end
		end
	else
		local num_meshes_2 = Unit.num_meshes(unit)

		for k = 0, num_meshes_2 - 1 do
			local mesh_2 = Unit.mesh(unit, k + index_offset)
			local num_materials_2 = Mesh.num_materials(mesh_2)

			for l = 0, num_materials_2 - 1 do
				do_material_dissolve(Mesh.material(mesh_2, l + index_offset), timer_var_name, var_61_2, dissolve_start_state_var_name, var_61_6)
			end
		end
	end
end

function flow_callback_material_dissolve_chr(self)
	-- function 62
	assert(self.unit, "[flow_callback_material_dissolve_chr] You need to specify the Unit")
	assert(self.duration, "[flow_callback_material_dissolve_chr] You need to specify duration")
	flow_callback_material_dissolve(self)

	local unit = self.unit
	local tbl = {}

	for i, v in ipairs({
		"outfit",
		"stump",
		"skin",
		"helmet"
	}) do
		local flag = Unit.get_data(unit, v .. "_items") or {}

		for k = 1, #flag do
			self.unit = flag[k]

			flow_callback_material_dissolve(self)
		end
	end
end

function flow_callback_material_dissolve_chr_inventory(self)
	-- function 63
	assert(self.unit, "[flow_callback_material_dissolve_chr_outfit] You need to specify the Unit")
	assert(self.duration, "[flow_callback_material_dissolve_chr_outfit] You need to specify duration")
	assert(self.inventory_type, "[flow_callback_material_dissolve_chr_inventory] You need to specify inventory type")

	local unit = self.unit
	local tbl = {}

	if self.inventory_type == "weapon" then
		tbl = Unit.get_data(unit, "other_items") or {}
	else
		tbl = Unit.get_data(unit, self.inventory_type .. "_items") or {}
	end

	for i = 1, #tbl do
		self.unit = tbl[i]

		flow_callback_material_dissolve(self)
	end
end

function do_material_fade(arg_64_0, arg_64_1, arg_64_2, arg_64_3, arg_64_4)
	-- function 64
	Material.set_vector2(arg_64_0, arg_64_3, arg_64_4)
	Material.set_vector2(arg_64_0, arg_64_1, arg_64_2)
end

function flow_callback_material_fade(self)
	-- function 65
	assert(self.unit, "[flow_callback_material_fade] You need to specify the Unit")
	assert(self.duration, "[flow_callback_material_fade] You need to specify duration")

	local timer_var_name = self.timer_var_name

	timer_var_name = timer_var_name or "fade_timer"

	local time = World.time(Application.main_world())
	local var_65_2 = Vector2(time, time + self.duration)
	local fade_range_var_name = self.fade_range_var_name

	fade_range_var_name = fade_range_var_name or "fade_interval"

	local Vector2 = Vector2
	local fade_range_from = self.fade_range_from

	fade_range_from = fade_range_from or 1

	local fade_range_to = self.fade_range_to

	fade_range_to = fade_range_to or 0

	local var_65_7 = Vector2(fade_range_from, fade_range_to)
	local unit = self.unit
	local index_offset = Script.index_offset()
	local var_65_10
	local mesh_name = self.mesh_name

	if not mesh_name then
		fassert(Unit.has_mesh(unit, mesh_name), string.format("[flow_callback_material_fade] The mesh %s doesn't exist in unit %s", mesh_name, tostring(unit)))

		var_65_10 = Unit.mesh(unit, mesh_name)
	end

	local var_65_12
	local material_name = self.material_name

	if not var_65_10 and not material_name then
		fassert(Mesh.has_material(var_65_10, material_name), string.format("[flow_callback_material_fade] The material %s doesn't exist for mesh %s", mesh_name, material_name))

		var_65_12 = Mesh.material(var_65_10, material_name)
	end

	if not var_65_10 and not var_65_12 then
		do_material_fade(var_65_12, timer_var_name, var_65_2, fade_range_var_name, var_65_7)
	elseif not var_65_10 then
		local num_materials = Mesh.num_materials(var_65_10)

		for i = 0, num_materials - 1 do
			do_material_fade(Mesh.material(var_65_10, i + index_offset), timer_var_name, var_65_2, fade_range_var_name, var_65_7)
		end
	elseif not material_name then
		local num_meshes = Unit.num_meshes(unit)

		for j = 0, num_meshes - 1 do
			local mesh = Unit.mesh(unit, j + index_offset)

			if not Mesh.has_material(mesh, material_name) then
				do_material_fade(Mesh.material(mesh, material_name), timer_var_name, var_65_2, fade_range_var_name, var_65_7)
			end
		end
	else
		local num_meshes_2 = Unit.num_meshes(unit)

		for k = 0, num_meshes_2 - 1 do
			local mesh_2 = Unit.mesh(unit, k + index_offset)
			local num_materials_2 = Mesh.num_materials(mesh_2)

			for l = 0, num_materials_2 - 1 do
				do_material_fade(Mesh.material(mesh_2, l + index_offset), timer_var_name, var_65_2, fade_range_var_name, var_65_7)
			end
		end
	end
end

function flow_callback_material_fade_chr(self)
	-- function 66
	assert(self.unit, "[flow_callback_material_fade_chr] You need to specify the Unit")
	assert(self.duration, "[flow_callback_material_fade_chr] You need to specify duration")
	flow_callback_material_fade(self)

	local unit = self.unit
	local tbl = {}

	for i, v in ipairs({
		"outfit",
		"stump",
		"skin",
		"helmet"
	}) do
		local flag = Unit.get_data(unit, v .. "_items") or {}

		for k = 1, #flag do
			self.unit = flag[k]

			flow_callback_material_fade(self)
		end
	end
end

function flow_callback_material_fade_chr_inventory(self)
	-- function 67
	assert(self.unit, "[flow_callback_material_fade_chr_inventory] You need to specify the Unit")
	assert(self.duration, "[flow_callback_material_fade_chr_inventory] You need to specify duration")
	assert(self.inventory_type, "[flow_callback_material_fade_chr_inventory] You need to specify inventory type")

	local unit = self.unit
	local tbl = {}

	if self.inventory_type == "weapon" then
		tbl = Unit.get_data(unit, "other_items") or {}
	else
		tbl = Unit.get_data(unit, self.inventory_type .. "_items") or {}
	end

	for i = 1, #tbl do
		self.unit = tbl[i]

		flow_callback_material_fade(self)
	end
end

function flow_callback_visibility_chr_inventory(self)
	-- function 68
	assert(self.unit, "[flow_callback_visibility_chr_inventory] You need to specify the Unit")

	local unit = self.unit
	local visibility = self.visibility
	local tbl = {}

	for i, v in ipairs({
		"outfit",
		"stump",
		"helmet",
		"skin",
		"other"
	}) do
		local flag = Unit.get_data(unit, v .. "_items") or {}

		for k = 1, #flag do
			Unit.set_unit_visibility(flag[k], visibility)
		end
	end
end

function flow_callback_get_chr_inventory_skin_unit(self)
	-- function 69
	assert(self.unit, "[flow_callback_get_chr_inventory_skin_unit] You need to specify the Unit")

	local unit = self.unit
	local var_69_1
	local get_data = Unit.get_data(unit, "skin_items")

	get_data = get_data or {}

	for i = 1, #get_data do
		var_69_1 = get_data[i]
	end

	assert(var_69_1, "[flow_callback_get_chr_inventory_skin_unit] No skin found for unit ", tostring(unit))

	return {
		skin_unit = var_69_1
	}
end

function start_material_fade(arg_70_0, arg_70_1, arg_70_2, arg_70_3, arg_70_4, arg_70_5, arg_70_6, arg_70_7, arg_70_8)
	-- function 70
	if not arg_70_5 and not arg_70_6 then
		Material.set_scalar(arg_70_0, arg_70_5, arg_70_6)
	end

	if not arg_70_7 and not arg_70_8 then
		Material.set_scalar(arg_70_0, arg_70_7, arg_70_8)
	end

	Material.set_scalar(arg_70_0, arg_70_1, arg_70_2)
	Material.set_vector2(arg_70_0, arg_70_3, arg_70_4)
end

function flow_callback_start_fade(self)
	-- function 71
	assert(self.unit, "[flow_callback_start_fade] You need to specify the Unit")
	assert(self.duration, "[flow_callback_start_fade] You need to specify duration")
	assert(self.fade_switch, "[flow_callback_start_fade] You need to specify whether to fade in or out (0 or 1)")

	local time = World.time(Application.main_world())
	local var_71_1 = Vector2(time, time + self.duration)
	local floor = math.floor(self.fade_switch + 0.5)
	local fade_switch_name = self.fade_switch_name

	fade_switch_name = fade_switch_name or "fade_switch"

	local start_end_time_name = self.start_end_time_name

	start_end_time_name = start_end_time_name or "start_end_time"

	local unit = self.unit
	local index_offset = Script.index_offset()
	local var_71_7
	local mesh_name = self.mesh_name
	local start_fade_value_name = self.start_fade_value_name

	start_fade_value_name = start_fade_value_name or nil

	local start_fade_value = self.start_fade_value

	start_fade_value = start_fade_value or nil

	local end_fade_value_name = self.end_fade_value_name

	end_fade_value_name = end_fade_value_name or nil

	local end_fade_value = self.end_fade_value

	end_fade_value = end_fade_value or nil

	if not mesh_name then
		assert(Unit.has_mesh(unit, mesh_name), string.format("[flow_callback_start_fade] The mesh %s doesn't exist in unit %s", mesh_name, tostring(unit)))

		var_71_7 = Unit.mesh(unit, mesh_name)
	end

	local var_71_13
	local material_name = self.material_name

	if not var_71_7 and not material_name then
		assert(Mesh.has_material(var_71_7, material_name), string.format("[flow_callback_start_fade] The material %s doesn't exist for mesh %s", mesh_name, material_name))

		var_71_13 = Mesh.material(var_71_7, material_name)
	end

	if not var_71_7 and not var_71_13 then
		start_material_fade(var_71_13, fade_switch_name, floor, start_end_time_name, var_71_1, start_fade_value_name, start_fade_value, end_fade_value_name, end_fade_value)
	elseif not var_71_7 then
		local num_materials = Mesh.num_materials(var_71_7)

		for i = 0, num_materials - 1 do
			local material = Mesh.material(var_71_7, i + index_offset)

			start_material_fade(material, fade_switch_name, floor, start_end_time_name, var_71_1, start_fade_value_name, start_fade_value, end_fade_value_name, end_fade_value)
		end
	elseif not material_name then
		local num_meshes = Unit.num_meshes(unit)

		for j = 0, num_meshes - 1 do
			local mesh = Unit.mesh(unit, j + index_offset)

			if not Mesh.has_material(mesh, material_name) then
				local material_2 = Mesh.material(mesh, material_name)

				start_material_fade(material_2, fade_switch_name, floor, start_end_time_name, var_71_1, start_fade_value_name, start_fade_value, end_fade_value_name, end_fade_value)
			end
		end
	else
		local num_meshes_2 = Unit.num_meshes(unit)

		for k = 0, num_meshes_2 - 1 do
			local mesh_2 = Unit.mesh(unit, k + index_offset)
			local num_materials_2 = Mesh.num_materials(mesh_2)

			for l = 0, num_materials_2 - 1 do
				local material_3 = Mesh.material(mesh_2, l + index_offset)

				start_material_fade(material_3, fade_switch_name, floor, start_end_time_name, var_71_1, start_fade_value_name, start_fade_value, end_fade_value_name, end_fade_value)
			end
		end
	end
end

function flow_callback_chr_editor_inventory_spawn(self)
	-- function 72
	local unit = self.unit
	local world = Unit.world(unit)
	local unwield = self.unwield
	local var_72_3 = InventoryConfigurations[self.inventory_config]

	if var_72_3 ~= nil then
		local get_data = Unit.get_data(unit, "outfit_items")

		get_data = get_data or {}

		local get_data_2 = Unit.get_data(unit, "helmet_items")

		get_data_2 = get_data_2 or {}

		local get_data_3 = Unit.get_data(unit, "skin_items")

		get_data_3 = get_data_3 or {}

		local get_data_4 = Unit.get_data(unit, "other_items")

		get_data_4 = get_data_4 or {}

		for i = 1, #var_72_3.items do
			local var_72_8 = var_72_3.items[i][math.random(1, var_72_3.items[i].count)]
			local attachment_node_linking = var_72_8.attachment_node_linking
			local flow_event = var_72_8.flow_event

			flow_event = flow_event or nil

			local wielded = attachment_node_linking.wielded

			wielded = wielded or attachment_node_linking

			if not unwield then
				wielded = attachment_node_linking.unwielded or attachment_node_linking
			end

			local var_72_12
			local var_72_13

			for i_2, v in ipairs(wielded) do
				if v.target == 0 then
					local source = v.source
					local node

					if type(source) == "string" then
						node = Unit.node(unit, source)

						if not node then
							-- Nothing
						end
					end

					node = source + 1

					::label_72_0::

					var_72_12 = Unit.world_position(unit, node)
					var_72_13 = Unit.world_rotation(unit, node)

					break
				end
			end

			if not flow_event then
				Unit.flow_event(unit, flow_event)
			end

			local spawn_unit = World.spawn_unit(world, var_72_8.unit_name, var_72_12, var_72_13)

			link_attachment(wielded, world, spawn_unit, unit)
			Unit.set_data(spawn_unit, "node_linking_data", wielded)

			if not Unit.has_animation_state_machine(spawn_unit) then
				if not Unit.has_animation_event(spawn_unit, "linked") then
					Unit.animation_event(spawn_unit, "linked")
				end

				if not Unit.has_animation_event(spawn_unit, "enable") then
					Unit.animation_event(spawn_unit, "enable")
				end
			end

			local unit_extension_template = var_72_8.unit_extension_template

			unit_extension_template = unit_extension_template or "ai_inventory_item"

			if unit_extension_template == "ai_helmet_unit" then
				table.insert(get_data_2, spawn_unit)
			elseif unit_extension_template == "ai_outfit_unit" then
				table.insert(get_data, spawn_unit)
			elseif unit_extension_template == "ai_skin_unit" then
				table.insert(get_data_3, spawn_unit)
			else
				table.insert(get_data_4, spawn_unit)
			end
		end

		if unwield ~= true then
			local anim_state_event = var_72_3.anim_state_event

			if not anim_state_event and not Unit.has_animation_event(unit, anim_state_event) then
				Unit.animation_event(unit, anim_state_event)
			end
		end

		Unit.set_data(unit, "outfit_items", get_data)
		Unit.set_data(unit, "helmet_items", get_data_2)
		Unit.set_data(unit, "skin_items", get_data_3)
		Unit.set_data(unit, "other_items", get_data_4)
	end

	return {
		spawned = true
	}
end

function flow_callback_chr_editor_inventory_unspawn(self)
	-- function 73
	local unit = self.unit
	local world = Unit.world(unit)
	local get_data = Unit.get_data(unit, "outfit_items")

	get_data = get_data or {}

	local get_data_2 = Unit.get_data(unit, "helmet_items")

	get_data_2 = get_data_2 or {}

	local get_data_3 = Unit.get_data(unit, "skin_items")

	get_data_3 = get_data_3 or {}

	local get_data_4 = Unit.get_data(unit, "other_items")

	get_data_4 = get_data_4 or {}

	for i = 1, #get_data do
		World.destroy_unit(world, get_data[i])
	end

	for j = 1, #get_data_2 do
		World.destroy_unit(world, get_data_2[j])
	end

	for k = 1, #get_data_3 do
		World.destroy_unit(world, get_data_3[k])
	end

	for l = 1, #get_data_4 do
		World.destroy_unit(world, get_data_4[l])
	end

	Unit.set_data(unit, "outfit_items", {})
	Unit.set_data(unit, "helmet_items", {})
	Unit.set_data(unit, "skin_items", {})
	Unit.set_data(unit, "other_items", {})

	return {
		unspawned = true
	}
end

function flow_callback_chr_editor_inventory_drop(self)
	-- function 74
	local unit = self.unit
	local world = Unit.world(unit)
	local get_data = Unit.get_data(unit, "other_items")

	get_data = get_data or {}

	for i = 1, #get_data do
		local var_74_3 = get_data[i]
		local get_data_2 = Unit.get_data(var_74_3, "node_linking_data")

		get_data_2 = get_data_2 or {}

		if not get_data_2 then
			unlink_attachment(get_data_2, world, var_74_3)
			Unit.flow_event(var_74_3, "lua_dropped")

			local create_actor = Unit.create_actor(var_74_3, "rp_dropped")

			Actor.add_angular_velocity(create_actor, Vector3(math.random(), math.random(), math.random()) * 5)

			local add_velocity = Actor.add_velocity
			local var_74_7 = create_actor
			local optional_drop_direction = optional_drop_direction

			optional_drop_direction = optional_drop_direction or Vector3(2 * math.random() - 0.5, 2 * math.random() - 0.5, 4.5)

			add_velocity(var_74_7, optional_drop_direction)
		end
	end

	return {
		dropped = true
	}
end

function flow_callback_chr_enemy_inventory_send_event(self)
	-- function 75
	assert(self.unit, "[flow_callback_chr_enemy_inventory_send_event] You need to specify the Unit")
	assert(self.event, "[flow_callback_chr_enemy_inventory_send_event] You need to specify an event name")

	local unit = self.unit
	local event = self.event
	local get_data = Unit.get_data(unit, "outfit_items")

	get_data = get_data or {}

	for i = 1, #get_data do
		Unit.flow_event(get_data[i], event)
	end

	local get_data_2 = Unit.get_data(unit, "helmet_items")

	get_data_2 = get_data_2 or {}

	for j = 1, #get_data_2 do
		Unit.flow_event(get_data_2[j], event)
	end

	local get_data_3 = Unit.get_data(unit, "skin_items")

	get_data_3 = get_data_3 or {}

	for k = 1, #get_data_3 do
		Unit.flow_event(get_data_3[k], event)
	end

	local get_data_4 = Unit.get_data(unit, "stump_items")

	get_data_4 = get_data_4 or {}

	for l = 1, #get_data_4 do
		Unit.flow_event(get_data_4[l], event)
	end

	local get_data_5 = Unit.get_data(unit, "other_items")

	get_data_5 = get_data_5 or {}

	for i4 = 1, #get_data_5 do
		Unit.flow_event(get_data_5[i4], event)
	end
end

function flow_callback_is_character_alive(arg_76_0)
	-- function 76
	return {
		out_value = true
	}
end

function flow_callback_set_unit_light_state(self)
	-- function 77
	local unit = self.unit
	local state = self.state

	if not self.all_lights then
		local num_lights = Unit.num_lights(unit)

		if not num_lights then
			for i = 1, num_lights do
				local light = Unit.light(unit, i - 1)

				Light.set_enabled(light, state)
			end
		else
			print("No Lights in unit")
		end
	else
		local light_2 = self.light

		if not light_2 then
			local light_3 = Unit.light(unit, light_2)

			Light.set_enabled(light_3, state)
		else
			print("No light named ", light_2, " in scene")
		end
	end
end

function flow_callback_set_unit_light_color(self)
	-- function 78
	local unit = self.unit
	local color = self.color

	if not self.all_lights then
		local num_lights = Unit.num_lights(unit)

		if not num_lights then
			for i = 1, num_lights do
				local light = Unit.light(unit, i - 1)

				Light.set_color(light, color)
			end
		else
			print("No Lights in unit")
		end
	else
		local light_2 = self.light

		if not light_2 then
			local light_3 = Unit.light(unit, light_2)

			Light.set_color(light_3, color)
		else
			print("No light named ", light_2, " in scene")
		end
	end
end

function flow_callback_debug_print(self)
	-- function 79
	local var_79_0

	if not self.prefix then
		var_79_0 = string.format("[flow:%s]", self.prefix)
	else
		var_79_0 = "[flow]"
	end

	if not self.unit then
		var_79_0 = var_79_0 .. string.format(" unit=%q", tostring(self.unit))
	end

	if not self.actor then
		var_79_0 = var_79_0 .. string.format(" actor=%q", tostring(self.actor))
	end

	if not self.bool then
		var_79_0 = var_79_0 .. string.format(" bool=%q", tostring(self.bool))
	end

	if not self.string then
		var_79_0 = var_79_0 .. string.format(" string=%q", self.string)
	end

	if not self.mover then
		var_79_0 = var_79_0 .. string.format(" mover=%q", tostring(self.mover))
	end

	if not self.vector3 then
		var_79_0 = var_79_0 .. string.format(" vector3=%q", tostring(self.vector3))
	end

	if not self.quaternion then
		var_79_0 = var_79_0 .. string.format(" quaternion=%q", tostring(self.quaternion))
	end

	if not self.float then
		var_79_0 = var_79_0 .. string.format(" float=%f", self.float)
	end

	print(var_79_0)
end

function flow_callback_link_objects_in_units(self)
	-- function 80
	local parent_unit = self.parent_unit
	local child_unit = self.child_unit
	local var_80_2 = split(self.parent_nodes, ";")
	local var_80_3 = split(self.child_nodes, ";")
	local world = Unit.world(parent_unit)

	for i = 1, #var_80_2 - 1 do
		local node = Unit.node(parent_unit, var_80_2[i])
		local var_80_6 = var_80_3[i]
		local var_80_7

		if not string.find(string.lower(var_80_6), "index(.)") then
			var_80_7 = tonumber(string.match(var_80_6, "%d+"))
		else
			var_80_7 = Unit.node(child_unit, var_80_6)
		end

		World.link_unit(world, child_unit, var_80_7, parent_unit, node)

		if not self.parent_lod_object and not self.child_lod_object and not Unit.has_lod_object(parent_unit, self.parent_lod_object) and not Unit.has_lod_object(child_unit, self.child_lod_object) then
			local lod_object = Unit.lod_object(parent_unit, self.parent_lod_object)
			local lod_object_2 = Unit.lod_object(child_unit, self.child_lod_object)

			LODObject.set_bounding_volume(lod_object_2, LODObject.bounding_volume(lod_object))
			World.link_unit(world, child_unit, LODObject.node(lod_object_2), parent_unit, LODObject.node(lod_object))
		end
	end
end

function flow_callback_get_local_transform(self)
	-- function 81
	local node = self.node
	local unit = self.unit
	local var_81_2

	if not string.find(string.lower(node), "index(.)") then
		var_81_2 = tonumber(string.match(node, "%d+"))
	else
		var_81_2 = Unit.node(unit, node)
	end

	return {
		position = Unit.local_position(unit, var_81_2),
		rotation = Unit.local_rotation(unit, var_81_2),
		scale = Unit.local_scale(unit, var_81_2)
	}
end

function flow_callback_get_world_transform(self)
	-- function 82
	local node = self.node
	local unit = self.unit
	local var_82_2

	if not string.find(string.lower(node), "index(.)") then
		var_82_2 = tonumber(string.match(node, "%d+"))
	else
		var_82_2 = Unit.node(unit, node)
	end

	return {
		position = Unit.world_position(unit, var_82_2),
		rotation = Unit.world_rotation(unit, var_82_2)
	}
end

function flow_callback_set_local_scale(self)
	-- function 83
	local node = Unit.node(self.unit, self.node)

	Unit.set_local_scale(self.unit, node, self.scale)
end

function flow_callback_render_cubemap(self)
	-- function 84
	local unit = self.unit
	local path = self.path
	local world_position = Unit.world_position(unit, 0)

	LevelEditor.cubemap_generator:create(world_position, LevelEditor.shading_environment, path)
	Application.console_command("reload", "texture")
end

function flow_callback_store_parent(self)
	-- function 85
	local parent_unit = self.parent_unit
	local child_unit = self.child_unit

	Unit.set_data(child_unit, "parent_ref", parent_unit)
end

function flow_callback_stored_parent(self)
	-- function 86
	local child_unit = self.child_unit
	local get_data = Unit.get_data(child_unit, "parent_ref")

	return {
		parent_unit = get_data
	}
end

function flow_callback_set_unit_enabled(self)
	-- function 87
	if not self.enabled then
		Unit.set_unit_visibility(self.unit, true)
		Unit.enable_physics(self.unit)
		Unit.enable_animation_state_machine(self.unit)
	else
		Unit.set_unit_visibility(self.unit, false)
		Unit.disable_physics(self.unit)

		if not Unit.has_animation_state_machine(self.unit) then
			Unit.disable_animation_state_machine(self.unit)
		end
	end
end

function flow_callback_set_unit_physics(self)
	-- function 88
	if not self.physics then
		Unit.enable_physics(self.unit)
	else
		Unit.disable_physics(self.unit)
	end
end

function flow_callback_disable_animation_state_machine(self)
	-- function 89
	Unit.disable_animation_state_machine(self.unit)
end

function flow_callback_play_voice(arg_90_0)
	-- function 90
	return
end

function flow_callback_relay_trigger(arg_91_0)
	-- function 91
	return {
		out = true
	}
end

function flow_callback_set_shading_environment_scalar(self)
	-- function 92
	if not GameSettingsDevelopment then
		return
	end

	local variable = self.variable
	local value = self.value

	LevelEditor.camera_env_control = true

	local shading_environment = LevelEditor.shading_environment

	ShadingEnvironment.set_scalar(shading_environment, variable, value)
	ShadingEnvironment.apply(shading_environment)
end

function split(self, arg_93_1)
	-- function 93
	arg_93_1 = arg_93_1 or "\n"

	local tbl = {}
	local num = 1

	while true do
		local find, var_93_3 = self:find(arg_93_1, num)

		if not find then
			table.insert(tbl, self:sub(num))

			break
		end

		table.insert(tbl, self:sub(num, find - 1))

		num = var_93_3 + 1
	end

	return tbl
end

function link_attachment(arg_94_0, arg_94_1, arg_94_2, arg_94_3)
	-- function 94
	local index_offset = Script.index_offset()

	for i, v in ipairs(arg_94_0) do
		local source = v.source
		local target = v.target
		local node

		if type(source) == "string" then
			node = Unit.node(arg_94_3, source)

			if not node then
				-- Nothing
			end
		end

		node = source + 1

		do
			local node_2
		end

		::label_94_0::

		if type(target) == "string" then
			node_2 = Unit.node(arg_94_2, target)

			if not node_2 then
				-- Nothing
			end
		end

		node_2 = target + 1

		::label_94_1::

		World.link_unit(arg_94_1, arg_94_2, node_2, arg_94_3, node)

		if not (Unit.num_lod_objects(arg_94_3) == 0 or Unit.num_lod_objects(arg_94_2) == 0) then
			local lod_object = Unit.lod_object(arg_94_3, index_offset)
			local lod_object_2 = Unit.lod_object(arg_94_2, index_offset)

			LODObject.set_bounding_volume(lod_object_2, LODObject.bounding_volume(lod_object))
			World.link_unit(arg_94_1, arg_94_2, LODObject.node(lod_object_2), arg_94_3, LODObject.node(lod_object))
		end
	end
end

function unlink_attachment(self, arg_95_1, arg_95_2)
	-- function 95
	World.unlink_unit(arg_95_1, arg_95_2)

	local wielded = self.wielded

	wielded = wielded or self

	for i, v in ipairs(wielded) do
		local target = v.target
		local node

		if type(target) == "string" then
			node = Unit.node(arg_95_2, target)

			if not node then
				-- Nothing
			end
		end

		node = target + 1

		::label_95_0::

		if node > 1 then
			Unit.scene_graph_link(arg_95_2, node, 1)
		end
	end
end

function flow_callback_wwise_trigger_event_with_environment()
	-- function 96
	return
end

function flow_query_global_listener()
	-- function 97
	return
end
