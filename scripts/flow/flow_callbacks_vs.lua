-- chunkname: @scripts/flow/flow_callbacks_vs.lua

local flow_return_table = Boot.flow_return_table
local alive = Unit.alive

function flow_query_ghost_mode_active(self)
	-- function 1
	local unit = self.unit

	if not alive(unit) then
		flow_return_table.active = false
		flow_return_table.not_active = false

		return
	end

	local has_extension = ScriptUnit.has_extension(unit, "ghost_mode_system")
	local flag = not has_extension and has_extension:is_in_ghost_mode()

	flow_return_table.active = not not flag
	flow_return_table.not_active = not flag

	return flow_return_table
end
