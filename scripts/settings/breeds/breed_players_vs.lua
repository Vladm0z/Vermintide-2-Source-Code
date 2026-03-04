-- chunkname: @scripts/settings/breeds/breed_players_vs.lua

require("scripts/settings/breeds")

local var_0_0 = table.clone(Breeds.skaven_gutter_runner)

var_0_0.animation_sync_rpc = "rpc_sync_anim_state_5"
var_0_0.cannot_be_aggroed = true
var_0_0.parent_breed_name = "skaven_gutter_runner"
var_0_0.poison_resistance = 100
var_0_0.starting_animation = "to_gutter_runner"
var_0_0.climb_type = "climb"
var_0_0.keep_weapon_on_death = true
var_0_0.movement_speed_multiplier = 1.25
var_0_0.run_threshold = 4
var_0_0.pounce_prime_time = 1
var_0_0.breed_move_acceleration_up = 8
var_0_0.breed_move_acceleration_down = 8
var_0_0.pounce_speed = 25
var_0_0.pounce_upwards_amount = 0.15
var_0_0.pounce_start_forward_offset = 0.3
var_0_0.pounce_start_up_offset = 0.3
var_0_0.pounce_gravity = 10
var_0_0.pounce_look_sense = 0.8
var_0_0.pounce_hit_radius = 1.1
var_0_0.pounce_max_damage_time = 3
var_0_0.min_pounce_damage = 10
var_0_0.max_pounce_damage = 24
var_0_0.foff_enter_anim_time = 0.32
var_0_0.time_before_ramping_damage = 1.5
var_0_0.time_to_reach_max_damage = 3
var_0_0.base_damage = 2.5
var_0_0.final_damage_multiplier = 4
var_0_0.max_stagger_duration = 0.4
var_0_0.stagger_resistance = 2
var_0_0.stagger_resistance_ranged = 6
var_0_0.stagger_threshold_light = 1
var_0_0.stagger_threshold_medium = 2
var_0_0.stagger_threshold_heavy = 2.5
var_0_0.stagger_threshold_explosion = 3
var_0_0.z_onscreen_damage_offset = 1
var_0_0.damage_numbers_font_override = 10
var_0_0.default_gear = {
	slot_frame = "frame_0000",
	slot_melee = "vs_gutter_runner_claws",
	slot_skin = "skaven_gutter_runner_skin_0000"
}

local var_0_1 = table.clone(Breeds.skaven_pack_master)

var_0_1.animation_sync_rpc = "rpc_sync_anim_state_7"
var_0_1.cannot_be_aggroed = true
var_0_1.parent_breed_name = "skaven_pack_master"
var_0_1.dragging_hit_zone_name = "full"
var_0_1.dragging_damage_type = "cutting"
var_0_1.starting_animation = "to_packmaster"
var_0_1.climb_type = "climb"
var_0_1.poison_resistance = 100
var_0_1.keep_weapon_on_death = false
var_0_1.custom_husk_max_pitch = math.huge
var_0_1.movement_speed_multiplier = 1.3
var_0_1.run_threshold = 4
var_0_1.strafe_speed_multiplier = 0.5
var_0_1.breed_move_acceleration_up = 8
var_0_1.breed_move_acceleration_down = 8
var_0_1.grab_movement_speed_multiplier_initial = 0.875
var_0_1.grab_movement_speed_multiplier_target = 0.25
var_0_1.grab_hook_range = 4.5
var_0_1.grab_hook_cone_dot = 0.9
var_0_1.grab_anim_time = 0.55
var_0_1.grab_grace_period = {
	before = 0.2,
	after = 0.5
}
var_0_1.grab_look_sense = 1
var_0_1.initial_drag_movement_speed = 6
var_0_1.initial_drag_movement_speed_duration = 1.5
var_0_1.drag_movement_speed = 3
var_0_1.equip_hook_weapon_spawn_time = 0.3333333333333333
var_0_1.equip_hook_exit_state_time = 0.6666666666666666
var_0_1.dragging_time_to_damage = 1
var_0_1.dragging_damage_amount = 6
var_0_0.max_stagger_duration = 0.4
var_0_1.stagger_resistance = 100
var_0_1.stagger_resistance_ranged = 100
var_0_1.stagger_threshold_light = 1
var_0_1.stagger_threshold_medium = 2
var_0_1.stagger_threshold_heavy = 2.5
var_0_1.stagger_threshold_explosion = 3
var_0_1.default_gear = {
	slot_frame = "frame_0000",
	slot_melee = "vs_packmaster_claw",
	slot_skin = "skaven_pack_master_skin_0000"
}

local var_0_2 = table.clone(Breeds.skaven_poison_wind_globadier)

var_0_2.animation_sync_rpc = "rpc_sync_anim_state_5"
var_0_2.cannot_be_aggroed = true
var_0_2.parent_breed_name = "skaven_poison_wind_globadier"
var_0_2.poison_resistance = 100
var_0_2.keep_weapon_on_death = true
var_0_2.starting_animation = "to_globadier"
var_0_2.climb_type = "climb"
var_0_2.movement_speed_multiplier = 1
var_0_2.wind_up_movement_speed = 2
var_0_2.run_threshold = 5
var_0_2.globe_throw_prime_time = 0.65
var_0_2.breed_move_acceleration_up = 8
var_0_2.breed_move_acceleration_down = 8
var_0_2.globe_throw_spawn_globe_time = 0.14
var_0_2.globe_throw_finish_time = 0.5
var_0_2.globe_throw_speed = 1600
var_0_2.globe_throw_look_sense = 1
var_0_2.globe_throw_aoe_radius = 5
var_0_2.globe_throw_initial_radius = 5
var_0_2.globe_throw_aoe_life_time = 6
var_0_2.globe_throw_upwards_amount = 0.2
var_0_2.globe_throw_impact_difficulty_damage = {
	1,
	1,
	1,
	1,
	1
}
var_0_2.globe_throw_dot_difficulty_damage = {
	8,
	8,
	8,
	8,
	8
}
var_0_2.globe_throw_dot_damage_interval = 1
var_0_0.max_stagger_duration = 0.4
var_0_2.stagger_resistance = 100
var_0_2.stagger_resistance_ranged = 500
var_0_2.stagger_threshold_light = 1
var_0_2.stagger_threshold_medium = 2
var_0_2.stagger_threshold_heavy = 2.5
var_0_2.stagger_threshold_explosion = 3
var_0_2.default_gear = {
	slot_frame = "frame_0000",
	slot_melee = "vs_poison_wind_globadier_orb",
	slot_skin = "skaven_wind_globadier_skin_0000"
}

local var_0_3 = table.clone(Breeds.skaven_ratling_gunner)

var_0_3.animation_sync_rpc = "rpc_sync_anim_state_6"
var_0_3.base_unit = "units/beings/player/dark_pact_third_person_base/skaven_ratlinggunner"
var_0_3.cannot_be_aggroed = true
var_0_3.parent_breed_name = "skaven_ratling_gunner"
var_0_3.poison_resistance = 100
var_0_3.keep_weapon_on_death = false
var_0_3.starting_animation = "to_ratling_gunner"
var_0_3.climb_type = "climb"
var_0_3.death_sound_event = "Play_player_ratling_gunner_dead"
var_0_3.radius = 1
var_0_3.aoe_height = 1.5
var_0_3.size_variation_range = {
	1.1,
	1.1
}
var_0_3.player_locomotion_constrain_radius = 0.7
var_0_3.weapon_reach = 2
var_0_3.smart_targeting_width = 0.3
var_0_3.smart_targeting_height_multiplier = 2.1
var_0_3.smart_targeting_outer_width = 0.7
var_0_3.aim_constraint_forward_multiplier = 30
var_0_3.custom_husk_max_pitch = math.huge
var_0_3.movement_speed_multiplier = 0.875
var_0_3.run_threshold = 2.5
var_0_3.breed_move_acceleration_up = 8
var_0_3.breed_move_acceleration_down = 8
var_0_3.shoot_ratlinggun_pose_weapon_time = 1.8
var_0_3.reloading_max_time = 1
var_0_3.reloading_movement_speed = 3
var_0_3.shoot_ratlinggun_minimum_forced_cooldown = 0.01
var_0_3.shoot_ratlinggun_max_firing_time = 100
var_0_3.max_ammo = 120
var_0_3.armor_category = 1
var_0_0.max_stagger_duration = 0.4
var_0_3.diff_stagger_resist = nil
var_0_3.stagger_resistance = 2.5
var_0_3.stagger_resistance_ranged = 9
var_0_3.stagger_threshold_light = 1
var_0_3.stagger_threshold_medium = 2
var_0_3.stagger_threshold_heavy = 3
var_0_3.stagger_threshold_explosion = 4
var_0_3.default_gear = {
	slot_frame = "frame_0000",
	slot_melee = "vs_ratling_gunner_gun",
	slot_skin = "skaven_ratling_gunner_skin_0000"
}
var_0_3.track_projectile_blocked_vo = true

local var_0_4 = table.clone(Breeds.skaven_warpfire_thrower)

var_0_4.animation_sync_rpc = "rpc_sync_anim_state_6"
var_0_4.cannot_be_aggroed = true
var_0_4.parent_breed_name = "skaven_warpfire_thrower"
var_0_4.poison_resistance = 100
var_0_4.keep_weapon_on_death = false
var_0_4.starting_animation = "to_warpfire_thrower"
var_0_4.climb_type = "climb"
var_0_4.movement_speed_multiplier = 0.875
var_0_4.breed_move_acceleration_up = 8
var_0_4.breed_move_acceleration_down = 8
var_0_4.run_threshold = 4
var_0_4.shoot_warpfire_prime_time = 0.2
var_0_4.shoot_warpfire_wind_up_movement_speed = {
	finish = 1,
	start = 3,
	rate = 1
}
var_0_4.shoot_warpfire_movement_speed_mod = 2
var_0_4.custom_husk_max_pitch = math.huge
var_0_4.shoot_warpfire_max_flame_time = 5
var_0_4.shoot_warpfire_attack_range = 10
var_0_4.shoot_warpfire_close_attack_range = 7
var_0_4.shoot_warpfire_close_attack_cooldown = 0.2
var_0_4.shoot_warpfire_close_attack_hit_radius = 1.5
var_0_4.shoot_warpfire_close_attack_dot = 0.9
var_0_4.shoot_warpfire_minimum_forced_cooldown = 0.6
var_0_4.warpfire_vfx = "chr_warp_fire_flamethrower_01_1p_versus"
var_0_4.shoot_warpfire_long_attack_damage = {
	2,
	2,
	2,
	2,
	2,
	2
}
var_0_4.armor_category = 1
var_0_0.max_stagger_duration = 0.4
var_0_4.diff_stagger_resist = nil
var_0_4.stagger_resistance = 5
var_0_4.stagger_resistance_ranged = 8
var_0_4.stagger_threshold_light = 1
var_0_4.stagger_threshold_medium = 2
var_0_4.stagger_threshold_heavy = 3
var_0_4.stagger_threshold_explosion = 4
var_0_4.default_gear = {
	slot_frame = "frame_0000",
	slot_melee = "vs_warpfire_thrower_gun",
	slot_skin = "skaven_warpfire_thrower_skin_0000"
}

local var_0_5 = table.clone(Breeds.chaos_troll)

var_0_5.animation_sync_rpc = "rpc_sync_anim_state_6"
var_0_5.cannot_be_aggroed = true
var_0_5.parent_breed_name = "chaos_troll"
var_0_5.poison_resistance = 100
var_0_5.starting_animation = "to_1h_axe"
var_0_5.climb_type = "climb"
var_0_5.keep_weapon_on_death = true
var_0_5.max_vomit_distance = 7
var_0_5.vomit_in_face_sweep_radius = 3
var_0_5.vomit_movement_speed = 2
var_0_5.look_sense_override = 0.33
var_0_5.vomit_upwards_amount = 0.2
var_0_5.vomit_projectile_speed = 10
var_0_5.puke_in_face_sweep_radius = 3.3
var_0_5.puke_in_face_indicator_raidus = 3
var_0_5.movement_speed_multiplier = 1
var_0_5.breed_move_acceleration_up = 2
var_0_5.breed_move_acceleration_down = 4
var_0_5.run_threshold = 4
var_0_5.run_on_spawn = AiBreedSnippets.on_chaos_troll_spawn
var_0_5.run_on_death = nil
var_0_5.run_on_despawn = nil
var_0_5.boss_blocked_sound = nil
var_0_5.combat_music_state = "troll"
var_0_5.default_gear = {
	slot_frame = "frame_0000",
	slot_melee = "vs_chaos_troll_axe",
	slot_skin = "chaos_troll_skin_0000"
}

local var_0_6 = table.clone(Breeds.skaven_rat_ogre)

var_0_6.animation_sync_rpc = "rpc_sync_anim_state_5"
var_0_6.cannot_be_aggroed = true
var_0_6.parent_breed_name = "skaven_rat_ogre"
var_0_6.poison_resistance = 100
var_0_6.starting_animation = "to_1h_axe"
var_0_6.climb_type = "climb"
var_0_6.keep_weapon_on_death = true
var_0_6.blood_effect_name = nil
var_0_6.movement_speed_multiplier = 1.25
var_0_6.breed_move_acceleration_up = 2
var_0_6.breed_move_acceleration_down = 4
var_0_6.run_threshold = 4
var_0_6.priming_move_speed = 1
var_0_6.run_on_spawn = nil
var_0_6.run_on_death = nil
var_0_6.run_on_despawn = nil
var_0_6.combat_music_state = "rat_ogre"
var_0_6.default_gear = {
	slot_frame = "frame_0000",
	slot_melee = "vs_rat_ogre_hands",
	slot_skin = "skaven_rat_ogre_skin_0000"
}
PlayerBreeds.vs_rat_ogre = var_0_6
PlayerBreeds.vs_chaos_troll = var_0_5
PlayerBreeds.vs_gutter_runner = var_0_0
PlayerBreeds.vs_packmaster = var_0_1
PlayerBreeds.vs_poison_wind_globadier = var_0_2
PlayerBreeds.vs_ratling_gunner = var_0_3
PlayerBreeds.vs_warpfire_thrower = var_0_4

for iter_0_0, iter_0_1 in pairs(PlayerBreeds) do
	iter_0_1.name = iter_0_0

	local var_0_7 = BreedHitZonesLookup[iter_0_0]

	if var_0_7 then
		iter_0_1.hit_zones_lookup = var_0_7
	end
end

local var_0_8 = {
	stagger_prohibited = true,
	ignore_staggers = {
		true,
		true,
		true,
		true,
		true,
		true,
		true
	}
}
local var_0_9 = {
	stagger_prohibited = true,
	ignore_staggers = {
		true,
		true,
		true,
		true,
		true,
		true,
		true
	}
}
local var_0_10 = {
	stagger_prohibited = true,
	ignore_staggers = {
		true,
		true,
		true,
		true,
		true,
		true,
		true
	}
}
local var_0_11 = table.clone(BreedActions.chaos_troll)

var_0_11.climbing = var_0_8
var_0_11.spawning = var_0_10

local var_0_12 = table.clone(BreedActions.skaven_rat_ogre)

var_0_12.climbing = var_0_8
var_0_12.spawning = var_0_10

local var_0_13 = table.clone(BreedActions.skaven_warpfire_thrower)

var_0_13.climbing = var_0_8
var_0_13.tunneling = var_0_9
var_0_13.spawning = var_0_10
var_0_13.shoot_warpfire_thrower.ignore_staggers = {
	true,
	true,
	false,
	false,
	true,
	false
}

local var_0_14 = table.clone(BreedActions.skaven_gutter_runner)

var_0_14.climbing = var_0_8
var_0_14.tunneling = var_0_9
var_0_14.spawning = var_0_10

local var_0_15 = table.clone(BreedActions.skaven_pack_master)

var_0_15.climbing = var_0_8
var_0_15.tunneling = var_0_9
var_0_15.spawning = var_0_10

local var_0_16 = table.clone(BreedActions.skaven_poison_wind_globadier)

var_0_16.climbing = var_0_8
var_0_16.tunneling = var_0_9
var_0_16.spawning = var_0_10

local var_0_17 = table.clone(BreedActions.skaven_ratling_gunner)

var_0_17.climbing = var_0_8
var_0_17.tunneling = var_0_9
var_0_17.spawning = var_0_10

local var_0_18 = var_0_17.shoot_ratling_gun

var_0_18.fire_rate_at_start = 15
var_0_18.fire_rate_at_end = 20
var_0_18.time_at_max_rate_of_fire = 3
var_0_18.max_fire_rate_at_percentage = 0.5
var_0_18.light_weight_projectile_template_name = "ratling_gunner_vs"
var_0_18.target_switch_distance = {
	15,
	15
}
var_0_18.radial_speed_feet_shooting = math.pi * 0.725
var_0_18.radial_speed_upper_body_shooting = math.pi * 0.35
var_0_18.line_of_fire_nav_obstacle_half_extents = Vector3Box(1, 25, 1)
var_0_18.arc_of_sight_nav_obstacle_half_extents = Vector3Box(5, 5, 1)
var_0_18.ignore_staggers = {
	true,
	false,
	false,
	false,
	false,
	false
}
BreedActions.vs_gutter_runner = var_0_14
BreedActions.vs_packmaster = var_0_15
BreedActions.vs_poison_wind_globadier = var_0_16
BreedActions.vs_ratling_gunner = var_0_17
BreedActions.vs_warpfire_thrower = var_0_13
BreedActions.vs_chaos_troll = var_0_11
BreedActions.vs_rat_ogre = var_0_12
