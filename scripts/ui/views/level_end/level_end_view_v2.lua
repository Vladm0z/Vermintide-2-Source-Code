-- chunkname: @scripts/ui/views/level_end/level_end_view_v2.lua

require("scripts/ui/views/level_end/level_end_view_base")
require("scripts/ui/views/level_end/states/end_view_state_parading")
require("scripts/ui/views/level_end/states/end_view_state_summary")
require("scripts/ui/views/level_end/states/end_view_state_score")
require("scripts/ui/views/level_end/states/end_view_state_chest")
require("scripts/ui/reward_popup/reward_popup_ui")

local var_0_0 = local_require("scripts/ui/views/level_end/level_end_view_v2_definitions")
local var_0_1 = var_0_0.widgets_definitions
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animations
local var_0_4 = var_0_0.generic_input_actions
local var_0_5 = var_0_0.weave_widget_definitions
local var_0_6 = false
local var_0_7 = false
local var_0_8 = script_data.testify and require("scripts/ui/views/level_end/level_end_view_testify")
local var_0_9 = 0.07
local var_0_10 = 1.36
local var_0_11 = -1.5
local var_0_12 = 0.15
local var_0_13 = 0
local var_0_14 = {
	{
		{
			var_0_9,
			var_0_11,
			var_0_13
		}
	},
	{
		{
			var_0_9 + var_0_10 * 0.5,
			var_0_11 + var_0_12 * 0.5,
			var_0_13
		},
		{
			var_0_9 + var_0_10 * -0.5,
			var_0_11 + var_0_12 * -0.5,
			var_0_13
		}
	},
	{
		{
			var_0_9 + var_0_10 * 1,
			var_0_11 + var_0_12 * 1,
			var_0_13
		},
		{
			var_0_9 + var_0_10 * 0,
			var_0_11 + var_0_12 * 0,
			var_0_13
		},
		{
			var_0_9 + var_0_10 * -1,
			var_0_11 + var_0_12 * -1,
			var_0_13
		}
	},
	{
		{
			var_0_9 + var_0_10 * 1,
			var_0_11 + var_0_12 * 1.5,
			var_0_13
		},
		{
			var_0_9 + var_0_10 * 0.25,
			var_0_11 + var_0_12 * 0.25 + 0.5,
			var_0_13
		},
		{
			var_0_9 + var_0_10 * -0.25,
			var_0_11 + var_0_12 * -0.25 + 0.5,
			var_0_13
		},
		{
			var_0_9 + var_0_10 * -1,
			var_0_11 + var_0_12 * -1.5,
			var_0_13
		}
	}
}

LevelEndView = class(LevelEndView, LevelEndViewBase)

function LevelEndView.init(arg_1_0, arg_1_1)
	arg_1_0._weave_render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._team_heroes = {}
	arg_1_0._team_previewer = nil

	local var_1_0 = {}

	if arg_1_1.players_session_score then
		for iter_1_0 in pairs(arg_1_1.players_session_score) do
			var_1_0[iter_1_0] = true
		end
	end

	arg_1_0._peers_with_score = var_1_0

	LevelEndView.super.init(arg_1_0, arg_1_1)
	Managers.transition:force_fade_in()
end

function LevelEndView.start(arg_2_0)
	LevelEndView.super.start(arg_2_0)
	arg_2_0:play_sound("play_gui_chestroom_start")

	arg_2_0._playing_music = nil
	arg_2_0._start_music_event = arg_2_0.game_won and "Play_won_music" or "Play_lost_music"
	arg_2_0._stop_music_event = arg_2_0.game_won and "Stop_won_music" or "Stop_lost_music"
end

function LevelEndView.setup_pages(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0

	if arg_3_0._is_untrusted then
		var_3_0 = arg_3_0:_setup_pages_untrusted()
	elseif arg_3_1 then
		var_3_0 = arg_3_0:_setup_pages_victory(arg_3_2)
	else
		var_3_0 = arg_3_0:_setup_pages_defeat(arg_3_2)
	end

	return var_3_0
end

function LevelEndView._setup_pages_untrusted(arg_4_0)
	return {
		EndViewStateScore = 1
	}
end

function LevelEndView._setup_pages_victory(arg_5_0, arg_5_1)
	local var_5_0 = {}
	local var_5_1 = arg_5_1.end_of_level_rewards.chest

	var_5_0.EndViewStateParading = table.size(var_5_0) + 1
	var_5_0.EndViewStateSummary = table.size(var_5_0) + 1

	if var_5_1 then
		var_5_0.EndViewStateChest = table.size(var_5_0) + 1
	end

	var_5_0.EndViewStateScore = table.size(var_5_0) + 1

	return var_5_0
end

function LevelEndView.show_team(arg_6_0)
	if arg_6_0._team_previewer then
		arg_6_0:_destroy_team_previewer()
	end

	arg_6_0:_setup_team_heroes(arg_6_0.context.players_session_score)

	if arg_6_0.game_won then
		arg_6_0:_setup_team_previewer()
	end
end

function LevelEndView.hide_team(arg_7_0)
	if arg_7_0._team_previewer then
		arg_7_0:_destroy_team_previewer()
	end
end

function LevelEndView.loading_complete(arg_8_0)
	return arg_8_0._team_previewer and arg_8_0._team_previewer:loading_done()
end

function LevelEndView._setup_pages_defeat(arg_9_0)
	local var_9_0 = {}

	var_9_0.EndViewStateSummary = table.size(var_9_0) + 1
	var_9_0.EndViewStateScore = table.size(var_9_0) + 1

	return var_9_0
end

function LevelEndView.create_ui_elements(arg_10_0)
	arg_10_0.ui_animations = {}
	arg_10_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)
	arg_10_0._static_widgets = {}
	arg_10_0._dynamic_widgets = {
		timer_text = UIWidget.init(var_0_1.timer_text),
		timer_bg = UIWidget.init(var_0_1.timer_bg)
	}

	if var_0_7 then
		arg_10_0._page_selector_widget = UIWidget.init(UIWidgets.create_page_dot_selector("page_selector", #arg_10_0._state_name_by_index))
	end

	local var_10_0 = UIWidgets.create_default_button("retry_button", var_0_2.retry_button.size, nil, nil, Localize(arg_10_0.game_won and "button_replay" or "button_retry"), 32, nil, nil, nil, true)

	arg_10_0._retry_button_widget = UIWidget.init(var_10_0)
	arg_10_0._ready_button_widget = UIWidget.init(var_0_1.ready_button)
	arg_10_0._retry_checkboxes_widget = UIWidget.init(var_0_1.retry_checkboxes)
	arg_10_0._reload_checkboxes_widget = UIWidget.init(var_0_1.reload_checkboxes)
	arg_10_0._weave_widgets = {}

	for iter_10_0, iter_10_1 in pairs(var_0_5) do
		arg_10_0._weave_widgets[iter_10_0] = UIWidget.init(iter_10_1)
	end

	arg_10_0._dead_space_filler_mask = UIWidget.init(var_0_1.dead_space_filler_mask)
	arg_10_0._dead_space_filler_unmask = UIWidget.init(var_0_1.dead_space_filler_unmask)

	UIRenderer.clear_scenegraph_queue(arg_10_0.ui_renderer)

	arg_10_0.ui_animator = UIAnimator:new(arg_10_0.ui_scenegraph, var_0_3)

	local var_10_1 = arg_10_0.input_manager:get_service("end_of_level")

	arg_10_0._menu_input_description = MenuInputDescriptionUI:new(nil, arg_10_0.ui_renderer, var_10_1, 5, 10, var_0_4.default)

	arg_10_0._menu_input_description:set_input_description(nil)

	arg_10_0.active = true
	arg_10_0._ready_button_widget.scenegraph_id = "ready_button_alone"
end

function LevelEndView._setup_team_heroes(arg_11_0, arg_11_1)
	local var_11_0 = {}

	for iter_11_0 in pairs(arg_11_1) do
		table.insert(var_11_0, iter_11_0)
	end

	table.sort(var_11_0)

	local var_11_1 = table.size(arg_11_1)
	local var_11_2 = arg_11_0._team_heroes
	local var_11_3 = arg_11_0._peers_with_score

	table.clear(var_11_2)
	table.clear(var_11_3)

	for iter_11_1 = 1, var_11_1 do
		local var_11_4 = var_11_0[iter_11_1]

		if var_11_4 then
			local var_11_5 = arg_11_1[var_11_4]

			var_11_2[#var_11_2 + 1] = arg_11_0:_get_hero_from_score(var_11_5)
			var_11_3[var_11_4] = true
		end
	end
end

function LevelEndView._get_hero_from_score(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_1.profile_index
	local var_12_1 = arg_12_1.career_index
	local var_12_2 = SPProfiles[var_12_0].careers[var_12_1]
	local var_12_3
	local var_12_4
	local var_12_5
	local var_12_6 = arg_12_1.weapon_pose and arg_12_1.weapon_pose.item_name

	if var_12_6 then
		local var_12_7 = ItemMasterList[var_12_6]

		if var_12_7 then
			local var_12_8 = arg_12_1.weapon_pose.skin_name
			local var_12_9 = var_12_7.parent
			local var_12_10 = rawget(ItemMasterList, var_12_9)

			if var_12_10 then
				var_12_4 = {
					item_name = var_12_9,
					skin_name = var_12_8
				}
				var_12_5 = var_12_10.slot_type
				var_12_3 = var_12_7.data.anim_event
			end
		end
	end

	local var_12_11, var_12_12, var_12_13 = arg_12_0:_verify_weapon_data(arg_12_1, var_12_5 or arg_12_1.weapon and var_12_2.preview_wield_slot or nil, var_12_4 or arg_12_1.weapon, var_12_3)

	return {
		profile_index = var_12_0,
		career_index = var_12_1,
		hero_name = var_12_2.profile_name,
		skin_name = arg_12_1.hero_skin,
		weapon_slot = var_12_11,
		weapon_pose_anim_event = var_12_13,
		preview_items = {
			arg_12_1.hat,
			var_12_12
		}
	}
end

local var_0_15 = {}

function LevelEndView._verify_weapon_data(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	local var_13_0 = arg_13_1.profile_index
	local var_13_1 = arg_13_1.career_index
	local var_13_2 = SPProfiles[var_13_0].careers[var_13_1]
	local var_13_3 = var_13_2.name
	local var_13_4 = var_13_2.preview_wield_slot
	local var_13_5 = {
		item_name = var_13_2.preview_items[1]
	}
	local var_13_6

	if not arg_13_3 or arg_13_3 and not arg_13_3.item_name then
		print(string.format("[LevelEndView] No preview weapon was set - using DEFAULT for %s with peer_id: %s", arg_13_1.name, arg_13_1.peer_id))

		return var_13_4, var_13_5, var_13_6
	end

	local var_13_7 = Managers.backend:get_interface("common")
	local var_13_8 = rawget(ItemMasterList, arg_13_3.item_name)

	if not var_13_7:can_wield(var_13_3, var_13_8) then
		print(string.format("[LevelEndView] %q is not wieldable by %s  - using DEFAULT for %s with peer_id: %s", arg_13_3.item_name, var_13_3, arg_13_1.name, arg_13_1.peer_id))

		return var_13_4, var_13_5, var_13_6
	end

	if var_13_8.slot_type ~= arg_13_2 then
		return var_13_4, var_13_5, var_13_6
	end

	local var_13_9 = arg_13_2

	var_13_5.item_name = arg_13_3.item_name

	local var_13_10 = false
	local var_13_11 = arg_13_3.skin_name

	if var_13_11 then
		local var_13_12 = var_13_8.skin_combination_table
		local var_13_13 = WeaponSkins.skin_combinations[var_13_12] or var_0_15

		for iter_13_0, iter_13_1 in pairs(var_13_13) do
			for iter_13_2, iter_13_3 in ipairs(iter_13_1) do
				if iter_13_3 == var_13_11 then
					var_13_10 = true

					break
				end
			end

			if var_13_10 then
				break
			end
		end

		var_13_5.skin_name = var_13_10 and var_13_11
	end

	local var_13_14 = string.gsub(var_13_8.name, "^vs_", "")

	if var_13_8.rarity == "magic" then
		var_13_14 = string.gsub(var_13_14, "_magic_0%d$", "")
	end

	local var_13_15 = "resource_packages/pose_packages/" .. var_13_14

	if Application.can_get("package", var_13_15) then
		var_13_6 = arg_13_4
	else
		var_13_6 = nil
	end

	return var_13_9, var_13_5, var_13_6
end

function LevelEndView._destroy_team_previewer(arg_14_0)
	if arg_14_0._team_previewer then
		arg_14_0._team_previewer:on_exit()

		arg_14_0._team_previewer = nil
	end
end

function LevelEndView._update_team_previewer(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0._team_previewer

	if var_15_0 then
		var_15_0:update(arg_15_1, arg_15_2)
		var_15_0:post_update(arg_15_1, arg_15_2)
	end
end

function LevelEndView._setup_team_previewer(arg_16_0)
	if arg_16_0._team_previewer then
		arg_16_0:_destroy_team_previewer()
	end

	local var_16_0, var_16_1 = arg_16_0:get_viewport_world()

	arg_16_0._team_previewer = TeamPreviewer:new(arg_16_0.context, var_16_0, var_16_1)

	local var_16_2 = arg_16_0._team_heroes
	local var_16_3 = #var_16_2
	local var_16_4 = arg_16_0:_gather_hero_locations()

	arg_16_0._team_previewer:setup_team(var_16_2, var_16_4)
end

function LevelEndView._handle_global_shader_flags(arg_17_0)
	local var_17_0 = false

	for iter_17_0, iter_17_1 in pairs(arg_17_0._team_heroes) do
		local var_17_1 = iter_17_1.profile_index
		local var_17_2 = iter_17_1.career_index

		if SPProfiles[var_17_1].careers[var_17_2].name == "bw_necromancer" then
			var_17_0 = true

			break
		end
	end

	GlobalShaderFlags.set_global_shader_flag("NECROMANCER_CAREER_REMAP", var_17_0)
end

function LevelEndView.draw_weave_widgets(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_0.context.game_mode_key == "weave"
	local var_18_1 = arg_18_0.context.is_quickplay

	if not var_18_0 or not var_18_1 then
		return
	end

	local var_18_2 = arg_18_0.ui_renderer
	local var_18_3 = arg_18_0.ui_scenegraph
	local var_18_4 = arg_18_0._weave_render_settings

	UIRenderer.begin_pass(var_18_2, var_18_3, arg_18_2, arg_18_1, nil, var_18_4)
	UIRenderer.draw_widget(var_18_2, arg_18_0._dead_space_filler_mask)
	UIRenderer.draw_widget(var_18_2, arg_18_0._dead_space_filler_unmask)

	for iter_18_0, iter_18_1 in pairs(arg_18_0._weave_widgets) do
		UIRenderer.draw_widget(var_18_2, iter_18_1)
	end

	UIRenderer.end_pass(var_18_2)
end

function LevelEndView.draw(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0.ui_renderer
	local var_19_1 = arg_19_0.ui_top_renderer
	local var_19_2 = arg_19_0.ui_scenegraph
	local var_19_3 = arg_19_0.input_manager:is_device_active("gamepad")
	local var_19_4 = arg_19_0.waiting_to_start
	local var_19_5 = arg_19_0.render_settings

	UIRenderer.begin_pass(var_19_0, var_19_2, arg_19_2, arg_19_1, nil, var_19_5)

	if var_0_6 then
		UISceneGraph.debug_render_scenegraph(var_19_0, var_19_2)
	end

	for iter_19_0, iter_19_1 in ipairs(arg_19_0._static_widgets) do
		UIRenderer.draw_widget(var_19_0, iter_19_1)
	end

	if arg_19_0._page_selector_widget then
		UIRenderer.draw_widget(var_19_0, arg_19_0._page_selector_widget)
	end

	if arg_19_0._started_force_shutdown then
		for iter_19_2, iter_19_3 in pairs(arg_19_0._dynamic_widgets) do
			UIRenderer.draw_widget(var_19_0, iter_19_3)
		end
	end

	if arg_19_0:state_machine_completed() then
		UIRenderer.draw_widget(var_19_0, arg_19_0._ready_button_widget)
	end

	UIRenderer.end_pass(var_19_0)

	if arg_19_0:state_machine_completed() and var_19_3 and not arg_19_0._ready_button_widget.content.button_hotspot.disable_button then
		arg_19_0._menu_input_description:draw(var_19_1, arg_19_1)
	end
end

function LevelEndView.update(arg_20_0, arg_20_1, arg_20_2)
	LevelEndView.super.update(arg_20_0, arg_20_1, arg_20_2)
	arg_20_0:_update_team_previewer(arg_20_1, arg_20_2)
	arg_20_0:_update_fade(arg_20_1, arg_20_2)
	arg_20_0:_update_story(arg_20_1, arg_20_2)

	local var_20_0 = arg_20_0:input_service()

	arg_20_0:draw_weave_widgets(arg_20_1, var_20_0)

	if arg_20_0.suspended or arg_20_0.waiting_for_post_update_enter then
		return
	end

	arg_20_0:_update_input(arg_20_1, arg_20_2)
	arg_20_0:_update_animations(arg_20_1, arg_20_2)
	arg_20_0:draw(arg_20_1, var_20_0)

	if not arg_20_0._playing_music then
		arg_20_0._playing_music = true

		arg_20_0:play_sound(arg_20_0._start_music_event)
	end

	if script_data.testify then
		Testify:poll_requests_through_handler(var_0_8, arg_20_0)
	end
end

function LevelEndView._update_fade(arg_21_0, arg_21_1, arg_21_2)
	if arg_21_0._fade_out_triggered then
		return
	end

	if arg_21_0._team_previewer and not arg_21_0._team_previewer:loading_done() then
		Managers.transition:force_fade_in()
	else
		Managers.transition:fade_out(2)

		arg_21_0._fade_out_triggered = true

		arg_21_0:_handle_global_shader_flags()
	end
end

function LevelEndView._update_input(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = false

	if arg_22_0:_is_button_hover_enter(arg_22_0._retry_button_widget) or arg_22_0:_is_button_hover_enter(arg_22_0._ready_button_widget) then
		arg_22_0:play_sound("play_gui_start_menu_button_hover")
	end

	if arg_22_0:_is_button_pressed(arg_22_0._ready_button_widget) and not var_22_0 then
		arg_22_0:play_sound("play_gui_mission_summary_button_return_to_keep_click")

		if arg_22_0._left_lobby then
			arg_22_0:exit_to_game()
		else
			arg_22_0:signal_done(false)
		end

		var_22_0 = true
	end

	if not var_22_0 and arg_22_0._cursor_visible then
		arg_22_0:_update_gamepad_input(arg_22_1, arg_22_2)
	end
end

function LevelEndView._update_gamepad_input(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = arg_23_0:input_service()

	if not arg_23_0._ready_button_widget.content.button_hotspot.disable_button and (var_23_0:get("refresh") or Managers.invite:has_invitation()) then
		arg_23_0:play_sound("play_gui_mission_summary_button_return_to_keep_click")

		if arg_23_0._left_lobby then
			arg_23_0:exit_to_game()
		else
			arg_23_0:signal_done(false)
		end
	end
end

function LevelEndView.input_enabled(arg_24_0)
	return not arg_24_0._ready_button_widget.content.button_hotspot.disable_button
end

function LevelEndView.set_input_description(arg_25_0, arg_25_1)
	local var_25_0 = var_0_0.generic_input_actions[arg_25_1]

	arg_25_0._menu_input_description:set_input_description(var_25_0)
end

function LevelEndView._update_animations(arg_26_0, arg_26_1, arg_26_2)
	arg_26_0.ui_animator:update(arg_26_1)

	for iter_26_0, iter_26_1 in pairs(arg_26_0.ui_animations) do
		UIAnimation.update(iter_26_1, arg_26_1)

		if UIAnimation.completed(iter_26_1) then
			arg_26_0.ui_animations[iter_26_0] = nil
		end
	end

	UIWidgetUtils.animate_default_button(arg_26_0._retry_button_widget, arg_26_1)
	UIWidgetUtils.animate_default_button(arg_26_0._ready_button_widget, arg_26_1)
end

function LevelEndView.destroy(arg_27_0, arg_27_1)
	arg_27_0:_destroy_team_previewer()
	LevelEndView.super.destroy(arg_27_0, arg_27_1)
	Managers.state.event:unregister("set_flow_object_set_enabled", arg_27_0)

	arg_27_0._ui_scenegraph = nil
end

function LevelEndView.active_input_service(arg_28_0)
	return arg_28_0.input_blocked and FAKE_INPUT_SERVICE or arg_28_0:input_service()
end

function LevelEndView._start_animation(arg_29_0, arg_29_1)
	local var_29_0 = {
		wwise_world = arg_29_0.wwise_world,
		render_settings = arg_29_0.render_settings
	}
	local var_29_1 = arg_29_0._dynamic_widgets

	return arg_29_0.ui_animator:start_animation(arg_29_1, var_29_1, var_0_2, var_29_0)
end

function LevelEndView._retry_level(arg_30_0)
	arg_30_0:signal_done(true)

	if not arg_30_0.is_server then
		arg_30_0._retry_button_widget.content.button_hotspot.disabled = true
	end
end

function LevelEndView.signal_done(arg_31_0, arg_31_1)
	LevelEndView.super.signal_done(arg_31_0, arg_31_1)

	if arg_31_0._signaled_done then
		return
	end

	arg_31_0._ready_button_widget.content.button_hotspot.disable_button = true
	arg_31_0._retry_button_widget.content.button_hotspot.disable_button = true
end

function LevelEndView.peer_signaled_done(arg_32_0, arg_32_1, arg_32_2)
	LevelEndView.super.peer_signaled_done(arg_32_0, arg_32_1, arg_32_2)

	local var_32_0

	if arg_32_2 then
		var_32_0 = arg_32_0._retry_checkboxes_widget.content
	else
		var_32_0 = arg_32_0._reload_checkboxes_widget.content
	end

	var_32_0.votes = var_32_0.votes + 1
end

function LevelEndView._set_end_timer(arg_33_0, arg_33_1)
	arg_33_0._dynamic_widgets.timer_text.content.text = Localize("timer_prefix_time_left") .. ": " .. UIUtils.format_time(math.ceil(arg_33_1))
end

function LevelEndView.update_force_shutdown(arg_34_0, arg_34_1)
	arg_34_0._force_shutdown_timer = math.max(0, arg_34_0._force_shutdown_timer - arg_34_1)

	arg_34_0:_set_end_timer(arg_34_0._force_shutdown_timer)

	if arg_34_0._force_shutdown_timer == 0 and not arg_34_0._signaled_done then
		arg_34_0:signal_done(false)

		arg_34_0._signaled_done = true
		arg_34_0._signal_done_fallback_timer = 15
		arg_34_0._ready_button_widget.content.button_hotspot.disable_button = true
		arg_34_0._retry_button_widget.content.button_hotspot.disable_button = true
	elseif not arg_34_0._left_lobby then
		if arg_34_0._signal_done_fallback_timer then
			arg_34_0._signal_done_fallback_timer = math.max(0, arg_34_0._signal_done_fallback_timer - arg_34_1)
		end

		local var_34_0 = true

		if arg_34_0._lobby:members() then
			local var_34_1 = arg_34_0._lobby:members():get_members()
			local var_34_2 = arg_34_0._peers_with_score

			for iter_34_0 = 1, #var_34_1 do
				local var_34_3 = var_34_1[iter_34_0]

				if not arg_34_0._done_peers[var_34_3] and (not var_34_2 or var_34_2[var_34_3 .. ":1"]) then
					var_34_0 = false

					break
				end
			end
		end

		if var_34_0 or arg_34_0._signal_done_fallback_timer and arg_34_0._signal_done_fallback_timer <= 0 then
			arg_34_0:exit_to_game()
		end
	end

	if arg_34_0._started_exit then
		arg_34_0._started_force_shutdown = false
	end
end

local var_0_16 = "levels/end_screen_victory/parading_screen"

function LevelEndView.setup_camera(arg_35_0)
	local var_35_0 = arg_35_0.game_won and "pose_camera" or "end_screen_camera"
	local var_35_1
	local var_35_2
	local var_35_3 = arg_35_0.game_won and "units/hub_elements/cutscene_camera/cutscene_camera_env_controls" or "units/hub_elements/cutscene_camera/cutscene_camera"
	local var_35_4 = LevelResource.unit_indices(var_0_16, var_35_3)

	for iter_35_0, iter_35_1 in pairs(var_35_4) do
		local var_35_5 = LevelResource.unit_data(var_0_16, iter_35_1)
		local var_35_6 = DynamicData.get(var_35_5, "name")

		if var_35_6 and var_35_6 == var_35_0 then
			local var_35_7 = LevelResource.unit_position(var_0_16, iter_35_1)
			local var_35_8 = LevelResource.unit_rotation(var_0_16, iter_35_1)
			local var_35_9 = LevelResource.unit_rotation(var_0_16, iter_35_1)
			local var_35_10 = Quaternion.forward(var_35_9)
			local var_35_11 = Matrix4x4.from_quaternion_position(var_35_9, var_35_7)

			var_35_1 = Matrix4x4Box(var_35_11)
			var_35_2 = iter_35_1

			print("Found camera: " .. var_35_6)

			break
		end
	end

	arg_35_0._camera_pose = var_35_1
	arg_35_0._camera_index = var_35_2

	arg_35_0:position_camera()
end

function LevelEndView.get_camera_pose(arg_36_0)
	return arg_36_0._camera_pose:unbox()
end

function LevelEndView.start_story_camera(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
	arg_37_0._storyteller = World.storyteller(arg_37_0._world)

	arg_37_0:stop_playing_story(arg_37_0._story_id)

	local var_37_0 = Storyteller.play_level_story(arg_37_0._storyteller, arg_37_0._level, arg_37_1)

	arg_37_0._story_id = var_37_0

	Storyteller.set_speed(arg_37_0._storyteller, var_37_0, arg_37_3 or 1)
	Storyteller.set_loop_mode(arg_37_0._storyteller, var_37_0, arg_37_2 and Storyteller.LOOP or Storyteller.NONE)

	arg_37_0._story_timer = 0
	arg_37_0._manual_control = arg_37_4
	arg_37_0._story_length = Storyteller.length(arg_37_0._storyteller, var_37_0)

	return var_37_0
end

function LevelEndView.stop_playing_story(arg_38_0, arg_38_1)
	if not arg_38_1 or not arg_38_0._storyteller or not Storyteller.is_playing(arg_38_0._storyteller, arg_38_1) then
		return
	end

	Storyteller.stop(arg_38_0._storyteller, arg_38_1)

	arg_38_0._story_id = nil
end

function LevelEndView.is_playing_story(arg_39_0, arg_39_1)
	if not arg_39_0._storyteller or not arg_39_1 then
		return false
	end

	return (Storyteller.is_playing(arg_39_0._storyteller, arg_39_1))
end

function LevelEndView._update_story(arg_40_0, arg_40_1, arg_40_2)
	if not arg_40_0._storyteller or not arg_40_0._story_id then
		return
	end

	Storyteller.set_speed(arg_40_0._storyteller, arg_40_0._story_id, arg_40_0._state_speed_mult)

	if arg_40_0._manual_control then
		Storyteller.set_time(arg_40_0._storyteller, arg_40_0._story_id, arg_40_0._story_timer)
	end

	local var_40_0 = Level.unit_by_index(arg_40_0._level, arg_40_0._camera_index)
	local var_40_1 = Unit.world_pose(var_40_0, 0)

	arg_40_0._camera_pose = Matrix4x4Box(var_40_1)

	arg_40_0:position_camera()

	if Storyteller.time(arg_40_0._storyteller, arg_40_0._story_id) >= arg_40_0._story_length then
		arg_40_0:stop_playing_story(arg_40_0._story_id)

		arg_40_0._storyteller = nil
	end
end

function LevelEndView.set_story_time(arg_41_0, arg_41_1)
	arg_41_0._story_timer = arg_41_1
end

function LevelEndView._gather_hero_locations(arg_42_0)
	local var_42_0 = {}
	local var_42_1 = LevelResource.unit_indices(var_0_16, "units/hub_elements/versus_podium_character_spawn")

	for iter_42_0, iter_42_1 in pairs(var_42_1) do
		local var_42_2 = LevelResource.unit_data(var_0_16, iter_42_1)
		local var_42_3 = DynamicData.get(var_42_2, "name")

		if var_42_3 and string.find(var_42_3, "spawn_point") then
			local var_42_4 = LevelResource.unit_position(var_0_16, iter_42_1)

			var_42_0[tonumber(string.gsub(var_42_3, "spawn_point_", ""), 10)] = {
				var_42_4[1],
				var_42_4[2],
				var_42_4[3]
			}
		end
	end

	for iter_42_2 = 1, 4 do
		var_42_0[iter_42_2] = var_42_0[iter_42_2] or {
			0,
			0,
			0
		}
	end

	return var_42_0
end

function LevelEndView.create_world(arg_43_0, arg_43_1)
	local var_43_0 = "end_screen"
	local var_43_1 = "environment/ui_end_screen"
	local var_43_2 = 2
	local var_43_3 = arg_43_0:get_world_flags()
	local var_43_4 = Managers.world:create_world(var_43_0, var_43_1, nil, var_43_2, unpack(var_43_3))
	local var_43_5 = Managers.world:world("top_ingame_view")

	return var_43_4, var_43_5
end

function LevelEndView.spawn_level(arg_44_0, arg_44_1, arg_44_2)
	local var_44_0 = {}
	local var_44_1
	local var_44_2
	local var_44_3
	local var_44_4
	local var_44_5 = false
	local var_44_6 = ScriptWorld.spawn_level(arg_44_2, var_0_16, var_44_0, var_44_1, var_44_2, var_44_3, var_44_4, var_44_5)

	Level.spawn_background(var_44_6)
	Level.trigger_level_loaded(var_44_6)
	arg_44_0:_register_object_sets(var_44_6, var_0_16)

	local var_44_7 = arg_44_1.game_won and "flow_victory" or "flow_defeat"

	arg_44_0:_show_object_set(var_44_7, var_44_6)

	return var_44_6
end

function LevelEndView.get_world_link_unit(arg_45_0)
	local var_45_0 = arg_45_0:get_viewport_world()
	local var_45_1 = ScriptWorld.level(var_45_0, var_0_16)

	if var_45_1 then
		local var_45_2 = Level.units(var_45_1)

		for iter_45_0, iter_45_1 in ipairs(var_45_2) do
			local var_45_3 = Unit.get_data(iter_45_1, "name")

			if var_45_3 and var_45_3 == "loot_chest_spawn" then
				return iter_45_1
			end
		end
	end
end

function LevelEndView._push_mouse_cursor(arg_46_0)
	if not arg_46_0._cursor_visible then
		ShowCursorStack.show("LevelEndViewBase")

		arg_46_0._cursor_visible = true

		arg_46_0:_start_animation("ready_button_entry_alone")
	end
end

function LevelEndViewBase._pop_mouse_cursor(arg_47_0)
	if arg_47_0._cursor_visible then
		ShowCursorStack.hide("LevelEndViewBase")

		arg_47_0._cursor_visible = nil
	end
end

function LevelEndView.input_enabled(arg_48_0)
	return not arg_48_0._ready_button_widget.content.button_hotspot.disable_button
end
