-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_vortex_spawn_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTVortexSpawnAction = class(BTVortexSpawnAction, BTNode)

BTVortexSpawnAction.init = function (arg_1_0, ...)
	BTVortexSpawnAction.super.init(arg_1_0, ...)
end

BTVortexSpawnAction.name = "BTVortexSpawnAction"

BTVortexSpawnAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = POSITION_LOOKUP[arg_2_1]
	local var_2_1 = arg_2_2.nav_world

	if not GwNavQueries.triangle_from_position(var_2_1, var_2_0, 0.5, 0.5) then
		Managers.state.conflict:destroy_unit(arg_2_1, arg_2_2, "no_navmesh")
	end
end

BTVortexSpawnAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.spawn = false
end

BTVortexSpawnAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	return "done"
end
