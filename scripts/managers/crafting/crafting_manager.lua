-- chunkname: @scripts/managers/crafting/crafting_manager.lua

CraftingManager = class(CraftingManager)
CraftingManager.NAME = "CraftingManager"

CraftingManager.init = function (arg_1_0)
	arg_1_0._crafting_interface = Managers.backend:get_interface("crafting")
end

CraftingManager.update = function (arg_2_0, arg_2_1)
	return
end

CraftingManager.get_recipes = function (arg_3_0)
	return arg_3_0._crafting_interface:get_recipes()
end

CraftingManager.get_recipes_lookup = function (arg_4_0)
	return arg_4_0._crafting_interface:get_recipes_lookup()
end

CraftingManager.are_recipes_dirty = function (arg_5_0)
	return (arg_5_0._crafting_interface:are_recipes_dirty())
end

CraftingManager.destroy = function (arg_6_0)
	return
end

CraftingManager.craft = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0._crafting_interface
	local var_7_1 = {}

	for iter_7_0, iter_7_1 in pairs(arg_7_1) do
		var_7_1[#var_7_1 + 1] = iter_7_1
	end

	local var_7_2 = Managers.player
	local var_7_3 = var_7_2:local_player()
	local var_7_4 = var_7_3:profile_index()
	local var_7_5 = SPProfiles[var_7_4].careers[var_7_3:career_index()].name
	local var_7_6, var_7_7 = var_7_0:craft(var_7_5, var_7_1, arg_7_2)

	if var_7_6 and var_7_7 then
		local var_7_8 = var_7_3:stats_id()
		local var_7_9 = var_7_2:statistics_db()

		if var_7_7.name == "salvage" then
			local var_7_10 = var_7_9:get_persistent_stat(var_7_8, "salvaged_items") + #arg_7_1

			var_7_9:set_stat(var_7_8, "salvaged_items", var_7_10)
		else
			var_7_9:increment_stat(var_7_8, "crafted_items")
		end

		Managers.backend:commit()
	end

	return var_7_6
end

CraftingManager.debug_set_crafted_items_stat = function (arg_8_0, arg_8_1)
	local var_8_0 = Managers.player
	local var_8_1 = var_8_0:local_player():stats_id()

	var_8_0:statistics_db():set_stat(var_8_1, "crafted_items", arg_8_1)
	Managers.backend:commit()
	print("Number of crafted items set to", arg_8_1)
end

CraftingManager.debug_set_salvaged_items_stat = function (arg_9_0, arg_9_1)
	local var_9_0 = Managers.player
	local var_9_1 = var_9_0:local_player():stats_id()

	var_9_0:statistics_db():set_stat(var_9_1, "salvaged_items", arg_9_1)
	Managers.backend:commit()
	print("Number of salvaged items set to", arg_9_1)
end
