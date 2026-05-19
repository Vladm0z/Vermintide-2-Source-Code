-- chunkname: @scripts/ui/views/ingame_view_layout_logic.lua

IngameViewLayoutLogic = class(IngameViewLayoutLogic)

function IngameViewLayoutLogic.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0._menu_layouts = arg_1_3
	arg_1_0._full_access_layout = arg_1_4
	arg_1_0.ingame_ui = arg_1_1.ingame_ui
	arg_1_0._params = arg_1_2

	local var_1_0 = arg_1_1.is_in_inn

	arg_1_0.is_server = arg_1_1.is_server
	arg_1_0.layout_list = var_1_0 and arg_1_3.in_menu or arg_1_3.in_game
end

function IngameViewLayoutLogic.setup_button_layout(arg_2_0, arg_2_1)
	local var_2_0 = arg_2_0.active_button_data

	if var_2_0 then
		table.clear(var_2_0)
	else
		arg_2_0.active_button_data = {}
		var_2_0 = arg_2_0.active_button_data
	end

	local var_2_1 = arg_2_0._params

	for iter_2_0, iter_2_1 in ipairs(arg_2_1) do
		if not iter_2_1.can_add_function or iter_2_1.can_add_function(var_2_1) then
			local var_2_2 = iter_2_1.display_name
			local var_2_3 = iter_2_1.display_name_func
			local var_2_4 = iter_2_1.url
			local var_2_5 = iter_2_1.callback
			local var_2_6 = iter_2_1.transition
			local var_2_7 = iter_2_1.transition_state
			local var_2_8 = iter_2_1.transition_sub_state
			local var_2_9 = iter_2_1.disable_for_mechanism
			local var_2_10 = iter_2_1.requires_player_unit
			local var_2_11 = iter_2_1.fade
			local var_2_12 = iter_2_1.force_open
			local var_2_13 = iter_2_1.force_ingame_menu

			var_2_0[#var_2_0 + 1] = {
				display_name = var_2_2,
				display_name_func = var_2_3,
				url = var_2_4,
				callback = var_2_5,
				transition = var_2_6,
				transition_state = var_2_7,
				transition_sub_state = var_2_8,
				disable_for_mechanism = var_2_9,
				requires_player_unit = var_2_10,
				fade = var_2_11,
				force_open = var_2_12,
				force_ingame_menu = var_2_13
			}
		end
	end
end

function IngameViewLayoutLogic._update_menu_options(arg_3_0)
	if script_data.pause_menu_full_access then
		if not arg_3_0.pause_menu_full_access then
			arg_3_0.pause_menu_full_access = true

			arg_3_0:setup_button_layout(arg_3_0._full_access_layout)
		end
	else
		local var_3_0 = Managers.player:num_human_players()
		local var_3_1 = arg_3_0.pause_menu_full_access or arg_3_0.num_players ~= var_3_0

		arg_3_0.pause_menu_full_access = nil

		if var_3_1 then
			arg_3_0.num_players = var_3_0

			local var_3_2 = arg_3_0.layout_list
			local var_3_3
			local var_3_4 = Managers.state.game_mode:level_key()
			local var_3_5 = Managers.account:offline_mode()

			if script_data.honduras_demo then
				var_3_3 = var_3_2.demo
			elseif var_3_4 == "prologue" then
				var_3_3 = var_3_2.tutorial
			elseif var_3_5 then
				var_3_3 = var_3_2.offline
			elseif var_3_0 == 1 then
				var_3_3 = var_3_2.alone
			elseif arg_3_0.is_server then
				var_3_3 = var_3_2.host
			else
				var_3_3 = var_3_2.client
			end

			arg_3_0:setup_button_layout(var_3_3)
		end
	end
end

function IngameViewLayoutLogic._update_menu_options_enabled_states(arg_4_0)
	local var_4_0 = arg_4_0.active_button_data

	if var_4_0 then
		local var_4_1 = arg_4_0.ingame_ui:is_local_player_ready_for_game()
		local var_4_2 = Managers.matchmaking:is_game_matchmaking()
		local var_4_3 = Managers.player:local_player()
		local var_4_4 = var_4_3 and var_4_3.player_unit ~= nil
		local var_4_5 = Managers.mechanism:current_mechanism_name()

		for iter_4_0, iter_4_1 in ipairs(var_4_0) do
			local var_4_6
			local var_4_7
			local var_4_8
			local var_4_9 = iter_4_1.disable_for_mechanism and iter_4_1.disable_for_mechanism[var_4_5]

			if var_4_9 then
				var_4_6 = var_4_9.matchmaking
				var_4_7 = var_4_9.matchmaking_ready
				var_4_8 = var_4_9.not_matchmaking
			end

			local var_4_10 = iter_4_1.requires_player_unit
			local var_4_11 = var_4_1 and var_4_7 or var_4_2 and var_4_6 or var_4_10 and not var_4_4 or var_4_8 and not var_4_2

			if var_4_11 and not iter_4_1.disabled then
				iter_4_1.disabled = true
			elseif not var_4_11 and iter_4_1.disabled then
				iter_4_1.disabled = false
			end
		end
	end
end

function IngameViewLayoutLogic.execute_layout_option(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0.active_button_data
	local var_5_1 = arg_5_0.ingame_ui
	local var_5_2 = var_5_0[arg_5_1]

	if var_5_2 then
		local var_5_3 = var_5_2.url

		if var_5_3 then
			Application.open_url_in_browser(var_5_3)
		else
			local var_5_4 = var_5_2.callback

			if var_5_4 then
				var_5_4()
			end

			local var_5_5 = var_5_2.transition
			local var_5_6 = var_5_2.transition_state
			local var_5_7 = var_5_2.transition_sub_state
			local var_5_8 = var_5_2.fade
			local var_5_9 = var_5_2.force_open
			local var_5_10 = var_5_2.force_ingame_menu
			local var_5_11 = {
				menu_state_name = var_5_6,
				menu_sub_state_name = var_5_7,
				force_open = var_5_9,
				force_ingame_menu = var_5_10
			}

			if var_5_8 then
				var_5_1:transition_with_fade(var_5_5, var_5_11)
			else
				var_5_1:handle_transition(var_5_5, var_5_11)
			end
		end
	end
end

function IngameViewLayoutLogic.update(arg_6_0)
	arg_6_0:_update_menu_options()
	arg_6_0:_update_menu_options_enabled_states()
end

function IngameViewLayoutLogic.layout_data(arg_7_0)
	return arg_7_0.active_button_data
end

function IngameViewLayoutLogic.destroy(arg_8_0)
	return
end
