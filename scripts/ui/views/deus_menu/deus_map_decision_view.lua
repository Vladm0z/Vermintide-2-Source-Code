-- chunkname: @scripts/ui/views/deus_menu/deus_map_decision_view.lua

require("scripts/network/shared_state")
require("scripts/ui/views/deus_menu/deus_map_view")
require("scripts/settings/dlcs/morris/deus_map_visibility_settings")

DeusMapDecisionView = class(DeusMapDecisionView, DeusMapView)

local num = 5
local num_2 = 30
local num_3 = 5
local num_4 = 3
local num_5 = 2
local num_6 = 0.5
local num_7 = 1
local num_8 = 1
local tbl = {
	[DeusMapVisibilitySettings.WEAK_FOG_LEVEL] = {
		conflict_settings = true,
		shop = true,
		terror_event_power_up = true,
		theme = true,
		minor_modifier = true,
		level = true
	},
	[DeusMapVisibilitySettings.WEAK_FOG_LEVEL + 1] = {
		conflict_settings = false,
		shop = true,
		terror_event_power_up = true,
		theme = true,
		minor_modifier = true,
		level = true
	},
	[DeusMapVisibilitySettings.WEAK_FOG_LEVEL + 2] = {
		conflict_settings = false,
		shop = true,
		terror_event_power_up = false,
		theme = true,
		minor_modifier = false,
		level = false
	},
	[DeusMapVisibilitySettings.WEAK_FOG_LEVEL + 3] = {
		conflict_settings = false,
		shop = false,
		terror_event_power_up = false,
		theme = false,
		minor_modifier = false,
		level = false
	}
}
local tbl_2 = {
	ingame_final_node_selected = "hud_morris_world_map_level_chosen",
	token_move = "hud_morris_world_map_token_move",
	node_hover = "hud_morris_world_map_hover",
	node_pressed = "hud_morris_world_map_chose_level",
	shrine_final_node_selected = "hud_morris_map_shrine_open"
}
local tbl_3 = {
	TWITCH_STARTING = "TWITCH_STARTING",
	VOTING = "VOTING",
	FINISHED = "FINISHED",
	WAITING = "WAITING",
	VOTING_FINISHING = "VOTING_FINISHING",
	TWITCH_WAITING = "TWITCH_WAITING",
	FINISHING = "FINISHING",
	STARTING = "STARTING"
}
local tbl_4 = {
	server = {
		map_state = {
			default_value = "",
			type = "string",
			composite_keys = {}
		},
		final_node_selected = {
			default_value = "",
			type = "string",
			composite_keys = {}
		}
	},
	peer = {
		ready = {
			default_value = false,
			type = "boolean",
			composite_keys = {}
		},
		vote = {
			default_value = "",
			type = "string",
			composite_keys = {}
		}
	}
}

SharedState.validate_spec(tbl_4)

local function fn(self)
	-- function 1
	local tbl = {}
	local get_current_node = self:get_current_node()

	for i, v in ipairs(get_current_node.next) do
		local get_node = self:get_node(v)

		table.insert(tbl, get_node.node_type)
	end

	return tbl
end

DeusMapDecisionView.init = function (self, arg_2_1)
	-- function 2
	self.super.init(self, arg_2_1)

	self._is_server = arg_2_1.is_server
	self._server_peer_id = arg_2_1.server_peer_id
	self._own_peer_id = arg_2_1.own_peer_id
	self._network_server = arg_2_1.network_server
	self._wwise_world = arg_2_1.wwise_world
	self._world = arg_2_1.world

	local event = Managers.state.event

	event:register(self, "ingame_menu_opened", "on_ingame_menu_opened")
	event:register(self, "ingame_menu_closed", "on_ingame_menu_closed")
end

DeusMapDecisionView._start = function (self)
	-- function 3
	self._state = tbl_3.IDLE

	local get_current_node_key = self._deus_run_controller:get_current_node_key()

	self._shared_state = SharedState:new("deus_map_" .. self._deus_run_controller:get_run_id() .. "_" .. get_current_node_key, tbl_4, self._is_server, self._network_server, self._server_peer_id, self._own_peer_id)

	self._shared_state:register_rpcs(self._network_event_delegate)
	self._shared_state:full_sync()
	self._shared_state:set_own(self._shared_state:get_key("ready"), true)

	local get_current_node = self._deus_run_controller:get_current_node()

	if not self._is_server then
		local twitch = Managers.twitch
		local is_connected = twitch:is_connected()

		is_connected = not is_connected and #get_current_node.next == 2

		local get_key = self._shared_state:get_key("map_state")

		if not is_connected then
			self._deus_run_controller:request_standard_twitch_level_vote(twitch)
			self._shared_state:set_server(get_key, tbl_3.TWITCH_STARTING)
		else
			self._shared_state:set_server(get_key, tbl_3.STARTING)
		end

		self._shared_state:set_server(self._shared_state:get_key("final_node_selected"), "")

		local var_3_5
		local var_3_6 = fn(self._deus_run_controller)
		local flag

		flag = not table.contains(var_3_6, "shop") and "deus_before_shrine_tutorial" and "deus_map_tutorial"

		local find_dialogue_unit = LevelHelper:find_dialogue_unit(self._world, "ferry_lady_01")
		local extension_input = ScriptUnit.extension_input(find_dialogue_unit, "dialogue_system")
		local alloc_table = FrameTable.alloc_table()

		extension_input:trigger_dialogue_event(flag, alloc_table)
	end

	self._shared_state:set_own(self._shared_state:get_key("vote"), "")
	print("[DeusMapDecisionView] Self vote defaulted")

	if get_current_node_key ~= "start" then
		self._scene:set_zoomed_camera_to(get_current_node.layout_x, get_current_node.layout_y)
	end

	self._scene:animate_camera_to(get_current_node.layout_x, get_current_node.layout_y, num_5)

	local get_journey_name = self._deus_run_controller:get_journey_name()

	self._ui:set_journey_name(get_journey_name)
	self._ui:hide_content()
	self._ui:show_full_screen_rect()
	self._ui:set_alpha_multiplier(1)
	self._ui:fade_out(num_5)

	self._initial_animation_duration_left = num_5

	local get_map_visibility = self._deus_run_controller:get_map_visibility()

	self._visibility_data = get_map_visibility

	self._scene:setup_fog(get_map_visibility)

	local get_traversed_nodes = self._deus_run_controller:get_traversed_nodes()
	local str = "start"

	self._scene:traversed_node(str)

	for i = 1, #get_traversed_nodes do
		local var_3_15 = get_traversed_nodes[i]

		if var_3_15 ~= "start" then
			self._scene:traversed_node(var_3_15)
			self._scene:highlight_edge(str, var_3_15)

			str = var_3_15
		end
	end

	for i_2, v in ipairs(get_current_node.next) do
		self._scene:highlight_edge(get_current_node_key, v)
	end

	local get_unreachable_nodes = self._deus_run_controller:get_unreachable_nodes()

	for i_3, v_2 in ipairs(get_unreachable_nodes) do
		self._scene:unreachable_node(v_2)
	end

	self._scene:select_node(get_current_node_key)

	local get_arena_belakor_node = self._deus_run_controller:get_arena_belakor_node()
	local has_own_seen_arena_belakor_node = self._deus_run_controller:has_own_seen_arena_belakor_node()

	if not (not get_arena_belakor_node and has_own_seen_arena_belakor_node) then
		self._scene:animate_arena_belakor_node(get_arena_belakor_node)
	end
end

DeusMapDecisionView.register_rpcs = function (self, arg_4_1, arg_4_2)
	-- function 4
	DeusMapDecisionView.super.register_rpcs(self, arg_4_1, arg_4_2)

	self._network_event_delegate = arg_4_1
end

DeusMapDecisionView.unregister_rpcs = function (self)
	-- function 5
	DeusMapDecisionView.super.unregister_rpcs(self)

	self._network_event_delegate = nil
end

DeusMapDecisionView.destroy = function (self)
	-- function 6
	DeusMapDecisionView.super.destroy(self)
	self:unregister_rpcs()

	if not self._shared_state then
		self._shared_state:destroy()

		self._shared_state = nil
	end
end

DeusMapDecisionView._update = function (self, arg_7_1, arg_7_2)
	-- function 7
	local get_revision = self._shared_state:get_revision()
	local get_state_revision = self._deus_run_controller:get_state_revision()

	if not (self._shared_state_revision ~= get_revision or self._run_state_revision == get_state_revision) then
		self:_update_player_state()

		self._shared_state_revision = get_revision
		self._run_state_revision = get_state_revision
	end

	if not self._initial_animation_duration_left then
		self._initial_animation_duration_left = self._initial_animation_duration_left - arg_7_1

		if self._initial_animation_duration_left <= 0 then
			self._initial_animation_duration_left = nil

			self._ui:show_content()
			self._ui:hide_full_screen_rect()
			self._ui:set_alpha_multiplier(0)
			self._ui:fade_in(num_6)
		end
	end

	local get_server = self._shared_state:get_server(self._shared_state:get_key("map_state"))

	if not self._is_server then
		local _check_transition = self:_check_transition(get_server)

		if _check_transition ~= get_server then
			self._shared_state:set_server(self._shared_state:get_key("map_state"), _check_transition)

			get_server = _check_transition
		end
	end

	if self._prev_state ~= get_server then
		if get_server == tbl_3.TWITCH_STARTING then
			self:_on_enter_starting(arg_7_1, arg_7_2)
		elseif get_server == tbl_3.STARTING then
			self:_on_enter_starting(arg_7_1, arg_7_2)
		elseif get_server == tbl_3.WAITING then
			self:_on_enter_waiting(arg_7_1, arg_7_2)
		elseif get_server == tbl_3.TWITCH_WAITING then
			self:_on_enter_waiting(arg_7_1, arg_7_2)
		elseif get_server == tbl_3.VOTING then
			self:_on_enter_voting(arg_7_1, arg_7_2)
		elseif get_server == tbl_3.VOTING_FINISHING then
			self:_on_enter_voting_finishing(arg_7_1, arg_7_2)
		elseif get_server == tbl_3.FINISHING then
			self:_on_enter_finishing(arg_7_1, arg_7_2)
		elseif get_server == tbl_3.FINISHED then
			self:_on_enter_finished(arg_7_1, arg_7_2)
		end
	end

	if get_server == tbl_3.TWITCH_STARTING then
		self:_update_during_starting(arg_7_1, arg_7_2)
	elseif get_server == tbl_3.STARTING then
		self:_update_during_starting(arg_7_1, arg_7_2)
	elseif get_server == tbl_3.WAITING then
		self:_update_during_waiting(arg_7_1, arg_7_2)
	elseif get_server == tbl_3.VOTING then
		self:_update_during_voting(arg_7_1, arg_7_2)
	elseif get_server == tbl_3.VOTING_FINISHING then
		self:_update_during_voting_finishing(arg_7_1, arg_7_2)
	elseif get_server == tbl_3.FINISHING then
		self:_update_during_finishing(arg_7_1, arg_7_2)
	end

	self._prev_state = get_server
end

DeusMapDecisionView._get_rpcs = function (arg_8_0)
	-- function 8
	return nil
end

DeusMapDecisionView._node_pressed = function (self, arg_9_1)
	-- function 9
	if self._prev_state == tbl_3.TWITCH_WAITING then
		return
	end

	local get_own = self._shared_state:get_own(self._shared_state:get_key("vote"))

	get_own = get_own or ""

	local get_current_node_key = self._deus_run_controller:get_current_node_key()
	local get_graph_data = self._deus_run_controller:get_graph_data()
	local var_9_3 = get_graph_data[arg_9_1]
	local var_9_4 = get_graph_data[get_own]

	if get_own ~= "" then
		self._scene:unselect_node(get_own)

		for i, v in ipairs(var_9_4.next) do
			self._scene:unhighlight_edge(get_own, v)
		end
	else
		self._scene:unselect_node(get_current_node_key)
	end

	if get_own == arg_9_1 then
		if not Managers.input:is_device_active("gamepad") then
			self._scene:select_node(get_current_node_key, tbl_2.token_move)
			self._shared_state:set_own(self._shared_state:get_key("vote"), "")
			print("[DeusMapDecisionView] Self removed vote")
		else
			self._scene:select_node(get_own, tbl_2.token_move)
			self._shared_state:set_own(self._shared_state:get_key("vote"), get_own)
			print("[DeusMapDecisionView] Self replaced vote")

			for i_2, v_2 in ipairs(var_9_3.next) do
				self._scene:highlight_edge(get_own, v_2)
			end
		end
	else
		self._scene:select_node(arg_9_1, tbl_2.token_move)
		self._shared_state:set_own(self._shared_state:get_key("vote"), arg_9_1)
		print("[DeusMapDecisionView] Self voted for", arg_9_1)

		for i_3, v_3 in ipairs(var_9_3.next) do
			self._scene:highlight_edge(arg_9_1, v_3)
		end
	end

	if self._hovered_node == arg_9_1 then
		self:_enable_hover(arg_9_1)
	end

	self:_play_sound(tbl_2.node_pressed)
end

DeusMapDecisionView._node_hovered = function (self, arg_10_1)
	-- function 10
	self:_enable_hover(arg_10_1)
end

DeusMapDecisionView._node_unhovered = function (self)
	-- function 11
	self:_disable_hover()
end

DeusMapDecisionView._check_transition = function (self, arg_12_1)
	-- function 12
	if arg_12_1 == tbl_3.TWITCH_STARTING then
		if self._starting_countdown == 0 or not self:_are_all_peers_ready() then
			return tbl_3.TWITCH_WAITING
		end
	elseif arg_12_1 == tbl_3.STARTING then
		if self._starting_countdown == 0 or not self:_are_all_peers_ready() then
			return tbl_3.WAITING
		end
	elseif arg_12_1 == tbl_3.TWITCH_WAITING then
		if not self:_get_twitch_vote() then
			self:_handle_twitch_waiting_end()

			return tbl_3.FINISHING
		end
	elseif arg_12_1 == tbl_3.WAITING then
		if not self:_did_someone_vote() then
			return tbl_3.VOTING
		end
	elseif arg_12_1 == tbl_3.VOTING then
		if not self:_did_someone_vote() then
			return tbl_3.WAITING
		end

		if not self:_did_everyone_vote() then
			return tbl_3.VOTING_FINISHING
		end

		if self._voting_countdown == 0 then
			self:_handle_voting_end()

			return tbl_3.FINISHING
		end
	elseif arg_12_1 == tbl_3.VOTING_FINISHING then
		if not self:_did_someone_vote() then
			return tbl_3.WAITING
		end

		if self._voting_countdown == 0 then
			self:_handle_voting_end()

			return tbl_3.FINISHING
		end
	elseif not (arg_12_1 ~= tbl_3.FINISHING or self._final_countdown ~= 0) then
		return tbl_3.FINISHED
	end

	return arg_12_1
end

DeusMapDecisionView._enable_hover = function (self, arg_13_1)
	-- function 13
	if not self._hovered_node then
		self:_disable_hover()
	end

	local var_13_0 = self._deus_run_controller:get_graph_data()[arg_13_1]
	local var_13_1 = self._visibility_data[arg_13_1]
	local var_13_2 = tbl[var_13_1]
	local level = var_13_2.level
	local theme = var_13_2.theme
	local minor_modifier = var_13_2.minor_modifier
	local conflict_settings = var_13_2.conflict_settings
	local terror_event_power_up = var_13_2.terror_event_power_up
	local get_current_node = self._deus_run_controller:get_current_node()
	local get_own_peer_id = self._deus_run_controller:get_own_peer_id()
	local get_player_profile, var_13_11 = self._deus_run_controller:get_player_profile(get_own_peer_id, num_8)
	local _ui = self._ui
	local var_13_13 = _ui
	local enable_hover_text = _ui.enable_hover_text
	local get_screen_pos_of_node = self._scene:get_screen_pos_of_node(arg_13_1)
	local level_type = var_13_0.level_type
	local base_level

	if not level then
		base_level = var_13_0.base_level

		if not base_level then
			-- Nothing
		end
	end

	base_level = nil

	do
		local theme_2
	end

	::label_13_0::

	if not theme then
		theme_2 = var_13_0.theme

		if not theme_2 then
			-- Nothing
		end
	end

	theme_2 = nil

	do
		local minor_modifier_group
	end

	::label_13_1::

	if not minor_modifier then
		minor_modifier_group = var_13_0.minor_modifier_group

		if not minor_modifier_group then
			-- Nothing
		end
	end

	minor_modifier_group = nil

	do
		local conflict_settings_2
	end

	::label_13_2::

	if not conflict_settings then
		conflict_settings_2 = var_13_0.conflict_settings

		if not conflict_settings_2 then
			-- Nothing
		end
	end

	conflict_settings_2 = nil

	do
		local terror_event_power_up_2
	end

	::label_13_3::

	if not terror_event_power_up then
		terror_event_power_up_2 = var_13_0.terror_event_power_up

		if not terror_event_power_up_2 then
			-- Nothing
		end
	end

	terror_event_power_up_2 = nil

	do
		local grant_random_power_up_count
	end

	::label_13_4::

	if not terror_event_power_up then
		grant_random_power_up_count = var_13_0.grant_random_power_up_count

		if not grant_random_power_up_count then
			-- Nothing
		end
	end

	grant_random_power_up_count = nil

	do
		local terror_event_power_up_rarity
	end

	::label_13_5::

	if not terror_event_power_up then
		terror_event_power_up_rarity = var_13_0.terror_event_power_up_rarity

		if not terror_event_power_up_rarity then
			-- Nothing
		end
	end

	terror_event_power_up_rarity = nil

	::label_13_6::

	enable_hover_text(var_13_13, get_screen_pos_of_node, level_type, base_level, theme_2, minor_modifier_group, conflict_settings_2, terror_event_power_up_2, grant_random_power_up_count, terror_event_power_up_rarity, self._shared_state:get_own(self._shared_state:get_key("vote")) == arg_13_1, table.contains(get_current_node.next, arg_13_1), get_player_profile, var_13_11)
	self._scene:hover_node(arg_13_1)

	self._hovered_node = arg_13_1

	self:_play_sound(tbl_2.node_hover)
end

DeusMapDecisionView._disable_hover = function (self)
	-- function 14
	self._ui:disable_hover_text()
	self._scene:unhover_node(self._hovered_node)

	self._hovered_node = nil
end

DeusMapDecisionView._on_enter_starting = function (self, arg_15_1, arg_15_2)
	-- function 15
	self._ui:set_general_info(Localize("deus_map_info_waiting_title"), Localize("deus_map_info_waiting_desc"))

	self._starting_countdown = num
end

DeusMapDecisionView._update_during_starting = function (self, arg_16_1, arg_16_2)
	-- function 16
	self._starting_countdown = math.max(0, self._starting_countdown - arg_16_1)

	self._ui:update_timer(self._starting_countdown)
end

DeusMapDecisionView._on_enter_waiting = function (self, arg_17_1, arg_17_2)
	-- function 17
	self._ui:set_general_info(Localize("deus_map_info_voting_title"), Localize("deus_map_info_voting_desc"))

	local get_current_node = self._deus_run_controller:get_current_node()

	for i, v in ipairs(get_current_node.next) do
		self._scene:selectable_node(v)
	end

	self._ui:hide_timer()
end

DeusMapDecisionView._update_during_waiting = function (arg_18_0, arg_18_1, arg_18_2)
	-- function 18
	return
end

DeusMapDecisionView._on_enter_voting = function (self, arg_19_1, arg_19_2)
	-- function 19
	local get_current_node = self._deus_run_controller:get_current_node()

	for i, v in ipairs(get_current_node.next) do
		self._scene:selectable_node(v)
	end

	if not self._voting_countdown then
		self._voting_countdown = math.max(self._voting_countdown, num_3)
	else
		self._voting_countdown = num_2
	end
end

DeusMapDecisionView._update_during_voting = function (self, arg_20_1, arg_20_2)
	-- function 20
	self._voting_countdown = math.max(0, self._voting_countdown - arg_20_1)

	self._ui:update_timer(self._voting_countdown)
end

DeusMapDecisionView._on_enter_voting_finishing = function (self, arg_21_1, arg_21_2)
	-- function 21
	local get_current_node = self._deus_run_controller:get_current_node()

	for i, v in ipairs(get_current_node.next) do
		self._scene:selectable_node(v)
	end

	if not self._voting_countdown then
		self._voting_countdown = math.min(self._voting_countdown, num_3)
	else
		self._voting_countdown = num_3
	end
end

DeusMapDecisionView._update_during_voting_finishing = function (self, arg_22_1, arg_22_2)
	-- function 22
	self._voting_countdown = math.max(0, self._voting_countdown - arg_22_1)

	self._ui:update_timer(self._voting_countdown)
end

DeusMapDecisionView._on_enter_finishing = function (self, arg_23_1, arg_23_2)
	-- function 23
	self._final_countdown = num_4

	local get_current_node_key = self._deus_run_controller:get_current_node_key()
	local get_current_node = self._deus_run_controller:get_current_node()
	local get_own = self._shared_state:get_own(self._shared_state:get_key("vote"))

	get_own = get_own or ""

	if get_own ~= "" then
		self._scene:unselect_node(get_own)
	end

	local get_server = self._shared_state:get_server(self._shared_state:get_key("final_node_selected"))
	local var_23_4 = self._deus_run_controller:get_graph_data()[get_server]

	for i, v in ipairs(get_current_node.next) do
		self._scene:unselectable_node(v)

		if v ~= get_server then
			self._scene:unhighlight_edge(get_current_node_key, v)
		end
	end

	self._scene:set_final_node(get_server)
	self._scene:zoom_camera_to(var_23_4.layout_x, var_23_4.layout_y, num_5)
	self._ui:set_general_info(Localize("deus_map_info_finishing_title"), string.format(Localize("deus_map_info_finishing_desc"), Localize(var_23_4.base_level .. "_" .. "title")))
	self._deus_run_controller:map_finished_voting()
end

DeusMapDecisionView._on_enter_finished = function (self, arg_24_1, arg_24_2)
	-- function 24
	local _finish_cb = self._finish_cb

	if not _finish_cb then
		self._finish_cb = nil

		_finish_cb(self._shared_state:get_server(self._shared_state:get_key("final_node_selected")))
		self._ui:fade_out(num_7)
	end

	Managers.state.event:trigger("close_ingame_menu")
	self:_finish()
end

DeusMapDecisionView._finish = function (self)
	-- function 25
	DeusMapDecisionView.super._finish(self)

	self._voting_countdown = nil
	self._starting_countdown = nil
	self._final_countdown = nil

	if not self._shared_state then
		self._shared_state:unregister_rpcs()
		self._shared_state:destroy()

		self._shared_state = nil
	end
end

DeusMapDecisionView._update_during_finishing = function (self, arg_26_1, arg_26_2)
	-- function 26
	self._final_countdown = math.max(0, self._final_countdown - arg_26_1)

	self._ui:update_timer(self._final_countdown, Localize("game_starts_prepare"))
end

DeusMapDecisionView._update_player_state = function (self)
	-- function 27
	local tbl = {}
	local peer_id = Network.peer_id()
	local get_graph_data = self._deus_run_controller:get_graph_data()
	local var_27_3
	local get_peers = self._deus_run_controller:get_peers()

	for i, v in ipairs(get_peers) do
		if peer_id == v then
			var_27_3 = i
		end

		local tbl_2 = {}
		local get_player_profile, var_27_7 = self._deus_run_controller:get_player_profile(v, num_8)

		if not (get_player_profile == 0 or var_27_7 == 0) then
			tbl_2.profile_index = get_player_profile
			tbl_2.career_index = var_27_7
			tbl_2.level = self._deus_run_controller:get_player_level(v, tbl_2.profile_index)
			tbl_2.versus_level = self._deus_run_controller:get_versus_player_level(v)
			tbl_2.frame = self._deus_run_controller:get_player_frame(v, tbl_2.profile_index, tbl_2.career_index)
			tbl_2.name = self._deus_run_controller:get_player_name(v)

			local get_player_health_percentage = self._deus_run_controller:get_player_health_percentage(v, num_8)

			get_player_health_percentage = get_player_health_percentage or 1
			tbl_2.health_percentage = get_player_health_percentage
			tbl_2.healthkit_consumable = self._deus_run_controller:get_player_consumable_healthkit_slot(v, num_8)
			tbl_2.potion_consumable = self._deus_run_controller:get_player_consumable_potion_slot(v, num_8)
			tbl_2.grenade_consumable = self._deus_run_controller:get_player_consumable_grenade_slot(v, num_8)
			tbl_2.ammo_percentage = self._deus_run_controller:get_player_ranged_ammo(v, num_8)

			local get_player_soft_currency = self._deus_run_controller:get_player_soft_currency(v)

			get_player_soft_currency = get_player_soft_currency or 0
			tbl_2.soft_currency = get_player_soft_currency

			local get_peer = self._shared_state:get_peer(v, self._shared_state:get_key("vote"))

			get_peer = get_peer or ""

			local base_level

			if get_peer ~= "" then
				base_level = get_graph_data[get_peer].base_level

				if not base_level then
					-- Nothing
				end
			end

			base_level = nil

			::label_27_0::

			tbl_2.vote = base_level
		else
			tbl_2.profile_index = 0
			tbl_2.career_index = 0
			tbl_2.level = 1
			tbl_2.versus_level = 0
			tbl_2.frame = "default"
			tbl_2.health_percentage = 1
			tbl_2.soft_currency = 0
		end

		table.insert(tbl, tbl_2)
	end

	if not var_27_3 then
		tbl[var_27_3], tbl[1] = tbl[1], tbl[var_27_3]
	end

	self._ui:update_player_data(tbl)

	local get_current_node_key = self._deus_run_controller:get_current_node_key()
	local tbl_3 = {
		true,
		true,
		true,
		true,
		true
	}
	local get_server = self._shared_state:get_server(self._shared_state:get_key("final_node_selected"))

	for i_2, v_2 in ipairs(get_peers) do
		local get_player_profile_2, var_27_16 = self._deus_run_controller:get_player_profile(v_2, num_8)

		if get_player_profile_2 ~= 0 then
			local get_peer_2 = self._shared_state:get_peer(v_2, self._shared_state:get_key("vote"))
			local flag = not get_server and get_server ~= "" and get_server and not get_peer_2 or get_peer_2 ~= "" and get_peer_2 and get_current_node_key

			self._scene:place_token(get_player_profile_2, i_2, flag)

			tbl_3[get_player_profile_2] = false
		end
	end

	for k, v_3 in pairs(tbl_3) do
		if not v_3 then
			self._scene:hide_token(k)
		end
	end

	local get_own_peer_id = self._deus_run_controller:get_own_peer_id()
	local get_player_profile_3, var_27_21 = self._deus_run_controller:get_player_profile(get_own_peer_id, num_8)

	if get_player_profile_3 ~= 0 then
		local display_name = SPProfiles[get_player_profile_3].display_name

		self._scene:set_own_hero_name(display_name)
	end
end

DeusMapDecisionView._handle_voting_end = function (self)
	-- function 28
	local _deus_run_controller = self._deus_run_controller
	local tbl = {}
	local num = 0

	for i, v in ipairs(_deus_run_controller:get_peers()) do
		local get_peer = self._shared_state:get_peer(v, self._shared_state:get_key("vote"))

		get_peer = get_peer or ""

		if get_peer ~= "" then
			local var_28_4 = tbl[get_peer]
			local flag

			flag = not var_28_4 and var_28_4 + 1 and 1
			tbl[get_peer] = flag

			printf("[DeusMapDecisionView] Voting ended. %s voted for %s.", v, get_peer)

			if num < flag then
				num = flag
			end
		end
	end

	local tbl_3 = {}

	for k, v_2 in pairs(tbl) do
		if num <= v_2 then
			tbl_3[#tbl_3 + 1] = k
		end
	end

	local get_current_node = _deus_run_controller:get_current_node()

	if #tbl_3 == 0 then
		for i_2, v_3 in ipairs(get_current_node.next) do
			tbl_3[#tbl_3 + 1] = v_3
		end
	end

	local var_28_8 = tbl_3[Math.random(1, #tbl_3)]

	self._shared_state:set_server(self._shared_state:get_key("final_node_selected"), var_28_8)

	if _deus_run_controller:get_graph_data()[var_28_8].node_type == "shop" then
		self:_play_networked_2d_sound(tbl_2.shrine_final_node_selected)
	else
		self:_play_networked_2d_sound(tbl_2.ingame_final_node_selected)
	end
end

DeusMapDecisionView._handle_twitch_waiting_end = function (self)
	-- function 29
	local _get_twitch_vote = self:_get_twitch_vote()

	self._shared_state:set_server(self._shared_state:get_key("final_node_selected"), _get_twitch_vote)
end

DeusMapDecisionView._are_all_peers_ready = function (self)
	-- function 30
	for i, v in ipairs(self._deus_run_controller:get_peers()) do
		if self._shared_state:get_peer(v, self._shared_state:get_key("ready")) ~= true then
			return false
		end
	end

	return true
end

DeusMapDecisionView._get_twitch_vote = function (self)
	-- function 31
	local _is_server = self._is_server

	_is_server = not _is_server and self._deus_run_controller:get_twitch_level_vote()

	if not _is_server then
		return _is_server
	else
		return nil
	end
end

DeusMapDecisionView._did_someone_vote = function (self)
	-- function 32
	for i, v in ipairs(self._deus_run_controller:get_peers()) do
		local get_peer = self._shared_state:get_peer(v, self._shared_state:get_key("vote"))

		if not (get_peer == nil or get_peer == "") then
			return true
		end
	end

	return false
end

DeusMapDecisionView._did_everyone_vote = function (self)
	-- function 33
	for i, v in ipairs(self._deus_run_controller:get_peers()) do
		local get_peer = self._shared_state:get_peer(v, self._shared_state:get_key("vote"))

		get_peer = get_peer or ""

		if get_peer == "" then
			return false
		end
	end

	return true
end

DeusMapDecisionView._play_sound = function (self, arg_34_1)
	-- function 34
	WwiseWorld.trigger_event(self._wwise_world, arg_34_1)
end

DeusMapDecisionView._play_networked_2d_sound = function (arg_35_0, arg_35_1)
	-- function 35
	Managers.state.entity:system("audio_system"):play_2d_audio_event(arg_35_1)
end

DeusMapDecisionView.on_ingame_menu_opened = function (arg_36_0)
	-- function 36
	Managers.input:disable_gamepad_cursor()
end

DeusMapDecisionView.on_ingame_menu_closed = function (arg_37_0)
	-- function 37
	Managers.input:enable_gamepad_cursor()
end
