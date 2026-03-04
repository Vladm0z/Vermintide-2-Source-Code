-- chunkname: @scripts/helpers/ui_utils.lua

require("scripts/helpers/item_tooltip_helper")

UIUtils = UIUtils or {}
FAKE_INPUT_SERVICE = {
	get = NOP,
	has = NOP
}
ALL_INPUT_METHODS = {
	"keyboard",
	"gamepad",
	"mouse"
}

UIUtils.use_gamepad_hud_layout = function ()
	if not IS_WINDOWS then
		return true
	end

	local var_1_0 = UISettings.use_gamepad_hud_layout

	if var_1_0 == "auto" then
		return Managers.input:is_device_active("gamepad")
	elseif var_1_0 == "never" then
		return false
	elseif var_1_0 == "always" then
		return true
	end
end

local var_0_0 = {}

UIUtils.format_localized_description = function (arg_2_0, arg_2_1)
	local var_2_0 = Localize(arg_2_0)

	if not arg_2_1 or table.is_empty(arg_2_1) then
		return var_2_0
	end

	local var_2_1 = #arg_2_1

	for iter_2_0 = 1, var_2_1 do
		local var_2_2 = arg_2_1[iter_2_0]
		local var_2_3 = var_2_2.value_type
		local var_2_4 = var_2_2.value_fmt
		local var_2_5 = var_2_2.value

		if var_2_2.localize then
			local var_2_6 = var_2_2.format_values

			var_2_5 = UIUtils.format_localized_description(var_2_5, var_2_6)
		end

		if var_2_3 == "percent" then
			var_2_5 = math.abs(100 * var_2_5)
		elseif var_2_3 == "baked_percent" then
			var_2_5 = math.abs(100 * (var_2_5 - 1))
		end

		if var_2_4 then
			var_2_5 = string.format(var_2_4, var_2_5)
		end

		var_0_0[iter_2_0] = var_2_5
	end

	local var_2_7 = string.format(var_2_0, unpack(var_0_0, 1, var_2_1))

	table.clear(var_0_0)

	return var_2_7
end

UIUtils.get_talent_description = function (arg_3_0)
	return UIUtils.format_localized_description(arg_3_0.description, arg_3_0.description_values)
end

UIUtils.get_ability_description = function (arg_4_0)
	return UIUtils.format_localized_description(arg_4_0.description, arg_4_0.description_values)
end

UIUtils.get_perk_description = function (arg_5_0)
	return UIUtils.format_localized_description(arg_5_0.description, arg_5_0.description_values)
end

UIUtils.get_weave_property_description = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = Localize(arg_6_1.display_name)
	local var_6_1 = arg_6_1.description_values
	local var_6_2 = #arg_6_2
	local var_6_3 = ""

	if var_6_1 then
		local var_6_4 = var_6_1[1]
		local var_6_5 = var_6_4.value_type
		local var_6_6 = var_6_4.value
		local var_6_7 = arg_6_3 or 1
		local var_6_8 = var_6_6 / var_6_2 * var_6_7

		if var_6_5 == "percent" then
			var_6_8 = math.abs(100 * var_6_8)
		elseif var_6_5 == "baked_percent" then
			var_6_8 = math.abs(100 * (var_6_8 - 1))
		end

		var_6_3 = string.format(var_6_0, var_6_8)
	else
		var_6_3 = var_6_0
	end

	return var_6_3
end

UIUtils.get_weave_property_value_text = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_1.description_values
	local var_7_1 = #arg_7_2
	local var_7_2 = "n/a"

	if var_7_0 then
		local var_7_3 = var_7_0[1]
		local var_7_4 = var_7_3.value_type
		local var_7_5 = var_7_3.value / var_7_1 * (arg_7_3 or 1)

		if var_7_4 == "percent" then
			var_7_2 = math.abs(100 * var_7_5) .. "%"
		elseif var_7_4 == "baked_percent" then
			var_7_2 = math.abs(100 * (var_7_5 - 1)) .. "%"
		else
			var_7_2 = var_7_5
		end
	end

	return var_7_2
end

UIUtils.get_property_description = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_2 or WeaponProperties.properties[arg_8_0]
	local var_8_1 = Localize(var_8_0.display_name)
	local var_8_2 = var_8_0.description_values
	local var_8_3
	local var_8_4 = ""

	if var_8_2 then
		local var_8_5
		local var_8_6
		local var_8_7 = var_8_2[1]
		local var_8_8 = var_8_7.value_type
		local var_8_9 = var_8_7.value
		local var_8_10

		if type(var_8_9) == "table" then
			if #var_8_9 > 2 then
				var_8_10 = var_8_9[arg_8_1 == 1 and #var_8_9 or 1 + math.floor(arg_8_1 / (1 / #var_8_9))]
				var_8_5 = var_8_9[1]
				var_8_6 = var_8_9[#var_8_9]
			else
				var_8_5 = var_8_9[1]
				var_8_6 = var_8_9[2]
				var_8_10 = math.lerp(var_8_5, var_8_6, arg_8_1)
			end
		else
			var_8_10 = var_8_9
		end

		if var_8_8 == "percent" then
			var_8_10 = math.abs(100 * var_8_10)
			var_8_5 = math.abs(100 * var_8_5)
			var_8_6 = math.abs(100 * var_8_6)
			var_8_4 = string.format(" (%.1f%% - %.1f%%)", var_8_5, var_8_6)
		elseif var_8_8 == "baked_percent" then
			var_8_10 = math.abs(100 * (var_8_10 - 1))

			local var_8_11 = math.abs(100 * (var_8_5 - 1))
			local var_8_12 = math.abs(100 * (var_8_6 - 1))

			var_8_4 = string.format(" (%.1f%% - %.1f%%)", var_8_11, var_8_12)
		end

		var_8_3 = string.format(var_8_1, var_8_10)
	else
		var_8_3 = var_8_1
	end

	return var_8_3, var_8_4
end

UIUtils.get_trait_description = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_1 or WeaponTraits.traits[arg_9_0]
	local var_9_1 = Localize(var_9_0.advanced_description)
	local var_9_2 = var_9_0.description_values
	local var_9_3

	if var_9_2 then
		local var_9_4 = {}

		for iter_9_0 = 1, #var_9_2 do
			local var_9_5 = var_9_2[iter_9_0]
			local var_9_6 = var_9_5.value_type
			local var_9_7 = var_9_5.value

			if var_9_6 == "percent" or var_9_6 == "proc_chance" then
				var_9_4[#var_9_4 + 1] = math.abs(100 * var_9_7)
			else
				var_9_4[#var_9_4 + 1] = var_9_7
			end
		end

		var_9_3 = string.format(var_9_1, unpack(var_9_4))
	else
		var_9_3 = var_9_1
	end

	return var_9_3
end

UIUtils.get_ui_information_from_item = function (arg_10_0)
	local var_10_0 = arg_10_0.data
	local var_10_1 = var_10_0.item_type
	local var_10_2 = arg_10_0.rarity
	local var_10_3
	local var_10_4
	local var_10_5
	local var_10_6

	if var_10_1 == "weapon_skin" then
		local var_10_7 = arg_10_0.skin or arg_10_0.key or var_10_0.key
		local var_10_8 = WeaponSkins.skins[var_10_7]

		var_10_3 = var_10_8.inventory_icon
		var_10_6 = var_10_8.store_icon
		var_10_4 = var_10_8.display_name
		var_10_5 = var_10_8.description
	elseif var_10_1 == "weapon_pose" then
		var_10_3 = var_10_0.hud_icon
		var_10_6 = "icons_placeholder"
		var_10_4 = var_10_0.display_name
		var_10_5 = var_10_0.description
	elseif arg_10_0.skin then
		local var_10_9 = arg_10_0.skin
		local var_10_10 = WeaponSkins.skins[var_10_9]

		var_10_3 = var_10_10.inventory_icon
		var_10_6 = var_10_10.store_icon
		var_10_4 = var_10_10.display_name
		var_10_5 = var_10_10.description
	elseif var_10_2 == "default" then
		local var_10_11 = var_10_0.key
		local var_10_12 = UISettings.default_items[var_10_11]

		if var_10_12 then
			var_10_3 = var_10_12.inventory_icon or var_10_0.inventory_icon
			var_10_6 = var_10_12.store_icon or var_10_0.store_icon
			var_10_4 = var_10_12.display_name or var_10_0.display_name
			var_10_5 = var_10_12.description or var_10_0.description
		else
			var_10_3 = var_10_0.inventory_icon
			var_10_6 = var_10_0.store_icon
			var_10_4 = var_10_0.display_name
			var_10_5 = var_10_0.description
		end
	else
		var_10_3 = var_10_0.inventory_icon
		var_10_6 = var_10_0.store_icon
		var_10_4 = var_10_0.display_name
		var_10_5 = var_10_0.description
	end

	return var_10_3, var_10_4, var_10_5, var_10_6
end

UIUtils.presentable_hero_power_level = function (arg_11_0)
	return math.max(0, math.floor(arg_11_0 - PowerLevelFromLevelSettings.starting_power_level))
end

UIUtils.presentable_hero_power_level_weaves = function (arg_12_0)
	return math.max(0, math.floor(arg_12_0 - PowerLevelFromMagicLevel.starting_power_level))
end

UIUtils.get_item_tooltip_value = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_2.format_type
	local var_13_1 = arg_13_2.format_function_name
	local var_13_2 = ItemTooltipHelper[var_13_1]
	local var_13_3 = {}

	if arg_13_2.detailed then
		ItemTooltipHelper.parse_weapon_chain(var_13_3, arg_13_0, arg_13_1, arg_13_2, var_13_2)
	else
		local var_13_4 = ItemTooltipHelper.get_action(arg_13_0, arg_13_1, arg_13_2)

		var_13_2(var_13_3, var_13_4, arg_13_0, arg_13_1, arg_13_2)
	end

	return ItemTooltipHelper.format_return_string(var_13_0, var_13_3)
end

UIUtils.get_hero_statistics_by_template = function (arg_14_0)
	local var_14_0 = {}
	local var_14_1 = {}

	for iter_14_0, iter_14_1 in ipairs(arg_14_0) do
		local var_14_2 = iter_14_1.type
		local var_14_3 = iter_14_1.display_name
		local var_14_4 = iter_14_1.description_name
		local var_14_5

		if var_14_2 == "title" then
			var_14_3 = iter_14_1.display_name
		elseif var_14_2 == "entry" then
			var_14_3 = iter_14_1.display_name
			var_14_5 = iter_14_1.generate_value(var_14_1)
			var_14_4 = iter_14_1.description_name or iter_14_1.generate_description(var_14_1)
		end

		if iter_14_1.value_type == "percent" then
			var_14_5 = tostring(var_14_5) .. "%"
		end

		var_14_0[iter_14_0] = {
			display_name = var_14_3,
			description_name = var_14_4,
			value = var_14_5,
			value_text = tostring(var_14_5),
			type = var_14_2
		}
	end

	return var_14_0
end

UIUtils.get_text_height = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0, var_15_1 = UIFontByResolution(arg_15_2)

	if arg_15_2.localize then
		arg_15_3 = Localize(arg_15_3)
	end

	if arg_15_2.upper_case then
		arg_15_3 = TextToUpper(arg_15_3)
	end

	local var_15_2, var_15_3, var_15_4 = UIGetFontHeight(arg_15_0.gui, arg_15_2.font_type, var_15_1)
	local var_15_5 = UIRenderer.word_wrap(arg_15_0, arg_15_3, var_15_0[1], var_15_1, arg_15_1[1])
	local var_15_6 = 1
	local var_15_7 = #var_15_5
	local var_15_8 = math.min(#var_15_5 - (var_15_6 - 1), var_15_7)
	local var_15_9 = RESOLUTION_LOOKUP.inv_scale

	return (var_15_4 + math.abs(var_15_3)) * var_15_9 * var_15_8, var_15_8
end

UIUtils.get_text_width = function (arg_16_0, arg_16_1, arg_16_2)
	if arg_16_1.localize then
		arg_16_2 = Localize(arg_16_2)
	end

	if arg_16_1.upper_case then
		arg_16_2 = TextToUpper(arg_16_2)
	end

	local var_16_0, var_16_1 = UIFontByResolution(arg_16_1)

	return (UIRenderer.text_size(arg_16_0, arg_16_2, var_16_0[1], var_16_1))
end

UIUtils.enable_button = function (arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_0.content

	;(var_17_0[arg_17_2] or var_17_0.button_hotspot or var_17_0.hotspot).disable_button = not arg_17_1
end

UIUtils.is_button_enabled = function (arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_0.content

	return not (var_18_0[arg_18_2] or var_18_0.button_hotspot or var_18_0.hotspot).disable_button
end

UIUtils.is_button_pressed = function (arg_19_0, arg_19_1, arg_19_2)
	if arg_19_0 then
		local var_19_0 = arg_19_0.content
		local var_19_1 = var_19_0[arg_19_1] or var_19_0.button_hotspot or var_19_0.hotspot

		if var_19_1.on_release then
			var_19_1.on_release = false

			return true
		elseif var_19_1.is_selected and arg_19_2 then
			var_19_1.is_selected = false

			return true
		end
	end

	return false
end

UIUtils.is_right_button_pressed = function (arg_20_0, arg_20_1, arg_20_2)
	if arg_20_0 then
		local var_20_0 = arg_20_0.content
		local var_20_1 = var_20_0[arg_20_1] or var_20_0.button_hotspot or var_20_0.hotspot

		if var_20_1.on_right_click then
			var_20_1.on_right_click = false

			return true
		elseif var_20_1.is_selected and arg_20_2 then
			var_20_1.is_selected = false

			return true
		end
	end

	return false
end

UIUtils.is_button_held = function (arg_21_0, arg_21_1)
	if arg_21_0 then
		local var_21_0 = arg_21_0.content

		if (var_21_0[arg_21_1] or var_21_0.button_hotspot or var_21_0.hotspot).is_held then
			return true
		end
	end

	return false
end

UIUtils.is_button_hover_enter = function (arg_22_0, arg_22_1)
	if arg_22_0 then
		local var_22_0 = arg_22_0.content

		return (var_22_0[arg_22_1] or var_22_0.button_hotspot or var_22_0.hotspot).on_hover_enter
	end

	return false
end

UIUtils.is_button_hover = function (arg_23_0, arg_23_1)
	if arg_23_0 then
		local var_23_0 = arg_23_0.content

		return (var_23_0[arg_23_1] or var_23_0.button_hotspot or var_23_0.hotspot).is_hover
	end

	return false
end

UIUtils.is_button_selected = function (arg_24_0, arg_24_1)
	if arg_24_0 then
		local var_24_0 = arg_24_0.content

		return (var_24_0[arg_24_1] or var_24_0.button_hotspot or var_24_0.hotspot).is_selected
	end

	return false
end

UIUtils.is_left_button_released = function (arg_25_0, arg_25_1)
	if arg_25_0 then
		local var_25_0 = arg_25_0.content

		return (var_25_0[arg_25_1] or var_25_0.button_hotspot or var_25_0.hotspot).on_left_release
	end

	return false
end

UIUtils.animate_value = function (arg_26_0, arg_26_1, arg_26_2)
	if arg_26_2 then
		return math.min(arg_26_0 + arg_26_1, 1)
	else
		return math.max(arg_26_0 - arg_26_1, 0)
	end
end

UIUtils.comma_value = function (arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0
	local var_27_1
	local var_27_2 = "%1" .. (arg_27_1 or " ") .. "%2"

	repeat
		local var_27_3

		var_27_0, var_27_3 = string.gsub(var_27_0, "^(-?%d+)(%d%d%d)", var_27_2)
	until var_27_3 == 0

	return var_27_0
end

UIUtils.get_portrait_image_by_profile_index = function (arg_28_0, arg_28_1)
	return SPProfiles[arg_28_0].careers[arg_28_1].portrait_image
end

UIUtils.create_widgets = function (arg_29_0, arg_29_1, arg_29_2)
	if arg_29_1 == nil then
		arg_29_1 = {}
	end

	if arg_29_2 == nil then
		arg_29_2 = {}
	end

	for iter_29_0, iter_29_1 in pairs(arg_29_0) do
		local var_29_0 = UIWidget.init(iter_29_1)

		if arg_29_1 then
			arg_29_1[#arg_29_1 + 1] = var_29_0
		end

		if arg_29_2 then
			arg_29_2[iter_29_0] = var_29_0
		end
	end

	return arg_29_1, arg_29_2
end

UIUtils.destroy_widgets = function (arg_30_0, arg_30_1)
	local var_30_0 = UIWidget.destroy

	for iter_30_0, iter_30_1 in pairs(arg_30_1) do
		var_30_0(arg_30_0, iter_30_1)
	end
end

UIUtils.mark_dirty = function (arg_31_0)
	for iter_31_0, iter_31_1 in pairs(arg_31_0) do
		iter_31_1.element.dirty = true
	end
end

UIUtils.align_box_inplace = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	local var_32_0 = arg_32_0.horizontal_alignment

	if var_32_0 == "right" then
		arg_32_1[1] = arg_32_1[1] + arg_32_2[1] - arg_32_3[1]
	elseif var_32_0 == "center" then
		arg_32_1[1] = arg_32_1[1] + 0.5 * (arg_32_2[1] - arg_32_3[1])
	end

	local var_32_1 = arg_32_0.vertical_alignment

	if var_32_1 == "top" then
		arg_32_1[2] = arg_32_1[2] + arg_32_2[2] - arg_32_3[2]
	elseif var_32_1 == "center" then
		arg_32_1[2] = arg_32_1[2] + 0.5 * (arg_32_2[2] - arg_32_3[2])
	end
end

UIUtils.format_time = function (arg_33_0)
	local var_33_0 = arg_33_0 % 60
	local var_33_1 = (arg_33_0 - var_33_0) / 60

	return string.format("%02d:%02d", var_33_1, var_33_0)
end

UIUtils.format_time_long = function (arg_34_0)
	local var_34_0 = math.floor
	local var_34_1 = var_34_0(arg_34_0 / 86400)
	local var_34_2 = var_34_0(arg_34_0 / 3600 % 24)
	local var_34_3 = var_34_0(arg_34_0 / 60) % 60
	local var_34_4 = arg_34_0 % 60

	return string.format("%02d:%02d:%02d:%02d", var_34_1, var_34_2, var_34_3, var_34_4)
end

UIUtils.format_duration = function (arg_35_0, arg_35_1)
	if arg_35_0 > 172800 then
		return string.format(Localize("datetime_days") .. ", " .. Localize("datetime_hours_short"), arg_35_0 / 86400, arg_35_0 / 3600 % 24)
	elseif arg_35_0 > 7200 then
		return string.format(Localize("datetime_hours_short") .. ", " .. Localize("datetime_minutes_short"), arg_35_0 / 3600, arg_35_0 / 60 % 60)
	elseif arg_35_0 > 120 then
		return string.format(Localize("datetime_minutes_short") .. ", " .. Localize("datetime_seconds_short"), arg_35_0 / 60, arg_35_0 % 60)
	elseif arg_35_0 > 0 then
		return string.format(Localize("datetime_seconds_short"), arg_35_0)
	else
		return arg_35_1 or string.format(Localize("datetime_seconds_short"), 0)
	end
end

UIUtils.get_color_for_consumable_item = function (arg_36_0)
	local var_36_0 = UISettings.inventory_consumable_slot_colors.default

	return arg_36_0 and UISettings.inventory_consumable_slot_colors[arg_36_0] or var_36_0
end

UIUtils.sort_items_power_level_ascending = function (arg_37_0, arg_37_1)
	local var_37_0 = arg_37_0.power_level or math.huge
	local var_37_1 = arg_37_1.power_level or math.huge

	if var_37_0 == var_37_1 then
		return UIUtils.sort_items_rarity_ascending(arg_37_0, arg_37_1)
	end

	return var_37_0 < var_37_1
end

UIUtils.sort_items_power_level_descending = function (arg_38_0, arg_38_1)
	local var_38_0 = arg_38_0.power_level or math.huge
	local var_38_1 = arg_38_1.power_level or math.huge

	if var_38_0 == var_38_1 then
		return UIUtils.sort_items_rarity_descending(arg_38_0, arg_38_1)
	end

	return var_38_1 < var_38_0
end

UIUtils.sort_items_rarity_ascending = function (arg_39_0, arg_39_1)
	local var_39_0 = arg_39_0.data
	local var_39_1 = arg_39_1.data
	local var_39_2 = arg_39_0.rarity or var_39_0.rarity
	local var_39_3 = arg_39_1.rarity or var_39_1.rarity
	local var_39_4 = UISettings.item_rarity_order

	return var_39_4[var_39_2] > var_39_4[var_39_3]
end

UIUtils.sort_items_rarity_descending = function (arg_40_0, arg_40_1)
	local var_40_0 = arg_40_0.data
	local var_40_1 = arg_40_1.data
	local var_40_2 = arg_40_0.rarity or var_40_0.rarity
	local var_40_3 = arg_40_1.rarity or var_40_1.rarity
	local var_40_4 = UISettings.item_rarity_order

	return var_40_4[var_40_2] < var_40_4[var_40_3]
end

UIUtils.set_widget_alpha = function (arg_41_0, arg_41_1, arg_41_2)
	if not arg_41_0 then
		return
	end

	local var_41_0 = arg_41_0.style

	if arg_41_2 then
		if var_41_0[arg_41_2].color then
			var_41_0[arg_41_2].color[1] = arg_41_1
		elseif var_41_0[arg_41_2].text_color then
			var_41_0[arg_41_2].text_color[1] = arg_41_1
		end
	else
		for iter_41_0, iter_41_1 in pairs(var_41_0) do
			if iter_41_1.color then
				iter_41_1.color[1] = arg_41_1
			elseif iter_41_1.text_color then
				iter_41_1.text_color[1] = arg_41_1
			end
		end
	end
end
