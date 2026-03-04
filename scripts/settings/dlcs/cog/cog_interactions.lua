-- chunkname: @scripts/settings/dlcs/cog/cog_interactions.lua

InteractionDefinitions.cog_missing_cog_pickup = InteractionDefinitions.cog_missing_cog_pickup or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.cog_missing_cog_pickup.config.swap_to_3p = false

InteractionDefinitions.cog_missing_cog_pickup.client.can_interact = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = Managers.player
	local var_1_1 = Managers.player:unit_owner(arg_1_0):stats_id()
	local var_1_2 = var_1_0:statistics_db():get_persistent_stat(var_1_1, "cog_missing_cog")
	local var_1_3 = Managers.unlock
	local var_1_4 = "cog"

	return var_1_2 < 1 and var_1_3:is_dlc_unlocked(var_1_4)
end

InteractionDefinitions.cog_missing_cog_pickup.client.stop = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	arg_2_3.start_time = nil

	if arg_2_6 == InteractionResult.SUCCESS and not arg_2_3.is_husk then
		local var_2_0 = Managers.player:unit_owner(arg_2_1)

		if var_2_0 and var_2_0.local_player and not var_2_0.bot_player then
			local var_2_1 = Managers.player:statistics_db()
			local var_2_2 = var_2_0:stats_id()

			var_2_1:increment_stat(var_2_2, "cog_missing_cog")
			Managers.backend:commit()
		end
	end

	local var_2_3 = "lua_interaction_stopped_smartobject_" .. InteractionResult[arg_2_6]

	Unit.flow_event(arg_2_2, var_2_3)
end

InteractionDefinitions.cog_missing_cog_pickup.client.hud_description = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	return Unit.get_data(arg_3_0, "interaction_data", "hud_description"), Unit.get_data(arg_3_0, "interaction_data", "hud_interaction_action")
end
