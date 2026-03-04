-- chunkname: @scripts/settings/equipment/weapon_templates/longbows.lua

local var_0_0 = "arrow_impact"
local var_0_1 = 4
local var_0_2 = 2
local var_0_3 = {
	actions = {
		action_one = {
			default = {
				anim_event = "attack_shoot_fast",
				ammo_usage = 1,
				kind = "bow",
				apply_recoil = true,
				aim_assist_max_ramp_multiplier = 0.8,
				aim_assist_ramp_decay_delay = 0.3,
				anim_event_last_ammo = "attack_shoot_fast_last",
				charge_value = "arrow_hit",
				weapon_action_hand = "left",
				fire_sound_event = "player_combat_weapon_bow_fire_light",
				speed = 9000,
				aim_assist_ramp_multiplier = 0.4,
				total_time = 0.83,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.5,
						end_time = 0.3,
						buff_name = "planted_decrease_movement"
					}
				},
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.6,
						action = "action_wield",
						input = "action_wield"
					},
					{
						sub_action = "default",
						start_time = 0.65,
						action = "action_one",
						release_required = "action_one_hold",
						input = "action_one",
						end_time = math.huge
					},
					{
						sub_action = "default",
						start_time = 0.6,
						action = "action_two",
						input = "action_two_hold",
						end_time = math.huge
					},
					{
						sub_action = "default",
						start_time = 0.65,
						action = "weapon_reload",
						input = "weapon_reload"
					}
				},
				enter_function = function (arg_1_0, arg_1_1)
					arg_1_1:clear_input_buffer()

					return arg_1_1:reset_release_input()
				end,
				hit_effect = var_0_0,
				projectile_info = Projectiles.carbine_arrow,
				impact_data = {
					wall_nail = true,
					depth = 0.1,
					targets = 1,
					damage_profile = "arrow_carbine",
					link = true,
					depth_offset = -0.6
				},
				alert_sound_range_fire = var_0_1,
				alert_sound_range_hit = var_0_2,
				recoil_settings = {
					horizontal_climb = -0.5,
					restore_duration = 0.2,
					vertical_climb = -1.5,
					climb_duration = 0.1,
					climb_function = math.easeInCubic,
					restore_function = math.ease_out_quad
				}
			},
			shoot_charged = {
				reset_aim_on_attack = true,
				attack_template = "arrow_sniper_1",
				anim_time_scale = 1.25,
				kind = "bow",
				charge_value = "zoomed_arrow_hit",
				weapon_action_hand = "left",
				apply_recoil = true,
				anim_event_last_ammo = "attack_shoot_last",
				minimum_hold_time = 0.4,
				anim_end_event = "to_unzoom",
				ammo_usage = 1,
				fire_sound_event = "player_combat_weapon_bow_fire_heavy",
				speed = 16000,
				hold_input = "action_two_hold",
				anim_event = "attack_shoot",
				total_time = 0.6,
				anim_end_event_condition_func = function (arg_2_0, arg_2_1)
					return arg_2_1 ~= "new_interupting_action"
				end,
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.5,
						action = "action_wield",
						input = "action_wield"
					},
					{
						sub_action = "default",
						start_time = 0.25,
						action = "action_one",
						release_required = "action_two_hold",
						input = "action_one"
					},
					{
						sub_action = "default",
						start_time = 0.55,
						action = "action_two",
						input = "action_two_hold",
						end_time = math.huge
					},
					{
						sub_action = "default",
						start_time = 0.55,
						action = "weapon_reload",
						input = "weapon_reload"
					}
				},
				enter_function = function (arg_3_0, arg_3_1)
					arg_3_1:clear_input_buffer()

					return arg_3_1:reset_release_input()
				end,
				hit_effect = var_0_0,
				projectile_info = Projectiles.sniper_arrow,
				impact_data = {
					depth = 0.15,
					wall_nail = true,
					damage_profile = "arrow_sniper",
					link = true,
					depth_offset = -0.6
				},
				alert_sound_range_fire = var_0_1,
				alert_sound_range_hit = var_0_2,
				recoil_settings = {
					horizontal_climb = -0.5,
					restore_duration = 0.2,
					vertical_climb = -1.5,
					climb_duration = 0.1,
					climb_function = math.easeInCubic,
					restore_function = math.ease_out_quad
				}
			},
			shoot_special_charged = {
				reset_aim_on_attack = true,
				anim_end_event = "to_unzoom",
				kind = "bow",
				charge_value = "zoomed_arrow_hit",
				weapon_action_hand = "left",
				apply_recoil = true,
				anim_event_last_ammo = "attack_shoot_last",
				minimum_hold_time = 0.4,
				anim_time_scale = 1.25,
				ammo_usage = 1,
				fire_sound_event = "player_combat_weapon_bow_fire_heavy",
				speed = 16000,
				hold_input = "action_two_hold",
				anim_event = "attack_shoot",
				total_time = 0.6,
				anim_end_event_condition_func = function (arg_4_0, arg_4_1)
					return arg_4_1 ~= "new_interupting_action"
				end,
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.5,
						action = "action_wield",
						input = "action_wield"
					},
					{
						sub_action = "default",
						start_time = 0.25,
						action = "action_one",
						release_required = "action_two_hold",
						input = "action_one"
					},
					{
						sub_action = "default",
						start_time = 0.55,
						action = "action_two",
						input = "action_two_hold",
						end_time = math.huge
					},
					{
						sub_action = "default",
						start_time = 0.55,
						action = "weapon_reload",
						input = "weapon_reload"
					}
				},
				enter_function = function (arg_5_0, arg_5_1)
					arg_5_1:clear_input_buffer()

					return arg_5_1:reset_release_input()
				end,
				hit_effect = var_0_0,
				projectile_info = Projectiles.sniper_arrow,
				impact_data = {
					depth = 0.15,
					wall_nail = true,
					damage_profile = "arrow_sniper",
					link = true,
					depth_offset = -0.6
				},
				alert_sound_range_fire = var_0_1,
				alert_sound_range_hit = var_0_2,
				chain_condition_func = function (arg_6_0, arg_6_1)
					return ScriptUnit.extension(arg_6_0, "buff_system"):has_buff_type("we_timed_charged_shot")
				end,
				recoil_settings = {
					horizontal_climb = -0.5,
					restore_duration = 0.2,
					vertical_climb = -1.5,
					climb_duration = 0.1,
					climb_function = math.easeInCubic,
					restore_function = math.ease_out_quad
				}
			}
		},
		action_two = {
			default = {
				default_zoom = "zoom_in",
				kind = "aim",
				aim_zoom_delay = 0.01,
				anim_time_scale = 1.25,
				aim_at_gaze_setting = "tobii_aim_at_gaze_longbow",
				aim_sound_delay = 0.5,
				anim_end_event = "draw_cancel",
				aim_assist_ramp_multiplier = 0.6,
				aim_assist_ramp_decay_delay = 0.2,
				aim_sound_event = "player_combat_weapon_bow_tighten_grip_loop",
				minimum_hold_time = 0.2,
				ammo_usage = 1,
				weapon_action_hand = "left",
				unaim_sound_event = "stop_player_combat_weapon_bow_tighten_grip_loop",
				charge_time = 0.5,
				aim_assist_max_ramp_multiplier = 0.8,
				hold_input = "action_two_hold",
				anim_event = "draw_bow",
				allow_hold_toggle = true,
				reload_when_out_of_ammo = true,
				anim_end_event_condition_func = function (arg_7_0, arg_7_1)
					return arg_7_1 ~= "new_interupting_action"
				end,
				total_time = math.huge,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.25,
						buff_name = "planted_charging_decrease_movement"
					}
				},
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.3,
						action = "action_wield",
						input = "action_wield",
						end_time = math.huge
					},
					{
						sub_action = "shoot_special_charged",
						start_time = 0.5,
						action = "action_one",
						end_time = 1,
						input = "action_one"
					},
					{
						sub_action = "shoot_charged",
						start_time = 0.65,
						action = "action_one",
						input = "action_one",
						end_time = math.huge
					},
					{
						softbutton_threshold = 0.75,
						start_time = 0.5,
						action = "action_one",
						sub_action = "shoot_charged",
						input = "action_one_softbutton_gamepad",
						end_time = math.huge
					},
					{
						sub_action = "default",
						start_time = 0.65,
						action = "weapon_reload",
						input = "weapon_reload"
					}
				},
				buffed_zoom_thresholds = {
					"zoom_in",
					"increased_zoom_in"
				},
				zoom_condition_function = function ()
					return true
				end,
				unzoom_condition_function = function (arg_9_0)
					return arg_9_0 ~= "new_interupting_action"
				end,
				condition_func = function (arg_10_0, arg_10_1, arg_10_2)
					if arg_10_2 and (arg_10_2:total_remaining_ammo() <= 0 or arg_10_2:is_reloading()) then
						return false
					end

					return true
				end
			}
		},
		weapon_reload = ActionTemplates.reload,
		action_inspect = ActionTemplates.action_inspect_left,
		action_wield = ActionTemplates.wield_left
	},
	ammo_data = {
		ammo_per_reload = 1,
		max_ammo = 20,
		ammo_per_clip = 1,
		reload_on_ammo_pickup = true,
		reload_time = 0,
		ammo_hand = "left",
		ammo_unit_attachment_node_linking = AttachmentNodeLinking.arrow
	},
	attack_meta_data = {
		aim_at_node = "j_spine1",
		charged_attack_action_name = "shoot_charged",
		ignore_enemies_for_obstruction_charged = true,
		can_charge_shot = true,
		aim_at_node_charged = "j_head",
		minimum_charge_time = 0.55,
		charge_above_range = 30,
		charge_when_obstructed = false,
		ignore_enemies_for_obstruction = false,
		effective_against = bit.bor(BreedCategory.Berserker, BreedCategory.Special),
		effective_against_charged = bit.bor(BreedCategory.Berserker, BreedCategory.Special, BreedCategory.Armored)
	}
}
local var_0_4 = var_0_3.actions.action_one.default

var_0_3.default_loaded_projectile_settings = {
	drop_multiplier = 0.03,
	speed = var_0_4.speed,
	gravity = ProjectileGravitySettings[var_0_4.projectile_info.gravity_settings]
}
var_0_3.default_spread_template = "longbow"
var_0_3.left_hand_unit = "units/weapons/player/wpn_we_bow_01_t1/wpn_we_bow_01_t1"
var_0_3.display_unit = "units/weapons/weapon_display/display_longbow"
var_0_3.left_hand_attachment_node_linking = AttachmentNodeLinking.bow
var_0_3.wield_anim = "to_longbow"
var_0_3.wield_anim_no_ammo = "to_longbow_noammo"
var_0_3.state_machine = "units/beings/player/first_person_base/state_machines/ranged/longbow"
var_0_3.crosshair_style = "projectile"
var_0_3.no_ammo_reload_event = "reload"
var_0_3.buff_type = "RANGED"
var_0_3.weapon_type = "LONGBOW"
var_0_3.default_projectile_action = var_0_3.actions.action_one.default
var_0_3.dodge_count = 3
var_0_3.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1
	},
	change_dodge_speed = {
		external_optional_multiplier = 1
	}
}
var_0_3.wwise_dep_left_hand = {
	"wwise/bow"
}
var_0_3.aim_assist_settings = {
	max_range = 50,
	no_aim_input_multiplier = 0,
	always_auto_aim = true,
	base_multiplier = 0,
	target_node = "j_neck",
	effective_max_range = 30,
	breed_scalars = {
		skaven_storm_vermin = 1,
		skaven_clan_rat = 1,
		skaven_slave = 1
	}
}
var_0_3.weapon_diagram = {
	light_attack = {
		[DamageTypes.ARMOR_PIERCING] = 3,
		[DamageTypes.CLEAVE] = 3,
		[DamageTypes.SPEED] = 5,
		[DamageTypes.STAGGER] = 1,
		[DamageTypes.DAMAGE] = 3
	},
	heavy_attack = {
		[DamageTypes.ARMOR_PIERCING] = 6,
		[DamageTypes.CLEAVE] = 2,
		[DamageTypes.SPEED] = 2,
		[DamageTypes.STAGGER] = 3,
		[DamageTypes.DAMAGE] = 6
	}
}
var_0_3.tooltip_keywords = {
	"weapon_keyword_armour_piercing",
	"weapon_keyword_sniper",
	"weapon_keyword_versatile"
}
var_0_3.tooltip_compare = {
	light = {
		action_name = "action_one",
		sub_action_name = "default"
	},
	heavy = {
		action_name = "action_one",
		sub_action_name = "shoot_charged"
	}
}
var_0_3.tooltip_detail = {
	light = {
		action_name = "action_one",
		sub_action_name = "default"
	},
	heavy = {
		{
			action_name = "action_one",
			chain_start_time = 0.65,
			sub_action_name = "shoot_charged"
		},
		{
			action_name = "action_one",
			chain_start_time = 0.8,
			sub_action_name = "shoot_special_charged"
		},
		custom_chain = true
	}
}

return {
	longbow_template_1 = table.clone(var_0_3)
}
