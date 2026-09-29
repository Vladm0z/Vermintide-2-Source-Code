-- chunkname: @scripts/game_state/state_context.lua

StateContext = not not StateContext

StateContext.set_context = function (c)
	-- function 1
	StateContext.context = c
end

StateContext.get = function (parent, child)
	-- function 2
	assert(StateContext.context[parent], "parent does not exist")

	return StateContext.context[parent][child]
end

StateContext.manager = function (name)
	-- function 3
	return StateContext.get("manager", name)
end

StateContext.event = function ()
	-- function 4
	return StateContext.get("manager", "event")
end
