-- chunkname: @scripts/settings/crafting/crafting_recipes.lua

CraftingSettings = {
	NUM_SALVAGE_SLOTS = 9
}

local crafting_recipes = {
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
		item_sort_func = function (item_1, item_2)
			-- function 1
			local item_data_1 = item_1.data
			local item_data_2 = item_2.data
			local power_level = item_1.power_level

			if not power_level then
				-- Nothing
			end

			power_level = math.huge

			local item_1_power_level = power_level

			::label_1_0::

			local power_level_2 = item_2.power_level

			if not power_level_2 then
				-- Nothing
			end

			power_level_2 = math.huge

			local item_2_power_level = power_level_2

			::label_1_1::

			local item_1_item_type = item_data_1.item_type
			local item_2_item_type = item_data_2.item_type
			local item_1_backend_id = item_1.backend_id
			local item_2_backend_id = item_2.backend_id
			local item_1_favorited = ItemHelper.is_favorite_backend_id(item_1_backend_id, item_1)
			local item_2_favorited = ItemHelper.is_favorite_backend_id(item_2_backend_id, item_2)

			if item_1_favorited == item_2_favorited then
				if item_1_power_level == item_2_power_level then
					local rarity = item_1.rarity

					if not rarity then
						-- Nothing
					end

					rarity = item_data_1.rarity

					local item_1_rarity = rarity

					::label_1_2::

					local rarity_2 = item_2.rarity

					if not rarity_2 then
						-- Nothing
					end

					rarity_2 = item_data_2.rarity

					local item_2_rarity = rarity_2

					::label_1_3::

					local item_rarity_order = UISettings.item_rarity_order
					local item_1_rarity_order = item_rarity_order[item_1_rarity]
					local item_2_rarity_order = item_rarity_order[item_2_rarity]
					local cosmetics_sorting_order = UISettings.cosmetics_sorting_order
					local var_1_4 = cosmetics_sorting_order[item_1_item_type]

					if not var_1_4 then
						-- Nothing
					end

					var_1_4 = 0

					local item_1_cosmetic_order = var_1_4

					::label_1_4::

					local var_1_5 = cosmetics_sorting_order[item_2_item_type]

					if not var_1_5 then
						-- Nothing
					end

					var_1_5 = 0

					local item_2_cosmetic_order = var_1_5

					::label_1_5::

					local item_1_is_cosmetic = item_1_item_type == "skin" or item_1_item_type == "hat"
					local item_2_is_cosmetic = item_2_item_type == "skin" or item_2_item_type == "hat"

					if item_1_cosmetic_order == item_2_cosmetic_order then
						if item_1_rarity_order == item_2_rarity_order then
							local item_type_1 = Localize(item_1_item_type)
							local item_type_2 = Localize(item_1_item_type)

							if item_type_1 == item_type_2 then
								local _, item_name_1 = UIUtils.get_ui_information_from_item(item_1)
								local _, item_name_2 = UIUtils.get_ui_information_from_item(item_2)

								if item_name_1 == item_name_2 then
									return item_1_backend_id < item_2_backend_id
								else
									return Localize(item_name_1) < Localize(item_name_2)
								end
							else
								return item_type_1 < item_type_2
							end
						else
							return item_2_rarity_order < item_1_rarity_order
						end
					else
						return item_1_cosmetic_order < item_2_cosmetic_order
					end
				else
					return item_1_power_level < item_2_power_level
				end
			elseif item_1_favorited then
				return false
			else
				return true
			end
		end,
		input_func = function (self, input_service)
			-- function 2
			local backend_ids
			local gamepad_active = Managers.input:is_device_active("gamepad")

			if gamepad_active then
				if input_service:get("right_stick_press") then
					local item_grid = self._item_grid
					local item, is_equipped = item_grid:get_item_hovered()

					if not item then
						item, is_equipped = item_grid:selected_item()
					end

					backend_ids = {}

					if item and not is_equipped then
						local rarity = item.rarity

						backend_ids[#backend_ids + 1] = item.backend_id

						local items = item_grid:items()

						for idx, item in ipairs(items) do
							local backend_id = item.backend_id
							local item_rarity = item.rarity

							if item_rarity == rarity and not table.find(backend_ids, backend_id) then
								backend_ids[#backend_ids + 1] = backend_id

								if table.size(backend_ids) == CraftingSettings.NUM_SALVAGE_SLOTS then
									break
								end
							end
						end
					end
				end
			else
				backend_ids = {}

				local rarity = self.parent:get_auto_fill_rarity()

				if rarity then
					local item_grid = self._item_grid
					local items = item_grid:items()

					for idx, item in ipairs(items) do
						local backend_id = item.backend_id
						local item_rarity = item.rarity

						if item_rarity == rarity and not table.find(backend_ids, backend_id) then
							backend_ids[#backend_ids + 1] = backend_id

							if table.size(backend_ids) == CraftingSettings.NUM_SALVAGE_SLOTS then
								break
							end
						end
					end
				end
			end

			self.parent:set_selected_items_backend_ids(backend_ids)
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
		item_sort_func = function (item_1, item_2)
			-- function 3
			local item_data_1 = item_1.data
			local item_data_2 = item_2.data
			local item_type_1 = Localize(item_data_1.item_type)
			local item_type_2 = Localize(item_data_2.item_type)
			local item_1_backend_id = item_1.backend_id
			local item_2_backend_id = item_2.backend_id
			local item_1_favorited = ItemHelper.is_favorite_backend_id(item_1_backend_id, item_1)
			local item_2_favorited = ItemHelper.is_favorite_backend_id(item_2_backend_id, item_2)

			if item_1_favorited == item_2_favorited then
				if item_type_1 == item_type_2 then
					local _, item_name_1 = UIUtils.get_ui_information_from_item(item_1)
					local _, item_name_2 = UIUtils.get_ui_information_from_item(item_2)

					return Localize(item_name_1) < Localize(item_name_2)
				else
					return item_type_1 < item_type_2
				end
			elseif item_1_favorited then
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
		item_sort_func = function (item_1, item_2)
			-- function 4
			local item_data_1 = item_1.data
			local item_data_2 = item_2.data
			local item_type_1 = Localize(item_data_1.item_type)
			local item_type_2 = Localize(item_data_2.item_type)
			local item_1_backend_id = item_1.backend_id
			local item_2_backend_id = item_2.backend_id
			local item_1_favorited = ItemHelper.is_favorite_backend_id(item_1_backend_id, item_1)
			local item_2_favorited = ItemHelper.is_favorite_backend_id(item_2_backend_id, item_2)

			if item_1_favorited == item_2_favorited then
				if item_type_1 == item_type_2 then
					local _, item_name_1 = UIUtils.get_ui_information_from_item(item_1)
					local _, item_name_2 = UIUtils.get_ui_information_from_item(item_2)

					return Localize(item_name_1) < Localize(item_name_2)
				else
					return item_type_1 < item_type_2
				end
			elseif item_1_favorited then
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
		item_sort_func = function (item_1, item_2)
			-- function 5
			local item_data_1 = item_1.data
			local item_data_2 = item_2.data
			local item_type_1 = Localize(item_data_1.item_type)
			local item_type_2 = Localize(item_data_2.item_type)
			local item_1_backend_id = item_1.backend_id
			local item_2_backend_id = item_2.backend_id
			local item_1_favorited = ItemHelper.is_favorite_backend_id(item_1_backend_id, item_1)
			local item_2_favorited = ItemHelper.is_favorite_backend_id(item_2_backend_id, item_2)

			if item_1_favorited == item_2_favorited then
				if item_type_1 == item_type_2 then
					local _, item_name_1 = UIUtils.get_ui_information_from_item(item_1)
					local _, item_name_2 = UIUtils.get_ui_information_from_item(item_2)

					return Localize(item_name_1) < Localize(item_name_2)
				else
					return item_type_1 < item_type_2
				end
			elseif item_1_favorited then
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
		item_sort_func = function (item_1, item_2)
			-- function 6
			local item_data_1 = item_1.data
			local item_data_2 = item_2.data
			local power_level = item_1.power_level

			if not power_level then
				-- Nothing
			end

			power_level = 0

			local item_1_power_level = power_level

			::label_6_0::

			local power_level_2 = item_2.power_level

			if not power_level_2 then
				-- Nothing
			end

			power_level_2 = 0

			local item_2_power_level = power_level_2

			::label_6_1::

			local item_1_backend_id = item_1.backend_id
			local item_2_backend_id = item_2.backend_id
			local item_1_favorited = ItemHelper.is_favorite_backend_id(item_1_backend_id, item_1)
			local item_2_favorited = ItemHelper.is_favorite_backend_id(item_2_backend_id, item_2)

			if item_1_favorited == item_2_favorited then
				if item_1_power_level == item_2_power_level then
					local rarity = item_1.rarity

					if not rarity then
						-- Nothing
					end

					rarity = item_data_1.rarity

					local item_1_rarity = rarity

					::label_6_2::

					local rarity_2 = item_2.rarity

					if not rarity_2 then
						-- Nothing
					end

					rarity_2 = item_data_2.rarity

					local item_2_rarity = rarity_2

					::label_6_3::

					local item_rarity_order = UISettings.item_rarity_order
					local item_1_rarity_order = item_rarity_order[item_1_rarity]
					local item_2_rarity_order = item_rarity_order[item_2_rarity]

					if item_1_rarity_order == item_2_rarity_order then
						local item_type_1 = Localize(item_data_1.item_type)
						local item_type_2 = Localize(item_data_2.item_type)

						if item_type_1 == item_type_2 then
							local _, item_name_1 = UIUtils.get_ui_information_from_item(item_1)
							local _, item_name_2 = UIUtils.get_ui_information_from_item(item_2)

							return Localize(item_name_1) < Localize(item_name_2)
						else
							return item_type_1 < item_type_2
						end
					else
						return item_1_rarity_order < item_2_rarity_order
					end
				else
					return item_2_power_level < item_1_power_level
				end
			elseif item_1_favorited then
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
		item_sort_func = function (item_1, item_2)
			-- function 7
			local item_data_1 = item_1.data
			local item_data_2 = item_2.data
			local power_level = item_1.power_level

			if not power_level then
				-- Nothing
			end

			power_level = 0

			local item_1_power_level = power_level

			::label_7_0::

			local power_level_2 = item_2.power_level

			if not power_level_2 then
				-- Nothing
			end

			power_level_2 = 0

			local item_2_power_level = power_level_2

			::label_7_1::

			local item_1_backend_id = item_1.backend_id
			local item_2_backend_id = item_2.backend_id
			local item_1_favorited = ItemHelper.is_favorite_backend_id(item_1_backend_id, item_1)
			local item_2_favorited = ItemHelper.is_favorite_backend_id(item_2_backend_id, item_2)

			if item_1_favorited == item_2_favorited then
				if item_1_power_level == item_2_power_level then
					local rarity = item_1.rarity

					if not rarity then
						-- Nothing
					end

					rarity = item_data_1.rarity

					local item_1_rarity = rarity

					::label_7_2::

					local rarity_2 = item_2.rarity

					if not rarity_2 then
						-- Nothing
					end

					rarity_2 = item_data_2.rarity

					local item_2_rarity = rarity_2

					::label_7_3::

					local item_rarity_order = UISettings.item_rarity_order
					local item_1_rarity_order = item_rarity_order[item_1_rarity]
					local item_2_rarity_order = item_rarity_order[item_2_rarity]

					if item_1_rarity_order == item_2_rarity_order then
						local item_type_1 = Localize(item_data_1.item_type)
						local item_type_2 = Localize(item_data_2.item_type)

						if item_type_1 == item_type_2 then
							local _, item_name_1 = UIUtils.get_ui_information_from_item(item_1)
							local _, item_name_2 = UIUtils.get_ui_information_from_item(item_2)

							return Localize(item_name_1) < Localize(item_name_2)
						else
							return item_type_1 < item_type_2
						end
					else
						return item_1_rarity_order < item_2_rarity_order
					end
				else
					return item_2_power_level < item_1_power_level
				end
			elseif item_1_favorited then
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
		item_sort_func = function (item_1, item_2)
			-- function 8
			local item_data_1 = item_1.data
			local item_data_2 = item_2.data
			local power_level = item_1.power_level

			if not power_level then
				-- Nothing
			end

			power_level = 0

			local item_1_power_level = power_level

			::label_8_0::

			local power_level_2 = item_2.power_level

			if not power_level_2 then
				-- Nothing
			end

			power_level_2 = 0

			local item_2_power_level = power_level_2

			::label_8_1::

			local item_1_backend_id = item_1.backend_id
			local item_2_backend_id = item_2.backend_id
			local item_1_favorited = ItemHelper.is_favorite_backend_id(item_1_backend_id, item_1)
			local item_2_favorited = ItemHelper.is_favorite_backend_id(item_2_backend_id, item_2)

			if item_1_favorited == item_2_favorited then
				if item_1_power_level == item_2_power_level then
					local rarity = item_1.rarity

					if not rarity then
						-- Nothing
					end

					rarity = item_data_1.rarity

					local item_1_rarity = rarity

					::label_8_2::

					local rarity_2 = item_2.rarity

					if not rarity_2 then
						-- Nothing
					end

					rarity_2 = item_data_2.rarity

					local item_2_rarity = rarity_2

					::label_8_3::

					local item_rarity_order = UISettings.item_rarity_order
					local item_1_rarity_order = item_rarity_order[item_1_rarity]
					local item_2_rarity_order = item_rarity_order[item_2_rarity]

					if item_1_rarity_order == item_2_rarity_order then
						local item_type_1 = Localize(item_data_1.item_type)
						local item_type_2 = Localize(item_data_2.item_type)

						if item_type_1 == item_type_2 then
							local _, item_name_1 = UIUtils.get_ui_information_from_item(item_1)
							local _, item_name_2 = UIUtils.get_ui_information_from_item(item_2)

							return Localize(item_name_1) < Localize(item_name_2)
						else
							return item_type_1 < item_type_2
						end
					else
						return item_1_rarity_order < item_2_rarity_order
					end
				else
					return item_2_power_level < item_1_power_level
				end
			elseif item_1_favorited then
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
		item_sort_func = function (item_1, item_2)
			-- function 9
			local item_data_1 = item_1.data
			local item_data_2 = item_2.data
			local power_level = item_1.power_level

			if not power_level then
				-- Nothing
			end

			power_level = 0

			local item_1_power_level = power_level

			::label_9_0::

			local power_level_2 = item_2.power_level

			if not power_level_2 then
				-- Nothing
			end

			power_level_2 = 0

			local item_2_power_level = power_level_2

			::label_9_1::

			local item_1_backend_id = item_1.backend_id
			local item_2_backend_id = item_2.backend_id
			local item_1_favorited = ItemHelper.is_favorite_backend_id(item_1_backend_id, item_1)
			local item_2_favorited = ItemHelper.is_favorite_backend_id(item_2_backend_id, item_2)

			if item_1_favorited == item_2_favorited then
				if item_1_power_level == item_2_power_level then
					local rarity = item_1.rarity

					if not rarity then
						-- Nothing
					end

					rarity = item_data_1.rarity

					local item_1_rarity = rarity

					::label_9_2::

					local rarity_2 = item_2.rarity

					if not rarity_2 then
						-- Nothing
					end

					rarity_2 = item_data_2.rarity

					local item_2_rarity = rarity_2

					::label_9_3::

					local item_rarity_order = UISettings.item_rarity_order
					local item_1_rarity_order = item_rarity_order[item_1_rarity]
					local item_2_rarity_order = item_rarity_order[item_2_rarity]

					if item_1_rarity_order == item_2_rarity_order then
						local item_type_1 = Localize(item_data_1.item_type)
						local item_type_2 = Localize(item_data_2.item_type)

						if item_type_1 == item_type_2 then
							local _, item_name_1 = UIUtils.get_ui_information_from_item(item_1)
							local _, item_name_2 = UIUtils.get_ui_information_from_item(item_2)

							return Localize(item_name_1) < Localize(item_name_2)
						else
							return item_type_1 < item_type_2
						end
					else
						return item_1_rarity_order < item_2_rarity_order
					end
				else
					return item_2_power_level < item_1_power_level
				end
			elseif item_1_favorited then
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
		item_sort_func = function (item_1, item_2)
			-- function 10
			local item_data_1 = item_1.data
			local item_data_2 = item_2.data
			local power_level = item_1.power_level

			if not power_level then
				-- Nothing
			end

			power_level = 0

			local item_1_power_level = power_level

			::label_10_0::

			local power_level_2 = item_2.power_level

			if not power_level_2 then
				-- Nothing
			end

			power_level_2 = 0

			local item_2_power_level = power_level_2

			::label_10_1::

			local item_1_backend_id = item_1.backend_id
			local item_2_backend_id = item_2.backend_id
			local item_1_favorited = ItemHelper.is_favorite_backend_id(item_1_backend_id, item_1)
			local item_2_favorited = ItemHelper.is_favorite_backend_id(item_2_backend_id, item_2)

			if item_1_favorited == item_2_favorited then
				if item_1_power_level == item_2_power_level then
					local rarity = item_1.rarity

					if not rarity then
						-- Nothing
					end

					rarity = item_data_1.rarity

					local item_1_rarity = rarity

					::label_10_2::

					local rarity_2 = item_2.rarity

					if not rarity_2 then
						-- Nothing
					end

					rarity_2 = item_data_2.rarity

					local item_2_rarity = rarity_2

					::label_10_3::

					local item_rarity_order = UISettings.item_rarity_order
					local item_1_rarity_order = item_rarity_order[item_1_rarity]
					local item_2_rarity_order = item_rarity_order[item_2_rarity]

					if item_1_rarity_order == item_2_rarity_order then
						local item_type_1 = Localize(item_data_1.item_type)
						local item_type_2 = Localize(item_data_2.item_type)

						if item_type_1 == item_type_2 then
							local _, item_name_1 = UIUtils.get_ui_information_from_item(item_1)
							local _, item_name_2 = UIUtils.get_ui_information_from_item(item_2)

							return Localize(item_name_1) < Localize(item_name_2)
						else
							return item_type_1 < item_type_2
						end
					else
						return item_1_rarity_order < item_2_rarity_order
					end
				else
					return item_2_power_level < item_1_power_level
				end
			elseif item_1_favorited then
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
		item_sort_func = function (item_1, item_2)
			-- function 11
			local item_data_1 = item_1.data
			local item_data_2 = item_2.data
			local power_level = item_1.power_level

			if not power_level then
				-- Nothing
			end

			power_level = 0

			local item_1_power_level = power_level

			::label_11_0::

			local power_level_2 = item_2.power_level

			if not power_level_2 then
				-- Nothing
			end

			power_level_2 = 0

			local item_2_power_level = power_level_2

			::label_11_1::

			local item_1_backend_id = item_1.backend_id
			local item_2_backend_id = item_2.backend_id
			local item_1_favorited = ItemHelper.is_favorite_backend_id(item_1_backend_id, item_1)
			local item_2_favorited = ItemHelper.is_favorite_backend_id(item_2_backend_id, item_2)

			if item_1_favorited == item_2_favorited then
				if item_1_power_level == item_2_power_level then
					local rarity = item_1.rarity

					if not rarity then
						-- Nothing
					end

					rarity = item_data_1.rarity

					local item_1_rarity = rarity

					::label_11_2::

					local rarity_2 = item_2.rarity

					if not rarity_2 then
						-- Nothing
					end

					rarity_2 = item_data_2.rarity

					local item_2_rarity = rarity_2

					::label_11_3::

					local item_rarity_order = UISettings.item_rarity_order
					local item_1_rarity_order = item_rarity_order[item_1_rarity]
					local item_2_rarity_order = item_rarity_order[item_2_rarity]

					if item_1_rarity_order == item_2_rarity_order then
						local item_type_1 = Localize(item_data_1.item_type)
						local item_type_2 = Localize(item_data_2.item_type)

						if item_type_1 == item_type_2 then
							local _, item_name_1 = UIUtils.get_ui_information_from_item(item_1)
							local _, item_name_2 = UIUtils.get_ui_information_from_item(item_2)

							return Localize(item_name_1) < Localize(item_name_2)
						else
							return item_type_1 < item_type_2
						end
					else
						return item_1_rarity_order < item_2_rarity_order
					end
				else
					return item_2_power_level < item_1_power_level
				end
			elseif item_1_favorited then
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
		item_sort_func = function (item_1, item_2)
			-- function 12
			local item_data_1 = item_1.data
			local item_data_2 = item_2.data
			local power_level = item_1.power_level

			if not power_level then
				-- Nothing
			end

			power_level = 0

			local item_1_power_level = power_level

			::label_12_0::

			local power_level_2 = item_2.power_level

			if not power_level_2 then
				-- Nothing
			end

			power_level_2 = 0

			local item_2_power_level = power_level_2

			::label_12_1::

			local item_1_backend_id = item_1.backend_id
			local item_2_backend_id = item_2.backend_id
			local item_1_favorited = ItemHelper.is_favorite_backend_id(item_1_backend_id, item_1)
			local item_2_favorited = ItemHelper.is_favorite_backend_id(item_2_backend_id, item_2)

			if item_1_favorited == item_2_favorited then
				if item_1_power_level == item_2_power_level then
					local rarity = item_1.rarity

					if not rarity then
						-- Nothing
					end

					rarity = item_data_1.rarity

					local item_1_rarity = rarity

					::label_12_2::

					local rarity_2 = item_2.rarity

					if not rarity_2 then
						-- Nothing
					end

					rarity_2 = item_data_2.rarity

					local item_2_rarity = rarity_2

					::label_12_3::

					local item_rarity_order = UISettings.item_rarity_order
					local item_1_rarity_order = item_rarity_order[item_1_rarity]
					local item_2_rarity_order = item_rarity_order[item_2_rarity]

					if item_1_rarity_order == item_2_rarity_order then
						local item_type_1 = Localize(item_data_1.item_type)
						local item_type_2 = Localize(item_data_2.item_type)

						if item_type_1 == item_type_2 then
							local _, item_name_1 = UIUtils.get_ui_information_from_item(item_1)
							local _, item_name_2 = UIUtils.get_ui_information_from_item(item_2)

							return Localize(item_name_1) < Localize(item_name_2)
						else
							return item_type_1 < item_type_2
						end
					else
						return item_1_rarity_order < item_2_rarity_order
					end
				else
					return item_2_power_level < item_1_power_level
				end
			elseif item_1_favorited then
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
		item_sort_func = function (item_1, item_2)
			-- function 13
			local item_data_1 = item_1.data
			local item_data_2 = item_2.data
			local power_level = item_1.power_level

			if not power_level then
				-- Nothing
			end

			power_level = 0

			local item_1_power_level = power_level

			::label_13_0::

			local power_level_2 = item_2.power_level

			if not power_level_2 then
				-- Nothing
			end

			power_level_2 = 0

			local item_2_power_level = power_level_2

			::label_13_1::

			local item_1_backend_id = item_1.backend_id
			local item_2_backend_id = item_2.backend_id
			local item_1_favorited = ItemHelper.is_favorite_backend_id(item_1_backend_id, item_1)
			local item_2_favorited = ItemHelper.is_favorite_backend_id(item_2_backend_id, item_2)

			if item_1_favorited == item_2_favorited then
				if item_1_power_level == item_2_power_level then
					local rarity = item_1.rarity

					if not rarity then
						-- Nothing
					end

					rarity = item_data_1.rarity

					local item_1_rarity = rarity

					::label_13_2::

					local rarity_2 = item_2.rarity

					if not rarity_2 then
						-- Nothing
					end

					rarity_2 = item_data_2.rarity

					local item_2_rarity = rarity_2

					::label_13_3::

					local item_rarity_order = UISettings.item_rarity_order
					local item_1_rarity_order = item_rarity_order[item_1_rarity]
					local item_2_rarity_order = item_rarity_order[item_2_rarity]

					if item_1_rarity_order == item_2_rarity_order then
						local item_type_1 = Localize(item_data_1.item_type)
						local item_type_2 = Localize(item_data_2.item_type)

						if item_type_1 == item_type_2 then
							local _, item_name_1 = UIUtils.get_ui_information_from_item(item_1)
							local _, item_name_2 = UIUtils.get_ui_information_from_item(item_2)

							return Localize(item_name_1) < Localize(item_name_2)
						else
							return item_type_1 < item_type_2
						end
					else
						return item_1_rarity_order < item_2_rarity_order
					end
				else
					return item_2_power_level < item_1_power_level
				end
			elseif item_1_favorited then
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
		item_sort_func = function (item_1, item_2)
			-- function 14
			local item_data_1 = item_1.data
			local item_data_2 = item_2.data
			local power_level = item_1.power_level

			if not power_level then
				-- Nothing
			end

			power_level = 0

			local item_1_power_level = power_level

			::label_14_0::

			local power_level_2 = item_2.power_level

			if not power_level_2 then
				-- Nothing
			end

			power_level_2 = 0

			local item_2_power_level = power_level_2

			::label_14_1::

			local item_1_backend_id = item_1.backend_id
			local item_2_backend_id = item_2.backend_id
			local item_1_favorited = ItemHelper.is_favorite_backend_id(item_1_backend_id, item_1)
			local item_2_favorited = ItemHelper.is_favorite_backend_id(item_2_backend_id, item_2)

			if item_1_favorited == item_2_favorited then
				if item_1_power_level == item_2_power_level then
					local rarity = item_1.rarity

					if not rarity then
						-- Nothing
					end

					rarity = item_data_1.rarity

					local item_1_rarity = rarity

					::label_14_2::

					local rarity_2 = item_2.rarity

					if not rarity_2 then
						-- Nothing
					end

					rarity_2 = item_data_2.rarity

					local item_2_rarity = rarity_2

					::label_14_3::

					local item_rarity_order = UISettings.item_rarity_order
					local item_1_rarity_order = item_rarity_order[item_1_rarity]
					local item_2_rarity_order = item_rarity_order[item_2_rarity]

					if item_1_rarity_order == item_2_rarity_order then
						local item_type_1 = Localize(item_data_1.item_type)
						local item_type_2 = Localize(item_data_2.item_type)

						if item_type_1 == item_type_2 then
							local _, item_name_1 = UIUtils.get_ui_information_from_item(item_1)
							local _, item_name_2 = UIUtils.get_ui_information_from_item(item_2)

							return Localize(item_name_1) < Localize(item_name_2)
						else
							return item_type_1 < item_type_2
						end
					else
						return item_1_rarity_order < item_2_rarity_order
					end
				else
					return item_2_power_level < item_1_power_level
				end
			elseif item_1_favorited then
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
		item_sort_func = function (item_1, item_2)
			-- function 15
			local _, item_name_1 = UIUtils.get_ui_information_from_item(item_1)
			local _, item_name_2 = UIUtils.get_ui_information_from_item(item_2)

			return item_name_1 < item_name_2
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
		item_sort_func = function (item_1, item_2)
			-- function 16
			local _, item_name_1 = UIUtils.get_ui_information_from_item(item_1)
			local _, item_name_2 = UIUtils.get_ui_information_from_item(item_2)

			return item_name_1 < item_name_2
		end
	}
}
local crafting_recipes_lookup = {}
local crafting_recipes_by_name = {}

for i, recipe_data in ipairs(crafting_recipes) do
	local name = recipe_data.name

	crafting_recipes_lookup[i] = name
	crafting_recipes_by_name[name] = recipe_data
end

return crafting_recipes, crafting_recipes_by_name, crafting_recipes_lookup
