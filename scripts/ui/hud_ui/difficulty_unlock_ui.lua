-- chunkname: @scripts/ui/hud_ui/difficulty_unlock_ui.lua

require("scripts/settings/difficulty_settings")

local var_0_0 = local_require("scripts/ui/hud_ui/difficulty_unlock_ui_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.animations
local var_0_3 = SurvivalStartWaveByDifficulty

DifficultyUnlockUI = class(DifficultyUnlockUI)

local var_0_4 = false

function DifficultyUnlockUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0.ui_renderer = arg_1_2.ui_renderer
	arg_1_0.ingame_ui = arg_1_2.ingame_ui
	arg_1_0.input_manager = arg_1_2.input_manager
	arg_1_0.world = arg_1_2.world_manager:world("level_world")
	arg_1_0.wwise_world = Managers.world:wwise_world(arg_1_0.world)
	arg_1_0.difficulty_manager = Managers.state.difficulty
	arg_1_0.statistics_db = arg_1_2.statistics_db
	arg_1_0.ui_animations = {}

	arg_1_0:create_ui_elements()
	arg_1_0:difficulty_set()
	Managers.state.event:register(arg_1_0, "difficulty_synced", "difficulty_set")
end

function DifficultyUnlockUI.create_ui_elements(arg_2_0)
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)

	local var_2_0 = var_0_0.widget_definitions
	local var_2_1 = {}

	for iter_2_0 = 1, 5 do
		local var_2_2 = "difficulty_icon_" .. iter_2_0

		var_2_1[iter_2_0] = UIWidget.init(var_2_0[var_2_2])
	end

	arg_2_0.icon_widgets = var_2_1
	arg_2_0.background_top_widget = UIWidget.init(var_2_0.background_top)
	arg_2_0.background_center_widget = UIWidget.init(var_2_0.background_center)
	arg_2_0.background_bottom_widget = UIWidget.init(var_2_0.background_bottom)
	arg_2_0.background_glow_widget = UIWidget.init(var_2_0.background_glow)
	arg_2_0.difficulty_text_widget = UIWidget.init(var_2_0.difficulty_text)
	arg_2_0.difficulty_title_text_widget = UIWidget.init(var_2_0.difficulty_title_text)

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)

	arg_2_0.ui_animator = UIAnimator:new(arg_2_0.ui_scenegraph, var_0_2)
	arg_2_0.is_visible = true
end

function DifficultyUnlockUI.difficulty_set(arg_3_0)
	local var_3_0 = arg_3_0.statistics_db
	local var_3_1 = Managers.player:local_player():stats_id()
	local var_3_2 = Managers.state.game_mode:level_key()
	local var_3_3 = LevelSettings[var_3_2]
	local var_3_4 = arg_3_0.difficulty_manager:get_default_difficulties()
	local var_3_5 = table.mirror_table(var_3_4)
	local var_3_6 = arg_3_0.difficulty_manager:get_difficulty()
	local var_3_7 = table.find(var_3_5, var_3_6)
	local var_3_8 = (LevelUnlockUtils.completed_level_difficulty_index(var_3_0, var_3_1, var_3_2) or 0) + 1

	if var_3_7 and var_3_6 ~= var_3_4[#var_3_4] then
		local var_3_9 = var_0_3[var_3_6]
		local var_3_10 = {}
		local var_3_11 = {}

		for iter_3_0 = var_3_7, #var_3_4 do
			local var_3_12 = var_3_4[iter_3_0]

			if var_3_12 ~= var_3_6 and var_3_8 < iter_3_0 then
				local var_3_13 = var_0_3[var_3_12]

				var_3_10[#var_3_10 + 1] = var_3_13 - var_3_9
				var_3_11[#var_3_11 + 1] = var_3_12
			end
		end

		arg_3_0.next_presentation_wave = var_3_10[1]
		arg_3_0.persentation_wave_list = var_3_10
		arg_3_0.persentation_wave_difficulty_list = var_3_11
	end
end

function DifficultyUnlockUI.align_icon_widgets(arg_4_0)
	local var_4_0 = arg_4_0.icon_draw_count
	local var_4_1 = arg_4_0.icon_widgets
	local var_4_2 = 50
	local var_4_3 = -(var_4_0 / 2 * var_4_2) + var_4_2 * 0.5

	if var_4_1 then
		local var_4_4 = arg_4_0.ui_scenegraph
		local var_4_5 = 0

		for iter_4_0 = 1, var_4_0 do
			local var_4_6 = var_4_1[iter_4_0]

			var_4_4[var_4_6.scenegraph_id].local_position[1] = var_4_3
			var_4_3 = var_4_3 + var_4_2
			var_4_6.element.dirty = true
		end
	end
end

function DifficultyUnlockUI.destroy(arg_5_0)
	arg_5_0.ui_animator = nil

	arg_5_0:set_visible(false)
end

function DifficultyUnlockUI.set_visible(arg_6_0, arg_6_1)
	arg_6_0.is_visible = arg_6_1

	local var_6_0 = arg_6_0.ui_renderer
	local var_6_1 = arg_6_0.icon_widgets

	if var_6_1 then
		for iter_6_0, iter_6_1 in ipairs(var_6_1) do
			UIRenderer.set_element_visible(var_6_0, iter_6_1.element, arg_6_1)
		end
	end
end

function DifficultyUnlockUI._check_for_presentation_start(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.previous_wave_completed or 0
	local var_7_1 = arg_7_1.wave_completed - arg_7_1.starting_wave

	if var_7_1 <= var_7_0 then
		return
	end

	if arg_7_0.next_presentation_wave == var_7_1 then
		table.remove(arg_7_0.persentation_wave_list, 1)

		arg_7_0.next_presentation_wave = arg_7_0.persentation_wave_list[1]
		arg_7_0.display_presentation_difficulty = arg_7_0.persentation_wave_difficulty_list[1]

		table.remove(arg_7_0.persentation_wave_difficulty_list, 1)

		arg_7_0.presentation_start_time = 0
	end

	arg_7_0.previous_wave_completed = var_7_1
end

function DifficultyUnlockUI._update_start_timer(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.presentation_start_time

	if var_8_0 then
		local var_8_1 = 10

		if var_8_0 == var_8_1 then
			arg_8_0:display_unlock(nil, arg_8_0.display_presentation_difficulty)

			arg_8_0.display_presentation_difficulty = nil
			var_8_0 = nil
		else
			var_8_0 = math.min(var_8_0 + arg_8_1, var_8_1)
		end

		arg_8_0.presentation_start_time = var_8_0
	end
end

function DifficultyUnlockUI.update(arg_9_0, arg_9_1, arg_9_2)
	if var_0_4 then
		var_0_4 = false

		arg_9_0:create_ui_elements()
	end

	if arg_9_0.next_presentation_wave then
		arg_9_0:_check_for_presentation_start(arg_9_2)
	end

	arg_9_0:_update_start_timer(arg_9_1)

	if not arg_9_0.is_visible or not arg_9_0.draw_widgets then
		return
	end

	local var_9_0
	local var_9_1 = arg_9_0.ui_animations

	if var_9_1 then
		for iter_9_0, iter_9_1 in pairs(var_9_1) do
			var_9_0 = true

			UIAnimation.update(iter_9_1, arg_9_1)

			if UIAnimation.completed(iter_9_1) then
				arg_9_0.ui_animations[iter_9_0] = nil
			end
		end
	end

	local var_9_2 = arg_9_0.ui_animator

	var_9_2:update(arg_9_1)

	local var_9_3 = arg_9_0.presentation_anim_id

	if var_9_3 then
		if var_9_2:is_animation_completed(var_9_3) then
			var_9_2:stop_animation(var_9_3)

			arg_9_0.presentation_anim_id = nil

			arg_9_0:start_explode_animation()
		end

		var_9_0 = true
	end

	local var_9_4 = arg_9_0.explode_anim_id

	if var_9_4 then
		if var_9_2:is_animation_completed(var_9_4) then
			var_9_2:stop_animation(var_9_4)

			arg_9_0.explode_anim_id = nil

			arg_9_0:on_presentation_complete()
		end

		var_9_0 = true
	end

	if not var_9_0 and RESOLUTION_LOOKUP.modified then
		var_9_0 = true
	end

	if var_9_0 then
		local var_9_5 = arg_9_0.icon_widgets

		if var_9_5 then
			for iter_9_2, iter_9_3 in ipairs(var_9_5) do
				iter_9_3.element.dirty = true
			end
		end
	end

	arg_9_0:draw(arg_9_1)
end

function DifficultyUnlockUI.draw(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.ui_renderer
	local var_10_1 = arg_10_0.ui_scenegraph
	local var_10_2 = arg_10_0.input_manager:get_service("ingame_menu")

	UIRenderer.begin_pass(var_10_0, var_10_1, var_10_2, arg_10_1)

	local var_10_3 = arg_10_0.icon_draw_count

	if var_10_3 then
		local var_10_4 = arg_10_0.icon_widgets

		if var_10_4 then
			for iter_10_0 = 1, var_10_3 do
				local var_10_5 = var_10_4[iter_10_0]

				UIRenderer.draw_widget(var_10_0, var_10_5)
			end
		end
	end

	UIRenderer.draw_widget(var_10_0, arg_10_0.background_top_widget)
	UIRenderer.draw_widget(var_10_0, arg_10_0.background_center_widget)
	UIRenderer.draw_widget(var_10_0, arg_10_0.background_bottom_widget)
	UIRenderer.draw_widget(var_10_0, arg_10_0.background_glow_widget)
	UIRenderer.draw_widget(var_10_0, arg_10_0.difficulty_text_widget)
	UIRenderer.draw_widget(var_10_0, arg_10_0.difficulty_title_text_widget)
	UIRenderer.end_pass(var_10_0)
end

function DifficultyUnlockUI.set_difficulty_amount(arg_11_0, arg_11_1)
	arg_11_0.icon_draw_count = arg_11_1

	arg_11_0:align_icon_widgets()
end

function DifficultyUnlockUI.display_unlock(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = DifficultySettings[arg_12_2]
	local var_12_1 = var_12_0.rank
	local var_12_2 = var_12_0.display_name

	arg_12_0.difficulty_text_widget.content.text = var_12_2

	arg_12_0:set_difficulty_amount(var_12_1)
	arg_12_0:start_presentation_animation()

	arg_12_0.draw_widgets = true
end

function DifficultyUnlockUI.on_presentation_complete(arg_13_0)
	arg_13_0.draw_widgets = false
end

function DifficultyUnlockUI.start_presentation_animation(arg_14_0)
	local var_14_0 = {
		wwise_world = arg_14_0.wwise_world
	}
	local var_14_1 = {}
	local var_14_2 = arg_14_0.icon_draw_count
	local var_14_3 = arg_14_0.icon_widgets
	local var_14_4 = {}

	for iter_14_0 = 1, var_14_2 do
		var_14_4[iter_14_0] = var_14_3[iter_14_0]
	end

	var_14_1.icons = var_14_4
	var_14_1.background_top = arg_14_0.background_top_widget
	var_14_1.background_center = arg_14_0.background_center_widget
	var_14_1.background_bottom = arg_14_0.background_bottom_widget
	var_14_1.background_glow = arg_14_0.background_glow_widget
	var_14_1.difficulty_text = arg_14_0.difficulty_text_widget
	var_14_1.difficulty_title_text = arg_14_0.difficulty_title_text_widget
	arg_14_0.presentation_anim_id = arg_14_0.ui_animator:start_animation("presentation", var_14_1, var_0_1, var_14_0)
end

function DifficultyUnlockUI.start_explode_animation(arg_15_0)
	local var_15_0 = {
		wwise_world = arg_15_0.wwise_world
	}
	local var_15_1 = {}
	local var_15_2 = arg_15_0.icon_draw_count
	local var_15_3 = arg_15_0.icon_widgets
	local var_15_4 = {}

	for iter_15_0 = 1, var_15_2 do
		var_15_4[iter_15_0] = var_15_3[iter_15_0]
	end

	var_15_1.icons = var_15_4
	var_15_1.background_top = arg_15_0.background_top_widget
	var_15_1.background_center = arg_15_0.background_center_widget
	var_15_1.background_bottom = arg_15_0.background_bottom_widget
	var_15_1.background_glow = arg_15_0.background_glow_widget
	var_15_1.difficulty_text = arg_15_0.difficulty_text_widget
	var_15_1.difficulty_title_text = arg_15_0.difficulty_title_text_widget

	local var_15_5 = var_15_2 == 4 and "explode_parts_4" or "explode_parts_5"

	arg_15_0.explode_anim_id = arg_15_0.ui_animator:start_animation(var_15_5, var_15_1, var_0_1, var_15_0)
end
