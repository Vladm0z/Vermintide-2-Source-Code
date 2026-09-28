-- chunkname: @scripts/ui/views/level_end/states/end_view_state_parading_vs.lua

require("scripts/ui/views/world_hero_previewer")

EndViewStateParadingVS = class(EndViewStateParadingVS)
EndViewStateParadingVS.NAME = "EndViewStateParadingVS"

EndViewStateParadingVS.on_enter = function (self, params)
	-- function 1
	self._parent = params.parent

	local context = params.context

	self._statistics_db = context.statistics_db
	self._profile_synchronizer = context.profile_synchronizer

	ShowCursorStack.show("EndViewStateParadingVS")
	self._parent:show_team()
end

EndViewStateParadingVS.on_exit = function (self)
	-- function 2
	ShowCursorStack.hide("EndViewStateParadingVS")
end

EndViewStateParadingVS.update = function (self, dt, t)
	-- function 3
	self._done = self._parent:parading_done(dt, t)
end

EndViewStateParadingVS.done = function (self)
	-- function 4
	return self._done
end

EndViewStateParadingVS.exit = function (self)
	-- function 5
	return
end

EndViewStateParadingVS.exit_done = function (self)
	-- function 6
	return true
end
