-- chunkname: @scripts/settings/mutators/mutator_blessing_of_ranald.lua

require("scripts/settings/dlcs/morris/deus_blessing_settings")

return {
	display_name = DeusBlessingSettings.blessing_of_ranald.display_name,
	description = DeusBlessingSettings.blessing_of_ranald.description,
	icon = DeusBlessingSettings.blessing_of_ranald.icon,
	server_update_function = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
		-- function 1
		MutatorUtils.apply_buff_to_alive_player_units(arg_1_0, arg_1_1, "blessing_of_ranald_damage_taken")
	end,
	client_update_function = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		-- function 2
		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit

		if not local_player and not ALIVE[flag] then
			local has_extension = ScriptUnit.has_extension(flag, "buff_system")

			if not (not has_extension and has_extension:has_buff_type("blessing_of_ranald_coins_greed")) then
				has_extension:add_buff("blessing_of_ranald_coins_greed")
			end
		end
	end
}
