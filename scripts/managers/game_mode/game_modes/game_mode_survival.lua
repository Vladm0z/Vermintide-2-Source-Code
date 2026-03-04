-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_survival.lua

require("scripts/managers/game_mode/game_modes/game_mode_base")

script_data.disable_gamemode_end = script_data.disable_gamemode_end or Development.parameter("disable_gamemode_end")
GameModeSurvival = class(GameModeSurvival, GameModeBase)

local var_0_0 = false
local var_0_1 = false

function GameModeSurvival.init(arg_1_0, arg_1_1, arg_1_2, ...)
	GameModeSurvival.super.init(arg_1_0, arg_1_1, arg_1_2, ...)

	arg_1_0._lost_condition_timer = nil
end

function GameModeSurvival.evaluate_end_conditions(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	if script_data.disable_gamemode_end then
		return false
	end

	local var_2_0 = true
	local var_2_1 = GameModeHelper.side_is_dead("heroes", var_2_0)
	local var_2_2 = GameModeHelper.side_is_disabled("heroes")
	local var_2_3 = not arg_2_0._lose_condition_disabled and (var_2_1 or var_2_2 or arg_2_0._level_failed or arg_2_0:_is_time_up())

	if arg_2_0:is_about_to_end_game_early() then
		if var_2_3 then
			if arg_2_3 > arg_2_0._lost_condition_timer then
				local var_2_4, var_2_5 = Managers.state.entity:system("mission_system"):get_missions()

				if var_2_4 then
					local var_2_6 = var_2_4.survival_wave

					if var_2_6 then
						local var_2_7 = var_2_6.wave_completed - var_2_6.starting_wave > 0 and "won" or "lost"

						return true, var_2_7
					end

					return true, "lost"
				end
			else
				return false
			end
		else
			arg_2_0:set_about_to_end_game_early(false)

			arg_2_0._lost_condition_timer = nil
		end
	end

	if var_0_0 then
		var_0_0 = false

		return true, "won"
	end

	if var_0_1 then
		var_0_1 = false

		return true, "lost"
	end

	if var_2_3 then
		arg_2_0:set_about_to_end_game_early(true)

		if var_2_1 then
			arg_2_0._lost_condition_timer = arg_2_3 + GameModeSettings.survival.lose_condition_time_dead
		else
			arg_2_0._lost_condition_timer = arg_2_3 + GameModeSettings.survival.lose_condition_time
		end
	elseif arg_2_0._level_completed or arg_2_0:update_end_level_areas() then
		return true, "won"
	else
		return false
	end
end

function GameModeSurvival.ended(arg_3_0, arg_3_1)
	if not arg_3_0._network_server:are_all_peers_ingame() then
		arg_3_0._network_server:disconnect_joining_peers()
	end
end

function COMPLETE_LEVEL()
	var_0_0 = true
end

function FAIL_LEVEL()
	var_0_1 = true
end
