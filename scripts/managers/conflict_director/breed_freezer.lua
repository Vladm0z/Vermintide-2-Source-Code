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

local scripts_network_unit_extension_templates = require("scripts/network/unit_extension_templates")

BreedFreezer = class(BreedFreezer)

BreedFreezer.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	local is_server = Managers.player.is_server

	self.is_server = is_server
	self.world = arg_1_1
	self.entity_manager = arg_1_2
	self.network_event_delegate = arg_1_3

	arg_1_3:register(self, "rpc_breed_freeze_units", "rpc_breed_unfreeze_breed", "rpc_breed_freezer_sync_breeds")

	self._enemy_package_loader = arg_1_4
	self.breed_spawn_queues = {}
	self.extensions = {}
	self.systems_by_breed = {}
	self.extension_names_by_breed = {}
	self.count = 0
	self.units_to_freeze = {}
	self.num_to_freeze = 0
	self.breed_offsets = {}
	self.breed_template_units = {}

	if not is_server then
		self._breed_freezer_settings = self:_setup_freezable_breeds(arg_1_4)
	end
end

BreedFreezer._setup_freezable_breeds = function (self, arg_2_1)
	-- function 2
	local clone = table.clone(BreedFreezerSettings)
	local get_startup_breeds = arg_2_1:get_startup_breeds()
	local breeds = clone.breeds

	for k, v in pairs(breeds) do
		if not get_startup_breeds[k] then
			breeds[k] = nil
		end
	end

	local keys = table.keys(breeds)

	table.sort(keys)
	printf("[BreedFreezer] Setting up freezable breeds: (%s)", table.concat(keys, ", "))

	clone.num_pools = #keys
	clone.max_pool_size = 0

	local breeds_index_lookup = clone.breeds_index_lookup

	for k_2 = 1, #keys do
		local var_2_5 = keys[k_2]
		local var_2_6 = breeds[var_2_5]

		breeds_index_lookup[k_2] = var_2_5
		clone.max_pool_size = math.max(clone.max_pool_size, var_2_6.pool_size)
	end

	for k_3, v_2 in pairs(clone.breeds) do
		fassert(v_2.pool_size <= NetworkConstants.max_breed_freezer_units_per_rpc, "Pool size too large to sync!")
	end

	self:_setup_freeze_box(clone)

	return clone
end

BreedFreezer._setup_freeze_box = function (self, arg_3_1)
	-- function 3
	local num = 0
	local unbox

	if not script_data.debug_breed_freeze then
		unbox = Vector3Aux.unbox(arg_3_1.freezer_pos_debug)

		if not unbox then
			-- Nothing
		end
	end

	unbox = Vector3Aux.unbox(arg_3_1.freezer_pos)

	do
		local unbox_2
	end

	::label_3_0::

	if not script_data.debug_breed_freeze then
		unbox_2 = Vector3Aux.unbox(arg_3_1.freezer_offset_debug)

		if not unbox_2 then
			-- Nothing
		end
	end

	unbox_2 = Vector3Aux.unbox(arg_3_1.freezer_offset)

	::label_3_1::

	self.freezer_pos = Vector3Box(unbox)
	self.freezer_offset = Vector3Box(unbox_2)

	local world = self.world
	local is_server = self.is_server
	local entity_manager = self.entity_manager

	for k, v in pairs(arg_3_1.breeds) do
		self.breed_offsets[k] = num
		self.units_to_freeze[k] = {}
		self.breed_spawn_queues[k] = CircularQueue:new(v.pool_size)

		local var_3_6 = Breeds[k]
		local flag = not is_server
		local get_extensions, var_3_9 = scripts_network_unit_extension_templates.get_extensions(var_3_6.unit_template, flag, is_server)

		self.systems_by_breed[k] = {}
		self.extension_names_by_breed[k] = {}

		local var_3_10 = self.systems_by_breed[k]
		local var_3_11 = self.extension_names_by_breed[k]

		for k_2 = 1, var_3_9 do
			local var_3_12 = get_extensions[k_2]
			local system_by_extension = entity_manager:system_by_extension(var_3_12)

			if system_by_extension ~= nil then
				var_3_10[#var_3_10 + 1] = system_by_extension

				fassert(system_by_extension.freeze, "System '%s' that should be able to freeze and unfreeze breed extensions doesn't have the required function(s).", system_by_extension.NAME)

				var_3_11[#var_3_11 + 1] = var_3_12
			end
		end

		local opt_base_unit

		if not script_data.use_optimized_breed_units then
			opt_base_unit = var_3_6.opt_base_unit

			if not opt_base_unit then
				-- Nothing
			end
		end

		opt_base_unit = var_3_6.base_unit

		::label_3_2::

		local num_2 = 0

		if not (not opt_base_unit and type(opt_base_unit) ~= "table") then
			for i, v_2 in ipairs(opt_base_unit) do
				local num_3 = unbox + Vector3(num_2, -3, num)

				self:_spawn_template_unit(world, v_2, num_3)
			end

			local num_4 = num_2 + 1
		else
			local num_5 = unbox + Vector3(0, -3, num)

			self:_spawn_template_unit(world, opt_base_unit, num_5)
		end

		num = num + unbox_2.z
	end

	arg_3_1.freezer_size[1] = 4
	arg_3_1.freezer_size[2] = unbox_2[2] * (arg_3_1.max_pool_size + 1)
	arg_3_1.freezer_size[3] = unbox_2[3] * (arg_3_1.num_pools + 1)
	self.spawn_data = {
		nil,
		Vector3Box(),
		QuaternionBox()
	}
	self._freezer_initialized = true
end

BreedFreezer._spawn_template_unit = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local spawn_unit = World.spawn_unit(arg_4_1, arg_4_2, arg_4_3)

	arg_4_0.breed_template_units[arg_4_2] = spawn_unit

	Unit.disable_animation_state_machine(spawn_unit)
	Unit.disable_physics(spawn_unit)
	Unit.set_unit_visibility(spawn_unit, false)

	if not script_data.debug_breed_freeze then
		QuickDrawerStay:sphere(arg_4_3, 1, Color(0, 200, 0))
	end
end

BreedFreezer.destroy = function (self)
	-- function 5
	self.network_event_delegate:unregister(self)
end

BreedFreezer.try_mark_unit_for_freeze = function (self, arg_6_1, arg_6_2)
	-- function 6
	assert(self._breed_freezer_settings, "[BreedFreezer] 'try_mark_unit_for_freeze' was called before we've initialized the breed freezer")

	local name = arg_6_1.name

	if self._breed_freezer_settings.breeds[name] == nil then
		return false
	end

	local var_6_1 = self.units_to_freeze[name]

	if self.breed_spawn_queues[name]:available() <= #var_6_1 then
		return false
	end

	for i = 1, #var_6_1 do
		if var_6_1[i] == arg_6_2 then
			local rawset = rawset
			local _G = _G
			local str = "DoubleFreezeContext"
			local var_6_5 = rawget(_G, "DoubleFreezeContext")

			var_6_5 = var_6_5 or {}

			rawset(_G, str, var_6_5)

			DoubleFreezeContext[arg_6_2] = true

			print("ERROR: Tried to freeze unit twice in the same frame.", Script.callstack())

			return false
		end
	end

	if not self.breed_spawn_queues[name]:contains(arg_6_2) then
		print("ERROR: Tried to freeze unit twice (it was already in queue).")

		return false
	end

	self.num_to_freeze = self.num_to_freeze + 1
	var_6_1[#var_6_1 + 1] = arg_6_2

	return true
end

BreedFreezer.rpc_breed_freeze_units = function (self, arg_7_1, arg_7_2)
	-- function 7
	fassert(self._freezer_initialized, "Received freeze before freezer was initialized!")

	local unit_storage = Managers.state.unit_storage

	for i = 1, #arg_7_2 do
		local var_7_1 = arg_7_2[i]
		local unit = unit_storage:unit(var_7_1)
		local name = ScriptUnit.has_extension(unit, "ai_system"):breed().name

		fassert(self._breed_freezer_settings.breeds[name], "Can't freeze unit of breed %s", name)

		local var_7_4 = self.units_to_freeze[name]

		fassert(self.breed_spawn_queues[name]:available() > #var_7_4, "Breed freeze queue for breed %s is full.", name)

		self.num_to_freeze = self.num_to_freeze + 1
		var_7_4[#var_7_4 + 1] = unit
	end

	self:commit_freezes()
end

local set_game_object_field = GameSession.set_game_object_field

BreedFreezer.commit_freezes = function (self)
	-- function 8
	if self.num_to_freeze == 0 then
		return
	end

	local unbox = self.freezer_offset:unbox()
	local unbox_2 = self.freezer_pos:unbox()
	local unbox_3 = Vector3Aux.unbox(self._breed_freezer_settings.freezer_size)
	local is_server = self.is_server
	local network = Managers.state.network
	local in_game_session = network:in_game_session()
	local game = network:game()
	local alloc_table = FrameTable.alloc_table()
	local max_breed_freezer_units_per_rpc = NetworkConstants.max_breed_freezer_units_per_rpc

	for k, v in pairs(self.units_to_freeze) do
		local var_8_9 = self.breed_spawn_queues[k]

		for k_2 = 1, #v do
			local var_8_10 = v[k_2]

			v[k_2] = nil

			var_8_9:push_back(var_8_10)
			Managers.state.event:trigger_referenced(var_8_10, "on_unit_freeze")

			local var_8_11 = self.systems_by_breed[k]
			local var_8_12 = self.extension_names_by_breed[k]

			for l = #var_8_11, 1, -1 do
				var_8_11[l]:freeze(var_8_10, var_8_12[l], "reason_unspawn")
			end

			if not Unit.has_animation_state_machine(var_8_10) then
				Unit.disable_animation_state_machine(var_8_10)
			end

			Unit.flow_event(var_8_10, "lua_freeze_unit")
			Unit.disable_physics(var_8_10)

			local get_data = Unit.get_data(var_8_10, "unit_name")
			local var_8_14 = self.breed_template_units[get_data]

			Unit.copy_scene_graph_local_from(var_8_10, var_8_14)

			if not script_data.debug_breed_freeze then
				Unit.set_unit_visibility(var_8_10, false)
			end

			local var_8_15 = Vector3(unbox_3[1] * 0.5, var_8_9.last * unbox[2], self.breed_offsets[k] + unbox[3] * 0.5)

			Unit.set_local_position(var_8_10, 0, unbox_2 + var_8_15)

			FROZEN[var_8_10] = true
			POSITION_LOOKUP[var_8_10] = nil

			Unit.reload_flow(var_8_10)

			self.count = self.count + 1

			Unit.set_frozen(var_8_10, true)

			if not is_server and not in_game_session then
				local unit_game_object_id = network:unit_game_object_id(var_8_10)

				alloc_table[#alloc_table + 1] = unit_game_object_id

				set_game_object_field(game, unit_game_object_id, "position", unbox_2 + var_8_15)

				if max_breed_freezer_units_per_rpc <= #alloc_table then
					fassert(#alloc_table == max_breed_freezer_units_per_rpc, "More than one unit id was added during loop!")
					network.network_transmit:send_rpc_clients("rpc_breed_freeze_units", alloc_table)
					table.clear(alloc_table)
				end
			end

			Managers.state.unit_storage:freeze(var_8_10)
		end
	end

	if not (not is_server and not in_game_session and not (#alloc_table > 0)) then
		network.network_transmit:send_rpc_clients("rpc_breed_freeze_units", alloc_table)
	end

	self.num_to_freeze = 0
end

BreedFreezer.try_unfreeze_breed = function (self, arg_9_1, arg_9_2)
	-- function 9
	assert(self._breed_freezer_settings, "[BreedFreezer] 'try_unfreeze_breed' was called before the breed freezer was initialized")

	local name = arg_9_1.name

	if self._breed_freezer_settings.breeds[name] == nil then
		return nil
	end

	local var_9_1 = self.breed_spawn_queues[name]

	if not var_9_1:is_empty() then
		return nil
	end

	local pop_first = var_9_1:pop_first()

	Managers.state.unit_storage:unfreeze(pop_first)

	local side_id = arg_9_2[7].side_id
	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(pop_first)

	network.network_transmit:send_rpc_clients("rpc_breed_unfreeze_breed", NetworkLookup.breeds[name], arg_9_2[2]:unbox(), arg_9_2[3]:unbox(), side_id, unit_game_object_id)
	self:unfreeze_unit(pop_first, name, arg_9_2)

	return pop_first
end

BreedFreezer.rpc_breed_unfreeze_breed = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6)
	-- function 10
	fassert(self._freezer_initialized, "Received unfreeze before freezer was initialized!")

	local var_10_0 = NetworkLookup.breeds[arg_10_2]
	local pop_first = self.breed_spawn_queues[var_10_0]:pop_first()

	fassert(self._breed_freezer_settings.breeds[var_10_0], "Can't unfreeze unit of breed %s", var_10_0)
	Managers.state.unit_storage:unfreeze(pop_first)

	local go_id = Managers.state.unit_storage:go_id(pop_first)

	fassert(arg_10_6 == go_id, "Server unfreeze unit didn't match local unit in spawn queue")

	local breed = ScriptUnit.has_extension(pop_first, "ai_system"):breed()
	local tbl = {
		side_id = arg_10_5
	}
	local spawn_data = self.spawn_data

	spawn_data[1] = breed

	spawn_data[2]:store(arg_10_3)
	spawn_data[3]:store(arg_10_4)

	spawn_data[7] = tbl

	self:unfreeze_unit(pop_first, var_10_0, spawn_data)
end

BreedFreezer.unfreeze_unit = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	Unit.set_frozen(arg_11_1, false)

	local unbox = arg_11_3[2]:unbox()
	local unbox_2 = arg_11_3[3]:unbox()

	Unit.set_local_position(arg_11_1, 0, unbox)
	Unit.set_local_rotation(arg_11_1, 0, unbox_2)

	POSITION_LOOKUP[arg_11_1] = unbox
	FROZEN[arg_11_1] = nil

	Unit.enable_animation_state_machine(arg_11_1)
	Unit.enable_physics(arg_11_1)
	Unit.flow_event(arg_11_1, "lua_unfreeze_unit")
	Unit.set_unit_visibility(arg_11_1, true)
	Managers.state.blood:clear_unit_decals(arg_11_1)
	Unit.trigger_flow_unit_spawned(arg_11_1)
	World.update_unit(self.world, arg_11_1)

	self.count = self.count - 1

	local var_11_2 = self.systems_by_breed[arg_11_2]
	local var_11_3 = self.extension_names_by_breed[arg_11_2]

	for i = 1, #var_11_2 do
		local var_11_4 = var_11_2[i]

		if not var_11_4.unfreeze then
			var_11_4:unfreeze(arg_11_1, var_11_3[i], arg_11_3)
		end
	end

	Unit.flow_event(arg_11_1, "lua_trigger_variation")

	return arg_11_1
end

function store_go_ids_in_array_func(self, arg_12_1, arg_12_2)
	-- function 12
	self[#self + 1] = arg_12_2[arg_12_1]
end

BreedFreezer.hot_join_sync = function (self, arg_13_1)
	-- function 13
	print("Breedfreezer (server) starting a hot join sync")

	local tbl = {}
	local tbl_2 = {}
	local num = 0
	local num_2 = 1
	local max_breed_freezer_units_per_rpc = NetworkConstants.max_breed_freezer_units_per_rpc
	local var_13_5 = PEER_ID_TO_CHANNEL[arg_13_1]
	local frozen_bimap_goid_unit = Managers.state.unit_storage.frozen_bimap_goid_unit
	local breeds_index_lookup = self._breed_freezer_settings.breeds_index_lookup

	for i = 1, #breeds_index_lookup do
		local var_13_8 = breeds_index_lookup[i]
		local var_13_9 = self.breed_spawn_queues[var_13_8]
		local size = var_13_9:size()

		if max_breed_freezer_units_per_rpc <= size + num then
			printf("\t--> rpc-package size reached, sending rpc now")
			RPC.rpc_breed_freezer_sync_breeds(var_13_5, tbl, tbl_2)
			table.clear(tbl_2)
			table.clear(tbl)

			num = 0
			num_2 = 1
		end

		tbl[num_2 * 2 - 1] = var_13_9.first
		tbl[num_2 * 2 - 0] = size

		printf("\tpacking %d units of breed %s", size, var_13_8)
		var_13_9:foreach(tbl_2, store_go_ids_in_array_func, frozen_bimap_goid_unit)

		num = num + size
		num_2 = num_2 + 1
	end

	if #tbl > 0 then
		printf("\t--> rpc-package size reached, sending rpc now (last package)")
		RPC.rpc_breed_freezer_sync_breeds(var_13_5, tbl, tbl_2)
		table.dump(tbl, "starts")
		table.dump(tbl_2, "breed_go_ids")
	end
end

BreedFreezer.rpc_breed_freezer_sync_breeds = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	if not self._current_synced_breed_index then
		self._current_synced_breed_index = 0
		self._breed_freezer_settings = self:_setup_freezable_breeds(self._enemy_package_loader)
	end

	printf("Breedfreezer (client) received breed syncs num_breeds:%d, total_units:%d", #arg_14_2 / 2, #arg_14_3)

	local _current_synced_breed_index = self._current_synced_breed_index
	local num = 1

	for i = 1, #arg_14_2, 2 do
		_current_synced_breed_index = _current_synced_breed_index + 1

		local var_14_2 = self._breed_freezer_settings.breeds_index_lookup[_current_synced_breed_index]

		fassert(self._breed_freezer_settings.breeds[var_14_2], "Can't freeze unit of breed %s", var_14_2)

		local var_14_3 = arg_14_2[i]
		local var_14_4 = arg_14_2[i + 1]
		local var_14_5 = self.breed_spawn_queues[var_14_2]

		var_14_5.first = var_14_3
		var_14_5.last = var_14_5:index_before(var_14_5.first)

		printf("-->\tgot %d of %s", var_14_4, var_14_2)
		fassert(var_14_5:is_empty(), "Breed freeze queue for breed %s was not empty!", var_14_2)

		local var_14_6 = self.units_to_freeze[var_14_2]

		for j = 1, var_14_4 do
			local var_14_7 = arg_14_3[num]
			local unit = Managers.state.unit_storage:unit(var_14_7)

			var_14_6[#var_14_6 + 1] = unit
			self.num_to_freeze = self.num_to_freeze + 1

			local breed = ScriptUnit.has_extension(unit, "ai_system"):breed()

			fassert(breed.name == var_14_2, "Got wrong expected breed in rpc_breed_freezer_sync_breeds %q ~= %q", breed.name, var_14_2)

			num = num + 1
		end
	end

	self._current_synced_breed_index = _current_synced_breed_index

	print("Breed freezer counts: ", self._current_synced_breed_index, #self._breed_freezer_settings.breeds_index_lookup)

	if self._current_synced_breed_index == #self._breed_freezer_settings.breeds_index_lookup then
		print("Comitting breed freezer frozen units")
		self:commit_freezes()
	end
end
