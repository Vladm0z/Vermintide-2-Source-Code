-- chunkname: @scripts/ui/hud_ui/weave_progress_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/weave_progress_ui_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition

WeaveProgressUI = class(WeaveProgressUI)

WeaveProgressUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self._ui_renderer = arg_1_2.ui_renderer
	self._ingame_ui_context = arg_1_2
	self._render_settings = {}
	self._progress = 0
	self._animations = {}
	self._animation_callbacks = {}

	self:_create_ui_elements()
end

WeaveProgressUI.destroy = function (arg_2_0)
	-- function 2
	return
end

WeaveProgressUI._create_ui_elements = function (self)
	-- function 3
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local _render_settings = self._render_settings

	_render_settings = _render_settings or {}
	self._render_settings = _render_settings
	self._bonus_objective_widgets = {}
	self._bonus_objective_stack_widgets = {}
	self._bonus_objective_lookup = {}
	self._widgets = {}

	for k, v in pairs(widgets) do
		self._widgets[k] = UIWidget.init(v)
	end

	self._bonus_header_widget = UIWidget.init(var_0_0.create_bonus_objective_header_func())

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._progress = 0
end

WeaveProgressUI._sync_weave_objectives = function (self)
	-- function 4
	local get_active_objective_template = Managers.weave:get_active_objective_template()

	if not get_active_objective_template then
		return
	end

	local bar_cutoff = get_active_objective_template.bar_cutoff

	if not (not bar_cutoff and bar_cutoff ~= 100) then
		local max = math.max(Managers.weave:get_active_objective() - 1, 1)
		local objectives = Managers.weave:get_active_weave_template().objectives

		for i = max, 1, -1 do
			bar_cutoff = objectives[i].bar_cutoff

			if not (not bar_cutoff and not (bar_cutoff < 100)) then
				break
			end
		end
	end

	bar_cutoff = bar_cutoff or 100

	local progress_ui = self._widgets.progress_ui
	local content = progress_ui.content

	content.bar_cutoff = bar_cutoff

	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name("weaves_essence_bar_fill")
	local bubble_icon = progress_ui.style.bubble_icon
	local base_offset_x = bubble_icon.base_offset_x

	bubble_icon.offset[1] = base_offset_x + get_atlas_settings_by_texture_name.size[1] * (bar_cutoff * 0.01)

	local str = ""
	local bonus_time_on_complete = get_active_objective_template.bonus_time_on_complete

	if not bonus_time_on_complete then
		local max_2 = math.max(bonus_time_on_complete, 0)

		str = string.format("+ %d:%02d", math.floor(max_2 / 60), max_2 % 60)
	end

	content.bonus_time = str
	self._initiated = true
end

WeaveProgressUI.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not self._initiated then
		self:_sync_weave_objectives()
	end

	self:_update_bonus_objectives(arg_5_1, arg_5_2)
	self:_update_animations(arg_5_1, arg_5_2)
	self:_update_bar(arg_5_1, arg_5_2)
	self:_draw(arg_5_1, arg_5_2)
end

local function fn(self, arg_6_1)
	-- function 6
	return self.sort_index < arg_6_1.sort_index
end

local tbl = {}
local tbl_2 = {}
local tbl_3 = {}

WeaveProgressUI._update_bonus_objectives = function (self, arg_7_1, arg_7_2)
	-- function 7
	table.clear(tbl)
	table.clear(tbl_2)
	table.clear(tbl_3)

	local _bonus_objective_lookup = self._bonus_objective_lookup
	local _bonus_objective_widgets = self._bonus_objective_widgets
	local _bonus_objective_stack_widgets = self._bonus_objective_stack_widgets
	local get_active_weave_template = Managers.weave:get_active_weave_template()

	if not get_active_weave_template then
		return
	end

	local state = Managers.state

	state = not state and Managers.state.entity

	local flag = not state and state:system("objective_system")
	local get_active_objective = Managers.weave:get_active_objective()
	local var_7_7 = get_active_weave_template.objectives_ordered[get_active_objective]

	if not flag then
		local active_objectives = flag:active_objectives()

		for i, v in ipairs(active_objectives) do
			local extension_by_objective_name = flag:extension_by_objective_name(v)

			tbl[v] = true

			if _bonus_objective_lookup[v] or not extension_by_objective_name:display_name() then
				local find = table.find(var_7_7, v)

				tbl_2[#tbl_2 + 1] = {
					sort_index = find,
					objective = extension_by_objective_name
				}
			end
		end

		table.sort(tbl_2, fn)

		for i_2, v_2 in ipairs(tbl_2) do
			local objective_name = v_2.objective:objective_name()
			local display_name = v_2.objective:display_name()
			local is_stacking_objective = v_2.objective:is_stacking_objective()

			if not is_stacking_objective then
				if not tbl_3[is_stacking_objective] then
					local create_bonus_objective_func = var_0_0.create_bonus_objective_func(display_name, table.size(_bonus_objective_widgets) + table.size(_bonus_objective_stack_widgets), is_stacking_objective, objective_name)
					local var_7_15 = _bonus_objective_stack_widgets[is_stacking_objective]

					var_7_15 = var_7_15 or {}
					var_7_15[#var_7_15 + 1] = UIWidget.init(create_bonus_objective_func)
					_bonus_objective_stack_widgets[is_stacking_objective] = var_7_15
					_bonus_objective_lookup[objective_name] = var_7_15[#var_7_15]
					tbl_3[is_stacking_objective] = true
				else
					local var_7_16 = _bonus_objective_stack_widgets[is_stacking_objective][#_bonus_objective_stack_widgets[is_stacking_objective]]

					var_7_16.content.stack[#var_7_16.content.stack + 1] = objective_name
					_bonus_objective_lookup[objective_name] = var_7_16
				end
			else
				local create_bonus_objective_func_2 = var_0_0.create_bonus_objective_func(display_name, table.size(_bonus_objective_widgets) + table.size(_bonus_objective_stack_widgets))

				_bonus_objective_widgets[objective_name] = UIWidget.init(create_bonus_objective_func_2)
				_bonus_objective_lookup[objective_name] = _bonus_objective_widgets[objective_name]
			end
		end

		for k, v_3 in pairs(_bonus_objective_lookup) do
			if tbl[k] or v_3.content:is_done_func(k) or not self:_handle_stacks(v_3, k) then
				v_3.content.is_done = true

				local objective_name_id = v_3.content.objective_name_id
				local objective_name_2 = v_3.style.objective_name
				local var_7_20, var_7_21 = UIFontByResolution(objective_name_2)
				local text_size = UIRenderer.text_size(self._ui_renderer, objective_name_id, var_7_20[1], var_7_21)
				local clone = table.clone(v_3.style.checkmark.texture_size)

				self._animations["checkmark_x_" .. k] = UIAnimation.init(UIAnimation.function_by_time, v_3.style.checkmark.texture_size, 1, clone[1] * 3, clone[1], 0.4, math.easeOutCubic)
				self._animations["checkmark_y_" .. k] = UIAnimation.init(UIAnimation.function_by_time, v_3.style.checkmark.texture_size, 2, clone[2] * 3, clone[2], 0.4, math.easeOutCubic)
				self._animations["checkmark_shadow_x_" .. k] = UIAnimation.init(UIAnimation.function_by_time, v_3.style.checkmark_shadow.texture_size, 1, clone[1] * 3, clone[1], 0.4, math.easeOutCubic)
				self._animations["checkmark_shadow_y_" .. k] = UIAnimation.init(UIAnimation.function_by_time, v_3.style.checkmark_shadow.texture_size, 2, clone[2] * 3, clone[2], 0.4, math.easeOutCubic)
				self._animations["checkmark_color_r_" .. k] = UIAnimation.init(UIAnimation.function_by_time, v_3.style.checkmark.color, 2, 255, 192, 0.4, math.easeOutCubic)
				self._animations["checkmark_color_g_" .. k] = UIAnimation.init(UIAnimation.function_by_time, v_3.style.checkmark.color, 3, 255, 192, 0.4, math.easeOutCubic)
				self._animations["checkmark_color_b_" .. k] = UIAnimation.init(UIAnimation.function_by_time, v_3.style.checkmark.color, 4, 255, 192, 0.4, math.easeOutCubic)
				self._animation_callbacks["checkmark_x_" .. k] = function ()
					-- function 8
					self._animations["stroke_" .. k] = UIAnimation.init(UIAnimation.function_by_time, v_3.style.stroke.texture_size, 1, 0, text_size, 0.25, math.easeInCubic)
					self._animations["essence_icon_r_" .. k] = UIAnimation.init(UIAnimation.function_by_time, v_3.style.essence_icon.color, 2, 255, 60, 0.4, math.easeOutCubic)
					self._animations["essence_icon_g_" .. k] = UIAnimation.init(UIAnimation.function_by_time, v_3.style.essence_icon.color, 3, 255, 60, 0.4, math.easeOutCubic)
					self._animations["essence_icon_b_" .. k] = UIAnimation.init(UIAnimation.function_by_time, v_3.style.essence_icon.color, 4, 255, 60, 0.4, math.easeOutCubic)
					self._animation_callbacks["stroke_" .. k] = function ()
						-- function 9
						self._animations["objective_color_r_" .. k] = UIAnimation.init(UIAnimation.function_by_time, objective_name_2.text_color, 2, 255, 192, 0.5, math.easeInCubic)
						self._animations["objective_color_g_" .. k] = UIAnimation.init(UIAnimation.function_by_time, objective_name_2.text_color, 3, 255, 192, 0.5, math.easeInCubic)
						self._animations["objective_color_b_" .. k] = UIAnimation.init(UIAnimation.function_by_time, objective_name_2.text_color, 4, 255, 192, 0.5, math.easeInCubic)
					end
				end
			end
		end
	end
end

WeaveProgressUI._handle_stacks = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	local content = arg_10_1.content

	if not content.stack then
		return true
	end

	local stack = content.stack
	local done_stack = content.done_stack

	done_stack[#done_stack + 1] = arg_10_2

	return table.size(done_stack) == table.size(stack)
end

WeaveProgressUI._update_animations = function (self, arg_11_1)
	-- function 11
	local _animations = self._animations
	local _animation_callbacks = self._animation_callbacks

	for k, v in pairs(_animations) do
		UIAnimation.update(v, arg_11_1)

		if not UIAnimation.completed(v) then
			_animations[k] = nil

			local var_11_2 = _animation_callbacks[k]

			if not var_11_2 then
				var_11_2()

				_animation_callbacks[k] = nil
			end
		end
	end
end

local flag

flag = not DEBUG and 0 and nil

WeaveProgressUI._update_bar = function (self, arg_12_1, arg_12_2)
	-- function 12
	local weave = Managers.weave

	if not weave:get_active_weave() then
		local current_bar_score = weave:current_bar_score()
		local _old_progress = self._old_progress

		self._progress = current_bar_score / 100

		if not (not _old_progress and not (_old_progress < self._progress)) then
			local progress_ui = self._widgets.progress_ui
			local content = progress_ui.content
			local style = progress_ui.style

			self._animations.update_bar_glow = UIAnimation.init(UIAnimation.function_by_time, style.bar_glow.color, 1, 255, 0, 0.5, math.easeInCubic)

			self._animation_callbacks.update_bar_glow = function ()
				-- function 13
				self._animations.update_bar = UIAnimation.init(UIAnimation.function_by_time, content, "bar_progress", content.bar_progress, self._progress, 0.5, math.easeOutCubic)
			end

			self._animations.update_effect = UIAnimation.init(UIAnimation.function_by_time, style.background_filled.color, 1, 255, 0, 2, math.easeOutCubic)
		end

		local content_2 = self._widgets.progress_ui.content

		content_2.progress = self._progress
		self._old_progress = self._progress

		if current_bar_score >= content_2.bar_cutoff then
			content_2.bonus_time = ""
		end
	end
end

WeaveProgressUI._draw = function (self, arg_14_1, arg_14_2)
	-- function 14
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _render_settings = self._render_settings
	local get_service = Managers.input:get_service("ingame_menu")

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, get_service, arg_14_1, nil, _render_settings)

	for k, v in pairs(self._widgets) do
		UIRenderer.draw_widget(_ui_renderer, v)
	end

	local _bonus_objective_widgets = self._bonus_objective_widgets

	if table.size(_bonus_objective_widgets) > 0 then
		UIRenderer.draw_widget(_ui_renderer, self._bonus_header_widget)

		for k_2, v_2 in pairs(_bonus_objective_widgets) do
			UIRenderer.draw_widget(_ui_renderer, v_2)
		end
	end

	local _bonus_objective_stack_widgets = self._bonus_objective_stack_widgets

	if table.size(_bonus_objective_stack_widgets) > 0 then
		for k_3, v_3 in pairs(_bonus_objective_stack_widgets) do
			for k_4, v_4 in pairs(v_3) do
				UIRenderer.draw_widget(_ui_renderer, v_4)
			end
		end
	end

	if not (table.size(_bonus_objective_widgets) > 0 or not (table.size(_bonus_objective_stack_widgets) > 0)) then
		UIRenderer.draw_widget(_ui_renderer, self._bonus_header_widget)
	end

	UIRenderer.end_pass(_ui_renderer)
end
