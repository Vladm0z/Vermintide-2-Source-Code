-- chunkname: @scripts/settings/progression_unlocks.lua

local var_0_0 = {}

for iter_0_0, iter_0_1 in pairs(TalentUnlockLevels) do
	if Development.parameter("debug_unlock_talents") then
		iter_0_1 = 0
	end

	var_0_0[iter_0_0] = {
		description = "reward_talent_point",
		value = "options_button_icon_talents_glow",
		unlock_type = "icon",
		level_requirement = iter_0_1,
		mechanism_overrides = {
			versus = {
				level_requirement = 0
			}
		}
	}
end

var_0_0.es_mercenary = {
	description = "end_screen_career_unlocked",
	profile = "empire_soldier",
	value = "es_mercenary",
	title = "es_mercenary",
	level_requirement = 0,
	unlock_type = "career"
}
var_0_0.es_huntsman = {
	description = "end_screen_career_unlocked",
	profile = "empire_soldier",
	value = "es_huntsman",
	title = "es_huntsman",
	level_requirement = 7,
	unlock_type = "career"
}
var_0_0.es_knight = {
	description = "end_screen_career_unlocked",
	profile = "empire_soldier",
	value = "es_knight",
	title = "es_knight",
	level_requirement = 12,
	unlock_type = "career"
}
var_0_0.dr_ranger = {
	description = "n/a",
	profile = "dwarf_ranger",
	value = "dr_ranger",
	title = "dr_ranger",
	level_requirement = 0,
	unlock_type = "career"
}
var_0_0.dr_ironbreaker = {
	description = "end_screen_career_unlocked",
	profile = "dwarf_ranger",
	value = "dr_ironbreaker",
	title = "dr_ironbreaker",
	level_requirement = 7,
	unlock_type = "career"
}
var_0_0.dr_slayer = {
	description = "end_screen_career_unlocked",
	profile = "dwarf_ranger",
	value = "dr_slayer",
	title = "dr_slayer",
	level_requirement = 12,
	unlock_type = "career"
}
var_0_0.wh_captain = {
	description = "end_screen_career_unlocked",
	profile = "witch_hunter",
	value = "wh_captain",
	title = "wh_captain",
	level_requirement = 0,
	unlock_type = "career"
}
var_0_0.wh_bountyhunter = {
	description = "end_screen_career_unlocked",
	profile = "witch_hunter",
	value = "wh_bountyhunter",
	title = "wh_bountyhunter",
	level_requirement = 7,
	unlock_type = "career"
}
var_0_0.wh_zealot = {
	description = "end_screen_career_unlocked",
	profile = "witch_hunter",
	value = "wh_zealot",
	title = "wh_zealot",
	level_requirement = 12,
	unlock_type = "career"
}
var_0_0.we_waywatcher = {
	description = "end_screen_career_unlocked",
	profile = "wood_elf",
	value = "we_waywatcher",
	title = "we_waywatcher",
	level_requirement = 0,
	unlock_type = "career"
}
var_0_0.we_maidenguard = {
	description = "end_screen_career_unlocked",
	profile = "wood_elf",
	value = "we_maidenguard",
	title = "we_maidenguard",
	level_requirement = 7,
	unlock_type = "career"
}
var_0_0.we_shade = {
	description = "end_screen_career_unlocked",
	profile = "wood_elf",
	value = "we_shade",
	title = "we_shade",
	level_requirement = 12,
	unlock_type = "career"
}
var_0_0.bw_adept = {
	description = "end_screen_career_unlocked",
	profile = "bright_wizard",
	value = "bw_adept",
	title = "bw_adept",
	level_requirement = 0,
	unlock_type = "career"
}
var_0_0.bw_scholar = {
	description = "end_screen_career_unlocked",
	profile = "bright_wizard",
	value = "bw_scholar",
	title = "bw_scholar",
	level_requirement = 7,
	unlock_type = "career"
}
var_0_0.bw_unchained = {
	description = "end_screen_career_unlocked",
	profile = "bright_wizard",
	value = "bw_unchained",
	title = "bw_unchained",
	level_requirement = 12,
	unlock_type = "career"
}

DLCUtils.merge("progression_unlocks", var_0_0)

for iter_0_2, iter_0_3 in pairs(var_0_0) do
	iter_0_3.name = iter_0_2
end

local var_0_1 = {}

for iter_0_4, iter_0_5 in pairs(var_0_0) do
	local var_0_2 = iter_0_5.profile

	if var_0_2 ~= nil then
		if var_0_1[var_0_2] == nil then
			var_0_1[var_0_2] = {}
		end

		var_0_1[var_0_2][iter_0_5.name] = iter_0_5
	end
end

ProgressionUnlocks = {}
ProgressionUnlocks.all_unlocks_for_debug = var_0_0

function ProgressionUnlocks.get_unlock(arg_1_0, arg_1_1)
	return MechanismOverrides.get(var_0_0)[arg_1_0]
end

function ProgressionUnlocks.get_profile_unlock(arg_2_0, arg_2_1)
	return MechanismOverrides.get(var_0_1)[arg_2_1][arg_2_0]
end

function ProgressionUnlocks.is_unlocked(arg_3_0, arg_3_1)
	local var_3_0 = MechanismOverrides.get(var_0_0)[arg_3_0]

	fassert(var_3_0, "[ProgressionUnlocks] no template named %q", tostring(arg_3_0))

	if not var_3_0.disabled and arg_3_1 >= var_3_0.level_requirement then
		return true
	end
end

function ProgressionUnlocks.get_level_unlocks(arg_4_0, arg_4_1)
	local var_4_0 = {}
	local var_4_1 = MechanismOverrides.get(var_0_0)

	for iter_4_0, iter_4_1 in pairs(var_4_1) do
		if (not iter_4_1.profile or iter_4_1.profile == arg_4_1) and iter_4_1.level_requirement == arg_4_0 then
			var_4_0[#var_4_0 + 1] = iter_4_1
		end
	end

	return var_4_0
end

function ProgressionUnlocks.is_unlocked_for_profile(arg_5_0, arg_5_1, arg_5_2)
	if Development.parameter("unlock_all_careers") then
		return true
	end

	local var_5_0 = MechanismOverrides.get(var_0_1)[arg_5_1]

	fassert(var_5_0, "No unlocks found for profile %s", arg_5_1)

	local var_5_1 = MechanismOverrides.get(var_0_0)
	local var_5_2 = var_5_0[arg_5_0]

	if var_5_2 == nil then
		return true
	end

	if arg_5_2 < var_5_2.level_requirement then
		local var_5_3 = true
		local var_5_4

		return false, Localize("career_locked_info") .. " " .. tostring(var_5_2.level_requirement), var_5_4, var_5_3
	end

	return true
end

function ProgressionUnlocks.get_quests_unlocked(arg_6_0)
	if LevelSettings[arg_6_0].dlc_name or not table.contains(MainGameLevels, arg_6_0) then
		return
	end

	local var_6_0 = Managers.player:statistics_db()
	local var_6_1 = Managers.player:local_player():stats_id()
	local var_6_2 = true

	for iter_6_0, iter_6_1 in pairs(GameActs) do
		local var_6_3 = #iter_6_1

		for iter_6_2 = 1, var_6_3 do
			local var_6_4 = iter_6_1[iter_6_2]
			local var_6_5 = var_6_0:get_persistent_stat(var_6_1, "completed_levels", var_6_4)

			if var_6_5 == 0 or arg_6_0 == var_6_4 and var_6_5 > 1 then
				var_6_2 = false

				break
			end
		end

		if not var_6_2 then
			break
		end
	end

	if var_6_2 then
		return MechanismOverrides.get(var_0_0).quests
	end
end

local var_0_3 = {
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

function ProgressionUnlocks.prestige_reward_by_level(arg_7_0, arg_7_1)
	return var_0_3[arg_7_1][arg_7_0]
end

function ProgressionUnlocks.get_max_prestige_levels()
	return 5
end

function ProgressionUnlocks.can_upgrade_prestige(arg_9_0)
	local var_9_0 = Managers.backend:get_interface("hero_attributes"):get(arg_9_0, "prestige")
	local var_9_1 = ExperienceSettings.get_experience(arg_9_0)
	local var_9_2 = ExperienceSettings.get_level(var_9_1)

	return (ProgressionUnlocks.is_unlocked("prestige", var_9_2))
end

function ProgressionUnlocks.upgrade_prestige(arg_10_0)
	local var_10_0 = Managers.backend:get_interface("hero_attributes")

	if not ProgressionUnlocks.can_upgrade_prestige(arg_10_0) then
		print("Trying to upgrade prestige although requirements are not met")

		return
	end

	local var_10_1 = Managers.backend:get_interface("hero_attributes")

	var_10_1:set(arg_10_0, "experience", 0)

	local var_10_2 = var_10_1:get(arg_10_0, "prestige") + 1

	var_10_1:set(arg_10_0, "prestige", var_10_2)

	local var_10_3 = ProgressionUnlocks.prestige_reward_by_level(var_10_2, arg_10_0)

	Managers.backend:get_interface("items"):award_item(var_10_3)
end

function ProgressionUnlocks.get_prestige_level(arg_11_0)
	return Managers.backend:get_interface("hero_attributes"):get(arg_11_0, "prestige") or 0
end

function ProgressionUnlocks.get_num_talent_points(arg_12_0)
	local var_12_0 = ExperienceSettings.get_experience(arg_12_0)
	local var_12_1 = ExperienceSettings.get_level(var_12_0)
	local var_12_2 = 0

	for iter_12_0, iter_12_1 in pairs(TalentUnlockLevels) do
		if ProgressionUnlocks.is_unlocked(iter_12_0, var_12_1) then
			var_12_2 = var_12_2 + 1
		end
	end

	return var_12_2
end

local var_0_4 = ""

function ProgressionUnlocks.debug_use_hero_template(arg_13_0)
	if var_0_4 ~= arg_13_0.name then
		local var_13_0 = Managers.backend:get_interface("items")
		local var_13_1 = Managers.backend:get_interface("hero_attributes")
		local var_13_2 = Managers.player:local_player(1):profile_index()
		local var_13_3 = SPProfiles[var_13_2].display_name

		BackendUtils.remove_items_for_prestige()

		local var_13_4 = arg_13_0.level
		local var_13_5 = arg_13_0.prestige_level
		local var_13_6 = arg_13_0.items
		local var_13_7 = ExperienceSettings.get_total_experience_required_for_level(var_13_4)

		var_13_1:set(var_13_3, "experience", var_13_7)
		var_13_1:set(var_13_3, "prestige", var_13_5)

		for iter_13_0, iter_13_1 in ipairs(var_13_6) do
			var_13_0:award_item(iter_13_1)
		end

		var_0_4 = arg_13_0.name

		print(var_0_4)
	else
		print("ERROR: You are already using hero template " .. arg_13_0.name)
	end
end

function ProgressionUnlocks.debug_get_current_hero_template()
	return var_0_4
end

function ProgressionUnlocks.debug_reset_current_hero_template()
	var_0_4 = ""
end

local var_0_5 = {
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
