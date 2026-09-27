-- chunkname: @scripts/network/unit_spawner.lua

require("scripts/settings/unit_spawner_settings")
require("scripts/settings/spawn_unit_templates")

local scripts_network_unit_extension_templates = require("scripts/network/unit_extension_templates")

local function fn(self, arg_1_1)
	-- function 1
	local var_1_0 = self[arg_1_1]

	if not var_1_0 then
		return
	end

	for k, v in pairs(var_1_0) do
		v(arg_1_1)
	end

	self[arg_1_1] = nil
end

local alive = Unit.alive

UnitSpawner = class(UnitSpawner)

UnitSpawner.init = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	self.world = arg_2_1
	self.entity_manager = arg_2_2
	self.unit_storage = nil
	self.is_server = arg_2_3
	self.unit_deletion_information = {}
	self.deletion_queue = GrowQueue:new()
	self.temp_deleted_units_list = {}
	self.unit_unique_id = 0
	self.game_session = nil
	self.unit_synchronizer = nil
	self.own_peer_id = nil
	self.gameobject_functor_context = nil
	self.gameobject_initializers = nil
	self.gameobject_extractors = nil
	self.pending_extension_adds_map = {}
	self.pending_extension_adds_list = {}
	self.pending_extension_adds_list_n = 0
	self.unit_destroy_listeners = {}
	self.unit_destroy_listeners_post_cleanup = {}
	self.unit_death_watch_list = {}
	self.unit_death_watch_lookup = {}
	self.unit_death_watch_list_n = 0
	self.unit_death_watch_list_dirty = false
	self._async_spawn_queue = {}
	self._async_spawn_handle = 0
	self._spawned_async_units = {}
end

UnitSpawner.destroy = function (self)
	-- function 3
	GarbageLeakDetector.register_object(self, "UnitSpawner")

	self.unit_destroy_listeners = nil
	self.entity_manager = nil
end

UnitSpawner.set_gameobject_initializer_data = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	self.game_session = Network.game_session()

	fassert(self.game_session, "No game session when initializing game object")

	self.own_peer_id = Network.peer_id()

	fassert(self.own_peer_id, "No own peer id when initializing game object")

	self.gameobject_functor_context = arg_4_3
	self.gameobject_initializers = arg_4_1
	self.gameobject_extractors = arg_4_2
end

UnitSpawner.set_unit_storage = function (self, arg_5_1)
	-- function 5
	self.unit_storage = arg_5_1
end

UnitSpawner.set_gameobject_to_unit_creator_function = function (self, arg_6_1)
	-- function 6
	self.create_unit_from_gameobject_function = arg_6_1
end

UnitSpawner.set_unit_template_lookup_table = function (self, arg_7_1)
	-- function 7
	self.unit_template_lut = arg_7_1
end

UnitSpawner.push_unit_to_death_watch_list = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	self:freeze_unit_extensions(arg_8_1, arg_8_2, arg_8_3)

	self.unit_death_watch_list_n = self.unit_death_watch_list_n + 1
	self.unit_death_watch_list[self.unit_death_watch_list_n] = {
		unit = arg_8_1,
		t = arg_8_2,
		data = arg_8_3
	}
	self.unit_death_watch_lookup[arg_8_1] = self.unit_death_watch_list[self.unit_death_watch_list_n]
end

UnitSpawner.freeze_unit_extensions = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local is_husk_unit = NetworkUnit.is_husk_unit(arg_9_1)
	local extensions_to_remove_on_death = scripts_network_unit_extension_templates.extensions_to_remove_on_death(arg_9_3.breed.unit_template, is_husk_unit, self.is_server)

	if not extensions_to_remove_on_death then
		self.entity_manager:freeze_extensions(arg_9_1, extensions_to_remove_on_death)
	end
end

UnitSpawner.prioritize_death_watch_unit = function (self, arg_10_1, arg_10_2)
	-- function 10
	local var_10_0 = self.unit_death_watch_lookup[arg_10_1]

	if not var_10_0 then
		var_10_0.t = arg_10_2
		self.unit_death_watch_list_dirty = true
	end
end

UnitSpawner.breed_in_death_watch = function (self, arg_11_1)
	-- function 11
	local unit_death_watch_list = self.unit_death_watch_list

	for i = 1, self.unit_death_watch_list_n do
		local unit = unit_death_watch_list[i].unit
		local var_11_2 = BLACKBOARDS[unit]

		if not (not var_11_2 and arg_11_1 ~= var_11_2.breed.name) then
			return true
		end
	end
end

local function fn_2(self, arg_12_1)
	-- function 12
	return self.t < arg_12_1.t
end

UnitSpawner.update_death_watch_list = function (self)
	-- function 13
	if not self.unit_death_watch_list_dirty then
		table.sort(self.unit_death_watch_list, fn_2)

		self.unit_death_watch_list_dirty = false
	end

	local max_num_ragdolls = RagdollSettings.max_num_ragdolls
	local min_num_ragdolls = RagdollSettings.min_num_ragdolls
	local num = Managers.state.conflict:total_num_ai_spawned() + self.unit_death_watch_list_n

	if max_num_ragdolls < num then
		local min = math.min(num - max_num_ragdolls, self.unit_death_watch_list_n)

		if min_num_ragdolls > self.unit_death_watch_list_n - min then
			min = min - min_num_ragdolls
		end

		for i = 1, min do
			local var_13_4

			if i < self.unit_death_watch_list_n then
				var_13_4 = self.unit_death_watch_list[i]

				local var_13_5 = self.unit_death_watch_list[self.unit_death_watch_list_n]

				self.unit_death_watch_list[i] = var_13_5
				self.unit_death_watch_lookup[var_13_5.unit] = self.unit_death_watch_list[i]
				self.unit_death_watch_list[self.unit_death_watch_list_n] = nil
				self.unit_death_watch_lookup[var_13_4.unit] = nil
			else
				var_13_4 = self.unit_death_watch_list[self.unit_death_watch_list_n]
				self.unit_death_watch_list[self.unit_death_watch_list_n] = nil
				self.unit_death_watch_lookup[var_13_4.unit] = nil
			end

			self.unit_death_watch_list_n = math.max(self.unit_death_watch_list_n - 1, 0)
			var_13_4.data.remove = true
		end

		self.unit_death_watch_list_dirty = true
	end
end

UnitSpawner.mark_for_deletion = function (self, arg_14_1)
	-- function 14
	fassert(alive(arg_14_1), "Tried to destroy a unit (%s) that was already destroyed.", tostring(arg_14_1))
	self.deletion_queue:push_back(arg_14_1)

	local var_14_0 = self.unit_death_watch_lookup[arg_14_1]

	if not var_14_0 then
		local find = table.find(self.unit_death_watch_list, var_14_0)
		local var_14_2 = self.unit_death_watch_list[self.unit_death_watch_list_n]

		self.unit_death_watch_list[find] = var_14_2
		self.unit_death_watch_lookup[var_14_2.unit] = self.unit_death_watch_list[find]
		self.unit_death_watch_list[self.unit_death_watch_list_n] = nil
		self.unit_death_watch_lookup[var_14_0.unit] = nil
		self.unit_death_watch_list_n = math.max(self.unit_death_watch_list_n - 1, 0)
		self.unit_death_watch_list_dirty = true
	end
end

UnitSpawner.is_marked_for_deletion = function (self, arg_15_1)
	-- function 15
	return (self.deletion_queue:contains(arg_15_1))
end

UnitSpawner.commit_and_remove_pending_units = function (self)
	-- function 16
	local num = 0
	local num_2 = 0

	repeat
		-- Nothing
	until self:commit_pending_unit_system_registrations() + self:remove_units_marked_for_deletion() == 0
end

UnitSpawner.commit_pending_unit_system_registrations = function (self)
	-- function 17
	fassert(not self.locked)

	local pending_extension_adds_list_n = self.pending_extension_adds_list_n

	if pending_extension_adds_list_n == 0 then
		return 0
	end

	local pending_extension_adds_map = self.pending_extension_adds_map
	local pending_extension_adds_list = self.pending_extension_adds_list
	local num = 0

	for k, v in pairs(pending_extension_adds_map) do
		pending_extension_adds_map[k] = nil
		num = num + 1
		pending_extension_adds_list[num] = k
	end

	fassert(num == pending_extension_adds_list_n)
	self.entity_manager:register_units_extensions(pending_extension_adds_list, pending_extension_adds_list_n)

	self.pending_extension_adds_list_n = 0

	return pending_extension_adds_list_n
end

UnitSpawner.remove_units_marked_for_deletion = function (self)
	-- function 18
	fassert(not self.locked)

	local pending_extension_adds_map = self.pending_extension_adds_map
	local pending_extension_adds_list_n = self.pending_extension_adds_list_n
	local num = 0
	local entity_manager = self.entity_manager
	local event = Managers.state.event
	local world = self.world
	local world_delete_units = self.world_delete_units
	local temp_deleted_units_list = self.temp_deleted_units_list
	local unit_storage = self.unit_storage
	local unit_destroy_listeners = self.unit_destroy_listeners
	local unit_destroy_listeners_post_cleanup = self.unit_destroy_listeners_post_cleanup
	local pop_first = self.deletion_queue:pop_first()

	if not alive(pop_first) then
		local num_2 = 0

		fn(unit_destroy_listeners, pop_first)
		Unit.flow_event(pop_first, "cleanup_before_destroy")

		local num_3 = num_2 + 1

		temp_deleted_units_list[num_3] = pop_first

		if not (pending_extension_adds_list_n > 0) or not pending_extension_adds_map[pop_first] then
			pending_extension_adds_map[pop_first] = nil
			pending_extension_adds_list_n = pending_extension_adds_list_n - 1
		end

		event:unregister_referenced_all(pop_first)
		entity_manager:unregister_units(temp_deleted_units_list, num_3)

		for i = 1, num_3 do
			fn(unit_destroy_listeners_post_cleanup, temp_deleted_units_list[i])
		end

		world_delete_units(self, world, temp_deleted_units_list, num_3)

		num = num + num_3
	end

	self.pending_extension_adds_list_n = pending_extension_adds_list_n

	return num
end

UnitSpawner.spawn_local_unit = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	-- function 19
	local spawn_unit = World.spawn_unit(self.world, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	local unit_unique_id = self.unit_unique_id

	self.unit_unique_id = unit_unique_id + 1

	Unit.set_data(spawn_unit, "unique_id", unit_unique_id)
	Unit.set_data(spawn_unit, "unit_name", arg_19_1)

	POSITION_LOOKUP[spawn_unit] = Unit.world_position(spawn_unit, 0)

	return spawn_unit
end

local tbl = {}

UnitSpawner.create_unit_extensions = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	-- function 20
	if not self.entity_manager:add_unit_extensions(arg_20_1, arg_20_2, arg_20_3, arg_20_4) then
		if not not self.locked then
			tbl[1] = arg_20_2

			self.entity_manager:register_units_extensions(tbl, 1)
		else
			self.pending_extension_adds_list_n = self.pending_extension_adds_list_n + 1
			self.pending_extension_adds_map[arg_20_2] = true
		end
	end
end

UnitSpawner.spawn_local_unit_with_extensions = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6)
	-- function 21
	local spawn_local_unit = self:spawn_local_unit(arg_21_1, arg_21_4, arg_21_5, arg_21_6)

	arg_21_2 = arg_21_2 or Unit.get_data(spawn_local_unit, "unit_template")

	self:create_unit_extensions(self.world, spawn_local_unit, arg_21_2, arg_21_3)

	return spawn_local_unit, arg_21_2
end

UnitSpawner.spawn_network_unit = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6)
	-- function 22
	local spawn_local_unit_with_extensions, var_22_1 = self:spawn_local_unit_with_extensions(arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6)
	local var_22_2 = self.unit_template_lut[var_22_1]

	NetworkUnit.add_unit(spawn_local_unit_with_extensions)
	NetworkUnit.set_is_husk_unit(spawn_local_unit_with_extensions, false)

	local go_type = var_22_2.go_type
	local var_22_4 = self.gameobject_initializers[go_type](spawn_local_unit_with_extensions, arg_22_1, var_22_2, self.gameobject_functor_context)
	local create_game_object = GameSession.create_game_object(self.game_session, go_type, var_22_4)

	self.unit_storage:add_unit_info(spawn_local_unit_with_extensions, create_game_object, go_type, self.own_peer_id)
	self.entity_manager:sync_unit_extensions(spawn_local_unit_with_extensions, create_game_object)

	return spawn_local_unit_with_extensions, create_game_object
end

UnitSpawner.queue_spawn_network_unit = function (self, ...)
	-- function 23
	local _async_spawn_queue = self._async_spawn_queue
	local _async_spawn_handle = self._async_spawn_handle

	self._async_spawn_handle = _async_spawn_handle + 1

	local pack_temp_types = Managers.state.network.network_transmit:pack_temp_types(nil, ...)

	_async_spawn_queue[#_async_spawn_queue + 1] = {
		handle = _async_spawn_handle,
		unpack(pack_temp_types)
	}

	return _async_spawn_handle
end

UnitSpawner.remove_queued_network_unit = function (self, arg_24_1)
	-- function 24
	local var_24_0 = self._spawned_async_units[arg_24_1]

	if not var_24_0 then
		self:mark_for_deletion(var_24_0)

		return
	end

	local _async_spawn_queue = self._async_spawn_queue

	for i = #_async_spawn_queue, 1, -1 do
		if _async_spawn_queue[i].handle == arg_24_1 then
			table.remove(_async_spawn_queue, i)

			break
		end
	end
end

UnitSpawner.spawn_queued_units = function (self)
	-- function 25
	local _async_spawn_queue = self._async_spawn_queue

	for i = 1, #_async_spawn_queue do
		local var_25_1 = _async_spawn_queue[i]

		Managers.state.network.network_transmit:unpack_temp_types(var_25_1)

		local spawn_network_unit = self:spawn_network_unit(unpack(var_25_1))

		self._async_spawn_queue[i] = nil
		self._spawned_async_units[var_25_1.handle] = spawn_network_unit
	end
end

UnitSpawner.try_claim_async_unit = function (self, arg_26_1)
	-- function 26
	local var_26_0 = self._spawned_async_units[arg_26_1]

	self._spawned_async_units[arg_26_1] = nil

	return var_26_0
end

UnitSpawner.request_spawn_template_unit = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6)
	-- function 27
	arg_27_6 = arg_27_6 or 1

	local var_27_0 = NetworkLookup.spawn_unit_templates[arg_27_1]
	local go_id = Managers.state.unit_storage:go_id(arg_27_4)

	Managers.state.network.network_transmit:send_rpc_server("rpc_request_spawn_template_unit", var_27_0, arg_27_2, arg_27_3, go_id, arg_27_5, arg_27_6)
end

UnitSpawner.world_delete_units = function (self, arg_28_1, arg_28_2, arg_28_3)
	-- function 28
	local game_session = self.game_session
	local unit_storage = self.unit_storage

	if not game_session then
		for i = 1, arg_28_3 do
			local var_28_2 = arg_28_2[i]
			local var_28_3, var_28_4 = alive(var_28_2)
			local go_id = unit_storage:go_id(var_28_2)

			if not var_28_3 then
				fassert(false)
			end

			if not go_id then
				GameSession.destroy_game_object(game_session, go_id)
				unit_storage:remove(var_28_2, go_id)
				NetworkUnit.remove_unit(var_28_2)
			end

			POSITION_LOOKUP[var_28_2] = nil

			Unit.flow_event(var_28_2, "unit_despawned")
			World.destroy_unit(arg_28_1, var_28_2)
		end
	else
		for j = 1, arg_28_3 do
			local var_28_6 = arg_28_2[j]
			local var_28_7, var_28_8 = alive(var_28_6)

			if not var_28_7 then
				fassert(false)
			end

			local go_id_2 = unit_storage:go_id(var_28_6)

			if not go_id_2 then
				unit_storage:remove(var_28_6, go_id_2)
				NetworkUnit.remove_unit(var_28_6)
			end

			POSITION_LOOKUP[var_28_6] = nil

			Unit.flow_event(var_28_6, "unit_despawned")
			World.destroy_unit(arg_28_1, var_28_6)
		end
	end
end

UnitSpawner.spawn_unit_from_game_object = function (self, arg_29_1, arg_29_2, arg_29_3)
	-- function 29
	local create_unit_from_gameobject_function = self.create_unit_from_gameobject_function(self, self.game_session, arg_29_1, arg_29_3)

	NetworkUnit.add_unit(create_unit_from_gameobject_function)
	NetworkUnit.set_is_husk_unit(create_unit_from_gameobject_function, true)

	local go_type = arg_29_3.go_type

	self.unit_storage:add_unit_info(create_unit_from_gameobject_function, arg_29_1, go_type, arg_29_2)

	local var_29_2 = self.gameobject_extractors[go_type]

	fassert(type(var_29_2) == "function")

	local var_29_3, var_29_4 = var_29_2(self.game_session, arg_29_1, arg_29_2, create_unit_from_gameobject_function, self.gameobject_functor_context)
	local flag = true

	self:create_unit_extensions(self.world, create_unit_from_gameobject_function, var_29_3, var_29_4, flag)

	return create_unit_from_gameobject_function
end

UnitSpawner.destroy_game_object_unit = function (self, arg_30_1, arg_30_2)
	-- function 30
	local unit_storage = self.unit_storage
	local var_30_1 = unit_storage:units()[arg_30_1]

	fassert(var_30_1, "Couldn't find unit with go_id %d", arg_30_1)

	if not Unit.is_frozen(var_30_1) then
		FROZEN[var_30_1] = nil

		Unit.set_frozen(var_30_1, false)
	end

	self.entity_manager:game_object_unit_destroyed(var_30_1)
	self:mark_for_deletion(var_30_1)
	unit_storage:remove(var_30_1, arg_30_1)
end

UnitSpawner.add_destroy_listener = function (self, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
	-- function 31
	local unit_destroy_listeners_post_cleanup

	if not arg_31_4 then
		unit_destroy_listeners_post_cleanup = self.unit_destroy_listeners_post_cleanup

		if not unit_destroy_listeners_post_cleanup then
			-- Nothing
		end
	end

	unit_destroy_listeners_post_cleanup = self.unit_destroy_listeners

	::label_31_0::

	local var_31_1 = unit_destroy_listeners_post_cleanup[arg_31_1]

	if not var_31_1 then
		var_31_1 = {}
		unit_destroy_listeners_post_cleanup[arg_31_1] = var_31_1
	end

	fassert(var_31_1[arg_31_2] == nil, "Tried to register a unit destroy listener identifier (%s) twice for the same unit %s", tostring(arg_31_2), tostring(arg_31_1))

	var_31_1[arg_31_2] = arg_31_3
end

UnitSpawner.remove_destroy_listener = function (self, arg_32_1, arg_32_2, arg_32_3)
	-- function 32
	local unit_destroy_listeners_post_cleanup

	if not arg_32_3 then
		unit_destroy_listeners_post_cleanup = self.unit_destroy_listeners_post_cleanup

		if not unit_destroy_listeners_post_cleanup then
			-- Nothing
		end
	end

	unit_destroy_listeners_post_cleanup = self.unit_destroy_listeners

	::label_32_0::

	local var_32_1 = unit_destroy_listeners_post_cleanup[arg_32_1]

	if not var_32_1 then
		var_32_1[arg_32_2] = nil
	else
		printf("[UnitSpawner] [%s] failed to remove listener [%s] from unit [%s]", self.identifier_tag, tostring(arg_32_2), tostring(arg_32_1))
	end
end
