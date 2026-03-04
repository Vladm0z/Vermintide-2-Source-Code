-- chunkname: @scripts/settings/store_interactions.lua

InteractionDefinitions.store_access = InteractionDefinitions.store_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.store_access.config.swap_to_3p = false

function InteractionDefinitions.store_access.client.can_interact(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	return true
end

function InteractionDefinitions.store_access.client.stop(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	arg_2_3.start_time = nil

	if arg_2_6 == InteractionResult.SUCCESS and not arg_2_3.is_husk then
		Managers.ui:handle_transition("hero_view_force", {
			menu_sub_state_name = "featured",
			menu_state_name = "store",
			use_fade = true
		})
	end
end

function InteractionDefinitions.store_access.client.hud_description(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	return Unit.get_data(arg_3_0, "interaction_data", "hud_description"), Unit.get_data(arg_3_0, "interaction_data", "hud_interaction_action")
end
