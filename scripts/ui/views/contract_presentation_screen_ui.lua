-- chunkname: @scripts/ui/views/contract_presentation_screen_ui.lua

local var_0_0 = local_require("scripts/ui/views/contract_presentation_screen_ui_definitions")
local var_0_1 = var_0_0.animation_definitions
local var_0_2 = var_0_0.scenegraph_definition

ContractPresentationScreenUI = class(ContractPresentationScreenUI)

local var_0_3 = false
local var_0_4 = 8

ContractPresentationScreenUI.init = function (arg_1_0, arg_1_1)
	arg_1_0.ui_renderer = arg_1_1.ui_renderer
	arg_1_0.ingame_ui = arg_1_1.ingame_ui
	arg_1_0.input_manager = arg_1_1.input_manager
	arg_1_0.peer_id = arg_1_1.peer_id
	arg_1_0.player_manager = arg_1_1.player_manager
	arg_1_0.game_won = arg_1_1.game_won
	arg_1_0.ui_animations = {}
	arg_1_0.world_manager = arg_1_1.world_manager

	local var_1_0 = arg_1_0.world_manager:world("level_world")

	arg_1_0.wwise_world = Managers.world:wwise_world(var_1_0)
	arg_1_0.quest_manager = Managers.state.quest

	local var_1_1 = arg_1_0.input_manager

	var_1_1:create_input_service("contract_presentation_screen_ui", "IngameMenuKeymaps", "IngameMenuFilters")
	var_1_1:map_device_to_service("contract_presentation_screen_ui", "keyboard")
	var_1_1:map_device_to_service("contract_presentation_screen_ui", "mouse")
	var_1_1:map_device_to_service("contract_presentation_screen_ui", "gamepad")
	arg_1_0:_create_ui_elements()
end

ContractPresentationScreenUI.on_enter = function (arg_2_0, arg_2_1)
	if GameSettingsDevelopment.backend_settings.quests_enabled then
		local var_2_0 = Managers.chat:chat_is_focused()
		local var_2_1 = arg_2_0.input_manager

		if not arg_2_1 and not var_2_0 then
			var_2_1:block_device_except_service("contract_presentation_screen_ui", "keyboard")
			var_2_1:block_device_except_service("contract_presentation_screen_ui", "mouse")
			var_2_1:block_device_except_service("contract_presentation_screen_ui", "gamepad")
		end

		local var_2_2 = arg_2_0:_initialize_active_contracts()

		if not arg_2_0.game_won or var_2_2 or arg_2_0.num_active_contract_widget == 0 then
			arg_2_0.is_complete = true
		else
			arg_2_0.started = true
			arg_2_0.is_complete = nil
		end

		arg_2_0.waiting_for_input = nil
		arg_2_0.exit_anim_id = nil
	else
		arg_2_0.is_complete = true
	end
end

ContractPresentationScreenUI.input_service = function (arg_3_0)
	return arg_3_0.input_manager:get_service("contract_presentation_screen_ui")
end

ContractPresentationScreenUI.destroy = function (arg_4_0)
	arg_4_0.ui_animator = nil
end

ContractPresentationScreenUI.update = function (arg_5_0, arg_5_1, arg_5_2)
	if var_0_3 then
		arg_5_0:_create_ui_elements()

		var_0_3 = false
	end

	if arg_5_0.is_complete or not arg_5_0.started then
		return
	end

	local var_5_0 = arg_5_0.ui_animator

	var_5_0:update(arg_5_1)

	local var_5_1 = arg_5_0:_update_continue_timer(arg_5_1)

	if not arg_5_0.waiting_for_input then
		if arg_5_0:_handle_animations() then
			arg_5_0.waiting_for_input = true
			arg_5_0.continue_timer = var_0_4
		end
	elseif not arg_5_0.exit_anim_id and (arg_5_0.input_manager:any_input_pressed() or var_5_1) then
		arg_5_0.exit_anim_id = arg_5_0:_start_contract_animation(nil, "contracts_exit")
	end

	if arg_5_0.exit_anim_id and var_5_0:is_animation_completed(arg_5_0.exit_anim_id) then
		var_5_0:stop_animation(arg_5_0.exit_anim_id)

		arg_5_0.is_complete = true
	end

	arg_5_0:_draw(arg_5_1)
end

ContractPresentationScreenUI._update_continue_timer = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.continue_timer

	if var_6_0 then
		local var_6_1 = var_6_0 - arg_6_1

		if var_6_1 <= 0 then
			arg_6_0.continue_timer = nil

			return true
		else
			arg_6_0.continue_timer = var_6_1
		end
	end
end

ContractPresentationScreenUI._draw = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.ui_renderer
	local var_7_1 = arg_7_0.ui_scenegraph
	local var_7_2 = arg_7_0.input_manager
	local var_7_3 = var_7_2:get_service("contract_presentation_screen_ui")
	local var_7_4 = var_7_2:is_device_active("gamepad")

	UIRenderer.begin_pass(var_7_0, var_7_1, var_7_3, arg_7_1)
	UIRenderer.draw_widget(var_7_0, arg_7_0.title_text)

	for iter_7_0, iter_7_1 in ipairs(arg_7_0._widgets) do
		UIRenderer.draw_widget(var_7_0, iter_7_1)
	end

	if arg_7_0.waiting_for_input and not arg_7_0.exit_anim_id then
		local var_7_5 = arg_7_0._input_widgets

		arg_7_0.input_description_text.content.text = var_7_4 and "press_any_button_to_continue" or "press_any_key_to_continue"

		UIRenderer.draw_widget(var_7_0, arg_7_0.input_description_text)
	end

	UIRenderer.end_pass(var_7_0)
end

ContractPresentationScreenUI._create_ui_elements = function (arg_8_0)
	arg_8_0.num_active_contract_widget = 0
	arg_8_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)
	arg_8_0.input_description_text = UIWidget.init(var_0_0.widget_definitions.input_description_text)
	arg_8_0.title_text = UIWidget.init(var_0_0.widget_definitions.title_text)

	local var_8_0 = {}

	for iter_8_0, iter_8_1 in ipairs(var_0_0.entry_widget_definitions) do
		var_8_0[iter_8_0] = UIWidget.init(iter_8_1)
	end

	arg_8_0._widgets = var_8_0

	UIRenderer.clear_scenegraph_queue(arg_8_0.ui_renderer)

	arg_8_0.ui_animator = UIAnimator:new(arg_8_0.ui_scenegraph, var_0_1)
end

ContractPresentationScreenUI._initialize_active_contracts = function (arg_9_0)
	local var_9_0 = arg_9_0.quest_manager:get_contracts()
	local var_9_1 = {}

	for iter_9_0, iter_9_1 in pairs(var_9_0) do
		if arg_9_0.quest_manager:get_session_progress_by_contract_id(iter_9_0) and iter_9_1.active and not iter_9_1.turned_in then
			var_9_1[#var_9_1 + 1] = iter_9_0
		end
	end

	local var_9_2 = {}
	local var_9_3 = {}
	local var_9_4 = 0

	if #var_9_1 > 0 then
		local var_9_5 = arg_9_0._widgets

		for iter_9_2, iter_9_3 in ipairs(var_9_1) do
			var_9_4 = var_9_4 + 1

			local var_9_6 = var_9_5[var_9_4]

			if var_9_6 then
				local var_9_7, var_9_8, var_9_9 = arg_9_0:_set_contract_start_info_by_contract_id(var_9_6, iter_9_3)

				var_9_2[iter_9_3] = {
					contract_start_progress = var_9_8,
					contract_session_progress = var_9_9,
					widget_index = var_9_4,
					contract_id = iter_9_3,
					task_data = var_9_7,
					widget = var_9_6
				}
				var_9_3[var_9_4] = var_9_2[iter_9_3]
			end
		end
	else
		return true
	end

	arg_9_0.num_active_contract_widget = var_9_4
	arg_9_0.contract_entries_by_index = var_9_3
	arg_9_0.contract_entries = var_9_2
end

ContractPresentationScreenUI._set_contract_start_info_by_contract_id = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0.quest_manager
	local var_10_1 = var_10_0:get_contract_by_id(arg_10_2).requirements.task
	local var_10_2 = var_10_0:get_title_for_contract_id(arg_10_2)

	arg_10_1.content.title_text = var_10_2

	local var_10_3 = var_10_0:get_contract_progress(arg_10_2)
	local var_10_4 = var_10_0:get_session_progress_by_contract_id(arg_10_2)
	local var_10_5 = 0
	local var_10_6 = {}
	local var_10_7 = 0
	local var_10_8 = 0
	local var_10_9 = 0

	if var_10_1 then
		local var_10_10 = var_10_3 or 0
		local var_10_11 = var_10_4 or 0
		local var_10_12 = math.max(var_10_10 - var_10_11, 0)
		local var_10_13 = var_10_1.amount.required
		local var_10_14 = tostring(var_10_12) .. "/" .. tostring(var_10_13)

		var_10_5 = var_10_5 + 1

		arg_10_0:_set_widget_task_info(arg_10_1, var_10_5, var_10_1.type, var_10_14)

		var_10_6[var_10_5] = {
			end_value = var_10_13,
			value = var_10_12,
			session_value = var_10_11,
			has_changed = var_10_11 > 0
		}
		var_10_8 = var_10_8 + var_10_12
		var_10_9 = var_10_9 + var_10_11
		var_10_7 = var_10_7 + var_10_13
	end

	local var_10_15 = var_10_7 > 0 and var_10_8 / var_10_7 or 0
	local var_10_16 = math.max(math.min(var_10_15, 1), 0)
	local var_10_17 = var_10_7 > 0 and var_10_9 / var_10_7 or 0
	local var_10_18 = math.max(math.min(var_10_17, 1), 0)

	arg_10_0:_set_widget_task_amount(arg_10_1, var_10_5)
	arg_10_0:_set_widget_contract_progress(arg_10_1, var_10_16)

	return var_10_6, var_10_16, var_10_18
end

ContractPresentationScreenUI._set_widget_task_amount = function (arg_11_0, arg_11_1, arg_11_2)
	arg_11_1.content.task_amount = arg_11_2

	local var_11_0 = arg_11_1.style

	var_11_0.texture_divider.texture_amount = arg_11_2 - 1

	local var_11_1 = arg_11_1.style.task_bg_size
	local var_11_2 = arg_11_1.style.task_start_offset
	local var_11_3 = var_11_1[1] / arg_11_2

	for iter_11_0 = 1, arg_11_2 do
		local var_11_4 = var_11_0["task_text_" .. iter_11_0]
		local var_11_5 = var_11_0["task_value_" .. iter_11_0]
		local var_11_6 = var_11_0["texture_task_marker_" .. iter_11_0]
		local var_11_7 = var_11_0["texture_task_glow_" .. iter_11_0]
		local var_11_8 = var_11_0["texture_task_icon_" .. iter_11_0]

		var_11_4.size[1] = var_11_3
		var_11_5.size[1] = var_11_3

		local var_11_9 = var_11_2 + var_11_3 * (iter_11_0 - 1)

		var_11_4.offset[1] = var_11_9
		var_11_5.offset[1] = var_11_9

		local var_11_10 = var_11_6.size

		var_11_6.offset[1] = 20 + (var_11_2 + var_11_3 * (iter_11_0 - 1)) + (var_11_3 * 0.5 - var_11_10[1] * 0.5)

		local var_11_11 = var_11_7.size

		var_11_7.offset[1] = var_11_2 + var_11_3 * (iter_11_0 - 1) + (var_11_3 * 0.5 - var_11_11[1] * 0.5)

		local var_11_12 = var_11_8.size

		var_11_8.offset[1] = var_11_2 + var_11_3 * (iter_11_0 - 1) + (var_11_3 * 0.5 - var_11_12[1] * 0.5)
	end
end

ContractPresentationScreenUI._sync_contracts_task_progress = function (arg_12_0)
	local var_12_0 = arg_12_0._widgets
	local var_12_1 = arg_12_0.contract_entries

	if var_12_1 then
		for iter_12_0, iter_12_1 in pairs(var_12_1) do
			arg_12_0:_sync_contract_task_progress(iter_12_0)
		end
	end
end

ContractPresentationScreenUI._sync_contract_task_progress = function (arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0.contract_entries[arg_13_1]
	local var_13_1 = var_13_0.widget
	local var_13_2 = var_13_0.task_data
	local var_13_3 = quest_manager:get_session_progress_by_contract_id(arg_13_1)
	local var_13_4 = 0
	local var_13_5 = var_13_4 + 1
	local var_13_6 = var_13_2[var_13_5]
	local var_13_7 = tostring(task_value) .. "/" .. tostring(var_13_6.end_value)

	arg_13_0:_set_widget_task_info(var_13_1, var_13_5, nil, var_13_7)
end

ContractPresentationScreenUI._set_widget_contract_progress = function (arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_1.content
	local var_14_1 = arg_14_1.style.progress_bar
	local var_14_2 = var_14_0.progress_bar

	var_14_1.size[1] = var_14_1.uv_scale_pixels * arg_14_2
	var_14_2.uvs[2][var_14_1.scale_axis] = arg_14_2
	arg_14_2 = math.floor(arg_14_2 * 100, 1)

	local var_14_3 = tostring(arg_14_2) .. "%"

	var_14_0.bar_text = Localize("dlc1_3_1_contract_presentation_progress_prefix") .. ": " .. var_14_3
end

ContractPresentationScreenUI._set_widget_task_info = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	local var_15_0 = arg_15_1.content
	local var_15_1 = arg_15_1.style

	if arg_15_3 then
		local var_15_2 = QuestSettings.task_type_to_icon_lookup[arg_15_3]

		if var_15_2 then
			var_15_0["texture_task_icon_" .. arg_15_2] = var_15_2
		else
			var_15_0["task_text_" .. arg_15_2] = arg_15_3
		end
	end

	if arg_15_4 then
		var_15_0["task_value_" .. arg_15_2] = arg_15_4
	end
end

ContractPresentationScreenUI._get_text_size = function (arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0.ui_renderer
	local var_16_1 = arg_16_1.size
	local var_16_2, var_16_3 = UIFontByResolution(arg_16_1, nil)
	local var_16_4 = var_16_2[1]
	local var_16_5 = var_16_2[2]
	local var_16_6 = var_16_2[3]
	local var_16_7 = var_16_3
	local var_16_8, var_16_9, var_16_10 = UIGetFontHeight(var_16_0.gui, var_16_6, var_16_7)
	local var_16_11 = UIRenderer.word_wrap(var_16_0, arg_16_2, var_16_4, var_16_7, var_16_1[1])
	local var_16_12 = #var_16_11
	local var_16_13 = RESOLUTION_LOOKUP.inv_scale
	local var_16_14 = (var_16_10 + math.abs(var_16_9)) * var_16_13
	local var_16_15 = 0

	for iter_16_0 = 1, var_16_12 do
		local var_16_16 = var_16_11[iter_16_0]
		local var_16_17, var_16_18, var_16_19 = UIRenderer.text_size(var_16_0, var_16_16, var_16_4, var_16_7, var_16_14)

		if var_16_15 < var_16_17 then
			var_16_15 = var_16_17
		end
	end

	return var_16_12 * var_16_14, var_16_15
end

ContractPresentationScreenUI._handle_animations = function (arg_17_0)
	local var_17_0 = arg_17_0.num_active_contract_widget
	local var_17_1 = arg_17_0.ui_animator

	if var_17_0 > 0 then
		local var_17_2 = arg_17_0.contract_entries_by_index
		local var_17_3 = true

		for iter_17_0, iter_17_1 in pairs(var_17_2) do
			local var_17_4 = iter_17_1.contract_id

			if not iter_17_1.animations_done then
				var_17_3 = true

				if not iter_17_1.intro_started then
					local var_17_5 = arg_17_0:_start_contract_animation(var_17_4, "contract_entry")

					iter_17_1.widget.content.visible = true
					iter_17_1.intro_started = true
					iter_17_1.intro_anim_id = var_17_5

					return
				elseif iter_17_1.intro_anim_id and var_17_1:is_animation_completed(iter_17_1.intro_anim_id) then
					var_17_1:stop_animation(iter_17_1.intro_anim_id)

					iter_17_1.intro_anim_id = nil

					return
				end

				if iter_17_1.intro_started and not iter_17_1.intro_anim_id then
					if not iter_17_1.task_anims_done then
						if not iter_17_1.animating_task_index then
							local var_17_6 = iter_17_1.task_data

							if #var_17_6 > 0 then
								for iter_17_2 = 1, #var_17_6 do
									if var_17_6[iter_17_2].has_changed then
										local var_17_7 = iter_17_2

										iter_17_1.task_anim_id = arg_17_0:_start_contract_animation(var_17_4, "contract_task_progress", var_17_7)
										iter_17_1.animating_task_index = var_17_7

										return
									end
								end
							end

							iter_17_1.task_anims_done = true

							return
						elseif iter_17_1.task_anim_id and var_17_1:is_animation_completed(iter_17_1.task_anim_id) then
							var_17_1:stop_animation(iter_17_1.task_anim_id)

							iter_17_1.task_anim_id = nil

							local var_17_8 = iter_17_1.task_data
							local var_17_9 = iter_17_1.animating_task_index

							if var_17_9 < #var_17_8 then
								for iter_17_3 = var_17_9 + 1, #var_17_8 do
									if var_17_8[iter_17_3].has_changed then
										local var_17_10 = iter_17_3

										iter_17_1.task_anim_id = arg_17_0:_start_contract_animation(var_17_4, "contract_task_progress", var_17_10)
										iter_17_1.animating_task_index = var_17_10

										return
									end
								end
							end

							iter_17_1.task_anims_done = true

							return
						else
							return
						end
					elseif not iter_17_1.summary_anim_done then
						if not iter_17_1.summary_started then
							local var_17_11 = iter_17_1.contract_session_progress > 0 and "contract_summary" or "no_progress"

							iter_17_1.summary_anim_id = arg_17_0:_start_contract_animation(var_17_4, var_17_11)
							iter_17_1.summary_started = true

							return
						elseif iter_17_1.summary_anim_id and var_17_1:is_animation_completed(iter_17_1.summary_anim_id) then
							var_17_1:stop_animation(iter_17_1.summary_anim_id)

							iter_17_1.summary_anim_id = nil
							iter_17_1.summary_anim_done = true

							return
						else
							return
						end
					elseif not iter_17_1.end_started then
						if iter_17_0 < var_17_0 then
							iter_17_1.end_anim_id, iter_17_1.end_started = arg_17_0:_start_contract_animation(var_17_4, "contract_move"), true

							return
						else
							iter_17_1.animations_done = true
						end
					elseif iter_17_1.end_anim_id and var_17_1:is_animation_completed(iter_17_1.end_anim_id) then
						var_17_1:stop_animation(iter_17_1.end_anim_id)

						iter_17_1.end_anim_id = nil
						iter_17_1.animations_done = true
					else
						return
					end
				else
					return
				end
			end
		end

		return var_17_3
	else
		return true
	end
end

ContractPresentationScreenUI._start_contract_animation = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local var_18_0 = arg_18_1 and arg_18_0.contract_entries[arg_18_1]
	local var_18_1 = var_18_0 and var_18_0.widget_index
	local var_18_2 = var_18_0 and var_18_0.task_data
	local var_18_3 = {
		wwise_world = arg_18_0.wwise_world,
		widget_index = var_18_1,
		task_data = var_18_2,
		task_index = arg_18_3,
		num_widgets = arg_18_0.num_active_contract_widget,
		contract_session_progress = var_18_0 and var_18_0.contract_session_progress,
		contract_start_progress = var_18_0 and var_18_0.contract_start_progress
	}

	return arg_18_0.ui_animator:start_animation(arg_18_2, arg_18_0._widgets, var_0_2, var_18_3)
end
