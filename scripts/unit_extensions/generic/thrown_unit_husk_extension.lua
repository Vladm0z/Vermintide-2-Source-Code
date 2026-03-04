-- chunkname: @scripts/unit_extensions/generic/thrown_unit_husk_extension.lua

ThrownUnitHuskExtension = class(ThrownUnitHuskExtension)

local var_0_0 = Unit.alive
local var_0_1 = POSITION_LOOKUP

ThrownUnitHuskExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.world = arg_1_1.world
	arg_1_0.game = Managers.state.network:game()
	arg_1_0.unit = arg_1_2
	arg_1_0.go_id = Managers.state.unit_storage:go_id(arg_1_2)
end

ThrownUnitHuskExtension.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2)
	Unit.flow_event(arg_2_2, "axe_thrown")
end

ThrownUnitHuskExtension.destroy = function (arg_3_0)
	return
end

ThrownUnitHuskExtension.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = math.min(arg_4_3 * 20, 1)
	local var_4_1 = POSITION_LOOKUP[arg_4_1]
	local var_4_2 = GameSession.game_object_field(arg_4_0.game, arg_4_0.go_id, "position")
	local var_4_3 = Vector3.lerp(var_4_1, var_4_2, var_4_0)

	Unit.set_local_position(arg_4_1, 0, var_4_3)

	local var_4_4 = Unit.local_rotation(arg_4_1, 0)
	local var_4_5 = GameSession.game_object_field(arg_4_0.game, arg_4_0.go_id, "rotation")
	local var_4_6 = Quaternion.lerp(var_4_4, var_4_5, var_4_0)

	Unit.set_local_rotation(arg_4_1, 0, var_4_6)
end
