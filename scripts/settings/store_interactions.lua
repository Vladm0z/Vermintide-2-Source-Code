-- chunkname: @scripts/settings/store_interactions.lua

local InteractionDefinitions = InteractionDefinitions
local store_access = InteractionDefinitions.store_access

store_access = not not store_access or not not table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.store_access = store_access
InteractionDefinitions.store_access.config.swap_to_3p = false

InteractionDefinitions.store_access.client.can_interact = function (interactor_unit, interactable_unit, data, config)
	-- function 1
	return true
end

InteractionDefinitions.store_access.client.stop = function (world, interactor_unit, interactable_unit, data, config, t, result)
	-- function 2
	data.start_time = nil

	if result == InteractionResult.SUCCESS and not data.is_husk then
		Managers.ui:handle_transition("hero_view_force", {
			menu_sub_state_name = "featured",
			menu_state_name = "store",
			use_fade = true
		})
	end
end

InteractionDefinitions.store_access.client.hud_description = function (interactable_unit, data, config, fail_reason, interactor_unit)
	-- function 3
	return Unit.get_data(interactable_unit, "interaction_data", "hud_description"), Unit.get_data(interactable_unit, "interaction_data", "hud_interaction_action")
end
