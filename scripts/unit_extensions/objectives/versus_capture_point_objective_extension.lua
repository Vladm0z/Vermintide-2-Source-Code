-- chunkname: @scripts/unit_extensions/objectives/versus_capture_point_objective_extension.lua

local testify = script_data.testify

if testify then
	-- Nothing
end

testify = require("scripts/unit_extensions/objectives/testify/versus_capture_point_objective_extension_testify")

local versus_capture_point_objective_extension_testify = testify

::label_0_0::

VersusCapturePointObjectiveExtension = class(VersusCapturePointObjectiveExtension, BaseObjectiveExtension)
VersusCapturePointObjectiveExtension.NAME = "VersusCapturePointObjectiveExtension"

VersusCapturePointObjectiveExtension.init = function (self, ...)
	-- function 1
	VersusCapturePointObjectiveExtension.super.init(self, ...)

	local _, extents = Unit.box(self._unit)
	local radius = math.max(extents.x, extents.y)

	self._inside_radius = radius * math.max(self._scale.x, self._scale.y)
	self._percentage = 0
end

VersusCapturePointObjectiveExtension._set_objective_data = function (self, objective_data)
	-- function 2
	local capture_point_default_settings = GameModeSettings.versus.objectives.capture_point
	local capture_rate_multiplier = objective_data.capture_rate_multiplier

	capture_rate_multiplier = not not capture_rate_multiplier or not not capture_point_default_settings.capture_rate_multiplier
	self._capture_rate_multiplier = capture_rate_multiplier

	local capture_time = objective_data.capture_time

	capture_time = not not capture_time or not not capture_point_default_settings.capture_time
	self._capture_time = capture_time

	local num_sections = objective_data.num_sections

	num_sections = not not num_sections or not not capture_point_default_settings.num_sections
	self._num_sections = num_sections

	local score_per_section = objective_data.score_per_section

	score_per_section = not not score_per_section or not not capture_point_default_settings.score_per_section
	self._score_per_section = score_per_section

	local time_per_section = objective_data.time_per_section

	time_per_section = not not time_per_section or not not capture_point_default_settings.time_per_section
	self._time_per_section = time_per_section

	local score_for_completion = objective_data.score_for_completion

	score_for_completion = not not score_for_completion or not not capture_point_default_settings.score_for_completion
	self._score_for_completion = score_for_completion

	local time_for_completion = objective_data.time_for_completion

	time_for_completion = not not time_for_completion or not not capture_point_default_settings.time_for_completion
	self._time_for_completion = time_for_completion

	local on_last_leaf_complete_sound_event = objective_data.on_last_leaf_complete_sound_event

	on_last_leaf_complete_sound_event = not not on_last_leaf_complete_sound_event or not not capture_point_default_settings.on_last_leaf_complete_sound_event
	self._on_last_leaf_complete_sound_event = on_last_leaf_complete_sound_event

	local on_leaf_complete_sound_event = objective_data.on_leaf_complete_sound_event

	on_leaf_complete_sound_event = not not on_leaf_complete_sound_event or not not capture_point_default_settings.on_leaf_complete_sound_event
	self._on_leaf_complete_sound_event = on_leaf_complete_sound_event

	local on_section_progress_sound_event = objective_data.on_section_progress_sound_event

	on_section_progress_sound_event = not not on_section_progress_sound_event or not not capture_point_default_settings.on_section_progress_sound_event
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

VersusCapturePointObjectiveExtension._server_update = function (self, dt, t)
	-- function 5
	local num_players_inside = self:_get_num_players_inside()
	local previous_percentage = self:get_percentage_done()

	if num_players_inside >= 1 then
		local total_num_players = #self._hero_side.PLAYER_UNITS
		local capture_rate = self._capture_rate_multiplier * 4 * (num_players_inside / total_num_players)
		local time_remaining = math.clamp(self._capture_time_remaining - dt * capture_rate, 0, self._capture_time)

		if time_remaining ~= self._capture_time_remaining then
			self._capture_time_remaining = time_remaining

			local percentage_done = self:get_percentage_done()

			self:server_set_value(percentage_done)

			if percentage_done >= (self._current_section + 1) * (1 / self._num_sections) then
				self:on_section_completed()
			end
		end
	end

	if not DEDICATED_SERVER then
		self:_update_local_player(dt, t, previous_percentage)
	end
end

VersusCapturePointObjectiveExtension._client_update = function (self, dt, t)
	-- function 6
	local previous_percentage = self:get_percentage_done()

	self._percentage = self:client_get_value()

	self:_update_local_player(dt, t, previous_percentage)
end

VersusCapturePointObjectiveExtension.update_testify = function (self, dt, t)
	-- function 7
	Testify:poll_requests_through_handler(versus_capture_point_objective_extension_testify, self)
end

VersusCapturePointObjectiveExtension._update_local_player = function (self, dt, t, previous_percentage)
	-- function 8
	local percentage_done = self:get_percentage_done()

	if previous_percentage ~= percentage_done then
		Material.set_scalar(self._material, "radial_cutoff", percentage_done)
		self._audio_system:set_global_parameter("versus_checkpoint", percentage_done * 100)
	end

	if self:_local_side():name() ~= "heroes" then
		return
	end

	local local_player_inside = self:_is_local_player_inside()

	if local_player_inside and not self._local_player_entered then
		self:play_local_unit_sound("Play_versus_objective_capture_ticking_loop")
	elseif not local_player_inside and self._local_player_entered then
		self:play_local_unit_sound("Stop_versus_objective_capture_ticking_loop")
	end

	self._local_player_entered = local_player_inside
end

VersusCapturePointObjectiveExtension._is_local_player_inside = function (self)
	-- function 9
	local local_player = Managers.player:local_player()
	local local_player_unit = not not local_player and not not local_player.player_unit

	if not local_player_unit then
		return
	end

	local player_position = POSITION_LOOKUP[local_player_unit]
	local position = Unit.local_position(self._unit, 0)
	local distance = Vector3.distance_squared(position, player_position)
	local radius = self._inside_radius * self._inside_radius

	return distance <= radius
end

VersusCapturePointObjectiveExtension._get_num_players_inside = function (self)
	-- function 10
	local ALIVE = ALIVE
	local POSITION_LOOKUP = POSITION_LOOKUP
	local ScriptUnit_extension = ScriptUnit.extension
	local Vector3_distance_squared = Vector3.distance_squared
	local radius_sq = self._inside_radius * self._inside_radius
	local num_players_inside = 0
	local player_units = self._hero_side.PLAYER_UNITS
	local position = self:get_position()

	for _, unit in pairs(player_units) do
		if ALIVE[unit] then
			local status_extension = ScriptUnit_extension(unit, "status_system")

			if not status_extension:is_disabled() then
				local player_position = POSITION_LOOKUP[unit]
				local distance = Vector3_distance_squared(position, player_position)

				if distance <= radius_sq then
					num_players_inside = num_players_inside + 1
				end
			end
		end
	end

	return num_players_inside
end

VersusCapturePointObjectiveExtension.get_percentage_done = function (self)
	-- function 11
	if self._is_server then
		local value = 1 - self._capture_time_remaining / self._capture_time

		return math.clamp(value, 0, 1)
	end

	return self._percentage
end
