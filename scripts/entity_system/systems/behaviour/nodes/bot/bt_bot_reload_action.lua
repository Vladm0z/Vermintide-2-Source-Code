-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bot/bt_bot_reload_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTBotReloadAction = class(BTBotReloadAction, BTNode)

BTBotReloadAction.init = function (self, ...)
	-- function 1
	BTBotReloadAction.super.init(self, ...)
end

BTBotReloadAction.name = "BTBotReloadAction"

BTBotReloadAction.enter = function (self, unit, blackboard, t)
	-- function 2
	blackboard.reloading = true
end

BTBotReloadAction.leave = function (self, unit, blackboard, t, reason, destroy)
	-- function 3
	blackboard.reloading = false
end

BTBotReloadAction.run = function (self, unit, blackboard, t, dt)
	-- function 4
	local input_extension = blackboard.input_extension

	input_extension:weapon_reload()

	return "running", "evaluate"
end
