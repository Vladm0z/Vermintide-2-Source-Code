-- chunkname: @scripts/ui/hud_ui/dark_pact_climbing_ui.lua

local num = 50
local num_2 = 250
local num_3 = 0.5
local num_4 = 400

DarkPactClimbingUI = class(DarkPactClimbingUI)

DarkPactClimbingUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._local_player = arg_1_2.player
	self._raycast_frame_counter = 0
	self._world_markers_spawned = {}
	self._next_distance_check_time = -math.huge
	self._previous_position_box = Vector3Box(math.huge, math.huge, math.huge)
	self._broadphase_results = {}
	self._keep_marker_lookup = {}
	self._visible = true
	self._are_climb_units_registered = false

	self:_initialize_broadphase()
	self:_initialize_camera()
end

DarkPactClimbingUI.destroy = function (self)
	-- function 2
	if not self._markers_cleared then
		self:_clear_world_markers()
	end
end

DarkPactClimbingUI._register_climb_units = function (self)
	-- function 3
	local entity = Managers.state.entity
	local system = entity:system("door_system")

	self:_add_units_to_broadphase("tunneling", system:get_crawl_space_tunnel_units())
	self:_add_units_to_broadphase("spawning", system:get_crawl_space_spawner_units())

	local level_jump_units = entity:system("nav_graph_system"):level_jump_units()

	if not level_jump_units then
		self:_add_units_to_broadphase("climbing", table.keys(level_jump_units))
	end

	self._are_climb_units_registered = true
end

DarkPactClimbingUI._add_units_to_broadphase = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not arg_4_2 then
		return
	end

	for i, v in ipairs(arg_4_2) do
		if not (not Unit.alive(v) and self._broadphase_types[v]) then
			Broadphase.add(self._broadphase, v, Unit.world_position(v, 0), 1)

			self._broadphase_types[v] = arg_4_1
		end
	end
end

DarkPactClimbingUI._initialize_broadphase = function (self)
	-- function 5
	self._broadphase = Broadphase(num, num_2)
	self._broadphase_types = {}
end

DarkPactClimbingUI._initialize_camera = function (self)
	-- function 6
	local str = "player_1"
	local world = Managers.world:world("level_world")

	if not Managers.state.camera:has_viewport(str) then
		self._camera = ScriptViewport.camera(ScriptWorld.viewport(world, str))
	end
end

DarkPactClimbingUI._broadphase_check = function (self, arg_7_1)
	-- function 7
	local _broadphase_results = self._broadphase_results

	table.clear(_broadphase_results)

	local query = Broadphase.query(self._broadphase, arg_7_1, num, _broadphase_results)

	return _broadphase_results, query
end

DarkPactClimbingUI.update = function (self, arg_8_1, arg_8_2)
	-- function 8
	if not self._are_climb_units_registered then
		return
	end

	if not (not self._visible and Unit.alive(self._local_player.player_unit)) then
		if not self._markers_cleared then
			self:_clear_world_markers()
		end

		return
	end

	local _camera = self._camera

	if not _camera then
		return
	end

	if arg_8_2 < self._next_distance_check_time then
		return
	end

	self._next_distance_check_time = arg_8_2 + num_3

	local local_position = Camera.local_position(_camera)
	local _previous_position_box = self._previous_position_box

	if Vector3.distance_squared(_previous_position_box:unbox(), local_position) < num_4 then
		return
	end

	_previous_position_box:store(local_position)

	local _broadphase_check, var_8_4 = self:_broadphase_check(local_position)
	local event = Managers.state.event

	for i = 1, var_8_4 do
		local var_8_6 = _broadphase_check[i]

		if not self:_has_marker_for_unit(var_8_6) then
			event:trigger("add_world_marker_unit", self._broadphase_types[var_8_6], var_8_6, callback(self, "cb_world_marker_spawned", var_8_6))
		end

		self._keep_marker_lookup[var_8_6] = true
	end

	self:_clear_world_markers_except(self._keep_marker_lookup)
	table.clear(self._keep_marker_lookup)
end

DarkPactClimbingUI._has_marker_for_unit = function (self, arg_9_1)
	-- function 9
	return self._world_markers_spawned[arg_9_1]
end

DarkPactClimbingUI._clear_world_markers = function (self)
	-- function 10
	local _world_markers_spawned = self._world_markers_spawned
	local event = Managers.state.event

	for k, v in pairs(_world_markers_spawned) do
		event:trigger("event_remove_world_marker", v)

		_world_markers_spawned[k] = nil
	end

	self._markers_cleared = true
end

DarkPactClimbingUI._clear_world_markers_except = function (self, arg_11_1)
	-- function 11
	local _world_markers_spawned = self._world_markers_spawned
	local event = Managers.state.event

	for k, v in pairs(_world_markers_spawned) do
		if not arg_11_1[k] then
			event:trigger("event_remove_world_marker", _world_markers_spawned[k])

			_world_markers_spawned[k] = nil
		end
	end
end

DarkPactClimbingUI.cb_world_marker_spawned = function (self, arg_12_1, arg_12_2)
	-- function 12
	self._world_markers_spawned[arg_12_1] = arg_12_2
	self._markers_cleared = false
end

DarkPactClimbingUI.set_visible = function (self, arg_13_1)
	-- function 13
	self._visible = arg_13_1

	if not arg_13_1 then
		self:_initialize_camera()
		self:_initialize_broadphase()
		self:_register_climb_units()
	end
end
