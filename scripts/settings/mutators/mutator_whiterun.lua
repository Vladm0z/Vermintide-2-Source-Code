-- chunkname: @scripts/settings/mutators/mutator_whiterun.lua

local function var_0_0()
	local var_1_0 = Managers.state.network.profile_synchronizer
	local var_1_1 = Managers.player:local_player()

	if not var_1_1 then
		return
	end

	local var_1_2 = ScriptUnit.has_extension(var_1_1.player_unit, "talent_system")

	if var_1_2 then
		var_1_2:talents_changed()
	else
		local var_1_3 = var_1_1.bot_player
		local var_1_4 = false

		var_1_0:resync_loadout(var_1_1:network_id(), var_1_1:local_player_id(), var_1_3, var_1_4)
	end
end

return {
	description = "description_mutator_whiterun",
	display_name = "display_name_mutator_whiterun",
	icon = "mutator_icon_whiterun",
	client_start_function = var_0_0,
	client_stop_function = var_0_0,
	check_dependencies = function()
		if not BackendUtils.get_total_power_level then
			return false
		end

		if not GearUtils.get_property_and_trait_buffs then
			return false
		end

		return true
	end
}
