-- chunkname: @scripts/ui/act_presentation/act_presentation_ui.lua

local var_0_0 = local_require("scripts/ui/act_presentation/act_presentation_ui_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local widgets = var_0_0.widgets
local animations = var_0_0.animations

ActPresentationUI = class(ActPresentationUI)

local flag = false

ActPresentationUI.init = function (self, arg_1_1)
	-- function 1
	self.ui_renderer = arg_1_1.ui_renderer
	self.ui_top_renderer = arg_1_1.ui_top_renderer
	self.ingame_ui = arg_1_1.ingame_ui
	self.statistics_db = arg_1_1.statistics_db
	self.stats_id = arg_1_1.stats_id
	self.input_manager = arg_1_1.input_manager
	self.render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	self.platform = PLATFORM
	self.world = arg_1_1.world_manager:world("level_world")
	self.wwise_world = Managers.world:wwise_world(self.world)

	self:create_ui_elements()

	local input_manager = self.input_manager

	input_manager:create_input_service("act_presentation", "IngameMenuKeymaps", "IngameMenuFilters")
	input_manager:map_device_to_service("act_presentation", "keyboard")
	input_manager:map_device_to_service("act_presentation", "mouse")
	input_manager:map_device_to_service("act_presentation", "gamepad")
end

ActPresentationUI.create_ui_elements = function (self)
	-- function 2
	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		if not v then
			local var_2_2 = UIWidget.init(v)

			tbl[#tbl + 1] = var_2_2
			tbl_2[k] = var_2_2
		end
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animations)
	self._animations = {}
	flag = false
end

ActPresentationUI.start = function (self, arg_3_1, arg_3_2)
	-- function 3
	local get_act_key_by_level = LevelUnlockUtils.get_act_key_by_level(arg_3_1)

	if not get_act_key_by_level then
		self.active = true
		self._presentation_aborted = true

		return false
	end

	self._presentation_aborted = nil

	self:_set_presentation_info(get_act_key_by_level, arg_3_1)

	local _setup_level, var_3_2 = self:_setup_level(get_act_key_by_level, arg_3_1, arg_3_2)
	local tbl = {
		wwise_world = self.wwise_world,
		level_key = arg_3_1,
		widget = self._widgets_by_name.level,
		first_time = _setup_level,
		previous_difficulty_index = arg_3_2,
		difficulty_index = var_3_2,
		render_settings = self.render_settings
	}

	self.animation_params = tbl

	local flag

	flag = not _setup_level and "enter_first_time" and "enter"

	self:start_presentation_animation(flag, tbl)

	self.active = true
end

ActPresentationUI._set_presentation_info = function (self, arg_4_1, arg_4_2)
	-- function 4
	local var_4_0 = LevelSettings[arg_4_2]
	local display_name = var_4_0.display_name
	local level_image = var_4_0.level_image
	local display_name_2 = Managers.state.difficulty:get_difficulty_settings().display_name
	local display_name_3 = ActSettings[arg_4_1].display_name
	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.level.content.icon = level_image

	local content = _widgets_by_name.act_title.content
	local var_4_7

	if not display_name_3 then
		var_4_7 = Localize(display_name_3)

		if not var_4_7 then
			-- Nothing
		end
	end

	var_4_7 = ""

	::label_4_0::

	content.text = var_4_7
	_widgets_by_name.level_title.content.text = Localize(display_name)
end

ActPresentationUI._setup_level = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local _widgets_by_name = self._widgets_by_name
	local statistics_db = self.statistics_db
	local stats_id = self.stats_id
	local get_persistent_stat = statistics_db:get_persistent_stat(stats_id, "completed_levels", arg_5_2)

	get_persistent_stat = get_persistent_stat or 0

	local flag = get_persistent_stat ~= 0
	local completed_level_difficulty_index

	if not flag then
		completed_level_difficulty_index = LevelUnlockUtils.completed_level_difficulty_index(statistics_db, stats_id, arg_5_2)

		if not completed_level_difficulty_index then
			-- Nothing
		end
	end

	completed_level_difficulty_index = 0

	::label_5_0::

	local flag_2 = arg_5_3 < completed_level_difficulty_index
	local level = _widgets_by_name.level
	local content = level.content
	local style = level.style

	content.locked = flag_2 or not flag

	return flag_2, completed_level_difficulty_index
end

ActPresentationUI.destroy = function (self)
	-- function 6
	self._ui_animator = nil
end

ActPresentationUI._update_animations = function (self, arg_7_1)
	-- function 7
	local _animations = self._animations
	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_7_1)

	for k, v in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v) then
			_ui_animator:stop_animation(v)

			_animations[k] = nil

			local animation_params = self.animation_params

			if not animation_params then
				animation_params.presentation_completed = true
				self.active = false
			end
		end
	end
end

ActPresentationUI.presentation_completed = function (self)
	-- function 8
	local animation_params = self.animation_params
	local presentation_completed

	if not animation_params then
		presentation_completed = animation_params.presentation_completed

		if not presentation_completed then
			-- Nothing
		end
	end

	presentation_completed = self._presentation_aborted

	::label_8_0::

	return presentation_completed
end

ActPresentationUI.update = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not flag then
		self:create_ui_elements()
	end

	self:_update_animations(arg_9_1)
	self:draw(arg_9_1)
end

ActPresentationUI.draw = function (self, arg_10_1)
	-- function 10
	local ui_top_renderer = self.ui_top_renderer
	local render_settings = self.render_settings
	local _ui_scenegraph = self._ui_scenegraph
	local get_service = self.input_manager:get_service("act_presentation")
	local alpha_multiplier = render_settings.alpha_multiplier

	UIRenderer.begin_pass(ui_top_renderer, _ui_scenegraph, get_service, arg_10_1, nil, render_settings)

	local snap_pixel_positions = render_settings.snap_pixel_positions

	for i, v in ipairs(self._widgets) do
		if v.snap_pixel_positions ~= nil then
			render_settings.snap_pixel_positions = v.snap_pixel_positions
		end

		UIRenderer.draw_widget(ui_top_renderer, v)

		render_settings.snap_pixel_positions = snap_pixel_positions
	end

	UIRenderer.end_pass(ui_top_renderer)
end

ActPresentationUI.start_presentation_animation = function (self, arg_11_1, arg_11_2)
	-- function 11
	local flag = arg_11_2 or {
		wwise_world = self.wwise_world
	}
	local start_animation = self._ui_animator:start_animation(arg_11_1, self._widgets_by_name, scenegraph_definition, flag)
	local var_11_2 = arg_11_1

	self._animations[var_11_2] = start_animation

	return var_11_2
end
