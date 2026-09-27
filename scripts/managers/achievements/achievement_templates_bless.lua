-- chunkname: @scripts/managers/achievements/achievement_templates_bless.lua

local PLACEHOLDER_ICON = AchievementTemplateHelper.PLACEHOLDER_ICON
local achievements = AchievementTemplates.achievements
local bless = DLCSettings.bless
local rpc_increment_stat = AchievementTemplateHelper.rpc_increment_stat
local rpc_modify_stat = AchievementTemplateHelper.rpc_modify_stat
local add_levels_complete_per_hero_challenge = AchievementTemplateHelper.add_levels_complete_per_hero_challenge
local add_career_mission_count_challenge = AchievementTemplateHelper.add_career_mission_count_challenge
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
local num_10 = 1
local num_11 = 2
local num_12 = 3
local num_13 = 4
local num_14 = 5
local num_15 = 6
local num_16 = 7
local num_17 = 8
local HelmgartLevels = HelmgartLevels

add_levels_complete_per_hero_challenge(achievements, "bless_complete_all_helmgart_levels", HelmgartLevels, 2, "wh_priest", false, "achievement_trophy_bless_complete_all_helmgart_levels_wh_priest", "bless", nil, nil)

local tbl_3 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}

add_career_mission_count_challenge(achievements, "bless_complete_25_missions", "completed_career_levels", "wh_priest", tbl_3, 25, nil, "achievement_trophy_bless_complete_25_missions_wh_priest", "bless", nil, nil)

local num_18 = 1500

achievements.bless_heal_allies = {
	name = "achv_bless_heal_allies_name",
	desc = "achv_bless_heal_allies_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_bless_heal_allies",
	required_dlc = "bless",
	events = {
		"register_heal"
	},
	progress = function (self, arg_1_1, arg_1_2)
		-- function 1
		local get_persistent_stat = self:get_persistent_stat(arg_1_1, "bless_heal_allies")

		return {
			get_persistent_stat,
			num_18
		}
	end,
	completed = function (self, arg_2_1, arg_2_2)
		-- function 2
		return self:get_persistent_stat(arg_2_1, "bless_heal_allies") >= num_18
	end,
	on_event = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		-- function 3
		local var_3_0 = arg_3_4[1]
		local var_3_1 = arg_3_4[2]
		local var_3_2 = arg_3_4[3]
		local var_3_3 = arg_3_4[4]
		local player_unit = Managers.player:local_player().player_unit

		if not (not var_3_1 and player_unit == var_3_0) then
			return
		end

		if var_3_0 == var_3_1 then
			return
		end

		local has_extension = ScriptUnit.has_extension(var_3_0, "career_system")

		if not (not has_extension and has_extension:career_name() == "wh_priest") then
			return
		end

		self:modify_stat_by_amount(arg_3_1, "bless_heal_allies", var_3_2)
	end
}

local num_19 = 5

achievements.bless_saved_by_perk = {
	name = "achv_bless_saved_by_perk_name",
	desc = "achv_bless_saved_by_perk_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_bless_saved_by_perk",
	required_dlc = "bless",
	events = {
		"register_damage_taken",
		"player_dead",
		"player_knocked_down"
	},
	progress = function (self, arg_4_1, arg_4_2)
		-- function 4
		local get_persistent_stat = self:get_persistent_stat(arg_4_1, "bless_saved_by_perk")

		return {
			get_persistent_stat,
			num_19
		}
	end,
	completed = function (self, arg_5_1, arg_5_2)
		-- function 5
		return self:get_persistent_stat(arg_5_1, "bless_saved_by_perk") >= num_19
	end,
	on_event = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		-- function 6
		if arg_6_3 == "register_damage_taken" then
			local var_6_0 = arg_6_4[1]
			local var_6_1 = arg_6_4[2]

			if not var_6_1 then
				return
			end

			local player_unit = Managers.player:local_player().player_unit

			if not (not var_6_0 and player_unit == var_6_0) then
				return
			end

			local has_extension = ScriptUnit.has_extension(var_6_0, "career_system")

			if not (not has_extension and has_extension:career_name() == "wh_priest") then
				return
			end

			local current_health = ScriptUnit.extension(var_6_0, "health_system"):current_health()
			local var_6_5 = var_6_1[DamageDataIndex.DAMAGE_AMOUNT]
			local var_6_6 = var_6_1[DamageDataIndex.DAMAGE_TYPE]

			if not (not (current_health - var_6_5 < 6) or var_6_6 ~= "life_tap") then
				local timer_handles = arg_6_2.timer_handles

				timer_handles = timer_handles or {}
				arg_6_2.timer_handles = timer_handles

				local var_6_8 = timer_handles[var_6_0]

				if not (not var_6_8 and var_6_8.valid) then
					timer_handles[var_6_0] = Managers.state.achievement:register_timed_event("bless_saved_by_perk", "on_timed_event", 5, var_6_0)
				end
			end
		elseif not arg_6_2.timer_handles then
			local var_6_9 = arg_6_4[1]
			local flag = not var_6_9 and var_6_9.player_unit
			local timer_handles_2 = arg_6_2.timer_handles
			local var_6_12 = timer_handles_2[flag]

			if not var_6_12 and not var_6_12.valid then
				Managers.state.achievement:cancel_timed_event(var_6_12)

				timer_handles_2[flag] = nil
			end
		end
	end,
	on_timed_event = function (self, arg_7_1, arg_7_2, arg_7_3)
		-- function 7
		local var_7_0 = arg_7_3

		if not HEALTH_ALIVE[var_7_0] then
			self:increment_stat(arg_7_1, "bless_saved_by_perk")

			arg_7_2.timer_handles[var_7_0] = nil
		end
	end
}
bless_book_run_amount = 5
achievements.bless_book_run = {
	name = "achv_bless_book_run_name",
	desc = "achv_bless_book_run_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_bless_book_run",
	required_dlc = "bless",
	events = {
		"register_completed_level"
	},
	progress = function (self, arg_8_1, arg_8_2)
		-- function 8
		local get_persistent_stat = self:get_persistent_stat(arg_8_1, "bless_book_run")

		return {
			get_persistent_stat,
			bless_book_run_amount
		}
	end,
	completed = function (self, arg_9_1, arg_9_2)
		-- function 9
		return self:get_persistent_stat(arg_9_1, "bless_book_run") >= bless_book_run_amount
	end,
	on_event = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
		-- function 10
		if arg_10_4[3] == "wh_priest" then
			local var_10_0 = arg_10_4[4]

			if not (not var_10_0 and var_10_0.bot_player) then
				local player_unit = var_10_0.player_unit
				local has_extension = ScriptUnit.has_extension(player_unit, "inventory_system")

				if not has_extension then
					return
				end

				local get_slot_data = has_extension:get_slot_data("slot_healthkit")
				local get_slot_data_2 = has_extension:get_slot_data("slot_potion")

				if not (not get_slot_data_2 and get_slot_data) then
					return
				end

				local get_item_template = has_extension:get_item_template(get_slot_data)
				local get_item_template_2 = has_extension:get_item_template(get_slot_data_2)

				if not get_item_template.is_grimoire and not get_item_template_2.is_grimoire then
					self:increment_stat(arg_10_1, "bless_book_run")
				end
			end
		end
	end
}

local num_20 = 10
local num_21 = 1

achievements.bless_fast_shield = {
	name = "achv_bless_fast_shield_name",
	desc = "achv_bless_fast_shield_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_bless_fast_shield",
	required_dlc = "bless",
	events = {
		"register_shield_applied",
		"register_player_disabled"
	},
	progress = function (self, arg_11_1, arg_11_2)
		-- function 11
		local get_persistent_stat = self:get_persistent_stat(arg_11_1, "bless_fast_shield")

		return {
			get_persistent_stat,
			num_20
		}
	end,
	completed = function (self, arg_12_1, arg_12_2)
		-- function 12
		return self:get_persistent_stat(arg_12_1, "bless_fast_shield") >= num_20
	end,
	on_event = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
		-- function 13
		if arg_13_3 == "register_shield_applied" then
			local var_13_0 = arg_13_4[1]
			local var_13_1 = arg_13_4[2]
			local player_unit = Managers.player:local_player().player_unit

			if not (not var_13_0 and player_unit == var_13_1) then
				return
			end

			local has_extension = ScriptUnit.has_extension(var_13_0, "status_system")

			if not has_extension then
				return
			end

			local is_pounced_down = has_extension:is_pounced_down()

			if not is_pounced_down then
				is_pounced_down = has_extension:is_grabbed_by_pack_master()
				is_pounced_down = is_pounced_down or has_extension:is_grabbed_by_corruptor()
			end

			if not is_pounced_down then
				return
			end

			local var_13_5 = arg_13_2.incapacitated_units[var_13_0]

			if not var_13_5 then
				return
			end

			local num = Managers.time:time("game") - var_13_5

			if not (not (num <= num_21) or not (num >= 0)) then
				self:increment_stat(arg_13_1, "bless_fast_shield")
			end
		else
			local incapacitated_units = arg_13_2.incapacitated_units

			incapacitated_units = incapacitated_units or {}

			local time = Managers.time:time("game")

			for k, v in pairs(incapacitated_units) do
				if not (not ALIVE[k] and not (time - v > num_21)) then
					incapacitated_units[k] = nil
				end
			end

			incapacitated_units[arg_13_4[1]] = time
			arg_13_2.incapacitated_units = incapacitated_units
		end
	end
}

local num_22 = 500

achievements.bless_unbreakable_damage_block = {
	always_run = true,
	name = "achv_bless_unbreakable_damage_block_name",
	display_completion_ui = true,
	desc = "achv_bless_unbreakable_damage_block_desc",
	required_career = "wh_priest",
	icon = "achievement_trophy_bless_unbreakable_damage_block",
	required_dlc = "bless",
	events = {
		"bless_delay_damage"
	},
	progress = function (self, arg_14_1, arg_14_2)
		-- function 14
		local get_persistent_stat = self:get_persistent_stat(arg_14_1, "bless_unbreakable_damage_block")

		return {
			get_persistent_stat,
			num_22
		}
	end,
	completed = function (self, arg_15_1, arg_15_2)
		-- function 15
		return self:get_persistent_stat(arg_15_1, "bless_unbreakable_damage_block") >= num_22
	end,
	on_event = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
		-- function 16
		local var_16_0 = arg_16_4[1]
		local var_16_1 = arg_16_4[2]

		if not (not var_16_1 and var_16_0) then
			return
		end

		local has_extension = ScriptUnit.has_extension(var_16_0, "buff_system")

		if not has_extension then
			return
		end

		if has_extension:num_buff_stacks("victor_priest_activated_ability_invincibility") <= 0 then
			return
		end

		local networkify_damage = DamageUtils.networkify_damage(var_16_1)

		rpc_modify_stat(var_16_0, "bless_unbreakable_damage_block", networkify_damage)
	end
}

local num_23 = 3

achievements.bless_punch_back = {
	always_run = true,
	name = "achv_bless_punch_back_name",
	display_completion_ui = true,
	desc = "achv_bless_punch_back_desc",
	required_career = "wh_priest",
	icon = "achievement_trophy_bless_punch_back",
	required_dlc = "bless",
	events = {
		"register_damage_taken",
		"register_damage"
	},
	completed = function (self, arg_17_1, arg_17_2)
		-- function 17
		return self:get_persistent_stat(arg_17_1, "bless_punch_back") >= 1
	end,
	on_event = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
		-- function 18
		if not Managers.state.network.is_server then
			return
		end

		if arg_18_3 == "register_damage_taken" then
			local var_18_0 = arg_18_4[1]
			local var_18_1 = arg_18_4[2]
			local flag = not var_18_1 and var_18_1[DamageDataIndex.ATTACKER]

			if not (not ALIVE[flag] and ALIVE[var_18_0]) then
				return
			end

			local has_extension = ScriptUnit.has_extension(var_18_0, "career_system")

			if not (not has_extension and has_extension:career_name() == "wh_priest") then
				return
			end

			local var_18_4 = BLACKBOARDS[flag]
			local flag_2 = not var_18_4 and var_18_4.breed

			if not (not flag_2 and flag_2.name == "chaos_warrior") then
				return
			end

			local has_extension_2 = ScriptUnit.has_extension(flag, "ai_system")

			if (not has_extension_2 and has_extension_2:current_action_name()) == "special_attack_quick" then
				local time = Managers.time:time("game")

				if not arg_18_2.last_hit then
					arg_18_2.last_hit = {
						[flag] = time
					}
					arg_18_2.last_hit_n = 1
				else
					arg_18_2.last_hit[flag] = time
					arg_18_2.last_hit_n = arg_18_2.last_hit_n + 1
				end

				if arg_18_2.last_hit_n >= 10 then
					local last_hit = arg_18_2.last_hit
					local last_hit_n = arg_18_2.last_hit_n

					for k, v in pairs(last_hit) do
						if not (not ALIVE[k] and not (time > v + num_23)) then
							last_hit[k] = nil
							last_hit_n = last_hit_n - 1
						end
					end

					arg_18_2.last_hit_n = last_hit_n
				end
			end
		elseif not arg_18_2.last_hit then
			local var_18_10 = arg_18_4[num_2]
			local var_18_11 = arg_18_2.last_hit[var_18_10]

			if not var_18_11 then
				local var_18_12 = arg_18_4[num_3]
				local var_18_13 = var_18_12[DamageDataIndex.DAMAGE_TYPE]
				local var_18_14 = var_18_12[DamageDataIndex.DAMAGE_SOURCE_NAME]
				local var_18_15 = rawget(ItemMasterList, var_18_14)
				local flag_3 = not (not var_18_15 and var_18_15.item_type == "wh_2h_hammer") and var_18_13 == "stab_smiter"
				local time_2 = Managers.time:time("game")

				if not (not flag_3 and not (time_2 - var_18_11 <= num_23)) then
					local var_18_18 = arg_18_4[num_4]

					rpc_increment_stat(var_18_18, "bless_punch_back")
				else
					arg_18_2.last_hit[var_18_10] = nil
					arg_18_2.last_hit_n = arg_18_2.last_hit_n - 1
				end
			end
		end
	end
}
achievements.bless_cluch_revive = {
	display_completion_ui = true,
	name = "achv_bless_cluch_revive_name",
	desc = "achv_bless_cluch_revive_desc",
	required_career = "wh_priest",
	icon = "achievement_trophy_bless_cluch_revive",
	required_dlc = "bless",
	events = {
		"register_revive"
	},
	completed = function (self, arg_19_1, arg_19_2)
		-- function 19
		return self:get_persistent_stat(arg_19_1, "bless_cluch_revive") >= 1
	end,
	on_event = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
		-- function 20
		local var_20_0 = arg_20_4[1]
		local var_20_1 = arg_20_4[2]
		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit

		if not (not ALIVE[var_20_1] and not ALIVE[var_20_0] and flag == var_20_0) then
			return
		end

		local has_extension = ScriptUnit.has_extension(var_20_0, "career_system")

		if not (not has_extension and has_extension:career_name() == "wh_priest") then
			return
		end

		local has_extension_2 = ScriptUnit.has_extension(var_20_0, "buff_system")

		if not has_extension_2 then
			return
		end

		if has_extension_2:num_buff_stacks("victor_priest_activated_ability_invincibility") <= 0 then
			return
		end

		local var_20_6 = Managers.state.side.side_by_unit[var_20_0]

		if not var_20_6 then
			return
		end

		local PLAYER_AND_BOT_UNITS = var_20_6.PLAYER_AND_BOT_UNITS

		if not PLAYER_AND_BOT_UNITS then
			return
		end

		for i = 1, #PLAYER_AND_BOT_UNITS do
			local var_20_8 = PLAYER_AND_BOT_UNITS[i]

			if var_20_8 ~= var_20_0 then
				local has_extension_3 = ScriptUnit.has_extension(var_20_8, "status_system")

				if not (not has_extension_3 and has_extension_3:is_knocked_down() or has_extension_3:is_dead() or has_extension_3:is_ready_for_assisted_respawn()) then
					return
				end
			end
		end

		self:increment_stat(arg_20_1, "bless_cluch_revive")
	end
}

local num_24 = 2
local tbl_4 = {
	skaven_ratling_gunner = true,
	skaven_warpfire_thrower = true
}

achievements.bless_ranged_raki = {
	display_completion_ui = true,
	name = "achv_bless_ranged_raki_name",
	desc = "achv_bless_ranged_raki_desc",
	required_career = "wh_priest",
	icon = "achievement_trophy_bless_ranged_raki",
	required_dlc = "bless",
	events = {
		"register_kill"
	},
	completed = function (self, arg_21_1, arg_21_2)
		-- function 21
		return self:get_persistent_stat(arg_21_1, "bless_ranged_raki") >= 1
	end,
	on_event = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
		-- function 22
		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit
		local var_22_2 = arg_22_4[num_8][DamageDataIndex.ATTACKER]

		if not (not var_22_2 and flag == var_22_2) then
			return
		end

		local var_22_3 = arg_22_4[num_9]

		if not (not var_22_3 and tbl_4[var_22_3.name]) then
			return
		end

		local has_extension = ScriptUnit.has_extension(var_22_2, "career_system")

		if not (not has_extension and has_extension:career_name() == "wh_priest") then
			return
		end

		local has_extension_2 = ScriptUnit.has_extension(var_22_2, "buff_system")

		if not has_extension_2 then
			return
		end

		local get_buff_type = has_extension_2:get_buff_type("victor_priest_activated_ability_invincibility")

		if not get_buff_type then
			if not (not arg_22_2.last_buff_id and not get_buff_type and arg_22_2.last_buff_id == get_buff_type.id) then
				arg_22_2.last_buff_id = get_buff_type.id
				arg_22_2.kill_count = 0
			end

			arg_22_2.kill_count = arg_22_2.kill_count + 1

			if arg_22_2.kill_count >= num_24 then
				self:increment_stat(arg_22_1, "bless_ranged_raki")
			end
		end
	end
}

local num_25 = 5

achievements.bless_chaos_warriors = {
	display_completion_ui = true,
	name = "achv_bless_chaos_warriors_name",
	desc = "achv_bless_chaos_warriors_desc",
	required_career = "wh_priest",
	icon = "achievement_trophy_bless_chaos_warriors",
	required_dlc = "bless",
	events = {
		"register_kill",
		"righteous_fury_start",
		"righteous_fury_end",
		"player_dead"
	},
	completed = function (self, arg_23_1, arg_23_2)
		-- function 23
		return self:get_persistent_stat(arg_23_1, "bless_chaos_warriors") >= 1
	end,
	on_event = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
		-- function 24
		if arg_24_3 ~= "righteous_fury_start" or not arg_24_4[2] then
			arg_24_2.righteous_fury_active = true
			arg_24_2.kill_count = 0
		elseif ((arg_24_3 ~= "righteous_fury_end" or not arg_24_4[2]) and arg_24_3 ~= "player_dead" or not arg_24_4[1]) and not arg_24_4[1].local_player then
			arg_24_2.righteous_fury_active = false
		elseif not arg_24_2.righteous_fury_active then
			local var_24_0 = arg_24_4[num_9]

			if not (not var_24_0 and var_24_0.name ~= "chaos_warrior") then
				arg_24_2.kill_count = arg_24_2.kill_count + 1

				if arg_24_2.kill_count >= num_25 then
					self:increment_stat(arg_24_1, "bless_chaos_warriors")
				end
			end
		end
	end
}

local num_26 = 50

achievements.bless_very_righteous = {
	display_completion_ui = true,
	name = "achv_bless_very_righteous_name",
	desc = "achv_bless_very_righteous_desc",
	required_career = "wh_priest",
	icon = "achievement_trophy_bless_very_righteous",
	required_dlc = "bless",
	events = {
		"righteous_fury_start",
		"righteous_fury_end",
		"player_dead"
	},
	completed = function (self, arg_25_1, arg_25_2)
		-- function 25
		return self:get_persistent_stat(arg_25_1, "bless_very_righteous") >= 1
	end,
	on_event = function (self, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
		-- function 26
		local time = Managers.time:time("game")

		if arg_26_3 ~= "righteous_fury_start" or not arg_26_4[2] then
			arg_26_2.righteous_fury_active = time
		elseif ((arg_26_3 ~= "righteous_fury_end" or not arg_26_4[2]) and arg_26_3 ~= "player_dead" or not arg_26_4[1]) and not arg_26_4[1].local_player then
			local righteous_fury_active = arg_26_2.righteous_fury_active

			if not (not righteous_fury_active and not (time - righteous_fury_active >= num_26)) then
				self:increment_stat(arg_26_1, "bless_very_righteous")
			end
		end
	end
}

local num_27 = 250

achievements.bless_smite_enemies = {
	display_completion_ui = true,
	name = "achv_bless_smite_enemies_name",
	desc = "achv_bless_smite_enemies_desc",
	required_career = "wh_priest",
	icon = "achievement_trophy_bless_smite_enemies",
	required_dlc = "bless",
	events = {
		"register_kill"
	},
	progress = function (self, arg_27_1, arg_27_2)
		-- function 27
		local get_persistent_stat = self:get_persistent_stat(arg_27_1, "bless_smite_enemies")

		return {
			get_persistent_stat,
			num_27
		}
	end,
	completed = function (self, arg_28_1, arg_28_2)
		-- function 28
		return self:get_persistent_stat(arg_28_1, "bless_smite_enemies") >= num_27
	end,
	on_event = function (self, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
		-- function 29
		local var_29_0 = arg_29_4[num_8]
		local flag = not var_29_0 and var_29_0[DamageDataIndex.ATTACKER]

		if not ALIVE[flag] then
			return
		end

		local local_player = Managers.player:local_player()
		local flag_2 = not local_player and local_player.player_unit

		if not (not flag_2 and flag_2 == flag) then
			return
		end

		local flag_3 = not var_29_0 and var_29_0[DamageDataIndex.DAMAGE_TYPE]
		local flag_4 = not var_29_0 and var_29_0[DamageDataIndex.DAMAGE_SOURCE_NAME]

		if not (flag_3 ~= "buff" or flag_4 == "career_ability") then
			return
		end

		local has_extension = ScriptUnit.has_extension(flag, "career_system")

		if not (not has_extension and has_extension:career_name() == "wh_priest") then
			return
		end

		self:increment_stat(arg_29_1, "bless_smite_enemies")
	end
}

local num_28 = 40

achievements.bless_great_hammer_headshots = {
	display_completion_ui = true,
	name = "achv_bless_great_hammer_headshots_name",
	desc = "achv_bless_great_hammer_headshots_desc",
	required_career = "wh_priest",
	icon = "achievement_trophy_bless_great_hammer_headshots",
	required_dlc = "bless",
	events = {
		"on_hit"
	},
	progress = function (self, arg_30_1, arg_30_2)
		-- function 30
		local get_persistent_stat = self:get_persistent_stat(arg_30_1, "bless_great_hammer_headshots")

		return {
			get_persistent_stat,
			num_28
		}
	end,
	completed = function (self, arg_31_1, arg_31_2)
		-- function 31
		return self:get_persistent_stat(arg_31_1, "bless_great_hammer_headshots") >= num_28
	end,
	on_event = function (self, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
		-- function 32
		local var_32_0 = arg_32_4[num_17]
		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit

		if not (not ALIVE[var_32_0] and not flag and flag == var_32_0) then
			return
		end

		if arg_32_4[num_12] ~= "head" then
			return
		end

		if arg_32_4[num_11] ~= "heavy_attack" then
			return
		end

		local has_extension = ScriptUnit.has_extension(var_32_0, "career_system")

		if not (not has_extension and has_extension:career_name() == "wh_priest") then
			return
		end

		local has_extension_2 = ScriptUnit.has_extension(var_32_0, "inventory_system")

		if not has_extension_2 then
			local get_wielded_slot_data = has_extension_2:get_wielded_slot_data()
			local flag_2 = not get_wielded_slot_data and get_wielded_slot_data.item_data

			if not (not flag_2 and flag_2.name ~= "wh_2h_hammer") then
				self:increment_stat(arg_32_1, "bless_great_hammer_headshots")
			end
		end
	end
}

local tbl_5 = {
	skaven_ratling_gunner = 8,
	skaven_poison_wind_globadier = 2,
	chaos_corruptor_sorcerer = 32,
	chaos_vortex_sorcerer = 64,
	skaven_pack_master = 4,
	skaven_warpfire_thrower = 16,
	beastmen_standard_bearer = 128,
	skaven_gutter_runner = 1
}
local num_29 = 8
local num_30 = 255

achievements.bless_kill_specials_hammer_book = {
	display_completion_ui = true,
	name = "achv_bless_kill_specials_hammer_book_name",
	desc = "achv_bless_kill_specials_hammer_book_desc",
	required_career = "wh_priest",
	icon = "achievement_trophy_bless_kill_specials_hammer_book",
	required_dlc = "bless",
	events = {
		"register_kill"
	},
	progress = function (self, arg_33_1, arg_33_2)
		-- function 33
		local num = 0
		local get_persistent_stat = self:get_persistent_stat(arg_33_1, "bless_kill_specials_hammer_book")

		for k, v in pairs(tbl_5) do
			if bit.band(get_persistent_stat, v) == v then
				num = num + 1
			end
		end

		return {
			num,
			num_29
		}
	end,
	completed = function (self, arg_34_1, arg_34_2)
		-- function 34
		return self:get_persistent_stat(arg_34_1, "bless_kill_specials_hammer_book") >= num_30
	end,
	requirements = function (self, arg_35_1)
		-- function 35
		local tbl = {}
		local num = 0
		local get_persistent_stat = self:get_persistent_stat(arg_35_1, "bless_kill_specials_hammer_book")

		for k, v in pairs(tbl_5) do
			local flag = bit.band(get_persistent_stat, v) == v

			num = num + 1
			tbl[num] = {
				name = k,
				completed = flag
			}
		end

		return tbl
	end,
	on_event = function (self, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
		-- function 36
		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit
		local var_36_2 = arg_36_4[num_8]
		local var_36_3 = var_36_2[DamageDataIndex.ATTACKER]

		if not (not var_36_3 and flag == var_36_3) then
			return
		end

		local var_36_4 = arg_36_4[num_9]

		if not var_36_4 then
			return
		end

		local var_36_5 = tbl_5[var_36_4.name]

		if not var_36_5 then
			return
		end

		local var_36_6 = var_36_2[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_36_7 = rawget(ItemMasterList, var_36_6)

		if not (not var_36_7 and var_36_7.item_type == "wh_hammer_book") then
			return
		end

		local has_extension = ScriptUnit.has_extension(var_36_3, "career_system")

		if not (not has_extension and has_extension:career_name() == "wh_priest") then
			return
		end

		local has_extension_2 = ScriptUnit.has_extension(var_36_3, "inventory_system")

		if not has_extension_2 then
			return
		end

		local get_item_data_and_weapon_extensions, var_36_11, var_36_12 = CharacterStateHelper.get_item_data_and_weapon_extensions(has_extension_2)
		local get_current_action_data = CharacterStateHelper.get_current_action_data(var_36_12, var_36_11)
		local flag_2 = not get_current_action_data and get_current_action_data.lookup_data.sub_action_name

		if not (flag_2 == "heavy_attack_stab_charged" or flag_2 == "heavy_attack_left_charged") then
			return
		end

		local get_persistent_stat = self:get_persistent_stat(arg_36_1, "bless_kill_specials_hammer_book")

		if bit.band(get_persistent_stat, var_36_5) == 0 then
			local bor = bit.bor(get_persistent_stat, var_36_5)

			self:set_stat(arg_36_1, "bless_kill_specials_hammer_book", bor)
		end
	end
}
achievements.bless_mighty_blow = {
	display_completion_ui = true,
	name = "achv_bless_mighty_blow_name",
	desc = "achv_bless_mighty_blow_desc",
	required_career = "wh_priest",
	icon = "achievement_trophy_bless_mighty_blow",
	required_dlc = "bless",
	events = {
		"register_kill"
	},
	completed = function (self, arg_37_1, arg_37_2)
		-- function 37
		return self:get_persistent_stat(arg_37_1, "bless_mighty_blow") >= 1
	end,
	on_event = function (self, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
		-- function 38
		local var_38_0 = arg_38_4[num_9]

		if not (not var_38_0 and var_38_0.name == "chaos_exalted_champion_warcamp") then
			return
		end

		local var_38_1 = arg_38_4[num_8]
		local flag = not var_38_1 and var_38_1[DamageDataIndex.ATTACKER]

		if not ALIVE[flag] then
			return
		end

		local local_player = Managers.player:local_player()
		local flag_2 = not local_player and local_player.player_unit

		if not (not flag_2 and flag_2 == flag) then
			return
		end

		local flag_3 = not var_38_1 and var_38_1[DamageDataIndex.DAMAGE_TYPE]
		local var_38_6 = var_38_1[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_38_7 = rawget(ItemMasterList, var_38_6)

		if not (not (not var_38_7 and var_38_7.item_type == "wh_2h_hammer") and flag_3 == "stab_smiter") then
			return
		end

		local has_extension = ScriptUnit.has_extension(flag, "career_system")

		if not (not has_extension and has_extension:career_name() == "wh_priest") then
			return
		end

		self:increment_stat(arg_38_1, "bless_mighty_blow")
	end
}

local num_31 = 800

achievements.bless_block_attacks = {
	always_run = true,
	name = "achv_bless_block_attacks_name",
	display_completion_ui = true,
	desc = "achv_bless_block_attacks_desc",
	required_career = "wh_priest",
	icon = "achievement_trophy_bless_block_attacks",
	required_dlc = "bless",
	events = {
		"register_damage_resisted_immune"
	},
	progress = function (self, arg_39_1, arg_39_2)
		-- function 39
		local get_persistent_stat = self:get_persistent_stat(arg_39_1, "bless_block_attacks")

		return {
			get_persistent_stat,
			num_31
		}
	end,
	completed = function (self, arg_40_1, arg_40_2)
		-- function 40
		return self:get_persistent_stat(arg_40_1, "bless_block_attacks") >= num_31
	end,
	on_event = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
		-- function 41
		local var_41_0 = arg_41_4[1]
		local var_41_1 = arg_41_4[2]
		local var_41_2 = arg_41_4[3]

		if not (not ALIVE[var_41_1] and ALIVE[var_41_0]) then
			return
		end

		if var_41_0 == var_41_1 then
			return
		end

		if not (var_41_2 == "buff" or var_41_2 ~= "push") then
			return
		end

		local has_extension = ScriptUnit.has_extension(var_41_0, "buff_system")

		if not has_extension then
			return
		end

		local get_buff_type = has_extension:get_buff_type("victor_priest_activated_ability_invincibility")

		if not get_buff_type then
			return
		end

		local attacker_unit = get_buff_type.attacker_unit

		if not ALIVE[attacker_unit] then
			rpc_increment_stat(attacker_unit, "bless_block_attacks")
		end
	end
}

local num_32 = 800

achievements.bless_righteous_stagger = {
	always_run = true,
	name = "achv_bless_righteous_stagger_name",
	display_completion_ui = true,
	desc = "achv_bless_righteous_stagger_desc",
	required_career = "wh_priest",
	icon = "achievement_trophy_bless_righteous_stagger",
	required_dlc = "bless",
	events = {
		"register_ai_stagger"
	},
	progress = function (self, arg_42_1, arg_42_2)
		-- function 42
		local get_persistent_stat = self:get_persistent_stat(arg_42_1, "bless_righteous_stagger")

		return {
			get_persistent_stat,
			num_32
		}
	end,
	completed = function (self, arg_43_1, arg_43_2)
		-- function 43
		return self:get_persistent_stat(arg_43_1, "bless_righteous_stagger") >= num_32
	end,
	on_event = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
		-- function 44
		if not Managers.state.network.is_server then
			return
		end

		local var_44_0 = arg_44_4[1]
		local var_44_1 = arg_44_4[2]

		if not (not ALIVE[var_44_1] and ALIVE[var_44_0]) then
			return
		end

		local has_extension = ScriptUnit.has_extension(var_44_1, "career_system")

		if not (not has_extension and has_extension:career_name() == "wh_priest") then
			return
		end

		local get_passive_ability = has_extension:get_passive_ability(1)

		if not get_passive_ability and not get_passive_ability:is_active() then
			rpc_increment_stat(var_44_1, "bless_righteous_stagger")
		end
	end
}

local num_33 = 60
local num_34 = 0.2

achievements.bless_charged_hammer = {
	display_completion_ui = true,
	name = "achv_bless_charged_hammer_name",
	desc = "achv_bless_charged_hammer_desc",
	required_career = "wh_priest",
	icon = "achievement_trophy_bless_charged_hammer",
	required_dlc = "bless",
	events = {
		"register_damage"
	},
	completed = function (self, arg_45_1, arg_45_2)
		-- function 45
		return self:get_persistent_stat(arg_45_1, "bless_charged_hammer") >= 1
	end,
	on_event = function (self, arg_46_1, arg_46_2, arg_46_3, arg_46_4)
		-- function 46
		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit
		local var_46_2 = arg_46_4[num_3]
		local var_46_3 = var_46_2[DamageDataIndex.ATTACKER]

		if not (not var_46_3 and flag == var_46_3) then
			return
		end

		local var_46_4 = var_46_2[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_46_5 = rawget(ItemMasterList, var_46_4)

		if not (not var_46_5 and var_46_5.item_type == "wh_hammer_book") then
			return
		end

		local has_extension = ScriptUnit.has_extension(var_46_3, "career_system")

		if not (not has_extension and has_extension:career_name() == "wh_priest") then
			return
		end

		local has_extension_2 = ScriptUnit.has_extension(var_46_3, "inventory_system")

		if not has_extension_2 then
			return
		end

		local get_item_data_and_weapon_extensions, var_46_9, var_46_10 = CharacterStateHelper.get_item_data_and_weapon_extensions(has_extension_2)
		local get_current_action_data = CharacterStateHelper.get_current_action_data(var_46_10, var_46_9)
		local flag_2 = not get_current_action_data and get_current_action_data.lookup_data.sub_action_name

		if not (flag_2 == "heavy_attack_stab_charged" or flag_2 == "heavy_attack_left_charged") then
			return
		end

		local time = Managers.time:time("game")

		if not (not arg_46_2.first_hit_t and not (time > arg_46_2.first_hit_t + num_34)) then
			arg_46_2.first_hit_t = time
			arg_46_2.hit_count = 0
			arg_46_2.victim_units = {}
		end

		local var_46_14 = arg_46_4[num_2]

		if not (not (time <= arg_46_2.first_hit_t + num_34) or arg_46_2.victim_units[var_46_14]) then
			arg_46_2.hit_count = arg_46_2.hit_count + 1
			arg_46_2.victim_units[var_46_14] = true

			if arg_46_2.hit_count >= num_33 then
				self:increment_stat(arg_46_1, "bless_charged_hammer")
			end
		end
	end
}

local num_35 = 50

achievements.bless_protected_killing = {
	display_completion_ui = true,
	name = "achv_bless_protected_killing_name",
	desc = "achv_bless_protected_killing_desc",
	required_career = "wh_priest",
	icon = "achievement_trophy_bless_protected_killing",
	required_dlc = "bless",
	events = {
		"register_kill"
	},
	completed = function (self, arg_47_1, arg_47_2)
		-- function 47
		return self:get_persistent_stat(arg_47_1, "bless_protected_killing") >= 1
	end,
	on_event = function (self, arg_48_1, arg_48_2, arg_48_3, arg_48_4)
		-- function 48
		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit
		local has_extension = ScriptUnit.has_extension(flag, "career_system")

		if not (not has_extension and has_extension:career_name() == "wh_priest") then
			return
		end

		local var_48_3 = arg_48_4[num_8]
		local var_48_4 = var_48_3[DamageDataIndex.ATTACKER]
		local var_48_5 = var_48_3[DamageDataIndex.ATTACK_TYPE]

		if not (var_48_5 == "light_attack" or var_48_5 == "heavy_attack") then
			return
		end

		local has_extension_2 = ScriptUnit.has_extension(var_48_4, "buff_system")

		if not has_extension_2 then
			local get_buff_type = has_extension_2:get_buff_type("victor_priest_activated_ability_invincibility")

			if not get_buff_type then
				local _bless_protected_killing_count = get_buff_type._bless_protected_killing_count

				_bless_protected_killing_count = _bless_protected_killing_count or 0
				get_buff_type._bless_protected_killing_count = _bless_protected_killing_count + 1

				if get_buff_type._bless_protected_killing_count >= num_35 then
					self:increment_stat(arg_48_1, "bless_protected_killing")
				end
			end
		end
	end
}

local tbl_6 = {
	"bless_complete_all_helmgart_levels_wh_priest",
	"bless_complete_25_missions_wh_priest",
	"bless_saved_by_perk",
	"bless_book_run",
	"bless_heal_allies",
	"bless_fast_shield",
	"bless_unbreakable_damage_block",
	"bless_punch_back",
	"bless_cluch_revive",
	"bless_ranged_raki",
	"bless_chaos_warriors",
	"bless_very_righteous",
	"bless_smite_enemies",
	"bless_great_hammer_headshots",
	"bless_kill_specials_hammer_book",
	"bless_mighty_blow",
	"bless_block_attacks",
	"bless_righteous_stagger",
	"bless_charged_hammer",
	"bless_protected_killing"
}

add_meta_challenge(achievements, "complete_all_warrior_priest_challenges", tbl_6, "achievement_trophy_complete_all_warrior_priest_challenges", "bless", nil, nil)
