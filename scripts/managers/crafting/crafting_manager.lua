-- chunkname: @scripts/managers/crafting/crafting_manager.lua

CraftingManager = class(CraftingManager)
CraftingManager.NAME = "CraftingManager"

CraftingManager.init = function (self)
	-- function 1
	self._crafting_interface = Managers.backend:get_interface("crafting")
end

CraftingManager.update = function (arg_2_0, arg_2_1)
	-- function 2
	return
end

CraftingManager.get_recipes = function (self)
	-- function 3
	return self._crafting_interface:get_recipes()
end

CraftingManager.get_recipes_lookup = function (self)
	-- function 4
	return self._crafting_interface:get_recipes_lookup()
end

CraftingManager.are_recipes_dirty = function (self)
	-- function 5
	return (self._crafting_interface:are_recipes_dirty())
end

CraftingManager.destroy = function (arg_6_0)
	-- function 6
	return
end

CraftingManager.craft = function (self, arg_7_1, arg_7_2)
	-- function 7
	local _crafting_interface = self._crafting_interface
	local tbl = {}

	for k, v in pairs(arg_7_1) do
		tbl[#tbl + 1] = v
	end

	local player = Managers.player
	local local_player = player:local_player()
	local profile_index = local_player:profile_index()
	local name = SPProfiles[profile_index].careers[local_player:career_index()].name
	local craft, var_7_7 = _crafting_interface:craft(name, tbl, arg_7_2)

	if not craft and not var_7_7 then
		local stats_id = local_player:stats_id()
		local statistics_db = player:statistics_db()

		if var_7_7.name == "salvage" then
			local num = statistics_db:get_persistent_stat(stats_id, "salvaged_items") + #arg_7_1

			statistics_db:set_stat(stats_id, "salvaged_items", num)
		else
			statistics_db:increment_stat(stats_id, "crafted_items")
		end

		Managers.backend:commit()
	end

	return craft
end

CraftingManager.debug_set_crafted_items_stat = function (arg_8_0, arg_8_1)
	-- function 8
	local player = Managers.player
	local stats_id = player:local_player():stats_id()

	player:statistics_db():set_stat(stats_id, "crafted_items", arg_8_1)
	Managers.backend:commit()
	print("Number of crafted items set to", arg_8_1)
end

CraftingManager.debug_set_salvaged_items_stat = function (arg_9_0, arg_9_1)
	-- function 9
	local player = Managers.player
	local stats_id = player:local_player():stats_id()

	player:statistics_db():set_stat(stats_id, "salvaged_items", arg_9_1)
	Managers.backend:commit()
	print("Number of salvaged items set to", arg_9_1)
end
