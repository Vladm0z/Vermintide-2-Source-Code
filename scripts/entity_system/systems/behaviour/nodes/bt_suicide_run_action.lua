-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_suicide_run_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTSuicideRunAction = class(BTSuicideRunAction, BTNode)
BTSuicideRunAction.StateInit = class(BTSuicideRunAction.StateInit)
BTSuicideRunAction.StateMove = class(BTSuicideRunAction.StateMove)
BTSuicideRunAction.StateExplode = class(BTSuicideRunAction.StateExplode)

BTSuicideRunAction.init = function (self, ...)
	-- function 1
	BTSuicideRunAction.super.init(self, ...)
end

BTSuicideRunAction.name = "BTSuicideRunAction"

local position_lookup = POSITION_LOOKUP
local UPDATE_MOVE_INTERVAL = 0.25

BTSuicideRunAction.enter = function (self, unit, blackboard, t)
	-- function 2
	local suicide_run_2 = blackboard.suicide_run

	suicide_run_2 = not not suicide_run_2 or not not {}
	blackboard.suicide_run = suicide_run_2

	local action = self._tree_node.action_data
	local suicide_run = blackboard.suicide_run

	suicide_run.action = action
	suicide_run.update_move_timer = 0

	local target = suicide_run.target

	if not target then
		target = blackboard.previous_attacker
		target = not not target or not not blackboard.target_unit
	end

	suicide_run.target = target
	blackboard.target_unit = suicide_run.target

	local params = {
		unit = unit,
		blackboard = blackboard,
		action = action
	}

	blackboard.suicide_run.state_machine = StateMachine:new(self, BTSuicideRunAction.StateInit, params)
	blackboard.action = action

	aiprint("BTSuicideRunAction: StateMachine created")

	if not suicide_run.target then
		aiprint("BTSuicideRunAction: suicide_run.instant_explode")

		suicide_run.instant_explode = true

		return
	end

	local dialogue_input = ScriptUnit.extension_input(unit, "dialogue_system")
	local event_data = FrameTable.alloc_table()

	event_data.attack_tag = "pwg_suicide_run"

	dialogue_input:trigger_networked_dialogue_event("enemy_attack", event_data)
	Managers.state.entity:system("surrounding_aware_system"):add_system_event(unit, "enemy_attack", DialogueSettings.suicide_run_broadcast_range, "attack_tag", "pwg_suicide_run")
end

BTSuicideRunAction.leave = function (self, unit, blackboard, t, reason, destroy)
	-- function 3
	local default_move_speed = AiUtils.get_default_breed_move_speed(unit, blackboard)
	local navigation_extension = blackboard.navigation_extension

	navigation_extension:set_max_speed(default_move_speed)

	blackboard.anim_cb_move = nil
	blackboard.attack_finished = nil
end

BTSuicideRunAction.update_target_position = function (self, unit, blackboard, ai_navigation, stop)
	-- function 4
	local target_unit = blackboard.target_unit

	if ALIVE[target_unit] and not stop then
		local whereabouts_extension = ScriptUnit.has_extension(target_unit, "whereabouts_system")

		if whereabouts_extension then
			local last_position_on_navmesh = whereabouts_extension:last_position_on_navmesh()

			if last_position_on_navmesh then
				ai_navigation:move_to(last_position_on_navmesh)

				return
			end
		else
			local pos = POSITION_LOOKUP[target_unit]
			local success, z = GwNavQueries.triangle_from_position(ai_navigation:nav_world(), pos, 5, 5)

			if success then
				ai_navigation:move_to(Vector3(pos[1], pos[2], z))

				return
			end
		end
	end

	ai_navigation:stop()
end

BTSuicideRunAction.play_unit_audio = function (self, unit, blackboard, sound_name)
	-- function 5
	Managers.state.entity:system("audio_system"):play_audio_unit_event(sound_name, unit)
end

BTSuicideRunAction.run = function (self, unit, blackboard, t, dt)
	-- function 6
	local suicide_run = blackboard.suicide_run

	if not suicide_run.state_machine then
		aiprint("BTSuicideRunAction: StateMachine lost?!?")
	end

	suicide_run.state_machine:update(dt, t)

	if suicide_run.done then
		return "done"
	else
		return "running"
	end
end

BTSuicideRunAction.StateInit.on_enter = function (self, params)
	-- function 7
	local unit = params.unit
	local blackboard = params.blackboard
	local action = params.action
	local locomotion_extension = blackboard.locomotion_extension

	locomotion_extension:set_rotation_speed(5)

	local ai_navigation_extension = blackboard.navigation_extension
	local position = position_lookup[unit]

	ai_navigation_extension:move_to(position)

	if not blackboard.explode_timer_started then
		Managers.state.network:anim_event(unit, "suicide_run_start")
	end

	self.unit = unit
	self.blackboard = blackboard
end

BTSuicideRunAction.StateInit.update = function (self, dt, t)
	-- function 8
	local unit = self.unit
	local blackboard = self.blackboard
	local suicide_run = blackboard.suicide_run
	local no_target = false

	if Unit.alive(blackboard.target_unit) then
		local rotation = LocomotionUtils.rotation_towards_unit_flat(unit, blackboard.target_unit)
		local locomotion_extension = blackboard.locomotion_extension

		locomotion_extension:set_wanted_rotation(rotation)
	else
		no_target = true
	end

	local anim_cb_move = blackboard.anim_cb_move

	if not anim_cb_move then
		-- Nothing
	end

	anim_cb_move = blackboard.explode_timer_started

	local init_done = anim_cb_move

	::label_8_0::

	if init_done then
		return BTSuicideRunAction.StateMove
	end

	local instant_explode_2 = suicide_run.instant_explode

	if not instant_explode_2 then
		-- Nothing
	end

	instant_explode_2 = no_target

	local instant_explode = instant_explode_2

	::label_8_1::

	if instant_explode then
		return BTSuicideRunAction.StateExplode
	end
end

BTSuicideRunAction.StateMove.on_enter = function (self, params)
	-- function 9
	local unit = params.unit
	local blackboard = params.blackboard
	local sound_name = "Play_enemy_globadier_suicide_start"

	self.parent:play_unit_audio(unit, blackboard, sound_name)
	Managers.state.network:anim_event(unit, "move_fwd_run")

	blackboard.move_state = "moving"

	local breed = blackboard.breed
	local run_speed = breed.run_speed
	local ai_navigation_extension = blackboard.navigation_extension

	ai_navigation_extension:set_max_speed(run_speed)

	blackboard.explode_timer_started = true
	self.unit = unit
	self.blackboard = blackboard
	self.explode_timer = blackboard.suicide_run.action.suicide_explosion_timer
end

BTSuicideRunAction.StateMove.update = function (self, dt, t)
	-- function 10
	local unit = self.unit
	local blackboard = self.blackboard
	local suicide_run = blackboard.suicide_run
	local ai_navigation = blackboard.navigation_extension

	suicide_run.update_move_timer = suicide_run.update_move_timer - dt

	if suicide_run.update_move_timer <= 0 then
		self.parent:update_target_position(unit, blackboard, ai_navigation)

		suicide_run.update_move_timer = UPDATE_MOVE_INTERVAL
	end

	self.explode_timer = self.explode_timer - dt

	local has_reached_destination = ai_navigation:has_reached_destination(suicide_run.action.distance_to_explode)

	if not has_reached_destination then
		-- Nothing
	end

	if not (self.explode_timer < 0) then
		has_reached_destination = false

		goto label_10_0
	end

	has_reached_destination = true

	local move_done = has_reached_destination

	::label_10_0::

	local proximity_target, proximity = PerceptionUtils.pick_closest_target(unit, blackboard, blackboard.breed)

	if move_done or proximity < 2 or blackboard.no_path_found then
		return BTSuicideRunAction.StateExplode
	end
end

BTSuicideRunAction.StateExplode.on_enter = function (self, params)
	-- function 11
	local unit = params.unit
	local blackboard = params.blackboard
	local suicide_run = blackboard.suicide_run

	suicide_run.explosion_started = true

	local ai_navigation_extension = blackboard.navigation_extension

	self.parent:update_target_position(unit, blackboard, ai_navigation_extension, true)
	Managers.state.network:anim_event(unit, "attack_foff_self")

	self.unit = unit
	self.blackboard = blackboard
end

BTSuicideRunAction.StateExplode.update = function (self, dt, t)
	-- function 12
	local unit = self.unit
	local blackboard = self.blackboard
	local suicide_run = blackboard.suicide_run
	local ready_to_explode = blackboard.attack_finished

	if not ready_to_explode then
		return
	end

	AiUtils.kill_unit(unit)

	suicide_run.done = true
end
