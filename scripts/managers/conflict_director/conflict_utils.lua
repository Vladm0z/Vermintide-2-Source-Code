-- chunkname: @scripts/managers/conflict_director/conflict_utils.lua

require("scripts/settings/breeds")
require("scripts/settings/patrol_formation_settings")
require("scripts/managers/conflict_director/breed_packs")
require("scripts/managers/conflict_director/encampment_templates")

ConflictUtils = {}

local ConflictUtils = ConflictUtils
local distance_squared = Vector3.distance_squared
local random = Math.random
local look = Quaternion.look

local function fn(self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local difficulty_overrides = self.difficulty_overrides

	if not difficulty_overrides then
		-- Nothing
	end

	::label_1_0::

	local var_1_1 = difficulty_overrides[arg_1_2]

	var_1_1 = var_1_1 or difficulty_overrides[arg_1_3]

	do
		local var_1_2
	end

	::label_1_1::

	if not var_1_1 then
		var_1_2 = var_1_1[arg_1_1]

		if not var_1_2 then
			-- Nothing
		end
	end

	var_1_2 = self[arg_1_1]

	::label_1_2::

	return var_1_2
end

ConflictUtils.random_interval = function (self)
	-- function 2
	if type(self) == "table" then
		return random(self[1], self[2])
	else
		return self
	end
end

local tbl = {}
local tbl_2 = {}
local tbl_3 = {
	false,
	false,
	false
}

ConflictUtils.cluster_positions = function (self, arg_3_1)
	-- function 3
	local tbl_4 = {
		self[1]
	}
	local var_3_1 = tbl

	var_3_1[1] = 1
	tbl_2[1] = 1
	arg_3_1 = arg_3_1 * arg_3_1

	local var_3_2 = tbl_3

	for i = 1, 3 do
		var_3_2[i] = nil
	end

	for j = 2, #self do
		var_3_2[j - 1] = j
	end

	local count = #var_3_2

	while count > 0 do
		local flag = false

		for k = 1, #tbl_4 do
			for l = 1, count do
				local var_3_5 = var_3_2[l]

				if arg_3_1 > Vector3.distance_squared(tbl_4[k], self[var_3_5]) then
					var_3_2[l] = var_3_2[count]
					count = count - 1
					tbl_2[var_3_5] = k
					var_3_1[k] = var_3_1[k] + 1
					flag = true

					break
				end
			end
		end

		if not flag then
			local num = #tbl_4 + 1
			local var_3_7 = var_3_2[1]

			tbl_4[num] = self[var_3_7]
			tbl_2[var_3_7] = num
			var_3_1[num] = 1
			var_3_2[1] = var_3_2[count]
			count = count - 1
		end
	end

	for i4 = #tbl_4 + 1, #var_3_1 do
		var_3_1[i4] = nil
	end

	return tbl_4, var_3_1, tbl_2
end

local tbl_4 = {}
local tbl_5 = {
	1,
	2,
	3,
	6
}

ConflictUtils.cluster_weight_and_loneliness = function (self, arg_4_1)
	-- function 4
	local distance_squared = Vector3.distance_squared

	arg_4_1 = arg_4_1 * arg_4_1

	local min = math.min(#self, 4)

	if min == 1 then
		return 1, 1, 100
	elseif min == 0 then
		return 0, 0, 0
	end

	local var_4_2 = self[1]
	local var_4_3 = self[2]
	local var_4_4 = self[3]
	local var_4_5 = self[4]
	local num = 0
	local num_2 = 0
	local num_3 = 0
	local num_4 = 0
	local num_5 = 0
	local num_6 = 0
	local num_7 = 0

	if not var_4_5 then
		num_4 = distance_squared(var_4_2, var_4_5)
		num_6 = distance_squared(var_4_3, var_4_5)
		num_7 = distance_squared(var_4_4, var_4_5)

		local flag

		flag = not (num_4 < arg_4_1) or not 1 or 0
		num = num + flag

		local flag_2

		flag_2 = not (num_6 < arg_4_1) or not 1 or 0
		num = num + flag_2

		local flag_3

		flag_3 = not (num_7 < arg_4_1) or not 1 or 0
		num = num + flag_3
		tbl_4[4] = num_4 + num_6 + num_7
	end

	if not var_4_4 then
		num_3 = distance_squared(var_4_2, var_4_4)
		num_5 = distance_squared(var_4_3, var_4_4)

		local flag_4

		flag_4 = not (num_3 < arg_4_1) or not 1 or 0
		num = num + flag_4

		local flag_5

		flag_5 = not (num_5 < arg_4_1) or not 1 or 0
		num = num + flag_5
		tbl_4[3] = num_3 + num_5 + num_7
	end

	if not var_4_3 then
		num_2 = distance_squared(var_4_2, var_4_3)

		local flag_6

		flag_6 = not (num_2 < arg_4_1) or not 1 or 0
		num = num + flag_6
		tbl_4[2] = num_2 + num_5 + num_6
	end

	tbl_4[1] = num_2 + num_3 + num_4

	local num_8 = num / tbl_5[min]
	local num_9 = 0
	local num_10 = 1

	for i = 1, min do
		if num_9 < tbl_4[i] then
			num_9 = tbl_4[i]
			num_10 = i
		end
	end

	local num_11 = math.sqrt(num_9) / min

	return num_8, num_10, num_11, tbl_4
end

ConflictUtils.average_player_position = function ()
	-- function 5
	local num = 0
	local zero = Vector3.zero()
	local human_and_bot_players = Managers.player:human_and_bot_players()

	for k, v in pairs(human_and_bot_players) do
		local player_unit = v.player_unit

		if not ALIVE[player_unit] then
			zero = zero + POSITION_LOOKUP[player_unit]
			num = num + 1
		end
	end

	if num == 0 then
		return nil
	end

	return zero * (1 / num)
end

local tbl_6 = {}
local tbl_7 = {}

ConflictUtils.hidden_cover_points = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local cover_points_broadphase = Managers.state.conflict.level_analysis.cover_points_broadphase

	arg_6_2 = arg_6_2 * arg_6_2
	arg_6_4 = not arg_6_4 and math.max(arg_6_4, -0.9) and -0.9

	local num = 40
	local query = Broadphase.query(cover_points_broadphase, arg_6_0, math.min(arg_6_3, num), tbl_6)
	local normalize = Vector3.normalize
	local forward = Quaternion.forward
	local local_rotation = Unit.local_rotation
	local local_position = Unit.local_position
	local dot = Vector3.dot
	local num_2 = 0
	local count = #arg_6_1

	for i = 1, query do
		local var_6_10 = tbl_6[i]
		local var_6_11 = local_position(var_6_10, 0)
		local var_6_12 = distance_squared(var_6_11, arg_6_0)

		if arg_6_2 <= var_6_12 then
			local var_6_13 = local_rotation(var_6_10, 0)
			local num_3 = 0

			for j = 1, count do
				local var_6_15 = arg_6_1[j]
				local var_6_16 = normalize(var_6_11 - var_6_15)

				Vector3.set_z(var_6_16, 0)

				if not ((not (var_6_12 < 50) or not arg_6_4 or -0.6) > dot(forward(var_6_13), var_6_16)) then
					num_3 = num_3 + 1
				else
					break
				end
			end

			if count == num_3 then
				num_2 = num_2 + 1
				tbl_7[num_2] = var_6_10
			end
		end
	end

	return num_2, tbl_7
end

ConflictUtils.debug_is_cover_point_hidden = function ()
	-- function 7
	local cover_points_broadphase = Managers.state.conflict.level_analysis.cover_points_broadphase
	local query = Broadphase.query(cover_points_broadphase, PLAYER_POSITIONS[1], 20, tbl_6)
	local get = Colors.get("red")
	local get_2 = Colors.get("green")
	local local_rotation = Unit.local_rotation
	local local_position = Unit.local_position
	local num = 5

	for i = 1, query do
		local var_7_7 = tbl_6[i]
		local var_7_8 = local_position(var_7_7, 0)
		local var_7_9 = local_rotation(var_7_7, 0)

		if not ConflictUtils.is_cover_point_hidden(var_7_7, PLAYER_POSITIONS, num) then
			QuickDrawer:sphere(var_7_8, 0.8, get_2)
			QuickDrawer:line(var_7_8 + Vector3(0, 0, 1), var_7_8 + Quaternion.forward(var_7_9) * 2 + Vector3(0, 0, 1), get_2)
		else
			QuickDrawer:sphere(var_7_8, 0.8, get)
			QuickDrawer:line(var_7_8 + Vector3(0, 0, 1), var_7_8 + Quaternion.forward(var_7_9) * 2 + Vector3(0, 0, 1), get)
		end
	end
end

ConflictUtils.is_cover_point_hidden = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local normalize = Vector3.normalize
	local forward = Quaternion.forward
	local local_rotation = Unit.local_rotation
	local local_position = Unit.local_position
	local dot = Vector3.dot
	local flag = arg_8_3 or 10000
	local var_8_6 = local_position(arg_8_0, 0)
	local var_8_7 = local_rotation(arg_8_0, 0)
	local count = #arg_8_1
	local num = 0

	for i = 1, count do
		local var_8_10 = arg_8_1[i]
		local var_8_11 = distance_squared(var_8_6, var_8_10)

		if var_8_11 < arg_8_2 then
			break
		end

		local var_8_12 = normalize(var_8_6 - var_8_10)
		local flag_2

		flag_2 = not (var_8_11 < 225) or not -0.9 or -0.6

		if not (flag_2 > dot(forward(var_8_7), var_8_12) or flag < var_8_11) then
			num = num + 1
		else
			break
		end
	end

	if num == count then
		return true
	end
end

ConflictUtils.get_random_spawner_with_id = function (arg_9_0, arg_9_1)
	-- function 9
	local var_9_0 = Managers.state.entity:system("spawner_system")._id_lookup[arg_9_0]

	if not var_9_0 then
		local count = #var_9_0
		local random = Math.random(1, count)
		local var_9_3 = var_9_0[random]

		if not (not (count > 1) or var_9_3 ~= arg_9_1) then
			random = (random - 1) % count + 1
			var_9_3 = var_9_0[random]
		end

		return var_9_3, random
	end
end

ConflictUtils.get_random_hidden_spawner = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	local system = Managers.state.entity:system("spawner_system")
	local query = Broadphase.query(system.hidden_spawners_broadphase, arg_10_0, arg_10_1, tbl_6)

	if query <= 0 then
		return
	end

	if not arg_10_2 then
		return tbl_6[1]
	end

	local random = math.random(1, query)

	return tbl_6[random]
end

ConflictUtils.get_biggest_cluster = function (self)
	-- function 11
	local num = 1

	for i = 2, #self do
		local var_11_1 = self[i]

		if not var_11_1 then
			if var_11_1 > self[num] then
				num = i
			end
		else
			break
		end
	end

	return num
end

ConflictUtils.filter_positions = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	-- function 12
	local tbl = {}

	arg_12_4 = arg_12_4 * arg_12_4
	arg_12_3 = arg_12_3 * arg_12_3

	local var_12_1 = distance_squared(arg_12_0, arg_12_1)

	for i = 1, #arg_12_2 do
		local var_12_2 = arg_12_2[i]
		local local_position = Unit.local_position(var_12_2, 0)
		local var_12_4 = distance_squared(arg_12_0, local_position)

		if not (not (var_12_4 < arg_12_4) or not (arg_12_3 < var_12_4) or not (var_12_1 > distance_squared(arg_12_1, local_position))) then
			tbl[#tbl + 1] = var_12_2
		end
	end

	return tbl
end

ConflictUtils.filter_horde_spawners = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	local tbl = {}
	local tbl_2 = {}

	arg_13_4 = arg_13_4 * arg_13_4
	arg_13_3 = arg_13_3 * arg_13_3

	for i = 1, #self do
		local var_13_2 = self[i]

		for j = 1, #arg_13_1 do
			local var_13_3 = arg_13_1[j]
			local local_position = Unit.local_position(var_13_3, 0)
			local var_13_5 = distance_squared(var_13_2, local_position)

			if not (not (var_13_5 < arg_13_4) or not (arg_13_3 < var_13_5)) then
				tbl[#tbl + 1] = var_13_3

				if not arg_13_2[var_13_3] then
					tbl_2[#tbl_2 + 1] = var_13_3
				end
			end
		end
	end

	return tbl, tbl_2
end

ConflictUtils.filter_horde_spawners_strictly = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	local tbl = {}
	local tbl_2 = {}

	arg_14_4 = arg_14_4 * arg_14_4
	arg_14_3 = arg_14_3 * arg_14_3

	local count = #self

	for i = 1, #arg_14_1 do
		local var_14_3 = arg_14_1[i]
		local local_position = Unit.local_position(var_14_3, 0)
		local num = 0

		for j = 1, count do
			local var_14_6 = self[j]
			local var_14_7 = distance_squared(var_14_6, local_position)

			if not (not (var_14_7 < arg_14_4) or not (arg_14_3 < var_14_7)) then
				num = num + 1
			end
		end

		if num == count then
			tbl[#tbl + 1] = var_14_3

			if not arg_14_2[var_14_3] then
				tbl_2[#tbl_2 + 1] = var_14_3
			end
		end
	end

	return tbl, tbl_2
end

ConflictUtils.get_hidden_pos = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8, arg_15_9, arg_15_10, arg_15_11, arg_15_12)
	-- function 15
	local var_15_0 = Vector3(0, 0, 1)
	local num = arg_15_8 * 0.5
	local flag = not World.umbra_available(arg_15_0)

	for i = 1, arg_15_10 do
		local var_15_3

		if not arg_15_11 then
			var_15_3 = ConflictUtils.get_spawn_pos_on_cake_slice(arg_15_1, arg_15_5, arg_15_7 - num, arg_15_7 + num, arg_15_11, arg_15_12, 10, arg_15_4, arg_15_2, arg_15_3)
		else
			var_15_3 = ConflictUtils.get_spawn_pos_on_circle(arg_15_1, arg_15_5, arg_15_7, arg_15_8, 10, arg_15_4, arg_15_2, arg_15_3)
		end

		if not var_15_3 then
			local flag_2 = true

			for j = 1, #arg_15_6 do
				local var_15_5 = arg_15_6[j]

				if not (flag or World.umbra_has_line_of_sight(arg_15_0, var_15_3 + var_15_0, var_15_5 + var_15_0)) then
					flag_2 = false

					break
				end
			end

			if not flag_2 then
				return var_15_3
			end
		end
	end
end

ConflictUtils.is_position_inside_no_spawn_volume = function (arg_16_0, arg_16_1, arg_16_2)
	-- function 16
	local inside_level_volume_layer = NavTagVolumeUtils.inside_level_volume_layer(arg_16_0, arg_16_1, arg_16_2, "NO_SPAWN")

	inside_level_volume_layer = inside_level_volume_layer or NavTagVolumeUtils.inside_level_volume_layer(arg_16_0, arg_16_1, arg_16_2, "NO_BOTS_NO_SPAWN")

	return inside_level_volume_layer
end

ConflictUtils.find_center_tri = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	local triangle_from_position, var_17_1, var_17_2, var_17_3, var_17_4 = GwNavQueries.triangle_from_position(arg_17_0, arg_17_1, arg_17_2 or 30, arg_17_3 or 30)

	if not triangle_from_position then
		arg_17_1.z = var_17_1

		return arg_17_1, var_17_2, var_17_3, var_17_4
	end
end

ConflictUtils.find_center_tri_with_fallback = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	arg_18_2, arg_18_3 = arg_18_2 or 30, arg_18_3 or 30

	local triangle_from_position, var_18_1, var_18_2, var_18_3, var_18_4 = GwNavQueries.triangle_from_position(arg_18_0, arg_18_1, arg_18_2, arg_18_3)

	if not triangle_from_position then
		arg_18_1.z = var_18_1

		return arg_18_1, var_18_2, var_18_3, var_18_4
	end

	local num = 5

	if not (arg_18_2 < num or not (arg_18_3 < num)) then
		local triangle_from_position_2, var_18_7, var_18_8, var_18_9, var_18_10 = GwNavQueries.triangle_from_position(arg_18_0, arg_18_1, math.max(arg_18_2, num), math.max(arg_18_3, num))
		local var_18_11 = var_18_10
		local var_18_12 = var_18_9
		local var_18_13 = var_18_8
		local var_18_14 = var_18_7

		if not triangle_from_position_2 then
			arg_18_1.z = var_18_14

			return arg_18_1, var_18_13, var_18_12, var_18_11
		end
	end

	local num_2 = 5

	arg_18_1 = GwNavQueries.inside_position_from_outside_position(arg_18_0, arg_18_1, num, num, num_2, 0.5)

	if not arg_18_1 then
		local var_18_16
		local triangle_from_position_3, var_18_18, var_18_19, var_18_20, var_18_21 = GwNavQueries.triangle_from_position(arg_18_0, arg_18_1, math.max(arg_18_2, num), math.max(arg_18_3, num))

		return arg_18_1, var_18_19, var_18_20, var_18_21
	end

	return nil
end

ConflictUtils.simulate_dummy_target = function (arg_19_0, arg_19_1, arg_19_2)
	-- function 19
	local num = 15
	local var_19_1 = Vector3(num, 0, 1)
	local num_2 = arg_19_2 / 3 % (math.pi * 2)
	local num_3 = arg_19_1 + Quaternion.rotate(Quaternion(Vector3.up(), num_2), var_19_1)
	local triangle_from_position, var_19_5 = GwNavQueries.triangle_from_position(arg_19_0, num_3, 15, 15)

	if not triangle_from_position then
		num_3.z = var_19_5

		return num_3
	end

	return num_3
end

ConflictUtils.test_cake_slice = function (arg_20_0, arg_20_1, arg_20_2)
	-- function 20
	local rotate = Quaternion.rotate(Quaternion(Vector3.up(), math.degrees_to_radians(arg_20_2 % 20 / 20 * 360)), Vector3(0, 20, 0))

	QuickDrawer:line(arg_20_1 + Vector3(0, 0, 1), arg_20_1 + rotate + Vector3(0, 0, 1), Color(0, 255, 175))

	for i = 1, 100 do
		local get_spawn_pos_on_cake_slice = ConflictUtils.get_spawn_pos_on_cake_slice(arg_20_0, arg_20_1, 1, 40, rotate, math.pi / 4, 5)

		if not get_spawn_pos_on_cake_slice then
			QuickDrawer:sphere(get_spawn_pos_on_cake_slice, 0.5, Color(0, 0, 175))
		end
	end
end

ConflictUtils.get_spawn_pos_on_cake_slice = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7, arg_21_8, arg_21_9)
	-- function 21
	local atan2 = math.atan2(arg_21_4.x, arg_21_4.y)
	local num = arg_21_5 * 0.5
	local num_2 = atan2 - num
	local num_3 = atan2 + num

	for i = 1, arg_21_6 do
		local get_uniformly_random_point_inside_sector, var_21_5 = math.get_uniformly_random_point_inside_sector(arg_21_2, arg_21_3, num_2, num_3)
		local var_21_6 = Vector3(arg_21_1.x + get_uniformly_random_point_inside_sector, arg_21_1.y + var_21_5, arg_21_1.z)
		local triangle_from_position, var_21_8 = GwNavQueries.triangle_from_position(arg_21_0, var_21_6, 30, 30)

		if not triangle_from_position then
			Vector3.set_z(var_21_6, var_21_8)

			if not (not arg_21_7 and ConflictUtils.is_position_inside_no_spawn_volume(arg_21_8, arg_21_9, var_21_6)) then
				return var_21_6
			end
		end
	end

	return false
end

ConflictUtils.get_spawn_pos_on_circle = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8, arg_22_9)
	-- function 22
	local var_22_0
	local var_22_1
	local var_22_2

	for i = 1, arg_22_4 do
		local var_22_3 = Vector3(arg_22_2 + (math.random() - 0.5) * arg_22_3, 0, 1)
		local num = arg_22_1 + Quaternion.rotate(Quaternion(Vector3.up(), math.degrees_to_radians(Math.random(1, 360))), var_22_3)
		local find_center_tri, var_22_6, var_22_7, var_22_8 = ConflictUtils.find_center_tri(arg_22_0, num, arg_22_8, arg_22_9)

		if not (not find_center_tri and not arg_22_5 and ConflictUtils.is_position_inside_no_spawn_volume(arg_22_6, arg_22_7, find_center_tri)) then
			return find_center_tri, var_22_6, var_22_7, var_22_8
		end
	end

	return false
end

ConflictUtils.get_pos_towards_goal = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7, arg_23_8)
	-- function 23
	arg_23_4 = arg_23_4 or 1

	for i = 1, arg_23_4 do
		local var_23_0
		local var_23_1

		if not arg_23_5 then
			var_23_1 = arg_23_1 + arg_23_5 * arg_23_2 + (math.random() - 0.5) * arg_23_3
		else
			local var_23_2 = Vector3(arg_23_2 + (math.random() - 0.5) * arg_23_3, 0, 0)

			var_23_1 = arg_23_1 + Quaternion.rotate(Quaternion(Vector3.up(), math.degrees_to_radians(Math.random(1, 360))), var_23_2)
		end

		local raycast, var_23_4 = GwNavQueries.raycast(arg_23_0, arg_23_1, var_23_1)

		if not var_23_4 then
			local var_23_5
			local triangle_from_position, var_23_7 = GwNavQueries.triangle_from_position(arg_23_0, var_23_4, 1, 1)

			if not triangle_from_position then
				var_23_5 = var_23_4
			else
				var_23_5 = GwNavQueries.inside_position_from_outside_position(arg_23_0, var_23_4, 3, 3, 5, 0.5)
			end

			if not (not arg_23_6 and ConflictUtils.is_position_inside_no_spawn_volume(arg_23_7, arg_23_8, var_23_4)) then
				return var_23_5
			end
		end
	end

	return false
end

ConflictUtils.get_furthest_pos_from_pos_on_circle = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
	-- function 24
	local tbl = {}

	for i = 1, arg_24_4 do
		local var_24_1 = Vector3(arg_24_2 + (math.random() - 0.5) * arg_24_3, 0, 1)
		local num = arg_24_1 + Quaternion.rotate(Quaternion(Vector3.up(), math.degrees_to_radians(Math.random(1, 360))), var_24_1)
		local find_center_tri = ConflictUtils.find_center_tri(arg_24_0, num)

		if not find_center_tri then
			tbl[#tbl + 1] = find_center_tri
		end
	end

	local num_2 = (arg_24_2 + 0.5 * arg_24_3 + 1) * 2 * ((arg_24_2 + 0.5 * arg_24_3 + 1) * 2)
	local var_24_5
	local num_3 = 0

	for i_2, v in ipairs(tbl) do
		if not var_24_5 then
			var_24_5 = v
		elseif not v then
			local distance_squared = Vector3.distance_squared(arg_24_5, v)

			if not (not (num_3 < distance_squared) or not (distance_squared <= num_2)) then
				var_24_5 = v
				num_3 = distance_squared
			end
		end
	end

	if not var_24_5 then
		return var_24_5
	end

	return false
end

ConflictUtils.get_spawn_pos_on_circle_with_func = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6, arg_25_7, arg_25_8)
	-- function 25
	for i = 1, arg_25_4 do
		local var_25_0 = Vector3(arg_25_2 + (math.random() - 0.5) * arg_25_3, 0, 1)
		local num = arg_25_1 + Quaternion.rotate(Quaternion(Vector3.up(), math.degrees_to_radians(Math.random(1, 360))), var_25_0)
		local find_center_tri = ConflictUtils.find_center_tri(arg_25_0, num, arg_25_7, arg_25_8)

		if not find_center_tri and not arg_25_5(find_center_tri, arg_25_6) then
			return find_center_tri
		end
	end

	return false
end

ConflictUtils.get_spawn_pos_on_circle_with_func_range = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6, arg_26_7, arg_26_8)
	-- function 26
	for i = 1, arg_26_4 do
		local var_26_0 = Vector3(math.lerp(arg_26_2, arg_26_3, math.random()), 0, 1)
		local num = arg_26_1 + Quaternion.rotate(Quaternion(Vector3.up(), math.degrees_to_radians(Math.random(1, 360))), var_26_0)
		local find_center_tri = ConflictUtils.find_center_tri(arg_26_0, num, arg_26_7, arg_26_8)

		if not find_center_tri and not arg_26_5(find_center_tri, arg_26_6) then
			return find_center_tri
		end
	end

	return false
end

ConflictUtils.draw_stack_of_balls = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	-- function 27
	QuickDrawer:sphere(arg_27_0 + Vector3(0, 0, 1), 0.4, Color(arg_27_1, arg_27_2, arg_27_3, arg_27_4))
	QuickDrawer:sphere(arg_27_0 + Vector3(0, 0, 1.5), 0.3, Color(arg_27_1, arg_27_2 * 0.75, arg_27_3 * 0.75, arg_27_4 * 0.75))
	QuickDrawer:sphere(arg_27_0 + Vector3(0, 0, 2), 0.2, Color(arg_27_1, arg_27_2 * 0.5, arg_27_3 * 0.5, arg_27_4 * 0.5))
	QuickDrawer:sphere(arg_27_0 + Vector3(0, 0, 2.5), 0.1, Color(arg_27_1, arg_27_2 * 0.25, arg_27_3 * 0.25, arg_27_4 * 0.25))
end

local tbl_8 = {}

ConflictUtils.get_teleporter_portals = function ()
	-- function 28
	local level_key = Managers.state.game_mode:level_key()
	local level_name = LevelSettings[level_key].level_name
	local var_28_2 = tbl_8[level_name]

	if not var_28_2 then
		return var_28_2
	end

	local tbl = {}

	tbl_8[level_name] = tbl

	local unit_indices = LevelResource.unit_indices(level_name, "units/hub_elements/portal")

	for i, v in ipairs(unit_indices) do
		local unit_position = LevelResource.unit_position(level_name, v)
		local unit_rotation = LevelResource.unit_rotation(level_name, v)
		local unit_data = LevelResource.unit_data(level_name, v)
		local get = DynamicData.get(unit_data, "id")
		local var_28_9 = QuaternionBox(unit_rotation)
		local var_28_10 = Vector3Box(unit_position)

		tbl[get] = {
			var_28_10,
			var_28_9
		}
	end

	return tbl
end

ConflictUtils.interest_point_outside_nav_mesh = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	-- function 29
	local var_29_0 = InterestPointUnitsLookup[arg_29_1]

	for i = 1, #var_29_0 do
		local unbox = var_29_0[i][1]:unbox()
		local num = arg_29_2 + Quaternion.rotate(arg_29_3, unbox)
		local triangle_from_position, var_29_4 = GwNavQueries.triangle_from_position(arg_29_0, num, 0.3, 0.3)

		if not triangle_from_position then
			return num
		end
	end
end

ConflictUtils.generate_spawn_point_lookup = function (arg_30_0)
	-- function 30
	local InterestPointUnits = InterestPointUnits
	local tbl = {}
	local var_30_2 = Vector3(0, 0, -1000)
	local identity = Quaternion.identity()

	for i, v in ipairs(InterestPointUnits) do
		if not v then
			for i_2, v_2 in ipairs(v) do
				local spawn_unit = World.spawn_unit(arg_30_0, v_2, var_30_2, identity)
				local tbl_2 = {}
				local num = 0

				while not Unit.has_data(spawn_unit, "interest_point", "points", num) do
					local get_data = Unit.get_data(spawn_unit, "interest_point", "points", num, "node")
					local node = Unit.node(spawn_unit, get_data)
					local var_30_9

					if get_data == "root_point" then
						var_30_9 = Vector3(0, 0, 0)

						if not var_30_9 then
							-- Nothing
						end
					end

					var_30_9 = Unit.local_position(spawn_unit, node)

					::label_30_0::

					local local_rotation = Unit.local_rotation(spawn_unit, node)

					tbl_2[#tbl_2 + 1] = {
						Vector3Box(var_30_9),
						QuaternionBox(local_rotation)
					}
					num = num + 1
				end

				tbl[v_2] = tbl_2

				World.destroy_unit(arg_30_0, spawn_unit)
			end
		end
	end

	InterestPointUnitsLookup = tbl
end

ConflictUtils.display_number_of_breeds = function (arg_31_0, arg_31_1, arg_31_2)
	-- function 31
	local str = arg_31_0 .. tostring(arg_31_1) .. ", "

	for k, v in pairs(arg_31_2) do
		if v > 0 then
			str = str .. k .. "=" .. v .. ", "
		end
	end

	Debug.text(str)
end

local tbl_9 = {}

ConflictUtils.display_number_of_breeds_in_segment = function (arg_32_0, arg_32_1, arg_32_2)
	-- function 32
	table.clear(tbl_9)

	local str = arg_32_0 .. ", "

	for k, v in pairs(arg_32_1) do
		for k_2, v_2 in pairs(v) do
			local has_extension = ScriptUnit.has_extension(v_2, "health_system")
			local hi_data = arg_32_2.hi_data
			local zone_data = has_extension.zone_data

			zone_data = not zone_data and has_extension.zone_data.hi_data

			if not (not hi_data and hi_data ~= zone_data) then
				local var_32_4 = tbl_9
				local var_32_5 = tbl_9[k]

				var_32_5 = var_32_5 or 0
				var_32_4[k] = var_32_5 + 1

				QuickDrawer:sphere(POSITION_LOOKUP[v_2], 0.75, Color(200, 0, 200))
			end
		end
	end

	Debug.text(str)

	for k_3, v_3 in pairs(tbl_9) do
		str = str .. k_3 .. "=" .. v_3 .. ", "
	end

	return str
end

ConflictUtils.show_where_ai_is = function (self)
	-- function 33
	local POSITION_LOOKUP = POSITION_LOOKUP
	local var_33_1 = Vector3(0, 0, 40)

	for i = 1, #self do
		local var_33_2 = self[i]
		local var_33_3 = POSITION_LOOKUP[var_33_2]
		local get_data = Unit.get_data(var_33_2, "breed")

		QuickDrawer:line(var_33_3, var_33_3 + var_33_1, Color(unpack(get_data.debug_color)))
	end
end

ConflictUtils.make_roaming_spawns = function (arg_34_0, arg_34_1)
	-- function 34
	local tbl = {}

	if not LEVEL_EDITOR_TEST then
		return tbl
	end

	local density = CurrentConflictSettings.roaming.density

	density = density or 0.01

	local get_start_and_finish = arg_34_1:get_start_and_finish()

	if not get_start_and_finish then
		get_start_and_finish = get_start_and_finish:unbox()
	else
		local level_key = Managers.state.game_mode:level_key()
		local level_name = LevelSettings[level_key].level_name
		local unit_indices = LevelResource.unit_indices(level_name, "core/gwnav/units/seedpoint/seedpoint")

		if #unit_indices > 0 then
			local var_34_6 = unit_indices[1]

			get_start_and_finish = LevelResource.unit_position(level_name, var_34_6)
		end
	end

	local get_seed_triangle = GwNavTraversal.get_seed_triangle(arg_34_0, get_start_and_finish)
	local tbl_2 = {
		get_seed_triangle
	}
	local num = 1
	local num_2 = 0
	local tbl_3 = {}
	local get_triangle_vertices, var_34_13, var_34_14 = GwNavTraversal.get_triangle_vertices(arg_34_0, get_seed_triangle)
	local num_3 = (get_triangle_vertices + var_34_13 + var_34_14) / 3

	tbl_3[num_3.x * 0.0001 + num_3.y + num_3.z * 10000] = true

	while num_2 < num do
		num_2 = num_2 + 1

		local var_34_16 = tbl_2[num_2]
		local temp_count, var_34_18, var_34_19 = Script.temp_count()
		local get_triangle_vertices_2, var_34_21, var_34_22 = GwNavTraversal.get_triangle_vertices(arg_34_0, var_34_16)
		local num_4 = (get_triangle_vertices_2 + var_34_21 + var_34_22) / 3

		if density > math.random() then
			tbl[#tbl + 1] = Vector3Box(num_4)
		end

		Script.set_temp_count(temp_count, var_34_18, var_34_19)

		local tbl_4 = {
			GwNavTraversal.get_neighboring_triangles(var_34_16)
		}

		for i = 1, #tbl_4 do
			local var_34_25 = tbl_4[i]
			local temp_count_2, var_34_27, var_34_28 = Script.temp_count()
			local get_triangle_vertices_3, var_34_30, var_34_31 = GwNavTraversal.get_triangle_vertices(arg_34_0, var_34_25)
			local var_34_32 = var_34_31
			local var_34_33 = var_34_30
			local num_5 = (get_triangle_vertices_3 + var_34_33 + var_34_32) / 3
			local num_6 = num_5.x * 0.0001 + num_5.y + num_5.z * 10000

			Script.set_temp_count(temp_count_2, var_34_27, var_34_28)

			if not tbl_3[num_6] then
				num = num + 1
				tbl_2[num] = var_34_25
				tbl_3[num_6] = true
			end
		end
	end

	return tbl
end

local function fn_2(self, arg_35_1, arg_35_2)
	-- function 35
	local var_35_0 = self[arg_35_1]

	if not var_35_0 then
		for i = 1, #var_35_0 do
			local var_35_1 = var_35_0[i]

			for j = 1, #var_35_1 do
				local var_35_2 = var_35_1[j]

				if not Breeds[var_35_2] then
					arg_35_2[var_35_2] = true
				end
			end
		end
	end
end

local function fn_3(self, arg_36_1, arg_36_2)
	-- function 36
	local num = DifficultySettings[arg_36_2].rank - 1
	local var_36_1 = HordeCompositions[arg_36_1][num]

	fassert(var_36_1 ~= nil, string.format("No horde composition found for '%s' on difficulty '%s'", arg_36_1, arg_36_2))

	for i = 1, #var_36_1 do
		local breeds = var_36_1[i].breeds

		for j = 1, #breeds, 2 do
			self[breeds[j]] = true
		end
	end
end

local function fn_4(self, arg_37_1, arg_37_2)
	-- function 37
	local var_37_0 = BreedActions[arg_37_1]

	if not var_37_0 then
		for k, v in pairs(var_37_0) do
			if v.difficulty_spawn_list or not v.spawn_list then
				local var_37_1

				if not v.difficulty_spawn_list then
					var_37_1 = v.difficulty_spawn_list[arg_37_2]

					if not var_37_1 then
						-- Nothing
					end
				end

				var_37_1 = v.spawn_list

				::label_37_0::

				for k_2 = 1, #var_37_1 do
					self[var_37_1[k_2]] = true
				end
			end

			if not v.phase_spawn then
				for k_3, v_2 in pairs(v.phase_spawn) do
					fn_3(self, v_2, arg_37_2)
				end
			end

			if v.difficulty_spawn or not v.spawn then
				local var_37_2

				if not v.difficulty_spawn then
					var_37_2 = v.difficulty_spawn[arg_37_2]

					if not var_37_2 then
						-- Nothing
					end
				end

				var_37_2 = v.spawn

				::label_37_1::

				fn_3(self, var_37_2, arg_37_2)
			end
		end
	end
end

local function fn_5(self, arg_38_1, arg_38_2)
	-- function 38
	if type(arg_38_1) == "table" then
		for i = 1, #arg_38_1 do
			local var_38_0 = arg_38_1[i]

			self[var_38_0] = true

			fn_4(self, var_38_0, arg_38_2)
		end
	else
		self[arg_38_1] = true

		fn_4(self, arg_38_1, arg_38_2)
	end
end

ConflictUtils.add_breeds_from_event = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5)
	-- function 39
	for i = 1, #arg_39_1 do
		repeat
			local var_39_0 = arg_39_1[i]
			local var_39_1 = var_39_0[1]
			local difficulty_requirement = var_39_0.difficulty_requirement

			if not (not difficulty_requirement and not (difficulty_requirement > (arg_39_3 or DifficultySettings.normal.rank))) then
				break
			end

			if not (var_39_1 == "spawn" or var_39_1 == "spawn_at_raw" or var_39_1 == "spawn_special" or var_39_1 == "spawn_weave_special" or var_39_1 ~= "spawn_weave_special_event") then
				fn_5(arg_39_4, var_39_0.breed_name, arg_39_2)

				break
			end

			if var_39_1 == "spawn_patrol" then
				local formations = var_39_0.formations

				for j = 1, #formations do
					local var_39_4 = formations[j]
					local var_39_5 = PatrolFormationSettings[var_39_4]

					fn_2(var_39_5, arg_39_2, arg_39_4)
				end

				break
			end

			if var_39_1 == "start_event" then
				local start_event_name = var_39_0.start_event_name
				local var_39_7 = arg_39_5[start_event_name]

				if start_event_name ~= arg_39_0 then
					ConflictUtils.add_breeds_from_event(arg_39_0, var_39_7, arg_39_2, arg_39_3, arg_39_4, arg_39_5)
				end

				break
			end

			if not (var_39_1 == "event_horde" or var_39_1 ~= "ambush_horde") then
				local composition_type = var_39_0.composition_type

				fn_3(arg_39_4, composition_type, arg_39_2)
			end
		until true
	end
end

local function fn_6(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	-- function 40
	local rank = DifficultySettings[arg_40_1].rank

	for k, v in pairs(arg_40_0) do
		local var_40_1 = fn(arg_40_0, k, arg_40_1, arg_40_2)

		if type(var_40_1) == "table" then
			local event_lookup = var_40_1.event_lookup

			for k_2, v_2 in pairs(event_lookup) do
				for i4 = 1, #v_2 do
					local var_40_3 = v_2[i4]
					local GenericTerrorEvents = GenericTerrorEvents
					local var_40_5 = GenericTerrorEvents[var_40_3]

					ConflictUtils.add_breeds_from_event(var_40_3, var_40_5, arg_40_1, rank, arg_40_3, GenericTerrorEvents)
				end
			end
		end
	end
end

local function fn_7(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	-- function 41
	local var_41_0 = fn(arg_41_0, "breeds", arg_41_1, arg_41_2)

	for i = 1, #var_41_0 do
		arg_41_3[var_41_0[i]] = true
	end

	local breeds = fn(arg_41_0, "rush_intervention", arg_41_1, arg_41_2).breeds

	for j = 1, #breeds do
		arg_41_3[breeds[j]] = true
	end

	local var_41_2 = fn(arg_41_0, "speed_running_intervention", arg_41_1, arg_41_2)

	var_41_2 = var_41_2 or SpecialsSettings.default.speed_running_intervention

	local breeds_2 = var_41_2.breeds

	for k = 1, #breeds_2 do
		arg_41_3[breeds_2[k]] = true
	end

	local vector_horde_breeds = var_41_2.vector_horde_breeds

	for l = 1, #vector_horde_breeds do
		arg_41_3[vector_horde_breeds[l]] = true
	end
end

local function fn_8(self, arg_42_1, arg_42_2)
	-- function 42
	local zone_checks = self.zone_checks
	local num = 3
	local var_42_2 = zone_checks.clamp_breeds_low[arg_42_1]

	if not var_42_2 then
		for i = 1, #var_42_2 do
			arg_42_2[var_42_2[i][num].name] = true
		end
	end

	local var_42_3 = zone_checks.clamp_breeds_hi[arg_42_1]

	if not var_42_3 then
		for j = 1, #var_42_3 do
			arg_42_2[var_42_3[j][num].name] = true
		end
	end

	for k = 1, #self do
		local members = self[k].members

		for l = 1, #members do
			local var_42_5 = members[l]
			local name = var_42_5.name

			if not name then
				arg_42_2[name] = true
			else
				for i_2, v in ipairs(var_42_5) do
					arg_42_2[v.name] = true
				end
			end
		end
	end
end

local function fn_9(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	-- function 43
	local var_43_0 = fn(arg_43_0, "roaming_set", arg_43_1, arg_43_2)
	local breed_packs = var_43_0.breed_packs
	local var_43_2 = BreedPacks[breed_packs]

	fn_8(var_43_2, arg_43_1, arg_43_3)

	local num = 1
	local breed_packs_override = var_43_0.breed_packs_override

	for i = 1, #breed_packs_override do
		local var_43_5 = breed_packs_override[i][num]
		local var_43_6 = BreedPacks[var_43_5]

		fn_8(var_43_6, arg_43_1, arg_43_3)
	end
end

local function fn_10(self, arg_44_1, arg_44_2, arg_44_3)
	-- function 44
	local var_44_0 = fn(self, "compositions_pacing", arg_44_1, arg_44_2)
	local var_44_1 = fn(self, "ambush_composition", arg_44_1, arg_44_2)

	if type(var_44_1) == "table" then
		for i = 1, #var_44_1 do
			local var_44_2 = var_44_1[i]
			local var_44_3 = HordeWaveCompositions[var_44_2]

			for j = 1, #var_44_3 do
				local var_44_4 = var_44_0[var_44_3[j]]

				for k = 1, #var_44_4 do
					local breeds = var_44_4[k].breeds

					for l = 1, #breeds, 2 do
						arg_44_3[breeds[l]] = true
					end
				end
			end
		end
	else
		local var_44_6 = var_44_0[var_44_1]

		for i4 = 1, #var_44_6 do
			local breeds_2 = var_44_6[i4].breeds

			for i5 = 1, #breeds_2, 2 do
				arg_44_3[breeds_2[i5]] = true
			end
		end
	end

	local vector_composition = self.vector_composition

	if type(vector_composition) == "table" then
		for i6 = 1, #vector_composition do
			local var_44_9 = vector_composition[i6]
			local var_44_10 = HordeWaveCompositions[var_44_9]

			for i7 = 1, #var_44_10 do
				local var_44_11 = var_44_0[var_44_10[i7]]

				for i8 = 1, #var_44_11 do
					local breeds_3 = var_44_11[i8].breeds

					for i9 = 1, #breeds_3, 2 do
						arg_44_3[breeds_3[i9]] = true
					end
				end
			end
		end
	else
		local var_44_13 = var_44_0[vector_composition]

		for i10 = 1, #var_44_13 do
			local breeds_4 = var_44_13[i10].breeds

			for i11 = 1, #breeds_4, 2 do
				arg_44_3[breeds_4[i11]] = true
			end
		end
	end

	local vector_blob_composition = self.vector_blob_composition

	if type(vector_blob_composition) == "table" then
		for i12 = 1, #vector_blob_composition do
			local var_44_16 = vector_blob_composition[i12]
			local var_44_17 = HordeWaveCompositions[var_44_16]

			for i13 = 1, #var_44_17 do
				local var_44_18 = var_44_0[var_44_17[i13]]

				for i14 = 1, #var_44_18 do
					local breeds_5 = var_44_18[i14].breeds

					for i15 = 1, #breeds_5, 2 do
						arg_44_3[breeds_5[i15]] = true
					end
				end
			end
		end
	else
		local var_44_20 = var_44_0[vector_blob_composition]

		for i16 = 1, #var_44_20 do
			local breeds_6 = var_44_20[i16].breeds

			for i17 = 1, #breeds_6, 2 do
				arg_44_3[breeds_6[i17]] = true
			end
		end
	end

	local var_44_22 = var_44_0[self.mini_patrol_composition]

	for i18 = 1, #var_44_22 do
		local breeds_7 = var_44_22[i18].breeds

		for i19 = 1, #breeds_7, 2 do
			arg_44_3[breeds_7[i19]] = true
		end
	end
end

ConflictUtils.find_conflict_director_breeds = function (self, arg_45_1, arg_45_2)
	-- function 45
	local fallback_difficulty = DifficultySettings[arg_45_1].fallback_difficulty

	if not self.boss.disabled then
		fn_6(self.boss, arg_45_1, fallback_difficulty, arg_45_2)
	end

	if not self.specials.disabled then
		fn_7(self.specials, arg_45_1, fallback_difficulty, arg_45_2)
	end

	if not self.pack_spawning.disabled then
		fn_9(self.pack_spawning, arg_45_1, fallback_difficulty, arg_45_2)
	end

	if not self.horde.disabled then
		fn_10(self.horde, arg_45_1, fallback_difficulty, arg_45_2)
	end

	return arg_45_2
end

ConflictUtils.patch_settings_with_difficulty = function (self, arg_46_1, arg_46_2)
	-- function 46
	local difficulty_overrides = self.difficulty_overrides

	if not difficulty_overrides then
		-- Nothing
	end

	::label_46_0::

	local var_46_1 = difficulty_overrides[arg_46_1]

	var_46_1 = var_46_1 or difficulty_overrides[arg_46_2]

	::label_46_1::

	if not var_46_1 then
		for k, v in pairs(self) do
			if k ~= "difficulty_overrides" then
				local var_46_2 = var_46_1[k]

				var_46_2 = var_46_2 or self[k]
				self[k] = var_46_2
			end
		end

		self.difficulty_overrides = nil

		return self
	else
		return self
	end
end

ConflictUtils.patch_terror_events_with_weaves = function (arg_47_0, arg_47_1, arg_47_2)
	-- function 47
	local name = arg_47_1.name
	local objectives = WeaveSettings.templates[name].objectives
	local weaves = TerrorEventBlueprints.weaves
	local TerrorEventBlueprints = TerrorEventBlueprints
	local var_47_4 = TerrorEventBlueprints[arg_47_0]

	var_47_4 = var_47_4 or {}
	TerrorEventBlueprints[arg_47_0] = var_47_4

	table.clear(TerrorEventBlueprints[arg_47_0])

	local var_47_5 = objectives[arg_47_2]
	local spawning_settings = var_47_5.spawning_settings

	if not spawning_settings then
		local main_path_spawning = spawning_settings.main_path_spawning
		local terror_event_trickle = spawning_settings.terror_event_trickle

		if not main_path_spawning then
			for i = 1, #main_path_spawning do
				local terror_event_name = main_path_spawning[i].terror_event_name

				TerrorEventBlueprints[arg_47_0][terror_event_name] = weaves[terror_event_name]
			end
		end

		if not terror_event_trickle then
			TerrorEventBlueprints[arg_47_0][terror_event_trickle] = weaves[terror_event_trickle]
		end
	end

	local terror_events = var_47_5.terror_events

	if not terror_events then
		for j = 1, #terror_events do
			local var_47_11 = terror_events[j]

			TerrorEventBlueprints[arg_47_0][var_47_11] = weaves[var_47_11]
		end
	end
end

ConflictUtils.generate_conflict_director_locked_functions = function (arg_48_0)
	-- function 48
	local tbl = {}

	for k, v in pairs(ConflictDirectorLockedFunctions) do
		if not v(arg_48_0) then
			tbl[#tbl + 1] = k
		end
	end

	return tbl
end

ConflictUtils.teleport_ai_unit = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3)
	-- function 49
	if not arg_49_1 then
		if not ALIVE[arg_49_0] then
			local var_49_0 = BLACKBOARDS[arg_49_0]
			local navigation_extension = var_49_0.navigation_extension
			local locomotion_extension = var_49_0.locomotion_extension

			if not navigation_extension and not locomotion_extension then
				navigation_extension:set_navbot_position(arg_49_1)
				locomotion_extension:teleport_to(arg_49_1)
				Managers.state.entity:system("ai_bot_group_system"):enemy_teleported(arg_49_0, arg_49_1)
			end
		end

		Managers.state.entity:system("ping_system"):remove_ping_from_unit(arg_49_0)

		if not arg_49_2 then
			Managers.state.entity:system("audio_system"):play_audio_unit_event(arg_49_2, arg_49_0)
		end

		if not arg_49_3 then
			local var_49_3 = NetworkLookup.effects[arg_49_3]
			local num = 0
			local identity = Quaternion.identity()
			local var_49_6 = POSITION_LOOKUP[arg_49_0]
			local network = Managers.state.network

			network:rpc_play_particle_effect(nil, var_49_3, NetworkConstants.invalid_game_object_id, num, var_49_6, identity, false)
			network:rpc_play_particle_effect(nil, var_49_3, NetworkConstants.invalid_game_object_id, num, arg_49_1, identity, false)
		end
	end
end

ConflictUtils.look_at_position_flat = function (arg_50_0, arg_50_1)
	-- function 50
	local flat = Vector3.flat(arg_50_1 - arg_50_0)
	local normalize = Vector3.normalize(flat)

	return (look(normalize, Vector3.up()))
end

ConflictUtils.get_closest_position = function (arg_51_0, arg_51_1)
	-- function 51
	local huge = math.huge
	local var_51_1

	for i = 1, #arg_51_1 do
		local var_51_2 = arg_51_1[i]
		local var_51_3 = distance_squared(arg_51_0, var_51_2)

		if var_51_3 < huge then
			huge = var_51_3
			var_51_1 = var_51_2
		end
	end

	return var_51_1, huge
end

ConflictUtils.override_extension_init_data = function (self, arg_52_1)
	-- function 52
	local extension_init_data = arg_52_1.extension_init_data

	if not extension_init_data then
		for k, v in pairs(extension_init_data) do
			table.merge(self[k], v)
		end
	end
end

local function fn_11(arg_53_0, arg_53_1, arg_53_2, arg_53_3)
	-- function 53
	local num = arg_53_3 - arg_53_2
	local length = Vector3.length(num)
	local normalize = Vector3.normalize(num)
	local raycast, var_53_4, var_53_5, var_53_6, var_53_7 = PhysicsWorld.raycast(arg_53_0, arg_53_2, normalize, length, "closest", "collision_filter", "filter_ai_line_of_sight_check")
	local flag = not raycast and Actor.unit(var_53_7)

	return not raycast and flag == arg_53_1
end

ConflictUtils.raise_dead = function (arg_54_0, arg_54_1, arg_54_2)
	-- function 54
	if not arg_54_0 then
		arg_54_1 = arg_54_1 or 10

		local tbl = {}
		local tbl_2 = {}

		Managers.state.entity:system("death_system"):get_dead(tbl)

		for k, v in pairs(tbl) do
			local var_54_2 = BLACKBOARDS[k]

			if not var_54_2 then
				local breed = var_54_2.breed
				local var_54_4 = POSITION_LOOKUP[k]

				if not (not (arg_54_1 > Vector3.distance(arg_54_0, var_54_4)) or breed.is_resurrectable == false) then
					if not Unit.has_animation_event(k, "spawn_floor") then
						tbl_2[#tbl_2 + 1] = k
					else
						printf("Can't raise %s missing animation event: 'spawn_floor' ", BLACKBOARDS[k].breed.name)
					end
				end
			end
		end

		local count = #tbl_2

		if count > 0 then
			local local_player = Managers.player:local_player()
			local resurrected_group_id = local_player.resurrected_group_id
			local flag = resurrected_group_id or Managers.state.entity:system("ai_group_system"):generate_group_id()
			local tbl_3 = {
				insert_into_group = true,
				template = "resurrected",
				group_type = "resurrected",
				id = flag,
				size = count,
				commanding_player = local_player
			}

			local_player.resurrected_group_id = flag

			for k_2 = 1, count do
				local var_54_10 = tbl_2[k_2]
				local var_54_11 = POSITION_LOOKUP[var_54_10]
				local local_rotation = Unit.local_rotation(var_54_10, 0)
				local breed_2 = BLACKBOARDS[var_54_10].breed
				local str = "resurrected"
				local str_2 = "spawn_floor"
				local tbl_4 = {
					ignore_breed_limits = true,
					side_id = arg_54_2,
					insert_into_group = resurrected_group_id ~= nil
				}

				Managers.state.conflict:spawn_queued_unit(breed_2, Vector3Box(var_54_11), QuaternionBox(local_rotation), str, str_2, nil, tbl_4, tbl_3)
				Managers.state.unit_spawner:mark_for_deletion(var_54_10)
			end
		end
	end
end

ConflictUtils.command_ai_to_move = function (self, arg_55_1, arg_55_2)
	-- function 55
	if not arg_55_2 then
		local get_ai_group = Managers.state.entity:system("ai_group_system"):get_ai_group(self.resurrected_group_id)

		if not get_ai_group then
			QuickDrawer:sphere(arg_55_2, 2, Color(100, 0, 255))

			local num = 1
			local members_n = get_ai_group.members_n
			local num_2 = 8
			local ceil = math.ceil(math.sqrt(members_n))

			for k, v in pairs(get_ai_group.members) do
				local var_55_5 = BLACKBOARDS[k]

				for k_2 = 1, num_2 do
					local var_55_6 = Vector3(4 * math.random() - 2, 4 * math.random() - 2, 0)

					if k_2 == 1 then
						var_55_6 = Vector3(-ceil / 2 + num % ceil, -ceil / 2 + math.floor(num / ceil), 0)
					end

					local pos_on_mesh = LocomotionUtils.pos_on_mesh(arg_55_1, arg_55_2 + var_55_6)

					if not pos_on_mesh then
						var_55_5.new_move_to_goal = true
						var_55_5.goal_destination = Vector3Box(pos_on_mesh)

						break
					end
				end

				num = num + 1
			end
		end
	end
end

ConflictUtils.find_positions_around_position = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4, arg_56_5, arg_56_6, arg_56_7, arg_56_8, arg_56_9, arg_56_10, arg_56_11, arg_56_12, arg_56_13, arg_56_14, arg_56_15)
	-- function 56
	arg_56_7 = arg_56_7 or 1

	local function fn(arg_57_0)
		-- function 57
		local pow = math.pow(arg_56_7, 2)

		if not arg_56_6 then
			for i = 1, #arg_56_6 do
				local var_57_1 = arg_56_6[i]

				if pow > Vector3.distance_squared(arg_57_0, var_57_1) then
					return false
				end
			end
		end

		for j = 1, #arg_56_1 do
			local var_57_2 = arg_56_1[j]

			if pow > Vector3.distance_squared(arg_57_0, var_57_2) then
				return false
			end
		end

		if not arg_56_13 then
			local var_57_3 = Vector3(0, 0, 1)
			local num = arg_57_0 + var_57_3
			local num_2 = arg_56_0 + var_57_3

			return (fn_11(arg_56_14, arg_56_15, num, num_2))
		end

		return true
	end

	local num = arg_56_4 - arg_56_3
	local num_2 = arg_56_3 + num * 0.5

	arg_56_9 = arg_56_9 or 4

	local num_3 = math.pi * 2 / arg_56_9
	local flag = arg_56_10 or 2
	local num_4 = 2 * math.pi
	local num_5 = (math.random() - 0.5) * num
	local num_6 = math.random() * num_4
	local num_7 = 0

	arg_56_8 = arg_56_8 or 30

	local function fn_2()
		-- function 58
		num_6 = num_6 + num_3

		if num_6 > num_4 then
			num_6 = num_6 - num_4
		end

		num_7 = num_7 + 1

		if num_7 > arg_56_9 then
			num_5 = num_5 + flag

			if num_5 > num * 0.5 then
				num_5 = num_5 - num
			end

			num_7 = 0
			num_6 = math.random() * num_4
		end

		local var_58_0 = Vector3(num_2 + num_5, 0, 0)

		return arg_56_0 + Quaternion.rotate(Quaternion(Vector3.up(), num_6), var_58_0)
	end

	for i = 1, arg_56_5 do
		for j = 1, arg_56_8 do
			local var_56_10 = fn_2()
			local find_center_tri_with_fallback = ConflictUtils.find_center_tri_with_fallback(arg_56_2, var_56_10, arg_56_11, arg_56_12)

			if not find_center_tri_with_fallback then
				if not fn(find_center_tri_with_fallback) then
					arg_56_1[#arg_56_1 + 1] = find_center_tri_with_fallback
				end

				break
			end
		end
	end

	return arg_56_1
end

local function fn_12(arg_59_0, arg_59_1, arg_59_2)
	-- function 59
	local raycast, var_59_1, var_59_2, var_59_3, var_59_4 = PhysicsWorld.raycast(arg_59_0, arg_59_1, Vector3(0, 0, -1), arg_59_2, "closest", "types", "statics", "collision_filter", "filter_environment_overlap")

	return not raycast
end

ConflictUtils.find_visible_positions_in_sphere_around_player = function (arg_60_0, arg_60_1, arg_60_2, arg_60_3, arg_60_4, arg_60_5, arg_60_6, arg_60_7, arg_60_8, arg_60_9, arg_60_10, arg_60_11, arg_60_12, arg_60_13)
	-- function 60
	arg_60_11 = arg_60_11 or 0

	local pow = math.pow(arg_60_12, 2)
	local pow_2 = math.pow(arg_60_11, 2)
	local var_60_2 = POSITION_LOOKUP[arg_60_2]
	local num = arg_60_5 - arg_60_4
	local num_2 = arg_60_8 - arg_60_7
	local num_3 = arg_60_4 + num * math.random()
	local num_4 = arg_60_7 + num_2 * math.random()
	local num_5 = num / arg_60_6
	local num_6 = num_2 / arg_60_9
	local var_60_9 = num_3
	local num_7 = 0
	local num_8 = 0
	local var_60_12 = num_4
	local tbl = {}

	while arg_60_1 > #tbl do
		var_60_9 = var_60_9 + arg_60_6
		num_7 = num_7 + 1

		if num_5 <= num_7 then
			var_60_9 = num_3
			num_7 = 0
			var_60_12 = var_60_12 + arg_60_9
			num_8 = num_8 + 1

			if num_6 <= num_8 then
				break
			end
		end

		local num_9 = var_60_2 + Quaternion.rotate(Quaternion.from_yaw_pitch_roll(var_60_12, var_60_9, 0), Vector3.forward()) * arg_60_3
		local flag = false

		if not arg_60_10 then
			for i = 1, #arg_60_10 do
				local var_60_16 = arg_60_10[i]

				if pow_2 > Vector3.distance_squared(num_9, var_60_16) then
					flag = true

					break
				end
			end
		end

		if not flag then
			for j = 1, #tbl do
				local var_60_17 = tbl[j]

				if pow > Vector3.distance_squared(num_9, var_60_17) then
					flag = true

					break
				end
			end

			if (flag or not fn_11(arg_60_0, arg_60_2, num_9, var_60_2)) and not fn_12(arg_60_0, num_9, arg_60_13) then
				tbl[#tbl + 1] = num_9
			end
		end
	end

	return tbl
end
