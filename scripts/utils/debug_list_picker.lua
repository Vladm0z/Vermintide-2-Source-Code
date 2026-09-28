-- chunkname: @scripts/utils/debug_list_picker.lua

DebugListPicker = class(DebugListPicker)

local font_size = 22
local font = "arial"
local font_mtrl = "materials/fonts/" .. font
local font_height = 22
local COLUMN_SPACING = 10
local max_display_items = 20

DebugListPicker.init = function (self, list, save_data_name, item_validation_func)
	-- function 1
	self.pick_list = list
	self.save_data_name = save_data_name
	self._item_validation_func = not not item_validation_func or not not function ()
		-- function 2
		return true
	end
	self.column_index, self.row_index = 1, 1
	self.move_cursor_timer = 0
	self.gui = Debug.gui
	self.font_mtrl = font_mtrl
	self.font = font
	self.font_size = font_size

	self:setup(save_data_name)

	self.column = self.pick_list[self.column_index]

	local var_1_0 = self.column[self.row_index]

	var_1_0 = not not var_1_0 or not not "?"
	self.item = var_1_0
	self.max_cols_seen = 3
end

DebugListPicker.destroy = function (self)
	-- function 3
	return
end

DebugListPicker.setup = function (self)
	-- function 4
	local save_data = SaveData[self.save_data_name]

	save_data = (type(save_data) ~= "table" or not save_data) and not not {
		last_column_index = 1,
		columns = {}
	}
	self.save_data = save_data

	local columns = save_data.columns
	local last_column_index

	if columns[save_data.last_column_index] then
		last_column_index = save_data.last_column_index

		if not last_column_index then
			-- Nothing
		end
	end

	last_column_index = 1

	::label_4_0::

	self.column_index = last_column_index

	local row_index

	if columns[self.column_index] then
		row_index = columns[self.column_index].row_index

		if not row_index then
			-- Nothing
		end
	end

	row_index = 1

	::label_4_1::

	self.row_index = row_index

	local start_item
	local max_width, max_height = 0, 0
	local pick_list = self.pick_list
	local max_rows = 0
	local column_index

	if pick_list[self.column_index] then
		column_index = self.column_index

		if not column_index then
			-- Nothing
		end
	end

	column_index = 1

	::label_4_2::

	self.column_index = column_index
	self.column = pick_list[self.column_index]

	local row_index_2

	if self.column[self.row_index] then
		row_index_2 = self.row_index

		if not row_index_2 then
			-- Nothing
		end
	end

	row_index_2 = 1

	::label_4_3::

	self.row_index = row_index_2
	self.item = self.column[self.row_index]

	for i = 1, #pick_list do
		local column = pick_list[i]
		local row_index_3

		if columns[i] then
			row_index_3 = columns[i].row_index

			if not row_index_3 then
				-- Nothing
			end
		end

		row_index_3 = 1

		::label_4_4::

		column.last_row_index = row_index_3

		local num_rows = #column

		if max_rows < num_rows then
			max_rows = num_rows
		end

		for j = 1, num_rows do
			local item = column[j]
			local text = item[1] .. "(Load)"
			local min, max = Gui.text_extents(self.gui, text:upper(), self.font_mtrl, self.font_size)
			local width = max.x - min.x
			local height = max.y - min.y

			if max_width < width then
				max_width = width
			end

			if max_height < height then
				max_height = height
			end
		end
	end

	self.max_height = max_height
	self.max_width = max_width + 40
	self.max_rows = max_rows + 1
end

DebugListPicker.activate = function (self)
	-- function 5
	self.active = not self.active

	DebugScreen.set_blocked(self.active)

	if not self.active and self.save_data_name then
		local pick_list = self.pick_list
		local save_data = self.save_data
		local columns_2 = save_data.columns

		if not columns_2 then
			-- Nothing
		end

		columns_2 = {}

		local columns = columns_2

		::label_5_0::

		save_data.columns = columns
		save_data.last_column_index = self.column_index

		for i = 1, #pick_list do
			local column = pick_list[i]
			local var_5_1 = columns[i]

			var_5_1 = not not var_5_1 or not not {}
			columns[i] = var_5_1
			columns[i].row_index = column.last_row_index
		end

		SaveData[self.save_data_name] = save_data

		Managers.save:auto_save(SaveFileName, SaveData)
	end
end

DebugListPicker.current_item = function (self)
	-- function 6
	return self.item
end

DebugListPicker.current_item_name = function (self)
	-- function 7
	return self.item[1]
end

DebugListPicker._sort_column = function (self, column)
	-- function 8
	local valid = self._item_validation_func

	table.sort(column, function (a, b)
		-- function 9
		local a_valid, b_valid = not not valid(a[1]), not not valid(b[1])

		if a_valid == b_valid then
			return a[1] < b[1]
		elseif a_valid then
			return true
		end

		return false
	end)
end

DebugListPicker.update = function (self, t, dt)
	-- function 10
	if not self.active then
		return
	end

	local wall_time = Application.time_since_launch()
	local pick_list = self.pick_list
	local column = self.column
	local item = self.item
	local last_row = self.row_index

	if DebugKeyHandler.key_pressed("right_key", "switch spawn category", "ai") then
		self.column_index = self.column_index + 1
		self.column_index = (self.column_index - 1) % #pick_list + 1
		self.column = self.pick_list[self.column_index]

		local clamp = math.clamp
		local last_row_index = self.column.last_row_index

		last_row_index = not not last_row_index or not not self.row_index
		self.row_index = clamp(last_row_index, 1, #self.column)
	end

	if DebugKeyHandler.key_pressed("left_key", "switch spawn category", "ai") then
		self.column_index = self.column_index - 1
		self.column_index = (self.column_index - 1) % #pick_list + 1
		self.column = self.pick_list[self.column_index]

		local clamp_2 = math.clamp
		local last_row_index_2 = self.column.last_row_index

		last_row_index_2 = not not last_row_index_2 or not not self.row_index
		self.row_index = clamp_2(last_row_index_2, 1, #self.column)
	end

	if DebugKeyHandler.key_pressed("up_key", "switch spawn category", "ai") and wall_time > self.move_cursor_timer then
		self.row_index = self.row_index - 1
		self.row_index = (self.row_index - 1) % #column + 1
		self.move_cursor_timer = wall_time + 0.1
		column.last_row_index = self.row_index
	end

	if DebugKeyHandler.key_pressed("down_key", "switch spawn category", "ai") and wall_time > self.move_cursor_timer then
		self.row_index = self.row_index + 1
		self.row_index = (self.row_index - 1) % #column + 1
		self.move_cursor_timer = wall_time + 0.1
		column.last_row_index = self.row_index
	end

	local same_row = last_row == self.row_index

	self.item = self.column[self.row_index]

	if not script_data.disable_debug_draw then
		local item = self.item
		local column = self.column
		local col_in = self.column_index
		local num_cols = #self.pick_list
		local c1, c2 = col_in - 1, col_in + 1

		if col_in == 1 then
			c1 = 1
			c2 = c1 + (self.max_cols_seen - 1)
		elseif col_in == num_cols then
			c1 = num_cols - (self.max_cols_seen - 1)
			c2 = num_cols
		end

		local res_x, res_y = RESOLUTION_LOOKUP.res_w, RESOLUTION_LOOKUP.res_h
		local opacity = 0.85
		local height = self.font_size * (max_display_items + 1) + COLUMN_SPACING
		local col_text = ""
		local header_color
		local base_header_color = Color(200, 100, 0)
		local selected_header_color = Color(255, 155, 0)
		local upper_pos = Vector3(5, res_y - 80 - font_height, 900)
		local text_position = Vector3.copy(upper_pos)
		local curr_column

		for i = c1, c2 do
			local column_i = pick_list[i]

			if column == column_i then
				curr_column = column
				col_text = string.upper(column_i.name)
				header_color = selected_header_color
			else
				col_text = column_i.name
				header_color = base_header_color
			end

			Gui.text(self.gui, col_text, self.font_mtrl, self.font_size, self.font, text_position, header_color)

			local min_pos, max_pos = Gui.text_extents(self.gui, col_text, self.font_mtrl, self.font_size)
			local text_width = max_pos.x - min_pos.x + COLUMN_SPACING

			text_position.x = text_position.x + text_width
		end

		if curr_column.column_run_func then
			curr_column.column_run_func(self, item, text_position)
		end

		self:_sort_column(column)

		if same_row and self.item and self._last_selected_item and self.item ~= self._last_selected_item then
			local found_i = table.find_func(column, function (_, col)
				-- function 11
				return type(col) == "table" and col[1] == self._last_selected_item[1]
			end)

			if found_i then
				self.row_index = found_i
			end
		else
			self._last_selected_item = self.item
		end

		local start_idx = math.clamp(self.row_index - max_display_items + 1, 1, #column)
		local end_idx = math.min(#column, max_display_items) + (start_idx - 1)

		for i = start_idx, end_idx do
			local item_pos = upper_pos - Vector3(0, (i - start_idx + 1) * font_height, 0)
			local item_text = column[i][1]

			if curr_column.row_func then
				item_text = item_text .. curr_column.row_func(self, column[i])
			end

			local loaded = self._item_validation_func(item_text)

			if not loaded then
				item_text = item_text .. " (Load)"
			end

			if i == self.row_index then
				local text = Gui.text
				local gui = self.gui
				local str = " > " .. item_text:upper()
				local font_mtrl = self.font_mtrl
				local font_size = self.font_size
				local font = self.font
				local var_10_10 = item_pos
				local var_10_11

				if loaded then
					var_10_11 = Color(200, 200, 200)

					if not var_10_11 then
						-- Nothing
					end
				end

				var_10_11 = Color(100, 50, 200, 0)

				::label_10_0::

				text(gui, str, font_mtrl, font_size, font, var_10_10, var_10_11)
			else
				local text_2 = Gui.text
				local gui_2 = self.gui
				local str_2 = "     " .. item_text
				local font_mtrl_2 = self.font_mtrl
				local font_size_2 = self.font_size
				local font_2 = self.font
				local var_10_18 = item_pos
				local var_10_19

				if loaded then
					var_10_19 = Color(50, 200, 0)

					if not var_10_19 then
						-- Nothing
					end
				end

				var_10_19 = Color(100, 50, 200, 0)

				::label_10_1::

				text_2(gui_2, str_2, font_mtrl_2, font_size_2, font_2, var_10_18, var_10_19)
			end
		end

		Gui.rect(self.gui, Vector3(5, res_y - height - 80, 899), Vector3(self.max_width, height, 899), Color(230 * opacity, 10, 10, 10))
	end
end
