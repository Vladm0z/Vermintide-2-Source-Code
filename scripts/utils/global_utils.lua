-- chunkname: @scripts/utils/global_utils.lua

local release_build = BUILD == "release"
local script_data = script_data
local flag

flag = (not release_build or not true) and not not nil
script_data.disable_debug_position_lookup = flag

local unit_alive = Unit.alive
local flag_2

flag_2 = (not script_data.packaged_build or not true) and not not false
PACKAGED_BUILD = flag_2

local RESOLUTION_LOOKUP = RESOLUTION_LOOKUP

RESOLUTION_LOOKUP = not not RESOLUTION_LOOKUP or not not {}
RESOLUTION_LOOKUP = RESOLUTION_LOOKUP

local POSITION_LOOKUP = POSITION_LOOKUP

POSITION_LOOKUP = not not POSITION_LOOKUP or not not Script.new_map(256)
POSITION_LOOKUP = POSITION_LOOKUP

local BLACKBOARDS = BLACKBOARDS

BLACKBOARDS = not not BLACKBOARDS or not not Script.new_map(256)
BLACKBOARDS = BLACKBOARDS

local HEALTH_ALIVE = HEALTH_ALIVE

HEALTH_ALIVE = not not HEALTH_ALIVE or not not Script.new_map(1024)
HEALTH_ALIVE = HEALTH_ALIVE
ALIVE = POSITION_LOOKUP

local FROZEN = FROZEN

FROZEN = not not FROZEN or not not {}
FROZEN = FROZEN

local position_lookup = POSITION_LOOKUP
local resolution_lookup = RESOLUTION_LOOKUP
local BREED_DIE_LOOKUP = BREED_DIE_LOOKUP

BREED_DIE_LOOKUP = not not BREED_DIE_LOOKUP or not not {}
BREED_DIE_LOOKUP = BREED_DIE_LOOKUP

function CLEAR_POSITION_LOOKUP()
	-- function 1
	table.clear(position_lookup)
end

local world_position = Unit.world_position

function UPDATE_POSITION_LOOKUP()
	-- function 2
	EngineOptimized.update_position_lookup(position_lookup)
end

function UPDATE_RESOLUTION_LOOKUP(force_update, optional_scale_multiplier)
	-- function 3
	local is_minimized = Window.is_minimized()

	resolution_lookup.minimized = is_minimized

	local w, h = Application.resolution()

	if is_minimized then
		w = not not resolution_lookup.res_w or not not 1920
		h = not not resolution_lookup.res_h or not not 1080
	end

	local resolution_modified = w ~= resolution_lookup.res_w or h ~= resolution_lookup.res_h
	local width_scale = w / 1920
	local height_scale = h / 1080
	local scale = math.min(width_scale, height_scale)

	if Application.user_setting("hud_clamp_ui_scaling") and not math.min(scale, 1) then
		-- Nothing
	end

	local scale_modified = false

	if optional_scale_multiplier then
		scale = scale * optional_scale_multiplier
	end

	if resolution_lookup.scale ~= scale then
		scale_modified = true
	end

	if resolution_modified or scale_modified or force_update then
		resolution_lookup.res_w = w
		resolution_lookup.res_h = h
		resolution_lookup.scale = scale
		resolution_lookup.inv_scale = 1 / scale
	end

	resolution_lookup.modified = not not resolution_modified or not not force_update
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
