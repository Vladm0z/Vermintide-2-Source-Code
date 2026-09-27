-- chunkname: @scripts/ui/hud_ui/challenge_tracker_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/challenge_tracker_ui_definitions")

ChallengeTrackerUI = class(ChallengeTrackerUI)

local num = 500
local RETAINED_MODE_ENABLED = var_0_0.RETAINED_MODE_ENABLED

ChallengeTrackerUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._ui_renderer = arg_1_2.ui_renderer
	self._wwise_world = arg_1_2.wwise_world

	self:_create_ui_elements()
end

ChallengeTrackerUI.destroy = function (self)
	-- function 2
	if not RETAINED_MODE_ENABLED then
		local _data = self._data

		_data = not _data and self._data.widgets

		if not _data then
			UIUtils.destroy_widgets(self._ui_renderer, _data)
		end
	end
end

ChallengeTrackerUI._play_sound = function (self, arg_3_1)
	-- function 3
	return WwiseWorld.trigger_event(self._wwise_world, arg_3_1)
end

ChallengeTrackerUI._create_ui_elements = function (self)
	-- function 4
	self:destroy()

	self._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	self._render_settings = {
		alpha_multiplier = 1
	}
	self._ui_animator = UIAnimator:new(self._ui_scenegraph, var_0_0.animation_definitions)
	self._data = {
		offset = {
			0,
			0,
			0
		},
		widgets = {},
		widget_by_challenge = {},
		challenges = {}
	}
	self._animation_queue = MakeTableWeakKeys({})
	self._restack_targets = {}

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._dirty = true
end

local function fn(self, arg_5_1)
	-- function 5
	return self:get_category() < arg_5_1:get_category()
end

ChallengeTrackerUI._refresh_challenge_data = function (self, arg_6_1)
	-- function 6
	table.clear(arg_6_1.challenges)

	local get_challenges_filtered, var_6_1 = Managers.venture.challenge:get_challenges_filtered(arg_6_1.challenges)

	table.sort(get_challenges_filtered, fn)

	local widgets = arg_6_1.widgets
	local count = #widgets
	local gui_retained

	if not RETAINED_MODE_ENABLED then
		gui_retained = self._ui_renderer.gui_retained

		if not gui_retained then
			-- Nothing
		end
	end

	gui_retained = self._ui_renderer.gui

	::label_6_0::

	for i = 1, var_6_1 do
		local var_6_5 = get_challenges_filtered[i]
		local get_status = var_6_5:get_status()

		if not (arg_6_1.widget_by_challenge[var_6_5] or get_status ~= InGameChallengeStatus.InProgress) then
			count = count + 1

			local create_objective = var_0_0.create_objective(var_6_5, gui_retained, arg_6_1.offset, count)

			arg_6_1.widgets[count] = create_objective
			arg_6_1.widget_by_challenge[var_6_5] = create_objective

			self:_play_animation_queued("on_enter", create_objective)
		end
	end

	for j = 1, count do
		local var_6_8 = widgets[j]
		local content = var_6_8.content
		local challenge = content.challenge
		local get_status_2 = challenge:get_status()

		if get_status_2 == InGameChallengeStatus.InProgress then
			content.progress, content.max_progress = challenge:get_progress()

			if content.last_progress ~= content.progress then
				self:_play_animation_queued("on_progress", var_6_8)

				content.last_progress = content.progress
			end
		elseif not (content.is_done or content.canceled) then
			if get_status_2 == InGameChallengeStatus.Finished then
				if challenge:get_result() == InGameChallengeResult.Completed then
					content.is_done = true
					content.progress, content.max_progress = challenge:get_progress()

					self:_play_animation_queued("on_progress", var_6_8)
					self:_play_animation_queued("on_done", var_6_8)
				else
					content.canceled = true

					self:_play_animation_queued("on_cancel", var_6_8)
				end
			elseif get_status_2 == InGameChallengeStatus.Paused then
				content.canceled = true

				self:_play_animation_queued("on_cancel", var_6_8)
			end
		end
	end
end

ChallengeTrackerUI._cb_on_done = function (self, arg_7_1, arg_7_2)
	-- function 7
	local _data = self._data
	local index_of = table.index_of(_data.widgets, arg_7_1)
	local count = #_data.widgets

	_data.widgets[index_of] = nil
	_data.widget_by_challenge[arg_7_2] = nil
	self._animation_queue[arg_7_1] = nil
	self._restack_targets[arg_7_1] = nil

	if not RETAINED_MODE_ENABLED then
		UIWidget.destroy(self._ui_renderer, arg_7_1)
	end

	local offset = _data.offset
	local _restack_targets = self._restack_targets

	for i = index_of + 1, count do
		_restack_targets[_data.widgets[i]] = var_0_0.get_widget_position(offset, i - 1)[2]
		_data.widgets[i - 1] = _data.widgets[i]
		_data.widgets[i] = nil
	end
end

ChallengeTrackerUI._play_animation = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local _ui_animator = self._ui_animator
	local var_8_1 = _ui_animator
	local stop_animation = _ui_animator.stop_animation
	local animation_id = arg_8_2.content.animation_id

	animation_id = animation_id or false

	stop_animation(var_8_1, animation_id)

	arg_8_2.content.animation_id = _ui_animator:start_animation(arg_8_1, arg_8_2, var_0_0.scenegraph_definition, {
		view = self,
		ui_renderer = self._ui_renderer
	}, arg_8_3)
end

ChallengeTrackerUI._play_animation_queued = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local _ui_animator = self._ui_animator
	local animation_id = arg_9_2.content.animation_id

	if not _ui_animator:is_animation_completed(animation_id) then
		self:_play_animation(arg_9_1, arg_9_2, arg_9_3)
	else
		local var_9_2 = self._animation_queue[arg_9_2]

		var_9_2 = var_9_2 or {}
		var_9_2[#var_9_2 + 1] = {
			name = arg_9_1,
			initial_delay = arg_9_3
		}
		self._animation_queue[arg_9_2] = var_9_2
	end
end

ChallengeTrackerUI._update_animation_queue = function (self)
	-- function 10
	local _ui_animator = self._ui_animator

	for k, v in pairs(self._animation_queue) do
		local var_10_1 = v[1]

		if not var_10_1 then
			local animation_id = k.content.animation_id

			if not _ui_animator:is_animation_completed(animation_id) then
				self:_play_animation(var_10_1.name, k, var_10_1.initial_delay)
				table.remove(v, 1)
			end
		else
			self._animation_queue[k] = nil
		end
	end
end

ChallengeTrackerUI._update_restacking = function (self, arg_11_1)
	-- function 11
	local _restack_targets = self._restack_targets
	local num_2 = num * arg_11_1

	for k, v in pairs(_restack_targets) do
		local var_11_2 = k.offset[2]
		local num_3 = v - var_11_2

		if num_2 >= math.abs(num_3) then
			k.offset[2] = v
			_restack_targets[k] = nil
		else
			local min = math.min(math.abs(num_3), num_2)

			k.offset[2] = var_11_2 + math.clamp(num_3, -min, min)
		end

		self:_set_widget_dirty(k)
	end
end

ChallengeTrackerUI._set_widget_dirty = function (self, arg_12_1)
	-- function 12
	arg_12_1.element.dirty = true
	self._dirty = true
end

ChallengeTrackerUI._update_animations = function (self, arg_13_1, arg_13_2)
	-- function 13
	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_13_1)

	local widgets = self._data.widgets
	local count = #widgets

	for i = 1, count do
		local var_13_3 = widgets[i]
		local animation_id = var_13_3.content.animation_id

		if not _ui_animator:is_animation_completed(animation_id) then
			self:_set_widget_dirty(var_13_3)
		end
	end
end

ChallengeTrackerUI._handle_resolution_modified = function (self)
	-- function 14
	if not RESOLUTION_LOOKUP.modified then
		UIUtils.mark_dirty(self._data.widgets)

		self._dirty = true
	end
end

local tbl = {
	lock_y = false,
	registry_key = "questingknight",
	drag_scenegraph_id = "quest",
	root_scenegraph_id = "quest",
	label = "Duties",
	lock_x = false
}

ChallengeTrackerUI.update = function (self, arg_15_1, arg_15_2)
	-- function 15
	HudCustomizer.run(self._ui_renderer, self._ui_scenegraph, tbl)
	self:_handle_resolution_modified()
	self:_update_restacking(arg_15_1)
	self:_update_animation_queue()
	self:_refresh_challenge_data(self._data)
	self:_update_animations(arg_15_1, arg_15_2)
	self:_draw(arg_15_1)
end

ChallengeTrackerUI._draw = function (self, arg_16_1)
	-- function 16
	if not (self._dirty or not RETAINED_MODE_ENABLED or self._is_visible) then
		return
	end

	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _render_settings = self._render_settings
	local var_16_3
	local UIRenderer = UIRenderer

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, var_16_3, arg_16_1, nil, _render_settings)

	for k, v in pairs(self._data.widgets) do
		local alpha_multiplier = v.content.alpha_multiplier

		alpha_multiplier = alpha_multiplier or 1
		_render_settings.alpha_multiplier = alpha_multiplier

		UIRenderer.draw_widget(_ui_renderer, v)
	end

	UIRenderer.end_pass(_ui_renderer)

	self._dirty = false
end

ChallengeTrackerUI.set_visible = function (self, arg_17_1)
	-- function 17
	self._is_visible = arg_17_1

	local _ui_renderer = self._ui_renderer

	for k, v in pairs(self._data.widgets) do
		UIRenderer.set_element_visible(_ui_renderer, v.element, arg_17_1)
	end

	self._dirty = true
end
