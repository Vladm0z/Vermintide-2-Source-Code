-- chunkname: @scripts/unit_extensions/camera/generic_camera_extension.lua

GenericCameraExtension = class(GenericCameraExtension)

GenericCameraExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.unit = arg_1_2
	self.player = arg_1_3.player
	self.viewport_name = self.player.viewport_name
	self.idle_position = Vector3Box(0, 0, 0)
	self.idle_rotation = QuaternionBox(Quaternion.identity())
	self.external_state_change = nil
	self.external_state_change_params = nil
end

GenericCameraExtension.extensions_ready = function (arg_2_0)
	-- function 2
	return
end

GenericCameraExtension.update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if not (not self._delayed_state_change and not (arg_3_5 > self._delayed_state_change_t)) then
		self:set_external_state_change(self._delayed_state_change, self._delayed_state_change_params)
	end

	local override_follow_unit = self.override_follow_unit

	if not (not override_follow_unit and Unit.alive(override_follow_unit)) then
		self:set_follow_unit(nil, nil)
	end
end

GenericCameraExtension.set_external_state_change = function (self, arg_4_1, arg_4_2)
	-- function 4
	self.external_state_change = arg_4_1
	self.external_state_change_params = arg_4_2
	self._delayed_state_change = nil
	self._delayed_state_change_t = nil
	self._delayed_state_change_params = nil
end

GenericCameraExtension.set_delayed_external_state_change = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	self._delayed_state_change = arg_5_1
	self._delayed_state_change_t = arg_5_3
	self._delayed_state_change_params = arg_5_2
end

GenericCameraExtension.set_idle_position = function (self, arg_6_1)
	-- function 6
	local viewport_name = self.viewport_name

	assert(Vector3.is_valid(arg_6_1), "Trying to set invalid camera position")
	self.idle_position:store(arg_6_1)
end

GenericCameraExtension.set_idle_rotation = function (self, arg_7_1)
	-- function 7
	local viewport_name = self.viewport_name

	self.idle_rotation:store(arg_7_1)
end

GenericCameraExtension.get_idle_position = function (self)
	-- function 8
	return self.idle_position:unbox()
end

GenericCameraExtension.get_idle_rotation = function (self)
	-- function 9
	return self.idle_rotation:unbox()
end

GenericCameraExtension.set_follow_unit = function (self, arg_10_1, arg_10_2)
	-- function 10
	self.override_follow_unit = arg_10_1

	local node

	if not arg_10_2 then
		node = Unit.node(arg_10_1, arg_10_2)

		if not node then
			-- Nothing
		end
	end

	node = nil

	::label_10_0::

	self.override_follow_node = node
end

GenericCameraExtension.get_follow_data = function (self)
	-- function 11
	local player = self.player
	local player_unit = player.player_unit
	local var_11_2
	local var_11_3

	if not player.respawning then
		return
	end

	if not self.override_follow_unit then
		return self.override_follow_unit, self.override_follow_node
	elseif not player_unit and not ScriptUnit.has_extension(player_unit, "first_person_system") then
		var_11_2 = ScriptUnit.extension(player_unit, "first_person_system"):get_first_person_unit()
		var_11_3 = Unit.node(var_11_2, "camera_node")
	end

	return var_11_2, var_11_3
end

GenericCameraExtension.destroy = function (arg_12_0)
	-- function 12
	return
end
