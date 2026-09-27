-- chunkname: @scripts/ui/hud_ui/loot_objective_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/loot_objective_ui_definitions")
local create_loot_widget = var_0_0.create_loot_widget

LootObjectiveUI = class(LootObjectiveUI)

local tbl = {
	tome = {
		item_name = "wpn_side_objective_tome_01",
		mission_name = "tome_bonus_mission",
		total_amount = 3,
		texture = "loot_objective_icon_02"
	},
	grimoire = {
		item_name = "wpn_grimoire_01",
		mission_name = "grimoire_hidden_mission",
		total_amount = 2,
		texture = "loot_objective_icon_01"
	}
}

LootObjectiveUI.init = function (self, arg_1_1, arg_1_2)
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
	self._mission_system = Managers.state.entity:system("mission_system")
	self._animations = {}
	self._event_queue = {}

	self:create_ui_elements()
end

local flag = true

LootObjectiveUI.create_ui_elements = function (self)
	-- function 2
	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local tbl_2 = {}
	local tbl_3 = {}

	for k, v in pairs(tbl) do
		local mission_name = v.mission_name
		local texture = v.texture
		local total_amount = v.total_amount
		local var_2_5 = create_loot_widget(texture, total_amount)
		local var_2_6 = UIWidget.init(var_2_5)

		tbl_2[k] = var_2_6
		tbl_3[k] = {
			name = k,
			total_amount = total_amount,
			mission_name = mission_name,
			widget = var_2_6
		}
	end

	self._settings_data = tbl_3
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	flag = false

	self:_sync_missions(true)
end

LootObjectiveUI.destroy = function (arg_3_0)
	-- function 3
	GarbageLeakDetector.register_object(arg_3_0, "loot_objective_ui")
end

local tbl_2 = {
	root_scenegraph_id = "background",
	label = "Books",
	registry_key = "books",
	drag_scenegraph_id = "background"
}

LootObjectiveUI.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not flag then
		self:create_ui_elements()
	end

	HudCustomizer.run(self.ui_renderer, self.ui_scenegraph, tbl_2)
	self:_sync_missions()

	self._active_presentation_widget = self:_update_active_presentation(arg_4_1, arg_4_2)

	self:_update_animations(arg_4_1)
	self:draw(arg_4_1)
end

LootObjectiveUI._sync_missions = function (self, arg_5_1)
	-- function 5
	local _settings_data = self._settings_data

	for k, v in pairs(_settings_data) do
		local mission_name = v.mission_name
		local _get_item_amount_by_mission_name = self:_get_item_amount_by_mission_name(mission_name)

		_get_item_amount_by_mission_name = _get_item_amount_by_mission_name or 0

		if not v.amount then
			v.amount = _get_item_amount_by_mission_name or 0
		end

		local amount = v.amount

		if amount ~= _get_item_amount_by_mission_name then
			v.previous_amount = amount or 0
			v.amount = _get_item_amount_by_mission_name

			local widget = v.widget

			if not arg_5_1 then
				self:_add_presentation_event(widget, v.previous_amount, _get_item_amount_by_mission_name)
			end
		end
	end
end

LootObjectiveUI._assign_amount_to_widget = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	arg_6_1.content.draw_count = arg_6_2
end

LootObjectiveUI._get_item_amount_by_mission_name = function (self, arg_7_1)
	-- function 7
	local get_level_end_mission_data = self._mission_system:get_level_end_mission_data(arg_7_1)

	return not get_level_end_mission_data and get_level_end_mission_data.current_amount
end

LootObjectiveUI._add_presentation_event = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local _event_queue = self._event_queue
	local count = #_event_queue

	_event_queue[#_event_queue + 1] = {
		amount = arg_8_3,
		previous_amount = arg_8_2,
		widget = arg_8_1
	}
end

LootObjectiveUI._update_active_presentation = function (self, arg_9_1, arg_9_2)
	-- function 9
	local _event_queue = self._event_queue

	if #_event_queue == 0 then
		return
	end

	local var_9_1 = _event_queue[1]
	local widget = var_9_1.widget
	local amount = var_9_1.amount
	local previous_amount = var_9_1.previous_amount

	if not var_9_1.started then
		self:_assign_amount_to_widget(widget, amount)

		var_9_1.started = true

		local num = 2.5

		var_9_1.end_time = arg_9_2 + self:_animate_in(widget, previous_amount) + num
	end

	if arg_9_2 > var_9_1.end_time then
		if not var_9_1.end_started then
			var_9_1.end_started = true
			var_9_1.end_time = arg_9_2 + self:_animate_out(widget)
		else
			table.remove(_event_queue, 1)
		end
	end

	return widget
end

LootObjectiveUI._animate_in = function (self, arg_10_1, arg_10_2)
	-- function 10
	local _animations = self._animations
	local num = 1
	local num_2 = 0
	local easeInCubic = math.easeInCubic
	local function_by_time = UIAnimation.function_by_time
	local num_3 = 0.3
	local amount = arg_10_1.content.amount
	local draw_count = arg_10_1.content.draw_count
	local texture_colors = arg_10_1.style.icon_textures.texture_colors
	local max = math.max(arg_10_2, draw_count)
	local flag = arg_10_2 < draw_count

	for i = 1, math.min(amount, max) do
		local var_10_11 = texture_colors[i]

		if not (not flag and not (i < max)) then
			local var_10_12 = UIAnimation.init(function_by_time, var_10_11, num, num_2, 255, num_3, easeInCubic)

			_animations["icon_textures_" .. i] = var_10_12
		end

		if i == max then
			if not flag then
				local var_10_13 = UIAnimation.init(UIAnimation.wait, num_3 + 0.2, function_by_time, var_10_11, num, num_2, 255, num_3, easeInCubic)

				_animations["icon_textures_" .. i] = var_10_13
			else
				local var_10_14 = UIAnimation.init(UIAnimation.wait, num_3 + 0.5, function_by_time, var_10_11, num, 255, 0, num_3, easeInCubic)

				_animations["icon_textures_last" .. i] = var_10_14
			end
		end
	end

	local color = arg_10_1.style.background_icon_textures.color
	local default_color = arg_10_1.style.background_icon_textures.default_color

	_animations.background_icon_textures = UIAnimation.init(function_by_time, color, num, num_2, default_color[num], num_3, easeInCubic)

	local color_2 = arg_10_1.style.glow_icon_textures.color
	local default_color_2 = arg_10_1.style.glow_icon_textures.default_color

	_animations.glow_icon_textures = UIAnimation.init(function_by_time, color_2, num, num_2, default_color_2[num], num_3, easeInCubic)

	local color_3 = arg_10_1.style.background.color
	local default_color_3 = arg_10_1.style.background.default_color

	_animations.background = UIAnimation.init(function_by_time, color_3, num, num_2, default_color_3[num], num_3, easeInCubic)

	return num_3
end

LootObjectiveUI._animate_out = function (self, arg_11_1)
	-- function 11
	local _animations = self._animations
	local num = 1
	local num_2 = 0
	local easeInCubic = math.easeInCubic
	local function_by_time = UIAnimation.function_by_time
	local num_3 = 0.3
	local amount = arg_11_1.content.amount
	local draw_count = arg_11_1.content.draw_count
	local texture_colors = arg_11_1.style.icon_textures.texture_colors

	for i = 1, amount do
		if i <= draw_count then
			if not (i ~= draw_count or num_3 + 1) then
				local var_11_9 = num_3
			end

			local var_11_10 = texture_colors[i]

			_animations["icon_textures_" .. i] = UIAnimation.init(function_by_time, var_11_10, num, 255, num_2, num_3, easeInCubic)
		end
	end

	local color = arg_11_1.style.background_icon_textures.color

	_animations.background_icon_textures = UIAnimation.init(function_by_time, color, num, color[1], num_2, num_3, easeInCubic)

	local color_2 = arg_11_1.style.glow_icon_textures.color

	_animations.glow_icon_textures = UIAnimation.init(function_by_time, color_2, num, color_2[1], num_2, num_3, easeInCubic)

	local color_3 = arg_11_1.style.background.color

	_animations.background = UIAnimation.init(function_by_time, color_3, num, color_3[1], num_2, num_3, easeInCubic)

	return num_3
end

LootObjectiveUI._update_animations = function (self, arg_12_1)
	-- function 12
	local _animations = self._animations

	for k, v in pairs(_animations) do
		UIAnimation.update(v, arg_12_1)

		if not UIAnimation.completed(v) then
			_animations[k] = nil
		end
	end
end

LootObjectiveUI.draw = function (self, arg_13_1)
	-- function 13
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("ingame_menu")

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_13_1)

	local _active_presentation_widget = self._active_presentation_widget

	if not _active_presentation_widget then
		UIRenderer.draw_widget(ui_renderer, _active_presentation_widget)
	end

	UIRenderer.end_pass(ui_renderer)
end
