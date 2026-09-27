-- chunkname: @scripts/ui/views/tutorial_ui.lua

require("scripts/ui/views/tutorial_tooltip_ui")

local var_0_0 = local_require("scripts/ui/views/tutorial_ui_definitions")
local script_data = script_data
local disable_tutorial_ui = script_data.disable_tutorial_ui

disable_tutorial_ui = disable_tutorial_ui or Development.parameter("disable_tutorial_ui")
script_data.disable_tutorial_ui = disable_tutorial_ui

local script_data_2 = script_data
local disable_info_slate_ui = script_data.disable_info_slate_ui

disable_info_slate_ui = disable_info_slate_ui or Development.parameter("disable_info_slate_ui")
script_data_2.disable_info_slate_ui = disable_info_slate_ui

local tbl = {
	"mission_goal",
	"mission_objective",
	"side_mission",
	"tutorial",
	side_mission = 3,
	mission_objective = 2,
	tutorial = 4,
	mission_goal = 1
}
local flag = false

TutorialUI = class(TutorialUI)

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h
	local num = arg_1_2 / res_w * arg_1_0
	local num_2 = arg_1_3 / res_h * arg_1_1

	return num, num_2
end

TutorialUI.init = function (self, arg_2_1, arg_2_2)
	-- function 2
	self._parent = arg_2_1
	self.ui_renderer = arg_2_2.ui_renderer
	self.input_manager = arg_2_2.input_manager
	self.player_manager = arg_2_2.player_manager
	self.camera_manager = arg_2_2.camera_manager
	self.world_manager = arg_2_2.world_manager
	self.peer_id = arg_2_2.peer_id
	self.platform = PLATFORM
	self.localized_texts = {
		hold = Localize("interaction_prefix_hold"),
		press = Localize("interaction_prefix_press"),
		to = Localize("interaction_to")
	}
	self.render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = false
	}
	self.tooltip_animations = {}
	self.tooltip_alpha_multiplier = 1
	self.info_slate_entries = {}
	self.unused_info_slate_entry_scenegraphs = {}
	self.info_slate_widgets = {}
	self.entry_id_count = 0
	self.health_bars = {}
	self.objective_tooltip_widget_holders = {}
	self.widgets_for_update = {}
	self.num_widgets_for_update = 0
	self._objective_tooltip_position_lookup = {}
	self.queued_info_slate_entries = {}
	self.queued_info_slate_entries.mission_goal = {}
	self.queued_info_slate_entries.mission_objective = {}
	self.queued_info_slate_entries.side_mission = {}
	self.queued_info_slate_entries.tutorial = {}

	local world = self.world_manager:world("level_world")

	self.wwise_world = Managers.world:wwise_world(world)

	self:create_ui_elements()

	self.tutorial_tooltip_ui = TutorialTooltipUI:new(arg_2_2)

	local event = Managers.state.event

	if not event then
		event:register(self, "tutorial_event_queue_info_slate_entry", "queue_info_slate_entry")
		event:register(self, "tutorial_event_add_health_bar", "add_health_bar")
		event:register(self, "tutorial_event_remove_health_bar", "remove_health_bar")
		event:register(self, "tutorial_event_show_health_bar", "show_health_bar")
		event:register(self, "tutorial_event_clear_tutorials", "clear_tutorials")
	end
end

TutorialUI.create_ui_elements = function (self)
	-- function 3
	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph)
	self.floating_icons_ui_scene_graph = UISceneGraph.init_scenegraph(var_0_0.floating_icons_scene_graph)
	self.tooltip_mission_widget = UIWidget.init(var_0_0.widgets.tooltip_mission)
	self.info_slate_mask = UIWidget.init(var_0_0.widgets.info_slate_mask)

	for i = 1, var_0_0.NUMBER_OF_INFO_SLATE_ENTRIES do
		self.info_slate_widgets[i] = UIWidget.init(var_0_0.info_slate_entries[i])
	end

	self.info_slate_widgets[tbl.mission_goal].style.description_text.word_wrap = false
	self.info_slate_widgets[tbl.mission_goal].style.description_text.font_type = "hell_shark"
	self.active_animations = {}

	self:add_info_slate_entries()

	for j = 1, var_0_0.NUMBER_OF_OBJECTIVE_TOOLTIPS do
		local str = "objective_tooltip_root_" .. j
		local str_2 = "objective_tooltip_" .. j
		local str_3 = "objective_tooltip_text" .. j
		local str_4 = "objective_tooltip_icon" .. j
		local str_5 = "objective_tooltip_arrow" .. j

		self.objective_tooltip_widget_holders[j] = {
			widget = UIWidget.init(var_0_0.objective_tooltips[j]),
			animations = {},
			scenegraph_root = str,
			scenegraph_id = str_2,
			scenegraph_text = str_3,
			scenegraph_icon = str_4,
			scenegraph_arrow = str_5
		}
	end

	self._widgets = {
		self.tooltip_widget,
		self.tooltip_mission_widget,
		self.info_slate_mask
	}

	for k, v in pairs(self.info_slate_widgets) do
		self._widgets[#self._widgets + 1] = v
	end

	flag = false
	self.ui_animator = UIAnimator:new(self.ui_scenegraph, var_0_0.animations)
	self.mission_goal_state = "invisible"
	self.mission_objective_state = "invisible"
	self.side_mission_state = "invisible"
	self.tutorial_state = "invisible"
	self.side_mission_visible_timer = 0
	self.info_slate_slots_taken = {}
end

TutorialUI.destroy = function (arg_4_0)
	-- function 4
	local event = Managers.state.event

	if not event then
		event:unregister("tutorial_event_queue_info_slate_entry", arg_4_0)
		event:unregister("tutorial_event_add_health_bar", arg_4_0)
		event:unregister("tutorial_event_remove_health_bar", arg_4_0)
		event:unregister("tutorial_event_show_health_bar", arg_4_0)
		event:unregister("tutorial_event_clear_tutorials", arg_4_0)
	end

	GarbageLeakDetector.register_object(arg_4_0, "interaction_gui")
end

TutorialUI._get_player_first_person_extension = function (self)
	-- function 5
	local peer_id = self.peer_id
	local player_from_peer_id = self.player_manager:player_from_peer_id(peer_id)

	return ScriptUnit.has_extension(player_from_peer_id.player_unit, "first_person_system")
end

TutorialUI.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not flag then
		self:create_ui_elements()
	end

	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local input_manager = self.input_manager
	local get_service = input_manager:get_service("Player")
	local is_device_active = input_manager:is_device_active("gamepad")

	if not RESOLUTION_LOOKUP.modified then
		for i = 1, var_0_0.NUMBER_OF_INFO_SLATE_ENTRIES do
			self.info_slate_widgets[i].element.dirty = true
		end

		self.tutorial_tooltip_ui:set_dirty()
	end

	for k, v in pairs(self.tooltip_animations) do
		UIAnimation.update(v, arg_6_1)

		if not UIAnimation.completed(v) then
			self.tooltip_animations[k] = nil
		end
	end

	local peer_id = self.peer_id
	local player_from_peer_id = self.player_manager:player_from_peer_id(peer_id)
	local flag_2 = not player_from_peer_id and player_from_peer_id.player_unit

	if not flag_2 then
		return
	end

	if not Managers.state.side:versus_is_dark_pact(flag_2) then
		return
	end

	local flag_3 = false
	local extension = ScriptUnit.extension(flag_2, "tutorial_system")

	self.mission_tutorial_tooltip_to_update = nil

	if not extension then
		local tooltip_tutorial = extension.tooltip_tutorial
		local flag_4 = not tooltip_tutorial and tooltip_tutorial.name
		local flag_5 = not flag_4 and TutorialTemplates[flag_4]

		if not tooltip_tutorial.active then
			if not flag_5.is_mission_tutorial then
				self.mission_tutorial_tooltip_to_update = tooltip_tutorial

				self.tutorial_tooltip_ui:hide()
			end
		elseif self.active_tooltip_name or not self.active_tooltip_widget then
			if not flag_5 and not flag_5.is_mission_tutorial then
				UIRenderer.set_element_visible(ui_renderer, self.active_tooltip_widget.element, false)
			else
				self.tutorial_tooltip_ui:hide()
			end

			self.active_tooltip_widget = nil
			self.active_tooltip_name = nil
		end

		local objective_tooltips = extension.objective_tooltips

		self:update_objective_tooltip(objective_tooltips, flag_2, arg_6_1)
	elseif self.active_tooltip_name or not self.active_tooltip_widget then
		UIRenderer.set_element_visible(ui_renderer, self.active_tooltip_widget.element, false)

		self.active_tooltip_widget.element.dirty = true
		self.active_tooltip_name = nil
		self.active_tooltip_widget = nil
	end

	self.ui_animator:update(arg_6_1)
	self:update_info_slate_entries(arg_6_1, arg_6_2)

	if script_data.disable_tutorial_ui or not flag_3 then
		self.tutorial_tooltip_ui:draw(arg_6_1, arg_6_2)
	end
end

TutorialUI.post_update = function (self, arg_7_1, arg_7_2)
	-- function 7
	local floating_icons_ui_scene_graph = self.floating_icons_ui_scene_graph
	local ui_renderer = self.ui_renderer
	local peer_id = self.peer_id
	local player_from_peer_id = self.player_manager:player_from_peer_id(peer_id)
	local flag = not player_from_peer_id and player_from_peer_id.player_unit

	if not flag then
		return
	end

	local input_manager = self.input_manager
	local get_service = input_manager:get_service("Player")
	local is_device_active = input_manager:is_device_active("gamepad")
	local extension = ScriptUnit.extension(flag, "tutorial_system")
	local widgets_for_update = self.widgets_for_update

	for i = 1, self.num_widgets_for_update do
		local var_7_10 = widgets_for_update[i]

		self:update_objective_tooltip_widget(var_7_10[1], var_7_10[2], arg_7_1)
	end

	self:update_health_bars(arg_7_1, flag)

	local mission_tutorial_tooltip_to_update = self.mission_tutorial_tooltip_to_update

	self.mission_tutorial_tooltip_to_update = nil

	if not mission_tutorial_tooltip_to_update then
		self:update_mission_tooltip(mission_tutorial_tooltip_to_update, flag, arg_7_1)
	end

	if not (not self._visible and script_data.disable_tutorial_ui) then
		local _get_player_first_person_extension = self:_get_player_first_person_extension()
		local render_settings = self.render_settings

		UIRenderer.begin_pass(ui_renderer, floating_icons_ui_scene_graph, get_service, arg_7_1, nil, render_settings)

		if not _get_player_first_person_extension.first_person_mode then
			local alpha_multiplier = render_settings.alpha_multiplier
			local flag_2 = not ScriptUnit.has_extension(flag, "status_system"):get_is_aiming()

			render_settings.alpha_multiplier = alpha_multiplier * math.max(0.25, UIUtils.animate_value(self.tooltip_alpha_multiplier, arg_7_1 * 5, flag_2))

			local objective_tooltip_widget_holders = self.objective_tooltip_widget_holders

			for j = 1, var_0_0.NUMBER_OF_OBJECTIVE_TOOLTIPS do
				local var_7_17 = objective_tooltip_widget_holders[j]

				if not var_7_17.updated then
					UIRenderer.draw_widget(ui_renderer, var_7_17.widget)
				end
			end

			self.tooltip_alpha_multiplier = render_settings.alpha_multiplier
			render_settings.alpha_multiplier = alpha_multiplier
		end

		if not self.active_tooltip_widget and not mission_tutorial_tooltip_to_update then
			UIRenderer.draw_widget(ui_renderer, self.active_tooltip_widget)
		end

		if not _get_player_first_person_extension.first_person_mode then
			local health_bars = self.health_bars

			for k = 1, var_0_0.NUMBER_OF_HEALTH_BARS do
				local var_7_19 = health_bars[k]

				if not var_7_19 then
					UIRenderer.draw_widget(ui_renderer, var_7_19.widget)
				end
			end
		end

		UIRenderer.end_pass(ui_renderer)
	end
end

local tbl_2 = {
	var_0_0.scenegraph.root.size[1] * 0.5,
	var_0_0.scenegraph.root.size[2] * 0.5
}

TutorialUI.update_mission_tooltip = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local floating_icons_ui_scene_graph = self.floating_icons_ui_scene_graph
	local tooltip_mission_widget = self.tooltip_mission_widget
	local mission_tooltip = UISettings.tutorial.mission_tooltip
	local name = arg_8_1.name
	local active_tooltip_name = self.active_tooltip_name
	local flag = false

	if not (not active_tooltip_name and active_tooltip_name == name) then
		local var_8_6 = TutorialTemplates[name]
		local var_8_7

		if not var_8_6.text then
			var_8_7 = Localize(var_8_6.text)

			if not var_8_7 then
				-- Nothing
			end
		end

		var_8_7 = ""

		::label_8_0::

		tooltip_mission_widget.content.text = var_8_7
		self.active_tooltip_name = name

		local content = tooltip_mission_widget.content
		local icon

		if not var_8_6.icon then
			icon = var_8_6.icon

			if not icon then
				-- Nothing
			end
		end

		icon = "hud_tutorial_icon_info"

		::label_8_1::

		content.texture_id = icon
		tooltip_mission_widget.style.texture_id.color[1] = 0
		tooltip_mission_widget.style.arrow.color[1] = 0
		self.mission_tooltip_animation_in_time = 0
		flag = true
	end

	if not arg_8_1.world_position then
		local str = "player_1"
		local var_8_11

		if not self.camera_manager:has_viewport(str) then
			local str_2 = "level_world"
			local world_manager = self.world_manager

			if not world_manager:has_world(str_2) then
				local world = world_manager:world(str_2)
				local viewport = ScriptWorld.viewport(world, str)

				var_8_11 = ScriptViewport.camera(viewport)
			end
		end

		local unbox = arg_8_1.world_position:unbox()
		local _get_player_first_person_extension = self:_get_player_first_person_extension()
		local copy = Vector3.copy(POSITION_LOOKUP[arg_8_2])
		local current_rotation = _get_player_first_person_extension:current_rotation()
		local forward = Quaternion.forward(current_rotation)
		local normalize = Vector3.normalize(Vector3.flat(forward))
		local normalize_2 = Vector3.normalize(unbox - copy)
		local normalize_3 = Vector3.normalize(Vector3.flat(normalize_2))
		local dot = Vector3.dot(normalize, normalize_3)
		local right = Quaternion.right(current_rotation)
		local flat = Vector3.flat(right)
		local normalize_4 = Vector3.normalize(flat)
		local dot_2 = Vector3.dot(normalize_4, normalize_3)
		local convert_world_to_screen_position, var_8_30 = self:convert_world_to_screen_position(var_8_11, unbox)
		local get_floating_icon_position, var_8_32, var_8_33, var_8_34 = self:get_floating_icon_position(convert_world_to_screen_position, var_8_30, dot, dot_2, mission_tooltip)

		if var_8_33 or not var_8_34 then
			if not self.mission_tooltip_animation_in_time then
				local size = floating_icons_ui_scene_graph.tooltip_mission_arrow.size
				local size_2 = floating_icons_ui_scene_graph.tooltip_mission_icon.size
				local num = var_8_30 - tbl_2[2]
				local get_arrow_angle_and_offset, var_8_39, var_8_40, var_8_41 = self:get_arrow_angle_and_offset(dot, dot_2, size, size_2, num)

				if var_8_39 ~= nil then
					local offset = tooltip_mission_widget.style.arrow.offset

					offset[1] = var_8_39
					offset[2] = var_8_40
					offset[3] = var_8_41
				end

				tooltip_mission_widget.style.arrow.angle = get_arrow_angle_and_offset
			end
		else
			tooltip_mission_widget.style.arrow.color[1] = 0
		end

		if not self.mission_tooltip_animation_in_time then
			self:floating_icon_animations(tooltip_mission_widget, self.tooltip_animations, var_8_34, var_8_33, mission_tooltip)
		end

		local flag_2 = not not var_8_33 or not var_8_34

		if not self.mission_tooltip_animation_in_time then
			self.mission_tooltip_animation_in_time = self:animate_in_mission_tooltip(self.mission_tooltip_animation_in_time, flag_2, arg_8_3, tooltip_mission_widget, floating_icons_ui_scene_graph.tooltip_mission_icon.size)
		elseif not flag_2 then
			local var_8_44 = floating_icons_ui_scene_graph.tooltip_mission_icon.size[1]
			local var_8_45 = var_0_0.FLOATING_ICON_SIZE[1]
			local num_2 = 1
			local get_icon_size = self:get_icon_size(unbox, copy, var_8_44, var_8_45, mission_tooltip, num_2)

			floating_icons_ui_scene_graph.tooltip_mission_icon.size[1] = get_icon_size
			floating_icons_ui_scene_graph.tooltip_mission_icon.size[2] = get_icon_size
		else
			local var_8_48 = var_0_0.FLOATING_ICON_SIZE[1]

			floating_icons_ui_scene_graph.tooltip_mission_icon.size[1] = var_8_48
			floating_icons_ui_scene_graph.tooltip_mission_icon.size[2] = var_8_48
		end

		local local_position = floating_icons_ui_scene_graph.tooltip_mission_root.local_position
		local mission_tooltip_use_screen_position = self.mission_tooltip_use_screen_position

		if not mission_tooltip_use_screen_position and flag_2 and mission_tooltip_use_screen_position or not flag_2 then
			self.mission_tooltip_lerp_speed = 0
		end

		if flag or not self.mission_tooltip_lerp_speed then
			local mission_tooltip_lerp_speed = self.mission_tooltip_lerp_speed
			local min = math.min(mission_tooltip_lerp_speed + arg_8_3, 1)

			local_position[1] = math.lerp(local_position[1], get_floating_icon_position, min)
			local_position[2] = math.lerp(local_position[2], var_8_32, min)

			if min == 1 then
				self.mission_tooltip_lerp_speed = nil
			else
				self.mission_tooltip_lerp_speed = min
			end
		else
			local_position[1] = get_floating_icon_position
			local_position[2] = var_8_32
		end

		self.mission_tooltip_use_screen_position = flag_2
	else
		floating_icons_ui_scene_graph.tooltip_mission_root.local_position[1] = 0
		floating_icons_ui_scene_graph.tooltip_mission_root.local_position[2] = 0
	end

	self.active_tooltip_widget = tooltip_mission_widget
end

local tbl_3 = {}
local tbl_4 = {}
local alive = Unit.alive

TutorialUI.update_objective_tooltip = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local name = arg_9_1.name
	local units = arg_9_1.units
	local units_n = arg_9_1.units_n
	local objective_tooltip_widget_holders = self.objective_tooltip_widget_holders
	local NUMBER_OF_OBJECTIVE_TOOLTIPS = var_0_0.NUMBER_OF_OBJECTIVE_TOOLTIPS
	local num = 0
	local widgets_for_update = self.widgets_for_update

	table.clear(tbl_3)

	for i = 1, NUMBER_OF_OBJECTIVE_TOOLTIPS do
		local var_9_7 = objective_tooltip_widget_holders[i]

		var_9_7.updated = false

		if not var_9_7.unit then
			tbl_3[var_9_7.unit] = i
		end
	end

	local num_2 = 0
	local min = math.min(units_n, NUMBER_OF_OBJECTIVE_TOOLTIPS)

	table.clear(self._objective_tooltip_position_lookup)

	for j = 1, min do
		repeat
			local var_9_10 = units[j]

			if not alive(var_9_10) then
				break
			end

			local var_9_11 = tbl_3[var_9_10]

			if not var_9_11 then
				local var_9_12 = objective_tooltip_widget_holders[var_9_11]
				local animations = var_9_12.animations

				for k, v in pairs(animations) do
					UIAnimation.update(v, arg_9_3)

					if not UIAnimation.completed(v) then
						animations[k] = nil
					end
				end

				num = num + 1

				local var_9_14 = widgets_for_update[num]

				if not var_9_14 then
					var_9_14 = {}
					widgets_for_update[num] = var_9_14
				end

				var_9_14[1] = var_9_12
				var_9_14[2] = arg_9_2
				var_9_12.updated = true

				break
			end

			num_2 = num_2 + 1
			tbl_4[num_2] = var_9_10
		until true
	end

	for i4 = 1, NUMBER_OF_OBJECTIVE_TOOLTIPS do
		local var_9_15 = objective_tooltip_widget_holders[i4]

		if not var_9_15.updated then
			var_9_15.unit = nil
		end
	end

	for i5 = 1, num_2 do
		local var_9_16

		for i6 = 1, NUMBER_OF_OBJECTIVE_TOOLTIPS do
			if not objective_tooltip_widget_holders[i6].updated then
				var_9_16 = objective_tooltip_widget_holders[i6]

				break
			end
		end

		fassert(var_9_16 ~= nil, "sanity check")

		var_9_16.unit = tbl_4[i5]

		self:setup_objective_tooltip_widget(var_9_16, arg_9_1, arg_9_2, arg_9_3)

		num = num + 1

		local var_9_17 = widgets_for_update[num]

		if not var_9_17 then
			var_9_17 = {}
			widgets_for_update[num] = var_9_17
		end

		var_9_17[1] = var_9_16
		var_9_17[2] = arg_9_2
		var_9_16.updated = true
	end

	self.num_widgets_for_update = num
end

TutorialUI.setup_objective_tooltip_widget = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	local widget = arg_10_1.widget
	local name = arg_10_2.name
	local var_10_2 = TutorialTemplates[name]
	local unit = arg_10_1.unit
	local alive = Unit.alive(unit)

	alive = not alive and Unit.get_data(unit, "tutorial_text_id")

	if not alive then
		-- Nothing
	end

	::label_10_0::

	local text = var_10_2.text

	text = text or ""

	::label_10_1::

	if not var_10_2.alerts_horde then
		text = text .. "_alert_horde"
	end

	local content = widget.content
	local var_10_7

	if text ~= "" then
		var_10_7 = Localize(text)

		if not var_10_7 then
			-- Nothing
		end
	end

	var_10_7 = ""

	::label_10_2::

	content.text = var_10_7

	if not var_10_2.wave then
		local content_2 = widget.content
		local str

		if text ~= "" then
			str = Localize(text) .. var_10_2.wave

			if not str then
				-- Nothing
			end
		end

		str = ""

		::label_10_3::

		content_2.text = str
	end

	local content_3 = widget.content
	local icon = var_10_2.icon

	icon = icon or "hud_tutorial_icon_info"
	content_3.texture_id = icon

	local game_mode_key = Managers.state.game_mode:game_mode_key()

	if not game_mode_key and not var_10_2.game_mode_icons and not var_10_2.game_mode_icons[game_mode_key] then
		widget.content.texture_id = var_10_2.game_mode_icons[game_mode_key]
	end

	widget.style.texture_id.color[1] = 0
	widget.style.arrow.color[1] = 0

	local content_4 = widget.content
	local get_data = Unit.get_data(unit, "tutorial_size_scale")

	get_data = get_data or 1
	content_4.size_scale = get_data

	local get_data_2 = Unit.get_data(unit, "tutorial_position_offset", "x")

	if get_data_2 ~= nil then
		local get_data_3 = Unit.get_data(unit, "tutorial_position_offset", "y")
		local get_data_4 = Unit.get_data(unit, "tutorial_position_offset", "z")

		widget.content.position_offset = Vector3Box(get_data_2, get_data_3, get_data_4)
	end
end

TutorialUI._floating_icon_overlap = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	local _objective_tooltip_position_lookup = self._objective_tooltip_position_lookup
	local var_11_1

	for k, v in pairs(_objective_tooltip_position_lookup) do
		if not ((not (arg_11_2 >= v[1]) or not (arg_11_2 <= v[1] + 200 * arg_11_4) or not (arg_11_2 <= v[1])) and not (arg_11_2 + 200 * arg_11_4 >= v[1]) or (not (arg_11_3 >= v[2]) or not (arg_11_3 <= v[2] + var_0_0.FLOATING_ICON_SIZE[2] * arg_11_4) or not (arg_11_3 <= v[2])) and not (arg_11_3 + var_0_0.FLOATING_ICON_SIZE[2] * arg_11_4 >= v[2])) then
			if arg_11_3 < v[2] then
				var_11_1 = -var_0_0.FLOATING_ICON_SIZE[2] * 0.75 * arg_11_4

				break
			end

			var_11_1 = var_0_0.FLOATING_ICON_SIZE[2] * 0.75 * arg_11_4

			break
		end
	end

	_objective_tooltip_position_lookup[arg_11_1.scenegraph_id] = {
		arg_11_2,
		arg_11_3
	}

	return var_11_1
end

local objective_tooltip = UISettings.tutorial.objective_tooltip

TutorialUI.update_objective_tooltip_widget = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local str = "player_1"
	local var_12_1

	if not self.camera_manager:has_viewport(str) then
		local str_2 = "level_world"
		local world_manager = self.world_manager

		if not world_manager:has_world(str_2) then
			local world = world_manager:world(str_2)
			local viewport = ScriptWorld.viewport(world, str)

			var_12_1 = ScriptViewport.camera(viewport)
		end
	end

	local unit = arg_12_1.unit

	if not (not unit and not Unit.alive(unit) and Unit.alive(arg_12_2)) then
		return
	end

	local widget = arg_12_1.widget
	local position_offset = widget.content.position_offset

	position_offset = not position_offset and Vector3.up() + widget.content.position_offset:unbox()

	if not Unit.get_data(unit, "breed") then
		position_offset = Vector3(0, 0, AiUtils.breed_height(unit) + 0.75)
	end

	position_offset = position_offset or Vector3.up()

	local num = Unit.world_position(unit, 0) + position_offset
	local _get_player_first_person_extension = self:_get_player_first_person_extension()
	local current_position = _get_player_first_person_extension:current_position()
	local current_rotation = _get_player_first_person_extension:current_rotation()
	local forward = Quaternion.forward(current_rotation)
	local normalize = Vector3.normalize(Vector3.flat(forward))
	local right = Quaternion.right(current_rotation)
	local normalize_2 = Vector3.normalize(Vector3.flat(right))
	local num_2 = num - current_position
	local normalize_3 = Vector3.normalize(Vector3.flat(num_2))
	local dot = Vector3.dot(normalize, normalize_3)
	local dot_2 = Vector3.dot(normalize_2, normalize_3)
	local convert_world_to_screen_position, var_12_22 = self:convert_world_to_screen_position(var_12_1, num)
	local get_floating_icon_position, var_12_24, var_12_25, var_12_26 = self:get_floating_icon_position(convert_world_to_screen_position, var_12_22, dot, dot_2, objective_tooltip)
	local floating_icons_ui_scene_graph = self.floating_icons_ui_scene_graph
	local widget_2 = arg_12_1.widget
	local animation_in_time = arg_12_1.animation_in_time

	if var_12_25 or not var_12_26 then
		if not animation_in_time then
			local size = floating_icons_ui_scene_graph[arg_12_1.scenegraph_arrow].size
			local size_2 = floating_icons_ui_scene_graph[arg_12_1.scenegraph_icon].size
			local num_3 = var_12_22 - tbl_2[2]
			local get_arrow_angle_and_offset, var_12_34, var_12_35, var_12_36 = self:get_arrow_angle_and_offset(dot, dot_2, size, size_2, num_3)

			if var_12_34 ~= nil then
				local offset = widget_2.style.arrow.offset

				offset[1] = var_12_34
				offset[2] = var_12_35
				offset[3] = var_12_36
			end

			widget_2.style.arrow.angle = get_arrow_angle_and_offset
		end
	else
		widget_2.style.arrow.color[1] = 0
	end

	if not animation_in_time then
		self:floating_icon_animations(widget_2, arg_12_1.animations, var_12_26, var_12_25, objective_tooltip)
	end

	local flag = not not var_12_25 or not var_12_26

	if not animation_in_time then
		local size_3 = floating_icons_ui_scene_graph[arg_12_1.scenegraph_icon].size

		arg_12_1.animation_in_time = self:animate_in_mission_tooltip(animation_in_time, flag, arg_12_3, widget_2, size_3)
	elseif not flag then
		local var_12_40 = floating_icons_ui_scene_graph[arg_12_1.scenegraph_icon].size[1]
		local var_12_41 = var_0_0.FLOATING_ICON_SIZE[1]
		local size_scale = widget_2.content.size_scale
		local get_icon_size, var_12_44 = self:get_icon_size(num, current_position, var_12_40, var_12_41, objective_tooltip, size_scale)

		floating_icons_ui_scene_graph.tooltip_mission_icon.size[1] = get_icon_size
		floating_icons_ui_scene_graph.tooltip_mission_icon.size[2] = get_icon_size
		widget_2.style.texture_id.size[1] = get_icon_size
		widget_2.style.texture_id.size[2] = get_icon_size
		widget_2.style.texture_id.offset[2] = get_icon_size * (1 - var_12_44)

		local lerp = math.lerp
		local current_font_size = arg_12_1.current_font_size

		current_font_size = current_font_size or 30

		local var_12_47 = lerp(current_font_size, var_12_44 * 30, 0.2)

		widget_2.style.text.font_size = var_12_47

		if not widget_2.style.text_shadow then
			widget_2.style.text_shadow.font_size = var_12_47
		end

		floating_icons_ui_scene_graph[arg_12_1.scenegraph_icon].size[1] = get_icon_size
		arg_12_1.current_font_size = var_12_47

		local _floating_icon_overlap = self:_floating_icon_overlap(arg_12_1, get_floating_icon_position, var_12_24, var_12_44)

		if not _floating_icon_overlap then
			var_12_24 = var_12_24 + _floating_icon_overlap
			arg_12_1.lerp_speed = 0.6
		end
	else
		local var_12_49 = var_0_0.FLOATING_ICON_SIZE[1]
		local size_4 = floating_icons_ui_scene_graph[arg_12_1.scenegraph_icon].size

		size_4[1] = var_12_49
		size_4[2] = var_12_49
		widget_2.style.texture_id.size[1] = var_12_49
		widget_2.style.texture_id.size[2] = var_12_49
		widget_2.style.texture_id.offset[2] = 0
		widget_2.style.text.font_size = 30

		if not widget_2.style.text_shadow then
			widget_2.style.text_shadow.font_size = 30
		end

		floating_icons_ui_scene_graph[arg_12_1.scenegraph_icon].size[1] = var_12_49
	end

	local use_screen_position = arg_12_1.use_screen_position

	if not use_screen_position and flag and use_screen_position or not flag then
		arg_12_1.lerp_speed = 0
	end

	local local_position = floating_icons_ui_scene_graph[arg_12_1.scenegraph_root].local_position

	if not arg_12_1.lerp_speed then
		local lerp_speed = arg_12_1.lerp_speed
		local min = math.min(lerp_speed + arg_12_3, 1)

		local_position[1] = math.lerp(local_position[1], get_floating_icon_position, min)
		local_position[2] = math.lerp(local_position[2], var_12_24, min)

		if min == 1 then
			arg_12_1.lerp_speed = nil
		else
			arg_12_1.lerp_speed = min
		end
	else
		local_position[1] = get_floating_icon_position
		local_position[2] = var_12_24
	end

	arg_12_1.use_screen_position = flag
end

TutorialUI.get_floating_icon_position = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	-- function 13
	local get_size_scaled = UISceneGraph.get_size_scaled(self.ui_scenegraph, "root")
	local scale = RESOLUTION_LOOKUP.scale
	local num = get_size_scaled[1] * scale
	local num_2 = get_size_scaled[2] * scale
	local num_3 = num * 0.5
	local num_4 = num_2 * 0.5
	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h
	local num_5 = res_w / 2
	local num_6 = res_h / 2
	local num_7 = arg_13_1 - num_5
	local num_8 = num_6 - arg_13_2
	local flag = false
	local flag_2 = false

	if math.abs(num_7) > num_3 * 0.9 then
		flag = true
	end

	if math.abs(num_8) > num_4 * 0.9 then
		flag_2 = true
	end

	local var_13_14 = arg_13_1
	local var_13_15 = arg_13_2
	local flag_3

	flag_3 = not (arg_13_3 < 0) or not true or false

	local flag_4

	flag_4 = flag or not flag_2 or true or false

	if flag_4 or not flag_3 then
		local distance_from_center = arg_13_5.distance_from_center

		var_13_14 = num_3 + arg_13_4 * distance_from_center.width * scale
		var_13_15 = num_4 + arg_13_3 * distance_from_center.height * scale
	else
		local num_9 = res_w - num
		local num_10 = res_h - num_2

		var_13_14 = var_13_14 - num_9 / 2
		var_13_15 = var_13_15 - num_10 / 2
	end

	local inv_scale = RESOLUTION_LOOKUP.inv_scale
	local num_11 = var_13_14 * inv_scale
	local num_12 = var_13_15 * inv_scale

	return num_11, num_12, flag_4, flag_3
end

TutorialUI.floating_icon_animations = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	-- function 14
	local texture_id = arg_14_1.style.texture_id
	local text = arg_14_1.style.text
	local text_shadow = arg_14_1.style.text_shadow

	if arg_14_4 or not arg_14_3 then
		local alpha_fade_out_value = arg_14_5.alpha_fade_out_value

		arg_14_1.style.arrow.color[1] = alpha_fade_out_value

		if not (arg_14_2.out_of_view or texture_id.color[1] == alpha_fade_out_value) then
			arg_14_2.in_of_view = nil
			arg_14_2.in_of_view_text = nil
			arg_14_2.in_of_view_text_shadow = nil

			local fade_out_time = arg_14_5.fade_out_time

			arg_14_2.out_of_view = UIAnimation.init(UIAnimation.function_by_time, texture_id.color, 1, texture_id.color[1], alpha_fade_out_value, fade_out_time, math.easeInCubic)
			text.text_color[1] = 0
			text_shadow.text_color[1] = 0
		end
	else
		arg_14_1.style.arrow.color[1] = 0
		arg_14_2.out_of_view = nil

		if not (arg_14_2.in_of_view or texture_id.color[1] == 255) then
			local fade_in_time = arg_14_5.fade_in_time

			arg_14_2.in_of_view = UIAnimation.init(UIAnimation.function_by_time, texture_id.color, 1, texture_id.color[1], 255, fade_in_time, math.easeInCubic)
		end

		if not (arg_14_2.in_of_view_text or text.text_color[1] == 255) then
			local fade_in_time_2 = arg_14_5.fade_in_time

			arg_14_2.in_of_view_text = UIAnimation.init(UIAnimation.function_by_time, text.text_color, 1, text.text_color[1], 255, fade_in_time_2, math.easeInCubic)
			arg_14_2.in_of_view_text_shadow = UIAnimation.init(UIAnimation.function_by_time, text_shadow.text_color, 1, text_shadow.text_color[1], 255, fade_in_time_2, math.easeInCubic)
		end
	end
end

TutorialUI.get_arrow_angle_and_offset = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	local num = 1.57079633
	local num_2 = 0
	local num_3 = 0
	local num_4 = 0
	local atan2 = math.atan2(arg_15_2, arg_15_1)

	if not (not (arg_15_5 < -400) or not (arg_15_1 > 0.6)) then
		num_3 = -(arg_15_4[2] * 0.5 + arg_15_3[2])
		num = num * 2
	elseif not (not (arg_15_5 > 400) or not (arg_15_1 > 0.6)) then
		num_3 = arg_15_4[2] * 0.5 + arg_15_3[2]
		num = 0
	elseif atan2 > 0 then
		num_2 = arg_15_4[2] * 0.5 + arg_15_3[2]
	elseif atan2 < 0 then
		num_2 = -(arg_15_4[2] * 0.5 + arg_15_3[2])
		num = -num
	else
		num_2 = nil
		num_3 = nil
		num_4 = nil
		num = 0
	end

	return num, num_2, num_3, num_4
end

TutorialUI.get_icon_size = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6)
	-- function 16
	local num = arg_16_4 * arg_16_6
	local var_16_1 = num
	local start_scale_distance = arg_16_5.start_scale_distance
	local end_scale_distance = arg_16_5.end_scale_distance
	local distance = Vector3.distance(arg_16_1, arg_16_2)
	local num_2 = 1

	if start_scale_distance < distance then
		num_2 = self:icon_scale_by_distance(distance - start_scale_distance, end_scale_distance)
		var_16_1 = math.lerp(arg_16_3, num_2 * num, 0.2)
	end

	return var_16_1, num_2
end

TutorialUI.icon_scale_by_distance = function (arg_17_0, arg_17_1, arg_17_2)
	-- function 17
	local min = math.min(arg_17_2, arg_17_1)
	local max = math.max(0, min)
	local minimum_icon_scale = UISettings.tutorial.mission_tooltip.minimum_icon_scale

	return (math.max(minimum_icon_scale, 1 - max / arg_17_2))
end

TutorialUI.distance_between_screen_positions = function (arg_18_0, arg_18_1, arg_18_2)
	-- function 18
	local num = arg_18_1[1] - arg_18_2[1]
	local num_2 = arg_18_1[2] - arg_18_2[2]

	num = not (num < 0) or not (-1 * num) or num
	num_2 = not (num_2 < 0) or not (-1 * num_2) or num_2

	return {
		num,
		num_2
	}
end

TutorialUI.convert_world_to_screen_position = function (arg_19_0, arg_19_1, arg_19_2)
	-- function 19
	if not arg_19_1 then
		local world_to_screen = Camera.world_to_screen(arg_19_1, arg_19_2)

		return world_to_screen.x, world_to_screen.y
	end
end

TutorialUI.animate_in_mission_tooltip = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	-- function 20
	local texture_id = arg_20_4.style.texture_id
	local text = arg_20_4.style.text
	local num = 0.5

	arg_20_1 = arg_20_1 + arg_20_3

	local min = math.min(arg_20_1 / num, 1)
	local min_2 = math.min(min / 0.5, 1)
	local min_3 = math.min(math.max(0, (min - 0.5) / 0.5), 1)
	local catmullrom = math.catmullrom(min_2, 1, 0.9, 1, -0.1)
	local texture_id_2 = arg_20_4.style.texture_id
	local num_2 = catmullrom * var_0_0.FLOATING_ICON_SIZE[1]

	arg_20_5[1] = num_2
	arg_20_5[2] = num_2
	texture_id_2.color[1] = math.min(min * 4, 1) * 255

	local num_3

	if not arg_20_2 then
		num_3 = 255 * min_3

		if not num_3 then
			-- Nothing
		end
	end

	num_3 = 0

	::label_20_0::

	arg_20_4.style.text.text_color[1] = num_3

	if not arg_20_4.style.text_shadow then
		arg_20_4.style.text_shadow.text_color[1] = num_3
	end

	return not (min < 1) or not arg_20_1 or nil
end

TutorialUI.add_info_slate_entries = function (self)
	-- function 21
	for i = 1, var_0_0.NUMBER_OF_INFO_SLATE_ENTRIES do
		local var_21_0 = self.info_slate_widgets[i]
		local scenegraph_id = var_21_0.scenegraph_id

		var_21_0.style.background_texture.color[1] = 0

		local str = scenegraph_id .. "_text"
		local str_2 = scenegraph_id .. "_icon"
		local str_3 = scenegraph_id .. "_icon_root"
		local str_4 = scenegraph_id .. "_left_frame"
		local str_5 = scenegraph_id .. "_frame_glow_middle"
		local str_6 = scenegraph_id .. "_frame_glow_uv"

		if tbl[i] == "mission_goal" then
			var_21_0.content.icon_texture.texture_id = "hud_tutorial_icon_mission"
		elseif tbl[i] ~= "tutorial" then
			var_21_0.content.icon_texture.texture_id = "hud_tutorial_icon_sidemission"
		end

		local tbl_2 = {
			widget = var_21_0,
			scenegraph_id = scenegraph_id,
			text_scenegraph_id = str,
			icon_scenegraph_id = str_2,
			icon_root_scenegraph_id = str_3,
			entry_id = i
		}

		self.info_slate_entries[i] = tbl_2
	end
end

TutorialUI.queue_info_slate_entry = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7)
	-- function 22
	local num = self.entry_id_count + 1

	self.queued_info_slate_entries[arg_22_1][num] = {
		text = arg_22_2,
		icon_texture = arg_22_3,
		update_sound = arg_22_4,
		entry_id = num,
		template = arg_22_5,
		unit = arg_22_6,
		raycast_unit = arg_22_7
	}
	self.entry_id_count = num

	return num
end

TutorialUI.clear_tutorials = function (self)
	-- function 23
	self.queued_info_slate_entries.tutorial = {}

	local ui_animator = self.ui_animator
	local widget = self.info_slate_entries[tbl.tutorial].widget
	local var_23_2 = var_0_0.scenegraph[widget.scenegraph_id]

	if not (self.tutorial_state == "animating_out" or self.tutorial_state == "invisible") then
		self.tutorial_anim_id = ui_animator:start_animation("info_slate_exit", widget, var_23_2)
		self.tutorial_state = "animating_out"
	end
end

TutorialUI.complete_mission_info_slate = function (self, arg_24_1, arg_24_2)
	-- function 24
	if arg_24_1 == "side_mission" then
		return
	end

	self:play_sound("hud_info_slate_mission_complete")

	local var_24_0 = self.queued_info_slate_entries[arg_24_1]

	for k, v in pairs(var_24_0) do
		if v.entry_id == arg_24_2 then
			var_24_0[k] = nil

			return
		end
	end
end

TutorialUI.update_info_slate_entry_text = function (self, arg_25_1, arg_25_2, arg_25_3)
	-- function 25
	local var_25_0 = self.queued_info_slate_entries[arg_25_1]

	for k, v in pairs(var_25_0) do
		if v.entry_id == arg_25_2 then
			local widget = v.widget

			v.updated = true
			v.text = arg_25_3

			self:play_sound("hud_info_slate_mission_update")

			return
		end
	end
end

local tbl_5 = {
	slot_1 = {
		end_id = "info_slate_slot1_end",
		start_id = "info_slate_slot1_start"
	},
	slot_2 = {
		end_id = "info_slate_slot2_end",
		start_id = "info_slate_slot2_start"
	}
}

TutorialUI.update_info_slate_entries = function (self, arg_26_1, arg_26_2)
	-- function 26
	local ui_scenegraph = self.ui_scenegraph
	local ui_animator = self.ui_animator

	if not self.info_slate_entries then
		local mission_goal = self.queued_info_slate_entries.mission_goal
		local widget = self.info_slate_entries[tbl.mission_goal].widget
		local var_26_4 = var_0_0.scenegraph[widget.scenegraph_id]
		local mission_goal_state = self.mission_goal_state

		mission_goal_state = mission_goal_state or "invisible"
		self.mission_goal_state = mission_goal_state

		if not (self.mission_goal_state ~= "invisible" or self.mission_objective_state ~= "invisible") then
			local var_26_6 = next(mission_goal)

			if not (not var_26_6 and self.info_slate_slots_taken[1]) then
				self.info_slate_slots_taken[1] = true

				local var_26_7 = mission_goal[var_26_6]
				local text = var_26_7.text

				self.mission_goal_entry = var_26_7
				widget.content.description_text = text
				self.mission_goal_anim_id = ui_animator:start_animation("info_slate_enter", widget, var_26_4, tbl_5.slot_1)

				self:play_sound("hud_info_slate_mission_entry")

				self.mission_goal_state = "animating_in"
			end
		elseif self.mission_goal_state == "animating_in" then
			if not ui_animator:is_animation_completed(self.mission_goal_anim_id) then
				self.mission_goal_anim_id = ui_animator:start_animation("mission_goal_wait", widget, var_26_4)
				self.mission_goal_state = "waiting"
			end
		elseif self.mission_goal_state == "waiting" then
			if not ui_animator:is_animation_completed(self.mission_goal_anim_id) then
				self.mission_goal_anim_id = ui_animator:start_animation("mission_goal_move_up", widget, var_26_4)
				self.mission_goal_state = "animating_up"
			end
		elseif self.mission_goal_state == "animating_up" then
			if not ui_animator:is_animation_completed(self.mission_goal_anim_id) then
				self.mission_goal_anim_id = nil
				self.mission_goal_state = "visible"
			end
		elseif self.mission_goal_state == "visible" then
			if mission_goal[self.mission_goal_entry.entry_id] == nil then
				self.mission_goal_anim_id = ui_animator:start_animation("info_slate_exit", widget, var_26_4)
				self.mission_goal_state = "animating_out"
			elseif next(self.queued_info_slate_entries.mission_objective) ~= nil then
				self.mission_goal_anim_id = ui_animator:start_animation("info_slate_exit", widget, var_26_4)
				self.mission_goal_state = "animating_out"
			end
		elseif self.mission_goal_state ~= "animating_out" or not ui_animator:is_animation_completed(self.mission_goal_anim_id) then
			UIRenderer.set_element_visible(self.ui_renderer, widget.element, false)

			self.info_slate_slots_taken[1] = false
			self.mission_goal_state = "invisible"
		end

		local mission_objective = self.queued_info_slate_entries.mission_objective
		local var_26_10 = self.info_slate_entries[tbl.mission_objective]
		local widget_2 = var_26_10.widget
		local var_26_12 = var_0_0.scenegraph[widget_2.scenegraph_id]
		local mission_objective_state = self.mission_objective_state

		mission_objective_state = mission_objective_state or "invisible"
		self.mission_objective_state = mission_objective_state

		if self.mission_objective_state == "invisible" then
			local var_26_14 = next(mission_objective)

			if not (not var_26_14 and self.info_slate_slots_taken[1]) then
				for i = 1, 1 do
					if not self.info_slate_slots_taken[i] then
						self.info_slate_slots_taken[i] = true

						local var_26_15 = mission_objective[var_26_14]

						var_26_15.slot = i

						local text_2 = var_26_15.text

						self.mission_objective_entry = var_26_15
						widget_2.content.description_text = text_2

						local var_26_17 = ui_animator
						local start_animation = ui_animator.start_animation
						local str = "info_slate_enter"
						local var_26_20 = widget_2
						local var_26_21 = var_26_12
						local var_26_22 = tbl_5
						local flag

						flag = i ~= 1 or not "slot_1" or "slot_2"
						self.mission_objective_anim_id = start_animation(var_26_17, str, var_26_20, var_26_21, var_26_22[flag])

						local INFO_SLATE_ENTRY_SIZE = var_0_0.INFO_SLATE_ENTRY_SIZE
						local text_scenegraph_id = var_26_10.text_scenegraph_id
						local icon_scenegraph_id = var_26_10.icon_scenegraph_id
						local description_text = widget_2.style.description_text
						local info_slate_text_height, var_26_29 = self:info_slate_text_height(text_2, description_text)
						local max = math.max(INFO_SLATE_ENTRY_SIZE[2], info_slate_text_height)

						ui_scenegraph[text_scenegraph_id].size[2] = max

						local var_26_31 = ui_scenegraph[widget_2.scenegraph_id].size[2]

						ui_scenegraph[widget_2.scenegraph_id].size[2] = max
						ui_scenegraph[widget_2.scenegraph_id].position[2] = ui_scenegraph[widget_2.scenegraph_id].position[2] - max + INFO_SLATE_ENTRY_SIZE[2]

						local var_26_32 = ui_scenegraph[var_26_10.icon_root_scenegraph_id]
						local flag_2

						flag_2 = not (var_26_29 > 1) or not "top" or "center"
						var_26_32.vertical_alignment = flag_2

						local position = ui_scenegraph[var_26_10.icon_root_scenegraph_id].position
						local flag_3

						flag_3 = not (var_26_29 > 1) or not -10 or 0
						position[2] = flag_3

						self:play_sound("hud_info_slate_mission_entry")

						self.mission_objective_state = "animating_in"

						break
					end
				end
			end
		elseif self.mission_objective_state == "animating_in" then
			if not ui_animator:is_animation_completed(self.mission_objective_anim_id) then
				self.mission_objective_anim_id = ui_animator:start_animation("mission_goal_wait", widget_2, var_26_12)
				self.mission_objective_state = "visible"
			end
		elseif self.mission_objective_state == "visible" then
			if not self.mission_objective_entry.updated then
				self.mission_objective_entry.updated = nil
				self.mission_objective_anim_id = ui_animator:start_animation("info_slate_flash", widget_2, var_26_12)
				self.mission_objective_state = "flashing"
				widget_2.content.description_text = self.mission_objective_entry.text
			elseif mission_objective[self.mission_objective_entry.entry_id] == nil then
				self.mission_objective_anim_id = ui_animator:start_animation("info_slate_exit", widget_2, var_26_12)
				self.mission_objective_state = "animating_out"
			end
		elseif self.mission_objective_state == "moving" then
			if not ui_animator:is_animation_completed(self.mission_objective_anim_id) then
				self.mission_objective_state = "visible"
			end
		elseif self.mission_objective_state == "flashing" then
			if not ui_animator:is_animation_completed(self.mission_objective_anim_id) then
				self.mission_objective_state = "visible"
			end
		elseif self.mission_objective_state ~= "animating_out" or not ui_animator:is_animation_completed(self.mission_objective_anim_id) then
			UIRenderer.set_element_visible(self.ui_renderer, widget_2.element, false)

			self.info_slate_slots_taken[self.mission_objective_entry.slot] = false
			self.mission_objective_state = "invisible"
		end

		local side_mission = self.queued_info_slate_entries.side_mission
		local widget_3 = self.info_slate_entries[tbl.side_mission].widget
		local var_26_38 = var_0_0.scenegraph[widget_3.scenegraph_id]
		local side_mission_state = self.side_mission_state

		side_mission_state = side_mission_state or "invisible"
		self.side_mission_state = side_mission_state

		if self.side_mission_state == "invisible" then
			for k, v in pairs(side_mission) do
				if not v.updated then
					self.side_mission_state = "waiting_for_tutorial"

					break
				end
			end
		elseif not (self.side_mission_state ~= "waiting_for_tutorial" or self.tutorial_state ~= "invisible") then
			for l = 2, 2 do
				if not self.info_slate_slots_taken[l] then
					self.info_slate_slots_taken[l] = true

					local var_26_40 = side_mission[next(side_mission)]

					var_26_40.slot = l

					local text_3 = var_26_40.text

					self.side_mission_entry = var_26_40
					widget_3.content.description_text = text_3

					local flag_4

					flag_4 = (l ~= 1 or not "slot_1" or l ~= 2) and (not "slot_2" or "slot_3")
					self.side_mission_anim_id = ui_animator:start_animation("info_slate_enter", widget_3, var_26_38, tbl_5[flag_4])
					self.side_mission_state = "animating_in"

					break
				end
			end
		elseif self.side_mission_state == "animating_in" then
			if not ui_animator:is_animation_completed(self.side_mission_anim_id) then
				self.side_mission_anim_id = ui_animator:start_animation("mission_goal_wait", widget_3, var_26_38)
				self.side_mission_visible_timer = 0
				self.side_mission_state = "visible"
			end
		elseif self.side_mission_state == "visible" then
			self.side_mission_visible_timer = self.side_mission_visible_timer + arg_26_1

			if self.side_mission_visible_timer > 1 then
				local slot = self.side_mission_entry.slot
				local flag_5

				flag_5 = (slot ~= 1 or not "slot_1" or slot ~= 2) and (not "slot_2" or "slot_3")
				self.side_mission_anim_id = ui_animator:start_animation("info_slate_exit", widget_3, var_26_38, tbl_5[flag_5])
				self.side_mission_state = "animating_out"
			elseif not self.side_mission_entry.updated then
				self.side_mission_entry.updated = nil
				self.side_mission_anim_id = ui_animator:start_animation("info_slate_flash", widget_3, var_26_38)
				self.side_mission_state = "flashing"
				widget_3.content.description_text = self.side_mission_entry.text
			elseif side_mission[self.side_mission_entry.entry_id] == nil then
				self.side_mission_anim_id = ui_animator:start_animation("info_slate_exit", widget_3, var_26_38)
				self.side_mission_state = "animating_out"
			end
		elseif self.side_mission_state == "moving" then
			if not ui_animator:is_animation_completed(self.side_mission_anim_id) then
				self.side_mission_visible_timer = 0
				self.side_mission_state = "visible"
			end
		elseif self.side_mission_state == "flashing" then
			if not ui_animator:is_animation_completed(self.side_mission_anim_id) then
				self.side_mission_visible_timer = 0
				self.side_mission_state = "visible"
			end
		elseif self.side_mission_state ~= "animating_out" or not ui_animator:is_animation_completed(self.side_mission_anim_id) then
			UIRenderer.set_element_visible(self.ui_renderer, widget_3.element, false)

			self.info_slate_slots_taken[self.side_mission_entry.slot] = false
			self.side_mission_state = "invisible"
		end

		local tutorial = self.queued_info_slate_entries.tutorial
		local var_26_46 = self.info_slate_entries[tbl.tutorial]
		local widget_4 = var_26_46.widget
		local var_26_48 = var_0_0.scenegraph[widget_4.scenegraph_id]
		local tutorial_state = self.tutorial_state

		tutorial_state = tutorial_state or "invisible"
		self.tutorial_state = tutorial_state

		local _get_next_verified = self:_get_next_verified(tutorial, arg_26_2)

		if not (self.tutorial_state ~= "invisible" or self.side_mission_state ~= "invisible") then
			if not _get_next_verified then
				for i4 = 2, 2 do
					if not self.info_slate_slots_taken[i4] then
						self.info_slate_slots_taken[i4] = true

						local var_26_51 = tutorial[_get_next_verified]

						var_26_51.slot = i4

						local text_4 = var_26_51.text

						self.tutorial_entry = var_26_51
						widget_4.content.description_text = text_4

						local var_26_53 = ui_animator
						local start_animation_2 = ui_animator.start_animation
						local str_2 = "info_slate_enter"
						local var_26_56 = widget_4
						local var_26_57 = var_26_48
						local var_26_58 = tbl_5
						local flag_6

						flag_6 = i4 ~= 1 or not "slot_1" or "slot_2"
						self.tutorial_anim_id = start_animation_2(var_26_53, str_2, var_26_56, var_26_57, var_26_58[flag_6])

						local INFO_SLATE_ENTRY_SIZE_2 = var_0_0.INFO_SLATE_ENTRY_SIZE
						local text_scenegraph_id_2 = var_26_46.text_scenegraph_id
						local icon_scenegraph_id_2 = var_26_46.icon_scenegraph_id
						local description_text_2 = widget_4.style.description_text
						local info_slate_text_height_2, var_26_65 = self:info_slate_text_height(text_4, description_text_2)
						local max_2 = math.max(INFO_SLATE_ENTRY_SIZE_2[2], info_slate_text_height_2)

						ui_scenegraph[text_scenegraph_id_2].size[2] = max_2

						local var_26_67 = ui_scenegraph[widget_4.scenegraph_id].size[2]

						ui_scenegraph[widget_4.scenegraph_id].size[2] = max_2
						ui_scenegraph[widget_4.scenegraph_id].position[2] = ui_scenegraph[widget_4.scenegraph_id].position[2] - max_2 + INFO_SLATE_ENTRY_SIZE_2[2]

						local var_26_68 = ui_scenegraph[var_26_46.icon_root_scenegraph_id]
						local flag_7

						flag_7 = not (var_26_65 > 1) or not "top" or "center"
						var_26_68.vertical_alignment = flag_7

						local position_2 = ui_scenegraph[var_26_46.icon_root_scenegraph_id].position
						local flag_8

						flag_8 = not (var_26_65 > 1) or not -10 or 0
						position_2[2] = flag_8
						self.tutorial_state = "animating_in"

						break
					end
				end
			end
		elseif self.tutorial_state == "animating_in" then
			if not ui_animator:is_animation_completed(self.tutorial_anim_id) then
				self.tutorial_anim_id = ui_animator:start_animation("mission_goal_wait", widget_4, var_26_48)
				self.tutorial_visible_timer = 0
				self.tutorial_state = "visible"
			end
		elseif self.tutorial_state == "visible" then
			self.tutorial_visible_timer = self.tutorial_visible_timer + arg_26_1

			if self.tutorial_visible_timer > 10 then
				local slot_2 = self.tutorial_entry.slot
				local flag_9

				flag_9 = (slot_2 ~= 1 or not "slot_1" or slot_2 ~= 2) and (not "slot_2" or "slot_3")
				self.tutorial_anim_id = ui_animator:start_animation("info_slate_exit", widget_4, var_26_48, tbl_5[flag_9])
				self.tutorial_state = "animating_out"
			elseif not self.tutorial_entry.updated then
				self.tutorial_entry.updated = nil
				self.tutorial_anim_id = ui_animator:start_animation("info_slate_flash", widget_4, var_26_48)
				self.tutorial_state = "flashing"
				widget_4.content.description_text = self.tutorial_entry.text
			elseif self.side_mission_state == "waiting_for_tutorial" then
				self.tutorial_anim_id = ui_animator:start_animation("info_slate_exit", widget_4, var_26_48)
				self.tutorial_state = "animating_out"
			end
		elseif self.tutorial_state == "moving" then
			if not ui_animator:is_animation_completed(self.tutorial_anim_id) then
				self.info_slate_slots_taken[3 - self.tutorial_entry.slot] = false
				self.tutorial_state = "visible"
			end
		elseif self.tutorial_state == "flashing" then
			if not ui_animator:is_animation_completed(self.tutorial_anim_id) then
				self.tutorial_state = "visible"
			end
		elseif self.tutorial_state ~= "animating_out" or not ui_animator:is_animation_completed(self.tutorial_anim_id) then
			UIRenderer.set_element_visible(self.ui_renderer, widget_4.element, false)

			self.info_slate_slots_taken[self.tutorial_entry.slot] = false
			tutorial[self.tutorial_entry.entry_id] = nil
			self.tutorial_state = "invisible"
		end
	end
end

TutorialUI._get_next_verified = function (self, arg_27_1, arg_27_2)
	-- function 27
	local system = Managers.state.entity:system("tutorial_system")

	while true do
		local var_27_1, var_27_2 = next(arg_27_1)

		if not var_27_1 then
			return
		end

		local unit = var_27_2.unit
		local template = var_27_2.template
		local raycast_unit = var_27_2.raycast_unit

		if not (not Unit.alive(unit) and template) then
			return var_27_1
		end

		if not system:verify_info_slate(arg_27_2, unit, raycast_unit, template) then
			return var_27_1
		else
			print("Verification failed: " .. var_27_2.text)

			arg_27_1[var_27_1] = nil

			if self.tutorial_state ~= "invisible" then
				local slot = self.tutorial_entry.slot
				local widget = self.info_slate_entries[tbl.tutorial].widget
				local var_27_8 = var_0_0.scenegraph[widget.scenegraph_id]
				local flag

				flag = (slot ~= 1 or not "slot_1" or slot ~= 2) and (not "slot_2" or "slot_3")

				self.ui_animator:stop_animation(self.tutorial_anim_id)

				self.tutorial_anim_id = self.ui_animator:start_animation("info_slate_exit", widget, var_27_8, tbl_5[flag])
				self.tutorial_state = "animating_out"
			end
		end
	end
end

TutorialUI.info_slate_text_height = function (self, arg_28_1, arg_28_2)
	-- function 28
	local clone = table.clone(var_0_0.INFO_SLATE_ENTRY_SIZE)

	clone[1] = clone[1] - 62

	local ui_renderer = self.ui_renderer
	local var_28_2, var_28_3 = UIFontByResolution(arg_28_2)
	local var_28_4, var_28_5, var_28_6 = unpack(var_28_2)
	local var_28_7, var_28_8, var_28_9 = UIGetFontHeight(self.ui_renderer.gui, var_28_6, var_28_3)
	local num = var_28_9 - var_28_8
	local word_wrap = UIRenderer.word_wrap(ui_renderer, arg_28_1, var_28_2[1], var_28_3, clone[1])
	local num_2 = 20
	local count = #word_wrap

	return num * RESOLUTION_LOOKUP.inv_scale * count + num_2, count
end

TutorialUI.play_sound = function (self, arg_29_1)
	-- function 29
	WwiseWorld.trigger_event(self.wwise_world, arg_29_1)
end

TutorialUI.add_health_bar = function (self, arg_30_1, arg_30_2)
	-- function 30
	local flag = false

	for i = 1, var_0_0.NUMBER_OF_HEALTH_BARS do
		local var_30_1 = self.health_bars[i]

		if not (not arg_30_2 and not var_30_1 and var_30_1.visible) then
			self:remove_health_bar(arg_30_1)

			var_30_1 = nil
		end

		if not var_30_1 then
			local get_data

			if not Unit.has_data(arg_30_1, "health_bar_color") then
				get_data = Unit.get_data(arg_30_1, "health_bar_color")

				if not get_data then
					-- Nothing
				end
			end

			get_data = "red"

			::label_30_0::

			local var_30_3 = var_0_0.health_bar_definitions[i]
			local var_30_4 = UIWidget.init(var_30_3)

			var_30_4.style.texture_fg.color = Colors.get_table(get_data)
			self.health_bars[i] = {
				health_percent = 1,
				init_position = true,
				visible_time = 0,
				damage_time = 0,
				visible = true,
				active = false,
				unit = arg_30_1,
				health_extension = ScriptUnit.extension(arg_30_1, "health_system"),
				widget = var_30_4,
				scenegraph_definition = self.floating_icons_ui_scene_graph[var_30_3.scenegraph_id]
			}
			flag = i

			break
		end
	end

	if not flag then
		if not arg_30_2 then
			Application.warning("[TutorialUI] ERROR: Tried to exceed the limit of %s visible health bars.", var_0_0.NUMBER_OF_HEALTH_BARS)
		else
			self:add_health_bar(arg_30_1, true)
		end
	end
end

TutorialUI.remove_health_bar = function (self, arg_31_1)
	-- function 31
	for i = 1, var_0_0.NUMBER_OF_HEALTH_BARS do
		local var_31_0 = self.health_bars[i]

		if not (not var_31_0 and var_31_0.unit ~= arg_31_1) then
			self.health_bars[i] = nil

			break
		end
	end
end

TutorialUI._get_health_bar_by_unit = function (self, arg_32_1)
	-- function 32
	for i = 1, var_0_0.NUMBER_OF_HEALTH_BARS do
		local var_32_0 = self.health_bars[i]

		if not (not var_32_0 and var_32_0.unit ~= arg_32_1) then
			return var_32_0
		end
	end
end

TutorialUI.show_health_bar = function (self, arg_33_1, arg_33_2)
	-- function 33
	local _get_health_bar_by_unit = self:_get_health_bar_by_unit(arg_33_1)

	if not _get_health_bar_by_unit then
		_get_health_bar_by_unit.visible = arg_33_2
	elseif not arg_33_2 then
		self:add_health_bar(arg_33_1)

		local _get_health_bar_by_unit_2 = self:_get_health_bar_by_unit(arg_33_1)

		if not _get_health_bar_by_unit_2 then
			_get_health_bar_by_unit_2.visible = arg_33_2
		end
	end
end

TutorialUI.update_health_bars = function (self, arg_34_1, arg_34_2)
	-- function 34
	local _get_player_first_person_extension = self:_get_player_first_person_extension()
	local current_position = _get_player_first_person_extension:current_position()
	local current_rotation = _get_player_first_person_extension:current_rotation()
	local forward = Quaternion.forward(current_rotation)
	local str = "player_1"
	local var_34_5

	if not self.camera_manager:has_viewport(str) then
		local str_2 = "level_world"
		local world_manager = self.world_manager

		if not world_manager:has_world(str_2) then
			local world = world_manager:world(str_2)
			local viewport = ScriptWorld.viewport(world, str)

			var_34_5 = ScriptViewport.camera(viewport)
		end
	end

	local health_bars = self.health_bars
	local inv_scale = RESOLUTION_LOOKUP.inv_scale
	local Unit = Unit

	for i = 1, var_0_0.NUMBER_OF_HEALTH_BARS do
		local var_34_13 = health_bars[i]
		local flag = not var_34_13 and var_34_13.unit

		if not flag and not Unit.alive(flag) then
			local get_data = Unit.get_data(flag, "health_bar_node")
			local node

			if not get_data then
				node = Unit.node(flag, get_data)

				if not node then
					-- Nothing
				end
			end

			node = 0

			::label_34_0::

			local world_position = Unit.world_position(flag, node)
			local normalize = Vector3.normalize(world_position - current_position)
			local dot = Vector3.dot(forward, normalize)
			local current_health_percent = var_34_13.health_extension:current_health_percent()
			local health_percent = var_34_13.health_percent
			local recent_damages, var_34_23 = var_34_13.health_extension:recent_damages()

			if not (var_34_23 > 0) then
				var_34_13.visible_time = 1
				var_34_13.damage_time = 0.5
			end

			var_34_13.visible_time = var_34_13.visible_time - arg_34_1
			var_34_13.damage_time = var_34_13.damage_time - arg_34_1

			if dot > 0 then
				local var_34_24 = health_percent

				if not (not (var_34_13.visible_time > 0) or not (var_34_13.damage_time < 0) or not (current_health_percent < health_percent)) then
					var_34_13.health_percent = math.max(current_health_percent, health_percent - arg_34_1)
				end

				var_34_13.health_percent = current_health_percent

				local convert_world_to_screen_position, var_34_26 = self:convert_world_to_screen_position(var_34_5, world_position)
				local scenegraph_definition = var_34_13.scenegraph_definition
				local local_position = scenegraph_definition.local_position

				local_position[1] = convert_world_to_screen_position * inv_scale
				local_position[2] = var_34_26 * inv_scale

				local size = scenegraph_definition.size

				var_34_13.widget.style.texture_fg.size[1] = size[1] * current_health_percent
				var_34_13.widget.content.visible = true
			else
				var_34_13.widget.content.visible = false
			end

			if var_34_13.widget.content.visible ~= var_34_13.visible then
				var_34_13.widget.content.visible = var_34_13.visible
			end
		elseif not var_34_13 then
			var_34_13.widget.content.visible = false
		end
	end
end

TutorialUI.set_visible = function (self, arg_35_1)
	-- function 35
	self._visible = arg_35_1

	self.tutorial_tooltip_ui:set_visible(arg_35_1)
end
