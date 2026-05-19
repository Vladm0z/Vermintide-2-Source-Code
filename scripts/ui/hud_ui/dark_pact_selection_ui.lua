-- chunkname: @scripts/ui/hud_ui/dark_pact_selection_ui.lua

require("scripts/ui/views/versus_menu/ui_widgets_vs")
require("scripts/ui/hud_ui/base_component")

local var_0_0 = local_require("scripts/ui/hud_ui/dark_pact_selection_ui_definitions")
local var_0_1 = var_0_0.ordered_pactsworn_slots
local var_0_2 = var_0_0.create_selection_widget
local var_0_3 = var_0_0.scenegraph_definition
local var_0_4 = 148
local var_0_5 = 148

DarkPactSelectionUI = class(DarkPactSelectionUI, BaseComponent)
DarkPactSelectionUI._input_service_name = "dark_pact_selection"
DarkPactSelectionUI._input_methods = {
	"keyboard",
	"mouse",
	"gamepad"
}

local var_0_6 = {
	disabler = "Disabler",
	all = "Pactsworn",
	area_damage = "Area Damage"
}

function DarkPactSelectionUI.init(arg_1_0, arg_1_1, arg_1_2)
	DarkPactSelectionUI.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_0)

	arg_1_0._player = arg_1_2.player
	arg_1_0._peer_id = arg_1_2.peer_id
	arg_1_0._local_player_id = arg_1_2.local_player_id
	arg_1_0._profile_requester = (arg_1_2.network_server or arg_1_2.network_client):profile_requester()
	arg_1_0._profile_synchronizer = arg_1_2.profile_synchronizer
	arg_1_0._ingame_ui = arg_1_2.ingame_ui
	arg_1_0._game_mode = Managers.state.game_mode:game_mode()
	arg_1_0._party = Managers.party:get_local_player_party()

	local var_1_0 = arg_1_2.world

	arg_1_0._wwise_world = Managers.world:wwise_world(arg_1_0._world)
	arg_1_0._ui_animator = UIAnimator:new(arg_1_0._ui_scenegraph, var_0_0.animation_definitions)
	arg_1_0._current_anim_id = 0
	arg_1_0._selected_index = 0
	arg_1_0._input_captured = false
	arg_1_0._pending_profile = false

	arg_1_0:_hide(100)

	local var_1_1 = arg_1_0._input_manager
	local var_1_2 = arg_1_0._input_service_name

	var_1_1:create_input_service(var_1_2, "DarkPactSelectionUIKeymaps", "DarkPactSelectionUIFilters")
	var_1_1:map_device_to_service(var_1_2, "keyboard")
	var_1_1:map_device_to_service(var_1_2, "mouse")
	var_1_1:map_device_to_service(var_1_2, "gamepad")
	Managers.state.event:register(arg_1_0, "add_respawn_counter_event", "event_add_respawn_counter_event")
	Managers.state.event:register(arg_1_0, "set_new_enemy_role", "event_set_new_enemy_role")
	Managers.state.event:register(arg_1_0, "versus_received_selectable_careers_response", "event_versus_received_selectable_careers_response")
end

function DarkPactSelectionUI.event_add_respawn_counter_event(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	if arg_2_0._player == arg_2_1 then
		if arg_2_4 then
			arg_2_0:_show()
		else
			arg_2_0:_hide()
		end
	end
end

function DarkPactSelectionUI.destroy(arg_3_0)
	Managers.state.event:unregister("add_respawn_counter_event", arg_3_0)
	Managers.state.event:unregister("set_new_enemy_role", arg_3_0)
	Managers.state.event:unregister("versus_received_selectable_careers_response", arg_3_0)
	arg_3_0:_release_input()
	DarkPactSelectionUI.super.destroy(arg_3_0)
end

function DarkPactSelectionUI._capture_input(arg_4_0)
	if arg_4_0._input_captured then
		return
	end

	arg_4_0._input_manager:capture_input(arg_4_0._input_methods, 1, arg_4_0._input_service_name, "DarkPactSelectionUI")
	ShowCursorStack.show("DarkPactSelectionUI")

	arg_4_0._input_captured = true
end

function DarkPactSelectionUI._release_input(arg_5_0)
	if not arg_5_0._input_captured then
		return
	end

	if IS_WINDOWS and not Window.has_focus() then
		Window.set_focus()
	end

	arg_5_0._input_manager:release_input(arg_5_0._input_methods, 1, arg_5_0._input_service_name, "DarkPactSelectionUI")
	arg_5_0._input_manager:device_unblock_service("keyboard", 1, arg_5_0._input_service_name)

	local var_5_0 = arg_5_0:input_service()

	if var_5_0 then
		var_5_0:set_input_blocked("next_observer_target", false, "DarkPactSelectionUI")
		var_5_0:set_input_blocked("previous_observer_target", false, "DarkPactSelectionUI")
	end

	ShowCursorStack.hide("DarkPactSelectionUI")

	arg_5_0._input_captured = false
end

function DarkPactSelectionUI._update_occupied_by_role(arg_6_0, arg_6_1)
	if not arg_6_0._game_mode.get_num_occupied_profile_enemy_role then
		return
	end

	local var_6_0 = arg_6_0._game_mode:get_num_occupied_profile_enemy_role(arg_6_0._profile_synchronizer, arg_6_0._party, arg_6_1)
	local var_6_1 = GameModeSettings.versus.dark_pact_profile_rules[arg_6_1]
	local var_6_2 = arg_6_0._widgets_by_name.chrome
	local var_6_3 = var_6_2.content
	local var_6_4
	local var_6_5

	if var_6_0 < var_6_1 then
		var_6_4, var_6_5 = "vs_ui_dark_pact_selection_available", var_6_3.color_available
	else
		var_6_4, var_6_5 = "vs_ui_dark_pact_selection_full", var_6_3.color_disabled
	end

	local var_6_6 = arg_6_1 .. "_text"

	var_6_3[var_6_6] = string.format("%i/%i %s", var_6_0, var_6_1, Localize(var_6_4))
	var_6_2.style[var_6_6].text_color = var_6_5
end

function DarkPactSelectionUI._play_anim(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0._ui_animator:stop_animation(arg_7_0._current_anim_id)

	arg_7_0._current_anim_id = arg_7_0._ui_animator:start_animation(arg_7_1, arg_7_0._widgets_by_name, arg_7_0._definitions.scenegraph_definition, arg_7_0, arg_7_2)
end

function DarkPactSelectionUI._set_button(arg_8_0, arg_8_1, arg_8_2)
	arg_8_1.style.profile_texture.saturated = not arg_8_2
	arg_8_1.content.hotspot.disabled = not arg_8_2
end

function DarkPactSelectionUI._can_switch_profile(arg_9_0)
	local var_9_0 = arg_9_0._peer_id
	local var_9_1 = arg_9_0._local_player_id

	if Managers.party:get_player_status(var_9_0, var_9_1) then
		local var_9_2 = arg_9_0._player
		local var_9_3 = var_9_2 and var_9_2.player_unit
		local var_9_4 = ScriptUnit.has_extension(var_9_3, "ghost_mode_system")

		if var_9_4 then
			local var_9_5, var_9_6 = var_9_4:is_in_ghost_mode()

			return var_9_5 and not var_9_6
		else
			return true
		end
	end

	return false
end

function DarkPactSelectionUI._show(arg_10_0, arg_10_1)
	if arg_10_0._is_visible == true then
		return
	end

	arg_10_0._show_play_speed = arg_10_1

	arg_10_0:_request_careers()
	WwiseWorld.trigger_event(arg_10_0._wwise_world, "Play_versus_pactsworn_select_start")
end

function DarkPactSelectionUI._hide(arg_11_0, arg_11_1)
	if arg_11_0._is_visible == false then
		return
	end

	arg_11_0:_play_anim("on_exit", arg_11_1)

	arg_11_0._is_visible = false

	local var_11_0 = arg_11_0:input_service()

	if var_11_0 then
		var_11_0:set_input_blocked("next_observer_target", false, "DarkPactSelectionUI")
		var_11_0:set_input_blocked("previous_observer_target", false, "DarkPactSelectionUI")
	end

	WwiseWorld.trigger_event(arg_11_0._wwise_world, "Stop_versus_pactsworn_select_start")
end

function DarkPactSelectionUI.update(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	if arg_12_0._requesting_careers then
		return
	end

	if RESOLUTION_LOOKUP.modified then
		arg_12_0:_set_overlay_size()
	end

	arg_12_0._ui_animator:update(arg_12_1)

	local var_12_0 = arg_12_0._profile_requester

	if arg_12_0._pending_profile then
		local var_12_1 = var_12_0:result()

		if var_12_1 == "success" then
			arg_12_0._ingame_ui:play_sound("menu_versus_pactsworn_confirmed")
			arg_12_0:_hide()

			arg_12_0._pending_profile = nil
		elseif var_12_1 == "failure" then
			local var_12_2 = arg_12_0._selector_widgets

			for iter_12_0 = 1, #var_12_2 do
				if var_12_2[iter_12_0].content.profile_name == arg_12_0._pending_profile then
					arg_12_0:_set_button(var_12_2[iter_12_0], false)

					break
				end
			end

			arg_12_0._pending_profile = nil
		end

		return
	end

	local var_12_3 = arg_12_0:input_service()

	if arg_12_0._is_visible then
		if var_12_3:get("enable_camera_movement") then
			arg_12_0._camera_movement_enabled = true

			arg_12_0:_release_input()
		elseif arg_12_0._camera_movement_enabled and not var_12_3:get("camera_movement_held") then
			arg_12_0._camera_movement_enabled = false

			arg_12_0:_capture_input()
		end
	end

	if not arg_12_0._input_captured then
		return
	end

	if not Managers.state.network or not Managers.state.network:game() then
		return
	end

	local var_12_4 = Managers.input:is_device_active("mouse")

	if arg_12_0._mouse_active ~= var_12_4 then
		if var_12_4 then
			arg_12_0:_deselect()
		else
			arg_12_0:_select(1)
		end

		arg_12_0._mouse_active = var_12_4
	end

	if var_12_4 then
		arg_12_0:_handle_mouse_input(arg_12_1, arg_12_2, var_12_3, var_12_0)
	else
		arg_12_0:_handle_gamepad_input(arg_12_1, arg_12_2, var_12_3, var_12_0)
	end
end

function DarkPactSelectionUI._handle_mouse_input(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	local var_13_0 = false
	local var_13_1 = arg_13_0._peer_id
	local var_13_2 = arg_13_0._local_player_id
	local var_13_3 = arg_13_0._selector_widgets

	for iter_13_0 = 1, #var_13_3 do
		local var_13_4 = var_13_3[iter_13_0].content
		local var_13_5 = var_13_4.hotspot
		local var_13_6 = var_13_4.profile_name

		var_13_0 = var_13_0 or var_13_5.is_hover

		if var_13_5.on_release or arg_13_3:get(var_13_4.input_key) then
			arg_13_0._ingame_ui:play_sound("menu_versus_pactsworn_select")

			var_13_5.on_release = false

			arg_13_4:request_profile(var_13_1, var_13_2, var_13_6, var_13_6, true)

			arg_13_0._pending_profile = var_13_6

			break
		elseif var_13_5.on_hover_enter then
			arg_13_0._ingame_ui:play_sound("menu_versus_pactsworn_hover")

			local var_13_7 = CareerSettings[var_13_6].display_name

			arg_13_0:_set_enemy_pick_text(var_13_7)
			arg_13_0:_set_enemy_pick_info_text(var_13_6)
			arg_13_0:_deselect()
		end
	end

	arg_13_3:set_input_blocked("next_observer_target", var_13_0, "DarkPactSelectionUI")
	arg_13_3:set_input_blocked("previous_observer_target", var_13_0, "DarkPactSelectionUI")
end

function DarkPactSelectionUI._handle_gamepad_input(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	if arg_14_3:get("move_right") then
		local var_14_0 = math.min(arg_14_0._selected_index + 1, #arg_14_0._selector_widgets)

		arg_14_0._ingame_ui:play_sound("menu_versus_pactsworn_hover")
		arg_14_0:_select(var_14_0)
	elseif arg_14_3:get("move_left") then
		local var_14_1 = math.max(arg_14_0._selected_index - 1, 1)

		arg_14_0._ingame_ui:play_sound("menu_versus_pactsworn_hover")
		arg_14_0:_select(var_14_1)
	end

	if arg_14_3:get("confirm") then
		arg_14_0:_confirm_choice(arg_14_0._selected_index, arg_14_4)
	end
end

function DarkPactSelectionUI._select(arg_15_0, arg_15_1)
	arg_15_0:_deselect()

	arg_15_0._selected_index = arg_15_1

	local var_15_0 = arg_15_0._selector_widgets[arg_15_1].content

	var_15_0.selected = true

	local var_15_1 = var_15_0.profile_name
	local var_15_2 = CareerSettings[var_15_1].display_name

	arg_15_0:_set_enemy_pick_text(var_15_2)
	arg_15_0:_set_enemy_pick_info_text(var_15_1)
end

function DarkPactSelectionUI._deselect(arg_16_0)
	local var_16_0 = arg_16_0._selector_widgets

	for iter_16_0, iter_16_1 in pairs(var_16_0) do
		iter_16_1.content.selected = false
	end

	arg_16_0._selected_index = 0
end

function DarkPactSelectionUI._confirm_choice(arg_17_0, arg_17_1, arg_17_2)
	arg_17_1 = math.clamp(arg_17_1, 1, #arg_17_0._selector_widgets)

	local var_17_0 = arg_17_0._peer_id
	local var_17_1 = arg_17_0._local_player_id
	local var_17_2 = arg_17_0._selector_widgets[arg_17_1].content

	var_17_2.selected = false

	local var_17_3 = var_17_2.profile_name

	arg_17_0._ingame_ui:play_sound("menu_versus_pactsworn_select")
	arg_17_2:request_profile(var_17_0, var_17_1, var_17_3, var_17_3, true)

	arg_17_0._pending_profile = var_17_3
end

function DarkPactSelectionUI.post_update(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	arg_18_0:_draw(arg_18_1, arg_18_0:input_service())
end

function DarkPactSelectionUI._draw(arg_19_0, arg_19_1, arg_19_2)
	arg_19_0.super._draw(arg_19_0, arg_19_1, arg_19_2)
	UIRenderer.begin_pass(arg_19_0._ui_renderer, arg_19_0._ui_scenegraph, arg_19_2, arg_19_1, nil, {})

	if arg_19_0._selector_widgets and arg_19_0._is_visible then
		UIRenderer.draw_all_widgets(arg_19_0._ui_renderer, arg_19_0._selector_widgets)
	end

	UIRenderer.end_pass(arg_19_0._ui_renderer)
end

function DarkPactSelectionUI.event_set_new_enemy_role(arg_20_0)
	return
end

function DarkPactSelectionUI._set_enemy_role_text(arg_21_0, arg_21_1)
	arg_21_0._widgets_by_name.chrome.content.category_text = string.format(Localize("vs_profile_selection_reason_unavailable"))
end

function DarkPactSelectionUI._set_enemy_pick_text(arg_22_0, arg_22_1)
	arg_22_0._widgets_by_name.chrome.content.pick_text = Utf8.upper(Localize(arg_22_1))
end

function DarkPactSelectionUI._set_enemy_pick_info_text(arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0._widgets_by_name.info_text
	local var_23_1 = CareerSettings[arg_23_1].description

	var_23_0.content.text = Localize(var_23_1)
end

function DarkPactSelectionUI._create_ui_elements(arg_24_0)
	arg_24_0.super._create_ui_elements(arg_24_0)

	arg_24_0._selector_widgets = {}
end

function DarkPactSelectionUI._request_careers(arg_25_0)
	arg_25_0._requesting_careers = true

	Managers.state.game_mode:game_mode():request_selectable_dark_pact_careers()
end

function DarkPactSelectionUI.event_versus_received_selectable_careers_response(arg_26_0, arg_26_1, arg_26_2)
	arg_26_0._requesting_careers = false

	arg_26_0:_create_selection_widgets(arg_26_1, arg_26_2)
	arg_26_0:_play_anim("on_enter", arg_26_0._show_play_speed)

	if Managers.input:is_device_active("gamepad") then
		arg_26_0:_select(1)
	end

	local var_26_0 = arg_26_0:_get_current_selected_career_name()

	arg_26_0:_set_enemy_pick_text(var_26_0)
	arg_26_0:_set_overlay_size()

	arg_26_0._is_visible = true
end

function DarkPactSelectionUI._create_selection_widgets(arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = math.floor(#arg_27_2 / 2)
	local var_27_1 = var_0_4 + 10
	local var_27_2 = -(var_27_0 * var_27_1)
	local var_27_3 = -(var_27_0 * var_27_1) - var_0_4 / 2
	local var_27_4 = #arg_27_2 % 2 == 0 and var_27_2 or var_27_3

	arg_27_0._ui_scenegraph.selection_pivot.position[1] = var_27_4

	UISceneGraph.update_scenegraph(arg_27_0._ui_scenegraph)

	local var_27_5 = {}

	for iter_27_0 = 1, #arg_27_2 do
		local var_27_6 = "selection_pivot"
		local var_27_7 = "selection_widget_" .. iter_27_0
		local var_27_8 = var_0_2(var_27_6, {
			var_0_4,
			var_0_5
		})
		local var_27_9 = UIWidget.init(var_27_8)
		local var_27_10 = arg_27_2[iter_27_0]

		var_27_9.content.profile_name = var_27_10
		var_27_9.content.profile_texture = CareerSettings[var_27_10].picking_image_square or "icons_placeholder"
		var_27_9.content.input_key = "keyboard_" .. iter_27_0
		var_27_9.offset[1] = (iter_27_0 - 1) * var_27_1
		var_27_5[#var_27_5 + 1] = var_27_9
	end

	arg_27_0:_set_enemy_role_text(arg_27_1)

	arg_27_0._selector_widgets = var_27_5
end

function DarkPactSelectionUI.input_service(arg_28_0)
	return arg_28_0._input_manager:get_service(arg_28_0._input_service_name)
end

function DarkPactSelectionUI._get_current_selected_career_name(arg_29_0)
	if not Managers then
		return "not_assigned"
	end

	if not Managers.player then
		return "not_assigned"
	end

	if not SPProfiles then
		return "not_assigned"
	end

	local var_29_0 = Managers.player:local_player()

	if not var_29_0 then
		return "not_assigned"
	end

	local var_29_1 = var_29_0:career_index()
	local var_29_2 = var_29_0:profile_index()

	if not var_29_2 or not var_29_1 then
		return "not_assigned"
	end

	return SPProfiles[var_29_2].careers[var_29_1].display_name
end

function DarkPactSelectionUI._set_overlay_size(arg_30_0)
	local var_30_0 = RESOLUTION_LOOKUP.res_w
	local var_30_1 = RESOLUTION_LOOKUP.res_h
	local var_30_2 = RESOLUTION_LOOKUP.inv_scale

	arg_30_0._widgets_by_name.overlay.style.rect.size = {
		var_30_0 * var_30_2 + 6,
		var_30_1 * var_30_2 + 6
	}
end
