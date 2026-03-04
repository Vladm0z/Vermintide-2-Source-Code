-- chunkname: @scripts/settings/equipment/weapon_templates/1h_throwing_axes.lua

local var_0_0 = "throwing_axe"
local var_0_1 = 4
local var_0_2 = 2
local var_0_3 = {
	actions = {
		action_one = {
			default = {
				anim_end_event = "attack_finished",
				kind = "thrown_projectile",
				anim_event_no_ammo_left = "to_noammo",
				charge_value = "arrow_hit",
				weapon_action_hand = "right",
				apply_recoil = true,
				aim_assist_max_ramp_multiplier = 0.8,
				anim_event_last_ammo = "to_noammo",
				aim_assist_ramp_decay_delay = 0.3,
				ammo_usage = 1,
				fire_time = 0.4,
				speed = 3500,
				aim_assist_ramp_multiplier = 0.4,
				anim_event = "attack_throw",
				no_out_of_ammo_vo = true,
				total_time = 0.85,
				anim_end_event_condition_func = function (arg_1_0, arg_1_1)
					return arg_1_1 ~= "new_interupting_action"
				end,
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
						start_time = 0.35,
						action = "weapon_reload",
						input = "weapon_reload"
					},
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
					}
				},
				enter_function = function (arg_2_0, arg_2_1)
					arg_2_1:clear_input_buffer()

					return arg_2_1:reset_release_input()
				end,
				hit_effect = var_0_0,
				projectile_info = Projectiles.throwing_axe,
				impact_data = {
					depth = 0.2,
					depth_damage_modifier_min = 1,
					link_pickup = true,
					damage_profile = "throwing_axe",
					no_stop_on_friendly_fire = true,
					depth_damage_modifier_max = 1.2,
					depth_offset = -0.2,
					pickup_settings = {
						use_weapon_skin = true,
						link_hit_zones = {
							"head",
							"neck",
							"torso"
						}
					}
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
			throw_charged = {
				reset_aim_on_attack = true,
				anim_end_event = "attack_finished",
				kind = "thrown_projectile",
				charge_value = "zoomed_arrow_hit",
				weapon_action_hand = "right",
				attack_template = "arrow_sniper_1",
				apply_recoil = true,
				anim_event_last_ammo = "to_noammo",
				minimum_hold_time = 0.4,
				ammo_usage = 1,
				fire_time = 0.2,
				speed = 5000,
				hold_input = "action_two_hold",
				anim_event = "attack_throw",
				no_out_of_ammo_vo = true,
				total_time = 0.9,
				anim_end_event_condition_func = function (arg_3_0, arg_3_1)
					return arg_3_1 ~= "new_interupting_action"
				end,
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0,
						action = "weapon_reload",
						input = "weapon_reload"
					},
					{
						sub_action = "default",
						start_time = 0.5,
						action = "action_wield",
						input = "action_wield"
					},
					{
						sub_action = "default",
						start_time = 0.55,
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
					}
				},
				enter_function = function (arg_4_0, arg_4_1)
					arg_4_1:clear_input_buffer()

					return arg_4_1:reset_release_input()
				end,
				hit_effect = var_0_0,
				projectile_info = Projectiles.throwing_axe,
				impact_data = {
					depth = 0.2,
					depth_damage_modifier_min = 1,
					link_pickup = true,
					damage_profile = "throwing_axe_charged",
					no_stop_on_friendly_fire = true,
					depth_damage_modifier_max = 1.2,
					depth_offset = -0.2,
					pickup_settings = {
						use_weapon_skin = true,
						link_hit_zones = {
							"head",
							"neck",
							"torso"
						}
					}
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
			}
		},
		action_two = {
			default = {
				allow_hold_toggle = true,
				anim_end_event = "throw_charge_cancel",
				kind = "dummy",
				weapon_action_hand = "right",
				hold_input = "action_two_hold",
				anim_event = "throw_charge",
				minimum_hold_time = 0.2,
				anim_end_event_condition_func = function (arg_5_0, arg_5_1)
					return arg_5_1 ~= "new_interupting_action"
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
						start_time = 0,
						action = "weapon_reload",
						input = "weapon_reload"
					},
					{
						sub_action = "default",
						start_time = 0.2,
						action = "action_wield",
						input = "action_wield",
						end_time = math.huge
					},
					{
						sub_action = "throw_charged",
						start_time = 0.65,
						action = "action_one",
						input = "action_one",
						end_time = math.huge
					},
					{
						softbutton_threshold = 0.75,
						start_time = 0.65,
						action = "action_one",
						sub_action = "throw_charged",
						input = "action_one_softbutton_gamepad",
						end_time = math.huge
					}
				},
				condition_func = function (arg_6_0, arg_6_1, arg_6_2)
					if arg_6_2 and (arg_6_2:total_remaining_ammo() <= 0 or arg_6_2:is_reloading()) then
						return false
					end

					return true
				end
			}
		},
		weapon_reload = {
			default = {
				total_time = 2.5,
				anim_time_scale = 1.25,
				hold_input = "weapon_reload_hold",
				anim_end_event = "interrupt",
				kind = "dummy",
				uninterruptible = false,
				do_not_validate_with_hold = true,
				one_ammo_catch_time = 1.1,
				anim_event = "reload",
				minimum_hold_time = 0.5,
				anim_end_event_condition_func = function (arg_7_0, arg_7_1)
					return arg_7_1 ~= "new_interupting_action"
				end,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.85,
						buff_name = "planted_fast_decrease_movement",
						end_time = math.huge
					}
				},
				enter_function = function (arg_8_0, arg_8_1)
					arg_8_1:reset_release_input()
					arg_8_1:clear_input_buffer()
				end,
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.2,
						action = "action_wield",
						input = "action_wield"
					},
					{
						sub_action = "catch",
						start_time = 1.5,
						action = "weapon_reload",
						auto_chain = true
					}
				},
				condition_func = function (arg_9_0, arg_9_1, arg_9_2)
					if arg_9_2 and arg_9_2:total_remaining_ammo() < arg_9_2:max_ammo() then
						return true
					end

					return false
				end
			},
			catch = {
				total_time = 0.7,
				uninterruptible = false,
				catch_time = 0.1,
				kind = "catch",
				do_not_validate_with_hold = true,
				hold_input = "weapon_reload_hold",
				anim_event = "reload_last",
				minimum_hold_time = 0.2,
				anim_end_event_condition_func = function (arg_10_0, arg_10_1)
					return arg_10_1 ~= "new_interupting_action"
				end,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 1.1,
						buff_name = "planted_fast_decrease_movement",
						end_time = math.huge
					}
				},
				enter_function = function (arg_11_0, arg_11_1)
					arg_11_1:reset_release_input()
					arg_11_1:clear_input_buffer()
				end,
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.2,
						action = "action_wield",
						input = "action_wield"
					},
					{
						sub_action = "catch",
						start_time = 0.55,
						action = "weapon_reload",
						input = "weapon_reload_hold"
					}
				},
				chain_condition_func = function (arg_12_0, arg_12_1, arg_12_2)
					if arg_12_2 and arg_12_2:total_remaining_ammo() < arg_12_2:max_ammo() then
						return true
					end

					return false
				end
			}
		},
		action_inspect = ActionTemplates.action_inspect,
		action_wield = ActionTemplates.wield
	},
	ammo_data = {
		unique_ammo_type = true,
		ammo_per_reload = 1,
		ammo_type = "throwing_axe",
		ammo_per_clip = 1,
		ammo_hand = "right",
		play_reload_anim_on_wield_reload = true,
		has_wield_reload_anim = true,
		max_ammo = 3,
		reload_on_ammo_pickup = true,
		reload_time = 0,
		ammo_kind = "thrown",
		ammo_unit_attachment_node_linking = AttachmentNodeLinking.one_handed_melee_weapon.right
	},
	attack_meta_data = {
		max_range = 30,
		charged_attack_action_name = "throw_charged",
		aim_at_node = "j_spine1",
		can_charge_shot = true,
		ignore_enemies_for_obstruction_charged = true,
		aim_at_node_charged = "j_head",
		minimum_charge_time = 0.55,
		charge_above_range = 15,
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
var_0_3.default_spread_template = "throwing_axe"
var_0_3.right_hand_unit = "units/weapons/player/wpn_dw_thrown_axe_01_t1/wpn_dw_thrown_axe_01_t1"
var_0_3.right_hand_attachment_node_linking = AttachmentNodeLinking.one_handed_melee_weapon.right
var_0_3.display_unit = "units/weapons/weapon_display/display_1h_throwing_axes"
var_0_3.wield_anim_not_loaded = "to_throwing_axe"
var_0_3.wield_anim = "to_throwing_axe"
var_0_3.wield_anim_no_ammo = "to_throwing_axe_noammo"
var_0_3.state_machine = "units/beings/player/first_person_base/state_machines/ranged/throwing_axes"
var_0_3.crosshair_style = "projectile"
var_0_3.no_ammo_reload_event = "to_ammo"
var_0_3.reload_event = "to_ammo"
var_0_3.buff_type = "RANGED"
var_0_3.weapon_type = "THROWING_AXE"
var_0_3.default_projectile_action = var_0_3.actions.action_one.default
var_0_3.dodge_count = 6
var_0_3.destroy_indexed_projectiles = true
var_0_3.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1.2
	},
	change_dodge_speed = {
		external_optional_multiplier = 1.2
	}
}
var_0_3.wwise_dep_ammo = {
	"wwise/throwing_axe"
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
		[DamageTypes.ARMOR_PIERCING] = 5,
		[DamageTypes.CLEAVE] = 0,
		[DamageTypes.SPEED] = 4,
		[DamageTypes.STAGGER] = 5,
		[DamageTypes.DAMAGE] = 5
	},
	heavy_attack = {
		[DamageTypes.ARMOR_PIERCING] = 6,
		[DamageTypes.CLEAVE] = 3,
		[DamageTypes.SPEED] = 1,
		[DamageTypes.STAGGER] = 6,
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
		sub_action_name = "throw_charged"
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
			sub_action_name = "throw_charged"
		},
		{
			action_name = "action_one",
			chain_start_time = 0.8,
			sub_action_name = "throw_special_charged"
		},
		custom_chain = true
	}
}

local var_0_5 = table.clone(var_0_3)

var_0_5.actions.weapon_reload.default.allowed_chain_actions = {
	{
		sub_action = "default",
		start_time = 0.2,
		action = "action_wield",
		input = "action_wield"
	},
	{
		sub_action = "catch",
		start_time = 0.8,
		action = "weapon_reload",
		auto_chain = true
	}
}

return {
	one_handed_throwing_axes_template = var_0_3,
	one_handed_throwing_axes_template_vs = var_0_5
}
