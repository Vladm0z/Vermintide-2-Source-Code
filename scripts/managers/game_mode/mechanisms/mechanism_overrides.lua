-- chunkname: @scripts/managers/game_mode/mechanisms/mechanism_overrides.lua

MechanismOverrides = MechanismOverrides or {}
MechanismOverrides.NIL = MechanismOverrides.NIL or {}
MechanismOverrides.CACHE = MechanismOverrides.CACHE or {}
MechanismOverrides.TEMP_CACHE = MechanismOverrides.TEMP_CACHE or {}
MechanismOverrides.CACHED_MECHANISM = MechanismOverrides.CACHED_MECHANISM or {}

local var_0_0 = MechanismOverrides.CACHE
local var_0_1 = MechanismOverrides.CACHED_MECHANISM
local var_0_2 = MechanismOverrides.TEMP_CACHE

function MechanismOverrides.get(arg_1_0, arg_1_1)
	if arg_1_0 == nil then
		return nil
	end

	local var_1_0 = arg_1_1 or Managers.mechanism:current_mechanism_name()

	return MechanismOverrides.recursive_override(arg_1_0, var_1_0, 1)
end

function MechanismOverrides.mechanism_switched()
	var_0_0 = {}
	var_0_1 = {}
	MechanismOverrides.CACHE = var_0_0
	MechanismOverrides.CACHED_MECHANISM = var_0_1
end

local function var_0_3(arg_3_0, arg_3_1)
	for iter_3_0, iter_3_1 in pairs(arg_3_1) do
		if iter_3_1 == MechanismOverrides.NIL then
			arg_3_0[iter_3_0] = nil
		elseif type(arg_3_0[iter_3_0]) == "table" and type(arg_3_1[iter_3_0]) == "table" then
			arg_3_0[iter_3_0] = table.shallow_copy(arg_3_0[iter_3_0])

			var_0_3(arg_3_0[iter_3_0], arg_3_1[iter_3_0])
		else
			arg_3_0[iter_3_0] = iter_3_1
		end
	end
end

function MechanismOverrides.recursive_override(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if var_0_2[arg_4_0] then
		return var_0_2[arg_4_0]
	end

	local var_4_0 = var_0_0[arg_4_0]

	if var_4_0 then
		if var_0_1[arg_4_0] == arg_4_1 then
			return var_4_0, true
		else
			MechanismOverrides.recursive_cleanup(arg_4_0, arg_4_1)
		end
	end

	arg_4_2 = arg_4_2 or 1

	if arg_4_2 == 1 then
		table.clear(var_0_2)
	end

	local var_4_1

	if arg_4_0.mechanism_overrides then
		var_4_1 = table.shallow_copy(arg_4_0)

		local var_4_2 = arg_4_0.mechanism_overrides[arg_4_1]

		if var_4_2 then
			var_0_3(var_4_1, var_4_2)
		end

		var_0_0[var_4_1] = arg_4_0
		var_0_0[arg_4_0] = var_4_1
		var_0_1[arg_4_0] = arg_4_1
		var_0_2[arg_4_0] = nil
	else
		var_0_2[arg_4_0] = arg_4_0
	end

	local var_4_3 = FrameTable.alloc_table()
	local var_4_4 = not not var_4_1

	for iter_4_0, iter_4_1 in pairs(var_4_1 or arg_4_0) do
		if iter_4_0 ~= "mechanism_overrides" and type(iter_4_1) == "table" then
			local var_4_5, var_4_6 = MechanismOverrides.recursive_override(iter_4_1, arg_4_1, arg_4_2 + 1)

			var_4_3[iter_4_0] = var_4_5
			var_4_4 = var_4_4 or var_4_6
		end
	end

	if var_4_4 then
		var_4_1 = var_4_1 or table.shallow_copy(arg_4_0)

		for iter_4_2, iter_4_3 in pairs(var_4_3) do
			var_4_1[iter_4_2] = iter_4_3
		end

		var_4_1.mechanism_overrides = nil
		var_0_0[arg_4_0] = var_4_1
		var_0_1[arg_4_0] = arg_4_1
		var_0_2[arg_4_0] = nil
	end

	if arg_4_2 == 1 then
		local var_4_7 = var_4_1 or arg_4_0

		var_0_0[var_4_7] = arg_4_0
		var_0_0[arg_4_0] = var_4_7
		var_0_1[arg_4_0] = arg_4_1
	end

	return var_0_0[arg_4_0] or var_0_2[arg_4_0], var_4_4
end

function MechanismOverrides.recursive_cleanup(arg_5_0, arg_5_1)
	local var_5_0 = var_0_0[arg_5_0]

	if var_5_0 then
		var_0_0[arg_5_0] = nil

		if var_5_0 and var_5_0.mechanism_name ~= arg_5_1 then
			var_0_0[var_5_0] = nil
		end

		for iter_5_0, iter_5_1 in pairs(arg_5_0) do
			if iter_5_0 ~= "mechanism_overrides" and type(iter_5_1) == "table" then
				MechanismOverrides.recursive_cleanup(iter_5_1, arg_5_1)
			end
		end
	end
end
