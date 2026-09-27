-- chunkname: @scripts/unit_extensions/weapons/area_damage/liquid/liquid_area_damage_extension.lua

require("scripts/unit_extensions/weapons/area_damage/liquid/hex_grid")
require("scripts/managers/debug/debug_manager")

LiquidAreaDamageExtension = class(LiquidAreaDamageExtension)

local function fn(...)
	-- function 1
	if not script_data.debug_liquid_system then
		print("[LiquidSystem]:", ...)
	end
end

LiquidAreaDamageExtension.init = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local entity_manager = arg_2_1.entity_manager
	local system = entity_manager:system("ai_system")
	local world = arg_2_1.world

	self._world = world
	self._unit = arg_2_2
	self._network_transmit = arg_2_1.network_transmit
	self._ai_system = system
	self._nav_world = system:nav_world()
	self._audio_system = entity_manager:system("audio_system")

	local liquid_template = arg_2_3.liquid_template
	local var_2_4 = LiquidAreaDamageTemplates.templates[liquid_template]

	self._liquid_area_damage_template = liquid_template

	local world_position = Unit.world_position(arg_2_2, 0)
	local above = var_2_4.above
	local below = var_2_4.below
	local _find_point = self:_find_point(world_position, above, below)

	_find_point = _find_point or world_position

	local cell_size = var_2_4.cell_size
	local max_liquid = arg_2_3.max_liquid

	if not max_liquid then
		max_liquid = var_2_4.max_liquid
		max_liquid = max_liquid or 50
	end

	local min = math.min(max_liquid + 10, 50)

	self._grid = HexGrid:new(_find_point, min, 10, cell_size, 1)

	local time = Managers.time:time("game")
	local delay = var_2_4.delay

	delay = delay or 0
	self._next_pulse = time + delay
	self._time_to_start = time + delay
	self._time_to_remove = time + var_2_4.time_of_life + delay
	self._spread_function = LiquidAreaDamageTemplates[var_2_4.liquid_spread_function]
	self._buff_system = entity_manager:system("buff_system")
	self._flow = {}
	self._active_flow = {}
	self._inactive_flow = {}
	self._num_liquid = 0
	self._max_liquid = max_liquid

	local starting_pressure = var_2_4.starting_pressure

	starting_pressure = starting_pressure or 5
	self._starting_pressure = starting_pressure

	local end_pressure = var_2_4.end_pressure

	end_pressure = end_pressure or 0.5
	self._end_pressure = end_pressure
	self._spawned_unit_index = 1
	self._cell_radius = cell_size / 2
	self._do_direct_damage_ai = var_2_4.do_direct_damage_ai
	self._do_direct_damage_player = var_2_4.do_direct_damage_player
	self._hit_player_function = var_2_4.hit_player_function

	local get_difficulty = Managers.state.difficulty:get_difficulty()
	local damage_table = arg_2_3.damage_table

	damage_table = damage_table or var_2_4.difficulty_direct_damage[get_difficulty]
	self._damage_table = damage_table
	self._damage_type = var_2_4.damage_type

	local use_nav_cost_map_volumes = var_2_4.use_nav_cost_map_volumes

	self._use_nav_cost_map_volumes = use_nav_cost_map_volumes
	self._apply_buff_to_ai = var_2_4.apply_buff_to_ai
	self._apply_buff_to_player = var_2_4.apply_buff_to_player
	self._buff_name = var_2_4.buff_template_name
	self._buff_type = var_2_4.buff_template_type
	self._damage_buff_name = var_2_4.damage_buff_template_name
	self._fx_name_rim = var_2_4.fx_name_rim
	self._fx_name_filled = var_2_4.fx_name_filled
	self._fx_name_start_delayed = var_2_4.fx_name_start_delayed
	self._override_fx_life_time = var_2_4.override_fx_life_time

	Unit.set_unit_visibility(arg_2_2, false)

	local sfx_name_start = var_2_4.sfx_name_start

	self._sfx_name_start = sfx_name_start
	self._sfx_name_start_delayed = var_2_4.sfx_name_start_delayed
	self._sfx_name_stop = var_2_4.sfx_name_stop

	local flat = Vector3.flat(arg_2_3.flow_dir)

	self._starting_flow_angle, self._flow_dir = math.atan2(flat.y, flat.x), Vector3Box(flat)
	self._linearized_flow = var_2_4.linearized_flow
	self._immune_breeds = var_2_4.immune_breeds
	self._colliding_units = {}
	self._buff_affected_units = {}
	self._affected_player_units = {}

	local source_unit = arg_2_3.source_unit

	source_unit = source_unit or arg_2_2
	self._source_attacker_unit = source_unit
	self._done = false
	self._started = delay <= 0

	local _source_attacker_unit = self._source_attacker_unit

	if not Managers.player:owner(_source_attacker_unit) then
		local has_extension = ScriptUnit.has_extension(_source_attacker_unit, "buff_system")

		if not has_extension then
			self.buff_damage_multiplier = has_extension:apply_buffs_to_value(1, "damage_dealt")
		end
	end

	if not use_nav_cost_map_volumes then
		local nav_cost_map_cost_type = var_2_4.nav_cost_map_cost_type
		local _max_liquid = self._max_liquid

		self._nav_cost_map_cost_type = nav_cost_map_cost_type
		self._nav_cost_map_id = system:create_nav_cost_map(nav_cost_map_cost_type, _max_liquid)
	end

	local init_function = var_2_4.init_function

	if not init_function then
		LiquidAreaDamageTemplates[init_function](self, time)
	end

	local update_function = var_2_4.update_function

	if not update_function then
		self._liquid_update_function = LiquidAreaDamageTemplates[update_function]
	end

	local buff_condition_function = var_2_4.buff_condition_function

	if not buff_condition_function then
		self._buff_condition = LiquidAreaDamageTemplates[buff_condition_function]
	end

	if not sfx_name_start then
		WwiseUtils.trigger_unit_event(world, sfx_name_start, arg_2_2, 0)
	end
end

LiquidAreaDamageExtension.ready = function (self)
	-- function 3
	local _unit = self._unit

	self._unit_id = Managers.state.unit_storage:go_id(_unit)

	local local_position = Unit.local_position(_unit, 0)
	local _grid = self._grid
	local find_index, var_3_4, var_3_5 = _grid:find_index(local_position)

	fn("CREATING LIQUID AT: ", find_index, var_3_4, var_3_5)

	local real_index = _grid:real_index(find_index, var_3_4, var_3_5)
	local ijk, var_3_8, var_3_9 = _grid:ijk(real_index)

	fassert(ijk ~= find_index or var_3_8 ~= var_3_4 or var_3_9 == var_3_5, "FAIL, %i:%i %i:%i %i:%i", find_index, ijk, var_3_4, var_3_8, var_3_5, var_3_9)

	local find_position = _grid:find_position(find_index, var_3_4, var_3_5)
	local distance_squared = Vector3.distance_squared(local_position, find_position)

	fassert(distance_squared < 1, "FAIL test_pos %s and pos %s too far apart %q", tostring(find_position), tostring(local_position), distance_squared)

	local _starting_flow_angle = self._starting_flow_angle

	self:_create_liquid(real_index, _starting_flow_angle)
	self:_set_active(real_index)

	self._damage_direction = self._flow_dir
end

local num = 1 / (math.sqrt(3) * 0.5)

LiquidAreaDamageExtension._set_active = function (self, arg_4_1)
	-- function 4
	local _flow = self._flow
	local var_4_1 = _flow[arg_4_1]
	local unbox = var_4_1.position:unbox()

	var_4_1.full = true
	var_4_1.amount = 1

	if not var_4_1.fx_id then
		World.stop_spawning_particles(self._world, var_4_1.fx_id)
	end

	local _fx_name_filled = self._fx_name_filled

	if script_data.debug_liquid_system or not _fx_name_filled then
		local unbox_2 = var_4_1.rotation:unbox()

		var_4_1.fx_id = World.create_particles(self._world, _fx_name_filled, unbox, unbox_2)

		local _override_fx_life_time = self._override_fx_life_time

		if not _override_fx_life_time then
			World.set_particles_life_time(self._world, var_4_1.fx_id, _override_fx_life_time)
		end
	else
		var_4_1.fx_id = nil
	end

	self._network_transmit:send_rpc_clients("rpc_update_liquid_damage_blob", self._unit_id, arg_4_1, NetworkLookup.liquid_damage_blob_states.filled)

	self._active_flow[arg_4_1] = var_4_1
	self._inactive_flow[arg_4_1] = nil
	self._num_liquid = self._num_liquid + 1

	local str = "LiquidAreaDamageExtension"

	if self._do_direct_damage_player or not self._apply_buff_to_player then
		local system = Managers.state.entity:system("ai_bot_group_system")
		local num_2 = self._cell_radius * num

		var_4_1.threat = system:aoe_threat_created(unbox, "sphere", num_2, nil, math.huge, str)
	end

	if not self._use_nav_cost_map_volumes then
		local _ai_system = self._ai_system
		local _nav_cost_map_id = self._nav_cost_map_id

		var_4_1.nav_cost_map_volume_id = _ai_system:add_nav_cost_map_sphere_volume(unbox, self._cell_radius, _nav_cost_map_id)
	end

	for k, v in pairs(var_4_1.neighbours) do
		if not _flow[v] then
			self:_create_liquid(v, var_4_1.angle)
		end
	end
end

LiquidAreaDamageExtension.stop_fx = function (self)
	-- function 5
	if not script_data.debug_liquid_system then
		self._fx_stopped = true
	else
		for k, v in pairs(self._flow) do
			if not v.fx_id then
				World.stop_spawning_particles(self._world, v.fx_id)
			end
		end
	end
end

LiquidAreaDamageExtension._create_liquid = function (self, arg_6_1, arg_6_2)
	-- function 6
	local _grid = self._grid
	local ijk, var_6_2, var_6_3 = _grid:ijk(arg_6_1)
	local find_position = _grid:find_position(ijk, var_6_2, var_6_3)
	local _nav_world = self._nav_world
	local directions = _grid:directions()
	local triangle_from_position, var_6_8, var_6_9, var_6_10, var_6_11 = GwNavQueries.triangle_from_position(_nav_world, find_position, 2, 2)
	local var_6_12
	local var_6_13

	if not triangle_from_position then
		local normalize = Vector3.normalize(var_6_10 - var_6_9)
		local normalize_2 = Vector3.normalize(var_6_11 - var_6_9)
		local normalize_3 = Vector3.normalize(Vector3.cross(normalize, normalize_2))

		var_6_13 = Quaternion.look(normalize, normalize_3)
		var_6_12 = Vector3(find_position.x, find_position.y, var_6_8)
	else
		var_6_13 = Quaternion.identity()
		var_6_12 = find_position
	end

	local tbl = {}

	for i = 1, #directions do
		local var_6_18 = directions[i]
		local num = ijk + var_6_18[1]
		local num_2 = var_6_2 + var_6_18[2]
		local var_6_21 = var_6_3
		local find_position_2 = _grid:find_position(num, num_2, var_6_21)
		local _find_point = self:_find_point(find_position_2)

		if not _find_point and not GwNavQueries.raycango(_nav_world, var_6_12, _find_point) then
			tbl[i] = _grid:real_index(_grid:find_index(_find_point))
		end
	end

	local var_6_24
	local _fx_name_rim = self._fx_name_rim

	if script_data.debug_liquid_system or not _fx_name_rim then
		var_6_24 = World.create_particles(self._world, _fx_name_rim, var_6_12, var_6_13)

		local _override_fx_life_time = self._override_fx_life_time

		if not _override_fx_life_time then
			World.set_particles_life_time(self._world, var_6_24, _override_fx_life_time)
		end
	end

	local flag = false

	self._network_transmit:send_rpc_clients("rpc_add_liquid_damage_blob", self._unit_id, arg_6_1, var_6_12, flag)

	local tbl_2 = {
		full = false,
		amount = 0,
		neighbours = tbl,
		position = Vector3Box(var_6_12),
		rotation = QuaternionBox(var_6_13),
		fx_id = var_6_24,
		angle = arg_6_2 or 0
	}

	self._flow[arg_6_1] = tbl_2
	self._inactive_flow[arg_6_1] = tbl_2
end

LiquidAreaDamageExtension._find_point = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local _nav_world = self._nav_world
	local triangle_from_position, var_7_2 = GwNavQueries.triangle_from_position(_nav_world, arg_7_1, arg_7_2 or 2, arg_7_3 or 2)

	if not triangle_from_position then
		return Vector3(arg_7_1.x, arg_7_1.y, var_7_2)
	else
		local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position(_nav_world, arg_7_1, arg_7_2 or 2, arg_7_3 or 2, 2, 0.5)

		if not inside_position_from_outside_position then
			return inside_position_from_outside_position
		end

		return nil
	end
end

LiquidAreaDamageExtension.destroy = function (self)
	-- function 8
	local _unit = self._unit
	local _sfx_name_stop = self._sfx_name_stop

	if not _sfx_name_stop then
		local _world = self._world

		WwiseUtils.trigger_unit_event(_world, _sfx_name_stop, _unit, 0)
	end

	for k, v in pairs(self._buff_affected_units) do
		if not Unit.alive(k) then
			self._buff_system:remove_server_controlled_buff(k, v)
		end

		self._buff_affected_units[k] = nil
	end

	local sides = Managers.state.side:sides()

	for k_2 = 1, #sides do
		local PLAYER_AND_BOT_UNITS = sides[k_2].PLAYER_AND_BOT_UNITS
		local count = #PLAYER_AND_BOT_UNITS

		for l = 1, count do
			local var_8_6 = PLAYER_AND_BOT_UNITS[l]

			if not Unit.alive(var_8_6) then
				local var_8_7 = self._colliding_units[var_8_6]
				local flag = not var_8_7 and ScriptUnit.extension(var_8_6, "status_system")

				if not (not var_8_7 and flag.in_liquid_unit ~= _unit) then
					StatusUtils.set_in_liquid_network(var_8_6, false)
				end
			end

			self._colliding_units[var_8_6] = nil
		end
	end

	if not self._use_nav_cost_map_volumes then
		local _ai_system = self._ai_system
		local _nav_cost_map_id = self._nav_cost_map_id

		for k_3, v_2 in pairs(self._flow) do
			local nav_cost_map_volume_id = v_2.nav_cost_map_volume_id

			if not nav_cost_map_volume_id then
				_ai_system:remove_nav_cost_map_volume(nav_cost_map_volume_id, _nav_cost_map_id)
			end
		end

		_ai_system:destroy_nav_cost_map(_nav_cost_map_id)
	end

	for k_4, v_3 in pairs(self._flow) do
		local threat = v_3.threat

		if not threat then
			Managers.state.entity:system("ai_bot_group_system"):remove_threat(threat)
		end
	end

	table.clear(self._affected_player_units)
	self:stop_fx()
end

local tbl = {}
local tbl_2 = {}
local tbl_3 = {
	{
		index = 0,
		weight = 0,
		angle = 0
	},
	{
		index = 0,
		weight = 0,
		angle = 0
	},
	{
		index = 0,
		weight = 0,
		angle = 0
	},
	{
		index = 0,
		weight = 0,
		angle = 0
	},
	{
		index = 0,
		weight = 0,
		angle = 0
	},
	{
		index = 0,
		weight = 0,
		angle = 0
	}
}

LiquidAreaDamageExtension.update = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	-- function 9
	local num = 1 - self._num_liquid / self._max_liquid
	local lerp = math.lerp(self._end_pressure, self._starting_pressure, num)
	local _active_flow = self._active_flow
	local _flow = self._flow

	table.clear(tbl)
	table.clear(tbl_2)

	if not self._started then
		if arg_9_5 < self._time_to_start then
			return
		end

		self._started = true

		if not self._sfx_name_start_delayed then
			WwiseUtils.trigger_unit_event(self._world, self._sfx_name_start_delayed, self._unit, 0)
		end

		if not self._fx_name_start_delayed then
			local world_position = Unit.world_position(arg_9_1, 0)
			local world_rotation = Unit.world_rotation(arg_9_1, 0)

			World.create_particles(self._world, self._fx_name_start_delayed, world_position, world_rotation)
		end
	end

	if arg_9_5 > self._time_to_remove then
		Managers.state.unit_spawner:mark_for_deletion(self._unit)

		return
	end

	if not self._done then
		local _spread_function = self._spread_function
		local directions = self._grid:directions()
		local num_2 = 2 * math.pi

		for k, v in pairs(self._active_flow) do
			local flag = true
			local num_3 = 0
			local num_4 = 0
			local angle = v.angle

			for k_2, v_2 in pairs(v.neighbours) do
				local var_9_13 = _flow[v_2]
				local angle_2 = directions[k_2].angle
				local var_9_15
				local var_9_16

				if angle < angle_2 then
					var_9_15 = angle_2 - angle
					var_9_16 = num_2 - angle_2 + angle
				else
					var_9_15 = num_2 - angle + angle_2
					var_9_16 = angle - angle_2
				end

				local var_9_17

				if var_9_15 < var_9_16 then
					var_9_17 = var_9_15
				else
					var_9_17 = -var_9_16
				end

				local var_9_18 = _spread_function(math.abs(var_9_17))

				num_4 = num_4 + var_9_18

				if not (_active_flow[v_2] or var_9_13.full or not (var_9_18 > 0)) then
					num_3 = num_3 + 1

					local var_9_19 = tbl_3[num_3]

					var_9_19.index = v_2
					var_9_19.weight = var_9_18
					var_9_19.angle = angle_2
					var_9_19.relative_angle = var_9_17
				end
			end

			local _starting_flow_angle = self._starting_flow_angle
			local _linearized_flow = self._linearized_flow

			for i4 = 1, num_3 do
				local var_9_22 = tbl_3[i4]
				local index = var_9_22.index
				local weight = var_9_22.weight
				local var_9_25 = _flow[index]
				local num_5 = weight / num_4
				local num_6 = arg_9_3 * lerp * num_5
				local amount = var_9_25.amount
				local num_7 = num_6 + amount

				fassert(num_6 > 0)
				fassert(num_7 > 0)
				fassert(amount >= 0)

				if not _linearized_flow then
					var_9_25.angle = _starting_flow_angle - var_9_22.relative_angle
					var_9_25.amount = num_7
				else
					var_9_25.amount = num_7
				end

				if var_9_25.amount >= 1 then
					tbl_2[index] = true
				end

				flag = false
			end

			if not flag then
				tbl[k] = true
			end
		end

		for k_3, v_3 in pairs(tbl) do
			_active_flow[k_3] = nil
		end

		for k_4, v_4 in pairs(tbl_2) do
			self:_set_active(k_4)

			if self._num_liquid == self._max_liquid then
				self._done = true

				break
			end
		end
	end

	self:_update_collision_detection(arg_9_3, arg_9_5)

	while arg_9_5 > self._next_pulse do
		self._next_pulse = self._next_pulse + 0.75

		self:_pulse_damage()
	end

	if not (not self._liquid_update_function and self._liquid_update_function(self, arg_9_5, arg_9_3)) then
		self._liquid_update_function = nil
	end
end

LiquidAreaDamageExtension._add_buff_helper_function = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	-- function 10
	local var_10_0

	if not arg_10_4 then
		var_10_0 = arg_10_4(arg_10_1)
	else
		var_10_0 = true
	end

	if self._buff_affected_units[arg_10_1] == nil then
		if not var_10_0 then
			self._buff_affected_units[arg_10_1] = arg_10_5:add_buff(arg_10_1, arg_10_3, arg_10_2, true)
		end
	elseif not var_10_0 then
		local var_10_1 = self._buff_affected_units[arg_10_1]

		arg_10_5:remove_server_controlled_buff(arg_10_1, var_10_1)

		self._buff_affected_units[arg_10_1] = nil
	end
end

local num_2 = 10

LiquidAreaDamageExtension._update_collision_detection = function (self, arg_11_1, arg_11_2)
	-- function 11
	local var_11_0 = num_2
	local _grid = self._grid
	local _unit = self._unit
	local _apply_buff_to_player = self._apply_buff_to_player
	local _do_direct_damage_player = self._do_direct_damage_player

	self._check_player_units = _apply_buff_to_player or not _do_direct_damage_player or self._check_player_units

	local _buff_system = self._buff_system
	local _buff_name = self._buff_name
	local _buff_type = self._buff_type
	local _buff_condition = self._buff_condition
	local _immune_breeds = self._immune_breeds

	if not self._check_player_units then
		local sides = Managers.state.side:sides()

		for i = 1, #sides do
			local PLAYER_AND_BOT_UNITS = sides[i].PLAYER_AND_BOT_UNITS
			local count = #PLAYER_AND_BOT_UNITS

			for j = 1, count do
				local var_11_13 = PLAYER_AND_BOT_UNITS[j]
				local get_data = Unit.get_data(var_11_13, "breed")

				if not (not get_data and _immune_breeds[get_data.name]) then
					local extension = ScriptUnit.extension(var_11_13, "status_system")

					if not self:_is_unit_colliding(_grid, var_11_13) then
						self._colliding_units[var_11_13] = 4

						if extension.in_liquid_unit ~= _unit then
							StatusUtils.set_in_liquid_network(var_11_13, true, _unit)
						end

						if self._affected_player_units[var_11_13] or not self._hit_player_function then
							self._affected_player_units[var_11_13] = true

							self._hit_player_function(var_11_13, PLAYER_AND_BOT_UNITS, self._source_attacker_unit)
						end

						local extension_2 = ScriptUnit.extension(var_11_13, "buff_system")

						if not (not _buff_name and not _apply_buff_to_player and extension_2:has_buff_type(_buff_type)) then
							self:_add_buff_helper_function(var_11_13, _unit, _buff_name, _buff_condition, _buff_system)
						end
					else
						self._colliding_units[var_11_13] = nil

						if extension.in_liquid_unit == _unit then
							StatusUtils.set_in_liquid_network(var_11_13, false)
						end

						if not _buff_name and not self._buff_affected_units[var_11_13] then
							local var_11_17 = self._buff_affected_units[var_11_13]

							_buff_system:remove_server_controlled_buff(var_11_13, var_11_17)

							self._buff_affected_units[var_11_13] = nil
						end
					end
				end
			end

			self._check_player_units = false
			var_11_0 = var_11_0 - count
		end
	end

	local all_spawned_units, var_11_19 = Managers.state.conflict:all_spawned_units()
	local _spawned_unit_index = self._spawned_unit_index
	local min = math.min(_spawned_unit_index + var_11_0, var_11_19)
	local _apply_buff_to_ai = self._apply_buff_to_ai
	local BLACKBOARDS = BLACKBOARDS

	while _spawned_unit_index <= min do
		local var_11_24 = all_spawned_units[_spawned_unit_index]
		local breed = BLACKBOARDS[var_11_24].breed

		if not (not breed and _immune_breeds[breed.name]) then
			if not self:_is_unit_colliding(_grid, var_11_24) then
				local _colliding_units = self._colliding_units
				local armor_category = breed.armor_category

				armor_category = armor_category or 1
				_colliding_units[var_11_24] = armor_category

				local has_extension = ScriptUnit.has_extension(var_11_24, "buff_system")

				if not (not _buff_name and not _apply_buff_to_ai and not has_extension and has_extension:has_buff_type(_buff_type)) then
					self:_add_buff_helper_function(var_11_24, _unit, _buff_name, _buff_condition, _buff_system)
				end
			else
				self._colliding_units[var_11_24] = nil

				if not _buff_name and not self._buff_affected_units[var_11_24] then
					local var_11_29 = self._buff_affected_units[var_11_24]

					_buff_system:remove_server_controlled_buff(var_11_24, var_11_29)

					self._buff_affected_units[var_11_24] = nil
				end
			end
		end

		_spawned_unit_index = _spawned_unit_index + 1
	end

	if var_11_19 < _spawned_unit_index then
		self._spawned_unit_index = 1
		self._check_player_units = true
	else
		self._spawned_unit_index = _spawned_unit_index
	end
end

LiquidAreaDamageExtension._is_unit_colliding = function (self, arg_12_1, arg_12_2)
	-- function 12
	local var_12_0 = POSITION_LOOKUP[arg_12_2]

	if not var_12_0 then
		for i = 0, 1 do
			local find_index, var_12_2, var_12_3 = arg_12_1:find_index(var_12_0 + i * Vector3.up())

			if not arg_12_1:is_out_of_bounds(find_index, var_12_2, var_12_3) then
				break
			end

			local real_index = arg_12_1:real_index(find_index, var_12_2, var_12_3)
			local var_12_5 = self._flow[real_index]

			if not var_12_5 then
				if not var_12_5.full then
					return true
				else
					break
				end
			end
		end
	end

	return false
end

local tbl_4 = {}

LiquidAreaDamageExtension._pulse_damage = function (self)
	-- function 13
	local num = 0
	local unbox = self._damage_direction:unbox()
	local _damage_type = self._damage_type
	local _source_attacker_unit = self._source_attacker_unit
	local flag = not _source_attacker_unit and DamageUtils.is_player_unit(_source_attacker_unit)
	local _do_direct_damage_player = self._do_direct_damage_player
	local _do_direct_damage_ai = self._do_direct_damage_ai
	local _damage_buff_name = self._damage_buff_name
	local _unit = self._unit
	local _damage_table = self._damage_table

	for k, v in pairs(self._colliding_units) do
		local is_player_unit = DamageUtils.is_player_unit(k)

		if not HEALTH_ALIVE[k] then
			if not is_player_unit and _do_direct_damage_player and is_player_unit or not _do_direct_damage_ai then
				local var_13_11 = _damage_table[v]

				var_13_11 = var_13_11 or _damage_table[1]

				DamageUtils.add_damage_network(k, k, var_13_11, "torso", _damage_type, nil, unbox, self._liquid_area_damage_template, nil, _source_attacker_unit, nil, nil, nil, nil, nil, nil, nil, nil, 1)

				if not flag then
					local unit_breed = AiUtils.unit_breed(k)

					if not (not unit_breed and unit_breed.is_hero) then
						AiUtils.alert_unit_of_enemy(k, _source_attacker_unit)
					end
				end

				if not _damage_buff_name then
					ScriptUnit.extension(k, "buff_system"):add_buff(_damage_buff_name, tbl_4)
				end
			end
		else
			num = num + 1
			tbl[num] = k

			local flag_2 = not is_player_unit and ScriptUnit.extension(k, "status_system")

			if not (not is_player_unit and flag_2.in_liquid_unit ~= _unit) then
				StatusUtils.set_in_liquid_network(k, false)
			end
		end
	end

	for k_2 = 1, num do
		local var_13_14 = tbl[k_2]

		self._colliding_units[var_13_14] = nil
	end
end

LiquidAreaDamageExtension.is_position_inside = function (self, arg_14_1, arg_14_2)
	-- function 14
	local _grid = self._grid
	local find_index, var_14_2, var_14_3 = _grid:find_index(arg_14_1)

	if not _grid:is_out_of_bounds(find_index, var_14_2, var_14_3) then
		return false
	end

	local _nav_cost_map_cost_type = self._nav_cost_map_cost_type

	if not ((_nav_cost_map_cost_type == nil or not arg_14_2) and arg_14_2[_nav_cost_map_cost_type] ~= 1) then
		return false
	end

	local real_index = _grid:real_index(find_index, var_14_2, var_14_3)
	local var_14_6 = self._flow[real_index]

	if not var_14_6 and not var_14_6.full then
		return true
	else
		return false
	end
end

LiquidAreaDamageExtension.get_rim_nodes = function (self)
	-- function 15
	return self._inactive_flow, false
end

LiquidAreaDamageExtension.hot_join_sync = function (self, arg_16_1)
	-- function 16
	local _flow = self._flow
	local _unit_id = self._unit_id
	local _network_transmit = self._network_transmit

	for k, v in pairs(_flow) do
		local unbox = v.position:unbox()
		local full = v.full

		_network_transmit:send_rpc("rpc_add_liquid_damage_blob", arg_16_1, _unit_id, k, unbox, full)
	end
end

LiquidAreaDamageExtension.get_source_attacker_unit = function (self)
	-- function 17
	return self._source_attacker_unit
end
