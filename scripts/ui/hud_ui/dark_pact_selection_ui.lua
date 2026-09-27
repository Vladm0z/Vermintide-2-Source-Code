-- chunkname: @scripts/ui/hud_ui/dark_pact_selection_ui.lua

require("scripts/ui/views/versus_menu/ui_widgets_vs")
require("scripts/ui/hud_ui/base_component")

local var_0_0 = local_require("scripts/ui/hud_ui/dark_pact_selection_ui_definitions")
local ordered_pactsworn_slots = var_0_0.ordered_pactsworn_slots
local create_selection_widget = var_0_0.create_selection_widget
local scenegraph_definition = var_0_0.scenegraph_definition
local num = 148
local num_2 = 148

DarkPactSelectionUI = class(DarkPactSelectionUI, BaseComponent)
DarkPactSelectionUI._input_service_name = "dark_pact_selection"
DarkPactSelectionUI._input_methods = {
	"keyboard",
	"mouse",
	"gamepad"
}

local tbl = {
	disabler = "Disabler",
	all = "Pactsworn",
	area_damage = "Area Damage"
}

DarkPactSelectionUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	DarkPactSelectionUI.super.init(self, arg_1_1, arg_1_2, var_0_0)

	self._player = arg_1_2.player
	self._peer_id = arg_1_2.peer_id
	self._local_player_id = arg_1_2.local_player_id

	local network_server = arg_1_2.network_server

	network_server = network_server or arg_1_2.network_client
	self._profile_requester = network_server:profile_requester()
	self._profile_synchronizer = arg_1_2.profile_synchronizer
	self._ingame_ui = arg_1_2.ingame_ui
	self._game_mode = Managers.state.game_mode:game_mode()
	self._party = Managers.party:get_local_player_party()

	local world = arg_1_2.world

	self._wwise_world = Managers.world:wwise_world(self._world)
	self._ui_animator = UIAnimator:new(self._ui_scenegraph, var_0_0.animation_definitions)
	self._current_anim_id = 0
	self._selected_index = 0
	self._input_captured = false
	self._pending_profile = false

	self:_hide(100)

	local _input_manager = self._input_manager
	local _input_service_name = self._input_service_name

	_input_manager:create_input_service(_input_service_name, "DarkPactSelectionUIKeymaps", "DarkPactSelectionUIFilters")
	_input_manager:map_device_to_service(_input_service_name, "keyboard")
	_input_manager:map_device_to_service(_input_service_name, "mouse")
	_input_manager:map_device_to_service(_input_service_name, "gamepad")
	Managers.state.event:register(self, "add_respawn_counter_event", "event_add_respawn_counter_event")
	Managers.state.event:register(self, "set_new_enemy_role", "event_set_new_enemy_role")
	Managers.state.event:register(self, "versus_received_selectable_careers_response", "event_versus_received_selectable_careers_response")
end

DarkPactSelectionUI.event_add_respawn_counter_event = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	if self._player == arg_2_1 then
		if not arg_2_4 then
			self:_show()
		else
			self:_hide()
		end
	end
end

DarkPactSelectionUI.destroy = function (self)
	-- function 3
	Managers.state.event:unregister("add_respawn_counter_event", self)
	Managers.state.event:unregister("set_new_enemy_role", self)
	Managers.state.event:unregister("versus_received_selectable_careers_response", self)
	self:_release_input()
	DarkPactSelectionUI.super.destroy(self)
end

DarkPactSelectionUI._capture_input = function (self)
	-- function 4
	if not self._input_captured then
		return
	end

	self._input_manager:capture_input(self._input_methods, 1, self._input_service_name, "DarkPactSelectionUI")
	ShowCursorStack.show("DarkPactSelectionUI")

	self._input_captured = true
end

DarkPactSelectionUI._release_input = function (self)
	-- function 5
	if not self._input_captured then
		return
	end

	if not (not IS_WINDOWS and Window.has_focus()) then
		Window.set_focus()
	end

	self._input_manager:release_input(self._input_methods, 1, self._input_service_name, "DarkPactSelectionUI")
	self._input_manager:device_unblock_service("keyboard", 1, self._input_service_name)

	local input_service = self:input_service()

	if not input_service then
		input_service:set_input_blocked("next_observer_target", false, "DarkPactSelectionUI")
		input_service:set_input_blocked("previous_observer_target", false, "DarkPactSelectionUI")
	end

	ShowCursorStack.hide("DarkPactSelectionUI")

	self._input_captured = false
end

DarkPactSelectionUI._update_occupied_by_role = function (self, arg_6_1)
	-- function 6
	if not self._game_mode.get_num_occupied_profile_enemy_role then
		return
	end

	local get_num_occupied_profile_enemy_role = self._game_mode:get_num_occupied_profile_enemy_role(self._profile_synchronizer, self._party, arg_6_1)
	local var_6_1 = GameModeSettings.versus.dark_pact_profile_rules[arg_6_1]
	local chrome = self._widgets_by_name.chrome
	local content = chrome.content
	local var_6_4
	local var_6_5

	if get_num_occupied_profile_enemy_role < var_6_1 then
		var_6_4, var_6_5 = "vs_ui_dark_pact_selection_available", content.color_available
	else
		var_6_4, var_6_5 = "vs_ui_dark_pact_selection_full", content.color_disabled
	end

	local str = arg_6_1 .. "_text"

	content[str] = string.format("%i/%i %s", get_num_occupied_profile_enemy_role, var_6_1, Localize(var_6_4))
	chrome.style[str].text_color = var_6_5
end

DarkPactSelectionUI._play_anim = function (self, arg_7_1, arg_7_2)
	-- function 7
	self._ui_animator:stop_animation(self._current_anim_id)

	self._current_anim_id = self._ui_animator:start_animation(arg_7_1, self._widgets_by_name, self._definitions.scenegraph_definition, self, arg_7_2)
end

DarkPactSelectionUI._set_button = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	arg_8_1.style.profile_texture.saturated = not arg_8_2
	arg_8_1.content.hotspot.disabled = not arg_8_2
end

DarkPactSelectionUI._can_switch_profile = function (self)
	-- function 9
	local _peer_id = self._peer_id
	local _local_player_id = self._local_player_id

	if not Managers.party:get_player_status(_peer_id, _local_player_id) then
		local _player = self._player
		local flag = not _player and _player.player_unit
		local has_extension = ScriptUnit.has_extension(flag, "ghost_mode_system")

		if not has_extension then
			local is_in_ghost_mode, var_9_6 = has_extension:is_in_ghost_mode()

			return not is_in_ghost_mode and not var_9_6
		else
			return true
		end
	end

	return false
end

DarkPactSelectionUI._show = function (self, arg_10_1)
	-- function 10
	if self._is_visible == true then
		return
	end

	self._show_play_speed = arg_10_1

	self:_request_careers()
	WwiseWorld.trigger_event(self._wwise_world, "Play_versus_pactsworn_select_start")
end

DarkPactSelectionUI._hide = function (self, arg_11_1)
	-- function 11
	if self._is_visible == false then
		return
	end

	self:_play_anim("on_exit", arg_11_1)

	self._is_visible = false

	local input_service = self:input_service()

	if not input_service then
		input_service:set_input_blocked("next_observer_target", false, "DarkPactSelectionUI")
		input_service:set_input_blocked("previous_observer_target", false, "DarkPactSelectionUI")
	end

	WwiseWorld.trigger_event(self._wwise_world, "Stop_versus_pactsworn_select_start")
end

DarkPactSelectionUI.update = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	if not self._requesting_careers then
		return
	end

	if not RESOLUTION_LOOKUP.modified then
		self:_set_overlay_size()
	end

	self._ui_animator:update(arg_12_1)

	local _profile_requester = self._profile_requester

	if not self._pending_profile then
		local result = _profile_requester:result()

		if result == "success" then
			self._ingame_ui:play_sound("menu_versus_pactsworn_confirmed")
			self:_hide()

			self._pending_profile = nil
		elseif result == "failure" then
			local _selector_widgets = self._selector_widgets

			for i = 1, #_selector_widgets do
				if _selector_widgets[i].content.profile_name == self._pending_profile then
					self:_set_button(_selector_widgets[i], false)

					break
				end
			end

			self._pending_profile = nil
		end

		return
	end

	local input_service = self:input_service()

	if not self._is_visible then
		if not input_service:get("enable_camera_movement") then
			self._camera_movement_enabled = true

			self:_release_input()
		elseif not (not self._camera_movement_enabled and input_service:get("camera_movement_held")) then
			self._camera_movement_enabled = false

			self:_capture_input()
		end
	end

	if not self._input_captured then
		return
	end

	if not (not Managers.state.network and Managers.state.network:game()) then
		return
	end

	local is_device_active = Managers.input:is_device_active("mouse")

	if self._mouse_active ~= is_device_active then
		if not is_device_active then
			self:_deselect()
		else
			self:_select(1)
		end

		self._mouse_active = is_device_active
	end

	if not is_device_active then
		self:_handle_mouse_input(arg_12_1, arg_12_2, input_service, _profile_requester)
	else
		self:_handle_gamepad_input(arg_12_1, arg_12_2, input_service, _profile_requester)
	end
end

DarkPactSelectionUI._handle_mouse_input = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	local flag = false
	local _peer_id = self._peer_id
	local _local_player_id = self._local_player_id
	local _selector_widgets = self._selector_widgets

	for i = 1, #_selector_widgets do
		local content = _selector_widgets[i].content
		local hotspot = content.hotspot
		local profile_name = content.profile_name

		flag = flag or hotspot.is_hover

		if hotspot.on_release or not arg_13_3:get(content.input_key) then
			self._ingame_ui:play_sound("menu_versus_pactsworn_select")

			hotspot.on_release = false

			arg_13_4:request_profile(_peer_id, _local_player_id, profile_name, profile_name, true)

			self._pending_profile = profile_name

			break
		elseif not hotspot.on_hover_enter then
			self._ingame_ui:play_sound("menu_versus_pactsworn_hover")

			local display_name = CareerSettings[profile_name].display_name

			self:_set_enemy_pick_text(display_name)
			self:_set_enemy_pick_info_text(profile_name)
			self:_deselect()
		end
	end

	arg_13_3:set_input_blocked("next_observer_target", flag, "DarkPactSelectionUI")
	arg_13_3:set_input_blocked("previous_observer_target", flag, "DarkPactSelectionUI")
end

DarkPactSelectionUI._handle_gamepad_input = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	if not arg_14_3:get("move_right") then
		local min = math.min(self._selected_index + 1, #self._selector_widgets)

		self._ingame_ui:play_sound("menu_versus_pactsworn_hover")
		self:_select(min)
	elseif not arg_14_3:get("move_left") then
		local max = math.max(self._selected_index - 1, 1)

		self._ingame_ui:play_sound("menu_versus_pactsworn_hover")
		self:_select(max)
	end

	if not arg_14_3:get("confirm") then
		self:_confirm_choice(self._selected_index, arg_14_4)
	end
end

DarkPactSelectionUI._select = function (self, arg_15_1)
	-- function 15
	self:_deselect()

	self._selected_index = arg_15_1

	local content = self._selector_widgets[arg_15_1].content

	content.selected = true

	local profile_name = content.profile_name
	local display_name = CareerSettings[profile_name].display_name

	self:_set_enemy_pick_text(display_name)
	self:_set_enemy_pick_info_text(profile_name)
end

DarkPactSelectionUI._deselect = function (self)
	-- function 16
	local _selector_widgets = self._selector_widgets

	for k, v in pairs(_selector_widgets) do
		v.content.selected = false
	end

	self._selected_index = 0
end

DarkPactSelectionUI._confirm_choice = function (self, arg_17_1, arg_17_2)
	-- function 17
	arg_17_1 = math.clamp(arg_17_1, 1, #self._selector_widgets)

	local _peer_id = self._peer_id
	local _local_player_id = self._local_player_id
	local content = self._selector_widgets[arg_17_1].content

	content.selected = false

	local profile_name = content.profile_name

	self._ingame_ui:play_sound("menu_versus_pactsworn_select")
	arg_17_2:request_profile(_peer_id, _local_player_id, profile_name, profile_name, true)

	self._pending_profile = profile_name
end

DarkPactSelectionUI.post_update = function (self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	self:_draw(arg_18_1, self:input_service())
end

DarkPactSelectionUI._draw = function (self, arg_19_1, arg_19_2)
	-- function 19
	self.super._draw(self, arg_19_1, arg_19_2)
	UIRenderer.begin_pass(self._ui_renderer, self._ui_scenegraph, arg_19_2, arg_19_1, nil, {})

	if not self._selector_widgets and not self._is_visible then
		UIRenderer.draw_all_widgets(self._ui_renderer, self._selector_widgets)
	end

	UIRenderer.end_pass(self._ui_renderer)
end

DarkPactSelectionUI.event_set_new_enemy_role = function (arg_20_0)
	-- function 20
	return
end

DarkPactSelectionUI._set_enemy_role_text = function (arg_21_0, arg_21_1)
	-- function 21
	arg_21_0._widgets_by_name.chrome.content.category_text = string.format(Localize("vs_profile_selection_reason_unavailable"))
end

DarkPactSelectionUI._set_enemy_pick_text = function (arg_22_0, arg_22_1)
	-- function 22
	arg_22_0._widgets_by_name.chrome.content.pick_text = Utf8.upper(Localize(arg_22_1))
end

DarkPactSelectionUI._set_enemy_pick_info_text = function (self, arg_23_1)
	-- function 23
	local info_text = self._widgets_by_name.info_text
	local description = CareerSettings[arg_23_1].description

	info_text.content.text = Localize(description)
end

DarkPactSelectionUI._create_ui_elements = function (self)
	-- function 24
	self.super._create_ui_elements(self)

	self._selector_widgets = {}
end

DarkPactSelectionUI._request_careers = function (self)
	-- function 25
	self._requesting_careers = true

	Managers.state.game_mode:game_mode():request_selectable_dark_pact_careers()
end

DarkPactSelectionUI.event_versus_received_selectable_careers_response = function (self, arg_26_1, arg_26_2)
	-- function 26
	self._requesting_careers = false

	self:_create_selection_widgets(arg_26_1, arg_26_2)
	self:_play_anim("on_enter", self._show_play_speed)

	if not Managers.input:is_device_active("gamepad") then
		self:_select(1)
	end

	local _get_current_selected_career_name = self:_get_current_selected_career_name()

	self:_set_enemy_pick_text(_get_current_selected_career_name)
	self:_set_overlay_size()

	self._is_visible = true
end

DarkPactSelectionUI._create_selection_widgets = function (self, arg_27_1, arg_27_2)
	-- function 27
	local floor = math.floor(#arg_27_2 / 2)
	local num_3 = num + 10
	local num_4 = -(floor * num_3)
	local num_5 = -(floor * num_3) - num / 2
	local flag = #arg_27_2 % 2 ~= 0 or not num_4 or num_5

	self._ui_scenegraph.selection_pivot.position[1] = flag

	UISceneGraph.update_scenegraph(self._ui_scenegraph)

	local tbl = {}

	for i = 1, #arg_27_2 do
		local str = "selection_pivot"
		local str_2 = "selection_widget_" .. i
		local var_27_8 = create_selection_widget(str, {
			num,
			num_2
		})
		local var_27_9 = UIWidget.init(var_27_8)
		local var_27_10 = arg_27_2[i]

		var_27_9.content.profile_name = var_27_10

		local content = var_27_9.content
		local picking_image_square = CareerSettings[var_27_10].picking_image_square

		picking_image_square = picking_image_square or "icons_placeholder"
		content.profile_texture = picking_image_square
		var_27_9.content.input_key = "keyboard_" .. i
		var_27_9.offset[1] = (i - 1) * num_3
		tbl[#tbl + 1] = var_27_9
	end

	self:_set_enemy_role_text(arg_27_1)

	self._selector_widgets = tbl
end

DarkPactSelectionUI.input_service = function (self)
	-- function 28
	return self._input_manager:get_service(self._input_service_name)
end

DarkPactSelectionUI._get_current_selected_career_name = function (arg_29_0)
	-- function 29
	if not Managers then
		return "not_assigned"
	end

	if not Managers.player then
		return "not_assigned"
	end

	if not SPProfiles then
		return "not_assigned"
	end

	local local_player = Managers.player:local_player()

	if not local_player then
		return "not_assigned"
	end

	local career_index = local_player:career_index()
	local profile_index = local_player:profile_index()

	if not (not profile_index and career_index) then
		return "not_assigned"
	end

	return SPProfiles[profile_index].careers[career_index].display_name
end

DarkPactSelectionUI._set_overlay_size = function (arg_30_0)
	-- function 30
	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h
	local inv_scale = RESOLUTION_LOOKUP.inv_scale

	arg_30_0._widgets_by_name.overlay.style.rect.size = {
		res_w * inv_scale + 6,
		res_h * inv_scale + 6
	}
end
