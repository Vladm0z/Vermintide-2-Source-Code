-- chunkname: @scripts/ui/views/store_login_rewards_popup.lua

local var_0_0 = local_require("scripts/ui/views/store_login_rewards_popup_definitions")

StoreLoginRewardsPopup = class(StoreLoginRewardsPopup)

local enum = table.enum("refresh", "default", "claiming", "wait_for_backend", "presenting", "exiting", "exited")

StoreLoginRewardsPopup.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self._ui_renderer = arg_1_2.ui_top_renderer
	self._render_settings = {
		alpha_multiplier = 1
	}
	self._state = enum.refresh
	self._has_claimed_rewards = false
	self._gamepad_active = false
	self._cursor_x = nil
	self._cursor_y = nil
	self._selected_widget = nil
	self._refresh_cooldown = 0

	self:_create_ui_elements()

	self._backend_store = Managers.backend:get_interface("peddler")
	self._rewards_claimable = nil
	self._reward_popup = RewardPopupUI:new(arg_1_2)
	self._show_gamepad_tooltips = false
end

StoreLoginRewardsPopup.destroy = function (self)
	-- function 2
	if not self._reward_popup then
		self._reward_popup:destroy()

		self._reward_popup = nil
	end
end

StoreLoginRewardsPopup._create_ui_elements = function (self)
	-- function 3
	self._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	self._widgets, self._widgets_by_name = UIUtils.create_widgets(var_0_0.widget_definitions)
	self._overlay_widgets, self._overlay_widgets_by_name = UIUtils.create_widgets(var_0_0.overlay_widgets_definitions)
	self._loading_widgets, self._loading_widgets_by_name = UIUtils.create_widgets(var_0_0.loading_widgets_definitions)
	self._day_widgets = UIUtils.create_widgets(var_0_0.day_widget_definitions)
	self._reward_widgets = {}

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	local input_service = self._parent:input_service()

	self._menu_input_description = MenuInputDescriptionUI:new(nil, self._ui_renderer, input_service, 5, 900, var_0_0.generic_input_actions.default)

	self._menu_input_description:set_input_description(nil)

	self._widgets_by_name.claim_button.content.button_hotspot.disable_button = GameSettingsDevelopment.read_only_backend
	self._ui_animator = UIAnimator:new(self._ui_scenegraph, var_0_0.animation_definitions)
	self._animations = {}
end

StoreLoginRewardsPopup._has_claimed_reward = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	for i, v in ipairs(arg_4_1) do
		if arg_4_2 == v then
			return true
		end
	end

	return false
end

StoreLoginRewardsPopup._setup_rewards_data = function (self, arg_5_1)
	-- function 5
	if arg_5_1.event_type ~= "personal_time_strike" then
		Managers.ui:handle_transition("close_active", {
			fade_out_speed = 1,
			use_fade = true,
			fade_in_speed = 1
		})

		return
	end

	local rewards = arg_5_1.rewards
	local total_claims = arg_5_1.total_claims

	total_claims = total_claims or 0

	local _day_widgets = self._day_widgets
	local _reward_widgets = self._reward_widgets

	table.clear(_reward_widgets)

	local _widgets_by_name = self._widgets_by_name

	self._gamepad_active = Managers.input:is_device_active("gamepad")

	local _cursor_x = self._cursor_x

	_cursor_x = _cursor_x or math.clamp(total_claims + 1, 1, #rewards)

	local _cursor_y = self._cursor_y

	_cursor_y = _cursor_y or 1
	self._cursor_x = _cursor_x
	self._cursor_y = _cursor_y

	local event_type

	if not arg_5_1.event_type then
		event_type = arg_5_1.event_type

		if not event_type then
			-- Nothing
		end
	end

	event_type = "personal_time_strike"

	do
		local claimed_rewards
	end

	::label_5_0::

	if not arg_5_1.claimed_rewards then
		claimed_rewards = arg_5_1.claimed_rewards

		if not claimed_rewards then
			-- Nothing
		end
	end

	claimed_rewards = {}

	::label_5_1::

	local time = os.time(os.date("!*t"))
	local num = os.time(os.date("!*t", arg_5_1.next_claim_timestamp / 1000)) - time
	local flag = total_claims ~= #_day_widgets or num <= 0

	for i = 1, #_day_widgets do
		local content = _day_widgets[i].content

		content.is_today = not not flag or i == total_claims

		local var_5_13

		if event_type == "calendar" then
			var_5_13 = not self:_has_claimed_reward(claimed_rewards, i) and not flag
		else
			var_5_13 = not not flag or i <= total_claims
		end

		content.is_claimed = var_5_13

		local var_5_14 = rewards[i]

		content.reward_count = #var_5_14
		content.selection_index = self._cursor_x
		content.calendar_type = event_type
		content.current_day = total_claims
		content.is_loop = flag

		for j = 1, #var_5_14 do
			local create_reward_item_widget = var_0_0.create_reward_item_widget(i, j)
			local var_5_16 = UIWidget.init(create_reward_item_widget)

			_reward_widgets[#_reward_widgets + 1] = var_5_16

			local var_5_17 = var_5_14[j]
			local var_5_18

			if var_5_17.reward_type == "currency" then
				var_5_18 = BackendUtils.get_fake_currency_item(var_5_17.currency_code, var_5_17.amount)
			else
				var_5_18 = ItemMasterList[var_5_17.item_id]
			end

			local merge = table.merge({
				backend_id = math.uuid(),
				data = var_5_18
			}, var_5_17)

			fassert(merge.data, "Reward item %s not found in ItemMasterList", var_5_17.item_id)

			local rarity = merge.rarity

			if not rarity then
				if not merge.data then
					rarity = merge.data.rarity

					if not rarity then
						-- Nothing
					end
				end

				rarity = "plentiful"
			end

			::label_5_2::

			local content_2 = var_5_16.content

			content_2.item = merge

			local get_ui_information_from_item = UIUtils.get_ui_information_from_item(merge)

			get_ui_information_from_item = get_ui_information_from_item or "icons_placeholder"
			content_2.item_icon = get_ui_information_from_item

			local var_5_23 = UISettings.item_rarity_textures[rarity]

			var_5_23 = var_5_23 or "icons_placeholder"
			content_2.item_rarity = var_5_23
			content_2.is_illusion = merge.item_type == "weapon_skin"
			content_2.day_index = i
			content_2.item_index = j

			local flag_2 = _cursor_x ~= i or _cursor_y == j

			content_2.is_selected = flag_2

			if not flag_2 then
				self._selected_widget = var_5_16
			end
		end
	end

	local num_2 = 1 + total_claims % #_day_widgets
	local offset = _day_widgets[num_2].offset

	self._ui_scenegraph.claim_button.position[1] = offset[1]
	self._next_reward_index = num_2
	self._will_loop = total_claims == #_day_widgets
end

StoreLoginRewardsPopup._claim_rewards = function (self)
	-- function 6
	if not self._waiting_for_claim then
		return
	end

	self._state = enum.claiming
	self._widgets_by_name.claim_button.content.visible = false
	self._widgets_by_name.claim_button_glow.content.visible = false

	self._backend_store:claim_login_rewards()

	self._has_claimed_rewards = true

	local _selected_widget = self._selected_widget

	if not _selected_widget then
		_selected_widget.content.is_selected = false
		self._selected_widget = nil
	end

	self._parent:play_sound("Play_hud_daily_reward_claim")

	local _next_reward_index = self._next_reward_index
	local _day_widgets = self._day_widgets

	for i = 1, #_day_widgets do
		_day_widgets[i].content.is_today = false
	end

	local var_6_3 = _day_widgets[_next_reward_index]
	local content = var_6_3.content

	content.is_claimed = true
	content.is_today = true

	self:_play_animation("on_claim", var_6_3)
end

StoreLoginRewardsPopup._refresh_login_rewards_cb = function (self)
	-- function 7
	self._waiting_for_refresh = false
end

StoreLoginRewardsPopup.update = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local _backend_store = self._backend_store
	local get_login_rewards = _backend_store:get_login_rewards()
	local time = os.time(os.date("!*t"))
	local time_2 = os.time(os.date("!*t", get_login_rewards.next_claim_timestamp / 1000))
	local time_3 = os.time(os.date("!*t", get_login_rewards.end_of_claim_timestamp / 1000))
	local num = time_2 - time
	local num_2 = time_3 - time
	local _state = self._state
	local _ui_animator = self._ui_animator
	local _animations = self._animations

	if _state == enum.refresh then
		if not (not _backend_store:done_claiming_login_rewards() and self._waiting_for_refresh or not (arg_8_3 > self._refresh_cooldown)) then
			self:_play_animation("on_enter")
			self._parent:play_sound("Play_hud_daily_reward_open")

			self._state = enum.default

			self:_setup_rewards_data(get_login_rewards)
			self:_update_timer(num, num_2)

			self._refresh_cooldown = arg_8_3 + 3
		end
	elseif _state == enum.default then
		if num_2 <= -1 then
			local var_8_10 = callback(self, "_refresh_login_rewards_cb")

			_backend_store:refresh_login_rewards(var_8_10)

			self._waiting_for_refresh = true
			self._state = enum.refresh

			return
		end

		self:_update_timer(num, num_2)
		self:_handle_input(arg_8_1, arg_8_2, arg_8_3)
		self:_handle_gamepad_input(arg_8_1)
	elseif _state == enum.claiming then
		if not _animations.on_claim then
			self._state = enum.wait_for_backend

			local _overlay_widgets_by_name = self._overlay_widgets_by_name

			_overlay_widgets_by_name.loading_glow.content.visible = true
			_overlay_widgets_by_name.loading_frame.content.visible = true
		end
	elseif _state == enum.wait_for_backend then
		if not _backend_store:done_claiming_login_rewards() then
			local _overlay_widgets_by_name_2 = self._overlay_widgets_by_name

			_overlay_widgets_by_name_2.loading_glow.content.visible = false
			_overlay_widgets_by_name_2.loading_frame.content.visible = false

			self:_setup_rewards_data(get_login_rewards)

			if get_login_rewards.event_type ~= "personal_time_strike" then
				return
			end

			local rewards = get_login_rewards.rewards
			local total_claims = get_login_rewards.total_claims

			total_claims = total_claims or 1

			local count

			if total_claims == 0 then
				count = #rewards

				if not count then
					-- Nothing
				end
			end

			count = total_claims

			::label_8_0::

			self:_present_rewards(rewards[count])

			self._state = enum.presenting
		end
	elseif _state == enum.presenting then
		if not self._reward_popup:is_presentation_active() then
			self._state = enum.default
		end
	elseif not (_state ~= enum.exiting or _animations.on_exit) then
		self._state = enum.exited
	end

	self._reward_popup:update(arg_8_2)
	self:_update_animations(arg_8_2)
	self:_draw(_state, arg_8_1, arg_8_2, arg_8_3)
end

StoreLoginRewardsPopup._present_rewards = function (self, arg_9_1)
	-- function 9
	local count = #arg_9_1

	if count == 0 then
		return
	end

	local get_interface = Managers.backend:get_interface("items")
	local tbl = {}

	for i = 1, count do
		local var_9_3 = arg_9_1[i]
		local reward_type = var_9_3.reward_type

		if not (reward_type == "item" or reward_type == "loot_chest" or reward_type ~= "crafting_material") then
			local item_id = var_9_3.item_id
			local var_9_6 = ItemMasterList[item_id]

			tbl[#tbl + 1] = {
				{
					widget_type = "description",
					value = {
						Localize(var_9_6.display_name),
						Localize("achv_menu_reward_claimed_title")
					}
				},
				{
					widget_type = "loot_chest",
					value = item_id
				}
			}
		elseif reward_type == "loot_chest" then
			local item_id_2 = var_9_3.item_id
			local var_9_8 = ItemMasterList[item_id_2]

			tbl[#tbl + 1] = {
				{
					widget_type = "description",
					value = {
						Localize(var_9_8.display_name),
						Localize("achv_menu_reward_claimed_title")
					}
				},
				{
					widget_type = "loot_chest",
					value = item_id_2
				}
			}
		elseif reward_type == "chips" then
			local item_id_3 = var_9_3.item_id
			local var_9_10 = ItemMasterList[item_id_3]
			local amount = var_9_3.amount

			if not amount then
				amount = var_9_10.bundle.BundledVirtualCurrencies.SM
				amount = amount or 0
			end

			tbl[#tbl + 1] = {
				{
					widget_type = "description",
					value = {
						Localize(var_9_10.display_name),
						string.format(Localize("achv_menu_curreny_reward_claimed"), amount)
					}
				},
				{
					widget_type = "icon",
					value = var_9_10.inventory_icon
				}
			}
		elseif reward_type == "currency" then
			local get_fake_currency_item, var_9_13, var_9_14 = BackendUtils.get_fake_currency_item(var_9_3.currency_code, var_9_3.amount)

			tbl[#tbl + 1] = {
				{
					widget_type = "description",
					value = {
						Localize(get_fake_currency_item.display_name),
						string.format(Localize(var_9_14), var_9_3.amount)
					}
				},
				{
					widget_type = "icon",
					value = get_fake_currency_item.inventory_icon
				}
			}
		end
	end

	if #tbl == 0 then
		return
	end

	self._reward_popup:display_presentation(tbl)

	self._reward_presentation_active = true
end

StoreLoginRewardsPopup._update_timer = function (self, arg_10_1, arg_10_2)
	-- function 10
	local _widgets_by_name = self._widgets_by_name
	local timer = _widgets_by_name.timer

	if arg_10_1 <= 0 then
		if self._rewards_claimable ~= true then
			self._rewards_claimable = true

			self:_play_sound("Play_gui_achivements_menu_claim_reward")

			_widgets_by_name.claim_button.content.visible = true
			_widgets_by_name.claim_button_glow.content.visible = true

			if not self._will_loop then
				local _day_widgets = self._day_widgets

				for i = 1, #_day_widgets do
					local content = _day_widgets[i].content

					content.is_today = false
					content.is_claimed = false
				end
			end

			timer.style.text.horizontal_alignment = "right"
			timer.style.text_shadow.horizontal_alignment = "right"
		end

		local format_duration = UIUtils.format_duration(arg_10_2)

		timer.content.text = Localize("menu_store_expire_timer_expires_in") .. ": " .. format_duration
	else
		if self._rewards_claimable ~= false then
			self._rewards_claimable = false
			_widgets_by_name.claim_button.content.visible = false
			_widgets_by_name.claim_button_glow.content.visible = false
			timer.style.text.horizontal_alignment = "left"
			timer.style.text_shadow.horizontal_alignment = "left"
		end

		local format_duration_2 = UIUtils.format_duration(arg_10_1)

		timer.content.text = Localize("store_login_rewards_next_available_in") .. format_duration_2
	end
end

StoreLoginRewardsPopup._play_animation = function (self, arg_11_1, arg_11_2)
	-- function 11
	local start_animation = self._ui_animator:start_animation(arg_11_1, arg_11_2 or self._widgets_by_name, self._scenegraph_definition, self._render_settings)

	self._animations[arg_11_1] = start_animation
end

StoreLoginRewardsPopup._update_animations = function (self, arg_12_1)
	-- function 12
	UIWidgetUtils.animate_default_button(self._widgets_by_name.claim_button, arg_12_1)
	UIWidgetUtils.animate_default_button(self._widgets_by_name.close_button, arg_12_1)

	local _ui_animator = self._ui_animator
	local _animations = self._animations

	_ui_animator:update(arg_12_1)

	for k, v in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v) then
			_animations[k] = nil
		end
	end
end

StoreLoginRewardsPopup._handle_input = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local _widgets_by_name = self._widgets_by_name
	local close_button = _widgets_by_name.close_button
	local claim_button = _widgets_by_name.claim_button

	if UIUtils.is_button_hover_enter(close_button) or not UIUtils.is_button_hover_enter(claim_button) then
		self:_play_sound("Play_hud_hover")
	end

	if UIUtils.is_button_pressed(close_button) or not arg_13_1:get("toggle_menu", true) then
		self:_play_sound("Play_hud_select")
		self:_play_animation("on_exit")

		self._state = enum.exiting
	elseif not UIUtils.is_button_pressed(claim_button) then
		self:_claim_rewards()
	end
end

StoreLoginRewardsPopup._handle_gamepad_input = function (self, arg_14_1)
	-- function 14
	local is_device_active = Managers.input:is_device_active("gamepad")

	self._gamepad_active = is_device_active

	if not is_device_active then
		return
	end

	local _day_widgets = self._day_widgets
	local _cursor_x = self._cursor_x
	local flag = false

	if not (_cursor_x < #_day_widgets) or not arg_14_1:get("move_right") then
		_cursor_x = _cursor_x + 1
		flag = true
	elseif not (_cursor_x > 1) or not arg_14_1:get("move_left") then
		_cursor_x = _cursor_x - 1
		flag = true
	end

	local reward_count = _day_widgets[_cursor_x].content.reward_count
	local min = math.min(self._cursor_y, reward_count)

	if not (min > 1) or not arg_14_1:get("move_up") then
		min = min - 1
		flag = true
	elseif not (min < reward_count) or not arg_14_1:get("move_down") then
		min = min + 1
		flag = true
	end

	if not flag then
		self._cursor_x = _cursor_x
		self._cursor_y = min

		local _reward_widgets = self._reward_widgets

		for i = 1, #_reward_widgets do
			local var_14_7 = _reward_widgets[i]
			local content = var_14_7.content
			local flag_2 = content.day_index ~= _cursor_x or content.item_index == min

			content.is_selected = flag_2

			if not flag_2 then
				self._selected_widget = var_14_7
			end
		end
	elseif not arg_14_1:get("right_stick_press") then
		self._show_gamepad_tooltips = not self._show_gamepad_tooltips

		local _reward_widgets_2 = self._reward_widgets

		for j = 1, #_reward_widgets_2 do
			_reward_widgets_2[j].content.show_tooltips = self._show_gamepad_tooltips
		end
	elseif not (not self._rewards_claimable and not arg_14_1:get("confirm_press") and self._next_reward_index ~= self._cursor_x) then
		self:_claim_rewards()

		return
	elseif not arg_14_1:get("back") then
		self:_play_animation("on_exit")

		self._state = enum.exiting

		return
	end

	local _day_widgets_2 = self._day_widgets

	for k = 1, #_day_widgets_2 do
		_day_widgets_2[k].content.selection_index = self._cursor_x
	end

	local str = "default"

	if not (not self._rewards_claimable and self._next_reward_index ~= self._cursor_x) then
		str = "claim_available"
	end

	if str ~= self._input_description then
		self._menu_input_description:change_generic_actions(var_0_0.generic_input_actions[str])
	end
end

StoreLoginRewardsPopup._draw = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	-- function 15
	if arg_15_1 == enum.exited then
		return
	end

	local _ui_renderer = self._ui_renderer

	UIRenderer.begin_pass(_ui_renderer, self._ui_scenegraph, arg_15_2, arg_15_3, nil, self._render_settings)

	if arg_15_1 == enum.refresh then
		UIRenderer.draw_all_widgets(_ui_renderer, self._loading_widgets)
	else
		UIRenderer.draw_all_widgets(_ui_renderer, self._widgets)
		UIRenderer.draw_all_widgets(_ui_renderer, self._day_widgets)
		UIRenderer.draw_all_widgets(_ui_renderer, self._reward_widgets)

		if not (arg_15_1 == enum.wait_for_backend or arg_15_1 ~= enum.presenting) then
			UIRenderer.draw_all_widgets(_ui_renderer, self._overlay_widgets)
		end
	end

	UIRenderer.end_pass(_ui_renderer)

	if not self._gamepad_active then
		self._menu_input_description:draw(_ui_renderer, arg_15_3)
	end
end

StoreLoginRewardsPopup.is_complete = function (self)
	-- function 16
	return self._state == enum.exited
end

StoreLoginRewardsPopup._play_sound = function (self, arg_17_1)
	-- function 17
	return self._parent:play_sound(arg_17_1)
end

StoreLoginRewardsPopup.has_claimed_rewards = function (self)
	-- function 18
	return self._has_claimed_rewards
end
