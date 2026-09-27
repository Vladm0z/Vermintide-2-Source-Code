-- chunkname: @scripts/utils/global_utils.lua

local flag = BUILD == "release"
local script_data = script_data
local flag_2

flag_2 = not flag and true and nil
script_data.disable_debug_position_lookup = flag_2

local alive = Unit.alive
local flag_3

flag_3 = not script_data.packaged_build and true and false
PACKAGED_BUILD = flag_3

local RESOLUTION_LOOKUP = RESOLUTION_LOOKUP

RESOLUTION_LOOKUP = RESOLUTION_LOOKUP or {}
RESOLUTION_LOOKUP = RESOLUTION_LOOKUP

local POSITION_LOOKUP = POSITION_LOOKUP

POSITION_LOOKUP = POSITION_LOOKUP or Script.new_map(256)
POSITION_LOOKUP = POSITION_LOOKUP

local BLACKBOARDS = BLACKBOARDS

BLACKBOARDS = BLACKBOARDS or Script.new_map(256)
BLACKBOARDS = BLACKBOARDS

local HEALTH_ALIVE = HEALTH_ALIVE

HEALTH_ALIVE = HEALTH_ALIVE or Script.new_map(1024)
HEALTH_ALIVE = HEALTH_ALIVE
ALIVE = POSITION_LOOKUP

local FROZEN = FROZEN

FROZEN = FROZEN or {}
FROZEN = FROZEN

local POSITION_LOOKUP_2 = POSITION_LOOKUP
local RESOLUTION_LOOKUP_2 = RESOLUTION_LOOKUP
local BREED_DIE_LOOKUP = BREED_DIE_LOOKUP

BREED_DIE_LOOKUP = BREED_DIE_LOOKUP or {}
BREED_DIE_LOOKUP = BREED_DIE_LOOKUP

function CLEAR_POSITION_LOOKUP()
	-- function 1
	table.clear(POSITION_LOOKUP_2)
end

local world_position = Unit.world_position

function UPDATE_POSITION_LOOKUP()
	-- function 2
	EngineOptimized.update_position_lookup(POSITION_LOOKUP_2)
end

function UPDATE_RESOLUTION_LOOKUP(arg_3_0, arg_3_1)
	-- function 3
	local is_minimized = Window.is_minimized()

	RESOLUTION_LOOKUP_2.minimized = is_minimized

	local resolution, var_3_2 = Application.resolution()

	if not is_minimized then
		resolution = RESOLUTION_LOOKUP_2.res_w or 1920
		var_3_2 = RESOLUTION_LOOKUP_2.res_h or 1080
	end

	local flag = resolution ~= RESOLUTION_LOOKUP_2.res_w or var_3_2 ~= RESOLUTION_LOOKUP_2.res_h
	local num = resolution / 1920
	local num_2 = var_3_2 / 1080
	local min = math.min(num, num_2)

	min = not Application.user_setting("hud_clamp_ui_scaling") and math.min(min, 1) and min

	local flag_2 = false

	if not arg_3_1 then
		min = min * arg_3_1
	end

	if RESOLUTION_LOOKUP_2.scale ~= min then
		flag_2 = true
	end

	if flag or flag_2 or not arg_3_0 then
		RESOLUTION_LOOKUP_2.res_w = resolution
		RESOLUTION_LOOKUP_2.res_h = var_3_2
		RESOLUTION_LOOKUP_2.scale = min
		RESOLUTION_LOOKUP_2.inv_scale = 1 / min
	end

	RESOLUTION_LOOKUP_2.modified = flag or arg_3_0
end

function CLEAR_ALL_PLAYER_LISTS()
	-- function 4
	print("Clearing all global lookup lists")
	table.clear(BLACKBOARDS)
	assert(next(BLACKBOARDS) == nil)
	table.clear(ALIVE)
	assert(next(ALIVE) == nil)
	CLEAR_POSITION_LOOKUP()
	table.clear(FROZEN)
	table.clear(BREED_DIE_LOOKUP)
end
