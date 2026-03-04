-- chunkname: @scripts/flow/flow_callbacks_vs.lua

local var_0_0 = Boot.flow_return_table
local var_0_1 = Unit.alive

function flow_query_ghost_mode_active(arg_1_0)
	local var_1_0 = arg_1_0.unit

	if not var_0_1(var_1_0) then
		var_0_0.active = false
		var_0_0.not_active = false

		return
	end

	local var_1_1 = ScriptUnit.has_extension(var_1_0, "ghost_mode_system")
	local var_1_2 = var_1_1 and var_1_1:is_in_ghost_mode()

	var_0_0.active = not not var_1_2
	var_0_0.not_active = not var_1_2

	return var_0_0
end
