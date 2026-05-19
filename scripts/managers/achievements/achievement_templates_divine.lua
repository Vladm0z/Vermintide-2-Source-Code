-- chunkname: @scripts/managers/achievements/achievement_templates_divine.lua

local var_0_0 = AchievementTemplateHelper.add_event_challenge
local var_0_1 = AchievementTemplateHelper.add_levels_complete_challenge
local var_0_2 = AchievementTemplateHelper.add_meta_challenge
local var_0_3 = AchievementTemplateHelper.PLACEHOLDER_ICON
local var_0_4 = AchievementTemplates.achievements
local var_0_5 = AchievementTemplateHelper.add_console_achievements
local var_0_6 = AchievementTemplateHelper.rpc_increment_stat_unique_id
local var_0_7 = {
	divine_complete_legend = 131,
	divine_collectible_challenge = 132,
	divine_generator_challenge = 133
}
local var_0_8 = {
	divine_generator_challenge = "096"
}
local var_0_9 = {
	LevelSettings.dlc_reikwald_river
}
local var_0_10 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}
local var_0_11 = {
	hardest = "legend",
	hard = "veteran",
	harder = "champion",
	cataclysm = "cataclysm",
	normal = "recruit"
}
local var_0_12 = {}

for iter_0_0 = 1, #var_0_10 do
	local var_0_13 = var_0_10[iter_0_0]
	local var_0_14 = "divine_complete_" .. var_0_11[var_0_13]
	local var_0_15 = "achv_divine_complete_" .. var_0_11[var_0_13] .. "_icon"

	var_0_12[iter_0_0] = var_0_14

	var_0_1(var_0_4, var_0_14, var_0_9, DifficultySettings[var_0_13].rank, var_0_15, nil, var_0_7[var_0_14], var_0_8[var_0_14])
end

local var_0_16 = 1
local var_0_17 = 1852 * var_0_16
local var_0_18 = 765

var_0_4.divine_nautical_miles_challenge = {
	name = "achv_divine_nautical_miles_challenge_name",
	desc = "achv_divine_nautical_miles_challenge_desc",
	display_completion_ui = true,
	icon = "achv_divine_nautical_miles_challenge_icon",
	events = {
		"divine_nautical_miles_challenge"
	},
	completed = function(arg_1_0, arg_1_1, arg_1_2)
		return arg_1_0:get_persistent_stat(arg_1_1, "divine_nautical_miles_challenge") >= var_0_17
	end,
	on_event = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		arg_2_0:modify_stat_by_amount(arg_2_1, "divine_nautical_miles_challenge", var_0_18)
	end,
	progress = function(arg_3_0, arg_3_1, arg_3_2)
		local var_3_0 = arg_3_0:get_persistent_stat(arg_3_1, "divine_nautical_miles_challenge")
		local var_3_1 = math.floor(var_3_0 * 0.539957) * 0.001

		return {
			var_3_1,
			var_0_16
		}
	end,
	progress_text_format_func = function(arg_4_0, arg_4_1)
		return string.format("%.1f / %d", arg_4_0, arg_4_1)
	end
}

local var_0_19 = 60
local var_0_20 = 50
local var_0_21 = 3

var_0_4.divine_anchor_challenge = {
	name = "achv_divine_anchor_challenge_name",
	display_completion_ui = true,
	always_run = true,
	icon = "achv_divine_anchor_challenge_icon",
	desc = function()
		return string.format(Localize("achv_divine_anchor_challenge_desc"), var_0_20)
	end,
	events = {
		"divine_anchor_attached",
		"divine_anchor_destroyed",
		"divine_anchor_challenge_completed"
	},
	completed = function(arg_6_0, arg_6_1, arg_6_2)
		return arg_6_0:get_persistent_stat(arg_6_1, "divine_anchor_challenge") >= 1
	end,
	on_event = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
		if not Managers.state.network or not Managers.state.network.is_server then
			return
		end

		local var_7_0 = Managers.time:time("game")

		if arg_7_3 == "divine_anchor_attached" then
			if arg_7_2.total_time == nil then
				arg_7_2.total_time = 0
				arg_7_2.num_events_done = 0
			end

			arg_7_2.attached_timestamp = var_7_0
			arg_7_2.num_events_done = arg_7_2.num_events_done + 1
			arg_7_2.players_at_start = arg_7_2.players_at_start or table.keys(Managers.player:human_players())
		elseif arg_7_3 == "divine_anchor_destroyed" and arg_7_2.attached_timestamp then
			local var_7_1 = var_7_0 - arg_7_2.attached_timestamp

			arg_7_2.total_time = arg_7_2.total_time + var_7_1
		end

		if arg_7_3 == "divine_anchor_challenge_completed" and var_0_19 > arg_7_2.total_time and arg_7_2.num_events_done >= var_0_21 then
			local var_7_2 = arg_7_2.players_at_start

			for iter_7_0 = 1, #var_7_2 do
				var_0_6(var_7_2[iter_7_0], "divine_anchor_challenge")
			end
		end
	end
}

local var_0_22 = 45

var_0_4.divine_sink_ships_challenge = {
	name = "achv_divine_sink_ships_challenge_name",
	display_completion_ui = true,
	icon = "achv_divine_sink_ships_challenge_icon",
	desc = function()
		return string.format(Localize("achv_divine_sink_ships_challenge_desc"), var_0_22)
	end,
	events = {
		"divine_sink_ships_challenge"
	},
	completed = function(arg_9_0, arg_9_1, arg_9_2)
		return arg_9_0:get_persistent_stat(arg_9_1, "divine_sink_ships_challenge") >= 1
	end,
	on_event = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
		local var_10_0 = Managers.time:time("game")

		if arg_10_4[1] then
			arg_10_2.challenge_over_t = var_10_0 + var_0_22
		elseif not arg_10_2.challenge_over_t then
			return
		elseif var_10_0 < arg_10_2.challenge_over_t then
			arg_10_0:increment_stat(arg_10_1, "divine_sink_ships_challenge")
		end
	end
}
var_0_4.divine_cannon_challenge = {
	name = "achv_divine_cannon_challenge_name",
	display_completion_ui = true,
	icon = "achv_divine_cannon_challenge_icon",
	desc = function()
		return string.format(Localize("achv_divine_cannon_challenge_desc"))
	end,
	events = {
		"divine_cannon_challenge"
	},
	completed = function(arg_12_0, arg_12_1, arg_12_2)
		return arg_12_0:get_persistent_stat(arg_12_1, "divine_cannon_challenge") >= 1
	end,
	on_event = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
		arg_13_0:increment_stat(arg_13_1, "divine_cannon_challenge")
	end
}
var_0_4.divine_chaos_warrior_challenge = {
	name = "achv_divine_chaos_warrior_challenge_name",
	display_completion_ui = true,
	always_run = true,
	icon = "achv_divine_chaos_warrior_challenge_icon",
	desc = function()
		return string.format(Localize("achv_divine_chaos_warrior_challenge_desc"))
	end,
	events = {
		"on_damage_dealt"
	},
	completed = function(arg_15_0, arg_15_1, arg_15_2)
		return arg_15_0:get_persistent_stat(arg_15_1, "divine_chaos_warrior_challenge") >= 1
	end,
	on_event = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
		if arg_16_4[9] ~= "sawblade_instant_kill" then
			return
		end

		local var_16_0 = Managers.state.game_mode:level_key()

		if not var_16_0 or var_16_0 ~= "dlc_reikwald_river" then
			return
		end

		local var_16_1 = arg_16_4[1]
		local var_16_2 = var_16_1 and Unit.get_data(var_16_1, "breed")
		local var_16_3 = var_16_2 and var_16_2.name

		if var_16_3 == "chaos_warrior" or var_16_3 == "chaos_bulwark" then
			arg_16_0:increment_stat_and_sync_to_clients("divine_chaos_warrior_challenge")
		end
	end
}
divine_all_challenges = table.clone(var_0_12)

table.remove(divine_all_challenges, #divine_all_challenges)

divine_all_challenges[#divine_all_challenges + 1] = "divine_nautical_miles_challenge"
divine_all_challenges[#divine_all_challenges + 1] = "divine_sink_ships_challenge"
divine_all_challenges[#divine_all_challenges + 1] = "divine_cannon_challenge"
divine_all_challenges[#divine_all_challenges + 1] = "divine_chaos_warrior_challenge"

var_0_2(var_0_4, "divine_all_challenges", divine_all_challenges, "achv_divine_complete_all_icon", nil, nil, nil)
var_0_5(var_0_7, var_0_8)
