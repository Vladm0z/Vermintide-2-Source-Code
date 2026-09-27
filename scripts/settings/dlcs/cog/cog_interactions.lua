-- chunkname: @scripts/settings/dlcs/cog/cog_interactions.lua

local InteractionDefinitions = InteractionDefinitions
local cog_missing_cog_pickup = InteractionDefinitions.cog_missing_cog_pickup

cog_missing_cog_pickup = cog_missing_cog_pickup or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.cog_missing_cog_pickup = cog_missing_cog_pickup
InteractionDefinitions.cog_missing_cog_pickup.config.swap_to_3p = false

InteractionDefinitions.cog_missing_cog_pickup.client.can_interact = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local player = Managers.player
	local stats_id = Managers.player:unit_owner(arg_1_0):stats_id()
	local get_persistent_stat = player:statistics_db():get_persistent_stat(stats_id, "cog_missing_cog")
	local unlock = Managers.unlock
	local str = "cog"

	return not (get_persistent_stat < 1) or unlock:is_dlc_unlocked(str)
end

InteractionDefinitions.cog_missing_cog_pickup.client.stop = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	-- function 2
	arg_2_3.start_time = nil

	if not (arg_2_6 ~= InteractionResult.SUCCESS or arg_2_3.is_husk) then
		local unit_owner = Managers.player:unit_owner(arg_2_1)

		if not (not unit_owner and not unit_owner.local_player and unit_owner.bot_player) then
			local statistics_db = Managers.player:statistics_db()
			local stats_id = unit_owner:stats_id()

			statistics_db:increment_stat(stats_id, "cog_missing_cog")
			Managers.backend:commit()
		end
	end

	local str = "lua_interaction_stopped_smartobject_" .. InteractionResult[arg_2_6]

	Unit.flow_event(arg_2_2, str)
end

InteractionDefinitions.cog_missing_cog_pickup.client.hud_description = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	return Unit.get_data(arg_3_0, "interaction_data", "hud_description"), Unit.get_data(arg_3_0, "interaction_data", "hud_interaction_action")
end
