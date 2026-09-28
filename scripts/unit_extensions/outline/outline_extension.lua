-- chunkname: @scripts/unit_extensions/outline/outline_extension.lua

require("scripts/settings/outline_settings")

OutlineExtension = class(OutlineExtension)

OutlineExtension.init = function (self, outline_system, unit)
	-- function 1
	self._unique_id = 0
	self._default_settings = nil
	self._unit = unit
	self.outlined = false
	self.reapply = false
	self.flag = nil
	self.apply_method = nil
	self.outline_color = nil
	self.distance = nil
	self.method = nil
	self.outline_settings = {}
	self._outline_system = outline_system
end

OutlineExtension.add_outline = function (self, settings)
	-- function 2
	local unique_id = self._unique_id
	local settings = table.clone(settings)

	self._unique_id = self._unique_id + 1

	if unique_id == 0 then
		self._default_settings = settings
	end

	settings._unique_id = unique_id

	local priority_2 = settings.priority

	priority_2 = not not priority_2 or not not 0
	settings.priority = priority_2

	local settings_bucket = self.outline_settings
	local num_settings_buckets = #settings_bucket
	local insert_index = num_settings_buckets + 1
	local priority = settings.priority

	for i = 1, num_settings_buckets do
		local current_bucket = settings_bucket[i][1]

		if priority >= current_bucket.priority then
			insert_index = i

			break
		end
	end

	if settings_bucket[insert_index] then
		local shared_priority_settings = settings_bucket[insert_index]

		table.insert(shared_priority_settings, 1, settings)
	else
		settings_bucket[insert_index] = {
			settings
		}
	end

	if insert_index == 1 then
		self:_refresh_current_outline()
	end

	return unique_id
end

OutlineExtension.remove_outline = function (self, unique_id)
	-- function 3
	if not unique_id or unique_id < 0 then
		return
	end

	local settings_bucket = self.outline_settings

	for bucket_id = 1, #settings_bucket do
		local current_bucket = settings_bucket[bucket_id]

		for setting_id = 1, #current_bucket do
			if current_bucket[setting_id]._unique_id == unique_id then
				table.remove(current_bucket, setting_id)

				if #current_bucket == 0 then
					table.remove(settings_bucket, bucket_id)
				end

				if bucket_id == 1 and setting_id == 1 then
					self:_refresh_current_outline()
				end

				return
			end
		end
	end
end

OutlineExtension.update_outline = function (self, settings, unique_id)
	-- function 4
	if not unique_id or unique_id < 0 then
		return
	end

	local settings_bucket = self.outline_settings

	for bucket_id = 1, #settings_bucket do
		local current_bucket = settings_bucket[bucket_id]

		for setting_id = 1, #current_bucket do
			local bucket_settings = current_bucket[setting_id]

			if bucket_settings._unique_id == unique_id then
				table.merge(bucket_settings, settings)

				settings._unique_id = unique_id

				if bucket_id == 1 and setting_id == 1 then
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

OutlineExtension._refresh_current_outline = function (self, reapply)
	-- function 6
	local default = self._default_settings
	local current_settings = self.outline_settings[1][1]
	local new_color = not current_settings.outline_color or self.outline_color ~= current_settings.outline_color
	local outline_color

	if current_settings.outline_color then
		outline_color = current_settings.outline_color

		if not outline_color then
			-- Nothing
		end
	end

	outline_color = default.outline_color

	::label_6_0::

	self.outline_color = outline_color

	local distance

	if current_settings.distance then
		distance = current_settings.distance

		if not distance then
			-- Nothing
		end
	end

	distance = default.distance

	::label_6_1::

	self.distance = distance

	local method

	if current_settings.method then
		method = current_settings.method

		if not method then
			-- Nothing
		end
	end

	method = default.method

	::label_6_2::

	self.method = method
	self.prev_flag = self.flag

	local flag

	if current_settings.flag then
		flag = current_settings.flag

		if not flag then
			-- Nothing
		end
	end

	flag = default.flag

	::label_6_3::

	self.flag = flag

	if not reapply then
		-- Nothing
	end

	::label_6_4::

	local outlined = self.outlined

	outlined = not not outlined and not not new_color

	::label_6_5::

	self.reapply = outlined

	if self.reapply or new_color then
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

OutlineExtension.swap_delete_outline = function (self, new_id, old_id)
	-- function 9
	local settings_bucket = self.outline_settings
	local to_bucket_id, to_setting_id, from_bucket_id, from_setting_id

	for bucket_id = 1, #settings_bucket do
		local current_bucket = settings_bucket[bucket_id]

		for setting_id = 1, #current_bucket do
			if current_bucket[setting_id]._unique_id == new_id then
				from_bucket_id = bucket_id
				from_setting_id = setting_id
			end

			if current_bucket[setting_id]._unique_id == old_id then
				to_bucket_id = bucket_id
				to_setting_id = setting_id
			end
		end
	end

	local new_settings = settings_bucket[from_bucket_id][from_setting_id]

	new_settings._unique_id = old_id
	settings_bucket[to_bucket_id][to_setting_id] = new_settings

	table.remove(settings_bucket[from_bucket_id], from_setting_id)

	if #settings_bucket[from_bucket_id] == 0 then
		table.remove(settings_bucket, from_bucket_id)
	end

	self._default_settings = new_settings

	self:update_outline(new_settings, old_id)
end
