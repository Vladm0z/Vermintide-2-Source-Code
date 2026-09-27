-- chunkname: @scripts/managers/game_mode/spawning_components/spawning_helper.lua

SpawningHelper = class(SpawningHelper)

local tbl = {
	"slot_healthkit",
	"slot_potion",
	"slot_grenade"
}

SpawningHelper.netpack_consumables = function (self)
	-- function 1
	local tbl_2 = {}

	for i = 1, #tbl do
		local var_1_1 = self[tbl[i]]
		local var_1_2 = rawget(ItemMasterList, var_1_1)

		if not var_1_2 and not var_1_2.skip_sync then
			var_1_1 = "n/a"
		end

		tbl_2[i] = NetworkLookup.item_names[var_1_1]
	end

	return tbl_2
end

SpawningHelper.netpack_additional_items = function (arg_2_0)
	-- function 2
	local tbl = {}

	for k, v in pairs(arg_2_0) do
		local items = v.items

		for k_2 = 1, #items do
			local var_2_2 = items[k_2]

			if not var_2_2.skip_sync then
				local key = var_2_2.key
				local var_2_4 = NetworkLookup.equipment_slots[k]
				local var_2_5 = NetworkLookup.item_names[key]

				tbl[#tbl + 1] = var_2_4
				tbl[#tbl + 1] = var_2_5
			end
		end
	end

	return tbl
end

SpawningHelper.unnetpack_additional_items = function (self)
	-- function 3
	local tbl = {}

	for i = 1, #self, 2 do
		local var_3_1 = tonumber(self[i])
		local var_3_2 = tonumber(self[i + 1])
		local var_3_3 = NetworkLookup.equipment_slots[var_3_1]
		local var_3_4 = NetworkLookup.item_names[var_3_2]

		if not tbl[var_3_3] then
			tbl[var_3_3] = {
				items = {}
			}
		end

		local items = tbl[var_3_3].items

		items[#items + 1] = ItemMasterList[var_3_4]
	end

	return tbl
end

SpawningHelper.fill_consumable_table = function (self, arg_4_1)
	-- function 4
	for i = 1, #tbl do
		local var_4_0 = tbl[i]
		local get_slot_data = arg_4_1:get_slot_data(var_4_0)
		local flag = not get_slot_data and get_slot_data.item_data
		local flag_2 = not flag and flag.key

		if not flag and not flag.skip_sync then
			self[var_4_0] = nil
		else
			self[var_4_0] = flag_2
		end
	end
end

SpawningHelper.default_spawn_items = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not arg_5_2.disable_difficulty_spawning_items then
		for i = 1, #tbl do
			local var_5_0 = tbl[i]

			self[var_5_0] = arg_5_1[var_5_0]
		end
	end
end

SpawningHelper.get_consumable_slot_order = function ()
	-- function 6
	return tbl
end

SpawningHelper.fill_ammo_percentage = function (self, arg_7_1, arg_7_2)
	-- function 7
	local slots = arg_7_1:equipment().slots
	local remote = Managers.player:owner(arg_7_2).remote

	for k, v in pairs(self) do
		local num = 1
		local var_7_3 = slots[k]

		if not var_7_3 then
			local item_data = var_7_3.item_data
			local get_item_template = BackendUtils.get_item_template(item_data)

			if not get_item_template.ammo_data then
				local ammo_hand = get_item_template.ammo_data.ammo_hand

				if not remote then
					num = arg_7_1:ammo_percentage() or num
				elseif ammo_hand ~= "right" or not Unit.alive(var_7_3.right_unit_1p) then
					num = ScriptUnit.extension(var_7_3.right_unit_1p, "ammo_system"):total_ammo_fraction()
				elseif ammo_hand ~= "left" or not Unit.alive(var_7_3.left_unit_1p) then
					num = ScriptUnit.extension(var_7_3.left_unit_1p, "ammo_system"):total_ammo_fraction()
				end
			end
		end

		self[k] = num
	end
end
