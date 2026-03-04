-- chunkname: @scripts/ui/views/console_friends_view.lua

local var_0_0 = local_require("scripts/ui/views/console_friends_view_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.widget_definitions
local var_0_3 = var_0_0.generic_input_actions
local var_0_4 = var_0_0.entry_definitions
local var_0_5 = true
local var_0_6 = 5
local var_0_7 = 12

ConsoleFriendsView = class(ConsoleFriendsView)

function ConsoleFriendsView.init(arg_1_0, arg_1_1)
	arg_1_0._ingame_ui_context = arg_1_1
	arg_1_0._ingame_ui = arg_1_1.ingame_ui
	arg_1_0._ui_top_renderer = arg_1_1.ui_top_renderer
	arg_1_0._ui_renderer = arg_1_1.ui_renderer
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._network_lobby = arg_1_1.network_lobby
	arg_1_0._invite_cooldown = {}
	arg_1_0._cursor_position = 1
	arg_1_0._hold_down_timer = 0
	arg_1_0._hold_up_timer = 0
	arg_1_0._is_in_inn = arg_1_1.is_in_inn
	arg_1_0._is_server = arg_1_1.is_server

	if GLOBAL_MUSIC_WORLD then
		arg_1_0._wwise_world = MUSIC_WWISE_WORLD
	else
		local var_1_0 = arg_1_1.world_manager:world("music_world")

		arg_1_0._wwise_world = Managers.world:wwise_world(var_1_0)
	end

	arg_1_0:_setup_input(arg_1_1)
	arg_1_0:_create_ui_elements()

	arg_1_0._menu_input_description = MenuInputDescriptionUI:new(arg_1_1, arg_1_0._ui_top_renderer, arg_1_0:input_service(), 7, 900, var_0_3.default, true)

	arg_1_0._menu_input_description:set_input_description(nil)

	arg_1_0._current_input_desc = nil
	arg_1_0._friend_list_widgets = {}
end

function ConsoleFriendsView.on_enter(arg_2_0)
	arg_2_0._input_manager:block_device_except_service("console_friends_view", "keyboard", 1)
	arg_2_0._input_manager:block_device_except_service("console_friends_view", "mouse", 1)
	arg_2_0._input_manager:block_device_except_service("console_friends_view", "gamepad", 1)

	local var_2_0 = Managers.world:has_world("character_preview") and Managers.world:world("character_preview")
	local var_2_1 = var_2_0 and World.get_data(var_2_0, "shading_environment")

	if var_2_1 then
		World.set_data(var_2_0, "avoid_blend", true)
		ShadingEnvironment.set_scalar(var_2_1, "fullscreen_blur_enabled", 1)
		ShadingEnvironment.set_scalar(var_2_1, "fullscreen_blur_amount", 0.7)
		ShadingEnvironment.apply(var_2_1)
	end

	local var_2_2 = Managers.world:world("top_ingame_view")

	World.set_data(var_2_2, "avoid_blend", false)

	arg_2_0._active = true

	if IS_XB1 and not Managers.account:friends_list_initiated() then
		Managers.account:setup_friendslist()
	end

	arg_2_0:_create_ui_elements()
	arg_2_0:_setup_party_entries()
	arg_2_0:_refresh_friends()

	arg_2_0._refresh_friends_timer = nil
end

function ConsoleFriendsView._join_game(arg_3_0)
	if arg_3_0.network_server and not arg_3_0.network_server:are_all_peers_ingame(nil, true) then
		arg_3_0._popup_id = Managers.popup:queue_popup(Localize("popup_join_blocked_by_joining_player"), Localize("popup_invite_not_installed_header"), "ok", Localize("menu_ok"))
	else
		local var_3_0 = arg_3_0._current_friend_index
		local var_3_1 = arg_3_0._friend_list_widgets[arg_3_0._current_friend_index]

		if var_3_1 then
			local var_3_2 = var_3_1.content.friend
			local var_3_3 = var_3_2 and var_3_2.room_id

			if var_3_3 then
				local var_3_4 = {
					id = var_3_3
				}

				if arg_3_0._ingame_ui_context.network_lobby:id() == var_3_3 then
					arg_3_0._popup_id = Managers.popup:queue_popup(Localize("popup_already_in_same_lobby"), Localize("popup_invite_not_installed_header"), "ok", Localize("menu_ok"))

					return
				end

				if not arg_3_0._is_server or not arg_3_0._is_in_inn then
					arg_3_0._ingame_ui:handle_transition("join_lobby", var_3_4)
				else
					Managers.matchmaking:request_join_lobby(var_3_4, {
						friend_join = true
					})
				end
			end
		end
	end
end

function ConsoleFriendsView._refresh_friends(arg_4_0)
	arg_4_0._is_refreshing = true

	if IS_XB1 then
		Managers.account:get_friends(1000, callback(arg_4_0, "cb_friends_collected"))
	elseif IS_PS4 then
		Managers.account:get_friends(2000, callback(arg_4_0, "cb_friends_collected"))
	end

	arg_4_0._widgets_by_name.loading_icon.style.loading_icon.color[1] = 255
end

local var_0_8 = {}

function ConsoleFriendsView.cb_friends_collected(arg_5_0, arg_5_1)
	arg_5_1 = arg_5_1 or var_0_8

	local var_5_0 = arg_5_0._friend_list_widgets

	table.clear(var_5_0)

	local var_5_1 = {}
	local var_5_2 = {}
	local var_5_3 = {}

	for iter_5_0, iter_5_1 in pairs(arg_5_1) do
		iter_5_1.id = iter_5_0

		if iter_5_1.status == "offline" then
			var_5_3[#var_5_3 + 1] = iter_5_1
		elseif iter_5_1.playing_this_game then
			var_5_1[#var_5_1 + 1] = iter_5_1
		else
			var_5_2[#var_5_2 + 1] = iter_5_1
		end
	end

	local function var_5_4(arg_6_0, arg_6_1)
		return arg_6_0.name < arg_6_1.name
	end

	table.sort(var_5_1, var_5_4)
	table.sort(var_5_2, var_5_4)
	table.sort(var_5_3, var_5_4)

	local var_5_5 = var_0_4.friend_entry_size[2]
	local var_5_6 = -var_5_5

	for iter_5_2, iter_5_3 in pairs(var_5_1) do
		var_5_0[#var_5_0 + 1] = UIWidget.init(var_0_4.create_friend_entry(iter_5_3.name, true, var_5_6, iter_5_3))
		var_5_6 = var_5_6 - var_5_5
	end

	for iter_5_4, iter_5_5 in pairs(var_5_2) do
		var_5_0[#var_5_0 + 1] = UIWidget.init(var_0_4.create_friend_entry(iter_5_5.name, true, var_5_6, iter_5_5))
		var_5_6 = var_5_6 - var_5_5
	end

	for iter_5_6, iter_5_7 in pairs(var_5_3) do
		var_5_0[#var_5_0 + 1] = UIWidget.init(var_0_4.create_friend_entry(iter_5_7.name, false, var_5_6, iter_5_7))
		var_5_6 = var_5_6 - var_5_5
	end

	print(string.format("Added %s friends", #var_5_0))

	local var_5_7 = arg_5_0._widgets_by_name.loading_icon

	arg_5_0._ui_animations.loading_icon_fade = UIAnimation.init(UIAnimation.function_by_time, var_5_7.style.loading_icon.color, 1, 255, 0, 0.5, math.easeOutCubic)
	arg_5_0._is_refreshing = false
end

function ConsoleFriendsView.on_exit(arg_7_0)
	arg_7_0._input_manager:device_unblock_all_services("keyboard", 1)
	arg_7_0._input_manager:device_unblock_all_services("mouse", 1)
	arg_7_0._input_manager:device_unblock_all_services("gamepad", 1)

	local var_7_0 = Managers.world:has_world("character_preview") and Managers.world:world("character_preview")

	if var_7_0 then
		World.set_data(var_7_0, "avoid_blend", false)
	end

	if arg_7_0._popup_id then
		Managers.popup:cancel_popup(arg_7_0._popup_id)

		arg_7_0._popup_id = nil
	end

	arg_7_0._exiting = nil
	arg_7_0._active = nil
end

function ConsoleFriendsView.exit(arg_8_0)
	local var_8_0 = "ingame_menu"

	arg_8_0._ingame_ui:transition_with_fade(var_8_0)
	WwiseWorld.trigger_event(arg_8_0._wwise_world, "Play_hud_button_close")

	arg_8_0._exiting = true
end

function ConsoleFriendsView.transitioning(arg_9_0)
	if arg_9_0._exiting then
		return true
	else
		return not arg_9_0._active
	end
end

function ConsoleFriendsView._setup_input(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1.input_manager

	var_10_0:create_input_service("console_friends_view", "IngameMenuKeymaps", "IngameMenuFilters")
	var_10_0:map_device_to_service("console_friends_view", "keyboard")
	var_10_0:map_device_to_service("console_friends_view", "mouse")
	var_10_0:map_device_to_service("console_friends_view", "gamepad")

	arg_10_0._input_manager = var_10_0
end

function ConsoleFriendsView._create_ui_elements(arg_11_0)
	UIRenderer.clear_scenegraph_queue(arg_11_0._ui_top_renderer)

	arg_11_0._wanted_pos = var_0_1.friends_base.position[2]
	arg_11_0._current_friend_index = 1
	arg_11_0._ui_animations = {}
	arg_11_0._ui_animations = {}
	arg_11_0._cursor_position = 1

	local var_11_0 = {}
	local var_11_1 = {}

	for iter_11_0, iter_11_1 in pairs(var_0_2) do
		local var_11_2 = UIWidget.init(iter_11_1)

		var_11_0[#var_11_0 + 1] = var_11_2
		var_11_1[iter_11_0] = var_11_2
	end

	arg_11_0._widgets = var_11_0
	arg_11_0._widgets_by_name = var_11_1
	arg_11_0._widgets_by_name.friends_bg.style.background.color = {
		255,
		128,
		128,
		128
	}

	arg_11_0:_setup_party_entries()

	arg_11_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	var_0_5 = false
end

function ConsoleFriendsView._sorted_players(arg_12_0)
	local var_12_0 = Managers.player:human_players()
	local var_12_1 = {}

	for iter_12_0, iter_12_1 in pairs(var_12_0) do
		var_12_1[#var_12_1 + 1] = iter_12_1
	end

	local function var_12_2(arg_13_0, arg_13_1)
		return (arg_13_0:profile_index() or -1) < (arg_13_1:profile_index() or -1)
	end

	local var_12_3 = FindProfileIndex("spectator")

	if var_12_3 then
		table.array_remove_if(var_12_1, function(arg_14_0)
			return arg_14_0:profile_index() == var_12_3
		end)
	end

	table.sort(var_12_1, var_12_2)

	return var_12_1
end

function ConsoleFriendsView._setup_party_entries(arg_15_0)
	arg_15_0._party_entries = {}

	local var_15_0 = arg_15_0:_sorted_players()
	local var_15_1 = -40

	for iter_15_0, iter_15_1 in ipairs(var_15_0) do
		local var_15_2 = iter_15_1:name()
		local var_15_3

		if iter_15_1.local_player then
			var_15_3 = iter_15_1:career_name()
		else
			local var_15_4 = iter_15_1.player_unit

			if Unit.alive(var_15_4) then
				var_15_3 = ScriptUnit.extension(var_15_4, "career_system"):career_name()
			end
		end

		local var_15_5 = CareerSettings[var_15_3]

		arg_15_0._party_entries[#arg_15_0._party_entries + 1] = UIWidget.init(var_0_4.create_party_entry(var_15_2, var_15_5, var_15_1 * iter_15_0))
	end

	local var_15_6 = 4 - #arg_15_0._party_entries

	for iter_15_2 = 1, var_15_6 do
		arg_15_0._party_entries[#arg_15_0._party_entries + 1] = UIWidget.init(var_0_4.create_party_entry(nil, nil, var_15_1 * (#arg_15_0._party_entries + 1)))
	end
end

function ConsoleFriendsView.update(arg_16_0, arg_16_1, arg_16_2)
	if var_0_5 then
		arg_16_0:_create_ui_elements()
	end

	if arg_16_0._popup_id then
		arg_16_0:_handle_popup()
	else
		arg_16_0:_update_input_descriptions(arg_16_1, arg_16_2)
		arg_16_0:_handle_input(arg_16_1, arg_16_2)
		arg_16_0:_update_animations(arg_16_1, arg_16_2)
		arg_16_0:_handle_refresh(arg_16_1, arg_16_2)
		arg_16_0:_animate_default_buttons(arg_16_1, arg_16_2)
		arg_16_0:_draw(arg_16_1, arg_16_2)
	end
end

function ConsoleFriendsView._update_input_descriptions(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_0._friend_list_widgets[arg_17_0._current_friend_index]
	local var_17_1 = false
	local var_17_2 = false

	if var_17_0 then
		local var_17_3 = var_17_0.content.friend
		local var_17_4 = var_17_3.xbox_user_id
		local var_17_5 = var_17_3.status == "online"
		local var_17_6 = (not arg_17_0._invite_cooldown[var_17_4] or arg_17_2 > arg_17_0._invite_cooldown[var_17_4]) and var_17_5 and Managers.account:has_session() and "invite" or nil
		local var_17_7 = not arg_17_0._is_refreshing and "refresh"

		if IS_PS4 and var_17_7 and not var_17_5 then
			var_17_7 = nil
		end

		local var_17_8 = "friend"

		if var_17_6 then
			var_17_8 = var_17_8 .. "_" .. var_17_6

			if var_17_7 then
				var_17_8 = var_17_8 .. "_" .. var_17_7
			end
		elseif var_17_7 then
			var_17_8 = var_17_8 .. "_" .. var_17_7
		end

		if var_17_8 then
			arg_17_0._menu_input_description:set_input_description(var_0_3[var_17_8])
		else
			arg_17_0._menu_input_description:set_input_description(nil)
		end

		var_17_1 = true
		var_17_2 = var_17_6 ~= nil
		arg_17_0._current_input_desc = var_17_8
	elseif IS_XB1 then
		local var_17_9 = not arg_17_0._is_refreshing and "only_refresh"

		if arg_17_0._current_input_desc ~= var_17_9 then
			local var_17_10 = var_17_9 and var_0_3[var_17_9]

			arg_17_0._menu_input_description:set_input_description(var_17_10)

			arg_17_0._current_input_desc = var_17_9
		end
	elseif arg_17_0._current_input_desc then
		arg_17_0._menu_input_description:set_input_description(nil)

		arg_17_0._current_input_desc = nil
	end

	local var_17_11 = arg_17_0._widgets_by_name.open_profile_button

	if var_17_11 then
		var_17_11.content.button_hotspot.disable_button = not var_17_1
	end

	local var_17_12 = arg_17_0._widgets_by_name.invite_button

	if var_17_12 then
		var_17_12.content.button_hotspot.disable_button = not var_17_2
	end
end

function ConsoleFriendsView._handle_refresh(arg_18_0, arg_18_1, arg_18_2)
	if IS_PS4 then
		arg_18_0._refresh_friends_timer = arg_18_0._refresh_friends_timer or arg_18_2 + var_0_7

		if arg_18_2 > arg_18_0._refresh_friends_timer then
			arg_18_0:_refresh_friends()

			arg_18_0._refresh_friends_timer = arg_18_2 + var_0_7
		end
	end
end

function ConsoleFriendsView._animate_default_buttons(arg_19_0, arg_19_1, arg_19_2)
	if not Managers.input:is_device_active("gamepad") then
		local var_19_0 = arg_19_0._widgets_by_name.open_profile_button
		local var_19_1 = arg_19_0._widgets_by_name.invite_button

		UIWidgetUtils.animate_default_button(var_19_0, arg_19_1)
		UIWidgetUtils.animate_default_button(var_19_1, arg_19_1)
	end
end

function ConsoleFriendsView._handle_input(arg_20_0, arg_20_1, arg_20_2)
	if arg_20_0._exiting then
		return
	end

	local var_20_0 = arg_20_0:input_service()

	arg_20_0._ui_animations = arg_20_0._ui_animations or {}

	local var_20_1 = var_0_4.friend_entry_size[2]
	local var_20_2 = var_0_1.friends_base.position[2]

	arg_20_0._wanted_pos = arg_20_0._wanted_pos or var_20_2
	arg_20_0._current_friend_index = arg_20_0._current_friend_index or 1

	local var_20_3 = arg_20_0._current_friend_index
	local var_20_4 = 0
	local var_20_5 = 0
	local var_20_6 = Managers.input:is_device_active("gamepad")
	local var_20_7 = arg_20_0._widgets_by_name.open_profile_button.content.button_hotspot.on_pressed
	local var_20_8 = arg_20_0._widgets_by_name.invite_button.content.button_hotspot.on_pressed
	local var_20_9 = arg_20_0._widgets_by_name.selection_handler.content
	local var_20_10 = var_20_9.up_hotspot
	local var_20_11 = var_20_9.down_hotspot

	if var_20_0:get("move_up_hold") or var_20_10.is_held then
		var_20_5 = arg_20_0._hold_up_timer + arg_20_1
	elseif var_20_0:get("move_down_hold") or var_20_11.is_held then
		var_20_4 = arg_20_0._hold_down_timer + arg_20_1
	end

	arg_20_0._hold_down_timer = var_20_4
	arg_20_0._hold_up_timer = var_20_5

	local var_20_12 = #arg_20_0._friend_list_widgets
	local var_20_13 = var_0_0.num_visible_friends
	local var_20_14 = var_20_0:get("scroll_axis")

	if IS_XB1 then
		var_20_14 = var_20_14 and math.sign(var_20_14.x)
	else
		var_20_14 = var_20_14 and math.sign(var_20_14.y)
	end

	if var_20_0:get("back", true) or var_20_0:get("toggle_menu", true) then
		arg_20_0:exit()
	elseif var_20_0:get("refresh") or var_20_8 then
		local var_20_15 = arg_20_0._friend_list_widgets[arg_20_0._current_friend_index]

		if var_20_15 then
			arg_20_0:_send_invite(var_20_15, arg_20_2)
		end
	elseif var_20_0:get("special_1") and not arg_20_0._is_refreshing then
		if IS_XB1 then
			arg_20_0:_refresh_friends()
		elseif IS_PS4 then
			arg_20_0:_join_game()
		end
	elseif var_20_0:get("confirm_press") or var_20_7 then
		local var_20_16 = arg_20_0._friend_list_widgets[arg_20_0._current_friend_index]

		if var_20_16 then
			arg_20_0:_open_profile(var_20_16)
		end
	elseif var_20_0:get("move_down") or arg_20_0._hold_down_timer > 0.5 or var_20_11.on_pressed or var_20_11.on_double_click or var_20_14 < 0 then
		if arg_20_0._hold_down_timer > 0.5 then
			arg_20_0._hold_down_timer = 0.4
		end

		arg_20_0._current_friend_index = math.clamp(arg_20_0._current_friend_index + 1, 1, var_20_12)
		arg_20_0._cursor_position = math.clamp(arg_20_0._cursor_position + 1, 1, math.min(var_20_13, var_20_12))

		if arg_20_0._cursor_position == var_20_13 then
			local var_20_17 = arg_20_0._wanted_pos

			arg_20_0._wanted_pos = math.clamp(arg_20_0._wanted_pos + var_20_1, var_20_2, var_20_12 * var_20_1 + var_20_1)
			arg_20_0._ui_animations.move = UIAnimation.init(UIAnimation.function_by_time, arg_20_0._ui_scenegraph.friends_base.position, 2, arg_20_0._ui_scenegraph.friends_base.position[2], arg_20_0._wanted_pos, 0.3, math.easeOutCubic)

			if arg_20_0._wanted_pos ~= var_20_17 then
				arg_20_0._cursor_position = math.clamp(arg_20_0._cursor_position - 1, 1, var_20_13)
			end
		end
	elseif var_20_0:get("move_up") or arg_20_0._hold_up_timer > 0.5 or var_20_10.on_pressed or var_20_10.on_double_click or var_20_14 > 0 then
		if arg_20_0._hold_up_timer > 0.5 then
			arg_20_0._hold_up_timer = 0.4
		end

		arg_20_0._current_friend_index = math.clamp(arg_20_0._current_friend_index - 1, 1, var_20_12)
		arg_20_0._cursor_position = math.clamp(arg_20_0._cursor_position - 1, 1, math.min(var_20_13, var_20_12))

		if arg_20_0._cursor_position <= 2 and var_20_13 < var_20_12 then
			local var_20_18 = arg_20_0._wanted_pos

			arg_20_0._wanted_pos = math.clamp(arg_20_0._wanted_pos - var_20_1, var_20_2, var_20_12 * var_20_1 + var_20_1)
			arg_20_0._ui_animations.move = UIAnimation.init(UIAnimation.function_by_time, arg_20_0._ui_scenegraph.friends_base.position, 2, arg_20_0._ui_scenegraph.friends_base.position[2], arg_20_0._wanted_pos, 0.3, math.easeOutCubic)

			if arg_20_0._wanted_pos ~= var_20_18 then
				arg_20_0._cursor_position = math.clamp(arg_20_0._cursor_position + 1, 1, var_20_13)
			end
		end
	elseif not var_20_6 and not IS_PS4 then
		local var_20_19 = math.clamp(arg_20_0._current_friend_index - (arg_20_0._cursor_position - 1), 1, math.max(var_20_12 - (var_20_13 - 1), 1))
		local var_20_20 = math.clamp(var_20_19 + var_20_13 - 1, 1, var_20_12)

		for iter_20_0 = var_20_19, var_20_20 do
			if arg_20_0._friend_list_widgets[iter_20_0].content.entry_hotspot.on_pressed then
				arg_20_0._current_friend_index = iter_20_0
				arg_20_0._cursor_position = iter_20_0 - (var_20_19 - 1)

				break
			end
		end
	end

	local var_20_21 = arg_20_0._friend_list_widgets[var_20_3]

	if var_20_21 then
		var_20_21.content.selected = false
	end

	local var_20_22 = arg_20_0._friend_list_widgets[arg_20_0._current_friend_index]

	if var_20_22 then
		var_20_22.content.selected = true
	end
end

function ConsoleFriendsView._update_animations(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_0._ui_animations

	for iter_21_0, iter_21_1 in pairs(var_21_0) do
		UIAnimation.update(iter_21_1, arg_21_1)

		if UIAnimation.completed(iter_21_1) then
			var_21_0[iter_21_0] = nil
		end
	end
end

function ConsoleFriendsView._draw(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_0._ui_scenegraph
	local var_22_1 = arg_22_0._ui_top_renderer
	local var_22_2 = arg_22_0:input_service()
	local var_22_3 = arg_22_0._input_manager:is_device_active("gamepad")

	UIRenderer.begin_pass(var_22_1, var_22_0, var_22_2, arg_22_1, nil, arg_22_0._render_settings)

	for iter_22_0, iter_22_1 in ipairs(arg_22_0._widgets) do
		UIRenderer.draw_widget(var_22_1, iter_22_1)
	end

	for iter_22_2, iter_22_3 in ipairs(arg_22_0._party_entries) do
		UIRenderer.draw_widget(var_22_1, iter_22_3)
	end

	if arg_22_0._friend_list_widgets then
		local var_22_4 = table.clone(var_22_0.friends_mask.world_position)[2]
		local var_22_5 = var_22_4 + var_0_4.friend_entry_size[2]
		local var_22_6 = var_22_4 - (var_0_0.num_visible_friends + 1) * var_0_4.friend_entry_size[2]

		for iter_22_4, iter_22_5 in ipairs(arg_22_0._friend_list_widgets) do
			local var_22_7 = var_22_0.friends_base.position[2] + iter_22_5.offset[2]

			if var_22_7 <= var_22_5 and var_22_6 <= var_22_7 then
				UIRenderer.draw_widget(var_22_1, iter_22_5)
			end
		end
	end

	UIRenderer.end_pass(var_22_1)

	if var_22_3 then
		arg_22_0._menu_input_description:draw(var_22_1, arg_22_1)
	end
end

function ConsoleFriendsView._handle_popup(arg_23_0)
	local var_23_0, var_23_1 = Managers.popup:query_result(arg_23_0._popup_id)

	if var_23_0 then
		if var_23_0 == "ok" then
			arg_23_0._popup_id = nil
		else
			fassert(false, "[ConsoleFriendsView:_handle_popup] No implementation for the result %q", var_23_0)
		end
	end
end

function ConsoleFriendsView.destroy(arg_24_0)
	return
end

function ConsoleFriendsView.input_service(arg_25_0)
	return arg_25_0._input_manager:get_service("console_friends_view")
end

function ConsoleFriendsView._open_profile(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_1.content.friend.id

	if IS_XB1 then
		Managers.account:show_player_profile(var_26_0)
	elseif IS_PS4 then
		Managers.account:show_player_profile_with_account_id(var_26_0)
	end
end

function ConsoleFriendsView._send_invite(arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = arg_27_1.content.friend.id
	local var_27_1 = arg_27_0._invite_cooldown[var_27_0]

	if arg_27_0._invite_cooldown[var_27_0] and arg_27_2 < arg_27_0._invite_cooldown[var_27_0] or not Managers.account:has_session() then
		return
	end

	arg_27_0._network_lobby = arg_27_0._ingame_ui_context.network_lobby

	local var_27_2 = arg_27_0._network_lobby:invite_target()

	Managers.account:send_session_invitation(var_27_0, var_27_2)

	arg_27_0._invite_cooldown[var_27_0] = arg_27_2 + var_0_6
	arg_27_0._ui_animations["fade_invite_" .. var_27_0] = UIAnimation.init(UIAnimation.function_by_time, arg_27_1.style.invite_texture.color, 1, 255, 0, 1, math.easeInCubic)
	arg_27_0._ui_animations["move_invite_" .. var_27_0] = UIAnimation.init(UIAnimation.function_by_time, arg_27_1.style.invite_texture.offset, 1, 40, 70, 1, math.easeInCubic)
end

function ConsoleFriendsView.cleanup_popups(arg_28_0)
	if arg_28_0._popup_id then
		Managers.popup:cancel_popup(arg_28_0._popup_id)

		arg_28_0._popup_id = nil
	end
end
