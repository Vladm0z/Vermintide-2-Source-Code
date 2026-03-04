-- chunkname: @scripts/network/unit_spawner.lua

require("scripts/settings/unit_spawner_settings")
require("scripts/settings/spawn_unit_templates")

local var_0_0 = require("scripts/network/unit_extension_templates")

local function var_0_1(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0[arg_1_1]

	if not var_1_0 then
		return
	end

	for iter_1_0, iter_1_1 in pairs(var_1_0) do
		iter_1_1(arg_1_1)
	end

	arg_1_0[arg_1_1] = nil
end

local var_0_2 = Unit.alive

UnitSpawner = class(UnitSpawner)

function UnitSpawner.init(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0.world = arg_2_1
	arg_2_0.entity_manager = arg_2_2
	arg_2_0.unit_storage = nil
	arg_2_0.is_server = arg_2_3
	arg_2_0.unit_deletion_information = {}
	arg_2_0.deletion_queue = GrowQueue:new()
	arg_2_0.temp_deleted_units_list = {}
	arg_2_0.unit_unique_id = 0
	arg_2_0.game_session = nil
	arg_2_0.unit_synchronizer = nil
	arg_2_0.own_peer_id = nil
	arg_2_0.gameobject_functor_context = nil
	arg_2_0.gameobject_initializers = nil
	arg_2_0.gameobject_extractors = nil
	arg_2_0.pending_extension_adds_map = {}
	arg_2_0.pending_extension_adds_list = {}
	arg_2_0.pending_extension_adds_list_n = 0
	arg_2_0.unit_destroy_listeners = {}
	arg_2_0.unit_destroy_listeners_post_cleanup = {}
	arg_2_0.unit_death_watch_list = {}
	arg_2_0.unit_death_watch_lookup = {}
	arg_2_0.unit_death_watch_list_n = 0
	arg_2_0.unit_death_watch_list_dirty = false
	arg_2_0._async_spawn_queue = {}
	arg_2_0._async_spawn_handle = 0
	arg_2_0._spawned_async_units = {}
end

function UnitSpawner.destroy(arg_3_0)
	GarbageLeakDetector.register_object(arg_3_0, "UnitSpawner")

	arg_3_0.unit_destroy_listeners = nil
	arg_3_0.entity_manager = nil
end

function UnitSpawner.set_gameobject_initializer_data(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	arg_4_0.game_session = Network.game_session()

	fassert(arg_4_0.game_session, "No game session when initializing game object")

	arg_4_0.own_peer_id = Network.peer_id()

	fassert(arg_4_0.own_peer_id, "No own peer id when initializing game object")

	arg_4_0.gameobject_functor_context = arg_4_3
	arg_4_0.gameobject_initializers = arg_4_1
	arg_4_0.gameobject_extractors = arg_4_2
end

function UnitSpawner.set_unit_storage(arg_5_0, arg_5_1)
	arg_5_0.unit_storage = arg_5_1
end

function UnitSpawner.set_gameobject_to_unit_creator_function(arg_6_0, arg_6_1)
	arg_6_0.create_unit_from_gameobject_function = arg_6_1
end

function UnitSpawner.set_unit_template_lookup_table(arg_7_0, arg_7_1)
	arg_7_0.unit_template_lut = arg_7_1
end

function UnitSpawner.push_unit_to_death_watch_list(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	arg_8_0:freeze_unit_extensions(arg_8_1, arg_8_2, arg_8_3)

	arg_8_0.unit_death_watch_list_n = arg_8_0.unit_death_watch_list_n + 1
	arg_8_0.unit_death_watch_list[arg_8_0.unit_death_watch_list_n] = {
		unit = arg_8_1,
		t = arg_8_2,
		data = arg_8_3
	}
	arg_8_0.unit_death_watch_lookup[arg_8_1] = arg_8_0.unit_death_watch_list[arg_8_0.unit_death_watch_list_n]
end

function UnitSpawner.freeze_unit_extensions(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = NetworkUnit.is_husk_unit(arg_9_1)
	local var_9_1 = var_0_0.extensions_to_remove_on_death(arg_9_3.breed.unit_template, var_9_0, arg_9_0.is_server)

	if var_9_1 then
		arg_9_0.entity_manager:freeze_extensions(arg_9_1, var_9_1)
	end
end

function UnitSpawner.prioritize_death_watch_unit(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0.unit_death_watch_lookup[arg_10_1]

	if var_10_0 then
		var_10_0.t = arg_10_2
		arg_10_0.unit_death_watch_list_dirty = true
	end
end

function UnitSpawner.breed_in_death_watch(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0.unit_death_watch_list

	for iter_11_0 = 1, arg_11_0.unit_death_watch_list_n do
		local var_11_1 = var_11_0[iter_11_0].unit
		local var_11_2 = BLACKBOARDS[var_11_1]

		if var_11_2 and arg_11_1 == var_11_2.breed.name then
			return true
		end
	end
end

local function var_0_3(arg_12_0, arg_12_1)
	return arg_12_0.t < arg_12_1.t
end

function UnitSpawner.update_death_watch_list(arg_13_0)
	if arg_13_0.unit_death_watch_list_dirty then
		table.sort(arg_13_0.unit_death_watch_list, var_0_3)

		arg_13_0.unit_death_watch_list_dirty = false
	end

	local var_13_0 = RagdollSettings.max_num_ragdolls
	local var_13_1 = RagdollSettings.min_num_ragdolls
	local var_13_2 = Managers.state.conflict:total_num_ai_spawned() + arg_13_0.unit_death_watch_list_n

	if var_13_0 < var_13_2 then
		local var_13_3 = math.min(var_13_2 - var_13_0, arg_13_0.unit_death_watch_list_n)

		if var_13_1 > arg_13_0.unit_death_watch_list_n - var_13_3 then
			var_13_3 = var_13_3 - var_13_1
		end

		for iter_13_0 = 1, var_13_3 do
			local var_13_4

			if iter_13_0 < arg_13_0.unit_death_watch_list_n then
				var_13_4 = arg_13_0.unit_death_watch_list[iter_13_0]

				local var_13_5 = arg_13_0.unit_death_watch_list[arg_13_0.unit_death_watch_list_n]

				arg_13_0.unit_death_watch_list[iter_13_0] = var_13_5
				arg_13_0.unit_death_watch_lookup[var_13_5.unit] = arg_13_0.unit_death_watch_list[iter_13_0]
				arg_13_0.unit_death_watch_list[arg_13_0.unit_death_watch_list_n] = nil
				arg_13_0.unit_death_watch_lookup[var_13_4.unit] = nil
			else
				var_13_4 = arg_13_0.unit_death_watch_list[arg_13_0.unit_death_watch_list_n]
				arg_13_0.unit_death_watch_list[arg_13_0.unit_death_watch_list_n] = nil
				arg_13_0.unit_death_watch_lookup[var_13_4.unit] = nil
			end

			arg_13_0.unit_death_watch_list_n = math.max(arg_13_0.unit_death_watch_list_n - 1, 0)
			var_13_4.data.remove = true
		end

		arg_13_0.unit_death_watch_list_dirty = true
	end
end

function UnitSpawner.mark_for_deletion(arg_14_0, arg_14_1)
	fassert(var_0_2(arg_14_1), "Tried to destroy a unit (%s) that was already destroyed.", tostring(arg_14_1))
	arg_14_0.deletion_queue:push_back(arg_14_1)

	local var_14_0 = arg_14_0.unit_death_watch_lookup[arg_14_1]

	if var_14_0 then
		local var_14_1 = table.find(arg_14_0.unit_death_watch_list, var_14_0)
		local var_14_2 = arg_14_0.unit_death_watch_list[arg_14_0.unit_death_watch_list_n]

		arg_14_0.unit_death_watch_list[var_14_1] = var_14_2
		arg_14_0.unit_death_watch_lookup[var_14_2.unit] = arg_14_0.unit_death_watch_list[var_14_1]
		arg_14_0.unit_death_watch_list[arg_14_0.unit_death_watch_list_n] = nil
		arg_14_0.unit_death_watch_lookup[var_14_0.unit] = nil
		arg_14_0.unit_death_watch_list_n = math.max(arg_14_0.unit_death_watch_list_n - 1, 0)
		arg_14_0.unit_death_watch_list_dirty = true
	end
end

function UnitSpawner.is_marked_for_deletion(arg_15_0, arg_15_1)
	return (arg_15_0.deletion_queue:contains(arg_15_1))
end

function UnitSpawner.commit_and_remove_pending_units(arg_16_0)
	local var_16_0 = 0
	local var_16_1 = 0

	repeat
		-- block empty
	until arg_16_0:commit_pending_unit_system_registrations() + arg_16_0:remove_units_marked_for_deletion() == 0
end

function UnitSpawner.commit_pending_unit_system_registrations(arg_17_0)
	fassert(not arg_17_0.locked)

	local var_17_0 = arg_17_0.pending_extension_adds_list_n

	if var_17_0 == 0 then
		return 0
	end

	local var_17_1 = arg_17_0.pending_extension_adds_map
	local var_17_2 = arg_17_0.pending_extension_adds_list
	local var_17_3 = 0

	for iter_17_0, iter_17_1 in pairs(var_17_1) do
		var_17_1[iter_17_0] = nil
		var_17_3 = var_17_3 + 1
		var_17_2[var_17_3] = iter_17_0
	end

	fassert(var_17_3 == var_17_0)
	arg_17_0.entity_manager:register_units_extensions(var_17_2, var_17_0)

	arg_17_0.pending_extension_adds_list_n = 0

	return var_17_0
end

function UnitSpawner.remove_units_marked_for_deletion(arg_18_0)
	fassert(not arg_18_0.locked)

	local var_18_0 = arg_18_0.pending_extension_adds_map
	local var_18_1 = arg_18_0.pending_extension_adds_list_n
	local var_18_2 = 0
	local var_18_3 = arg_18_0.entity_manager
	local var_18_4 = Managers.state.event
	local var_18_5 = arg_18_0.world
	local var_18_6 = arg_18_0.world_delete_units
	local var_18_7 = arg_18_0.temp_deleted_units_list
	local var_18_8 = arg_18_0.unit_storage
	local var_18_9 = arg_18_0.unit_destroy_listeners
	local var_18_10 = arg_18_0.unit_destroy_listeners_post_cleanup
	local var_18_11 = arg_18_0.deletion_queue:pop_first()

	if var_0_2(var_18_11) then
		local var_18_12 = 0

		var_0_1(var_18_9, var_18_11)
		Unit.flow_event(var_18_11, "cleanup_before_destroy")

		local var_18_13 = var_18_12 + 1

		var_18_7[var_18_13] = var_18_11

		if var_18_1 > 0 and var_18_0[var_18_11] then
			var_18_0[var_18_11] = nil
			var_18_1 = var_18_1 - 1
		end

		var_18_4:unregister_referenced_all(var_18_11)
		var_18_3:unregister_units(var_18_7, var_18_13)

		for iter_18_0 = 1, var_18_13 do
			var_0_1(var_18_10, var_18_7[iter_18_0])
		end

		var_18_6(arg_18_0, var_18_5, var_18_7, var_18_13)

		var_18_2 = var_18_2 + var_18_13
	end

	arg_18_0.pending_extension_adds_list_n = var_18_1

	return var_18_2
end

function UnitSpawner.spawn_local_unit(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	local var_19_0 = World.spawn_unit(arg_19_0.world, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	local var_19_1 = arg_19_0.unit_unique_id

	arg_19_0.unit_unique_id = var_19_1 + 1

	Unit.set_data(var_19_0, "unique_id", var_19_1)
	Unit.set_data(var_19_0, "unit_name", arg_19_1)

	POSITION_LOOKUP[var_19_0] = Unit.world_position(var_19_0, 0)

	return var_19_0
end

local var_0_4 = {}

function UnitSpawner.create_unit_extensions(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	if arg_20_0.entity_manager:add_unit_extensions(arg_20_1, arg_20_2, arg_20_3, arg_20_4) then
		if not arg_20_0.locked then
			var_0_4[1] = arg_20_2

			arg_20_0.entity_manager:register_units_extensions(var_0_4, 1)
		else
			arg_20_0.pending_extension_adds_list_n = arg_20_0.pending_extension_adds_list_n + 1
			arg_20_0.pending_extension_adds_map[arg_20_2] = true
		end
	end
end

function UnitSpawner.spawn_local_unit_with_extensions(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6)
	local var_21_0 = arg_21_0:spawn_local_unit(arg_21_1, arg_21_4, arg_21_5, arg_21_6)

	arg_21_2 = arg_21_2 or Unit.get_data(var_21_0, "unit_template")

	arg_21_0:create_unit_extensions(arg_21_0.world, var_21_0, arg_21_2, arg_21_3)

	return var_21_0, arg_21_2
end

function UnitSpawner.spawn_network_unit(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6)
	local var_22_0, var_22_1 = arg_22_0:spawn_local_unit_with_extensions(arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6)
	local var_22_2 = arg_22_0.unit_template_lut[var_22_1]

	NetworkUnit.add_unit(var_22_0)
	NetworkUnit.set_is_husk_unit(var_22_0, false)

	local var_22_3 = var_22_2.go_type
	local var_22_4 = arg_22_0.gameobject_initializers[var_22_3](var_22_0, arg_22_1, var_22_2, arg_22_0.gameobject_functor_context)
	local var_22_5 = GameSession.create_game_object(arg_22_0.game_session, var_22_3, var_22_4)

	arg_22_0.unit_storage:add_unit_info(var_22_0, var_22_5, var_22_3, arg_22_0.own_peer_id)
	arg_22_0.entity_manager:sync_unit_extensions(var_22_0, var_22_5)

	return var_22_0, var_22_5
end

function UnitSpawner.queue_spawn_network_unit(arg_23_0, ...)
	local var_23_0 = arg_23_0._async_spawn_queue
	local var_23_1 = arg_23_0._async_spawn_handle

	arg_23_0._async_spawn_handle = var_23_1 + 1

	local var_23_2 = Managers.state.network.network_transmit:pack_temp_types(nil, ...)

	var_23_0[#var_23_0 + 1] = {
		handle = var_23_1,
		unpack(var_23_2)
	}

	return var_23_1
end

function UnitSpawner.remove_queued_network_unit(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0._spawned_async_units[arg_24_1]

	if var_24_0 then
		arg_24_0:mark_for_deletion(var_24_0)

		return
	end

	local var_24_1 = arg_24_0._async_spawn_queue

	for iter_24_0 = #var_24_1, 1, -1 do
		if var_24_1[iter_24_0].handle == arg_24_1 then
			table.remove(var_24_1, iter_24_0)

			break
		end
	end
end

function UnitSpawner.spawn_queued_units(arg_25_0)
	local var_25_0 = arg_25_0._async_spawn_queue

	for iter_25_0 = 1, #var_25_0 do
		local var_25_1 = var_25_0[iter_25_0]

		Managers.state.network.network_transmit:unpack_temp_types(var_25_1)

		local var_25_2 = arg_25_0:spawn_network_unit(unpack(var_25_1))

		arg_25_0._async_spawn_queue[iter_25_0] = nil
		arg_25_0._spawned_async_units[var_25_1.handle] = var_25_2
	end
end

function UnitSpawner.try_claim_async_unit(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0._spawned_async_units[arg_26_1]

	arg_26_0._spawned_async_units[arg_26_1] = nil

	return var_26_0
end

function UnitSpawner.request_spawn_template_unit(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6)
	arg_27_6 = arg_27_6 or 1

	local var_27_0 = NetworkLookup.spawn_unit_templates[arg_27_1]
	local var_27_1 = Managers.state.unit_storage:go_id(arg_27_4)

	Managers.state.network.network_transmit:send_rpc_server("rpc_request_spawn_template_unit", var_27_0, arg_27_2, arg_27_3, var_27_1, arg_27_5, arg_27_6)
end

function UnitSpawner.world_delete_units(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	local var_28_0 = arg_28_0.game_session
	local var_28_1 = arg_28_0.unit_storage

	if var_28_0 then
		for iter_28_0 = 1, arg_28_3 do
			local var_28_2 = arg_28_2[iter_28_0]
			local var_28_3, var_28_4 = var_0_2(var_28_2)
			local var_28_5 = var_28_1:go_id(var_28_2)

			if not var_28_3 then
				fassert(false)
			end

			if var_28_5 then
				GameSession.destroy_game_object(var_28_0, var_28_5)
				var_28_1:remove(var_28_2, var_28_5)
				NetworkUnit.remove_unit(var_28_2)
			end

			POSITION_LOOKUP[var_28_2] = nil

			Unit.flow_event(var_28_2, "unit_despawned")
			World.destroy_unit(arg_28_1, var_28_2)
		end
	else
		for iter_28_1 = 1, arg_28_3 do
			local var_28_6 = arg_28_2[iter_28_1]
			local var_28_7, var_28_8 = var_0_2(var_28_6)

			if not var_28_7 then
				fassert(false)
			end

			local var_28_9 = var_28_1:go_id(var_28_6)

			if var_28_9 then
				var_28_1:remove(var_28_6, var_28_9)
				NetworkUnit.remove_unit(var_28_6)
			end

			POSITION_LOOKUP[var_28_6] = nil

			Unit.flow_event(var_28_6, "unit_despawned")
			World.destroy_unit(arg_28_1, var_28_6)
		end
	end
end

function UnitSpawner.spawn_unit_from_game_object(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	local var_29_0 = arg_29_0.create_unit_from_gameobject_function(arg_29_0, arg_29_0.game_session, arg_29_1, arg_29_3)

	NetworkUnit.add_unit(var_29_0)
	NetworkUnit.set_is_husk_unit(var_29_0, true)

	local var_29_1 = arg_29_3.go_type

	arg_29_0.unit_storage:add_unit_info(var_29_0, arg_29_1, var_29_1, arg_29_2)

	local var_29_2 = arg_29_0.gameobject_extractors[var_29_1]

	fassert(type(var_29_2) == "function")

	local var_29_3, var_29_4 = var_29_2(arg_29_0.game_session, arg_29_1, arg_29_2, var_29_0, arg_29_0.gameobject_functor_context)
	local var_29_5 = true

	arg_29_0:create_unit_extensions(arg_29_0.world, var_29_0, var_29_3, var_29_4, var_29_5)

	return var_29_0
end

function UnitSpawner.destroy_game_object_unit(arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_0.unit_storage
	local var_30_1 = var_30_0:units()[arg_30_1]

	fassert(var_30_1, "Couldn't find unit with go_id %d", arg_30_1)

	if Unit.is_frozen(var_30_1) then
		FROZEN[var_30_1] = nil

		Unit.set_frozen(var_30_1, false)
	end

	arg_30_0.entity_manager:game_object_unit_destroyed(var_30_1)
	arg_30_0:mark_for_deletion(var_30_1)
	var_30_0:remove(var_30_1, arg_30_1)
end

function UnitSpawner.add_destroy_listener(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
	local var_31_0 = arg_31_4 and arg_31_0.unit_destroy_listeners_post_cleanup or arg_31_0.unit_destroy_listeners
	local var_31_1 = var_31_0[arg_31_1]

	if not var_31_1 then
		var_31_1 = {}
		var_31_0[arg_31_1] = var_31_1
	end

	fassert(var_31_1[arg_31_2] == nil, "Tried to register a unit destroy listener identifier (%s) twice for the same unit %s", tostring(arg_31_2), tostring(arg_31_1))

	var_31_1[arg_31_2] = arg_31_3
end

function UnitSpawner.remove_destroy_listener(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	local var_32_0 = (arg_32_3 and arg_32_0.unit_destroy_listeners_post_cleanup or arg_32_0.unit_destroy_listeners)[arg_32_1]

	if var_32_0 then
		var_32_0[arg_32_2] = nil
	else
		printf("[UnitSpawner] [%s] failed to remove listener [%s] from unit [%s]", arg_32_0.identifier_tag, tostring(arg_32_2), tostring(arg_32_1))
	end
end
