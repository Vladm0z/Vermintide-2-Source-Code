-- chunkname: @scripts/helpers/cosmetic_utils.lua

CosmeticUtils = CosmeticUtils or {}

function CosmeticUtils.color_tint_unit(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = "mtr_outfit"

	if arg_1_1 == "bright_wizard" then
		var_1_0 = "mtr_body"
	end

	local var_1_1 = Unit.num_meshes(arg_1_0)

	for iter_1_0 = 0, var_1_1 - 1 do
		local var_1_2 = Unit.mesh(arg_1_0, iter_1_0)

		if Mesh.has_material(var_1_2, var_1_0) then
			local var_1_3 = Mesh.material(var_1_2, var_1_0)
			local var_1_4 = arg_1_2
			local var_1_5 = arg_1_3

			Material.set_scalar(var_1_3, "gradient_variation", var_1_4)
			Material.set_scalar(var_1_3, "tint_columns_pair", var_1_5)
		end
	end
end

function CosmeticUtils.apply_material_settings(arg_2_0, arg_2_1)
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

local var_0_0 = {
	slot_frame = true,
	slot_hat = true,
	slot_skin = true
}
local var_0_1 = {
	frame = true,
	skin = true,
	hat = true
}
local var_0_2 = {
	"slot_ranged",
	"slot_melee",
	"slot_skin",
	"slot_hat",
	"slot_frame",
	"slot_pose"
}
local var_0_3 = {
	slot_pose = true,
	slot_hat = true,
	slot_skin = true,
	slot_frame = true,
	slot_melee = true,
	slot_ranged = true
}

function CosmeticUtils.is_cosmetic_slot(arg_3_0)
	return var_0_0[arg_3_0] ~= nil
end

function CosmeticUtils.is_cosmetic_item(arg_4_0)
	return var_0_1[arg_4_0] ~= nil
end

function CosmeticUtils.is_weapon_pose(arg_5_0)
	return arg_5_0.slot_type == "weapon_pose"
end

local var_0_4 = {
	name = "",
	icon = "unit_frame_02",
	unit = "",
	material_settings_name = "generated_portrait_frame",
	attachment_node = {
		unit = "units/ui/ui_portrait_frame",
		attachment_node = AttachmentNodeLinking.ui_portrait_frame
	}
}

function CosmeticUtils.generate_frame_template(arg_6_0)
	local var_6_0 = var_0_4
	local var_6_1 = string.format("resource_packages/store/item_icons/store_item_icon_%s", arg_6_0)

	if Application.can_get("package", var_6_1) then
		var_6_0.texture_package_name = var_6_1
		MaterialSettingsTemplates.generated_portrait_frame.portrait_frame.texture = string.format("gui/1080p/single_textures/store_item_icons/store_item_icon_%s/store_item_icon_%s", arg_6_0, arg_6_0)
	elseif Cosmetics[arg_6_0] then
		local var_6_2 = Cosmetics[arg_6_0]

		if var_6_2.texture_package_name then
			var_6_0.texture_package_name = var_6_2.texture_package_name
		end

		local var_6_3 = var_6_2.material_settings_name
		local var_6_4 = table.safe_get(MaterialSettingsTemplates, var_6_3, "portrait_frame", "texture")

		if var_6_4 then
			MaterialSettingsTemplates.generated_portrait_frame.portrait_frame.texture = var_6_4
		end
	end

	var_6_0.name = arg_6_0

	return var_6_0
end

function CosmeticUtils.get_cosmetic_name(arg_7_0, arg_7_1)
	local var_7_0

	if arg_7_0 == "slot_frame" or arg_7_0 == "slot_skin" then
		var_7_0 = NetworkLookup.cosmetics[arg_7_1 or 1]
	else
		var_7_0 = NetworkLookup.item_names[arg_7_1 or 1]
	end

	return var_7_0
end

function CosmeticUtils.get_weapon_skin_name(arg_8_0, arg_8_1)
	local var_8_0

	if CosmeticUtils.is_weapon_slot(arg_8_0) then
		var_8_0 = NetworkLookup.weapon_skins[arg_8_1 or 1]
	elseif arg_8_0 == "slot_pose" then
		var_8_0 = NetworkLookup.item_names[arg_8_1 or 1]
	end

	return var_8_0
end

function CosmeticUtils.get_cosmetic_id(arg_9_0, arg_9_1)
	if arg_9_0 == "slot_frame" or arg_9_0 == "slot_skin" then
		return NetworkLookup.cosmetics[arg_9_1 or "default"]
	else
		return NetworkLookup.item_names[arg_9_1 or "n/a"]
	end
end

function CosmeticUtils.get_weapon_pose_skin(arg_10_0)
	local var_10_0
	local var_10_1 = ItemMasterList[arg_10_0]
	local var_10_2 = Managers.backend:get_interface("items")
	local var_10_3 = var_10_2:get_equipped_weapon_pose_skins()[var_10_1.parent]

	if var_10_3 then
		local var_10_4 = var_10_2:get_weapon_skin_from_skin_key(var_10_3)

		var_10_0 = var_10_4 and var_10_2:get_item_from_id(var_10_4)
	end

	return var_10_0
end

function CosmeticUtils.get_weapon_skin_id(arg_11_0, arg_11_1)
	local var_11_0

	if CosmeticUtils.is_weapon_slot(arg_11_0) then
		var_11_0 = NetworkLookup.weapon_skins[arg_11_1 or "n/a"]
	elseif arg_11_0 == "slot_pose" then
		local var_11_1 = ItemMasterList[arg_11_1]
		local var_11_2 = Managers.backend:get_interface("items")
		local var_11_3 = var_11_1.parent
		local var_11_4 = var_11_2:get_equipped_weapon_pose_skin(var_11_3)

		if var_11_4 then
			local var_11_5 = NetworkLookup.item_names[var_11_4]

			if var_11_5 then
				var_11_0 = var_11_5
			end
		else
			var_11_0 = NetworkLookup.item_names["n/a"]
		end
	end

	return var_11_0
end

function CosmeticUtils.update_cosmetic_slot(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	if not var_0_3[arg_12_1] then
		return
	end

	if arg_12_0 and (arg_12_0.local_player or arg_12_0.bot_player and arg_12_0.is_server) and arg_12_0:sync_data_active() then
		local var_12_0 = CosmeticUtils.get_cosmetic_id(arg_12_1, arg_12_2)

		arg_12_0:set_data(arg_12_1, var_12_0)

		local var_12_1

		if arg_12_1 == "slot_pose" then
			var_12_1 = CosmeticUtils.get_weapon_skin_id(arg_12_1, arg_12_2)
		elseif arg_12_3 then
			var_12_1 = CosmeticUtils.get_weapon_skin_id(arg_12_1, arg_12_3)
		end

		if var_12_1 then
			arg_12_0:set_data(arg_12_1 .. "_skin", var_12_1)
		end
	end
end

function CosmeticUtils.get_cosmetic_slot(arg_13_0, arg_13_1)
	if not var_0_3[arg_13_1] then
		return nil
	end

	if arg_13_0 and arg_13_0:sync_data_active() then
		local var_13_0 = {}
		local var_13_1 = arg_13_0:get_data(arg_13_1)

		if not var_13_1 then
			print("[CosmeticUtils] item_id for slot " .. arg_13_1 .. " is nill ")

			return nil
		end

		local var_13_2

		if CosmeticUtils.is_weapon_slot(arg_13_1) or arg_13_1 == "slot_pose" then
			var_13_2 = arg_13_0:get_data(arg_13_1 .. "_skin")
		end

		local var_13_3 = CosmeticUtils.get_cosmetic_name(arg_13_1, var_13_1)

		if var_13_3 == "default" or var_13_3 == "n/a" then
			var_13_3 = nil
		end

		local var_13_4 = CosmeticUtils.get_weapon_skin_name(arg_13_1, var_13_2)

		if var_13_4 == "n/a" then
			var_13_4 = nil
		end

		var_13_0.item_name = var_13_3
		var_13_0.skin_name = var_13_4

		return var_13_0
	end

	return nil
end

function CosmeticUtils.is_weapon_slot(arg_14_0)
	return arg_14_0 == "slot_melee" or arg_14_0 == "slot_ranged"
end

function CosmeticUtils.is_valid(arg_15_0)
	return arg_15_0 and arg_15_0.item_name
end

function CosmeticUtils.get_default_cosmetic_slot(arg_16_0, arg_16_1)
	if not var_0_3[arg_16_1] then
		return nil
	end

	if arg_16_1 == "slot_skin" then
		return {
			item_name = arg_16_0.base_skin
		}
	elseif arg_16_1 == "slot_pose" then
		return {
			item_name = "default_weapon_pose_01"
		}
	elseif CosmeticUtils.is_weapon_slot(arg_16_1) or arg_16_1 == "slot_hat" then
		local var_16_0 = arg_16_0.preview_items

		if var_16_0 then
			for iter_16_0 = 1, #var_16_0 do
				local var_16_1 = var_16_0[iter_16_0].item_name
				local var_16_2 = ItemMasterList[var_16_1].slot_type

				if InventorySettings.slot_names_by_type[var_16_2][1] == arg_16_1 then
					return {
						item_name = var_16_1
					}
				end
			end
		end
	elseif arg_16_1 == "slot_frame" then
		return {
			item_name = "default"
		}
	end

	return nil
end

function CosmeticUtils.sync_local_player_cosmetics(arg_17_0, arg_17_1, arg_17_2)
	if not arg_17_0 then
		Application.warning("[CosmeticUtils.sync_local_player_cosmetics] Failed to sync cosmetics")

		return
	end

	local var_17_0 = SPProfiles[arg_17_1].careers[arg_17_2]
	local var_17_1 = var_17_0.name
	local var_17_2 = #var_0_2
	local var_17_3 = var_17_0.preview_items

	if var_17_3 then
		for iter_17_0 = 1, #var_17_3 do
			local var_17_4 = var_17_3[iter_17_0].item_name
			local var_17_5 = ItemMasterList[var_17_4].slot_type
			local var_17_6 = InventorySettings.slot_names_by_type[var_17_5][1]

			CosmeticUtils.update_cosmetic_slot(arg_17_0, var_17_6, var_17_4)
		end
	end

	CosmeticUtils.update_cosmetic_slot(arg_17_0, "slot_skin", var_17_0.base_skin)

	for iter_17_1 = 1, var_17_2 do
		local var_17_7 = var_0_2[iter_17_1]
		local var_17_8 = BackendUtils.get_loadout_item(var_17_1, var_17_7)

		if var_17_8 then
			local var_17_9 = var_17_8.data
			local var_17_10 = var_17_8.backend_id
			local var_17_11 = BackendUtils.get_item_units(var_17_9, var_17_10, nil, var_17_1)
			local var_17_12 = var_17_9 and var_17_9.name
			local var_17_13 = var_17_11 and var_17_11.skin

			CosmeticUtils.update_cosmetic_slot(arg_17_0, var_17_7, var_17_12, var_17_13)
		end
	end
end
