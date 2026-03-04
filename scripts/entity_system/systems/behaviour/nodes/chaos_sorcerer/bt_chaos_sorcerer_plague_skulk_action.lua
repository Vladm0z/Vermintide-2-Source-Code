-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/bt_chaos_sorcerer_plague_skulk_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTChaosSorcererPlagueSkulkAction = class(BTChaosSorcererPlagueSkulkAction, BTNode)

local var_0_0 = BTChaosSorcererPlagueSkulkAction
local var_0_1 = POSITION_LOOKUP

var_0_0.init = function (arg_1_0, ...)
	var_0_0.super.init(arg_1_0, ...)
end

var_0_0.name = "BTChaosSorcererPlagueSkulkAction"

var_0_0.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data
	local var_2_1 = arg_2_2.breed

	Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_2_1, "heard_enemy", DialogueSettings.hear_chaos_corruptor_sorcerer, "enemy_tag", var_2_1.name)

	local var_2_2 = arg_2_2.skulk_data or {}

	arg_2_2.skulk_data = var_2_2
	var_2_2.direction = var_2_2.direction or 1 - math.random(0, 1) * 2
	var_2_2.radius = var_2_2.radius or arg_2_2.target_dist
	arg_2_2.action = var_2_0

	if arg_2_2.move_state ~= "idle" then
		arg_2_0:idle(arg_2_1, arg_2_2)
	end

	LocomotionUtils.set_animation_driven_movement(arg_2_1, false)

	if arg_2_2.move_pos then
		local var_2_3 = arg_2_2.move_pos:unbox()

		arg_2_0:move_to(var_2_3, arg_2_1, arg_2_2)
	end

	arg_2_2.ready_to_summon = false

	local var_2_4 = 6

	if var_2_0.skulk_time then
		if var_2_0.initial_skulk_time and not arg_2_2.initial_skulk_finished then
			var_2_4 = math.random(var_2_0.initial_skulk_time[1], var_2_0.initial_skulk_time[2])
		else
			var_2_4 = math.random(var_2_0.skulk_time[1], var_2_0.skulk_time[2])
		end
	end

	if not arg_2_2.plague_wave_data then
		arg_2_2.plague_wave_data = {
			plague_wave_timer = arg_2_3 + var_2_4,
			physics_world = World.get_data(arg_2_2.world, "physics_world"),
			target_starting_pos = Vector3Box(),
			plague_wave_rot = QuaternionBox()
		}
	end

	arg_2_2.health_extension = ScriptUnit.extension(arg_2_1, "health_system")
	arg_2_2.teleport_health_percent = arg_2_2.health_extension:current_health_percent() - var_2_0.part_hp_lost_to_teleport
	arg_2_2.travel_teleport_timer = arg_2_3 + ConflictUtils.random_interval(var_2_0.teleport_cooldown)
	arg_2_2.face_target_while_summoning = true
	arg_2_2.summon_vo_timer = arg_2_2.summon_vo_timer or arg_2_3
	arg_2_2.initial_skulk_finished = true

	if not arg_2_2.played_foreshadow then
		local var_2_5 = Managers.state.entity:system("audio_system")
		local var_2_6 = var_2_0.skulk_foreshadowing_sound

		var_2_5:play_audio_unit_event(var_2_6, arg_2_1)

		arg_2_2.played_foreshadow = true
	end
end

var_0_0.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = arg_3_2.skulk_data
	local var_3_1 = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)
	local var_3_2 = arg_3_2.navigation_extension

	var_3_2:set_max_speed(var_3_1)

	if arg_3_4 == "aborted" then
		local var_3_3 = var_3_2:is_following_path()

		if arg_3_2.move_pos and var_3_3 and arg_3_2.move_state == "idle" then
			arg_3_0:start_move_animation(arg_3_1, arg_3_2)
		end
	end

	if arg_3_2.played_foreshadow then
		local var_3_4 = Managers.state.entity:system("audio_system")
		local var_3_5 = arg_3_2.action.skulk_foreshadowing_sound_stop

		var_3_4:play_audio_unit_event(var_3_5, arg_3_1)
	end

	var_3_0.animation_state = nil
	arg_3_2.action = nil

	if arg_3_4 == "failed" then
		arg_3_2.target_unit = nil
	end
end

var_0_0.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if not AiUtils.is_of_interest_plague_wave_sorcerer(arg_4_2.target_unit) then
		return "failed"
	end

	local var_4_0 = arg_4_2.navigation_extension
	local var_4_1 = var_4_0:is_following_path()
	local var_4_2 = var_4_0:number_failed_move_attempts()
	local var_4_3 = arg_4_2.action
	local var_4_4 = arg_4_2.plague_wave_data
	local var_4_5 = arg_4_2.skulk_data
	local var_4_6 = arg_4_2.target_unit

	if arg_4_2.move_pos and var_4_1 and arg_4_2.move_state == "idle" then
		arg_4_0:start_move_animation(arg_4_1, arg_4_2)
	end

	if arg_4_2.health_extension:current_health_percent() < arg_4_2.teleport_health_percent then
		local var_4_7 = var_0_1[arg_4_1]
		local var_4_8 = math.random() * 5 + math.random() * 5 + math.random() * 5
		local var_4_9 = var_4_8 * 0.5 + 10
		local var_4_10 = 5
		local var_4_11 = ConflictUtils.get_spawn_pos_on_circle(arg_4_2.nav_world, var_4_7, var_4_9, var_4_8, var_4_10)

		if var_4_11 then
			arg_4_2.quick_teleport_exit_pos = Vector3Box(var_4_11)
			arg_4_2.quick_teleport = true
			var_4_5.direction = nil
			arg_4_2.move_pos = nil

			return "done"
		end
	end

	if arg_4_2.vanish_timer and arg_4_3 < arg_4_2.vanish_timer then
		Managers.state.entity:system("ping_system"):remove_ping_from_unit(arg_4_1)

		return "running"
	end

	if arg_4_3 > arg_4_2.travel_teleport_timer then
		local var_4_12 = arg_4_0:get_skulk_target(arg_4_1, arg_4_2, true)

		if var_4_12 then
			arg_4_2.quick_teleport_exit_pos = Vector3Box(var_4_12)
			arg_4_2.quick_teleport = true
			arg_4_2.move_pos = nil

			return "done"
		end
	end

	if arg_4_2.vanish_countdown and arg_4_3 > arg_4_2.vanish_countdown and arg_4_0:vanish(arg_4_1, arg_4_2, arg_4_3) then
		return "done"
	end

	if arg_4_3 > var_4_4.plague_wave_timer and not ScriptUnit.extension(var_4_6, "status_system"):is_invisible() then
		local var_4_13 = arg_4_0:get_plague_wave_cast_position(arg_4_1, arg_4_2, arg_4_2.plague_wave_data)

		if var_4_13 then
			local var_4_14 = 6

			if var_4_3.skulk_time then
				var_4_14 = math.random(var_4_3.skulk_time[1], var_4_3.skulk_time[2])
			end

			arg_4_2.face_player_when_teleporting = true
			arg_4_2.quick_teleport_exit_pos = Vector3Box(var_4_13)
			arg_4_2.quick_teleport = true
			arg_4_2.move_pos = nil
			arg_4_2.vanish_countdown = arg_4_3 + var_4_3.vanish_countdown
			var_4_4.plague_wave_timer = arg_4_3 + var_4_14
			arg_4_2.ready_to_summon = true
			arg_4_2.num_plague_waves = arg_4_2.num_plague_waves and arg_4_2.num_plague_waves + 1 or 1

			if arg_4_2.num_plague_waves >= 4 then
				arg_4_2.num_plague_waves = 0
			end

			if arg_4_2.played_foreshadow then
				local var_4_15 = Managers.state.entity:system("audio_system")
				local var_4_16 = var_4_3.skulk_foreshadowing_sound_stop

				var_4_15:play_audio_unit_event(var_4_16, arg_4_1)
			end

			return "done"
		end
	end

	if arg_4_2.move_pos then
		if arg_4_0:at_goal(arg_4_1, arg_4_2) or var_4_2 > 0 then
			arg_4_2.move_pos = nil
		end

		return "running"
	end

	local var_4_17 = arg_4_0:get_skulk_target(arg_4_1, arg_4_2)

	if var_4_17 then
		arg_4_0:move_to(var_4_17, arg_4_1, arg_4_2)

		return "running"
	end

	if arg_4_2.move_state ~= "idle" then
		arg_4_0:idle(arg_4_1, arg_4_2)
	end

	return "running"
end

var_0_0.at_goal = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_2.move_pos
	local var_5_1 = var_0_1[arg_5_1]

	if not var_5_0 then
		return false
	end

	local var_5_2 = var_5_0:unbox()

	if Vector3.distance_squared(var_5_1, var_5_2) < 0.25 then
		return true
	end
end

var_0_0.move_to = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_3.navigation_extension:move_to(arg_6_1)

	arg_6_3.move_pos = Vector3Box(arg_6_1)
end

var_0_0.vanish = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_2.action
	local var_7_1 = BTNinjaVanishAction.find_escape_position(arg_7_1, arg_7_2)

	if var_7_1 then
		arg_7_2.quick_teleport_exit_pos = Vector3Box(var_7_1)
		arg_7_2.quick_teleport = true
		arg_7_2.move_pos = nil
		arg_7_2.vanish_countdown = nil
		arg_7_2.vanish_timer = arg_7_3 + var_7_0.vanish_timer

		arg_7_2.navigation_extension:move_to(var_7_1)
		arg_7_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

		return true
	end

	return false
end

var_0_0.idle = function (arg_8_0, arg_8_1, arg_8_2)
	arg_8_0:anim_event(arg_8_1, arg_8_2, "idle")

	arg_8_2.move_state = "idle"
end

var_0_0.start_move_animation = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_2.action.move_animation

	arg_9_0:anim_event(arg_9_1, arg_9_2, var_9_0)

	arg_9_2.move_state = "moving"
end

var_0_0.anim_event = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = arg_10_2.skulk_data

	if var_10_0.animation_state ~= arg_10_3 then
		Managers.state.network:anim_event(arg_10_1, arg_10_3)

		var_10_0.animation_state = arg_10_3
	end
end

local var_0_2 = false

var_0_0.get_plague_wave_cast_position = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = arg_11_2.action
	local var_11_1 = arg_11_2.nav_world
	local var_11_2 = arg_11_2.target_unit
	local var_11_3 = var_0_1[var_11_2]
	local var_11_4 = LocomotionUtils.pos_on_mesh(var_11_1, var_11_3, 1, 1)
	local var_11_5 = Vector3.distance
	local var_11_6 = var_11_0.min_wave_distance
	local var_11_7 = var_11_0.max_wave_distance

	if arg_11_2.num_plague_waves and arg_11_2.num_plague_waves >= 3 then
		var_11_7 = var_11_0.third_wave_max_distance
		var_11_6 = var_11_0.third_wave_min_distance
	end

	local var_11_8 = (var_11_7 + var_11_6) / 2
	local var_11_9 = math.pi
	local var_11_10
	local var_11_11 = var_11_4

	if not var_11_11 then
		local var_11_12 = GwNavQueries.inside_position_from_outside_position(var_11_1, var_11_3, 6, 6, 8, 0.5)

		if var_11_12 then
			var_11_11 = var_11_12
		end
	end

	if var_11_11 then
		local var_11_13 = math.random(0, 360) * var_11_9 / 180
		local var_11_14 = Vector3(math.sin(var_11_13), math.cos(var_11_13), 0)
		local var_11_15 = var_11_3 + var_11_14 * var_11_7

		if var_11_15 then
			local var_11_16, var_11_17 = GwNavQueries.raycast(var_11_1, var_11_11, var_11_15)

			if var_11_17 then
				local var_11_18 = var_11_5(var_11_17, var_11_3)

				if var_11_6 < var_11_18 and var_11_18 < var_11_7 then
					local var_11_19 = var_11_3 + var_11_14 * math.random(var_11_6, var_11_18)

					if var_11_8 <= var_11_18 then
						var_11_19 = var_11_3 + var_11_14 * math.random(var_11_8, var_11_18)
					end

					local var_11_20 = LocomotionUtils.pos_on_mesh(var_11_1, var_11_19, 1, 1)

					if var_11_20 then
						local var_11_21 = Vector3.normalize(var_11_11 - var_11_20)
						local var_11_22 = Quaternion.look(var_11_21)

						var_11_10 = var_11_20

						arg_11_3.plague_wave_rot:store(var_11_22)
						arg_11_3.target_starting_pos:store(var_11_11)
					end
				end
			end
		end
	end

	return var_11_10
end

local var_0_3 = 15

var_0_0.get_skulk_target = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = arg_12_2.action
	local var_12_1 = arg_12_2.nav_world
	local var_12_2 = arg_12_2.skulk_data
	local var_12_3 = var_12_2.direction
	local var_12_4 = arg_12_2.target_unit

	if not var_12_4 then
		return
	end

	local var_12_5 = var_0_1[var_12_4]
	local var_12_6 = var_0_1[arg_12_1]
	local var_12_7 = arg_12_2.target_dist
	local var_12_8 = var_12_6 - var_12_5
	local var_12_9 = Vector3.normalize(var_12_8)

	if arg_12_2.is_close then
		if var_12_7 < (var_12_0.preferred_distance or 20) then
			var_12_8 = var_12_8 + var_12_9 * (1 + math.random())
		else
			arg_12_2.is_close = false
			var_12_8 = var_12_8 + var_12_9
		end
	elseif var_12_7 < (var_12_0.close_distance or 20) then
		arg_12_2.is_close = true
		var_12_8 = var_12_8 + var_12_9
	end

	local var_12_10 = Vector3(0, 0, var_12_3)
	local var_12_11 = 0.1
	local var_12_12 = math.pi * math.clamp(var_12_11 * 20 / var_12_7, 0.01, 0.15)

	if arg_12_3 then
		var_12_12 = var_12_12 * 1.5
	end

	for iter_12_0 = 1, var_0_3 do
		local var_12_13 = var_12_8 - var_12_9 * 0.5
		local var_12_14 = var_12_5 + Quaternion.rotate(Quaternion(var_12_10, var_12_12 * iter_12_0), var_12_13)
		local var_12_15 = ConflictUtils.find_center_tri(var_12_1, var_12_14)

		if var_12_15 then
			return var_12_15
		end
	end

	var_12_2.direction = var_12_2.direction * -1
end
