-- chunkname: @scripts/unit_extensions/objectives/versus_volume_objective_extension.lua

local var_0_0 = script_data.testify and require("scripts/unit_extensions/objectives/testify/versus_volume_objective_extension_testify")

VersusVolumeObjectiveExtension = class(VersusVolumeObjectiveExtension, BaseObjectiveExtension)
VersusVolumeObjectiveExtension.NAME = "VersusVolumeObjectiveExtension"

local var_0_1 = {
	all_alive = "all_alive_human_players_inside",
	any_alive = "any_alive_human_players_inside"
}

function VersusVolumeObjectiveExtension.init(arg_1_0, ...)
	VersusVolumeObjectiveExtension.super.init(arg_1_0, ...)

	arg_1_0._volume_system = Managers.state.entity:system("volume_system")
	arg_1_0._percentage = 0
end

function VersusVolumeObjectiveExtension._set_objective_data(arg_2_0, arg_2_1)
	local var_2_0 = GameModeSettings.versus.objectives.volume

	arg_2_0._score_for_completion = arg_2_1.score_for_completion or var_2_0.score_for_completion
	arg_2_0._time_for_completion = arg_2_1.time_for_completion or var_2_0.time_for_completion
	arg_2_0._score_for_each_player_inside = arg_2_1.score_for_each_player_inside or var_2_0.score_for_each_player_inside
	arg_2_0._time_for_each_player_inside = arg_2_1.time_for_each_player_inside or var_2_0.time_for_each_player_inside
	arg_2_0._volume_name = arg_2_1.volume_name
	arg_2_0._volume_type = arg_2_1.volume_type or var_2_0.volume_type
	arg_2_0._on_last_leaf_complete_sound_event = arg_2_1.on_last_leaf_complete_sound_event or var_2_0.on_last_leaf_complete_sound_event
	arg_2_0._on_leaf_complete_sound_event = arg_2_1.on_leaf_complete_sound_event or var_2_0.on_leaf_complete_sound_event

	local var_2_1 = var_0_1[arg_2_0._volume_type]

	fassert(var_2_1 ~= nil, "Invalid volume type ", arg_2_0._volume_type)

	arg_2_0._condition_func = arg_2_0._volume_system[var_2_1]
end

function VersusVolumeObjectiveExtension._activate(arg_3_0)
	if arg_3_0._is_server then
		arg_3_0._volume_system:register_volume(arg_3_0._volume_name, "trigger_volume", {
			sub_type = "players_inside"
		})
	end
end

function VersusVolumeObjectiveExtension._deactivate(arg_4_0)
	return
end

function VersusVolumeObjectiveExtension._server_update(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0._condition_func(arg_5_0._volume_system, arg_5_0._volume_name)

	if arg_5_0._percentage < 1 and var_5_0 then
		arg_5_0._percentage = 1

		arg_5_0:server_set_value(arg_5_0._percentage)
	end
end

function VersusVolumeObjectiveExtension._client_update(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0._percentage = arg_6_0:client_get_value()
end

function VersusVolumeObjectiveExtension.update_testify(arg_7_0, arg_7_1, arg_7_2)
	Testify:poll_requests_through_handler(var_0_0, arg_7_0)
end

function VersusVolumeObjectiveExtension.get_percentage_done(arg_8_0)
	return arg_8_0._percentage
end

function VersusVolumeObjectiveExtension._get_num_players_inside(arg_9_0)
	local var_9_0 = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS
	local var_9_1 = 0

	if arg_9_0._volume_type == "all_alive_human_players_inside" then
		for iter_9_0 = 1, #var_9_0 do
			local var_9_2 = var_9_0[iter_9_0]
			local var_9_3 = ALIVE[var_9_2] and ScriptUnit.has_extension(var_9_2, "status_system")

			if var_9_3 and not var_9_3:is_disabled() then
				var_9_1 = var_9_1 + 1
			end
		end
	else
		for iter_9_1 = 1, #var_9_0 do
			local var_9_4 = var_9_0[iter_9_1]
			local var_9_5 = ALIVE[var_9_4] and ScriptUnit.has_extension(var_9_4, "status_system")

			if var_9_5 and not var_9_5:is_disabled() and (var_9_5.is_bot or arg_9_0._volume_system:player_inside(arg_9_0._volume_name, var_9_4)) then
				var_9_1 = var_9_1 + 1
			end
		end
	end

	return var_9_1
end

function VersusVolumeObjectiveExtension.get_score_for_completion(arg_10_0)
	if not arg_10_0:is_done() then
		return 0
	end

	if arg_10_0._score_for_each_player_inside == 0 then
		return arg_10_0._score_for_completion
	end

	return arg_10_0._score_for_completion + arg_10_0:_get_num_players_inside() * arg_10_0._score_for_each_player_inside
end

function VersusVolumeObjectiveExtension.get_time_for_completion(arg_11_0)
	if not arg_11_0:is_done() then
		return 0
	end

	if arg_11_0._time_for_each_player_inside == 0 then
		return arg_11_0._time_for_completion
	end

	return arg_11_0._time_for_completion + arg_11_0:_get_num_players_inside() * arg_11_0._time_for_each_player_inside
end
