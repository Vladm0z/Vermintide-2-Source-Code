-- chunkname: @scripts/unit_extensions/weapons/projectiles/projectile_extrapolated_husk_locomotion_extension.lua

ProjectileExtrapolatedHuskLocomotionExtension = class(ProjectileExtrapolatedHuskLocomotionExtension)

function ProjectileExtrapolatedHuskLocomotionExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._spawn_time = Managers.time:time("game")
	arg_1_0._last_lerp_position = Vector3Box(Unit.local_position(arg_1_2, 0))
	arg_1_0._last_lerp_position_offset = Vector3Box()
	arg_1_0._accumulated_movement = Vector3Box()
	arg_1_0._pos_lerp_time = 0
end

local var_0_0 = 0.01
local var_0_1 = var_0_0 * var_0_0
local var_0_2 = 0.1

function ProjectileExtrapolatedHuskLocomotionExtension.update(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	if arg_2_0._stopped then
		return
	end

	local var_2_0 = Managers.state.network:game()
	local var_2_1 = Managers.state.unit_storage:go_id(arg_2_1)

	if var_2_0 and var_2_1 then
		local var_2_2 = GameSession.game_object_field(var_2_0, var_2_1, "position")
		local var_2_3 = GameSession.game_object_field(var_2_0, var_2_1, "rotation")
		local var_2_4 = GameSession.game_object_field(var_2_0, var_2_1, "velocity")

		if NetworkConstants.VELOCITY_EPSILON * NetworkConstants.VELOCITY_EPSILON > Vector3.length_squared(var_2_4) then
			var_2_4 = Vector3(0, 0, 0)
		end

		local var_2_5 = arg_2_0._last_lerp_position:unbox()
		local var_2_6 = arg_2_0._last_lerp_position_offset:unbox()
		local var_2_7 = arg_2_0._accumulated_movement:unbox()

		arg_2_0._pos_lerp_time = arg_2_0._pos_lerp_time + arg_2_3

		local var_2_8 = arg_2_0._pos_lerp_time / var_0_2
		local var_2_9 = var_2_7 + var_2_4 * arg_2_3
		local var_2_10 = Vector3.lerp(var_2_6, Vector3.zero(), math.min(var_2_8, 1))
		local var_2_11 = var_2_5 + var_2_9 + var_2_10

		if Vector3.length_squared(var_2_2 - var_2_5) > var_0_1 then
			arg_2_0._pos_lerp_time = 0

			arg_2_0._last_lerp_position:store(var_2_2)
			arg_2_0._last_lerp_position_offset:store(var_2_11 - var_2_2)
			arg_2_0._accumulated_movement:store(Vector3.zero())
		else
			arg_2_0._accumulated_movement:store(var_2_9)
		end

		Unit.set_local_position(arg_2_1, 0, var_2_11)

		local var_2_12 = Unit.local_rotation(arg_2_1, 0)
		local var_2_13 = math.min(arg_2_3 * 15, 1)

		Unit.set_local_rotation(arg_2_1, 0, Quaternion.lerp(var_2_12, var_2_3, var_2_13))
	end
end

function ProjectileExtrapolatedHuskLocomotionExtension.destroy(arg_3_0)
	return
end

function ProjectileExtrapolatedHuskLocomotionExtension.stop(arg_4_0)
	arg_4_0._stopped = true
end
