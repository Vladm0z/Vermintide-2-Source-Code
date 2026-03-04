-- chunkname: @scripts/settings/dlcs/bless/buff_settings_bless.lua

require("scripts/settings/profiles/career_constants")

local var_0_0 = require("scripts/utils/stagger_types")
local var_0_1 = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")
local var_0_2 = DLCSettings.bless
local var_0_3 = 2
local var_0_4 = 3

var_0_2.buff_templates = {
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
					var_0_1.invulnerable
				}
			},
			{
				stagger_distance = 1,
				push_radius = 3.5,
				name = "victor_priest_6_1_pulse_attack",
				buff_func = "victor_priest_6_1_pulse_attack",
				event = "on_melee_hit",
				apply_condition = function(arg_1_0, arg_1_1, arg_1_2)
					if not Managers.state.network.is_server then
						return false
					end

					local var_1_0 = arg_1_2.attacker_unit

					if not ScriptUnit.extension(var_1_0, "talent_system"):has_talent("victor_priest_6_1") then
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
					var_0_0.medium,
					var_0_0.none,
					var_0_0.none,
					var_0_0.none,
					var_0_0.none
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
					var_0_1.no_ranged_knockback
				},
				stagger_impact = {
					var_0_0.medium,
					var_0_0.none,
					var_0_0.none,
					var_0_0.none,
					var_0_0.none
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
					var_0_1.burning
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
var_0_2.proc_functions = {
	add_buff_to_hit_enemy = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		local var_2_0 = arg_2_2[1]
		local var_2_1 = arg_2_2[7]

		if ALIVE[arg_2_0] and ALIVE[var_2_0] and var_2_1 and (var_2_1 == "light_attack" or var_2_1 == "heavy_attack") then
			local var_2_2 = arg_2_1.template.buff_to_add
			local var_2_3 = ScriptUnit.has_extension(arg_2_0, "talent_system")

			if var_2_3 and var_2_3:has_talent("victor_priest_4_2_new") then
				var_2_2 = arg_2_1.template.buff_to_add_upgraded
			end

			local var_2_4 = ScriptUnit.has_extension(var_2_0, "buff_system")

			if var_2_4 then
				local var_2_5 = {
					external_optional_value = arg_2_2[3],
					attacker_unit = arg_2_0
				}

				var_2_4:add_buff(var_2_2, var_2_5)
			end
		end
	end,
	victor_priest_4_1_on_damage_taken = function(arg_3_0, arg_3_1, arg_3_2)
		local var_3_0 = ScriptUnit.extension(arg_3_0, "career_system"):get_passive_ability_by_name("wh_priest")
		local var_3_1 = arg_3_2[1]

		if Managers.state.side:is_ally(arg_3_0, var_3_1) then
			return
		end

		if ScriptUnit.extension(arg_3_0, "status_system"):is_knocked_down() then
			return
		end

		local var_3_2 = arg_3_2[2] * CareerConstants.wh_priest.talent_4_1_fury_gain_mult

		var_3_0:modify_resource(var_3_2)
	end,
	add_buff_to_first_hit_enemy = function(arg_4_0, arg_4_1, arg_4_2)
		local var_4_0 = arg_4_2[1]
		local var_4_1 = arg_4_2[7]
		local var_4_2 = arg_4_2[8]

		if var_4_2 and var_4_2 > 1 then
			return
		end

		if ALIVE[arg_4_0] and ALIVE[var_4_0] and var_4_1 and (var_4_1 == "light_attack" or var_4_1 == "heavy_attack") then
			local var_4_3 = arg_4_1.template.buff_to_add
			local var_4_4 = ScriptUnit.has_extension(var_4_0, "buff_system")

			if var_4_4 then
				local var_4_5 = {
					external_optional_value = arg_4_2[3],
					attacker_unit = arg_4_0
				}

				var_4_4:add_buff(var_4_3, var_4_5)
			end
		end
	end,
	victor_priest_book_buff_heal_on_kill_proc = function(arg_5_0, arg_5_1, arg_5_2)
		if not Managers.state.network.is_server then
			return
		end

		if ALIVE[arg_5_0] then
			local var_5_0 = Managers.state.side.side_by_unit[arg_5_0]
			local var_5_1 = (arg_5_2[2].bloodlust_health or 0) / 2
			local var_5_2 = var_5_0.PLAYER_AND_BOT_UNITS

			for iter_5_0 = 1, #var_5_2 do
				local var_5_3 = var_5_2[iter_5_0]

				if HEALTH_ALIVE[var_5_3] then
					local var_5_4 = ScriptUnit.extension(var_5_3, "status_system")

					if not var_5_4:is_knocked_down() and not var_5_4:is_assisted_respawning() then
						DamageUtils.heal_network(var_5_3, arg_5_0, var_5_1, "career_passive")
					end
				end
			end
		end
	end,
	add_buff_on_elite_kill = function(arg_6_0, arg_6_1, arg_6_2)
		if ALIVE[arg_6_0] and arg_6_2[1][DamageDataIndex.ATTACKER] == arg_6_0 then
			ScriptUnit.extension(arg_6_0, "buff_system"):add_buff(arg_6_1.template.buff_to_add)
		end
	end,
	victor_priest_store_damage = function(arg_7_0, arg_7_1, arg_7_2)
		if ALIVE[arg_7_0] then
			if not arg_7_1.damage_table then
				arg_7_1.damage_table = {}
			end

			local var_7_0 = ScriptUnit.has_extension(arg_7_0, "status_system")

			if var_7_0 and var_7_0:is_knocked_down() then
				return
			end

			local var_7_1 = arg_7_2[2]
			local var_7_2 = var_7_1
			local var_7_3 = Managers.time:time("game")
			local var_7_4 = ScriptUnit.has_extension(arg_7_0, "health_system")
			local var_7_5 = var_7_4 and var_7_4:current_temporary_health()

			if var_7_5 then
				local var_7_6 = var_7_2 - var_7_5

				if var_7_6 <= 0 then
					local var_7_7 = {
						temp_hp = true,
						t = var_7_3,
						damage_taken = var_7_1
					}

					table.insert(arg_7_1.damage_table, var_7_7)
				elseif var_7_6 == var_7_1 then
					local var_7_8 = {
						temp_hp = false,
						t = var_7_3,
						damage_taken = var_7_1
					}

					table.insert(arg_7_1.damage_table, var_7_8)
				else
					local var_7_9 = {
						temp_hp = true,
						t = var_7_3,
						damage_taken = var_7_5
					}

					table.insert(arg_7_1.damage_table, var_7_9)

					local var_7_10 = {
						temp_hp = false,
						t = var_7_3,
						damage_taken = var_7_6
					}

					table.insert(arg_7_1.damage_table, var_7_10)
				end
			end

			arg_7_1.list_dirty = true

			while arg_7_1.list_dirty do
				if var_7_3 - arg_7_1.damage_table[1].t > arg_7_1.template.heal_window then
					table.remove(arg_7_1.damage_table, 1)
				else
					arg_7_1.list_dirty = false
				end
			end
		end
	end,
	victor_priest_damage_stagger = function(arg_8_0, arg_8_1, arg_8_2)
		if ALIVE[arg_8_0] then
			local var_8_0 = arg_8_2[var_0_4]

			if not (var_8_0 ~= "life_tap" and var_8_0 ~= "knockdown_bleed") then
				return false
			end

			local var_8_1 = arg_8_2[var_0_3]
			local var_8_2 = ScriptUnit.extension(arg_8_0, "buff_system")
			local var_8_3 = arg_8_1.template
			local var_8_4 = var_8_3.staggered_damage_taken
			local var_8_5 = (var_8_1 + var_8_1 * (var_8_4 / (1 - var_8_4))) * var_8_3.percentage_to_take
			local var_8_6 = {
				external_optional_value = var_8_5
			}
			local var_8_7 = var_8_2:get_buff_type("damage_stagger")

			if var_8_7 then
				var_8_7.value = var_8_5 + (var_8_7.value - (var_8_7.damage_dealt or 0))
				var_8_7.damage_dealt = 0
				var_8_7.start_time = Managers.time:time("game")
			end

			local var_8_8 = var_8_3.buff_to_add

			var_8_2:add_buff(var_8_8, var_8_6)
		end
	end,
	add_buff_on_num_targets_hit = function(arg_9_0, arg_9_1, arg_9_2)
		if ALIVE[arg_9_0] then
			local var_9_0 = arg_9_1.template

			if var_9_0.num_targets > arg_9_2[4] then
				return
			end

			local var_9_1 = arg_9_2[2]

			if var_9_1 ~= "light_attack" and var_9_1 ~= "heavy_attack" then
				return
			end

			local var_9_2 = var_9_0.block_buff
			local var_9_3 = ScriptUnit.extension(arg_9_0, "buff_system")

			if var_9_2 and var_9_3:has_buff_type(var_9_2) then
				return
			end

			local var_9_4 = var_9_0.buff_to_add

			Managers.state.entity:system("buff_system"):add_buff(arg_9_0, var_9_4, arg_9_0, false)
		end
	end,
	victor_priest_knockback_on_hit = function(arg_10_0, arg_10_1, arg_10_2)
		if ALIVE[arg_10_0] then
			if arg_10_2[4] > 1 then
				return
			end

			local var_10_0 = arg_10_2[2]

			if var_10_0 ~= "light_attack" and var_10_0 ~= "heavy_attack" then
				return
			end

			local var_10_1 = ScriptUnit.has_extension(arg_10_0, "career_system"):get_career_power_level()
			local var_10_2 = arg_10_2[1]
			local var_10_3 = POSITION_LOOKUP[var_10_2]

			Managers.state.entity:system("area_damage_system"):create_explosion(arg_10_0, var_10_3, Quaternion.identity(), "victor_priest_melee_explosion", 1, "career_ability", var_10_1, false)

			local var_10_4 = ScriptUnit.extension(arg_10_0, "buff_system")

			var_10_4:add_buff(arg_10_1.template.buff_to_add)
			var_10_4:remove_buff(arg_10_1.id)
		end
	end,
	victor_priest_add_buff_first_target = function(arg_11_0, arg_11_1, arg_11_2)
		if ALIVE[arg_11_0] then
			if arg_11_2[4] > 1 then
				return
			end

			if not arg_11_1.buff_ids then
				arg_11_1.buff_ids = {}
			end

			local var_11_0 = arg_11_1.template.buff_to_add
			local var_11_1 = ScriptUnit.extension(arg_11_0, "buff_system")

			arg_11_1.buff_ids[#arg_11_1.buff_ids + 1] = var_11_1:add_buff(var_11_0)
		end
	end,
	victor_priest_passive_resource = function(arg_12_0, arg_12_1, arg_12_2)
		if ALIVE[arg_12_0] then
			local var_12_0
			local var_12_1 = arg_12_1.template
			local var_12_2 = arg_12_2[2]

			if var_12_2.elite then
				var_12_0 = var_12_1.fury_on_elite
			elseif var_12_2.special then
				var_12_0 = var_12_1.fury_on_special
			elseif var_12_2.boss then
				var_12_0 = var_12_1.fury_on_boss
			else
				var_12_0 = var_12_1.fury_on_normal
			end

			local var_12_3 = ScriptUnit.has_extension(arg_12_0, "overcharge_system")

			if var_12_3 then
				var_12_3:add_charge(var_12_0)
			end
		end
	end,
	victor_priest_passive_resource_activate = function(arg_13_0, arg_13_1, arg_13_2)
		if ALIVE[arg_13_0] then
			local var_13_0 = ScriptUnit.has_extension(arg_13_0, "overcharge_system")

			if not var_13_0 then
				return
			end

			if not var_13_0:is_above_critical_limit() then
				return
			end

			local var_13_1 = arg_13_2[2]

			if not var_13_1 or var_13_1 ~= "heavy_attack" then
				return
			end

			local var_13_2 = arg_13_1.template.buff_to_add
			local var_13_3 = ScriptUnit.extension(arg_13_0, "buff_system")

			if not var_13_3:get_buff_type(var_13_2) then
				var_13_3:add_buff(var_13_2)

				local var_13_4 = Managers.player:owner(arg_13_0)

				if var_13_4 and not var_13_4.remote then
					local var_13_5 = ScriptUnit.extension_input(arg_13_0, "dialogue_system")
					local var_13_6 = FrameTable.alloc_table()

					var_13_5:trigger_networked_dialogue_event("activate_ability", var_13_6)

					local var_13_7 = ScriptUnit.extension(arg_13_0, "first_person_system")

					var_13_7:play_hud_sound_event("career_ability_priest_cast_t1")
					var_13_7:play_remote_unit_sound_event("career_ability_priest_cast_t1", arg_13_0, 0)
				end
			end
		end
	end,
	victor_priest_4_3_heal_on_kill = function(arg_14_0, arg_14_1, arg_14_2)
		local var_14_0 = Managers.state.network.is_server

		if not Managers.player:owner(arg_14_0).remote and ScriptUnit.extension(arg_14_0, "talent_system"):has_talent("victor_priest_4_3") then
			local var_14_1 = ScriptUnit.extension(arg_14_0, "career_system"):get_passive_ability_by_name("wh_priest")
			local var_14_2 = arg_14_1.template.percent_fury_to_gain

			var_14_1:modify_resource_percent(var_14_2)
		end

		if not var_14_0 then
			return
		end

		local var_14_3 = ScriptUnit.extension(arg_14_0, "buff_system")

		if not var_14_3 or not var_14_3:has_buff_type("victor_priest_passive_aftershock") then
			return
		end

		if not arg_14_2[1] then
			return
		end

		local var_14_4 = arg_14_2[2]

		if var_14_4 and not var_14_4.is_hero then
			local var_14_5 = var_14_4.bloodlust_health or 0
			local var_14_6 = Managers.state.side.side_by_unit[arg_14_0]

			if not var_14_6 then
				return
			end

			local var_14_7 = var_14_6.PLAYER_AND_BOT_UNITS
			local var_14_8 = #var_14_7
			local var_14_9 = var_14_5 * 0.5

			for iter_14_0 = 1, var_14_8 do
				local var_14_10 = var_14_7[iter_14_0]

				if ALIVE[var_14_10] then
					DamageUtils.heal_network(var_14_10, arg_14_0, var_14_9, "career_passive")
				end
			end
		end
	end,
	victor_priest_6_1_pulse_attack = function(arg_15_0, arg_15_1, arg_15_2)
		local var_15_0 = arg_15_1.template
		local var_15_1 = var_15_0.push_radius
		local var_15_2 = var_15_0.stagger_impact
		local var_15_3 = var_15_0.stagger_distance
		local var_15_4 = Managers.time:time("game")
		local var_15_5 = POSITION_LOOKUP[arg_15_0]
		local var_15_6 = FrameTable.alloc_table()

		arg_15_1.broadphase_categories = arg_15_1.broadphase_categories or Managers.state.side.side_by_unit[arg_15_0].enemy_broadphase_categories

		local var_15_7 = AiUtils.broadphase_query(var_15_5, var_15_1, var_15_6, arg_15_1.broadphase_categories)

		for iter_15_0 = 1, var_15_7 do
			local var_15_8 = var_15_6[iter_15_0]
			local var_15_9 = POSITION_LOOKUP[var_15_8]
			local var_15_10 = Vector3.normalize(var_15_9 - var_15_5)

			AiUtils.stagger_target(arg_15_0, var_15_8, var_15_3, var_15_2, var_15_10, var_15_4)
		end
	end
}
var_0_2.buff_function_templates = {
	victor_priest_passive_active_update = function(arg_16_0, arg_16_1, arg_16_2)
		if ALIVE[arg_16_0] then
			local var_16_0 = ScriptUnit.has_extension(arg_16_0, "overcharge_system")

			if not var_16_0 then
				return
			end

			local var_16_1 = arg_16_1.template
			local var_16_2 = ScriptUnit.extension(arg_16_0, "buff_system")
			local var_16_3 = Managers.time:time("game")
			local var_16_4 = var_16_1.fury_to_remove + math.floor((var_16_3 - arg_16_1.start_time) / 2) / 15

			var_16_0:remove_charge(var_16_4)

			if var_16_0:get_overcharge_value() <= 0 then
				var_16_2:remove_buff(arg_16_1.id)
			end
		end
	end,
	victor_priest_passive_grow = function(arg_17_0, arg_17_1, arg_17_2)
		if ALIVE[arg_17_0] then
			if not arg_17_1.stack_ids then
				arg_17_1.stack_ids = {}
			end

			local var_17_0 = ScriptUnit.extension(arg_17_0, "buff_system")

			if var_17_0:get_buff_type("victor_priest_righteous_fury_active_buff") then
				arg_17_1.stack_ids[#arg_17_1.stack_ids + 1] = var_17_0:add_buff(arg_17_1.template.buff_to_add)
			elseif #arg_17_1.stack_ids > 0 then
				for iter_17_0 = 1, #arg_17_1.stack_ids do
					var_17_0:remove_buff(arg_17_1.stack_ids[iter_17_0])
				end

				arg_17_1.stack_ids = {}
			end
		end
	end,
	victor_priest_delayed_buff_remove = function(arg_18_0, arg_18_1, arg_18_2)
		local var_18_0 = arg_18_0

		if ALIVE[var_18_0] then
			local var_18_1 = ScriptUnit.extension(var_18_0, "buff_system")
			local var_18_2 = var_18_1:get_non_stacking_buff(arg_18_1.template.buff_list_buff)

			if var_18_2 then
				local var_18_3 = var_18_2.buff_ids

				if var_18_3 then
					for iter_18_0 = 1, #var_18_3 do
						var_18_1:queue_remove_buff(var_18_3[iter_18_0])
					end
				end
			end
		end
	end,
	victor_priest_deal_damage_on_remove = function(arg_19_0, arg_19_1, arg_19_2)
		if ALIVE[arg_19_0] then
			local var_19_0 = arg_19_1.attacker_unit
			local var_19_1 = arg_19_1.value

			if not var_19_1 or var_19_1 <= 0 then
				return
			end

			local var_19_2 = 0.2
			local var_19_3 = ScriptUnit.extension(var_19_0, "buff_system")

			if var_19_3 then
				var_19_2 = var_19_2 + 0.02 * var_19_3:num_buff_type("victor_priest_4_2_stack")
			end

			local var_19_4 = var_19_1 * var_19_2

			DamageUtils.add_damage_network(arg_19_0, var_19_0, var_19_4, "torso", "buff", nil, Vector3(0, 0, 0), "career_ability", nil, var_19_0, nil, nil, nil, nil, nil, nil, nil, nil, 1)

			local var_19_5 = ScriptUnit.has_extension(var_19_0, "career_system"):get_career_power_level()
			local var_19_6 = POSITION_LOOKUP[arg_19_0] + Vector3.up() * 0.5

			Managers.state.entity:system("area_damage_system"):create_explosion(var_19_0, var_19_6, Quaternion.identity(), "victor_priest_career_skill_aftershock", 1, "career_ability", var_19_5, false)
		end
	end,
	victor_priest_activated_ability_aftershock_update = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
		if not Managers.state.network.is_server then
			return
		end

		local var_20_0 = arg_20_1.attacker_unit

		if ALIVE[arg_20_0] and ALIVE[var_20_0] then
			if not ScriptUnit.has_extension(arg_20_0, "buff_system") then
				return
			end

			local var_20_1 = arg_20_1.value

			if not var_20_1 or var_20_1 <= 0 then
				return
			end

			local var_20_2 = var_20_1 * arg_20_1.template.damage_multiplier

			DamageUtils.add_damage_network(arg_20_0, var_20_0, var_20_2, "torso", "buff", nil, Vector3(0, 0, 0), "career_ability", nil, var_20_0, nil, nil, nil, nil, nil, nil, nil, nil, 1)

			local var_20_3 = ScriptUnit.has_extension(var_20_0, "career_system"):get_career_power_level()
			local var_20_4 = POSITION_LOOKUP[arg_20_0] + Vector3.up() * 0.5
			local var_20_5 = Managers.state.entity:system("weapon_system")
			local var_20_6 = "career_ability"
			local var_20_7 = NetworkLookup.damage_sources[var_20_6]
			local var_20_8 = Managers.state.network
			local var_20_9 = var_20_8:unit_game_object_id(var_20_0)
			local var_20_10 = var_20_8:unit_game_object_id(arg_20_0)
			local var_20_11 = NetworkLookup.hit_zones.body
			local var_20_12 = arg_20_1.template.damage_profile
			local var_20_13 = NetworkLookup.damage_profiles[var_20_12]
			local var_20_14 = POSITION_LOOKUP[arg_20_0] or 0
			local var_20_15 = POSITION_LOOKUP[var_20_0] or 0
			local var_20_16 = Vector3.normalize(var_20_14 - var_20_15)

			var_20_5:send_rpc_attack_hit(var_20_7, var_20_9, var_20_10, var_20_11, var_20_4, var_20_16, var_20_13, "power_level", var_20_3)

			local var_20_17 = "fx/wp_enemy_explosion"

			if not Unit.has_node(arg_20_0, "j_neck") then
				return
			end

			local var_20_18 = Managers.state.unit_storage:go_id(arg_20_0)

			if var_20_18 then
				local var_20_19 = NetworkLookup.effects[var_20_17]
				local var_20_20 = Unit.node(arg_20_0, "j_neck")

				var_20_8:rpc_play_particle_effect_no_rotation(nil, var_20_19, var_20_18, var_20_20, Vector3.zero(), false)

				local var_20_21 = Managers.player:owner(var_20_0)

				if var_20_21 then
					local var_20_22 = "career_priest_fury_smite"
					local var_20_23 = "career_priest_fury_smite_husk"

					if var_20_21.remote then
						WwiseUtils.trigger_unit_event(arg_20_3, var_20_23, arg_20_0, var_20_20)

						local var_20_24 = var_20_21:network_id()
						local var_20_25 = NetworkLookup.sound_events[var_20_22]

						var_20_8.network_transmit:send_rpc("rpc_server_audio_unit_event", var_20_24, var_20_25, var_20_18, false, var_20_20)

						local var_20_26 = NetworkLookup.sound_events[var_20_23]

						var_20_8.network_transmit:send_rpc_clients_except("rpc_server_audio_unit_event", var_20_24, var_20_26, var_20_18, false, var_20_20)
					else
						WwiseUtils.trigger_unit_event(arg_20_3, var_20_22, arg_20_0, var_20_20)

						local var_20_27 = NetworkLookup.sound_events[var_20_23]

						var_20_8.network_transmit:send_rpc_clients("rpc_server_audio_unit_event", var_20_27, var_20_18, false, var_20_20)
					end
				end
			end
		end
	end,
	victor_priest_on_career_skill_applied = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
		local var_21_0 = "fx/wp_immortality_allies"
		local var_21_1 = "fx/wp_immortality_self"
		local var_21_2 = Managers.player
		local var_21_3 = var_21_2:local_player()

		if var_21_2:unit_owner(arg_21_0) == var_21_3 then
			local var_21_4 = ScriptUnit.has_extension(arg_21_0, "first_person_system")

			if var_21_4 then
				if arg_21_1.screen_space_id then
					var_21_4:destroy_screen_particles(arg_21_1.screen_space_id)
				end

				arg_21_1.screen_space_id = var_21_4:create_screen_particles(var_21_1)
			end
		else
			local var_21_5 = Unit.node(arg_21_0, "j_spine") or 0
			local var_21_6 = Unit.world_position(arg_21_0, var_21_5)

			arg_21_1._tp_node = var_21_5

			if arg_21_1.third_person_effect_id then
				World.destroy_particles(arg_21_3, arg_21_1.third_person_effect_id)
			end

			arg_21_1.third_person_effect_id = World.create_particles(arg_21_3, var_21_0, var_21_6)

			World.set_particles_life_time(arg_21_3, arg_21_1.third_person_effect_id, arg_21_1.duration)
		end

		local var_21_7 = arg_21_1.attacker_unit

		Managers.state.achievement:trigger_event("register_shield_applied", arg_21_0, var_21_7)

		if not Managers.state.network.is_server then
			return
		end

		if ALIVE[arg_21_0] and ALIVE[var_21_7] then
			local var_21_8 = ScriptUnit.has_extension(var_21_7, "talent_system")

			if not var_21_8 then
				return
			end

			if var_21_8:has_talent("victor_priest_6_3") then
				local var_21_9 = ScriptUnit.has_extension(arg_21_0, "status_system")

				if var_21_9 and var_21_9:is_knocked_down() then
					StatusUtils.set_revived_network(arg_21_0, true, var_21_7)
					CharacterStateHelper.play_animation_event(arg_21_0, "revive_complete")
					StatisticsUtil.register_revive(var_21_7, arg_21_0, Managers.player:statistics_db())
				end

				local var_21_10 = BuffUtils.get_buff_template("victor_priest_6_3_buff").buffs[1].heal_window or 3
				local var_21_11 = ScriptUnit.extension(arg_21_0, "buff_system")
				local var_21_12 = var_21_11:get_buff_type("victor_priest_6_3_buff")

				if var_21_12 then
					arg_21_1.heal_amount = 0

					local var_21_13 = var_21_12.damage_table

					if not var_21_13 then
						return
					end

					local var_21_14 = 0
					local var_21_15 = 0

					for iter_21_0 = 1, #var_21_13 do
						local var_21_16 = Managers.time:time("game")
						local var_21_17 = var_21_13[iter_21_0]

						if var_21_17.t and var_21_10 > var_21_16 - var_21_17.t then
							if var_21_17.temp_hp then
								var_21_14 = var_21_14 + var_21_17.damage_taken
							else
								var_21_15 = var_21_15 + var_21_17.damage_taken
							end

							local var_21_18 = var_21_17.damage_taken

							arg_21_1.heal_amount = arg_21_1.heal_amount + var_21_18
						end
					end

					var_21_12.damage_table = {}

					if arg_21_1.heal_amount > 0 then
						arg_21_2 = {
							attacker_unit = var_21_7,
							external_optional_value = {
								temp_hp = var_21_14,
								perm_hp = var_21_15
							}
						}

						var_21_11:add_buff("victor_priest_6_3_delayed_heal", arg_21_2)

						local var_21_19 = ScriptUnit.has_extension(arg_21_0, "first_person_system")

						if var_21_19 then
							var_21_19:play_hud_sound_event("career_talent_priest_heal")
						end
					end
				end
			end
		end
	end,
	victor_priest_6_1_removed = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
		if not Managers.state.network.is_server then
			return
		end

		if ALIVE[arg_22_0] and ALIVE[arg_22_1.attacker_unit] then
			local var_22_0 = arg_22_1.value

			if var_22_0.perm_hp > 0 then
				DamageUtils.heal_network(arg_22_0, arg_22_1.attacker_unit, var_22_0.perm_hp, "career_passive")
			end

			if var_22_0.temp_hp > 0 then
				DamageUtils.heal_network(arg_22_0, arg_22_1.attacker_unit, var_22_0.temp_hp, "heal_from_proc")
			end
		end
	end,
	victor_priest_on_career_skill_removed = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
		if arg_23_1.screen_space_id then
			local var_23_0 = ScriptUnit.has_extension(arg_23_0, "first_person_system")

			if var_23_0 then
				var_23_0:destroy_screen_particles(arg_23_1.screen_space_id)
			end
		end

		if arg_23_1.third_person_effect_id then
			World.destroy_particles(arg_23_3, arg_23_1.third_person_effect_id)
		end
	end,
	victor_priest_on_career_skill_update = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
		if arg_24_1.third_person_effect_id then
			if ALIVE[arg_24_0] then
				local var_24_0 = arg_24_1._tp_node or 0
				local var_24_1 = Unit.world_position(arg_24_0, var_24_0)

				World.move_particles(arg_24_3, arg_24_1.third_person_effect_id, var_24_1)
			else
				World.destroy_particles(arg_24_3, arg_24_1.third_person_effect_id)

				arg_24_1.third_person_effect_id = nil
			end
		end
	end,
	damage_stagger_dot = function(arg_25_0, arg_25_1, arg_25_2)
		if not Managers.state.network.is_server then
			return
		end

		if ALIVE[arg_25_0] then
			local var_25_0 = arg_25_1.template
			local var_25_1 = var_25_0.update_frequency
			local var_25_2 = var_25_0.duration
			local var_25_3 = ScriptUnit.has_extension(arg_25_0, "health_system")
			local var_25_4 = arg_25_1.value / math.round(var_25_2 / var_25_1)
			local var_25_5 = var_25_3:current_health()

			if var_25_5 <= var_25_4 then
				var_25_4 = var_25_5 - 5
			end

			if var_25_3 and var_25_4 > 0 then
				local var_25_6 = ScriptUnit.extension(arg_25_0, "buff_system")
				local var_25_7 = var_25_6:get_buff_type("victor_priest_4_3_buff")

				if var_25_7 and not var_25_6:has_buff_perk("invulnerable") then
					var_25_6:remove_buff(var_25_7.id)
				end

				Managers.state.achievement:trigger_event("bless_delay_damage", arg_25_0, var_25_4)
				DamageUtils.add_damage_network(arg_25_0, arg_25_0, var_25_4, "torso", "life_tap", nil, Vector3(0, 0, 0), "life_tap", nil, arg_25_0, nil, nil, nil, nil, nil, nil, nil, nil, 1)

				if not arg_25_1.damage_dealt then
					arg_25_1.damage_dealt = 0
				end

				arg_25_1.damage_dealt = arg_25_1.damage_dealt + var_25_4
			end
		end
	end,
	victor_priest_activated_ability_nuke_start = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
		local var_26_0 = "fx/wp_explosion_allies"
		local var_26_1 = "fx/wp_explosion_self"
		local var_26_2 = Managers.player
		local var_26_3 = var_26_2:local_player()

		if var_26_2:unit_owner(arg_26_0) == var_26_3 then
			local var_26_4 = ScriptUnit.has_extension(arg_26_0, "first_person_system")

			if var_26_4 then
				arg_26_1.screen_space_id = var_26_4:create_screen_particles(var_26_1)
			end
		else
			local var_26_5 = Unit.node(arg_26_0, "j_spine")

			arg_26_1.third_person_effect_id = ScriptWorld.create_particles_linked(arg_26_3, var_26_0, arg_26_0, var_26_5, "destroy")
		end

		local var_26_6 = Managers.player:owner(arg_26_0)
		local var_26_7 = var_26_6 and (var_26_6.remote or var_26_6.bot_player) or false

		if ALIVE[arg_26_0] and var_26_7 then
			WwiseUtils.trigger_unit_event(arg_26_3, "career_ability_priest_buildup_husk", arg_26_0, 0)
		end
	end,
	victor_priest_activated_ability_nuke = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
		if arg_27_1.screen_space_id then
			local var_27_0 = ScriptUnit.has_extension(arg_27_0, "first_person_system")

			if var_27_0 then
				var_27_0:destroy_screen_particles(arg_27_1.screen_space_id)
			end
		end

		if arg_27_1.third_person_effect_id then
			World.destroy_particles(arg_27_3, arg_27_1.third_person_effect_id)
		end

		local var_27_1 = arg_27_1.attacker_unit

		if not ALIVE[var_27_1] then
			return
		end

		local var_27_2 = Unit.node(arg_27_0, "j_spine")
		local var_27_3 = Unit.world_position(arg_27_0, var_27_2) or POSITION_LOOKUP[arg_27_0]

		if not var_27_3 then
			return
		end

		local var_27_4 = "victor_priest_activated_ability_nuke"
		local var_27_5 = ExplosionUtils.get_template(var_27_4)
		local var_27_6 = Unit.local_rotation(arg_27_0, 0)
		local var_27_7 = 1
		local var_27_8 = "career_ability"
		local var_27_9 = ScriptUnit.has_extension(var_27_1, "career_system"):get_career_power_level()
		local var_27_10 = Managers.state.network.is_server
		local var_27_11 = Managers.player:owner(arg_27_0)
		local var_27_12 = var_27_11 and (var_27_11.remote or var_27_11.bot_player) or false

		if ALIVE[arg_27_0] and var_27_12 then
			WwiseUtils.trigger_unit_event(arg_27_3, "career_ability_priest_buildup_husk_stop", arg_27_0, 0)
		end

		DamageUtils.create_explosion(arg_27_3, var_27_1, var_27_3, var_27_6, var_27_5, var_27_7, var_27_8, var_27_10, var_27_12, var_27_1, var_27_9, false, arg_27_0)
	end,
	victor_priest_activated_noclip_apply = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
		local var_28_0 = ScriptUnit.extension(arg_28_0, "locomotion_system")

		if var_28_0.apply_no_clip_filter then
			var_28_0:apply_no_clip_filter(arg_28_1.template.no_clip_filter, "victor_priest_activated_noclip")
		end

		if Managers.state.network.is_server then
			arg_28_1.broadphase_results = {}
			arg_28_1.pushed_units = {}
		end
	end,
	victor_priest_activated_noclip_remove = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
		local var_29_0 = ScriptUnit.extension(arg_29_0, "locomotion_system")

		if var_29_0.remove_no_clip_filter then
			var_29_0:remove_no_clip_filter("victor_priest_activated_noclip")
		end
	end,
	victor_priest_activated_noclip_update = function(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
		if not Managers.state.network.is_server then
			return
		end

		local var_30_0 = arg_30_1.template
		local var_30_1 = var_30_0.push_cooldown
		local var_30_2 = var_30_0.push_radius
		local var_30_3 = var_30_0.stagger_impact
		local var_30_4 = var_30_0.stagger_distance
		local var_30_5 = arg_30_1.broadphase_results
		local var_30_6 = arg_30_1.pushed_units
		local var_30_7 = arg_30_2.t
		local var_30_8 = Managers.state.side.side_by_unit[arg_30_0].enemy_broadphase_categories
		local var_30_9 = POSITION_LOOKUP[arg_30_0]
		local var_30_10 = AiUtils.broadphase_query(var_30_9, var_30_2, var_30_5, var_30_8)

		for iter_30_0 = 1, var_30_10 do
			local var_30_11 = var_30_5[iter_30_0]

			if var_30_7 > (var_30_6[var_30_11] or 0) then
				var_30_6[var_30_11] = var_30_7 + var_30_1

				local var_30_12 = POSITION_LOOKUP[var_30_11]
				local var_30_13 = Vector3.normalize(var_30_12 - var_30_9)

				AiUtils.stagger_target(arg_30_0, var_30_11, var_30_4, var_30_3, var_30_13, var_30_7)
			end
		end

		table.clear(var_30_5)
	end
}
