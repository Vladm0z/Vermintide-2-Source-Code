-- chunkname: @scripts/unit_extensions/objectives/testify/versus_interact_objective_extension_testify.lua

return {
	versus_objective_simulate_interaction = function (arg_1_0)
		local var_1_0 = Managers.player:local_player().player_unit
		local var_1_1 = arg_1_0._unit
		local var_1_2 = arg_1_0._wanted_interaction_result

		ScriptUnit.extension(var_1_1, "interactable_system"):set_is_being_interacted_with(var_1_0, var_1_2)
		InteractionHelper:complete_interaction(var_1_0, var_1_1, var_1_2)
	end
}
