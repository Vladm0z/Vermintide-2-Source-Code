-- chunkname: @scripts/managers/achievements/achievement_templates_shovel.lua

local PLACEHOLDER_ICON = AchievementTemplateHelper.PLACEHOLDER_ICON
local achievements = AchievementTemplates.achievements
local shovel = DLCSettings.shovel
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

add_levels_complete_per_hero_challenge(achievements, "shovel_complete_all_helmgart_levels", HelmgartLevels, 2, "bw_necromancer", false, "unexpected_saviour", "shovel", nil, nil)

local tbl_3 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}

add_career_mission_count_challenge(achievements, "shovel_complete_25_missions", "completed_career_levels", "bw_necromancer", tbl_3, 25, nil, "creeping_death", "shovel", nil, nil)

local num_18 = 2500

achievements.shovel_sac_vent = {
	display_completion_ui = true,
	name = "achv_sac_vent_name",
	required_career = "bw_necromancer",
	icon = "assistive_sacrifice",
	required_dlc = "shovel",
	desc = function ()
		-- function 1
		return string.format(Localize("achv_sac_vent_desc"), num_18)
	end,
	events = {
		"sacrifice_skeleton"
	},
	progress = function (self, arg_2_1, arg_2_2)
		-- function 2
		local get_persistent_stat = self:get_persistent_stat(arg_2_1, "shovel_sac_vent")

		return {
			get_persistent_stat,
			num_18
		}
	end,
	completed = function (self, arg_3_1, arg_3_2)
		-- function 3
		return self:get_persistent_stat(arg_3_1, "shovel_sac_vent") >= num_18
	end,
	on_event = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		-- function 4
		if not global_is_inside_inn then
			return
		end

		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit

		if not flag then
			return
		end

		if flag ~= arg_4_4[3] then
			return
		end

		local var_4_2 = arg_4_4[2]

		if var_4_2 > 0 then
			local num = var_4_2 * 100

			self:modify_stat_by_amount(arg_4_1, "shovel_sac_vent", num)
		end
	end
}

local num_19 = 10
local num_20 = 0.2

achievements.shovel_sac_low = {
	display_completion_ui = true,
	name = "achv_sac_low_name",
	required_career = "bw_necromancer",
	icon = "easy_come_easy_go",
	required_dlc = "shovel",
	desc = function ()
		-- function 5
		return string.format(Localize("achv_sac_low_desc"), num_19, num_20 * 100)
	end,
	events = {
		"sacrifice_skeleton"
	},
	completed = function (self, arg_6_1, arg_6_2)
		-- function 6
		return self:get_persistent_stat(arg_6_1, "shovel_sac_low") >= 1
	end,
	on_event = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
		-- function 7
		if not global_is_inside_inn then
			return
		end

		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit

		if not flag then
			return
		end

		if flag ~= arg_7_4[3] then
			return
		end

		local var_7_2 = arg_7_4[1]
		local has_extension = ScriptUnit.has_extension(var_7_2, "health_system")

		if not (not has_extension and not (has_extension:current_health_percent() > num_20)) then
			return
		end

		local count = arg_7_2.count

		count = count or 0
		arg_7_2.count = count + 1

		if arg_7_2.count >= num_19 then
			self:increment_stat(arg_7_1, "shovel_sac_low")
		end
	end
}

local num_21 = 400
local num_22 = 18

achievements.shovel_fast_generate = {
	display_completion_ui = true,
	name = "achv_fast_generate_name",
	required_career = "bw_necromancer",
	icon = "unlimited_power",
	required_dlc = "shovel",
	desc = function ()
		-- function 8
		return string.format(Localize("achv_fast_generate_desc"), num_21, num_22)
	end,
	events = {
		"overcharge_gained"
	},
	completed = function (self, arg_9_1, arg_9_2)
		-- function 9
		return self:get_persistent_stat(arg_9_1, "shovel_fast_generate") >= 1
	end,
	on_event = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
		-- function 10
		if not global_is_inside_inn then
			return
		end

		local var_10_0 = arg_10_4[3]
		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit

		if not (not flag and flag == var_10_0) then
			return
		end

		local has_extension = ScriptUnit.has_extension(flag, "career_system")

		if not (not has_extension and has_extension:career_name() == "bw_necromancer") then
			return
		end

		local var_10_4 = arg_10_4[2]

		if var_10_4 <= 0 then
			return
		end

		local num = var_10_4 * 100
		local total_amount = arg_10_2.total_amount

		total_amount = total_amount or 0
		arg_10_2.total_amount = total_amount + num

		local instances = arg_10_2.instances

		instances = instances or {}
		arg_10_2.instances = instances

		local time = Managers.time:time("game")
		local tbl = {
			time = time,
			overcharge = num
		}

		table.insert(instances, tbl)

		repeat
			if instances[1].time > time - num_22 then
				break
			end

			local remove = table.remove(instances, 1)

			arg_10_2.total_amount = arg_10_2.total_amount - remove.overcharge
		until false

		if arg_10_2.total_amount > num_21 then
			self:increment_stat(arg_10_1, "shovel_fast_generate")
		end
	end
}

local num_23 = 30

achievements.shovel_command_elite = {
	display_completion_ui = true,
	name = "achv_command_elite_name",
	required_career = "bw_necromancer",
	icon = "dead_reckoning",
	required_dlc = "shovel",
	desc = function ()
		-- function 11
		return string.format(Localize("achv_command_elite_desc"), num_23)
	end,
	events = {
		"command_attack_unit"
	},
	progress = function (self, arg_12_1, arg_12_2)
		-- function 12
		local get_persistent_stat = self:get_persistent_stat(arg_12_1, "shovel_command_elite")

		return {
			get_persistent_stat,
			num_23
		}
	end,
	completed = function (self, arg_13_1, arg_13_2)
		-- function 13
		return self:get_persistent_stat(arg_13_1, "shovel_command_elite") >= num_23
	end,
	on_event = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
		-- function 14
		local var_14_0 = arg_14_4[1]
		local get_commander_unit = Managers.state.entity:system("ai_commander_system"):get_commander_unit(var_14_0)
		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit

		if not (not flag and flag == get_commander_unit) then
			return
		end

		local var_14_4 = arg_14_4[2]
		local get_data = Unit.get_data(var_14_4, "breed")

		if not (not get_data and get_data.elite) then
			return
		end

		local has_extension = ScriptUnit.has_extension(var_14_4, "buff_system")

		if not has_extension and not has_extension:get_stacking_buff("command_elite_challenge_tracker") then
			return
		end

		has_extension:add_buff("command_elite_challenge_tracker")
		self:increment_stat(arg_14_1, "shovel_command_elite")
	end
}

local num_24 = 30
local num_25 = 2

achievements.shovel_skeleton_attack_big = {
	always_run = true,
	name = "achv_skeleton_attack_big_name",
	display_completion_ui = true,
	required_career = "bw_necromancer",
	icon = "sally_forth",
	required_dlc = "shovel",
	desc = function ()
		-- function 15
		return string.format(Localize("achv_skeleton_attack_big_desc"), num_25)
	end,
	events = {
		"on_damage_dealt"
	},
	completed = function (self, arg_16_1, arg_16_2)
		-- function 16
		return self:get_persistent_stat(arg_16_1, "shovel_skeleton_attack_big") >= 1
	end,
	on_event = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
		-- function 17
		if not Managers.state.network.is_server then
			return
		end

		if arg_17_4[3] <= 0 then
			return
		end

		local var_17_0 = arg_17_4[2]
		local get_commander_unit = Managers.state.entity:system("ai_commander_system"):get_commander_unit(var_17_0)

		if not get_commander_unit then
			return
		end

		local owner = Managers.player:owner(get_commander_unit)

		if not owner then
			return
		end

		if not arg_17_2[owner:stats_id()] then
			return
		end

		local var_17_3 = arg_17_4[1]
		local time = Managers.time:time("game")
		local damaged_enemies = arg_17_2.damaged_enemies

		damaged_enemies = damaged_enemies or {}

		if not damaged_enemies[var_17_3] then
			local count = arg_17_2.count

			count = count or 0
			arg_17_2.count = count + 1
		end

		damaged_enemies[var_17_3] = time
		arg_17_2.damaged_enemies = damaged_enemies

		if arg_17_2.count >= num_24 then
			local num = time - num_25

			for k, v in pairs(damaged_enemies) do
				if v < num then
					damaged_enemies[k] = nil
					arg_17_2.count = arg_17_2.count - 1
				end
			end

			if arg_17_2.count >= num_24 then
				arg_17_2[owner:stats_id()] = true

				rpc_increment_stat(get_commander_unit, "shovel_skeleton_attack_big")
			end
		end
	end
}

local num_26 = 400
local num_27 = 10

achievements.shovel_skeleton_defend = {
	always_run = true,
	name = "achv_skeleton_defend_name",
	display_completion_ui = true,
	required_career = "bw_necromancer",
	icon = "wall_of_bone",
	required_dlc = "shovel",
	desc = function ()
		-- function 18
		return string.format(Localize("achv_skeleton_defend_desc"), num_26, num_27)
	end,
	events = {
		"on_damage_dealt"
	},
	completed = function (self, arg_19_1, arg_19_2)
		-- function 19
		return self:get_persistent_stat(arg_19_1, "shovel_skeleton_defend") >= 1
	end,
	on_event = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
		-- function 20
		if not Managers.state.network.is_server then
			return
		end

		local var_20_0 = arg_20_4[1]
		local get_commander_unit = Managers.state.entity:system("ai_commander_system"):get_commander_unit(var_20_0)

		if not get_commander_unit then
			return
		end

		local owner = Managers.player:owner(get_commander_unit)

		if not owner then
			return
		end

		if not arg_20_2[owner:stats_id()] then
			return
		end

		local var_20_3 = BLACKBOARDS[var_20_0]

		if not (not var_20_3 and var_20_3.command_state == CommandStates.StandingGround) then
			return
		end

		local var_20_4 = arg_20_4[2]

		if not Managers.state.side:is_ally(var_20_0, var_20_4) then
			return
		end

		local var_20_5 = arg_20_4[3]

		if var_20_5 <= 0 then
			return
		end

		local total_amount = arg_20_2.total_amount

		total_amount = total_amount or 0
		arg_20_2.total_amount = total_amount + var_20_5

		local instances = arg_20_2.instances

		instances = instances or {}
		arg_20_2.instances = instances

		local time = Managers.time:time("game")
		local tbl = {
			time = time,
			damage = var_20_5
		}

		table.insert(instances, tbl)

		repeat
			if instances[1].time > time - num_27 then
				break
			end

			local remove = table.remove(instances, 1)

			arg_20_2.total_amount = arg_20_2.total_amount - remove.damage
		until false

		if arg_20_2.total_amount > num_26 then
			arg_20_2[owner:stats_id()] = true

			rpc_increment_stat(get_commander_unit, "shovel_skeleton_defend")
		end
	end
}

local num_28 = 24

achievements.shovel_many_skeletons = {
	display_completion_ui = true,
	name = "achv_many_skeletons_name",
	required_career = "bw_necromancer",
	icon = "deaths_company",
	required_dlc = "shovel",
	desc = function ()
		-- function 21
		return string.format(Localize("achv_many_skeletons_desc"), num_28)
	end,
	events = {
		"on_controlled_unit_added"
	},
	completed = function (self, arg_22_1, arg_22_2)
		-- function 22
		return self:get_persistent_stat(arg_22_1, "shovel_many_skeletons") >= 1
	end,
	on_event = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
		-- function 23
		local var_23_0 = arg_23_4[2]
		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit

		if not (not flag and flag == var_23_0) then
			return
		end

		if arg_23_4[3]:get_controlled_units_count() >= num_28 then
			self:increment_stat(arg_23_1, "shovel_many_skeletons")
		end
	end
}

local num_29 = 150

achievements.shovel_melee_balefire = {
	display_completion_ui = true,
	name = "achv_melee_balefire_name",
	required_career = "bw_necromancer",
	icon = "flames_forever",
	required_dlc = "shovel",
	desc = function ()
		-- function 24
		return string.format(Localize("achv_melee_balefire_desc"), num_29)
	end,
	events = {
		"register_kill"
	},
	progress = function (self, arg_25_1, arg_25_2)
		-- function 25
		local get_persistent_stat = self:get_persistent_stat(arg_25_1, "shovel_melee_balefire")

		return {
			get_persistent_stat,
			num_29
		}
	end,
	completed = function (self, arg_26_1, arg_26_2)
		-- function 26
		return self:get_persistent_stat(arg_26_1, "shovel_melee_balefire") >= num_29
	end,
	on_event = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
		-- function 27
		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit
		local var_27_2 = arg_27_4[num_8]
		local var_27_3 = var_27_2[DamageDataIndex.ATTACKER]

		if not (not var_27_3 and flag == var_27_3) then
			return
		end

		local var_27_4 = arg_27_4[num_7]
		local has_status, var_27_6 = Managers.state.status_effect:has_status(var_27_4, "burning_balefire")

		if not has_status and not var_27_6 then
			return
		end

		local has_extension = ScriptUnit.has_extension(var_27_3, "career_system")

		if not (not has_extension and has_extension:career_name() == "bw_necromancer") then
			return
		end

		local var_27_8 = var_27_2[DamageDataIndex.ATTACK_TYPE]

		if not (var_27_8 == "light_attack" or var_27_8 == "heavy_attack") then
			return
		end

		self:increment_stat(arg_27_1, "shovel_melee_balefire")
	end
}

local num_30 = 8

achievements.shovel_fast_staff_attack = {
	always_run = true,
	name = "achv_fast_staff_attack_name",
	display_completion_ui = true,
	required_career = "bw_necromancer",
	icon = "mistress_of_the_stave",
	required_dlc = "shovel",
	desc = function ()
		-- function 28
		return string.format(Localize("achv_fast_staff_attack_desc"), num_30)
	end,
	events = {
		"register_ai_stagger"
	},
	completed = function (self, arg_29_1, arg_29_2)
		-- function 29
		return self:get_persistent_stat(arg_29_1, "shovel_fast_staff_attack") >= 1
	end,
	on_event = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
		-- function 30
		local var_30_0 = arg_30_4[1]
		local var_30_1 = BLACKBOARDS[var_30_0]

		if not (not var_30_1 and var_30_1.breed.elite) then
			return
		end

		if arg_30_4[3].name ~= "death_staff_curse" then
			return
		end

		local var_30_2 = arg_30_4[2]
		local owner = Managers.player:owner(var_30_2)

		if not owner and not owner.bot_player then
			return
		end

		if not arg_30_2[owner:stats_id()] then
			return
		end

		local has_extension = ScriptUnit.has_extension(var_30_2, "career_system")

		if not (not has_extension and has_extension:career_name() == "bw_necromancer") then
			return
		end

		local stagger_instances = arg_30_2.stagger_instances

		stagger_instances = stagger_instances or {}
		arg_30_2.stagger_instances = stagger_instances

		local time = Managers.time:time("game")

		if not stagger_instances[var_30_0] then
			local num_staggers = arg_30_2.num_staggers

			num_staggers = num_staggers or 0
			arg_30_2.num_staggers = num_staggers + 1
		end

		stagger_instances[var_30_0] = time

		local num = 1.75

		if arg_30_2.num_staggers >= num_30 then
			for k, v in pairs(stagger_instances) do
				local var_30_9 = BLACKBOARDS[k]

				if not (not (not var_30_9 and var_30_9.stagger_time) and not (time > v + num)) then
					stagger_instances[k] = nil
					arg_30_2.num_staggers = arg_30_2.num_staggers - 1
				end
			end
		end

		if arg_30_2.num_staggers >= num_30 then
			arg_30_2[owner:stats_id()] = true

			rpc_increment_stat(var_30_2, "shovel_fast_staff_attack")
		end
	end
}

local num_31 = 250

achievements.shovel_staff_balefire = {
	always_run = true,
	name = "achv_staff_balefire_name",
	display_completion_ui = true,
	required_career = "bw_necromancer",
	icon = "still_fiery_darlings",
	required_dlc = "shovel",
	desc = function ()
		-- function 31
		return string.format(Localize("achv_staff_balefire_desc"), num_31)
	end,
	events = {
		"on_dot_applied"
	},
	completed = function (self, arg_32_1, arg_32_2)
		-- function 32
		return self:get_persistent_stat(arg_32_1, "shovel_staff_balefire") >= num_31
	end,
	on_event = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
		-- function 33
		if not Managers.state.network.is_server then
			return
		end

		local var_33_0 = arg_33_4[3]
		local owner = Managers.player:owner(var_33_0)

		if not owner and not owner.bot_player then
			return
		end

		if arg_33_4[2] ~= "bw_necromancy_staff" then
			return
		end

		local var_33_2 = arg_33_4[1]

		if not BalefireDots[var_33_2] then
			return
		end

		local has_extension = ScriptUnit.has_extension(var_33_0, "career_system")

		if not (not has_extension and has_extension:career_name() == "bw_necromancer") then
			return
		end

		local counter = arg_33_2.counter

		counter = counter or {}
		arg_33_2.counter = counter

		local var_33_5 = counter[var_33_0]

		var_33_5 = var_33_5 or 0
		counter[var_33_0] = var_33_5 + 1

		if counter[var_33_0] <= num_31 then
			rpc_increment_stat(var_33_0, "shovel_staff_balefire")
		end
	end
}

local num_32 = 25

achievements.shovel_big_suck = {
	display_completion_ui = true,
	name = "achv_big_suck_name",
	required_career = "bw_necromancer",
	icon = "drained",
	required_dlc = "shovel",
	desc = function ()
		-- function 34
		return string.format(Localize("achv_big_suck_desc"), num_32)
	end,
	events = {
		"register_kill"
	},
	progress = function (self, arg_35_1, arg_35_2)
		-- function 35
		local get_persistent_stat = self:get_persistent_stat(arg_35_1, "shovel_big_suck")

		return {
			get_persistent_stat,
			num_32
		}
	end,
	completed = function (self, arg_36_1, arg_36_2)
		-- function 36
		return self:get_persistent_stat(arg_36_1, "shovel_big_suck") >= num_32
	end,
	on_event = function (self, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
		-- function 37
		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit
		local var_37_2 = arg_37_4[num_8]
		local var_37_3 = var_37_2[DamageDataIndex.ATTACKER]

		if not (not var_37_3 and flag == var_37_3) then
			return
		end

		local var_37_4 = arg_37_4[num_9]

		if not (not var_37_4 and var_37_4.name == "chaos_warrior") then
			return
		end

		local var_37_5 = var_37_2[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_37_6 = rawget(ItemMasterList, var_37_5)

		if not (not var_37_6 and var_37_6.item_type == "bw_necromancy_staff") then
			return
		end

		if var_37_2[DamageDataIndex.ATTACK_TYPE] ~= "heavy_instant_projectile" then
			return
		end

		local has_extension = ScriptUnit.has_extension(var_37_3, "career_system")

		if not (not has_extension and has_extension:career_name() == "bw_necromancer") then
			return
		end

		self:increment_stat(arg_37_1, "shovel_big_suck")
	end
}

local num_33 = 15
local num_34 = 5

achievements.shovel_big_cleave = {
	display_completion_ui = true,
	name = "achv_big_cleave_name",
	required_career = "bw_necromancer",
	icon = "reaping_time",
	required_dlc = "shovel",
	desc = function ()
		-- function 38
		return string.format(Localize("achv_big_cleave_desc"), num_33, num_34)
	end,
	events = {
		"on_hit"
	},
	completed = function (self, arg_39_1, arg_39_2)
		-- function 39
		return self:get_persistent_stat(arg_39_1, "shovel_big_cleave") >= num_34
	end,
	on_event = function (self, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
		-- function 40
		if arg_40_4[9] ~= "bw_ghost_scythe" then
			return
		end

		if arg_40_4[2] == "aoe" then
			return
		end

		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit
		local var_40_2 = arg_40_4[8]

		if not (not var_40_2 and flag == var_40_2) then
			return
		end

		if arg_40_4[4] == num_33 + 1 then
			self:increment_stat(arg_40_1, "shovel_big_cleave")
		end
	end
}

local num_35 = 100

achievements.shovel_headshot_scythe = {
	display_completion_ui = true,
	name = "achv_headshot_scythe_name",
	required_career = "bw_necromancer",
	icon = "ripe_harvest",
	required_dlc = "shovel",
	desc = function ()
		-- function 41
		return string.format(Localize("achv_headshot_scythe_desc"), num_35)
	end,
	events = {
		"on_hit"
	},
	progress = function (self, arg_42_1, arg_42_2)
		-- function 42
		local get_persistent_stat = self:get_persistent_stat(arg_42_1, "shovel_headshot_scythe")

		return {
			get_persistent_stat,
			num_35
		}
	end,
	completed = function (self, arg_43_1, arg_43_2)
		-- function 43
		return self:get_persistent_stat(arg_43_1, "shovel_headshot_scythe") >= num_35
	end,
	on_event = function (self, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
		-- function 44
		if arg_44_4[9] ~= "bw_ghost_scythe" then
			return
		end

		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit
		local var_44_2 = arg_44_4[8]

		if not (not var_44_2 and flag == var_44_2) then
			return
		end

		if arg_44_4[3] == "head" then
			self:increment_stat(arg_44_1, "shovel_headshot_scythe")
		end
	end
}

local num_36 = 3
local num_37 = 4

local function fn(self, arg_45_1)
	-- function 45
	local unbox = self.knockback_position:unbox()
	local is_valid = Unit.is_valid(arg_45_1)

	is_valid = not is_valid and not not Unit.is_frozen(arg_45_1) or Unit.local_position(arg_45_1, 0)

	if not (not is_valid and not (unbox[3] - is_valid[3] < num_37)) then
		return false
	end

	return true
end

achievements.shovel_staff_gandalf = {
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
	completed = function (self, arg_46_1, arg_46_2)
		-- function 46
		return self:get_persistent_stat(arg_46_1, "shovel_staff_gandalf") >= 1
	end,
	on_event = function (self, arg_47_1, arg_47_2, arg_47_3, arg_47_4)
		-- function 47
		local time = Managers.time:time("game")

		if arg_47_3 == "register_kill" then
			local var_47_1 = arg_47_4[num_7]
			local tracked_units = arg_47_2.tracked_units

			tracked_units = not tracked_units and arg_47_2.tracked_units[var_47_1]

			if not tracked_units then
				return
			end

			if time - tracked_units.knockback_time > num_36 then
				return false
			end

			if not fn(tracked_units, var_47_1) then
				self:increment_stat(arg_47_1, "shovel_staff_gandalf")

				return
			end
		elseif arg_47_3 == "on_hit" then
			local var_47_3 = arg_47_4[1]
			local get_data = Unit.get_data(var_47_3, "breed")

			if not (not get_data and get_data.name == "chaos_warrior") then
				return
			end

			if arg_47_4[9] ~= "bw_ghost_scythe" then
				return
			end

			if arg_47_4[2] ~= "aoe" then
				return
			end

			local local_player = Managers.player:local_player()
			local flag = not local_player and local_player.player_unit
			local has_extension = ScriptUnit.has_extension(flag, "career_system")

			if not (not has_extension and has_extension:career_name() == "bw_necromancer") then
				return
			end

			has_extension:get_passive_ability_by_name("bw_necromancer"):achievement_staff_gandalf_trigger(var_47_3, time, math.max(num_36, 6))

			local tracked_units_2 = arg_47_2.tracked_units

			tracked_units_2 = tracked_units_2 or {}
			arg_47_2.tracked_units = tracked_units_2

			local var_47_9 = arg_47_2.tracked_units[var_47_3]

			if not var_47_9 then
				var_47_9.knockback_time = time

				var_47_9.knockback_position:store(POSITION_LOOKUP[var_47_3])
			else
				arg_47_2.tracked_units[var_47_3] = {
					knockback_time = time,
					knockback_position = Vector3Box(POSITION_LOOKUP[var_47_3])
				}
			end
		else
			local var_47_10 = arg_47_4[1]
			local var_47_11 = arg_47_2.tracked_units[var_47_10]

			if not fn(var_47_11, var_47_10) then
				self:increment_stat(arg_47_1, "shovel_staff_gandalf")

				return
			end
		end
	end
}

local num_38 = 500

achievements.shovel_skeleton_balefire = {
	always_run = true,
	name = "achv_skeleton_balefire_name",
	display_completion_ui = true,
	required_career = "bw_necromancer",
	icon = "unrestful_bonefire",
	required_dlc = "shovel",
	desc = function ()
		-- function 48
		return string.format(Localize("achv_skeleton_balefire_desc"), num_38)
	end,
	events = {
		"on_damage_dealt"
	},
	progress = function (self, arg_49_1, arg_49_2)
		-- function 49
		local get_persistent_stat = self:get_persistent_stat(arg_49_1, "shovel_skeleton_balefire")

		return {
			get_persistent_stat,
			num_38
		}
	end,
	completed = function (self, arg_50_1, arg_50_2)
		-- function 50
		return self:get_persistent_stat(arg_50_1, "shovel_skeleton_balefire") >= num_38
	end,
	on_event = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4)
		-- function 51
		if not Managers.state.network.is_server then
			return
		end

		local var_51_0 = arg_51_4[2]
		local get_commander_unit = Managers.state.entity:system("ai_commander_system"):get_commander_unit(var_51_0)

		if not get_commander_unit then
			return
		end

		local owner = Managers.player:owner(get_commander_unit)

		if not owner then
			return
		end

		if not arg_51_2[owner:stats_id()] then
			return
		end

		local var_51_3 = arg_51_4[1]
		local has_status, var_51_5 = Managers.state.status_effect:has_status(var_51_3, "burning_balefire")

		if not has_status and not var_51_5 then
			return
		end

		local count = arg_51_2.count

		count = count or {}
		arg_51_2.count = count

		local count_2 = arg_51_2.count
		local var_51_8 = arg_51_2.count[get_commander_unit]

		var_51_8 = var_51_8 or 0
		count_2[get_commander_unit] = var_51_8 + 1

		if arg_51_2.count[get_commander_unit] <= num_38 then
			rpc_increment_stat(get_commander_unit, "shovel_skeleton_balefire")
		else
			arg_51_2[owner:stats_id()] = true
		end
	end
}

local function fn_2(self, arg_52_1)
	-- function 52
	if not self.timer_start_t then
		local num = arg_52_1 - self.timer_start_t

		self.total_time = self.total_time + num
	end

	self.timer_start_t = nil
end

local function fn_3(self, arg_53_1)
	-- function 53
	fn_2(self, arg_53_1)

	self.timer_start_t = arg_53_1
end

local num_39 = 4
local num_40 = 0.95
local num_41 = 95

achievements.shovel_keep_skeletons_alive = {
	display_completion_ui = true,
	name = "achv_keep_skeletons_alive_name",
	required_career = "bw_necromancer",
	icon = "the_soul_of_the_party",
	required_dlc = "shovel",
	desc = function ()
		-- function 54
		return string.format(Localize("achv_keep_skeletons_alive_desc"), num_41)
	end,
	events = {
		"on_controlled_unit_added",
		"on_controlled_unit_removed",
		"on_round_started",
		"register_completed_level"
	},
	completed = function (self, arg_55_1, arg_55_2)
		-- function 55
		return self:get_persistent_stat(arg_55_1, "shovel_keep_skeletons_alive") >= 1
	end,
	on_event = function (self, arg_56_1, arg_56_2, arg_56_3, arg_56_4)
		-- function 56
		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit

		if not flag then
			return
		end

		if ScriptUnit.extension(flag, "career_system"):career_name() ~= "bw_necromancer" then
			return
		end

		local time = Managers.time:time("game")

		if arg_56_3 == "on_round_started" then
			local level_start_t = arg_56_2.level_start_t

			level_start_t = level_start_t or time
			arg_56_2.level_start_t = level_start_t
			arg_56_2.total_time = 0
		elseif not arg_56_2.level_start_t then
			return
		elseif arg_56_3 == "register_completed_level" then
			fn_2(arg_56_2, time)

			local level_start_t_2 = arg_56_2.level_start_t

			if not (not level_start_t_2 and level_start_t_2 == time) then
				local num = time - level_start_t_2

				if arg_56_2.total_time / num >= num_40 then
					self:increment_stat(arg_56_1, "shovel_keep_skeletons_alive")
				end
			end
		end

		if ScriptUnit.extension(flag, "ai_commander_system"):get_controlled_units_count() < num_39 then
			fn_2(arg_56_2, time)
		else
			fn_3(arg_56_2, time)
		end
	end
}

local tbl_4 = {
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

add_meta_challenge(achievements, "necro_complete_all", tbl_4, "mistress_of_necromancy", "shovel", nil, nil)
