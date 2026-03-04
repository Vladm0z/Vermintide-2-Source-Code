-- chunkname: @scripts/settings/mutators/mutator_blessing_of_ranald.lua

require("scripts/settings/dlcs/morris/deus_blessing_settings")

return {
	display_name = DeusBlessingSettings.blessing_of_ranald.display_name,
	description = DeusBlessingSettings.blessing_of_ranald.description,
	icon = DeusBlessingSettings.blessing_of_ranald.icon,
	server_update_function = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
		MutatorUtils.apply_buff_to_alive_player_units(arg_1_0, arg_1_1, "blessing_of_ranald_damage_taken")
	end,
	client_update_function = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		local var_2_0 = Managers.player:local_player()
		local var_2_1 = var_2_0 and var_2_0.player_unit

		if var_2_0 and ALIVE[var_2_1] then
			local var_2_2 = ScriptUnit.has_extension(var_2_1, "buff_system")

			if var_2_2 and not var_2_2:has_buff_type("blessing_of_ranald_coins_greed") then
				var_2_2:add_buff("blessing_of_ranald_coins_greed")
			end
		end
	end
}
