-- chunkname: @scripts/unit_extensions/objectives/versus_interact_objective_extension.lua

local var_0_0 = script_data.testify and require("scripts/unit_extensions/objectives/testify/versus_interact_objective_extension_testify")

VersusInteractObjectiveExtension = class(VersusInteractObjectiveExtension, BaseObjectiveExtension)
VersusInteractObjectiveExtension.NAME = "VersusInteractObjectiveExtension"

function VersusInteractObjectiveExtension.init(arg_1_0, ...)
	VersusInteractObjectiveExtension.super.init(arg_1_0, ...)

	arg_1_0._wanted_interaction_result = InteractionResult.SUCCESS
	arg_1_0._percentage = 0
end

function VersusInteractObjectiveExtension.extensions_ready(arg_2_0)
	arg_2_0._interactable_extension = ScriptUnit.has_extension(arg_2_0._unit, "interactable_system")
end

function VersusInteractObjectiveExtension._set_objective_data(arg_3_0, arg_3_1)
	local var_3_0 = GameModeSettings.versus.objectives.interact

	arg_3_0._score_for_completion = arg_3_1.score_for_completion or var_3_0.score_for_completion
	arg_3_0._time_for_completion = arg_3_1.time_for_completion or var_3_0.time_for_completion
end

function VersusInteractObjectiveExtension._activate(arg_4_0)
	return
end

function VersusInteractObjectiveExtension._server_update(arg_5_0, arg_5_1, arg_5_2)
	if arg_5_0._percentage < 1 and arg_5_0._interactable_extension.interaction_result == arg_5_0._wanted_interaction_result then
		arg_5_0._percentage = 1

		arg_5_0:server_set_value(arg_5_0._percentage)
	end
end

function VersusInteractObjectiveExtension._client_update(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0._percentage = arg_6_0:client_get_value()
end

function VersusInteractObjectiveExtension.update_testify(arg_7_0, arg_7_1, arg_7_2)
	Testify:poll_requests_through_handler(var_0_0, arg_7_0)
end

function VersusInteractObjectiveExtension.get_percentage_done(arg_8_0)
	return arg_8_0._percentage
end

function VersusInteractObjectiveExtension._deactivate(arg_9_0)
	return
end
