-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_teleport_to_commander_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTTeleportToCommanderAction = class(BTTeleportToCommanderAction, BTNode)

BTTeleportToCommanderAction.init = function (arg_1_0, ...)
	BTTeleportToCommanderAction.super.init(arg_1_0, ...)
end

BTTeleportToCommanderAction.name = "BTTeleportToCommanderAction"

BTTeleportToCommanderAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0.commander_system = Managers.state.entity:system("ai_commander_system")
end

BTTeleportToCommanderAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	return
end

local var_0_0 = 5
local var_0_1 = math.pi / (2 * var_0_0)
local var_0_2 = 5

BTTeleportToCommanderAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_0.commander_system:get_commander_unit(arg_4_1)

	if not ALIVE[var_4_0] then
		return "done"
	end

	ScriptUnit.extension(var_4_0, "career_system"):get_passive_ability_by_name("bw_necromancer"):resummon_pet(arg_4_1)

	return "done"
end
