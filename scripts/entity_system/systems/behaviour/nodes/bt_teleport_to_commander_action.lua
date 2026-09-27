-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_teleport_to_commander_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTTeleportToCommanderAction = class(BTTeleportToCommanderAction, BTNode)

BTTeleportToCommanderAction.init = function (arg_1_0, ...)
	-- function 1
	BTTeleportToCommanderAction.super.init(arg_1_0, ...)
end

BTTeleportToCommanderAction.name = "BTTeleportToCommanderAction"

BTTeleportToCommanderAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	self.commander_system = Managers.state.entity:system("ai_commander_system")
end

BTTeleportToCommanderAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	return
end

local num = 5
local num_2 = math.pi / (2 * num)
local num_3 = 5

BTTeleportToCommanderAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local get_commander_unit = self.commander_system:get_commander_unit(arg_4_1)

	if not ALIVE[get_commander_unit] then
		return "done"
	end

	ScriptUnit.extension(get_commander_unit, "career_system"):get_passive_ability_by_name("bw_necromancer"):resummon_pet(arg_4_1)

	return "done"
end
