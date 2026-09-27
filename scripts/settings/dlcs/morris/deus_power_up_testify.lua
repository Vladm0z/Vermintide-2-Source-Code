-- chunkname: @scripts/settings/dlcs/morris/deus_power_up_testify.lua

require("scripts/settings/dlcs/morris/deus_power_up_settings")

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	Testify:make_request("start_terror_event", arg_1_1)

	while not Testify:make_request("terror_event_finished", arg_1_1) do
		Testify:make_request("make_players_invicible")
		Testify:make_request("set_player_unit_not_visible")
		Testify:make_request("set_camera_to_observe_first_bot")

		local point_on_mainpath = MainPathUtils.point_on_mainpath(nil, arg_1_2)
		local get_spawn_pos_on_circle = ConflictUtils.get_spawn_pos_on_circle(arg_1_0, point_on_mainpath, 7, 7, 15)

		if not get_spawn_pos_on_circle then
			local var_1_2 = Vector3Box(get_spawn_pos_on_circle)

			Testify:make_request("teleport_player_to_position", var_1_2)
		end

		Testify:make_request("teleport_bots_forward_on_main_path_if_blocked", arg_1_3)

		if not Testify:make_request("level_end_screen_displayed") then
			if not Testify:make_request("has_lost") then
				Testify:make_request("fail_test", "Test failed due to players/bot dying to the AI")
			else
				Testify:make_request("fail_test", "Test failed due to level ending before terror event finished")
			end
		end

		local clock = os.clock()

		while os.clock() < clock + 2 do
			Testify:make_request("update_camera_to_follow_first_bot_rotation")
		end
	end

	Testify:make_request("reset_terror_event_mixer")
end

DeusPowerUpTests = {
	default = fn
}
