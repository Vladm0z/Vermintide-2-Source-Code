-- chunkname: @scripts/unit_extensions/human/ai_player_unit/ai_locomotion_extension.lua

require("scripts/helpers/mover_helper")

local local_position = Unit.local_position
local num = 10
local num_2 = 20
local num_3 = 0.5

AILocomotionExtension = class(AILocomotionExtension)

AILocomotionExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._system_data = arg_1_3.system_data
	self._unit = arg_1_2
	self.breed = arg_1_3.breed
	self._world = arg_1_1.world
	self._nav_world = arg_1_3.nav_world

	assert(self._nav_world)

	self._move_speed_var = Unit.animation_find_variable(arg_1_2, "move_speed")
	self._velocity = Vector3Box()
	self._update_function_name = "update_script_driven"
	self._wanted_velocity = nil
	self._wanted_rotation = nil
	self._rotation_speed = num
	self._rotation_speed_modifier = 1
	self._infinite_rotation_speed = false
	self._affected_by_gravity = true
	self._constrained_by_mover = false
	self._constrained_by_players = false
	self._snap_to_navmesh = true
	self._animation_translation_scale_box = Vector3Box(1, 1, 1)
	self._animation_rotation_scale = 1
	self._lerp_rotation = true
	self._is_falling = false
	self._check_falling = true
	self._gravity = num_2
	self.move_speed = 0
	self._system_data.all_update_units[self._unit] = self

	Unit.set_animation_merge_options(arg_1_2)

	self.is_server = Managers.player.is_server
	self._last_fall_position = Vector3Box(10000, 10000, 10000)
	self._mover_state = MoverHelper.create_mover_state()

	local str = "c_mover_collision"

	if not Unit.actor(arg_1_2, str) then
		self._collision_state = MoverHelper.create_collision_state(arg_1_2, str)
	end

	local set_active_mover = MoverHelper.set_active_mover
	local var_1_2 = arg_1_2
	local _mover_state = self._mover_state
	local default_mover = self.breed.default_mover

	default_mover = default_mover or "mover"

	set_active_mover(var_1_2, _mover_state, default_mover)
	self:set_movement_type("snap_to_navmesh")
end

AILocomotionExtension.destroy = function (self)
	-- function 2
	local _system_data = self._system_data
	local _unit = self._unit

	_system_data.destroy_units[_unit] = self
end

AILocomotionExtension.ready = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	return
end

AILocomotionExtension.hot_join_sync = function (self, arg_4_1)
	-- function 4
	local _unit = self._unit

	if not FROZEN[_unit] then
		return
	end

	local var_4_1 = PEER_ID_TO_CHANNEL[arg_4_1]

	if not Unit.has_animation_state_machine(_unit) then
		local unit_game_object_id = Managers.state.network:unit_game_object_id(_unit)
		local get_data = Unit.get_data(_unit, "breed")

		RPC[get_data.animation_sync_rpc](var_4_1, unit_game_object_id, Unit.animation_get_state(_unit))
	else
		local unit_game_object_id_2 = Managers.state.network:unit_game_object_id(_unit)

		RPC.rpc_hot_join_nail_to_wall_fix(var_4_1, unit_game_object_id_2)
	end
end

AILocomotionExtension.set_mover_displacement = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not arg_5_1 then
		local mover = Unit.mover(self._unit)

		Mover.move(mover, arg_5_1, 0.00390625)

		self._mover_displacement_duration = arg_5_2
		self._mover_displacement = Vector3Box(arg_5_1)
		self._mover_displacement_t = arg_5_2
	else
		self._mover_displacement = Vector3Box(0, 0, 0)
		self._mover_displacement_duration = nil
		self._mover_displacement_t = nil
	end
end

AILocomotionExtension.teleport_to = function (self, arg_6_1, arg_6_2)
	-- function 6
	local _unit = self._unit

	Unit.set_local_position(_unit, 0, arg_6_1)

	if not arg_6_2 then
		Unit.set_local_rotation(_unit, 0, arg_6_2)
	end

	local network = Managers.state.network
	local game = network:game()

	if not game then
		local unit_game_object_id = network:unit_game_object_id(_unit)
		local num = GameSession.game_object_field(game, unit_game_object_id, "has_teleported") % NetworkConstants.teleports.max + 1

		GameSession.set_game_object_field(game, unit_game_object_id, "has_teleported", num)
	end
end

local str = "update_animation_driven_movement_script_driven_rotation"
local str_2 = "update_animation_driven"
local str_3 = "update_script_driven"
local str_4 = "update_linked_transport"

AILocomotionExtension.set_animation_driven = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	arg_7_2 = arg_7_2 or false

	local _unit = self._unit

	self:set_affected_by_gravity(arg_7_2)

	local network = Managers.state.network
	local network_transmit = network.network_transmit
	local game = network:game()

	game = not game and network:unit_game_object_id(_unit)

	if not game then
		return
	end

	local _update_function_name = self._update_function_name
	local _affected_by_gravity = self._affected_by_gravity
	local flag = _update_function_name == str_2
	local flag_2 = _update_function_name == str
	local flag_3 = _update_function_name == str_3
	local flag_4 = _update_function_name == str_4
	local flag_5 = false
	local _system_data = self._system_data

	if not arg_7_4 then
		if not flag_4 then
			self._update_function_name = str_4
			_system_data.animation_update_units[_unit] = nil
			_system_data.animation_and_script_update_units[_unit] = nil

			network_transmit:send_rpc_clients("rpc_set_linked_transport_driven", game, arg_7_2)
		end

		flag_5 = true
	elseif not (not arg_7_1 and not arg_7_3 and flag_2) then
		self._update_function_name = str
		_system_data.animation_update_units[_unit] = nil
		_system_data.animation_and_script_update_units[_unit] = self

		if not game then
			local local_position = Unit.local_position(_unit, 0)
			local local_rotation = Unit.local_rotation(_unit, 0)

			network_transmit:send_rpc_clients("rpc_set_animation_driven_script_movement", game, local_position, local_rotation, arg_7_2)
		end

		flag_5 = true
	elseif not (not arg_7_1 and arg_7_3 or flag) then
		self._update_function_name = str_2
		_system_data.animation_update_units[_unit] = self
		_system_data.animation_and_script_update_units[_unit] = nil

		if not game then
			local local_position_2 = Unit.local_position(_unit, 0)
			local local_rotation_2 = Unit.local_rotation(_unit, 0)

			network_transmit:send_rpc_clients("rpc_set_animation_driven", game, local_position_2, local_rotation_2, arg_7_2)
		end

		flag_5 = true
	elseif not (arg_7_1 or flag_3) then
		self._update_function_name = str_3
		_system_data.animation_update_units[_unit] = nil
		_system_data.animation_and_script_update_units[_unit] = nil

		if not game then
			network_transmit:send_rpc_clients("rpc_set_script_driven", game, arg_7_2)
		end

		flag_5 = true
	end

	if not (not game and flag_5 or _affected_by_gravity == arg_7_2) then
		network_transmit:send_rpc_clients("rpc_set_affected_by_gravity", game, arg_7_2)
	end
end

AILocomotionExtension.set_animation_translation_scale = function (self, arg_8_1)
	-- function 8
	self._animation_translation_scale_box:store(arg_8_1)
end

AILocomotionExtension.set_animation_rotation_scale = function (self, arg_9_1)
	-- function 9
	self._animation_rotation_scale = arg_9_1
end

AILocomotionExtension.set_wanted_velocity_flat = function (self, arg_10_1)
	-- function 10
	arg_10_1.z = self._velocity.z
	self._wanted_velocity = arg_10_1
end

AILocomotionExtension.set_wanted_velocity = function (self, arg_11_1)
	-- function 11
	self._wanted_velocity = arg_11_1

	self._velocity:store(arg_11_1)
end

AILocomotionExtension.set_wanted_rotation = function (self, arg_12_1)
	-- function 12
	self._wanted_rotation = arg_12_1
end

AILocomotionExtension.use_lerp_rotation = function (self, arg_13_1)
	-- function 13
	self._lerp_rotation = arg_13_1
end

AILocomotionExtension.set_rotation_speed = function (self, arg_14_1)
	-- function 14
	if arg_14_1 == nil then
		self._rotation_speed = num
	else
		self._rotation_speed = arg_14_1
	end
end

AILocomotionExtension.set_rotation_speed_modifier = function (self, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	self._system_data.rotation_speed_modifier_update_units[self._unit] = self
	self._rotation_speed_modifier = arg_15_1
	self._rotation_speed_modifier_lerp_start_value = arg_15_1
	self._rotation_speed_modifier_lerp_start_time = arg_15_3
	self._rotation_speed_modifier_lerp_end_time = arg_15_3 + arg_15_2
end

AILocomotionExtension.set_affected_by_gravity = function (self, arg_16_1)
	-- function 16
	self._affected_by_gravity = arg_16_1

	if not (not arg_16_1 and self._system_data.snap_to_navmesh_update_units[self._unit] ~= nil) then
		self._system_data.affected_by_gravity_update_units[self._unit] = self
	elseif not arg_16_1 then
		self._system_data.affected_by_gravity_update_units[self._unit] = nil
	end
end

AILocomotionExtension.set_gravity = function (self, arg_17_1)
	-- function 17
	self._gravity = arg_17_1 or num_2
end

AILocomotionExtension.set_mover_disable_reason = function (self, arg_18_1, arg_18_2)
	-- function 18
	MoverHelper.set_disable_reason(self._unit, self._mover_state, arg_18_1, arg_18_2)
end

AILocomotionExtension.set_check_falling = function (self, arg_19_1)
	-- function 19
	self._check_falling = arg_19_1
end

AILocomotionExtension.set_collision_disabled = function (self, arg_20_1, arg_20_2)
	-- function 20
	if not self._collision_state then
		MoverHelper.set_collision_disable_reason(self._unit, self._collision_state, arg_20_1, arg_20_2)
	end
end

AILocomotionExtension.set_movement_type = function (self, arg_21_1, arg_21_2)
	-- function 21
	if arg_21_1 == self.movement_type then
		return
	end

	self.movement_type = arg_21_1

	local _unit = self._unit

	if arg_21_1 == "script_driven" then
		self._snap_to_navmesh = false
		self._constrained_by_mover = false
		self._system_data.script_driven_update_units[_unit] = self
		self._system_data.snap_to_navmesh_update_units[_unit] = nil
		self._system_data.get_to_navmesh_update_units[_unit] = nil
		self._system_data.mover_constrained_update_units[_unit] = nil
		self._system_data.affected_by_gravity_update_units[_unit] = not self._affected_by_gravity and self and nil

		MoverHelper.set_disable_reason(_unit, self._mover_state, "constrained_by_mover", true)
	elseif arg_21_1 == "snap_to_navmesh" then
		local var_21_1 = local_position(_unit, 0)
		local triangle_from_position, var_21_3 = GwNavQueries.triangle_from_position(self._nav_world, var_21_1, 0.5, 0.5)

		if not triangle_from_position then
			self._system_data.snap_to_navmesh_update_units[_unit] = self
			self._system_data.get_to_navmesh_update_units[_unit] = nil
		else
			self._system_data.get_to_navmesh_update_units[_unit] = self
			self._system_data.snap_to_navmesh_update_units[_unit] = nil
		end

		self._snap_to_navmesh = true
		self._constrained_by_mover = false
		self._system_data.script_driven_update_units[_unit] = nil
		self._system_data.mover_constrained_update_units[_unit] = nil
		self._system_data.affected_by_gravity_update_units[_unit] = nil

		MoverHelper.set_disable_reason(_unit, self._mover_state, "constrained_by_mover", true)
	elseif arg_21_1 == "constrained_by_mover" then
		self._snap_to_navmesh = false
		self._constrained_by_mover = true
		self._system_data.script_driven_update_units[_unit] = nil
		self._system_data.snap_to_navmesh_update_units[_unit] = nil
		self._system_data.get_to_navmesh_update_units[_unit] = nil
		self._system_data.mover_constrained_update_units[_unit] = self
		self._system_data.affected_by_gravity_update_units[_unit] = not self._affected_by_gravity and self and nil

		MoverHelper.set_disable_reason(_unit, self._mover_state, "constrained_by_mover", false)

		local mover = Unit.mover(_unit)
		local flag = arg_21_2 or num_3
		local separate, var_21_7, var_21_8, var_21_9 = Mover.separate(mover, flag)

		if not separate then
			if not var_21_9 then
				Mover.set_position(mover, var_21_9)
			else
				local str = "forced"
				local var_21_11 = Vector3(0, 0, -1)

				AiUtils.kill_unit(_unit, nil, nil, str, var_21_11)

				return
			end
		end

		local position = Mover.position(mover)

		Unit.set_local_position(_unit, 0, position)

		local get_data = World.get_data(self._world, "physics_world")
		local num = 0.5
		local num_2 = 1.5
		local var_21_16 = Vector3(num, num_2, num)
		local look = Quaternion.look(Vector3(0, 0, 1))
		local flag_2

		flag_2 = not (num_2 - num > 0) or not "capsule" or "sphere"

		local immediate_overlap, var_21_20 = PhysicsWorld.immediate_overlap(get_data, "shape", flag_2, "position", position, "rotation", look, "size", var_21_16, "collision_filter", "filter_environment_overlap")

		self._is_falling = var_21_20 == 0
	end
end

AILocomotionExtension.set_disabled = function (self)
	-- function 22
	assert(not self._disabled, "ai_locomotion_extension disabled extension several times.")

	self._system_data.destroy_units[unit] = self

	MoverHelper.set_disable_reason(unit, self._mover_state, "constrained_by_mover", true)

	self._disabled = true
end

AILocomotionExtension.current_velocity = function (self)
	-- function 23
	return self._velocity:unbox()
end

AILocomotionExtension.is_falling = function (self)
	-- function 24
	return self._is_falling
end

AILocomotionExtension.get_rotation_speed = function (self)
	-- function 25
	return self._rotation_speed
end

AILocomotionExtension.get_rotation_speed_modifier = function (self)
	-- function 26
	return self._rotation_speed_modifier
end

AILocomotionExtension.get_animation_rotation_scale = function (self)
	-- function 27
	return self._animation_rotation_scale
end

AILocomotionExtension.get_animation_translation_scale = function (self)
	-- function 28
	return self._animation_translation_scale_box:unbox()
end
