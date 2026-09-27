-- chunkname: @scripts/unit_extensions/weapons/actions/action_geiser_targeting.lua

ActionGeiserTargeting = class(ActionGeiserTargeting, ActionBase)

ActionGeiserTargeting.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionGeiserTargeting.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.position = Vector3Box()
	self.first_person_extension = ScriptUnit.extension(arg_1_4, "first_person_system")
	self.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	self.unit_id = Managers.state.network.unit_storage:go_id(arg_1_4)
	self._is_server = arg_1_3
end

ActionGeiserTargeting.client_owner_start_action = function (self, arg_2_1, arg_2_2)
	-- function 2
	ActionGeiserTargeting.super.client_owner_start_action(self, arg_2_1, arg_2_2)

	local world = self.world
	local network_transmit = self.network_transmit
	local owner_unit = self.owner_unit

	self.overcharge_timer = 0
	self.current_action = arg_2_1
	self.fully_charged_triggered = false

	local particle_effect = arg_2_1.particle_effect
	local var_2_4 = NetworkLookup.effects[particle_effect]
	local extension = ScriptUnit.extension(owner_unit, "buff_system")

	self.buff_extension = extension

	if not self._is_server then
		self.targeting_effect_id = World.create_particles(world, particle_effect, Vector3.zero())
		self.targeting_variable_id = World.find_particles_variable(world, particle_effect, "charge_radius")
	end

	self.charge_time = extension:apply_buffs_to_value(arg_2_1.charge_time, "reduced_ranged_charge_time")
	self.angle = math.degrees_to_radians(arg_2_1.angle)
	self.time_to_shoot = arg_2_2

	local unit_id = self.unit_id

	network_transmit:send_rpc_server("rpc_start_geiser", unit_id, var_2_4, arg_2_1.min_radius, arg_2_1.max_radius, self.charge_time, self.angle)

	self.min_radius = arg_2_1.min_radius
	self.max_radius = arg_2_1.max_radius
	self.radius = self.min_radius
	self.charge_ready_sound_event = self.current_action.charge_ready_sound_event
	self.speed = arg_2_1.speed
	self.gravity = arg_2_1.gravity

	local height = arg_2_1.height

	height = height or 1
	self.height = height
	self.debug_draw = arg_2_1.debug_draw

	local owner = Managers.player:owner(owner_unit)

	if (not owner and owner.bot_player or not self.current_action.fire_at_gaze_setting) and not ScriptUnit.has_extension(owner_unit, "eyetracking_system") then
		local extension_2 = ScriptUnit.extension(owner_unit, "eyetracking_system")

		if not extension_2:get_is_feature_enabled("tobii_fire_at_gaze") then
			local world_rotation = Unit.world_rotation(self.first_person_unit, 0)
			local gaze_rotation = extension_2:gaze_rotation()
			local inverse = Quaternion.inverse(world_rotation)
			local multiply = Quaternion.multiply(inverse, gaze_rotation)

			self.fire_at_gaze_offset = QuaternionBox()

			QuaternionBox.store(self.fire_at_gaze_offset, multiply)
		end
	end

	self:_start_charge_sound()

	self.charge_value = 0
end

local function fn(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	-- function 3
	local num = arg_3_2 / arg_3_1

	for i = 1, arg_3_1 do
		local num_2 = arg_3_3 + arg_3_4 * num
		local num_3 = num_2 - arg_3_3
		local normalize = Vector3.normalize(num_3)
		local length = Vector3.length(num_3)
		local immediate_raycast, var_3_6, var_3_7, var_3_8, var_3_9 = PhysicsWorld.immediate_raycast(arg_3_0, arg_3_3, normalize, length, "closest", "collision_filter", arg_3_6)

		if not var_3_6 then
			return immediate_raycast, var_3_6, var_3_7, var_3_8, var_3_9
		end

		arg_3_4 = arg_3_4 + arg_3_5 * num
		arg_3_3 = num_2
	end

	return false, arg_3_3
end

ActionGeiserTargeting._start_charge_sound = function (self)
	-- function 4
	local current_action = self.current_action
	local owner_unit = self.owner_unit
	local owner_player = self.owner_player
	local flag = not owner_player and owner_player.bot_player
	local flag_2 = not owner_player and not owner_player.remote
	local wwise_world = self.wwise_world

	if not (not flag_2 and flag) then
		local start_charge_sound, var_4_7 = ActionUtils.start_charge_sound(wwise_world, self.weapon_unit, owner_unit, current_action)

		self.charging_sound_id = start_charge_sound
		self.wwise_source_id = var_4_7
	end

	ActionUtils.play_husk_sound_event(wwise_world, current_action.charge_sound_husk_name, owner_unit, flag)
end

ActionGeiserTargeting._stop_charge_sound = function (self)
	-- function 5
	local current_action = self.current_action
	local owner_unit = self.owner_unit
	local owner_player = self.owner_player
	local flag = not owner_player and owner_player.bot_player
	local flag_2 = not owner_player and not owner_player.remote
	local wwise_world = self.wwise_world

	if not (not flag_2 and flag) then
		ActionUtils.stop_charge_sound(wwise_world, self.charging_sound_id, self.wwise_source_id, current_action)

		self.charging_sound_id = nil
		self.wwise_source_id = nil
	end

	ActionUtils.play_husk_sound_event(wwise_world, current_action.charge_sound_husk_stop_event, owner_unit, flag)
end

ActionGeiserTargeting.client_owner_post_update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local time_to_shoot = self.time_to_shoot
	local current_action = self.current_action

	if not current_action.overcharge_interval then
		self.overcharge_timer = self.overcharge_timer + arg_6_1

		if self.overcharge_timer >= current_action.overcharge_interval then
			if not self.overcharge_extension then
				local var_6_2 = PlayerUnitStatusSettings.overcharge_values[current_action.overcharge_type]

				self.overcharge_extension:add_charge(var_6_2, nil, current_action.overcharge_type)
			end

			self.overcharge_timer = 0
		end
	end

	local var_6_3 = POSITION_LOOKUP[self.owner_unit]
	local var_6_4 = POSITION_LOOKUP[self.first_person_unit]
	local world_rotation = Unit.world_rotation(self.first_person_unit, 0)

	if not self.fire_at_gaze_offset then
		world_rotation = Quaternion.multiply(world_rotation, QuaternionBox.unbox(self.fire_at_gaze_offset))
	end

	local var_6_6
	local get_data = World.get_data(arg_6_3, "physics_world")
	local num = 10
	local num_2 = 1.5
	local speed = self.speed
	local angle = self.angle
	local num_3 = Quaternion.forward(Quaternion.multiply(world_rotation, Quaternion(Vector3.right(), angle))) * speed
	local var_6_13 = Vector3(0, 0, self.gravity)
	local str = "filter_geiser_check"
	local var_6_15, var_6_16, var_6_17, var_6_18 = fn(get_data, num, num_2, var_6_4, num_3, var_6_13, str, self.debug_draw)
	local var_6_19 = var_6_16

	if not var_6_15 then
		local var_6_20 = Vector3(0, 0, 1)

		if Vector3.dot(var_6_18, var_6_20) < 0.75 then
			local num_4 = var_6_19 - 1 * Vector3.normalize(var_6_19 - var_6_3)
			local immediate_raycast, var_6_23, var_6_24, var_6_25 = PhysicsWorld.immediate_raycast(get_data, num_4, Vector3(0, 0, -1), 5, "closest", "collision_filter", str)

			if not var_6_23 then
				var_6_19 = var_6_23
			end
		end
	end

	self.position:store(var_6_19)

	self.charge_value = math.min(math.max(arg_6_2 - time_to_shoot, 0) / self.charge_time, 1)

	if not (not (self.charge_value >= 1) or self.fully_charged_triggered) then
		self.fully_charged_triggered = true

		self.buff_extension:trigger_procs("on_full_charge")
	end

	local min_radius = self.min_radius
	local max_radius = self.max_radius
	local min = math.min(max_radius, (max_radius - min_radius) * self.charge_value + min_radius)

	self.radius = min

	if not self.targeting_effect_id then
		local num_5 = min * 2

		World.move_particles(arg_6_3, self.targeting_effect_id, var_6_19)
		World.set_particles_variable(arg_6_3, self.targeting_effect_id, self.targeting_variable_id, Vector3(num_5, num_5, 1))
	end

	local owner_unit = self.owner_unit
	local owner = Managers.player:owner(owner_unit)

	if not (not owner and owner.bot_player) then
		local charge_sound_parameter_name = current_action.charge_sound_parameter_name

		if not charge_sound_parameter_name then
			local wwise_world = self.wwise_world
			local wwise_source_id = self.wwise_source_id

			WwiseWorld.set_source_parameter(wwise_world, wwise_source_id, charge_sound_parameter_name, self.charge_value)
		end

		if not (not self.charge_ready_sound_event and not (self.charge_value >= 1)) then
			self.first_person_extension:play_hud_sound_event(self.charge_ready_sound_event)

			self.charge_ready_sound_event = nil
		end
	end
end

ActionGeiserTargeting.finish = function (self, arg_7_1, arg_7_2)
	-- function 7
	local world = self.world
	local network_transmit = self.network_transmit
	local unit_id = self.unit_id

	network_transmit:send_rpc_server("rpc_end_geiser", unit_id)

	local tbl = {
		radius = self.radius,
		range = self.range,
		height = self.height,
		charge_value = self.charge_value,
		position = self.position
	}

	if not self.targeting_effect_id then
		World.destroy_particles(world, self.targeting_effect_id)

		self.targeting_effect_id = nil
	end

	self:_stop_charge_sound()
	self.buff_extension:trigger_procs("on_charge_finished")

	return tbl
end

ActionGeiserTargeting.destroy = function (self)
	-- function 8
	if not self.targeting_effect_id then
		World.destroy_particles(self.world, self.targeting_effect_id)

		self.targeting_effect_id = nil
	end

	self:_stop_charge_sound()
end
