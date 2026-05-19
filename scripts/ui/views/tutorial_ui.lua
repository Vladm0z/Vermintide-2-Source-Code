-- chunkname: @scripts/ui/views/tutorial_ui.lua

require("scripts/ui/views/tutorial_tooltip_ui")

local var_0_0 = local_require("scripts/ui/views/tutorial_ui_definitions")

script_data.disable_tutorial_ui = script_data.disable_tutorial_ui or Development.parameter("disable_tutorial_ui")
script_data.disable_info_slate_ui = script_data.disable_info_slate_ui or Development.parameter("disable_info_slate_ui")

local var_0_1 = {
	"mission_goal",
	"mission_objective",
	"side_mission",
	"tutorial",
	side_mission = 3,
	mission_objective = 2,
	tutorial = 4,
	mission_goal = 1
}
local var_0_2 = false

TutorialUI = class(TutorialUI)

local function var_0_3(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = RESOLUTION_LOOKUP.res_w
	local var_1_1 = RESOLUTION_LOOKUP.res_h
	local var_1_2 = arg_1_2 / var_1_0 * arg_1_0
	local var_1_3 = arg_1_3 / var_1_1 * arg_1_1

	return var_1_2, var_1_3
end

function TutorialUI.init(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._parent = arg_2_1
	arg_2_0.ui_renderer = arg_2_2.ui_renderer
	arg_2_0.input_manager = arg_2_2.input_manager
	arg_2_0.player_manager = arg_2_2.player_manager
	arg_2_0.camera_manager = arg_2_2.camera_manager
	arg_2_0.world_manager = arg_2_2.world_manager
	arg_2_0.peer_id = arg_2_2.peer_id
	arg_2_0.platform = PLATFORM
	arg_2_0.localized_texts = {
		hold = Localize("interaction_prefix_hold"),
		press = Localize("interaction_prefix_press"),
		to = Localize("interaction_to")
	}
	arg_2_0.render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = false
	}
	arg_2_0.tooltip_animations = {}
	arg_2_0.tooltip_alpha_multiplier = 1
	arg_2_0.info_slate_entries = {}
	arg_2_0.unused_info_slate_entry_scenegraphs = {}
	arg_2_0.info_slate_widgets = {}
	arg_2_0.entry_id_count = 0
	arg_2_0.health_bars = {}
	arg_2_0.objective_tooltip_widget_holders = {}
	arg_2_0.widgets_for_update = {}
	arg_2_0.num_widgets_for_update = 0
	arg_2_0._objective_tooltip_position_lookup = {}
	arg_2_0.queued_info_slate_entries = {}
	arg_2_0.queued_info_slate_entries.mission_goal = {}
	arg_2_0.queued_info_slate_entries.mission_objective = {}
	arg_2_0.queued_info_slate_entries.side_mission = {}
	arg_2_0.queued_info_slate_entries.tutorial = {}

	local var_2_0 = arg_2_0.world_manager:world("level_world")

	arg_2_0.wwise_world = Managers.world:wwise_world(var_2_0)

	arg_2_0:create_ui_elements()

	arg_2_0.tutorial_tooltip_ui = TutorialTooltipUI:new(arg_2_2)

	local var_2_1 = Managers.state.event

	if var_2_1 then
		var_2_1:register(arg_2_0, "tutorial_event_queue_info_slate_entry", "queue_info_slate_entry")
		var_2_1:register(arg_2_0, "tutorial_event_add_health_bar", "add_health_bar")
		var_2_1:register(arg_2_0, "tutorial_event_remove_health_bar", "remove_health_bar")
		var_2_1:register(arg_2_0, "tutorial_event_show_health_bar", "show_health_bar")
		var_2_1:register(arg_2_0, "tutorial_event_clear_tutorials", "clear_tutorials")
	end
end

function TutorialUI.create_ui_elements(arg_3_0)
	UIRenderer.clear_scenegraph_queue(arg_3_0.ui_renderer)

	arg_3_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph)
	arg_3_0.floating_icons_ui_scene_graph = UISceneGraph.init_scenegraph(var_0_0.floating_icons_scene_graph)
	arg_3_0.tooltip_mission_widget = UIWidget.init(var_0_0.widgets.tooltip_mission)
	arg_3_0.info_slate_mask = UIWidget.init(var_0_0.widgets.info_slate_mask)

	for iter_3_0 = 1, var_0_0.NUMBER_OF_INFO_SLATE_ENTRIES do
		arg_3_0.info_slate_widgets[iter_3_0] = UIWidget.init(var_0_0.info_slate_entries[iter_3_0])
	end

	arg_3_0.info_slate_widgets[var_0_1.mission_goal].style.description_text.word_wrap = false
	arg_3_0.info_slate_widgets[var_0_1.mission_goal].style.description_text.font_type = "hell_shark"
	arg_3_0.active_animations = {}

	arg_3_0:add_info_slate_entries()

	for iter_3_1 = 1, var_0_0.NUMBER_OF_OBJECTIVE_TOOLTIPS do
		local var_3_0 = "objective_tooltip_root_" .. iter_3_1
		local var_3_1 = "objective_tooltip_" .. iter_3_1
		local var_3_2 = "objective_tooltip_text" .. iter_3_1
		local var_3_3 = "objective_tooltip_icon" .. iter_3_1
		local var_3_4 = "objective_tooltip_arrow" .. iter_3_1

		arg_3_0.objective_tooltip_widget_holders[iter_3_1] = {
			widget = UIWidget.init(var_0_0.objective_tooltips[iter_3_1]),
			animations = {},
			scenegraph_root = var_3_0,
			scenegraph_id = var_3_1,
			scenegraph_text = var_3_2,
			scenegraph_icon = var_3_3,
			scenegraph_arrow = var_3_4
		}
	end

	arg_3_0._widgets = {
		arg_3_0.tooltip_widget,
		arg_3_0.tooltip_mission_widget,
		arg_3_0.info_slate_mask
	}

	for iter_3_2, iter_3_3 in pairs(arg_3_0.info_slate_widgets) do
		arg_3_0._widgets[#arg_3_0._widgets + 1] = iter_3_3
	end

	var_0_2 = false
	arg_3_0.ui_animator = UIAnimator:new(arg_3_0.ui_scenegraph, var_0_0.animations)
	arg_3_0.mission_goal_state = "invisible"
	arg_3_0.mission_objective_state = "invisible"
	arg_3_0.side_mission_state = "invisible"
	arg_3_0.tutorial_state = "invisible"
	arg_3_0.side_mission_visible_timer = 0
	arg_3_0.info_slate_slots_taken = {}
end

function TutorialUI.destroy(arg_4_0)
	local var_4_0 = Managers.state.event

	if var_4_0 then
		var_4_0:unregister("tutorial_event_queue_info_slate_entry", arg_4_0)
		var_4_0:unregister("tutorial_event_add_health_bar", arg_4_0)
		var_4_0:unregister("tutorial_event_remove_health_bar", arg_4_0)
		var_4_0:unregister("tutorial_event_show_health_bar", arg_4_0)
		var_4_0:unregister("tutorial_event_clear_tutorials", arg_4_0)
	end

	GarbageLeakDetector.register_object(arg_4_0, "interaction_gui")
end

function TutorialUI._get_player_first_person_extension(arg_5_0)
	local var_5_0 = arg_5_0.peer_id
	local var_5_1 = arg_5_0.player_manager:player_from_peer_id(var_5_0)

	return ScriptUnit.has_extension(var_5_1.player_unit, "first_person_system")
end

function TutorialUI.update(arg_6_0, arg_6_1, arg_6_2)
	if var_0_2 then
		arg_6_0:create_ui_elements()
	end

	local var_6_0 = arg_6_0.ui_renderer
	local var_6_1 = arg_6_0.ui_scenegraph
	local var_6_2 = arg_6_0.input_manager
	local var_6_3 = var_6_2:get_service("Player")
	local var_6_4 = var_6_2:is_device_active("gamepad")

	if RESOLUTION_LOOKUP.modified then
		for iter_6_0 = 1, var_0_0.NUMBER_OF_INFO_SLATE_ENTRIES do
			arg_6_0.info_slate_widgets[iter_6_0].element.dirty = true
		end

		arg_6_0.tutorial_tooltip_ui:set_dirty()
	end

	for iter_6_1, iter_6_2 in pairs(arg_6_0.tooltip_animations) do
		UIAnimation.update(iter_6_2, arg_6_1)

		if UIAnimation.completed(iter_6_2) then
			arg_6_0.tooltip_animations[iter_6_1] = nil
		end
	end

	local var_6_5 = arg_6_0.peer_id
	local var_6_6 = arg_6_0.player_manager:player_from_peer_id(var_6_5)
	local var_6_7 = var_6_6 and var_6_6.player_unit

	if not var_6_7 then
		return
	end

	if Managers.state.side:versus_is_dark_pact(var_6_7) then
		return
	end

	local var_6_8 = false
	local var_6_9 = ScriptUnit.extension(var_6_7, "tutorial_system")

	arg_6_0.mission_tutorial_tooltip_to_update = nil

	if var_6_9 then
		local var_6_10 = var_6_9.tooltip_tutorial
		local var_6_11 = var_6_10 and var_6_10.name
		local var_6_12 = var_6_11 and TutorialTemplates[var_6_11]

		if var_6_10.active then
			if var_6_12.is_mission_tutorial then
				arg_6_0.mission_tutorial_tooltip_to_update = var_6_10

				arg_6_0.tutorial_tooltip_ui:hide()
			end
		elseif arg_6_0.active_tooltip_name or arg_6_0.active_tooltip_widget then
			if var_6_12 and var_6_12.is_mission_tutorial then
				UIRenderer.set_element_visible(var_6_0, arg_6_0.active_tooltip_widget.element, false)
			else
				arg_6_0.tutorial_tooltip_ui:hide()
			end

			arg_6_0.active_tooltip_widget = nil
			arg_6_0.active_tooltip_name = nil
		end

		local var_6_13 = var_6_9.objective_tooltips

		arg_6_0:update_objective_tooltip(var_6_13, var_6_7, arg_6_1)
	elseif arg_6_0.active_tooltip_name or arg_6_0.active_tooltip_widget then
		UIRenderer.set_element_visible(var_6_0, arg_6_0.active_tooltip_widget.element, false)

		arg_6_0.active_tooltip_widget.element.dirty = true
		arg_6_0.active_tooltip_name = nil
		arg_6_0.active_tooltip_widget = nil
	end

	arg_6_0.ui_animator:update(arg_6_1)
	arg_6_0:update_info_slate_entries(arg_6_1, arg_6_2)

	if not script_data.disable_tutorial_ui and var_6_8 then
		arg_6_0.tutorial_tooltip_ui:draw(arg_6_1, arg_6_2)
	end
end

function TutorialUI.post_update(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0.floating_icons_ui_scene_graph
	local var_7_1 = arg_7_0.ui_renderer
	local var_7_2 = arg_7_0.peer_id
	local var_7_3 = arg_7_0.player_manager:player_from_peer_id(var_7_2)
	local var_7_4 = var_7_3 and var_7_3.player_unit

	if not var_7_4 then
		return
	end

	local var_7_5 = arg_7_0.input_manager
	local var_7_6 = var_7_5:get_service("Player")
	local var_7_7 = var_7_5:is_device_active("gamepad")
	local var_7_8 = ScriptUnit.extension(var_7_4, "tutorial_system")
	local var_7_9 = arg_7_0.widgets_for_update

	for iter_7_0 = 1, arg_7_0.num_widgets_for_update do
		local var_7_10 = var_7_9[iter_7_0]

		arg_7_0:update_objective_tooltip_widget(var_7_10[1], var_7_10[2], arg_7_1)
	end

	arg_7_0:update_health_bars(arg_7_1, var_7_4)

	local var_7_11 = arg_7_0.mission_tutorial_tooltip_to_update

	arg_7_0.mission_tutorial_tooltip_to_update = nil

	if var_7_11 then
		arg_7_0:update_mission_tooltip(var_7_11, var_7_4, arg_7_1)
	end

	if arg_7_0._visible and not script_data.disable_tutorial_ui then
		local var_7_12 = arg_7_0:_get_player_first_person_extension()
		local var_7_13 = arg_7_0.render_settings

		UIRenderer.begin_pass(var_7_1, var_7_0, var_7_6, arg_7_1, nil, var_7_13)

		if var_7_12.first_person_mode then
			local var_7_14 = var_7_13.alpha_multiplier
			local var_7_15 = not ScriptUnit.has_extension(var_7_4, "status_system"):get_is_aiming()

			var_7_13.alpha_multiplier = var_7_14 * math.max(0.25, UIUtils.animate_value(arg_7_0.tooltip_alpha_multiplier, arg_7_1 * 5, var_7_15))

			local var_7_16 = arg_7_0.objective_tooltip_widget_holders

			for iter_7_1 = 1, var_0_0.NUMBER_OF_OBJECTIVE_TOOLTIPS do
				local var_7_17 = var_7_16[iter_7_1]

				if var_7_17.updated then
					UIRenderer.draw_widget(var_7_1, var_7_17.widget)
				end
			end

			arg_7_0.tooltip_alpha_multiplier = var_7_13.alpha_multiplier
			var_7_13.alpha_multiplier = var_7_14
		end

		if arg_7_0.active_tooltip_widget and var_7_11 then
			UIRenderer.draw_widget(var_7_1, arg_7_0.active_tooltip_widget)
		end

		if var_7_12.first_person_mode then
			local var_7_18 = arg_7_0.health_bars

			for iter_7_2 = 1, var_0_0.NUMBER_OF_HEALTH_BARS do
				local var_7_19 = var_7_18[iter_7_2]

				if var_7_19 then
					UIRenderer.draw_widget(var_7_1, var_7_19.widget)
				end
			end
		end

		UIRenderer.end_pass(var_7_1)
	end
end

local var_0_4 = {
	var_0_0.scenegraph.root.size[1] * 0.5,
	var_0_0.scenegraph.root.size[2] * 0.5
}

function TutorialUI.update_mission_tooltip(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_0.floating_icons_ui_scene_graph
	local var_8_1 = arg_8_0.tooltip_mission_widget
	local var_8_2 = UISettings.tutorial.mission_tooltip
	local var_8_3 = arg_8_1.name
	local var_8_4 = arg_8_0.active_tooltip_name
	local var_8_5 = false

	if not var_8_4 or var_8_4 ~= var_8_3 then
		local var_8_6 = TutorialTemplates[var_8_3]
		local var_8_7 = var_8_6.text and Localize(var_8_6.text) or ""

		var_8_1.content.text = var_8_7
		arg_8_0.active_tooltip_name = var_8_3
		var_8_1.content.texture_id = var_8_6.icon and var_8_6.icon or "hud_tutorial_icon_info"
		var_8_1.style.texture_id.color[1] = 0
		var_8_1.style.arrow.color[1] = 0
		arg_8_0.mission_tooltip_animation_in_time = 0
		var_8_5 = true
	end

	if arg_8_1.world_position then
		local var_8_8 = "player_1"
		local var_8_9

		if arg_8_0.camera_manager:has_viewport(var_8_8) then
			local var_8_10 = "level_world"
			local var_8_11 = arg_8_0.world_manager

			if var_8_11:has_world(var_8_10) then
				local var_8_12 = var_8_11:world(var_8_10)
				local var_8_13 = ScriptWorld.viewport(var_8_12, var_8_8)

				var_8_9 = ScriptViewport.camera(var_8_13)
			end
		end

		local var_8_14 = arg_8_1.world_position:unbox()
		local var_8_15 = arg_8_0:_get_player_first_person_extension()
		local var_8_16 = Vector3.copy(POSITION_LOOKUP[arg_8_2])
		local var_8_17 = var_8_15:current_rotation()
		local var_8_18 = Quaternion.forward(var_8_17)
		local var_8_19 = Vector3.normalize(Vector3.flat(var_8_18))
		local var_8_20 = Vector3.normalize(var_8_14 - var_8_16)
		local var_8_21 = Vector3.normalize(Vector3.flat(var_8_20))
		local var_8_22 = Vector3.dot(var_8_19, var_8_21)
		local var_8_23 = Quaternion.right(var_8_17)
		local var_8_24 = Vector3.flat(var_8_23)
		local var_8_25 = Vector3.normalize(var_8_24)
		local var_8_26 = Vector3.dot(var_8_25, var_8_21)
		local var_8_27, var_8_28 = arg_8_0:convert_world_to_screen_position(var_8_9, var_8_14)
		local var_8_29, var_8_30, var_8_31, var_8_32 = arg_8_0:get_floating_icon_position(var_8_27, var_8_28, var_8_22, var_8_26, var_8_2)

		if var_8_31 or var_8_32 then
			if not arg_8_0.mission_tooltip_animation_in_time then
				local var_8_33 = var_8_0.tooltip_mission_arrow.size
				local var_8_34 = var_8_0.tooltip_mission_icon.size
				local var_8_35 = var_8_28 - var_0_4[2]
				local var_8_36, var_8_37, var_8_38, var_8_39 = arg_8_0:get_arrow_angle_and_offset(var_8_22, var_8_26, var_8_33, var_8_34, var_8_35)

				if var_8_37 ~= nil then
					local var_8_40 = var_8_1.style.arrow.offset

					var_8_40[1] = var_8_37
					var_8_40[2] = var_8_38
					var_8_40[3] = var_8_39
				end

				var_8_1.style.arrow.angle = var_8_36
			end
		else
			var_8_1.style.arrow.color[1] = 0
		end

		if not arg_8_0.mission_tooltip_animation_in_time then
			arg_8_0:floating_icon_animations(var_8_1, arg_8_0.tooltip_animations, var_8_32, var_8_31, var_8_2)
		end

		local var_8_41 = not var_8_31 and not var_8_32

		if arg_8_0.mission_tooltip_animation_in_time then
			arg_8_0.mission_tooltip_animation_in_time = arg_8_0:animate_in_mission_tooltip(arg_8_0.mission_tooltip_animation_in_time, var_8_41, arg_8_3, var_8_1, var_8_0.tooltip_mission_icon.size)
		elseif var_8_41 then
			local var_8_42 = var_8_0.tooltip_mission_icon.size[1]
			local var_8_43 = var_0_0.FLOATING_ICON_SIZE[1]
			local var_8_44 = 1
			local var_8_45 = arg_8_0:get_icon_size(var_8_14, var_8_16, var_8_42, var_8_43, var_8_2, var_8_44)

			var_8_0.tooltip_mission_icon.size[1] = var_8_45
			var_8_0.tooltip_mission_icon.size[2] = var_8_45
		else
			local var_8_46 = var_0_0.FLOATING_ICON_SIZE[1]

			var_8_0.tooltip_mission_icon.size[1] = var_8_46
			var_8_0.tooltip_mission_icon.size[2] = var_8_46
		end

		local var_8_47 = var_8_0.tooltip_mission_root.local_position
		local var_8_48 = arg_8_0.mission_tooltip_use_screen_position

		if var_8_48 and not var_8_41 or not var_8_48 and var_8_41 then
			arg_8_0.mission_tooltip_lerp_speed = 0
		end

		if not var_8_5 and arg_8_0.mission_tooltip_lerp_speed then
			local var_8_49 = arg_8_0.mission_tooltip_lerp_speed
			local var_8_50 = math.min(var_8_49 + arg_8_3, 1)

			var_8_47[1] = math.lerp(var_8_47[1], var_8_29, var_8_50)
			var_8_47[2] = math.lerp(var_8_47[2], var_8_30, var_8_50)

			if var_8_50 == 1 then
				arg_8_0.mission_tooltip_lerp_speed = nil
			else
				arg_8_0.mission_tooltip_lerp_speed = var_8_50
			end
		else
			var_8_47[1] = var_8_29
			var_8_47[2] = var_8_30
		end

		arg_8_0.mission_tooltip_use_screen_position = var_8_41
	else
		var_8_0.tooltip_mission_root.local_position[1] = 0
		var_8_0.tooltip_mission_root.local_position[2] = 0
	end

	arg_8_0.active_tooltip_widget = var_8_1
end

local var_0_5 = {}
local var_0_6 = {}
local var_0_7 = Unit.alive

function TutorialUI.update_objective_tooltip(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = arg_9_1.name
	local var_9_1 = arg_9_1.units
	local var_9_2 = arg_9_1.units_n
	local var_9_3 = arg_9_0.objective_tooltip_widget_holders
	local var_9_4 = var_0_0.NUMBER_OF_OBJECTIVE_TOOLTIPS
	local var_9_5 = 0
	local var_9_6 = arg_9_0.widgets_for_update

	table.clear(var_0_5)

	for iter_9_0 = 1, var_9_4 do
		local var_9_7 = var_9_3[iter_9_0]

		var_9_7.updated = false

		if var_9_7.unit then
			var_0_5[var_9_7.unit] = iter_9_0
		end
	end

	local var_9_8 = 0
	local var_9_9 = math.min(var_9_2, var_9_4)

	table.clear(arg_9_0._objective_tooltip_position_lookup)

	for iter_9_1 = 1, var_9_9 do
		repeat
			local var_9_10 = var_9_1[iter_9_1]

			if not var_0_7(var_9_10) then
				break
			end

			local var_9_11 = var_0_5[var_9_10]

			if var_9_11 then
				local var_9_12 = var_9_3[var_9_11]
				local var_9_13 = var_9_12.animations

				for iter_9_2, iter_9_3 in pairs(var_9_13) do
					UIAnimation.update(iter_9_3, arg_9_3)

					if UIAnimation.completed(iter_9_3) then
						var_9_13[iter_9_2] = nil
					end
				end

				var_9_5 = var_9_5 + 1

				local var_9_14 = var_9_6[var_9_5]

				if not var_9_14 then
					var_9_14 = {}
					var_9_6[var_9_5] = var_9_14
				end

				var_9_14[1] = var_9_12
				var_9_14[2] = arg_9_2
				var_9_12.updated = true

				break
			end

			var_9_8 = var_9_8 + 1
			var_0_6[var_9_8] = var_9_10
		until true
	end

	for iter_9_4 = 1, var_9_4 do
		local var_9_15 = var_9_3[iter_9_4]

		if not var_9_15.updated then
			var_9_15.unit = nil
		end
	end

	for iter_9_5 = 1, var_9_8 do
		local var_9_16

		for iter_9_6 = 1, var_9_4 do
			if not var_9_3[iter_9_6].updated then
				var_9_16 = var_9_3[iter_9_6]

				break
			end
		end

		fassert(var_9_16 ~= nil, "sanity check")

		var_9_16.unit = var_0_6[iter_9_5]

		arg_9_0:setup_objective_tooltip_widget(var_9_16, arg_9_1, arg_9_2, arg_9_3)

		var_9_5 = var_9_5 + 1

		local var_9_17 = var_9_6[var_9_5]

		if not var_9_17 then
			var_9_17 = {}
			var_9_6[var_9_5] = var_9_17
		end

		var_9_17[1] = var_9_16
		var_9_17[2] = arg_9_2
		var_9_16.updated = true
	end

	arg_9_0.num_widgets_for_update = var_9_5
end

function TutorialUI.setup_objective_tooltip_widget(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	local var_10_0 = arg_10_1.widget
	local var_10_1 = arg_10_2.name
	local var_10_2 = TutorialTemplates[var_10_1]
	local var_10_3 = arg_10_1.unit
	local var_10_4 = Unit.alive(var_10_3) and Unit.get_data(var_10_3, "tutorial_text_id") or var_10_2.text or ""

	if var_10_2.alerts_horde then
		var_10_4 = var_10_4 .. "_alert_horde"
	end

	var_10_0.content.text = var_10_4 ~= "" and Localize(var_10_4) or ""

	if var_10_2.wave then
		var_10_0.content.text = var_10_4 ~= "" and Localize(var_10_4) .. var_10_2.wave or ""
	end

	var_10_0.content.texture_id = var_10_2.icon or "hud_tutorial_icon_info"

	local var_10_5 = Managers.state.game_mode:game_mode_key()

	if var_10_5 and var_10_2.game_mode_icons and var_10_2.game_mode_icons[var_10_5] then
		var_10_0.content.texture_id = var_10_2.game_mode_icons[var_10_5]
	end

	var_10_0.style.texture_id.color[1] = 0
	var_10_0.style.arrow.color[1] = 0
	var_10_0.content.size_scale = Unit.get_data(var_10_3, "tutorial_size_scale") or 1

	local var_10_6 = Unit.get_data(var_10_3, "tutorial_position_offset", "x")

	if var_10_6 ~= nil then
		local var_10_7 = Unit.get_data(var_10_3, "tutorial_position_offset", "y")
		local var_10_8 = Unit.get_data(var_10_3, "tutorial_position_offset", "z")

		var_10_0.content.position_offset = Vector3Box(var_10_6, var_10_7, var_10_8)
	end
end

function TutorialUI._floating_icon_overlap(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0 = arg_11_0._objective_tooltip_position_lookup
	local var_11_1

	for iter_11_0, iter_11_1 in pairs(var_11_0) do
		if (arg_11_2 >= iter_11_1[1] and arg_11_2 <= iter_11_1[1] + 200 * arg_11_4 or arg_11_2 <= iter_11_1[1] and arg_11_2 + 200 * arg_11_4 >= iter_11_1[1]) and (arg_11_3 >= iter_11_1[2] and arg_11_3 <= iter_11_1[2] + var_0_0.FLOATING_ICON_SIZE[2] * arg_11_4 or arg_11_3 <= iter_11_1[2] and arg_11_3 + var_0_0.FLOATING_ICON_SIZE[2] * arg_11_4 >= iter_11_1[2]) then
			if arg_11_3 < iter_11_1[2] then
				var_11_1 = -var_0_0.FLOATING_ICON_SIZE[2] * 0.75 * arg_11_4

				break
			end

			var_11_1 = var_0_0.FLOATING_ICON_SIZE[2] * 0.75 * arg_11_4

			break
		end
	end

	var_11_0[arg_11_1.scenegraph_id] = {
		arg_11_2,
		arg_11_3
	}

	return var_11_1
end

local var_0_8 = UISettings.tutorial.objective_tooltip

function TutorialUI.update_objective_tooltip_widget(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = "player_1"
	local var_12_1

	if arg_12_0.camera_manager:has_viewport(var_12_0) then
		local var_12_2 = "level_world"
		local var_12_3 = arg_12_0.world_manager

		if var_12_3:has_world(var_12_2) then
			local var_12_4 = var_12_3:world(var_12_2)
			local var_12_5 = ScriptWorld.viewport(var_12_4, var_12_0)

			var_12_1 = ScriptViewport.camera(var_12_5)
		end
	end

	local var_12_6 = arg_12_1.unit

	if not var_12_6 or not Unit.alive(var_12_6) or not Unit.alive(arg_12_2) then
		return
	end

	local var_12_7 = arg_12_1.widget
	local var_12_8 = var_12_7.content.position_offset and Vector3.up() + var_12_7.content.position_offset:unbox()

	if Unit.get_data(var_12_6, "breed") then
		var_12_8 = Vector3(0, 0, AiUtils.breed_height(var_12_6) + 0.75)
	end

	var_12_8 = var_12_8 or Vector3.up()

	local var_12_9 = Unit.world_position(var_12_6, 0) + var_12_8
	local var_12_10 = arg_12_0:_get_player_first_person_extension()
	local var_12_11 = var_12_10:current_position()
	local var_12_12 = var_12_10:current_rotation()
	local var_12_13 = Quaternion.forward(var_12_12)
	local var_12_14 = Vector3.normalize(Vector3.flat(var_12_13))
	local var_12_15 = Quaternion.right(var_12_12)
	local var_12_16 = Vector3.normalize(Vector3.flat(var_12_15))
	local var_12_17 = var_12_9 - var_12_11
	local var_12_18 = Vector3.normalize(Vector3.flat(var_12_17))
	local var_12_19 = Vector3.dot(var_12_14, var_12_18)
	local var_12_20 = Vector3.dot(var_12_16, var_12_18)
	local var_12_21, var_12_22 = arg_12_0:convert_world_to_screen_position(var_12_1, var_12_9)
	local var_12_23, var_12_24, var_12_25, var_12_26 = arg_12_0:get_floating_icon_position(var_12_21, var_12_22, var_12_19, var_12_20, var_0_8)
	local var_12_27 = arg_12_0.floating_icons_ui_scene_graph
	local var_12_28 = arg_12_1.widget
	local var_12_29 = arg_12_1.animation_in_time

	if var_12_25 or var_12_26 then
		if not var_12_29 then
			local var_12_30 = var_12_27[arg_12_1.scenegraph_arrow].size
			local var_12_31 = var_12_27[arg_12_1.scenegraph_icon].size
			local var_12_32 = var_12_22 - var_0_4[2]
			local var_12_33, var_12_34, var_12_35, var_12_36 = arg_12_0:get_arrow_angle_and_offset(var_12_19, var_12_20, var_12_30, var_12_31, var_12_32)

			if var_12_34 ~= nil then
				local var_12_37 = var_12_28.style.arrow.offset

				var_12_37[1] = var_12_34
				var_12_37[2] = var_12_35
				var_12_37[3] = var_12_36
			end

			var_12_28.style.arrow.angle = var_12_33
		end
	else
		var_12_28.style.arrow.color[1] = 0
	end

	if not var_12_29 then
		arg_12_0:floating_icon_animations(var_12_28, arg_12_1.animations, var_12_26, var_12_25, var_0_8)
	end

	local var_12_38 = not var_12_25 and not var_12_26

	if var_12_29 then
		local var_12_39 = var_12_27[arg_12_1.scenegraph_icon].size

		arg_12_1.animation_in_time = arg_12_0:animate_in_mission_tooltip(var_12_29, var_12_38, arg_12_3, var_12_28, var_12_39)
	elseif var_12_38 then
		local var_12_40 = var_12_27[arg_12_1.scenegraph_icon].size[1]
		local var_12_41 = var_0_0.FLOATING_ICON_SIZE[1]
		local var_12_42 = var_12_28.content.size_scale
		local var_12_43, var_12_44 = arg_12_0:get_icon_size(var_12_9, var_12_11, var_12_40, var_12_41, var_0_8, var_12_42)

		var_12_27.tooltip_mission_icon.size[1] = var_12_43
		var_12_27.tooltip_mission_icon.size[2] = var_12_43
		var_12_28.style.texture_id.size[1] = var_12_43
		var_12_28.style.texture_id.size[2] = var_12_43
		var_12_28.style.texture_id.offset[2] = var_12_43 * (1 - var_12_44)

		local var_12_45 = math.lerp(arg_12_1.current_font_size or 30, var_12_44 * 30, 0.2)

		var_12_28.style.text.font_size = var_12_45

		if var_12_28.style.text_shadow then
			var_12_28.style.text_shadow.font_size = var_12_45
		end

		var_12_27[arg_12_1.scenegraph_icon].size[1] = var_12_43
		arg_12_1.current_font_size = var_12_45

		local var_12_46 = arg_12_0:_floating_icon_overlap(arg_12_1, var_12_23, var_12_24, var_12_44)

		if var_12_46 then
			var_12_24 = var_12_24 + var_12_46
			arg_12_1.lerp_speed = 0.6
		end
	else
		local var_12_47 = var_0_0.FLOATING_ICON_SIZE[1]
		local var_12_48 = var_12_27[arg_12_1.scenegraph_icon].size

		var_12_48[1] = var_12_47
		var_12_48[2] = var_12_47
		var_12_28.style.texture_id.size[1] = var_12_47
		var_12_28.style.texture_id.size[2] = var_12_47
		var_12_28.style.texture_id.offset[2] = 0
		var_12_28.style.text.font_size = 30

		if var_12_28.style.text_shadow then
			var_12_28.style.text_shadow.font_size = 30
		end

		var_12_27[arg_12_1.scenegraph_icon].size[1] = var_12_47
	end

	local var_12_49 = arg_12_1.use_screen_position

	if var_12_49 and not var_12_38 or not var_12_49 and var_12_38 then
		arg_12_1.lerp_speed = 0
	end

	local var_12_50 = var_12_27[arg_12_1.scenegraph_root].local_position

	if arg_12_1.lerp_speed then
		local var_12_51 = arg_12_1.lerp_speed
		local var_12_52 = math.min(var_12_51 + arg_12_3, 1)

		var_12_50[1] = math.lerp(var_12_50[1], var_12_23, var_12_52)
		var_12_50[2] = math.lerp(var_12_50[2], var_12_24, var_12_52)

		if var_12_52 == 1 then
			arg_12_1.lerp_speed = nil
		else
			arg_12_1.lerp_speed = var_12_52
		end
	else
		var_12_50[1] = var_12_23
		var_12_50[2] = var_12_24
	end

	arg_12_1.use_screen_position = var_12_38
end

function TutorialUI.get_floating_icon_position(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	local var_13_0 = UISceneGraph.get_size_scaled(arg_13_0.ui_scenegraph, "root")
	local var_13_1 = RESOLUTION_LOOKUP.scale
	local var_13_2 = var_13_0[1] * var_13_1
	local var_13_3 = var_13_0[2] * var_13_1
	local var_13_4 = var_13_2 * 0.5
	local var_13_5 = var_13_3 * 0.5
	local var_13_6 = RESOLUTION_LOOKUP.res_w
	local var_13_7 = RESOLUTION_LOOKUP.res_h
	local var_13_8 = var_13_6 / 2
	local var_13_9 = var_13_7 / 2
	local var_13_10 = arg_13_1 - var_13_8
	local var_13_11 = var_13_9 - arg_13_2
	local var_13_12 = false
	local var_13_13 = false

	if math.abs(var_13_10) > var_13_4 * 0.9 then
		var_13_12 = true
	end

	if math.abs(var_13_11) > var_13_5 * 0.9 then
		var_13_13 = true
	end

	local var_13_14 = arg_13_1
	local var_13_15 = arg_13_2
	local var_13_16 = arg_13_3 < 0 and true or false
	local var_13_17 = (var_13_12 or var_13_13) and true or false

	if var_13_17 or var_13_16 then
		local var_13_18 = arg_13_5.distance_from_center

		var_13_14 = var_13_4 + arg_13_4 * var_13_18.width * var_13_1
		var_13_15 = var_13_5 + arg_13_3 * var_13_18.height * var_13_1
	else
		local var_13_19 = var_13_6 - var_13_2
		local var_13_20 = var_13_7 - var_13_3

		var_13_14 = var_13_14 - var_13_19 / 2
		var_13_15 = var_13_15 - var_13_20 / 2
	end

	local var_13_21 = RESOLUTION_LOOKUP.inv_scale
	local var_13_22 = var_13_14 * var_13_21
	local var_13_23 = var_13_15 * var_13_21

	return var_13_22, var_13_23, var_13_17, var_13_16
end

function TutorialUI.floating_icon_animations(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	local var_14_0 = arg_14_1.style.texture_id
	local var_14_1 = arg_14_1.style.text
	local var_14_2 = arg_14_1.style.text_shadow

	if arg_14_4 or arg_14_3 then
		local var_14_3 = arg_14_5.alpha_fade_out_value

		arg_14_1.style.arrow.color[1] = var_14_3

		if not arg_14_2.out_of_view and var_14_0.color[1] ~= var_14_3 then
			arg_14_2.in_of_view = nil
			arg_14_2.in_of_view_text = nil
			arg_14_2.in_of_view_text_shadow = nil

			local var_14_4 = arg_14_5.fade_out_time

			arg_14_2.out_of_view = UIAnimation.init(UIAnimation.function_by_time, var_14_0.color, 1, var_14_0.color[1], var_14_3, var_14_4, math.easeInCubic)
			var_14_1.text_color[1] = 0
			var_14_2.text_color[1] = 0
		end
	else
		arg_14_1.style.arrow.color[1] = 0
		arg_14_2.out_of_view = nil

		if not arg_14_2.in_of_view and var_14_0.color[1] ~= 255 then
			local var_14_5 = arg_14_5.fade_in_time

			arg_14_2.in_of_view = UIAnimation.init(UIAnimation.function_by_time, var_14_0.color, 1, var_14_0.color[1], 255, var_14_5, math.easeInCubic)
		end

		if not arg_14_2.in_of_view_text and var_14_1.text_color[1] ~= 255 then
			local var_14_6 = arg_14_5.fade_in_time

			arg_14_2.in_of_view_text = UIAnimation.init(UIAnimation.function_by_time, var_14_1.text_color, 1, var_14_1.text_color[1], 255, var_14_6, math.easeInCubic)
			arg_14_2.in_of_view_text_shadow = UIAnimation.init(UIAnimation.function_by_time, var_14_2.text_color, 1, var_14_2.text_color[1], 255, var_14_6, math.easeInCubic)
		end
	end
end

function TutorialUI.get_arrow_angle_and_offset(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	local var_15_0 = 1.57079633
	local var_15_1 = 0
	local var_15_2 = 0
	local var_15_3 = 0
	local var_15_4 = math.atan2(arg_15_2, arg_15_1)

	if arg_15_5 < -400 and arg_15_1 > 0.6 then
		var_15_2 = -(arg_15_4[2] * 0.5 + arg_15_3[2])
		var_15_0 = var_15_0 * 2
	elseif arg_15_5 > 400 and arg_15_1 > 0.6 then
		var_15_2 = arg_15_4[2] * 0.5 + arg_15_3[2]
		var_15_0 = 0
	elseif var_15_4 > 0 then
		var_15_1 = arg_15_4[2] * 0.5 + arg_15_3[2]
	elseif var_15_4 < 0 then
		var_15_1 = -(arg_15_4[2] * 0.5 + arg_15_3[2])
		var_15_0 = -var_15_0
	else
		var_15_1 = nil
		var_15_2 = nil
		var_15_3 = nil
		var_15_0 = 0
	end

	return var_15_0, var_15_1, var_15_2, var_15_3
end

function TutorialUI.get_icon_size(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6)
	local var_16_0 = arg_16_4 * arg_16_6
	local var_16_1 = var_16_0
	local var_16_2 = arg_16_5.start_scale_distance
	local var_16_3 = arg_16_5.end_scale_distance
	local var_16_4 = Vector3.distance(arg_16_1, arg_16_2)
	local var_16_5 = 1

	if var_16_2 < var_16_4 then
		var_16_5 = arg_16_0:icon_scale_by_distance(var_16_4 - var_16_2, var_16_3)
		var_16_1 = math.lerp(arg_16_3, var_16_5 * var_16_0, 0.2)
	end

	return var_16_1, var_16_5
end

function TutorialUI.icon_scale_by_distance(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = math.min(arg_17_2, arg_17_1)
	local var_17_1 = math.max(0, var_17_0)
	local var_17_2 = UISettings.tutorial.mission_tooltip.minimum_icon_scale

	return (math.max(var_17_2, 1 - var_17_1 / arg_17_2))
end

function TutorialUI.distance_between_screen_positions(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_1[1] - arg_18_2[1]
	local var_18_1 = arg_18_1[2] - arg_18_2[2]

	var_18_0 = var_18_0 < 0 and -1 * var_18_0 or var_18_0
	var_18_1 = var_18_1 < 0 and -1 * var_18_1 or var_18_1

	return {
		var_18_0,
		var_18_1
	}
end

function TutorialUI.convert_world_to_screen_position(arg_19_0, arg_19_1, arg_19_2)
	if arg_19_1 then
		local var_19_0 = Camera.world_to_screen(arg_19_1, arg_19_2)

		return var_19_0.x, var_19_0.y
	end
end

function TutorialUI.animate_in_mission_tooltip(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	local var_20_0 = arg_20_4.style.texture_id
	local var_20_1 = arg_20_4.style.text
	local var_20_2 = 0.5

	arg_20_1 = arg_20_1 + arg_20_3

	local var_20_3 = math.min(arg_20_1 / var_20_2, 1)
	local var_20_4 = math.min(var_20_3 / 0.5, 1)
	local var_20_5 = math.min(math.max(0, (var_20_3 - 0.5) / 0.5), 1)
	local var_20_6 = math.catmullrom(var_20_4, 1, 0.9, 1, -0.1)
	local var_20_7 = arg_20_4.style.texture_id
	local var_20_8 = var_20_6 * var_0_0.FLOATING_ICON_SIZE[1]

	arg_20_5[1] = var_20_8
	arg_20_5[2] = var_20_8
	var_20_7.color[1] = math.min(var_20_3 * 4, 1) * 255

	local var_20_9 = arg_20_2 and 255 * var_20_5 or 0

	arg_20_4.style.text.text_color[1] = var_20_9

	if arg_20_4.style.text_shadow then
		arg_20_4.style.text_shadow.text_color[1] = var_20_9
	end

	return var_20_3 < 1 and arg_20_1 or nil
end

function TutorialUI.add_info_slate_entries(arg_21_0)
	for iter_21_0 = 1, var_0_0.NUMBER_OF_INFO_SLATE_ENTRIES do
		local var_21_0 = arg_21_0.info_slate_widgets[iter_21_0]
		local var_21_1 = var_21_0.scenegraph_id

		var_21_0.style.background_texture.color[1] = 0

		local var_21_2 = var_21_1 .. "_text"
		local var_21_3 = var_21_1 .. "_icon"
		local var_21_4 = var_21_1 .. "_icon_root"
		local var_21_5 = var_21_1 .. "_left_frame"
		local var_21_6 = var_21_1 .. "_frame_glow_middle"
		local var_21_7 = var_21_1 .. "_frame_glow_uv"

		if var_0_1[iter_21_0] == "mission_goal" then
			var_21_0.content.icon_texture.texture_id = "hud_tutorial_icon_mission"
		elseif var_0_1[iter_21_0] ~= "tutorial" then
			var_21_0.content.icon_texture.texture_id = "hud_tutorial_icon_sidemission"
		end

		local var_21_8 = {
			widget = var_21_0,
			scenegraph_id = var_21_1,
			text_scenegraph_id = var_21_2,
			icon_scenegraph_id = var_21_3,
			icon_root_scenegraph_id = var_21_4,
			entry_id = iter_21_0
		}

		arg_21_0.info_slate_entries[iter_21_0] = var_21_8
	end
end

function TutorialUI.queue_info_slate_entry(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7)
	local var_22_0 = arg_22_0.entry_id_count + 1

	arg_22_0.queued_info_slate_entries[arg_22_1][var_22_0] = {
		text = arg_22_2,
		icon_texture = arg_22_3,
		update_sound = arg_22_4,
		entry_id = var_22_0,
		template = arg_22_5,
		unit = arg_22_6,
		raycast_unit = arg_22_7
	}
	arg_22_0.entry_id_count = var_22_0

	return var_22_0
end

function TutorialUI.clear_tutorials(arg_23_0)
	arg_23_0.queued_info_slate_entries.tutorial = {}

	local var_23_0 = arg_23_0.ui_animator
	local var_23_1 = arg_23_0.info_slate_entries[var_0_1.tutorial].widget
	local var_23_2 = var_0_0.scenegraph[var_23_1.scenegraph_id]

	if arg_23_0.tutorial_state ~= "animating_out" and arg_23_0.tutorial_state ~= "invisible" then
		arg_23_0.tutorial_anim_id = var_23_0:start_animation("info_slate_exit", var_23_1, var_23_2)
		arg_23_0.tutorial_state = "animating_out"
	end
end

function TutorialUI.complete_mission_info_slate(arg_24_0, arg_24_1, arg_24_2)
	if arg_24_1 == "side_mission" then
		return
	end

	arg_24_0:play_sound("hud_info_slate_mission_complete")

	local var_24_0 = arg_24_0.queued_info_slate_entries[arg_24_1]

	for iter_24_0, iter_24_1 in pairs(var_24_0) do
		if iter_24_1.entry_id == arg_24_2 then
			var_24_0[iter_24_0] = nil

			return
		end
	end
end

function TutorialUI.update_info_slate_entry_text(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	local var_25_0 = arg_25_0.queued_info_slate_entries[arg_25_1]

	for iter_25_0, iter_25_1 in pairs(var_25_0) do
		if iter_25_1.entry_id == arg_25_2 then
			local var_25_1 = iter_25_1.widget

			iter_25_1.updated = true
			iter_25_1.text = arg_25_3

			arg_25_0:play_sound("hud_info_slate_mission_update")

			return
		end
	end
end

local var_0_9 = {
	slot_1 = {
		end_id = "info_slate_slot1_end",
		start_id = "info_slate_slot1_start"
	},
	slot_2 = {
		end_id = "info_slate_slot2_end",
		start_id = "info_slate_slot2_start"
	}
}

function TutorialUI.update_info_slate_entries(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = arg_26_0.ui_scenegraph
	local var_26_1 = arg_26_0.ui_animator

	if arg_26_0.info_slate_entries then
		local var_26_2 = arg_26_0.queued_info_slate_entries.mission_goal
		local var_26_3 = arg_26_0.info_slate_entries[var_0_1.mission_goal].widget
		local var_26_4 = var_0_0.scenegraph[var_26_3.scenegraph_id]

		arg_26_0.mission_goal_state = arg_26_0.mission_goal_state or "invisible"

		if arg_26_0.mission_goal_state == "invisible" and arg_26_0.mission_objective_state == "invisible" then
			local var_26_5 = next(var_26_2)

			if var_26_5 and not arg_26_0.info_slate_slots_taken[1] then
				arg_26_0.info_slate_slots_taken[1] = true

				local var_26_6 = var_26_2[var_26_5]
				local var_26_7 = var_26_6.text

				arg_26_0.mission_goal_entry = var_26_6
				var_26_3.content.description_text = var_26_7
				arg_26_0.mission_goal_anim_id = var_26_1:start_animation("info_slate_enter", var_26_3, var_26_4, var_0_9.slot_1)

				arg_26_0:play_sound("hud_info_slate_mission_entry")

				arg_26_0.mission_goal_state = "animating_in"
			end
		elseif arg_26_0.mission_goal_state == "animating_in" then
			if var_26_1:is_animation_completed(arg_26_0.mission_goal_anim_id) then
				arg_26_0.mission_goal_anim_id = var_26_1:start_animation("mission_goal_wait", var_26_3, var_26_4)
				arg_26_0.mission_goal_state = "waiting"
			end
		elseif arg_26_0.mission_goal_state == "waiting" then
			if var_26_1:is_animation_completed(arg_26_0.mission_goal_anim_id) then
				arg_26_0.mission_goal_anim_id = var_26_1:start_animation("mission_goal_move_up", var_26_3, var_26_4)
				arg_26_0.mission_goal_state = "animating_up"
			end
		elseif arg_26_0.mission_goal_state == "animating_up" then
			if var_26_1:is_animation_completed(arg_26_0.mission_goal_anim_id) then
				arg_26_0.mission_goal_anim_id = nil
				arg_26_0.mission_goal_state = "visible"
			end
		elseif arg_26_0.mission_goal_state == "visible" then
			if var_26_2[arg_26_0.mission_goal_entry.entry_id] == nil then
				arg_26_0.mission_goal_anim_id = var_26_1:start_animation("info_slate_exit", var_26_3, var_26_4)
				arg_26_0.mission_goal_state = "animating_out"
			elseif next(arg_26_0.queued_info_slate_entries.mission_objective) ~= nil then
				arg_26_0.mission_goal_anim_id = var_26_1:start_animation("info_slate_exit", var_26_3, var_26_4)
				arg_26_0.mission_goal_state = "animating_out"
			end
		elseif arg_26_0.mission_goal_state == "animating_out" and var_26_1:is_animation_completed(arg_26_0.mission_goal_anim_id) then
			UIRenderer.set_element_visible(arg_26_0.ui_renderer, var_26_3.element, false)

			arg_26_0.info_slate_slots_taken[1] = false
			arg_26_0.mission_goal_state = "invisible"
		end

		local var_26_8 = arg_26_0.queued_info_slate_entries.mission_objective
		local var_26_9 = arg_26_0.info_slate_entries[var_0_1.mission_objective]
		local var_26_10 = var_26_9.widget
		local var_26_11 = var_0_0.scenegraph[var_26_10.scenegraph_id]

		arg_26_0.mission_objective_state = arg_26_0.mission_objective_state or "invisible"

		if arg_26_0.mission_objective_state == "invisible" then
			local var_26_12 = next(var_26_8)

			if var_26_12 and not arg_26_0.info_slate_slots_taken[1] then
				for iter_26_0 = 1, 1 do
					if not arg_26_0.info_slate_slots_taken[iter_26_0] then
						arg_26_0.info_slate_slots_taken[iter_26_0] = true

						local var_26_13 = var_26_8[var_26_12]

						var_26_13.slot = iter_26_0

						local var_26_14 = var_26_13.text

						arg_26_0.mission_objective_entry = var_26_13
						var_26_10.content.description_text = var_26_14
						arg_26_0.mission_objective_anim_id = var_26_1:start_animation("info_slate_enter", var_26_10, var_26_11, var_0_9[iter_26_0 == 1 and "slot_1" or "slot_2"])

						local var_26_15 = var_0_0.INFO_SLATE_ENTRY_SIZE
						local var_26_16 = var_26_9.text_scenegraph_id
						local var_26_17 = var_26_9.icon_scenegraph_id
						local var_26_18 = var_26_10.style.description_text
						local var_26_19, var_26_20 = arg_26_0:info_slate_text_height(var_26_14, var_26_18)
						local var_26_21 = math.max(var_26_15[2], var_26_19)

						var_26_0[var_26_16].size[2] = var_26_21

						local var_26_22 = var_26_0[var_26_10.scenegraph_id].size[2]

						var_26_0[var_26_10.scenegraph_id].size[2] = var_26_21
						var_26_0[var_26_10.scenegraph_id].position[2] = var_26_0[var_26_10.scenegraph_id].position[2] - var_26_21 + var_26_15[2]
						var_26_0[var_26_9.icon_root_scenegraph_id].vertical_alignment = var_26_20 > 1 and "top" or "center"
						var_26_0[var_26_9.icon_root_scenegraph_id].position[2] = var_26_20 > 1 and -10 or 0

						arg_26_0:play_sound("hud_info_slate_mission_entry")

						arg_26_0.mission_objective_state = "animating_in"

						break
					end
				end
			end
		elseif arg_26_0.mission_objective_state == "animating_in" then
			if var_26_1:is_animation_completed(arg_26_0.mission_objective_anim_id) then
				arg_26_0.mission_objective_anim_id = var_26_1:start_animation("mission_goal_wait", var_26_10, var_26_11)
				arg_26_0.mission_objective_state = "visible"
			end
		elseif arg_26_0.mission_objective_state == "visible" then
			if arg_26_0.mission_objective_entry.updated then
				arg_26_0.mission_objective_entry.updated = nil
				arg_26_0.mission_objective_anim_id = var_26_1:start_animation("info_slate_flash", var_26_10, var_26_11)
				arg_26_0.mission_objective_state = "flashing"
				var_26_10.content.description_text = arg_26_0.mission_objective_entry.text
			elseif var_26_8[arg_26_0.mission_objective_entry.entry_id] == nil then
				arg_26_0.mission_objective_anim_id = var_26_1:start_animation("info_slate_exit", var_26_10, var_26_11)
				arg_26_0.mission_objective_state = "animating_out"
			end
		elseif arg_26_0.mission_objective_state == "moving" then
			if var_26_1:is_animation_completed(arg_26_0.mission_objective_anim_id) then
				arg_26_0.mission_objective_state = "visible"
			end
		elseif arg_26_0.mission_objective_state == "flashing" then
			if var_26_1:is_animation_completed(arg_26_0.mission_objective_anim_id) then
				arg_26_0.mission_objective_state = "visible"
			end
		elseif arg_26_0.mission_objective_state == "animating_out" and var_26_1:is_animation_completed(arg_26_0.mission_objective_anim_id) then
			UIRenderer.set_element_visible(arg_26_0.ui_renderer, var_26_10.element, false)

			arg_26_0.info_slate_slots_taken[arg_26_0.mission_objective_entry.slot] = false
			arg_26_0.mission_objective_state = "invisible"
		end

		local var_26_23 = arg_26_0.queued_info_slate_entries.side_mission
		local var_26_24 = arg_26_0.info_slate_entries[var_0_1.side_mission].widget
		local var_26_25 = var_0_0.scenegraph[var_26_24.scenegraph_id]

		arg_26_0.side_mission_state = arg_26_0.side_mission_state or "invisible"

		if arg_26_0.side_mission_state == "invisible" then
			for iter_26_1, iter_26_2 in pairs(var_26_23) do
				if iter_26_2.updated then
					arg_26_0.side_mission_state = "waiting_for_tutorial"

					break
				end
			end
		elseif arg_26_0.side_mission_state == "waiting_for_tutorial" and arg_26_0.tutorial_state == "invisible" then
			for iter_26_3 = 2, 2 do
				if not arg_26_0.info_slate_slots_taken[iter_26_3] then
					arg_26_0.info_slate_slots_taken[iter_26_3] = true

					local var_26_26 = var_26_23[next(var_26_23)]

					var_26_26.slot = iter_26_3

					local var_26_27 = var_26_26.text

					arg_26_0.side_mission_entry = var_26_26
					var_26_24.content.description_text = var_26_27

					local var_26_28 = iter_26_3 == 1 and "slot_1" or iter_26_3 == 2 and "slot_2" or "slot_3"

					arg_26_0.side_mission_anim_id = var_26_1:start_animation("info_slate_enter", var_26_24, var_26_25, var_0_9[var_26_28])
					arg_26_0.side_mission_state = "animating_in"

					break
				end
			end
		elseif arg_26_0.side_mission_state == "animating_in" then
			if var_26_1:is_animation_completed(arg_26_0.side_mission_anim_id) then
				arg_26_0.side_mission_anim_id = var_26_1:start_animation("mission_goal_wait", var_26_24, var_26_25)
				arg_26_0.side_mission_visible_timer = 0
				arg_26_0.side_mission_state = "visible"
			end
		elseif arg_26_0.side_mission_state == "visible" then
			arg_26_0.side_mission_visible_timer = arg_26_0.side_mission_visible_timer + arg_26_1

			if arg_26_0.side_mission_visible_timer > 1 then
				local var_26_29 = arg_26_0.side_mission_entry.slot
				local var_26_30 = var_26_29 == 1 and "slot_1" or var_26_29 == 2 and "slot_2" or "slot_3"

				arg_26_0.side_mission_anim_id = var_26_1:start_animation("info_slate_exit", var_26_24, var_26_25, var_0_9[var_26_30])
				arg_26_0.side_mission_state = "animating_out"
			elseif arg_26_0.side_mission_entry.updated then
				arg_26_0.side_mission_entry.updated = nil
				arg_26_0.side_mission_anim_id = var_26_1:start_animation("info_slate_flash", var_26_24, var_26_25)
				arg_26_0.side_mission_state = "flashing"
				var_26_24.content.description_text = arg_26_0.side_mission_entry.text
			elseif var_26_23[arg_26_0.side_mission_entry.entry_id] == nil then
				arg_26_0.side_mission_anim_id = var_26_1:start_animation("info_slate_exit", var_26_24, var_26_25)
				arg_26_0.side_mission_state = "animating_out"
			end
		elseif arg_26_0.side_mission_state == "moving" then
			if var_26_1:is_animation_completed(arg_26_0.side_mission_anim_id) then
				arg_26_0.side_mission_visible_timer = 0
				arg_26_0.side_mission_state = "visible"
			end
		elseif arg_26_0.side_mission_state == "flashing" then
			if var_26_1:is_animation_completed(arg_26_0.side_mission_anim_id) then
				arg_26_0.side_mission_visible_timer = 0
				arg_26_0.side_mission_state = "visible"
			end
		elseif arg_26_0.side_mission_state == "animating_out" and var_26_1:is_animation_completed(arg_26_0.side_mission_anim_id) then
			UIRenderer.set_element_visible(arg_26_0.ui_renderer, var_26_24.element, false)

			arg_26_0.info_slate_slots_taken[arg_26_0.side_mission_entry.slot] = false
			arg_26_0.side_mission_state = "invisible"
		end

		local var_26_31 = arg_26_0.queued_info_slate_entries.tutorial
		local var_26_32 = arg_26_0.info_slate_entries[var_0_1.tutorial]
		local var_26_33 = var_26_32.widget
		local var_26_34 = var_0_0.scenegraph[var_26_33.scenegraph_id]

		arg_26_0.tutorial_state = arg_26_0.tutorial_state or "invisible"

		local var_26_35 = arg_26_0:_get_next_verified(var_26_31, arg_26_2)

		if arg_26_0.tutorial_state == "invisible" and arg_26_0.side_mission_state == "invisible" then
			if var_26_35 then
				for iter_26_4 = 2, 2 do
					if not arg_26_0.info_slate_slots_taken[iter_26_4] then
						arg_26_0.info_slate_slots_taken[iter_26_4] = true

						local var_26_36 = var_26_31[var_26_35]

						var_26_36.slot = iter_26_4

						local var_26_37 = var_26_36.text

						arg_26_0.tutorial_entry = var_26_36
						var_26_33.content.description_text = var_26_37
						arg_26_0.tutorial_anim_id = var_26_1:start_animation("info_slate_enter", var_26_33, var_26_34, var_0_9[iter_26_4 == 1 and "slot_1" or "slot_2"])

						local var_26_38 = var_0_0.INFO_SLATE_ENTRY_SIZE
						local var_26_39 = var_26_32.text_scenegraph_id
						local var_26_40 = var_26_32.icon_scenegraph_id
						local var_26_41 = var_26_33.style.description_text
						local var_26_42, var_26_43 = arg_26_0:info_slate_text_height(var_26_37, var_26_41)
						local var_26_44 = math.max(var_26_38[2], var_26_42)

						var_26_0[var_26_39].size[2] = var_26_44

						local var_26_45 = var_26_0[var_26_33.scenegraph_id].size[2]

						var_26_0[var_26_33.scenegraph_id].size[2] = var_26_44
						var_26_0[var_26_33.scenegraph_id].position[2] = var_26_0[var_26_33.scenegraph_id].position[2] - var_26_44 + var_26_38[2]
						var_26_0[var_26_32.icon_root_scenegraph_id].vertical_alignment = var_26_43 > 1 and "top" or "center"
						var_26_0[var_26_32.icon_root_scenegraph_id].position[2] = var_26_43 > 1 and -10 or 0
						arg_26_0.tutorial_state = "animating_in"

						break
					end
				end
			end
		elseif arg_26_0.tutorial_state == "animating_in" then
			if var_26_1:is_animation_completed(arg_26_0.tutorial_anim_id) then
				arg_26_0.tutorial_anim_id = var_26_1:start_animation("mission_goal_wait", var_26_33, var_26_34)
				arg_26_0.tutorial_visible_timer = 0
				arg_26_0.tutorial_state = "visible"
			end
		elseif arg_26_0.tutorial_state == "visible" then
			arg_26_0.tutorial_visible_timer = arg_26_0.tutorial_visible_timer + arg_26_1

			if arg_26_0.tutorial_visible_timer > 10 then
				local var_26_46 = arg_26_0.tutorial_entry.slot
				local var_26_47 = var_26_46 == 1 and "slot_1" or var_26_46 == 2 and "slot_2" or "slot_3"

				arg_26_0.tutorial_anim_id = var_26_1:start_animation("info_slate_exit", var_26_33, var_26_34, var_0_9[var_26_47])
				arg_26_0.tutorial_state = "animating_out"
			elseif arg_26_0.tutorial_entry.updated then
				arg_26_0.tutorial_entry.updated = nil
				arg_26_0.tutorial_anim_id = var_26_1:start_animation("info_slate_flash", var_26_33, var_26_34)
				arg_26_0.tutorial_state = "flashing"
				var_26_33.content.description_text = arg_26_0.tutorial_entry.text
			elseif arg_26_0.side_mission_state == "waiting_for_tutorial" then
				arg_26_0.tutorial_anim_id = var_26_1:start_animation("info_slate_exit", var_26_33, var_26_34)
				arg_26_0.tutorial_state = "animating_out"
			end
		elseif arg_26_0.tutorial_state == "moving" then
			if var_26_1:is_animation_completed(arg_26_0.tutorial_anim_id) then
				arg_26_0.info_slate_slots_taken[3 - arg_26_0.tutorial_entry.slot] = false
				arg_26_0.tutorial_state = "visible"
			end
		elseif arg_26_0.tutorial_state == "flashing" then
			if var_26_1:is_animation_completed(arg_26_0.tutorial_anim_id) then
				arg_26_0.tutorial_state = "visible"
			end
		elseif arg_26_0.tutorial_state == "animating_out" and var_26_1:is_animation_completed(arg_26_0.tutorial_anim_id) then
			UIRenderer.set_element_visible(arg_26_0.ui_renderer, var_26_33.element, false)

			arg_26_0.info_slate_slots_taken[arg_26_0.tutorial_entry.slot] = false
			var_26_31[arg_26_0.tutorial_entry.entry_id] = nil
			arg_26_0.tutorial_state = "invisible"
		end
	end
end

function TutorialUI._get_next_verified(arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = Managers.state.entity:system("tutorial_system")

	while true do
		local var_27_1, var_27_2 = next(arg_27_1)

		if not var_27_1 then
			return
		end

		local var_27_3 = var_27_2.unit
		local var_27_4 = var_27_2.template
		local var_27_5 = var_27_2.raycast_unit

		if not Unit.alive(var_27_3) or not var_27_4 then
			return var_27_1
		end

		if var_27_0:verify_info_slate(arg_27_2, var_27_3, var_27_5, var_27_4) then
			return var_27_1
		else
			print("Verification failed: " .. var_27_2.text)

			arg_27_1[var_27_1] = nil

			if arg_27_0.tutorial_state ~= "invisible" then
				local var_27_6 = arg_27_0.tutorial_entry.slot
				local var_27_7 = arg_27_0.info_slate_entries[var_0_1.tutorial].widget
				local var_27_8 = var_0_0.scenegraph[var_27_7.scenegraph_id]
				local var_27_9 = var_27_6 == 1 and "slot_1" or var_27_6 == 2 and "slot_2" or "slot_3"

				arg_27_0.ui_animator:stop_animation(arg_27_0.tutorial_anim_id)

				arg_27_0.tutorial_anim_id = arg_27_0.ui_animator:start_animation("info_slate_exit", var_27_7, var_27_8, var_0_9[var_27_9])
				arg_27_0.tutorial_state = "animating_out"
			end
		end
	end
end

function TutorialUI.info_slate_text_height(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = table.clone(var_0_0.INFO_SLATE_ENTRY_SIZE)

	var_28_0[1] = var_28_0[1] - 62

	local var_28_1 = arg_28_0.ui_renderer
	local var_28_2, var_28_3 = UIFontByResolution(arg_28_2)
	local var_28_4, var_28_5, var_28_6 = unpack(var_28_2)
	local var_28_7, var_28_8, var_28_9 = UIGetFontHeight(arg_28_0.ui_renderer.gui, var_28_6, var_28_3)
	local var_28_10 = var_28_9 - var_28_8
	local var_28_11 = UIRenderer.word_wrap(var_28_1, arg_28_1, var_28_2[1], var_28_3, var_28_0[1])
	local var_28_12 = 20
	local var_28_13 = #var_28_11

	return var_28_10 * RESOLUTION_LOOKUP.inv_scale * var_28_13 + var_28_12, var_28_13
end

function TutorialUI.play_sound(arg_29_0, arg_29_1)
	WwiseWorld.trigger_event(arg_29_0.wwise_world, arg_29_1)
end

function TutorialUI.add_health_bar(arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = false

	for iter_30_0 = 1, var_0_0.NUMBER_OF_HEALTH_BARS do
		local var_30_1 = arg_30_0.health_bars[iter_30_0]

		if arg_30_2 and var_30_1 and not var_30_1.visible then
			arg_30_0:remove_health_bar(arg_30_1)

			var_30_1 = nil
		end

		if not var_30_1 then
			local var_30_2 = Unit.has_data(arg_30_1, "health_bar_color") and Unit.get_data(arg_30_1, "health_bar_color") or "red"
			local var_30_3 = var_0_0.health_bar_definitions[iter_30_0]
			local var_30_4 = UIWidget.init(var_30_3)

			var_30_4.style.texture_fg.color = Colors.get_table(var_30_2)
			arg_30_0.health_bars[iter_30_0] = {
				health_percent = 1,
				init_position = true,
				visible_time = 0,
				damage_time = 0,
				visible = true,
				active = false,
				unit = arg_30_1,
				health_extension = ScriptUnit.extension(arg_30_1, "health_system"),
				widget = var_30_4,
				scenegraph_definition = arg_30_0.floating_icons_ui_scene_graph[var_30_3.scenegraph_id]
			}
			var_30_0 = iter_30_0

			break
		end
	end

	if not var_30_0 then
		if arg_30_2 then
			Application.warning("[TutorialUI] ERROR: Tried to exceed the limit of %s visible health bars.", var_0_0.NUMBER_OF_HEALTH_BARS)
		else
			arg_30_0:add_health_bar(arg_30_1, true)
		end
	end
end

function TutorialUI.remove_health_bar(arg_31_0, arg_31_1)
	for iter_31_0 = 1, var_0_0.NUMBER_OF_HEALTH_BARS do
		local var_31_0 = arg_31_0.health_bars[iter_31_0]

		if var_31_0 and var_31_0.unit == arg_31_1 then
			arg_31_0.health_bars[iter_31_0] = nil

			break
		end
	end
end

function TutorialUI._get_health_bar_by_unit(arg_32_0, arg_32_1)
	for iter_32_0 = 1, var_0_0.NUMBER_OF_HEALTH_BARS do
		local var_32_0 = arg_32_0.health_bars[iter_32_0]

		if var_32_0 and var_32_0.unit == arg_32_1 then
			return var_32_0
		end
	end
end

function TutorialUI.show_health_bar(arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = arg_33_0:_get_health_bar_by_unit(arg_33_1)

	if var_33_0 then
		var_33_0.visible = arg_33_2
	elseif arg_33_2 then
		arg_33_0:add_health_bar(arg_33_1)

		local var_33_1 = arg_33_0:_get_health_bar_by_unit(arg_33_1)

		if var_33_1 then
			var_33_1.visible = arg_33_2
		end
	end
end

function TutorialUI.update_health_bars(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = arg_34_0:_get_player_first_person_extension()
	local var_34_1 = var_34_0:current_position()
	local var_34_2 = var_34_0:current_rotation()
	local var_34_3 = Quaternion.forward(var_34_2)
	local var_34_4 = "player_1"
	local var_34_5

	if arg_34_0.camera_manager:has_viewport(var_34_4) then
		local var_34_6 = "level_world"
		local var_34_7 = arg_34_0.world_manager

		if var_34_7:has_world(var_34_6) then
			local var_34_8 = var_34_7:world(var_34_6)
			local var_34_9 = ScriptWorld.viewport(var_34_8, var_34_4)

			var_34_5 = ScriptViewport.camera(var_34_9)
		end
	end

	local var_34_10 = arg_34_0.health_bars
	local var_34_11 = RESOLUTION_LOOKUP.inv_scale
	local var_34_12 = Unit

	for iter_34_0 = 1, var_0_0.NUMBER_OF_HEALTH_BARS do
		local var_34_13 = var_34_10[iter_34_0]
		local var_34_14 = var_34_13 and var_34_13.unit

		if var_34_14 and var_34_12.alive(var_34_14) then
			local var_34_15 = var_34_12.get_data(var_34_14, "health_bar_node")
			local var_34_16 = var_34_15 and var_34_12.node(var_34_14, var_34_15) or 0
			local var_34_17 = var_34_12.world_position(var_34_14, var_34_16)
			local var_34_18 = Vector3.normalize(var_34_17 - var_34_1)
			local var_34_19 = Vector3.dot(var_34_3, var_34_18)
			local var_34_20 = var_34_13.health_extension:current_health_percent()
			local var_34_21 = var_34_13.health_percent
			local var_34_22, var_34_23 = var_34_13.health_extension:recent_damages()

			if var_34_23 > 0 then
				var_34_13.visible_time = 1
				var_34_13.damage_time = 0.5
			end

			var_34_13.visible_time = var_34_13.visible_time - arg_34_1
			var_34_13.damage_time = var_34_13.damage_time - arg_34_1

			if var_34_19 > 0 then
				local var_34_24 = var_34_21

				if var_34_13.visible_time > 0 and var_34_13.damage_time < 0 and var_34_20 < var_34_21 then
					var_34_13.health_percent = math.max(var_34_20, var_34_21 - arg_34_1)
				end

				var_34_13.health_percent = var_34_20

				local var_34_25, var_34_26 = arg_34_0:convert_world_to_screen_position(var_34_5, var_34_17)
				local var_34_27 = var_34_13.scenegraph_definition
				local var_34_28 = var_34_27.local_position

				var_34_28[1] = var_34_25 * var_34_11
				var_34_28[2] = var_34_26 * var_34_11

				local var_34_29 = var_34_27.size

				var_34_13.widget.style.texture_fg.size[1] = var_34_29[1] * var_34_20
				var_34_13.widget.content.visible = true
			else
				var_34_13.widget.content.visible = false
			end

			if var_34_13.widget.content.visible ~= var_34_13.visible then
				var_34_13.widget.content.visible = var_34_13.visible
			end
		elseif var_34_13 then
			var_34_13.widget.content.visible = false
		end
	end
end

function TutorialUI.set_visible(arg_35_0, arg_35_1)
	arg_35_0._visible = arg_35_1

	arg_35_0.tutorial_tooltip_ui:set_visible(arg_35_1)
end
