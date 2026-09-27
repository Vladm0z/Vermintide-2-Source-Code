-- chunkname: @scripts/entity_system/systems/objective/objective_system.lua

local testify = script_data.testify

testify = not testify and require("scripts/entity_system/systems/objective/objective_system_testify")

require("scripts/entity_system/systems/weaves/weave_essence_handler")
require("scripts/unit_extensions/objectives/base_objective_extension")
require("scripts/unit_extensions/objectives/objective_group_extension")

ObjectiveSystem = class(ObjectiveSystem, ExtensionSystemBase)

local tbl = {
	"rpc_register_objectives",
	"rpc_activate_objective",
	"rpc_objective_completed"
}
local tbl_2 = {
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

ObjectiveSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	ExtensionSystemBase.init(self, arg_1_1, arg_1_2, tbl_2)

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))

	self._game_session = Network.game_session()
	self._entity_system_creation_context = arg_1_1
	self._is_server = arg_1_1.is_server
	self._world = arg_1_1.world
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

	local game_mode_key = Managers.state.game_mode:game_mode_key()

	if game_mode_key == "weave" then
		self._weave_essence_handler = WeaveEssenceHandler:new(self._world)
		self._weave_manager = Managers.weave
	elseif game_mode_key == "versus" then
		self._is_versus = true
	end

	self._objective_item_spawner = Managers.state.entity:system("objective_item_spawner_system")

	Managers.state.event:register(self, "on_player_joined_party", "_on_player_joined_party")
end

ObjectiveSystem.on_game_entered = function (self)
	-- function 2
	if not self._is_server then
		local level_start_objectives = Managers.state.game_mode:level_start_objectives()

		if not level_start_objectives then
			self:server_register_objectives(level_start_objectives)
		end
	end
end

ObjectiveSystem.destroy = function (self)
	-- function 3
	self.network_event_delegate:unregister(self)

	local event = Managers.state.event

	if not event then
		event:unregister("on_player_joined_party", self)
	end
end

ObjectiveSystem.weave_essence_handler = function (self)
	-- function 4
	return self._weave_essence_handler
end

ObjectiveSystem.game_object_created = function (self, arg_5_1, arg_5_2)
	-- function 5
	local game_object_field = GameSession.game_object_field(arg_5_1, arg_5_2, "objective_name")
	local var_5_1 = NetworkLookup.objective_names[game_object_field]
	local var_5_2 = self._objective_by_name[var_5_1]

	if not var_5_2 then
		var_5_2:sync_objective(arg_5_2, arg_5_1)

		self._extension_by_sync_object[arg_5_2] = var_5_2
	else
		self._pending_sync_objects[var_5_1] = arg_5_2
	end
end

ObjectiveSystem.deactivate_all_objectives = function (self)
	-- function 6
	if not self._weave_essence_handler then
		self._weave_essence_handler:destroy_all_essence()
	end

	self:_destroy_all_sync_objects()

	local _active_objectives = self._active_objectives

	for i, v in ipairs(_active_objectives) do
		local var_6_1 = self._objective_by_name[v]

		var_6_1:deactivate()

		if not var_6_1.keep_alive then
			self._objective_item_spawner:destroy_objective(v)
		end

		_active_objectives[i] = nil
	end
end

ObjectiveSystem._destroy_all_sync_objects = function (self, arg_7_1)
	-- function 7
	local _current_objective_list_index = self._current_objective_list_index
	local var_7_1 = self._objective_lists[_current_objective_list_index]

	if not var_7_1 then
		for k in pairs(var_7_1) do
			if not (arg_7_1 or k == "kill_enemies") then
				self:_destroy_sync_object(k)
			end
		end
	end
end

ObjectiveSystem._destroy_sync_object = function (self, arg_8_1)
	-- function 8
	local game_session = Network.game_session()

	if not game_session then
		return
	end

	local var_8_1 = self._sync_object_by_name[arg_8_1]

	if not var_8_1 then
		self._sync_object_by_name[arg_8_1] = nil

		GameSession.destroy_game_object(game_session, var_8_1)
	end
end

ObjectiveSystem.server_register_objectives = function (self, arg_9_1)
	-- function 9
	assert(self._is_server, "[ObjectiveSystem] Only server may register objectives")
	self:_register_objectives(arg_9_1)

	local var_9_0 = NetworkLookup.objective_lists[arg_9_1]

	self.network_transmit:send_rpc_clients("rpc_register_objectives", var_9_0)
end

ObjectiveSystem._register_objectives = function (self, arg_10_1)
	-- function 10
	assert(not self._objective_list_name, "[ObjectiveSystem] No support implemented for registering multiple sets of objectives. Needs a pass to support this.")

	self._objective_list_name = arg_10_1

	local var_10_0 = ObjectiveLists[arg_10_1]

	self._objective_lists = var_10_0

	local num = 0

	for i, v in ipairs(var_10_0) do
		num = num + table.size(v)

		for k, v_2 in pairs(v) do
			fassert(not self._data_by_name[k] and k == "kill_enemies", "[ObjectiveSystem] Objective with name %s in group %s was already registered as part of group %s.", k, i, self._data_by_name[k])
			self:_register_objective(k, v_2)
		end
	end

	self._total_num_main_objectives = self._total_num_main_objectives + num
end

ObjectiveSystem._register_objective = function (self, arg_11_1, arg_11_2)
	-- function 11
	self._data_by_name[arg_11_1] = arg_11_2

	if not arg_11_2.sub_objectives then
		self:_create_group_unit(arg_11_1, arg_11_2)

		self._children_by_name[arg_11_1] = {}

		for k, v in pairs(arg_11_2.sub_objectives) do
			self._group_by_name[k] = arg_11_1

			table.insert(self._children_by_name[arg_11_1], k)
			self:_register_objective(k, v)
			self:_patch_relation(arg_11_1, k)
		end
	end

	local var_11_0 = self._objective_by_name[arg_11_1]

	if not var_11_0 then
		var_11_0:set_objective_data(arg_11_2)
	end
end

ObjectiveSystem._patch_relation = function (self, arg_12_1, arg_12_2)
	-- function 12
	local var_12_0 = self._objective_by_name[arg_12_1]
	local var_12_1 = self._objective_by_name[arg_12_2]

	if not (not var_12_0 and var_12_1) then
		return
	end

	var_12_0:register_child(var_12_1)
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

ObjectiveSystem._create_group_unit = function (arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	local unit_spawner = Managers.state.unit_spawner
	local objective_group = ObjectiveUnitTemplates.objective_group
	local unit_name = objective_group.unit_name
	local unit_template_name = objective_group.unit_template_name
	local create_extension_init_data_func = objective_group.create_extension_init_data_func(arg_14_1, arg_14_2, nil)

	return (unit_spawner:spawn_local_unit_with_extensions(unit_name, unit_template_name, create_extension_init_data_func))
end

ObjectiveSystem._activate_objective = function (self, arg_15_1)
	-- function 15
	local var_15_0 = self._data_by_name[arg_15_1]

	assert(var_15_0, "[ObjectiveSystem] Tried activating objective before registering it.")

	if not self._is_server then
		self:_check_trigger_start_vo(var_15_0)
	end

	if not var_15_0.vo_context_on_activate then
		local system = Managers.state.entity:system("dialogue_system")

		for k, v in pairs(var_15_0.vo_context_on_activate) do
			system:set_global_context(k, v)
		end
	end

	local _is_objective_container = self:_is_objective_container(arg_15_1)

	if not _is_objective_container then
		local var_15_3 = self._objective_by_name[arg_15_1]

		if not var_15_3.activate then
			var_15_3:activate()
		end
	else
		if not self._is_server then
			self._objective_item_spawner:spawn_item(arg_15_1, var_15_0)

			local var_15_4 = self._objective_by_name[arg_15_1]

			fassert(var_15_4, "[ObjectiveSystem] Missing unit with objective extension and objective id %s", arg_15_1)

			local tbl = {
				value = 0,
				go_type = NetworkLookup.go_types.objective,
				objective_name = NetworkLookup.objective_names[arg_15_1]
			}

			if not var_15_4.initial_sync_data then
				var_15_4:initial_sync_data(tbl)
			end

			local var_15_6 = callback(self, "cb_game_session_disconnect")
			local create_game_object = Managers.state.network:create_game_object("objective", tbl, var_15_6)

			self._sync_object_by_name[arg_15_1] = create_game_object

			var_15_4:sync_objective(create_game_object)
		end

		local var_15_8 = self._objective_by_name[arg_15_1]
		local var_15_9 = self._pending_sync_objects[arg_15_1]

		if not var_15_9 then
			var_15_8:sync_objective(var_15_9)

			self._pending_sync_objects[arg_15_1] = nil
		end

		if not var_15_8.activate then
			var_15_8:activate()
		end

		self._active_leaf_objectives[#self._active_leaf_objectives + 1] = arg_15_1
	end

	self._active_objectives[#self._active_objectives + 1] = arg_15_1

	if not self:_is_part_of_objective_container(arg_15_1) then
		self._active_root_objectives[#self._active_root_objectives + 1] = arg_15_1
	end

	if not _is_objective_container then
		local var_15_10 = self._children_by_name[arg_15_1]

		for i, v_2 in ipairs(var_15_10) do
			if not self._hot_join_sync_completed_objectives[v_2] then
				self:_activate_objective(v_2)
			end
		end
	end
end

ObjectiveSystem.cb_game_session_disconnect = function (self, arg_16_1)
	-- function 16
	local var_16_0 = self._extension_by_sync_object[arg_16_1]

	if not var_16_0 then
		var_16_0:desync_objective()

		self._extension_by_sync_object[arg_16_1] = nil
	end
end

ObjectiveSystem.on_add_extension = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	-- function 17
	local get_data = Unit.get_data(arg_17_2, "listen_to_progress")

	if not get_data then
		local var_17_1 = self._progress_listeners[get_data]

		var_17_1 = var_17_1 or {}
		var_17_1[0] = #var_17_1 + 1
		var_17_1[var_17_1[0]] = arg_17_2
		self._progress_listeners[get_data] = var_17_1
	end

	local var_17_2

	if arg_17_3 == "ObjectiveEventExtension" then
		var_17_2 = {}
	else
		local NAME = self.NAME
		local var_17_4

		var_17_2 = ScriptUnit.add_extension(self.extension_init_context, arg_17_2, arg_17_3, NAME, arg_17_4, var_17_4)
	end

	local extensions = self.extensions
	local var_17_6 = self.extensions[arg_17_3]

	var_17_6 = var_17_6 or 0
	extensions[arg_17_3] = var_17_6 + 1
	self._units[var_17_2] = arg_17_2
	self._extensions[arg_17_2] = var_17_2

	if arg_17_3 == "ObjectiveEventExtension" then
		return var_17_2
	end

	local objective_name = var_17_2:objective_name()

	if not (not objective_name and objective_name == "") then
		local var_17_8 = self._data_by_name[objective_name]

		if not var_17_8 then
			var_17_2:set_objective_data(var_17_8)
		end

		if not self._objective_item_spawner:template_by_unit(arg_17_2) then
			self._objective_by_name[objective_name] = var_17_2

			local var_17_9 = self._group_by_name[objective_name]

			if not var_17_9 then
				self:_patch_relation(var_17_9, objective_name)
			end
		end
	end

	return var_17_2
end

ObjectiveSystem.on_remove_extension = function (self, arg_18_1, ...)
	-- function 18
	ObjectiveSystem.super.on_remove_extension(self, arg_18_1, ...)

	local var_18_0 = self._extensions[arg_18_1]

	self._units[var_18_0] = nil
	self._extensions[arg_18_1] = nil
end

ObjectiveSystem.update = function (self, arg_19_1, arg_19_2)
	-- function 19
	if not script_data.testify then
		Testify:poll_requests_through_handler(testify, self)
	end

	local dt = arg_19_1.dt

	if not self._weave_essence_handler then
		self._weave_essence_handler:update(dt, arg_19_2)
	end

	if not self._activated and not Managers.state.game_mode:is_game_mode_ended() then
		return
	end

	if not self._is_server then
		self:_update_server(dt, arg_19_2)
	else
		self:_update_client(dt, arg_19_2)
	end
end

ObjectiveSystem._on_player_joined_party = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	-- function 20
	if not (arg_20_5 or arg_20_1 == Network.peer_id()) then
		return
	end

	local _extensions = self._extensions

	for k, v in pairs(_extensions) do
		Unit.flow_event(k, "local_player_party_changed")
	end
end

ObjectiveSystem.game_object_destroyed = function (self, arg_21_1, arg_21_2)
	-- function 21
	local game_object_field = GameSession.game_object_field(arg_21_1, arg_21_2, "objective_name")
	local var_21_1 = NetworkLookup.objective_names[game_object_field]

	self._pending_sync_objects[var_21_1] = arg_21_2

	local var_21_2 = self._extension_by_sync_object[arg_21_2]

	if not var_21_2 then
		var_21_2:desync_objective()

		self._extension_by_sync_object[arg_21_2] = nil
	end
end

ObjectiveSystem._update_server = function (self, arg_22_1, arg_22_2)
	-- function 22
	local _active_objectives = self._active_objectives
	local _active_leaf_objectives = self._active_leaf_objectives
	local _active_root_objectives = self._active_root_objectives
	local tbl = {}

	self:_update_objective_vo()

	for i, v in ipairs(_active_objectives) do
		local var_22_4 = self._objective_by_name[v]

		var_22_4:update(arg_22_1, arg_22_2)
		self:_update_progress_listeners(v)

		if not var_22_4:is_done() then
			tbl[#tbl + 1] = i
		end
	end

	for k = #tbl, 1, -1 do
		local var_22_5 = tbl[k]
		local remove = table.remove(_active_objectives, var_22_5)
		local index_of = table.index_of(_active_leaf_objectives, remove)

		if not index_of then
			table.remove(_active_leaf_objectives, index_of)
		end

		local index_of_2 = table.index_of(_active_root_objectives, remove)

		if not index_of_2 then
			table.remove(_active_root_objectives, index_of_2)
		end

		local var_22_9 = self._objective_by_name[remove]

		self:_complete_objective_server(var_22_9, tbl)
	end

	self:_update_activate_objectives()
end

ObjectiveSystem._update_client = function (self, arg_23_1, arg_23_2)
	-- function 23
	local _active_objectives = self._active_objectives

	for k, v in pairs(_active_objectives) do
		self._objective_by_name[v]:update(arg_23_1, arg_23_2)
		self:_update_progress_listeners(v)
	end
end

ObjectiveSystem._update_progress_listeners = function (self, arg_24_1)
	-- function 24
	local var_24_0 = self._objective_by_name[arg_24_1]
	local get_percentage_done = var_24_0:get_percentage_done()
	local var_24_2 = self._units[var_24_0]

	Unit.set_data(var_24_2, "objective_progress", get_percentage_done)
	Unit.flow_event(var_24_2, "objective_progress_update")

	local var_24_3 = self._progress_listeners[arg_24_1]

	if not var_24_3 then
		local var_24_4 = var_24_3[0]

		for i = 1, var_24_4 do
			local var_24_5 = var_24_3[i]

			Unit.set_data(var_24_5, "objective_progress", get_percentage_done)
			Unit.flow_event(var_24_5, "objective_progress_update")
		end
	end
end

ObjectiveSystem._update_activate_objectives = function (self)
	-- function 25
	local count = #self._active_objectives
	local flag = count > 0

	for i = 1, count do
		if self._active_objectives[i] ~= "kill_enemies" then
			flag = false

			break
		end
	end

	if count == 0 or not flag then
		local num = self._current_objective_list_index + 1
		local var_25_3 = self._objective_lists[num]

		if not self._weave_manager then
			self._weave_manager:objective_set_completed()
		end

		if not var_25_3 then
			self:_destroy_all_sync_objects(false)
			self:_activate_objectives_at_index(num)
			self:objective_started_telemetry(self._current_objective_list_index)

			self._main_objective_scratch = {}
		elseif not flag then
			self:_destroy_all_sync_objects(true)

			self._activated = false
			self._all_objectives_completed = true
		end
	end
end

ObjectiveSystem._complete_objective_server = function (self, arg_26_1, arg_26_2)
	-- function 26
	local objective_name = arg_26_1:objective_name()
	local var_26_1 = self._data_by_name[objective_name]

	self:_check_trigger_complete_vo(var_26_1)

	if not var_26_1.vo_context_on_complete then
		local system = Managers.state.entity:system("dialogue_system")

		for k, v in pairs(var_26_1.vo_context_on_complete) do
			if type(v) == "function" then
				v = v(system:get_global_context(k))
			end

			system:set_global_context(k, v)
		end
	end

	if not self._weave_manager then
		local _weave_manager = self._weave_manager
		local var_26_4 = _weave_manager
		local increase_bar_score = _weave_manager.increase_bar_score
		local get_score_for_completion = arg_26_1:get_score_for_completion()

		get_score_for_completion = get_score_for_completion or 0

		increase_bar_score(var_26_4, get_score_for_completion)
	end

	if not arg_26_1.keep_alive then
		self._objective_item_spawner:destroy_objective(objective_name)
	end

	LevelHelper:flow_event(self._world, "objective_completed_" .. objective_name)
	LevelHelper:flow_event(self._world, "objective_completed")

	if not self:_is_last_active_objective(objective_name) then
		Managers.state.event:trigger("objective_group_completed")

		local game_mode = Managers.state.game_mode
		local game_mode_2 = game_mode:game_mode()

		if not game_mode:settings().move_dead_players_after_objective_completed then
			game_mode_2:adventure_spawning():set_move_dead_players_to_next_respawn(true)
		end
	end

	local is_root_objective = self:is_root_objective(objective_name)
	local is_leaf_objective = self:is_leaf_objective(objective_name)
	local is_last_leaf_objective = self:is_last_leaf_objective(objective_name)

	arg_26_1:complete(is_root_objective, is_leaf_objective, is_last_leaf_objective)
	Managers.state.event:trigger("objective_completed", arg_26_1, var_26_1)

	local var_26_12 = NetworkLookup.objective_names[objective_name]

	self.network_transmit:send_rpc_clients("rpc_objective_completed", var_26_12)
end

ObjectiveSystem._is_last_active_objective = function (self, arg_27_1)
	-- function 27
	return self._active_objectives[2] ~= nil or self._active_objectives[1] == arg_27_1
end

ObjectiveSystem.is_root_objective = function (self, arg_28_1)
	-- function 28
	return self:_is_part_of_objective_container(arg_28_1)
end

ObjectiveSystem.is_leaf_objective = function (self, arg_29_1)
	-- function 29
	return not self:_is_objective_container(arg_29_1)
end

ObjectiveSystem.is_last_leaf_objective = function (self, arg_30_1)
	-- function 30
	local is_leaf_objective = self:is_leaf_objective(arg_30_1)

	is_leaf_objective = not is_leaf_objective and table.is_empty(self._active_leaf_objectives)

	return is_leaf_objective
end

ObjectiveSystem._get_first_objective = function (self)
	-- function 31
	local var_31_0 = self._active_objectives[1]
	local var_31_1 = self._objective_by_name[var_31_0]
	local var_31_2 = self._data_by_name[var_31_0]

	return var_31_1, var_31_2, var_31_0
end

ObjectiveSystem._get_first_leaf_objective = function (self)
	-- function 32
	local var_32_0 = self._active_leaf_objectives[1]
	local var_32_1 = self._objective_by_name[var_32_0]
	local var_32_2 = self._data_by_name[var_32_0]

	return var_32_1, var_32_2, var_32_0
end

ObjectiveSystem.first_active_leaf_objective_unit = function (self)
	-- function 33
	local _get_first_leaf_objective = self:_get_first_leaf_objective()

	return not _get_first_leaf_objective and _get_first_leaf_objective:unit()
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
		local var_36_1 = active_objectives[i]
		local var_36_2 = self._objective_by_name[var_36_1]
		local var_36_3 = self._data_by_name[var_36_1]
		local description = var_36_2:description()

		description = description or var_36_3.description

		if not description then
			return Localize(description)
		end
	end

	return string.format("<MISSING DESCRIPTION FOR OBJECTIVE '%s'>", self:first_active_objective_name())
end

ObjectiveSystem.current_objective_progress = function (self)
	-- function 37
	local active_root_objectives = self:active_root_objectives()
	local _total_num_objectives_at_current_list_index = self._total_num_objectives_at_current_list_index
	local num = 0
	local count = #active_root_objectives

	if count == 0 then
		return 0
	end

	for i = 1, count do
		local var_37_4 = self._objective_by_name[active_root_objectives[i]]

		if not var_37_4.get_percentage_done then
			num = num + var_37_4:get_percentage_done()
		else
			num = not var_37_4:is_done() and 1 and 0
		end
	end

	return (num + (_total_num_objectives_at_current_list_index - count)) / _total_num_objectives_at_current_list_index
end

ObjectiveSystem.current_objective_icon = function (self)
	-- function 38
	local active_objectives = self:active_objectives()

	for i = 1, #active_objectives do
		local var_38_1 = active_objectives[i]
		local var_38_2 = self._objective_by_name[var_38_1]
		local var_38_3 = self._data_by_name[var_38_1]
		local objective_icon = var_38_2:objective_icon()

		objective_icon = objective_icon or var_38_3.objective_type

		if not objective_icon then
			return objective_icon
		end
	end

	return "icons_placeholder"
end

ObjectiveSystem.current_objective_type = function (self)
	-- function 39
	local active_objectives = self:active_objectives()

	for i = 1, #active_objectives do
		local var_39_1 = active_objectives[i]
		local var_39_2 = self._objective_by_name[var_39_1]
		local var_39_3 = self._data_by_name[var_39_1]
		local objective_type = var_39_2:objective_type()

		objective_type = objective_type or var_39_3.objective_type

		if not objective_type then
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

	local tbl = {}
	local active_leaf_objectives = self:active_leaf_objectives()

	for i = 1, #active_leaf_objectives do
		local var_40_2 = active_leaf_objectives[i]
		local unit = self._objective_by_name[var_40_2]:unit()

		if not Unit.alive(unit) then
			tbl[#tbl + 1] = Unit.world_position(unit, 0)
		end
	end

	return tbl
end

ObjectiveSystem.objective_started_telemetry = function (self, arg_41_1)
	-- function 41
	if not self._is_versus then
		return
	end

	local match_id = Managers.mechanism:game_mechanism():match_id()
	local var_41_1 = self._objective_lists[arg_41_1]
	local var_41_2 = next(var_41_1)
	local total_rounds_started = Managers.mechanism:game_mechanism():total_rounds_started()

	Managers.telemetry_events:versus_objective_started(match_id, arg_41_1, total_rounds_started, var_41_2)
end

ObjectiveSystem.objective_section_completed_telemetry = function (self, arg_42_1, arg_42_2)
	-- function 42
	if not self._is_versus then
		return
	end

	arg_42_1 = arg_42_1 or 1
	arg_42_2 = arg_42_2 or 1

	local match_id = Managers.mechanism:game_mechanism():match_id()
	local _current_objective_list_index = self._current_objective_list_index
	local var_42_2 = self._objective_lists[_current_objective_list_index]
	local var_42_3 = next(var_42_2)
	local total_rounds_started = Managers.mechanism:game_mechanism():total_rounds_started()

	Managers.telemetry_events:versus_objective_section_completed(match_id, _current_objective_list_index, total_rounds_started, var_42_3, arg_42_1, arg_42_2)
end

ObjectiveSystem.is_active = function (self)
	-- function 43
	return self._activated
end

ObjectiveSystem.all_objectives_completed = function (self)
	-- function 44
	return self._all_objectives_completed
end

ObjectiveSystem.hot_join_sync = function (self, arg_45_1)
	-- function 45
	local _objective_list_name = self._objective_list_name

	if not _objective_list_name then
		return
	end

	local var_45_1 = PEER_ID_TO_CHANNEL[arg_45_1]
	local var_45_2 = NetworkLookup.objective_lists[_objective_list_name]

	RPC.rpc_register_objectives(var_45_1, var_45_2)

	if not table.is_empty(self._active_objectives) then
		local var_45_3 = self._objective_lists[self._current_objective_list_index]
		local _write_hot_join_sync_completed_objectives = self:_write_hot_join_sync_completed_objectives(var_45_3)

		RPC.rpc_activate_objective(var_45_1, self._current_objective_list_index, _write_hot_join_sync_completed_objectives)
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

ObjectiveSystem.extension_by_objective_name = function (self, arg_49_1)
	-- function 49
	return self._objective_by_name[arg_49_1]
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

ObjectiveSystem.on_ai_killed = function (self, arg_55_1, arg_55_2, arg_55_3, arg_55_4)
	-- function 55
	if not self._weave_essence_handler then
		self._weave_essence_handler:on_ai_killed(arg_55_1, arg_55_2, arg_55_3, arg_55_4)
	end

	local _active_objectives = self._active_objectives

	for k, v in pairs(_active_objectives) do
		local var_55_1 = self._objective_by_name[v]

		if not var_55_1.on_ai_killed then
			var_55_1:on_ai_killed(arg_55_1, arg_55_2, arg_55_3, arg_55_4)
		end
	end
end

ObjectiveSystem.rpc_register_objectives = function (self, arg_56_1, arg_56_2)
	-- function 56
	local var_56_0 = NetworkLookup.objective_lists[arg_56_2]

	self:_register_objectives(var_56_0)
end

ObjectiveSystem._read_hot_join_sync_completed_objectives = function (self, arg_57_1, arg_57_2, arg_57_3)
	-- function 57
	arg_57_3 = arg_57_3 or 0

	for k, v in pairs(arg_57_1) do
		if bit.band(bit.rshift(arg_57_2, arg_57_3), 1) ~= 0 then
			self._hot_join_sync_completed_objectives[k] = true
		end

		arg_57_3 = arg_57_3 + 1

		if not v.sub_objectives then
			arg_57_3 = self:_read_hot_join_sync_completed_objectives(v.sub_objectives, arg_57_2, arg_57_3)
		end
	end

	return arg_57_3
end

ObjectiveSystem._write_hot_join_sync_completed_objectives = function (self, arg_58_1, arg_58_2, arg_58_3)
	-- function 58
	arg_58_3 = arg_58_3 or 0
	arg_58_2 = arg_58_2 or 0

	for k, v in pairs(arg_58_1) do
		if not not table.contains(self._active_objectives, k) then
			arg_58_2 = bit.bor(bit.lshift(1, arg_58_3), arg_58_2)
		end

		arg_58_3 = arg_58_3 + 1

		if not v.sub_objectives then
			arg_58_2, arg_58_3 = self:_write_hot_join_sync_completed_objectives(v.sub_objectives, arg_58_2, arg_58_3)
		end
	end

	return arg_58_2, arg_58_3
end

ObjectiveSystem.rpc_activate_objective = function (self, arg_59_1, arg_59_2, arg_59_3)
	-- function 59
	assert(arg_59_2 > self._current_objective_list_index or table.is_empty(self._active_objectives), "[ObjectiveSystem] Reactivating objective or activating old objective")
	self:_read_hot_join_sync_completed_objectives(self._objective_lists[arg_59_2], arg_59_3)
	self:_activate_objectives_at_index(arg_59_2)
end

ObjectiveSystem._activate_objectives_at_index = function (self, arg_60_1)
	-- function 60
	table.clear(self._active_objectives)
	table.clear(self._active_root_objectives)
	table.clear(self._active_leaf_objectives)

	self._total_num_objectives_at_current_list_index = 0

	local var_60_0 = self._objective_lists[arg_60_1]

	if not table.is_empty(var_60_0) then
		self._activated = false
		self._all_objectives_completed = true

		return false
	end

	self._activated = true
	self._all_objectives_completed = false
	self._current_objective_list_index = arg_60_1

	for k in pairs(var_60_0) do
		if not self._hot_join_sync_completed_objectives[k] then
			self:_activate_objective(k)

			self._total_num_objectives_at_current_list_index = self._total_num_objectives_at_current_list_index + 1
		end
	end

	if not self._is_server then
		self.network_transmit:send_rpc_clients("rpc_activate_objective", arg_60_1, 0)
	end

	return true
end

ObjectiveSystem._is_objective_container = function (self, arg_61_1)
	-- function 61
	return not not self._children_by_name[arg_61_1]
end

ObjectiveSystem._is_part_of_objective_container = function (self, arg_62_1)
	-- function 62
	return not not self._group_by_name[arg_62_1]
end

ObjectiveSystem.rpc_objective_completed = function (self, arg_63_1, arg_63_2)
	-- function 63
	local var_63_0 = NetworkLookup.objective_names[arg_63_2]

	table.remove(self._active_objectives, table.index_of(self._active_objectives, var_63_0))

	local _active_leaf_objectives = self._active_leaf_objectives
	local index_of = table.index_of(_active_leaf_objectives, var_63_0)

	if not index_of then
		table.remove(_active_leaf_objectives, index_of)
	end

	local _active_root_objectives = self._active_root_objectives
	local index_of_2 = table.index_of(_active_root_objectives, var_63_0)

	if not index_of_2 then
		table.remove(_active_root_objectives, index_of_2)
		printf("[ObjectiveSystem] Completed root objective: %s", var_63_0)
	else
		printf("[ObjectiveSystem] Completed sub objective: %s", var_63_0)
	end

	local is_root_objective = self:is_root_objective(var_63_0)
	local is_leaf_objective = self:is_leaf_objective(var_63_0)
	local is_last_leaf_objective = self:is_last_leaf_objective(var_63_0)
	local var_63_8 = self._objective_by_name[var_63_0]

	var_63_8:complete(is_root_objective, is_leaf_objective, is_last_leaf_objective)

	local var_63_9 = self._data_by_name[var_63_0]

	Managers.state.event:trigger("objective_completed", var_63_8, var_63_9)
end

ObjectiveSystem.complete_objective = function (arg_64_0, arg_64_1)
	-- function 64
	arg_64_0._objective_by_name[arg_64_1]._completed = true
end

ObjectiveSystem.get_remaining_objectives_list = function (self)
	-- function 65
	return table.slice(self._objective_lists, self._current_objective_list_index, #self._objective_lists)
end

ObjectiveSystem._update_objective_vo = function (self)
	-- function 66
	local var_66_0 = self._objective_lists[self._current_objective_list_index]

	for k, v in pairs(var_66_0) do
		if not v.almost_done and self._main_objective_scratch.almost_done_vo_played or not v:almost_done(self._active_objectives) then
			self._main_objective_scratch.almost_done_vo_played = true

			Managers.state.entity:system("dialogue_system"):queue_mission_giver_event("vs_mg_heroes_objective_almost_completed")

			break
		end
	end
end

ObjectiveSystem._check_trigger_complete_vo = function (arg_67_0, arg_67_1)
	-- function 67
	if not arg_67_1.play_complete_vo then
		Managers.state.entity:system("dialogue_system"):queue_mission_giver_event("vs_mg_heroes_objective_completed")
	elseif not arg_67_1.play_safehouse_vo then
		Managers.state.entity:system("dialogue_system"):queue_mission_giver_event("vs_mg_heroes_reached_safe_room")
	elseif not arg_67_1.play_waystone_vo then
		Managers.state.entity:system("dialogue_system"):queue_mission_giver_event("vs_mg_heroes_reached_waystone")
	elseif not arg_67_1.play_dialogue_event_on_complete then
		local dialogue_event = arg_67_1.dialogue_event

		Managers.state.entity:system("dialogue_system"):queue_mission_giver_event(dialogue_event)
	end
end

ObjectiveSystem._check_trigger_start_vo = function (arg_68_0, arg_68_1)
	-- function 68
	if not arg_68_1.play_arrive_vo then
		Managers.state.entity:system("dialogue_system"):queue_mission_giver_event("vs_mg_heroes_objective_reached")
	end
end
