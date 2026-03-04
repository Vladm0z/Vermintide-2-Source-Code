-- chunkname: @scripts/managers/game_mode/spawning_components/spawning_helper.lua

SpawningHelper = class(SpawningHelper)

local var_0_0 = {
	"slot_healthkit",
	"slot_potion",
	"slot_grenade"
}

SpawningHelper.netpack_consumables = function (arg_1_0)
	local var_1_0 = {}

	for iter_1_0 = 1, #var_0_0 do
		local var_1_1 = arg_1_0[var_0_0[iter_1_0]]
		local var_1_2 = rawget(ItemMasterList, var_1_1)

		if not var_1_2 or var_1_2.skip_sync then
			var_1_1 = "n/a"
		end

		var_1_0[iter_1_0] = NetworkLookup.item_names[var_1_1]
	end

	return var_1_0
end

SpawningHelper.netpack_additional_items = function (arg_2_0)
	local var_2_0 = {}

	for iter_2_0, iter_2_1 in pairs(arg_2_0) do
		local var_2_1 = iter_2_1.items

		for iter_2_2 = 1, #var_2_1 do
			local var_2_2 = var_2_1[iter_2_2]

			if not var_2_2.skip_sync then
				local var_2_3 = var_2_2.key
				local var_2_4 = NetworkLookup.equipment_slots[iter_2_0]
				local var_2_5 = NetworkLookup.item_names[var_2_3]

				var_2_0[#var_2_0 + 1] = var_2_4
				var_2_0[#var_2_0 + 1] = var_2_5
			end
		end
	end

	return var_2_0
end

SpawningHelper.unnetpack_additional_items = function (arg_3_0)
	local var_3_0 = {}

	for iter_3_0 = 1, #arg_3_0, 2 do
		local var_3_1 = tonumber(arg_3_0[iter_3_0])
		local var_3_2 = tonumber(arg_3_0[iter_3_0 + 1])
		local var_3_3 = NetworkLookup.equipment_slots[var_3_1]
		local var_3_4 = NetworkLookup.item_names[var_3_2]

		if not var_3_0[var_3_3] then
			var_3_0[var_3_3] = {
				items = {}
			}
		end

		local var_3_5 = var_3_0[var_3_3].items

		var_3_5[#var_3_5 + 1] = ItemMasterList[var_3_4]
	end

	return var_3_0
end

SpawningHelper.fill_consumable_table = function (arg_4_0, arg_4_1)
	for iter_4_0 = 1, #var_0_0 do
		local var_4_0 = var_0_0[iter_4_0]
		local var_4_1 = arg_4_1:get_slot_data(var_4_0)
		local var_4_2 = var_4_1 and var_4_1.item_data
		local var_4_3 = var_4_2 and var_4_2.key

		if not var_4_2 or var_4_2.skip_sync then
			arg_4_0[var_4_0] = nil
		else
			arg_4_0[var_4_0] = var_4_3
		end
	end
end

SpawningHelper.default_spawn_items = function (arg_5_0, arg_5_1, arg_5_2)
	if not arg_5_2.disable_difficulty_spawning_items then
		for iter_5_0 = 1, #var_0_0 do
			local var_5_0 = var_0_0[iter_5_0]

			arg_5_0[var_5_0] = arg_5_1[var_5_0]
		end
	end
end

SpawningHelper.get_consumable_slot_order = function ()
	return var_0_0
end

SpawningHelper.fill_ammo_percentage = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_1:equipment().slots
	local var_7_1 = Managers.player:owner(arg_7_2).remote

	for iter_7_0, iter_7_1 in pairs(arg_7_0) do
		local var_7_2 = 1
		local var_7_3 = var_7_0[iter_7_0]

		if var_7_3 then
			local var_7_4 = var_7_3.item_data
			local var_7_5 = BackendUtils.get_item_template(var_7_4)

			if var_7_5.ammo_data then
				local var_7_6 = var_7_5.ammo_data.ammo_hand

				if var_7_1 then
					var_7_2 = arg_7_1:ammo_percentage() or var_7_2
				elseif var_7_6 == "right" and Unit.alive(var_7_3.right_unit_1p) then
					var_7_2 = ScriptUnit.extension(var_7_3.right_unit_1p, "ammo_system"):total_ammo_fraction()
				elseif var_7_6 == "left" and Unit.alive(var_7_3.left_unit_1p) then
					var_7_2 = ScriptUnit.extension(var_7_3.left_unit_1p, "ammo_system"):total_ammo_fraction()
				end
			end
		end

		arg_7_0[iter_7_0] = var_7_2
	end
end
