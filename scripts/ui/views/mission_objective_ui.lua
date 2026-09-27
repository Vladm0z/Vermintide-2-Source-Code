-- chunkname: @scripts/ui/views/mission_objective_ui.lua

local var_0_0 = local_require("scripts/ui/views/mission_objective_ui_definitions")
local animation_definitions = var_0_0.animation_definitions
local scenegraph_definition = var_0_0.scenegraph_definition

MissionObjectiveUI = class(MissionObjectiveUI)

MissionObjectiveUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self.ui_renderer = arg_1_2.ui_renderer
	self.ingame_ui = arg_1_2.ingame_ui
	self.input_manager = arg_1_2.input_manager

	local world = arg_1_2.world_manager:world("level_world")

	self.wwise_world = Managers.world:wwise_world(world)
	self.saved_mission_objectives = {}
	self.completed_mission_objectives = {}
	self.current_mission_objective = nil
	self.index_count = 0
	self._animations = {}
	self.render_settings = {
		snap_pixel_positions = true
	}

	self:create_ui_elements()

	local event = Managers.state.event

	if not event then
		event:register(self, "ui_event_add_mission_objective", "add_mission_objective")
		event:register(self, "ui_event_complete_mission", "complete_mission")
		event:register(self, "ui_event_update_mission", "update_mission")
		event:register(self, "ui_event_block_mission_ui", "block_mission_ui")

		local system = Managers.state.entity:system("mission_system")

		if not system then
			system:trigger_active_mission_ui_events()
		end
	end
end

local flag = true

MissionObjectiveUI.create_ui_elements = function (self)
	-- function 2
	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	self._mission_widget = UIWidget.init(var_0_0.widget_definitions.mission_widget)
	self.current_mission_objective = nil

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)
	flag = false
end

MissionObjectiveUI.destroy = function (self)
	-- function 3
	local event = Managers.state.event

	if not event then
		event:unregister("ui_event_add_mission_objective", self)
		event:unregister("ui_event_complete_mission", self)
		event:unregister("ui_event_update_mission", self)
		event:unregister("ui_event_block_mission_ui", self)
	end

	self.ui_animator = nil
end

MissionObjectiveUI.block_mission_ui = function (self, arg_4_1)
	-- function 4
	self._ui_blocked = arg_4_1
end

local tbl = {
	root_scenegraph_id = "pivot",
	label = "Objectives",
	registry_key = "mission_objective",
	drag_scenegraph_id = "background"
}

MissionObjectiveUI.update = function (self, arg_5_1)
	-- function 5
	if not flag then
		self:create_ui_elements()
	end

	HudCustomizer.run(self.ui_renderer, self.ui_scenegraph, tbl)

	if not self._ui_blocked then
		return
	end

	self:update_animations(arg_5_1)
	self:next_mission_objective(arg_5_1)

	if self.current_mission_objective or not self._animations.mission_animation then
		self:draw(arg_5_1)
	end
end

MissionObjectiveUI.add_mission_objective = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local saved_mission_objectives = self.saved_mission_objectives

	for k, v in pairs(saved_mission_objectives) do
		if v.mission_name == arg_6_1 then
			return
		end
	end

	self.saved_mission_objectives[#self.saved_mission_objectives + 1] = {
		mission_name = arg_6_1,
		text = arg_6_2,
		duration_text = arg_6_3
	}
end

MissionObjectiveUI._clear_animations = function (self)
	-- function 7
	for k, v in pairs(self._animations) do
		self.ui_animator:stop_animation(v)
	end

	table.clear(self._animations)
end

MissionObjectiveUI.complete_mission = function (self, arg_8_1, arg_8_2)
	-- function 8
	if not arg_8_2 then
		self:_clear_animations()
		self:_remove_mission_objective(arg_8_1)
	else
		self:_remove_mission_objective(arg_8_1)
		self:_clear_animations()
		self:_start_animation("mission_animation", "mission_end")
	end
end

MissionObjectiveUI._remove_mission_objective = function (self, arg_9_1)
	-- function 9
	local var_9_0

	for i, v in ipairs(self.saved_mission_objectives) do
		if v.mission_name == arg_9_1 then
			var_9_0 = i

			break
		end
	end

	if not var_9_0 then
		local var_9_1 = self.saved_mission_objectives[var_9_0]

		if not var_9_1 then
			table.remove(self.saved_mission_objectives, var_9_0)

			self.completed_mission_objectives[var_9_1.mission_name] = var_9_1.text
			self.current_mission_objective = nil
		end
	end
end

MissionObjectiveUI.update_mission = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local var_10_0

	for i, v in ipairs(self.saved_mission_objectives) do
		if v.mission_name == arg_10_1 then
			var_10_0 = i

			break
		end
	end

	if not var_10_0 then
		local var_10_1 = self.saved_mission_objectives[var_10_0]

		self.saved_mission_objectives[var_10_0].text = arg_10_2

		if var_10_1.mission_name == self.current_mission_objective then
			local _mission_widget = self._mission_widget

			self:_set_mission_text(arg_10_2, arg_10_3)
		end
	end
end

MissionObjectiveUI.next_mission_objective = function (self, arg_11_1)
	-- function 11
	if not (self.current_mission_objective or not (#self.saved_mission_objectives > 0) or self._animations.mission_animation) then
		local var_11_0 = self.saved_mission_objectives[1]

		self.current_mission_objective = var_11_0.mission_name

		local flag = true

		self:_set_mission_text(var_11_0.text, var_11_0.duration_text, flag)
		self:_start_animation("mission_animation", "mission_start")
	end
end

MissionObjectiveUI.update_animations = function (self, arg_12_1)
	-- function 12
	local _animations = self._animations
	local ui_animator = self.ui_animator

	ui_animator:update(arg_12_1)

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end
end

MissionObjectiveUI._set_mission_text = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local content = self._mission_widget.content
	local style = self._mission_widget.style

	content.area_text_content = arg_13_1

	local str

	if not arg_13_2 then
		str = arg_13_2 .. " "

		if not str then
			-- Nothing
		end
	end

	str = nil

	::label_13_0::

	content.duration_text_content = str

	local ui_renderer = self.ui_renderer
	local num = 287.5
	local num_2 = 40

	content.text_height = 45

	if not arg_13_3 then
		local ui_scenegraph = self.ui_scenegraph

		if not arg_13_2 then
			local var_13_7, var_13_8 = UIFontByResolution(style.area_text_style)
			local var_13_9 = var_13_7[1]
			local var_13_10 = var_13_8
			local upper = string.upper(content.area_text_content)
			local text_size = UIRenderer.text_size(ui_renderer, upper, var_13_9, var_13_10)
			local var_13_13 = arg_13_2
			local text_size_2 = UIRenderer.text_size(ui_renderer, var_13_13, var_13_9, var_13_10)
			local var_13_15 = ui_scenegraph.area_text_background.size[1]
			local var_13_16 = ui_scenegraph.duration_text_background.size[1]

			ui_scenegraph.area_text_background.position[1] = text_size_2 * 0.5
			ui_scenegraph.duration_text_background.position[1] = -text_size * 0.5
		else
			ui_scenegraph.area_text_background.local_position[1] = 0
			ui_scenegraph.duration_text_background.local_position[1] = 0
		end
	end
end

MissionObjectiveUI._get_text_size = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	-- function 14
	arg_14_5.font_size = arg_14_5.default_font_size

	local huge = math.huge

	if arg_14_4 < huge then
		repeat
			local var_14_1, var_14_2 = UIFontByResolution(arg_14_5)
			local var_14_3 = var_14_1[1]
			local var_14_4 = var_14_1[2]
			local var_14_5 = var_14_1[3]
			local var_14_6, var_14_7, var_14_8 = UIGetFontHeight(arg_14_1.gui, var_14_5, var_14_4)
			local count = #UIRenderer.word_wrap(arg_14_1, arg_14_2, var_14_3, var_14_4, arg_14_3)

			huge = (var_14_8 + math.abs(var_14_7)) * RESOLUTION_LOOKUP.inv_scale * count
			arg_14_5.font_size = math.max(arg_14_5.font_size - 1, arg_14_5.min_font_size)
			arg_14_5.new_font_size = arg_14_5.font_size

			if arg_14_5.font_size == arg_14_5.min_font_size then
				return huge
			end
		until huge <= arg_14_4
	end

	return huge
end

MissionObjectiveUI.draw = function (self, arg_15_1)
	-- function 15
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("ingame_menu")
	local render_settings = self.render_settings

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_15_1, nil, render_settings)
	UIRenderer.draw_widget(ui_renderer, self._mission_widget)
	UIRenderer.end_pass(ui_renderer)
end

MissionObjectiveUI._start_animation = function (self, arg_16_1, arg_16_2)
	-- function 16
	local tbl = {
		wwise_world = self.wwise_world,
		render_settings = self.render_settings,
		ui_renderer = self.ui_renderer
	}
	local start_animation = self.ui_animator:start_animation(arg_16_2, self._mission_widget, scenegraph_definition, tbl)

	self._animations[arg_16_1] = start_animation
end
