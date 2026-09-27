-- chunkname: @scripts/managers/game_mode/mechanisms/mechanism_overrides.lua

local MechanismOverrides = MechanismOverrides

MechanismOverrides = MechanismOverrides or {}
MechanismOverrides = MechanismOverrides

local MechanismOverrides_2 = MechanismOverrides
local NIL = MechanismOverrides.NIL

NIL = NIL or {}
MechanismOverrides_2.NIL = NIL

local MechanismOverrides_3 = MechanismOverrides
local CACHE = MechanismOverrides.CACHE

CACHE = CACHE or {}
MechanismOverrides_3.CACHE = CACHE

local MechanismOverrides_4 = MechanismOverrides
local TEMP_CACHE = MechanismOverrides.TEMP_CACHE

TEMP_CACHE = TEMP_CACHE or {}
MechanismOverrides_4.TEMP_CACHE = TEMP_CACHE

local MechanismOverrides_5 = MechanismOverrides
local CACHED_MECHANISM = MechanismOverrides.CACHED_MECHANISM

CACHED_MECHANISM = CACHED_MECHANISM or {}
MechanismOverrides_5.CACHED_MECHANISM = CACHED_MECHANISM

local CACHE_2 = MechanismOverrides.CACHE
local CACHED_MECHANISM_2 = MechanismOverrides.CACHED_MECHANISM
local TEMP_CACHE_2 = MechanismOverrides.TEMP_CACHE

MechanismOverrides.get = function (arg_1_0, arg_1_1)
	-- function 1
	if arg_1_0 == nil then
		return nil
	end

	local flag = arg_1_1 or Managers.mechanism:current_mechanism_name()

	return MechanismOverrides.recursive_override(arg_1_0, flag, 1)
end

MechanismOverrides.mechanism_switched = function ()
	-- function 2
	CACHE_2 = {}
	CACHED_MECHANISM_2 = {}
	MechanismOverrides.CACHE = CACHE_2
	MechanismOverrides.CACHED_MECHANISM = CACHED_MECHANISM_2
end

local function fn(self, arg_3_1)
	-- function 3
	for k, v in pairs(arg_3_1) do
		if v == MechanismOverrides.NIL then
			self[k] = nil
		elseif not (type(self[k]) ~= "table" or type(arg_3_1[k]) ~= "table") then
			self[k] = table.shallow_copy(self[k])

			fn(self[k], arg_3_1[k])
		else
			self[k] = v
		end
	end
end

MechanismOverrides.recursive_override = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	if not TEMP_CACHE_2[self] then
		return TEMP_CACHE_2[self]
	end

	local var_4_0 = CACHE_2[self]

	if not var_4_0 then
		if CACHED_MECHANISM_2[self] == arg_4_1 then
			return var_4_0, true
		else
			MechanismOverrides.recursive_cleanup(self, arg_4_1)
		end
	end

	arg_4_2 = arg_4_2 or 1

	if arg_4_2 == 1 then
		table.clear(TEMP_CACHE_2)
	end

	local var_4_1

	if not self.mechanism_overrides then
		var_4_1 = table.shallow_copy(self)

		local var_4_2 = self.mechanism_overrides[arg_4_1]

		if not var_4_2 then
			fn(var_4_1, var_4_2)
		end

		CACHE_2[var_4_1] = self
		CACHE_2[self] = var_4_1
		CACHED_MECHANISM_2[self] = arg_4_1
		TEMP_CACHE_2[self] = nil
	else
		TEMP_CACHE_2[self] = self
	end

	local alloc_table = FrameTable.alloc_table()
	local flag = not not var_4_1

	for k, v in pairs(var_4_1 or self) do
		if not (k == "mechanism_overrides" or type(v) ~= "table") then
			local recursive_override, var_4_6 = MechanismOverrides.recursive_override(v, arg_4_1, arg_4_2 + 1)

			alloc_table[k] = recursive_override
			flag = flag or var_4_6
		end
	end

	if not flag then
		var_4_1 = var_4_1 or table.shallow_copy(self)

		for k_2, v_2 in pairs(alloc_table) do
			var_4_1[k_2] = v_2
		end

		var_4_1.mechanism_overrides = nil
		CACHE_2[self] = var_4_1
		CACHED_MECHANISM_2[self] = arg_4_1
		TEMP_CACHE_2[self] = nil
	end

	if arg_4_2 == 1 then
		local flag_2 = var_4_1 or self

		CACHE_2[flag_2] = self
		CACHE_2[self] = flag_2
		CACHED_MECHANISM_2[self] = arg_4_1
	end

	local var_4_8 = CACHE_2[self]

	var_4_8 = var_4_8 or TEMP_CACHE_2[self]

	return var_4_8, flag
end

MechanismOverrides.recursive_cleanup = function (arg_5_0, arg_5_1)
	-- function 5
	local var_5_0 = CACHE_2[arg_5_0]

	if not var_5_0 then
		CACHE_2[arg_5_0] = nil

		if not (not var_5_0 and var_5_0.mechanism_name == arg_5_1) then
			CACHE_2[var_5_0] = nil
		end

		for k, v in pairs(arg_5_0) do
			if not (k == "mechanism_overrides" or type(v) ~= "table") then
				MechanismOverrides.recursive_cleanup(v, arg_5_1)
			end
		end
	end
end
