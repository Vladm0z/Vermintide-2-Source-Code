-- chunkname: @scripts/managers/backend_playfab/backend_interface_talents_playfab.lua

BackendInterfaceTalentsPlayfab = class(BackendInterfaceTalentsPlayfab)

BackendInterfaceTalentsPlayfab.init = function (self, arg_1_1)
	-- function 1
	self._backend_mirror = arg_1_1
	self._talents = {}
	self._default_loadouts_talents = {}
	self._career_loadouts_talents = {}
	self._default_talents_overrides = {}
	self._selected_career_custom_talents = {}
	self._bot_talents = {}

	self:_refresh()
end

BackendInterfaceTalentsPlayfab._refresh = function (self)
	-- function 2
	if not DEDICATED_SERVER then
		self:_refresh_default_loadouts_talents()
		self:_refresh_career_loadouts_talents()
		self:_setup_default_overrides()
	end

	self:_refresh_talents()

	if not DEDICATED_SERVER then
		self:refresh_bot_talents()
	end
end

BackendInterfaceTalentsPlayfab._refresh_talents = function (self)
	-- function 3
	local _talents = self._talents
	local _backend_mirror = self._backend_mirror

	for k, v in pairs(CareerSettings) do
		if not v.playfab_name then
			local get_character_data = _backend_mirror:get_character_data(k, "talents")

			if not get_character_data then
				local split_deprecated = string.split_deprecated(get_character_data, ",")

				for k_2 = 1, #split_deprecated do
					split_deprecated[k_2] = tonumber(split_deprecated[k_2])
				end

				self:_validate_talents(k, split_deprecated, v.talent_tree_index)

				_talents[k] = split_deprecated
			end
		end
	end

	self._dirty = false
end

local tbl = {}

BackendInterfaceTalentsPlayfab.refresh_bot_talents = function (self)
	-- function 4
	self._bot_talents = table.clone(self._talents)

	local _bot_talents = self._bot_talents
	local _backend_mirror = self._backend_mirror
	local loadout_selection = PlayerData.loadout_selection

	loadout_selection = loadout_selection or tbl

	local bot_equipment = loadout_selection.bot_equipment

	bot_equipment = bot_equipment or tbl

	local current_mechanism_name = Managers.mechanism:current_mechanism_name()
	local var_4_5 = InventorySettings.bot_loadout_allowed_mechanisms[current_mechanism_name]

	for k, v in pairs(CareerSettings) do
		if not v.playfab_name then
			local flag = not var_4_5 and bot_equipment[k]

			if not flag then
				local get_character_data = _backend_mirror:get_character_data(k, "talents", flag)

				if not get_character_data then
					local split_deprecated = string.split_deprecated(get_character_data, ",")

					for k_2 = 1, #split_deprecated do
						split_deprecated[k_2] = tonumber(split_deprecated[k_2])
					end

					self:_validate_talents(k, split_deprecated, v.talent_tree_index, flag)

					_bot_talents[k] = split_deprecated
				end
			end
		end
	end

	print("[BackendInterfaceItemPlayfab] Refreshing bot loadout")
end

BackendInterfaceTalentsPlayfab._refresh_default_loadouts_talents = function (self)
	-- function 5
	local _default_loadouts_talents = self._default_loadouts_talents
	local _backend_mirror = self._backend_mirror
	local flag = true

	table.clear(_default_loadouts_talents)

	for k, v in pairs(CareerSettings) do
		if not v.playfab_name then
			local get_default_loadouts = _backend_mirror:get_default_loadouts(k)
			local var_5_4 = _default_loadouts_talents[k]

			var_5_4 = var_5_4 or {}
			_default_loadouts_talents[k] = var_5_4

			if not get_default_loadouts then
				local var_5_5 = _default_loadouts_talents[k]

				for k_2 = 1, #get_default_loadouts do
					local talents = get_default_loadouts[k_2].talents

					if not talents then
						local split_deprecated = string.split_deprecated(talents, ",")

						for l = 1, #split_deprecated do
							split_deprecated[l] = tonumber(split_deprecated[l])
						end

						self:_validate_talents(k, split_deprecated, v.talent_tree_index, flag)

						var_5_5[k_2] = split_deprecated
					else
						var_5_5[k_2] = {
							0,
							0,
							0,
							0,
							0,
							0
						}
					end
				end
			end
		end
	end

	self._dirty = false
end

BackendInterfaceTalentsPlayfab._refresh_career_loadouts_talents = function (self)
	-- function 6
	local _career_loadouts_talents = self._career_loadouts_talents
	local _backend_mirror = self._backend_mirror
	local flag = true

	table.clear(_career_loadouts_talents)

	for k, v in pairs(CareerSettings) do
		if not v.playfab_name then
			local get_career_loadouts, var_6_4 = _backend_mirror:get_career_loadouts(k)

			self._selected_career_custom_talents[k] = get_career_loadouts

			if not var_6_4 then
				local var_6_5 = _career_loadouts_talents[k]

				var_6_5 = var_6_5 or {}
				_career_loadouts_talents[k] = var_6_5

				local var_6_6 = _career_loadouts_talents[k]

				for k_2 = 1, #var_6_4 do
					local talents = var_6_4[k_2].talents

					if not talents then
						local split_deprecated = string.split_deprecated(talents, ",")

						for l = 1, #split_deprecated do
							split_deprecated[l] = tonumber(split_deprecated[l])
						end

						self:_validate_talents(k, split_deprecated, v.talent_tree_index, flag)

						var_6_6[k_2] = split_deprecated
					else
						var_6_6[k_2] = {
							0,
							0,
							0,
							0,
							0,
							0
						}
					end
				end
			end
		end
	end

	self._dirty = false
end

BackendInterfaceTalentsPlayfab._setup_default_overrides = function (self)
	-- function 7
	local current_mechanism_name = Managers.mechanism:current_mechanism_name()
	local var_7_1

	if not PlayerData.loadout_selection then
		var_7_1 = PlayerData.loadout_selection[current_mechanism_name]

		if not var_7_1 then
			-- Nothing
		end
	end

	var_7_1 = {}

	::label_7_0::

	table.clear(self._default_talents_overrides)

	if not var_7_1 then
		return
	end

	local game_mode = Managers.state.game_mode

	game_mode = not game_mode and Managers.state.game_mode:game_mode_key()

	if not (not game_mode and InventorySettings.default_loadout_allowed_game_modes[game_mode]) then
		return
	end

	for k, v in pairs(CareerSettings) do
		local var_7_3 = var_7_1[k]

		var_7_3 = var_7_3 or 1

		if not (not var_7_3 and InventorySettings.loadouts[var_7_3].loadout_type ~= "default") then
			self:set_default_override(k, var_7_3)
		end
	end
end

BackendInterfaceTalentsPlayfab.set_default_override = function (self, arg_8_1, arg_8_2)
	-- function 8
	local var_8_0 = self._default_loadouts_talents[arg_8_1]

	self._default_talents_overrides[arg_8_1] = not var_8_0 and var_8_0[arg_8_2]
end

BackendInterfaceTalentsPlayfab._validate_talents = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	-- function 9
	local var_9_0 = PROFILES_BY_CAREER_NAMES[arg_9_1]

	if not var_9_0 then
		return
	end

	local display_name = var_9_0.display_name
	local get_read_only_data = self._backend_mirror:get_read_only_data(display_name .. "_experience")
	local get_level = ExperienceSettings.get_level(get_read_only_data)
	local get_talent_overrides_by_career = PlayerUtils.get_talent_overrides_by_career(arg_9_1)
	local var_9_5 = TalentTrees[display_name]
	local flag = not var_9_5 and var_9_5[arg_9_3]
	local flag_2 = false

	for i = 1, #arg_9_2 do
		local var_9_8 = arg_9_2[i]

		if var_9_8 > 0 then
			if not ProgressionUnlocks.is_unlocked("talent_point_" .. i, get_level) then
				arg_9_2[i] = 0
				flag_2 = true
			elseif not (not get_talent_overrides_by_career and not flag and get_talent_overrides_by_career[flag[i][var_9_8]] ~= false) then
				arg_9_2[i] = 0
				flag_2 = true
			end
		end
	end

	if not (not flag_2 and arg_9_4) then
		self:set_talents(arg_9_1, arg_9_2, arg_9_5)
	end
end

BackendInterfaceTalentsPlayfab.ready = function (arg_10_0)
	-- function 10
	return true
end

BackendInterfaceTalentsPlayfab.update = function (arg_11_0, arg_11_1)
	-- function 11
	return
end

BackendInterfaceTalentsPlayfab.make_dirty = function (self)
	-- function 12
	self._dirty = true
end

BackendInterfaceTalentsPlayfab.get_talent_ids = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local var_13_0 = CareerSettings[arg_13_1]
	local profile_name = var_13_0.profile_name
	local talent_tree_index = var_13_0.talent_tree_index
	local flag = not talent_tree_index and TalentTrees[profile_name][talent_tree_index]
	local tbl = {}
	local game_mode = Managers.state.game_mode

	game_mode = not game_mode and Managers.state.game_mode:game_mode_key()

	local var_13_6 = InventorySettings.bot_loadout_allowed_game_modes[game_mode]
	local var_13_7 = InventorySettings.default_loadout_allowed_game_modes[game_mode]
	local flag_2 = not var_13_6 and self:get_bot_talents(arg_13_1)
	local flag_3 = not var_13_7 and self:get_default_talents(arg_13_1)
	local flag_4 = not var_13_7 and not flag_3 and flag_3[1]
	local get_talents = self:get_talents(arg_13_1)
	local flag_5 = not var_13_6 and not arg_13_3 and flag_2 and not arg_13_3 or not var_13_7 and flag_4 and arg_13_2 or get_talents

	if not flag_5 then
		for i = 1, #flag_5 do
			local var_13_13 = flag_5[i]

			if var_13_13 ~= 0 then
				local var_13_14 = flag[i][var_13_13]
				local var_13_15 = TalentIDLookup[var_13_14]

				if not var_13_15 and not var_13_15.talent_id then
					tbl[#tbl + 1] = var_13_15.talent_id
				end
			end
		end
	end

	return tbl
end

BackendInterfaceTalentsPlayfab.get_talent_tree = function (arg_14_0, arg_14_1)
	-- function 14
	local var_14_0 = CareerSettings[arg_14_1]
	local profile_name = var_14_0.profile_name
	local talent_tree_index = var_14_0.talent_tree_index

	return not talent_tree_index and TalentTrees[profile_name][talent_tree_index]
end

BackendInterfaceTalentsPlayfab.set_talents = function (self, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	local str = ""

	for i = 1, #arg_15_2 do
		local var_15_1 = arg_15_2[i]

		if i == #arg_15_2 then
			str = str .. var_15_1
		else
			str = str .. var_15_1 .. ","
		end
	end

	self._backend_mirror:set_character_data(arg_15_1, "talents", str, false, arg_15_3)

	self._dirty = true
end

BackendInterfaceTalentsPlayfab.get_talents = function (self, arg_16_1)
	-- function 16
	if not self._dirty then
		self:_refresh()
	end

	local clone = table.clone(self._talents)

	for k, v in pairs(self._default_talents_overrides) do
		clone[k] = v
	end

	return clone[arg_16_1]
end

BackendInterfaceTalentsPlayfab.get_bot_talents = function (self, arg_17_1)
	-- function 17
	if not self._dirty then
		self:_refresh()
	end

	return self._bot_talents[arg_17_1]
end

BackendInterfaceTalentsPlayfab.get_default_talents = function (self, arg_18_1)
	-- function 18
	if not self._dirty then
		self:_refresh()
	end

	return self._default_loadouts_talents[arg_18_1]
end

BackendInterfaceTalentsPlayfab.get_career_talents = function (self, arg_19_1)
	-- function 19
	if not self._dirty then
		self:_refresh()
	end

	return self._career_loadouts_talents[arg_19_1]
end

BackendInterfaceTalentsPlayfab.get_career_talent_ids = function (self, arg_20_1, arg_20_2)
	-- function 20
	local var_20_0 = CareerSettings[arg_20_1]
	local profile_name = var_20_0.profile_name
	local talent_tree_index = var_20_0.talent_tree_index
	local flag = not talent_tree_index and TalentTrees[profile_name][talent_tree_index]
	local tbl = {}
	local var_20_5 = self:get_career_talents(arg_20_1)[arg_20_2]

	if not var_20_5 then
		for i = 1, #var_20_5 do
			local var_20_6 = var_20_5[i]

			if var_20_6 ~= 0 then
				local var_20_7 = flag[i][var_20_6]
				local var_20_8 = TalentIDLookup[var_20_7]

				if not var_20_8 and not var_20_8.talent_id then
					tbl[#tbl + 1] = var_20_8.talent_id
				end
			end
		end
	end

	return tbl
end
