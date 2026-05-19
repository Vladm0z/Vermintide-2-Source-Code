-- chunkname: @scripts/ui/hud_ui/dark_pact_ability_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/dark_pact_ability_ui_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.create_ability_widget
local var_0_3 = var_0_0.profile_ability_templates

DarkPactAbilityUI = class(DarkPactAbilityUI)

function DarkPactAbilityUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0._ui_renderer = arg_1_2.ui_renderer
	arg_1_0._ingame_ui = arg_1_2.ingame_ui
	arg_1_0._input_manager = arg_1_2.input_manager
	arg_1_0._peer_id = arg_1_2.peer_id
	arg_1_0._player_manager = arg_1_2.player_manager
	arg_1_0._ui_animations = {}
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}

	local var_1_0 = Managers.world:world("level_world")

	arg_1_0._world = var_1_0
	arg_1_0._wwise_world = Managers.world:wwise_world(var_1_0)
	arg_1_0._is_in_inn = arg_1_2.is_in_inn

	arg_1_0:_create_ui_elements()

	arg_1_0._ability_events = {}

	local var_1_1 = Managers.state.event

	var_1_1:register(arg_1_0, "input_changed", "event_input_changed")
	var_1_1:register(arg_1_0, "on_spectator_target_changed", "on_spectator_target_changed")
end

function DarkPactAbilityUI._create_ui_elements(arg_2_0)
	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)

	local var_2_0 = {}
	local var_2_1 = {}

	for iter_2_0, iter_2_1 in pairs(var_0_0.widget_definitions) do
		local var_2_2 = UIWidget.init(iter_2_1)

		var_2_1[iter_2_0] = var_2_2
		var_2_0[#var_2_0 + 1] = var_2_2
	end

	arg_2_0._widgets = var_2_0
	arg_2_0._widgets_by_name = var_2_1
	arg_2_0._widgets_by_ability_name = {}
	arg_2_0._career_ability_widgets_by_name = {}
	arg_2_0._ability_hud_widgets_by_name = {}

	UIRenderer.clear_scenegraph_queue(arg_2_0._ui_renderer)
end

function DarkPactAbilityUI._setup_activated_ability(arg_3_0)
	local var_3_0, var_3_1 = arg_3_0:_get_player_unit()

	if not var_3_1 then
		return
	end

	local var_3_2 = ScriptUnit.extension(var_3_1, "career_system")
	local var_3_3 = var_3_2:get_activated_ability_data()
	local var_3_4 = var_3_2:career_name()

	if not var_3_3 or not var_3_4 then
		return
	end

	arg_3_0._career_name = var_3_4
	arg_3_0._initialized = true
end

function DarkPactAbilityUI._get_extension(arg_4_0, arg_4_1)
	local var_4_0, var_4_1 = arg_4_0:_get_player_unit()

	if var_4_1 and Unit.alive(var_4_1) then
		return ScriptUnit.extension(var_4_1, arg_4_1)
	end
end

function DarkPactAbilityUI._update_abilities(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0:_get_extension("career_system")
	local var_5_1 = arg_5_0:_get_extension("versus_horde_ability_system")
	local var_5_2 = var_5_0 and var_5_0:career_name()
	local var_5_3 = arg_5_0._ui_renderer

	if arg_5_0._career_name ~= var_5_2 then
		table.clear(arg_5_0._ability_hud_widgets_by_name)

		arg_5_0._initialized = false

		return
	end

	local var_5_4, var_5_5 = arg_5_0:_get_player_unit()
	local var_5_6 = ScriptUnit.has_extension(var_5_5, "ghost_mode_system")
	local var_5_7 = var_5_6 and var_5_6:is_in_ghost_mode()

	arg_5_0:_handle_career_abilities(arg_5_1, arg_5_2, var_5_2, var_5_0, var_5_1, var_5_3, var_5_7)
end

function DarkPactAbilityUI.destroy(arg_6_0)
	local var_6_0 = Managers.state.event

	var_6_0:unregister("input_changed", arg_6_0)
	var_6_0:unregister("on_spectator_target_changed", arg_6_0)

	for iter_6_0, iter_6_1 in pairs(arg_6_0._ability_events) do
		var_6_0:unregister(iter_6_0, arg_6_0)
	end

	arg_6_0:set_visible(false)
	print("[DarkPactAbilityUI] - Destroy")
end

function DarkPactAbilityUI.set_visible(arg_7_0, arg_7_1)
	arg_7_0._is_visible = arg_7_1

	arg_7_0:_set_elements_visible(arg_7_1)
end

function DarkPactAbilityUI._set_elements_visible(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._ui_renderer

	for iter_8_0, iter_8_1 in ipairs(arg_8_0._widgets) do
		UIRenderer.set_element_visible(var_8_0, iter_8_1.element, arg_8_1)
	end

	local var_8_1 = arg_8_0._ability_widgets

	if var_8_1 then
		for iter_8_2, iter_8_3 in ipairs(var_8_1) do
			UIRenderer.set_element_visible(var_8_0, iter_8_3.element, arg_8_1)
		end
	end

	arg_8_0._retained_elements_visible = arg_8_1

	arg_8_0:set_dirty()
end

function DarkPactAbilityUI._handle_gamepad(arg_9_0)
	return true
end

function DarkPactAbilityUI.update(arg_10_0, arg_10_1, arg_10_2)
	if not arg_10_0._is_visible then
		return
	end

	if not arg_10_0._initialized then
		arg_10_0:_setup_activated_ability()

		return
	end

	if not arg_10_0:_handle_gamepad() then
		return
	end

	arg_10_0:_handle_resolution_modified()
	arg_10_0:draw(arg_10_1, arg_10_2)
end

function DarkPactAbilityUI._handle_resolution_modified(arg_11_0)
	if RESOLUTION_LOOKUP.modified then
		arg_11_0:_on_resolution_modified()
	end
end

function DarkPactAbilityUI._on_resolution_modified(arg_12_0)
	for iter_12_0, iter_12_1 in ipairs(arg_12_0._widgets) do
		arg_12_0:_set_widget_dirty(iter_12_1)
	end

	arg_12_0:set_dirty()
end

function DarkPactAbilityUI.draw(arg_13_0, arg_13_1, arg_13_2)
	if not arg_13_0._is_visible then
		return
	end

	local var_13_0, var_13_1 = arg_13_0:_get_player_unit()
	local var_13_2 = var_13_0 and var_13_0:profile_index()
	local var_13_3 = var_13_2 and SPProfiles[var_13_2]

	if var_13_3 and var_13_3.affiliation ~= "dark_pact" then
		arg_13_0:set_visible(false)

		return
	end

	local var_13_4 = arg_13_0._ui_renderer
	local var_13_5 = arg_13_0._ui_scenegraph
	local var_13_6 = arg_13_0._input_manager:get_service("ingame_menu")

	UIRenderer.begin_pass(var_13_4, var_13_5, var_13_6, arg_13_1, nil, arg_13_0._render_settings)
	arg_13_0:_update_abilities(arg_13_1, arg_13_2)

	local var_13_7 = arg_13_0._ability_widgets

	if var_13_7 then
		for iter_13_0, iter_13_1 in ipairs(var_13_7) do
			UIRenderer.draw_widget(var_13_4, iter_13_1)
		end
	end

	for iter_13_2, iter_13_3 in ipairs(arg_13_0._widgets) do
		UIRenderer.draw_widget(var_13_4, iter_13_3)
	end

	if arg_13_0._career_ability_widgets_by_name then
		for iter_13_4, iter_13_5 in pairs(arg_13_0._career_ability_widgets_by_name) do
			UIRenderer.draw_widget(var_13_4, iter_13_5)
		end
	end

	UIRenderer.end_pass(var_13_4)

	arg_13_0._dirty = false
end

function DarkPactAbilityUI.set_dirty(arg_14_0)
	arg_14_0._dirty = true
end

function DarkPactAbilityUI._set_widget_dirty(arg_15_0, arg_15_1)
	arg_15_1.element.dirty = true
end

function DarkPactAbilityUI._play_sound(arg_16_0, arg_16_1)
	WwiseWorld.trigger_event(arg_16_0._wwise_world, arg_16_1)
end

function DarkPactAbilityUI.event_input_changed(arg_17_0)
	local var_17_0 = "action_career"
	local var_17_1 = arg_17_0._ability_widgets

	if var_17_1 then
		for iter_17_0, iter_17_1 in ipairs(var_17_1) do
			local var_17_2 = iter_17_1.content.input_action or var_17_0

			arg_17_0:_set_input(iter_17_1, var_17_2)
			arg_17_0:_set_widget_dirty(iter_17_1)
		end
	end

	arg_17_0:set_dirty()
end

function DarkPactAbilityUI._set_input(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0, var_18_1, var_18_2 = arg_18_0:_get_input_texture_data(arg_18_2)
	local var_18_3 = 100
	local var_18_4 = arg_18_1.style.input_text
	local var_18_5 = arg_18_0._ui_renderer

	var_18_1 = var_18_1 and UIRenderer.crop_text_width(var_18_5, var_18_1, var_18_3, var_18_4)
	arg_18_1.content.input_text = var_18_1 or ""
	arg_18_1.content.input_action = arg_18_2
end

function DarkPactAbilityUI._get_input_texture_data(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0._input_manager
	local var_19_1 = var_19_0:get_service("Player")
	local var_19_2 = var_19_0:is_device_active("gamepad")
	local var_19_3 = PLATFORM

	if IS_WINDOWS and var_19_2 then
		var_19_3 = "xb1"
	end

	local var_19_4 = var_19_1:get_keymapping(arg_19_1, var_19_3)

	if not var_19_4 then
		Application.warning(string.format("[DarkPactAbilityUI] There is no keymap for %q on %q", arg_19_1, var_19_3))

		return nil, ""
	end

	local var_19_5 = var_19_4[1]
	local var_19_6 = var_19_4[2]
	local var_19_7 = var_19_4[3]
	local var_19_8

	if var_19_7 == "held" then
		var_19_8 = "matchmaking_prefix_hold"
	end

	local var_19_9 = var_19_6 == UNASSIGNED_KEY
	local var_19_10 = ""

	if var_19_5 == "keyboard" then
		var_19_10 = var_19_9 and "" or Keyboard.button_locale_name(var_19_6)

		return nil, var_19_10, var_19_8
	elseif var_19_5 == "mouse" then
		var_19_10 = var_19_9 and "" or Mouse.button_name(var_19_6)

		return nil, var_19_10, var_19_8
	elseif var_19_5 == "gamepad" then
		var_19_10 = var_19_9 and "" or Pad1.button_name(var_19_6)

		return ButtonTextureByName(var_19_10, var_19_3), var_19_10, var_19_8
	end

	return nil, var_19_10
end

function DarkPactAbilityUI._update_ability_animations(arg_20_0, arg_20_1, arg_20_2)
	if not arg_20_0._is_visible then
		return false
	end

	local var_20_0 = arg_20_1.style
	local var_20_1 = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

	var_20_0.icon_cooldown.color[1] = math.max(var_20_0.icon_cooldown.color[1] - arg_20_2 * 400, 0)
	var_20_0.icon.color[1] = 155 + var_20_1 * 100

	arg_20_0:_set_widget_dirty(arg_20_1)

	return true
end

function DarkPactAbilityUI.set_alpha(arg_21_0, arg_21_1)
	for iter_21_0, iter_21_1 in pairs(arg_21_0._widgets) do
		arg_21_0:_set_widget_dirty(iter_21_1)
	end

	arg_21_0._render_settings.alpha_multiplier = arg_21_1

	arg_21_0:set_dirty()
end

function DarkPactAbilityUI._get_player_unit(arg_22_0)
	if arg_22_0._is_spectator then
		return arg_22_0._spectated_player, arg_22_0._spectated_player_unit
	end

	if arg_22_0._player then
		return arg_22_0._player, arg_22_0._player.player_unit
	end

	arg_22_0._player = arg_22_0._player_manager:local_player(1)

	return arg_22_0._player, arg_22_0._player.player_unit
end

function DarkPactAbilityUI.on_spectator_target_changed(arg_23_0, arg_23_1)
	arg_23_0._spectated_player_unit = arg_23_1
	arg_23_0._spectated_player = Managers.player:owner(arg_23_1)
	arg_23_0._is_spectator = true

	if Managers.state.side:get_side_from_player_unique_id(arg_23_0._spectated_player:unique_id()):name() == "dark_pact" then
		arg_23_0:set_visible(true)
	else
		arg_23_0:set_visible(false)
	end
end

function DarkPactAbilityUI.event_on_dark_pact_ammo_changed(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_0._ability_hud_widgets_by_name and arg_24_0._ability_hud_widgets_by_name[2]

	if not var_24_0 then
		return
	end

	local var_24_1 = var_24_0.ammo

	if not var_24_1 then
		return
	end

	if not arg_24_2 then
		local var_24_2 = BLACKBOARDS[arg_24_1].attack_pattern_data or {}

		if var_24_2.current_ammo then
			arg_24_2 = var_24_2.current_ammo
		else
			arg_24_2 = Unit.get_data(arg_24_1, "breed").max_ammo
		end
	end

	local var_24_3 = 0
	local var_24_4 = var_24_1.content
	local var_24_5

	var_24_5 = arg_24_2 + var_24_3 == 0

	local var_24_6 = false

	if arg_24_0._ammo_count ~= arg_24_2 then
		arg_24_0._ammo_count = arg_24_2
		var_24_4.current_ammo = tostring(arg_24_2)

		local var_24_7 = true
	end

	if arg_24_0._remaining_ammo ~= var_24_3 then
		local var_24_8 = Unit.get_data(arg_24_1, "breed").max_ammo

		arg_24_0._remaining_ammo = var_24_8
		var_24_4.remaining_ammo = tostring(var_24_8)

		local var_24_9 = true
	end
end

function DarkPactAbilityUI._handle_career_abilities(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6, arg_25_7)
	local var_25_0, var_25_1 = arg_25_0:_get_player_unit()
	local var_25_2 = var_25_0:profile_index()
	local var_25_3 = var_25_0:career_index()
	local var_25_4 = SPProfiles[var_25_2].careers[var_25_3].career_info_settings
	local var_25_5 = #var_25_4
	local var_25_6 = arg_25_4 and arg_25_4:career_name()
	local var_25_7 = arg_25_0._widgets_by_ability_name
	local var_25_8 = var_0_3[var_25_6]
	local var_25_9 = arg_25_0:_get_extension("status_system")
	local var_25_10 = true

	if var_25_9 and not var_25_9:is_dead() then
		var_25_10 = false
	end

	local var_25_11 = -(80 * var_25_5 * 0.5)

	for iter_25_0 = 1, #var_25_8 do
		if not arg_25_0._ability_hud_widgets_by_name[iter_25_0] then
			local var_25_12 = var_25_8[iter_25_0]
			local var_25_13 = var_25_12.widget_definitions
			local var_25_14 = {}

			for iter_25_1, iter_25_2 in pairs(var_25_13) do
				var_25_14[iter_25_1] = UIWidget.init(iter_25_2)
			end

			local var_25_15 = var_25_14.ability_icon

			if var_25_15 then
				var_25_15.content.settings = var_25_4[iter_25_0]
				var_25_15.offset[1] = var_25_11 + 80 * (iter_25_0 - 1)
			end

			if var_25_12.events then
				local var_25_16 = var_25_12.events

				for iter_25_3, iter_25_4 in pairs(var_25_16) do
					arg_25_0._ability_events[#arg_25_0._ability_events + 1] = {
						iter_25_3,
						iter_25_4
					}

					Managers.state.event:register(arg_25_0, iter_25_3, iter_25_4)
				end
			end

			arg_25_0._ability_hud_widgets_by_name[#arg_25_0._ability_hud_widgets_by_name + 1] = var_25_14
		end
	end

	local var_25_17 = arg_25_0._widgets_by_name.abilities_detail_left
	local var_25_18 = arg_25_0._widgets_by_name.abilities_detail_right

	var_25_17.offset[1] = var_25_11 - 88 + 20
	var_25_18.offset[1] = var_25_11 + 80 * var_25_5 - 20
	var_25_17.content.visible = not arg_25_7
	var_25_18.content.visible = not arg_25_7

	for iter_25_5 = 1, #var_25_8 do
		local var_25_19 = var_25_8[iter_25_5]
		local var_25_20 = var_25_19.update_functions
		local var_25_21 = arg_25_0._ability_hud_widgets_by_name[iter_25_5]

		for iter_25_6, iter_25_7 in pairs(var_25_21) do
			local var_25_22 = var_25_20 and var_25_20[iter_25_6]

			if var_25_22 then
				if var_25_19.ability_name then
					local var_25_23, var_25_24 = arg_25_4:ability_by_name(var_25_19.ability_name)

					if arg_25_7 and var_25_23.draw_ui_in_ghost_mode or not arg_25_7 then
						var_25_22(arg_25_1, arg_25_2, arg_25_6, arg_25_4, var_25_24, iter_25_7, var_25_10, var_25_1, arg_25_5)
					end
				end
			elseif not var_25_10 and not arg_25_7 then
				UIRenderer.draw_widget(arg_25_6, iter_25_7)
			end
		end
	end
end
