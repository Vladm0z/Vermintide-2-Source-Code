-- chunkname: @scripts/ui/views/area_indicator_ui.lua

local var_0_0 = local_require("scripts/ui/views/area_indicator_ui_definitions")

AreaIndicatorUI = class(AreaIndicatorUI)

AreaIndicatorUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self.ui_renderer = arg_1_2.ui_renderer
	self.ingame_ui = arg_1_2.ingame_ui
	self.input_manager = arg_1_2.input_manager

	local world = arg_1_2.world_manager:world("level_world")

	self.wwise_world = Managers.world:wwise_world(world)

	self:create_ui_elements()
end

AreaIndicatorUI.create_ui_elements = function (self)
	-- function 2
	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	self.area_text_box = UIWidget.init(var_0_0.widget_definitions.area_text_box)

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)
end

AreaIndicatorUI.destroy = function (arg_3_0)
	-- function 3
	return
end

AreaIndicatorUI.update = function (self, arg_4_1)
	-- function 4
	local local_player = Managers.player:local_player()
	local flag = not local_player and local_player.player_unit

	if not flag and not Unit.alive(flag) then
		local extension = ScriptUnit.extension(flag, "hud_system")
		local saved_location = self.saved_location
		local current_location = extension.current_location

		if not (extension.location_ui_blocked or current_location == nil or current_location == saved_location) then
			self.saved_location = current_location

			local area_indicator = UISettings.area_indicator
			local area_text_box = self.area_text_box

			area_text_box.content.text = current_location
			self.area_text_box_animation = UIAnimation.init(UIAnimation.function_by_time, area_text_box.style.text.text_color, 1, 0, 255, area_indicator.fade_time, math.easeInCubic, UIAnimation.wait, area_indicator.wait_time, UIAnimation.function_by_time, area_text_box.style.text.text_color, 1, 255, 0, area_indicator.fade_time, math.easeInCubic)
			self.area_text_box_shadow_animation = UIAnimation.init(UIAnimation.function_by_time, area_text_box.style.text_shadow.text_color, 1, 0, 255, area_indicator.fade_time, math.easeInCubic, UIAnimation.wait, area_indicator.wait_time, UIAnimation.function_by_time, area_text_box.style.text_shadow.text_color, 1, 255, 0, area_indicator.fade_time, math.easeInCubic)

			WwiseWorld.trigger_event(self.wwise_world, "hud_area_indicator")
		end
	end

	if self.area_text_box_animation == nil then
		return
	end

	self.area_text_box_animation = self:update_animation(self.area_text_box_animation, arg_4_1)
	self.area_text_box_shadow_animation = self:update_animation(self.area_text_box_shadow_animation, arg_4_1)

	self:draw(arg_4_1)
end

AreaIndicatorUI.update_animation = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	if not arg_5_1 then
		UIAnimation.update(arg_5_1, arg_5_2)

		if not UIAnimation.completed(arg_5_1) then
			return nil
		end

		return arg_5_1
	end
end

AreaIndicatorUI.draw = function (self, arg_6_1)
	-- function 6
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("ingame_menu")

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_6_1)
	UIRenderer.draw_widget(ui_renderer, self.area_text_box)
	UIRenderer.end_pass(ui_renderer)
end
