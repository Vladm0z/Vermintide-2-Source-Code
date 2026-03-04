-- chunkname: @scripts/settings/equipment/weapon_templates/vs_ratling_gunner_gun.lua

local var_0_0 = "dark_pact_action_one"
local var_0_1 = "dark_pact_action_one_release"
local var_0_2 = "dark_pact_action_one_hold"
local var_0_3 = "dark_pact_action_two"
local var_0_4 = "dark_pact_reload"
local var_0_5 = 1
local var_0_6 = 0.2
local var_0_7 = 15
local var_0_8 = 20
local var_0_9 = 3
local var_0_10 = 120
local var_0_11 = 4
local var_0_12 = 2.1666666666666665 / var_0_5
local var_0_13 = 1 / var_0_5
local var_0_14 = (var_0_8 - var_0_7) / var_0_9

local function var_0_15(arg_1_0, arg_1_1, arg_1_2)
	if ScriptUnit.extension(arg_1_0, "status_system"):is_climbing() then
		return false
	end

	if ScriptUnit.extension(arg_1_0, "ghost_mode_system"):is_in_ghost_mode() then
		return false
	end

	return not arg_1_2 or arg_1_2:ammo_count() > 0
end

local function var_0_16(arg_2_0, arg_2_1, arg_2_2)
	if ScriptUnit.extension(arg_2_0, "status_system"):is_climbing() then
		return false
	end

	return arg_2_2 and arg_2_2:can_reload()
end

local function var_0_17(arg_3_0, arg_3_1)
	local var_3_0 = ScriptUnit.extension(arg_3_1, "ammo_system"):ammo_count()

	Managers.state.event:trigger("on_dark_pact_ammo_changed", arg_3_0, var_3_0)
end

local var_0_18 = {
	actions = {
		[var_0_0] = {
			default = {
				charge_sound_stop_event = "Stop_player_engineer_engine_loop",
				charge_sound_name = "Play_player_engineer_engine_charge",
				kind = "minigun_spin",
				reload_when_out_of_ammo = true,
				windup_max = 1,
				disallow_ghost_mode = true,
				initial_windup = 0,
				windup_start_on_zero = true,
				charge_sound_husk_name = "Play_player_engineer_engine_charge_husk",
				weapon_action_hand = "left",
				anim_event = "attack_shoot_start",
				charge_sound_husk_stop_event = "Stop_player_engineer_engine_loop_husk",
				anim_time_scale = var_0_12,
				enter_function = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					arg_4_1:clear_input_buffer()
					arg_4_1:reset_release_input()
					arg_4_3:change_synced_state("winding")
				end,
				finish_function = function (arg_5_0, arg_5_1, arg_5_2)
					if arg_5_1 ~= "new_interupting_action" then
						arg_5_2:change_synced_state(nil)
					end
				end,
				total_time = var_0_5 * var_0_12,
				hold_input = var_0_2,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.35,
						buff_name = "planted_fast_decrease_movement",
						end_time = math.huge
					}
				},
				allowed_chain_actions = {
					{
						sub_action = "fire",
						auto_chain = true,
						start_time = var_0_5 * var_0_12,
						action = var_0_0
					},
					{
						sub_action = "default",
						start_time = 0,
						hold_allowed = true,
						input = var_0_4,
						action = var_0_4
					}
				},
				condition_func = var_0_15,
				windup_speed = var_0_13
			},
			fire = {
				looping_anim = true,
				rps_loss_per_second = 1.5,
				kind = "minigun",
				weapon_action_hand = "left",
				spread_template_override = "vs_ratling_gunner_gun_shooting",
				disallow_ghost_mode = true,
				hit_effect = "bullet_impact",
				critical_hit_effect = "bullet_critical_impact",
				dont_shoot_near_wall = true,
				ammo_usage = 1,
				near_wall_anim = "",
				power_level = 100,
				shot_count = 1,
				hold_input = var_0_2,
				chain_condition_func = var_0_15,
				enter_function = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					arg_6_1:reset_release_input()
					arg_6_1:clear_input_buffer()
					arg_6_3:change_synced_state("firing")
				end,
				finish_function = function (arg_7_0, arg_7_1, arg_7_2)
					arg_7_2:change_synced_state(nil)
				end,
				initial_rounds_per_second = var_0_7,
				max_rps = var_0_8,
				rps_gain_per_shot = var_0_14,
				total_time = math.huge,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.4,
						buff_name = "planted_fast_decrease_movement",
						end_time = math.huge
					}
				},
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0,
						input = var_0_4,
						action = var_0_4
					}
				},
				lightweight_projectile_info = {
					collision_filter = "filter_enemy_player_afro_ray_projectile",
					template_name = "ratling_gunner_vs"
				}
			}
		},
		[var_0_4] = {
			default = {
				anim_end_event = "cooldown_ready",
				weapon_action_hand = "either",
				kind = "dummy",
				crosshair_style = "dot",
				anim_event = "wind_up_start",
				condition_func = var_0_16,
				chain_condition_func = var_0_16,
				enter_function = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					arg_8_3:change_synced_state("reloading")

					local var_8_0 = Managers.world:wwise_world(arg_8_3.world)

					WwiseWorld.trigger_event(var_8_0, "Play_player_ratling_gunner_weapon_reload")
				end,
				finish_function = function (arg_9_0, arg_9_1, arg_9_2)
					arg_9_2:change_synced_state(nil)

					local var_9_0 = Managers.world:wwise_world(arg_9_2.world)

					WwiseWorld.trigger_event(var_9_0, "Stop_player_ratling_gunner_weapon_reload")

					if arg_9_1 == "action_complete" then
						ScriptUnit.extension(arg_9_2.unit, "ammo_system"):add_ammo()
						var_0_17(arg_9_0, arg_9_2.unit)
					end
				end,
				total_time = var_0_11,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.6,
						buff_name = "planted_fast_decrease_movement",
						end_time = math.huge
					}
				},
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0,
						input = var_0_3,
						action = var_0_3
					}
				}
			}
		},
		[var_0_3] = {
			default = {
				weapon_action_hand = "left",
				kind = "dummy",
				total_time = 0,
				allowed_chain_actions = {},
				enter_function = function (arg_10_0, arg_10_1)
					arg_10_1:clear_input_buffer()

					return arg_10_1:reset_release_input()
				end
			}
		},
		action_wield = ActionTemplates.wield
	}
}

var_0_18.left_hand_unit = "units/weapons/player/dark_pact/wpn_skaven_warpfiregun/wpn_skaven_warpfiregun"
var_0_18.right_hand_attachment_node_linking = nil
var_0_18.left_hand_attachment_node_linking = AttachmentNodeLinking.vs_warpfire_thrower_gun.left
var_0_18.display_unit = "units/weapons/weapon_display/display_1h_axes"
var_0_18.wield_anim = "idle"
var_0_18.buff_type = "RANGED"
var_0_18.weapon_type = "FIRE_STAFF"
var_0_18.max_fatigue_points = 6
var_0_18.dodge_count = 6
var_0_18.block_angle = 90
var_0_18.outer_block_angle = 360
var_0_18.block_fatigue_point_multiplier = 0.5
var_0_18.outer_block_fatigue_point_multiplier = 2
var_0_18.sound_event_block_within_arc = "weapon_foley_blunt_1h_block_wood"
var_0_18.crosshair_style = "default"
var_0_18.default_spread_template = "vs_ratling_gunner_gun"
var_0_18.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1.2
	},
	change_dodge_speed = {
		external_optional_multiplier = 1.2
	}
}
var_0_18.custom_data = {
	windup = 0,
	reload_progress = 0,
	windup_loss_per_second = var_0_6
}

var_0_18.update = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0:get_custom_data("windup") - arg_11_0:get_custom_data("windup_loss_per_second") * arg_11_1

	arg_11_0:set_custom_data("windup", var_11_0)
end

var_0_18.attack_meta_data = {
	tap_attack = {
		arc = 0
	},
	hold_attack = {
		arc = 0
	}
}
var_0_18.aim_assist_settings = {
	max_range = 5,
	no_aim_input_multiplier = 0,
	vertical_only = true,
	base_multiplier = 0,
	effective_max_range = 4,
	breed_scalars = {
		skaven_storm_vermin = 1,
		skaven_clan_rat = 0.5,
		skaven_slave = 0.5
	}
}
var_0_18.weapon_diagram = {
	light_attack = {
		[DamageTypes.ARMOR_PIERCING] = 4,
		[DamageTypes.CLEAVE] = 1,
		[DamageTypes.SPEED] = 3,
		[DamageTypes.STAGGER] = 2,
		[DamageTypes.DAMAGE] = 5
	},
	heavy_attack = {
		[DamageTypes.ARMOR_PIERCING] = 5,
		[DamageTypes.CLEAVE] = 0,
		[DamageTypes.SPEED] = 3,
		[DamageTypes.STAGGER] = 2,
		[DamageTypes.DAMAGE] = 4
	}
}
var_0_18.tooltip_keywords = {
	"weapon_keyword_high_damage",
	"weapon_keyword_armour_piercing",
	"weapon_keyword_shield_breaking"
}
var_0_18.tooltip_compare = {
	light = {
		sub_action_name = "light_attack_left",
		action_name = var_0_0
	}
}
var_0_18.tooltip_detail = {
	light = {
		sub_action_name = "default",
		action_name = var_0_0
	}
}

local function var_0_19(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = "fire"
	local var_12_1 = arg_12_0:ability_id(var_12_0)
	local var_12_2 = arg_12_0:get_activated_ability_data(var_12_1)
	local var_12_3 = ScriptUnit.extension(arg_12_1, "weapon_system")

	var_12_2.priming_progress = arg_12_2 or var_12_3:get_custom_data("windup")
end

var_0_18.synced_states = {
	winding = {
		clear_data_on_enter = true,
		enter = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
			local var_13_0 = Managers.world:wwise_world(arg_13_5)

			if arg_13_4 then
				WwiseWorld.trigger_event(var_13_0, "Play_player_ratling_gunner_weapon_ready", arg_13_2)
			end
		end,
		update = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
			if not arg_14_4 then
				return
			end

			local var_14_0 = ScriptUnit.extension(arg_14_1, "career_system")
			local var_14_1 = "fire"
			local var_14_2 = var_14_0:ability_id(var_14_1)

			var_14_0:get_activated_ability_data(var_14_2).priming_progress = ScriptUnit.extension(arg_14_2, "weapon_system"):get_custom_data("windup")

			var_0_19(var_14_0, arg_14_2)
		end,
		leave = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7)
			local var_15_0 = Managers.world:wwise_world(arg_15_5)

			if arg_15_4 then
				WwiseWorld.trigger_event(var_15_0, "Stop_player_ratling_gunner_weapon_ready", arg_15_2)

				if not arg_15_7 then
					local var_15_1 = ScriptUnit.extension(arg_15_1, "career_system")

					var_0_19(var_15_1, arg_15_2, 0)
				end
			end

			if not arg_15_7 and arg_15_6 ~= "firing" then
				if arg_15_4 then
					local var_15_2 = ScriptUnit.extension(arg_15_1, "first_person_system")

					CharacterStateHelper.play_animation_event_first_person(var_15_2, "attack_finished")
					CharacterStateHelper.play_animation_event_first_person(var_15_2, "barrel_spin_finished")
				end

				Unit.animation_event(arg_15_1, "no_anim_upperbody")
				Unit.animation_event(arg_15_1, "to_combat")
				Unit.animation_event(arg_15_1, "idle")
			end
		end
	},
	firing = {
		enter = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
			arg_16_3.shoot_time = 0

			local var_16_0 = true
			local var_16_1 = 0
			local var_16_2, var_16_3 = WwiseUtils.make_unit_auto_source(arg_16_5, arg_16_2, var_16_1)

			if arg_16_4 then
				Managers.state.vce:trigger_vce(arg_16_1, var_16_3, "Play_player_enemy_vce_ratling_gunner_shoot_start", var_16_0, var_16_2)
				WwiseWorld.trigger_event(var_16_3, "Play_player_ratling_gunner_shooting_loop", var_16_0, var_16_2)
			else
				Managers.state.vce:trigger_vce(arg_16_1, var_16_3, "Play_player_enemy_vce_ratling_gunner_shoot_start_husk", var_16_0, var_16_2)
				WwiseWorld.trigger_event(var_16_3, "Play_ratling_gunner_shooting_loop", var_16_0, var_16_2)
			end

			WwiseWorld.set_source_parameter(var_16_3, var_16_2, "ratling_gun_shooting_loop_parameter", 0)

			arg_16_3.shoot_sound_source_id = var_16_2
		end,
		update = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6)
			if arg_17_4 then
				var_0_17(arg_17_1, arg_17_2)
			end

			if arg_17_3.shoot_time > var_0_9 then
				return
			end

			arg_17_3.shoot_time = arg_17_3.shoot_time + arg_17_6

			local var_17_0 = arg_17_3.shoot_sound_source_id
			local var_17_1 = arg_17_3.shoot_time / var_0_9
			local var_17_2 = Managers.world:wwise_world(arg_17_5)

			WwiseWorld.set_source_parameter(var_17_2, var_17_0, "ratling_gun_shooting_loop_parameter", var_17_1)
		end,
		leave = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7)
			if not arg_18_7 then
				if arg_18_4 then
					local var_18_0 = ScriptUnit.extension(arg_18_1, "first_person_system")

					CharacterStateHelper.play_animation_event_first_person(var_18_0, "attack_finished")
					var_0_17(arg_18_1, arg_18_2)
				end

				Unit.animation_event(arg_18_1, "no_anim_upperbody")
				Unit.animation_event(arg_18_1, "to_combat")
			end

			local var_18_1 = Managers.world:wwise_world(arg_18_5)

			if arg_18_4 then
				WwiseWorld.trigger_event(var_18_1, "Stop_player_ratling_gunner_shooting_loop", arg_18_2)
			else
				WwiseWorld.trigger_event(var_18_1, "Stop_ratling_gunner_shooting_loop", arg_18_2)
			end

			arg_18_3.shoot_sound_source_id = nil
			arg_18_3.shoot_time = nil
		end
	},
	reloading = {
		enter = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
			if arg_19_4 then
				arg_19_3.time_in_reload = 0
			end

			local var_19_0 = Managers.player:owner(arg_19_1)

			if var_19_0.remote or var_19_0.bot_player then
				local var_19_1 = Managers.world:wwise_world(arg_19_5)

				WwiseWorld.trigger_event(var_19_1, "Play_player_ratling_gunner_weapon_reload_husk", arg_19_2)
			end
		end,
		update = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6)
			if not arg_20_4 then
				return
			end

			arg_20_3.time_in_reload = arg_20_3.time_in_reload + arg_20_6

			local var_20_0 = arg_20_3.time_in_reload / var_0_11

			ScriptUnit.extension(arg_20_2, "weapon_system"):set_custom_data("reload_progress", var_20_0)
		end,
		leave = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7)
			if not arg_21_7 then
				if arg_21_4 then
					ScriptUnit.extension(arg_21_2, "weapon_system"):set_custom_data("reload_progress", 0)
				end

				local var_21_0 = Managers.player:owner(arg_21_1)

				if var_21_0.remote or var_21_0.bot_player then
					Unit.animation_event(arg_21_1, "no_anim_upperbody")
					Unit.animation_event(arg_21_1, "to_combat")
					Unit.animation_event(arg_21_1, "idle")

					local var_21_1 = Managers.world:wwise_world(arg_21_5)

					WwiseWorld.trigger_event(var_21_1, "Stop_player_ratling_gunner_weapon_reload_husk", arg_21_2)
				end
			end
		end
	}
}
var_0_18.left_hand_attachment_node_linking = AttachmentNodeLinking.vs_ratling_gunner_gun.left
var_0_18.ammo_data = {
	ammo_immediately_available = true,
	play_reload_anim_on_wield_reload = true,
	ammo_hand = "left",
	infinite_ammo = true,
	reload_time = 0,
	ammo_per_reload = var_0_10,
	starting_reserve_ammo = var_0_10,
	ammo_per_clip = var_0_10,
	max_ammo = var_0_10
}

return {
	vs_ratling_gunner_gun = var_0_18
}
