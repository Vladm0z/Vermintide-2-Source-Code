-- chunkname: @scripts/entity_system/systems/extension_system_base.lua

ExtensionSystemBase = class(ExtensionSystemBase)

ExtensionSystemBase.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.is_server = arg_1_1.is_server
	self.world = arg_1_1.world
	self.name = arg_1_2

	local entity_manager = arg_1_1.entity_manager

	entity_manager:register_system(self, arg_1_2, arg_1_3)

	self.entity_manager = entity_manager
	self.unit_storage = arg_1_1.unit_storage
	self.network_transmit = arg_1_1.network_transmit
	self.system_api = arg_1_1.system_api
	self.statistics_db = arg_1_1.statistics_db
	self.extension_init_context = {
		world = self.world,
		unit_storage = self.unit_storage,
		entity_manager = self.entity_manager,
		network_transmit = self.network_transmit,
		system_api = self.system_api,
		statistics_db = self.statistics_db,
		ingame_ui = arg_1_1.ingame_ui,
		is_server = arg_1_1.is_server,
		owning_system = self
	}
	self.update_list = {}
	self.extensions = {}
	self.profiler_names = {}

	for i = 1, #arg_1_3 do
		local var_1_1 = arg_1_3[i]

		self.update_list[var_1_1] = {
			pre_update = {},
			update = {},
			post_update = {}
		}
		self.extensions[var_1_1] = 0
		self.profiler_names[var_1_1] = var_1_1 .. " [ALL]"
	end
end

ExtensionSystemBase.on_add_extension = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	local NAME = self.NAME
	local var_2_1
	local add_extension = ScriptUnit.add_extension(self.extension_init_context, arg_2_2, arg_2_3, NAME, arg_2_4, var_2_1)
	local extensions = self.extensions
	local var_2_4 = self.extensions[arg_2_3]

	var_2_4 = var_2_4 or 0
	extensions[arg_2_3] = var_2_4 + 1

	if not add_extension.pre_update then
		self.update_list[arg_2_3].pre_update[arg_2_2] = add_extension
	end

	if not add_extension.update then
		self.update_list[arg_2_3].update[arg_2_2] = add_extension
	end

	if not add_extension.post_update then
		self.update_list[arg_2_3].post_update[arg_2_2] = add_extension
	end

	return add_extension
end

ExtensionSystemBase.on_remove_extension = function (self, arg_3_1, arg_3_2)
	-- function 3
	local has_extension = ScriptUnit.has_extension(arg_3_1, self.NAME)

	assert(has_extension, "Trying to remove non-existing extension %q from unit %s", arg_3_2, arg_3_1)
	ScriptUnit.remove_extension(arg_3_1, self.NAME)

	self.extensions[arg_3_2] = self.extensions[arg_3_2] - 1
	self.update_list[arg_3_2].pre_update[arg_3_1] = nil
	self.update_list[arg_3_2].update[arg_3_1] = nil
	self.update_list[arg_3_2].post_update[arg_3_1] = nil
end

ExtensionSystemBase.on_freeze_extension = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	return
end

local tbl = {}

ExtensionSystemBase.pre_update = function (self, arg_5_1, arg_5_2)
	-- function 5
	local dt = arg_5_1.dt
	local update_list = self.update_list
	local var_5_2 = tbl

	for k, v in pairs(self.extensions) do
		local var_5_3 = self.profiler_names[k]

		for k_2, v_2 in pairs(update_list[k].pre_update) do
			v_2:pre_update(k_2, var_5_2, dt, arg_5_1, arg_5_2)
		end
	end
end

ExtensionSystemBase.enable_update_function = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	arg_6_0.update_list[arg_6_1][arg_6_2][arg_6_3] = arg_6_4
end

ExtensionSystemBase.disable_update_function = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	arg_7_0.update_list[arg_7_1][arg_7_2][arg_7_3] = nil
end

ExtensionSystemBase.update = function (self, arg_8_1, arg_8_2)
	-- function 8
	local dt = arg_8_1.dt
	local update_list = self.update_list
	local var_8_2 = tbl

	for k, v in pairs(self.extensions) do
		local var_8_3 = self.profiler_names[k]

		for k_2, v_2 in pairs(update_list[k].update) do
			v_2:update(k_2, var_8_2, dt, arg_8_1, arg_8_2)
		end
	end
end

ExtensionSystemBase.post_update = function (self, arg_9_1, arg_9_2)
	-- function 9
	local dt = arg_9_1.dt
	local update_list = self.update_list
	local var_9_2 = tbl

	for k, v in pairs(self.extensions) do
		local var_9_3 = self.profiler_names[k]

		for k_2, v_2 in pairs(update_list[k].post_update) do
			v_2:post_update(k_2, var_9_2, dt, arg_9_1, arg_9_2)
		end
	end
end

ExtensionSystemBase.pre_update_extension = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	local var_10_0 = tbl

	for k, v in pairs(self.update_list[arg_10_1].pre_update) do
		v:pre_update(k, var_10_0, arg_10_2, arg_10_3, arg_10_4)
	end
end

ExtensionSystemBase.update_extension = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	local var_11_0 = tbl

	for k, v in pairs(self.update_list[arg_11_1].update) do
		v:update(k, var_11_0, arg_11_2, arg_11_3, arg_11_4)
	end
end

ExtensionSystemBase.post_update_extension = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	-- function 12
	local var_12_0 = tbl

	for k, v in pairs(self.update_list[arg_12_1].post_update) do
		v:post_update(k, var_12_0, arg_12_2, arg_12_3, arg_12_4)
	end
end

ExtensionSystemBase.hot_join_sync = function (self, arg_13_1)
	-- function 13
	for k, v in pairs(self.extensions) do
		self:_hot_join_sync_extension(k, arg_13_1)
	end
end

ExtensionSystemBase._hot_join_sync_extension = function (self, arg_14_1, arg_14_2)
	-- function 14
	local get_entities = self.entity_manager:get_entities(arg_14_1)

	for k, v in pairs(get_entities) do
		if not v.hot_join_sync then
			v:hot_join_sync(arg_14_2)
		end
	end
end

ExtensionSystemBase.destroy = function (arg_15_0)
	-- function 15
	return
end

local tbl_2 = {}

ExtensionSystemBase.get_extensions_from_extension_name = function (self, arg_16_1)
	-- function 16
	fassert(self.update_list[arg_16_1], "[ExtensionSystemBase:get_extensions_from_type] There is no extension called %q", arg_16_1)
	table.clear(tbl_2)

	for k, v in pairs(self.update_list[arg_16_1].pre_update) do
		tbl_2[k] = v
	end

	for k_2, v_2 in pairs(self.update_list[arg_16_1].update) do
		tbl_2[k_2] = v_2
	end

	for k_3, v_3 in pairs(self.update_list[arg_16_1].post_update) do
		tbl_2[k_3] = v_3
	end

	return tbl_2
end
