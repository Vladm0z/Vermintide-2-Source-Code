-- chunkname: @scripts/ui/weave_tutorial/weave_ui_onboarding_tutorial.lua

local_require("scripts/ui/weave_tutorial/weave_tutorial_popup_ui")
require("scripts/ui/weave_tutorial/weave_ui_tutorials")
require("scripts/ui/weave_tutorial/weave_onboarding_utils")

WeaveUIOnboardingTutorial = class(WeaveUIOnboardingTutorial)

WeaveUIOnboardingTutorial.init = function (arg_1_0, arg_1_1)
	arg_1_0.onboarding_step = 0
	arg_1_0.ui_onboarding_state = 0
	arg_1_0.statistics_db = arg_1_1.statistics_db

	local var_1_0 = Managers.player and Managers.player:local_player()

	arg_1_0.player_stats_id = var_1_0 and var_1_0:stats_id()
	arg_1_0.delayed_tutorial = nil
	arg_1_0.tutorial_timer = 0
	arg_1_0.tutorial_queue = {}
	arg_1_0.tutorial_popup = WeaveTutorialPopupUI:new(arg_1_1)

	arg_1_0:get_tutorial_state()
	arg_1_0:register_events()
end

WeaveUIOnboardingTutorial.destroy = function (arg_2_0)
	arg_2_0:unregister_events()
	arg_2_0:clear_all_popups()

	if arg_2_0.tutorial_popup then
		arg_2_0.tutorial_popup:destroy()

		arg_2_0.tutorial_popup = nil
	end
end

WeaveUIOnboardingTutorial.update = function (arg_3_0, arg_3_1, arg_3_2)
	if Managers.state.voting:vote_in_progress() then
		if arg_3_0:is_showing_tutorial() then
			arg_3_0:clear_all_popups()
		end

		return
	end

	if arg_3_0.tutorial_popup then
		if not arg_3_0:is_showing_tutorial() then
			local var_3_0 = arg_3_0.tutorial_queue

			arg_3_0:try_show_tutorial(var_3_0[1])
			table.remove(var_3_0, 1)
		elseif arg_3_0.delayed_tutorial then
			arg_3_0.tutorial_timer = arg_3_0.tutorial_timer + arg_3_1

			if arg_3_0.tutorial_timer >= arg_3_0.delayed_tutorial.delay then
				arg_3_0:show_tutorial(arg_3_0.delayed_tutorial)

				arg_3_0.delayed_tutorial = nil
			end
		end

		arg_3_0.tutorial_popup:update(arg_3_1)
	end
end

WeaveUIOnboardingTutorial.register_events = function (arg_4_0)
	local var_4_0 = Managers.state.event

	if var_4_0 then
		var_4_0:register(arg_4_0, "weave_forge_entered", "event_weave_forge_entered")
		var_4_0:register(arg_4_0, "weave_list_entered", "event_weave_list_entered")
		var_4_0:register(arg_4_0, "weave_forge_weapons_entered", "event_weave_forge_weapons_entered")
		var_4_0:register(arg_4_0, "weave_forge_item_unlocked", "event_weave_forge_item_unlocked")
		var_4_0:register(arg_4_0, "weave_forge_upgrade_item_entered", "event_weave_forge_upgrade_item_entered")
		var_4_0:register(arg_4_0, "weave_forge_item_upgraded", "event_weave_forge_item_upgraded")
		var_4_0:register(arg_4_0, "weave_forge_upgraded", "event_weave_forge_upgraded")
		var_4_0:register(arg_4_0, "weave_tutorial_message", "event_weave_tutorial_message")
	end
end

WeaveUIOnboardingTutorial.unregister_events = function (arg_5_0)
	local var_5_0 = Managers.state.event

	if var_5_0 then
		var_5_0:unregister("weave_forge_entered", arg_5_0)
		var_5_0:unregister("weave_list_entered", arg_5_0)
		var_5_0:unregister("weave_forge_weapons_entered", arg_5_0)
		var_5_0:unregister("weave_forge_item_unlocked", arg_5_0)
		var_5_0:unregister("weave_forge_upgrade_item_entered", arg_5_0)
		var_5_0:unregister("weave_forge_item_upgraded", arg_5_0)
		var_5_0:unregister("weave_forge_upgraded", arg_5_0)
		var_5_0:unregister("weave_tutorial_message", arg_5_0)
	end
end

WeaveUIOnboardingTutorial.get_tutorial_state = function (arg_6_0)
	local var_6_0 = arg_6_0.statistics_db
	local var_6_1 = arg_6_0.player_stats_id

	if var_6_0 and var_6_1 then
		arg_6_0.onboarding_step = WeaveOnboardingUtils.get_onboarding_step(var_6_0, var_6_1)
		arg_6_0.ui_onboarding_state = WeaveOnboardingUtils.get_ui_onboarding_state(var_6_0, var_6_1)
	end
end

WeaveUIOnboardingTutorial.has_popup = function (arg_7_0, arg_7_1)
	return arg_7_1 and (arg_7_1.popup_body or arg_7_1.custom_popup)
end

WeaveUIOnboardingTutorial.needs_to_show = function (arg_8_0, arg_8_1)
	return WeaveOnboardingUtils.reached_requirements(arg_8_0.onboarding_step, arg_8_1) and not WeaveOnboardingUtils.tutorial_completed(arg_8_0.ui_onboarding_state, arg_8_1)
end

WeaveUIOnboardingTutorial.show_tutorial = function (arg_9_0, arg_9_1)
	if arg_9_1 and arg_9_0.tutorial_popup then
		if arg_9_1.custom_popup then
			arg_9_0.tutorial_popup:show_custom_popup(arg_9_1)
		else
			local var_9_0 = arg_9_1.popup_title
			local var_9_1 = arg_9_1.popup_sub_title
			local var_9_2 = arg_9_1.popup_body
			local var_9_3 = arg_9_1.optional_button_2
			local var_9_4 = arg_9_1.optional_button_2_func
			local var_9_5 = arg_9_1.optional_button_2_input_actions
			local var_9_6 = arg_9_1.disable_body_localization

			arg_9_0.tutorial_popup:show(var_9_0, var_9_1, var_9_2, var_9_3, var_9_4, var_9_5, var_9_6, arg_9_1)
		end

		arg_9_0:set_completed(arg_9_1)
	end
end

WeaveUIOnboardingTutorial.queue_tutorial = function (arg_10_0, arg_10_1)
	if arg_10_1 then
		table.insert(arg_10_0.tutorial_queue, arg_10_1)
	end
end

WeaveUIOnboardingTutorial.set_completed = function (arg_11_0, arg_11_1)
	WeaveOnboardingUtils.complete_tutorial(arg_11_0.statistics_db, arg_11_0.player_stats_id, arg_11_1)
end

WeaveUIOnboardingTutorial.is_showing_tutorial = function (arg_12_0)
	return arg_12_0.tutorial_popup and arg_12_0.tutorial_popup.is_visible or arg_12_0.delayed_tutorial
end

WeaveUIOnboardingTutorial.try_show_tutorial = function (arg_13_0, arg_13_1)
	if arg_13_1 then
		arg_13_0:get_tutorial_state()

		if arg_13_0:needs_to_show(arg_13_1) then
			if not arg_13_0:has_popup(arg_13_1) then
				arg_13_0:set_completed(arg_13_1)
			elseif arg_13_0:is_showing_tutorial() then
				arg_13_0:queue_tutorial(arg_13_1)
			elseif arg_13_1.delay then
				arg_13_0.delayed_tutorial = arg_13_1
				arg_13_0.tutorial_timer = 0
			else
				arg_13_0:show_tutorial(arg_13_1)
			end
		end
	end
end

WeaveUIOnboardingTutorial.clear_all_popups = function (arg_14_0)
	arg_14_0.tutorial_queue = {}
	arg_14_0.delayed_tutorial = nil

	if arg_14_0.tutorial_popup then
		arg_14_0.tutorial_popup:hide()
	end
end

WeaveUIOnboardingTutorial.event_weave_forge_entered = function (arg_15_0)
	arg_15_0:try_show_tutorial(WeaveUITutorials.forge_initial)
	arg_15_0:try_show_tutorial(WeaveUITutorials.amulet)
	arg_15_0:try_show_tutorial(WeaveUITutorials.upgrade_forge)
end

WeaveUIOnboardingTutorial.event_weave_list_entered = function (arg_16_0)
	arg_16_0:try_show_tutorial(WeaveUITutorials.book_initial)
end

WeaveUIOnboardingTutorial.event_weave_forge_weapons_entered = function (arg_17_0)
	arg_17_0:try_show_tutorial(WeaveUITutorials.forge_weapon)
end

WeaveUIOnboardingTutorial.event_weave_forge_item_unlocked = function (arg_18_0)
	arg_18_0:try_show_tutorial(WeaveUITutorials.equip_weapon)
end

WeaveUIOnboardingTutorial.event_weave_forge_upgrade_item_entered = function (arg_19_0)
	arg_19_0:try_show_tutorial(WeaveUITutorials.temper_item)
end

WeaveUIOnboardingTutorial.event_weave_forge_item_upgraded = function (arg_20_0)
	arg_20_0:try_show_tutorial(WeaveUITutorials.mastery)
end

WeaveUIOnboardingTutorial.event_weave_forge_upgraded = function (arg_21_0)
	arg_21_0:try_show_tutorial(WeaveUITutorials.forge_upgrade)
end

WeaveUIOnboardingTutorial.event_weave_tutorial_message = function (arg_22_0, arg_22_1)
	arg_22_0:try_show_tutorial(arg_22_1)
end
