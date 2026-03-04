-- chunkname: @scripts/ui/views/level_end/states/end_view_state_chest.lua

local var_0_0 = local_require("scripts/ui/views/level_end/states/definitions/end_view_state_chest_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.score_entry_widgets
local var_0_3 = var_0_0.scenegraph_definition
local var_0_4 = var_0_0.animation_definitions
local var_0_5 = var_0_0.create_bar_divider
local var_0_6 = false
local var_0_7 = 2
local var_0_8 = 0.8
local var_0_9 = 1
local var_0_10 = 2
local var_0_11 = 1
local var_0_12 = {
	"loot_chest_jump",
	"loot_chest_jump_02"
}

EndViewStateChest = class(EndViewStateChest)
EndViewStateChest.NAME = "EndViewStateChest"
EndViewStateChest.CAN_SPEED_UP = true

EndViewStateChest.on_enter = function (arg_1_0, arg_1_1)
	print("[PlayState] Enter Substate EndViewStateChest")

	arg_1_0.parent = arg_1_1.parent
	arg_1_0.game_won = arg_1_1.game_won
	arg_1_0.game_mode_key = arg_1_1.game_mode_key
	arg_1_0.hero_name = arg_1_1.hero_name

	local var_1_0 = arg_1_1.context

	arg_1_0._context = var_1_0
	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.rewards = var_1_0.rewards
	arg_1_0.render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = true
	}
	arg_1_0._score_presentation_queue = {}
	arg_1_0._total_score = 0
	arg_1_0.wwise_world = var_1_0.wwise_world
	arg_1_0.world_previewer = arg_1_1.world_previewer
	arg_1_0.platform = PLATFORM
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}
	arg_1_0._units = {}

	arg_1_0:create_ui_elements(arg_1_1)
	arg_1_0:_set_presentation_progress(0, true)

	if arg_1_1.initial_state then
		arg_1_0._initial_preview = true
		arg_1_1.initial_state = nil
	end

	arg_1_0:_start_transition_animation("on_enter", "transition_enter")

	arg_1_0._exit_timer = nil
	arg_1_0.chest_settings = {
		{
			text = "Chest Tier 1",
			score_requirement = LootChestData.score_thresholds_per_chest[1],
			total_score = LootChestData.score_thresholds[1]
		},
		{
			text = "Chest Tier 2",
			score_requirement = LootChestData.score_thresholds_per_chest[2],
			total_score = LootChestData.score_thresholds[2]
		},
		{
			text = "Chest Tier 3",
			score_requirement = LootChestData.score_thresholds_per_chest[3],
			total_score = LootChestData.score_thresholds[3]
		},
		{
			text = "Chest Tier 4",
			score_requirement = LootChestData.score_thresholds_per_chest[4],
			total_score = LootChestData.score_thresholds[4]
		},
		{
			text = "Chest Tier 5",
			score_requirement = LootChestData.score_thresholds_per_chest[5],
			total_score = LootChestData.score_thresholds[5]
		},
		{
			text = "Chest Tier 6",
			score_requirement = LootChestData.score_thresholds_per_chest[6],
			total_score = LootChestData.score_thresholds[6]
		}
	}

	local var_1_1 = var_1_0.difficulty
	local var_1_2 = LootChestData.chests_by_category[var_1_1]
	local var_1_3 = var_1_2.chest_unit_names
	local var_1_4 = var_1_2.display_names

	for iter_1_0, iter_1_1 in ipairs(arg_1_0.chest_settings) do
		iter_1_1.unit_name = var_1_3[iter_1_0]
		iter_1_1.display_name = var_1_4[iter_1_0]
	end

	arg_1_0:_play_sound("play_gui_mission_summary_chest_uppgrade_amb_begin")
end

EndViewStateChest.exit = function (arg_2_0, arg_2_1)
	arg_2_0._exit_started = true

	arg_2_0:_start_transition_animation("on_enter", "transition_exit")
	arg_2_0:_play_sound("play_gui_mission_summary_chest_uppgrade_amb_end")
end

EndViewStateChest.exit_done = function (arg_3_0)
	return arg_3_0._exit_started and arg_3_0._animations.on_enter == nil
end

EndViewStateChest.create_ui_elements = function (arg_4_0, arg_4_1)
	var_0_6 = false
	arg_4_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_3)

	local var_4_0 = {}
	local var_4_1 = {}

	for iter_4_0, iter_4_1 in pairs(var_0_1) do
		local var_4_2 = UIWidget.init(iter_4_1)

		var_4_0[#var_4_0 + 1] = var_4_2
		var_4_1[iter_4_0] = var_4_2
	end

	arg_4_0._widgets = var_4_0
	arg_4_0._widgets_by_name = var_4_1

	local var_4_3 = {}

	for iter_4_2, iter_4_3 in ipairs(var_0_2) do
		local var_4_4 = UIWidget.init(iter_4_3)

		var_4_3[#var_4_3 + 1] = var_4_4
	end

	arg_4_0._score_widgets = var_4_3
	arg_4_0._divider_widgets = {}

	UIRenderer.clear_scenegraph_queue(arg_4_0.ui_renderer)

	arg_4_0.ui_animator = UIAnimator:new(arg_4_0.ui_scenegraph, var_0_4)

	local var_4_5 = var_4_1.score_entry_bg_left
	local var_4_6 = var_4_1.score_entry_bg_right
	local var_4_7 = var_4_1.score_entry_texture
	local var_4_8 = var_4_5.style.texture_id
	local var_4_9 = var_4_6.style.texture_id
	local var_4_10 = var_4_7.style.texture_id

	var_4_8.color[1] = 0
	var_4_9.color[1] = 0
	var_4_10.color[1] = 0

	arg_4_0:_initialize_score_topics()
end

EndViewStateChest._initialize_score_topics = function (arg_5_0)
	local var_5_0 = arg_5_0._score_widgets
	local var_5_1 = UISettings.chest_upgrade_score_topics[arg_5_0.game_mode_key] or UISettings.chest_upgrade_score_topics.default

	arg_5_0._num_score_topics = #var_5_1
	arg_5_0._score_topics = {}

	local var_5_2 = -10

	for iter_5_0, iter_5_1 in ipairs(var_5_1) do
		local var_5_3 = var_5_0[iter_5_0]
		local var_5_4 = iter_5_1.name
		local var_5_5 = iter_5_1.texture
		local var_5_6 = iter_5_1.display_name

		var_5_3.content.text = Localize(var_5_6)
		var_5_3.content.texture_id = var_5_5
		var_5_3.content.texture_id_glow = var_5_5 .. "_glow"
		var_5_3.content.name = var_5_4

		local var_5_7 = var_5_3.scenegraph_id
		local var_5_8 = var_0_3[var_5_7].size[2]

		var_5_3.offset[2] = -(var_5_8 + var_5_2) * (iter_5_0 - 1)
		arg_5_0._score_topics[#arg_5_0._score_topics + 1] = var_5_4
	end
end

EndViewStateChest._wanted_state = function (arg_6_0)
	return (arg_6_0.parent:wanted_menu_state())
end

EndViewStateChest.set_input_manager = function (arg_7_0, arg_7_1)
	arg_7_0.input_manager = arg_7_1
end

EndViewStateChest.on_exit = function (arg_8_0, arg_8_1)
	print("[PlayState] Exit Substate EndViewStateChest")

	arg_8_0.ui_animator = nil
end

EndViewStateChest._update_transition_timer = function (arg_9_0, arg_9_1)
	if not arg_9_0._transition_timer then
		return
	end

	if arg_9_0._transition_timer == 0 then
		arg_9_0._transition_timer = nil
	else
		arg_9_0._transition_timer = math.max(arg_9_0._transition_timer - arg_9_1, 0)
	end

	local var_9_0 = arg_9_0._units
	local var_9_1 = arg_9_0:_get_viewport_world()

	for iter_9_0, iter_9_1 in pairs(var_9_0) do
		World.destroy_unit(var_9_1, iter_9_1)
	end

	table.clear(var_9_0)
end

EndViewStateChest.update = function (arg_10_0, arg_10_1, arg_10_2)
	if var_0_6 then
		var_0_6 = false

		local var_10_0 = arg_10_0._units
		local var_10_1 = arg_10_0:_get_viewport_world()

		if var_10_1 then
			for iter_10_0, iter_10_1 in pairs(var_10_0) do
				World.destroy_unit(var_10_1, iter_10_1)
			end

			table.clear(var_10_0)
		end

		arg_10_0._current_chest_unit_name = nil
		arg_10_0._spawned_chest_index = nil
		arg_10_0._current_chest_enter_time = nil
		arg_10_0._presentation_started = false
		arg_10_0._entry_duration = 0
		arg_10_0._current_entry_display_index = nil
		arg_10_0._total_score = 0
		arg_10_0._animations = {}
		arg_10_0._ui_animations = {}
		arg_10_0._score_entries = {}

		arg_10_0:create_ui_elements()

		arg_10_0.ui_animator = UIAnimator:new(arg_10_0.ui_scenegraph, var_0_4)
		arg_10_0.chest_settings = {
			{
				text = "Chest Tier 1",
				score_requirement = LootChestData.score_thresholds_per_chest[1],
				total_score = LootChestData.score_thresholds[1]
			},
			{
				text = "Chest Tier 2",
				score_requirement = LootChestData.score_thresholds_per_chest[2],
				total_score = LootChestData.score_thresholds[2]
			},
			{
				text = "Chest Tier 3",
				score_requirement = LootChestData.score_thresholds_per_chest[3],
				total_score = LootChestData.score_thresholds[3]
			},
			{
				text = "Chest Tier 4",
				score_requirement = LootChestData.score_thresholds_per_chest[4],
				total_score = LootChestData.score_thresholds[4]
			},
			{
				text = "Chest Tier 5",
				score_requirement = LootChestData.score_thresholds_per_chest[5],
				total_score = LootChestData.score_thresholds[5]
			},
			{
				text = "Chest Tier 6",
				score_requirement = LootChestData.score_thresholds_per_chest[6],
				total_score = LootChestData.score_thresholds[6]
			}
		}

		local var_10_2 = arg_10_0._context.difficulty
		local var_10_3 = LootChestData.chests_by_category[var_10_2]
		local var_10_4 = var_10_3.chest_unit_names
		local var_10_5 = var_10_3.display_names

		for iter_10_2, iter_10_3 in ipairs(arg_10_0.chest_settings) do
			iter_10_3.unit_name = var_10_4[iter_10_2]
			iter_10_3.display_name = var_10_5[iter_10_2]
		end
	end

	if not arg_10_0._presentation_started then
		arg_10_0:_start_presentation(arg_10_2)

		arg_10_0._presentation_started = true
	end

	arg_10_0:_animate_score_entries(arg_10_1, arg_10_2)

	local var_10_6 = arg_10_0.input_manager:get_service("end_of_level")

	if arg_10_0._exit_started then
		local var_10_7 = arg_10_0._units
		local var_10_8 = arg_10_0:_get_viewport_world()

		for iter_10_4, iter_10_5 in pairs(var_10_7) do
			World.destroy_unit(var_10_8, iter_10_5)
		end

		table.clear(var_10_7)
	end

	arg_10_0:draw(var_10_6, arg_10_1)
	arg_10_0:_update_transition_timer(arg_10_1)

	local var_10_9 = arg_10_0:_wanted_state()

	if not arg_10_0._transition_timer and (var_10_9 or arg_10_0._new_state) then
		arg_10_0.parent:clear_wanted_menu_state()

		return var_10_9 or arg_10_0._new_state
	end

	arg_10_0:_update_chest_zoom_wait_time(arg_10_1, arg_10_2)
	arg_10_0:_update_chest_zoom_time(arg_10_1, arg_10_2)
	arg_10_0:_update_chest_bonus_time(arg_10_1, arg_10_2)
	arg_10_0:_update_chest_exit_time(arg_10_1, arg_10_2)

	if arg_10_0._ready_to_exit and not arg_10_0._exit_timer and not arg_10_0.parent:displaying_reward_presentation() then
		arg_10_0._exit_timer = 1.5
	end

	arg_10_0:_update_current_chest_enter(arg_10_1, arg_10_2)
	arg_10_0.ui_animator:update(arg_10_1)
	arg_10_0:_update_animations(arg_10_1)
	arg_10_0:_animate_score_progress(arg_10_1, arg_10_2)

	if arg_10_0._exit_timer then
		arg_10_0._exit_timer = math.max(arg_10_0._exit_timer - arg_10_1, 0)

		if arg_10_0._exit_timer == 0 then
			arg_10_0._score_entry_presentation_done = true
		end
	end

	if not arg_10_0.parent:transitioning() and not arg_10_0._transition_timer then
		arg_10_0:_handle_input(arg_10_1, arg_10_2)
	end
end

EndViewStateChest.post_update = function (arg_11_0, arg_11_1, arg_11_2)
	return
end

EndViewStateChest._update_animations = function (arg_12_0, arg_12_1)
	for iter_12_0, iter_12_1 in pairs(arg_12_0._ui_animations) do
		UIAnimation.update(iter_12_1, arg_12_1)

		if UIAnimation.completed(iter_12_1) then
			arg_12_0._ui_animations[iter_12_0] = nil
		end
	end

	local var_12_0 = arg_12_0._animations
	local var_12_1 = arg_12_0.ui_animator

	for iter_12_2, iter_12_3 in pairs(var_12_0) do
		if var_12_1:is_animation_completed(iter_12_3) then
			var_12_1:stop_animation(iter_12_3)

			var_12_0[iter_12_2] = nil
		end
	end

	if arg_12_0.score_presentation_anim_id and var_12_1:is_animation_completed(arg_12_0.score_presentation_anim_id) then
		var_12_1:stop_animation(arg_12_0.score_presentation_anim_id)

		arg_12_0.score_presentation_anim_id = nil
	end
end

EndViewStateChest._handle_input = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0._widgets_by_name
end

EndViewStateChest.draw = function (arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0.ui_renderer
	local var_14_1 = arg_14_0.ui_top_renderer
	local var_14_2 = arg_14_0.ui_scenegraph
	local var_14_3 = arg_14_0.render_settings

	UIRenderer.begin_pass(var_14_0, var_14_2, arg_14_1, arg_14_2, nil, var_14_3)

	local var_14_4 = var_14_3.alpha_multiplier

	for iter_14_0, iter_14_1 in ipairs(arg_14_0._widgets) do
		if iter_14_1.alpha_multiplier then
			var_14_3.alpha_multiplier = iter_14_1.alpha_multiplier
		end

		UIRenderer.draw_widget(var_14_0, iter_14_1)

		var_14_3.alpha_multiplier = var_14_4
	end

	local var_14_5 = arg_14_0._divider_widgets

	if var_14_5 then
		for iter_14_2, iter_14_3 in ipairs(var_14_5) do
			UIRenderer.draw_widget(var_14_0, iter_14_3)
		end
	end

	local var_14_6 = arg_14_0._num_score_topics
	local var_14_7 = arg_14_0._score_widgets

	if var_14_6 and var_14_7 then
		for iter_14_4 = 1, var_14_6 do
			local var_14_8 = var_14_7[iter_14_4]

			UIRenderer.draw_widget(var_14_0, var_14_8)
		end
	end

	UIRenderer.end_pass(var_14_0)
end

EndViewStateChest._start_transition_animation = function (arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = {
		wwise_world = arg_15_0.wwise_world,
		render_settings = arg_15_0.render_settings
	}
	local var_15_1 = {}
	local var_15_2 = arg_15_0.ui_animator:start_animation(arg_15_2, var_15_1, var_0_3, var_15_0)

	arg_15_0._animations[arg_15_1] = var_15_2
end

EndViewStateChest._animate_element_by_time = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	return (UIAnimation.init(UIAnimation.function_by_time, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, math.ease_out_quad))
end

EndViewStateChest._animate_element_by_catmullrom = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8)
	return (UIAnimation.init(UIAnimation.catmullrom, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8))
end

EndViewStateChest.done = function (arg_18_0)
	return arg_18_0._score_entry_presentation_done
end

EndViewStateChest._set_entry_text_progress = function (arg_19_0, arg_19_1)
	local var_19_0 = 1 - arg_19_1
	local var_19_1 = (-4 * (arg_19_1 - 0.5) * (arg_19_1 - 0.5) + 1) * 0.5
	local var_19_2 = var_0_3.score_entry_texture

	arg_19_0.ui_scenegraph.score_entry_texture.local_position[1] = var_19_2.position[1] + 200 * arg_19_1

	local var_19_3 = var_19_1 * 255
	local var_19_4 = arg_19_0._widgets_by_name
	local var_19_5 = var_19_4.score_entry_texture

	var_19_4.score_entry_text.style.text.text_color[1] = var_19_3
	var_19_5.style.texture_id.color[1] = var_19_3
end

EndViewStateChest._display_chest_by_settings_index = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0 = arg_20_0.chest_settings[arg_20_1]
	local var_20_1 = var_20_0.unit_name
	local var_20_2 = var_20_0.display_name
	local var_20_3 = arg_20_0:_spawn_chest_unit(var_20_1, arg_20_3, arg_20_2)

	arg_20_0._units[var_20_1] = var_20_3

	local var_20_4 = arg_20_0._widgets_by_name

	var_20_4.chest_title.content.text = Localize(var_20_2)
	var_20_4.chest_sub_title.content.text = Localize("loot_chest")

	local var_20_5 = "chest_title_update"

	if arg_20_3 then
		var_20_5 = "chest_title_initialize"

		local var_20_6 = arg_20_0._context.difficulty
		local var_20_7 = "play_gui_chest_appear_" .. var_20_6 .. "_" .. tostring(arg_20_1)

		arg_20_0:_play_sound(var_20_7)
	else
		arg_20_0:_play_sound("play_gui_mission_summary_chest_upgrade")
	end

	arg_20_0.ui_animator:start_animation(var_20_5, arg_20_0._widgets_by_name, var_0_3, {
		wwise_world = arg_20_0.wwise_world
	})
end

EndViewStateChest._spawn_chest_unit = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	if arg_21_0._current_chest_unit_name then
		arg_21_0._current_chest_enter_time = arg_21_3 + 0.5

		local var_21_0 = arg_21_0._units[arg_21_0._current_chest_unit_name]

		Unit.flow_event(var_21_0, "loot_chest_upgrade_out")
	end

	local var_21_1 = arg_21_0:_get_viewport_world()
	local var_21_2 = World.spawn_unit(var_21_1, arg_21_1)

	Unit.set_unit_visibility(var_21_2, arg_21_2 == true)

	local var_21_3 = arg_21_0.parent:get_world_link_unit()

	World.link_unit(var_21_1, var_21_2, 0, var_21_3, 0)

	if arg_21_2 then
		local var_21_4 = "loot_chest_enter"

		Unit.flow_event(var_21_2, var_21_4)
		arg_21_0.parent:set_camera_zoom(0)
		arg_21_0:_set_bar_alpha_by_progress(1)
	else
		arg_21_0.parent:add_camera_shake(nil, arg_21_3, nil)
	end

	arg_21_0._current_chest_unit_name = arg_21_1

	return var_21_2
end

EndViewStateChest._update_current_chest_enter = function (arg_22_0, arg_22_1, arg_22_2)
	if not arg_22_0._current_chest_enter_time then
		return
	end

	if arg_22_2 >= arg_22_0._current_chest_enter_time then
		arg_22_0._current_chest_enter_time = nil

		if arg_22_0._current_chest_unit_name then
			local var_22_0 = arg_22_0._units[arg_22_0._current_chest_unit_name]

			Unit.set_unit_visibility(var_22_0, true)
			Unit.flow_event(var_22_0, "loot_chest_upgrade_in")
		end
	end
end

EndViewStateChest._trigger_unit_flow_event = function (arg_23_0, arg_23_1, arg_23_2)
	if arg_23_1 and Unit.alive(arg_23_1) then
		Unit.flow_event(arg_23_1, arg_23_2)
	end
end

EndViewStateChest._get_viewport_world = function (arg_24_0)
	return arg_24_0.parent:get_viewport_world()
end

EndViewStateChest._start_presentation = function (arg_25_0, arg_25_1)
	local var_25_0 = true
	local var_25_1 = 1

	arg_25_0._spawned_chest_index = var_25_1

	arg_25_0:_display_chest_by_settings_index(var_25_1, arg_25_1, var_25_0)

	local var_25_2 = 0
	local var_25_3 = arg_25_0._context.rewards.end_of_level_rewards.chest.score_breakdown

	for iter_25_0, iter_25_1 in ipairs(arg_25_0._score_topics) do
		local var_25_4 = var_25_3[iter_25_1]

		if var_25_4 and var_25_4.score > 0 then
			local var_25_5 = var_25_4.score
			local var_25_6 = var_25_4.amount

			arg_25_0:_add_score({
				id = var_25_2,
				score = var_25_5,
				name = iter_25_1,
				amount = var_25_6
			})

			var_25_2 = var_25_2 + 1
		end
	end

	if var_25_2 == 0 then
		arg_25_0._chest_zoom_wait_duration = var_0_7
	end
end

EndViewStateChest._add_score = function (arg_26_0, arg_26_1)
	if arg_26_1.score == 0 then
		return
	end

	local var_26_0 = arg_26_0._score_widgets

	arg_26_0._score_entries = arg_26_0._score_entries or {}

	local var_26_1

	for iter_26_0, iter_26_1 in ipairs(var_26_0) do
		if iter_26_1.content.name == arg_26_1.name then
			var_26_1 = iter_26_1

			break
		end
	end

	local var_26_2 = #arg_26_0._score_entries + 1
	local var_26_3 = {
		entry_animation_completed = false,
		entry_index = var_26_2,
		data = arg_26_1,
		widget = var_26_1,
		wwise_world = arg_26_0.wwise_world
	}

	arg_26_0._score_entries[var_26_2] = var_26_3

	local var_26_4 = arg_26_1.amount

	if var_26_4 then
		var_26_1.content.text = var_26_1.content.text .. "\n x" .. tostring(var_26_4)
	end
end

EndViewStateChest._animate_score_entries = function (arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0._score_entries

	if not var_27_0 or var_27_0.complete then
		return
	end

	local var_27_1 = arg_27_0.ui_animator
	local var_27_2 = "score_entry_add"
	local var_27_3 = "summary_entry_text_shadow"
	local var_27_4 = true

	for iter_27_0, iter_27_1 in ipairs(var_27_0) do
		if not iter_27_1.entry_animation_completed then
			if not arg_27_0.score_entry_enter_anim_id then
				arg_27_0.score_entry_enter_anim_id = arg_27_0.ui_animator:start_animation(var_27_2, arg_27_0._widgets_by_name, var_0_3, iter_27_1)
			elseif var_27_1:is_animation_completed(arg_27_0.score_entry_enter_anim_id) then
				var_27_1:stop_animation(arg_27_0.score_entry_enter_anim_id)

				arg_27_0.score_entry_enter_anim_id = nil
				iter_27_1.entry_animation_completed = true
			end

			var_27_4 = false
		end
	end

	var_27_0.complete = var_27_4

	if var_27_4 and arg_27_0._score_widgets then
		arg_27_0:_display_next_score_entry()
	end
end

EndViewStateChest._display_next_score_entry = function (arg_28_0)
	local var_28_0 = arg_28_0._score_entries

	arg_28_0._current_entry_display_index = (arg_28_0._current_entry_display_index or 0) + 1

	local var_28_1 = var_28_0[arg_28_0._current_entry_display_index]

	arg_28_0.score_presentation_anim_id = arg_28_0.ui_animator:start_animation("score_presentation_start", arg_28_0._widgets_by_name, var_0_3, var_28_1)
	arg_28_0._current_entry_data = var_28_1.data
	arg_28_0._entry_duration = 0
end

EndViewStateChest._start_entry_animation = function (arg_29_0, arg_29_1)
	local var_29_0 = {
		wwise_world = arg_29_0.wwise_world,
		render_settings = arg_29_0.render_settings
	}
	local var_29_1 = arg_29_0._widgets_by_name
	local var_29_2 = arg_29_0.ui_animator:start_animation("score_entry", var_29_1, var_0_3, var_29_0)

	arg_29_0._animations[arg_29_1] = var_29_2
end

EndViewStateChest._animate_score_progress = function (arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_0._entry_duration
	local var_30_1 = arg_30_0._current_chest_enter_time

	if not var_30_0 or var_30_1 or arg_30_0.score_entry_enter_anim_id or arg_30_0.score_presentation_anim_id then
		return
	end

	local var_30_2 = #arg_30_0.chest_settings
	local var_30_3 = arg_30_0._score_entries
	local var_30_4 = arg_30_0._current_entry_display_index
	local var_30_5 = var_30_3[var_30_4]
	local var_30_6 = var_30_5.data
	local var_30_7 = LootChestData.max_score
	local var_30_8 = arg_30_0._total_score or 0
	local var_30_9 = var_30_7 - var_30_8
	local var_30_10 = var_30_6.score
	local var_30_11 = math.clamp(var_30_6.score, 0, var_30_7 - var_30_8)
	local var_30_12 = UISettings.chest_upgrade_score_topics_min_duration or 0.5
	local var_30_13 = UISettings.chest_upgrade_score_topics_max_duration or 7
	local var_30_14 = var_30_9 > 0 and math.min(var_30_11 / var_30_9, 1) or 0
	local var_30_15 = math.clamp(var_30_14 * var_30_13, var_30_12, var_30_13)
	local var_30_16 = math.min(var_30_0 + arg_30_1, var_30_15)
	local var_30_17 = var_30_16 / var_30_15
	local var_30_18 = 0.5 * (LootChestData.score_per_chest / var_30_10)
	local var_30_19 = math.easeOutCubic(var_30_17)
	local var_30_20 = var_30_11 * var_30_19
	local var_30_21 = math.min(var_30_8 + var_30_20, var_30_7)
	local var_30_22 = var_30_21 == var_30_7

	if var_30_22 then
		var_30_19 = 1
	end

	local var_30_23, var_30_24 = arg_30_0:_get_chest_settings_by_total_score(var_30_21)
	local var_30_25 = 0

	if var_30_22 and var_30_2 > arg_30_0._spawned_chest_index or var_30_24 and var_30_24 - 1 ~= arg_30_0._spawned_chest_index then
		var_30_25 = 1

		local var_30_26 = var_30_22 and var_30_2 or var_30_24 - 1

		arg_30_0._spawned_chest_index = var_30_26

		arg_30_0:_display_chest_by_settings_index(var_30_26, arg_30_2)
	elseif var_30_23 then
		local var_30_27 = var_30_23.total_score
		local var_30_28 = var_30_23.score_requirement

		var_30_25 = (var_30_21 - (var_30_27 - var_30_28)) / var_30_28
	else
		var_30_25 = 1
	end

	WwiseWorld.set_global_parameter(arg_30_0.wwise_world, "chest_upgrade_progress", var_30_19)

	if not arg_30_0._upgrade_sound_started and var_30_19 < 1 then
		WwiseWorld.trigger_event(arg_30_0.wwise_world, "play_gui_mission_summary_chest_upgrade_meter_begin")

		arg_30_0._upgrade_sound_started = true
	end

	if (var_30_25 == 1 or var_30_19 == 1) and arg_30_0._upgrade_sound_started then
		WwiseWorld.trigger_event(arg_30_0.wwise_world, "play_gui_mission_summary_chest_upgrade_meter_end")

		arg_30_0._upgrade_sound_started = false
	end

	if var_30_19 == 1 then
		arg_30_0._entry_duration = nil
		arg_30_0._total_score = math.min((arg_30_0._total_score or 0) + var_30_11, var_30_7)

		if var_30_4 == #var_30_3 then
			arg_30_0._chest_zoom_wait_duration = var_30_25 == 1 and 0 or var_0_7
		else
			arg_30_0:_display_next_score_entry()
		end

		arg_30_0._current_bar_total_score_progress = var_30_25

		arg_30_0.ui_animator:start_animation("score_presentation_end", arg_30_0._widgets_by_name, var_0_3, var_30_5)
	else
		if arg_30_0._current_bar_total_score_progress and var_30_25 < arg_30_0._current_bar_total_score_progress then
			var_30_25 = 0
			arg_30_0._current_bar_total_score_progress = nil
		end

		arg_30_0._entry_duration = var_30_16
	end

	arg_30_0:_set_presentation_progress(var_30_25)
end

EndViewStateChest._get_chest_settings_by_total_score = function (arg_31_0, arg_31_1)
	for iter_31_0, iter_31_1 in ipairs(arg_31_0.chest_settings) do
		if arg_31_1 < iter_31_1.total_score then
			return iter_31_1, iter_31_0
		end
	end
end

EndViewStateChest._set_presentation_progress = function (arg_32_0, arg_32_1, arg_32_2)
	local var_32_0 = arg_32_0._widgets_by_name.score_bar
	local var_32_1 = var_32_0.content.texture_id
	local var_32_2 = var_32_0.style.texture_id
	local var_32_3 = var_32_0.scenegraph_id
	local var_32_4 = arg_32_0.ui_scenegraph[var_32_3]
	local var_32_5 = var_0_3[var_32_3].size

	var_32_4.size[1] = math.ceil(var_32_5[1] * arg_32_1)

	if not arg_32_2 then
		WwiseWorld.set_global_parameter(arg_32_0.wwise_world, "summary_meter_progress", arg_32_1)
	end
end

EndViewStateChest._update_chest_zoom_wait_time = function (arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = arg_33_0._chest_zoom_wait_duration

	if not var_33_0 then
		return
	end

	local var_33_1 = var_33_0 + arg_33_1

	if math.min(var_33_1 / var_0_7, 1) == 1 then
		arg_33_0._chest_zoom_wait_duration = nil
		arg_33_0._chest_zoom_duration = 0
	else
		arg_33_0._chest_zoom_wait_duration = var_33_1
	end
end

EndViewStateChest._update_chest_zoom_time = function (arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = arg_34_0._chest_zoom_duration

	if not var_34_0 then
		return
	end

	local var_34_1 = var_34_0 + arg_34_1
	local var_34_2 = math.min(var_34_1 / var_0_8, 1)
	local var_34_3 = math.easeOutCubic(var_34_2)

	arg_34_0.parent:set_camera_zoom(var_34_3)

	if var_34_2 == 1 then
		arg_34_0._chest_zoom_duration = nil
		arg_34_0._chest_wait_exit_duration = 0
	else
		arg_34_0._chest_zoom_duration = var_34_1
	end
end

EndViewStateChest._update_chest_bonus_time = function (arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = arg_35_0._chest_bonus_duration

	if not var_35_0 then
		return
	end

	local var_35_1 = var_35_0 + arg_35_1

	if math.min(var_35_1 / var_0_10, 1) == 1 then
		arg_35_0._chest_bonus_duration = nil
		arg_35_0._chest_wait_exit_duration = 0
	else
		arg_35_0._chest_bonus_duration = var_35_1
	end
end

EndViewStateChest._update_chest_exit_time = function (arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = arg_36_0._chest_wait_exit_duration

	if not var_36_0 then
		return
	end

	local var_36_1 = var_36_0 + arg_36_1

	if math.min(var_36_1 / var_0_11, 1) == 1 then
		arg_36_0.parent:present_chest_rewards()

		arg_36_0._ready_to_exit = true
		arg_36_0._chest_wait_exit_duration = nil
	else
		arg_36_0._chest_wait_exit_duration = var_36_1
	end
end

EndViewStateChest._set_bar_alpha_by_progress = function (arg_37_0, arg_37_1)
	local var_37_0 = arg_37_0._widgets_by_name
	local var_37_1 = var_37_0.bar_bg
	local var_37_2 = var_37_0.score_bar
	local var_37_3 = var_37_0.score_bar_fg

	var_37_1.alpha_multiplier = arg_37_1
	var_37_2.alpha_multiplier = arg_37_1
	var_37_3.alpha_multiplier = arg_37_1
end

EndViewStateChest._play_sound = function (arg_38_0, arg_38_1)
	arg_38_0.parent:play_sound(arg_38_1)
end
