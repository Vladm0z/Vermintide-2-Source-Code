-- chunkname: @scripts/unit_extensions/default_player_unit/player_husk_locomotion_extension.lua

require("scripts/unit_extensions/default_player_unit/third_person_idle_fullbody_animation_control")

PlayerHuskLocomotionExtension = class(PlayerHuskLocomotionExtension)

local POSITION_LOOKUP = POSITION_LOOKUP

PlayerHuskLocomotionExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.world = arg_1_1.world
	self.unit = arg_1_2
	self.game = arg_1_3.game
	self.id = arg_1_3.id
	self.player = arg_1_3.player
	self.is_server = Managers.player.is_server
	self.velocity_current = Vector3Box(0, 0, 0)
	self._current_rotation = QuaternionBox(Quaternion.identity())
	self.has_moved_from_start_position = arg_1_3.has_moved_from_start_position
	self.anim_move_speed = 0
	self.move_speed_anim_var = Unit.animation_find_variable(arg_1_2, "move_speed")

	Managers.player:assign_unit_ownership(arg_1_2, self.player, true)

	local on_spawn_flow_event = LevelHelper:current_level_settings().on_spawn_flow_event

	if not on_spawn_flow_event then
		Unit.flow_event(arg_1_2, on_spawn_flow_event)
	end

	local animation_find_variable = Unit.animation_find_variable(arg_1_2, "anim_run_speed")
	local animation_find_variable_2 = Unit.animation_find_variable(arg_1_2, "anim_walk_speed")

	self.movement_scale_animation_id = Unit.animation_find_variable(arg_1_2, "movement_scale")
	self.run_speed_treshold = Unit.animation_get_variable(arg_1_2, animation_find_variable)
	self.walk_speed_treshold = Unit.animation_get_variable(arg_1_2, animation_find_variable_2)

	if not self.is_server then
		local create_tag_cost_table = GwNavCostMap.create_tag_cost_table()

		AiUtils.initialize_nav_cost_map_cost_table(create_tag_cost_table, nil, 1)

		self._latest_position_on_navmesh = Vector3Box(Unit.world_position(arg_1_2, 0))
		self._nav_world = Managers.state.entity:system("ai_system"):nav_world()
		self._nav_traverse_logic = GwNavTraverseLogic.create(self._nav_world, create_tag_cost_table)
		self._nav_cost_map_cost_table = create_tag_cost_table
	end

	self.third_person_idle_fullbody_animation_control = ThirdPersonIdleFullbodyAnimationControl:new(arg_1_2)
end

PlayerHuskLocomotionExtension.destroy = function (self)
	-- function 2
	if not self.is_server then
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

PlayerHuskLocomotionExtension.get_script_driven_gravity_scale = function (arg_6_0)
	-- function 6
	return 1
end

PlayerHuskLocomotionExtension.extensions_ready = function (self, arg_7_1, arg_7_2)
	-- function 7
	self.status_extension = ScriptUnit.extension(self.unit, "status_system")

	self.third_person_idle_fullbody_animation_control:extensions_ready(arg_7_1, arg_7_2)
end

PlayerHuskLocomotionExtension.add_external_velocity = function (self, arg_8_1, arg_8_2)
	-- function 8
	if not Managers.state.network:game() then
		return
	end

	local flag

	flag = not arg_8_2 and "rpc_add_external_velocity_with_upper_limit" and "rpc_add_external_velocity"

	if not self.is_server then
		Managers.state.network.network_transmit:send_rpc(flag, self.player:network_id(), self.id, arg_8_1, arg_8_2)
	else
		Managers.state.network.network_transmit:send_rpc_server(flag, self.id, arg_8_1, arg_8_2)
	end
end

PlayerHuskLocomotionExtension.set_forced_velocity = function (self, arg_9_1)
	-- function 9
	if not self.disabled then
		if self.is_server or not DEDICATED_SERVER then
			Managers.state.network.network_transmit:send_rpc("rpc_set_forced_velocity", self.player:network_id(), self.id, arg_9_1)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_set_forced_velocity", self.id, arg_9_1)
		end
	end
end

PlayerHuskLocomotionExtension.set_disabled = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	self._disabled = arg_10_1
	self._run_func = arg_10_2
	self.master_unit = arg_10_3

	if not arg_10_1 then
		local unit = self.unit
		local var_10_1 = POSITION_LOOKUP[unit]

		var_10_1 = var_10_1 or Unit.local_position(unit, 0)
		self._pos_lerp_time = 0

		Unit.set_data(unit, "last_lerp_position", var_10_1)
		Unit.set_data(unit, "last_lerp_position_offset", Vector3(0, 0, 0))
		Unit.set_data(unit, "accumulated_movement", Vector3(0, 0, 0))

		local mover = Unit.mover(unit)

		Mover.set_position(mover, var_10_1)
		Unit.set_local_position(unit, 0, var_10_1)
	end
end

PlayerHuskLocomotionExtension.post_update = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	-- function 11
	if not self._disabled then
		return
	end

	local game = Managers.state.network:game()

	if not game and not GameSession.game_object_exists(game, self.id) then
		if not HEALTH_ALIVE[arg_11_1] then
			local str = "onground"

			self:update_movement(arg_11_3, arg_11_1, str)
		end

		self:_update_last_position_on_navmesh()
	end
end

PlayerHuskLocomotionExtension.update = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	-- function 12
	if not self._disabled then
		self._run_func(arg_12_1, arg_12_3, self)

		return
	end

	local get_is_on_ladder, var_12_1 = self.status_extension:get_is_on_ladder()

	if not get_is_on_ladder and not var_12_1 then
		self:update_ladder_animation_position(var_12_1)
	end

	self.third_person_idle_fullbody_animation_control:update(arg_12_5)
end

PlayerHuskLocomotionExtension.last_position_on_navmesh = function (self)
	-- function 13
	assert(self.is_server, "last position on nav mesh is only saved on server")

	return self._latest_position_on_navmesh:unbox()
end

PlayerHuskLocomotionExtension._update_last_position_on_navmesh = function (self)
	-- function 14
	if not self.is_server then
		local game_object_field = GameSession.game_object_field(self.game, self.id, "position")
		local triangle_from_position, var_14_2 = GwNavQueries.triangle_from_position(self._nav_world, game_object_field, 0.1, 0.3, self._nav_traverse_logic)

		if not triangle_from_position then
			self._latest_position_on_navmesh:store(Vector3(game_object_field.x, game_object_field.y, game_object_field.z))
		end
	end
end

local num = 0.01
local num_2 = 0.1
local num_3 = 0.01
local num_4 = 1

PlayerHuskLocomotionExtension.update_movement = function (self, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	local local_position = Unit.local_position(arg_15_2, 0)
	local var_15_1
	local game_object_field = GameSession.game_object_field(self.game, self.id, "linked_movement")
	local game_object_field_2 = GameSession.game_object_field(self.game, self.id, "moving_platform")

	if not game_object_field then
		local game_object_field_3 = GameSession.game_object_field(self.game, self.id, "link_parent_is_level_unit")
		local game_object_field_4 = GameSession.game_object_field(self.game, self.id, "link_parent_id")
		local game_object_field_5 = GameSession.game_object_field(self.game, self.id, "link_node")
		local game_object_field_6 = GameSession.game_object_field(self.game, self.id, "link_offset")
		local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(game_object_field_4, game_object_field_3)

		if not Unit.alive(game_object_or_level_unit) then
			var_15_1 = Unit.world_position(game_object_or_level_unit, game_object_field_5) + game_object_field_6
		else
			var_15_1 = GameSession.game_object_field(self.game, self.id, "position")
		end
	else
		var_15_1 = GameSession.game_object_field(self.game, self.id, "position")
	end

	local game_object_field_7 = GameSession.game_object_field(self.game, self.id, "yaw")
	local game_object_field_8 = GameSession.game_object_field(self.game, self.id, "pitch")
	local var_15_11 = Quaternion(Vector3.up(), game_object_field_7)
	local var_15_12 = Quaternion(Vector3.right(), game_object_field_8)
	local multiply = Quaternion.multiply(var_15_11, var_15_12)
	local game_object_field_9 = GameSession.game_object_field(self.game, self.id, "velocity")

	if Vector3.length(game_object_field_9) < NetworkConstants.VELOCITY_EPSILON then
		game_object_field_9 = Vector3(0, 0, 0)
	end

	self.has_moved_from_start_position = GameSession.game_object_field(self.game, self.id, "has_moved_from_start_position")

	self:_extrapolation_movement(arg_15_2, arg_15_1, local_position, var_15_1, multiply, arg_15_3, game_object_field_9, game_object_field, game_object_field_2)
	self.velocity_current:store(game_object_field_9)
	self._current_rotation:store(multiply)
	self:_update_speed_variable(arg_15_1)
end

PlayerHuskLocomotionExtension.get_moving_platform = function (self)
	-- function 16
	if not Managers.state.network:game() then
		return
	end

	if not GameSession.game_object_exists(self.game, self.id) then
		local game_object_field = GameSession.game_object_field(self.game, self.id, "moving_platform")
		local game_object_or_level_unit

		if game_object_field ~= 0 then
			game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(game_object_field, true)

			if not game_object_or_level_unit then
				-- Nothing
			end
		end

		game_object_or_level_unit = nil

		::label_16_0::

		local has_extension = ScriptUnit.has_extension(game_object_or_level_unit, "transportation_system")
		local game_object_field_2

		if not game_object_or_level_unit then
			game_object_field_2 = GameSession.game_object_field(self.game, self.id, "moving_platform_soft_linked")

			if not game_object_field_2 then
				-- Nothing
			end
		end

		game_object_field_2 = nil

		::label_16_1::

		return game_object_or_level_unit, has_extension, game_object_field_2
	end

	return nil, nil, nil
end

PlayerHuskLocomotionExtension.update_ladder_animation_position = function (self, arg_17_1)
	-- function 17
	local unit = self.unit
	local world_position = Unit.world_position(arg_17_1, 0)
	local time_in_ladder_move_animation = CharacterStateHelper.time_in_ladder_move_animation(unit, Vector3.z(world_position))
	local animation_find_variable = Unit.animation_find_variable(unit, "climb_time")

	Unit.animation_set_variable(unit, animation_find_variable, time_in_ladder_move_animation)
end

PlayerHuskLocomotionExtension._extrapolation_movement = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7, arg_18_8, arg_18_9)
	-- function 18
	local get_data = Unit.get_data(arg_18_1, "last_lerp_position")

	get_data = get_data or arg_18_3

	local get_data_2 = Unit.get_data(arg_18_1, "last_lerp_position_offset")

	get_data_2 = get_data_2 or Vector3(0, 0, 0)

	local get_data_3 = Unit.get_data(arg_18_1, "accumulated_movement")

	get_data_3 = get_data_3 or Vector3(0, 0, 0)

	if self._moving_platform ~= arg_18_9 then
		local _moving_platform = self._moving_platform

		_moving_platform = _moving_platform or 0

		local flag = _moving_platform == 0 or Managers.state.network:game_object_or_level_unit(self._moving_platform, true)
		local flag_2 = arg_18_9 == 0 or Managers.state.network:game_object_or_level_unit(arg_18_9, true)

		if not flag and not flag_2 then
			local extension = ScriptUnit.extension(flag, "transportation_system")

			get_data = get_data + (Unit.local_position(flag, 0) + extension:visual_delta())

			local extension_2 = ScriptUnit.extension(flag_2, "transportation_system")

			get_data = get_data - (Unit.local_position(flag_2, 0) + extension_2:visual_delta())
		end

		self._moving_platform = arg_18_9
	end

	if not (arg_18_9 == 0 or arg_18_8) then
		local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(arg_18_9, true)
		local local_position = Unit.local_position(game_object_or_level_unit, 0)
		local extension_3 = ScriptUnit.extension(game_object_or_level_unit, "transportation_system")

		arg_18_4 = arg_18_4 + local_position + extension_3:visual_delta()
	end

	local _pos_lerp_time = self._pos_lerp_time

	_pos_lerp_time = _pos_lerp_time or 0
	self._pos_lerp_time = _pos_lerp_time + arg_18_2

	local _velocity_lerp_time = self._velocity_lerp_time

	_velocity_lerp_time = _velocity_lerp_time or 0
	self._velocity_lerp_time = _velocity_lerp_time + arg_18_2

	local var_18_13

	if not arg_18_8 then
		var_18_13 = num_3

		if not var_18_13 then
			-- Nothing
		end
	end

	var_18_13 = num_2

	::label_18_0::

	local num_5 = self._pos_lerp_time / var_18_13
	local num_6 = arg_18_7 * arg_18_2
	local num_7 = get_data_3 + num_6
	local lerp = Vector3.lerp(get_data_2, Vector3(0, 0, 0), math.min(num_5, 1))
	local num_8 = get_data + num_7 + lerp

	Profiler.record_statistics("move_delta", Vector3.length(num_6))
	Profiler.record_statistics("husk_speed", Vector3.length(arg_18_7))
	Profiler.record_statistics("dt", arg_18_2)
	Unit.set_data(arg_18_1, "accumulated_movement", num_7)

	if Vector3.length(arg_18_4 - get_data) > num then
		self._pos_lerp_time = 0

		Unit.set_data(arg_18_1, "last_lerp_position", arg_18_4)
		Unit.set_data(arg_18_1, "last_lerp_position_offset", num_8 - arg_18_4)
		Unit.set_data(arg_18_1, "accumulated_movement", Vector3(0, 0, 0))
	end

	local unbox = self.velocity_current:unbox()

	if Vector3.length(arg_18_7 - unbox) > NetworkConstants.VELOCITY_EPSILON then
		self._velocity_lerp_time = 0
	end

	if not (not (self._pos_lerp_time > num_4) or not (self._velocity_lerp_time > num_4)) then
		num_8 = arg_18_4

		Unit.set_data(arg_18_1, "accumulated_movement", Vector3(0, 0, 0))
	end

	local mover = Unit.mover(arg_18_1)

	Mover.set_position(mover, num_8)
	Unit.set_local_position(arg_18_1, 0, num_8)

	local local_rotation = Unit.local_rotation(arg_18_1, 0)

	Unit.set_local_rotation(arg_18_1, 0, Quaternion.lerp(local_rotation, arg_18_5, math.min(arg_18_2 * 15, 1)))
end

local num_5 = 0.97
local num_6 = 3.23
local num_7 = 6.14
local num_8 = 0.3
local num_9 = 1.5
local num_10 = 99.9999
local num_11 = 0.3

PlayerHuskLocomotionExtension._update_speed_variable = function (self, arg_19_1)
	-- function 19
	local unbox = self.velocity_current:unbox()
	local var_19_1 = Vector3(unbox.x, unbox.y, 0)
	local length = Vector3.length(var_19_1)
	local anim_move_speed = self.anim_move_speed
	local abs = math.abs(anim_move_speed - length)

	if anim_move_speed < length then
		local min = math.min(length / num_11 * arg_19_1, abs)

		anim_move_speed = math.clamp(anim_move_speed + min, 0, length)
		self._move_speed_top = anim_move_speed
	else
		local _move_speed_top = self._move_speed_top

		_move_speed_top = _move_speed_top or length

		local min_2 = math.min(_move_speed_top / num_11 * arg_19_1, abs)

		anim_move_speed = math.clamp(anim_move_speed - min_2, 0, anim_move_speed)
	end

	self.anim_move_speed = anim_move_speed

	local unit = self.unit

	Unit.animation_set_variable(unit, self.move_speed_anim_var, math.min(anim_move_speed, num_10))

	local var_19_9

	if length < self.walk_speed_treshold then
		var_19_9 = length / self.walk_speed_treshold
	elseif length > self.run_speed_treshold then
		var_19_9 = length / self.run_speed_treshold
	else
		var_19_9 = 1
	end

	local clamp = math.clamp(var_19_9, num_8, num_9)

	Unit.animation_set_variable(unit, self.movement_scale_animation_id, clamp)
end

PlayerHuskLocomotionExtension._calculate_move_speed_var_from_mps = function (arg_20_0, arg_20_1)
	-- function 20
	local var_20_0
	local num = 1

	if arg_20_1 <= num_5 then
		var_20_0 = 0
		num = arg_20_1 / num_5
	elseif arg_20_1 <= num_6 then
		var_20_0 = (arg_20_1 - num_5) / (num_6 - num_5)
	elseif arg_20_1 <= num_7 then
		var_20_0 = 1 + (arg_20_1 - num_6) / (num_7 - num_6)
	else
		var_20_0 = 3
		num = arg_20_1 / num_7
	end

	return var_20_0, num
end

PlayerHuskLocomotionExtension.rpc_animation_set_variable = function (self, arg_21_1, arg_21_2)
	-- function 21
	Unit.animation_set_variable(self.unit, arg_21_1, arg_21_2)
end

PlayerHuskLocomotionExtension.hot_join_sync = function (self, arg_22_1)
	-- function 22
	local unit = self.unit

	if not Managers.state.unit_spawner:is_marked_for_deletion(unit) then
		return
	end

	local id = self.id
	local var_22_2 = PEER_ID_TO_CHANNEL[arg_22_1]

	RPC.rpc_sync_anim_state_3(var_22_2, id, Unit.animation_get_state(unit))
end

PlayerHuskLocomotionExtension.current_rotation = function (self)
	-- function 23
	return self._current_rotation:unbox()
end

local num_12 = 1

PlayerHuskLocomotionExtension.move_to_non_intersecting_position = function (self)
	-- function 24
	local unit = self.unit
	local mover = Unit.mover(unit)
	local separate, var_24_3, var_24_4, var_24_5 = Mover.separate(mover, num_12)

	if not separate and not var_24_5 then
		Mover.set_position(mover, var_24_5)
		Unit.set_local_position(unit, 0, var_24_5)
	end
end

PlayerHuskLocomotionExtension.teleport_to = function (self, arg_25_1, arg_25_2)
	-- function 25
	local unit = self.unit
	local mover = Unit.mover(unit)

	Mover.set_position(mover, arg_25_1)
	Unit.set_local_position(unit, 0, arg_25_1)

	if not arg_25_2 then
		Unit.set_local_rotation(unit, 0, arg_25_2)
	end

	self:move_to_non_intersecting_position()
end
