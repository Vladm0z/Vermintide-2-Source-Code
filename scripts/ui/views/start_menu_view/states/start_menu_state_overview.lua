-- chunkname: @scripts/ui/views/start_menu_view/states/start_menu_state_overview.lua

require("scripts/settings/profiles/sp_profiles")

local var_0_0 = local_require("scripts/ui/views/start_menu_view/states/definitions/start_menu_state_overview_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.generic_input_actions
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = var_0_0.scenegraph_definition
local var_0_5 = var_0_0.console_cursor_definition
local var_0_6 = false
local var_0_7 = {
	function (arg_1_0)
		Managers.input:block_device_except_service("options_menu", "gamepad")
		arg_1_0:_activate_view("options_view")
	end,
	function (arg_2_0)
		Managers.state.difficulty:set_difficulty("normal", 0)
		Managers.state.game_mode:start_specific_level("prologue")
	end,
	function (arg_3_0)
		arg_3_0:_activate_view("credits_view")
	end,
	function (arg_4_0)
		arg_4_0:_activate_view("cinematics_view")
	end
}

StartMenuStateOverview = class(StartMenuStateOverview)
StartMenuStateOverview.NAME = "StartMenuStateOverview"

StartMenuStateOverview.on_enter = function (arg_5_0, arg_5_1)
	arg_5_0.parent:clear_wanted_state()
	print("[HeroViewState] Enter Substate StartMenuStateOverview")

	arg_5_0._hero_name = arg_5_1.hero_name

	local var_5_0 = arg_5_1.ingame_ui_context

	arg_5_0.ingame_ui_context = var_5_0
	arg_5_0.ui_renderer = var_5_0.ui_renderer
	arg_5_0.ui_top_renderer = var_5_0.ui_top_renderer
	arg_5_0.input_manager = var_5_0.input_manager
	arg_5_0.statistics_db = var_5_0.statistics_db
	arg_5_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_5_0.profile_synchronizer = var_5_0.profile_synchronizer
	arg_5_0.is_server = var_5_0.is_server
	arg_5_0.world_previewer = arg_5_1.world_previewer
	arg_5_0.wwise_world = arg_5_1.wwise_world
	arg_5_0.platform = PLATFORM

	local var_5_1 = Managers.player
	local var_5_2 = var_5_1:local_player()

	arg_5_0._stats_id = var_5_2:stats_id()
	arg_5_0.player_manager = var_5_1
	arg_5_0.peer_id = var_5_0.peer_id
	arg_5_0.local_player_id = var_5_0.local_player_id
	arg_5_0.local_player = var_5_2
	arg_5_0._animations = {}
	arg_5_0._ui_animations = {}
	arg_5_0._available_profiles = {}

	arg_5_0:_init_menu_views()

	local var_5_3 = arg_5_0.parent
	local var_5_4 = arg_5_0:input_service(true)
	local var_5_5 = UILayer.default + 30

	arg_5_0.menu_input_description = MenuInputDescriptionUI:new(var_5_0, arg_5_0.ui_top_renderer, var_5_4, 3, var_5_5, var_0_2.default)

	arg_5_0.menu_input_description:set_input_description(nil)
	arg_5_0:create_ui_elements(arg_5_1)
	arg_5_0:_start_transition_animation("on_enter", "on_enter")

	arg_5_0._hero_preview_skin = nil
	arg_5_0.use_user_skins = true

	local var_5_6 = arg_5_0.profile_synchronizer:profile_by_peer(arg_5_0.peer_id, arg_5_0.local_player_id)
	local var_5_7 = arg_5_0._hero_name

	if var_5_7 then
		local var_5_8 = Managers.backend:get_interface("hero_attributes"):get(var_5_7, "career") or 1

		arg_5_0:_populate_career_page(var_5_7, var_5_8)
	end

	Managers.input:enable_gamepad_cursor()
end

StartMenuStateOverview.create_ui_elements = function (arg_6_0, arg_6_1)
	arg_6_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_4)

	local var_6_0 = {}
	local var_6_1 = {}

	for iter_6_0, iter_6_1 in pairs(var_0_1) do
		local var_6_2 = UIWidget.init(iter_6_1)

		var_6_0[#var_6_0 + 1] = var_6_2
		var_6_1[iter_6_0] = var_6_2
	end

	arg_6_0._widgets = var_6_0
	arg_6_0._widgets_by_name = var_6_1

	if script_data.settings.use_beta_mode and IS_XB1 then
		var_6_1.tutorial_button.content.button_hotspot.disable_button = true
	end

	arg_6_0._console_cursor = UIWidget.init(var_0_5)

	UIRenderer.clear_scenegraph_queue(arg_6_0.ui_top_renderer)

	arg_6_0.ui_animator = UIAnimator:new(arg_6_0.ui_scenegraph, var_0_3)
end

StartMenuStateOverview._get_skin_item_data = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = SPProfiles[arg_7_1].careers[arg_7_2].base_skin

	return Cosmetics[var_7_0]
end

StartMenuStateOverview._wanted_state = function (arg_8_0)
	return (arg_8_0.parent:wanted_state())
end

StartMenuStateOverview.on_exit = function (arg_9_0, arg_9_1)
	Managers.input:disable_gamepad_cursor()

	if arg_9_0._active_view then
		arg_9_0:exit_current_view()
	end

	if arg_9_0.menu_input_description then
		arg_9_0.menu_input_description:destroy()

		arg_9_0.menu_input_description = nil
	end

	arg_9_0.ui_animator = nil

	print("[HeroViewState] Exit Substate StartMenuStateOverview")
end

StartMenuStateOverview._update_transition_timer = function (arg_10_0, arg_10_1)
	if not arg_10_0._transition_timer then
		return
	end

	if arg_10_0._transition_timer == 0 then
		arg_10_0._transition_timer = nil
	else
		arg_10_0._transition_timer = math.max(arg_10_0._transition_timer - arg_10_1, 0)
	end
end

StartMenuStateOverview.update = function (arg_11_0, arg_11_1, arg_11_2)
	if var_0_6 then
		var_0_6 = false

		arg_11_0:create_ui_elements()
	end

	for iter_11_0, iter_11_1 in pairs(arg_11_0._ui_animations) do
		UIAnimation.update(iter_11_1, arg_11_1)

		if UIAnimation.completed(iter_11_1) then
			arg_11_0._ui_animations[iter_11_0] = nil
		end
	end

	local var_11_0 = arg_11_0._active_view

	if var_11_0 then
		arg_11_0._views[var_11_0]:update(arg_11_1, arg_11_2)
	elseif not arg_11_0._prepare_exit then
		arg_11_0:_handle_input(arg_11_1, arg_11_2)
		arg_11_0:_handle_keyboard_input(arg_11_1, arg_11_2)
	end

	local var_11_1 = arg_11_0:_wanted_state()

	if not arg_11_0._transition_timer and (var_11_1 or arg_11_0._new_state) then
		if arg_11_0.world_previewer:has_units_spawned() then
			arg_11_0._prepare_exit = true
		elseif not arg_11_0._prepare_exit then
			return var_11_1 or arg_11_0._new_state
		end
	end

	arg_11_0:draw(arg_11_1)
end

StartMenuStateOverview.post_update = function (arg_12_0, arg_12_1, arg_12_2)
	arg_12_0.ui_animator:update(arg_12_1)
	arg_12_0:_update_animations(arg_12_1)

	if not arg_12_0.parent:transitioning() and not arg_12_0._transition_timer then
		if arg_12_0._prepare_exit then
			arg_12_0._prepare_exit = false

			arg_12_0.world_previewer:prepare_exit()
		elseif arg_12_0._spawn_hero then
			arg_12_0._spawn_hero = nil

			local var_12_0 = arg_12_0._selected_hero_name or arg_12_0._hero_name

			arg_12_0:_spawn_hero_unit(var_12_0)
		end
	end
end

StartMenuStateOverview.draw = function (arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0.ui_renderer
	local var_13_1 = arg_13_0.ui_top_renderer
	local var_13_2 = arg_13_0.ui_scenegraph
	local var_13_3 = arg_13_0.input_manager
	local var_13_4 = arg_13_0.parent
	local var_13_5 = arg_13_0:input_service(true)
	local var_13_6 = arg_13_0.render_settings
	local var_13_7 = var_13_6.snap_pixel_positions

	UIRenderer.begin_pass(var_13_1, var_13_2, var_13_5, arg_13_1, nil, var_13_6)

	for iter_13_0, iter_13_1 in ipairs(arg_13_0._widgets) do
		UIRenderer.draw_widget(var_13_1, iter_13_1)
	end

	if arg_13_0._player_portrait_widget then
		UIRenderer.draw_widget(var_13_1, arg_13_0._player_portrait_widget)
	end

	if not arg_13_0._active_view then
		UIRenderer.draw_widget(var_13_1, arg_13_0._console_cursor)
	end

	UIRenderer.end_pass(var_13_1)
end

StartMenuStateOverview._update_animations = function (arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0._animations
	local var_14_1 = arg_14_0.ui_animator

	for iter_14_0, iter_14_1 in pairs(var_14_0) do
		if var_14_1:is_animation_completed(iter_14_1) then
			var_14_1:stop_animation(iter_14_1)

			var_14_0[iter_14_0] = nil
		end
	end
end

StartMenuStateOverview._spawn_hero_unit = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.world_previewer
	local var_15_1 = arg_15_0.career_index
	local var_15_2 = callback(arg_15_0, "cb_hero_unit_spawned", arg_15_1)

	var_15_0:request_spawn_hero_unit(arg_15_1, arg_15_0.career_index, not arg_15_0.use_user_skins, var_15_2)
end

StartMenuStateOverview.cb_hero_unit_spawned = function (arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.world_previewer
	local var_16_1 = arg_16_0.career_index
	local var_16_2 = FindProfileIndex(arg_16_1)
	local var_16_3 = SPProfiles[var_16_2].careers[var_16_1]
	local var_16_4 = var_16_3.preview_idle_animation
	local var_16_5 = var_16_3.preview_wield_slot
	local var_16_6 = var_16_3.preview_items

	if var_16_6 then
		for iter_16_0, iter_16_1 in ipairs(var_16_6) do
			local var_16_7 = iter_16_1.item_name
			local var_16_8 = ItemMasterList[var_16_7].slot_type
			local var_16_9 = InventorySettings.slot_names_by_type[var_16_8][1]
			local var_16_10 = InventorySettings.slots_by_name[var_16_9]

			var_16_0:equip_item(var_16_7, var_16_10)
		end

		if var_16_5 then
			var_16_0:wield_weapon_slot(var_16_5)
		end
	end

	if arg_16_0.use_user_skins then
		local var_16_11 = var_16_3.name
		local var_16_12 = BackendUtils.get_loadout_item(var_16_11, "slot_hat")

		if var_16_12 then
			local var_16_13 = var_16_12.data.name
			local var_16_14 = var_16_12.backend_id
			local var_16_15 = InventorySettings.slots_by_name.slot_hat

			var_16_0:equip_item(var_16_13, var_16_15, var_16_14)
		end
	end

	if var_16_4 then
		arg_16_0.world_previewer:play_character_animation(var_16_4)
	end
end

StartMenuStateOverview._populate_career_page = function (arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = FindProfileIndex(arg_17_1)
	local var_17_1 = SPProfiles[var_17_0]
	local var_17_2 = var_17_1.character_name
	local var_17_3 = var_17_1.careers[arg_17_2]
	local var_17_4 = var_17_3.name
	local var_17_5 = var_17_3.portrait_image
	local var_17_6 = var_17_3.display_name
	local var_17_7 = var_17_3.icon

	arg_17_0._widgets_by_name.info_career_name.content.text = Localize(var_17_6)
	arg_17_0._spawn_hero = true
	arg_17_0.career_index = arg_17_2

	local var_17_8

	if Managers.mechanism:current_mechanism_name() == "versus" then
		local var_17_9 = ExperienceSettings.get_versus_experience()

		var_17_8 = ExperienceSettings.get_versus_profile_level_from_experience(var_17_9)
	else
		local var_17_10 = Managers.backend:get_interface("hero_attributes"):get(arg_17_1, "experience") or 0

		var_17_8 = ExperienceSettings.get_level(var_17_10)
	end

	arg_17_0:_set_hero_info(Localize(var_17_2), var_17_8)

	local var_17_11 = arg_17_0:_get_portrait_frame(var_17_0, arg_17_2)

	arg_17_0:_create_player_portrait(var_17_5, var_17_8, var_17_11)
end

StartMenuStateOverview._get_portrait_frame = function (arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = SPProfiles[arg_18_1].careers[arg_18_2].name
	local var_18_1 = "default"
	local var_18_2 = BackendUtils.get_loadout_item(var_18_0, "slot_frame")

	var_18_1 = var_18_2 and var_18_2.data.temporary_template or var_18_1

	return var_18_1
end

StartMenuStateOverview._set_hero_info = function (arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0._widgets_by_name

	var_19_0.info_hero_name.content.text = arg_19_1
	var_19_0.info_hero_level.content.text = Localize("level") .. ": " .. arg_19_2
end

StartMenuStateOverview._create_player_portrait = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0 = arg_20_2 and tostring(arg_20_2) or "-"
	local var_20_1 = 1
	local var_20_2 = false
	local var_20_3 = UIWidgets.create_portrait_frame("portrait_root", arg_20_3, var_20_0, var_20_1, var_20_2, arg_20_1)

	arg_20_0._player_portrait_widget = UIWidget.init(var_20_3, arg_20_0.ui_top_renderer)
end

StartMenuStateOverview._set_select_button_enabled = function (arg_21_0, arg_21_1)
	arg_21_0._widgets_by_name.select_button.content.button_hotspot.disable_button = not arg_21_1
end

StartMenuStateOverview._clear_keyboard_selection = function (arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0._widgets_by_name

	for iter_22_0, iter_22_1 in ipairs(arg_22_1) do
		for iter_22_2, iter_22_3 in ipairs(iter_22_1) do
			var_22_0[iter_22_3].content.button_hotspot.is_selected = false
		end
	end

	arg_22_0._keyboard_grid_selection = nil
end

StartMenuStateOverview._handle_keyboard_input = function (arg_23_0)
	local var_23_0 = Managers.input:is_device_active("gamepad")
	local var_23_1 = Managers.input:is_device_active("mouse")
	local var_23_2 = {
		{
			"play_button",
			"options_button",
			"tutorial_button",
			"cinematics_button",
			"credits_button",
			"quit_button"
		},
		{
			"hero_button"
		}
	}

	if var_23_1 or var_23_0 then
		arg_23_0:_clear_keyboard_selection(var_23_2)

		return
	end

	local var_23_3 = {
		play_button = function ()
			arg_23_0.parent:close_menu()
		end,
		options_button = function ()
			var_0_7[1](arg_23_0)
		end,
		tutorial_button = function ()
			var_0_7[2](arg_23_0)
		end,
		cinematics_button = function ()
			var_0_7[4](arg_23_0)
		end,
		credits_button = function ()
			var_0_7[3](arg_23_0)
		end,
		quit_button = function ()
			Boot.quit_game = true
		end,
		hero_button = function ()
			arg_23_0.parent:requested_screen_change_by_name("character")
		end
	}
	local var_23_4 = arg_23_0._keyboard_grid_selection or {}
	local var_23_5 = var_23_4[1] or 1
	local var_23_6 = var_23_4[2] or 1
	local var_23_7 = arg_23_0:input_service(true)

	if var_23_7:get("move_down_hold_continuous") then
		var_23_6 = var_23_6 + 1
	elseif var_23_7:get("move_up_hold_continuous") then
		var_23_6 = var_23_6 - 1
	elseif var_23_7:get("move_right_hold_continuous") then
		var_23_5 = var_23_5 + 1
	elseif var_23_7:get("move_left_hold_continuous") then
		var_23_5 = var_23_5 - 1
	elseif var_23_7:get("confirm_press") then
		local var_23_8 = var_23_3[var_23_2[var_23_5][var_23_6]]

		if var_23_8 then
			var_23_8()
			arg_23_0:_play_sound("play_gui_start_menu_button_click")
		end
	end

	local var_23_9 = math.clamp(var_23_5, 1, #var_23_2)
	local var_23_10 = math.clamp(var_23_6, 1, #var_23_2[var_23_9])
	local var_23_11 = arg_23_0._widgets_by_name

	if var_23_9 ~= var_23_4[1] or var_23_10 ~= var_23_4[2] then
		for iter_23_0, iter_23_1 in ipairs(var_23_2) do
			for iter_23_2, iter_23_3 in ipairs(iter_23_1) do
				var_23_11[iter_23_3].content.button_hotspot.is_selected = iter_23_0 == var_23_9 and iter_23_2 == var_23_10
			end
		end

		var_23_4[1] = var_23_9
		var_23_4[2] = var_23_10
		arg_23_0._keyboard_grid_selection = var_23_4

		arg_23_0:_play_sound("play_gui_start_menu_button_hover")
	end
end

StartMenuStateOverview._handle_input = function (arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = arg_31_0:input_service(true)
	local var_31_1 = arg_31_0._widgets_by_name
	local var_31_2 = var_31_1.play_button
	local var_31_3 = var_31_1.hero_button
	local var_31_4 = var_31_1.quit_button
	local var_31_5 = var_31_1.credits_button
	local var_31_6 = var_31_1.options_button
	local var_31_7 = var_31_1.tutorial_button
	local var_31_8 = var_31_1.cinematics_button

	UIWidgetUtils.animate_default_button(var_31_2, arg_31_1)
	UIWidgetUtils.animate_default_button(var_31_3, arg_31_1)
	UIWidgetUtils.animate_default_button(var_31_4, arg_31_1)
	UIWidgetUtils.animate_default_button(var_31_5, arg_31_1)
	UIWidgetUtils.animate_default_button(var_31_8, arg_31_1)
	UIWidgetUtils.animate_default_button(var_31_6, arg_31_1)
	UIWidgetUtils.animate_default_button(var_31_7, arg_31_1)

	if arg_31_0:_is_button_hover_enter(var_31_2) or arg_31_0:_is_button_hover_enter(var_31_3) or arg_31_0:_is_button_hover_enter(var_31_4) or arg_31_0:_is_button_hover_enter(var_31_5) or arg_31_0:_is_button_hover_enter(var_31_6) or arg_31_0:_is_button_hover_enter(var_31_7) then
		arg_31_0:_play_sound("play_gui_start_menu_button_hover")
	elseif arg_31_0:_is_button_hover_enter(var_31_8) then
		arg_31_0:_play_sound("play_gui_start_menu_button_hover")
	end

	if arg_31_0:_is_button_pressed(var_31_3) then
		arg_31_0:_play_sound("play_gui_start_menu_button_click")
		arg_31_0.parent:requested_screen_change_by_name("character")
	elseif arg_31_0:_is_button_pressed(var_31_2) then
		arg_31_0:_play_sound("play_gui_start_menu_button_click")
		arg_31_0.parent:close_menu()
	elseif arg_31_0:_is_button_pressed(var_31_6) then
		arg_31_0:_play_sound("play_gui_start_menu_button_click")
		var_0_7[1](arg_31_0)
		arg_31_0:_play_sound("play_gui_start_menu_button_click")
	elseif arg_31_0:_is_button_pressed(var_31_7) then
		var_0_7[2](arg_31_0)
		arg_31_0:_play_sound("play_gui_start_menu_button_click")
	elseif arg_31_0:_is_button_pressed(var_31_8) then
		var_0_7[4](arg_31_0)
		arg_31_0:_play_sound("play_gui_start_menu_button_click")
	elseif arg_31_0:_is_button_pressed(var_31_5) then
		var_0_7[3](arg_31_0)
	elseif arg_31_0:_is_button_pressed(var_31_4) then
		arg_31_0:_play_sound("play_gui_start_menu_button_click")

		Boot.quit_game = true
	end

	if Development.parameter("tobii_button") then
		arg_31_0:_handle_tobii_button(arg_31_1)
	end
end

StartMenuStateOverview._handle_tobii_button = function (arg_32_0, arg_32_1)
	local var_32_0 = arg_32_0._widgets_by_name.tobii_button

	UIWidgetUtils.animate_default_button(var_32_0, arg_32_1)

	if arg_32_0:_is_button_pressed(var_32_0) then
		arg_32_0:_play_sound("play_gui_start_menu_button_click")

		local var_32_1 = "https://vermintide2beta.com/?utm_medium=referral&utm_campaign=vermintide2beta&utm_source=ingame#challenge"

		Application.open_url_in_browser(var_32_1)
	end
end

StartMenuStateOverview.game_popup_active = function (arg_33_0)
	return arg_33_0._show_play_popup
end

StartMenuStateOverview._is_button_pressed = function (arg_34_0, arg_34_1)
	local var_34_0 = arg_34_1.content.button_hotspot

	if var_34_0.on_release then
		var_34_0.on_release = false

		return true
	end
end

StartMenuStateOverview._is_button_hover_enter = function (arg_35_0, arg_35_1)
	return arg_35_1.content.button_hotspot.on_hover_enter
end

StartMenuStateOverview._is_button_hover_exit = function (arg_36_0, arg_36_1)
	return arg_36_1.content.button_hotspot.on_hover_exit
end

StartMenuStateOverview._play_sound = function (arg_37_0, arg_37_1)
	arg_37_0.parent:play_sound(arg_37_1)
end

StartMenuStateOverview.get_camera_position = function (arg_38_0)
	local var_38_0, var_38_1 = arg_38_0.parent:get_background_world()
	local var_38_2 = ScriptViewport.camera(var_38_1)

	return ScriptCamera.position(var_38_2)
end

StartMenuStateOverview.get_camera_rotation = function (arg_39_0)
	local var_39_0, var_39_1 = arg_39_0.parent:get_background_world()
	local var_39_2 = ScriptViewport.camera(var_39_1)

	return ScriptCamera.rotation(var_39_2)
end

StartMenuStateOverview.trigger_unit_flow_event = function (arg_40_0, arg_40_1, arg_40_2)
	if arg_40_1 and Unit.alive(arg_40_1) then
		Unit.flow_event(arg_40_1, arg_40_2)
	end
end

StartMenuStateOverview._start_transition_animation = function (arg_41_0, arg_41_1, arg_41_2)
	local var_41_0 = {
		wwise_world = arg_41_0.wwise_world,
		render_settings = arg_41_0.render_settings
	}
	local var_41_1 = {}
	local var_41_2 = arg_41_0.ui_animator:start_animation(arg_41_2, var_41_1, var_0_4, var_41_0)

	arg_41_0._animations[arg_41_1] = var_41_2
end

StartMenuStateOverview._on_option_button_hover = function (arg_42_0, arg_42_1, arg_42_2)
	local var_42_0 = arg_42_0._ui_animations
	local var_42_1 = "option_button_" .. arg_42_2
	local var_42_2 = arg_42_1.style[arg_42_2]
	local var_42_3 = var_42_2.color[2]
	local var_42_4 = 255
	local var_42_5 = UISettings.scoreboard.topic_hover_duration
	local var_42_6 = (1 - var_42_3 / var_42_4) * var_42_5

	for iter_42_0 = 2, 4 do
		if var_42_6 > 0 then
			var_42_0[var_42_1 .. "_hover_" .. iter_42_0] = arg_42_0:_animate_element_by_time(var_42_2.color, iter_42_0, var_42_3, var_42_4, var_42_6)
		else
			var_42_2.color[iter_42_0] = var_42_4
		end
	end
end

StartMenuStateOverview._on_option_button_dehover = function (arg_43_0, arg_43_1, arg_43_2)
	local var_43_0 = arg_43_0._ui_animations
	local var_43_1 = "option_button_" .. arg_43_2
	local var_43_2 = arg_43_1.style[arg_43_2]
	local var_43_3 = var_43_2.color[1]
	local var_43_4 = 100
	local var_43_5 = UISettings.scoreboard.topic_hover_duration
	local var_43_6 = var_43_3 / 255 * var_43_5

	for iter_43_0 = 2, 4 do
		if var_43_6 > 0 then
			var_43_0[var_43_1 .. "_hover_" .. iter_43_0] = arg_43_0:_animate_element_by_time(var_43_2.color, iter_43_0, var_43_3, var_43_4, var_43_6)
		else
			var_43_2.color[1] = var_43_4
		end
	end
end

StartMenuStateOverview.play_sound = function (arg_44_0, arg_44_1)
	return
end

StartMenuStateOverview._animate_element_by_time = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5)
	return (UIAnimation.init(UIAnimation.function_by_time, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5, math.ease_out_quad))
end

StartMenuStateOverview._animate_element_by_catmullrom = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5, arg_46_6, arg_46_7, arg_46_8)
	return (UIAnimation.init(UIAnimation.catmullrom, arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5, arg_46_6, arg_46_7, arg_46_8))
end

StartMenuStateOverview._init_menu_views = function (arg_47_0)
	local var_47_0 = arg_47_0.ingame_ui_context

	arg_47_0._views = {
		credits_view = CreditsView:new(var_47_0),
		options_view = OptionsView:new(var_47_0),
		cinematics_view = CinematicsView:new(var_47_0)
	}

	for iter_47_0, iter_47_1 in pairs(arg_47_0._views) do
		iter_47_1.exit = function ()
			arg_47_0:exit_current_view()
		end
	end
end

StartMenuStateOverview._activate_view = function (arg_49_0, arg_49_1)
	arg_49_0._active_view = arg_49_1

	local var_49_0 = arg_49_0._views

	assert(var_49_0[arg_49_1])

	if arg_49_1 and var_49_0[arg_49_1] and var_49_0[arg_49_1].on_enter then
		Managers.input:disable_gamepad_cursor()
		var_49_0[arg_49_1]:on_enter()
	end
end

StartMenuStateOverview.exit_current_view = function (arg_50_0)
	local var_50_0 = arg_50_0._active_view
	local var_50_1 = arg_50_0._views

	assert(var_50_0)

	if var_50_1[var_50_0] and var_50_1[var_50_0].on_exit then
		var_50_1[var_50_0]:on_exit()
	end

	arg_50_0._active_view = nil

	local var_50_2 = arg_50_0:input_service(true).name
	local var_50_3 = Managers.input

	var_50_3:block_device_except_service(var_50_2, "keyboard")
	var_50_3:block_device_except_service(var_50_2, "mouse")
	var_50_3:block_device_except_service(var_50_2, "gamepad")
	Managers.input:enable_gamepad_cursor()
end

StartMenuStateOverview.input_service = function (arg_51_0, arg_51_1)
	if not arg_51_1 then
		local var_51_0 = arg_51_0._active_view
		local var_51_1 = arg_51_0._views[var_51_0]

		if var_51_1 then
			return var_51_1:input_service()
		end
	end

	return arg_51_0.parent:input_service(true)
end
