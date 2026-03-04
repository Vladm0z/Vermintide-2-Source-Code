-- chunkname: @scripts/entity_system/systems/objective/objective_system.lua

local var_0_0 = script_data.testify and require("scripts/entity_system/systems/objective/objective_system_testify")

require("scripts/entity_system/systems/weaves/weave_essence_handler")
require("scripts/unit_extensions/objectives/base_objective_extension")
require("scripts/unit_extensions/objectives/objective_group_extension")

ObjectiveSystem = class(ObjectiveSystem, ExtensionSystemBase)

local var_0_1 = {
	"rpc_register_objectives",
	"rpc_activate_objective",
	"rpc_objective_completed"
}
local var_0_2 = {
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

function ObjectiveSystem.init(arg_1_0, arg_1_1, arg_1_2)
	ExtensionSystemBase.init(arg_1_0, arg_1_1, arg_1_2, var_0_2)

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_1))

	arg_1_0._game_session = Network.game_session()
	arg_1_0._entity_system_creation_context = arg_1_1
	arg_1_0._is_server = arg_1_1.is_server
	arg_1_0._world = arg_1_1.world
	arg_1_0._extensions = {}
	arg_1_0._units = {}
	arg_1_0._progress_listeners = {}
	arg_1_0._objective_lists = {}
	arg_1_0._active_objectives = {}
	arg_1_0._active_leaf_objectives = {}
	arg_1_0._active_root_objectives = {}
	arg_1_0._activated = false
	arg_1_0._all_objectives_completed = false
	arg_1_0._objective_by_name = {}
	arg_1_0._group_by_name = {}
	arg_1_0._children_by_name = {}
	arg_1_0._extension_by_sync_object = {}
	arg_1_0._pending_sync_objects = {}
	arg_1_0._data_by_name = {}
	arg_1_0._sync_object_by_name = {}
	arg_1_0._total_num_main_objectives = 0
	arg_1_0._total_num_objectives_at_current_list_index = 0
	arg_1_0._current_objective_list_index = 1
	arg_1_0._hot_join_sync_completed_objectives = {}

	local var_1_1 = Managers.state.game_mode:game_mode_key()

	if var_1_1 == "weave" then
		arg_1_0._weave_essence_handler = WeaveEssenceHandler:new(arg_1_0._world)
		arg_1_0._weave_manager = Managers.weave
	elseif var_1_1 == "versus" then
		arg_1_0._is_versus = true
	end

	arg_1_0._objective_item_spawner = Managers.state.entity:system("objective_item_spawner_system")

	Managers.state.event:register(arg_1_0, "on_player_joined_party", "_on_player_joined_party")
end

function ObjectiveSystem.on_game_entered(arg_2_0)
	if arg_2_0._is_server then
		local var_2_0 = Managers.state.game_mode:level_start_objectives()

		if var_2_0 then
			arg_2_0:server_register_objectives(var_2_0)
		end
	end
end

function ObjectiveSystem.destroy(arg_3_0)
	arg_3_0.network_event_delegate:unregister(arg_3_0)

	local var_3_0 = Managers.state.event

	if var_3_0 then
		var_3_0:unregister("on_player_joined_party", arg_3_0)
	end
end

function ObjectiveSystem.weave_essence_handler(arg_4_0)
	return arg_4_0._weave_essence_handler
end

function ObjectiveSystem.game_object_created(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = GameSession.game_object_field(arg_5_1, arg_5_2, "objective_name")
	local var_5_1 = NetworkLookup.objective_names[var_5_0]
	local var_5_2 = arg_5_0._objective_by_name[var_5_1]

	if var_5_2 then
		var_5_2:sync_objective(arg_5_2, arg_5_1)

		arg_5_0._extension_by_sync_object[arg_5_2] = var_5_2
	else
		arg_5_0._pending_sync_objects[var_5_1] = arg_5_2
	end
end

function ObjectiveSystem.deactivate_all_objectives(arg_6_0)
	if arg_6_0._weave_essence_handler then
		arg_6_0._weave_essence_handler:destroy_all_essence()
	end

	arg_6_0:_destroy_all_sync_objects()

	local var_6_0 = arg_6_0._active_objectives

	for iter_6_0, iter_6_1 in ipairs(var_6_0) do
		local var_6_1 = arg_6_0._objective_by_name[iter_6_1]

		var_6_1:deactivate()

		if not var_6_1.keep_alive then
			arg_6_0._objective_item_spawner:destroy_objective(iter_6_1)
		end

		var_6_0[iter_6_0] = nil
	end
end

function ObjectiveSystem._destroy_all_sync_objects(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._current_objective_list_index
	local var_7_1 = arg_7_0._objective_lists[var_7_0]

	if var_7_1 then
		for iter_7_0 in pairs(var_7_1) do
			if arg_7_1 or iter_7_0 ~= "kill_enemies" then
				arg_7_0:_destroy_sync_object(iter_7_0)
			end
		end
	end
end

function ObjectiveSystem._destroy_sync_object(arg_8_0, arg_8_1)
	local var_8_0 = Network.game_session()

	if not var_8_0 then
		return
	end

	local var_8_1 = arg_8_0._sync_object_by_name[arg_8_1]

	if var_8_1 then
		arg_8_0._sync_object_by_name[arg_8_1] = nil

		GameSession.destroy_game_object(var_8_0, var_8_1)
	end
end

function ObjectiveSystem.server_register_objectives(arg_9_0, arg_9_1)
	assert(arg_9_0._is_server, "[ObjectiveSystem] Only server may register objectives")
	arg_9_0:_register_objectives(arg_9_1)

	local var_9_0 = NetworkLookup.objective_lists[arg_9_1]

	arg_9_0.network_transmit:send_rpc_clients("rpc_register_objectives", var_9_0)
end

function ObjectiveSystem._register_objectives(arg_10_0, arg_10_1)
	assert(not arg_10_0._objective_list_name, "[ObjectiveSystem] No support implemented for registering multiple sets of objectives. Needs a pass to support this.")

	arg_10_0._objective_list_name = arg_10_1

	local var_10_0 = ObjectiveLists[arg_10_1]

	arg_10_0._objective_lists = var_10_0

	local var_10_1 = 0

	for iter_10_0, iter_10_1 in ipairs(var_10_0) do
		var_10_1 = var_10_1 + table.size(iter_10_1)

		for iter_10_2, iter_10_3 in pairs(iter_10_1) do
			fassert(not arg_10_0._data_by_name[iter_10_2] or iter_10_2 == "kill_enemies", "[ObjectiveSystem] Objective with name %s in group %s was already registered as part of group %s.", iter_10_2, iter_10_0, arg_10_0._data_by_name[iter_10_2])
			arg_10_0:_register_objective(iter_10_2, iter_10_3)
		end
	end

	arg_10_0._total_num_main_objectives = arg_10_0._total_num_main_objectives + var_10_1
end

function ObjectiveSystem._register_objective(arg_11_0, arg_11_1, arg_11_2)
	arg_11_0._data_by_name[arg_11_1] = arg_11_2

	if arg_11_2.sub_objectives then
		arg_11_0:_create_group_unit(arg_11_1, arg_11_2)

		arg_11_0._children_by_name[arg_11_1] = {}

		for iter_11_0, iter_11_1 in pairs(arg_11_2.sub_objectives) do
			arg_11_0._group_by_name[iter_11_0] = arg_11_1

			table.insert(arg_11_0._children_by_name[arg_11_1], iter_11_0)
			arg_11_0:_register_objective(iter_11_0, iter_11_1)
			arg_11_0:_patch_relation(arg_11_1, iter_11_0)
		end
	end

	local var_11_0 = arg_11_0._objective_by_name[arg_11_1]

	if var_11_0 then
		var_11_0:set_objective_data(arg_11_2)
	end
end

function ObjectiveSystem._patch_relation(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0._objective_by_name[arg_12_1]
	local var_12_1 = arg_12_0._objective_by_name[arg_12_2]

	if not var_12_0 or not var_12_1 then
		return
	end

	var_12_0:register_child(var_12_1)
end

function ObjectiveSystem.server_activate_first_objective(arg_13_0)
	assert(arg_13_0._is_server, "[ObjectiveSystem] Only server may activate objectives")
	assert(not arg_13_0._activated, "[ObjectiveSystem] Already activated the first objective")

	if not arg_13_0:_activate_objectives_at_index(1) then
		return
	end

	arg_13_0:objective_started_telemetry(arg_13_0._current_objective_list_index)
end

function ObjectiveSystem._create_group_unit(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = Managers.state.unit_spawner
	local var_14_1 = ObjectiveUnitTemplates.objective_group
	local var_14_2 = var_14_1.unit_name
	local var_14_3 = var_14_1.unit_template_name
	local var_14_4 = var_14_1.create_extension_init_data_func(arg_14_1, arg_14_2, nil)

	return (var_14_0:spawn_local_unit_with_extensions(var_14_2, var_14_3, var_14_4))
end

function ObjectiveSystem._activate_objective(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0._data_by_name[arg_15_1]

	assert(var_15_0, "[ObjectiveSystem] Tried activating objective before registering it.")

	if arg_15_0._is_server then
		arg_15_0:_check_trigger_start_vo(var_15_0)
	end

	if var_15_0.vo_context_on_activate then
		local var_15_1 = Managers.state.entity:system("dialogue_system")

		for iter_15_0, iter_15_1 in pairs(var_15_0.vo_context_on_activate) do
			var_15_1:set_global_context(iter_15_0, iter_15_1)
		end
	end

	local var_15_2 = arg_15_0:_is_objective_container(arg_15_1)

	if var_15_2 then
		local var_15_3 = arg_15_0._objective_by_name[arg_15_1]

		if var_15_3.activate then
			var_15_3:activate()
		end
	else
		if arg_15_0._is_server then
			arg_15_0._objective_item_spawner:spawn_item(arg_15_1, var_15_0)

			local var_15_4 = arg_15_0._objective_by_name[arg_15_1]

			fassert(var_15_4, "[ObjectiveSystem] Missing unit with objective extension and objective id %s", arg_15_1)

			local var_15_5 = {
				value = 0,
				go_type = NetworkLookup.go_types.objective,
				objective_name = NetworkLookup.objective_names[arg_15_1]
			}

			if var_15_4.initial_sync_data then
				var_15_4:initial_sync_data(var_15_5)
			end

			local var_15_6 = callback(arg_15_0, "cb_game_session_disconnect")
			local var_15_7 = Managers.state.network:create_game_object("objective", var_15_5, var_15_6)

			arg_15_0._sync_object_by_name[arg_15_1] = var_15_7

			var_15_4:sync_objective(var_15_7)
		end

		local var_15_8 = arg_15_0._objective_by_name[arg_15_1]
		local var_15_9 = arg_15_0._pending_sync_objects[arg_15_1]

		if var_15_9 then
			var_15_8:sync_objective(var_15_9)

			arg_15_0._pending_sync_objects[arg_15_1] = nil
		end

		if var_15_8.activate then
			var_15_8:activate()
		end

		arg_15_0._active_leaf_objectives[#arg_15_0._active_leaf_objectives + 1] = arg_15_1
	end

	arg_15_0._active_objectives[#arg_15_0._active_objectives + 1] = arg_15_1

	if not arg_15_0:_is_part_of_objective_container(arg_15_1) then
		arg_15_0._active_root_objectives[#arg_15_0._active_root_objectives + 1] = arg_15_1
	end

	if var_15_2 then
		local var_15_10 = arg_15_0._children_by_name[arg_15_1]

		for iter_15_2, iter_15_3 in ipairs(var_15_10) do
			if not arg_15_0._hot_join_sync_completed_objectives[iter_15_3] then
				arg_15_0:_activate_objective(iter_15_3)
			end
		end
	end
end

function ObjectiveSystem.cb_game_session_disconnect(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0._extension_by_sync_object[arg_16_1]

	if var_16_0 then
		var_16_0:desync_objective()

		arg_16_0._extension_by_sync_object[arg_16_1] = nil
	end
end

function ObjectiveSystem.on_add_extension(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	local var_17_0 = Unit.get_data(arg_17_2, "listen_to_progress")

	if var_17_0 then
		local var_17_1 = arg_17_0._progress_listeners[var_17_0] or {}

		var_17_1[0] = #var_17_1 + 1
		var_17_1[var_17_1[0]] = arg_17_2
		arg_17_0._progress_listeners[var_17_0] = var_17_1
	end

	local var_17_2

	if arg_17_3 == "ObjectiveEventExtension" then
		var_17_2 = {}
	else
		local var_17_3 = arg_17_0.NAME
		local var_17_4

		var_17_2 = ScriptUnit.add_extension(arg_17_0.extension_init_context, arg_17_2, arg_17_3, var_17_3, arg_17_4, var_17_4)
	end

	arg_17_0.extensions[arg_17_3] = (arg_17_0.extensions[arg_17_3] or 0) + 1
	arg_17_0._units[var_17_2] = arg_17_2
	arg_17_0._extensions[arg_17_2] = var_17_2

	if arg_17_3 == "ObjectiveEventExtension" then
		return var_17_2
	end

	local var_17_5 = var_17_2:objective_name()

	if var_17_5 and var_17_5 ~= "" then
		local var_17_6 = arg_17_0._data_by_name[var_17_5]

		if var_17_6 then
			var_17_2:set_objective_data(var_17_6)
		end

		if not arg_17_0._objective_item_spawner:template_by_unit(arg_17_2) then
			arg_17_0._objective_by_name[var_17_5] = var_17_2

			local var_17_7 = arg_17_0._group_by_name[var_17_5]

			if var_17_7 then
				arg_17_0:_patch_relation(var_17_7, var_17_5)
			end
		end
	end

	return var_17_2
end

function ObjectiveSystem.on_remove_extension(arg_18_0, arg_18_1, ...)
	ObjectiveSystem.super.on_remove_extension(arg_18_0, arg_18_1, ...)

	local var_18_0 = arg_18_0._extensions[arg_18_1]

	arg_18_0._units[var_18_0] = nil
	arg_18_0._extensions[arg_18_1] = nil
end

function ObjectiveSystem.update(arg_19_0, arg_19_1, arg_19_2)
	if script_data.testify then
		Testify:poll_requests_through_handler(var_0_0, arg_19_0)
	end

	local var_19_0 = arg_19_1.dt

	if arg_19_0._weave_essence_handler then
		arg_19_0._weave_essence_handler:update(var_19_0, arg_19_2)
	end

	if not arg_19_0._activated or Managers.state.game_mode:is_game_mode_ended() then
		return
	end

	if arg_19_0._is_server then
		arg_19_0:_update_server(var_19_0, arg_19_2)
	else
		arg_19_0:_update_client(var_19_0, arg_19_2)
	end
end

function ObjectiveSystem._on_player_joined_party(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	if arg_20_5 or arg_20_1 ~= Network.peer_id() then
		return
	end

	local var_20_0 = arg_20_0._extensions

	for iter_20_0, iter_20_1 in pairs(var_20_0) do
		Unit.flow_event(iter_20_0, "local_player_party_changed")
	end
end

function ObjectiveSystem.game_object_destroyed(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = GameSession.game_object_field(arg_21_1, arg_21_2, "objective_name")
	local var_21_1 = NetworkLookup.objective_names[var_21_0]

	arg_21_0._pending_sync_objects[var_21_1] = arg_21_2

	local var_21_2 = arg_21_0._extension_by_sync_object[arg_21_2]

	if var_21_2 then
		var_21_2:desync_objective()

		arg_21_0._extension_by_sync_object[arg_21_2] = nil
	end
end

function ObjectiveSystem._update_server(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_0._active_objectives
	local var_22_1 = arg_22_0._active_leaf_objectives
	local var_22_2 = arg_22_0._active_root_objectives
	local var_22_3 = {}

	arg_22_0:_update_objective_vo()

	for iter_22_0, iter_22_1 in ipairs(var_22_0) do
		local var_22_4 = arg_22_0._objective_by_name[iter_22_1]

		var_22_4:update(arg_22_1, arg_22_2)
		arg_22_0:_update_progress_listeners(iter_22_1)

		if var_22_4:is_done() then
			var_22_3[#var_22_3 + 1] = iter_22_0
		end
	end

	for iter_22_2 = #var_22_3, 1, -1 do
		local var_22_5 = var_22_3[iter_22_2]
		local var_22_6 = table.remove(var_22_0, var_22_5)
		local var_22_7 = table.index_of(var_22_1, var_22_6)

		if var_22_7 then
			table.remove(var_22_1, var_22_7)
		end

		local var_22_8 = table.index_of(var_22_2, var_22_6)

		if var_22_8 then
			table.remove(var_22_2, var_22_8)
		end

		local var_22_9 = arg_22_0._objective_by_name[var_22_6]

		arg_22_0:_complete_objective_server(var_22_9, var_22_3)
	end

	arg_22_0:_update_activate_objectives()
end

function ObjectiveSystem._update_client(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = arg_23_0._active_objectives

	for iter_23_0, iter_23_1 in pairs(var_23_0) do
		arg_23_0._objective_by_name[iter_23_1]:update(arg_23_1, arg_23_2)
		arg_23_0:_update_progress_listeners(iter_23_1)
	end
end

function ObjectiveSystem._update_progress_listeners(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0._objective_by_name[arg_24_1]
	local var_24_1 = var_24_0:get_percentage_done()
	local var_24_2 = arg_24_0._units[var_24_0]

	Unit.set_data(var_24_2, "objective_progress", var_24_1)
	Unit.flow_event(var_24_2, "objective_progress_update")

	local var_24_3 = arg_24_0._progress_listeners[arg_24_1]

	if var_24_3 then
		local var_24_4 = var_24_3[0]

		for iter_24_0 = 1, var_24_4 do
			local var_24_5 = var_24_3[iter_24_0]

			Unit.set_data(var_24_5, "objective_progress", var_24_1)
			Unit.flow_event(var_24_5, "objective_progress_update")
		end
	end
end

function ObjectiveSystem._update_activate_objectives(arg_25_0)
	local var_25_0 = #arg_25_0._active_objectives
	local var_25_1 = var_25_0 > 0

	for iter_25_0 = 1, var_25_0 do
		if arg_25_0._active_objectives[iter_25_0] ~= "kill_enemies" then
			var_25_1 = false

			break
		end
	end

	if var_25_0 == 0 or var_25_1 then
		local var_25_2 = arg_25_0._current_objective_list_index + 1
		local var_25_3 = arg_25_0._objective_lists[var_25_2]

		if arg_25_0._weave_manager then
			arg_25_0._weave_manager:objective_set_completed()
		end

		if var_25_3 then
			arg_25_0:_destroy_all_sync_objects(false)
			arg_25_0:_activate_objectives_at_index(var_25_2)
			arg_25_0:objective_started_telemetry(arg_25_0._current_objective_list_index)

			arg_25_0._main_objective_scratch = {}
		elseif not var_25_1 then
			arg_25_0:_destroy_all_sync_objects(true)

			arg_25_0._activated = false
			arg_25_0._all_objectives_completed = true
		end
	end
end

function ObjectiveSystem._complete_objective_server(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = arg_26_1:objective_name()
	local var_26_1 = arg_26_0._data_by_name[var_26_0]

	arg_26_0:_check_trigger_complete_vo(var_26_1)

	if var_26_1.vo_context_on_complete then
		local var_26_2 = Managers.state.entity:system("dialogue_system")

		for iter_26_0, iter_26_1 in pairs(var_26_1.vo_context_on_complete) do
			if type(iter_26_1) == "function" then
				iter_26_1 = iter_26_1(var_26_2:get_global_context(iter_26_0))
			end

			var_26_2:set_global_context(iter_26_0, iter_26_1)
		end
	end

	if arg_26_0._weave_manager then
		arg_26_0._weave_manager:increase_bar_score(arg_26_1:get_score_for_completion() or 0)
	end

	if not arg_26_1.keep_alive then
		arg_26_0._objective_item_spawner:destroy_objective(var_26_0)
	end

	LevelHelper:flow_event(arg_26_0._world, "objective_completed_" .. var_26_0)
	LevelHelper:flow_event(arg_26_0._world, "objective_completed")

	if arg_26_0:_is_last_active_objective(var_26_0) then
		Managers.state.event:trigger("objective_group_completed")

		local var_26_3 = Managers.state.game_mode
		local var_26_4 = var_26_3:game_mode()

		if var_26_3:settings().move_dead_players_after_objective_completed then
			var_26_4:adventure_spawning():set_move_dead_players_to_next_respawn(true)
		end
	end

	local var_26_5 = arg_26_0:is_root_objective(var_26_0)
	local var_26_6 = arg_26_0:is_leaf_objective(var_26_0)
	local var_26_7 = arg_26_0:is_last_leaf_objective(var_26_0)

	arg_26_1:complete(var_26_5, var_26_6, var_26_7)
	Managers.state.event:trigger("objective_completed", arg_26_1, var_26_1)

	local var_26_8 = NetworkLookup.objective_names[var_26_0]

	arg_26_0.network_transmit:send_rpc_clients("rpc_objective_completed", var_26_8)
end

function ObjectiveSystem._is_last_active_objective(arg_27_0, arg_27_1)
	return arg_27_0._active_objectives[2] == nil and arg_27_0._active_objectives[1] == arg_27_1
end

function ObjectiveSystem.is_root_objective(arg_28_0, arg_28_1)
	return arg_28_0:_is_part_of_objective_container(arg_28_1)
end

function ObjectiveSystem.is_leaf_objective(arg_29_0, arg_29_1)
	return not arg_29_0:_is_objective_container(arg_29_1)
end

function ObjectiveSystem.is_last_leaf_objective(arg_30_0, arg_30_1)
	return arg_30_0:is_leaf_objective(arg_30_1) and table.is_empty(arg_30_0._active_leaf_objectives)
end

function ObjectiveSystem._get_first_objective(arg_31_0)
	local var_31_0 = arg_31_0._active_objectives[1]
	local var_31_1 = arg_31_0._objective_by_name[var_31_0]
	local var_31_2 = arg_31_0._data_by_name[var_31_0]

	return var_31_1, var_31_2, var_31_0
end

function ObjectiveSystem._get_first_leaf_objective(arg_32_0)
	local var_32_0 = arg_32_0._active_leaf_objectives[1]
	local var_32_1 = arg_32_0._objective_by_name[var_32_0]
	local var_32_2 = arg_32_0._data_by_name[var_32_0]

	return var_32_1, var_32_2, var_32_0
end

function ObjectiveSystem.first_active_leaf_objective_unit(arg_33_0)
	local var_33_0 = arg_33_0:_get_first_leaf_objective()

	return var_33_0 and var_33_0:unit()
end

function ObjectiveSystem.first_active_objective_name(arg_34_0)
	return arg_34_0._active_objectives[1]
end

function ObjectiveSystem.first_active_root_objective_name(arg_35_0)
	return arg_35_0._active_root_objectives[1]
end

function ObjectiveSystem.first_active_objective_description(arg_36_0)
	local var_36_0 = arg_36_0:active_objectives()

	for iter_36_0 = 1, #var_36_0 do
		local var_36_1 = var_36_0[iter_36_0]
		local var_36_2 = arg_36_0._objective_by_name[var_36_1]
		local var_36_3 = arg_36_0._data_by_name[var_36_1]
		local var_36_4 = var_36_2:description() or var_36_3.description

		if var_36_4 then
			return Localize(var_36_4)
		end
	end

	return string.format("<MISSING DESCRIPTION FOR OBJECTIVE '%s'>", arg_36_0:first_active_objective_name())
end

function ObjectiveSystem.current_objective_progress(arg_37_0)
	local var_37_0 = arg_37_0:active_root_objectives()
	local var_37_1 = arg_37_0._total_num_objectives_at_current_list_index
	local var_37_2 = 0
	local var_37_3 = #var_37_0

	if var_37_3 == 0 then
		return 0
	end

	for iter_37_0 = 1, var_37_3 do
		local var_37_4 = arg_37_0._objective_by_name[var_37_0[iter_37_0]]

		if var_37_4.get_percentage_done then
			var_37_2 = var_37_2 + var_37_4:get_percentage_done()
		else
			var_37_2 = var_37_4:is_done() and 1 or 0
		end
	end

	return (var_37_2 + (var_37_1 - var_37_3)) / var_37_1
end

function ObjectiveSystem.current_objective_icon(arg_38_0)
	local var_38_0 = arg_38_0:active_objectives()

	for iter_38_0 = 1, #var_38_0 do
		local var_38_1 = var_38_0[iter_38_0]
		local var_38_2 = arg_38_0._objective_by_name[var_38_1]
		local var_38_3 = arg_38_0._data_by_name[var_38_1]
		local var_38_4 = var_38_2:objective_icon() or var_38_3.objective_type

		if var_38_4 then
			return var_38_4
		end
	end

	return "icons_placeholder"
end

function ObjectiveSystem.current_objective_type(arg_39_0)
	local var_39_0 = arg_39_0:active_objectives()

	for iter_39_0 = 1, #var_39_0 do
		local var_39_1 = var_39_0[iter_39_0]
		local var_39_2 = arg_39_0._objective_by_name[var_39_1]
		local var_39_3 = arg_39_0._data_by_name[var_39_1]
		local var_39_4 = var_39_2:objective_type() or var_39_3.objective_type

		if var_39_4 then
			return var_39_4
		end
	end

	return "objective_reach"
end

function ObjectiveSystem.current_objectives_position(arg_40_0)
	if not arg_40_0._objective_lists then
		return
	end

	local var_40_0 = {}
	local var_40_1 = arg_40_0:active_leaf_objectives()

	for iter_40_0 = 1, #var_40_1 do
		local var_40_2 = var_40_1[iter_40_0]
		local var_40_3 = arg_40_0._objective_by_name[var_40_2]:unit()

		if Unit.alive(var_40_3) then
			var_40_0[#var_40_0 + 1] = Unit.world_position(var_40_3, 0)
		end
	end

	return var_40_0
end

function ObjectiveSystem.objective_started_telemetry(arg_41_0, arg_41_1)
	if not arg_41_0._is_versus then
		return
	end

	local var_41_0 = Managers.mechanism:game_mechanism():match_id()
	local var_41_1 = arg_41_0._objective_lists[arg_41_1]
	local var_41_2 = next(var_41_1)
	local var_41_3 = Managers.mechanism:game_mechanism():total_rounds_started()

	Managers.telemetry_events:versus_objective_started(var_41_0, arg_41_1, var_41_3, var_41_2)
end

function ObjectiveSystem.objective_section_completed_telemetry(arg_42_0, arg_42_1, arg_42_2)
	if not arg_42_0._is_versus then
		return
	end

	arg_42_1 = arg_42_1 or 1
	arg_42_2 = arg_42_2 or 1

	local var_42_0 = Managers.mechanism:game_mechanism():match_id()
	local var_42_1 = arg_42_0._current_objective_list_index
	local var_42_2 = arg_42_0._objective_lists[var_42_1]
	local var_42_3 = next(var_42_2)
	local var_42_4 = Managers.mechanism:game_mechanism():total_rounds_started()

	Managers.telemetry_events:versus_objective_section_completed(var_42_0, var_42_1, var_42_4, var_42_3, arg_42_1, arg_42_2)
end

function ObjectiveSystem.is_active(arg_43_0)
	return arg_43_0._activated
end

function ObjectiveSystem.all_objectives_completed(arg_44_0)
	return arg_44_0._all_objectives_completed
end

function ObjectiveSystem.hot_join_sync(arg_45_0, arg_45_1)
	local var_45_0 = arg_45_0._objective_list_name

	if not var_45_0 then
		return
	end

	local var_45_1 = PEER_ID_TO_CHANNEL[arg_45_1]
	local var_45_2 = NetworkLookup.objective_lists[var_45_0]

	RPC.rpc_register_objectives(var_45_1, var_45_2)

	if not table.is_empty(arg_45_0._active_objectives) then
		local var_45_3 = arg_45_0._objective_lists[arg_45_0._current_objective_list_index]
		local var_45_4 = arg_45_0:_write_hot_join_sync_completed_objectives(var_45_3)

		RPC.rpc_activate_objective(var_45_1, arg_45_0._current_objective_list_index, var_45_4)
	end
end

function ObjectiveSystem.active_objectives(arg_46_0)
	return arg_46_0._active_objectives
end

function ObjectiveSystem.active_leaf_objectives(arg_47_0)
	return arg_47_0._active_leaf_objectives
end

function ObjectiveSystem.active_root_objectives(arg_48_0)
	return arg_48_0._active_root_objectives
end

function ObjectiveSystem.extension_by_objective_name(arg_49_0, arg_49_1)
	return arg_49_0._objective_by_name[arg_49_1]
end

function ObjectiveSystem.current_objective_index(arg_50_0)
	return arg_50_0._current_objective_list_index
end

function ObjectiveSystem.num_main_objectives(arg_51_0)
	return arg_51_0._total_num_main_objectives
end

function ObjectiveSystem.num_current_sub_objectives(arg_52_0)
	return arg_52_0._total_num_objectives_at_current_list_index
end

function ObjectiveSystem.num_completed_main_objectives(arg_53_0)
	return arg_53_0._current_objective_list_index - 1
end

function ObjectiveSystem.num_current_completed_sub_objectives(arg_54_0)
	return arg_54_0._total_num_objectives_at_current_list_index - #arg_54_0._active_root_objectives
end

function ObjectiveSystem.on_ai_killed(arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4)
	if arg_55_0._weave_essence_handler then
		arg_55_0._weave_essence_handler:on_ai_killed(arg_55_1, arg_55_2, arg_55_3, arg_55_4)
	end

	local var_55_0 = arg_55_0._active_objectives

	for iter_55_0, iter_55_1 in pairs(var_55_0) do
		local var_55_1 = arg_55_0._objective_by_name[iter_55_1]

		if var_55_1.on_ai_killed then
			var_55_1:on_ai_killed(arg_55_1, arg_55_2, arg_55_3, arg_55_4)
		end
	end
end

function ObjectiveSystem.rpc_register_objectives(arg_56_0, arg_56_1, arg_56_2)
	local var_56_0 = NetworkLookup.objective_lists[arg_56_2]

	arg_56_0:_register_objectives(var_56_0)
end

function ObjectiveSystem._read_hot_join_sync_completed_objectives(arg_57_0, arg_57_1, arg_57_2, arg_57_3)
	arg_57_3 = arg_57_3 or 0

	for iter_57_0, iter_57_1 in pairs(arg_57_1) do
		if bit.band(bit.rshift(arg_57_2, arg_57_3), 1) ~= 0 then
			arg_57_0._hot_join_sync_completed_objectives[iter_57_0] = true
		end

		arg_57_3 = arg_57_3 + 1

		if iter_57_1.sub_objectives then
			arg_57_3 = arg_57_0:_read_hot_join_sync_completed_objectives(iter_57_1.sub_objectives, arg_57_2, arg_57_3)
		end
	end

	return arg_57_3
end

function ObjectiveSystem._write_hot_join_sync_completed_objectives(arg_58_0, arg_58_1, arg_58_2, arg_58_3)
	arg_58_3 = arg_58_3 or 0
	arg_58_2 = arg_58_2 or 0

	for iter_58_0, iter_58_1 in pairs(arg_58_1) do
		if not table.contains(arg_58_0._active_objectives, iter_58_0) then
			arg_58_2 = bit.bor(bit.lshift(1, arg_58_3), arg_58_2)
		end

		arg_58_3 = arg_58_3 + 1

		if iter_58_1.sub_objectives then
			arg_58_2, arg_58_3 = arg_58_0:_write_hot_join_sync_completed_objectives(iter_58_1.sub_objectives, arg_58_2, arg_58_3)
		end
	end

	return arg_58_2, arg_58_3
end

function ObjectiveSystem.rpc_activate_objective(arg_59_0, arg_59_1, arg_59_2, arg_59_3)
	assert(arg_59_2 > arg_59_0._current_objective_list_index or table.is_empty(arg_59_0._active_objectives), "[ObjectiveSystem] Reactivating objective or activating old objective")
	arg_59_0:_read_hot_join_sync_completed_objectives(arg_59_0._objective_lists[arg_59_2], arg_59_3)
	arg_59_0:_activate_objectives_at_index(arg_59_2)
end

function ObjectiveSystem._activate_objectives_at_index(arg_60_0, arg_60_1)
	table.clear(arg_60_0._active_objectives)
	table.clear(arg_60_0._active_root_objectives)
	table.clear(arg_60_0._active_leaf_objectives)

	arg_60_0._total_num_objectives_at_current_list_index = 0

	local var_60_0 = arg_60_0._objective_lists[arg_60_1]

	if table.is_empty(var_60_0) then
		arg_60_0._activated = false
		arg_60_0._all_objectives_completed = true

		return false
	end

	arg_60_0._activated = true
	arg_60_0._all_objectives_completed = false
	arg_60_0._current_objective_list_index = arg_60_1

	for iter_60_0 in pairs(var_60_0) do
		if not arg_60_0._hot_join_sync_completed_objectives[iter_60_0] then
			arg_60_0:_activate_objective(iter_60_0)

			arg_60_0._total_num_objectives_at_current_list_index = arg_60_0._total_num_objectives_at_current_list_index + 1
		end
	end

	if arg_60_0._is_server then
		arg_60_0.network_transmit:send_rpc_clients("rpc_activate_objective", arg_60_1, 0)
	end

	return true
end

function ObjectiveSystem._is_objective_container(arg_61_0, arg_61_1)
	return not not arg_61_0._children_by_name[arg_61_1]
end

function ObjectiveSystem._is_part_of_objective_container(arg_62_0, arg_62_1)
	return not not arg_62_0._group_by_name[arg_62_1]
end

function ObjectiveSystem.rpc_objective_completed(arg_63_0, arg_63_1, arg_63_2)
	local var_63_0 = NetworkLookup.objective_names[arg_63_2]

	table.remove(arg_63_0._active_objectives, table.index_of(arg_63_0._active_objectives, var_63_0))

	local var_63_1 = arg_63_0._active_leaf_objectives
	local var_63_2 = table.index_of(var_63_1, var_63_0)

	if var_63_2 then
		table.remove(var_63_1, var_63_2)
	end

	local var_63_3 = arg_63_0._active_root_objectives
	local var_63_4 = table.index_of(var_63_3, var_63_0)

	if var_63_4 then
		table.remove(var_63_3, var_63_4)
		printf("[ObjectiveSystem] Completed root objective: %s", var_63_0)
	else
		printf("[ObjectiveSystem] Completed sub objective: %s", var_63_0)
	end

	local var_63_5 = arg_63_0:is_root_objective(var_63_0)
	local var_63_6 = arg_63_0:is_leaf_objective(var_63_0)
	local var_63_7 = arg_63_0:is_last_leaf_objective(var_63_0)
	local var_63_8 = arg_63_0._objective_by_name[var_63_0]

	var_63_8:complete(var_63_5, var_63_6, var_63_7)

	local var_63_9 = arg_63_0._data_by_name[var_63_0]

	Managers.state.event:trigger("objective_completed", var_63_8, var_63_9)
end

function ObjectiveSystem.complete_objective(arg_64_0, arg_64_1)
	arg_64_0._objective_by_name[arg_64_1]._completed = true
end

function ObjectiveSystem.get_remaining_objectives_list(arg_65_0)
	return table.slice(arg_65_0._objective_lists, arg_65_0._current_objective_list_index, #arg_65_0._objective_lists)
end

function ObjectiveSystem._update_objective_vo(arg_66_0)
	local var_66_0 = arg_66_0._objective_lists[arg_66_0._current_objective_list_index]

	for iter_66_0, iter_66_1 in pairs(var_66_0) do
		if iter_66_1.almost_done and not arg_66_0._main_objective_scratch.almost_done_vo_played and iter_66_1:almost_done(arg_66_0._active_objectives) then
			arg_66_0._main_objective_scratch.almost_done_vo_played = true

			Managers.state.entity:system("dialogue_system"):queue_mission_giver_event("vs_mg_heroes_objective_almost_completed")

			break
		end
	end
end

function ObjectiveSystem._check_trigger_complete_vo(arg_67_0, arg_67_1)
	if arg_67_1.play_complete_vo then
		Managers.state.entity:system("dialogue_system"):queue_mission_giver_event("vs_mg_heroes_objective_completed")
	elseif arg_67_1.play_safehouse_vo then
		Managers.state.entity:system("dialogue_system"):queue_mission_giver_event("vs_mg_heroes_reached_safe_room")
	elseif arg_67_1.play_waystone_vo then
		Managers.state.entity:system("dialogue_system"):queue_mission_giver_event("vs_mg_heroes_reached_waystone")
	elseif arg_67_1.play_dialogue_event_on_complete then
		local var_67_0 = arg_67_1.dialogue_event

		Managers.state.entity:system("dialogue_system"):queue_mission_giver_event(var_67_0)
	end
end

function ObjectiveSystem._check_trigger_start_vo(arg_68_0, arg_68_1)
	if arg_68_1.play_arrive_vo then
		Managers.state.entity:system("dialogue_system"):queue_mission_giver_event("vs_mg_heroes_objective_reached")
	end
end
