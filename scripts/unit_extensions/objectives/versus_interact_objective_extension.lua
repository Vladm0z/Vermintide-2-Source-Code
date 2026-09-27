-- chunkname: @scripts/unit_extensions/objectives/versus_interact_objective_extension.lua

local testify = script_data.testify

testify = not testify and require("scripts/unit_extensions/objectives/testify/versus_interact_objective_extension_testify")
VersusInteractObjectiveExtension = class(VersusInteractObjectiveExtension, BaseObjectiveExtension)
VersusInteractObjectiveExtension.NAME = "VersusInteractObjectiveExtension"

VersusInteractObjectiveExtension.init = function (self, ...)
	-- function 1
	VersusInteractObjectiveExtension.super.init(self, ...)

	self._wanted_interaction_result = InteractionResult.SUCCESS
	self._percentage = 0
end

VersusInteractObjectiveExtension.extensions_ready = function (self)
	-- function 2
	self._interactable_extension = ScriptUnit.has_extension(self._unit, "interactable_system")
end

VersusInteractObjectiveExtension._set_objective_data = function (self, arg_3_1)
	-- function 3
	local interact = GameModeSettings.versus.objectives.interact
	local score_for_completion = arg_3_1.score_for_completion

	score_for_completion = score_for_completion or interact.score_for_completion
	self._score_for_completion = score_for_completion

	local time_for_completion = arg_3_1.time_for_completion

	time_for_completion = time_for_completion or interact.time_for_completion
	self._time_for_completion = time_for_completion
end

VersusInteractObjectiveExtension._activate = function (arg_4_0)
	-- function 4
	return
end

VersusInteractObjectiveExtension._server_update = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not (not (self._percentage < 1) or self._interactable_extension.interaction_result ~= self._wanted_interaction_result) then
		self._percentage = 1

		self:server_set_value(self._percentage)
	end
end

VersusInteractObjectiveExtension._client_update = function (self, arg_6_1, arg_6_2)
	-- function 6
	self._percentage = self:client_get_value()
end

VersusInteractObjectiveExtension.update_testify = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	Testify:poll_requests_through_handler(testify, arg_7_0)
end

VersusInteractObjectiveExtension.get_percentage_done = function (self)
	-- function 8
	return self._percentage
end

VersusInteractObjectiveExtension._deactivate = function (arg_9_0)
	-- function 9
	return
end
