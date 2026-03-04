-- chunkname: @scripts/managers/conflict_director/pack_spawner_utils.lua

PackSpawnerUtils = {}

local function var_0_0(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = Quaternion(Vector3.right(), arg_1_0)
	local var_1_1 = Quaternion(Vector3.forward(), arg_1_1)
	local var_1_2 = Quaternion(Vector3.up(), arg_1_2)
	local var_1_3 = Quaternion.multiply(var_1_0, var_1_1)

	return (Quaternion.multiply(var_1_3, var_1_2))
end

local var_0_1 = {}

PackSpawnerUtils.spawn_predefined_pack = function (arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = 0

	for iter_2_0, iter_2_1 in pairs(arg_2_0) do
		if type(iter_2_1) == "table" then
			for iter_2_2, iter_2_3 in ipairs(iter_2_1) do
				local var_2_1 = PackSpawnerUtils.modify_spawn_position(Vector2(iter_2_3.pos[1], iter_2_3.pos[2]), arg_2_1, arg_2_2)

				if var_2_1 then
					local var_2_2 = iter_2_3.breed
					local var_2_3 = iter_2_3.rot
					local var_2_4 = var_0_0(math.degrees_to_radians(var_2_3[1]), math.degrees_to_radians(var_2_3[2]), math.degrees_to_radians(var_2_3[3]))
					local var_2_5 = iter_2_3.animation[math.random(1, #iter_2_3.animation)]

					var_2_0 = var_2_0 + 1

					local var_2_6 = iter_2_3.inventory_template or "default"

					var_0_1[var_2_0] = {
						var_2_2,
						var_2_1,
						var_2_4,
						var_2_5,
						var_2_6
					}
				else
					print("Pack outside mesh, try fallback...")

					local var_2_7 = #iter_2_1

					return PackSpawnerUtils.spawn_in_circle(BackupBreedPack, #iter_2_1, arg_2_1)
				end
			end
		end
	end

	return var_2_0, var_0_1
end

PackSpawnerUtils.spawn_in_circle = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = 5
	local var_3_1 = arg_3_1
	local var_3_2 = 0
	local var_3_3 = 60
	local var_3_4 = 0
	local var_3_5 = 0

	for iter_3_0 = 3, 100, 2 do
		var_3_5 = var_3_5 + 45

		if var_3_5 == 90 then
			var_3_5 = 0
		end

		local var_3_6 = var_3_5
		local var_3_7 = iter_3_0 / 2
		local var_3_8 = Vector3(var_3_7, 0, 5)
		local var_3_9 = var_3_1 - var_3_2

		for iter_3_1 = 1, var_3_0 do
			if var_3_2 == var_3_1 then
				print("Fallback pack spawning moved inside:", var_3_1, " units.")

				return var_3_1, var_0_1
			end

			local var_3_10 = math.random(-1, 1) / 10
			local var_3_11 = math.random(-var_3_7, var_3_7) / 10

			var_3_8 = var_3_8 + Vector3(var_3_10, var_3_11, 0)

			local var_3_12 = Quaternion.rotate(Quaternion(Vector3.up(), math.degrees_to_radians(var_3_6)), var_3_8)
			local var_3_13 = PackSpawnerUtils.modify_spawn_position(var_3_12, arg_3_2)

			if var_3_13 then
				local var_3_14 = arg_3_0.members[1]
				local var_3_15 = var_3_14.breed
				local var_3_16 = var_3_14.animation[math.random(1, #var_3_14.animation)]
				local var_3_17 = arg_3_2 - var_3_13

				var_3_17.z = 0

				local var_3_18 = Quaternion.look(var_3_17)

				var_3_2 = var_3_2 + 1

				local var_3_19 = var_3_14.inventory_template or "default"

				var_0_1[var_3_2] = {
					var_3_15,
					var_3_13,
					var_3_18,
					var_3_16,
					var_3_19
				}
			end

			var_3_6 = var_3_6 + var_3_3

			if var_3_6 >= 360 then
				var_3_6 = 0
			end
		end
	end

	print("=== backup pack somehow failed!? at position", arg_3_2, " ===")

	return 0, var_0_1
end

PackSpawnerUtils.spawn_random_pack = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0
	local var_4_1 = var_4_0[1]
	local var_4_2 = Math.random(var_4_0.amount[1], var_4_0.amount[2])

	for iter_4_0 = 1, var_4_2 do
		local var_4_3 = Quaternion(Vector3.up(), math.degrees_to_radians(Math.random(1, 360)))
		local var_4_4 = var_4_0.spawn_range[2]
		local var_4_5 = 0

		while var_4_5 < 10 do
			local var_4_6 = (math.random() - 0.5) * var_4_4 * 2
			local var_4_7 = (math.random() - 0.5) * var_4_4 * 2
			local var_4_8 = PackSpawnerUtils.modify_spawn_position(Vector2(var_4_6, var_4_7), arg_4_1)

			if not PackSpawnerUtils.check_unit_overlap(var_4_8, var_0_1, iter_4_0) then
				local var_4_9 = var_4_1.animation[math.random(1, #var_4_1.animation)]

				var_0_1[iter_4_0] = {
					breed,
					var_4_8,
					var_4_3,
					var_4_9
				}

				break
			end

			var_4_5 = var_4_5 + 1
		end
	end

	return #var_0_1, var_0_1
end

PackSpawnerUtils.modify_spawn_position = function (arg_5_0, arg_5_1)
	local var_5_0 = arg_5_1[1] + arg_5_0[1]
	local var_5_1 = arg_5_1[2] + arg_5_0[2]
	local var_5_2 = Vector3(var_5_0, var_5_1, arg_5_1[3])
	local var_5_3, var_5_4 = Managers.state.entity:system("ai_system"):get_tri_on_navmesh(var_5_2)

	if var_5_3 then
		var_5_2.z = var_5_4

		return var_5_2
	end

	return false
end

PackSpawnerUtils.check_unit_overlap = function (arg_6_0, arg_6_1, arg_6_2)
	if not next(arg_6_1) then
		return false
	else
		for iter_6_0 = 1, arg_6_2 do
			local var_6_0 = arg_6_1[iter_6_0]

			if Vector3.distance(arg_6_0, var_6_0[1]) < 1 then
				return true
			end
		end
	end

	return false
end

PackSpawnerUtils.random_predefined_pack_index = function ()
	local var_7_0 = 1
	local var_7_1 = math.random(0, BreedPacks[var_7_0].spawn_weight)

	for iter_7_0, iter_7_1 in ipairs(BreedPacks) do
		local var_7_2 = math.random(0, iter_7_1.spawn_weight)

		if var_7_1 < var_7_2 then
			var_7_0 = iter_7_0
			var_7_1 = var_7_2
		end
	end

	return var_7_0
end
