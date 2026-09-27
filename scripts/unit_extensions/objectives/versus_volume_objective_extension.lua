-- chunkname: @scripts/unit_extensions/objectives/versus_volume_objective_extension.lua

local testify = script_data.testify

testify = not testify and require("scripts/unit_extensions/objectives/testify/versus_volume_objective_extension_testify")
VersusVolumeObjectiveExtension = class(VersusVolumeObjectiveExtension, BaseObjectiveExtension)
VersusVolumeObjectiveExtension.NAME = "VersusVolumeObjectiveExtension"

local tbl = {
	all_alive = "all_alive_human_players_inside",
	any_alive = "any_alive_human_players_inside"
}

VersusVolumeObjectiveExtension.init = function (self, ...)
	-- function 1
	VersusVolumeObjectiveExtension.super.init(self, ...)

	self._volume_system = Managers.state.entity:system("volume_system")
	self._percentage = 0
end

VersusVolumeObjectiveExtension._set_objective_data = function (self, arg_2_1)
	-- function 2
	local volume = GameModeSettings.versus.objectives.volume
	local score_for_completion = arg_2_1.score_for_completion

	score_for_completion = score_for_completion or volume.score_for_completion
	self._score_for_completion = score_for_completion

	local time_for_completion = arg_2_1.time_for_completion

	time_for_completion = time_for_completion or volume.time_for_completion
	self._time_for_completion = time_for_completion

	local score_for_each_player_inside = arg_2_1.score_for_each_player_inside

	score_for_each_player_inside = score_for_each_player_inside or volume.score_for_each_player_inside
	self._score_for_each_player_inside = score_for_each_player_inside

	local time_for_each_player_inside = arg_2_1.time_for_each_player_inside

	time_for_each_player_inside = time_for_each_player_inside or volume.time_for_each_player_inside
	self._time_for_each_player_inside = time_for_each_player_inside
	self._volume_name = arg_2_1.volume_name

	local volume_type = arg_2_1.volume_type

	volume_type = volume_type or volume.volume_type
	self._volume_type = volume_type

	local on_last_leaf_complete_sound_event = arg_2_1.on_last_leaf_complete_sound_event

	on_last_leaf_complete_sound_event = on_last_leaf_complete_sound_event or volume.on_last_leaf_complete_sound_event
	self._on_last_leaf_complete_sound_event = on_last_leaf_complete_sound_event

	local on_leaf_complete_sound_event = arg_2_1.on_leaf_complete_sound_event

	on_leaf_complete_sound_event = on_leaf_complete_sound_event or volume.on_leaf_complete_sound_event
	self._on_leaf_complete_sound_event = on_leaf_complete_sound_event

	local var_2_8 = tbl[self._volume_type]

	fassert(var_2_8 ~= nil, "Invalid volume type ", self._volume_type)

	self._condition_func = self._volume_system[var_2_8]
end

VersusVolumeObjectiveExtension._activate = function (self)
	-- function 3
	if not self._is_server then
		self._volume_system:register_volume(self._volume_name, "trigger_volume", {
			sub_type = "players_inside"
		})
	end
end

VersusVolumeObjectiveExtension._deactivate = function (arg_4_0)
	-- function 4
	return
end

VersusVolumeObjectiveExtension._server_update = function (self, arg_5_1, arg_5_2)
	-- function 5
	local _condition_func = self._condition_func(self._volume_system, self._volume_name)

	if not (self._percentage < 1) or not _condition_func then
		self._percentage = 1

		self:server_set_value(self._percentage)
	end
end

VersusVolumeObjectiveExtension._client_update = function (self, arg_6_1, arg_6_2)
	-- function 6
	self._percentage = self:client_get_value()
end

VersusVolumeObjectiveExtension.update_testify = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	Testify:poll_requests_through_handler(testify, arg_7_0)
end

VersusVolumeObjectiveExtension.get_percentage_done = function (self)
	-- function 8
	return self._percentage
end

VersusVolumeObjectiveExtension._get_num_players_inside = function (self)
	-- function 9
	local PLAYER_AND_BOT_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS
	local num = 0

	if self._volume_type == "all_alive_human_players_inside" then
		for i = 1, #PLAYER_AND_BOT_UNITS do
			local var_9_2 = PLAYER_AND_BOT_UNITS[i]
			local var_9_3 = ALIVE[var_9_2]

			var_9_3 = not var_9_3 and ScriptUnit.has_extension(var_9_2, "status_system")

			if not (not var_9_3 and var_9_3:is_disabled()) then
				num = num + 1
			end
		end
	else
		for j = 1, #PLAYER_AND_BOT_UNITS do
			local var_9_4 = PLAYER_AND_BOT_UNITS[j]
			local var_9_5 = ALIVE[var_9_4]

			var_9_5 = not var_9_5 and ScriptUnit.has_extension(var_9_4, "status_system")

			if not var_9_5 and var_9_5:is_disabled() or var_9_5.is_bot or not self._volume_system:player_inside(self._volume_name, var_9_4) then
				num = num + 1
			end
		end
	end

	return num
end

VersusVolumeObjectiveExtension.get_score_for_completion = function (self)
	-- function 10
	if not self:is_done() then
		return 0
	end

	if self._score_for_each_player_inside == 0 then
		return self._score_for_completion
	end

	return self._score_for_completion + self:_get_num_players_inside() * self._score_for_each_player_inside
end

VersusVolumeObjectiveExtension.get_time_for_completion = function (self)
	-- function 11
	if not self:is_done() then
		return 0
	end

	if self._time_for_each_player_inside == 0 then
		return self._time_for_completion
	end

	return self._time_for_completion + self:_get_num_players_inside() * self._time_for_each_player_inside
end
