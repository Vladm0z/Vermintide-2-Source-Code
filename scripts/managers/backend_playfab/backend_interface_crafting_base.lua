-- chunkname: @scripts/managers/backend_playfab/backend_interface_crafting_base.lua

require("scripts/settings/crafting/crafting_data")

BackendInterfaceCraftingBase = class(BackendInterfaceCraftingBase)

local var_0_0, var_0_1, var_0_2 = dofile("scripts/settings/crafting/crafting_recipes")

BackendInterfaceCraftingBase.init = function (self)
	-- function 1
	self._crafting_recipes = var_0_0
	self._crafting_recipes_by_name = var_0_1
	self._crafting_recipes_lookup = var_0_2
end

BackendInterfaceCraftingBase.get_recipes = function (self)
	-- function 2
	return self._crafting_recipes
end

BackendInterfaceCraftingBase.get_recipe_by_name = function (self, arg_3_1)
	-- function 3
	return self._crafting_recipes_by_name[arg_3_1]
end

BackendInterfaceCraftingBase.get_recipes_lookup = function (self)
	-- function 4
	return self._crafting_recipes_lookup
end

BackendInterfaceCraftingBase._get_valid_recipe = function (self, arg_5_1, arg_5_2)
	-- function 5
	local _crafting_recipes = self._crafting_recipes

	if not arg_5_2 then
		local var_5_1 = var_0_1[arg_5_2]
		local var_5_2, var_5_3 = self[var_5_1.validation_function](self, var_5_1, arg_5_1)

		if not var_5_2 then
			return var_5_1, var_5_3
		end

		return
	end

	for i = 1, #_crafting_recipes do
		local var_5_4 = _crafting_recipes[i]
		local var_5_5, var_5_6 = self[var_5_4.validation_function](self, var_5_4, arg_5_1)

		if not var_5_5 then
			return var_5_4, var_5_6
		end
	end
end

local tbl = {}

BackendInterfaceCraftingBase.salvage_validation_func = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local get_interface = Managers.backend:get_interface("items")
	local salvagable_slot_types = arg_6_1.salvagable_slot_types

	table.clear(tbl)

	for i = 1, #arg_6_2 do
		local var_6_2 = arg_6_2[i]
		local get_item_masterlist_data = get_interface:get_item_masterlist_data(var_6_2)
		local flag = not get_item_masterlist_data and get_item_masterlist_data.slot_type

		if not (not flag and salvagable_slot_types[flag]) then
			return false
		end

		if not get_item_masterlist_data then
			tbl[#tbl + 1] = {
				amount = 1,
				backend_id = var_6_2
			}
		end
	end

	if #tbl == 0 then
		return false
	end

	return true, tbl
end

BackendInterfaceCraftingBase.craft_validation_func = function (self, arg_7_1, arg_7_2)
	-- function 7
	local ingredients = arg_7_1.ingredients
	local clone = table.clone(arg_7_2)
	local num = 0

	table.clear(tbl)

	for i = 1, #ingredients do
		local var_7_3 = ingredients[i]
		local amount = var_7_3.amount
		local _validate_ingredient, var_7_6 = self:_validate_ingredient(var_7_3, clone)
		local multiple_check_func = var_7_3.multiple_check_func

		if not _validate_ingredient and not multiple_check_func then
			_validate_ingredient = self[multiple_check_func](self, var_7_6)
		end

		if not _validate_ingredient then
			num = num + 1

			for i_2, v in ipairs(var_7_6) do
				tbl[#tbl + 1] = v
			end
		end
	end

	if not (num ~= #ingredients or not (#clone > 0)) then
		return false
	end

	return true, tbl
end

local tbl_2 = {}

BackendInterfaceCraftingBase._validate_ingredient = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	local get_interface = Managers.backend:get_interface("items")
	local name = arg_8_1.name
	local catergory = arg_8_1.catergory
	local has_variable = arg_8_1.has_variable
	local amount = arg_8_1.amount

	amount = amount or 1

	local num = 0

	table.clear(tbl_2)

	for i = 1, #arg_8_2 do
		repeat
			local var_8_6 = arg_8_2[i]
			local get_item_masterlist_data = get_interface:get_item_masterlist_data(var_8_6)
			local flag = not get_item_masterlist_data and get_item_masterlist_data.name

			if not (not flag and not name and name == flag) then
				break
			end

			if not catergory then
				local var_8_9 = CraftingData[catergory.category_table]
				local var_8_10 = get_item_masterlist_data[catergory.item_value]

				if not table.contains(var_8_9, var_8_10) then
					break
				end
			end

			if not (not has_variable and item_data[has_variable]) then
				break
			end

			local can_stack = get_item_masterlist_data.can_stack
			local var_8_12
			local get_item_amount = get_interface:get_item_amount(var_8_6)

			if not (not can_stack and not (get_item_amount < amount)) then
				break
			else
				var_8_12 = can_stack or not 1 or amount
			end

			num = num + var_8_12
			tbl_2[#tbl_2 + 1] = {
				backend_id = var_8_6,
				amount = var_8_12
			}

			if num == amount then
				for j = 1, #tbl_2 do
					local backend_id = tbl_2[j].backend_id
					local find = table.find(arg_8_2, backend_id)

					table.remove(arg_8_2, find)
				end

				return true, tbl_2
			end
		until true
	end

	return false
end

BackendInterfaceCraftingBase.weapon_skin_application_validation_func = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	local ingredients = arg_9_1.ingredients
	local get_interface = Managers.backend:get_interface("items")
	local clone = table.clone(arg_9_2)

	table.clear(tbl)

	local var_9_3
	local var_9_4

	for i = 1, #clone do
		local var_9_5 = clone[i]
		local get_item_from_id = get_interface:get_item_from_id(var_9_5)

		if not get_item_from_id then
			return false
		end

		local data = get_item_from_id.data
		local slot_type = data.slot_type

		if not table.find(CraftingData.weapon_slot_types, slot_type) then
			var_9_3 = data.name
			tbl[#tbl + 1] = {
				amount = 1,
				backend_id = var_9_5
			}
		end

		if not table.find(CraftingData.weapon_skin_slot_types, slot_type) then
			var_9_4 = get_item_from_id.skin
			tbl[#tbl + 1] = {
				skin_name = var_9_4
			}
		end

		if slot_type == "crafting_material" then
			for i_2, v in ipairs(ingredients) do
				if not (not v.name and not v.amount and v.name ~= get_item_from_id.ItemId) then
					tbl[#tbl + 1] = {
						backend_id = var_9_5,
						amount = v.amount
					}
				end
			end
		end
	end

	if #tbl ~= 2 then
		return false
	end

	if not (not var_9_3 and var_9_4) then
		return false
	end

	if not WeaponSkins.is_matching_skin(var_9_3, var_9_4) then
		return false
	end

	return true, tbl
end

BackendInterfaceCraftingBase.check_same_item_func = function (arg_10_0, arg_10_1)
	-- function 10
	local get_interface = Managers.backend:get_interface("items")
	local var_10_1

	for i, v in ipairs(arg_10_1) do
		local backend_id = v.backend_id
		local name = get_interface:get_item_masterlist_data(backend_id).name

		var_10_1 = var_10_1 or name

		if var_10_1 ~= name then
			return false
		end
	end

	return true
end

BackendInterfaceCraftingBase.check_has_skin = function (arg_11_0, arg_11_1)
	-- function 11
	local get_interface = Managers.backend:get_interface("items")
	local backend_id = arg_11_1[1].backend_id

	if not get_interface:get_item_from_id(backend_id).skin then
		return true
	end

	return false
end
