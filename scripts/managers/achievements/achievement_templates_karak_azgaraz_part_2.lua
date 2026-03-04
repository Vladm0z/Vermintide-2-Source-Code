-- chunkname: @scripts/managers/achievements/achievement_templates_karak_azgaraz_part_2.lua

local var_0_0 = AchievementTemplateHelper.add_event_challenge
local var_0_1 = AchievementTemplateHelper.add_levels_complete_challenge
local var_0_2 = AchievementTemplateHelper.add_meta_challenge
local var_0_3 = AchievementTemplates.achievements
local var_0_4 = AchievementTemplateHelper.add_console_achievements
local var_0_5 = {
	karak_azgaraz_complete_dlc_dwarf_exterior_legend = 120,
	dwarf_jump_puzzle = 116,
	dwarf_towers = 117
}
local var_0_6 = {
	dwarf_jump_puzzle = "090"
}
local var_0_7 = {}
local var_0_8 = {
	LevelSettings.dlc_dwarf_exterior
}
local var_0_9 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}
local var_0_10 = {
	hardest = "legend",
	hard = "veteran",
	harder = "champion",
	cataclysm = "cataclysm",
	normal = "recruit"
}

for iter_0_0 = 1, #var_0_9 do
	local var_0_11 = var_0_9[iter_0_0]
	local var_0_12 = "karak_azgaraz_complete_dlc_dwarf_exterior_" .. var_0_10[var_0_11]
	local var_0_13 = "achievement_exterior_" .. var_0_10[var_0_11]

	var_0_7[iter_0_0] = var_0_12

	var_0_1(var_0_3, var_0_12, var_0_8, DifficultySettings[var_0_11].rank, var_0_13, nil, var_0_5[var_0_12], var_0_6[var_0_12])
end

var_0_3.dwarf_towers = {
	name = "achv_dwarf_towers_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_towers",
	desc = "achv_dwarf_towers_desc",
	events = {
		"progress_dwarf_towers_challenge"
	},
	on_event = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
		if not arg_1_2.num_fires then
			arg_1_2.num_fires = 1

			return
		end

		arg_1_2.num_fires = arg_1_2.num_fires + 1

		if arg_1_2.num_fires >= 4 then
			arg_1_0:increment_stat(arg_1_1, "dwarf_towers")
		end
	end,
	completed = function (arg_2_0, arg_2_1, arg_2_2)
		return arg_2_0:get_persistent_stat(arg_2_1, "dwarf_towers") >= 1
	end
}

local var_0_14 = 6

var_0_3.dwarf_chain_speed = {
	name = "achv_dwarf_chain_speed_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_chain_speed",
	desc = function ()
		return string.format(Localize("achv_dwarf_chain_speed_desc"), var_0_14)
	end,
	events = {
		"progress_dwarf_chain_speed_challenge"
	},
	completed = function (arg_4_0, arg_4_1, arg_4_2)
		return arg_4_0:get_persistent_stat(arg_4_1, "dwarf_chain_speed") >= 1
	end,
	on_event = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		if arg_5_2.failed then
			return
		end

		local var_5_0 = Managers.time:time("game")

		if not arg_5_2.num_chains then
			arg_5_2.num_chains = 0
		end

		if arg_5_2.start_t and var_5_0 > arg_5_2.start_t + var_0_14 then
			arg_5_2.failed = true

			return
		end

		arg_5_2.num_chains = arg_5_2.num_chains + 1
		arg_5_2.start_t = var_5_0

		if arg_5_2.num_chains >= 6 then
			local var_5_1 = Managers.state.network.network_transmit
			local var_5_2 = NetworkLookup.statistics.dwarf_chain_speed

			if Managers.state.network.is_server then
				var_5_1:send_rpc_clients("rpc_increment_stat_party", var_5_2)
			else
				var_5_1:send_rpc_server("rpc_increment_stat_party", var_5_2)
			end
		end
	end
}
var_0_3.dwarf_jump_puzzle = {
	name = "achv_dwarf_jump_puzzle_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_jump_puzzle",
	desc = "achv_dwarf_jump_puzzle_desc",
	events = {
		"complete_dwarf_jump_puzzle_challenge"
	},
	completed = function (arg_6_0, arg_6_1, arg_6_2)
		return arg_6_0:get_persistent_stat(arg_6_1, "dwarf_jump_puzzle") >= 1
	end,
	on_event = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
		arg_7_0:increment_stat(arg_7_1, "dwarf_jump_puzzle")
	end
}

local var_0_15 = 200

var_0_3.dwarf_push = {
	name = "achv_dwarf_push_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_push",
	desc = function ()
		return string.format(Localize("achv_dwarf_push_desc"), var_0_15)
	end,
	events = {
		"register_kill"
	},
	progress = function (arg_9_0, arg_9_1, arg_9_2)
		local var_9_0 = arg_9_0:get_persistent_stat(arg_9_1, "dwarf_push")

		return {
			var_9_0,
			var_0_15
		}
	end,
	completed = function (arg_10_0, arg_10_1, arg_10_2)
		return arg_10_0:get_persistent_stat(arg_10_1, "dwarf_push") >= var_0_15
	end,
	on_event = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
		local var_11_0 = Managers.state.game_mode:level_key()

		if not var_11_0 or var_11_0 ~= "dlc_dwarf_exterior" then
			return
		end

		local var_11_1 = arg_11_4[3]
		local var_11_2 = var_11_1[DamageDataIndex.DAMAGE_TYPE]

		if not var_11_2 or var_11_2 ~= "volume_insta_kill" and var_11_2 ~= "forced" then
			return
		end

		local var_11_3 = var_11_1[DamageDataIndex.DAMAGE_SOURCE_NAME]

		if not var_11_3 or var_11_3 ~= "suicide" then
			return
		end

		local var_11_4 = arg_11_4[2]

		if ScriptUnit.has_extension(var_11_4, "health_system") then
			local var_11_5 = var_11_1[DamageDataIndex.SOURCE_ATTACKER_UNIT]
			local var_11_6 = Managers.player:local_player().player_unit

			if not var_11_5 or var_11_6 ~= var_11_5 then
				return
			end

			arg_11_0:increment_stat(arg_11_1, "dwarf_push")
		end
	end
}
exterior_all_challenges = table.clone(var_0_7)

table.remove(exterior_all_challenges, #exterior_all_challenges)

exterior_all_challenges[#exterior_all_challenges + 1] = "dwarf_towers"
exterior_all_challenges[#exterior_all_challenges + 1] = "dwarf_chain_speed"
exterior_all_challenges[#exterior_all_challenges + 1] = "dwarf_jump_puzzle"
exterior_all_challenges[#exterior_all_challenges + 1] = "dwarf_push"

var_0_2(var_0_3, "exterior_all_challenges", exterior_all_challenges, "achievement_exterior_meta", nil, var_0_5[name], var_0_6[name])
var_0_4(var_0_5, var_0_6)
