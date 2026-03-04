-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bot/bt_bot_reload_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTBotReloadAction = class(BTBotReloadAction, BTNode)

BTBotReloadAction.init = function (arg_1_0, ...)
	BTBotReloadAction.super.init(arg_1_0, ...)
end

BTBotReloadAction.name = "BTBotReloadAction"

BTBotReloadAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.reloading = true
end

BTBotReloadAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.reloading = false
end

BTBotReloadAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	arg_4_2.input_extension:weapon_reload()

	return "running", "evaluate"
end
