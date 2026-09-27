-- chunkname: @scripts/unit_extensions/camera/states/camera_state_observer_spectator.lua

CameraStateObserverSpectator = class(CameraStateObserverSpectator, CameraStateObserver)

local tbl = {
	"third_person",
	"first_person"
}
local tbl_2 = {
	"free",
	"follow",
	"locked"
}

CameraStateObserverSpectator.on_enter = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7)
	-- function 1
	self._current_view_id = 1
	self._num_views = #tbl
	self._locked_rotation = false
	self._follow_rotation = false
	self._offset_scale = 0.5
	self._camera_offset = 0
	self._rotation_state = tbl_2[1]
	self._rotation_state_index = 1
	self._current_view = tbl[1]
	self._pinged_units = {}

	local PLAYER_AND_BOT_UNITS = Managers.state.side:get_side_from_name("dark_pact").PLAYER_AND_BOT_UNITS

	for i, v in ipairs(PLAYER_AND_BOT_UNITS) do
		if not ALIVE[v] then
			local extension = ScriptUnit.extension(v, "ghost_mode_system")

			if not extension:is_in_ghost_mode() then
				extension:husk_leave_ghost_mode(true)
				extension:husk_enter_ghost_mode()
			end
		end
	end

	CameraStateObserver.on_enter(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7)

	if not self._observed_unit then
		Managers.state.event:trigger("on_spectator_target_changed", self._observed_unit)
	end
end

local num = math.pi / 2 - math.pi / 15

CameraStateObserverSpectator.update = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	local csm = self.csm
	local camera_extension = self.camera_extension
	local external_state_change = camera_extension.external_state_change
	local external_state_change_params = camera_extension.external_state_change_params

	if not (not external_state_change and external_state_change == self.name) then
		csm:change_state(external_state_change, external_state_change_params)
		camera_extension:set_external_state_change(nil)

		return
	end

	local input = Managers.input
	local get_service = input:get_service("Player")
	local get = get_service:get("next_observer_target")
	local get_2 = get_service:get("previous_observer_target")
	local alive = Unit.alive(self._observed_unit)
	local _observed_unit = self._observed_unit
	local flag = false

	if not alive and not get then
		_observed_unit, flag = self:follow_next_unit(false)
	elseif not get_2 then
		_observed_unit, flag = self:follow_next_unit(true)
	end

	if not flag then
		Managers.state.event:trigger("on_spectator_target_changed", self._observed_unit)
	elseif not Unit.alive(_observed_unit) then
		csm:change_state("idle")

		return
	end

	local y = get_service:get("observer_change_offset").y

	if y ~= 0 then
		self._camera_offset = math.clamp(self._camera_offset + y * self._offset_scale, 0, 5)
	end

	local camera = Managers.state.camera
	local viewport_name = camera_extension.viewport_name
	local get_3

	if not input:is_device_active("gamepad") then
		get_3 = get_service:get("look_controller_3p")

		if not get_3 then
			-- Nothing
		end
	end

	get_3 = get_service:get("look")

	::label_2_0::

	local var_2_15 = Vector3(0, 0, 0)

	if not get_3 then
		local num_2

		if not camera:has_viewport(viewport_name) then
			num_2 = camera:fov(viewport_name) / 0.785

			if not num_2 then
				-- Nothing
			end
		end

		num_2 = 1

		::label_2_1::

		var_2_15 = var_2_15 + get_3 * num_2
	end

	local get_4 = get_service:get("next_observer_rotation_state")
	local get_5 = get_service:get("previous_observer_rotation_state")

	if not get_4 then
		self._rotation_state_index = self._rotation_state_index % #tbl_2 + 1
		self._rotation_state = tbl_2[self._rotation_state_index]
	elseif not get_5 then
		self._rotation_state_index = (self._rotation_state_index - 2) % #tbl_2 + 1
		self._rotation_state = tbl_2[self._rotation_state_index]
	end

	local local_rotation = Unit.local_rotation(arg_2_1, 0)
	local clamp = math.clamp(Quaternion.pitch(local_rotation) + var_2_15.y, -num, num)
	local var_2_21 = Quaternion(Vector3.right(), clamp)
	local var_2_22

	if self._rotation_state == "follow" then
		var_2_22 = Unit.local_rotation(_observed_unit, 0)
		var_2_22 = Quaternion.multiply(var_2_22, var_2_21)
	elseif self._rotation_state == "locked" then
		-- Nothing
	else
		local num_3 = Quaternion.yaw(local_rotation) - var_2_15.x
		local var_2_24 = Quaternion(Vector3.up(), num_3)

		var_2_22 = Quaternion.multiply(var_2_24, var_2_21)
	end

	if not var_2_22 then
		Unit.set_local_rotation(arg_2_1, 0, var_2_22)
	end

	local node = Unit.node(_observed_unit, self._observed_node_name)
	local num_4 = Unit.world_position(_observed_unit, node) + Vector3(0, 0, self._camera_offset)
	local world_position = Unit.world_position(arg_2_1, 0)
	local min = math.min(arg_2_3 * 10, 1)
	local lerp = Vector3.lerp(world_position, num_4, min)

	if not self._snap_camera then
		lerp = num_4
		self._snap_camera = false

		Managers.state.event:trigger("camera_teleported")
	end

	fassert(Vector3.is_valid(lerp), "Camera position invalid.")
	Unit.set_local_position(arg_2_1, 0, lerp)
end
