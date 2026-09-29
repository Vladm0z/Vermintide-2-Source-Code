-- chunkname: @scripts/unit_extensions/objectives/versus_interact_objective_extension.lua

local versus_interact_objective_extension_testify = not not script_data.testify

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

VersusInteractObjectiveExtension._set_objective_data = function (self, objective_data)
	-- function 3
	local interact_default_settings = GameModeSettings.versus.objectives.interact

	self._score_for_completion = not not objective_data.score_for_completion
	self._time_for_completion = not not objective_data.time_for_completion
end

VersusInteractObjectiveExtension._activate = function (self)
	-- function 4
	return
end

VersusInteractObjectiveExtension._server_update = function (self, dt, t)
	-- function 5
	if self._percentage < 1 and self._interactable_extension.interaction_result == self._wanted_interaction_result then
		self._percentage = 1

		self:server_set_value(self._percentage)
	end
end

VersusInteractObjectiveExtension._client_update = function (self, dt, t)
	-- function 6
	self._percentage = self:client_get_value()
end

VersusInteractObjectiveExtension.update_testify = function (self, dt, t)
	-- function 7
	Testify:poll_requests_through_handler(versus_interact_objective_extension_testify, self)
end

VersusInteractObjectiveExtension.get_percentage_done = function (self)
	-- function 8
	return self._percentage
end

VersusInteractObjectiveExtension._deactivate = function (self)
	-- function 9
	return
end
