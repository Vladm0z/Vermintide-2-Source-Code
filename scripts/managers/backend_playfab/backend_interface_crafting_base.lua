-- chunkname: @scripts/managers/backend_playfab/backend_interface_crafting_base.lua

require("scripts/settings/crafting/crafting_data")

BackendInterfaceCraftingBase = class(BackendInterfaceCraftingBase)

local var_0_0, var_0_1, var_0_2 = dofile("scripts/settings/crafting/crafting_recipes")

function BackendInterfaceCraftingBase.init(arg_1_0)
	arg_1_0._crafting_recipes = var_0_0
	arg_1_0._crafting_recipes_by_name = var_0_1
	arg_1_0._crafting_recipes_lookup = var_0_2
end

function BackendInterfaceCraftingBase.get_recipes(arg_2_0)
	return arg_2_0._crafting_recipes
end

function BackendInterfaceCraftingBase.get_recipe_by_name(arg_3_0, arg_3_1)
	return arg_3_0._crafting_recipes_by_name[arg_3_1]
end

function BackendInterfaceCraftingBase.get_recipes_lookup(arg_4_0)
	return arg_4_0._crafting_recipes_lookup
end

function BackendInterfaceCraftingBase._get_valid_recipe(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0._crafting_recipes

	if arg_5_2 then
		local var_5_1 = var_0_1[arg_5_2]
		local var_5_2, var_5_3 = arg_5_0[var_5_1.validation_function](arg_5_0, var_5_1, arg_5_1)

		if var_5_2 then
			return var_5_1, var_5_3
		end

		return
	end

	for iter_5_0 = 1, #var_5_0 do
		local var_5_4 = var_5_0[iter_5_0]
		local var_5_5, var_5_6 = arg_5_0[var_5_4.validation_function](arg_5_0, var_5_4, arg_5_1)

		if var_5_5 then
			return var_5_4, var_5_6
		end
	end
end

local var_0_3 = {}

function BackendInterfaceCraftingBase.salvage_validation_func(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = Managers.backend:get_interface("items")
	local var_6_1 = arg_6_1.salvagable_slot_types

	table.clear(var_0_3)

	for iter_6_0 = 1, #arg_6_2 do
		local var_6_2 = arg_6_2[iter_6_0]
		local var_6_3 = var_6_0:get_item_masterlist_data(var_6_2)
		local var_6_4 = var_6_3 and var_6_3.slot_type

		if var_6_4 and not var_6_1[var_6_4] then
			return false
		end

		if var_6_3 then
			var_0_3[#var_0_3 + 1] = {
				amount = 1,
				backend_id = var_6_2
			}
		end
	end

	if #var_0_3 == 0 then
		return false
	end

	return true, var_0_3
end

function BackendInterfaceCraftingBase.craft_validation_func(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_1.ingredients
	local var_7_1 = table.clone(arg_7_2)
	local var_7_2 = 0

	table.clear(var_0_3)

	for iter_7_0 = 1, #var_7_0 do
		local var_7_3 = var_7_0[iter_7_0]
		local var_7_4 = var_7_3.amount
		local var_7_5, var_7_6 = arg_7_0:_validate_ingredient(var_7_3, var_7_1)
		local var_7_7 = var_7_3.multiple_check_func

		if var_7_5 and var_7_7 then
			var_7_5 = arg_7_0[var_7_7](arg_7_0, var_7_6)
		end

		if var_7_5 then
			var_7_2 = var_7_2 + 1

			for iter_7_1, iter_7_2 in ipairs(var_7_6) do
				var_0_3[#var_0_3 + 1] = iter_7_2
			end
		end
	end

	if var_7_2 ~= #var_7_0 or #var_7_1 > 0 then
		return false
	end

	return true, var_0_3
end

local var_0_4 = {}

function BackendInterfaceCraftingBase._validate_ingredient(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = Managers.backend:get_interface("items")
	local var_8_1 = arg_8_1.name
	local var_8_2 = arg_8_1.catergory
	local var_8_3 = arg_8_1.has_variable
	local var_8_4 = arg_8_1.amount or 1
	local var_8_5 = 0

	table.clear(var_0_4)

	for iter_8_0 = 1, #arg_8_2 do
		repeat
			local var_8_6 = arg_8_2[iter_8_0]
			local var_8_7 = var_8_0:get_item_masterlist_data(var_8_6)
			local var_8_8 = var_8_7 and var_8_7.name

			if not var_8_8 or var_8_1 and var_8_1 ~= var_8_8 then
				break
			end

			if var_8_2 then
				local var_8_9 = CraftingData[var_8_2.category_table]
				local var_8_10 = var_8_7[var_8_2.item_value]

				if not table.contains(var_8_9, var_8_10) then
					break
				end
			end

			if var_8_3 and not item_data[var_8_3] then
				break
			end

			local var_8_11 = var_8_7.can_stack
			local var_8_12
			local var_8_13 = var_8_0:get_item_amount(var_8_6)

			if var_8_11 and var_8_13 < var_8_4 then
				break
			else
				var_8_12 = not var_8_11 and 1 or var_8_4
			end

			var_8_5 = var_8_5 + var_8_12
			var_0_4[#var_0_4 + 1] = {
				backend_id = var_8_6,
				amount = var_8_12
			}

			if var_8_5 == var_8_4 then
				for iter_8_1 = 1, #var_0_4 do
					local var_8_14 = var_0_4[iter_8_1].backend_id
					local var_8_15 = table.find(arg_8_2, var_8_14)

					table.remove(arg_8_2, var_8_15)
				end

				return true, var_0_4
			end
		until true
	end

	return false
end

function BackendInterfaceCraftingBase.weapon_skin_application_validation_func(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_1.ingredients
	local var_9_1 = Managers.backend:get_interface("items")
	local var_9_2 = table.clone(arg_9_2)

	table.clear(var_0_3)

	local var_9_3
	local var_9_4

	for iter_9_0 = 1, #var_9_2 do
		local var_9_5 = var_9_2[iter_9_0]
		local var_9_6 = var_9_1:get_item_from_id(var_9_5)

		if not var_9_6 then
			return false
		end

		local var_9_7 = var_9_6.data
		local var_9_8 = var_9_7.slot_type

		if table.find(CraftingData.weapon_slot_types, var_9_8) then
			var_9_3 = var_9_7.name
			var_0_3[#var_0_3 + 1] = {
				amount = 1,
				backend_id = var_9_5
			}
		end

		if table.find(CraftingData.weapon_skin_slot_types, var_9_8) then
			var_9_4 = var_9_6.skin
			var_0_3[#var_0_3 + 1] = {
				skin_name = var_9_4
			}
		end

		if var_9_8 == "crafting_material" then
			for iter_9_1, iter_9_2 in ipairs(var_9_0) do
				if iter_9_2.name and iter_9_2.amount and iter_9_2.name == var_9_6.ItemId then
					var_0_3[#var_0_3 + 1] = {
						backend_id = var_9_5,
						amount = iter_9_2.amount
					}
				end
			end
		end
	end

	if #var_0_3 ~= 2 then
		return false
	end

	if not var_9_3 or not var_9_4 then
		return false
	end

	if not WeaponSkins.is_matching_skin(var_9_3, var_9_4) then
		return false
	end

	return true, var_0_3
end

function BackendInterfaceCraftingBase.check_same_item_func(arg_10_0, arg_10_1)
	local var_10_0 = Managers.backend:get_interface("items")
	local var_10_1

	for iter_10_0, iter_10_1 in ipairs(arg_10_1) do
		local var_10_2 = iter_10_1.backend_id
		local var_10_3 = var_10_0:get_item_masterlist_data(var_10_2).name

		var_10_1 = var_10_1 or var_10_3

		if var_10_1 ~= var_10_3 then
			return false
		end
	end

	return true
end

function BackendInterfaceCraftingBase.check_has_skin(arg_11_0, arg_11_1)
	local var_11_0 = Managers.backend:get_interface("items")
	local var_11_1 = arg_11_1[1].backend_id

	if var_11_0:get_item_from_id(var_11_1).skin then
		return true
	end

	return false
end
