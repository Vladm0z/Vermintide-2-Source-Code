-- chunkname: @scripts/unit_extensions/objectives/versus_capture_point_objective_extension.lua

local var_0_0 = script_data.testify and require("scripts/unit_extensions/objectives/testify/versus_capture_point_objective_extension_testify")

VersusCapturePointObjectiveExtension = class(VersusCapturePointObjectiveExtension, BaseObjectiveExtension)
VersusCapturePointObjectiveExtension.NAME = "VersusCapturePointObjectiveExtension"

VersusCapturePointObjectiveExtension.init = function (arg_1_0, ...)
	VersusCapturePointObjectiveExtension.super.init(arg_1_0, ...)

	local var_1_0, var_1_1 = Unit.box(arg_1_0._unit)

	arg_1_0._inside_radius = math.max(var_1_1.x, var_1_1.y) * math.max(arg_1_0._scale.x, arg_1_0._scale.y)
	arg_1_0._percentage = 0
end

VersusCapturePointObjectiveExtension._set_objective_data = function (arg_2_0, arg_2_1)
	local var_2_0 = GameModeSettings.versus.objectives.capture_point

	arg_2_0._capture_rate_multiplier = arg_2_1.capture_rate_multiplier or var_2_0.capture_rate_multiplier
	arg_2_0._capture_time = arg_2_1.capture_time or var_2_0.capture_time
	arg_2_0._num_sections = arg_2_1.num_sections or var_2_0.num_sections
	arg_2_0._score_per_section = arg_2_1.score_per_section or var_2_0.score_per_section
	arg_2_0._time_per_section = arg_2_1.time_per_section or var_2_0.time_per_section
	arg_2_0._score_for_completion = arg_2_1.score_for_completion or var_2_0.score_for_completion
	arg_2_0._time_for_completion = arg_2_1.time_for_completion or var_2_0.time_for_completion
	arg_2_0._on_last_leaf_complete_sound_event = arg_2_1.on_last_leaf_complete_sound_event or var_2_0.on_last_leaf_complete_sound_event
	arg_2_0._on_leaf_complete_sound_event = arg_2_1.on_leaf_complete_sound_event or var_2_0.on_leaf_complete_sound_event
	arg_2_0._on_section_progress_sound_event = arg_2_1.on_section_progress_sound_event or var_2_0.on_section_progress_sound_event
	arg_2_0._capture_time_remaining = arg_2_0._capture_time
end

VersusCapturePointObjectiveExtension._activate = function (arg_3_0)
	local var_3_0 = Unit.mesh(arg_3_0._unit, "g_projector002")

	arg_3_0._material = Mesh.material(var_3_0, "projector")

	Material.set_scalar(arg_3_0._material, "radial_cutoff", 0)

	arg_3_0._hero_side = Managers.state.side:get_side_from_name("heroes")

	if not DEDICATED_SERVER then
		arg_3_0:play_local_unit_sound("Play_versus_objective_capture_world_loop")
	end
end

VersusCapturePointObjectiveExtension._deactivate = function (arg_4_0)
	if not DEDICATED_SERVER then
		arg_4_0:play_local_unit_sound("Stop_versus_objective_capture_loop")
		arg_4_0:play_local_unit_sound("Stop_versus_objective_capture_ticking_loop")
	end
end

VersusCapturePointObjectiveExtension._server_update = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0:_get_num_players_inside()
	local var_5_1 = arg_5_0:get_percentage_done()

	if var_5_0 >= 1 then
		local var_5_2 = #arg_5_0._hero_side.PLAYER_UNITS
		local var_5_3 = arg_5_0._capture_rate_multiplier * 4 * (var_5_0 / var_5_2)
		local var_5_4 = math.clamp(arg_5_0._capture_time_remaining - arg_5_1 * var_5_3, 0, arg_5_0._capture_time)

		if var_5_4 ~= arg_5_0._capture_time_remaining then
			arg_5_0._capture_time_remaining = var_5_4

			local var_5_5 = arg_5_0:get_percentage_done()

			arg_5_0:server_set_value(var_5_5)

			if var_5_5 >= (arg_5_0._current_section + 1) * (1 / arg_5_0._num_sections) then
				arg_5_0:on_section_completed()
			end
		end
	end

	if not DEDICATED_SERVER then
		arg_5_0:_update_local_player(arg_5_1, arg_5_2, var_5_1)
	end
end

VersusCapturePointObjectiveExtension._client_update = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0:get_percentage_done()

	arg_6_0._percentage = arg_6_0:client_get_value()

	arg_6_0:_update_local_player(arg_6_1, arg_6_2, var_6_0)
end

VersusCapturePointObjectiveExtension.update_testify = function (arg_7_0, arg_7_1, arg_7_2)
	Testify:poll_requests_through_handler(var_0_0, arg_7_0)
end

VersusCapturePointObjectiveExtension._update_local_player = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_0:get_percentage_done()

	if arg_8_3 ~= var_8_0 then
		Material.set_scalar(arg_8_0._material, "radial_cutoff", var_8_0)
		arg_8_0._audio_system:set_global_parameter("versus_checkpoint", var_8_0 * 100)
	end

	if arg_8_0:_local_side():name() ~= "heroes" then
		return
	end

	local var_8_1 = arg_8_0:_is_local_player_inside()

	if var_8_1 and not arg_8_0._local_player_entered then
		arg_8_0:play_local_unit_sound("Play_versus_objective_capture_ticking_loop")
	elseif not var_8_1 and arg_8_0._local_player_entered then
		arg_8_0:play_local_unit_sound("Stop_versus_objective_capture_ticking_loop")
	end

	arg_8_0._local_player_entered = var_8_1
end

VersusCapturePointObjectiveExtension._is_local_player_inside = function (arg_9_0)
	local var_9_0 = Managers.player:local_player()
	local var_9_1 = var_9_0 and var_9_0.player_unit

	if not var_9_1 then
		return
	end

	local var_9_2 = POSITION_LOOKUP[var_9_1]
	local var_9_3 = Unit.local_position(arg_9_0._unit, 0)

	return Vector3.distance_squared(var_9_3, var_9_2) <= arg_9_0._inside_radius * arg_9_0._inside_radius
end

VersusCapturePointObjectiveExtension._get_num_players_inside = function (arg_10_0)
	local var_10_0 = ALIVE
	local var_10_1 = POSITION_LOOKUP
	local var_10_2 = ScriptUnit.extension
	local var_10_3 = Vector3.distance_squared
	local var_10_4 = arg_10_0._inside_radius * arg_10_0._inside_radius
	local var_10_5 = 0
	local var_10_6 = arg_10_0._hero_side.PLAYER_UNITS
	local var_10_7 = arg_10_0:get_position()

	for iter_10_0, iter_10_1 in pairs(var_10_6) do
		if var_10_0[iter_10_1] and not var_10_2(iter_10_1, "status_system"):is_disabled() then
			local var_10_8 = var_10_1[iter_10_1]

			if var_10_4 >= var_10_3(var_10_7, var_10_8) then
				var_10_5 = var_10_5 + 1
			end
		end
	end

	return var_10_5
end

VersusCapturePointObjectiveExtension.get_percentage_done = function (arg_11_0)
	if arg_11_0._is_server then
		local var_11_0 = 1 - arg_11_0._capture_time_remaining / arg_11_0._capture_time

		return math.clamp(var_11_0, 0, 1)
	end

	return arg_11_0._percentage
end
