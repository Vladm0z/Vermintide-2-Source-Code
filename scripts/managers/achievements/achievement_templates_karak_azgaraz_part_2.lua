-- chunkname: @scripts/managers/achievements/achievement_templates_karak_azgaraz_part_2.lua

local add_event_challenge = AchievementTemplateHelper.add_event_challenge
local add_levels_complete_challenge = AchievementTemplateHelper.add_levels_complete_challenge
local add_meta_challenge = AchievementTemplateHelper.add_meta_challenge
local achievements = AchievementTemplates.achievements
local add_console_achievements = AchievementTemplateHelper.add_console_achievements
local tbl = {
	karak_azgaraz_complete_dlc_dwarf_exterior_legend = 120,
	dwarf_jump_puzzle = 116,
	dwarf_towers = 117
}
local tbl_2 = {
	dwarf_jump_puzzle = "090"
}
local tbl_3 = {}
local tbl_4 = {
	LevelSettings.dlc_dwarf_exterior
}
local tbl_5 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}
local tbl_6 = {
	hardest = "legend",
	hard = "veteran",
	harder = "champion",
	cataclysm = "cataclysm",
	normal = "recruit"
}

for i = 1, #tbl_5 do
	local var_0_11 = tbl_5[i]
	local str = "karak_azgaraz_complete_dlc_dwarf_exterior_" .. tbl_6[var_0_11]
	local str_2 = "achievement_exterior_" .. tbl_6[var_0_11]

	tbl_3[i] = str

	add_levels_complete_challenge(achievements, str, tbl_4, DifficultySettings[var_0_11].rank, str_2, nil, tbl[str], tbl_2[str])
end

achievements.dwarf_towers = {
	name = "achv_dwarf_towers_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_towers",
	desc = "achv_dwarf_towers_desc",
	events = {
		"progress_dwarf_towers_challenge"
	},
	on_event = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
		-- function 1
		if not arg_1_2.num_fires then
			arg_1_2.num_fires = 1

			return
		end

		arg_1_2.num_fires = arg_1_2.num_fires + 1

		if arg_1_2.num_fires >= 4 then
			self:increment_stat(arg_1_1, "dwarf_towers")
		end
	end,
	completed = function (self, arg_2_1, arg_2_2)
		-- function 2
		return self:get_persistent_stat(arg_2_1, "dwarf_towers") >= 1
	end
}

local num = 6

achievements.dwarf_chain_speed = {
	name = "achv_dwarf_chain_speed_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_chain_speed",
	desc = function ()
		-- function 3
		return string.format(Localize("achv_dwarf_chain_speed_desc"), num)
	end,
	events = {
		"progress_dwarf_chain_speed_challenge"
	},
	completed = function (self, arg_4_1, arg_4_2)
		-- function 4
		return self:get_persistent_stat(arg_4_1, "dwarf_chain_speed") >= 1
	end,
	on_event = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		-- function 5
		if not arg_5_2.failed then
			return
		end

		local time = Managers.time:time("game")

		if not arg_5_2.num_chains then
			arg_5_2.num_chains = 0
		end

		if not (not arg_5_2.start_t and not (time > arg_5_2.start_t + num)) then
			arg_5_2.failed = true

			return
		end

		arg_5_2.num_chains = arg_5_2.num_chains + 1
		arg_5_2.start_t = time

		if arg_5_2.num_chains >= 6 then
			local network_transmit = Managers.state.network.network_transmit
			local dwarf_chain_speed = NetworkLookup.statistics.dwarf_chain_speed

			if not Managers.state.network.is_server then
				network_transmit:send_rpc_clients("rpc_increment_stat_party", dwarf_chain_speed)
			else
				network_transmit:send_rpc_server("rpc_increment_stat_party", dwarf_chain_speed)
			end
		end
	end
}
achievements.dwarf_jump_puzzle = {
	name = "achv_dwarf_jump_puzzle_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_jump_puzzle",
	desc = "achv_dwarf_jump_puzzle_desc",
	events = {
		"complete_dwarf_jump_puzzle_challenge"
	},
	completed = function (self, arg_6_1, arg_6_2)
		-- function 6
		return self:get_persistent_stat(arg_6_1, "dwarf_jump_puzzle") >= 1
	end,
	on_event = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
		-- function 7
		self:increment_stat(arg_7_1, "dwarf_jump_puzzle")
	end
}

local num_2 = 200

achievements.dwarf_push = {
	name = "achv_dwarf_push_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_push",
	desc = function ()
		-- function 8
		return string.format(Localize("achv_dwarf_push_desc"), num_2)
	end,
	events = {
		"register_kill"
	},
	progress = function (self, arg_9_1, arg_9_2)
		-- function 9
		local get_persistent_stat = self:get_persistent_stat(arg_9_1, "dwarf_push")

		return {
			get_persistent_stat,
			num_2
		}
	end,
	completed = function (self, arg_10_1, arg_10_2)
		-- function 10
		return self:get_persistent_stat(arg_10_1, "dwarf_push") >= num_2
	end,
	on_event = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
		-- function 11
		local level_key = Managers.state.game_mode:level_key()

		if not (not level_key and level_key == "dlc_dwarf_exterior") then
			return
		end

		local var_11_1 = arg_11_4[3]
		local var_11_2 = var_11_1[DamageDataIndex.DAMAGE_TYPE]

		if not (not var_11_2 and var_11_2 == "volume_insta_kill" and var_11_2 == "forced") then
			return
		end

		local var_11_3 = var_11_1[DamageDataIndex.DAMAGE_SOURCE_NAME]

		if not (not var_11_3 and var_11_3 == "suicide") then
			return
		end

		local var_11_4 = arg_11_4[2]

		if not ScriptUnit.has_extension(var_11_4, "health_system") then
			local var_11_5 = var_11_1[DamageDataIndex.SOURCE_ATTACKER_UNIT]
			local player_unit = Managers.player:local_player().player_unit

			if not (not var_11_5 and player_unit == var_11_5) then
				return
			end

			self:increment_stat(arg_11_1, "dwarf_push")
		end
	end
}
exterior_all_challenges = table.clone(tbl_3)

table.remove(exterior_all_challenges, #exterior_all_challenges)

exterior_all_challenges[#exterior_all_challenges + 1] = "dwarf_towers"
exterior_all_challenges[#exterior_all_challenges + 1] = "dwarf_chain_speed"
exterior_all_challenges[#exterior_all_challenges + 1] = "dwarf_jump_puzzle"
exterior_all_challenges[#exterior_all_challenges + 1] = "dwarf_push"

add_meta_challenge(achievements, "exterior_all_challenges", exterior_all_challenges, "achievement_exterior_meta", nil, tbl[name], tbl_2[name])
add_console_achievements(tbl, tbl_2)
