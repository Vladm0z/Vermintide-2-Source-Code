-- chunkname: @scripts/ui/hud_ui/boss_health_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/boss_health_ui_definitions")
local num = 0.5
local num_2 = 2
local breed_textures = UISettings.breed_textures
local tbl = {
	sync = 0,
	lord = 2,
	proximity = 1,
	ping = 4,
	damage_taken = 3,
	damage_done = 4,
	forced = 5
}
local set = table.set({
	"damage_taken",
	"damage_done",
	"ping"
})
local tbl_2 = {
	"rpc_add_forced_boss_health_ui",
	"rpc_register_detected_boss"
}

BossHealthUI = class(BossHealthUI)
BossHealthUI.MAX_NUM_FORCED_WIDGETS = 2
BossHealthUI.MAX_NUM_ADDITIONAL_WIDGETS = 4

BossHealthUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self.ui_renderer = arg_1_2.ui_renderer
	self.input_manager = arg_1_2.input_manager
	self.player_manager = arg_1_2.player_manager
	self.peer_id = arg_1_2.peer_id
	self.world = arg_1_2.world_manager:world("level_world")
	self.render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}

	self:create_ui_elements()

	self._animations = {}
	self._forced_animations = {}
	self._ingame_ui_context = arg_1_2
	self._name_pools = {}
	self._cached_pool_name_by_unit = {}
	self._detected_boss_units = {}

	local event = Managers.state.event

	event:register(self, "boss_health_bar_register_unit", "_event_register_boss_unit")
	event:register(self, "on_spectator_target_changed", "on_spectator_target_changed")
	event:register(self, "force_add_boss_health_ui", "on_force_add_boss_health_ui")

	self._proximity_update_time = 0
	self._look_at_boss_unit_timer = 0
	self._network_event_delegate = arg_1_2.network_event_delegate

	self._network_event_delegate:register(self, unpack(tbl_2))
end

BossHealthUI.destroy = function (self)
	-- function 2
	GarbageLeakDetector.register_object(self, "boss_health_ui")

	local event = Managers.state.event

	event:unregister("on_spectator_target_changed", self)
	event:unregister("boss_health_bar_register_unit", self)
	event:unregister("force_add_boss_health_ui", self)
	self._network_event_delegate:unregister(self)
end

BossHealthUI.create_ui_elements = function (self)
	-- function 3
	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	self._forced_widget_names = {}
	self._additional_widget_names = {}

	local tbl = {}
	local tbl_2 = {}
	local widget_create_func = var_0_0.widget_create_func()
	local var_3_3 = UIWidget.init(widget_create_func)

	tbl[#tbl + 1] = var_3_3
	tbl_2.prioritized_bar = var_3_3
	self._widgets = tbl
	self._widgets_by_name = tbl_2

	self:_preemptively_hide_widgets()

	if Managers.state.game_mode:game_mode_key() == "versus" then
		self.ui_scenegraph.pivot.position[2] = -150
	end
end

BossHealthUI._get_or_create_forced_widget_name = function (self, arg_4_1)
	-- function 4
	if arg_4_1 > BossHealthUI.MAX_NUM_FORCED_WIDGETS then
		return nil
	end

	local _forced_widget_names = self._forced_widget_names
	local var_4_1 = _forced_widget_names[arg_4_1]

	if not var_4_1 then
		var_4_1 = "forced_widget_" .. arg_4_1
		_forced_widget_names[arg_4_1] = var_4_1
	end

	local _widgets_by_name = self._widgets_by_name

	if not _widgets_by_name[var_4_1] then
		local _widgets = self._widgets
		local widget_create_func = var_0_0.widget_create_func()
		local var_4_5 = UIWidget.init(widget_create_func)

		_widgets[#_widgets + 1] = var_4_5
		_widgets_by_name[var_4_1] = var_4_5
	end

	return var_4_1
end

BossHealthUI._get_or_create_additional_widget_name = function (self, arg_5_1)
	-- function 5
	if arg_5_1 > BossHealthUI.MAX_NUM_ADDITIONAL_WIDGETS then
		return nil
	end

	local _additional_widget_names = self._additional_widget_names
	local var_5_1 = _additional_widget_names[arg_5_1]

	if not var_5_1 then
		var_5_1 = "additional_widget_" .. arg_5_1
		_additional_widget_names[arg_5_1] = var_5_1
	end

	local _widgets_by_name = self._widgets_by_name

	if not _widgets_by_name[var_5_1] then
		local _widgets = self._widgets
		local widget_create_func = var_0_0.widget_create_func(true)
		local var_5_5 = UIWidget.init(widget_create_func)

		_widgets[#_widgets + 1] = var_5_5
		_widgets_by_name[var_5_1] = var_5_5
	end

	return var_5_1
end

BossHealthUI._set_portrait_and_title = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local breed_name = arg_6_1.breed_name
	local var_6_1 = breed_textures[breed_name]

	var_6_1 = var_6_1 or "icons_placeholder"

	local var_6_2 = self._widgets_by_name[arg_6_1.widget_name]

	if not var_6_2 then
		local title_cached = var_6_2.content.title_cached
		local marked_cached = var_6_2.content.marked_cached

		if not (arg_6_1.dirty or title_cached ~= arg_6_3 or marked_cached == arg_6_2) then
			var_6_2.content.title_cached, var_6_2.content.marked_cached = arg_6_3, arg_6_2

			if not arg_6_2 then
				var_6_2.content.title_text = "{#grad(true);color(255,125,80,255);color2(234,77,29,255)}" .. Utf8.upper(arg_6_3)
			else
				var_6_2.content.title_text = Utf8.upper(Localize(arg_6_3))
			end
		end

		var_6_2.content.portrait = var_6_1
	end
end

local tbl_3 = {
	font_size = 20,
	upper_case = true,
	font_type = "hell_shark",
	divider_icon_width = 22
}

BossHealthUI._generate_attributes = function (self, arg_7_1, arg_7_2)
	-- function 7
	local var_7_0 = tbl_3
	local font_size = var_7_0.font_size
	local content = arg_7_2.content
	local attribute_offset_reference = content.attribute_offset_reference

	attribute_offset_reference = attribute_offset_reference or 0

	local num = attribute_offset_reference + 4
	local var_7_5 = num
	local num_2 = -40
	local num_3 = 24
	local num_4 = (num_3 - var_7_0.divider_icon_width) / 2

	for i, v in ipairs(arg_7_1) do
		content.attributes[i] = true
		content.num_attributes = i

		local str = "attribute_text_" .. i
		local var_7_10 = arg_7_2.style[str]

		if not var_7_10 then
			local var_7_11 = content.skull_dividers[i]

			if not var_7_11 then
				local var_7_12 = arg_7_2.style[var_7_11]

				var_7_12.offset[1] = var_7_5 + num_4
				var_7_12.offset[2] = num_2 - 13
				var_7_5 = var_7_5 + num_3
			end

			local str_2 = "{#grad(true);color(242,226,187,255);color2(255,125,80,255)}" .. v
			local get_text_width = UIUtils.get_text_width(self.ui_renderer, var_7_0, str_2)

			content[str] = str_2
			var_7_10.offset[1] = var_7_5
			var_7_10.font_size = font_size
			var_7_5 = var_7_5 + get_text_width

			if i % 3 == 0 then
				var_7_5 = num
				num_2 = num_2 - 16
			end
		end
	end

	local lower_marked_bg = arg_7_2.style.lower_marked_bg

	if not lower_marked_bg then
		if #arg_7_1 <= 4 then
			lower_marked_bg.offset[2] = -83 + var_7_0.font_size - 4
		else
			lower_marked_bg.offset[2] = -83
		end
	end

	return true
end

BossHealthUI._update_enemy_portrait_name_and_attributes = function (self, arg_8_1)
	-- function 8
	local unit = arg_8_1.unit
	local get_attributes = Managers.state.entity:system("ai_system"):get_attributes(unit)
	local grudge_marked = get_attributes.grudge_marked
	local breed_name = arg_8_1.breed_name
	local var_8_4 = Breeds[breed_name]

	var_8_4 = var_8_4 or PlayerBreeds[breed_name]

	local var_8_5
	local boss_health_ui_boss_phase_func = var_8_4.boss_health_ui_boss_phase_func

	if not boss_health_ui_boss_phase_func then
		local var_8_7, var_8_8 = boss_health_ui_boss_phase_func(unit)

		if not var_8_7 then
			if not (not var_8_8 and not (var_8_8 > 0)) then
				var_8_5 = string.format("%s (%s)", Localize(var_8_7), string.format(Localize("datetime_seconds_short"), var_8_8))
			else
				var_8_5 = Localize(var_8_7)
			end
		end
	end

	if not ((arg_8_1.dirty or not arg_8_1.cached_name) and var_8_5 ~= arg_8_1.cached_custom_attribute) then
		return arg_8_1.cached_name, grudge_marked
	end

	local var_8_9
	local var_8_10 = self._widgets_by_name[arg_8_1.widget_name]

	if not var_8_10 then
		table.clear(var_8_10.content.attributes)

		var_8_10.content.has_custom_attribute = not not boss_health_ui_boss_phase_func
	end

	local get_current_level_key = Managers.level_transition_handler:get_current_level_key()

	if not var_8_4 then
		-- Nothing
	end

	::label_8_0::

	local name_pool_by_level = var_8_4.name_pool_by_level

	name_pool_by_level = not name_pool_by_level and var_8_4.name_pool_by_level[get_current_level_key]

	::label_8_1::

	if not grudge_marked then
		local name_index = grudge_marked.name_index

		var_8_9 = TerrorEventUtils.get_grudge_marked_name(breed_name, name_index, get_attributes.breed_enhancements)
	elseif not name_pool_by_level then
		if not self._cached_pool_name_by_unit[unit] then
			var_8_9 = self._cached_pool_name_by_unit[unit]
		else
			local format = string.format("%s_%s", get_current_level_key, breed_name)
			local var_8_15 = self._name_pools[format]

			var_8_15 = var_8_15 or {}
			self._name_pools[format] = var_8_15

			if not table.is_empty(var_8_15) then
				table.append(var_8_15, name_pool_by_level)
			end

			local go_id = Managers.state.unit_storage:go_id(arg_8_1.unit)

			go_id = go_id or 0

			local next_random, var_8_18 = Math.next_random(go_id, 1, #var_8_15)

			var_8_9 = table.remove(var_8_15, var_8_18)
			self._cached_pool_name_by_unit[unit] = var_8_9
		end
	else
		var_8_9 = var_8_4.display_name or breed_name
	end

	if not var_8_10 then
		local tbl = {}

		if not grudge_marked and not get_attributes.breed_enhancements then
			for k in pairs(get_attributes.breed_enhancements) do
				local display_name = BreedEnhancements[k].display_name

				display_name = display_name or "missing_grudge_mark_name"
				tbl[#tbl + 1] = Utf8.upper(Localize(display_name))
			end
		end

		if not var_8_5 then
			tbl[#tbl + 1] = var_8_5
		end

		if not table.is_empty(tbl) then
			self:_generate_attributes(tbl, var_8_10)
		end
	end

	arg_8_1.cached_name = var_8_9
	arg_8_1.cached_custom_attribute = var_8_5

	return var_8_9, grudge_marked
end

local tbl_4 = {
	root_scenegraph_id = "pivot",
	label = "Boss health",
	registry_key = "boss_health",
	drag_scenegraph_id = "pivot_dragger"
}

BossHealthUI.update = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not HudCustomizer.run(self.ui_renderer, self.ui_scenegraph, tbl_4) then
		UISceneGraph.update_scenegraph(self.ui_scenegraph)
	end

	self:_update_proximity_boss()
	self:_sync_boss_unit_health(arg_9_1, arg_9_2)
	self:_update_animations(arg_9_1, arg_9_2)

	if not script_data.hide_boss_health_ui then
		self:_draw(arg_9_1, arg_9_2)
	end
end

BossHealthUI._update_proximity_boss = function (self)
	-- function 10
	local closest_boss_unit = Managers.state.entity:system("proximity_system").closest_boss_unit

	self:_event_register_boss_unit(closest_boss_unit, "proximity")
end

BossHealthUI._is_forced = function (self, arg_11_1)
	-- function 11
	for i, v in ipairs(self._detected_boss_units) do
		if v.unit ~= arg_11_1 or not v.forced then
			return true
		end
	end
end

BossHealthUI._has_forced = function (self)
	-- function 12
	return table.find_func(self._detected_boss_units, function (arg_13_0, arg_13_1)
		-- function 13
		return arg_13_1.forced
	end)
end

local tbl_5 = {}

BossHealthUI._num_healthbars = function (self)
	-- function 14
	local filter_array, var_14_1 = table.filter_array(self._detected_boss_units, function (self)
		-- function 15
		return self.show_health_bar
	end, tbl_5)

	return var_14_1
end

BossHealthUI._update_animations = function (self, arg_16_1, arg_16_2)
	-- function 16
	local _animations = self._animations

	for k, v in pairs(_animations) do
		if not UIAnimation.completed(v) then
			UIAnimation.update(v, arg_16_1)
		else
			_animations[k] = nil
		end
	end

	local _forced_animations = self._forced_animations

	for k_2, v_2 in pairs(_forced_animations) do
		if not UIAnimation.completed(v_2) then
			UIAnimation.update(v_2, arg_16_1)
		else
			_forced_animations[k_2] = nil
		end
	end
end

BossHealthUI._draw = function (self, arg_17_1, arg_17_2)
	-- function 17
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("Player")
	local render_settings = self.render_settings

	render_settings.alpha_multiplier = math.min(render_settings.alpha_multiplier + arg_17_1 * 5, 1)

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_17_1, nil, render_settings)

	local alpha_multiplier = render_settings.alpha_multiplier

	for k, v in pairs(self._detected_boss_units) do
		if not v.current_progress then
			local var_17_5 = self._widgets_by_name[v.widget_name]

			if not var_17_5 then
				v.alpha_multiplier = math.min(v.alpha_multiplier + arg_17_1 * 5, 1)
				render_settings.alpha_multiplier = v.alpha_multiplier

				UIRenderer.draw_widget(ui_renderer, var_17_5)
			end
		end
	end

	render_settings.alpha_multiplier = alpha_multiplier

	UIRenderer.end_pass(ui_renderer)
end

BossHealthUI._show_boss_health_bar = function (self, arg_18_1)
	-- function 18
	local unit = arg_18_1.unit
	local var_18_1
	local get_data = Unit.get_data(unit, "breed")

	if not get_data and not get_data.server_controlled_health_bar then
		local state = Managers.state
		local game = state.network:game()
		local go_id = state.unit_storage:go_id(unit)

		var_18_1 = not go_id and GameSession.game_object_field(game, go_id, "show_health_bar")
	else
		local get_attributes = Managers.state.entity:system("ai_system"):get_attributes(unit)

		var_18_1 = not get_data and get_data.show_health_bar or get_attributes.grudge_marked ~= nil
	end

	if arg_18_1.show_health_bar ~= var_18_1 then
		local _num_healthbars = self:_num_healthbars()

		arg_18_1.show_health_bar = var_18_1
		arg_18_1.dirty = true

		local render_settings = self.render_settings
		local flag

		flag = _num_healthbars ~= 0 or not 0 or self.render_settings.alpha_multiplier
		render_settings.alpha_multiplier = flag

		local flag_2

		flag_2 = _num_healthbars ~= 0 or not 0 or self.render_settings.alpha_multiplier
		arg_18_1.alpha_multiplier = flag_2

		self:_set_healing_amount(arg_18_1, 0, 0)

		arg_18_1.freeze_healing = false
		arg_18_1.next_update_is_instant = true
	end

	return var_18_1
end

BossHealthUI.on_spectator_target_changed = function (arg_19_0, arg_19_1)
	-- function 19
	return
end

BossHealthUI.on_force_add_boss_health_ui = function (self, arg_20_1)
	-- function 20
	self:_event_register_boss_unit(arg_20_1, "forced", true)
	self:_realign_forced_boss_widgets()

	if not Managers.player.is_server then
		if not Managers.state.network:game() then
			return
		end

		local go_id = Managers.state.unit_storage:go_id(arg_20_1)

		Managers.state.network.network_transmit:send_rpc_clients("rpc_add_forced_boss_health_ui", go_id)
	end
end

BossHealthUI.rpc_add_forced_boss_health_ui = function (self, arg_21_1, arg_21_2)
	-- function 21
	local unit = Managers.state.unit_storage:unit(arg_21_2)

	self:on_force_add_boss_health_ui(unit)
end

BossHealthUI._event_register_boss_unit = function (self, arg_22_1, arg_22_2, arg_22_3)
	-- function 22
	if not HEALTH_ALIVE[arg_22_1] then
		return
	end

	local find_func, var_22_1 = table.find_func(self._detected_boss_units, function (arg_23_0, arg_23_1)
		-- function 23
		return arg_23_1.unit == arg_22_1
	end)

	if not var_22_1 then
		local priority = var_22_1.priority
		local var_22_3 = tbl[arg_22_2]

		if priority < var_22_3 or var_22_3 ~= priority or not set[arg_22_2] then
			var_22_1.priority = var_22_3
			var_22_1.priority_t = Managers.time:time("ui")
		end

		return var_22_1
	end

	local tbl_2 = {
		alpha_multiplier = 0,
		unit = arg_22_1,
		priority = tbl[arg_22_2],
		priority_t = Managers.time:time("ui"),
		forced = arg_22_2 == "forced",
		breed_name = Unit.get_data(arg_22_1, "breed").name
	}

	self._detected_boss_units[#self._detected_boss_units + 1] = tbl_2

	if not tbl_2.forced then
		self:_realign_forced_boss_widgets()
	end

	if arg_22_2 ~= "sync" then
		local go_id = Managers.state.unit_storage:go_id(arg_22_1)

		if not go_id then
			local network_transmit = Managers.state.network.network_transmit

			if not Managers.player.is_server then
				network_transmit:send_rpc_clients("rpc_register_detected_boss", go_id)
			else
				network_transmit:send_rpc_server("rpc_register_detected_boss", go_id)
			end
		end
	end

	return tbl_2
end

local tbl_6 = {}

BossHealthUI._realign_forced_boss_widgets = function (self, arg_24_1)
	-- function 24
	table.clear(self._forced_animations)

	local flag

	flag = not arg_24_1 and 0 and 0.3

	local filter_array, var_24_2 = table.filter_array(self._detected_boss_units, function (self)
		-- function 25
		return self.forced
	end, tbl_6)
	local min = math.min(var_24_2, BossHealthUI.MAX_NUM_FORCED_WIDGETS)
	local num = 50
	local num_2 = 500
	local num_3 = -(min - 1) * 0.5 * (num_2 + num)

	for i = 1, min do
		local var_24_7 = filter_array[i]
		local var_24_8 = self._widgets_by_name[var_24_7.widget_name]

		if not var_24_8 then
			self._forced_animations["boss_ui_offset_" .. i] = UIAnimation.init(UIAnimation.function_by_time, var_24_8.offset, 1, var_24_8.offset[1], num_3, flag, math.easeOutCubic)
			num_3 = num_3 + num_2 + num
		end
	end
end

BossHealthUI._sync_boss_unit_health = function (self, arg_26_1, arg_26_2)
	-- function 26
	local _update_alive_units = self:_update_alive_units()
	local _update_prioritized_unit, var_26_2, var_26_3 = self:_update_prioritized_unit(arg_26_2)

	self:_preemptively_hide_widgets()

	if _update_alive_units or not var_26_2 then
		self:_realign_forced_boss_widgets(_update_alive_units)
	end

	local _has_forced = self:_has_forced()
	local num = 0
	local _detected_boss_units = self._detected_boss_units

	for i = 1, #_detected_boss_units do
		local var_26_7 = _detected_boss_units[i]

		if not _update_prioritized_unit then
			var_26_7.dirty = true
		end

		local unit = var_26_7.unit
		local dirty = var_26_7.dirty

		if var_26_7.prioritized or var_26_7.forced or not dirty then
			local _update_enemy_portrait_name_and_attributes, var_26_11 = self:_update_enemy_portrait_name_and_attributes(var_26_7)

			self:_set_portrait_and_title(var_26_7, var_26_11, _update_enemy_portrait_name_and_attributes)
		end

		local var_26_12 = self._widgets_by_name[var_26_7.widget_name]

		if not var_26_12 then
			if not var_26_7.forced then
				var_26_12.offset[2] = 0
			elseif not var_26_7.prioritized then
				var_26_12.offset[1] = num % 4 * var_0_0.total_bar_length * 0.25
				num = num + 1

				local num_2 = -80
				local var_26_14 = self._widgets_by_name[var_26_3.widget_name]

				if not var_26_14 then
					local num_attributes = var_26_14.content.num_attributes

					num_attributes = num_attributes or 0

					if num_attributes > 3 then
						num_2 = -100
					end
				end

				local num_3 = num_2 + (math.ceil(num / 4) - 1) * -60

				var_26_12.offset[2] = num_3
			end
		end

		local var_26_17
		local var_26_18
		local extension = ScriptUnit.extension(unit, "health_system")
		local current_health_percent = extension:current_health_percent()
		local clamp = math.clamp(current_health_percent, 0, 1)
		local current_max_health_percent = extension:current_max_health_percent()
		local num_4 = clamp * current_max_health_percent
		local var_26_24 = current_max_health_percent
		local var_26_25 = BreedActions[var_26_7.breed_name]

		if not var_26_25 then
			-- Nothing
		end

		::label_26_0::

		local downed = var_26_25.downed

		if not downed then
			downed = var_26_25.downed.freeze_healing
			downed = not downed and extension.state == "down"
		end

		::label_26_1::

		var_26_7.freeze_healing = downed

		local current_raw_progress = var_26_7.current_raw_progress
		local flag = false

		if not num_4 and not current_raw_progress and current_raw_progress < num_4 and not dirty then
			if not (self._last_rendered_prioritized_unit == unit or num_4) then
				-- Nothing
			end

			::label_26_2::

			local healing_start_progress = var_26_7.healing_start_progress

			if not healing_start_progress then
				healing_start_progress = var_26_7.current_progress
				healing_start_progress = healing_start_progress or num_4
			end

			::label_26_3::

			local flag_2 = not current_raw_progress and not (current_raw_progress < num_4) or arg_26_2

			self:_set_healing_amount(var_26_7, healing_start_progress, num_4, flag_2, arg_26_1)

			var_26_7.healing_start_progress = healing_start_progress
		end

		if num_4 ~= var_26_7.current_progress or num_4 ~= var_26_7.current_raw_progress or var_26_24 ~= var_26_7.current_max_health_fraction or not dirty then
			self:_set_bar_progress(var_26_7, num_4, var_26_24, flag, arg_26_1, arg_26_2)
		end

		self:_update_healing_bar(var_26_7, arg_26_1, arg_26_2, var_26_7.freeze_healing)
		self:_update_healing_effect(var_26_7, arg_26_1, arg_26_2)
		self:_set_health_edge_texture_position_progress(var_26_7)

		if not var_26_7.prioritized then
			self._last_rendered_prioritized_unit = var_26_7.unit
		end

		var_26_7.dirty = false

		if not var_26_12 then
			if not (var_26_7.prioritized or not (num > BossHealthUI.MAX_NUM_ADDITIONAL_WIDGETS)) then
				var_26_12.content.visible = false
			else
				local content = var_26_12.content
				local forced = var_26_7.forced

				forced = forced or not not _has_forced or self:_show_boss_health_bar(var_26_7)
				content.visible = forced
			end
		end
	end
end

BossHealthUI._update_alive_units = function (self)
	-- function 27
	local flag = false
	local _detected_boss_units = self._detected_boss_units

	for i = #_detected_boss_units, 1, -1 do
		local var_27_2 = _detected_boss_units[i]

		if not HEALTH_ALIVE[var_27_2.unit] then
			table.remove(_detected_boss_units, i)

			flag = true
		end
	end

	return flag
end

local tbl_7 = {}

BossHealthUI._update_prioritized_unit = function (self, arg_28_1)
	-- function 28
	local _detected_boss_units = self._detected_boss_units
	local flag = false
	local var_28_2
	local num = -math.huge
	local num_2 = -math.huge

	for i = #_detected_boss_units, 1, -1 do
		local var_28_5 = _detected_boss_units[i]

		var_28_5.prioritized = false

		local priority = var_28_5.priority
		local priority_t = var_28_5.priority_t
		local breed_name = var_28_5.breed_name
		local var_28_9 = Breeds[breed_name]

		var_28_9 = var_28_9 or PlayerBreeds[breed_name]

		local healthbar_timeout

		if not var_28_9 then
			healthbar_timeout = var_28_9.healthbar_timeout

			if not healthbar_timeout then
				-- Nothing
			end
		end

		healthbar_timeout = math.huge

		::label_28_0::

		if healthbar_timeout < arg_28_1 - priority_t then
			table.swap_delete(_detected_boss_units, i)
		elseif not self:_show_boss_health_bar(var_28_5) then
			if num < priority then
				var_28_2 = var_28_5
				num = priority
				num_2 = var_28_5.priority_t
			elseif not (priority ~= num or not (num_2 < priority_t)) then
				var_28_2 = var_28_5
				num_2 = priority_t
			end
		end
	end

	if not var_28_2 then
		var_28_2.prioritized = true

		if not (var_28_2.forced or var_28_2.widget_name == "prioritized_bar") then
			var_28_2.dirty = true
			var_28_2.widget_name = "prioritized_bar"
			flag = true
		end
	end

	local filter_array, var_28_12 = table.filter_array(_detected_boss_units, function (self)
		-- function 29
		return not not self.prioritized or not self.forced
	end, tbl_7)
	local num_3 = 0

	for j = 1, var_28_12 do
		local var_28_14 = filter_array[j]
		local breed_name_2 = var_28_14.breed_name
		local var_28_16 = Breeds[breed_name_2]

		var_28_16 = var_28_16 or PlayerBreeds[breed_name_2]

		local show_health_bar = var_28_14.show_health_bar

		show_health_bar = not show_health_bar and not var_28_16.disallow_additional_healthbar

		if not show_health_bar then
			num_3 = num_3 + 1
		end

		local _get_or_create_additional_widget_name

		if not show_health_bar then
			_get_or_create_additional_widget_name = self:_get_or_create_additional_widget_name(num_3)

			if not _get_or_create_additional_widget_name then
				-- Nothing
			end
		end

		_get_or_create_additional_widget_name = nil

		::label_28_1::

		if _get_or_create_additional_widget_name ~= var_28_14.widget_name then
			var_28_14.dirty = true
			var_28_14.widget_name = _get_or_create_additional_widget_name
			flag = true
		end
	end

	local flag_2 = false
	local filter_array_2, var_28_21 = table.filter_array(_detected_boss_units, function (self)
		-- function 30
		return self.forced
	end, tbl_7)

	for k = 1, var_28_21 do
		local var_28_22 = filter_array_2[k]
		local _get_or_create_forced_widget_name = self:_get_or_create_forced_widget_name(k)

		if _get_or_create_forced_widget_name ~= var_28_22.widget_name then
			var_28_22.dirty = true
			var_28_22.widget_name = _get_or_create_forced_widget_name
			flag_2 = true
			flag = true
		end
	end

	return flag, flag_2, var_28_2
end

BossHealthUI._preemptively_hide_widgets = function (self)
	-- function 31
	self._widgets_by_name.prioritized_bar.content.visible = false

	local _additional_widget_names = self._additional_widget_names

	for i = 1, #_additional_widget_names do
		local _get_or_create_additional_widget_name = self:_get_or_create_additional_widget_name(i)

		self._widgets_by_name[_get_or_create_additional_widget_name].content.visible = false
	end

	local _forced_widget_names = self._forced_widget_names

	for j = 1, #_forced_widget_names do
		local _get_or_create_forced_widget_name = self:_get_or_create_forced_widget_name(j)

		self._widgets_by_name[_get_or_create_forced_widget_name].content.visible = false
	end
end

BossHealthUI._set_bar_progress = function (self, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6)
	-- function 32
	arg_32_2 = arg_32_2 or 0

	local current_progress = arg_32_1.current_progress

	current_progress = current_progress or 1

	local healing_start_progress = arg_32_1.healing_start_progress

	healing_start_progress = healing_start_progress or current_progress + math.sign(arg_32_2 - current_progress) * (arg_32_5 * 0.3)
	arg_32_4 = arg_32_1.next_update_is_instant or arg_32_4

	if not arg_32_4 then
		healing_start_progress = arg_32_2
	elseif current_progress < arg_32_2 then
		healing_start_progress = math.min(healing_start_progress, arg_32_2)
	else
		healing_start_progress = math.max(healing_start_progress, arg_32_2)
	end

	arg_32_3 = arg_32_3 or 1

	local current_max_health_fraction = arg_32_1.current_max_health_fraction

	current_max_health_fraction = current_max_health_fraction or 1

	local num = current_max_health_fraction + math.sign(arg_32_3 - current_max_health_fraction) * (arg_32_5 * 0.3)

	if not arg_32_4 then
		num = arg_32_3
	elseif current_max_health_fraction < arg_32_3 then
		num = math.min(num, arg_32_3)
	else
		num = math.max(num, arg_32_3)
	end

	local var_32_4 = self._widgets_by_name[arg_32_1.widget_name]

	if not var_32_4 then
		local content = var_32_4.content
		local style = var_32_4.style
		local bar = style.bar
		local uvs = content.bar.uvs

		bar.size[1] = bar.default_size[1] * (healing_start_progress or 1)
		uvs[2][1] = healing_start_progress

		local dead_space_bar = style.dead_space_bar
		local uvs_2 = content.dead_space_bar.uvs
		local size = dead_space_bar.size
		local offset = dead_space_bar.offset
		local default_size = dead_space_bar.default_size

		size[1] = default_size[1] * (1 - (num or 1))
		uvs_2[1][1] = num
		offset[1] = content.dead_space_bar_offset_reference + default_size[1] - size[1]

		local dead_space_bar_divider = style.dead_space_bar_divider
		local offset_2 = dead_space_bar_divider.offset
		local default_width_offset = dead_space_bar_divider.default_width_offset

		offset_2[1] = content.dead_space_bar_divider_offset_reference + (default_size[1] - default_width_offset) - size[1]
		content.max_health_fraction = num
		content.health_fraction = healing_start_progress
	end

	arg_32_1.current_progress = healing_start_progress
	arg_32_1.current_raw_progress = arg_32_2
	arg_32_1.current_max_health_fraction = num
	arg_32_1.next_update_is_instant = nil
end

BossHealthUI._set_healing_amount = function (self, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5)
	-- function 33
	local var_33_0 = self._widgets_by_name[arg_33_1.widget_name]

	if not var_33_0 then
		local content = var_33_0.content
		local style = var_33_0.style
		local healing_bar = style.healing_bar
		local original_color = healing_bar.original_color

		original_color = original_color or table.shallow_copy(healing_bar.color)
		healing_bar.original_color = original_color

		local healing_bar_2 = content.healing_bar
		local size = healing_bar.size
		local offset = healing_bar.offset
		local uvs = healing_bar_2.uvs
		local num_3 = arg_33_3 - arg_33_2
		local num_4 = content.bar_length * num_3
		local num_5 = content.healing_bar_offset_reference + content.bar_length * arg_33_2

		uvs[1][1] = arg_33_2
		uvs[2][1] = arg_33_3

		local healing_bar_flash = style.healing_bar_flash
		local flag = false
		local breed_name = arg_33_1.breed_name
		local var_33_15 = Breeds[breed_name]

		var_33_15 = var_33_15 or PlayerBreeds[breed_name]

		if not var_33_15 and not var_33_15.reflect_regen_reduction_in_hp_bar then
			local has_extension = ScriptUnit.has_extension(arg_33_1.unit, "buff_system")

			if not has_extension then
				local flash_time = healing_bar.flash_time

				flash_time = flash_time or 0
				healing_bar.flash_time = flash_time

				local num_6 = 0.75
				local num_7 = 1 - math.clamp01(has_extension:apply_buffs_to_value(1, "healing_received"))

				if not (num_7 == 0 or num_7 == healing_bar.last_lerp_value) then
					healing_bar.flash_time = num_6
				end

				local inv_lerp_clamped = math.inv_lerp_clamped(num_6, 0, healing_bar.flash_time)

				if inv_lerp_clamped < 0.5 then
					healing_bar_flash.color[1] = 200 * math.ease_out_quad(inv_lerp_clamped * 2)
				elseif inv_lerp_clamped < 1 then
					healing_bar_flash.color[1] = 200 * math.ease_out_quad(1 - (inv_lerp_clamped - 0.5) * 2)
				end

				local num_8 = arg_33_3 - arg_33_2

				healing_bar_flash.offset[1] = healing_bar.offset[1] - UIFrameSettings.boss_hp_bar_heal_flash.texture_sizes.vertical[1] * num_8
				healing_bar_flash.size[1] = healing_bar_flash.default_size[1] * num_8 + UIFrameSettings.boss_hp_bar_heal_flash.texture_sizes.vertical[1] * 2 * num_8
				healing_bar.color[1] = math.lerp(healing_bar.original_color[2], 255, num_7)
				healing_bar.color[2] = math.lerp(healing_bar.original_color[2], 200, num_7)
				healing_bar.color[3] = math.lerp(healing_bar.original_color[3], 100, num_7)
				healing_bar.color[4] = math.lerp(healing_bar.original_color[4], 100, num_7)
				healing_bar.last_lerp_value = num_7

				if not arg_33_5 then
					healing_bar.flash_time = math.max(healing_bar.flash_time - arg_33_5, 0)
				end

				flag = true
			end
		end

		if not flag then
			healing_bar.color[2] = healing_bar.original_color[2]
			healing_bar.color[3] = healing_bar.original_color[3]
			healing_bar.color[4] = healing_bar.original_color[4]
			healing_bar.last_lerp_value = 1
			healing_bar.flash_time = 0
		end

		size[1] = num_4
		offset[1] = num_5
	end

	if not arg_33_4 then
		arg_33_1.healing_life_time = arg_33_4 + num
		arg_33_1.healing_effect_life_time = arg_33_4 + num_2
	end
end

BossHealthUI._update_healing_bar = function (self, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
	-- function 34
	local current_raw_progress = arg_34_1.current_raw_progress
	local healing_start_progress = arg_34_1.healing_start_progress

	if not (not healing_start_progress and current_raw_progress) then
		return
	end

	local var_34_2 = healing_start_progress

	if current_raw_progress <= healing_start_progress then
		var_34_2 = current_raw_progress
	elseif not (not arg_34_1.healing_life_time and not (arg_34_3 >= arg_34_1.healing_life_time) or arg_34_4) then
		var_34_2 = math.min(healing_start_progress + arg_34_2 * 0.5, current_raw_progress)
	end

	if not arg_34_4 then
		local unit = arg_34_1.unit
		local respawn_thresholds, var_34_5, var_34_6, var_34_7 = ScriptUnit.extension(unit, "health_system"):respawn_thresholds()

		var_34_2 = var_34_7
	end

	self:_set_healing_amount(arg_34_1, var_34_2, current_raw_progress, nil, arg_34_2)

	arg_34_1.healing_start_progress = var_34_2

	if var_34_2 == current_raw_progress then
		arg_34_1.healing_start_progress = nil
		arg_34_1.healing_life_time = nil
	end
end

BossHealthUI._set_health_edge_texture_position_progress = function (self, arg_35_1)
	-- function 35
	local healing_start_progress = arg_35_1.healing_start_progress

	if not healing_start_progress then
		healing_start_progress = arg_35_1.current_progress
		healing_start_progress = healing_start_progress or 0
	end

	local var_35_1 = self._widgets_by_name[arg_35_1.widget_name]

	if not var_35_1 then
		local content = var_35_1.content
		local bar_edge = var_35_1.style.bar_edge
		local offset = bar_edge.offset
		local default_width_offset = bar_edge.default_width_offset

		offset[1] = content.bar_edge_reference_offset + content.bar_length * healing_start_progress - default_width_offset
		content.bar_edge_fraction = healing_start_progress
	end
end

BossHealthUI._update_healing_effect = function (self, arg_36_1, arg_36_2, arg_36_3)
	-- function 36
	local num = 0

	if not arg_36_1.healing_effect_life_time then
		local inv_lerp_clamped = math.inv_lerp_clamped(arg_36_1.healing_effect_life_time - num_2, num_2, arg_36_3)
		local num_3 = 1 - inv_lerp_clamped

		num = 255 * math.ease_pulse(num_3)

		if inv_lerp_clamped == 0 then
			arg_36_1.healing_effect_life_time = nil
		end
	end

	self:_set_health_effect_alpha(arg_36_1, num)
end

BossHealthUI._set_health_effect_alpha = function (self, arg_37_1, arg_37_2)
	-- function 37
	local var_37_0 = self._widgets_by_name[arg_37_1.widget_name]

	if not var_37_0 then
		var_37_0.style.portrait_healing.color[1] = arg_37_2
	end
end

BossHealthUI.rpc_register_detected_boss = function (self, arg_38_1, arg_38_2)
	-- function 38
	local unit = Managers.state.unit_storage:unit(arg_38_2)

	if not ALIVE[unit] then
		self:_event_register_boss_unit(unit, "sync")

		if not Managers.state.network.is_server then
			Managers.state.network.network_transmit:send_rpc_clients_except("rpc_register_detected_boss", CHANNEL_TO_PEER_ID[arg_38_1], arg_38_2)
		end
	end
end
