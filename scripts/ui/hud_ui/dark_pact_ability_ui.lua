-- chunkname: @scripts/ui/hud_ui/dark_pact_ability_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/dark_pact_ability_ui_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local create_ability_widget = var_0_0.create_ability_widget
local profile_ability_templates = var_0_0.profile_ability_templates

DarkPactAbilityUI = class(DarkPactAbilityUI)

DarkPactAbilityUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self._ui_renderer = arg_1_2.ui_renderer
	self._ingame_ui = arg_1_2.ingame_ui
	self._input_manager = arg_1_2.input_manager
	self._peer_id = arg_1_2.peer_id
	self._player_manager = arg_1_2.player_manager
	self._ui_animations = {}
	self._render_settings = {
		snap_pixel_positions = true
	}

	local world = Managers.world:world("level_world")

	self._world = world
	self._wwise_world = Managers.world:wwise_world(world)
	self._is_in_inn = arg_1_2.is_in_inn

	self:_create_ui_elements()

	self._ability_events = {}

	local event = Managers.state.event

	event:register(self, "input_changed", "event_input_changed")
	event:register(self, "on_spectator_target_changed", "on_spectator_target_changed")
end

DarkPactAbilityUI._create_ui_elements = function (self)
	-- function 2
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(var_0_0.widget_definitions) do
		local var_2_2 = UIWidget.init(v)

		tbl_2[k] = var_2_2
		tbl[#tbl + 1] = var_2_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2
	self._widgets_by_ability_name = {}
	self._career_ability_widgets_by_name = {}
	self._ability_hud_widgets_by_name = {}

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)
end

DarkPactAbilityUI._setup_activated_ability = function (self)
	-- function 3
	local _get_player_unit, var_3_1 = self:_get_player_unit()

	if not var_3_1 then
		return
	end

	local extension = ScriptUnit.extension(var_3_1, "career_system")
	local get_activated_ability_data = extension:get_activated_ability_data()
	local career_name = extension:career_name()

	if not (not get_activated_ability_data and career_name) then
		return
	end

	self._career_name = career_name
	self._initialized = true
end

DarkPactAbilityUI._get_extension = function (self, arg_4_1)
	-- function 4
	local _get_player_unit, var_4_1 = self:_get_player_unit()

	if not var_4_1 and not Unit.alive(var_4_1) then
		return ScriptUnit.extension(var_4_1, arg_4_1)
	end
end

DarkPactAbilityUI._update_abilities = function (self, arg_5_1, arg_5_2)
	-- function 5
	local _get_extension = self:_get_extension("career_system")
	local _get_extension_2 = self:_get_extension("versus_horde_ability_system")
	local flag = not _get_extension and _get_extension:career_name()
	local _ui_renderer = self._ui_renderer

	if self._career_name ~= flag then
		table.clear(self._ability_hud_widgets_by_name)

		self._initialized = false

		return
	end

	local _get_player_unit, var_5_5 = self:_get_player_unit()
	local has_extension = ScriptUnit.has_extension(var_5_5, "ghost_mode_system")
	local flag_2 = not has_extension and has_extension:is_in_ghost_mode()

	self:_handle_career_abilities(arg_5_1, arg_5_2, flag, _get_extension, _get_extension_2, _ui_renderer, flag_2)
end

DarkPactAbilityUI.destroy = function (self)
	-- function 6
	local event = Managers.state.event

	event:unregister("input_changed", self)
	event:unregister("on_spectator_target_changed", self)

	for k, v in pairs(self._ability_events) do
		event:unregister(k, self)
	end

	self:set_visible(false)
	print("[DarkPactAbilityUI] - Destroy")
end

DarkPactAbilityUI.set_visible = function (self, arg_7_1)
	-- function 7
	self._is_visible = arg_7_1

	self:_set_elements_visible(arg_7_1)
end

DarkPactAbilityUI._set_elements_visible = function (self, arg_8_1)
	-- function 8
	local _ui_renderer = self._ui_renderer

	for i, v in ipairs(self._widgets) do
		UIRenderer.set_element_visible(_ui_renderer, v.element, arg_8_1)
	end

	local _ability_widgets = self._ability_widgets

	if not _ability_widgets then
		for i_2, v_2 in ipairs(_ability_widgets) do
			UIRenderer.set_element_visible(_ui_renderer, v_2.element, arg_8_1)
		end
	end

	self._retained_elements_visible = arg_8_1

	self:set_dirty()
end

DarkPactAbilityUI._handle_gamepad = function (arg_9_0)
	-- function 9
	return true
end

DarkPactAbilityUI.update = function (self, arg_10_1, arg_10_2)
	-- function 10
	if not self._is_visible then
		return
	end

	if not self._initialized then
		self:_setup_activated_ability()

		return
	end

	if not self:_handle_gamepad() then
		return
	end

	self:_handle_resolution_modified()
	self:draw(arg_10_1, arg_10_2)
end

DarkPactAbilityUI._handle_resolution_modified = function (self)
	-- function 11
	if not RESOLUTION_LOOKUP.modified then
		self:_on_resolution_modified()
	end
end

DarkPactAbilityUI._on_resolution_modified = function (self)
	-- function 12
	for i, v in ipairs(self._widgets) do
		self:_set_widget_dirty(v)
	end

	self:set_dirty()
end

DarkPactAbilityUI.draw = function (self, arg_13_1, arg_13_2)
	-- function 13
	if not self._is_visible then
		return
	end

	local _get_player_unit, var_13_1 = self:_get_player_unit()
	local flag = not _get_player_unit and _get_player_unit:profile_index()
	local flag_2 = not flag and SPProfiles[flag]

	if not (not flag_2 and flag_2.affiliation == "dark_pact") then
		self:set_visible(false)

		return
	end

	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local get_service = self._input_manager:get_service("ingame_menu")

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, get_service, arg_13_1, nil, self._render_settings)
	self:_update_abilities(arg_13_1, arg_13_2)

	local _ability_widgets = self._ability_widgets

	if not _ability_widgets then
		for i, v in ipairs(_ability_widgets) do
			UIRenderer.draw_widget(_ui_renderer, v)
		end
	end

	for i_2, v_2 in ipairs(self._widgets) do
		UIRenderer.draw_widget(_ui_renderer, v_2)
	end

	if not self._career_ability_widgets_by_name then
		for k, v_3 in pairs(self._career_ability_widgets_by_name) do
			UIRenderer.draw_widget(_ui_renderer, v_3)
		end
	end

	UIRenderer.end_pass(_ui_renderer)

	self._dirty = false
end

DarkPactAbilityUI.set_dirty = function (self)
	-- function 14
	self._dirty = true
end

DarkPactAbilityUI._set_widget_dirty = function (arg_15_0, arg_15_1)
	-- function 15
	arg_15_1.element.dirty = true
end

DarkPactAbilityUI._play_sound = function (self, arg_16_1)
	-- function 16
	WwiseWorld.trigger_event(self._wwise_world, arg_16_1)
end

DarkPactAbilityUI.event_input_changed = function (self)
	-- function 17
	local str = "action_career"
	local _ability_widgets = self._ability_widgets

	if not _ability_widgets then
		for i, v in ipairs(_ability_widgets) do
			local input_action = v.content.input_action

			input_action = input_action or str

			self:_set_input(v, input_action)
			self:_set_widget_dirty(v)
		end
	end

	self:set_dirty()
end

DarkPactAbilityUI._set_input = function (self, arg_18_1, arg_18_2)
	-- function 18
	local _get_input_texture_data, var_18_1, var_18_2 = self:_get_input_texture_data(arg_18_2)
	local num = 100
	local input_text = arg_18_1.style.input_text
	local _ui_renderer = self._ui_renderer

	var_18_1 = not var_18_1 and UIRenderer.crop_text_width(_ui_renderer, var_18_1, num, input_text)
	arg_18_1.content.input_text = var_18_1 or ""
	arg_18_1.content.input_action = arg_18_2
end

DarkPactAbilityUI._get_input_texture_data = function (self, arg_19_1)
	-- function 19
	local _input_manager = self._input_manager
	local get_service = _input_manager:get_service("Player")
	local is_device_active = _input_manager:is_device_active("gamepad")
	local PLATFORM = PLATFORM

	if not IS_WINDOWS and not is_device_active then
		PLATFORM = "xb1"
	end

	local get_keymapping = get_service:get_keymapping(arg_19_1, PLATFORM)

	if not get_keymapping then
		Application.warning(string.format("[DarkPactAbilityUI] There is no keymap for %q on %q", arg_19_1, PLATFORM))

		return nil, ""
	end

	local var_19_5 = get_keymapping[1]
	local var_19_6 = get_keymapping[2]
	local var_19_7 = get_keymapping[3]
	local var_19_8

	if var_19_7 == "held" then
		var_19_8 = "matchmaking_prefix_hold"
	end

	local flag = var_19_6 == UNASSIGNED_KEY
	local str = ""

	if var_19_5 == "keyboard" then
		str = not flag and "" and Keyboard.button_locale_name(var_19_6)

		return nil, str, var_19_8
	elseif var_19_5 == "mouse" then
		str = not flag and "" and Mouse.button_name(var_19_6)

		return nil, str, var_19_8
	elseif var_19_5 == "gamepad" then
		str = not flag and "" and Pad1.button_name(var_19_6)

		return ButtonTextureByName(str, PLATFORM), str, var_19_8
	end

	return nil, str
end

DarkPactAbilityUI._update_ability_animations = function (self, arg_20_1, arg_20_2)
	-- function 20
	if not self._is_visible then
		return false
	end

	local style = arg_20_1.style
	local num = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

	style.icon_cooldown.color[1] = math.max(style.icon_cooldown.color[1] - arg_20_2 * 400, 0)
	style.icon.color[1] = 155 + num * 100

	self:_set_widget_dirty(arg_20_1)

	return true
end

DarkPactAbilityUI.set_alpha = function (self, arg_21_1)
	-- function 21
	for k, v in pairs(self._widgets) do
		self:_set_widget_dirty(v)
	end

	self._render_settings.alpha_multiplier = arg_21_1

	self:set_dirty()
end

DarkPactAbilityUI._get_player_unit = function (self)
	-- function 22
	if not self._is_spectator then
		return self._spectated_player, self._spectated_player_unit
	end

	if not self._player then
		return self._player, self._player.player_unit
	end

	self._player = self._player_manager:local_player(1)

	return self._player, self._player.player_unit
end

DarkPactAbilityUI.on_spectator_target_changed = function (self, arg_23_1)
	-- function 23
	self._spectated_player_unit = arg_23_1
	self._spectated_player = Managers.player:owner(arg_23_1)
	self._is_spectator = true

	if Managers.state.side:get_side_from_player_unique_id(self._spectated_player:unique_id()):name() == "dark_pact" then
		self:set_visible(true)
	else
		self:set_visible(false)
	end
end

DarkPactAbilityUI.event_on_dark_pact_ammo_changed = function (self, arg_24_1, arg_24_2)
	-- function 24
	local _ability_hud_widgets_by_name = self._ability_hud_widgets_by_name

	_ability_hud_widgets_by_name = not _ability_hud_widgets_by_name and self._ability_hud_widgets_by_name[2]

	if not _ability_hud_widgets_by_name then
		return
	end

	local ammo = _ability_hud_widgets_by_name.ammo

	if not ammo then
		return
	end

	if not arg_24_2 then
		local attack_pattern_data = BLACKBOARDS[arg_24_1].attack_pattern_data

		attack_pattern_data = attack_pattern_data or {}

		if not attack_pattern_data.current_ammo then
			arg_24_2 = attack_pattern_data.current_ammo
		else
			arg_24_2 = Unit.get_data(arg_24_1, "breed").max_ammo
		end
	end

	local num = 0
	local content = ammo.content
	local flag

	flag = arg_24_2 + num == 0

	local flag_2 = false

	if self._ammo_count ~= arg_24_2 then
		self._ammo_count = arg_24_2
		content.current_ammo = tostring(arg_24_2)

		local flag_3 = true
	end

	if self._remaining_ammo ~= num then
		local max_ammo = Unit.get_data(arg_24_1, "breed").max_ammo

		self._remaining_ammo = max_ammo
		content.remaining_ammo = tostring(max_ammo)

		local flag_4 = true
	end
end

DarkPactAbilityUI._handle_career_abilities = function (self, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6, arg_25_7)
	-- function 25
	local _get_player_unit, var_25_1 = self:_get_player_unit()
	local profile_index = _get_player_unit:profile_index()
	local career_index = _get_player_unit:career_index()
	local career_info_settings = SPProfiles[profile_index].careers[career_index].career_info_settings
	local count = #career_info_settings
	local flag = not arg_25_4 and arg_25_4:career_name()
	local _widgets_by_ability_name = self._widgets_by_ability_name
	local var_25_8 = profile_ability_templates[flag]
	local _get_extension = self:_get_extension("status_system")
	local flag_2 = true

	if not (not _get_extension and _get_extension:is_dead()) then
		flag_2 = false
	end

	local num = -(80 * count * 0.5)

	for i = 1, #var_25_8 do
		if not self._ability_hud_widgets_by_name[i] then
			local var_25_12 = var_25_8[i]
			local widget_definitions = var_25_12.widget_definitions
			local tbl = {}

			for k, v in pairs(widget_definitions) do
				tbl[k] = UIWidget.init(v)
			end

			local ability_icon = tbl.ability_icon

			if not ability_icon then
				ability_icon.content.settings = career_info_settings[i]
				ability_icon.offset[1] = num + 80 * (i - 1)
			end

			if not var_25_12.events then
				local events = var_25_12.events

				for k_2, v_2 in pairs(events) do
					self._ability_events[#self._ability_events + 1] = {
						k_2,
						v_2
					}

					Managers.state.event:register(self, k_2, v_2)
				end
			end

			self._ability_hud_widgets_by_name[#self._ability_hud_widgets_by_name + 1] = tbl
		end
	end

	local abilities_detail_left = self._widgets_by_name.abilities_detail_left
	local abilities_detail_right = self._widgets_by_name.abilities_detail_right

	abilities_detail_left.offset[1] = num - 88 + 20
	abilities_detail_right.offset[1] = num + 80 * count - 20
	abilities_detail_left.content.visible = not arg_25_7
	abilities_detail_right.content.visible = not arg_25_7

	for i5 = 1, #var_25_8 do
		local var_25_19 = var_25_8[i5]
		local update_functions = var_25_19.update_functions
		local var_25_21 = self._ability_hud_widgets_by_name[i5]

		for k_3, v_3 in pairs(var_25_21) do
			local flag_3 = not update_functions and update_functions[k_3]

			if not flag_3 then
				if not var_25_19.ability_name then
					local ability_by_name, var_25_24 = arg_25_4:ability_by_name(var_25_19.ability_name)

					if not (not arg_25_7 and ability_by_name.draw_ui_in_ghost_mode or arg_25_7) then
						flag_3(arg_25_1, arg_25_2, arg_25_6, arg_25_4, var_25_24, v_3, flag_2, var_25_1, arg_25_5)
					end
				end
			elseif not (flag_2 or arg_25_7) then
				UIRenderer.draw_widget(arg_25_6, v_3)
			end
		end
	end
end
