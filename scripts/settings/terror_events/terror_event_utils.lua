-- chunkname: @scripts/settings/terror_events/terror_event_utils.lua

require("scripts/settings/grudge_mark_settings")

TerrorEventUtils = {}

function TerrorEventUtils.count_event_breed(arg_1_0)
	return Managers.state.conflict:count_units_by_breed_during_event(arg_1_0)
end

function TerrorEventUtils.num_spawned_enemies()
	return #Managers.state.conflict:spawned_enemies()
end

function TerrorEventUtils.count_breed(arg_3_0)
	return Managers.state.conflict:count_units_by_breed(arg_3_0)
end

function TerrorEventUtils.num_alive_standards()
	return #Managers.state.conflict:alive_standards()
end

function TerrorEventUtils.spawned_during_event()
	return Managers.state.conflict:enemies_spawned_during_event()
end

function TerrorEventUtils.num_spawned_enemies_during_event()
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

function TerrorEventUtils.set_seed(arg_7_0)
	var_0_0 = arg_7_0
end

function TerrorEventUtils.random(...)
	local var_8_0, var_8_1 = Math.next_random(var_0_0 or 0, ...)

	var_0_0 = var_8_0

	return var_8_1
end

function TerrorEventUtils.get_grudge_marked_name(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = Breeds[arg_9_0].race
	local var_9_1 = GrudgeMarkedNames[BreedEnhancements] or GrudgeMarkedNames[arg_9_0] or GrudgeMarkedNames[var_9_0]

	if arg_9_2 then
		for iter_9_0, iter_9_1 in pairs(arg_9_2) do
			if GrudgeMarkedNames[iter_9_0] then
				var_9_1 = GrudgeMarkedNames[iter_9_0]
			end
		end
	end

	fassert(var_9_1, "%s is not a valid breed, or does not have a valid race set in its breed data", arg_9_0)

	local var_9_2 = arg_9_1 % #var_9_1 + 1

	return (Localize(var_9_1[var_9_2]))
end

function TerrorEventUtils.apply_breed_enhancements(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = Managers.state.entity:system("ai_system")
	local var_10_1 = arg_10_2.name_index or TerrorEventUtils.random(16384)

	var_10_0:set_attribute(arg_10_0, "name_index", "grudge_marked", var_10_1)

	local var_10_2 = Managers.state.entity:system("buff_system")
	local var_10_3 = arg_10_2.enhancements
	local var_10_4 = table.find_by_key(var_10_3, "name", "intangible_mirror") ~= nil

	for iter_10_0 = 1, #var_10_3 do
		local var_10_5 = var_10_3[iter_10_0]

		if not var_10_5.no_attribute then
			var_10_0:set_attribute(arg_10_0, var_10_5.name, "breed_enhancements", true)
		end

		if not var_10_4 or var_10_5.name == "mirror_base" or var_10_5.name == "intangible_mirror" then
			for iter_10_1 = 1, #var_10_5 do
				local var_10_6 = var_10_5[iter_10_1]

				var_10_2:add_buff(arg_10_0, var_10_6, arg_10_0, true)
			end
		end
	end
end

function TerrorEventUtils.generate_enhanced_breed(arg_11_0, arg_11_1, arg_11_2)
	arg_11_2 = arg_11_2 or BossGrudgeMarks

	local var_11_0 = {}
	local var_11_1 = {
		BreedEnhancements.base
	}

	for iter_11_0, iter_11_1 in pairs(arg_11_2) do
		var_11_0[#var_11_0 + 1] = iter_11_0
	end

	local var_11_2 = BreedEnhancementBannedBreeds[arg_11_1]

	if var_11_2 then
		for iter_11_2 = #var_11_0, 1, -1 do
			if var_11_2[var_11_0[iter_11_2]] then
				table.swap_delete(var_11_0, iter_11_2)
			end
		end
	end

	for iter_11_3 = 1, arg_11_0 do
		local var_11_3 = TerrorEventUtils.random(#var_11_0)

		if var_11_3 <= 0 then
			break
		end

		local var_11_4 = var_11_0[var_11_3]
		local var_11_5 = BreedEnhancements[var_11_4]

		table.swap_delete(var_11_0, var_11_3)

		local var_11_6 = BreedEnhancementExclusionList[var_11_5.name]

		if var_11_6 then
			for iter_11_4 = #var_11_0, 1, -1 do
				if var_11_6[var_11_0[iter_11_4]] then
					table.swap_delete(var_11_0, iter_11_4)
				end
			end
		end

		var_11_1[#var_11_1 + 1] = var_11_5
	end

	return var_11_1
end

function TerrorEventUtils.generate_enhanced_breed_from_set(arg_12_0)
	local var_12_0 = {}
	local var_12_1 = BreedEnhancements

	for iter_12_0, iter_12_1 in pairs(arg_12_0) do
		if iter_12_1 and var_12_1[iter_12_0] then
			local var_12_2 = var_12_1[iter_12_0]

			var_12_0[#var_12_0 + 1] = var_12_2
		end
	end

	if #var_12_0 > 0 then
		var_12_0[#var_12_0 + 1] = var_12_1.base

		return var_12_0
	end

	return nil
end

function TerrorEventUtils.add_enhancements_to_spawn_data(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if arg_13_1 > 0 then
		arg_13_0 = arg_13_0 or {}
		arg_13_0.enhancements = TerrorEventUtils.generate_enhanced_breed(arg_13_1, arg_13_2, arg_13_3 or BossGrudgeMarks)
	end

	return arg_13_0
end

function TerrorEventUtils.add_enhancements_for_difficulty(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	arg_14_0 = arg_14_0 or {}

	local var_14_0 = DifficultyTweak.converters.closest_tweak_match(arg_14_1, arg_14_4, BREED_ENHANCEMENTS_PER_DIFFICULTY) or 0

	if var_14_0 > 0 then
		arg_14_5 = arg_14_5 or BossGrudgeMarks

		return TerrorEventUtils.add_enhancements_to_spawn_data(arg_14_0, var_14_0, arg_14_2, arg_14_5)
	end

	return arg_14_0
end

return TerrorEventUtils
