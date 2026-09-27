-- chunkname: @scripts/ui/hud_ui/difficulty_unlock_ui.lua

require("scripts/settings/difficulty_settings")

local var_0_0 = local_require("scripts/ui/hud_ui/difficulty_unlock_ui_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local animations = var_0_0.animations
local SurvivalStartWaveByDifficulty = SurvivalStartWaveByDifficulty

DifficultyUnlockUI = class(DifficultyUnlockUI)

local flag = false

DifficultyUnlockUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self.ui_renderer = arg_1_2.ui_renderer
	self.ingame_ui = arg_1_2.ingame_ui
	self.input_manager = arg_1_2.input_manager
	self.world = arg_1_2.world_manager:world("level_world")
	self.wwise_world = Managers.world:wwise_world(self.world)
	self.difficulty_manager = Managers.state.difficulty
	self.statistics_db = arg_1_2.statistics_db
	self.ui_animations = {}

	self:create_ui_elements()
	self:difficulty_set()
	Managers.state.event:register(self, "difficulty_synced", "difficulty_set")
end

DifficultyUnlockUI.create_ui_elements = function (self)
	-- function 2
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local widget_definitions = var_0_0.widget_definitions
	local tbl = {}

	for i = 1, 5 do
		local str = "difficulty_icon_" .. i

		tbl[i] = UIWidget.init(widget_definitions[str])
	end

	self.icon_widgets = tbl
	self.background_top_widget = UIWidget.init(widget_definitions.background_top)
	self.background_center_widget = UIWidget.init(widget_definitions.background_center)
	self.background_bottom_widget = UIWidget.init(widget_definitions.background_bottom)
	self.background_glow_widget = UIWidget.init(widget_definitions.background_glow)
	self.difficulty_text_widget = UIWidget.init(widget_definitions.difficulty_text)
	self.difficulty_title_text_widget = UIWidget.init(widget_definitions.difficulty_title_text)

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animations)
	self.is_visible = true
end

DifficultyUnlockUI.difficulty_set = function (self)
	-- function 3
	local statistics_db = self.statistics_db
	local stats_id = Managers.player:local_player():stats_id()
	local level_key = Managers.state.game_mode:level_key()
	local var_3_3 = LevelSettings[level_key]
	local get_default_difficulties = self.difficulty_manager:get_default_difficulties()
	local mirror_table = table.mirror_table(get_default_difficulties)
	local get_difficulty = self.difficulty_manager:get_difficulty()
	local find = table.find(mirror_table, get_difficulty)
	local completed_level_difficulty_index = LevelUnlockUtils.completed_level_difficulty_index(statistics_db, stats_id, level_key)

	completed_level_difficulty_index = completed_level_difficulty_index or 0

	local num = completed_level_difficulty_index + 1

	if not (not find and get_difficulty == get_default_difficulties[#get_default_difficulties]) then
		local var_3_10 = SurvivalStartWaveByDifficulty[get_difficulty]
		local tbl = {}
		local tbl_2 = {}

		for i = find, #get_default_difficulties do
			local var_3_13 = get_default_difficulties[i]

			if not (var_3_13 == get_difficulty or not (num < i)) then
				local var_3_14 = SurvivalStartWaveByDifficulty[var_3_13]

				tbl[#tbl + 1] = var_3_14 - var_3_10
				tbl_2[#tbl_2 + 1] = var_3_13
			end
		end

		self.next_presentation_wave = tbl[1]
		self.persentation_wave_list = tbl
		self.persentation_wave_difficulty_list = tbl_2
	end
end

DifficultyUnlockUI.align_icon_widgets = function (self)
	-- function 4
	local icon_draw_count = self.icon_draw_count
	local icon_widgets = self.icon_widgets
	local num = 50
	local num_2 = -(icon_draw_count / 2 * num) + num * 0.5

	if not icon_widgets then
		local ui_scenegraph = self.ui_scenegraph
		local num_3 = 0

		for i = 1, icon_draw_count do
			local var_4_6 = icon_widgets[i]

			ui_scenegraph[var_4_6.scenegraph_id].local_position[1] = num_2
			num_2 = num_2 + num
			var_4_6.element.dirty = true
		end
	end
end

DifficultyUnlockUI.destroy = function (self)
	-- function 5
	self.ui_animator = nil

	self:set_visible(false)
end

DifficultyUnlockUI.set_visible = function (self, arg_6_1)
	-- function 6
	self.is_visible = arg_6_1

	local ui_renderer = self.ui_renderer
	local icon_widgets = self.icon_widgets

	if not icon_widgets then
		for i, v in ipairs(icon_widgets) do
			UIRenderer.set_element_visible(ui_renderer, v.element, arg_6_1)
		end
	end
end

DifficultyUnlockUI._check_for_presentation_start = function (self, arg_7_1)
	-- function 7
	local previous_wave_completed = self.previous_wave_completed

	previous_wave_completed = previous_wave_completed or 0

	local num = arg_7_1.wave_completed - arg_7_1.starting_wave

	if num <= previous_wave_completed then
		return
	end

	if self.next_presentation_wave == num then
		table.remove(self.persentation_wave_list, 1)

		self.next_presentation_wave = self.persentation_wave_list[1]
		self.display_presentation_difficulty = self.persentation_wave_difficulty_list[1]

		table.remove(self.persentation_wave_difficulty_list, 1)

		self.presentation_start_time = 0
	end

	self.previous_wave_completed = num
end

DifficultyUnlockUI._update_start_timer = function (self, arg_8_1)
	-- function 8
	local presentation_start_time = self.presentation_start_time

	if not presentation_start_time then
		local num = 10

		if presentation_start_time == num then
			self:display_unlock(nil, self.display_presentation_difficulty)

			self.display_presentation_difficulty = nil
			presentation_start_time = nil
		else
			presentation_start_time = math.min(presentation_start_time + arg_8_1, num)
		end

		self.presentation_start_time = presentation_start_time
	end
end

DifficultyUnlockUI.update = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	if not self.next_presentation_wave then
		self:_check_for_presentation_start(arg_9_2)
	end

	self:_update_start_timer(arg_9_1)

	if not (not self.is_visible and self.draw_widgets) then
		return
	end

	local var_9_0
	local ui_animations = self.ui_animations

	if not ui_animations then
		for k, v in pairs(ui_animations) do
			var_9_0 = true

			UIAnimation.update(v, arg_9_1)

			if not UIAnimation.completed(v) then
				self.ui_animations[k] = nil
			end
		end
	end

	local ui_animator = self.ui_animator

	ui_animator:update(arg_9_1)

	local presentation_anim_id = self.presentation_anim_id

	if not presentation_anim_id then
		if not ui_animator:is_animation_completed(presentation_anim_id) then
			ui_animator:stop_animation(presentation_anim_id)

			self.presentation_anim_id = nil

			self:start_explode_animation()
		end

		var_9_0 = true
	end

	local explode_anim_id = self.explode_anim_id

	if not explode_anim_id then
		if not ui_animator:is_animation_completed(explode_anim_id) then
			ui_animator:stop_animation(explode_anim_id)

			self.explode_anim_id = nil

			self:on_presentation_complete()
		end

		var_9_0 = true
	end

	if var_9_0 or not RESOLUTION_LOOKUP.modified then
		var_9_0 = true
	end

	if not var_9_0 then
		local icon_widgets = self.icon_widgets

		if not icon_widgets then
			for i, v_2 in ipairs(icon_widgets) do
				v_2.element.dirty = true
			end
		end
	end

	self:draw(arg_9_1)
end

DifficultyUnlockUI.draw = function (self, arg_10_1)
	-- function 10
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("ingame_menu")

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_10_1)

	local icon_draw_count = self.icon_draw_count

	if not icon_draw_count then
		local icon_widgets = self.icon_widgets

		if not icon_widgets then
			for i = 1, icon_draw_count do
				local var_10_5 = icon_widgets[i]

				UIRenderer.draw_widget(ui_renderer, var_10_5)
			end
		end
	end

	UIRenderer.draw_widget(ui_renderer, self.background_top_widget)
	UIRenderer.draw_widget(ui_renderer, self.background_center_widget)
	UIRenderer.draw_widget(ui_renderer, self.background_bottom_widget)
	UIRenderer.draw_widget(ui_renderer, self.background_glow_widget)
	UIRenderer.draw_widget(ui_renderer, self.difficulty_text_widget)
	UIRenderer.draw_widget(ui_renderer, self.difficulty_title_text_widget)
	UIRenderer.end_pass(ui_renderer)
end

DifficultyUnlockUI.set_difficulty_amount = function (self, arg_11_1)
	-- function 11
	self.icon_draw_count = arg_11_1

	self:align_icon_widgets()
end

DifficultyUnlockUI.display_unlock = function (self, arg_12_1, arg_12_2)
	-- function 12
	local var_12_0 = DifficultySettings[arg_12_2]
	local rank = var_12_0.rank
	local display_name = var_12_0.display_name

	self.difficulty_text_widget.content.text = display_name

	self:set_difficulty_amount(rank)
	self:start_presentation_animation()

	self.draw_widgets = true
end

DifficultyUnlockUI.on_presentation_complete = function (self)
	-- function 13
	self.draw_widgets = false
end

DifficultyUnlockUI.start_presentation_animation = function (self)
	-- function 14
	local tbl = {
		wwise_world = self.wwise_world
	}
	local tbl_2 = {}
	local icon_draw_count = self.icon_draw_count
	local icon_widgets = self.icon_widgets
	local tbl_3 = {}

	for i = 1, icon_draw_count do
		tbl_3[i] = icon_widgets[i]
	end

	tbl_2.icons = tbl_3
	tbl_2.background_top = self.background_top_widget
	tbl_2.background_center = self.background_center_widget
	tbl_2.background_bottom = self.background_bottom_widget
	tbl_2.background_glow = self.background_glow_widget
	tbl_2.difficulty_text = self.difficulty_text_widget
	tbl_2.difficulty_title_text = self.difficulty_title_text_widget
	self.presentation_anim_id = self.ui_animator:start_animation("presentation", tbl_2, scenegraph_definition, tbl)
end

DifficultyUnlockUI.start_explode_animation = function (self)
	-- function 15
	local tbl = {
		wwise_world = self.wwise_world
	}
	local tbl_2 = {}
	local icon_draw_count = self.icon_draw_count
	local icon_widgets = self.icon_widgets
	local tbl_3 = {}

	for i = 1, icon_draw_count do
		tbl_3[i] = icon_widgets[i]
	end

	tbl_2.icons = tbl_3
	tbl_2.background_top = self.background_top_widget
	tbl_2.background_center = self.background_center_widget
	tbl_2.background_bottom = self.background_bottom_widget
	tbl_2.background_glow = self.background_glow_widget
	tbl_2.difficulty_text = self.difficulty_text_widget
	tbl_2.difficulty_title_text = self.difficulty_title_text_widget

	local flag

	flag = icon_draw_count ~= 4 or not "explode_parts_4" or "explode_parts_5"
	self.explode_anim_id = self.ui_animator:start_animation(flag, tbl_2, scenegraph_definition, tbl)
end
