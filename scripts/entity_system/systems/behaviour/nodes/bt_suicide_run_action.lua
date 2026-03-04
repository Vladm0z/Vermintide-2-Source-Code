-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_suicide_run_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTSuicideRunAction = class(BTSuicideRunAction, BTNode)
BTSuicideRunAction.StateInit = class(BTSuicideRunAction.StateInit)
BTSuicideRunAction.StateMove = class(BTSuicideRunAction.StateMove)
BTSuicideRunAction.StateExplode = class(BTSuicideRunAction.StateExplode)

function BTSuicideRunAction.init(arg_1_0, ...)
	BTSuicideRunAction.super.init(arg_1_0, ...)
end

BTSuicideRunAction.name = "BTSuicideRunAction"

local var_0_0 = POSITION_LOOKUP
local var_0_1 = 0.25

function BTSuicideRunAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.suicide_run = arg_2_2.suicide_run or {}

	local var_2_0 = arg_2_0._tree_node.action_data
	local var_2_1 = arg_2_2.suicide_run

	var_2_1.action = var_2_0
	var_2_1.update_move_timer = 0
	var_2_1.target = var_2_1.target or arg_2_2.previous_attacker or arg_2_2.target_unit
	arg_2_2.target_unit = var_2_1.target

	local var_2_2 = {
		unit = arg_2_1,
		blackboard = arg_2_2,
		action = var_2_0
	}

	arg_2_2.suicide_run.state_machine = StateMachine:new(arg_2_0, BTSuicideRunAction.StateInit, var_2_2)
	arg_2_2.action = var_2_0

	aiprint("BTSuicideRunAction: StateMachine created")

	if not var_2_1.target then
		aiprint("BTSuicideRunAction: suicide_run.instant_explode")

		var_2_1.instant_explode = true

		return
	end

	local var_2_3 = ScriptUnit.extension_input(arg_2_1, "dialogue_system")
	local var_2_4 = FrameTable.alloc_table()

	var_2_4.attack_tag = "pwg_suicide_run"

	var_2_3:trigger_networked_dialogue_event("enemy_attack", var_2_4)
	Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_2_1, "enemy_attack", DialogueSettings.suicide_run_broadcast_range, "attack_tag", "pwg_suicide_run")
end

function BTSuicideRunAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)

	arg_3_2.navigation_extension:set_max_speed(var_3_0)

	arg_3_2.anim_cb_move = nil
	arg_3_2.attack_finished = nil
end

function BTSuicideRunAction.update_target_position(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.target_unit

	if ALIVE[var_4_0] and not arg_4_4 then
		local var_4_1 = ScriptUnit.has_extension(var_4_0, "whereabouts_system")

		if var_4_1 then
			local var_4_2 = var_4_1:last_position_on_navmesh()

			if var_4_2 then
				arg_4_3:move_to(var_4_2)

				return
			end
		else
			local var_4_3 = POSITION_LOOKUP[var_4_0]
			local var_4_4, var_4_5 = GwNavQueries.triangle_from_position(arg_4_3:nav_world(), var_4_3, 5, 5)

			if var_4_4 then
				arg_4_3:move_to(Vector3(var_4_3[1], var_4_3[2], var_4_5))

				return
			end
		end
	end

	arg_4_3:stop()
end

function BTSuicideRunAction.play_unit_audio(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	Managers.state.entity:system("audio_system"):play_audio_unit_event(arg_5_3, arg_5_1)
end

function BTSuicideRunAction.run(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = arg_6_2.suicide_run

	if not var_6_0.state_machine then
		aiprint("BTSuicideRunAction: StateMachine lost?!?")
	end

	var_6_0.state_machine:update(arg_6_4, arg_6_3)

	if var_6_0.done then
		return "done"
	else
		return "running"
	end
end

function BTSuicideRunAction.StateInit.on_enter(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1.unit
	local var_7_1 = arg_7_1.blackboard
	local var_7_2 = arg_7_1.action

	var_7_1.locomotion_extension:set_rotation_speed(5)

	local var_7_3 = var_7_1.navigation_extension
	local var_7_4 = var_0_0[var_7_0]

	var_7_3:move_to(var_7_4)

	if not var_7_1.explode_timer_started then
		Managers.state.network:anim_event(var_7_0, "suicide_run_start")
	end

	arg_7_0.unit = var_7_0
	arg_7_0.blackboard = var_7_1
end

function BTSuicideRunAction.StateInit.update(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0.unit
	local var_8_1 = arg_8_0.blackboard
	local var_8_2 = var_8_1.suicide_run
	local var_8_3 = false

	if Unit.alive(var_8_1.target_unit) then
		local var_8_4 = LocomotionUtils.rotation_towards_unit_flat(var_8_0, var_8_1.target_unit)

		var_8_1.locomotion_extension:set_wanted_rotation(var_8_4)
	else
		var_8_3 = true
	end

	if var_8_1.anim_cb_move or var_8_1.explode_timer_started then
		return BTSuicideRunAction.StateMove
	end

	if var_8_2.instant_explode or var_8_3 then
		return BTSuicideRunAction.StateExplode
	end
end

function BTSuicideRunAction.StateMove.on_enter(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_1.unit
	local var_9_1 = arg_9_1.blackboard
	local var_9_2 = "Play_enemy_globadier_suicide_start"

	arg_9_0.parent:play_unit_audio(var_9_0, var_9_1, var_9_2)
	Managers.state.network:anim_event(var_9_0, "move_fwd_run")

	var_9_1.move_state = "moving"

	local var_9_3 = var_9_1.breed.run_speed

	var_9_1.navigation_extension:set_max_speed(var_9_3)

	var_9_1.explode_timer_started = true
	arg_9_0.unit = var_9_0
	arg_9_0.blackboard = var_9_1
	arg_9_0.explode_timer = var_9_1.suicide_run.action.suicide_explosion_timer
end

function BTSuicideRunAction.StateMove.update(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0.unit
	local var_10_1 = arg_10_0.blackboard
	local var_10_2 = var_10_1.suicide_run
	local var_10_3 = var_10_1.navigation_extension

	var_10_2.update_move_timer = var_10_2.update_move_timer - arg_10_1

	if var_10_2.update_move_timer <= 0 then
		arg_10_0.parent:update_target_position(var_10_0, var_10_1, var_10_3)

		var_10_2.update_move_timer = var_0_1
	end

	arg_10_0.explode_timer = arg_10_0.explode_timer - arg_10_1

	local var_10_4 = var_10_3:has_reached_destination(var_10_2.action.distance_to_explode) or arg_10_0.explode_timer < 0
	local var_10_5, var_10_6 = PerceptionUtils.pick_closest_target(var_10_0, var_10_1, var_10_1.breed)

	if var_10_4 or var_10_6 < 2 or var_10_1.no_path_found then
		return BTSuicideRunAction.StateExplode
	end
end

function BTSuicideRunAction.StateExplode.on_enter(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_1.unit
	local var_11_1 = arg_11_1.blackboard

	var_11_1.suicide_run.explosion_started = true

	local var_11_2 = var_11_1.navigation_extension

	arg_11_0.parent:update_target_position(var_11_0, var_11_1, var_11_2, true)
	Managers.state.network:anim_event(var_11_0, "attack_foff_self")

	arg_11_0.unit = var_11_0
	arg_11_0.blackboard = var_11_1
end

function BTSuicideRunAction.StateExplode.update(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0.unit
	local var_12_1 = arg_12_0.blackboard
	local var_12_2 = var_12_1.suicide_run

	if not var_12_1.attack_finished then
		return
	end

	AiUtils.kill_unit(var_12_0)

	var_12_2.done = true
end
