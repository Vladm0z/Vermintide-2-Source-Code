-- chunkname: @scripts/unit_extensions/camera/states/camera_state_observer_testify.lua

return {
	set_camera_to_observe_first_bot = function (self)
		-- function 1
		local var_1_0 = Managers.player:bots()[1]
		local get_party_from_unique_id = Managers.party:get_party_from_unique_id(var_1_0:unique_id())
		local var_1_2 = Managers.state.side.side_by_party[get_party_from_unique_id]

		var_1_2 = var_1_2 or Managers.state.side:get_side_from_name("heroes")

		if not var_1_2 then
			local get_valid_unit_to_observe = CameraStateHelper.get_valid_unit_to_observe(true, var_1_2, var_1_0.player_unit)

			self:refresh_follow_unit(get_valid_unit_to_observe)
		end
	end
}
