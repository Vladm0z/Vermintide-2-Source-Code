-- chunkname: @scripts/unit_extensions/outline/outline_extension.lua

require("scripts/settings/outline_settings")

OutlineExtension = class(OutlineExtension)

OutlineExtension.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._unique_id = 0
	self._default_settings = nil
	self._unit = arg_1_2
	self.outlined = false
	self.reapply = false
	self.flag = nil
	self.apply_method = nil
	self.outline_color = nil
	self.distance = nil
	self.method = nil
	self.outline_settings = {}
	self._outline_system = arg_1_1
end

OutlineExtension.add_outline = function (self, arg_2_1)
	-- function 2
	local _unique_id = self._unique_id
	local clone = table.clone(arg_2_1)

	self._unique_id = self._unique_id + 1

	if _unique_id == 0 then
		self._default_settings = clone
	end

	clone._unique_id = _unique_id

	local priority = clone.priority

	priority = priority or 0
	clone.priority = priority

	local outline_settings = self.outline_settings
	local count = #outline_settings
	local num = count + 1
	local priority_2 = clone.priority

	for i = 1, count do
		if priority_2 >= outline_settings[i][1].priority then
			num = i

			break
		end
	end

	if not outline_settings[num] then
		local var_2_7 = outline_settings[num]

		table.insert(var_2_7, 1, clone)
	else
		outline_settings[num] = {
			clone
		}
	end

	if num == 1 then
		self:_refresh_current_outline()
	end

	return _unique_id
end

OutlineExtension.remove_outline = function (self, arg_3_1)
	-- function 3
	if not (not arg_3_1 and not (arg_3_1 < 0)) then
		return
	end

	local outline_settings = self.outline_settings

	for i = 1, #outline_settings do
		local var_3_1 = outline_settings[i]

		for j = 1, #var_3_1 do
			if var_3_1[j]._unique_id == arg_3_1 then
				table.remove(var_3_1, j)

				if #var_3_1 == 0 then
					table.remove(outline_settings, i)
				end

				if not (i ~= 1 or j ~= 1) then
					self:_refresh_current_outline()
				end

				return
			end
		end
	end
end

OutlineExtension.update_outline = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not (not arg_4_2 and not (arg_4_2 < 0)) then
		return
	end

	local outline_settings = self.outline_settings

	for i = 1, #outline_settings do
		local var_4_1 = outline_settings[i]

		for j = 1, #var_4_1 do
			local var_4_2 = var_4_1[j]

			if var_4_2._unique_id == arg_4_2 then
				table.merge(var_4_2, arg_4_1)

				arg_4_1._unique_id = arg_4_2

				if not (i ~= 1 or j ~= 1) then
					self:_refresh_current_outline()
				end
			end
		end
	end
end

OutlineExtension.reapply_outline = function (self)
	-- function 5
	self.reapply = true

	self._outline_system:mark_outline_dirty(self._unit)
end

OutlineExtension._refresh_current_outline = function (self, arg_6_1)
	-- function 6
	local _default_settings = self._default_settings
	local var_6_1 = self.outline_settings[1][1]
	local flag = not var_6_1.outline_color and self.outline_color ~= var_6_1.outline_color
	local outline_color

	if not var_6_1.outline_color then
		outline_color = var_6_1.outline_color

		if not outline_color then
			-- Nothing
		end
	end

	outline_color = _default_settings.outline_color

	::label_6_0::

	self.outline_color = outline_color

	local distance

	if not var_6_1.distance then
		distance = var_6_1.distance

		if not distance then
			-- Nothing
		end
	end

	distance = _default_settings.distance

	::label_6_1::

	self.distance = distance

	local method

	if not var_6_1.method then
		method = var_6_1.method

		if not method then
			-- Nothing
		end
	end

	method = _default_settings.method

	::label_6_2::

	self.method = method
	self.prev_flag = self.flag

	local flag_2

	if not var_6_1.flag then
		flag_2 = var_6_1.flag

		if not flag_2 then
			-- Nothing
		end
	end

	flag_2 = _default_settings.flag

	::label_6_3::

	self.flag = flag_2

	if not arg_6_1 then
		-- Nothing
	end

	::label_6_4::

	local outlined = self.outlined

	outlined = not outlined and flag

	::label_6_5::

	self.reapply = outlined

	if self.reapply or not flag then
		self._outline_system:mark_outline_dirty(self._unit)
	end
end

OutlineExtension.on_freeze = function (self)
	-- function 7
	self.method = "never"

	table.clear(self.outline_settings)

	self.outline_settings[1] = {
		self._default_settings
	}
end

OutlineExtension.on_unfreeze = function (self)
	-- function 8
	self:_refresh_current_outline()
end

OutlineExtension.swap_delete_outline = function (self, arg_9_1, arg_9_2)
	-- function 9
	local outline_settings = self.outline_settings
	local var_9_1
	local var_9_2
	local var_9_3
	local var_9_4

	for i = 1, #outline_settings do
		local var_9_5 = outline_settings[i]

		for j = 1, #var_9_5 do
			if var_9_5[j]._unique_id == arg_9_1 then
				var_9_3 = i
				var_9_4 = j
			end

			if var_9_5[j]._unique_id == arg_9_2 then
				var_9_1 = i
				var_9_2 = j
			end
		end
	end

	local var_9_6 = outline_settings[var_9_3][var_9_4]

	var_9_6._unique_id = arg_9_2
	outline_settings[var_9_1][var_9_2] = var_9_6

	table.remove(outline_settings[var_9_3], var_9_4)

	if #outline_settings[var_9_3] == 0 then
		table.remove(outline_settings, var_9_3)
	end

	self._default_settings = var_9_6

	self:update_outline(var_9_6, arg_9_2)
end
