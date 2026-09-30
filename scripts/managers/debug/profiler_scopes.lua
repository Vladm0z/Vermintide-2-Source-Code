-- chunkname: @scripts/managers/debug/profiler_scopes.lua

local depth = 0
local dump = false
local dump_light = false
local has_started = false
local last_started
local started_scopes = {}
local started_scopes2 = {}
local overloaded = overloaded

local function indent(depth)
	-- function 1
	local ind = ""

	for ii = 0, 2 + depth do
		ind = ind .. "   "
	end

	return ind
end

local function get_line()
	-- function 2
	local tb = debug.traceback()
	local result = string.match(tb, "\t.-\n\t.-\n\t(.-)\n")

	return result
end

function profiler_scopes_trace()
	-- function 3
	if overloaded then
		return
	end

	overloaded = true
end

function profiler_scopes_dump()
	-- function 4
	profiler_scopes_trace()

	dump_light = true
	dump = true
end

function profiler_scopes_dump_light()
	-- function 5
	profiler_scopes_trace()

	dump_light = true
end

if Development.parameter("validate_profiling_scopes") or Development.parameter("debug_profiling_scopes") then
	Application.warning("Enabling profile scope validation")
	profiler_scopes_dump_light()
end
