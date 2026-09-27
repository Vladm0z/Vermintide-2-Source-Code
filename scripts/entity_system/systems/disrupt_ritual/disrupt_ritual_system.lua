-- chunkname: @scripts/entity_system/systems/disrupt_ritual/disrupt_ritual_system.lua

DisruptRitualSystem = class(DisruptRitualSystem, ExtensionSystemBase)

local str = "DisruptRitualExtension"

DisruptRitualSystem.init = function (self, arg_1_1, ...)
	-- function 1
	DisruptRitualSystem.super.init(self, arg_1_1, ...)

	self._update_index = 1
	self._units = {}
	self._is_server = arg_1_1.is_server
	self._extension_list = {}
	self._profiler_name = self.profiler_names.DisruptRitualExtension
end

DisruptRitualSystem.on_add_extension = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
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
	self._extension_list[#self._extension_list + 1] = add_extension

	return add_extension
end

DisruptRitualSystem.update = function (self, arg_3_1, arg_3_2)
	-- function 3
	if not self._is_server then
		return
	end

	local DisruptRitualExtension = self.extensions.DisruptRitualExtension

	if DisruptRitualExtension == 0 then
		return
	end

	local _update_index = self._update_index
	local dt = arg_3_1.dt

	self._extension_list[_update_index]:update(arg_3_2)

	if _update_index == DisruptRitualExtension then
		self._update_index = 1
	else
		self._update_index = _update_index + 1
	end
end

DisruptRitualSystem.hot_join_sync = function (self, arg_4_1)
	-- function 4
	for k, v in pairs(self.extensions) do
		self:_hot_join_sync_extension(k, arg_4_1)
	end
end

DisruptRitualSystem._hot_join_sync_extension = function (self, arg_5_1, arg_5_2)
	-- function 5
	local get_entities = self.entity_manager:get_entities(arg_5_1)

	for k, v in pairs(get_entities) do
		if not v.hot_join_sync then
			v:hot_join_sync(arg_5_2)
		end
	end
end
