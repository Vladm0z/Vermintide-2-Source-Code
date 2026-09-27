-- chunkname: @scripts/settings/breeds/breed_players_vs.lua

require("scripts/settings/breeds")

local clone = table.clone(Breeds.skaven_gutter_runner)

clone.animation_sync_rpc = "rpc_sync_anim_state_5"
clone.cannot_be_aggroed = true
clone.parent_breed_name = "skaven_gutter_runner"
clone.poison_resistance = 100
clone.starting_animation = "to_gutter_runner"
clone.climb_type = "climb"
clone.keep_weapon_on_death = true
clone.movement_speed_multiplier = 1.25
clone.run_threshold = 4
clone.pounce_prime_time = 1
clone.breed_move_acceleration_up = 8
clone.breed_move_acceleration_down = 8
clone.pounce_speed = 25
clone.pounce_upwards_amount = 0.15
clone.pounce_start_forward_offset = 0.3
clone.pounce_start_up_offset = 0.3
clone.pounce_gravity = 10
clone.pounce_look_sense = 0.8
clone.pounce_hit_radius = 1.1
clone.pounce_max_damage_time = 3
clone.min_pounce_damage = 10
clone.max_pounce_damage = 24
clone.foff_enter_anim_time = 0.32
clone.time_before_ramping_damage = 1.5
clone.time_to_reach_max_damage = 3
clone.base_damage = 2.5
clone.final_damage_multiplier = 4
clone.max_stagger_duration = 0.4
clone.stagger_resistance = 2
clone.stagger_resistance_ranged = 6
clone.stagger_threshold_light = 1
clone.stagger_threshold_medium = 2
clone.stagger_threshold_heavy = 2.5
clone.stagger_threshold_explosion = 3
clone.z_onscreen_damage_offset = 1
clone.damage_numbers_font_override = 10
clone.default_gear = {
	slot_frame = "frame_0000",
	slot_melee = "vs_gutter_runner_claws",
	slot_skin = "skaven_gutter_runner_skin_0000"
}

local clone_2 = table.clone(Breeds.skaven_pack_master)

clone_2.animation_sync_rpc = "rpc_sync_anim_state_7"
clone_2.cannot_be_aggroed = true
clone_2.parent_breed_name = "skaven_pack_master"
clone_2.dragging_hit_zone_name = "full"
clone_2.dragging_damage_type = "cutting"
clone_2.starting_animation = "to_packmaster"
clone_2.climb_type = "climb"
clone_2.poison_resistance = 100
clone_2.keep_weapon_on_death = false
clone_2.custom_husk_max_pitch = math.huge
clone_2.movement_speed_multiplier = 1.3
clone_2.run_threshold = 4
clone_2.strafe_speed_multiplier = 0.5
clone_2.breed_move_acceleration_up = 8
clone_2.breed_move_acceleration_down = 8
clone_2.grab_movement_speed_multiplier_initial = 0.875
clone_2.grab_movement_speed_multiplier_target = 0.25
clone_2.grab_hook_range = 4.5
clone_2.grab_hook_cone_dot = 0.9
clone_2.grab_anim_time = 0.55
clone_2.grab_grace_period = {
	before = 0.2,
	after = 0.5
}
clone_2.grab_look_sense = 1
clone_2.initial_drag_movement_speed = 6
clone_2.initial_drag_movement_speed_duration = 1.5
clone_2.drag_movement_speed = 3
clone_2.equip_hook_weapon_spawn_time = 0.3333333333333333
clone_2.equip_hook_exit_state_time = 0.6666666666666666
clone_2.dragging_time_to_damage = 1
clone_2.dragging_damage_amount = 6
clone.max_stagger_duration = 0.4
clone_2.stagger_resistance = 100
clone_2.stagger_resistance_ranged = 100
clone_2.stagger_threshold_light = 1
clone_2.stagger_threshold_medium = 2
clone_2.stagger_threshold_heavy = 2.5
clone_2.stagger_threshold_explosion = 3
clone_2.default_gear = {
	slot_frame = "frame_0000",
	slot_melee = "vs_packmaster_claw",
	slot_skin = "skaven_pack_master_skin_0000"
}

local clone_3 = table.clone(Breeds.skaven_poison_wind_globadier)

clone_3.animation_sync_rpc = "rpc_sync_anim_state_5"
clone_3.cannot_be_aggroed = true
clone_3.parent_breed_name = "skaven_poison_wind_globadier"
clone_3.poison_resistance = 100
clone_3.keep_weapon_on_death = true
clone_3.starting_animation = "to_globadier"
clone_3.climb_type = "climb"
clone_3.movement_speed_multiplier = 1
clone_3.wind_up_movement_speed = 2
clone_3.run_threshold = 5
clone_3.globe_throw_prime_time = 0.65
clone_3.breed_move_acceleration_up = 8
clone_3.breed_move_acceleration_down = 8
clone_3.globe_throw_spawn_globe_time = 0.14
clone_3.globe_throw_finish_time = 0.5
clone_3.globe_throw_speed = 1600
clone_3.globe_throw_look_sense = 1
clone_3.globe_throw_aoe_radius = 5
clone_3.globe_throw_initial_radius = 5
clone_3.globe_throw_aoe_life_time = 6
clone_3.globe_throw_upwards_amount = 0.2
clone_3.globe_throw_impact_difficulty_damage = {
	1,
	1,
	1,
	1,
	1
}
clone_3.globe_throw_dot_difficulty_damage = {
	8,
	8,
	8,
	8,
	8
}
clone_3.globe_throw_dot_damage_interval = 1
clone.max_stagger_duration = 0.4
clone_3.stagger_resistance = 100
clone_3.stagger_resistance_ranged = 500
clone_3.stagger_threshold_light = 1
clone_3.stagger_threshold_medium = 2
clone_3.stagger_threshold_heavy = 2.5
clone_3.stagger_threshold_explosion = 3
clone_3.default_gear = {
	slot_frame = "frame_0000",
	slot_melee = "vs_poison_wind_globadier_orb",
	slot_skin = "skaven_wind_globadier_skin_0000"
}

local clone_4 = table.clone(Breeds.skaven_ratling_gunner)

clone_4.animation_sync_rpc = "rpc_sync_anim_state_6"
clone_4.base_unit = "units/beings/player/dark_pact_third_person_base/skaven_ratlinggunner"
clone_4.cannot_be_aggroed = true
clone_4.parent_breed_name = "skaven_ratling_gunner"
clone_4.poison_resistance = 100
clone_4.keep_weapon_on_death = false
clone_4.starting_animation = "to_ratling_gunner"
clone_4.climb_type = "climb"
clone_4.death_sound_event = "Play_player_ratling_gunner_dead"
clone_4.radius = 1
clone_4.aoe_height = 1.5
clone_4.size_variation_range = {
	1.1,
	1.1
}
clone_4.player_locomotion_constrain_radius = 0.7
clone_4.weapon_reach = 2
clone_4.smart_targeting_width = 0.3
clone_4.smart_targeting_height_multiplier = 2.1
clone_4.smart_targeting_outer_width = 0.7
clone_4.aim_constraint_forward_multiplier = 30
clone_4.custom_husk_max_pitch = math.huge
clone_4.movement_speed_multiplier = 0.875
clone_4.run_threshold = 2.5
clone_4.breed_move_acceleration_up = 8
clone_4.breed_move_acceleration_down = 8
clone_4.shoot_ratlinggun_pose_weapon_time = 1.8
clone_4.reloading_max_time = 1
clone_4.reloading_movement_speed = 3
clone_4.shoot_ratlinggun_minimum_forced_cooldown = 0.01
clone_4.shoot_ratlinggun_max_firing_time = 100
clone_4.max_ammo = 120
clone_4.armor_category = 1
clone.max_stagger_duration = 0.4
clone_4.diff_stagger_resist = nil
clone_4.stagger_resistance = 2.5
clone_4.stagger_resistance_ranged = 9
clone_4.stagger_threshold_light = 1
clone_4.stagger_threshold_medium = 2
clone_4.stagger_threshold_heavy = 3
clone_4.stagger_threshold_explosion = 4
clone_4.default_gear = {
	slot_frame = "frame_0000",
	slot_melee = "vs_ratling_gunner_gun",
	slot_skin = "skaven_ratling_gunner_skin_0000"
}
clone_4.track_projectile_blocked_vo = true

local clone_5 = table.clone(Breeds.skaven_warpfire_thrower)

clone_5.animation_sync_rpc = "rpc_sync_anim_state_6"
clone_5.cannot_be_aggroed = true
clone_5.parent_breed_name = "skaven_warpfire_thrower"
clone_5.poison_resistance = 100
clone_5.keep_weapon_on_death = false
clone_5.starting_animation = "to_warpfire_thrower"
clone_5.climb_type = "climb"
clone_5.movement_speed_multiplier = 0.875
clone_5.breed_move_acceleration_up = 8
clone_5.breed_move_acceleration_down = 8
clone_5.run_threshold = 4
clone_5.shoot_warpfire_prime_time = 0.2
clone_5.shoot_warpfire_wind_up_movement_speed = {
	finish = 1,
	start = 3,
	rate = 1
}
clone_5.shoot_warpfire_movement_speed_mod = 2
clone_5.custom_husk_max_pitch = math.huge
clone_5.shoot_warpfire_max_flame_time = 5
clone_5.shoot_warpfire_attack_range = 10
clone_5.shoot_warpfire_close_attack_range = 7
clone_5.shoot_warpfire_close_attack_cooldown = 0.2
clone_5.shoot_warpfire_close_attack_hit_radius = 1.5
clone_5.shoot_warpfire_close_attack_dot = 0.9
clone_5.shoot_warpfire_minimum_forced_cooldown = 0.6
clone_5.warpfire_vfx = "chr_warp_fire_flamethrower_01_1p_versus"
clone_5.shoot_warpfire_long_attack_damage = {
	2,
	2,
	2,
	2,
	2,
	2
}
clone_5.armor_category = 1
clone.max_stagger_duration = 0.4
clone_5.diff_stagger_resist = nil
clone_5.stagger_resistance = 5
clone_5.stagger_resistance_ranged = 8
clone_5.stagger_threshold_light = 1
clone_5.stagger_threshold_medium = 2
clone_5.stagger_threshold_heavy = 3
clone_5.stagger_threshold_explosion = 4
clone_5.default_gear = {
	slot_frame = "frame_0000",
	slot_melee = "vs_warpfire_thrower_gun",
	slot_skin = "skaven_warpfire_thrower_skin_0000"
}

local clone_6 = table.clone(Breeds.chaos_troll)

clone_6.animation_sync_rpc = "rpc_sync_anim_state_6"
clone_6.cannot_be_aggroed = true
clone_6.parent_breed_name = "chaos_troll"
clone_6.poison_resistance = 100
clone_6.starting_animation = "to_1h_axe"
clone_6.climb_type = "climb"
clone_6.keep_weapon_on_death = true
clone_6.max_vomit_distance = 7
clone_6.vomit_in_face_sweep_radius = 3
clone_6.vomit_movement_speed = 2
clone_6.look_sense_override = 0.33
clone_6.vomit_upwards_amount = 0.2
clone_6.vomit_projectile_speed = 10
clone_6.puke_in_face_sweep_radius = 3.3
clone_6.puke_in_face_indicator_raidus = 3
clone_6.movement_speed_multiplier = 1
clone_6.breed_move_acceleration_up = 2
clone_6.breed_move_acceleration_down = 4
clone_6.run_threshold = 4
clone_6.run_on_spawn = AiBreedSnippets.on_chaos_troll_spawn
clone_6.run_on_death = nil
clone_6.run_on_despawn = nil
clone_6.boss_blocked_sound = nil
clone_6.combat_music_state = "troll"
clone_6.default_gear = {
	slot_frame = "frame_0000",
	slot_melee = "vs_chaos_troll_axe",
	slot_skin = "chaos_troll_skin_0000"
}

local clone_7 = table.clone(Breeds.skaven_rat_ogre)

clone_7.animation_sync_rpc = "rpc_sync_anim_state_5"
clone_7.cannot_be_aggroed = true
clone_7.parent_breed_name = "skaven_rat_ogre"
clone_7.poison_resistance = 100
clone_7.starting_animation = "to_1h_axe"
clone_7.climb_type = "climb"
clone_7.keep_weapon_on_death = true
clone_7.blood_effect_name = nil
clone_7.movement_speed_multiplier = 1.25
clone_7.breed_move_acceleration_up = 2
clone_7.breed_move_acceleration_down = 4
clone_7.run_threshold = 4
clone_7.priming_move_speed = 1
clone_7.run_on_spawn = nil
clone_7.run_on_death = nil
clone_7.run_on_despawn = nil
clone_7.combat_music_state = "rat_ogre"
clone_7.default_gear = {
	slot_frame = "frame_0000",
	slot_melee = "vs_rat_ogre_hands",
	slot_skin = "skaven_rat_ogre_skin_0000"
}
PlayerBreeds.vs_rat_ogre = clone_7
PlayerBreeds.vs_chaos_troll = clone_6
PlayerBreeds.vs_gutter_runner = clone
PlayerBreeds.vs_packmaster = clone_2
PlayerBreeds.vs_poison_wind_globadier = clone_3
PlayerBreeds.vs_ratling_gunner = clone_4
PlayerBreeds.vs_warpfire_thrower = clone_5

for k, v in pairs(PlayerBreeds) do
	v.name = k

	local var_0_7 = BreedHitZonesLookup[k]

	if not var_0_7 then
		v.hit_zones_lookup = var_0_7
	end
end

local tbl = {
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
local tbl_2 = {
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
local tbl_3 = {
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
local clone_8 = table.clone(BreedActions.chaos_troll)

clone_8.climbing = tbl
clone_8.spawning = tbl_3

local clone_9 = table.clone(BreedActions.skaven_rat_ogre)

clone_9.climbing = tbl
clone_9.spawning = tbl_3

local clone_10 = table.clone(BreedActions.skaven_warpfire_thrower)

clone_10.climbing = tbl
clone_10.tunneling = tbl_2
clone_10.spawning = tbl_3
clone_10.shoot_warpfire_thrower.ignore_staggers = {
	true,
	true,
	false,
	false,
	true,
	false
}

local clone_11 = table.clone(BreedActions.skaven_gutter_runner)

clone_11.climbing = tbl
clone_11.tunneling = tbl_2
clone_11.spawning = tbl_3

local clone_12 = table.clone(BreedActions.skaven_pack_master)

clone_12.climbing = tbl
clone_12.tunneling = tbl_2
clone_12.spawning = tbl_3

local clone_13 = table.clone(BreedActions.skaven_poison_wind_globadier)

clone_13.climbing = tbl
clone_13.tunneling = tbl_2
clone_13.spawning = tbl_3

local clone_14 = table.clone(BreedActions.skaven_ratling_gunner)

clone_14.climbing = tbl
clone_14.tunneling = tbl_2
clone_14.spawning = tbl_3

local shoot_ratling_gun = clone_14.shoot_ratling_gun

shoot_ratling_gun.fire_rate_at_start = 15
shoot_ratling_gun.fire_rate_at_end = 20
shoot_ratling_gun.time_at_max_rate_of_fire = 3
shoot_ratling_gun.max_fire_rate_at_percentage = 0.5
shoot_ratling_gun.light_weight_projectile_template_name = "ratling_gunner_vs"
shoot_ratling_gun.target_switch_distance = {
	15,
	15
}
shoot_ratling_gun.radial_speed_feet_shooting = math.pi * 0.725
shoot_ratling_gun.radial_speed_upper_body_shooting = math.pi * 0.35
shoot_ratling_gun.line_of_fire_nav_obstacle_half_extents = Vector3Box(1, 25, 1)
shoot_ratling_gun.arc_of_sight_nav_obstacle_half_extents = Vector3Box(5, 5, 1)
shoot_ratling_gun.ignore_staggers = {
	true,
	false,
	false,
	false,
	false,
	false
}
BreedActions.vs_gutter_runner = clone_11
BreedActions.vs_packmaster = clone_12
BreedActions.vs_poison_wind_globadier = clone_13
BreedActions.vs_ratling_gunner = clone_14
BreedActions.vs_warpfire_thrower = clone_10
BreedActions.vs_chaos_troll = clone_8
BreedActions.vs_rat_ogre = clone_9
