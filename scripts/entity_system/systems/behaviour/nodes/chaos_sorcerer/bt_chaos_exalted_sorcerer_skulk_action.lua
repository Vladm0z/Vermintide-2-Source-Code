-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/bt_chaos_exalted_sorcerer_skulk_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTChaosExaltedSorcererSkulkAction = class(BTChaosExaltedSorcererSkulkAction, BTNode)
BTChaosExaltedSorcererSkulkAction.name = "BTChaosExaltedSorcererSkulkAction"

local var_0_0 = BTChaosExaltedSorcererSkulkAction
local var_0_1 = Unit.alive
local var_0_2 = POSITION_LOOKUP

function var_0_0.init(arg_1_0, ...)
	var_0_0.super.init(arg_1_0, ...)

	arg_1_0.cover_points_broadphase = Managers.state.conflict.level_analysis.cover_points_broadphase
end

function var_0_0.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data
	local var_2_1 = arg_2_2.breed
	local var_2_2 = arg_2_2.target_dist
	local var_2_3 = arg_2_2.skulk_data or {}

	arg_2_2.skulk_data = var_2_3
	var_2_3.direction = var_2_3.direction or 1 - math.random(0, 1) * 2
	var_2_3.radius = var_2_3.radius or arg_2_2.target_dist
	arg_2_2.action = var_2_0

	if arg_2_2.move_state ~= "idle" then
		arg_2_0:idle(arg_2_1, arg_2_2)
	end

	arg_2_2.navigation_extension:set_max_speed(var_2_1.run_speed)
	LocomotionUtils.set_animation_driven_movement(arg_2_1, false)

	if arg_2_2.move_pos then
		local var_2_4 = arg_2_2.move_pos:unbox()

		arg_2_0:move_to(var_2_4, arg_2_1, arg_2_2)
	end

	arg_2_2.ready_to_summon = false
	arg_2_2.num_summons = arg_2_2.num_summons or 0
	arg_2_2.health_extension = ScriptUnit.extension(arg_2_1, "health_system")
	arg_2_2.teleport_health_percent = arg_2_2.health_extension:current_health_percent() - var_2_0.part_hp_lost_to_teleport
	arg_2_2.travel_teleport_timer = arg_2_3 + ConflictUtils.random_interval(var_2_0.teleport_cooldown)

	local var_2_5 = var_2_0.available_spells
	local var_2_6 = var_2_5[Math.random(1, #var_2_5)]
	local var_2_7 = arg_2_2.spells_lookup[var_2_6]

	arg_2_2.current_spell = var_2_7
	arg_2_2.current_spell_name = var_2_7.name
	arg_2_2.face_target_while_summoning = true
end

function var_0_0.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = arg_3_2.skulk_data
	local var_3_1 = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)
	local var_3_2 = arg_3_2.navigation_extension

	var_3_2:set_max_speed(var_3_1)

	if arg_3_4 == "aborted" then
		local var_3_3 = var_3_2:is_following_path()

		if arg_3_2.move_pos and var_3_3 and arg_3_2.move_state == "idle" then
			arg_3_0:start_move_animation(arg_3_1, arg_3_2)
		end

		local var_3_4 = Managers.state.difficulty:get_difficulty()

		arg_3_2.done_casting_timer = arg_3_3 + arg_3_2.action.after_casting_delay[var_3_4]
	end

	var_3_0.animation_state = nil
	arg_3_2.action = nil
end

function var_0_0.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.navigation_extension
	local var_4_1 = var_4_0:is_following_path()
	local var_4_2 = var_4_0:number_failed_move_attempts()
	local var_4_3 = arg_4_2.action
	local var_4_4 = arg_4_2.current_spell

	if arg_4_3 > arg_4_2.done_casting_timer and var_4_4 and var_4_4.search_func(arg_4_0, arg_4_1, arg_4_2, arg_4_3, var_4_4) then
		return "done"
	end

	local var_4_5 = arg_4_2.skulk_data

	if arg_4_2.move_pos and var_4_1 and arg_4_2.move_state == "idle" then
		arg_4_0:start_move_animation(arg_4_1, arg_4_2)
	end

	if arg_4_2.health_extension:current_health_percent() < arg_4_2.teleport_health_percent then
		local var_4_6 = var_0_2[arg_4_1]
		local var_4_7 = var_0_2[arg_4_2.target_unit]
		local var_4_8 = var_4_6

		if Vector3.distance_squared(var_4_6, var_4_7) > var_4_3.far_away_from_target_sq then
			local var_4_9 = var_4_7
		end

		local var_4_10 = math.random() * 5 + math.random() * 5 + math.random() * 5
		local var_4_11 = var_4_10 * 0.5 + 10
		local var_4_12 = 5
		local var_4_13 = ConflictUtils.get_spawn_pos_on_circle_with_func(arg_4_2.nav_world, var_4_6, var_4_11, var_4_10, var_4_12, arg_4_2.valid_teleport_pos_func, arg_4_2)

		if var_4_13 then
			arg_4_2.quick_teleport_exit_pos = Vector3Box(var_4_13)
			arg_4_2.quick_teleport = true
			var_4_5.direction = nil
			arg_4_2.move_pos = nil

			return "done"
		end
	elseif arg_4_3 > arg_4_2.travel_teleport_timer then
		local var_4_14 = var_0_0.get_skulk_target(arg_4_1, arg_4_2, true)

		if var_4_14 and arg_4_2.valid_teleport_pos_func(var_4_14, arg_4_2) then
			arg_4_2.quick_teleport_exit_pos = Vector3Box(var_4_14)
			arg_4_2.quick_teleport = true
			arg_4_2.move_pos = nil

			return "done"
		end
	end

	if arg_4_2.move_pos then
		if arg_4_0:at_goal(arg_4_1, arg_4_2) or var_4_2 > 0 then
			arg_4_2.move_pos = nil
		end

		return "running"
	end

	local var_4_15 = var_0_0.get_skulk_target(arg_4_1, arg_4_2)

	if var_4_15 then
		arg_4_0:move_to(var_4_15, arg_4_1, arg_4_2)

		return "running"
	end

	if arg_4_2.move_state ~= "idle" then
		arg_4_0:idle(arg_4_1, arg_4_2)
	end

	return "running"
end

function var_0_0.at_goal(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_2.skulk_data
	local var_5_1 = arg_5_2.move_pos

	if not var_5_1 then
		return false
	end

	local var_5_2 = var_5_1:unbox()

	if Vector3.distance_squared(var_5_2, var_0_2[arg_5_1]) < 0.25 then
		return true
	end
end

function var_0_0.move_to(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_3.navigation_extension:move_to(arg_6_1)

	arg_6_3.move_pos = Vector3Box(arg_6_1)
end

function var_0_0.idle(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0:anim_event(arg_7_1, arg_7_2, "idle")

	arg_7_2.move_state = "idle"
end

function var_0_0.start_move_animation(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_2.action.move_animation

	arg_8_0:anim_event(arg_8_1, arg_8_2, var_8_0)

	arg_8_2.move_state = "moving"
end

function var_0_0.anim_event(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = arg_9_2.skulk_data

	if var_9_0.animation_state ~= arg_9_3 then
		Managers.state.network:anim_event(arg_9_1, arg_9_3)

		var_9_0.animation_state = arg_9_3
	end
end

local var_0_3 = 15

function var_0_0.get_skulk_target(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_1.action
	local var_10_1 = arg_10_1.nav_world
	local var_10_2 = arg_10_1.skulk_data
	local var_10_3 = var_10_2.direction
	local var_10_4 = arg_10_1.target_unit
	local var_10_5 = var_0_2[var_10_4]
	local var_10_6 = var_0_2[arg_10_0]
	local var_10_7 = arg_10_1.target_dist
	local var_10_8 = var_10_6 - var_10_5
	local var_10_9 = Vector3.normalize(var_10_8)
	local var_10_10 = var_10_0.preferred_distance

	if arg_10_1.is_close then
		if var_10_7 < var_10_10 then
			var_10_8 = var_10_8 + var_10_9 * (1 + math.random())
		else
			arg_10_1.is_close = false
			var_10_8 = var_10_8 + var_10_9
		end
	elseif var_10_7 < var_10_0.close_distance then
		arg_10_1.is_close = true
		var_10_8 = var_10_8 + var_10_9
	end

	local var_10_11 = Vector3(0, 0, var_10_3)
	local var_10_12 = 0.1
	local var_10_13 = math.pi * math.clamp(var_10_12 * 20 / var_10_7, 0.01, 0.15)

	if arg_10_2 then
		var_10_13 = var_10_13 * 1.5
	end

	for iter_10_0 = 1, var_0_3 do
		local var_10_14 = var_10_8 - var_10_9 * 0.5

		if arg_10_1.num_summons and arg_10_1.num_summons >= (var_10_0.teleport_closer_summon_limit or 3) then
			var_10_14 = Vector3.normalize(var_10_5 - var_10_6) * var_10_0.teleport_closer_range
		end

		local var_10_15 = var_10_5 + Quaternion.rotate(Quaternion(var_10_11, var_10_13 * iter_10_0), var_10_14)
		local var_10_16 = ConflictUtils.find_center_tri(var_10_1, var_10_15)

		if var_10_16 then
			return var_10_16
		end
	end

	var_10_2.direction = var_10_2.direction * -1
end

function var_0_0.debug_show_skulk_circle(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_2.action
	local var_11_1 = arg_11_2.skulk_data
	local var_11_2 = var_11_1.radius
	local var_11_3 = arg_11_2.target_unit
	local var_11_4 = var_0_2[var_11_3]
	local var_11_5 = Vector3.up() * 0.2

	QuickDrawer:circle(var_11_4 + var_11_5, arg_11_2.target_dist, Vector3.up(), Colors.get("light_green"))
	QuickDrawer:circle(var_11_4 + var_11_5, var_11_1.radius, Vector3.up(), Colors.get("light_green"))

	var_11_1.radius = arg_11_2.target_dist
end

function var_0_0.update_dummy(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	return false
end

function var_0_0.update_plague_wave(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	local var_13_0 = arg_13_2.target_unit
	local var_13_1 = BTChaosSorcererPlagueSkulkAction.get_plague_wave_cast_position(arg_13_0, arg_13_1, arg_13_2, arg_13_4)

	if var_13_1 and arg_13_2.valid_teleport_pos_func(var_13_1, arg_13_2) then
		arg_13_2.face_player_when_teleporting = true
		arg_13_2.quick_teleport_exit_pos = Vector3Box(var_13_1)
		arg_13_2.quick_teleport = true
		arg_13_2.move_pos = nil
		arg_13_2.ready_to_summon = true
		arg_13_2.num_plague_waves = arg_13_2.num_plague_waves and arg_13_2.num_plague_waves + 1 or 1

		if arg_13_2.num_plague_waves >= 4 then
			arg_13_2.num_plague_waves = 0
		end

		return true
	end
end

function var_0_0.update_cast_missile(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	local var_14_0 = Vector3.copy(var_0_2[arg_14_1])
	local var_14_1 = LocomotionUtils.rotation_towards_unit_flat(arg_14_1, arg_14_2.target_unit)
	local var_14_2, var_14_3, var_14_4 = unpack(arg_14_2.action.missile_spawn_offset)
	local var_14_5 = Vector3(var_14_2, var_14_3, var_14_4)
	local var_14_6 = var_14_0 + Quaternion.rotate(var_14_1, var_14_5)

	var_14_0.z = var_14_6.z

	local var_14_7 = var_14_6 - var_14_0
	local var_14_8 = Vector3.normalize(var_14_7)
	local var_14_9 = Vector3.length(var_14_7)
	local var_14_10 = arg_14_2.world
	local var_14_11 = World.get_data(var_14_10, "physics_world")

	if PhysicsWorld.immediate_raycast(var_14_11, var_14_0, var_14_8, var_14_9, "closest", "collision_filter", "filter_enemy_ray_projectile") then
		return false
	end

	arg_14_2.ready_to_summon = true

	return true
end
