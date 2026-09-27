-- chunkname: @scripts/unit_extensions/weapons/area_damage/liquid/damage_wave_extension.lua

local scripts_utils_stagger_types = require("scripts/utils/stagger_types")

DamageWaveExtension = class(DamageWaveExtension)

local alive = Unit.alive
local POSITION_LOOKUP = POSITION_LOOKUP
local tbl = {
	math.huge,
	math.huge,
	math.huge,
	math.huge,
	math.huge,
	math.huge
}
local tbl_2 = {}

DamageWaveExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local world = arg_1_1.world
	local entity = Managers.state.entity
	local system = entity:system("ai_system")

	self.world = world
	self.game = Managers.state.network:game()
	self.unit = arg_1_2
	self.source_unit = arg_1_3.source_unit
	self._buff_params = {
		attacker_unit = arg_1_2,
		source_attacker_unit = arg_1_3.source_unit
	}
	self._source_side = Managers.state.side.side_by_unit[self.source_unit]
	self.displaced_units = {}
	self.nav_world = system:nav_world()
	self.network_manager = Managers.state.network
	self.network_transmit = self.network_manager.network_transmit
	self.ai_system = system
	self.ai_blob_index = 1
	self.blobs = {}
	self.rim_nodes = {}
	self.fx_list = {}
	self.ai_units_inside = {}

	local player_units_inside = arg_1_3.player_units_inside

	player_units_inside = player_units_inside or {}
	self.player_units_inside = player_units_inside

	local ai_hit_by_wavefront = arg_1_3.ai_hit_by_wavefront

	ai_hit_by_wavefront = ai_hit_by_wavefront or {}
	self.ai_hit_by_wavefront = ai_hit_by_wavefront
	self.buff_system = entity:system("buff_system")

	local damage_wave_template_name = arg_1_3.damage_wave_template_name
	local var_1_6 = DamageWaveTemplates.templates[damage_wave_template_name]

	if not var_1_6.is_transient then
		self.is_transient = true
		self.transient_name_override = var_1_6.transient_name_override
	end

	self.template = var_1_6
	self.damage_wave_template_name = damage_wave_template_name
	self.immune_breeds = var_1_6.immune_breeds
	self.buff_template_name = var_1_6.buff_template_name
	self.buff_template_type = var_1_6.buff_template_type
	self.leave_area_func = var_1_6.leave_area_func
	self.add_buff_func = var_1_6.add_buff_func
	self.buff_wave_impact_template_name = var_1_6.buff_wave_impact_name
	self.buff_wave_impact_impact_type = var_1_6.buff_wave_impact_type
	self.fx_name_filled = var_1_6.fx_name_filled
	self.fx_name_running = var_1_6.fx_name_running
	self.fx_name_impact = var_1_6.fx_name_impact
	self.fx_name_arrived = var_1_6.fx_name_arrived

	if not var_1_6.running_spawn_config then
		self._running_spawn_configs = var_1_6.running_spawn_config
		self._running_spawn_datas = {}

		local time = Managers.time:time("game")

		for i = 1, #var_1_6.running_spawn_config do
			local var_1_8 = var_1_6.running_spawn_config[i]
			local _running_spawn_datas = self._running_spawn_datas
			local tbl = {}
			local start_delay = var_1_8.start_delay

			start_delay = start_delay or 0
			tbl.next_spawn_t = time + start_delay
			tbl.next_seed = math.random_seed()
			_running_spawn_datas[i] = tbl
		end

		self._local_units = {}
	end

	local fx_name_init = var_1_6.fx_name_init

	if not fx_name_init then
		local create_particles = World.create_particles(world, fx_name_init, POSITION_LOOKUP[arg_1_2], Unit.local_rotation(arg_1_2, 0))

		World.link_particles(world, create_particles, arg_1_2, 0, Matrix4x4.identity(), var_1_6.particle_arrived_stop_mode)

		self.init_effect_id = create_particles
	end

	self.blob_separation_dist = var_1_6.blob_separation_dist
	self.fx_separation_dist = var_1_6.fx_separation_dist
	self.max_height = var_1_6.max_height
	self.overflow_dist = var_1_6.overflow_dist
	self.launch_wave_sound = var_1_6.launch_wave_sound
	self.running_wave_sound = var_1_6.running_wave_sound
	self.stop_running_wave_sound = var_1_6.stop_running_wave_sound
	self.impact_wave_sound = var_1_6.impact_wave_sound
	self.start_speed = var_1_6.start_speed
	self.acceleration = var_1_6.acceleration
	self.max_speed = var_1_6.max_speed
	self.player_query_distance = var_1_6.player_query_distance
	self.ai_query_distance = var_1_6.ai_query_distance
	self.travel_dist = 0
	self.apply_buff_to_ai = var_1_6.apply_buff_to_ai
	self.apply_buff_to_player = var_1_6.apply_buff_to_player
	self.apply_buff_to_owner = var_1_6.apply_buff_to_owner
	self.apply_impact_buff_to_player = var_1_6.apply_impact_buff_to_player
	self.apply_impact_buff_to_ai = var_1_6.apply_impact_buff_to_ai
	self.damage_friendly_ai = var_1_6.damage_friendly_ai
	self.time_of_life = var_1_6.time_of_life
	self.launch_animation = var_1_6.launch_animation
	self._on_arrive_func = var_1_6.on_arrive_func
	self._update_func = var_1_6.update_func

	local init_func = var_1_6.init_func

	if not init_func then
		init_func(self)
	end
end

DamageWaveExtension.set_update_func = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	self._update_func = arg_2_1

	if not arg_2_2 then
		arg_2_2(self, arg_2_3)
	end
end

DamageWaveExtension._calculate_oobb_collision = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	-- function 3
	local num = arg_3_1 * 0.5
	local num_2 = arg_3_2 * 0.5
	local num_3 = arg_3_3 * 0.5
	local var_3_3 = Vector3(num, num_2, num_3)
	local num_4 = Quaternion.rotate(arg_3_7, Vector3.forward()) * (arg_3_4 + num_2)
	local num_5 = Vector3.up() * (arg_3_5 + num_3)

	return arg_3_6 + num_4 + num_5, arg_3_7, var_3_3
end

DamageWaveExtension.launch_wave = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local unit = self.unit

	if not Unit.alive(unit) then
		return
	end

	self.optional_data = arg_4_3

	local var_4_1 = arg_4_2

	var_4_1 = var_4_1 or POSITION_LOOKUP[arg_4_1]

	local start_speed = self.start_speed

	self.target_unit = arg_4_1
	self.target_pos = Vector3Box(var_4_1)
	self.wave_speed = start_speed

	local var_4_3 = POSITION_LOOKUP[unit]
	local num = var_4_1 - var_4_3
	local length = Vector3.length(num)

	self.initial_dist = length
	self.original_pos_z = var_4_3.z

	local normalize = Vector3.normalize(num)
	local look = Quaternion.look(normalize)

	self.wave_direction = Vector3Box(normalize)

	local template = self.template
	local use_nav_cost_map_volumes = template.use_nav_cost_map_volumes

	if not use_nav_cost_map_volumes then
		local nav_cost_map_cost_type = template.nav_cost_map_cost_type
		local blob_separation_dist = self.blob_separation_dist
		local max = math.max(math.floor(length / blob_separation_dist), 1)

		self._nav_cost_map_id = self.ai_system:create_nav_cost_map(nav_cost_map_cost_type, max)
	end

	self.use_nav_cost_map_volumes = use_nav_cost_map_volumes

	if not template.create_bot_aoe_threat then
		local str = "DamageWaveExtension"
		local num_2

		if start_speed > 0 then
			num_2 = length / start_speed

			if not num_2 then
				-- Nothing
			end
		end

		num_2 = length

		::label_4_0::

		local num_3 = self.player_query_distance * 2
		local num_4 = length + self.overflow_dist
		local player_query_distance = self.player_query_distance
		local num_5 = 0
		local num_6 = 0
		local _calculate_oobb_collision, var_4_21, var_4_22 = self:_calculate_oobb_collision(num_3, num_4, player_query_distance, num_5, num_6, var_4_3, look)

		Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(_calculate_oobb_collision, "oobb", var_4_22, var_4_21, num_2, str)
	end

	self.last_dist = length
	self.last_fx_dist = length
	self.effect_id = World.create_particles(self.world, self.fx_name_running, var_4_3 + Vector3.up() * 5, look)

	World.link_particles(self.world, self.effect_id, self.unit, 0, Matrix4x4.identity(), template.particle_arrived_stop_mode)

	local launch_wave_sound = self.launch_wave_sound

	if not launch_wave_sound then
		WwiseUtils.trigger_position_event(self.world, launch_wave_sound, var_4_3)
	end

	local running_wave_sound = self.running_wave_sound

	if not running_wave_sound then
		local trigger_unit_event, var_4_26 = WwiseUtils.trigger_unit_event(self.world, running_wave_sound, self.unit)

		self.running_source_id = var_4_26
	end

	self.state = "running"

	local network_manager = self.network_manager
	local unit_game_object_id = network_manager:unit_game_object_id(unit)

	if not unit_game_object_id then
		self.network_transmit:send_rpc_clients("rpc_damage_wave_set_state", unit_game_object_id, NetworkLookup.damage_wave_states.running)
	end

	self.unit_id = unit_game_object_id

	local launch_animation = self.launch_animation

	if not launch_animation and not Unit.has_animation_state_machine(unit) then
		network_manager:anim_event(unit, launch_animation)
	end

	self.is_launched = true
end

DamageWaveExtension.destroy = function (self)
	-- function 5
	local unit = self.unit
	local player_units_inside = self.player_units_inside
	local buff_system = self.buff_system

	for k, v in pairs(player_units_inside) do
		if not alive(k) then
			if ScriptUnit.extension(k, "status_system").in_liquid_unit == unit then
				StatusUtils.set_in_liquid_network(k, false)
			end

			if not self.leave_area_func then
				self.leave_area_func(k)
			end
		end
	end

	local blobs = self.blobs
	local count = #blobs
	local ai_system = self.ai_system
	local _nav_cost_map_id = self._nav_cost_map_id

	for k_2 = 1, count do
		local var_5_7 = blobs[k_2][6]

		if not var_5_7 then
			ai_system:remove_nav_cost_map_volume(var_5_7, _nav_cost_map_id)
		end
	end

	if not self.leave_area_func then
		for k_3, v_2 in pairs(self.ai_units_inside) do
			self.leave_area_func(k_3)
		end
	end

	if not _nav_cost_map_id then
		ai_system:destroy_nav_cost_map(_nav_cost_map_id)
	end

	local world = self.world
	local fx_list = self.fx_list
	local count_2 = #fx_list

	for i5 = 1, count_2 do
		local id = fx_list[i5].id

		World.stop_spawning_particles(world, id)
	end

	local _local_units = self._local_units

	if not _local_units then
		for i6 = 1, #_local_units do
			World.destroy_unit(world, _local_units[i6])

			_local_units[i6] = nil
		end
	end

	table.clear(tbl_2)
end

DamageWaveExtension.abort = function (self)
	-- function 6
	if not alive(self.unit) then
		return
	end

	local unit = self.unit
	local var_6_1 = POSITION_LOOKUP[unit]
	local identity = Quaternion.identity()

	Managers.state.unit_spawner:mark_for_deletion(unit)

	if not self.impact_wave_sound then
		WwiseUtils.trigger_unit_event(self.world, self.impact_wave_sound, unit)
	end

	if not self.fx_name_arrived then
		local network_manager = self.network_manager
		local var_6_4 = NetworkLookup.effects[self.fx_name_arrived]
		local num = 0

		network_manager:rpc_play_particle_effect(nil, var_6_4, NetworkConstants.invalid_game_object_id, num, var_6_1, identity, false)
	end
end

DamageWaveExtension.move_wave = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	local acceleration = self.acceleration
	local wave_speed = self.wave_speed

	if wave_speed < self.max_speed then
		wave_speed = wave_speed + acceleration * arg_7_3
		self.wave_speed = wave_speed
	end

	local var_7_2 = POSITION_LOOKUP[arg_7_1]
	local local_rotation = Unit.local_rotation(arg_7_1, 0)
	local var_7_4 = Vector3(var_7_2.x, var_7_2.y, self.original_pos_z)
	local num = self.target_pos:unbox() - var_7_4
	local length = Vector3.length(num)
	local zero

	if length < 0.001 then
		zero = Vector3.zero()

		if not zero then
			-- Nothing
		end
	end

	zero = Vector3.divide(num, length)

	::label_7_0::

	local unbox = self.wave_direction:unbox()
	local min = math.min(wave_speed * arg_7_3, length)

	self.travel_dist = self.travel_dist + min

	local num_2 = var_7_4 + unbox * min

	self.original_pos_z = num_2.z

	local nav_world = self.nav_world
	local num_3 = 1.5
	local flag

	flag = not self.template.ignore_obstacles and 15 and 1.5

	local triangle_from_position, var_7_15, var_7_16, var_7_17, var_7_18 = GwNavQueries.triangle_from_position(nav_world, num_2, num_3, flag)

	if not triangle_from_position then
		num_2 = Vector3(num_2.x, num_2.y, var_7_15)
	end

	Unit.set_local_position(arg_7_1, 0, num_2)

	if not (not self.blob_separation_dist and not (self.last_dist - length >= self.blob_separation_dist)) then
		self:insert_blob(num_2, self.ai_query_distance, local_rotation, nav_world)

		self.last_dist = length
	end

	if not (not self.fx_name_filled and not (self.last_fx_dist - length >= self.fx_separation_dist)) then
		local look = Quaternion.look(unbox, Vector3(0, 0, 1))

		self:insert_fx(num_2, look, 0)

		self.last_fx_dist = length
	end

	local var_7_20
	local num_4

	if arg_7_4 > 0 then
		num_4 = length / arg_7_4

		if not num_4 then
			-- Nothing
		end
	end

	num_4 = 0

	::label_7_1::

	if not arg_7_5 then
		var_7_20 = math.clamp(num_4, 0, 1)
	else
		var_7_20 = math.clamp(1 - num_4, 0, 1)
	end

	GameSession.set_game_object_field(self.game, self.unit_id, "height_percentage", var_7_20)
	GameSession.set_game_object_field(self.game, self.unit_id, "position", num_2)
	GameSession.set_game_object_field(self.game, self.unit_id, "rotation", local_rotation)

	return zero, length, triangle_from_position or self.template.ignore_obstacles
end

DamageWaveExtension.on_hit_by_wave = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	if not tbl_2[arg_8_0] then
		return
	end

	local world = arg_8_2.world
	local look = Quaternion.look(Vector3.forward(), Vector3.up())

	if not arg_8_2.fx_name_impact then
		World.create_particles(world, arg_8_2.fx_name_impact, POSITION_LOOKUP[arg_8_1], look)
	end

	local impact_wave_sound = arg_8_2.impact_wave_sound

	if not impact_wave_sound then
		WwiseUtils.trigger_unit_event(world, impact_wave_sound, arg_8_1)
	end

	if not DamageUtils.is_player_unit(arg_8_0) and not arg_8_2.apply_impact_buff_to_player then
		local system = Managers.state.entity:system("buff_system")

		if not ScriptUnit.extension(arg_8_0, "buff_system"):has_buff_type(arg_8_2.buff_wave_impact_impact_type) then
			system:add_buff(arg_8_0, arg_8_2.buff_wave_impact_template_name, arg_8_1)
		end

		if not arg_8_2.template.trigger_dialogue_on_impact then
			local extension_input = ScriptUnit.extension_input(arg_8_0, "dialogue_system")
			local alloc_table = FrameTable.alloc_table()

			alloc_table.distance = DialogueSettings.pounced_down_broadcast_range
			alloc_table.target = arg_8_0
			alloc_table.target_name = ScriptUnit.extension(arg_8_0, "dialogue_system").context.player_profile

			extension_input:trigger_dialogue_event("on_plague_wave_hit", alloc_table)
		end
	end

	local unit_id = arg_8_2.unit_id

	if not unit_id then
		arg_8_2.network_transmit:send_rpc_clients("rpc_damage_wave_set_state", unit_id, NetworkLookup.damage_wave_states.impact)
	end

	tbl_2[arg_8_0] = true
end

local num = 0.5

DamageWaveExtension.wave_arrived = function (self, arg_9_1, arg_9_2)
	-- function 9
	self.state = "lingering"
	self.linger_time = arg_9_1 + self.time_of_life

	Unit.set_unit_visibility(arg_9_2, false)

	local world = self.world
	local wwise_world = Managers.world:wwise_world(world)
	local running_source_id = self.running_source_id
	local stop_running_wave_sound = self.stop_running_wave_sound

	if not WwiseWorld.has_source(wwise_world, running_source_id) and not stop_running_wave_sound then
		WwiseWorld.trigger_event(wwise_world, stop_running_wave_sound, running_source_id)
	end

	self.running_source_id = nil

	local impact_wave_sound = self.impact_wave_sound

	if not impact_wave_sound then
		WwiseUtils.trigger_unit_event(world, impact_wave_sound, arg_9_2)
	end

	World.stop_spawning_particles(world, self.effect_id)

	local var_9_5 = POSITION_LOOKUP[arg_9_2]
	local look = Quaternion.look(self.wave_direction:unbox())

	if not self.fx_name_arrived then
		World.create_particles(world, self.fx_name_arrived, var_9_5, look)
	end

	local unit_id = self.unit_id

	if not unit_id then
		self.network_transmit:send_rpc_clients("rpc_damage_wave_set_state", unit_id, NetworkLookup.damage_wave_states.arrived)
	end

	if not self.init_effect_id then
		World.stop_spawning_particles(world, self.init_effect_id)
	end

	local blobs = self.blobs
	local count = #blobs

	if count > 0 then
		local local_rotation = Unit.local_rotation(arg_9_2, 0)
		local forward = Quaternion.forward(local_rotation)
		local var_9_12 = blobs[count]
		local num_2 = Vector3(var_9_12[1], var_9_12[2], var_9_12[3]) + forward * (var_9_12[4] + num)
		local triangle_from_position, var_9_15 = GwNavQueries.triangle_from_position(self.nav_world, num_2, 1.5, 1.5)

		if not triangle_from_position then
			local rim_nodes = self.rim_nodes

			num_2.z = var_9_15
			rim_nodes[#rim_nodes + 1] = Vector3Box(num_2)
		end
	end

	if not self._on_arrive_func then
		self._on_arrive_func(self, var_9_5, look)
	end
end

DamageWaveExtension.wavefront_impact = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7)
	-- function 10
	if not arg_10_4 then
		return
	end

	local BLACKBOARDS = BLACKBOARDS
	local ai_hit_by_wavefront = self.ai_hit_by_wavefront
	local immune_breeds = self.immune_breeds
	local stagger_impact = arg_10_4.stagger_impact
	local stagger_duration = arg_10_4.stagger_duration
	local stagger_distance = arg_10_4.stagger_distance
	local stagger_distance_table = arg_10_4.stagger_distance_table
	local push_along_wave_direction = arg_10_4.push_along_wave_direction
	local apply_impact_buff_to_ai = self.apply_impact_buff_to_ai
	local stagger_refresh_time = arg_10_4.stagger_refresh_time

	stagger_refresh_time = stagger_refresh_time or tbl

	local drag_along_wave = arg_10_4.drag_along_wave

	drag_along_wave = not drag_along_wave and arg_10_6 * self.wave_speed

	local wave_drag_multiplier = arg_10_4.wave_drag_multiplier
	local wave_drag_multiplier_table = arg_10_4.wave_drag_multiplier_table
	local hit_half_extends = arg_10_4.hit_half_extends
	local from_quaternion_position = Matrix4x4.from_quaternion_position(Quaternion.look(arg_10_6), arg_10_2)
	local buff_system = self.buff_system
	local buff_wave_impact_impact_type = self.buff_wave_impact_impact_type
	local buff_wave_impact_template_name = self.buff_wave_impact_template_name
	local _source_side = self._source_side
	local enemy_broadphase_categories

	if not (not _source_side and self.damage_friendly_ai) then
		enemy_broadphase_categories = _source_side.enemy_broadphase_categories

		if not enemy_broadphase_categories then
			-- Nothing
		end
	end

	enemy_broadphase_categories = nil

	::label_10_0::

	local alloc_table = FrameTable.alloc_table()
	local broadphase_query = AiUtils.broadphase_query(arg_10_2, arg_10_3, alloc_table, enemy_broadphase_categories)

	for i = 1, broadphase_query do
		local var_10_22 = alloc_table[i]
		local var_10_23 = HEALTH_ALIVE[var_10_22]
		local var_10_24 = BLACKBOARDS[var_10_22]
		local name = var_10_24.breed.name

		if not drag_along_wave then
			local var_10_26 = ai_hit_by_wavefront[var_10_22]

			var_10_26 = var_10_26 or 0

			if var_10_26 <= arg_10_1 then
				-- Nothing
			end
		end

		if not (not var_10_23 and not immune_breeds[name]) then
			local var_10_27 = POSITION_LOOKUP[var_10_22]

			if not (not hit_half_extends and math.point_is_inside_box(var_10_27, from_quaternion_position, hit_half_extends)) then
				local breed = var_10_24.breed
				local stagger_armor_category = breed.stagger_armor_category

				if not stagger_armor_category then
					stagger_armor_category = breed.primary_armor_category

					if not stagger_armor_category then
						stagger_armor_category = breed.armor_category
						stagger_armor_category = stagger_armor_category or 1
					end
				end

				local var_10_30 = ai_hit_by_wavefront[var_10_22]

				var_10_30 = var_10_30 or 0

				if var_10_30 <= arg_10_1 then
					local calculate_stagger, var_10_32 = DamageUtils.calculate_stagger(stagger_impact, stagger_duration, var_10_22, arg_10_5)

					if calculate_stagger > scripts_utils_stagger_types.none then
						local var_10_33 = POSITION_LOOKUP[var_10_22]
						local flag = not push_along_wave_direction and arg_10_6 and Vector3.normalize(var_10_33 - arg_10_2)
						local var_10_35

						if not stagger_distance_table then
							var_10_35 = stagger_distance_table[stagger_armor_category]

							if not var_10_35 then
								-- Nothing
							end
						end

						var_10_35 = stagger_distance

						::label_10_1::

						AiUtils.stagger(var_10_22, var_10_24, arg_10_5, flag, var_10_35, calculate_stagger, var_10_32, nil, arg_10_1)
					end

					ai_hit_by_wavefront[var_10_22] = arg_10_1 + stagger_refresh_time[stagger_armor_category] * (math.random() / 2 + 0.5)

					if not (not apply_impact_buff_to_ai and ScriptUnit.extension(var_10_22, "buff_system"):has_buff_type(buff_wave_impact_impact_type)) then
						buff_system:add_buff_synced(var_10_22, buff_wave_impact_template_name, BuffSyncType.All, self._buff_params)
					end
				end

				if not drag_along_wave then
					local locomotion_extension = var_10_24.locomotion_extension

					if not locomotion_extension then
						local var_10_37

						if not wave_drag_multiplier_table then
							var_10_37 = wave_drag_multiplier_table[stagger_armor_category]

							if not var_10_37 then
								-- Nothing
							end
						end

						var_10_37 = wave_drag_multiplier

						::label_10_2::

						if var_10_37 > 0 then
							locomotion_extension:set_animation_external_velocity(drag_along_wave * var_10_37)
						end
					end
				end
			end
		end

		::label_10_3::
	end
end

DamageWaveExtension.check_overlap = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7)
	-- function 11
	local player_units_inside = self.player_units_inside
	local var_11_1 = POSITION_LOOKUP[arg_11_2]
	local closest_point_on_line = Geometry.closest_point_on_line(var_11_1, arg_11_4, arg_11_5)
	local flat = Vector3.flat(var_11_1 - closest_point_on_line)
	local length_squared = Vector3.length_squared(flat)
	local num = arg_11_3 * arg_11_3
	local var_11_6 = player_units_inside[arg_11_2]
	local extension = ScriptUnit.extension(arg_11_2, "status_system")

	if not var_11_6 then
		var_11_6[self] = true

		if num < length_squared then
			if extension.in_liquid_unit == arg_11_1 then
				StatusUtils.set_in_liquid_network(arg_11_2, false)
			end

			var_11_6[self] = nil

			if not table.is_empty(var_11_6) then
				player_units_inside[arg_11_2] = nil

				if not self.leave_area_func then
					self.leave_area_func(arg_11_2)
				end
			end
		end
	elseif length_squared < num then
		local distance = Vector3.distance(arg_11_4, closest_point_on_line)
		local num_2 = math.floor(0.5 + distance / self.initial_dist * arg_11_7) + 1
		local clamp = math.clamp(num_2, 1, arg_11_7)
		local var_11_11 = self.blobs[clamp][3]
		local buff_template_name = self.buff_template_name
		local buff_template_type = self.buff_template_type
		local extension_2 = ScriptUnit.extension(arg_11_2, "buff_system")

		if arg_11_3 > math.abs(var_11_1.z - var_11_11) then
			if extension.in_liquid_unit ~= arg_11_1 then
				StatusUtils.set_in_liquid_network(arg_11_2, true, arg_11_1)
			end

			if not self.add_buff_func then
				self.add_buff_func(self, arg_11_2, buff_template_name, arg_11_1, self.source_unit)
			else
				arg_11_6:add_buff(arg_11_2, buff_template_name, arg_11_1, false, nil, self.source_unit)
			end

			player_units_inside[arg_11_2] = {}
			player_units_inside[arg_11_2][self] = true
		end
	end
end

DamageWaveExtension.update = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	-- function 12
	if not (HEALTH_ALIVE[self.source_unit] or self.is_launched) then
		self:abort()
	end

	if not self.is_launched then
		return
	end

	local state = self.state
	local var_12_1 = POSITION_LOOKUP[arg_12_1]
	local unbox = self.wave_direction:unbox()

	if state == "running" then
		if not self._update_func then
			self._update_func(self, arg_12_1, var_12_1, arg_12_5, arg_12_3)
		end

		local move_wave, var_12_4, var_12_5 = self:move_wave(arg_12_1, arg_12_5, arg_12_3, self.initial_dist, true)

		if not (Vector3.dot(move_wave, unbox) < 0 or var_12_4 < 0.1 or var_12_5) then
			local overflow_dist = self.overflow_dist

			self.target_pos:store(var_12_1 + unbox * overflow_dist)

			self.last_dist = self.last_dist + overflow_dist
			self.last_fx_dist = self.last_fx_dist + overflow_dist
			self.state = "arrived"
		end

		if not self._running_spawn_configs then
			self:_update_running_spawn_datas(arg_12_5)
		end

		local player_push_data = self.template.player_push_data

		if not player_push_data then
			AiUtils.push_intersecting_players(arg_12_1, self.source_unit, self.displaced_units, player_push_data, arg_12_5, arg_12_3, self.on_hit_by_wave, self)
		end

		self:wavefront_impact(arg_12_5, var_12_1, self.ai_query_distance, self.template.ai_push_data, self.unit, unbox)
	elseif state == "arrived" then
		local move_wave_2, var_12_9 = self:move_wave(arg_12_1, arg_12_5, arg_12_3, self.overflow_dist)

		if not (Vector3.dot(move_wave_2, unbox) < 0 or not (var_12_9 < 0.1)) then
			self:wave_arrived(arg_12_5, arg_12_1)
		end

		local player_push_data_2 = self.template.player_push_data

		if not player_push_data_2 then
			AiUtils.push_intersecting_players(arg_12_1, self.source_unit, self.displaced_units, player_push_data_2, arg_12_5, arg_12_3, self.on_hit_by_wave, self)
		end
	elseif arg_12_5 > self.linger_time then
		Managers.state.unit_spawner:mark_for_deletion(arg_12_1)
	end

	Unit.set_local_rotation(arg_12_1, 0, Quaternion.look(self.wave_direction:unbox()))
	self:update_blob_overlaps()
end

DamageWaveExtension.insert_blob = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	local var_13_0

	if not self.use_nav_cost_map_volumes then
		local ai_system = self.ai_system
		local _nav_cost_map_id = self._nav_cost_map_id

		var_13_0 = ai_system:add_nav_cost_map_sphere_volume(arg_13_1, arg_13_2, _nav_cost_map_id)
	end

	local blobs = self.blobs
	local num_2 = #blobs + 1

	blobs[num_2] = {
		arg_13_1[1],
		arg_13_1[2],
		arg_13_1[3],
		arg_13_2,
		{},
		var_13_0,
		num_2
	}

	local rim_nodes = self.rim_nodes
	local num_3 = arg_13_2 + num
	local right = Quaternion.right(arg_13_3)
	local num_4 = arg_13_1 + right * num_3
	local triangle_from_position, var_13_10 = GwNavQueries.triangle_from_position(arg_13_4, num_4, 1.5, 1.5)

	if not triangle_from_position then
		num_4.z = var_13_10
		rim_nodes[#rim_nodes + 1] = Vector3Box(num_4)
	end

	local num_5 = arg_13_1 + -right * num_3
	local triangle_from_position_2, var_13_13 = GwNavQueries.triangle_from_position(arg_13_4, num_5, 1.5, 1.5)

	if not triangle_from_position_2 then
		num_5.z = var_13_13
		rim_nodes[#rim_nodes + 1] = Vector3Box(num_5)
	end

	if num_2 == 1 then
		local num_6 = arg_13_1 + -Quaternion.forward(arg_13_3) * num_3
		local triangle_from_position_3, var_13_16 = GwNavQueries.triangle_from_position(arg_13_4, num_6, 1.5, 1.5)

		if not triangle_from_position_3 then
			num_6.z = var_13_16
			rim_nodes[#rim_nodes + 1] = Vector3Box(num_6)
		end
	end
end

DamageWaveExtension.insert_fx = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	local var_14_0
	local var_14_1
	local var_14_2

	if arg_14_3 == 0 then
		var_14_2 = 0
		var_14_1 = self.fx_name_filled
	else
		var_14_0 = self._running_spawn_configs[arg_14_3]

		local var_14_3 = self._running_spawn_datas[arg_14_3]
		local names = var_14_0.names

		var_14_3.next_seed, var_14_2 = Math.next_random(var_14_3.next_seed, 1, #names)
		var_14_1 = names[var_14_2]
	end

	local var_14_5

	if not (arg_14_3 == 0 or var_14_0.spawn_type ~= "effect") then
		var_14_5 = World.create_particles(self.world, var_14_1, arg_14_1, arg_14_2, Vector3(0.1, 0.1, 0.1))

		local fx_list = self.fx_list

		fx_list[#fx_list + 1] = {
			id = var_14_5,
			position = Vector3Box(arg_14_1),
			rotation = QuaternionBox(arg_14_2),
			index = arg_14_3,
			name_index = var_14_2
		}
	elseif var_14_0.spawn_type == "unit" then
		var_14_5 = World.spawn_unit(self.world, var_14_1, arg_14_1, arg_14_2)
		self._local_units[#self._local_units + 1] = var_14_5
	end

	if not (arg_14_3 > 0) or not var_14_0.on_spawn then
		var_14_0.on_spawn(self, var_14_0, var_14_1, var_14_5, self.world)
	end

	local unit_id = self.unit_id

	if not unit_id then
		self.network_transmit:send_rpc_clients("rpc_add_damage_wave_fx", unit_id, arg_14_1, arg_14_2, arg_14_3, var_14_2)
	end
end

DamageWaveExtension.update_blob_overlaps = function (self)
	-- function 15
	local blobs = self.blobs
	local count = #blobs

	if count < 1 then
		return
	end

	local unit = self.unit
	local source_unit = self.source_unit
	local buff_system = self.buff_system
	local var_15_5 = blobs[1]
	local var_15_6 = blobs[count]
	local var_15_7 = Vector3(var_15_5[1], var_15_5[2], var_15_5[3])
	local var_15_8 = Vector3(var_15_6[1], var_15_6[2], var_15_6[3])

	if not self.apply_buff_to_player then
		local ENEMY_PLAYER_AND_BOT_UNITS = self._source_side.ENEMY_PLAYER_AND_BOT_UNITS
		local player_query_distance = self.player_query_distance

		for i = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
			local var_15_11 = ENEMY_PLAYER_AND_BOT_UNITS[i]
			local has_extension = ScriptUnit.has_extension(var_15_11, "ghost_mode_system")

			if not (not has_extension and not has_extension:is_in_ghost_mode()) then
				self:check_overlap(unit, var_15_11, player_query_distance, var_15_7, var_15_8, buff_system, count)
			end
		end
	end

	if not self.apply_buff_to_owner and not ALIVE[self.source_unit] then
		local player_query_distance_2 = self.player_query_distance

		self:check_overlap(unit, self.source_unit, player_query_distance_2, var_15_7, var_15_8, buff_system, count)
	end

	if not self.apply_buff_to_ai then
		return
	end

	local num = 1
	local ai_blob_index = self.ai_blob_index
	local min = math.min(num, count)
	local buff_template_name = self.buff_template_name
	local immune_breeds = self.immune_breeds
	local ai_units_inside = self.ai_units_inside
	local BLACKBOARDS = BLACKBOARDS
	local _source_side = self._source_side
	local enemy_broadphase_categories

	if not (not _source_side and self.damage_friendly_ai) then
		enemy_broadphase_categories = _source_side.enemy_broadphase_categories

		if not enemy_broadphase_categories then
			-- Nothing
		end
	end

	enemy_broadphase_categories = nil

	::label_15_0::

	local alloc_table = FrameTable.alloc_table()
	local alloc_table_2 = FrameTable.alloc_table()

	while min > 0 do
		local var_15_25 = blobs[ai_blob_index]
		local var_15_26 = Vector3(var_15_25[1], var_15_25[2], var_15_25[3])
		local var_15_27 = var_15_25[4]
		local var_15_28 = var_15_25[5]
		local broadphase_query = AiUtils.broadphase_query(var_15_26, var_15_27, alloc_table, enemy_broadphase_categories)

		for j = 1, broadphase_query do
			local var_15_30 = alloc_table[j]
			local flag = alloc_table_2[var_15_30] ~= nil
			local var_15_32 = ai_units_inside[var_15_30]

			if flag or not HEALTH_ALIVE[var_15_30] then
				local var_15_33 = POSITION_LOOKUP[var_15_30]
				local closest_point_on_line = Geometry.closest_point_on_line(var_15_33, var_15_7, var_15_8)

				if Vector3.distance_squared(var_15_33, closest_point_on_line) < var_15_27 * var_15_27 then
					if not immune_breeds[BLACKBOARDS[var_15_30].breed.name] then
						if not (not buff_template_name and var_15_32) then
							if not self.add_buff_func then
								self.add_buff_func(self, var_15_30, buff_template_name, unit, source_unit)
							else
								buff_system:add_buff(var_15_30, buff_template_name, unit, false, nil, source_unit)
							end
						elseif not (not var_15_32 and var_15_32 == var_15_25) then
							var_15_32[5][var_15_30] = nil
							var_15_28[var_15_30] = true
						end

						ai_units_inside[var_15_30] = var_15_25
						alloc_table_2[var_15_30] = true
					end
				elseif not ai_units_inside[var_15_30] then
					if not self.leave_area_func then
						self.leave_area_func(var_15_30)
					end

					alloc_table_2[var_15_30] = false
					ai_units_inside[var_15_30] = nil
					var_15_28[var_15_30] = nil
				end
			end
		end

		for k, v in pairs(var_15_28) do
			if not HEALTH_ALIVE[k] then
				var_15_28[k] = nil
				ai_units_inside[k] = nil
			elseif not alloc_table_2[k] then
				local var_15_35 = POSITION_LOOKUP[k]
				local var_15_36 = var_15_25[7]
				local closest_point_on_line_2 = Geometry.closest_point_on_line(var_15_35, var_15_7, var_15_8)
				local distance_squared = Vector3.distance_squared(var_15_35, closest_point_on_line_2)
				local distance = Vector3.distance(var_15_7, closest_point_on_line_2)
				local num_2 = math.floor(distance / self.blob_separation_dist + 0.5) + 1
				local clamp = math.clamp(num_2, 1, count)
				local var_15_42 = blobs[clamp]
				local var_15_43 = var_15_42[4]
				local flag_2 = clamp == var_15_36

				if distance_squared > var_15_43 * var_15_43 then
					ai_units_inside[k] = nil
					var_15_28[k] = nil

					if not self.leave_area_func then
						self.leave_area_func(k)
					end
				elseif not flag_2 then
					var_15_42[5][k] = var_15_28[k]
					ai_units_inside[k] = var_15_42
					var_15_28[k] = nil
				end
			end
		end

		ai_blob_index = ai_blob_index + 1

		if count < ai_blob_index then
			ai_blob_index = 1
		end

		min = min - 1
	end

	self.ai_blob_index = ai_blob_index
end

DamageWaveExtension.get_rim_nodes = function (self)
	-- function 16
	return self.rim_nodes, true
end

DamageWaveExtension.is_position_inside = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	local blobs = self.blobs
	local count = #blobs

	if count == 0 then
		return false
	end

	local nav_cost_map_cost_type = self.template.nav_cost_map_cost_type

	if not ((nav_cost_map_cost_type == nil or not arg_17_2) and arg_17_2[nav_cost_map_cost_type] ~= 1) then
		return false
	end

	local var_17_3 = blobs[1]
	local var_17_4 = blobs[count]
	local var_17_5 = Vector3(var_17_3[1], var_17_3[2], var_17_3[3])
	local var_17_6 = Vector3(var_17_4[1], var_17_4[2], var_17_4[3])
	local closest_point_on_line = Geometry.closest_point_on_line(arg_17_1, var_17_5, var_17_6)
	local distance_squared = Vector3.distance_squared(arg_17_1, closest_point_on_line)
	local player_query_distance

	if not arg_17_3 then
		player_query_distance = self.player_query_distance

		if not player_query_distance then
			-- Nothing
		end
	end

	player_query_distance = self.ai_query_distance

	::label_17_0::

	return distance_squared <= player_query_distance * player_query_distance
end

DamageWaveExtension.is_position_inside_blob = function (arg_18_0, arg_18_1, arg_18_2)
	-- function 18
	local var_18_0 = Vector3(arg_18_2[1], arg_18_2[2], arg_18_2[3])
	local distance_squared = Vector3.distance_squared(arg_18_1, var_18_0)
	local var_18_2 = arg_18_2[4]

	return distance_squared < var_18_2 * var_18_2
end

DamageWaveExtension.hot_join_sync = function (self, arg_19_1)
	-- function 19
	if not self.is_launched then
		local network_transmit = self.network_transmit
		local unit_id = self.unit_id
		local fx_list = self.fx_list
		local count = #fx_list

		for i = 1, count do
			local var_19_4 = fx_list[i]
			local unbox = var_19_4.position:unbox()
			local unbox_2 = var_19_4.rotation:unbox()
			local index = var_19_4.index
			local name_index = var_19_4.name_index

			network_transmit:send_rpc("rpc_add_damage_wave_fx", arg_19_1, unit_id, unbox, unbox_2, index, name_index)
		end

		if self.state == "lingering" then
			network_transmit:send_rpc("rpc_damage_wave_set_state", arg_19_1, unit_id, NetworkLookup.damage_wave_states.hide)
		else
			network_transmit:send_rpc("rpc_damage_wave_set_state", arg_19_1, unit_id, NetworkLookup.damage_wave_states.running)
		end
	end
end

local num_2 = 20
local num_3 = num_2 / 2
local num_4 = 1

DamageWaveExtension.debug_render_wave = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	-- function 20
	local num = 0

	for i = -num_3, num_3 - 1 do
		local num_5 = math.sin(-math.pi + num / num_2 * math.pi) * self.max_height
		local num_6 = arg_20_3 + arg_20_4 * (i / num_2) * num_4 - num_5 * Vector3(0, 0, 1) - Vector3(0, 0, arg_20_5 * 2)

		QuickDrawer:circle(num_6, self.max_height, arg_20_4, Colors.get("lime_green"))

		num = num + 1
	end
end

DamageWaveExtension.debug_render_blobs = function (self)
	-- function 21
	local blobs = self.blobs

	for i = 1, #blobs do
		local var_21_1 = blobs[i]
		local var_21_2 = Vector3(var_21_1[1], var_21_1[2], var_21_1[3])
		local var_21_3 = var_21_1[4]

		QuickDrawer:circle(var_21_2, var_21_3, Vector3(0, 0, 1), Color(255, 146, 60))

		local var_21_4 = var_21_1[5]

		for k, v in pairs(var_21_4) do
			if not ALIVE[k] then
				local var_21_5 = POSITION_LOOKUP[k]

				QuickDrawer:sphere(var_21_5, 0.5, Color(70, 146, 60))
				QuickDrawer:line(var_21_5, var_21_2, Color(70, 146, 60))
			end
		end
	end

	local rim_nodes = self.rim_nodes

	for l = 1, #rim_nodes do
		local unbox = rim_nodes[l]:unbox()

		QuickDrawer:sphere(unbox, 0.05)
	end

	local player_units_inside = self.player_units_inside

	for k_2, v_2 in pairs(player_units_inside) do
		if not alive(k_2) then
			local var_21_9 = POSITION_LOOKUP[k_2]

			QuickDrawer:sphere(var_21_9, 0.3, Color(255, 0, 60))
		end
	end
end

DamageWaveExtension._update_running_spawn_datas = function (self, arg_22_1)
	-- function 22
	local _running_spawn_configs = self._running_spawn_configs
	local _running_spawn_datas = self._running_spawn_datas
	local unit = self.unit
	local var_22_3 = POSITION_LOOKUP[unit]
	local look = Quaternion.look(self.wave_direction:unbox())

	for i = 1, #_running_spawn_configs do
		local var_22_5 = _running_spawn_configs[i]
		local var_22_6 = _running_spawn_datas[i]

		if arg_22_1 > var_22_6.next_spawn_t then
			local next_seed = var_22_6.next_seed

			next_seed = next_seed or Managers.state.unit_storage:go_id(unit) + i
			var_22_6.next_seed = next_seed
			var_22_6.next_spawn_t = var_22_6.next_spawn_t + var_22_5.frequency

			local var_22_8 = look
			local max_random_angle = var_22_5.max_random_angle

			if not (not max_random_angle and not (max_random_angle > 0)) then
				local up = Quaternion.up(look)

				var_22_8 = Quaternion.multiply(var_22_8, Quaternion.axis_angle(up, math.random(-max_random_angle, max_random_angle)))
			end

			local var_22_11

			if var_22_5.separation_type == "box" then
				local bounds = var_22_5.bounds
				local from_quaternion_position = Matrix4x4.from_quaternion_position(look, var_22_3)

				var_22_6.next_seed, var_22_11 = math.get_random_point_inside_box_seeded(var_22_6.next_seed, from_quaternion_position, bounds)

				local offset = var_22_5.offset

				var_22_11 = var_22_11 + Quaternion.rotate(look, Vector3(offset[1], offset[2], offset[3]))
			end

			self:insert_fx(var_22_11, var_22_8, i)
		end
	end
end
