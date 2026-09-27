-- chunkname: @scripts/helpers/camera_carrier.lua

CameraCarrier = class(CameraCarrier)
CameraCarrier.CAMERA_CARRIER_REEVALUATE_PERIOD = 10

CameraCarrier.init = function (self)
	-- function 1
	self._carrier_camera_unit = nil
	self._camera_carrier_unique_id = nil
	self._camera_carrier_linked = false
	self._time_since_reevaluate_camera_carrier = 0
end

CameraCarrier.destroy = function (self)
	-- function 2
	if self._carrier_camera_unit ~= nil then
		self:_detach_carrier_camera()
		self:_destroy_carrier_camera()
	end
end

CameraCarrier.update = function (self, arg_3_1)
	-- function 3
	if not DEDICATED_SERVER then
		return
	end

	self._time_since_reevaluate_camera_carrier = self._time_since_reevaluate_camera_carrier + arg_3_1

	if self._time_since_reevaluate_camera_carrier > CameraCarrier.CAMERA_CARRIER_REEVALUATE_PERIOD then
		self:_reevaluate_camera_carrier()
	end
end

CameraCarrier._reevaluate_camera_carrier = function (self)
	-- function 4
	self._time_since_reevaluate_camera_carrier = 0

	if not DEDICATED_SERVER then
		return
	end

	local _best_suited_camera_carrier = self:_best_suited_camera_carrier()

	if not self._camera_carrier_linked then
		if Managers.player:player_from_unique_id(self._camera_carrier_unique_id) == _best_suited_camera_carrier then
			return
		end

		self:_detach_carrier_camera()
	end

	if _best_suited_camera_carrier == nil then
		return
	end

	print(string.format("Switching camera carrier to %s", _best_suited_camera_carrier:name()))
	self:_attach_carrier_camera(_best_suited_camera_carrier)
end

CameraCarrier._create_carrier_camera = function (self)
	-- function 5
	assert(self._carrier_camera_unit == nil)
	assert(DEDICATED_SERVER)

	local backlit_camera = DefaultUnits.standard.backlit_camera
	local zero = Vector3.zero()
	local identity = Quaternion.identity()

	self._carrier_camera_unit = Managers.state.unit_spawner:spawn_local_unit(backlit_camera, zero, identity)
end

CameraCarrier._destroy_carrier_camera = function (self)
	-- function 6
	assert(self._carrier_camera_unit ~= nil)
	assert(DEDICATED_SERVER)
	Managers.state.unit_spawner:mark_for_deletion(self._carrier_camera_unit)

	self._carrier_camera_unit = nil
	self._camera_carrier_unique_id = nil
end

CameraCarrier._attach_carrier_camera = function (self, arg_7_1)
	-- function 7
	assert(DEDICATED_SERVER)
	assert(arg_7_1 ~= nil)

	if arg_7_1.player_unit == nil then
		print(string.format("Failed to switching camera carrier to %s since there is no unit", arg_7_1:name()))

		return
	end

	if not Unit.alive(arg_7_1.player_unit) then
		print(string.format("Failed to switching camera carrier to %s since the player unit is not alive", arg_7_1:name()))

		return
	end

	if self._carrier_camera_unit == nil then
		self:_create_carrier_camera()
	end

	local world = Unit.world(arg_7_1.player_unit)

	World.link_unit(world, self._carrier_camera_unit, arg_7_1.player_unit)

	self._camera_carrier_unique_id = arg_7_1:profile_id()
	self._camera_carrier_linked = true
end

CameraCarrier._detach_carrier_camera = function (self)
	-- function 8
	assert(DEDICATED_SERVER)
	assert(self._carrier_camera_unit ~= nil)

	if not self._camera_carrier_linked then
		return
	end

	local world = Unit.world(self._carrier_camera_unit)

	World.unlink_unit(world, self._carrier_camera_unit)

	self._camera_carrier_linked = false
end

CameraCarrier._most_ahead_player = function (arg_9_0)
	-- function 9
	local conflict = Managers.state.conflict

	if conflict == nil then
		return nil
	end

	local ahead_unit = conflict.main_path_info.ahead_unit

	return Managers.player:unit_owner(ahead_unit)
end

CameraCarrier._best_suited_camera_carrier = function (self)
	-- function 10
	local _most_ahead_player = self:_most_ahead_player()

	if _most_ahead_player ~= nil then
		return _most_ahead_player
	end

	local leader = Managers.party:leader()
	local players_at_peer = Managers.player:players_at_peer(leader)

	if players_at_peer == nil then
		return nil
	end

	return players_at_peer[1]
end
