-- chunkname: @scripts/ui/views/store_login_rewards_popup.lua

local var_0_0 = local_require("scripts/ui/views/store_login_rewards_popup_definitions")

StoreLoginRewardsPopup = class(StoreLoginRewardsPopup)

local var_0_1 = table.enum("refresh", "default", "claiming", "wait_for_backend", "presenting", "exiting", "exited")

StoreLoginRewardsPopup.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0._ui_renderer = arg_1_2.ui_top_renderer
	arg_1_0._render_settings = {
		alpha_multiplier = 1
	}
	arg_1_0._state = var_0_1.refresh
	arg_1_0._has_claimed_rewards = false
	arg_1_0._gamepad_active = false
	arg_1_0._cursor_x = nil
	arg_1_0._cursor_y = nil
	arg_1_0._selected_widget = nil
	arg_1_0._refresh_cooldown = 0

	arg_1_0:_create_ui_elements()

	arg_1_0._backend_store = Managers.backend:get_interface("peddler")
	arg_1_0._rewards_claimable = nil
	arg_1_0._reward_popup = RewardPopupUI:new(arg_1_2)
	arg_1_0._show_gamepad_tooltips = false
end

StoreLoginRewardsPopup.destroy = function (arg_2_0)
	if arg_2_0._reward_popup then
		arg_2_0._reward_popup:destroy()

		arg_2_0._reward_popup = nil
	end
end

StoreLoginRewardsPopup._create_ui_elements = function (arg_3_0)
	arg_3_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	arg_3_0._widgets, arg_3_0._widgets_by_name = UIUtils.create_widgets(var_0_0.widget_definitions)
	arg_3_0._overlay_widgets, arg_3_0._overlay_widgets_by_name = UIUtils.create_widgets(var_0_0.overlay_widgets_definitions)
	arg_3_0._loading_widgets, arg_3_0._loading_widgets_by_name = UIUtils.create_widgets(var_0_0.loading_widgets_definitions)
	arg_3_0._day_widgets = UIUtils.create_widgets(var_0_0.day_widget_definitions)
	arg_3_0._reward_widgets = {}

	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_renderer)

	local var_3_0 = arg_3_0._parent:input_service()

	arg_3_0._menu_input_description = MenuInputDescriptionUI:new(nil, arg_3_0._ui_renderer, var_3_0, 5, 900, var_0_0.generic_input_actions.default)

	arg_3_0._menu_input_description:set_input_description(nil)

	arg_3_0._widgets_by_name.claim_button.content.button_hotspot.disable_button = script_data["eac-untrusted"]
	arg_3_0._ui_animator = UIAnimator:new(arg_3_0._ui_scenegraph, var_0_0.animation_definitions)
	arg_3_0._animations = {}
end

StoreLoginRewardsPopup._has_claimed_reward = function (arg_4_0, arg_4_1, arg_4_2)
	for iter_4_0, iter_4_1 in ipairs(arg_4_1) do
		if arg_4_2 == iter_4_1 then
			return true
		end
	end

	return false
end

StoreLoginRewardsPopup._setup_rewards_data = function (arg_5_0, arg_5_1)
	if arg_5_1.event_type ~= "personal_time_strike" then
		Managers.ui:handle_transition("close_active", {
			fade_out_speed = 1,
			use_fade = true,
			fade_in_speed = 1
		})

		return
	end

	local var_5_0 = arg_5_1.rewards
	local var_5_1 = arg_5_1.total_claims or 0
	local var_5_2 = arg_5_0._day_widgets
	local var_5_3 = arg_5_0._reward_widgets

	table.clear(var_5_3)

	local var_5_4 = arg_5_0._widgets_by_name

	arg_5_0._gamepad_active = Managers.input:is_device_active("gamepad")

	local var_5_5 = arg_5_0._cursor_x or math.clamp(var_5_1 + 1, 1, #var_5_0)
	local var_5_6 = arg_5_0._cursor_y or 1

	arg_5_0._cursor_x = var_5_5
	arg_5_0._cursor_y = var_5_6

	local var_5_7 = arg_5_1.event_type and arg_5_1.event_type or "personal_time_strike"
	local var_5_8 = arg_5_1.claimed_rewards and arg_5_1.claimed_rewards or {}
	local var_5_9 = os.time(os.date("!*t"))
	local var_5_10 = os.time(os.date("!*t", arg_5_1.next_claim_timestamp / 1000)) - var_5_9
	local var_5_11 = var_5_1 == #var_5_2 and var_5_10 <= 0

	for iter_5_0 = 1, #var_5_2 do
		local var_5_12 = var_5_2[iter_5_0].content

		var_5_12.is_today = not var_5_11 and iter_5_0 == var_5_1

		local var_5_13

		if var_5_7 == "calendar" then
			var_5_13 = arg_5_0:_has_claimed_reward(var_5_8, iter_5_0) and not var_5_11
		else
			var_5_13 = not var_5_11 and iter_5_0 <= var_5_1
		end

		var_5_12.is_claimed = var_5_13

		local var_5_14 = var_5_0[iter_5_0]

		var_5_12.reward_count = #var_5_14
		var_5_12.selection_index = arg_5_0._cursor_x
		var_5_12.calendar_type = var_5_7
		var_5_12.current_day = var_5_1
		var_5_12.is_loop = var_5_11

		for iter_5_1 = 1, #var_5_14 do
			local var_5_15 = var_0_0.create_reward_item_widget(iter_5_0, iter_5_1)
			local var_5_16 = UIWidget.init(var_5_15)

			var_5_3[#var_5_3 + 1] = var_5_16

			local var_5_17 = var_5_14[iter_5_1]
			local var_5_18

			if var_5_17.reward_type == "currency" then
				var_5_18 = BackendUtils.get_fake_currency_item(var_5_17.currency_code, var_5_17.amount)
			else
				var_5_18 = ItemMasterList[var_5_17.item_id]
			end

			local var_5_19 = table.merge({
				backend_id = math.uuid(),
				data = var_5_18
			}, var_5_17)

			fassert(var_5_19.data, "Reward item %s not found in ItemMasterList", var_5_17.item_id)

			local var_5_20 = var_5_19.rarity or var_5_19.data and var_5_19.data.rarity or "plentiful"
			local var_5_21 = var_5_16.content

			var_5_21.item = var_5_19
			var_5_21.item_icon = UIUtils.get_ui_information_from_item(var_5_19) or "icons_placeholder"
			var_5_21.item_rarity = UISettings.item_rarity_textures[var_5_20] or "icons_placeholder"
			var_5_21.is_illusion = var_5_19.item_type == "weapon_skin"
			var_5_21.day_index = iter_5_0
			var_5_21.item_index = iter_5_1

			local var_5_22 = var_5_5 == iter_5_0 and var_5_6 == iter_5_1

			var_5_21.is_selected = var_5_22

			if var_5_22 then
				arg_5_0._selected_widget = var_5_16
			end
		end
	end

	local var_5_23 = 1 + var_5_1 % #var_5_2
	local var_5_24 = var_5_2[var_5_23].offset

	arg_5_0._ui_scenegraph.claim_button.position[1] = var_5_24[1]
	arg_5_0._next_reward_index = var_5_23
	arg_5_0._will_loop = var_5_1 == #var_5_2
end

StoreLoginRewardsPopup._claim_rewards = function (arg_6_0)
	if arg_6_0._waiting_for_claim then
		return
	end

	arg_6_0._state = var_0_1.claiming
	arg_6_0._widgets_by_name.claim_button.content.visible = false
	arg_6_0._widgets_by_name.claim_button_glow.content.visible = false

	arg_6_0._backend_store:claim_login_rewards()

	arg_6_0._has_claimed_rewards = true

	local var_6_0 = arg_6_0._selected_widget

	if var_6_0 then
		var_6_0.content.is_selected = false
		arg_6_0._selected_widget = nil
	end

	arg_6_0._parent:play_sound("Play_hud_daily_reward_claim")

	local var_6_1 = arg_6_0._next_reward_index
	local var_6_2 = arg_6_0._day_widgets

	for iter_6_0 = 1, #var_6_2 do
		var_6_2[iter_6_0].content.is_today = false
	end

	local var_6_3 = var_6_2[var_6_1]
	local var_6_4 = var_6_3.content

	var_6_4.is_claimed = true
	var_6_4.is_today = true

	arg_6_0:_play_animation("on_claim", var_6_3)
end

StoreLoginRewardsPopup._refresh_login_rewards_cb = function (arg_7_0)
	arg_7_0._waiting_for_refresh = false
end

StoreLoginRewardsPopup.update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_0._backend_store
	local var_8_1 = var_8_0:get_login_rewards()
	local var_8_2 = os.time(os.date("!*t"))
	local var_8_3 = os.time(os.date("!*t", var_8_1.next_claim_timestamp / 1000))
	local var_8_4 = os.time(os.date("!*t", var_8_1.end_of_claim_timestamp / 1000))
	local var_8_5 = var_8_3 - var_8_2
	local var_8_6 = var_8_4 - var_8_2
	local var_8_7 = arg_8_0._state
	local var_8_8 = arg_8_0._ui_animator
	local var_8_9 = arg_8_0._animations

	if var_8_7 == var_0_1.refresh then
		if var_8_0:done_claiming_login_rewards() and not arg_8_0._waiting_for_refresh and arg_8_3 > arg_8_0._refresh_cooldown then
			arg_8_0:_play_animation("on_enter")
			arg_8_0._parent:play_sound("Play_hud_daily_reward_open")

			arg_8_0._state = var_0_1.default

			arg_8_0:_setup_rewards_data(var_8_1)
			arg_8_0:_update_timer(var_8_5, var_8_6)

			arg_8_0._refresh_cooldown = arg_8_3 + 3
		end
	elseif var_8_7 == var_0_1.default then
		if var_8_6 <= -1 then
			local var_8_10 = callback(arg_8_0, "_refresh_login_rewards_cb")

			var_8_0:refresh_login_rewards(var_8_10)

			arg_8_0._waiting_for_refresh = true
			arg_8_0._state = var_0_1.refresh

			return
		end

		arg_8_0:_update_timer(var_8_5, var_8_6)
		arg_8_0:_handle_input(arg_8_1, arg_8_2, arg_8_3)
		arg_8_0:_handle_gamepad_input(arg_8_1)
	elseif var_8_7 == var_0_1.claiming then
		if not var_8_9.on_claim then
			arg_8_0._state = var_0_1.wait_for_backend

			local var_8_11 = arg_8_0._overlay_widgets_by_name

			var_8_11.loading_glow.content.visible = true
			var_8_11.loading_frame.content.visible = true
		end
	elseif var_8_7 == var_0_1.wait_for_backend then
		if var_8_0:done_claiming_login_rewards() then
			local var_8_12 = arg_8_0._overlay_widgets_by_name

			var_8_12.loading_glow.content.visible = false
			var_8_12.loading_frame.content.visible = false

			arg_8_0:_setup_rewards_data(var_8_1)

			if var_8_1.event_type ~= "personal_time_strike" then
				return
			end

			local var_8_13 = var_8_1.rewards
			local var_8_14 = var_8_1.total_claims or 1
			local var_8_15 = var_8_14 == 0 and #var_8_13 or var_8_14

			arg_8_0:_present_rewards(var_8_13[var_8_15])

			arg_8_0._state = var_0_1.presenting
		end
	elseif var_8_7 == var_0_1.presenting then
		if not arg_8_0._reward_popup:is_presentation_active() then
			arg_8_0._state = var_0_1.default
		end
	elseif var_8_7 == var_0_1.exiting and not var_8_9.on_exit then
		arg_8_0._state = var_0_1.exited
	end

	arg_8_0._reward_popup:update(arg_8_2)
	arg_8_0:_update_animations(arg_8_2)
	arg_8_0:_draw(var_8_7, arg_8_1, arg_8_2, arg_8_3)
end

StoreLoginRewardsPopup._present_rewards = function (arg_9_0, arg_9_1)
	local var_9_0 = #arg_9_1

	if var_9_0 == 0 then
		return
	end

	local var_9_1 = Managers.backend:get_interface("items")
	local var_9_2 = {}

	for iter_9_0 = 1, var_9_0 do
		local var_9_3 = arg_9_1[iter_9_0]
		local var_9_4 = var_9_3.reward_type

		if var_9_4 == "item" or var_9_4 == "loot_chest" or var_9_4 == "crafting_material" then
			local var_9_5 = var_9_3.item_id
			local var_9_6 = ItemMasterList[var_9_5]

			var_9_2[#var_9_2 + 1] = {
				{
					widget_type = "description",
					value = {
						Localize(var_9_6.display_name),
						Localize("achv_menu_reward_claimed_title")
					}
				},
				{
					widget_type = "loot_chest",
					value = var_9_5
				}
			}
		elseif var_9_4 == "loot_chest" then
			local var_9_7 = var_9_3.item_id
			local var_9_8 = ItemMasterList[var_9_7]

			var_9_2[#var_9_2 + 1] = {
				{
					widget_type = "description",
					value = {
						Localize(var_9_8.display_name),
						Localize("achv_menu_reward_claimed_title")
					}
				},
				{
					widget_type = "loot_chest",
					value = var_9_7
				}
			}
		elseif var_9_4 == "chips" then
			local var_9_9 = var_9_3.item_id
			local var_9_10 = ItemMasterList[var_9_9]
			local var_9_11 = var_9_3.amount or var_9_10.bundle.BundledVirtualCurrencies.SM or 0

			var_9_2[#var_9_2 + 1] = {
				{
					widget_type = "description",
					value = {
						Localize(var_9_10.display_name),
						string.format(Localize("achv_menu_curreny_reward_claimed"), var_9_11)
					}
				},
				{
					widget_type = "icon",
					value = var_9_10.inventory_icon
				}
			}
		elseif var_9_4 == "currency" then
			local var_9_12, var_9_13, var_9_14 = BackendUtils.get_fake_currency_item(var_9_3.currency_code, var_9_3.amount)

			var_9_2[#var_9_2 + 1] = {
				{
					widget_type = "description",
					value = {
						Localize(var_9_12.display_name),
						string.format(Localize(var_9_14), var_9_3.amount)
					}
				},
				{
					widget_type = "icon",
					value = var_9_12.inventory_icon
				}
			}
		end
	end

	if #var_9_2 == 0 then
		return
	end

	arg_9_0._reward_popup:display_presentation(var_9_2)

	arg_9_0._reward_presentation_active = true
end

StoreLoginRewardsPopup._update_timer = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0._widgets_by_name
	local var_10_1 = var_10_0.timer

	if arg_10_1 <= 0 then
		if arg_10_0._rewards_claimable ~= true then
			arg_10_0._rewards_claimable = true

			arg_10_0:_play_sound("Play_gui_achivements_menu_claim_reward")

			var_10_0.claim_button.content.visible = true
			var_10_0.claim_button_glow.content.visible = true

			if arg_10_0._will_loop then
				local var_10_2 = arg_10_0._day_widgets

				for iter_10_0 = 1, #var_10_2 do
					local var_10_3 = var_10_2[iter_10_0].content

					var_10_3.is_today = false
					var_10_3.is_claimed = false
				end
			end

			var_10_1.style.text.horizontal_alignment = "right"
			var_10_1.style.text_shadow.horizontal_alignment = "right"
		end

		local var_10_4 = UIUtils.format_duration(arg_10_2)

		var_10_1.content.text = Localize("menu_store_expire_timer_expires_in") .. ": " .. var_10_4
	else
		if arg_10_0._rewards_claimable ~= false then
			arg_10_0._rewards_claimable = false
			var_10_0.claim_button.content.visible = false
			var_10_0.claim_button_glow.content.visible = false
			var_10_1.style.text.horizontal_alignment = "left"
			var_10_1.style.text_shadow.horizontal_alignment = "left"
		end

		local var_10_5 = UIUtils.format_duration(arg_10_1)

		var_10_1.content.text = Localize("store_login_rewards_next_available_in") .. var_10_5
	end
end

StoreLoginRewardsPopup._play_animation = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0._ui_animator:start_animation(arg_11_1, arg_11_2 or arg_11_0._widgets_by_name, arg_11_0._scenegraph_definition, arg_11_0._render_settings)

	arg_11_0._animations[arg_11_1] = var_11_0
end

StoreLoginRewardsPopup._update_animations = function (arg_12_0, arg_12_1)
	UIWidgetUtils.animate_default_button(arg_12_0._widgets_by_name.claim_button, arg_12_1)
	UIWidgetUtils.animate_default_button(arg_12_0._widgets_by_name.close_button, arg_12_1)

	local var_12_0 = arg_12_0._ui_animator
	local var_12_1 = arg_12_0._animations

	var_12_0:update(arg_12_1)

	for iter_12_0, iter_12_1 in pairs(var_12_1) do
		if var_12_0:is_animation_completed(iter_12_1) then
			var_12_1[iter_12_0] = nil
		end
	end
end

StoreLoginRewardsPopup._handle_input = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = arg_13_0._widgets_by_name
	local var_13_1 = var_13_0.close_button
	local var_13_2 = var_13_0.claim_button

	if UIUtils.is_button_hover_enter(var_13_1) or UIUtils.is_button_hover_enter(var_13_2) then
		arg_13_0:_play_sound("Play_hud_hover")
	end

	if UIUtils.is_button_pressed(var_13_1) or arg_13_1:get("toggle_menu", true) then
		arg_13_0:_play_sound("Play_hud_select")
		arg_13_0:_play_animation("on_exit")

		arg_13_0._state = var_0_1.exiting
	elseif UIUtils.is_button_pressed(var_13_2) then
		arg_13_0:_claim_rewards()
	end
end

StoreLoginRewardsPopup._handle_gamepad_input = function (arg_14_0, arg_14_1)
	local var_14_0 = Managers.input:is_device_active("gamepad")

	arg_14_0._gamepad_active = var_14_0

	if not var_14_0 then
		return
	end

	local var_14_1 = arg_14_0._day_widgets
	local var_14_2 = arg_14_0._cursor_x
	local var_14_3 = false

	if var_14_2 < #var_14_1 and arg_14_1:get("move_right") then
		var_14_2 = var_14_2 + 1
		var_14_3 = true
	elseif var_14_2 > 1 and arg_14_1:get("move_left") then
		var_14_2 = var_14_2 - 1
		var_14_3 = true
	end

	local var_14_4 = var_14_1[var_14_2].content.reward_count
	local var_14_5 = math.min(arg_14_0._cursor_y, var_14_4)

	if var_14_5 > 1 and arg_14_1:get("move_up") then
		var_14_5 = var_14_5 - 1
		var_14_3 = true
	elseif var_14_5 < var_14_4 and arg_14_1:get("move_down") then
		var_14_5 = var_14_5 + 1
		var_14_3 = true
	end

	if var_14_3 then
		arg_14_0._cursor_x = var_14_2
		arg_14_0._cursor_y = var_14_5

		local var_14_6 = arg_14_0._reward_widgets

		for iter_14_0 = 1, #var_14_6 do
			local var_14_7 = var_14_6[iter_14_0]
			local var_14_8 = var_14_7.content
			local var_14_9 = var_14_8.day_index == var_14_2 and var_14_8.item_index == var_14_5

			var_14_8.is_selected = var_14_9

			if var_14_9 then
				arg_14_0._selected_widget = var_14_7
			end
		end
	elseif arg_14_1:get("right_stick_press") then
		arg_14_0._show_gamepad_tooltips = not arg_14_0._show_gamepad_tooltips

		local var_14_10 = arg_14_0._reward_widgets

		for iter_14_1 = 1, #var_14_10 do
			var_14_10[iter_14_1].content.show_tooltips = arg_14_0._show_gamepad_tooltips
		end
	elseif arg_14_0._rewards_claimable and arg_14_1:get("confirm_press") and arg_14_0._next_reward_index == arg_14_0._cursor_x then
		arg_14_0:_claim_rewards()

		return
	elseif arg_14_1:get("back") then
		arg_14_0:_play_animation("on_exit")

		arg_14_0._state = var_0_1.exiting

		return
	end

	local var_14_11 = arg_14_0._day_widgets

	for iter_14_2 = 1, #var_14_11 do
		var_14_11[iter_14_2].content.selection_index = arg_14_0._cursor_x
	end

	local var_14_12 = "default"

	if arg_14_0._rewards_claimable and arg_14_0._next_reward_index == arg_14_0._cursor_x then
		var_14_12 = "claim_available"
	end

	if var_14_12 ~= arg_14_0._input_description then
		arg_14_0._menu_input_description:change_generic_actions(var_0_0.generic_input_actions[var_14_12])
	end
end

StoreLoginRewardsPopup._draw = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	if arg_15_1 == var_0_1.exited then
		return
	end

	local var_15_0 = arg_15_0._ui_renderer

	UIRenderer.begin_pass(var_15_0, arg_15_0._ui_scenegraph, arg_15_2, arg_15_3, nil, arg_15_0._render_settings)

	if arg_15_1 == var_0_1.refresh then
		UIRenderer.draw_all_widgets(var_15_0, arg_15_0._loading_widgets)
	else
		UIRenderer.draw_all_widgets(var_15_0, arg_15_0._widgets)
		UIRenderer.draw_all_widgets(var_15_0, arg_15_0._day_widgets)
		UIRenderer.draw_all_widgets(var_15_0, arg_15_0._reward_widgets)

		if arg_15_1 == var_0_1.wait_for_backend or arg_15_1 == var_0_1.presenting then
			UIRenderer.draw_all_widgets(var_15_0, arg_15_0._overlay_widgets)
		end
	end

	UIRenderer.end_pass(var_15_0)

	if arg_15_0._gamepad_active then
		arg_15_0._menu_input_description:draw(var_15_0, arg_15_3)
	end
end

StoreLoginRewardsPopup.is_complete = function (arg_16_0)
	return arg_16_0._state == var_0_1.exited
end

StoreLoginRewardsPopup._play_sound = function (arg_17_0, arg_17_1)
	return arg_17_0._parent:play_sound(arg_17_1)
end

StoreLoginRewardsPopup.has_claimed_rewards = function (arg_18_0)
	return arg_18_0._has_claimed_rewards
end
