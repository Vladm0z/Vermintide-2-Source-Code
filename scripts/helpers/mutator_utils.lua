-- chunkname: @scripts/helpers/mutator_utils.lua

local MutatorUtils = MutatorUtils

MutatorUtils = MutatorUtils or {}
MutatorUtils = MutatorUtils

local function fn(arg_1_0, arg_1_1)
	-- function 1
	return math.max(1, math.ceil(arg_1_0 * arg_1_1))
end

local function fn_2(self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	if not arg_2_2[arg_2_1] then
		return
	end

	arg_2_2[arg_2_1] = true

	local var_2_0 = self[arg_2_1]

	if not var_2_0 then
		print("[MutatorUtils.update_conflict_settings_horde_size_modifier] did not find " .. arg_2_1)

		return
	end

	for i, v in ipairs(var_2_0) do
		local breeds = v.breeds

		for k = 2, #breeds, 2 do
			local var_2_2 = breeds[k]

			var_2_2[1] = fn(var_2_2[1], arg_2_3)
			var_2_2[2] = fn(var_2_2[2], arg_2_3)
		end
	end
end

local function fn_3(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	if type(arg_3_1) == "string" then
		fn_2(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	else
		for i, v in ipairs(arg_3_1) do
			fn_2(arg_3_0, v, arg_3_2, arg_3_3)
		end
	end
end

local function fn_4(self, arg_4_1, arg_4_2)
	-- function 4
	local var_4_0 = self[1]
	local var_4_1 = self[2]

	self[1] = var_4_0 - var_4_0 * arg_4_1
	self[2] = var_4_1 - var_4_1 * arg_4_1
end

MutatorUtils.apply_buff_to_alive_player_units = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	if not arg_5_1.buffed_player_units then
		arg_5_1.buffed_player_units = {}
	end

	local buffed_player_units = arg_5_1.buffed_player_units

	if not buffed_player_units[arg_5_2] then
		buffed_player_units[arg_5_2] = {}
	end

	local var_5_1 = buffed_player_units[arg_5_2]

	for k, v in pairs(var_5_1) do
		var_5_1[k] = false
	end

	local get_side_from_name = Managers.state.side:get_side_from_name("heroes")
	local PLAYER_UNITS

	if not arg_5_1.only_affect_players then
		PLAYER_UNITS = get_side_from_name.PLAYER_UNITS

		if not PLAYER_UNITS then
			-- Nothing
		end
	end

	PLAYER_UNITS = get_side_from_name.PLAYER_AND_BOT_UNITS

	::label_5_0::

	local count = #PLAYER_UNITS
	local extension = ScriptUnit.extension
	local tbl = {}

	for k_2 = 1, count do
		local var_5_7 = PLAYER_UNITS[k_2]

		if var_5_1[var_5_7] ~= nil or not HEALTH_ALIVE[var_5_7] then
			local tbl_2 = {
				attacker_unit = var_5_7
			}

			tbl[var_5_7] = extension(var_5_7, "buff_system"):add_buff(arg_5_2, tbl_2)
		end

		var_5_1[var_5_7] = true
	end

	for k_3, v_2 in pairs(var_5_1) do
		if not v_2 then
			var_5_1[k_3] = nil
		end
	end

	return tbl
end

MutatorUtils.store_breed_and_action_settings = function (self, arg_6_1)
	-- function 6
	if not (self.original_breed_settings or self.original_breed_action_settings) then
		self.original_breed_settings = table.clone(Breeds)
		self.original_breed_action_settings = table.clone(BreedActions)
	end
end

MutatorUtils.restore_breed_and_action_settings = function (self, arg_7_1)
	-- function 7
	if not self.original_breed_settings and not self.original_breed_action_settings then
		Breeds = self.original_breed_settings
		BreedActions = self.original_breed_action_settings
		self.original_breed_settings = nil
		self.original_breed_action_settings = nil
	end
end

MutatorUtils.update_conflict_settings_horde_size_modifier = function (arg_8_0)
	-- function 8
	if not CurrentPacing.disabled then
		return
	end

	local compositions_pacing = CurrentHordeSettings.compositions_pacing
	local tbl = {}

	fn_3(compositions_pacing, CurrentHordeSettings.ambush_composition, tbl, arg_8_0)
	fn_3(compositions_pacing, CurrentHordeSettings.vector_composition, tbl, arg_8_0)
	fn_3(compositions_pacing, CurrentHordeSettings.vector_blob_composition, tbl, arg_8_0)
	fn_3(compositions_pacing, CurrentHordeSettings.mini_patrol_composition, tbl, arg_8_0)
end

MutatorUtils.update_conflict_settings_horde_frequency = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local CurrentPacing = CurrentPacing

	if not CurrentPacing.disabled then
		fn_4(CurrentPacing.horde_frequency, arg_9_0, "Changed horde frequency from ({%s, %s}) to ({%s, %s}), modifier: %s - original")
		fn_4(CurrentPacing.horde_startup_time, arg_9_1, "Changed horde startup time from ({%s, %s}) to ({%s, %s}), modifier: %s - original")
		fn_4(CurrentPacing.relax_duration, arg_9_2, "Changed relax duration from ({%s, %s}) to ({%s, %s}), modifier: %s - original")

		if not CurrentPacing.max_delay_until_next_horde then
			fn_4(CurrentPacing.max_delay_until_next_horde, arg_9_3, "Changed max_delay_until_next_horde from ({%s, %s}) to ({%s, %s}), modifier: %s - original")
		end
	end
end

MutatorUtils.tweak_pack_spawning_settings_convert_breeds = function (self, arg_10_1)
	-- function 10
	local breed_packs = self.roaming_set.breed_packs
	local roaming_set = self.roaming_set
	local var_10_2 = arg_10_1[breed_packs]

	var_10_2 = var_10_2 or breed_packs
	roaming_set.breed_packs = var_10_2

	for i, v in ipairs(self.roaming_set.breed_packs_override) do
		local var_10_3 = v[1]
		local var_10_4 = arg_10_1[var_10_3]

		var_10_4 = var_10_4 or var_10_3
		v[1] = var_10_4
	end

	if not self.difficulty_overrides then
		for k, v_2 in pairs(self.difficulty_overrides) do
			for i4 = 1, #v_2 do
				local var_10_5 = v_2[i4]
				local var_10_6 = var_10_5[1]
				local var_10_7 = arg_10_1[var_10_6]

				var_10_7 = var_10_7 or var_10_6
				var_10_5[1] = var_10_7
			end
		end
	end
end

MutatorUtils.tweak_pack_spawning_settings_density_multiplier = function (self, arg_11_1)
	-- function 11
	self.area_density_coefficient = self.area_density_coefficient * arg_11_1

	if not self.difficulty_overrides then
		for k, v in pairs(self.difficulty_overrides) do
			v.area_density_coefficient = v.area_density_coefficient * arg_11_1

			for k_2 = 1, #v do
				local var_11_0 = v[k_2]

				var_11_0[3] = var_11_0[3] * arg_11_1
			end
		end
	end
end

MutatorUtils.tweak_pack_spawning_settings_override_chance = function (arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	arg_12_0.roaming_set.breed_packs_peeks_overide_chance[1] = math.clamp(arg_12_1, 0, 1)
	arg_12_0.roaming_set.breed_packs_peeks_overide_chance[2] = math.clamp(arg_12_2, 0, 1)
end

MutatorUtils.update_conflict_settings_specials_frequency = function (arg_13_0, arg_13_1)
	-- function 13
	local CurrentSpecialsSettings = CurrentSpecialsSettings

	if not CurrentSpecialsSettings.disabled then
		if not CurrentSpecialsSettings.max_specials then
			local max_specials = CurrentSpecialsSettings.max_specials

			CurrentSpecialsSettings.max_specials = math.round(CurrentSpecialsSettings.max_specials * arg_13_0)
		end

		for k, v in pairs(CurrentSpecialsSettings.methods) do
			local flag = false

			if k == "specials_by_time_window" then
				local spawn_interval = v.spawn_interval

				spawn_interval[1] = spawn_interval[1] * arg_13_1
				spawn_interval[2] = spawn_interval[2] * arg_13_1
				flag = true

				local var_13_4 = spawn_interval[1]
				local var_13_5 = spawn_interval[2]
				local num = var_13_4 / arg_13_1
				local num_2 = var_13_5 / arg_13_1
			end

			if k == "specials_by_slots" then
				local spawn_cooldown = v.spawn_cooldown

				spawn_cooldown[1] = spawn_cooldown[1] * arg_13_1
				spawn_cooldown[2] = spawn_cooldown[2] * arg_13_1
				flag = true

				local var_13_9 = spawn_cooldown[1]
				local var_13_10 = spawn_cooldown[2]
				local num_3 = var_13_9 / arg_13_1
				local num_4 = var_13_10 / arg_13_1
			end

			fassert(flag, "MutatorUtils.update_conflict_settings_specials_frequency: Found new method_name (%s)", k)
		end
	end
end
