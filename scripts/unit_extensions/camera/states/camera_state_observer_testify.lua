-- chunkname: @scripts/unit_extensions/camera/states/camera_state_observer_testify.lua

return {
	set_camera_to_observe_first_bot = function (arg_1_0)
		local var_1_0 = Managers.player:bots()[1]
		local var_1_1 = Managers.party:get_party_from_unique_id(var_1_0:unique_id())
		local var_1_2 = Managers.state.side.side_by_party[var_1_1] or Managers.state.side:get_side_from_name("heroes")

		if var_1_2 then
			local var_1_3 = CameraStateHelper.get_valid_unit_to_observe(true, var_1_2, var_1_0.player_unit)

			arg_1_0:refresh_follow_unit(var_1_3)
		end
	end
}
