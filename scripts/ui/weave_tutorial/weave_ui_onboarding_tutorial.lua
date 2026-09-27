-- chunkname: @scripts/ui/weave_tutorial/weave_ui_onboarding_tutorial.lua

local_require("scripts/ui/weave_tutorial/weave_tutorial_popup_ui")
require("scripts/ui/weave_tutorial/weave_ui_tutorials")
require("scripts/ui/weave_tutorial/weave_onboarding_utils")

WeaveUIOnboardingTutorial = class(WeaveUIOnboardingTutorial)

WeaveUIOnboardingTutorial.init = function (self, arg_1_1)
	-- function 1
	self.onboarding_step = 0
	self.ui_onboarding_state = 0
	self.statistics_db = arg_1_1.statistics_db

	local player = Managers.player

	player = not player and Managers.player:local_player()
	self.player_stats_id = not player and player:stats_id()
	self.delayed_tutorial = nil
	self.tutorial_timer = 0
	self.tutorial_queue = {}
	self.tutorial_popup = WeaveTutorialPopupUI:new(arg_1_1)

	self:get_tutorial_state()
	self:register_events()
end

WeaveUIOnboardingTutorial.destroy = function (self)
	-- function 2
	self:unregister_events()
	self:clear_all_popups()

	if not self.tutorial_popup then
		self.tutorial_popup:destroy()

		self.tutorial_popup = nil
	end
end

WeaveUIOnboardingTutorial.update = function (self, arg_3_1, arg_3_2)
	-- function 3
	if not Managers.state.voting:vote_in_progress() then
		if not self:is_showing_tutorial() then
			self:clear_all_popups()
		end

		return
	end

	if not self.tutorial_popup then
		if not self:is_showing_tutorial() then
			local tutorial_queue = self.tutorial_queue

			self:try_show_tutorial(tutorial_queue[1])
			table.remove(tutorial_queue, 1)
		elseif not self.delayed_tutorial then
			self.tutorial_timer = self.tutorial_timer + arg_3_1

			if self.tutorial_timer >= self.delayed_tutorial.delay then
				self:show_tutorial(self.delayed_tutorial)

				self.delayed_tutorial = nil
			end
		end

		self.tutorial_popup:update(arg_3_1)
	end
end

WeaveUIOnboardingTutorial.register_events = function (arg_4_0)
	-- function 4
	local event = Managers.state.event

	if not event then
		event:register(arg_4_0, "weave_forge_entered", "event_weave_forge_entered")
		event:register(arg_4_0, "weave_list_entered", "event_weave_list_entered")
		event:register(arg_4_0, "weave_forge_weapons_entered", "event_weave_forge_weapons_entered")
		event:register(arg_4_0, "weave_forge_item_unlocked", "event_weave_forge_item_unlocked")
		event:register(arg_4_0, "weave_forge_upgrade_item_entered", "event_weave_forge_upgrade_item_entered")
		event:register(arg_4_0, "weave_forge_item_upgraded", "event_weave_forge_item_upgraded")
		event:register(arg_4_0, "weave_forge_upgraded", "event_weave_forge_upgraded")
		event:register(arg_4_0, "weave_tutorial_message", "event_weave_tutorial_message")
	end
end

WeaveUIOnboardingTutorial.unregister_events = function (arg_5_0)
	-- function 5
	local event = Managers.state.event

	if not event then
		event:unregister("weave_forge_entered", arg_5_0)
		event:unregister("weave_list_entered", arg_5_0)
		event:unregister("weave_forge_weapons_entered", arg_5_0)
		event:unregister("weave_forge_item_unlocked", arg_5_0)
		event:unregister("weave_forge_upgrade_item_entered", arg_5_0)
		event:unregister("weave_forge_item_upgraded", arg_5_0)
		event:unregister("weave_forge_upgraded", arg_5_0)
		event:unregister("weave_tutorial_message", arg_5_0)
	end
end

WeaveUIOnboardingTutorial.get_tutorial_state = function (self)
	-- function 6
	local statistics_db = self.statistics_db
	local player_stats_id = self.player_stats_id

	if not statistics_db and not player_stats_id then
		self.onboarding_step = WeaveOnboardingUtils.get_onboarding_step(statistics_db, player_stats_id)
		self.ui_onboarding_state = WeaveOnboardingUtils.get_ui_onboarding_state(statistics_db, player_stats_id)
	end
end

WeaveUIOnboardingTutorial.has_popup = function (arg_7_0, arg_7_1)
	-- function 7
	if not arg_7_1 then
		-- Nothing
	end

	::label_7_0::

	local popup_body = arg_7_1.popup_body

	popup_body = popup_body or arg_7_1.custom_popup

	::label_7_1::

	return popup_body
end

WeaveUIOnboardingTutorial.needs_to_show = function (self, arg_8_1)
	-- function 8
	local reached_requirements = WeaveOnboardingUtils.reached_requirements(self.onboarding_step, arg_8_1)

	reached_requirements = not reached_requirements and not WeaveOnboardingUtils.tutorial_completed(self.ui_onboarding_state, arg_8_1)

	return reached_requirements
end

WeaveUIOnboardingTutorial.show_tutorial = function (self, arg_9_1)
	-- function 9
	if not arg_9_1 and not self.tutorial_popup then
		if not arg_9_1.custom_popup then
			self.tutorial_popup:show_custom_popup(arg_9_1)
		else
			local popup_title = arg_9_1.popup_title
			local popup_sub_title = arg_9_1.popup_sub_title
			local popup_body = arg_9_1.popup_body
			local optional_button_2 = arg_9_1.optional_button_2
			local optional_button_2_func = arg_9_1.optional_button_2_func
			local optional_button_2_input_actions = arg_9_1.optional_button_2_input_actions
			local disable_body_localization = arg_9_1.disable_body_localization

			self.tutorial_popup:show(popup_title, popup_sub_title, popup_body, optional_button_2, optional_button_2_func, optional_button_2_input_actions, disable_body_localization, arg_9_1)
		end

		self:set_completed(arg_9_1)
	end
end

WeaveUIOnboardingTutorial.queue_tutorial = function (self, arg_10_1)
	-- function 10
	if not arg_10_1 then
		table.insert(self.tutorial_queue, arg_10_1)
	end
end

WeaveUIOnboardingTutorial.set_completed = function (self, arg_11_1)
	-- function 11
	WeaveOnboardingUtils.complete_tutorial(self.statistics_db, self.player_stats_id, arg_11_1)
end

WeaveUIOnboardingTutorial.is_showing_tutorial = function (self)
	-- function 12
	local is_visible

	if not self.tutorial_popup then
		is_visible = self.tutorial_popup.is_visible

		if not is_visible then
			-- Nothing
		end
	end

	is_visible = self.delayed_tutorial

	::label_12_0::

	return is_visible
end

WeaveUIOnboardingTutorial.try_show_tutorial = function (self, arg_13_1)
	-- function 13
	if not arg_13_1 then
		self:get_tutorial_state()

		if not self:needs_to_show(arg_13_1) then
			if not self:has_popup(arg_13_1) then
				self:set_completed(arg_13_1)
			elseif not self:is_showing_tutorial() then
				self:queue_tutorial(arg_13_1)
			elseif not arg_13_1.delay then
				self.delayed_tutorial = arg_13_1
				self.tutorial_timer = 0
			else
				self:show_tutorial(arg_13_1)
			end
		end
	end
end

WeaveUIOnboardingTutorial.clear_all_popups = function (self)
	-- function 14
	self.tutorial_queue = {}
	self.delayed_tutorial = nil

	if not self.tutorial_popup then
		self.tutorial_popup:hide()
	end
end

WeaveUIOnboardingTutorial.event_weave_forge_entered = function (self)
	-- function 15
	self:try_show_tutorial(WeaveUITutorials.forge_initial)
	self:try_show_tutorial(WeaveUITutorials.amulet)
	self:try_show_tutorial(WeaveUITutorials.upgrade_forge)
end

WeaveUIOnboardingTutorial.event_weave_list_entered = function (self)
	-- function 16
	self:try_show_tutorial(WeaveUITutorials.book_initial)
end

WeaveUIOnboardingTutorial.event_weave_forge_weapons_entered = function (self)
	-- function 17
	self:try_show_tutorial(WeaveUITutorials.forge_weapon)
end

WeaveUIOnboardingTutorial.event_weave_forge_item_unlocked = function (self)
	-- function 18
	self:try_show_tutorial(WeaveUITutorials.equip_weapon)
end

WeaveUIOnboardingTutorial.event_weave_forge_upgrade_item_entered = function (self)
	-- function 19
	self:try_show_tutorial(WeaveUITutorials.temper_item)
end

WeaveUIOnboardingTutorial.event_weave_forge_item_upgraded = function (self)
	-- function 20
	self:try_show_tutorial(WeaveUITutorials.mastery)
end

WeaveUIOnboardingTutorial.event_weave_forge_upgraded = function (self)
	-- function 21
	self:try_show_tutorial(WeaveUITutorials.forge_upgrade)
end

WeaveUIOnboardingTutorial.event_weave_tutorial_message = function (self, arg_22_1)
	-- function 22
	self:try_show_tutorial(arg_22_1)
end
