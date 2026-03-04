-- chunkname: @scripts/entity_system/systems/sound/sound_sector_event_templates.lua

SoundSectorEventTemplates = SoundSectorEventTemplates or {}

local var_0_0
local var_0_1 = {}
local var_0_2 = {}
local var_0_3 = 0

SoundSectorEventTemplates.distant_horde = {
	sound_event_stop = "stop_distant_horde",
	sound_event_start = "distant_horde",
	evaluate = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
		local var_1_0 = arg_1_0[arg_1_1]

		if not var_1_0 then
			return false
		end

		local var_1_1
		local var_1_2

		if not var_0_0 or not Unit.alive(var_0_0) or not var_1_0[var_0_0] then
			var_1_1, var_1_2 = next(var_1_0, nil)
		else
			var_1_1, var_1_2 = next(var_1_0, var_0_0)
		end

		if var_1_1 and ScriptUnit.extension(var_1_1, "ai_system"):breed().race == "skaven" and arg_1_3[var_1_1].has_target and not var_1_2:has_death_started() then
			if not var_0_1[var_1_1] then
				var_0_3 = var_0_3 + 1
			end

			local var_1_3 = POSITION_LOOKUP[var_1_1]

			var_0_1[var_1_1] = var_1_2
			var_0_2[var_1_1] = Vector3Box(var_1_3)
		end

		local var_1_4 = Vector3.zero()

		for iter_1_0, iter_1_1 in pairs(var_0_1) do
			local var_1_5 = var_0_2[iter_1_0]:unbox()

			if not Unit.alive(iter_1_0) or iter_1_1:has_death_started() or not var_1_0[iter_1_0] or not arg_1_3[iter_1_0].has_target then
				var_0_1[iter_1_0] = nil
				var_0_2[iter_1_0] = nil
				var_0_3 = var_0_3 - 1
			elseif var_1_5 then
				var_1_4 = var_1_4 + var_1_5
			end
		end

		var_0_0 = var_1_1

		if 7 > var_0_3 then
			return false
		end

		local var_1_6 = 25
		local var_1_7 = 1600
		local var_1_8 = var_1_4 / var_0_3
		local var_1_9 = Vector3.distance_squared(arg_1_4, var_1_8)

		return var_1_6 <= var_1_9 and var_1_9 <= var_1_7, var_1_8, var_0_3
	end
}

local var_0_4
local var_0_5 = {}
local var_0_6 = {}
local var_0_7 = 0

SoundSectorEventTemplates.distant_horde_chaos = {
	sound_event_stop = "stop_distant_horde_marauder",
	sound_event_start = "distant_horde_marauder",
	evaluate = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		local var_2_0 = arg_2_0[arg_2_1]

		if not var_2_0 then
			return false
		end

		local var_2_1
		local var_2_2

		if not var_0_4 or not Unit.alive(var_0_4) or not var_2_0[var_0_4] then
			var_2_1, var_2_2 = next(var_2_0, nil)
		else
			var_2_1, var_2_2 = next(var_2_0, var_0_4)
		end

		if var_2_1 and ScriptUnit.extension(var_2_1, "ai_system"):breed().race == "chaos" and arg_2_3[var_2_1].has_target and not var_2_2:has_death_started() then
			if not var_0_5[var_2_1] then
				var_0_7 = var_0_7 + 1
			end

			local var_2_3 = POSITION_LOOKUP[var_2_1]

			var_0_5[var_2_1] = var_2_2
			var_0_6[var_2_1] = Vector3Box(var_2_3)
		end

		local var_2_4 = Vector3.zero()

		for iter_2_0, iter_2_1 in pairs(var_0_5) do
			local var_2_5 = var_0_6[iter_2_0]:unbox()

			if not Unit.alive(iter_2_0) or iter_2_1:has_death_started() or not var_2_0[iter_2_0] or not arg_2_3[iter_2_0].has_target then
				var_0_5[iter_2_0] = nil
				var_0_6[iter_2_0] = nil
				var_0_7 = var_0_7 - 1
			elseif var_2_5 then
				var_2_4 = var_2_4 + var_2_5
			end
		end

		var_0_4 = var_2_1

		if 4 > var_0_7 then
			return false
		end

		local var_2_6 = 4
		local var_2_7 = 3600
		local var_2_8 = var_2_4 / var_0_7
		local var_2_9 = Vector3.distance_squared(arg_2_4, var_2_8)

		return var_2_6 <= var_2_9 and var_2_9 <= var_2_7, var_2_8, var_0_7
	end
}

local var_0_8
local var_0_9 = {}
local var_0_10 = {}
local var_0_11 = 0

SoundSectorEventTemplates.distant_horde_beastmen = {
	sound_event_stop = "stop_distant_horde_beastmen",
	sound_event_start = "distant_horde_beastmen",
	evaluate = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		local var_3_0 = arg_3_0[arg_3_1]

		if not var_3_0 then
			return false
		end

		local var_3_1
		local var_3_2

		if not var_0_8 or not Unit.alive(var_0_8) or not var_3_0[var_0_8] then
			var_3_1, var_3_2 = next(var_3_0, nil)
		else
			var_3_1, var_3_2 = next(var_3_0, var_0_8)
		end

		if var_3_1 and ScriptUnit.extension(var_3_1, "ai_system"):breed().race == "beastmen" and arg_3_3[var_3_1].has_target and not var_3_2:has_death_started() then
			if not var_0_9[var_3_1] then
				var_0_11 = var_0_11 + 1
			end

			local var_3_3 = POSITION_LOOKUP[var_3_1]

			var_0_9[var_3_1] = var_3_2
			var_0_10[var_3_1] = Vector3Box(var_3_3)
		end

		local var_3_4 = Vector3.zero()

		for iter_3_0, iter_3_1 in pairs(var_0_9) do
			local var_3_5 = var_0_10[iter_3_0]:unbox()

			if not Unit.alive(iter_3_0) or iter_3_1:has_death_started() or not var_3_0[iter_3_0] or not arg_3_3[iter_3_0].has_target then
				var_0_9[iter_3_0] = nil
				var_0_10[iter_3_0] = nil
				var_0_11 = var_0_11 - 1
			elseif var_3_5 then
				var_3_4 = var_3_4 + var_3_5
			end
		end

		var_0_8 = var_3_1

		if 4 > var_0_11 then
			return false
		end

		local var_3_6 = 4
		local var_3_7 = 3600
		local var_3_8 = var_3_4 / var_0_11
		local var_3_9 = Vector3.distance_squared(arg_3_4, var_3_8)

		return var_3_6 <= var_3_9 and var_3_9 <= var_3_7, var_3_8, var_0_11
	end
}
