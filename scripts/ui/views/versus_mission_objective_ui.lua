-- chunkname: @scripts/ui/views/versus_mission_objective_ui.lua

local var_0_0 = local_require("scripts/ui/views/versus_mission_objective_ui_definitions")
local carousel = DLCSettings.carousel
local animation_definitions = var_0_0.animation_definitions
local scenegraph_definition = var_0_0.scenegraph_definition
local side_colors = var_0_0.side_colors
local num = 0.8
local num_2 = 3
local num_3 = 120
local num_4 = 1
local flag = false
local tbl = {
	"rpc_update_start_round_countdown_timer",
	"rpc_ui_round_started"
}

VersusMissionObjectiveUI = class(VersusMissionObjectiveUI)

VersusMissionObjectiveUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	local game_mode = Managers.state.game_mode:game_mode()

	self._active = Managers.state.game_mode:game_mode_key() ~= "versus" or not game_mode:in_training_mode()

	if not self._active then
		return
	end

	self._parent = arg_1_1
	self._ingame_ui_context = arg_1_2
	self._ui_renderer = arg_1_2.ui_renderer
	self._input_manager = arg_1_2.input_manager

	local world = arg_1_2.world_manager:world("level_world")

	self._world = world
	self._wwise_world = Managers.world:wwise_world(world)
	self._animations = {}
	self._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	self._world_markers = {}
	self._selected_objective_index = 0
	self._objectives_widgets = {}

	self:_create_ui_elements()

	self._round_started = false
	self._objective_system = Managers.state.entity:system("objective_system")
	self._objectives_initialized = false

	self:_register_rpcs()
	self:_register_events()

	local mechanism_try_call, var_1_3, var_1_4 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", "round_time_limit")

	if not var_1_4 and not var_1_3 then
		self._custom_round_timer_active = true
	end

	self._win_conditions = Managers.mechanism:game_mechanism():win_conditions()

	local flag

	flag = Managers.state.game_mode:game_mode():game_mode_state() ~= "match_running_state" or not true or nil

	if not flag then
		self:_on_round_started()
	end

	self._round_has_started = flag
end

VersusMissionObjectiveUI._register_rpcs = function (self)
	-- function 2
	self._ingame_ui_context.network_event_delegate:register(self, unpack(tbl))
end

VersusMissionObjectiveUI._unregister_rpcs = function (self)
	-- function 3
	self._ingame_ui_context.network_event_delegate:unregister(self)
end

VersusMissionObjectiveUI._is_dark_pact = function (self)
	-- function 4
	local _get_local_player_party_id = self:_get_local_player_party_id()
	local get_party = Managers.party:get_party(_get_local_player_party_id)
	local var_4_2 = Managers.state.side.side_by_party[get_party]

	return not var_4_2 and var_4_2:name() == "dark_pact"
end

VersusMissionObjectiveUI._start_transition_animation = function (self, arg_5_1, arg_5_2)
	-- function 5
	local tbl = {
		wwise_world = self._wwise_world,
		render_settings = self._render_settings
	}
	local _widgets_by_name = self._widgets_by_name
	local start_animation = self._ui_animator:start_animation(arg_5_2, _widgets_by_name, scenegraph_definition, tbl)

	self._animations[arg_5_1] = start_animation
end

VersusMissionObjectiveUI._create_ui_elements = function (self)
	-- function 6
	self._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}
	local widget_definitions = var_0_0.widget_definitions

	for k, v in pairs(widget_definitions) do
		local var_6_3 = UIWidget.init(v)

		tbl_2[k] = var_6_3
		tbl[#tbl + 1] = var_6_3
	end

	self._objective_text_widget = UIWidget.init(var_0_0.objective_text)
	self._widgets_by_name = tbl_2
	self._widgets = tbl
	self._objective_text_widget.content.visible = false
	flag = false

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)
end

VersusMissionObjectiveUI.destroy = function (self)
	-- function 7
	self:_unregister_rpcs()
	self:_unregister_events()

	self._ui_animator = nil
end

VersusMissionObjectiveUI.update = function (self, arg_8_1, arg_8_2)
	-- function 8
	if not flag then
		self:_create_ui_elements()
	end

	if not self._active then
		self:_update_round_start_timer(arg_8_1, arg_8_2)
		self:_update_objectives(arg_8_1, arg_8_2)
		self:_update_animations(arg_8_1, arg_8_2)
		self:_update_score()
		self:_draw(arg_8_1)
	end
end

VersusMissionObjectiveUI._update_objectives = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not self._objective_system:is_active() then
		return
	end

	self:_update_world_markers(arg_9_1, arg_9_2)

	if not self._objectives_initialized then
		local _get_local_player_party_id = self:_get_local_player_party_id()
		local flag = self:_get_party_side_name(_get_local_player_party_id) == "heroes"

		self._num_main_objective = self._objective_system:num_main_objectives()

		self:_set_active_scoring_side_color(flag)

		self._objectives_initialized = true
	end

	local current_objective_index = self._objective_system:current_objective_index()
	local num_completed_main_objectives = self._objective_system:num_completed_main_objectives()

	if current_objective_index > self._selected_objective_index then
		self._selected_objective_index = current_objective_index

		self:_update_current_objective(current_objective_index)

		local str = "n/a"

		if not self:_is_dark_pact() then
			local first_active_objective_description = self._objective_system:first_active_objective_description()

			self:_set_objective_text(first_active_objective_description)

			local tbl = {
				render_settings = self._render_settings
			}
			local _objective_text_widget = self._objective_text_widget

			self._ui_animator:start_animation("mission_start", _objective_text_widget, scenegraph_definition, tbl)
		else
			local var_9_8 = Localize("level_objective_pactsworn")

			self:_set_objective_text(var_9_8)
		end
	end

	self:_update_objective_progress()
end

VersusMissionObjectiveUI._set_active_scoring_side_color = function (self, arg_10_1)
	-- function 10
	local get_color_table_with_alpha

	if not arg_10_1 then
		get_color_table_with_alpha = Colors.get_color_table_with_alpha("local_player_team_lighter", 255)

		if not get_color_table_with_alpha then
			-- Nothing
		end
	end

	get_color_table_with_alpha = Colors.get_color_table_with_alpha("opponent_team_lighter", 255)

	::label_10_0::

	local objective = self._widgets_by_name.objective

	objective.content.is_hero = arg_10_1
	objective.style.progress_bar.color = get_color_table_with_alpha
	objective.style.objective_icon.color = get_color_table_with_alpha
end

VersusMissionObjectiveUI._update_current_objective = function (self)
	-- function 11
	local objective = self._widgets_by_name.objective
	local current_objective_icon = self._objective_system:current_objective_icon()

	objective.content.objective_icon = current_objective_icon
end

VersusMissionObjectiveUI._update_objective_status = function (self, arg_12_1)
	-- function 12
	if not self._objectives_widgets then
		for i = 1, #self._objectives_widgets do
			local flag = i == arg_12_1
			local flag_2 = i < arg_12_1
			local flag_3 = arg_12_1 < i
			local var_12_3 = self._objectives_widgets[i]
			local style = var_12_3.style
			local content = var_12_3.content
			local current_objective_progress

			if not flag then
				current_objective_progress = self._objective_system:current_objective_progress()

				if not current_objective_progress then
					-- Nothing
				end
			end

			current_objective_progress = 0

			::label_12_0::

			content.objective_progress = current_objective_progress
			content.current_objective = flag
			content.is_inactive = flag_3
			content.completed = flag_2
		end
	end
end

VersusMissionObjectiveUI._set_round_text = function (self)
	-- function 13
	local content = self._widgets_by_name.round_text.content
	local _get_round_count = self:_get_round_count()

	content.text = string.format("Round: %d", _get_round_count)
end

VersusMissionObjectiveUI._get_round_count = function (arg_14_0)
	-- function 14
	return (Managers.mechanism:game_mechanism():win_conditions():get_current_round())
end

VersusMissionObjectiveUI._update_score = function (self)
	-- function 15
	local _get_local_player_party_id = self:_get_local_player_party_id()
	local _get_opponent_party_id = self:_get_opponent_party_id()
	local objective = self._widgets_by_name.objective

	objective.content.team_1_score = self._win_conditions:get_total_score(_get_local_player_party_id)
	objective.content.team_2_score = self._win_conditions:get_total_score(_get_opponent_party_id)
end

VersusMissionObjectiveUI._get_party_side_name = function (arg_16_0, arg_16_1)
	-- function 16
	local get_party = Managers.party:get_party(arg_16_1)

	return (Managers.state.side.side_by_party[get_party]:name())
end

VersusMissionObjectiveUI._get_local_player_party_id = function (arg_17_0)
	-- function 17
	local peer_id = Network.peer_id()
	local party = Managers.party
	local num = 1

	return party:get_player_status(peer_id, num).party_id
end

VersusMissionObjectiveUI._get_opponent_party_id = function (self)
	-- function 18
	local flag

	flag = self:_get_local_player_party_id() ~= 1 or not 2 or 1

	return flag
end

VersusMissionObjectiveUI._reset_timer_size = function (self)
	-- function 19
	local style = self._widgets_by_name.timer_text.style
	local default_font_size = style.text.default_font_size

	style.text.font_size = default_font_size
	style.text_shadow.font_size = default_font_size
end

VersusMissionObjectiveUI._set_objective_bar_end = function (arg_20_0, arg_20_1)
	-- function 20
	arg_20_0._widgets_by_name.progress_bar.content.disabled_progress_bar = arg_20_1
end

VersusMissionObjectiveUI._play_sound = function (self, arg_21_1)
	-- function 21
	WwiseWorld.trigger_event(self._wwise_world, arg_21_1)
end

VersusMissionObjectiveUI._update_animations = function (self, arg_22_1, arg_22_2)
	-- function 22
	local _animations = self._animations
	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_22_1)

	for k, v in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v) then
			_ui_animator:stop_animation(v)

			_animations[k] = nil

			if k == "announcement" then
				self._bonus_time_timer = num_4
			end
		end
	end
end

VersusMissionObjectiveUI._update_round_start_timer = function (self, arg_23_1, arg_23_2)
	-- function 23
	if not self._round_has_started then
		return
	end

	if not (not self._countdown_timer and not (self._countdown_timer <= 0)) then
		self:_set_round_starting_text()
	end
end

VersusMissionObjectiveUI._set_pre_round_timer = function (self, arg_24_1)
	-- function 24
	self._widgets_by_name.objective.content.pre_round_timer = arg_24_1

	if not (not (arg_24_1 <= 10) or not (arg_24_1 > 0)) then
		local var_24_0 = carousel.versus_round_start_safe_zone_countdown_tick[arg_24_1]

		self:_play_sound(var_24_0)
	end

	self._countdown_timer = arg_24_1
end

VersusMissionObjectiveUI.set_round_timer = function (arg_25_0, arg_25_1)
	-- function 25
	arg_25_0._widgets_by_name.objective.content.pre_round_timer = arg_25_1
end

VersusMissionObjectiveUI._set_round_starting_text = function (arg_26_0)
	-- function 26
	arg_26_0._widgets_by_name.round_starting_text.content.text = "Round Starting..."
end

VersusMissionObjectiveUI._draw = function (self, arg_27_1)
	-- function 27
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local get_service = self._input_manager:get_service("ingame_menu")
	local _render_settings = self._render_settings
	local alpha_multiplier = _render_settings.alpha_multiplier

	alpha_multiplier = alpha_multiplier or 1

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, get_service, arg_27_1, nil, _render_settings)

	local _widgets = self._widgets

	if not _widgets then
		for i = 1, #_widgets do
			local var_27_6 = _widgets[i]
			local alpha_multiplier_2 = var_27_6.alpha_multiplier

			alpha_multiplier_2 = alpha_multiplier_2 or alpha_multiplier
			_render_settings.alpha_multiplier = alpha_multiplier_2

			UIRenderer.draw_widget(_ui_renderer, var_27_6)
		end
	end

	if not self._objectives_widgets and not self._round_has_started then
		UIRenderer.draw_all_widgets(_ui_renderer, self._objectives_widgets)
	end

	if not self._objective_text_widget then
		local alpha_multiplier_3 = self._objective_text_widget.alpha_multiplier

		alpha_multiplier_3 = alpha_multiplier_3 or alpha_multiplier
		_render_settings.alpha_multiplier = alpha_multiplier_3

		UIRenderer.draw_widget(_ui_renderer, self._objective_text_widget)
	end

	UIRenderer.end_pass(_ui_renderer)

	_render_settings.alpha_multiplier = alpha_multiplier
end

VersusMissionObjectiveUI._set_objective_text = function (self, arg_28_1)
	-- function 28
	local _widgets_by_name = self._widgets_by_name
	local _objective_text_widget = self._objective_text_widget
	local content = _objective_text_widget.content
	local style = _objective_text_widget.style

	content.area_text_content = arg_28_1

	local ui_renderer = self.ui_renderer
	local num = 287.5
	local num_2 = 40

	content.text_height = 45
end

VersusMissionObjectiveUI._format_timer = function (arg_29_0, arg_29_1)
	-- function 29
	if not (arg_29_1 or arg_29_1 <= 0) then
		return "00:00"
	end

	return string.format("%02d:%02d", math.floor(arg_29_1 / 60), arg_29_1 % 60)
end

local tbl_2 = {}
local tbl_3 = {}

VersusMissionObjectiveUI._update_world_markers = function (self, arg_30_1, arg_30_2)
	-- function 30
	if self._selected_objective_index < 1 then
		return
	end

	if not self._round_has_started then
		return
	end

	table.clear(tbl_3)

	local _world_markers = self._world_markers
	local _get_world_marker_targets = self:_get_world_marker_targets(tbl_2)

	for i = 1, _get_world_marker_targets do
		local var_30_2 = tbl_2[i]

		tbl_3[var_30_2] = true

		if not _world_markers[var_30_2] then
			self:_request_world_marker(var_30_2)
		end
	end

	for k, v in pairs(_world_markers) do
		if not tbl_3[k] then
			_world_markers[k] = nil

			self:_remove_world_marker(v)
		end
	end
end

VersusMissionObjectiveUI._get_world_marker_targets = function (self, arg_31_1)
	-- function 31
	local viewport_name = Managers.player:local_player().viewport_name
	local viewport = ScriptWorld.viewport(self._world, viewport_name)
	local camera = ScriptViewport.camera(viewport)
	local position = ScriptCamera.position(camera)
	local num = 0
	local var_31_5
	local huge = math.huge
	local _objective_system = self._objective_system
	local active_leaf_objectives = _objective_system:active_leaf_objectives()

	for i = 1, #active_leaf_objectives do
		local var_31_9 = active_leaf_objectives[i]
		local extension_by_objective_name = _objective_system:extension_by_objective_name(var_31_9)
		local unit = extension_by_objective_name:unit()

		if not Unit.alive(unit) then
			local local_position = Unit.local_position(unit, 0)
			local distance_squared = Vector3.distance_squared(position, local_position)

			if distance_squared < huge then
				var_31_5 = unit
				huge = distance_squared
			end

			if not extension_by_objective_name:always_show_objective_marker() then
				num = num + 1
				arg_31_1[num] = unit
			end
		end
	end

	local flag = false

	for j = 1, num do
		if arg_31_1[j] == var_31_5 then
			flag = true

			break
		end
	end

	if not (not var_31_5 and flag) then
		num = num + 1
		arg_31_1[num] = var_31_5
	end

	return num
end

VersusMissionObjectiveUI._remove_world_marker = function (arg_32_0, arg_32_1)
	-- function 32
	Managers.state.event:trigger("remove_world_marker", arg_32_1)
end

VersusMissionObjectiveUI._request_world_marker = function (arg_33_0, arg_33_1)
	-- function 33
	local event = Managers.state.event
	local str = "versus_objective"
	local var_33_2 = callback(arg_33_0, "cb_world_marker_spawned", arg_33_1)

	if not ScriptUnit.has_extension(arg_33_1, "payload_system") then
		event:trigger("add_world_marker_unit", str, arg_33_1, var_33_2)
	else
		local world_position = Unit.world_position(arg_33_1, 0)

		event:trigger("add_world_marker_position", str, world_position, var_33_2)
	end
end

VersusMissionObjectiveUI.cb_world_marker_spawned = function (arg_34_0, arg_34_1, arg_34_2)
	-- function 34
	arg_34_0._world_markers[arg_34_1] = arg_34_2
end

VersusMissionObjectiveUI.rpc_update_start_round_countdown_timer = function (arg_35_0, arg_35_1, arg_35_2)
	-- function 35
	arg_35_2 = math.round(arg_35_2)

	Managers.state.event:trigger("ui_update_start_round_counter", arg_35_2)
	Managers.state.event:trigger("ui_tab_update_start_round_counter", arg_35_2)
end

VersusMissionObjectiveUI.rpc_ui_round_started = function (self, arg_36_1)
	-- function 36
	self:_on_round_started()
	Managers.state.event:trigger("ui_tab_round_started")
end

VersusMissionObjectiveUI._on_round_started = function (self)
	-- function 37
	self._round_has_started = true

	local round_start_timer = self._widgets_by_name.round_start_timer
	local round_starting_text = self._widgets_by_name.round_starting_text
	local _objective_text_widget = self._objective_text_widget
	local objective = self._widgets_by_name.objective
	local flag = not self._custom_round_timer_active

	round_start_timer.content.visible = false
	round_starting_text.content.visible = false
	_objective_text_widget.content.visible = true
	objective.content.pre_round_timer_done = flag

	local pre_round_timer = objective.style.pre_round_timer
	local flag_2

	flag_2 = not flag and 50 and 32
	pre_round_timer.font_size = flag_2

	if not flag then
		self._widgets_by_name.objective.content.pre_round_timer = ""
	end

	local tbl = {
		wwise_world = self._wwise_world,
		render_settings = self._render_settings
	}

	self._ui_animator:start_animation("mission_start", _objective_text_widget, scenegraph_definition, tbl)
	self:_play_sound("menu_versus_match_start")
end

VersusMissionObjectiveUI._register_events = function (arg_38_0)
	-- function 38
	local event = Managers.state.event

	if not event then
		event:register(arg_38_0, "ui_update_start_round_counter", "update_start_round_counter")
		event:register(arg_38_0, "ui_update_round_timer", "set_round_timer")
		event:register(arg_38_0, "ui_round_started", "round_started")
	end
end

VersusMissionObjectiveUI._unregister_events = function (arg_39_0)
	-- function 39
	local event = Managers.state.event

	if not event then
		event:unregister("ui_update_start_round_counter", arg_39_0)
		event:unregister("ui_update_round_timer", arg_39_0)
		event:unregister("ui_round_started", arg_39_0)
	end
end

VersusMissionObjectiveUI.update_start_round_counter = function (self, arg_40_1)
	-- function 40
	self:_set_pre_round_timer(arg_40_1)
end

VersusMissionObjectiveUI.round_started = function (self)
	-- function 41
	self:_on_round_started()
end

VersusMissionObjectiveUI._update_objective_progress = function (self)
	-- function 42
	local current_objective_progress = self._objective_system:current_objective_progress()

	current_objective_progress = current_objective_progress or 0

	local num = 0
	local num_2 = 360 - num * 2
	local num_3 = 255 * math.min(current_objective_progress * 2, 1)
	local num_4 = (num + num_2 * current_objective_progress) / 360

	self._widgets_by_name.objective.style.progress_bar.gradient_threshold = num_4

	if current_objective_progress == 1 then
		return true
	end
end
