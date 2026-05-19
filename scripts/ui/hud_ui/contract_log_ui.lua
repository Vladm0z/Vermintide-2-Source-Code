-- chunkname: @scripts/ui/hud_ui/contract_log_ui.lua

require("scripts/settings/quest_settings")

local var_0_0 = local_require("scripts/ui/hud_ui/contract_log_ui_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = 3
local var_0_3 = var_0_0.ENTRY_LENGTH
local var_0_4 = QuestSettings
local var_0_5 = {
	170,
	255,
	255,
	255
}
local var_0_6 = Colors.get_color_table_with_alpha("sky_blue", 220)
local var_0_7 = Colors.get_color_table_with_alpha("pale_green", 220)

ContractLogUI = class(ContractLogUI)

function ContractLogUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0.ui_renderer = arg_1_2.ui_renderer
	arg_1_0.ingame_ui = arg_1_2.ingame_ui
	arg_1_0.input_manager = arg_1_2.input_manager
	arg_1_0.peer_id = arg_1_2.peer_id
	arg_1_0.player_manager = arg_1_2.player_manager
	arg_1_0.ui_animations = {}

	local var_1_0 = arg_1_2.world_manager:world("level_world")

	arg_1_0.wwise_world = Managers.world:wwise_world(var_1_0)
	arg_1_0.num_added_contracts = 0

	arg_1_0:_create_ui_elements()

	local var_1_1, var_1_2 = arg_1_0:_get_text_size(arg_1_0.title_widget.style.title_text, arg_1_0.title_widget.content.title_text)

	arg_1_0.min_log_width = math.floor(var_1_2)
	arg_1_0.quest_manager = Managers.state.quest

	arg_1_0:_align_widgets()
end

function ContractLogUI._create_ui_elements(arg_2_0)
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)

	local var_2_0 = {}
	local var_2_1 = {}

	for iter_2_0, iter_2_1 in ipairs(var_0_0.entry_widget_definitions) do
		var_2_0[iter_2_0] = UIWidget.init(iter_2_1)
		var_2_1[iter_2_0] = var_2_0[iter_2_0]
	end

	arg_2_0._widgets = var_2_0
	arg_2_0._unused_widgets = var_2_1
	arg_2_0._used_widgets = {}
	arg_2_0._log_entries = {}
	arg_2_0._log_entries_by_contract_id = {}
	arg_2_0.title_widget = UIWidget.init(var_0_0.widget_definitions.title_text)

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)
	arg_2_0:set_visible(true)
end

function ContractLogUI._align_widgets(arg_3_0)
	local var_3_0 = 5
	local var_3_1 = 0
	local var_3_2 = 10

	for iter_3_0, iter_3_1 in ipairs(arg_3_0._used_widgets) do
		iter_3_1.offset[2] = -math.floor(var_3_0)

		local var_3_3 = iter_3_1.content.text_width
		local var_3_4 = iter_3_1.content.total_height

		iter_3_1.style.texture_fade_bg.size[2] = var_3_4
		var_3_0 = var_3_0 + var_3_4 + var_3_2

		arg_3_0:_set_widget_dirty(iter_3_1)
	end

	arg_3_0:set_dirty()
end

function ContractLogUI.destroy(arg_4_0)
	arg_4_0:set_visible(false)
end

function ContractLogUI.set_visible(arg_5_0, arg_5_1)
	arg_5_0._is_visible = arg_5_1

	local var_5_0 = arg_5_0.ui_renderer

	for iter_5_0, iter_5_1 in ipairs(arg_5_0._widgets) do
		UIRenderer.set_element_visible(var_5_0, iter_5_1.element, arg_5_1)
	end

	UIRenderer.set_element_visible(var_5_0, arg_5_0.title_widget.element, arg_5_1)
	arg_5_0:set_dirty()
end

function ContractLogUI._sync_active_contracts(arg_6_0)
	local var_6_0 = false
	local var_6_1 = arg_6_0.quest_manager:get_active_contract_ids()

	if var_6_1 then
		local var_6_2 = arg_6_0._log_entries_by_contract_id
		local var_6_3 = arg_6_0.num_added_contracts

		if var_6_3 and var_6_3 > 0 then
			local var_6_4 = arg_6_0._log_entries

			for iter_6_0 = 1, var_6_3 do
				local var_6_5 = var_6_4[iter_6_0]

				if var_6_5 then
					local var_6_6 = var_6_5.contract_id
					local var_6_7 = arg_6_0.quest_manager:is_contract_able_to_progress(var_6_6)

					if not table.contains(var_6_1, var_6_6) or not var_6_7 then
						arg_6_0:_remove_contract(var_6_6)

						var_6_0 = true
					end
				end
			end
		end

		for iter_6_1, iter_6_2 in pairs(var_6_1) do
			if not var_6_2[iter_6_2] and arg_6_0.quest_manager:is_contract_able_to_progress(iter_6_2) then
				arg_6_0:_add_contract(iter_6_2)

				var_6_0 = true
			end
		end
	end

	return var_6_0
end

function ContractLogUI._sync_contract_progression(arg_7_0)
	local var_7_0 = arg_7_0._log_entries
	local var_7_1 = false
	local var_7_2 = false

	for iter_7_0, iter_7_1 in ipairs(var_7_0) do
		local var_7_3 = iter_7_1.contract_id

		if arg_7_0.quest_manager:has_contract_session_changes(var_7_3) then
			local var_7_4, var_7_5 = arg_7_0:_update_contract_goal(iter_7_1)

			if var_7_4 then
				local var_7_6 = iter_7_1.widget

				arg_7_0:_set_widget_dirty(var_7_6)
			end

			if var_7_5 then
				var_7_2 = true
			end

			if var_7_4 or var_7_5 then
				var_7_1 = true
			end
		end
	end

	if var_7_2 then
		arg_7_0:play_sound("Play_hud_quest_menu_finish_quest_during_gameplay")
	end

	return var_7_1
end

function ContractLogUI._update_contract_goal(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_1.contract_id
	local var_8_1 = arg_8_0.quest_manager:get_session_progress_by_contract_id(var_8_0)
	local var_8_2 = arg_8_1.widget
	local var_8_3 = var_8_2.content
	local var_8_4 = var_8_2.style
	local var_8_5 = var_8_3.title_text_width
	local var_8_6 = var_0_5
	local var_8_7 = arg_8_1.contract_goal
	local var_8_8 = arg_8_1.contract_goal_start_progress
	local var_8_9 = arg_8_1.contract_goal_session_progress
	local var_8_10 = ""
	local var_8_11

	var_8_4.task_text.text_color = var_8_6

	if var_8_7 then
		local var_8_12 = var_8_8
		local var_8_13 = var_8_1
		local var_8_14 = var_8_12 + var_8_13
		local var_8_15 = var_8_7.amount.required
		local var_8_16 = var_8_15 <= var_8_14
		local var_8_17 = var_8_14 ~= var_8_12

		if var_8_16 then
			var_8_6 = var_0_7
		elseif var_8_17 then
			var_8_6 = var_0_6
		end

		local var_8_18 = var_8_14 ~= var_8_3.task_progress

		var_8_3.task_progress = var_8_14
		var_8_4.task_text.text_color = var_8_6

		local var_8_19 = Localize(var_0_4.task_type_to_name_lookup[var_8_7.type]) .. ": " .. tostring(var_8_14) .. "/" .. tostring(var_8_15)
		local var_8_20 = var_8_10 .. var_8_19
		local var_8_21 = var_8_9 ~= var_8_13
		local var_8_22

		var_8_22 = var_8_14 ~= var_8_12

		if var_8_21 then
			local var_8_23 = var_8_13
		end

		if var_8_11 then
			var_8_20 = var_8_20 .. "..."
		end

		local var_8_24, var_8_25 = arg_8_0:_get_text_size(var_8_4.task_text, var_8_20)

		if var_8_25 < var_8_5 then
			var_8_25 = var_8_5
		end

		var_8_3.task_text = var_8_20
		var_8_3.text_width = var_8_25

		if not var_8_3.tasks_complete and var_8_16 then
			var_8_3.tasks_complete = var_8_16

			return var_8_18, var_8_16
		else
			var_8_3.tasks_complete = var_8_16
		end

		return var_8_18
	end
end

function ContractLogUI._add_contract(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0.num_added_contracts or 0

	if var_9_0 >= var_0_2 then
		return
	end

	local var_9_1 = {}
	local var_9_2 = var_9_0 + 1
	local var_9_3 = table.remove(arg_9_0._unused_widgets, 1)
	local var_9_4 = var_9_3.content
	local var_9_5 = var_9_3.style

	var_9_5.task_text.text_color = var_0_5

	UIRenderer.set_element_visible(arg_9_0.ui_renderer, var_9_3.element, true)
	arg_9_0:_set_widget_dirty(var_9_3)

	local var_9_6 = arg_9_0.quest_manager:get_contract_by_id(arg_9_1)
	local var_9_7 = var_9_6.requirements.task
	local var_9_8 = arg_9_0.quest_manager:get_title_for_contract_id(arg_9_1)
	local var_9_9 = var_9_6.rewards.quest
	local var_9_10 = var_9_9 and var_0_4.contract_ui_dlc_colors[var_9_9.quest_type] or Colors.get_table("white")
	local var_9_11 = var_9_5.texture_icon_bg.color

	var_9_11[2] = var_9_10[2]
	var_9_11[3] = var_9_10[3]
	var_9_11[4] = var_9_10[4]

	local var_9_12 = arg_9_0.quest_manager:get_contract_progress(arg_9_1)
	local var_9_13
	local var_9_14 = ""

	if var_9_7 then
		var_9_13 = 0

		local var_9_15 = var_9_12
		local var_9_16 = var_9_7.amount.required
		local var_9_17 = var_9_7.amount.acquired

		if var_9_15 < var_9_16 then
			local var_9_18 = Localize(var_0_4.task_type_to_name_lookup[var_9_7.type]) .. ":  " .. tostring(var_9_15) .. "/" .. tostring(var_9_16)

			var_9_14 = var_9_14 .. var_9_18 .. "\n"
		end
	end

	local var_9_19, var_9_20 = arg_9_0:_get_text_size(var_9_5.title_text, var_9_8)
	local var_9_21, var_9_22 = arg_9_0:_get_text_size(var_9_5.task_text, var_9_14)

	if var_9_22 < var_9_20 then
		var_9_22 = var_9_20
	end

	var_9_4.title_text = var_9_8
	var_9_4.task_text = var_9_14
	var_9_4.total_height = var_9_5.texture_icon.size[2] + var_9_21
	var_9_4.text_width = var_9_22
	var_9_4.title_text_width = var_9_20
	var_9_4.tasks_complete = false
	var_9_4.task_progress = 0
	var_9_1.widget = var_9_3
	var_9_1.contract_goal = var_9_7
	var_9_1.contract_goal_start_progress = var_9_12
	var_9_1.contract_goal_session_progress = var_9_13
	var_9_1.contract_id = arg_9_1

	local var_9_23 = arg_9_0._used_widgets

	table.insert(var_9_23, #var_9_23 + 1, var_9_3)

	local var_9_24 = arg_9_0._log_entries

	table.insert(var_9_24, #var_9_24 + 1, var_9_1)

	arg_9_0._log_entries_by_contract_id[arg_9_1] = var_9_1
	arg_9_0.num_added_contracts = var_9_2
end

function ContractLogUI._remove_contract(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.num_added_contracts or 0

	if var_10_0 <= 0 then
		return
	end

	local var_10_1
	local var_10_2
	local var_10_3 = arg_10_0._log_entries

	for iter_10_0 = 1, #var_10_3 do
		local var_10_4 = var_10_3[iter_10_0]

		if var_10_4.contract_id == arg_10_1 then
			var_10_1 = var_10_4
			var_10_2 = iter_10_0

			break
		end
	end

	if not var_10_1 then
		return
	end

	local var_10_5 = table.remove(arg_10_0._used_widgets, var_10_2)

	UIRenderer.set_element_visible(arg_10_0.ui_renderer, var_10_5.element, false)
	arg_10_0:_set_widget_dirty(var_10_5)
	table.remove(var_10_3, var_10_2)

	local var_10_6 = arg_10_0._unused_widgets

	table.insert(var_10_6, #var_10_6 + 1, var_10_5)

	arg_10_0.num_added_contracts = var_10_0 - 1
	arg_10_0._log_entries_by_contract_id[arg_10_1] = nil

	arg_10_0:_align_widgets()
end

function ContractLogUI._get_text_size(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0.ui_renderer
	local var_11_1 = arg_11_1.size
	local var_11_2 = UIUtils.get_text_height(var_11_0, var_11_1, arg_11_1, arg_11_2)
	local var_11_3 = 0

	for iter_11_0 = 1, num_texts do
		local var_11_4 = texts[iter_11_0]
		local var_11_5 = UIUtils.get_text_width(var_11_0, arg_11_1, var_11_4)

		if var_11_3 < var_11_5 then
			var_11_3 = var_11_5
		end
	end

	return var_11_2, var_11_3
end

function ContractLogUI.update(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = false
	local var_12_1 = false

	if arg_12_0:_sync_active_contracts() then
		var_12_1 = true
		var_12_0 = true
	end

	if arg_12_0:_sync_contract_progression() then
		var_12_1 = true
		var_12_0 = true
	end

	if arg_12_0._is_visible and (arg_12_0.num_added_contracts and arg_12_0.num_added_contracts <= 0 or not arg_12_0.num_added_contracts) then
		arg_12_0:set_visible(false)
	elseif not arg_12_0._is_visible and arg_12_0.num_added_contracts and arg_12_0.num_added_contracts > 0 then
		arg_12_0:set_visible(true)
	end

	if arg_12_0:_handle_resolution_modified() then
		var_12_1 = true
	end

	if var_12_1 then
		arg_12_0:_align_widgets()
	end

	if var_12_0 then
		arg_12_0:set_dirty()
	end

	arg_12_0:draw(arg_12_1)
end

function ContractLogUI._handle_resolution_modified(arg_13_0)
	if RESOLUTION_LOOKUP.modified then
		arg_13_0:_on_resolution_modified()

		return true
	end
end

function ContractLogUI._on_resolution_modified(arg_14_0)
	for iter_14_0, iter_14_1 in ipairs(arg_14_0._log_entries) do
		arg_14_0:_update_contract_goal(iter_14_1)

		local var_14_0 = iter_14_1.widget

		arg_14_0:_set_widget_dirty(var_14_0)
	end

	local var_14_1, var_14_2 = arg_14_0:_get_text_size(arg_14_0.title_widget.style.title_text, arg_14_0.title_widget.content.title_text)

	arg_14_0.min_log_width = math.floor(var_14_2)

	arg_14_0:_set_widget_dirty(arg_14_0.title_widget)
	arg_14_0:set_dirty()
end

function ContractLogUI.draw(arg_15_0, arg_15_1)
	if not arg_15_0._is_visible then
		return
	end

	if not arg_15_0._dirty then
		return
	end

	local var_15_0 = arg_15_0.ui_renderer
	local var_15_1 = arg_15_0.ui_scenegraph
	local var_15_2 = arg_15_0.input_manager:get_service("ingame_menu")

	UIRenderer.begin_pass(var_15_0, var_15_1, var_15_2, arg_15_1)

	for iter_15_0, iter_15_1 in ipairs(arg_15_0._used_widgets) do
		UIRenderer.draw_widget(var_15_0, iter_15_1)
	end

	UIRenderer.draw_widget(var_15_0, arg_15_0.title_widget)
	UIRenderer.end_pass(var_15_0)

	arg_15_0._dirty = false
end

function ContractLogUI.set_dirty(arg_16_0)
	arg_16_0._dirty = true
end

function ContractLogUI._set_widget_dirty(arg_17_0, arg_17_1)
	arg_17_1.element.dirty = true
end

function ContractLogUI.play_sound(arg_18_0, arg_18_1)
	WwiseWorld.trigger_event(arg_18_0.wwise_world, arg_18_1)
end
