-- chunkname: @scripts/managers/conflict_director/pack_spawner_utils.lua

PackSpawnerUtils = {}

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	local var_1_0 = Quaternion(Vector3.right(), arg_1_0)
	local var_1_1 = Quaternion(Vector3.forward(), arg_1_1)
	local var_1_2 = Quaternion(Vector3.up(), arg_1_2)
	local multiply = Quaternion.multiply(var_1_0, var_1_1)

	return (Quaternion.multiply(multiply, var_1_2))
end

local tbl = {}

PackSpawnerUtils.spawn_predefined_pack = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	local num = 0

	for k, v in pairs(arg_2_0) do
		if type(v) == "table" then
			for i, v_2 in ipairs(v) do
				local modify_spawn_position = PackSpawnerUtils.modify_spawn_position(Vector2(v_2.pos[1], v_2.pos[2]), arg_2_1, arg_2_2)

				if not modify_spawn_position then
					local breed = v_2.breed
					local rot = v_2.rot
					local var_2_4 = fn(math.degrees_to_radians(rot[1]), math.degrees_to_radians(rot[2]), math.degrees_to_radians(rot[3]))
					local var_2_5 = v_2.animation[math.random(1, #v_2.animation)]

					num = num + 1

					local inventory_template = v_2.inventory_template

					inventory_template = inventory_template or "default"
					tbl[num] = {
						breed,
						modify_spawn_position,
						var_2_4,
						var_2_5,
						inventory_template
					}
				else
					print("Pack outside mesh, try fallback...")

					local count = #v

					return PackSpawnerUtils.spawn_in_circle(BackupBreedPack, #v, arg_2_1)
				end
			end
		end
	end

	return num, tbl
end

PackSpawnerUtils.spawn_in_circle = function (self, arg_3_1, arg_3_2)
	-- function 3
	local num = 5
	local var_3_1 = arg_3_1
	local num_2 = 0
	local num_3 = 60
	local num_4 = 0
	local num_5 = 0

	for i = 3, 100, 2 do
		num_5 = num_5 + 45

		if num_5 == 90 then
			num_5 = 0
		end

		local var_3_6 = num_5
		local num_6 = i / 2
		local var_3_8 = Vector3(num_6, 0, 5)
		local num_7 = var_3_1 - num_2

		for j = 1, num do
			if num_2 == var_3_1 then
				print("Fallback pack spawning moved inside:", var_3_1, " units.")

				return var_3_1, tbl
			end

			local num_8 = math.random(-1, 1) / 10
			local num_9 = math.random(-num_6, num_6) / 10

			var_3_8 = var_3_8 + Vector3(num_8, num_9, 0)

			local rotate = Quaternion.rotate(Quaternion(Vector3.up(), math.degrees_to_radians(var_3_6)), var_3_8)
			local modify_spawn_position = PackSpawnerUtils.modify_spawn_position(rotate, arg_3_2)

			if not modify_spawn_position then
				local var_3_14 = self.members[1]
				local breed = var_3_14.breed
				local var_3_16 = var_3_14.animation[math.random(1, #var_3_14.animation)]
				local num_10 = arg_3_2 - modify_spawn_position

				num_10.z = 0

				local look = Quaternion.look(num_10)

				num_2 = num_2 + 1

				local inventory_template = var_3_14.inventory_template

				inventory_template = inventory_template or "default"
				tbl[num_2] = {
					breed,
					modify_spawn_position,
					look,
					var_3_16,
					inventory_template
				}
			end

			var_3_6 = var_3_6 + num_3

			if var_3_6 >= 360 then
				var_3_6 = 0
			end
		end
	end

	print("=== backup pack somehow failed!? at position", arg_3_2, " ===")

	return 0, tbl
end

PackSpawnerUtils.spawn_random_pack = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	local var_4_0 = arg_4_0
	local var_4_1 = var_4_0[1]
	local random = Math.random(var_4_0.amount[1], var_4_0.amount[2])

	for i = 1, random do
		local var_4_3 = Quaternion(Vector3.up(), math.degrees_to_radians(Math.random(1, 360)))
		local var_4_4 = var_4_0.spawn_range[2]
		local num = 0

		while num < 10 do
			local num_2 = (math.random() - 0.5) * var_4_4 * 2
			local num_3 = (math.random() - 0.5) * var_4_4 * 2
			local modify_spawn_position = PackSpawnerUtils.modify_spawn_position(Vector2(num_2, num_3), arg_4_1)

			if not PackSpawnerUtils.check_unit_overlap(modify_spawn_position, tbl, i) then
				local var_4_9 = var_4_1.animation[math.random(1, #var_4_1.animation)]

				tbl[i] = {
					breed,
					modify_spawn_position,
					var_4_3,
					var_4_9
				}

				break
			end

			num = num + 1
		end
	end

	return #tbl, tbl
end

PackSpawnerUtils.modify_spawn_position = function (self, arg_5_1)
	-- function 5
	local num = arg_5_1[1] + self[1]
	local num_2 = arg_5_1[2] + self[2]
	local var_5_2 = Vector3(num, num_2, arg_5_1[3])
	local get_tri_on_navmesh, var_5_4 = Managers.state.entity:system("ai_system"):get_tri_on_navmesh(var_5_2)

	if not get_tri_on_navmesh then
		var_5_2.z = var_5_4

		return var_5_2
	end

	return false
end

PackSpawnerUtils.check_unit_overlap = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	if not next(arg_6_1) then
		return false
	else
		for i = 1, arg_6_2 do
			local var_6_0 = arg_6_1[i]

			if Vector3.distance(arg_6_0, var_6_0[1]) < 1 then
				return true
			end
		end
	end

	return false
end

PackSpawnerUtils.random_predefined_pack_index = function ()
	-- function 7
	local num = 1
	local random = math.random(0, BreedPacks[num].spawn_weight)

	for i, v in ipairs(BreedPacks) do
		local random_2 = math.random(0, v.spawn_weight)

		if random < random_2 then
			num = i
			random = random_2
		end
	end

	return num
end
