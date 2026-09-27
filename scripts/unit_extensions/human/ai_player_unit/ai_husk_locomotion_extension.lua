-- chunkname: @scripts/unit_extensions/human/ai_player_unit/ai_husk_locomotion_extension.lua

require("scripts/helpers/mover_helper")

local num = 0.5

AiHuskLocomotionExtension = class(AiHuskLocomotionExtension)

AiHuskLocomotionExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._unit = arg_1_2
	self._system_data = arg_1_3.system_data
	self._game = arg_1_3.game
	self._go_id = arg_1_3.go_id

	Unit.set_animation_merge_options(arg_1_2)

	self._velocity = Vector3Box(0, 0, 0)
	self.breed = arg_1_3.breed

	local system = Managers.state.entity:system("ai_system")
	local client_traverse_logic = system:client_traverse_logic()

	self._nav_world = system:nav_world()
	self._world = arg_1_1.world
	self._traverse_logic = client_traverse_logic
	self._move_speed_anim_var = Unit.animation_find_variable(arg_1_2, "move_speed")
	self._animation_translation_scale = Vector3Box(1, 1, 1)
	self._animation_rotation_scale = 1
	self.is_affected_by_gravity = false
	self.hit_wall = false

	local on_spawn_flow_event = LevelHelper:current_level_settings().on_spawn_flow_event

	if not on_spawn_flow_event then
		Unit.flow_event(arg_1_2, on_spawn_flow_event)
	end

	self.constrain_min = {
		0,
		0,
		0
	}
	self.constrain_max = {
		0,
		0,
		0
	}
	self.last_lerp_position = Vector3Box(Unit.local_position(arg_1_2, 0))
	self.last_lerp_position_offset = Vector3Box()
	self.accumulated_movement = Vector3Box()

	local game_object_field = GameSession.game_object_field(self._game, self._go_id, "has_teleported")

	self.has_teleported = game_object_field
	self._pos_lerp_time = 0
	self._update_function_name = "update_network_driven"
	self._mover_state = MoverHelper.create_mover_state()

	local str = "c_mover_collision"

	if not Unit.actor(arg_1_2, str) then
		self._collision_state = MoverHelper.create_collision_state(arg_1_2, "c_mover_collision")
	end

	local set_active_mover = MoverHelper.set_active_mover
	local var_1_6 = arg_1_2
	local _mover_state = self._mover_state
	local default_mover = self.breed.default_mover

	default_mover = default_mover or "mover"

	set_active_mover(var_1_6, _mover_state, default_mover)
	self:set_mover_disable_reason("not_constrained_by_mover", true)

	self._system_data.all_update_units[arg_1_2] = self
	self._system_data.pure_network_update_units[arg_1_2] = self

	local var_1_9 = Managers.state.unit_spawner.unit_template_lut[self.breed.unit_template]
	local flag = not var_1_9 and var_1_9.go_type
	local game_object_template = Managers.state.network:game_object_template(flag)
	local flag_2 = not game_object_template and not not game_object_template.syncs_rotation or false

	self._engine_extension_id = EngineOptimizedExtensions.ai_husk_locomotion_register_extension(arg_1_2, self._go_id, game_object_field, client_traverse_logic, flag_2)

	EngineOptimizedExtensions.ai_husk_locomotion_set_is_network_driven(self._engine_extension_id, true)

	self.is_network_driven = true
end

AiHuskLocomotionExtension.destroy = function (self)
	-- function 2
	self:_cleanup()
end

AiHuskLocomotionExtension.freeze = function (self)
	-- function 3
	self:_cleanup()
end

AiHuskLocomotionExtension._cleanup = function (self)
	-- function 4
	local _unit = self._unit

	self._system_data.all_update_units[_unit] = nil
	self._system_data.pure_network_update_units[_unit] = nil
	self._system_data.other_update_units[_unit] = nil

	if not self._engine_extension_id then
		EngineOptimizedExtensions.ai_husk_locomotion_unregister_extension(self._engine_extension_id)

		self._engine_extension_id = nil
	end
end

AiHuskLocomotionExtension.unfreeze = function (self)
	-- function 5
	local _unit = self._unit

	Unit.set_animation_merge_options(_unit)
	self._velocity:store(Vector3(0, 0, 0))
	self._animation_translation_scale:store(Vector3(1, 1, 1))

	self._animation_rotation_scale = 1
	self.is_affected_by_gravity = false
	self.hit_wall = false

	local on_spawn_flow_event = LevelHelper:current_level_settings().on_spawn_flow_event

	if not on_spawn_flow_event then
		Unit.flow_event(_unit, on_spawn_flow_event)
	end

	self.constrain_min = {
		0,
		0,
		0
	}
	self.constrain_max = {
		0,
		0,
		0
	}

	self.last_lerp_position:store(Unit.local_position(_unit, 0))
	self.last_lerp_position_offset:store(Vector3(0, 0, 0))
	self.accumulated_movement:store(Vector3(0, 0, 0))

	self._pos_lerp_time = 0
	self._update_function_name = "update_network_driven"
	self._mover_state = MoverHelper.create_mover_state()

	local str = "c_mover_collision"

	if not Unit.actor(_unit, str) then
		self._collision_state = MoverHelper.create_collision_state(_unit, "c_mover_collision")
	end

	local set_active_mover = MoverHelper.set_active_mover
	local var_5_4 = _unit
	local _mover_state = self._mover_state
	local default_mover = self.breed.default_mover

	default_mover = default_mover or "mover"

	set_active_mover(var_5_4, _mover_state, default_mover)
	self:set_mover_disable_reason("not_constrained_by_mover", true)

	self._system_data.all_update_units[_unit] = self
	self._system_data.pure_network_update_units[_unit] = self

	local var_5_7 = Managers.state.unit_spawner.unit_template_lut[self.breed.unit_template]
	local flag = not var_5_7 and var_5_7.go_type
	local game_object_template = Managers.state.network:game_object_template(flag)
	local flag_2 = not game_object_template and not not game_object_template.syncs_rotation or false

	self._engine_extension_id = EngineOptimizedExtensions.ai_husk_locomotion_register_extension(_unit, self._go_id, self.has_teleported, self._client_traverse_logic, flag_2)

	EngineOptimizedExtensions.ai_husk_locomotion_set_is_network_driven(self._engine_extension_id, true)

	self.is_network_driven = true
end

AiHuskLocomotionExtension.set_animation_translation_scale = function (self, arg_6_1)
	-- function 6
	self._animation_translation_scale = Vector3Box(arg_6_1)

	if not self._engine_extension_id then
		EngineOptimizedExtensions.ai_husk_locomotion_set_animation_translation_scale(self._engine_extension_id, arg_6_1)
	end
end

AiHuskLocomotionExtension.set_animation_rotation_scale = function (self, arg_7_1)
	-- function 7
	self._animation_rotation_scale = arg_7_1

	if not self._engine_extension_id then
		EngineOptimizedExtensions.ai_husk_locomotion_set_animation_rotation_scale(self._engine_extension_id, arg_7_1)
	end
end

AiHuskLocomotionExtension.set_affected_by_gravity = function (self, arg_8_1)
	-- function 8
	self.is_affected_by_gravity = arg_8_1

	if not self._engine_extension_id then
		EngineOptimizedExtensions.ai_husk_locomotion_set_is_affected_by_gravity(self._engine_extension_id, arg_8_1)
	end
end

AiHuskLocomotionExtension.set_animation_driven = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	if not self._engine_extension_id then
		return
	end

	arg_9_2 = not not arg_9_2
	self.is_animation_driven = arg_9_1
	self.has_network_driven_rotation = arg_9_3
	self.is_affected_by_gravity = arg_9_2
	self.hit_wall = false

	local flag = (not not arg_9_4 or not arg_9_1) and not arg_9_2

	self.is_network_driven = flag

	self:set_mover_disable_reason("not_constrained_by_mover", true)

	local _system_data = self._system_data

	if not flag then
		_system_data.other_update_units[self._unit] = nil
		_system_data.pure_network_update_units[self._unit] = self
	else
		_system_data.other_update_units[self._unit] = self
		_system_data.pure_network_update_units[self._unit] = nil
	end

	EngineOptimizedExtensions.ai_husk_locomotion_set_has_network_driven_rotation(self._engine_extension_id, arg_9_3)
	EngineOptimizedExtensions.ai_husk_locomotion_set_is_network_driven(self._engine_extension_id, flag)
	EngineOptimizedExtensions.ai_husk_locomotion_set_is_affected_by_gravity(self._engine_extension_id, arg_9_2)
end

AiHuskLocomotionExtension.set_mover_disable_reason = function (self, arg_10_1, arg_10_2)
	-- function 10
	MoverHelper.set_disable_reason(self._unit, self._mover_state, arg_10_1, arg_10_2)
end

AiHuskLocomotionExtension.set_constrained = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	if not self._engine_extension_id then
		return
	end

	self.is_constrained = arg_11_1

	if not arg_11_1 then
		Vector3Aux.box(self.constrain_min, arg_11_2)
		Vector3Aux.box(self.constrain_max, arg_11_3)
	end

	EngineOptimizedExtensions.ai_husk_locomotion_set_is_constrained(self._engine_extension_id, arg_11_1, arg_11_2, arg_11_3)
end

AiHuskLocomotionExtension.teleport_to = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	-- function 12
	if not self._engine_extension_id then
		return
	end

	self.hit_wall = false

	local _unit = self._unit
	local mover = Unit.mover(_unit)

	if not (not mover and arg_12_4) then
		local override_mover_move_distance = self.breed.override_mover_move_distance

		override_mover_move_distance = override_mover_move_distance or num

		Mover.set_position(mover, arg_12_1)
		LocomotionUtils.separate_mover_fallbacks(mover, override_mover_move_distance)

		arg_12_1 = Mover.position(mover)
	end

	arg_12_3 = arg_12_3 or Vector3.zero()

	Unit.set_local_position(_unit, 0, arg_12_1)
	Unit.set_local_rotation(_unit, 0, arg_12_2)
	self._velocity:store(arg_12_3)

	self._pos_lerp_time = 0

	EngineOptimizedExtensions.ai_husk_locomotion_teleport_to(self._engine_extension_id, arg_12_1, arg_12_2, arg_12_3)
end

AiHuskLocomotionExtension.set_collision_disabled = function (self, arg_13_1, arg_13_2)
	-- function 13
	if not self._collision_state then
		MoverHelper.set_collision_disable_reason(self._unit, self._collision_state, arg_13_1, arg_13_2)
	end
end

AiHuskLocomotionExtension.current_velocity = function (self)
	-- function 14
	return self._velocity:unbox()
end

AiHuskLocomotionExtension.traverse_logic = function (self)
	-- function 15
	return self._traverse_logic
end

AiHuskLocomotionExtension.hot_join_sync = function (arg_16_0, arg_16_1)
	-- function 16
	assert(false, "ai is never husk on server")
end
