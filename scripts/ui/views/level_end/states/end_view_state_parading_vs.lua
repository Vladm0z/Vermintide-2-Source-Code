-- chunkname: @scripts/ui/views/level_end/states/end_view_state_parading_vs.lua

require("scripts/ui/views/world_hero_previewer")

EndViewStateParadingVS = class(EndViewStateParadingVS)
EndViewStateParadingVS.NAME = "EndViewStateParadingVS"

function EndViewStateParadingVS.on_enter(arg_1_0, arg_1_1)
	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.context

	arg_1_0._statistics_db = var_1_0.statistics_db
	arg_1_0._profile_synchronizer = var_1_0.profile_synchronizer

	ShowCursorStack.show("EndViewStateParadingVS")
	arg_1_0._parent:show_team()
end

function EndViewStateParadingVS.on_exit(arg_2_0)
	ShowCursorStack.hide("EndViewStateParadingVS")
end

function EndViewStateParadingVS.update(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0._done = arg_3_0._parent:parading_done(arg_3_1, arg_3_2)
end

function EndViewStateParadingVS.done(arg_4_0)
	return arg_4_0._done
end

function EndViewStateParadingVS.exit(arg_5_0)
	return
end

function EndViewStateParadingVS.exit_done(arg_6_0)
	return true
end
