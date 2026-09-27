-- chunkname: @scripts/utils/deadlock_stack.lua

local DeadlockStack = DeadlockStack

DeadlockStack = DeadlockStack or {
	n = 0
}
DeadlockStack = DeadlockStack

DeadlockStack.pause = function ()
	-- function 1
	if DeadlockStack.n == 0 then
		Deadlock.pause()
	end

	DeadlockStack.n = DeadlockStack.n + 1
end

DeadlockStack.unpause = function ()
	-- function 2
	DeadlockStack.n = DeadlockStack.n - 1

	assert(DeadlockStack.n >= 0, "DeadlockStack underflow")

	if DeadlockStack.n == 0 then
		Deadlock.unpause()
	end
end
