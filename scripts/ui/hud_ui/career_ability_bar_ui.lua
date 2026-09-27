-- chunkname: @scripts/ui/hud_ui/career_ability_bar_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/career_ability_bar_ui_definitions")

CareerAbilityBarUI = class(CareerAbilityBarUI)

local flag = true

CareerAbilityBarUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self._platform = PLATFORM
	self._ui_renderer = arg_1_2.ui_renderer
	self._input_manager = arg_1_2.input_manager
	self._slot_equip_animations = {}
	self._slot_animations = {}
	self._ui_animations = {}

	self:_create_ui_elements()

	self._peer_id = arg_1_2.peer_id
	self._player_manager = arg_1_2.player_manager
	self._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	self._is_spectator = false
	self._spectated_player = nil
	self._spectated_player_unit = nil
	self._game_options_dirty = true

	local event = Managers.state.event

	event:register(self, "on_spectator_target_changed", "on_spectator_target_changed")
	event:register(self, "on_game_options_changed", "_set_game_options_dirty")
	self:_update_game_options()
end

CareerAbilityBarUI._get_ability_amount = function (arg_2_0, arg_2_1)
	-- function 2
	local current_ability_cooldown, var_2_1 = ScriptUnit.extension(arg_2_1, "career_system"):current_ability_cooldown()
	local num = 1 - current_ability_cooldown / var_2_1
	local num_2 = 0.25
	local num_3 = 0.8
	local num_4 = 0.3

	return num, num_2, num_3, num_4
end

CareerAbilityBarUI.on_spectator_target_changed = function (self, arg_3_1)
	-- function 3
	self._spectated_player_unit = arg_3_1
	self._spectated_player = Managers.player:owner(arg_3_1)
	self._is_spectator = true
end

CareerAbilityBarUI._set_player_extensions = function (self, arg_4_1)
	-- function 4
	self._inventory_extension = ScriptUnit.extension(arg_4_1, "inventory_system")
	self._initialize_ability_bar = true
end

CareerAbilityBarUI._update_career_ability = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not arg_5_1 then
		return
	end

	local player_unit = arg_5_1.player_unit

	if not Unit.alive(player_unit) then
		return
	end

	local extension = ScriptUnit.extension(player_unit, "inventory_system")

	if not extension:equipment() then
		return
	end

	if not (extension:get_wielded_slot_name() == "slot_career_skill_weapon") then
		return
	end

	local extension_2 = ScriptUnit.extension(player_unit, "career_system")
	local career_name = extension_2:career_name()
	local profile_index = extension_2:profile_index()
	local career_index = extension_2:career_index()

	if not CareerUtils.get_ability_data(profile_index, career_index, 1).show_gamepad_ability_bar then
		local _get_ability_amount, var_5_7, var_5_8, var_5_9 = self:_get_ability_amount(player_unit)

		self:_set_ability_bar_fraction(_get_ability_amount, var_5_7, var_5_8, var_5_9)

		return true
	end
end

CareerAbilityBarUI._create_ui_elements = function (self)
	-- function 6
	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local inventory_entry_definitions = var_0_0.inventory_entry_definitions

	self._ability_bar = UIWidget.init(var_0_0.widget_definitions.ability_bar)
	flag = false
end

CareerAbilityBarUI.update = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	if not flag then
		self:_create_ui_elements()
	end

	local _input_manager = self._input_manager

	if not ((_input_manager:is_device_active("gamepad") or UISettings.use_gamepad_hud_layout == "always") and UISettings.use_gamepad_hud_layout ~= "never") then
		return
	end

	self:_update_game_options()

	local _spectated_player

	if not self._is_spectator then
		_spectated_player = self._spectated_player

		if not _spectated_player then
			-- Nothing
		end
	end

	_spectated_player = arg_7_3

	::label_7_0::

	local _update_career_ability = self:_update_career_ability(_spectated_player, arg_7_1)
	local is_activated = Managers.twitch:is_activated()

	if is_activated ~= self._has_twitch then
		local offset = self._ability_bar.offset
		local flag_2

		flag_2 = not is_activated and 140 and 0
		offset[2] = flag_2
		self._has_twitch = is_activated
		_update_career_ability = true
	end

	if not _update_career_ability then
		local _ui_scenegraph = self._ui_scenegraph
		local get_service = _input_manager:get_service("ingame_menu")
		local get_crosshair_position, var_7_9 = self._parent:get_crosshair_position()

		self:_apply_crosshair_position(get_crosshair_position, var_7_9)

		local _ui_renderer = self._ui_renderer

		UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, get_service, arg_7_1, nil, self._render_settings)
		UIRenderer.draw_widget(_ui_renderer, self._ability_bar)
		UIRenderer.end_pass(_ui_renderer)
	end
end

local tbl = {
	normal = {
		255,
		223,
		133,
		228
	},
	medium = {
		255,
		223,
		133,
		228
	},
	high = {
		255,
		223,
		133,
		228
	}
}

CareerAbilityBarUI._set_ability_bar_fraction = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	local _ability_bar = self._ability_bar
	local style = _ability_bar.style
	local content = _ability_bar.content
	local size = content.size
	local lerp = math.lerp
	local internal_gradient_threshold = content.internal_gradient_threshold

	internal_gradient_threshold = internal_gradient_threshold or 0
	arg_8_1 = lerp(internal_gradient_threshold, math.min(arg_8_1, 1), 0.3)
	content.internal_gradient_threshold = arg_8_1

	local num = 0
	local num_2 = 1
	local num_3 = math.min(arg_8_1, arg_8_2) * num_2
	local num_4 = math.min(arg_8_1, arg_8_3) * num_2
	local num_5 = arg_8_1 * num_2

	style.bar_1.gradient_threshold = num_5

	local num_6 = 1
	local var_8_12
	local color = style.icon.color
	local color_2 = style.bar_1.color

	if arg_8_1 <= arg_8_2 then
		var_8_12 = tbl.normal
	elseif arg_8_1 <= arg_8_3 then
		var_8_12 = tbl.medium
	else
		var_8_12 = tbl.high
	end

	color_2[1] = var_8_12[1]
	color_2[2] = var_8_12[2]
	color_2[3] = var_8_12[3]
	color_2[4] = var_8_12[4]

	local num_7 = 10
	local num_8 = 1 - arg_8_1
	local min = math.min(math.max(num_8 - arg_8_3, 0) / (1 - arg_8_3) * 1.3, 1)
	local min_2 = math.min(math.max(num_8 - arg_8_4, 0) / (1 - arg_8_4) * 1.3, 1)
	local num_9 = 100 + (0.5 + math.sin(Managers.time:time("ui") * num_7) * 0.5) * 155

	style.frame.color[1] = num_9 * min
	color[1] = num_9 * min_2
	color[2] = 255
	color[3] = 255
	color[4] = 255
	style.input_text.text_color[1] = num_9 * min_2
	style.input_text_shadow.text_color[1] = num_9 * min_2 * min_2
	style.ability_bar_highlight.texture_size[1] = 250 * arg_8_1

	local num_10 = Managers.time:time("main") * 0.25

	content.ability_bar_highlight.uvs[1][1] = num_10 % 1
	content.ability_bar_highlight.uvs[2][1] = (0.5 + num_10) % 1
end

CareerAbilityBarUI.destroy = function (arg_9_0)
	-- function 9
	local event = Managers.state.event

	event:unregister("on_spectator_target_changed", arg_9_0)
	event:unregister("on_game_options_changed", arg_9_0)
end

CareerAbilityBarUI.set_alpha = function (arg_10_0, arg_10_1)
	-- function 10
	arg_10_0._render_settings.alpha_multiplier = arg_10_1
end

CareerAbilityBarUI._apply_crosshair_position = function (self, arg_11_1, arg_11_2)
	-- function 11
	local str = "screen_bottom_pivot"
	local local_position = self._ui_scenegraph[str].local_position

	local_position[1] = arg_11_1
	local_position[2] = arg_11_2
end

CareerAbilityBarUI._set_game_options_dirty = function (self)
	-- function 12
	self._game_options_dirty = true
end

CareerAbilityBarUI._update_game_options = function (self)
	-- function 13
	if not self._game_options_dirty then
		return
	end

	self:_update_gamepad_input_button()

	self._game_options_dirty = false
end

CareerAbilityBarUI._update_gamepad_input_button = function (self)
	-- function 14
	local get_service = Managers.input:get_service("Player")
	local str = "weapon_reload_input"
	local flag = true
	local get_gamepad_input_texture_data, var_14_4, var_14_5, var_14_6 = UISettings.get_gamepad_input_texture_data(get_service, str, flag)
	local _ability_bar = self._ability_bar
	local style = _ability_bar.style
	local content = _ability_bar.content

	if not get_gamepad_input_texture_data then
		content.icon = get_gamepad_input_texture_data.texture
		content.input_text = ""

		local texture_size = style.icon.texture_size
		local texture_size_2 = style.icon_shadow.texture_size
		local size = get_gamepad_input_texture_data.size

		texture_size[1] = size[1]
		texture_size[2] = size[2]
		texture_size_2[1] = size[1]
		texture_size_2[2] = size[2]
	end
end
