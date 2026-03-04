-- chunkname: @scripts/ui/views/deus_menu/deus_map_decision_view.lua

require("scripts/network/shared_state")
require("scripts/ui/views/deus_menu/deus_map_view")
require("scripts/settings/dlcs/morris/deus_map_visibility_settings")

DeusMapDecisionView = class(DeusMapDecisionView, DeusMapView)

local var_0_0 = 5
local var_0_1 = 30
local var_0_2 = 5
local var_0_3 = 3
local var_0_4 = 2
local var_0_5 = 0.5
local var_0_6 = 1
local var_0_7 = 1
local var_0_8 = {
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
local var_0_9 = {
	ingame_final_node_selected = "hud_morris_world_map_level_chosen",
	token_move = "hud_morris_world_map_token_move",
	node_hover = "hud_morris_world_map_hover",
	node_pressed = "hud_morris_world_map_chose_level",
	shrine_final_node_selected = "hud_morris_map_shrine_open"
}
local var_0_10 = {
	TWITCH_STARTING = "TWITCH_STARTING",
	VOTING = "VOTING",
	FINISHED = "FINISHED",
	WAITING = "WAITING",
	VOTING_FINISHING = "VOTING_FINISHING",
	TWITCH_WAITING = "TWITCH_WAITING",
	FINISHING = "FINISHING",
	STARTING = "STARTING"
}
local var_0_11 = {
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

SharedState.validate_spec(var_0_11)

local function var_0_12(arg_1_0)
	local var_1_0 = {}
	local var_1_1 = arg_1_0:get_current_node()

	for iter_1_0, iter_1_1 in ipairs(var_1_1.next) do
		local var_1_2 = arg_1_0:get_node(iter_1_1)

		table.insert(var_1_0, var_1_2.node_type)
	end

	return var_1_0
end

function DeusMapDecisionView.init(arg_2_0, arg_2_1)
	arg_2_0.super.init(arg_2_0, arg_2_1)

	arg_2_0._is_server = arg_2_1.is_server
	arg_2_0._server_peer_id = arg_2_1.server_peer_id
	arg_2_0._own_peer_id = arg_2_1.own_peer_id
	arg_2_0._network_server = arg_2_1.network_server
	arg_2_0._wwise_world = arg_2_1.wwise_world
	arg_2_0._world = arg_2_1.world

	local var_2_0 = Managers.state.event

	var_2_0:register(arg_2_0, "ingame_menu_opened", "on_ingame_menu_opened")
	var_2_0:register(arg_2_0, "ingame_menu_closed", "on_ingame_menu_closed")
end

function DeusMapDecisionView._start(arg_3_0)
	arg_3_0._state = var_0_10.IDLE

	local var_3_0 = arg_3_0._deus_run_controller:get_current_node_key()

	arg_3_0._shared_state = SharedState:new("deus_map_" .. arg_3_0._deus_run_controller:get_run_id() .. "_" .. var_3_0, var_0_11, arg_3_0._is_server, arg_3_0._network_server, arg_3_0._server_peer_id, arg_3_0._own_peer_id)

	arg_3_0._shared_state:register_rpcs(arg_3_0._network_event_delegate)
	arg_3_0._shared_state:full_sync()
	arg_3_0._shared_state:set_own(arg_3_0._shared_state:get_key("ready"), true)

	local var_3_1 = arg_3_0._deus_run_controller:get_current_node()

	if arg_3_0._is_server then
		local var_3_2 = Managers.twitch
		local var_3_3 = var_3_2:is_connected() and #var_3_1.next == 2
		local var_3_4 = arg_3_0._shared_state:get_key("map_state")

		if var_3_3 then
			arg_3_0._deus_run_controller:request_standard_twitch_level_vote(var_3_2)
			arg_3_0._shared_state:set_server(var_3_4, var_0_10.TWITCH_STARTING)
		else
			arg_3_0._shared_state:set_server(var_3_4, var_0_10.STARTING)
		end

		arg_3_0._shared_state:set_server(arg_3_0._shared_state:get_key("final_node_selected"), "")

		local var_3_5
		local var_3_6 = var_0_12(arg_3_0._deus_run_controller)
		local var_3_7 = table.contains(var_3_6, "shop") and "deus_before_shrine_tutorial" or "deus_map_tutorial"
		local var_3_8 = LevelHelper:find_dialogue_unit(arg_3_0._world, "ferry_lady_01")
		local var_3_9 = ScriptUnit.extension_input(var_3_8, "dialogue_system")
		local var_3_10 = FrameTable.alloc_table()

		var_3_9:trigger_dialogue_event(var_3_7, var_3_10)
	end

	arg_3_0._shared_state:set_own(arg_3_0._shared_state:get_key("vote"), "")
	print("[DeusMapDecisionView] Self vote defaulted")

	if var_3_0 ~= "start" then
		arg_3_0._scene:set_zoomed_camera_to(var_3_1.layout_x, var_3_1.layout_y)
	end

	arg_3_0._scene:animate_camera_to(var_3_1.layout_x, var_3_1.layout_y, var_0_4)

	local var_3_11 = arg_3_0._deus_run_controller:get_journey_name()

	arg_3_0._ui:set_journey_name(var_3_11)
	arg_3_0._ui:hide_content()
	arg_3_0._ui:show_full_screen_rect()
	arg_3_0._ui:set_alpha_multiplier(1)
	arg_3_0._ui:fade_out(var_0_4)

	arg_3_0._initial_animation_duration_left = var_0_4

	local var_3_12 = arg_3_0._deus_run_controller:get_map_visibility()

	arg_3_0._visibility_data = var_3_12

	arg_3_0._scene:setup_fog(var_3_12)

	local var_3_13 = arg_3_0._deus_run_controller:get_traversed_nodes()
	local var_3_14 = "start"

	arg_3_0._scene:traversed_node(var_3_14)

	for iter_3_0 = 1, #var_3_13 do
		local var_3_15 = var_3_13[iter_3_0]

		if var_3_15 ~= "start" then
			arg_3_0._scene:traversed_node(var_3_15)
			arg_3_0._scene:highlight_edge(var_3_14, var_3_15)

			var_3_14 = var_3_15
		end
	end

	for iter_3_1, iter_3_2 in ipairs(var_3_1.next) do
		arg_3_0._scene:highlight_edge(var_3_0, iter_3_2)
	end

	local var_3_16 = arg_3_0._deus_run_controller:get_unreachable_nodes()

	for iter_3_3, iter_3_4 in ipairs(var_3_16) do
		arg_3_0._scene:unreachable_node(iter_3_4)
	end

	arg_3_0._scene:select_node(var_3_0)

	local var_3_17 = arg_3_0._deus_run_controller:get_arena_belakor_node()
	local var_3_18 = arg_3_0._deus_run_controller:has_own_seen_arena_belakor_node()

	if var_3_17 and not var_3_18 then
		arg_3_0._scene:animate_arena_belakor_node(var_3_17)
	end
end

function DeusMapDecisionView.register_rpcs(arg_4_0, arg_4_1, arg_4_2)
	DeusMapDecisionView.super.register_rpcs(arg_4_0, arg_4_1, arg_4_2)

	arg_4_0._network_event_delegate = arg_4_1
end

function DeusMapDecisionView.unregister_rpcs(arg_5_0)
	DeusMapDecisionView.super.unregister_rpcs(arg_5_0)

	arg_5_0._network_event_delegate = nil
end

function DeusMapDecisionView.destroy(arg_6_0)
	DeusMapDecisionView.super.destroy(arg_6_0)
	arg_6_0:unregister_rpcs()

	if arg_6_0._shared_state then
		arg_6_0._shared_state:destroy()

		arg_6_0._shared_state = nil
	end
end

function DeusMapDecisionView._update(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0._shared_state:get_revision()
	local var_7_1 = arg_7_0._deus_run_controller:get_state_revision()

	if arg_7_0._shared_state_revision ~= var_7_0 or arg_7_0._run_state_revision ~= var_7_1 then
		arg_7_0:_update_player_state()

		arg_7_0._shared_state_revision = var_7_0
		arg_7_0._run_state_revision = var_7_1
	end

	if arg_7_0._initial_animation_duration_left then
		arg_7_0._initial_animation_duration_left = arg_7_0._initial_animation_duration_left - arg_7_1

		if arg_7_0._initial_animation_duration_left <= 0 then
			arg_7_0._initial_animation_duration_left = nil

			arg_7_0._ui:show_content()
			arg_7_0._ui:hide_full_screen_rect()
			arg_7_0._ui:set_alpha_multiplier(0)
			arg_7_0._ui:fade_in(var_0_5)
		end
	end

	local var_7_2 = arg_7_0._shared_state:get_server(arg_7_0._shared_state:get_key("map_state"))

	if arg_7_0._is_server then
		local var_7_3 = arg_7_0:_check_transition(var_7_2)

		if var_7_3 ~= var_7_2 then
			arg_7_0._shared_state:set_server(arg_7_0._shared_state:get_key("map_state"), var_7_3)

			var_7_2 = var_7_3
		end
	end

	if arg_7_0._prev_state ~= var_7_2 then
		if var_7_2 == var_0_10.TWITCH_STARTING then
			arg_7_0:_on_enter_starting(arg_7_1, arg_7_2)
		elseif var_7_2 == var_0_10.STARTING then
			arg_7_0:_on_enter_starting(arg_7_1, arg_7_2)
		elseif var_7_2 == var_0_10.WAITING then
			arg_7_0:_on_enter_waiting(arg_7_1, arg_7_2)
		elseif var_7_2 == var_0_10.TWITCH_WAITING then
			arg_7_0:_on_enter_waiting(arg_7_1, arg_7_2)
		elseif var_7_2 == var_0_10.VOTING then
			arg_7_0:_on_enter_voting(arg_7_1, arg_7_2)
		elseif var_7_2 == var_0_10.VOTING_FINISHING then
			arg_7_0:_on_enter_voting_finishing(arg_7_1, arg_7_2)
		elseif var_7_2 == var_0_10.FINISHING then
			arg_7_0:_on_enter_finishing(arg_7_1, arg_7_2)
		elseif var_7_2 == var_0_10.FINISHED then
			arg_7_0:_on_enter_finished(arg_7_1, arg_7_2)
		end
	end

	if var_7_2 == var_0_10.TWITCH_STARTING then
		arg_7_0:_update_during_starting(arg_7_1, arg_7_2)
	elseif var_7_2 == var_0_10.STARTING then
		arg_7_0:_update_during_starting(arg_7_1, arg_7_2)
	elseif var_7_2 == var_0_10.WAITING then
		arg_7_0:_update_during_waiting(arg_7_1, arg_7_2)
	elseif var_7_2 == var_0_10.VOTING then
		arg_7_0:_update_during_voting(arg_7_1, arg_7_2)
	elseif var_7_2 == var_0_10.VOTING_FINISHING then
		arg_7_0:_update_during_voting_finishing(arg_7_1, arg_7_2)
	elseif var_7_2 == var_0_10.FINISHING then
		arg_7_0:_update_during_finishing(arg_7_1, arg_7_2)
	end

	arg_7_0._prev_state = var_7_2
end

function DeusMapDecisionView._get_rpcs(arg_8_0)
	return nil
end

function DeusMapDecisionView._node_pressed(arg_9_0, arg_9_1)
	if arg_9_0._prev_state == var_0_10.TWITCH_WAITING then
		return
	end

	local var_9_0 = arg_9_0._shared_state:get_own(arg_9_0._shared_state:get_key("vote")) or ""
	local var_9_1 = arg_9_0._deus_run_controller:get_current_node_key()
	local var_9_2 = arg_9_0._deus_run_controller:get_graph_data()
	local var_9_3 = var_9_2[arg_9_1]
	local var_9_4 = var_9_2[var_9_0]

	if var_9_0 ~= "" then
		arg_9_0._scene:unselect_node(var_9_0)

		for iter_9_0, iter_9_1 in ipairs(var_9_4.next) do
			arg_9_0._scene:unhighlight_edge(var_9_0, iter_9_1)
		end
	else
		arg_9_0._scene:unselect_node(var_9_1)
	end

	if var_9_0 == arg_9_1 then
		if Managers.input:is_device_active("gamepad") then
			arg_9_0._scene:select_node(var_9_1, var_0_9.token_move)
			arg_9_0._shared_state:set_own(arg_9_0._shared_state:get_key("vote"), "")
			print("[DeusMapDecisionView] Self removed vote")
		else
			arg_9_0._scene:select_node(var_9_0, var_0_9.token_move)
			arg_9_0._shared_state:set_own(arg_9_0._shared_state:get_key("vote"), var_9_0)
			print("[DeusMapDecisionView] Self replaced vote")

			for iter_9_2, iter_9_3 in ipairs(var_9_3.next) do
				arg_9_0._scene:highlight_edge(var_9_0, iter_9_3)
			end
		end
	else
		arg_9_0._scene:select_node(arg_9_1, var_0_9.token_move)
		arg_9_0._shared_state:set_own(arg_9_0._shared_state:get_key("vote"), arg_9_1)
		print("[DeusMapDecisionView] Self voted for", arg_9_1)

		for iter_9_4, iter_9_5 in ipairs(var_9_3.next) do
			arg_9_0._scene:highlight_edge(arg_9_1, iter_9_5)
		end
	end

	if arg_9_0._hovered_node == arg_9_1 then
		arg_9_0:_enable_hover(arg_9_1)
	end

	arg_9_0:_play_sound(var_0_9.node_pressed)
end

function DeusMapDecisionView._node_hovered(arg_10_0, arg_10_1)
	arg_10_0:_enable_hover(arg_10_1)
end

function DeusMapDecisionView._node_unhovered(arg_11_0)
	arg_11_0:_disable_hover()
end

function DeusMapDecisionView._check_transition(arg_12_0, arg_12_1)
	if arg_12_1 == var_0_10.TWITCH_STARTING then
		if arg_12_0._starting_countdown == 0 or arg_12_0:_are_all_peers_ready() then
			return var_0_10.TWITCH_WAITING
		end
	elseif arg_12_1 == var_0_10.STARTING then
		if arg_12_0._starting_countdown == 0 or arg_12_0:_are_all_peers_ready() then
			return var_0_10.WAITING
		end
	elseif arg_12_1 == var_0_10.TWITCH_WAITING then
		if arg_12_0:_get_twitch_vote() then
			arg_12_0:_handle_twitch_waiting_end()

			return var_0_10.FINISHING
		end
	elseif arg_12_1 == var_0_10.WAITING then
		if arg_12_0:_did_someone_vote() then
			return var_0_10.VOTING
		end
	elseif arg_12_1 == var_0_10.VOTING then
		if not arg_12_0:_did_someone_vote() then
			return var_0_10.WAITING
		end

		if arg_12_0:_did_everyone_vote() then
			return var_0_10.VOTING_FINISHING
		end

		if arg_12_0._voting_countdown == 0 then
			arg_12_0:_handle_voting_end()

			return var_0_10.FINISHING
		end
	elseif arg_12_1 == var_0_10.VOTING_FINISHING then
		if not arg_12_0:_did_someone_vote() then
			return var_0_10.WAITING
		end

		if arg_12_0._voting_countdown == 0 then
			arg_12_0:_handle_voting_end()

			return var_0_10.FINISHING
		end
	elseif arg_12_1 == var_0_10.FINISHING and arg_12_0._final_countdown == 0 then
		return var_0_10.FINISHED
	end

	return arg_12_1
end

function DeusMapDecisionView._enable_hover(arg_13_0, arg_13_1)
	if arg_13_0._hovered_node then
		arg_13_0:_disable_hover()
	end

	local var_13_0 = arg_13_0._deus_run_controller:get_graph_data()[arg_13_1]
	local var_13_1 = arg_13_0._visibility_data[arg_13_1]
	local var_13_2 = var_0_8[var_13_1]
	local var_13_3 = var_13_2.level
	local var_13_4 = var_13_2.theme
	local var_13_5 = var_13_2.minor_modifier
	local var_13_6 = var_13_2.conflict_settings
	local var_13_7 = var_13_2.terror_event_power_up
	local var_13_8 = arg_13_0._deus_run_controller:get_current_node()
	local var_13_9 = arg_13_0._deus_run_controller:get_own_peer_id()
	local var_13_10, var_13_11 = arg_13_0._deus_run_controller:get_player_profile(var_13_9, var_0_7)

	arg_13_0._ui:enable_hover_text(arg_13_0._scene:get_screen_pos_of_node(arg_13_1), var_13_0.level_type, var_13_3 and var_13_0.base_level or nil, var_13_4 and var_13_0.theme or nil, var_13_5 and var_13_0.minor_modifier_group or nil, var_13_6 and var_13_0.conflict_settings or nil, var_13_7 and var_13_0.terror_event_power_up or nil, var_13_7 and var_13_0.grant_random_power_up_count or nil, var_13_7 and var_13_0.terror_event_power_up_rarity or nil, arg_13_0._shared_state:get_own(arg_13_0._shared_state:get_key("vote")) == arg_13_1, table.contains(var_13_8.next, arg_13_1), var_13_10, var_13_11)
	arg_13_0._scene:hover_node(arg_13_1)

	arg_13_0._hovered_node = arg_13_1

	arg_13_0:_play_sound(var_0_9.node_hover)
end

function DeusMapDecisionView._disable_hover(arg_14_0)
	arg_14_0._ui:disable_hover_text()
	arg_14_0._scene:unhover_node(arg_14_0._hovered_node)

	arg_14_0._hovered_node = nil
end

function DeusMapDecisionView._on_enter_starting(arg_15_0, arg_15_1, arg_15_2)
	arg_15_0._ui:set_general_info(Localize("deus_map_info_waiting_title"), Localize("deus_map_info_waiting_desc"))

	arg_15_0._starting_countdown = var_0_0
end

function DeusMapDecisionView._update_during_starting(arg_16_0, arg_16_1, arg_16_2)
	arg_16_0._starting_countdown = math.max(0, arg_16_0._starting_countdown - arg_16_1)

	arg_16_0._ui:update_timer(arg_16_0._starting_countdown)
end

function DeusMapDecisionView._on_enter_waiting(arg_17_0, arg_17_1, arg_17_2)
	arg_17_0._ui:set_general_info(Localize("deus_map_info_voting_title"), Localize("deus_map_info_voting_desc"))

	local var_17_0 = arg_17_0._deus_run_controller:get_current_node()

	for iter_17_0, iter_17_1 in ipairs(var_17_0.next) do
		arg_17_0._scene:selectable_node(iter_17_1)
	end

	arg_17_0._ui:hide_timer()
end

function DeusMapDecisionView._update_during_waiting(arg_18_0, arg_18_1, arg_18_2)
	return
end

function DeusMapDecisionView._on_enter_voting(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0._deus_run_controller:get_current_node()

	for iter_19_0, iter_19_1 in ipairs(var_19_0.next) do
		arg_19_0._scene:selectable_node(iter_19_1)
	end

	if arg_19_0._voting_countdown then
		arg_19_0._voting_countdown = math.max(arg_19_0._voting_countdown, var_0_2)
	else
		arg_19_0._voting_countdown = var_0_1
	end
end

function DeusMapDecisionView._update_during_voting(arg_20_0, arg_20_1, arg_20_2)
	arg_20_0._voting_countdown = math.max(0, arg_20_0._voting_countdown - arg_20_1)

	arg_20_0._ui:update_timer(arg_20_0._voting_countdown)
end

function DeusMapDecisionView._on_enter_voting_finishing(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_0._deus_run_controller:get_current_node()

	for iter_21_0, iter_21_1 in ipairs(var_21_0.next) do
		arg_21_0._scene:selectable_node(iter_21_1)
	end

	if arg_21_0._voting_countdown then
		arg_21_0._voting_countdown = math.min(arg_21_0._voting_countdown, var_0_2)
	else
		arg_21_0._voting_countdown = var_0_2
	end
end

function DeusMapDecisionView._update_during_voting_finishing(arg_22_0, arg_22_1, arg_22_2)
	arg_22_0._voting_countdown = math.max(0, arg_22_0._voting_countdown - arg_22_1)

	arg_22_0._ui:update_timer(arg_22_0._voting_countdown)
end

function DeusMapDecisionView._on_enter_finishing(arg_23_0, arg_23_1, arg_23_2)
	arg_23_0._final_countdown = var_0_3

	local var_23_0 = arg_23_0._deus_run_controller:get_current_node_key()
	local var_23_1 = arg_23_0._deus_run_controller:get_current_node()
	local var_23_2 = arg_23_0._shared_state:get_own(arg_23_0._shared_state:get_key("vote")) or ""

	if var_23_2 ~= "" then
		arg_23_0._scene:unselect_node(var_23_2)
	end

	local var_23_3 = arg_23_0._shared_state:get_server(arg_23_0._shared_state:get_key("final_node_selected"))
	local var_23_4 = arg_23_0._deus_run_controller:get_graph_data()[var_23_3]

	for iter_23_0, iter_23_1 in ipairs(var_23_1.next) do
		arg_23_0._scene:unselectable_node(iter_23_1)

		if iter_23_1 ~= var_23_3 then
			arg_23_0._scene:unhighlight_edge(var_23_0, iter_23_1)
		end
	end

	arg_23_0._scene:set_final_node(var_23_3)
	arg_23_0._scene:zoom_camera_to(var_23_4.layout_x, var_23_4.layout_y, var_0_4)
	arg_23_0._ui:set_general_info(Localize("deus_map_info_finishing_title"), string.format(Localize("deus_map_info_finishing_desc"), Localize(var_23_4.base_level .. "_" .. "title")))
	arg_23_0._deus_run_controller:map_finished_voting()
end

function DeusMapDecisionView._on_enter_finished(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_0._finish_cb

	if var_24_0 then
		arg_24_0._finish_cb = nil

		var_24_0(arg_24_0._shared_state:get_server(arg_24_0._shared_state:get_key("final_node_selected")))
		arg_24_0._ui:fade_out(var_0_6)
	end

	Managers.state.event:trigger("close_ingame_menu")
	arg_24_0:_finish()
end

function DeusMapDecisionView._finish(arg_25_0)
	DeusMapDecisionView.super._finish(arg_25_0)

	arg_25_0._voting_countdown = nil
	arg_25_0._starting_countdown = nil
	arg_25_0._final_countdown = nil

	if arg_25_0._shared_state then
		arg_25_0._shared_state:unregister_rpcs()
		arg_25_0._shared_state:destroy()

		arg_25_0._shared_state = nil
	end
end

function DeusMapDecisionView._update_during_finishing(arg_26_0, arg_26_1, arg_26_2)
	arg_26_0._final_countdown = math.max(0, arg_26_0._final_countdown - arg_26_1)

	arg_26_0._ui:update_timer(arg_26_0._final_countdown, Localize("game_starts_prepare"))
end

function DeusMapDecisionView._update_player_state(arg_27_0)
	local var_27_0 = {}
	local var_27_1 = Network.peer_id()
	local var_27_2 = arg_27_0._deus_run_controller:get_graph_data()
	local var_27_3
	local var_27_4 = arg_27_0._deus_run_controller:get_peers()

	for iter_27_0, iter_27_1 in ipairs(var_27_4) do
		if var_27_1 == iter_27_1 then
			var_27_3 = iter_27_0
		end

		local var_27_5 = {}
		local var_27_6, var_27_7 = arg_27_0._deus_run_controller:get_player_profile(iter_27_1, var_0_7)

		if var_27_6 ~= 0 and var_27_7 ~= 0 then
			var_27_5.profile_index = var_27_6
			var_27_5.career_index = var_27_7
			var_27_5.level = arg_27_0._deus_run_controller:get_player_level(iter_27_1, var_27_5.profile_index)
			var_27_5.versus_level = arg_27_0._deus_run_controller:get_versus_player_level(iter_27_1)
			var_27_5.frame = arg_27_0._deus_run_controller:get_player_frame(iter_27_1, var_27_5.profile_index, var_27_5.career_index)
			var_27_5.name = arg_27_0._deus_run_controller:get_player_name(iter_27_1)
			var_27_5.health_percentage = arg_27_0._deus_run_controller:get_player_health_percentage(iter_27_1, var_0_7) or 1
			var_27_5.healthkit_consumable = arg_27_0._deus_run_controller:get_player_consumable_healthkit_slot(iter_27_1, var_0_7)
			var_27_5.potion_consumable = arg_27_0._deus_run_controller:get_player_consumable_potion_slot(iter_27_1, var_0_7)
			var_27_5.grenade_consumable = arg_27_0._deus_run_controller:get_player_consumable_grenade_slot(iter_27_1, var_0_7)
			var_27_5.ammo_percentage = arg_27_0._deus_run_controller:get_player_ranged_ammo(iter_27_1, var_0_7)
			var_27_5.soft_currency = arg_27_0._deus_run_controller:get_player_soft_currency(iter_27_1) or 0

			local var_27_8 = arg_27_0._shared_state:get_peer(iter_27_1, arg_27_0._shared_state:get_key("vote")) or ""

			var_27_5.vote = var_27_8 ~= "" and var_27_2[var_27_8].base_level or nil
		else
			var_27_5.profile_index = 0
			var_27_5.career_index = 0
			var_27_5.level = 1
			var_27_5.versus_level = 0
			var_27_5.frame = "default"
			var_27_5.health_percentage = 1
			var_27_5.soft_currency = 0
		end

		table.insert(var_27_0, var_27_5)
	end

	if var_27_3 then
		var_27_0[var_27_3], var_27_0[1] = var_27_0[1], var_27_0[var_27_3]
	end

	arg_27_0._ui:update_player_data(var_27_0)

	local var_27_9 = arg_27_0._deus_run_controller:get_current_node_key()
	local var_27_10 = {
		true,
		true,
		true,
		true,
		true
	}
	local var_27_11 = arg_27_0._shared_state:get_server(arg_27_0._shared_state:get_key("final_node_selected"))

	for iter_27_2, iter_27_3 in ipairs(var_27_4) do
		local var_27_12, var_27_13 = arg_27_0._deus_run_controller:get_player_profile(iter_27_3, var_0_7)

		if var_27_12 ~= 0 then
			local var_27_14 = arg_27_0._shared_state:get_peer(iter_27_3, arg_27_0._shared_state:get_key("vote"))
			local var_27_15 = var_27_11 and var_27_11 ~= "" and var_27_11 or var_27_14 and var_27_14 ~= "" and var_27_14 or var_27_9

			arg_27_0._scene:place_token(var_27_12, iter_27_2, var_27_15)

			var_27_10[var_27_12] = false
		end
	end

	for iter_27_4, iter_27_5 in pairs(var_27_10) do
		if iter_27_5 then
			arg_27_0._scene:hide_token(iter_27_4)
		end
	end

	local var_27_16 = arg_27_0._deus_run_controller:get_own_peer_id()
	local var_27_17, var_27_18 = arg_27_0._deus_run_controller:get_player_profile(var_27_16, var_0_7)

	if var_27_17 ~= 0 then
		local var_27_19 = SPProfiles[var_27_17].display_name

		arg_27_0._scene:set_own_hero_name(var_27_19)
	end
end

function DeusMapDecisionView._handle_voting_end(arg_28_0)
	local var_28_0 = arg_28_0._deus_run_controller
	local var_28_1 = {}
	local var_28_2 = 0

	for iter_28_0, iter_28_1 in ipairs(var_28_0:get_peers()) do
		local var_28_3 = arg_28_0._shared_state:get_peer(iter_28_1, arg_28_0._shared_state:get_key("vote")) or ""

		if var_28_3 ~= "" then
			local var_28_4 = var_28_1[var_28_3]
			local var_28_5

			var_28_5 = var_28_4 and var_28_4 + 1 or 1
			var_28_1[var_28_3] = var_28_5

			printf("[DeusMapDecisionView] Voting ended. %s voted for %s.", iter_28_1, var_28_3)

			if var_28_2 < var_28_5 then
				var_28_2 = var_28_5
			end
		end
	end

	local var_28_6 = {}

	for iter_28_2, iter_28_3 in pairs(var_28_1) do
		if var_28_2 <= iter_28_3 then
			var_28_6[#var_28_6 + 1] = iter_28_2
		end
	end

	local var_28_7 = var_28_0:get_current_node()

	if #var_28_6 == 0 then
		for iter_28_4, iter_28_5 in ipairs(var_28_7.next) do
			var_28_6[#var_28_6 + 1] = iter_28_5
		end
	end

	local var_28_8 = var_28_6[Math.random(1, #var_28_6)]

	arg_28_0._shared_state:set_server(arg_28_0._shared_state:get_key("final_node_selected"), var_28_8)

	if var_28_0:get_graph_data()[var_28_8].node_type == "shop" then
		arg_28_0:_play_networked_2d_sound(var_0_9.shrine_final_node_selected)
	else
		arg_28_0:_play_networked_2d_sound(var_0_9.ingame_final_node_selected)
	end
end

function DeusMapDecisionView._handle_twitch_waiting_end(arg_29_0)
	local var_29_0 = arg_29_0:_get_twitch_vote()

	arg_29_0._shared_state:set_server(arg_29_0._shared_state:get_key("final_node_selected"), var_29_0)
end

function DeusMapDecisionView._are_all_peers_ready(arg_30_0)
	for iter_30_0, iter_30_1 in ipairs(arg_30_0._deus_run_controller:get_peers()) do
		if arg_30_0._shared_state:get_peer(iter_30_1, arg_30_0._shared_state:get_key("ready")) ~= true then
			return false
		end
	end

	return true
end

function DeusMapDecisionView._get_twitch_vote(arg_31_0)
	local var_31_0 = arg_31_0._is_server and arg_31_0._deus_run_controller:get_twitch_level_vote()

	if var_31_0 then
		return var_31_0
	else
		return nil
	end
end

function DeusMapDecisionView._did_someone_vote(arg_32_0)
	for iter_32_0, iter_32_1 in ipairs(arg_32_0._deus_run_controller:get_peers()) do
		local var_32_0 = arg_32_0._shared_state:get_peer(iter_32_1, arg_32_0._shared_state:get_key("vote"))

		if var_32_0 ~= nil and var_32_0 ~= "" then
			return true
		end
	end

	return false
end

function DeusMapDecisionView._did_everyone_vote(arg_33_0)
	for iter_33_0, iter_33_1 in ipairs(arg_33_0._deus_run_controller:get_peers()) do
		if (arg_33_0._shared_state:get_peer(iter_33_1, arg_33_0._shared_state:get_key("vote")) or "") == "" then
			return false
		end
	end

	return true
end

function DeusMapDecisionView._play_sound(arg_34_0, arg_34_1)
	WwiseWorld.trigger_event(arg_34_0._wwise_world, arg_34_1)
end

function DeusMapDecisionView._play_networked_2d_sound(arg_35_0, arg_35_1)
	Managers.state.entity:system("audio_system"):play_2d_audio_event(arg_35_1)
end

function DeusMapDecisionView.on_ingame_menu_opened(arg_36_0)
	Managers.input:disable_gamepad_cursor()
end

function DeusMapDecisionView.on_ingame_menu_closed(arg_37_0)
	Managers.input:enable_gamepad_cursor()
end
