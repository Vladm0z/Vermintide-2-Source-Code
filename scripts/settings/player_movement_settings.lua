-- chunkname: @scripts/settings/player_movement_settings.lua

local PlayerUnitMovementSettings = PlayerUnitMovementSettings

PlayerUnitMovementSettings = PlayerUnitMovementSettings or {}
PlayerUnitMovementSettings = PlayerUnitMovementSettings

local tbl = {}

PlayerUnitMovementSettings.get_movement_settings_table = function (arg_1_0)
	-- function 1
	if not tbl[arg_1_0] then
		PlayerUnitMovementSettings.register_unit(arg_1_0)
	end

	return tbl[arg_1_0]
end

PlayerUnitMovementSettings.register_unit = function (arg_2_0)
	-- function 2
	tbl[arg_2_0] = table.clone(PlayerUnitMovementSettings)
end

PlayerUnitMovementSettings.unregister_unit = function (arg_3_0)
	-- function 3
	tbl[arg_3_0] = nil
end

PlayerUnitMovementSettings.get_active_units_in_movement_settings = function ()
	-- function 4
	local tbl_2 = {}
	local num = 1

	for k, v in pairs(tbl) do
		tbl_2[num] = k
		num = num + 1
	end

	return tbl_2
end

PlayerUnitMovementSettings.FWD_MOVE_SPEED_SCALE = 1
PlayerUnitMovementSettings.BWD_MOVE_SPEED_SCALE = 0.65
PlayerUnitMovementSettings.STRAFE_MOVE_SPEED_SCALE = 1

local PlayerUnitMovementSettings_2 = PlayerUnitMovementSettings
local slope_traversion = PlayerUnitMovementSettings.slope_traversion

slope_traversion = slope_traversion or {}
PlayerUnitMovementSettings_2.slope_traversion = slope_traversion
PlayerUnitMovementSettings.slope_traversion.max_angle = math.pi * 0.27
PlayerUnitMovementSettings.slope_traversion.standing_frames = 1
PlayerUnitMovementSettings.slope_traversion.jump_disallowed_frames = 10
PlayerUnitMovementSettings.slope_traversion.crouch_step_up = 0.15
PlayerUnitMovementSettings.slope_traversion.aim_step_up = 0.15
PlayerUnitMovementSettings.player_speed_scale = 1
PlayerUnitMovementSettings.player_air_speed_scale = 0.035
PlayerUnitMovementSettings.crouch_move_speed = 1.4
PlayerUnitMovementSettings.walk_move_speed = 1.9
PlayerUnitMovementSettings.move_speed = 4
PlayerUnitMovementSettings.backward_move_scale = 0.75
PlayerUnitMovementSettings.move_acceleration_up = 8
PlayerUnitMovementSettings.move_acceleration_down = 5
PlayerUnitMovementSettings.post_dodge_jump_velocity_scale = 0.2
PlayerUnitMovementSettings.post_dodge_jump_speed_scale = 1
PlayerUnitMovementSettings.backwards_jump_velocity_scale = 0.35
PlayerUnitMovementSettings.look_input_limit = -1
PlayerUnitMovementSettings.look_input_limit_multiplier = 1
PlayerUnitMovementSettings.look_input_sensitivity = 1

local PlayerUnitMovementSettings_3 = PlayerUnitMovementSettings
local rig_movement = PlayerUnitMovementSettings.rig_movement

rig_movement = rig_movement or {}
PlayerUnitMovementSettings_3.rig_movement = rig_movement
PlayerUnitMovementSettings.rig_movement.mass = 8
PlayerUnitMovementSettings.rig_movement.tension = 600
PlayerUnitMovementSettings.rig_movement.damping = 40
PlayerUnitMovementSettings.rig_movement.motion_offset = 3
PlayerUnitMovementSettings.rig_movement.horizontal_motion_damping = 0.8
PlayerUnitMovementSettings.rig_movement.vertical_motion_damping = 0.2
PlayerUnitMovementSettings.rig_movement.vertical_look_multiplier_ranged = 0.25
PlayerUnitMovementSettings.rig_movement.vertical_look_multiplier_melee = 0.1

local PlayerUnitMovementSettings_4 = PlayerUnitMovementSettings
local ladder = PlayerUnitMovementSettings.ladder

ladder = ladder or {}
PlayerUnitMovementSettings_4.ladder = ladder
PlayerUnitMovementSettings.ladder.player_ladder_speed_scale = 1
PlayerUnitMovementSettings.ladder.climb_speed = 3
PlayerUnitMovementSettings.ladder.climb_move_acceleration_up = 4
PlayerUnitMovementSettings.ladder.climb_move_acceleration_down = 5
PlayerUnitMovementSettings.ladder.climb_pitch_offset = math.pi / 8
PlayerUnitMovementSettings.ladder.climb_speed_lerp_interval = 22.5
PlayerUnitMovementSettings.ladder.climb_horizontals_multiplier = 0.25
PlayerUnitMovementSettings.ladder.climb_attach_to_ladder_position_in_ladder_space_y = -0.73
PlayerUnitMovementSettings.ladder.animation_distance_threshold_from_top_node = 2
PlayerUnitMovementSettings.ladder.movement_animation_length = 1.666
PlayerUnitMovementSettings.ladder.leaving_ladder_top_animation_time = 0.25
PlayerUnitMovementSettings.ladder.leaving_ladder_height_below_get_of_node = 0.4
PlayerUnitMovementSettings.ladder.enter_ladder_top_animation_time = 0.25
PlayerUnitMovementSettings.ladder.whole_movement_animation_distance = 2.5
PlayerUnitMovementSettings.ladder.threshold_for_idle_right = 0.166
PlayerUnitMovementSettings.ladder.threshold_for_idle_middle = 0.433
PlayerUnitMovementSettings.ladder.threshold_for_idle_left = 1.066
PlayerUnitMovementSettings.ladder.pitch_offset = 20
PlayerUnitMovementSettings.ladder.look_horizontal_max_degrees = 360
PlayerUnitMovementSettings.ladder.jump_backwards_force = -8.5
PlayerUnitMovementSettings.ladder.jump_up_force = 4.25
PlayerUnitMovementSettings.ladder.jump_force_backward_movement_time = 1
PlayerUnitMovementSettings.ladder.jump_force_forward_movement_time = 0.4
PlayerUnitMovementSettings.ladder.leave_ladder_reattach_time = 0.5
PlayerUnitMovementSettings.ladder.looking_up_threshold = -0.25
PlayerUnitMovementSettings.ladder.looking_down_threshold = -0.6
PlayerUnitMovementSettings.ladder.bot_looking_down_threshold = 0
PlayerUnitMovementSettings.soft_collision = {}
PlayerUnitMovementSettings.soft_collision.speed_modifier = 0.01
PlayerUnitMovementSettings.soft_collision.lowest_speed = 1
PlayerUnitMovementSettings.soft_collision.highest_speed = 3
PlayerUnitMovementSettings.soft_collision.grace_time_pushed_entering_standing = 0.75
PlayerUnitMovementSettings.soft_collision.max_distance = 0.65
PlayerUnitMovementSettings.soft_collision.max_height_diference = 0.1
PlayerUnitMovementSettings.soft_collision.idle_speed_threshold = 0.05

local PlayerUnitMovementSettings_5 = PlayerUnitMovementSettings
local catapulted = PlayerUnitMovementSettings.catapulted

catapulted = catapulted or {}
PlayerUnitMovementSettings_5.catapulted = catapulted

local catapulted_2 = PlayerUnitMovementSettings.catapulted
local directions = PlayerUnitMovementSettings.catapulted.directions

directions = directions or {}
catapulted_2.directions = directions
PlayerUnitMovementSettings.catapulted.directions.forward = {
	wall_collide_animation = "airtime_end",
	start_animation = "airtime_bwd",
	land_animation = "airtime_end"
}
PlayerUnitMovementSettings.catapulted.directions.backward = {
	wall_collide_animation = "airtime_end",
	start_animation = "airtime_fwd",
	land_animation = "airtime_end"
}
PlayerUnitMovementSettings.catapulted.directions.forward_thrown = {
	start_animation_1p = "airtime_bwd",
	start_animation = "airtime_fwd",
	wall_collide_animation = "airtime_end",
	land_animation = "airtime_end"
}
PlayerUnitMovementSettings.gameplay_collision_box = {}
PlayerUnitMovementSettings.gameplay_collision_box.collision_check_player_half_height = 0.8
PlayerUnitMovementSettings.gameplay_collision_box.collision_check_player_radius = 0.8
PlayerUnitMovementSettings.gameplay_collision_box.collision_check_player_height_offset = 0.8
PlayerUnitMovementSettings.ledge_hanging = {}
PlayerUnitMovementSettings.ledge_hanging.time_until_fall_down = 30
PlayerUnitMovementSettings.ledge_hanging.reattach_time = 2
PlayerUnitMovementSettings.ledge_hanging.look_horizontal_max_degrees_yaw = 0
PlayerUnitMovementSettings.ledge_hanging.look_horizontal_max_degrees_pitch = 0
PlayerUnitMovementSettings.ledge_hanging.attach_rotation_speed_slowdown_modifier_yaw = 0.1
PlayerUnitMovementSettings.ledge_hanging.attach_rotation_speed_slowdown_modifier_pitch = 0.1
PlayerUnitMovementSettings.ledge_hanging.attach_position_lerp_threshold = 0.05
PlayerUnitMovementSettings.ledge_hanging.attach_position_lerp_time_per_meter = 0.2
PlayerUnitMovementSettings.ledge_hanging.ledge_hanging_attachment_offset_x = -0
PlayerUnitMovementSettings.ledge_hanging.ledge_hanging_attachment_offset_y = 0.95
PlayerUnitMovementSettings.ledge_hanging.ledge_hanging_attachment_offset_z = 0.05
PlayerUnitMovementSettings.ledge_hanging.attach_pos_lerp_percentage_start_per_unit_velocity = 0.2
PlayerUnitMovementSettings.ledge_hanging.attach_max_instant_start_pos_movement = 0.3
PlayerUnitMovementSettings.ledge_hanging.leaving_animation_time = 2.83
PlayerUnitMovementSettings.ledge_hanging.leaving_time_to_activate_gravitation = 2.5
PlayerUnitMovementSettings.ledge_hanging.leaving_forward_push_factor = 0.1
PlayerUnitMovementSettings.ledge_hanging.leaving_push_up_constant = -0.01
PlayerUnitMovementSettings.ledge_hanging.falling_kill_timer = 0.2
PlayerUnitMovementSettings.ledge_hanging.leaving_falling_forward_push_constant = -1.8
PlayerUnitMovementSettings.ledge_hanging.leaving_falling_push_up_constant = -0.7
PlayerUnitMovementSettings.dodging = {}
PlayerUnitMovementSettings.dodging.distance = 2
PlayerUnitMovementSettings.dodging.speed_at_times = {
	{
		time_in_dodge = 0,
		speed = 1
	},
	{
		time_in_dodge = 0.05,
		speed = 4
	},
	{
		time_in_dodge = 0.1,
		speed = 7
	},
	{
		time_in_dodge = 0.25,
		speed = 5
	},
	{
		time_in_dodge = 0.4,
		speed = 2
	},
	{
		time_in_dodge = 0.5,
		speed = 1
	}
}
PlayerUnitMovementSettings.dodging.dodge_cd = 0.15
PlayerUnitMovementSettings.dodging.dodge_jump_override_timer = 0.35
PlayerUnitMovementSettings.dodging.stop_threshold = 0.1
PlayerUnitMovementSettings.dodging.speed_modifier = 1
PlayerUnitMovementSettings.dodging.distance_modifier = 1
PlayerUnitMovementSettings.first_person_height_knocked_down = 0.25
PlayerUnitMovementSettings.first_person_height_crouch = 1
PlayerUnitMovementSettings.first_person_height_stand = 1.65
PlayerUnitMovementSettings.slowing_damage_types = {
	projectile = true,
	kinetic = true,
	blunt = true,
	slashing = true,
	vomit_face = true,
	warpfire_ground = false,
	plague_face = false,
	piercing = true,
	vomit_ground = false,
	warpfire_face = false,
	cutting = true,
	crush = true
}

local PlayerUnitMovementSettings_6 = PlayerUnitMovementSettings
local charged_settings = PlayerUnitMovementSettings.charged_settings

charged_settings = charged_settings or {}
PlayerUnitMovementSettings_6.charged_settings = charged_settings
PlayerUnitMovementSettings.charged_settings.charged = {
	duration = 1,
	first_person_anim_name = "interrupt",
	third_person_anim_name = "idle"
}

local PlayerUnitMovementSettings_7 = PlayerUnitMovementSettings
local stun_settings = PlayerUnitMovementSettings.stun_settings

stun_settings = stun_settings or {}
PlayerUnitMovementSettings_7.stun_settings = stun_settings
PlayerUnitMovementSettings.stun_settings.parry_broken = {
	duration = 1,
	first_person_anim_name = "parry_break",
	third_person_anim_name = "parry_break"
}
PlayerUnitMovementSettings.stun_settings.pushed = {
	duration = 0.2,
	first_person_anim_name = "interrupt",
	third_person_anim_name = "idle"
}
PlayerUnitMovementSettings.hit_react_settings = {
	light_push = {
		start_look_sense_override = 0.9,
		end_look_sense_override = 1,
		movement_speed_modifier = 1,
		look_override_function = function ()
			-- function 5
			local num = 0.5 * (0.5 - math.random())
			local num_2 = -0.1 + math.random() * 0.05

			return num, num_2
		end,
		duration_function = function ()
			-- function 6
			return 0.1
		end,
		onscreen_particle_function = function (arg_7_0)
			-- function 7
			return "fx/screenspace_head_blow_light_push"
		end
	},
	light = {
		start_look_sense_override = 0.6,
		end_look_sense_override = 1,
		movement_speed_modifier = 0.8,
		look_override_function = function ()
			-- function 8
			local num = 0.5 * (0.5 - math.random())
			local num_2 = -0.2 + math.random() * 0.1

			return num, num_2
		end,
		duration_function = function ()
			-- function 9
			return 0.35
		end,
		onscreen_particle_function = function (arg_10_0)
			-- function 10
			if arg_10_0 < 0.35 then
				return
			end

			return "fx/screenspace_head_blow_light"
		end
	},
	medium_push = {
		start_look_sense_override = 0.6,
		end_look_sense_override = 1,
		movement_speed_modifier = 0.8,
		look_override_function = function ()
			-- function 11
			local num = 0.5 * (0.5 - math.random())
			local num_2 = -0.15 + math.random() * 0.1

			return num, num_2
		end,
		duration_function = function ()
			-- function 12
			return 0.35
		end,
		onscreen_particle_function = function (arg_13_0)
			-- function 13
			return "fx/screenspace_head_blow_medium_push"
		end
	},
	medium = {
		start_look_sense_override = 0.4,
		end_look_sense_override = 0.8,
		movement_speed_modifier = 0.65,
		look_override_function = function ()
			-- function 14
			local num = 0.5 * (0.5 - math.random())
			local num_2 = -0.3 + math.random() * 0.2

			return num, num_2
		end,
		duration_function = function ()
			-- function 15
			return 0.6
		end,
		onscreen_particle_function = function (arg_16_0)
			-- function 16
			if arg_16_0 < 0.6 then
				return "fx/screenspace_head_blow_light"
			end

			return "fx/screenspace_head_blow_medium"
		end
	},
	heavy_push = {
		start_look_sense_override = 0.4,
		end_look_sense_override = 0.8,
		movement_speed_modifier = 0.65,
		look_override_function = function ()
			-- function 17
			local num = 0.5 * (0.5 - math.random())
			local num_2 = -0.25 + math.random() * 0.1

			return num, num_2
		end,
		duration_function = function ()
			-- function 18
			return 0.6
		end,
		onscreen_particle_function = function (arg_19_0)
			-- function 19
			return "fx/screenspace_head_blow_heavy_push"
		end
	},
	heavy = {
		start_look_sense_override = 0.35,
		end_look_sense_override = 0.7,
		movement_speed_modifier = 0.5,
		look_override_function = function ()
			-- function 20
			local num = 0.5 * (0.5 - math.random())
			local num_2 = -0.5 + math.random() * 0.2

			return num, num_2
		end,
		duration_function = function ()
			-- function 21
			return 1
		end,
		onscreen_particle_function = function (arg_22_0)
			-- function 22
			if arg_22_0 < 1 then
				return "fx/screenspace_head_blow_medium"
			end

			return "fx/screenspace_head_blow_heavy"
		end
	},
	slow_bomb = {
		start_look_sense_override = 0.35,
		end_look_sense_override = 0.7,
		movement_speed_modifier = 0.1,
		look_override_function = function ()
			-- function 23
			local num = 0.5 * (0.5 - math.random())
			local num_2 = -0.5 + math.random() * 0.2

			return num, num_2
		end,
		duration_function = function ()
			-- function 24
			return 7
		end,
		onscreen_particle_function = function (arg_25_0)
			-- function 25
			if arg_25_0 < 7 then
				return "fx/screenspace_head_blow_light"
			end

			return "fx/screenspace_head_blow_heavy"
		end
	},
	charged = {
		start_look_sense_override = 0.4,
		end_look_sense_override = 0.8,
		movement_speed_modifier = 0.65,
		look_override_function = function ()
			-- function 26
			local num = 0
			local num_2 = 0.45

			return num, num_2
		end,
		duration_function = function ()
			-- function 27
			return 1
		end,
		onscreen_particle_function = function (arg_28_0)
			-- function 28
			return "fx/screenspace_head_blow_medium_push"
		end
	}
}

local PlayerUnitMovementSettings_8 = PlayerUnitMovementSettings
local overpowered_templates = PlayerUnitMovementSettings.overpowered_templates

overpowered_templates = overpowered_templates or {}
PlayerUnitMovementSettings_8.overpowered_templates = overpowered_templates
PlayerUnitMovementSettings.overpowered_templates.slow_bomb = {}
PlayerUnitMovementSettings.overpowered_templates.fly_bomb = {
	end_sound_event = "Stop_sorcerer_boss_flies_curse_loop",
	start_sound_event = "Play_sorcerer_boss_flies_curse_loop"
}
PlayerUnitMovementSettings.gravity_acceleration = 11

local PlayerUnitMovementSettings_9 = PlayerUnitMovementSettings
local jump = PlayerUnitMovementSettings.jump

jump = jump or {}
PlayerUnitMovementSettings_9.jump = jump
PlayerUnitMovementSettings.jump.stamina_cost = 0
PlayerUnitMovementSettings.jump.initial_vertical_speed = 4.25

local PlayerUnitMovementSettings_10 = PlayerUnitMovementSettings
local leap = PlayerUnitMovementSettings.leap

leap = leap or {}
PlayerUnitMovementSettings_10.leap = leap
PlayerUnitMovementSettings.leap.jump_speed = 6.5
PlayerUnitMovementSettings.leap.move_speed = 13.5
PlayerUnitMovementSettings.leap.slam_speed = 18

local PlayerUnitMovementSettings_11 = PlayerUnitMovementSettings
local teleleap = PlayerUnitMovementSettings.teleleap

teleleap = teleleap or {}
PlayerUnitMovementSettings_11.teleleap = teleleap
PlayerUnitMovementSettings.teleleap.jump_speed = 12
PlayerUnitMovementSettings.teleleap.move_speed = 60

local PlayerUnitMovementSettings_12 = PlayerUnitMovementSettings
local fall = PlayerUnitMovementSettings.fall

fall = fall or {}
PlayerUnitMovementSettings_12.fall = fall

local fall_2 = PlayerUnitMovementSettings.fall
local heights = PlayerUnitMovementSettings.fall.heights

heights = heights or {}
fall_2.heights = heights
PlayerUnitMovementSettings.fall.heights.FALL_DAMAGE_MULTIPLIER = 14
PlayerUnitMovementSettings.fall.heights.MIN_FALL_DAMAGE_HEIGHT = 7
PlayerUnitMovementSettings.fall.heights.MIN_FALL_DAMAGE_PERCENTAGE = 0
PlayerUnitMovementSettings.fall.heights.MAX_FALL_DAMAGE_PERCENTAGE = 1
PlayerUnitMovementSettings.fall.heights.HARD_LANDING_FALL_HEIGHT = 7

local PlayerUnitMovementSettings_13 = PlayerUnitMovementSettings
local landing = PlayerUnitMovementSettings.landing

landing = landing or {}
PlayerUnitMovementSettings_13.landing = landing
PlayerUnitMovementSettings.landing.anim_forced_upper_body_block = 0.3

local PlayerUnitMovementSettings_14 = PlayerUnitMovementSettings
local swing = PlayerUnitMovementSettings.swing

swing = swing or {}
PlayerUnitMovementSettings_14.swing = swing
PlayerUnitMovementSettings.swing.REQUIRED_MOVEMENT_TO_POSE = 0.003
PlayerUnitMovementSettings.swing.REQUIRED_MOVEMENT_TO_POSE_SCALE_Y_UP = 2.5
PlayerUnitMovementSettings.swing.REQUIRED_MOVEMENT_TO_POSE_SCALE_Y_DOWN = 0
PlayerUnitMovementSettings.swing.THRUST_TIMER = 0.15
PlayerUnitMovementSettings.swing.invert_pose_control_x = false
PlayerUnitMovementSettings.swing.invert_pose_control_y = false
PlayerUnitMovementSettings.swing.keyboard_controlled = false
PlayerUnitMovementSettings.swing.mounted_lean_swing_top = 0
PlayerUnitMovementSettings.swing.mounted_lean_swing_range = 30

local swing_2 = PlayerUnitMovementSettings.swing
local stamina_settings = PlayerUnitMovementSettings.swing.stamina_settings

stamina_settings = stamina_settings or {}
swing_2.stamina_settings = stamina_settings
PlayerUnitMovementSettings.swing.stamina_settings.minimum_activation_cost = 0.1
PlayerUnitMovementSettings.swing.stamina_settings.activation_cost = 0.2

local PlayerUnitMovementSettings_15 = PlayerUnitMovementSettings
local parry = PlayerUnitMovementSettings.parry

parry = parry or {}
PlayerUnitMovementSettings_15.parry = parry
PlayerUnitMovementSettings.parry.stamina_per_damage = 0.001375
PlayerUnitMovementSettings.parry.override_recharge_rate = 0.025

local PlayerUnitMovementSettings_16 = PlayerUnitMovementSettings
local block = PlayerUnitMovementSettings.block

block = block or {}
PlayerUnitMovementSettings_16.block = block
PlayerUnitMovementSettings.block.stamina_per_damage = 0.001375
PlayerUnitMovementSettings.block.consecutive_block_impact_time = 3
PlayerUnitMovementSettings.block.consecutive_block_impact_multiplier = 1
PlayerUnitMovementSettings.block.override_recharge_rate = 0.025

local PlayerUnitMovementSettings_17 = PlayerUnitMovementSettings
local parry_2 = PlayerUnitMovementSettings.parry

parry_2 = parry_2 or {}
PlayerUnitMovementSettings_17.parry = parry_2
PlayerUnitMovementSettings.parry.REQUIRED_MOVEMENT_TO_POSE = 0.003
PlayerUnitMovementSettings.parry.invert_parry_control_x = false
PlayerUnitMovementSettings.parry.invert_parry_control_y = false
PlayerUnitMovementSettings.parry.keyboard_controlled = false
PlayerUnitMovementSettings.parry.raise_delay = 0.18

local PlayerUnitMovementSettings_18 = PlayerUnitMovementSettings
local block_2 = PlayerUnitMovementSettings.block

block_2 = block_2 or {}
PlayerUnitMovementSettings_18.block = block_2
PlayerUnitMovementSettings.block.raise_delay = 0.18

DLCUtils.require("player_movement_settings")
