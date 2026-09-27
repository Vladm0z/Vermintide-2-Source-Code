-- chunkname: @scripts/ui/social_wheel/social_wheel_ui.lua

local var_0_0 = local_require("scripts/ui/social_wheel/social_wheel_ui_settings")
local BASE_SOCIAL_WHEEL_SETTINGS = BASE_SOCIAL_WHEEL_SETTINGS

BASE_SOCIAL_WHEEL_SETTINGS = BASE_SOCIAL_WHEEL_SETTINGS or table.clone(SocialWheelSettings)

local str = "gui/1080p/single_textures/generic/transparent_placeholder_texture"
local str_2 = "social_wheel_ui"
local str_3 = "SocialWheelUI_"
local str_4 = "%s_weapon_pose_anim_%02d"
local flag = false
local var_0_7 = local_require("scripts/ui/social_wheel/social_wheel_ui_definitions")
local scenegraph_definition = var_0_7.scenegraph_definition

SocialWheelUI = class(SocialWheelUI)

local tbl = {
	"rpc_social_wheel_event"
}
local num = 0.125
local num_2 = 0.25
local num_3 = 0.01
local num_4 = 0.125
local num_5 = 5
local var_0_15

if not IS_WINDOWS then
	var_0_15 = {
		OPEN = {
			MOVE_Y = 0.3,
			SIZE = 0.3,
			MOVE_X = 0.3,
			ALPHA = 0.45
		},
		CLOSE = {
			MOVE_Y = 0.2,
			SIZE = 0.25,
			MOVE_X = 0.2,
			ALPHA = 0.1
		}
	}
else
	var_0_15 = {
		OPEN = {
			MOVE_Y = 0.3,
			SIZE = 0.3,
			MOVE_X = 0.3,
			ALPHA = 0.45
		},
		CLOSE = {
			MOVE_Y = 0.2,
			SIZE = 0.25,
			MOVE_X = 0.2,
			ALPHA = 0.1
		}
	}
end

local tbl_2 = {
	__index = function (self, arg_1_1, arg_1_2)
		-- function 1
		return self.default
	end
}
local tbl_3 = {
	default = {
		OPEN = "Play_hud_socialwheel_open",
		HOVER = "Play_hud_socialwheel_hover",
		SELECT = "Play_hud_socialwheel_select"
	},
	heroes = {
		OPEN = "Play_hud_socialwheel_open",
		HOVER = "Play_hud_socialwheel_hover",
		SELECT = "Play_hud_socialwheel_select"
	}
}

for k, v in pairs(DLCSettings) do
	local social_wheel_sfx_events = v.social_wheel_sfx_events

	if not social_wheel_sfx_events then
		table.merge_recursive(tbl_3, social_wheel_sfx_events)
	end
end

setmetatable(tbl_3, tbl_2)

SocialWheelUI.init = function (self, arg_2_1, arg_2_2)
	-- function 2
	self._parent = arg_2_1
	self._ui_top_renderer = arg_2_2.ui_top_renderer
	self._render_settings = {
		alpha_multiplier = 0
	}
	self._is_visible = true
	self._state = "update_closed"
	self._states = {
		update_closed = true,
		update_open = true
	}
	self._ingame_ui_context = arg_2_2
	self._peer_id = arg_2_2.peer_id
	self._player = arg_2_2.player
	self._wwise_world = arg_2_2.wwise_world

	if not IS_CONSOLE then
		local flag

		flag = not arg_2_2.is_in_inn and "_inn" and ""
		self._console_extension = flag
	else
		self._console_extension = ""
	end

	self._current_context = nil
	self._active_context = nil
	self._num_free_events = num_5
	self._valid_selection = true
	self._cloned_materials_by_reference = {}

	local ping_mode = Managers.state.game_mode:settings().ping_mode

	if not ping_mode then
		self._world_markers_enabled = ping_mode.world_markers
	else
		self._world_markers_enabled = false
	end

	self:_create_ui_elements()
	self:_register_rpcs()
end

SocialWheelUI._create_ui_elements = function (self)
	-- function 3
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._animations = {}
	self._animation_callbacks = {}
	self._selection_widgets = {}
	self._social_event_widgets = {}
	self._queued_social_wheel_events = {}
	self._icon_widgets = {}
	self._event_index = 0
	self._select_timer = 0
	self._selected_widget = nil

	self:_create_social_wheel(BASE_SOCIAL_WHEEL_SETTINGS)

	self._arrow_widget = UIWidget.init(var_0_7.arrow_widget)
	self._bg_widget = UIWidget.init(var_0_7.create_bg_widget())
	self._page_input_widget = UIWidget.init(var_0_7.page_input_widget)

	UIRenderer.clear_scenegraph_queue(self._ui_top_renderer)
end

SocialWheelUI._create_social_wheel = function (self, arg_4_1)
	-- function 4
	local flag = arg_4_1 or SocialWheelSettings

	local function fn()
		-- function 5
		return self._active_context
	end

	for k, v in pairs(flag) do
		local has_pages = v.has_pages
		local validation_function = v.validation_function

		if not validation_function and not validation_function() then
			if not has_pages then
				local count = #v
				local new_array = Script.new_array(count)

				self._selection_widgets[k] = new_array

				for k_2 = 1, count do
					local create_social_widget = var_0_7.create_social_widget(v[k_2], self:_widget_angle(v.angle, count, k_2), v, fn)

					new_array[k_2] = UIWidget.init(create_social_widget)
				end
			else
				local count_2 = #v
				local new_table = Script.new_table(count_2, 2)

				new_table.num_pages = count_2
				new_table.current_page = 1
				self._selection_widgets[k] = new_table

				for l = 1, count_2 do
					local var_4_9 = v[l]
					local count_3 = #var_4_9
					local new_array_2 = Script.new_array(count_3)

					new_table[l] = new_array_2

					if not new_table.emotes_page_index then
						new_table.emotes_page_index = not var_4_9.emotes and l and nil
					end

					if not new_table.weapon_poses_page_index then
						new_table.weapon_poses_page_index = not var_4_9.weapon_poses and l and nil
					end

					for i4 = 1, count_3 do
						local create_social_widget_2 = var_0_7.create_social_widget(var_4_9[i4], self:_widget_angle(v.angle, count_3, i4), v, fn, l)

						new_array_2[i4] = UIWidget.init(create_social_widget_2)
					end
				end
			end
		end
	end
end

SocialWheelUI._register_rpcs = function (self)
	-- function 6
	self._ingame_ui_context.network_event_delegate:register(self, unpack(tbl))
end

SocialWheelUI._unregister_rpcs = function (self)
	-- function 7
	self._ingame_ui_context.network_event_delegate:unregister(self)
end

SocialWheelUI.destroy = function (self)
	-- function 8
	self:_unregister_rpcs()

	local has_extension = ScriptUnit.has_extension(self._player.player_unit, "interactor_system")

	if not has_extension then
		has_extension:enable_interactions(true)
	end

	if not self._loaded_weapon_pose_packages then
		for k, v in pairs(self._loaded_weapon_pose_packages) do
			self:_reset_materials_for_item_type(v.item_type, k)
			Managers.package:unload(v.package_name, str_2)
		end

		table.clear(self._loaded_weapon_pose_packages)
	end

	self:_set_player_input_scale(1, nil)
end

SocialWheelUI._widget_angle = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local pi = math.pi
	local num = arg_9_1 / arg_9_2

	return -(pi * 0.5 + pi - arg_9_1 * 0.5 + num * 0.5) - (arg_9_3 - 1) * num
end

SocialWheelUI._select_widget = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local pi = math.pi
	local num = arg_10_1 / arg_10_2
	local num_2 = pi * 0.5 + pi - arg_10_1 * 0.5
	local num_3 = (-arg_10_3 - num_2) % (2 * pi)
	local num_4 = math.floor(num_3 / num) + 1

	if not (not (num_4 > 0) or not (num_4 <= arg_10_2)) then
		return num_4
	end
end

local tbl_4 = {
	0,
	0,
	0
}

SocialWheelUI._add_social_wheel_event = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	local var_11_0 = SocialWheelSettingsLookup[arg_11_2]
	local event_text, event_text_func = var_11_0.event_text, var_11_0.event_text_func
	local var_11_3

	if not event_text_func then
		event_text, var_11_3 = event_text_func(arg_11_3, var_11_0)
	end

	if not event_text then
		if not IS_WINDOWS then
			if self._num_free_events >= 1 then
				local flag = true
				local flag_2 = true

				Managers.chat:send_chat_message(1, arg_11_1:local_player_id(), event_text, flag, var_11_3, flag_2)
			else
				local var_11_6 = Localize("social_wheel_too_many_messages_warning")

				Managers.chat:add_local_system_message(1, var_11_6, true)
			end
		else
			local flag_3 = arg_11_1.peer_id == Network.peer_id()
			local player_unit = arg_11_1.player_unit

			if not Unit.alive(player_unit) then
				local career_name = ScriptUnit.extension(player_unit, "career_system"):career_name()
				local var_11_10 = CareerSettings[career_name]
				local var_11_11 = UIWidget.init(var_0_7.create_social_text_event(var_11_0, var_11_10.portrait_image, event_text, flag_3))
				local var_11_12

				if not flag_3 then
					local world = Managers.world:world("level_world")
					local viewport = ScriptWorld.viewport(world, "player_1")
					local camera = ScriptViewport.camera(viewport)
					local var_11_16 = UIWidget.init(var_0_7.create_social_icon(var_11_0, arg_11_1.peer_id, camera, world, Managers.time:time("game") + 5, 1))

					self._icon_widgets[arg_11_1.peer_id] = var_11_16
				end
			end
		end

		if not arg_11_4 then
			self:_play_sound("Play_hud_socialwheel_notification")
		end
	end
end

SocialWheelUI._add_social_wheel_event_animation = function (self, arg_12_1, arg_12_2)
	-- function 12
	local is_local_player = arg_12_1.content.is_local_player

	self._social_event_widgets[#self._social_event_widgets + 1] = arg_12_1
	self._event_index = self._event_index + 1

	local _event_index = self._event_index

	self._animations["social_event_" .. _event_index] = UIAnimation.init(UIAnimation.function_by_time, arg_12_1.offset, 1, 500, -60, 0.25, math.easeOutCubic)
	self._animation_callbacks["social_event_" .. _event_index] = function ()
		-- function 13
		local get_color_table_with_alpha

		if not is_local_player then
			get_color_table_with_alpha = Colors.get_color_table_with_alpha("medium_purple", 255)

			if not get_color_table_with_alpha then
				-- Nothing
			end
		end

		get_color_table_with_alpha = Colors.get_color_table_with_alpha("light_sky_blue", 255)

		::label_13_0::

		self._animations["social_event_color_" .. _event_index] = UIAnimation.init(UIAnimation.linear_scale_color, arg_12_1.style.text.text_color, 255, 255, 255, get_color_table_with_alpha[2], get_color_table_with_alpha[3], get_color_table_with_alpha[4], 2)
		self._animations["timer_" .. _event_index] = UIAnimation.init(UIAnimation.function_by_time, tbl_4, 1, 0, 0, 5, math.easeInCubic)
		self._animation_callbacks["timer_" .. _event_index] = function ()
			-- function 14
			self._animations["social_event_alpha_" .. _event_index] = UIAnimation.init(UIAnimation.function_by_time, arg_12_1.style.text.text_color, 1, 255, 0, 1, math.easeInCubic)
			self._animations["social_event_texture_alpha_" .. _event_index] = UIAnimation.init(UIAnimation.function_by_time, arg_12_1.style.texture.color, 1, 255, 0, 1, math.easeInCubic)
			self._animation_callbacks["social_event_alpha_" .. _event_index] = function ()
				-- function 15
				self._animations["spacing_" .. _event_index] = UIAnimation.init(UIAnimation.function_by_time, arg_12_1.content, "spacing", arg_12_1.content.spacing, 0, 0.5, math.easeOutCubic)
				self._animation_callbacks["spacing_" .. _event_index] = function ()
					-- function 16
					table.remove(self._social_event_widgets, 1)

					if #self._social_event_widgets < 6 then
						local var_16_0 = self._queued_social_wheel_events[1]

						if not var_16_0 then
							table.remove(self._queued_social_wheel_events, 1)
							self:_add_social_wheel_event_animation(var_16_0)
						end
					end
				end
			end
		end
	end
end

SocialWheelUI.rpc_social_wheel_event = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	-- function 17
	if not IS_XB1 and not Managers.chat:ignoring_peer_id(arg_17_2) then
		return
	end

	local player_from_peer_id = Managers.player:player_from_peer_id(arg_17_2)

	if not player_from_peer_id then
		local unit = Managers.state.unit_storage:unit(arg_17_4)

		if not unit and not Unit.alive(unit) then
			local var_17_2 = rawget(NetworkLookup.social_wheel_events, arg_17_3)

			if not var_17_2 then
				self:_add_social_wheel_event(player_from_peer_id, var_17_2, unit, true)
			end
		end
	end
end

SocialWheelUI.post_update = function (self, arg_18_1)
	-- function 18
	self:_post_update_remove_icon(arg_18_1)
	self:_post_update_render(arg_18_1)
end

local tbl_5 = {}

SocialWheelUI._post_update_remove_icon = function (self, arg_19_1)
	-- function 19
	table.clear(tbl_5)

	local time = Managers.time:time("game")

	for k, v in pairs(self._icon_widgets) do
		if time > v.content.end_time then
			tbl_5[#tbl_5 + 1] = k
		end
	end

	for i, v_2 in ipairs(tbl_5) do
		self._icon_widgets[v_2] = nil
	end
end

local tbl_6 = {}

SocialWheelUI._post_update_render = function (self, arg_20_1)
	-- function 20
	if not self._is_visible then
		return
	end

	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local get_service = Managers.input:get_service("ingame_menu")

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, get_service, arg_20_1, nil, tbl_6)

	for k, v in pairs(self._icon_widgets) do
		UIRenderer.draw_widget(_ui_top_renderer, v)
	end

	UIRenderer.end_pass(_ui_top_renderer)
end

SocialWheelUI.update = function (self, arg_21_1, arg_21_2)
	-- function 21
	self:_update_animations(arg_21_1, arg_21_2)
	self:_update_input(arg_21_1, arg_21_2)
	self:_draw(arg_21_1, arg_21_2)
end

SocialWheelUI._update_animations = function (self, arg_22_1)
	-- function 22
	local _animations = self._animations
	local _animation_callbacks = self._animation_callbacks

	for k, v in pairs(_animations) do
		UIAnimation.update(v, arg_22_1)

		if not UIAnimation.completed(v) then
			_animations[k] = nil

			if not _animation_callbacks[k] then
				_animation_callbacks[k]()

				_animation_callbacks[k] = nil
			end
		end
	end
end

SocialWheelUI._update_input = function (self, arg_23_1, arg_23_2)
	-- function 23
	local get_service = Managers.input:get_service("Player")

	self[self._state](self, arg_23_1, arg_23_2, get_service)

	self.previous_ping_held = get_service:get("ping_hold")
	self.previous_social_wheel_only_held = get_service:get("social_wheel_only_hold")
	self.previous_weapon_poses_only_held = get_service:get("weapon_poses_only_hold")
	self.previous_photomode_only_held = get_service:get("photomode_only_hold")
end

SocialWheelUI._draw = function (self, arg_24_1, arg_24_2)
	-- function 24
	if not self._is_visible then
		return
	end

	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local get_service = Managers.input:get_service("ingame_menu")
	local _current_selection_widgets = self._current_selection_widgets
	local _render_settings = self._render_settings

	if not (not _current_selection_widgets and not (_render_settings.alpha_multiplier > 0)) then
		UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, get_service, arg_24_1, nil, _render_settings)

		local count = #_current_selection_widgets

		for i = 1, count do
			local var_24_6 = _current_selection_widgets[i]

			UIRenderer.draw_widget(_ui_top_renderer, var_24_6)
		end

		UIRenderer.draw_widget(_ui_top_renderer, self._arrow_widget)

		if not self._current_selection_widget_settings.has_pages then
			UIRenderer.draw_widget(_ui_top_renderer, self._page_input_widget)
		end

		if not self._current_selection_widget_settings.individual_bg then
			UIRenderer.draw_widget(_ui_top_renderer, self._bg_widget)
		end

		UIRenderer.end_pass(_ui_top_renderer)
	end

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, get_service, arg_24_1)

	if not self._selected_widget then
		UIRenderer.draw_widget(_ui_top_renderer, self._selected_widget)
	end

	local num = 0
	local _social_event_widgets = self._social_event_widgets
	local count_2 = #_social_event_widgets

	for j = 1, count_2 do
		local var_24_10 = _social_event_widgets[j]

		var_24_10.offset[2] = num

		UIRenderer.draw_widget(_ui_top_renderer, var_24_10)

		num = num - var_24_10.content.spacing
	end

	UIRenderer.end_pass(_ui_top_renderer)
end

SocialWheelUI.set_visible = function (self, arg_25_1)
	-- function 25
	self._is_visible = arg_25_1
end

SocialWheelUI._set_player_input_scale = function (self, arg_26_1, arg_26_2)
	-- function 26
	local player_unit = self._player.player_unit

	if not Unit.alive(player_unit) then
		local extension = ScriptUnit.extension(player_unit, "input_system")

		extension:set_input_key_scale("look", arg_26_1, arg_26_2)
		extension:set_input_key_scale("look_controller", arg_26_1, arg_26_2)
		extension:set_input_key_scale("look_controller_zoom", arg_26_1, arg_26_2)
		extension:set_input_key_scale("look_controller_3p", arg_26_1, arg_26_2)
		extension:set_input_key_scale("look_controller_ranged", arg_26_1, arg_26_2)
		extension:set_input_key_scale("look_controller_melee", arg_26_1, arg_26_2)
	end

	local get_service = Managers.input:get_service("Player")

	if not get_service then
		local flag = arg_26_1 == 0

		get_service:set_input_blocked("look_controller_3p", flag, nil, "SocialWheelUI")
		get_service:set_input_blocked("look", flag, nil, "SocialWheelUI")
	end
end

SocialWheelUI._ping_unit_attempt = function (self, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
	local player_unit = self._player.player_unit

	if not Unit.alive(player_unit) and not Unit.alive(arg_27_1) then
		local time = Managers.time:time("game")

		return ScriptUnit.extension(player_unit, "ping_system"):ping_attempt(player_unit, arg_27_1, time, arg_27_2, arg_27_3)
	end
end

SocialWheelUI._ping_world_position_attempt = function (self, arg_28_1, arg_28_2, arg_28_3)
	-- function 28
	local player_unit = self._player.player_unit

	if not Unit.alive(player_unit) then
		local time = Managers.time:time("game")

		return ScriptUnit.extension(player_unit, "ping_system"):ping_world_position_attempt(player_unit, arg_28_1:unbox(), time, arg_28_2, arg_28_3)
	end
end

SocialWheelUI._social_message_attempt = function (self, arg_29_1, arg_29_2)
	-- function 29
	local player_unit = self._player.player_unit

	if not Unit.alive(player_unit) then
		local time = Managers.time:time("game")

		return ScriptUnit.extension(player_unit, "ping_system"):social_message_attempt(player_unit, arg_29_1, arg_29_2)
	end
end

SocialWheelUI._local_ping_attempt = function (self, arg_30_1, arg_30_2)
	-- function 30
	local _player = self._player
	local player_unit = _player.player_unit

	if not Unit.alive(player_unit) then
		Managers.state.entity:system("ping_system"):handle_local_ping(PingTypes.LOCAL_ONLY, arg_30_1, _player, player_unit, arg_30_2, nil)
	end
end

SocialWheelUI._play_sound = function (self, arg_31_1)
	-- function 31
	if not arg_31_1 then
		return
	end

	WwiseWorld.trigger_event(self._wwise_world, arg_31_1)
end

SocialWheelUI._change_state = function (self, arg_32_1)
	-- function 32
	fassert(self._states[arg_32_1], "[SocialWheelUI:_change_state] There is no state called %s", tostring(arg_32_1))

	self._state = arg_32_1
end

SocialWheelUI.update_closed = function (self, arg_33_1, arg_33_2, arg_33_3)
	-- function 33
	local player_unit = self._player.player_unit

	if not Unit.alive(player_unit) then
		local social_wheel_context = ScriptUnit.extension(player_unit, "ping_system"):social_wheel_context()

		self:_set_current_context(social_wheel_context)

		local time = Managers.time:time("game")

		if not (not social_wheel_context and not (time > social_wheel_context.min_t)) then
			if not self:_open_menu(arg_33_1, arg_33_2, arg_33_3) then
				self:_set_pulsing(social_wheel_context, true)
			else
				self:_set_current_context(nil)
			end
		elseif not social_wheel_context then
			self:_update_pointer(arg_33_3, false, arg_33_2)
		else
			local var_33_3 = Vector3(RESOLUTION_LOOKUP.res_w / 2, RESOLUTION_LOOKUP.res_h / 2, 0)

			self._arrow_widget.content.pointing_point:store(var_33_3)
		end
	end
end

SocialWheelUI._set_pulsing = function (arg_34_0, arg_34_1, arg_34_2)
	-- function 34
	local unit = arg_34_1.unit

	if not Unit.alive(unit) then
		if not arg_34_2 then
			Managers.state.entity:system("outline_system"):set_pulsing(unit, true, "pulse")

			arg_34_1.id = true
		elseif arg_34_2 or not arg_34_1.id then
			Managers.state.entity:system("outline_system"):set_pulsing(unit, false)

			arg_34_1.id = nil
		end
	end
end

SocialWheelUI._set_current_context = function (self, arg_35_1)
	-- function 35
	local _current_context = self._current_context

	if arg_35_1 ~= _current_context then
		if not _current_context then
			self:_set_pulsing(_current_context, false)
		end

		if not (not arg_35_1 and self._state ~= "open") then
			self:_set_pulsing(arg_35_1, true)
		end

		self._current_context = arg_35_1
	end
end

SocialWheelUI._open_menu = function (self, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
	-- function 36
	self._block_next_input = false

	local flag = true
	local _current_context = self._current_context
	local unit = _current_context.unit

	unit = unit or _current_context.ping_context_unit

	if not Unit.alive(unit) then
		unit = nil
	end

	local name = Managers.state.side.side_by_unit[self._player.player_unit]:name()
	local setting = Managers.state.game_mode:setting("social_wheel_by_side")
	local var_36_5

	if not setting then
		var_36_5 = setting[name] or "general"
	else
		var_36_5 = "general"
	end

	if not IS_WINDOWS then
		local is_device_active = Managers.input:is_device_active("gamepad")
		local user_setting = Application.user_setting("social_wheel_gamepad_layout")
		local setting_2 = Managers.state.game_mode:setting("should_use_gamepad_social_wheel")

		if user_setting ~= "auto" or not is_device_active or user_setting == "always" or not setting_2 then
			var_36_5 = var_36_5 .. "_gamepad"
		end
	else
		var_36_5 = var_36_5 .. self._console_extension
	end

	self:_inject_weapon_poses()

	for i = 1, #SocialWheelPriority do
		local var_36_9 = SocialWheelPriority[i]
		local var_36_10 = var_36_9[1]

		if not var_36_9[2](_current_context, self._player, unit) then
			var_36_5 = var_36_10

			break
		end
	end

	self._current_selection_widgets = self._selection_widgets[var_36_5]

	local var_36_11 = self._selection_widgets[var_36_5]
	local current_page = var_36_11.current_page

	self._page_input_widget.content.visible = true

	if not current_page then
		if not arg_36_4 then
			current_page = current_page % var_36_11.num_pages + 1

			if not (not _current_context.show_emotes and current_page == var_36_11.emotes_page_index) then
				current_page = var_36_11.emotes_page_index
			elseif not (not _current_context.show_poses and current_page == var_36_11.weapon_poses_page_index) then
				current_page = var_36_11.weapon_poses_page_index or 1
			end
		else
			current_page = 1

			if not _current_context.show_emotes then
				current_page = var_36_11.emotes_page_index or 1
			elseif not _current_context.show_poses then
				current_page = var_36_11.weapon_poses_page_index or 1
			end
		end

		var_36_11.current_page = current_page
		self._current_selection_widgets = var_36_11[current_page]
	else
		self._current_selection_widgets = var_36_11
	end

	if not self._current_selection_widgets then
		flag = false

		return flag
	end

	self._active_context = _current_context

	local _active_context = self._active_context

	if not var_36_11.num_pages and _active_context.show_emotes and not _active_context.show_poses then
		self._page_input_widget.content.visible = false
		self._block_next_input = true
	end

	self._current_selection_category = var_36_5

	local var_36_14 = SocialWheelSettings[var_36_5]

	fassert(var_36_14, "No settings for category %q.", var_36_5)

	self._current_selection_widget_settings = var_36_14

	local OPEN = var_0_15.OPEN
	local _animations = self._animations

	_animations.update_alpha = UIAnimation.init(UIAnimation.function_by_time, self._render_settings, "alpha_multiplier", 0, 1, OPEN.ALPHA, math.easeOutCubic)

	local _current_selection_widgets = self._current_selection_widgets
	local count = #_current_selection_widgets

	for j = 1, count do
		local var_36_19 = _current_selection_widgets[j]
		local content = var_36_19.content
		local final_offset = content.final_offset
		local unbox = content.dir:unbox()
		local offset = var_36_19.offset

		_animations["animation_x_" .. j] = UIAnimation.init(UIAnimation.function_by_time, offset, 1, unbox[1] * final_offset[1] * 0.5, unbox[1] * final_offset[1], OPEN.MOVE_X, math.ease_out_elastic)
		_animations["animation_y_" .. j] = UIAnimation.init(UIAnimation.function_by_time, offset, 2, unbox[2] * final_offset[2] * 0.5, unbox[2] * final_offset[2], OPEN.MOVE_Y, math.ease_out_elastic)
		_animations["animation_divider_size_" .. j] = UIAnimation.init(UIAnimation.function_by_time, content, "size_multiplier", content.final_size_multiplier * 0.5, content.final_size_multiplier, OPEN.SIZE, math.ease_out_elastic)
	end

	local content_2 = self._bg_widget.content

	_animations.animation_bg_size = UIAnimation.init(UIAnimation.function_by_time, content_2, "size_multiplier", content_2.final_size_multiplier * 0.5, content_2.final_size_multiplier, OPEN.SIZE, math.ease_out_elastic)

	local var_36_25

	if not (not IS_WINDOWS and Managers.input:is_device_active("gamepad")) then
		var_36_25 = num_2

		if not var_36_25 then
			-- Nothing
		end
	end

	var_36_25 = num

	::label_36_0::

	self._valid_selection = true
	self._selected_widget = nil
	self._open_start_t = arg_36_2

	self:_set_player_input_scale(0, var_36_25)
	self:_change_state("update_open")
	ScriptUnit.extension(self._player.player_unit, "interactor_system"):enable_interactions(false)

	if not self._world_markers_enabled then
		local function fn(arg_37_0, arg_37_1)
			-- function 37
			if not self._world_marker_preview_id then
				Managers.state.event:trigger("remove_world_marker", self._world_marker_preview_id)
			end

			self._world_marker_preview_id = arg_37_0
			arg_37_1.style.text.localize = false
		end

		local position = _active_context.position

		position = not position and _active_context.position:unbox()

		if not (not position and self._world_marker_preview_id) then
			Managers.state.event:trigger("add_world_marker_position", "ping", position, fn)
		end
	end

	if not name then
		local OPEN_2 = tbl_3[name].OPEN

		self:_play_sound(OPEN_2)
	end

	return flag
end

SocialWheelUI._inject_weapon_poses = function (self)
	-- function 38
	local local_player = Managers.player:local_player()
	local player_unit = local_player.player_unit

	if not ALIVE[player_unit] then
		self:_reset_social_wheel()

		return
	end

	local get_wielded_slot_name = ScriptUnit.has_extension(player_unit, "inventory_system"):get_wielded_slot_name()

	if not (get_wielded_slot_name == "slot_melee" or get_wielded_slot_name == "slot_ranged") then
		self:_reset_social_wheel()

		return
	end

	local career_name = local_player:career_name()
	local get_loadout_item = BackendUtils.get_loadout_item(career_name, get_wielded_slot_name)
	local data = get_loadout_item.data
	local gsub = string.gsub(data.key, "^vs_", "")

	if get_loadout_item.rarity == "magic" then
		gsub = string.gsub(data.key, "_magic_0%d$", "")
	end

	if not (self._wielded_item_type ~= gsub or self:_is_dirty(gsub)) then
		return
	end

	self._wielded_item_type = gsub

	local _loaded_weapon_pose_packages = self._loaded_weapon_pose_packages

	_loaded_weapon_pose_packages = _loaded_weapon_pose_packages or {}
	self._loaded_weapon_pose_packages = _loaded_weapon_pose_packages

	local var_38_8 = self._loaded_weapon_pose_packages[get_wielded_slot_name]

	if not (not var_38_8 and var_38_8.item_type == gsub or get_wielded_slot_name ~= var_38_8.slot_type) then
		self:_reset_materials_for_item_type(var_38_8.item_type, get_wielded_slot_name)
		Managers.package:unload(var_38_8.package_name, str_2)

		self._loaded_weapon_pose_packages[get_wielded_slot_name] = nil
	end

	local var_38_9 = self._loaded_weapon_pose_packages[get_wielded_slot_name]

	if not var_38_9 then
		local str = "resource_packages/pose_packages/" .. gsub

		if not Application.can_get("package", str) then
			if not Managers.package:has_loaded(str, str_2) then
				Managers.package:load(str, str_2, callback(self, "_weapon_pose_package_loaded_cb", gsub, get_wielded_slot_name), true, true)
			end

			self._loaded_weapon_pose_packages[get_wielded_slot_name] = {
				package_name = str,
				item_type = gsub,
				slot_type = get_wielded_slot_name
			}
		else
			Application.warning(string.format("[SocialWheelUI:_inject_weapon_poses] Pose package %q is missing for %q", gsub, str))
		end
	end

	self:_create_weapon_pose_wheel(gsub, get_wielded_slot_name, var_38_9)
end

SocialWheelUI._is_dirty = function (self, arg_39_1)
	-- function 39
	local flag = self:_gather_weapon_poses_by_parent_item(arg_39_1) ~= nil
	local name = Managers.state.side.side_by_unit[self._player.player_unit]:name()
	local setting = Managers.state.game_mode:setting("social_wheel_by_side")
	local str = "general"

	if not setting then
		str = setting[name]
	end

	local str_2 = str .. self._console_extension
	local var_39_5 = self._selection_widgets[str_2]
	local var_39_6 = self._selection_widgets[str_2 .. "_gamepad"]

	if not var_39_5 then
		return var_39_5.weapon_poses_page_index ~= nil ~= flag
	end

	if not var_39_6 then
		return var_39_6.weapon_poses_page_index ~= nil ~= flag
	end
end

SocialWheelUI._reset_social_wheel = function (self)
	-- function 40
	local name = Managers.state.side.side_by_unit[self._player.player_unit]:name()
	local setting = Managers.state.game_mode:setting("social_wheel_by_side")
	local str = "general"

	if not setting then
		str = setting[name]
	end

	local str_2 = str .. self._console_extension
	local var_40_4 = SocialWheelSettings[str_2]
	local var_40_5 = SocialWheelSettings[str_2 .. "_gamepad"]

	if not var_40_4 then
		local find_func_array = table.find_func_array(var_40_4, function (self)
			-- function 41
			return self.weapon_poses
		end)

		if not find_func_array then
			table.remove(var_40_4, find_func_array)
		end
	end

	if not var_40_5 then
		local find_func_array_2 = table.find_func_array(var_40_5, function (self)
			-- function 42
			return self.weapon_poses
		end)

		if not find_func_array_2 then
			table.remove(var_40_5, find_func_array_2)
		end
	end

	self:_create_social_wheel()
end

SocialWheelUI._create_weapon_pose_wheel = function (self, arg_43_1, arg_43_2, arg_43_3)
	-- function 43
	self:_reset_social_wheel()

	local _gather_weapon_poses_by_parent_item = self:_gather_weapon_poses_by_parent_item(arg_43_1)

	if not _gather_weapon_poses_by_parent_item then
		return
	end

	local functions = var_0_0.functions
	local tbl = {
		weapon_poses = true
	}
	local flag_2

	flag_2 = not flag and "template_diffuse_masked" and "template_diffuse"

	for i = 1, #_gather_weapon_poses_by_parent_item do
		local data = _gather_weapon_poses_by_parent_item[i].data
		local pose_index = data.pose_index
		local parent = data.parent
		local format = string.format(str_4, arg_43_2, data.pose_index)
		local str = str_3 .. format

		self:_create_material_instance(str, flag_2, format)

		if not arg_43_3 then
			local format_2 = string.format("gui/1080p/single_textures/icons_poses_social_wheel/" .. arg_43_1 .. "_%02d", pose_index)

			self:_set_material_diffuse_by_texture_path(str, format_2)
		end

		local format_3 = string.format(str_4 .. "_glow", arg_43_2, data.pose_index)
		local str_2 = str_3 .. format_3

		self:_create_material_instance(str_2, flag_2, format_3)

		if not arg_43_3 then
			local format_4 = string.format("gui/1080p/single_textures/icons_poses_social_wheel/" .. arg_43_1 .. "_%02d_glow", pose_index)

			self:_set_material_diffuse_by_texture_path(str_2, format_4)
		end

		local format_5 = string.format("social_wheel_weapon_pose_general_pose_%02d", data.pose_index)
		local tbl_2 = {
			localize = false,
			disable_input_text = true,
			name = format_5,
			text = string.format(Localize(parent .. "_emote_wheel"), data.pose_index),
			event_text = string.format(Localize(parent .. "_emote_wheel"), data.pose_index),
			execute_func = functions.play_emote,
			data = {
				anim_event = data.data.anim_event,
				pose_index = data.pose_index,
				hide_weapons = data.data.hide_weapons
			},
			icon = str,
			icon_glow = str_2,
			ping_type = PingTypes.LOCAL_ONLY
		}

		tbl[#tbl + 1] = tbl_2
		SocialWheelSettingsLookup[format_5] = tbl_2
	end

	local name = Managers.state.side.side_by_unit[self._player.player_unit]:name()
	local setting = Managers.state.game_mode:setting("social_wheel_by_side")
	local str_5 = "general"

	if not setting then
		str_5 = setting[name]
	end

	local str_6 = str_5 .. self._console_extension
	local var_43_19 = SocialWheelSettings[str_6]
	local var_43_20 = SocialWheelSettings[str_6 .. "_gamepad"]

	if not var_43_19 then
		table.insert(var_43_19, tbl)
	end

	if not var_43_20 then
		table.insert(var_43_20, tbl)
	end

	self:_create_social_wheel()
end

SocialWheelUI._create_material_instance = function (self, arg_44_1, arg_44_2, arg_44_3)
	-- function 44
	local _cloned_materials_by_reference = self._cloned_materials_by_reference

	_cloned_materials_by_reference = _cloned_materials_by_reference or {}

	if not _cloned_materials_by_reference[arg_44_3] then
		_cloned_materials_by_reference[arg_44_3] = arg_44_1

		Gui.clone_material_from_template(self._ui_top_renderer.gui, arg_44_1, arg_44_2)

		self._cloned_materials_by_reference = _cloned_materials_by_reference
	end
end

SocialWheelUI._gather_weapon_poses_by_parent_item = function (arg_45_0, arg_45_1)
	-- function 45
	local tbl = {}
	local get_interface = Managers.backend:get_interface("items")
	local var_45_2 = get_interface:get_unlocked_weapon_poses()[arg_45_1]

	if not var_45_2 then
		return
	end

	for k, v in pairs(var_45_2) do
		local get_item_from_id = get_interface:get_item_from_id(v)

		tbl[#tbl + 1] = get_item_from_id
	end

	local function fn(self, arg_46_1)
		-- function 46
		return self.data.pose_index < arg_46_1.data.pose_index
	end

	table.sort(tbl, fn)

	return tbl
end

SocialWheelUI._reset_materials_for_item_type = function (self, arg_47_1, arg_47_2)
	-- function 47
	local _gather_weapon_poses_by_parent_item = self:_gather_weapon_poses_by_parent_item(arg_47_1)

	if not _gather_weapon_poses_by_parent_item then
		return
	end

	for i = 1, #_gather_weapon_poses_by_parent_item do
		local data = _gather_weapon_poses_by_parent_item[i].data
		local format = string.format(str_4, arg_47_2, data.pose_index)

		self:_reset_cloned_material(format)

		local format_2 = string.format(str_4 .. "_glow", arg_47_2, data.pose_index)

		self:_reset_cloned_material(format_2)
	end
end

SocialWheelUI._weapon_pose_package_loaded_cb = function (self, arg_48_1, arg_48_2)
	-- function 48
	local _gather_weapon_poses_by_parent_item = self:_gather_weapon_poses_by_parent_item(arg_48_1)

	if not _gather_weapon_poses_by_parent_item then
		return
	end

	for i = 1, #_gather_weapon_poses_by_parent_item do
		local data = _gather_weapon_poses_by_parent_item[i].data
		local format = string.format(str_4, arg_48_2, data.pose_index)
		local str = str_3 .. format
		local pose_index = data.pose_index
		local format_2 = string.format("gui/1080p/single_textures/icons_poses_social_wheel/" .. arg_48_1 .. "_%02d", pose_index)

		self:_set_material_diffuse_by_texture_path(str, format_2)

		local format_3 = string.format(str_4 .. "_glow", arg_48_2, data.pose_index)
		local str_2 = str_3 .. format_3
		local format_4 = string.format("gui/1080p/single_textures/icons_poses_social_wheel/" .. arg_48_1 .. "_%02d_glow", pose_index)

		self:_set_material_diffuse_by_texture_path(str_2, format_4)
	end
end

SocialWheelUI._set_material_diffuse_by_texture_path = function (self, arg_49_1, arg_49_2)
	-- function 49
	local material = Gui.material(self._ui_top_renderer.gui, arg_49_1)

	if not material then
		Material.set_texture(material, "diffuse_map", arg_49_2)
	else
		Application.error(string.format("[SocialWheelUI:_set_material_diffuse_by_texture_path9 Missing material name: %q", arg_49_1))
	end
end

SocialWheelUI._reset_cloned_material = function (self, arg_50_1)
	-- function 50
	local var_50_0 = self._cloned_materials_by_reference[arg_50_1]

	if not var_50_0 then
		self:_set_material_diffuse_by_texture_path(var_50_0, str)
	else
		Application.error(string.format("[SocialWheelUI:_reset_cloned_material] Found no material to reset for reference name: %q", arg_50_1))
	end
end

SocialWheelUI.update_open = function (self, arg_51_1, arg_51_2, arg_51_3)
	-- function 51
	local get = arg_51_3:get("ping_hold")
	local get_2 = arg_51_3:get("ping_release")

	if not get_2 then
		get_2 = self.previous_ping_held
		get_2 = not get_2 and not get
	end

	local get_3 = arg_51_3:get("social_wheel_only_hold")
	local get_4 = arg_51_3:get("social_wheel_only_release")

	if not get_4 then
		get_4 = self.previous_social_wheel_only_held
		get_4 = not get_4 and not get_3
	end

	local get_5 = arg_51_3:get("photomode_only_hold")
	local get_6 = arg_51_3:get("photomode_only_release")

	if not get_6 then
		get_6 = self.previous_photomode_only_held
		get_6 = not get_6 and not get_5
	end

	if not (not get_5 and not self._current_selection_widget_settings.has_pages and not arg_51_3:get("social_wheel_page") and self._block_next_input) then
		self:_close_menu(arg_51_1, arg_51_2, arg_51_3, true)
		self:_open_menu(arg_51_1, arg_51_2, arg_51_3, true)

		return
	end

	local get_7 = arg_51_3:get("weapon_poses_only_hold")
	local get_8 = arg_51_3:get("weapon_poses_only_release")

	if not get_8 then
		get_8 = self.previous_weapon_poses_only_held
		get_8 = not get_8 and not get_7
	end

	if not (not get_7 and not self._current_selection_widget_settings.has_pages and not arg_51_3:get("social_wheel_page") and self._block_next_input) then
		self:_close_menu(arg_51_1, arg_51_2, arg_51_3, true)
		self:_open_menu(arg_51_1, arg_51_2, arg_51_3, true)

		return
	end

	if not (not self._current_selection_widget_settings.has_pages and not arg_51_3:get("social_wheel_page") and self._block_next_input) then
		self:_close_menu(arg_51_1, arg_51_2, arg_51_3, true)
		self:_open_menu(arg_51_1, arg_51_2, arg_51_3, true)

		return
	end

	if get_2 or get_4 or get_6 or not get_8 then
		self:_close_menu(arg_51_1, arg_51_2, arg_51_3)

		return
	end

	self:_update_pointer(arg_51_3, true, arg_51_2)
end

SocialWheelUI._update_pointer = function (self, arg_52_1, arg_52_2, arg_52_3)
	-- function 52
	local _arrow_widget = self._arrow_widget
	local content = _arrow_widget.content
	local style = _arrow_widget.style
	local arrow = style.arrow
	local cursor = style.cursor
	local _current_selection_widget_settings = self._current_selection_widget_settings
	local num = 0
	local flag = false

	if not Managers.input:is_device_active("gamepad") then
		local get = arg_52_1:get("look_raw_controller")

		if Vector3.length_squared(get) < 0.5 then
			arrow.angle = 0
			arrow.offset = {
				0,
				0,
				0
			}
			content.visible = false

			if arg_52_3 < self._select_timer then
				arg_52_2 = false
			end
		else
			local normalize = Vector3.normalize(get)

			num = math.atan2(normalize[2], normalize[1])
			arrow.angle = math.pi - num
			arrow.offset = {
				90 * normalize[1],
				90 * normalize[2],
				0
			}
			content.visible = arg_52_2
			flag = arg_52_2
			self._select_timer = arg_52_3 + 0.4
		end
	else
		local get_2 = arg_52_1:get("look_raw")
		local var_52_11 = Vector3(RESOLUTION_LOOKUP.res_w / 2, RESOLUTION_LOOKUP.res_h / 2, 0)
		local num_2 = content.pointing_point:unbox() + Vector3(get_2.x, -get_2.y, 0) - var_52_11
		local length = Vector3.length(num_2)
		local min = math.min(length, 200)
		local normalize_2 = Vector3.normalize(num_2)
		local num_3 = var_52_11 + normalize_2 * min
		local num_4

		if not arg_52_2 then
			num_4 = _current_selection_widget_settings.size[1] / _current_selection_widget_settings.size[2]

			if not num_4 then
				-- Nothing
			end
		end

		num_4 = 1

		::label_52_0::

		if min < 100 then
			num = math.atan2(normalize_2[2] * num_4, normalize_2[1])
			arrow.angle = math.pi - num
			arrow.offset = {
				0,
				0,
				0
			}
			arrow.color[1] = 0
			cursor.color[1] = 255
			cursor.offset = {
				num_2.x,
				num_2.y
			}
			content.visible = arg_52_2

			content.pointing_point:store(num_3)
		else
			num = math.atan2(normalize_2[2] * num_4, normalize_2[1])
			arrow.angle = math.pi - num
			arrow.offset = {
				100 * normalize_2[1],
				100 * normalize_2[2],
				0
			}
			arrow.color[1] = 255
			cursor.color[1] = 0
			content.visible = arg_52_2

			content.pointing_point:store(num_3)

			flag = arg_52_2
		end
	end

	if not arg_52_2 then
		self:_update_selection(flag, _current_selection_widget_settings.angle, num)
	end
end

SocialWheelUI._update_selection = function (self, arg_53_1, arg_53_2, arg_53_3)
	-- function 53
	local _current_selection_widgets = self._current_selection_widgets

	local function fn()
		-- function 54
		_current_selection_widgets[self._current_index].content.selected = false
		self._current_index = nil
		self._valid_selection = true
		self._bg_widget.content.text_id = Localize("tutorial_no_text")
	end

	if not arg_53_1 then
		if not self._current_index then
			fn()
		end

		return
	end

	local _select_widget = self:_select_widget(arg_53_2, #_current_selection_widgets, arg_53_3)

	if _select_widget or not self._current_index then
		fn()

		return
	end

	local _current_index = self._current_index

	if not (not _current_index and _current_selection_widgets[_current_index].content.is_valid) then
		fn()

		return
	end

	if _select_widget == _current_index then
		return
	end

	if not _current_index then
		_current_selection_widgets[_current_index].content.selected = false
		self._current_index = nil
	end

	local var_53_4 = _current_selection_widgets[_select_widget]

	if not var_53_4.content.is_valid then
		var_53_4.content.selected = true
		self._current_index = _select_widget
		self._valid_selection = true

		if not IS_WINDOWS then
			local unit = self._active_context.unit

			if not unit and not Unit.alive(unit) then
				local name = var_53_4.content.settings.name
				local var_53_7 = SocialWheelSettingsLookup[name]
				local event_text_func = var_53_7.event_text_func

				if not var_53_7.disable_input_text then
					local var_53_9

					if not event_text_func then
						var_53_9 = event_text_func(unit, var_53_7, true)

						if not var_53_9 then
							-- Nothing
						end
					end

					var_53_9 = var_53_7.event_text
					var_53_9 = var_53_9 or Localize(var_53_7.text)

					::label_53_0::

					self._bg_widget.content.text_id = var_53_9
				end
			end
		end

		local name_2 = Managers.state.side.side_by_unit[self._player.player_unit]:name()

		if not name_2 then
			local HOVER = tbl_3[name_2].HOVER

			self:_play_sound(HOVER)
		end
	else
		self._valid_selection = false
	end
end

SocialWheelUI._close_menu = function (self, arg_55_1, arg_55_2, arg_55_3, arg_55_4)
	-- function 55
	local CLOSE = var_0_15.CLOSE
	local _animations = self._animations

	self._animations.update_alpha = UIAnimation.init(UIAnimation.function_by_time, self._render_settings, "alpha_multiplier", self._render_settings.alpha_multiplier, 0, CLOSE.ALPHA, math.easeOutCubic)

	local content = self._bg_widget.content

	content.text_id = Localize("tutorial_no_text")
	_animations.animation_bg_size = UIAnimation.init(UIAnimation.function_by_time, content, "size_multiplier", content.size_multiplier, 0, CLOSE.SIZE, math.easeOutCubic)

	local _active_context = self._active_context
	local unit = _active_context.unit

	unit = unit or _active_context.ping_context_unit

	local _current_selection_widgets = self._current_selection_widgets
	local count = #_current_selection_widgets

	for i = 1, count do
		local var_55_7 = _current_selection_widgets[i]
		local content_2 = var_55_7.content
		local offset = var_55_7.offset

		_animations["animation_x_" .. i] = UIAnimation.init(UIAnimation.function_by_time, offset, 1, offset[1], 0, CLOSE.MOVE_X, math.easeOutCubic)
		_animations["animation_y_" .. i] = UIAnimation.init(UIAnimation.function_by_time, offset, 2, offset[2], 0, CLOSE.MOVE_Y, math.easeOutCubic)
		_animations["animation_divider_size_" .. i] = UIAnimation.init(UIAnimation.function_by_time, content_2, "size_multiplier", content_2.size_multiplier, 0, CLOSE.SIZE, math.easeOutCubic)

		if i == self._current_index then
			local settings = content_2.settings

			content_2.selected = false

			local function fn()
				-- function 56
				return _active_context
			end

			local category_settings = var_55_7.content.category_settings
			local _current_selection_category = self._current_selection_category
			local current_page = self._selection_widgets[_current_selection_category].current_page
			local var_55_15 = UIWidget.init(var_0_7.create_social_widget(settings, self:_widget_angle(category_settings.angle, count, i), category_settings, fn, current_page))

			self._selected_widget = var_55_15

			local content_3 = var_55_15.content

			content_3.selected = true
			content_3.activated = true

			local style = var_55_15.style
			local color = style.icon.color
			local color_2 = style.icon_shadow.color
			local color_3 = style.icon_bg.color
			local texture_size = style.icon.texture_size
			local texture_size_2 = style.icon_shadow.texture_size
			local base_texture_size = style.icon.base_texture_size
			local base_texture_size_2 = style.icon_shadow.base_texture_size
			local selected_color = style.text.selected_color
			local selected_color_2 = style.text_shadow.selected_color

			_animations["icon_color_a_" .. i] = UIAnimation.init(UIAnimation.pulse_animation3, color, 1, color[1], color[1] * 0.5, 10, 0.5)
			_animations["icon_size_x_" .. i] = UIAnimation.init(UIAnimation.pulse_animation3, texture_size, 1, base_texture_size[1], base_texture_size[1] * 0.75, 10, 0.5)
			_animations["icon_size_y_" .. i] = UIAnimation.init(UIAnimation.pulse_animation3, texture_size, 2, base_texture_size[2], base_texture_size[2] * 0.75, 10, 0.5)
			_animations["icon_shadow_color_a_" .. i] = UIAnimation.init(UIAnimation.pulse_animation3, color_2, 1, color_2[1], color_2[1] * 0.5, 10, 0.5)
			_animations["icon_shadow_size_x_" .. i] = UIAnimation.init(UIAnimation.pulse_animation3, texture_size_2, 1, base_texture_size_2[1], base_texture_size_2[1] * 0.75, 10, 0.5)
			_animations["icon_shadow_size_y_" .. i] = UIAnimation.init(UIAnimation.pulse_animation3, texture_size_2, 2, base_texture_size_2[2], base_texture_size_2[2] * 0.75, 10, 0.5)
			self._animation_callbacks["icon_color_a_" .. i] = function ()
				-- function 57
				_animations["fade_text_color_a_" .. i] = UIAnimation.init(UIAnimation.function_by_time, selected_color, 1, selected_color[1], 0, 0.25, math.easeOutCubic)
				_animations["fade_text_shadow_color_a_" .. i] = UIAnimation.init(UIAnimation.function_by_time, selected_color_2, 1, selected_color_2[1], 0, 0.25, math.easeOutCubic)
				_animations["fade_icon_color_a_" .. i] = UIAnimation.init(UIAnimation.function_by_time, color, 1, color[1], 0, 0.25, math.easeOutCubic)
				_animations["fade_icon_shadow_color_a_" .. i] = UIAnimation.init(UIAnimation.function_by_time, color_2, 1, color_2[1], 0, 0.25, math.easeOutCubic)
				_animations["fade_icon_bg_color_a_" .. i] = UIAnimation.init(UIAnimation.function_by_time, color_3, 1, color_3[1], 0, 0.25, math.easeOutCubic)
				self._animation_callbacks["fade_icon_color_a_" .. i] = function ()
					-- function 58
					self._selected_widget = nil
					content_3.activated = false
				end
			end
		end
	end

	if not arg_55_4 then
		self._open_start_t = nil
		self._current_index = nil

		return
	end

	if not IS_CONSOLE then
		local flag

		flag = not self._ingame_ui_context.is_in_inn and "_inn" and ""
		self._console_extension = flag
	else
		self._console_extension = ""
	end

	local var_55_28

	if not (not IS_WINDOWS and Managers.input:is_device_active("gamepad")) then
		var_55_28 = num_4

		if not var_55_28 then
			-- Nothing
		end
	end

	var_55_28 = num_3

	::label_55_0::

	local var_55_29

	if not self._world_marker_preview_id then
		Managers.state.event:trigger("remove_world_marker", self._world_marker_preview_id)

		self._world_marker_preview_id = nil
	end

	if not self._valid_selection then
		if self._current_index == nil then
			local num = arg_55_2 - self._open_start_t
			local max, var_55_32 = table.max(var_0_15.OPEN)

			if num < var_55_32 then
				var_55_29 = self:_ping_unit_attempt(unit, PingTypes.CONTEXT)
			end
		else
			local settings_2 = self._current_selection_widgets[self._current_index].content.settings
			local ping_type = settings_2.ping_type

			ping_type = ping_type or PingTypes.CHAT_ONLY

			local var_55_35 = rawget(NetworkLookup.social_wheel_events, settings_2.name)

			if not var_55_35 then
				if not (not unit and self._world_markers_enabled or ping_type ~= PingTypes.PLAYER_PICK_UP) then
					var_55_29 = self:_ping_unit_attempt(unit, ping_type, var_55_35)
				elseif ping_type == PingTypes.LOCAL_ONLY then
					var_55_29 = self:_local_ping_attempt(var_55_35, unit)
				elseif not _active_context.position and not self._world_markers_enabled then
					var_55_29 = self:_ping_world_position_attempt(_active_context.position, ping_type, var_55_35)
				else
					var_55_29 = self:_social_message_attempt(var_55_35, unit)
				end
			end
		end
	end

	local name = Managers.state.side.side_by_unit[self._player.player_unit]:name()

	if not name then
		if not var_55_29 then
			local SELECT = tbl_3[name].SELECT

			self:_play_sound(SELECT)
		else
			local CLOSE_2 = tbl_3[name].CLOSE

			self:_play_sound(CLOSE_2)
		end
	end

	self._active_context = nil

	self:_set_current_context(nil)

	self._open_start_t = nil
	self._current_index = nil

	self:_set_player_input_scale(1, var_55_28)
	self:_change_state("update_closed")
	ScriptUnit.extension(self._player.player_unit, "interactor_system"):enable_interactions(true)
end

SocialWheelUI.is_active = function (self)
	-- function 59
	return self._active_context ~= nil
end
