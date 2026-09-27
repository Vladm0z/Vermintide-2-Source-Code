-- chunkname: @scripts/helpers/cosmetic_utils.lua

local CosmeticUtils = CosmeticUtils

CosmeticUtils = CosmeticUtils or {}
CosmeticUtils = CosmeticUtils

CosmeticUtils.color_tint_unit = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local str = "mtr_outfit"

	if arg_1_1 == "bright_wizard" then
		str = "mtr_body"
	end

	local num_meshes = Unit.num_meshes(arg_1_0)

	for i = 0, num_meshes - 1 do
		local mesh = Unit.mesh(arg_1_0, i)

		if not Mesh.has_material(mesh, str) then
			local material = Mesh.material(mesh, str)
			local var_1_4 = arg_1_2
			local var_1_5 = arg_1_3

			Material.set_scalar(material, "gradient_variation", var_1_4)
			Material.set_scalar(material, "tint_columns_pair", var_1_5)
		end
	end
end

CosmeticUtils.apply_material_settings = function (arg_2_0, arg_2_1)
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

local tbl = {
	slot_frame = true,
	slot_hat = true,
	slot_skin = true
}
local tbl_2 = {
	frame = true,
	skin = true,
	hat = true
}
local tbl_3 = {
	"slot_ranged",
	"slot_melee",
	"slot_skin",
	"slot_hat",
	"slot_frame",
	"slot_pose"
}
local tbl_4 = {
	slot_pose = true,
	slot_hat = true,
	slot_skin = true,
	slot_frame = true,
	slot_melee = true,
	slot_ranged = true
}

CosmeticUtils.is_cosmetic_slot = function (arg_3_0)
	-- function 3
	return tbl[arg_3_0] ~= nil
end

CosmeticUtils.is_cosmetic_item = function (arg_4_0)
	-- function 4
	return tbl_2[arg_4_0] ~= nil
end

CosmeticUtils.is_weapon_pose = function (self)
	-- function 5
	return self.slot_type == "weapon_pose"
end

local tbl_5 = {
	name = "",
	icon = "unit_frame_02",
	unit = "",
	material_settings_name = "generated_portrait_frame",
	attachment_node = {
		unit = "units/ui/ui_portrait_frame",
		attachment_node = AttachmentNodeLinking.ui_portrait_frame
	}
}

CosmeticUtils.generate_frame_template = function (arg_6_0)
	-- function 6
	local var_6_0 = tbl_5
	local format = string.format("resource_packages/store/item_icons/store_item_icon_%s", arg_6_0)

	if not Application.can_get("package", format) then
		var_6_0.texture_package_name = format
		MaterialSettingsTemplates.generated_portrait_frame.portrait_frame.texture = string.format("gui/1080p/single_textures/store_item_icons/store_item_icon_%s/store_item_icon_%s", arg_6_0, arg_6_0)
	elseif not Cosmetics[arg_6_0] then
		local var_6_2 = Cosmetics[arg_6_0]

		if not var_6_2.texture_package_name then
			var_6_0.texture_package_name = var_6_2.texture_package_name
		end

		local material_settings_name = var_6_2.material_settings_name
		local safe_get = table.safe_get(MaterialSettingsTemplates, material_settings_name, "portrait_frame", "texture")

		if not safe_get then
			MaterialSettingsTemplates.generated_portrait_frame.portrait_frame.texture = safe_get
		end
	end

	var_6_0.name = arg_6_0

	return var_6_0
end

CosmeticUtils.get_cosmetic_name = function (arg_7_0, arg_7_1)
	-- function 7
	local var_7_0

	if not (arg_7_0 == "slot_frame" or arg_7_0 ~= "slot_skin") then
		var_7_0 = NetworkLookup.cosmetics[arg_7_1 or 1]
	else
		var_7_0 = NetworkLookup.item_names[arg_7_1 or 1]
	end

	return var_7_0
end

CosmeticUtils.get_weapon_skin_name = function (arg_8_0, arg_8_1)
	-- function 8
	local var_8_0

	if not CosmeticUtils.is_weapon_slot(arg_8_0) then
		var_8_0 = NetworkLookup.weapon_skins[arg_8_1 or 1]
	elseif arg_8_0 == "slot_pose" then
		var_8_0 = NetworkLookup.item_names[arg_8_1 or 1]
	end

	return var_8_0
end

CosmeticUtils.get_cosmetic_id = function (arg_9_0, arg_9_1)
	-- function 9
	if not (arg_9_0 == "slot_frame" or arg_9_0 ~= "slot_skin") then
		return NetworkLookup.cosmetics[arg_9_1 or "default"]
	else
		return NetworkLookup.item_names[arg_9_1 or "n/a"]
	end
end

CosmeticUtils.get_weapon_pose_skin = function (arg_10_0)
	-- function 10
	local var_10_0
	local var_10_1 = ItemMasterList[arg_10_0]
	local get_interface = Managers.backend:get_interface("items")
	local var_10_3 = get_interface:get_equipped_weapon_pose_skins()[var_10_1.parent]

	if not var_10_3 then
		local get_weapon_skin_from_skin_key = get_interface:get_weapon_skin_from_skin_key(var_10_3)

		var_10_0 = not get_weapon_skin_from_skin_key and get_interface:get_item_from_id(get_weapon_skin_from_skin_key)
	end

	return var_10_0
end

CosmeticUtils.get_weapon_skin_id = function (arg_11_0, arg_11_1)
	-- function 11
	local var_11_0

	if not CosmeticUtils.is_weapon_slot(arg_11_0) then
		var_11_0 = NetworkLookup.weapon_skins[arg_11_1 or "n/a"]
	elseif arg_11_0 == "slot_pose" then
		local var_11_1 = ItemMasterList[arg_11_1]
		local get_interface = Managers.backend:get_interface("items")
		local parent = var_11_1.parent
		local get_equipped_weapon_pose_skin = get_interface:get_equipped_weapon_pose_skin(parent)

		if not get_equipped_weapon_pose_skin then
			local var_11_5 = NetworkLookup.item_names[get_equipped_weapon_pose_skin]

			if not var_11_5 then
				var_11_0 = var_11_5
			end
		else
			var_11_0 = NetworkLookup.item_names["n/a"]
		end
	end

	return var_11_0
end

CosmeticUtils.update_cosmetic_slot = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	if not tbl_4[arg_12_1] then
		return
	end

	if not self and (self.local_player or not self.bot_player or not self.is_server or not self:sync_data_active()) then
		local get_cosmetic_id = CosmeticUtils.get_cosmetic_id(arg_12_1, arg_12_2)

		self:set_data(arg_12_1, get_cosmetic_id)

		local var_12_1

		if arg_12_1 == "slot_pose" then
			var_12_1 = CosmeticUtils.get_weapon_skin_id(arg_12_1, arg_12_2)
		elseif not arg_12_3 then
			var_12_1 = CosmeticUtils.get_weapon_skin_id(arg_12_1, arg_12_3)
		end

		if not var_12_1 then
			self:set_data(arg_12_1 .. "_skin", var_12_1)
		end
	end
end

CosmeticUtils.get_cosmetic_slot = function (self, arg_13_1)
	-- function 13
	if not tbl_4[arg_13_1] then
		return nil
	end

	if not self and not self:sync_data_active() then
		local tbl = {}
		local get_data = self:get_data(arg_13_1)

		if not get_data then
			print("[CosmeticUtils] item_id for slot " .. arg_13_1 .. " is nill ")

			return nil
		end

		local var_13_2

		if not (CosmeticUtils.is_weapon_slot(arg_13_1) or arg_13_1 ~= "slot_pose") then
			var_13_2 = self:get_data(arg_13_1 .. "_skin")
		end

		local get_cosmetic_name = CosmeticUtils.get_cosmetic_name(arg_13_1, get_data)

		if not (get_cosmetic_name == "default" or get_cosmetic_name ~= "n/a") then
			get_cosmetic_name = nil
		end

		local get_weapon_skin_name = CosmeticUtils.get_weapon_skin_name(arg_13_1, var_13_2)

		if get_weapon_skin_name == "n/a" then
			get_weapon_skin_name = nil
		end

		tbl.item_name = get_cosmetic_name
		tbl.skin_name = get_weapon_skin_name

		return tbl
	end

	return nil
end

CosmeticUtils.is_weapon_slot = function (arg_14_0)
	-- function 14
	return arg_14_0 == "slot_melee" or arg_14_0 == "slot_ranged"
end

CosmeticUtils.is_valid = function (self)
	-- function 15
	return not self and self.item_name
end

CosmeticUtils.get_default_cosmetic_slot = function (self, arg_16_1)
	-- function 16
	if not tbl_4[arg_16_1] then
		return nil
	end

	if arg_16_1 == "slot_skin" then
		return {
			item_name = self.base_skin
		}
	elseif arg_16_1 == "slot_pose" then
		return {
			item_name = "default_weapon_pose_01"
		}
	elseif not (CosmeticUtils.is_weapon_slot(arg_16_1) or arg_16_1 ~= "slot_hat") then
		local preview_items = self.preview_items

		if not preview_items then
			for i = 1, #preview_items do
				local item_name = preview_items[i].item_name
				local slot_type = ItemMasterList[item_name].slot_type

				if InventorySettings.slot_names_by_type[slot_type][1] == arg_16_1 then
					return {
						item_name = item_name
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

CosmeticUtils.sync_local_player_cosmetics = function (arg_17_0, arg_17_1, arg_17_2)
	-- function 17
	if not arg_17_0 then
		Application.warning("[CosmeticUtils.sync_local_player_cosmetics] Failed to sync cosmetics")

		return
	end

	local var_17_0 = SPProfiles[arg_17_1].careers[arg_17_2]
	local name = var_17_0.name
	local count = #tbl_3
	local preview_items = var_17_0.preview_items

	if not preview_items then
		for i = 1, #preview_items do
			local item_name = preview_items[i].item_name
			local slot_type = ItemMasterList[item_name].slot_type
			local var_17_6 = InventorySettings.slot_names_by_type[slot_type][1]

			CosmeticUtils.update_cosmetic_slot(arg_17_0, var_17_6, item_name)
		end
	end

	CosmeticUtils.update_cosmetic_slot(arg_17_0, "slot_skin", var_17_0.base_skin)

	for j = 1, count do
		local var_17_7 = tbl_3[j]
		local get_loadout_item = BackendUtils.get_loadout_item(name, var_17_7)

		if not get_loadout_item then
			local data = get_loadout_item.data
			local backend_id = get_loadout_item.backend_id
			local get_item_units = BackendUtils.get_item_units(data, backend_id, nil, name)
			local flag = not data and data.name
			local flag_2 = not get_item_units and get_item_units.skin

			CosmeticUtils.update_cosmetic_slot(arg_17_0, var_17_7, flag, flag_2)
		end
	end
end
