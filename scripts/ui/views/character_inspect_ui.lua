-- chunkname: @scripts/ui/views/character_inspect_ui.lua

local var_0_0 = local_require("scripts/ui/views/character_inspect_ui_definitions")
local create_loot_widget = var_0_0.create_loot_widget

CharacterInspectUI = class(CharacterInspectUI)

CharacterInspectUI.init = function (self, arg_1_1)
	-- function 1
	self.ui_top_renderer = arg_1_1.ui_top_renderer
	self.ui_renderer = arg_1_1.ui_renderer
	self.ingame_ui = arg_1_1.ingame_ui
	self.input_manager = arg_1_1.input_manager

	local world = arg_1_1.world_manager:world("level_world")

	self.wwise_world = Managers.world:wwise_world(world)
	self._animations = {}

	self:create_ui_elements()
end

local flag = true

CharacterInspectUI.create_ui_elements = function (self)
	-- function 2
	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}
	local widget_definitions = var_0_0.widget_definitions

	for k, v in pairs(widget_definitions) do
		local var_2_3 = UIWidget.init(v)

		tbl[#tbl + 1] = var_2_3
		tbl_2[k] = var_2_3
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	flag = false
end

CharacterInspectUI.destroy = function (arg_3_0)
	-- function 3
	GarbageLeakDetector.register_object(arg_3_0, "character_inspect_ui")
end

CharacterInspectUI.update = function (self, arg_4_1)
	-- function 4
	if not flag then
		self:create_ui_elements()
	end

	self:_update_animations(arg_4_1)
	self:draw(arg_4_1)
end

CharacterInspectUI._update_animations = function (self, arg_5_1)
	-- function 5
	local _animations = self._animations

	for k, v in pairs(_animations) do
		UIAnimation.update(v, arg_5_1)

		if not UIAnimation.completed(v) then
			_animations[k] = nil
		end
	end
end

CharacterInspectUI.draw = function (self, arg_6_1)
	-- function 6
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("ingame_menu")
	local _widgets_by_name = self._widgets_by_name

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, get_service, arg_6_1)

	for k, v in pairs(_widgets_by_name) do
		UIRenderer.draw_widget(ui_top_renderer, v)
	end

	UIRenderer.end_pass(ui_top_renderer)
end

CharacterInspectUI.set_position = function (self, arg_7_1, arg_7_2)
	-- function 7
	local local_position = self.ui_scenegraph.background.local_position

	local_position[1] = arg_7_1
	local_position[2] = arg_7_2
end
