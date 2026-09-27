-- chunkname: @scripts/managers/achievements/achievement_templates_cog.lua

local PLACEHOLDER_ICON = AchievementTemplateHelper.PLACEHOLDER_ICON
local achievements = AchievementTemplates.achievements
local cog = DLCSettings.cog
local add_levels_complete_per_hero_challenge = AchievementTemplateHelper.add_levels_complete_per_hero_challenge
local add_weapon_kill_challenge = AchievementTemplateHelper.add_weapon_kill_challenge
local add_career_mission_count_challenge = AchievementTemplateHelper.add_career_mission_count_challenge
local add_meta_challenge = AchievementTemplateHelper.add_meta_challenge
local add_weapon_kills_per_breeds_challenge = AchievementTemplateHelper.add_weapon_kills_per_breeds_challenge
local add_multi_stat_count_challenge = AchievementTemplateHelper.add_multi_stat_count_challenge
local add_event_challenge = AchievementTemplateHelper.add_event_challenge
local add_stat_count_challenge = AchievementTemplateHelper.add_stat_count_challenge
local tbl = {}
local tbl_2 = {}

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

local num = 1
local num_2 = 2
local num_3 = 3
local num_4 = 4
local num_5 = 5
local num_6 = 1
local num_7 = 2
local num_8 = 3
local num_9 = 1
local num_10 = 2
local num_11 = 1
local num_12 = 2
local num_13 = 3
local num_14 = 4
local num_15 = 1
local num_16 = 2
local num_17 = 1
local num_18 = 1
local num_19 = 2
local num_20 = 3
local num_21 = 4
local num_22 = 5
local num_23 = 6
local num_24 = 7
local num_25 = 8
local num_26 = 1
local num_27 = 1
local num_28 = 2
local num_29 = 3
local num_30 = 4
local num_31 = 1
local num_32 = 2
local num_33 = 3

achievements.cog_penta_bomb = {
	name = "achv_cog_penta_bomb_name",
	required_dlc_extra = "cog",
	desc = "achv_cog_penta_bomb_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_cog_penta_bomb",
	required_dlc = "cog_upgrade",
	events = {
		"register_damage"
	},
	completed = function (self, arg_2_1, arg_2_2)
		-- function 2
		return self:get_persistent_stat(arg_2_1, "cog_penta_bomb") > 0
	end,
	on_event = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		-- function 3
		local var_3_0 = arg_3_4[num_3]
		local var_3_1 = var_3_0[DamageDataIndex.DAMAGE_TYPE]
		local var_3_2 = var_3_0[DamageDataIndex.SOURCE_ATTACKER_UNIT]
		local player_unit = Managers.player:local_player().player_unit

		if not (not var_3_2 and player_unit == var_3_2) then
			return
		end

		if var_3_1 ~= "grenade" then
			return
		end

		local var_3_4 = arg_3_4[num_5]

		if not (not var_3_4 and var_3_4.boss) then
			return
		end

		local has_extension = ScriptUnit.has_extension(var_3_2, "career_system")

		if not (not has_extension and has_extension:career_name() == "dr_engineer") then
			return
		end

		local var_3_6 = arg_3_4[num_2]

		if not (not ALIVE[arg_3_2.current_target_unit] and arg_3_2.current_target_unit == var_3_6) then
			arg_3_2.current_target_unit = var_3_6
			arg_3_2.counter = 0
		end

		arg_3_2.counter = arg_3_2.counter + 1

		if arg_3_2.counter > 4 then
			self:increment_stat(arg_3_1, "cog_penta_bomb")
		end
	end
}
achievements.cog_air_bomb = {
	name = "achv_cog_air_bomb_name",
	required_dlc_extra = "cog",
	desc = "achv_cog_air_bomb_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_cog_air_bomb",
	required_dlc = "cog_upgrade",
	events = {
		"rat_ogre_stagger"
	},
	completed = function (self, arg_4_1, arg_4_2)
		-- function 4
		return self:get_persistent_stat(arg_4_1, "cog_air_bomb") > 0
	end,
	on_event = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		-- function 5
		local var_5_0 = arg_5_4[num_8]
		local has_extension = ScriptUnit.has_extension(var_5_0, "career_system")

		if not (not has_extension and has_extension:career_name() == "dr_engineer") then
			return false
		end

		local var_5_2 = arg_5_4[num_6]
		local recently_damaged, var_5_4 = ScriptUnit.has_extension(var_5_2, "health_system"):recently_damaged()

		if recently_damaged ~= "grenade" then
			return
		end

		if ScriptUnit.has_extension(var_5_2, "ai_system"):current_action_name() == "jump_slam" then
			fn(var_5_0, "cog_air_bomb")
		end
	end
}
achievements.cog_kill_barrage = {
	name = "achv_cog_kill_barrage_name",
	required_dlc_extra = "cog",
	desc = "achv_cog_kill_barrage_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_cog_kill_barrage",
	required_dlc = "cog_upgrade",
	events = {
		"register_kill",
		"crank_gun_fire"
	},
	completed = function (self, arg_6_1, arg_6_2)
		-- function 6
		return self:get_persistent_stat(arg_6_1, "cog_kill_barrage") > 0
	end,
	on_event = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
		-- function 7
		if arg_7_3 == "crank_gun_fire" then
			if not arg_7_2.time then
				arg_7_2.time = 0
			end

			local time = Managers.time:time("game")

			if arg_7_4[num_10] < time - arg_7_2.time then
				arg_7_2.kill_count = 0
			end

			arg_7_2.time = time

			return false
		end

		local var_7_1 = arg_7_4[num_13]
		local var_7_2 = var_7_1[DamageDataIndex.SOURCE_ATTACKER_UNIT]
		local player_unit = Managers.player:local_player().player_unit

		if not (not var_7_2 and player_unit == var_7_2) then
			return
		end

		local var_7_4 = var_7_1[DamageDataIndex.DAMAGE_SOURCE_NAME]

		if not (var_7_4 == "bardin_engineer_career_skill_weapon" or var_7_4 == "bardin_engineer_career_skill_weapon_heavy") then
			return
		end

		local has_extension = ScriptUnit.has_extension(var_7_2, "career_system")

		if not (not has_extension and has_extension:career_name() == "dr_engineer") then
			return
		end

		local kill_count = arg_7_2.kill_count

		kill_count = kill_count or 0
		arg_7_2.kill_count = kill_count + 1

		if arg_7_2.kill_count >= 50 then
			self:increment_stat(arg_7_1, "cog_kill_barrage")
		end
	end
}
achievements.cog_all_kill_barrage = {
	name = "achv_cog_all_kill_barrage_name",
	required_dlc_extra = "cog",
	desc = "achv_cog_all_kill_barrage_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_cog_all_kill_barrage",
	required_dlc = "cog_upgrade",
	events = {
		"register_kill",
		"crank_gun_fire"
	},
	completed = function (self, arg_8_1, arg_8_2)
		-- function 8
		return self:get_persistent_stat(arg_8_1, "cog_all_kill_barrage") > 0
	end,
	on_event = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
		-- function 9
		if arg_9_3 == "crank_gun_fire" then
			if not arg_9_2.time then
				arg_9_2.time = 0
			end

			local time = Managers.time:time("game")

			if arg_9_4[num_10] < time - arg_9_2.time then
				arg_9_2.kill_count = {}
			end

			arg_9_2.time = time

			return false
		else
			local var_9_1 = arg_9_4[num_13]
			local var_9_2 = var_9_1[DamageDataIndex.SOURCE_ATTACKER_UNIT]
			local var_9_3 = var_9_1[DamageDataIndex.DAMAGE_SOURCE_NAME]

			if not (not var_9_2 and var_9_3 == "bardin_engineer_career_skill_weapon" and var_9_3 == "bardin_engineer_career_skill_weapon_heavy") then
				return false
			end

			if Managers.player:local_player().player_unit ~= var_9_2 then
				return
			end

			local has_extension = ScriptUnit.has_extension(var_9_2, "career_system")

			if not (not has_extension and has_extension:career_name() == "dr_engineer") then
				return false
			end

			if not arg_9_2.kill_count then
				arg_9_2.kill_count = {}
			end

			local var_9_5 = arg_9_4[num_14]

			if not var_9_5 then
				if not var_9_5.elite then
					arg_9_2.kill_count[1] = true
				elseif not var_9_5.special then
					arg_9_2.kill_count[2] = true
				elseif not var_9_5.boss then
					arg_9_2.kill_count[3] = true
				end

				if #arg_9_2.kill_count >= 3 then
					self:increment_stat(arg_9_1, "cog_all_kill_barrage")
				end
			end
		end
	end
}
achievements.cog_climb_kill = {
	required_dlc = "cog",
	name = "achv_cog_climb_kill_name",
	display_completion_ui = true,
	desc = "achv_cog_climb_kill_desc",
	required_career = "dr_engineer",
	icon = "achievement_trophy_cog_climb_kill",
	always_run = true,
	events = {
		"register_kill"
	},
	progress = function (self, arg_10_1, arg_10_2)
		-- function 10
		local get_persistent_stat = self:get_persistent_stat(arg_10_1, "climbing_enemies_killed")

		return {
			get_persistent_stat,
			100
		}
	end,
	completed = function (self, arg_11_1, arg_11_2)
		-- function 11
		return self:get_persistent_stat(arg_11_1, "climbing_enemies_killed") >= 100
	end,
	on_event = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
		-- function 12
		if not Managers.state.network.is_server then
			return
		end

		local var_12_0 = arg_12_4[num_13]
		local var_12_1 = var_12_0[DamageDataIndex.DAMAGE_SOURCE_NAME]

		if not (var_12_1 == "bardin_engineer_career_skill_weapon" or var_12_1 == "bardin_engineer_career_skill_weapon_heavy") then
			return
		end

		local var_12_2 = var_12_0[DamageDataIndex.ATTACKER]

		if not var_12_2 then
			return false
		end

		local has_extension = ScriptUnit.has_extension(var_12_2, "career_system")

		if not (not has_extension and has_extension:career_name() == "dr_engineer") then
			return false
		end

		local var_12_4 = arg_12_4[num_12]
		local var_12_5 = BLACKBOARDS[var_12_4]

		if not var_12_5 then
			return
		end

		local locomotion_extension = var_12_5.locomotion_extension

		if not (not locomotion_extension and not locomotion_extension.movement_type and locomotion_extension.movement_type ~= "script_driven") then
			local var_12_7 = var_12_0[DamageDataIndex.ATTACKER]

			fn(var_12_7, "climbing_enemies_killed")
		end
	end
}
achievements.cog_long_bomb = {
	name = "achv_cog_long_bomb_name",
	required_dlc_extra = "cog",
	desc = "achv_cog_long_bomb_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_cog_long_bomb",
	required_dlc = "cog_upgrade",
	events = {
		"on_grenade_thrown",
		"register_kill"
	},
	completed = function (self, arg_13_1, arg_13_2)
		-- function 13
		return self:get_persistent_stat(arg_13_1, "cog_long_bomb") > 0
	end,
	on_event = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
		-- function 14
		if arg_14_3 == "on_grenade_thrown" then
			local var_14_0 = arg_14_4[num_15]

			if not var_14_0 then
				return false
			end

			local var_14_1 = POSITION_LOOKUP[var_14_0]

			arg_14_2.throw_position = Vector3Box(var_14_1)
		else
			if not arg_14_2.throw_position then
				return false
			end

			local var_14_2 = arg_14_4[num_13]
			local player_unit = Managers.player:local_player().player_unit
			local var_14_4 = var_14_2[DamageDataIndex.ATTACKER]

			if not (not var_14_4 and player_unit == var_14_4) then
				return false
			end

			local var_14_5 = var_14_2[DamageDataIndex.DAMAGE_SOURCE_NAME]

			if not (var_14_5 == "grenade_frag_01" or var_14_5 == "grenade_frag_02") then
				return false
			end

			local var_14_6 = var_14_2[DamageDataIndex.ATTACKER]

			if not var_14_6 then
				return
			end

			local has_extension = ScriptUnit.has_extension(var_14_6, "career_system")

			if not (not has_extension and has_extension:career_name() == "dr_engineer") then
				return
			end

			if arg_14_4[num_14].name == "skaven_ratling_gunner" then
				local unbox = arg_14_2.throw_position:unbox()
				local var_14_9 = arg_14_4[num_12]
				local var_14_10 = POSITION_LOOKUP[var_14_9]

				if Vector3.distance(var_14_10, unbox) > 25 then
					self:increment_stat(arg_14_1, "cog_long_bomb")
				end
			end
		end
	end
}
achievements.cog_steam_alt = {
	name = "achv_cog_steam_alt_name",
	required_dlc_extra = "cog",
	desc = "achv_cog_steam_alt_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_cog_steam_alt",
	required_dlc = "cog_upgrade",
	events = {
		"steam_alt_fire",
		"register_damage"
	},
	completed = function (self, arg_15_1, arg_15_2)
		-- function 15
		return self:get_persistent_stat(arg_15_1, "cog_steam_alt") > 0
	end,
	on_event = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
		-- function 16
		if arg_16_3 == "steam_alt_fire" then
			if not arg_16_2.shot_counter then
				arg_16_2.hit_counter = 0
				arg_16_2.shot_counter = 0
			end

			arg_16_2.shot_counter = arg_16_2.shot_counter + 1

			if not (arg_16_2.shot_counter - arg_16_2.hit_counter > 1 or not (arg_16_2.shot_counter - arg_16_2.hit_counter < -1)) then
				arg_16_2.hit_counter = 0
				arg_16_2.shot_counter = 0
			end
		else
			if not arg_16_2.shot_counter then
				return
			end

			local var_16_0 = arg_16_4[num_3][DamageDataIndex.DAMAGE_SOURCE_NAME]
			local var_16_1 = rawget(ItemMasterList, var_16_0)

			if not (not var_16_1 and var_16_1.item_type == "dr_steam_pistol") then
				return
			end

			local var_16_2 = arg_16_4[num_5]

			if not (not var_16_2 and var_16_2.boss) then
				return
			end

			local var_16_3 = arg_16_4[num_4]
			local has_extension = ScriptUnit.has_extension(var_16_3, "career_system")

			if not (not has_extension and has_extension:career_name() == "dr_engineer") then
				return
			end

			arg_16_2.hit_counter = arg_16_2.hit_counter + 1

			if not (arg_16_2.shot_counter - arg_16_2.hit_counter >= 1 or not (arg_16_2.shot_counter - arg_16_2.hit_counter <= -1)) then
				arg_16_2.hit_counter = 0
				arg_16_2.shot_counter = 0
			end

			if arg_16_2.hit_counter >= 12 then
				self:increment_stat(arg_16_1, "cog_steam_alt")
			end
		end
	end
}
achievements.cog_bomb_grind = {
	name = "achv_cog_bomb_grind_name",
	required_dlc_extra = "cog",
	desc = "achv_cog_bomb_grind_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_cog_bomb_grind",
	required_dlc = "cog_upgrade",
	events = {
		"register_kill"
	},
	progress = function (self, arg_17_1, arg_17_2)
		-- function 17
		local get_persistent_stat = self:get_persistent_stat(arg_17_1, "cog_bomb_kills")

		return {
			get_persistent_stat,
			500
		}
	end,
	completed = function (self, arg_18_1, arg_18_2)
		-- function 18
		return self:get_persistent_stat(arg_18_1, "cog_bomb_kills") >= 500
	end,
	on_event = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
		-- function 19
		local var_19_0 = arg_19_4[num_13]
		local var_19_1 = var_19_0[DamageDataIndex.DAMAGE_TYPE]

		if not (var_19_1 == "grenade" or var_19_1 == "grenade_glance") then
			return false
		end

		local player_unit = Managers.player:local_player().player_unit
		local var_19_3 = var_19_0[DamageDataIndex.ATTACKER]

		if not (not var_19_3 and player_unit == var_19_3) then
			return false
		end

		if not ((var_19_1 == "burninating" or var_19_1 == "burn") and DamageUtils.attacker_is_fire_bomb(var_19_3)) then
			return
		end

		local var_19_4 = var_19_0[DamageDataIndex.DAMAGE_SOURCE_NAME]

		if not (var_19_4 == "grenade_frag_01" or var_19_4 == "grenade_frag_02" or var_19_4 == "dot_debuff" or var_19_4 == "grenade_fire_01" or var_19_4 ~= "grenade_fire_02") then
			local var_19_5 = var_19_0[DamageDataIndex.ATTACKER]

			if var_19_4 == "dot_debuff" then
				var_19_5 = var_19_0[DamageDataIndex.SOURCE_ATTACKER_UNIT]
			end

			local has_extension = ScriptUnit.has_extension(var_19_5, "career_system")

			if not (not has_extension and has_extension:career_name() == "dr_engineer") then
				return false
			end

			self:increment_stat(arg_19_1, "cog_bomb_kills")
		end
	end
}
achievements.cog_chain_headshot = {
	display_completion_ui = true,
	name = "achv_cog_chain_headshot_name",
	required_dlc = "cog",
	icon = "achievement_trophy_cog_chain_headshot",
	desc = "achv_cog_chain_headshot_desc",
	events = {
		"on_hit",
		"ammo_used"
	},
	completed = function (self, arg_20_1, arg_20_2)
		-- function 20
		return self:get_persistent_stat(arg_20_1, "cog_chain_headshot") > 0
	end,
	on_event = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
		-- function 21
		if arg_21_3 == "ammo_used" then
			local var_21_0 = arg_21_4[num_17]
			local has_extension = ScriptUnit.has_extension(var_21_0, "career_system")

			if not (not has_extension and has_extension:career_name() == "dr_engineer") then
				return false
			end

			local shots_fired = arg_21_2.shots_fired

			shots_fired = shots_fired or 0
			arg_21_2.shots_fired = shots_fired
			arg_21_2.shots_fired = arg_21_2.shots_fired + 1
		else
			local var_21_3 = arg_21_4[num_21]
			local var_21_4 = arg_21_4[num_25]
			local var_21_5 = arg_21_4[num_25]
			local player_unit = Managers.player:local_player().player_unit

			if not (not var_21_5 and player_unit == var_21_5) then
				return
			end

			if var_21_3 > 1 then
				return
			end

			if arg_21_4[num_19] ~= "instant_projectile" then
				return
			end

			if arg_21_4[num_20] ~= "head" then
				return
			end

			local var_21_7 = arg_21_4[num_18]
			local flag = not var_21_7 and Unit.get_data(var_21_7, "breed")

			if not (not flag and flag.elite) then
				return
			end

			local has_extension_2 = ScriptUnit.has_extension(var_21_4, "career_system")

			if not (not has_extension_2 and has_extension_2:career_name() == "dr_engineer") then
				return false
			end

			local has_extension_3 = ScriptUnit.has_extension(var_21_4, "inventory_system")

			if not has_extension_3 then
				local str = "slot_ranged"

				if has_extension_3:get_wielded_slot_name() == str then
					if has_extension_3:get_slot_data(str).item_data.name ~= "dr_steam_pistol" then
						return
					end

					if not arg_21_2.combo_headshots then
						arg_21_2.combo_headshots = 0
					end

					if not (not arg_21_2.shots_fired and not (arg_21_2.shots_fired - arg_21_2.combo_headshots > 1)) then
						arg_21_2.shots_fired = 1
						arg_21_2.combo_headshots = 0
					end

					arg_21_2.combo_headshots = arg_21_2.combo_headshots + 1

					if arg_21_2.combo_headshots >= 6 then
						self:increment_stat(arg_21_1, "cog_chain_headshot")
					end
				end
			end
		end
	end
}
achievements.cog_pistol_headshot_grind = {
	name = "achv_cog_pistol_headshot_grind_name",
	desc = "achv_cog_pistol_headshot_grind_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_cog_pistol_headshot_grind",
	required_dlc = "cog",
	events = {
		"on_hit"
	},
	progress = function (self, arg_22_1, arg_22_2)
		-- function 22
		local get_persistent_stat = self:get_persistent_stat(arg_22_1, "steam_pistol_headshots")

		return {
			get_persistent_stat,
			1000
		}
	end,
	completed = function (self, arg_23_1, arg_23_2)
		-- function 23
		return self:get_persistent_stat(arg_23_1, "steam_pistol_headshots") >= 1000
	end,
	on_event = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
		-- function 24
		if arg_24_4[num_19] ~= "instant_projectile" then
			return
		end

		local var_24_0 = arg_24_4[num_25]
		local player_unit = Managers.player:local_player().player_unit

		if not (not var_24_0 and player_unit == var_24_0) then
			return
		end

		if arg_24_4[num_20] ~= "head" then
			return
		end

		local var_24_2 = arg_24_4[num_18]

		if not (not var_24_2 and Unit.get_data(var_24_2, "breed")) then
			return
		end

		local var_24_3 = arg_24_4[num_25]
		local has_extension = ScriptUnit.has_extension(var_24_3, "career_system")

		if not (not has_extension and has_extension:career_name() == "dr_engineer") then
			return false
		end

		local has_extension_2 = ScriptUnit.has_extension(var_24_3, "inventory_system")

		if not has_extension_2 then
			local str = "slot_ranged"

			if has_extension_2:get_wielded_slot_name() == str then
				if has_extension_2:get_slot_data(str).item_data.name ~= "dr_steam_pistol" then
					return
				end

				self:increment_stat(arg_24_1, "steam_pistol_headshots")
			end
		end
	end
}
achievements.cog_clutch_pump = {
	name = "achv_cog_clutch_pump_name",
	desc = "achv_cog_clutch_pump_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_cog_clutch_pump",
	required_dlc = "cog",
	events = {
		"clutch_pump"
	},
	progress = function (self, arg_25_1, arg_25_2)
		-- function 25
		local get_persistent_stat = self:get_persistent_stat(arg_25_1, "clutch_pumps")

		return {
			get_persistent_stat,
			100
		}
	end,
	completed = function (self, arg_26_1, arg_26_2)
		-- function 26
		return self:get_persistent_stat(arg_26_1, "clutch_pumps") >= 100
	end,
	on_event = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
		-- function 27
		local get_current_level_keys = Managers.level_transition_handler:get_current_level_keys()
		local flag = not get_current_level_keys and LevelSettings[get_current_level_keys]

		if not (not flag and flag.hub_level) then
			self:increment_stat(arg_27_1, "clutch_pumps")
		end
	end
}
achievements.cog_hammer_cliff_push = {
	name = "achv_cog_hammer_cliff_push_name",
	desc = "achv_cog_hammer_cliff_push_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_cog_hammer_cliff_push",
	required_dlc = "cog",
	events = {
		"register_kill"
	},
	progress = function (self, arg_28_1, arg_28_2)
		-- function 28
		local get_persistent_stat = self:get_persistent_stat(arg_28_1, "hammer_cliff_pushes")

		return {
			get_persistent_stat,
			200
		}
	end,
	completed = function (self, arg_29_1, arg_29_2)
		-- function 29
		return self:get_persistent_stat(arg_29_1, "hammer_cliff_pushes") >= 200
	end,
	on_event = function (self, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
		-- function 30
		local var_30_0 = arg_30_4[num_13]
		local var_30_1 = var_30_0[DamageDataIndex.DAMAGE_TYPE]

		if not (not var_30_1 and var_30_1 == "volume_insta_kill" and var_30_1 == "forced") then
			return
		end

		local var_30_2 = var_30_0[DamageDataIndex.DAMAGE_SOURCE_NAME]

		if not (not var_30_2 and var_30_2 ~= "suicide") then
			local var_30_3 = arg_30_4[num_12]
			local has_extension = ScriptUnit.has_extension(var_30_3, "health_system")

			if not has_extension then
				local recent_damages = has_extension:recent_damages()
				local var_30_6 = recent_damages[DamageDataIndex.DAMAGE_SOURCE_NAME]
				local var_30_7 = rawget(ItemMasterList, var_30_6)

				if not (not var_30_7 and var_30_7.item_type == "dr_cog_hammer") then
					return
				end

				local var_30_8 = recent_damages[DamageDataIndex.ATTACKER]
				local player_unit = Managers.player:local_player().player_unit

				if not (not var_30_8 and player_unit == var_30_8) then
					return
				end

				local has_extension_2 = ScriptUnit.has_extension(var_30_8, "career_system")

				if not (not has_extension_2 and has_extension_2:career_name() == "dr_engineer") then
					return false
				end

				self:increment_stat(arg_30_1, "hammer_cliff_pushes")
			end
		end
	end
}
achievements.cog_only_crank = {
	name = "achv_cog_only_crank_name",
	display_completion_ui = true,
	required_dlc = "cog",
	icon = "achievement_trophy_cog_only_crank",
	desc = "achv_cog_only_crank_desc",
	events = {
		"register_kill",
		"register_completed_level"
	},
	completed = function (self, arg_31_1, arg_31_2)
		-- function 31
		return self:get_persistent_stat(arg_31_1, "cog_only_crank") > 0
	end,
	on_event = function (self, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
		-- function 32
		if arg_32_3 == "register_kill" then
			if not arg_32_2.failed then
				return false
			end

			local var_32_0 = arg_32_4[num_13]
			local var_32_1 = var_32_0[DamageDataIndex.SOURCE_ATTACKER_UNIT]
			local has_extension = ScriptUnit.has_extension(var_32_1, "career_system")

			if not (not has_extension and has_extension:career_name() == "dr_engineer") then
				return false
			end

			local var_32_3 = var_32_0[DamageDataIndex.DAMAGE_SOURCE_NAME]

			if not (var_32_3 == "bardin_engineer_career_skill_weapon" or var_32_3 == "bardin_engineer_career_skill_weapon_heavy") then
				arg_32_2.failed = true

				return false
			end
		else
			if not (arg_32_4[num_29] ~= "dr_engineer" or arg_32_2.failed) then
				local var_32_4 = arg_32_4[num_30]

				if not (not var_32_4 and var_32_4.bot_player) then
					self:increment_stat(arg_32_1, "cog_only_crank")
				end
			end

			arg_32_2.failed = nil
		end
	end
}
achievements.cog_exploding_barrel_kills = {
	display_completion_ui = true,
	name = "achv_cog_exploding_barrel_kills_name",
	required_dlc = "cog",
	icon = "achievement_trophy_cog_exploding_barrel_kills",
	desc = "achv_cog_exploding_barrel_kills_desc",
	events = {
		"register_kill",
		"explosive_barrel_destroyed"
	},
	completed = function (self, arg_33_1, arg_33_2)
		-- function 33
		if self:get_persistent_stat(arg_33_1, "cog_exploding_barrel_kills") > 0 then
			print("completed")
		end

		return self:get_persistent_stat(arg_33_1, "cog_exploding_barrel_kills") > 0
	end,
	on_event = function (self, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
		-- function 34
		if arg_34_3 == "register_kill" then
			local var_34_0 = arg_34_4[num_13]
			local var_34_1 = var_34_0[DamageDataIndex.DAMAGE_SOURCE_NAME]
			local player_unit = Managers.player:local_player().player_unit
			local var_34_3 = var_34_0[DamageDataIndex.ATTACKER]

			if not (not var_34_3 and player_unit == var_34_3) then
				return false
			end

			if var_34_1 ~= "explosive_barrel" then
				return false
			end

			local has_extension = ScriptUnit.has_extension(var_34_3, "career_system")

			if not (not has_extension and has_extension:career_name() == "dr_engineer") then
				return false
			end

			local str = "cog_exploding_barrel_kills"
			local get_local_stat = self:get_local_stat("cog_exploding_barrel_kills")

			if not get_local_stat then
				return false
			end

			local num = get_local_stat + 1

			if num >= 10 then
				self:increment_stat(arg_34_1, str)
			else
				self:set_local_stat("cog_exploding_barrel_kills", num)
			end
		elseif arg_34_3 == "explosive_barrel_destroyed" then
			if arg_34_4[num_32] == arg_34_4[num_33][DamageDataIndex.ATTACKER] then
				self:set_local_stat("cog_exploding_barrel_kills", nil)
			else
				self:set_local_stat("cog_exploding_barrel_kills", 0)
			end
		end
	end
}
achievements.cog_long_crank_fire = {
	display_completion_ui = true,
	name = "achv_cog_long_crank_fire_name",
	required_dlc = "cog",
	icon = "achievement_trophy_cog_long_crank_fire",
	desc = "achv_cog_long_crank_fire_desc",
	events = {
		"crank_gun_fire_start",
		"crank_gun_fire"
	},
	completed = function (self, arg_35_1, arg_35_2)
		-- function 35
		return self:get_persistent_stat(arg_35_1, "cog_long_crank_fire") > 0
	end,
	on_event = function (self, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
		-- function 36
		if arg_36_3 == "crank_gun_fire_start" then
			arg_36_2.start_time = Managers.time:time("game")
		elseif arg_36_3 == "crank_gun_fire" then
			local start_time = arg_36_2.start_time

			if Managers.time:time("game") - start_time >= 40 then
				self:increment_stat(arg_36_1, "cog_long_crank_fire")
			end
		end
	end
}

local tbl_3 = {}

for k, v in pairs(Breeds) do
	if Breeds[k].elite == true then
		tbl_3[#tbl_3 + 1] = k
	end

	if Breeds[k].special == true then
		tbl_3[#tbl_3 + 1] = k
	end

	if k == "chaos_exalted_sorcerer" then
		tbl_3[#tbl_3 + 1] = k
	end
end

local tbl_4 = {
	dr_steam_pistol = "dr_steam_pistol",
	dr_cog_hammer = "dr_2h_cog_hammer",
	bardin_engineer_career_skill_weapon = "bardin_engineer_career_skill_weapon",
	bardin_engineer_career_skill_weapon_heavy = "bardin_engineer_career_skill_weapon_heavy"
}
local set = table.set(table.keys(tbl_4), nil)

achievements.cog_kill_register = {
	display_completion_ui = false,
	required_dlc = "cog",
	events = {
		"register_kill"
	},
	completed = function (self, arg_37_1, arg_37_2)
		-- function 37
		local num = 0

		for i = 1, #tbl_3 do
			num = num + self:get_persistent_stat(arg_37_1, "weapon_kills_per_breed", "dr_steam_pistol", tbl_3[i])
		end

		local flag = num >= 150
		local flag_2 = 0 + self:get_persistent_stat(arg_37_1, "weapon_kills_per_breed", "bardin_engineer_career_skill_weapon_heavy", "skaven_ratling_gunner") + self:get_persistent_stat(arg_37_1, "weapon_kills_per_breed", "bardin_engineer_career_skill_weapon", "skaven_ratling_gunner") >= 15
		local get_persistent_stat = self:get_persistent_stat(arg_37_1, "weapon_kills_per_breed", "dr_2h_cog_hammer", "chaos_vortex_sorcerer")
		local get_persistent_stat_2 = self:get_persistent_stat(arg_37_1, "weapon_kills_per_breed", "dr_2h_cog_hammer", "chaos_corruptor_sorcerer")
		local get_persistent_stat_3 = self:get_persistent_stat(arg_37_1, "weapon_kills_per_breed", "dr_2h_cog_hammer", "chaos_exalted_sorcerer")
		local flag_3 = not (get_persistent_stat >= 1) or not (get_persistent_stat_2 >= 1) or get_persistent_stat_3 >= 1

		return not flag and not flag_2 and flag_3
	end,
	on_event = function (self, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
		-- function 38
		local var_38_0 = arg_38_4[3]
		local var_38_1 = var_38_0[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_38_2 = rawget(ItemMasterList, var_38_1)
		local flag = not var_38_2 and var_38_2.item_type

		if not set[flag] then
			return
		end

		local flag_2 = not var_38_0 and var_38_0[DamageDataIndex.ATTACKER]

		if not ALIVE[flag_2] then
			return
		end

		local local_player = Managers.player:local_player()
		local flag_3 = not local_player and local_player.player_unit

		if not (not flag_3 and flag_3 == flag_2) then
			return
		end

		local has_extension = ScriptUnit.has_extension(flag_2, "career_system")

		if not (not has_extension and has_extension:career_name() == "dr_engineer") then
			return false
		end

		local var_38_8 = arg_38_4[4]

		if not table.contains(tbl_3, var_38_8.name) then
			return false
		end

		if not var_38_8 and not var_38_8.name then
			local var_38_9 = tbl_4[flag]

			self:increment_stat(arg_38_1, "weapon_kills_per_breed", var_38_9, var_38_8.name)
		end
	end
}
achievements.cog_missing_cog = {
	required_dlc = "cog",
	name = "achv_cog_missing_cog_name",
	allow_in_inn = true,
	display_completion_ui = true,
	icon = "achievement_trophy_cog_missing_cog",
	desc = "achv_cog_missing_cog_desc",
	completed = function (self, arg_39_1)
		-- function 39
		return self:get_persistent_stat(arg_39_1, "cog_missing_cog") > 0
	end
}

local act_1 = GameActs.act_1
local act_2 = GameActs.act_2
local act_3 = GameActs.act_3
local rank = DifficultySettings.hardest.rank

add_levels_complete_per_hero_challenge(achievements, "cog_mission_streak_act1_legend", act_1, rank, "dr_engineer", true, "achievement_trophy_cog_mission_streak_act1_legend_dr_engineer", "cog_upgrade", nil, nil)
add_levels_complete_per_hero_challenge(achievements, "cog_mission_streak_act2_legend", act_2, rank, "dr_engineer", true, "achievement_trophy_cog_mission_streak_act2_legend_dr_engineer", "cog_upgrade", nil, nil)
add_levels_complete_per_hero_challenge(achievements, "cog_mission_streak_act3_legend", act_3, rank, "dr_engineer", true, "achievement_trophy_cog_mission_streak_act3_legend_dr_engineer", "cog_upgrade", nil, nil)
add_multi_stat_count_challenge(achievements, "cog_crank_kill", {
	"cog_kills_bardin_engineer_career_skill_weapon",
	"cog_kills_bardin_engineer_career_skill_weapon_heavy"
}, 3000, "achievement_trophy_cog_crank_kill", "cog_upgrade")
add_stat_count_challenge(achievements, "cog_hammer_axe_kills", "cog_kills_dr_2h_cog_hammer", 1000, nil, "achievement_trophy_cog_hammer_axe_kills", "cog_upgrade")

local tbl_5 = {
	dr_2h_cog_hammer = {
		"dr_2h_cog_hammer"
	},
	dr_steam_pistol = {
		"dr_steam_pistol"
	},
	bardin_engineer_career_skill_weapon = {
		"bardin_engineer_career_skill_weapon",
		"bardin_engineer_career_skill_weapon_heavy"
	}
}

add_weapon_kills_per_breeds_challenge(achievements, "cog_crank_kill_ratling", tbl_5.bardin_engineer_career_skill_weapon, {
	"skaven_ratling_gunner"
}, 15, "achievement_trophy_cog_crank_kill_ratling", "cog", true, nil, nil)
add_weapon_kills_per_breeds_challenge(achievements, "cog_steam_elite_kill", tbl_5.dr_steam_pistol, tbl_3, 150, "achievement_trophy_cog_steam_elite_kill", "cog_upgrade", true, nil, nil)
add_weapon_kills_per_breeds_challenge(achievements, "cog_hammer_kill_storm", tbl_5.dr_2h_cog_hammer, {
	"chaos_vortex_sorcerer"
}, 1, nil, "cog_upgrade", false, nil, nil)
add_weapon_kills_per_breeds_challenge(achievements, "cog_hammer_kill_leech", tbl_5.dr_2h_cog_hammer, {
	"chaos_corruptor_sorcerer"
}, 1, nil, "cog_upgrade", false, nil, nil)
add_weapon_kills_per_breeds_challenge(achievements, "cog_hammer_kill_hale", tbl_5.dr_2h_cog_hammer, {
	"chaos_exalted_sorcerer"
}, 1, nil, "cog_upgrade", false, nil, nil)

local HelmgartLevels = HelmgartLevels
local tbl_6 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}

for k_2 = 1, #tbl_6 do
	local var_0_57 = tbl_6[k_2]
	local str = "cog_complete_all_helmgart_levels_" .. DifficultyMapping[var_0_57]

	add_levels_complete_per_hero_challenge(achievements, str, HelmgartLevels, DifficultySettings[var_0_57].rank, "dr_engineer", false, nil, "cog_upgrade", nil, nil)
end

add_career_mission_count_challenge(achievements, "cog_complete_100_missions", "completed_career_levels", "dr_engineer", tbl_6, 25, nil, "achievement_trophy_cog_complete_25_missions_dr_engineer", "cog_upgrade", nil, nil)

local tbl_7 = {
	"cog_climb_kill",
	"cog_chain_headshot",
	"cog_crank_kill_ratling",
	"cog_pistol_headshot_grind",
	"cog_clutch_pump",
	"cog_hammer_cliff_push",
	"cog_only_crank",
	"cog_exploding_barrel_kills",
	"cog_long_crank_fire",
	"cog_missing_cog",
	"cog_complete_100_missions_dr_engineer",
	"cog_penta_bomb",
	"cog_crank_kill",
	"cog_kill_barrage",
	"cog_all_kill_barrage",
	"cog_long_bomb",
	"cog_hammer_axe_kills",
	"cog_wizard_hammer",
	"cog_steam_elite_kill",
	"cog_steam_alt",
	"cog_bomb_grind"
}
local tbl_8 = {
	"cog_hammer_kill_storm",
	"cog_hammer_kill_leech",
	"cog_hammer_kill_hale"
}

add_meta_challenge(achievements, "complete_all_engineer_challenges", tbl_7, "achievement_trophy_complete_all_engineer_challenges", "cog_upgrade", nil, nil)
add_meta_challenge(achievements, "cog_wizard_hammer", tbl_8, "achievement_trophy_cog_wizard_hammer", "cog_upgrade", nil, nil)
