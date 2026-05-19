-- chunkname: @scripts/hub_elements/ai_spawner.lua

require("scripts/settings/breeds")

AISpawner = class(AISpawner)
AI_TEST_COUNTER = 0

function AISpawner.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._spawner_system = Managers.state.entity:system("spawner_system")
	arg_1_0._config = {}
	arg_1_0._breed_list = {}
	arg_1_0._world = arg_1_1
	arg_1_0._unit = arg_1_2
	arg_1_0._num_queued_units = 0
	arg_1_0._next_spawn = 0
	arg_1_0._max_amount = 0
	arg_1_0._spawned_units = {}
	arg_1_0._spawned_unit_handles = {}
	arg_1_0._activate_version = 0

	if Unit.has_data(arg_1_2, "spawner_settings") then
		local var_1_0 = arg_1_0:check_for_enabled()

		if var_1_0 ~= nil then
			local var_1_1 = Unit.get_data(arg_1_2, "terror_event_id")

			var_1_1 = var_1_1 and var_1_1 ~= "" and var_1_1

			local var_1_2 = Unit.get_data(arg_1_2, "hidden")

			arg_1_0._spawner_system:register_enabled_spawner(arg_1_2, var_1_1, var_1_2)

			local var_1_3 = 0
			local var_1_4 = {}

			while Unit.has_data(arg_1_2, "spawner_settings", var_1_0, "animation_events", var_1_3) do
				var_1_4[#var_1_4 + 1] = Unit.get_data(arg_1_2, "spawner_settings", var_1_0, "animation_events", var_1_3)
				var_1_3 = var_1_3 + 1
			end

			arg_1_0._config = {
				name = var_1_0,
				animation_events = var_1_4,
				node = Unit.get_data(arg_1_2, "spawner_settings", var_1_0, "node"),
				spawn_rate = Unit.get_data(arg_1_2, "spawner_settings", var_1_0, "spawn_rate")
			}
		end
	else
		local var_1_5 = Unit.get_data(arg_1_0._unit, "terror_event_id")

		var_1_5 = var_1_5 and var_1_5 ~= "" and var_1_5

		arg_1_0._spawner_system:register_raw_spawner(arg_1_0._unit, var_1_5)
	end
end

function AISpawner.check_for_enabled(arg_2_0)
	local var_2_0 = 1
	local var_2_1 = "spawner"

	repeat
		local var_2_2 = "spawner" .. var_2_0

		if Unit.has_data(arg_2_0._unit, "spawner_settings", var_2_2) then
			if Unit.get_data(arg_2_0._unit, "spawner_settings", var_2_2, "enabled") then
				return var_2_2
			end
		else
			return nil
		end

		var_2_0 = var_2_0 + 1
	until true
end

function AISpawner.on_activate(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	table.clear(arg_3_0._spawned_unit_handles)
	table.clear(arg_3_0._spawned_units)

	arg_3_0._activate_version = arg_3_0._activate_version + 1

	local var_3_0 = {
		arg_3_2,
		arg_3_3,
		arg_3_4
	}
	local var_3_1 = arg_3_0._breed_list
	local var_3_2 = #var_3_1

	arg_3_0._max_amount = arg_3_0._max_amount + #arg_3_1

	local var_3_3 = var_3_2 + 1

	for iter_3_0 = 1, #arg_3_1 do
		var_3_1[var_3_3] = arg_3_1[iter_3_0]
		var_3_3 = var_3_3 + 1
		var_3_1[var_3_3] = var_3_0
		var_3_3 = var_3_3 + 1
	end
end

function AISpawner.on_deactivate(arg_4_0)
	arg_4_0._max_amount = 0
	arg_4_0._num_queued_units = 0

	arg_4_0._spawner_system:deactivate_spawner(arg_4_0._unit)
	table.clear(arg_4_0._breed_list)
end

function AISpawner.update(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	if arg_5_5 > arg_5_0._next_spawn then
		if arg_5_0._num_queued_units < arg_5_0._max_amount then
			arg_5_0:spawn_unit()

			arg_5_0._next_spawn = arg_5_5 + 1 / arg_5_0._config.spawn_rate
		elseif arg_5_0:done_spawning() then
			Unit.flow_event(arg_5_0._unit, "lua_all_units_spawned")
			arg_5_0:on_deactivate()
		end
	end
end

function AISpawner.done_spawning(arg_6_0)
	return #arg_6_0._spawned_units == arg_6_0._max_amount
end

function AISpawner.spawned_units(arg_7_0)
	return arg_7_0._spawned_units
end

function AISpawner.spawn_rate(arg_8_0)
	return arg_8_0._config.spawn_rate
end

function AISpawner.spawn_unit(arg_9_0)
	local var_9_0 = arg_9_0._breed_list
	local var_9_1 = #var_9_0
	local var_9_2 = var_9_0[var_9_1]

	var_9_0[var_9_1] = nil

	local var_9_3 = var_9_1 - 1
	local var_9_4 = var_9_0[var_9_3]

	var_9_0[var_9_3] = nil

	local var_9_5 = Breeds[var_9_4]
	local var_9_6 = arg_9_0._unit

	Unit.flow_event(var_9_6, "lua_spawn")

	local var_9_7 = Managers.state.conflict
	local var_9_8 = "ai_spawner"
	local var_9_9 = Unit.node(var_9_6, arg_9_0._config.node)
	local var_9_10 = Unit.scene_graph_parent(var_9_6, var_9_9)
	local var_9_11 = Unit.world_rotation(var_9_6, var_9_10)
	local var_9_12 = Unit.local_rotation(var_9_6, var_9_9)
	local var_9_13 = Quaternion.multiply(var_9_11, var_9_12)
	local var_9_14 = Unit.get_data(arg_9_0._unit, "hidden") and "horde_hidden" or "horde"
	local var_9_15 = Unit.world_position(var_9_6, var_9_9)
	local var_9_16 = arg_9_0._config.animation_events

	if var_9_14 == "horde_hidden" and var_9_5.use_regular_horde_spawning then
		var_9_14 = "horde"
	end

	local var_9_17 = var_9_14 == "horde" and var_9_16[math.random(#var_9_16)]
	local var_9_18

	var_9_18.side_id, var_9_18 = var_9_2[1], var_9_2[3] or {}

	local var_9_19 = arg_9_0._activate_version
	local var_9_20 = var_9_18.spawned_func

	if var_9_20 then
		function var_9_18.spawned_func(arg_10_0, ...)
			var_9_20(arg_10_0, ...)

			if var_9_19 == arg_9_0._activate_version then
				arg_9_0._spawned_units[#arg_9_0._spawned_units + 1] = arg_10_0
			end
		end
	end

	local var_9_21 = var_9_2[2]

	arg_9_0._num_queued_units = arg_9_0._num_queued_units + 1
	arg_9_0._spawned_unit_handles[arg_9_0._num_queued_units] = var_9_7:spawn_queued_unit(var_9_5, Vector3Box(var_9_15), QuaternionBox(var_9_13), var_9_8, var_9_17, var_9_14, var_9_18, var_9_21)

	var_9_7:add_horde(1)
end

function AISpawner.spawn_rotation(arg_11_0)
	local var_11_0 = arg_11_0._unit

	return Unit.world_rotation(var_11_0, Unit.node(var_11_0, arg_11_0._config.node))
end

function AISpawner.spawn_position(arg_12_0)
	local var_12_0 = arg_12_0._unit

	return Unit.world_position(var_12_0, Unit.node(var_12_0, arg_12_0._config.node))
end

function AISpawner.get_spawner_name(arg_13_0)
	return arg_13_0._config.name
end

function AISpawner.destroy(arg_14_0)
	return
end
