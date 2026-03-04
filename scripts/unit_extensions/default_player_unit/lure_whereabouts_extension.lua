-- chunkname: @scripts/unit_extensions/default_player_unit/lure_whereabouts_extension.lua

require("scripts/unit_extensions/generic/generic_state_machine")

LureWhereaboutsExtension = class(LureWhereaboutsExtension)

LureWhereaboutsExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._unit = arg_1_2

	local var_1_0 = Managers.state.entity:system("ai_system"):nav_world()

	arg_1_0._closest_positions = {}

	local var_1_1 = Unit.world_position(arg_1_2, 0)
	local var_1_2 = 1
	local var_1_3 = 5
	local var_1_4, var_1_5 = GwNavQueries.triangle_from_position(var_1_0, var_1_1, var_1_2, var_1_3)

	if var_1_4 then
		arg_1_0._closest_positions[1] = Vector3Box(Vector3(var_1_1.x, var_1_1.y, var_1_5))
		arg_1_0._on_navmesh = true
	else
		arg_1_0._on_navmesh = false

		local var_1_6 = 5
		local var_1_7 = 0.1
		local var_1_8 = GwNavQueries.inside_position_from_outside_position(var_1_0, var_1_1, var_1_2, var_1_3, var_1_6, var_1_7)

		if var_1_8 then
			arg_1_0._closest_positions[1] = Vector3Box(var_1_8)
		end
	end
end

LureWhereaboutsExtension.destroy = function (arg_2_0)
	return
end

LureWhereaboutsExtension.closest_positions_when_outside_navmesh = function (arg_3_0)
	return arg_3_0._closest_positions, arg_3_0._on_navmesh
end
