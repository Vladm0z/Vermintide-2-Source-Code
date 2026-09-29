-- chunkname: @scripts/ui/weave_tutorial/weave_ui_onboarding_tutorial.lua

local_require("scripts/ui/weave_tutorial/weave_tutorial_popup_ui")
require("scripts/ui/weave_tutorial/weave_ui_tutorials")
require("scripts/ui/weave_tutorial/weave_onboarding_utils")

WeaveUIOnboardingTutorial = class(WeaveUIOnboardingTutorial)

WeaveUIOnboardingTutorial.init = function (self, context)
	-- function 1
	self.onboarding_step = 0
	self.ui_onboarding_state = 0
	self.statistics_db = context.statistics_db

	local player = not not Managers.player

	self.player_stats_id = not not player and not not player:stats_id()
	self.delayed_tutorial = nil
	self.tutorial_timer = 0
	self.tutorial_queue = {}
	self.tutorial_popup = WeaveTutorialPopupUI:new(context)

	self:get_tutorial_state()
	self:register_events()
end

WeaveUIOnboardingTutorial.destroy = function (self)
	-- function 2
	self:unregister_events()
	self:clear_all_popups()

	if self.tutorial_popup then
		self.tutorial_popup:destroy()

		self.tutorial_popup = nil
	end
end

WeaveUIOnboardingTutorial.update = function (self, dt, t)
	-- function 3
	if Managers.state.voting:vote_in_progress() then
		if self:is_showing_tutorial() then
			self:clear_all_popups()
		end

		return
	end

	if self.tutorial_popup then
		if not self:is_showing_tutorial() then
			local tutorial_queue = self.tutorial_queue

			self:try_show_tutorial(tutorial_queue[1])
			table.remove(tutorial_queue, 1)
		elseif self.delayed_tutorial then
			self.tutorial_timer = self.tutorial_timer + dt

			if self.tutorial_timer >= self.delayed_tutorial.delay then
				self:show_tutorial(self.delayed_tutorial)

				self.delayed_tutorial = nil
			end
		end

		self.tutorial_popup:update(dt)
	end
end

WeaveUIOnboardingTutorial.register_events = function (self)
	-- function 4
	local event_manager = Managers.state.event

	if event_manager then
		event_manager:register(self, "weave_forge_entered", "event_weave_forge_entered")
		event_manager:register(self, "weave_list_entered", "event_weave_list_entered")
		event_manager:register(self, "weave_forge_weapons_entered", "event_weave_forge_weapons_entered")
		event_manager:register(self, "weave_forge_item_unlocked", "event_weave_forge_item_unlocked")
		event_manager:register(self, "weave_forge_upgrade_item_entered", "event_weave_forge_upgrade_item_entered")
		event_manager:register(self, "weave_forge_item_upgraded", "event_weave_forge_item_upgraded")
		event_manager:register(self, "weave_forge_upgraded", "event_weave_forge_upgraded")
		event_manager:register(self, "weave_tutorial_message", "event_weave_tutorial_message")
	end
end

WeaveUIOnboardingTutorial.unregister_events = function (self)
	-- function 5
	local event_manager = Managers.state.event

	if event_manager then
		event_manager:unregister("weave_forge_entered", self)
		event_manager:unregister("weave_list_entered", self)
		event_manager:unregister("weave_forge_weapons_entered", self)
		event_manager:unregister("weave_forge_item_unlocked", self)
		event_manager:unregister("weave_forge_upgrade_item_entered", self)
		event_manager:unregister("weave_forge_item_upgraded", self)
		event_manager:unregister("weave_forge_upgraded", self)
		event_manager:unregister("weave_tutorial_message", self)
	end
end

WeaveUIOnboardingTutorial.get_tutorial_state = function (self)
	-- function 6
	local statistics_db = self.statistics_db
	local stats_id = self.player_stats_id

	if statistics_db and stats_id then
		self.onboarding_step = WeaveOnboardingUtils.get_onboarding_step(statistics_db, stats_id)
		self.ui_onboarding_state = WeaveOnboardingUtils.get_ui_onboarding_state(statistics_db, stats_id)
	end
end

WeaveUIOnboardingTutorial.has_popup = function (self, tutorial)
	-- function 7
	return not not tutorial.custom_popup
end

WeaveUIOnboardingTutorial.needs_to_show = function (self, tutorial_data)
	-- function 8
	return not not WeaveOnboardingUtils.reached_requirements(self.onboarding_step, tutorial_data)
end

WeaveUIOnboardingTutorial.show_tutorial = function (self, tutorial_data)
	-- function 9
	if tutorial_data and self.tutorial_popup then
		if tutorial_data.custom_popup then
			self.tutorial_popup:show_custom_popup(tutorial_data)
		else
			local title = tutorial_data.popup_title
			local sub_title = tutorial_data.popup_sub_title
			local body = tutorial_data.popup_body
			local optional_button_2 = tutorial_data.optional_button_2
			local optional_button_2_func = tutorial_data.optional_button_2_func
			local optional_button_2_input_actions = tutorial_data.optional_button_2_input_actions
			local disable_body_localization = tutorial_data.disable_body_localization

			self.tutorial_popup:show(title, sub_title, body, optional_button_2, optional_button_2_func, optional_button_2_input_actions, disable_body_localization, tutorial_data)
		end

		self:set_completed(tutorial_data)
	end
end

WeaveUIOnboardingTutorial.queue_tutorial = function (self, tutorial_data)
	-- function 10
	if tutorial_data then
		table.insert(self.tutorial_queue, tutorial_data)
	end
end

WeaveUIOnboardingTutorial.set_completed = function (self, tutorial_data)
	-- function 11
	WeaveOnboardingUtils.complete_tutorial(self.statistics_db, self.player_stats_id, tutorial_data)
end

WeaveUIOnboardingTutorial.is_showing_tutorial = function (self)
	-- function 12
	return self.tutorial_popup and not not self.tutorial_popup.is_visible or not self.tutorial_popup and not not self.delayed_tutorial
end

WeaveUIOnboardingTutorial.try_show_tutorial = function (self, tutorial_data)
	-- function 13
	if tutorial_data then
		self:get_tutorial_state()

		if self:needs_to_show(tutorial_data) then
			if not self:has_popup(tutorial_data) then
				self:set_completed(tutorial_data)
			elseif self:is_showing_tutorial() then
				self:queue_tutorial(tutorial_data)
			elseif tutorial_data.delay then
				self.delayed_tutorial = tutorial_data
				self.tutorial_timer = 0
			else
				self:show_tutorial(tutorial_data)
			end
		end
	end
end

WeaveUIOnboardingTutorial.clear_all_popups = function (self)
	-- function 14
	self.tutorial_queue = {}
	self.delayed_tutorial = nil

	if self.tutorial_popup then
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

WeaveUIOnboardingTutorial.event_weave_tutorial_message = function (self, message)
	-- function 22
	self:try_show_tutorial(message)
end
