-- chunkname: @scripts/ui/views/hero_view/item_grid_ui.lua

ItemGridUI = class(InventoryGridUI)

local function var_0_0(arg_1_0, arg_1_1)
	for iter_1_0, iter_1_1 in pairs(arg_1_0) do
		if arg_1_1 == iter_1_1.name then
			return iter_1_0
		end
	end
end

function ItemGridUI.init(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	arg_2_0._platform = PLATFORM
	arg_2_0._category_settings = arg_2_1
	arg_2_0._widget = arg_2_2

	arg_2_0:_append_widget_content(arg_2_2, arg_2_5)

	if arg_2_4 > #PROFILES_BY_NAME[arg_2_3].careers then
		arg_2_4 = 1
	end

	arg_2_0._hero_name = arg_2_3
	arg_2_0._career_index = arg_2_4
	arg_2_0._params = arg_2_5
	arg_2_0._locked_items = {}
end

function ItemGridUI._append_widget_content(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_1.content

	var_3_0.profile_index = arg_3_2 and arg_3_2.profile_index
	var_3_0.career_index = arg_3_2 and arg_3_2.career_index
end

function ItemGridUI.change_category(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:clear_item_grid()

	for iter_4_0, iter_4_1 in ipairs(arg_4_0._category_settings) do
		if iter_4_1.name == arg_4_1 then
			arg_4_0:_on_category_index_change(iter_4_0, arg_4_2)

			return
		end
	end
end

function ItemGridUI.set_item_page(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0._total_item_pages

	if var_5_0 < arg_5_1 or arg_5_1 < 1 then
		return
	end

	local var_5_1 = arg_5_0._widget
	local var_5_2 = var_5_1.content.slots
	local var_5_3 = (arg_5_1 - 1) * var_5_2 + 1
	local var_5_4 = arg_5_0._items

	arg_5_0:_populate_inventory_page(var_5_4, var_5_3)

	var_5_1.content.page_text = arg_5_1 .. "/" .. var_5_0
	arg_5_0._selected_page_index = arg_5_1
end

function ItemGridUI.items(arg_6_0)
	return arg_6_0._items
end

function ItemGridUI.get_page_info(arg_7_0)
	return arg_7_0._selected_page_index, arg_7_0._total_item_pages
end

function ItemGridUI.get_equipped_items(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = InventorySettings.slots
	local var_8_1 = {}
	local var_8_2 = SPProfiles[FindProfileIndex(arg_8_1)].careers[arg_8_2].name

	for iter_8_0, iter_8_1 in pairs(var_8_0) do
		local var_8_3 = iter_8_1.name
		local var_8_4 = BackendUtils.get_loadout_item(var_8_2, var_8_3)

		if var_8_4 then
			var_8_1[var_8_4.backend_id] = var_8_4
		end
	end

	return var_8_1
end

function ItemGridUI.get_equipped_weapon_pose_parent(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = SPProfiles[FindProfileIndex(arg_9_1)].careers[arg_9_2].name
	local var_9_1 = BackendUtils.get_loadout_item(var_9_0, "slot_pose")

	if not var_9_1 then
		return
	end

	local var_9_2 = var_9_1.data.parent

	return (Managers.backend:get_interface("items"):get_item_from_key(var_9_2))
end

function ItemGridUI.apply_item_sorting_function(arg_10_0, arg_10_1)
	arg_10_0._item_sort_func = arg_10_1
end

function ItemGridUI.set_locked_items_icon(arg_11_0, arg_11_1)
	arg_11_0._locked_item_icon = arg_11_1

	arg_11_0:update_items_status()
end

function ItemGridUI.disable_locked_items(arg_12_0, arg_12_1)
	arg_12_0._disable_locked_items = arg_12_1

	arg_12_0:mark_locked_items(arg_12_0._mark_locked_items)
end

function ItemGridUI.lock_item_by_id(arg_13_0, arg_13_1, arg_13_2)
	arg_13_0._locked_items[arg_13_1] = arg_13_2
end

function ItemGridUI.clear_locked_items(arg_14_0)
	arg_14_0._locked_items = {}
end

function ItemGridUI.hide_slots(arg_15_0, arg_15_1)
	arg_15_0._hide_slots = arg_15_1

	arg_15_0:update_items_status()
end

function ItemGridUI.mark_locked_items(arg_16_0, arg_16_1)
	arg_16_0._mark_locked_items = arg_16_1

	arg_16_0:update_items_status()
end

function ItemGridUI.disable_unwieldable_items(arg_17_0, arg_17_1)
	arg_17_0._disable_unwieldable_items = arg_17_1
end

function ItemGridUI.disable_equipped_items(arg_18_0, arg_18_1)
	arg_18_0._disable_equipped_items = arg_18_1

	arg_18_0:mark_equipped_items(arg_18_0._mark_equipped_items)
end

function ItemGridUI.mark_equipped_items(arg_19_0, arg_19_1)
	arg_19_0._mark_equipped_items = arg_19_1

	arg_19_0:update_items_status()
end

function ItemGridUI.mark_equipped_weapon_pose_parent(arg_20_0, arg_20_1)
	arg_20_0._mark_equipped_weapon_pose_parent = arg_20_1

	arg_20_0:update_items_status()
end

function ItemGridUI.disable_item_drag(arg_21_0)
	arg_21_0._item_drag_disabled = true

	arg_21_0:update_items_status()
end

function ItemGridUI.update_items_status(arg_22_0)
	local var_22_0 = arg_22_0._hero_name
	local var_22_1 = FindProfileIndex(var_22_0)
	local var_22_2 = arg_22_0._career_index
	local var_22_3 = SPProfiles[var_22_1].careers[var_22_2].name
	local var_22_4 = arg_22_0._locked_item_icon
	local var_22_5 = arg_22_0._mark_locked_items and arg_22_0._locked_items
	local var_22_6 = arg_22_0._mark_equipped_items and arg_22_0:get_equipped_items(var_22_0, var_22_2)
	local var_22_7 = arg_22_0._mark_equipped_weapon_pose_parent and arg_22_0:get_equipped_weapon_pose_parent(var_22_0, var_22_2)
	local var_22_8 = arg_22_0._item_drag_disabled
	local var_22_9 = arg_22_0._hide_slots
	local var_22_10 = arg_22_0._disable_locked_items
	local var_22_11 = arg_22_0._disable_equipped_items
	local var_22_12 = arg_22_0._disable_unwieldable_items
	local var_22_13 = arg_22_0._widget
	local var_22_14 = var_22_13.content
	local var_22_15 = var_22_13.style
	local var_22_16 = var_22_14.rows
	local var_22_17 = var_22_14.columns

	for iter_22_0 = 1, var_22_16 do
		for iter_22_1 = 1, var_22_17 do
			local var_22_18 = "_" .. tostring(iter_22_0) .. "_" .. tostring(iter_22_1)
			local var_22_19 = "item_icon" .. var_22_18
			local var_22_20 = "locked_icon" .. var_22_18
			local var_22_21 = var_22_14["hotspot" .. var_22_18]
			local var_22_22 = var_22_15[var_22_19]
			local var_22_23 = var_22_14["item" .. var_22_18]
			local var_22_24 = var_22_23 and var_22_23.data
			local var_22_25 = var_22_24 and var_22_24.key
			local var_22_26 = var_22_23 and var_22_23.backend_id
			local var_22_27 = var_22_26 and var_22_6 and var_22_6[var_22_26] ~= nil

			var_22_27 = var_22_25 and var_22_7 and var_22_7.data.key == var_22_25 or var_22_27

			local var_22_28 = var_22_26 and var_22_5 and var_22_5[var_22_26] ~= nil
			local var_22_29 = var_22_24 and var_22_24.can_wield
			local var_22_30 = var_22_29 and table.contains(var_22_29, var_22_3)

			var_22_21[var_22_20] = var_22_4

			if var_22_6 or var_22_7 then
				var_22_21.equipped = var_22_27
			else
				var_22_21.equipped = false
			end

			if var_22_5 then
				var_22_21.reserved = var_22_28
			else
				var_22_21.reserved = false
			end

			local var_22_31 = false
			local var_22_32 = var_22_8
			local var_22_33 = false

			if var_22_28 then
				var_22_33 = true

				if var_22_10 then
					var_22_32 = true
					var_22_31 = true
				end
			end

			if not var_22_30 and var_22_12 then
				var_22_33 = true
				var_22_21.unwieldable = true
			else
				var_22_21.unwieldable = false
			end

			if var_22_6 and var_22_27 and var_22_11 then
				var_22_32 = true
				var_22_31 = true
			end

			if not var_22_23 then
				var_22_31 = true
			end

			var_22_21.disable_button = var_22_31
			var_22_21.drag_disabled = var_22_32
			var_22_21.hide_slot = var_22_9
			var_22_22.saturated = var_22_33
		end
	end

	local var_22_34 = Managers.backend:get_interface("items")

	if arg_22_0._selected_item and var_22_34:get_item_from_id(arg_22_0._selected_item.backend_id) then
		arg_22_0:set_item_selected(arg_22_0._selected_item)
	end
end

function ItemGridUI.has_item(arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0._items

	if var_23_0 then
		for iter_23_0, iter_23_1 in ipairs(var_23_0) do
			local var_23_1 = iter_23_1.backend_id

			if arg_23_1.backend_id == var_23_1 then
				return true
			end
		end
	end

	return false
end

function ItemGridUI.set_item_selected(arg_24_0, arg_24_1)
	arg_24_0._selected_item = arg_24_1

	local var_24_0 = arg_24_0._widget.content
	local var_24_1 = var_24_0.rows
	local var_24_2 = var_24_0.columns

	arg_24_0._selected_item_row = nil
	arg_24_0._selected_item_column = nil
	arg_24_0._selected_item_equipped = nil

	for iter_24_0 = 1, var_24_1 do
		for iter_24_1 = 1, var_24_2 do
			local var_24_3 = "_" .. tostring(iter_24_0) .. "_" .. tostring(iter_24_1)
			local var_24_4 = var_24_0["hotspot" .. var_24_3]
			local var_24_5 = var_24_0["item" .. var_24_3]
			local var_24_6 = arg_24_1 and var_24_5 and arg_24_1.backend_id == var_24_5.backend_id
			local var_24_7 = var_24_4.equipped

			var_24_4.is_selected = var_24_6

			if var_24_6 then
				arg_24_0._selected_item_row = iter_24_0
				arg_24_0._selected_item_column = iter_24_1
				arg_24_0._selected_item_equipped = var_24_7
			end
		end
	end
end

function ItemGridUI.is_item_wieldable(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0._widget.content
	local var_25_1 = var_25_0.rows
	local var_25_2 = var_25_0.columns

	for iter_25_0 = 1, var_25_1 do
		for iter_25_1 = 1, var_25_2 do
			local var_25_3 = "_" .. tostring(iter_25_0) .. "_" .. tostring(iter_25_1)
			local var_25_4 = var_25_0["hotspot" .. var_25_3]
			local var_25_5 = var_25_0["item" .. var_25_3]

			if arg_25_1 and var_25_5 and arg_25_1.backend_id == var_25_5.backend_id then
				local var_25_6 = var_25_4.equipped
				local var_25_7 = var_25_4.disable_button
				local var_25_8 = var_25_4.unwieldable
				local var_25_9 = var_25_4.reserved

				if not var_25_6 and not var_25_7 and not var_25_8 and not var_25_9 then
					return true
				end

				return false
			end
		end
	end

	return false
end

function ItemGridUI.handle_favorite_marking(arg_26_0, arg_26_1)
	if arg_26_1 and arg_26_1:has("hotkey_mark_favorite_item") and arg_26_1:get("hotkey_mark_favorite_item") then
		local var_26_0

		if Managers.input:is_device_active("gamepad") then
			var_26_0 = arg_26_0:selected_item()
		else
			var_26_0 = arg_26_0:get_item_hovered()
		end

		local var_26_1 = var_26_0 and var_26_0.backend_id

		print("item", var_26_0, var_26_1)

		if var_26_1 then
			if ItemHelper.is_favorite_backend_id(var_26_1, var_26_0) then
				ItemHelper.unmark_backend_id_as_favorite(var_26_1, var_26_0)

				return true
			else
				ItemHelper.mark_backend_id_as_favorite(var_26_1, var_26_0)

				return true
			end
		end
	end
end

function ItemGridUI.handle_gamepad_selection(arg_27_0, arg_27_1)
	if not arg_27_0._selected_item then
		return
	end

	local var_27_0 = arg_27_0._widget.content
	local var_27_1 = var_27_0.rows
	local var_27_2 = var_27_0.columns
	local var_27_3 = arg_27_0._selected_item_row
	local var_27_4 = arg_27_0._selected_item_column

	if var_27_3 and var_27_4 then
		local var_27_5 = false

		if var_27_4 > 1 and arg_27_1:get("move_left_hold_continuous") then
			var_27_4 = var_27_4 - 1
			var_27_5 = true
		elseif var_27_4 < var_27_2 and arg_27_1:get("move_right_hold_continuous") then
			var_27_4 = var_27_4 + 1
			var_27_5 = true
		end

		if var_27_3 > 1 and arg_27_1:get("move_up_hold_continuous") then
			var_27_3 = var_27_3 - 1
			var_27_5 = true
		elseif var_27_3 < var_27_1 and arg_27_1:get("move_down_hold_continuous") then
			var_27_3 = var_27_3 + 1
			var_27_5 = true
		end

		if var_27_5 then
			local var_27_6 = "_" .. tostring(var_27_3) .. "_" .. tostring(var_27_4)
			local var_27_7 = var_27_0["hotspot" .. var_27_6]
			local var_27_8 = var_27_0["item" .. var_27_6]

			if var_27_8 then
				arg_27_0:set_item_selected(var_27_8)

				return true
			end
		end
	end
end

function ItemGridUI.get_item_in_slot(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_0._widget.content
	local var_28_1 = var_28_0.rows
	local var_28_2 = var_28_0.columns

	for iter_28_0 = 1, var_28_1 do
		if iter_28_0 == arg_28_1 then
			for iter_28_1 = 1, var_28_2 do
				if iter_28_1 == arg_28_2 then
					local var_28_3 = "_" .. tostring(iter_28_0) .. "_" .. tostring(iter_28_1)

					return var_28_0["item" .. var_28_3]
				end
			end
		end
	end
end

function ItemGridUI.set_backend_id_selected(arg_29_0, arg_29_1)
	local var_29_0 = Managers.backend:get_interface("items")
	local var_29_1 = arg_29_1 and var_29_0:get_item_from_id(arg_29_1)

	arg_29_0:set_item_selected(var_29_1)
end

function ItemGridUI.selected_item(arg_30_0)
	return arg_30_0._selected_item, arg_30_0._selected_item_equipped
end

function ItemGridUI.add_item_to_slot_index(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	local var_31_0 = arg_31_0._widget
	local var_31_1 = var_31_0.content
	local var_31_2 = var_31_0.style
	local var_31_3 = var_31_1.rows
	local var_31_4 = var_31_1.columns
	local var_31_5 = math.floor((arg_31_1 - 1) / var_31_4) + 1
	local var_31_6 = (arg_31_1 - 1) % var_31_4 + 1
	local var_31_7 = "_" .. tostring(var_31_5) .. "_" .. tostring(var_31_6)
	local var_31_8 = "item_icon" .. var_31_7
	local var_31_9 = "amount_text" .. var_31_7
	local var_31_10 = "locked_icon" .. var_31_7
	local var_31_11 = var_31_1["hotspot" .. var_31_7]
	local var_31_12 = var_31_2[var_31_8]
	local var_31_13 = arg_31_2 and arg_31_2.backend_id

	var_31_1["item" .. var_31_7] = arg_31_2

	if arg_31_2 then
		local var_31_14 = arg_31_2.data
		local var_31_15 = Managers.backend:get_interface("items")
		local var_31_16 = var_31_14.rarity

		if var_31_13 then
			var_31_16 = var_31_15:get_item_rarity(var_31_13)
		end

		local var_31_17, var_31_18, var_31_19 = UIUtils.get_ui_information_from_item(arg_31_2)
		local var_31_20 = "rarity_texture" .. var_31_7

		if var_31_2[var_31_20] then
			var_31_1[var_31_20] = UISettings.item_rarity_textures[var_31_16]
		end

		local var_31_21

		if var_31_13 then
			var_31_21 = arg_31_3 or var_31_15:get_item_amount(var_31_13)
		elseif arg_31_2.amount then
			var_31_21 = arg_31_2.amount
		end

		if var_31_21 then
			local var_31_22
			local var_31_23
			local var_31_24
			local var_31_25

			if arg_31_2.insufficient_amount then
				var_31_22 = 255
				var_31_23 = 0
				var_31_25 = 0
			else
				local var_31_26 = var_31_2[var_31_9].default_color

				var_31_22 = var_31_26[2]
				var_31_23 = var_31_26[3]
				var_31_25 = var_31_26[4]
			end

			local var_31_27 = var_31_2[var_31_9].text_color

			arg_31_0:_set_color_values(var_31_27, var_31_22, var_31_23, var_31_25)
		else
			var_31_21 = ""
		end

		var_31_1["item_tooltip" .. var_31_7] = var_31_18
		var_31_11[var_31_8] = var_31_17
		var_31_11[var_31_9] = var_31_14.can_stack and var_31_21 or ""
		var_31_11[var_31_10] = arg_31_0._locked_item_icon

		if not var_31_13 then
			var_31_11.reserved = true
			var_31_11.equipped = false
			var_31_12.saturated = false
			var_31_11.disable_button = false
		else
			var_31_11.reserved = false
			var_31_12.saturated = false
			var_31_11.disable_button = false
		end

		var_31_11.fake_item = var_31_13 == nil
	else
		var_31_11.disable_button = true
		var_31_11[var_31_8] = nil
		var_31_11[var_31_9] = ""
	end

	if arg_31_0._mark_locked_items then
		arg_31_0:mark_locked_items(true)
	end
end

function ItemGridUI._set_color_values(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
	arg_32_1[2] = arg_32_2
	arg_32_1[3] = arg_32_3
	arg_32_1[4] = arg_32_4
end

function ItemGridUI.repopulate_current_inventory_page(arg_33_0)
	local var_33_0 = arg_33_0._widget
	local var_33_1 = var_33_0.content
	local var_33_2 = arg_33_0._items
	local var_33_3 = arg_33_0._selected_page_index
	local var_33_4 = arg_33_0._total_item_pages
	local var_33_5 = var_33_1.slots
	local var_33_6 = (var_33_3 - 1) * var_33_5 + 1

	arg_33_0:_populate_inventory_page(var_33_2, var_33_6)

	var_33_0.content.page_text = var_33_3 .. "/" .. var_33_4
	arg_33_0._selected_page_index = var_33_3
end

function ItemGridUI._populate_inventory_page(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = arg_34_0._widget
	local var_34_1 = var_34_0.content
	local var_34_2 = var_34_0.style
	local var_34_3 = var_34_1.rows
	local var_34_4 = var_34_1.columns
	local var_34_5 = arg_34_2

	for iter_34_0 = 1, var_34_3 do
		for iter_34_1 = 1, var_34_4 do
			local var_34_6 = "_" .. tostring(iter_34_0) .. "_" .. tostring(iter_34_1)
			local var_34_7 = "item_icon" .. var_34_6
			local var_34_8 = "amount_text" .. var_34_6
			local var_34_9 = "locked_icon" .. var_34_6
			local var_34_10 = var_34_1["hotspot" .. var_34_6]
			local var_34_11 = var_34_2[var_34_7]
			local var_34_12 = arg_34_1[var_34_5]
			local var_34_13 = var_34_12 and var_34_12.backend_id

			var_34_1["item" .. var_34_6] = var_34_13 and var_34_12

			if var_34_12 then
				local var_34_14 = var_34_12.data
				local var_34_15 = var_34_14.rarity
				local var_34_16 = Managers.backend:get_interface("items")

				if var_34_13 then
					var_34_15 = var_34_16:get_item_rarity(var_34_13)
				end

				local var_34_17, var_34_18, var_34_19 = UIUtils.get_ui_information_from_item(var_34_12)
				local var_34_20 = "rarity_texture" .. var_34_6

				if var_34_2[var_34_20] then
					var_34_1[var_34_20] = UISettings.item_rarity_textures[var_34_15]
				end

				local var_34_21

				if var_34_13 then
					var_34_21 = var_34_16:get_item_amount(var_34_13)
				elseif var_34_12.amount then
					var_34_21 = var_34_12.amount
				end

				if var_34_21 then
					local var_34_22
					local var_34_23
					local var_34_24
					local var_34_25

					if var_34_12.insufficient_amount then
						var_34_22 = 255
						var_34_23 = 0
						var_34_25 = 0
					else
						local var_34_26 = var_34_2[var_34_8].default_color

						var_34_22 = var_34_26[2]
						var_34_23 = var_34_26[3]
						var_34_25 = var_34_26[4]
					end

					local var_34_27 = var_34_2[var_34_8].text_color

					arg_34_0:_set_color_values(var_34_27, var_34_22, var_34_23, var_34_25)
				else
					var_34_21 = ""
				end

				var_34_1["item_tooltip" .. var_34_6] = var_34_18
				var_34_10[var_34_7] = var_34_17
				var_34_10[var_34_8] = var_34_14.can_stack and var_34_21 or ""
				var_34_10[var_34_9] = arg_34_0._locked_item_icon

				if not var_34_13 then
					var_34_10.reserved = true
					var_34_10.equipped = false
					var_34_11.saturated = true
					var_34_10.disable_button = true
				else
					var_34_10.reserved = false
					var_34_11.saturated = false
					var_34_10.disable_button = false
				end

				var_34_5 = var_34_5 + 1
			else
				var_34_10[var_34_7] = nil
				var_34_10[var_34_8] = ""
			end
		end
	end

	if arg_34_0._mark_equipped_items then
		arg_34_0:mark_equipped_items(true)
	end

	if arg_34_0._mark_locked_items then
		arg_34_0:mark_locked_items(true)
	end

	local var_34_28 = Managers.backend:get_interface("items")

	if arg_34_0._selected_item and var_34_28:get_item_from_id(arg_34_0._selected_item.backend_id) then
		arg_34_0:set_item_selected(arg_34_0._selected_item)
	end
end

function ItemGridUI.clear_item_grid(arg_35_0)
	local var_35_0 = arg_35_0._widget
	local var_35_1 = var_35_0.content
	local var_35_2 = var_35_0.style
	local var_35_3 = var_35_1.rows
	local var_35_4 = var_35_1.columns

	for iter_35_0 = 1, var_35_3 do
		for iter_35_1 = 1, var_35_4 do
			local var_35_5 = "_" .. tostring(iter_35_0) .. "_" .. tostring(iter_35_1)
			local var_35_6 = "item_icon" .. var_35_5
			local var_35_7 = "amount_text" .. var_35_5
			local var_35_8 = var_35_1["hotspot" .. var_35_5]
			local var_35_9 = var_35_2[var_35_6]

			var_35_1["item" .. var_35_5] = nil
			var_35_8[var_35_6] = nil
			var_35_8[var_35_7] = ""
			var_35_8.equipped = false
			var_35_8.drag_disabled = false
			var_35_8.disable_button = true
			var_35_9.saturated = false
		end
	end
end

function ItemGridUI._on_category_index_change(arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = arg_36_0._category_settings[arg_36_1]
	local var_36_1 = var_36_0.display_name
	local var_36_2 = var_36_0.item_filter
	local var_36_3 = var_36_0.slot_type
	local var_36_4 = var_36_0.hero_specific_filter
	local var_36_5 = var_36_0.career_specific_filter

	if var_36_4 then
		local var_36_6 = var_36_2 and "and " .. var_36_2 or ""

		var_36_2 = "can_wield_by_current_hero " .. var_36_6
	end

	if var_36_0.wield then
		arg_36_0:disable_unwieldable_items(true)
	end

	local var_36_7 = arg_36_0._selected_page_index or 1

	arg_36_0:change_item_filter(var_36_2, not arg_36_2)

	arg_36_0._widget.content.title_text = var_36_1

	if arg_36_2 then
		local var_36_8 = math.min(var_36_7, arg_36_0._total_item_pages)

		arg_36_0:set_item_page(var_36_8)
	end
end

local var_0_1 = {}

function ItemGridUI._apply_search_query(arg_37_0, arg_37_1, arg_37_2)
	local var_37_0 = Utf8.lower(arg_37_2)

	table.clear(var_0_1)

	for iter_37_0 = 1, #arg_37_1 do
		local var_37_1 = arg_37_1[iter_37_0]
		local var_37_2 = var_37_1.data
		local var_37_3 = Utf8.lower(Localize(var_37_2.item_type))
		local var_37_4, var_37_5 = UIUtils.get_ui_information_from_item(var_37_1)
		local var_37_6 = Utf8.lower(Localize(var_37_5))

		if var_37_3:find(var_37_0) then
			var_0_1[#var_0_1 + 1] = var_37_1
		elseif var_37_6:find(var_37_0) then
			var_0_1[#var_0_1 + 1] = var_37_1
		end
	end

	local var_37_7 = var_0_1

	return var_0_1
end

function ItemGridUI.change_item_filter(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	arg_38_1 = "available_in_current_mechanism and ( " .. arg_38_1 .. " )"

	local var_38_0 = arg_38_0:_get_items_by_filter("can_wield_by_current_career and ( " .. arg_38_1 .. " )")
	local var_38_1 = arg_38_0:_get_items_by_filter("not can_wield_by_current_career and ( " .. arg_38_1 .. " )")
	local var_38_2 = arg_38_0._item_sort_func

	if var_38_2 then
		arg_38_0:_sort_items(var_38_0, var_38_2)
		arg_38_0:_sort_items(var_38_1, var_38_2)
	end

	local var_38_3 = var_38_0

	for iter_38_0, iter_38_1 in pairs(var_38_1) do
		var_38_3[#var_38_3 + 1] = iter_38_1
	end

	if arg_38_3 then
		var_38_3 = arg_38_0:_apply_search_query(var_38_3, arg_38_3)
	end

	arg_38_0._items = var_38_3

	local var_38_4 = arg_38_0._widget.content.slots
	local var_38_5 = #var_38_3

	arg_38_0._total_item_pages = math.max(math.ceil(var_38_5 / var_38_4), 1)

	if arg_38_2 then
		local var_38_6 = 1

		arg_38_0:set_item_page(var_38_6)
	end
end

function ItemGridUI._sort_items(arg_39_0, arg_39_1, arg_39_2)
	if arg_39_2 and #arg_39_1 > 1 then
		table.sort(arg_39_1, arg_39_2)
	end
end

function ItemGridUI._get_items_by_filter(arg_40_0, arg_40_1)
	return (Managers.backend:get_interface("items"):get_filtered_items(arg_40_1, arg_40_0._params))
end

function ItemGridUI._get_slot_by_ui_index(arg_41_0, arg_41_1)
	local var_41_0 = InventorySettings.slots

	for iter_41_0, iter_41_1 in pairs(var_41_0) do
		if arg_41_1 == iter_41_1.ui_slot_index then
			return iter_41_1
		end
	end
end

function ItemGridUI._handle_page_arrow_pressed(arg_42_0)
	local var_42_0 = arg_42_0._selected_page_index or 0
	local var_42_1 = arg_42_0._total_item_pages
	local var_42_2 = var_42_1 == 0
	local var_42_3 = arg_42_0._widget.content
	local var_42_4 = var_42_3.page_hotspot_left
	local var_42_5 = var_42_3.page_hotspot_right

	if not var_42_4 and not var_42_5 then
		return
	end

	var_42_4.disable_button = var_42_2 or var_42_0 <= 1
	var_42_5.disable_button = var_42_2 or var_42_0 == var_42_1

	if not arg_42_0._selected_page_index or not arg_42_0._total_item_pages then
		return
	end

	local var_42_6

	if var_42_4 and var_42_4.on_release then
		var_42_6 = math.max(var_42_0 - 1, 1)
	elseif var_42_5 and var_42_5.on_release then
		var_42_6 = math.min(var_42_0 + 1, var_42_1)
	end

	if var_42_6 and var_42_6 ~= var_42_0 then
		arg_42_0:set_item_page(var_42_6)

		return true
	end
end

function ItemGridUI.is_item_pressed(arg_43_0, arg_43_1)
	local var_43_0 = arg_43_0._widget.content
	local var_43_1 = var_43_0.rows
	local var_43_2 = var_43_0.columns
	local var_43_3 = arg_43_0._disable_locked_items
	local var_43_4 = arg_43_0._disable_unwieldable_items

	for iter_43_0 = 1, var_43_1 do
		for iter_43_1 = 1, var_43_2 do
			local var_43_5 = "_" .. tostring(iter_43_0) .. "_" .. tostring(iter_43_1)
			local var_43_6 = var_43_0["hotspot" .. var_43_5]
			local var_43_7 = var_43_3 and var_43_6.reserved
			local var_43_8 = var_43_4 and var_43_6.unwieldable

			if not var_43_7 and not var_43_8 and (var_43_6.on_double_click or var_43_6.on_right_click or arg_43_1 and var_43_6.on_pressed) then
				local var_43_9 = var_43_0["item" .. var_43_5]
				local var_43_10 = var_43_6.equipped

				return var_43_9, var_43_10
			end
		end
	end
end

function ItemGridUI.is_item_hovered(arg_44_0)
	local var_44_0 = arg_44_0._widget.content
	local var_44_1 = var_44_0.rows
	local var_44_2 = var_44_0.columns

	for iter_44_0 = 1, var_44_1 do
		for iter_44_1 = 1, var_44_2 do
			local var_44_3 = "_" .. tostring(iter_44_0) .. "_" .. tostring(iter_44_1)

			if var_44_0["hotspot" .. var_44_3].on_hover_enter then
				return var_44_0["item" .. var_44_3]
			end
		end
	end
end

function ItemGridUI.get_item_hovered(arg_45_0)
	local var_45_0 = arg_45_0._widget.content
	local var_45_1 = var_45_0.rows
	local var_45_2 = var_45_0.columns

	for iter_45_0 = 1, var_45_1 do
		for iter_45_1 = 1, var_45_2 do
			local var_45_3 = "_" .. tostring(iter_45_0) .. "_" .. tostring(iter_45_1)
			local var_45_4 = var_45_0["hotspot" .. var_45_3]

			if var_45_4.internal_is_hover then
				local var_45_5 = var_45_0["item" .. var_45_3]
				local var_45_6 = var_45_4.equipped

				return var_45_5, var_45_6
			end
		end
	end
end

function ItemGridUI.get_item_hovered_slot(arg_46_0)
	local var_46_0 = arg_46_0._widget.content
	local var_46_1 = var_46_0.rows
	local var_46_2 = var_46_0.columns

	for iter_46_0 = 1, var_46_1 do
		for iter_46_1 = 1, var_46_2 do
			local var_46_3 = "_" .. tostring(iter_46_0) .. "_" .. tostring(iter_46_1)

			if var_46_0["hotspot" .. var_46_3].internal_is_hover then
				return iter_46_0, iter_46_1
			end
		end
	end
end

function ItemGridUI.get_item_content(arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = arg_47_0._widget.content
	local var_47_1 = "_" .. tostring(arg_47_1) .. "_" .. tostring(arg_47_2)

	return var_47_0["hotspot" .. var_47_1]
end

function ItemGridUI.is_slot_hovered(arg_48_0)
	local var_48_0 = arg_48_0._widget.content
	local var_48_1 = var_48_0.rows
	local var_48_2 = var_48_0.columns

	for iter_48_0 = 1, var_48_1 do
		for iter_48_1 = 1, var_48_2 do
			local var_48_3 = "_" .. tostring(iter_48_0) .. "_" .. tostring(iter_48_1)

			if var_48_0["hotspot" .. var_48_3].internal_is_hover then
				return (iter_48_0 - 1) * var_48_1 + iter_48_1
			end
		end
	end
end

function ItemGridUI.highlight_slots(arg_49_0, arg_49_1, arg_49_2)
	local var_49_0 = arg_49_0._widget
	local var_49_1 = var_49_0.content
	local var_49_2 = var_49_0.style
	local var_49_3 = var_49_1.rows
	local var_49_4 = var_49_1.columns

	for iter_49_0 = 1, var_49_3 do
		for iter_49_1 = 1, var_49_4 do
			local var_49_5 = "_" .. tostring(iter_49_0) .. "_" .. tostring(iter_49_1)
			local var_49_6 = "hotspot" .. var_49_5
			local var_49_7 = "slot_hover" .. var_49_5

			var_49_1[var_49_6].highlight = arg_49_1
			var_49_2[var_49_7].color[1] = arg_49_1 and (arg_49_2 or 255) or 255
		end
	end
end

function ItemGridUI.highlight_drop_slots(arg_50_0, arg_50_1)
	local var_50_0 = arg_50_0._widget
	local var_50_1 = var_50_0.content
	local var_50_2 = var_50_0.style
	local var_50_3 = var_50_1.rows
	local var_50_4 = var_50_1.columns

	for iter_50_0 = 1, var_50_3 do
		for iter_50_1 = 1, var_50_4 do
			local var_50_5 = "_" .. tostring(iter_50_0) .. "_" .. tostring(iter_50_1)
			local var_50_6 = "hotspot" .. var_50_5
			local var_50_7 = "item_icon" .. var_50_5
			local var_50_8 = "slot_hover" .. var_50_5
			local var_50_9 = var_50_1[var_50_6]

			var_50_9.highlight = arg_50_1

			local var_50_10 = var_50_9.internal_is_hover and 255 or 100

			var_50_2[var_50_8].color[1] = arg_50_1 and var_50_10 or 255
		end
	end
end

function ItemGridUI.is_item_dragged(arg_51_0)
	local var_51_0 = arg_51_0._widget.content
	local var_51_1 = var_51_0.rows
	local var_51_2 = var_51_0.columns
	local var_51_3
	local var_51_4

	for iter_51_0 = 1, var_51_1 do
		for iter_51_1 = 1, var_51_2 do
			local var_51_5 = "_" .. tostring(iter_51_0) .. "_" .. tostring(iter_51_1)
			local var_51_6 = "hotspot" .. var_51_5
			local var_51_7 = "item_icon" .. var_51_5
			local var_51_8 = var_51_0[var_51_6]

			if var_51_8[var_51_7] and var_51_8.on_drag_stopped then
				var_51_3 = var_51_0["item" .. var_51_5]

				break
			end
		end
	end

	return var_51_3
end

function ItemGridUI.is_dragging_item(arg_52_0)
	local var_52_0 = arg_52_0._widget.content
	local var_52_1 = var_52_0.rows
	local var_52_2 = var_52_0.columns
	local var_52_3

	for iter_52_0 = 1, var_52_1 do
		for iter_52_1 = 1, var_52_2 do
			local var_52_4 = "_" .. tostring(iter_52_0) .. "_" .. tostring(iter_52_1)
			local var_52_5 = "hotspot" .. var_52_4
			local var_52_6 = "item_icon" .. var_52_4
			local var_52_7 = var_52_0[var_52_5]

			if var_52_7[var_52_6] and var_52_7.is_dragging then
				var_52_3 = var_52_0["item" .. var_52_4]

				break
			end
		end
	end

	return var_52_3
end

function ItemGridUI.update(arg_53_0, arg_53_1, arg_53_2)
	local var_53_0 = arg_53_0:_handle_page_arrow_pressed()
end

function ItemGridUI.destroy(arg_54_0)
	return
end

function ItemGridUI.get_selected_item_grid_slot(arg_55_0)
	return arg_55_0._selected_item_row, arg_55_0._selected_item_column
end
