-- chunkname: @scripts/ui/views/ingame_view_layout_logic.lua

IngameViewLayoutLogic = class(IngameViewLayoutLogic)

IngameViewLayoutLogic.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	self._menu_layouts = arg_1_3
	self._full_access_layout = arg_1_4
	self.ingame_ui = arg_1_1.ingame_ui
	self._params = arg_1_2

	local is_in_inn = arg_1_1.is_in_inn

	self.is_server = arg_1_1.is_server

	local in_menu

	if not is_in_inn then
		in_menu = arg_1_3.in_menu

		if not in_menu then
			-- Nothing
		end
	end

	in_menu = arg_1_3.in_game

	::label_1_0::

	self.layout_list = in_menu
end

IngameViewLayoutLogic.setup_button_layout = function (self, arg_2_1)
	-- function 2
	local active_button_data = self.active_button_data

	if not active_button_data then
		table.clear(active_button_data)
	else
		self.active_button_data = {}
		active_button_data = self.active_button_data
	end

	local _params = self._params

	for i, v in ipairs(arg_2_1) do
		if not v.can_add_function and not v.can_add_function(_params) then
			local display_name = v.display_name
			local display_name_func = v.display_name_func
			local url = v.url
			local callback = v.callback
			local transition = v.transition
			local transition_state = v.transition_state
			local transition_sub_state = v.transition_sub_state
			local disable_for_mechanism = v.disable_for_mechanism
			local requires_player_unit = v.requires_player_unit
			local fade = v.fade
			local force_open = v.force_open
			local force_ingame_menu = v.force_ingame_menu

			active_button_data[#active_button_data + 1] = {
				display_name = display_name,
				display_name_func = display_name_func,
				url = url,
				callback = callback,
				transition = transition,
				transition_state = transition_state,
				transition_sub_state = transition_sub_state,
				disable_for_mechanism = disable_for_mechanism,
				requires_player_unit = requires_player_unit,
				fade = fade,
				force_open = force_open,
				force_ingame_menu = force_ingame_menu
			}
		end
	end
end

IngameViewLayoutLogic._update_menu_options = function (self)
	-- function 3
	if not script_data.pause_menu_full_access then
		if not self.pause_menu_full_access then
			self.pause_menu_full_access = true

			self:setup_button_layout(self._full_access_layout)
		end
	else
		local num_human_players = Managers.player:num_human_players()
		local pause_menu_full_access = self.pause_menu_full_access

		pause_menu_full_access = pause_menu_full_access or self.num_players ~= num_human_players
		self.pause_menu_full_access = nil

		if not pause_menu_full_access then
			self.num_players = num_human_players

			local layout_list = self.layout_list
			local var_3_3
			local level_key = Managers.state.game_mode:level_key()
			local offline_mode = Managers.account:offline_mode()

			if not script_data.honduras_demo then
				var_3_3 = layout_list.demo
			elseif level_key == "prologue" then
				var_3_3 = layout_list.tutorial
			elseif not offline_mode then
				var_3_3 = layout_list.offline
			elseif num_human_players == 1 then
				var_3_3 = layout_list.alone
			elseif not self.is_server then
				var_3_3 = layout_list.host
			else
				var_3_3 = layout_list.client
			end

			self:setup_button_layout(var_3_3)
		end
	end
end

IngameViewLayoutLogic._update_menu_options_enabled_states = function (self)
	-- function 4
	local active_button_data = self.active_button_data

	if not active_button_data then
		local is_local_player_ready_for_game = self.ingame_ui:is_local_player_ready_for_game()
		local is_game_matchmaking = Managers.matchmaking:is_game_matchmaking()
		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit ~= nil
		local current_mechanism_name = Managers.mechanism:current_mechanism_name()

		for i, v in ipairs(active_button_data) do
			local var_4_6
			local var_4_7
			local var_4_8
			local disable_for_mechanism = v.disable_for_mechanism

			disable_for_mechanism = not disable_for_mechanism and v.disable_for_mechanism[current_mechanism_name]

			if not disable_for_mechanism then
				var_4_6 = disable_for_mechanism.matchmaking
				var_4_7 = disable_for_mechanism.matchmaking_ready
				var_4_8 = disable_for_mechanism.not_matchmaking
			end

			local requires_player_unit = v.requires_player_unit
			local flag_2 = not is_local_player_ready_for_game and var_4_7 and not is_game_matchmaking or var_4_6 and (not requires_player_unit and not not flag and not var_4_8 or not is_game_matchmaking)

			if not (not flag_2 and v.disabled) then
				v.disabled = true
			elseif flag_2 or not v.disabled then
				v.disabled = false
			end
		end
	end
end

IngameViewLayoutLogic.execute_layout_option = function (self, arg_5_1)
	-- function 5
	local active_button_data = self.active_button_data
	local ingame_ui = self.ingame_ui
	local var_5_2 = active_button_data[arg_5_1]

	if not var_5_2 then
		local url = var_5_2.url

		if not url then
			Application.open_url_in_browser(url)
		else
			local callback = var_5_2.callback

			if not callback then
				callback()
			end

			local transition = var_5_2.transition
			local transition_state = var_5_2.transition_state
			local transition_sub_state = var_5_2.transition_sub_state
			local fade = var_5_2.fade
			local force_open = var_5_2.force_open
			local force_ingame_menu = var_5_2.force_ingame_menu
			local tbl = {
				menu_state_name = transition_state,
				menu_sub_state_name = transition_sub_state,
				force_open = force_open,
				force_ingame_menu = force_ingame_menu
			}

			if not fade then
				ingame_ui:transition_with_fade(transition, tbl)
			else
				ingame_ui:handle_transition(transition, tbl)
			end
		end
	end
end

IngameViewLayoutLogic.update = function (self)
	-- function 6
	self:_update_menu_options()
	self:_update_menu_options_enabled_states()
end

IngameViewLayoutLogic.layout_data = function (self)
	-- function 7
	return self.active_button_data
end

IngameViewLayoutLogic.destroy = function (arg_8_0)
	-- function 8
	return
end
