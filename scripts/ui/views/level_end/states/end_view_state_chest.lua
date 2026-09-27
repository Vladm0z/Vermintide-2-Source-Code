-- chunkname: @scripts/ui/views/level_end/states/end_view_state_chest.lua

local var_0_0 = local_require("scripts/ui/views/level_end/states/definitions/end_view_state_chest_definitions")
local widgets = var_0_0.widgets
local score_entry_widgets = var_0_0.score_entry_widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local create_bar_divider = var_0_0.create_bar_divider
local flag = false
local num = 2
local num_2 = 0.8
local num_3 = 1
local num_4 = 2
local num_5 = 1
local tbl = {
	"loot_chest_jump",
	"loot_chest_jump_02"
}

EndViewStateChest = class(EndViewStateChest)
EndViewStateChest.NAME = "EndViewStateChest"
EndViewStateChest.CAN_SPEED_UP = true

EndViewStateChest.on_enter = function (self, arg_1_1)
	-- function 1
	print("[PlayState] Enter Substate EndViewStateChest")

	self.parent = arg_1_1.parent
	self.game_won = arg_1_1.game_won
	self.game_mode_key = arg_1_1.game_mode_key
	self.hero_name = arg_1_1.hero_name

	local context = arg_1_1.context

	self._context = context
	self.ui_renderer = context.ui_renderer
	self.ui_top_renderer = context.ui_top_renderer
	self.input_manager = context.input_manager
	self.statistics_db = context.statistics_db
	self.rewards = context.rewards
	self.render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = true
	}
	self._score_presentation_queue = {}
	self._total_score = 0
	self.wwise_world = context.wwise_world
	self.world_previewer = arg_1_1.world_previewer
	self.platform = PLATFORM
	self._animations = {}
	self._ui_animations = {}
	self._units = {}

	self:create_ui_elements(arg_1_1)
	self:_set_presentation_progress(0, true)

	if not arg_1_1.initial_state then
		self._initial_preview = true
		arg_1_1.initial_state = nil
	end

	self:_start_transition_animation("on_enter", "transition_enter")

	self._exit_timer = nil
	self.chest_settings = {
		{
			text = "Chest Tier 1",
			score_requirement = LootChestData.score_thresholds_per_chest[1],
			total_score = LootChestData.score_thresholds[1]
		},
		{
			text = "Chest Tier 2",
			score_requirement = LootChestData.score_thresholds_per_chest[2],
			total_score = LootChestData.score_thresholds[2]
		},
		{
			text = "Chest Tier 3",
			score_requirement = LootChestData.score_thresholds_per_chest[3],
			total_score = LootChestData.score_thresholds[3]
		},
		{
			text = "Chest Tier 4",
			score_requirement = LootChestData.score_thresholds_per_chest[4],
			total_score = LootChestData.score_thresholds[4]
		},
		{
			text = "Chest Tier 5",
			score_requirement = LootChestData.score_thresholds_per_chest[5],
			total_score = LootChestData.score_thresholds[5]
		},
		{
			text = "Chest Tier 6",
			score_requirement = LootChestData.score_thresholds_per_chest[6],
			total_score = LootChestData.score_thresholds[6]
		}
	}

	local difficulty = context.difficulty
	local var_1_2 = LootChestData.chests_by_category[difficulty]
	local chest_unit_names = var_1_2.chest_unit_names
	local display_names = var_1_2.display_names

	for i, v in ipairs(self.chest_settings) do
		v.unit_name = chest_unit_names[i]
		v.display_name = display_names[i]
	end

	self:_play_sound("play_gui_mission_summary_chest_uppgrade_amb_begin")
end

EndViewStateChest.exit = function (self, arg_2_1)
	-- function 2
	self._exit_started = true

	self:_start_transition_animation("on_enter", "transition_exit")
	self:_play_sound("play_gui_mission_summary_chest_uppgrade_amb_end")
end

EndViewStateChest.exit_done = function (self)
	-- function 3
	local _exit_started = self._exit_started

	_exit_started = not _exit_started and self._animations.on_enter == nil

	return _exit_started
end

EndViewStateChest.create_ui_elements = function (self, arg_4_1)
	-- function 4
	flag = false
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_4_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_4_2
		tbl_2[k] = var_4_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	local tbl_3 = {}

	for i, v_2 in ipairs(score_entry_widgets) do
		local var_4_4 = UIWidget.init(v_2)

		tbl_3[#tbl_3 + 1] = var_4_4
	end

	self._score_widgets = tbl_3
	self._divider_widgets = {}

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

	local score_entry_bg_left = tbl_2.score_entry_bg_left
	local score_entry_bg_right = tbl_2.score_entry_bg_right
	local score_entry_texture = tbl_2.score_entry_texture
	local texture_id = score_entry_bg_left.style.texture_id
	local texture_id_2 = score_entry_bg_right.style.texture_id
	local texture_id_3 = score_entry_texture.style.texture_id

	texture_id.color[1] = 0
	texture_id_2.color[1] = 0
	texture_id_3.color[1] = 0

	self:_initialize_score_topics()
end

EndViewStateChest._initialize_score_topics = function (self)
	-- function 5
	local _score_widgets = self._score_widgets
	local var_5_1 = UISettings.chest_upgrade_score_topics[self.game_mode_key]

	var_5_1 = var_5_1 or UISettings.chest_upgrade_score_topics.default
	self._num_score_topics = #var_5_1
	self._score_topics = {}

	local num = -10

	for i, v in ipairs(var_5_1) do
		local var_5_3 = _score_widgets[i]
		local name = v.name
		local texture = v.texture
		local display_name = v.display_name

		var_5_3.content.text = Localize(display_name)
		var_5_3.content.texture_id = texture
		var_5_3.content.texture_id_glow = texture .. "_glow"
		var_5_3.content.name = name

		local scenegraph_id = var_5_3.scenegraph_id
		local var_5_8 = scenegraph_definition[scenegraph_id].size[2]

		var_5_3.offset[2] = -(var_5_8 + num) * (i - 1)
		self._score_topics[#self._score_topics + 1] = name
	end
end

EndViewStateChest._wanted_state = function (self)
	-- function 6
	return (self.parent:wanted_menu_state())
end

EndViewStateChest.set_input_manager = function (self, arg_7_1)
	-- function 7
	self.input_manager = arg_7_1
end

EndViewStateChest.on_exit = function (self, arg_8_1)
	-- function 8
	print("[PlayState] Exit Substate EndViewStateChest")

	self.ui_animator = nil
end

EndViewStateChest._update_transition_timer = function (self, arg_9_1)
	-- function 9
	if not self._transition_timer then
		return
	end

	if self._transition_timer == 0 then
		self._transition_timer = nil
	else
		self._transition_timer = math.max(self._transition_timer - arg_9_1, 0)
	end

	local _units = self._units
	local _get_viewport_world = self:_get_viewport_world()

	for k, v in pairs(_units) do
		World.destroy_unit(_get_viewport_world, v)
	end

	table.clear(_units)
end

EndViewStateChest.update = function (self, arg_10_1, arg_10_2)
	-- function 10
	if not flag then
		flag = false

		local _units = self._units
		local _get_viewport_world = self:_get_viewport_world()

		if not _get_viewport_world then
			for k, v in pairs(_units) do
				World.destroy_unit(_get_viewport_world, v)
			end

			table.clear(_units)
		end

		self._current_chest_unit_name = nil
		self._spawned_chest_index = nil
		self._current_chest_enter_time = nil
		self._presentation_started = false
		self._entry_duration = 0
		self._current_entry_display_index = nil
		self._total_score = 0
		self._animations = {}
		self._ui_animations = {}
		self._score_entries = {}

		self:create_ui_elements()

		self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)
		self.chest_settings = {
			{
				text = "Chest Tier 1",
				score_requirement = LootChestData.score_thresholds_per_chest[1],
				total_score = LootChestData.score_thresholds[1]
			},
			{
				text = "Chest Tier 2",
				score_requirement = LootChestData.score_thresholds_per_chest[2],
				total_score = LootChestData.score_thresholds[2]
			},
			{
				text = "Chest Tier 3",
				score_requirement = LootChestData.score_thresholds_per_chest[3],
				total_score = LootChestData.score_thresholds[3]
			},
			{
				text = "Chest Tier 4",
				score_requirement = LootChestData.score_thresholds_per_chest[4],
				total_score = LootChestData.score_thresholds[4]
			},
			{
				text = "Chest Tier 5",
				score_requirement = LootChestData.score_thresholds_per_chest[5],
				total_score = LootChestData.score_thresholds[5]
			},
			{
				text = "Chest Tier 6",
				score_requirement = LootChestData.score_thresholds_per_chest[6],
				total_score = LootChestData.score_thresholds[6]
			}
		}

		local difficulty = self._context.difficulty
		local var_10_3 = LootChestData.chests_by_category[difficulty]
		local chest_unit_names = var_10_3.chest_unit_names
		local display_names = var_10_3.display_names

		for i, v_2 in ipairs(self.chest_settings) do
			v_2.unit_name = chest_unit_names[i]
			v_2.display_name = display_names[i]
		end
	end

	if not self._presentation_started then
		self:_start_presentation(arg_10_2)

		self._presentation_started = true
	end

	self:_animate_score_entries(arg_10_1, arg_10_2)

	local get_service = self.input_manager:get_service("end_of_level")

	if not self._exit_started then
		local _units_2 = self._units
		local _get_viewport_world_2 = self:_get_viewport_world()

		for k_2, v_3 in pairs(_units_2) do
			World.destroy_unit(_get_viewport_world_2, v_3)
		end

		table.clear(_units_2)
	end

	self:draw(get_service, arg_10_1)
	self:_update_transition_timer(arg_10_1)

	local _wanted_state = self:_wanted_state()

	if self._transition_timer or _wanted_state or not self._new_state then
		self.parent:clear_wanted_menu_state()

		return _wanted_state or self._new_state
	end

	self:_update_chest_zoom_wait_time(arg_10_1, arg_10_2)
	self:_update_chest_zoom_time(arg_10_1, arg_10_2)
	self:_update_chest_bonus_time(arg_10_1, arg_10_2)
	self:_update_chest_exit_time(arg_10_1, arg_10_2)

	if not (not self._ready_to_exit and self._exit_timer or self.parent:displaying_reward_presentation()) then
		self._exit_timer = 1.5
	end

	self:_update_current_chest_enter(arg_10_1, arg_10_2)
	self.ui_animator:update(arg_10_1)
	self:_update_animations(arg_10_1)
	self:_animate_score_progress(arg_10_1, arg_10_2)

	if not self._exit_timer then
		self._exit_timer = math.max(self._exit_timer - arg_10_1, 0)

		if self._exit_timer == 0 then
			self._score_entry_presentation_done = true
		end
	end

	if not (self.parent:transitioning() or self._transition_timer) then
		self:_handle_input(arg_10_1, arg_10_2)
	end
end

EndViewStateChest.post_update = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	return
end

EndViewStateChest._update_animations = function (self, arg_12_1)
	-- function 12
	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_12_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k_2, v_2 in pairs(_animations) do
		if not ui_animator:is_animation_completed(v_2) then
			ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end

	if not self.score_presentation_anim_id and not ui_animator:is_animation_completed(self.score_presentation_anim_id) then
		ui_animator:stop_animation(self.score_presentation_anim_id)

		self.score_presentation_anim_id = nil
	end
end

EndViewStateChest._handle_input = function (self, arg_13_1, arg_13_2)
	-- function 13
	local _widgets_by_name = self._widgets_by_name
end

EndViewStateChest.draw = function (self, arg_14_1, arg_14_2)
	-- function 14
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local render_settings = self.render_settings

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, arg_14_1, arg_14_2, nil, render_settings)

	local alpha_multiplier = render_settings.alpha_multiplier

	for i, v in ipairs(self._widgets) do
		if not v.alpha_multiplier then
			render_settings.alpha_multiplier = v.alpha_multiplier
		end

		UIRenderer.draw_widget(ui_renderer, v)

		render_settings.alpha_multiplier = alpha_multiplier
	end

	local _divider_widgets = self._divider_widgets

	if not _divider_widgets then
		for i_2, v_2 in ipairs(_divider_widgets) do
			UIRenderer.draw_widget(ui_renderer, v_2)
		end
	end

	local _num_score_topics = self._num_score_topics
	local _score_widgets = self._score_widgets

	if not _num_score_topics and not _score_widgets then
		for i4 = 1, _num_score_topics do
			local var_14_8 = _score_widgets[i4]

			UIRenderer.draw_widget(ui_renderer, var_14_8)
		end
	end

	UIRenderer.end_pass(ui_renderer)
end

EndViewStateChest._start_transition_animation = function (self, arg_15_1, arg_15_2)
	-- function 15
	local tbl = {
		wwise_world = self.wwise_world,
		render_settings = self.render_settings
	}
	local tbl_2 = {}
	local start_animation = self.ui_animator:start_animation(arg_15_2, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_15_1] = start_animation
end

EndViewStateChest._animate_element_by_time = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	-- function 16
	return (UIAnimation.init(UIAnimation.function_by_time, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, math.ease_out_quad))
end

EndViewStateChest._animate_element_by_catmullrom = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8)
	-- function 17
	return (UIAnimation.init(UIAnimation.catmullrom, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8))
end

EndViewStateChest.done = function (self)
	-- function 18
	return self._score_entry_presentation_done
end

EndViewStateChest._set_entry_text_progress = function (self, arg_19_1)
	-- function 19
	local num = 1 - arg_19_1
	local num_2 = (-4 * (arg_19_1 - 0.5) * (arg_19_1 - 0.5) + 1) * 0.5
	local score_entry_texture = scenegraph_definition.score_entry_texture

	self.ui_scenegraph.score_entry_texture.local_position[1] = score_entry_texture.position[1] + 200 * arg_19_1

	local num_3 = num_2 * 255
	local _widgets_by_name = self._widgets_by_name
	local score_entry_texture_2 = _widgets_by_name.score_entry_texture

	_widgets_by_name.score_entry_text.style.text.text_color[1] = num_3
	score_entry_texture_2.style.texture_id.color[1] = num_3
end

EndViewStateChest._display_chest_by_settings_index = function (self, arg_20_1, arg_20_2, arg_20_3)
	-- function 20
	local var_20_0 = self.chest_settings[arg_20_1]
	local unit_name = var_20_0.unit_name
	local display_name = var_20_0.display_name
	local _spawn_chest_unit = self:_spawn_chest_unit(unit_name, arg_20_3, arg_20_2)

	self._units[unit_name] = _spawn_chest_unit

	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.chest_title.content.text = Localize(display_name)
	_widgets_by_name.chest_sub_title.content.text = Localize("loot_chest")

	local str = "chest_title_update"

	if not arg_20_3 then
		str = "chest_title_initialize"

		local difficulty = self._context.difficulty
		local str_2 = "play_gui_chest_appear_" .. difficulty .. "_" .. tostring(arg_20_1)

		self:_play_sound(str_2)
	else
		self:_play_sound("play_gui_mission_summary_chest_upgrade")
	end

	self.ui_animator:start_animation(str, self._widgets_by_name, scenegraph_definition, {
		wwise_world = self.wwise_world
	})
end

EndViewStateChest._spawn_chest_unit = function (self, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	if not self._current_chest_unit_name then
		self._current_chest_enter_time = arg_21_3 + 0.5

		local var_21_0 = self._units[self._current_chest_unit_name]

		Unit.flow_event(var_21_0, "loot_chest_upgrade_out")
	end

	local _get_viewport_world = self:_get_viewport_world()
	local spawn_unit = World.spawn_unit(_get_viewport_world, arg_21_1)

	Unit.set_unit_visibility(spawn_unit, arg_21_2 == true)

	local get_world_link_unit = self.parent:get_world_link_unit()

	World.link_unit(_get_viewport_world, spawn_unit, 0, get_world_link_unit, 0)

	if not arg_21_2 then
		local str = "loot_chest_enter"

		Unit.flow_event(spawn_unit, str)
		self.parent:set_camera_zoom(0)
		self:_set_bar_alpha_by_progress(1)
	else
		self.parent:add_camera_shake(nil, arg_21_3, nil)
	end

	self._current_chest_unit_name = arg_21_1

	return spawn_unit
end

EndViewStateChest._update_current_chest_enter = function (self, arg_22_1, arg_22_2)
	-- function 22
	if not self._current_chest_enter_time then
		return
	end

	if arg_22_2 >= self._current_chest_enter_time then
		self._current_chest_enter_time = nil

		if not self._current_chest_unit_name then
			local var_22_0 = self._units[self._current_chest_unit_name]

			Unit.set_unit_visibility(var_22_0, true)
			Unit.flow_event(var_22_0, "loot_chest_upgrade_in")
		end
	end
end

EndViewStateChest._trigger_unit_flow_event = function (arg_23_0, arg_23_1, arg_23_2)
	-- function 23
	if not arg_23_1 and not Unit.alive(arg_23_1) then
		Unit.flow_event(arg_23_1, arg_23_2)
	end
end

EndViewStateChest._get_viewport_world = function (self)
	-- function 24
	return self.parent:get_viewport_world()
end

EndViewStateChest._start_presentation = function (self, arg_25_1)
	-- function 25
	local flag = true
	local num_2 = 1

	self._spawned_chest_index = num_2

	self:_display_chest_by_settings_index(num_2, arg_25_1, flag)

	local num_3 = 0
	local score_breakdown = self._context.rewards.end_of_level_rewards.chest.score_breakdown

	for i, v in ipairs(self._score_topics) do
		local var_25_4 = score_breakdown[v]

		if not (not var_25_4 and not (var_25_4.score > 0)) then
			local score = var_25_4.score
			local amount = var_25_4.amount

			self:_add_score({
				id = num_3,
				score = score,
				name = v,
				amount = amount
			})

			num_3 = num_3 + 1
		end
	end

	if num_3 == 0 then
		self._chest_zoom_wait_duration = num
	end
end

EndViewStateChest._add_score = function (self, arg_26_1)
	-- function 26
	if arg_26_1.score == 0 then
		return
	end

	local _score_widgets = self._score_widgets
	local _score_entries = self._score_entries

	_score_entries = _score_entries or {}
	self._score_entries = _score_entries

	local var_26_2

	for i, v in ipairs(_score_widgets) do
		if v.content.name == arg_26_1.name then
			var_26_2 = v

			break
		end
	end

	local num = #self._score_entries + 1
	local tbl = {
		entry_animation_completed = false,
		entry_index = num,
		data = arg_26_1,
		widget = var_26_2,
		wwise_world = self.wwise_world
	}

	self._score_entries[num] = tbl

	local amount = arg_26_1.amount

	if not amount then
		var_26_2.content.text = var_26_2.content.text .. "\n x" .. tostring(amount)
	end
end

EndViewStateChest._animate_score_entries = function (self, arg_27_1)
	-- function 27
	local _score_entries = self._score_entries

	if not _score_entries and not _score_entries.complete then
		return
	end

	local ui_animator = self.ui_animator
	local str = "score_entry_add"
	local str_2 = "summary_entry_text_shadow"
	local flag = true

	for i, v in ipairs(_score_entries) do
		if not v.entry_animation_completed then
			if not self.score_entry_enter_anim_id then
				self.score_entry_enter_anim_id = self.ui_animator:start_animation(str, self._widgets_by_name, scenegraph_definition, v)
			elseif not ui_animator:is_animation_completed(self.score_entry_enter_anim_id) then
				ui_animator:stop_animation(self.score_entry_enter_anim_id)

				self.score_entry_enter_anim_id = nil
				v.entry_animation_completed = true
			end

			flag = false
		end
	end

	_score_entries.complete = flag

	if not flag and not self._score_widgets then
		self:_display_next_score_entry()
	end
end

EndViewStateChest._display_next_score_entry = function (self)
	-- function 28
	local _score_entries = self._score_entries
	local _current_entry_display_index = self._current_entry_display_index

	_current_entry_display_index = _current_entry_display_index or 0
	self._current_entry_display_index = _current_entry_display_index + 1

	local var_28_2 = _score_entries[self._current_entry_display_index]

	self.score_presentation_anim_id = self.ui_animator:start_animation("score_presentation_start", self._widgets_by_name, scenegraph_definition, var_28_2)
	self._current_entry_data = var_28_2.data
	self._entry_duration = 0
end

EndViewStateChest._start_entry_animation = function (self, arg_29_1)
	-- function 29
	local tbl = {
		wwise_world = self.wwise_world,
		render_settings = self.render_settings
	}
	local _widgets_by_name = self._widgets_by_name
	local start_animation = self.ui_animator:start_animation("score_entry", _widgets_by_name, scenegraph_definition, tbl)

	self._animations[arg_29_1] = start_animation
end

EndViewStateChest._animate_score_progress = function (self, arg_30_1, arg_30_2)
	-- function 30
	local _entry_duration = self._entry_duration
	local _current_chest_enter_time = self._current_chest_enter_time

	if not _entry_duration and _current_chest_enter_time or self.score_entry_enter_anim_id or not self.score_presentation_anim_id then
		return
	end

	local count = #self.chest_settings
	local _score_entries = self._score_entries
	local _current_entry_display_index = self._current_entry_display_index
	local var_30_5 = _score_entries[_current_entry_display_index]
	local data = var_30_5.data
	local max_score = LootChestData.max_score
	local _total_score = self._total_score

	_total_score = _total_score or 0

	local num_2 = max_score - _total_score
	local score = data.score
	local clamp = math.clamp(data.score, 0, max_score - _total_score)
	local chest_upgrade_score_topics_min_duration = UISettings.chest_upgrade_score_topics_min_duration

	chest_upgrade_score_topics_min_duration = chest_upgrade_score_topics_min_duration or 0.5

	local chest_upgrade_score_topics_max_duration = UISettings.chest_upgrade_score_topics_max_duration

	chest_upgrade_score_topics_max_duration = chest_upgrade_score_topics_max_duration or 7

	local min

	if num_2 > 0 then
		min = math.min(clamp / num_2, 1)

		if not min then
			-- Nothing
		end
	end

	min = 0

	::label_30_0::

	local clamp_2 = math.clamp(min * chest_upgrade_score_topics_max_duration, chest_upgrade_score_topics_min_duration, chest_upgrade_score_topics_max_duration)
	local min_2 = math.min(_entry_duration + arg_30_1, clamp_2)
	local num_3 = min_2 / clamp_2
	local num_4 = 0.5 * (LootChestData.score_per_chest / score)
	local easeOutCubic = math.easeOutCubic(num_3)
	local num_5 = clamp * easeOutCubic
	local min_3 = math.min(_total_score + num_5, max_score)
	local flag = min_3 == max_score

	if not flag then
		easeOutCubic = 1
	end

	local _get_chest_settings_by_total_score, var_30_24 = self:_get_chest_settings_by_total_score(min_3)
	local num_6 = 0

	if not (not flag and count > self._spawned_chest_index and not var_30_24 or var_30_24 - 1 ~= self._spawned_chest_index) then
		num_6 = 1

		local flag_2 = not flag and count and var_30_24 - 1

		self._spawned_chest_index = flag_2

		self:_display_chest_by_settings_index(flag_2, arg_30_2)
	elseif not _get_chest_settings_by_total_score then
		local total_score = _get_chest_settings_by_total_score.total_score
		local score_requirement = _get_chest_settings_by_total_score.score_requirement

		num_6 = (min_3 - (total_score - score_requirement)) / score_requirement
	else
		num_6 = 1
	end

	WwiseWorld.set_global_parameter(self.wwise_world, "chest_upgrade_progress", easeOutCubic)

	if not (self._upgrade_sound_started or not (easeOutCubic < 1)) then
		WwiseWorld.trigger_event(self.wwise_world, "play_gui_mission_summary_chest_upgrade_meter_begin")

		self._upgrade_sound_started = true
	end

	if num_6 == 1 or easeOutCubic == 1 or not self._upgrade_sound_started then
		WwiseWorld.trigger_event(self.wwise_world, "play_gui_mission_summary_chest_upgrade_meter_end")

		self._upgrade_sound_started = false
	end

	if easeOutCubic == 1 then
		self._entry_duration = nil

		local min_4 = math.min
		local _total_score_2 = self._total_score

		_total_score_2 = _total_score_2 or 0
		self._total_score = min_4(_total_score_2 + clamp, max_score)

		if _current_entry_display_index == #_score_entries then
			local flag_3

			flag_3 = not (num_6 == 1) and 0 and num
			self._chest_zoom_wait_duration = flag_3
		else
			self:_display_next_score_entry()
		end

		self._current_bar_total_score_progress = num_6

		self.ui_animator:start_animation("score_presentation_end", self._widgets_by_name, scenegraph_definition, var_30_5)
	else
		if not (not self._current_bar_total_score_progress and not (num_6 < self._current_bar_total_score_progress)) then
			num_6 = 0
			self._current_bar_total_score_progress = nil
		end

		self._entry_duration = min_2
	end

	self:_set_presentation_progress(num_6)
end

EndViewStateChest._get_chest_settings_by_total_score = function (self, arg_31_1)
	-- function 31
	for i, v in ipairs(self.chest_settings) do
		if arg_31_1 < v.total_score then
			return v, i
		end
	end
end

EndViewStateChest._set_presentation_progress = function (self, arg_32_1, arg_32_2)
	-- function 32
	local score_bar = self._widgets_by_name.score_bar
	local texture_id = score_bar.content.texture_id
	local texture_id_2 = score_bar.style.texture_id
	local scenegraph_id = score_bar.scenegraph_id
	local var_32_4 = self.ui_scenegraph[scenegraph_id]
	local size = scenegraph_definition[scenegraph_id].size

	var_32_4.size[1] = math.ceil(size[1] * arg_32_1)

	if not arg_32_2 then
		WwiseWorld.set_global_parameter(self.wwise_world, "summary_meter_progress", arg_32_1)
	end
end

EndViewStateChest._update_chest_zoom_wait_time = function (self, arg_33_1, arg_33_2)
	-- function 33
	local _chest_zoom_wait_duration = self._chest_zoom_wait_duration

	if not _chest_zoom_wait_duration then
		return
	end

	local num_2 = _chest_zoom_wait_duration + arg_33_1

	if math.min(num_2 / num, 1) == 1 then
		self._chest_zoom_wait_duration = nil
		self._chest_zoom_duration = 0
	else
		self._chest_zoom_wait_duration = num_2
	end
end

EndViewStateChest._update_chest_zoom_time = function (self, arg_34_1, arg_34_2)
	-- function 34
	local _chest_zoom_duration = self._chest_zoom_duration

	if not _chest_zoom_duration then
		return
	end

	local num = _chest_zoom_duration + arg_34_1
	local min = math.min(num / num_2, 1)
	local easeOutCubic = math.easeOutCubic(min)

	self.parent:set_camera_zoom(easeOutCubic)

	if min == 1 then
		self._chest_zoom_duration = nil
		self._chest_wait_exit_duration = 0
	else
		self._chest_zoom_duration = num
	end
end

EndViewStateChest._update_chest_bonus_time = function (self, arg_35_1, arg_35_2)
	-- function 35
	local _chest_bonus_duration = self._chest_bonus_duration

	if not _chest_bonus_duration then
		return
	end

	local num = _chest_bonus_duration + arg_35_1

	if math.min(num / num_4, 1) == 1 then
		self._chest_bonus_duration = nil
		self._chest_wait_exit_duration = 0
	else
		self._chest_bonus_duration = num
	end
end

EndViewStateChest._update_chest_exit_time = function (self, arg_36_1, arg_36_2)
	-- function 36
	local _chest_wait_exit_duration = self._chest_wait_exit_duration

	if not _chest_wait_exit_duration then
		return
	end

	local num = _chest_wait_exit_duration + arg_36_1

	if math.min(num / num_5, 1) == 1 then
		self.parent:present_chest_rewards()

		self._ready_to_exit = true
		self._chest_wait_exit_duration = nil
	else
		self._chest_wait_exit_duration = num
	end
end

EndViewStateChest._set_bar_alpha_by_progress = function (self, arg_37_1)
	-- function 37
	local _widgets_by_name = self._widgets_by_name
	local bar_bg = _widgets_by_name.bar_bg
	local score_bar = _widgets_by_name.score_bar
	local score_bar_fg = _widgets_by_name.score_bar_fg

	bar_bg.alpha_multiplier = arg_37_1
	score_bar.alpha_multiplier = arg_37_1
	score_bar_fg.alpha_multiplier = arg_37_1
end

EndViewStateChest._play_sound = function (self, arg_38_1)
	-- function 38
	self.parent:play_sound(arg_38_1)
end
