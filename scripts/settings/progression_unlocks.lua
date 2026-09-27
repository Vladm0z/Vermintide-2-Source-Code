-- chunkname: @scripts/settings/progression_unlocks.lua

local tbl = {}

for k, v in pairs(TalentUnlockLevels) do
	if not Development.parameter("debug_unlock_talents") then
		v = 0
	end

	tbl[k] = {
		description = "reward_talent_point",
		value = "options_button_icon_talents_glow",
		unlock_type = "icon",
		level_requirement = v,
		mechanism_overrides = {
			versus = {
				level_requirement = 0
			}
		}
	}
end

tbl.es_mercenary = {
	description = "end_screen_career_unlocked",
	profile = "empire_soldier",
	value = "es_mercenary",
	title = "es_mercenary",
	level_requirement = 0,
	unlock_type = "career"
}
tbl.es_huntsman = {
	description = "end_screen_career_unlocked",
	profile = "empire_soldier",
	value = "es_huntsman",
	title = "es_huntsman",
	level_requirement = 7,
	unlock_type = "career"
}
tbl.es_knight = {
	description = "end_screen_career_unlocked",
	profile = "empire_soldier",
	value = "es_knight",
	title = "es_knight",
	level_requirement = 12,
	unlock_type = "career"
}
tbl.dr_ranger = {
	description = "n/a",
	profile = "dwarf_ranger",
	value = "dr_ranger",
	title = "dr_ranger",
	level_requirement = 0,
	unlock_type = "career"
}
tbl.dr_ironbreaker = {
	description = "end_screen_career_unlocked",
	profile = "dwarf_ranger",
	value = "dr_ironbreaker",
	title = "dr_ironbreaker",
	level_requirement = 7,
	unlock_type = "career"
}
tbl.dr_slayer = {
	description = "end_screen_career_unlocked",
	profile = "dwarf_ranger",
	value = "dr_slayer",
	title = "dr_slayer",
	level_requirement = 12,
	unlock_type = "career"
}
tbl.wh_captain = {
	description = "end_screen_career_unlocked",
	profile = "witch_hunter",
	value = "wh_captain",
	title = "wh_captain",
	level_requirement = 0,
	unlock_type = "career"
}
tbl.wh_bountyhunter = {
	description = "end_screen_career_unlocked",
	profile = "witch_hunter",
	value = "wh_bountyhunter",
	title = "wh_bountyhunter",
	level_requirement = 7,
	unlock_type = "career"
}
tbl.wh_zealot = {
	description = "end_screen_career_unlocked",
	profile = "witch_hunter",
	value = "wh_zealot",
	title = "wh_zealot",
	level_requirement = 12,
	unlock_type = "career"
}
tbl.we_waywatcher = {
	description = "end_screen_career_unlocked",
	profile = "wood_elf",
	value = "we_waywatcher",
	title = "we_waywatcher",
	level_requirement = 0,
	unlock_type = "career"
}
tbl.we_maidenguard = {
	description = "end_screen_career_unlocked",
	profile = "wood_elf",
	value = "we_maidenguard",
	title = "we_maidenguard",
	level_requirement = 7,
	unlock_type = "career"
}
tbl.we_shade = {
	description = "end_screen_career_unlocked",
	profile = "wood_elf",
	value = "we_shade",
	title = "we_shade",
	level_requirement = 12,
	unlock_type = "career"
}
tbl.bw_adept = {
	description = "end_screen_career_unlocked",
	profile = "bright_wizard",
	value = "bw_adept",
	title = "bw_adept",
	level_requirement = 0,
	unlock_type = "career"
}
tbl.bw_scholar = {
	description = "end_screen_career_unlocked",
	profile = "bright_wizard",
	value = "bw_scholar",
	title = "bw_scholar",
	level_requirement = 7,
	unlock_type = "career"
}
tbl.bw_unchained = {
	description = "end_screen_career_unlocked",
	profile = "bright_wizard",
	value = "bw_unchained",
	title = "bw_unchained",
	level_requirement = 12,
	unlock_type = "career"
}

DLCUtils.merge("progression_unlocks", tbl)

for k_2, v_2 in pairs(tbl) do
	v_2.name = k_2
end

local tbl_2 = {}

for k_3, v_3 in pairs(tbl) do
	local profile = v_3.profile

	if profile ~= nil then
		if tbl_2[profile] == nil then
			tbl_2[profile] = {}
		end

		tbl_2[profile][v_3.name] = v_3
	end
end

ProgressionUnlocks = {}
ProgressionUnlocks.all_unlocks_for_debug = tbl

ProgressionUnlocks.get_unlock = function (arg_1_0, arg_1_1)
	-- function 1
	return MechanismOverrides.get(tbl)[arg_1_0]
end

ProgressionUnlocks.get_profile_unlock = function (arg_2_0, arg_2_1)
	-- function 2
	return MechanismOverrides.get(tbl_2)[arg_2_1][arg_2_0]
end

ProgressionUnlocks.is_unlocked = function (arg_3_0, arg_3_1)
	-- function 3
	local var_3_0 = MechanismOverrides.get(tbl)[arg_3_0]

	fassert(var_3_0, "[ProgressionUnlocks] no template named %q", tostring(arg_3_0))

	if not (var_3_0.disabled or not (arg_3_1 >= var_3_0.level_requirement)) then
		return true
	end
end

ProgressionUnlocks.get_level_unlocks = function (arg_4_0, arg_4_1)
	-- function 4
	local tbl_2 = {}
	local get = MechanismOverrides.get(tbl)

	for k, v in pairs(get) do
		if not (not v.profile and v.profile ~= arg_4_1 and v.level_requirement ~= arg_4_0) then
			tbl_2[#tbl_2 + 1] = v
		end
	end

	return tbl_2
end

ProgressionUnlocks.is_unlocked_for_profile = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	if not Development.parameter("unlock_all_careers") then
		return true
	end

	local var_5_0 = MechanismOverrides.get(tbl_2)[arg_5_1]

	fassert(var_5_0, "No unlocks found for profile %s", arg_5_1)

	local get = MechanismOverrides.get(tbl)
	local var_5_2 = var_5_0[arg_5_0]

	if var_5_2 == nil then
		return true
	end

	if arg_5_2 < var_5_2.level_requirement then
		local flag = true
		local var_5_4

		return false, Localize("career_locked_info") .. " " .. tostring(var_5_2.level_requirement), var_5_4, flag
	end

	return true
end

ProgressionUnlocks.get_quests_unlocked = function (arg_6_0)
	-- function 6
	if not (LevelSettings[arg_6_0].dlc_name or table.contains(MainGameLevels, arg_6_0)) then
		return
	end

	local statistics_db = Managers.player:statistics_db()
	local stats_id = Managers.player:local_player():stats_id()
	local flag = true

	for k, v in pairs(GameActs) do
		local count = #v

		for k_2 = 1, count do
			local var_6_4 = v[k_2]
			local get_persistent_stat = statistics_db:get_persistent_stat(stats_id, "completed_levels", var_6_4)

			if not (get_persistent_stat == 0 or arg_6_0 ~= var_6_4 or not (get_persistent_stat > 1)) then
				flag = false

				break
			end
		end

		if not flag then
			break
		end
	end

	if not flag then
		return MechanismOverrides.get(tbl).quests
	end
end

local tbl_3 = {
	witch_hunter = {
		"frame_0001",
		"frame_0002",
		"frame_0003",
		"frame_0004",
		"frame_0005",
		"frame_0006"
	},
	bright_wizard = {
		"frame_0001",
		"frame_0002",
		"frame_0003",
		"frame_0004",
		"frame_0005",
		"frame_0006"
	},
	dwarf_ranger = {
		"frame_0001",
		"frame_0002",
		"frame_0003",
		"frame_0004",
		"frame_0005",
		"frame_0006"
	},
	wood_elf = {
		"frame_0001",
		"frame_0002",
		"frame_0003",
		"frame_0004",
		"frame_0005",
		"frame_0006"
	},
	empire_soldier = {
		"frame_0001",
		"frame_0002",
		"frame_0003",
		"frame_0004",
		"frame_0005",
		"frame_0006"
	}
}

ProgressionUnlocks.prestige_reward_by_level = function (arg_7_0, arg_7_1)
	-- function 7
	return tbl_3[arg_7_1][arg_7_0]
end

ProgressionUnlocks.get_max_prestige_levels = function ()
	-- function 8
	return 5
end

ProgressionUnlocks.can_upgrade_prestige = function (arg_9_0)
	-- function 9
	local get = Managers.backend:get_interface("hero_attributes"):get(arg_9_0, "prestige")
	local get_experience = ExperienceSettings.get_experience(arg_9_0)
	local get_level = ExperienceSettings.get_level(get_experience)

	return (ProgressionUnlocks.is_unlocked("prestige", get_level))
end

ProgressionUnlocks.upgrade_prestige = function (arg_10_0)
	-- function 10
	local get_interface = Managers.backend:get_interface("hero_attributes")

	if not ProgressionUnlocks.can_upgrade_prestige(arg_10_0) then
		print("Trying to upgrade prestige although requirements are not met")

		return
	end

	local get_interface_2 = Managers.backend:get_interface("hero_attributes")

	get_interface_2:set(arg_10_0, "experience", 0)

	local num = get_interface_2:get(arg_10_0, "prestige") + 1

	get_interface_2:set(arg_10_0, "prestige", num)

	local prestige_reward_by_level = ProgressionUnlocks.prestige_reward_by_level(num, arg_10_0)

	Managers.backend:get_interface("items"):award_item(prestige_reward_by_level)
end

ProgressionUnlocks.get_prestige_level = function (arg_11_0)
	-- function 11
	local get = Managers.backend:get_interface("hero_attributes"):get(arg_11_0, "prestige")

	get = get or 0

	return get
end

ProgressionUnlocks.get_num_talent_points = function (arg_12_0)
	-- function 12
	local get_experience = ExperienceSettings.get_experience(arg_12_0)
	local get_level = ExperienceSettings.get_level(get_experience)
	local num = 0

	for k, v in pairs(TalentUnlockLevels) do
		if not ProgressionUnlocks.is_unlocked(k, get_level) then
			num = num + 1
		end
	end

	return num
end

local str = ""

ProgressionUnlocks.debug_use_hero_template = function (self)
	-- function 13
	if str ~= self.name then
		local get_interface = Managers.backend:get_interface("items")
		local get_interface_2 = Managers.backend:get_interface("hero_attributes")
		local profile_index = Managers.player:local_player(1):profile_index()
		local display_name = SPProfiles[profile_index].display_name

		BackendUtils.remove_items_for_prestige()

		local level = self.level
		local prestige_level = self.prestige_level
		local items = self.items
		local get_total_experience_required_for_level = ExperienceSettings.get_total_experience_required_for_level(level)

		get_interface_2:set(display_name, "experience", get_total_experience_required_for_level)
		get_interface_2:set(display_name, "prestige", prestige_level)

		for i, v in ipairs(items) do
			get_interface:award_item(v)
		end

		str = self.name

		print(str)
	else
		print("ERROR: You are already using hero template " .. self.name)
	end
end

ProgressionUnlocks.debug_get_current_hero_template = function ()
	-- function 14
	return str
end

ProgressionUnlocks.debug_reset_current_hero_template = function ()
	-- function 15
	str = ""
end

local tbl_4 = {
	dwarf_ranger = {
		{},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		}
	},
	witch_hunter = {
		{},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		}
	},
	wood_elf = {
		{},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		}
	},
	bright_wizard = {
		{},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		}
	},
	empire_soldier = {
		{},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		},
		{
			{
				item_name = "loot_chest_01_03"
			}
		}
	}
}
