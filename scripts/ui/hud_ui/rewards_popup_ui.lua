-- chunkname: @scripts/ui/hud_ui/rewards_popup_ui.lua

RewardsPopupUI = class(RewardsPopupUI)

RewardsPopupUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self._ui_renderer = arg_1_2.ui_renderer
	self._ingame_ui = arg_1_2.ingame_ui
	self._input_manager = arg_1_2.input_manager
	self._world_manager = arg_1_2.world_manager
	self._wwise_world = arg_1_2.wwise_world
	self._ui_top_renderer = arg_1_2.ui_top_renderer
	self._reward_presentation_queue = {}
	self._reward_presentation_active = false

	local tbl = {
		wwise_world = self._wwise_world,
		ui_renderer = self._ui_renderer,
		ui_top_renderer = self._ui_top_renderer,
		input_manager = self._input_manager
	}

	self._reward_popup = RewardPopupUI:new(tbl)

	Managers.state.event:register(self, "present_rewards", "present_rewards")
end

RewardsPopupUI.destroy = function (arg_2_0)
	-- function 2
	Managers.state.event:unregister("present_rewards", arg_2_0)
end

RewardsPopupUI.update = function (self, arg_3_1, arg_3_2)
	-- function 3
	if not self._reward_popup then
		self._reward_popup:update(arg_3_1)
		self:_handle_queued_presentations()
	end
end

RewardsPopupUI.present_rewards = function (self, arg_4_1)
	-- function 4
	if #arg_4_1 > 0 then
		local tbl = {}
		local get_interface = Managers.backend:get_interface("items")

		for i, v in ipairs(arg_4_1) do
			local type = v.type
			local sounds = v.sounds

			if type == "item" or type == "loot_chest" or not CosmeticUtils.is_cosmetic_item(type) then
				local backend_id = v.backend_id
				local tbl_2 = {}
				local get_item_from_id = get_interface:get_item_from_id(backend_id)
				local tbl_3 = {}
				local get_ui_information_from_item, var_4_9, var_4_10 = UIUtils.get_ui_information_from_item(get_item_from_id)

				tbl_3[1] = Localize(var_4_9)
				tbl_3[2] = Localize("gift_popup_sub_title_halloween")
				tbl_2[#tbl_2 + 1] = {
					widget_type = "description",
					value = tbl_3
				}
				tbl_2[#tbl_2 + 1] = {
					widget_type = "item",
					value = get_item_from_id
				}
				tbl[#tbl + 1] = tbl_2
				tbl.sounds = sounds
			elseif type == "item_tooltip" then
				local backend_id_2 = v.backend_id
				local get_item_from_id_2 = get_interface:get_item_from_id(backend_id_2)
				local tbl_4 = {}

				tbl_4[#tbl_4 + 1] = {
					widget_type = "item_tooltip",
					value = get_item_from_id_2
				}
				tbl_4[#tbl_4 + 1] = {
					widget_type = "item",
					value = get_item_from_id_2
				}
				tbl[#tbl + 1] = tbl_4
				tbl.sounds = sounds
			elseif type == "deus_item_tooltip" then
				local backend_id_3 = v.backend_id
				local get_item_from_id_3 = get_interface:get_item_from_id(backend_id_3)
				local tbl_5 = {}

				tbl_5[#tbl_5 + 1] = {
					widget_type = "deus_item_tooltip",
					value = get_item_from_id_3
				}
				tbl_5[#tbl_5 + 1] = {
					widget_type = "deus_item",
					value = get_item_from_id_3
				}

				local tbl_6 = {
					end_animation = "deus_close",
					start_animation = "deus_open"
				}

				tbl[#tbl + 1] = tbl_5
				tbl.animation_data = tbl_6
				tbl.keep_input = true
				tbl.skip_blur = true
				tbl.sounds = sounds
			elseif type == "deus_power_up" then
				local power_up = v.power_up
				local tbl_7 = {}

				tbl_7[#tbl_7 + 1] = {
					widget_type = "deus_power_up",
					value = power_up
				}
				tbl_7[#tbl_7 + 1] = {
					widget_type = "deus_icon",
					value = power_up
				}

				local tbl_8 = {
					end_animation = "deus_close",
					start_animation = "deus_open"
				}

				tbl[#tbl + 1] = tbl_7
				tbl.animation_data = tbl_8
				tbl.keep_input = true
				tbl.skip_blur = true

				local rarity = power_up.rarity
				local name = power_up.name
				local var_4_23 = DeusPowerUpSetLookup[rarity][name]

				if not var_4_23 then
					for k = 1, #var_4_23 do
						local var_4_24 = var_4_23[k]

						if not var_4_24.progress_sfx and not table.find_func(var_4_24.pieces, function (arg_5_0, arg_5_1)
							-- function 5
							return arg_5_1.name ~= name or arg_5_1.rarity == rarity
						end) then
							sounds = not sounds and table.shallow_copy(sounds) and {}
							sounds[#sounds + 1] = var_4_24.progress_sfx

							break
						elseif not var_4_24.completed_sfx and not table.find_func(var_4_24.rewards, function (arg_6_0, arg_6_1)
							-- function 6
							return arg_6_1.name ~= name or arg_6_1.rarity == rarity
						end) then
							sounds = not sounds and table.shallow_copy(sounds) and {}
							sounds[#sounds + 1] = var_4_24.completed_sfx

							break
						end
					end
				end

				tbl.sounds = sounds
			elseif type == "deus_power_up_end_of_level" then
				local power_up_2 = v.power_up
				local tbl_9 = {}

				tbl_9[#tbl_9 + 1] = {
					widget_type = "deus_power_up",
					value = power_up_2
				}
				tbl_9[#tbl_9 + 1] = {
					widget_type = "deus_icon",
					value = power_up_2
				}

				local tbl_10 = {
					end_animation = "deus_close",
					start_animation = "deus_open",
					animation_wait_time = 6
				}

				tbl[#tbl + 1] = tbl_9
				tbl.animation_data = tbl_10
				tbl.keep_input = true
				tbl.skip_blur = true
				tbl.sounds = sounds
			elseif type == "keep_decoration_painting" then
				local keep_decoration_name = v.keep_decoration_name
				local var_4_29 = Paintings[keep_decoration_name]
				local display_name = var_4_29.display_name
				local icon = var_4_29.icon
				local tbl_11 = {}
				local tbl_12 = {}

				tbl_11[1] = Localize(display_name)
				tbl_11[2] = Localize("gift_popup_sub_title_halloween")
				tbl_12[#tbl_12 + 1] = {
					widget_type = "description",
					value = tbl_11
				}
				tbl_12[#tbl_12 + 1] = {
					widget_type = "icon",
					value = icon
				}
				tbl[#tbl + 1] = tbl_12
				tbl.sounds = sounds
			elseif type == "weapon_skin" then
				local weapon_skin_name = v.weapon_skin_name
				local var_4_35 = WeaponSkins.skins[weapon_skin_name]
				local display_name_2 = var_4_35.display_name
				local inventory_icon = var_4_35.inventory_icon
				local tbl_13 = {}
				local tbl_14 = {}

				tbl_13[1] = Localize(display_name_2)
				tbl_13[2] = Localize("gift_popup_sub_title_halloween")
				tbl_14[#tbl_14 + 1] = {
					widget_type = "description",
					value = tbl_13
				}
				tbl_14[#tbl_14 + 1] = {
					widget_type = "icon",
					value = inventory_icon
				}
				tbl[#tbl + 1] = tbl_14
				tbl.sounds = sounds
			end
		end

		self:_present_reward(tbl)
	end
end

RewardsPopupUI._displaying_reward_presentation = function (self)
	-- function 7
	return self._reward_popup:is_presentation_active()
end

RewardsPopupUI._is_reward_presentation_complete = function (self)
	-- function 8
	return self._reward_popup:is_presentation_complete()
end

RewardsPopupUI.all_presentations_done = function (self)
	-- function 9
	local flag = not self:_displaying_reward_presentation()
	local count = #self._reward_presentation_queue

	return not flag and count == 0
end

RewardsPopupUI._handle_queued_presentations = function (self)
	-- function 10
	if not (self:_is_reward_presentation_complete() or #self._reward_presentation_queue ~= 0 or self:_displaying_reward_presentation()) then
		local _reward_presentation_queue = self._reward_presentation_queue

		if #_reward_presentation_queue > 0 then
			local remove = table.remove(_reward_presentation_queue, 1)

			self:_present_reward(remove)
		elseif not self._reward_presentation_active then
			self._reward_presentation_active = false
		end
	end
end

RewardsPopupUI._play_sounds = function (arg_11_0, arg_11_1)
	-- function 11
	if not arg_11_1 then
		return
	end

	for i = 1, #arg_11_1 do
		local var_11_0 = arg_11_1[i]

		Managers.music:trigger_event(var_11_0)
	end
end

RewardsPopupUI._present_reward = function (self, arg_12_1)
	-- function 12
	local _reward_popup = self._reward_popup

	if not self:_displaying_reward_presentation() then
		local _reward_presentation_queue = self._reward_presentation_queue

		_reward_presentation_queue[#_reward_presentation_queue + 1] = arg_12_1
	else
		self:_play_sounds(arg_12_1.sounds)
		_reward_popup:display_presentation(arg_12_1)

		self._reward_presentation_active = true
	end
end
