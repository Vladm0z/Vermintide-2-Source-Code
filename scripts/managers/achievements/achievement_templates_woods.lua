-- chunkname: @scripts/managers/achievements/achievement_templates_woods.lua

local achievements = AchievementTemplates.achievements
local woods = DLCSettings.woods
local add_levels_complete_per_hero_challenge = AchievementTemplateHelper.add_levels_complete_per_hero_challenge
local add_weapon_kill_challenge = AchievementTemplateHelper.add_weapon_kill_challenge
local add_career_mission_count_challenge = AchievementTemplateHelper.add_career_mission_count_challenge
local add_meta_challenge = AchievementTemplateHelper.add_meta_challenge
local add_multi_stat_count_challenge = AchievementTemplateHelper.add_multi_stat_count_challenge
local add_event_challenge = AchievementTemplateHelper.add_event_challenge
local add_stat_count_challenge = AchievementTemplateHelper.add_stat_count_challenge

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local unit_owner = Managers.player:unit_owner(arg_1_0)

	if not (not unit_owner and unit_owner.bot_player) then
		local network_id = unit_owner:network_id()
		local network = Managers.state.network
		local var_1_3 = NetworkLookup.statistics[arg_1_1]

		network.network_transmit:send_rpc("rpc_increment_stat", network_id, var_1_3)
	end
end

local tbl = {}
local tbl_2 = {}
local num = 1
local num_2 = 2
local num_3 = 3
local num_4 = 4
local num_5 = 1
local num_6 = 2
local num_7 = 3
local num_8 = 4
local num_9 = 5

achievements.woods_javelin_melee = {
	name = "achv_woods_javelin_melee_name",
	required_dlc_extra = "woods",
	desc = "achv_woods_javelin_melee_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_thornsister_catch_a_dying_breath",
	required_dlc = "woods",
	events = {
		"register_kill"
	},
	progress = function (self, arg_2_1, arg_2_2)
		-- function 2
		local get_persistent_stat = self:get_persistent_stat(arg_2_1, "woods_javelin_melee_kills")

		return {
			get_persistent_stat,
			500
		}
	end,
	completed = function (self, arg_3_1, arg_3_2)
		-- function 3
		return self:get_persistent_stat(arg_3_1, "woods_javelin_melee_kills") >= 500
	end,
	on_event = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		-- function 4
		local var_4_0 = arg_4_4[num_3]
		local var_4_1 = var_4_0[DamageDataIndex.SOURCE_ATTACKER_UNIT]
		local player_unit = Managers.player:local_player().player_unit

		if not (not var_4_1 and player_unit == var_4_1) then
			return
		end

		local var_4_3 = var_4_0[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_4_4 = rawget(ItemMasterList, var_4_3)

		if not (not var_4_4 and var_4_4.item_type == "we_javelin") then
			return
		end

		local var_4_5 = var_4_0[DamageDataIndex.ATTACK_TYPE]

		if not (not var_4_5 and var_4_5 == "light_attack" or var_4_5 ~= "heavy_attack") then
			local has_extension = ScriptUnit.has_extension(var_4_1, "career_system")

			if not (not has_extension and has_extension:career_name() == "we_thornsister") then
				return
			end

			self:increment_stat(arg_4_1, "woods_javelin_melee_kills")
		end
	end
}
achievements.woods_javelin_combo = {
	name = "achv_woods_javelin_combo_name",
	required_dlc_extra = "woods",
	desc = "achv_woods_javelin_combo_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_thornsister_dance_of_the_willow",
	required_dlc = "woods",
	events = {
		"register_kill"
	},
	completed = function (self, arg_5_1, arg_5_2)
		-- function 5
		return self:get_persistent_stat(arg_5_1, "woods_javelin_combo") > 0
	end,
	on_event = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		-- function 6
		local var_6_0 = arg_6_4[num_3]
		local var_6_1 = var_6_0[DamageDataIndex.SOURCE_ATTACKER_UNIT]
		local player_unit = Managers.player:local_player().player_unit

		if not (not var_6_1 and player_unit == var_6_1) then
			return
		end

		local var_6_3 = var_6_0[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_6_4 = rawget(ItemMasterList, var_6_3)

		if not (not var_6_4 and var_6_4.item_type == "we_javelin") then
			return
		end

		local has_extension = ScriptUnit.has_extension(var_6_1, "career_system")

		if not (not has_extension and has_extension:career_name() == "we_thornsister") then
			return
		end

		local var_6_6 = arg_6_4[num_4]
		local var_6_7 = var_6_0[DamageDataIndex.ATTACK_TYPE]

		if not (not var_6_7 and var_6_7 == "light_attack" or var_6_7 ~= "heavy_attack") then
			if not var_6_6 and not var_6_6.elite then
				arg_6_2.timed_kill = Managers.time:time("game")
			end
		elseif not var_6_7 and (var_6_7 ~= "projectile" or not arg_6_2.timed_kill) and not var_6_6 and not var_6_6.special then
			local num = Managers.time:time("game") - arg_6_2.timed_kill

			if not (not (num > 0) or not (num < 3)) then
				self:increment_stat(arg_6_1, "woods_javelin_combo")
			end
		end
	end
}
achievements.woods_wall_kill_grind = {
	name = "achv_woods_wall_kill_grind_name",
	required_dlc_extra = "woods",
	desc = "achv_woods_wall_kill_grind_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_thornsister_the_awakening_of_the_woods",
	required_dlc = "woods",
	events = {
		"register_kill"
	},
	progress = function (self, arg_7_1, arg_7_2)
		-- function 7
		local get_persistent_stat = self:get_persistent_stat(arg_7_1, "woods_wall_kill")

		return {
			get_persistent_stat,
			500
		}
	end,
	completed = function (self, arg_8_1, arg_8_2)
		-- function 8
		return self:get_persistent_stat(arg_8_1, "woods_wall_kill") >= 500
	end,
	on_event = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
		-- function 9
		local var_9_0 = arg_9_4[num_3]
		local var_9_1 = var_9_0[DamageDataIndex.ATTACKER]
		local player_unit = Managers.player:local_player().player_unit

		if not (not var_9_1 and player_unit == var_9_1) then
			return
		end

		if var_9_0[DamageDataIndex.DAMAGE_SOURCE_NAME] ~= "career_ability" then
			return
		end

		local has_extension = ScriptUnit.has_extension(var_9_1, "career_system")

		if not (not has_extension and has_extension:career_name() == "we_thornsister") then
			return
		end

		self:increment_stat(arg_9_1, "woods_wall_kill")
	end
}
achievements.woods_lifted_kill = {
	required_dlc = "woods",
	name = "achv_woods_lifted_kill_name",
	required_dlc_extra = "woods",
	display_completion_ui = true,
	desc = "achv_woods_lifted_kill_desc",
	required_career = "we_thornsister",
	icon = "achievement_trophy_thornsister_ancients_vengeful_embrace",
	always_run = true,
	events = {
		"register_kill"
	},
	progress = function (self, arg_10_1, arg_10_2)
		-- function 10
		local get_persistent_stat = self:get_persistent_stat(arg_10_1, "woods_lift_kills")

		return {
			get_persistent_stat,
			250
		}
	end,
	completed = function (self, arg_11_1, arg_11_2)
		-- function 11
		return self:get_persistent_stat(arg_11_1, "woods_lift_kills") >= 250
	end,
	on_event = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
		-- function 12
		if not Managers.state.network.is_server then
			return
		end

		local var_12_0 = arg_12_4[num_3][DamageDataIndex.ATTACKER]

		if not var_12_0 then
			return false
		end

		local has_extension = ScriptUnit.has_extension(var_12_0, "career_system")

		if not (not has_extension and has_extension:career_name() == "we_thornsister") then
			return
		end

		local var_12_2 = arg_12_4[num_2]
		local var_12_3 = BLACKBOARDS[var_12_2]

		if not var_12_3 then
			return
		end

		if not var_12_3.in_vortex then
			fn(var_12_0, "woods_lift_kills")
		end
	end
}
achievements.woods_triple_lift = {
	required_dlc = "woods",
	name = "achv_woods_triple_lift_name",
	required_dlc_extra = "woods",
	display_completion_ui = true,
	desc = "achv_woods_triple_lift_desc",
	required_career = "we_thornsister",
	icon = "achievement_trophy_thornsister_away_with_the_faeries",
	always_run = true,
	events = {
		"vortex_caught_unit"
	},
	completed = function (self, arg_13_1, arg_13_2)
		-- function 13
		return self:get_persistent_stat(arg_13_1, "woods_triple_lift") > 0
	end,
	on_event = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
		-- function 14
		if not Managers.state.network.is_server then
			return
		end

		local var_14_0 = arg_14_4[1]
		local var_14_1 = arg_14_4[2]
		local has_extension = ScriptUnit.has_extension(var_14_0, "career_system")

		if not (not has_extension and has_extension:career_name() == "we_thornsister") then
			return
		end

		local breed = BLACKBOARDS[var_14_1].breed

		if not (not breed and breed.special) then
			return
		end

		if not arg_14_2.lifted_units then
			arg_14_2.lifted_units = {}
		end

		arg_14_2.lifted_units[var_14_1] = true

		local num = 0

		for k, v in pairs(arg_14_2.lifted_units) do
			if not HEALTH_ALIVE[k] then
				local var_14_5 = BLACKBOARDS[k]

				if not (not var_14_5 and not var_14_5.in_vortex_state and var_14_5.in_vortex_state == "in_vortex_init" or var_14_5.in_vortex_state ~= "in_vortex") then
					num = num + 1
				else
					arg_14_2.lifted_units[k] = nil
				end
			else
				arg_14_2.lifted_units[k] = nil
			end
		end

		if num >= 3 then
			fn(var_14_0, "woods_triple_lift")
		end
	end
}
achievements.woods_heal_grind = {
	name = "achv_woods_heal_grind_name",
	required_dlc_extra = "woods",
	desc = "achv_woods_heal_grind_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_thornsister_handmaiden_of_isha",
	required_dlc = "woods",
	events = {
		"register_heal"
	},
	progress = function (self, arg_15_1, arg_15_2)
		-- function 15
		local get_persistent_stat = self:get_persistent_stat(arg_15_1, "woods_amount_healed")

		return {
			get_persistent_stat,
			2000
		}
	end,
	completed = function (self, arg_16_1, arg_16_2)
		-- function 16
		return self:get_persistent_stat(arg_16_1, "woods_amount_healed") > 2000
	end,
	on_event = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
		-- function 17
		local var_17_0 = arg_17_4[1]
		local player_unit = Managers.player:local_player().player_unit

		if not (not var_17_0 and player_unit == var_17_0) then
			return
		end

		local var_17_2 = arg_17_4[4]
		local var_17_3 = arg_17_4[3]

		if not (var_17_2 == "heal_from_proc" or var_17_2 ~= "career_skill") then
			return
		end

		local get_current_level_keys = Managers.level_transition_handler:get_current_level_keys()
		local var_17_5 = LevelSettings[get_current_level_keys]

		if not (not var_17_5 and var_17_5.hub_level) then
			return
		end

		local has_extension = ScriptUnit.has_extension(var_17_0, "career_system")

		if not (not has_extension and has_extension:career_name() == "we_thornsister") then
			return
		end

		local num = self:get_persistent_stat(arg_17_1, "woods_amount_healed") + var_17_3

		self:set_stat(arg_17_1, "woods_amount_healed", num)
	end
}
achievements.woods_bleed_grind = {
	name = "achv_woods_bleed_grind_name",
	required_dlc_extra = "woods",
	desc = "achv_woods_bleed_grind_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_thornsister_well_earned_agony",
	required_dlc = "woods",
	events = {
		"register_damage"
	},
	progress = function (self, arg_18_1, arg_18_2)
		-- function 18
		local get_persistent_stat = self:get_persistent_stat(arg_18_1, "woods_bleed_tics")

		return {
			get_persistent_stat,
			2000
		}
	end,
	completed = function (self, arg_19_1, arg_19_2)
		-- function 19
		return self:get_persistent_stat(arg_19_1, "woods_bleed_tics") > 2000
	end,
	on_event = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
		-- function 20
		local var_20_0 = arg_20_4[num_7][DamageDataIndex.DAMAGE_TYPE]

		if not (not var_20_0 and var_20_0 == "bleed") then
			return
		end

		local get_current_level_keys = Managers.level_transition_handler:get_current_level_keys()
		local var_20_2 = LevelSettings[get_current_level_keys]

		if not (not var_20_2 and var_20_2.hub_level) then
			return
		end

		local var_20_3 = arg_20_4[num_8]
		local player_unit = Managers.player:local_player().player_unit

		if not (not var_20_3 and player_unit == var_20_3) then
			return
		end

		local has_extension = ScriptUnit.has_extension(var_20_3, "career_system")

		if not (not has_extension and has_extension:career_name() == "we_thornsister") then
			return
		end

		self:increment_stat(arg_20_1, "woods_bleed_tics")
	end
}
achievements.woods_chaos_pinata = {
	required_dlc = "woods",
	name = "achv_woods_chaos_pinata_name",
	required_dlc_extra = "woods",
	display_completion_ui = true,
	desc = "achv_woods_chaos_pinata_desc",
	required_career = "we_thornsister",
	icon = "achievement_trophy_thornsister_together_we",
	always_run = true,
	events = {
		"vortex_caught_unit",
		"register_damage",
		"register_kill"
	},
	completed = function (self, arg_21_1, arg_21_2)
		-- function 21
		return self:get_persistent_stat(arg_21_1, "woods_chaos_pinata") > 0
	end,
	on_event = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
		-- function 22
		if not Managers.state.network.is_server then
			return
		end

		if arg_22_3 == "vortex_caught_unit" then
			local var_22_0 = arg_22_4[1]
			local var_22_1 = arg_22_4[2]
			local has_extension = ScriptUnit.has_extension(var_22_0, "career_system")

			if not (not has_extension and has_extension:career_name() == "we_thornsister") then
				return
			end

			local breed = BLACKBOARDS[var_22_1].breed

			if not (not breed and not breed.name and breed.name == "chaos_warrior") then
				return
			end

			if not arg_22_2.lifted_units then
				arg_22_2.lifted_units = {}
			end

			arg_22_2.lifted_units[var_22_1] = {}

			for k, v in pairs(arg_22_2.lifted_units) do
				if not HEALTH_ALIVE[k] then
					arg_22_2.lifted_units[k] = nil
				end
			end
		elseif arg_22_3 == "register_damage" then
			local var_22_4 = arg_22_4[num_6]

			if not (not arg_22_2.lifted_units and arg_22_2.lifted_units[var_22_4]) then
				return
			end

			local var_22_5 = arg_22_4[num_7][DamageDataIndex.ATTACK_TYPE]

			if not (not var_22_5 and var_22_5 == "light_attack" and var_22_5 == "heavy_attack") then
				return
			end

			local var_22_6 = arg_22_4[num_8]

			if not var_22_6 then
				return
			end

			local var_22_7 = arg_22_2.lifted_units[var_22_4]
			local get_data = Unit.get_data(var_22_6, "breed")

			if not get_data and not get_data.is_hero then
				var_22_7[var_22_6] = true
			end
		else
			local var_22_9 = arg_22_4[num_2]

			if not (not arg_22_2.lifted_units and arg_22_2.lifted_units[var_22_9]) then
				return
			end

			local var_22_10 = BLACKBOARDS[var_22_9]

			if not (not var_22_10 and not var_22_10.in_vortex_state and var_22_10.in_vortex_state == "in_vortex_init" or var_22_10.in_vortex_state ~= "in_vortex") then
				local num = 0
				local var_22_12

				for k_2, v_2 in pairs(arg_22_2.lifted_units[var_22_9]) do
					num = num + 1

					local has_extension_2 = ScriptUnit.has_extension(k_2, "career_system")

					if not (not has_extension_2 and has_extension_2:career_name() ~= "we_thornsister") then
						var_22_12 = k_2
					end
				end

				if not (num >= 2) or not var_22_12 then
					fn(var_22_12, "woods_chaos_pinata")
				end
			end
		end
	end
}
achievements.woods_ability_combo = {
	name = "achv_woods_ability_combo_name",
	required_dlc_extra = "woods",
	desc = "achv_woods_ability_combo_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_thornsister_rippling_radiance",
	required_dlc = "woods",
	events = {
		"any_ability_used"
	},
	completed = function (self, arg_23_1, arg_23_2)
		-- function 23
		return self:get_persistent_stat(arg_23_1, "woods_ability_combo") > 0
	end,
	on_event = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
		-- function 24
		local player_unit = Managers.player:local_player().player_unit
		local has_extension = ScriptUnit.has_extension(player_unit, "career_system")

		if not (not has_extension and has_extension:career_name() == "we_thornsister") then
			return
		end

		local var_24_2 = arg_24_4[1]
		local has_extension_2 = ScriptUnit.has_extension(var_24_2, "career_system")

		if not (not has_extension_2 and has_extension_2:career_name() == "we_thornsister") then
			return
		end

		local get_current_level_keys = Managers.level_transition_handler:get_current_level_keys()
		local var_24_5 = LevelSettings[get_current_level_keys]

		if not (not var_24_5 and var_24_5.hub_level) then
			return
		end

		local time = Managers.time:time("game")

		if not arg_24_2.use_times then
			arg_24_2.use_times = {}
		end

		local use_times = arg_24_2.use_times

		if #use_times >= 5 then
			table.remove(use_times, 1)
		end

		use_times[#use_times + 1] = time

		if #use_times >= 5 then
			local flag = true
			local var_24_9 = use_times[1]

			for i = 1, #use_times do
				if use_times[i] - var_24_9 > 10 then
					flag = false
				end
			end

			if not flag then
				self:increment_stat(arg_24_1, "woods_ability_combo")
			end
		end
	end
}
achievements.woods_wall_tank = {
	name = "achv_woods_wall_tank_name",
	required_dlc_extra = "woods",
	desc = "achv_woods_wall_tank_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_thornsister_roots_of_ages",
	required_dlc = "woods",
	events = {
		"register_thorn_wall_damage"
	},
	progress = function (self, arg_25_1, arg_25_2)
		-- function 25
		local get_persistent_stat = self:get_persistent_stat(arg_25_1, "woods_wall_hits_soaked")

		return {
			get_persistent_stat,
			1000
		}
	end,
	completed = function (self, arg_26_1, arg_26_2)
		-- function 26
		return self:get_persistent_stat(arg_26_1, "woods_wall_hits_soaked") > 1000
	end,
	on_event = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
		-- function 27
		local player_unit = Managers.player:local_player().player_unit
		local has_extension = ScriptUnit.has_extension(player_unit, "career_system")

		if not (not has_extension and has_extension:career_name() == "we_thornsister") then
			return
		end

		local var_27_2 = arg_27_4[1]
		local var_27_3 = arg_27_4[2]
		local var_27_4 = arg_27_4[4]
		local get_data = Unit.get_data(var_27_3, "breed")

		if not (not get_data and get_data.is_hero) then
			if not var_27_4 then
				if var_27_4 ~= "projectile" then
					self:increment_stat(arg_27_1, "woods_wall_hits_soaked")
				end
			else
				self:increment_stat(arg_27_1, "woods_wall_hits_soaked")
			end
		end
	end
}
achievements.woods_wall_block_ratling = {
	name = "achv_woods_wall_block_ratling_name",
	required_dlc_extra = "woods",
	desc = "achv_woods_wall_block_ratling_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_thornsister_sheltering_thicket",
	required_dlc = "woods",
	events = {
		"register_thorn_wall_damage"
	},
	progress = function (self, arg_28_1, arg_28_2)
		-- function 28
		local get_persistent_stat = self:get_persistent_stat(arg_28_1, "woods_ratling_shots_soaked")

		return {
			get_persistent_stat,
			500
		}
	end,
	completed = function (self, arg_29_1, arg_29_2)
		-- function 29
		return self:get_persistent_stat(arg_29_1, "woods_ratling_shots_soaked") >= 500
	end,
	on_event = function (self, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
		-- function 30
		local player_unit = Managers.player:local_player().player_unit
		local has_extension = ScriptUnit.has_extension(player_unit, "career_system")

		if not (not has_extension and has_extension:career_name() == "we_thornsister") then
			return
		end

		local var_30_2 = arg_30_4[1]
		local var_30_3 = arg_30_4[2]
		local var_30_4 = arg_30_4[4]
		local get_data = Unit.get_data(var_30_3, "breed")

		if not (not get_data and get_data.name ~= "skaven_ratling_gunner" and not var_30_4 and var_30_4 ~= "projectile") then
			self:increment_stat(arg_30_1, "woods_ratling_shots_soaked")
		end
	end
}
achievements.woods_bleed_boss = {
	name = "achv_woods_bleed_boss_name",
	required_dlc_extra = "woods",
	desc = "achv_woods_bleed_boss_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_thornsister_an_offering_of_pain",
	required_dlc = "woods",
	events = {
		"register_damage",
		"register_kill"
	},
	completed = function (self, arg_31_1, arg_31_2)
		-- function 31
		return self:get_persistent_stat(arg_31_1, "woods_bleed_boss") > 0
	end,
	on_event = function (self, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
		-- function 32
		if arg_32_3 == "register_damage" then
			local var_32_0 = arg_32_4[num_9]

			if not (not var_32_0 and var_32_0.boss) then
				return
			end

			local var_32_1 = arg_32_4[num_7]
			local var_32_2 = var_32_1[DamageDataIndex.DAMAGE_TYPE]

			if not (not var_32_2 and var_32_2 == "bleed") then
				return
			end

			local var_32_3 = arg_32_4[num_8]
			local player_unit = Managers.player:local_player().player_unit

			if not (not var_32_3 and player_unit == var_32_3) then
				return
			end

			local has_extension = ScriptUnit.has_extension(var_32_3, "career_system")

			if not (not has_extension and has_extension:career_name() == "we_thornsister") then
				return
			end

			local var_32_6 = arg_32_4[num_6]

			if not arg_32_2.target_bosses then
				arg_32_2.target_bosses = {}
			end

			if not arg_32_2.target_max_healths then
				arg_32_2.target_max_healths = {}
			end

			if not arg_32_2.target_bosses[var_32_6] then
				arg_32_2.target_bosses[var_32_6] = 0
			end

			arg_32_2.target_bosses[var_32_6] = arg_32_2.target_bosses[var_32_6] + var_32_1[DamageDataIndex.DAMAGE_AMOUNT]

			local has_extension_2 = ScriptUnit.has_extension(var_32_6, "health_system")

			if not has_extension_2 then
				return
			end

			local var_32_8 = arg_32_2.target_max_healths[var_32_6]

			if not var_32_8 then
				var_32_8 = has_extension_2:get_max_health()
				arg_32_2.target_max_healths[var_32_6] = var_32_8
			end

			if arg_32_2.target_bosses[var_32_6] / var_32_8 > 0.2 then
				self:increment_stat(arg_32_1, "woods_bleed_boss")
			end
		else
			if not arg_32_2.target_bosses then
				return
			end

			if not arg_32_4[num_4].boss then
				for k, v in pairs(arg_32_2.target_bosses) do
					if not HEALTH_ALIVE[k] then
						arg_32_2.target_bosses[k] = nil

						if not arg_32_2.target_max_healths and not arg_32_2.target_max_healths[k] then
							arg_32_2.target_max_healths[k] = nil
						end
					end
				end
			end
		end
	end
}
achievements.woods_wall_kill_gutter = {
	required_dlc = "woods",
	name = "achv_woods_wall_kill_gutter_name",
	required_dlc_extra = "woods",
	display_completion_ui = true,
	desc = "achv_woods_wall_kill_gutter_desc",
	required_career = "we_thornsister",
	icon = "achievement_trophy_thornsister_shall_not_pass",
	always_run = true,
	events = {
		"register_damage"
	},
	completed = function (self, arg_33_1, arg_33_2)
		-- function 33
		return self:get_persistent_stat(arg_33_1, "woods_wall_kill_gutter") > 0
	end,
	on_event = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
		-- function 34
		if not Managers.state.network.is_server then
			return
		end

		local var_34_0 = arg_34_4[5]
		local name = var_34_0.name
		local flag = not var_34_0 and name == "skaven_gutter_runner"
		local var_34_3 = arg_34_4[3]
		local var_34_4 = var_34_3[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local flag_2 = not var_34_3 and var_34_4 == "career_ability"
		local var_34_6 = var_34_3[DamageDataIndex.ATTACKER]
		local has_extension = ScriptUnit.has_extension(var_34_6, "career_system")
		local flag_3 = not has_extension and has_extension:career_name() == "we_thornsister"

		if not flag and not flag_2 and not flag_3 then
			local var_34_9 = arg_34_4[2]
			local jump_data = BLACKBOARDS[var_34_9].jump_data

			if not (not jump_data and jump_data.state == "in_air" and jump_data.state == "in_air_no_target" and jump_data.state == "snapping") then
				fn(var_34_6, "woods_wall_kill_gutter")
			end
		end
	end
}
achievements.woods_wall_dual_save = {
	required_dlc = "woods",
	name = "achv_woods_wall_dual_save_name",
	required_dlc_extra = "woods",
	display_completion_ui = true,
	desc = "achv_woods_wall_dual_save_desc",
	required_career = "we_thornsister",
	icon = "achievement_trophy_thornsister_thorny_rescue",
	always_run = true,
	events = {
		"register_damage"
	},
	completed = function (self, arg_35_1, arg_35_2)
		-- function 35
		return self:get_persistent_stat(arg_35_1, "woods_wall_dual_save") > 0
	end,
	on_event = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
		-- function 36
		if not Managers.state.network.is_server then
			return
		end

		local var_36_0 = arg_36_4[num_7]

		if var_36_0[DamageDataIndex.DAMAGE_SOURCE_NAME] ~= "career_ability" then
			return
		end

		local var_36_1 = arg_36_4[num_9]

		if not (not var_36_1 and var_36_1.special) then
			return
		end

		local var_36_2 = var_36_0[DamageDataIndex.ATTACKER]
		local has_extension = ScriptUnit.has_extension(var_36_2, "career_system")

		if not (not has_extension and has_extension:career_name() == "we_thornsister") then
			return
		end

		local var_36_4 = arg_36_4[num_2]
		local var_36_5 = BLACKBOARDS[var_36_4]

		if not var_36_1.name then
			return
		end

		local flag = false

		if var_36_1.name == "skaven_pack_master" then
			local action = var_36_5.action
			local flag_2 = not action and action.name

			if not (flag_2 == "pull" or flag_2 == "initial_pull" or flag_2 == "drag" or flag_2 ~= "hoist") then
				flag = true
			end
		elseif var_36_1.name == "skaven_gutter_runner" then
			if not var_36_5.pouncing_target then
				flag = true
			end
		elseif var_36_1.name ~= "chaos_corruptor_sorcerer" or not var_36_5.grabbed_unit then
			flag = true
		end

		if not flag then
			local time = Managers.time:time("game")
			local last_timed_interrupt = arg_36_2.last_timed_interrupt

			if not last_timed_interrupt then
				local num = time - last_timed_interrupt

				if not (not (num < 0.5) or not (num > -0.1)) then
					fn(var_36_2, "woods_wall_dual_save")
				end
			end

			arg_36_2.last_timed_interrupt = time
		end
	end
}
achievements.woods_free_ability_grind = {
	required_dlc = "woods",
	name = "achv_woods_free_ability_grind_name",
	required_dlc_extra = "woods",
	display_completion_ui = true,
	desc = "achv_woods_free_ability_grind_desc",
	required_career = "we_thornsister",
	icon = "achievement_trophy_thornsister_weaves_bounty",
	always_run = true,
	events = {
		"free_cast_used"
	},
	progress = function (self, arg_37_1, arg_37_2)
		-- function 37
		local get_persistent_stat = self:get_persistent_stat(arg_37_1, "woods_free_abilities_used")

		return {
			get_persistent_stat,
			50
		}
	end,
	completed = function (self, arg_38_1, arg_38_2)
		-- function 38
		return self:get_persistent_stat(arg_38_1, "woods_free_abilities_used") >= 50
	end,
	on_event = function (self, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
		-- function 39
		local var_39_0 = arg_39_4[2]

		if var_39_0 ~= Managers.player:local_player().player_unit then
			return
		end

		local get_current_level_keys = Managers.level_transition_handler:get_current_level_keys()
		local var_39_2 = LevelSettings[get_current_level_keys]

		if not (not var_39_2 and var_39_2.hub_level) then
			return
		end

		local has_extension = ScriptUnit.has_extension(var_39_0, "career_system")

		if not (not has_extension and has_extension:career_name() == "we_thornsister") then
			return
		end

		self:increment_stat(arg_39_1, "woods_free_abilities_used")
	end
}

local act_1 = GameActs.act_1
local act_2 = GameActs.act_2
local act_3 = GameActs.act_3
local HelmgartLevels = HelmgartLevels
local tbl_3 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}

for i = 1, #tbl_3 do
	local var_0_26 = tbl_3[i]
	local var_0_27 = DifficultyMapping[var_0_26]
	local str = "woods_complete_all_helmgart_levels_" .. var_0_27
	local str_2 = "achievement_trophy_" .. var_0_27 .. "_thornsister"

	add_levels_complete_per_hero_challenge(achievements, str, HelmgartLevels, DifficultySettings[var_0_26].rank, "we_thornsister", false, str_2, "woods", nil, nil)
end

add_career_mission_count_challenge(achievements, "woods_complete_25_missions", "completed_career_levels", "we_thornsister", tbl_3, 25, nil, "achievement_trophy_thornsister_bitter_rose_among_thorns", "woods", nil, nil)

local tbl_4 = {
	"woods_complete_all_helmgart_levels_recruit_we_thornsister",
	"woods_complete_all_helmgart_levels_veteran_we_thornsister",
	"woods_complete_all_helmgart_levels_champion_we_thornsister",
	"woods_complete_all_helmgart_levels_legend_we_thornsister",
	"woods_complete_25_missions_we_thornsister",
	"woods_javelin_melee",
	"woods_lifted_kill",
	"woods_javelin_combo",
	"woods_triple_lift",
	"woods_heal_grind",
	"woods_wall_kill_grind",
	"woods_bleed_grind",
	"woods_chaos_pinata",
	"woods_bleed_boss",
	"woods_wall_kill_gutter",
	"woods_wall_dual_save",
	"woods_ability_combo",
	"woods_wall_tank",
	"woods_wall_block_ratling",
	"woods_free_ability_grind"
}

add_meta_challenge(achievements, "complete_all_thorn_sister_challenges", tbl_4, "achievement_trophy_thornsister_reborn_through_the_weave", "woods", nil, nil)
