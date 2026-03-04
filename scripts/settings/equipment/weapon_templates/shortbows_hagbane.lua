-- chunkname: @scripts/settings/equipment/weapon_templates/shortbows_hagbane.lua

local var_0_0 = {}
local var_0_1 = "poison_arrow_impact"
local var_0_2 = 4
local var_0_3 = 2

var_0_0.actions = {
	action_one = {
		default = {
			anim_event = "attack_shoot_fast",
			kind = "bow",
			weapon_action_hand = "left",
			apply_recoil = true,
			ammo_usage = 1,
			aim_assist_ramp_multiplier = 0.2,
			aim_assist_max_ramp_multiplier = 0.5,
			aim_assist_ramp_decay_delay = 0.3,
			hit_effect = "poison_arrow_impact_small",
			anim_event_last_ammo = "attack_shoot_fast_last",
			charge_value = "arrow_hit",
			fire_sound_event = "player_combat_weapon_shortbow_fire_light_poison",
			speed = 5000,
			total_time = 0.83,
			buff_data = {
				{
					start_time = 0,
					external_multiplier = 0.75,
					end_time = 0.3,
					buff_name = "planted_decrease_movement"
				}
			},
			allowed_chain_actions = {
				{
					sub_action = "default",
					start_time = 0,
					action = "action_wield",
					input = "action_wield"
				},
				{
					sub_action = "default",
					blocking_input = "action_two_hold",
					action = "action_one",
					start_time = 0.4,
					release_required = "action_one_hold",
					input = "action_one",
					end_time = math.huge
				},
				{
					sub_action = "default",
					start_time = 0.5,
					action = "action_two",
					input = "action_two_hold",
					end_time = math.huge
				},
				{
					sub_action = "default",
					start_time = 0.4,
					action = "weapon_reload",
					input = "weapon_reload"
				}
			},
			enter_function = function (arg_1_0, arg_1_1)
				arg_1_1:clear_input_buffer()

				return arg_1_1:reset_release_input()
			end,
			cleave_distribution = {
				attack = 0,
				impact = 0
			},
			projectile_info = Projectiles.machinegun_poison_arrow,
			impact_data = {
				damage_profile = "shortbow_hagbane",
				targets = 1
			},
			alert_sound_range_fire = var_0_2,
			alert_sound_range_hit = var_0_3,
			recoil_settings = {
				horizontal_climb = -0.5,
				restore_duration = 0.15,
				vertical_climb = -1,
				climb_duration = 0.1,
				climb_function = math.easeInCubic,
				restore_function = math.ease_out_quad
			}
		},
		shoot_charged = {
			reset_aim_on_attack = true,
			kind = "bow",
			charge_value = "zoomed_arrow_hit",
			weapon_action_hand = "left",
			apply_recoil = true,
			ammo_usage = 1,
			anim_event_last_ammo = "attack_shoot_last",
			minimum_hold_time = 0.3,
			fire_sound_event = "player_combat_weapon_shortbow_fire_heavy_poison",
			keep_zoom = true,
			speed = 8000,
			hold_input = "action_two_hold",
			anim_event = "attack_shoot",
			allow_hold_toggle = true,
			total_time = 0.66,
			allowed_chain_actions = {
				{
					sub_action = "default",
					start_time = 0.6,
					action = "action_two",
					input = "action_two_hold",
					end_time = math.huge
				},
				{
					sub_action = "default",
					start_time = 0.66,
					action = "action_wield",
					input = "action_wield"
				},
				{
					sub_action = "default",
					start_time = 0.6,
					action = "weapon_reload",
					input = "weapon_reload"
				}
			},
			hit_effect = var_0_1,
			cleave_distribution = {
				attack = 0,
				impact = 0
			},
			enter_function = function (arg_2_0, arg_2_1)
				arg_2_1:clear_input_buffer()

				return arg_2_1:reset_release_input()
			end,
			projectile_info = Projectiles.carbine_poison_arrow,
			impact_data = {
				damage_profile = "shortbow_hagbane_charged",
				aoe_on_bounce = true,
				aoe = ExplosionTemplates.carbine_poison_arrow
			},
			alert_sound_range_fire = var_0_2,
			alert_sound_range_hit = var_0_3,
			recoil_settings = {
				horizontal_climb = -0.5,
				restore_duration = 0.15,
				vertical_climb = -1,
				climb_duration = 0.1,
				climb_function = math.easeInCubic,
				restore_function = math.ease_out_quad
			}
		}
	},
	action_two = {
		default = {
			default_zoom = "zoom_in_trueflight",
			aim_zoom_delay = 0.25,
			kind = "aim",
			aim_at_gaze_setting = "tobii_aim_at_gaze_hagbane",
			anim_end_event = "draw_cancel",
			aim_sound_delay = 0.3,
			aim_assist_ramp_multiplier = 0.4,
			aim_assist_ramp_decay_delay = 0.3,
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
			anim_end_event_condition_func = function (arg_3_0, arg_3_1)
				return arg_3_1 ~= "new_interupting_action"
			end,
			total_time = math.huge,
			buff_data = {
				{
					start_time = 0,
					external_multiplier = 0.8,
					buff_name = "planted_charging_decrease_movement"
				}
			},
			allowed_chain_actions = {
				{
					sub_action = "default",
					start_time = 0,
					action = "action_wield",
					input = "action_wield",
					end_time = math.huge
				},
				{
					sub_action = "shoot_charged",
					start_time = 0.3,
					action = "action_one",
					input = "action_one",
					end_time = math.huge
				},
				{
					softbutton_threshold = 0.75,
					start_time = 0.3,
					action = "action_one",
					sub_action = "shoot_charged",
					input = "action_one_softbutton_gamepad",
					end_time = math.huge
				},
				{
					sub_action = "default",
					start_time = 0.3,
					action = "weapon_reload",
					input = "weapon_reload"
				}
			},
			buffed_zoom_thresholds = {
				"zoom_in_trueflight",
				"zoom_in"
			},
			zoom_condition_function = function ()
				return true
			end,
			unzoom_condition_function = function (arg_5_0)
				return arg_5_0 ~= "new_interupting_action"
			end,
			condition_func = function (arg_6_0, arg_6_1, arg_6_2)
				if arg_6_2 and (arg_6_2:total_remaining_ammo() <= 0 or arg_6_2:is_reloading()) then
					return false
				end

				return true
			end
		}
	},
	weapon_reload = ActionTemplates.reload,
	action_inspect = ActionTemplates.action_inspect_left,
	action_wield = ActionTemplates.wield_left
}
var_0_0.ammo_data = {
	ammo_per_reload = 1,
	max_ammo = 17,
	ammo_per_clip = 1,
	reload_on_ammo_pickup = true,
	reload_time = 0.2,
	ammo_hand = "left",
	ammo_unit_attachment_node_linking = AttachmentNodeLinking.arrow
}
var_0_0.attack_meta_data = {
	aim_at_node = "j_head",
	charged_attack_action_name = "shoot_charged",
	can_charge_shot = true,
	aim_at_node_charged = "j_spine",
	minimum_charge_time = 0.35,
	charge_above_range = 20,
	charge_when_obstructed = false,
	ignore_enemies_for_obstruction = true,
	effective_against = bit.bor(BreedCategory.Berserker, BreedCategory.Special),
	effective_against_charged = bit.bor(BreedCategory.Infantry, BreedCategory.Berserker, BreedCategory.Armored, BreedCategory.Shielded)
}

local var_0_4 = var_0_0.actions.action_one.default

var_0_0.default_loaded_projectile_settings = {
	drop_multiplier = 0.03,
	speed = var_0_4.speed,
	gravity = ProjectileGravitySettings[var_0_4.projectile_info.gravity_settings]
}
var_0_0.aim_assist_settings = {
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
var_0_0.default_spread_template = "bow"
var_0_0.left_hand_unit = "units/weapons/player/wpn_we_bow_01_t1/wpn_we_bow_01_t1"
var_0_0.display_unit = "units/weapons/weapon_display/display_bow"
var_0_0.left_hand_attachment_node_linking = AttachmentNodeLinking.shortbow
var_0_0.wield_anim = "to_shortbow"
var_0_0.wield_anim_no_ammo = "to_shortbow_noammo"
var_0_0.state_machine = "units/beings/player/first_person_base/state_machines/ranged/shortbow"
var_0_0.crosshair_style = "projectile"
var_0_0.no_ammo_reload_event = "reload"
var_0_0.buff_type = "RANGED"
var_0_0.weapon_type = "SHORTBOW_HAGBANE"
var_0_0.default_projectile_action = var_0_0.actions.action_one.default
var_0_0.dodge_count = 6
var_0_0.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1.25
	},
	change_dodge_speed = {
		external_optional_multiplier = 1.25
	}
}
var_0_0.server_buffs = {
	we_deus_01_kerillian_critical_bleed_dot_disable = {}
}
var_0_0.weapon_diagram = {
	light_attack = {
		[DamageTypes.ARMOR_PIERCING] = 2,
		[DamageTypes.CLEAVE] = 0,
		[DamageTypes.SPEED] = 5,
		[DamageTypes.STAGGER] = 0,
		[DamageTypes.DAMAGE] = 4
	},
	heavy_attack = {
		[DamageTypes.ARMOR_PIERCING] = 5,
		[DamageTypes.CLEAVE] = 6,
		[DamageTypes.SPEED] = 2,
		[DamageTypes.STAGGER] = 5,
		[DamageTypes.DAMAGE] = 6
	}
}
var_0_0.tooltip_keywords = {
	"weapon_keyword_damage_over_time",
	"weapon_keyword_rapid_fire",
	"weapon_keyword_crowd_control"
}
var_0_0.tooltip_compare = {
	light = {
		action_name = "action_one",
		sub_action_name = "default"
	},
	heavy = {
		action_name = "action_one",
		sub_action_name = "shoot_charged"
	}
}
var_0_0.tooltip_detail = {
	light = {
		action_name = "action_one",
		sub_action_name = "default"
	},
	heavy = {
		action_name = "action_two",
		sub_action_name = "default"
	}
}
var_0_0.wwise_dep_left_hand = {
	"wwise/bow"
}

return {
	shortbow_hagbane_template_1 = table.clone(var_0_0)
}
