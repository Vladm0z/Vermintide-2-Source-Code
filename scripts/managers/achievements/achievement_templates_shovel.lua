-- chunkname: @scripts/managers/achievements/achievement_templates_shovel.lua

local var_0_0 = AchievementTemplateHelper.PLACEHOLDER_ICON
local var_0_1 = AchievementTemplates.achievements
local var_0_2 = DLCSettings.shovel
local var_0_3 = AchievementTemplateHelper.rpc_increment_stat
local var_0_4 = AchievementTemplateHelper.rpc_modify_stat
local var_0_5 = AchievementTemplateHelper.add_levels_complete_per_hero_challenge
local var_0_6 = AchievementTemplateHelper.add_career_mission_count_challenge
local var_0_7 = AchievementTemplateHelper.add_meta_challenge
local var_0_8 = {}
local var_0_9 = {}
local var_0_10 = 1
local var_0_11 = 2
local var_0_12 = 3
local var_0_13 = 4
local var_0_14 = 5
local var_0_15 = 1
local var_0_16 = 2
local var_0_17 = 3
local var_0_18 = 4
local var_0_19 = 1
local var_0_20 = 2
local var_0_21 = 3
local var_0_22 = 4
local var_0_23 = 5
local var_0_24 = 6
local var_0_25 = 7
local var_0_26 = 8
local var_0_27 = HelmgartLevels

var_0_5(var_0_1, "shovel_complete_all_helmgart_levels", var_0_27, 2, "bw_necromancer", false, "unexpected_saviour", "shovel", nil, nil)

local var_0_28 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}

var_0_6(var_0_1, "shovel_complete_25_missions", "completed_career_levels", "bw_necromancer", var_0_28, 25, nil, "creeping_death", "shovel", nil, nil)

local var_0_29 = 2500

var_0_1.shovel_sac_vent = {
	display_completion_ui = true,
	name = "achv_sac_vent_name",
	required_career = "bw_necromancer",
	icon = "assistive_sacrifice",
	required_dlc = "shovel",
	desc = function()
		return string.format(Localize("achv_sac_vent_desc"), var_0_29)
	end,
	events = {
		"sacrifice_skeleton"
	},
	progress = function(arg_2_0, arg_2_1, arg_2_2)
		local var_2_0 = arg_2_0:get_persistent_stat(arg_2_1, "shovel_sac_vent")

		return {
			var_2_0,
			var_0_29
		}
	end,
	completed = function(arg_3_0, arg_3_1, arg_3_2)
		return arg_3_0:get_persistent_stat(arg_3_1, "shovel_sac_vent") >= var_0_29
	end,
	on_event = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		if global_is_inside_inn then
			return
		end

		local var_4_0 = Managers.player:local_player()
		local var_4_1 = var_4_0 and var_4_0.player_unit

		if not var_4_1 then
			return
		end

		if var_4_1 ~= arg_4_4[3] then
			return
		end

		local var_4_2 = arg_4_4[2]

		if var_4_2 > 0 then
			local var_4_3 = var_4_2 * 100

			arg_4_0:modify_stat_by_amount(arg_4_1, "shovel_sac_vent", var_4_3)
		end
	end
}

local var_0_30 = 10
local var_0_31 = 0.2

var_0_1.shovel_sac_low = {
	display_completion_ui = true,
	name = "achv_sac_low_name",
	required_career = "bw_necromancer",
	icon = "easy_come_easy_go",
	required_dlc = "shovel",
	desc = function()
		return string.format(Localize("achv_sac_low_desc"), var_0_30, var_0_31 * 100)
	end,
	events = {
		"sacrifice_skeleton"
	},
	completed = function(arg_6_0, arg_6_1, arg_6_2)
		return arg_6_0:get_persistent_stat(arg_6_1, "shovel_sac_low") >= 1
	end,
	on_event = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
		if global_is_inside_inn then
			return
		end

		local var_7_0 = Managers.player:local_player()
		local var_7_1 = var_7_0 and var_7_0.player_unit

		if not var_7_1 then
			return
		end

		if var_7_1 ~= arg_7_4[3] then
			return
		end

		local var_7_2 = arg_7_4[1]
		local var_7_3 = ScriptUnit.has_extension(var_7_2, "health_system")

		if not var_7_3 or var_7_3:current_health_percent() > var_0_31 then
			return
		end

		arg_7_2.count = (arg_7_2.count or 0) + 1

		if arg_7_2.count >= var_0_30 then
			arg_7_0:increment_stat(arg_7_1, "shovel_sac_low")
		end
	end
}

local var_0_32 = 400
local var_0_33 = 18

var_0_1.shovel_fast_generate = {
	display_completion_ui = true,
	name = "achv_fast_generate_name",
	required_career = "bw_necromancer",
	icon = "unlimited_power",
	required_dlc = "shovel",
	desc = function()
		return string.format(Localize("achv_fast_generate_desc"), var_0_32, var_0_33)
	end,
	events = {
		"overcharge_gained"
	},
	completed = function(arg_9_0, arg_9_1, arg_9_2)
		return arg_9_0:get_persistent_stat(arg_9_1, "shovel_fast_generate") >= 1
	end,
	on_event = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
		if global_is_inside_inn then
			return
		end

		local var_10_0 = arg_10_4[3]
		local var_10_1 = Managers.player:local_player()
		local var_10_2 = var_10_1 and var_10_1.player_unit

		if not var_10_2 or var_10_2 ~= var_10_0 then
			return
		end

		local var_10_3 = ScriptUnit.has_extension(var_10_2, "career_system")

		if not var_10_3 or var_10_3:career_name() ~= "bw_necromancer" then
			return
		end

		local var_10_4 = arg_10_4[2]

		if var_10_4 <= 0 then
			return
		end

		local var_10_5 = var_10_4 * 100

		arg_10_2.total_amount = (arg_10_2.total_amount or 0) + var_10_5

		local var_10_6 = arg_10_2.instances or {}

		arg_10_2.instances = var_10_6

		local var_10_7 = Managers.time:time("game")
		local var_10_8 = {
			time = var_10_7,
			overcharge = var_10_5
		}

		table.insert(var_10_6, var_10_8)

		repeat
			if var_10_6[1].time > var_10_7 - var_0_33 then
				break
			end

			local var_10_9 = table.remove(var_10_6, 1)

			arg_10_2.total_amount = arg_10_2.total_amount - var_10_9.overcharge
		until false

		if arg_10_2.total_amount > var_0_32 then
			arg_10_0:increment_stat(arg_10_1, "shovel_fast_generate")
		end
	end
}

local var_0_34 = 30

var_0_1.shovel_command_elite = {
	display_completion_ui = true,
	name = "achv_command_elite_name",
	required_career = "bw_necromancer",
	icon = "dead_reckoning",
	required_dlc = "shovel",
	desc = function()
		return string.format(Localize("achv_command_elite_desc"), var_0_34)
	end,
	events = {
		"command_attack_unit"
	},
	progress = function(arg_12_0, arg_12_1, arg_12_2)
		local var_12_0 = arg_12_0:get_persistent_stat(arg_12_1, "shovel_command_elite")

		return {
			var_12_0,
			var_0_34
		}
	end,
	completed = function(arg_13_0, arg_13_1, arg_13_2)
		return arg_13_0:get_persistent_stat(arg_13_1, "shovel_command_elite") >= var_0_34
	end,
	on_event = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
		local var_14_0 = arg_14_4[1]
		local var_14_1 = Managers.state.entity:system("ai_commander_system"):get_commander_unit(var_14_0)
		local var_14_2 = Managers.player:local_player()
		local var_14_3 = var_14_2 and var_14_2.player_unit

		if not var_14_3 or var_14_3 ~= var_14_1 then
			return
		end

		local var_14_4 = arg_14_4[2]
		local var_14_5 = Unit.get_data(var_14_4, "breed")

		if not var_14_5 or not var_14_5.elite then
			return
		end

		local var_14_6 = ScriptUnit.has_extension(var_14_4, "buff_system")

		if not var_14_6 or var_14_6:get_stacking_buff("command_elite_challenge_tracker") then
			return
		end

		var_14_6:add_buff("command_elite_challenge_tracker")
		arg_14_0:increment_stat(arg_14_1, "shovel_command_elite")
	end
}

local var_0_35 = 30
local var_0_36 = 2

var_0_1.shovel_skeleton_attack_big = {
	always_run = true,
	name = "achv_skeleton_attack_big_name",
	display_completion_ui = true,
	required_career = "bw_necromancer",
	icon = "sally_forth",
	required_dlc = "shovel",
	desc = function()
		return string.format(Localize("achv_skeleton_attack_big_desc"), var_0_36)
	end,
	events = {
		"on_damage_dealt"
	},
	completed = function(arg_16_0, arg_16_1, arg_16_2)
		return arg_16_0:get_persistent_stat(arg_16_1, "shovel_skeleton_attack_big") >= 1
	end,
	on_event = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
		if not Managers.state.network.is_server then
			return
		end

		if arg_17_4[3] <= 0 then
			return
		end

		local var_17_0 = arg_17_4[2]
		local var_17_1 = Managers.state.entity:system("ai_commander_system"):get_commander_unit(var_17_0)

		if not var_17_1 then
			return
		end

		local var_17_2 = Managers.player:owner(var_17_1)

		if not var_17_2 then
			return
		end

		if arg_17_2[var_17_2:stats_id()] then
			return
		end

		local var_17_3 = arg_17_4[1]
		local var_17_4 = Managers.time:time("game")
		local var_17_5 = arg_17_2.damaged_enemies or {}

		if not var_17_5[var_17_3] then
			arg_17_2.count = (arg_17_2.count or 0) + 1
		end

		var_17_5[var_17_3] = var_17_4
		arg_17_2.damaged_enemies = var_17_5

		if arg_17_2.count >= var_0_35 then
			local var_17_6 = var_17_4 - var_0_36

			for iter_17_0, iter_17_1 in pairs(var_17_5) do
				if iter_17_1 < var_17_6 then
					var_17_5[iter_17_0] = nil
					arg_17_2.count = arg_17_2.count - 1
				end
			end

			if arg_17_2.count >= var_0_35 then
				arg_17_2[var_17_2:stats_id()] = true

				var_0_3(var_17_1, "shovel_skeleton_attack_big")
			end
		end
	end
}

local var_0_37 = 400
local var_0_38 = 10

var_0_1.shovel_skeleton_defend = {
	always_run = true,
	name = "achv_skeleton_defend_name",
	display_completion_ui = true,
	required_career = "bw_necromancer",
	icon = "wall_of_bone",
	required_dlc = "shovel",
	desc = function()
		return string.format(Localize("achv_skeleton_defend_desc"), var_0_37, var_0_38)
	end,
	events = {
		"on_damage_dealt"
	},
	completed = function(arg_19_0, arg_19_1, arg_19_2)
		return arg_19_0:get_persistent_stat(arg_19_1, "shovel_skeleton_defend") >= 1
	end,
	on_event = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
		if not Managers.state.network.is_server then
			return
		end

		local var_20_0 = arg_20_4[1]
		local var_20_1 = Managers.state.entity:system("ai_commander_system"):get_commander_unit(var_20_0)

		if not var_20_1 then
			return
		end

		local var_20_2 = Managers.player:owner(var_20_1)

		if not var_20_2 then
			return
		end

		if arg_20_2[var_20_2:stats_id()] then
			return
		end

		local var_20_3 = BLACKBOARDS[var_20_0]

		if not var_20_3 or var_20_3.command_state ~= CommandStates.StandingGround then
			return
		end

		local var_20_4 = arg_20_4[2]

		if Managers.state.side:is_ally(var_20_0, var_20_4) then
			return
		end

		local var_20_5 = arg_20_4[3]

		if var_20_5 <= 0 then
			return
		end

		arg_20_2.total_amount = (arg_20_2.total_amount or 0) + var_20_5

		local var_20_6 = arg_20_2.instances or {}

		arg_20_2.instances = var_20_6

		local var_20_7 = Managers.time:time("game")
		local var_20_8 = {
			time = var_20_7,
			damage = var_20_5
		}

		table.insert(var_20_6, var_20_8)

		repeat
			if var_20_6[1].time > var_20_7 - var_0_38 then
				break
			end

			local var_20_9 = table.remove(var_20_6, 1)

			arg_20_2.total_amount = arg_20_2.total_amount - var_20_9.damage
		until false

		if arg_20_2.total_amount > var_0_37 then
			arg_20_2[var_20_2:stats_id()] = true

			var_0_3(var_20_1, "shovel_skeleton_defend")
		end
	end
}

local var_0_39 = 24

var_0_1.shovel_many_skeletons = {
	display_completion_ui = true,
	name = "achv_many_skeletons_name",
	required_career = "bw_necromancer",
	icon = "deaths_company",
	required_dlc = "shovel",
	desc = function()
		return string.format(Localize("achv_many_skeletons_desc"), var_0_39)
	end,
	events = {
		"on_controlled_unit_added"
	},
	completed = function(arg_22_0, arg_22_1, arg_22_2)
		return arg_22_0:get_persistent_stat(arg_22_1, "shovel_many_skeletons") >= 1
	end,
	on_event = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
		local var_23_0 = arg_23_4[2]
		local var_23_1 = Managers.player:local_player()
		local var_23_2 = var_23_1 and var_23_1.player_unit

		if not var_23_2 or var_23_2 ~= var_23_0 then
			return
		end

		if arg_23_4[3]:get_controlled_units_count() >= var_0_39 then
			arg_23_0:increment_stat(arg_23_1, "shovel_many_skeletons")
		end
	end
}

local var_0_40 = 150

var_0_1.shovel_melee_balefire = {
	display_completion_ui = true,
	name = "achv_melee_balefire_name",
	required_career = "bw_necromancer",
	icon = "flames_forever",
	required_dlc = "shovel",
	desc = function()
		return string.format(Localize("achv_melee_balefire_desc"), var_0_40)
	end,
	events = {
		"register_kill"
	},
	progress = function(arg_25_0, arg_25_1, arg_25_2)
		local var_25_0 = arg_25_0:get_persistent_stat(arg_25_1, "shovel_melee_balefire")

		return {
			var_25_0,
			var_0_40
		}
	end,
	completed = function(arg_26_0, arg_26_1, arg_26_2)
		return arg_26_0:get_persistent_stat(arg_26_1, "shovel_melee_balefire") >= var_0_40
	end,
	on_event = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
		local var_27_0 = Managers.player:local_player()
		local var_27_1 = var_27_0 and var_27_0.player_unit
		local var_27_2 = arg_27_4[var_0_17]
		local var_27_3 = var_27_2[DamageDataIndex.ATTACKER]

		if var_27_3 and var_27_1 ~= var_27_3 then
			return
		end

		local var_27_4 = arg_27_4[var_0_16]
		local var_27_5, var_27_6 = Managers.state.status_effect:has_status(var_27_4, "burning_balefire")

		if not var_27_5 or var_27_6 then
			return
		end

		local var_27_7 = ScriptUnit.has_extension(var_27_3, "career_system")

		if not var_27_7 or var_27_7:career_name() ~= "bw_necromancer" then
			return
		end

		local var_27_8 = var_27_2[DamageDataIndex.ATTACK_TYPE]

		if var_27_8 ~= "light_attack" and var_27_8 ~= "heavy_attack" then
			return
		end

		arg_27_0:increment_stat(arg_27_1, "shovel_melee_balefire")
	end
}

local var_0_41 = 8

var_0_1.shovel_fast_staff_attack = {
	always_run = true,
	name = "achv_fast_staff_attack_name",
	display_completion_ui = true,
	required_career = "bw_necromancer",
	icon = "mistress_of_the_stave",
	required_dlc = "shovel",
	desc = function()
		return string.format(Localize("achv_fast_staff_attack_desc"), var_0_41)
	end,
	events = {
		"register_ai_stagger"
	},
	completed = function(arg_29_0, arg_29_1, arg_29_2)
		return arg_29_0:get_persistent_stat(arg_29_1, "shovel_fast_staff_attack") >= 1
	end,
	on_event = function(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
		local var_30_0 = arg_30_4[1]
		local var_30_1 = BLACKBOARDS[var_30_0]

		if not var_30_1 or not var_30_1.breed.elite then
			return
		end

		if arg_30_4[3].name ~= "death_staff_curse" then
			return
		end

		local var_30_2 = arg_30_4[2]
		local var_30_3 = Managers.player:owner(var_30_2)

		if not var_30_3 or var_30_3.bot_player then
			return
		end

		if arg_30_2[var_30_3:stats_id()] then
			return
		end

		local var_30_4 = ScriptUnit.has_extension(var_30_2, "career_system")

		if not var_30_4 or var_30_4:career_name() ~= "bw_necromancer" then
			return
		end

		local var_30_5 = arg_30_2.stagger_instances or {}

		arg_30_2.stagger_instances = var_30_5

		local var_30_6 = Managers.time:time("game")

		if not var_30_5[var_30_0] then
			arg_30_2.num_staggers = (arg_30_2.num_staggers or 0) + 1
		end

		var_30_5[var_30_0] = var_30_6

		local var_30_7 = 1.75

		if arg_30_2.num_staggers >= var_0_41 then
			for iter_30_0, iter_30_1 in pairs(var_30_5) do
				local var_30_8 = BLACKBOARDS[iter_30_0]

				if not (not var_30_8 or var_30_8.stagger_time) or var_30_6 > iter_30_1 + var_30_7 then
					var_30_5[iter_30_0] = nil
					arg_30_2.num_staggers = arg_30_2.num_staggers - 1
				end
			end
		end

		if arg_30_2.num_staggers >= var_0_41 then
			arg_30_2[var_30_3:stats_id()] = true

			var_0_3(var_30_2, "shovel_fast_staff_attack")
		end
	end
}

local var_0_42 = 250

var_0_1.shovel_staff_balefire = {
	always_run = true,
	name = "achv_staff_balefire_name",
	display_completion_ui = true,
	required_career = "bw_necromancer",
	icon = "still_fiery_darlings",
	required_dlc = "shovel",
	desc = function()
		return string.format(Localize("achv_staff_balefire_desc"), var_0_42)
	end,
	events = {
		"on_dot_applied"
	},
	completed = function(arg_32_0, arg_32_1, arg_32_2)
		return arg_32_0:get_persistent_stat(arg_32_1, "shovel_staff_balefire") >= var_0_42
	end,
	on_event = function(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
		if not Managers.state.network.is_server then
			return
		end

		local var_33_0 = arg_33_4[3]
		local var_33_1 = Managers.player:owner(var_33_0)

		if not var_33_1 or var_33_1.bot_player then
			return
		end

		if arg_33_4[2] ~= "bw_necromancy_staff" then
			return
		end

		local var_33_2 = arg_33_4[1]

		if not BalefireDots[var_33_2] then
			return
		end

		local var_33_3 = ScriptUnit.has_extension(var_33_0, "career_system")

		if not var_33_3 or var_33_3:career_name() ~= "bw_necromancer" then
			return
		end

		local var_33_4 = arg_33_2.counter or {}

		arg_33_2.counter = var_33_4
		var_33_4[var_33_0] = (var_33_4[var_33_0] or 0) + 1

		if var_33_4[var_33_0] <= var_0_42 then
			var_0_3(var_33_0, "shovel_staff_balefire")
		end
	end
}

local var_0_43 = 25

var_0_1.shovel_big_suck = {
	display_completion_ui = true,
	name = "achv_big_suck_name",
	required_career = "bw_necromancer",
	icon = "drained",
	required_dlc = "shovel",
	desc = function()
		return string.format(Localize("achv_big_suck_desc"), var_0_43)
	end,
	events = {
		"register_kill"
	},
	progress = function(arg_35_0, arg_35_1, arg_35_2)
		local var_35_0 = arg_35_0:get_persistent_stat(arg_35_1, "shovel_big_suck")

		return {
			var_35_0,
			var_0_43
		}
	end,
	completed = function(arg_36_0, arg_36_1, arg_36_2)
		return arg_36_0:get_persistent_stat(arg_36_1, "shovel_big_suck") >= var_0_43
	end,
	on_event = function(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
		local var_37_0 = Managers.player:local_player()
		local var_37_1 = var_37_0 and var_37_0.player_unit
		local var_37_2 = arg_37_4[var_0_17]
		local var_37_3 = var_37_2[DamageDataIndex.ATTACKER]

		if var_37_3 and var_37_1 ~= var_37_3 then
			return
		end

		local var_37_4 = arg_37_4[var_0_18]

		if not var_37_4 or var_37_4.name ~= "chaos_warrior" then
			return
		end

		local var_37_5 = var_37_2[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_37_6 = rawget(ItemMasterList, var_37_5)

		if not (var_37_6 and var_37_6.item_type == "bw_necromancy_staff") then
			return
		end

		if var_37_2[DamageDataIndex.ATTACK_TYPE] ~= "heavy_instant_projectile" then
			return
		end

		local var_37_7 = ScriptUnit.has_extension(var_37_3, "career_system")

		if not var_37_7 or var_37_7:career_name() ~= "bw_necromancer" then
			return
		end

		arg_37_0:increment_stat(arg_37_1, "shovel_big_suck")
	end
}

local var_0_44 = 15
local var_0_45 = 5

var_0_1.shovel_big_cleave = {
	display_completion_ui = true,
	name = "achv_big_cleave_name",
	required_career = "bw_necromancer",
	icon = "reaping_time",
	required_dlc = "shovel",
	desc = function()
		return string.format(Localize("achv_big_cleave_desc"), var_0_44, var_0_45)
	end,
	events = {
		"on_hit"
	},
	completed = function(arg_39_0, arg_39_1, arg_39_2)
		return arg_39_0:get_persistent_stat(arg_39_1, "shovel_big_cleave") >= var_0_45
	end,
	on_event = function(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
		if arg_40_4[9] ~= "bw_ghost_scythe" then
			return
		end

		if arg_40_4[2] == "aoe" then
			return
		end

		local var_40_0 = Managers.player:local_player()
		local var_40_1 = var_40_0 and var_40_0.player_unit
		local var_40_2 = arg_40_4[8]

		if var_40_2 and var_40_1 ~= var_40_2 then
			return
		end

		if arg_40_4[4] == var_0_44 + 1 then
			arg_40_0:increment_stat(arg_40_1, "shovel_big_cleave")
		end
	end
}

local var_0_46 = 100

var_0_1.shovel_headshot_scythe = {
	display_completion_ui = true,
	name = "achv_headshot_scythe_name",
	required_career = "bw_necromancer",
	icon = "ripe_harvest",
	required_dlc = "shovel",
	desc = function()
		return string.format(Localize("achv_headshot_scythe_desc"), var_0_46)
	end,
	events = {
		"on_hit"
	},
	progress = function(arg_42_0, arg_42_1, arg_42_2)
		local var_42_0 = arg_42_0:get_persistent_stat(arg_42_1, "shovel_headshot_scythe")

		return {
			var_42_0,
			var_0_46
		}
	end,
	completed = function(arg_43_0, arg_43_1, arg_43_2)
		return arg_43_0:get_persistent_stat(arg_43_1, "shovel_headshot_scythe") >= var_0_46
	end,
	on_event = function(arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
		if arg_44_4[9] ~= "bw_ghost_scythe" then
			return
		end

		local var_44_0 = Managers.player:local_player()
		local var_44_1 = var_44_0 and var_44_0.player_unit
		local var_44_2 = arg_44_4[8]

		if var_44_2 and var_44_1 ~= var_44_2 then
			return
		end

		if arg_44_4[3] == "head" then
			arg_44_0:increment_stat(arg_44_1, "shovel_headshot_scythe")
		end
	end
}

local var_0_47 = 3
local var_0_48 = 4

local function var_0_49(arg_45_0, arg_45_1)
	local var_45_0 = arg_45_0.knockback_position:unbox()
	local var_45_1 = Unit.is_valid(arg_45_1) and not Unit.is_frozen(arg_45_1) and Unit.local_position(arg_45_1, 0)

	if not var_45_1 or var_45_0[3] - var_45_1[3] < var_0_48 then
		return false
	end

	return true
end

var_0_1.shovel_staff_gandalf = {
	display_completion_ui = true,
	name = "achv_staff_gandalf_name",
	desc = "achv_staff_gandalf_desc",
	required_career = "bw_necromancer",
	icon = "whoosh_clang",
	required_dlc = "shovel",
	events = {
		"register_kill",
		"on_hit",
		"necromancer_staff_gandalf_delayed_check"
	},
	completed = function(arg_46_0, arg_46_1, arg_46_2)
		return arg_46_0:get_persistent_stat(arg_46_1, "shovel_staff_gandalf") >= 1
	end,
	on_event = function(arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4)
		local var_47_0 = Managers.time:time("game")

		if arg_47_3 == "register_kill" then
			local var_47_1 = arg_47_4[var_0_16]
			local var_47_2 = arg_47_2.tracked_units and arg_47_2.tracked_units[var_47_1]

			if not var_47_2 then
				return
			end

			if var_47_0 - var_47_2.knockback_time > var_0_47 then
				return false
			end

			if var_0_49(var_47_2, var_47_1) then
				arg_47_0:increment_stat(arg_47_1, "shovel_staff_gandalf")

				return
			end
		elseif arg_47_3 == "on_hit" then
			local var_47_3 = arg_47_4[1]
			local var_47_4 = Unit.get_data(var_47_3, "breed")

			if not var_47_4 or var_47_4.name ~= "chaos_warrior" then
				return
			end

			if arg_47_4[9] ~= "bw_ghost_scythe" then
				return
			end

			if arg_47_4[2] ~= "aoe" then
				return
			end

			local var_47_5 = Managers.player:local_player()
			local var_47_6 = var_47_5 and var_47_5.player_unit
			local var_47_7 = ScriptUnit.has_extension(var_47_6, "career_system")

			if not var_47_7 or var_47_7:career_name() ~= "bw_necromancer" then
				return
			end

			var_47_7:get_passive_ability_by_name("bw_necromancer"):achievement_staff_gandalf_trigger(var_47_3, var_47_0, math.max(var_0_47, 6))

			arg_47_2.tracked_units = arg_47_2.tracked_units or {}

			local var_47_8 = arg_47_2.tracked_units[var_47_3]

			if var_47_8 then
				var_47_8.knockback_time = var_47_0

				var_47_8.knockback_position:store(POSITION_LOOKUP[var_47_3])
			else
				arg_47_2.tracked_units[var_47_3] = {
					knockback_time = var_47_0,
					knockback_position = Vector3Box(POSITION_LOOKUP[var_47_3])
				}
			end
		else
			local var_47_9 = arg_47_4[1]
			local var_47_10 = arg_47_2.tracked_units[var_47_9]

			if var_0_49(var_47_10, var_47_9) then
				arg_47_0:increment_stat(arg_47_1, "shovel_staff_gandalf")

				return
			end
		end
	end
}

local var_0_50 = 500

var_0_1.shovel_skeleton_balefire = {
	always_run = true,
	name = "achv_skeleton_balefire_name",
	display_completion_ui = true,
	required_career = "bw_necromancer",
	icon = "unrestful_bonefire",
	required_dlc = "shovel",
	desc = function()
		return string.format(Localize("achv_skeleton_balefire_desc"), var_0_50)
	end,
	events = {
		"on_damage_dealt"
	},
	progress = function(arg_49_0, arg_49_1, arg_49_2)
		local var_49_0 = arg_49_0:get_persistent_stat(arg_49_1, "shovel_skeleton_balefire")

		return {
			var_49_0,
			var_0_50
		}
	end,
	completed = function(arg_50_0, arg_50_1, arg_50_2)
		return arg_50_0:get_persistent_stat(arg_50_1, "shovel_skeleton_balefire") >= var_0_50
	end,
	on_event = function(arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4)
		if not Managers.state.network.is_server then
			return
		end

		local var_51_0 = arg_51_4[2]
		local var_51_1 = Managers.state.entity:system("ai_commander_system"):get_commander_unit(var_51_0)

		if not var_51_1 then
			return
		end

		local var_51_2 = Managers.player:owner(var_51_1)

		if not var_51_2 then
			return
		end

		if arg_51_2[var_51_2:stats_id()] then
			return
		end

		local var_51_3 = arg_51_4[1]
		local var_51_4, var_51_5 = Managers.state.status_effect:has_status(var_51_3, "burning_balefire")

		if not var_51_4 or var_51_5 then
			return
		end

		arg_51_2.count = arg_51_2.count or {}
		arg_51_2.count[var_51_1] = (arg_51_2.count[var_51_1] or 0) + 1

		if arg_51_2.count[var_51_1] <= var_0_50 then
			var_0_3(var_51_1, "shovel_skeleton_balefire")
		else
			arg_51_2[var_51_2:stats_id()] = true
		end
	end
}

local function var_0_51(arg_52_0, arg_52_1)
	if arg_52_0.timer_start_t then
		local var_52_0 = arg_52_1 - arg_52_0.timer_start_t

		arg_52_0.total_time = arg_52_0.total_time + var_52_0
	end

	arg_52_0.timer_start_t = nil
end

local function var_0_52(arg_53_0, arg_53_1)
	var_0_51(arg_53_0, arg_53_1)

	arg_53_0.timer_start_t = arg_53_1
end

local var_0_53 = 4
local var_0_54 = 0.95
local var_0_55 = 95

var_0_1.shovel_keep_skeletons_alive = {
	display_completion_ui = true,
	name = "achv_keep_skeletons_alive_name",
	required_career = "bw_necromancer",
	icon = "the_soul_of_the_party",
	required_dlc = "shovel",
	desc = function()
		return string.format(Localize("achv_keep_skeletons_alive_desc"), var_0_55)
	end,
	events = {
		"on_controlled_unit_added",
		"on_controlled_unit_removed",
		"on_round_started",
		"register_completed_level"
	},
	completed = function(arg_55_0, arg_55_1, arg_55_2)
		return arg_55_0:get_persistent_stat(arg_55_1, "shovel_keep_skeletons_alive") >= 1
	end,
	on_event = function(arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4)
		local var_56_0 = Managers.player:local_player()
		local var_56_1 = var_56_0 and var_56_0.player_unit

		if not var_56_1 then
			return
		end

		if ScriptUnit.extension(var_56_1, "career_system"):career_name() ~= "bw_necromancer" then
			return
		end

		local var_56_2 = Managers.time:time("game")

		if arg_56_3 == "on_round_started" then
			arg_56_2.level_start_t = arg_56_2.level_start_t or var_56_2
			arg_56_2.total_time = 0
		elseif not arg_56_2.level_start_t then
			return
		elseif arg_56_3 == "register_completed_level" then
			var_0_51(arg_56_2, var_56_2)

			local var_56_3 = arg_56_2.level_start_t

			if var_56_3 and var_56_3 ~= var_56_2 then
				local var_56_4 = var_56_2 - var_56_3

				if arg_56_2.total_time / var_56_4 >= var_0_54 then
					arg_56_0:increment_stat(arg_56_1, "shovel_keep_skeletons_alive")
				end
			end
		end

		if ScriptUnit.extension(var_56_1, "ai_commander_system"):get_controlled_units_count() < var_0_53 then
			var_0_51(arg_56_2, var_56_2)
		else
			var_0_52(arg_56_2, var_56_2)
		end
	end
}

local var_0_56 = {
	"shovel_complete_all_helmgart_levels_bw_necromancer",
	"shovel_complete_25_missions_bw_necromancer",
	"shovel_sac_vent",
	"shovel_fast_generate",
	"shovel_command_elite",
	"shovel_skeleton_attack_big",
	"shovel_skeleton_defend",
	"shovel_many_skeletons",
	"shovel_melee_balefire",
	"shovel_fast_staff_attack",
	"shovel_staff_balefire",
	"shovel_big_suck",
	"shovel_big_cleave",
	"shovel_headshot_scythe",
	"shovel_skeleton_balefire",
	"shovel_keep_skeletons_alive"
}

var_0_7(var_0_1, "necro_complete_all", var_0_56, "mistress_of_necromancy", "shovel", nil, nil)
