-- chunkname: @scripts/unit_extensions/weapons/projectiles/projectile_true_flight_locomotion_extension.lua

require("scripts/unit_extensions/weapons/projectiles/true_flight_utility")

ProjectileTrueFlightLocomotionExtension = class(ProjectileTrueFlightLocomotionExtension)

ProjectileTrueFlightLocomotionExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local world = arg_1_1.world
	local gravity_settings = arg_1_3.gravity_settings

	gravity_settings = gravity_settings or "default"

	local initial_position = arg_1_3.initial_position
	local true_flight_template_name = arg_1_3.true_flight_template_name

	assert(true_flight_template_name, "no true_flight_template")

	self.true_flight_template_name = true_flight_template_name

	local var_1_4 = TrueFlightTemplates[true_flight_template_name]

	self.true_flight_template = var_1_4

	local time = Managers.time:time("game")
	local fast_forward_time = arg_1_3.fast_forward_time

	fast_forward_time = fast_forward_time or 0
	self.t = time - fast_forward_time
	self.target_unit = arg_1_3.target_unit

	local initial_target_node = var_1_4.initial_target_node

	initial_target_node = initial_target_node or "c_head"
	self.target_node = initial_target_node
	self.unit = arg_1_2
	self.world = world
	self.gravity_settings = gravity_settings
	self.gravity = ProjectileGravitySettings[gravity_settings]
	self.velocity = Vector3Box()
	self.speed = arg_1_3.speed
	self.initial_position_boxed = Vector3Box(initial_position)

	local side_by_unit = Managers.state.side.side_by_unit
	local var_1_9 = side_by_unit[arg_1_2]

	var_1_9 = var_1_9 or side_by_unit[arg_1_3.owner_unit]
	self.side = var_1_9

	local enemy_broadphase_categories

	if not var_1_4.dont_target_friendly and not self.side then
		enemy_broadphase_categories = self.side.enemy_broadphase_categories

		if not enemy_broadphase_categories then
			-- Nothing
		end
	end

	enemy_broadphase_categories = nil

	::label_1_0::

	self.target_broadphase_categories = enemy_broadphase_categories
	self.trajectory_template_name = arg_1_3.trajectory_template_name

	assert(self.trajectory_template_name)

	self.raycast_timer = 0
	self.target_vector = arg_1_3.target_vector
	self.current_direction = Vector3Box(self.target_vector)
	self.current_rotation = QuaternionBox(Quaternion.look(self.target_vector))
	self.target_vector = Vector3.normalize(Vector3.flat(self.target_vector))
	self.target_vector_boxed = Vector3Box(self.target_vector)
	self.owner_unit = arg_1_3.owner_unit
	self.is_husk = not not arg_1_3.is_husk
	self.network_manager = Managers.state.network
	self.radians = math.degrees_to_radians(arg_1_3.angle)
	self.stopped = false
	self.moved = false
	self.spawn_time = time

	local life_time = arg_1_3.life_time

	life_time = life_time or math.huge
	self.death_time = life_time
	self.on_target_time = 0

	local height_offset = arg_1_3.height_offset

	height_offset = height_offset or 0
	self.height_offset = height_offset

	if not var_1_4.target_tracking_check_func then
		self._update_towards_target_func = self[var_1_4.target_tracking_check_func]
	else
		self._update_towards_target_func = self.update_towards_target
	end

	local var_1_13

	if not var_1_4.legitimate_target_func then
		var_1_13 = self[var_1_4.legitimate_target_func]

		if not var_1_13 then
			-- Nothing
		end
	end

	var_1_13 = self.legitimate_target

	::label_1_1::

	self._legitimate_target_func = var_1_13

	local var_1_14

	if not var_1_4.keep_target_on_miss_check_func then
		var_1_14 = self[var_1_4.keep_target_on_miss_check_func]

		if not var_1_14 then
			-- Nothing
		end
	end

	var_1_14 = self.legitimate_never

	::label_1_2::

	self._keep_target_on_miss_check_func = var_1_14

	local valid_target_dot = var_1_4.valid_target_dot

	valid_target_dot = valid_target_dot or 0.75
	self._valid_target_dot = valid_target_dot

	local retarget_broadphase_offset = var_1_4.retarget_broadphase_offset

	retarget_broadphase_offset = retarget_broadphase_offset or 10
	self._retarget_broadphase_offset = retarget_broadphase_offset
	self._dont_target_patrols = var_1_4.dont_target_patrols

	local lerp_modifier_func = var_1_4.lerp_modifier_func

	lerp_modifier_func = lerp_modifier_func or function (arg_2_0)
		-- function 2
		local flag

		flag = not (arg_2_0 < 5) or not 1 or 5 / arg_2_0

		return flag
	end
	self._lerp_modifier_func = lerp_modifier_func
	self.target_players = var_1_4.target_players

	if not var_1_4.find_target_func then
		self._find_target_func = self[var_1_4.find_target_func]
	else
		self._find_target_func = self.find_broadphase_target
	end

	if not arg_1_3.position_target then
		self.position_target = Vector3Box(arg_1_3.position_target)
	end

	if not var_1_4.init_func then
		local random_seed = math.random_seed()

		self._custom_data = {}

		var_1_4.init_func(arg_1_2, var_1_4, random_seed, self._custom_data)
	end

	self._current_position = Vector3Box(POSITION_LOOKUP[arg_1_2])

	Unit.set_local_position(arg_1_2, 0, initial_position)

	self.hit_units = {}
end

local function fn(arg_3_0, arg_3_1)
	-- function 3
	local var_3_0 = BLACKBOARDS[arg_3_0]
	local flag = not var_3_0 and var_3_0.breed
	local node

	if not Unit.has_node(arg_3_0, arg_3_1) then
		node = Unit.node(arg_3_0, arg_3_1)

		if not node then
			-- Nothing
		end
	end

	node = 0

	::label_3_0::

	if not flag and not flag.target_head_node then
		return Unit.world_position(arg_3_0, node)
	else
		return Unit.world_position(arg_3_0, node)
	end
end

local function fn_2(self)
	-- function 4
	local min = NetworkConstants.position.min
	local max = NetworkConstants.position.max

	for i = 1, 3 do
		local var_4_2 = self[i]

		if not (var_4_2 < min or not (max < var_4_2)) then
			print("[ProjectileTrueFlightLocomotionExtension] position is not valid, outside of NetworkConstants.position")

			return false
		end
	end

	return true
end

ProjectileTrueFlightLocomotionExtension._do_forced_impact = function (self, arg_5_1, arg_5_2)
	-- function 5
	ScriptUnit.extension(arg_5_1, "projectile_system"):force_impact(arg_5_1, Unit.local_position(arg_5_1, 0))

	local network_manager = self.network_manager
	local unit_game_object_id = network_manager:unit_game_object_id(arg_5_1)

	network_manager.network_transmit:send_rpc_clients("rpc_generic_impact_projectile_force_impact", unit_game_object_id, arg_5_2)
end

ProjectileTrueFlightLocomotionExtension.bounce = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local normalize = Vector3.normalize(Vector3.reflect(arg_6_2, arg_6_3))
	local num = arg_6_1 - arg_6_2 * 0.25 + arg_6_3 * 0.1
	local look = Quaternion.look(normalize)

	self.t = Managers.time:time("game")

	self.target_vector_boxed:store(normalize)
	self.initial_position_boxed:store(num)

	self.radians = math.degrees_to_radians(ActionUtils.pitch_from_rotation(look))

	self._current_position:store(num)
	self:_unit_set_position_rotation(self.unit, num, look)
end

ProjectileTrueFlightLocomotionExtension.update = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	self.dt = arg_7_5 - self.t
	self.t = arg_7_5
	self.moved = false

	if not self.stopped then
		return
	end

	if not self.is_husk then
		local game = Managers.state.network:game()
		local go_id = Managers.state.unit_storage:go_id(arg_7_1)

		if not game and not go_id then
			local game_object_field = GameSession.game_object_field(game, go_id, "position")
			local game_object_field_2 = GameSession.game_object_field(game, go_id, "rotation")

			self:_unit_set_position_rotation(arg_7_1, game_object_field, game_object_field_2)
		end

		return
	end

	self.on_target_time = self.on_target_time + arg_7_3

	local unbox = self._current_position:unbox()

	if self.on_target_time > self.death_time then
		self:_do_forced_impact(arg_7_1, unbox)
	end

	local var_7_5 = TrueFlightTemplates[self.true_flight_template_name]
	local target_unit = self.target_unit
	local _check_target_valid, var_7_8 = self:_check_target_valid(target_unit, unbox, var_7_5)
	local var_7_9

	if not _check_target_valid then
		local max_on_target_time = var_7_5.max_on_target_time

		max_on_target_time = max_on_target_time or 0.75

		local flag = max_on_target_time > self.on_target_time
		local update_seeking_target, var_7_13 = self:update_seeking_target(unbox, arg_7_3, arg_7_5, flag)

		var_7_9 = update_seeking_target
		self.target_unit = var_7_13
		_check_target_valid, var_7_8 = self:_check_target_valid(var_7_13, unbox, var_7_5)
	end

	local var_7_14

	if not var_7_8 then
		var_7_9, var_7_14 = self._update_towards_target_func(self, unbox, arg_7_5, arg_7_3)
	elseif not _check_target_valid then
		local update_seeking_target_2, var_7_16 = self:update_seeking_target(unbox, arg_7_3, arg_7_5, false)

		var_7_9 = update_seeking_target_2
	end

	if not fn_2(var_7_9) then
		self:stop()
		Managers.state.unit_spawner:mark_for_deletion(self.unit)

		return
	end

	local num = var_7_9 - unbox

	if Vector3.length(num) <= 0.001 then
		return
	end

	if not script_data.debug_projectiles then
		QuickDrawerStay:line(unbox, var_7_9, Color(255, 255, 255, 0))
	end

	local normalize = Vector3.normalize(num)
	local flag_2 = var_7_14 or Quaternion.look(normalize)

	self:_unit_set_position_rotation(arg_7_1, var_7_9, flag_2)

	local game_2 = Managers.state.network:game()
	local go_id_2 = Managers.state.unit_storage:go_id(arg_7_1)

	if not game_2 and not go_id_2 then
		GameSession.set_game_object_field(game_2, go_id_2, "position", var_7_9)
		GameSession.set_game_object_field(game_2, go_id_2, "rotation", flag_2)
	end

	self._current_position:store(var_7_9)
	self.velocity:store(num)
	self.current_direction:store(normalize)
	self.current_rotation:store(flag_2)

	self.t = arg_7_5

	self.target_vector_boxed:store(Vector3.normalize(Vector3.flat(normalize)))
	self.initial_position_boxed:store(var_7_9)

	self.radians = math.degrees_to_radians(ActionUtils.pitch_from_rotation(flag_2))
	self.moved = true
end

ProjectileTrueFlightLocomotionExtension._check_target_valid = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local flag = false
	local flag_2 = false

	if not self.position_target then
		flag = true
	elseif not (not HEALTH_ALIVE[arg_8_1] and self.hit_units[arg_8_1]) then
		if not (not self._dont_target_patrols and not AiUtils.is_part_of_patrol(arg_8_1) and AiUtils.is_aggroed(arg_8_1)) then
			return flag_2, flag
		end

		flag_2 = true

		if not self._legitimate_target_func(self, arg_8_1, arg_8_2) then
			flag = true
		elseif not arg_8_3.retarget_on_miss then
			flag_2 = self._keep_target_on_miss_check_func(self, arg_8_1, arg_8_2)
		end
	end

	return flag_2, flag
end

ProjectileTrueFlightLocomotionExtension.set_projectile_state = function (self, arg_9_1)
	-- function 9
	if arg_9_1 ~= self.projectile_state_id then
		local flag = not self.is_husk
		local unit = self.unit

		TrueFlightTemplates[self.true_flight_template_name].template_state_func(self, unit, arg_9_1, flag)

		if not flag then
			local network_manager = self.network_manager
			local unit_game_object_id = network_manager:unit_game_object_id(unit)

			network_manager.network_transmit:send_rpc_clients("rpc_set_projectile_state", unit_game_object_id, arg_9_1)
		end

		self.projectile_state_id = arg_9_1
	else
		print("WARNING: projectile trying to be put in the same state multiple times", self.unit, arg_9_1)
	end
end

ProjectileTrueFlightLocomotionExtension.update_towards_slow_bomb_target = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local target_unit = self.target_unit
	local unit = self.unit
	local unbox = self.current_direction:unbox()
	local var_10_3 = TrueFlightTemplates[self.true_flight_template_name]
	local speed_multiplier = var_10_3.speed_multiplier
	local num = Unit.world_position(target_unit, Unit.node(target_unit, "c_spine")) - arg_10_1
	local length = Vector3.length(num)
	local normalize = Vector3.normalize(num)
	local look = Quaternion.look(unbox)
	local look_2 = Quaternion.look(normalize)

	if not self._slow_bomb_triggered then
		local triggered_speed_mult = var_10_3.triggered_speed_mult

		return arg_10_1 + unbox * self.speed * speed_multiplier * triggered_speed_mult * arg_10_3
	elseif length < var_10_3.trigger_dist then
		self._slow_bomb_triggered = true

		Unit.flow_event(unit, "lua_projectile_triggered")

		local network_manager = self.network_manager
		local unit_game_object_id = network_manager:unit_game_object_id(unit)

		network_manager.network_transmit:send_rpc_clients("rpc_set_projectile_state", unit_game_object_id, 1)
	end

	local clamp = math.clamp
	local flag

	flag = not (length < 10) or not 1 or length / 10

	local var_10_15 = clamp(flag, 0, 3)
	local num_2 = self.speed * speed_multiplier * var_10_15
	local _lerp_modifier_func = self._lerp_modifier_func(length)
	local num_3 = _lerp_modifier_func * _lerp_modifier_func * (math.min(self.on_target_time, 0.25) / 0.25)
	local min = math.min(arg_10_3 * num_3 * 100, 0.75)
	local lerp = Quaternion.lerp(look, look_2, min)

	return arg_10_1 + Quaternion.forward(lerp) * num_2 * arg_10_3
end

ProjectileTrueFlightLocomotionExtension.update_towards_strike_missile_target = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local target_unit = self.target_unit
	local unbox = self.current_direction:unbox()
	local var_11_2 = TrueFlightTemplates[self.true_flight_template_name]
	local speed_multiplier = var_11_2.speed_multiplier
	local num = Unit.world_position(target_unit, Unit.node(target_unit, "c_spine")) - arg_11_1
	local length = Vector3.length(num)
	local normalize = Vector3.normalize(num)
	local unit = self.unit

	if not self._missile_triggered then
		if not self._missile_striking then
			local triggered_speed_mult = var_11_2.triggered_speed_mult

			return arg_11_1 + unbox * self.speed * speed_multiplier * triggered_speed_mult * arg_11_3
		else
			if arg_11_2 > self._missile_lingering then
				self._missile_striking = true

				if not var_11_2.create_bot_threat then
					local var_11_9 = HEALTH_ALIVE[self.owner_unit]

					var_11_9 = not var_11_9 and BLACKBOARDS[self.owner_unit]

					if not (not var_11_9 and var_11_9.created_missile_bot_threat) then
						var_11_9.missile_bot_threat_unit = target_unit
						var_11_9.created_missile_bot_threat = true
					end
				end

				Unit.flow_event(unit, "lua_projectile_striking")

				local network_manager = self.network_manager
				local unit_game_object_id = network_manager:unit_game_object_id(unit)

				network_manager.network_transmit:send_rpc_clients("rpc_set_projectile_state", unit_game_object_id, 2)
			end

			local num_2 = 0.1

			return arg_11_1 + unbox * self.speed * speed_multiplier * num_2 * arg_11_3
		end
	elseif not (Vector3.dot(unbox, normalize) > 0.999 or not (self.on_target_time > 2)) then
		self._missile_triggered = true
		self._missile_lingering = arg_11_2 + var_11_2.lingering_duration

		Unit.flow_event(unit, "lua_projectile_triggered")

		local network_manager_2 = self.network_manager
		local unit_game_object_id_2 = network_manager_2:unit_game_object_id(unit)

		network_manager_2.network_transmit:send_rpc_clients("rpc_set_projectile_state", unit_game_object_id_2, 1)
	end

	local look = Quaternion.look(unbox)
	local look_2 = Quaternion.look(normalize)

	self.speed = self.speed - 5 * arg_11_3

	local num_3 = self.speed * speed_multiplier
	local _lerp_modifier_func = self._lerp_modifier_func(length)
	local num_4 = _lerp_modifier_func * _lerp_modifier_func * (math.min(self.on_target_time, 0.5) / 0.5)
	local min = math.min(arg_11_3 * num_4 * 100, 0.75)
	local lerp = Quaternion.lerp(look, look_2, min)

	return arg_11_1 + Quaternion.forward(lerp) * num_3 * arg_11_3
end

ProjectileTrueFlightLocomotionExtension.update_towards_position_target = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local unbox = self.current_direction:unbox()
	local speed_multiplier = TrueFlightTemplates[self.true_flight_template_name].speed_multiplier
	local unbox_2 = self.position_target:unbox()
	local num = unbox_2 - arg_12_1
	local length = Vector3.length(num)
	local normalize = Vector3.normalize(num)
	local look = Quaternion.look(unbox)
	local look_2 = Quaternion.look(normalize)
	local num_2 = self.height_offset + math.max(arg_12_1.z - unbox_2.z, 0)
	local _lerp_modifier_func = self._lerp_modifier_func(length, num_2, arg_12_2)
	local num_3 = _lerp_modifier_func * _lerp_modifier_func * (math.min(self.on_target_time, 0.25) / 0.25)
	local min = math.min(arg_12_3 * num_3 * 100, 0.75)
	local lerp = Quaternion.lerp(look, look_2, min)

	return arg_12_1 + Quaternion.forward(lerp) * (self.speed * speed_multiplier) * arg_12_3
end

ProjectileTrueFlightLocomotionExtension.update_towards_target = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local target_unit = self.target_unit
	local unbox = self.current_direction:unbox()
	local var_13_2 = TrueFlightTemplates[self.true_flight_template_name]
	local speed_multiplier = var_13_2.speed_multiplier
	local var_13_4 = fn(target_unit, self.target_node)
	local num = var_13_4 - arg_13_1
	local length = Vector3.length(num)
	local num_2 = self.speed * speed_multiplier

	if length < num_2 * arg_13_3 then
		return var_13_4
	end

	local normalize = Vector3.normalize(num)
	local look = Quaternion.look(unbox)
	local look_2 = Quaternion.look(normalize)
	local num_3 = self.height_offset + math.max(arg_13_1.z - var_13_4.z, 0)
	local _lerp_modifier_func = self._lerp_modifier_func(length, num_3, arg_13_2)
	local num_4 = _lerp_modifier_func * _lerp_modifier_func * (math.min(self.on_target_time, 0.25) / 0.25)
	local min = math.min(arg_13_3 * num_4 * 100, 0.75)
	local lerp = Quaternion.lerp(look, look_2, min)
	local num_5 = arg_13_1 + Quaternion.forward(lerp) * num_2 * arg_13_3
	local create_bot_threat = var_13_2.create_bot_threat

	if not self.target_players and not create_bot_threat then
		self:update_bot_threat(target_unit, length)
	end

	return num_5
end

ProjectileTrueFlightLocomotionExtension.update_seeking_target = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	local var_14_0 = TrueFlightTemplates[self.true_flight_template_name]
	local speed_multiplier = var_14_0.speed_multiplier
	local dt = self.dt
	local num = self.speed * speed_multiplier
	local radians = self.radians
	local gravity = self.gravity
	local unbox = Vector3Box.unbox(self.target_vector_boxed)
	local unbox_2 = Vector3Box.unbox(self.initial_position_boxed)
	local trajectory_template_name = self.trajectory_template_name
	local is_husk = self.is_husk
	local update = ProjectileTemplates.get_trajectory_template(trajectory_template_name, is_husk).update(num, radians, gravity, unbox_2, unbox, dt)
	local flag = not arg_14_4 and self:find_new_target(arg_14_1, var_14_0, arg_14_3, dt)

	return update, flag
end

ProjectileTrueFlightLocomotionExtension.find_new_target = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	-- function 15
	if arg_15_3 > self.raycast_timer then
		self.raycast_timer = arg_15_3 + arg_15_2.time_between_raycasts

		return (self._find_target_func(self, arg_15_1, arg_15_2))
	end
end

ProjectileTrueFlightLocomotionExtension.find_player_target = function (self, arg_16_1, arg_16_2)
	-- function 16
	local var_16_0
	local side = self.side

	if not side then
		var_16_0 = side.ENEMY_PLAYER_UNITS
	else
		var_16_0 = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS
	end

	local count = #var_16_0

	if count > 0 then
		local random = Math.random(1, count)

		for i = random, random + count do
			local var_16_4 = var_16_0[(i - 1) % count + 1]

			if not HEALTH_ALIVE[var_16_4] and self.hit_units[var_16_4] or not self:_check_target_valid(var_16_4, arg_16_1, arg_16_2) then
				return var_16_4
			end
		end
	end
end

local tbl = {}

ProjectileTrueFlightLocomotionExtension.find_broadphase_target = function (self, arg_17_1, arg_17_2)
	-- function 17
	local broadphase_radius = TrueFlightTemplates[self.true_flight_template_name].broadphase_radius
	local target_broadphase_categories = self.target_broadphase_categories

	table.clear(tbl)

	local var_17_2

	if not self.target_position then
		var_17_2 = AiUtils.broadphase_query(self.target_position:unbox(), broadphase_radius, tbl, target_broadphase_categories)
	else
		local unbox = self.current_direction:unbox()

		var_17_2 = AiUtils.broadphase_query(arg_17_1 + unbox * self._retarget_broadphase_offset, broadphase_radius, tbl, target_broadphase_categories)

		if var_17_2 <= 0 then
			var_17_2 = AiUtils.broadphase_query(arg_17_1 + unbox * 2 * self._retarget_broadphase_offset, broadphase_radius * 2, tbl, target_broadphase_categories)
		end
	end

	if var_17_2 > 0 then
		table.shuffle(tbl)

		for i = 1, var_17_2 do
			local var_17_4 = tbl[i]

			if not ScriptUnit.has_extension(var_17_4, "health_system") and not HEALTH_ALIVE[var_17_4] and self.hit_units[var_17_4] or not self:_check_target_valid(var_17_4, arg_17_1, arg_17_2) then
				return var_17_4
			end
		end
	end

	return nil
end

ProjectileTrueFlightLocomotionExtension.find_closest_highest_value_target = function (self, arg_18_1, arg_18_2)
	-- function 18
	local var_18_0 = TrueFlightTemplates[self.true_flight_template_name]
	local broadphase_radius = var_18_0.broadphase_radius
	local target_broadphase_categories = self.target_broadphase_categories
	local forward_search_distance_to_find_target = var_18_0.forward_search_distance_to_find_target

	table.clear(tbl)

	local var_18_4

	if not self.target_position then
		var_18_4 = AiUtils.broadphase_query(self.target_position:unbox(), broadphase_radius, tbl, target_broadphase_categories)
	else
		local unbox = self.current_direction:unbox()

		var_18_4 = AiUtils.broadphase_query(arg_18_1 + unbox * forward_search_distance_to_find_target, broadphase_radius, tbl, target_broadphase_categories)

		if var_18_4 <= 0 then
			var_18_4 = AiUtils.broadphase_query(arg_18_1 + unbox * forward_search_distance_to_find_target * 2, broadphase_radius * 2, tbl, target_broadphase_categories)
		end
	end

	if var_18_4 > 0 then
		local num = 1

		while num <= var_18_4 do
			local var_18_7 = tbl[num]
			local get_data = Unit.get_data(var_18_7, "breed")

			if not (not get_data and (get_data.no_autoaim or not ScriptUnit.has_extension(var_18_7, "health_system") or not HEALTH_ALIVE[var_18_7] or self.hit_units[var_18_7] or self:_check_target_valid(var_18_7, arg_18_1, arg_18_2))) then
				table.swap_delete(tbl, num)

				var_18_4 = var_18_4 - 1
			else
				num = num + 1
			end
		end

		TrueFlightUtility.sort_prioritize_specials(tbl)

		return tbl[1]
	end

	return nil
end

ProjectileTrueFlightLocomotionExtension.legitimate_always = function (arg_19_0, arg_19_1, arg_19_2)
	-- function 19
	return true
end

ProjectileTrueFlightLocomotionExtension.legitimate_never = function (arg_20_0, arg_20_1, arg_20_2)
	-- function 20
	return false
end

ProjectileTrueFlightLocomotionExtension.legitimate_only_dot_check = function (self, arg_21_1, arg_21_2)
	-- function 21
	local node

	if not Unit.has_node(arg_21_1, "c_spine") then
		node = Unit.node(arg_21_1, "c_spine")

		if not node then
			-- Nothing
		end
	end

	node = 0

	::label_21_0::

	local world_position = Unit.world_position(arg_21_1, node)
	local unbox = self.current_direction:unbox()
	local num = world_position - arg_21_2
	local normalize = Vector3.normalize(num)

	if Vector3.dot(unbox, normalize) > -self._valid_target_dot then
		return true
	else
		self.target_unit = nil
	end
end

ProjectileTrueFlightLocomotionExtension.legitimate_target = function (self, arg_22_1, arg_22_2)
	-- function 22
	local var_22_0 = fn(arg_22_1, "c_head")
	local unbox = self.current_direction:unbox()
	local num = var_22_0 - arg_22_2

	if Vector3.length_squared(num) < math.epsilon then
		return true
	end

	local normalize = Vector3.normalize(num)

	if Vector3.dot(unbox, normalize) > -self._valid_target_dot then
		local get_data = World.get_data(self.world, "physics_world")
		local immediate_raycast_actors = PhysicsWorld.immediate_raycast_actors(get_data, arg_22_2, normalize, 10000, "static_collision_filter", "filter_player_ray_projectile_static_only", "dynamic_collision_filter", "filter_player_ray_projectile_ai_only", "dynamic_collision_filter", "filter_player_ray_projectile_hitbox_only")
		local num_2 = 4

		if not immediate_raycast_actors then
			for k, v in pairs(immediate_raycast_actors) do
				local var_22_7 = v[num_2]
				local unit = Actor.unit(var_22_7)

				if unit ~= self.owner_unit then
					if not Unit.get_data(unit, "breed") then
						if unit == arg_22_1 then
							return true
						end
					elseif var_22_7 ~= Unit.actor(unit, "c_afro") then
						return false
					end
				end
			end
		end
	else
		self.target_unit = nil
	end

	return false
end

ProjectileTrueFlightLocomotionExtension.legitimate_target_keep_target = function (self, arg_23_1, arg_23_2)
	-- function 23
	local var_23_0 = fn(arg_23_1, "c_head")
	local unbox = self.current_direction:unbox()
	local num = var_23_0 - arg_23_2

	if Vector3.length_squared(num) == 0 then
		return true
	end

	local normalize = Vector3.normalize(num)

	if not (not (Vector3.dot(unbox, normalize) > -self._valid_target_dot) or not (Vector3.length_squared(normalize) > 0)) then
		local get_data = World.get_data(self.world, "physics_world")
		local immediate_raycast_actors = PhysicsWorld.immediate_raycast_actors(get_data, arg_23_2, normalize, 10000, "static_collision_filter", "filter_player_ray_projectile_static_only", "dynamic_collision_filter", "filter_player_ray_projectile_ai_only", "dynamic_collision_filter", "filter_player_ray_projectile_hitbox_only")
		local num_2 = 4

		if not immediate_raycast_actors then
			for k, v in pairs(immediate_raycast_actors) do
				local var_23_7 = v[num_2]
				local unit = Actor.unit(var_23_7)

				if unit ~= self.owner_unit then
					if not Unit.get_data(unit, "breed") then
						if unit == arg_23_1 then
							return true
						end
					elseif var_23_7 ~= Unit.actor(unit, "c_afro") then
						return false
					end
				end
			end
		end
	end

	return false
end

ProjectileTrueFlightLocomotionExtension.legitimate_player_target = function (self, arg_24_1, arg_24_2)
	-- function 24
	local target_node = self.target_node
	local node

	if not Unit.has_node(arg_24_1, target_node) then
		node = Unit.node(arg_24_1, target_node)

		if not node then
			-- Nothing
		end
	end

	node = 0

	::label_24_0::

	local world_position = Unit.world_position(arg_24_1, node)
	local unbox = self.current_direction:unbox()
	local num = world_position - arg_24_2

	if Vector3.length_squared(num) == 0 then
		return true
	end

	local normalize = Vector3.normalize(num)

	if Vector3.dot(unbox, normalize) > -0.99 then
		local get_data = World.get_data(self.world, "physics_world")
		local immediate_raycast_actors = PhysicsWorld.immediate_raycast_actors(get_data, arg_24_2, normalize, 10000, "static_collision_filter", "filter_player_ray_projectile_static_only", "dynamic_collision_filter", "filter_player_ray_projectile_ai_only", "dynamic_collision_filter", "filter_player_ray_projectile_hitbox_only")
		local num_2 = 4

		if not immediate_raycast_actors then
			for k, v in pairs(immediate_raycast_actors) do
				local var_24_9 = v[num_2]
				local unit = Actor.unit(var_24_9)

				if unit ~= self.owner_unit then
					if not VALID_PLAYERS_AND_BOTS[unit] then
						if unit == arg_24_1 then
							return true
						end
					elseif var_24_9 ~= Unit.actor(unit, "c_afro") then
						return false
					end
				end
			end
		end
	else
		self.target_unit = nil
	end

	return false
end

ProjectileTrueFlightLocomotionExtension._unit_set_position_rotation = function (self, arg_25_1, arg_25_2, arg_25_3)
	-- function 25
	if not self.true_flight_template.update_unit_position then
		self.true_flight_template.update_unit_position(arg_25_1, arg_25_2, arg_25_3, self._custom_data, self)
	else
		Unit.set_local_rotation(arg_25_1, 0, arg_25_3)
		Unit.set_local_position(arg_25_1, 0, arg_25_2)
	end
end

ProjectileTrueFlightLocomotionExtension.moved_this_frame = function (self)
	-- function 26
	return self.moved
end

ProjectileTrueFlightLocomotionExtension.current_velocity = function (self)
	-- function 27
	return self.velocity:unbox()
end

ProjectileTrueFlightLocomotionExtension.current_position = function (self)
	-- function 28
	return self._current_position:unbox()
end

ProjectileTrueFlightLocomotionExtension.destroy = function (self)
	-- function 29
	if not self.true_flight_template.create_bot_threat then
		local var_29_0 = HEALTH_ALIVE[self.owner_unit]

		var_29_0 = not var_29_0 and BLACKBOARDS[self.owner_unit]

		if not var_29_0 then
			var_29_0.created_missile_bot_threat = nil
		end
	end

	self.hit_units = nil
end

ProjectileTrueFlightLocomotionExtension.notify_hit_enemy = function (self, arg_30_1)
	-- function 30
	self.hit_units[arg_30_1] = true
	self.raycast_timer = 0
end

ProjectileTrueFlightLocomotionExtension.update_bot_threat = function (self, arg_31_1, arg_31_2)
	-- function 31
	if arg_31_2 < self.true_flight_template.bot_threat_at_distance then
		local var_31_0 = HEALTH_ALIVE[self.owner_unit]

		var_31_0 = not var_31_0 and BLACKBOARDS[self.owner_unit]

		if not (not var_31_0 and var_31_0.created_missile_bot_threat) then
			var_31_0.missile_bot_threat_unit = arg_31_1
			var_31_0.created_missile_bot_threat = true
		end
	end
end

ProjectileTrueFlightLocomotionExtension.stop = function (self)
	-- function 32
	if not self.true_flight_template.update_after_impact then
		return
	end

	self.stopped = true
end
