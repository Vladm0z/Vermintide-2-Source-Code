-- chunkname: @scripts/ui/views/friends_ui_component.lua

local var_0_0 = local_require("scripts/ui/views/friends_ui_component_definitions")
local var_0_1 = true

FriendsUIComponent = class(FriendsUIComponent)

FriendsUIComponent.init = function (arg_1_0, arg_1_1)
	arg_1_0._ui_top_renderer = arg_1_1.ui_top_renderer
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._network_lobby = arg_1_1.network_lobby
	arg_1_0._invite_cooldown = {}

	arg_1_0:_create_ui_elements()
end

FriendsUIComponent._create_ui_elements = function (arg_2_0)
	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local var_2_0 = var_0_0.widget_definitions
	local var_2_1 = {}
	local var_2_2 = {}

	for iter_2_0, iter_2_1 in pairs(var_2_0) do
		if iter_2_0 ~= "friends_button" then
			local var_2_3 = UIWidget.init(iter_2_1)

			var_2_1[#var_2_1 + 1] = var_2_3
			var_2_2[iter_2_0] = var_2_3
		end
	end

	arg_2_0._widgets = var_2_1
	arg_2_0._widgets_by_name = var_2_2
	arg_2_0._friends_button_widget = UIWidget.init(var_0_0.widget_definitions.friends_button)
end

FriendsUIComponent.is_active = function (arg_3_0)
	return arg_3_0._active
end

FriendsUIComponent.activate_friends_ui = function (arg_4_0)
	if IS_XB1 and not Managers.account:friends_list_initiated() then
		Managers.account:setup_friendslist()
	end

	arg_4_0._active = true

	arg_4_0:_refresh_friends_list()

	arg_4_0._widgets_by_name.hotspot_area.content.disregard_exit = nil
end

FriendsUIComponent.deactivate_friends_ui = function (arg_5_0)
	arg_5_0._active = false
end

FriendsUIComponent._refresh_friends_list = function (arg_6_0)
	local var_6_0 = {}
	local var_6_1 = arg_6_0._widgets_by_name

	arg_6_0:_populate_tab(var_6_1.online_tab, var_6_0)
	arg_6_0:_populate_tab(var_6_1.offline_tab, var_6_0)

	local var_6_2 = var_0_0.list_info.friend_list_limit

	Managers.account:get_friends(var_6_2, callback(arg_6_0, "cb_refresh_friends_done"))
end

FriendsUIComponent.join_lobby_data = function (arg_7_0)
	local var_7_0 = arg_7_0._join_lobby_data

	arg_7_0._join_lobby_data = nil

	return var_7_0
end

local var_0_2 = {}

FriendsUIComponent.cb_refresh_friends_done = function (arg_8_0, arg_8_1)
	arg_8_1 = arg_8_1 or var_0_2

	local var_8_0 = {}
	local var_8_1 = {}
	local var_8_2 = {}

	for iter_8_0, iter_8_1 in pairs(arg_8_1) do
		iter_8_1.id = iter_8_0

		if iter_8_1.status == "offline" then
			var_8_2[#var_8_2 + 1] = iter_8_1
		elseif iter_8_1.playing_this_game then
			var_8_0[#var_8_0 + 1] = iter_8_1
		else
			var_8_1[#var_8_1 + 1] = iter_8_1
		end
	end

	local function var_8_3(arg_9_0, arg_9_1)
		return arg_9_0.name < arg_9_1.name
	end

	table.sort(var_8_0, var_8_3)
	table.sort(var_8_1, var_8_3)
	table.sort(var_8_2, var_8_3)

	for iter_8_2 = 1, #var_8_1 do
		local var_8_4 = var_8_1[iter_8_2]

		var_8_0[#var_8_0 + 1] = var_8_4
	end

	local var_8_5 = arg_8_0._widgets_by_name

	arg_8_0:_populate_tab(var_8_5.online_tab, var_8_0, true)
	arg_8_0:_populate_tab(var_8_5.offline_tab, var_8_2, false)
end

FriendsUIComponent._button_pressed = function (arg_10_0, arg_10_1)
	if arg_10_1.on_release then
		arg_10_1.on_release = false

		return true
	end

	return false
end

FriendsUIComponent.update = function (arg_11_0, arg_11_1, arg_11_2)
	if var_0_1 then
		var_0_1 = false

		arg_11_0:_create_ui_elements()
	end

	arg_11_0:_update_invite_cooldown(arg_11_1)
	arg_11_0:_update_animations(arg_11_1)
	arg_11_0:_handle_input(arg_11_2, arg_11_1)
	arg_11_0:_update_active_tab(arg_11_2, arg_11_1)
	arg_11_0:_draw(arg_11_2, arg_11_1)
end

FriendsUIComponent._update_invite_cooldown = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0._invite_cooldown

	for iter_12_0, iter_12_1 in pairs(var_12_0) do
		iter_12_1 = iter_12_1 - arg_12_1

		if iter_12_1 < 0 then
			var_12_0[iter_12_0] = nil
		else
			var_12_0[iter_12_0] = iter_12_1
		end
	end
end

FriendsUIComponent._update_animations = function (arg_13_0, arg_13_1)
	arg_13_0:_update_refresh_animations(arg_13_1)
end

FriendsUIComponent._update_refresh_animations = function (arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0._widgets_by_name.refresh_button
	local var_14_1 = var_14_0.content

	if var_14_1.animate then
		local var_14_2 = 0
		local var_14_3 = math.pi
		local var_14_4 = 20
		local var_14_5 = var_14_1.rotate_progress or var_14_2
		local var_14_6 = math.min(var_14_5 + arg_14_1 * var_14_4, var_14_3)

		if var_14_6 == var_14_3 then
			var_14_6 = var_14_2
			var_14_1.animate = false
		end

		var_14_1.rotate_progress = var_14_6

		local var_14_7 = var_14_0.style

		var_14_7.button_texture.angle = var_14_6
		var_14_7.button_texture_hover.angle = var_14_6
	end
end

FriendsUIComponent._handle_input = function (arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0._widgets_by_name
	local var_15_1 = arg_15_0._active

	if arg_15_0:_button_pressed(arg_15_0._friends_button_widget.content.button_hotspot) then
		if var_15_1 then
			arg_15_0:deactivate_friends_ui()
		else
			arg_15_0:activate_friends_ui()
		end
	end

	if var_15_1 then
		local var_15_2 = var_15_0.hotspot_area.content

		if arg_15_1:get("left_press") and (var_15_2.is_hover or arg_15_0._friends_button_widget.content.button_hotspot.is_hover) then
			var_15_2.disregard_exit = true
		end

		if arg_15_1:get("left_release") then
			if var_15_2.disregard_exit or var_15_2.is_hover or arg_15_0._friends_button_widget.content.button_hotspot.is_hover then
				var_15_2.disregard_exit = nil
			else
				arg_15_0:deactivate_friends_ui()
			end
		end

		if arg_15_0:_button_pressed(var_15_0.exit_button.content) then
			arg_15_0:deactivate_friends_ui()
		end

		if arg_15_0:_button_pressed(var_15_0.refresh_button.content) then
			arg_15_0:_animate_refresh_button(var_15_0.refresh_button)
			arg_15_0:_refresh_friends_list()
		end

		if arg_15_0:_button_pressed(var_15_0.online_tab.content.button_hotspot) then
			arg_15_0:_tab_pressed(var_15_0.online_tab)
		end

		if arg_15_0:_button_pressed(var_15_0.offline_tab.content.button_hotspot) then
			arg_15_0:_tab_pressed(var_15_0.offline_tab)
		end
	end
end

FriendsUIComponent._update_active_tab = function (arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0._active_tab

	if not var_16_0 then
		return
	end

	local var_16_1 = var_0_0.scenegraph_info.tabs_size
	local var_16_2 = var_0_0.scenegraph_info.tabs_active_size
	local var_16_3 = var_16_0.style.list_style
	local var_16_4 = var_16_3.list_member_offset[2] * var_16_3.num_draws - (var_16_2[2] - var_16_1[2] - 10)
	local var_16_5 = var_16_3.scenegraph_id
	local var_16_6 = arg_16_0._ui_scenegraph[var_16_5].position
	local var_16_7 = 1 - var_16_0.content.scrollbar.scroll_value

	var_16_6[2] = -var_16_1[2] + var_16_4 * var_16_7

	arg_16_0:_update_list(var_16_0)
	arg_16_0:_handle_list_input(var_16_0)
end

FriendsUIComponent._animate_refresh_button = function (arg_17_0, arg_17_1)
	arg_17_1.content.animate = true
end

local var_0_3 = {
	0,
	0
}

FriendsUIComponent._update_list = function (arg_18_0, arg_18_1)
	local var_18_0 = arg_18_1.style.list_style
	local var_18_1, var_18_2 = arg_18_0:_get_mask_position_and_size(arg_18_1)
	local var_18_3 = UISceneGraph.get_world_position(arg_18_0._ui_scenegraph, var_18_0.scenegraph_id)
	local var_18_4 = UISceneGraph.get_size(arg_18_0._ui_scenegraph, var_18_0.scenegraph_id)
	local var_18_5 = arg_18_1.content.list_content
	local var_18_6 = var_18_0.item_styles
	local var_18_7 = var_18_0.num_draws
	local var_18_8 = false
	local var_18_9 = Managers.matchmaking and Managers.matchmaking
	local var_18_10 = var_18_9 and var_18_9.lobby:lobby_data("matchmaking_type")
	local var_18_11 = Managers.level_transition_handler:get_current_mechanism()
	local var_18_12 = Managers.level_transition_handler:in_hub_level()

	if var_18_11 == "versus" then
		if not var_18_12 then
			if var_18_10 and NetworkLookup.matchmaking_types[tonumber(var_18_10)] == "versus" then
				var_18_8 = true
			end
		elseif var_18_12 then
			local var_18_13 = var_18_9 and var_18_9:search_info()

			if var_18_9 and var_18_9:is_game_matchmaking() and var_18_13 and var_18_13.quick_game then
				var_18_8 = true
			end
		end
	end

	for iter_18_0 = 1, var_18_7 do
		local var_18_14 = var_18_5[iter_18_0]
		local var_18_15 = var_18_6[iter_18_0]
		local var_18_16 = var_18_15.size
		local var_18_17 = var_18_15.list_member_offset

		var_0_3[1] = var_18_3[1] + var_18_17[1] * iter_18_0 + var_18_16[1] / 2
		var_0_3[2] = var_18_3[2] + var_18_4[2] + var_18_17[2] * iter_18_0

		local var_18_18 = math.point_is_inside_2d_box(var_0_3, var_18_1, var_18_2)

		var_0_3[2] = var_0_3[2] + var_18_16[2] / 2

		local var_18_19 = math.point_is_inside_2d_box(var_0_3, var_18_1, var_18_2)

		var_0_3[2] = var_0_3[2] + var_18_16[2] / 2

		local var_18_20 = math.point_is_inside_2d_box(var_0_3, var_18_1, var_18_2)
		local var_18_21 = var_18_18 or var_18_20
		local var_18_22 = var_18_14.playing_game_info
		local var_18_23 = false

		if var_18_22 and (var_18_22.ip or var_18_22.server_port) then
			var_18_23 = true
		end

		var_18_14.visible = var_18_21
		var_18_14.profile_button.visible = var_18_21
		var_18_14.invite_button.visible = var_18_21 and not var_18_8
		var_18_14.join_button.visible = var_18_21 and not var_18_8 and not var_18_23
	end
end

FriendsUIComponent._handle_list_input = function (arg_19_0, arg_19_1)
	local var_19_0 = arg_19_1.content.list_content
	local var_19_1 = arg_19_1.style.list_style.num_draws

	for iter_19_0 = 1, var_19_1 do
		local var_19_2 = var_19_0[iter_19_0]

		if arg_19_0:_button_pressed(var_19_2.invite_button) then
			arg_19_0:_send_invite(var_19_2)
		end

		if arg_19_0:_button_pressed(var_19_2.profile_button) then
			arg_19_0:_open_player_profile(var_19_2)
		end

		if arg_19_0:_button_pressed(var_19_2.join_button) then
			arg_19_0:_join_player(var_19_2)
		end
	end
end

FriendsUIComponent._draw = function (arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_0._ui_top_renderer
	local var_20_1 = arg_20_0._ui_scenegraph

	UIRenderer.begin_pass(var_20_0, var_20_1, arg_20_1, arg_20_2, nil, arg_20_0._render_settings)
	UIRenderer.draw_widget(var_20_0, arg_20_0._friends_button_widget)

	if arg_20_0._active then
		local var_20_2 = arg_20_0._widgets

		for iter_20_0, iter_20_1 in ipairs(var_20_2) do
			UIRenderer.draw_widget(var_20_0, iter_20_1)
		end
	end

	UIRenderer.end_pass(var_20_0)
end

FriendsUIComponent._tab_pressed = function (arg_21_0, arg_21_1)
	if arg_21_0._active_tab == arg_21_1 then
		arg_21_0:_deactivate_active_tab()
	else
		if arg_21_0._active_tab then
			arg_21_0:_deactivate_active_tab()
		end

		arg_21_0:_activate_tab(arg_21_1)
	end
end

FriendsUIComponent._activate_tab = function (arg_22_0, arg_22_1)
	arg_22_0._active_tab = arg_22_1

	local var_22_0 = arg_22_1.scenegraph_id
	local var_22_1 = arg_22_0._ui_scenegraph[var_22_0]
	local var_22_2 = var_0_0.scenegraph_info.tabs_active_size

	var_22_1.size[1] = var_22_2[1]
	var_22_1.size[2] = var_22_2[2]
	var_22_1.position[2] = -var_22_2[2]
	arg_22_1.content.active = true
	arg_22_1.content.list_content.active = true
	arg_22_1.style.drop_down_arrow.angle = math.pi

	local var_22_3 = var_0_0.scenegraph_info.tabs_size

	arg_22_1.style.hotspot.offset[2] = var_22_2[2] - var_22_3[2]

	if arg_22_1.content.scrollbar.percentage < 1 then
		arg_22_1.content.scrollbar.active = true
	else
		arg_22_1.content.scrollbar.active = false
	end
end

FriendsUIComponent._deactivate_active_tab = function (arg_23_0)
	local var_23_0 = arg_23_0._active_tab

	arg_23_0._active_tab = nil

	local var_23_1 = var_23_0.scenegraph_id
	local var_23_2 = arg_23_0._ui_scenegraph[var_23_1]
	local var_23_3 = var_0_0.scenegraph_info.tabs_size

	var_23_2.size[1] = var_23_3[1]
	var_23_2.size[2] = var_23_3[2]
	var_23_2.position[2] = -var_23_3[2]
	var_23_0.content.active = false
	var_23_0.content.list_content.active = false
	var_23_0.content.scrollbar.active = false
	var_23_0.style.drop_down_arrow.angle = 0
	var_23_0.style.hotspot.offset[2] = 0
end

FriendsUIComponent._populate_tab = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	local var_24_0 = arg_24_1.content
	local var_24_1 = arg_24_1.style.list_style
	local var_24_2 = var_24_0.list_content
	local var_24_3 = var_24_1.item_styles
	local var_24_4 = Managers.matchmaking:allowed_to_initiate_join_lobby()
	local var_24_5 = math.min(#arg_24_2, var_0_0.list_info.friend_list_limit)

	for iter_24_0 = 1, var_24_5 do
		local var_24_6 = arg_24_2[iter_24_0]
		local var_24_7 = var_24_2[iter_24_0]

		var_24_7.name = UIRenderer.crop_text_width(arg_24_0._ui_top_renderer, var_24_6.name, 200, var_24_3[iter_24_0].name)
		var_24_7.id = var_24_6.id

		local var_24_8 = false
		local var_24_9 = var_24_6.playing_this_game

		if var_24_4 and var_24_9 then
			local var_24_10 = var_24_6.playing_game

			if var_24_10 and (var_24_10.lobby or var_24_10.ip) then
				var_24_8 = true
			end
		end

		var_24_7.invite_button.allow_invite = arg_24_3
		var_24_7.join_button.allow_join = var_24_8

		if var_24_8 then
			var_24_7.playing_game_info = var_24_6.playing_game
		end

		local var_24_11 = var_24_3[iter_24_0]

		if var_24_9 then
			var_24_11.name.text_color = Colors.get_color_table_with_alpha("online_green", 255)
		elseif var_24_6.status ~= "offline" then
			var_24_11.name.text_color = Colors.get_color_table_with_alpha("white", 255)
		else
			var_24_11.name.text_color = Colors.get_color_table_with_alpha("font_default", 255)
		end
	end

	var_24_0.real_text = string.format("%s (%s)", var_24_0.text, tostring(var_24_5))
	var_24_1.num_draws = var_24_5

	arg_24_0:_setup_tab_scrollbar(arg_24_1)
end

FriendsUIComponent._setup_tab_scrollbar = function (arg_25_0, arg_25_1)
	local var_25_0 = var_0_0.scenegraph_info.tabs_size
	local var_25_1 = var_0_0.scenegraph_info.tabs_active_size[2] - var_25_0[2]
	local var_25_2 = arg_25_1.style.list_style
	local var_25_3 = var_25_2.list_member_offset[2]
	local var_25_4 = var_25_2.num_draws
	local var_25_5

	if var_25_4 == 0 then
		var_25_5 = var_25_3
	else
		var_25_5 = var_25_3 * var_25_4
	end

	local var_25_6 = var_25_1 / var_25_5
	local var_25_7 = arg_25_1.content.scrollbar

	if var_25_6 < 1 then
		var_25_7.percentage = var_25_6
		var_25_7.scroll_value = 1
		var_25_7.scroll_amount = var_25_3 / var_25_5
	else
		var_25_7.scroll_value = 1
	end
end

local var_0_4 = {
	0,
	0
}
local var_0_5 = {
	0,
	0,
	0
}

FriendsUIComponent._get_mask_position_and_size = function (arg_26_0, arg_26_1)
	local var_26_0 = arg_26_1.style.mask
	local var_26_1 = var_26_0.size

	var_0_4[1] = var_26_1[1]
	var_0_4[2] = var_26_1[2]

	local var_26_2 = UISceneGraph.get_world_position(arg_26_0._ui_scenegraph, arg_26_1.scenegraph_id)
	local var_26_3 = var_26_0.offset

	var_0_5[1] = var_26_2[1] + var_26_3[1]
	var_0_5[2] = var_26_2[2] + var_26_3[2]
	var_0_5[3] = var_26_2[3] + var_26_3[3]

	return var_0_5, var_0_4
end

FriendsUIComponent._send_invite = function (arg_27_0, arg_27_1)
	if arg_27_0._invite_cooldown[arg_27_1.id] then
		return
	end

	local var_27_0 = arg_27_1.id
	local var_27_1 = arg_27_0._network_lobby:invite_target()

	Managers.account:send_session_invitation(var_27_0, var_27_1)

	arg_27_0._invite_cooldown[var_27_0] = 5
end

FriendsUIComponent._open_player_profile = function (arg_28_0, arg_28_1)
	local var_28_0 = arg_28_1.id

	if IS_PS4 then
		Managers.account:show_player_profile_with_account_id(var_28_0)
	else
		Managers.account:show_player_profile(var_28_0)
	end
end

FriendsUIComponent._join_player = function (arg_29_0, arg_29_1)
	local var_29_0 = arg_29_1.playing_game_info
	local var_29_1 = var_29_0.lobby
	local var_29_2 = var_29_0.ip
	local var_29_3 = var_29_0.server_port

	if var_29_1 then
		local var_29_4 = LobbyInternal.get_lobby_data_from_id(var_29_1)

		var_29_4.id = var_29_1
		arg_29_0._join_lobby_data = var_29_4
	elseif var_29_2 and var_29_3 then
		arg_29_0._join_lobby_data = {
			server_info = {
				ip_port = var_29_2 .. ":" .. var_29_3
			}
		}
	end
end
