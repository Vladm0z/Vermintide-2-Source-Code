-- chunkname: @scripts/unit_extensions/generic/ai_line_of_sight_extension.lua

AILineOfSightExtension = class(AILineOfSightExtension)

AILineOfSightExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.unit = arg_1_2
	self._offsets = {}
end

AILineOfSightExtension.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	self._physics_world = World.physics_world(arg_2_1)
end

AILineOfSightExtension.destroy = function (arg_3_0)
	-- function 3
	return
end

AILineOfSightExtension.reset = function (arg_4_0)
	-- function 4
	return
end

local num = 36
local num_2 = 0.1
local num_3 = 0.1

AILineOfSightExtension.has_line_of_sight = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	if not arg_5_2.pause_line_of_sight_t then
		if Managers.time:time("game") < arg_5_2.pause_line_of_sight_t then
			return false, 1
		else
			arg_5_2.pause_line_of_sight_t = nil
		end
	end

	local _offsets = self._offsets

	_offsets[1] = Vector3(0, 0, 1.5)
	_offsets[2] = Vector3(0.5, 0, 1.5)
	_offsets[3] = Vector3(-0.5, 0, 1.5)

	local var_5_1 = Vector3(0, 0, 1.5)
	local num_4 = 3
	local _physics_world = self._physics_world
	local up = Vector3.up()
	local alive = Unit.alive
	local is_character = DamageUtils.is_character
	local flag = false
	local distance_squared = Vector3.distance_squared
	local num_5 = 0
	local flag_2 = false

	if not arg_5_4 then
		-- Nothing
	end

	::label_5_0::

	local line_of_sight_distance_sq = arg_5_2.breed.line_of_sight_distance_sq

	line_of_sight_distance_sq = line_of_sight_distance_sq or num

	::label_5_1::

	if not arg_5_3 then
		-- Nothing
	end

	::label_5_2::

	local attacking_target = arg_5_2.attacking_target

	attacking_target = attacking_target or arg_5_2.target_unit

	::label_5_3::

	if not alive(attacking_target) and not is_character(attacking_target) then
		local var_5_13 = POSITION_LOOKUP[arg_5_1]
		local var_5_14 = POSITION_LOOKUP[attacking_target]

		if not (not var_5_14 and not (line_of_sight_distance_sq > distance_squared(var_5_13, var_5_14))) then
			local num_6 = var_5_14 - var_5_13

			flag_2 = false

			if not (not (math.abs(num_6.x) < num_2) or not (math.abs(num_6.y) < num_2)) then
				local z = _offsets[1].z
				local num_7 = var_5_13 + var_5_1
				local num_8 = num_6 + Vector3(0, 0, z - var_5_1.z)
				local max = math.max(Vector3.length(num_8), 0.0001)
				local num_9 = num_8 / max

				if max > num_3 then
					num_5 = num_5 + 1

					local raycast, var_5_22, var_5_23, var_5_24, var_5_25 = PhysicsWorld.raycast(_physics_world, num_7, num_9, max, "closest", "collision_filter", "filter_ai_line_of_sight_check")

					if not (not raycast and Actor.unit(var_5_25) ~= attacking_target) then
						flag_2 = true
					end
				else
					flag_2 = true
				end
			else
				local normalize = Vector3.normalize(Vector3.cross(num_6, up))

				for i = 1, num_4 do
					num_5 = num_5 + 1

					local var_5_27 = _offsets[i]
					local num_10 = var_5_13 + var_5_1
					local num_11 = num_6 + Vector3(normalize.x * var_5_27.x, normalize.y * var_5_27.x, var_5_27.z - var_5_1.z)
					local length = Vector3.length(num_11)
					local num_12 = num_11 / length
					local raycast_2, var_5_33, var_5_34, var_5_35, var_5_36 = PhysicsWorld.raycast(_physics_world, num_10, num_12, length, "closest", "collision_filter", "filter_ai_line_of_sight_check")

					if not (not raycast_2 and Actor.unit(var_5_36) ~= attacking_target) then
						flag_2 = true

						break
					end
				end
			end
		end
	end

	return flag_2, num_5
end
