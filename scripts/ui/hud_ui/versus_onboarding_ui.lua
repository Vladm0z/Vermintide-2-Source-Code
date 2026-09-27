-- chunkname: @scripts/ui/hud_ui/versus_onboarding_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/versus_onboarding_ui_definitions")
local scenegraph = var_0_0.scenegraph
local widgets = var_0_0.widgets
local animations_definitions = var_0_0.animations_definitions

VersusOnboardingUI = class(VersusOnboardingUI)

VersusOnboardingUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self._ui_renderer = arg_1_2.ui_renderer
	self._input_manager = arg_1_2.input_manager
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._player_manager = arg_1_2.player_manager
	self._profile_synchronizer = arg_1_2.profile_synchronizer

	local player = arg_1_2.player

	self._player = player
	self._peer_id = player:network_id()
	self._local_player_id = player:local_player_id()
	self._local_player = self._player_manager:local_player()
	self._side = Managers.state.side:get_side_from_player_unique_id(player:unique_id())
	self._gamepad_active = self._input_manager:is_device_active("gamepad")

	self:_create_ui_elements()
end

VersusOnboardingUI._create_ui_elements = function (self)
	-- function 2
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph)
	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animations_definitions)
	self._animations = {}

	local var_2_0
	local name = self._side:name()

	if name == "heroes" then
		var_2_0 = UIWidgets.create_hero_onboarding_tutorial_widget("side_pivot_heroes", scenegraph.side_pivot_heroes.size, {
			-400,
			0,
			5
		})
	elseif name == "dark_pact" then
		var_2_0 = UIWidgets.create_dark_pact_onboarding_tutorial_widget("side_pivot_dark_pact", scenegraph.side_pivot_dark_pact.size, {
			-400,
			0,
			5
		})
	end

	if not var_2_0 then
		self._onboarding_widget = UIWidget.init(var_2_0)
	end

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)
end

VersusOnboardingUI.destroy = function (arg_3_0)
	-- function 3
	return
end

VersusOnboardingUI._setup_career_info_widget = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not self._should_draw then
		return
	end

	self._current_profile_index = arg_4_1
	self._current_career_index = arg_4_2

	local var_4_0
	local var_4_1
	local var_4_2
	local flag = self._side:name() ~= "dark_pact"

	if not arg_4_1 and not arg_4_2 then
		var_4_0 = SPProfiles[arg_4_1]
		var_4_2 = var_4_0.careers[arg_4_2]
		var_4_1 = not flag and self:_get_hero_side_info(var_4_2) and var_4_2.career_info_settings
	end

	if not var_4_1 then
		local _onboarding_widget = self._onboarding_widget

		self:_populate_help_widget_info(var_4_0, var_4_2, var_4_1, _onboarding_widget, flag)
	end
end

VersusOnboardingUI._populate_help_widget_info = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local content = arg_5_4.content
	local style = arg_5_4.style
	local str = ""
	local is_device_active = self._input_manager:is_device_active("gamepad")

	for i = 1, 2 do
		local var_5_4 = arg_5_3[i]
		local flag = arg_5_3[i + 1] == nil

		if not var_5_4 then
			if not arg_5_5 then
				local str_2 = ""
				local keybind = var_5_4.keybind

				if not keybind then
					str_2 = not is_device_active and " $KEY;Player__" .. keybind .. ": " and "{#color(193,91,36)}[" .. keybind .. "]{#reset()} : "
				end

				content["ability_" .. i .. "_icon"] = var_5_4.icon
				content["ability_" .. i .. "_name"] = str_2 .. Localize(var_5_4.title)
				content["ability_" .. i .. "_description"] = var_5_4.description
			else
				local var_5_8
				local flag_2 = not is_device_active and var_5_4.gamepad_input and var_5_4.input_action

				if not flag_2 then
					local str_3 = " $KEY;Player__" .. flag_2 .. ":"

					if not var_5_4.double_input then
						local var_5_11 = str
						local format = string.format(Localize(var_5_4.description), str_3, str_3)
						local flag_3

						flag_3 = not flag and "" and "\n\n"
						str = var_5_11 .. format .. flag_3
					else
						local var_5_14 = str
						local format_2 = string.format(Localize(var_5_4.description), str_3)
						local flag_4

						flag_4 = not flag and "" and "\n\n"
						str = var_5_14 .. format_2 .. flag_4
					end
				else
					local var_5_17 = str
					local var_5_18 = Localize(var_5_4.description)
					local flag_5

					flag_5 = not flag and "" and "\n\n"
					str = var_5_17 .. var_5_18 .. flag_5
				end

				content.abilities_tooltip = str
				content.description = Localize(arg_5_2.description)
			end
		end
	end

	content.hero_text = Localize(arg_5_2.name)

	if not arg_5_5 then
		content.career_icon = UISettings.hero_icons.medium_white[arg_5_1.display_name]

		local get_text_width = UIUtils.get_text_width(self._ui_renderer, style.hero_text, content.hero_text)
		local num = scenegraph.side_pivot_heroes.size[1] - (get_text_width + 25 + 64)

		style.career_icon.offset[1] = num
	end
end

VersusOnboardingUI._set_widget_dirty = function (arg_6_0, arg_6_1)
	-- function 6
	arg_6_1.element.dirty = true
end

VersusOnboardingUI._update_career_status = function (self)
	-- function 7
	local profile_by_peer, var_7_1 = self._profile_synchronizer:profile_by_peer(self._peer_id, self._local_player_id)
	local is_device_active = self._input_manager:is_device_active("gamepad")

	if not (profile_by_peer ~= self._current_profile_index or var_7_1 ~= self._current_career_index or is_device_active == self._gamepad_active) then
		self._gamepad_active = is_device_active

		self:_setup_career_info_widget(profile_by_peer, var_7_1)
	end
end

VersusOnboardingUI._update_visibility = function (self)
	-- function 8
	local flag

	flag = self._side:name() == "dark_pact"

	local player_unit = self._local_player.player_unit
	local has_extension = ScriptUnit.has_extension(player_unit, "ghost_mode_system")
	local flag_2 = not has_extension and has_extension:is_in_ghost_mode()

	if not flag_2 and not Application.user_setting("toggle_pactsworn_help_ui") then
		local hint_ui_handler = Managers.ui:ingame_ui().hint_ui_handler

		if not hint_ui_handler and not hint_ui_handler:is_hint_active() then
			return false
		else
			return true
		end
	end

	return not Managers.input:get_service("Player"):get("show_career_help") and not flag_2
end

VersusOnboardingUI.update = function (self, arg_9_1, arg_9_2)
	-- function 9
	local _update_visibility = self:_update_visibility()

	if _update_visibility ~= self._should_draw then
		if not self._anim_id and not self._ui_animator:is_animation_completed(self._anim_id) then
			self._anim_id = nil
		end

		if not self._anim_id then
			local flag

			flag = not _update_visibility and "enter" and "exit"

			local _onboarding_widget = self._onboarding_widget
			local tbl = {
				self = self
			}

			self._anim_id = self._ui_animator:start_animation(flag, _onboarding_widget, scenegraph, tbl)
		end
	end

	self:_update_career_status()
	self._ui_animator:update(arg_9_1, arg_9_2)
	self:_draw(arg_9_1)
end

VersusOnboardingUI._draw = function (self, arg_10_1)
	-- function 10
	if not self._should_draw then
		return
	end

	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local get_service = self._input_manager:get_service("ingame_menu")
	local _render_settings = self._render_settings

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, get_service, arg_10_1, nil, _render_settings)

	if not self._onboarding_widget then
		UIRenderer.draw_widget(_ui_renderer, self._onboarding_widget)
	end

	UIRenderer.end_pass(_ui_renderer)
end

VersusOnboardingUI.get_input_texture_data = function (self, arg_11_1, arg_11_2)
	-- function 11
	local get_service = self._input_manager:get_service("Player")

	return UISettings.get_gamepad_input_texture_data(get_service, arg_11_1, arg_11_2)
end

VersusOnboardingUI._get_hero_side_info = function (self, arg_12_1)
	-- function 12
	local is_device_active = self._input_manager:is_device_active("gamepad")
	local tbl = {}
	local tbl_2 = {}
	local name = arg_12_1.name
	local index = PROFILES_BY_CAREER_NAMES[name].index
	local var_12_5 = career_index_from_name(index, name)
	local get_ability_data = CareerUtils.get_ability_data(index, var_12_5, 1)
	local display_name = get_ability_data.display_name

	display_name = display_name or "PLACEHOLDER"
	tbl_2.title = display_name

	local get_ability_description = UIUtils.get_ability_description(get_ability_data)

	get_ability_description = get_ability_description or Localize("PLACEHOLDER")
	tbl_2.description = get_ability_description

	local icon = get_ability_data.icon

	icon = icon or "icons_placeholder"
	tbl_2.icon = icon
	tbl_2.ability_type = Localize("hero_view_activated_ability")

	local flag

	flag = not is_device_active and "ability" and "action_career"

	local get_input_texture_data, var_12_12 = self:get_input_texture_data(flag, is_device_active)

	tbl_2.keybind = not is_device_active and flag and var_12_12

	local tbl_3 = {}
	local get_passive_ability_by_career = CareerUtils.get_passive_ability_by_career(arg_12_1)
	local display_name_2 = get_passive_ability_by_career.display_name

	display_name_2 = display_name_2 or "PLACEHOLDER"
	tbl_3.title = display_name_2

	local get_ability_description_2 = UIUtils.get_ability_description(get_passive_ability_by_career)

	get_ability_description_2 = get_ability_description_2 or Localize("PLACEHOLDER")
	tbl_3.description = get_ability_description_2

	local icon_2 = get_passive_ability_by_career.icon

	icon_2 = icon_2 or "icons_placeholder"
	tbl_3.icon = icon_2
	tbl_3.ability_type = Localize("hero_view_passive_ability")

	table.insert(tbl, tbl_2)
	table.insert(tbl, tbl_3)

	return tbl
end
