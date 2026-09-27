-- chunkname: @scripts/settings/equipment/weapon_templates/bardin_engineer_career_skill.lua

local num = 0.75
local num_2 = 1
local num_3 = 0.5
local num_4 = 0.15
local num_5 = 4
local num_6 = 12
local num_7 = 1.5
local num_8 = 0.2
local num_9 = 2
local str = "engineer_ability_shot_armor_pierce"
local num_10 = 2
local num_11 = 3.6
local num_12 = 1.5
local num_13 = 0.2
local num_14 = 0.34
local num_15 = 0.67
local num_16 = 0.0015
local num_17 = 0.002
local num_18 = 0.006
local num_19 = 0.16666666666666666
local num_20 = 0.3333333333333333

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local current_ability_cooldown, var_1_1 = ScriptUnit.extension(arg_1_0, "career_system"):current_ability_cooldown(1)

	return var_1_1 - current_ability_cooldown >= num_2 * num
end

local function fn_2(arg_2_0, arg_2_1)
	-- function 2
	local current_ability_cooldown, var_2_1 = ScriptUnit.extension(arg_2_0, "career_system"):current_ability_cooldown(1)

	return var_2_1 - current_ability_cooldown >= num_2 * num_9
end

local tbl = {
	actions = {
		action_one = {
			default = {
				total_time_secondary = 1.75,
				anim_event_secondary = "reload",
				kind = "career_dummy",
				anim_event = "attack_charge",
				total_time = 1.4,
				allowed_chain_actions = {
					{
						sub_action = "spin",
						start_time = 0,
						action = "action_one",
						hold_allowed = true,
						input = "action_one"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "weapon_reload",
						input = "weapon_reload"
					}
				},
				condition_func = fn,
				enter_function = function (arg_3_0, arg_3_1)
					-- function 3
					arg_3_1:clear_input_buffer()

					return arg_3_1:reset_release_input()
				end
			},
			spin = {
				charge_sound_stop_event = "Stop_player_engineer_engine_loop",
				anim_end_event = "attack_finished",
				fp_speed_anim_variable = "barrel_spin_speed",
				visual_spinup_min = 0,
				kind = "career_dr_four_spin",
				override_visual_spinup = true,
				charge_sound_name = "Play_player_engineer_engine_charge",
				windup_max = 0,
				initial_windup = 0,
				visual_spinup_max = 0.3,
				charge_sound_husk_name = "Play_player_engineer_engine_charge_husk",
				windup_speed = 0,
				audio_loop_id = "engineer_weapon_spin",
				hold_input = "action_one_hold",
				anim_event = "attack_charge",
				charge_sound_husk_stop_event = "Stop_player_engineer_engine_loop_husk",
				anim_end_event_condition_func = function (arg_4_0, arg_4_1)
					-- function 4
					return arg_4_1 ~= "new_interupting_action"
				end,
				on_chain_keep_audio_loops = {
					"engineer_weapon_spin"
				},
				total_time = num_3 + 0.25,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.2,
						buff_name = "planted_fast_decrease_movement",
						end_time = math.huge
					}
				},
				allowed_chain_actions = {
					{
						sub_action = "fire",
						action = "action_one",
						hold_allowed = true,
						input = "action_one",
						start_time = num_3
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_wield",
						input = "action_wield"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "weapon_reload",
						hold_allowed = true,
						input = "weapon_reload"
					}
				},
				condition_func = fn,
				enter_function = function (arg_5_0, arg_5_1)
					-- function 5
					arg_5_1:clear_input_buffer()

					return arg_5_1:reset_release_input()
				end,
				visual_spinup_time = num_3 / 3
			},
			fire = {
				kind = "action_selector",
				on_chain_keep_audio_loops = {
					"engineer_weapon_spin"
				},
				conditional_actions = {
					{
						sub_action = "armor_pierce_fire",
						condition = function (self, arg_6_1)
							-- function 6
							return not self and self:has_talent("bardin_engineer_armor_piercing_ability")
						end
					}
				},
				default_action = {
					sub_action = "base_fire"
				},
				condition_func = fn,
				chain_condition_func = fn
			},
			base_fire = {
				anim_event = "attack_shoot_charged",
				use_ability_as_ammo = true,
				fire_sound_event = "Play_player_engineer_shooting_burst",
				kind = "career_dr_four",
				shot_count = 1,
				action_priority = 0,
				damage_profile = "engineer_ability_shot",
				anim_end_event = "attack_finished",
				anim_event_secondary = "reload",
				charge_value = "bullet_hit",
				total_time_secondary = 1.75,
				apply_recoil = true,
				headshot_multiplier = 2,
				additional_critical_strike_chance = 0,
				aim_assist_ramp_multiplier = 0.1,
				aim_assist_max_ramp_multiplier = 0.3,
				fire_time = 0,
				aim_assist_auto_hit_chance = 0.5,
				aim_assist_ramp_decay_delay = 0.2,
				critical_hit_effect = "bullet_critical_impact",
				alert_sound_range_hit = 1.5,
				reload_when_out_of_ammo = true,
				continuous_buff_check = true,
				num_layers_spread = 1,
				hit_effect = "bullet_impact",
				ranged_attack = true,
				alert_sound_range_fire = 10,
				hold_input = "action_one_hold",
				on_chain_keep_audio_loops = {
					"engineer_weapon_spin"
				},
				total_time = math.huge,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.2,
						buff_name = "planted_fast_decrease_movement",
						end_time = math.huge
					}
				},
				allowed_chain_actions = {
					{
						sub_action = "charged",
						start_time = 0,
						action = "action_two",
						hold_allowed = true,
						release_required = "action_one_hold",
						input = "action_two"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "weapon_reload",
						hold_allowed = true,
						input = "weapon_reload"
					},
					{
						sub_action = "default",
						action = "action_wield",
						input = "action_wield",
						start_time = num_4
					}
				},
				enter_function = function (arg_7_0, arg_7_1)
					-- function 7
					arg_7_1:clear_input_buffer()

					return arg_7_1:reset_release_input()
				end,
				visual_heat_generation = num_16,
				base_anim_speed = num_19,
				initial_rounds_per_second = num_5,
				max_rps = num_6,
				rps_loss_per_second = num_7,
				rps_gain_per_shot = num_8,
				ammo_usage = num,
				recoil_settings = {
					horizontal_climb = 0,
					restore_duration = 0.25,
					vertical_climb = 0.8,
					climb_duration = 0.1,
					climb_function = math.ease_out_quad,
					restore_function = math.ease_out_quad
				},
				critical_strike = {}
			}
		},
		action_two = {
			default = {
				charge_sound_stop_event = "Stop_player_engineer_engine_loop",
				anim_end_event = "attack_finished",
				visual_spinup_min = 0.4,
				kind = "career_dr_four_spin",
				charge_sound_husk_stop_event = "Stop_player_engineer_engine_loop_husk",
				override_visual_spinup = true,
				windup_max = 0,
				initial_windup = 0,
				visual_spinup_time = 0.3,
				visual_spinup_max = 0.5,
				charge_sound_husk_name = "Play_player_engineer_engine_loop_husk",
				windup_speed = 0,
				audio_loop_id = "engineer_weapon_spin",
				hold_input = "action_two_hold",
				anim_event = "attack_charge_loop",
				charge_sound_name = "Play_player_engineer_engine_charge",
				anim_end_event_condition_func = function (arg_8_0, arg_8_1)
					-- function 8
					return arg_8_1 ~= "new_interupting_action"
				end,
				on_chain_keep_audio_loops = {
					"engineer_weapon_spin"
				},
				total_time = math.huge,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.2,
						buff_name = "planted_fast_decrease_movement",
						end_time = math.huge
					}
				},
				allowed_chain_actions = {
					{
						sub_action = "charged",
						action = "action_two",
						hold_allowed = true,
						input = "action_two",
						start_time = num_3
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "weapon_reload",
						hold_allowed = true,
						input = "weapon_reload"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_wield",
						input = "action_wield"
					}
				},
				condition_func = fn,
				chain_condition_func = fn,
				enter_function = function (arg_9_0, arg_9_1)
					-- function 9
					arg_9_1:clear_input_buffer()

					return arg_9_1:reset_release_input()
				end
			},
			charged = {
				kind = "career_dr_four_spin",
				anim_end_event = "attack_finished",
				action_priority = 0,
				windup_max = 1,
				initial_windup = 0,
				hold_input = "action_two_hold",
				anim_event = "attack_charge_end",
				windup_speed = 0.2,
				anim_end_event_condition_func = function (arg_10_0, arg_10_1)
					-- function 10
					return arg_10_1 ~= "new_interupting_action"
				end,
				on_chain_keep_audio_loops = {
					"engineer_weapon_spin"
				},
				total_time = math.huge,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.2,
						buff_name = "planted_fast_decrease_movement",
						end_time = math.huge
					}
				},
				allowed_chain_actions = {
					{
						sub_action = "fire",
						action = "action_one",
						hold_allowed = true,
						input = "action_one",
						start_time = num_4
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "weapon_reload",
						hold_allowed = true,
						input = "weapon_reload"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_wield",
						input = "action_wield"
					}
				},
				condition_func = fn,
				chain_condition_func = fn,
				enter_function = function (arg_11_0, arg_11_1)
					-- function 11
					arg_11_1:clear_input_buffer()

					return arg_11_1:reset_release_input()
				end
			}
		},
		weapon_reload = {
			default = {
				charge_sound_stop_event = "Stop_player_engineer_steam_loop",
				stop_at_max = true,
				anim_end_event = "cooldown_end",
				kind = "career_dr_four_charge",
				hold_input = "weapon_reload_hold",
				do_not_validate_with_hold = false,
				charge_sound_husk_stop_event = "Stop_player_engineer_steam_loop_husk",
				charge_sound_husk_name = "Play_player_engineer_steam_loop_husk",
				minimum_hold_time = 0.5,
				charge_time = 3,
				uninterruptible = true,
				anim_event = "cooldown_start",
				charge_sound_name = "Play_player_engineer_steam_loop",
				anim_end_event_condition_func = function (arg_12_0, arg_12_1)
					-- function 12
					return arg_12_1 ~= "new_interupting_action"
				end,
				total_time = math.huge,
				buff_data = {},
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.2,
						action = "action_wield",
						input = "action_wield"
					}
				},
				condition_func = function (arg_13_0, arg_13_1)
					-- function 13
					local has_extension = ScriptUnit.has_extension(arg_13_0, "career_system")

					return not ScriptUnit.has_extension(arg_13_0, "buff_system"):has_buff_type("bardin_engineer_pump_max_exhaustion_buff")
				end,
				chain_condition_func = function (arg_14_0, arg_14_1)
					-- function 14
					local has_extension = ScriptUnit.has_extension(arg_14_0, "career_system")

					return not ScriptUnit.has_extension(arg_14_0, "buff_system"):has_buff_type("bardin_engineer_pump_max_exhaustion_buff")
				end,
				initial_charge_delay = num_14,
				ability_charge_interval = num_15
			}
		},
		action_inspect = ActionTemplates.action_inspect,
		action_wield = ActionTemplates.wield
	}
}
local shallow_copy = table.shallow_copy(tbl.actions.action_one.base_fire)

tbl.actions.action_one.fast_fire = shallow_copy

local shallow_copy_2 = table.shallow_copy(tbl.actions.action_one.base_fire)

shallow_copy_2.damage_profile = str
shallow_copy_2.visual_heat_generation = num_17
shallow_copy_2.base_anim_speed = num_20
shallow_copy_2.ammo_usage = num_9
shallow_copy_2.initial_rounds_per_second = num_10
shallow_copy_2.max_rps = num_11
shallow_copy_2.rps_loss_per_second = num_12
shallow_copy_2.rps_gain_per_shot = num_13
shallow_copy_2.fire_sound_event = "Play_player_engineer_shooting_armor_piercing"
tbl.actions.action_one.armor_pierce_fire = shallow_copy_2
tbl.attack_meta_data = {
	max_range = 25,
	aim_at_node = "j_spine1",
	keep_distance = 6.5,
	fire_input = "fire_hold",
	ignore_enemies_for_obstruction = false,
	stop_fire_delay = 0.3,
	aim_data = {
		min_radius_pseudo_random_c = 1,
		max_radius_pseudo_random_c = 0.3021,
		min_radius = math.pi / 72,
		max_radius = math.pi / 16
	},
	hold_fire_condition = function (arg_15_0, arg_15_1)
		-- function 15
		return true
	end,
	effective_against = bit.bor(BreedCategory.Infantry, BreedCategory.Shielded, BreedCategory.Boss, BreedCategory.Berserker, BreedCategory.Special)
}
tbl.default_spread_template = "sparks"
tbl.right_hand_unit = ""
tbl.right_hand_attachment_node_linking = AttachmentNodeLinking.rotary_gun
tbl.display_unit = "units/weapons/weapon_display/display_drakegun"
tbl.wield_anim = "to_engineer_career_skill"
tbl.state_machine = "units/beings/player/first_person_base/state_machines/career/skill_engineer"
tbl.load_state_machine = false
tbl.crosshair_style = "default"
tbl.buff_type = "RANGED"
tbl.weapon_type = "BRACE_OF_PISTOLS"
tbl.dodge_count = 1
tbl.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1.1
	},
	change_dodge_speed = {
		external_optional_multiplier = 1.1
	}
}
tbl.aim_assist_settings = {
	max_range = 22,
	no_aim_input_multiplier = 0,
	aim_at_node = "j_spine",
	always_auto_aim = true,
	base_multiplier = 0.15,
	effective_max_range = 10,
	breed_scalars = {
		skaven_storm_vermin = 0.25,
		skaven_clan_rat = 1,
		skaven_slave = 1
	}
}
tbl.particle_fx = {
	heat_shimmer = {
		{
			orphaned_policy = "destroy",
			effect = "fx/wpnfx_engineer_heat_shimmer",
			third_person = false,
			link_target = "right_weapon",
			first_person = true,
			link_node = "fx_muzzle",
			destroy_policy = "stop_spawning"
		}
	}
}
tbl.particle_fx_lookup = table.mirror_array_inplace(table.keys(tbl.particle_fx))
tbl.visual_heat_cooldown_speed = num_18
tbl.custom_data = {
	windup = 0,
	windup_loss_per_second = (num_6 - num_5) / num_7
}

tbl.update = function (self, arg_16_1, arg_16_2)
	-- function 16
	local num = self:get_custom_data("windup") - self:get_custom_data("windup_loss_per_second") * arg_16_1

	self:set_custom_data("windup", num)
end

local clone = table.clone(tbl)

clone.wield_anim = "to_engineer_career_skill_special"
clone.actions.action_one.default.condition_func = fn_2
clone.actions.action_one.default.chain_condition_func = fn_2
clone.actions.action_one.spin.condition_func = fn_2
clone.actions.action_one.spin.chain_condition_func = fn_2
clone.actions.action_one.fire.condition_func = fn_2
clone.actions.action_one.fire.chain_condition_func = fn_2
clone.actions.action_two.default.condition_func = fn_2
clone.actions.action_two.default.chain_condition_func = fn_2
clone.actions.action_two.charged.condition_func = fn_2
clone.actions.action_two.charged.chain_condition_func = fn_2
clone.attack_meta_data = {
	effective_against = bit.bor(BreedCategory.Infantry, BreedCategory.Shielded, BreedCategory.Boss, BreedCategory.Berserker, BreedCategory.Special, BreedCategory.Armored)
}
tbl.custom_data = {
	windup = 0,
	windup_loss_per_second = (num_11 - num_10) / num_12
}

local clone_2 = table.clone(tbl)

clone_2.actions.action_one.base_fire.damage_profile = "engineer_ability_shot_vs"
armor_piercing_template_vs = table.clone(clone)

return {
	bardin_engineer_career_skill_weapon = table.clone(tbl),
	bardin_engineer_career_skill_weapon_special = clone,
	bardin_engineer_career_skill_weapon_vs = table.clone(clone_2),
	bardin_engineer_career_skill_weapon_special_vs = armor_piercing_template_vs
}
