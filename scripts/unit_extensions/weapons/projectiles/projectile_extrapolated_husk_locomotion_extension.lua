-- chunkname: @scripts/unit_extensions/weapons/projectiles/projectile_extrapolated_husk_locomotion_extension.lua

ProjectileExtrapolatedHuskLocomotionExtension = class(ProjectileExtrapolatedHuskLocomotionExtension)

ProjectileExtrapolatedHuskLocomotionExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._spawn_time = Managers.time:time("game")
	self._last_lerp_position = Vector3Box(Unit.local_position(arg_1_2, 0))
	self._last_lerp_position_offset = Vector3Box()
	self._accumulated_movement = Vector3Box()
	self._pos_lerp_time = 0
end

local num = 0.01
local num_2 = num * num
local num_3 = 0.1

ProjectileExtrapolatedHuskLocomotionExtension.update = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	if not self._stopped then
		return
	end

	local game = Managers.state.network:game()
	local go_id = Managers.state.unit_storage:go_id(arg_2_1)

	if not game and not go_id then
		local game_object_field = GameSession.game_object_field(game, go_id, "position")
		local game_object_field_2 = GameSession.game_object_field(game, go_id, "rotation")
		local game_object_field_3 = GameSession.game_object_field(game, go_id, "velocity")

		if NetworkConstants.VELOCITY_EPSILON * NetworkConstants.VELOCITY_EPSILON > Vector3.length_squared(game_object_field_3) then
			game_object_field_3 = Vector3(0, 0, 0)
		end

		local unbox = self._last_lerp_position:unbox()
		local unbox_2 = self._last_lerp_position_offset:unbox()
		local unbox_3 = self._accumulated_movement:unbox()

		self._pos_lerp_time = self._pos_lerp_time + arg_2_3

		local num = self._pos_lerp_time / num_3
		local num_4 = unbox_3 + game_object_field_3 * arg_2_3
		local lerp = Vector3.lerp(unbox_2, Vector3.zero(), math.min(num, 1))
		local num_5 = unbox + num_4 + lerp

		if Vector3.length_squared(game_object_field - unbox) > num_2 then
			self._pos_lerp_time = 0

			self._last_lerp_position:store(game_object_field)
			self._last_lerp_position_offset:store(num_5 - game_object_field)
			self._accumulated_movement:store(Vector3.zero())
		else
			self._accumulated_movement:store(num_4)
		end

		Unit.set_local_position(arg_2_1, 0, num_5)

		local local_rotation = Unit.local_rotation(arg_2_1, 0)
		local min = math.min(arg_2_3 * 15, 1)

		Unit.set_local_rotation(arg_2_1, 0, Quaternion.lerp(local_rotation, game_object_field_2, min))
	end
end

ProjectileExtrapolatedHuskLocomotionExtension.destroy = function (arg_3_0)
	-- function 3
	return
end

ProjectileExtrapolatedHuskLocomotionExtension.stop = function (self)
	-- function 4
	self._stopped = true
end
