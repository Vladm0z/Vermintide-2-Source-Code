-- chunkname: @scripts/ui/hud_ui/floating_icon_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/floating_icon_ui_definitions")
local animation_definitions = var_0_0.animation_definitions
local widget_definitions = var_0_0.widget_definitions
local scenegraph_definition = var_0_0.scenegraph_definition

FloatingIconUI = class(FloatingIconUI)

FloatingIconUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self.ui_renderer = arg_1_2.ui_renderer
	self.ingame_ui = arg_1_2.ingame_ui
	self.input_manager = arg_1_2.input_manager
	self.world_manager = arg_1_2.world_manager
	self.camera_manager = arg_1_2.camera_manager
	self.player_manager = arg_1_2.player_manager
	self.peer_id = arg_1_2.peer_id

	local world = self.world_manager:world("level_world")

	self.wwise_world = Managers.world:wwise_world(world)
	self._animations = {}
	self.render_settings = {
		snap_pixel_positions = true
	}

	self:create_ui_elements()
	Managers.state.event:register(self, "start_progression_zone", "show_progression_bar")
	Managers.state.event:register(self, "stop_progression_zone", "hide_progression_bar")
end

local flag = true

FloatingIconUI.create_ui_elements = function (self)
	-- function 2
	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widget_definitions) do
		if not v then
			local var_2_2 = UIWidget.init(v)

			tbl[#tbl + 1] = var_2_2
			tbl_2[k] = var_2_2
		end
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	flag = false
end

FloatingIconUI.destroy = function (self)
	-- function 3
	self.ui_animator = nil

	if not Managers.state.event then
		Managers.state.event:unregister("start_progression_zone", self)
		Managers.state.event:unregister("stop_progression_zone", self)
	end
end

FloatingIconUI.show_progression_bar = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not (not self._progress_unit and self._progress_unit ~= arg_4_1) then
		return
	end

	self._progress_unit = arg_4_1
	self._progress_extension = arg_4_2
end

FloatingIconUI.hide_progression_bar = function (self, arg_5_1)
	-- function 5
	if self._progress_unit == arg_5_1 then
		self._progress_unit = nil
		self._progress_extension = nil
	end
end

FloatingIconUI.update = function (self, arg_6_1)
	-- function 6
	if not flag then
		self:create_ui_elements()
	end

	if not self._progress_unit then
		self:_draw_progressbar(arg_6_1)
	end
end

FloatingIconUI._draw_progressbar = function (self, arg_7_1)
	-- function 7
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("ingame_menu")
	local render_settings = self.render_settings

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_7_1, nil, render_settings)

	local progress_bar_personal = self._progress_extension:progress_bar_personal()

	progress_bar_personal = not progress_bar_personal and self._progress_extension:player_been_in_zone()

	local progress_bar_global = self._progress_extension:progress_bar_global()

	progress_bar_global = progress_bar_global or progress_bar_personal

	if progress_bar_personal or not progress_bar_global then
		local progress = self._progress_extension:progress()

		if not self._progress_extension:should_progress_count_down() then
			progress = 1 - self._progress_extension:progress()
		end

		self:_draw(self._progress_unit, progress, arg_7_1)
	end

	UIRenderer.end_pass(ui_renderer)
end

FloatingIconUI._get_camera = function (self)
	-- function 8
	local str = "player_1"

	if not self.camera_manager:has_viewport(str) then
		local str_2 = "level_world"
		local world_manager = self.world_manager

		if not world_manager:has_world(str_2) then
			local world = world_manager:world(str_2)
			local viewport = ScriptWorld.viewport(world, str)

			return ScriptViewport.camera(viewport)
		end
	end
end

FloatingIconUI._get_player_rotation_and_position = function (self)
	-- function 9
	local get_player_first_person_extension = self:get_player_first_person_extension()
	local current_position = get_player_first_person_extension:current_position()
	local current_rotation = get_player_first_person_extension:current_rotation()

	return current_position, current_rotation
end

FloatingIconUI._set_widget_position = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local offset = arg_10_1.offset

	offset[1] = arg_10_2
	offset[2] = arg_10_3
end

FloatingIconUI._set_bar_progress = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local foreground = arg_11_1.style.foreground
	local default_size = foreground.default_size

	foreground.texture_size[1] = math.floor(default_size[1] * arg_11_2)
end

FloatingIconUI._draw = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local ui_renderer = self.ui_renderer
	local progress_bar = self._widgets_by_name.progress_bar

	self:_set_bar_progress(progress_bar, arg_12_2, arg_12_3)

	local num = 100
	local num_2 = 100

	self:_set_widget_position(progress_bar, num, num_2)
	UIRenderer.draw_widget(ui_renderer, progress_bar)
end

FloatingIconUI.convert_world_to_screen_position = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	if not arg_13_1 then
		local world_to_screen = Camera.world_to_screen(arg_13_1, arg_13_2)

		return world_to_screen.x, world_to_screen.y
	end
end

FloatingIconUI.get_floating_icon_position = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	-- function 14
	local get_size_scaled = UISceneGraph.get_size_scaled(self.ui_scenegraph, "screen")
	local scale = RESOLUTION_LOOKUP.scale
	local num = get_size_scaled[1] * scale
	local num_2 = get_size_scaled[2] * scale
	local num_3 = num * 0.5
	local num_4 = num_2 * 0.5
	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h
	local num_5 = res_w / 2
	local num_6 = res_h / 2
	local num_7 = arg_14_1 - num_5
	local num_8 = num_6 - arg_14_2
	local flag = false
	local flag_2 = false

	if math.abs(num_7) > num_3 * 0.9 then
		flag = true
	end

	if math.abs(num_8) > num_4 * 0.9 then
		flag_2 = true
	end

	local var_14_14 = arg_14_1
	local var_14_15 = arg_14_2
	local flag_3

	flag_3 = not (arg_14_3 < 0) or not true or false

	local flag_4

	flag_4 = flag or not flag_2 or true or false

	local num_9 = res_w - num
	local num_10 = res_h - num_2
	local num_11 = var_14_14 - num_9 / 2
	local num_12 = var_14_15 - num_10 / 2
	local inv_scale = RESOLUTION_LOOKUP.inv_scale
	local num_13 = num_11 * inv_scale
	local num_14 = num_12 * inv_scale

	return num_13, num_14, flag_4, flag_3
end

FloatingIconUI.get_icon_size = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	local var_15_0 = arg_15_4
	local start_scale_distance = arg_15_5.start_scale_distance
	local end_scale_distance = arg_15_5.end_scale_distance
	local distance = Vector3.distance(arg_15_1, arg_15_2)
	local num = 1

	if start_scale_distance < distance then
		num = self:icon_scale_by_distance(distance - start_scale_distance, end_scale_distance)
		var_15_0 = math.lerp(arg_15_3, num * arg_15_4, 0.2)
	end

	return var_15_0, num
end

FloatingIconUI.icon_scale_by_distance = function (arg_16_0, arg_16_1, arg_16_2)
	-- function 16
	local min = math.min(arg_16_2, arg_16_1)
	local max = math.max(0, min)
	local minimum_icon_scale = UISettings.tutorial.mission_tooltip.minimum_icon_scale

	return (math.max(minimum_icon_scale, 1 - max / arg_16_2))
end

FloatingIconUI.get_player_first_person_extension = function (self)
	-- function 17
	if not self._first_person_extension then
		return self._first_person_extension
	else
		local peer_id = self.peer_id
		local player_unit = self.player_manager:player_from_peer_id(peer_id).player_unit

		if not player_unit and not ScriptUnit.has_extension(player_unit, "first_person_system") then
			local extension = ScriptUnit.extension(player_unit, "first_person_system")

			self._first_person_extension = extension

			return extension
		end
	end
end
