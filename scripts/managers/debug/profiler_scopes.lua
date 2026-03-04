-- chunkname: @scripts/managers/debug/profiler_scopes.lua

local var_0_0 = 0
local var_0_1 = false
local var_0_2 = false
local var_0_3 = false
local var_0_4
local var_0_5 = {}
local var_0_6 = {}
local var_0_7 = overloaded or false

local function var_0_8(arg_1_0)
	local var_1_0 = ""

	for iter_1_0 = 0, 2 + arg_1_0 do
		var_1_0 = var_1_0 .. "   "
	end

	return var_1_0
end

local function var_0_9()
	local var_2_0 = debug.traceback()

	return (string.match(var_2_0, "\t.-\n\t.-\n\t(.-)\n"))
end

function profiler_scopes_trace()
	if var_0_7 then
		return
	end

	var_0_7 = true
end

function profiler_scopes_dump()
	profiler_scopes_trace()

	var_0_2 = true
	var_0_1 = true
end

function profiler_scopes_dump_light()
	profiler_scopes_trace()

	var_0_2 = true
end

if Development.parameter("validate_profiling_scopes") or Development.parameter("debug_profiling_scopes") then
	Application.warning("Enabling profile scope validation")
	profiler_scopes_dump_light()
end
