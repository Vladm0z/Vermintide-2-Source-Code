-- chunkname: @scripts/settings/crafting/crafting_recipes.lua

CraftingSettings = {
	NUM_SALVAGE_SLOTS = 9
}

local tbl = {
	{
		result_function = "salvage_result_func",
		name = "salvage",
		display_name = "crafting_recipe_salvage",
		lore_text = "recipe_salvage_lore_text",
		validation_function = "salvage_validation_func",
		result_function_playfab = "craftingSalvage",
		hero_specific_filter = true,
		item_filter = "can_salvage and not is_equipped and not is_equipped_by_any_loadout",
		description_text = "description_crafting_recipe_salvage",
		display_icon_console = "console_crafting_recipe_icon_salvage",
		salvagable_slot_types = {
			ring = true,
			melee = true,
			necklace = true,
			trinket = true,
			ranged = true,
			hat = true
		},
		item_sort_func = function (self, arg_1_1)
			-- function 1
			local data = self.data
			local data_2 = arg_1_1.data
			local power_level = self.power_level

			power_level = power_level or math.huge

			local power_level_2 = arg_1_1.power_level

			power_level_2 = power_level_2 or math.huge

			local item_type = data.item_type
			local item_type_2 = data_2.item_type
			local backend_id = self.backend_id
			local backend_id_2 = arg_1_1.backend_id
			local is_favorite_backend_id = ItemHelper.is_favorite_backend_id(backend_id, self)

			if is_favorite_backend_id == ItemHelper.is_favorite_backend_id(backend_id_2, arg_1_1) then
				if power_level == power_level_2 then
					local rarity = self.rarity

					rarity = rarity or data.rarity

					local rarity_2 = arg_1_1.rarity

					rarity_2 = rarity_2 or data_2.rarity

					local item_rarity_order = UISettings.item_rarity_order
					local var_1_12 = item_rarity_order[rarity]
					local var_1_13 = item_rarity_order[rarity_2]
					local cosmetics_sorting_order = UISettings.cosmetics_sorting_order
					local var_1_15 = cosmetics_sorting_order[item_type]

					var_1_15 = var_1_15 or 0

					local var_1_16 = cosmetics_sorting_order[item_type_2]

					var_1_16 = var_1_16 or 0

					local flag

					flag = item_type == "skin" or item_type == "hat"

					local flag_2

					flag_2 = item_type_2 == "skin" or item_type_2 == "hat"

					if var_1_15 == var_1_16 then
						if var_1_12 == var_1_13 then
							local var_1_19 = Localize(item_type)
							local var_1_20 = Localize(item_type)

							if var_1_19 == var_1_20 then
								local get_ui_information_from_item, var_1_22 = UIUtils.get_ui_information_from_item(self)
								local get_ui_information_from_item_2, var_1_24 = UIUtils.get_ui_information_from_item(arg_1_1)

								if var_1_22 == var_1_24 then
									return backend_id < backend_id_2
								else
									return Localize(var_1_22) < Localize(var_1_24)
								end
							else
								return var_1_19 < var_1_20
							end
						else
							return var_1_13 < var_1_12
						end
					else
						return var_1_15 < var_1_16
					end
				else
					return power_level < power_level_2
				end
			elseif not is_favorite_backend_id then
				return false
			else
				return true
			end
		end,
		input_func = function (self, arg_2_1)
			-- function 2
			local var_2_0

			if not Managers.input:is_device_active("gamepad") then
				if not arg_2_1:get("right_stick_press") then
					local _item_grid = self._item_grid
					local get_item_hovered, var_2_3 = _item_grid:get_item_hovered()

					if not get_item_hovered then
						get_item_hovered, var_2_3 = _item_grid:selected_item()
					end

					var_2_0 = {}

					if not (not get_item_hovered and var_2_3) then
						local rarity = get_item_hovered.rarity

						var_2_0[#var_2_0 + 1] = get_item_hovered.backend_id

						local items = _item_grid:items()

						for i, v in ipairs(items) do
							local backend_id = v.backend_id

							if not (v.rarity ~= rarity or table.find(var_2_0, backend_id)) then
								var_2_0[#var_2_0 + 1] = backend_id

								if table.size(var_2_0) == CraftingSettings.NUM_SALVAGE_SLOTS then
									break
								end
							end
						end
					end
				end
			else
				var_2_0 = {}

				local get_auto_fill_rarity = self.parent:get_auto_fill_rarity()

				if not get_auto_fill_rarity then
					local items_2 = self._item_grid:items()

					for i_2, v_2 in ipairs(items_2) do
						local backend_id_2 = v_2.backend_id

						if not (v_2.rarity ~= get_auto_fill_rarity or table.find(var_2_0, backend_id_2)) then
							var_2_0[#var_2_0 + 1] = backend_id_2

							if table.size(var_2_0) == CraftingSettings.NUM_SALVAGE_SLOTS then
								break
							end
						end
					end
				end
			end

			self.parent:set_selected_items_backend_ids(var_2_0)
		end
	},
	{
		result_function = "craft_random_item_result_func",
		name = "craft_random_item",
		display_name = "crafting_recipe_craft_item",
		lore_text = "crafting_recipe_random_item_lore_text",
		validation_function = "craft_validation_func",
		result_function_playfab = "craftingRandomItem",
		hero_specific_filter = true,
		item_filter = "can_craft_with",
		description_text = "description_crafting_recipe_craft_item",
		display_icon_console = "console_crafting_recipe_icon_craft",
		ingredients = {
			{
				amount = 10,
				name = "crafting_material_scrap"
			}
		},
		item_sort_func = function (self, arg_3_1)
			-- function 3
			local data = self.data
			local data_2 = arg_3_1.data
			local var_3_2 = Localize(data.item_type)
			local var_3_3 = Localize(data_2.item_type)
			local backend_id = self.backend_id
			local backend_id_2 = arg_3_1.backend_id
			local is_favorite_backend_id = ItemHelper.is_favorite_backend_id(backend_id, self)

			if is_favorite_backend_id == ItemHelper.is_favorite_backend_id(backend_id_2, arg_3_1) then
				if var_3_2 == var_3_3 then
					local get_ui_information_from_item, var_3_8 = UIUtils.get_ui_information_from_item(self)
					local get_ui_information_from_item_2, var_3_10 = UIUtils.get_ui_information_from_item(arg_3_1)

					return Localize(var_3_8) < Localize(var_3_10)
				else
					return var_3_2 < var_3_3
				end
			elseif not is_favorite_backend_id then
				return true
			else
				return false
			end
		end
	},
	{
		result_function = "craft_jewellery_result_func",
		name = "craft_jewellery",
		display_name = "crafting_recipe_craft_jewellery",
		lore_text = "crafting_recipe_jewellery_lore_text",
		validation_function = "craft_validation_func",
		result_function_playfab = "craftingSpecificItem",
		hero_specific_filter = true,
		item_filter = "can_craft_with",
		description_text = "description_crafting_recipe_craft_jewellery",
		display_icon_console = "console_crafting_recipe_icon_craft",
		ingredients = {
			{
				amount = 1,
				name = "crafting_material_jewellery"
			},
			{
				amount = 10,
				name = "crafting_material_scrap"
			},
			{
				catergory = {
					item_value = "slot_type",
					category_table = "jewellery_slot_types"
				}
			}
		},
		item_sort_func = function (self, arg_4_1)
			-- function 4
			local data = self.data
			local data_2 = arg_4_1.data
			local var_4_2 = Localize(data.item_type)
			local var_4_3 = Localize(data_2.item_type)
			local backend_id = self.backend_id
			local backend_id_2 = arg_4_1.backend_id
			local is_favorite_backend_id = ItemHelper.is_favorite_backend_id(backend_id, self)

			if is_favorite_backend_id == ItemHelper.is_favorite_backend_id(backend_id_2, arg_4_1) then
				if var_4_2 == var_4_3 then
					local get_ui_information_from_item, var_4_8 = UIUtils.get_ui_information_from_item(self)
					local get_ui_information_from_item_2, var_4_10 = UIUtils.get_ui_information_from_item(arg_4_1)

					return Localize(var_4_8) < Localize(var_4_10)
				else
					return var_4_2 < var_4_3
				end
			elseif not is_favorite_backend_id then
				return true
			else
				return false
			end
		end
	},
	{
		result_function = "craft_weapon_result_func",
		name = "craft_weapon",
		display_name = "crafting_recipe_craft_weapon",
		lore_text = "crafting_recipe_weapon_lore_text",
		validation_function = "craft_validation_func",
		result_function_playfab = "craftingSpecificItem",
		hero_specific_filter = true,
		item_filter = "can_craft_with",
		description_text = "description_crafting_recipe_craft_weapon",
		display_icon_console = "console_crafting_recipe_icon_craft",
		ingredients = {
			{
				amount = 1,
				name = "crafting_material_weapon"
			},
			{
				amount = 10,
				name = "crafting_material_scrap"
			},
			{
				catergory = {
					item_value = "slot_type",
					category_table = "weapon_slot_types"
				}
			}
		},
		item_sort_func = function (self, arg_5_1)
			-- function 5
			local data = self.data
			local data_2 = arg_5_1.data
			local var_5_2 = Localize(data.item_type)
			local var_5_3 = Localize(data_2.item_type)
			local backend_id = self.backend_id
			local backend_id_2 = arg_5_1.backend_id
			local is_favorite_backend_id = ItemHelper.is_favorite_backend_id(backend_id, self)

			if is_favorite_backend_id == ItemHelper.is_favorite_backend_id(backend_id_2, arg_5_1) then
				if var_5_2 == var_5_3 then
					local get_ui_information_from_item, var_5_8 = UIUtils.get_ui_information_from_item(self)
					local get_ui_information_from_item_2, var_5_10 = UIUtils.get_ui_information_from_item(arg_5_1)

					return Localize(var_5_8) < Localize(var_5_10)
				else
					return var_5_2 < var_5_3
				end
			elseif not is_favorite_backend_id then
				return true
			else
				return false
			end
		end
	},
	{
		result_function = "reroll_weapon_properties_result_func",
		name = "reroll_weapon_properties",
		display_name = "crafting_recipe_weapon_reroll_properties",
		lore_text = "crafting_recipe_reroll_weapon_properties_lore_text",
		validation_function = "craft_validation_func",
		result_function_playfab = "craftingRerollProperties",
		hero_specific_filter = true,
		item_filter = "has_properties and item_rarity ~= magic",
		description_text = "description_crafting_recipe_weapon_reroll_properties",
		display_icon_console = "console_crafting_recipe_icon_properties",
		ingredients = {
			{
				amount = 1,
				name = "crafting_material_dust_1"
			},
			{
				amount = 1,
				name = "crafting_material_dust_2"
			},
			{
				catergory = {
					item_value = "slot_type",
					category_table = "weapon_slot_types"
				}
			}
		},
		item_sort_func = function (self, arg_6_1)
			-- function 6
			local data = self.data
			local data_2 = arg_6_1.data
			local power_level = self.power_level

			power_level = power_level or 0

			local power_level_2 = arg_6_1.power_level

			power_level_2 = power_level_2 or 0

			local backend_id = self.backend_id
			local backend_id_2 = arg_6_1.backend_id
			local is_favorite_backend_id = ItemHelper.is_favorite_backend_id(backend_id, self)

			if is_favorite_backend_id == ItemHelper.is_favorite_backend_id(backend_id_2, arg_6_1) then
				if power_level == power_level_2 then
					local rarity = self.rarity

					rarity = rarity or data.rarity

					local rarity_2 = arg_6_1.rarity

					rarity_2 = rarity_2 or data_2.rarity

					local item_rarity_order = UISettings.item_rarity_order
					local var_6_10 = item_rarity_order[rarity]
					local var_6_11 = item_rarity_order[rarity_2]

					if var_6_10 == var_6_11 then
						local var_6_12 = Localize(data.item_type)
						local var_6_13 = Localize(data_2.item_type)

						if var_6_12 == var_6_13 then
							local get_ui_information_from_item, var_6_15 = UIUtils.get_ui_information_from_item(self)
							local get_ui_information_from_item_2, var_6_17 = UIUtils.get_ui_information_from_item(arg_6_1)

							return Localize(var_6_15) < Localize(var_6_17)
						else
							return var_6_12 < var_6_13
						end
					else
						return var_6_10 < var_6_11
					end
				else
					return power_level_2 < power_level
				end
			elseif not is_favorite_backend_id then
				return true
			else
				return false
			end
		end
	},
	{
		result_function = "reroll_jewellery_properties_result_func",
		name = "reroll_jewellery_properties",
		display_name = "crafting_recipe_jewellery_reroll_properties",
		lore_text = "crafting_recipe_reroll_jewellery_properties_lore_text",
		validation_function = "craft_validation_func",
		result_function_playfab = "craftingRerollProperties",
		hero_specific_filter = true,
		item_filter = "has_properties and item_rarity ~= magic",
		description_text = "description_crafting_recipe_jewellery_reroll_properties",
		display_icon_console = "console_crafting_recipe_icon_properties",
		ingredients = {
			{
				amount = 1,
				name = "crafting_material_dust_1"
			},
			{
				amount = 1,
				name = "crafting_material_dust_2"
			},
			{
				catergory = {
					item_value = "slot_type",
					category_table = "jewellery_slot_types"
				}
			}
		},
		item_sort_func = function (self, arg_7_1)
			-- function 7
			local data = self.data
			local data_2 = arg_7_1.data
			local power_level = self.power_level

			power_level = power_level or 0

			local power_level_2 = arg_7_1.power_level

			power_level_2 = power_level_2 or 0

			local backend_id = self.backend_id
			local backend_id_2 = arg_7_1.backend_id
			local is_favorite_backend_id = ItemHelper.is_favorite_backend_id(backend_id, self)

			if is_favorite_backend_id == ItemHelper.is_favorite_backend_id(backend_id_2, arg_7_1) then
				if power_level == power_level_2 then
					local rarity = self.rarity

					rarity = rarity or data.rarity

					local rarity_2 = arg_7_1.rarity

					rarity_2 = rarity_2 or data_2.rarity

					local item_rarity_order = UISettings.item_rarity_order
					local var_7_10 = item_rarity_order[rarity]
					local var_7_11 = item_rarity_order[rarity_2]

					if var_7_10 == var_7_11 then
						local var_7_12 = Localize(data.item_type)
						local var_7_13 = Localize(data_2.item_type)

						if var_7_12 == var_7_13 then
							local get_ui_information_from_item, var_7_15 = UIUtils.get_ui_information_from_item(self)
							local get_ui_information_from_item_2, var_7_17 = UIUtils.get_ui_information_from_item(arg_7_1)

							return Localize(var_7_15) < Localize(var_7_17)
						else
							return var_7_12 < var_7_13
						end
					else
						return var_7_10 < var_7_11
					end
				else
					return power_level_2 < power_level
				end
			elseif not is_favorite_backend_id then
				return true
			else
				return false
			end
		end
	},
	{
		result_function = "reroll_weapon_traits_result_func",
		name = "reroll_weapon_traits",
		display_name = "crafting_recipe_weapon_reroll_traits",
		lore_text = "crafting_recipe_reroll_weapon_traits_lore_text",
		validation_function = "craft_validation_func",
		result_function_playfab = "craftingRerollTraits",
		hero_specific_filter = true,
		item_filter = "has_traits and item_rarity ~= magic",
		description_text = "description_crafting_recipe_weapon_reroll_traits",
		display_icon_console = "console_crafting_recipe_icon_trait",
		ingredients = {
			{
				amount = 1,
				name = "crafting_material_dust_3"
			},
			{
				catergory = {
					item_value = "slot_type",
					category_table = "weapon_slot_types"
				}
			}
		},
		item_sort_func = function (self, arg_8_1)
			-- function 8
			local data = self.data
			local data_2 = arg_8_1.data
			local power_level = self.power_level

			power_level = power_level or 0

			local power_level_2 = arg_8_1.power_level

			power_level_2 = power_level_2 or 0

			local backend_id = self.backend_id
			local backend_id_2 = arg_8_1.backend_id
			local is_favorite_backend_id = ItemHelper.is_favorite_backend_id(backend_id, self)

			if is_favorite_backend_id == ItemHelper.is_favorite_backend_id(backend_id_2, arg_8_1) then
				if power_level == power_level_2 then
					local rarity = self.rarity

					rarity = rarity or data.rarity

					local rarity_2 = arg_8_1.rarity

					rarity_2 = rarity_2 or data_2.rarity

					local item_rarity_order = UISettings.item_rarity_order
					local var_8_10 = item_rarity_order[rarity]
					local var_8_11 = item_rarity_order[rarity_2]

					if var_8_10 == var_8_11 then
						local var_8_12 = Localize(data.item_type)
						local var_8_13 = Localize(data_2.item_type)

						if var_8_12 == var_8_13 then
							local get_ui_information_from_item, var_8_15 = UIUtils.get_ui_information_from_item(self)
							local get_ui_information_from_item_2, var_8_17 = UIUtils.get_ui_information_from_item(arg_8_1)

							return Localize(var_8_15) < Localize(var_8_17)
						else
							return var_8_12 < var_8_13
						end
					else
						return var_8_10 < var_8_11
					end
				else
					return power_level_2 < power_level
				end
			elseif not is_favorite_backend_id then
				return true
			else
				return false
			end
		end
	},
	{
		result_function = "reroll_jewellery_traits_result_func",
		name = "reroll_jewellery_traits",
		display_name = "crafting_recipe_jewellery_reroll_traits",
		lore_text = "crafting_recipe_reroll_jewellery_traits_lore_text",
		validation_function = "craft_validation_func",
		result_function_playfab = "craftingRerollTraits",
		hero_specific_filter = true,
		item_filter = "has_traits and item_rarity ~= magic",
		description_text = "description_crafting_recipe_jewellery_reroll_traits",
		display_icon_console = "console_crafting_recipe_icon_trait",
		ingredients = {
			{
				amount = 1,
				name = "crafting_material_dust_3"
			},
			{
				catergory = {
					item_value = "slot_type",
					category_table = "jewellery_slot_types"
				}
			}
		}
	},
	{
		result_function = "extract_weapon_skin_result_func",
		name = "extract_weapon_skin",
		display_name = "crafting_recipe_extract_weapon_skin",
		lore_text = "crafting_recipe_reroll_extract_weapon_skin",
		validation_function = "craft_validation_func",
		result_function_playfab = "craftingExtractSkin",
		hero_specific_filter = true,
		item_filter = "has_applied_skin and item_rarity ~= magic and not is_equipped and not is_equipped_by_any_loadout",
		description_text = "description_crafting_recipe_extract_weapon_skin",
		display_icon_console = "console_crafting_recipe_icon_extract",
		ingredients = {
			{
				multiple_check_func = "check_has_skin",
				catergory = {
					item_value = "slot_type",
					category_table = "weapon_slot_types"
				}
			}
		},
		item_sort_func = function (self, arg_9_1)
			-- function 9
			local data = self.data
			local data_2 = arg_9_1.data
			local power_level = self.power_level

			power_level = power_level or 0

			local power_level_2 = arg_9_1.power_level

			power_level_2 = power_level_2 or 0

			local backend_id = self.backend_id
			local backend_id_2 = arg_9_1.backend_id
			local is_favorite_backend_id = ItemHelper.is_favorite_backend_id(backend_id, self)

			if is_favorite_backend_id == ItemHelper.is_favorite_backend_id(backend_id_2, arg_9_1) then
				if power_level == power_level_2 then
					local rarity = self.rarity

					rarity = rarity or data.rarity

					local rarity_2 = arg_9_1.rarity

					rarity_2 = rarity_2 or data_2.rarity

					local item_rarity_order = UISettings.item_rarity_order
					local var_9_10 = item_rarity_order[rarity]
					local var_9_11 = item_rarity_order[rarity_2]

					if var_9_10 == var_9_11 then
						local var_9_12 = Localize(data.item_type)
						local var_9_13 = Localize(data_2.item_type)

						if var_9_12 == var_9_13 then
							local get_ui_information_from_item, var_9_15 = UIUtils.get_ui_information_from_item(self)
							local get_ui_information_from_item_2, var_9_17 = UIUtils.get_ui_information_from_item(arg_9_1)

							return Localize(var_9_15) < Localize(var_9_17)
						else
							return var_9_12 < var_9_13
						end
					else
						return var_9_10 < var_9_11
					end
				else
					return power_level_2 < power_level
				end
			elseif not is_favorite_backend_id then
				return true
			else
				return false
			end
		end
	},
	{
		result_function = "apply_weapon_skin_result_func",
		name = "apply_weapon_skin",
		display_name = "crafting_recipe_apply_weapon_skin",
		lore_text = "crafting_recipe_reroll_apply_weapon_skin",
		validation_function = "weapon_skin_application_validation_func",
		result_function_playfab = "craftingApplySkin2",
		hero_specific_filter = true,
		item_filter = "can_apply_skin",
		description_text = "description_crafting_recipe_apply_weapon_skin",
		display_icon_console = "console_crafting_recipe_icon_apply",
		ingredients = {},
		item_sort_func = function (self, arg_10_1)
			-- function 10
			local data = self.data
			local data_2 = arg_10_1.data
			local power_level = self.power_level

			power_level = power_level or 0

			local power_level_2 = arg_10_1.power_level

			power_level_2 = power_level_2 or 0

			local backend_id = self.backend_id
			local backend_id_2 = arg_10_1.backend_id
			local is_favorite_backend_id = ItemHelper.is_favorite_backend_id(backend_id, self)

			if is_favorite_backend_id == ItemHelper.is_favorite_backend_id(backend_id_2, arg_10_1) then
				if power_level == power_level_2 then
					local rarity = self.rarity

					rarity = rarity or data.rarity

					local rarity_2 = arg_10_1.rarity

					rarity_2 = rarity_2 or data_2.rarity

					local item_rarity_order = UISettings.item_rarity_order
					local var_10_10 = item_rarity_order[rarity]
					local var_10_11 = item_rarity_order[rarity_2]

					if var_10_10 == var_10_11 then
						local var_10_12 = Localize(data.item_type)
						local var_10_13 = Localize(data_2.item_type)

						if var_10_12 == var_10_13 then
							local get_ui_information_from_item, var_10_15 = UIUtils.get_ui_information_from_item(self)
							local get_ui_information_from_item_2, var_10_17 = UIUtils.get_ui_information_from_item(arg_10_1)

							return Localize(var_10_15) < Localize(var_10_17)
						else
							return var_10_12 < var_10_13
						end
					else
						return var_10_10 < var_10_11
					end
				else
					return power_level_2 < power_level
				end
			elseif not is_favorite_backend_id then
				return true
			else
				return false
			end
		end
	},
	{
		result_function = "upgrade_item_rarity_result_func",
		name = "upgrade_item_rarity_common",
		display_name = "crafting_recipe_upgrade_item_rarity_common",
		lore_text = "crafting_recipe_upgrade_item_rarity_common_lore_text",
		validation_function = "craft_validation_func",
		result_function_playfab = "craftingUpgradeRarity",
		hero_specific_filter = true,
		item_filter = "can_upgrade",
		description_text = "description_crafting_upgrade_item_rarity_common",
		display_icon_console = "console_crafting_recipe_icon_upgrade",
		ingredients = {
			{
				amount = 10,
				name = "crafting_material_scrap"
			},
			{
				amount = 2,
				name = "crafting_material_dust_1"
			},
			{
				catergory = {
					item_value = "slot_type",
					category_table = "equipment_slot_types"
				}
			}
		},
		item_sort_func = function (self, arg_11_1)
			-- function 11
			local data = self.data
			local data_2 = arg_11_1.data
			local power_level = self.power_level

			power_level = power_level or 0

			local power_level_2 = arg_11_1.power_level

			power_level_2 = power_level_2 or 0

			local backend_id = self.backend_id
			local backend_id_2 = arg_11_1.backend_id
			local is_favorite_backend_id = ItemHelper.is_favorite_backend_id(backend_id, self)

			if is_favorite_backend_id == ItemHelper.is_favorite_backend_id(backend_id_2, arg_11_1) then
				if power_level == power_level_2 then
					local rarity = self.rarity

					rarity = rarity or data.rarity

					local rarity_2 = arg_11_1.rarity

					rarity_2 = rarity_2 or data_2.rarity

					local item_rarity_order = UISettings.item_rarity_order
					local var_11_10 = item_rarity_order[rarity]
					local var_11_11 = item_rarity_order[rarity_2]

					if var_11_10 == var_11_11 then
						local var_11_12 = Localize(data.item_type)
						local var_11_13 = Localize(data_2.item_type)

						if var_11_12 == var_11_13 then
							local get_ui_information_from_item, var_11_15 = UIUtils.get_ui_information_from_item(self)
							local get_ui_information_from_item_2, var_11_17 = UIUtils.get_ui_information_from_item(arg_11_1)

							return Localize(var_11_15) < Localize(var_11_17)
						else
							return var_11_12 < var_11_13
						end
					else
						return var_11_10 < var_11_11
					end
				else
					return power_level_2 < power_level
				end
			elseif not is_favorite_backend_id then
				return true
			else
				return false
			end
		end
	},
	{
		result_function = "upgrade_item_rarity_result_func",
		name = "upgrade_item_rarity_rare",
		display_name = "crafting_recipe_upgrade_item_rarity_common",
		lore_text = "crafting_recipe_upgrade_item_rarity_rare_lore_text",
		validation_function = "craft_validation_func",
		result_function_playfab = "craftingUpgradeRarity",
		hero_specific_filter = true,
		item_filter = "can_upgrade",
		description_text = "description_crafting_upgrade_item_rarity_common",
		display_icon_console = "console_crafting_recipe_icon_upgrade",
		ingredients = {
			{
				amount = 15,
				name = "crafting_material_scrap"
			},
			{
				amount = 2,
				name = "crafting_material_dust_2"
			},
			{
				catergory = {
					item_value = "slot_type",
					category_table = "equipment_slot_types"
				}
			}
		},
		item_sort_func = function (self, arg_12_1)
			-- function 12
			local data = self.data
			local data_2 = arg_12_1.data
			local power_level = self.power_level

			power_level = power_level or 0

			local power_level_2 = arg_12_1.power_level

			power_level_2 = power_level_2 or 0

			local backend_id = self.backend_id
			local backend_id_2 = arg_12_1.backend_id
			local is_favorite_backend_id = ItemHelper.is_favorite_backend_id(backend_id, self)

			if is_favorite_backend_id == ItemHelper.is_favorite_backend_id(backend_id_2, arg_12_1) then
				if power_level == power_level_2 then
					local rarity = self.rarity

					rarity = rarity or data.rarity

					local rarity_2 = arg_12_1.rarity

					rarity_2 = rarity_2 or data_2.rarity

					local item_rarity_order = UISettings.item_rarity_order
					local var_12_10 = item_rarity_order[rarity]
					local var_12_11 = item_rarity_order[rarity_2]

					if var_12_10 == var_12_11 then
						local var_12_12 = Localize(data.item_type)
						local var_12_13 = Localize(data_2.item_type)

						if var_12_12 == var_12_13 then
							local get_ui_information_from_item, var_12_15 = UIUtils.get_ui_information_from_item(self)
							local get_ui_information_from_item_2, var_12_17 = UIUtils.get_ui_information_from_item(arg_12_1)

							return Localize(var_12_15) < Localize(var_12_17)
						else
							return var_12_12 < var_12_13
						end
					else
						return var_12_10 < var_12_11
					end
				else
					return power_level_2 < power_level
				end
			elseif not is_favorite_backend_id then
				return true
			else
				return false
			end
		end
	},
	{
		result_function = "upgrade_item_rarity_result_func",
		name = "upgrade_item_rarity_exotic",
		display_name = "crafting_recipe_upgrade_item_rarity_common",
		lore_text = "crafting_recipe_upgrade_item_rarity_exotic_lore_text",
		validation_function = "craft_validation_func",
		result_function_playfab = "craftingUpgradeRarity",
		hero_specific_filter = true,
		item_filter = "can_upgrade",
		description_text = "description_crafting_upgrade_item_rarity_common",
		display_icon_console = "console_crafting_recipe_icon_upgrade",
		ingredients = {
			{
				amount = 20,
				name = "crafting_material_scrap"
			},
			{
				amount = 2,
				name = "crafting_material_dust_3"
			},
			{
				catergory = {
					item_value = "slot_type",
					category_table = "equipment_slot_types"
				}
			}
		},
		item_sort_func = function (self, arg_13_1)
			-- function 13
			local data = self.data
			local data_2 = arg_13_1.data
			local power_level = self.power_level

			power_level = power_level or 0

			local power_level_2 = arg_13_1.power_level

			power_level_2 = power_level_2 or 0

			local backend_id = self.backend_id
			local backend_id_2 = arg_13_1.backend_id
			local is_favorite_backend_id = ItemHelper.is_favorite_backend_id(backend_id, self)

			if is_favorite_backend_id == ItemHelper.is_favorite_backend_id(backend_id_2, arg_13_1) then
				if power_level == power_level_2 then
					local rarity = self.rarity

					rarity = rarity or data.rarity

					local rarity_2 = arg_13_1.rarity

					rarity_2 = rarity_2 or data_2.rarity

					local item_rarity_order = UISettings.item_rarity_order
					local var_13_10 = item_rarity_order[rarity]
					local var_13_11 = item_rarity_order[rarity_2]

					if var_13_10 == var_13_11 then
						local var_13_12 = Localize(data.item_type)
						local var_13_13 = Localize(data_2.item_type)

						if var_13_12 == var_13_13 then
							local get_ui_information_from_item, var_13_15 = UIUtils.get_ui_information_from_item(self)
							local get_ui_information_from_item_2, var_13_17 = UIUtils.get_ui_information_from_item(arg_13_1)

							return Localize(var_13_15) < Localize(var_13_17)
						else
							return var_13_12 < var_13_13
						end
					else
						return var_13_10 < var_13_11
					end
				else
					return power_level_2 < power_level
				end
			elseif not is_favorite_backend_id then
				return true
			else
				return false
			end
		end
	},
	{
		result_function = "upgrade_item_rarity_result_func",
		name = "upgrade_item_rarity_unique",
		display_name = "crafting_recipe_upgrade_item_rarity_common",
		lore_text = "crafting_recipe_upgrade_item_rarity_unique_lore_text",
		validation_function = "craft_validation_func",
		result_function_playfab = "craftingUpgradeRarity",
		hero_specific_filter = true,
		item_filter = "can_upgrade",
		description_text = "description_crafting_upgrade_item_rarity_common",
		display_icon_console = "console_crafting_recipe_icon_upgrade",
		ingredients = {
			{
				amount = 5,
				name = "crafting_material_dust_4"
			},
			{
				catergory = {
					item_value = "slot_type",
					category_table = "equipment_slot_types"
				}
			}
		},
		item_sort_func = function (self, arg_14_1)
			-- function 14
			local data = self.data
			local data_2 = arg_14_1.data
			local power_level = self.power_level

			power_level = power_level or 0

			local power_level_2 = arg_14_1.power_level

			power_level_2 = power_level_2 or 0

			local backend_id = self.backend_id
			local backend_id_2 = arg_14_1.backend_id
			local is_favorite_backend_id = ItemHelper.is_favorite_backend_id(backend_id, self)

			if is_favorite_backend_id == ItemHelper.is_favorite_backend_id(backend_id_2, arg_14_1) then
				if power_level == power_level_2 then
					local rarity = self.rarity

					rarity = rarity or data.rarity

					local rarity_2 = arg_14_1.rarity

					rarity_2 = rarity_2 or data_2.rarity

					local item_rarity_order = UISettings.item_rarity_order
					local var_14_10 = item_rarity_order[rarity]
					local var_14_11 = item_rarity_order[rarity_2]

					if var_14_10 == var_14_11 then
						local var_14_12 = Localize(data.item_type)
						local var_14_13 = Localize(data_2.item_type)

						if var_14_12 == var_14_13 then
							local get_ui_information_from_item, var_14_15 = UIUtils.get_ui_information_from_item(self)
							local get_ui_information_from_item_2, var_14_17 = UIUtils.get_ui_information_from_item(arg_14_1)

							return Localize(var_14_15) < Localize(var_14_17)
						else
							return var_14_12 < var_14_13
						end
					else
						return var_14_10 < var_14_11
					end
				else
					return power_level_2 < power_level
				end
			elseif not is_favorite_backend_id then
				return true
			else
				return false
			end
		end
	},
	{
		validation_function = "craft_validation_func",
		name = "convert_blue_dust",
		display_name = "crafting_recipe_convert_dust",
		lore_text = "",
		result_function_playfab = "craftingDowngradeDust",
		hero_specific_filter = false,
		result_function = "upgrade_item_rarity_result_func",
		item_filter = "item_key == crafting_material_dust_2 or item_key == crafting_material_dust_3",
		description_text = "description_crafting_recipe_convert_dust",
		display_icon_console = "console_crafting_recipe_icon_dust",
		ingredients = {
			{
				amount = 10,
				name = "crafting_material_dust_2"
			}
		},
		presentation_ingredients = {
			{
				amount = 10,
				name = "crafting_material_dust_2"
			},
			{
				amount = 20,
				name = "crafting_material_dust_1"
			}
		},
		item_sort_func = function (arg_15_0, arg_15_1)
			-- function 15
			local get_ui_information_from_item, var_15_1 = UIUtils.get_ui_information_from_item(arg_15_0)
			local get_ui_information_from_item_2, var_15_3 = UIUtils.get_ui_information_from_item(arg_15_1)

			return var_15_1 < var_15_3
		end
	},
	{
		validation_function = "craft_validation_func",
		name = "convert_orange_dust",
		display_name = "crafting_recipe_convert_dust",
		lore_text = "",
		result_function_playfab = "craftingDowngradeDust",
		hero_specific_filter = false,
		result_function = "upgrade_item_rarity_result_func",
		item_filter = "item_key == crafting_material_dust_2 or item_key == crafting_material_dust_3",
		description_text = "description_crafting_recipe_convert_dust",
		display_icon_console = "console_crafting_recipe_icon_dust",
		ingredients = {
			{
				amount = 10,
				name = "crafting_material_dust_3"
			}
		},
		presentation_ingredients = {
			{
				amount = 10,
				name = "crafting_material_dust_3"
			},
			{
				amount = 20,
				name = "crafting_material_dust_2"
			}
		},
		item_sort_func = function (arg_16_0, arg_16_1)
			-- function 16
			local get_ui_information_from_item, var_16_1 = UIUtils.get_ui_information_from_item(arg_16_0)
			local get_ui_information_from_item_2, var_16_3 = UIUtils.get_ui_information_from_item(arg_16_1)

			return var_16_1 < var_16_3
		end
	}
}
local tbl_2 = {}
local tbl_3 = {}

for i, v in ipairs(tbl) do
	local name = v.name

	tbl_2[i] = name
	tbl_3[name] = v
end

return tbl, tbl_3, tbl_2
