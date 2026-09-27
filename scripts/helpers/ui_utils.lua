-- chunkname: @scripts/helpers/ui_utils.lua

require("scripts/helpers/item_tooltip_helper")

local UIUtils = UIUtils

UIUtils = UIUtils or {}
UIUtils = UIUtils
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
	-- function 1
	if not IS_WINDOWS then
		return true
	end

	local use_gamepad_hud_layout = UISettings.use_gamepad_hud_layout

	if use_gamepad_hud_layout == "auto" then
		return Managers.input:is_device_active("gamepad")
	elseif use_gamepad_hud_layout == "never" then
		return false
	elseif use_gamepad_hud_layout == "always" then
		return true
	end
end

local tbl = {}

UIUtils.format_localized_description = function (arg_2_0, arg_2_1)
	-- function 2
	local var_2_0 = Localize(arg_2_0)

	if not arg_2_1 and not table.is_empty(arg_2_1) then
		return var_2_0
	end

	local count = #arg_2_1

	for i = 1, count do
		local var_2_2 = arg_2_1[i]
		local value_type = var_2_2.value_type
		local value_fmt = var_2_2.value_fmt
		local value = var_2_2.value

		if not var_2_2.localize then
			local format_values = var_2_2.format_values

			value = UIUtils.format_localized_description(value, format_values)
		end

		if value_type == "percent" then
			value = math.abs(100 * value)
		elseif value_type == "baked_percent" then
			value = math.abs(100 * (value - 1))
		end

		if not value_fmt then
			value = string.format(value_fmt, value)
		end

		tbl[i] = value
	end

	local format = string.format(var_2_0, unpack(tbl, 1, count))

	table.clear(tbl)

	return format
end

UIUtils.get_talent_description = function (self)
	-- function 3
	return UIUtils.format_localized_description(self.description, self.description_values)
end

UIUtils.get_ability_description = function (self)
	-- function 4
	return UIUtils.format_localized_description(self.description, self.description_values)
end

UIUtils.get_perk_description = function (self)
	-- function 5
	return UIUtils.format_localized_description(self.description, self.description_values)
end

UIUtils.get_weave_property_description = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local var_6_0 = Localize(arg_6_1.display_name)
	local description_values = arg_6_1.description_values
	local count = #arg_6_2
	local str = ""

	if not description_values then
		local var_6_4 = description_values[1]
		local value_type = var_6_4.value_type
		local value = var_6_4.value
		local flag = arg_6_3 or 1
		local num = value / count * flag

		if value_type == "percent" then
			num = math.abs(100 * num)
		elseif value_type == "baked_percent" then
			num = math.abs(100 * (num - 1))
		end

		str = string.format(var_6_0, num)
	else
		str = var_6_0
	end

	return str
end

UIUtils.get_weave_property_value_text = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local description_values = arg_7_1.description_values
	local count = #arg_7_2
	local str = "n/a"

	if not description_values then
		local var_7_3 = description_values[1]
		local value_type = var_7_3.value_type
		local num = var_7_3.value / count * (arg_7_3 or 1)

		if value_type == "percent" then
			str = math.abs(100 * num) .. "%"
		elseif value_type == "baked_percent" then
			str = math.abs(100 * (num - 1)) .. "%"
		else
			str = num
		end
	end

	return str
end

UIUtils.get_property_description = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	local flag = arg_8_2 or WeaponProperties.properties[arg_8_0]
	local var_8_1 = Localize(flag.display_name)
	local description_values = flag.description_values
	local var_8_3
	local str = ""

	if not description_values then
		local var_8_5
		local var_8_6
		local var_8_7 = description_values[1]
		local value_type = var_8_7.value_type
		local value = var_8_7.value
		local var_8_10

		if type(value) == "table" then
			if #value > 2 then
				local count

				if arg_8_1 == 1 then
					count = #value

					if not count then
						-- Nothing
					end
				end

				count = 1 + math.floor(arg_8_1 / (1 / #value))

				::label_8_0::

				var_8_10 = value[count]
				var_8_5 = value[1]
				var_8_6 = value[#value]
			else
				var_8_5 = value[1]
				var_8_6 = value[2]
				var_8_10 = math.lerp(var_8_5, var_8_6, arg_8_1)
			end
		else
			var_8_10 = value
		end

		if value_type == "percent" then
			var_8_10 = math.abs(100 * var_8_10)
			var_8_5 = math.abs(100 * var_8_5)
			var_8_6 = math.abs(100 * var_8_6)
			str = string.format(" (%.1f%% - %.1f%%)", var_8_5, var_8_6)
		elseif value_type == "baked_percent" then
			var_8_10 = math.abs(100 * (var_8_10 - 1))

			local abs = math.abs(100 * (var_8_5 - 1))
			local abs_2 = math.abs(100 * (var_8_6 - 1))

			str = string.format(" (%.1f%% - %.1f%%)", abs, abs_2)
		end

		var_8_3 = string.format(var_8_1, var_8_10)
	else
		var_8_3 = var_8_1
	end

	return var_8_3, str
end

UIUtils.get_trait_description = function (arg_9_0, arg_9_1)
	-- function 9
	local flag = arg_9_1 or WeaponTraits.traits[arg_9_0]
	local var_9_1 = Localize(flag.advanced_description)
	local description_values = flag.description_values
	local var_9_3

	if not description_values then
		local tbl = {}

		for i = 1, #description_values do
			local var_9_5 = description_values[i]
			local value_type = var_9_5.value_type
			local value = var_9_5.value

			if not (value_type == "percent" or value_type ~= "proc_chance") then
				tbl[#tbl + 1] = math.abs(100 * value)
			else
				tbl[#tbl + 1] = value
			end
		end

		var_9_3 = string.format(var_9_1, unpack(tbl))
	else
		var_9_3 = var_9_1
	end

	return var_9_3
end

UIUtils.get_ui_information_from_item = function (self)
	-- function 10
	local data = self.data
	local item_type = data.item_type
	local rarity = self.rarity
	local var_10_3
	local var_10_4
	local var_10_5
	local var_10_6

	if item_type == "weapon_skin" then
		local skin = self.skin

		if not skin then
			skin = self.key
			skin = skin or data.key
		end

		local var_10_8 = WeaponSkins.skins[skin]

		var_10_3 = var_10_8.inventory_icon
		var_10_6 = var_10_8.store_icon
		var_10_4 = var_10_8.display_name
		var_10_5 = var_10_8.description
	elseif item_type == "weapon_pose" then
		var_10_3 = data.hud_icon
		var_10_6 = "icons_placeholder"
		var_10_4 = data.display_name
		var_10_5 = data.description
	elseif not self.skin then
		local skin_2 = self.skin
		local var_10_10 = WeaponSkins.skins[skin_2]

		var_10_3 = var_10_10.inventory_icon
		var_10_6 = var_10_10.store_icon
		var_10_4 = var_10_10.display_name
		var_10_5 = var_10_10.description
	elseif rarity == "default" then
		local key = data.key
		local var_10_12 = UISettings.default_items[key]

		if not var_10_12 then
			var_10_3 = var_10_12.inventory_icon or data.inventory_icon
			var_10_6 = var_10_12.store_icon or data.store_icon
			var_10_4 = var_10_12.display_name or data.display_name
			var_10_5 = var_10_12.description or data.description
		else
			var_10_3 = data.inventory_icon
			var_10_6 = data.store_icon
			var_10_4 = data.display_name
			var_10_5 = data.description
		end
	else
		var_10_3 = data.inventory_icon
		var_10_6 = data.store_icon
		var_10_4 = data.display_name
		var_10_5 = data.description
	end

	return var_10_3, var_10_4, var_10_5, var_10_6
end

UIUtils.presentable_hero_power_level = function (arg_11_0)
	-- function 11
	return math.max(0, math.floor(arg_11_0 - PowerLevelFromLevelSettings.starting_power_level))
end

UIUtils.presentable_hero_power_level_weaves = function (arg_12_0)
	-- function 12
	return math.max(0, math.floor(arg_12_0 - PowerLevelFromMagicLevel.starting_power_level))
end

UIUtils.get_item_tooltip_value = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	local format_type = arg_13_2.format_type
	local format_function_name = arg_13_2.format_function_name
	local var_13_2 = ItemTooltipHelper[format_function_name]
	local tbl = {}

	if not arg_13_2.detailed then
		ItemTooltipHelper.parse_weapon_chain(tbl, arg_13_0, arg_13_1, arg_13_2, var_13_2)
	else
		local get_action = ItemTooltipHelper.get_action(arg_13_0, arg_13_1, arg_13_2)

		var_13_2(tbl, get_action, arg_13_0, arg_13_1, arg_13_2)
	end

	return ItemTooltipHelper.format_return_string(format_type, tbl)
end

UIUtils.get_hero_statistics_by_template = function (arg_14_0)
	-- function 14
	local tbl = {}
	local tbl_2 = {}

	for i, v in ipairs(arg_14_0) do
		local type = v.type
		local display_name = v.display_name
		local description_name = v.description_name
		local var_14_5

		if type == "title" then
			display_name = v.display_name
		elseif type == "entry" then
			display_name = v.display_name
			var_14_5 = v.generate_value(tbl_2)
			description_name = v.description_name or v.generate_description(tbl_2)
		end

		if v.value_type == "percent" then
			var_14_5 = tostring(var_14_5) .. "%"
		end

		tbl[i] = {
			display_name = display_name,
			description_name = description_name,
			value = var_14_5,
			value_text = tostring(var_14_5),
			type = type
		}
	end

	return tbl
end

UIUtils.get_text_height = function (self, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	local var_15_0, var_15_1 = UIFontByResolution(arg_15_2)

	if not arg_15_2.localize then
		arg_15_3 = Localize(arg_15_3)
	end

	if not arg_15_2.upper_case then
		arg_15_3 = TextToUpper(arg_15_3)
	end

	local var_15_2, var_15_3, var_15_4 = UIGetFontHeight(self.gui, arg_15_2.font_type, var_15_1)
	local word_wrap = UIRenderer.word_wrap(self, arg_15_3, var_15_0[1], var_15_1, arg_15_1[1])
	local num = 1
	local count = #word_wrap
	local min = math.min(#word_wrap - (num - 1), count)
	local inv_scale = RESOLUTION_LOOKUP.inv_scale

	return (var_15_4 + math.abs(var_15_3)) * inv_scale * min, min
end

UIUtils.get_text_width = function (arg_16_0, arg_16_1, arg_16_2)
	-- function 16
	if not arg_16_1.localize then
		arg_16_2 = Localize(arg_16_2)
	end

	if not arg_16_1.upper_case then
		arg_16_2 = TextToUpper(arg_16_2)
	end

	local var_16_0, var_16_1 = UIFontByResolution(arg_16_1)

	return (UIRenderer.text_size(arg_16_0, arg_16_2, var_16_0[1], var_16_1))
end

UIUtils.enable_button = function (self, arg_17_1, arg_17_2)
	-- function 17
	local content = self.content
	local var_17_1 = content[arg_17_2]

	if not var_17_1 then
		var_17_1 = content.button_hotspot
		var_17_1 = var_17_1 or content.hotspot
	end

	var_17_1.disable_button = not arg_17_1
end

UIUtils.is_button_enabled = function (self, arg_18_1, arg_18_2)
	-- function 18
	local content = self.content
	local var_18_1 = content[arg_18_2]

	if not var_18_1 then
		var_18_1 = content.button_hotspot
		var_18_1 = var_18_1 or content.hotspot
	end

	return not var_18_1.disable_button
end

UIUtils.is_button_pressed = function (self, arg_19_1, arg_19_2)
	-- function 19
	if not self then
		local content = self.content
		local var_19_1 = content[arg_19_1]

		if not var_19_1 then
			var_19_1 = content.button_hotspot
			var_19_1 = var_19_1 or content.hotspot
		end

		if not var_19_1.on_release then
			var_19_1.on_release = false

			return true
		elseif not var_19_1.is_selected and not arg_19_2 then
			var_19_1.is_selected = false

			return true
		end
	end

	return false
end

UIUtils.is_right_button_pressed = function (self, arg_20_1, arg_20_2)
	-- function 20
	if not self then
		local content = self.content
		local var_20_1 = content[arg_20_1]

		if not var_20_1 then
			var_20_1 = content.button_hotspot
			var_20_1 = var_20_1 or content.hotspot
		end

		if not var_20_1.on_right_click then
			var_20_1.on_right_click = false

			return true
		elseif not var_20_1.is_selected and not arg_20_2 then
			var_20_1.is_selected = false

			return true
		end
	end

	return false
end

UIUtils.is_button_held = function (self, arg_21_1)
	-- function 21
	if not self then
		local content = self.content
		local var_21_1 = content[arg_21_1]

		if not var_21_1 then
			var_21_1 = content.button_hotspot
			var_21_1 = var_21_1 or content.hotspot
		end

		if not var_21_1.is_held then
			return true
		end
	end

	return false
end

UIUtils.is_button_hover_enter = function (self, arg_22_1)
	-- function 22
	if not self then
		local content = self.content
		local var_22_1 = content[arg_22_1]

		if not var_22_1 then
			var_22_1 = content.button_hotspot
			var_22_1 = var_22_1 or content.hotspot
		end

		return var_22_1.on_hover_enter
	end

	return false
end

UIUtils.is_button_hover = function (self, arg_23_1)
	-- function 23
	if not self then
		local content = self.content
		local var_23_1 = content[arg_23_1]

		if not var_23_1 then
			var_23_1 = content.button_hotspot
			var_23_1 = var_23_1 or content.hotspot
		end

		return var_23_1.is_hover
	end

	return false
end

UIUtils.is_button_selected = function (self, arg_24_1)
	-- function 24
	if not self then
		local content = self.content
		local var_24_1 = content[arg_24_1]

		if not var_24_1 then
			var_24_1 = content.button_hotspot
			var_24_1 = var_24_1 or content.hotspot
		end

		return var_24_1.is_selected
	end

	return false
end

UIUtils.is_left_button_released = function (self, arg_25_1)
	-- function 25
	if not self then
		local content = self.content
		local var_25_1 = content[arg_25_1]

		if not var_25_1 then
			var_25_1 = content.button_hotspot
			var_25_1 = var_25_1 or content.hotspot
		end

		return var_25_1.on_left_release
	end

	return false
end

UIUtils.animate_value = function (arg_26_0, arg_26_1, arg_26_2)
	-- function 26
	if not arg_26_2 then
		return math.min(arg_26_0 + arg_26_1, 1)
	else
		return math.max(arg_26_0 - arg_26_1, 0)
	end
end

UIUtils.comma_value = function (arg_27_0, arg_27_1)
	-- function 27
	local var_27_0 = arg_27_0
	local var_27_1
	local str = "%1" .. (arg_27_1 or " ") .. "%2"

	repeat
		local var_27_3

		var_27_0, var_27_3 = string.gsub(var_27_0, "^(-?%d+)(%d%d%d)", str)
	until var_27_3 == 0

	return var_27_0
end

UIUtils.get_portrait_image_by_profile_index = function (arg_28_0, arg_28_1)
	-- function 28
	return SPProfiles[arg_28_0].careers[arg_28_1].portrait_image
end

UIUtils.create_widgets = function (arg_29_0, arg_29_1, arg_29_2)
	-- function 29
	if arg_29_1 == nil then
		arg_29_1 = {}
	end

	if arg_29_2 == nil then
		arg_29_2 = {}
	end

	for k, v in pairs(arg_29_0) do
		local var_29_0 = UIWidget.init(v)

		if not arg_29_1 then
			arg_29_1[#arg_29_1 + 1] = var_29_0
		end

		if not arg_29_2 then
			arg_29_2[k] = var_29_0
		end
	end

	return arg_29_1, arg_29_2
end

UIUtils.destroy_widgets = function (arg_30_0, arg_30_1)
	-- function 30
	local destroy = UIWidget.destroy

	for k, v in pairs(arg_30_1) do
		destroy(arg_30_0, v)
	end
end

UIUtils.mark_dirty = function (arg_31_0)
	-- function 31
	for k, v in pairs(arg_31_0) do
		v.element.dirty = true
	end
end

UIUtils.align_box_inplace = function (self, arg_32_1, arg_32_2, arg_32_3)
	-- function 32
	local horizontal_alignment = self.horizontal_alignment

	if horizontal_alignment == "right" then
		arg_32_1[1] = arg_32_1[1] + arg_32_2[1] - arg_32_3[1]
	elseif horizontal_alignment == "center" then
		arg_32_1[1] = arg_32_1[1] + 0.5 * (arg_32_2[1] - arg_32_3[1])
	end

	local vertical_alignment = self.vertical_alignment

	if vertical_alignment == "top" then
		arg_32_1[2] = arg_32_1[2] + arg_32_2[2] - arg_32_3[2]
	elseif vertical_alignment == "center" then
		arg_32_1[2] = arg_32_1[2] + 0.5 * (arg_32_2[2] - arg_32_3[2])
	end
end

UIUtils.format_time = function (arg_33_0)
	-- function 33
	local num = arg_33_0 % 60
	local num_2 = (arg_33_0 - num) / 60

	return string.format("%02d:%02d", num_2, num)
end

UIUtils.format_time_long = function (arg_34_0)
	-- function 34
	local floor = math.floor
	local var_34_1 = floor(arg_34_0 / 86400)
	local var_34_2 = floor(arg_34_0 / 3600 % 24)
	local num = floor(arg_34_0 / 60) % 60
	local num_2 = arg_34_0 % 60

	return string.format("%02d:%02d:%02d:%02d", var_34_1, var_34_2, num, num_2)
end

UIUtils.format_duration = function (arg_35_0, arg_35_1)
	-- function 35
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
	-- function 36
	local default = UISettings.inventory_consumable_slot_colors.default
	local var_36_1

	if not arg_36_0 then
		var_36_1 = UISettings.inventory_consumable_slot_colors[arg_36_0]

		if not var_36_1 then
			-- Nothing
		end
	end

	var_36_1 = default

	::label_36_0::

	return var_36_1
end

UIUtils.sort_items_power_level_ascending = function (self, arg_37_1)
	-- function 37
	local power_level = self.power_level

	power_level = power_level or math.huge

	local power_level_2 = arg_37_1.power_level

	power_level_2 = power_level_2 or math.huge

	if power_level == power_level_2 then
		return UIUtils.sort_items_rarity_ascending(self, arg_37_1)
	end

	return power_level < power_level_2
end

UIUtils.sort_items_power_level_descending = function (self, arg_38_1)
	-- function 38
	local power_level = self.power_level

	power_level = power_level or math.huge

	local power_level_2 = arg_38_1.power_level

	power_level_2 = power_level_2 or math.huge

	if power_level == power_level_2 then
		return UIUtils.sort_items_rarity_descending(self, arg_38_1)
	end

	return power_level_2 < power_level
end

UIUtils.sort_items_rarity_ascending = function (self, arg_39_1)
	-- function 39
	local data = self.data
	local data_2 = arg_39_1.data
	local rarity = self.rarity

	rarity = rarity or data.rarity

	local rarity_2 = arg_39_1.rarity

	rarity_2 = rarity_2 or data_2.rarity

	local item_rarity_order = UISettings.item_rarity_order

	return item_rarity_order[rarity] > item_rarity_order[rarity_2]
end

UIUtils.sort_items_rarity_descending = function (self, arg_40_1)
	-- function 40
	local data = self.data
	local data_2 = arg_40_1.data
	local rarity = self.rarity

	rarity = rarity or data.rarity

	local rarity_2 = arg_40_1.rarity

	rarity_2 = rarity_2 or data_2.rarity

	local item_rarity_order = UISettings.item_rarity_order

	return item_rarity_order[rarity] < item_rarity_order[rarity_2]
end

UIUtils.set_widget_alpha = function (self, arg_41_1, arg_41_2)
	-- function 41
	if not self then
		return
	end

	local style = self.style

	if not arg_41_2 then
		if not style[arg_41_2].color then
			style[arg_41_2].color[1] = arg_41_1
		elseif not style[arg_41_2].text_color then
			style[arg_41_2].text_color[1] = arg_41_1
		end
	else
		for k, v in pairs(style) do
			if not v.color then
				v.color[1] = arg_41_1
			elseif not v.text_color then
				v.text_color[1] = arg_41_1
			end
		end
	end
end
