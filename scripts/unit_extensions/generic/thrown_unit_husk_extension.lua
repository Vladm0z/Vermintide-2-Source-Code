-- chunkname: @scripts/unit_extensions/generic/thrown_unit_husk_extension.lua

ThrownUnitHuskExtension = class(ThrownUnitHuskExtension)

local alive = Unit.alive
local POSITION_LOOKUP = POSITION_LOOKUP

ThrownUnitHuskExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.world = arg_1_1.world
	self.game = Managers.state.network:game()
	self.unit = arg_1_2
	self.go_id = Managers.state.unit_storage:go_id(arg_1_2)
end

ThrownUnitHuskExtension.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	Unit.flow_event(arg_2_2, "axe_thrown")
end

ThrownUnitHuskExtension.destroy = function (arg_3_0)
	-- function 3
	return
end

ThrownUnitHuskExtension.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local min = math.min(arg_4_3 * 20, 1)
	local var_4_1 = POSITION_LOOKUP[arg_4_1]
	local game_object_field = GameSession.game_object_field(self.game, self.go_id, "position")
	local lerp = Vector3.lerp(var_4_1, game_object_field, min)

	Unit.set_local_position(arg_4_1, 0, lerp)

	local local_rotation = Unit.local_rotation(arg_4_1, 0)
	local game_object_field_2 = GameSession.game_object_field(self.game, self.go_id, "rotation")
	local lerp_2 = Quaternion.lerp(local_rotation, game_object_field_2, min)

	Unit.set_local_rotation(arg_4_1, 0, lerp_2)
end
