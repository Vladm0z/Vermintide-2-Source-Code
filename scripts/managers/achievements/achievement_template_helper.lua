-- chunkname: @scripts/managers/achievements/achievement_template_helper.lua

local AchievementTemplateHelper = AchievementTemplateHelper

AchievementTemplateHelper = AchievementTemplateHelper or {}
AchievementTemplateHelper = AchievementTemplateHelper
AchievementTemplateHelper.rarity_index = {
	common = 2,
	plentiful = 1,
	exotic = 4,
	rare = 3,
	unique = 5
}
AchievementTemplateHelper.PLACEHOLDER_ICON = "icons_placeholder"

AchievementTemplateHelper.check_level = function (self, arg_1_1, arg_1_2)
	-- function 1
	local get_persistent_stat = self:get_persistent_stat(arg_1_1, "completed_levels", arg_1_2)

	return not (not get_persistent_stat and get_persistent_stat == 0)
end

AchievementTemplateHelper.check_level_list = function (self, arg_2_1, arg_2_2)
	-- function 2
	assert(type(arg_2_2) ~= "table" or #arg_2_2 > 0, "levels_to_complete needs to be a list of levels with at least 1 element")

	for i = 1, #arg_2_2 do
		local var_2_0 = arg_2_2[i]
		local get_persistent_stat = self:get_persistent_stat(arg_2_1, "completed_levels", var_2_0)

		if not (not get_persistent_stat and get_persistent_stat ~= 0) then
			return false
		end
	end

	return true
end

AchievementTemplateHelper.rpc_increment_stat = function (arg_3_0, arg_3_1)
	-- function 3
	local unit_owner = Managers.player:unit_owner(arg_3_0)

	if not (not unit_owner and unit_owner.bot_player) then
		local network_id = unit_owner:network_id()
		local network = Managers.state.network
		local var_3_3 = NetworkLookup.statistics[arg_3_1]

		network.network_transmit:send_rpc("rpc_increment_stat", network_id, var_3_3)
	end
end

AchievementTemplateHelper.rpc_increment_stat_unique_id = function (arg_4_0, arg_4_1)
	-- function 4
	local player_from_unique_id = Managers.player:player_from_unique_id(arg_4_0)

	if not (not player_from_unique_id and player_from_unique_id.bot_player) then
		local network_id = player_from_unique_id:network_id()
		local network = Managers.state.network
		local var_4_3 = NetworkLookup.statistics[arg_4_1]

		network.network_transmit:send_rpc("rpc_increment_stat", network_id, var_4_3)
	end
end

AchievementTemplateHelper.rpc_modify_stat = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	local unit_owner = Managers.player:unit_owner(arg_5_0)

	if not (not unit_owner and unit_owner.bot_player) then
		local network_id = unit_owner:network_id()
		local network = Managers.state.network
		local var_5_3 = NetworkLookup.statistics[arg_5_1]

		network.network_transmit:send_rpc("rpc_modify_stat", network_id, var_5_3, arg_5_2)
	end
end

AchievementTemplateHelper.check_level_difficulty = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local difficulty = Managers.state.difficulty

	if not difficulty then
		return false
	end

	local get_default_difficulties = difficulty:get_default_difficulties()
	local var_6_2

	if not arg_6_4 then
		var_6_2 = LevelUnlockUtils.completed_level_difficulty_index(self, arg_6_1, arg_6_2)
	else
		for i = #get_default_difficulties, 1, -1 do
			if self:get_persistent_stat(arg_6_1, "completed_career_levels", arg_6_4, arg_6_2, get_default_difficulties[i]) > 0 then
				var_6_2 = i

				break
			end
		end
	end

	local var_6_3 = get_default_difficulties[var_6_2]

	if not var_6_3 then
		return false
	end

	if not DefaultDifficultyLookup[var_6_3] then
		return false
	end

	return arg_6_3 <= DifficultySettings[var_6_3].rank
end

AchievementTemplateHelper.check_level_table_difficulty = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	assert(type(arg_7_2) ~= "table" or arg_7_2.level_id, "level_to_complete needs to be a table with a level_id field")

	local level_id = arg_7_2.level_id

	return AchievementTemplateHelper.check_level_difficulty(arg_7_0, arg_7_1, level_id, arg_7_3, arg_7_4)
end

AchievementTemplateHelper.check_level_list_difficulty = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	assert(type(arg_8_2) ~= "table" or #arg_8_2 > 0, "levels_to_complete needs to be a list of levels with at least 1 element")

	local check_level_difficulty = AchievementTemplateHelper.check_level_difficulty

	for i = 1, #arg_8_2 do
		local var_8_1 = arg_8_2[i]

		if not check_level_difficulty(arg_8_0, arg_8_1, var_8_1, arg_8_3, arg_8_4) then
			return false
		end
	end

	return true
end

AchievementTemplateHelper.hero_level = function (arg_9_0)
	-- function 9
	local get_experience = ExperienceSettings.get_experience(arg_9_0)

	return ExperienceSettings.get_level(get_experience)
end

local tbl = {
	"melee",
	"ranged",
	"necklace",
	"ring",
	"trinket"
}

AchievementTemplateHelper.equipped_items_of_rarity = function (self, arg_10_1, arg_10_2)
	-- function 10
	local var_10_0 = AchievementTemplateHelper.rarity_index[arg_10_2]

	assert(var_10_0, "Invalid rarity %s", arg_10_2)

	local num = 0

	for i, v in ipairs(tbl) do
		if var_10_0 <= self:get_persistent_stat(arg_10_1, "highest_equipped_rarity", v) then
			num = num + 1
		end
	end

	return num
end

AchievementTemplateHelper.add_stat_count_challenge = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8)
	-- function 11
	self[arg_11_1] = {
		display_completion_ui = true,
		name = "achv_" .. arg_11_1 .. "_name",
		desc = function ()
			-- function 12
			local str = "achv_" .. arg_11_1 .. "_desc"

			return string.format(Localize(str), arg_11_3)
		end,
		icon = arg_11_5 or "achievement_trophy_" .. arg_11_1,
		required_dlc = arg_11_6,
		ID_XB1 = arg_11_7,
		ID_PS4 = arg_11_8,
		completed = function (self, arg_13_1)
			-- function 13
			if not arg_11_4 then
				return self:get_persistent_stat(arg_13_1, arg_11_2, arg_11_4) >= arg_11_3
			else
				return self:get_persistent_stat(arg_13_1, arg_11_2) >= arg_11_3
			end
		end,
		progress = function (self, arg_14_1)
			-- function 14
			if not arg_11_4 then
				local get_persistent_stat = self:get_persistent_stat(arg_14_1, arg_11_2, arg_11_4)

				return {
					get_persistent_stat,
					arg_11_3
				}
			else
				local get_persistent_stat_2 = self:get_persistent_stat(arg_14_1, arg_11_2)

				return {
					get_persistent_stat_2,
					arg_11_3
				}
			end
		end
	}
end

AchievementTemplateHelper.add_health_challenge = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7)
	-- function 15
	self[arg_15_1] = {
		display_completion_ui = true,
		name = "achv_" .. arg_15_1 .. "_name",
		desc = "achv_" .. arg_15_1 .. "_desc",
		icon = arg_15_4 or "achievement_trophy_" .. arg_15_1,
		required_dlc = arg_15_5,
		ID_XB1 = arg_15_6,
		ID_PS4 = arg_15_7,
		completed = function (self, arg_16_1)
			-- function 16
			return self:get_persistent_stat(arg_16_1, "min_health_completed", arg_15_2) >= arg_15_3
		end
	}
end

AchievementTemplateHelper.add_weapon_kills_per_breeds_challenge = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9)
	-- function 17
	assert(type(arg_17_3) == "table", "breeds_to_kill needs to be a list of breeds")

	self[arg_17_1] = {
		name = "achv_" .. arg_17_1 .. "_name",
		desc = function ()
			-- function 18
			local str = "achv_" .. arg_17_1 .. "_desc"

			return string.format(Localize(str), arg_17_4)
		end,
		icon = arg_17_5 or "achievement_trophy_" .. arg_17_1,
		required_dlc = arg_17_6,
		ID_XB1 = arg_17_8,
		ID_PS4 = arg_17_9,
		display_completion_ui = arg_17_7,
		completed = function (self, arg_19_1)
			-- function 19
			local str = "weapon_kills_per_breed"
			local num = 0

			for i = 1, #arg_17_3 do
				for j = 1, #arg_17_2 do
					num = num + self:get_persistent_stat(arg_19_1, str, arg_17_2[j], arg_17_3[i])
				end
			end

			return num >= arg_17_4
		end,
		progress = function (self, arg_20_1)
			-- function 20
			local str = "weapon_kills_per_breed"
			local num = 0

			for i = 1, #arg_17_3 do
				for j = 1, #arg_17_2 do
					num = num + self:get_persistent_stat(arg_20_1, str, arg_17_2[j], arg_17_3[i])
				end
			end

			if num > arg_17_4 then
				num = arg_17_4
			end

			return {
				num,
				arg_17_4
			}
		end
	}
end

AchievementTemplateHelper.add_career_mission_count_challenge = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7, arg_21_8, arg_21_9, arg_21_10)
	-- function 21
	self[arg_21_1 .. "_" .. arg_21_3] = {
		display_completion_ui = true,
		name = "achv_" .. arg_21_1 .. "_" .. arg_21_3 .. "_name",
		desc = "achv_" .. arg_21_1 .. "_" .. arg_21_3 .. "_desc",
		icon = arg_21_7 or "achievement_trophy_" .. arg_21_1 .. "_" .. arg_21_3,
		required_dlc = arg_21_8,
		ID_XB1 = arg_21_9,
		ID_PS4 = arg_21_10,
		completed = function (self, arg_22_1)
			-- function 22
			local num = 0

			for i = 1, #arg_21_4 do
				for j = 1, #UnlockableLevels do
					num = num + self:get_persistent_stat(arg_22_1, arg_21_2, arg_21_3, UnlockableLevels[j], arg_21_4[i])
				end
			end

			return num >= arg_21_5
		end,
		progress = function (self, arg_23_1)
			-- function 23
			local num = 0

			for i = 1, #arg_21_4 do
				for j = 1, #UnlockableLevels do
					num = num + self:get_persistent_stat(arg_23_1, arg_21_2, arg_21_3, UnlockableLevels[j], arg_21_4[i])
				end
			end

			if num > arg_21_5 then
				num = arg_21_5
			end

			return {
				num,
				arg_21_5
			}
		end
	}
end

AchievementTemplateHelper.add_multi_stat_count_challenge = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6, arg_24_7)
	-- function 24
	self[arg_24_1] = {
		display_completion_ui = true,
		name = "achv_" .. arg_24_1 .. "_name",
		desc = "achv_" .. arg_24_1 .. "_desc",
		icon = arg_24_4 or "achievement_trophy_" .. arg_24_1,
		required_dlc = arg_24_5,
		ID_XB1 = arg_24_6,
		ID_PS4 = arg_24_7,
		completed = function (self, arg_25_1)
			-- function 25
			local num = 0
			local count = #arg_24_2

			for i = 1, count do
				num = num + self:get_persistent_stat(arg_25_1, arg_24_2[i])
			end

			return num >= arg_24_3
		end,
		progress = function (self, arg_26_1)
			-- function 26
			local num = 0
			local count = #arg_24_2

			for i = 1, count do
				num = num + self:get_persistent_stat(arg_26_1, arg_24_2[i])
			end

			if num > arg_24_3 then
				num = arg_24_3
			end

			return {
				num,
				arg_24_3
			}
		end
	}
end

AchievementTemplateHelper.add_weapon_kill_challenge = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6, arg_27_7)
	-- function 27
	local str = (arg_27_5 or "") .. "_kills_" .. arg_27_2

	AchievementTemplateHelper.add_stat_count_challenge(arg_27_0, arg_27_1, str, arg_27_3, nil, arg_27_4, arg_27_5, arg_27_6, arg_27_7)
end

AchievementTemplateHelper.add_weapon_levels_challenge = function (self, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6, arg_28_7, arg_28_8)
	-- function 28
	local tbl = {}
	local count

	if not arg_28_3 then
		count = #arg_28_3

		if not count then
			-- Nothing
		end
	end

	count = 0

	::label_28_0::

	for i = 1, count do
		local var_28_2 = arg_28_3[i]

		tbl[i] = (arg_28_6 or "") .. "_" .. var_28_2 .. "_" .. arg_28_2
	end

	local var_28_3 = DifficultySettings[arg_28_4]
	local rank = DifficultySettings[arg_28_4].rank

	self[arg_28_1] = {
		name = "achv_" .. arg_28_1 .. "_name",
		desc = "achv_" .. arg_28_1 .. "_desc",
		icon = arg_28_5 or "achievement_trophy_" .. arg_28_1,
		required_dlc = arg_28_6,
		required_dlc_extra = var_28_3.dlc_requirement,
		ID_XB1 = arg_28_7,
		ID_PS4 = arg_28_8,
		completed = function (self, arg_29_1)
			-- function 29
			for i = 1, count do
				if self:get_persistent_stat(arg_29_1, tbl[i]) < rank then
					return false
				end
			end

			return true
		end,
		progress = function (self, arg_30_1)
			-- function 30
			local num = 0

			for i = 1, count do
				local var_30_1 = tbl[i]

				if self:get_persistent_stat(arg_30_1, var_30_1) >= rank then
					num = num + 1
				end
			end

			return {
				num,
				count
			}
		end,
		requirements = function (self, arg_31_1)
			-- function 31
			local tbl_2 = {}

			for i = 1, count do
				local var_31_1 = arg_28_3[i]
				local display_name = LevelSettings[var_31_1].display_name
				local tbl_3 = {
					name = display_name,
					completed = self:get_persistent_stat(arg_31_1, tbl[i]) >= rank
				}

				table.insert(tbl_2, tbl_3)
			end

			return tbl_2
		end
	}
end

AchievementTemplateHelper.add_event_challenge = function (self, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6)
	-- function 32
	local tbl = {
		display_completion_ui = true,
		name = "achv_" .. arg_32_1 .. "_name",
		icon = arg_32_2 or "achievement_trophy_" .. arg_32_1,
		required_dlc = arg_32_4,
		ID_XB1 = arg_32_5,
		ID_PS4 = arg_32_6,
		completed = function (self, arg_33_1)
			-- function 33
			return self:get_persistent_stat(arg_33_1, arg_32_1) > 0
		end
	}
	local str = "achv_" .. arg_32_1 .. "_desc"

	if not arg_32_3 then
		tbl.desc = function ()
			-- function 34
			return string.format(Localize(str), unpack(arg_32_3))
		end
	else
		tbl.desc = str
	end

	self[arg_32_1] = tbl
end

AchievementTemplateHelper.add_levels_complete_challenge = function (self, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5, arg_35_6, arg_35_7)
	-- function 35
	local count

	if not arg_35_2 then
		count = #arg_35_2

		if not count then
			-- Nothing
		end
	end

	count = 0

	::label_35_0::

	local var_35_1 = DifficultyRankLookup[arg_35_3]
	local var_35_2 = DifficultySettings[var_35_1]
	local tbl = {
		name = "achv_" .. arg_35_1 .. "_name",
		desc = "achv_" .. arg_35_1 .. "_desc",
		icon = arg_35_4 or "achievement_trophy_" .. arg_35_1,
		required_dlc = arg_35_5,
		required_dlc_extra = var_35_2.dlc_requirement,
		ID_XB1 = arg_35_6,
		ID_PS4 = arg_35_7,
		completed = function (arg_36_0, arg_36_1)
			-- function 36
			local num = 0

			for i = 1, count do
				if not AchievementTemplateHelper.check_level_table_difficulty(arg_36_0, arg_36_1, arg_35_2[i], arg_35_3) then
					num = num + 1
				end
			end

			return num >= count
		end
	}

	if count > 1 then
		tbl.progress = function (arg_37_0, arg_37_1)
			-- function 37
			local num = 0

			for i = 1, count do
				if not AchievementTemplateHelper.check_level_table_difficulty(arg_37_0, arg_37_1, arg_35_2[i], arg_35_3) then
					num = num + 1
				end
			end

			return {
				num,
				count
			}
		end

		tbl.requirements = function (arg_38_0, arg_38_1)
			-- function 38
			local tbl = {}

			for i = 1, count do
				local tbl_2 = {
					name = arg_35_2[i].display_name,
					completed = AchievementTemplateHelper.check_level_table_difficulty(arg_38_0, arg_38_1, arg_35_2[i], arg_35_3)
				}

				table.insert(tbl, tbl_2)
			end

			return tbl
		end
	end

	self[arg_35_1] = tbl
end

AchievementTemplateHelper.add_levels_complete_per_hero_challenge = function (self, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6, arg_39_7, arg_39_8, arg_39_9)
	-- function 39
	fassert(CareerSettings[arg_39_4] ~= nil, "No career with such name (%s)", arg_39_4)

	local count

	if not arg_39_2 then
		count = #arg_39_2

		if not count then
			-- Nothing
		end
	end

	count = 0

	::label_39_0::

	local var_39_1 = DifficultyRankLookup[arg_39_3]
	local var_39_2 = DifficultySettings[var_39_1]
	local tbl = {
		name = "achv_" .. arg_39_1 .. "_" .. arg_39_4 .. "_name",
		desc = "achv_" .. arg_39_1 .. "_" .. arg_39_4 .. "_desc",
		icon = arg_39_6 or "achievement_trophy_" .. arg_39_1 .. "_" .. arg_39_4,
		required_dlc = arg_39_7,
		required_dlc_extra = var_39_2.dlc_requirement,
		ID_XB1 = arg_39_8,
		ID_PS4 = arg_39_9,
		completed = function (arg_40_0, arg_40_1)
			-- function 40
			return AchievementTemplateHelper.check_level_list_difficulty(arg_40_0, arg_40_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5)
		end
	}

	if count > 1 then
		tbl.progress = function (arg_41_0, arg_41_1)
			-- function 41
			local num = 0

			for i = 1, count do
				if not AchievementTemplateHelper.check_level_list_difficulty(arg_41_0, arg_41_1, {
					arg_39_2[i]
				}, arg_39_3, arg_39_4, arg_39_5) then
					num = num + 1
				end
			end

			return {
				num,
				count
			}
		end

		tbl.requirements = function (arg_42_0, arg_42_1)
			-- function 42
			local tbl = {}

			for i = 1, count do
				local tbl_2 = {
					name = LevelSettings[arg_39_2[i]].display_name,
					completed = AchievementTemplateHelper.check_level_list_difficulty(arg_42_0, arg_42_1, {
						arg_39_2[i]
					}, arg_39_3, arg_39_4, arg_39_5)
				}

				table.insert(tbl, tbl_2)
			end

			return tbl
		end
	end

	self[arg_39_1 .. "_" .. arg_39_4] = tbl
end

AchievementTemplateHelper.add_meta_challenge = function (self, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5, arg_43_6)
	-- function 43
	self[arg_43_1] = {
		display_completion_ui = true,
		name = "achv_" .. arg_43_1 .. "_name",
		desc = "achv_" .. arg_43_1 .. "_desc",
		icon = arg_43_3 or "achievement_trophy_" .. arg_43_1,
		required_dlc = arg_43_4,
		ID_XB1 = arg_43_5,
		ID_PS4 = arg_43_6,
		completed = function (arg_44_0, arg_44_1)
			-- function 44
			local get_interface = Managers.backend:get_interface("loot")

			for i = 1, #arg_43_2 do
				local var_44_1 = arg_43_2[i]

				if not (self[var_44_1].completed(arg_44_0, arg_44_1) or get_interface:achievement_rewards_claimed(var_44_1)) then
					return false
				end
			end

			return true
		end,
		progress = function (arg_45_0, arg_45_1)
			-- function 45
			local get_interface = Managers.backend:get_interface("loot")
			local num = 0
			local count = #arg_43_2

			for i = 1, count do
				local var_45_3 = arg_43_2[i]
				local completed = self[var_45_3].completed(arg_45_0, arg_45_1)

				completed = completed or get_interface:achievement_rewards_claimed(var_45_3)

				if not completed then
					num = num + 1
				end
			end

			return {
				num,
				count
			}
		end,
		requirements = function (arg_46_0, arg_46_1)
			-- function 46
			local get_interface = Managers.backend:get_interface("loot")
			local tbl = {}

			for i = 1, #arg_43_2 do
				local var_46_2 = arg_43_2[i]
				local name = self[var_46_2].name
				local completed = self[var_46_2].completed(arg_46_0, arg_46_1)

				completed = completed or get_interface:achievement_rewards_claimed(var_46_2)

				table.insert(tbl, {
					name = name,
					completed = completed
				})
			end

			return tbl
		end
	}
end

AchievementTemplateHelper.add_console_achievements = function (arg_47_0, arg_47_1)
	-- function 47
	local achievements = AchievementTemplates.achievements

	for k, v in pairs(arg_47_0) do
		if not achievements[k] then
			achievements[k].ID_XB1 = v
		else
			Application.error(string.format("Missing xbox achievement %q", k))
		end
	end

	for k_2, v_2 in pairs(arg_47_1) do
		if not achievements[k_2] then
			achievements[k_2].ID_PS4 = v_2
		else
			Application.error(string.format("Missing xbox achievement %q", k_2))
		end
	end
end
