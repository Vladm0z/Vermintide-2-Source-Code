-- chunkname: @scripts/ui/views/contract_presentation_screen_ui.lua

local var_0_0 = local_require("scripts/ui/views/contract_presentation_screen_ui_definitions")
local animation_definitions = var_0_0.animation_definitions
local scenegraph_definition = var_0_0.scenegraph_definition

ContractPresentationScreenUI = class(ContractPresentationScreenUI)

local flag = false
local num = 8

ContractPresentationScreenUI.init = function (self, arg_1_1)
	-- function 1
	self.ui_renderer = arg_1_1.ui_renderer
	self.ingame_ui = arg_1_1.ingame_ui
	self.input_manager = arg_1_1.input_manager
	self.peer_id = arg_1_1.peer_id
	self.player_manager = arg_1_1.player_manager
	self.game_won = arg_1_1.game_won
	self.ui_animations = {}
	self.world_manager = arg_1_1.world_manager

	local world = self.world_manager:world("level_world")

	self.wwise_world = Managers.world:wwise_world(world)
	self.quest_manager = Managers.state.quest

	local input_manager = self.input_manager

	input_manager:create_input_service("contract_presentation_screen_ui", "IngameMenuKeymaps", "IngameMenuFilters")
	input_manager:map_device_to_service("contract_presentation_screen_ui", "keyboard")
	input_manager:map_device_to_service("contract_presentation_screen_ui", "mouse")
	input_manager:map_device_to_service("contract_presentation_screen_ui", "gamepad")
	self:_create_ui_elements()
end

ContractPresentationScreenUI.on_enter = function (self, arg_2_1)
	-- function 2
	if not GameSettingsDevelopment.backend_settings.quests_enabled then
		local chat_is_focused = Managers.chat:chat_is_focused()
		local input_manager = self.input_manager

		if not (arg_2_1 or chat_is_focused) then
			input_manager:block_device_except_service("contract_presentation_screen_ui", "keyboard")
			input_manager:block_device_except_service("contract_presentation_screen_ui", "mouse")
			input_manager:block_device_except_service("contract_presentation_screen_ui", "gamepad")
		end

		local _initialize_active_contracts = self:_initialize_active_contracts()

		if not (not self.game_won and _initialize_active_contracts or self.num_active_contract_widget ~= 0) then
			self.is_complete = true
		else
			self.started = true
			self.is_complete = nil
		end

		self.waiting_for_input = nil
		self.exit_anim_id = nil
	else
		self.is_complete = true
	end
end

ContractPresentationScreenUI.input_service = function (self)
	-- function 3
	return self.input_manager:get_service("contract_presentation_screen_ui")
end

ContractPresentationScreenUI.destroy = function (self)
	-- function 4
	self.ui_animator = nil
end

ContractPresentationScreenUI.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not flag then
		self:_create_ui_elements()

		flag = false
	end

	if not (self.is_complete or self.started) then
		return
	end

	local ui_animator = self.ui_animator

	ui_animator:update(arg_5_1)

	local _update_continue_timer = self:_update_continue_timer(arg_5_1)

	if not self.waiting_for_input then
		if not self:_handle_animations() then
			self.waiting_for_input = true
			self.continue_timer = num
		end
	elseif self.exit_anim_id or self.input_manager:any_input_pressed() or not _update_continue_timer then
		self.exit_anim_id = self:_start_contract_animation(nil, "contracts_exit")
	end

	if not self.exit_anim_id and not ui_animator:is_animation_completed(self.exit_anim_id) then
		ui_animator:stop_animation(self.exit_anim_id)

		self.is_complete = true
	end

	self:_draw(arg_5_1)
end

ContractPresentationScreenUI._update_continue_timer = function (self, arg_6_1)
	-- function 6
	local continue_timer = self.continue_timer

	if not continue_timer then
		local num = continue_timer - arg_6_1

		if num <= 0 then
			self.continue_timer = nil

			return true
		else
			self.continue_timer = num
		end
	end
end

ContractPresentationScreenUI._draw = function (self, arg_7_1)
	-- function 7
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local input_manager = self.input_manager
	local get_service = input_manager:get_service("contract_presentation_screen_ui")
	local is_device_active = input_manager:is_device_active("gamepad")

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_7_1)
	UIRenderer.draw_widget(ui_renderer, self.title_text)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(ui_renderer, v)
	end

	if not (not self.waiting_for_input and self.exit_anim_id) then
		local _input_widgets = self._input_widgets
		local content = self.input_description_text.content
		local flag

		flag = not is_device_active and "press_any_button_to_continue" and "press_any_key_to_continue"
		content.text = flag

		UIRenderer.draw_widget(ui_renderer, self.input_description_text)
	end

	UIRenderer.end_pass(ui_renderer)
end

ContractPresentationScreenUI._create_ui_elements = function (self)
	-- function 8
	self.num_active_contract_widget = 0
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self.input_description_text = UIWidget.init(var_0_0.widget_definitions.input_description_text)
	self.title_text = UIWidget.init(var_0_0.widget_definitions.title_text)

	local tbl = {}

	for i, v in ipairs(var_0_0.entry_widget_definitions) do
		tbl[i] = UIWidget.init(v)
	end

	self._widgets = tbl

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)
end

ContractPresentationScreenUI._initialize_active_contracts = function (self)
	-- function 9
	local get_contracts = self.quest_manager:get_contracts()
	local tbl = {}

	for k, v in pairs(get_contracts) do
		if not (not self.quest_manager:get_session_progress_by_contract_id(k) and not v.active and v.turned_in) then
			tbl[#tbl + 1] = k
		end
	end

	local tbl_2 = {}
	local tbl_3 = {}
	local num = 0

	if #tbl > 0 then
		local _widgets = self._widgets

		for i, v_2 in ipairs(tbl) do
			num = num + 1

			local var_9_6 = _widgets[num]

			if not var_9_6 then
				local _set_contract_start_info_by_contract_id, var_9_8, var_9_9 = self:_set_contract_start_info_by_contract_id(var_9_6, v_2)

				tbl_2[v_2] = {
					contract_start_progress = var_9_8,
					contract_session_progress = var_9_9,
					widget_index = num,
					contract_id = v_2,
					task_data = _set_contract_start_info_by_contract_id,
					widget = var_9_6
				}
				tbl_3[num] = tbl_2[v_2]
			end
		end
	else
		return true
	end

	self.num_active_contract_widget = num
	self.contract_entries_by_index = tbl_3
	self.contract_entries = tbl_2
end

ContractPresentationScreenUI._set_contract_start_info_by_contract_id = function (self, arg_10_1, arg_10_2)
	-- function 10
	local quest_manager = self.quest_manager
	local task = quest_manager:get_contract_by_id(arg_10_2).requirements.task
	local get_title_for_contract_id = quest_manager:get_title_for_contract_id(arg_10_2)

	arg_10_1.content.title_text = get_title_for_contract_id

	local get_contract_progress = quest_manager:get_contract_progress(arg_10_2)
	local get_session_progress_by_contract_id = quest_manager:get_session_progress_by_contract_id(arg_10_2)
	local num = 0
	local tbl = {}
	local num_2 = 0
	local num_3 = 0
	local num_4 = 0

	if not task then
		local flag = get_contract_progress or 0
		local flag_2 = get_session_progress_by_contract_id or 0
		local max = math.max(flag - flag_2, 0)
		local required = task.amount.required
		local str = tostring(max) .. "/" .. tostring(required)

		num = num + 1

		self:_set_widget_task_info(arg_10_1, num, task.type, str)

		tbl[num] = {
			end_value = required,
			value = max,
			session_value = flag_2,
			has_changed = flag_2 > 0
		}
		num_3 = num_3 + max
		num_4 = num_4 + flag_2
		num_2 = num_2 + required
	end

	local num_5

	if num_2 > 0 then
		num_5 = num_3 / num_2

		if not num_5 then
			-- Nothing
		end
	end

	num_5 = 0

	::label_10_0::

	local max_2 = math.max(math.min(num_5, 1), 0)
	local num_6

	if num_2 > 0 then
		num_6 = num_4 / num_2

		if not num_6 then
			-- Nothing
		end
	end

	num_6 = 0

	::label_10_1::

	local max_3 = math.max(math.min(num_6, 1), 0)

	self:_set_widget_task_amount(arg_10_1, num)
	self:_set_widget_contract_progress(arg_10_1, max_2)

	return tbl, max_2, max_3
end

ContractPresentationScreenUI._set_widget_task_amount = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	arg_11_1.content.task_amount = arg_11_2

	local style = arg_11_1.style

	style.texture_divider.texture_amount = arg_11_2 - 1

	local task_bg_size = arg_11_1.style.task_bg_size
	local task_start_offset = arg_11_1.style.task_start_offset
	local num = task_bg_size[1] / arg_11_2

	for i = 1, arg_11_2 do
		local var_11_4 = style["task_text_" .. i]
		local var_11_5 = style["task_value_" .. i]
		local var_11_6 = style["texture_task_marker_" .. i]
		local var_11_7 = style["texture_task_glow_" .. i]
		local var_11_8 = style["texture_task_icon_" .. i]

		var_11_4.size[1] = num
		var_11_5.size[1] = num

		local num_2 = task_start_offset + num * (i - 1)

		var_11_4.offset[1] = num_2
		var_11_5.offset[1] = num_2

		local size = var_11_6.size

		var_11_6.offset[1] = 20 + (task_start_offset + num * (i - 1)) + (num * 0.5 - size[1] * 0.5)

		local size_2 = var_11_7.size

		var_11_7.offset[1] = task_start_offset + num * (i - 1) + (num * 0.5 - size_2[1] * 0.5)

		local size_3 = var_11_8.size

		var_11_8.offset[1] = task_start_offset + num * (i - 1) + (num * 0.5 - size_3[1] * 0.5)
	end
end

ContractPresentationScreenUI._sync_contracts_task_progress = function (self)
	-- function 12
	local _widgets = self._widgets
	local contract_entries = self.contract_entries

	if not contract_entries then
		for k, v in pairs(contract_entries) do
			self:_sync_contract_task_progress(k)
		end
	end
end

ContractPresentationScreenUI._sync_contract_task_progress = function (self, arg_13_1)
	-- function 13
	local var_13_0 = self.contract_entries[arg_13_1]
	local widget = var_13_0.widget
	local task_data = var_13_0.task_data
	local get_session_progress_by_contract_id = quest_manager:get_session_progress_by_contract_id(arg_13_1)
	local num = 0
	local num_2 = num + 1
	local var_13_6 = task_data[num_2]
	local str = tostring(task_value) .. "/" .. tostring(var_13_6.end_value)

	self:_set_widget_task_info(widget, num_2, nil, str)
end

ContractPresentationScreenUI._set_widget_contract_progress = function (arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	local content = arg_14_1.content
	local progress_bar = arg_14_1.style.progress_bar
	local progress_bar_2 = content.progress_bar

	progress_bar.size[1] = progress_bar.uv_scale_pixels * arg_14_2
	progress_bar_2.uvs[2][progress_bar.scale_axis] = arg_14_2
	arg_14_2 = math.floor(arg_14_2 * 100, 1)

	local str = tostring(arg_14_2) .. "%"

	content.bar_text = Localize("dlc1_3_1_contract_presentation_progress_prefix") .. ": " .. str
end

ContractPresentationScreenUI._set_widget_task_info = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	-- function 15
	local content = arg_15_1.content
	local style = arg_15_1.style

	if not arg_15_3 then
		local var_15_2 = QuestSettings.task_type_to_icon_lookup[arg_15_3]

		if not var_15_2 then
			content["texture_task_icon_" .. arg_15_2] = var_15_2
		else
			content["task_text_" .. arg_15_2] = arg_15_3
		end
	end

	if not arg_15_4 then
		content["task_value_" .. arg_15_2] = arg_15_4
	end
end

ContractPresentationScreenUI._get_text_size = function (self, arg_16_1, arg_16_2)
	-- function 16
	local ui_renderer = self.ui_renderer
	local size = arg_16_1.size
	local var_16_2, var_16_3 = UIFontByResolution(arg_16_1, nil)
	local var_16_4 = var_16_2[1]
	local var_16_5 = var_16_2[2]
	local var_16_6 = var_16_2[3]
	local var_16_7 = var_16_3
	local var_16_8, var_16_9, var_16_10 = UIGetFontHeight(ui_renderer.gui, var_16_6, var_16_7)
	local word_wrap = UIRenderer.word_wrap(ui_renderer, arg_16_2, var_16_4, var_16_7, size[1])
	local count = #word_wrap
	local inv_scale = RESOLUTION_LOOKUP.inv_scale
	local num = (var_16_10 + math.abs(var_16_9)) * inv_scale
	local num_2 = 0

	for i = 1, count do
		local var_16_16 = word_wrap[i]
		local text_size, var_16_18, var_16_19 = UIRenderer.text_size(ui_renderer, var_16_16, var_16_4, var_16_7, num)

		if num_2 < text_size then
			num_2 = text_size
		end
	end

	return count * num, num_2
end

ContractPresentationScreenUI._handle_animations = function (self)
	-- function 17
	local num_active_contract_widget = self.num_active_contract_widget
	local ui_animator = self.ui_animator

	if num_active_contract_widget > 0 then
		local contract_entries_by_index = self.contract_entries_by_index
		local flag = true

		for k, v in pairs(contract_entries_by_index) do
			local contract_id = v.contract_id

			if not v.animations_done then
				flag = true

				if not v.intro_started then
					local _start_contract_animation = self:_start_contract_animation(contract_id, "contract_entry")

					v.widget.content.visible = true
					v.intro_started = true
					v.intro_anim_id = _start_contract_animation

					return
				elseif not v.intro_anim_id and not ui_animator:is_animation_completed(v.intro_anim_id) then
					ui_animator:stop_animation(v.intro_anim_id)

					v.intro_anim_id = nil

					return
				end

				if not (not v.intro_started and v.intro_anim_id) then
					if not v.task_anims_done then
						if not v.animating_task_index then
							local task_data = v.task_data

							if #task_data > 0 then
								for k_2 = 1, #task_data do
									if not task_data[k_2].has_changed then
										local var_17_7 = k_2

										v.task_anim_id = self:_start_contract_animation(contract_id, "contract_task_progress", var_17_7)
										v.animating_task_index = var_17_7

										return
									end
								end
							end

							v.task_anims_done = true

							return
						elseif not v.task_anim_id and not ui_animator:is_animation_completed(v.task_anim_id) then
							ui_animator:stop_animation(v.task_anim_id)

							v.task_anim_id = nil

							local task_data_2 = v.task_data
							local animating_task_index = v.animating_task_index

							if animating_task_index < #task_data_2 then
								for l = animating_task_index + 1, #task_data_2 do
									if not task_data_2[l].has_changed then
										local var_17_10 = l

										v.task_anim_id = self:_start_contract_animation(contract_id, "contract_task_progress", var_17_10)
										v.animating_task_index = var_17_10

										return
									end
								end
							end

							v.task_anims_done = true

							return
						else
							return
						end
					elseif not v.summary_anim_done then
						if not v.summary_started then
							local flag_2

							flag_2 = not (v.contract_session_progress > 0) or not "contract_summary" or "no_progress"
							v.summary_anim_id = self:_start_contract_animation(contract_id, flag_2)
							v.summary_started = true

							return
						elseif not v.summary_anim_id and not ui_animator:is_animation_completed(v.summary_anim_id) then
							ui_animator:stop_animation(v.summary_anim_id)

							v.summary_anim_id = nil
							v.summary_anim_done = true

							return
						else
							return
						end
					elseif not v.end_started then
						if k < num_active_contract_widget then
							v.end_anim_id, v.end_started = self:_start_contract_animation(contract_id, "contract_move"), true

							return
						else
							v.animations_done = true
						end
					elseif not v.end_anim_id and not ui_animator:is_animation_completed(v.end_anim_id) then
						ui_animator:stop_animation(v.end_anim_id)

						v.end_anim_id = nil
						v.animations_done = true
					else
						return
					end
				else
					return
				end
			end
		end

		return flag
	else
		return true
	end
end

ContractPresentationScreenUI._start_contract_animation = function (self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	local flag = not arg_18_1 and self.contract_entries[arg_18_1]
	local flag_2 = not flag and flag.widget_index
	local flag_3 = not flag and flag.task_data
	local tbl = {
		wwise_world = self.wwise_world,
		widget_index = flag_2,
		task_data = flag_3,
		task_index = arg_18_3,
		num_widgets = self.num_active_contract_widget,
		contract_session_progress = not flag and flag.contract_session_progress,
		contract_start_progress = not flag and flag.contract_start_progress
	}

	return self.ui_animator:start_animation(arg_18_2, self._widgets, scenegraph_definition, tbl)
end
