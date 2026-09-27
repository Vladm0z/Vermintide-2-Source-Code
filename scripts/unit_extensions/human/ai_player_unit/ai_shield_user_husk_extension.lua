-- chunkname: @scripts/unit_extensions/human/ai_player_unit/ai_shield_user_husk_extension.lua

AIShieldUserHuskExtension = class(AIShieldUserHuskExtension)

AIShieldUserHuskExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._unit = arg_1_2
	self.is_blocking = arg_1_3.is_blocking
	self.is_dodging = arg_1_3.is_dodging
end

AIShieldUserHuskExtension.destroy = function (arg_2_0)
	-- function 2
	return
end

AIShieldUserHuskExtension.can_block_attack = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	assert(arg_3_1)

	local _unit = self._unit
	local go_id = Managers.state.unit_storage:go_id(_unit)
	local game = Managers.state.network:game()

	if not GameSession.game_object_field(game, go_id, "is_blocking") then
		return false
	end

	local world_position = Unit.world_position(arg_3_1, 0)
	local world_position_2 = Unit.world_position(_unit, 0)
	local normalize = Vector3.normalize(world_position_2 - world_position)
	local forward = Quaternion.forward(Unit.local_rotation(_unit, 0))
	local var_3_7
	local var_3_8

	if not arg_3_2 then
		local dot = Vector3.dot(forward, arg_3_3)

		var_3_8 = not (dot >= -0.75) or dot <= 1
	else
		local dot_2 = Vector3.dot(forward, normalize)

		var_3_8 = not (dot_2 >= 0.55) or dot_2 <= 1
	end

	return not var_3_8
end

AIShieldUserHuskExtension.get_is_blocking = function (self)
	-- function 4
	local _unit = self._unit
	local go_id = Managers.state.unit_storage:go_id(_unit)
	local game = Managers.state.network:game()

	return (GameSession.game_object_field(game, go_id, "is_blocking"))
end
