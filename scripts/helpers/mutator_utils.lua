-- chunkname: @scripts/helpers/mutator_utils.lua

MutatorUtils = MutatorUtils or {}

local function var_0_0(arg_1_0, arg_1_1)
	return math.max(1, math.ceil(arg_1_0 * arg_1_1))
end

local function var_0_1(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	if arg_2_2[arg_2_1] then
		return
	end

	arg_2_2[arg_2_1] = true

	local var_2_0 = arg_2_0[arg_2_1]

	if not var_2_0 then
		print("[MutatorUtils.update_conflict_settings_horde_size_modifier] did not find " .. arg_2_1)

		return
	end

	for iter_2_0, iter_2_1 in ipairs(var_2_0) do
		local var_2_1 = iter_2_1.breeds

		for iter_2_2 = 2, #var_2_1, 2 do
			local var_2_2 = var_2_1[iter_2_2]

			var_2_2[1] = var_0_0(var_2_2[1], arg_2_3)
			var_2_2[2] = var_0_0(var_2_2[2], arg_2_3)
		end
	end
end

local function var_0_2(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	if type(arg_3_1) == "string" then
		var_0_1(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	else
		for iter_3_0, iter_3_1 in ipairs(arg_3_1) do
			var_0_1(arg_3_0, iter_3_1, arg_3_2, arg_3_3)
		end
	end
end

local function var_0_3(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0[1]
	local var_4_1 = arg_4_0[2]

	arg_4_0[1] = var_4_0 - var_4_0 * arg_4_1
	arg_4_0[2] = var_4_1 - var_4_1 * arg_4_1
end

function MutatorUtils.apply_buff_to_alive_player_units(arg_5_0, arg_5_1, arg_5_2)
	if not arg_5_1.buffed_player_units then
		arg_5_1.buffed_player_units = {}
	end

	local var_5_0 = arg_5_1.buffed_player_units

	if not var_5_0[arg_5_2] then
		var_5_0[arg_5_2] = {}
	end

	local var_5_1 = var_5_0[arg_5_2]

	for iter_5_0, iter_5_1 in pairs(var_5_1) do
		var_5_1[iter_5_0] = false
	end

	local var_5_2 = Managers.state.side:get_side_from_name("heroes")
	local var_5_3 = arg_5_1.only_affect_players and var_5_2.PLAYER_UNITS or var_5_2.PLAYER_AND_BOT_UNITS
	local var_5_4 = #var_5_3
	local var_5_5 = ScriptUnit.extension
	local var_5_6 = {}

	for iter_5_2 = 1, var_5_4 do
		local var_5_7 = var_5_3[iter_5_2]

		if var_5_1[var_5_7] == nil and HEALTH_ALIVE[var_5_7] then
			local var_5_8 = {
				attacker_unit = var_5_7
			}

			var_5_6[var_5_7] = var_5_5(var_5_7, "buff_system"):add_buff(arg_5_2, var_5_8)
		end

		var_5_1[var_5_7] = true
	end

	for iter_5_3, iter_5_4 in pairs(var_5_1) do
		if not iter_5_4 then
			var_5_1[iter_5_3] = nil
		end
	end

	return var_5_6
end

function MutatorUtils.store_breed_and_action_settings(arg_6_0, arg_6_1)
	if not arg_6_0.original_breed_settings and not arg_6_0.original_breed_action_settings then
		arg_6_0.original_breed_settings = table.clone(Breeds)
		arg_6_0.original_breed_action_settings = table.clone(BreedActions)
	end
end

function MutatorUtils.restore_breed_and_action_settings(arg_7_0, arg_7_1)
	if arg_7_0.original_breed_settings and arg_7_0.original_breed_action_settings then
		Breeds = arg_7_0.original_breed_settings
		BreedActions = arg_7_0.original_breed_action_settings
		arg_7_0.original_breed_settings = nil
		arg_7_0.original_breed_action_settings = nil
	end
end

function MutatorUtils.update_conflict_settings_horde_size_modifier(arg_8_0)
	if CurrentPacing.disabled then
		return
	end

	local var_8_0 = CurrentHordeSettings.compositions_pacing
	local var_8_1 = {}

	var_0_2(var_8_0, CurrentHordeSettings.ambush_composition, var_8_1, arg_8_0)
	var_0_2(var_8_0, CurrentHordeSettings.vector_composition, var_8_1, arg_8_0)
	var_0_2(var_8_0, CurrentHordeSettings.vector_blob_composition, var_8_1, arg_8_0)
	var_0_2(var_8_0, CurrentHordeSettings.mini_patrol_composition, var_8_1, arg_8_0)
end

function MutatorUtils.update_conflict_settings_horde_frequency(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = CurrentPacing

	if not var_9_0.disabled then
		var_0_3(var_9_0.horde_frequency, arg_9_0, "Changed horde frequency from ({%s, %s}) to ({%s, %s}), modifier: %s - original")
		var_0_3(var_9_0.horde_startup_time, arg_9_1, "Changed horde startup time from ({%s, %s}) to ({%s, %s}), modifier: %s - original")
		var_0_3(var_9_0.relax_duration, arg_9_2, "Changed relax duration from ({%s, %s}) to ({%s, %s}), modifier: %s - original")

		if var_9_0.max_delay_until_next_horde then
			var_0_3(var_9_0.max_delay_until_next_horde, arg_9_3, "Changed max_delay_until_next_horde from ({%s, %s}) to ({%s, %s}), modifier: %s - original")
		end
	end
end

function MutatorUtils.tweak_pack_spawning_settings_convert_breeds(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.roaming_set.breed_packs

	arg_10_0.roaming_set.breed_packs = arg_10_1[var_10_0] or var_10_0

	for iter_10_0, iter_10_1 in ipairs(arg_10_0.roaming_set.breed_packs_override) do
		local var_10_1 = iter_10_1[1]

		iter_10_1[1] = arg_10_1[var_10_1] or var_10_1
	end

	if arg_10_0.difficulty_overrides then
		for iter_10_2, iter_10_3 in pairs(arg_10_0.difficulty_overrides) do
			for iter_10_4 = 1, #iter_10_3 do
				local var_10_2 = iter_10_3[iter_10_4]
				local var_10_3 = var_10_2[1]

				var_10_2[1] = arg_10_1[var_10_3] or var_10_3
			end
		end
	end
end

function MutatorUtils.tweak_pack_spawning_settings_density_multiplier(arg_11_0, arg_11_1)
	arg_11_0.area_density_coefficient = arg_11_0.area_density_coefficient * arg_11_1

	if arg_11_0.difficulty_overrides then
		for iter_11_0, iter_11_1 in pairs(arg_11_0.difficulty_overrides) do
			iter_11_1.area_density_coefficient = iter_11_1.area_density_coefficient * arg_11_1

			for iter_11_2 = 1, #iter_11_1 do
				local var_11_0 = iter_11_1[iter_11_2]

				var_11_0[3] = var_11_0[3] * arg_11_1
			end
		end
	end
end

function MutatorUtils.tweak_pack_spawning_settings_override_chance(arg_12_0, arg_12_1, arg_12_2)
	arg_12_0.roaming_set.breed_packs_peeks_overide_chance[1] = math.clamp(arg_12_1, 0, 1)
	arg_12_0.roaming_set.breed_packs_peeks_overide_chance[2] = math.clamp(arg_12_2, 0, 1)
end

function MutatorUtils.update_conflict_settings_specials_frequency(arg_13_0, arg_13_1)
	local var_13_0 = CurrentSpecialsSettings

	if not var_13_0.disabled then
		if var_13_0.max_specials then
			local var_13_1 = var_13_0.max_specials

			var_13_0.max_specials = math.round(var_13_0.max_specials * arg_13_0)
		end

		for iter_13_0, iter_13_1 in pairs(var_13_0.methods) do
			local var_13_2 = false

			if iter_13_0 == "specials_by_time_window" then
				local var_13_3 = iter_13_1.spawn_interval

				var_13_3[1] = var_13_3[1] * arg_13_1
				var_13_3[2] = var_13_3[2] * arg_13_1
				var_13_2 = true

				local var_13_4 = var_13_3[1]
				local var_13_5 = var_13_3[2]
				local var_13_6 = var_13_4 / arg_13_1
				local var_13_7 = var_13_5 / arg_13_1
			end

			if iter_13_0 == "specials_by_slots" then
				local var_13_8 = iter_13_1.spawn_cooldown

				var_13_8[1] = var_13_8[1] * arg_13_1
				var_13_8[2] = var_13_8[2] * arg_13_1
				var_13_2 = true

				local var_13_9 = var_13_8[1]
				local var_13_10 = var_13_8[2]
				local var_13_11 = var_13_9 / arg_13_1
				local var_13_12 = var_13_10 / arg_13_1
			end

			fassert(var_13_2, "MutatorUtils.update_conflict_settings_specials_frequency: Found new method_name (%s)", iter_13_0)
		end
	end
end
