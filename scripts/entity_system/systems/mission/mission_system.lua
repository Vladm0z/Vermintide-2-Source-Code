-- chunkname: @scripts/entity_system/systems/mission/mission_system.lua

require("scripts/entity_system/systems/mission/mission_templates")
require("scripts/settings/missions")

MissionSystem = class(MissionSystem, ExtensionSystemBase)

local tbl = {
	"rpc_start_mission",
	"rpc_start_mission_with_unit",
	"rpc_end_mission",
	"rpc_request_mission",
	"rpc_request_mission_with_unit",
	"rpc_update_mission",
	"rpc_request_mission_update"
}
local tbl_2 = {}
local script_data = script_data
local debug_mission_system = script_data.debug_mission_system

debug_mission_system = debug_mission_system or Development.parameter("debug_mission_system")
script_data.debug_mission_system = debug_mission_system

MissionSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	MissionSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	self.active_missions = {}
	self.level_end_missions = {}
	self.completed_missions = {}
	self._only_once_missions = {}

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))

	self.statistics_db = arg_1_1.statistics_db

	local network = Managers.state.network

	self.network_manager = network
	self.network_transmit = network.network_transmit
	self.is_server = arg_1_1.is_server
	self._percentage_completed = {}
	self._use_level_progress = Managers.state.game_mode:setting("use_level_progress")
end

MissionSystem.create_checkpoint_data = function (self)
	-- function 2
	local world = self.world
	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(self.active_missions) do
		local tbl_3 = {}
		local unit = v.unit

		if not unit then
			tbl_3.unit_index = LevelHelper:unit_index(world, unit)
		end

		tbl_2[k] = tbl_3
	end

	tbl.active_missions = tbl_2

	local tbl_4 = {}

	for k_2, v_2 in pairs(self.completed_missions) do
		local tbl_5 = {}
		local unit_2 = v_2.unit

		if not unit_2 then
			tbl_5.unit_index = LevelHelper:unit_index(world, unit_2)
		end

		tbl_4[k_2] = tbl_5
	end

	tbl.completed_missions = tbl_4

	return tbl
end

MissionSystem.load_checkpoint_data = function (self, arg_3_1)
	-- function 3
	local world = self.world

	for k, v in pairs(arg_3_1.completed_missions) do
		local unit_index = v.unit_index
		local unit_by_index

		if not unit_index then
			unit_by_index = LevelHelper:unit_by_index(world, unit_index)

			if not unit_by_index then
				-- Nothing
			end
		end

		unit_by_index = nil

		::label_3_0::

		self:start_mission(k, unit_by_index)
		self:end_mission(k, true)
	end

	for k_2, v_2 in pairs(arg_3_1.active_missions) do
		local unit_index_2 = v_2.unit_index
		local unit_by_index_2

		if not unit_index_2 then
			unit_by_index_2 = LevelHelper:unit_by_index(world, unit_index_2)

			if not unit_by_index_2 then
				-- Nothing
			end
		end

		unit_by_index_2 = nil

		::label_3_1::

		self:start_mission(k_2, unit_by_index_2)
	end
end

MissionSystem.destroy = function (self)
	-- function 4
	self.network_event_delegate:unregister(self)

	self.network_event_delegate = nil
	self.network_transmit = nil
	self.network_manager = nil
end

MissionSystem.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	local dt = arg_5_1.dt
	local active_missions = self.active_missions

	for k, v in pairs(active_missions) do
		if not v.manual_update then
			self:update_mission(k, nil, dt)
		end
	end

	if not self._use_level_progress then
		self:_update_level_progress(dt)
	end

	if not script_data.debug_mission_system then
		self:debug_draw(dt)
	end
end

MissionSystem.request_mission = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	arg_6_3 = arg_6_3 or false

	local var_6_0 = NetworkLookup.mission_names[arg_6_1]
	local var_6_1

	if not arg_6_2 then
		var_6_1 = Level.unit_index(LevelHelper:current_level(self.world), arg_6_2)
	end

	if not self.is_server then
		if not self._only_once_missions[arg_6_1] then
			Debug.sticky_text("Request to start mission %q denied, only allowed once", arg_6_1)

			return
		end

		if not self.active_missions[arg_6_1] then
			Debug.sticky_text("Request to start mission %q denied, already started", arg_6_1)

			return
		end

		if not var_6_1 then
			self:start_mission(arg_6_1, arg_6_2, nil, arg_6_3)
		else
			self:start_mission(arg_6_1, nil, nil, arg_6_3)
		end

		local var_6_2 = self.active_missions[arg_6_1]
		local mission_template_name = var_6_2.mission_data.mission_template_name
		local create_sync_data = MissionTemplates[mission_template_name].create_sync_data(var_6_2)

		if not var_6_1 then
			self.network_transmit:send_rpc_clients("rpc_start_mission_with_unit", var_6_0, var_6_1, create_sync_data)
		else
			self.network_transmit:send_rpc_clients("rpc_start_mission", var_6_0, create_sync_data)
		end
	elseif not var_6_1 then
		self.network_transmit:send_rpc_server("rpc_request_mission_with_unit", var_6_0, var_6_1, arg_6_3)
	else
		self.network_transmit:send_rpc_server("rpc_request_mission", var_6_0, arg_6_3)
	end
end

MissionSystem.start_mission = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local var_7_0 = Missions[arg_7_1]
	local mission_template_name = var_7_0.mission_template_name
	local var_7_2 = MissionTemplates[mission_template_name]
	local var_7_3 = var_7_2.init(var_7_0, arg_7_2)

	var_7_3.mission_type = mission_template_name

	if not arg_7_3 then
		var_7_2.sync(var_7_3, arg_7_3)
	end

	var_7_2.update_text(var_7_3)

	if not (var_7_0.hidden or var_7_3.mission_data.is_side_mission) then
		local event = Managers.state.event
		local var_7_5 = event
		local trigger = event.trigger
		local str = "ui_event_add_mission_objective"
		local var_7_8 = arg_7_1
		local center_text = var_7_3.center_text

		center_text = center_text or var_7_3.text

		trigger(var_7_5, str, var_7_8, center_text, var_7_3.duration_text)
	end

	arg_7_0.active_missions[arg_7_1] = var_7_3

	if not arg_7_2 then
		Unit.flow_event(arg_7_2, "lua_mission_started")
	end

	if not var_7_3.evaluate_at_level_end then
		arg_7_0.level_end_missions[arg_7_1] = var_7_3
	end

	if not arg_7_4 then
		arg_7_0._only_once_missions[arg_7_1] = true
	end
end

MissionSystem.block_mission_ui = function (arg_8_0, arg_8_1)
	-- function 8
	Managers.state.event:trigger("ui_event_block_mission_ui", arg_8_1)
end

MissionSystem.trigger_active_mission_ui_events = function (self)
	-- function 9
	for k, v in pairs(self.active_missions) do
		if not (Missions[k].hidden or v.mission_data.is_side_mission) then
			local event = Managers.state.event
			local var_9_1 = event
			local trigger = event.trigger
			local str = "ui_event_add_mission_objective"
			local var_9_4 = k
			local center_text = v.center_text

			center_text = center_text or v.text

			trigger(var_9_1, str, var_9_4, center_text)
		end
	end
end

MissionSystem.end_mission = function (self, arg_10_1, arg_10_2)
	-- function 10
	fassert(self.active_missions[arg_10_1], "No active mission with passed mission_name %q", arg_10_1)

	local var_10_0 = self.active_missions[arg_10_1]
	local evaluate_mission = MissionTemplates[var_10_0.mission_data.mission_template_name].evaluate_mission(var_10_0)
	local flag

	flag = not var_10_0.mission_data.is_side_mission and "side_mission" and var_10_0.info_slate_type

	if not var_10_0.mission_data.hidden then
		Managers.state.event:trigger("ui_event_complete_mission", arg_10_1, var_10_0.mission_data.dont_show_mission_end_tooltip)
	end

	if not arg_10_2 and not self.is_server then
		local var_10_3 = NetworkLookup.mission_names[arg_10_1]

		self.network_transmit:send_rpc_clients("rpc_end_mission", var_10_3, evaluate_mission)
	end

	local unit = var_10_0.unit

	if not unit then
		local flag_2

		flag_2 = not evaluate_mission and "lua_mission_complete" and "lua_mission_failed"

		Unit.flow_event(unit, flag_2)
	end

	self.active_missions[arg_10_1] = nil
	self.completed_missions[arg_10_1] = var_10_0
end

MissionSystem.reset_mission = function (self, arg_11_1, arg_11_2)
	-- function 11
	fassert(self.active_missions[arg_11_1], "No active mission with passed mission_name %q", arg_11_1)

	local var_11_0 = self.active_missions[arg_11_1]
	local network_time = self.network_manager:network_time()
	local mission_template_name = var_11_0.mission_data.mission_template_name
	local var_11_3 = MissionTemplates[mission_template_name]

	var_11_3.reset_mission(var_11_0)
	var_11_3.update_text(var_11_0)

	if not var_11_0.mission_data.hidden then
		local event = Managers.state.event
		local var_11_5 = event
		local trigger = event.trigger
		local str = "ui_event_update_mission"
		local var_11_8 = arg_11_1
		local center_text = var_11_0.center_text

		center_text = center_text or var_11_0.text

		trigger(var_11_5, str, var_11_8, center_text)
	end

	if not arg_11_2 and not self.is_server then
		local var_11_10 = NetworkLookup.mission_names[arg_11_1]
		local create_sync_data = var_11_3.create_sync_data(var_11_0)

		self.network_transmit:send_rpc_clients("rpc_update_mission", var_11_10, create_sync_data)
	end
end

MissionSystem.update_mission = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	-- function 12
	fassert(self.active_missions[arg_12_1], "No active mission with passed mission_name %q", arg_12_1)

	local var_12_0 = self.active_missions[arg_12_1]
	local network_time = self.network_manager:network_time()
	local mission_template_name = var_12_0.mission_data.mission_template_name
	local var_12_3 = MissionTemplates[mission_template_name]
	local update = var_12_3.update(var_12_0, arg_12_2, arg_12_3, network_time)

	var_12_3.update_text(var_12_0)

	if not var_12_0.mission_data.hidden then
		local event = Managers.state.event
		local var_12_6 = event
		local trigger = event.trigger
		local str = "ui_event_update_mission"
		local var_12_9 = arg_12_1
		local center_text = var_12_0.center_text

		center_text = center_text or var_12_0.text

		trigger(var_12_6, str, var_12_9, center_text, var_12_0.duration_text)
	end

	if not arg_12_4 and not self.is_server then
		local var_12_11 = NetworkLookup.mission_names[arg_12_1]
		local create_sync_data = var_12_3.create_sync_data(var_12_0)

		self.network_transmit:send_rpc_clients("rpc_update_mission", var_12_11, create_sync_data)
	end

	if not update then
		self:end_mission(arg_12_1, arg_12_4)
	end
end

MissionSystem.evaluate_level_end_missions = function (self)
	-- function 13
	local level_end_missions = self.level_end_missions

	for k, v in pairs(level_end_missions) do
		if not MissionTemplates[v.mission_data.mission_template_name].evaluate_mission(v) then
			self:end_mission(k, false)
		end
	end
end

MissionSystem.debug_draw = function (self, arg_14_1)
	-- function 14
	for k, v in pairs(self.active_missions) do
		Debug.text(v.text)
	end
end

MissionSystem.hot_join_sync = function (self, arg_15_1)
	-- function 15
	for k, v in pairs(self.active_missions) do
		local var_15_0 = NetworkLookup.mission_names[k]
		local mission_template_name = v.mission_data.mission_template_name
		local create_sync_data = MissionTemplates[mission_template_name].create_sync_data(v)
		local unit = v.unit
		local var_15_4 = PEER_ID_TO_CHANNEL[arg_15_1]

		if not unit then
			local unit_index = Level.unit_index(LevelHelper:current_level(self.world), unit)

			RPC.rpc_start_mission_with_unit(var_15_4, var_15_0, unit_index, create_sync_data)
		else
			RPC.rpc_start_mission(var_15_4, var_15_0, create_sync_data)
		end
	end
end

MissionSystem.flow_callback_start_mission = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	-- function 16
	if not (arg_16_3 or self.is_server) then
		return
	end

	self:request_mission(arg_16_1, arg_16_2, arg_16_4)
end

MissionSystem.flow_callback_reset_mission = function (self, arg_17_1)
	-- function 17
	if not self.is_server then
		return
	end

	fassert(self.active_missions[arg_17_1], "No active mission with passed mission_name %q", arg_17_1)

	local mission_template_name = self.active_missions[arg_17_1].mission_data.mission_template_name

	if mission_template_name == "collect" then
		self:reset_mission(arg_17_1, true)
	else
		fassert(mission_template_name, "[flow_callback_reset_mission]: Reset function only suports COLLECT missions")
	end
end

MissionSystem.flow_callback_update_mission = function (self, arg_18_1)
	-- function 18
	if not self.is_server then
		return
	end

	fassert(self.active_missions[arg_18_1], "No active mission with passed mission_name %q", arg_18_1)

	local var_18_0 = self.active_missions[arg_18_1]

	fassert(var_18_0.manual_update, "MissionSystem:flow_callback_update_mission() Trying to update mission %q from flow", arg_18_1)
	self:update_mission(arg_18_1, true, nil, true)
end

MissionSystem.flow_callback_end_mission = function (self, arg_19_1)
	-- function 19
	if not self.is_server then
		return
	end

	self:end_mission(arg_19_1, true)
end

MissionSystem.rpc_start_mission = function (self, arg_20_1, arg_20_2, arg_20_3)
	-- function 20
	local var_20_0 = NetworkLookup.mission_names[arg_20_2]

	self:start_mission(var_20_0, nil, arg_20_3)
end

MissionSystem.rpc_start_mission_with_unit = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	-- function 21
	local var_21_0 = NetworkLookup.mission_names[arg_21_2]
	local unit_by_index = Level.unit_by_index(LevelHelper:current_level(self.world), arg_21_3)

	self:start_mission(var_21_0, unit_by_index, arg_21_4)
end

MissionSystem.rpc_request_mission = function (self, arg_22_1, arg_22_2, arg_22_3)
	-- function 22
	fassert(self.is_server, "[MissionSystem] Request mission ended up on a client")

	local var_22_0 = NetworkLookup.mission_names[arg_22_2]

	self:request_mission(var_22_0, nil, arg_22_3)
end

MissionSystem.rpc_request_mission_with_unit = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	-- function 23
	fassert(self.is_server, "[MissionSystem] Request mission ended up on a client")

	local var_23_0 = NetworkLookup.mission_names[arg_23_2]
	local unit_by_index = Level.unit_by_index(LevelHelper:current_level(self.world), arg_23_3)

	self:request_mission(var_23_0, unit_by_index, arg_23_4)
end

MissionSystem.rpc_request_mission_update = function (self, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	fassert(self.is_server, "[MissionSystem] Request mission update ended up on a client")

	local var_24_0 = NetworkLookup.mission_names[arg_24_2]

	if not self.active_missions[var_24_0] then
		local var_24_1 = self.active_missions[var_24_0]

		fassert(var_24_1.manual_update, "[MissionSystem] Requested an update on a mission not using manual updates", var_24_0)
		self:update_mission(var_24_0, arg_24_3, nil, true)
	end
end

MissionSystem.rpc_end_mission = function (self, arg_25_1, arg_25_2)
	-- function 25
	local var_25_0 = NetworkLookup.mission_names[arg_25_2]

	self:end_mission(var_25_0)
end

MissionSystem.rpc_update_mission = function (self, arg_26_1, arg_26_2, arg_26_3)
	-- function 26
	local var_26_0 = NetworkLookup.mission_names[arg_26_2]
	local var_26_1 = self.active_missions[var_26_0]

	fassert(var_26_1, "[MissionSystem]:rpc_update_mission() Trying to update non-active mission %q", var_26_0)

	local mission_template_name = var_26_1.mission_data.mission_template_name
	local var_26_3 = MissionTemplates[mission_template_name]

	var_26_3.sync(var_26_1, arg_26_3)
	var_26_3.update_text(var_26_1)

	if not var_26_1.mission_data.hidden then
		local event = Managers.state.event
		local var_26_5 = event
		local trigger = event.trigger
		local str = "ui_event_update_mission"
		local var_26_8 = var_26_0
		local center_text = var_26_1.center_text

		center_text = center_text or var_26_1.text

		trigger(var_26_5, str, var_26_8, center_text)
	end
end

MissionSystem.get_missions = function (self)
	-- function 27
	return self.active_missions, self.completed_missions
end

MissionSystem.has_active_mission = function (self, arg_28_1)
	-- function 28
	return self.active_missions[arg_28_1] ~= nil
end

MissionSystem.get_level_end_mission_data = function (self, arg_29_1)
	-- function 29
	return self.level_end_missions[arg_29_1]
end

MissionSystem.set_percentage_completed = function (self, arg_30_1)
	-- function 30
	self._percentage_completed = arg_30_1
end

MissionSystem._update_level_progress = function (self, arg_31_1)
	-- function 31
	if not self.is_server then
		local conflict = Managers.state.conflict
		local _percentage_completed = self._percentage_completed
		local player = Managers.player
		local PLAYER_AND_BOT_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

		for i = 1, #PLAYER_AND_BOT_UNITS do
			local var_31_4 = PLAYER_AND_BOT_UNITS[i]
			local main_path_completion = conflict:main_path_completion(var_31_4)
			local unique_id = player:owner(var_31_4):unique_id()
			local var_31_7 = _percentage_completed[unique_id]

			var_31_7 = var_31_7 or 0

			if var_31_7 < main_path_completion then
				_percentage_completed[unique_id] = main_path_completion
			end
		end
	end
end

MissionSystem.override_percentage_completed = function (self, arg_32_1)
	-- function 32
	if not self.is_server then
		self._percentage_completed_override = arg_32_1
	end
end

MissionSystem.percentages_completed = function (self)
	-- function 33
	for k, v in pairs(self._percentage_completed) do
		local _percentage_completed_override = self._percentage_completed_override

		_percentage_completed_override = _percentage_completed_override or v
		self._percentage_completed[k] = math.clamp(_percentage_completed_override, 0, 1)
	end

	return self._percentage_completed
end
