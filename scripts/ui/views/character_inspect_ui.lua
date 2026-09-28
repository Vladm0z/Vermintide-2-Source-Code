-- chunkname: @scripts/ui/views/character_inspect_ui.lua

local definitions = local_require("scripts/ui/views/character_inspect_ui_definitions")
local create_loot_widget = definitions.create_loot_widget

CharacterInspectUI = class(CharacterInspectUI)

CharacterInspectUI.init = function (self, ingame_ui_context)
	-- function 1
	self.ui_top_renderer = ingame_ui_context.ui_top_renderer
	self.ui_renderer = ingame_ui_context.ui_renderer
	self.ingame_ui = ingame_ui_context.ingame_ui
	self.input_manager = ingame_ui_context.input_manager

	local world = ingame_ui_context.world_manager:world("level_world")

	self.wwise_world = Managers.world:wwise_world(world)
	self._animations = {}

	self:create_ui_elements()
end

local DO_RELOAD = true

CharacterInspectUI.create_ui_elements = function (self)
	-- function 2
	self.ui_scenegraph = UISceneGraph.init_scenegraph(definitions.scenegraph_definition)

	local widgets = {}
	local widgets_by_name = {}
	local widget_definitions = definitions.widget_definitions

	for name, definition in pairs(widget_definitions) do
		local widget = UIWidget.init(definition)

		widgets[#widgets + 1] = widget
		widgets_by_name[name] = widget
	end

	self._widgets = widgets
	self._widgets_by_name = widgets_by_name

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	DO_RELOAD = false
end

CharacterInspectUI.destroy = function (self)
	-- function 3
	GarbageLeakDetector.register_object(self, "character_inspect_ui")
end

CharacterInspectUI.update = function (self, dt)
	-- function 4
	if DO_RELOAD then
		self:create_ui_elements()
	end

	self:_update_animations(dt)
	self:draw(dt)
end

CharacterInspectUI._update_animations = function (self, dt)
	-- function 5
	local animations = self._animations

	for anmation_name, anmation in pairs(animations) do
		UIAnimation.update(anmation, dt)

		if UIAnimation.completed(anmation) then
			animations[anmation_name] = nil
		end
	end
end

CharacterInspectUI.draw = function (self, dt)
	-- function 6
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local input_service = self.input_manager:get_service("ingame_menu")
	local widgets_by_name = self._widgets_by_name

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, input_service, dt)

	for _, widget in pairs(widgets_by_name) do
		UIRenderer.draw_widget(ui_top_renderer, widget)
	end

	UIRenderer.end_pass(ui_top_renderer)
end

CharacterInspectUI.set_position = function (self, x, y)
	-- function 7
	local position = self.ui_scenegraph.background.local_position

	position[1] = x
	position[2] = y
end
