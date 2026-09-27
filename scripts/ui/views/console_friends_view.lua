-- chunkname: @scripts/ui/views/console_friends_view.lua

local var_0_0 = local_require("scripts/ui/views/console_friends_view_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local widget_definitions = var_0_0.widget_definitions
local generic_input_actions = var_0_0.generic_input_actions
local entry_definitions = var_0_0.entry_definitions
local flag = true
local num = 5
local num_2 = 12

ConsoleFriendsView = class(ConsoleFriendsView)

ConsoleFriendsView.init = function (self, arg_1_1)
	-- function 1
	self._ingame_ui_context = arg_1_1
	self._ingame_ui = arg_1_1.ingame_ui
	self._ui_top_renderer = arg_1_1.ui_top_renderer
	self._ui_renderer = arg_1_1.ui_renderer
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._network_lobby = arg_1_1.network_lobby
	self._invite_cooldown = {}
	self._cursor_position = 1
	self._hold_down_timer = 0
	self._hold_up_timer = 0
	self._is_in_inn = arg_1_1.is_in_inn
	self._is_server = arg_1_1.is_server

	if not GLOBAL_MUSIC_WORLD then
		self._wwise_world = MUSIC_WWISE_WORLD
	else
		local world = arg_1_1.world_manager:world("music_world")

		self._wwise_world = Managers.world:wwise_world(world)
	end

	self:_setup_input(arg_1_1)
	self:_create_ui_elements()

	self._menu_input_description = MenuInputDescriptionUI:new(arg_1_1, self._ui_top_renderer, self:input_service(), 7, 900, generic_input_actions.default, true)

	self._menu_input_description:set_input_description(nil)

	self._current_input_desc = nil
	self._friend_list_widgets = {}
end

ConsoleFriendsView.on_enter = function (self)
	-- function 2
	self._input_manager:block_device_except_service("console_friends_view", "keyboard", 1)
	self._input_manager:block_device_except_service("console_friends_view", "mouse", 1)
	self._input_manager:block_device_except_service("console_friends_view", "gamepad", 1)

	local has_world = Managers.world:has_world("character_preview")

	has_world = not has_world and Managers.world:world("character_preview")

	local flag = not has_world and World.get_data(has_world, "shading_environment")

	if not flag then
		World.set_data(has_world, "avoid_blend", true)
		ShadingEnvironment.set_scalar(flag, "fullscreen_blur_enabled", 1)
		ShadingEnvironment.set_scalar(flag, "fullscreen_blur_amount", 0.7)
		ShadingEnvironment.apply(flag)
	end

	local world = Managers.world:world("top_ingame_view")

	World.set_data(world, "avoid_blend", false)

	self._active = true

	if not (not IS_XB1 and Managers.account:friends_list_initiated()) then
		Managers.account:setup_friendslist()
	end

	self:_create_ui_elements()
	self:_setup_party_entries()
	self:_refresh_friends()

	self._refresh_friends_timer = nil
end

ConsoleFriendsView._join_game = function (self)
	-- function 3
	if not (not self.network_server and self.network_server:are_all_peers_ingame(nil, true)) then
		self._popup_id = Managers.popup:queue_popup(Localize("popup_join_blocked_by_joining_player"), Localize("popup_invite_not_installed_header"), "ok", Localize("menu_ok"))
	else
		local _current_friend_index = self._current_friend_index
		local var_3_1 = self._friend_list_widgets[self._current_friend_index]

		if not var_3_1 then
			local friend = var_3_1.content.friend
			local flag = not friend and friend.room_id

			if not flag then
				local tbl = {
					id = flag
				}

				if self._ingame_ui_context.network_lobby:id() == flag then
					self._popup_id = Managers.popup:queue_popup(Localize("popup_already_in_same_lobby"), Localize("popup_invite_not_installed_header"), "ok", Localize("menu_ok"))

					return
				end

				if not (not self._is_server and self._is_in_inn) then
					self._ingame_ui:handle_transition("join_lobby", tbl)
				else
					Managers.matchmaking:request_join_lobby(tbl, {
						friend_join = true
					})
				end
			end
		end
	end
end

ConsoleFriendsView._refresh_friends = function (self)
	-- function 4
	self._is_refreshing = true

	if not IS_XB1 then
		Managers.account:get_friends(1000, callback(self, "cb_friends_collected"))
	elseif not IS_PS4 then
		Managers.account:get_friends(2000, callback(self, "cb_friends_collected"))
	end

	self._widgets_by_name.loading_icon.style.loading_icon.color[1] = 255
end

local tbl = {}

ConsoleFriendsView.cb_friends_collected = function (self, arg_5_1)
	-- function 5
	arg_5_1 = arg_5_1 or tbl

	local _friend_list_widgets = self._friend_list_widgets

	table.clear(_friend_list_widgets)

	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}

	for k, v in pairs(arg_5_1) do
		v.id = k

		if v.status == "offline" then
			tbl_4[#tbl_4 + 1] = v
		elseif not v.playing_this_game then
			tbl_2[#tbl_2 + 1] = v
		else
			tbl_3[#tbl_3 + 1] = v
		end
	end

	local function fn(self, arg_6_1)
		-- function 6
		return self.name < arg_6_1.name
	end

	table.sort(tbl_2, fn)
	table.sort(tbl_3, fn)
	table.sort(tbl_4, fn)

	local var_5_5 = entry_definitions.friend_entry_size[2]
	local num = -var_5_5

	for k_2, v_2 in pairs(tbl_2) do
		_friend_list_widgets[#_friend_list_widgets + 1] = UIWidget.init(entry_definitions.create_friend_entry(v_2.name, true, num, v_2))
		num = num - var_5_5
	end

	for k_3, v_3 in pairs(tbl_3) do
		_friend_list_widgets[#_friend_list_widgets + 1] = UIWidget.init(entry_definitions.create_friend_entry(v_3.name, true, num, v_3))
		num = num - var_5_5
	end

	for k_4, v_4 in pairs(tbl_4) do
		_friend_list_widgets[#_friend_list_widgets + 1] = UIWidget.init(entry_definitions.create_friend_entry(v_4.name, false, num, v_4))
		num = num - var_5_5
	end

	print(string.format("Added %s friends", #_friend_list_widgets))

	local loading_icon = self._widgets_by_name.loading_icon

	self._ui_animations.loading_icon_fade = UIAnimation.init(UIAnimation.function_by_time, loading_icon.style.loading_icon.color, 1, 255, 0, 0.5, math.easeOutCubic)
	self._is_refreshing = false
end

ConsoleFriendsView.on_exit = function (self)
	-- function 7
	self._input_manager:device_unblock_all_services("keyboard", 1)
	self._input_manager:device_unblock_all_services("mouse", 1)
	self._input_manager:device_unblock_all_services("gamepad", 1)

	local has_world = Managers.world:has_world("character_preview")

	has_world = not has_world and Managers.world:world("character_preview")

	if not has_world then
		World.set_data(has_world, "avoid_blend", false)
	end

	if not self._popup_id then
		Managers.popup:cancel_popup(self._popup_id)

		self._popup_id = nil
	end

	self._exiting = nil
	self._active = nil
end

ConsoleFriendsView.exit = function (self)
	-- function 8
	local str = "ingame_menu"

	self._ingame_ui:transition_with_fade(str)
	WwiseWorld.trigger_event(self._wwise_world, "Play_hud_button_close")

	self._exiting = true
end

ConsoleFriendsView.transitioning = function (self)
	-- function 9
	if not self._exiting then
		return true
	else
		return not self._active
	end
end

ConsoleFriendsView._setup_input = function (self, arg_10_1)
	-- function 10
	local input_manager = arg_10_1.input_manager

	input_manager:create_input_service("console_friends_view", "IngameMenuKeymaps", "IngameMenuFilters")
	input_manager:map_device_to_service("console_friends_view", "keyboard")
	input_manager:map_device_to_service("console_friends_view", "mouse")
	input_manager:map_device_to_service("console_friends_view", "gamepad")

	self._input_manager = input_manager
end

ConsoleFriendsView._create_ui_elements = function (self)
	-- function 11
	UIRenderer.clear_scenegraph_queue(self._ui_top_renderer)

	self._wanted_pos = scenegraph_definition.friends_base.position[2]
	self._current_friend_index = 1
	self._ui_animations = {}
	self._ui_animations = {}
	self._cursor_position = 1

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widget_definitions) do
		local var_11_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_11_2
		tbl_2[k] = var_11_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2
	self._widgets_by_name.friends_bg.style.background.color = {
		255,
		128,
		128,
		128
	}

	self:_setup_party_entries()

	self._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	flag = false
end

ConsoleFriendsView._sorted_players = function (arg_12_0)
	-- function 12
	local human_players = Managers.player:human_players()
	local tbl = {}

	for k, v in pairs(human_players) do
		tbl[#tbl + 1] = v
	end

	local function fn(self, arg_13_1)
		-- function 13
		local profile_index = self:profile_index()

		profile_index = profile_index or -1

		local profile_index_2 = arg_13_1:profile_index()

		profile_index_2 = profile_index_2 or -1

		return profile_index < profile_index_2
	end

	local var_12_3 = FindProfileIndex("spectator")

	if not var_12_3 then
		table.array_remove_if(tbl, function (self)
			-- function 14
			return self:profile_index() == var_12_3
		end)
	end

	table.sort(tbl, fn)

	return tbl
end

ConsoleFriendsView._setup_party_entries = function (self)
	-- function 15
	self._party_entries = {}

	local _sorted_players = self:_sorted_players()
	local num = -40

	for i, v in ipairs(_sorted_players) do
		local name = v:name()
		local var_15_3

		if not v.local_player then
			var_15_3 = v:career_name()
		else
			local player_unit = v.player_unit

			if not Unit.alive(player_unit) then
				var_15_3 = ScriptUnit.extension(player_unit, "career_system"):career_name()
			end
		end

		local var_15_5 = CareerSettings[var_15_3]

		self._party_entries[#self._party_entries + 1] = UIWidget.init(entry_definitions.create_party_entry(name, var_15_5, num * i))
	end

	local num_2 = 4 - #self._party_entries

	for k = 1, num_2 do
		self._party_entries[#self._party_entries + 1] = UIWidget.init(entry_definitions.create_party_entry(nil, nil, num * (#self._party_entries + 1)))
	end
end

ConsoleFriendsView.update = function (self, arg_16_1, arg_16_2)
	-- function 16
	if not flag then
		self:_create_ui_elements()
	end

	if not self._popup_id then
		self:_handle_popup()
	else
		self:_update_input_descriptions(arg_16_1, arg_16_2)
		self:_handle_input(arg_16_1, arg_16_2)
		self:_update_animations(arg_16_1, arg_16_2)
		self:_handle_refresh(arg_16_1, arg_16_2)
		self:_animate_default_buttons(arg_16_1, arg_16_2)
		self:_draw(arg_16_1, arg_16_2)
	end
end

ConsoleFriendsView._update_input_descriptions = function (self, arg_17_1, arg_17_2)
	-- function 17
	local var_17_0 = self._friend_list_widgets[self._current_friend_index]
	local flag = false
	local flag_2 = false

	if not var_17_0 then
		local friend = var_17_0.content.friend
		local xbox_user_id = friend.xbox_user_id
		local flag_3 = friend.status == "online"
		local flag_4

		flag_4 = (not self._invite_cooldown[xbox_user_id] and not (arg_17_2 > self._invite_cooldown[xbox_user_id]) and flag_3 or Managers.account:has_session() and not "invite") and nil

		local flag_5 = not not self._is_refreshing or "refresh"

		if not (not IS_PS4 and not flag_5 and flag_3) then
			flag_5 = nil
		end

		local str = "friend"

		if not flag_4 then
			str = str .. "_" .. flag_4

			if not flag_5 then
				str = str .. "_" .. flag_5
			end
		elseif not flag_5 then
			str = str .. "_" .. flag_5
		end

		if not str then
			self._menu_input_description:set_input_description(generic_input_actions[str])
		else
			self._menu_input_description:set_input_description(nil)
		end

		flag = true
		flag_2 = flag_4 ~= nil
		self._current_input_desc = str
	elseif not IS_XB1 then
		local flag_6 = not not self._is_refreshing or "only_refresh"

		if self._current_input_desc ~= flag_6 then
			local flag_7 = not flag_6 and generic_input_actions[flag_6]

			self._menu_input_description:set_input_description(flag_7)

			self._current_input_desc = flag_6
		end
	elseif not self._current_input_desc then
		self._menu_input_description:set_input_description(nil)

		self._current_input_desc = nil
	end

	local open_profile_button = self._widgets_by_name.open_profile_button

	if not open_profile_button then
		open_profile_button.content.button_hotspot.disable_button = not flag
	end

	local invite_button = self._widgets_by_name.invite_button

	if not invite_button then
		invite_button.content.button_hotspot.disable_button = not flag_2
	end
end

ConsoleFriendsView._handle_refresh = function (self, arg_18_1, arg_18_2)
	-- function 18
	if not IS_PS4 then
		local _refresh_friends_timer = self._refresh_friends_timer

		_refresh_friends_timer = _refresh_friends_timer or arg_18_2 + num_2
		self._refresh_friends_timer = _refresh_friends_timer

		if arg_18_2 > self._refresh_friends_timer then
			self:_refresh_friends()

			self._refresh_friends_timer = arg_18_2 + num_2
		end
	end
end

ConsoleFriendsView._animate_default_buttons = function (self, arg_19_1, arg_19_2)
	-- function 19
	if not Managers.input:is_device_active("gamepad") then
		local open_profile_button = self._widgets_by_name.open_profile_button
		local invite_button = self._widgets_by_name.invite_button

		UIWidgetUtils.animate_default_button(open_profile_button, arg_19_1)
		UIWidgetUtils.animate_default_button(invite_button, arg_19_1)
	end
end

ConsoleFriendsView._handle_input = function (self, arg_20_1, arg_20_2)
	-- function 20
	if not self._exiting then
		return
	end

	local input_service = self:input_service()
	local _ui_animations = self._ui_animations

	_ui_animations = _ui_animations or {}
	self._ui_animations = _ui_animations

	local var_20_2 = entry_definitions.friend_entry_size[2]
	local var_20_3 = scenegraph_definition.friends_base.position[2]
	local _wanted_pos = self._wanted_pos

	_wanted_pos = _wanted_pos or var_20_3
	self._wanted_pos = _wanted_pos

	local _current_friend_index = self._current_friend_index

	_current_friend_index = _current_friend_index or 1
	self._current_friend_index = _current_friend_index

	local _current_friend_index_2 = self._current_friend_index
	local num = 0
	local num_2 = 0
	local is_device_active = Managers.input:is_device_active("gamepad")
	local on_pressed = self._widgets_by_name.open_profile_button.content.button_hotspot.on_pressed
	local on_pressed_2 = self._widgets_by_name.invite_button.content.button_hotspot.on_pressed
	local content = self._widgets_by_name.selection_handler.content
	local up_hotspot = content.up_hotspot
	local down_hotspot = content.down_hotspot

	if input_service:get("move_up_hold") or not up_hotspot.is_held then
		num_2 = self._hold_up_timer + arg_20_1
	elseif input_service:get("move_down_hold") or not down_hotspot.is_held then
		num = self._hold_down_timer + arg_20_1
	end

	self._hold_down_timer = num
	self._hold_up_timer = num_2

	local count = #self._friend_list_widgets
	local num_visible_friends = var_0_0.num_visible_friends
	local get = input_service:get("scroll_axis")

	if not IS_XB1 then
		get = not get and math.sign(get.x)
	else
		get = not get and math.sign(get.y)
	end

	if input_service:get("back", true) or not input_service:get("toggle_menu", true) then
		self:exit()
	elseif input_service:get("refresh") or not on_pressed_2 then
		local var_20_18 = self._friend_list_widgets[self._current_friend_index]

		if not var_20_18 then
			self:_send_invite(var_20_18, arg_20_2)
		end
	elseif not (not input_service:get("special_1") and self._is_refreshing) then
		if not IS_XB1 then
			self:_refresh_friends()
		elseif not IS_PS4 then
			self:_join_game()
		end
	elseif input_service:get("confirm_press") or not on_pressed then
		local var_20_19 = self._friend_list_widgets[self._current_friend_index]

		if not var_20_19 then
			self:_open_profile(var_20_19)
		end
	elseif not (input_service:get("move_down") or self._hold_down_timer > 0.5 or down_hotspot.on_pressed or down_hotspot.on_double_click or not (get < 0)) then
		if self._hold_down_timer > 0.5 then
			self._hold_down_timer = 0.4
		end

		self._current_friend_index = math.clamp(self._current_friend_index + 1, 1, count)
		self._cursor_position = math.clamp(self._cursor_position + 1, 1, math.min(num_visible_friends, count))

		if self._cursor_position == num_visible_friends then
			local _wanted_pos_2 = self._wanted_pos

			self._wanted_pos = math.clamp(self._wanted_pos + var_20_2, var_20_3, count * var_20_2 + var_20_2)
			self._ui_animations.move = UIAnimation.init(UIAnimation.function_by_time, self._ui_scenegraph.friends_base.position, 2, self._ui_scenegraph.friends_base.position[2], self._wanted_pos, 0.3, math.easeOutCubic)

			if self._wanted_pos ~= _wanted_pos_2 then
				self._cursor_position = math.clamp(self._cursor_position - 1, 1, num_visible_friends)
			end
		end
	elseif not (input_service:get("move_up") or self._hold_up_timer > 0.5 or up_hotspot.on_pressed or up_hotspot.on_double_click or not (get > 0)) then
		if self._hold_up_timer > 0.5 then
			self._hold_up_timer = 0.4
		end

		self._current_friend_index = math.clamp(self._current_friend_index - 1, 1, count)
		self._cursor_position = math.clamp(self._cursor_position - 1, 1, math.min(num_visible_friends, count))

		if not (not (self._cursor_position <= 2) or not (num_visible_friends < count)) then
			local _wanted_pos_3 = self._wanted_pos

			self._wanted_pos = math.clamp(self._wanted_pos - var_20_2, var_20_3, count * var_20_2 + var_20_2)
			self._ui_animations.move = UIAnimation.init(UIAnimation.function_by_time, self._ui_scenegraph.friends_base.position, 2, self._ui_scenegraph.friends_base.position[2], self._wanted_pos, 0.3, math.easeOutCubic)

			if self._wanted_pos ~= _wanted_pos_3 then
				self._cursor_position = math.clamp(self._cursor_position + 1, 1, num_visible_friends)
			end
		end
	elseif not (is_device_active or IS_PS4) then
		local clamp = math.clamp(self._current_friend_index - (self._cursor_position - 1), 1, math.max(count - (num_visible_friends - 1), 1))
		local clamp_2 = math.clamp(clamp + num_visible_friends - 1, 1, count)

		for i = clamp, clamp_2 do
			if not self._friend_list_widgets[i].content.entry_hotspot.on_pressed then
				self._current_friend_index = i
				self._cursor_position = i - (clamp - 1)

				break
			end
		end
	end

	local var_20_24 = self._friend_list_widgets[_current_friend_index_2]

	if not var_20_24 then
		var_20_24.content.selected = false
	end

	local var_20_25 = self._friend_list_widgets[self._current_friend_index]

	if not var_20_25 then
		var_20_25.content.selected = true
	end
end

ConsoleFriendsView._update_animations = function (self, arg_21_1, arg_21_2)
	-- function 21
	local _ui_animations = self._ui_animations

	for k, v in pairs(_ui_animations) do
		UIAnimation.update(v, arg_21_1)

		if not UIAnimation.completed(v) then
			_ui_animations[k] = nil
		end
	end
end

ConsoleFriendsView._draw = function (self, arg_22_1, arg_22_2)
	-- function 22
	local _ui_scenegraph = self._ui_scenegraph
	local _ui_top_renderer = self._ui_top_renderer
	local input_service = self:input_service()
	local is_device_active = self._input_manager:is_device_active("gamepad")

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, input_service, arg_22_1, nil, self._render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(_ui_top_renderer, v)
	end

	for i_2, v_2 in ipairs(self._party_entries) do
		UIRenderer.draw_widget(_ui_top_renderer, v_2)
	end

	if not self._friend_list_widgets then
		local var_22_4 = table.clone(_ui_scenegraph.friends_mask.world_position)[2]
		local num = var_22_4 + entry_definitions.friend_entry_size[2]
		local num_2 = var_22_4 - (var_0_0.num_visible_friends + 1) * entry_definitions.friend_entry_size[2]

		for i_3, v_3 in ipairs(self._friend_list_widgets) do
			local num_3 = _ui_scenegraph.friends_base.position[2] + v_3.offset[2]

			if not (not (num_3 <= num) or not (num_2 <= num_3)) then
				UIRenderer.draw_widget(_ui_top_renderer, v_3)
			end
		end
	end

	UIRenderer.end_pass(_ui_top_renderer)

	if not is_device_active then
		self._menu_input_description:draw(_ui_top_renderer, arg_22_1)
	end
end

ConsoleFriendsView._handle_popup = function (self)
	-- function 23
	local query_result, var_23_1 = Managers.popup:query_result(self._popup_id)

	if not query_result then
		if query_result == "ok" then
			self._popup_id = nil
		else
			fassert(false, "[ConsoleFriendsView:_handle_popup] No implementation for the result %q", query_result)
		end
	end
end

ConsoleFriendsView.destroy = function (arg_24_0)
	-- function 24
	return
end

ConsoleFriendsView.input_service = function (self)
	-- function 25
	return self._input_manager:get_service("console_friends_view")
end

ConsoleFriendsView._open_profile = function (arg_26_0, arg_26_1)
	-- function 26
	local id = arg_26_1.content.friend.id

	if not IS_XB1 then
		Managers.account:show_player_profile(id)
	elseif not IS_PS4 then
		Managers.account:show_player_profile_with_account_id(id)
	end
end

ConsoleFriendsView._send_invite = function (self, arg_27_1, arg_27_2)
	-- function 27
	local id = arg_27_1.content.friend.id
	local var_27_1 = self._invite_cooldown[id]

	if not (not self._invite_cooldown[id] and arg_27_2 < self._invite_cooldown[id] or Managers.account:has_session()) then
		return
	end

	self._network_lobby = self._ingame_ui_context.network_lobby

	local invite_target = self._network_lobby:invite_target()

	Managers.account:send_session_invitation(id, invite_target)

	self._invite_cooldown[id] = arg_27_2 + num
	self._ui_animations["fade_invite_" .. id] = UIAnimation.init(UIAnimation.function_by_time, arg_27_1.style.invite_texture.color, 1, 255, 0, 1, math.easeInCubic)
	self._ui_animations["move_invite_" .. id] = UIAnimation.init(UIAnimation.function_by_time, arg_27_1.style.invite_texture.offset, 1, 40, 70, 1, math.easeInCubic)
end

ConsoleFriendsView.cleanup_popups = function (self)
	-- function 28
	if not self._popup_id then
		Managers.popup:cancel_popup(self._popup_id)

		self._popup_id = nil
	end
end
