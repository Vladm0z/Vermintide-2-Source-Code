-- chunkname: @scripts/managers/entity/entity_manager2.lua

local var_0_0 = (function(arg_1_0)
	return setmetatable({}, {
		__metatable = false,
		__index = arg_1_0,
		__newindex = function(arg_2_0, arg_2_1, arg_2_2)
			error("Coder trying to modify EntityManager's read-only empty table. Don't do it!")
		end
	})
end)({})

EntityManager2 = class(EntityManager2)

function EntityManager2.init(arg_3_0)
	arg_3_0.temp_table = {}
	arg_3_0._ignore_extensions_list = {}
	arg_3_0._units = {}
	arg_3_0._unit_extensions_list = {}
	arg_3_0._extensions = {}
	arg_3_0._systems = {}
	arg_3_0._extension_to_system_map = {}
	arg_3_0.system_to_extension_per_unit_type_map = {}
	arg_3_0._networked_flow_state = Managers.state.networked_flow_state
end

function EntityManager2.set_extension_extractor_function(arg_4_0, arg_4_1)
	arg_4_0.extension_extractor_function = arg_4_1
end

function EntityManager2.register_system(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	assert(arg_5_0._systems[arg_5_2] == nil, string.format("Tried to register system whose name '%s' was already registered.", arg_5_2))

	arg_5_0._systems[arg_5_2] = arg_5_1
	arg_5_1.NAME = arg_5_2

	for iter_5_0, iter_5_1 in ipairs(arg_5_3) do
		arg_5_0._extension_to_system_map[iter_5_1] = arg_5_2
	end

	GarbageLeakDetector.register_object(arg_5_1, arg_5_2)
end

function EntityManager2.system(arg_6_0, arg_6_1)
	return arg_6_0._systems[arg_6_1]
end

function EntityManager2.system_by_extension(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._extension_to_system_map[arg_7_1]

	return var_7_0 and arg_7_0._systems[var_7_0]
end

function EntityManager2.get_entities(arg_8_0, arg_8_1)
	return arg_8_0._extensions[arg_8_1] or var_0_0
end

function EntityManager2.destroy(arg_9_0)
	arg_9_0.temp_table = nil
	arg_9_0._units = nil
	arg_9_0._unit_extensions_list = nil
	arg_9_0._extensions = nil
	arg_9_0._systems = nil
	arg_9_0._extension_to_system_map = nil
	arg_9_0.extension_extractor_function = nil

	GarbageLeakDetector.register_object(arg_9_0, "EntityManager")
end

function EntityManager2.add_unit_extensions(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	arg_10_4 = arg_10_4 or var_0_0

	local var_10_0 = arg_10_0._ignore_extensions_list
	local var_10_1 = arg_10_0._extension_to_system_map
	local var_10_2 = arg_10_0._units
	local var_10_3 = arg_10_0._extensions
	local var_10_4 = arg_10_0._systems
	local var_10_5, var_10_6 = arg_10_0.extension_extractor_function(arg_10_2, arg_10_3)

	if arg_10_3 and arg_10_0.system_to_extension_per_unit_type_map[var_10_5] == nil then
		local var_10_7 = {}

		for iter_10_0 = 1, var_10_6 do
			repeat
				local var_10_8 = var_10_5[iter_10_0]

				if var_10_0[var_10_8] then
					break
				end

				local var_10_9 = arg_10_0._extension_to_system_map[var_10_8]

				if var_10_9 then
					var_10_7[var_10_9] = var_10_8
				end
			until true
		end

		arg_10_0.system_to_extension_per_unit_type_map[var_10_5] = var_10_7
	end

	local var_10_10 = arg_10_0._unit_extensions_list

	assert(not var_10_10[arg_10_2], "Adding extensions to a unit that already has extensions added!")

	var_10_10[arg_10_2] = var_10_5

	if var_10_6 == 0 then
		if arg_10_3 ~= nil then
			Unit.flow_event(arg_10_2, "unit_registered")
		end

		return false
	end

	for iter_10_1 = 1, var_10_6 do
		repeat
			local var_10_11 = var_10_5[iter_10_1]

			if var_10_0[var_10_11] then
				break
			end

			local var_10_12 = var_10_1[var_10_11]

			assert(var_10_12, string.format("No such registered extension %q", var_10_11))

			local var_10_13 = arg_10_4[var_10_12] or var_0_0

			assert(var_10_1[var_10_11])

			local var_10_14 = var_10_4[var_10_12]

			assert(var_10_14 ~= nil, string.format("Adding extension %q with no system is registered.", var_10_11))

			local var_10_15 = var_10_14:on_add_extension(arg_10_1, arg_10_2, var_10_11, var_10_13)

			assert(var_10_15, string.format("System (%s) must return the created extension (%s)", var_10_12, var_10_11))

			var_10_3[var_10_11] = var_10_3[var_10_11] or {}
			var_10_2[arg_10_2] = var_10_2[arg_10_2] or {}
			var_10_2[arg_10_2][var_10_11] = var_10_15

			assert(var_10_15 ~= var_0_0)
		until true
	end

	local var_10_16 = var_10_2[arg_10_2]

	for iter_10_2 = 1, var_10_6 do
		repeat
			local var_10_17 = var_10_5[iter_10_2]

			if var_10_0[var_10_17] then
				break
			end

			local var_10_18 = var_10_16[var_10_17]

			if var_10_18.extensions_ready ~= nil then
				var_10_18:extensions_ready(arg_10_1, arg_10_2)
			end

			local var_10_19 = var_10_4[var_10_1[var_10_17]]

			if var_10_19.extensions_ready ~= nil then
				var_10_19:extensions_ready(arg_10_1, arg_10_2, var_10_17)
			end
		until true
	end

	Unit.flow_event(arg_10_2, "unit_registered")

	return true
end

function EntityManager2.sync_unit_extensions(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0._units[arg_11_1]

	if var_11_0 then
		local var_11_1 = arg_11_0._extension_to_system_map
		local var_11_2 = arg_11_0._systems

		for iter_11_0, iter_11_1 in pairs(var_11_0) do
			if iter_11_1.game_object_initialized ~= nil then
				iter_11_1:game_object_initialized(arg_11_1, arg_11_2)
			end

			local var_11_3 = var_11_2[var_11_1[iter_11_0]]

			if var_11_3.game_object_initialized ~= nil then
				var_11_3:game_object_initialized(arg_11_1, arg_11_2)
			end
		end
	end
end

function EntityManager2.hot_join_sync(arg_12_0, arg_12_1)
	local var_12_0 = ScriptUnit.extensions(arg_12_1)

	if not var_12_0 then
		return
	end

	for iter_12_0, iter_12_1 in pairs(var_12_0) do
		if iter_12_1.hot_join_sync then
			iter_12_1:hot_join_sync(Managers.state.network:game_session_host())
		end
	end
end

local var_0_1 = {}

function EntityManager2.register_unit(arg_13_0, arg_13_1, arg_13_2, arg_13_3, ...)
	local var_13_0

	if type(arg_13_3) == "table" then
		var_13_0 = arg_13_3
	else
		var_13_0 = {
			arg_13_3,
			...
		}
	end

	if arg_13_0:add_unit_extensions(arg_13_1, arg_13_2, nil, var_13_0) then
		var_0_1[1] = arg_13_2

		arg_13_0:register_units_extensions(var_0_1, 1)
	end
end

function EntityManager2.add_and_register_units(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	arg_14_3 = arg_14_3 or #arg_14_2

	local var_14_0 = arg_14_0.temp_table
	local var_14_1 = 0

	for iter_14_0 = 1, arg_14_3 do
		local var_14_2 = arg_14_2[iter_14_0]
		local var_14_3 = Unit.get_data(var_14_2, "unit_template")

		if arg_14_0:add_unit_extensions(arg_14_1, var_14_2, var_14_3) then
			var_14_1 = var_14_1 + 1
			var_14_0[var_14_1] = var_14_2
		end
	end

	if var_14_1 > 0 then
		arg_14_0:register_units_extensions(var_14_0, var_14_1)
	end
end

function EntityManager2.register_units_extensions(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0._units
	local var_15_1 = arg_15_0._extensions

	for iter_15_0 = 1, arg_15_2 do
		repeat
			local var_15_2 = arg_15_1[iter_15_0]
			local var_15_3 = var_15_0[var_15_2]

			if not var_15_3 then
				break
			end

			for iter_15_1, iter_15_2 in pairs(var_15_3) do
				assert(not var_15_1[iter_15_1][var_15_2], string.format("Unit %q already has extension %s registered.", var_15_2, iter_15_1))

				var_15_1[iter_15_1][var_15_2] = iter_15_2
			end
		until true
	end
end

function EntityManager2.remove_extensions_from_unit(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0._unit_extensions_list
	local var_16_1 = arg_16_0._extensions
	local var_16_2 = ScriptUnit.destroy_extension
	local var_16_3 = ScriptUnit.extensions(arg_16_1)
	local var_16_4 = var_16_0[arg_16_1]

	if not var_16_4 then
		return
	end

	local var_16_5 = #var_16_4

	for iter_16_0, iter_16_1 in ipairs(arg_16_2) do
		local var_16_6 = arg_16_0:system_by_extension(iter_16_1).NAME

		var_16_2(arg_16_1, var_16_6)
	end

	for iter_16_2, iter_16_3 in ipairs(arg_16_2) do
		local var_16_7 = arg_16_0:system_by_extension(iter_16_3)

		var_16_7:on_remove_extension(arg_16_1, iter_16_3)
		assert(not ScriptUnit.has_extension(arg_16_1, var_16_7.NAME), string.format("Extension was not properly destroyed for extension %s", iter_16_3))

		var_16_1[iter_16_3][arg_16_1] = nil
	end
end

function EntityManager2.freeze_extensions(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	for iter_17_0 = #arg_17_2, 1, -1 do
		local var_17_0 = arg_17_2[iter_17_0]
		local var_17_1 = arg_17_0:system_by_extension(var_17_0)

		if var_17_1 and var_17_1.on_freeze_extension then
			var_17_1:on_freeze_extension(arg_17_1, var_17_0, arg_17_3)
		end
	end
end

function EntityManager2.unregister_units(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_0._networked_flow_state
	local var_18_1 = arg_18_0._units
	local var_18_2 = arg_18_0._extensions
	local var_18_3 = arg_18_0.extension_extractor_function
	local var_18_4 = arg_18_0._unit_extensions_list
	local var_18_5 = ScriptUnit.destroy_extension
	local var_18_6 = ScriptUnit.has_extension
	local var_18_7 = arg_18_0._ignore_extensions_list

	for iter_18_0 = 1, arg_18_2 do
		repeat
			local var_18_8 = arg_18_1[iter_18_0]

			POSITION_LOOKUP[var_18_8] = nil

			local var_18_9 = ScriptUnit.extensions(var_18_8)

			if not var_18_9 then
				break
			end

			local var_18_10 = var_18_4[var_18_8]

			if not var_18_10 then
				break
			end

			for iter_18_1 = #var_18_10, 1, -1 do
				local var_18_11 = var_18_10[iter_18_1]
				local var_18_12 = arg_18_0:system_by_extension(var_18_11)

				if var_18_12 ~= nil then
					local var_18_13 = var_18_12.NAME

					if var_18_6(var_18_8, var_18_13) then
						var_18_5(var_18_8, var_18_13)
					end
				end
			end

			local var_18_14 = arg_18_0.system_to_extension_per_unit_type_map[var_18_10]

			if var_18_14 then
				for iter_18_2, iter_18_3 in pairs(var_18_9) do
					local var_18_15 = var_18_14[iter_18_2]
					local var_18_16 = arg_18_0._systems[iter_18_2]

					var_18_16:on_remove_extension(var_18_8, var_18_15)
					assert(not ScriptUnit.has_extension(var_18_8, var_18_16.NAME), string.format("Extension was not properly destroyed for extension %s", var_18_15))

					var_18_2[var_18_15][var_18_8] = nil
				end
			else
				for iter_18_4 = #var_18_10, 1, -1 do
					local var_18_17 = var_18_10[iter_18_4]

					if not var_18_7[var_18_17] then
						local var_18_18 = arg_18_0:system_by_extension(var_18_17)

						var_18_18:on_remove_extension(var_18_8, var_18_17)
						assert(not ScriptUnit.has_extension(var_18_8, var_18_18.NAME), string.format("Extension was not properly destroyed for extension %s", var_18_17))

						var_18_2[var_18_17][var_18_8] = nil
					end
				end
			end

			var_18_0:clear_object_state(var_18_8)
			ScriptUnit.remove_unit(var_18_8)

			var_18_1[var_18_8] = nil
			var_18_4[var_18_8] = nil
		until true
	end
end

function EntityManager2.game_object_unit_destroyed(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0._unit_extensions_list[arg_19_1]
	local var_19_1 = ScriptUnit.extensions(arg_19_1)

	if not var_19_1 then
		return
	end

	for iter_19_0, iter_19_1 in pairs(var_19_1) do
		local var_19_2 = arg_19_0._systems[iter_19_0]
		local var_19_3 = ScriptUnit.extension(arg_19_1, iter_19_0)

		if var_19_3.game_object_unit_destroyed then
			var_19_3:game_object_unit_destroyed()
		end
	end
end

function EntityManager2.add_ignore_extensions(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0._ignore_extensions_list
	local var_20_1 = #arg_20_1

	for iter_20_0 = 1, var_20_1 do
		var_20_0[arg_20_1[iter_20_0]] = true
	end
end

local var_0_2 = {}

function EntityManager2.unregister_unit(arg_21_0, arg_21_1)
	var_0_2[1] = arg_21_1

	arg_21_0:unregister_units(var_0_2, 1)
end
