-- chunkname: @scripts/settings/terror_events/terror_event_utils.lua

require("scripts/settings/grudge_mark_settings")

TerrorEventUtils = {}

TerrorEventUtils.count_event_breed = function (arg_1_0)
	-- function 1
	return Managers.state.conflict:count_units_by_breed_during_event(arg_1_0)
end

TerrorEventUtils.num_spawned_enemies = function ()
	-- function 2
	return #Managers.state.conflict:spawned_enemies()
end

TerrorEventUtils.count_breed = function (arg_3_0)
	-- function 3
	return Managers.state.conflict:count_units_by_breed(arg_3_0)
end

TerrorEventUtils.num_alive_standards = function ()
	-- function 4
	return #Managers.state.conflict:alive_standards()
end

TerrorEventUtils.spawned_during_event = function ()
	-- function 5
	return Managers.state.conflict:enemies_spawned_during_event()
end

TerrorEventUtils.num_spawned_enemies_during_event = function ()
	-- function 6
	return (Managers.state.conflict:enemies_spawned_during_event())
end

TerrorEventUtils.NORMAL = 2
TerrorEventUtils.HARD = 3
TerrorEventUtils.HARDER = 4
TerrorEventUtils.HARDEST = 5
TerrorEventUtils.CATACLYSM = 6
TerrorEventUtils.CATACLYSM2 = 7
TerrorEventUtils.CATACLYSM3 = 8

local var_0_0

TerrorEventUtils.set_seed = function (arg_7_0)
	-- function 7
	var_0_0 = arg_7_0
end

TerrorEventUtils.random = function (...)
	-- function 8
	local next_random = Math.next_random
	local var_8_1 = var_0_0

	var_8_1 = var_8_1 or 0

	local var_8_2, var_8_3 = next_random(var_8_1, ...)

	var_0_0 = var_8_2

	return var_8_3
end

TerrorEventUtils.get_grudge_marked_name = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	local race = Breeds[arg_9_0].race
	local var_9_1 = GrudgeMarkedNames[BreedEnhancements]

	if not var_9_1 then
		var_9_1 = GrudgeMarkedNames[arg_9_0]
		var_9_1 = var_9_1 or GrudgeMarkedNames[race]
	end

	if not arg_9_2 then
		for k, v in pairs(arg_9_2) do
			if not GrudgeMarkedNames[k] then
				var_9_1 = GrudgeMarkedNames[k]
			end
		end
	end

	fassert(var_9_1, "%s is not a valid breed, or does not have a valid race set in its breed data", arg_9_0)

	local num = arg_9_1 % #var_9_1 + 1

	return (Localize(var_9_1[num]))
end

TerrorEventUtils.apply_breed_enhancements = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	local system = Managers.state.entity:system("ai_system")
	local name_index = arg_10_2.name_index

	name_index = name_index or TerrorEventUtils.random(16384)

	system:set_attribute(arg_10_0, "name_index", "grudge_marked", name_index)

	local system_2 = Managers.state.entity:system("buff_system")
	local enhancements = arg_10_2.enhancements
	local flag = table.find_by_key(enhancements, "name", "intangible_mirror") ~= nil

	for i = 1, #enhancements do
		local var_10_5 = enhancements[i]

		if not var_10_5.no_attribute then
			system:set_attribute(arg_10_0, var_10_5.name, "breed_enhancements", true)
		end

		if not (not flag and var_10_5.name == "mirror_base" or var_10_5.name ~= "intangible_mirror") then
			for j = 1, #var_10_5 do
				local var_10_6 = var_10_5[j]

				system_2:add_buff(arg_10_0, var_10_6, arg_10_0, true)
			end
		end
	end
end

TerrorEventUtils.generate_enhanced_breed = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	arg_11_2 = arg_11_2 or BossGrudgeMarks

	local tbl = {}
	local tbl_2 = {
		BreedEnhancements.base
	}

	for k, v in pairs(arg_11_2) do
		tbl[#tbl + 1] = k
	end

	local var_11_2 = BreedEnhancementBannedBreeds[arg_11_1]

	if not var_11_2 then
		for k_2 = #tbl, 1, -1 do
			if not var_11_2[tbl[k_2]] then
				table.swap_delete(tbl, k_2)
			end
		end
	end

	for l = 1, arg_11_0 do
		local random = TerrorEventUtils.random(#tbl)

		if random <= 0 then
			break
		end

		local var_11_4 = tbl[random]
		local var_11_5 = BreedEnhancements[var_11_4]

		table.swap_delete(tbl, random)

		local var_11_6 = BreedEnhancementExclusionList[var_11_5.name]

		if not var_11_6 then
			for i4 = #tbl, 1, -1 do
				if not var_11_6[tbl[i4]] then
					table.swap_delete(tbl, i4)
				end
			end
		end

		tbl_2[#tbl_2 + 1] = var_11_5
	end

	return tbl_2
end

TerrorEventUtils.generate_enhanced_breed_from_set = function (arg_12_0)
	-- function 12
	local tbl = {}
	local BreedEnhancements = BreedEnhancements

	for k, v in pairs(arg_12_0) do
		if not v and not BreedEnhancements[k] then
			local var_12_2 = BreedEnhancements[k]

			tbl[#tbl + 1] = var_12_2
		end
	end

	if #tbl > 0 then
		tbl[#tbl + 1] = BreedEnhancements.base

		return tbl
	end

	return nil
end

TerrorEventUtils.add_enhancements_to_spawn_data = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	if arg_13_1 > 0 then
		self = self or {}
		self.enhancements = TerrorEventUtils.generate_enhanced_breed(arg_13_1, arg_13_2, arg_13_3 or BossGrudgeMarks)
	end

	return self
end

TerrorEventUtils.add_enhancements_for_difficulty = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	-- function 14
	arg_14_0 = arg_14_0 or {}

	local closest_tweak_match = DifficultyTweak.converters.closest_tweak_match(arg_14_1, arg_14_4, BREED_ENHANCEMENTS_PER_DIFFICULTY)

	closest_tweak_match = closest_tweak_match or 0

	if closest_tweak_match > 0 then
		arg_14_5 = arg_14_5 or BossGrudgeMarks

		return TerrorEventUtils.add_enhancements_to_spawn_data(arg_14_0, closest_tweak_match, arg_14_2, arg_14_5)
	end

	return arg_14_0
end

return TerrorEventUtils
