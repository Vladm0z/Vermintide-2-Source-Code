-- chunkname: @scripts/unit_extensions/objectives/versus_capture_point_objective_extension.lua

local testify = script_data.testify

testify = not testify and require("scripts/unit_extensions/objectives/testify/versus_capture_point_objective_extension_testify")
VersusCapturePointObjectiveExtension = class(VersusCapturePointObjectiveExtension, BaseObjectiveExtension)
VersusCapturePointObjectiveExtension.NAME = "VersusCapturePointObjectiveExtension"

VersusCapturePointObjectiveExtension.init = function (self, ...)
	-- function 1
	VersusCapturePointObjectiveExtension.super.init(self, ...)

	local box, var_1_1 = Unit.box(self._unit)

	self._inside_radius = math.max(var_1_1.x, var_1_1.y) * math.max(self._scale.x, self._scale.y)
	self._percentage = 0
end

VersusCapturePointObjectiveExtension._set_objective_data = function (self, arg_2_1)
	-- function 2
	local capture_point = GameModeSettings.versus.objectives.capture_point
	local capture_rate_multiplier = arg_2_1.capture_rate_multiplier

	capture_rate_multiplier = capture_rate_multiplier or capture_point.capture_rate_multiplier
	self._capture_rate_multiplier = capture_rate_multiplier

	local capture_time = arg_2_1.capture_time

	capture_time = capture_time or capture_point.capture_time
	self._capture_time = capture_time

	local num_sections = arg_2_1.num_sections

	num_sections = num_sections or capture_point.num_sections
	self._num_sections = num_sections

	local score_per_section = arg_2_1.score_per_section

	score_per_section = score_per_section or capture_point.score_per_section
	self._score_per_section = score_per_section

	local time_per_section = arg_2_1.time_per_section

	time_per_section = time_per_section or capture_point.time_per_section
	self._time_per_section = time_per_section

	local score_for_completion = arg_2_1.score_for_completion

	score_for_completion = score_for_completion or capture_point.score_for_completion
	self._score_for_completion = score_for_completion

	local time_for_completion = arg_2_1.time_for_completion

	time_for_completion = time_for_completion or capture_point.time_for_completion
	self._time_for_completion = time_for_completion

	local on_last_leaf_complete_sound_event = arg_2_1.on_last_leaf_complete_sound_event

	on_last_leaf_complete_sound_event = on_last_leaf_complete_sound_event or capture_point.on_last_leaf_complete_sound_event
	self._on_last_leaf_complete_sound_event = on_last_leaf_complete_sound_event

	local on_leaf_complete_sound_event = arg_2_1.on_leaf_complete_sound_event

	on_leaf_complete_sound_event = on_leaf_complete_sound_event or capture_point.on_leaf_complete_sound_event
	self._on_leaf_complete_sound_event = on_leaf_complete_sound_event

	local on_section_progress_sound_event = arg_2_1.on_section_progress_sound_event

	on_section_progress_sound_event = on_section_progress_sound_event or capture_point.on_section_progress_sound_event
	self._on_section_progress_sound_event = on_section_progress_sound_event
	self._capture_time_remaining = self._capture_time
end

VersusCapturePointObjectiveExtension._activate = function (self)
	-- function 3
	local mesh = Unit.mesh(self._unit, "g_projector002")

	self._material = Mesh.material(mesh, "projector")

	Material.set_scalar(self._material, "radial_cutoff", 0)

	self._hero_side = Managers.state.side:get_side_from_name("heroes")

	if not DEDICATED_SERVER then
		self:play_local_unit_sound("Play_versus_objective_capture_world_loop")
	end
end

VersusCapturePointObjectiveExtension._deactivate = function (self)
	-- function 4
	if not DEDICATED_SERVER then
		self:play_local_unit_sound("Stop_versus_objective_capture_loop")
		self:play_local_unit_sound("Stop_versus_objective_capture_ticking_loop")
	end
end

VersusCapturePointObjectiveExtension._server_update = function (self, arg_5_1, arg_5_2)
	-- function 5
	local _get_num_players_inside = self:_get_num_players_inside()
	local get_percentage_done = self:get_percentage_done()

	if _get_num_players_inside >= 1 then
		local count = #self._hero_side.PLAYER_UNITS
		local num = self._capture_rate_multiplier * 4 * (_get_num_players_inside / count)
		local clamp = math.clamp(self._capture_time_remaining - arg_5_1 * num, 0, self._capture_time)

		if clamp ~= self._capture_time_remaining then
			self._capture_time_remaining = clamp

			local get_percentage_done_2 = self:get_percentage_done()

			self:server_set_value(get_percentage_done_2)

			if get_percentage_done_2 >= (self._current_section + 1) * (1 / self._num_sections) then
				self:on_section_completed()
			end
		end
	end

	if not DEDICATED_SERVER then
		self:_update_local_player(arg_5_1, arg_5_2, get_percentage_done)
	end
end

VersusCapturePointObjectiveExtension._client_update = function (self, arg_6_1, arg_6_2)
	-- function 6
	local get_percentage_done = self:get_percentage_done()

	self._percentage = self:client_get_value()

	self:_update_local_player(arg_6_1, arg_6_2, get_percentage_done)
end

VersusCapturePointObjectiveExtension.update_testify = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	Testify:poll_requests_through_handler(testify, arg_7_0)
end

VersusCapturePointObjectiveExtension._update_local_player = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local get_percentage_done = self:get_percentage_done()

	if arg_8_3 ~= get_percentage_done then
		Material.set_scalar(self._material, "radial_cutoff", get_percentage_done)
		self._audio_system:set_global_parameter("versus_checkpoint", get_percentage_done * 100)
	end

	if self:_local_side():name() ~= "heroes" then
		return
	end

	local _is_local_player_inside = self:_is_local_player_inside()

	if not (not _is_local_player_inside and self._local_player_entered) then
		self:play_local_unit_sound("Play_versus_objective_capture_ticking_loop")
	elseif _is_local_player_inside or not self._local_player_entered then
		self:play_local_unit_sound("Stop_versus_objective_capture_ticking_loop")
	end

	self._local_player_entered = _is_local_player_inside
end

VersusCapturePointObjectiveExtension._is_local_player_inside = function (self)
	-- function 9
	local local_player = Managers.player:local_player()
	local flag = not local_player and local_player.player_unit

	if not flag then
		return
	end

	local var_9_2 = POSITION_LOOKUP[flag]
	local local_position = Unit.local_position(self._unit, 0)

	return Vector3.distance_squared(local_position, var_9_2) <= self._inside_radius * self._inside_radius
end

VersusCapturePointObjectiveExtension._get_num_players_inside = function (self)
	-- function 10
	local ALIVE = ALIVE
	local POSITION_LOOKUP = POSITION_LOOKUP
	local extension = ScriptUnit.extension
	local distance_squared = Vector3.distance_squared
	local num = self._inside_radius * self._inside_radius
	local num_2 = 0
	local PLAYER_UNITS = self._hero_side.PLAYER_UNITS
	local get_position = self:get_position()

	for k, v in pairs(PLAYER_UNITS) do
		if not (not ALIVE[v] and extension(v, "status_system"):is_disabled()) then
			local var_10_8 = POSITION_LOOKUP[v]

			if num >= distance_squared(get_position, var_10_8) then
				num_2 = num_2 + 1
			end
		end
	end

	return num_2
end

VersusCapturePointObjectiveExtension.get_percentage_done = function (self)
	-- function 11
	if not self._is_server then
		local num = 1 - self._capture_time_remaining / self._capture_time

		return math.clamp(num, 0, 1)
	end

	return self._percentage
end
