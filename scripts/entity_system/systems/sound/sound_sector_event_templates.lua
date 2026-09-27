-- chunkname: @scripts/entity_system/systems/sound/sound_sector_event_templates.lua

local SoundSectorEventTemplates = SoundSectorEventTemplates

SoundSectorEventTemplates = SoundSectorEventTemplates or {}
SoundSectorEventTemplates = SoundSectorEventTemplates

local var_0_1
local tbl = {}
local tbl_2 = {}
local num = 0

SoundSectorEventTemplates.distant_horde = {
	sound_event_stop = "stop_distant_horde",
	sound_event_start = "distant_horde",
	evaluate = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
		-- function 1
		local var_1_0 = self[arg_1_1]

		if not var_1_0 then
			return false
		end

		local var_1_1
		local var_1_2

		if not (not var_0_1 and not Unit.alive(var_0_1) and not var_1_0[var_0_1]) then
			var_1_1, var_1_2 = next(var_1_0, nil)
		else
			var_1_1, var_1_2 = next(var_1_0, var_0_1)
		end

		if not (not var_1_1 and not (ScriptUnit.extension(var_1_1, "ai_system"):breed().race == "skaven") and not arg_1_3[var_1_1].has_target and var_1_2:has_death_started()) then
			if not tbl[var_1_1] then
				num = num + 1
			end

			local var_1_3 = POSITION_LOOKUP[var_1_1]

			tbl[var_1_1] = var_1_2
			tbl_2[var_1_1] = Vector3Box(var_1_3)
		end

		local zero = Vector3.zero()

		for k, v in pairs(tbl) do
			local unbox = tbl_2[k]:unbox()

			if not (not Unit.alive(k) and (v:has_death_started() or not var_1_0[k]) and arg_1_3[k].has_target) then
				tbl[k] = nil
				tbl_2[k] = nil
				num = num - 1
			elseif not unbox then
				zero = zero + unbox
			end
		end

		var_0_1 = var_1_1

		if 7 > num then
			return false
		end

		local num_2 = 25
		local num_3 = 1600
		local num_4 = zero / num
		local distance_squared = Vector3.distance_squared(arg_1_4, num_4)

		return not (num_2 <= distance_squared) or distance_squared <= num_3, num_4, num
	end
}

local var_0_5
local tbl_3 = {}
local tbl_4 = {}
local num_2 = 0

SoundSectorEventTemplates.distant_horde_chaos = {
	sound_event_stop = "stop_distant_horde_marauder",
	sound_event_start = "distant_horde_marauder",
	evaluate = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		-- function 2
		local var_2_0 = self[arg_2_1]

		if not var_2_0 then
			return false
		end

		local var_2_1
		local var_2_2

		if not (not var_0_5 and not Unit.alive(var_0_5) and not var_2_0[var_0_5]) then
			var_2_1, var_2_2 = next(var_2_0, nil)
		else
			var_2_1, var_2_2 = next(var_2_0, var_0_5)
		end

		if not (not var_2_1 and not (ScriptUnit.extension(var_2_1, "ai_system"):breed().race == "chaos") and not arg_2_3[var_2_1].has_target and var_2_2:has_death_started()) then
			if not tbl_3[var_2_1] then
				num_2 = num_2 + 1
			end

			local var_2_3 = POSITION_LOOKUP[var_2_1]

			tbl_3[var_2_1] = var_2_2
			tbl_4[var_2_1] = Vector3Box(var_2_3)
		end

		local zero = Vector3.zero()

		for k, v in pairs(tbl_3) do
			local unbox = tbl_4[k]:unbox()

			if not (not Unit.alive(k) and (v:has_death_started() or not var_2_0[k]) and arg_2_3[k].has_target) then
				tbl_3[k] = nil
				tbl_4[k] = nil
				num_2 = num_2 - 1
			elseif not unbox then
				zero = zero + unbox
			end
		end

		var_0_5 = var_2_1

		if 4 > num_2 then
			return false
		end

		local num = 4
		local num_3 = 3600
		local num_4 = zero / num_2
		local distance_squared = Vector3.distance_squared(arg_2_4, num_4)

		return not (num <= distance_squared) or distance_squared <= num_3, num_4, num_2
	end
}

local var_0_9
local tbl_5 = {}
local tbl_6 = {}
local num_3 = 0

SoundSectorEventTemplates.distant_horde_beastmen = {
	sound_event_stop = "stop_distant_horde_beastmen",
	sound_event_start = "distant_horde_beastmen",
	evaluate = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		-- function 3
		local var_3_0 = self[arg_3_1]

		if not var_3_0 then
			return false
		end

		local var_3_1
		local var_3_2

		if not (not var_0_9 and not Unit.alive(var_0_9) and not var_3_0[var_0_9]) then
			var_3_1, var_3_2 = next(var_3_0, nil)
		else
			var_3_1, var_3_2 = next(var_3_0, var_0_9)
		end

		if not (not var_3_1 and not (ScriptUnit.extension(var_3_1, "ai_system"):breed().race == "beastmen") and not arg_3_3[var_3_1].has_target and var_3_2:has_death_started()) then
			if not tbl_5[var_3_1] then
				num_3 = num_3 + 1
			end

			local var_3_3 = POSITION_LOOKUP[var_3_1]

			tbl_5[var_3_1] = var_3_2
			tbl_6[var_3_1] = Vector3Box(var_3_3)
		end

		local zero = Vector3.zero()

		for k, v in pairs(tbl_5) do
			local unbox = tbl_6[k]:unbox()

			if not (not Unit.alive(k) and (v:has_death_started() or not var_3_0[k]) and arg_3_3[k].has_target) then
				tbl_5[k] = nil
				tbl_6[k] = nil
				num_3 = num_3 - 1
			elseif not unbox then
				zero = zero + unbox
			end
		end

		var_0_9 = var_3_1

		if 4 > num_3 then
			return false
		end

		local num = 4
		local num_2 = 3600
		local num_4 = zero / num_3
		local distance_squared = Vector3.distance_squared(arg_3_4, num_4)

		return not (num <= distance_squared) or distance_squared <= num_2, num_4, num_3
	end
}
