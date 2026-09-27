-- chunkname: @scripts/ui/hud_ui/buff_presentation_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/buff_presentation_ui_definitions")
local animation_definitions = var_0_0.animation_definitions
local scenegraph_definition = var_0_0.scenegraph_definition

BuffPresentationUI = class(BuffPresentationUI)

BuffPresentationUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self.ui_renderer = arg_1_2.ui_renderer
	self.ingame_ui = arg_1_2.ingame_ui
	self.input_manager = arg_1_2.input_manager

	local world = arg_1_2.world_manager:world("level_world")

	self.wwise_world = Managers.world:wwise_world(world)

	self:create_ui_elements()
end

BuffPresentationUI.create_ui_elements = function (self)
	-- function 2
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self.presentation_widget = UIWidget.init(var_0_0.widget_definitions.presentation_widget)
	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)
	self._animations = {}
	self._buffs_to_add = {}
	self._added_buff_presentations = {}
	self._buffs_presented = {}

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)
end

BuffPresentationUI.destroy = function (self)
	-- function 3
	self.ui_animator = nil
end

local tbl = {
	root_scenegraph_id = "presentation_widget",
	label = "Buff",
	registry_key = "buff_present",
	drag_scenegraph_id = "presentation_widget_dragger"
}

BuffPresentationUI.update = function (self, arg_4_1)
	-- function 4
	if not HudCustomizer.run(self.ui_renderer, self.ui_scenegraph, tbl) then
		UISceneGraph.update_scenegraph(self.ui_scenegraph)
	end

	self:_sync_buffs()
	self:_next_buff(arg_4_1)

	if not self._active_buff_name then
		self:update_animations(arg_4_1)
		self:draw(arg_4_1)
	end
end

BuffPresentationUI.update_animations = function (self, arg_5_1)
	-- function 5
	local _animations = self._animations
	local ui_animator = self.ui_animator

	ui_animator:update(arg_5_1)

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end
end

BuffPresentationUI.draw = function (self, arg_6_1)
	-- function 6
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("ingame_menu")

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_6_1)
	UIRenderer.draw_widget(ui_renderer, self.presentation_widget)
	UIRenderer.end_pass(ui_renderer)
end

BuffPresentationUI._clear_animations = function (self)
	-- function 7
	for k, v in pairs(self._animations) do
		self.ui_animator:stop_animation(v)
	end

	table.clear(self._animations)
end

BuffPresentationUI._start_animation = function (self, arg_8_1, arg_8_2)
	-- function 8
	local tbl = {
		wwise_world = self.wwise_world
	}
	local start_animation = self.ui_animator:start_animation(arg_8_2, self.presentation_widget, scenegraph_definition, tbl)

	self._animations[arg_8_1] = start_animation
end

BuffPresentationUI._sync_buffs = function (self)
	-- function 9
	local parameter = Development.parameter("debug_player_buffs")
	local time = Managers.time:time("game")
	local player_unit = Managers.player:local_player(1).player_unit

	if not player_unit then
		local _buffs_to_add = self._buffs_to_add
		local _buffs_presented = self._buffs_presented

		table.clear(_buffs_to_add)

		local extension = ScriptUnit.extension(player_unit, "buff_system")
		local active_buffs = extension:active_buffs()
		local _num_buffs = extension._num_buffs

		for i = 1, _num_buffs do
			local var_9_8 = active_buffs[i]

			if not var_9_8.removed then
				local template = var_9_8.template
				local name = template.name

				if not (not not _buffs_to_add[name] or not _buffs_presented[name] or parameter or template.icon == nil or not template.priority_buff) then
					self:_add_buff(var_9_8)

					_buffs_to_add[name] = var_9_8
				end
			end
		end

		for i_2, v in ipairs(self._added_buff_presentations) do
			local name_2 = v.name
			local flag = true

			for k, v_2 in pairs(_buffs_to_add) do
				if k == name_2 then
					flag = false

					break
				end
			end

			if not flag then
				self:_remove_buff(name_2)
			end
		end

		for k_2, v_3 in pairs(_buffs_presented) do
			local flag_2 = true

			for i7 = 1, _num_buffs do
				local var_9_14 = active_buffs[i7]

				if not (var_9_14.removed or k_2 ~= var_9_14.template.name) then
					flag_2 = false

					break
				end
			end

			if not flag_2 then
				_buffs_presented[k_2] = nil
			end
		end
	end
end

BuffPresentationUI._add_buff = function (self, arg_10_1)
	-- function 10
	local _added_buff_presentations = self._added_buff_presentations
	local template = arg_10_1.template
	local name = template.name

	for i, v in ipairs(_added_buff_presentations) do
		if v.name == name then
			return
		end
	end

	self._added_buff_presentations[#self._added_buff_presentations + 1] = template
end

BuffPresentationUI._remove_buff = function (self, arg_11_1)
	-- function 11
	local var_11_0

	for i, v in ipairs(self._added_buff_presentations) do
		if v.name == arg_11_1 then
			var_11_0 = i

			break
		end
	end

	if not var_11_0 and not self._added_buff_presentations[var_11_0] then
		table.remove(self._added_buff_presentations, var_11_0)
	end
end

BuffPresentationUI._next_buff = function (self, arg_12_1)
	-- function 12
	local _added_buff_presentations = self._added_buff_presentations

	if not (not self._active_buff_name and not self._active_buff_name and self._animations.presentation) then
		if not self._active_buff_name then
			self._buffs_presented[self._active_buff_name] = true
			self._active_buff_name = nil

			table.remove(_added_buff_presentations, 1)
		end

		if #_added_buff_presentations > 0 then
			local var_12_1 = _added_buff_presentations[1]

			self._active_buff_name = var_12_1.name

			self:_set_buff_to_present(var_12_1)
			self:_start_animation("presentation", "presentation")
		end
	end
end

BuffPresentationUI._set_buff_to_present = function (self, arg_13_1)
	-- function 13
	local presentation_widget = self.presentation_widget
	local icon = arg_13_1.icon

	icon = icon or "icons_placeholder"
	presentation_widget.content.texture_icon = icon
end
