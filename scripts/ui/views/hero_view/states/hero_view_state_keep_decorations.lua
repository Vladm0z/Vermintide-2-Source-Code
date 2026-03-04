-- chunkname: @scripts/ui/views/hero_view/states/hero_view_state_keep_decorations.lua

require("scripts/ui/helpers/scrollbar_logic")

local var_0_0 = local_require("scripts/ui/views/hero_view/states/definitions/hero_view_state_keep_decorations_definitions")
local var_0_1 = var_0_0.widgets_definitions
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.generic_input_actions
local var_0_4 = var_0_0.animation_definitions
local var_0_5 = var_0_0.entry_widget_definition
local var_0_6 = var_0_0.dummy_entry_widget_definition
local var_0_7 = var_0_0.input_actions
local var_0_8 = false
local var_0_9 = 4
local var_0_10 = 800
local var_0_11 = 1

HeroViewStateKeepDecorations = class(HeroViewStateKeepDecorations)
HeroViewStateKeepDecorations.NAME = "HeroViewStateKeepDecorations"

HeroViewStateKeepDecorations.on_enter = function (arg_1_0, arg_1_1)
	print("[HeroViewState] Enter Substate HeroViewStateKeepDecorations")

	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ingame_ui_context = var_1_0
	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._input_manager = var_1_0.input_manager
	arg_1_0._voting_manager = var_1_0.voting_manager
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._wwise_world = arg_1_1.wwise_world
	arg_1_0._is_server = var_1_0.is_server

	local var_1_1 = arg_1_0:input_service()

	arg_1_0._menu_input_description = MenuInputDescriptionUI:new(var_1_0, arg_1_0._ui_top_renderer, var_1_1, 3, 100, var_0_3)

	arg_1_0._menu_input_description:set_input_description(nil)

	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}
	arg_1_0._decoration_system = Managers.state.entity:system("keep_decoration_system")
	arg_1_0._keep_decoration_backend_interface = Managers.backend:get_interface("keep_decorations")

	arg_1_0:_create_ui_elements(arg_1_1)

	if arg_1_1.initial_state then
		arg_1_1.initial_state = nil

		arg_1_0:_start_transition_animation("on_enter", "on_enter")
	end

	arg_1_0:_play_sound("Play_hud_trophy_open")

	local var_1_2 = arg_1_1.state_params
	local var_1_3 = var_1_2.interactable_unit

	arg_1_0._interactable_unit = var_1_3
	arg_1_0._type = var_1_2.type

	if arg_1_0._type == "painting" then
		arg_1_0._default_table = DefaultPaintings
		arg_1_0._main_table = Paintings
		arg_1_0._ordered_table = PaintingOrder
		arg_1_0._empty_decoration_name = "hor_none"
	elseif arg_1_0._type == "trophy" then
		arg_1_0._default_table = DefaultTrophies
		arg_1_0._main_table = Trophies
		arg_1_0._ordered_table = TrophyOrder
		arg_1_0._empty_decoration_name = "hub_trophy_empty"
	end

	arg_1_0._default_decorations = {}

	table.append(arg_1_0._default_decorations, DefaultPaintings)
	table.append(arg_1_0._default_decorations, DefaultTrophies)

	local var_1_4 = Unit.get_data(var_1_3, "interaction_data", "camera_interaction_name")
	local var_1_5 = Unit.get_data(var_1_3, "interaction_data", "hide_character")

	arg_1_0._hide_character = var_1_5

	local var_1_6 = Managers.player:local_player()

	if var_1_6 then
		UISettings.map.camera_time_enter = Unit.get_data(var_1_3, "interaction_data", "camera_transition_time_in") or 0.5
		UISettings.map.camera_time_exit = Unit.get_data(var_1_3, "interaction_data", "camera_transition_time_out") or 0.5

		local var_1_7 = {
			camera_interaction_name = var_1_4
		}

		CharacterStateHelper.change_camera_state(var_1_6, "camera_state_interaction", var_1_7)

		local var_1_8 = var_1_6.player_unit

		if Unit.alive(var_1_8) then
			local var_1_9 = ScriptUnit.extension(var_1_8, "first_person_system")

			var_1_9:abort_toggle_visibility_timer()
			var_1_9:abort_first_person_units_visibility_timer()

			if var_1_5 then
				if not var_1_9:first_person_mode_active() then
					var_1_9:set_first_person_mode(true)
				end

				if var_1_9:first_person_units_visible() then
					var_1_9:toggle_first_person_units_visibility("third_person_mode")
				end
			elseif var_1_9:first_person_mode_active() then
				var_1_9:set_first_person_mode(false)
			end
		end
	end

	if Unit.get_data(var_1_3, "decoration_settings_key") then
		local var_1_10 = ScriptUnit.extension(var_1_3, "keep_decoration_system")
		local var_1_11 = var_1_10:get_selected_decoration()

		arg_1_0._keep_decoration_extension = var_1_10

		if Unit.get_data(var_1_3, "interaction_data", "view_only") or not arg_1_0._is_server then
			arg_1_0:_set_info_by_decoration_key(var_1_11, false)
		else
			arg_1_0._customizable_decoration = true

			arg_1_0:_setup_decorations_list()

			local var_1_12 = 1
			local var_1_13 = arg_1_0._list_widgets

			for iter_1_0 = 1, #var_1_13 do
				if var_1_13[iter_1_0].content.key == var_1_11 then
					var_1_12 = iter_1_0

					break
				end
			end

			arg_1_0:_on_list_index_selected(var_1_12)

			local var_1_14 = arg_1_0:_get_scrollbar_percentage_by_index(var_1_12)

			arg_1_0._scrollbar_logic:set_scroll_percentage(var_1_14)
		end
	else
		arg_1_0:_initialize_simple_decoration_preview()
	end

	if not arg_1_0._customizable_decoration then
		arg_1_0:_disable_list_widgets()
	end
end

HeroViewStateKeepDecorations._disable_list_widgets = function (arg_2_0)
	local var_2_0 = arg_2_0._widgets_by_name

	var_2_0.list_mask.content.visible = false
	var_2_0.list_scrollbar.content.visible = false
	var_2_0.confirm_button.content.visible = false
	var_2_0.list_detail_top.content.visible = false
	var_2_0.list_detail_bottom.content.visible = false
end

HeroViewStateKeepDecorations._initialize_simple_decoration_preview = function (arg_3_0)
	local var_3_0 = arg_3_0._interactable_unit
	local var_3_1 = Unit.get_data(var_3_0, "interaction_data", "hud_text_line_1")
	local var_3_2 = Unit.get_data(var_3_0, "interaction_data", "hud_text_line_2")
	local var_3_3 = Unit.get_data(var_3_0, "interaction_data", "sound_event")

	if var_3_3 and var_3_3 ~= "" then
		arg_3_0._sound_event = var_3_3
		arg_3_0._sound_event_delay = arg_3_0._sound_event and var_0_11 or nil
	end

	local var_3_4 = Localize(var_3_1)
	local var_3_5 = Localize(var_3_2)

	arg_3_0:_set_info_texts(var_3_4, var_3_5)
end

HeroViewStateKeepDecorations.on_exit = function (arg_4_0, arg_4_1)
	print("[HeroViewState] Exit Substate HeroViewStateKeepDecorations")

	arg_4_0.ui_animator = nil

	if arg_4_0._customizable_decoration then
		local var_4_0 = arg_4_0._interactable_unit

		ScriptUnit.extension(var_4_0, "keep_decoration_system"):reset_selection()
	end

	if arg_4_0._fullscreen_effect_enabled then
		arg_4_0:set_fullscreen_effect_enable_state(false)
	end

	arg_4_0:_play_sound("Stop_all_keep_decorations_desc_vo")
	arg_4_0:_play_sound("Stop_trophy_music")

	local var_4_1 = Managers.player:local_player()

	if var_4_1 then
		CharacterStateHelper.change_camera_state(var_4_1, "follow")

		local var_4_2 = var_4_1.player_unit

		if Unit.alive(var_4_2) then
			local var_4_3 = ScriptUnit.extension(var_4_2, "first_person_system")

			var_4_3:abort_toggle_visibility_timer()
			var_4_3:abort_first_person_units_visibility_timer()

			local var_4_4 = UISettings.map.camera_time_exit or 0.5

			if not var_4_3:first_person_mode_active() then
				var_4_3:toggle_visibility(var_4_4)
			elseif not var_4_3:first_person_units_visible() then
				var_4_3:toggle_first_person_units_visibility("third_person_mode", var_4_4)
			end
		end
	end
end

HeroViewStateKeepDecorations._create_ui_elements = function (arg_5_0, arg_5_1)
	arg_5_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)

	local var_5_0 = {}
	local var_5_1 = {}

	for iter_5_0, iter_5_1 in pairs(var_0_1) do
		if iter_5_1 then
			local var_5_2 = UIWidget.init(iter_5_1)

			var_5_0[#var_5_0 + 1] = var_5_2
			var_5_1[iter_5_0] = var_5_2
		end
	end

	arg_5_0._widgets = var_5_0
	arg_5_0._widgets_by_name = var_5_1

	UIRenderer.clear_scenegraph_queue(arg_5_0._ui_renderer)

	arg_5_0.ui_animator = UIAnimator:new(arg_5_0._ui_scenegraph, var_0_4)

	local var_5_3 = arg_5_0._widgets_by_name.list_scrollbar

	arg_5_0._scrollbar_logic = ScrollBarLogic:new(var_5_3)
end

HeroViewStateKeepDecorations._set_color_alpha_intensity = function (arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:_set_color_values(arg_6_1, arg_6_1[1] * arg_6_2)
end

HeroViewStateKeepDecorations._set_color_intensity = function (arg_7_0, arg_7_1, arg_7_2)
	arg_7_0:_set_color_values(arg_7_1, nil, arg_7_1[2] * arg_7_2, arg_7_1[3] * arg_7_2, arg_7_1[4] * arg_7_2)
end

HeroViewStateKeepDecorations._set_color_values = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	arg_8_1[1] = arg_8_2 or arg_8_1[1]
	arg_8_1[2] = arg_8_3 or arg_8_1[2]
	arg_8_1[3] = arg_8_4 or arg_8_1[3]
	arg_8_1[4] = arg_8_5 or arg_8_1[4]
end

HeroViewStateKeepDecorations.transitioning = function (arg_9_0)
	if arg_9_0.exiting then
		return true
	else
		return false
	end
end

HeroViewStateKeepDecorations._wanted_state = function (arg_10_0)
	return (arg_10_0.parent:wanted_state())
end

HeroViewStateKeepDecorations.wanted_menu_state = function (arg_11_0)
	return arg_11_0._wanted_menu_state
end

HeroViewStateKeepDecorations.clear_wanted_menu_state = function (arg_12_0)
	arg_12_0._wanted_menu_state = nil
end

HeroViewStateKeepDecorations._update_transition_timer = function (arg_13_0, arg_13_1)
	if not arg_13_0._transition_timer then
		return
	end

	if arg_13_0._transition_timer == 0 then
		arg_13_0._transition_timer = nil
	else
		arg_13_0._transition_timer = math.max(arg_13_0._transition_timer - arg_13_1, 0)
	end
end

HeroViewStateKeepDecorations.input_service = function (arg_14_0)
	return arg_14_0.parent:input_service()
end

HeroViewStateKeepDecorations._is_list_hovered = function (arg_15_0)
	return arg_15_0._widgets_by_name.list_mask.content.hotspot.is_hover or false
end

HeroViewStateKeepDecorations.update = function (arg_16_0, arg_16_1, arg_16_2)
	arg_16_0:_handle_gamepad_activity()

	if var_0_8 then
		var_0_8 = false

		arg_16_0:_create_ui_elements()
	end

	local var_16_0 = arg_16_0._input_blocked and FAKE_INPUT_SERVICE or arg_16_0:input_service()

	if arg_16_0._type == "painting" then
		arg_16_0:_update_client_paintings(arg_16_1)
	end

	arg_16_0:_update_sound_trigger_delay(arg_16_1)
	arg_16_0:_update_scroll_position()
	arg_16_0:draw(var_16_0, arg_16_1)
	arg_16_0:_update_transition_timer(arg_16_1)

	local var_16_1 = arg_16_0.parent:transitioning()
	local var_16_2 = arg_16_0:_wanted_state()

	if not arg_16_0._transition_timer then
		if not var_16_1 then
			if arg_16_0:_has_active_level_vote() then
				local var_16_3 = true

				arg_16_0:close_menu(var_16_3)
			else
				arg_16_0:_handle_input(arg_16_1, arg_16_2)
			end
		end

		if var_16_2 or arg_16_0._new_state then
			arg_16_0.parent:clear_wanted_state()

			return var_16_2 or arg_16_0._new_state
		end
	end
end

HeroViewStateKeepDecorations._update_client_paintings = function (arg_17_0, arg_17_1)
	if not Unit.alive(arg_17_0._interactable_unit) or not arg_17_0._keep_decoration_extension or not arg_17_0._keep_decoration_extension.get_selected_decoration then
		return
	end

	if arg_17_0._is_server then
		if arg_17_0._keep_decoration_extension:get_selected_decoration() == "hidden" then
			arg_17_0:close_menu()
		end
	else
		local var_17_0 = arg_17_0._keep_decoration_extension:get_selected_decoration()

		if var_17_0 ~= arg_17_0._selected_decoration then
			arg_17_0:_set_info_by_decoration_key(var_17_0, false)
		end
	end
end

HeroViewStateKeepDecorations._has_active_level_vote = function (arg_18_0)
	local var_18_0 = arg_18_0._voting_manager

	return var_18_0:vote_in_progress() and var_18_0:is_mission_vote() and not var_18_0:has_voted(Network.peer_id())
end

HeroViewStateKeepDecorations.post_update = function (arg_19_0, arg_19_1, arg_19_2)
	arg_19_0.ui_animator:update(arg_19_1)
	arg_19_0:_update_animations(arg_19_1)
end

HeroViewStateKeepDecorations._update_animations = function (arg_20_0, arg_20_1)
	for iter_20_0, iter_20_1 in pairs(arg_20_0._ui_animations) do
		UIAnimation.update(iter_20_1, arg_20_1)

		if UIAnimation.completed(iter_20_1) then
			arg_20_0._ui_animations[iter_20_0] = nil
		end
	end

	local var_20_0 = arg_20_0._animations
	local var_20_1 = arg_20_0.ui_animator

	for iter_20_2, iter_20_3 in pairs(var_20_0) do
		if var_20_1:is_animation_completed(iter_20_3) then
			var_20_1:stop_animation(iter_20_3)

			var_20_0[iter_20_2] = nil
		end
	end

	local var_20_2 = arg_20_0._widgets_by_name
	local var_20_3 = var_20_2.close_button
	local var_20_4 = var_20_2.confirm_button

	UIWidgetUtils.animate_default_button(var_20_3, arg_20_1)
	UIWidgetUtils.animate_default_button(var_20_4, arg_20_1)
end

HeroViewStateKeepDecorations._is_button_hover_enter = function (arg_21_0, arg_21_1)
	local var_21_0 = arg_21_1.content

	return (var_21_0.button_hotspot or var_21_0.hotspot).on_hover_enter
end

HeroViewStateKeepDecorations._is_button_hover_exit = function (arg_22_0, arg_22_1)
	local var_22_0 = arg_22_1.content

	return (var_22_0.button_hotspot or var_22_0.hotspot).on_hover_exit
end

HeroViewStateKeepDecorations._is_button_hover = function (arg_23_0, arg_23_1)
	local var_23_0 = arg_23_1.content

	return (var_23_0.button_hotspot or var_23_0.hotspot).is_hover
end

HeroViewStateKeepDecorations._handle_input = function (arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_0._input_blocked and FAKE_INPUT_SERVICE or arg_24_0:input_service()
	local var_24_1 = Managers.input:is_device_active("mouse")
	local var_24_2 = var_24_0:get("toggle_menu")
	local var_24_3 = not var_24_1 and var_24_0:get("back")
	local var_24_4 = arg_24_0._widgets_by_name

	arg_24_0._scrollbar_logic:update(arg_24_1, arg_24_2)

	local var_24_5 = var_24_4.close_button
	local var_24_6 = var_24_4.confirm_button

	if arg_24_0:_is_button_hover_enter(var_24_5) or arg_24_0:_is_button_hover_enter(var_24_6) then
		arg_24_0:_play_sound("Play_hud_hover")
	end

	if arg_24_0._customizable_decoration then
		local var_24_7 = arg_24_0._interactable_unit

		if arg_24_0:_is_button_pressed(var_24_6) or var_24_0:get("confirm") then
			local var_24_8 = ScriptUnit.extension(var_24_7, "keep_decoration_system")

			if arg_24_0._selected_equipped_decoration then
				var_24_8:unequip_decoration()

				arg_24_0._selected_equipped_decoration = false

				arg_24_0:_update_confirm_button()
				arg_24_0:_update_equipped_widget()
				arg_24_0._menu_input_description:set_input_description(var_0_7.default)
				arg_24_0:_play_sound("Play_hud_select")
			else
				arg_24_0:_verify_decoration_selection()
				var_24_8:confirm_selection()
				arg_24_0:_play_sound("hud_add_painting")

				arg_24_0._selected_equipped_decoration = true

				arg_24_0:_update_confirm_button()
				arg_24_0:_update_equipped_widget()
				arg_24_0._menu_input_description:set_input_description(var_0_7.remove)
			end
		end

		local var_24_9 = false

		if not var_24_1 then
			var_24_9 = true

			arg_24_0:_handle_gamepad_list_selection(var_24_0)
		else
			var_24_9 = arg_24_0:_is_list_hovered()

			local var_24_10 = arg_24_0._list_widgets

			if var_24_10 and var_24_9 then
				for iter_24_0, iter_24_1 in ipairs(var_24_10) do
					if arg_24_0:_is_button_hover_enter(iter_24_1) then
						arg_24_0:_play_sound("play_gui_equipment_button_hover")
					end
				end
			end

			local var_24_11 = arg_24_0:_list_index_pressed()

			if var_24_11 and var_24_11 ~= arg_24_0._selected_list_index then
				arg_24_0:_on_list_index_selected(var_24_11)
				arg_24_0:_play_sound("Play_hud_select")
			end
		end

		arg_24_0:_animate_list_entries(arg_24_1, var_24_9)
	end

	if var_24_2 or arg_24_0:_is_button_pressed(var_24_5) or var_24_3 then
		arg_24_0:_play_sound("Play_hud_select")
		arg_24_0:close_menu()

		return
	end
end

HeroViewStateKeepDecorations._verify_decoration_selection = function (arg_25_0)
	local var_25_0 = ScriptUnit.extension(arg_25_0._interactable_unit, "keep_decoration_system")
	local var_25_1 = var_25_0:get_selected_decoration()

	if not table.find(arg_25_0._default_decorations, var_25_1) then
		return
	end

	local var_25_2 = arg_25_0._selected_list_index
	local var_25_3 = arg_25_0._list_widgets

	if not var_25_2 or var_25_2 > #var_25_3 then
		return
	end

	local var_25_4 = var_25_3[var_25_2].content
	local var_25_5 = var_25_4.key

	if var_25_4.locked then
		return
	else
		var_25_0:decoration_selected(var_25_5)
	end
end

HeroViewStateKeepDecorations.close_menu = function (arg_26_0, arg_26_1)
	arg_26_1 = true

	arg_26_0.parent:close_menu(nil, arg_26_1)
end

HeroViewStateKeepDecorations.draw = function (arg_27_0, arg_27_1, arg_27_2)
	arg_27_0:_update_visible_list_entries()

	local var_27_0 = arg_27_0._ui_renderer
	local var_27_1 = arg_27_0._ui_top_renderer
	local var_27_2 = arg_27_0._ui_scenegraph
	local var_27_3 = arg_27_0._input_manager
	local var_27_4 = arg_27_0._render_settings
	local var_27_5 = var_27_3:is_device_active("gamepad")

	UIRenderer.begin_pass(var_27_0, var_27_2, arg_27_1, arg_27_2, nil, var_27_4)

	local var_27_6 = var_27_4.snap_pixel_positions
	local var_27_7 = var_27_4.alpha_multiplier or 1
	local var_27_8 = arg_27_0._list_widgets

	if var_27_8 then
		for iter_27_0, iter_27_1 in ipairs(var_27_8) do
			UIRenderer.draw_widget(var_27_0, iter_27_1)
		end
	end

	local var_27_9 = arg_27_0._dummy_list_widgets

	if var_27_9 then
		for iter_27_2, iter_27_3 in ipairs(var_27_9) do
			UIRenderer.draw_widget(var_27_0, iter_27_3)
		end
	end

	for iter_27_4, iter_27_5 in ipairs(arg_27_0._widgets) do
		if iter_27_5.snap_pixel_positions ~= nil then
			var_27_4.snap_pixel_positions = iter_27_5.snap_pixel_positions
		end

		var_27_4.alpha_multiplier = iter_27_5.alpha_multiplier or var_27_7

		UIRenderer.draw_widget(var_27_0, iter_27_5)

		var_27_4.snap_pixel_positions = var_27_6
	end

	UIRenderer.end_pass(var_27_0)

	var_27_4.alpha_multiplier = var_27_7

	if var_27_5 then
		arg_27_0._menu_input_description:draw(var_27_1, arg_27_2)
	end
end

HeroViewStateKeepDecorations._is_button_pressed = function (arg_28_0, arg_28_1)
	local var_28_0 = arg_28_1.content
	local var_28_1 = var_28_0.button_hotspot or var_28_0.hotspot

	if var_28_1.on_release then
		var_28_1.on_release = false

		return true
	end
end

HeroViewStateKeepDecorations._play_sound = function (arg_29_0, arg_29_1)
	arg_29_0.parent:play_sound(arg_29_1)
end

HeroViewStateKeepDecorations._start_transition_animation = function (arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = {
		wwise_world = arg_30_0._wwise_world,
		render_settings = arg_30_0._render_settings
	}
	local var_30_1 = {}
	local var_30_2 = arg_30_0.ui_animator:start_animation(arg_30_2, var_30_1, var_0_2, var_30_0)

	arg_30_0._animations[arg_30_1] = var_30_2
end

HeroViewStateKeepDecorations.set_fullscreen_effect_enable_state = function (arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0._ui_renderer.world
	local var_31_1 = World.get_data(var_31_0, "shading_environment")

	if var_31_1 then
		ShadingEnvironment.set_scalar(var_31_1, "fullscreen_blur_enabled", arg_31_1 and 1 or 0)
		ShadingEnvironment.set_scalar(var_31_1, "fullscreen_blur_amount", arg_31_1 and 0.75 or 0)
		ShadingEnvironment.apply(var_31_1)
	end

	arg_31_0._fullscreen_effect_enabled = arg_31_1
end

HeroViewStateKeepDecorations.block_input = function (arg_32_0)
	arg_32_0._input_blocked = true
end

HeroViewStateKeepDecorations.unblock_input = function (arg_33_0)
	arg_33_0._input_blocked = false
end

HeroViewStateKeepDecorations.input_blocked = function (arg_34_0)
	return arg_34_0._input_blocked
end

HeroViewStateKeepDecorations._set_info_by_decoration_key = function (arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = arg_35_0._main_table[arg_35_1]
	local var_35_1 = var_35_0.display_name
	local var_35_2 = var_35_0.description
	local var_35_3 = var_35_0.artist
	local var_35_4 = arg_35_2 and Localize("interaction_unavailable") or Localize(var_35_2)
	local var_35_5 = var_35_3 and not arg_35_2 and Localize(var_35_3) or ""

	arg_35_0._selected_decoration = arg_35_1

	arg_35_0:_set_info_texts(Localize(var_35_1), var_35_4, var_35_5)
	arg_35_0:_play_sound("Stop_all_keep_decorations_desc_vo")

	if not arg_35_2 then
		arg_35_0._sound_event_delay = var_35_0.sound_event and var_0_11 or nil
	end
end

HeroViewStateKeepDecorations._update_sound_trigger_delay = function (arg_36_0, arg_36_1)
	local var_36_0 = arg_36_0._sound_event_delay

	if not var_36_0 then
		return
	end

	local var_36_1 = math.max(var_36_0 - arg_36_1, 0)

	if var_36_1 == 0 then
		arg_36_0._sound_event_delay = nil

		local var_36_2 = arg_36_0._selected_list_index

		if arg_36_0._selected_decoration and var_36_2 then
			local var_36_3 = arg_36_0._list_widgets[var_36_2].content.key
			local var_36_4 = arg_36_0._main_table[var_36_3].sound_event

			if var_36_4 then
				arg_36_0:_play_sound(var_36_4)
			end
		elseif arg_36_0._sound_event then
			arg_36_0:_play_sound(arg_36_0._sound_event)
		end
	else
		arg_36_0._sound_event_delay = var_36_1
	end
end

HeroViewStateKeepDecorations._update_confirm_button = function (arg_37_0)
	local var_37_0 = arg_37_0._selected_equipped_decoration == true
	local var_37_1 = arg_37_0._widgets_by_name.confirm_button

	if var_37_0 then
		var_37_1.content.title_text = Localize("input_description_remove")
	else
		var_37_1.content.title_text = Localize("menu_settings_apply")
	end
end

HeroViewStateKeepDecorations._on_list_index_selected = function (arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = arg_38_0._interactable_unit
	local var_38_1 = ScriptUnit.extension(var_38_0, "keep_decoration_system")
	local var_38_2 = var_38_1:get_selected_decoration()
	local var_38_3 = arg_38_0._list_widgets

	if not arg_38_1 or arg_38_1 > #var_38_3 then
		return
	end

	local var_38_4 = var_38_3[arg_38_1].content
	local var_38_5 = var_38_4.key

	if ItemHelper.is_new_keep_decoration_id(var_38_5) then
		ItemHelper.unmark_keep_decoration_as_new(var_38_5)

		var_38_4.new = false
	end

	local var_38_6 = var_38_4.locked

	arg_38_0:_set_info_by_decoration_key(var_38_5, var_38_6)

	if var_38_6 then
		var_38_1:decoration_selected(arg_38_0._empty_decoration_name)
	else
		var_38_1:decoration_selected(var_38_5)
	end

	arg_38_0._selected_equipped_decoration = var_38_2 == var_38_5

	arg_38_0:_update_confirm_button()

	local var_38_7 = arg_38_0._selected_equipped_decoration and "remove" or "default"

	arg_38_0._menu_input_description:set_input_description(var_38_7 and var_0_7[var_38_7])

	if var_38_3 then
		for iter_38_0, iter_38_1 in ipairs(var_38_3) do
			local var_38_8 = iter_38_1.content
			local var_38_9 = var_38_8.hotspot or var_38_8.button_hotspot

			if var_38_9 then
				local var_38_10 = iter_38_0 == arg_38_1

				var_38_9.is_selected = var_38_10

				if var_38_10 then
					var_38_9.on_hover_enter = true
				end
			end
		end
	end

	arg_38_0._previous_selected_list_index = arg_38_0._selected_list_index
	arg_38_0._selected_list_index = arg_38_1

	if arg_38_2 then
		local var_38_11 = arg_38_0._widgets_by_name.list_scrollbar.content.scroll_bar_info
		local var_38_12 = UIAnimation.function_by_time
		local var_38_13 = var_38_11
		local var_38_14 = "scroll_value"
		local var_38_15 = var_38_11.scroll_value
		local var_38_16 = arg_38_2
		local var_38_17 = 0.3
		local var_38_18 = math.easeOutCubic

		arg_38_0._ui_animations.scrollbar = UIAnimation.init(var_38_12, var_38_13, var_38_14, var_38_15, var_38_16, var_38_17, var_38_18)
	else
		arg_38_0._ui_animations.scrollbar = nil
	end
end

HeroViewStateKeepDecorations._update_scrollbar_progress_animation = function (arg_39_0, arg_39_1, arg_39_2)
	local var_39_0 = arg_39_0._chest_zoom_in_duration

	if not var_39_0 then
		return
	end

	local var_39_1 = var_39_0 + arg_39_1
	local var_39_2 = math.min(var_39_1 / CHEST_PRESENTATION_ZOOM_IN_TIME, 1)
	local var_39_3 = math.easeOutCubic(var_39_2)

	arg_39_0:set_camera_zoom(var_39_3)
	arg_39_0:set_grid_animation_progress(var_39_3)
	arg_39_0:set_chest_title_alpha_progress(1 - var_39_3)

	if var_39_2 == 1 then
		arg_39_0._chest_zoom_in_duration = nil
		arg_39_0._chest_open_wait_duration = 0
	else
		arg_39_0._chest_zoom_in_duration = var_39_1
	end
end

HeroViewStateKeepDecorations._set_info_texts = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	local var_40_0 = arg_40_0:_set_selected_title(arg_40_1)
	local var_40_1 = arg_40_0:_set_selected_description(arg_40_2)
	local var_40_2 = arg_40_3 and arg_40_0:_set_selected_artist(arg_40_3) or 0
	local var_40_3 = arg_40_0._ui_scenegraph

	var_40_3.title_text.size[2] = var_40_0
	var_40_3.artist_text.size[2] = var_40_2

	local var_40_4 = var_40_3.info_window
	local var_40_5 = var_40_4.position
	local var_40_6 = var_40_4.size[2] - var_40_0 - var_40_2 - 110

	var_40_3.description_text.size[2] = var_40_6
end

HeroViewStateKeepDecorations._set_selected_title = function (arg_41_0, arg_41_1)
	local var_41_0 = arg_41_0._widgets_by_name.title_text

	var_41_0.content.text = arg_41_1

	local var_41_1 = var_41_0.scenegraph_id
	local var_41_2 = var_41_0.style.text
	local var_41_3 = var_0_2[var_41_1].size

	return (UIUtils.get_text_height(arg_41_0._ui_renderer, var_41_3, var_41_2, arg_41_1))
end

HeroViewStateKeepDecorations._set_selected_description = function (arg_42_0, arg_42_1)
	local var_42_0 = arg_42_0._widgets_by_name.description_text

	var_42_0.content.text = arg_42_1

	local var_42_1 = var_42_0.scenegraph_id
	local var_42_2 = var_42_0.style.text
	local var_42_3 = var_0_2[var_42_1].size

	return (UIUtils.get_text_height(arg_42_0._ui_renderer, var_42_3, var_42_2, arg_42_1))
end

HeroViewStateKeepDecorations._set_selected_artist = function (arg_43_0, arg_43_1)
	local var_43_0 = arg_43_0._widgets_by_name.artist_text

	var_43_0.content.text = arg_43_1

	local var_43_1 = var_43_0.scenegraph_id
	local var_43_2 = var_43_0.style.text
	local var_43_3 = var_0_2[var_43_1].size

	return (UIUtils.get_text_height(arg_43_0._ui_renderer, var_43_3, var_43_2, arg_43_1))
end

HeroViewStateKeepDecorations._update_equipped_widget = function (arg_44_0)
	local var_44_0 = arg_44_0._interactable_unit
	local var_44_1 = ScriptUnit.extension(var_44_0, "keep_decoration_system"):get_selected_decoration()
	local var_44_2 = arg_44_0._decoration_system

	for iter_44_0, iter_44_1 in pairs(arg_44_0._list_widgets) do
		local var_44_3 = iter_44_1.content.key

		iter_44_1.content.in_use = var_44_2:is_decoration_in_use(var_44_3)
		iter_44_1.content.equipped = var_44_1 == var_44_3
	end
end

HeroViewStateKeepDecorations._align_list_widgets = function (arg_45_0)
	local var_45_0 = 0
	local var_45_1 = arg_45_0._list_widgets
	local var_45_2 = arg_45_0._dummy_list_widgets
	local var_45_3 = #var_45_1 + #var_45_2

	for iter_45_0 = 1, var_45_3 do
		local var_45_4

		if iter_45_0 <= #var_45_1 then
			var_45_4 = var_45_1[iter_45_0]
		else
			var_45_4 = var_45_2[iter_45_0 - #var_45_1]
		end

		local var_45_5 = var_45_4.offset
		local var_45_6 = var_45_4.content.size

		var_45_4.default_offset = table.clone(var_45_5)

		local var_45_7 = var_45_6[2]

		var_45_5[2] = -var_45_0
		var_45_0 = var_45_0 + var_45_7

		if iter_45_0 ~= var_45_3 then
			var_45_0 = var_45_0 + var_0_9
		end
	end

	arg_45_0._total_list_height = var_45_0
end

HeroViewStateKeepDecorations._handle_gamepad_list_selection = function (arg_46_0, arg_46_1)
	local var_46_0 = arg_46_0._selected_list_index

	if not var_46_0 then
		return
	end

	local var_46_1 = #arg_46_0._list_widgets
	local var_46_2
	local var_46_3

	if arg_46_1:get("move_up_hold_continuous") then
		var_46_2 = math.max(var_46_0 - 1, 1)
		var_46_3 = math.max(var_46_2 - 3, 1)
	elseif arg_46_1:get("move_down_hold_continuous") then
		var_46_2 = math.min(var_46_0 + 1, var_46_1)
		var_46_3 = math.min(var_46_2 + 3, var_46_1)
	end

	if var_46_2 and var_46_2 ~= var_46_0 then
		local var_46_4 = arg_46_0:_get_scrollbar_percentage_by_index(var_46_3)

		arg_46_0:_on_list_index_selected(var_46_2, var_46_4)
		arg_46_0:_play_sound("Play_hud_hover")
	end
end

HeroViewStateKeepDecorations._find_closest_neighbour = function (arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = arg_47_0._list_widgets
	local var_47_1 = var_47_0[arg_47_2]
	local var_47_2 = var_47_1.content.size
	local var_47_3 = var_47_1.offset
	local var_47_4 = var_47_2[1] * 0.5 + var_47_3[1]
	local var_47_5 = math.huge
	local var_47_6

	for iter_47_0, iter_47_1 in pairs(arg_47_1) do
		local var_47_7 = var_47_0[iter_47_1]
		local var_47_8 = var_47_7.offset
		local var_47_9 = var_47_7.content.size[1] * 0.5 + var_47_8[1]
		local var_47_10 = math.abs(var_47_9 - var_47_4)

		if var_47_10 < var_47_5 then
			var_47_5 = var_47_10
			var_47_6 = iter_47_1
		end
	end

	if var_47_6 then
		return var_47_6
	end
end

HeroViewStateKeepDecorations._initialize_scrollbar = function (arg_48_0)
	local var_48_0 = var_0_2.list_window.size
	local var_48_1 = var_0_2.list_scrollbar.size
	local var_48_2 = var_48_0[2]
	local var_48_3 = arg_48_0._total_list_height
	local var_48_4 = var_48_1[2]
	local var_48_5 = 220 + var_0_9 * 1.5
	local var_48_6 = 1
	local var_48_7 = arg_48_0._scrollbar_logic

	var_48_7:set_scrollbar_values(var_48_2, var_48_3, var_48_4, var_48_5, var_48_6)
	var_48_7:set_scroll_percentage(0)
end

HeroViewStateKeepDecorations._update_scroll_position = function (arg_49_0)
	local var_49_0 = arg_49_0._scrollbar_logic:get_scrolled_length()

	if var_49_0 ~= arg_49_0._scrolled_length then
		arg_49_0._ui_scenegraph.list_scroll_root.local_position[2] = math.round(var_49_0)
		arg_49_0._scrolled_length = var_49_0
	end
end

HeroViewStateKeepDecorations._update_visible_list_entries = function (arg_50_0)
	local var_50_0 = arg_50_0._scrollbar_logic

	if not var_50_0:enabled() then
		return
	end

	local var_50_1 = var_50_0:get_scroll_percentage()
	local var_50_2 = var_50_0:get_scrolled_length()
	local var_50_3 = var_50_0:get_scroll_length()
	local var_50_4 = var_0_2.list_window.size
	local var_50_5 = var_0_9 * 2
	local var_50_6 = var_50_4[2] + var_50_5
	local var_50_7 = arg_50_0._list_widgets
	local var_50_8 = #var_50_7

	for iter_50_0, iter_50_1 in ipairs(var_50_7) do
		local var_50_9 = iter_50_1.offset
		local var_50_10 = iter_50_1.content
		local var_50_11 = var_50_10.size
		local var_50_12 = math.abs(var_50_9[2]) + var_50_11[2]
		local var_50_13 = false

		if var_50_12 < var_50_2 - var_50_5 then
			var_50_13 = true
		elseif var_50_6 < math.abs(var_50_9[2]) - var_50_2 then
			var_50_13 = true
		end

		var_50_10.visible = not var_50_13
	end
end

HeroViewStateKeepDecorations._get_scrollbar_percentage_by_index = function (arg_51_0, arg_51_1)
	local var_51_0 = arg_51_0._scrollbar_logic

	if var_51_0:enabled() then
		local var_51_1 = var_51_0:get_scroll_percentage()
		local var_51_2 = var_51_0:get_scrolled_length()
		local var_51_3 = var_51_0:get_scroll_length()
		local var_51_4 = var_0_2.list_window.size[2]
		local var_51_5 = var_51_2
		local var_51_6 = var_51_5 + var_51_4
		local var_51_7 = arg_51_0._list_widgets

		if var_51_7 then
			local var_51_8 = var_51_7[arg_51_1]
			local var_51_9 = var_51_8.content
			local var_51_10 = var_51_8.offset
			local var_51_11 = var_51_9.size[2]
			local var_51_12 = math.abs(var_51_10[2])
			local var_51_13 = var_51_12 + var_51_11
			local var_51_14 = 0

			if var_51_6 < var_51_13 then
				local var_51_15 = var_51_13 - var_51_6

				var_51_14 = math.clamp(var_51_15 / var_51_3, 0, 1)
			elseif var_51_12 < var_51_5 then
				local var_51_16 = var_51_5 - var_51_12

				var_51_14 = -math.clamp(var_51_16 / var_51_3, 0, 1)
			end

			if var_51_14 then
				return (math.clamp(var_51_1 + var_51_14, 0, 1))
			end
		end
	end

	return 0
end

HeroViewStateKeepDecorations._list_index_pressed = function (arg_52_0)
	local var_52_0 = arg_52_0._list_widgets

	if var_52_0 then
		for iter_52_0, iter_52_1 in ipairs(var_52_0) do
			local var_52_1 = iter_52_1.content
			local var_52_2 = var_52_1.hotspot or var_52_1.button_hotspot

			if var_52_2 and var_52_2.on_release then
				var_52_2.on_release = false

				return iter_52_0
			end
		end
	end
end

HeroViewStateKeepDecorations._setup_decorations_list = function (arg_53_0)
	local var_53_0 = arg_53_0._keep_decoration_backend_interface
	local var_53_1 = var_53_0 and var_53_0:get_unlocked_keep_decorations() or {}
	local var_53_2 = {}
	local var_53_3 = 0

	for iter_53_0, iter_53_1 in ipairs(arg_53_0._ordered_table) do
		if not table.contains(arg_53_0._default_table, iter_53_1) then
			local var_53_4 = arg_53_0._main_table[iter_53_1]

			if var_53_4 then
				local var_53_5 = table.contains(var_53_1, iter_53_1)
				local var_53_6 = Localize(var_53_4.display_name)
				local var_53_7 = ItemHelper.is_new_keep_decoration_id(iter_53_1)

				if var_53_5 then
					local var_53_8 = UIWidget.init(var_0_5)

					var_53_3 = var_53_3 + 1
					var_53_2[var_53_3] = var_53_8

					local var_53_9 = var_53_8.content
					local var_53_10 = var_53_8.style
					local var_53_11 = var_53_6
					local var_53_12 = var_53_10.title
					local var_53_13 = var_53_12.size[1] - 10

					var_53_9.title = UIRenderer.crop_text_width(arg_53_0._ui_renderer, var_53_11, var_53_13, var_53_12)
					var_53_9.key = iter_53_1
					var_53_9.locked = false
					var_53_9.new = var_53_7
					var_53_9.in_use = arg_53_0._decoration_system:is_decoration_in_use(iter_53_1)
				end
			end
		end
	end

	table.sort(var_53_2, function (arg_54_0, arg_54_1)
		local var_54_0 = arg_54_0.content
		local var_54_1 = arg_54_1.content

		if var_54_0.new ~= var_54_1.new then
			return var_54_0.new
		end

		return Localize(var_54_0.title) < Localize(var_54_1.title)
	end)

	arg_53_0._list_widgets = var_53_2
	arg_53_0._dummy_list_widgets = {}

	arg_53_0:_align_list_widgets()

	local var_53_14 = arg_53_0._total_list_height
	local var_53_15 = var_0_2.list_scrollbar.size[2]
	local var_53_16 = {}

	if var_53_14 < var_53_15 then
		local var_53_17 = 0
		local var_53_18 = var_0_9

		while var_53_15 > var_53_14 + var_53_18 do
			var_53_17 = var_53_17 + 1

			local var_53_19 = UIWidget.init(var_0_6)

			table.insert(var_53_16, var_53_19)

			var_53_18 = var_53_18 + var_53_19.content.size[2] + var_0_9
		end
	end

	arg_53_0._dummy_list_widgets = var_53_16

	arg_53_0:_align_list_widgets()
	arg_53_0:_initialize_scrollbar()
	arg_53_0:_update_equipped_widget()
end

HeroViewStateKeepDecorations._animate_list_entries = function (arg_55_0, arg_55_1, arg_55_2)
	local var_55_0 = arg_55_0._list_widgets

	if not var_55_0 then
		return
	end

	for iter_55_0, iter_55_1 in ipairs(var_55_0) do
		arg_55_0:_animate_list_widget(iter_55_1, arg_55_1, arg_55_2)
	end
end

HeroViewStateKeepDecorations._animate_list_widget = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3)
	local var_56_0 = arg_56_1.offset
	local var_56_1 = arg_56_1.content
	local var_56_2 = arg_56_1.style
	local var_56_3 = var_56_1.button_hotspot or var_56_1.hotspot
	local var_56_4 = var_56_3.on_hover_enter
	local var_56_5 = var_56_3.is_hover

	if arg_56_3 ~= nil and not arg_56_3 then
		var_56_5 = false
		var_56_4 = false
	end

	local var_56_6 = var_56_3.is_selected
	local var_56_7 = not var_56_6 and var_56_3.is_clicked and var_56_3.is_clicked == 0
	local var_56_8 = var_56_3.input_progress or 0
	local var_56_9 = var_56_3.hover_progress or 0
	local var_56_10 = var_56_3.pulse_progress or 1
	local var_56_11 = var_56_3.offset_progress or 1
	local var_56_12 = var_56_3.selection_progress or 0
	local var_56_13 = (var_56_5 or var_56_6) and 14 or 3
	local var_56_14 = 3
	local var_56_15 = 20
	local var_56_16 = 5

	if var_56_7 then
		var_56_8 = math.min(var_56_8 + arg_56_2 * var_56_15, 1)
	else
		var_56_8 = math.max(var_56_8 - arg_56_2 * var_56_15, 0)
	end

	local var_56_17 = math.easeOutCubic(var_56_8)
	local var_56_18 = math.easeInCubic(var_56_8)

	if var_56_4 then
		var_56_10 = 0
	end

	local var_56_19 = math.min(var_56_10 + arg_56_2 * var_56_14, 1)
	local var_56_20 = math.easeOutCubic(var_56_19)
	local var_56_21 = math.easeInCubic(var_56_19)

	if var_56_5 then
		var_56_9 = math.min(var_56_9 + arg_56_2 * var_56_13, 1)
	else
		var_56_9 = math.max(var_56_9 - arg_56_2 * var_56_13, 0)
	end

	local var_56_22 = math.easeOutCubic(var_56_9)
	local var_56_23 = math.easeInCubic(var_56_9)

	if var_56_6 then
		var_56_12 = math.min(var_56_12 + arg_56_2 * var_56_13, 1)
		var_56_11 = math.min(var_56_11 + arg_56_2 * var_56_16, 1)
	else
		var_56_12 = math.max(var_56_12 - arg_56_2 * var_56_13, 0)
		var_56_11 = math.max(var_56_11 - arg_56_2 * var_56_16, 0)
	end

	local var_56_24 = math.easeOutCubic(var_56_12)
	local var_56_25 = math.easeInCubic(var_56_12)
	local var_56_26 = math.max(var_56_9, var_56_12)
	local var_56_27 = math.max(var_56_24, var_56_22)
	local var_56_28 = math.max(var_56_23, var_56_25)
	local var_56_29 = 255 * var_56_26

	var_56_2.hover_frame.color[1] = var_56_29

	local var_56_30 = var_56_2.title
	local var_56_31 = var_56_30.text_color
	local var_56_32 = var_56_30.default_text_color
	local var_56_33 = var_56_30.hover_text_color

	Colors.lerp_color_tables(var_56_32, var_56_33, var_56_26, var_56_31)

	local var_56_34 = 255 - 255 * var_56_19

	var_56_2.pulse_frame.color[1] = var_56_34
	var_56_0[1] = 10 * math.ease_in_exp(var_56_11)
	var_56_3.offset_progress = var_56_11
	var_56_3.pulse_progress = var_56_19
	var_56_3.hover_progress = var_56_9
	var_56_3.input_progress = var_56_8
	var_56_3.selection_progress = var_56_12
end

HeroViewStateKeepDecorations._handle_gamepad_activity = function (arg_57_0)
	local var_57_0 = Managers.input:is_device_active("mouse")
	local var_57_1 = arg_57_0._gamepad_active_last_frame == nil

	if not var_57_0 then
		if not arg_57_0._gamepad_active_last_frame or var_57_1 then
			arg_57_0._gamepad_active_last_frame = true

			if arg_57_0._customizable_decoration then
				local var_57_2 = arg_57_0._selected_list_index

				if var_57_2 then
					local var_57_3 = arg_57_0:_get_scrollbar_percentage_by_index(var_57_2)

					arg_57_0._scrollbar_logic:set_scroll_percentage(var_57_3)
				end
			end
		end
	elseif arg_57_0._gamepad_active_last_frame or var_57_1 then
		arg_57_0._gamepad_active_last_frame = false
	end
end
