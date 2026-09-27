-- chunkname: @scripts/unit_extensions/weapons/actions/action_interaction.lua

ActionInteraction = class(ActionInteraction, ActionBase)

ActionInteraction.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionInteraction.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.interactor_extension = ScriptUnit.extension(arg_1_4, "interactor_system")
end

ActionInteraction.client_owner_start_action = function (self, arg_2_1, arg_2_2)
	-- function 2
	ActionInteraction.super.client_owner_start_action(self, arg_2_1, arg_2_2)

	self.current_action = arg_2_1

	local interaction_type = arg_2_1.interaction_type

	self.interactor_extension:start_interaction(arg_2_1.hold_input, nil, interaction_type)
end

ActionInteraction.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	return
end

ActionInteraction.finish = function (self, arg_4_1)
	-- function 4
	local unit_owner = Managers.player:unit_owner(self.owner_unit)
	local var_4_1 = POSITION_LOOKUP[self.owner_unit]

	Managers.telemetry_events:player_used_item(unit_owner, self.item_name, var_4_1)
end
