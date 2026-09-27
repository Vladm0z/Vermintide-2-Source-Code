-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_survival.lua

require("scripts/managers/game_mode/game_modes/game_mode_base")

local script_data = script_data
local disable_gamemode_end = script_data.disable_gamemode_end

disable_gamemode_end = disable_gamemode_end or Development.parameter("disable_gamemode_end")
script_data.disable_gamemode_end = disable_gamemode_end
GameModeSurvival = class(GameModeSurvival, GameModeBase)

local flag = false
local flag_2 = false

GameModeSurvival.init = function (self, arg_1_1, arg_1_2, ...)
	-- function 1
	GameModeSurvival.super.init(self, arg_1_1, arg_1_2, ...)

	self._lost_condition_timer = nil
end

GameModeSurvival.evaluate_end_conditions = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	if not script_data.disable_gamemode_end then
		return false
	end

	local flag_3 = true
	local side_is_dead = GameModeHelper.side_is_dead("heroes", flag_3)
	local side_is_disabled = GameModeHelper.side_is_disabled("heroes")
	local _level_failed

	if not self._lose_condition_disabled then
		if not (side_is_dead or side_is_disabled) then
			-- Nothing
		end

		::label_2_1::

		_level_failed = self._level_failed

		if not _level_failed then
			_level_failed = self:_is_time_up()
		end
	else
		_level_failed = false
	end

	if false then
		_level_failed = true
	end

	::label_2_2::

	if not self:is_about_to_end_game_early() then
		if not _level_failed then
			if arg_2_3 > self._lost_condition_timer then
				local get_missions, var_2_5 = Managers.state.entity:system("mission_system"):get_missions()

				if not get_missions then
					local survival_wave = get_missions.survival_wave

					if not survival_wave then
						local flag_4

						flag_4 = not (survival_wave.wave_completed - survival_wave.starting_wave > 0) or not "won" or "lost"

						return true, flag_4
					end

					return true, "lost"
				end
			else
				return false
			end
		else
			self:set_about_to_end_game_early(false)

			self._lost_condition_timer = nil
		end
	end

	if not flag then
		flag = false

		return true, "won"
	end

	if not flag_2 then
		flag_2 = false

		return true, "lost"
	end

	if not _level_failed then
		self:set_about_to_end_game_early(true)

		if not side_is_dead then
			self._lost_condition_timer = arg_2_3 + GameModeSettings.survival.lose_condition_time_dead
		else
			self._lost_condition_timer = arg_2_3 + GameModeSettings.survival.lose_condition_time
		end
	elseif self._level_completed or not self:update_end_level_areas() then
		return true, "won"
	else
		return false
	end
end

GameModeSurvival.ended = function (self, arg_3_1)
	-- function 3
	if not self._network_server:are_all_peers_ingame() then
		self._network_server:disconnect_joining_peers()
	end
end

function COMPLETE_LEVEL()
	-- function 4
	flag = true
end

function FAIL_LEVEL()
	-- function 5
	flag_2 = true
end
