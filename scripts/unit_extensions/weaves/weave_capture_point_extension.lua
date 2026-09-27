-- chunkname: @scripts/unit_extensions/weaves/weave_capture_point_extension.lua

WeaveCapturePointExtension = class(WeaveCapturePointExtension, BaseObjectiveExtension)
WeaveCapturePointExtension.NAME = "WeaveCapturePointExtension"

local num = 10

WeaveCapturePointExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	WeaveCapturePointExtension.super.init(self, arg_1_1, arg_1_2, arg_1_3)

	self._is_already_inside = false
	self._num_players = 0
	self._num_players_required = 0
	self._on_start_func = arg_1_3.on_start_func
	self._on_enter_func = arg_1_3.on_enter_func
	self._on_progress_func = arg_1_3.on_progress_func
	self._on_exit_func = arg_1_3.on_exit_func
	self._on_complete_func = arg_1_3.on_complete_func

	local percentage_of_players_required = arg_1_3.percentage_of_players_required

	percentage_of_players_required = percentage_of_players_required or 0.25
	self._percentage_of_players_required = percentage_of_players_required

	local timer = arg_1_3.timer

	timer = timer or 45
	self._max_time = timer

	local capture_rate_multiplier = arg_1_3.capture_rate_multiplier

	capture_rate_multiplier = capture_rate_multiplier or 5
	self._capture_rate_multiplier = capture_rate_multiplier
	self._timer = self._max_time

	if not self._is_server then
		self._progress_buffer_index = 0
		self._client_progress_buffer = {}
	end

	local terror_event_spawner_id = arg_1_3.terror_event_spawner_id

	Unit.set_data(arg_1_2, "terror_event_spawner_id", terror_event_spawner_id)
	self:_calculate_size()

	self._last_set_value = 0
	self._latest_value = 0
	self._predicted_value = 0
end

WeaveCapturePointExtension.display_name = function (arg_2_0)
	-- function 2
	return "objective_capture_points_name_single"
end

WeaveCapturePointExtension._calculate_size = function (self)
	-- function 3
	local local_scale = Unit.local_scale(self._unit, 0)
	local box, var_3_2 = Unit.box(self._unit)

	if var_3_2[1] > var_3_2[2] then
		self._size = var_3_2[1] * local_scale[1]
	else
		self._size = var_3_2[2] * local_scale[2]
	end
end

WeaveCapturePointExtension._set_objective_data = function (arg_4_0, arg_4_1)
	-- function 4
	return
end

WeaveCapturePointExtension._activate = function (self)
	-- function 5
	local has_extension = ScriptUnit.has_extension(self._unit, "tutorial_system")

	if not has_extension then
		has_extension:set_active(true)
	end

	local mesh = Unit.mesh(self._unit, "g_projector002")

	self._material = Mesh.material(mesh, "projector")

	local var_5_2
	local var_5_3
	local get_active_wind = Managers.weave:get_active_wind()

	self._wind = get_active_wind

	if get_active_wind == "fire" then
		var_5_2 = Vector3(0.5, 0.3, 0.1)
		var_5_3 = Vector3(1, 0.1, 0)
	elseif get_active_wind == "beasts" then
		var_5_2 = Vector3(0.4, 0.1, 0.02)
		var_5_3 = Vector3(0.72, 0.5, 0.4)
	elseif get_active_wind == "death" then
		var_5_2 = Vector3(0.2, 0.15, 0.2)
		var_5_3 = Vector3(0.5, 0.25, 1)
	elseif get_active_wind == "heavens" then
		var_5_2 = Vector3(0.2, 0.4, 1)
		var_5_3 = Vector3(0.8, 0.8, 0.6)
	elseif get_active_wind == "light" then
		var_5_2 = Vector3(0.5, 0.72, 0.85)
		var_5_3 = Vector3(1, 1, 1)
	elseif get_active_wind == "shadow" then
		var_5_2 = Vector3(0.35, 0.35, 0.35)
		var_5_3 = Vector3(0.1, 0.1, 0.1)
	elseif get_active_wind == "life" then
		var_5_2 = Vector3(0.2, 0.35, 0.15)
		var_5_3 = Vector3(0.3, 0.75, 0)
	elseif get_active_wind == "metal" then
		var_5_2 = Vector3(0.5, 0.5, 0.3)
		var_5_3 = Vector3(1, 0.5, 0)
	end

	Material.set_vector3(self._material, "runes_color", var_5_3)
	Material.set_vector3(self._material, "frame_color", var_5_2)
	Material.set_scalar(self._material, "radial_cutoff", self:get_percentage_done())

	if not self._is_server then
		self._num_start_players = Managers.weave:get_num_players()

		self:_update_num_players_required(self._num_start_players)

		local num = self._num_start_players - self._num_players_required

		num = num ~= 0 or not 1 or num
		self._capture_rate_multiplier = 1 / num
	end
end

WeaveCapturePointExtension.complete = function (self, ...)
	-- function 6
	WeaveCapturePointExtension.super.complete(self, ...)
	Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_winds_gameplay_capture_success", self._unit)
end

WeaveCapturePointExtension._deactivate = function (self)
	-- function 7
	local _size = self._size

	for i = 1, _size * 15 do
		local num = math.random(-_size * 10, _size * 10) / 10
		local num_2 = math.random(-_size * 10, _size * 10) / 10
		local num_3 = Unit.local_position(self._unit, 0) + Vector3(num, num_2, 0)

		Managers.state.entity:system("objective_system"):weave_essence_handler():spawn_essence_unit(num_3)
	end
end

WeaveCapturePointExtension._update_num_players_required = function (self, arg_8_1)
	-- function 8
	local _percentage_of_players_required = self._percentage_of_players_required
	local floor = math.floor(arg_8_1 * _percentage_of_players_required)
	local flag

	flag = floor ~= 0 or not 1 or floor
	self._num_players_required = flag
	self._num_players = arg_8_1
end

WeaveCapturePointExtension._server_update = function (self, arg_9_1, arg_9_2)
	-- function 9
	local local_position = Unit.local_position(self._unit, 0)
	local num = 0
	local PLAYER_AND_BOT_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS
	local num_2 = self._size * self._size
	local num_3 = 0

	for k, v in pairs(PLAYER_AND_BOT_UNITS) do
		if not Unit.alive(v) then
			if not ScriptUnit.has_extension(v, "status_system"):is_disabled() then
				num_3 = num_3 + 1
			else
				local var_9_5 = POSITION_LOOKUP[v]

				if num_2 >= Vector3.distance_squared(local_position, var_9_5) then
					num = num + 1
				end
			end
		end
	end

	local num_human_players = Managers.player:num_human_players()

	if self._num_players ~= num_human_players then
		self:_update_num_players_required(num_human_players)
	end

	local _timer = self._timer
	local _num_players_required = self._num_players_required

	if _num_players_required <= num then
		if not self._is_already_inside then
			if not self._on_start_func then
				self._on_start_func(self._unit)

				self._on_start_func = nil
			end

			if not self._on_enter_func then
				self._on_enter_func(self._unit)
			end

			Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_winds_gameplay_capture_loop", self._unit)

			self._is_already_inside = true
		end

		local var_9_9

		if not (num ~= self._num_start_players or num ~= _num_players_required) then
			var_9_9 = 1 + self._capture_rate_multiplier
		else
			var_9_9 = 1 + self._capture_rate_multiplier * (num - _num_players_required)
		end

		_timer = math.clamp(self._timer - arg_9_1 * var_9_9, 0, self._max_time)

		if not self._on_progress_func then
			self._on_progress_func(self._unit, self._timer, self._max_time)
		end
	elseif not self._is_already_inside then
		if not self._on_exit_func then
			self._on_exit_func(self._unit)
		end

		Managers.state.entity:system("audio_system"):play_audio_unit_event("Stop_winds_gameplay_capture_loop", self._unit)

		self._is_already_inside = false
	end

	if _timer ~= self._timer then
		self._timer = _timer

		local get_percentage_done = self:get_percentage_done()

		Material.set_scalar(self._material, "radial_cutoff", get_percentage_done)
		self:server_set_value(get_percentage_done)
	end
end

WeaveCapturePointExtension._client_average_progress_speed = function (self)
	-- function 10
	local _client_progress_buffer = self._client_progress_buffer
	local count = #_client_progress_buffer

	if count == 0 then
		return 0
	end

	local index_wrapper = math.index_wrapper(self._progress_buffer_index + 1, count)
	local var_10_3 = _client_progress_buffer[index_wrapper]

	var_10_3 = not var_10_3 and _client_progress_buffer[index_wrapper].value

	local var_10_4 = _client_progress_buffer[index_wrapper]

	var_10_4 = not var_10_4 and _client_progress_buffer[index_wrapper].t

	local num = 0

	for i = 1, count - 1 do
		local var_10_6 = _client_progress_buffer[math.index_wrapper(index_wrapper + i, count)]
		local value = var_10_6.value
		local t = var_10_6.t

		num = num + (value - var_10_3) / (t - var_10_4)
		var_10_3 = value
		var_10_4 = t
	end

	return num / count
end

WeaveCapturePointExtension._client_register_value_progress = function (self, arg_11_1, arg_11_2)
	-- function 11
	self._progress_buffer_index = math.index_wrapper(self._progress_buffer_index + 1, num)

	local var_11_0 = self._client_progress_buffer[self._progress_buffer_index]

	var_11_0 = var_11_0 or {}
	var_11_0.value = arg_11_1
	var_11_0.t = arg_11_2
	self._client_progress_buffer[self._progress_buffer_index] = var_11_0
end

WeaveCapturePointExtension._client_update = function (self, arg_12_1, arg_12_2)
	-- function 12
	local client_get_value = self:client_get_value()

	if client_get_value > self._latest_value then
		self:_client_register_value_progress(client_get_value, arg_12_2)

		self._latest_value = client_get_value
	end

	local num = 1
	local _client_average_progress_speed = self:_client_average_progress_speed()
	local clamp = math.clamp(self._predicted_value + _client_average_progress_speed * arg_12_1, client_get_value, client_get_value + _client_average_progress_speed * num)

	self._predicted_value = clamp

	local lerp = math.lerp(self._last_set_value, clamp, arg_12_1)

	self._last_set_value = lerp

	Material.set_scalar(self._material, "radial_cutoff", lerp)
end

WeaveCapturePointExtension.get_percentage_done = function (self)
	-- function 13
	return math.clamp(1 - self._timer / self._max_time, 0, 1)
end
