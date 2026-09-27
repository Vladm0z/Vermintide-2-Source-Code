-- chunkname: @scripts/settings/dlcs/scorpion/scorpion_interactions.lua

local function fn()
	-- function 1
	if not script_data.unlock_all_levels then
		return true
	end

	local player = Managers.player
	local statistics_db = player:statistics_db()
	local stats_id = player:local_player():stats_id()

	for k, v in pairs(HelmgartLevels) do
		if not (LevelSettings[v].mechanism ~= "adventure" or not (statistics_db:get_persistent_stat(stats_id, "completed_levels", v) < 1)) then
			return false
		end
	end

	local act_scorpion = GameActs.act_scorpion

	for k_2, v_2 in pairs(act_scorpion) do
		if not (LevelSettings[v_2].mechanism ~= "adventure" or not (statistics_db:get_persistent_stat(stats_id, "completed_levels", v_2) < 1)) then
			return false
		end
	end

	return true
end

local function fn_2()
	-- function 2
	if not fn() then
		return false
	end

	return not Managers.account:offline_mode()
end

local InteractionDefinitions = InteractionDefinitions
local weave_level_select_access = InteractionDefinitions.weave_level_select_access

weave_level_select_access = weave_level_select_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.weave_level_select_access = weave_level_select_access
InteractionDefinitions.weave_level_select_access.config.swap_to_3p = false

InteractionDefinitions.weave_level_select_access.client.stop = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	arg_3_3.start_time = nil

	if not (arg_3_6 ~= InteractionResult.SUCCESS or arg_3_3.is_husk) then
		local str = "scorpion"

		if not Managers.unlock:is_dlc_unlocked(str) then
			Managers.state.event:trigger("ui_show_popup", str, "upsell")

			return
		end

		local twitch = Managers.twitch

		if not twitch then
			twitch = Managers.twitch:is_connected()
			twitch = twitch or Managers.twitch:is_activated()
		end

		if not twitch then
			Managers.state.event:trigger("weave_tutorial_message", WeaveUITutorials.twitch_not_supported_for_weaves)

			return
		elseif not (Managers.player.is_server or Managers.state.network:lobby():lobby_data("twitch_enabled") ~= "true") then
			Managers.state.event:trigger("weave_tutorial_message", WeaveUITutorials.twitch_not_supported_for_weaves_client)

			return
		end

		if not fn() then
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
	-- function 4
	return true
end

InteractionDefinitions.weave_level_select_access.client.hud_description = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	return Unit.get_data(arg_5_0, "interaction_data", "hud_description"), Unit.get_data(arg_5_0, "interaction_data", "hud_interaction_action")
end

local InteractionDefinitions_2 = InteractionDefinitions
local weave_magic_forge_access = InteractionDefinitions.weave_magic_forge_access

weave_magic_forge_access = weave_magic_forge_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_2.weave_magic_forge_access = weave_magic_forge_access
InteractionDefinitions.weave_magic_forge_access.config.swap_to_3p = false

InteractionDefinitions.weave_magic_forge_access.client.stop = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6)
	-- function 6
	arg_6_3.start_time = nil

	if not (arg_6_6 ~= InteractionResult.SUCCESS or arg_6_3.is_husk) then
		local str = "scorpion"

		if not Managers.unlock:is_dlc_unlocked(str) then
			Managers.state.event:trigger("ui_show_popup", str, "upsell")

			return
		end

		if not fn() then
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
	-- function 7
	return true
end

InteractionDefinitions.weave_magic_forge_access.client.hud_description = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	return Unit.get_data(arg_8_0, "interaction_data", "hud_description"), Unit.get_data(arg_8_0, "interaction_data", "hud_interaction_action")
end

local InteractionDefinitions_3 = InteractionDefinitions
local weave_leaderboard_access = InteractionDefinitions.weave_leaderboard_access

weave_leaderboard_access = weave_leaderboard_access or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions_3.weave_leaderboard_access = weave_leaderboard_access
InteractionDefinitions.weave_leaderboard_access.config.swap_to_3p = false

InteractionDefinitions.weave_leaderboard_access.client.stop = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6)
	-- function 9
	arg_9_3.start_time = nil

	if not (arg_9_6 ~= InteractionResult.SUCCESS or arg_9_3.is_husk) then
		local str = "scorpion"

		if not Managers.unlock:is_dlc_unlocked(str) then
			Managers.state.event:trigger("ui_show_popup", str, "upsell")

			return
		end

		if not fn_2() then
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
	-- function 10
	if not Managers.account:offline_mode() then
		return false, "status_offline"
	end

	return true
end

InteractionDefinitions.weave_leaderboard_access.client.hud_description = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	if arg_11_3 == "status_offline" then
		return Unit.get_data(arg_11_0, "interaction_data", "hud_description"), "status_offline"
	else
		return Unit.get_data(arg_11_0, "interaction_data", "hud_description"), Unit.get_data(arg_11_0, "interaction_data", "hud_interaction_action"), nil, "test"
	end
end
