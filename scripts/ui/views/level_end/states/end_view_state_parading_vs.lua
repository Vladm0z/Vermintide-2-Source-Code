-- chunkname: @scripts/ui/views/level_end/states/end_view_state_parading_vs.lua

require("scripts/ui/views/world_hero_previewer")

EndViewStateParadingVS = class(EndViewStateParadingVS)
EndViewStateParadingVS.NAME = "EndViewStateParadingVS"

EndViewStateParadingVS.on_enter = function (self, arg_1_1)
	-- function 1
	self._parent = arg_1_1.parent

	local context = arg_1_1.context

	self._statistics_db = context.statistics_db
	self._profile_synchronizer = context.profile_synchronizer

	ShowCursorStack.show("EndViewStateParadingVS")
	self._parent:show_team()
end

EndViewStateParadingVS.on_exit = function (arg_2_0)
	-- function 2
	ShowCursorStack.hide("EndViewStateParadingVS")
end

EndViewStateParadingVS.update = function (self, arg_3_1, arg_3_2)
	-- function 3
	self._done = self._parent:parading_done(arg_3_1, arg_3_2)
end

EndViewStateParadingVS.done = function (self)
	-- function 4
	return self._done
end

EndViewStateParadingVS.exit = function (arg_5_0)
	-- function 5
	return
end

EndViewStateParadingVS.exit_done = function (arg_6_0)
	-- function 6
	return true
end
