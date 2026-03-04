-- chunkname: @scripts/managers/conflict_director/breed_freezer.lua

BreedFreezerSettings = {
	freezer_pos = {
		0,
		0,
		-600
	},
	freezer_offset = {
		0,
		0.05,
		0.05
	},
	freezer_pos_debug = {
		0,
		0,
		10
	},
	freezer_offset_debug = {
		0,
		2,
		3
	},
	freezer_size = {
		0,
		0,
		0
	},
	breeds = {
		skaven_clan_rat = {
			pool_size = 32
		},
		skaven_slave = {
			pool_size = 50
		},
		skaven_storm_vermin = {
			pool_size = 16
		},
		skaven_plague_monk = {
			pool_size = 8
		},
		chaos_marauder = {
			pool_size = 32
		},
		chaos_fanatic = {
			pool_size = 50
		},
		chaos_berzerker = {
			pool_size = 8
		},
		chaos_raider = {
			pool_size = 8
		},
		chaos_warrior = {
			pool_size = 6
		},
		beastmen_ungor = {
			pool_size = 50
		},
		beastmen_ungor_archer = {
			pool_size = 16
		},
		beastmen_gor = {
			pool_size = 32
		},
		beastmen_bestigor = {
			pool_size = 16
		}
	},
	breeds_index_lookup = {}
}

fassert(BreedFreezerSettings.freezer_offset[2] > 0, "Must have positive offset so we can sort the units when hot joining")

local var_0_0 = require("scripts/network/unit_extension_templates")

BreedFreezer = class(BreedFreezer)

function BreedFreezer.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	local var_1_0 = Managers.player.is_server

	arg_1_0.is_server = var_1_0
	arg_1_0.world = arg_1_1
	arg_1_0.entity_manager = arg_1_2
	arg_1_0.network_event_delegate = arg_1_3

	arg_1_3:register(arg_1_0, "rpc_breed_freeze_units", "rpc_breed_unfreeze_breed", "rpc_breed_freezer_sync_breeds")

	arg_1_0._enemy_package_loader = arg_1_4
	arg_1_0.breed_spawn_queues = {}
	arg_1_0.extensions = {}
	arg_1_0.systems_by_breed = {}
	arg_1_0.extension_names_by_breed = {}
	arg_1_0.count = 0
	arg_1_0.units_to_freeze = {}
	arg_1_0.num_to_freeze = 0
	arg_1_0.breed_offsets = {}
	arg_1_0.breed_template_units = {}

	if var_1_0 then
		arg_1_0._breed_freezer_settings = arg_1_0:_setup_freezable_breeds(arg_1_4)
	end
end

function BreedFreezer._setup_freezable_breeds(arg_2_0, arg_2_1)
	local var_2_0 = table.clone(BreedFreezerSettings)
	local var_2_1 = arg_2_1:get_startup_breeds()
	local var_2_2 = var_2_0.breeds

	for iter_2_0, iter_2_1 in pairs(var_2_2) do
		if not var_2_1[iter_2_0] then
			var_2_2[iter_2_0] = nil
		end
	end

	local var_2_3 = table.keys(var_2_2)

	table.sort(var_2_3)
	printf("[BreedFreezer] Setting up freezable breeds: (%s)", table.concat(var_2_3, ", "))

	var_2_0.num_pools = #var_2_3
	var_2_0.max_pool_size = 0

	local var_2_4 = var_2_0.breeds_index_lookup

	for iter_2_2 = 1, #var_2_3 do
		local var_2_5 = var_2_3[iter_2_2]
		local var_2_6 = var_2_2[var_2_5]

		var_2_4[iter_2_2] = var_2_5
		var_2_0.max_pool_size = math.max(var_2_0.max_pool_size, var_2_6.pool_size)
	end

	for iter_2_3, iter_2_4 in pairs(var_2_0.breeds) do
		fassert(iter_2_4.pool_size <= NetworkConstants.max_breed_freezer_units_per_rpc, "Pool size too large to sync!")
	end

	arg_2_0:_setup_freeze_box(var_2_0)

	return var_2_0
end

function BreedFreezer._setup_freeze_box(arg_3_0, arg_3_1)
	local var_3_0 = 0
	local var_3_1 = script_data.debug_breed_freeze and Vector3Aux.unbox(arg_3_1.freezer_pos_debug) or Vector3Aux.unbox(arg_3_1.freezer_pos)
	local var_3_2 = script_data.debug_breed_freeze and Vector3Aux.unbox(arg_3_1.freezer_offset_debug) or Vector3Aux.unbox(arg_3_1.freezer_offset)

	arg_3_0.freezer_pos = Vector3Box(var_3_1)
	arg_3_0.freezer_offset = Vector3Box(var_3_2)

	local var_3_3 = arg_3_0.world
	local var_3_4 = arg_3_0.is_server
	local var_3_5 = arg_3_0.entity_manager

	for iter_3_0, iter_3_1 in pairs(arg_3_1.breeds) do
		arg_3_0.breed_offsets[iter_3_0] = var_3_0
		arg_3_0.units_to_freeze[iter_3_0] = {}
		arg_3_0.breed_spawn_queues[iter_3_0] = CircularQueue:new(iter_3_1.pool_size)

		local var_3_6 = Breeds[iter_3_0]
		local var_3_7 = not var_3_4
		local var_3_8, var_3_9 = var_0_0.get_extensions(var_3_6.unit_template, var_3_7, var_3_4)

		arg_3_0.systems_by_breed[iter_3_0] = {}
		arg_3_0.extension_names_by_breed[iter_3_0] = {}

		local var_3_10 = arg_3_0.systems_by_breed[iter_3_0]
		local var_3_11 = arg_3_0.extension_names_by_breed[iter_3_0]

		for iter_3_2 = 1, var_3_9 do
			local var_3_12 = var_3_8[iter_3_2]
			local var_3_13 = var_3_5:system_by_extension(var_3_12)

			if var_3_13 ~= nil then
				var_3_10[#var_3_10 + 1] = var_3_13

				fassert(var_3_13.freeze, "System '%s' that should be able to freeze and unfreeze breed extensions doesn't have the required function(s).", var_3_13.NAME)

				var_3_11[#var_3_11 + 1] = var_3_12
			end
		end

		local var_3_14 = script_data.use_optimized_breed_units and var_3_6.opt_base_unit or var_3_6.base_unit
		local var_3_15 = 0

		if var_3_14 and type(var_3_14) == "table" then
			for iter_3_3, iter_3_4 in ipairs(var_3_14) do
				local var_3_16 = var_3_1 + Vector3(var_3_15, -3, var_3_0)

				arg_3_0:_spawn_template_unit(var_3_3, iter_3_4, var_3_16)
			end

			local var_3_17 = var_3_15 + 1
		else
			local var_3_18 = var_3_1 + Vector3(0, -3, var_3_0)

			arg_3_0:_spawn_template_unit(var_3_3, var_3_14, var_3_18)
		end

		var_3_0 = var_3_0 + var_3_2.z
	end

	arg_3_1.freezer_size[1] = 4
	arg_3_1.freezer_size[2] = var_3_2[2] * (arg_3_1.max_pool_size + 1)
	arg_3_1.freezer_size[3] = var_3_2[3] * (arg_3_1.num_pools + 1)
	arg_3_0.spawn_data = {
		nil,
		Vector3Box(),
		QuaternionBox()
	}
	arg_3_0._freezer_initialized = true
end

function BreedFreezer._spawn_template_unit(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = World.spawn_unit(arg_4_1, arg_4_2, arg_4_3)

	arg_4_0.breed_template_units[arg_4_2] = var_4_0

	Unit.disable_animation_state_machine(var_4_0)
	Unit.disable_physics(var_4_0)
	Unit.set_unit_visibility(var_4_0, false)

	if script_data.debug_breed_freeze then
		QuickDrawerStay:sphere(arg_4_3, 1, Color(0, 200, 0))
	end
end

function BreedFreezer.destroy(arg_5_0)
	arg_5_0.network_event_delegate:unregister(arg_5_0)
end

function BreedFreezer.try_mark_unit_for_freeze(arg_6_0, arg_6_1, arg_6_2)
	assert(arg_6_0._breed_freezer_settings, "[BreedFreezer] 'try_mark_unit_for_freeze' was called before we've initialized the breed freezer")

	local var_6_0 = arg_6_1.name

	if arg_6_0._breed_freezer_settings.breeds[var_6_0] == nil then
		return false
	end

	local var_6_1 = arg_6_0.units_to_freeze[var_6_0]

	if arg_6_0.breed_spawn_queues[var_6_0]:available() <= #var_6_1 then
		return false
	end

	for iter_6_0 = 1, #var_6_1 do
		if var_6_1[iter_6_0] == arg_6_2 then
			rawset(_G, "DoubleFreezeContext", rawget(_G, "DoubleFreezeContext") or {})

			DoubleFreezeContext[arg_6_2] = true

			print("ERROR: Tried to freeze unit twice in the same frame.", Script.callstack())

			return false
		end
	end

	if arg_6_0.breed_spawn_queues[var_6_0]:contains(arg_6_2) then
		print("ERROR: Tried to freeze unit twice (it was already in queue).")

		return false
	end

	arg_6_0.num_to_freeze = arg_6_0.num_to_freeze + 1
	var_6_1[#var_6_1 + 1] = arg_6_2

	return true
end

function BreedFreezer.rpc_breed_freeze_units(arg_7_0, arg_7_1, arg_7_2)
	fassert(arg_7_0._freezer_initialized, "Received freeze before freezer was initialized!")

	local var_7_0 = Managers.state.unit_storage

	for iter_7_0 = 1, #arg_7_2 do
		local var_7_1 = arg_7_2[iter_7_0]
		local var_7_2 = var_7_0:unit(var_7_1)
		local var_7_3 = ScriptUnit.has_extension(var_7_2, "ai_system"):breed().name

		fassert(arg_7_0._breed_freezer_settings.breeds[var_7_3], "Can't freeze unit of breed %s", var_7_3)

		local var_7_4 = arg_7_0.units_to_freeze[var_7_3]

		fassert(arg_7_0.breed_spawn_queues[var_7_3]:available() > #var_7_4, "Breed freeze queue for breed %s is full.", var_7_3)

		arg_7_0.num_to_freeze = arg_7_0.num_to_freeze + 1
		var_7_4[#var_7_4 + 1] = var_7_2
	end

	arg_7_0:commit_freezes()
end

local var_0_1 = GameSession.set_game_object_field

function BreedFreezer.commit_freezes(arg_8_0)
	if arg_8_0.num_to_freeze == 0 then
		return
	end

	local var_8_0 = arg_8_0.freezer_offset:unbox()
	local var_8_1 = arg_8_0.freezer_pos:unbox()
	local var_8_2 = Vector3Aux.unbox(arg_8_0._breed_freezer_settings.freezer_size)
	local var_8_3 = arg_8_0.is_server
	local var_8_4 = Managers.state.network
	local var_8_5 = var_8_4:in_game_session()
	local var_8_6 = var_8_4:game()
	local var_8_7 = FrameTable.alloc_table()
	local var_8_8 = NetworkConstants.max_breed_freezer_units_per_rpc

	for iter_8_0, iter_8_1 in pairs(arg_8_0.units_to_freeze) do
		local var_8_9 = arg_8_0.breed_spawn_queues[iter_8_0]

		for iter_8_2 = 1, #iter_8_1 do
			local var_8_10 = iter_8_1[iter_8_2]

			iter_8_1[iter_8_2] = nil

			var_8_9:push_back(var_8_10)
			Managers.state.event:trigger_referenced(var_8_10, "on_unit_freeze")

			local var_8_11 = arg_8_0.systems_by_breed[iter_8_0]
			local var_8_12 = arg_8_0.extension_names_by_breed[iter_8_0]

			for iter_8_3 = #var_8_11, 1, -1 do
				var_8_11[iter_8_3]:freeze(var_8_10, var_8_12[iter_8_3], "reason_unspawn")
			end

			if Unit.has_animation_state_machine(var_8_10) then
				Unit.disable_animation_state_machine(var_8_10)
			end

			Unit.flow_event(var_8_10, "lua_freeze_unit")
			Unit.disable_physics(var_8_10)

			local var_8_13 = Unit.get_data(var_8_10, "unit_name")
			local var_8_14 = arg_8_0.breed_template_units[var_8_13]

			Unit.copy_scene_graph_local_from(var_8_10, var_8_14)

			if not script_data.debug_breed_freeze then
				Unit.set_unit_visibility(var_8_10, false)
			end

			local var_8_15 = Vector3(var_8_2[1] * 0.5, var_8_9.last * var_8_0[2], arg_8_0.breed_offsets[iter_8_0] + var_8_0[3] * 0.5)

			Unit.set_local_position(var_8_10, 0, var_8_1 + var_8_15)

			FROZEN[var_8_10] = true
			POSITION_LOOKUP[var_8_10] = nil

			Unit.reload_flow(var_8_10)

			arg_8_0.count = arg_8_0.count + 1

			Unit.set_frozen(var_8_10, true)

			if var_8_3 and var_8_5 then
				local var_8_16 = var_8_4:unit_game_object_id(var_8_10)

				var_8_7[#var_8_7 + 1] = var_8_16

				var_0_1(var_8_6, var_8_16, "position", var_8_1 + var_8_15)

				if var_8_8 <= #var_8_7 then
					fassert(#var_8_7 == var_8_8, "More than one unit id was added during loop!")
					var_8_4.network_transmit:send_rpc_clients("rpc_breed_freeze_units", var_8_7)
					table.clear(var_8_7)
				end
			end

			Managers.state.unit_storage:freeze(var_8_10)
		end
	end

	if var_8_3 and var_8_5 and #var_8_7 > 0 then
		var_8_4.network_transmit:send_rpc_clients("rpc_breed_freeze_units", var_8_7)
	end

	arg_8_0.num_to_freeze = 0
end

function BreedFreezer.try_unfreeze_breed(arg_9_0, arg_9_1, arg_9_2)
	assert(arg_9_0._breed_freezer_settings, "[BreedFreezer] 'try_unfreeze_breed' was called before the breed freezer was initialized")

	local var_9_0 = arg_9_1.name

	if arg_9_0._breed_freezer_settings.breeds[var_9_0] == nil then
		return nil
	end

	local var_9_1 = arg_9_0.breed_spawn_queues[var_9_0]

	if var_9_1:is_empty() then
		return nil
	end

	local var_9_2 = var_9_1:pop_first()

	Managers.state.unit_storage:unfreeze(var_9_2)

	local var_9_3 = arg_9_2[7].side_id
	local var_9_4 = Managers.state.network
	local var_9_5 = var_9_4:unit_game_object_id(var_9_2)

	var_9_4.network_transmit:send_rpc_clients("rpc_breed_unfreeze_breed", NetworkLookup.breeds[var_9_0], arg_9_2[2]:unbox(), arg_9_2[3]:unbox(), var_9_3, var_9_5)
	arg_9_0:unfreeze_unit(var_9_2, var_9_0, arg_9_2)

	return var_9_2
end

function BreedFreezer.rpc_breed_unfreeze_breed(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6)
	fassert(arg_10_0._freezer_initialized, "Received unfreeze before freezer was initialized!")

	local var_10_0 = NetworkLookup.breeds[arg_10_2]
	local var_10_1 = arg_10_0.breed_spawn_queues[var_10_0]:pop_first()

	fassert(arg_10_0._breed_freezer_settings.breeds[var_10_0], "Can't unfreeze unit of breed %s", var_10_0)
	Managers.state.unit_storage:unfreeze(var_10_1)

	local var_10_2 = Managers.state.unit_storage:go_id(var_10_1)

	fassert(arg_10_6 == var_10_2, "Server unfreeze unit didn't match local unit in spawn queue")

	local var_10_3 = ScriptUnit.has_extension(var_10_1, "ai_system"):breed()
	local var_10_4 = {
		side_id = arg_10_5
	}
	local var_10_5 = arg_10_0.spawn_data

	var_10_5[1] = var_10_3

	var_10_5[2]:store(arg_10_3)
	var_10_5[3]:store(arg_10_4)

	var_10_5[7] = var_10_4

	arg_10_0:unfreeze_unit(var_10_1, var_10_0, var_10_5)
end

function BreedFreezer.unfreeze_unit(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	Unit.set_frozen(arg_11_1, false)

	local var_11_0 = arg_11_3[2]:unbox()
	local var_11_1 = arg_11_3[3]:unbox()

	Unit.set_local_position(arg_11_1, 0, var_11_0)
	Unit.set_local_rotation(arg_11_1, 0, var_11_1)

	POSITION_LOOKUP[arg_11_1] = var_11_0
	FROZEN[arg_11_1] = nil

	Unit.enable_animation_state_machine(arg_11_1)
	Unit.enable_physics(arg_11_1)
	Unit.flow_event(arg_11_1, "lua_unfreeze_unit")
	Unit.set_unit_visibility(arg_11_1, true)
	Managers.state.blood:clear_unit_decals(arg_11_1)
	Unit.trigger_flow_unit_spawned(arg_11_1)
	World.update_unit(arg_11_0.world, arg_11_1)

	arg_11_0.count = arg_11_0.count - 1

	local var_11_2 = arg_11_0.systems_by_breed[arg_11_2]
	local var_11_3 = arg_11_0.extension_names_by_breed[arg_11_2]

	for iter_11_0 = 1, #var_11_2 do
		local var_11_4 = var_11_2[iter_11_0]

		if var_11_4.unfreeze then
			var_11_4:unfreeze(arg_11_1, var_11_3[iter_11_0], arg_11_3)
		end
	end

	Unit.flow_event(arg_11_1, "lua_trigger_variation")

	return arg_11_1
end

function store_go_ids_in_array_func(arg_12_0, arg_12_1, arg_12_2)
	arg_12_0[#arg_12_0 + 1] = arg_12_2[arg_12_1]
end

function BreedFreezer.hot_join_sync(arg_13_0, arg_13_1)
	print("Breedfreezer (server) starting a hot join sync")

	local var_13_0 = {}
	local var_13_1 = {}
	local var_13_2 = 0
	local var_13_3 = 1
	local var_13_4 = NetworkConstants.max_breed_freezer_units_per_rpc
	local var_13_5 = PEER_ID_TO_CHANNEL[arg_13_1]
	local var_13_6 = Managers.state.unit_storage.frozen_bimap_goid_unit
	local var_13_7 = arg_13_0._breed_freezer_settings.breeds_index_lookup

	for iter_13_0 = 1, #var_13_7 do
		local var_13_8 = var_13_7[iter_13_0]
		local var_13_9 = arg_13_0.breed_spawn_queues[var_13_8]
		local var_13_10 = var_13_9:size()

		if var_13_4 <= var_13_10 + var_13_2 then
			printf("\t--> rpc-package size reached, sending rpc now")
			RPC.rpc_breed_freezer_sync_breeds(var_13_5, var_13_0, var_13_1)
			table.clear(var_13_1)
			table.clear(var_13_0)

			var_13_2 = 0
			var_13_3 = 1
		end

		var_13_0[var_13_3 * 2 - 1] = var_13_9.first
		var_13_0[var_13_3 * 2 - 0] = var_13_10

		printf("\tpacking %d units of breed %s", var_13_10, var_13_8)
		var_13_9:foreach(var_13_1, store_go_ids_in_array_func, var_13_6)

		var_13_2 = var_13_2 + var_13_10
		var_13_3 = var_13_3 + 1
	end

	if #var_13_0 > 0 then
		printf("\t--> rpc-package size reached, sending rpc now (last package)")
		RPC.rpc_breed_freezer_sync_breeds(var_13_5, var_13_0, var_13_1)
		table.dump(var_13_0, "starts")
		table.dump(var_13_1, "breed_go_ids")
	end
end

function BreedFreezer.rpc_breed_freezer_sync_breeds(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	if not arg_14_0._current_synced_breed_index then
		arg_14_0._current_synced_breed_index = 0
		arg_14_0._breed_freezer_settings = arg_14_0:_setup_freezable_breeds(arg_14_0._enemy_package_loader)
	end

	printf("Breedfreezer (client) received breed syncs num_breeds:%d, total_units:%d", #arg_14_2 / 2, #arg_14_3)

	local var_14_0 = arg_14_0._current_synced_breed_index
	local var_14_1 = 1

	for iter_14_0 = 1, #arg_14_2, 2 do
		var_14_0 = var_14_0 + 1

		local var_14_2 = arg_14_0._breed_freezer_settings.breeds_index_lookup[var_14_0]

		fassert(arg_14_0._breed_freezer_settings.breeds[var_14_2], "Can't freeze unit of breed %s", var_14_2)

		local var_14_3 = arg_14_2[iter_14_0]
		local var_14_4 = arg_14_2[iter_14_0 + 1]
		local var_14_5 = arg_14_0.breed_spawn_queues[var_14_2]

		var_14_5.first = var_14_3
		var_14_5.last = var_14_5:index_before(var_14_5.first)

		printf("-->\tgot %d of %s", var_14_4, var_14_2)
		fassert(var_14_5:is_empty(), "Breed freeze queue for breed %s was not empty!", var_14_2)

		local var_14_6 = arg_14_0.units_to_freeze[var_14_2]

		for iter_14_1 = 1, var_14_4 do
			local var_14_7 = arg_14_3[var_14_1]
			local var_14_8 = Managers.state.unit_storage:unit(var_14_7)

			var_14_6[#var_14_6 + 1] = var_14_8
			arg_14_0.num_to_freeze = arg_14_0.num_to_freeze + 1

			local var_14_9 = ScriptUnit.has_extension(var_14_8, "ai_system"):breed()

			fassert(var_14_9.name == var_14_2, "Got wrong expected breed in rpc_breed_freezer_sync_breeds %q ~= %q", var_14_9.name, var_14_2)

			var_14_1 = var_14_1 + 1
		end
	end

	arg_14_0._current_synced_breed_index = var_14_0

	print("Breed freezer counts: ", arg_14_0._current_synced_breed_index, #arg_14_0._breed_freezer_settings.breeds_index_lookup)

	if arg_14_0._current_synced_breed_index == #arg_14_0._breed_freezer_settings.breeds_index_lookup then
		print("Comitting breed freezer frozen units")
		arg_14_0:commit_freezes()
	end
end
