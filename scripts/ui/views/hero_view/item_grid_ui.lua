-- chunkname: @scripts/ui/views/hero_view/item_grid_ui.lua

ItemGridUI = class(InventoryGridUI)

local function fn(arg_1_0, arg_1_1)
	-- function 1
	for k, v in pairs(arg_1_0) do
		if arg_1_1 == v.name then
			return k
		end
	end
end

ItemGridUI.init = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	self._platform = PLATFORM
	self._category_settings = arg_2_1
	self._widget = arg_2_2

	self:_append_widget_content(arg_2_2, arg_2_5)

	if arg_2_4 > #PROFILES_BY_NAME[arg_2_3].careers then
		arg_2_4 = 1
	end

	self._hero_name = arg_2_3
	self._career_index = arg_2_4
	self._params = arg_2_5
	self._locked_items = {}
end

ItemGridUI._append_widget_content = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	local content = arg_3_1.content

	content.profile_index = not arg_3_2 and arg_3_2.profile_index
	content.career_index = not arg_3_2 and arg_3_2.career_index
end

ItemGridUI.change_category = function (self, arg_4_1, arg_4_2)
	-- function 4
	self:clear_item_grid()

	for i, v in ipairs(self._category_settings) do
		if v.name == arg_4_1 then
			self:_on_category_index_change(i, arg_4_2)

			return
		end
	end
end

ItemGridUI.set_item_page = function (self, arg_5_1)
	-- function 5
	local _total_item_pages = self._total_item_pages

	if not (_total_item_pages < arg_5_1 or not (arg_5_1 < 1)) then
		return
	end

	local _widget = self._widget
	local slots = _widget.content.slots
	local num = (arg_5_1 - 1) * slots + 1
	local _items = self._items

	self:_populate_inventory_page(_items, num)

	_widget.content.page_text = arg_5_1 .. "/" .. _total_item_pages
	self._selected_page_index = arg_5_1
end

ItemGridUI.items = function (self)
	-- function 6
	return self._items
end

ItemGridUI.get_page_info = function (self)
	-- function 7
	return self._selected_page_index, self._total_item_pages
end

ItemGridUI.get_equipped_items = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	local slots = InventorySettings.slots
	local tbl = {}
	local name = SPProfiles[FindProfileIndex(arg_8_1)].careers[arg_8_2].name

	for k, v in pairs(slots) do
		local name_2 = v.name
		local get_loadout_item = BackendUtils.get_loadout_item(name, name_2)

		if not get_loadout_item then
			tbl[get_loadout_item.backend_id] = get_loadout_item
		end
	end

	return tbl
end

ItemGridUI.get_equipped_weapon_pose_parent = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	local name = SPProfiles[FindProfileIndex(arg_9_1)].careers[arg_9_2].name
	local get_loadout_item = BackendUtils.get_loadout_item(name, "slot_pose")

	if not get_loadout_item then
		return
	end

	local parent = get_loadout_item.data.parent

	return (Managers.backend:get_interface("items"):get_item_from_key(parent))
end

ItemGridUI.apply_item_sorting_function = function (self, arg_10_1)
	-- function 10
	self._item_sort_func = arg_10_1
end

ItemGridUI.set_locked_items_icon = function (self, arg_11_1)
	-- function 11
	self._locked_item_icon = arg_11_1

	self:update_items_status()
end

ItemGridUI.disable_locked_items = function (self, arg_12_1)
	-- function 12
	self._disable_locked_items = arg_12_1

	self:mark_locked_items(self._mark_locked_items)
end

ItemGridUI.lock_item_by_id = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	arg_13_0._locked_items[arg_13_1] = arg_13_2
end

ItemGridUI.clear_locked_items = function (self)
	-- function 14
	self._locked_items = {}
end

ItemGridUI.hide_slots = function (self, arg_15_1)
	-- function 15
	self._hide_slots = arg_15_1

	self:update_items_status()
end

ItemGridUI.mark_locked_items = function (self, arg_16_1)
	-- function 16
	self._mark_locked_items = arg_16_1

	self:update_items_status()
end

ItemGridUI.disable_unwieldable_items = function (self, arg_17_1)
	-- function 17
	self._disable_unwieldable_items = arg_17_1
end

ItemGridUI.disable_equipped_items = function (self, arg_18_1)
	-- function 18
	self._disable_equipped_items = arg_18_1

	self:mark_equipped_items(self._mark_equipped_items)
end

ItemGridUI.mark_equipped_items = function (self, arg_19_1)
	-- function 19
	self._mark_equipped_items = arg_19_1

	self:update_items_status()
end

ItemGridUI.mark_equipped_weapon_pose_parent = function (self, arg_20_1)
	-- function 20
	self._mark_equipped_weapon_pose_parent = arg_20_1

	self:update_items_status()
end

ItemGridUI.disable_item_drag = function (self)
	-- function 21
	self._item_drag_disabled = true

	self:update_items_status()
end

ItemGridUI.update_items_status = function (self)
	-- function 22
	local _hero_name = self._hero_name
	local var_22_1 = FindProfileIndex(_hero_name)
	local _career_index = self._career_index
	local name = SPProfiles[var_22_1].careers[_career_index].name
	local _locked_item_icon = self._locked_item_icon
	local _mark_locked_items = self._mark_locked_items

	_mark_locked_items = not _mark_locked_items and self._locked_items

	local _mark_equipped_items = self._mark_equipped_items

	_mark_equipped_items = not _mark_equipped_items and self:get_equipped_items(_hero_name, _career_index)

	local _mark_equipped_weapon_pose_parent = self._mark_equipped_weapon_pose_parent

	_mark_equipped_weapon_pose_parent = not _mark_equipped_weapon_pose_parent and self:get_equipped_weapon_pose_parent(_hero_name, _career_index)

	local _item_drag_disabled = self._item_drag_disabled
	local _hide_slots = self._hide_slots
	local _disable_locked_items = self._disable_locked_items
	local _disable_equipped_items = self._disable_equipped_items
	local _disable_unwieldable_items = self._disable_unwieldable_items
	local _widget = self._widget
	local content = _widget.content
	local style = _widget.style
	local rows = content.rows
	local columns = content.columns

	for i = 1, rows do
		for j = 1, columns do
			local str = "_" .. tostring(i) .. "_" .. tostring(j)
			local str_2 = "item_icon" .. str
			local str_3 = "locked_icon" .. str
			local var_22_21 = content["hotspot" .. str]
			local var_22_22 = style[str_2]
			local var_22_23 = content["item" .. str]
			local flag = not var_22_23 and var_22_23.data
			local flag_2 = not flag and flag.key
			local flag_3 = not var_22_23 and var_22_23.backend_id
			local flag_4 = not flag_3 and not _mark_equipped_items and _mark_equipped_items[flag_3] ~= nil

			flag_4 = not flag_2 and not _mark_equipped_weapon_pose_parent and _mark_equipped_weapon_pose_parent.data.key == flag_2 or flag_4

			local flag_5 = not flag_3 and not _mark_locked_items and _mark_locked_items[flag_3] ~= nil
			local flag_6 = not flag and flag.can_wield
			local flag_7 = not flag_6 and table.contains(flag_6, name)

			var_22_21[str_3] = _locked_item_icon

			if _mark_equipped_items or not _mark_equipped_weapon_pose_parent then
				var_22_21.equipped = flag_4
			else
				var_22_21.equipped = false
			end

			if not _mark_locked_items then
				var_22_21.reserved = flag_5
			else
				var_22_21.reserved = false
			end

			local flag_8 = false
			local var_22_32 = _item_drag_disabled
			local flag_9 = false

			if not flag_5 then
				flag_9 = true

				if not _disable_locked_items then
					var_22_32 = true
					flag_8 = true
				end
			end

			if flag_7 or not _disable_unwieldable_items then
				flag_9 = true
				var_22_21.unwieldable = true
			else
				var_22_21.unwieldable = false
			end

			if not _mark_equipped_items and not flag_4 and not _disable_equipped_items then
				var_22_32 = true
				flag_8 = true
			end

			if not var_22_23 then
				flag_8 = true
			end

			var_22_21.disable_button = flag_8
			var_22_21.drag_disabled = var_22_32
			var_22_21.hide_slot = _hide_slots
			var_22_22.saturated = flag_9
		end
	end

	local get_interface = Managers.backend:get_interface("items")

	if not self._selected_item and not get_interface:get_item_from_id(self._selected_item.backend_id) then
		self:set_item_selected(self._selected_item)
	end
end

ItemGridUI.has_item = function (self, arg_23_1)
	-- function 23
	local _items = self._items

	if not _items then
		for i, v in ipairs(_items) do
			local backend_id = v.backend_id

			if arg_23_1.backend_id == backend_id then
				return true
			end
		end
	end

	return false
end

ItemGridUI.set_item_selected = function (self, arg_24_1)
	-- function 24
	self._selected_item = arg_24_1

	local content = self._widget.content
	local rows = content.rows
	local columns = content.columns

	self._selected_item_row = nil
	self._selected_item_column = nil
	self._selected_item_equipped = nil

	for i = 1, rows do
		for j = 1, columns do
			local str = "_" .. tostring(i) .. "_" .. tostring(j)
			local var_24_4 = content["hotspot" .. str]
			local var_24_5 = content["item" .. str]
			local flag = not arg_24_1 and not var_24_5 and arg_24_1.backend_id == var_24_5.backend_id
			local equipped = var_24_4.equipped

			var_24_4.is_selected = flag

			if not flag then
				self._selected_item_row = i
				self._selected_item_column = j
				self._selected_item_equipped = equipped
			end
		end
	end
end

ItemGridUI.is_item_wieldable = function (self, arg_25_1)
	-- function 25
	local content = self._widget.content
	local rows = content.rows
	local columns = content.columns

	for i = 1, rows do
		for j = 1, columns do
			local str = "_" .. tostring(i) .. "_" .. tostring(j)
			local var_25_4 = content["hotspot" .. str]
			local var_25_5 = content["item" .. str]

			if not (not arg_25_1 and not var_25_5 and arg_25_1.backend_id ~= var_25_5.backend_id) then
				local equipped = var_25_4.equipped
				local disable_button = var_25_4.disable_button
				local unwieldable = var_25_4.unwieldable
				local reserved = var_25_4.reserved

				if not (equipped or disable_button or unwieldable or reserved) then
					return true
				end

				return false
			end
		end
	end

	return false
end

ItemGridUI.handle_favorite_marking = function (self, arg_26_1)
	-- function 26
	if not arg_26_1 and not arg_26_1:has("hotkey_mark_favorite_item") and not arg_26_1:get("hotkey_mark_favorite_item") then
		local var_26_0

		if not Managers.input:is_device_active("gamepad") then
			var_26_0 = self:selected_item()
		else
			var_26_0 = self:get_item_hovered()
		end

		local flag = not var_26_0 and var_26_0.backend_id

		print("item", var_26_0, flag)

		if not flag then
			if not ItemHelper.is_favorite_backend_id(flag, var_26_0) then
				ItemHelper.unmark_backend_id_as_favorite(flag, var_26_0)

				return true
			else
				ItemHelper.mark_backend_id_as_favorite(flag, var_26_0)

				return true
			end
		end
	end
end

ItemGridUI.handle_gamepad_selection = function (self, arg_27_1)
	-- function 27
	if not self._selected_item then
		return
	end

	local content = self._widget.content
	local rows = content.rows
	local columns = content.columns
	local _selected_item_row = self._selected_item_row
	local _selected_item_column = self._selected_item_column

	if not _selected_item_row and not _selected_item_column then
		local flag = false

		if not (_selected_item_column > 1) or not arg_27_1:get("move_left_hold_continuous") then
			_selected_item_column = _selected_item_column - 1
			flag = true
		elseif not (_selected_item_column < columns) or not arg_27_1:get("move_right_hold_continuous") then
			_selected_item_column = _selected_item_column + 1
			flag = true
		end

		if not (_selected_item_row > 1) or not arg_27_1:get("move_up_hold_continuous") then
			_selected_item_row = _selected_item_row - 1
			flag = true
		elseif not (_selected_item_row < rows) or not arg_27_1:get("move_down_hold_continuous") then
			_selected_item_row = _selected_item_row + 1
			flag = true
		end

		if not flag then
			local str = "_" .. tostring(_selected_item_row) .. "_" .. tostring(_selected_item_column)
			local var_27_7 = content["hotspot" .. str]
			local var_27_8 = content["item" .. str]

			if not var_27_8 then
				self:set_item_selected(var_27_8)

				return true
			end
		end
	end
end

ItemGridUI.get_item_in_slot = function (self, arg_28_1, arg_28_2)
	-- function 28
	local content = self._widget.content
	local rows = content.rows
	local columns = content.columns

	for i = 1, rows do
		if i == arg_28_1 then
			for j = 1, columns do
				if j == arg_28_2 then
					local str = "_" .. tostring(i) .. "_" .. tostring(j)

					return content["item" .. str]
				end
			end
		end
	end
end

ItemGridUI.set_backend_id_selected = function (self, arg_29_1)
	-- function 29
	local get_interface = Managers.backend:get_interface("items")
	local flag = not arg_29_1 and get_interface:get_item_from_id(arg_29_1)

	self:set_item_selected(flag)
end

ItemGridUI.selected_item = function (self)
	-- function 30
	return self._selected_item, self._selected_item_equipped
end

ItemGridUI.add_item_to_slot_index = function (self, arg_31_1, arg_31_2, arg_31_3)
	-- function 31
	local _widget = self._widget
	local content = _widget.content
	local style = _widget.style
	local rows = content.rows
	local columns = content.columns
	local num = math.floor((arg_31_1 - 1) / columns) + 1
	local num_2 = (arg_31_1 - 1) % columns + 1
	local str = "_" .. tostring(num) .. "_" .. tostring(num_2)
	local str_2 = "item_icon" .. str
	local str_3 = "amount_text" .. str
	local str_4 = "locked_icon" .. str
	local var_31_11 = content["hotspot" .. str]
	local var_31_12 = style[str_2]
	local flag = not arg_31_2 and arg_31_2.backend_id

	content["item" .. str] = arg_31_2
	var_31_11.item = arg_31_2

	if not arg_31_2 then
		local data = arg_31_2.data
		local get_interface = Managers.backend:get_interface("items")
		local rarity = data.rarity

		if not flag then
			rarity = get_interface:get_item_rarity(flag)
		end

		local get_ui_information_from_item, var_31_18, var_31_19 = UIUtils.get_ui_information_from_item(arg_31_2)
		local str_5 = "rarity_texture" .. str

		if not style[str_5] then
			content[str_5] = UISettings.item_rarity_textures[rarity]
		end

		local var_31_21

		if not flag then
			var_31_21 = arg_31_3 or get_interface:get_item_amount(flag)
		elseif not arg_31_2.amount then
			var_31_21 = arg_31_2.amount
		end

		if not var_31_21 then
			local var_31_22
			local var_31_23
			local var_31_24
			local num_3

			if not arg_31_2.insufficient_amount then
				var_31_22 = 255
				var_31_23 = 0
				num_3 = 0
			else
				local default_color = style[str_3].default_color

				var_31_22 = default_color[2]
				var_31_23 = default_color[3]
				num_3 = default_color[4]
			end

			local text_color = style[str_3].text_color

			self:_set_color_values(text_color, var_31_22, var_31_23, num_3)
		else
			var_31_21 = ""
		end

		content["item_tooltip" .. str] = var_31_18
		var_31_11[str_2] = get_ui_information_from_item
		var_31_11[str_3] = not data.can_stack and var_31_21 and ""
		var_31_11[str_4] = self._locked_item_icon

		if not flag then
			var_31_11.reserved = true
			var_31_11.equipped = false
			var_31_12.saturated = false
			var_31_11.disable_button = false
		else
			var_31_11.reserved = false
			var_31_12.saturated = false
			var_31_11.disable_button = false
		end

		var_31_11.fake_item = flag == nil
	else
		var_31_11.disable_button = true
		var_31_11[str_2] = nil
		var_31_11[str_3] = ""
	end

	if not self._mark_locked_items then
		self:mark_locked_items(true)
	end
end

ItemGridUI._set_color_values = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
	-- function 32
	arg_32_1[2] = arg_32_2
	arg_32_1[3] = arg_32_3
	arg_32_1[4] = arg_32_4
end

ItemGridUI.repopulate_current_inventory_page = function (self)
	-- function 33
	local _widget = self._widget
	local content = _widget.content
	local _items = self._items
	local _selected_page_index = self._selected_page_index
	local _total_item_pages = self._total_item_pages
	local slots = content.slots
	local num = (_selected_page_index - 1) * slots + 1

	self:_populate_inventory_page(_items, num)

	_widget.content.page_text = _selected_page_index .. "/" .. _total_item_pages
	self._selected_page_index = _selected_page_index
end

ItemGridUI._populate_inventory_page = function (self, arg_34_1, arg_34_2)
	-- function 34
	local _widget = self._widget
	local content = _widget.content
	local style = _widget.style
	local rows = content.rows
	local columns = content.columns
	local var_34_5 = arg_34_2

	for i = 1, rows do
		for j = 1, columns do
			local str = "_" .. tostring(i) .. "_" .. tostring(j)
			local str_2 = "item_icon" .. str
			local str_3 = "amount_text" .. str
			local str_4 = "locked_icon" .. str
			local var_34_10 = content["hotspot" .. str]
			local var_34_11 = style[str_2]
			local var_34_12 = arg_34_1[var_34_5]
			local flag = not var_34_12 and var_34_12.backend_id

			content["item" .. str] = not flag and var_34_12
			var_34_10.item = not flag and var_34_12

			if not var_34_12 then
				local data = var_34_12.data
				local rarity = data.rarity
				local get_interface = Managers.backend:get_interface("items")

				if not flag then
					rarity = get_interface:get_item_rarity(flag)
				end

				local get_ui_information_from_item, var_34_18, var_34_19 = UIUtils.get_ui_information_from_item(var_34_12)
				local str_5 = "rarity_texture" .. str

				if not style[str_5] then
					content[str_5] = UISettings.item_rarity_textures[rarity]
				end

				local var_34_21

				if not flag then
					var_34_21 = get_interface:get_item_amount(flag)
				elseif not var_34_12.amount then
					var_34_21 = var_34_12.amount
				end

				if not var_34_21 then
					local var_34_22
					local var_34_23
					local var_34_24
					local num

					if not var_34_12.insufficient_amount then
						var_34_22 = 255
						var_34_23 = 0
						num = 0
					else
						local default_color = style[str_3].default_color

						var_34_22 = default_color[2]
						var_34_23 = default_color[3]
						num = default_color[4]
					end

					local text_color = style[str_3].text_color

					self:_set_color_values(text_color, var_34_22, var_34_23, num)
				else
					var_34_21 = ""
				end

				content["item_tooltip" .. str] = var_34_18
				var_34_10[str_2] = get_ui_information_from_item
				var_34_10[str_3] = not data.can_stack and var_34_21 and ""
				var_34_10[str_4] = self._locked_item_icon

				if not flag then
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
				var_34_10[str_2] = nil
				var_34_10[str_3] = ""
			end
		end
	end

	if not self._mark_equipped_items then
		self:mark_equipped_items(true)
	end

	if not self._mark_locked_items then
		self:mark_locked_items(true)
	end

	local get_interface_2 = Managers.backend:get_interface("items")

	if not self._selected_item and not get_interface_2:get_item_from_id(self._selected_item.backend_id) then
		self:set_item_selected(self._selected_item)
	end
end

ItemGridUI.clear_item_grid = function (self)
	-- function 35
	local _widget = self._widget
	local content = _widget.content
	local style = _widget.style
	local rows = content.rows
	local columns = content.columns

	for i = 1, rows do
		for j = 1, columns do
			local str = "_" .. tostring(i) .. "_" .. tostring(j)
			local str_2 = "item_icon" .. str
			local str_3 = "amount_text" .. str
			local var_35_8 = content["hotspot" .. str]
			local var_35_9 = style[str_2]

			content["item" .. str] = nil
			var_35_8.item = nil
			var_35_8[str_2] = nil
			var_35_8[str_3] = ""
			var_35_8.equipped = false
			var_35_8.drag_disabled = false
			var_35_8.disable_button = true
			var_35_9.saturated = false
		end
	end
end

ItemGridUI._on_category_index_change = function (self, arg_36_1, arg_36_2)
	-- function 36
	local var_36_0 = self._category_settings[arg_36_1]
	local display_name = var_36_0.display_name
	local item_filter = var_36_0.item_filter
	local slot_type = var_36_0.slot_type
	local hero_specific_filter = var_36_0.hero_specific_filter
	local career_specific_filter = var_36_0.career_specific_filter

	if not hero_specific_filter then
		local str

		if not item_filter then
			str = "and " .. item_filter

			if not str then
				-- Nothing
			end
		end

		str = ""

		::label_36_0::

		item_filter = "can_wield_by_current_hero " .. str
	end

	if not var_36_0.wield then
		self:disable_unwieldable_items(true)
	end

	local _selected_page_index = self._selected_page_index

	_selected_page_index = _selected_page_index or 1

	self:change_item_filter(item_filter, not arg_36_2)

	self._widget.content.title_text = display_name

	if not arg_36_2 then
		local min = math.min(_selected_page_index, self._total_item_pages)

		self:set_item_page(min)
	end
end

local tbl = {}

ItemGridUI._apply_search_query = function (arg_37_0, arg_37_1, arg_37_2)
	-- function 37
	local lower = Utf8.lower(arg_37_2)

	table.clear(tbl)

	for i = 1, #arg_37_1 do
		local var_37_1 = arg_37_1[i]
		local data = var_37_1.data
		local lower_2 = Utf8.lower(Localize(data.item_type))
		local get_ui_information_from_item, var_37_5 = UIUtils.get_ui_information_from_item(var_37_1)
		local lower_3 = Utf8.lower(Localize(var_37_5))

		if not lower_2:find(lower) then
			tbl[#tbl + 1] = var_37_1
		elseif not lower_3:find(lower) then
			tbl[#tbl + 1] = var_37_1
		end
	end

	local var_37_7 = tbl

	return tbl
end

ItemGridUI.change_item_filter = function (self, arg_38_1, arg_38_2, arg_38_3)
	-- function 38
	arg_38_1 = "available_in_current_mechanism and ( " .. arg_38_1 .. " )"

	local _get_items_by_filter = self:_get_items_by_filter("can_wield_by_current_career and ( " .. arg_38_1 .. " )")
	local _get_items_by_filter_2 = self:_get_items_by_filter("not can_wield_by_current_career and ( " .. arg_38_1 .. " )")
	local _item_sort_func = self._item_sort_func

	if not _item_sort_func then
		self:_sort_items(_get_items_by_filter, _item_sort_func)
		self:_sort_items(_get_items_by_filter_2, _item_sort_func)
	end

	local var_38_3 = _get_items_by_filter

	for k, v in pairs(_get_items_by_filter_2) do
		var_38_3[#var_38_3 + 1] = v
	end

	if not arg_38_3 then
		var_38_3 = self:_apply_search_query(var_38_3, arg_38_3)
	end

	self._items = var_38_3

	local slots = self._widget.content.slots
	local count = #var_38_3

	self._total_item_pages = math.max(math.ceil(count / slots), 1)

	if not arg_38_2 then
		local num = 1

		self:set_item_page(num)
	end
end

ItemGridUI._sort_items = function (arg_39_0, arg_39_1, arg_39_2)
	-- function 39
	if not (not arg_39_2 and not (#arg_39_1 > 1)) then
		table.sort(arg_39_1, arg_39_2)
	end
end

ItemGridUI._get_items_by_filter = function (self, arg_40_1)
	-- function 40
	return (Managers.backend:get_interface("items"):get_filtered_items(arg_40_1, self._params))
end

ItemGridUI._get_slot_by_ui_index = function (arg_41_0, arg_41_1)
	-- function 41
	local slots = InventorySettings.slots

	for k, v in pairs(slots) do
		if arg_41_1 == v.ui_slot_index then
			return v
		end
	end
end

ItemGridUI._handle_page_arrow_pressed = function (self)
	-- function 42
	local _selected_page_index = self._selected_page_index

	_selected_page_index = _selected_page_index or 0

	local _total_item_pages = self._total_item_pages
	local flag = _total_item_pages == 0
	local content = self._widget.content
	local page_hotspot_left = content.page_hotspot_left
	local page_hotspot_right = content.page_hotspot_right

	if not (page_hotspot_left or page_hotspot_right) then
		return
	end

	page_hotspot_left.disable_button = flag or _selected_page_index <= 1
	page_hotspot_right.disable_button = flag or _selected_page_index == _total_item_pages

	if not (not self._selected_page_index and self._total_item_pages) then
		return
	end

	local var_42_6

	if not page_hotspot_left and not page_hotspot_left.on_release then
		var_42_6 = math.max(_selected_page_index - 1, 1)
	elseif not page_hotspot_right and not page_hotspot_right.on_release then
		var_42_6 = math.min(_selected_page_index + 1, _total_item_pages)
	end

	if not (not var_42_6 and var_42_6 == _selected_page_index) then
		self:set_item_page(var_42_6)

		return true
	end
end

ItemGridUI.is_item_pressed = function (self, arg_43_1)
	-- function 43
	local content = self._widget.content
	local rows = content.rows
	local columns = content.columns
	local _disable_locked_items = self._disable_locked_items
	local _disable_unwieldable_items = self._disable_unwieldable_items

	for i = 1, rows do
		for j = 1, columns do
			local str = "_" .. tostring(i) .. "_" .. tostring(j)
			local var_43_6 = content["hotspot" .. str]
			local flag = not _disable_locked_items and var_43_6.reserved
			local flag_2 = not _disable_unwieldable_items and var_43_6.unwieldable

			if flag or flag_2 or var_43_6.on_double_click or var_43_6.on_right_click or not arg_43_1 or not var_43_6.on_pressed then
				local var_43_9 = content["item" .. str]
				local equipped = var_43_6.equipped

				return var_43_9, equipped
			end
		end
	end
end

ItemGridUI.is_item_hovered = function (self)
	-- function 44
	local content = self._widget.content
	local rows = content.rows
	local columns = content.columns

	for i = 1, rows do
		for j = 1, columns do
			local str = "_" .. tostring(i) .. "_" .. tostring(j)

			if not content["hotspot" .. str].on_hover_enter then
				return content["item" .. str]
			end
		end
	end
end

ItemGridUI.get_item_hovered = function (self)
	-- function 45
	local content = self._widget.content
	local rows = content.rows
	local columns = content.columns

	for i = 1, rows do
		for j = 1, columns do
			local str = "_" .. tostring(i) .. "_" .. tostring(j)
			local var_45_4 = content["hotspot" .. str]

			if not var_45_4.internal_is_hover then
				local var_45_5 = content["item" .. str]
				local equipped = var_45_4.equipped

				return var_45_5, equipped
			end
		end
	end
end

ItemGridUI.get_item_hovered_slot = function (self)
	-- function 46
	local content = self._widget.content
	local rows = content.rows
	local columns = content.columns

	for i = 1, rows do
		for j = 1, columns do
			local str = "_" .. tostring(i) .. "_" .. tostring(j)

			if not content["hotspot" .. str].internal_is_hover then
				return i, j
			end
		end
	end
end

ItemGridUI.get_item_content = function (self, arg_47_1, arg_47_2)
	-- function 47
	local content = self._widget.content
	local str = "_" .. tostring(arg_47_1) .. "_" .. tostring(arg_47_2)

	return content["hotspot" .. str]
end

ItemGridUI.is_slot_hovered = function (self)
	-- function 48
	local content = self._widget.content
	local rows = content.rows
	local columns = content.columns

	for i = 1, rows do
		for j = 1, columns do
			local str = "_" .. tostring(i) .. "_" .. tostring(j)

			if not content["hotspot" .. str].internal_is_hover then
				return (i - 1) * rows + j
			end
		end
	end
end

ItemGridUI.highlight_slots = function (self, arg_49_1, arg_49_2)
	-- function 49
	local _widget = self._widget
	local content = _widget.content
	local style = _widget.style
	local rows = content.rows
	local columns = content.columns

	for i = 1, rows do
		for j = 1, columns do
			local str = "_" .. tostring(i) .. "_" .. tostring(j)
			local str_2 = "hotspot" .. str
			local str_3 = "slot_hover" .. str

			content[str_2].highlight = arg_49_1

			local color = style[str_3].color
			local flag

			flag = not arg_49_1 and arg_49_2 and 255 and 255
			color[1] = flag
		end
	end
end

ItemGridUI.highlight_drop_slots = function (self, arg_50_1)
	-- function 50
	local _widget = self._widget
	local content = _widget.content
	local style = _widget.style
	local rows = content.rows
	local columns = content.columns

	for i = 1, rows do
		for j = 1, columns do
			local str = "_" .. tostring(i) .. "_" .. tostring(j)
			local str_2 = "hotspot" .. str
			local str_3 = "item_icon" .. str
			local str_4 = "slot_hover" .. str
			local var_50_9 = content[str_2]

			var_50_9.highlight = arg_50_1

			local flag

			flag = not var_50_9.internal_is_hover and 255 and 100
			style[str_4].color[1] = not arg_50_1 and flag and 255
		end
	end
end

ItemGridUI.is_item_dragged = function (self)
	-- function 51
	local content = self._widget.content
	local rows = content.rows
	local columns = content.columns
	local var_51_3
	local var_51_4

	for i = 1, rows do
		for j = 1, columns do
			local str = "_" .. tostring(i) .. "_" .. tostring(j)
			local str_2 = "hotspot" .. str
			local str_3 = "item_icon" .. str
			local var_51_8 = content[str_2]

			if not var_51_8[str_3] and not var_51_8.on_drag_stopped then
				var_51_3 = content["item" .. str]

				break
			end
		end
	end

	return var_51_3
end

ItemGridUI.is_dragging_item = function (self)
	-- function 52
	local content = self._widget.content
	local rows = content.rows
	local columns = content.columns
	local var_52_3

	for i = 1, rows do
		for j = 1, columns do
			local str = "_" .. tostring(i) .. "_" .. tostring(j)
			local str_2 = "hotspot" .. str
			local str_3 = "item_icon" .. str
			local var_52_7 = content[str_2]

			if not var_52_7[str_3] and not var_52_7.is_dragging then
				var_52_3 = content["item" .. str]

				break
			end
		end
	end

	return var_52_3
end

ItemGridUI.update = function (self, arg_53_1, arg_53_2)
	-- function 53
	local _handle_page_arrow_pressed = self:_handle_page_arrow_pressed()
end

ItemGridUI.destroy = function (arg_54_0)
	-- function 54
	return
end

ItemGridUI.get_selected_item_grid_slot = function (self)
	-- function 55
	return self._selected_item_row, self._selected_item_column
end
