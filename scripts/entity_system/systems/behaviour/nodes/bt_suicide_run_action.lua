-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_suicide_run_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTSuicideRunAction = class(BTSuicideRunAction, BTNode)
BTSuicideRunAction.StateInit = class(BTSuicideRunAction.StateInit)
BTSuicideRunAction.StateMove = class(BTSuicideRunAction.StateMove)
BTSuicideRunAction.StateExplode = class(BTSuicideRunAction.StateExplode)

BTSuicideRunAction.init = function (arg_1_0, ...)
	-- function 1
	BTSuicideRunAction.super.init(arg_1_0, ...)
end

BTSuicideRunAction.name = "BTSuicideRunAction"

local POSITION_LOOKUP = POSITION_LOOKUP
local num = 0.25

BTSuicideRunAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local suicide_run = arg_2_2.suicide_run

	suicide_run = suicide_run or {}
	arg_2_2.suicide_run = suicide_run

	local action_data = self._tree_node.action_data
	local suicide_run_2 = arg_2_2.suicide_run

	suicide_run_2.action = action_data
	suicide_run_2.update_move_timer = 0

	local target = suicide_run_2.target

	if not target then
		target = arg_2_2.previous_attacker
		target = target or arg_2_2.target_unit
	end

	suicide_run_2.target = target
	arg_2_2.target_unit = suicide_run_2.target

	local tbl = {
		unit = arg_2_1,
		blackboard = arg_2_2,
		action = action_data
	}

	arg_2_2.suicide_run.state_machine = StateMachine:new(self, BTSuicideRunAction.StateInit, tbl)
	arg_2_2.action = action_data

	aiprint("BTSuicideRunAction: StateMachine created")

	if not suicide_run_2.target then
		aiprint("BTSuicideRunAction: suicide_run.instant_explode")

		suicide_run_2.instant_explode = true

		return
	end

	local extension_input = ScriptUnit.extension_input(arg_2_1, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	alloc_table.attack_tag = "pwg_suicide_run"

	extension_input:trigger_networked_dialogue_event("enemy_attack", alloc_table)
	Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_2_1, "enemy_attack", DialogueSettings.suicide_run_broadcast_range, "attack_tag", "pwg_suicide_run")
end

BTSuicideRunAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)

	arg_3_2.navigation_extension:set_max_speed(get_default_breed_move_speed)

	arg_3_2.anim_cb_move = nil
	arg_3_2.attack_finished = nil
end

BTSuicideRunAction.update_target_position = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local target_unit = arg_4_2.target_unit

	if not (not ALIVE[target_unit] and arg_4_4) then
		local has_extension = ScriptUnit.has_extension(target_unit, "whereabouts_system")

		if not has_extension then
			local last_position_on_navmesh = has_extension:last_position_on_navmesh()

			if not last_position_on_navmesh then
				arg_4_3:move_to(last_position_on_navmesh)

				return
			end
		else
			local var_4_3 = POSITION_LOOKUP[target_unit]
			local triangle_from_position, var_4_5 = GwNavQueries.triangle_from_position(arg_4_3:nav_world(), var_4_3, 5, 5)

			if not triangle_from_position then
				arg_4_3:move_to(Vector3(var_4_3[1], var_4_3[2], var_4_5))

				return
			end
		end
	end

	arg_4_3:stop()
end

BTSuicideRunAction.play_unit_audio = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	Managers.state.entity:system("audio_system"):play_audio_unit_event(arg_5_3, arg_5_1)
end

BTSuicideRunAction.run = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local suicide_run = arg_6_2.suicide_run

	if not suicide_run.state_machine then
		aiprint("BTSuicideRunAction: StateMachine lost?!?")
	end

	suicide_run.state_machine:update(arg_6_4, arg_6_3)

	if not suicide_run.done then
		return "done"
	else
		return "running"
	end
end

BTSuicideRunAction.StateInit.on_enter = function (self, arg_7_1)
	-- function 7
	local unit = arg_7_1.unit
	local blackboard = arg_7_1.blackboard
	local action = arg_7_1.action

	blackboard.locomotion_extension:set_rotation_speed(5)

	local navigation_extension = blackboard.navigation_extension
	local var_7_4 = POSITION_LOOKUP[unit]

	navigation_extension:move_to(var_7_4)

	if not blackboard.explode_timer_started then
		Managers.state.network:anim_event(unit, "suicide_run_start")
	end

	self.unit = unit
	self.blackboard = blackboard
end

BTSuicideRunAction.StateInit.update = function (self, arg_8_1, arg_8_2)
	-- function 8
	local unit = self.unit
	local blackboard = self.blackboard
	local suicide_run = blackboard.suicide_run
	local flag = false

	if not Unit.alive(blackboard.target_unit) then
		local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(unit, blackboard.target_unit)

		blackboard.locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)
	else
		flag = true
	end

	local anim_cb_move = blackboard.anim_cb_move

	anim_cb_move = anim_cb_move or blackboard.explode_timer_started

	if not anim_cb_move then
		return BTSuicideRunAction.StateMove
	end

	local instant_explode = suicide_run.instant_explode

	instant_explode = instant_explode or flag

	if not instant_explode then
		return BTSuicideRunAction.StateExplode
	end
end

BTSuicideRunAction.StateMove.on_enter = function (self, arg_9_1)
	-- function 9
	local unit = arg_9_1.unit
	local blackboard = arg_9_1.blackboard
	local str = "Play_enemy_globadier_suicide_start"

	self.parent:play_unit_audio(unit, blackboard, str)
	Managers.state.network:anim_event(unit, "move_fwd_run")

	blackboard.move_state = "moving"

	local run_speed = blackboard.breed.run_speed

	blackboard.navigation_extension:set_max_speed(run_speed)

	blackboard.explode_timer_started = true
	self.unit = unit
	self.blackboard = blackboard
	self.explode_timer = blackboard.suicide_run.action.suicide_explosion_timer
end

BTSuicideRunAction.StateMove.update = function (self, arg_10_1, arg_10_2)
	-- function 10
	local unit = self.unit
	local blackboard = self.blackboard
	local suicide_run = blackboard.suicide_run
	local navigation_extension = blackboard.navigation_extension

	suicide_run.update_move_timer = suicide_run.update_move_timer - arg_10_1

	if suicide_run.update_move_timer <= 0 then
		self.parent:update_target_position(unit, blackboard, navigation_extension)

		suicide_run.update_move_timer = num
	end

	self.explode_timer = self.explode_timer - arg_10_1

	local has_reached_destination = navigation_extension:has_reached_destination(suicide_run.action.distance_to_explode)

	has_reached_destination = has_reached_destination or self.explode_timer < 0

	local pick_closest_target, var_10_6 = PerceptionUtils.pick_closest_target(unit, blackboard, blackboard.breed)

	if has_reached_destination or var_10_6 < 2 or not blackboard.no_path_found then
		return BTSuicideRunAction.StateExplode
	end
end

BTSuicideRunAction.StateExplode.on_enter = function (self, arg_11_1)
	-- function 11
	local unit = arg_11_1.unit
	local blackboard = arg_11_1.blackboard

	blackboard.suicide_run.explosion_started = true

	local navigation_extension = blackboard.navigation_extension

	self.parent:update_target_position(unit, blackboard, navigation_extension, true)
	Managers.state.network:anim_event(unit, "attack_foff_self")

	self.unit = unit
	self.blackboard = blackboard
end

BTSuicideRunAction.StateExplode.update = function (self, arg_12_1, arg_12_2)
	-- function 12
	local unit = self.unit
	local blackboard = self.blackboard
	local suicide_run = blackboard.suicide_run

	if not blackboard.attack_finished then
		return
	end

	AiUtils.kill_unit(unit)

	suicide_run.done = true
end
