-- chunkname: @scripts/entity_system/systems/objective/objective_system.lua

local objective_system_testify = not not script_data.testify

require("scripts/entity_system/systems/weaves/weave_essence_handler")
require("scripts/unit_extensions/objectives/base_objective_extension")
require("scripts/unit_extensions/objectives/objective_group_extension")

ObjectiveSystem = class(ObjectiveSystem, ExtensionSystemBase)

local RPCS = {
	"rpc_register_objectives",
	"rpc_activate_objective",
	"rpc_objective_completed"
}
local EXTENSIONS = {
	"ObjectiveGroupExtension",
	"WeaveCapturePointExtension",
	"WeaveTargetExtension",
	"WeaveItemExtension",
	"WeaveLimitedItemSpawnerExtension",
	"WeaveDoomWheelExtension",
	"WeaveInteractionExtension",
	"WeaveKillEnemiesExtension",
	"WeaveSocketExtension",
	"VersusVolumeObjectiveExtension",
	"VersusInteractObjectiveExtension",
	"VersusPayloadObjectiveExtension",
	"VersusSocketObjectiveExtension",
	"VersusTargetObjectiveExtension",
	"VersusMissionObjectiveExtension",
	"VersusCapturePointObjectiveExtension",
	"VersusSurviveEventObjectiveExtension",
	"ObjectiveEventExtension"
}

ObjectiveSystem.init = function (self, entity_system_creation_context, system_name)
	-- function 1
	ExtensionSystemBase.init(self, entity_system_creation_context, system_name, EXTENSIONS)

	local network_event_delegate = entity_system_creation_context.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(RPCS))

	self._game_session = Network.game_session()
	self._entity_system_creation_context = entity_system_creation_context
	self._is_server = entity_system_creation_context.is_server
	self._world = entity_system_creation_context.world
	self._extensions = {}
	self._units = {}
	self._progress_listeners = {}
	self._objective_lists = {}
	self._active_objectives = {}
	self._active_leaf_objectives = {}
	self._active_root_objectives = {}
	self._activated = false
	self._all_objectives_completed = false
	self._objective_by_name = {}
	self._group_by_name = {}
	self._children_by_name = {}
	self._extension_by_sync_object = {}
	self._pending_sync_objects = {}
	self._data_by_name = {}
	self._sync_object_by_name = {}
	self._total_num_main_objectives = 0
	self._total_num_objectives_at_current_list_index = 0
	self._current_objective_list_index = 1
	self._hot_join_sync_completed_objectives = {}

	local game_mode_name = Managers.state.game_mode:game_mode_key()

	if game_mode_name == "weave" then
		self._weave_essence_handler = WeaveEssenceHandler:new(self._world)
		self._weave_manager = Managers.weave
	elseif game_mode_name == "versus" then
		self._is_versus = true
	end

	self._objective_item_spawner = Managers.state.entity:system("objective_item_spawner_system")

	Managers.state.event:register(self, "on_player_joined_party", "_on_player_joined_party")
end

ObjectiveSystem.on_game_entered = function (self)
	-- function 2
	if self._is_server then
		local level_start_objectives = Managers.state.game_mode:level_start_objectives()

		if level_start_objectives then
			self:server_register_objectives(level_start_objectives)
		end
	end
end

ObjectiveSystem.destroy = function (self)
	-- function 3
	self.network_event_delegate:unregister(self)

	local event_manager = Managers.state.event

	if event_manager then
		event_manager:unregister("on_player_joined_party", self)
	end
end

ObjectiveSystem.weave_essence_handler = function (self)
	-- function 4
	return self._weave_essence_handler
end

ObjectiveSystem.game_object_created = function (self, game_session, game_object_id)
	-- function 5
	local objective_name_id = GameSession.game_object_field(game_session, game_object_id, "objective_name")
	local objective_name = NetworkLookup.objective_names[objective_name_id]
	local extension = self._objective_by_name[objective_name]

	if extension then
		extension:sync_objective(game_object_id, game_session)

		self._extension_by_sync_object[game_object_id] = extension
	else
		self._pending_sync_objects[objective_name] = game_object_id
	end
end

ObjectiveSystem.deactivate_all_objectives = function (self)
	-- function 6
	if self._weave_essence_handler then
		self._weave_essence_handler:destroy_all_essence()
	end

	self:_destroy_all_sync_objects()

	local active_objectives = self._active_objectives

	for idx, objective_name in ipairs(active_objectives) do
		local extension = self._objective_by_name[objective_name]

		extension:deactivate()

		if not extension.keep_alive then
			self._objective_item_spawner:destroy_objective(objective_name)
		end

		active_objectives[idx] = nil
	end
end

ObjectiveSystem._destroy_all_sync_objects = function (self, ignore_kill_objectives)
	-- function 7
	local objective_index = self._current_objective_list_index
	local objectives = self._objective_lists[objective_index]

	if objectives then
		for objective_name in pairs(objectives) do
			if ignore_kill_objectives or objective_name ~= "kill_enemies" then
				self:_destroy_sync_object(objective_name)
			end
		end
	end
end

ObjectiveSystem._destroy_sync_object = function (self, objective_name)
	-- function 8
	local game_session = Network.game_session()

	if not game_session then
		return
	end

	local sync_object_id = self._sync_object_by_name[objective_name]

	if sync_object_id then
		self._sync_object_by_name[objective_name] = nil

		GameSession.destroy_game_object(game_session, sync_object_id)
	end
end

ObjectiveSystem.server_register_objectives = function (self, objective_list_name)
	-- function 9
	assert(self._is_server, "[ObjectiveSystem] Only server may register objectives")
	self:_register_objectives(objective_list_name)

	local objective_list_id = NetworkLookup.objective_lists[objective_list_name]

	self.network_transmit:send_rpc_clients("rpc_register_objectives", objective_list_id)
end

ObjectiveSystem._register_objectives = function (self, objective_list_name)
	-- function 10
	assert(not self._objective_list_name, "[ObjectiveSystem] No support implemented for registering multiple sets of objectives. Needs a pass to support this.")

	self._objective_list_name = objective_list_name

	local objective_list = ObjectiveLists[objective_list_name]

	self._objective_lists = objective_list

	local num_main_objectives = 0

	for objective_group_index, objective_set in ipairs(objective_list) do
		num_main_objectives = num_main_objectives + table.size(objective_set)

		for objective_name, objective_data in pairs(objective_set) do
			fassert(not self._data_by_name[objective_name] or objective_name == "kill_enemies", "[ObjectiveSystem] Objective with name %s in group %s was already registered as part of group %s.", objective_name, objective_group_index, self._data_by_name[objective_name])
			self:_register_objective(objective_name, objective_data)
		end
	end

	self._total_num_main_objectives = self._total_num_main_objectives + num_main_objectives
end

ObjectiveSystem._register_objective = function (self, objective_name, objective_data)
	-- function 11
	self._data_by_name[objective_name] = objective_data

	if objective_data.sub_objectives then
		self:_create_group_unit(objective_name, objective_data)

		self._children_by_name[objective_name] = {}

		for sub_objective_name, sub_objective_data in pairs(objective_data.sub_objectives) do
			self._group_by_name[sub_objective_name] = objective_name

			table.insert(self._children_by_name[objective_name], sub_objective_name)
			self:_register_objective(sub_objective_name, sub_objective_data)
			self:_patch_relation(objective_name, sub_objective_name)
		end
	end

	local extension = self._objective_by_name[objective_name]

	if extension then
		extension:set_objective_data(objective_data)
	end
end

ObjectiveSystem._patch_relation = function (self, group_name, sub_objective_name)
	-- function 12
	local group_extension = self._objective_by_name[group_name]
	local child_extension = self._objective_by_name[sub_objective_name]

	if not group_extension or not child_extension then
		return
	end

	group_extension:register_child(child_extension)
end

ObjectiveSystem.server_activate_first_objective = function (self)
	-- function 13
	assert(self._is_server, "[ObjectiveSystem] Only server may activate objectives")
	assert(not self._activated, "[ObjectiveSystem] Already activated the first objective")

	if not self:_activate_objectives_at_index(1) then
		return
	end

	self:objective_started_telemetry(self._current_objective_list_index)
end

ObjectiveSystem._create_group_unit = function (self, objective_name, objective_data)
	-- function 14
	local unit_spawner = Managers.state.unit_spawner
	local objective_unit_template = ObjectiveUnitTemplates.objective_group
	local unit_name = objective_unit_template.unit_name
	local unit_template_name = objective_unit_template.unit_template_name
	local extension_init_data = objective_unit_template.create_extension_init_data_func(objective_name, objective_data, nil)
	local group_unit = unit_spawner:spawn_local_unit_with_extensions(unit_name, unit_template_name, extension_init_data)

	return group_unit
end

ObjectiveSystem._activate_objective = function (self, objective_name)
	-- function 15
	local objective_data = self._data_by_name[objective_name]

	assert(objective_data, "[ObjectiveSystem] Tried activating objective before registering it.")

	if self._is_server then
		self:_check_trigger_start_vo(objective_data)
	end

	if objective_data.vo_context_on_activate then
		local dialogue_system = Managers.state.entity:system("dialogue_system")

		for context_name, context_value in pairs(objective_data.vo_context_on_activate) do
			dialogue_system:set_global_context(context_name, context_value)
		end
	end

	local is_objective_container = self:_is_objective_container(objective_name)

	if is_objective_container then
		local objective_extension = self._objective_by_name[objective_name]

		if objective_extension.activate then
			objective_extension:activate()
		end
	else
		if self._is_server then
			self._objective_item_spawner:spawn_item(objective_name, objective_data)

			local objective_extension = self._objective_by_name[objective_name]

			fassert(objective_extension, "[ObjectiveSystem] Missing unit with objective extension and objective id %s", objective_name)

			local game_object_data_table = {
				value = 0,
				go_type = NetworkLookup.go_types.objective,
				objective_name = NetworkLookup.objective_names[objective_name]
			}

			if objective_extension.initial_sync_data then
				objective_extension:initial_sync_data(game_object_data_table)
			end

			local callback = callback(self, "cb_game_session_disconnect")
			local sync_go_id = Managers.state.network:create_game_object("objective", game_object_data_table, callback)

			self._sync_object_by_name[objective_name] = sync_go_id

			objective_extension:sync_objective(sync_go_id)
		end

		local objective_extension = self._objective_by_name[objective_name]
		local go_id = self._pending_sync_objects[objective_name]

		if go_id then
			objective_extension:sync_objective(go_id)

			self._pending_sync_objects[objective_name] = nil
		end

		if objective_extension.activate then
			objective_extension:activate()
		end

		self._active_leaf_objectives[#self._active_leaf_objectives + 1] = objective_name
	end

	self._active_objectives[#self._active_objectives + 1] = objective_name

	local is_part_of_objective_container = self:_is_part_of_objective_container(objective_name)

	if not is_part_of_objective_container then
		self._active_root_objectives[#self._active_root_objectives + 1] = objective_name
	end

	if is_objective_container then
		local children = self._children_by_name[objective_name]

		for _, sub_objective_name in ipairs(children) do
			if not self._hot_join_sync_completed_objectives[sub_objective_name] then
				self:_activate_objective(sub_objective_name)
			end
		end
	end
end

ObjectiveSystem.cb_game_session_disconnect = function (self, go_id)
	-- function 16
	local extension = self._extension_by_sync_object[go_id]

	if extension then
		extension:desync_objective()

		self._extension_by_sync_object[go_id] = nil
	end
end

ObjectiveSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data)
	-- function 17
	local progress_listener = Unit.get_data(unit, "listen_to_progress")

	if progress_listener then
		local listeners = not not self._progress_listeners[progress_listener]

		listeners[0] = #listeners + 1
		listeners[listeners[0]] = unit
		self._progress_listeners[progress_listener] = listeners
	end

	local extension

	if extension_name == "ObjectiveEventExtension" then
		extension = {}
	else
		local extension_alias = self.NAME
		local extension_pool_table

		extension = ScriptUnit.add_extension(self.extension_init_context, unit, extension_name, extension_alias, extension_init_data, extension_pool_table)
	end

	self.extensions[extension_name] = not not self.extensions[extension_name] + 1
	self._units[extension] = unit
	self._extensions[unit] = extension

	if extension_name == "ObjectiveEventExtension" then
		return extension
	end

	local objective_name = extension:objective_name()

	if objective_name and objective_name ~= "" then
		local objective_data = self._data_by_name[objective_name]

		if objective_data then
			extension:set_objective_data(objective_data)
		end

		local spawn_template = self._objective_item_spawner:template_by_unit(unit)

		if not spawn_template then
			self._objective_by_name[objective_name] = extension

			local group_name = self._group_by_name[objective_name]

			if group_name then
				self:_patch_relation(group_name, objective_name)
			end
		end
	end

	return extension
end

ObjectiveSystem.on_remove_extension = function (self, unit, ...)
	-- function 18
	ObjectiveSystem.super.on_remove_extension(self, unit, ...)

	local extension = self._extensions[unit]

	self._units[extension] = nil
	self._extensions[unit] = nil
end

ObjectiveSystem.update = function (self, context, t)
	-- function 19
	if script_data.testify then
		Testify:poll_requests_through_handler(objective_system_testify, self)
	end

	local dt = context.dt

	if self._weave_essence_handler then
		self._weave_essence_handler:update(dt, t)
	end

	if not self._activated or Managers.state.game_mode:is_game_mode_ended() then
		return
	end

	if self._is_server then
		self:_update_server(dt, t)
	else
		self:_update_client(dt, t)
	end
end

ObjectiveSystem._on_player_joined_party = function (self, peer_id, local_player_id, party_id, slot_id, is_bot)
	-- function 20
	if is_bot or peer_id ~= Network.peer_id() then
		return
	end

	local extensions = self._extensions

	for unit, extension in pairs(extensions) do
		Unit.flow_event(unit, "local_player_party_changed")
	end
end

ObjectiveSystem.game_object_destroyed = function (self, game_session, game_object_id)
	-- function 21
	local objective_name_id = GameSession.game_object_field(game_session, game_object_id, "objective_name")
	local objective_name = NetworkLookup.objective_names[objective_name_id]

	self._pending_sync_objects[objective_name] = game_object_id

	local objective_extension = self._extension_by_sync_object[game_object_id]

	if objective_extension then
		objective_extension:desync_objective()

		self._extension_by_sync_object[game_object_id] = nil
	end
end

ObjectiveSystem._update_server = function (self, dt, t)
	-- function 22
	local active_objectives = self._active_objectives
	local active_leaf_objectives = self._active_leaf_objectives
	local active_root_objectives = self._active_root_objectives
	local objects_to_remove = {}

	self:_update_objective_vo()

	for idx, objective_name in ipairs(active_objectives) do
		local extension = self._objective_by_name[objective_name]

		extension:update(dt, t)
		self:_update_progress_listeners(objective_name)

		if extension:is_done() then
			objects_to_remove[#objects_to_remove + 1] = idx
		end
	end

	for i = #objects_to_remove, 1, -1 do
		local index = objects_to_remove[i]
		local objective_name = table.remove(active_objectives, index)
		local leaf_index = table.index_of(active_leaf_objectives, objective_name)

		if leaf_index then
			table.remove(active_leaf_objectives, leaf_index)
		end

		local root_index = table.index_of(active_root_objectives, objective_name)

		if root_index then
			table.remove(active_root_objectives, root_index)
		end

		local extension = self._objective_by_name[objective_name]

		self:_complete_objective_server(extension, objects_to_remove)
	end

	self:_update_activate_objectives()
end

ObjectiveSystem._update_client = function (self, dt, t)
	-- function 23
	local active_objectives = self._active_objectives

	for _, objective_name in pairs(active_objectives) do
		local extension = self._objective_by_name[objective_name]

		extension:update(dt, t)
		self:_update_progress_listeners(objective_name)
	end
end

ObjectiveSystem._update_progress_listeners = function (self, objective_name)
	-- function 24
	local extension = self._objective_by_name[objective_name]
	local progress = extension:get_percentage_done()
	local unit = self._units[extension]

	Unit.set_data(unit, "objective_progress", progress)
	Unit.flow_event(unit, "objective_progress_update")

	local progress_listeners = self._progress_listeners
	local listeners = progress_listeners[objective_name]

	if listeners then
		local num_listeners = listeners[0]

		for i = 1, num_listeners do
			local listener = listeners[i]

			Unit.set_data(listener, "objective_progress", progress)
			Unit.flow_event(listener, "objective_progress_update")
		end
	end
end

ObjectiveSystem._update_activate_objectives = function (self)
	-- function 25
	local num_update_list = #self._active_objectives
	local only_kill_objective_left = num_update_list > 0

	for i = 1, num_update_list do
		if self._active_objectives[i] ~= "kill_enemies" then
			only_kill_objective_left = false

			break
		end
	end

	if num_update_list == 0 or only_kill_objective_left then
		local next_objective_index = self._current_objective_list_index + 1
		local next_objectives = self._objective_lists[next_objective_index]

		if self._weave_manager then
			self._weave_manager:objective_set_completed()
		end

		if next_objectives then
			self:_destroy_all_sync_objects(false)
			self:_activate_objectives_at_index(next_objective_index)
			self:objective_started_telemetry(self._current_objective_list_index)

			self._main_objective_scratch = {}
		elseif not only_kill_objective_left then
			self:_destroy_all_sync_objects(true)

			self._activated = false
			self._all_objectives_completed = true
		end
	end
end

ObjectiveSystem._complete_objective_server = function (self, extension, objects_to_remove)
	-- function 26
	local objective_name = extension:objective_name()
	local objective_data = self._data_by_name[objective_name]

	self:_check_trigger_complete_vo(objective_data)

	if objective_data.vo_context_on_complete then
		local dialogue_system = Managers.state.entity:system("dialogue_system")

		for context_name, context_value in pairs(objective_data.vo_context_on_complete) do
			if type(context_value) == "function" then
				context_value = context_value(dialogue_system:get_global_context(context_name))
			end

			dialogue_system:set_global_context(context_name, context_value)
		end
	end

	if self._weave_manager then
		self._weave_manager:increase_bar_score(not not extension:get_score_for_completion())
	end

	if not extension.keep_alive then
		self._objective_item_spawner:destroy_objective(objective_name)
	end

	LevelHelper:flow_event(self._world, "objective_completed_" .. objective_name)
	LevelHelper:flow_event(self._world, "objective_completed")

	if self:_is_last_active_objective(objective_name) then
		Managers.state.event:trigger("objective_group_completed")

		local game_mode_manager = Managers.state.game_mode
		local game_mode = game_mode_manager:game_mode()
		local settings = game_mode_manager:settings()

		if settings.move_dead_players_after_objective_completed then
			local adventure_spawning = game_mode:adventure_spawning()

			adventure_spawning:set_move_dead_players_to_next_respawn(true)
		end
	end

	local is_root_objective = self:is_root_objective(objective_name)
	local is_leaf_objective = self:is_leaf_objective(objective_name)
	local is_last_leaf_objective = self:is_last_leaf_objective(objective_name)

	extension:complete(is_root_objective, is_leaf_objective, is_last_leaf_objective)
	Managers.state.event:trigger("objective_completed", extension, objective_data)

	local objective_name_id = NetworkLookup.objective_names[objective_name]

	self.network_transmit:send_rpc_clients("rpc_objective_completed", objective_name_id)
end

ObjectiveSystem._is_last_active_objective = function (self, objective_name)
	-- function 27
	return self._active_objectives[2] == nil and self._active_objectives[1] == objective_name
end

ObjectiveSystem.is_root_objective = function (self, objective_name)
	-- function 28
	return self:_is_part_of_objective_container(objective_name)
end

ObjectiveSystem.is_leaf_objective = function (self, objective_name)
	-- function 29
	return not self:_is_objective_container(objective_name)
end

ObjectiveSystem.is_last_leaf_objective = function (self, objective_name)
	-- function 30
	return not not self:is_leaf_objective(objective_name)
end

ObjectiveSystem._get_first_objective = function (self)
	-- function 31
	local objective_name = self._active_objectives[1]
	local extension = self._objective_by_name[objective_name]
	local objective_data = self._data_by_name[objective_name]

	return extension, objective_data, objective_name
end

ObjectiveSystem._get_first_leaf_objective = function (self)
	-- function 32
	local objective_name = self._active_leaf_objectives[1]
	local extension = self._objective_by_name[objective_name]
	local objective_data = self._data_by_name[objective_name]

	return extension, objective_data, objective_name
end

ObjectiveSystem.first_active_leaf_objective_unit = function (self)
	-- function 33
	local extension = self:_get_first_leaf_objective()

	return not not extension and not not extension:unit()
end

ObjectiveSystem.first_active_objective_name = function (self)
	-- function 34
	return self._active_objectives[1]
end

ObjectiveSystem.first_active_root_objective_name = function (self)
	-- function 35
	return self._active_root_objectives[1]
end

ObjectiveSystem.first_active_objective_description = function (self)
	-- function 36
	local active_objectives = self:active_objectives()

	for i = 1, #active_objectives do
		local objective_name = active_objectives[i]
		local extension = self._objective_by_name[objective_name]
		local objective_data = self._data_by_name[objective_name]
		local description = not not extension:description()

		if description then
			return Localize(description)
		end
	end

	return string.format("<MISSING DESCRIPTION FOR OBJECTIVE '%s'>", self:first_active_objective_name())
end

ObjectiveSystem.current_objective_progress = function (self)
	-- function 37
	local active_root_objectives = self:active_root_objectives()
	local num_root_objectives = self._total_num_objectives_at_current_list_index
	local total_progress = 0
	local num_active = #active_root_objectives

	if num_active == 0 then
		return 0
	end

	for i = 1, num_active do
		local extension = self._objective_by_name[active_root_objectives[i]]

		if extension.get_percentage_done then
			total_progress = total_progress + extension:get_percentage_done()
		else
			total_progress = extension:is_done() and (not not 1 or not not 0) or not extension:is_done() and not not 0
		end
	end

	total_progress = total_progress + (num_root_objectives - num_active)

	return total_progress / num_root_objectives
end

ObjectiveSystem.current_objective_icon = function (self)
	-- function 38
	local active_objectives = self:active_objectives()

	for i = 1, #active_objectives do
		local objective_name = active_objectives[i]
		local extension = self._objective_by_name[objective_name]
		local objective_data = self._data_by_name[objective_name]
		local objective_icon = not not extension:objective_icon()

		if objective_icon then
			return objective_icon
		end
	end

	return "icons_placeholder"
end

ObjectiveSystem.current_objective_type = function (self)
	-- function 39
	local active_objectives = self:active_objectives()

	for i = 1, #active_objectives do
		local objective_name = active_objectives[i]
		local extension = self._objective_by_name[objective_name]
		local objective_data = self._data_by_name[objective_name]
		local objective_type = not not extension:objective_type()

		if objective_type then
			return objective_type
		end
	end

	return "objective_reach"
end

ObjectiveSystem.current_objectives_position = function (self)
	-- function 40
	if not self._objective_lists then
		return
	end

	local positions = {}
	local active_leafs = self:active_leaf_objectives()

	for i = 1, #active_leafs do
		local objective_name = active_leafs[i]
		local extension = self._objective_by_name[objective_name]
		local unit = extension:unit()

		if Unit.alive(unit) then
			positions[#positions + 1] = Unit.world_position(unit, 0)
		end
	end

	return positions
end

ObjectiveSystem.objective_started_telemetry = function (self, objective_id)
	-- function 41
	if not self._is_versus then
		return
	end

	local match_id = Managers.mechanism:game_mechanism():match_id()
	local objective_list = self._objective_lists[objective_id]
	local objective_name = next(objective_list)
	local game_round = Managers.mechanism:game_mechanism():total_rounds_started()

	Managers.telemetry_events:versus_objective_started(match_id, objective_id, game_round, objective_name)
end

ObjectiveSystem.objective_section_completed_telemetry = function (self, current_section, total_sections)
	-- function 42
	if not self._is_versus then
		return
	end

	current_section = not not current_section or not not 1
	total_sections = not not total_sections or not not 1

	local match_id = Managers.mechanism:game_mechanism():match_id()
	local objective_id = self._current_objective_list_index
	local objective_list = self._objective_lists[objective_id]
	local objective_name = next(objective_list)
	local game_round = Managers.mechanism:game_mechanism():total_rounds_started()

	Managers.telemetry_events:versus_objective_section_completed(match_id, objective_id, game_round, objective_name, current_section, total_sections)
end

ObjectiveSystem.is_active = function (self)
	-- function 43
	return self._activated
end

ObjectiveSystem.all_objectives_completed = function (self)
	-- function 44
	return self._all_objectives_completed
end

ObjectiveSystem.hot_join_sync = function (self, peer_id)
	-- function 45
	local objective_list_name = self._objective_list_name

	if not objective_list_name then
		return
	end

	local channel_id = PEER_ID_TO_CHANNEL[peer_id]
	local objective_list_id = NetworkLookup.objective_lists[objective_list_name]

	RPC.rpc_register_objectives(channel_id, objective_list_id)

	if not table.is_empty(self._active_objectives) then
		local objective_list = self._objective_lists[self._current_objective_list_index]
		local completed_objectives_bit_field = self:_write_hot_join_sync_completed_objectives(objective_list)

		RPC.rpc_activate_objective(channel_id, self._current_objective_list_index, completed_objectives_bit_field)
	end
end

ObjectiveSystem.active_objectives = function (self)
	-- function 46
	return self._active_objectives
end

ObjectiveSystem.active_leaf_objectives = function (self)
	-- function 47
	return self._active_leaf_objectives
end

ObjectiveSystem.active_root_objectives = function (self)
	-- function 48
	return self._active_root_objectives
end

ObjectiveSystem.extension_by_objective_name = function (self, objective_name)
	-- function 49
	return self._objective_by_name[objective_name]
end

ObjectiveSystem.current_objective_index = function (self)
	-- function 50
	return self._current_objective_list_index
end

ObjectiveSystem.num_main_objectives = function (self)
	-- function 51
	return self._total_num_main_objectives
end

ObjectiveSystem.num_current_sub_objectives = function (self)
	-- function 52
	return self._total_num_objectives_at_current_list_index
end

ObjectiveSystem.num_completed_main_objectives = function (self)
	-- function 53
	return self._current_objective_list_index - 1
end

ObjectiveSystem.num_current_completed_sub_objectives = function (self)
	-- function 54
	return self._total_num_objectives_at_current_list_index - #self._active_root_objectives
end

ObjectiveSystem.on_ai_killed = function (self, killed_unit, killer_unit, death_data, killing_blow)
	-- function 55
	if self._weave_essence_handler then
		self._weave_essence_handler:on_ai_killed(killed_unit, killer_unit, death_data, killing_blow)
	end

	local update_list = self._active_objectives

	for _, objective_name in pairs(update_list) do
		local extension = self._objective_by_name[objective_name]

		if extension.on_ai_killed then
			extension:on_ai_killed(killed_unit, killer_unit, death_data, killing_blow)
		end
	end
end

ObjectiveSystem.rpc_register_objectives = function (self, sender, objective_name_id)
	-- function 56
	local objective_name = NetworkLookup.objective_lists[objective_name_id]

	self:_register_objectives(objective_name)
end

ObjectiveSystem._read_hot_join_sync_completed_objectives = function (self, objective_list, completed_objectives_bit_field, optional_offset)
	-- function 57
	optional_offset = not not optional_offset or not not 0

	for objective_name, objective_data in pairs(objective_list) do
		local is_completed = bit.band(bit.rshift(completed_objectives_bit_field, optional_offset), 1)

		if is_completed ~= 0 then
			self._hot_join_sync_completed_objectives[objective_name] = true
		end

		optional_offset = optional_offset + 1

		if objective_data.sub_objectives then
			optional_offset = self:_read_hot_join_sync_completed_objectives(objective_data.sub_objectives, completed_objectives_bit_field, optional_offset)
		end
	end

	return optional_offset
end

ObjectiveSystem._write_hot_join_sync_completed_objectives = function (self, objective_list, optional_completed_objectives_bit_field, optional_offset)
	-- function 58
	optional_offset = not not optional_offset or not not 0
	optional_completed_objectives_bit_field = not not optional_completed_objectives_bit_field or not not 0

	for objective_name, objective_data in pairs(objective_list) do
		local is_completed = not table.contains(self._active_objectives, objective_name)

		if is_completed then
			optional_completed_objectives_bit_field = bit.bor(bit.lshift(1, optional_offset), optional_completed_objectives_bit_field)
		end

		optional_offset = optional_offset + 1

		if objective_data.sub_objectives then
			optional_completed_objectives_bit_field, optional_offset = self:_write_hot_join_sync_completed_objectives(objective_data.sub_objectives, optional_completed_objectives_bit_field, optional_offset)
		end
	end

	return optional_completed_objectives_bit_field, optional_offset
end

ObjectiveSystem.rpc_activate_objective = function (self, sender, objective_index, completed_objectives_bit_field)
	-- function 59
	assert(objective_index > self._current_objective_list_index or not not table.is_empty(self._active_objectives), "[ObjectiveSystem] Reactivating objective or activating old objective")
	self:_read_hot_join_sync_completed_objectives(self._objective_lists[objective_index], completed_objectives_bit_field)
	self:_activate_objectives_at_index(objective_index)
end

ObjectiveSystem._activate_objectives_at_index = function (self, objective_index)
	-- function 60
	table.clear(self._active_objectives)
	table.clear(self._active_root_objectives)
	table.clear(self._active_leaf_objectives)

	self._total_num_objectives_at_current_list_index = 0

	local objective_list = self._objective_lists[objective_index]

	if table.is_empty(objective_list) then
		self._activated = false
		self._all_objectives_completed = true

		return false
	end

	self._activated = true
	self._all_objectives_completed = false
	self._current_objective_list_index = objective_index

	for objective_name in pairs(objective_list) do
		if not self._hot_join_sync_completed_objectives[objective_name] then
			self:_activate_objective(objective_name)

			self._total_num_objectives_at_current_list_index = self._total_num_objectives_at_current_list_index + 1
		end
	end

	if self._is_server then
		self.network_transmit:send_rpc_clients("rpc_activate_objective", objective_index, 0)
	end

	return true
end

ObjectiveSystem._is_objective_container = function (self, objective_name)
	-- function 61
	return not not self._children_by_name[objective_name]
end

ObjectiveSystem._is_part_of_objective_container = function (self, objective_name)
	-- function 62
	return not not self._group_by_name[objective_name]
end

ObjectiveSystem.rpc_objective_completed = function (self, sender, objective_name_id)
	-- function 63
	local objective_name = NetworkLookup.objective_names[objective_name_id]

	table.remove(self._active_objectives, table.index_of(self._active_objectives, objective_name))

	local active_leaf_objectives = self._active_leaf_objectives
	local leaf_index = table.index_of(active_leaf_objectives, objective_name)

	if leaf_index then
		table.remove(active_leaf_objectives, leaf_index)
	end

	local active_root_objectives = self._active_root_objectives
	local root_index = table.index_of(active_root_objectives, objective_name)

	if root_index then
		table.remove(active_root_objectives, root_index)
		printf("[ObjectiveSystem] Completed root objective: %s", objective_name)
	else
		printf("[ObjectiveSystem] Completed sub objective: %s", objective_name)
	end

	local is_root_objective = self:is_root_objective(objective_name)
	local is_leaf_objective = self:is_leaf_objective(objective_name)
	local is_last_leaf_objective = self:is_last_leaf_objective(objective_name)
	local extension = self._objective_by_name[objective_name]

	extension:complete(is_root_objective, is_leaf_objective, is_last_leaf_objective)

	local objective_data = self._data_by_name[objective_name]

	Managers.state.event:trigger("objective_completed", extension, objective_data)
end

ObjectiveSystem.complete_objective = function (self, objective_name)
	-- function 64
	self._objective_by_name[objective_name]._completed = true
end

ObjectiveSystem.get_remaining_objectives_list = function (self)
	-- function 65
	return table.slice(self._objective_lists, self._current_objective_list_index, #self._objective_lists)
end

ObjectiveSystem._update_objective_vo = function (self)
	-- function 66
	local current_objectives = self._objective_lists[self._current_objective_list_index]

	for _, objective_data in pairs(current_objectives) do
		if objective_data.almost_done and not self._main_objective_scratch.almost_done_vo_played then
			local almost_done = objective_data:almost_done(self._active_objectives)

			if almost_done then
				self._main_objective_scratch.almost_done_vo_played = true

				local dialogue_system = Managers.state.entity:system("dialogue_system")

				dialogue_system:queue_mission_giver_event("vs_mg_heroes_objective_almost_completed")

				break
			end
		end
	end
end

ObjectiveSystem._check_trigger_complete_vo = function (self, objective_data)
	-- function 67
	if objective_data.play_complete_vo then
		local dialogue_system = Managers.state.entity:system("dialogue_system")

		dialogue_system:queue_mission_giver_event("vs_mg_heroes_objective_completed")
	elseif objective_data.play_safehouse_vo then
		local dialogue_system = Managers.state.entity:system("dialogue_system")

		dialogue_system:queue_mission_giver_event("vs_mg_heroes_reached_safe_room")
	elseif objective_data.play_waystone_vo then
		local dialogue_system = Managers.state.entity:system("dialogue_system")

		dialogue_system:queue_mission_giver_event("vs_mg_heroes_reached_waystone")
	elseif objective_data.play_dialogue_event_on_complete then
		local dialogue_event = objective_data.dialogue_event
		local dialogue_system = Managers.state.entity:system("dialogue_system")

		dialogue_system:queue_mission_giver_event(dialogue_event)
	end
end

ObjectiveSystem._check_trigger_start_vo = function (self, objective_data)
	-- function 68
	if objective_data.play_arrive_vo then
		local dialogue_system = Managers.state.entity:system("dialogue_system")

		dialogue_system:queue_mission_giver_event("vs_mg_heroes_objective_reached")
	end
end
