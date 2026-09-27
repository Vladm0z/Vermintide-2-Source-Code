-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_lunging.lua

local POSITION_LOOKUP = POSITION_LOOKUP

PlayerCharacterStateLunging = class(PlayerCharacterStateLunging, PlayerCharacterState)

PlayerCharacterStateLunging.init = function (self, arg_1_1)
	-- function 1
	PlayerCharacterState.init(self, arg_1_1, "lunging")

	self._direction = Vector3Box()
	self._last_position = Vector3Box()
end

PlayerCharacterStateLunging._on_enter_animation = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	if not arg_2_3 then
		CharacterStateHelper.play_animation_event_with_variable_float(arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	else
		CharacterStateHelper.play_animation_event(arg_2_1, arg_2_2)
	end

	local first_person_extension = self.first_person_extension

	CharacterStateHelper.play_animation_event_first_person(first_person_extension, arg_2_5 or arg_2_2)
end

PlayerCharacterStateLunging.on_enter = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	-- function 3
	table.clear(self.temp_params)

	local input_extension = self.input_extension
	local first_person_extension = self.first_person_extension
	local status_extension = self.status_extension
	local do_lunge = self.status_extension.do_lunge

	self._lunge_data = do_lunge
	self.status_extension.do_lunge = false
	self.career_extension = ScriptUnit.extension(arg_3_1, "career_system")
	self._first_person_unit = first_person_extension:get_first_person_unit()

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

	local ledge_falloff_immunity = do_lunge.ledge_falloff_immunity

	ledge_falloff_immunity = not ledge_falloff_immunity and arg_3_5 + do_lunge.ledge_falloff_immunity
	self.ledge_falloff_immunity_time = ledge_falloff_immunity

	local forward = Quaternion.forward(self.first_person_extension:current_rotation())

	Vector3.set_z(forward, 0)

	local normalize = Vector3.normalize(forward)
	local look = Quaternion.look(normalize, Vector3.up())

	Unit.set_local_rotation(arg_3_1, 0, look)
	CharacterStateHelper.look(input_extension, self.player.viewport_name, first_person_extension, status_extension, self.inventory_extension)

	if not do_lunge.animation_event then
		self:_on_enter_animation(arg_3_1, do_lunge.animation_event, do_lunge.animation_variable_name, do_lunge.animation_variable_value, do_lunge.first_person_animation_event)
	end

	self._num_impacts = 0
	self._amount_of_mass_hit = 0
	self._hit_units = {}
	self._start_time = arg_3_5

	self._last_position:store(POSITION_LOOKUP[arg_3_1])
	self._direction:store(normalize)

	self._falling = false
	self._stop = false

	local lunge_events = do_lunge.lunge_events

	if not lunge_events then
		local start = lunge_events.start

		if not start then
			start(self)
		end
	end

	first_person_extension:disable_rig_movement()

	local damage = do_lunge.damage

	if not damage then
		local damage_profile = damage.damage_profile

		damage_profile = damage_profile or "default"

		local _parse_attack_data, var_3_14, var_3_15, var_3_16 = self:_parse_attack_data(damage)

		self.damage_profile_id = NetworkLookup.damage_profiles[damage_profile]

		local var_3_17 = DamageProfileTemplates[damage_profile]

		self.damage_profile = var_3_17

		local get_difficulty = Managers.state.difficulty:get_difficulty()
		local scale_power_levels = ActionUtils.scale_power_levels(var_3_14, "cleave", arg_3_1, get_difficulty)
		local get_max_targets, var_3_21 = ActionUtils.get_max_targets(var_3_17, scale_power_levels)

		self.max_targets_attack = get_max_targets
		self.max_targets_impact = var_3_21
		self.max_targets = not (var_3_21 < get_max_targets) or not get_max_targets or var_3_21
	end

	if not do_lunge.dodge and not Managers.state.network:game() then
		status_extension:set_is_dodging(true)

		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_3_1)

		network.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, true, unit_game_object_id, 0)
	end

	if not do_lunge.noclip then
		status_extension:set_noclip(true, "lunging")
	end
end

PlayerCharacterStateLunging.on_exit = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	-- function 4
	local _lunge_data = self._lunge_data
	local first_person_animation_end_event = _lunge_data.first_person_animation_end_event

	if not first_person_animation_end_event then
		CharacterStateHelper.play_animation_event_first_person(self.first_person_extension, first_person_animation_end_event)
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
		self.status_extension:set_is_dodging(false)

		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_4_1)

		network.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, false, unit_game_object_id, 0)
	end

	if not _lunge_data.noclip then
		self.status_extension:set_noclip(false, "lunging")
	end

	if not (not self._falling and arg_4_6 == "falling") then
		ScriptUnit.extension(arg_4_1, "whereabouts_system"):set_no_landing()
	end

	self._lunge_data = nil
	self._hit = nil
	self._stop = true

	self.first_person_extension:enable_rig_movement()
end

PlayerCharacterStateLunging.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local csm = self.csm
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_5_1)
	local input_extension = self.input_extension
	local status_extension = self.status_extension
	local extension = ScriptUnit.extension(arg_5_1, "whereabouts_system")
	local first_person_extension = self.first_person_extension
	local damage_start_time = self.damage_start_time

	if not CharacterStateHelper.is_colliding_down(arg_5_1) then
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
		local var_5_9 = lunge_events[1]
		local _start_time = self._start_time

		while not var_5_9 do
			if var_5_9.t < arg_5_5 - _start_time then
				var_5_9.event_function(self)
				table.remove(lunge_events, 1)

				var_5_9 = lunge_events[1]
			else
				break
			end
		end
	end

	if not CharacterStateHelper.do_common_state_transitions(status_extension, csm) then
		return
	end

	if not CharacterStateHelper.is_using_transport(status_extension) then
		csm:change_state("using_transport")

		return
	end

	local world = self.world

	if not self.ledge_falloff_immunity_time and not (arg_5_5 > self.ledge_falloff_immunity_time) or not CharacterStateHelper.is_ledge_hanging(world, arg_5_1, self.temp_params) then
		self._stop = true

		csm:change_state("ledge_hanging", self.temp_params)

		return
	end

	if not CharacterStateHelper.is_overcharge_exploding(status_extension) then
		csm:change_state("overcharge_exploding")

		return
	end

	if not CharacterStateHelper.is_pushed(status_extension) then
		status_extension:set_pushed(false)
	end

	if not CharacterStateHelper.is_block_broken(status_extension) then
		status_extension:set_block_broken(false)
	end

	if not self._stop then
		local damage = _lunge_data.damage

		if not (not damage and not (damage_start_time <= arg_5_5)) then
			self._stop = self:_update_damage(arg_5_1, arg_5_3, arg_5_5, damage)
		end

		local get_service = Managers.input:get_service("Player")

		if not get_service and not get_service:get("action_two", true) then
			local var_5_14 = POSITION_LOOKUP[arg_5_1]
			local forward = Quaternion.forward(first_person_extension:current_rotation())

			self:_do_blast(var_5_14, forward)

			self._stop = true
		end

		local _update_movement = self:_update_movement(arg_5_1, arg_5_3, arg_5_5, _lunge_data)

		if _update_movement == "ledge_hang" then
			self._stop = true

			csm:change_state("ledge_hanging", self.temp_params)

			return
		end

		if not (_update_movement ~= "stop" or self._stop) then
			local var_5_17 = POSITION_LOOKUP[arg_5_1]
			local forward_2 = Quaternion.forward(first_person_extension:current_rotation())

			self:_do_blast(var_5_17, forward_2)

			self._stop = true
		end
	end

	if not self._stop then
		if self.csm.state_next or not self._falling then
			csm:change_state("falling", self.temp_params)

			self.temp_params.hit = false

			first_person_extension:change_state("falling")

			return
		else
			csm:change_state("walking", self.temp_params)

			self.temp_params.hit = false

			first_person_extension:change_state("walking")

			return
		end
	end

	CharacterStateHelper.look(input_extension, self.player.viewport_name, first_person_extension, status_extension, self.inventory_extension, 0.5)
	CharacterStateHelper.update_weapon_actions(arg_5_5, arg_5_1, input_extension, self.inventory_extension, self.health_extension)
	self._last_position:store(POSITION_LOOKUP[arg_5_1])
end

PlayerCharacterStateLunging._update_movement = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local var_6_0

	if not self._falling then
		var_6_0 = self:_move_in_air(arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	else
		var_6_0 = self:_move_on_ground(arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	end

	return var_6_0
end

PlayerCharacterStateLunging._check_ledge_hang = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	-- function 7
	local var_7_0 = POSITION_LOOKUP[arg_7_1]
	local num = var_7_0 + arg_7_4 * arg_7_5 * arg_7_2
	local length = Vector3.length(num - var_7_0)
	local num_2 = 0.1
	local num_3 = length / num_2
	local world = self.world

	self.temp_params.z_offset = arg_7_6
	self.temp_params.collision_filter = "filter_lunge_ledge_collision"
	self.temp_params.radius = num_2 * 1.5

	for i = 1, num_3 do
		local num_4 = var_7_0 + arg_7_4 * (num_2 * i)

		self.temp_params.ray_position = num_4

		if not CharacterStateHelper.will_be_ledge_hanging(world, arg_7_1, self.temp_params) then
			return true
		end
	end

	return false
end

PlayerCharacterStateLunging._move_on_ground = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	local locomotion_extension = self.locomotion_extension
	local first_person_extension = self.first_person_extension
	local duration = arg_8_4.duration
	local num = arg_8_3 - self._start_time
	local var_8_4

	if not arg_8_4.allow_rotation then
		local forward = Quaternion.forward(first_person_extension:current_rotation())

		var_8_4 = Vector3.normalize(Vector3.flat(forward))
	else
		var_8_4 = self._direction:unbox()
	end

	local speed_function = arg_8_4.speed_function
	local var_8_7

	if not speed_function then
		var_8_7 = speed_function(num, duration)
	else
		var_8_7 = math.lerp(arg_8_4.initial_speed, arg_8_4.falloff_to_speed, math.min(num / duration, 1))
	end

	local num_2 = 1
	local flag = num_2 < var_8_7
	local flag_2 = not flag and num_2 and var_8_7

	if not self:_check_ledge_hang(arg_8_1, arg_8_2, arg_8_3, var_8_4, var_8_7, -1.6) then
		return "ledge_hang"
	end

	locomotion_extension:set_wanted_velocity(var_8_4 * flag_2)

	if not flag then
		locomotion_extension:set_script_movement_time_scale(var_8_7 / num_2)
	end

	local flag_3

	flag_3 = not (num < duration) and "continue" and "stop"

	return flag_3
end

PlayerCharacterStateLunging._move_in_air = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	local locomotion_extension = self.locomotion_extension
	local first_person_extension = self.first_person_extension
	local duration = arg_9_4.duration
	local num = arg_9_3 - self._start_time
	local var_9_4

	if not arg_9_4.allow_rotation then
		local forward = Quaternion.forward(first_person_extension:current_rotation())

		var_9_4 = Vector3.normalize(Vector3.flat(forward))
	else
		var_9_4 = self._direction:unbox()
	end

	local speed_function = arg_9_4.speed_function
	local var_9_7

	if not speed_function then
		var_9_7 = speed_function(num, duration)
	else
		var_9_7 = math.lerp(arg_9_4.initial_speed, arg_9_4.falloff_to_speed, math.min(num / duration, 1))
	end

	if not self:_check_ledge_hang(arg_9_1, arg_9_2, arg_9_3, var_9_4, var_9_7, -1.6) then
		return "ledge_hang"
	end

	local num_2 = Vector3.flat(locomotion_extension:current_velocity()) + var_9_4 * var_9_7
	local normalize = Vector3.normalize(num_2)

	locomotion_extension:set_wanted_velocity(normalize * var_9_7)

	local flag

	flag = not (num < duration) and "continue" and "stop"

	return flag
end

PlayerCharacterStateLunging._parse_attack_data = function (self, arg_10_1)
	-- function 10
	local num = self.career_extension:get_career_power_level() * arg_10_1.power_level_multiplier
	local clamp = math.clamp(num, MIN_POWER_LEVEL, MAX_POWER_LEVEL)
	local damage_profile = arg_10_1.damage_profile

	damage_profile = damage_profile or "default"

	local var_10_3 = NetworkLookup.damage_profiles[damage_profile]
	local hit_zone_hit_name = arg_10_1.hit_zone_hit_name
	local var_10_5 = NetworkLookup.hit_zones[hit_zone_hit_name]

	return var_10_3, clamp, var_10_5, arg_10_1.ignore_shield
end

PlayerCharacterStateLunging._calculate_hit_mass = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	-- function 11
	local is_enemy = Managers.state.side:is_enemy(arg_11_5, arg_11_3)

	if not arg_11_4 and not is_enemy and not HEALTH_ALIVE[arg_11_3] then
		local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
		local var_11_2

		if not arg_11_1 then
			if not arg_11_4.hit_mass_counts_block then
				var_11_2 = arg_11_4.hit_mass_counts_block[get_difficulty_rank]

				if not var_11_2 then
					-- Nothing
				end

				var_11_2 = arg_11_4.hit_mass_counts_block[2]

				if not var_11_2 then
					-- Nothing
				end
			end

			var_11_2 = arg_11_4.hit_mass_count_block

			if not var_11_2 then
				-- Nothing
			end
		end

		if not arg_11_4.hit_mass_counts then
			var_11_2 = arg_11_4.hit_mass_counts[get_difficulty_rank]

			if not var_11_2 then
				-- Nothing
			end

			var_11_2 = arg_11_4.hit_mass_counts[2]

			if not var_11_2 then
				-- Nothing
			end
		end

		var_11_2 = arg_11_4.hit_mass_count
		var_11_2 = var_11_2 or 1

		::label_11_0::

		local hit_mass_count = arg_11_2.hit_mass_count

		if not hit_mass_count and not hit_mass_count[arg_11_4.name] then
			var_11_2 = var_11_2 * (arg_11_2.hit_mass_count[arg_11_4.name] or 1)
		end

		self._amount_of_mass_hit = self._amount_of_mass_hit + var_11_2
	else
		arg_11_1 = false
	end

	return arg_11_1
end

PlayerCharacterStateLunging._update_damage = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	-- function 12
	local depth_padding = arg_12_4.depth_padding
	local num = 0.5 * arg_12_4.width
	local num_2 = 0.5 * arg_12_4.height
	local var_12_3 = POSITION_LOOKUP[arg_12_1]
	local unbox = self._last_position:unbox()
	local num_3 = var_12_3 - unbox
	local num_4 = Vector3.length(num_3) * 0.5 + depth_padding
	local look = Quaternion.look(num_3, Vector3.up())
	local first_person_extension = self.first_person_extension
	local forward = Quaternion.forward(first_person_extension:current_rotation())
	local flat = Vector3.flat(forward)
	local num_5 = (var_12_3 + unbox) * 0.5 + Vector3(0, 0, num_2)
	local offset_forward = arg_12_4.offset_forward

	offset_forward = offset_forward or 0

	local num_6 = num_5 + offset_forward * flat
	local var_12_14 = Vector3(num, num_4, num_2)
	local collision_filter = arg_12_4.collision_filter
	local immediate_overlap, var_12_17 = PhysicsWorld.immediate_overlap(self.physics_world, "shape", "oobb", "position", num_6, "rotation", look, "size", var_12_14, "collision_filter", collision_filter)
	local _hit_units = self._hit_units
	local buff_extension = self.buff_extension
	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(arg_12_1)
	local normalize = Vector3.normalize(num_3)
	local system = Managers.state.entity:system("weapon_system")
	local num_7 = 0
	local side = Managers.state.side

	for i = 1, var_12_17 do
		repeat
			local var_12_26 = immediate_overlap[i]
			local unit = Actor.unit(var_12_26)

			if not _hit_units[unit] then
				_hit_units[unit] = true

				if not HEALTH_ALIVE[unit] then
					break
				end

				if not side:is_enemy(arg_12_1, unit) then
					break
				end

				local get_data = Unit.get_data(unit, "breed")

				if not get_data then
					break
				end

				num_7 = num_7 + 1

				local unit_game_object_id_2 = network:unit_game_object_id(unit)
				local var_12_30 = POSITION_LOOKUP[unit]
				local _parse_attack_data, var_12_32, var_12_33, var_12_34 = self:_parse_attack_data(arg_12_4)
				local flag = not not var_12_34 or AiUtils.attack_is_shield_blocked(unit, arg_12_1)
				local _calculate_hit_mass = self:_calculate_hit_mass(flag, arg_12_4, unit, get_data, arg_12_1)
				local var_12_37

				if not arg_12_4.stagger_angles then
					local normalize_2 = Vector3.normalize(var_12_30 - var_12_3)
					local cross = Vector3.cross(Vector3.flat(normalize_2), Vector3.flat(forward))
					local random = Math.random(arg_12_4.stagger_angles.min, arg_12_4.stagger_angles.max)
					local flag_2

					flag_2 = not (cross.z < 0) or not -1 or 1

					local num_8 = random * flag_2
					local var_12_43 = normalize

					var_12_43.x = math.cos(num_8) * normalize.x - math.sin(num_8) * normalize.y
					var_12_43.y = math.sin(num_8) * normalize.x + math.cos(num_8) * normalize.y
					var_12_37 = Vector3.normalize(var_12_43)
				else
					var_12_37 = normalize
				end

				local str = "charge_ability_hit"
				local var_12_45 = NetworkLookup.damage_sources[str]
				local var_12_46
				local flag_3 = false
				local num_9 = 0
				local flag_4 = false
				local flag_5 = true
				local flag_6 = true

				system:send_rpc_attack_hit(var_12_45, unit_game_object_id, unit_game_object_id_2, var_12_33, var_12_30, var_12_37, _parse_attack_data, "power_level", var_12_32, "hit_target_index", var_12_46, "blocking", _calculate_hit_mass, "shield_break_procced", flag_3, "boost_curve_multiplier", num_9, "is_critical_strike", flag_4, "can_damage", flag_5, "can_stagger", flag_6)

				self._num_impacts = self._num_impacts + 1

				local lunge_events = self._lunge_data.lunge_events

				if not lunge_events then
					local impact = lunge_events.impact

					if not impact then
						impact(self)
					end
				end

				if not self._lunge_data.first_person_hit_animation_event then
					CharacterStateHelper.play_animation_event_first_person(first_person_extension, self._lunge_data.first_person_hit_animation_event)
				end

				local flag_7 = self._amount_of_mass_hit >= self.max_targets or get_data.armor_category == 2 or get_data.armor_category == 3

				if arg_12_4.interrupt_on_first_hit or not flag_7 or not arg_12_4.interrupt_on_max_hit_mass then
					self:_do_blast(var_12_3, forward)

					return true
				end
			end
		until true
	end

	return false
end

local tbl = {}

PlayerCharacterStateLunging._do_blast = function (self, arg_13_1, arg_13_2)
	-- function 13
	self._hit = true

	local damage = self._lunge_data.damage
	local flag = not damage and damage.on_interrupt_blast

	if not flag then
		local physics_world = self.physics_world
		local collision_filter = flag.collision_filter
		local network = Managers.state.network
		local system = Managers.state.entity:system("weapon_system")
		local unit = self.unit
		local unit_game_object_id = network:unit_game_object_id(unit)
		local radius = flag.radius
		local num = arg_13_1 + arg_13_2 * radius
		local immediate_overlap, var_13_11 = PhysicsWorld.immediate_overlap(physics_world, "shape", "sphere", "position", num, "size", radius, "collision_filter", collision_filter)
		local num_2 = 0
		local side = Managers.state.side

		table.clear(tbl)

		for i = 1, var_13_11 do
			repeat
				local var_13_14 = immediate_overlap[i]
				local unit_2 = Actor.unit(var_13_14)

				if not tbl[unit_2] then
					break
				end

				tbl[unit_2] = true

				if not Unit.get_data(unit_2, "breed") then
					break
				end

				if not side:is_enemy(unit, unit_2) then
					break
				end

				local _parse_attack_data, var_13_17, var_13_18, var_13_19 = self:_parse_attack_data(flag)
				local unit_game_object_id_2 = network:unit_game_object_id(unit_2)

				num_2 = num_2 + 1

				local str = "charge_ability_hit_blast"
				local var_13_22 = NetworkLookup.damage_sources[str]
				local var_13_23 = POSITION_LOOKUP[unit_2]
				local normalize = Vector3.normalize(num - var_13_23)
				local num_3 = 0
				local var_13_26
				local flag_2 = not not var_13_19 or AiUtils.attack_is_shield_blocked(unit_2, unit)
				local flag_3 = false
				local flag_4 = false
				local flag_5 = true
				local flag_6 = true

				system:send_rpc_attack_hit(var_13_22, unit_game_object_id, unit_game_object_id_2, var_13_18, var_13_23, normalize, _parse_attack_data, "power_level", var_13_17, "hit_target_index", var_13_26, "blocking", flag_2, "shield_break_procced", flag_3, "boost_curve_multiplier", num_3, "is_critical_strike", flag_4, "can_damage", flag_5, "can_stagger", flag_6)
			until true
		end
	end
end
