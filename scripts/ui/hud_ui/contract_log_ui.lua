-- chunkname: @scripts/ui/hud_ui/contract_log_ui.lua

require("scripts/settings/quest_settings")

local var_0_0 = local_require("scripts/ui/hud_ui/contract_log_ui_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local num = 3
local ENTRY_LENGTH = var_0_0.ENTRY_LENGTH
local QuestSettings = QuestSettings
local tbl = {
	170,
	255,
	255,
	255
}
local get_color_table_with_alpha = Colors.get_color_table_with_alpha("sky_blue", 220)
local get_color_table_with_alpha_2 = Colors.get_color_table_with_alpha("pale_green", 220)

ContractLogUI = class(ContractLogUI)

ContractLogUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self.ui_renderer = arg_1_2.ui_renderer
	self.ingame_ui = arg_1_2.ingame_ui
	self.input_manager = arg_1_2.input_manager
	self.peer_id = arg_1_2.peer_id
	self.player_manager = arg_1_2.player_manager
	self.ui_animations = {}

	local world = arg_1_2.world_manager:world("level_world")

	self.wwise_world = Managers.world:wwise_world(world)
	self.num_added_contracts = 0

	self:_create_ui_elements()

	local _get_text_size, var_1_2 = self:_get_text_size(self.title_widget.style.title_text, self.title_widget.content.title_text)

	self.min_log_width = math.floor(var_1_2)
	self.quest_manager = Managers.state.quest

	self:_align_widgets()
end

ContractLogUI._create_ui_elements = function (self)
	-- function 2
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for i, v in ipairs(var_0_0.entry_widget_definitions) do
		tbl[i] = UIWidget.init(v)
		tbl_2[i] = tbl[i]
	end

	self._widgets = tbl
	self._unused_widgets = tbl_2
	self._used_widgets = {}
	self._log_entries = {}
	self._log_entries_by_contract_id = {}
	self.title_widget = UIWidget.init(var_0_0.widget_definitions.title_text)

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)
	self:set_visible(true)
end

ContractLogUI._align_widgets = function (self)
	-- function 3
	local num = 5
	local num_2 = 0
	local num_3 = 10

	for i, v in ipairs(self._used_widgets) do
		v.offset[2] = -math.floor(num)

		local text_width = v.content.text_width
		local total_height = v.content.total_height

		v.style.texture_fade_bg.size[2] = total_height
		num = num + total_height + num_3

		self:_set_widget_dirty(v)
	end

	self:set_dirty()
end

ContractLogUI.destroy = function (self)
	-- function 4
	self:set_visible(false)
end

ContractLogUI.set_visible = function (self, arg_5_1)
	-- function 5
	self._is_visible = arg_5_1

	local ui_renderer = self.ui_renderer

	for i, v in ipairs(self._widgets) do
		UIRenderer.set_element_visible(ui_renderer, v.element, arg_5_1)
	end

	UIRenderer.set_element_visible(ui_renderer, self.title_widget.element, arg_5_1)
	self:set_dirty()
end

ContractLogUI._sync_active_contracts = function (self)
	-- function 6
	local flag = false
	local get_active_contract_ids = self.quest_manager:get_active_contract_ids()

	if not get_active_contract_ids then
		local _log_entries_by_contract_id = self._log_entries_by_contract_id
		local num_added_contracts = self.num_added_contracts

		if not (not num_added_contracts and not (num_added_contracts > 0)) then
			local _log_entries = self._log_entries

			for i = 1, num_added_contracts do
				local var_6_5 = _log_entries[i]

				if not var_6_5 then
					local contract_id = var_6_5.contract_id
					local is_contract_able_to_progress = self.quest_manager:is_contract_able_to_progress(contract_id)

					if not (not table.contains(get_active_contract_ids, contract_id) and is_contract_able_to_progress) then
						self:_remove_contract(contract_id)

						flag = true
					end
				end
			end
		end

		for k, v in pairs(get_active_contract_ids) do
			if _log_entries_by_contract_id[v] or not self.quest_manager:is_contract_able_to_progress(v) then
				self:_add_contract(v)

				flag = true
			end
		end
	end

	return flag
end

ContractLogUI._sync_contract_progression = function (self)
	-- function 7
	local _log_entries = self._log_entries
	local flag = false
	local flag_2 = false

	for i, v in ipairs(_log_entries) do
		local contract_id = v.contract_id

		if not self.quest_manager:has_contract_session_changes(contract_id) then
			local _update_contract_goal, var_7_5 = self:_update_contract_goal(v)

			if not _update_contract_goal then
				local widget = v.widget

				self:_set_widget_dirty(widget)
			end

			if not var_7_5 then
				flag_2 = true
			end

			if _update_contract_goal or not var_7_5 then
				flag = true
			end
		end
	end

	if not flag_2 then
		self:play_sound("Play_hud_quest_menu_finish_quest_during_gameplay")
	end

	return flag
end

ContractLogUI._update_contract_goal = function (self, arg_8_1)
	-- function 8
	local contract_id = arg_8_1.contract_id
	local get_session_progress_by_contract_id = self.quest_manager:get_session_progress_by_contract_id(contract_id)
	local widget = arg_8_1.widget
	local content = widget.content
	local style = widget.style
	local title_text_width = content.title_text_width
	local var_8_6 = tbl
	local contract_goal = arg_8_1.contract_goal
	local contract_goal_start_progress = arg_8_1.contract_goal_start_progress
	local contract_goal_session_progress = arg_8_1.contract_goal_session_progress
	local str = ""
	local var_8_11

	style.task_text.text_color = var_8_6

	if not contract_goal then
		local var_8_12 = contract_goal_start_progress
		local var_8_13 = get_session_progress_by_contract_id
		local num = var_8_12 + var_8_13
		local required = contract_goal.amount.required
		local flag = required <= num
		local flag_2 = num ~= var_8_12

		if not flag then
			var_8_6 = get_color_table_with_alpha_2
		elseif not flag_2 then
			var_8_6 = get_color_table_with_alpha
		end

		local flag_3 = num ~= content.task_progress

		content.task_progress = num
		style.task_text.text_color = var_8_6

		local str_2 = Localize(QuestSettings.task_type_to_name_lookup[contract_goal.type]) .. ": " .. tostring(num) .. "/" .. tostring(required)
		local str_3 = str .. str_2
		local flag_4 = contract_goal_session_progress ~= var_8_13
		local flag_5

		flag_5 = num ~= var_8_12

		if not flag_4 then
			local var_8_23 = var_8_13
		end

		if not var_8_11 then
			str_3 = str_3 .. "..."
		end

		local _get_text_size, var_8_25 = self:_get_text_size(style.task_text, str_3)

		if var_8_25 < title_text_width then
			var_8_25 = title_text_width
		end

		content.task_text = str_3
		content.text_width = var_8_25

		if content.tasks_complete or not flag then
			content.tasks_complete = flag

			return flag_3, flag
		else
			content.tasks_complete = flag
		end

		return flag_3
	end
end

ContractLogUI._add_contract = function (self, arg_9_1)
	-- function 9
	local num_added_contracts = self.num_added_contracts

	num_added_contracts = num_added_contracts or 0

	if num_added_contracts >= num then
		return
	end

	local tbl_2 = {}
	local num_2 = num_added_contracts + 1
	local remove = table.remove(self._unused_widgets, 1)
	local content = remove.content
	local style = remove.style

	style.task_text.text_color = tbl

	UIRenderer.set_element_visible(self.ui_renderer, remove.element, true)
	self:_set_widget_dirty(remove)

	local get_contract_by_id = self.quest_manager:get_contract_by_id(arg_9_1)
	local task = get_contract_by_id.requirements.task
	local get_title_for_contract_id = self.quest_manager:get_title_for_contract_id(arg_9_1)
	local quest = get_contract_by_id.rewards.quest
	local var_9_10

	if not quest then
		var_9_10 = QuestSettings.contract_ui_dlc_colors[quest.quest_type]

		if not var_9_10 then
			-- Nothing
		end
	end

	var_9_10 = Colors.get_table("white")

	::label_9_0::

	local color = style.texture_icon_bg.color

	color[2] = var_9_10[2]
	color[3] = var_9_10[3]
	color[4] = var_9_10[4]

	local get_contract_progress = self.quest_manager:get_contract_progress(arg_9_1)
	local var_9_13
	local str = ""

	if not task then
		var_9_13 = 0

		local var_9_15 = get_contract_progress
		local required = task.amount.required
		local acquired = task.amount.acquired

		if var_9_15 < required then
			local str_2 = Localize(QuestSettings.task_type_to_name_lookup[task.type]) .. ":  " .. tostring(var_9_15) .. "/" .. tostring(required)

			str = str .. str_2 .. "\n"
		end
	end

	local _get_text_size, var_9_20 = self:_get_text_size(style.title_text, get_title_for_contract_id)
	local _get_text_size_2, var_9_22 = self:_get_text_size(style.task_text, str)

	if var_9_22 < var_9_20 then
		var_9_22 = var_9_20
	end

	content.title_text = get_title_for_contract_id
	content.task_text = str
	content.total_height = style.texture_icon.size[2] + _get_text_size_2
	content.text_width = var_9_22
	content.title_text_width = var_9_20
	content.tasks_complete = false
	content.task_progress = 0
	tbl_2.widget = remove
	tbl_2.contract_goal = task
	tbl_2.contract_goal_start_progress = get_contract_progress
	tbl_2.contract_goal_session_progress = var_9_13
	tbl_2.contract_id = arg_9_1

	local _used_widgets = self._used_widgets

	table.insert(_used_widgets, #_used_widgets + 1, remove)

	local _log_entries = self._log_entries

	table.insert(_log_entries, #_log_entries + 1, tbl_2)

	self._log_entries_by_contract_id[arg_9_1] = tbl_2
	self.num_added_contracts = num_2
end

ContractLogUI._remove_contract = function (self, arg_10_1)
	-- function 10
	local num_added_contracts = self.num_added_contracts

	num_added_contracts = num_added_contracts or 0

	if num_added_contracts <= 0 then
		return
	end

	local var_10_1
	local var_10_2
	local _log_entries = self._log_entries

	for i = 1, #_log_entries do
		local var_10_4 = _log_entries[i]

		if var_10_4.contract_id == arg_10_1 then
			var_10_1 = var_10_4
			var_10_2 = i

			break
		end
	end

	if not var_10_1 then
		return
	end

	local remove = table.remove(self._used_widgets, var_10_2)

	UIRenderer.set_element_visible(self.ui_renderer, remove.element, false)
	self:_set_widget_dirty(remove)
	table.remove(_log_entries, var_10_2)

	local _unused_widgets = self._unused_widgets

	table.insert(_unused_widgets, #_unused_widgets + 1, remove)

	self.num_added_contracts = num_added_contracts - 1
	self._log_entries_by_contract_id[arg_10_1] = nil

	self:_align_widgets()
end

ContractLogUI._get_text_size = function (self, arg_11_1, arg_11_2)
	-- function 11
	local ui_renderer = self.ui_renderer
	local size = arg_11_1.size
	local get_text_height = UIUtils.get_text_height(ui_renderer, size, arg_11_1, arg_11_2)
	local num = 0

	for i = 1, num_texts do
		local var_11_4 = texts[i]
		local get_text_width = UIUtils.get_text_width(ui_renderer, arg_11_1, var_11_4)

		if num < get_text_width then
			num = get_text_width
		end
	end

	return get_text_height, num
end

ContractLogUI.update = function (self, arg_12_1, arg_12_2)
	-- function 12
	local flag = false
	local flag_2 = false

	if not self:_sync_active_contracts() then
		flag_2 = true
		flag = true
	end

	if not self:_sync_contract_progression() then
		flag_2 = true
		flag = true
	end

	if not (not self._is_visible and not self.num_added_contracts and self.num_added_contracts <= 0 or self.num_added_contracts) then
		self:set_visible(false)
	elseif not ((self._is_visible or not self.num_added_contracts) and not (self.num_added_contracts > 0)) then
		self:set_visible(true)
	end

	if not self:_handle_resolution_modified() then
		flag_2 = true
	end

	if not flag_2 then
		self:_align_widgets()
	end

	if not flag then
		self:set_dirty()
	end

	self:draw(arg_12_1)
end

ContractLogUI._handle_resolution_modified = function (self)
	-- function 13
	if not RESOLUTION_LOOKUP.modified then
		self:_on_resolution_modified()

		return true
	end
end

ContractLogUI._on_resolution_modified = function (self)
	-- function 14
	for i, v in ipairs(self._log_entries) do
		self:_update_contract_goal(v)

		local widget = v.widget

		self:_set_widget_dirty(widget)
	end

	local _get_text_size, var_14_2 = self:_get_text_size(self.title_widget.style.title_text, self.title_widget.content.title_text)

	self.min_log_width = math.floor(var_14_2)

	self:_set_widget_dirty(self.title_widget)
	self:set_dirty()
end

ContractLogUI.draw = function (self, arg_15_1)
	-- function 15
	if not self._is_visible then
		return
	end

	if not self._dirty then
		return
	end

	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("ingame_menu")

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_15_1)

	for i, v in ipairs(self._used_widgets) do
		UIRenderer.draw_widget(ui_renderer, v)
	end

	UIRenderer.draw_widget(ui_renderer, self.title_widget)
	UIRenderer.end_pass(ui_renderer)

	self._dirty = false
end

ContractLogUI.set_dirty = function (self)
	-- function 16
	self._dirty = true
end

ContractLogUI._set_widget_dirty = function (arg_17_0, arg_17_1)
	-- function 17
	arg_17_1.element.dirty = true
end

ContractLogUI.play_sound = function (self, arg_18_1)
	-- function 18
	WwiseWorld.trigger_event(self.wwise_world, arg_18_1)
end
