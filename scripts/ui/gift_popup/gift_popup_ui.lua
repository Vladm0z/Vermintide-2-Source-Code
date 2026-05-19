-- chunkname: @scripts/ui/gift_popup/gift_popup_ui.lua

require("scripts/ui/reward_popup/reward_popup_ui")

local var_0_0 = 1.5

GiftPopupUI = class(GiftPopupUI)

function GiftPopupUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0._is_in_inn = arg_1_2.is_in_inn

	local var_1_0 = RewardPopupUI:new(arg_1_2)

	arg_1_0._reward_popup = var_1_0

	var_1_0:set_input_manager(arg_1_2.input_manager)

	arg_1_0._next_poll_time = 0
	arg_1_0._presentation_queue = {}

	Managers.state.event:register(arg_1_0, "level_start_local_player_spawned", "event_initialize_poll")
end

function GiftPopupUI.event_initialize_poll(arg_2_0)
	arg_2_0._poll_initialized = true
end

function GiftPopupUI.update(arg_3_0, arg_3_1, arg_3_2)
	return
end

function GiftPopupUI.post_update(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0._reward_popup
	local var_4_1 = arg_4_0._presentation_queue

	if arg_4_0._poll_initialized and arg_4_0._is_in_inn then
		if arg_4_2 >= arg_4_0._next_poll_time then
			arg_4_0._next_poll_time = arg_4_2 + var_0_0

			while true do
				local var_4_2 = Managers.unlock:poll_rewards()

				if not var_4_2 then
					break
				end

				var_4_1[#var_4_1 + 1] = arg_4_0:_generate_presentation_data(var_4_2)
			end
		end

		if #var_4_1 > 0 and arg_4_0:_can_present_reward() then
			local var_4_3 = table.remove(var_4_1, 1)

			var_4_0:display_presentation(var_4_3)
		end

		var_4_0:update(arg_4_1)
	end
end

function GiftPopupUI.has_presentation_data(arg_5_0)
	return #arg_5_0._presentation_queue > 0 or arg_5_0._reward_popup:is_presentation_active()
end

function GiftPopupUI._can_present_reward(arg_6_0)
	if arg_6_0._reward_popup:is_presentation_active() then
		return false
	end

	local var_6_0 = Managers.popup

	if var_6_0 and var_6_0:has_popup() then
		return false
	end

	if not Managers.transition:fade_out_completed() then
		return false
	end

	return true
end

function GiftPopupUI._generate_presentation_data(arg_7_0, arg_7_1)
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

function GiftPopupUI.active(arg_8_0)
	return arg_8_0._reward_popup:is_presentation_active()
end

function GiftPopupUI.active_input_service(arg_9_0)
	return arg_9_0._reward_popup:input_service()
end

function GiftPopupUI.destroy(arg_10_0)
	arg_10_0._reward_popup:destroy()

	arg_10_0._reward_popup = nil
	arg_10_0._presentation_queue = nil
end
