-- chunkname: @scripts/ui/views/friends_ui_component.lua

local var_0_0 = local_require("scripts/ui/views/friends_ui_component_definitions")
local flag = true

FriendsUIComponent = class(FriendsUIComponent)

FriendsUIComponent.init = function (self, arg_1_1)
	-- function 1
	self._ui_top_renderer = arg_1_1.ui_top_renderer
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._network_lobby = arg_1_1.network_lobby
	self._invite_cooldown = {}

	self:_create_ui_elements()
end

FriendsUIComponent._create_ui_elements = function (self)
	-- function 2
	self._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local widget_definitions = var_0_0.widget_definitions
	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widget_definitions) do
		if k ~= "friends_button" then
			local var_2_3 = UIWidget.init(v)

			tbl[#tbl + 1] = var_2_3
			tbl_2[k] = var_2_3
		end
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2
	self._friends_button_widget = UIWidget.init(var_0_0.widget_definitions.friends_button)
end

FriendsUIComponent.is_active = function (self)
	-- function 3
	return self._active
end

FriendsUIComponent.activate_friends_ui = function (self)
	-- function 4
	if not (not IS_XB1 and Managers.account:friends_list_initiated()) then
		Managers.account:setup_friendslist()
	end

	self._active = true

	self:_refresh_friends_list()

	self._widgets_by_name.hotspot_area.content.disregard_exit = nil
end

FriendsUIComponent.deactivate_friends_ui = function (self)
	-- function 5
	self._active = false
end

FriendsUIComponent._refresh_friends_list = function (self)
	-- function 6
	local tbl = {}
	local _widgets_by_name = self._widgets_by_name

	self:_populate_tab(_widgets_by_name.online_tab, tbl)
	self:_populate_tab(_widgets_by_name.offline_tab, tbl)

	local friend_list_limit = var_0_0.list_info.friend_list_limit

	Managers.account:get_friends(friend_list_limit, callback(self, "cb_refresh_friends_done"))
end

FriendsUIComponent.join_lobby_data = function (self)
	-- function 7
	local _join_lobby_data = self._join_lobby_data

	self._join_lobby_data = nil

	return _join_lobby_data
end

local tbl = {}

FriendsUIComponent.cb_refresh_friends_done = function (self, arg_8_1)
	-- function 8
	arg_8_1 = arg_8_1 or tbl

	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}

	for k, v in pairs(arg_8_1) do
		v.id = k

		if v.status == "offline" then
			tbl_4[#tbl_4 + 1] = v
		elseif not v.playing_this_game then
			tbl_2[#tbl_2 + 1] = v
		else
			tbl_3[#tbl_3 + 1] = v
		end
	end

	local function fn(self, arg_9_1)
		-- function 9
		return self.name < arg_9_1.name
	end

	table.sort(tbl_2, fn)
	table.sort(tbl_3, fn)
	table.sort(tbl_4, fn)

	for k_2 = 1, #tbl_3 do
		local var_8_4 = tbl_3[k_2]

		tbl_2[#tbl_2 + 1] = var_8_4
	end

	local _widgets_by_name = self._widgets_by_name

	self:_populate_tab(_widgets_by_name.online_tab, tbl_2, true)
	self:_populate_tab(_widgets_by_name.offline_tab, tbl_4, false)
end

FriendsUIComponent._button_pressed = function (arg_10_0, arg_10_1)
	-- function 10
	if not arg_10_1.on_release then
		arg_10_1.on_release = false

		return true
	end

	return false
end

FriendsUIComponent.update = function (self, arg_11_1, arg_11_2)
	-- function 11
	if not flag then
		flag = false

		self:_create_ui_elements()
	end

	self:_update_invite_cooldown(arg_11_1)
	self:_update_animations(arg_11_1)
	self:_handle_input(arg_11_2, arg_11_1)
	self:_update_active_tab(arg_11_2, arg_11_1)
	self:_draw(arg_11_2, arg_11_1)
end

FriendsUIComponent._update_invite_cooldown = function (self, arg_12_1)
	-- function 12
	local _invite_cooldown = self._invite_cooldown

	for k, v in pairs(_invite_cooldown) do
		v = v - arg_12_1

		if v < 0 then
			_invite_cooldown[k] = nil
		else
			_invite_cooldown[k] = v
		end
	end
end

FriendsUIComponent._update_animations = function (self, arg_13_1)
	-- function 13
	self:_update_refresh_animations(arg_13_1)
end

FriendsUIComponent._update_refresh_animations = function (self, arg_14_1)
	-- function 14
	local refresh_button = self._widgets_by_name.refresh_button
	local content = refresh_button.content

	if not content.animate then
		local num = 0
		local pi = math.pi
		local num_2 = 20
		local rotate_progress = content.rotate_progress

		rotate_progress = rotate_progress or num

		local min = math.min(rotate_progress + arg_14_1 * num_2, pi)

		if min == pi then
			min = num
			content.animate = false
		end

		content.rotate_progress = min

		local style = refresh_button.style

		style.button_texture.angle = min
		style.button_texture_hover.angle = min
	end
end

FriendsUIComponent._handle_input = function (self, arg_15_1, arg_15_2)
	-- function 15
	local _widgets_by_name = self._widgets_by_name
	local _active = self._active

	if not self:_button_pressed(self._friends_button_widget.content.button_hotspot) then
		if not _active then
			self:deactivate_friends_ui()
		else
			self:activate_friends_ui()
		end
	end

	if not _active then
		local content = _widgets_by_name.hotspot_area.content

		if not arg_15_1:get("left_press") and content.is_hover and not self._friends_button_widget.content.button_hotspot.is_hover then
			content.disregard_exit = true
		end

		if not arg_15_1:get("left_release") then
			if content.disregard_exit or content.is_hover or not self._friends_button_widget.content.button_hotspot.is_hover then
				content.disregard_exit = nil
			else
				self:deactivate_friends_ui()
			end
		end

		if not self:_button_pressed(_widgets_by_name.exit_button.content) then
			self:deactivate_friends_ui()
		end

		if not self:_button_pressed(_widgets_by_name.refresh_button.content) then
			self:_animate_refresh_button(_widgets_by_name.refresh_button)
			self:_refresh_friends_list()
		end

		if not self:_button_pressed(_widgets_by_name.online_tab.content.button_hotspot) then
			self:_tab_pressed(_widgets_by_name.online_tab)
		end

		if not self:_button_pressed(_widgets_by_name.offline_tab.content.button_hotspot) then
			self:_tab_pressed(_widgets_by_name.offline_tab)
		end
	end
end

FriendsUIComponent._update_active_tab = function (self, arg_16_1, arg_16_2)
	-- function 16
	local _active_tab = self._active_tab

	if not _active_tab then
		return
	end

	local tabs_size = var_0_0.scenegraph_info.tabs_size
	local tabs_active_size = var_0_0.scenegraph_info.tabs_active_size
	local list_style = _active_tab.style.list_style
	local num = list_style.list_member_offset[2] * list_style.num_draws - (tabs_active_size[2] - tabs_size[2] - 10)
	local scenegraph_id = list_style.scenegraph_id
	local position = self._ui_scenegraph[scenegraph_id].position
	local num_2 = 1 - _active_tab.content.scrollbar.scroll_value

	position[2] = -tabs_size[2] + num * num_2

	self:_update_list(_active_tab)
	self:_handle_list_input(_active_tab)
end

FriendsUIComponent._animate_refresh_button = function (arg_17_0, arg_17_1)
	-- function 17
	arg_17_1.content.animate = true
end

local tbl_2 = {
	0,
	0
}

FriendsUIComponent._update_list = function (self, arg_18_1)
	-- function 18
	local list_style = arg_18_1.style.list_style
	local _get_mask_position_and_size, var_18_2 = self:_get_mask_position_and_size(arg_18_1)
	local get_world_position = UISceneGraph.get_world_position(self._ui_scenegraph, list_style.scenegraph_id)
	local get_size = UISceneGraph.get_size(self._ui_scenegraph, list_style.scenegraph_id)
	local list_content = arg_18_1.content.list_content
	local item_styles = list_style.item_styles
	local num_draws = list_style.num_draws
	local flag = false
	local matchmaking = Managers.matchmaking

	matchmaking = not matchmaking and Managers.matchmaking

	local flag_2 = not matchmaking and matchmaking.lobby:lobby_data("matchmaking_type")
	local get_current_mechanism = Managers.level_transition_handler:get_current_mechanism()
	local in_hub_level = Managers.level_transition_handler:in_hub_level()

	if get_current_mechanism == "versus" then
		if not in_hub_level then
			if not (not flag_2 and NetworkLookup.matchmaking_types[tonumber(flag_2)] ~= "versus") then
				flag = true
			end
		elseif not in_hub_level then
			local flag_3 = not matchmaking and matchmaking:search_info()

			if not matchmaking and not matchmaking:is_game_matchmaking() and not flag_3 and not flag_3.quick_game then
				flag = true
			end
		end
	end

	for i = 1, num_draws do
		local var_18_14 = list_content[i]
		local var_18_15 = item_styles[i]
		local size = var_18_15.size
		local list_member_offset = var_18_15.list_member_offset

		tbl_2[1] = get_world_position[1] + list_member_offset[1] * i + size[1] / 2
		tbl_2[2] = get_world_position[2] + get_size[2] + list_member_offset[2] * i

		local point_is_inside_2d_box = math.point_is_inside_2d_box(tbl_2, _get_mask_position_and_size, var_18_2)

		tbl_2[2] = tbl_2[2] + size[2] / 2

		local point_is_inside_2d_box_2 = math.point_is_inside_2d_box(tbl_2, _get_mask_position_and_size, var_18_2)

		tbl_2[2] = tbl_2[2] + size[2] / 2

		local point_is_inside_2d_box_3 = math.point_is_inside_2d_box(tbl_2, _get_mask_position_and_size, var_18_2)
		local flag_4 = point_is_inside_2d_box or point_is_inside_2d_box_3
		local playing_game_info = var_18_14.playing_game_info
		local flag_5 = false

		if not playing_game_info and playing_game_info.ip and not playing_game_info.server_port then
			flag_5 = true
		end

		var_18_14.visible = flag_4
		var_18_14.profile_button.visible = flag_4
		var_18_14.invite_button.visible = not flag_4 and not flag
		var_18_14.join_button.visible = not flag_4 and not not flag or not flag_5
	end
end

FriendsUIComponent._handle_list_input = function (self, arg_19_1)
	-- function 19
	local list_content = arg_19_1.content.list_content
	local num_draws = arg_19_1.style.list_style.num_draws

	for i = 1, num_draws do
		local var_19_2 = list_content[i]

		if not self:_button_pressed(var_19_2.invite_button) then
			self:_send_invite(var_19_2)
		end

		if not self:_button_pressed(var_19_2.profile_button) then
			self:_open_player_profile(var_19_2)
		end

		if not self:_button_pressed(var_19_2.join_button) then
			self:_join_player(var_19_2)
		end
	end
end

FriendsUIComponent._draw = function (self, arg_20_1, arg_20_2)
	-- function 20
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, arg_20_1, arg_20_2, nil, self._render_settings)
	UIRenderer.draw_widget(_ui_top_renderer, self._friends_button_widget)

	if not self._active then
		local _widgets = self._widgets

		for i, v in ipairs(_widgets) do
			UIRenderer.draw_widget(_ui_top_renderer, v)
		end
	end

	UIRenderer.end_pass(_ui_top_renderer)
end

FriendsUIComponent._tab_pressed = function (self, arg_21_1)
	-- function 21
	if self._active_tab == arg_21_1 then
		self:_deactivate_active_tab()
	else
		if not self._active_tab then
			self:_deactivate_active_tab()
		end

		self:_activate_tab(arg_21_1)
	end
end

FriendsUIComponent._activate_tab = function (self, arg_22_1)
	-- function 22
	self._active_tab = arg_22_1

	local scenegraph_id = arg_22_1.scenegraph_id
	local var_22_1 = self._ui_scenegraph[scenegraph_id]
	local tabs_active_size = var_0_0.scenegraph_info.tabs_active_size

	var_22_1.size[1] = tabs_active_size[1]
	var_22_1.size[2] = tabs_active_size[2]
	var_22_1.position[2] = -tabs_active_size[2]
	arg_22_1.content.active = true
	arg_22_1.content.list_content.active = true
	arg_22_1.style.drop_down_arrow.angle = math.pi

	local tabs_size = var_0_0.scenegraph_info.tabs_size

	arg_22_1.style.hotspot.offset[2] = tabs_active_size[2] - tabs_size[2]

	if arg_22_1.content.scrollbar.percentage < 1 then
		arg_22_1.content.scrollbar.active = true
	else
		arg_22_1.content.scrollbar.active = false
	end
end

FriendsUIComponent._deactivate_active_tab = function (self)
	-- function 23
	local _active_tab = self._active_tab

	self._active_tab = nil

	local scenegraph_id = _active_tab.scenegraph_id
	local var_23_2 = self._ui_scenegraph[scenegraph_id]
	local tabs_size = var_0_0.scenegraph_info.tabs_size

	var_23_2.size[1] = tabs_size[1]
	var_23_2.size[2] = tabs_size[2]
	var_23_2.position[2] = -tabs_size[2]
	_active_tab.content.active = false
	_active_tab.content.list_content.active = false
	_active_tab.content.scrollbar.active = false
	_active_tab.style.drop_down_arrow.angle = 0
	_active_tab.style.hotspot.offset[2] = 0
end

FriendsUIComponent._populate_tab = function (self, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	local content = arg_24_1.content
	local list_style = arg_24_1.style.list_style
	local list_content = content.list_content
	local item_styles = list_style.item_styles
	local allowed_to_initiate_join_lobby = Managers.matchmaking:allowed_to_initiate_join_lobby()
	local min = math.min(#arg_24_2, var_0_0.list_info.friend_list_limit)

	for i = 1, min do
		local var_24_6 = arg_24_2[i]
		local var_24_7 = list_content[i]

		var_24_7.name = UIRenderer.crop_text_width(self._ui_top_renderer, var_24_6.name, 200, item_styles[i].name)
		var_24_7.id = var_24_6.id

		local flag = false
		local playing_this_game = var_24_6.playing_this_game

		if not allowed_to_initiate_join_lobby and not playing_this_game then
			local playing_game = var_24_6.playing_game

			if not playing_game and playing_game.lobby and not playing_game.ip then
				flag = true
			end
		end

		var_24_7.invite_button.allow_invite = arg_24_3
		var_24_7.join_button.allow_join = flag

		if not flag then
			var_24_7.playing_game_info = var_24_6.playing_game
		end

		local var_24_11 = item_styles[i]

		if not playing_this_game then
			var_24_11.name.text_color = Colors.get_color_table_with_alpha("online_green", 255)
		elseif var_24_6.status ~= "offline" then
			var_24_11.name.text_color = Colors.get_color_table_with_alpha("white", 255)
		else
			var_24_11.name.text_color = Colors.get_color_table_with_alpha("font_default", 255)
		end
	end

	content.real_text = string.format("%s (%s)", content.text, tostring(min))
	list_style.num_draws = min

	self:_setup_tab_scrollbar(arg_24_1)
end

FriendsUIComponent._setup_tab_scrollbar = function (arg_25_0, arg_25_1)
	-- function 25
	local tabs_size = var_0_0.scenegraph_info.tabs_size
	local num = var_0_0.scenegraph_info.tabs_active_size[2] - tabs_size[2]
	local list_style = arg_25_1.style.list_style
	local var_25_3 = list_style.list_member_offset[2]
	local num_draws = list_style.num_draws
	local var_25_5

	if num_draws == 0 then
		var_25_5 = var_25_3
	else
		var_25_5 = var_25_3 * num_draws
	end

	local num_2 = num / var_25_5
	local scrollbar = arg_25_1.content.scrollbar

	if num_2 < 1 then
		scrollbar.percentage = num_2
		scrollbar.scroll_value = 1
		scrollbar.scroll_amount = var_25_3 / var_25_5
	else
		scrollbar.scroll_value = 1
	end
end

local tbl_3 = {
	0,
	0
}
local tbl_4 = {
	0,
	0,
	0
}

FriendsUIComponent._get_mask_position_and_size = function (self, arg_26_1)
	-- function 26
	local mask = arg_26_1.style.mask
	local size = mask.size

	tbl_3[1] = size[1]
	tbl_3[2] = size[2]

	local get_world_position = UISceneGraph.get_world_position(self._ui_scenegraph, arg_26_1.scenegraph_id)
	local offset = mask.offset

	tbl_4[1] = get_world_position[1] + offset[1]
	tbl_4[2] = get_world_position[2] + offset[2]
	tbl_4[3] = get_world_position[3] + offset[3]

	return tbl_4, tbl_3
end

FriendsUIComponent._send_invite = function (self, arg_27_1)
	-- function 27
	if not self._invite_cooldown[arg_27_1.id] then
		return
	end

	local id = arg_27_1.id
	local invite_target = self._network_lobby:invite_target()

	Managers.account:send_session_invitation(id, invite_target)

	self._invite_cooldown[id] = 5
end

FriendsUIComponent._open_player_profile = function (arg_28_0, arg_28_1)
	-- function 28
	local id = arg_28_1.id

	if not IS_PS4 then
		Managers.account:show_player_profile_with_account_id(id)
	else
		Managers.account:show_player_profile(id)
	end
end

FriendsUIComponent._join_player = function (self, arg_29_1)
	-- function 29
	local playing_game_info = arg_29_1.playing_game_info
	local lobby = playing_game_info.lobby
	local ip = playing_game_info.ip
	local server_port = playing_game_info.server_port

	if not lobby then
		local get_lobby_data_from_id = LobbyInternal.get_lobby_data_from_id(lobby)

		get_lobby_data_from_id.id = lobby
		self._join_lobby_data = get_lobby_data_from_id
	elseif not ip and not server_port then
		self._join_lobby_data = {
			server_info = {
				ip_port = ip .. ":" .. server_port
			}
		}
	end
end
