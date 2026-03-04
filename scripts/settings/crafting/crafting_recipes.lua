-- chunkname: @scripts/settings/crafting/crafting_recipes.lua

CraftingSettings = {
	NUM_SALVAGE_SLOTS = 9
}

local var_0_0 = {
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
		item_sort_func = function (arg_1_0, arg_1_1)
			local var_1_0 = arg_1_0.data
			local var_1_1 = arg_1_1.data
			local var_1_2 = arg_1_0.power_level or math.huge
			local var_1_3 = arg_1_1.power_level or math.huge
			local var_1_4 = var_1_0.item_type
			local var_1_5 = var_1_1.item_type
			local var_1_6 = arg_1_0.backend_id
			local var_1_7 = arg_1_1.backend_id
			local var_1_8 = ItemHelper.is_favorite_backend_id(var_1_6, arg_1_0)

			if var_1_8 == ItemHelper.is_favorite_backend_id(var_1_7, arg_1_1) then
				if var_1_2 == var_1_3 then
					local var_1_9 = arg_1_0.rarity or var_1_0.rarity
					local var_1_10 = arg_1_1.rarity or var_1_1.rarity
					local var_1_11 = UISettings.item_rarity_order
					local var_1_12 = var_1_11[var_1_9]
					local var_1_13 = var_1_11[var_1_10]
					local var_1_14 = UISettings.cosmetics_sorting_order
					local var_1_15 = var_1_14[var_1_4] or 0
					local var_1_16 = var_1_14[var_1_5] or 0
					local var_1_17

					var_1_17 = var_1_4 == "skin" or var_1_4 == "hat"

					local var_1_18

					var_1_18 = var_1_5 == "skin" or var_1_5 == "hat"

					if var_1_15 == var_1_16 then
						if var_1_12 == var_1_13 then
							local var_1_19 = Localize(var_1_4)
							local var_1_20 = Localize(var_1_4)

							if var_1_19 == var_1_20 then
								local var_1_21, var_1_22 = UIUtils.get_ui_information_from_item(arg_1_0)
								local var_1_23, var_1_24 = UIUtils.get_ui_information_from_item(arg_1_1)

								if var_1_22 == var_1_24 then
									return var_1_6 < var_1_7
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
					return var_1_2 < var_1_3
				end
			elseif var_1_8 then
				return false
			else
				return true
			end
		end,
		input_func = function (arg_2_0, arg_2_1)
			local var_2_0

			if Managers.input:is_device_active("gamepad") then
				if arg_2_1:get("right_stick_press") then
					local var_2_1 = arg_2_0._item_grid
					local var_2_2, var_2_3 = var_2_1:get_item_hovered()

					if not var_2_2 then
						var_2_2, var_2_3 = var_2_1:selected_item()
					end

					var_2_0 = {}

					if var_2_2 and not var_2_3 then
						local var_2_4 = var_2_2.rarity

						var_2_0[#var_2_0 + 1] = var_2_2.backend_id

						local var_2_5 = var_2_1:items()

						for iter_2_0, iter_2_1 in ipairs(var_2_5) do
							local var_2_6 = iter_2_1.backend_id

							if iter_2_1.rarity == var_2_4 and not table.find(var_2_0, var_2_6) then
								var_2_0[#var_2_0 + 1] = var_2_6

								if table.size(var_2_0) == CraftingSettings.NUM_SALVAGE_SLOTS then
									break
								end
							end
						end
					end
				end
			else
				var_2_0 = {}

				local var_2_7 = arg_2_0.parent:get_auto_fill_rarity()

				if var_2_7 then
					local var_2_8 = arg_2_0._item_grid:items()

					for iter_2_2, iter_2_3 in ipairs(var_2_8) do
						local var_2_9 = iter_2_3.backend_id

						if iter_2_3.rarity == var_2_7 and not table.find(var_2_0, var_2_9) then
							var_2_0[#var_2_0 + 1] = var_2_9

							if table.size(var_2_0) == CraftingSettings.NUM_SALVAGE_SLOTS then
								break
							end
						end
					end
				end
			end

			arg_2_0.parent:set_selected_items_backend_ids(var_2_0)
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
		item_sort_func = function (arg_3_0, arg_3_1)
			local var_3_0 = arg_3_0.data
			local var_3_1 = arg_3_1.data
			local var_3_2 = Localize(var_3_0.item_type)
			local var_3_3 = Localize(var_3_1.item_type)
			local var_3_4 = arg_3_0.backend_id
			local var_3_5 = arg_3_1.backend_id
			local var_3_6 = ItemHelper.is_favorite_backend_id(var_3_4, arg_3_0)

			if var_3_6 == ItemHelper.is_favorite_backend_id(var_3_5, arg_3_1) then
				if var_3_2 == var_3_3 then
					local var_3_7, var_3_8 = UIUtils.get_ui_information_from_item(arg_3_0)
					local var_3_9, var_3_10 = UIUtils.get_ui_information_from_item(arg_3_1)

					return Localize(var_3_8) < Localize(var_3_10)
				else
					return var_3_2 < var_3_3
				end
			elseif var_3_6 then
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
		item_sort_func = function (arg_4_0, arg_4_1)
			local var_4_0 = arg_4_0.data
			local var_4_1 = arg_4_1.data
			local var_4_2 = Localize(var_4_0.item_type)
			local var_4_3 = Localize(var_4_1.item_type)
			local var_4_4 = arg_4_0.backend_id
			local var_4_5 = arg_4_1.backend_id
			local var_4_6 = ItemHelper.is_favorite_backend_id(var_4_4, arg_4_0)

			if var_4_6 == ItemHelper.is_favorite_backend_id(var_4_5, arg_4_1) then
				if var_4_2 == var_4_3 then
					local var_4_7, var_4_8 = UIUtils.get_ui_information_from_item(arg_4_0)
					local var_4_9, var_4_10 = UIUtils.get_ui_information_from_item(arg_4_1)

					return Localize(var_4_8) < Localize(var_4_10)
				else
					return var_4_2 < var_4_3
				end
			elseif var_4_6 then
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
		item_sort_func = function (arg_5_0, arg_5_1)
			local var_5_0 = arg_5_0.data
			local var_5_1 = arg_5_1.data
			local var_5_2 = Localize(var_5_0.item_type)
			local var_5_3 = Localize(var_5_1.item_type)
			local var_5_4 = arg_5_0.backend_id
			local var_5_5 = arg_5_1.backend_id
			local var_5_6 = ItemHelper.is_favorite_backend_id(var_5_4, arg_5_0)

			if var_5_6 == ItemHelper.is_favorite_backend_id(var_5_5, arg_5_1) then
				if var_5_2 == var_5_3 then
					local var_5_7, var_5_8 = UIUtils.get_ui_information_from_item(arg_5_0)
					local var_5_9, var_5_10 = UIUtils.get_ui_information_from_item(arg_5_1)

					return Localize(var_5_8) < Localize(var_5_10)
				else
					return var_5_2 < var_5_3
				end
			elseif var_5_6 then
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
		item_sort_func = function (arg_6_0, arg_6_1)
			local var_6_0 = arg_6_0.data
			local var_6_1 = arg_6_1.data
			local var_6_2 = arg_6_0.power_level or 0
			local var_6_3 = arg_6_1.power_level or 0
			local var_6_4 = arg_6_0.backend_id
			local var_6_5 = arg_6_1.backend_id
			local var_6_6 = ItemHelper.is_favorite_backend_id(var_6_4, arg_6_0)

			if var_6_6 == ItemHelper.is_favorite_backend_id(var_6_5, arg_6_1) then
				if var_6_2 == var_6_3 then
					local var_6_7 = arg_6_0.rarity or var_6_0.rarity
					local var_6_8 = arg_6_1.rarity or var_6_1.rarity
					local var_6_9 = UISettings.item_rarity_order
					local var_6_10 = var_6_9[var_6_7]
					local var_6_11 = var_6_9[var_6_8]

					if var_6_10 == var_6_11 then
						local var_6_12 = Localize(var_6_0.item_type)
						local var_6_13 = Localize(var_6_1.item_type)

						if var_6_12 == var_6_13 then
							local var_6_14, var_6_15 = UIUtils.get_ui_information_from_item(arg_6_0)
							local var_6_16, var_6_17 = UIUtils.get_ui_information_from_item(arg_6_1)

							return Localize(var_6_15) < Localize(var_6_17)
						else
							return var_6_12 < var_6_13
						end
					else
						return var_6_10 < var_6_11
					end
				else
					return var_6_3 < var_6_2
				end
			elseif var_6_6 then
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
		item_sort_func = function (arg_7_0, arg_7_1)
			local var_7_0 = arg_7_0.data
			local var_7_1 = arg_7_1.data
			local var_7_2 = arg_7_0.power_level or 0
			local var_7_3 = arg_7_1.power_level or 0
			local var_7_4 = arg_7_0.backend_id
			local var_7_5 = arg_7_1.backend_id
			local var_7_6 = ItemHelper.is_favorite_backend_id(var_7_4, arg_7_0)

			if var_7_6 == ItemHelper.is_favorite_backend_id(var_7_5, arg_7_1) then
				if var_7_2 == var_7_3 then
					local var_7_7 = arg_7_0.rarity or var_7_0.rarity
					local var_7_8 = arg_7_1.rarity or var_7_1.rarity
					local var_7_9 = UISettings.item_rarity_order
					local var_7_10 = var_7_9[var_7_7]
					local var_7_11 = var_7_9[var_7_8]

					if var_7_10 == var_7_11 then
						local var_7_12 = Localize(var_7_0.item_type)
						local var_7_13 = Localize(var_7_1.item_type)

						if var_7_12 == var_7_13 then
							local var_7_14, var_7_15 = UIUtils.get_ui_information_from_item(arg_7_0)
							local var_7_16, var_7_17 = UIUtils.get_ui_information_from_item(arg_7_1)

							return Localize(var_7_15) < Localize(var_7_17)
						else
							return var_7_12 < var_7_13
						end
					else
						return var_7_10 < var_7_11
					end
				else
					return var_7_3 < var_7_2
				end
			elseif var_7_6 then
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
		item_sort_func = function (arg_8_0, arg_8_1)
			local var_8_0 = arg_8_0.data
			local var_8_1 = arg_8_1.data
			local var_8_2 = arg_8_0.power_level or 0
			local var_8_3 = arg_8_1.power_level or 0
			local var_8_4 = arg_8_0.backend_id
			local var_8_5 = arg_8_1.backend_id
			local var_8_6 = ItemHelper.is_favorite_backend_id(var_8_4, arg_8_0)

			if var_8_6 == ItemHelper.is_favorite_backend_id(var_8_5, arg_8_1) then
				if var_8_2 == var_8_3 then
					local var_8_7 = arg_8_0.rarity or var_8_0.rarity
					local var_8_8 = arg_8_1.rarity or var_8_1.rarity
					local var_8_9 = UISettings.item_rarity_order
					local var_8_10 = var_8_9[var_8_7]
					local var_8_11 = var_8_9[var_8_8]

					if var_8_10 == var_8_11 then
						local var_8_12 = Localize(var_8_0.item_type)
						local var_8_13 = Localize(var_8_1.item_type)

						if var_8_12 == var_8_13 then
							local var_8_14, var_8_15 = UIUtils.get_ui_information_from_item(arg_8_0)
							local var_8_16, var_8_17 = UIUtils.get_ui_information_from_item(arg_8_1)

							return Localize(var_8_15) < Localize(var_8_17)
						else
							return var_8_12 < var_8_13
						end
					else
						return var_8_10 < var_8_11
					end
				else
					return var_8_3 < var_8_2
				end
			elseif var_8_6 then
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
		item_sort_func = function (arg_9_0, arg_9_1)
			local var_9_0 = arg_9_0.data
			local var_9_1 = arg_9_1.data
			local var_9_2 = arg_9_0.power_level or 0
			local var_9_3 = arg_9_1.power_level or 0
			local var_9_4 = arg_9_0.backend_id
			local var_9_5 = arg_9_1.backend_id
			local var_9_6 = ItemHelper.is_favorite_backend_id(var_9_4, arg_9_0)

			if var_9_6 == ItemHelper.is_favorite_backend_id(var_9_5, arg_9_1) then
				if var_9_2 == var_9_3 then
					local var_9_7 = arg_9_0.rarity or var_9_0.rarity
					local var_9_8 = arg_9_1.rarity or var_9_1.rarity
					local var_9_9 = UISettings.item_rarity_order
					local var_9_10 = var_9_9[var_9_7]
					local var_9_11 = var_9_9[var_9_8]

					if var_9_10 == var_9_11 then
						local var_9_12 = Localize(var_9_0.item_type)
						local var_9_13 = Localize(var_9_1.item_type)

						if var_9_12 == var_9_13 then
							local var_9_14, var_9_15 = UIUtils.get_ui_information_from_item(arg_9_0)
							local var_9_16, var_9_17 = UIUtils.get_ui_information_from_item(arg_9_1)

							return Localize(var_9_15) < Localize(var_9_17)
						else
							return var_9_12 < var_9_13
						end
					else
						return var_9_10 < var_9_11
					end
				else
					return var_9_3 < var_9_2
				end
			elseif var_9_6 then
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
		item_sort_func = function (arg_10_0, arg_10_1)
			local var_10_0 = arg_10_0.data
			local var_10_1 = arg_10_1.data
			local var_10_2 = arg_10_0.power_level or 0
			local var_10_3 = arg_10_1.power_level or 0
			local var_10_4 = arg_10_0.backend_id
			local var_10_5 = arg_10_1.backend_id
			local var_10_6 = ItemHelper.is_favorite_backend_id(var_10_4, arg_10_0)

			if var_10_6 == ItemHelper.is_favorite_backend_id(var_10_5, arg_10_1) then
				if var_10_2 == var_10_3 then
					local var_10_7 = arg_10_0.rarity or var_10_0.rarity
					local var_10_8 = arg_10_1.rarity or var_10_1.rarity
					local var_10_9 = UISettings.item_rarity_order
					local var_10_10 = var_10_9[var_10_7]
					local var_10_11 = var_10_9[var_10_8]

					if var_10_10 == var_10_11 then
						local var_10_12 = Localize(var_10_0.item_type)
						local var_10_13 = Localize(var_10_1.item_type)

						if var_10_12 == var_10_13 then
							local var_10_14, var_10_15 = UIUtils.get_ui_information_from_item(arg_10_0)
							local var_10_16, var_10_17 = UIUtils.get_ui_information_from_item(arg_10_1)

							return Localize(var_10_15) < Localize(var_10_17)
						else
							return var_10_12 < var_10_13
						end
					else
						return var_10_10 < var_10_11
					end
				else
					return var_10_3 < var_10_2
				end
			elseif var_10_6 then
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
		item_sort_func = function (arg_11_0, arg_11_1)
			local var_11_0 = arg_11_0.data
			local var_11_1 = arg_11_1.data
			local var_11_2 = arg_11_0.power_level or 0
			local var_11_3 = arg_11_1.power_level or 0
			local var_11_4 = arg_11_0.backend_id
			local var_11_5 = arg_11_1.backend_id
			local var_11_6 = ItemHelper.is_favorite_backend_id(var_11_4, arg_11_0)

			if var_11_6 == ItemHelper.is_favorite_backend_id(var_11_5, arg_11_1) then
				if var_11_2 == var_11_3 then
					local var_11_7 = arg_11_0.rarity or var_11_0.rarity
					local var_11_8 = arg_11_1.rarity or var_11_1.rarity
					local var_11_9 = UISettings.item_rarity_order
					local var_11_10 = var_11_9[var_11_7]
					local var_11_11 = var_11_9[var_11_8]

					if var_11_10 == var_11_11 then
						local var_11_12 = Localize(var_11_0.item_type)
						local var_11_13 = Localize(var_11_1.item_type)

						if var_11_12 == var_11_13 then
							local var_11_14, var_11_15 = UIUtils.get_ui_information_from_item(arg_11_0)
							local var_11_16, var_11_17 = UIUtils.get_ui_information_from_item(arg_11_1)

							return Localize(var_11_15) < Localize(var_11_17)
						else
							return var_11_12 < var_11_13
						end
					else
						return var_11_10 < var_11_11
					end
				else
					return var_11_3 < var_11_2
				end
			elseif var_11_6 then
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
		item_sort_func = function (arg_12_0, arg_12_1)
			local var_12_0 = arg_12_0.data
			local var_12_1 = arg_12_1.data
			local var_12_2 = arg_12_0.power_level or 0
			local var_12_3 = arg_12_1.power_level or 0
			local var_12_4 = arg_12_0.backend_id
			local var_12_5 = arg_12_1.backend_id
			local var_12_6 = ItemHelper.is_favorite_backend_id(var_12_4, arg_12_0)

			if var_12_6 == ItemHelper.is_favorite_backend_id(var_12_5, arg_12_1) then
				if var_12_2 == var_12_3 then
					local var_12_7 = arg_12_0.rarity or var_12_0.rarity
					local var_12_8 = arg_12_1.rarity or var_12_1.rarity
					local var_12_9 = UISettings.item_rarity_order
					local var_12_10 = var_12_9[var_12_7]
					local var_12_11 = var_12_9[var_12_8]

					if var_12_10 == var_12_11 then
						local var_12_12 = Localize(var_12_0.item_type)
						local var_12_13 = Localize(var_12_1.item_type)

						if var_12_12 == var_12_13 then
							local var_12_14, var_12_15 = UIUtils.get_ui_information_from_item(arg_12_0)
							local var_12_16, var_12_17 = UIUtils.get_ui_information_from_item(arg_12_1)

							return Localize(var_12_15) < Localize(var_12_17)
						else
							return var_12_12 < var_12_13
						end
					else
						return var_12_10 < var_12_11
					end
				else
					return var_12_3 < var_12_2
				end
			elseif var_12_6 then
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
		item_sort_func = function (arg_13_0, arg_13_1)
			local var_13_0 = arg_13_0.data
			local var_13_1 = arg_13_1.data
			local var_13_2 = arg_13_0.power_level or 0
			local var_13_3 = arg_13_1.power_level or 0
			local var_13_4 = arg_13_0.backend_id
			local var_13_5 = arg_13_1.backend_id
			local var_13_6 = ItemHelper.is_favorite_backend_id(var_13_4, arg_13_0)

			if var_13_6 == ItemHelper.is_favorite_backend_id(var_13_5, arg_13_1) then
				if var_13_2 == var_13_3 then
					local var_13_7 = arg_13_0.rarity or var_13_0.rarity
					local var_13_8 = arg_13_1.rarity or var_13_1.rarity
					local var_13_9 = UISettings.item_rarity_order
					local var_13_10 = var_13_9[var_13_7]
					local var_13_11 = var_13_9[var_13_8]

					if var_13_10 == var_13_11 then
						local var_13_12 = Localize(var_13_0.item_type)
						local var_13_13 = Localize(var_13_1.item_type)

						if var_13_12 == var_13_13 then
							local var_13_14, var_13_15 = UIUtils.get_ui_information_from_item(arg_13_0)
							local var_13_16, var_13_17 = UIUtils.get_ui_information_from_item(arg_13_1)

							return Localize(var_13_15) < Localize(var_13_17)
						else
							return var_13_12 < var_13_13
						end
					else
						return var_13_10 < var_13_11
					end
				else
					return var_13_3 < var_13_2
				end
			elseif var_13_6 then
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
		item_sort_func = function (arg_14_0, arg_14_1)
			local var_14_0 = arg_14_0.data
			local var_14_1 = arg_14_1.data
			local var_14_2 = arg_14_0.power_level or 0
			local var_14_3 = arg_14_1.power_level or 0
			local var_14_4 = arg_14_0.backend_id
			local var_14_5 = arg_14_1.backend_id
			local var_14_6 = ItemHelper.is_favorite_backend_id(var_14_4, arg_14_0)

			if var_14_6 == ItemHelper.is_favorite_backend_id(var_14_5, arg_14_1) then
				if var_14_2 == var_14_3 then
					local var_14_7 = arg_14_0.rarity or var_14_0.rarity
					local var_14_8 = arg_14_1.rarity or var_14_1.rarity
					local var_14_9 = UISettings.item_rarity_order
					local var_14_10 = var_14_9[var_14_7]
					local var_14_11 = var_14_9[var_14_8]

					if var_14_10 == var_14_11 then
						local var_14_12 = Localize(var_14_0.item_type)
						local var_14_13 = Localize(var_14_1.item_type)

						if var_14_12 == var_14_13 then
							local var_14_14, var_14_15 = UIUtils.get_ui_information_from_item(arg_14_0)
							local var_14_16, var_14_17 = UIUtils.get_ui_information_from_item(arg_14_1)

							return Localize(var_14_15) < Localize(var_14_17)
						else
							return var_14_12 < var_14_13
						end
					else
						return var_14_10 < var_14_11
					end
				else
					return var_14_3 < var_14_2
				end
			elseif var_14_6 then
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
			local var_15_0, var_15_1 = UIUtils.get_ui_information_from_item(arg_15_0)
			local var_15_2, var_15_3 = UIUtils.get_ui_information_from_item(arg_15_1)

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
			local var_16_0, var_16_1 = UIUtils.get_ui_information_from_item(arg_16_0)
			local var_16_2, var_16_3 = UIUtils.get_ui_information_from_item(arg_16_1)

			return var_16_1 < var_16_3
		end
	}
}
local var_0_1 = {}
local var_0_2 = {}

for iter_0_0, iter_0_1 in ipairs(var_0_0) do
	local var_0_3 = iter_0_1.name

	var_0_1[iter_0_0] = var_0_3
	var_0_2[var_0_3] = iter_0_1
end

return var_0_0, var_0_2, var_0_1
