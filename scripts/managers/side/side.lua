-- chunkname: @scripts/managers/side/side.lua

SideRelations, SideRelationLookup = table.enum_lookup("ally", "enemy", "neutral")
Side = class(Side)

Side.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._name = arg_1_1.name
	arg_1_0._units = {}
	arg_1_0.units_lookup = {}
	arg_1_0._num_units = 0
	arg_1_0._player_units = {}
	arg_1_0._enemy_sides = {}
	arg_1_0.enemy_sides_lookup = {}
	arg_1_0._enemy_units = {}
	arg_1_0.enemy_units_lookup = {}
	arg_1_0._num_enemy_units = 0
	arg_1_0._enemy_player_units = {}
	arg_1_0._allied_sides = {}
	arg_1_0.allied_sides_lookup = {}
	arg_1_0._allied_units = {}
	arg_1_0.allied_units_lookup = {}
	arg_1_0._num_allied_units = 0
	arg_1_0._neutral_sides = {}
	arg_1_0.neutral_sides_lookup = {}
	arg_1_0.party = arg_1_1.party
	arg_1_0.side_id = arg_1_2
	arg_1_0.broadphase_category = {
		arg_1_1.name
	}
	arg_1_0.enemy_broadphase_categories = {}
	arg_1_0.ally_broadphase_categories = {}
	arg_1_0.neutral_broadphase_categories = {}
	arg_1_0._broadphase_categories_by_relation = {
		[SideRelations.ally] = arg_1_0.ally_broadphase_categories,
		[SideRelations.enemy] = arg_1_0.enemy_broadphase_categories,
		[SideRelations.neutral] = arg_1_0.neutral_broadphase_categories
	}

	local var_1_0 = arg_1_1.add_these_settings

	if var_1_0 then
		for iter_1_0, iter_1_1 in pairs(var_1_0) do
			fassert(not arg_1_0[iter_1_0], "Mechanism trying to add setting that is already defined")

			arg_1_0[iter_1_0] = iter_1_1
		end
	end

	arg_1_0.has_bots = false
	arg_1_0.PLAYER_UNITS = {}
	arg_1_0.PLAYER_POSITIONS = {}
	arg_1_0.PLAYER_AND_BOT_UNITS = {}
	arg_1_0.PLAYER_AND_BOT_POSITIONS = {}
	arg_1_0.NON_DISABLED_PLAYER_AND_BOT_UNITS = {}
	arg_1_0.ENEMY_PLAYER_UNITS = {}
	arg_1_0.ENEMY_PLAYER_POSITIONS = {}
	arg_1_0.ENEMY_PLAYER_AND_BOT_UNITS = {}
	arg_1_0.ENEMY_PLAYER_AND_BOT_POSITIONS = {}
	arg_1_0.VALID_ENEMY_PLAYERS_AND_BOTS = {}
	arg_1_0.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS = {}
	arg_1_0.AI_TARGET_UNITS = {}
end

Side.set_relation = function (arg_2_0, arg_2_1, arg_2_2)
	local var_2_0
	local var_2_1
	local var_2_2

	if arg_2_1 == SideRelations.enemy then
		var_2_0 = arg_2_0._enemy_sides
		var_2_1 = arg_2_0.enemy_sides_lookup
		var_2_2 = arg_2_0.enemy_broadphase_categories
	elseif arg_2_1 == SideRelations.ally then
		var_2_0 = arg_2_0._allied_sides
		var_2_1 = arg_2_0.allied_sides_lookup
		var_2_2 = arg_2_0.ally_broadphase_categories
	elseif arg_2_1 == SideRelations.neutral then
		var_2_0 = arg_2_0._neutral_sides
		var_2_1 = arg_2_0.neutral_sides_lookup
		var_2_2 = arg_2_0.neutral_broadphase_categories
	else
		ferror("Unknown relation (%s)", arg_2_1)
	end

	for iter_2_0 = 1, #arg_2_2 do
		local var_2_3 = arg_2_2[iter_2_0]

		var_2_0[#var_2_0 + 1] = var_2_3
		var_2_1[var_2_3] = true
		var_2_2[#var_2_2 + 1] = var_2_3:name()
	end
end

Side.name = function (arg_3_0)
	return arg_3_0._name
end

Side.get_enemy_sides = function (arg_4_0)
	return arg_4_0._enemy_sides
end

Side.get_allied_sides = function (arg_5_0)
	return arg_5_0._allied_sides
end

Side.add_unit = function (arg_6_0, arg_6_1)
	fassert(arg_6_0.units_lookup[arg_6_1] == nil, "Unit is already added to side.")

	local var_6_0 = arg_6_0._num_units + 1

	arg_6_0._units[var_6_0] = arg_6_1
	arg_6_0.units_lookup[arg_6_1] = var_6_0
	arg_6_0._num_units = var_6_0
end

Side.remove_unit = function (arg_7_0, arg_7_1)
	fassert(arg_7_0.units_lookup[arg_7_1] ~= nil, "Unit has not been added or is already removed from side.")

	local var_7_0 = arg_7_0._units
	local var_7_1 = arg_7_0._num_units
	local var_7_2 = arg_7_0.units_lookup
	local var_7_3 = var_7_2[arg_7_1]
	local var_7_4 = var_7_0[var_7_1]

	var_7_0[var_7_3] = var_7_4
	var_7_2[var_7_4] = var_7_3
	var_7_0[var_7_1] = nil
	var_7_2[arg_7_1] = nil
	arg_7_0._num_units = var_7_1 - 1
end

Side.broadphase_categories_by_relation = function (arg_8_0, arg_8_1)
	return arg_8_0._broadphase_categories_by_relation[arg_8_1]
end

Side.add_enemy_unit = function (arg_9_0, arg_9_1)
	fassert(arg_9_0.enemy_units_lookup[arg_9_1] == nil, "Enemy unit is already added to side.")

	local var_9_0 = arg_9_0._num_enemy_units + 1

	arg_9_0._enemy_units[var_9_0] = arg_9_1
	arg_9_0.enemy_units_lookup[arg_9_1] = var_9_0
	arg_9_0._num_enemy_units = var_9_0
end

Side.remove_enemy_unit = function (arg_10_0, arg_10_1)
	fassert(arg_10_0.enemy_units_lookup[arg_10_1] ~= nil, "Enemy unit has not been added or is already removed from side.")

	local var_10_0 = arg_10_0._enemy_units
	local var_10_1 = arg_10_0._num_enemy_units
	local var_10_2 = arg_10_0.enemy_units_lookup
	local var_10_3 = var_10_2[arg_10_1]
	local var_10_4 = var_10_0[var_10_1]

	var_10_0[var_10_3] = var_10_4
	var_10_2[var_10_4] = var_10_3
	var_10_0[var_10_1] = nil
	var_10_2[arg_10_1] = nil
	arg_10_0._num_enemy_units = var_10_1 - 1
end

Side.add_allied_unit = function (arg_11_0, arg_11_1)
	fassert(arg_11_0.allied_units_lookup[arg_11_1] == nil, "Ally unit is already added to side.")

	local var_11_0 = arg_11_0._num_allied_units + 1

	arg_11_0._allied_units[var_11_0] = arg_11_1
	arg_11_0.allied_units_lookup[arg_11_1] = var_11_0
	arg_11_0._num_allied_units = var_11_0
end

Side.remove_allied_unit = function (arg_12_0, arg_12_1)
	fassert(arg_12_0.allied_units_lookup[arg_12_1] ~= nil, "Ally unit has not been added or is already removed from side.")

	local var_12_0 = arg_12_0._allied_units
	local var_12_1 = arg_12_0._num_allied_units
	local var_12_2 = arg_12_0.allied_units_lookup
	local var_12_3 = var_12_2[arg_12_1]
	local var_12_4 = var_12_0[var_12_1]

	var_12_0[var_12_3] = var_12_4
	var_12_2[var_12_4] = var_12_3
	var_12_0[var_12_1] = nil
	var_12_2[arg_12_1] = nil
	arg_12_0._num_allied_units = var_12_1 - 1
end

Side.add_player_unit = function (arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0._player_units

	fassert(table.find(var_13_0, arg_13_1) == nil, "player_unit has already been added to side.")

	var_13_0[#var_13_0 + 1] = arg_13_1
end

Side.remove_player_unit = function (arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0._player_units
	local var_14_1 = table.find(var_14_0, arg_14_1)

	fassert(var_14_1 ~= false, "player_unit did not get added or has already been removed from side.")
	table.swap_delete(var_14_0, var_14_1)
end

Side.add_enemy_player_unit = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0._enemy_player_units

	fassert(table.find(var_15_0, arg_15_1) == nil, "player_unit has already been added as an enemy.")

	var_15_0[#var_15_0 + 1] = arg_15_1
end

Side.remove_enemy_player_unit = function (arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0._enemy_player_units
	local var_16_1 = table.find(var_16_0, arg_16_1)

	fassert(var_16_1 ~= nil, "player_unit did not get added or has already been removed as an enemy.")
	table.swap_delete(var_16_0, var_16_1)
end

Side.player_units = function (arg_17_0)
	return arg_17_0._player_units
end

Side.enemy_player_units = function (arg_18_0)
	return arg_18_0._enemy_player_units
end

Side.enemy_units = function (arg_19_0)
	return arg_19_0._enemy_units
end
