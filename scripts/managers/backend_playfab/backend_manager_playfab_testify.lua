-- chunkname: @scripts/managers/backend_playfab/backend_manager_playfab_testify.lua

return {
	clear_backend_inventory = function(arg_1_0)
		arg_1_0:get_backend_mirror():snippet_clear_inventory()
	end,
	request_magic_weapons_for_career = function(arg_2_0, arg_2_1)
		local var_2_0 = arg_2_0:get_interface("items"):get_all_backend_items()

		return table.filter(var_2_0, function(arg_3_0)
			local var_3_0 = arg_3_0.data.slot_type == "melee" or arg_3_0.data.slot_type == "ranged"
			local var_3_1 = arg_3_0.data.rarity == "magic"
			local var_3_2 = table.contains(arg_3_0.data.can_wield, arg_2_1)

			return var_3_0 and var_3_2 and var_3_1
		end)
	end,
	request_non_magic_weapons_for_career = function(arg_4_0, arg_4_1)
		local var_4_0 = arg_4_0:get_interface("items"):get_all_backend_items()

		return table.filter(var_4_0, function(arg_5_0)
			local var_5_0 = arg_5_0.data.slot_type == "melee" or arg_5_0.data.slot_type == "ranged"
			local var_5_1 = arg_5_0.data.rarity == "magic"
			local var_5_2 = table.contains(arg_5_0.data.can_wield, arg_4_1)

			return var_5_0 and var_5_2 and not var_5_1
		end)
	end,
	wait_for_playfab_response = function(arg_6_0, arg_6_1)
		return Testify.RETRY
	end
}
