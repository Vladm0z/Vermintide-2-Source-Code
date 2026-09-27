-- chunkname: @scripts/ui/gift_popup/gift_popup_ui.lua

require("scripts/ui/reward_popup/reward_popup_ui")

local num = 1.5

GiftPopupUI = class(GiftPopupUI)

GiftPopupUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self._is_in_inn = arg_1_2.is_in_inn

	local var_1_0 = RewardPopupUI:new(arg_1_2)

	self._reward_popup = var_1_0

	var_1_0:set_input_manager(arg_1_2.input_manager)

	self._next_poll_time = 0
	self._presentation_queue = {}

	Managers.state.event:register(self, "level_start_local_player_spawned", "event_initialize_poll")
end

GiftPopupUI.event_initialize_poll = function (self)
	-- function 2
	self._poll_initialized = true
end

GiftPopupUI.update = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	return
end

GiftPopupUI.post_update = function (self, arg_4_1, arg_4_2)
	-- function 4
	local _reward_popup = self._reward_popup
	local _presentation_queue = self._presentation_queue

	if not self._poll_initialized and not self._is_in_inn then
		if arg_4_2 >= self._next_poll_time then
			self._next_poll_time = arg_4_2 + num

			while true do
				local poll_rewards = Managers.unlock:poll_rewards()

				if not poll_rewards then
					break
				end

				_presentation_queue[#_presentation_queue + 1] = self:_generate_presentation_data(poll_rewards)
			end
		end

		if not (#_presentation_queue > 0) or not self:_can_present_reward() then
			local remove = table.remove(_presentation_queue, 1)

			_reward_popup:display_presentation(remove)
		end

		_reward_popup:update(arg_4_1)
	end
end

GiftPopupUI.has_presentation_data = function (self)
	-- function 5
	return #self._presentation_queue > 0 or self._reward_popup:is_presentation_active()
end

GiftPopupUI._can_present_reward = function (self)
	-- function 6
	if not self._reward_popup:is_presentation_active() then
		return false
	end

	local popup = Managers.popup

	if not popup and not popup:has_popup() then
		return false
	end

	if not Managers.transition:fade_out_completed() then
		return false
	end

	return true
end

GiftPopupUI._generate_presentation_data = function (arg_7_0, arg_7_1)
	-- function 7
	return {
		animation_data = {
			claim_button = true
		},
		{
			{
				widget_type = "description",
				value = {
					Localize(arg_7_1.presentation_text),
					Localize("gift_popup_sub_title_halloween")
				}
			},
			{
				widget_type = "item_list",
				value = arg_7_1.items
			}
		}
	}
end

GiftPopupUI.active = function (self)
	-- function 8
	return self._reward_popup:is_presentation_active()
end

GiftPopupUI.active_input_service = function (self)
	-- function 9
	return self._reward_popup:input_service()
end

GiftPopupUI.destroy = function (self)
	-- function 10
	self._reward_popup:destroy()

	self._reward_popup = nil
	self._presentation_queue = nil
end
