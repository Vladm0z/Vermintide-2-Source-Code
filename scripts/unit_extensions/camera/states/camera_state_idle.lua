-- chunkname: @scripts/unit_extensions/camera/states/camera_state_idle.lua

CameraStateIdle = class(CameraStateIdle, CameraState)

CameraStateIdle.init = function (arg_1_0, arg_1_1)
	-- function 1
	CameraState.init(arg_1_0, arg_1_1, "idle")
end

CameraStateIdle.on_enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	return
end

CameraStateIdle.on_exit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	return
end

CameraStateIdle.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local csm = self.csm
	local unit = self.unit
	local camera_extension = self.camera_extension
	local get_follow_data, var_4_4 = camera_extension:get_follow_data()

	if not get_follow_data then
		csm:change_state("follow")

		return
	end

	local external_state_change = camera_extension.external_state_change
	local external_state_change_params = camera_extension.external_state_change_params

	if not (not external_state_change and external_state_change == self.name) then
		csm:change_state(external_state_change, external_state_change_params)
		camera_extension:set_external_state_change(nil)

		return
	end

	local unique_id = self.camera_extension.player:unique_id()
	local get_side_from_player_unique_id = Managers.state.side:get_side_from_player_unique_id(unique_id)

	if (not get_side_from_player_unique_id and get_side_from_player_unique_id:name()) == "spectators" then
		csm:change_state("observer")

		return
	end

	local get_idle_position = camera_extension:get_idle_position()
	local get_idle_rotation = camera_extension:get_idle_rotation()

	assert(Vector3.is_valid(get_idle_position), "Camera position invalid.")
	Unit.set_local_position(unit, 0, get_idle_position)
	Unit.set_local_rotation(unit, 0, get_idle_rotation)
end
