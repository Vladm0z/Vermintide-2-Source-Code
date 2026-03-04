-- chunkname: @scripts/ui/hud_ui/versus_onboarding_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/versus_onboarding_ui_definitions")
local var_0_1 = var_0_0.scenegraph
local var_0_2 = var_0_0.widgets
local var_0_3 = var_0_0.animations_definitions

VersusOnboardingUI = class(VersusOnboardingUI)

function VersusOnboardingUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0._ui_renderer = arg_1_2.ui_renderer
	arg_1_0._input_manager = arg_1_2.input_manager
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._player_manager = arg_1_2.player_manager
	arg_1_0._profile_synchronizer = arg_1_2.profile_synchronizer

	local var_1_0 = arg_1_2.player

	arg_1_0._player = var_1_0
	arg_1_0._peer_id = var_1_0:network_id()
	arg_1_0._local_player_id = var_1_0:local_player_id()
	arg_1_0._local_player = arg_1_0._player_manager:local_player()
	arg_1_0._side = Managers.state.side:get_side_from_player_unique_id(var_1_0:unique_id())
	arg_1_0._gamepad_active = arg_1_0._input_manager:is_device_active("gamepad")

	arg_1_0:_create_ui_elements()
end

function VersusOnboardingUI._create_ui_elements(arg_2_0)
	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)
	arg_2_0._ui_animator = UIAnimator:new(arg_2_0._ui_scenegraph, var_0_3)
	arg_2_0._animations = {}

	local var_2_0
	local var_2_1 = arg_2_0._side:name()

	if var_2_1 == "heroes" then
		var_2_0 = UIWidgets.create_hero_onboarding_tutorial_widget("side_pivot_heroes", var_0_1.side_pivot_heroes.size, {
			-400,
			0,
			5
		})
	elseif var_2_1 == "dark_pact" then
		var_2_0 = UIWidgets.create_dark_pact_onboarding_tutorial_widget("side_pivot_dark_pact", var_0_1.side_pivot_dark_pact.size, {
			-400,
			0,
			5
		})
	end

	if var_2_0 then
		arg_2_0._onboarding_widget = UIWidget.init(var_2_0)
	end

	UIRenderer.clear_scenegraph_queue(arg_2_0._ui_renderer)
end

function VersusOnboardingUI.destroy(arg_3_0)
	return
end

function VersusOnboardingUI._setup_career_info_widget(arg_4_0, arg_4_1, arg_4_2)
	if not arg_4_0._should_draw then
		return
	end

	arg_4_0._current_profile_index = arg_4_1
	arg_4_0._current_career_index = arg_4_2

	local var_4_0
	local var_4_1
	local var_4_2
	local var_4_3 = arg_4_0._side:name() ~= "dark_pact"

	if arg_4_1 and arg_4_2 then
		var_4_0 = SPProfiles[arg_4_1]
		var_4_2 = var_4_0.careers[arg_4_2]
		var_4_1 = var_4_3 and arg_4_0:_get_hero_side_info(var_4_2) or var_4_2.career_info_settings
	end

	if var_4_1 then
		local var_4_4 = arg_4_0._onboarding_widget

		arg_4_0:_populate_help_widget_info(var_4_0, var_4_2, var_4_1, var_4_4, var_4_3)
	end
end

function VersusOnboardingUI._populate_help_widget_info(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_4.content
	local var_5_1 = arg_5_4.style
	local var_5_2 = ""
	local var_5_3 = arg_5_0._input_manager:is_device_active("gamepad")

	for iter_5_0 = 1, 2 do
		local var_5_4 = arg_5_3[iter_5_0]
		local var_5_5 = arg_5_3[iter_5_0 + 1] == nil

		if var_5_4 then
			if arg_5_5 then
				local var_5_6 = ""
				local var_5_7 = var_5_4.keybind

				if var_5_7 then
					var_5_6 = var_5_3 and " $KEY;Player__" .. var_5_7 .. ": " or "{#color(193,91,36)}[" .. var_5_7 .. "]{#reset()} : "
				end

				var_5_0["ability_" .. iter_5_0 .. "_icon"] = var_5_4.icon
				var_5_0["ability_" .. iter_5_0 .. "_name"] = var_5_6 .. Localize(var_5_4.title)
				var_5_0["ability_" .. iter_5_0 .. "_description"] = var_5_4.description
			else
				local var_5_8
				local var_5_9 = var_5_3 and var_5_4.gamepad_input or var_5_4.input_action

				if var_5_9 then
					local var_5_10 = " $KEY;Player__" .. var_5_9 .. ":"

					if var_5_4.double_input then
						var_5_2 = var_5_2 .. string.format(Localize(var_5_4.description), var_5_10, var_5_10) .. (var_5_5 and "" or "\n\n")
					else
						var_5_2 = var_5_2 .. string.format(Localize(var_5_4.description), var_5_10) .. (var_5_5 and "" or "\n\n")
					end
				else
					var_5_2 = var_5_2 .. Localize(var_5_4.description) .. (var_5_5 and "" or "\n\n")
				end

				var_5_0.abilities_tooltip = var_5_2
				var_5_0.description = Localize(arg_5_2.description)
			end
		end
	end

	var_5_0.hero_text = Localize(arg_5_2.name)

	if arg_5_5 then
		var_5_0.career_icon = UISettings.hero_icons.medium_white[arg_5_1.display_name]

		local var_5_11 = UIUtils.get_text_width(arg_5_0._ui_renderer, var_5_1.hero_text, var_5_0.hero_text)
		local var_5_12 = var_0_1.side_pivot_heroes.size[1] - (var_5_11 + 25 + 64)

		var_5_1.career_icon.offset[1] = var_5_12
	end
end

function VersusOnboardingUI._set_widget_dirty(arg_6_0, arg_6_1)
	arg_6_1.element.dirty = true
end

function VersusOnboardingUI._update_career_status(arg_7_0)
	local var_7_0, var_7_1 = arg_7_0._profile_synchronizer:profile_by_peer(arg_7_0._peer_id, arg_7_0._local_player_id)
	local var_7_2 = arg_7_0._input_manager:is_device_active("gamepad")

	if var_7_0 ~= arg_7_0._current_profile_index or var_7_1 ~= arg_7_0._current_career_index or var_7_2 ~= arg_7_0._gamepad_active then
		arg_7_0._gamepad_active = var_7_2

		arg_7_0:_setup_career_info_widget(var_7_0, var_7_1)
	end
end

function VersusOnboardingUI._update_visibility(arg_8_0)
	local var_8_0

	var_8_0 = arg_8_0._side:name() == "dark_pact"

	local var_8_1 = arg_8_0._local_player.player_unit
	local var_8_2 = ScriptUnit.has_extension(var_8_1, "ghost_mode_system")
	local var_8_3 = var_8_2 and var_8_2:is_in_ghost_mode()

	if var_8_3 and Application.user_setting("toggle_pactsworn_help_ui") then
		local var_8_4 = Managers.ui:ingame_ui().hint_ui_handler

		if var_8_4 and var_8_4:is_hint_active() then
			return false
		else
			return true
		end
	end

	return Managers.input:get_service("Player"):get("show_career_help") and not var_8_3
end

function VersusOnboardingUI.update(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0:_update_visibility()

	if var_9_0 ~= arg_9_0._should_draw then
		if arg_9_0._anim_id and arg_9_0._ui_animator:is_animation_completed(arg_9_0._anim_id) then
			arg_9_0._anim_id = nil
		end

		if not arg_9_0._anim_id then
			local var_9_1 = var_9_0 and "enter" or "exit"
			local var_9_2 = arg_9_0._onboarding_widget
			local var_9_3 = {
				self = arg_9_0
			}

			arg_9_0._anim_id = arg_9_0._ui_animator:start_animation(var_9_1, var_9_2, var_0_1, var_9_3)
		end
	end

	arg_9_0:_update_career_status()
	arg_9_0._ui_animator:update(arg_9_1, arg_9_2)
	arg_9_0:_draw(arg_9_1)
end

function VersusOnboardingUI._draw(arg_10_0, arg_10_1)
	if not arg_10_0._should_draw then
		return
	end

	local var_10_0 = arg_10_0._ui_renderer
	local var_10_1 = arg_10_0._ui_scenegraph
	local var_10_2 = arg_10_0._input_manager:get_service("ingame_menu")
	local var_10_3 = arg_10_0._render_settings

	UIRenderer.begin_pass(var_10_0, var_10_1, var_10_2, arg_10_1, nil, var_10_3)

	if arg_10_0._onboarding_widget then
		UIRenderer.draw_widget(var_10_0, arg_10_0._onboarding_widget)
	end

	UIRenderer.end_pass(var_10_0)
end

function VersusOnboardingUI.get_input_texture_data(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0._input_manager:get_service("Player")

	return UISettings.get_gamepad_input_texture_data(var_11_0, arg_11_1, arg_11_2)
end

function VersusOnboardingUI._get_hero_side_info(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0._input_manager:is_device_active("gamepad")
	local var_12_1 = {}
	local var_12_2 = {}
	local var_12_3 = arg_12_1.name
	local var_12_4 = PROFILES_BY_CAREER_NAMES[var_12_3].index
	local var_12_5 = career_index_from_name(var_12_4, var_12_3)
	local var_12_6 = CareerUtils.get_ability_data(var_12_4, var_12_5, 1)

	var_12_2.title = var_12_6.display_name or "PLACEHOLDER"
	var_12_2.description = UIUtils.get_ability_description(var_12_6) or Localize("PLACEHOLDER")
	var_12_2.icon = var_12_6.icon or "icons_placeholder"
	var_12_2.ability_type = Localize("hero_view_activated_ability")

	local var_12_7 = var_12_0 and "ability" or "action_career"
	local var_12_8, var_12_9 = arg_12_0:get_input_texture_data(var_12_7, var_12_0)

	var_12_2.keybind = var_12_0 and var_12_7 or var_12_9

	local var_12_10 = {}
	local var_12_11 = CareerUtils.get_passive_ability_by_career(arg_12_1)

	var_12_10.title = var_12_11.display_name or "PLACEHOLDER"
	var_12_10.description = UIUtils.get_ability_description(var_12_11) or Localize("PLACEHOLDER")
	var_12_10.icon = var_12_11.icon or "icons_placeholder"
	var_12_10.ability_type = Localize("hero_view_passive_ability")

	table.insert(var_12_1, var_12_2)
	table.insert(var_12_1, var_12_10)

	return var_12_1
end
