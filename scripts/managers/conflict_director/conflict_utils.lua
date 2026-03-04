-- chunkname: @scripts/managers/conflict_director/conflict_utils.lua

require("scripts/settings/breeds")
require("scripts/settings/patrol_formation_settings")
require("scripts/managers/conflict_director/breed_packs")
require("scripts/managers/conflict_director/encampment_templates")

ConflictUtils = {}

local var_0_0 = ConflictUtils
local var_0_1 = Vector3.distance_squared
local var_0_2 = Math.random
local var_0_3 = Quaternion.look

local function var_0_4(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_0.difficulty_overrides
	local var_1_1 = var_1_0 and (var_1_0[arg_1_2] or var_1_0[arg_1_3])

	return var_1_1 and var_1_1[arg_1_1] or arg_1_0[arg_1_1]
end

var_0_0.random_interval = function (arg_2_0)
	if type(arg_2_0) == "table" then
		return var_0_2(arg_2_0[1], arg_2_0[2])
	else
		return arg_2_0
	end
end

local var_0_5 = {}
local var_0_6 = {}
local var_0_7 = {
	false,
	false,
	false
}

var_0_0.cluster_positions = function (arg_3_0, arg_3_1)
	local var_3_0 = {
		arg_3_0[1]
	}
	local var_3_1 = var_0_5

	var_3_1[1] = 1
	var_0_6[1] = 1
	arg_3_1 = arg_3_1 * arg_3_1

	local var_3_2 = var_0_7

	for iter_3_0 = 1, 3 do
		var_3_2[iter_3_0] = nil
	end

	for iter_3_1 = 2, #arg_3_0 do
		var_3_2[iter_3_1 - 1] = iter_3_1
	end

	local var_3_3 = #var_3_2

	while var_3_3 > 0 do
		local var_3_4 = false

		for iter_3_2 = 1, #var_3_0 do
			for iter_3_3 = 1, var_3_3 do
				local var_3_5 = var_3_2[iter_3_3]

				if arg_3_1 > Vector3.distance_squared(var_3_0[iter_3_2], arg_3_0[var_3_5]) then
					var_3_2[iter_3_3] = var_3_2[var_3_3]
					var_3_3 = var_3_3 - 1
					var_0_6[var_3_5] = iter_3_2
					var_3_1[iter_3_2] = var_3_1[iter_3_2] + 1
					var_3_4 = true

					break
				end
			end
		end

		if not var_3_4 then
			local var_3_6 = #var_3_0 + 1
			local var_3_7 = var_3_2[1]

			var_3_0[var_3_6] = arg_3_0[var_3_7]
			var_0_6[var_3_7] = var_3_6
			var_3_1[var_3_6] = 1
			var_3_2[1] = var_3_2[var_3_3]
			var_3_3 = var_3_3 - 1
		end
	end

	for iter_3_4 = #var_3_0 + 1, #var_3_1 do
		var_3_1[iter_3_4] = nil
	end

	return var_3_0, var_3_1, var_0_6
end

local var_0_8 = {}
local var_0_9 = {
	1,
	2,
	3,
	6
}

var_0_0.cluster_weight_and_loneliness = function (arg_4_0, arg_4_1)
	local var_4_0 = Vector3.distance_squared

	arg_4_1 = arg_4_1 * arg_4_1

	local var_4_1 = math.min(#arg_4_0, 4)

	if var_4_1 == 1 then
		return 1, 1, 100
	elseif var_4_1 == 0 then
		return 0, 0, 0
	end

	local var_4_2 = arg_4_0[1]
	local var_4_3 = arg_4_0[2]
	local var_4_4 = arg_4_0[3]
	local var_4_5 = arg_4_0[4]
	local var_4_6 = 0
	local var_4_7 = 0
	local var_4_8 = 0
	local var_4_9 = 0
	local var_4_10 = 0
	local var_4_11 = 0
	local var_4_12 = 0

	if var_4_5 then
		var_4_9 = var_4_0(var_4_2, var_4_5)
		var_4_11 = var_4_0(var_4_3, var_4_5)
		var_4_12 = var_4_0(var_4_4, var_4_5)
		var_4_6 = var_4_6 + (var_4_9 < arg_4_1 and 1 or 0)
		var_4_6 = var_4_6 + (var_4_11 < arg_4_1 and 1 or 0)
		var_4_6 = var_4_6 + (var_4_12 < arg_4_1 and 1 or 0)
		var_0_8[4] = var_4_9 + var_4_11 + var_4_12
	end

	if var_4_4 then
		var_4_8 = var_4_0(var_4_2, var_4_4)
		var_4_10 = var_4_0(var_4_3, var_4_4)
		var_4_6 = var_4_6 + (var_4_8 < arg_4_1 and 1 or 0)
		var_4_6 = var_4_6 + (var_4_10 < arg_4_1 and 1 or 0)
		var_0_8[3] = var_4_8 + var_4_10 + var_4_12
	end

	if var_4_3 then
		var_4_7 = var_4_0(var_4_2, var_4_3)
		var_4_6 = var_4_6 + (var_4_7 < arg_4_1 and 1 or 0)
		var_0_8[2] = var_4_7 + var_4_10 + var_4_11
	end

	var_0_8[1] = var_4_7 + var_4_8 + var_4_9

	local var_4_13 = var_4_6 / var_0_9[var_4_1]
	local var_4_14 = 0
	local var_4_15 = 1

	for iter_4_0 = 1, var_4_1 do
		if var_4_14 < var_0_8[iter_4_0] then
			var_4_14 = var_0_8[iter_4_0]
			var_4_15 = iter_4_0
		end
	end

	local var_4_16 = math.sqrt(var_4_14) / var_4_1

	return var_4_13, var_4_15, var_4_16, var_0_8
end

var_0_0.average_player_position = function ()
	local var_5_0 = 0
	local var_5_1 = Vector3.zero()
	local var_5_2 = Managers.player:human_and_bot_players()

	for iter_5_0, iter_5_1 in pairs(var_5_2) do
		local var_5_3 = iter_5_1.player_unit

		if ALIVE[var_5_3] then
			var_5_1 = var_5_1 + POSITION_LOOKUP[var_5_3]
			var_5_0 = var_5_0 + 1
		end
	end

	if var_5_0 == 0 then
		return nil
	end

	return var_5_1 * (1 / var_5_0)
end

local var_0_10 = {}
local var_0_11 = {}

var_0_0.hidden_cover_points = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = Managers.state.conflict.level_analysis.cover_points_broadphase

	arg_6_2 = arg_6_2 * arg_6_2
	arg_6_4 = arg_6_4 and math.max(arg_6_4, -0.9) or -0.9

	local var_6_1 = 40
	local var_6_2 = Broadphase.query(var_6_0, arg_6_0, math.min(arg_6_3, var_6_1), var_0_10)
	local var_6_3 = Vector3.normalize
	local var_6_4 = Quaternion.forward
	local var_6_5 = Unit.local_rotation
	local var_6_6 = Unit.local_position
	local var_6_7 = Vector3.dot
	local var_6_8 = 0
	local var_6_9 = #arg_6_1

	for iter_6_0 = 1, var_6_2 do
		local var_6_10 = var_0_10[iter_6_0]
		local var_6_11 = var_6_6(var_6_10, 0)
		local var_6_12 = var_0_1(var_6_11, arg_6_0)

		if arg_6_2 <= var_6_12 then
			local var_6_13 = var_6_5(var_6_10, 0)
			local var_6_14 = 0

			for iter_6_1 = 1, var_6_9 do
				local var_6_15 = arg_6_1[iter_6_1]
				local var_6_16 = var_6_3(var_6_11 - var_6_15)

				Vector3.set_z(var_6_16, 0)

				if (var_6_12 < 50 and arg_6_4 or -0.6) > var_6_7(var_6_4(var_6_13), var_6_16) then
					var_6_14 = var_6_14 + 1
				else
					break
				end
			end

			if var_6_9 == var_6_14 then
				var_6_8 = var_6_8 + 1
				var_0_11[var_6_8] = var_6_10
			end
		end
	end

	return var_6_8, var_0_11
end

var_0_0.debug_is_cover_point_hidden = function ()
	local var_7_0 = Managers.state.conflict.level_analysis.cover_points_broadphase
	local var_7_1 = Broadphase.query(var_7_0, PLAYER_POSITIONS[1], 20, var_0_10)
	local var_7_2 = Colors.get("red")
	local var_7_3 = Colors.get("green")
	local var_7_4 = Unit.local_rotation
	local var_7_5 = Unit.local_position
	local var_7_6 = 5

	for iter_7_0 = 1, var_7_1 do
		local var_7_7 = var_0_10[iter_7_0]
		local var_7_8 = var_7_5(var_7_7, 0)
		local var_7_9 = var_7_4(var_7_7, 0)

		if var_0_0.is_cover_point_hidden(var_7_7, PLAYER_POSITIONS, var_7_6) then
			QuickDrawer:sphere(var_7_8, 0.8, var_7_3)
			QuickDrawer:line(var_7_8 + Vector3(0, 0, 1), var_7_8 + Quaternion.forward(var_7_9) * 2 + Vector3(0, 0, 1), var_7_3)
		else
			QuickDrawer:sphere(var_7_8, 0.8, var_7_2)
			QuickDrawer:line(var_7_8 + Vector3(0, 0, 1), var_7_8 + Quaternion.forward(var_7_9) * 2 + Vector3(0, 0, 1), var_7_2)
		end
	end
end

var_0_0.is_cover_point_hidden = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = Vector3.normalize
	local var_8_1 = Quaternion.forward
	local var_8_2 = Unit.local_rotation
	local var_8_3 = Unit.local_position
	local var_8_4 = Vector3.dot
	local var_8_5 = arg_8_3 or 10000
	local var_8_6 = var_8_3(arg_8_0, 0)
	local var_8_7 = var_8_2(arg_8_0, 0)
	local var_8_8 = #arg_8_1
	local var_8_9 = 0

	for iter_8_0 = 1, var_8_8 do
		local var_8_10 = arg_8_1[iter_8_0]
		local var_8_11 = var_0_1(var_8_6, var_8_10)

		if var_8_11 < arg_8_2 then
			break
		end

		local var_8_12 = var_8_0(var_8_6 - var_8_10)

		if (var_8_11 < 225 and -0.9 or -0.6) > var_8_4(var_8_1(var_8_7), var_8_12) or var_8_5 < var_8_11 then
			var_8_9 = var_8_9 + 1
		else
			break
		end
	end

	if var_8_9 == var_8_8 then
		return true
	end
end

var_0_0.get_random_spawner_with_id = function (arg_9_0, arg_9_1)
	local var_9_0 = Managers.state.entity:system("spawner_system")._id_lookup[arg_9_0]

	if var_9_0 then
		local var_9_1 = #var_9_0
		local var_9_2 = Math.random(1, var_9_1)
		local var_9_3 = var_9_0[var_9_2]

		if var_9_1 > 1 and var_9_3 == arg_9_1 then
			var_9_2 = (var_9_2 - 1) % var_9_1 + 1
			var_9_3 = var_9_0[var_9_2]
		end

		return var_9_3, var_9_2
	end
end

var_0_0.get_random_hidden_spawner = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = Managers.state.entity:system("spawner_system")
	local var_10_1 = Broadphase.query(var_10_0.hidden_spawners_broadphase, arg_10_0, arg_10_1, var_0_10)

	if var_10_1 <= 0 then
		return
	end

	if arg_10_2 then
		return var_0_10[1]
	end

	local var_10_2 = math.random(1, var_10_1)

	return var_0_10[var_10_2]
end

var_0_0.get_biggest_cluster = function (arg_11_0)
	local var_11_0 = 1

	for iter_11_0 = 2, #arg_11_0 do
		local var_11_1 = arg_11_0[iter_11_0]

		if var_11_1 then
			if var_11_1 > arg_11_0[var_11_0] then
				var_11_0 = iter_11_0
			end
		else
			break
		end
	end

	return var_11_0
end

var_0_0.filter_positions = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = {}

	arg_12_4 = arg_12_4 * arg_12_4
	arg_12_3 = arg_12_3 * arg_12_3

	local var_12_1 = var_0_1(arg_12_0, arg_12_1)

	for iter_12_0 = 1, #arg_12_2 do
		local var_12_2 = arg_12_2[iter_12_0]
		local var_12_3 = Unit.local_position(var_12_2, 0)
		local var_12_4 = var_0_1(arg_12_0, var_12_3)

		if var_12_4 < arg_12_4 and arg_12_3 < var_12_4 and var_12_1 > var_0_1(arg_12_1, var_12_3) then
			var_12_0[#var_12_0 + 1] = var_12_2
		end
	end

	return var_12_0
end

var_0_0.filter_horde_spawners = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	local var_13_0 = {}
	local var_13_1 = {}

	arg_13_4 = arg_13_4 * arg_13_4
	arg_13_3 = arg_13_3 * arg_13_3

	for iter_13_0 = 1, #arg_13_0 do
		local var_13_2 = arg_13_0[iter_13_0]

		for iter_13_1 = 1, #arg_13_1 do
			local var_13_3 = arg_13_1[iter_13_1]
			local var_13_4 = Unit.local_position(var_13_3, 0)
			local var_13_5 = var_0_1(var_13_2, var_13_4)

			if var_13_5 < arg_13_4 and arg_13_3 < var_13_5 then
				var_13_0[#var_13_0 + 1] = var_13_3

				if arg_13_2[var_13_3] then
					var_13_1[#var_13_1 + 1] = var_13_3
				end
			end
		end
	end

	return var_13_0, var_13_1
end

var_0_0.filter_horde_spawners_strictly = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	local var_14_0 = {}
	local var_14_1 = {}

	arg_14_4 = arg_14_4 * arg_14_4
	arg_14_3 = arg_14_3 * arg_14_3

	local var_14_2 = #arg_14_0

	for iter_14_0 = 1, #arg_14_1 do
		local var_14_3 = arg_14_1[iter_14_0]
		local var_14_4 = Unit.local_position(var_14_3, 0)
		local var_14_5 = 0

		for iter_14_1 = 1, var_14_2 do
			local var_14_6 = arg_14_0[iter_14_1]
			local var_14_7 = var_0_1(var_14_6, var_14_4)

			if var_14_7 < arg_14_4 and arg_14_3 < var_14_7 then
				var_14_5 = var_14_5 + 1
			end
		end

		if var_14_5 == var_14_2 then
			var_14_0[#var_14_0 + 1] = var_14_3

			if arg_14_2[var_14_3] then
				var_14_1[#var_14_1 + 1] = var_14_3
			end
		end
	end

	return var_14_0, var_14_1
end

var_0_0.get_hidden_pos = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8, arg_15_9, arg_15_10, arg_15_11, arg_15_12)
	local var_15_0 = Vector3(0, 0, 1)
	local var_15_1 = arg_15_8 * 0.5
	local var_15_2 = not World.umbra_available(arg_15_0)

	for iter_15_0 = 1, arg_15_10 do
		local var_15_3

		if arg_15_11 then
			var_15_3 = var_0_0.get_spawn_pos_on_cake_slice(arg_15_1, arg_15_5, arg_15_7 - var_15_1, arg_15_7 + var_15_1, arg_15_11, arg_15_12, 10, arg_15_4, arg_15_2, arg_15_3)
		else
			var_15_3 = var_0_0.get_spawn_pos_on_circle(arg_15_1, arg_15_5, arg_15_7, arg_15_8, 10, arg_15_4, arg_15_2, arg_15_3)
		end

		if var_15_3 then
			local var_15_4 = true

			for iter_15_1 = 1, #arg_15_6 do
				local var_15_5 = arg_15_6[iter_15_1]

				if var_15_2 or World.umbra_has_line_of_sight(arg_15_0, var_15_3 + var_15_0, var_15_5 + var_15_0) then
					var_15_4 = false

					break
				end
			end

			if var_15_4 then
				return var_15_3
			end
		end
	end
end

var_0_0.is_position_inside_no_spawn_volume = function (arg_16_0, arg_16_1, arg_16_2)
	return NavTagVolumeUtils.inside_level_volume_layer(arg_16_0, arg_16_1, arg_16_2, "NO_SPAWN") or NavTagVolumeUtils.inside_level_volume_layer(arg_16_0, arg_16_1, arg_16_2, "NO_BOTS_NO_SPAWN")
end

var_0_0.find_center_tri = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0, var_17_1, var_17_2, var_17_3, var_17_4 = GwNavQueries.triangle_from_position(arg_17_0, arg_17_1, arg_17_2 or 30, arg_17_3 or 30)

	if var_17_0 then
		arg_17_1.z = var_17_1

		return arg_17_1, var_17_2, var_17_3, var_17_4
	end
end

var_0_0.find_center_tri_with_fallback = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	arg_18_2, arg_18_3 = arg_18_2 or 30, arg_18_3 or 30

	local var_18_0, var_18_1, var_18_2, var_18_3, var_18_4 = GwNavQueries.triangle_from_position(arg_18_0, arg_18_1, arg_18_2, arg_18_3)

	if var_18_0 then
		arg_18_1.z = var_18_1

		return arg_18_1, var_18_2, var_18_3, var_18_4
	end

	local var_18_5 = 5

	if arg_18_2 < var_18_5 or arg_18_3 < var_18_5 then
		local var_18_6, var_18_7, var_18_8, var_18_9, var_18_10 = GwNavQueries.triangle_from_position(arg_18_0, arg_18_1, math.max(arg_18_2, var_18_5), math.max(arg_18_3, var_18_5))
		local var_18_11 = var_18_10
		local var_18_12 = var_18_9
		local var_18_13 = var_18_8
		local var_18_14 = var_18_7

		if var_18_6 then
			arg_18_1.z = var_18_14

			return arg_18_1, var_18_13, var_18_12, var_18_11
		end
	end

	local var_18_15 = 5

	arg_18_1 = GwNavQueries.inside_position_from_outside_position(arg_18_0, arg_18_1, var_18_5, var_18_5, var_18_15, 0.5)

	if arg_18_1 then
		local var_18_16
		local var_18_17, var_18_18, var_18_19, var_18_20, var_18_21 = GwNavQueries.triangle_from_position(arg_18_0, arg_18_1, math.max(arg_18_2, var_18_5), math.max(arg_18_3, var_18_5))

		return arg_18_1, var_18_19, var_18_20, var_18_21
	end

	return nil
end

var_0_0.simulate_dummy_target = function (arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = 15
	local var_19_1 = Vector3(var_19_0, 0, 1)
	local var_19_2 = arg_19_2 / 3 % (math.pi * 2)
	local var_19_3 = arg_19_1 + Quaternion.rotate(Quaternion(Vector3.up(), var_19_2), var_19_1)
	local var_19_4, var_19_5 = GwNavQueries.triangle_from_position(arg_19_0, var_19_3, 15, 15)

	if var_19_4 then
		var_19_3.z = var_19_5

		return var_19_3
	end

	return var_19_3
end

var_0_0.test_cake_slice = function (arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = Quaternion.rotate(Quaternion(Vector3.up(), math.degrees_to_radians(arg_20_2 % 20 / 20 * 360)), Vector3(0, 20, 0))

	QuickDrawer:line(arg_20_1 + Vector3(0, 0, 1), arg_20_1 + var_20_0 + Vector3(0, 0, 1), Color(0, 255, 175))

	for iter_20_0 = 1, 100 do
		local var_20_1 = var_0_0.get_spawn_pos_on_cake_slice(arg_20_0, arg_20_1, 1, 40, var_20_0, math.pi / 4, 5)

		if var_20_1 then
			QuickDrawer:sphere(var_20_1, 0.5, Color(0, 0, 175))
		end
	end
end

var_0_0.get_spawn_pos_on_cake_slice = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7, arg_21_8, arg_21_9)
	local var_21_0 = math.atan2(arg_21_4.x, arg_21_4.y)
	local var_21_1 = arg_21_5 * 0.5
	local var_21_2 = var_21_0 - var_21_1
	local var_21_3 = var_21_0 + var_21_1

	for iter_21_0 = 1, arg_21_6 do
		local var_21_4, var_21_5 = math.get_uniformly_random_point_inside_sector(arg_21_2, arg_21_3, var_21_2, var_21_3)
		local var_21_6 = Vector3(arg_21_1.x + var_21_4, arg_21_1.y + var_21_5, arg_21_1.z)
		local var_21_7, var_21_8 = GwNavQueries.triangle_from_position(arg_21_0, var_21_6, 30, 30)

		if var_21_7 then
			Vector3.set_z(var_21_6, var_21_8)

			if not arg_21_7 or not var_0_0.is_position_inside_no_spawn_volume(arg_21_8, arg_21_9, var_21_6) then
				return var_21_6
			end
		end
	end

	return false
end

var_0_0.get_spawn_pos_on_circle = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8, arg_22_9)
	local var_22_0
	local var_22_1
	local var_22_2

	for iter_22_0 = 1, arg_22_4 do
		local var_22_3 = Vector3(arg_22_2 + (math.random() - 0.5) * arg_22_3, 0, 1)
		local var_22_4 = arg_22_1 + Quaternion.rotate(Quaternion(Vector3.up(), math.degrees_to_radians(Math.random(1, 360))), var_22_3)
		local var_22_5, var_22_6, var_22_7, var_22_8 = var_0_0.find_center_tri(arg_22_0, var_22_4, arg_22_8, arg_22_9)

		if var_22_5 and (not arg_22_5 or not var_0_0.is_position_inside_no_spawn_volume(arg_22_6, arg_22_7, var_22_5)) then
			return var_22_5, var_22_6, var_22_7, var_22_8
		end
	end

	return false
end

var_0_0.get_pos_towards_goal = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7, arg_23_8)
	arg_23_4 = arg_23_4 or 1

	for iter_23_0 = 1, arg_23_4 do
		local var_23_0
		local var_23_1

		if arg_23_5 then
			var_23_1 = arg_23_1 + arg_23_5 * arg_23_2 + (math.random() - 0.5) * arg_23_3
		else
			local var_23_2 = Vector3(arg_23_2 + (math.random() - 0.5) * arg_23_3, 0, 0)

			var_23_1 = arg_23_1 + Quaternion.rotate(Quaternion(Vector3.up(), math.degrees_to_radians(Math.random(1, 360))), var_23_2)
		end

		local var_23_3, var_23_4 = GwNavQueries.raycast(arg_23_0, arg_23_1, var_23_1)

		if var_23_4 then
			local var_23_5
			local var_23_6, var_23_7 = GwNavQueries.triangle_from_position(arg_23_0, var_23_4, 1, 1)

			if var_23_6 then
				var_23_5 = var_23_4
			else
				var_23_5 = GwNavQueries.inside_position_from_outside_position(arg_23_0, var_23_4, 3, 3, 5, 0.5)
			end

			if not arg_23_6 or not var_0_0.is_position_inside_no_spawn_volume(arg_23_7, arg_23_8, var_23_4) then
				return var_23_5
			end
		end
	end

	return false
end

var_0_0.get_furthest_pos_from_pos_on_circle = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
	local var_24_0 = {}

	for iter_24_0 = 1, arg_24_4 do
		local var_24_1 = Vector3(arg_24_2 + (math.random() - 0.5) * arg_24_3, 0, 1)
		local var_24_2 = arg_24_1 + Quaternion.rotate(Quaternion(Vector3.up(), math.degrees_to_radians(Math.random(1, 360))), var_24_1)
		local var_24_3 = var_0_0.find_center_tri(arg_24_0, var_24_2)

		if var_24_3 then
			var_24_0[#var_24_0 + 1] = var_24_3
		end
	end

	local var_24_4 = (arg_24_2 + 0.5 * arg_24_3 + 1) * 2 * ((arg_24_2 + 0.5 * arg_24_3 + 1) * 2)
	local var_24_5
	local var_24_6 = 0

	for iter_24_1, iter_24_2 in ipairs(var_24_0) do
		if not var_24_5 then
			var_24_5 = iter_24_2
		elseif iter_24_2 then
			local var_24_7 = Vector3.distance_squared(arg_24_5, iter_24_2)

			if var_24_6 < var_24_7 and var_24_7 <= var_24_4 then
				var_24_5 = iter_24_2
				var_24_6 = var_24_7
			end
		end
	end

	if var_24_5 then
		return var_24_5
	end

	return false
end

var_0_0.get_spawn_pos_on_circle_with_func = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6, arg_25_7, arg_25_8)
	for iter_25_0 = 1, arg_25_4 do
		local var_25_0 = Vector3(arg_25_2 + (math.random() - 0.5) * arg_25_3, 0, 1)
		local var_25_1 = arg_25_1 + Quaternion.rotate(Quaternion(Vector3.up(), math.degrees_to_radians(Math.random(1, 360))), var_25_0)
		local var_25_2 = var_0_0.find_center_tri(arg_25_0, var_25_1, arg_25_7, arg_25_8)

		if var_25_2 and arg_25_5(var_25_2, arg_25_6) then
			return var_25_2
		end
	end

	return false
end

var_0_0.get_spawn_pos_on_circle_with_func_range = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6, arg_26_7, arg_26_8)
	for iter_26_0 = 1, arg_26_4 do
		local var_26_0 = Vector3(math.lerp(arg_26_2, arg_26_3, math.random()), 0, 1)
		local var_26_1 = arg_26_1 + Quaternion.rotate(Quaternion(Vector3.up(), math.degrees_to_radians(Math.random(1, 360))), var_26_0)
		local var_26_2 = var_0_0.find_center_tri(arg_26_0, var_26_1, arg_26_7, arg_26_8)

		if var_26_2 and arg_26_5(var_26_2, arg_26_6) then
			return var_26_2
		end
	end

	return false
end

var_0_0.draw_stack_of_balls = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	QuickDrawer:sphere(arg_27_0 + Vector3(0, 0, 1), 0.4, Color(arg_27_1, arg_27_2, arg_27_3, arg_27_4))
	QuickDrawer:sphere(arg_27_0 + Vector3(0, 0, 1.5), 0.3, Color(arg_27_1, arg_27_2 * 0.75, arg_27_3 * 0.75, arg_27_4 * 0.75))
	QuickDrawer:sphere(arg_27_0 + Vector3(0, 0, 2), 0.2, Color(arg_27_1, arg_27_2 * 0.5, arg_27_3 * 0.5, arg_27_4 * 0.5))
	QuickDrawer:sphere(arg_27_0 + Vector3(0, 0, 2.5), 0.1, Color(arg_27_1, arg_27_2 * 0.25, arg_27_3 * 0.25, arg_27_4 * 0.25))
end

local var_0_12 = {}

var_0_0.get_teleporter_portals = function ()
	local var_28_0 = Managers.state.game_mode:level_key()
	local var_28_1 = LevelSettings[var_28_0].level_name
	local var_28_2 = var_0_12[var_28_1]

	if var_28_2 then
		return var_28_2
	end

	local var_28_3 = {}

	var_0_12[var_28_1] = var_28_3

	local var_28_4 = LevelResource.unit_indices(var_28_1, "units/hub_elements/portal")

	for iter_28_0, iter_28_1 in ipairs(var_28_4) do
		local var_28_5 = LevelResource.unit_position(var_28_1, iter_28_1)
		local var_28_6 = LevelResource.unit_rotation(var_28_1, iter_28_1)
		local var_28_7 = LevelResource.unit_data(var_28_1, iter_28_1)
		local var_28_8 = DynamicData.get(var_28_7, "id")
		local var_28_9 = QuaternionBox(var_28_6)
		local var_28_10 = Vector3Box(var_28_5)

		var_28_3[var_28_8] = {
			var_28_10,
			var_28_9
		}
	end

	return var_28_3
end

var_0_0.interest_point_outside_nav_mesh = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	local var_29_0 = InterestPointUnitsLookup[arg_29_1]

	for iter_29_0 = 1, #var_29_0 do
		local var_29_1 = var_29_0[iter_29_0][1]:unbox()
		local var_29_2 = arg_29_2 + Quaternion.rotate(arg_29_3, var_29_1)
		local var_29_3, var_29_4 = GwNavQueries.triangle_from_position(arg_29_0, var_29_2, 0.3, 0.3)

		if not var_29_3 then
			return var_29_2
		end
	end
end

var_0_0.generate_spawn_point_lookup = function (arg_30_0)
	local var_30_0 = InterestPointUnits
	local var_30_1 = {}
	local var_30_2 = Vector3(0, 0, -1000)
	local var_30_3 = Quaternion.identity()

	for iter_30_0, iter_30_1 in ipairs(var_30_0) do
		if iter_30_1 then
			for iter_30_2, iter_30_3 in ipairs(iter_30_1) do
				local var_30_4 = World.spawn_unit(arg_30_0, iter_30_3, var_30_2, var_30_3)
				local var_30_5 = {}
				local var_30_6 = 0

				while Unit.has_data(var_30_4, "interest_point", "points", var_30_6) do
					local var_30_7 = Unit.get_data(var_30_4, "interest_point", "points", var_30_6, "node")
					local var_30_8 = Unit.node(var_30_4, var_30_7)
					local var_30_9 = var_30_7 == "root_point" and Vector3(0, 0, 0) or Unit.local_position(var_30_4, var_30_8)
					local var_30_10 = Unit.local_rotation(var_30_4, var_30_8)

					var_30_5[#var_30_5 + 1] = {
						Vector3Box(var_30_9),
						QuaternionBox(var_30_10)
					}
					var_30_6 = var_30_6 + 1
				end

				var_30_1[iter_30_3] = var_30_5

				World.destroy_unit(arg_30_0, var_30_4)
			end
		end
	end

	InterestPointUnitsLookup = var_30_1
end

var_0_0.display_number_of_breeds = function (arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = arg_31_0 .. tostring(arg_31_1) .. ", "

	for iter_31_0, iter_31_1 in pairs(arg_31_2) do
		if iter_31_1 > 0 then
			var_31_0 = var_31_0 .. iter_31_0 .. "=" .. iter_31_1 .. ", "
		end
	end

	Debug.text(var_31_0)
end

local var_0_13 = {}

var_0_0.display_number_of_breeds_in_segment = function (arg_32_0, arg_32_1, arg_32_2)
	table.clear(var_0_13)

	local var_32_0 = arg_32_0 .. ", "

	for iter_32_0, iter_32_1 in pairs(arg_32_1) do
		for iter_32_2, iter_32_3 in pairs(iter_32_1) do
			local var_32_1 = ScriptUnit.has_extension(iter_32_3, "health_system")
			local var_32_2 = arg_32_2.hi_data
			local var_32_3 = var_32_1.zone_data and var_32_1.zone_data.hi_data

			if var_32_2 and var_32_2 == var_32_3 then
				var_0_13[iter_32_0] = (var_0_13[iter_32_0] or 0) + 1

				QuickDrawer:sphere(POSITION_LOOKUP[iter_32_3], 0.75, Color(200, 0, 200))
			end
		end
	end

	Debug.text(var_32_0)

	for iter_32_4, iter_32_5 in pairs(var_0_13) do
		var_32_0 = var_32_0 .. iter_32_4 .. "=" .. iter_32_5 .. ", "
	end

	return var_32_0
end

var_0_0.show_where_ai_is = function (arg_33_0)
	local var_33_0 = POSITION_LOOKUP
	local var_33_1 = Vector3(0, 0, 40)

	for iter_33_0 = 1, #arg_33_0 do
		local var_33_2 = arg_33_0[iter_33_0]
		local var_33_3 = var_33_0[var_33_2]
		local var_33_4 = Unit.get_data(var_33_2, "breed")

		QuickDrawer:line(var_33_3, var_33_3 + var_33_1, Color(unpack(var_33_4.debug_color)))
	end
end

var_0_0.make_roaming_spawns = function (arg_34_0, arg_34_1)
	local var_34_0 = {}

	if LEVEL_EDITOR_TEST then
		return var_34_0
	end

	local var_34_1 = CurrentConflictSettings.roaming.density or 0.01
	local var_34_2 = arg_34_1:get_start_and_finish()

	if var_34_2 then
		var_34_2 = var_34_2:unbox()
	else
		local var_34_3 = Managers.state.game_mode:level_key()
		local var_34_4 = LevelSettings[var_34_3].level_name
		local var_34_5 = LevelResource.unit_indices(var_34_4, "core/gwnav/units/seedpoint/seedpoint")

		if #var_34_5 > 0 then
			local var_34_6 = var_34_5[1]

			var_34_2 = LevelResource.unit_position(var_34_4, var_34_6)
		end
	end

	local var_34_7 = GwNavTraversal.get_seed_triangle(arg_34_0, var_34_2)
	local var_34_8 = {
		var_34_7
	}
	local var_34_9 = 1
	local var_34_10 = 0
	local var_34_11 = {}
	local var_34_12, var_34_13, var_34_14 = GwNavTraversal.get_triangle_vertices(arg_34_0, var_34_7)
	local var_34_15 = (var_34_12 + var_34_13 + var_34_14) / 3

	var_34_11[var_34_15.x * 0.0001 + var_34_15.y + var_34_15.z * 10000] = true

	while var_34_10 < var_34_9 do
		var_34_10 = var_34_10 + 1

		local var_34_16 = var_34_8[var_34_10]
		local var_34_17, var_34_18, var_34_19 = Script.temp_count()
		local var_34_20, var_34_21, var_34_22 = GwNavTraversal.get_triangle_vertices(arg_34_0, var_34_16)
		local var_34_23 = (var_34_20 + var_34_21 + var_34_22) / 3

		if var_34_1 > math.random() then
			var_34_0[#var_34_0 + 1] = Vector3Box(var_34_23)
		end

		Script.set_temp_count(var_34_17, var_34_18, var_34_19)

		local var_34_24 = {
			GwNavTraversal.get_neighboring_triangles(var_34_16)
		}

		for iter_34_0 = 1, #var_34_24 do
			local var_34_25 = var_34_24[iter_34_0]
			local var_34_26, var_34_27, var_34_28 = Script.temp_count()
			local var_34_29, var_34_30, var_34_31 = GwNavTraversal.get_triangle_vertices(arg_34_0, var_34_25)
			local var_34_32 = var_34_31
			local var_34_33 = var_34_30
			local var_34_34 = (var_34_29 + var_34_33 + var_34_32) / 3
			local var_34_35 = var_34_34.x * 0.0001 + var_34_34.y + var_34_34.z * 10000

			Script.set_temp_count(var_34_26, var_34_27, var_34_28)

			if not var_34_11[var_34_35] then
				var_34_9 = var_34_9 + 1
				var_34_8[var_34_9] = var_34_25
				var_34_11[var_34_35] = true
			end
		end
	end

	return var_34_0
end

local function var_0_14(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = arg_35_0[arg_35_1]

	if var_35_0 then
		for iter_35_0 = 1, #var_35_0 do
			local var_35_1 = var_35_0[iter_35_0]

			for iter_35_1 = 1, #var_35_1 do
				local var_35_2 = var_35_1[iter_35_1]

				if Breeds[var_35_2] then
					arg_35_2[var_35_2] = true
				end
			end
		end
	end
end

local function var_0_15(arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = DifficultySettings[arg_36_2].rank - 1
	local var_36_1 = HordeCompositions[arg_36_1][var_36_0]

	fassert(var_36_1 ~= nil, string.format("No horde composition found for '%s' on difficulty '%s'", arg_36_1, arg_36_2))

	for iter_36_0 = 1, #var_36_1 do
		local var_36_2 = var_36_1[iter_36_0].breeds

		for iter_36_1 = 1, #var_36_2, 2 do
			arg_36_0[var_36_2[iter_36_1]] = true
		end
	end
end

local function var_0_16(arg_37_0, arg_37_1, arg_37_2)
	local var_37_0 = BreedActions[arg_37_1]

	if var_37_0 then
		for iter_37_0, iter_37_1 in pairs(var_37_0) do
			if iter_37_1.difficulty_spawn_list or iter_37_1.spawn_list then
				local var_37_1 = iter_37_1.difficulty_spawn_list and iter_37_1.difficulty_spawn_list[arg_37_2] or iter_37_1.spawn_list

				for iter_37_2 = 1, #var_37_1 do
					arg_37_0[var_37_1[iter_37_2]] = true
				end
			end

			if iter_37_1.phase_spawn then
				for iter_37_3, iter_37_4 in pairs(iter_37_1.phase_spawn) do
					var_0_15(arg_37_0, iter_37_4, arg_37_2)
				end
			end

			if iter_37_1.difficulty_spawn or iter_37_1.spawn then
				local var_37_2 = iter_37_1.difficulty_spawn and iter_37_1.difficulty_spawn[arg_37_2] or iter_37_1.spawn

				var_0_15(arg_37_0, var_37_2, arg_37_2)
			end
		end
	end
end

local function var_0_17(arg_38_0, arg_38_1, arg_38_2)
	if type(arg_38_1) == "table" then
		for iter_38_0 = 1, #arg_38_1 do
			local var_38_0 = arg_38_1[iter_38_0]

			arg_38_0[var_38_0] = true

			var_0_16(arg_38_0, var_38_0, arg_38_2)
		end
	else
		arg_38_0[arg_38_1] = true

		var_0_16(arg_38_0, arg_38_1, arg_38_2)
	end
end

var_0_0.add_breeds_from_event = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5)
	for iter_39_0 = 1, #arg_39_1 do
		repeat
			local var_39_0 = arg_39_1[iter_39_0]
			local var_39_1 = var_39_0[1]
			local var_39_2 = var_39_0.difficulty_requirement

			if var_39_2 and var_39_2 > (arg_39_3 or DifficultySettings.normal.rank) then
				break
			end

			if var_39_1 == "spawn" or var_39_1 == "spawn_at_raw" or var_39_1 == "spawn_special" or var_39_1 == "spawn_weave_special" or var_39_1 == "spawn_weave_special_event" then
				var_0_17(arg_39_4, var_39_0.breed_name, arg_39_2)

				break
			end

			if var_39_1 == "spawn_patrol" then
				local var_39_3 = var_39_0.formations

				for iter_39_1 = 1, #var_39_3 do
					local var_39_4 = var_39_3[iter_39_1]
					local var_39_5 = PatrolFormationSettings[var_39_4]

					var_0_14(var_39_5, arg_39_2, arg_39_4)
				end

				break
			end

			if var_39_1 == "start_event" then
				local var_39_6 = var_39_0.start_event_name
				local var_39_7 = arg_39_5[var_39_6]

				if var_39_6 ~= arg_39_0 then
					var_0_0.add_breeds_from_event(arg_39_0, var_39_7, arg_39_2, arg_39_3, arg_39_4, arg_39_5)
				end

				break
			end

			if var_39_1 == "event_horde" or var_39_1 == "ambush_horde" then
				local var_39_8 = var_39_0.composition_type

				var_0_15(arg_39_4, var_39_8, arg_39_2)
			end
		until true
	end
end

local function var_0_18(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	local var_40_0 = DifficultySettings[arg_40_1].rank

	for iter_40_0, iter_40_1 in pairs(arg_40_0) do
		local var_40_1 = var_0_4(arg_40_0, iter_40_0, arg_40_1, arg_40_2)

		if type(var_40_1) == "table" then
			local var_40_2 = var_40_1.event_lookup

			for iter_40_2, iter_40_3 in pairs(var_40_2) do
				for iter_40_4 = 1, #iter_40_3 do
					local var_40_3 = iter_40_3[iter_40_4]
					local var_40_4 = GenericTerrorEvents
					local var_40_5 = var_40_4[var_40_3]

					var_0_0.add_breeds_from_event(var_40_3, var_40_5, arg_40_1, var_40_0, arg_40_3, var_40_4)
				end
			end
		end
	end
end

local function var_0_19(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	local var_41_0 = var_0_4(arg_41_0, "breeds", arg_41_1, arg_41_2)

	for iter_41_0 = 1, #var_41_0 do
		arg_41_3[var_41_0[iter_41_0]] = true
	end

	local var_41_1 = var_0_4(arg_41_0, "rush_intervention", arg_41_1, arg_41_2).breeds

	for iter_41_1 = 1, #var_41_1 do
		arg_41_3[var_41_1[iter_41_1]] = true
	end

	local var_41_2 = var_0_4(arg_41_0, "speed_running_intervention", arg_41_1, arg_41_2) or SpecialsSettings.default.speed_running_intervention
	local var_41_3 = var_41_2.breeds

	for iter_41_2 = 1, #var_41_3 do
		arg_41_3[var_41_3[iter_41_2]] = true
	end

	local var_41_4 = var_41_2.vector_horde_breeds

	for iter_41_3 = 1, #var_41_4 do
		arg_41_3[var_41_4[iter_41_3]] = true
	end
end

local function var_0_20(arg_42_0, arg_42_1, arg_42_2)
	local var_42_0 = arg_42_0.zone_checks
	local var_42_1 = 3
	local var_42_2 = var_42_0.clamp_breeds_low[arg_42_1]

	if var_42_2 then
		for iter_42_0 = 1, #var_42_2 do
			arg_42_2[var_42_2[iter_42_0][var_42_1].name] = true
		end
	end

	local var_42_3 = var_42_0.clamp_breeds_hi[arg_42_1]

	if var_42_3 then
		for iter_42_1 = 1, #var_42_3 do
			arg_42_2[var_42_3[iter_42_1][var_42_1].name] = true
		end
	end

	for iter_42_2 = 1, #arg_42_0 do
		local var_42_4 = arg_42_0[iter_42_2].members

		for iter_42_3 = 1, #var_42_4 do
			local var_42_5 = var_42_4[iter_42_3]
			local var_42_6 = var_42_5.name

			if var_42_6 then
				arg_42_2[var_42_6] = true
			else
				for iter_42_4, iter_42_5 in ipairs(var_42_5) do
					arg_42_2[iter_42_5.name] = true
				end
			end
		end
	end
end

local function var_0_21(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	local var_43_0 = var_0_4(arg_43_0, "roaming_set", arg_43_1, arg_43_2)
	local var_43_1 = var_43_0.breed_packs
	local var_43_2 = BreedPacks[var_43_1]

	var_0_20(var_43_2, arg_43_1, arg_43_3)

	local var_43_3 = 1
	local var_43_4 = var_43_0.breed_packs_override

	for iter_43_0 = 1, #var_43_4 do
		local var_43_5 = var_43_4[iter_43_0][var_43_3]
		local var_43_6 = BreedPacks[var_43_5]

		var_0_20(var_43_6, arg_43_1, arg_43_3)
	end
end

local function var_0_22(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	local var_44_0 = var_0_4(arg_44_0, "compositions_pacing", arg_44_1, arg_44_2)
	local var_44_1 = var_0_4(arg_44_0, "ambush_composition", arg_44_1, arg_44_2)

	if type(var_44_1) == "table" then
		for iter_44_0 = 1, #var_44_1 do
			local var_44_2 = var_44_1[iter_44_0]
			local var_44_3 = HordeWaveCompositions[var_44_2]

			for iter_44_1 = 1, #var_44_3 do
				local var_44_4 = var_44_0[var_44_3[iter_44_1]]

				for iter_44_2 = 1, #var_44_4 do
					local var_44_5 = var_44_4[iter_44_2].breeds

					for iter_44_3 = 1, #var_44_5, 2 do
						arg_44_3[var_44_5[iter_44_3]] = true
					end
				end
			end
		end
	else
		local var_44_6 = var_44_0[var_44_1]

		for iter_44_4 = 1, #var_44_6 do
			local var_44_7 = var_44_6[iter_44_4].breeds

			for iter_44_5 = 1, #var_44_7, 2 do
				arg_44_3[var_44_7[iter_44_5]] = true
			end
		end
	end

	local var_44_8 = arg_44_0.vector_composition

	if type(var_44_8) == "table" then
		for iter_44_6 = 1, #var_44_8 do
			local var_44_9 = var_44_8[iter_44_6]
			local var_44_10 = HordeWaveCompositions[var_44_9]

			for iter_44_7 = 1, #var_44_10 do
				local var_44_11 = var_44_0[var_44_10[iter_44_7]]

				for iter_44_8 = 1, #var_44_11 do
					local var_44_12 = var_44_11[iter_44_8].breeds

					for iter_44_9 = 1, #var_44_12, 2 do
						arg_44_3[var_44_12[iter_44_9]] = true
					end
				end
			end
		end
	else
		local var_44_13 = var_44_0[var_44_8]

		for iter_44_10 = 1, #var_44_13 do
			local var_44_14 = var_44_13[iter_44_10].breeds

			for iter_44_11 = 1, #var_44_14, 2 do
				arg_44_3[var_44_14[iter_44_11]] = true
			end
		end
	end

	local var_44_15 = arg_44_0.vector_blob_composition

	if type(var_44_15) == "table" then
		for iter_44_12 = 1, #var_44_15 do
			local var_44_16 = var_44_15[iter_44_12]
			local var_44_17 = HordeWaveCompositions[var_44_16]

			for iter_44_13 = 1, #var_44_17 do
				local var_44_18 = var_44_0[var_44_17[iter_44_13]]

				for iter_44_14 = 1, #var_44_18 do
					local var_44_19 = var_44_18[iter_44_14].breeds

					for iter_44_15 = 1, #var_44_19, 2 do
						arg_44_3[var_44_19[iter_44_15]] = true
					end
				end
			end
		end
	else
		local var_44_20 = var_44_0[var_44_15]

		for iter_44_16 = 1, #var_44_20 do
			local var_44_21 = var_44_20[iter_44_16].breeds

			for iter_44_17 = 1, #var_44_21, 2 do
				arg_44_3[var_44_21[iter_44_17]] = true
			end
		end
	end

	local var_44_22 = var_44_0[arg_44_0.mini_patrol_composition]

	for iter_44_18 = 1, #var_44_22 do
		local var_44_23 = var_44_22[iter_44_18].breeds

		for iter_44_19 = 1, #var_44_23, 2 do
			arg_44_3[var_44_23[iter_44_19]] = true
		end
	end
end

var_0_0.find_conflict_director_breeds = function (arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = DifficultySettings[arg_45_1].fallback_difficulty

	if not arg_45_0.boss.disabled then
		var_0_18(arg_45_0.boss, arg_45_1, var_45_0, arg_45_2)
	end

	if not arg_45_0.specials.disabled then
		var_0_19(arg_45_0.specials, arg_45_1, var_45_0, arg_45_2)
	end

	if not arg_45_0.pack_spawning.disabled then
		var_0_21(arg_45_0.pack_spawning, arg_45_1, var_45_0, arg_45_2)
	end

	if not arg_45_0.horde.disabled then
		var_0_22(arg_45_0.horde, arg_45_1, var_45_0, arg_45_2)
	end

	return arg_45_2
end

var_0_0.patch_settings_with_difficulty = function (arg_46_0, arg_46_1, arg_46_2)
	local var_46_0 = arg_46_0.difficulty_overrides
	local var_46_1 = var_46_0 and (var_46_0[arg_46_1] or var_46_0[arg_46_2])

	if var_46_1 then
		for iter_46_0, iter_46_1 in pairs(arg_46_0) do
			if iter_46_0 ~= "difficulty_overrides" then
				arg_46_0[iter_46_0] = var_46_1[iter_46_0] or arg_46_0[iter_46_0]
			end
		end

		arg_46_0.difficulty_overrides = nil

		return arg_46_0
	else
		return arg_46_0
	end
end

var_0_0.patch_terror_events_with_weaves = function (arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = arg_47_1.name
	local var_47_1 = WeaveSettings.templates[var_47_0].objectives
	local var_47_2 = TerrorEventBlueprints.weaves

	TerrorEventBlueprints[arg_47_0] = TerrorEventBlueprints[arg_47_0] or {}

	table.clear(TerrorEventBlueprints[arg_47_0])

	local var_47_3 = var_47_1[arg_47_2]
	local var_47_4 = var_47_3.spawning_settings

	if var_47_4 then
		local var_47_5 = var_47_4.main_path_spawning
		local var_47_6 = var_47_4.terror_event_trickle

		if var_47_5 then
			for iter_47_0 = 1, #var_47_5 do
				local var_47_7 = var_47_5[iter_47_0].terror_event_name

				TerrorEventBlueprints[arg_47_0][var_47_7] = var_47_2[var_47_7]
			end
		end

		if var_47_6 then
			TerrorEventBlueprints[arg_47_0][var_47_6] = var_47_2[var_47_6]
		end
	end

	local var_47_8 = var_47_3.terror_events

	if var_47_8 then
		for iter_47_1 = 1, #var_47_8 do
			local var_47_9 = var_47_8[iter_47_1]

			TerrorEventBlueprints[arg_47_0][var_47_9] = var_47_2[var_47_9]
		end
	end
end

var_0_0.generate_conflict_director_locked_functions = function (arg_48_0)
	local var_48_0 = {}

	for iter_48_0, iter_48_1 in pairs(ConflictDirectorLockedFunctions) do
		if iter_48_1(arg_48_0) then
			var_48_0[#var_48_0 + 1] = iter_48_0
		end
	end

	return var_48_0
end

var_0_0.teleport_ai_unit = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3)
	if arg_49_1 then
		if ALIVE[arg_49_0] then
			local var_49_0 = BLACKBOARDS[arg_49_0]
			local var_49_1 = var_49_0.navigation_extension
			local var_49_2 = var_49_0.locomotion_extension

			if var_49_1 and var_49_2 then
				var_49_1:set_navbot_position(arg_49_1)
				var_49_2:teleport_to(arg_49_1)
				Managers.state.entity:system("ai_bot_group_system"):enemy_teleported(arg_49_0, arg_49_1)
			end
		end

		Managers.state.entity:system("ping_system"):remove_ping_from_unit(arg_49_0)

		if arg_49_2 then
			Managers.state.entity:system("audio_system"):play_audio_unit_event(arg_49_2, arg_49_0)
		end

		if arg_49_3 then
			local var_49_3 = NetworkLookup.effects[arg_49_3]
			local var_49_4 = 0
			local var_49_5 = Quaternion.identity()
			local var_49_6 = POSITION_LOOKUP[arg_49_0]
			local var_49_7 = Managers.state.network

			var_49_7:rpc_play_particle_effect(nil, var_49_3, NetworkConstants.invalid_game_object_id, var_49_4, var_49_6, var_49_5, false)
			var_49_7:rpc_play_particle_effect(nil, var_49_3, NetworkConstants.invalid_game_object_id, var_49_4, arg_49_1, var_49_5, false)
		end
	end
end

var_0_0.look_at_position_flat = function (arg_50_0, arg_50_1)
	local var_50_0 = Vector3.flat(arg_50_1 - arg_50_0)
	local var_50_1 = Vector3.normalize(var_50_0)

	return (var_0_3(var_50_1, Vector3.up()))
end

var_0_0.get_closest_position = function (arg_51_0, arg_51_1)
	local var_51_0 = math.huge
	local var_51_1

	for iter_51_0 = 1, #arg_51_1 do
		local var_51_2 = arg_51_1[iter_51_0]
		local var_51_3 = var_0_1(arg_51_0, var_51_2)

		if var_51_3 < var_51_0 then
			var_51_0 = var_51_3
			var_51_1 = var_51_2
		end
	end

	return var_51_1, var_51_0
end

var_0_0.override_extension_init_data = function (arg_52_0, arg_52_1)
	local var_52_0 = arg_52_1.extension_init_data

	if var_52_0 then
		for iter_52_0, iter_52_1 in pairs(var_52_0) do
			table.merge(arg_52_0[iter_52_0], iter_52_1)
		end
	end
end

local function var_0_23(arg_53_0, arg_53_1, arg_53_2, arg_53_3)
	local var_53_0 = arg_53_3 - arg_53_2
	local var_53_1 = Vector3.length(var_53_0)
	local var_53_2 = Vector3.normalize(var_53_0)
	local var_53_3, var_53_4, var_53_5, var_53_6, var_53_7 = PhysicsWorld.raycast(arg_53_0, arg_53_2, var_53_2, var_53_1, "closest", "collision_filter", "filter_ai_line_of_sight_check")
	local var_53_8 = var_53_3 and Actor.unit(var_53_7)

	return not var_53_3 or var_53_8 == arg_53_1
end

var_0_0.raise_dead = function (arg_54_0, arg_54_1, arg_54_2)
	if arg_54_0 then
		arg_54_1 = arg_54_1 or 10

		local var_54_0 = {}
		local var_54_1 = {}

		Managers.state.entity:system("death_system"):get_dead(var_54_0)

		for iter_54_0, iter_54_1 in pairs(var_54_0) do
			local var_54_2 = BLACKBOARDS[iter_54_0]

			if var_54_2 then
				local var_54_3 = var_54_2.breed
				local var_54_4 = POSITION_LOOKUP[iter_54_0]

				if arg_54_1 > Vector3.distance(arg_54_0, var_54_4) and var_54_3.is_resurrectable ~= false then
					if Unit.has_animation_event(iter_54_0, "spawn_floor") then
						var_54_1[#var_54_1 + 1] = iter_54_0
					else
						printf("Can't raise %s missing animation event: 'spawn_floor' ", BLACKBOARDS[iter_54_0].breed.name)
					end
				end
			end
		end

		local var_54_5 = #var_54_1

		if var_54_5 > 0 then
			local var_54_6 = Managers.player:local_player()
			local var_54_7 = var_54_6.resurrected_group_id
			local var_54_8 = var_54_7 or Managers.state.entity:system("ai_group_system"):generate_group_id()
			local var_54_9 = {
				insert_into_group = true,
				template = "resurrected",
				group_type = "resurrected",
				id = var_54_8,
				size = var_54_5,
				commanding_player = var_54_6
			}

			var_54_6.resurrected_group_id = var_54_8

			for iter_54_2 = 1, var_54_5 do
				local var_54_10 = var_54_1[iter_54_2]
				local var_54_11 = POSITION_LOOKUP[var_54_10]
				local var_54_12 = Unit.local_rotation(var_54_10, 0)
				local var_54_13 = BLACKBOARDS[var_54_10].breed
				local var_54_14 = "resurrected"
				local var_54_15 = "spawn_floor"
				local var_54_16 = {
					ignore_breed_limits = true,
					side_id = arg_54_2,
					insert_into_group = var_54_7 ~= nil
				}

				Managers.state.conflict:spawn_queued_unit(var_54_13, Vector3Box(var_54_11), QuaternionBox(var_54_12), var_54_14, var_54_15, nil, var_54_16, var_54_9)
				Managers.state.unit_spawner:mark_for_deletion(var_54_10)
			end
		end
	end
end

var_0_0.command_ai_to_move = function (arg_55_0, arg_55_1, arg_55_2)
	if arg_55_2 then
		local var_55_0 = Managers.state.entity:system("ai_group_system"):get_ai_group(arg_55_0.resurrected_group_id)

		if var_55_0 then
			QuickDrawer:sphere(arg_55_2, 2, Color(100, 0, 255))

			local var_55_1 = 1
			local var_55_2 = var_55_0.members_n
			local var_55_3 = 8
			local var_55_4 = math.ceil(math.sqrt(var_55_2))

			for iter_55_0, iter_55_1 in pairs(var_55_0.members) do
				local var_55_5 = BLACKBOARDS[iter_55_0]

				for iter_55_2 = 1, var_55_3 do
					local var_55_6 = Vector3(4 * math.random() - 2, 4 * math.random() - 2, 0)

					if iter_55_2 == 1 then
						var_55_6 = Vector3(-var_55_4 / 2 + var_55_1 % var_55_4, -var_55_4 / 2 + math.floor(var_55_1 / var_55_4), 0)
					end

					local var_55_7 = LocomotionUtils.pos_on_mesh(arg_55_1, arg_55_2 + var_55_6)

					if var_55_7 then
						var_55_5.new_move_to_goal = true
						var_55_5.goal_destination = Vector3Box(var_55_7)

						break
					end
				end

				var_55_1 = var_55_1 + 1
			end
		end
	end
end

var_0_0.find_positions_around_position = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4, arg_56_5, arg_56_6, arg_56_7, arg_56_8, arg_56_9, arg_56_10, arg_56_11, arg_56_12, arg_56_13, arg_56_14, arg_56_15)
	arg_56_7 = arg_56_7 or 1

	local function var_56_0(arg_57_0)
		local var_57_0 = math.pow(arg_56_7, 2)

		if arg_56_6 then
			for iter_57_0 = 1, #arg_56_6 do
				local var_57_1 = arg_56_6[iter_57_0]

				if var_57_0 > Vector3.distance_squared(arg_57_0, var_57_1) then
					return false
				end
			end
		end

		for iter_57_1 = 1, #arg_56_1 do
			local var_57_2 = arg_56_1[iter_57_1]

			if var_57_0 > Vector3.distance_squared(arg_57_0, var_57_2) then
				return false
			end
		end

		if arg_56_13 then
			local var_57_3 = Vector3(0, 0, 1)
			local var_57_4 = arg_57_0 + var_57_3
			local var_57_5 = arg_56_0 + var_57_3

			return (var_0_23(arg_56_14, arg_56_15, var_57_4, var_57_5))
		end

		return true
	end

	local var_56_1 = arg_56_4 - arg_56_3
	local var_56_2 = arg_56_3 + var_56_1 * 0.5

	arg_56_9 = arg_56_9 or 4

	local var_56_3 = math.pi * 2 / arg_56_9
	local var_56_4 = arg_56_10 or 2
	local var_56_5 = 2 * math.pi
	local var_56_6 = (math.random() - 0.5) * var_56_1
	local var_56_7 = math.random() * var_56_5
	local var_56_8 = 0

	arg_56_8 = arg_56_8 or 30

	local function var_56_9()
		var_56_7 = var_56_7 + var_56_3

		if var_56_7 > var_56_5 then
			var_56_7 = var_56_7 - var_56_5
		end

		var_56_8 = var_56_8 + 1

		if var_56_8 > arg_56_9 then
			var_56_6 = var_56_6 + var_56_4

			if var_56_6 > var_56_1 * 0.5 then
				var_56_6 = var_56_6 - var_56_1
			end

			var_56_8 = 0
			var_56_7 = math.random() * var_56_5
		end

		local var_58_0 = Vector3(var_56_2 + var_56_6, 0, 0)

		return arg_56_0 + Quaternion.rotate(Quaternion(Vector3.up(), var_56_7), var_58_0)
	end

	for iter_56_0 = 1, arg_56_5 do
		for iter_56_1 = 1, arg_56_8 do
			local var_56_10 = var_56_9()
			local var_56_11 = var_0_0.find_center_tri_with_fallback(arg_56_2, var_56_10, arg_56_11, arg_56_12)

			if var_56_11 then
				if var_56_0(var_56_11) then
					arg_56_1[#arg_56_1 + 1] = var_56_11
				end

				break
			end
		end
	end

	return arg_56_1
end

local function var_0_24(arg_59_0, arg_59_1, arg_59_2)
	local var_59_0, var_59_1, var_59_2, var_59_3, var_59_4 = PhysicsWorld.raycast(arg_59_0, arg_59_1, Vector3(0, 0, -1), arg_59_2, "closest", "types", "statics", "collision_filter", "filter_environment_overlap")

	return not var_59_0
end

var_0_0.find_visible_positions_in_sphere_around_player = function (arg_60_0, arg_60_1, arg_60_2, arg_60_3, arg_60_4, arg_60_5, arg_60_6, arg_60_7, arg_60_8, arg_60_9, arg_60_10, arg_60_11, arg_60_12, arg_60_13)
	arg_60_11 = arg_60_11 or 0

	local var_60_0 = math.pow(arg_60_12, 2)
	local var_60_1 = math.pow(arg_60_11, 2)
	local var_60_2 = POSITION_LOOKUP[arg_60_2]
	local var_60_3 = arg_60_5 - arg_60_4
	local var_60_4 = arg_60_8 - arg_60_7
	local var_60_5 = arg_60_4 + var_60_3 * math.random()
	local var_60_6 = arg_60_7 + var_60_4 * math.random()
	local var_60_7 = var_60_3 / arg_60_6
	local var_60_8 = var_60_4 / arg_60_9
	local var_60_9 = var_60_5
	local var_60_10 = 0
	local var_60_11 = 0
	local var_60_12 = var_60_6
	local var_60_13 = {}

	while arg_60_1 > #var_60_13 do
		var_60_9 = var_60_9 + arg_60_6
		var_60_10 = var_60_10 + 1

		if var_60_7 <= var_60_10 then
			var_60_9 = var_60_5
			var_60_10 = 0
			var_60_12 = var_60_12 + arg_60_9
			var_60_11 = var_60_11 + 1

			if var_60_8 <= var_60_11 then
				break
			end
		end

		local var_60_14 = var_60_2 + Quaternion.rotate(Quaternion.from_yaw_pitch_roll(var_60_12, var_60_9, 0), Vector3.forward()) * arg_60_3
		local var_60_15 = false

		if arg_60_10 then
			for iter_60_0 = 1, #arg_60_10 do
				local var_60_16 = arg_60_10[iter_60_0]

				if var_60_1 > Vector3.distance_squared(var_60_14, var_60_16) then
					var_60_15 = true

					break
				end
			end
		end

		if not var_60_15 then
			for iter_60_1 = 1, #var_60_13 do
				local var_60_17 = var_60_13[iter_60_1]

				if var_60_0 > Vector3.distance_squared(var_60_14, var_60_17) then
					var_60_15 = true

					break
				end
			end

			if not var_60_15 and var_0_23(arg_60_0, arg_60_2, var_60_14, var_60_2) and var_0_24(arg_60_0, var_60_14, arg_60_13) then
				var_60_13[#var_60_13 + 1] = var_60_14
			end
		end
	end

	return var_60_13
end
