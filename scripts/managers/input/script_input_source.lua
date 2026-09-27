-- chunkname: @scripts/managers/input/script_input_source.lua

require("scripts/settings/script_input_settings")

ScriptInputSource = class(ScriptInputSource, InputSource)

ScriptInputSource.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	ScriptInputSource.super.init(self, arg_1_1, arg_1_2)

	self._active = false
end

ScriptInputSource.start = function (self, arg_2_1, arg_2_2)
	-- function 2
	self._input_settings = arg_2_1
	self._input_settings_copy = table.clone(arg_2_1)
	self._input = {}
	self._active = true
	self._active_time = 0
	self._loop = arg_2_2
end

ScriptInputSource.clear = function (self)
	-- function 3
	ScriptInputSource.super.clear(self)

	self._active = false
end

ScriptInputSource.get = function (self, arg_4_1)
	-- function 4
	fassert(self.mapping_table, "Trying to access unmapped input source.")

	local var_4_0 = self.mapping_table[arg_4_1]

	fassert(var_4_0, "No input description for %q", arg_4_1)

	local var_4_1 = self.controllers[var_4_0.controller_type]

	fassert(var_4_1, "No controller of type %q", var_4_0.controller_type)
	fassert(var_4_0.func, "No input_desc.func")

	local var_4_2

	if not self._active then
		var_4_2 = self._input[arg_4_1]

		if not var_4_2 then
			-- Nothing
		end
	end

	var_4_2 = ScriptInputSource.super.get(self, arg_4_1)

	::label_4_0::

	return var_4_2
end

ScriptInputSource.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not self._active then
		self:_update_input(arg_5_1, arg_5_2)
	end
end

ScriptInputSource._update_input = function (self, arg_6_1, arg_6_2)
	-- function 6
	local tbl = {}

	for i = #self._input_settings_copy, 1, -1 do
		local var_6_1 = self._input_settings_copy[i]

		if self._active_time > var_6_1.start then
			local var_6_2 = self.mapping_table[var_6_1.name]

			if var_6_2.func == "button" then
				local name = var_6_1.name
				local value = var_6_1.value

				value = value or 1
				tbl[name] = value
			elseif not (var_6_2.func == "pressed" or var_6_2.func ~= "released") then
				tbl[var_6_1.name] = true
			elseif var_6_2.func == "axis" then
				tbl[var_6_1.name] = Vector3(var_6_1.value[1], var_6_1.value[2], var_6_1.value[3])
			elseif var_6_2.func == "filter" then
				tbl[var_6_1.name] = Vector3(var_6_1.value[1], var_6_1.value[2], var_6_1.value[3])
			end

			if not (not var_6_1.duration and not (self._active_time > var_6_1.start + var_6_1.duration)) then
				table.remove(self._input_settings_copy, i)
			end
		end
	end

	self._input = tbl
	self._active_time = self._active_time + arg_6_1

	if #self._input_settings_copy ~= 0 or not self._loop then
		self:start(self._input_settings, true)
	end
end
