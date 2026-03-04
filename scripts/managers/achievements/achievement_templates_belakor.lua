-- chunkname: @scripts/managers/achievements/achievement_templates_belakor.lua

local var_0_0 = AchievementTemplateHelper.PLACEHOLDER_ICON
local var_0_1 = AchievementTemplates.achievements
local var_0_2 = DLCSettings.belakor
local var_0_3 = AchievementTemplateHelper.rpc_increment_stat
local var_0_4 = AchievementTemplateHelper.rpc_modify_stat
local var_0_5 = AchievementTemplateHelper.add_levels_complete_per_hero_challenge
local var_0_6 = AchievementTemplateHelper.add_meta_challenge
local var_0_7 = {}
local var_0_8 = {}
local var_0_9 = 1
local var_0_10 = 2
local var_0_11 = 3
local var_0_12 = 4
local var_0_13 = 5
local var_0_14 = 1
local var_0_15 = 2
local var_0_16 = 3
local var_0_17 = 4

var_0_1.blk_complete_arena = {
	name = "achv_blk_complete_arena_name",
	display_completion_ui = true,
	icon = "achievement_morris_complete_arena",
	desc = "achv_blk_complete_arena_desc",
	completed = function (arg_1_0, arg_1_1)
		return AchievementTemplateHelper.check_level(arg_1_0, arg_1_1, "arena_belakor")
	end
}
var_0_1.blk_three_champions = {
	name = "achv_blk_three_champions_name",
	display_completion_ui = true,
	icon = "achievement_morris_shadow_champions_active",
	desc = "achv_blk_three_champions_desc",
	events = {
		"register_lieutenant_spawned",
		"register_kill"
	},
	completed = function (arg_2_0, arg_2_1, arg_2_2)
		return arg_2_0:get_persistent_stat(arg_2_1, "blk_three_champions") > 0
	end,
	on_event = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		if arg_3_3 == "register_lieutenant_spawned" then
			if not arg_3_2.num_champs then
				arg_3_2.num_champs = 0
			end

			arg_3_2.num_champs = arg_3_2.num_champs + 1

			if arg_3_2.num_champs >= 3 then
				arg_3_0:increment_stat(arg_3_1, "blk_three_champions")
			end
		else
			if not arg_3_2.num_champs then
				arg_3_2.num_champs = 0
			end

			local var_3_0 = arg_3_4[var_0_17]

			if var_3_0 and var_3_0.name and var_3_0.name == "shadow_lieutenant" then
				arg_3_2.num_champs = arg_3_2.num_champs - 1
			end
		end
	end
}
var_0_1.blk_fast_arena = {
	name = "achv_blk_fast_arena_name",
	display_completion_ui = true,
	icon = "achievement_morris_complete_arena_fast",
	desc = "achv_blk_fast_arena_desc",
	events = {
		"register_locus_destroyed"
	},
	completed = function (arg_4_0, arg_4_1, arg_4_2)
		return arg_4_0:get_persistent_stat(arg_4_1, "blk_fast_arena") >= 1
	end,
	on_event = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		local var_5_0 = Managers.time:time("game")

		if not arg_5_2.locus_destroyed then
			arg_5_2.locus_destroyed = 0
		end

		arg_5_2.locus_destroyed = arg_5_2.locus_destroyed + 1

		if arg_5_2.locus_destroyed >= 3 and var_5_0 <= 240 then
			arg_5_0:increment_stat(arg_5_1, "blk_fast_arena")
		end
	end
}

local var_0_18 = 10

var_0_1.blk_fast_kill_totems = {
	name = "achv_blk_fast_kill_totems_name",
	display_completion_ui = true,
	icon = "achievement_morris_complete_arena_totems_destroyed",
	desc = "achv_blk_fast_kill_totems_desc",
	events = {
		"register_totem_state_change",
		"register_completed_level"
	},
	completed = function (arg_6_0, arg_6_1, arg_6_2)
		return arg_6_0:get_persistent_stat(arg_6_1, "blk_fast_kill_totems") >= 1
	end,
	on_event = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
		if not arg_7_2.failed then
			if arg_7_3 == "register_totem_state_change" then
				if not arg_7_2.totem_life_time then
					arg_7_2.totem_life_time = {}
				end

				if not arg_7_2.active_totems then
					arg_7_2.active_totems = 0
				end

				local var_7_0 = Managers.time:time("game")
				local var_7_1 = arg_7_4[1]

				if arg_7_4[2] == true then
					arg_7_2.totem_life_time[var_7_1] = var_7_0
				else
					local var_7_2 = arg_7_2.totem_life_time[var_7_1]

					if var_7_2 and var_7_0 - var_7_2 > var_0_18 then
						arg_7_2.failed = true
					end

					arg_7_2.totem_life_time[var_7_1] = nil
				end
			elseif arg_7_2.totem_life_time then
				local var_7_3 = Managers.time:time("game")
				local var_7_4 = false

				for iter_7_0, iter_7_1 in pairs(arg_7_2.totem_life_time) do
					if var_7_3 - iter_7_1 > var_0_18 then
						var_7_4 = true

						break
					end
				end

				if not var_7_4 and Managers.state.game_mode:has_activated_mutator("curse_belakor_totems") then
					arg_7_0:increment_stat(arg_7_1, "blk_fast_kill_totems")
				end
			end
		end
	end
}

local var_0_19 = 2

var_0_1.blk_synced_destruction = {
	name = "achv_blk_synced_destruction_name",
	display_completion_ui = true,
	icon = "achievement_morris_destroy_locis",
	desc = "achv_blk_synced_destruction_desc",
	events = {
		"register_locus_destroyed"
	},
	completed = function (arg_8_0, arg_8_1, arg_8_2)
		return arg_8_0:get_persistent_stat(arg_8_1, "blk_synced_destruction") >= 1
	end,
	on_event = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
		local var_9_0 = Managers.time:time("game")

		if not arg_9_2.locus_destroyed then
			arg_9_2.locus_destroyed = {}
		end

		arg_9_2.locus_destroyed[#arg_9_2.locus_destroyed + 1] = var_9_0

		if #arg_9_2.locus_destroyed >= 3 and arg_9_2.locus_destroyed[#arg_9_2.locus_destroyed] - arg_9_2.locus_destroyed[1] <= var_0_19 then
			arg_9_0:increment_stat(arg_9_1, "blk_synced_destruction")
		end
	end
}
var_0_1.blk_white_run = {
	name = "achv_blk_white_run_name",
	display_completion_ui = true,
	icon = "achievement_morris_complete_arena_no_upgrades",
	desc = "achv_blk_white_run_desc",
	events = {
		"register_completed_level"
	},
	completed = function (arg_10_0, arg_10_1, arg_10_2)
		return arg_10_0:get_persistent_stat(arg_10_1, "blk_white_run") >= 1
	end,
	on_event = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
		local var_11_0 = Managers.mechanism:game_mechanism()

		if not var_11_0 or var_11_0.name ~= "Deus" then
			return
		end

		local var_11_1 = Managers.mechanism:game_mechanism():get_deus_run_controller()
		local var_11_2 = var_11_1:get_own_peer_id()
		local var_11_3 = var_11_1:get_cursed_chests_purified(var_11_2)
		local var_11_4 = var_11_1:get_coins_spent()

		if arg_11_4[2] ~= "arena_belakor" then
			return
		end

		if var_11_4 == 0 and var_11_3 == 0 then
			arg_11_0:increment_stat(arg_11_1, "blk_white_run")
		end
	end
}
var_0_1.blk_clutch_skull = {
	name = "achv_blk_clutch_skull_name",
	display_completion_ui = true,
	icon = "achievement_morris_destroy_skulls_before_hit",
	desc = "achv_blk_clutch_skull_desc",
	events = {
		"register_damage"
	},
	progress = function (arg_12_0, arg_12_1, arg_12_2)
		local var_12_0 = arg_12_0:get_persistent_stat(arg_12_1, "blk_clutch_skull")

		return {
			var_12_0,
			5
		}
	end,
	completed = function (arg_13_0, arg_13_1, arg_13_2)
		return arg_13_0:get_persistent_stat(arg_13_1, "blk_clutch_skull") >= 5
	end,
	on_event = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
		local var_14_0 = arg_14_4[var_0_13]
		local var_14_1 = arg_14_4[var_0_10]
		local var_14_2 = arg_14_4[var_0_12]

		if Managers.player:local_player().player_unit ~= var_14_2 then
			return
		end

		if var_14_0 and var_14_0.name and var_14_0.name == "shadow_skull" then
			local var_14_3 = POSITION_LOOKUP[var_14_1]
			local var_14_4 = Managers.state.side.side_by_unit[var_14_2]

			if not var_14_4 then
				return
			end

			local var_14_5 = var_14_4.PLAYER_AND_BOT_UNITS
			local var_14_6 = #var_14_5
			local var_14_7 = false

			for iter_14_0 = 1, var_14_6 do
				local var_14_8 = var_14_5[iter_14_0]

				if Unit.alive(var_14_8) and var_14_8 ~= var_14_2 then
					local var_14_9 = POSITION_LOOKUP[var_14_8]

					if Vector3.distance(var_14_3, var_14_9) < 3 then
						var_14_7 = true
					end
				end
			end

			if var_14_7 then
				arg_14_0:increment_stat(arg_14_1, "blk_clutch_skull")
			end
		end
	end
}
var_0_1.blk_no_totem = {
	name = "achv_blk_no_totem_name",
	display_completion_ui = true,
	icon = "achievement_morris_complete_arena_totems_alive",
	desc = "achv_blk_no_totem_desc",
	events = {
		"register_kill",
		"register_completed_level"
	},
	completed = function (arg_15_0, arg_15_1, arg_15_2)
		return arg_15_0:get_persistent_stat(arg_15_1, "blk_no_totem") >= 1
	end,
	on_event = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
		if arg_16_3 == "register_kill" then
			local var_16_0 = arg_16_4[var_0_17]

			if var_16_0 and var_16_0.name == "shadow_totem" then
				arg_16_2.failed = true
			end
		elseif Managers.state.game_mode:has_activated_mutator("curse_belakor_totems") and not arg_16_2.failed then
			arg_16_0:increment_stat(arg_16_1, "blk_no_totem")
		end
	end
}
var_0_1.blk_hitless_skull = {
	name = "achv_blk_hitless_skull_name",
	display_completion_ui = true,
	icon = "achievement_morris_destroy_skulls_within_time",
	desc = "achv_blk_hitless_skull_desc",
	events = {
		"register_skull_hit",
		"register_completed_level"
	},
	completed = function (arg_17_0, arg_17_1, arg_17_2)
		return arg_17_0:get_persistent_stat(arg_17_1, "blk_hitless_skull") >= 1
	end,
	on_event = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
		if arg_18_3 == "register_skull_hit" then
			local var_18_0 = arg_18_4[1]
			local var_18_1 = Managers.player:local_player()

			if var_18_0 == (var_18_1 and var_18_1.player_unit) then
				arg_18_2.failed = true
			end
		elseif Managers.state.game_mode:has_activated_mutator("curse_shadow_homing_skulls") and not arg_18_2.failed then
			arg_18_0:increment_stat(arg_18_1, "blk_hitless_skull")
		end
	end
}

local var_0_20 = {
	"blk_complete_arena",
	"blk_three_champions",
	"blk_fast_arena",
	"blk_synced_destruction",
	"blk_fast_kill_totems",
	"blk_white_run",
	"blk_clutch_skull",
	"blk_no_totem",
	"blk_hitless_skull"
}

var_0_6(var_0_1, "complete_all_belakor_challenges", var_0_20, "achievement_morris_complete_all_challenges", nil, nil, nil)
