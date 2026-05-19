-- chunkname: @scripts/unit_extensions/weapons/actions/action_interaction.lua

ActionInteraction = class(ActionInteraction, ActionBase)

function ActionInteraction.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionInteraction.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.interactor_extension = ScriptUnit.extension(arg_1_4, "interactor_system")
end

function ActionInteraction.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)
	ActionInteraction.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)

	arg_2_0.current_action = arg_2_1

	local var_2_0 = arg_2_1.interaction_type

	arg_2_0.interactor_extension:start_interaction(arg_2_1.hold_input, nil, var_2_0)
end

function ActionInteraction.client_owner_post_update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	return
end

function ActionInteraction.finish(arg_4_0, arg_4_1)
	local var_4_0 = Managers.player:unit_owner(arg_4_0.owner_unit)
	local var_4_1 = POSITION_LOOKUP[arg_4_0.owner_unit]

	Managers.telemetry_events:player_used_item(var_4_0, arg_4_0.item_name, var_4_1)
end
