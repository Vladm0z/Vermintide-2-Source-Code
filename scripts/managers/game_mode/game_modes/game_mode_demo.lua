-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_demo.lua

require("scripts/managers/game_mode/game_modes/game_mode_base")

script_data.disable_gamemode_end = script_data.disable_gamemode_end or Development.parameter("disable_gamemode_end")
GameModeDemo = class(GameModeDemo, GameModeBase)

local var_0_0 = false
local var_0_1 = false

GameModeDemo.init = function (arg_1_0, arg_1_1, arg_1_2, ...)
	GameModeDemo.super.init(arg_1_0, arg_1_1, arg_1_2, ...)
end

GameModeDemo.evaluate_end_conditions = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = true
	local var_2_1 = GameModeHelper.side_is_dead("heroes", var_2_0)
	local var_2_2 = GameModeHelper.side_is_disabled("heroes")
	local var_2_3 = var_2_1 or var_2_2 or arg_2_0._level_failed or arg_2_0:_is_time_up()

	if arg_2_0._level_completed or var_2_3 or arg_2_0:update_end_level_areas() then
		arg_2_0:complete_level()

		var_0_0 = false
		var_0_1 = false
	end
end

GameModeDemo.complete_level = function (arg_3_0)
	if arg_3_0._transition ~= "demo_completed" then
		if script_data.disable_video_player then
			arg_3_0._transition = "return_to_demo_title_screen"
		else
			arg_3_0._transition = "demo_completed"
		end

		Managers.music:trigger_event("Play_stinger_ending_demo")
		Managers.time:set_global_time_scale(1)

		local var_3_0 = arg_3_0._world
		local var_3_1 = Managers.world:wwise_world(var_3_0)

		WwiseWorld.set_global_parameter(var_3_1, "demo_slowmo", 0)
	end
end

GameModeDemo.ended = function (arg_4_0, arg_4_1)
	if not arg_4_0._network_server:are_all_peers_ingame() then
		arg_4_0._network_server:disconnect_joining_peers()
	end
end

GameModeDemo.wanted_transition = function (arg_5_0)
	return arg_5_0._transition
end

GameModeDemo.COMPLETE_LEVEL = function (arg_6_0)
	var_0_0 = true
end

GameModeDemo.FAIL_LEVEL = function (arg_7_0)
	var_0_1 = true
end
