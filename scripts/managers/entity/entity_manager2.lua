-- chunkname: @scripts/managers/entity/entity_manager2.lua

local var_0_0 = (function (arg_1_0)
	-- function 1
	return setmetatable({}, {
		__metatable = false,
		__index = arg_1_0,
		__newindex = function (arg_2_0, arg_2_1, arg_2_2)
			-- function 2
			error("Coder trying to modify EntityManager's read-only empty table. Don't do it!")
		end
	})
end)({})

EntityManager2 = class(EntityManager2)

EntityManager2.init = function (self)
	-- function 3
	self.temp_table = {}
	self._ignore_extensions_list = {}
	self._units = {}
	self._unit_extensions_list = {}
	self._extensions = {}
	self._systems = {}
	self._extension_to_system_map = {}
	self.system_to_extension_per_unit_type_map = {}
	self._networked_flow_state = Managers.state.networked_flow_state
end

EntityManager2.set_extension_extractor_function = function (self, arg_4_1)
	-- function 4
	self.extension_extractor_function = arg_4_1
end

EntityManager2.register_system = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	assert(self._systems[arg_5_2] == nil, string.format("Tried to register system whose name '%s' was already registered.", arg_5_2))

	self._systems[arg_5_2] = arg_5_1
	arg_5_1.NAME = arg_5_2

	for i, v in ipairs(arg_5_3) do
		self._extension_to_system_map[v] = arg_5_2
	end

	GarbageLeakDetector.register_object(arg_5_1, arg_5_2)
end

EntityManager2.system = function (self, arg_6_1)
	-- function 6
	return self._systems[arg_6_1]
end

EntityManager2.system_by_extension = function (self, arg_7_1)
	-- function 7
	local var_7_0 = self._extension_to_system_map[arg_7_1]

	return not var_7_0 and self._systems[var_7_0]
end

EntityManager2.get_entities = function (self, arg_8_1)
	-- function 8
	local var_8_0 = self._extensions[arg_8_1]

	var_8_0 = var_8_0 or var_0_0

	return var_8_0
end

EntityManager2.destroy = function (self)
	-- function 9
	self.temp_table = nil
	self._units = nil
	self._unit_extensions_list = nil
	self._extensions = nil
	self._systems = nil
	self._extension_to_system_map = nil
	self.extension_extractor_function = nil

	GarbageLeakDetector.register_object(self, "EntityManager")
end

EntityManager2.add_unit_extensions = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	arg_10_4 = arg_10_4 or var_0_0

	local _ignore_extensions_list = self._ignore_extensions_list
	local _extension_to_system_map = self._extension_to_system_map
	local _units = self._units
	local _extensions = self._extensions
	local _systems = self._systems
	local extension_extractor_function, var_10_6 = self.extension_extractor_function(arg_10_2, arg_10_3)

	if not (not arg_10_3 and self.system_to_extension_per_unit_type_map[extension_extractor_function] ~= nil) then
		local tbl = {}

		for i = 1, var_10_6 do
			repeat
				local var_10_8 = extension_extractor_function[i]

				if not _ignore_extensions_list[var_10_8] then
					break
				end

				local var_10_9 = self._extension_to_system_map[var_10_8]

				if not var_10_9 then
					tbl[var_10_9] = var_10_8
				end
			until true
		end

		self.system_to_extension_per_unit_type_map[extension_extractor_function] = tbl
	end

	local _unit_extensions_list = self._unit_extensions_list

	assert(not _unit_extensions_list[arg_10_2], "Adding extensions to a unit that already has extensions added!")

	_unit_extensions_list[arg_10_2] = extension_extractor_function

	if var_10_6 == 0 then
		if arg_10_3 ~= nil then
			Unit.flow_event(arg_10_2, "unit_registered")
		end

		return false
	end

	for j = 1, var_10_6 do
		repeat
			local var_10_11 = extension_extractor_function[j]

			if not _ignore_extensions_list[var_10_11] then
				break
			end

			local var_10_12 = _extension_to_system_map[var_10_11]

			assert(var_10_12, string.format("No such registered extension %q", var_10_11))

			local var_10_13 = arg_10_4[var_10_12]

			var_10_13 = var_10_13 or var_0_0

			assert(_extension_to_system_map[var_10_11])

			local var_10_14 = _systems[var_10_12]

			assert(var_10_14 ~= nil, string.format("Adding extension %q with no system is registered.", var_10_11))

			local on_add_extension = var_10_14:on_add_extension(arg_10_1, arg_10_2, var_10_11, var_10_13)

			assert(on_add_extension, string.format("System (%s) must return the created extension (%s)", var_10_12, var_10_11))

			local var_10_16 = _extensions[var_10_11]

			var_10_16 = var_10_16 or {}
			_extensions[var_10_11] = var_10_16

			local var_10_17 = _units[arg_10_2]

			var_10_17 = var_10_17 or {}
			_units[arg_10_2] = var_10_17
			_units[arg_10_2][var_10_11] = on_add_extension

			assert(on_add_extension ~= var_0_0)
		until true
	end

	local var_10_18 = _units[arg_10_2]

	for k = 1, var_10_6 do
		repeat
			local var_10_19 = extension_extractor_function[k]

			if not _ignore_extensions_list[var_10_19] then
				break
			end

			local var_10_20 = var_10_18[var_10_19]

			if var_10_20.extensions_ready ~= nil then
				var_10_20:extensions_ready(arg_10_1, arg_10_2)
			end

			local var_10_21 = _systems[_extension_to_system_map[var_10_19]]

			if var_10_21.extensions_ready ~= nil then
				var_10_21:extensions_ready(arg_10_1, arg_10_2, var_10_19)
			end
		until true
	end

	Unit.flow_event(arg_10_2, "unit_registered")

	return true
end

EntityManager2.sync_unit_extensions = function (self, arg_11_1, arg_11_2)
	-- function 11
	local var_11_0 = self._units[arg_11_1]

	if not var_11_0 then
		local _extension_to_system_map = self._extension_to_system_map
		local _systems = self._systems

		for k, v in pairs(var_11_0) do
			if v.game_object_initialized ~= nil then
				v:game_object_initialized(arg_11_1, arg_11_2)
			end

			local var_11_3 = _systems[_extension_to_system_map[k]]

			if var_11_3.game_object_initialized ~= nil then
				var_11_3:game_object_initialized(arg_11_1, arg_11_2)
			end
		end
	end
end

EntityManager2.hot_join_sync = function (arg_12_0, arg_12_1)
	-- function 12
	local extensions = ScriptUnit.extensions(arg_12_1)

	if not extensions then
		return
	end

	for k, v in pairs(extensions) do
		if not v.hot_join_sync then
			v:hot_join_sync(Managers.state.network:game_session_host())
		end
	end
end

local tbl = {}

EntityManager2.register_unit = function (self, arg_13_1, arg_13_2, arg_13_3, ...)
	-- function 13
	local var_13_0

	if type(arg_13_3) == "table" then
		var_13_0 = arg_13_3
	else
		var_13_0 = {
			arg_13_3,
			...
		}
	end

	if not self:add_unit_extensions(arg_13_1, arg_13_2, nil, var_13_0) then
		tbl[1] = arg_13_2

		self:register_units_extensions(tbl, 1)
	end
end

EntityManager2.add_and_register_units = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	arg_14_3 = arg_14_3 or #arg_14_2

	local temp_table = self.temp_table
	local num = 0

	for i = 1, arg_14_3 do
		local var_14_2 = arg_14_2[i]
		local get_data = Unit.get_data(var_14_2, "unit_template")

		if not self:add_unit_extensions(arg_14_1, var_14_2, get_data) then
			num = num + 1
			temp_table[num] = var_14_2
		end
	end

	if num > 0 then
		self:register_units_extensions(temp_table, num)
	end
end

EntityManager2.register_units_extensions = function (self, arg_15_1, arg_15_2)
	-- function 15
	local _units = self._units
	local _extensions = self._extensions

	for i = 1, arg_15_2 do
		repeat
			local var_15_2 = arg_15_1[i]
			local var_15_3 = _units[var_15_2]

			if not var_15_3 then
				break
			end

			for k, v in pairs(var_15_3) do
				assert(not _extensions[k][var_15_2], string.format("Unit %q already has extension %s registered.", var_15_2, k))

				_extensions[k][var_15_2] = v
			end
		until true
	end
end

EntityManager2.remove_extensions_from_unit = function (self, arg_16_1, arg_16_2)
	-- function 16
	local _unit_extensions_list = self._unit_extensions_list
	local _extensions = self._extensions
	local destroy_extension = ScriptUnit.destroy_extension
	local extensions = ScriptUnit.extensions(arg_16_1)
	local var_16_4 = _unit_extensions_list[arg_16_1]

	if not var_16_4 then
		return
	end

	local count = #var_16_4

	for i, v in ipairs(arg_16_2) do
		local NAME = self:system_by_extension(v).NAME

		destroy_extension(arg_16_1, NAME)
	end

	for i_2, v_2 in ipairs(arg_16_2) do
		local system_by_extension = self:system_by_extension(v_2)

		system_by_extension:on_remove_extension(arg_16_1, v_2)
		assert(not ScriptUnit.has_extension(arg_16_1, system_by_extension.NAME), string.format("Extension was not properly destroyed for extension %s", v_2))

		_extensions[v_2][arg_16_1] = nil
	end
end

EntityManager2.freeze_extensions = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	for i = #arg_17_2, 1, -1 do
		local var_17_0 = arg_17_2[i]
		local system_by_extension = self:system_by_extension(var_17_0)

		if not system_by_extension and not system_by_extension.on_freeze_extension then
			system_by_extension:on_freeze_extension(arg_17_1, var_17_0, arg_17_3)
		end
	end
end

EntityManager2.unregister_units = function (self, arg_18_1, arg_18_2)
	-- function 18
	local _networked_flow_state = self._networked_flow_state
	local _units = self._units
	local _extensions = self._extensions
	local extension_extractor_function = self.extension_extractor_function
	local _unit_extensions_list = self._unit_extensions_list
	local destroy_extension = ScriptUnit.destroy_extension
	local has_extension = ScriptUnit.has_extension
	local _ignore_extensions_list = self._ignore_extensions_list

	for i = 1, arg_18_2 do
		repeat
			local var_18_8 = arg_18_1[i]

			POSITION_LOOKUP[var_18_8] = nil

			local extensions = ScriptUnit.extensions(var_18_8)

			if not extensions then
				break
			end

			local var_18_10 = _unit_extensions_list[var_18_8]

			if not var_18_10 then
				break
			end

			for j = #var_18_10, 1, -1 do
				local var_18_11 = var_18_10[j]
				local system_by_extension = self:system_by_extension(var_18_11)

				if system_by_extension ~= nil then
					local NAME = system_by_extension.NAME

					if not has_extension(var_18_8, NAME) then
						destroy_extension(var_18_8, NAME)
					end
				end
			end

			local var_18_14 = self.system_to_extension_per_unit_type_map[var_18_10]

			if not var_18_14 then
				for k, v in pairs(extensions) do
					local var_18_15 = var_18_14[k]
					local var_18_16 = self._systems[k]

					var_18_16:on_remove_extension(var_18_8, var_18_15)
					assert(not ScriptUnit.has_extension(var_18_8, var_18_16.NAME), string.format("Extension was not properly destroyed for extension %s", var_18_15))

					_extensions[var_18_15][var_18_8] = nil
				end
			else
				for i4 = #var_18_10, 1, -1 do
					local var_18_17 = var_18_10[i4]

					if not _ignore_extensions_list[var_18_17] then
						local system_by_extension_2 = self:system_by_extension(var_18_17)

						system_by_extension_2:on_remove_extension(var_18_8, var_18_17)
						assert(not ScriptUnit.has_extension(var_18_8, system_by_extension_2.NAME), string.format("Extension was not properly destroyed for extension %s", var_18_17))

						_extensions[var_18_17][var_18_8] = nil
					end
				end
			end

			_networked_flow_state:clear_object_state(var_18_8)
			ScriptUnit.remove_unit(var_18_8)

			_units[var_18_8] = nil
			_unit_extensions_list[var_18_8] = nil
		until true
	end
end

EntityManager2.game_object_unit_destroyed = function (self, arg_19_1)
	-- function 19
	local var_19_0 = self._unit_extensions_list[arg_19_1]
	local extensions = ScriptUnit.extensions(arg_19_1)

	if not extensions then
		return
	end

	for k, v in pairs(extensions) do
		local var_19_2 = self._systems[k]
		local extension = ScriptUnit.extension(arg_19_1, k)

		if not extension.game_object_unit_destroyed then
			extension:game_object_unit_destroyed()
		end
	end
end

EntityManager2.add_ignore_extensions = function (self, arg_20_1)
	-- function 20
	local _ignore_extensions_list = self._ignore_extensions_list
	local count = #arg_20_1

	for i = 1, count do
		_ignore_extensions_list[arg_20_1[i]] = true
	end
end

local tbl_2 = {}

EntityManager2.unregister_unit = function (self, arg_21_1)
	-- function 21
	tbl_2[1] = arg_21_1

	self:unregister_units(tbl_2, 1)
end
