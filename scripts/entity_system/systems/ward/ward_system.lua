-- chunkname: @scripts/entity_system/systems/ward/ward_system.lua

WardSystem = class(WardSystem, ExtensionSystemBase)

local tbl = {
	"WardExtension"
}

WardSystem.init = function (self, arg_1_1, arg_1_2, ...)
	-- function 1
	WardSystem.super.init(self, arg_1_1, arg_1_2, tbl, ...)

	self._update_index = 1
	self._units = {}
	self._to_update = {}
	self._lookup = {}
	self._profiler_name = self.profiler_names.WardExtension
end

WardSystem.on_add_extension = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	local NAME = self.NAME
	local var_2_1
	local add_extension = ScriptUnit.add_extension(self.extension_init_context, arg_2_2, arg_2_3, NAME, arg_2_4, var_2_1)
	local extensions = self.extensions
	local var_2_4 = self.extensions[arg_2_3]

	var_2_4 = var_2_4 or 0
	extensions[arg_2_3] = var_2_4 + 1

	local var_2_5 = self.extensions[arg_2_3]

	self._units[var_2_5] = arg_2_2
	self._lookup[arg_2_2] = var_2_5

	if not add_extension.update then
		local _to_update = self._to_update
		local count = #self._to_update

		count = count or 0
		_to_update[count + 1] = add_extension
	end

	return add_extension
end

WardSystem.update = function (self, arg_3_1, arg_3_2)
	-- function 3
	local count = #self._to_update
	local dt = arg_3_1.dt

	if count == 0 then
		return
	end

	local _update_index = self._update_index
	local var_3_3 = self._to_update[_update_index]

	if not var_3_3 then
		var_3_3:update(self._units[_update_index], nil, dt, arg_3_1, arg_3_2)
	end

	if _update_index == count then
		self._update_index = 1
	else
		self._update_index = _update_index + 1
	end
end

WardSystem.on_remove_extension = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not ScriptUnit.has_extension(arg_4_1, self.NAME) then
		return
	end

	local var_4_0 = self.extensions[arg_4_2]
	local var_4_1 = self._lookup[arg_4_1]

	if var_4_1 == var_4_0 then
		self._units[var_4_1] = nil
		self._to_update[var_4_1] = nil
		self._lookup[var_4_1] = nil
	else
		self._units[var_4_1] = self._units[var_4_0]
		self._units[var_4_0] = nil
		self._to_update[var_4_1] = self._to_update[var_4_0]
		self._to_update[var_4_0] = nil
		self._lookup[self._units[var_4_1]] = var_4_1
		self._lookup[var_4_0] = nil
	end

	self._update_index = 1
	self.extensions[arg_4_2] = self.extensions[arg_4_2] - 1

	ScriptUnit.remove_extension(arg_4_1, self.NAME)
end
