-- chunkname: @scripts/unit_extensions/ai_commander/ai_commander_extension.lua

require("scripts/settings/profiles/career_constants")

local flag = true
local num = 7
local num_2 = 11
local num_3 = 4
local tbl = {
	alternating = true,
	lead_dist_min = 2,
	lead_dist_max = 2,
	commander_avoid_radius = 1.2,
	dist = 4,
	formation_type = "circle",
	lead_dist_mult = math.huge,
	initial_angle_offset = math.pi * 0.5,
	angle_offset = math.pi * 0.05
}

AICommanderExtension = class(AICommanderExtension)

AICommanderExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._unit = arg_1_2
	self.ai_commander_system = arg_1_1.owning_system
	self._controlled_units = {}
	self._controlled_units_n = 0
	self._nav_world = Managers.state.entity:system("ai_system"):nav_world()
	self._is_server = arg_1_1.is_server
	self._network_transmit = arg_1_1.network_transmit
	self._unit_storage = arg_1_1.unit_storage

	local player = arg_1_3.player

	if not player then
		self._is_local = not player and not player.remote
	end

	self._player = player
	self._last_reference_pos = Vector3Box()
	self._last_reference_rot = QuaternionBox(Quaternion.identity())
	self._last_point_match_rot = QuaternionBox(Quaternion.identity())

	if not self._is_server then
		self._follow_indices = {}
		self._follow_datas = {}
		self._units_to_recalculate = {}
		self._follow_units = {}
		self._stored_fallback_positions = {}
		self._fallback_position_data = {
			n = 0,
			cell_width = 2,
			grid_width = 0
		}
		self._fallback_positions = {}
	end

	self._combat_units = {}
	self._stand_ground_queue = {}
	self._stand_ground_active = false
	self._detection_radius = num
	self._detection_source_pos = Vector3Box()
	self._command_buffs = {}
end

AICommanderExtension.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	self._locomotion_ext = ScriptUnit.has_extension(arg_2_2, "locomotion_system")
	self._buff_extension = ScriptUnit.has_extension(arg_2_2, "buff_system")
	self._first_person_extension = ScriptUnit.has_extension(arg_2_2, "first_person_system")
	self._buff_system = Managers.state.entity:system("buff_system")
end

AICommanderExtension.destroy = function (arg_3_0)
	-- function 3
	return
end

AICommanderExtension._claim_follow_index = function (self, arg_4_1)
	-- function 4
	local num = #self._follow_indices + 1

	self._follow_indices[num] = arg_4_1
	self._follow_datas[arg_4_1] = {
		undergoing_avoidance = false,
		follow_index = num,
		last_follow_position = Vector3Box(),
		lerped_follow_position = Vector3Box(POSITION_LOOKUP[arg_4_1]),
		target_follow_position = Vector3Box(),
		true_follow_position = Vector3Box(),
		unit = arg_4_1
	}
end

AICommanderExtension._free_follow_index = function (self, arg_5_1)
	-- function 5
	local follow_index = self._follow_datas[arg_5_1].follow_index

	self._follow_datas[arg_5_1] = nil

	local _follow_indices = self._follow_indices

	table.swap_delete(_follow_indices, follow_index)

	local var_5_2 = _follow_indices[follow_index]

	if not var_5_2 then
		self._follow_datas[var_5_2].follow_index = follow_index
	end
end

AICommanderExtension.register_follow_node_update = function (self, arg_6_1)
	-- function 6
	self._follow_units[arg_6_1] = true
	self._force_follow_update = true

	self._follow_datas[arg_6_1].lerped_follow_position:store(POSITION_LOOKUP[arg_6_1])
end

AICommanderExtension.unregister_follow_node_update = function (arg_7_0, arg_7_1)
	-- function 7
	arg_7_0._follow_units[arg_7_1] = nil
	arg_7_0._units_to_recalculate[arg_7_1] = nil
end

AICommanderExtension.follow_node_pending = function (arg_8_0, arg_8_1)
	-- function 8
	return arg_8_1.waiting_for_follow_node
end

AICommanderExtension.follow_node_position = function (self, arg_9_1)
	-- function 9
	local var_9_0 = self._follow_datas[arg_9_1]

	return not var_9_0 and var_9_0.lerped_follow_position
end

AICommanderExtension.update = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	-- function 10
	if not self._is_server then
		self:_update_units(arg_10_3, arg_10_5)
		self:_update_follow(arg_10_3, arg_10_5)
	end

	self:_update_commands()

	self._cached_hovered_friendly_unit = false
	self._cached_hovered_fallback_unit = false
	self._cached_hovered_commanded_unit = false
end

AICommanderExtension._on_controlled_unit_destroyed = function (self, arg_11_1)
	-- function 11
	self:remove_controlled_unit(arg_11_1)
end

AICommanderExtension.set_controlled_unit_template = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	-- function 12
	if not arg_12_3 then
		self._controlled_units[arg_12_1] = {
			start_t = arg_12_4 or Managers.time:time("game"),
			command_state = CommandStates.Following
		}
	end

	local var_12_0 = ControlledUnitTemplates[arg_12_2]

	if not self._is_server then
		local client_version = var_12_0.client_version

		if not client_version then
			var_12_0 = ControlledUnitTemplates[client_version]
		end
	end

	self._controlled_units[arg_12_1].template = var_12_0
end

AICommanderExtension.controlled_unit_template = function (self, arg_13_1)
	-- function 13
	local var_13_0 = self._controlled_units[arg_13_1]

	return not var_13_0 and var_13_0.template
end

AICommanderExtension.add_controlled_unit = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	if not ALIVE[arg_14_1] then
		return
	end

	self:set_controlled_unit_template(arg_14_1, arg_14_2, true, arg_14_3)

	local _unit = self._unit

	self._controlled_units_n = self._controlled_units_n + 1

	self.ai_commander_system:register_commander_unit(_unit, arg_14_1)

	if not self._is_server then
		self:_claim_follow_index(arg_14_1)

		self._command_buffs[arg_14_1] = {}

		local var_14_1 = BLACKBOARDS[arg_14_1]

		if not var_14_1.ability_spawned then
			var_14_1.detection_radius = num
		end

		var_14_1.detection_source_pos = Vector3Box()
		var_14_1.max_combat_range = num
		var_14_1.max_combat_range_sq = var_14_1.max_combat_range * var_14_1.max_combat_range
		var_14_1.max_combat_range_sticky = num_2
		var_14_1.max_combat_range_sticky_sq = var_14_1.max_combat_range_sticky * var_14_1.max_combat_range_sticky
		var_14_1.dist_to_commander = 0
		var_14_1.commander_unit = _unit
		var_14_1.commander_extension = self
		var_14_1.command_state = CommandStates.Following

		Managers.state.event:register_referenced(arg_14_1, self, "on_ai_unit_destroyed", "_on_controlled_unit_destroyed")
	end

	if not self._is_local then
		self:_set_command_state(arg_14_1, CommandStates.Following)
		Managers.state.achievement:trigger_event("on_controlled_unit_added", arg_14_1, self._unit, self)
	end

	local _buff_extension = self._buff_extension

	if not _buff_extension then
		_buff_extension:trigger_procs("on_controlled_unit_added", arg_14_1)
	end

	Managers.state.event:trigger_referenced(_unit, "on_controlled_unit_added", arg_14_1)

	if not arg_14_4 then
		local go_id = self._unit_storage:go_id(_unit)
		local go_id_2 = self._unit_storage:go_id(arg_14_1)
		local var_14_5 = NetworkLookup.controlled_unit_templates[arg_14_2]

		if not self._is_server then
			local owner = Managers.player:owner(_unit)

			if not owner and not owner.remote then
				self._network_transmit:send_rpc("rpc_add_controlled_unit", owner.peer_id, go_id, go_id_2, var_14_5)
			end
		else
			self._network_transmit:send_rpc_server("rpc_add_controlled_unit", go_id, go_id_2, var_14_5)
		end
	end
end

AICommanderExtension.remove_controlled_unit = function (self, arg_15_1, arg_15_2)
	-- function 15
	local _controlled_units = self._controlled_units

	if not _controlled_units[arg_15_1] then
		return
	end

	self._combat_units[arg_15_1] = nil
	_controlled_units[arg_15_1] = nil
	self._controlled_units_n = self._controlled_units_n - 1

	if not self._is_local and not Managers.player:local_player() then
		Managers.state.achievement:trigger_event("on_controlled_unit_removed", arg_15_1, self._unit, self)
	end

	local _buff_extension = self._buff_extension

	if not _buff_extension then
		_buff_extension:trigger_procs("on_controlled_unit_removed", arg_15_1)

		if not HEALTH_ALIVE[arg_15_1] then
			_buff_extension:trigger_procs("on_controlled_unit_death", arg_15_1)
		end
	end

	self.ai_commander_system:clear_commander_unit(arg_15_1)

	if not self._is_server then
		self:_free_follow_index(arg_15_1)
		self:unregister_follow_node_update(arg_15_1)
		self:_store_fallback_position(arg_15_1)

		local var_15_2 = BLACKBOARDS[arg_15_1]

		if not var_15_2 then
			var_15_2.max_combat_range = nil
			var_15_2.max_combat_range_sq = nil
			var_15_2.max_combat_range_sticky = nil
			var_15_2.dist_to_commander = nil
			var_15_2.commander_unit = nil
			var_15_2.commander_extension = nil
			var_15_2.waiting_for_follow_node = nil
		end

		self:_cleanup_command_buffs(arg_15_1, false)

		self._command_buffs[arg_15_1] = nil

		Managers.state.event:unregister_referenced("on_ai_unit_destroyed", arg_15_1, self)
	end

	if not arg_15_2 then
		local _unit = self._unit
		local go_id = self._unit_storage:go_id(_unit)
		local go_id_2 = self._unit_storage:go_id(arg_15_1)

		if not go_id and not go_id_2 then
			if not self._is_server then
				local owner = Managers.player:owner(_unit)

				if not owner and not owner.remote then
					self._network_transmit:send_rpc("rpc_remove_controlled_unit", owner.peer_id, go_id, go_id_2)
				end
			else
				self._network_transmit:send_rpc_server("rpc_remove_controlled_unit", go_id, go_id_2)
			end
		end
	end
end

AICommanderExtension.get_controlled_units = function (self)
	-- function 16
	return self._controlled_units
end

AICommanderExtension.get_controlled_units_count = function (self)
	-- function 17
	return self._controlled_units_n
end

local num_4 = 0.5
local num_5 = num_4 * num_4

AICommanderExtension._update_follow = function (self, arg_18_1, arg_18_2)
	-- function 18
	if not self:_commander_is_on_navmesh() then
		return
	end

	local _unit = self._unit
	local var_18_1 = POSITION_LOOKUP[_unit]
	local var_18_2

	if not self._first_person_extension then
		var_18_2 = self._first_person_extension:current_rotation()
		var_18_2 = Quaternion.flat_no_roll(var_18_2)
	else
		local go_id = self._unit_storage:go_id(_unit)
		local game = Managers.state.network:game()
		local game_object_field = GameSession.game_object_field(game, go_id, "aim_direction")

		var_18_2 = Quaternion.flat_no_roll(Quaternion.look(game_object_field))
	end

	local _force_follow_update = self._force_follow_update
	local flag = false
	local flag_2 = not table.is_empty(self._units_to_recalculate)

	self._force_follow_update = nil

	if not _force_follow_update then
		local unbox = self._last_reference_pos:unbox()
		local distance_squared = Vector3.distance_squared(var_18_1, unbox)

		if distance_squared > num_5 then
			_force_follow_update = distance_squared > num_5
		end

		flag = not not _force_follow_update or distance_squared > 0.001

		if not flag then
			local current_velocity = self._locomotion_ext:current_velocity()

			flag = Vector3.length_squared(current_velocity) < NetworkConstants.VELOCITY_EPSILON * NetworkConstants.VELOCITY_EPSILON
		end
	end

	if _force_follow_update or flag_2 or not flag then
		if _force_follow_update or not flag then
			self._last_reference_rot:store(var_18_2)
			self._last_reference_pos:store(var_18_1)

			for k in pairs(self._follow_units) do
				self._units_to_recalculate[k] = true
			end
		end

		self:_update_follow_nodes(arg_18_1, arg_18_2)

		local _last_point_match_rot = self._last_point_match_rot

		if Quaternion.angle(var_18_2, _last_point_match_rot:unbox()) > math.pi * 0.25 or not flag then
			_last_point_match_rot:store(var_18_2)
			self:_pair_best_follow_nodes()
		end
	end

	self:_lerp_follow_positions(arg_18_1)
end

AICommanderExtension._update_follow_nodes = function (self, arg_19_1, arg_19_2)
	-- function 19
	if not script_data.bots_dont_follow then
		return
	end

	local _unit = self._unit
	local _nav_world = self._nav_world
	local var_19_2 = POSITION_LOOKUP[_unit]
	local current_velocity = self._locomotion_ext:current_velocity()
	local var_19_4
	local var_19_5

	if Vector3.length_squared(current_velocity) < NetworkConstants.VELOCITY_EPSILON * NetworkConstants.VELOCITY_EPSILON then
		var_19_4 = 0
		var_19_5 = Quaternion.forward(Quaternion.flat_no_roll(self._last_reference_rot:unbox()))
	else
		var_19_4 = Vector3.length(current_velocity)
		var_19_5 = current_velocity / var_19_4
	end

	local num = 30
	local num_2 = 30
	local num_4 = 5

	for k in pairs(self._units_to_recalculate) do
		repeat
			self._units_to_recalculate[k] = nil

			local var_19_9 = self._follow_datas[k]

			var_19_9.undergoing_avoidance = false

			if not POSITION_LOOKUP[k] then
				break
			end

			local var_19_10 = BLACKBOARDS[k]
			local commander_formation = var_19_10.breed.commander_formation
			local flag = var_19_9.follow_index > num_3
			local var_19_13

			if not flag then
				local grid_width = self._fallback_position_data.grid_width

				var_19_13 = Vector3(0, -3 - grid_width * 0.5, 0) + self:_get_fallback_position(k).pos:unbox()
				var_19_13 = Quaternion.rotate(Quaternion.look(Vector3.flat(var_19_5)), var_19_13)
			else
				local angle_offset = commander_formation.angle_offset
				local initial_angle_offset = commander_formation.initial_angle_offset

				initial_angle_offset = initial_angle_offset or angle_offset

				local alternating = commander_formation.alternating
				local follow_index = var_19_9.follow_index
				local num_5 = follow_index - 1

				num_5 = not alternating and math.floor(num_5 * 0.5) and num_5

				local num_6 = initial_angle_offset + num_5 * angle_offset

				if not (not alternating and not (follow_index % 2 > 0)) then
					num_6 = num_6 * -1
				end

				local axis_angle = Quaternion.axis_angle(Vector3.up(), num_6)

				var_19_13 = Quaternion.rotate(axis_angle, Vector3.forward() * commander_formation.dist)
				var_19_13 = Quaternion.rotate(Quaternion.look(Vector3.flat(var_19_5)), var_19_13)

				local var_19_22

				if not commander_formation.offset then
					var_19_22 = Vector3(commander_formation.offset[1], commander_formation.offset[2], 0)

					if not var_19_22 then
						-- Nothing
					end
				end

				var_19_22 = Vector3.zero()

				::label_19_0::

				var_19_13 = var_19_13 + var_19_22
			end

			local flag_2

			flag_2 = var_19_4 ~= 0 or not 0 or math.clamp(var_19_4 * commander_formation.lead_dist_mult, commander_formation.lead_dist_min, commander_formation.lead_dist_max)

			local num_7 = var_19_5 * flag_2
			local num_8 = var_19_2 + var_19_13 + num_7
			local _navify_follow_pos = self:_navify_follow_pos(num_8, _nav_world, var_19_2, num_7, var_19_10)

			var_19_9.true_follow_position:store(_navify_follow_pos)

			local var_19_27 = _navify_follow_pos
			local commander_avoid_radius

			if var_19_4 > 0 then
				commander_avoid_radius = commander_formation.commander_avoid_radius

				if not commander_avoid_radius then
					-- Nothing
				end
			end

			commander_avoid_radius = 0

			::label_19_1::

			local _avoid_unit = self:_avoid_unit(_unit, k, var_19_27, commander_avoid_radius, var_19_10, _nav_world, num, num_2, arg_19_1, arg_19_2)

			for k_2 in pairs(self._follow_datas) do
				if k_2 ~= k then
					local var_19_30 = BLACKBOARDS[k_2]

					if not (not var_19_30 and var_19_30.command_state ~= CommandStates.Following) then
						local flag_3

						flag_3 = not (var_19_4 > 0) or not self:_unit_arrived_at_follow_node(k_2) or 0.25 or not 1 or 0
						_avoid_unit = self:_avoid_unit(k_2, k, _avoid_unit, flag_3, var_19_10, _nav_world, num, num_2, arg_19_1, arg_19_2)
					end
				end
			end

			if _avoid_unit ~= _navify_follow_pos then
				_avoid_unit = self:_navify_follow_pos(_avoid_unit, _nav_world, var_19_2, num_7, var_19_10)
			end

			local lerped_follow_position = var_19_9.lerped_follow_position

			if Vector3.distance_squared(lerped_follow_position:unbox(), _avoid_unit) > 0.09 then
				local triangle_from_position, var_19_34 = GwNavQueries.triangle_from_position(_nav_world, _avoid_unit, num, num_2)

				if not triangle_from_position then
					_avoid_unit.z = var_19_34
				else
					_avoid_unit = GwNavQueries.inside_position_from_outside_position(_nav_world, _avoid_unit, num, num_2, num_4, 0.5)
				end

				if not _avoid_unit then
					var_19_9.target_follow_position:store(_avoid_unit)
				end
			end
		until true
	end
end

AICommanderExtension._lerp_follow_positions = function (self, arg_20_1)
	-- function 20
	local _nav_world = self._nav_world

	for k in pairs(self._follow_units) do
		local var_20_1 = BLACKBOARDS[k]
		local var_20_2 = self._follow_datas[k]
		local lerped_follow_position = var_20_2.lerped_follow_position
		local unbox = lerped_follow_position:unbox()
		local unbox_2 = var_20_2.target_follow_position:unbox()

		if Vector3.distance_squared(unbox, unbox_2) > math.epsilon then
			local num = var_20_1.navigation_extension:get_max_speed() * 2
			local direction_length, var_20_8 = Vector3.direction_length(unbox_2 - unbox)
			local num_2 = unbox + direction_length * math.max(num, var_20_8) * arg_20_1
			local closest_point_on_line = Geometry.closest_point_on_line(num_2, unbox, unbox_2)
			local traverse_logic = var_20_1.navigation_extension:traverse_logic()

			if not traverse_logic then
				local raycast, var_20_13 = GwNavQueries.raycast(_nav_world, unbox_2, closest_point_on_line, traverse_logic)

				lerped_follow_position:store(var_20_13)

				local last_follow_position = var_20_2.last_follow_position

				if Vector3.distance_squared(last_follow_position:unbox(), var_20_13) > 0.09 then
					last_follow_position:store(var_20_13)

					var_20_1.goal_destination = Vector3Box(var_20_13)
					var_20_1.new_move_to_goal = true
					self._units_to_recalculate[k] = true
				end
			end
		end

		var_20_1.waiting_for_follow_node = nil
	end
end

AICommanderExtension._unit_arrived_at_follow_node = function (self, arg_21_1)
	-- function 21
	local var_21_0 = POSITION_LOOKUP[arg_21_1]
	local var_21_1 = self._follow_datas[arg_21_1]

	return Vector3.distance_squared(var_21_0, var_21_1.target_follow_position:unbox()) < 0.25
end

AICommanderExtension._avoid_unit = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8, arg_22_9, arg_22_10)
	-- function 22
	local var_22_0 = POSITION_LOOKUP[arg_22_1]
	local var_22_1 = POSITION_LOOKUP[arg_22_2]

	if not var_22_0 then
		return arg_22_3
	end

	if math.abs(var_22_0.z - var_22_1.z) > 1 then
		return arg_22_3
	end

	local var_22_2 = self._follow_datas[arg_22_1]

	if not (not var_22_2 and var_22_2.undergoing_avoidance ~= arg_22_2) then
		return arg_22_3
	end

	local flat = Vector3.flat(arg_22_3 - var_22_0)
	local flat_2 = Vector3.flat(var_22_1 - var_22_0)

	if Vector3.length_squared(flat) < arg_22_4 * arg_22_4 then
		return arg_22_3
	end

	if not (Vector3.dot(flat, flat_2) < 0) then
		local flip_attempt_t = arg_22_5.flip_attempt_t
		local flag = not flip_attempt_t and arg_22_10 - flip_attempt_t < 2
		local flip_dir

		if not flag then
			flip_dir = arg_22_5.flip_dir

			if not flip_dir then
				-- Nothing
			end
		end

		flip_dir = not (Vector3.cross(flat_2, flat).z < 0) or not -1 or 1

		::label_22_0::

		local max = math.max(Vector3.length(flat_2), math.epsilon)
		local flag_2 = max < arg_22_4
		local var_22_10 = self._follow_datas[arg_22_2]
		local undergoing_avoidance = var_22_10.undergoing_avoidance

		if not flag_2 then
			var_22_10.undergoing_avoidance = arg_22_1
			self._units_to_recalculate[arg_22_2] = true

			if not undergoing_avoidance then
				return Vector3.copy(var_22_1)
			end

			local num = Vector3.cross(Vector3.normalize(flat_2), -Vector3.up()) * flip_dir

			arg_22_3 = var_22_1 + Quaternion.rotate(Quaternion.axis_angle(Vector3(0, 0, flip_dir), -math.pi * arg_22_9), num) * 2
		else
			local normalize = Vector3.normalize(Vector3.flat(arg_22_3 - var_22_1))
			local num_2 = var_22_1 + normalize * Vector3.dot(-flat_2, normalize)

			if not (Vector3.length_squared(Vector3.flat(var_22_0) - Vector3.flat(num_2)) < arg_22_4 * arg_22_4 - math.epsilon) then
				var_22_10.undergoing_avoidance = arg_22_1
				self._units_to_recalculate[arg_22_2] = true

				if not undergoing_avoidance then
					local flat_3 = Vector3.flat(var_22_1)
					local ray_circle, var_22_17 = Intersect.ray_circle(flat_3, normalize, Vector3.flat(var_22_0), arg_22_4)
					local flag_3 = not (Vector3.distance_squared(ray_circle, flat_3) < Vector3.distance_squared(var_22_17, flat_3)) and ray_circle and var_22_17

					if not flag then
						arg_22_5.flip_attempt_t = arg_22_10
						arg_22_5.flip_dir = -flip_dir
					end

					flag_3.z = arg_22_3.z

					return flag_3
				end

				local clamp01 = math.clamp01(arg_22_4 / max)
				local num_3 = var_22_0 + Quaternion.rotate(Quaternion.axis_angle(Vector3(0, 0, flip_dir), math.acos(clamp01)), Vector3.normalize(flat_2) * arg_22_4)
				local triangle_from_position, var_22_22 = GwNavQueries.triangle_from_position(arg_22_6, num_3, arg_22_7, arg_22_8)

				if not triangle_from_position then
					num_3.z = var_22_22
				elseif not flag then
					arg_22_5.flip_attempt_t = arg_22_10
					arg_22_5.flip_dir = -flip_dir
				else
					return num_2
				end

				local length = Vector3.length(arg_22_3 - var_22_1)

				arg_22_3 = var_22_1 + Vector3.normalize(num_3 - var_22_1) * length
			end
		end
	end

	return arg_22_3
end

AICommanderExtension._pair_best_follow_nodes = function (self)
	-- function 23
	local _follow_indices = self._follow_indices
	local _follow_datas = self._follow_datas
	local alloc_table = FrameTable.alloc_table()
	local alloc_table_2 = FrameTable.alloc_table()
	local count = #_follow_indices

	for i = 1, count do
		local var_23_5 = _follow_indices[i]
		local var_23_6 = POSITION_LOOKUP[var_23_5]

		alloc_table_2[i], alloc_table[i] = _follow_datas[var_23_5].true_follow_position:unbox(), var_23_6
	end

	local alloc_table_3 = FrameTable.alloc_table()

	math.distributed_point_matching(alloc_table, alloc_table_2, alloc_table_3, true)

	for j = 1, count do
		local var_23_8 = alloc_table_3[j]
		local var_23_9 = _follow_indices[j]

		if _follow_datas[var_23_9].follow_index ~= var_23_8 then
			_follow_datas[var_23_9].follow_index = var_23_8
			self._units_to_recalculate[var_23_9] = true
		end
	end

	for k, v in pairs(_follow_datas) do
		_follow_indices[v.follow_index] = k
	end
end

AICommanderExtension._navify_follow_pos = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
	-- function 24
	local traverse_logic = arg_24_5.navigation_extension:traverse_logic()

	if not traverse_logic then
		local raycast, var_24_2 = GwNavQueries.raycast(arg_24_2, arg_24_3, arg_24_3 + arg_24_4, traverse_logic)

		if not raycast then
			var_24_2 = var_24_2 + Vector3.normalize(arg_24_3 - var_24_2) * 1.5
		end

		local raycast_2, var_24_4 = GwNavQueries.raycast(arg_24_2, var_24_2, arg_24_1, traverse_logic)

		if not raycast_2 then
			arg_24_1 = var_24_4
		end
	end

	return arg_24_1
end

AICommanderExtension._update_units = function (self, arg_25_1, arg_25_2)
	-- function 25
	local var_25_0 = POSITION_LOOKUP[self._unit]
	local _controlled_units = self._controlled_units
	local var_25_2

	if not table.is_empty(self._combat_units) then
		var_25_2 = num

		if not var_25_2 then
			-- Nothing
		end
	end

	var_25_2 = num_2

	::label_25_0::

	local num_3 = var_25_2 * 0.5
	local average_velocity = self._locomotion_ext:average_velocity()

	if Vector3.length_squared(average_velocity) > num_3 * num_3 then
		average_velocity = Vector3.normalize(average_velocity) * num_3
	end

	local num_4 = var_25_0 + average_velocity

	for k in pairs(_controlled_units) do
		local var_25_6 = BLACKBOARDS[k]
		local var_25_7 = POSITION_LOOKUP[k]

		if not var_25_7 then
			self:remove_controlled_unit(k)

			return
		end

		if not ScriptUnit.extension(k, "health_system"):is_dead() then
			self:remove_controlled_unit(k)

			return
		end

		local var_25_8 = self._controlled_units[k]
		local template = var_25_8.template

		if not (not template.duration and not (arg_25_2 > var_25_8.start_t + template.duration)) then
			self:remove_controlled_unit(k)

			if template.disband_type == ControlledUnitDisbandType.kill then
				AiUtils.kill_unit(k)
			end

			return
		end

		if not var_25_6.ability_spawned then
			var_25_6.detection_radius = var_25_2
		end

		var_25_6.dist_to_commander = Vector3.distance(var_25_0, var_25_7)

		if var_25_6.command_state == CommandStates.StandingGround then
			var_25_6.detection_source_pos:store(var_25_6.stand_ground_position:unbox())
		else
			var_25_6.detection_source_pos:store(num_4)
		end

		AiBreedSnippets.update_enemy_sighting_within_commander_sticky(var_25_6)
	end
end

AICommanderExtension.pet_ui_data = function (self, arg_26_1)
	-- function 26
	local var_26_0 = self._controlled_units[arg_26_1]

	if not var_26_0 then
		return nil, nil, nil
	end

	local template = var_26_0.template
	local pet_ui_type = template.pet_ui_type

	if pet_ui_type == "health" then
		local has_extension = ScriptUnit.has_extension(arg_26_1, "health_system")

		if not has_extension then
			local current_health = has_extension:current_health()
			local get_max_health = has_extension:get_max_health()

			return template, current_health, get_max_health
		end
	elseif pet_ui_type == "duration" then
		local duration = var_26_0.template.duration

		if not duration then
			local time = Managers.time:time("game")
			local start_t = var_26_0.start_t

			return template, time - start_t, duration
		end
	end

	return nil, nil, nil
end

AICommanderExtension.controlled_units_in_combat = function (self)
	-- function 27
	return self._combat_units
end

AICommanderExtension.set_in_combat = function (arg_28_0, arg_28_1, arg_28_2)
	-- function 28
	arg_28_0._combat_units[arg_28_1] = arg_28_2 or nil
end

AICommanderExtension._calculate_hovered_friendly_unit = function (self)
	-- function 29
	local num = 1
	local _first_person_extension = self._first_person_extension
	local current_position = _first_person_extension:current_position()
	local forward = Quaternion.forward(_first_person_extension:current_rotation())
	local get_controlled_units = self:get_controlled_units()
	local var_29_5
	local var_29_6
	local var_29_7
	local huge = math.huge

	for k in pairs(get_controlled_units) do
		repeat
			if not ALIVE[k] then
				break
			end

			local world_position

			if not Unit.has_node(k, "j_spine") then
				world_position = Unit.world_position(k, Unit.node(k, "j_spine"))

				if not world_position then
					-- Nothing
				end
			end

			world_position = POSITION_LOOKUP[k]

			::label_29_0::

			if not world_position then
				local direction_length, var_29_11 = Vector3.direction_length(world_position - current_position)
				local atan = math.atan(num / var_29_11)
				local dot = Vector3.dot(forward, direction_length)
				local acos = math.acos(dot)

				if acos < huge then
					var_29_6 = k
					huge = acos

					if acos <= atan then
						var_29_5 = k

						if self:command_state(k) ~= CommandStates.Following then
							var_29_7 = k
						end
					end
				end
			end
		until true
	end

	self._cached_hovered_fallback_unit = var_29_6
	self._cached_hovered_friendly_unit = var_29_5
	self._cached_hovered_commanded_unit = var_29_7
end

AICommanderExtension._set_command_state = function (self, arg_30_1, arg_30_2)
	-- function 30
	fassert(self._is_local, "[AICommanderExtension] Local only function")

	local var_30_0 = self._controlled_units[arg_30_1]

	if not var_30_0 then
		var_30_0.command_state = arg_30_2
	end
end

AICommanderExtension.command_state = function (self, arg_31_1)
	-- function 31
	local var_31_0 = self._controlled_units[arg_31_1]

	return not var_31_0 and var_31_0.command_state
end

AICommanderExtension.cancel_current_command = function (self, arg_32_1, arg_32_2)
	-- function 32
	if not (not arg_32_2 and self:command_state(arg_32_1) ~= CommandStates.Attacking) then
		return
	end

	if not self._is_local then
		self:_set_command_state(arg_32_1, CommandStates.Following)
	end

	if not self._is_server then
		local go_id = self._unit_storage:go_id(arg_32_1)

		self._network_transmit:send_rpc_server("rpc_cancel_current_command", go_id)

		return
	end

	self:_cleanup_command_buffs(arg_32_1, true)

	local var_32_1 = BLACKBOARDS[arg_32_1]

	var_32_1.command_state = CommandStates.Following
	var_32_1.override_target_selection_name = nil
	var_32_1.override_detection_radius = nil
	var_32_1.fallback_rotation = nil
	var_32_1.commander_target = nil
	var_32_1.new_command_attack = nil
	var_32_1.charge_target = nil
	var_32_1.target_unit = nil
end

AICommanderExtension.command_attack = function (self, arg_33_1, arg_33_2)
	-- function 33
	if not self._is_server then
		self:cancel_current_command(arg_33_1)

		local var_33_0 = BLACKBOARDS[arg_33_1]

		var_33_0.target_unit = arg_33_2
		var_33_0.commander_target = arg_33_2
		var_33_0.override_target_selection_name = "attack_commander_target_with_fallback"
		var_33_0.command_state = CommandStates.Attacking
		var_33_0.new_command_attack = true

		self:_add_command_buffs(arg_33_1, CommandStates.Attacking)
	else
		local go_id = self._unit_storage:go_id(arg_33_1)
		local go_id_2 = self._unit_storage:go_id(arg_33_2)

		self._network_transmit:send_rpc_server("rpc_command_attack", go_id, go_id_2)
	end

	if not self._is_local then
		Managers.state.achievement:trigger_event("command_attack_unit", arg_33_1, arg_33_2)
		self:_set_command_state(arg_33_1, CommandStates.Attacking)

		self._controlled_units[arg_33_1].commander_target = arg_33_2

		local extension_input = ScriptUnit.extension_input(self._unit, "dialogue_system")
		local alloc_table = FrameTable.alloc_table()

		extension_input:trigger_dialogue_event("minion_command_attack", alloc_table)
	end
end

AICommanderExtension.command_stand_ground = function (self, arg_34_1, arg_34_2, arg_34_3)
	-- function 34
	if not self._is_server then
		self:cancel_current_command(arg_34_1)

		local var_34_0 = BLACKBOARDS[arg_34_1]

		var_34_0.target_unit = nil
		var_34_0.command_state = CommandStates.StandingGround
		var_34_0.override_detection_radius = 3
		var_34_0.stand_ground_position = Vector3Box(arg_34_2)
		var_34_0.goal_destination = Vector3Box(arg_34_2)
		var_34_0.new_move_to_goal = true
		var_34_0.fallback_rotation = QuaternionBox(arg_34_3)

		self:_add_command_buffs(arg_34_1, CommandStates.StandingGround)
	else
		local go_id = self._unit_storage:go_id(arg_34_1)

		self._network_transmit:send_rpc_server("rpc_command_stand_ground", go_id, arg_34_2, arg_34_3)
	end

	if not self._is_local then
		self:_set_command_state(arg_34_1, CommandStates.StandingGround)

		self._stand_ground_active = true

		local extension_input = ScriptUnit.extension_input(self._unit, "dialogue_system")
		local alloc_table = FrameTable.alloc_table()

		extension_input:trigger_dialogue_event("minion_command_defend", alloc_table)
	end
end

AICommanderExtension.hovered_friendly_unit = function (self)
	-- function 35
	if not self._cached_hovered_fallback_unit then
		self:_calculate_hovered_friendly_unit()
	end

	return self._cached_hovered_friendly_unit, self._cached_hovered_fallback_unit
end

AICommanderExtension.hovered_commanded_unit = function (self)
	-- function 36
	if not self._cached_hovered_commanded_unit then
		self:_calculate_hovered_friendly_unit()
	end

	return self._cached_hovered_commanded_unit
end

AICommanderExtension._update_command_stand_ground = function (self)
	-- function 37
	if not self._stand_ground_active then
		local flag = false

		for k in pairs(self._controlled_units) do
			local var_37_1 = POSITION_LOOKUP[k]
			local var_37_2 = POSITION_LOOKUP[self._unit]
			local distance_squared = Vector3.distance_squared(var_37_1, var_37_2)
			local max_range = CareerConstants.bw_necromancer.max_range

			if distance_squared > max_range * max_range then
				flag = true

				break
			end
		end

		if not flag then
			for k_2 in pairs(self._controlled_units) do
				if self:command_state(k_2) == CommandStates.StandingGround then
					self:cancel_current_command(k_2)
				end
			end

			self._stand_ground_active = false
		end
	end

	local _stand_ground_queue = self._stand_ground_queue

	for k_3 = 1, #_stand_ground_queue do
		local var_37_6 = _stand_ground_queue[k_3]

		self:_command_stand_ground_group(var_37_6.units, var_37_6.target_position:unbox(), var_37_6.fallback_rotation:unbox())

		_stand_ground_queue[k_3] = nil
	end
end

AICommanderExtension._update_commands = function (self)
	-- function 38
	if not self._is_local then
		local flag = false

		for k, v in pairs(self._controlled_units) do
			if not (self:command_state(k) ~= CommandStates.Attacking or HEALTH_ALIVE[v.commander_target]) then
				self:cancel_current_command(k)
			else
				flag = flag or v.command_state == CommandStates.StandingGround
			end
		end
	end

	self:_update_command_stand_ground()
end

AICommanderExtension.command_stand_ground_group = function (self, arg_39_1, arg_39_2, arg_39_3)
	-- function 39
	local _stand_ground_queue = self._stand_ground_queue

	_stand_ground_queue[#_stand_ground_queue + 1] = {
		units = arg_39_1,
		target_position = Vector3Box(arg_39_2),
		fallback_rotation = QuaternionBox(arg_39_3)
	}
end

AICommanderExtension._command_stand_ground_group = function (self, arg_40_1, arg_40_2, arg_40_3)
	-- function 40
	table.array_remove_if(arg_40_1, function (arg_41_0)
		-- function 41
		return not self._controlled_units[arg_41_0]
	end)

	local count = #arg_40_1

	if count <= 0 then
		return
	end

	local generate_positions = ActionCareerBwNecromancerCommandStandTargetingUtility.generate_positions(arg_40_2, arg_40_3, count)
	local min = math.min(count, #generate_positions)
	local alloc_table = FrameTable.alloc_table()
	local alloc_table_2 = FrameTable.alloc_table()

	for i = 1, min do
		alloc_table[i] = POSITION_LOOKUP[arg_40_1[i]]
		alloc_table_2[i] = generate_positions[i]:unbox()
	end

	local alloc_table_3 = FrameTable.alloc_table()
	local distributed_point_matching = math.distributed_point_matching(alloc_table, alloc_table_2, alloc_table_3)

	if not distributed_point_matching then
		return
	end

	for j = 1, distributed_point_matching do
		local var_40_7 = arg_40_1[j]
		local var_40_8 = alloc_table_2[alloc_table_3[j]]

		self:command_stand_ground(var_40_7, var_40_8, arg_40_3)
	end
end

AICommanderExtension._commander_is_on_navmesh = function (self)
	-- function 42
	local var_42_0 = POSITION_LOOKUP[self._unit]

	if not var_42_0 then
		self._is_on_navmesh = false

		return
	end

	local num = 0.5
	local num_2 = 2

	return (GwNavQueries.triangle_from_position(self._nav_world, var_42_0, num, num_2))
end

AICommanderExtension._cleanup_command_buffs = function (self, arg_43_1, arg_43_2)
	-- function 43
	local _buff_system = self._buff_system
	local var_43_1 = self._command_buffs[arg_43_1]

	for i = #var_43_1, 1, -1 do
		local var_43_2 = var_43_1[i]
		local remove_on_command = var_43_2.remove_on_command

		if not arg_43_2 and not remove_on_command then
			local id = var_43_2.id

			_buff_system:remove_buff_synced(arg_43_1, id)
			table.swap_delete(var_43_1, i)
		end
	end
end

AICommanderExtension._add_command_buffs = function (self, arg_44_1, arg_44_2)
	-- function 44
	local buff_on_command = self._controlled_units[arg_44_1].template.buff_on_command
	local flag = not buff_on_command and buff_on_command[arg_44_2]

	if not flag then
		return
	end

	local var_44_2 = self._command_buffs[arg_44_1]
	local _buff_system = self._buff_system

	for i = 1, #flag do
		local var_44_4 = flag[i]
		local add_buff_synced = _buff_system:add_buff_synced(arg_44_1, var_44_4.name, BuffSyncType.Local)

		var_44_2[#var_44_2 + 1] = {
			id = add_buff_synced,
			remove_on_command = var_44_4.remove_on_command
		}
	end
end

AICommanderExtension._get_fallback_position = function (self, arg_45_1)
	-- function 45
	local _fallback_positions = self._fallback_positions
	local _stored_fallback_positions = self._stored_fallback_positions
	local _fallback_position_data = self._fallback_position_data

	if not _fallback_positions[arg_45_1] then
		return _fallback_positions[arg_45_1]
	end

	local count = #_stored_fallback_positions

	if count == 0 then
		local cell_width = _fallback_position_data.cell_width
		local num = _fallback_position_data.grid_width + 1

		_fallback_position_data.grid_width = num

		for k, v in pairs(_fallback_positions) do
			local pos = v.pos
			local unbox = pos:unbox()
			local num_2 = cell_width * 0.5

			unbox[1] = unbox[1] - num_2
			unbox[2] = unbox[2] - num_2

			pos:store(unbox)
		end

		local cell_width_2 = _fallback_position_data.cell_width

		for k_2 = 1, num do
			local num_3 = (k_2 - 1 - (num - 1) * 0.5) * cell_width + math.random() * cell_width_2 - cell_width_2 * 0.5
			local num_4 = (num - 1) * 0.5 * cell_width + math.random() * cell_width_2 - cell_width_2 * 0.5

			_stored_fallback_positions[k_2] = {
				pos = Vector3Box(Vector3(num_3, num_4, 0)),
				grid_pow_of = num
			}
			count = count + 1

			if k_2 ~= num then
				local num_5 = (num - 1) * 0.5 * cell_width + math.random() * cell_width_2 - cell_width_2 * 0.5
				local num_6 = (k_2 - 1 - (num - 1) * 0.5) * cell_width + math.random() * cell_width_2 - cell_width_2 * 0.5

				_stored_fallback_positions[num + k_2] = {
					pos = Vector3Box(Vector3(num_5, num_6, 0)),
					grid_pow_of = num
				}
				count = count + 1
			end
		end
	end

	local random = Math.random(1, count)
	local var_45_15 = _stored_fallback_positions[random]

	table.swap_delete(_stored_fallback_positions, random)

	_fallback_positions[arg_45_1] = var_45_15
	_fallback_position_data.n = _fallback_position_data.n + 1

	return var_45_15
end

AICommanderExtension._store_fallback_position = function (self, arg_46_1)
	-- function 46
	local _fallback_positions = self._fallback_positions

	if not _fallback_positions[arg_46_1] then
		local _stored_fallback_positions = self._stored_fallback_positions
		local _fallback_position_data = self._fallback_position_data
		local var_46_3 = _fallback_positions[arg_46_1]

		_fallback_positions[arg_46_1] = nil
		_fallback_position_data.n = _fallback_position_data.n - 1
		_stored_fallback_positions[#_stored_fallback_positions + 1] = var_46_3

		local n = _fallback_position_data.n
		local ceil

		if n > 0 then
			ceil = math.ceil(math.sqrt(n))

			if not ceil then
				-- Nothing
			end
		end

		ceil = 0

		::label_46_0::

		local grid_width = _fallback_position_data.grid_width

		_fallback_position_data.grid_width = ceil

		if ceil ~= grid_width then
			local cell_width = _fallback_position_data.cell_width

			for k, v in pairs(_fallback_positions) do
				if ceil < v.grid_pow_of then
					_fallback_positions[k] = nil
					_fallback_position_data.n = _fallback_position_data.n - 1
				else
					local pos = v.pos
					local unbox = pos:unbox()
					local num = cell_width * 0.5

					unbox[1] = unbox[1] + num
					unbox[2] = unbox[2] + num

					pos:store(unbox)
				end
			end

			local n_2 = _fallback_position_data.n
			local flag = not (n_2 > 0) or not math.ceil(math.sqrt(n_2)) or 0

			for k_2 = #_stored_fallback_positions, 1, -1 do
				local var_46_13 = _stored_fallback_positions[k_2]

				if flag < var_46_13.grid_pow_of then
					table.swap_delete(_stored_fallback_positions, k_2)
				else
					local pos_2 = var_46_13.pos
					local unbox_2 = pos_2:unbox()
					local num_2 = cell_width * 0.5

					unbox_2[1] = unbox_2[1] + num_2
					unbox_2[2] = unbox_2[2] + num_2

					pos_2:store(unbox_2)
				end
			end
		end
	end
end
