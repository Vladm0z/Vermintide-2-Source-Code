-- chunkname: @scripts/utils/debug_list_picker.lua

DebugListPicker = class(DebugListPicker)

local num = 22
local str = "arial"
local str_2 = "materials/fonts/" .. str
local num_2 = 22
local num_3 = 10
local num_4 = 20

DebugListPicker.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.pick_list = arg_1_1
	self.save_data_name = arg_1_2
	self._item_validation_func = arg_1_3 or function ()
		-- function 2
		return true
	end
	self.column_index, self.row_index = 1, 1
	self.move_cursor_timer = 0
	self.gui = Debug.gui
	self.font_mtrl = str_2
	self.font = str
	self.font_size = num

	self:setup(arg_1_2)

	self.column = self.pick_list[self.column_index]

	local var_1_0 = self.column[self.row_index]

	var_1_0 = var_1_0 or "?"
	self.item = var_1_0
	self.max_cols_seen = 3
end

DebugListPicker.destroy = function (arg_3_0)
	-- function 3
	return
end

DebugListPicker.setup = function (self)
	-- function 4
	local var_4_0 = SaveData[self.save_data_name]

	var_4_0 = type(var_4_0) ~= "table" or not var_4_0 or {
		last_column_index = 1,
		columns = {}
	}
	self.save_data = var_4_0

	local columns = var_4_0.columns
	local last_column_index

	if not columns[var_4_0.last_column_index] then
		last_column_index = var_4_0.last_column_index

		if not last_column_index then
			-- Nothing
		end
	end

	last_column_index = 1

	::label_4_0::

	self.column_index = last_column_index

	local row_index

	if not columns[self.column_index] then
		row_index = columns[self.column_index].row_index

		if not row_index then
			-- Nothing
		end
	end

	row_index = 1

	::label_4_1::

	self.row_index = row_index

	local var_4_4
	local num = 0
	local num_2 = 0
	local pick_list = self.pick_list
	local num_3 = 0
	local column_index

	if not pick_list[self.column_index] then
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

	if not self.column[self.row_index] then
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
		local var_4_11 = pick_list[i]
		local row_index_3

		if not columns[i] then
			row_index_3 = columns[i].row_index

			if not row_index_3 then
				-- Nothing
			end
		end

		row_index_3 = 1

		::label_4_4::

		var_4_11.last_row_index = row_index_3

		local count = #var_4_11

		if num_3 < count then
			num_3 = count
		end

		for j = 1, count do
			local str = var_4_11[j][1] .. "(Load)"
			local text_extents, var_4_16 = Gui.text_extents(self.gui, str:upper(), self.font_mtrl, self.font_size)
			local num_4 = var_4_16.x - text_extents.x
			local num_5 = var_4_16.y - text_extents.y

			if num < num_4 then
				num = num_4
			end

			if num_2 < num_5 then
				num_2 = num_5
			end
		end
	end

	self.max_height = num_2
	self.max_width = num + 40
	self.max_rows = num_3 + 1
end

DebugListPicker.activate = function (self)
	-- function 5
	self.active = not self.active

	DebugScreen.set_blocked(self.active)

	if self.active or not self.save_data_name then
		local pick_list = self.pick_list
		local save_data = self.save_data
		local columns = save_data.columns

		columns = columns or {}
		save_data.columns = columns
		save_data.last_column_index = self.column_index

		for i = 1, #pick_list do
			local var_5_3 = pick_list[i]
			local var_5_4 = columns[i]

			var_5_4 = var_5_4 or {}
			columns[i] = var_5_4
			columns[i].row_index = var_5_3.last_row_index
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

DebugListPicker._sort_column = function (self, arg_8_1)
	-- function 8
	local _item_validation_func = self._item_validation_func

	table.sort(arg_8_1, function (self, arg_9_1)
		-- function 9
		local flag = not not _item_validation_func(self[1])

		if flag == not not _item_validation_func(arg_9_1[1]) then
			return self[1] < arg_9_1[1]
		elseif not flag then
			return true
		end

		return false
	end)
end

DebugListPicker.update = function (self, arg_10_1, arg_10_2)
	-- function 10
	if not self.active then
		return
	end

	local time_since_launch = Application.time_since_launch()
	local pick_list = self.pick_list
	local column = self.column
	local item = self.item
	local row_index = self.row_index

	if not DebugKeyHandler.key_pressed("right_key", "switch spawn category", "ai") then
		self.column_index = self.column_index + 1
		self.column_index = (self.column_index - 1) % #pick_list + 1
		self.column = self.pick_list[self.column_index]

		local clamp = math.clamp
		local last_row_index = self.column.last_row_index

		last_row_index = last_row_index or self.row_index
		self.row_index = clamp(last_row_index, 1, #self.column)
	end

	if not DebugKeyHandler.key_pressed("left_key", "switch spawn category", "ai") then
		self.column_index = self.column_index - 1
		self.column_index = (self.column_index - 1) % #pick_list + 1
		self.column = self.pick_list[self.column_index]

		local clamp_2 = math.clamp
		local last_row_index_2 = self.column.last_row_index

		last_row_index_2 = last_row_index_2 or self.row_index
		self.row_index = clamp_2(last_row_index_2, 1, #self.column)
	end

	if not (not DebugKeyHandler.key_pressed("up_key", "switch spawn category", "ai") and not (time_since_launch > self.move_cursor_timer)) then
		self.row_index = self.row_index - 1
		self.row_index = (self.row_index - 1) % #column + 1
		self.move_cursor_timer = time_since_launch + 0.1
		column.last_row_index = self.row_index
	end

	if not (not DebugKeyHandler.key_pressed("down_key", "switch spawn category", "ai") and not (time_since_launch > self.move_cursor_timer)) then
		self.row_index = self.row_index + 1
		self.row_index = (self.row_index - 1) % #column + 1
		self.move_cursor_timer = time_since_launch + 0.1
		column.last_row_index = self.row_index
	end

	local flag = row_index == self.row_index

	self.item = self.column[self.row_index]

	if not script_data.disable_debug_draw then
		local item_2 = self.item
		local column_2 = self.column
		local column_index = self.column_index
		local count = #self.pick_list
		local num = column_index - 1
		local num_5 = column_index + 1

		if column_index == 1 then
			num = 1
			num_5 = num + (self.max_cols_seen - 1)
		elseif column_index == count then
			num = count - (self.max_cols_seen - 1)
			num_5 = count
		end

		local res_w = RESOLUTION_LOOKUP.res_w
		local res_h = RESOLUTION_LOOKUP.res_h
		local num_6 = 0.85
		local num_7 = self.font_size * (num_4 + 1) + num_3
		local str = ""
		local var_10_21
		local var_10_22 = Color(200, 100, 0)
		local var_10_23 = Color(255, 155, 0)
		local var_10_24 = Vector3(5, res_h - 80 - num_2, 900)
		local copy = Vector3.copy(var_10_24)
		local var_10_26

		for i = num, num_5 do
			local var_10_27 = pick_list[i]

			if column_2 == var_10_27 then
				var_10_26 = column_2
				str = string.upper(var_10_27.name)
				var_10_21 = var_10_23
			else
				str = var_10_27.name
				var_10_21 = var_10_22
			end

			Gui.text(self.gui, str, self.font_mtrl, self.font_size, self.font, copy, var_10_21)

			local text_extents, var_10_29 = Gui.text_extents(self.gui, str, self.font_mtrl, self.font_size)
			local num_8 = var_10_29.x - text_extents.x + num_3

			copy.x = copy.x + num_8
		end

		if not var_10_26.column_run_func then
			var_10_26.column_run_func(self, item_2, copy)
		end

		self:_sort_column(column_2)

		if not (not flag and not self.item and not self._last_selected_item and self.item == self._last_selected_item) then
			local find_func = table.find_func(column_2, function (arg_11_0, arg_11_1)
				-- function 11
				return type(arg_11_1) ~= "table" or arg_11_1[1] == self._last_selected_item[1]
			end)

			if not find_func then
				self.row_index = find_func
			end
		else
			self._last_selected_item = self.item
		end

		local clamp_3 = math.clamp(self.row_index - num_4 + 1, 1, #column_2)
		local num_9 = math.min(#column_2, num_4) + (clamp_3 - 1)

		for j = clamp_3, num_9 do
			local num_10 = var_10_24 - Vector3(0, (j - clamp_3 + 1) * num_2, 0)
			local var_10_35 = column_2[j][1]

			if not var_10_26.row_func then
				var_10_35 = var_10_35 .. var_10_26.row_func(self, column_2[j])
			end

			local _item_validation_func = self._item_validation_func(var_10_35)

			if not _item_validation_func then
				var_10_35 = var_10_35 .. " (Load)"
			end

			if j == self.row_index then
				local text = Gui.text
				local gui = self.gui
				local str_2 = " > " .. var_10_35:upper()
				local font_mtrl = self.font_mtrl
				local font_size = self.font_size
				local font = self.font
				local var_10_43 = num_10
				local var_10_44

				if not _item_validation_func then
					var_10_44 = Color(200, 200, 200)

					if not var_10_44 then
						-- Nothing
					end
				end

				var_10_44 = Color(100, 50, 200, 0)

				::label_10_0::

				text(gui, str_2, font_mtrl, font_size, font, var_10_43, var_10_44)
			else
				local text_2 = Gui.text
				local gui_2 = self.gui
				local str_3 = "     " .. var_10_35
				local font_mtrl_2 = self.font_mtrl
				local font_size_2 = self.font_size
				local font_2 = self.font
				local var_10_51 = num_10
				local var_10_52

				if not _item_validation_func then
					var_10_52 = Color(50, 200, 0)

					if not var_10_52 then
						-- Nothing
					end
				end

				var_10_52 = Color(100, 50, 200, 0)

				::label_10_1::

				text_2(gui_2, str_3, font_mtrl_2, font_size_2, font_2, var_10_51, var_10_52)
			end
		end

		Gui.rect(self.gui, Vector3(5, res_h - num_7 - 80, 899), Vector3(self.max_width, num_7, 899), Color(230 * num_6, 10, 10, 10))
	end
end
