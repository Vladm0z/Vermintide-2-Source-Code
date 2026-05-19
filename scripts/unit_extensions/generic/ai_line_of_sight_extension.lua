-- chunkname: @scripts/unit_extensions/generic/ai_line_of_sight_extension.lua

AILineOfSightExtension = class(AILineOfSightExtension)

function AILineOfSightExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.unit = arg_1_2
	arg_1_0._offsets = {}
end

function AILineOfSightExtension.extensions_ready(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._physics_world = World.physics_world(arg_2_1)
end

function AILineOfSightExtension.destroy(arg_3_0)
	return
end

function AILineOfSightExtension.reset(arg_4_0)
	return
end

local var_0_0 = 36
local var_0_1 = 0.1
local var_0_2 = 0.1

function AILineOfSightExtension.has_line_of_sight(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if arg_5_2.pause_line_of_sight_t then
		if Managers.time:time("game") < arg_5_2.pause_line_of_sight_t then
			return false, 1
		else
			arg_5_2.pause_line_of_sight_t = nil
		end
	end

	local var_5_0 = arg_5_0._offsets

	var_5_0[1] = Vector3(0, 0, 1.5)
	var_5_0[2] = Vector3(0.5, 0, 1.5)
	var_5_0[3] = Vector3(-0.5, 0, 1.5)

	local var_5_1 = Vector3(0, 0, 1.5)
	local var_5_2 = 3
	local var_5_3 = arg_5_0._physics_world
	local var_5_4 = Vector3.up()
	local var_5_5 = Unit.alive
	local var_5_6 = DamageUtils.is_character
	local var_5_7 = false
	local var_5_8 = Vector3.distance_squared
	local var_5_9 = 0
	local var_5_10 = false
	local var_5_11 = arg_5_4 or arg_5_2.breed.line_of_sight_distance_sq or var_0_0
	local var_5_12 = arg_5_3 or arg_5_2.attacking_target or arg_5_2.target_unit

	if var_5_5(var_5_12) and var_5_6(var_5_12) then
		local var_5_13 = POSITION_LOOKUP[arg_5_1]
		local var_5_14 = POSITION_LOOKUP[var_5_12]

		if var_5_14 and var_5_11 > var_5_8(var_5_13, var_5_14) then
			local var_5_15 = var_5_14 - var_5_13

			var_5_10 = false

			if math.abs(var_5_15.x) < var_0_1 and math.abs(var_5_15.y) < var_0_1 then
				local var_5_16 = var_5_0[1].z
				local var_5_17 = var_5_13 + var_5_1
				local var_5_18 = var_5_15 + Vector3(0, 0, var_5_16 - var_5_1.z)
				local var_5_19 = math.max(Vector3.length(var_5_18), 0.0001)
				local var_5_20 = var_5_18 / var_5_19

				if var_5_19 > var_0_2 then
					var_5_9 = var_5_9 + 1

					local var_5_21, var_5_22, var_5_23, var_5_24, var_5_25 = PhysicsWorld.raycast(var_5_3, var_5_17, var_5_20, var_5_19, "closest", "collision_filter", "filter_ai_line_of_sight_check")

					if not var_5_21 or Actor.unit(var_5_25) == var_5_12 then
						var_5_10 = true
					end
				else
					var_5_10 = true
				end
			else
				local var_5_26 = Vector3.normalize(Vector3.cross(var_5_15, var_5_4))

				for iter_5_0 = 1, var_5_2 do
					var_5_9 = var_5_9 + 1

					local var_5_27 = var_5_0[iter_5_0]
					local var_5_28 = var_5_13 + var_5_1
					local var_5_29 = var_5_15 + Vector3(var_5_26.x * var_5_27.x, var_5_26.y * var_5_27.x, var_5_27.z - var_5_1.z)
					local var_5_30 = Vector3.length(var_5_29)
					local var_5_31 = var_5_29 / var_5_30
					local var_5_32, var_5_33, var_5_34, var_5_35, var_5_36 = PhysicsWorld.raycast(var_5_3, var_5_28, var_5_31, var_5_30, "closest", "collision_filter", "filter_ai_line_of_sight_check")

					if not var_5_32 or Actor.unit(var_5_36) == var_5_12 then
						var_5_10 = true

						break
					end
				end
			end
		end
	end

	return var_5_10, var_5_9
end
