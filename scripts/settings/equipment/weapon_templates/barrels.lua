-- chunkname: @scripts/settings/equipment/weapon_templates/barrels.lua

local num = 2
local tbl = {
	actions = {
		action_one = {
			default = {
				alert_sound_range_hit = 10,
				anim_end_event = "attack_finished",
				kind = "throw",
				velocity_multiplier = 1,
				throw_time = 0.35,
				ammo_usage = 1,
				weapon_action_hand = "left",
				block_pickup = true,
				speed = 5,
				uninterruptible = true,
				anim_event = "attack_throw",
				total_time = 0.7,
				anim_end_event_condition_func = function (arg_1_0, arg_1_1)
					-- function 1
					return arg_1_1 == "new_interupting_action" or arg_1_1 ~= "action_complete"
				end,
				allowed_chain_actions = {},
				angular_velocity = {
					0,
					-5,
					0
				},
				throw_offset = {
					0.25,
					1.2,
					0
				},
				projectile_info = {
					projectile_unit_template_name = "explosive_pickup_projectile_unit",
					pickup_name = "explosive_barrel",
					drop_on_player_destroyed = true,
					projectile_unit_name = "units/weapons/player/pup_explosive_barrel/pup_explosive_barrel_01"
				}
			}
		},
		action_two = {
			default = {
				damage_window_start = 0.05,
				anim_end_event = "attack_finished",
				outer_push_angle = 180,
				kind = "push_stagger",
				attack_template = "basic_sweep_push",
				damage_profile_outer = "light_push",
				push_angle = 100,
				hit_effect = "melee_hit_slashing",
				damage_window_end = 0.2,
				charge_value = "action_push",
				weapon_action_hand = "left",
				anim_event = "attack_push",
				damage_profile_inner = "medium_push",
				total_time = 0.8,
				anim_end_event_condition_func = function (arg_2_0, arg_2_1)
					-- function 2
					return arg_2_1 == "new_interupting_action" or arg_2_1 ~= "action_complete"
				end,
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.4,
						action = "action_one",
						end_time = 0.7,
						input = "action_one"
					}
				},
				push_radius = num,
				condition_func = function (arg_3_0, arg_3_1)
					-- function 3
					return not ScriptUnit.extension(arg_3_0, "status_system"):fatigued()
				end
			}
		},
		action_dropped = {
			default = {
				alert_sound_range_hit = 10,
				anim_end_event = "attack_finished",
				kind = "throw",
				velocity_multiplier = 1,
				throw_time = 0.35,
				ammo_usage = 1,
				weapon_action_hand = "left",
				block_pickup = true,
				speed = 5,
				uninterruptible = true,
				anim_event = "attack_throw",
				total_time = 0.7,
				anim_end_event_condition_func = function (arg_4_0, arg_4_1)
					-- function 4
					return arg_4_1 == "new_interupting_action" or arg_4_1 ~= "action_complete"
				end,
				allowed_chain_actions = {},
				angular_velocity = {
					0,
					-5,
					0
				},
				throw_offset = {
					0.25,
					1.2,
					0
				},
				projectile_info = {
					projectile_unit_template_name = "explosive_pickup_projectile_unit",
					pickup_name = "explosive_barrel",
					drop_on_player_destroyed = true,
					projectile_unit_name = "units/weapons/player/pup_explosive_barrel/pup_explosive_barrel_01"
				}
			}
		},
		action_wield = ActionTemplates.wield_left
	},
	ammo_data = {
		ammo_hand = "left",
		destroy_when_out_of_ammo = true,
		max_ammo = 1,
		ammo_per_clip = 1,
		reload_time = 0
	}
}

tbl.left_hand_unit = "units/weapons/player/wpn_explosive_barrel/wpn_explosive_barrel_01"
tbl.left_hand_attachment_node_linking = AttachmentNodeLinking.barrel
tbl.wield_anim = "to_barrel"
tbl.state_machine = "units/beings/player/first_person_base/state_machines/common"
tbl.load_state_machine = false
tbl.block_wielding = true
tbl.max_fatigue_points = 3
tbl.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1
	},
	change_dodge_speed = {
		external_optional_multiplier = 1
	}
}

local clone = table.clone(tbl)

clone.left_hand_unit = "units/weapons/player/wpn_explosive_barrel/wpn_explosive_barrel_01"

local clone_2 = table.clone(clone)

clone_2.left_hand_unit = "units/weapons/player/wpn_explosive_barrel/wpn_gun_powder_barrel_01"
clone_2.actions.action_one.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit",
	pickup_name = "explosive_barrel_objective",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_explosive_barrel/pup_gun_powder_barrel_01"
}

local clone_3 = table.clone(clone_2)

clone_3.left_hand_unit = "units/weapons/player/pup_magic_barrel/wpn_magic_barrel_01"
clone_3.actions.action_one.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit",
	pickup_name = "magic_barrel",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_magic_barrel/pup_magic_barrel_01"
}
clone_3.actions.action_dropped.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit",
	pickup_name = "magic_barrel",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_magic_barrel/pup_magic_barrel_01"
}

local clone_4 = table.clone(clone_2)

clone_4.left_hand_unit = "units/weapons/player/pup_wizards_barrel_01/wpn_wizards_barrel_01"
clone_4.actions.action_one.default.projectile_info = {
	projectile_unit_template_name = "explosive_pickup_projectile_unit_limited",
	pickup_name = "wizards_barrel",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_wizards_barrel_01/pup_wizards_barrel_01"
}
clone_4.actions.action_dropped.default.projectile_info = {
	projectile_unit_template_name = "explosive_pickup_projectile_unit_limited",
	pickup_name = "wizards_barrel",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_wizards_barrel_01/pup_wizards_barrel_01"
}

local clone_5 = table.clone(tbl)

clone_5.left_hand_unit = "units/weapons/player/wpn_oil_jug_01/wpn_oil_jug_01"
clone_5.actions.action_one.default.projectile_info = {
	projectile_unit_template_name = "explosive_pickup_projectile_unit",
	pickup_name = "lamp_oil",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_oil_jug_01/pup_oil_jug_01"
}
clone_5.actions.action_dropped.default.projectile_info = {
	projectile_unit_template_name = "explosive_pickup_projectile_unit",
	pickup_name = "lamp_oil",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_oil_jug_01/pup_oil_jug_01"
}

local clone_6 = table.clone(tbl)

clone_6.left_hand_unit = "units/weapons/player/wpn_explosive_barrel/wpn_explosive_barrel_01"
clone_6.actions.action_one.default.speed = 8
clone_6.actions.action_one.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit",
	pickup_name = "beer_barrel",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_explosive_barrel/pup_explosive_barrel_01"
}
clone_6.actions.action_dropped.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit",
	pickup_name = "beer_barrel",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_explosive_barrel/pup_explosive_barrel_01"
}

local clone_7 = table.clone(tbl)

clone_7.left_hand_unit = "units/weapons/player/pup_whale_oil_barrel/wpn_whale_oil_barrel_01"
clone_7.actions.action_one.default.projectile_info = {
	projectile_unit_template_name = "explosive_pickup_projectile_unit",
	pickup_name = "whale_oil_barrel",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_whale_oil_barrel/pup_whale_oil_barrel_01"
}
clone_7.actions.action_dropped.default.projectile_info = {
	projectile_unit_template_name = "explosive_pickup_projectile_unit",
	pickup_name = "whale_oil_barrel",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_whale_oil_barrel/pup_whale_oil_barrel_01"
}

local clone_8 = table.clone(tbl)

clone_8.left_hand_unit = "units/weapons/player/wpn_dwarf_barrel_01/wpn_dwarf_barrel_01"
clone_8.actions.action_one.default.projectile_info = {
	projectile_unit_template_name = "explosive_pickup_projectile_unit",
	pickup_name = "dwarf_explosive_barrel",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_dwarf_barrel_01/pup_dwarf_barrel_01"
}
clone_8.actions.action_dropped.default.projectile_info = {
	projectile_unit_template_name = "explosive_pickup_projectile_unit",
	pickup_name = "dwarf_explosive_barrel",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_dwarf_barrel_01/pup_dwarf_barrel_01"
}

local clone_9 = table.clone(tbl)

clone_9.left_hand_unit = "units/weapons/player/wpn_dwarf_barrel_02/wpn_dwarf_barrel_02"
clone_9.actions.action_one.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit",
	pickup_name = "dwarf_beer_barrel",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_dwarf_barrel_02/pup_dwarf_barrel_02"
}
clone_9.actions.action_dropped.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit",
	pickup_name = "dwarf_beer_barrel",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_dwarf_barrel_02/pup_dwarf_barrel_02"
}

return {
	explosive_barrel = clone,
	explosive_barrel_objective = clone_2,
	lamp_oil = clone_5,
	beer_barrel = clone_6,
	magic_barrel = clone_3,
	wizards_barrel = clone_4,
	whale_oil_barrel = clone_7,
	dwarf_explosive_barrel = clone_8,
	dwarf_beer_barrel = clone_9
}
