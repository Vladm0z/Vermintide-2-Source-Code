-- chunkname: @scripts/managers/side/side_manager.lua

require("scripts/managers/side/side")

local var_0_0 = script_data.testify and require("scripts/managers/side/side_manager_testify")

SideManager = class(SideManager)
ALL_PLAYER_AND_BOT_UNITS = {}

SideManager.init = function (arg_1_0, arg_1_1)
	arg_1_1[0] = {
		name = "undecided",
		relations = {},
		available_profiles = {},
		party = Managers.party:get_party(0)
	}
	arg_1_0._sides, arg_1_0._side_lookup = arg_1_0:_create_sides(arg_1_1)

	arg_1_0:_setup_relations(arg_1_1, arg_1_0._sides, arg_1_0._side_lookup)

	arg_1_0.side_by_party = arg_1_0:_setup_side_by_party(arg_1_0._sides)
	arg_1_0.side_by_unit = {}
	arg_1_0._player_units_lookup = {}
end

SideManager._create_sides = function (arg_2_0, arg_2_1)
	local var_2_0 = {}
	local var_2_1 = {}

	for iter_2_0 = 0, #arg_2_1 do
		local var_2_2 = arg_2_1[iter_2_0]
		local var_2_3 = var_2_2.name

		fassert(var_2_1[var_2_3] == nil, "Side with the same name exists in side_composition, side_name(%s)", var_2_3)

		local var_2_4 = Side:new(var_2_2, iter_2_0)

		var_2_0[iter_2_0] = var_2_4
		var_2_1[var_2_3] = var_2_4
	end

	fassert(table.is_empty(var_2_0) == false, "No sides specified")

	return var_2_0, var_2_1
end

SideManager._setup_relations = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	for iter_3_0 = 0, #arg_3_1 do
		local var_3_0 = arg_3_1[iter_3_0]
		local var_3_1 = arg_3_2[iter_3_0]
		local var_3_2 = var_3_0.relations

		for iter_3_1, iter_3_2 in pairs(var_3_2) do
			local var_3_3 = {}

			for iter_3_3 = 1, #iter_3_2 do
				local var_3_4 = iter_3_2[iter_3_3]

				fassert(arg_3_3[var_3_4], "Side (%s) does not exist", var_3_4)

				var_3_3[#var_3_3 + 1] = arg_3_3[var_3_4]
			end

			var_3_1:set_relation(iter_3_1, var_3_3)
		end

		var_3_1:set_relation("ally", {
			var_3_1
		})
	end
end

SideManager._setup_side_by_party = function (arg_4_0, arg_4_1)
	local var_4_0 = {}

	for iter_4_0 = 0, #arg_4_1 do
		local var_4_1 = arg_4_1[iter_4_0]
		local var_4_2 = var_4_1.party

		if var_4_2 then
			fassert(var_4_0[var_4_2] == nil, "Party has multiple sides, this is not supported (party_id==%s)", tostring(var_4_2.party_id))

			var_4_0[var_4_2] = var_4_1
		end
	end

	return var_4_0
end

SideManager.sides = function (arg_5_0)
	return arg_5_0._sides
end

SideManager.get_side = function (arg_6_0, arg_6_1)
	return arg_6_0._sides[arg_6_1]
end

SideManager.get_side_from_name = function (arg_7_0, arg_7_1)
	return arg_7_0._side_lookup[arg_7_1]
end

SideManager.get_party_from_side_name = function (arg_8_0, arg_8_1)
	return arg_8_0._side_lookup[arg_8_1].party
end

SideManager.versus_is_hero = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0.side_by_unit[arg_9_1]

	if not var_9_0 or var_9_0:name() ~= "heroes" then
		return
	end

	return not not Managers.player:owner(arg_9_1)
end

SideManager.versus_is_dark_pact = function (arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.side_by_unit[arg_10_1]

	return var_10_0 and var_10_0:name() == "dark_pact"
end

SideManager.add_unit_to_side = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0._sides[arg_11_2]

	var_11_0:add_unit(arg_11_1)

	arg_11_0.side_by_unit[arg_11_1] = var_11_0

	local var_11_1 = var_11_0:get_enemy_sides()

	for iter_11_0 = 1, #var_11_1 do
		var_11_1[iter_11_0]:add_enemy_unit(arg_11_1)
	end

	local var_11_2 = var_11_0:get_allied_sides()

	for iter_11_1 = 1, #var_11_2 do
		var_11_2[iter_11_1]:add_allied_unit(arg_11_1)
	end

	return var_11_0
end

SideManager.remove_unit_from_side = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0.side_by_unit[arg_12_1]

	if not var_12_0 then
		return
	end

	local var_12_1 = var_12_0:get_enemy_sides()

	for iter_12_0 = 1, #var_12_1 do
		var_12_1[iter_12_0]:remove_enemy_unit(arg_12_1)
	end

	local var_12_2 = var_12_0:get_allied_sides()

	for iter_12_1 = 1, #var_12_2 do
		var_12_2[iter_12_1]:remove_allied_unit(arg_12_1)
	end

	arg_12_0.side_by_unit[arg_12_1] = nil

	var_12_0:remove_unit(arg_12_1)
end

SideManager.add_player_unit_to_side = function (arg_13_0, arg_13_1, arg_13_2)
	arg_13_0:add_unit_to_side(arg_13_1, arg_13_2)

	local var_13_0 = arg_13_0._sides[arg_13_2]

	var_13_0:add_player_unit(arg_13_1)

	local var_13_1 = var_13_0:get_enemy_sides()

	for iter_13_0 = 1, #var_13_1 do
		var_13_1[iter_13_0]:add_enemy_player_unit(arg_13_1)
	end

	arg_13_0._player_units_lookup[arg_13_1] = true
end

SideManager.remove_player_unit_from_side = function (arg_14_0, arg_14_1)
	arg_14_0._player_units_lookup[arg_14_1] = nil

	local var_14_0 = arg_14_0.side_by_unit[arg_14_1]
	local var_14_1 = var_14_0:get_enemy_sides()

	for iter_14_0 = 1, #var_14_1 do
		var_14_1[iter_14_0]:remove_enemy_player_unit(arg_14_1)
	end

	var_14_0:remove_player_unit(arg_14_1)
	arg_14_0:remove_unit_from_side(arg_14_1)
	arg_14_0:_remove_player_unit_from_lists(arg_14_1)

	local var_14_2 = Managers.player:owner(arg_14_1)

	Managers.state.event:trigger("on_player_left_side", var_14_2:unique_id(), var_14_2:local_player_id(), var_14_0.side_id)
end

SideManager.is_enemy = function (arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0.side_by_unit[arg_15_1]

	return var_15_0 and var_15_0.enemy_units_lookup[arg_15_2], var_15_0
end

SideManager.is_enemy_by_side = function (arg_16_0, arg_16_1, arg_16_2)
	if arg_16_1 == nil or arg_16_2 == nil then
		return false
	end

	if arg_16_1.enemy_sides_lookup[arg_16_2] == nil then
		return false
	end

	return true
end

SideManager.is_enemy_by_party = function (arg_17_0, arg_17_1, arg_17_2)
	return arg_17_0:is_enemy_by_side(arg_17_0.side_by_party[arg_17_1], arg_17_0.side_by_party[arg_17_2])
end

SideManager.is_enemy_by_player = function (arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = Managers.party:get_party_from_unique_id(arg_18_1:unique_id())
	local var_18_1 = Managers.party:get_party_from_unique_id(arg_18_2:unique_id())

	return arg_18_0:is_enemy_by_party(var_18_0, var_18_1)
end

SideManager.is_ally = function (arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0.side_by_unit[arg_19_1]

	return var_19_0 and var_19_0.allied_units_lookup[arg_19_2], var_19_0
end

SideManager.is_ally_by_side = function (arg_20_0, arg_20_1, arg_20_2)
	if arg_20_1 == nil then
		return false
	end

	if arg_20_1.allied_sides_lookup[arg_20_2] == nil then
		return false
	end

	return true
end

SideManager.is_player_friendly_fire = function (arg_21_0, arg_21_1, arg_21_2)
	if not arg_21_1 or not arg_21_2 then
		return false
	end

	local var_21_0 = arg_21_0._player_units_lookup

	if not var_21_0[arg_21_1] or not var_21_0[arg_21_2] then
		return false
	end

	local var_21_1 = arg_21_0.side_by_unit[arg_21_1]
	local var_21_2 = arg_21_0.side_by_unit[arg_21_2]

	if not var_21_1 or not var_21_2 then
		return false
	end

	return var_21_1 == var_21_2
end

SideManager.destroy = function (arg_22_0)
	arg_22_0._sides = nil
	arg_22_0.side_by_unit = nil
	arg_22_0._player_units_lookup = nil
end

SideManager.remove_aggro_unit = function (arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = arg_23_0._sides[arg_23_1]:get_enemy_sides()
	local var_23_1 = #var_23_0

	for iter_23_0 = 1, var_23_1 do
		local var_23_2 = var_23_0[iter_23_0].AI_TARGET_UNITS
		local var_23_3 = #var_23_2

		for iter_23_1 = 1, var_23_3 do
			if arg_23_2 == var_23_2[iter_23_1] then
				var_23_2[iter_23_1] = var_23_2[var_23_3]
				var_23_2[var_23_3] = nil

				break
			end
		end
	end
end

SideManager.update_frame_tables = function (arg_24_0)
	table.clear(ALL_PLAYER_AND_BOT_UNITS)

	local var_24_0 = arg_24_0._sides
	local var_24_1 = #var_24_0

	for iter_24_0 = 1, var_24_1 do
		local var_24_2 = var_24_0[iter_24_0]

		arg_24_0:_update_frame_tables(var_24_2, ALL_PLAYER_AND_BOT_UNITS)
	end

	for iter_24_1 = 1, var_24_1 do
		local var_24_3 = var_24_0[iter_24_1]

		arg_24_0:_update_ally_frame_tables(var_24_3)
		arg_24_0:_update_enemy_frame_tables(var_24_3)
	end
end

local var_0_1 = Unit.alive

local function var_0_2(arg_25_0)
	return var_0_1(arg_25_0) and not ScriptUnit.extension(arg_25_0, "status_system"):is_ready_for_assisted_respawn()
end

local function var_0_3(arg_26_0)
	local var_26_0 = ScriptUnit.extension(arg_26_0, "status_system")
	local var_26_1 = true

	if var_26_0.in_ghost_mode then
		var_26_1 = false
	end

	return not var_26_0:is_in_end_zone() and not var_26_0:is_invisible() and var_26_1 and not var_26_0.spawn_grace and HEALTH_ALIVE[arg_26_0]
end

SideManager.is_valid_target = var_0_3

local function var_0_4(arg_27_0)
	if not ALIVE[arg_27_0] then
		return false
	end

	local var_27_0 = ScriptUnit.has_extension(arg_27_0, "status_system")

	if var_27_0 then
		return not var_27_0.ready_for_assisted_respawn and not var_27_0:is_in_end_zone() and not var_27_0:is_invisible() and not var_27_0.spawn_grace and HEALTH_ALIVE[arg_27_0]
	end

	return true
end

local var_0_5 = POSITION_LOOKUP

SideManager._update_frame_tables = function (arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_1.PLAYER_UNITS
	local var_28_1 = arg_28_1.PLAYER_POSITIONS
	local var_28_2 = #arg_28_2
	local var_28_3 = arg_28_1.PLAYER_AND_BOT_UNITS
	local var_28_4 = arg_28_1.PLAYER_AND_BOT_POSITIONS
	local var_28_5 = 0
	local var_28_6 = 0
	local var_28_7 = arg_28_1:player_units()
	local var_28_8 = #var_28_7
	local var_28_9 = Managers.player
	local var_28_10 = false

	for iter_28_0 = 1, var_28_8 do
		local var_28_11 = var_28_7[iter_28_0]

		if var_0_2(var_28_11) then
			local var_28_12 = var_0_5[var_28_11]

			var_28_6 = var_28_6 + 1
			var_28_3[var_28_6] = var_28_11
			var_28_4[var_28_6] = var_28_12
			arg_28_2[var_28_2 + iter_28_0] = var_28_11

			if var_28_9:owner(var_28_11):is_player_controlled() then
				var_28_5 = var_28_5 + 1
				var_28_0[var_28_5] = var_28_11
				var_28_1[var_28_5] = var_28_12
			else
				var_28_10 = true
			end
		end
	end

	arg_28_1.has_bots = var_28_10

	local var_28_13 = var_28_5 + 1

	while var_28_0[var_28_13] do
		var_28_0[var_28_13] = nil
		var_28_1[var_28_13] = nil
		var_28_13 = var_28_13 + 1
	end

	local var_28_14 = var_28_6 + 1

	while var_28_3[var_28_14] do
		var_28_3[var_28_14] = nil
		var_28_4[var_28_14] = nil
		var_28_14 = var_28_14 + 1
	end
end

SideManager._update_ally_frame_tables = function (arg_29_0, arg_29_1)
	local var_29_0 = arg_29_1.PLAYER_AND_BOT_UNITS
	local var_29_1 = 0
	local var_29_2 = arg_29_1.NON_DISABLED_PLAYER_AND_BOT_UNITS

	for iter_29_0 = 1, #var_29_0 do
		local var_29_3 = var_29_0[iter_29_0]
		local var_29_4 = ScriptUnit.has_extension(var_29_3, "status_system")

		if var_29_4 and not var_29_4:is_disabled_non_temporarily() then
			var_29_1 = var_29_1 + 1
			var_29_2[var_29_1] = var_29_3
		end
	end

	for iter_29_1 = var_29_1 + 1, #var_29_2 do
		var_29_2[iter_29_1] = nil
	end
end

SideManager._update_enemy_frame_tables = function (arg_30_0, arg_30_1)
	local var_30_0 = arg_30_1.ENEMY_PLAYER_UNITS
	local var_30_1 = arg_30_1.ENEMY_PLAYER_POSITIONS
	local var_30_2 = arg_30_1.ENEMY_PLAYER_AND_BOT_UNITS
	local var_30_3 = arg_30_1.ENEMY_PLAYER_AND_BOT_POSITIONS
	local var_30_4 = arg_30_1.VALID_ENEMY_PLAYERS_AND_BOTS
	local var_30_5 = arg_30_1.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS

	table.clear(var_30_4)
	table.clear(var_30_5)

	local var_30_6 = 0
	local var_30_7 = 0
	local var_30_8 = arg_30_1:enemy_player_units()
	local var_30_9 = #var_30_8
	local var_30_10 = Managers.player

	for iter_30_0 = 1, var_30_9 do
		local var_30_11 = var_30_8[iter_30_0]

		if var_0_2(var_30_11) then
			local var_30_12 = var_0_5[var_30_11]

			var_30_7 = var_30_7 + 1
			var_30_2[var_30_7] = var_30_11
			var_30_3[var_30_7] = var_30_12
			var_30_4[var_30_11] = true

			if var_30_10:owner(var_30_11):is_player_controlled() then
				var_30_6 = var_30_6 + 1
				var_30_0[var_30_6] = var_30_11
				var_30_1[var_30_6] = var_30_12
			end

			if var_0_3(var_30_11) then
				var_30_5[var_30_11] = true
			end
		end
	end

	local var_30_13 = var_30_6 + 1

	while var_30_0[var_30_13] do
		var_30_0[var_30_13] = nil
		var_30_1[var_30_13] = nil
		var_30_13 = var_30_13 + 1
	end

	local var_30_14 = var_30_7 + 1

	while var_30_2[var_30_14] do
		var_30_2[var_30_14] = nil
		var_30_3[var_30_14] = nil
		var_30_14 = var_30_14 + 1
	end

	local var_30_15 = arg_30_1.AI_TARGET_UNITS
	local var_30_16 = Managers.state.entity:system("aggro_system")
	local var_30_17 = arg_30_1:get_enemy_sides()
	local var_30_18 = #var_30_17
	local var_30_19 = 1

	for iter_30_1 = 1, var_30_18 do
		local var_30_20 = var_30_17[iter_30_1]
		local var_30_21 = var_30_16.aggroable_units[var_30_20.side_id]

		for iter_30_2, iter_30_3 in pairs(var_30_21) do
			if var_0_4(iter_30_2) then
				var_30_15[var_30_19] = iter_30_2
				var_30_19 = var_30_19 + 1
			end
		end
	end

	while var_30_15[var_30_19] do
		var_30_15[var_30_19] = nil
		var_30_19 = var_30_19 + 1
	end
end

SideManager._remove_player_unit_from_lists = function (arg_31_0, arg_31_1)
	POSITION_LOOKUP[arg_31_1] = nil

	local var_31_0 = arg_31_0._sides
	local var_31_1 = #var_31_0

	for iter_31_0 = 1, var_31_1 do
		local var_31_2 = var_31_0[iter_31_0]
		local var_31_3 = var_31_2.PLAYER_UNITS
		local var_31_4 = var_31_2.PLAYER_POSITIONS
		local var_31_5 = #var_31_3

		for iter_31_1 = 1, var_31_5 do
			if arg_31_1 == var_31_3[iter_31_1] then
				var_31_3[iter_31_1] = var_31_3[var_31_5]
				var_31_3[var_31_5] = nil
				var_31_4[iter_31_1] = var_31_4[var_31_5]
				var_31_4[var_31_5] = nil

				break
			end
		end

		local var_31_6 = var_31_2.PLAYER_AND_BOT_UNITS
		local var_31_7 = var_31_2.PLAYER_AND_BOT_POSITIONS
		local var_31_8 = #var_31_6

		for iter_31_2 = 1, var_31_8 do
			if arg_31_1 == var_31_6[iter_31_2] then
				var_31_6[iter_31_2] = var_31_6[var_31_8]
				var_31_6[var_31_8] = nil
				var_31_7[iter_31_2] = var_31_7[var_31_8]
				var_31_7[var_31_8] = nil

				break
			end
		end

		local var_31_9 = var_31_2.ENEMY_PLAYER_UNITS
		local var_31_10 = var_31_2.ENEMY_PLAYER_POSITIONS
		local var_31_11 = #var_31_9

		for iter_31_3 = 1, var_31_11 do
			if arg_31_1 == var_31_9[iter_31_3] then
				var_31_9[iter_31_3] = var_31_9[var_31_11]
				var_31_9[var_31_11] = nil
				var_31_10[iter_31_3] = var_31_10[var_31_11]
				var_31_10[var_31_11] = nil

				break
			end
		end

		local var_31_12 = var_31_2.ENEMY_PLAYER_AND_BOT_UNITS
		local var_31_13 = var_31_2.ENEMY_PLAYER_AND_BOT_POSITIONS
		local var_31_14 = #var_31_12

		for iter_31_4 = 1, var_31_14 do
			if arg_31_1 == var_31_12[iter_31_4] then
				var_31_12[iter_31_4] = var_31_12[var_31_14]
				var_31_12[var_31_14] = nil
				var_31_13[iter_31_4] = var_31_13[var_31_14]
				var_31_13[var_31_14] = nil

				break
			end
		end

		var_31_2.VALID_ENEMY_PLAYERS_AND_BOTS[arg_31_1] = nil
		var_31_2.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[arg_31_1] = nil
	end
end

SideManager.get_side_from_player_unique_id = function (arg_32_0, arg_32_1)
	local var_32_0 = Managers.party
	local var_32_1 = var_32_0:get_status_from_unique_id(arg_32_1).party_id
	local var_32_2 = var_32_0:get_party(var_32_1)

	return arg_32_0.side_by_party[var_32_2]
end

SideManager.update_testify = function (arg_33_0, arg_33_1, arg_33_2)
	Testify:poll_requests_through_handler(var_0_0, arg_33_0)
end
