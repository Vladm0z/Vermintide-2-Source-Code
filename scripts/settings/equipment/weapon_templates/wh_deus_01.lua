-- chunkname: @scripts/settings/equipment/weapon_templates/wh_deus_01.lua

local tbl = {
	{
		yaw = -8,
		pitch = 0,
		shot_count = 3
	},
	{
		yaw = -4,
		pitch = 0,
		shot_count = 3
	},
	{
		yaw = 0,
		pitch = 0,
		shot_count = 6
	},
	{
		yaw = 4,
		pitch = 0,
		shot_count = 3
	},
	{
		yaw = 8,
		pitch = 0,
		shot_count = 3
	}
}
local tbl_2 = {
	actions = {
		action_one = {
			default = {
				total_time_secondary = 2,
				reload_when_out_of_ammo = true,
				kind = "multi_shoot",
				charge_value = "bullet_hit",
				num_layers_spread = 12,
				alert_sound_range_fire = 12,
				alert_sound_range_hit = 2,
				apply_recoil = true,
				damage_profile = "shot_duckfoot",
				hit_effect = "bullet_impact",
				bullseye = false,
				headshot_multiplier = 2,
				aim_assist_max_ramp_multiplier = 0.3,
				range = 100,
				ammo_usage = 1,
				fire_time = 0,
				aim_assist_auto_hit_chance = 0.5,
				aim_assist_ramp_decay_delay = 0.2,
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
						input = "action_two"
					},
					{
						sub_action = "default",
						start_time = 0.75,
						action = "weapon_reload",
						input = "weapon_reload"
					},
					{
						sub_action = "auto_reload",
						start_time = 0.8,
						action = "weapon_reload",
						auto_chain = true
					}
				},
				enter_function = function (arg_1_0, arg_1_1)
					-- function 1
					arg_1_1:clear_input_buffer()

					return arg_1_1:reset_release_input()
				end,
				barrels = tbl,
				hit_mass_count = LINESMAN_HIT_MASS_COUNT,
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
				damage_window_start = 0.2,
				forward_offset = 0.75,
				anim_end_event = "attack_finished",
				anim_time_scale = 1.25,
				kind = "shield_slam",
				damage_profile_target = "shield_slam_shotgun",
				reload_when_out_of_ammo = true,
				no_damage_impact_sound_event = "blunt_hit_armour",
				damage_profile = "shield_slam_shotgun",
				push_radius = 2.5,
				hit_time = 0.25,
				hit_effect = "melee_hit_slashing",
				push_dot = 0.75,
				damage_window_end = 0.3,
				impact_sound_event = "blunt_hit",
				charge_value = "heavy_attack",
				damage_profile_aoe = "shield_slam_shotgun_aoe",
				dedicated_target_range = 3.5,
				anim_event = "attack_push",
				total_time = 1,
				anim_end_event_condition_func = function (arg_2_0, arg_2_1)
					-- function 2
					return arg_2_1 == "new_interupting_action" or arg_2_1 ~= "action_complete"
				end,
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.3,
						action = "action_one",
						input = "action_one"
					},
					{
						sub_action = "default",
						start_time = 2,
						action = "action_two",
						input = "action_two"
					},
					{
						sub_action = "default",
						start_time = 0.5,
						action = "weapon_reload",
						input = "weapon_reload"
					},
					{
						sub_action = "default",
						start_time = 0.4,
						action = "action_wield",
						input = "action_wield"
					},
					{
						sub_action = "auto_reload",
						start_time = 0.8,
						action = "weapon_reload",
						auto_chain = true
					}
				},
				enter_function = function (arg_3_0, arg_3_1)
					-- function 3
					arg_3_1:clear_input_buffer()
				end
			}
		},
		weapon_reload = {
			default = {
				weapon_action_hand = "either",
				kind = "reload",
				total_time = 0,
				condition_func = function (arg_4_0, arg_4_1)
					-- function 4
					local extension = ScriptUnit.extension(arg_4_0, "inventory_system")
					local extension_2 = ScriptUnit.extension(arg_4_0, "status_system")
					local var_4_2

					if not extension_2:is_zooming() then
						return false
					end

					local equipment = extension:equipment()

					if equipment.right_hand_wielded_unit == nil or not ScriptUnit.has_extension(equipment.right_hand_wielded_unit, "ammo_system") then
						var_4_2 = ScriptUnit.extension(equipment.right_hand_wielded_unit, "ammo_system")
					elseif equipment.left_hand_wielded_unit == nil or not ScriptUnit.has_extension(equipment.left_hand_wielded_unit, "ammo_system") then
						var_4_2 = ScriptUnit.extension(equipment.left_hand_wielded_unit, "ammo_system")
					end

					return not var_4_2 and var_4_2:can_reload()
				end,
				chain_condition_func = function (arg_5_0, arg_5_1)
					-- function 5
					local extension = ScriptUnit.extension(arg_5_0, "inventory_system")
					local extension_2 = ScriptUnit.extension(arg_5_0, "status_system")
					local var_5_2

					if not extension_2:is_zooming() then
						return false
					end

					local equipment = extension:equipment()

					if equipment.right_hand_wielded_unit == nil or not ScriptUnit.has_extension(equipment.right_hand_wielded_unit, "ammo_system") then
						var_5_2 = ScriptUnit.extension(equipment.right_hand_wielded_unit, "ammo_system")
					elseif equipment.left_hand_wielded_unit == nil or not ScriptUnit.has_extension(equipment.left_hand_wielded_unit, "ammo_system") then
						var_5_2 = ScriptUnit.extension(equipment.left_hand_wielded_unit, "ammo_system")
					end

					return not var_5_2 and var_5_2:can_reload()
				end,
				allowed_chain_actions = {}
			},
			auto_reload = {
				weapon_action_hand = "either",
				kind = "reload",
				total_time = 0,
				condition_func = function (arg_6_0, arg_6_1)
					-- function 6
					local extension = ScriptUnit.extension(arg_6_0, "inventory_system")
					local extension_2 = ScriptUnit.extension(arg_6_0, "status_system")
					local var_6_2

					if not extension_2:is_zooming() then
						return false
					end

					local equipment = extension:equipment()

					if equipment.right_hand_wielded_unit == nil or not ScriptUnit.has_extension(equipment.right_hand_wielded_unit, "ammo_system") then
						var_6_2 = ScriptUnit.extension(equipment.right_hand_wielded_unit, "ammo_system")
					elseif equipment.left_hand_wielded_unit == nil or not ScriptUnit.has_extension(equipment.left_hand_wielded_unit, "ammo_system") then
						var_6_2 = ScriptUnit.extension(equipment.left_hand_wielded_unit, "ammo_system")
					end

					return not var_6_2 and var_6_2:ammo_count() ~= 0 or var_6_2:can_reload()
				end,
				chain_condition_func = function (arg_7_0, arg_7_1)
					-- function 7
					local extension = ScriptUnit.extension(arg_7_0, "inventory_system")
					local extension_2 = ScriptUnit.extension(arg_7_0, "status_system")
					local var_7_2

					if not extension_2:is_zooming() then
						return false
					end

					local equipment = extension:equipment()

					if equipment.right_hand_wielded_unit == nil or not ScriptUnit.has_extension(equipment.right_hand_wielded_unit, "ammo_system") then
						var_7_2 = ScriptUnit.extension(equipment.right_hand_wielded_unit, "ammo_system")
					elseif equipment.left_hand_wielded_unit == nil or not ScriptUnit.has_extension(equipment.left_hand_wielded_unit, "ammo_system") then
						var_7_2 = ScriptUnit.extension(equipment.left_hand_wielded_unit, "ammo_system")
					end

					return not var_7_2 and var_7_2:ammo_count() ~= 0 or var_7_2:can_reload()
				end,
				allowed_chain_actions = {}
			}
		},
		action_inspect = ActionTemplates.action_inspect,
		action_wield = ActionTemplates.wield,
		action_instant_grenade_throw = ActionTemplates.instant_equip_grenade,
		action_instant_heal_self = ActionTemplates.instant_equip_and_heal_self,
		action_instant_heal_other = ActionTemplates.instant_equip_and_heal_other,
		action_instant_drink_potion = ActionTemplates.instant_equip_and_drink_potion,
		action_instant_equip_tome = ActionTemplates.instant_equip_tome,
		action_instant_equip_grimoire = ActionTemplates.instant_equip_grimoire,
		action_instant_equip_grenade = ActionTemplates.instant_equip_grenade_only,
		action_instant_equip_healing_draught = ActionTemplates.instant_equip_and_drink_healing_draught
	},
	action_on_wield = {
		action = "weapon_reload",
		sub_action = "default"
	},
	ammo_data = {
		ammo_hand = "right",
		ammo_per_reload = 2,
		max_ammo = 26,
		ammo_per_clip = 8,
		reload_on_ammo_pickup = true,
		reload_time = 1,
		play_reload_anim_on_wield_reload = true
	},
	attack_meta_data = {
		max_range = 10,
		aim_at_node = "j_spine",
		can_charge_shot = false,
		ignore_enemies_for_obstruction = true,
		effective_against = bit.bor(BreedCategory.Berserker, BreedCategory.Special, BreedCategory.Armored)
	}
}

tbl_2.default_spread_template = "wh_deus_01"
tbl_2.spread_lerp_speed = 5
tbl_2.right_hand_unit = "units/weapons/player/wpn_wh_deus_01/wpn_wh_deus_01"
tbl_2.right_hand_attachment_node_linking = AttachmentNodeLinking.pistol.right
tbl_2.left_hand_unit = "units/weapons/player/wpn_wh_deus_01/wpn_wh_deus_01"
tbl_2.left_hand_attachment_node_linking = AttachmentNodeLinking.pistol.left
tbl_2.display_unit = "units/weapons/weapon_display/display_pistols"
tbl_2.wield_anim = "to_wh_deus_01"
tbl_2.state_machine = "units/beings/player/first_person_base/state_machines/ranged/wh_deus_01"
tbl_2.reload_event = "reload"
tbl_2.crosshair_style = "default"
tbl_2.gui_texture = "hud_weapon_icon_repeating_handgun"
tbl_2.buff_type = "RANGED"
tbl_2.weapon_type = "wh_deus_01"
tbl_2.dodge_count = 100
tbl_2.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1.25
	},
	change_dodge_speed = {
		external_optional_multiplier = 1.25
	},
	wh_deus_01_victor_witchhunter_bleed_on_critical_hit_disable = {}
}
tbl_2.aim_assist_settings = {
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
tbl_2.wwise_dep_right_hand = {
	"wwise/wh_deus_01"
}
tbl_2.wwise_dep_left_hand = {
	"wwise/wh_deus_01"
}
tbl_2.weapon_diagram = {
	light_attack = {
		[DamageTypes.ARMOR_PIERCING] = 4,
		[DamageTypes.CLEAVE] = 7,
		[DamageTypes.SPEED] = 4,
		[DamageTypes.STAGGER] = 1,
		[DamageTypes.DAMAGE] = 4
	},
	heavy_attack = {
		[DamageTypes.ARMOR_PIERCING] = 0,
		[DamageTypes.CLEAVE] = 7,
		[DamageTypes.SPEED] = 3,
		[DamageTypes.STAGGER] = 1,
		[DamageTypes.DAMAGE] = 1
	}
}
tbl_2.tooltip_keywords = {
	"weapon_keyword_high_damage",
	"weapon_keyword_rapid_fire",
	"weapon_keyword_versatile"
}
tbl_2.tooltip_compare = {
	light = {
		action_name = "action_one",
		sub_action_name = "default"
	},
	heavy = {
		action_name = "action_one",
		sub_action_name = "fast_shot"
	}
}
tbl_2.tooltip_detail = {
	light = {
		action_name = "action_one",
		sub_action_name = "default"
	},
	heavy = {
		action_name = "action_one",
		sub_action_name = "fast_shot"
	}
}

return {
	wh_deus_01_template_1 = table.clone(tbl_2)
}
