-- chunkname: @scripts/ui/hud_ui/rewards_popup_ui.lua

RewardsPopupUI = class(RewardsPopupUI)

function RewardsPopupUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0._ui_renderer = arg_1_2.ui_renderer
	arg_1_0._ingame_ui = arg_1_2.ingame_ui
	arg_1_0._input_manager = arg_1_2.input_manager
	arg_1_0._world_manager = arg_1_2.world_manager
	arg_1_0._wwise_world = arg_1_2.wwise_world
	arg_1_0._ui_top_renderer = arg_1_2.ui_top_renderer
	arg_1_0._reward_presentation_queue = {}
	arg_1_0._reward_presentation_active = false

	local var_1_0 = {
		wwise_world = arg_1_0._wwise_world,
		ui_renderer = arg_1_0._ui_renderer,
		ui_top_renderer = arg_1_0._ui_top_renderer,
		input_manager = arg_1_0._input_manager
	}

	arg_1_0._reward_popup = RewardPopupUI:new(var_1_0)

	Managers.state.event:register(arg_1_0, "present_rewards", "present_rewards")
end

function RewardsPopupUI.destroy(arg_2_0)
	Managers.state.event:unregister("present_rewards", arg_2_0)
end

function RewardsPopupUI.update(arg_3_0, arg_3_1, arg_3_2)
	if arg_3_0._reward_popup then
		arg_3_0._reward_popup:update(arg_3_1)
		arg_3_0:_handle_queued_presentations()
	end
end

function RewardsPopupUI.present_rewards(arg_4_0, arg_4_1)
	if #arg_4_1 > 0 then
		local var_4_0 = {}
		local var_4_1 = Managers.backend:get_interface("items")

		for iter_4_0, iter_4_1 in ipairs(arg_4_1) do
			local var_4_2 = iter_4_1.type
			local var_4_3 = iter_4_1.sounds

			if var_4_2 == "item" or var_4_2 == "loot_chest" or CosmeticUtils.is_cosmetic_item(var_4_2) then
				local var_4_4 = iter_4_1.backend_id
				local var_4_5 = {}
				local var_4_6 = var_4_1:get_item_from_id(var_4_4)
				local var_4_7 = {}
				local var_4_8, var_4_9, var_4_10 = UIUtils.get_ui_information_from_item(var_4_6)

				var_4_7[1] = Localize(var_4_9)
				var_4_7[2] = Localize("gift_popup_sub_title_halloween")
				var_4_5[#var_4_5 + 1] = {
					widget_type = "description",
					value = var_4_7
				}
				var_4_5[#var_4_5 + 1] = {
					widget_type = "item",
					value = var_4_6
				}
				var_4_0[#var_4_0 + 1] = var_4_5
				var_4_0.sounds = var_4_3
			elseif var_4_2 == "item_tooltip" then
				local var_4_11 = iter_4_1.backend_id
				local var_4_12 = var_4_1:get_item_from_id(var_4_11)
				local var_4_13 = {}

				var_4_13[#var_4_13 + 1] = {
					widget_type = "item_tooltip",
					value = var_4_12
				}
				var_4_13[#var_4_13 + 1] = {
					widget_type = "item",
					value = var_4_12
				}
				var_4_0[#var_4_0 + 1] = var_4_13
				var_4_0.sounds = var_4_3
			elseif var_4_2 == "deus_item_tooltip" then
				local var_4_14 = iter_4_1.backend_id
				local var_4_15 = var_4_1:get_item_from_id(var_4_14)
				local var_4_16 = {}

				var_4_16[#var_4_16 + 1] = {
					widget_type = "deus_item_tooltip",
					value = var_4_15
				}
				var_4_16[#var_4_16 + 1] = {
					widget_type = "deus_item",
					value = var_4_15
				}

				local var_4_17 = {
					end_animation = "deus_close",
					start_animation = "deus_open"
				}

				var_4_0[#var_4_0 + 1] = var_4_16
				var_4_0.animation_data = var_4_17
				var_4_0.keep_input = true
				var_4_0.skip_blur = true
				var_4_0.sounds = var_4_3
			elseif var_4_2 == "deus_power_up" then
				local var_4_18 = iter_4_1.power_up
				local var_4_19 = {}

				var_4_19[#var_4_19 + 1] = {
					widget_type = "deus_power_up",
					value = var_4_18
				}
				var_4_19[#var_4_19 + 1] = {
					widget_type = "deus_icon",
					value = var_4_18
				}

				local var_4_20 = {
					end_animation = "deus_close",
					start_animation = "deus_open"
				}

				var_4_0[#var_4_0 + 1] = var_4_19
				var_4_0.animation_data = var_4_20
				var_4_0.keep_input = true
				var_4_0.skip_blur = true

				local var_4_21 = var_4_18.rarity
				local var_4_22 = var_4_18.name
				local var_4_23 = DeusPowerUpSetLookup[var_4_21][var_4_22]

				if var_4_23 then
					for iter_4_2 = 1, #var_4_23 do
						local var_4_24 = var_4_23[iter_4_2]

						if var_4_24.progress_sfx and table.find_func(var_4_24.pieces, function(arg_5_0, arg_5_1)
							return arg_5_1.name == var_4_22 and arg_5_1.rarity == var_4_21
						end) then
							var_4_3 = var_4_3 and table.shallow_copy(var_4_3) or {}
							var_4_3[#var_4_3 + 1] = var_4_24.progress_sfx

							break
						elseif var_4_24.completed_sfx and table.find_func(var_4_24.rewards, function(arg_6_0, arg_6_1)
							return arg_6_1.name == var_4_22 and arg_6_1.rarity == var_4_21
						end) then
							var_4_3 = var_4_3 and table.shallow_copy(var_4_3) or {}
							var_4_3[#var_4_3 + 1] = var_4_24.completed_sfx

							break
						end
					end
				end

				var_4_0.sounds = var_4_3
			elseif var_4_2 == "deus_power_up_end_of_level" then
				local var_4_25 = iter_4_1.power_up
				local var_4_26 = {}

				var_4_26[#var_4_26 + 1] = {
					widget_type = "deus_power_up",
					value = var_4_25
				}
				var_4_26[#var_4_26 + 1] = {
					widget_type = "deus_icon",
					value = var_4_25
				}

				local var_4_27 = {
					end_animation = "deus_close",
					start_animation = "deus_open",
					animation_wait_time = 6
				}

				var_4_0[#var_4_0 + 1] = var_4_26
				var_4_0.animation_data = var_4_27
				var_4_0.keep_input = true
				var_4_0.skip_blur = true
				var_4_0.sounds = var_4_3
			elseif var_4_2 == "keep_decoration_painting" then
				local var_4_28 = iter_4_1.keep_decoration_name
				local var_4_29 = Paintings[var_4_28]
				local var_4_30 = var_4_29.display_name
				local var_4_31 = var_4_29.icon
				local var_4_32 = {}
				local var_4_33 = {}

				var_4_32[1] = Localize(var_4_30)
				var_4_32[2] = Localize("gift_popup_sub_title_halloween")
				var_4_33[#var_4_33 + 1] = {
					widget_type = "description",
					value = var_4_32
				}
				var_4_33[#var_4_33 + 1] = {
					widget_type = "icon",
					value = var_4_31
				}
				var_4_0[#var_4_0 + 1] = var_4_33
				var_4_0.sounds = var_4_3
			elseif var_4_2 == "weapon_skin" then
				local var_4_34 = iter_4_1.weapon_skin_name
				local var_4_35 = WeaponSkins.skins[var_4_34]
				local var_4_36 = var_4_35.display_name
				local var_4_37 = var_4_35.inventory_icon
				local var_4_38 = {}
				local var_4_39 = {}

				var_4_38[1] = Localize(var_4_36)
				var_4_38[2] = Localize("gift_popup_sub_title_halloween")
				var_4_39[#var_4_39 + 1] = {
					widget_type = "description",
					value = var_4_38
				}
				var_4_39[#var_4_39 + 1] = {
					widget_type = "icon",
					value = var_4_37
				}
				var_4_0[#var_4_0 + 1] = var_4_39
				var_4_0.sounds = var_4_3
			end
		end

		arg_4_0:_present_reward(var_4_0)
	end
end

function RewardsPopupUI._displaying_reward_presentation(arg_7_0)
	return arg_7_0._reward_popup:is_presentation_active()
end

function RewardsPopupUI._is_reward_presentation_complete(arg_8_0)
	return arg_8_0._reward_popup:is_presentation_complete()
end

function RewardsPopupUI.all_presentations_done(arg_9_0)
	local var_9_0 = not arg_9_0:_displaying_reward_presentation()
	local var_9_1 = #arg_9_0._reward_presentation_queue

	return var_9_0 and var_9_1 == 0
end

function RewardsPopupUI._handle_queued_presentations(arg_10_0)
	if arg_10_0:_is_reward_presentation_complete() or #arg_10_0._reward_presentation_queue == 0 and not arg_10_0:_displaying_reward_presentation() then
		local var_10_0 = arg_10_0._reward_presentation_queue

		if #var_10_0 > 0 then
			local var_10_1 = table.remove(var_10_0, 1)

			arg_10_0:_present_reward(var_10_1)
		elseif arg_10_0._reward_presentation_active then
			arg_10_0._reward_presentation_active = false
		end
	end
end

function RewardsPopupUI._play_sounds(arg_11_0, arg_11_1)
	if not arg_11_1 then
		return
	end

	for iter_11_0 = 1, #arg_11_1 do
		local var_11_0 = arg_11_1[iter_11_0]

		Managers.music:trigger_event(var_11_0)
	end
end

function RewardsPopupUI._present_reward(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0._reward_popup

	if arg_12_0:_displaying_reward_presentation() then
		local var_12_1 = arg_12_0._reward_presentation_queue

		var_12_1[#var_12_1 + 1] = arg_12_1
	else
		arg_12_0:_play_sounds(arg_12_1.sounds)
		var_12_0:display_presentation(arg_12_1)

		arg_12_0._reward_presentation_active = true
	end
end
