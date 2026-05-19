-- chunkname: @scripts/managers/achievements/achievement_templates_cog.lua

local var_0_0 = AchievementTemplateHelper.PLACEHOLDER_ICON
local var_0_1 = AchievementTemplates.achievements
local var_0_2 = DLCSettings.cog
local var_0_3 = AchievementTemplateHelper.add_levels_complete_per_hero_challenge
local var_0_4 = AchievementTemplateHelper.add_weapon_kill_challenge
local var_0_5 = AchievementTemplateHelper.add_career_mission_count_challenge
local var_0_6 = AchievementTemplateHelper.add_meta_challenge
local var_0_7 = AchievementTemplateHelper.add_weapon_kills_per_breeds_challenge
local var_0_8 = AchievementTemplateHelper.add_multi_stat_count_challenge
local var_0_9 = AchievementTemplateHelper.add_event_challenge
local var_0_10 = AchievementTemplateHelper.add_stat_count_challenge
local var_0_11 = {}
local var_0_12 = {}

local function var_0_13(arg_1_0, arg_1_1)
	local var_1_0 = Managers.player:unit_owner(arg_1_0)

	if var_1_0 and not var_1_0.bot_player then
		local var_1_1 = var_1_0:network_id()
		local var_1_2 = Managers.state.network
		local var_1_3 = NetworkLookup.statistics[arg_1_1]

		var_1_2.network_transmit:send_rpc("rpc_increment_stat", var_1_1, var_1_3)
	end
end

local var_0_14 = 1
local var_0_15 = 2
local var_0_16 = 3
local var_0_17 = 4
local var_0_18 = 5
local var_0_19 = 1
local var_0_20 = 2
local var_0_21 = 3
local var_0_22 = 1
local var_0_23 = 2
local var_0_24 = 1
local var_0_25 = 2
local var_0_26 = 3
local var_0_27 = 4
local var_0_28 = 1
local var_0_29 = 2
local var_0_30 = 1
local var_0_31 = 1
local var_0_32 = 2
local var_0_33 = 3
local var_0_34 = 4
local var_0_35 = 5
local var_0_36 = 6
local var_0_37 = 7
local var_0_38 = 8
local var_0_39 = 1
local var_0_40 = 1
local var_0_41 = 2
local var_0_42 = 3
local var_0_43 = 4
local var_0_44 = 1
local var_0_45 = 2
local var_0_46 = 3

var_0_1.cog_penta_bomb = {
	name = "achv_cog_penta_bomb_name",
	required_dlc_extra = "cog",
	desc = "achv_cog_penta_bomb_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_cog_penta_bomb",
	required_dlc = "cog_upgrade",
	events = {
		"register_damage"
	},
	completed = function(arg_2_0, arg_2_1, arg_2_2)
		return arg_2_0:get_persistent_stat(arg_2_1, "cog_penta_bomb") > 0
	end,
	on_event = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		local var_3_0 = arg_3_4[var_0_16]
		local var_3_1 = var_3_0[DamageDataIndex.DAMAGE_TYPE]
		local var_3_2 = var_3_0[DamageDataIndex.SOURCE_ATTACKER_UNIT]
		local var_3_3 = Managers.player:local_player().player_unit

		if not var_3_2 or var_3_3 ~= var_3_2 then
			return
		end

		if var_3_1 ~= "grenade" then
			return
		end

		local var_3_4 = arg_3_4[var_0_18]

		if not var_3_4 or not var_3_4.boss then
			return
		end

		local var_3_5 = ScriptUnit.has_extension(var_3_2, "career_system")

		if not var_3_5 or var_3_5:career_name() ~= "dr_engineer" then
			return
		end

		local var_3_6 = arg_3_4[var_0_15]

		if not ALIVE[arg_3_2.current_target_unit] or arg_3_2.current_target_unit ~= var_3_6 then
			arg_3_2.current_target_unit = var_3_6
			arg_3_2.counter = 0
		end

		arg_3_2.counter = arg_3_2.counter + 1

		if arg_3_2.counter > 4 then
			arg_3_0:increment_stat(arg_3_1, "cog_penta_bomb")
		end
	end
}
var_0_1.cog_air_bomb = {
	name = "achv_cog_air_bomb_name",
	required_dlc_extra = "cog",
	desc = "achv_cog_air_bomb_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_cog_air_bomb",
	required_dlc = "cog_upgrade",
	events = {
		"rat_ogre_stagger"
	},
	completed = function(arg_4_0, arg_4_1, arg_4_2)
		return arg_4_0:get_persistent_stat(arg_4_1, "cog_air_bomb") > 0
	end,
	on_event = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		local var_5_0 = arg_5_4[var_0_21]
		local var_5_1 = ScriptUnit.has_extension(var_5_0, "career_system")

		if not var_5_1 or var_5_1:career_name() ~= "dr_engineer" then
			return false
		end

		local var_5_2 = arg_5_4[var_0_19]
		local var_5_3, var_5_4 = ScriptUnit.has_extension(var_5_2, "health_system"):recently_damaged()

		if var_5_3 ~= "grenade" then
			return
		end

		if ScriptUnit.has_extension(var_5_2, "ai_system"):current_action_name() == "jump_slam" then
			var_0_13(var_5_0, "cog_air_bomb")
		end
	end
}
var_0_1.cog_kill_barrage = {
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
	completed = function(arg_6_0, arg_6_1, arg_6_2)
		return arg_6_0:get_persistent_stat(arg_6_1, "cog_kill_barrage") > 0
	end,
	on_event = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
		if arg_7_3 == "crank_gun_fire" then
			if not arg_7_2.time then
				arg_7_2.time = 0
			end

			local var_7_0 = Managers.time:time("game")

			if arg_7_4[var_0_23] < var_7_0 - arg_7_2.time then
				arg_7_2.kill_count = 0
			end

			arg_7_2.time = var_7_0

			return false
		end

		local var_7_1 = arg_7_4[var_0_26]
		local var_7_2 = var_7_1[DamageDataIndex.SOURCE_ATTACKER_UNIT]
		local var_7_3 = Managers.player:local_player().player_unit

		if not var_7_2 or var_7_3 ~= var_7_2 then
			return
		end

		local var_7_4 = var_7_1[DamageDataIndex.DAMAGE_SOURCE_NAME]

		if var_7_4 ~= "bardin_engineer_career_skill_weapon" and var_7_4 ~= "bardin_engineer_career_skill_weapon_heavy" then
			return
		end

		local var_7_5 = ScriptUnit.has_extension(var_7_2, "career_system")

		if not var_7_5 or var_7_5:career_name() ~= "dr_engineer" then
			return
		end

		arg_7_2.kill_count = (arg_7_2.kill_count or 0) + 1

		if arg_7_2.kill_count >= 50 then
			arg_7_0:increment_stat(arg_7_1, "cog_kill_barrage")
		end
	end
}
var_0_1.cog_all_kill_barrage = {
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
	completed = function(arg_8_0, arg_8_1, arg_8_2)
		return arg_8_0:get_persistent_stat(arg_8_1, "cog_all_kill_barrage") > 0
	end,
	on_event = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
		if arg_9_3 == "crank_gun_fire" then
			if not arg_9_2.time then
				arg_9_2.time = 0
			end

			local var_9_0 = Managers.time:time("game")

			if arg_9_4[var_0_23] < var_9_0 - arg_9_2.time then
				arg_9_2.kill_count = {}
			end

			arg_9_2.time = var_9_0

			return false
		else
			local var_9_1 = arg_9_4[var_0_26]
			local var_9_2 = var_9_1[DamageDataIndex.SOURCE_ATTACKER_UNIT]
			local var_9_3 = var_9_1[DamageDataIndex.DAMAGE_SOURCE_NAME]

			if not var_9_2 or var_9_3 ~= "bardin_engineer_career_skill_weapon" and var_9_3 ~= "bardin_engineer_career_skill_weapon_heavy" then
				return false
			end

			if Managers.player:local_player().player_unit ~= var_9_2 then
				return
			end

			local var_9_4 = ScriptUnit.has_extension(var_9_2, "career_system")

			if not var_9_4 or var_9_4:career_name() ~= "dr_engineer" then
				return false
			end

			if not arg_9_2.kill_count then
				arg_9_2.kill_count = {}
			end

			local var_9_5 = arg_9_4[var_0_27]

			if var_9_5 then
				if var_9_5.elite then
					arg_9_2.kill_count[1] = true
				elseif var_9_5.special then
					arg_9_2.kill_count[2] = true
				elseif var_9_5.boss then
					arg_9_2.kill_count[3] = true
				end

				if #arg_9_2.kill_count >= 3 then
					arg_9_0:increment_stat(arg_9_1, "cog_all_kill_barrage")
				end
			end
		end
	end
}
var_0_1.cog_climb_kill = {
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
	progress = function(arg_10_0, arg_10_1, arg_10_2)
		local var_10_0 = arg_10_0:get_persistent_stat(arg_10_1, "climbing_enemies_killed")

		return {
			var_10_0,
			100
		}
	end,
	completed = function(arg_11_0, arg_11_1, arg_11_2)
		return arg_11_0:get_persistent_stat(arg_11_1, "climbing_enemies_killed") >= 100
	end,
	on_event = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
		if not Managers.state.network.is_server then
			return
		end

		local var_12_0 = arg_12_4[var_0_26]
		local var_12_1 = var_12_0[DamageDataIndex.DAMAGE_SOURCE_NAME]

		if var_12_1 ~= "bardin_engineer_career_skill_weapon" and var_12_1 ~= "bardin_engineer_career_skill_weapon_heavy" then
			return
		end

		local var_12_2 = var_12_0[DamageDataIndex.ATTACKER]

		if not var_12_2 then
			return false
		end

		local var_12_3 = ScriptUnit.has_extension(var_12_2, "career_system")

		if not var_12_3 or var_12_3:career_name() ~= "dr_engineer" then
			return false
		end

		local var_12_4 = arg_12_4[var_0_25]
		local var_12_5 = BLACKBOARDS[var_12_4]

		if not var_12_5 then
			return
		end

		local var_12_6 = var_12_5.locomotion_extension

		if var_12_6 and var_12_6.movement_type and var_12_6.movement_type == "script_driven" then
			local var_12_7 = var_12_0[DamageDataIndex.ATTACKER]

			var_0_13(var_12_7, "climbing_enemies_killed")
		end
	end
}
var_0_1.cog_long_bomb = {
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
	completed = function(arg_13_0, arg_13_1, arg_13_2)
		return arg_13_0:get_persistent_stat(arg_13_1, "cog_long_bomb") > 0
	end,
	on_event = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
		if arg_14_3 == "on_grenade_thrown" then
			local var_14_0 = arg_14_4[var_0_28]

			if not var_14_0 then
				return false
			end

			local var_14_1 = POSITION_LOOKUP[var_14_0]

			arg_14_2.throw_position = Vector3Box(var_14_1)
		else
			if not arg_14_2.throw_position then
				return false
			end

			local var_14_2 = arg_14_4[var_0_26]
			local var_14_3 = Managers.player:local_player().player_unit
			local var_14_4 = var_14_2[DamageDataIndex.ATTACKER]

			if var_14_4 and var_14_3 ~= var_14_4 then
				return false
			end

			local var_14_5 = var_14_2[DamageDataIndex.DAMAGE_SOURCE_NAME]

			if var_14_5 ~= "grenade_frag_01" and var_14_5 ~= "grenade_frag_02" then
				return false
			end

			local var_14_6 = var_14_2[DamageDataIndex.ATTACKER]

			if not var_14_6 then
				return
			end

			local var_14_7 = ScriptUnit.has_extension(var_14_6, "career_system")

			if not var_14_7 or var_14_7:career_name() ~= "dr_engineer" then
				return
			end

			if arg_14_4[var_0_27].name == "skaven_ratling_gunner" then
				local var_14_8 = arg_14_2.throw_position:unbox()
				local var_14_9 = arg_14_4[var_0_25]
				local var_14_10 = POSITION_LOOKUP[var_14_9]

				if Vector3.distance(var_14_10, var_14_8) > 25 then
					arg_14_0:increment_stat(arg_14_1, "cog_long_bomb")
				end
			end
		end
	end
}
var_0_1.cog_steam_alt = {
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
	completed = function(arg_15_0, arg_15_1, arg_15_2)
		return arg_15_0:get_persistent_stat(arg_15_1, "cog_steam_alt") > 0
	end,
	on_event = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
		if arg_16_3 == "steam_alt_fire" then
			if not arg_16_2.shot_counter then
				arg_16_2.hit_counter = 0
				arg_16_2.shot_counter = 0
			end

			arg_16_2.shot_counter = arg_16_2.shot_counter + 1

			if arg_16_2.shot_counter - arg_16_2.hit_counter > 1 or arg_16_2.shot_counter - arg_16_2.hit_counter < -1 then
				arg_16_2.hit_counter = 0
				arg_16_2.shot_counter = 0
			end
		else
			if not arg_16_2.shot_counter then
				return
			end

			local var_16_0 = arg_16_4[var_0_16][DamageDataIndex.DAMAGE_SOURCE_NAME]
			local var_16_1 = rawget(ItemMasterList, var_16_0)

			if not (var_16_1 and var_16_1.item_type == "dr_steam_pistol") then
				return
			end

			local var_16_2 = arg_16_4[var_0_18]

			if not var_16_2 or not var_16_2.boss then
				return
			end

			local var_16_3 = arg_16_4[var_0_17]
			local var_16_4 = ScriptUnit.has_extension(var_16_3, "career_system")

			if not var_16_4 or var_16_4:career_name() ~= "dr_engineer" then
				return
			end

			arg_16_2.hit_counter = arg_16_2.hit_counter + 1

			if arg_16_2.shot_counter - arg_16_2.hit_counter >= 1 or arg_16_2.shot_counter - arg_16_2.hit_counter <= -1 then
				arg_16_2.hit_counter = 0
				arg_16_2.shot_counter = 0
			end

			if arg_16_2.hit_counter >= 12 then
				arg_16_0:increment_stat(arg_16_1, "cog_steam_alt")
			end
		end
	end
}
var_0_1.cog_bomb_grind = {
	name = "achv_cog_bomb_grind_name",
	required_dlc_extra = "cog",
	desc = "achv_cog_bomb_grind_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_cog_bomb_grind",
	required_dlc = "cog_upgrade",
	events = {
		"register_kill"
	},
	progress = function(arg_17_0, arg_17_1, arg_17_2)
		local var_17_0 = arg_17_0:get_persistent_stat(arg_17_1, "cog_bomb_kills")

		return {
			var_17_0,
			500
		}
	end,
	completed = function(arg_18_0, arg_18_1, arg_18_2)
		return arg_18_0:get_persistent_stat(arg_18_1, "cog_bomb_kills") >= 500
	end,
	on_event = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
		local var_19_0 = arg_19_4[var_0_26]
		local var_19_1 = var_19_0[DamageDataIndex.DAMAGE_TYPE]

		if var_19_1 ~= "grenade" and var_19_1 ~= "grenade_glance" then
			return false
		end

		local var_19_2 = Managers.player:local_player().player_unit
		local var_19_3 = var_19_0[DamageDataIndex.ATTACKER]

		if var_19_3 and var_19_2 ~= var_19_3 then
			return false
		end

		if (var_19_1 == "burninating" or var_19_1 == "burn") and not DamageUtils.attacker_is_fire_bomb(var_19_3) then
			return
		end

		local var_19_4 = var_19_0[DamageDataIndex.DAMAGE_SOURCE_NAME]

		if var_19_4 == "grenade_frag_01" or var_19_4 == "grenade_frag_02" or var_19_4 == "dot_debuff" or var_19_4 == "grenade_fire_01" or var_19_4 == "grenade_fire_02" then
			local var_19_5 = var_19_0[DamageDataIndex.ATTACKER]

			if var_19_4 == "dot_debuff" then
				var_19_5 = var_19_0[DamageDataIndex.SOURCE_ATTACKER_UNIT]
			end

			local var_19_6 = ScriptUnit.has_extension(var_19_5, "career_system")

			if not var_19_6 or var_19_6:career_name() ~= "dr_engineer" then
				return false
			end

			arg_19_0:increment_stat(arg_19_1, "cog_bomb_kills")
		end
	end
}
var_0_1.cog_chain_headshot = {
	display_completion_ui = true,
	name = "achv_cog_chain_headshot_name",
	required_dlc = "cog",
	icon = "achievement_trophy_cog_chain_headshot",
	desc = "achv_cog_chain_headshot_desc",
	events = {
		"on_hit",
		"ammo_used"
	},
	completed = function(arg_20_0, arg_20_1, arg_20_2)
		return arg_20_0:get_persistent_stat(arg_20_1, "cog_chain_headshot") > 0
	end,
	on_event = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
		if arg_21_3 == "ammo_used" then
			local var_21_0 = arg_21_4[var_0_30]
			local var_21_1 = ScriptUnit.has_extension(var_21_0, "career_system")

			if not var_21_1 or var_21_1:career_name() ~= "dr_engineer" then
				return false
			end

			arg_21_2.shots_fired = arg_21_2.shots_fired or 0
			arg_21_2.shots_fired = arg_21_2.shots_fired + 1
		else
			local var_21_2 = arg_21_4[var_0_34]
			local var_21_3 = arg_21_4[var_0_38]
			local var_21_4 = arg_21_4[var_0_38]
			local var_21_5 = Managers.player:local_player().player_unit

			if not var_21_4 or var_21_5 ~= var_21_4 then
				return
			end

			if var_21_2 > 1 then
				return
			end

			if arg_21_4[var_0_32] ~= "instant_projectile" then
				return
			end

			if arg_21_4[var_0_33] ~= "head" then
				return
			end

			local var_21_6 = arg_21_4[var_0_31]
			local var_21_7 = var_21_6 and Unit.get_data(var_21_6, "breed")

			if not var_21_7 or not var_21_7.elite then
				return
			end

			local var_21_8 = ScriptUnit.has_extension(var_21_3, "career_system")

			if not var_21_8 or var_21_8:career_name() ~= "dr_engineer" then
				return false
			end

			local var_21_9 = ScriptUnit.has_extension(var_21_3, "inventory_system")

			if var_21_9 then
				local var_21_10 = "slot_ranged"

				if var_21_9:get_wielded_slot_name() == var_21_10 then
					if var_21_9:get_slot_data(var_21_10).item_data.name ~= "dr_steam_pistol" then
						return
					end

					if not arg_21_2.combo_headshots then
						arg_21_2.combo_headshots = 0
					end

					if not arg_21_2.shots_fired or arg_21_2.shots_fired - arg_21_2.combo_headshots > 1 then
						arg_21_2.shots_fired = 1
						arg_21_2.combo_headshots = 0
					end

					arg_21_2.combo_headshots = arg_21_2.combo_headshots + 1

					if arg_21_2.combo_headshots >= 6 then
						arg_21_0:increment_stat(arg_21_1, "cog_chain_headshot")
					end
				end
			end
		end
	end
}
var_0_1.cog_pistol_headshot_grind = {
	name = "achv_cog_pistol_headshot_grind_name",
	desc = "achv_cog_pistol_headshot_grind_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_cog_pistol_headshot_grind",
	required_dlc = "cog",
	events = {
		"on_hit"
	},
	progress = function(arg_22_0, arg_22_1, arg_22_2)
		local var_22_0 = arg_22_0:get_persistent_stat(arg_22_1, "steam_pistol_headshots")

		return {
			var_22_0,
			1000
		}
	end,
	completed = function(arg_23_0, arg_23_1, arg_23_2)
		return arg_23_0:get_persistent_stat(arg_23_1, "steam_pistol_headshots") >= 1000
	end,
	on_event = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
		if arg_24_4[var_0_32] ~= "instant_projectile" then
			return
		end

		local var_24_0 = arg_24_4[var_0_38]
		local var_24_1 = Managers.player:local_player().player_unit

		if not var_24_0 or var_24_1 ~= var_24_0 then
			return
		end

		if arg_24_4[var_0_33] ~= "head" then
			return
		end

		local var_24_2 = arg_24_4[var_0_31]

		if not (var_24_2 and Unit.get_data(var_24_2, "breed")) then
			return
		end

		local var_24_3 = arg_24_4[var_0_38]
		local var_24_4 = ScriptUnit.has_extension(var_24_3, "career_system")

		if not var_24_4 or var_24_4:career_name() ~= "dr_engineer" then
			return false
		end

		local var_24_5 = ScriptUnit.has_extension(var_24_3, "inventory_system")

		if var_24_5 then
			local var_24_6 = "slot_ranged"

			if var_24_5:get_wielded_slot_name() == var_24_6 then
				if var_24_5:get_slot_data(var_24_6).item_data.name ~= "dr_steam_pistol" then
					return
				end

				arg_24_0:increment_stat(arg_24_1, "steam_pistol_headshots")
			end
		end
	end
}
var_0_1.cog_clutch_pump = {
	name = "achv_cog_clutch_pump_name",
	desc = "achv_cog_clutch_pump_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_cog_clutch_pump",
	required_dlc = "cog",
	events = {
		"clutch_pump"
	},
	progress = function(arg_25_0, arg_25_1, arg_25_2)
		local var_25_0 = arg_25_0:get_persistent_stat(arg_25_1, "clutch_pumps")

		return {
			var_25_0,
			100
		}
	end,
	completed = function(arg_26_0, arg_26_1, arg_26_2)
		return arg_26_0:get_persistent_stat(arg_26_1, "clutch_pumps") >= 100
	end,
	on_event = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
		local var_27_0 = Managers.level_transition_handler:get_current_level_keys()
		local var_27_1 = var_27_0 and LevelSettings[var_27_0]

		if not (var_27_1 and var_27_1.hub_level) then
			arg_27_0:increment_stat(arg_27_1, "clutch_pumps")
		end
	end
}
var_0_1.cog_hammer_cliff_push = {
	name = "achv_cog_hammer_cliff_push_name",
	desc = "achv_cog_hammer_cliff_push_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_cog_hammer_cliff_push",
	required_dlc = "cog",
	events = {
		"register_kill"
	},
	progress = function(arg_28_0, arg_28_1, arg_28_2)
		local var_28_0 = arg_28_0:get_persistent_stat(arg_28_1, "hammer_cliff_pushes")

		return {
			var_28_0,
			200
		}
	end,
	completed = function(arg_29_0, arg_29_1, arg_29_2)
		return arg_29_0:get_persistent_stat(arg_29_1, "hammer_cliff_pushes") >= 200
	end,
	on_event = function(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
		local var_30_0 = arg_30_4[var_0_26]
		local var_30_1 = var_30_0[DamageDataIndex.DAMAGE_TYPE]

		if not var_30_1 or var_30_1 ~= "volume_insta_kill" and var_30_1 ~= "forced" then
			return
		end

		local var_30_2 = var_30_0[DamageDataIndex.DAMAGE_SOURCE_NAME]

		if var_30_2 and var_30_2 == "suicide" then
			local var_30_3 = arg_30_4[var_0_25]
			local var_30_4 = ScriptUnit.has_extension(var_30_3, "health_system")

			if var_30_4 then
				local var_30_5 = var_30_4:recent_damages()
				local var_30_6 = var_30_5[DamageDataIndex.DAMAGE_SOURCE_NAME]
				local var_30_7 = rawget(ItemMasterList, var_30_6)

				if not (var_30_7 and var_30_7.item_type == "dr_cog_hammer") then
					return
				end

				local var_30_8 = var_30_5[DamageDataIndex.ATTACKER]
				local var_30_9 = Managers.player:local_player().player_unit

				if not var_30_8 or var_30_9 ~= var_30_8 then
					return
				end

				local var_30_10 = ScriptUnit.has_extension(var_30_8, "career_system")

				if not var_30_10 or var_30_10:career_name() ~= "dr_engineer" then
					return false
				end

				arg_30_0:increment_stat(arg_30_1, "hammer_cliff_pushes")
			end
		end
	end
}
var_0_1.cog_only_crank = {
	name = "achv_cog_only_crank_name",
	display_completion_ui = true,
	required_dlc = "cog",
	icon = "achievement_trophy_cog_only_crank",
	desc = "achv_cog_only_crank_desc",
	events = {
		"register_kill",
		"register_completed_level"
	},
	completed = function(arg_31_0, arg_31_1, arg_31_2)
		return arg_31_0:get_persistent_stat(arg_31_1, "cog_only_crank") > 0
	end,
	on_event = function(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
		if arg_32_3 == "register_kill" then
			if arg_32_2.failed then
				return false
			end

			local var_32_0 = arg_32_4[var_0_26]
			local var_32_1 = var_32_0[DamageDataIndex.SOURCE_ATTACKER_UNIT]
			local var_32_2 = ScriptUnit.has_extension(var_32_1, "career_system")

			if not var_32_2 or var_32_2:career_name() ~= "dr_engineer" then
				return false
			end

			local var_32_3 = var_32_0[DamageDataIndex.DAMAGE_SOURCE_NAME]

			if var_32_3 ~= "bardin_engineer_career_skill_weapon" and var_32_3 ~= "bardin_engineer_career_skill_weapon_heavy" then
				arg_32_2.failed = true

				return false
			end
		else
			if arg_32_4[var_0_42] == "dr_engineer" and not arg_32_2.failed then
				local var_32_4 = arg_32_4[var_0_43]

				if var_32_4 and not var_32_4.bot_player then
					arg_32_0:increment_stat(arg_32_1, "cog_only_crank")
				end
			end

			arg_32_2.failed = nil
		end
	end
}
var_0_1.cog_exploding_barrel_kills = {
	display_completion_ui = true,
	name = "achv_cog_exploding_barrel_kills_name",
	required_dlc = "cog",
	icon = "achievement_trophy_cog_exploding_barrel_kills",
	desc = "achv_cog_exploding_barrel_kills_desc",
	events = {
		"register_kill",
		"explosive_barrel_destroyed"
	},
	completed = function(arg_33_0, arg_33_1, arg_33_2)
		if arg_33_0:get_persistent_stat(arg_33_1, "cog_exploding_barrel_kills") > 0 then
			print("completed")
		end

		return arg_33_0:get_persistent_stat(arg_33_1, "cog_exploding_barrel_kills") > 0
	end,
	on_event = function(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
		if arg_34_3 == "register_kill" then
			local var_34_0 = arg_34_4[var_0_26]
			local var_34_1 = var_34_0[DamageDataIndex.DAMAGE_SOURCE_NAME]
			local var_34_2 = Managers.player:local_player().player_unit
			local var_34_3 = var_34_0[DamageDataIndex.ATTACKER]

			if var_34_3 and var_34_2 ~= var_34_3 then
				return false
			end

			if var_34_1 ~= "explosive_barrel" then
				return false
			end

			local var_34_4 = ScriptUnit.has_extension(var_34_3, "career_system")

			if not var_34_4 or var_34_4:career_name() ~= "dr_engineer" then
				return false
			end

			local var_34_5 = "cog_exploding_barrel_kills"
			local var_34_6 = arg_34_0:get_local_stat("cog_exploding_barrel_kills")

			if not var_34_6 then
				return false
			end

			local var_34_7 = var_34_6 + 1

			if var_34_7 >= 10 then
				arg_34_0:increment_stat(arg_34_1, var_34_5)
			else
				arg_34_0:set_local_stat("cog_exploding_barrel_kills", var_34_7)
			end
		elseif arg_34_3 == "explosive_barrel_destroyed" then
			if arg_34_4[var_0_45] == arg_34_4[var_0_46][DamageDataIndex.ATTACKER] then
				arg_34_0:set_local_stat("cog_exploding_barrel_kills", nil)
			else
				arg_34_0:set_local_stat("cog_exploding_barrel_kills", 0)
			end
		end
	end
}
var_0_1.cog_long_crank_fire = {
	display_completion_ui = true,
	name = "achv_cog_long_crank_fire_name",
	required_dlc = "cog",
	icon = "achievement_trophy_cog_long_crank_fire",
	desc = "achv_cog_long_crank_fire_desc",
	events = {
		"crank_gun_fire_start",
		"crank_gun_fire"
	},
	completed = function(arg_35_0, arg_35_1, arg_35_2)
		return arg_35_0:get_persistent_stat(arg_35_1, "cog_long_crank_fire") > 0
	end,
	on_event = function(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
		if arg_36_3 == "crank_gun_fire_start" then
			arg_36_2.start_time = Managers.time:time("game")
		elseif arg_36_3 == "crank_gun_fire" then
			local var_36_0 = arg_36_2.start_time

			if Managers.time:time("game") - var_36_0 >= 40 then
				arg_36_0:increment_stat(arg_36_1, "cog_long_crank_fire")
			end
		end
	end
}

local var_0_47 = {}

for iter_0_0, iter_0_1 in pairs(Breeds) do
	if Breeds[iter_0_0].elite == true then
		var_0_47[#var_0_47 + 1] = iter_0_0
	end

	if Breeds[iter_0_0].special == true then
		var_0_47[#var_0_47 + 1] = iter_0_0
	end

	if iter_0_0 == "chaos_exalted_sorcerer" then
		var_0_47[#var_0_47 + 1] = iter_0_0
	end
end

local var_0_48 = {
	dr_steam_pistol = "dr_steam_pistol",
	dr_cog_hammer = "dr_2h_cog_hammer",
	bardin_engineer_career_skill_weapon = "bardin_engineer_career_skill_weapon",
	bardin_engineer_career_skill_weapon_heavy = "bardin_engineer_career_skill_weapon_heavy"
}
local var_0_49 = table.set(table.keys(var_0_48), nil)

var_0_1.cog_kill_register = {
	display_completion_ui = false,
	required_dlc = "cog",
	events = {
		"register_kill"
	},
	completed = function(arg_37_0, arg_37_1, arg_37_2)
		local var_37_0 = 0

		for iter_37_0 = 1, #var_0_47 do
			var_37_0 = var_37_0 + arg_37_0:get_persistent_stat(arg_37_1, "weapon_kills_per_breed", "dr_steam_pistol", var_0_47[iter_37_0])
		end

		local var_37_1 = var_37_0 >= 150
		local var_37_2 = 0 + arg_37_0:get_persistent_stat(arg_37_1, "weapon_kills_per_breed", "bardin_engineer_career_skill_weapon_heavy", "skaven_ratling_gunner") + arg_37_0:get_persistent_stat(arg_37_1, "weapon_kills_per_breed", "bardin_engineer_career_skill_weapon", "skaven_ratling_gunner") >= 15
		local var_37_3 = arg_37_0:get_persistent_stat(arg_37_1, "weapon_kills_per_breed", "dr_2h_cog_hammer", "chaos_vortex_sorcerer")
		local var_37_4 = arg_37_0:get_persistent_stat(arg_37_1, "weapon_kills_per_breed", "dr_2h_cog_hammer", "chaos_corruptor_sorcerer")
		local var_37_5 = arg_37_0:get_persistent_stat(arg_37_1, "weapon_kills_per_breed", "dr_2h_cog_hammer", "chaos_exalted_sorcerer")
		local var_37_6 = var_37_3 >= 1 and var_37_4 >= 1 and var_37_5 >= 1

		return var_37_1 and var_37_2 and var_37_6
	end,
	on_event = function(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
		local var_38_0 = arg_38_4[3]
		local var_38_1 = var_38_0[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_38_2 = rawget(ItemMasterList, var_38_1)
		local var_38_3 = var_38_2 and var_38_2.item_type

		if not var_0_49[var_38_3] then
			return
		end

		local var_38_4 = var_38_0 and var_38_0[DamageDataIndex.ATTACKER]

		if not ALIVE[var_38_4] then
			return
		end

		local var_38_5 = Managers.player:local_player()
		local var_38_6 = var_38_5 and var_38_5.player_unit

		if not var_38_6 or var_38_6 ~= var_38_4 then
			return
		end

		local var_38_7 = ScriptUnit.has_extension(var_38_4, "career_system")

		if not var_38_7 or var_38_7:career_name() ~= "dr_engineer" then
			return false
		end

		local var_38_8 = arg_38_4[4]

		if not table.contains(var_0_47, var_38_8.name) then
			return false
		end

		if var_38_8 and var_38_8.name then
			local var_38_9 = var_0_48[var_38_3]

			arg_38_0:increment_stat(arg_38_1, "weapon_kills_per_breed", var_38_9, var_38_8.name)
		end
	end
}
var_0_1.cog_missing_cog = {
	required_dlc = "cog",
	name = "achv_cog_missing_cog_name",
	allow_in_inn = true,
	display_completion_ui = true,
	icon = "achievement_trophy_cog_missing_cog",
	desc = "achv_cog_missing_cog_desc",
	completed = function(arg_39_0, arg_39_1)
		return arg_39_0:get_persistent_stat(arg_39_1, "cog_missing_cog") > 0
	end
}

local var_0_50 = GameActs.act_1
local var_0_51 = GameActs.act_2
local var_0_52 = GameActs.act_3
local var_0_53 = DifficultySettings.hardest.rank

var_0_3(var_0_1, "cog_mission_streak_act1_legend", var_0_50, var_0_53, "dr_engineer", true, "achievement_trophy_cog_mission_streak_act1_legend_dr_engineer", "cog_upgrade", nil, nil)
var_0_3(var_0_1, "cog_mission_streak_act2_legend", var_0_51, var_0_53, "dr_engineer", true, "achievement_trophy_cog_mission_streak_act2_legend_dr_engineer", "cog_upgrade", nil, nil)
var_0_3(var_0_1, "cog_mission_streak_act3_legend", var_0_52, var_0_53, "dr_engineer", true, "achievement_trophy_cog_mission_streak_act3_legend_dr_engineer", "cog_upgrade", nil, nil)
var_0_8(var_0_1, "cog_crank_kill", {
	"cog_kills_bardin_engineer_career_skill_weapon",
	"cog_kills_bardin_engineer_career_skill_weapon_heavy"
}, 3000, "achievement_trophy_cog_crank_kill", "cog_upgrade")
var_0_10(var_0_1, "cog_hammer_axe_kills", "cog_kills_dr_2h_cog_hammer", 1000, nil, "achievement_trophy_cog_hammer_axe_kills", "cog_upgrade")

local var_0_54 = {
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

var_0_7(var_0_1, "cog_crank_kill_ratling", var_0_54.bardin_engineer_career_skill_weapon, {
	"skaven_ratling_gunner"
}, 15, "achievement_trophy_cog_crank_kill_ratling", "cog", true, nil, nil)
var_0_7(var_0_1, "cog_steam_elite_kill", var_0_54.dr_steam_pistol, var_0_47, 150, "achievement_trophy_cog_steam_elite_kill", "cog_upgrade", true, nil, nil)
var_0_7(var_0_1, "cog_hammer_kill_storm", var_0_54.dr_2h_cog_hammer, {
	"chaos_vortex_sorcerer"
}, 1, nil, "cog_upgrade", false, nil, nil)
var_0_7(var_0_1, "cog_hammer_kill_leech", var_0_54.dr_2h_cog_hammer, {
	"chaos_corruptor_sorcerer"
}, 1, nil, "cog_upgrade", false, nil, nil)
var_0_7(var_0_1, "cog_hammer_kill_hale", var_0_54.dr_2h_cog_hammer, {
	"chaos_exalted_sorcerer"
}, 1, nil, "cog_upgrade", false, nil, nil)

local var_0_55 = HelmgartLevels
local var_0_56 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}

for iter_0_2 = 1, #var_0_56 do
	local var_0_57 = var_0_56[iter_0_2]
	local var_0_58 = "cog_complete_all_helmgart_levels_" .. DifficultyMapping[var_0_57]

	var_0_3(var_0_1, var_0_58, var_0_55, DifficultySettings[var_0_57].rank, "dr_engineer", false, nil, "cog_upgrade", nil, nil)
end

var_0_5(var_0_1, "cog_complete_100_missions", "completed_career_levels", "dr_engineer", var_0_56, 25, nil, "achievement_trophy_cog_complete_25_missions_dr_engineer", "cog_upgrade", nil, nil)

local var_0_59 = {
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
local var_0_60 = {
	"cog_hammer_kill_storm",
	"cog_hammer_kill_leech",
	"cog_hammer_kill_hale"
}

var_0_6(var_0_1, "complete_all_engineer_challenges", var_0_59, "achievement_trophy_complete_all_engineer_challenges", "cog_upgrade", nil, nil)
var_0_6(var_0_1, "cog_wizard_hammer", var_0_60, "achievement_trophy_cog_wizard_hammer", "cog_upgrade", nil, nil)
