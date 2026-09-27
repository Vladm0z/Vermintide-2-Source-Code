-- chunkname: @scripts/managers/achievements/achievement_templates_divine.lua

local add_event_challenge = AchievementTemplateHelper.add_event_challenge
local add_levels_complete_challenge = AchievementTemplateHelper.add_levels_complete_challenge
local add_meta_challenge = AchievementTemplateHelper.add_meta_challenge
local PLACEHOLDER_ICON = AchievementTemplateHelper.PLACEHOLDER_ICON
local achievements = AchievementTemplates.achievements
local add_console_achievements = AchievementTemplateHelper.add_console_achievements
local rpc_increment_stat_unique_id = AchievementTemplateHelper.rpc_increment_stat_unique_id
local tbl = {
	divine_complete_legend = 131,
	divine_collectible_challenge = 132,
	divine_generator_challenge = 133
}
local tbl_2 = {
	divine_generator_challenge = "096"
}
local tbl_3 = {
	LevelSettings.dlc_reikwald_river
}
local tbl_4 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}
local tbl_5 = {
	hardest = "legend",
	hard = "veteran",
	harder = "champion",
	cataclysm = "cataclysm",
	normal = "recruit"
}
local tbl_6 = {}

for i = 1, #tbl_4 do
	local var_0_13 = tbl_4[i]
	local str = "divine_complete_" .. tbl_5[var_0_13]
	local str_2 = "achv_divine_complete_" .. tbl_5[var_0_13] .. "_icon"

	tbl_6[i] = str

	add_levels_complete_challenge(achievements, str, tbl_3, DifficultySettings[var_0_13].rank, str_2, nil, tbl[str], tbl_2[str])
end

local num = 1
local num_2 = 1852 * num
local num_3 = 765

achievements.divine_nautical_miles_challenge = {
	name = "achv_divine_nautical_miles_challenge_name",
	desc = "achv_divine_nautical_miles_challenge_desc",
	display_completion_ui = true,
	icon = "achv_divine_nautical_miles_challenge_icon",
	events = {
		"divine_nautical_miles_challenge"
	},
	completed = function (self, arg_1_1, arg_1_2)
		-- function 1
		return self:get_persistent_stat(arg_1_1, "divine_nautical_miles_challenge") >= num_2
	end,
	on_event = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		-- function 2
		self:modify_stat_by_amount(arg_2_1, "divine_nautical_miles_challenge", num_3)
	end,
	progress = function (self, arg_3_1, arg_3_2)
		-- function 3
		local get_persistent_stat = self:get_persistent_stat(arg_3_1, "divine_nautical_miles_challenge")
		local num_2 = math.floor(get_persistent_stat * 0.539957) * 0.001

		return {
			num_2,
			num
		}
	end,
	progress_text_format_func = function (arg_4_0, arg_4_1)
		-- function 4
		return string.format("%.1f / %d", arg_4_0, arg_4_1)
	end
}

local num_4 = 60
local num_5 = 50
local num_6 = 3

achievements.divine_anchor_challenge = {
	name = "achv_divine_anchor_challenge_name",
	display_completion_ui = true,
	always_run = true,
	icon = "achv_divine_anchor_challenge_icon",
	desc = function ()
		-- function 5
		return string.format(Localize("achv_divine_anchor_challenge_desc"), num_5)
	end,
	events = {
		"divine_anchor_attached",
		"divine_anchor_destroyed",
		"divine_anchor_challenge_completed"
	},
	completed = function (self, arg_6_1, arg_6_2)
		-- function 6
		return self:get_persistent_stat(arg_6_1, "divine_anchor_challenge") >= 1
	end,
	on_event = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
		-- function 7
		if not (not Managers.state.network and Managers.state.network.is_server) then
			return
		end

		local time = Managers.time:time("game")

		if arg_7_3 == "divine_anchor_attached" then
			if arg_7_2.total_time == nil then
				arg_7_2.total_time = 0
				arg_7_2.num_events_done = 0
			end

			arg_7_2.attached_timestamp = time
			arg_7_2.num_events_done = arg_7_2.num_events_done + 1

			local players_at_start = arg_7_2.players_at_start

			players_at_start = players_at_start or table.keys(Managers.player:human_players())
			arg_7_2.players_at_start = players_at_start
		elseif arg_7_3 ~= "divine_anchor_destroyed" or not arg_7_2.attached_timestamp then
			local num = time - arg_7_2.attached_timestamp

			arg_7_2.total_time = arg_7_2.total_time + num
		end

		if not (arg_7_3 ~= "divine_anchor_challenge_completed" or not (num_4 > arg_7_2.total_time) or not (arg_7_2.num_events_done >= num_6)) then
			local players_at_start_2 = arg_7_2.players_at_start

			for i = 1, #players_at_start_2 do
				rpc_increment_stat_unique_id(players_at_start_2[i], "divine_anchor_challenge")
			end
		end
	end
}

local num_7 = 45

achievements.divine_sink_ships_challenge = {
	name = "achv_divine_sink_ships_challenge_name",
	display_completion_ui = true,
	icon = "achv_divine_sink_ships_challenge_icon",
	desc = function ()
		-- function 8
		return string.format(Localize("achv_divine_sink_ships_challenge_desc"), num_7)
	end,
	events = {
		"divine_sink_ships_challenge"
	},
	completed = function (self, arg_9_1, arg_9_2)
		-- function 9
		return self:get_persistent_stat(arg_9_1, "divine_sink_ships_challenge") >= 1
	end,
	on_event = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
		-- function 10
		local time = Managers.time:time("game")

		if not arg_10_4[1] then
			arg_10_2.challenge_over_t = time + num_7
		elseif not arg_10_2.challenge_over_t then
			return
		elseif time < arg_10_2.challenge_over_t then
			self:increment_stat(arg_10_1, "divine_sink_ships_challenge")
		end
	end
}
achievements.divine_cannon_challenge = {
	name = "achv_divine_cannon_challenge_name",
	display_completion_ui = true,
	icon = "achv_divine_cannon_challenge_icon",
	desc = function ()
		-- function 11
		return string.format(Localize("achv_divine_cannon_challenge_desc"))
	end,
	events = {
		"divine_cannon_challenge"
	},
	completed = function (self, arg_12_1, arg_12_2)
		-- function 12
		return self:get_persistent_stat(arg_12_1, "divine_cannon_challenge") >= 1
	end,
	on_event = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
		-- function 13
		self:increment_stat(arg_13_1, "divine_cannon_challenge")
	end
}
achievements.divine_chaos_warrior_challenge = {
	name = "achv_divine_chaos_warrior_challenge_name",
	display_completion_ui = true,
	always_run = true,
	icon = "achv_divine_chaos_warrior_challenge_icon",
	desc = function ()
		-- function 14
		return string.format(Localize("achv_divine_chaos_warrior_challenge_desc"))
	end,
	events = {
		"on_damage_dealt"
	},
	completed = function (self, arg_15_1, arg_15_2)
		-- function 15
		return self:get_persistent_stat(arg_15_1, "divine_chaos_warrior_challenge") >= 1
	end,
	on_event = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
		-- function 16
		if arg_16_4[9] ~= "sawblade_instant_kill" then
			return
		end

		local level_key = Managers.state.game_mode:level_key()

		if not (not level_key and level_key == "dlc_reikwald_river") then
			return
		end

		local var_16_1 = arg_16_4[1]
		local flag = not var_16_1 and Unit.get_data(var_16_1, "breed")
		local flag_2 = not flag and flag.name

		if not (flag_2 == "chaos_warrior" or flag_2 ~= "chaos_bulwark") then
			self:increment_stat_and_sync_to_clients("divine_chaos_warrior_challenge")
		end
	end
}
divine_all_challenges = table.clone(tbl_6)

table.remove(divine_all_challenges, #divine_all_challenges)

divine_all_challenges[#divine_all_challenges + 1] = "divine_nautical_miles_challenge"
divine_all_challenges[#divine_all_challenges + 1] = "divine_sink_ships_challenge"
divine_all_challenges[#divine_all_challenges + 1] = "divine_cannon_challenge"
divine_all_challenges[#divine_all_challenges + 1] = "divine_chaos_warrior_challenge"

add_meta_challenge(achievements, "divine_all_challenges", divine_all_challenges, "achv_divine_complete_all_icon", nil, nil, nil)
add_console_achievements(tbl, tbl_2)
