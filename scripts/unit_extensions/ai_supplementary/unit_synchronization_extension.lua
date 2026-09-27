-- chunkname: @scripts/unit_extensions/ai_supplementary/unit_synchronization_extension.lua

UnitSynchronizationExtension = class(UnitSynchronizationExtension)

local POSITION_LOOKUP = POSITION_LOOKUP

UnitSynchronizationExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.world = arg_1_1.world
	self.unit = arg_1_2
	self.is_server = Managers.player.is_server
end

UnitSynchronizationExtension.update = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	if not self.is_server then
		self:_server_sync_position_rotation(arg_2_3, arg_2_5)
	else
		self:_client_validate_position_rotation(arg_2_3, arg_2_5)
	end
end

UnitSynchronizationExtension._server_sync_position_rotation = function (self, arg_3_1, arg_3_2)
	-- function 3
	local game = Managers.state.network:game()

	if not game then
		local set_game_object_field = GameSession.set_game_object_field
		local unit_storage = Managers.state.unit_storage
		local local_rotation = Unit.local_rotation
		local min = NetworkConstants.position.min
		local max = NetworkConstants.position.max
		local unit = self.unit
		local go_id = unit_storage:go_id(unit)
		local clamp = Vector3.clamp(POSITION_LOOKUP[unit], min, max)
		local var_3_9 = local_rotation(unit, 0)

		set_game_object_field(game, go_id, "position", clamp)
		set_game_object_field(game, go_id, "rotation", var_3_9)
	end
end

local num = 0.0001

UnitSynchronizationExtension._client_validate_position_rotation = function (self, arg_4_1, arg_4_2)
	-- function 4
	local game = Managers.state.network:game()

	if not game then
		local game_object_field = GameSession.game_object_field
		local distance_squared = Vector3.distance_squared
		local local_position = Unit.local_position
		local unit_storage = Managers.state.unit_storage
		local unit = self.unit
		local go_id = unit_storage:go_id(unit)
		local var_4_7 = game_object_field(game, go_id, "position")
		local var_4_8 = POSITION_LOOKUP[unit]

		var_4_8 = var_4_8 or local_position(unit, 0)

		if distance_squared(var_4_7, var_4_8) > num then
			local var_4_9 = game_object_field(game, go_id, "rotation")

			Unit.set_local_position(unit, 0, var_4_7)
			Unit.set_local_rotation(unit, 0, var_4_9)
		end
	end
end
