-- chunkname: @scripts/unit_extensions/weaves/weave_capture_point_extension.lua

WeaveCapturePointExtension = class(WeaveCapturePointExtension, BaseObjectiveExtension)
WeaveCapturePointExtension.NAME = "WeaveCapturePointExtension"

local var_0_0 = 10

WeaveCapturePointExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	WeaveCapturePointExtension.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)

	arg_1_0._is_already_inside = false
	arg_1_0._num_players = 0
	arg_1_0._num_players_required = 0
	arg_1_0._on_start_func = arg_1_3.on_start_func
	arg_1_0._on_enter_func = arg_1_3.on_enter_func
	arg_1_0._on_progress_func = arg_1_3.on_progress_func
	arg_1_0._on_exit_func = arg_1_3.on_exit_func
	arg_1_0._on_complete_func = arg_1_3.on_complete_func
	arg_1_0._percentage_of_players_required = arg_1_3.percentage_of_players_required or 0.25
	arg_1_0._max_time = arg_1_3.timer or 45
	arg_1_0._capture_rate_multiplier = arg_1_3.capture_rate_multiplier or 5
	arg_1_0._timer = arg_1_0._max_time

	if not arg_1_0._is_server then
		arg_1_0._progress_buffer_index = 0
		arg_1_0._client_progress_buffer = {}
	end

	local var_1_0 = arg_1_3.terror_event_spawner_id

	Unit.set_data(arg_1_2, "terror_event_spawner_id", var_1_0)
	arg_1_0:_calculate_size()

	arg_1_0._last_set_value = 0
	arg_1_0._latest_value = 0
	arg_1_0._predicted_value = 0
end

WeaveCapturePointExtension.display_name = function (arg_2_0)
	return "objective_capture_points_name_single"
end

WeaveCapturePointExtension._calculate_size = function (arg_3_0)
	local var_3_0 = Unit.local_scale(arg_3_0._unit, 0)
	local var_3_1, var_3_2 = Unit.box(arg_3_0._unit)

	if var_3_2[1] > var_3_2[2] then
		arg_3_0._size = var_3_2[1] * var_3_0[1]
	else
		arg_3_0._size = var_3_2[2] * var_3_0[2]
	end
end

WeaveCapturePointExtension._set_objective_data = function (arg_4_0, arg_4_1)
	return
end

WeaveCapturePointExtension._activate = function (arg_5_0)
	local var_5_0 = ScriptUnit.has_extension(arg_5_0._unit, "tutorial_system")

	if var_5_0 then
		var_5_0:set_active(true)
	end

	local var_5_1 = Unit.mesh(arg_5_0._unit, "g_projector002")

	arg_5_0._material = Mesh.material(var_5_1, "projector")

	local var_5_2
	local var_5_3
	local var_5_4 = Managers.weave:get_active_wind()

	arg_5_0._wind = var_5_4

	if var_5_4 == "fire" then
		var_5_2 = Vector3(0.5, 0.3, 0.1)
		var_5_3 = Vector3(1, 0.1, 0)
	elseif var_5_4 == "beasts" then
		var_5_2 = Vector3(0.4, 0.1, 0.02)
		var_5_3 = Vector3(0.72, 0.5, 0.4)
	elseif var_5_4 == "death" then
		var_5_2 = Vector3(0.2, 0.15, 0.2)
		var_5_3 = Vector3(0.5, 0.25, 1)
	elseif var_5_4 == "heavens" then
		var_5_2 = Vector3(0.2, 0.4, 1)
		var_5_3 = Vector3(0.8, 0.8, 0.6)
	elseif var_5_4 == "light" then
		var_5_2 = Vector3(0.5, 0.72, 0.85)
		var_5_3 = Vector3(1, 1, 1)
	elseif var_5_4 == "shadow" then
		var_5_2 = Vector3(0.35, 0.35, 0.35)
		var_5_3 = Vector3(0.1, 0.1, 0.1)
	elseif var_5_4 == "life" then
		var_5_2 = Vector3(0.2, 0.35, 0.15)
		var_5_3 = Vector3(0.3, 0.75, 0)
	elseif var_5_4 == "metal" then
		var_5_2 = Vector3(0.5, 0.5, 0.3)
		var_5_3 = Vector3(1, 0.5, 0)
	end

	Material.set_vector3(arg_5_0._material, "runes_color", var_5_3)
	Material.set_vector3(arg_5_0._material, "frame_color", var_5_2)
	Material.set_scalar(arg_5_0._material, "radial_cutoff", arg_5_0:get_percentage_done())

	if arg_5_0._is_server then
		arg_5_0._num_start_players = Managers.weave:get_num_players()

		arg_5_0:_update_num_players_required(arg_5_0._num_start_players)

		local var_5_5 = arg_5_0._num_start_players - arg_5_0._num_players_required

		var_5_5 = var_5_5 == 0 and 1 or var_5_5
		arg_5_0._capture_rate_multiplier = 1 / var_5_5
	end
end

WeaveCapturePointExtension.complete = function (arg_6_0, ...)
	WeaveCapturePointExtension.super.complete(arg_6_0, ...)
	Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_winds_gameplay_capture_success", arg_6_0._unit)
end

WeaveCapturePointExtension._deactivate = function (arg_7_0)
	local var_7_0 = arg_7_0._size

	for iter_7_0 = 1, var_7_0 * 15 do
		local var_7_1 = math.random(-var_7_0 * 10, var_7_0 * 10) / 10
		local var_7_2 = math.random(-var_7_0 * 10, var_7_0 * 10) / 10
		local var_7_3 = Unit.local_position(arg_7_0._unit, 0) + Vector3(var_7_1, var_7_2, 0)

		Managers.state.entity:system("objective_system"):weave_essence_handler():spawn_essence_unit(var_7_3)
	end
end

WeaveCapturePointExtension._update_num_players_required = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._percentage_of_players_required
	local var_8_1 = math.floor(arg_8_1 * var_8_0)

	arg_8_0._num_players_required = var_8_1 == 0 and 1 or var_8_1
	arg_8_0._num_players = arg_8_1
end

WeaveCapturePointExtension._server_update = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = Unit.local_position(arg_9_0._unit, 0)
	local var_9_1 = 0
	local var_9_2 = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS
	local var_9_3 = arg_9_0._size * arg_9_0._size
	local var_9_4 = 0

	for iter_9_0, iter_9_1 in pairs(var_9_2) do
		if Unit.alive(iter_9_1) then
			if ScriptUnit.has_extension(iter_9_1, "status_system"):is_disabled() then
				var_9_4 = var_9_4 + 1
			else
				local var_9_5 = POSITION_LOOKUP[iter_9_1]

				if var_9_3 >= Vector3.distance_squared(var_9_0, var_9_5) then
					var_9_1 = var_9_1 + 1
				end
			end
		end
	end

	local var_9_6 = Managers.player:num_human_players()

	if arg_9_0._num_players ~= var_9_6 then
		arg_9_0:_update_num_players_required(var_9_6)
	end

	local var_9_7 = arg_9_0._timer
	local var_9_8 = arg_9_0._num_players_required

	if var_9_8 <= var_9_1 then
		if not arg_9_0._is_already_inside then
			if arg_9_0._on_start_func then
				arg_9_0._on_start_func(arg_9_0._unit)

				arg_9_0._on_start_func = nil
			end

			if arg_9_0._on_enter_func then
				arg_9_0._on_enter_func(arg_9_0._unit)
			end

			Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_winds_gameplay_capture_loop", arg_9_0._unit)

			arg_9_0._is_already_inside = true
		end

		local var_9_9

		if var_9_1 == arg_9_0._num_start_players and var_9_1 == var_9_8 then
			var_9_9 = 1 + arg_9_0._capture_rate_multiplier
		else
			var_9_9 = 1 + arg_9_0._capture_rate_multiplier * (var_9_1 - var_9_8)
		end

		var_9_7 = math.clamp(arg_9_0._timer - arg_9_1 * var_9_9, 0, arg_9_0._max_time)

		if arg_9_0._on_progress_func then
			arg_9_0._on_progress_func(arg_9_0._unit, arg_9_0._timer, arg_9_0._max_time)
		end
	elseif arg_9_0._is_already_inside then
		if arg_9_0._on_exit_func then
			arg_9_0._on_exit_func(arg_9_0._unit)
		end

		Managers.state.entity:system("audio_system"):play_audio_unit_event("Stop_winds_gameplay_capture_loop", arg_9_0._unit)

		arg_9_0._is_already_inside = false
	end

	if var_9_7 ~= arg_9_0._timer then
		arg_9_0._timer = var_9_7

		local var_9_10 = arg_9_0:get_percentage_done()

		Material.set_scalar(arg_9_0._material, "radial_cutoff", var_9_10)
		arg_9_0:server_set_value(var_9_10)
	end
end

WeaveCapturePointExtension._client_average_progress_speed = function (arg_10_0)
	local var_10_0 = arg_10_0._client_progress_buffer
	local var_10_1 = #var_10_0

	if var_10_1 == 0 then
		return 0
	end

	local var_10_2 = math.index_wrapper(arg_10_0._progress_buffer_index + 1, var_10_1)
	local var_10_3 = var_10_0[var_10_2] and var_10_0[var_10_2].value
	local var_10_4 = var_10_0[var_10_2] and var_10_0[var_10_2].t
	local var_10_5 = 0

	for iter_10_0 = 1, var_10_1 - 1 do
		local var_10_6 = var_10_0[math.index_wrapper(var_10_2 + iter_10_0, var_10_1)]
		local var_10_7 = var_10_6.value
		local var_10_8 = var_10_6.t

		var_10_5 = var_10_5 + (var_10_7 - var_10_3) / (var_10_8 - var_10_4)
		var_10_3 = var_10_7
		var_10_4 = var_10_8
	end

	return var_10_5 / var_10_1
end

WeaveCapturePointExtension._client_register_value_progress = function (arg_11_0, arg_11_1, arg_11_2)
	arg_11_0._progress_buffer_index = math.index_wrapper(arg_11_0._progress_buffer_index + 1, var_0_0)

	local var_11_0 = arg_11_0._client_progress_buffer[arg_11_0._progress_buffer_index] or {}

	var_11_0.value = arg_11_1
	var_11_0.t = arg_11_2
	arg_11_0._client_progress_buffer[arg_11_0._progress_buffer_index] = var_11_0
end

WeaveCapturePointExtension._client_update = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0:client_get_value()

	if var_12_0 > arg_12_0._latest_value then
		arg_12_0:_client_register_value_progress(var_12_0, arg_12_2)

		arg_12_0._latest_value = var_12_0
	end

	local var_12_1 = 1
	local var_12_2 = arg_12_0:_client_average_progress_speed()
	local var_12_3 = math.clamp(arg_12_0._predicted_value + var_12_2 * arg_12_1, var_12_0, var_12_0 + var_12_2 * var_12_1)

	arg_12_0._predicted_value = var_12_3

	local var_12_4 = math.lerp(arg_12_0._last_set_value, var_12_3, arg_12_1)

	arg_12_0._last_set_value = var_12_4

	Material.set_scalar(arg_12_0._material, "radial_cutoff", var_12_4)
end

WeaveCapturePointExtension.get_percentage_done = function (arg_13_0)
	return math.clamp(1 - arg_13_0._timer / arg_13_0._max_time, 0, 1)
end
