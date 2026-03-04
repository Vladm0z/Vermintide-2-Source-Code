-- chunkname: @scripts/entity_system/systems/mission/mission_system.lua

require("scripts/entity_system/systems/mission/mission_templates")
require("scripts/settings/missions")

MissionSystem = class(MissionSystem, ExtensionSystemBase)

local var_0_0 = {
	"rpc_start_mission",
	"rpc_start_mission_with_unit",
	"rpc_end_mission",
	"rpc_request_mission",
	"rpc_request_mission_with_unit",
	"rpc_update_mission",
	"rpc_request_mission_update"
}
local var_0_1 = {}

script_data.debug_mission_system = script_data.debug_mission_system or Development.parameter("debug_mission_system")

MissionSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	MissionSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	arg_1_0.active_missions = {}
	arg_1_0.level_end_missions = {}
	arg_1_0.completed_missions = {}
	arg_1_0._only_once_missions = {}

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_0))

	arg_1_0.statistics_db = arg_1_1.statistics_db

	local var_1_1 = Managers.state.network

	arg_1_0.network_manager = var_1_1
	arg_1_0.network_transmit = var_1_1.network_transmit
	arg_1_0.is_server = arg_1_1.is_server
	arg_1_0._percentage_completed = {}
	arg_1_0._use_level_progress = Managers.state.game_mode:setting("use_level_progress")
end

MissionSystem.create_checkpoint_data = function (arg_2_0)
	local var_2_0 = arg_2_0.world
	local var_2_1 = {}
	local var_2_2 = {}

	for iter_2_0, iter_2_1 in pairs(arg_2_0.active_missions) do
		local var_2_3 = {}
		local var_2_4 = iter_2_1.unit

		if var_2_4 then
			var_2_3.unit_index = LevelHelper:unit_index(var_2_0, var_2_4)
		end

		var_2_2[iter_2_0] = var_2_3
	end

	var_2_1.active_missions = var_2_2

	local var_2_5 = {}

	for iter_2_2, iter_2_3 in pairs(arg_2_0.completed_missions) do
		local var_2_6 = {}
		local var_2_7 = iter_2_3.unit

		if var_2_7 then
			var_2_6.unit_index = LevelHelper:unit_index(var_2_0, var_2_7)
		end

		var_2_5[iter_2_2] = var_2_6
	end

	var_2_1.completed_missions = var_2_5

	return var_2_1
end

MissionSystem.load_checkpoint_data = function (arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0.world

	for iter_3_0, iter_3_1 in pairs(arg_3_1.completed_missions) do
		local var_3_1 = iter_3_1.unit_index
		local var_3_2 = var_3_1 and LevelHelper:unit_by_index(var_3_0, var_3_1) or nil

		arg_3_0:start_mission(iter_3_0, var_3_2)
		arg_3_0:end_mission(iter_3_0, true)
	end

	for iter_3_2, iter_3_3 in pairs(arg_3_1.active_missions) do
		local var_3_3 = iter_3_3.unit_index
		local var_3_4 = var_3_3 and LevelHelper:unit_by_index(var_3_0, var_3_3) or nil

		arg_3_0:start_mission(iter_3_2, var_3_4)
	end
end

MissionSystem.destroy = function (arg_4_0)
	arg_4_0.network_event_delegate:unregister(arg_4_0)

	arg_4_0.network_event_delegate = nil
	arg_4_0.network_transmit = nil
	arg_4_0.network_manager = nil
end

MissionSystem.update = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_1.dt
	local var_5_1 = arg_5_0.active_missions

	for iter_5_0, iter_5_1 in pairs(var_5_1) do
		if not iter_5_1.manual_update then
			arg_5_0:update_mission(iter_5_0, nil, var_5_0)
		end
	end

	if arg_5_0._use_level_progress then
		arg_5_0:_update_level_progress(var_5_0)
	end

	if script_data.debug_mission_system then
		arg_5_0:debug_draw(var_5_0)
	end
end

MissionSystem.request_mission = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_3 = arg_6_3 or false

	local var_6_0 = NetworkLookup.mission_names[arg_6_1]
	local var_6_1

	if arg_6_2 then
		var_6_1 = Level.unit_index(LevelHelper:current_level(arg_6_0.world), arg_6_2)
	end

	if arg_6_0.is_server then
		if arg_6_0._only_once_missions[arg_6_1] then
			Debug.sticky_text("Request to start mission %q denied, only allowed once", arg_6_1)

			return
		end

		if arg_6_0.active_missions[arg_6_1] then
			Debug.sticky_text("Request to start mission %q denied, already started", arg_6_1)

			return
		end

		if var_6_1 then
			arg_6_0:start_mission(arg_6_1, arg_6_2, nil, arg_6_3)
		else
			arg_6_0:start_mission(arg_6_1, nil, nil, arg_6_3)
		end

		local var_6_2 = arg_6_0.active_missions[arg_6_1]
		local var_6_3 = var_6_2.mission_data.mission_template_name
		local var_6_4 = MissionTemplates[var_6_3].create_sync_data(var_6_2)

		if var_6_1 then
			arg_6_0.network_transmit:send_rpc_clients("rpc_start_mission_with_unit", var_6_0, var_6_1, var_6_4)
		else
			arg_6_0.network_transmit:send_rpc_clients("rpc_start_mission", var_6_0, var_6_4)
		end
	elseif var_6_1 then
		arg_6_0.network_transmit:send_rpc_server("rpc_request_mission_with_unit", var_6_0, var_6_1, arg_6_3)
	else
		arg_6_0.network_transmit:send_rpc_server("rpc_request_mission", var_6_0, arg_6_3)
	end
end

MissionSystem.start_mission = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = Missions[arg_7_1]
	local var_7_1 = var_7_0.mission_template_name
	local var_7_2 = MissionTemplates[var_7_1]
	local var_7_3 = var_7_2.init(var_7_0, arg_7_2)

	var_7_3.mission_type = var_7_1

	if arg_7_3 then
		var_7_2.sync(var_7_3, arg_7_3)
	end

	var_7_2.update_text(var_7_3)

	if not var_7_0.hidden and not var_7_3.mission_data.is_side_mission then
		Managers.state.event:trigger("ui_event_add_mission_objective", arg_7_1, var_7_3.center_text or var_7_3.text, var_7_3.duration_text)
	end

	arg_7_0.active_missions[arg_7_1] = var_7_3

	if arg_7_2 then
		Unit.flow_event(arg_7_2, "lua_mission_started")
	end

	if var_7_3.evaluate_at_level_end then
		arg_7_0.level_end_missions[arg_7_1] = var_7_3
	end

	if arg_7_4 then
		arg_7_0._only_once_missions[arg_7_1] = true
	end
end

MissionSystem.block_mission_ui = function (arg_8_0, arg_8_1)
	Managers.state.event:trigger("ui_event_block_mission_ui", arg_8_1)
end

MissionSystem.trigger_active_mission_ui_events = function (arg_9_0)
	for iter_9_0, iter_9_1 in pairs(arg_9_0.active_missions) do
		if not Missions[iter_9_0].hidden and not iter_9_1.mission_data.is_side_mission then
			Managers.state.event:trigger("ui_event_add_mission_objective", iter_9_0, iter_9_1.center_text or iter_9_1.text)
		end
	end
end

MissionSystem.end_mission = function (arg_10_0, arg_10_1, arg_10_2)
	fassert(arg_10_0.active_missions[arg_10_1], "No active mission with passed mission_name %q", arg_10_1)

	local var_10_0 = arg_10_0.active_missions[arg_10_1]
	local var_10_1 = MissionTemplates[var_10_0.mission_data.mission_template_name].evaluate_mission(var_10_0)
	local var_10_2

	var_10_2 = var_10_0.mission_data.is_side_mission and "side_mission" or var_10_0.info_slate_type

	if not var_10_0.mission_data.hidden then
		Managers.state.event:trigger("ui_event_complete_mission", arg_10_1, var_10_0.mission_data.dont_show_mission_end_tooltip)
	end

	if arg_10_2 and arg_10_0.is_server then
		local var_10_3 = NetworkLookup.mission_names[arg_10_1]

		arg_10_0.network_transmit:send_rpc_clients("rpc_end_mission", var_10_3, var_10_1)
	end

	local var_10_4 = var_10_0.unit

	if var_10_4 then
		local var_10_5 = var_10_1 and "lua_mission_complete" or "lua_mission_failed"

		Unit.flow_event(var_10_4, var_10_5)
	end

	arg_10_0.active_missions[arg_10_1] = nil
	arg_10_0.completed_missions[arg_10_1] = var_10_0
end

MissionSystem.reset_mission = function (arg_11_0, arg_11_1, arg_11_2)
	fassert(arg_11_0.active_missions[arg_11_1], "No active mission with passed mission_name %q", arg_11_1)

	local var_11_0 = arg_11_0.active_missions[arg_11_1]
	local var_11_1 = arg_11_0.network_manager:network_time()
	local var_11_2 = var_11_0.mission_data.mission_template_name
	local var_11_3 = MissionTemplates[var_11_2]

	var_11_3.reset_mission(var_11_0)
	var_11_3.update_text(var_11_0)

	if not var_11_0.mission_data.hidden then
		Managers.state.event:trigger("ui_event_update_mission", arg_11_1, var_11_0.center_text or var_11_0.text)
	end

	if arg_11_2 and arg_11_0.is_server then
		local var_11_4 = NetworkLookup.mission_names[arg_11_1]
		local var_11_5 = var_11_3.create_sync_data(var_11_0)

		arg_11_0.network_transmit:send_rpc_clients("rpc_update_mission", var_11_4, var_11_5)
	end
end

MissionSystem.update_mission = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	fassert(arg_12_0.active_missions[arg_12_1], "No active mission with passed mission_name %q", arg_12_1)

	local var_12_0 = arg_12_0.active_missions[arg_12_1]
	local var_12_1 = arg_12_0.network_manager:network_time()
	local var_12_2 = var_12_0.mission_data.mission_template_name
	local var_12_3 = MissionTemplates[var_12_2]
	local var_12_4 = var_12_3.update(var_12_0, arg_12_2, arg_12_3, var_12_1)

	var_12_3.update_text(var_12_0)

	if not var_12_0.mission_data.hidden then
		Managers.state.event:trigger("ui_event_update_mission", arg_12_1, var_12_0.center_text or var_12_0.text, var_12_0.duration_text)
	end

	if arg_12_4 and arg_12_0.is_server then
		local var_12_5 = NetworkLookup.mission_names[arg_12_1]
		local var_12_6 = var_12_3.create_sync_data(var_12_0)

		arg_12_0.network_transmit:send_rpc_clients("rpc_update_mission", var_12_5, var_12_6)
	end

	if var_12_4 then
		arg_12_0:end_mission(arg_12_1, arg_12_4)
	end
end

MissionSystem.evaluate_level_end_missions = function (arg_13_0)
	local var_13_0 = arg_13_0.level_end_missions

	for iter_13_0, iter_13_1 in pairs(var_13_0) do
		if MissionTemplates[iter_13_1.mission_data.mission_template_name].evaluate_mission(iter_13_1) then
			arg_13_0:end_mission(iter_13_0, false)
		end
	end
end

MissionSystem.debug_draw = function (arg_14_0, arg_14_1)
	for iter_14_0, iter_14_1 in pairs(arg_14_0.active_missions) do
		Debug.text(iter_14_1.text)
	end
end

MissionSystem.hot_join_sync = function (arg_15_0, arg_15_1)
	for iter_15_0, iter_15_1 in pairs(arg_15_0.active_missions) do
		local var_15_0 = NetworkLookup.mission_names[iter_15_0]
		local var_15_1 = iter_15_1.mission_data.mission_template_name
		local var_15_2 = MissionTemplates[var_15_1].create_sync_data(iter_15_1)
		local var_15_3 = iter_15_1.unit
		local var_15_4 = PEER_ID_TO_CHANNEL[arg_15_1]

		if var_15_3 then
			local var_15_5 = Level.unit_index(LevelHelper:current_level(arg_15_0.world), var_15_3)

			RPC.rpc_start_mission_with_unit(var_15_4, var_15_0, var_15_5, var_15_2)
		else
			RPC.rpc_start_mission(var_15_4, var_15_0, var_15_2)
		end
	end
end

MissionSystem.flow_callback_start_mission = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	if not arg_16_3 and not arg_16_0.is_server then
		return
	end

	arg_16_0:request_mission(arg_16_1, arg_16_2, arg_16_4)
end

MissionSystem.flow_callback_reset_mission = function (arg_17_0, arg_17_1)
	if not arg_17_0.is_server then
		return
	end

	fassert(arg_17_0.active_missions[arg_17_1], "No active mission with passed mission_name %q", arg_17_1)

	local var_17_0 = arg_17_0.active_missions[arg_17_1].mission_data.mission_template_name

	if var_17_0 == "collect" then
		arg_17_0:reset_mission(arg_17_1, true)
	else
		fassert(var_17_0, "[flow_callback_reset_mission]: Reset function only suports COLLECT missions")
	end
end

MissionSystem.flow_callback_update_mission = function (arg_18_0, arg_18_1)
	if not arg_18_0.is_server then
		return
	end

	fassert(arg_18_0.active_missions[arg_18_1], "No active mission with passed mission_name %q", arg_18_1)

	local var_18_0 = arg_18_0.active_missions[arg_18_1]

	fassert(var_18_0.manual_update, "MissionSystem:flow_callback_update_mission() Trying to update mission %q from flow", arg_18_1)
	arg_18_0:update_mission(arg_18_1, true, nil, true)
end

MissionSystem.flow_callback_end_mission = function (arg_19_0, arg_19_1)
	if not arg_19_0.is_server then
		return
	end

	arg_19_0:end_mission(arg_19_1, true)
end

MissionSystem.rpc_start_mission = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0 = NetworkLookup.mission_names[arg_20_2]

	arg_20_0:start_mission(var_20_0, nil, arg_20_3)
end

MissionSystem.rpc_start_mission_with_unit = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	local var_21_0 = NetworkLookup.mission_names[arg_21_2]
	local var_21_1 = Level.unit_by_index(LevelHelper:current_level(arg_21_0.world), arg_21_3)

	arg_21_0:start_mission(var_21_0, var_21_1, arg_21_4)
end

MissionSystem.rpc_request_mission = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	fassert(arg_22_0.is_server, "[MissionSystem] Request mission ended up on a client")

	local var_22_0 = NetworkLookup.mission_names[arg_22_2]

	arg_22_0:request_mission(var_22_0, nil, arg_22_3)
end

MissionSystem.rpc_request_mission_with_unit = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	fassert(arg_23_0.is_server, "[MissionSystem] Request mission ended up on a client")

	local var_23_0 = NetworkLookup.mission_names[arg_23_2]
	local var_23_1 = Level.unit_by_index(LevelHelper:current_level(arg_23_0.world), arg_23_3)

	arg_23_0:request_mission(var_23_0, var_23_1, arg_23_4)
end

MissionSystem.rpc_request_mission_update = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	fassert(arg_24_0.is_server, "[MissionSystem] Request mission update ended up on a client")

	local var_24_0 = NetworkLookup.mission_names[arg_24_2]

	if arg_24_0.active_missions[var_24_0] then
		local var_24_1 = arg_24_0.active_missions[var_24_0]

		fassert(var_24_1.manual_update, "[MissionSystem] Requested an update on a mission not using manual updates", var_24_0)
		arg_24_0:update_mission(var_24_0, arg_24_3, nil, true)
	end
end

MissionSystem.rpc_end_mission = function (arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = NetworkLookup.mission_names[arg_25_2]

	arg_25_0:end_mission(var_25_0)
end

MissionSystem.rpc_update_mission = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	local var_26_0 = NetworkLookup.mission_names[arg_26_2]
	local var_26_1 = arg_26_0.active_missions[var_26_0]

	fassert(var_26_1, "[MissionSystem]:rpc_update_mission() Trying to update non-active mission %q", var_26_0)

	local var_26_2 = var_26_1.mission_data.mission_template_name
	local var_26_3 = MissionTemplates[var_26_2]

	var_26_3.sync(var_26_1, arg_26_3)
	var_26_3.update_text(var_26_1)

	if not var_26_1.mission_data.hidden then
		Managers.state.event:trigger("ui_event_update_mission", var_26_0, var_26_1.center_text or var_26_1.text)
	end
end

MissionSystem.get_missions = function (arg_27_0)
	return arg_27_0.active_missions, arg_27_0.completed_missions
end

MissionSystem.has_active_mission = function (arg_28_0, arg_28_1)
	return arg_28_0.active_missions[arg_28_1] ~= nil
end

MissionSystem.get_level_end_mission_data = function (arg_29_0, arg_29_1)
	return arg_29_0.level_end_missions[arg_29_1]
end

MissionSystem.set_percentage_completed = function (arg_30_0, arg_30_1)
	arg_30_0._percentage_completed = arg_30_1
end

MissionSystem._update_level_progress = function (arg_31_0, arg_31_1)
	if arg_31_0.is_server then
		local var_31_0 = Managers.state.conflict
		local var_31_1 = arg_31_0._percentage_completed
		local var_31_2 = Managers.player
		local var_31_3 = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

		for iter_31_0 = 1, #var_31_3 do
			local var_31_4 = var_31_3[iter_31_0]
			local var_31_5 = var_31_0:main_path_completion(var_31_4)
			local var_31_6 = var_31_2:owner(var_31_4):unique_id()

			if var_31_5 > (var_31_1[var_31_6] or 0) then
				var_31_1[var_31_6] = var_31_5
			end
		end
	end
end

MissionSystem.override_percentage_completed = function (arg_32_0, arg_32_1)
	if arg_32_0.is_server then
		arg_32_0._percentage_completed_override = arg_32_1
	end
end

MissionSystem.percentages_completed = function (arg_33_0)
	for iter_33_0, iter_33_1 in pairs(arg_33_0._percentage_completed) do
		local var_33_0 = arg_33_0._percentage_completed_override or iter_33_1

		arg_33_0._percentage_completed[iter_33_0] = math.clamp(var_33_0, 0, 1)
	end

	return arg_33_0._percentage_completed
end
