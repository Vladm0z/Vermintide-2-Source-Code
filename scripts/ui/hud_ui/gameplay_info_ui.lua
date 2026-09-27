-- chunkname: @scripts/ui/hud_ui/gameplay_info_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/gameplay_info_ui_definitions")
local scenegraph = var_0_0.scenegraph
local widgets = var_0_0.widgets
local spawn_info_widgets = var_0_0.spawn_info_widgets
local animation_definitions = var_0_0.animation_definitions

GameplayInfoUI = class(GameplayInfoUI)

GameplayInfoUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self._ui_renderer = arg_1_2.ui_renderer
	self._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	self._first_time = true
	self._world = arg_1_2.world_manager:world("level_world")
	self._wwise_world = Managers.world:wwise_world(self._world)

	self:_create_ui_elements()
	Managers.state.event:register(self, "add_gameplay_info_event", "add_gameplay_info_event", "update_range_to_spawn", "on_update_range_to_spawn")
end

GameplayInfoUI.add_gameplay_info_event = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	self._active_event = arg_2_1
	self._active_reason = arg_2_3
	self._show = arg_2_2
	self._target_unit = arg_2_4

	self:_update_button_prompts()

	if not self._first_time then
		-- Nothing
	end
end

GameplayInfoUI._update_spawn_info_texts = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local spawn_text = self._widgets_by_name.spawn_text
	local spawn_reason = self._widgets_by_name.spawn_reason

	spawn_text.content.text = not arg_3_1 and arg_3_1 and ""
	spawn_text.content.visible = arg_3_1 ~= nil
	spawn_reason.content.text = not arg_3_2 and arg_3_2 and ""
	spawn_reason.content.visible = arg_3_2 ~= nil
end

GameplayInfoUI._update_selected_career_data = function (self)
	-- function 4
	local _get_current_selected_career_data, var_4_1 = self:_get_current_selected_career_data()
	local content = self._widgets_by_name.spawn_help.content

	content.portrait = var_4_1
	content.pick_name = Localize(_get_current_selected_career_data)
end

GameplayInfoUI._update_button_prompts = function (self)
	-- function 5
	local _active_event = self._active_event
	local _active_reason = self._active_reason

	if not self._show then
		return
	end

	if not _active_event then
		return
	end

	local var_5_2
	local var_5_3
	local var_5_4
	local var_5_5
	local var_5_6
	local var_5_7
	local flag = false

	if _active_event == "ghost_spawn" then
		local str = "Player"
		local str_2 = "ghost_mode_exit"
		local str_3 = "$KEY;%s__%s:"
		local get_service = Managers.input:get_service(str)
		local get_gamepad_input_texture_data, var_5_14, var_5_15 = UISettings.get_gamepad_input_texture_data(get_service, str_2, self._gamepad_active)
		local str_4 = ""

		if not self._gamepad_active then
			str_4 = string.format(str_3, str, str_2)
		elseif not var_5_15 and var_5_15[1] == "mouse" and not self._gamepad_active then
			str_4 = string.format(str_3, str, str_2)
		else
			str_4 = not var_5_14 and "{#color(193,91,36)}[" .. var_5_14 .. "] {#reset()}" and ""
		end

		var_5_4 = string.format(Localize("versus_gameplay_info_spawn_here"), str_4)
		var_5_6 = {
			175,
			0,
			255,
			0
		}
	elseif _active_event == "ghost_cantspawn" then
		var_5_5 = {
			175,
			141,
			141,
			141
		}
		var_5_6 = {
			175,
			141,
			141,
			141
		}
		var_5_4 = string.format(Localize("versus_gameplay_info_unable_to_spawn"), var_5_5[2], var_5_5[3], var_5_5[4], var_5_5[1])

		if _active_reason == "range" then
			var_5_7 = Localize("vs_spawning_hero_range")
			var_5_7 = var_5_7 .. self._range or 20
		elseif _active_reason == "los" then
			var_5_7 = Localize("vs_spawning_hero_los")
		elseif _active_reason == "start_zone" then
			var_5_7 = Localize("vs_spawning_hero_start_zone")
		elseif _active_reason == "transport" then
			var_5_7 = Localize("vs_spawning_hero_transport")
		elseif _active_reason == "w8_to_spawn" then
			var_5_7 = Localize("vs_spawning_w8_to_spawn")
		elseif _active_reason == "in_safe_zone" then
			var_5_7 = "Can't spawn in hero safe zone"
		else
			var_5_7 = Localize("vs_spawning_w8_to_spawn")
		end
	elseif _active_event == "ghost_catchup" then
		self:_update_catchup_tele_prompt()

		return
	elseif _active_event == "hide_teleport" then
		local flag_2 = true
		local str_5 = "Player"
		local str_6 = "ghost_mode_enter"
		local str_7 = ""

		self:_set_tele_prompt(str_5, str_6, str_7, nil, var_5_5, flag_2)

		return
	elseif _active_event == "hide_text" then
		local flag_3 = true
	end

	self:_update_spawn_info_texts(var_5_4, var_5_7, var_5_6)
end

GameplayInfoUI._set_sub_text = function (self, arg_6_1)
	-- function 6
	local ghost_mode_text_sub = self._widgets_by_name.ghost_mode_text_sub

	ghost_mode_text_sub.content.text = arg_6_1 or ""
	ghost_mode_text_sub.content.visible = arg_6_1 ~= nil
end

GameplayInfoUI._create_ui_elements = function (self)
	-- function 7
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph)
	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)
	self._animations = {}

	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}

	for k, v in pairs(widgets) do
		local var_7_3 = UIWidget.init(v)

		tbl_2[k] = var_7_3
		tbl[#tbl + 1] = var_7_3
	end

	for k_2, v_2 in pairs(spawn_info_widgets) do
		local var_7_4 = UIWidget.init(v_2)

		tbl_2[k_2] = var_7_4
		tbl_3[#tbl_3 + 1] = var_7_4
	end

	self._widgets = tbl
	self._spawn_info_widgets = tbl_3
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)
end

GameplayInfoUI.destroy = function (arg_8_0)
	-- function 8
	local event = Managers.state.event

	event:unregister("add_gameplay_info_event", arg_8_0)
	event:unregister("update_range_to_spawn", arg_8_0)
end

GameplayInfoUI.on_update_range_to_spawn = function (self, arg_9_1)
	-- function 9
	arg_9_1 = math.max(arg_9_1, 1)
	self._range = string.format("%2dm", arg_9_1)

	self:_update_button_prompts()
end

GameplayInfoUI.update = function (self, arg_10_1, arg_10_2)
	-- function 10
	local _animations = self._animations
	local _ui_animator = self._ui_animator
	local is_device_active = Managers.input:is_device_active("gamepad")

	if is_device_active ~= self._gamepad_active then
		self._gamepad_active = is_device_active

		self:_update_button_prompts()
		self:_update_catchup_tele_prompt()
	end

	_ui_animator:update(arg_10_1)

	for k, v in pairs(_animations) do
		local id = v.id

		if not _ui_animator:is_animation_completed(id) then
			_ui_animator:stop_animation(id)

			self._animations[k] = nil
		end
	end

	self:_draw(arg_10_1)
end

GameplayInfoUI._draw = function (self, arg_11_1)
	-- function 11
	if not self._show then
		return
	end

	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local get_service = Managers.input:get_service("ingame_menu")
	local _render_settings = self._render_settings

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, get_service, arg_11_1, nil, _render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(_ui_renderer, v)
	end

	local player_unit = Managers.player:local_player().player_unit
	local flag = not player_unit and ScriptUnit.has_extension(player_unit, "ghost_mode_system")

	if not (not flag and flag:is_in_ghost_mode()) then
		for i_2, v_2 in ipairs(self._spawn_info_widgets) do
			UIRenderer.draw_widget(_ui_renderer, v_2)
		end
	end

	UIRenderer.end_pass(_ui_renderer)
end

GameplayInfoUI._set_tele_prompt = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	-- function 12
	local _widgets_by_name = self._widgets_by_name
	local _ui_scenegraph = self._ui_scenegraph
	local input = Managers.input
	local _ui_renderer = self._ui_renderer
	local flag = not arg_12_1 and input:get_service(arg_12_1)
	local is_device_active = input:is_device_active("gamepad")
	local teleport_text = _widgets_by_name.teleport_text
	local var_12_7
	local var_12_8

	if not (not arg_12_2 and arg_12_6) then
		local get_gamepad_input_texture_data

		get_gamepad_input_texture_data, var_12_8 = UISettings.get_gamepad_input_texture_data(flag, arg_12_2, is_device_active)
	end

	local str = " %s %s "
	local str_2 = ""

	if not is_device_active then
		str_2 = "$KEY;" .. arg_12_1 .. "__" .. arg_12_2 .. ":"
	else
		str_2 = not var_12_8 and "{#color(193,91,36)}[" .. var_12_8 .. "] {#reset()}" and ""
	end

	teleport_text.content.text = string.format(str, str_2, arg_12_3)
	teleport_text.content.visible = not arg_12_6
end

GameplayInfoUI._start_animation = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local tbl = {
		wwise_world = self._wwise_world,
		render_settings = self._render_settings,
		ui_scenegraph = self._ui_scenegraph
	}
	local start_animation = self._ui_animator:start_animation(arg_13_1, arg_13_3, scenegraph, tbl)

	self._animations[arg_13_2] = {
		id = start_animation,
		name = arg_13_1
	}
end

GameplayInfoUI._update_catchup_tele_prompt = function (self)
	-- function 14
	local str = "Player"
	local str_2 = "ghost_mode_enter"
	local var_14_2 = Localize("vs_spawning_ghost_catchup")

	self:_set_tele_prompt(str, str_2, var_14_2)
end
