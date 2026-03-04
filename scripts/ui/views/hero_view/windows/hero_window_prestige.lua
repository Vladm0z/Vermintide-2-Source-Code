-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_prestige.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_prestige_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.warning_widgets
local var_0_3 = var_0_0.scenegraph_definition
local var_0_4 = var_0_0.animation_definitions
local var_0_5 = false

HeroWindowPrestige = class(HeroWindowPrestige)
HeroWindowPrestige.NAME = "HeroWindowPrestige"

function HeroWindowPrestige.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowPrestige")

	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}

	local var_1_1 = Managers.player

	arg_1_0._stats_id = var_1_1:local_player():stats_id()
	arg_1_0.player_manager = var_1_1
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0._animations = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)

	arg_1_0.hero_name = arg_1_1.hero_name
	arg_1_0.career_index = arg_1_1.career_index
	arg_1_0.profile_index = arg_1_1.profile_index

	local var_1_2 = ExperienceSettings.get_experience(arg_1_0.hero_name)

	arg_1_0.hero_level = ExperienceSettings.get_level(var_1_2)

	arg_1_0:_setup_prestige_reward()
end

function HeroWindowPrestige.on_exit(arg_2_0, arg_2_1)
	print("[HeroViewWindow] Exit Substate HeroWindowPrestige")

	arg_2_0.ui_animator = nil
end

function HeroWindowPrestige.create_ui_elements(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_3)

	local var_3_0 = {}
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in pairs(var_0_1) do
		local var_3_2 = UIWidget.init(iter_3_1)

		var_3_0[#var_3_0 + 1] = var_3_2
		var_3_1[iter_3_0] = var_3_2
	end

	arg_3_0._widgets = var_3_0
	arg_3_0._widgets_by_name = var_3_1

	local var_3_3 = {}

	for iter_3_2, iter_3_3 in pairs(var_0_2) do
		local var_3_4 = UIWidget.init(iter_3_3)

		var_3_3[#var_3_3 + 1] = var_3_4
		var_3_1[iter_3_2] = var_3_4
	end

	arg_3_0._warning_widgets = var_3_3

	UIRenderer.clear_scenegraph_queue(arg_3_0.ui_renderer)

	arg_3_0.ui_animator = UIAnimator:new(arg_3_0.ui_scenegraph, var_0_4)

	if arg_3_2 then
		local var_3_5 = arg_3_0.ui_scenegraph.window.local_position

		var_3_5[1] = var_3_5[1] + arg_3_2[1]
		var_3_5[2] = var_3_5[2] + arg_3_2[2]
		var_3_5[3] = var_3_5[3] + arg_3_2[3]
	end
end

function HeroWindowPrestige._setup_prestige_reward(arg_4_0)
	local var_4_0 = arg_4_0._widgets_by_name
	local var_4_1 = arg_4_0.hero_name
	local var_4_2 = ProgressionUnlocks.get_max_prestige_levels()

	arg_4_0._max_prestige_level = var_4_2

	local var_4_3 = ProgressionUnlocks.get_prestige_level(var_4_1)

	arg_4_0._prestige_level = var_4_3

	local var_4_4 = math.min(var_4_3 + 1, var_4_2)

	if not (var_4_3 == var_4_4) then
		local var_4_5
		local var_4_6
		local var_4_7 = ProgressionUnlocks.prestige_reward_by_level(var_4_4, var_4_1)

		arg_4_0._reward_item_key = var_4_7

		local var_4_8 = ItemMasterList[var_4_7]
		local var_4_9 = var_4_8.item_type
		local var_4_10 = var_4_8.display_name

		if var_4_9 == "hat" then
			-- block empty
		elseif var_4_9 == "frame" then
			var_4_5 = var_4_8.name
		elseif var_4_9 == "skin" then
			-- block empty
		end

		arg_4_0:_set_prestige_reward_portrait_frame(var_4_5)

		var_4_0.reward_item_text.content.text = Localize(var_4_10)
	end

	local var_4_11 = ProgressionUnlocks.can_upgrade_prestige(var_4_1)

	var_4_0.prestige_button.content.button_hotspot.disable_button = not var_4_11
	var_4_0.unable_description_text.content.visible = not var_4_11
end

function HeroWindowPrestige.update(arg_5_0, arg_5_1, arg_5_2)
	if var_0_5 then
		var_0_5 = false

		arg_5_0:create_ui_elements()
	end

	arg_5_0:_update_animations(arg_5_1)
	arg_5_0:_handle_input(arg_5_1, arg_5_2)
	arg_5_0:draw(arg_5_1)
end

function HeroWindowPrestige.post_update(arg_6_0, arg_6_1, arg_6_2)
	return
end

function HeroWindowPrestige._update_animations(arg_7_0, arg_7_1)
	arg_7_0.ui_animator:update(arg_7_1)

	local var_7_0 = arg_7_0._animations
	local var_7_1 = arg_7_0.ui_animator

	for iter_7_0, iter_7_1 in pairs(var_7_0) do
		if var_7_1:is_animation_completed(iter_7_1) then
			var_7_1:stop_animation(iter_7_1)

			var_7_0[iter_7_0] = nil
		end
	end
end

function HeroWindowPrestige._is_button_pressed(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_1.content.button_hotspot

	if var_8_0.on_pressed then
		var_8_0.on_pressed = false

		return true
	end
end

function HeroWindowPrestige._is_button_released(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_1.content.button_hotspot

	if var_9_0.on_release then
		var_9_0.on_release = false

		return true
	end
end

function HeroWindowPrestige._is_stepper_button_pressed(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1.content
	local var_10_1 = var_10_0.button_hotspot_left
	local var_10_2 = var_10_0.button_hotspot_right

	if var_10_1.on_release then
		var_10_1.on_release = false

		return true, -1
	elseif var_10_2.on_release then
		var_10_2.on_release = false

		return true, 1
	end
end

function HeroWindowPrestige._handle_input(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0.parent
	local var_11_1 = arg_11_0._widgets_by_name
	local var_11_2 = Managers.backend:get_interface("hero_attributes")

	if arg_11_0:_is_button_pressed(var_11_1.debug_level_up_button) then
		var_11_2:set(arg_11_0.hero_name, "experience", ExperienceSettings.max_experience)
		arg_11_0:_setup_prestige_reward()

		return true
	end

	if arg_11_0:_is_button_pressed(var_11_1.prestige_button) and not arg_11_0._show_warning_popup then
		var_11_1.prestige_button.content.visible = false
		arg_11_0._show_warning_popup = true

		var_11_0:block_input()
		var_11_0:set_fullscreen_effect_enable_state(true)

		return true
	end

	if arg_11_0._show_warning_popup then
		local var_11_3 = var_11_0:input_service():get("toggle_menu", true)

		if arg_11_0:_is_button_pressed(var_11_1.warning_popup_decline_button) or var_11_3 then
			var_11_1.prestige_button.content.visible = true
			arg_11_0._show_warning_popup = false

			var_11_0:unblock_input()
			var_11_0:set_fullscreen_effect_enable_state(false)

			return true
		end

		if arg_11_0:_is_button_pressed(var_11_1.warning_popup_accept_button) then
			var_11_1.prestige_button.content.visible = true
			arg_11_0._show_warning_popup = false

			arg_11_0:_play_sound("Play_enemy_combat_globadier_suicide_explosion")
			var_11_2:prestige(arg_11_0.hero_name)

			arg_11_0._wait_for_backend_attributes = true

			var_11_0:unblock_input()
			var_11_0:set_fullscreen_effect_enable_state(false)
			arg_11_0:_setup_prestige_reward()

			return true
		end
	end
end

function HeroWindowPrestige.draw(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0.ui_renderer
	local var_12_1 = arg_12_0.ui_top_renderer
	local var_12_2 = arg_12_0.ui_scenegraph
	local var_12_3 = arg_12_0.parent:window_input_service()

	UIRenderer.begin_pass(var_12_0, var_12_2, var_12_3, arg_12_1, nil, arg_12_0.render_settings)

	for iter_12_0, iter_12_1 in ipairs(arg_12_0._widgets) do
		UIRenderer.draw_widget(var_12_0, iter_12_1)
	end

	if arg_12_0._reward_portrait_widget then
		UIRenderer.draw_widget(var_12_0, arg_12_0._reward_portrait_widget)
	end

	UIRenderer.end_pass(var_12_0)

	if arg_12_0._show_warning_popup then
		local var_12_4 = arg_12_0.parent:input_service()

		UIRenderer.begin_pass(var_12_1, var_12_2, var_12_4, arg_12_1, nil, arg_12_0.render_settings)

		for iter_12_2, iter_12_3 in ipairs(arg_12_0._warning_widgets) do
			UIRenderer.draw_widget(var_12_1, iter_12_3)
		end

		UIRenderer.end_pass(var_12_1)
	end
end

function HeroWindowPrestige._play_sound(arg_13_0, arg_13_1)
	arg_13_0.parent:play_sound(arg_13_1)
end

function HeroWindowPrestige._set_prestige_reward_portrait_frame(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0.career_index
	local var_14_1 = arg_14_0.profile_index
	local var_14_2 = SPProfiles[var_14_1].careers[var_14_0].portrait_image
	local var_14_3

	if arg_14_1 then
		local var_14_4 = UIWidgets.create_portrait_frame("reward_portrait_root", arg_14_1, "", 1, nil, var_14_2)

		var_14_3 = UIWidget.init(var_14_4, arg_14_0.ui_renderer)
		var_14_3.content.frame_settings_name = arg_14_1
	end

	arg_14_0._reward_portrait_widget = var_14_3
end
