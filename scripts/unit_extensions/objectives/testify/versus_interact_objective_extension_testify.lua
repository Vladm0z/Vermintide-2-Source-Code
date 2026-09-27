-- chunkname: @scripts/unit_extensions/objectives/testify/versus_interact_objective_extension_testify.lua

return {
	versus_objective_simulate_interaction = function (self)
		-- function 1
		local player_unit = Managers.player:local_player().player_unit
		local _unit = self._unit
		local _wanted_interaction_result = self._wanted_interaction_result

		ScriptUnit.extension(_unit, "interactable_system"):set_is_being_interacted_with(player_unit, _wanted_interaction_result)
		InteractionHelper:complete_interaction(player_unit, _unit, _wanted_interaction_result)
	end
}
