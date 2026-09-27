-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_demo.lua

require("scripts/managers/game_mode/game_modes/game_mode_base")

local script_data = script_data
local disable_gamemode_end = script_data.disable_gamemode_end

disable_gamemode_end = disable_gamemode_end or Development.parameter("disable_gamemode_end")
script_data.disable_gamemode_end = disable_gamemode_end
GameModeDemo = class(GameModeDemo, GameModeBase)

local flag = false
local flag_2 = false

GameModeDemo.init = function (arg_1_0, arg_1_1, arg_1_2, ...)
	-- function 1
	GameModeDemo.super.init(arg_1_0, arg_1_1, arg_1_2, ...)
end

GameModeDemo.evaluate_end_conditions = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local flag_3 = true
	local side_is_dead = GameModeHelper.side_is_dead("heroes", flag_3)
	local side_is_disabled = GameModeHelper.side_is_disabled("heroes")

	if not (side_is_dead or side_is_disabled) then
		-- Nothing
	end

	::label_2_1::

	local _level_failed = self._level_failed

	_level_failed = _level_failed or self:_is_time_up()

	::label_2_2::

	if self._level_completed or _level_failed or not self:update_end_level_areas() then
		self:complete_level()

		flag = false
		flag_2 = false
	end
end

GameModeDemo.complete_level = function (self)
	-- function 3
	if self._transition ~= "demo_completed" then
		if not script_data.disable_video_player then
			self._transition = "return_to_demo_title_screen"
		else
			self._transition = "demo_completed"
		end

		Managers.music:trigger_event("Play_stinger_ending_demo")
		Managers.time:set_global_time_scale(1)

		local _world = self._world
		local wwise_world = Managers.world:wwise_world(_world)

		WwiseWorld.set_global_parameter(wwise_world, "demo_slowmo", 0)
	end
end

GameModeDemo.ended = function (self, arg_4_1)
	-- function 4
	if not self._network_server:are_all_peers_ingame() then
		self._network_server:disconnect_joining_peers()
	end
end

GameModeDemo.wanted_transition = function (self)
	-- function 5
	return self._transition
end

GameModeDemo.COMPLETE_LEVEL = function (arg_6_0)
	-- function 6
	flag = true
end

GameModeDemo.FAIL_LEVEL = function (arg_7_0)
	-- function 7
	flag_2 = true
end
