-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/packmaster/packmaster_state_dragging.lua

PackmasterStateDragging = class(PackmasterStateDragging, EnemyCharacterState)

local flag = true
local num = 6

PackmasterStateDragging.init = function (self, arg_1_1)
	-- function 1
	EnemyCharacterState.init(self, arg_1_1, "packmaster_dragging")

	local var_1_0 = arg_1_1

	self.current_movement_speed_scale = 0
	self.latest_valid_navmesh_position = Vector3Box(math.huge, math.huge, math.huge)
	self.last_input_direction = Vector3Box(0, 0, 0)
	self._hoist_ability_id = self._career_extension:ability_id("hoist")
end

PackmasterStateDragging.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	local _unit = self._unit
	local _input_extension = self._input_extension
	local _first_person_extension = self._first_person_extension
	local _status_extension = self._status_extension
	local _inventory_extension = self._inventory_extension
	local _health_extension = self._health_extension
	local current_velocity = self._locomotion_extension:current_velocity()

	self._enter_time = arg_2_5
	self._move_input_direction = Vector3Box()

	StatusUtils.set_grabbed_by_pack_master_network("pack_master_pulling", arg_2_7, true, _unit)
	_status_extension:set_is_packmaster_dragging(arg_2_7)

	self._dragged_unit = arg_2_7

	if not flag then
		CharacterStateHelper.change_camera_state(self._player, "follow_third_person")
		self._first_person_extension:set_first_person_mode(false)
	end

	_first_person_extension:hide_weapons("catapulted")
	CharacterStateHelper.show_inventory_3p(_unit, false, true, Managers.player.is_server, _inventory_extension)

	self._weapon_3p = _inventory_extension:get_weapon_unit_3p()
	self.claw_left_hand_constraint = Unit.animation_find_constraint_target(_unit, "claw_target_left_hand")
	self.claw_right_hand_constraint = Unit.animation_find_constraint_target(_unit, "claw_target_right_hand")
	self.constraint_left_hand_node = Unit.node(self._weapon_3p, "a_left_hand")
	self.constraint_right_hand_node = Unit.node(self._weapon_3p, "a_right_hand")

	StatusUtils.set_grabbed_by_pack_master_network("pack_master_dragging", arg_2_7, true, _unit)

	local owner = Managers.player:owner(_unit)
	local flag_2 = not owner and owner.bot_player

	self.blackboard = BLACKBOARDS[_unit]
	self.breed = self.blackboard.breed

	self:set_breed_action("drag")

	if arg_2_6 == "standing" then
		self.current_movement_speed_scale = 0
	elseif not script_data.disable_nice_movement then
		local length = Vector3.length(current_velocity)
		local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(_unit)

		self.current_movement_speed_scale = math.min(length / get_movement_settings_table.move_speed, 1)
	else
		self.current_movement_speed_scale = 1
	end

	if not flag_2 then
		local normalize = Vector3.normalize(Vector3.flat(current_velocity))
		local current_rotation = _first_person_extension:current_rotation()
		local dot = Vector3.dot(Quaternion.right(current_rotation), normalize)
		local dot_2 = Vector3.dot(Vector3.normalize(Vector3.flat(Quaternion.forward(current_rotation))), normalize)
		local var_2_15 = Vector3(dot, dot_2, 0)

		self.last_input_direction:store(var_2_15)
	end

	local _get_packmaster_drag_animation, var_2_17 = self:_get_packmaster_drag_animation()

	self.move_anim_3p = _get_packmaster_drag_animation
	self.move_anim_1p = var_2_17

	CharacterStateHelper.play_animation_event(_unit, "drag_walk")
	CharacterStateHelper.play_animation_event(_unit, _get_packmaster_drag_animation)
	CharacterStateHelper.play_animation_event_first_person(_first_person_extension, var_2_17)
	CharacterStateHelper.look(_input_extension, self._player.viewport_name, _first_person_extension, _status_extension, _inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_2_5, _unit, _input_extension, _inventory_extension, _health_extension)
	self._locomotion_extension:enable_rotation_towards_velocity(false)

	self.is_bot = flag_2
	self._next_damage_pulse_time = 0
	self._unhook_on_exit = true
end

PackmasterStateDragging.update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local _csm = self._csm
	local _world = self._world
	local _unit = self._unit
	local _temp_params = self._temp_params
	local _dragged_unit = self._dragged_unit
	local has_extension = ScriptUnit.has_extension(_dragged_unit, "status_system")
	local flag = not has_extension and has_extension:get_is_ledge_hanging()

	if not HEALTH_ALIVE[_dragged_unit] and not flag then
		_csm:change_state("walking", _temp_params)

		return
	end

	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(_unit)
	local extension = ScriptUnit.extension(_dragged_unit, "inventory_system")
	local right_hand_wielded_unit_3p = extension:equipment().right_hand_wielded_unit_3p
	local get_wielded_slot_name = extension:get_wielded_slot_name()
	local _input_extension = self._input_extension
	local _status_extension = self._status_extension
	local _first_person_extension = self._first_person_extension
	local _locomotion_extension = self._locomotion_extension
	local _inventory_extension = self._inventory_extension
	local _career_extension = self._career_extension

	if not CharacterStateHelper.is_dead(_status_extension) then
		_csm:change_state("dead")

		return
	end

	local current_movement_speed_scale = self.current_movement_speed_scale
	local CharacterStateHelper = CharacterStateHelper

	if not _locomotion_extension:is_on_ground() then
		ScriptUnit.extension(_unit, "whereabouts_system"):set_is_onground()
	end

	if not CharacterStateHelper.is_using_transport(_status_extension) then
		_csm:change_state("using_transport")

		return
	end

	if not CharacterStateHelper.is_pushed(_status_extension) then
		_status_extension:set_pushed(false)

		local pushed = get_movement_settings_table.stun_settings.pushed

		pushed.hit_react_type = _status_extension:hit_react_type() .. "_push"

		_csm:change_state("stunned", pushed)

		return
	end

	if not CharacterStateHelper.is_staggered(_status_extension) then
		_csm:change_state("staggered")

		return true
	end

	if not CharacterStateHelper.is_block_broken(_status_extension) then
		_status_extension:set_block_broken(false)

		local parry_broken = get_movement_settings_table.stun_settings.parry_broken

		parry_broken.hit_react_type = "medium_push"

		_csm:change_state("stunned", parry_broken)

		return
	end

	if not _locomotion_extension:is_animation_driven() then
		return
	end

	local world_position = Unit.world_position(self._weapon_3p, self.constraint_right_hand_node)
	local world_position_2 = Unit.world_position(self._weapon_3p, self.constraint_left_hand_node)

	Unit.animation_set_constraint_target(_unit, self.claw_left_hand_constraint, world_position)
	Unit.animation_set_constraint_target(_unit, self.claw_right_hand_constraint, world_position_2)

	local is_device_active = Managers.input:is_device_active("gamepad")
	local is_crouching = _status_extension:is_crouching()
	local owner = Managers.player:owner(_unit)
	local get_movement_input = CharacterStateHelper.get_movement_input(_input_extension)
	local has_move_input = CharacterStateHelper.has_move_input(_input_extension)

	if not self.is_bot then
		local _breed = self._breed

		_breed = not _breed and self._breed.breed_move_acceleration_up

		local _breed_2 = self._breed

		_breed_2 = not _breed_2 and self._breed.breed_move_acceleration_down

		local num_2 = _breed * arg_3_3

		num_2 = num_2 or get_movement_settings_table.move_acceleration_up * arg_3_3

		local num_3 = _breed_2 * arg_3_3

		num_3 = num_3 or get_movement_settings_table.move_acceleration_down * arg_3_3

		if not has_move_input then
			current_movement_speed_scale = math.min(1, current_movement_speed_scale + num_2)

			if not is_device_active then
				current_movement_speed_scale = Vector3.length(get_movement_input) * current_movement_speed_scale
			end
		else
			current_movement_speed_scale = math.max(0, current_movement_speed_scale - num_3)
		end
	else
		current_movement_speed_scale = not has_move_input and 1 and 0
	end

	local num_4 = self:_get_current_drag_speed(arg_3_5) * current_movement_speed_scale * get_movement_settings_table.player_speed_scale
	local normalize = Vector3.normalize(get_movement_input)

	if Vector3.length_squared(get_movement_input) == 0 then
		normalize = self.last_input_direction:unbox()
	else
		self.last_input_direction:store(normalize)
	end

	local var_3_34 = POSITION_LOOKUP[_dragged_unit]
	local num_5 = var_3_34 - POSITION_LOOKUP[_unit]

	Vector3.set_z(num_5, 0)

	local normalize_2 = Vector3.normalize(num_5)
	local look = Quaternion.look(normalize_2, Vector3(0, 0, 1))

	Unit.set_local_rotation(_unit, 0, look)

	local flag_2 = self.move_anim_1p == "idle"

	CharacterStateHelper.packmaster_move_on_ground(arg_3_5, _first_person_extension, _input_extension, _locomotion_extension, normalize, num_4, _unit, self._player, normalize_2, _dragged_unit, flag_2)
	CharacterStateHelper.look(_input_extension, self._player.viewport_name, _first_person_extension, _status_extension, _inventory_extension)

	local _get_packmaster_drag_animation, var_3_40 = self:_get_packmaster_drag_animation()
	local distance = Vector3.distance(var_3_34, POSITION_LOOKUP[_unit])
	local clamp = math.clamp(distance - 2, -11.9, 11.9)

	Managers.state.network:anim_set_variable_float(_unit, "distance_to_target", clamp)

	if not (_get_packmaster_drag_animation ~= self.move_anim_3p or var_3_40 == self.move_anim_1p) then
		local extension_2 = ScriptUnit.extension(_dragged_unit, "inventory_system")
		local get_wielded_slot_name_2 = extension_2:get_wielded_slot_name()
		local flag_3 = not extension_2:equipment().right_hand_wielded_unit_3p and get_wielded_slot_name_2 == "slot_packmaster_claw"

		if var_3_40 ~= "idle" or not flag_3 then
			Managers.state.entity:system("inventory_system"):weapon_anim_event(_dragged_unit, "attack_grab_idle")
		end

		self.move_anim_3p = _get_packmaster_drag_animation
		self.move_anim_1p = var_3_40

		CharacterStateHelper.play_animation_event(_unit, "drag_walk")
		CharacterStateHelper.play_animation_event(_unit, _get_packmaster_drag_animation)
		CharacterStateHelper.play_animation_event_first_person(_first_person_extension, var_3_40)
	end

	local current_relative_velocity_3p = _locomotion_extension:current_relative_velocity_3p()

	Managers.state.network:anim_set_variable_float(_unit, "drag_move_forward", math.clamp(current_relative_velocity_3p.y, -12, 12))
	Managers.state.network:anim_set_variable_float(_unit, "drag_move_right", math.clamp(current_relative_velocity_3p.x, -12, 12))

	self.current_movement_speed_scale = current_movement_speed_scale

	local extension_3 = ScriptUnit.extension(_dragged_unit, "status_system")

	if not extension_3:is_pounced_down() then
		local _temp_params_2 = self._temp_params

		_csm:change_state("walking", _temp_params_2)

		return
	end

	if distance > num then
		local _temp_params_3 = self._temp_params

		_csm:change_state("walking", _temp_params_3)

		return
	end

	if not _career_extension:ability_was_triggered(self._hoist_ability_id) then
		self._unhook_on_exit = false

		_csm:change_state("packmaster_hoisting", _dragged_unit)

		return
	end

	local get_pack_master_grabber = extension_3:get_pack_master_grabber()

	if not (not get_pack_master_grabber and get_pack_master_grabber == self._unit) then
		_csm:change_state("walking", _temp_params)
	end

	self:update_damage(_unit, _dragged_unit, arg_3_5)
end

PackmasterStateDragging._get_current_drag_speed = function (self, arg_4_1)
	-- function 4
	local initial_drag_movement_speed = self.breed.initial_drag_movement_speed
	local initial_drag_movement_speed_duration = self.breed.initial_drag_movement_speed_duration
	local drag_movement_speed = self.breed.drag_movement_speed
	local num = arg_4_1 - self._enter_time
	local var_4_4

	if num < initial_drag_movement_speed_duration then
		var_4_4 = initial_drag_movement_speed
	else
		var_4_4 = drag_movement_speed
	end

	return var_4_4
end

PackmasterStateDragging.on_exit = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	-- function 5
	if not self._unhook_on_exit then
		self:_release_dragged_target()
	end

	self._locomotion_extension:enable_rotation_towards_velocity(true)
	self:set_breed_action("n/a")

	if not self.is_bot then
		local local_player = Managers.player:local_player()
		local owner = Managers.player:owner(self._unit)

		if not (not local_player and local_player ~= owner) then
			local round = math.round(arg_5_5 - self._enter_time)

			if round > 0 then
				local stats_id = local_player:stats_id()

				Managers.player:statistics_db():modify_stat_by_amount(stats_id, "vs_drag_heroes", round)
			end
		end
	end
end

PackmasterStateDragging._release_dragged_target = function (self)
	-- function 6
	local _status_extension = self._status_extension
	local _first_person_extension = self._first_person_extension

	if not flag then
		CharacterStateHelper.change_camera_state(self._player, "follow")
		_first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)
	end

	_first_person_extension:unhide_weapons("catapulted")
	CharacterStateHelper.show_inventory_3p(self._unit, true, true, Managers.player.is_server, self._inventory_extension)
	_status_extension:set_packmaster_released()

	local _dragged_unit = self._dragged_unit

	if not _dragged_unit and not Unit.alive(_dragged_unit) then
		StatusUtils.set_grabbed_by_pack_master_network("pack_master_unhooked", _dragged_unit, false, self._unit)
	end
end

PackmasterStateDragging.update_damage = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	if arg_7_3 > self._next_damage_pulse_time then
		local breed = self.breed
		local dragging_damage_amount = breed.dragging_damage_amount
		local dragging_hit_zone_name = breed.dragging_hit_zone_name
		local dragging_damage_type = breed.dragging_damage_type
		local var_7_4

		DamageUtils.add_damage_network(arg_7_2, arg_7_1, dragging_damage_amount, dragging_hit_zone_name, dragging_damage_type, nil, Vector3.up(), breed.name, nil, nil, nil, var_7_4, nil, nil, nil, nil, nil, nil, 1)

		self._next_damage_pulse_time = arg_7_3 + breed.dragging_time_to_damage
	end
end

local num_2 = 0.05

PackmasterStateDragging._get_packmaster_drag_animation = function (self)
	-- function 8
	local _locomotion_extension = self._locomotion_extension

	if Vector3.length(_locomotion_extension:current_velocity()) < num_2 then
		return "attack_grab_idle", "idle"
	end

	local get_movement_input = CharacterStateHelper.get_movement_input(self._input_extension)
	local _unit = self._unit
	local get_data = Unit.get_data(_unit, "breed")
	local var_8_4

	if not get_data and not get_data.run_threshold then
		var_8_4 = Vector3.length(Vector3.flat(_locomotion_extension:current_velocity())) < get_data.run_threshold
	end

	if get_movement_input.y < 0 then
		local str = "move_bwd"
		local flag

		flag = not var_8_4 and "walk_bwd" and "move_bwd"

		return str, flag
	end

	local str_2 = "move_fwd"
	local flag_2

	flag_2 = not var_8_4 and "walk_fwd" and "move_fwd"

	return str_2, flag_2
end
