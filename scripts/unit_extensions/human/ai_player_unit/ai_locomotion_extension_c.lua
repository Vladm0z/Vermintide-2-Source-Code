-- chunkname: @scripts/unit_extensions/human/ai_player_unit/ai_locomotion_extension_c.lua

require("scripts/helpers/mover_helper")

local LOCOMOTION_GRAVITY = 20

AILocomotionExtensionC = class(AILocomotionExtensionC)

AILocomotionExtensionC.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	self._unit = unit

	local breed = extension_init_data.breed

	self.breed = breed

	local unit_template = Managers.state.unit_spawner.unit_template_lut[breed.unit_template]
	local go_type = unit_template.go_type
	local game_object_template = Managers.state.network:game_object_template(go_type)
	local fassert = fassert
	local syncs_rotation = game_object_template.syncs_rotation

	syncs_rotation = not not syncs_rotation or not not game_object_template.syncs_yaw

	fassert(syncs_rotation, "AI Locomotion error. AI units must have syncs_rotation or syncs_yaw set in its game_object_template.")

	local breed_run_speed = breed.run_speed
	local syncs_rotation_2 = game_object_template.syncs_rotation

	if not syncs_rotation_2 then
		-- Nothing
	end

	syncs_rotation_2 = false

	local sync_full_rotation = syncs_rotation_2

	::label_1_0::

	self._engine_extension_id = EngineOptimizedExtensions.ai_locomotion_register_extension(unit, LOCOMOTION_GRAVITY, breed_run_speed, sync_full_rotation)
	self._animation_rotation_scale = 1
	self._animation_translation_scale_box = Vector3Box(1, 1, 1)
	self._mover_state = MoverHelper.create_mover_state()

	local collision_actor_name = "c_mover_collision"
	local has_collision_actor = Unit.actor(unit, collision_actor_name)

	if has_collision_actor then
		self._collision_state = MoverHelper.create_collision_state(unit, collision_actor_name)
	end

	local set_active_mover = MoverHelper.set_active_mover
	local var_1_4 = unit
	local _mover_state = self._mover_state
	local default_mover = breed.default_mover

	default_mover = not not default_mover or not not "mover"

	set_active_mover(var_1_4, _mover_state, default_mover)
end

AILocomotionExtensionC.ready = function (self, go_id, blackboard)
	-- function 2
	if self._engine_extension_id then
		EngineOptimizedExtensions.ai_locomotion_ai_ready(self._engine_extension_id, go_id)
	end
end

AILocomotionExtensionC.destroy = function (self)
	-- function 3
	if self._engine_extension_id then
		EngineOptimizedExtensions.ai_locomotion_destroy_extension(self._engine_extension_id)

		self._engine_extension_id = nil
	end
end

AILocomotionExtensionC.freeze = function (self)
	-- function 4
	if self._engine_extension_id then
		EngineOptimizedExtensions.ai_locomotion_destroy_extension(self._engine_extension_id)

		self._engine_extension_id = nil
	end
end

AILocomotionExtensionC.unfreeze = function (self, unit)
	-- function 5
	local blackboard = BLACKBOARDS[unit]
	local breed = blackboard.breed
	local breed_run_speed = breed.run_speed
	local unit_template = Managers.state.unit_spawner.unit_template_lut[breed.unit_template]
	local go_type = unit_template.go_type
	local game_object_template = Managers.state.network:game_object_template(go_type)
	local syncs_rotation = game_object_template.syncs_rotation

	if not syncs_rotation then
		-- Nothing
	end

	syncs_rotation = false

	local sync_full_rotation = syncs_rotation

	::label_5_0::

	self._engine_extension_id = EngineOptimizedExtensions.ai_locomotion_register_extension(unit, LOCOMOTION_GRAVITY, breed_run_speed, sync_full_rotation)
	self._animation_rotation_scale = 1

	self._animation_translation_scale_box:store(1, 1, 1)

	local set_active_mover = MoverHelper.set_active_mover
	local var_5_2 = unit
	local _mover_state = self._mover_state
	local default_mover = breed.default_mover

	default_mover = not not default_mover or not not "mover"

	set_active_mover(var_5_2, _mover_state, default_mover)
	self:teleport_to(POSITION_LOOKUP[unit], Unit.local_rotation(unit, 0))
end

AILocomotionExtensionC.hot_join_sync = function (self, sender)
	-- function 6
	if FROZEN[self._unit] then
		return
	end

	local channel_id = PEER_ID_TO_CHANNEL[sender]
	local unit = self._unit
	local game_object_id = Managers.state.network:unit_game_object_id(unit)

	if Unit.has_animation_state_machine(unit) then
		local blackboard = BLACKBOARDS[unit]
		local breed = blackboard.breed

		RPC[breed.animation_sync_rpc](channel_id, game_object_id, Unit.animation_get_state(unit))
	else
		RPC.rpc_hot_join_nail_to_wall_fix(channel_id, game_object_id)
	end
end

AILocomotionExtensionC.set_mover_displacement = function (self, displacement, duration)
	-- function 7
	if self._engine_extension_id then
		EngineOptimizedExtensions.ai_locomotion_set_mover_displacement(self._engine_extension_id, displacement, duration)
	end
end

AILocomotionExtensionC.teleport_to = function (self, position, rotation)
	-- function 8
	if self._engine_extension_id then
		EngineOptimizedExtensions.ai_locomotion_teleport_to(self._engine_extension_id, position, rotation)
	end
end

AILocomotionExtensionC.set_animation_driven = function (self, is_animation_driven, is_affected_by_gravity, script_driven_rotation, is_on_transport)
	-- function 9
	if not self._engine_extension_id then
		return
	end

	is_affected_by_gravity = not not is_affected_by_gravity or not not false

	local r, param1, param2, param3 = EngineOptimizedExtensions.ai_locomotion_set_animation_driven(self._engine_extension_id, is_animation_driven, is_affected_by_gravity, script_driven_rotation, is_on_transport)

	if r == 1 then
		local network_transmit = Managers.state.network.network_transmit
		local game_object_id = param1
		local position = param2
		local rotation = param3

		network_transmit:send_rpc_clients("rpc_set_animation_driven_script_movement", game_object_id, position, rotation, is_affected_by_gravity)
	elseif r == 2 then
		local network_transmit = Managers.state.network.network_transmit
		local game_object_id = param1
		local position = param2
		local rotation = param3

		network_transmit:send_rpc_clients("rpc_set_animation_driven", game_object_id, position, rotation, is_affected_by_gravity)
	elseif r == 3 then
		local network_transmit = Managers.state.network.network_transmit
		local game_object_id = param1

		network_transmit:send_rpc_clients("rpc_set_script_driven", game_object_id, is_affected_by_gravity)
	elseif r == 4 then
		local network_transmit = Managers.state.network.network_transmit
		local game_object_id = param1

		network_transmit:send_rpc_clients("rpc_set_affected_by_gravity", game_object_id, is_affected_by_gravity)
	elseif r == 5 then
		local network_transmit = Managers.state.network.network_transmit
		local game_object_id = param1

		network_transmit:send_rpc_clients("rpc_set_linked_transport_driven", game_object_id, is_affected_by_gravity)
	end
end

AILocomotionExtensionC.set_animation_translation_scale = function (self, animation_translation_scale)
	-- function 10
	if not self._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_animation_translation_scale(self._engine_extension_id, animation_translation_scale)
	self._animation_translation_scale_box:store(animation_translation_scale)
end

AILocomotionExtensionC.set_animation_rotation_scale = function (self, animation_rotation_scale)
	-- function 11
	if not self._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_animation_rotation_scale(self._engine_extension_id, animation_rotation_scale)

	self._animation_rotation_scale = animation_rotation_scale
end

AILocomotionExtensionC.set_wanted_velocity_flat = function (self, wanted_velocity)
	-- function 12
	if not self._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_wanted_velocity_flat(self._engine_extension_id, wanted_velocity)
end

AILocomotionExtensionC.set_wanted_velocity = function (self, wanted_velocity)
	-- function 13
	if not self._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_wanted_velocity(self._engine_extension_id, wanted_velocity)
end

AILocomotionExtensionC.set_external_velocity = function (self, external_velocity)
	-- function 14
	if not self._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_external_velocity(self._engine_extension_id, external_velocity)
end

AILocomotionExtensionC.set_animation_external_velocity = function (self, external_velocity)
	-- function 15
	if not self._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_animation_external_velocity(self._engine_extension_id, external_velocity)
end

AILocomotionExtensionC.set_wanted_rotation = function (self, rotation)
	-- function 16
	if not self._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_wanted_rotation(self._engine_extension_id, rotation)
end

AILocomotionExtensionC.use_lerp_rotation = function (self, active)
	-- function 17
	if not self._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_use_lerp_rotation(self._engine_extension_id, active)
end

AILocomotionExtensionC.set_rotation_speed = function (self, rotation_speed)
	-- function 18
	if not self._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_rotation_speed(self._engine_extension_id, rotation_speed)
end

AILocomotionExtensionC.set_rotation_speed_modifier = function (self, rotation_speed_modifier, rotation_speed_modifier_lerp_time, start_time)
	-- function 19
	if not self._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_rotation_speed_modifier(self._engine_extension_id, rotation_speed_modifier, rotation_speed_modifier_lerp_time, start_time)
end

AILocomotionExtensionC.set_affected_by_gravity = function (self, affected_by_gravity)
	-- function 20
	if not self._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_affected_by_gravity(self._engine_extension_id, affected_by_gravity)
end

AILocomotionExtensionC.set_gravity = function (self, gravity)
	-- function 21
	if not self._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_gravity(self._engine_extension_id, gravity)
end

AILocomotionExtensionC.set_check_falling = function (self, state)
	-- function 22
	if not self._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_check_falling(self._engine_extension_id, state)
end

local movement_types = {
	script_driven = 0,
	snap_to_navmesh = 1,
	constrained_by_mover = 2,
	disabled = 3
}

AILocomotionExtensionC.set_movement_type = function (self, movement_type, override_mover_move_distance, ignore_forced_mover_kill)
	-- function 23
	if not self._engine_extension_id then
		return
	end

	if movement_type == self.movement_type then
		return true
	end

	self.movement_type = movement_type

	if movement_type == "script_driven" then
		MoverHelper.set_disable_reason(self._unit, self._mover_state, "constrained_by_mover", true)
	elseif movement_type == "snap_to_navmesh" then
		MoverHelper.set_disable_reason(self._unit, self._mover_state, "constrained_by_mover", true)
	elseif movement_type == "constrained_by_mover" then
		MoverHelper.set_disable_reason(self._unit, self._mover_state, "constrained_by_mover", false)
	end

	local kill = EngineOptimizedExtensions.ai_locomotion_set_movement_type(self._engine_extension_id, movement_types[movement_type], override_mover_move_distance)

	if kill and not ignore_forced_mover_kill then
		local damage_type = "forced"
		local damage_direction = Vector3(0, 0, -1)

		AiUtils.kill_unit(self._unit, nil, nil, damage_type, damage_direction)
	end

	return not kill
end

AILocomotionExtensionC.current_velocity = function (self)
	-- function 24
	if not self._engine_extension_id then
		return
	end

	return EngineOptimizedExtensions.ai_locomotion_get_velocity(self._engine_extension_id)
end

AILocomotionExtensionC.is_falling = function (self)
	-- function 25
	if not self._engine_extension_id then
		return
	end

	return EngineOptimizedExtensions.ai_locomotion_is_falling(self._engine_extension_id)
end

AILocomotionExtensionC.get_rotation_speed = function (self)
	-- function 26
	if not self._engine_extension_id then
		return
	end

	return EngineOptimizedExtensions.ai_locomotion_get_rotation_speed(self._engine_extension_id)
end

AILocomotionExtensionC.get_rotation_speed_modifier = function (self)
	-- function 27
	if not self._engine_extension_id then
		return
	end

	return EngineOptimizedExtensions.ai_locomotion_get_rotation_speed_modifier(self._engine_extension_id)
end

AILocomotionExtensionC.get_animation_rotation_scale = function (self)
	-- function 28
	return self._animation_rotation_scale
end

AILocomotionExtensionC.get_animation_translation_scale = function (self)
	-- function 29
	return self._animation_translation_scale_box:unbox()
end

AILocomotionExtensionC.set_disabled = function (self)
	-- function 30
	if not self._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_disabled(self._engine_extension_id)
	MoverHelper.set_disable_reason(self._unit, self._mover_state, "constrained_by_mover", true)
end

AILocomotionExtensionC.set_mover_disable_reason = function (self, reason, state)
	-- function 31
	MoverHelper.set_disable_reason(self._unit, self._mover_state, reason, state)
end

AILocomotionExtensionC.set_collision_disabled = function (self, reason, state)
	-- function 32
	if self._collision_state then
		MoverHelper.set_collision_disable_reason(self._unit, self._collision_state, reason, state)
	end
end
