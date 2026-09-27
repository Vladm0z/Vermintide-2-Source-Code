-- chunkname: @scripts/settings/mutators/mutator_whiterun.lua

local function fn()
	-- function 1
	local profile_synchronizer = Managers.state.network.profile_synchronizer
	local local_player = Managers.player:local_player()

	if not local_player then
		return
	end

	local has_extension = ScriptUnit.has_extension(local_player.player_unit, "talent_system")

	if not has_extension then
		has_extension:talents_changed()
	else
		local bot_player = local_player.bot_player
		local flag = false

		profile_synchronizer:resync_loadout(local_player:network_id(), local_player:local_player_id(), bot_player, flag)
	end
end

return {
	description = "description_mutator_whiterun",
	display_name = "display_name_mutator_whiterun",
	icon = "mutator_icon_whiterun",
	client_start_function = fn,
	client_stop_function = fn,
	check_dependencies = function ()
		-- function 2
		if not BackendUtils.get_total_power_level then
			return false
		end

		if not GearUtils.get_property_and_trait_buffs then
			return false
		end

		return true
	end
}
