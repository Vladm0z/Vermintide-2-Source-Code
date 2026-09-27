-- chunkname: @scripts/managers/achievements/achievement_templates_belakor.lua

local PLACEHOLDER_ICON = AchievementTemplateHelper.PLACEHOLDER_ICON
local achievements = AchievementTemplates.achievements
local belakor = DLCSettings.belakor
local rpc_increment_stat = AchievementTemplateHelper.rpc_increment_stat
local rpc_modify_stat = AchievementTemplateHelper.rpc_modify_stat
local add_levels_complete_per_hero_challenge = AchievementTemplateHelper.add_levels_complete_per_hero_challenge
local add_meta_challenge = AchievementTemplateHelper.add_meta_challenge
local tbl = {}
local tbl_2 = {}
local num = 1
local num_2 = 2
local num_3 = 3
local num_4 = 4
local num_5 = 5
local num_6 = 1
local num_7 = 2
local num_8 = 3
local num_9 = 4

achievements.blk_complete_arena = {
	name = "achv_blk_complete_arena_name",
	display_completion_ui = true,
	icon = "achievement_morris_complete_arena",
	desc = "achv_blk_complete_arena_desc",
	completed = function (arg_1_0, arg_1_1)
		-- function 1
		return AchievementTemplateHelper.check_level(arg_1_0, arg_1_1, "arena_belakor")
	end
}
achievements.blk_three_champions = {
	name = "achv_blk_three_champions_name",
	display_completion_ui = true,
	icon = "achievement_morris_shadow_champions_active",
	desc = "achv_blk_three_champions_desc",
	events = {
		"register_lieutenant_spawned",
		"register_kill"
	},
	completed = function (self, arg_2_1, arg_2_2)
		-- function 2
		return self:get_persistent_stat(arg_2_1, "blk_three_champions") > 0
	end,
	on_event = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		-- function 3
		if arg_3_3 == "register_lieutenant_spawned" then
			if not arg_3_2.num_champs then
				arg_3_2.num_champs = 0
			end

			arg_3_2.num_champs = arg_3_2.num_champs + 1

			if arg_3_2.num_champs >= 3 then
				self:increment_stat(arg_3_1, "blk_three_champions")
			end
		else
			if not arg_3_2.num_champs then
				arg_3_2.num_champs = 0
			end

			local var_3_0 = arg_3_4[num_9]

			if not (not var_3_0 and not var_3_0.name and var_3_0.name ~= "shadow_lieutenant") then
				arg_3_2.num_champs = arg_3_2.num_champs - 1
			end
		end
	end
}
achievements.blk_fast_arena = {
	name = "achv_blk_fast_arena_name",
	display_completion_ui = true,
	icon = "achievement_morris_complete_arena_fast",
	desc = "achv_blk_fast_arena_desc",
	events = {
		"register_locus_destroyed"
	},
	completed = function (self, arg_4_1, arg_4_2)
		-- function 4
		return self:get_persistent_stat(arg_4_1, "blk_fast_arena") >= 1
	end,
	on_event = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		-- function 5
		local time = Managers.time:time("game")

		if not arg_5_2.locus_destroyed then
			arg_5_2.locus_destroyed = 0
		end

		arg_5_2.locus_destroyed = arg_5_2.locus_destroyed + 1

		if not (not (arg_5_2.locus_destroyed >= 3) or not (time <= 240)) then
			self:increment_stat(arg_5_1, "blk_fast_arena")
		end
	end
}

local num_10 = 10

achievements.blk_fast_kill_totems = {
	name = "achv_blk_fast_kill_totems_name",
	display_completion_ui = true,
	icon = "achievement_morris_complete_arena_totems_destroyed",
	desc = "achv_blk_fast_kill_totems_desc",
	events = {
		"register_totem_state_change",
		"register_completed_level"
	},
	completed = function (self, arg_6_1, arg_6_2)
		-- function 6
		return self:get_persistent_stat(arg_6_1, "blk_fast_kill_totems") >= 1
	end,
	on_event = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
		-- function 7
		if not arg_7_2.failed then
			if arg_7_3 == "register_totem_state_change" then
				if not arg_7_2.totem_life_time then
					arg_7_2.totem_life_time = {}
				end

				if not arg_7_2.active_totems then
					arg_7_2.active_totems = 0
				end

				local time = Managers.time:time("game")
				local var_7_1 = arg_7_4[1]

				if arg_7_4[2] == true then
					arg_7_2.totem_life_time[var_7_1] = time
				else
					local var_7_2 = arg_7_2.totem_life_time[var_7_1]

					if not (not var_7_2 and not (time - var_7_2 > num_10)) then
						arg_7_2.failed = true
					end

					arg_7_2.totem_life_time[var_7_1] = nil
				end
			elseif not arg_7_2.totem_life_time then
				local time_2 = Managers.time:time("game")
				local flag = false

				for k, v in pairs(arg_7_2.totem_life_time) do
					if time_2 - v > num_10 then
						flag = true

						break
					end
				end

				if flag or not Managers.state.game_mode:has_activated_mutator("curse_belakor_totems") then
					self:increment_stat(arg_7_1, "blk_fast_kill_totems")
				end
			end
		end
	end
}

local num_11 = 2

achievements.blk_synced_destruction = {
	name = "achv_blk_synced_destruction_name",
	display_completion_ui = true,
	icon = "achievement_morris_destroy_locis",
	desc = "achv_blk_synced_destruction_desc",
	events = {
		"register_locus_destroyed"
	},
	completed = function (self, arg_8_1, arg_8_2)
		-- function 8
		return self:get_persistent_stat(arg_8_1, "blk_synced_destruction") >= 1
	end,
	on_event = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
		-- function 9
		local time = Managers.time:time("game")

		if not arg_9_2.locus_destroyed then
			arg_9_2.locus_destroyed = {}
		end

		arg_9_2.locus_destroyed[#arg_9_2.locus_destroyed + 1] = time

		if not (not (#arg_9_2.locus_destroyed >= 3) or not (arg_9_2.locus_destroyed[#arg_9_2.locus_destroyed] - arg_9_2.locus_destroyed[1] <= num_11)) then
			self:increment_stat(arg_9_1, "blk_synced_destruction")
		end
	end
}
achievements.blk_white_run = {
	name = "achv_blk_white_run_name",
	display_completion_ui = true,
	icon = "achievement_morris_complete_arena_no_upgrades",
	desc = "achv_blk_white_run_desc",
	events = {
		"register_completed_level"
	},
	completed = function (self, arg_10_1, arg_10_2)
		-- function 10
		return self:get_persistent_stat(arg_10_1, "blk_white_run") >= 1
	end,
	on_event = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
		-- function 11
		local game_mechanism = Managers.mechanism:game_mechanism()

		if not (not game_mechanism and game_mechanism.name == "Deus") then
			return
		end

		local get_deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()
		local get_own_peer_id = get_deus_run_controller:get_own_peer_id()
		local get_cursed_chests_purified = get_deus_run_controller:get_cursed_chests_purified(get_own_peer_id)
		local get_coins_spent = get_deus_run_controller:get_coins_spent()

		if arg_11_4[2] ~= "arena_belakor" then
			return
		end

		if not (get_coins_spent ~= 0 or get_cursed_chests_purified ~= 0) then
			self:increment_stat(arg_11_1, "blk_white_run")
		end
	end
}
achievements.blk_clutch_skull = {
	name = "achv_blk_clutch_skull_name",
	display_completion_ui = true,
	icon = "achievement_morris_destroy_skulls_before_hit",
	desc = "achv_blk_clutch_skull_desc",
	events = {
		"register_damage"
	},
	progress = function (self, arg_12_1, arg_12_2)
		-- function 12
		local get_persistent_stat = self:get_persistent_stat(arg_12_1, "blk_clutch_skull")

		return {
			get_persistent_stat,
			5
		}
	end,
	completed = function (self, arg_13_1, arg_13_2)
		-- function 13
		return self:get_persistent_stat(arg_13_1, "blk_clutch_skull") >= 5
	end,
	on_event = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
		-- function 14
		local var_14_0 = arg_14_4[num_5]
		local var_14_1 = arg_14_4[num_2]
		local var_14_2 = arg_14_4[num_4]

		if Managers.player:local_player().player_unit ~= var_14_2 then
			return
		end

		if not (not var_14_0 and not var_14_0.name and var_14_0.name ~= "shadow_skull") then
			local var_14_3 = POSITION_LOOKUP[var_14_1]
			local var_14_4 = Managers.state.side.side_by_unit[var_14_2]

			if not var_14_4 then
				return
			end

			local PLAYER_AND_BOT_UNITS = var_14_4.PLAYER_AND_BOT_UNITS
			local count = #PLAYER_AND_BOT_UNITS
			local flag = false

			for i = 1, count do
				local var_14_8 = PLAYER_AND_BOT_UNITS[i]

				if not (not Unit.alive(var_14_8) and var_14_8 == var_14_2) then
					local var_14_9 = POSITION_LOOKUP[var_14_8]

					if Vector3.distance(var_14_3, var_14_9) < 3 then
						flag = true
					end
				end
			end

			if not flag then
				self:increment_stat(arg_14_1, "blk_clutch_skull")
			end
		end
	end
}
achievements.blk_no_totem = {
	name = "achv_blk_no_totem_name",
	display_completion_ui = true,
	icon = "achievement_morris_complete_arena_totems_alive",
	desc = "achv_blk_no_totem_desc",
	events = {
		"register_kill",
		"register_completed_level"
	},
	completed = function (self, arg_15_1, arg_15_2)
		-- function 15
		return self:get_persistent_stat(arg_15_1, "blk_no_totem") >= 1
	end,
	on_event = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
		-- function 16
		if arg_16_3 == "register_kill" then
			local var_16_0 = arg_16_4[num_9]

			if not (not var_16_0 and var_16_0.name ~= "shadow_totem") then
				arg_16_2.failed = true
			end
		elseif not (not Managers.state.game_mode:has_activated_mutator("curse_belakor_totems") and arg_16_2.failed) then
			self:increment_stat(arg_16_1, "blk_no_totem")
		end
	end
}
achievements.blk_hitless_skull = {
	name = "achv_blk_hitless_skull_name",
	display_completion_ui = true,
	icon = "achievement_morris_destroy_skulls_within_time",
	desc = "achv_blk_hitless_skull_desc",
	events = {
		"register_skull_hit",
		"register_completed_level"
	},
	completed = function (self, arg_17_1, arg_17_2)
		-- function 17
		return self:get_persistent_stat(arg_17_1, "blk_hitless_skull") >= 1
	end,
	on_event = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
		-- function 18
		if arg_18_3 == "register_skull_hit" then
			local var_18_0 = arg_18_4[1]
			local local_player = Managers.player:local_player()

			if var_18_0 == (not local_player and local_player.player_unit) then
				arg_18_2.failed = true
			end
		elseif not (not Managers.state.game_mode:has_activated_mutator("curse_shadow_homing_skulls") and arg_18_2.failed) then
			self:increment_stat(arg_18_1, "blk_hitless_skull")
		end
	end
}

local tbl_3 = {
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

add_meta_challenge(achievements, "complete_all_belakor_challenges", tbl_3, "achievement_morris_complete_all_challenges", nil, nil, nil)
