-- chunkname: @scripts/unit_extensions/camera/states/camera_state_observer.lua

local testify = script_data.testify

testify = not testify and require("scripts/unit_extensions/camera/states/camera_state_observer_testify")
CameraStateObserver = class(CameraStateObserver, CameraState)

CameraStateObserver.init = function (self, arg_1_1)
	-- function 1
	CameraState.init(self, arg_1_1, "observer")

	self._game_settings = Managers.state.game_mode:settings()
end

CameraStateObserver.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	self._observed_unit = nil
	self._network_transmit = arg_2_4.network_transmit
	self._is_server = arg_2_4.network_transmit.is_server
	self._default_observed_node_name = "camera_attach"

	local input_service_name = arg_2_7.input_service_name

	input_service_name = input_service_name or "Player"
	self._input_service_name = input_service_name
	self._has_read_camera_input = false
	self._observed_node_name = arg_2_7.override_observed_node or self._default_observed_node_name

	local override_follow_unit = arg_2_7.override_follow_unit

	override_follow_unit = override_follow_unit or self._observed_unit

	if not Unit.alive(override_follow_unit) then
		local node = Unit.node(override_follow_unit, self._observed_node_name)

		self:_set_observed_unit(override_follow_unit, node)
	else
		self:follow_next_unit(false)
	end

	Managers.state.event:trigger("camera_teleported")
end

CameraStateObserver.on_exit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	Managers.player:local_player():set_observed_unit(nil)
	Managers.state.event:trigger("camera_teleported")
end

CameraStateObserver.refresh_follow_unit = function (self, arg_4_1, arg_4_2)
	-- function 4
	self:_set_observed_unit(arg_4_1, arg_4_2)
end

local num = math.pi / 2 - math.pi / 15

CameraStateObserver.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local csm = self.csm
	local camera_extension = self.camera_extension
	local external_state_change = camera_extension.external_state_change
	local external_state_change_params = camera_extension.external_state_change_params

	if not (not external_state_change and external_state_change == self.name) then
		csm:change_state(external_state_change, external_state_change_params)
		camera_extension:set_external_state_change(nil)

		return
	end

	local get_service = Managers.input:get_service(self._input_service_name)
	local get = get_service:get("next_observer_target")

	get = get or not Unit.alive(self._observed_unit)

	local get_2 = get_service:get("previous_observer_target")

	if get or not get_2 then
		if not get then
			self:follow_next_unit(false)
		else
			self:follow_next_unit(true)
		end
	end

	if not CameraStateHelper.set_camera_rotation(arg_5_1, camera_extension) then
		self._has_read_camera_input = true
	end

	local _observed_unit = self._observed_unit

	if not Unit.alive(_observed_unit) then
		self._observed_unit = nil

		return
	end

	if not (self._has_read_camera_input or Managers.player:owner(_observed_unit)) then
		CameraStateHelper.set_camera_rotation_observe_static(arg_5_1, _observed_unit)
	end

	local _observed_node = self._observed_node
	local _snap_camera = self._snap_camera
	local world_position = Unit.world_position(_observed_unit, _observed_node)
	local flag = not Managers.player:is_player_unit(_observed_unit) and ScriptUnit.extension(_observed_unit, "status_system")

	if not flag then
		-- Nothing
	end

	::label_5_0::

	local is_hanging_from_hook = flag:is_hanging_from_hook()

	is_hanging_from_hook = is_hanging_from_hook or flag:is_grabbed_by_pack_master()

	::label_5_1::

	if not is_hanging_from_hook then
		world_position = Unit.world_position(_observed_unit, 0)
		world_position = world_position + Vector3(0, 0, 1.5)
	elseif not (_observed_node ~= 0 or Managers.player:owner(_observed_unit)) then
		world_position = world_position + Vector3(0, 0, 1.5)
	end

	CameraStateHelper.set_follow_camera_position(arg_5_1, world_position, nil, _snap_camera, arg_5_3)

	self._snap_camera = false

	if not script_data.testify then
		Testify:poll_requests_through_handler(testify, self)
	end
end

CameraStateObserver.follow_next_unit = function (self, arg_6_1)
	-- function 6
	local player = self.camera_extension.player
	local unique_id = player:unique_id()
	local get_side_from_player_unique_id = Managers.state.side:get_side_from_player_unique_id(unique_id)
	local get_valid_unit_to_observe = CameraStateHelper.get_valid_unit_to_observe(arg_6_1, get_side_from_player_unique_id, self._observed_unit, player)
	local flag = get_valid_unit_to_observe ~= self._observed_unit

	if not flag then
		local node

		if not Unit.alive(get_valid_unit_to_observe) and not Unit.has_node(get_valid_unit_to_observe, self._observed_node_name) then
			node = Unit.node(get_valid_unit_to_observe, self._observed_node_name)

			if not node then
				-- Nothing
			end
		end

		node = 0

		::label_6_0::

		self:_set_observed_unit(get_valid_unit_to_observe, node)
	end

	return get_valid_unit_to_observe, flag
end

CameraStateObserver._set_observed_unit = function (self, arg_7_1, arg_7_2)
	-- function 7
	self._observed_unit = arg_7_1

	if arg_7_2 or not arg_7_1 then
		-- Nothing
	end

	do
		local node
	end

	::label_7_1::

	if not Unit.has_node(arg_7_1, self._default_observed_node_name) then
		node = Unit.node(arg_7_1, self._default_observed_node_name)

		if not node then
			-- Nothing
		end
	end

	node = 0

	::label_7_2::

	self._observed_node = node

	if not Unit.alive(arg_7_1) then
		return false
	end

	local var_7_1
	local unit = self.unit
	local viewport_name = self.camera_extension.viewport_name
	local normalize = Vector3.normalize(Vector3.flat(Quaternion.forward(Unit.local_rotation(arg_7_1, 0))))
	local atan2 = math.atan2(normalize.y, normalize.x)

	Managers.state.camera:set_pitch_yaw(viewport_name, -0.6, atan2)
	Unit.set_data(unit, "camera", "settings_node", "observer")

	local world_position = Unit.world_position(unit, 0)
	local world_position_2 = Unit.world_position(arg_7_1, 0)

	if Vector3.distance(world_position, world_position_2) > 50 then
		var_7_1 = true
	end

	self._snap_camera = var_7_1

	local player = self.camera_extension.player

	player:set_observed_unit(arg_7_1)

	if not self._is_server then
		local local_player_id = player:local_player_id()
		local game_object_or_level_id, var_7_11 = Managers.state.network:game_object_or_level_id(arg_7_1)

		game_object_or_level_id = game_object_or_level_id or NetworkConstants.invalid_game_object_id

		local flag = not not var_7_11

		self._network_transmit:send_rpc_server("rpc_set_observed_unit", local_player_id, game_object_or_level_id, flag)
	end

	self._has_read_camera_input = false

	return true
end
