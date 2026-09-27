-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_lunging.lua

local POSITION_LOOKUP = POSITION_LOOKUP

EnemyCharacterStateLunging = class(EnemyCharacterStateLunging, EnemyCharacterState)

EnemyCharacterStateLunging.init = function (self, arg_1_1)
	-- function 1
	EnemyCharacterState.init(self, arg_1_1, "lunging")

	self._direction = Vector3Box()
	self._last_position = Vector3Box()
end

EnemyCharacterStateLunging._on_enter_animation = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	if not arg_2_3 then
		CharacterStateHelper.play_animation_event_with_variable_float(arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	else
		CharacterStateHelper.play_animation_event(arg_2_1, arg_2_2)
	end

	local _first_person_extension = self._first_person_extension

	CharacterStateHelper.play_animation_event_first_person(_first_person_extension, arg_2_5 or arg_2_2)
end

EnemyCharacterStateLunging.on_enter = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	-- function 3
	local _unit = self._unit
	local _input_extension = self._input_extension
	local _first_person_extension = self._first_person_extension
	local _status_extension = self._status_extension
	local do_lunge = _status_extension.do_lunge

	self._lunge_data = do_lunge
	_status_extension.do_lunge = false
	self._career_extension = ScriptUnit.extension(_unit, "career_system")
	self._first_person_unit = _first_person_extension:get_first_person_unit()

	local num

	if not do_lunge.damage_start_time then
		num = arg_3_5 + do_lunge.damage_start_time

		if not num then
			-- Nothing
		end
	end

	num = arg_3_5

	::label_3_0::

	self.damage_start_time = num

	local forward = Quaternion.forward(self._first_person_extension:current_rotation())

	Vector3.set_z(forward, 0)

	local normalize = Vector3.normalize(forward)
	local look = Quaternion.look(normalize, Vector3.up())

	Unit.set_local_rotation(_unit, 0, look)
	CharacterStateHelper.look(_input_extension, self._player.viewport_name, _first_person_extension, _status_extension, self._inventory_extension)
	self:_on_enter_animation(_unit, do_lunge.animation_event, do_lunge.animation_variable_name, do_lunge.animation_variable_value, do_lunge.first_person_animation_event)

	self._num_impacts = 0
	self._amount_of_mass_hit = 0
	self._hit_units = {}
	self._start_time = arg_3_5

	self._last_position:store(POSITION_LOOKUP[_unit])
	self._direction:store(normalize)

	self._falling = false

	local lunge_events = do_lunge.lunge_events

	if not lunge_events then
		local start = lunge_events.start

		if not start then
			start(self)
		end
	end

	_first_person_extension:disable_rig_movement()

	local damage = do_lunge.damage

	if not damage then
		local get_career_power_level = self._career_extension:get_career_power_level()
		local power_level_multiplier = damage.power_level_multiplier
		local damage_profile = damage.damage_profile

		damage_profile = damage_profile or "default"

		local _parse_attack_data, var_3_16, var_3_17, var_3_18, var_3_19 = self:_parse_attack_data(damage)

		self.damage_profile_id = NetworkLookup.damage_profiles[damage_profile]

		local var_3_20 = DamageProfileTemplates[damage_profile]

		self.damage_profile = var_3_20

		local get_difficulty = Managers.state.difficulty:get_difficulty()
		local scale_power_levels = ActionUtils.scale_power_levels(var_3_16, "cleave", _unit, get_difficulty)
		local get_max_targets, var_3_24 = ActionUtils.get_max_targets(var_3_20, scale_power_levels)

		self.max_targets_attack = get_max_targets
		self.max_targets_impact = var_3_24
		self.max_targets = not (var_3_24 < get_max_targets) or not get_max_targets or var_3_24
	end

	if not do_lunge.dodge and not Managers.state.network:game() then
		_status_extension:set_is_dodging(true)

		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(_unit)

		network.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, true, unit_game_object_id, 0)
	end
end

EnemyCharacterStateLunging.on_exit = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	-- function 4
	local _lunge_data = self._lunge_data
	local _hit = self._hit
	local first_person_animation_end_event = _lunge_data.first_person_animation_end_event

	if not first_person_animation_end_event then
		CharacterStateHelper.play_animation_event_first_person(self._first_person_extension, first_person_animation_end_event)
	end

	local animation_end_event = _lunge_data.animation_end_event

	if not animation_end_event then
		if not _lunge_data.animation_variable_name and not _lunge_data.animation_variable_value then
			CharacterStateHelper.play_animation_event_with_variable_float(arg_4_1, animation_end_event, _lunge_data.animation_variable_name, _lunge_data.animation_variable_value)
		else
			CharacterStateHelper.play_animation_event(arg_4_1, animation_end_event)
		end
	end

	local lunge_events = self._lunge_data.lunge_events

	if not lunge_events then
		local finished = lunge_events.finished

		if not finished then
			finished(self)
		end
	end

	if not _lunge_data.lunge_finish then
		_lunge_data.lunge_finish(arg_4_1)
	end

	if not _lunge_data.dodge and not Managers.state.network:game() then
		self._status_extension:set_is_dodging(false)

		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_4_1)

		network.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, false, unit_game_object_id, 0)
	end

	if not (not self._falling and arg_4_6 == "falling") then
		ScriptUnit.extension(arg_4_1, "whereabouts_system"):set_no_landing()
	end

	self._lunge_data = nil
	self._hit = nil

	self._first_person_extension:enable_rig_movement()
end

EnemyCharacterStateLunging.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local _csm = self._csm
	local _unit = self._unit
	local _first_person_unit = self._first_person_unit
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(_unit)
	local _input_extension = self._input_extension
	local _status_extension = self._status_extension
	local extension = ScriptUnit.extension(_unit, "whereabouts_system")
	local _first_person_extension = self._first_person_extension
	local damage_start_time = self.damage_start_time
	local flag = false

	if not CharacterStateHelper.is_colliding_down(_unit) then
		if not self._falling then
			self._falling = false

			extension:set_landed()
		end

		extension:set_is_onground()
	elseif not self._falling then
		self._falling = true

		extension:set_fell(self.name)
	end

	local _lunge_data = self._lunge_data
	local lunge_events = _lunge_data.lunge_events

	if not lunge_events then
		local var_5_12 = lunge_events[1]
		local _start_time = self._start_time

		while not var_5_12 do
			if var_5_12.t < arg_5_5 - _start_time then
				var_5_12.event_function(self)
				table.remove(lunge_events, 1)

				var_5_12 = lunge_events[1]
			else
				break
			end
		end
	end

	if not CharacterStateHelper.do_common_state_transitions(_status_extension, _csm) then
		return
	end

	if not CharacterStateHelper.is_using_transport(_status_extension) then
		_csm:change_state("using_transport")

		return
	end

	if not CharacterStateHelper.is_overcharge_exploding(_status_extension) then
		_csm:change_state("overcharge_exploding")

		return
	end

	if not CharacterStateHelper.is_pushed(_status_extension) then
		_status_extension:set_pushed(false)

		local pushed = get_movement_settings_table.stun_settings.pushed

		pushed.hit_react_type = _status_extension:hit_react_type() .. "_push"

		_csm:change_state("stunned", pushed)

		return
	end

	if not CharacterStateHelper.is_block_broken(_status_extension) then
		_status_extension:set_block_broken(false)

		local parry_broken = get_movement_settings_table.stun_settings.parry_broken

		parry_broken.hit_react_type = "medium_push"

		_csm:change_state("stunned", parry_broken)

		return
	end

	if not flag then
		local damage = _lunge_data.damage

		if not (not damage and not (damage_start_time <= arg_5_5)) then
			flag = self:_update_damage(_unit, arg_5_3, arg_5_5, damage)
		end

		if not Managers.input:get_service("Player"):get("action_two", true) then
			local var_5_17 = POSITION_LOOKUP[_unit]
			local forward = Quaternion.forward(_first_person_extension:current_rotation())

			self:_do_blast(var_5_17, forward)

			flag = true
		end

		if not (self:_update_movement(_unit, arg_5_3, arg_5_5, _lunge_data) or flag) then
			local var_5_19 = POSITION_LOOKUP[_unit]
			local forward_2 = Quaternion.forward(_first_person_extension:current_rotation())

			self:_do_blast(var_5_19, forward_2)

			flag = true
		end
	end

	if not flag then
		if self._csm.state_next or not self._falling then
			_csm:change_state("falling", self._temp_params)

			self._temp_params.hit = false

			_first_person_extension:change_state("falling")

			return
		else
			_csm:change_state("walking", self._temp_params)

			self._temp_params.hit = false

			_first_person_extension:change_state("walking")

			return
		end
	end

	CharacterStateHelper.look(_input_extension, self._player.viewport_name, _first_person_extension, _status_extension, self._inventory_extension, 0.5)
end

EnemyCharacterStateLunging._update_movement = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	if not self._falling then
		return self:_move_in_air(arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	end

	return self:_move_on_ground(arg_6_1, arg_6_2, arg_6_3, arg_6_4)
end

EnemyCharacterStateLunging._move_on_ground = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local _locomotion_extension = self._locomotion_extension
	local _first_person_extension = self._first_person_extension
	local duration = arg_7_4.duration
	local num = arg_7_3 - self._start_time
	local var_7_4

	if not arg_7_4.allow_rotation then
		local forward = Quaternion.forward(_first_person_extension:current_rotation())

		var_7_4 = Vector3.normalize(Vector3.flat(forward))
	else
		var_7_4 = self._direction:unbox()
	end

	local speed_function = arg_7_4.speed_function
	local var_7_7

	if not speed_function then
		var_7_7 = speed_function(num, duration)
	else
		local initial_speed = arg_7_4.initial_speed

		var_7_7 = math.lerp(arg_7_4.initial_speed, arg_7_4.falloff_to_speed, math.min(num / duration, 1))
	end

	local num_2 = 1

	if num_2 < var_7_7 then
		_locomotion_extension:set_wanted_velocity(var_7_4 * num_2)
		_locomotion_extension:set_script_movement_time_scale(var_7_7 / num_2)
	else
		_locomotion_extension:set_wanted_velocity(var_7_4 * var_7_7)
	end

	return num < duration
end

EnemyCharacterStateLunging._move_in_air = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	local _locomotion_extension = self._locomotion_extension
	local _first_person_extension = self._first_person_extension
	local duration = arg_8_4.duration
	local num = arg_8_3 - self._start_time
	local var_8_4

	if not arg_8_4.allow_rotation then
		local forward = Quaternion.forward(_first_person_extension:current_rotation())

		var_8_4 = Vector3.normalize(Vector3.flat(forward))
	else
		var_8_4 = self._direction:unbox()
	end

	local speed_function = arg_8_4.speed_function
	local var_8_7

	if not speed_function then
		var_8_7 = speed_function(num, duration)
	else
		local initial_speed = arg_8_4.initial_speed

		var_8_7 = math.lerp(arg_8_4.initial_speed, arg_8_4.falloff_to_speed, math.min(num / duration, 1))
	end

	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_8_1)
	local num_2 = Vector3.flat(_locomotion_extension:current_velocity()) + var_8_4 * var_8_7
	local length = Vector3.length(num_2)
	local normalize = Vector3.normalize(num_2)

	_locomotion_extension:set_wanted_velocity(normalize * var_8_7)

	return num < duration
end

EnemyCharacterStateLunging._parse_attack_data = function (self, arg_9_1)
	-- function 9
	local num = self._career_extension:get_career_power_level() * arg_9_1.power_level_multiplier
	local damage_profile = arg_9_1.damage_profile

	damage_profile = damage_profile or "default"

	local var_9_2 = NetworkLookup.damage_profiles[damage_profile]
	local hit_zone_hit_name = arg_9_1.hit_zone_hit_name
	local var_9_4 = NetworkLookup.hit_zones[hit_zone_hit_name]

	return var_9_2, num, var_9_4, arg_9_1.ignore_shield, arg_9_1.allow_backstab
end

EnemyCharacterStateLunging._calculate_hit_mass = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	if not arg_10_4 and not HEALTH_ALIVE[arg_10_3] then
		local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
		local var_10_1

		if not arg_10_1 then
			if not arg_10_4.hit_mass_counts_block then
				var_10_1 = arg_10_4.hit_mass_counts_block[get_difficulty_rank]

				if not var_10_1 then
					-- Nothing
				end

				var_10_1 = arg_10_4.hit_mass_counts_block[2]

				if not var_10_1 then
					-- Nothing
				end
			end

			var_10_1 = arg_10_4.hit_mass_count_block

			if not var_10_1 then
				-- Nothing
			end
		end

		if not arg_10_4.hit_mass_counts then
			var_10_1 = arg_10_4.hit_mass_counts[get_difficulty_rank]

			if not var_10_1 then
				-- Nothing
			end

			var_10_1 = arg_10_4.hit_mass_counts[2]

			if not var_10_1 then
				-- Nothing
			end
		end

		var_10_1 = arg_10_4.hit_mass_count
		var_10_1 = var_10_1 or 1

		::label_10_0::

		local hit_mass_count = arg_10_2.hit_mass_count

		if not hit_mass_count and not hit_mass_count[arg_10_4.name] then
			var_10_1 = var_10_1 * (arg_10_2.hit_mass_count[arg_10_4.name] or 1)
		end

		self._amount_of_mass_hit = self._amount_of_mass_hit + var_10_1
	else
		arg_10_1 = false
	end

	return arg_10_1
end

EnemyCharacterStateLunging._update_damage = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	local depth_padding = arg_11_4.depth_padding
	local num = 0.5 * arg_11_4.width
	local num_2 = 0.5 * arg_11_4.height
	local var_11_3 = POSITION_LOOKUP[arg_11_1]
	local unbox = self._last_position:unbox()
	local num_3 = var_11_3 - unbox
	local num_4 = Vector3.length(num_3) * 0.5 + depth_padding
	local look = Quaternion.look(num_3, Vector3.up())
	local _first_person_extension = self._first_person_extension
	local forward = Quaternion.forward(_first_person_extension:current_rotation())
	local num_5 = (var_11_3 + unbox) * 0.5 + Vector3(0, 0, num_2)
	local offset_forward = arg_11_4.offset_forward

	offset_forward = offset_forward or 0

	local num_6 = num_5 + offset_forward * forward
	local var_11_13 = Vector3(num, num_4, num_2)
	local collision_filter = arg_11_4.collision_filter
	local immediate_overlap, var_11_16 = PhysicsWorld.immediate_overlap(self._physics_world, "shape", "oobb", "position", num_6, "rotation", look, "size", var_11_13, "collision_filter", collision_filter)
	local _hit_units = self._hit_units
	local _buff_extension = self._buff_extension
	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(arg_11_1)
	local normalize = Vector3.normalize(num_3)
	local system = Managers.state.entity:system("weapon_system")

	for i = 1, var_11_16 do
		local var_11_23 = immediate_overlap[i]
		local unit = Actor.unit(var_11_23)

		if not _hit_units[unit] then
			_hit_units[unit] = true

			local unit_game_object_id_2 = network:unit_game_object_id(unit)
			local var_11_26 = POSITION_LOOKUP[unit]
			local flag = false
			local num_7 = 1
			local get_data = Unit.get_data(unit, "breed")
			local _parse_attack_data, var_11_31, var_11_32, var_11_33, var_11_34 = self:_parse_attack_data(arg_11_4)

			if not get_data and not HEALTH_ALIVE[unit] then
				flag = not not var_11_33 or AiUtils.attack_is_shield_blocked(unit, arg_11_1)

				if not var_11_34 then
					local normalize_2 = Vector3.normalize(var_11_26 - var_11_3)
					local forward_2 = Quaternion.forward(Unit.local_rotation(unit, 0))

					if not (Vector3.dot(forward_2, normalize_2) >= 0.55) then
						local flag_2 = false
						local apply_buffs_to_value, var_11_39 = _buff_extension:apply_buffs_to_value(num_7, "backstab_multiplier")
					end
				end

				flag = self:_calculate_hit_mass(flag, arg_11_4, unit, get_data)
			else
				flag = false
			end

			if not get_data and not HEALTH_ALIVE[unit] then
				local var_11_40

				if not arg_11_4.stagger_angles then
					local normalize_3 = Vector3.normalize(var_11_26 - var_11_3)
					local cross = Vector3.cross(Vector3.flat(normalize_3), Vector3.flat(forward))
					local random = Math.random(arg_11_4.stagger_angles.min, arg_11_4.stagger_angles.max)
					local flag_3

					flag_3 = not (cross.z < 0) or not -1 or 1

					local num_8 = random * flag_3
					local var_11_46 = normalize

					var_11_46.x = math.cos(num_8) * normalize.x - math.sin(num_8) * normalize.y
					var_11_46.y = math.sin(num_8) * normalize.x + math.cos(num_8) * normalize.y
					var_11_40 = Vector3.normalize(var_11_46)
				else
					var_11_40 = normalize
				end

				local str = "career_ability"
				local var_11_48 = NetworkLookup.damage_sources[str]
				local var_11_49
				local flag_4 = false
				local num_9 = 0
				local flag_5 = false
				local flag_6 = true
				local flag_7 = true

				system:send_rpc_attack_hit(var_11_48, unit_game_object_id, unit_game_object_id_2, var_11_32, var_11_40, _parse_attack_data, "power_level", var_11_31, "hit_target_index", var_11_49, "blocking", flag, "shield_break_procced", flag_4, "boost_curve_multiplier", num_9, "is_critical_strike", flag_5, "can_damage", flag_6, "can_stagger", flag_7)

				self._num_impacts = self._num_impacts + 1

				local lunge_events = self._lunge_data.lunge_events

				if not lunge_events then
					local impact = lunge_events.impact

					if not impact then
						impact(self)
					end
				end

				if not self._lunge_data.first_person_hit_animation_event then
					CharacterStateHelper.play_animation_event_first_person(_first_person_extension, self._lunge_data.first_person_hit_animation_event)
				end

				local flag_8 = self._amount_of_mass_hit >= self.max_targets or get_data.armor_category == 2 or get_data.armor_category == 3

				if not HEALTH_ALIVE[unit] and (arg_11_4.interrupt_on_first_hit or not flag_8 or not arg_11_4.interrupt_on_max_hit_mass) then
					self:_do_blast(var_11_3, forward)

					return true
				end
			end
		end
	end

	self._last_position:store(var_11_3)

	return false
end

local tbl = {}

EnemyCharacterStateLunging._do_blast = function (self, arg_12_1, arg_12_2)
	-- function 12
	self._hit = true

	local damage = self._lunge_data.damage
	local flag = not damage and damage.on_interrupt_blast

	if not flag then
		local _physics_world = self._physics_world
		local collision_filter = flag.collision_filter
		local network = Managers.state.network
		local system = Managers.state.entity:system("weapon_system")
		local _unit = self._unit
		local unit_game_object_id = network:unit_game_object_id(_unit)
		local radius = flag.radius
		local num = arg_12_1 + arg_12_2 * radius
		local immediate_overlap, var_12_11 = PhysicsWorld.immediate_overlap(_physics_world, "shape", "sphere", "position", num, "size", radius, "collision_filter", collision_filter)

		table.clear(tbl)

		for i = 1, var_12_11 do
			local var_12_12 = immediate_overlap[i]
			local unit = Actor.unit(var_12_12)

			if not tbl[unit] then
				tbl[unit] = true

				if not Unit.get_data(unit, "breed") then
					local _parse_attack_data, var_12_15, var_12_16, var_12_17, var_12_18 = self:_parse_attack_data(flag)
					local unit_game_object_id_2 = network:unit_game_object_id(unit)
					local str = "career_ability"
					local var_12_21 = NetworkLookup.damage_sources[str]
					local normalize = Vector3.normalize(num - POSITION_LOOKUP[unit])
					local num_2 = 0
					local var_12_24
					local flag_2 = not not var_12_17 or AiUtils.attack_is_shield_blocked(unit, _unit)
					local flag_3 = false
					local flag_4 = false
					local flag_5 = true
					local flag_6 = true

					system:send_rpc_attack_hit(var_12_21, unit_game_object_id, unit_game_object_id_2, var_12_16, normalize, _parse_attack_data, "power_level", var_12_15, "hit_target_index", var_12_24, "blocking", flag_2, "shield_break_procced", flag_3, "boost_curve_multiplier", num_2, "is_critical_strike", flag_4, "can_damage", flag_5, "can_stagger", flag_6)
				end
			end
		end
	end
end
