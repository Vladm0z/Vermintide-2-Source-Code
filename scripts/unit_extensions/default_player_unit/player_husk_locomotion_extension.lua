-- chunkname: @scripts/unit_extensions/default_player_unit/player_husk_locomotion_extension.lua

require("scripts/unit_extensions/default_player_unit/third_person_idle_fullbody_animation_control")

PlayerHuskLocomotionExtension = class(PlayerHuskLocomotionExtension)

local POSITION_LOOKUP = POSITION_LOOKUP

PlayerHuskLocomotionExtension.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	self.world = extension_init_context.world
	self.unit = unit
	self.game = extension_init_data.game
	self.id = extension_init_data.id
	self.player = extension_init_data.player
	self.is_server = Managers.player.is_server
	self.velocity_current = Vector3Box(0, 0, 0)
	self._current_rotation = QuaternionBox(Quaternion.identity())
	self.has_moved_from_start_position = extension_init_data.has_moved_from_start_position
	self.anim_move_speed = 0
	self.move_speed_anim_var = Unit.animation_find_variable(unit, "move_speed")

	Managers.player:assign_unit_ownership(unit, self.player, true)

	local level_settings = LevelHelper:current_level_settings()
	local flow_event = level_settings.on_spawn_flow_event

	if flow_event then
		Unit.flow_event(unit, flow_event)
	end

	local animation_run_variable_id = Unit.animation_find_variable(unit, "anim_run_speed")
	local animation_walk_variable_id = Unit.animation_find_variable(unit, "anim_walk_speed")

	self.movement_scale_animation_id = Unit.animation_find_variable(unit, "movement_scale")
	self.run_speed_treshold = Unit.animation_get_variable(unit, animation_run_variable_id)
	self.walk_speed_treshold = Unit.animation_get_variable(unit, animation_walk_variable_id)

	if self.is_server then
		local nav_cost_map_cost_table = GwNavCostMap.create_tag_cost_table()

		AiUtils.initialize_nav_cost_map_cost_table(nav_cost_map_cost_table, nil, 1)

		self._latest_position_on_navmesh = Vector3Box(Unit.world_position(unit, 0))
		self._nav_world = Managers.state.entity:system("ai_system"):nav_world()
		self._nav_traverse_logic = GwNavTraverseLogic.create(self._nav_world, nav_cost_map_cost_table)
		self._nav_cost_map_cost_table = nav_cost_map_cost_table
	end

	self.third_person_idle_fullbody_animation_control = ThirdPersonIdleFullbodyAnimationControl:new(unit)
end

PlayerHuskLocomotionExtension.destroy = function (self)
	-- function 2
	if self.is_server then
		GwNavCostMap.destroy_tag_cost_table(self._nav_cost_map_cost_table)
		GwNavTraverseLogic.destroy(self._nav_traverse_logic)
	end
end

PlayerHuskLocomotionExtension.current_velocity = function (self)
	-- function 3
	return GameSession.game_object_field(self.game, self.id, "velocity")
end

PlayerHuskLocomotionExtension.average_velocity = function (self)
	-- function 4
	return GameSession.game_object_field(self.game, self.id, "average_velocity")
end

PlayerHuskLocomotionExtension.small_sample_size_average_velocity = function (self)
	-- function 5
	return GameSession.game_object_field(self.game, self.id, "small_sample_size_average_velocity")
end

PlayerHuskLocomotionExtension.get_script_driven_gravity_scale = function (self)
	-- function 6
	return 1
end

PlayerHuskLocomotionExtension.extensions_ready = function (self, world, unit)
	-- function 7
	self.status_extension = ScriptUnit.extension(self.unit, "status_system")

	self.third_person_idle_fullbody_animation_control:extensions_ready(world, unit)
end

PlayerHuskLocomotionExtension.add_external_velocity = function (self, velocity, upper_limit)
	-- function 8
	if not Managers.state.network:game() then
		return
	end

	local str

	if upper_limit then
		str = "rpc_add_external_velocity_with_upper_limit"

		goto label_8_0
	end

	str = "rpc_add_external_velocity"

	local rpc_name = str

	::label_8_0::

	if self.is_server then
		Managers.state.network.network_transmit:send_rpc(rpc_name, self.player:network_id(), self.id, velocity, upper_limit)
	else
		Managers.state.network.network_transmit:send_rpc_server(rpc_name, self.id, velocity, upper_limit)
	end
end

PlayerHuskLocomotionExtension.set_forced_velocity = function (self, velocity_forced)
	-- function 9
	if not self.disabled then
		if self.is_server or DEDICATED_SERVER then
			Managers.state.network.network_transmit:send_rpc("rpc_set_forced_velocity", self.player:network_id(), self.id, velocity_forced)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_set_forced_velocity", self.id, velocity_forced)
		end
	end
end

PlayerHuskLocomotionExtension.set_disabled = function (self, disabled, run_func, master_unit)
	-- function 10
	self._disabled = disabled
	self._run_func = run_func
	self.master_unit = master_unit

	if not disabled then
		local unit = self.unit
		local var_10_0 = POSITION_LOOKUP[unit]

		if not var_10_0 then
			-- Nothing
		end

		var_10_0 = Unit.local_position(unit, 0)

		local pos = var_10_0

		::label_10_0::

		self._pos_lerp_time = 0

		Unit.set_data(unit, "last_lerp_position", pos)
		Unit.set_data(unit, "last_lerp_position_offset", Vector3(0, 0, 0))
		Unit.set_data(unit, "accumulated_movement", Vector3(0, 0, 0))

		local mover = Unit.mover(unit)

		Mover.set_position(mover, pos)
		Unit.set_local_position(unit, 0, pos)
	end
end

PlayerHuskLocomotionExtension.post_update = function (self, unit, input, dt, context, t)
	-- function 11
	if self._disabled then
		return
	end

	local game = Managers.state.network:game()

	if game and GameSession.game_object_exists(game, self.id) then
		if HEALTH_ALIVE[unit] then
			local movement_state = "onground"

			self:update_movement(dt, unit, movement_state)
		end

		self:_update_last_position_on_navmesh()
	end
end

PlayerHuskLocomotionExtension.update = function (self, unit, input, dt, context, t)
	-- function 12
	if self._disabled then
		self._run_func(unit, dt, self)

		return
	end

	local is_on_ladder, ladder_unit = self.status_extension:get_is_on_ladder()

	if is_on_ladder and ladder_unit then
		self:update_ladder_animation_position(ladder_unit)
	end

	self.third_person_idle_fullbody_animation_control:update(t)
end

PlayerHuskLocomotionExtension.last_position_on_navmesh = function (self)
	-- function 13
	assert(self.is_server, "last position on nav mesh is only saved on server")

	return self._latest_position_on_navmesh:unbox()
end

PlayerHuskLocomotionExtension._update_last_position_on_navmesh = function (self)
	-- function 14
	if self.is_server then
		local current_position = GameSession.game_object_field(self.game, self.id, "position")
		local found_nav_mesh, z = GwNavQueries.triangle_from_position(self._nav_world, current_position, 0.1, 0.3, self._nav_traverse_logic)

		if found_nav_mesh then
			self._latest_position_on_navmesh:store(Vector3(current_position.x, current_position.y, current_position.z))
		end
	end
end

local POS_EPSILON = 0.01
local POS_LERP_TIME = 0.1
local POS_LERP_TIME_LINKED = 0.01
local DISCONNECT_GRACE_TIME = 1

PlayerHuskLocomotionExtension.update_movement = function (self, dt, unit, movement_state)
	-- function 15
	local old_pos = Unit.local_position(unit, 0)
	local new_pos
	local linked_movement = GameSession.game_object_field(self.game, self.id, "linked_movement")
	local moving_platform = GameSession.game_object_field(self.game, self.id, "moving_platform")

	if linked_movement then
		local link_parent_is_level_unit = GameSession.game_object_field(self.game, self.id, "link_parent_is_level_unit")
		local link_parent_id = GameSession.game_object_field(self.game, self.id, "link_parent_id")
		local link_node = GameSession.game_object_field(self.game, self.id, "link_node")
		local link_offset = GameSession.game_object_field(self.game, self.id, "link_offset")
		local link_parent_unit = Managers.state.network:game_object_or_level_unit(link_parent_id, link_parent_is_level_unit)

		if Unit.alive(link_parent_unit) then
			new_pos = Unit.world_position(link_parent_unit, link_node) + link_offset
		else
			new_pos = GameSession.game_object_field(self.game, self.id, "position")
		end
	else
		new_pos = GameSession.game_object_field(self.game, self.id, "position")
	end

	local new_yaw = GameSession.game_object_field(self.game, self.id, "yaw")
	local new_pitch = GameSession.game_object_field(self.game, self.id, "pitch")
	local yaw_rotation = Quaternion(Vector3.up(), new_yaw)
	local pitch_rotation = Quaternion(Vector3.right(), new_pitch)
	local new_rot = Quaternion.multiply(yaw_rotation, pitch_rotation)
	local velocity = GameSession.game_object_field(self.game, self.id, "velocity")

	if Vector3.length(velocity) < NetworkConstants.VELOCITY_EPSILON then
		velocity = Vector3(0, 0, 0)
	end

	self.has_moved_from_start_position = GameSession.game_object_field(self.game, self.id, "has_moved_from_start_position")

	self:_extrapolation_movement(unit, dt, old_pos, new_pos, new_rot, movement_state, velocity, linked_movement, moving_platform)
	self.velocity_current:store(velocity)
	self._current_rotation:store(new_rot)
	self:_update_speed_variable(dt)
end

PlayerHuskLocomotionExtension.get_moving_platform = function (self)
	-- function 16
	if not Managers.state.network:game() then
		return
	end

	if GameSession.game_object_exists(self.game, self.id) then
		local moving_platform = GameSession.game_object_field(self.game, self.id, "moving_platform")
		local game_object_or_level_unit

		if moving_platform ~= 0 then
			game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(moving_platform, true)

			if not game_object_or_level_unit then
				-- Nothing
			end
		end

		game_object_or_level_unit = nil

		local platform_unit = game_object_or_level_unit

		::label_16_0::

		local platform_extension = ScriptUnit.has_extension(platform_unit, "transportation_system")
		local game_object_field

		if platform_unit then
			game_object_field = GameSession.game_object_field(self.game, self.id, "moving_platform_soft_linked")

			if not game_object_field then
				-- Nothing
			end
		end

		game_object_field = nil

		local soft_platform = game_object_field

		::label_16_1::

		return platform_unit, platform_extension, soft_platform
	end

	return nil, nil, nil
end

PlayerHuskLocomotionExtension.update_ladder_animation_position = function (self, ladder_unit)
	-- function 17
	local unit = self.unit
	local ladder_pos = Unit.world_position(ladder_unit, 0)
	local time_in_move_animation = CharacterStateHelper.time_in_ladder_move_animation(unit, Vector3.z(ladder_pos))
	local variable_index = Unit.animation_find_variable(unit, "climb_time")

	Unit.animation_set_variable(unit, variable_index, time_in_move_animation)
end

PlayerHuskLocomotionExtension._extrapolation_movement = function (self, unit, dt, old_pos, new_pos, new_rot, movement_state, velocity, linked_movement, moving_platform)
	-- function 18
	local get_data = Unit.get_data(unit, "last_lerp_position")

	if not get_data then
		-- Nothing
	end

	get_data = old_pos

	local last_pos = get_data

	::label_18_0::

	local get_data_2 = Unit.get_data(unit, "last_lerp_position_offset")

	if not get_data_2 then
		-- Nothing
	end

	get_data_2 = Vector3(0, 0, 0)

	local last_pos_offset = get_data_2

	::label_18_1::

	local get_data_3 = Unit.get_data(unit, "accumulated_movement")

	if not get_data_3 then
		-- Nothing
	end

	get_data_3 = Vector3(0, 0, 0)

	local accumulated_movement = get_data_3

	::label_18_2::

	if self._moving_platform ~= moving_platform then
		local _moving_platform = self._moving_platform

		_moving_platform = not not _moving_platform or not not 0

		local last_platform_unit = _moving_platform ~= 0 and not not Managers.state.network:game_object_or_level_unit(self._moving_platform, true)
		local new_platform_unit = moving_platform ~= 0 and not not Managers.state.network:game_object_or_level_unit(moving_platform, true)

		if last_platform_unit and new_platform_unit then
			local last_platform_extension = ScriptUnit.extension(last_platform_unit, "transportation_system")
			local last_moving_platform_pos = Unit.local_position(last_platform_unit, 0) + last_platform_extension:visual_delta()

			last_pos = last_pos + last_moving_platform_pos

			local platform_extension = ScriptUnit.extension(new_platform_unit, "transportation_system")
			local moving_platform_pos = Unit.local_position(new_platform_unit, 0) + platform_extension:visual_delta()

			last_pos = last_pos - moving_platform_pos
		end

		self._moving_platform = moving_platform
	end

	if moving_platform ~= 0 and not linked_movement then
		local moving_platform_unit = Managers.state.network:game_object_or_level_unit(moving_platform, true)
		local moving_platform_pos = Unit.local_position(moving_platform_unit, 0)
		local platform_extension = ScriptUnit.extension(moving_platform_unit, "transportation_system")

		new_pos = new_pos + moving_platform_pos + platform_extension:visual_delta()
	end

	local _pos_lerp_time = self._pos_lerp_time

	_pos_lerp_time = not not _pos_lerp_time or not not 0
	self._pos_lerp_time = _pos_lerp_time + dt

	local _velocity_lerp_time = self._velocity_lerp_time

	_velocity_lerp_time = not not _velocity_lerp_time or not not 0
	self._velocity_lerp_time = _velocity_lerp_time + dt

	local var_18_6

	if linked_movement then
		var_18_6 = POS_LERP_TIME_LINKED

		if not var_18_6 then
			-- Nothing
		end
	end

	var_18_6 = POS_LERP_TIME

	local pos_lerp_time = var_18_6

	::label_18_3::

	local lerp_t = self._pos_lerp_time / pos_lerp_time
	local move_delta = velocity * dt

	accumulated_movement = accumulated_movement + move_delta

	local lerp_pos = Vector3.lerp(last_pos_offset, Vector3(0, 0, 0), math.min(lerp_t, 1))
	local pos = last_pos + accumulated_movement + lerp_pos

	Profiler.record_statistics("move_delta", Vector3.length(move_delta))
	Profiler.record_statistics("husk_speed", Vector3.length(velocity))
	Profiler.record_statistics("dt", dt)
	Unit.set_data(unit, "accumulated_movement", accumulated_movement)

	if Vector3.length(new_pos - last_pos) > POS_EPSILON then
		self._pos_lerp_time = 0

		Unit.set_data(unit, "last_lerp_position", new_pos)
		Unit.set_data(unit, "last_lerp_position_offset", pos - new_pos)
		Unit.set_data(unit, "accumulated_movement", Vector3(0, 0, 0))
	end

	local previous_velocity = self.velocity_current:unbox()

	if Vector3.length(velocity - previous_velocity) > NetworkConstants.VELOCITY_EPSILON then
		self._velocity_lerp_time = 0
	end

	if self._pos_lerp_time > DISCONNECT_GRACE_TIME and self._velocity_lerp_time > DISCONNECT_GRACE_TIME then
		pos = new_pos

		Unit.set_data(unit, "accumulated_movement", Vector3(0, 0, 0))
	end

	local mover = Unit.mover(unit)

	Mover.set_position(mover, pos)
	Unit.set_local_position(unit, 0, pos)

	local old_rot = Unit.local_rotation(unit, 0)

	Unit.set_local_rotation(unit, 0, Quaternion.lerp(old_rot, new_rot, math.min(dt * 15, 1)))
end

local WALK_THRESHOLD = 0.97
local JOG_THRESHOLD = 3.23
local RUN_THRESHOLD = 6.14
local LOWEST_MOVEMENT_ANIMATION_SCALE = 0.3
local HIGHEST_MOVEMENT_ANIMATION_SCALE = 1.5
local MOVE_SPEED_MAX = 99.9999
local MOVE_SPEED_ANIM_LERP_TIME = 0.3

PlayerHuskLocomotionExtension._update_speed_variable = function (self, dt)
	-- function 19
	local velocity = self.velocity_current:unbox()
	local flat_velocity = Vector3(velocity.x, velocity.y, 0)
	local speed = Vector3.length(flat_velocity)
	local move_speed_lerp_val = self.anim_move_speed
	local speed_difference = math.abs(move_speed_lerp_val - speed)

	if move_speed_lerp_val < speed then
		local delta = math.min(speed / MOVE_SPEED_ANIM_LERP_TIME * dt, speed_difference)

		move_speed_lerp_val = math.clamp(move_speed_lerp_val + delta, 0, speed)
		self._move_speed_top = move_speed_lerp_val
	else
		local _move_speed_top = self._move_speed_top

		if not _move_speed_top then
			-- Nothing
		end

		_move_speed_top = speed

		local ms = _move_speed_top

		::label_19_0::

		local delta = math.min(ms / MOVE_SPEED_ANIM_LERP_TIME * dt, speed_difference)

		move_speed_lerp_val = math.clamp(move_speed_lerp_val - delta, 0, move_speed_lerp_val)
	end

	self.anim_move_speed = move_speed_lerp_val

	local unit = self.unit

	Unit.animation_set_variable(unit, self.move_speed_anim_var, math.min(move_speed_lerp_val, MOVE_SPEED_MAX))

	local movement_anim_scale

	if speed < self.walk_speed_treshold then
		movement_anim_scale = speed / self.walk_speed_treshold
	elseif speed > self.run_speed_treshold then
		movement_anim_scale = speed / self.run_speed_treshold
	else
		movement_anim_scale = 1
	end

	movement_anim_scale = math.clamp(movement_anim_scale, LOWEST_MOVEMENT_ANIMATION_SCALE, HIGHEST_MOVEMENT_ANIMATION_SCALE)

	Unit.animation_set_variable(unit, self.movement_scale_animation_id, movement_anim_scale)
end

PlayerHuskLocomotionExtension._calculate_move_speed_var_from_mps = function (self, move_speed)
	-- function 20
	local speed_var
	local speed_multiplier = 1

	if move_speed <= WALK_THRESHOLD then
		speed_var = 0
		speed_multiplier = move_speed / WALK_THRESHOLD
	elseif move_speed <= JOG_THRESHOLD then
		speed_var = (move_speed - WALK_THRESHOLD) / (JOG_THRESHOLD - WALK_THRESHOLD)
	elseif move_speed <= RUN_THRESHOLD then
		speed_var = 1 + (move_speed - JOG_THRESHOLD) / (RUN_THRESHOLD - JOG_THRESHOLD)
	else
		speed_var = 3
		speed_multiplier = move_speed / RUN_THRESHOLD
	end

	return speed_var, speed_multiplier
end

PlayerHuskLocomotionExtension.rpc_animation_set_variable = function (self, index, variable)
	-- function 21
	Unit.animation_set_variable(self.unit, index, variable)
end

PlayerHuskLocomotionExtension.hot_join_sync = function (self, sender)
	-- function 22
	local unit = self.unit
	local is_marked_for_deletion = Managers.state.unit_spawner:is_marked_for_deletion(unit)

	if is_marked_for_deletion then
		return
	end

	local player_object_id = self.id
	local channel_id = PEER_ID_TO_CHANNEL[sender]

	RPC.rpc_sync_anim_state_3(channel_id, player_object_id, Unit.animation_get_state(unit))
end

PlayerHuskLocomotionExtension.current_rotation = function (self)
	-- function 23
	return self._current_rotation:unbox()
end

local ALLOWED_MOVER_MOVE_DISTANCE = 1

PlayerHuskLocomotionExtension.move_to_non_intersecting_position = function (self)
	-- function 24
	local unit = self.unit
	local mover = Unit.mover(unit)
	local is_colliding, colliding_actor, move_vector, new_position = Mover.separate(mover, ALLOWED_MOVER_MOVE_DISTANCE)

	if is_colliding and new_position then
		Mover.set_position(mover, new_position)
		Unit.set_local_position(unit, 0, new_position)
	end
end

PlayerHuskLocomotionExtension.teleport_to = function (self, pos, optional_rot)
	-- function 25
	local unit = self.unit
	local mover = Unit.mover(unit)

	Mover.set_position(mover, pos)
	Unit.set_local_position(unit, 0, pos)

	if optional_rot then
		Unit.set_local_rotation(unit, 0, optional_rot)
	end

	self:move_to_non_intersecting_position()
end
