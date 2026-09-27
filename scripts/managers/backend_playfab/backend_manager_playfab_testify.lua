-- chunkname: @scripts/managers/backend_playfab/backend_manager_playfab_testify.lua

return {
	clear_backend_inventory = function (self)
		-- function 1
		self:get_backend_mirror():snippet_clear_inventory()
	end,
	request_magic_weapons_for_career = function (self, arg_2_1)
		-- function 2
		local get_all_backend_items = self:get_interface("items"):get_all_backend_items()

		return table.filter(get_all_backend_items, function (self)
			-- function 3
			local flag = self.data.slot_type == "melee" or self.data.slot_type == "ranged"
			local flag_2 = self.data.rarity == "magic"
			local contains = table.contains(self.data.can_wield, arg_2_1)

			return not flag and not contains and flag_2
		end)
	end,
	request_non_magic_weapons_for_career = function (self, arg_4_1)
		-- function 4
		local get_all_backend_items = self:get_interface("items"):get_all_backend_items()

		return table.filter(get_all_backend_items, function (self)
			-- function 5
			local flag = self.data.slot_type == "melee" or self.data.slot_type == "ranged"
			local flag_2 = self.data.rarity == "magic"
			local contains = table.contains(self.data.can_wield, arg_4_1)

			return not flag and not contains and not flag_2
		end)
	end,
	wait_for_playfab_response = function (arg_6_0, arg_6_1)
		-- function 6
		return Testify.RETRY
	end
}
