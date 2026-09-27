-- chunkname: @scripts/unit_extensions/human/ai_player_unit/ai_locomotion_extension_c.lua

require("scripts/helpers/mover_helper")

local num = 20

AILocomotionExtensionC = class(AILocomotionExtensionC)

AILocomotionExtensionC.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._unit = arg_1_2

	local breed = arg_1_3.breed

	self.breed = breed

	local go_type = Managers.state.unit_spawner.unit_template_lut[breed.unit_template].go_type
	local game_object_template = Managers.state.network:game_object_template(go_type)
	local fassert = fassert
	local syncs_rotation = game_object_template.syncs_rotation

	syncs_rotation = syncs_rotation or game_object_template.syncs_yaw

	fassert(syncs_rotation, "AI Locomotion error. AI units must have syncs_rotation or syncs_yaw set in its game_object_template.")

	local run_speed = breed.run_speed
	local syncs_rotation_2 = game_object_template.syncs_rotation

	syncs_rotation_2 = syncs_rotation_2 or false
	self._engine_extension_id = EngineOptimizedExtensions.ai_locomotion_register_extension(arg_1_2, num, run_speed, syncs_rotation_2)
	self._animation_rotation_scale = 1
	self._animation_translation_scale_box = Vector3Box(1, 1, 1)
	self._mover_state = MoverHelper.create_mover_state()

	local str = "c_mover_collision"

	if not Unit.actor(arg_1_2, str) then
		self._collision_state = MoverHelper.create_collision_state(arg_1_2, str)
	end

	local set_active_mover = MoverHelper.set_active_mover
	local var_1_9 = arg_1_2
	local _mover_state = self._mover_state
	local default_mover = breed.default_mover

	default_mover = default_mover or "mover"

	set_active_mover(var_1_9, _mover_state, default_mover)
end

AILocomotionExtensionC.ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	if not self._engine_extension_id then
		EngineOptimizedExtensions.ai_locomotion_ai_ready(self._engine_extension_id, arg_2_1)
	end
end

AILocomotionExtensionC.destroy = function (self)
	-- function 3
	if not self._engine_extension_id then
		EngineOptimizedExtensions.ai_locomotion_destroy_extension(self._engine_extension_id)

		self._engine_extension_id = nil
	end
end

AILocomotionExtensionC.freeze = function (self)
	-- function 4
	if not self._engine_extension_id then
		EngineOptimizedExtensions.ai_locomotion_destroy_extension(self._engine_extension_id)

		self._engine_extension_id = nil
	end
end

AILocomotionExtensionC.unfreeze = function (self, arg_5_1)
	-- function 5
	local breed = BLACKBOARDS[arg_5_1].breed
	local run_speed = breed.run_speed
	local go_type = Managers.state.unit_spawner.unit_template_lut[breed.unit_template].go_type
	local syncs_rotation = Managers.state.network:game_object_template(go_type).syncs_rotation

	syncs_rotation = syncs_rotation or false
	self._engine_extension_id = EngineOptimizedExtensions.ai_locomotion_register_extension(arg_5_1, num, run_speed, syncs_rotation)
	self._animation_rotation_scale = 1

	self._animation_translation_scale_box:store(1, 1, 1)

	local set_active_mover = MoverHelper.set_active_mover
	local var_5_5 = arg_5_1
	local _mover_state = self._mover_state
	local default_mover = breed.default_mover

	default_mover = default_mover or "mover"

	set_active_mover(var_5_5, _mover_state, default_mover)
	self:teleport_to(POSITION_LOOKUP[arg_5_1], Unit.local_rotation(arg_5_1, 0))
end

AILocomotionExtensionC.hot_join_sync = function (self, arg_6_1)
	-- function 6
	if not FROZEN[self._unit] then
		return
	end

	local var_6_0 = PEER_ID_TO_CHANNEL[arg_6_1]
	local _unit = self._unit
	local unit_game_object_id = Managers.state.network:unit_game_object_id(_unit)

	if not Unit.has_animation_state_machine(_unit) then
		local breed = BLACKBOARDS[_unit].breed

		RPC[breed.animation_sync_rpc](var_6_0, unit_game_object_id, Unit.animation_get_state(_unit))
	else
		RPC.rpc_hot_join_nail_to_wall_fix(var_6_0, unit_game_object_id)
	end
end

AILocomotionExtensionC.set_mover_displacement = function (self, arg_7_1, arg_7_2)
	-- function 7
	if not self._engine_extension_id then
		EngineOptimizedExtensions.ai_locomotion_set_mover_displacement(self._engine_extension_id, arg_7_1, arg_7_2)
	end
end

AILocomotionExtensionC.teleport_to = function (self, arg_8_1, arg_8_2)
	-- function 8
	if not self._engine_extension_id then
		EngineOptimizedExtensions.ai_locomotion_teleport_to(self._engine_extension_id, arg_8_1, arg_8_2)
	end
end

AILocomotionExtensionC.set_animation_driven = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	if not self._engine_extension_id then
		return
	end

	arg_9_2 = arg_9_2 or false

	local ai_locomotion_set_animation_driven, var_9_1, var_9_2, var_9_3 = EngineOptimizedExtensions.ai_locomotion_set_animation_driven(self._engine_extension_id, arg_9_1, arg_9_2, arg_9_3, arg_9_4)

	if ai_locomotion_set_animation_driven == 1 then
		local network_transmit = Managers.state.network.network_transmit
		local var_9_5 = var_9_1
		local var_9_6 = var_9_2
		local var_9_7 = var_9_3

		network_transmit:send_rpc_clients("rpc_set_animation_driven_script_movement", var_9_5, var_9_6, var_9_7, arg_9_2)
	elseif ai_locomotion_set_animation_driven == 2 then
		local network_transmit_2 = Managers.state.network.network_transmit
		local var_9_9 = var_9_1
		local var_9_10 = var_9_2
		local var_9_11 = var_9_3

		network_transmit_2:send_rpc_clients("rpc_set_animation_driven", var_9_9, var_9_10, var_9_11, arg_9_2)
	elseif ai_locomotion_set_animation_driven == 3 then
		local network_transmit_3 = Managers.state.network.network_transmit
		local var_9_13 = var_9_1

		network_transmit_3:send_rpc_clients("rpc_set_script_driven", var_9_13, arg_9_2)
	elseif ai_locomotion_set_animation_driven == 4 then
		local network_transmit_4 = Managers.state.network.network_transmit
		local var_9_15 = var_9_1

		network_transmit_4:send_rpc_clients("rpc_set_affected_by_gravity", var_9_15, arg_9_2)
	elseif ai_locomotion_set_animation_driven == 5 then
		local network_transmit_5 = Managers.state.network.network_transmit
		local var_9_17 = var_9_1

		network_transmit_5:send_rpc_clients("rpc_set_linked_transport_driven", var_9_17, arg_9_2)
	end
end

AILocomotionExtensionC.set_animation_translation_scale = function (self, arg_10_1)
	-- function 10
	if not self._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_animation_translation_scale(self._engine_extension_id, arg_10_1)
	self._animation_translation_scale_box:store(arg_10_1)
end

AILocomotionExtensionC.set_animation_rotation_scale = function (self, arg_11_1)
	-- function 11
	if not self._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_animation_rotation_scale(self._engine_extension_id, arg_11_1)

	self._animation_rotation_scale = arg_11_1
end

AILocomotionExtensionC.set_wanted_velocity_flat = function (self, arg_12_1)
	-- function 12
	if not self._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_wanted_velocity_flat(self._engine_extension_id, arg_12_1)
end

AILocomotionExtensionC.set_wanted_velocity = function (self, arg_13_1)
	-- function 13
	if not self._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_wanted_velocity(self._engine_extension_id, arg_13_1)
end

AILocomotionExtensionC.set_external_velocity = function (self, arg_14_1)
	-- function 14
	if not self._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_external_velocity(self._engine_extension_id, arg_14_1)
end

AILocomotionExtensionC.set_animation_external_velocity = function (self, arg_15_1)
	-- function 15
	if not self._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_animation_external_velocity(self._engine_extension_id, arg_15_1)
end

AILocomotionExtensionC.set_wanted_rotation = function (self, arg_16_1)
	-- function 16
	if not self._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_wanted_rotation(self._engine_extension_id, arg_16_1)
end

AILocomotionExtensionC.use_lerp_rotation = function (self, arg_17_1)
	-- function 17
	if not self._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_use_lerp_rotation(self._engine_extension_id, arg_17_1)
end

AILocomotionExtensionC.set_rotation_speed = function (self, arg_18_1)
	-- function 18
	if not self._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_rotation_speed(self._engine_extension_id, arg_18_1)
end

AILocomotionExtensionC.set_rotation_speed_modifier = function (self, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	if not self._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_rotation_speed_modifier(self._engine_extension_id, arg_19_1, arg_19_2, arg_19_3)
end

AILocomotionExtensionC.set_affected_by_gravity = function (self, arg_20_1)
	-- function 20
	if not self._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_affected_by_gravity(self._engine_extension_id, arg_20_1)
end

AILocomotionExtensionC.set_gravity = function (self, arg_21_1)
	-- function 21
	if not self._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_gravity(self._engine_extension_id, arg_21_1)
end

AILocomotionExtensionC.set_check_falling = function (self, arg_22_1)
	-- function 22
	if not self._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_check_falling(self._engine_extension_id, arg_22_1)
end

local tbl = {
	script_driven = 0,
	snap_to_navmesh = 1,
	constrained_by_mover = 2,
	disabled = 3
}

AILocomotionExtensionC.set_movement_type = function (self, arg_23_1, arg_23_2, arg_23_3)
	-- function 23
	if not self._engine_extension_id then
		return
	end

	if arg_23_1 == self.movement_type then
		return true
	end

	self.movement_type = arg_23_1

	if arg_23_1 == "script_driven" then
		MoverHelper.set_disable_reason(self._unit, self._mover_state, "constrained_by_mover", true)
	elseif arg_23_1 == "snap_to_navmesh" then
		MoverHelper.set_disable_reason(self._unit, self._mover_state, "constrained_by_mover", true)
	elseif arg_23_1 == "constrained_by_mover" then
		MoverHelper.set_disable_reason(self._unit, self._mover_state, "constrained_by_mover", false)
	end

	local ai_locomotion_set_movement_type = EngineOptimizedExtensions.ai_locomotion_set_movement_type(self._engine_extension_id, tbl[arg_23_1], arg_23_2)

	if not (not ai_locomotion_set_movement_type and arg_23_3) then
		local str = "forced"
		local var_23_2 = Vector3(0, 0, -1)

		AiUtils.kill_unit(self._unit, nil, nil, str, var_23_2)
	end

	return not ai_locomotion_set_movement_type
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

AILocomotionExtensionC.set_mover_disable_reason = function (self, arg_31_1, arg_31_2)
	-- function 31
	MoverHelper.set_disable_reason(self._unit, self._mover_state, arg_31_1, arg_31_2)
end

AILocomotionExtensionC.set_collision_disabled = function (self, arg_32_1, arg_32_2)
	-- function 32
	if not self._collision_state then
		MoverHelper.set_collision_disable_reason(self._unit, self._collision_state, arg_32_1, arg_32_2)
	end
end
