-- chunkname: @scripts/settings/dlcs/bless/buff_settings_bless.lua

require("scripts/settings/profiles/career_constants")

local scripts_utils_stagger_types = require("scripts/utils/stagger_types")
local scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")
local bless = DLCSettings.bless
local num = 2
local num_2 = 3

bless.buff_templates = {
	victor_priest_activated_ability_invincibility = {
		buffs = {
			{
				priority_buff = true,
				name = "victor_priest_activated_ability_invincibility",
				icon = "victor_priest_activated_ability",
				remove_buff_func = "victor_priest_on_career_skill_removed",
				update_func = "victor_priest_on_career_skill_update",
				apply_buff_func = "victor_priest_on_career_skill_applied",
				refresh_durations = true,
				max_stacks = 1,
				reapply_buff_func = "victor_priest_on_career_skill_applied",
				duration = CareerConstants.wh_priest.ability_base_duration,
				mechanism_overrides = {
					versus = {
						duration = CareerConstants.wh_priest.ability_base_duration_versus
					}
				},
				perks = {
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.invulnerable
				}
			},
			{
				stagger_distance = 1,
				push_radius = 3.5,
				name = "victor_priest_6_1_pulse_attack",
				buff_func = "victor_priest_6_1_pulse_attack",
				event = "on_melee_hit",
				apply_condition = function (arg_1_0, arg_1_1, arg_1_2)
					-- function 1
					if not Managers.state.network.is_server then
						return false
					end

					local attacker_unit = arg_1_2.attacker_unit

					if not ScriptUnit.extension(attacker_unit, "talent_system"):has_talent("victor_priest_6_1") then
						return false
					end

					return true
				end,
				duration = CareerConstants.wh_priest.ability_base_duration,
				mechanism_overrides = {
					versus = {
						duration = CareerConstants.wh_priest.ability_base_duration_versus
					}
				},
				stagger_impact = {
					scripts_utils_stagger_types.medium,
					scripts_utils_stagger_types.none,
					scripts_utils_stagger_types.none,
					scripts_utils_stagger_types.none,
					scripts_utils_stagger_types.none
				}
			}
		}
	},
	victor_priest_activated_ability_nuke = {
		deactivation_sound = "career_ability_priest_buildup_stop",
		activation_sound = "career_ability_priest_buildup",
		buffs = {
			{
				apply_buff_func = "victor_priest_activated_ability_nuke_start",
				name = "victor_priest_activated_ability_nuke",
				refresh_durations = true,
				remove_buff_func = "victor_priest_activated_ability_nuke",
				priority_buff = true,
				max_stacks = 1,
				reapply_buff_func = "victor_priest_activated_ability_nuke_start",
				duration = CareerConstants.wh_priest.ability_base_duration,
				mechanism_overrides = {
					versus = {
						duration = CareerConstants.wh_priest.ability_base_duration_versus
					}
				}
			}
		}
	},
	victor_priest_activated_noclip = {
		buffs = {
			{
				stagger_distance = 1,
				name = "victor_priest_activated_noclip",
				push_cooldown = 1,
				apply_buff_func = "victor_priest_activated_noclip_apply",
				push_radius = 1.5,
				remove_buff_func = "victor_priest_activated_noclip_remove",
				refresh_durations = true,
				max_stacks = 1,
				update_func = "victor_priest_activated_noclip_update",
				update_frequency = 0.1,
				duration = CareerConstants.wh_priest.ability_base_duration,
				mechanism_overrides = {
					versus = {
						duration = CareerConstants.wh_priest.ability_base_duration_versus
					}
				},
				perks = {
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.no_ranged_knockback
				},
				stagger_impact = {
					scripts_utils_stagger_types.medium,
					scripts_utils_stagger_types.none,
					scripts_utils_stagger_types.none,
					scripts_utils_stagger_types.none,
					scripts_utils_stagger_types.none
				},
				no_clip_filter = {
					true,
					false,
					false,
					false,
					false,
					false
				}
			}
		}
	},
	victor_priest_nuke_dot = {
		buffs = {
			{
				duration = 5,
				name = "victor_priest_nuke_dot",
				apply_buff_func = "start_dot_damage",
				update_start_delay = 0.7,
				time_between_dot_damages = 0.7,
				damage_type = "burninating",
				damage_profile = "burning_dot",
				update_func = "apply_dot_damage",
				perks = {
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.burning
				},
				mechanism_overrides = {
					versus = {
						damage_profile = "victor_priest_nuke_dot_vs"
					}
				}
			}
		}
	},
	victor_priest_book_buff_attack_speed = {
		buffs = {
			{
				multiplier = 0.1,
				name = "victor_priest_book_buff_attack_speed",
				stat_buff = "attack_speed",
				max_stacks = 1,
				icon = "victor_witchhunter_activated_ability_guaranteed_crit_self_buff"
			},
			{
				max_stacks = 1,
				name = "victor_priest_book_buff_crit",
				stat_buff = "critical_strike_chance",
				bonus = 0.05
			}
		}
	},
	victor_priest_book_buff_heal_on_damage = {
		buffs = {
			{
				max_stacks = 1,
				name = "victor_priest_book_buff_heal_on_damage",
				buff_func = "victor_priest_book_buff_heal_on_kill_proc",
				event = "on_kill",
				icon = "bardin_ranger_increased_melee_damage_on_no_ammo"
			}
		}
	},
	victor_priest_book_buff_stamina = {
		buffs = {
			{
				max_stacks = 1,
				name = "victor_priest_book_buff_block_cost",
				stat_buff = "block_cost",
				multiplier = -0.3
			},
			{
				max_stacks = 1,
				name = "victor_priest_book_buff_stamina",
				stat_buff = "max_fatigue",
				bonus = 6
			},
			{
				max_stacks = 1,
				name = "victor_priest_book_buff_push_angle",
				stat_buff = "block_angle",
				multiplier = 0.5
			}
		}
	},
	victor_priest_passive_aftershock = {
		deactivation_sound = "career_priest_fury_stop",
		activation_sound = "career_priest_fury_start",
		buffs = {
			{
				buff_to_add = "victor_priest_passive_smite",
				name = "victor_priest_passive_aftershock",
				max_stacks = 1,
				buff_func = "add_buff_to_hit_enemy",
				event = "on_damage_dealt",
				icon = "victor_priest_passive",
				buff_to_add_upgraded = "victor_priest_passive_smite_upgraded"
			}
		}
	},
	victor_priest_passive_smite = {
		buffs = {
			{
				damage_multiplier = 0.2,
				name = "victor_priest_passive_smite",
				duration = 0.3,
				damage_profile = "light_push",
				remove_buff_func = "victor_priest_activated_ability_aftershock_update"
			}
		}
	},
	victor_priest_passive_smite_upgraded = {
		buffs = {
			{
				name = "victor_priest_passive_smite",
				duration = 0.3,
				damage_profile = "light_push",
				remove_buff_func = "victor_priest_activated_ability_aftershock_update",
				damage_multiplier = CareerConstants.wh_priest.talent_4_2_smite_improved_damage
			}
		}
	}
}
bless.proc_functions = {
	add_buff_to_hit_enemy = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		-- function 2
		local var_2_0 = arg_2_2[1]
		local var_2_1 = arg_2_2[7]

		if not (not ALIVE[arg_2_0] and not ALIVE[var_2_0] and not var_2_1 and var_2_1 == "light_attack" or var_2_1 ~= "heavy_attack") then
			local buff_to_add = arg_2_1.template.buff_to_add
			local has_extension = ScriptUnit.has_extension(arg_2_0, "talent_system")

			if not (not has_extension and has_extension:has_talent("victor_priest_4_2_new")) then
				buff_to_add = arg_2_1.template.buff_to_add_upgraded
			end

			local has_extension_2 = ScriptUnit.has_extension(var_2_0, "buff_system")

			if not has_extension_2 then
				local tbl = {
					external_optional_value = arg_2_2[3],
					attacker_unit = arg_2_0
				}

				has_extension_2:add_buff(buff_to_add, tbl)
			end
		end
	end,
	victor_priest_4_1_on_damage_taken = function (arg_3_0, arg_3_1, arg_3_2)
		-- function 3
		local get_passive_ability_by_name = ScriptUnit.extension(arg_3_0, "career_system"):get_passive_ability_by_name("wh_priest")
		local var_3_1 = arg_3_2[1]

		if not Managers.state.side:is_ally(arg_3_0, var_3_1) then
			return
		end

		if not ScriptUnit.extension(arg_3_0, "status_system"):is_knocked_down() then
			return
		end

		local num = arg_3_2[2] * CareerConstants.wh_priest.talent_4_1_fury_gain_mult

		get_passive_ability_by_name:modify_resource(num)
	end,
	add_buff_to_first_hit_enemy = function (arg_4_0, arg_4_1, arg_4_2)
		-- function 4
		local var_4_0 = arg_4_2[1]
		local var_4_1 = arg_4_2[7]
		local var_4_2 = arg_4_2[8]

		if not (not var_4_2 and not (var_4_2 > 1)) then
			return
		end

		if not (not ALIVE[arg_4_0] and not ALIVE[var_4_0] and not var_4_1 and var_4_1 == "light_attack" or var_4_1 ~= "heavy_attack") then
			local buff_to_add = arg_4_1.template.buff_to_add
			local has_extension = ScriptUnit.has_extension(var_4_0, "buff_system")

			if not has_extension then
				local tbl = {
					external_optional_value = arg_4_2[3],
					attacker_unit = arg_4_0
				}

				has_extension:add_buff(buff_to_add, tbl)
			end
		end
	end,
	victor_priest_book_buff_heal_on_kill_proc = function (arg_5_0, arg_5_1, arg_5_2)
		-- function 5
		if not Managers.state.network.is_server then
			return
		end

		if not ALIVE[arg_5_0] then
			local var_5_0 = Managers.state.side.side_by_unit[arg_5_0]
			local bloodlust_health = arg_5_2[2].bloodlust_health

			bloodlust_health = bloodlust_health or 0

			local num = bloodlust_health / 2
			local PLAYER_AND_BOT_UNITS = var_5_0.PLAYER_AND_BOT_UNITS

			for i = 1, #PLAYER_AND_BOT_UNITS do
				local var_5_4 = PLAYER_AND_BOT_UNITS[i]

				if not HEALTH_ALIVE[var_5_4] then
					local extension = ScriptUnit.extension(var_5_4, "status_system")

					if not (extension:is_knocked_down() or extension:is_assisted_respawning()) then
						DamageUtils.heal_network(var_5_4, arg_5_0, num, "career_passive")
					end
				end
			end
		end
	end,
	add_buff_on_elite_kill = function (arg_6_0, arg_6_1, arg_6_2)
		-- function 6
		if not (not ALIVE[arg_6_0] and arg_6_2[1][DamageDataIndex.ATTACKER] ~= arg_6_0) then
			ScriptUnit.extension(arg_6_0, "buff_system"):add_buff(arg_6_1.template.buff_to_add)
		end
	end,
	victor_priest_store_damage = function (arg_7_0, arg_7_1, arg_7_2)
		-- function 7
		if not ALIVE[arg_7_0] then
			if not arg_7_1.damage_table then
				arg_7_1.damage_table = {}
			end

			local has_extension = ScriptUnit.has_extension(arg_7_0, "status_system")

			if not has_extension and not has_extension:is_knocked_down() then
				return
			end

			local var_7_1 = arg_7_2[2]
			local var_7_2 = var_7_1
			local time = Managers.time:time("game")
			local has_extension_2 = ScriptUnit.has_extension(arg_7_0, "health_system")
			local flag = not has_extension_2 and has_extension_2:current_temporary_health()

			if not flag then
				local num = var_7_2 - flag

				if num <= 0 then
					local tbl = {
						temp_hp = true,
						t = time,
						damage_taken = var_7_1
					}

					table.insert(arg_7_1.damage_table, tbl)
				elseif num == var_7_1 then
					local tbl_2 = {
						temp_hp = false,
						t = time,
						damage_taken = var_7_1
					}

					table.insert(arg_7_1.damage_table, tbl_2)
				else
					local tbl_3 = {
						temp_hp = true,
						t = time,
						damage_taken = flag
					}

					table.insert(arg_7_1.damage_table, tbl_3)

					local tbl_4 = {
						temp_hp = false,
						t = time,
						damage_taken = num
					}

					table.insert(arg_7_1.damage_table, tbl_4)
				end
			end

			arg_7_1.list_dirty = true

			while not arg_7_1.list_dirty do
				if time - arg_7_1.damage_table[1].t > arg_7_1.template.heal_window then
					table.remove(arg_7_1.damage_table, 1)
				else
					arg_7_1.list_dirty = false
				end
			end
		end
	end,
	victor_priest_damage_stagger = function (arg_8_0, arg_8_1, arg_8_2)
		-- function 8
		if not ALIVE[arg_8_0] then
			local var_8_0 = arg_8_2[num_2]

			if not (var_8_0 == "life_tap" or var_8_0 ~= "knockdown_bleed") then
				return false
			end

			local var_8_1 = arg_8_2[num]
			local extension = ScriptUnit.extension(arg_8_0, "buff_system")
			local template = arg_8_1.template
			local staggered_damage_taken = template.staggered_damage_taken
			local num_3 = (var_8_1 + var_8_1 * (staggered_damage_taken / (1 - staggered_damage_taken))) * template.percentage_to_take
			local tbl = {
				external_optional_value = num_3
			}
			local get_buff_type = extension:get_buff_type("damage_stagger")

			if not get_buff_type then
				local value = get_buff_type.value
				local damage_dealt = get_buff_type.damage_dealt

				damage_dealt = damage_dealt or 0
				get_buff_type.value = num_3 + (value - damage_dealt)
				get_buff_type.damage_dealt = 0
				get_buff_type.start_time = Managers.time:time("game")
			end

			local buff_to_add = template.buff_to_add

			extension:add_buff(buff_to_add, tbl)
		end
	end,
	add_buff_on_num_targets_hit = function (arg_9_0, arg_9_1, arg_9_2)
		-- function 9
		if not ALIVE[arg_9_0] then
			local template = arg_9_1.template

			if template.num_targets > arg_9_2[4] then
				return
			end

			local var_9_1 = arg_9_2[2]

			if not (var_9_1 == "light_attack" or var_9_1 == "heavy_attack") then
				return
			end

			local block_buff = template.block_buff
			local extension = ScriptUnit.extension(arg_9_0, "buff_system")

			if not block_buff and not extension:has_buff_type(block_buff) then
				return
			end

			local buff_to_add = template.buff_to_add

			Managers.state.entity:system("buff_system"):add_buff(arg_9_0, buff_to_add, arg_9_0, false)
		end
	end,
	victor_priest_knockback_on_hit = function (arg_10_0, arg_10_1, arg_10_2)
		-- function 10
		if not ALIVE[arg_10_0] then
			if arg_10_2[4] > 1 then
				return
			end

			local var_10_0 = arg_10_2[2]

			if not (var_10_0 == "light_attack" or var_10_0 == "heavy_attack") then
				return
			end

			local get_career_power_level = ScriptUnit.has_extension(arg_10_0, "career_system"):get_career_power_level()
			local var_10_2 = arg_10_2[1]
			local var_10_3 = POSITION_LOOKUP[var_10_2]

			Managers.state.entity:system("area_damage_system"):create_explosion(arg_10_0, var_10_3, Quaternion.identity(), "victor_priest_melee_explosion", 1, "career_ability", get_career_power_level, false)

			local extension = ScriptUnit.extension(arg_10_0, "buff_system")

			extension:add_buff(arg_10_1.template.buff_to_add)
			extension:remove_buff(arg_10_1.id)
		end
	end,
	victor_priest_add_buff_first_target = function (arg_11_0, arg_11_1, arg_11_2)
		-- function 11
		if not ALIVE[arg_11_0] then
			if arg_11_2[4] > 1 then
				return
			end

			if not arg_11_1.buff_ids then
				arg_11_1.buff_ids = {}
			end

			local buff_to_add = arg_11_1.template.buff_to_add
			local extension = ScriptUnit.extension(arg_11_0, "buff_system")

			arg_11_1.buff_ids[#arg_11_1.buff_ids + 1] = extension:add_buff(buff_to_add)
		end
	end,
	victor_priest_passive_resource = function (arg_12_0, arg_12_1, arg_12_2)
		-- function 12
		if not ALIVE[arg_12_0] then
			local var_12_0
			local template = arg_12_1.template
			local var_12_2 = arg_12_2[2]

			if not var_12_2.elite then
				var_12_0 = template.fury_on_elite
			elseif not var_12_2.special then
				var_12_0 = template.fury_on_special
			elseif not var_12_2.boss then
				var_12_0 = template.fury_on_boss
			else
				var_12_0 = template.fury_on_normal
			end

			local has_extension = ScriptUnit.has_extension(arg_12_0, "overcharge_system")

			if not has_extension then
				has_extension:add_charge(var_12_0)
			end
		end
	end,
	victor_priest_passive_resource_activate = function (arg_13_0, arg_13_1, arg_13_2)
		-- function 13
		if not ALIVE[arg_13_0] then
			local has_extension = ScriptUnit.has_extension(arg_13_0, "overcharge_system")

			if not has_extension then
				return
			end

			if not has_extension:is_above_critical_limit() then
				return
			end

			local var_13_1 = arg_13_2[2]

			if not (not var_13_1 and var_13_1 == "heavy_attack") then
				return
			end

			local buff_to_add = arg_13_1.template.buff_to_add
			local extension = ScriptUnit.extension(arg_13_0, "buff_system")

			if not extension:get_buff_type(buff_to_add) then
				extension:add_buff(buff_to_add)

				local owner = Managers.player:owner(arg_13_0)

				if not (not owner and not owner.remote) then
					local extension_input = ScriptUnit.extension_input(arg_13_0, "dialogue_system")
					local alloc_table = FrameTable.alloc_table()

					extension_input:trigger_networked_dialogue_event("activate_ability", alloc_table)

					local extension_2 = ScriptUnit.extension(arg_13_0, "first_person_system")

					extension_2:play_hud_sound_event("career_ability_priest_cast_t1")
					extension_2:play_remote_unit_sound_event("career_ability_priest_cast_t1", arg_13_0, 0)
				end
			end
		end
	end,
	victor_priest_4_3_heal_on_kill = function (arg_14_0, arg_14_1, arg_14_2)
		-- function 14
		local is_server = Managers.state.network.is_server

		if Managers.player:owner(arg_14_0).remote or not ScriptUnit.extension(arg_14_0, "talent_system"):has_talent("victor_priest_4_3") then
			local get_passive_ability_by_name = ScriptUnit.extension(arg_14_0, "career_system"):get_passive_ability_by_name("wh_priest")
			local percent_fury_to_gain = arg_14_1.template.percent_fury_to_gain

			get_passive_ability_by_name:modify_resource_percent(percent_fury_to_gain)
		end

		if not is_server then
			return
		end

		local extension = ScriptUnit.extension(arg_14_0, "buff_system")

		if not (not extension and extension:has_buff_type("victor_priest_passive_aftershock")) then
			return
		end

		if not arg_14_2[1] then
			return
		end

		local var_14_4 = arg_14_2[2]

		if not (not var_14_4 and var_14_4.is_hero) then
			local bloodlust_health = var_14_4.bloodlust_health

			bloodlust_health = bloodlust_health or 0

			local var_14_6 = Managers.state.side.side_by_unit[arg_14_0]

			if not var_14_6 then
				return
			end

			local PLAYER_AND_BOT_UNITS = var_14_6.PLAYER_AND_BOT_UNITS
			local count = #PLAYER_AND_BOT_UNITS
			local num = bloodlust_health * 0.5

			for i = 1, count do
				local var_14_10 = PLAYER_AND_BOT_UNITS[i]

				if not ALIVE[var_14_10] then
					DamageUtils.heal_network(var_14_10, arg_14_0, num, "career_passive")
				end
			end
		end
	end,
	victor_priest_6_1_pulse_attack = function (arg_15_0, arg_15_1, arg_15_2)
		-- function 15
		local template = arg_15_1.template
		local push_radius = template.push_radius
		local stagger_impact = template.stagger_impact
		local stagger_distance = template.stagger_distance
		local time = Managers.time:time("game")
		local var_15_5 = POSITION_LOOKUP[arg_15_0]
		local alloc_table = FrameTable.alloc_table()
		local broadphase_categories = arg_15_1.broadphase_categories

		broadphase_categories = broadphase_categories or Managers.state.side.side_by_unit[arg_15_0].enemy_broadphase_categories
		arg_15_1.broadphase_categories = broadphase_categories

		local broadphase_query = AiUtils.broadphase_query(var_15_5, push_radius, alloc_table, arg_15_1.broadphase_categories)

		for i = 1, broadphase_query do
			local var_15_9 = alloc_table[i]
			local var_15_10 = POSITION_LOOKUP[var_15_9]
			local normalize = Vector3.normalize(var_15_10 - var_15_5)

			AiUtils.stagger_target(arg_15_0, var_15_9, stagger_distance, stagger_impact, normalize, time)
		end
	end
}
bless.buff_function_templates = {
	victor_priest_passive_active_update = function (arg_16_0, arg_16_1, arg_16_2)
		-- function 16
		if not ALIVE[arg_16_0] then
			local has_extension = ScriptUnit.has_extension(arg_16_0, "overcharge_system")

			if not has_extension then
				return
			end

			local template = arg_16_1.template
			local extension = ScriptUnit.extension(arg_16_0, "buff_system")
			local time = Managers.time:time("game")
			local num = template.fury_to_remove + math.floor((time - arg_16_1.start_time) / 2) / 15

			has_extension:remove_charge(num)

			if has_extension:get_overcharge_value() <= 0 then
				extension:remove_buff(arg_16_1.id)
			end
		end
	end,
	victor_priest_passive_grow = function (arg_17_0, arg_17_1, arg_17_2)
		-- function 17
		if not ALIVE[arg_17_0] then
			if not arg_17_1.stack_ids then
				arg_17_1.stack_ids = {}
			end

			local extension = ScriptUnit.extension(arg_17_0, "buff_system")

			if not extension:get_buff_type("victor_priest_righteous_fury_active_buff") then
				arg_17_1.stack_ids[#arg_17_1.stack_ids + 1] = extension:add_buff(arg_17_1.template.buff_to_add)
			elseif #arg_17_1.stack_ids > 0 then
				for i = 1, #arg_17_1.stack_ids do
					extension:remove_buff(arg_17_1.stack_ids[i])
				end

				arg_17_1.stack_ids = {}
			end
		end
	end,
	victor_priest_delayed_buff_remove = function (arg_18_0, arg_18_1, arg_18_2)
		-- function 18
		local var_18_0 = arg_18_0

		if not ALIVE[var_18_0] then
			local extension = ScriptUnit.extension(var_18_0, "buff_system")
			local get_non_stacking_buff = extension:get_non_stacking_buff(arg_18_1.template.buff_list_buff)

			if not get_non_stacking_buff then
				local buff_ids = get_non_stacking_buff.buff_ids

				if not buff_ids then
					for i = 1, #buff_ids do
						extension:queue_remove_buff(buff_ids[i])
					end
				end
			end
		end
	end,
	victor_priest_deal_damage_on_remove = function (arg_19_0, arg_19_1, arg_19_2)
		-- function 19
		if not ALIVE[arg_19_0] then
			local attacker_unit = arg_19_1.attacker_unit
			local value = arg_19_1.value

			if not (not value and not (value <= 0)) then
				return
			end

			local num = 0.2
			local extension = ScriptUnit.extension(attacker_unit, "buff_system")

			if not extension then
				num = num + 0.02 * extension:num_buff_type("victor_priest_4_2_stack")
			end

			local num_2 = value * num

			DamageUtils.add_damage_network(arg_19_0, attacker_unit, num_2, "torso", "buff", nil, Vector3(0, 0, 0), "career_ability", nil, attacker_unit, nil, nil, nil, nil, nil, nil, nil, nil, 1)

			local get_career_power_level = ScriptUnit.has_extension(attacker_unit, "career_system"):get_career_power_level()
			local num_3 = POSITION_LOOKUP[arg_19_0] + Vector3.up() * 0.5

			Managers.state.entity:system("area_damage_system"):create_explosion(attacker_unit, num_3, Quaternion.identity(), "victor_priest_career_skill_aftershock", 1, "career_ability", get_career_power_level, false)
		end
	end,
	victor_priest_activated_ability_aftershock_update = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
		-- function 20
		if not Managers.state.network.is_server then
			return
		end

		local attacker_unit = arg_20_1.attacker_unit

		if not ALIVE[arg_20_0] and not ALIVE[attacker_unit] then
			if not ScriptUnit.has_extension(arg_20_0, "buff_system") then
				return
			end

			local value = arg_20_1.value

			if not (not value and not (value <= 0)) then
				return
			end

			local num = value * arg_20_1.template.damage_multiplier

			DamageUtils.add_damage_network(arg_20_0, attacker_unit, num, "torso", "buff", nil, Vector3(0, 0, 0), "career_ability", nil, attacker_unit, nil, nil, nil, nil, nil, nil, nil, nil, 1)

			local get_career_power_level = ScriptUnit.has_extension(attacker_unit, "career_system"):get_career_power_level()
			local num_2 = POSITION_LOOKUP[arg_20_0] + Vector3.up() * 0.5
			local system = Managers.state.entity:system("weapon_system")
			local str = "career_ability"
			local var_20_7 = NetworkLookup.damage_sources[str]
			local network = Managers.state.network
			local unit_game_object_id = network:unit_game_object_id(attacker_unit)
			local unit_game_object_id_2 = network:unit_game_object_id(arg_20_0)
			local body = NetworkLookup.hit_zones.body
			local damage_profile = arg_20_1.template.damage_profile
			local var_20_13 = NetworkLookup.damage_profiles[damage_profile]
			local var_20_14 = POSITION_LOOKUP[arg_20_0]

			var_20_14 = var_20_14 or 0

			local var_20_15 = POSITION_LOOKUP[attacker_unit]

			var_20_15 = var_20_15 or 0

			local normalize = Vector3.normalize(var_20_14 - var_20_15)

			system:send_rpc_attack_hit(var_20_7, unit_game_object_id, unit_game_object_id_2, body, num_2, normalize, var_20_13, "power_level", get_career_power_level)

			local str_2 = "fx/wp_enemy_explosion"

			if not Unit.has_node(arg_20_0, "j_neck") then
				return
			end

			local go_id = Managers.state.unit_storage:go_id(arg_20_0)

			if not go_id then
				local var_20_19 = NetworkLookup.effects[str_2]
				local node = Unit.node(arg_20_0, "j_neck")

				network:rpc_play_particle_effect_no_rotation(nil, var_20_19, go_id, node, Vector3.zero(), false)

				local owner = Managers.player:owner(attacker_unit)

				if not owner then
					local str_3 = "career_priest_fury_smite"
					local str_4 = "career_priest_fury_smite_husk"

					if not owner.remote then
						WwiseUtils.trigger_unit_event(arg_20_3, str_4, arg_20_0, node)

						local network_id = owner:network_id()
						local var_20_25 = NetworkLookup.sound_events[str_3]

						network.network_transmit:send_rpc("rpc_server_audio_unit_event", network_id, var_20_25, go_id, false, node)

						local var_20_26 = NetworkLookup.sound_events[str_4]

						network.network_transmit:send_rpc_clients_except("rpc_server_audio_unit_event", network_id, var_20_26, go_id, false, node)
					else
						WwiseUtils.trigger_unit_event(arg_20_3, str_3, arg_20_0, node)

						local var_20_27 = NetworkLookup.sound_events[str_4]

						network.network_transmit:send_rpc_clients("rpc_server_audio_unit_event", var_20_27, go_id, false, node)
					end
				end
			end
		end
	end,
	victor_priest_on_career_skill_applied = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
		-- function 21
		local str = "fx/wp_immortality_allies"
		local str_2 = "fx/wp_immortality_self"
		local player = Managers.player
		local local_player = player:local_player()

		if not (player:unit_owner(arg_21_0) == local_player) then
			local has_extension = ScriptUnit.has_extension(arg_21_0, "first_person_system")

			if not has_extension then
				if not arg_21_1.screen_space_id then
					has_extension:destroy_screen_particles(arg_21_1.screen_space_id)
				end

				arg_21_1.screen_space_id = has_extension:create_screen_particles(str_2)
			end
		else
			local node = Unit.node(arg_21_0, "j_spine")

			node = node or 0

			local world_position = Unit.world_position(arg_21_0, node)

			arg_21_1._tp_node = node

			if not arg_21_1.third_person_effect_id then
				World.destroy_particles(arg_21_3, arg_21_1.third_person_effect_id)
			end

			arg_21_1.third_person_effect_id = World.create_particles(arg_21_3, str, world_position)

			World.set_particles_life_time(arg_21_3, arg_21_1.third_person_effect_id, arg_21_1.duration)
		end

		local attacker_unit = arg_21_1.attacker_unit

		Managers.state.achievement:trigger_event("register_shield_applied", arg_21_0, attacker_unit)

		if not Managers.state.network.is_server then
			return
		end

		if not ALIVE[arg_21_0] and not ALIVE[attacker_unit] then
			local has_extension_2 = ScriptUnit.has_extension(attacker_unit, "talent_system")

			if not has_extension_2 then
				return
			end

			if not has_extension_2:has_talent("victor_priest_6_3") then
				local has_extension_3 = ScriptUnit.has_extension(arg_21_0, "status_system")

				if not has_extension_3 and not has_extension_3:is_knocked_down() then
					StatusUtils.set_revived_network(arg_21_0, true, attacker_unit)
					CharacterStateHelper.play_animation_event(arg_21_0, "revive_complete")
					StatisticsUtil.register_revive(attacker_unit, arg_21_0, Managers.player:statistics_db())
				end

				local heal_window = BuffUtils.get_buff_template("victor_priest_6_3_buff").buffs[1].heal_window

				heal_window = heal_window or 3

				local extension = ScriptUnit.extension(arg_21_0, "buff_system")
				local get_buff_type = extension:get_buff_type("victor_priest_6_3_buff")

				if not get_buff_type then
					arg_21_1.heal_amount = 0

					local damage_table = get_buff_type.damage_table

					if not damage_table then
						return
					end

					local num = 0
					local num_2 = 0

					for i = 1, #damage_table do
						local time = Managers.time:time("game")
						local var_21_17 = damage_table[i]

						if not (not var_21_17.t and not (heal_window > time - var_21_17.t)) then
							if not var_21_17.temp_hp then
								num = num + var_21_17.damage_taken
							else
								num_2 = num_2 + var_21_17.damage_taken
							end

							local damage_taken = var_21_17.damage_taken

							arg_21_1.heal_amount = arg_21_1.heal_amount + damage_taken
						end
					end

					get_buff_type.damage_table = {}

					if arg_21_1.heal_amount > 0 then
						arg_21_2 = {
							attacker_unit = attacker_unit,
							external_optional_value = {
								temp_hp = num,
								perm_hp = num_2
							}
						}

						extension:add_buff("victor_priest_6_3_delayed_heal", arg_21_2)

						local has_extension_4 = ScriptUnit.has_extension(arg_21_0, "first_person_system")

						if not has_extension_4 then
							has_extension_4:play_hud_sound_event("career_talent_priest_heal")
						end
					end
				end
			end
		end
	end,
	victor_priest_6_1_removed = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
		-- function 22
		if not Managers.state.network.is_server then
			return
		end

		if not ALIVE[arg_22_0] and not ALIVE[arg_22_1.attacker_unit] then
			local value = arg_22_1.value

			if value.perm_hp > 0 then
				DamageUtils.heal_network(arg_22_0, arg_22_1.attacker_unit, value.perm_hp, "career_passive")
			end

			if value.temp_hp > 0 then
				DamageUtils.heal_network(arg_22_0, arg_22_1.attacker_unit, value.temp_hp, "heal_from_proc")
			end
		end
	end,
	victor_priest_on_career_skill_removed = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
		-- function 23
		if not arg_23_1.screen_space_id then
			local has_extension = ScriptUnit.has_extension(arg_23_0, "first_person_system")

			if not has_extension then
				has_extension:destroy_screen_particles(arg_23_1.screen_space_id)
			end
		end

		if not arg_23_1.third_person_effect_id then
			World.destroy_particles(arg_23_3, arg_23_1.third_person_effect_id)
		end
	end,
	victor_priest_on_career_skill_update = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
		-- function 24
		if not arg_24_1.third_person_effect_id then
			if not ALIVE[arg_24_0] then
				local _tp_node = arg_24_1._tp_node

				_tp_node = _tp_node or 0

				local world_position = Unit.world_position(arg_24_0, _tp_node)

				World.move_particles(arg_24_3, arg_24_1.third_person_effect_id, world_position)
			else
				World.destroy_particles(arg_24_3, arg_24_1.third_person_effect_id)

				arg_24_1.third_person_effect_id = nil
			end
		end
	end,
	damage_stagger_dot = function (arg_25_0, arg_25_1, arg_25_2)
		-- function 25
		if not Managers.state.network.is_server then
			return
		end

		if not ALIVE[arg_25_0] then
			local template = arg_25_1.template
			local update_frequency = template.update_frequency
			local duration = template.duration
			local has_extension = ScriptUnit.has_extension(arg_25_0, "health_system")
			local num = arg_25_1.value / math.round(duration / update_frequency)
			local current_health = has_extension:current_health()

			if current_health <= num then
				num = current_health - 5
			end

			if not (not has_extension and not (num > 0)) then
				local extension = ScriptUnit.extension(arg_25_0, "buff_system")
				local get_buff_type = extension:get_buff_type("victor_priest_4_3_buff")

				if not (not get_buff_type and extension:has_buff_perk("invulnerable")) then
					extension:remove_buff(get_buff_type.id)
				end

				Managers.state.achievement:trigger_event("bless_delay_damage", arg_25_0, num)
				DamageUtils.add_damage_network(arg_25_0, arg_25_0, num, "torso", "life_tap", nil, Vector3(0, 0, 0), "life_tap", nil, arg_25_0, nil, nil, nil, nil, nil, nil, nil, nil, 1)

				if not arg_25_1.damage_dealt then
					arg_25_1.damage_dealt = 0
				end

				arg_25_1.damage_dealt = arg_25_1.damage_dealt + num
			end
		end
	end,
	victor_priest_activated_ability_nuke_start = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
		-- function 26
		local str = "fx/wp_explosion_allies"
		local str_2 = "fx/wp_explosion_self"
		local player = Managers.player
		local local_player = player:local_player()

		if not (player:unit_owner(arg_26_0) == local_player) then
			local has_extension = ScriptUnit.has_extension(arg_26_0, "first_person_system")

			if not has_extension then
				arg_26_1.screen_space_id = has_extension:create_screen_particles(str_2)
			end
		else
			local node = Unit.node(arg_26_0, "j_spine")

			arg_26_1.third_person_effect_id = ScriptWorld.create_particles_linked(arg_26_3, str, arg_26_0, node, "destroy")
		end

		local owner = Managers.player:owner(arg_26_0)
		local remote

		if not owner then
			remote = owner.remote

			if not remote then
				-- Nothing
			end

			remote = owner.bot_player

			if not remote then
				-- Nothing
			end
		end

		remote = false

		::label_26_0::

		if not ALIVE[arg_26_0] and not remote then
			WwiseUtils.trigger_unit_event(arg_26_3, "career_ability_priest_buildup_husk", arg_26_0, 0)
		end
	end,
	victor_priest_activated_ability_nuke = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
		-- function 27
		if not arg_27_1.screen_space_id then
			local has_extension = ScriptUnit.has_extension(arg_27_0, "first_person_system")

			if not has_extension then
				has_extension:destroy_screen_particles(arg_27_1.screen_space_id)
			end
		end

		if not arg_27_1.third_person_effect_id then
			World.destroy_particles(arg_27_3, arg_27_1.third_person_effect_id)
		end

		local attacker_unit = arg_27_1.attacker_unit

		if not ALIVE[attacker_unit] then
			return
		end

		local node = Unit.node(arg_27_0, "j_spine")
		local world_position = Unit.world_position(arg_27_0, node)

		world_position = world_position or POSITION_LOOKUP[arg_27_0]

		if not world_position then
			return
		end

		local str = "victor_priest_activated_ability_nuke"
		local get_template = ExplosionUtils.get_template(str)
		local local_rotation = Unit.local_rotation(arg_27_0, 0)
		local num = 1
		local str_2 = "career_ability"
		local get_career_power_level = ScriptUnit.has_extension(attacker_unit, "career_system"):get_career_power_level()
		local is_server = Managers.state.network.is_server
		local owner = Managers.player:owner(arg_27_0)
		local remote

		if not owner then
			remote = owner.remote

			if not remote then
				-- Nothing
			end

			remote = owner.bot_player

			if not remote then
				-- Nothing
			end
		end

		remote = false

		::label_27_0::

		if not ALIVE[arg_27_0] and not remote then
			WwiseUtils.trigger_unit_event(arg_27_3, "career_ability_priest_buildup_husk_stop", arg_27_0, 0)
		end

		DamageUtils.create_explosion(arg_27_3, attacker_unit, world_position, local_rotation, get_template, num, str_2, is_server, remote, attacker_unit, get_career_power_level, false, arg_27_0)
	end,
	victor_priest_activated_noclip_apply = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
		-- function 28
		local extension = ScriptUnit.extension(arg_28_0, "locomotion_system")

		if not extension.apply_no_clip_filter then
			extension:apply_no_clip_filter(arg_28_1.template.no_clip_filter, "victor_priest_activated_noclip")
		end

		if not Managers.state.network.is_server then
			arg_28_1.broadphase_results = {}
			arg_28_1.pushed_units = {}
		end
	end,
	victor_priest_activated_noclip_remove = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
		-- function 29
		local extension = ScriptUnit.extension(arg_29_0, "locomotion_system")

		if not extension.remove_no_clip_filter then
			extension:remove_no_clip_filter("victor_priest_activated_noclip")
		end
	end,
	victor_priest_activated_noclip_update = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
		-- function 30
		if not Managers.state.network.is_server then
			return
		end

		local template = arg_30_1.template
		local push_cooldown = template.push_cooldown
		local push_radius = template.push_radius
		local stagger_impact = template.stagger_impact
		local stagger_distance = template.stagger_distance
		local broadphase_results = arg_30_1.broadphase_results
		local pushed_units = arg_30_1.pushed_units
		local t = arg_30_2.t
		local enemy_broadphase_categories = Managers.state.side.side_by_unit[arg_30_0].enemy_broadphase_categories
		local var_30_9 = POSITION_LOOKUP[arg_30_0]
		local broadphase_query = AiUtils.broadphase_query(var_30_9, push_radius, broadphase_results, enemy_broadphase_categories)

		for i = 1, broadphase_query do
			local var_30_11 = broadphase_results[i]
			local var_30_12 = pushed_units[var_30_11]

			var_30_12 = var_30_12 or 0

			if var_30_12 < t then
				pushed_units[var_30_11] = t + push_cooldown

				local var_30_13 = POSITION_LOOKUP[var_30_11]
				local normalize = Vector3.normalize(var_30_13 - var_30_9)

				AiUtils.stagger_target(arg_30_0, var_30_11, stagger_distance, stagger_impact, normalize, t)
			end
		end

		table.clear(broadphase_results)
	end
}
