-- chunkname: @scripts/settings/equipment/weapon_templates/brace_of_pistols.lua

local var_0_0 = {
	actions = {
		action_one = {
			default = {
				total_time_secondary = 2,
				speed = 16000,
				kind = "handgun",
				charge_value = "bullet_hit",
				alert_sound_range_fire = 12,
				alert_sound_range_hit = 2,
				apply_recoil = true,
				reload_when_out_of_ammo = true,
				headshot_multiplier = 2,
				hit_effect = "bullet_impact",
				aim_assist_max_ramp_multiplier = 0.3,
				aim_assist_auto_hit_chance = 0.5,
				aim_assist_ramp_decay_delay = 0.2,
				range = 100,
				ammo_usage = 1,
				fire_time = 0,
				anim_event_secondary = "reload",
				aim_assist_ramp_multiplier = 0.1,
				anim_event = "attack_shoot",
				reload_time = 0.1,
				total_time = 1,
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.4,
						action = "action_wield",
						input = "action_wield"
					},
					{
						sub_action = "default",
						start_time = 0.75,
						action = "action_one",
						sound_time_offset = -0.05,
						chain_ready_sound = "weapon_gun_ready",
						release_required = "action_one_hold",
						input = "action_one"
					},
					{
						sub_action = "default",
						start_time = 0.75,
						action = "action_one",
						input = "action_one_hold"
					},
					{
						sub_action = "default",
						start_time = 0.4,
						action = "action_two",
						input = "action_two_hold"
					},
					{
						sub_action = "default",
						start_time = 0.75,
						action = "weapon_reload",
						input = "weapon_reload"
					},
					{
						sub_action = "default",
						start_time = 0.6,
						action = "action_three",
						input = "action_three"
					},
					{
						sub_action = "auto_reload",
						start_time = 0.8,
						action = "weapon_reload",
						auto_chain = true
					}
				},
				enter_function = function (arg_1_0, arg_1_1)
					arg_1_1:clear_input_buffer()

					return arg_1_1:reset_release_input()
				end,
				projectile_info = Projectiles.pistol_shot,
				impact_data = {
					damage_profile = "shot_carbine"
				},
				recoil_settings = {
					horizontal_climb = 0,
					restore_duration = 0.25,
					vertical_climb = 2,
					climb_duration = 0.1,
					climb_function = math.easeInCubic,
					restore_function = math.ease_out_quad
				}
			},
			fast_shot = {
				reload_when_out_of_ammo = true,
				alert_sound_range_fire = 12,
				kind = "handgun",
				alert_sound_range_hit = 2,
				apply_recoil = true,
				spread_template_override = "pistol_special",
				charge_value = "bullet_hit",
				headshot_multiplier = 2,
				aim_assist_ramp_multiplier = 0.05,
				hit_effect = "bullet_impact",
				aim_assist_max_ramp_multiplier = 0.3,
				aim_assist_auto_hit_chance = 0.75,
				minimum_hold_time = 0.2,
				range = 100,
				ammo_usage = 1,
				fire_time = 0,
				aim_assist_ramp_decay_delay = 0.1,
				speed = 16000,
				hold_input = "action_two_hold",
				anim_event = "attack_shoot_fast",
				reload_time = 0.1,
				total_time = 1,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.85,
						buff_name = "planted_fast_decrease_movement"
					}
				},
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.2,
						action = "action_wield",
						input = "action_wield"
					},
					{
						sub_action = "fast_shot",
						start_time = 0.25,
						action = "action_one",
						sound_time_offset = -0.05,
						chain_ready_sound = "weapon_gun_ready",
						release_required = "action_one_hold",
						input = "action_one"
					},
					{
						sub_action = "fast_shot",
						start_time = 0.25,
						action = "action_one",
						input = "action_one_hold"
					},
					{
						sub_action = "default",
						start_time = 0.2,
						action = "weapon_reload",
						input = "weapon_reload"
					},
					{
						start_time = 0,
						blocker = true,
						input = "action_two_hold"
					},
					{
						sub_action = "auto_reload",
						start_time = 0,
						action = "weapon_reload",
						auto_chain = true
					}
				},
				enter_function = function (arg_2_0, arg_2_1)
					arg_2_1:clear_input_buffer()

					return arg_2_1:reset_release_input()
				end,
				projectile_info = Projectiles.pistol_shot,
				impact_data = {
					damage_profile = "shot_carbine"
				},
				recoil_settings = {
					horizontal_climb = 0,
					restore_duration = 0.25,
					vertical_climb = 2,
					climb_duration = 0.1,
					climb_function = math.easeInCubic,
					restore_function = math.ease_out_quad
				}
			},
			special_action_shoot = {
				total_time_secondary = 2,
				speed = 16000,
				kind = "handgun",
				charge_value = "bullet_hit",
				alert_sound_range_fire = 12,
				alert_sound_range_hit = 2,
				apply_recoil = true,
				reload_when_out_of_ammo = true,
				headshot_multiplier = 2,
				hit_effect = "bullet_impact",
				aim_assist_max_ramp_multiplier = 0.3,
				aim_assist_auto_hit_chance = 0.5,
				aim_assist_ramp_decay_delay = 0.2,
				range = 100,
				ammo_usage = 1,
				fire_time = 0,
				anim_event_secondary = "reload",
				aim_assist_ramp_multiplier = 0.1,
				anim_event = "attack_shoot",
				reload_time = 0.1,
				total_time = 1,
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.4,
						action = "action_wield",
						input = "action_wield"
					},
					{
						sub_action = "default",
						start_time = 0.75,
						action = "action_one",
						sound_time_offset = -0.05,
						chain_ready_sound = "weapon_gun_ready",
						release_required = "action_one_hold",
						input = "action_one"
					},
					{
						sub_action = "default",
						start_time = 0.75,
						action = "action_one",
						input = "action_one_hold"
					},
					{
						sub_action = "default",
						start_time = 0.4,
						action = "action_two",
						input = "action_two_hold"
					},
					{
						sub_action = "default",
						start_time = 0.75,
						action = "weapon_reload",
						input = "weapon_reload"
					},
					{
						sub_action = "default",
						start_time = 0.6,
						action = "action_three",
						input = "action_three"
					},
					{
						sub_action = "auto_reload",
						start_time = 0.8,
						action = "weapon_reload",
						auto_chain = true
					}
				},
				enter_function = function (arg_3_0, arg_3_1)
					arg_3_1:clear_input_buffer()

					return arg_3_1:reset_release_input()
				end,
				projectile_info = Projectiles.pistol_shot,
				impact_data = {
					damage_profile = "shot_carbine"
				},
				recoil_settings = {
					horizontal_climb = 0,
					restore_duration = 0.25,
					vertical_climb = 2,
					climb_duration = 0.1,
					climb_function = math.easeInCubic,
					restore_function = math.ease_out_quad
				}
			}
		},
		action_two = {
			default = {
				anim_event = "lock_target",
				can_abort_reload = true,
				allow_hold_toggle = true,
				anim_end_event = "attack_finished",
				kind = "dummy",
				minimum_hold_time = 0.2,
				spread_template_override = "pistol_special",
				hold_input = "action_two_hold",
				ammo_requirement = 1,
				anim_end_event_condition_func = function (arg_4_0, arg_4_1)
					return arg_4_1 ~= "new_interupting_action"
				end,
				total_time = math.huge,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.85,
						buff_name = "planted_fast_decrease_movement"
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
						sub_action = "fast_shot",
						start_time = 0,
						action = "action_one",
						input = "action_one"
					},
					{
						sub_action = "fast_shot",
						start_time = 0.25,
						action = "action_one",
						input = "action_one_hold"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "weapon_reload",
						input = "weapon_reload"
					},
					{
						start_time = 0,
						blocker = true,
						input = "action_two_hold"
					},
					{
						sub_action = "auto_reload",
						start_time = 0,
						action = "weapon_reload",
						auto_chain = true
					}
				},
				condition_func = function (arg_5_0, arg_5_1, arg_5_2)
					if arg_5_2 and arg_5_2:total_remaining_ammo() <= 0 then
						return false
					end

					return true
				end
			}
		},
		action_three = {
			default = {
				anim_end_event = "attack_finished",
				ammo_requirement = 1,
				can_abort_reload = true,
				kind = "dummy",
				anim_event = "special_action",
				total_time = 1.71,
				anim_end_event_condition_func = function (arg_6_0, arg_6_1)
					return arg_6_1 ~= "new_interupting_action"
				end,
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.4,
						action = "action_wield",
						input = "action_wield"
					},
					{
						sub_action = "special_action_shoot",
						start_time = 0.75,
						action = "action_one",
						release_required = "action_one_hold",
						end_time = 1.68,
						input = "action_one"
					},
					{
						sub_action = "special_action_shoot",
						start_time = 0.75,
						action = "action_one",
						end_time = 1.68,
						input = "action_one_hold"
					},
					{
						sub_action = "default",
						start_time = 1.7,
						action = "action_one",
						release_required = "action_one_hold",
						input = "action_one"
					},
					{
						sub_action = "default",
						start_time = 0.4,
						action = "action_two",
						input = "action_two_hold"
					},
					{
						sub_action = "default",
						start_time = 0.75,
						action = "weapon_reload",
						input = "weapon_reload"
					},
					{
						sub_action = "default",
						start_time = 0.8,
						action = "action_three",
						input = "action_three"
					}
				},
				condition_func = function (arg_7_0, arg_7_1, arg_7_2)
					if arg_7_2 and arg_7_2:total_remaining_ammo() <= 0 then
						return false
					end

					return true
				end
			}
		},
		weapon_reload = {
			default = {
				weapon_action_hand = "either",
				kind = "reload",
				total_time = 0,
				condition_func = function (arg_8_0, arg_8_1)
					local var_8_0 = ScriptUnit.extension(arg_8_0, "inventory_system")
					local var_8_1 = ScriptUnit.extension(arg_8_0, "status_system")
					local var_8_2

					if var_8_1:is_zooming() then
						return false
					end

					local var_8_3 = var_8_0:equipment()

					if var_8_3.right_hand_wielded_unit ~= nil and ScriptUnit.has_extension(var_8_3.right_hand_wielded_unit, "ammo_system") then
						var_8_2 = ScriptUnit.extension(var_8_3.right_hand_wielded_unit, "ammo_system")
					elseif var_8_3.left_hand_wielded_unit ~= nil and ScriptUnit.has_extension(var_8_3.left_hand_wielded_unit, "ammo_system") then
						var_8_2 = ScriptUnit.extension(var_8_3.left_hand_wielded_unit, "ammo_system")
					end

					return var_8_2 and var_8_2:can_reload()
				end,
				chain_condition_func = function (arg_9_0, arg_9_1)
					local var_9_0 = ScriptUnit.extension(arg_9_0, "inventory_system")
					local var_9_1 = ScriptUnit.extension(arg_9_0, "status_system")
					local var_9_2

					if var_9_1:is_zooming() then
						return false
					end

					local var_9_3 = var_9_0:equipment()

					if var_9_3.right_hand_wielded_unit ~= nil and ScriptUnit.has_extension(var_9_3.right_hand_wielded_unit, "ammo_system") then
						var_9_2 = ScriptUnit.extension(var_9_3.right_hand_wielded_unit, "ammo_system")
					elseif var_9_3.left_hand_wielded_unit ~= nil and ScriptUnit.has_extension(var_9_3.left_hand_wielded_unit, "ammo_system") then
						var_9_2 = ScriptUnit.extension(var_9_3.left_hand_wielded_unit, "ammo_system")
					end

					return var_9_2 and var_9_2:can_reload()
				end,
				allowed_chain_actions = {}
			},
			auto_reload = {
				weapon_action_hand = "either",
				kind = "reload",
				total_time = 0,
				condition_func = function (arg_10_0, arg_10_1)
					local var_10_0 = ScriptUnit.extension(arg_10_0, "inventory_system")
					local var_10_1 = ScriptUnit.extension(arg_10_0, "status_system")
					local var_10_2

					if var_10_1:is_zooming() then
						return false
					end

					local var_10_3 = var_10_0:equipment()

					if var_10_3.right_hand_wielded_unit ~= nil and ScriptUnit.has_extension(var_10_3.right_hand_wielded_unit, "ammo_system") then
						var_10_2 = ScriptUnit.extension(var_10_3.right_hand_wielded_unit, "ammo_system")
					elseif var_10_3.left_hand_wielded_unit ~= nil and ScriptUnit.has_extension(var_10_3.left_hand_wielded_unit, "ammo_system") then
						var_10_2 = ScriptUnit.extension(var_10_3.left_hand_wielded_unit, "ammo_system")
					end

					return var_10_2 and var_10_2:ammo_count() == 0 and var_10_2:can_reload()
				end,
				chain_condition_func = function (arg_11_0, arg_11_1)
					local var_11_0 = ScriptUnit.extension(arg_11_0, "inventory_system")
					local var_11_1 = ScriptUnit.extension(arg_11_0, "status_system")
					local var_11_2

					if var_11_1:is_zooming() then
						return false
					end

					local var_11_3 = var_11_0:equipment()

					if var_11_3.right_hand_wielded_unit ~= nil and ScriptUnit.has_extension(var_11_3.right_hand_wielded_unit, "ammo_system") then
						var_11_2 = ScriptUnit.extension(var_11_3.right_hand_wielded_unit, "ammo_system")
					elseif var_11_3.left_hand_wielded_unit ~= nil and ScriptUnit.has_extension(var_11_3.left_hand_wielded_unit, "ammo_system") then
						var_11_2 = ScriptUnit.extension(var_11_3.left_hand_wielded_unit, "ammo_system")
					end

					return var_11_2 and var_11_2:ammo_count() == 0 and var_11_2:can_reload()
				end,
				allowed_chain_actions = {}
			}
		},
		action_inspect = ActionTemplates.action_inspect,
		action_wield = ActionTemplates.wield
	},
	action_on_wield = {
		action = "weapon_reload",
		sub_action = "default"
	},
	ammo_data = {
		ammo_hand = "right",
		ammo_per_reload = 2,
		max_ammo = 30,
		ammo_per_clip = 12,
		reload_on_ammo_pickup = true,
		reload_time = 1,
		play_reload_anim_on_wield_reload = true
	},
	attack_meta_data = {
		aim_at_node = "j_head",
		can_charge_shot = false,
		effective_against = bit.bor(BreedCategory.Berserker, BreedCategory.Special, BreedCategory.Armored)
	}
}

var_0_0.default_spread_template = "brace_of_pistols"
var_0_0.spread_lerp_speed = 5
var_0_0.right_hand_unit = ""
var_0_0.right_hand_attachment_node_linking = AttachmentNodeLinking.pistol.right
var_0_0.left_hand_unit = ""
var_0_0.left_hand_attachment_node_linking = AttachmentNodeLinking.pistol.left
var_0_0.display_unit = "units/weapons/weapon_display/display_pistols"
var_0_0.wield_anim = "to_dual_pistol"
var_0_0.state_machine = "units/beings/player/first_person_base/state_machines/ranged/dual_pistol"
var_0_0.reload_event = "reload"
var_0_0.crosshair_style = "default"
var_0_0.gui_texture = "hud_weapon_icon_repeating_handgun"
var_0_0.buff_type = "RANGED"
var_0_0.weapon_type = "BRACE_OF_PISTOLS"
var_0_0.dodge_count = 100
var_0_0.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1.25
	},
	change_dodge_speed = {
		external_optional_multiplier = 1.25
	}
}
var_0_0.aim_assist_settings = {
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
var_0_0.wwise_dep_right_hand = {
	"wwise/pistol"
}
var_0_0.wwise_dep_left_hand = {
	"wwise/pistol"
}
var_0_0.weapon_diagram = {
	light_attack = {
		[DamageTypes.ARMOR_PIERCING] = 5,
		[DamageTypes.CLEAVE] = 2,
		[DamageTypes.SPEED] = 4,
		[DamageTypes.STAGGER] = 2,
		[DamageTypes.DAMAGE] = 5
	},
	heavy_attack = {
		[DamageTypes.ARMOR_PIERCING] = 5,
		[DamageTypes.CLEAVE] = 1,
		[DamageTypes.SPEED] = 6,
		[DamageTypes.STAGGER] = 2,
		[DamageTypes.DAMAGE] = 6
	}
}
var_0_0.tooltip_keywords = {
	"weapon_keyword_high_damage",
	"weapon_keyword_rapid_fire",
	"weapon_keyword_versatile"
}
var_0_0.tooltip_compare = {
	light = {
		action_name = "action_one",
		sub_action_name = "default"
	},
	heavy = {
		action_name = "action_one",
		sub_action_name = "fast_shot"
	}
}
var_0_0.tooltip_detail = {
	light = {
		action_name = "action_one",
		sub_action_name = "default"
	},
	heavy = {
		action_name = "action_one",
		sub_action_name = "fast_shot"
	}
}
var_0_0.tooltip_special_action_description = "special_action_brace_of_pistols"

return {
	brace_of_pistols_template_1 = table.clone(var_0_0)
}
