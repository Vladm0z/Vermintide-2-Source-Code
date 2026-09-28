-- chunkname: @scripts/unit_extensions/camera/states/camera_state_observer.lua

local testify = script_data.testify

if testify then
	-- Nothing
end

testify = require("scripts/unit_extensions/camera/states/camera_state_observer_testify")

local camera_state_observer_testify = testify

::label_0_0::

CameraStateObserver = class(CameraStateObserver, CameraState)

CameraStateObserver.init = function (self, camera_state_init_context)
	-- function 1
	CameraState.init(self, camera_state_init_context, "observer")

	self._game_settings = Managers.state.game_mode:settings()
end

CameraStateObserver.on_enter = function (self, unit, input, dt, context, t, previous_state, params)
	-- function 2
	self._observed_unit = nil
	self._network_transmit = context.network_transmit
	self._is_server = context.network_transmit.is_server
	self._default_observed_node_name = "camera_attach"

	local input_service_name = params.input_service_name

	input_service_name = not not input_service_name or not not "Player"
	self._input_service_name = input_service_name
	self._has_read_camera_input = false

	local override_observed_node = params.override_observed_node

	self._observed_node_name = not not override_observed_node or not not self._default_observed_node_name

	local override_follow_unit = params.override_follow_unit

	if not override_follow_unit then
		-- Nothing
	end

	override_follow_unit = self._observed_unit

	local observed_unit = override_follow_unit

	::label_2_0::

	if Unit.alive(observed_unit) then
		local observed_node = Unit.node(observed_unit, self._observed_node_name)

		self:_set_observed_unit(observed_unit, observed_node)
	else
		self:follow_next_unit(false)
	end

	Managers.state.event:trigger("camera_teleported")
end

CameraStateObserver.on_exit = function (self, unit, input, dt, context, t, next_state)
	-- function 3
	Managers.player:local_player():set_observed_unit(nil)
	Managers.state.event:trigger("camera_teleported")
end

CameraStateObserver.refresh_follow_unit = function (self, follow_unit, follow_node)
	-- function 4
	self:_set_observed_unit(follow_unit, follow_node)
end

local MAX_MIN_PITCH = math.pi / 2 - math.pi / 15

CameraStateObserver.update = function (self, unit, input, dt, context, t)
	-- function 5
	local csm = self.csm
	local camera_extension = self.camera_extension
	local external_state_change = camera_extension.external_state_change
	local external_state_change_params = camera_extension.external_state_change_params

	if external_state_change and external_state_change ~= self.name then
		csm:change_state(external_state_change, external_state_change_params)
		camera_extension:set_external_state_change(nil)

		return
	end

	local input_source = Managers.input:get_service(self._input_service_name)
	local get = input_source:get("next_observer_target")

	if not get then
		-- Nothing
	end

	get = not Unit.alive(self._observed_unit)

	local find_next_observer_target = get

	::label_5_0::

	local find_previous_observer_target = input_source:get("previous_observer_target")

	if find_next_observer_target or find_previous_observer_target then
		if find_next_observer_target then
			self:follow_next_unit(false)
		else
			self:follow_next_unit(true)
		end
	end

	local manually_moved_camera = CameraStateHelper.set_camera_rotation(unit, camera_extension)

	if manually_moved_camera then
		self._has_read_camera_input = true
	end

	local observed_unit = self._observed_unit

	if not Unit.alive(observed_unit) then
		self._observed_unit = nil

		return
	end

	if not self._has_read_camera_input and not Managers.player:owner(observed_unit) then
		CameraStateHelper.set_camera_rotation_observe_static(unit, observed_unit)
	end

	local observed_node = self._observed_node
	local snap_camera = self._snap_camera
	local position = Unit.world_position(observed_unit, observed_node)
	local is_player = Managers.player:is_player_unit(observed_unit)
	local observed_unit_status = not not is_player and not not ScriptUnit.extension(observed_unit, "status_system")

	if observed_unit_status then
		-- Nothing
	end

	::label_5_1::

	local is_hanging_from_hook = observed_unit_status:is_hanging_from_hook()

	if not is_hanging_from_hook then
		-- Nothing
	end

	is_hanging_from_hook = observed_unit_status:is_grabbed_by_pack_master()

	local is_hoisted = is_hanging_from_hook

	::label_5_2::

	if is_hoisted then
		position = Unit.world_position(observed_unit, 0)
		position = position + Vector3(0, 0, 1.5)
	elseif observed_node == 0 and not Managers.player:owner(observed_unit) then
		position = position + Vector3(0, 0, 1.5)
	end

	CameraStateHelper.set_follow_camera_position(unit, position, nil, snap_camera, dt)

	self._snap_camera = false

	if script_data.testify then
		Testify:poll_requests_through_handler(camera_state_observer_testify, self)
	end
end

CameraStateObserver.follow_next_unit = function (self, reverse)
	-- function 6
	local player = self.camera_extension.player
	local unique_id = player:unique_id()
	local player_side = Managers.state.side:get_side_from_player_unique_id(unique_id)
	local next_unit = CameraStateHelper.get_valid_unit_to_observe(reverse, player_side, self._observed_unit, player)
	local new_target = next_unit ~= self._observed_unit

	if new_target then
		local node

		if Unit.alive(next_unit) and Unit.has_node(next_unit, self._observed_node_name) then
			node = Unit.node(next_unit, self._observed_node_name)

			if not node then
				-- Nothing
			end
		end

		node = 0

		local observed_node = node

		::label_6_0::

		self:_set_observed_unit(next_unit, observed_node)
	end

	return next_unit, new_target
end

CameraStateObserver._set_observed_unit = function (self, observed_unit, observed_node)
	-- function 7
	self._observed_unit = observed_unit

	if not observed_node and observed_unit then
		-- Nothing
	end

	do
		local node
	end

	::label_7_1::

	if Unit.has_node(observed_unit, self._default_observed_node_name) then
		node = Unit.node(observed_unit, self._default_observed_node_name)

		if not node then
			-- Nothing
		end
	end

	node = 0

	::label_7_2::

	self._observed_node = node

	if not Unit.alive(observed_unit) then
		return false
	end

	local snap_camera
	local unit = self.unit
	local camera_extension = self.camera_extension
	local viewport_name = camera_extension.viewport_name
	local root_look_dir = Vector3.normalize(Vector3.flat(Quaternion.forward(Unit.local_rotation(observed_unit, 0))))
	local yaw = math.atan2(root_look_dir.y, root_look_dir.x)
	local camera_manager = Managers.state.camera

	camera_manager:set_pitch_yaw(viewport_name, -0.6, yaw)
	Unit.set_data(unit, "camera", "settings_node", "observer")

	local current_position = Unit.world_position(unit, 0)
	local observed_unit_position = Unit.world_position(observed_unit, 0)
	local distance = Vector3.distance(current_position, observed_unit_position)

	if distance > 50 then
		snap_camera = true
	end

	self._snap_camera = snap_camera

	local player = self.camera_extension.player

	player:set_observed_unit(observed_unit)

	if not self._is_server then
		local local_player_id = player:local_player_id()
		local observed_unit_id, is_level_unit = Managers.state.network:game_object_or_level_id(observed_unit)

		observed_unit_id = not not observed_unit_id or not not NetworkConstants.invalid_game_object_id
		is_level_unit = not not is_level_unit

		self._network_transmit:send_rpc_server("rpc_set_observed_unit", local_player_id, observed_unit_id, is_level_unit)
	end

	self._has_read_camera_input = false

	return true
end
