-- chunkname: @scripts/ui/views/level_end/level_end_view_base.lua

require("scripts/ui/reward_popup/reward_popup_ui")
DLCUtils.require_list("end_view_state")

local var_0_0 = local_require("scripts/ui/views/level_end/level_end_view_base_definitions")
local var_0_1 = {}

for iter_0_0, iter_0_1 in pairs(DLCSettings) do
	local var_0_2 = iter_0_1.portrait_materials

	if var_0_2 then
		for iter_0_2, iter_0_3 in ipairs(var_0_2) do
			var_0_1[#var_0_1 + 1] = iter_0_3
		end
	end
end

local var_0_3 = 3
local var_0_4 = 4

LevelEndViewBase = class(LevelEndViewBase)

function LevelEndViewBase.init(arg_1_0, arg_1_1)
	arg_1_0:setup_world(arg_1_1)
	arg_1_0:setup_transition_data()

	local var_1_0 = arg_1_1.game_won
	local var_1_1 = arg_1_1.rewards

	arg_1_0.context = arg_1_1
	arg_1_0.game_won = var_1_0
	arg_1_0.challenge_progression_status = arg_1_1.challenge_progression_status
	arg_1_0.game_mode_key = arg_1_1.game_mode_key
	arg_1_0.player_manager = arg_1_1.player_manager
	arg_1_0.input_manager = arg_1_1.input_manager
	arg_1_0.ingame_ui = arg_1_1.ingame_ui
	arg_1_0.profile_synchronizer = arg_1_1.profile_synchronizer
	arg_1_0.peer_id = arg_1_1.peer_id
	arg_1_0.local_player_id = arg_1_1.local_player_id
	arg_1_0.rewards = var_1_1
	arg_1_0.render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = true
	}
	arg_1_0._lobby = arg_1_1.lobby
	arg_1_0.is_server = arg_1_1.is_server
	arg_1_0._state_speed_mult = 1
	arg_1_0._state_machine_complete = false
	arg_1_0._skip_pressed = false

	if not arg_1_0.is_server then
		local var_1_2 = Managers.player:statistics_db()

		arg_1_0.context.players_session_score = arg_1_0._players_session_score or Managers.mechanism:get_players_session_score(var_1_2, arg_1_0.profile_synchronizer)
		arg_1_0._players_session_score = arg_1_0.context.players_session_score
	end

	local var_1_3 = script_data["eac-untrusted"]

	arg_1_0._is_untrusted = var_1_3

	if not var_1_3 then
		arg_1_0.level_up_rewards = arg_1_0:_get_level_up_rewards()
		arg_1_0.deed_rewards = arg_1_0:_get_deed_rewards()
		arg_1_0.deus_rewards = arg_1_0:_get_deus_rewards()
		arg_1_0.keep_decoration_rewards = arg_1_0:_get_keep_decoration_rewards()
		arg_1_0.event_rewards = arg_1_0:_get_event_rewards()
		arg_1_0.win_track_rewards = arg_1_0:_get_win_track_rewards()
		arg_1_0.versus_level_up_rewards = arg_1_0:_get_versus_level_up_rewards()
	end

	arg_1_0._reward_presentation_queue = {}
	arg_1_0.reward_popup = RewardPopupUI:new(arg_1_1)

	local var_1_4 = arg_1_0:setup_pages(var_1_0, var_1_1)
	local var_1_5 = {}

	for iter_1_0, iter_1_1 in pairs(var_1_4) do
		var_1_5[iter_1_1] = iter_1_0
	end

	arg_1_0._index_by_state_name = var_1_4
	arg_1_0._state_name_by_index = var_1_5
	arg_1_0._state_machine_params = {
		parent = arg_1_0,
		context = arg_1_1,
		game_won = var_1_0,
		game_mode_key = arg_1_0.game_mode_key
	}

	arg_1_0:setup_camera()
	arg_1_0:create_ui_elements()

	arg_1_0._done_peers = {}
	arg_1_0._wants_reload = {}
	arg_1_0.waiting_to_start = true
	arg_1_0._wants_to_exit_to_game = nil
	arg_1_0._started_exit = nil

	if arg_1_0._lobby == nil then
		arg_1_0:left_lobby()
	end
end

function LevelEndViewBase.state_machine_completed(arg_2_0)
	return arg_2_0._state_machine_complete
end

function LevelEndViewBase.setup_transition_data(arg_3_0)
	arg_3_0._transition_animations = {}
	arg_3_0._transition_render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = true
	}
	arg_3_0._transition_scenegraph_ui = UISceneGraph.init_scenegraph(var_0_0.transition_scenegraph_definition)
	arg_3_0._transition_widgets, arg_3_0._transition_widgets_by_name = UIUtils.create_widgets(var_0_0.transition_widget_definition)

	UIRenderer.clear_scenegraph_queue(arg_3_0.ui_renderer)

	arg_3_0._transition_ui_animator = UIAnimator:new(arg_3_0._transition_scenegraph_ui, var_0_0.transition_animations)
end

function LevelEndViewBase.trigger_transition(arg_4_0, arg_4_1)
	arg_4_0:_cleanup_transitions()

	local var_4_0 = {
		parent = arg_4_0,
		render_settings = arg_4_0._transition_render_settings,
		transition_data = arg_4_1
	}
	local var_4_1 = arg_4_0._transition_widgets
	local var_4_2 = arg_4_1.animation_name or "default"

	arg_4_0._transition_animations[#arg_4_0._transition_animations + 1] = arg_4_0._transition_ui_animator:start_animation(var_4_2, var_4_1, var_0_0.transition_scenegraph_definition, var_4_0)
end

function LevelEndViewBase.transition_camera(arg_5_0, arg_5_1)
	if not arg_5_1.camera_name then
		return
	end

	local var_5_0
	local var_5_1 = arg_5_1.level_name or "levels/end_screen/world"
	local var_5_2 = LevelResource.unit_indices(var_5_1, "units/hub_elements/cutscene_camera/cutscene_camera")

	for iter_5_0, iter_5_1 in pairs(var_5_2) do
		local var_5_3 = LevelResource.unit_data(var_5_1, iter_5_1)
		local var_5_4 = DynamicData.get(var_5_3, "name")

		if var_5_4 and var_5_4 == arg_5_1.camera_name then
			local var_5_5 = LevelResource.unit_position(var_5_1, iter_5_1)
			local var_5_6 = LevelResource.unit_rotation(var_5_1, iter_5_1)
			local var_5_7 = Matrix4x4.from_quaternion_position(var_5_6, var_5_5)

			var_5_0 = Matrix4x4Box(var_5_7)

			print("Found camera: " .. var_5_4)
		end
	end

	arg_5_0._camera_pose = var_5_0

	arg_5_0:position_camera()
end

function LevelEndViewBase._cleanup_transitions(arg_6_0)
	for iter_6_0, iter_6_1 in pairs(arg_6_0._transition_animations) do
		arg_6_0._transition_ui_animator:stop_animation(iter_6_1)
	end

	table.clear(arg_6_0._transition_animations)
end

function LevelEndViewBase._update_transition_fade(arg_7_0, arg_7_1, arg_7_2)
	if table.is_empty(arg_7_0._transition_animations) then
		return
	end

	arg_7_0:_update_transition_animations(arg_7_1, arg_7_2)
	arg_7_0:_draw_transition_widgets(arg_7_1, arg_7_2)
end

function LevelEndViewBase._draw_transition_widgets(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0.ui_renderer
	local var_8_1 = arg_8_0.ui_top_renderer
	local var_8_2 = arg_8_0._transition_scenegraph_ui
	local var_8_3 = arg_8_0.input_manager
	local var_8_4 = arg_8_0._transition_render_settings
	local var_8_5 = arg_8_0:input_service()

	UIRenderer.begin_pass(var_8_0, var_8_2, var_8_5, arg_8_1, nil, var_8_4)

	for iter_8_0, iter_8_1 in ipairs(arg_8_0._transition_widgets) do
		UIRenderer.draw_widget(var_8_0, iter_8_1)
	end

	UIRenderer.end_pass(var_8_0)
end

function LevelEndViewBase._update_transition_animations(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0._transition_ui_animator

	var_9_0:update(arg_9_1)

	for iter_9_0 = #arg_9_0._transition_animations, 1, -1 do
		local var_9_1 = arg_9_0._transition_animations[iter_9_0]

		if var_9_0:is_animation_completed(var_9_1) then
			arg_9_0._transition_animations[iter_9_0] = nil
		end
	end
end

function LevelEndViewBase.enable_chat(arg_10_0)
	return true
end

function LevelEndViewBase.start(arg_11_0)
	arg_11_0:_activate_viewport()

	arg_11_0.waiting_to_start = nil
	arg_11_0.state_auto_change = true

	arg_11_0:_proceed_to_next_auto_state(1, #arg_11_0._state_name_by_index)
end

function LevelEndViewBase.on_enter(arg_12_0)
	arg_12_0._state_speed_mult = 1
end

function LevelEndViewBase.on_exit(arg_13_0)
	if not arg_13_0._is_untrusted then
		local var_13_0 = Managers.state.difficulty:get_difficulty()
		local var_13_1 = LootChestData.chests_by_category[var_13_0].package_name

		Managers.package:unload(var_13_1, "global")
	end
end

function LevelEndViewBase._vote_to_leave_game(arg_14_0)
	Managers.state.voting:vote(1)

	arg_14_0._voted = true
end

function LevelEndViewBase.exit_to_game(arg_15_0)
	arg_15_0._exit_timer = 2
	arg_15_0._started_exit = true
end

function LevelEndViewBase.done(arg_16_0)
	return arg_16_0._wants_to_exit_to_game
end

function LevelEndViewBase.setup_pages(arg_17_0, arg_17_1, arg_17_2)
	return {}
end

function LevelEndViewBase.create_ui_elements(arg_18_0)
	return
end

function LevelEndViewBase._activate_viewport(arg_19_0)
	local var_19_0, var_19_1 = arg_19_0:get_viewport_world()

	ScriptWorld.activate_viewport(var_19_0, var_19_1)
end

function LevelEndViewBase.get_world_link_unit(arg_20_0)
	local var_20_0 = "levels/end_screen/world"
	local var_20_1 = arg_20_0:get_viewport_world()
	local var_20_2 = ScriptWorld.level(var_20_1, var_20_0)

	if var_20_2 then
		local var_20_3 = Level.units(var_20_2)

		for iter_20_0, iter_20_1 in ipairs(var_20_3) do
			local var_20_4 = Unit.get_data(iter_20_1, "name")

			if var_20_4 and var_20_4 == "loot_chest_spawn" then
				return iter_20_1
			end
		end
	end
end

function LevelEndViewBase.get_viewport_world(arg_21_0)
	return arg_21_0._world, arg_21_0._world_viewport
end

function LevelEndViewBase.post_update(arg_22_0)
	return
end

function LevelEndViewBase.update(arg_23_0, arg_23_1, arg_23_2)
	if arg_23_0.suspended or arg_23_0.waiting_for_post_update_enter then
		return
	end

	local var_23_0 = arg_23_0._active_camera_shakes

	if var_23_0 then
		for iter_23_0, iter_23_1 in pairs(var_23_0) do
			arg_23_0:_apply_shake_event(iter_23_0, arg_23_2)
		end
	end

	local var_23_1 = arg_23_0:input_service()

	if arg_23_0._started_force_shutdown then
		arg_23_0:update_force_shutdown(arg_23_1)
	end

	if arg_23_0._started_exit then
		arg_23_0:_update_exit(arg_23_1)
	end

	if arg_23_0.reward_popup then
		arg_23_0.reward_popup:update(arg_23_1)
	end

	arg_23_0:_handle_queued_presentations()
	arg_23_0:_update_transition_fade(arg_23_1, arg_23_2)

	if arg_23_0._machine then
		if arg_23_0._state_can_speed_up then
			local var_23_2 = 1
			local var_23_3 = arg_23_0.input_manager:get_service("end_of_level")

			arg_23_0._skip_pressed = var_23_3:get("skip_pressed") or var_23_3:get("confirm_press")

			if var_23_3:get("confirm_hold", true) or var_23_3:get("skip", true) then
				var_23_2 = var_0_3
			end

			local var_23_4 = arg_23_0._state_speed_mult
			local var_23_5 = math.lerp(var_23_4, var_23_2, var_0_4 * arg_23_1)
			local var_23_6 = math.clamp(var_23_5, 1, var_0_3)

			arg_23_1 = arg_23_1 * var_23_6
			arg_23_0._state_speed_mult = var_23_6
		end

		arg_23_0._machine:update(arg_23_1, arg_23_2)

		if arg_23_0._new_state_name then
			arg_23_0:_handle_state_exit()
		elseif arg_23_0.state_auto_change then
			arg_23_0:_handle_state_auto_change()
		elseif arg_23_0._page_selector_widget then
			local var_23_7 = arg_23_0:_is_page_selector_pressed()

			if var_23_7 then
				local var_23_8 = arg_23_0._state_name_by_index[var_23_7]

				arg_23_0:_request_state_change(var_23_8)
			end
		end
	end
end

function LevelEndViewBase.skip_pressed(arg_24_0)
	return arg_24_0._skip_pressed
end

function LevelEndViewBase.transitioning(arg_25_0)
	return arg_25_0.exiting
end

function LevelEndViewBase.left_lobby(arg_26_0)
	arg_26_0._left_lobby = true
	arg_26_0._lobby = nil

	if arg_26_0._done_peers[Network.peer_id()] then
		arg_26_0:exit_to_game()
	end
end

function LevelEndViewBase.destroy(arg_27_0, arg_27_1)
	arg_27_0.ui_animator = nil

	arg_27_0:_cleanup_transitions()

	if arg_27_0._machine then
		arg_27_0._machine:destroy()

		arg_27_0._machine = nil
	end

	if arg_27_0.reward_popup then
		arg_27_0.reward_popup:destroy()

		arg_27_0.reward_popup = nil
	end

	arg_27_0:_pop_mouse_cursor()
	arg_27_0:play_sound("play_gui_chestroom_stop")
	arg_27_0:play_sound("unmute_all_world_sounds")
	arg_27_0:destroy_world()

	if not arg_27_1 then
		Managers.mechanism:unload_end_screen_resources()
	end
end

function LevelEndViewBase.play_sound(arg_28_0, arg_28_1)
	WwiseWorld.trigger_event(arg_28_0.wwise_world, arg_28_1)
end

function LevelEndViewBase._is_button_pressed(arg_29_0, arg_29_1)
	local var_29_0 = arg_29_1.content.button_hotspot

	if var_29_0.on_release then
		var_29_0.on_release = nil

		return true
	end
end

function LevelEndViewBase._is_button_hover_enter(arg_30_0, arg_30_1)
	return arg_30_1.content.button_hotspot.on_hover_enter
end

function LevelEndViewBase._is_page_selector_pressed(arg_31_0)
	local var_31_0 = arg_31_0._page_selector_widget.content
	local var_31_1 = var_31_0.amount

	for iter_31_0 = 1, var_31_1 do
		local var_31_2 = "_" .. tostring(iter_31_0)
		local var_31_3 = var_31_0["hotspot" .. var_31_2]

		if var_31_3.on_release and not var_31_3.is_selected then
			return iter_31_0
		end
	end
end

function LevelEndViewBase._set_page_selector_selection(arg_32_0, arg_32_1)
	local var_32_0 = arg_32_0._page_selector_widget.content
	local var_32_1 = var_32_0.amount

	for iter_32_0 = 1, var_32_1 do
		local var_32_2 = "_" .. tostring(iter_32_0)

		var_32_0["hotspot" .. var_32_2].is_selected = arg_32_1 == iter_32_0
	end
end

function LevelEndViewBase._update_exit(arg_33_0, arg_33_1)
	arg_33_0._exit_timer = math.max(0, arg_33_0._exit_timer - arg_33_1)

	if arg_33_0._exit_timer == 0 then
		arg_33_0._started_exit = false
		arg_33_0._wants_to_exit_to_game = true
	end
end

function LevelEndViewBase.do_retry(arg_34_0)
	return false
end

function LevelEndViewBase._get_level_up_rewards(arg_35_0)
	local var_35_0 = arg_35_0.context.rewards.end_of_level_rewards
	local var_35_1 = {}

	for iter_35_0, iter_35_1 in pairs(var_35_0) do
		if string.find(iter_35_0, "level_up_reward") == 1 then
			local var_35_2 = string.split_deprecated(iter_35_0, ";")
			local var_35_3 = tonumber(var_35_2[2])
			local var_35_4 = tonumber(var_35_2[3])

			if not var_35_1[var_35_3] then
				var_35_1[var_35_3] = {}
			end

			var_35_1[var_35_3][var_35_4] = iter_35_1
		end
	end

	return var_35_1
end

function LevelEndViewBase._get_versus_level_up_rewards(arg_36_0)
	local var_36_0 = arg_36_0.context.rewards.end_of_level_rewards
	local var_36_1 = {}

	for iter_36_0, iter_36_1 in pairs(var_36_0) do
		if string.find(iter_36_0, "vs_level_up_reward") == 1 then
			local var_36_2 = string.split_deprecated(iter_36_0, ";")
			local var_36_3 = tonumber(var_36_2[2])
			local var_36_4 = tonumber(var_36_2[3])

			if not var_36_1[var_36_3] then
				var_36_1[var_36_3] = {}
			end

			var_36_1[var_36_3][var_36_4] = iter_36_1
		end
	end

	return var_36_1
end

function LevelEndViewBase._get_win_track_rewards(arg_37_0)
	local var_37_0 = arg_37_0.context.rewards.end_of_level_rewards
	local var_37_1 = {
		start_experience = arg_37_0.context.rewards.win_track_start_experience,
		item_rewards = {}
	}

	for iter_37_0, iter_37_1 in pairs(var_37_0) do
		if string.find(iter_37_0, "win_track_reward") == 1 then
			local var_37_2 = string.split_deprecated(iter_37_0, ";")
			local var_37_3 = tonumber(var_37_2[2])

			var_37_1.item_rewards[var_37_3] = iter_37_1
		end
	end

	return var_37_1
end

function LevelEndViewBase._get_deed_rewards(arg_38_0)
	local var_38_0 = arg_38_0.context.rewards.end_of_level_rewards
	local var_38_1 = {}

	for iter_38_0, iter_38_1 in pairs(var_38_0) do
		if string.find(iter_38_0, "deed_reward") == 1 then
			var_38_1[#var_38_1 + 1] = iter_38_1
		end
	end

	return var_38_1
end

function LevelEndViewBase._get_event_rewards(arg_39_0)
	local var_39_0 = arg_39_0.context.rewards.end_of_level_rewards
	local var_39_1 = {}

	for iter_39_0, iter_39_1 in pairs(var_39_0) do
		if string.find(iter_39_0, "event_reward") then
			var_39_1[#var_39_1 + 1] = iter_39_1
		end
	end

	return var_39_1
end

function LevelEndViewBase._get_deus_rewards(arg_40_0)
	local var_40_0 = arg_40_0.context.rewards.end_of_level_rewards
	local var_40_1 = {}

	for iter_40_0, iter_40_1 in pairs(var_40_0) do
		if string.find(iter_40_0, "deus_reward") == 1 then
			var_40_1[#var_40_1 + 1] = iter_40_1
		end
	end

	return var_40_1
end

function LevelEndViewBase._get_keep_decoration_rewards(arg_41_0)
	local var_41_0 = arg_41_0.context.rewards.end_of_level_rewards
	local var_41_1 = {}

	for iter_41_0, iter_41_1 in pairs(var_41_0) do
		if string.find(iter_41_0, "keep_decoration_painting") == 1 then
			var_41_1[#var_41_1 + 1] = iter_41_1
		end
	end

	return var_41_1
end

function LevelEndViewBase._present_reward(arg_42_0, arg_42_1)
	local var_42_0 = arg_42_0.reward_popup

	if arg_42_0:displaying_reward_presentation() then
		local var_42_1 = arg_42_0._reward_presentation_queue

		var_42_1[#var_42_1 + 1] = arg_42_1
	else
		var_42_0:display_presentation(arg_42_1)
	end
end

function LevelEndViewBase._handle_queued_presentations(arg_43_0)
	if arg_43_0:_is_reward_presentation_complete() or #arg_43_0._reward_presentation_queue == 0 and not arg_43_0:displaying_reward_presentation() then
		local var_43_0 = arg_43_0._reward_presentation_queue

		if #var_43_0 > 0 then
			local var_43_1 = table.remove(var_43_0, 1)

			arg_43_0:_present_reward(var_43_1)
		else
			arg_43_0._reward_presentation_done = true
		end
	end
end

function LevelEndViewBase.displaying_reward_presentation(arg_44_0)
	return arg_44_0.reward_popup:is_presentation_active()
end

function LevelEndViewBase._is_reward_presentation_complete(arg_45_0)
	return arg_45_0.reward_popup:is_presentation_complete()
end

function LevelEndViewBase.reward_presentation_done(arg_46_0)
	return arg_46_0._reward_presentation_done
end

function LevelEndViewBase.present_level_up(arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = ProgressionUnlocks.get_level_unlocks(arg_47_2, arg_47_1)
	local var_47_1 = arg_47_0.level_up_rewards[arg_47_2]
	local var_47_2 = var_47_0 and #var_47_0 > 0
	local var_47_3 = var_47_1 and #var_47_1 > 0
	local var_47_4

	if var_47_3 or var_47_2 then
		var_47_4 = {}
	end

	if var_47_2 then
		for iter_47_0, iter_47_1 in ipairs(var_47_0) do
			local var_47_5 = {}
			local var_47_6 = iter_47_1.title
			local var_47_7 = iter_47_1.description

			if var_47_6 and var_47_7 then
				var_47_5[#var_47_5 + 1] = {
					widget_type = "description",
					value = {
						Localize(var_47_6),
						Localize(var_47_7)
					}
				}
			elseif var_47_6 then
				var_47_5[#var_47_5 + 1] = {
					widget_type = "title",
					value = Localize(var_47_6)
				}
			elseif var_47_7 then
				var_47_5[#var_47_5 + 1] = {
					widget_type = "title",
					value = Localize(var_47_7)
				}
			end

			var_47_5[#var_47_5 + 1] = {
				value = iter_47_1.value,
				widget_type = iter_47_1.unlock_type
			}
			var_47_4[#var_47_4 + 1] = var_47_5
		end
	end

	if var_47_3 then
		local var_47_8 = Managers.backend:get_interface("items")

		for iter_47_2, iter_47_3 in ipairs(var_47_1) do
			local var_47_9 = {}
			local var_47_10 = iter_47_3.backend_id
			local var_47_11 = var_47_8:get_item_from_id(var_47_10)
			local var_47_12 = var_47_8:get_item_masterlist_data(var_47_10).item_type
			local var_47_13 = {}
			local var_47_14, var_47_15, var_47_16 = UIUtils.get_ui_information_from_item(var_47_11)

			if var_47_12 == "loot_chest" then
				var_47_13[1] = Localize(var_47_15)
				var_47_13[2] = Localize("end_screen_chest_received")
			else
				var_47_13[1] = Localize(var_47_12)
				var_47_13[2] = Localize("reward_weapon")
			end

			if var_47_13 then
				var_47_9[#var_47_9 + 1] = {
					widget_type = "description",
					value = var_47_13
				}
			end

			var_47_9[#var_47_9 + 1] = {
				widget_type = "item",
				value = iter_47_3
			}
			var_47_4[#var_47_4 + 1] = var_47_9
		end
	end

	if var_47_4 then
		arg_47_0:_present_reward(var_47_4)
	end
end

function LevelEndViewBase.present_win_track_reward(arg_48_0, arg_48_1)
	local var_48_0 = Managers.backend:get_interface("items")
	local var_48_1 = arg_48_0.win_track_rewards.item_rewards[arg_48_1]
	local var_48_2 = {}
	local var_48_3 = {}
	local var_48_4 = var_48_1.backend_id
	local var_48_5 = var_48_0:get_item_from_id(var_48_4)
	local var_48_6 = var_48_0:get_item_masterlist_data(var_48_4).item_type
	local var_48_7 = {}
	local var_48_8, var_48_9, var_48_10 = UIUtils.get_ui_information_from_item(var_48_5)

	var_48_7[1] = Localize(var_48_6)
	var_48_7[2] = Localize(var_48_9)

	if var_48_7 then
		var_48_3[#var_48_3 + 1] = {
			widget_type = "description",
			value = var_48_7
		}
	end

	var_48_3[#var_48_3 + 1] = {
		widget_type = "item",
		value = var_48_1
	}
	var_48_2[#var_48_2 + 1] = var_48_3

	arg_48_0:_present_reward(var_48_2)
end

function LevelEndViewBase.present_additional_rewards(arg_49_0)
	local var_49_0 = arg_49_0.deed_rewards
	local var_49_1 = #var_49_0
	local var_49_2 = Managers.backend:get_interface("items")

	if var_49_1 > 0 then
		local var_49_3 = {
			{
				{
					widget_type = "title",
					value = Localize("deed_completed_title")
				}
			}
		}

		for iter_49_0, iter_49_1 in ipairs(var_49_0) do
			local var_49_4 = {}
			local var_49_5 = iter_49_1.backend_id
			local var_49_6 = var_49_2:get_item_from_id(var_49_5)
			local var_49_7 = var_49_2:get_item_masterlist_data(var_49_5).item_type
			local var_49_8 = {}
			local var_49_9, var_49_10, var_49_11 = UIUtils.get_ui_information_from_item(var_49_6)

			if var_49_7 == "loot_chest" then
				var_49_8[1] = Localize(var_49_10)
				var_49_8[2] = Localize("end_screen_chest_received")
			else
				var_49_8[1] = Localize(var_49_7)
				var_49_8[2] = Localize("reward_weapon")
			end

			if var_49_8 then
				var_49_4[#var_49_4 + 1] = {
					widget_type = "description",
					value = var_49_8
				}
			end

			var_49_4[#var_49_4 + 1] = {
				widget_type = "item",
				value = iter_49_1
			}
			var_49_3[#var_49_3 + 1] = var_49_4
		end

		arg_49_0:_present_reward(var_49_3)
	end

	local var_49_12 = arg_49_0.keep_decoration_rewards

	if #var_49_12 > 0 then
		local var_49_13 = {}

		for iter_49_2, iter_49_3 in ipairs(var_49_12) do
			local var_49_14 = iter_49_3.keep_decoration_name
			local var_49_15 = Paintings[var_49_14]
			local var_49_16 = var_49_15.display_name
			local var_49_17 = var_49_15.icon
			local var_49_18 = {
				Localize(var_49_16),
				Localize("end_screen_you_received")
			}
			local var_49_19 = {
				{
					widget_type = "description",
					value = var_49_18
				},
				{
					widget_type = "icon",
					value = var_49_17
				}
			}

			var_49_13[#var_49_13 + 1] = var_49_19
		end

		arg_49_0:_present_reward(var_49_13)
	end

	local var_49_20 = arg_49_0.event_rewards

	if #var_49_20 > 0 then
		local var_49_21 = {}

		for iter_49_4, iter_49_5 in ipairs(var_49_20) do
			local var_49_22 = {}
			local var_49_23 = iter_49_5.backend_id
			local var_49_24 = var_49_2:get_item_from_id(var_49_23)
			local var_49_25 = {}
			local var_49_26, var_49_27, var_49_28 = UIUtils.get_ui_information_from_item(var_49_24)

			var_49_25[1] = Localize(var_49_27)
			var_49_25[2] = Localize("end_screen_you_received")

			if var_49_25 then
				var_49_22[#var_49_22 + 1] = {
					widget_type = "description",
					value = var_49_25
				}
			end

			var_49_22[#var_49_22 + 1] = {
				widget_type = "item",
				value = iter_49_5
			}
			var_49_21[#var_49_21 + 1] = var_49_22
		end

		arg_49_0:_present_reward(var_49_21)
	end

	local var_49_29 = arg_49_0.deus_rewards

	if #var_49_29 > 0 then
		local var_49_30 = {
			{
				{
					widget_type = "title",
					value = Localize("deus_expedition_completed_title")
				}
			}
		}

		for iter_49_6, iter_49_7 in ipairs(var_49_29) do
			local var_49_31 = {}
			local var_49_32 = iter_49_7.backend_id
			local var_49_33 = var_49_2:get_item_from_id(var_49_32)
			local var_49_34 = {}
			local var_49_35, var_49_36, var_49_37 = UIUtils.get_ui_information_from_item(var_49_33)

			var_49_34[1] = Localize(var_49_36)
			var_49_34[2] = Localize("end_screen_you_received")

			if var_49_34 then
				var_49_31[#var_49_31 + 1] = {
					widget_type = "description",
					value = var_49_34
				}
			end

			var_49_31[#var_49_31 + 1] = {
				widget_type = "item",
				value = iter_49_7
			}
			var_49_30[#var_49_30 + 1] = var_49_31
		end

		arg_49_0:_present_reward(var_49_30)
	end
end

function LevelEndViewBase.present_chest_rewards(arg_50_0)
	local var_50_0 = arg_50_0.context.rewards.end_of_level_rewards
	local var_50_1 = Managers.backend:get_interface("items")
	local var_50_2 = var_50_0.chest

	if var_50_2 then
		local var_50_3 = var_50_2.backend_id
		local var_50_4 = var_50_1:get_item_from_id(var_50_3)
		local var_50_5 = var_50_1:get_item_masterlist_data(var_50_3)
		local var_50_6, var_50_7, var_50_8 = UIUtils.get_ui_information_from_item(var_50_4)
		local var_50_9 = var_50_5.name
		local var_50_10 = {
			{
				{
					widget_type = "description",
					value = {
						Localize(var_50_7),
						Localize("end_screen_chest_received")
					}
				},
				{
					widget_type = "loot_chest",
					value = var_50_9
				}
			}
		}

		arg_50_0:_present_reward(var_50_10)
	end
end

function LevelEndViewBase.wanted_menu_state(arg_51_0)
	return arg_51_0._wanted_menu_state
end

function LevelEndViewBase.clear_wanted_menu_state(arg_52_0)
	arg_52_0._wanted_menu_state = nil
end

function LevelEndViewBase._request_state_change(arg_53_0, arg_53_1)
	local var_53_0 = arg_53_0._machine

	if not var_53_0 then
		return
	end

	local var_53_1 = var_53_0:state()
	local var_53_2 = var_53_1.NAME
	local var_53_3
	local var_53_4 = arg_53_0._index_by_state_name[arg_53_1] > arg_53_0._index_by_state_name[var_53_2] and "left" or "right"

	var_53_1:exit(var_53_4)

	arg_53_0._new_state_name = arg_53_1
end

function LevelEndViewBase._handle_state_exit(arg_54_0)
	local var_54_0 = arg_54_0._machine

	if not var_54_0 then
		return
	end

	if var_54_0:state():exit_done() then
		arg_54_0:_setup_state_machine(arg_54_0._new_state_name)

		arg_54_0._new_state_name = nil
		arg_54_0._state_speed_mult = 1
	end
end

function LevelEndViewBase._setup_state_machine(arg_55_0, arg_55_1, arg_55_2)
	if arg_55_0._machine then
		arg_55_0._machine:destroy()

		arg_55_0._machine = nil
	end

	local var_55_0 = arg_55_1 or "EndViewStateSummary"
	local var_55_1 = arg_55_0._index_by_state_name[var_55_0]
	local var_55_2 = rawget(_G, var_55_0)
	local var_55_3 = false
	local var_55_4 = arg_55_0._state_machine_params

	var_55_4.initial_state = arg_55_2
	arg_55_0._state_can_speed_up = var_55_2.CAN_SPEED_UP

	local var_55_5

	if not arg_55_2 then
		local var_55_6 = arg_55_0._current_state_name

		var_55_5 = var_55_1 > arg_55_0._index_by_state_name[var_55_6] and "left" or "right"
	end

	var_55_4.direction = var_55_5
	arg_55_0._current_state_name = var_55_0
	arg_55_0._machine = StateMachine:new(arg_55_0, var_55_2, var_55_4, var_55_3)

	arg_55_0:_show_object_set(var_55_0)
end

function LevelEndViewBase._handle_state_auto_change(arg_56_0)
	local var_56_0 = arg_56_0._machine

	if not var_56_0 then
		return
	end

	local var_56_1 = var_56_0:state()
	local var_56_2 = var_56_1.NAME
	local var_56_3 = arg_56_0._state_name_by_index
	local var_56_4 = arg_56_0._index_by_state_name[var_56_2]
	local var_56_5 = #var_56_3

	if arg_56_0._next_auto_state_index then
		if var_56_1:exit_done() then
			if var_56_5 < arg_56_0._next_auto_state_index then
				if not arg_56_0._started_exit then
					arg_56_0:exit_to_game()
				end
			else
				arg_56_0:_proceed_to_next_auto_state(arg_56_0._next_auto_state_index, var_56_5)
			end
		end
	else
		local var_56_6

		if not arg_56_0:displaying_reward_presentation() then
			if var_56_1:done() then
				var_56_6 = var_56_4 + 1
			end

			if var_56_6 then
				var_56_1:exit()

				arg_56_0._next_auto_state_index = var_56_6
			end
		end
	end
end

function LevelEndViewBase._proceed_to_next_auto_state(arg_57_0, arg_57_1, arg_57_2)
	local var_57_0 = arg_57_0._state_name_by_index[arg_57_1]

	arg_57_0:_setup_state_machine(var_57_0, true)

	if arg_57_1 == arg_57_2 then
		arg_57_0:_push_mouse_cursor()

		arg_57_0._state_machine_complete = true
	end

	arg_57_0._next_auto_state_index = nil
end

function LevelEndViewBase.rpc_signal_end_of_level_done(arg_58_0, arg_58_1, arg_58_2, arg_58_3)
	if arg_58_0.is_server then
		local var_58_0 = arg_58_0._lobby:members():get_members()
		local var_58_1 = Network.peer_id()

		for iter_58_0, iter_58_1 in ipairs(var_58_0) do
			if iter_58_1 ~= arg_58_2 and iter_58_1 ~= var_58_1 then
				local var_58_2 = PEER_ID_TO_CHANNEL[iter_58_1]

				if var_58_2 then
					RPC.rpc_signal_end_of_level_done(var_58_2, arg_58_2, arg_58_3)
				end
			end
		end
	end

	arg_58_0:peer_signaled_done(arg_58_2, arg_58_3)
end

function LevelEndViewBase.signal_done(arg_59_0, arg_59_1)
	if arg_59_0._signaled_done then
		return
	end

	if not arg_59_0._left_lobby then
		if arg_59_0.is_server then
			local var_59_0 = arg_59_0._lobby:members()

			if var_59_0 then
				local var_59_1 = var_59_0:get_members()
				local var_59_2 = Network.peer_id()

				for iter_59_0, iter_59_1 in ipairs(var_59_1) do
					if iter_59_1 ~= var_59_2 then
						local var_59_3 = PEER_ID_TO_CHANNEL[iter_59_1]

						if var_59_3 then
							RPC.rpc_signal_end_of_level_done(var_59_3, var_59_2, arg_59_1)
						end
					end
				end
			end
		else
			local var_59_4 = arg_59_0._lobby:lobby_host()
			local var_59_5 = Network.peer_id()
			local var_59_6 = PEER_ID_TO_CHANNEL[var_59_4]

			if var_59_6 then
				RPC.rpc_signal_end_of_level_done(var_59_6, var_59_5, arg_59_1)
			end
		end
	end

	arg_59_0:peer_signaled_done(Network.peer_id(), arg_59_1)
end

function LevelEndViewBase.peer_signaled_done(arg_60_0, arg_60_1, arg_60_2)
	if not arg_60_0._started_force_shutdown then
		arg_60_0:start_force_shutdown()
	end

	arg_60_0._done_peers[arg_60_1] = true
	arg_60_0._wants_reload[arg_60_1] = arg_60_2
end

function LevelEndViewBase.rpc_notify_lobby_joined(arg_61_0, arg_61_1)
	if arg_61_0.is_server then
		local var_61_0 = false
		local var_61_1 = arg_61_0._lobby:members():get_members()
		local var_61_2 = Network.peer_id()
		local var_61_3 = CHANNEL_TO_PEER_ID[arg_61_1]

		for iter_61_0, iter_61_1 in ipairs(var_61_1) do
			if iter_61_1 ~= var_61_3 and iter_61_1 ~= var_61_2 then
				local var_61_4 = PEER_ID_TO_CHANNEL[iter_61_1]

				RPC.rpc_signal_end_of_level_done(var_61_4, var_61_3, var_61_0)
			end
		end

		arg_61_0:peer_signaled_done(var_61_3, var_61_0)
	end
end

function LevelEndViewBase.start_force_shutdown(arg_62_0)
	arg_62_0._started_force_shutdown = true
	arg_62_0._force_shutdown_timer = 45
	arg_62_0._force_shutdown_timer_start = arg_62_0._force_shutdown_timer
end

function LevelEndViewBase.get_force_shutdown_time(arg_63_0)
	return arg_63_0._force_shutdown_timer, arg_63_0._force_shutdown_timer_start
end

function LevelEndViewBase.is_force_shutdown_active(arg_64_0)
	return arg_64_0._started_force_shutdown
end

function LevelEndViewBase.update_force_shutdown(arg_65_0, arg_65_1)
	arg_65_0._force_shutdown_timer = math.max(0, arg_65_0._force_shutdown_timer - arg_65_1)

	if arg_65_0._force_shutdown_timer == 0 and not arg_65_0._signaled_done then
		arg_65_0:signal_done(false)

		arg_65_0._signaled_done = true
	elseif not arg_65_0._left_lobby then
		local var_65_0 = true

		if arg_65_0._lobby:members() then
			local var_65_1 = arg_65_0._lobby:members():get_members()

			for iter_65_0, iter_65_1 in ipairs(var_65_1) do
				if not arg_65_0._done_peers[iter_65_1] then
					var_65_0 = false

					break
				end
			end
		end

		if var_65_0 then
			arg_65_0:exit_to_game()
		end
	end

	if arg_65_0._started_exit then
		arg_65_0._started_force_shutdown = false
	end
end

local var_0_5 = {
	persistance = 1,
	fade_out = 0.5,
	amplitude = 0.9,
	seed = 0,
	duration = 0.5,
	fade_in = 0.1,
	octaves = 7
}

function LevelEndViewBase.setup_camera(arg_66_0)
	local var_66_0
	local var_66_1
	local var_66_2 = "levels/end_screen/world"
	local var_66_3 = LevelResource.unit_indices(var_66_2, "units/hub_elements/cutscene_camera/cutscene_camera")

	for iter_66_0, iter_66_1 in pairs(var_66_3) do
		local var_66_4 = LevelResource.unit_data(var_66_2, iter_66_1)
		local var_66_5 = DynamicData.get(var_66_4, "name")

		if var_66_5 and var_66_5 == "end_screen_camera" then
			local var_66_6 = LevelResource.unit_position(var_66_2, iter_66_1)
			local var_66_7 = LevelResource.unit_rotation(var_66_2, iter_66_1)
			local var_66_8 = Matrix4x4.from_quaternion_position(var_66_7, var_66_6)

			var_66_0 = Matrix4x4Box(var_66_8)
			var_66_1 = iter_66_1

			print("Found camera: " .. var_66_5)

			break
		end
	end

	arg_66_0._camera_pose = var_66_0
	arg_66_0._camera_index = var_66_1

	arg_66_0:position_camera()
end

function LevelEndViewBase.add_camera_shake(arg_67_0, arg_67_1, arg_67_2, arg_67_3)
	local var_67_0 = {}
	local var_67_1 = arg_67_0:get_camera_rotation()
	local var_67_2 = arg_67_1 or var_0_5
	local var_67_3 = var_67_2.duration
	local var_67_4 = var_67_2.fade_in
	local var_67_5 = var_67_2.fade_out
	local var_67_6 = (var_67_3 or 0) + (var_67_4 or 0) + (var_67_5 or 0)

	var_67_0.shake_settings = var_67_2
	var_67_0.start_time = arg_67_2
	var_67_0.end_time = var_67_6 and arg_67_2 + var_67_6
	var_67_0.fade_in_time = var_67_4 and arg_67_2 + var_67_4
	var_67_0.fade_out_time = var_67_5 and var_67_0.end_time - var_67_5
	var_67_0.seed = var_67_2.seed or Math.random(1, 100)
	var_67_0.scale = arg_67_3 or 1
	var_67_0.camera_rotation_boxed = QuaternionBox(var_67_1)
	arg_67_0._active_camera_shakes = {
		[var_67_0] = true
	}
end

function LevelEndViewBase._apply_shake_event(arg_68_0, arg_68_1, arg_68_2)
	local var_68_0 = arg_68_0._active_camera_shakes
	local var_68_1 = arg_68_1.start_time
	local var_68_2 = arg_68_1.end_time
	local var_68_3 = arg_68_1.fade_in_time
	local var_68_4 = arg_68_1.fade_out_time

	if var_68_3 and arg_68_2 <= var_68_3 then
		arg_68_1.fade_progress = math.clamp((arg_68_2 - var_68_1) / (var_68_3 - var_68_1), 0, 1)
	elseif var_68_4 and var_68_4 <= arg_68_2 then
		arg_68_1.fade_progress = math.clamp((var_68_2 - arg_68_2) / (var_68_2 - var_68_4), 0, 1)
	end

	local var_68_5 = arg_68_0:_calculate_perlin_value(arg_68_2 - arg_68_1.start_time, arg_68_1) * arg_68_1.scale
	local var_68_6 = arg_68_0:_calculate_perlin_value(arg_68_2 - arg_68_1.start_time + 10, arg_68_1) * arg_68_1.scale
	local var_68_7 = arg_68_1.camera_rotation_boxed:unbox()
	local var_68_8 = math.pi / 180
	local var_68_9 = Quaternion(Vector3.up(), var_68_6 * var_68_8)
	local var_68_10 = Quaternion(Vector3.right(), var_68_5 * var_68_8)
	local var_68_11 = Quaternion.multiply(var_68_9, var_68_10)
	local var_68_12 = Quaternion.multiply(var_68_7, var_68_11)

	arg_68_0:set_camera_rotation(var_68_12)

	if arg_68_1.end_time and arg_68_2 >= arg_68_1.end_time then
		var_68_0[arg_68_1] = nil
	end
end

function LevelEndViewBase._calculate_perlin_value(arg_69_0, arg_69_1, arg_69_2)
	local var_69_0 = 0
	local var_69_1 = arg_69_2.shake_settings
	local var_69_2 = var_69_1.persistance
	local var_69_3 = var_69_1.octaves

	for iter_69_0 = 0, var_69_3 do
		local var_69_4 = 2^iter_69_0
		local var_69_5 = var_69_2^iter_69_0

		var_69_0 = var_69_0 + arg_69_0:_interpolated_noise(arg_69_1 * var_69_4, arg_69_2) * var_69_5
	end

	local var_69_6 = var_69_1.amplitude or 1
	local var_69_7 = arg_69_2.fade_progress or 1

	return var_69_0 * var_69_6 * var_69_7
end

function LevelEndViewBase._interpolated_noise(arg_70_0, arg_70_1, arg_70_2)
	local var_70_0 = math.floor(arg_70_1)
	local var_70_1 = arg_70_1 - var_70_0
	local var_70_2 = arg_70_0:_smoothed_noise(var_70_0, arg_70_2)
	local var_70_3 = arg_70_0:_smoothed_noise(var_70_0 + 1, arg_70_2)

	return math.lerp(var_70_2, var_70_3, var_70_1)
end

function LevelEndViewBase._smoothed_noise(arg_71_0, arg_71_1, arg_71_2)
	return arg_71_0:_noise(arg_71_1, arg_71_2) / 2 + arg_71_0:_noise(arg_71_1 - 1, arg_71_2) / 4 + arg_71_0:_noise(arg_71_1 + 1, arg_71_2) / 4
end

function LevelEndViewBase._noise(arg_72_0, arg_72_1, arg_72_2)
	local var_72_0, var_72_1 = Math.next_random(arg_72_1 + arg_72_2.seed)
	local var_72_2, var_72_3 = Math.next_random(var_72_0)

	return var_72_3 * 2 - 1
end

function LevelEndViewBase.set_camera_position(arg_73_0, arg_73_1)
	local var_73_0, var_73_1 = arg_73_0:get_viewport_world()
	local var_73_2 = ScriptViewport.camera(var_73_1)

	return ScriptCamera.set_local_position(var_73_2, arg_73_1)
end

function LevelEndViewBase.set_camera_rotation(arg_74_0, arg_74_1)
	local var_74_0, var_74_1 = arg_74_0:get_viewport_world()
	local var_74_2 = ScriptViewport.camera(var_74_1)

	return ScriptCamera.set_local_rotation(var_74_2, arg_74_1)
end

function LevelEndViewBase.get_camera_position(arg_75_0)
	local var_75_0, var_75_1 = arg_75_0:get_viewport_world()
	local var_75_2 = ScriptViewport.camera(var_75_1)

	return ScriptCamera.position(var_75_2)
end

function LevelEndViewBase.get_camera_rotation(arg_76_0)
	local var_76_0, var_76_1 = arg_76_0:get_viewport_world()
	local var_76_2 = ScriptViewport.camera(var_76_1)

	return ScriptCamera.rotation(var_76_2)
end

function LevelEndViewBase.position_camera(arg_77_0, arg_77_1, arg_77_2)
	local var_77_0, var_77_1 = arg_77_0:get_viewport_world()
	local var_77_2 = ScriptViewport.camera(var_77_1)
	local var_77_3 = arg_77_1 or arg_77_0._camera_pose:unbox()

	if var_77_3 then
		local var_77_4 = arg_77_2 or 65

		Camera.set_vertical_fov(var_77_2, math.degrees_to_radians(var_77_4))
		ScriptCamera.set_local_pose(var_77_2, var_77_3)
		ScriptCamera.force_update(var_77_0, var_77_2)
	end
end

function LevelEndViewBase.set_camera_zoom(arg_78_0, arg_78_1)
	local var_78_0 = arg_78_0._camera_pose:unbox()
	local var_78_1 = Matrix4x4.translation(var_78_0)
	local var_78_2 = Matrix4x4.rotation(var_78_0)
	local var_78_3 = 0.5 * arg_78_1
	local var_78_4 = var_78_1 + Quaternion.forward(var_78_2) * var_78_3

	arg_78_0:set_camera_position(var_78_4)
end

function LevelEndViewBase._setup_viewport_camera(arg_79_0)
	local var_79_0, var_79_1 = arg_79_0:get_viewport_world()
	local var_79_2 = World.unit_by_name(var_79_0, "camera")
	local var_79_3 = Unit.world_rotation(var_79_2, 0)
	local var_79_4 = Unit.world_position(var_79_2, 0) - Quaternion.forward(var_79_3) * 3
	local var_79_5 = ScriptViewport.camera(var_79_1)

	ScriptCamera.set_local_rotation(var_79_5, var_79_3)
	ScriptCamera.set_local_position(var_79_5, var_79_4)
end

function LevelEndViewBase._push_mouse_cursor(arg_80_0)
	if not arg_80_0._cursor_visible then
		ShowCursorStack.show("LevelEndViewBase")

		arg_80_0._cursor_visible = true
	end
end

function LevelEndViewBase._pop_mouse_cursor(arg_81_0)
	if arg_81_0._cursor_visible then
		ShowCursorStack.hide("LevelEndViewBase")

		arg_81_0._cursor_visible = nil
	end
end

function LevelEndViewBase.set_input_manager(arg_82_0, arg_82_1)
	arg_82_0.input_manager = arg_82_1

	if arg_82_0.reward_popup then
		arg_82_0.reward_popup:set_input_manager(arg_82_1)
	end

	arg_82_0._machine:state():set_input_manager(arg_82_1)
end

function LevelEndViewBase.input_service(arg_83_0)
	return (arg_83_0:displaying_reward_presentation() or not table.is_empty(arg_83_0._transition_animations)) and FAKE_INPUT_SERVICE or arg_83_0.input_manager:get_service("end_of_level")
end

function LevelEndViewBase.menu_input_service(arg_84_0)
	return arg_84_0.input_blocked and FAKE_INPUT_SERVICE or arg_84_0:input_service()
end

function LevelEndViewBase.set_input_blocked(arg_85_0, arg_85_1)
	arg_85_0.input_blocked = arg_85_1
end

function LevelEndViewBase.input_enabled(arg_86_0)
	return true
end

function LevelEndViewBase.setup_world(arg_87_0, arg_87_1)
	local var_87_0, var_87_1 = arg_87_0:create_world(arg_87_1)
	local var_87_2 = arg_87_0:spawn_level(arg_87_1, var_87_0)
	local var_87_3 = arg_87_0:create_viewport(arg_87_1, var_87_0)
	local var_87_4, var_87_5 = arg_87_0:create_ui_renderer(arg_87_1, var_87_0, var_87_1)
	local var_87_6 = Managers.world:wwise_world(var_87_0)

	arg_87_0._world = var_87_0
	arg_87_0._level = var_87_2
	arg_87_0._top_world = var_87_1
	arg_87_0._world_viewport = var_87_3
	arg_87_0.ui_renderer = var_87_4
	arg_87_0.ui_top_renderer = var_87_5
	arg_87_0.wwise_world = var_87_6
	arg_87_1.world = var_87_0
	arg_87_1.top_world = var_87_1
	arg_87_1.world_viewport = var_87_3
	arg_87_1.ui_renderer = var_87_4
	arg_87_1.ui_top_renderer = var_87_5
	arg_87_1.wwise_world = var_87_6
end

function LevelEndViewBase.destroy_world(arg_88_0)
	UIRenderer.destroy(arg_88_0.ui_renderer, arg_88_0._world)

	arg_88_0.ui_renderer = nil

	UIRenderer.destroy(arg_88_0.ui_top_renderer, arg_88_0._top_world)

	arg_88_0.ui_top_renderer = nil

	Managers.world:destroy_world(arg_88_0._world)

	arg_88_0._world = nil
	arg_88_0._top_world = nil
end

function LevelEndViewBase.get_world_flags(arg_89_0)
	local var_89_0 = {
		Application.DISABLE_SOUND,
		Application.DISABLE_ESRAM,
		Application.ENABLE_VOLUMETRICS
	}

	if Application.user_setting("disable_apex_cloth") then
		table.insert(var_89_0, Application.DISABLE_APEX_CLOTH)
	else
		table.insert(var_89_0, Application.APEX_LOD_RESOURCE_BUDGET)
		table.insert(var_89_0, Application.user_setting("apex_lod_resource_budget") or ApexClothQuality.high.apex_lod_resource_budget)
	end

	return var_89_0
end

function LevelEndViewBase.create_world(arg_90_0, arg_90_1)
	local var_90_0 = "end_screen"
	local var_90_1 = "environment/ui_end_screen"
	local var_90_2 = 2
	local var_90_3 = arg_90_0:get_world_flags()
	local var_90_4 = Managers.world:create_world(var_90_0, var_90_1, nil, var_90_2, unpack(var_90_3))
	local var_90_5 = Managers.world:world("top_ingame_view")

	return var_90_4, var_90_5
end

function LevelEndViewBase.create_viewport(arg_91_0, arg_91_1, arg_91_2)
	local var_91_0 = "end_screen_viewport"
	local var_91_1 = "default"
	local var_91_2 = 2

	return (ScriptWorld.create_viewport(arg_91_2, var_91_0, var_91_1, var_91_2))
end

function LevelEndViewBase.spawn_level(arg_92_0, arg_92_1, arg_92_2)
	local var_92_0 = "levels/end_screen/world"
	local var_92_1 = {}
	local var_92_2
	local var_92_3
	local var_92_4
	local var_92_5
	local var_92_6 = false
	local var_92_7 = ScriptWorld.spawn_level(arg_92_2, var_92_0, var_92_1, var_92_2, var_92_3, var_92_4, var_92_5, var_92_6)

	Level.spawn_background(var_92_7)
	Level.trigger_level_loaded(var_92_7)
	arg_92_0:_register_object_sets(var_92_7, var_92_0)

	return var_92_7
end

function LevelEndViewBase._register_object_sets(arg_93_0, arg_93_1, arg_93_2)
	local var_93_0 = {}
	local var_93_1 = LevelResource.object_set_names(arg_93_2)

	for iter_93_0, iter_93_1 in ipairs(var_93_1) do
		var_93_0[iter_93_1] = {
			set_enabled = true,
			units = LevelResource.unit_indices_in_object_set(arg_93_2, iter_93_1)
		}
	end

	arg_93_0._object_sets = var_93_0

	arg_93_0:_show_object_set(nil, arg_93_1)
end

function LevelEndViewBase._show_object_set(arg_94_0, arg_94_1, arg_94_2)
	local var_94_0 = arg_94_2 or arg_94_0._level
	local var_94_1 = arg_94_0._object_sets
	local var_94_2 = false

	for iter_94_0, iter_94_1 in pairs(var_94_1) do
		local var_94_3 = iter_94_1.set_enabled

		if var_94_3 and iter_94_0 ~= arg_94_1 then
			local var_94_4 = iter_94_1.units

			for iter_94_2, iter_94_3 in ipairs(var_94_4) do
				local var_94_5 = Level.unit_by_index(var_94_0, iter_94_3)

				if Unit.alive(var_94_5) then
					Unit.set_unit_visibility(var_94_5, false)
				end
			end

			iter_94_1.set_enabled = false
		elseif iter_94_0 == arg_94_1 and not var_94_3 then
			local var_94_6 = iter_94_1.units

			for iter_94_4, iter_94_5 in ipairs(var_94_6) do
				local var_94_7 = Level.unit_by_index(var_94_0, iter_94_5)

				Unit.set_unit_visibility(var_94_7, true)

				if Unit.has_data(var_94_7, "LevelEditor", "is_gizmo_unit") then
					local var_94_8 = Unit.get_data(var_94_7, "LevelEditor", "is_gizmo_unit")
					local var_94_9 = Unit.is_a(var_94_7, "core/stingray_renderer/helper_units/reflection_probe/reflection_probe")

					if var_94_8 and not var_94_9 then
						Unit.flow_event(var_94_7, "hide_helper_mesh")
						Unit.flow_event(var_94_7, "unit_object_set_enabled")
					end
				end
			end

			iter_94_1.set_enabled = true
		end

		var_94_2 = iter_94_0 == arg_94_1 or var_94_2
	end

	if var_94_2 then
		print("Showing object set:", arg_94_1)
	elseif arg_94_1 then
		print(string.format("Trying to show object set %q - But it didn't exist", arg_94_1))
	end
end

function LevelEndViewBase.create_ui_renderer(arg_95_0, arg_95_1, arg_95_2, arg_95_3)
	local var_95_0 = {
		"material",
		"materials/ui/ui_1080p_hud_atlas_textures",
		"material",
		"materials/ui/ui_1080p_hud_single_textures",
		"material",
		"materials/ui/ui_1080p_menu_atlas_textures",
		"material",
		"materials/ui/ui_1080p_menu_single_textures",
		"material",
		"materials/ui/ui_1080p_common",
		"material",
		"materials/ui/ui_1080p_versus_available_common",
		"material",
		"materials/ui/ui_1080p_versus_rewards_atlas",
		"material",
		"materials/fonts/gw_fonts"
	}
	local var_95_1 = arg_95_0.get_extra_materials

	if var_95_1 then
		for iter_95_0, iter_95_1 in ipairs(var_95_1) do
			var_95_0[#var_95_0 + 1] = iter_95_1
		end
	end

	for iter_95_2, iter_95_3 in ipairs(var_0_1) do
		var_95_0[#var_95_0 + 1] = "material"
		var_95_0[#var_95_0 + 1] = iter_95_3
	end

	local var_95_2 = UIRenderer.create(arg_95_2, unpack(var_95_0))
	local var_95_3 = UIRenderer.create(arg_95_3, unpack(var_95_0))

	return var_95_2, var_95_3
end

function LevelEndViewBase.show_team(arg_96_0)
	return
end

function LevelEndViewBase.hide_team(arg_97_0)
	return
end
