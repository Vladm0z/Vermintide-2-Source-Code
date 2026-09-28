-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_survival.lua

require("scripts/managers/game_mode/game_modes/game_mode_base")

local script_data = script_data
local disable_gamemode_end = script_data.disable_gamemode_end

disable_gamemode_end = not not disable_gamemode_end or not not Development.parameter("disable_gamemode_end")
script_data.disable_gamemode_end = disable_gamemode_end
GameModeSurvival = class(GameModeSurvival, GameModeBase)

local COMPLETE_LEVEL_VAR = false
local FAIL_LEVEL_VAR = false

GameModeSurvival.init = function (self, settings, world, ...)
	-- function 1
	GameModeSurvival.super.init(self, settings, world, ...)

	self._lost_condition_timer = nil
end

GameModeSurvival.evaluate_end_conditions = function (self, round_started, dt, t)
	-- function 2
	if script_data.disable_gamemode_end then
		return false
	end

	local ignore_bots = true
	local humans_dead = GameModeHelper.side_is_dead("heroes", ignore_bots)
	local players_disabled = GameModeHelper.side_is_disabled("heroes")
	local _level_failed

	if not self._lose_condition_disabled then
		if not humans_dead and not players_disabled then
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

	goto label_2_2

	_level_failed = true

	local lost = _level_failed

	::label_2_2::

	if self:is_about_to_end_game_early() then
		if lost then
			if t > self._lost_condition_timer then
				local mission_system = Managers.state.entity:system("mission_system")
				local active_missions, completed_missions = mission_system:get_missions()

				if active_missions then
					local mission_data = active_missions.survival_wave

					if mission_data then
						local wave_completed = mission_data.wave_completed
						local starting_wave = mission_data.starting_wave
						local str

						if wave_completed - starting_wave > 0 then
							str = "won"

							goto label_2_3
						end

						str = "lost"

						local end_reason = str

						::label_2_3::

						return true, end_reason
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

	if COMPLETE_LEVEL_VAR then
		COMPLETE_LEVEL_VAR = false

		return true, "won"
	end

	if FAIL_LEVEL_VAR then
		FAIL_LEVEL_VAR = false

		return true, "lost"
	end

	if lost then
		self:set_about_to_end_game_early(true)

		if humans_dead then
			self._lost_condition_timer = t + GameModeSettings.survival.lose_condition_time_dead
		else
			self._lost_condition_timer = t + GameModeSettings.survival.lose_condition_time
		end
	elseif self._level_completed or self:update_end_level_areas() then
		return true, "won"
	else
		return false
	end
end

GameModeSurvival.ended = function (self, reason)
	-- function 3
	local all_peers_ingame = self._network_server:are_all_peers_ingame()

	if not all_peers_ingame then
		self._network_server:disconnect_joining_peers()
	end
end

function COMPLETE_LEVEL()
	-- function 4
	COMPLETE_LEVEL_VAR = true
end

function FAIL_LEVEL()
	-- function 5
	FAIL_LEVEL_VAR = true
end
