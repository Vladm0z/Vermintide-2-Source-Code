-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_talents.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_talents_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = var_0_0.generic_input_actions
local var_0_5 = false

HeroWindowTalents = class(HeroWindowTalents)
HeroWindowTalents.NAME = "HeroWindowTalents"

HeroWindowTalents.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowTalents")

	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}

	local var_1_1 = Managers.player
	local var_1_2 = var_1_1:local_player()

	arg_1_0._stats_id = var_1_2:stats_id()
	arg_1_0.player_manager = var_1_1
	arg_1_0.player = var_1_2
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0._animations = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)

	arg_1_0.hero_name = arg_1_1.hero_name
	arg_1_0.career_index = arg_1_1.career_index

	local var_1_3 = FindProfileIndex(arg_1_0.hero_name)

	arg_1_0._career_name = SPProfiles[var_1_3].careers[arg_1_0.career_index].name

	local var_1_4 = ExperienceSettings.get_experience(arg_1_0.hero_name)

	arg_1_0.hero_level = ExperienceSettings.get_level(var_1_4)

	arg_1_0:_initialize_talents()
end

HeroWindowTalents.on_exit = function (arg_2_0, arg_2_1)
	print("[HeroViewWindow] Exit Substate HeroWindowTalents")

	arg_2_0.ui_animator = nil

	local var_2_0 = arg_2_0._talent_interface
	local var_2_1 = arg_2_0._career_name

	var_2_0:set_talents(var_2_1, arg_2_0._selected_talents)

	local var_2_2 = arg_2_0.player.player_unit

	if Unit.alive(var_2_2) then
		ScriptUnit.extension(var_2_2, "talent_system"):talents_changed()
		ScriptUnit.extension(var_2_2, "inventory_system"):apply_buffs_to_ammo()
	end
end

HeroWindowTalents.create_ui_elements = function (arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)

	local var_3_0 = {}
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in pairs(var_0_1) do
		local var_3_2 = UIWidget.init(iter_3_1)

		var_3_0[#var_3_0 + 1] = var_3_2
		var_3_1[iter_3_0] = var_3_2
	end

	arg_3_0._widgets = var_3_0
	arg_3_0._widgets_by_name = var_3_1

	UIRenderer.clear_scenegraph_queue(arg_3_0.ui_renderer)

	arg_3_0.ui_animator = UIAnimator:new(arg_3_0.ui_scenegraph, var_0_3)

	if arg_3_2 then
		local var_3_3 = arg_3_0.ui_scenegraph.window.local_position

		var_3_3[1] = var_3_3[1] + arg_3_2[1]
		var_3_3[2] = var_3_3[2] + arg_3_2[2]
		var_3_3[3] = var_3_3[3] + arg_3_2[3]
	end
end

HeroWindowTalents._initialize_talents = function (arg_4_0)
	local var_4_0 = arg_4_0._career_name
	local var_4_1 = Managers.backend:get_interface("talents")
	local var_4_2 = var_4_1:get_talents(var_4_0)

	arg_4_0._selected_talents = table.clone(var_4_2)
	arg_4_0._talent_interface = var_4_1

	arg_4_0:_update_talent_sync(true)

	arg_4_0._initialized = true
end

HeroWindowTalents.update = function (arg_5_0, arg_5_1, arg_5_2)
	if var_0_5 then
		var_0_5 = false

		arg_5_0:create_ui_elements()
	end

	arg_5_0:_update_animations(arg_5_1)
	arg_5_0:_handle_input(arg_5_1, arg_5_2)
	arg_5_0:draw(arg_5_1)
end

HeroWindowTalents.post_update = function (arg_6_0, arg_6_1, arg_6_2)
	return
end

HeroWindowTalents._update_talent_sync = function (arg_7_0, arg_7_1)
	arg_7_0:_populate_talents_by_hero(arg_7_1)
	arg_7_0:_populate_career_info(arg_7_1)
end

HeroWindowTalents._update_animations = function (arg_8_0, arg_8_1)
	arg_8_0.ui_animator:update(arg_8_1)

	local var_8_0 = arg_8_0._animations
	local var_8_1 = arg_8_0.ui_animator

	for iter_8_0, iter_8_1 in pairs(var_8_0) do
		if var_8_1:is_animation_completed(iter_8_1) then
			var_8_1:stop_animation(iter_8_1)

			var_8_0[iter_8_0] = nil
		end
	end
end

HeroWindowTalents._is_button_pressed = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_1.content.button_hotspot

	if var_9_0.on_pressed then
		var_9_0.on_pressed = false

		return true
	end
end

HeroWindowTalents._is_button_released = function (arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1.content.button_hotspot

	if var_10_0.on_release then
		var_10_0.on_release = false

		return true
	end
end

HeroWindowTalents._is_stepper_button_pressed = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_1.content
	local var_11_1 = var_11_0.button_hotspot_left
	local var_11_2 = var_11_0.button_hotspot_right

	if var_11_1.on_release then
		var_11_1.on_release = false

		return true, -1
	elseif var_11_2.on_release then
		var_11_2.on_release = false

		return true, 1
	end
end

HeroWindowTalents._is_button_hover_enter = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_1.content.button_hotspot

	return var_12_0.on_hover_enter and not var_12_0.is_selected
end

HeroWindowTalents._handle_input = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0.parent
	local var_13_1 = arg_13_0._widgets_by_name

	if arg_13_0:_is_button_hover_enter(var_13_1.career_perk_1) or arg_13_0:_is_button_hover_enter(var_13_1.career_perk_2) or arg_13_0:_is_button_hover_enter(var_13_1.career_perk_3) then
		arg_13_0:_play_sound("play_gui_equipment_button_hover")
	end

	if arg_13_0:_is_talent_hovered() then
		arg_13_0:_play_sound("play_gui_talents_selection_hover")
	end

	if arg_13_0:_is_disabled_talent_hovered() then
		arg_13_0:_play_sound("play_gui_talents_selection_hover_disabled")
	end

	local var_13_2, var_13_3 = arg_13_0:_is_talent_pressed()

	if var_13_2 and var_13_3 then
		if not arg_13_0._selected_talents[var_13_2] or arg_13_0._selected_talents[var_13_2] == 0 then
			arg_13_0:_play_sound("play_gui_talent_unlock")
		else
			arg_13_0:_play_sound("play_gui_talents_selection_click")
		end

		arg_13_0._selected_talents[var_13_2] = var_13_3

		arg_13_0:_update_talent_sync()
		var_13_0:update_talent_sync()
	end
end

HeroWindowTalents.draw = function (arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0.ui_renderer
	local var_14_1 = arg_14_0.ui_top_renderer
	local var_14_2 = arg_14_0.ui_scenegraph
	local var_14_3 = arg_14_0.parent:window_input_service()
	local var_14_4 = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(var_14_0, var_14_2, var_14_3, arg_14_1, nil, arg_14_0.render_settings)

	for iter_14_0, iter_14_1 in ipairs(arg_14_0._widgets) do
		UIRenderer.draw_widget(var_14_0, iter_14_1)
	end

	local var_14_5 = arg_14_0._active_node_widgets

	if var_14_5 then
		for iter_14_2, iter_14_3 in ipairs(var_14_5) do
			UIRenderer.draw_widget(var_14_0, iter_14_3)
		end
	end

	UIRenderer.end_pass(var_14_0)
end

HeroWindowTalents._play_sound = function (arg_15_0, arg_15_1)
	arg_15_0.parent:play_sound(arg_15_1)
end

HeroWindowTalents._populate_talents_by_hero = function (arg_16_0, arg_16_1)
	arg_16_0:_clear_talents()

	local var_16_0 = arg_16_0._widgets_by_name
	local var_16_1 = arg_16_0.hero_name
	local var_16_2 = arg_16_0.career_index
	local var_16_3 = FindProfileIndex(var_16_1)
	local var_16_4 = SPProfiles[var_16_3].careers[var_16_2]
	local var_16_5 = (var_16_2 - 1) * NumTalentRows
	local var_16_6 = TalentTrees[var_16_1][var_16_4.talent_tree_index]
	local var_16_7 = arg_16_0._selected_talents
	local var_16_8 = PlayerUtils.get_talent_overrides_by_career(var_16_4.display_name)

	for iter_16_0 = 1, NumTalentRows do
		local var_16_9 = var_16_0["talent_row_" .. iter_16_0]

		if var_16_9 then
			local var_16_10 = var_16_9.content
			local var_16_11 = var_16_9.style
			local var_16_12 = var_16_7[iter_16_0]
			local var_16_13 = not var_16_12 or var_16_12 == 0
			local var_16_14 = "talent_point_" .. iter_16_0
			local var_16_15 = ProgressionUnlocks.is_unlocked(var_16_14, arg_16_0.hero_level)
			local var_16_16 = var_16_15 and Colors.get_color_table_with_alpha("green", 255) or Colors.get_color_table_with_alpha("red", 255)
			local var_16_17 = ProgressionUnlocks.get_unlock(var_16_14)

			var_16_10.level_text = tostring(var_16_17.level_requirement)
			var_16_11.level_text.text_color = var_16_16

			if var_16_15 and not var_16_13 then
				local var_16_18 = var_16_9.animations

				table.clear(var_16_18)
			end

			local var_16_19 = var_16_11.glow_frame

			var_16_19.color[1] = 0

			if arg_16_1 and var_16_15 and var_16_13 then
				local var_16_20 = arg_16_0:_animate_pulse(var_16_19.color, 1, 255, 100, 2)

				UIWidget.animate(var_16_9, var_16_20)
			end

			for iter_16_1 = 1, NumTalentColumns do
				local var_16_21 = var_16_12 == iter_16_1
				local var_16_22 = var_16_6[iter_16_0][iter_16_1]
				local var_16_23 = TalentIDLookup[var_16_22].talent_id
				local var_16_24 = TalentUtils.get_talent_by_id(var_16_1, var_16_23)
				local var_16_25 = "_" .. tostring(iter_16_1)
				local var_16_26 = "icon" .. var_16_25
				local var_16_27 = "hotspot" .. var_16_25
				local var_16_28 = "title_text" .. var_16_25
				local var_16_29 = "background_glow" .. var_16_25
				local var_16_30 = var_16_10[var_16_27]
				local var_16_31 = not var_16_15 or var_16_8 and var_16_8[var_16_22] == false

				if var_16_21 or var_16_13 and not var_16_31 then
					var_16_11[var_16_26].saturated = false
				else
					var_16_11[var_16_26].saturated = true
				end

				var_16_10[var_16_26] = var_16_24 and var_16_24.icon or "icons_placeholder"
				var_16_10[var_16_28] = var_16_24 and Localize(var_16_24.display_name or var_16_24.name) or "Undefined"
				var_16_30.is_selected = var_16_21
				var_16_30.talent = var_16_24
				var_16_30.talent_id = var_16_23
				var_16_30.disabled = var_16_31

				if not var_16_31 then
					var_16_11[var_16_29].saturated = false
				else
					var_16_11[var_16_29].saturated = true
				end
			end
		end
	end
end

HeroWindowTalents._clear_talents = function (arg_17_0)
	local var_17_0 = arg_17_0._widgets_by_name

	for iter_17_0 = 1, NumTalentRows do
		local var_17_1 = var_17_0["talent_row_" .. iter_17_0]

		if var_17_1 then
			local var_17_2 = var_17_1.content
			local var_17_3 = var_17_1.style

			for iter_17_1 = 1, NumTalentColumns do
				local var_17_4 = "_" .. tostring(iter_17_1)
				local var_17_5 = "icon" .. var_17_4
				local var_17_6 = "hotspot" .. var_17_4
				local var_17_7 = "title_text" .. var_17_4

				var_17_2[var_17_5] = "icons_placeholder"
				var_17_2[var_17_7] = "Undefined"
				var_17_2[var_17_6].is_selected = false
				var_17_2[var_17_6].disabled = true
			end
		end
	end
end

HeroWindowTalents._is_talent_pressed = function (arg_18_0)
	local var_18_0 = arg_18_0._widgets_by_name

	for iter_18_0 = 1, NumTalentRows do
		local var_18_1 = var_18_0["talent_row_" .. iter_18_0]

		if var_18_1 then
			local var_18_2 = var_18_1.content

			for iter_18_1 = 1, NumTalentColumns do
				local var_18_3 = "_" .. tostring(iter_18_1)
				local var_18_4 = var_18_2["hotspot" .. var_18_3]

				if not var_18_4.disabled then
					if var_18_4.on_pressed then
						return iter_18_0, iter_18_1
					elseif var_18_4.on_right_click and var_18_4.is_selected then
						return iter_18_0, 0
					end
				end
			end
		end
	end
end

HeroWindowTalents._is_talent_hovered = function (arg_19_0)
	local var_19_0 = arg_19_0._widgets_by_name

	for iter_19_0 = 1, NumTalentRows do
		local var_19_1 = var_19_0["talent_row_" .. iter_19_0]

		if var_19_1 then
			local var_19_2 = var_19_1.content

			for iter_19_1 = 1, NumTalentColumns do
				local var_19_3 = "_" .. tostring(iter_19_1)
				local var_19_4 = var_19_2["hotspot" .. var_19_3]

				if var_19_4.on_hover_enter and not var_19_4.disabled then
					return iter_19_0, iter_19_1
				end
			end
		end
	end
end

HeroWindowTalents._is_disabled_talent_hovered = function (arg_20_0)
	local var_20_0 = arg_20_0._widgets_by_name

	for iter_20_0 = 1, NumTalentRows do
		local var_20_1 = var_20_0["talent_row_" .. iter_20_0]

		if var_20_1 then
			local var_20_2 = var_20_1.content

			for iter_20_1 = 1, NumTalentColumns do
				local var_20_3 = "_" .. tostring(iter_20_1)
				local var_20_4 = var_20_2["hotspot" .. var_20_3]

				if var_20_4.on_hover_enter and var_20_4.disabled then
					return iter_20_0, iter_20_1
				end
			end
		end
	end
end

HeroWindowTalents._populate_career_info = function (arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0.hero_name
	local var_21_1 = arg_21_0.career_index
	local var_21_2 = FindProfileIndex(var_21_0)
	local var_21_3 = SPProfiles[var_21_2].careers[var_21_1]
	local var_21_4 = var_21_3.name
	local var_21_5 = var_21_3.character_selection_image
	local var_21_6 = arg_21_0._widgets_by_name
	local var_21_7 = Colors.color_definitions[var_21_4] and Colors.get_color_table_with_alpha(var_21_4, 255) or {
		255,
		255,
		255,
		255
	}

	var_21_6.career_background.style.background.color = var_21_7

	local var_21_8 = CareerUtils.get_passive_ability_by_career(var_21_3)
	local var_21_9 = CareerUtils.get_ability_data_by_career(var_21_3, 1)
	local var_21_10 = var_21_8.display_name
	local var_21_11 = var_21_8.icon
	local var_21_12 = var_21_9.display_name
	local var_21_13 = var_21_9.icon

	var_21_6.passive_title_text.content.text = Localize(var_21_10)
	var_21_6.passive_description_text.content.text = UIUtils.get_ability_description(var_21_8)
	var_21_6.passive_icon.content.texture_id = var_21_11
	var_21_6.active_title_text.content.text = Localize(var_21_12)
	var_21_6.active_description_text.content.text = UIUtils.get_ability_description(var_21_9)
	var_21_6.active_icon.content.texture_id = var_21_13

	local var_21_14 = var_21_8.perks

	for iter_21_0, iter_21_1 in ipairs(var_21_14) do
		local var_21_15 = var_21_6["career_perk_" .. iter_21_0]
		local var_21_16 = iter_21_1.display_name

		var_21_15.content.text = Localize(var_21_16)
		var_21_15.content.tooltip_data = iter_21_1
	end
end

HeroWindowTalents._animate_pulse = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	return (UIAnimation.init(UIAnimation.pulse_animation, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5))
end
