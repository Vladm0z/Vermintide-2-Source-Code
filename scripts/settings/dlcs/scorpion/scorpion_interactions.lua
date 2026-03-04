-- chunkname: @scripts/settings/dlcs/scorpion/scorpion_interactions.lua

local function var_0_0()
	if script_data.unlock_all_levels then
		return true
	end

	local var_1_0 = Managers.player
	local var_1_1 = var_1_0:statistics_db()
	local var_1_2 = var_1_0:local_player():stats_id()

	for iter_1_0, iter_1_1 in pairs(HelmgartLevels) do
		if LevelSettings[iter_1_1].mechanism == "adventure" and var_1_1:get_persistent_stat(var_1_2, "completed_levels", iter_1_1) < 1 then
			return false
		end
	end

	local var_1_3 = GameActs.act_scorpion

	for iter_1_2, iter_1_3 in pairs(var_1_3) do
		if LevelSettings[iter_1_3].mechanism == "adventure" and var_1_1:get_persistent_stat(var_1_2, "completed_levels", iter_1_3) < 1 then
			return false
		end
	end

	return true
end

local function var_0_1()
	if not var_0_0() then
		return false
	end

	return not Managers.account:offline_mode()
end

InteractionDefinitions.weave_level_select_access = InteractionDefinitions.weave_level_select_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.weave_level_select_access.config.swap_to_3p = false

InteractionDefinitions.weave_level_select_access.client.stop = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	arg_3_3.start_time = nil

	if arg_3_6 == InteractionResult.SUCCESS and not arg_3_3.is_husk then
		local var_3_0 = "scorpion"

		if not Managers.unlock:is_dlc_unlocked(var_3_0) then
			Managers.state.event:trigger("ui_show_popup", var_3_0, "upsell")

			return
		end

		if Managers.twitch and (Managers.twitch:is_connected() or Managers.twitch:is_activated()) then
			Managers.state.event:trigger("weave_tutorial_message", WeaveUITutorials.twitch_not_supported_for_weaves)

			return
		elseif not Managers.player.is_server and Managers.state.network:lobby():lobby_data("twitch_enabled") == "true" then
			Managers.state.event:trigger("weave_tutorial_message", WeaveUITutorials.twitch_not_supported_for_weaves_client)

			return
		end

		if var_0_0() then
			Managers.ui:handle_transition("start_game_view_force", {
				menu_sub_state_name = "weave_quickplay",
				menu_state_name = "play",
				use_fade = true
			})
			Unit.flow_event(arg_3_2, "lua_interaction_success")
		else
			Managers.state.event:trigger("weave_tutorial_message", WeaveUITutorials.requirements_not_met)
		end
	end
end

InteractionDefinitions.weave_level_select_access.client.can_interact = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	return true
end

InteractionDefinitions.weave_level_select_access.client.hud_description = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	return Unit.get_data(arg_5_0, "interaction_data", "hud_description"), Unit.get_data(arg_5_0, "interaction_data", "hud_interaction_action")
end

InteractionDefinitions.weave_magic_forge_access = InteractionDefinitions.weave_magic_forge_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.weave_magic_forge_access.config.swap_to_3p = false

InteractionDefinitions.weave_magic_forge_access.client.stop = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6)
	arg_6_3.start_time = nil

	if arg_6_6 == InteractionResult.SUCCESS and not arg_6_3.is_husk then
		local var_6_0 = "scorpion"

		if not Managers.unlock:is_dlc_unlocked(var_6_0) then
			Managers.state.event:trigger("ui_show_popup", var_6_0, "upsell")

			return
		end

		if var_0_0() then
			Managers.ui:handle_transition("hero_view_force", {
				use_fade = true,
				menu_state_name = "weave_forge"
			})
			Unit.flow_event(arg_6_2, "lua_interaction_success")
		else
			Managers.state.event:trigger("weave_tutorial_message", WeaveUITutorials.requirements_not_met)
		end
	end
end

InteractionDefinitions.weave_magic_forge_access.client.can_interact = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	return true
end

InteractionDefinitions.weave_magic_forge_access.client.hud_description = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	return Unit.get_data(arg_8_0, "interaction_data", "hud_description"), Unit.get_data(arg_8_0, "interaction_data", "hud_interaction_action")
end

InteractionDefinitions.weave_leaderboard_access = InteractionDefinitions.weave_leaderboard_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.weave_leaderboard_access.config.swap_to_3p = false

InteractionDefinitions.weave_leaderboard_access.client.stop = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6)
	arg_9_3.start_time = nil

	if arg_9_6 == InteractionResult.SUCCESS and not arg_9_3.is_husk then
		local var_9_0 = "scorpion"

		if not Managers.unlock:is_dlc_unlocked(var_9_0) then
			Managers.state.event:trigger("ui_show_popup", var_9_0, "upsell")

			return
		end

		if var_0_1() then
			Managers.ui:handle_transition("start_game_view_force", {
				use_fade = true,
				menu_state_name = "leaderboard"
			})
			Unit.flow_event(arg_9_2, "lua_interaction_success")
		else
			Managers.state.event:trigger("weave_tutorial_message", WeaveUITutorials.requirements_not_met)
		end
	end
end

InteractionDefinitions.weave_leaderboard_access.client.can_interact = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if Managers.account:offline_mode() then
		return false, "status_offline"
	end

	return true
end

InteractionDefinitions.weave_leaderboard_access.client.hud_description = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	if arg_11_3 == "status_offline" then
		return Unit.get_data(arg_11_0, "interaction_data", "hud_description"), "status_offline"
	else
		return Unit.get_data(arg_11_0, "interaction_data", "hud_description"), Unit.get_data(arg_11_0, "interaction_data", "hud_interaction_action"), nil, "test"
	end
end
