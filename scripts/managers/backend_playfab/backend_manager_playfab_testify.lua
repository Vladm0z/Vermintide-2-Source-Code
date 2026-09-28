-- chunkname: @scripts/managers/backend_playfab/backend_manager_playfab_testify.lua

local BackendManagerPlayFabTestify = {
	clear_backend_inventory = function (backend_manager_playfab)
		-- function 1
		local backend_mirror = backend_manager_playfab:get_backend_mirror()

		backend_mirror:snippet_clear_inventory()
	end,
	request_magic_weapons_for_career = function (backend_manager_playfab, career_name)
		-- function 2
		local items = backend_manager_playfab:get_interface("items"):get_all_backend_items()

		return table.filter(items, function (item)
			-- function 3
			local is_weapon = item.data.slot_type == "melee" or item.data.slot_type == "ranged"
			local is_magic = item.data.rarity == "magic"
			local can_wield = table.contains(item.data.can_wield, career_name)

			return not not is_weapon and not not can_wield and not not is_magic
		end)
	end,
	request_non_magic_weapons_for_career = function (backend_manager_playfab, career_name)
		-- function 4
		local items = backend_manager_playfab:get_interface("items"):get_all_backend_items()

		return table.filter(items, function (item)
			-- function 5
			local is_weapon = item.data.slot_type == "melee" or item.data.slot_type == "ranged"
			local is_magic = item.data.rarity == "magic"
			local can_wield = table.contains(item.data.can_wield, career_name)

			return not not is_weapon and not not can_wield and not not not is_magic
		end)
	end,
	wait_for_playfab_response = function (backend_manager_playfab, cloudscript_function)
		-- function 6
		return Testify.RETRY
	end
}

return BackendManagerPlayFabTestify
