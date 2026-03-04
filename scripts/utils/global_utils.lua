-- chunkname: @scripts/utils/global_utils.lua

local var_0_0 = BUILD == "release"
local var_0_1 = script_data

var_0_1.disable_debug_position_lookup = var_0_0 and true or nil

local var_0_2 = Unit.alive

PACKAGED_BUILD = var_0_1.packaged_build and true or false
RESOLUTION_LOOKUP = RESOLUTION_LOOKUP or {}
POSITION_LOOKUP = POSITION_LOOKUP or Script.new_map(256)
BLACKBOARDS = BLACKBOARDS or Script.new_map(256)
HEALTH_ALIVE = HEALTH_ALIVE or Script.new_map(1024)
ALIVE = POSITION_LOOKUP
FROZEN = FROZEN or {}

local var_0_3 = POSITION_LOOKUP
local var_0_4 = RESOLUTION_LOOKUP

BREED_DIE_LOOKUP = BREED_DIE_LOOKUP or {}

function CLEAR_POSITION_LOOKUP()
	table.clear(var_0_3)
end

local var_0_5 = Unit.world_position

function UPDATE_POSITION_LOOKUP()
	EngineOptimized.update_position_lookup(var_0_3)
end

function UPDATE_RESOLUTION_LOOKUP(arg_3_0, arg_3_1)
	local var_3_0 = Window.is_minimized()

	var_0_4.minimized = var_3_0

	local var_3_1, var_3_2 = Application.resolution()

	if var_3_0 then
		var_3_1 = var_0_4.res_w or 1920
		var_3_2 = var_0_4.res_h or 1080
	end

	local var_3_3 = var_3_1 ~= var_0_4.res_w or var_3_2 ~= var_0_4.res_h
	local var_3_4 = var_3_1 / 1920
	local var_3_5 = var_3_2 / 1080
	local var_3_6 = math.min(var_3_4, var_3_5)

	var_3_6 = Application.user_setting("hud_clamp_ui_scaling") and math.min(var_3_6, 1) or var_3_6

	local var_3_7 = false

	if arg_3_1 then
		var_3_6 = var_3_6 * arg_3_1
	end

	if var_0_4.scale ~= var_3_6 then
		var_3_7 = true
	end

	if var_3_3 or var_3_7 or arg_3_0 then
		var_0_4.res_w = var_3_1
		var_0_4.res_h = var_3_2
		var_0_4.scale = var_3_6
		var_0_4.inv_scale = 1 / var_3_6
	end

	var_0_4.modified = var_3_3 or arg_3_0
end

function CLEAR_ALL_PLAYER_LISTS()
	print("Clearing all global lookup lists")
	table.clear(BLACKBOARDS)
	assert(next(BLACKBOARDS) == nil)
	table.clear(ALIVE)
	assert(next(ALIVE) == nil)
	CLEAR_POSITION_LOOKUP()
	table.clear(FROZEN)
	table.clear(BREED_DIE_LOOKUP)
end
