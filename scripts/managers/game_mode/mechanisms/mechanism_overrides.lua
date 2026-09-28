-- chunkname: @scripts/managers/game_mode/mechanisms/mechanism_overrides.lua

local MechanismOverrides = MechanismOverrides

MechanismOverrides = not not MechanismOverrides or not not {}
MechanismOverrides = MechanismOverrides

local MechanismOverrides_2 = MechanismOverrides
local NIL = MechanismOverrides.NIL

NIL = not not NIL or not not {}
MechanismOverrides_2.NIL = NIL

local MechanismOverrides_3 = MechanismOverrides
local CACHE_2 = MechanismOverrides.CACHE

CACHE_2 = not not CACHE_2 or not not {}
MechanismOverrides_3.CACHE = CACHE_2

local MechanismOverrides_4 = MechanismOverrides
local TEMP_CACHE_2 = MechanismOverrides.TEMP_CACHE

TEMP_CACHE_2 = not not TEMP_CACHE_2 or not not {}
MechanismOverrides_4.TEMP_CACHE = TEMP_CACHE_2

local MechanismOverrides_5 = MechanismOverrides
local CACHED_MECHANISM_2 = MechanismOverrides.CACHED_MECHANISM

CACHED_MECHANISM_2 = not not CACHED_MECHANISM_2 or not not {}
MechanismOverrides_5.CACHED_MECHANISM = CACHED_MECHANISM_2

local CACHE = MechanismOverrides.CACHE
local CACHED_MECHANISM = MechanismOverrides.CACHED_MECHANISM
local TEMP_CACHE = MechanismOverrides.TEMP_CACHE

MechanismOverrides.get = function (t, optional_mechanism_name)
	-- function 1
	if t == nil then
		return nil
	end

	local mechanism_name = not not optional_mechanism_name or not not Managers.mechanism:current_mechanism_name()

	return MechanismOverrides.recursive_override(t, mechanism_name, 1)
end

MechanismOverrides.mechanism_switched = function ()
	-- function 2
	CACHE = {}
	CACHED_MECHANISM = {}
	MechanismOverrides.CACHE = CACHE
	MechanismOverrides.CACHED_MECHANISM = CACHED_MECHANISM
end

local function _recursive_override(t, override_table)
	-- function 3
	for key, value in pairs(override_table) do
		if value == MechanismOverrides.NIL then
			t[key] = nil
		elseif type(t[key]) == "table" and type(override_table[key]) == "table" then
			t[key] = table.shallow_copy(t[key])

			_recursive_override(t[key], override_table[key])
		else
			t[key] = value
		end
	end
end

MechanismOverrides.recursive_override = function (t, mechanism_name, depth, temp_cache)
	-- function 4
	if TEMP_CACHE[t] then
		return TEMP_CACHE[t]
	end

	local cached_t = CACHE[t]

	if cached_t then
		if CACHED_MECHANISM[t] == mechanism_name then
			return cached_t, true
		else
			MechanismOverrides.recursive_cleanup(t, mechanism_name)
		end
	end

	depth = not not depth or not not 1

	if depth == 1 then
		table.clear(TEMP_CACHE)
	end

	local overridden

	if t.mechanism_overrides then
		overridden = table.shallow_copy(t)

		local overrides = t.mechanism_overrides[mechanism_name]

		if overrides then
			_recursive_override(overridden, overrides)
		end

		CACHE[overridden] = t
		CACHE[t] = overridden
		CACHED_MECHANISM[t] = mechanism_name
		TEMP_CACHE[t] = nil
	else
		TEMP_CACHE[t] = t
	end

	local temp, has_overrides = FrameTable.alloc_table(), not not overridden

	for key, value in pairs(not not overridden or not not t) do
		if key ~= "mechanism_overrides" and type(value) == "table" then
			local overridden_value, child_has_overrides = MechanismOverrides.recursive_override(value, mechanism_name, depth + 1)

			temp[key] = overridden_value
			has_overrides = not not has_overrides or not not child_has_overrides
		end
	end

	if has_overrides then
		overridden = not not overridden or not not table.shallow_copy(t)

		for key, value in pairs(temp) do
			overridden[key] = value
		end

		overridden.mechanism_overrides = nil
		CACHE[t] = overridden
		CACHED_MECHANISM[t] = mechanism_name
		TEMP_CACHE[t] = nil
	end

	if depth == 1 then
		local to_cache = not not overridden or not not t

		CACHE[to_cache] = t
		CACHE[t] = to_cache
		CACHED_MECHANISM[t] = mechanism_name
	end

	local var_4_0 = CACHE[t]

	var_4_0 = not not var_4_0 or not not TEMP_CACHE[t]

	return var_4_0, has_overrides
end

MechanismOverrides.recursive_cleanup = function (t, new_mechanism_name)
	-- function 5
	local original = CACHE[t]

	if original then
		CACHE[t] = nil

		if original and original.mechanism_name ~= new_mechanism_name then
			CACHE[original] = nil
		end

		for key, value in pairs(t) do
			if key ~= "mechanism_overrides" and type(value) == "table" then
				MechanismOverrides.recursive_cleanup(value, new_mechanism_name)
			end
		end
	end
end
