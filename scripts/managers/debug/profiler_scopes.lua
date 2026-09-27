-- chunkname: @scripts/managers/debug/profiler_scopes.lua

local num = 0
local flag = false
local flag_2 = false
local flag_3 = false
local var_0_4
local tbl = {}
local tbl_2 = {}
local overloaded = overloaded

overloaded = overloaded or false

local function fn(arg_1_0)
	-- function 1
	local str = ""

	for i = 0, 2 + arg_1_0 do
		str = str .. "   "
	end

	return str
end

local function fn_2()
	-- function 2
	local traceback = debug.traceback()

	return (string.match(traceback, "\t.-\n\t.-\n\t(.-)\n"))
end

function profiler_scopes_trace()
	-- function 3
	if not overloaded then
		return
	end

	overloaded = true
end

function profiler_scopes_dump()
	-- function 4
	profiler_scopes_trace()

	flag_2 = true
	flag = true
end

function profiler_scopes_dump_light()
	-- function 5
	profiler_scopes_trace()

	flag_2 = true
end

if Development.parameter("validate_profiling_scopes") or not Development.parameter("debug_profiling_scopes") then
	Application.warning("Enabling profile scope validation")
	profiler_scopes_dump_light()
end
