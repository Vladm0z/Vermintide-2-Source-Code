-- chunkname: @scripts/ui/hud_ui/loot_objective_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/loot_objective_ui_definitions")
local var_0_1 = var_0_0.create_loot_widget

LootObjectiveUI = class(LootObjectiveUI)

local var_0_2 = {
	tome = {
		item_name = "wpn_side_objective_tome_01",
		mission_name = "tome_bonus_mission",
		total_amount = 3,
		texture = "loot_objective_icon_02"
	},
	grimoire = {
		item_name = "wpn_grimoire_01",
		mission_name = "grimoire_hidden_mission",
		total_amount = 2,
		texture = "loot_objective_icon_01"
	}
}

LootObjectiveUI.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0.ui_renderer = arg_1_2.ui_renderer
	arg_1_0.ingame_ui = arg_1_2.ingame_ui
	arg_1_0.input_manager = arg_1_2.input_manager

	local var_1_0 = arg_1_2.world_manager:world("level_world")

	arg_1_0.wwise_world = Managers.world:wwise_world(var_1_0)
	arg_1_0.saved_mission_objectives = {}
	arg_1_0.completed_mission_objectives = {}
	arg_1_0.current_mission_objective = nil
	arg_1_0.index_count = 0
	arg_1_0._mission_system = Managers.state.entity:system("mission_system")
	arg_1_0._animations = {}
	arg_1_0._event_queue = {}

	arg_1_0:create_ui_elements()
end

local var_0_3 = true

LootObjectiveUI.create_ui_elements = function (arg_2_0)
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local var_2_0 = {}
	local var_2_1 = {}

	for iter_2_0, iter_2_1 in pairs(var_0_2) do
		local var_2_2 = iter_2_1.mission_name
		local var_2_3 = iter_2_1.texture
		local var_2_4 = iter_2_1.total_amount
		local var_2_5 = var_0_1(var_2_3, var_2_4)
		local var_2_6 = UIWidget.init(var_2_5)

		var_2_0[iter_2_0] = var_2_6
		var_2_1[iter_2_0] = {
			name = iter_2_0,
			total_amount = var_2_4,
			mission_name = var_2_2,
			widget = var_2_6
		}
	end

	arg_2_0._settings_data = var_2_1
	arg_2_0._widgets_by_name = var_2_0

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)

	var_0_3 = false

	arg_2_0:_sync_missions(true)
end

LootObjectiveUI.destroy = function (arg_3_0)
	GarbageLeakDetector.register_object(arg_3_0, "loot_objective_ui")
end

local var_0_4 = {
	root_scenegraph_id = "background",
	label = "Books",
	registry_key = "books",
	drag_scenegraph_id = "background"
}

LootObjectiveUI.update = function (arg_4_0, arg_4_1, arg_4_2)
	if var_0_3 then
		arg_4_0:create_ui_elements()
	end

	HudCustomizer.run(arg_4_0.ui_renderer, arg_4_0.ui_scenegraph, var_0_4)
	arg_4_0:_sync_missions()

	arg_4_0._active_presentation_widget = arg_4_0:_update_active_presentation(arg_4_1, arg_4_2)

	arg_4_0:_update_animations(arg_4_1)
	arg_4_0:draw(arg_4_1)
end

LootObjectiveUI._sync_missions = function (arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0._settings_data

	for iter_5_0, iter_5_1 in pairs(var_5_0) do
		local var_5_1 = iter_5_1.mission_name
		local var_5_2 = arg_5_0:_get_item_amount_by_mission_name(var_5_1) or 0

		if not iter_5_1.amount then
			iter_5_1.amount = var_5_2 or 0
		end

		local var_5_3 = iter_5_1.amount

		if var_5_3 ~= var_5_2 then
			iter_5_1.previous_amount = var_5_3 or 0
			iter_5_1.amount = var_5_2

			local var_5_4 = iter_5_1.widget

			if not arg_5_1 then
				arg_5_0:_add_presentation_event(var_5_4, iter_5_1.previous_amount, var_5_2)
			end
		end
	end
end

LootObjectiveUI._assign_amount_to_widget = function (arg_6_0, arg_6_1, arg_6_2)
	arg_6_1.content.draw_count = arg_6_2
end

LootObjectiveUI._get_item_amount_by_mission_name = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._mission_system:get_level_end_mission_data(arg_7_1)

	return var_7_0 and var_7_0.current_amount
end

LootObjectiveUI._add_presentation_event = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_0._event_queue
	local var_8_1 = #var_8_0

	var_8_0[#var_8_0 + 1] = {
		amount = arg_8_3,
		previous_amount = arg_8_2,
		widget = arg_8_1
	}
end

LootObjectiveUI._update_active_presentation = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0._event_queue

	if #var_9_0 == 0 then
		return
	end

	local var_9_1 = var_9_0[1]
	local var_9_2 = var_9_1.widget
	local var_9_3 = var_9_1.amount
	local var_9_4 = var_9_1.previous_amount

	if not var_9_1.started then
		arg_9_0:_assign_amount_to_widget(var_9_2, var_9_3)

		var_9_1.started = true

		local var_9_5 = 2.5

		var_9_1.end_time = arg_9_2 + arg_9_0:_animate_in(var_9_2, var_9_4) + var_9_5
	end

	if arg_9_2 > var_9_1.end_time then
		if not var_9_1.end_started then
			var_9_1.end_started = true
			var_9_1.end_time = arg_9_2 + arg_9_0:_animate_out(var_9_2)
		else
			table.remove(var_9_0, 1)
		end
	end

	return var_9_2
end

LootObjectiveUI._animate_in = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0._animations
	local var_10_1 = 1
	local var_10_2 = 0
	local var_10_3 = math.easeInCubic
	local var_10_4 = UIAnimation.function_by_time
	local var_10_5 = 0.3
	local var_10_6 = arg_10_1.content.amount
	local var_10_7 = arg_10_1.content.draw_count
	local var_10_8 = arg_10_1.style.icon_textures.texture_colors
	local var_10_9 = math.max(arg_10_2, var_10_7)
	local var_10_10 = arg_10_2 < var_10_7

	for iter_10_0 = 1, math.min(var_10_6, var_10_9) do
		local var_10_11 = var_10_8[iter_10_0]

		if not var_10_10 or iter_10_0 < var_10_9 then
			local var_10_12 = UIAnimation.init(var_10_4, var_10_11, var_10_1, var_10_2, 255, var_10_5, var_10_3)

			var_10_0["icon_textures_" .. iter_10_0] = var_10_12
		end

		if iter_10_0 == var_10_9 then
			if var_10_10 then
				local var_10_13 = UIAnimation.init(UIAnimation.wait, var_10_5 + 0.2, var_10_4, var_10_11, var_10_1, var_10_2, 255, var_10_5, var_10_3)

				var_10_0["icon_textures_" .. iter_10_0] = var_10_13
			else
				local var_10_14 = UIAnimation.init(UIAnimation.wait, var_10_5 + 0.5, var_10_4, var_10_11, var_10_1, 255, 0, var_10_5, var_10_3)

				var_10_0["icon_textures_last" .. iter_10_0] = var_10_14
			end
		end
	end

	local var_10_15 = arg_10_1.style.background_icon_textures.color
	local var_10_16 = arg_10_1.style.background_icon_textures.default_color

	var_10_0.background_icon_textures = UIAnimation.init(var_10_4, var_10_15, var_10_1, var_10_2, var_10_16[var_10_1], var_10_5, var_10_3)

	local var_10_17 = arg_10_1.style.glow_icon_textures.color
	local var_10_18 = arg_10_1.style.glow_icon_textures.default_color

	var_10_0.glow_icon_textures = UIAnimation.init(var_10_4, var_10_17, var_10_1, var_10_2, var_10_18[var_10_1], var_10_5, var_10_3)

	local var_10_19 = arg_10_1.style.background.color
	local var_10_20 = arg_10_1.style.background.default_color

	var_10_0.background = UIAnimation.init(var_10_4, var_10_19, var_10_1, var_10_2, var_10_20[var_10_1], var_10_5, var_10_3)

	return var_10_5
end

LootObjectiveUI._animate_out = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._animations
	local var_11_1 = 1
	local var_11_2 = 0
	local var_11_3 = math.easeInCubic
	local var_11_4 = UIAnimation.function_by_time
	local var_11_5 = 0.3
	local var_11_6 = arg_11_1.content.amount
	local var_11_7 = arg_11_1.content.draw_count
	local var_11_8 = arg_11_1.style.icon_textures.texture_colors

	for iter_11_0 = 1, var_11_6 do
		if iter_11_0 <= var_11_7 then
			if iter_11_0 ~= var_11_7 or not (var_11_5 + 1) then
				local var_11_9 = var_11_5
			end

			local var_11_10 = var_11_8[iter_11_0]

			var_11_0["icon_textures_" .. iter_11_0] = UIAnimation.init(var_11_4, var_11_10, var_11_1, 255, var_11_2, var_11_5, var_11_3)
		end
	end

	local var_11_11 = arg_11_1.style.background_icon_textures.color

	var_11_0.background_icon_textures = UIAnimation.init(var_11_4, var_11_11, var_11_1, var_11_11[1], var_11_2, var_11_5, var_11_3)

	local var_11_12 = arg_11_1.style.glow_icon_textures.color

	var_11_0.glow_icon_textures = UIAnimation.init(var_11_4, var_11_12, var_11_1, var_11_12[1], var_11_2, var_11_5, var_11_3)

	local var_11_13 = arg_11_1.style.background.color

	var_11_0.background = UIAnimation.init(var_11_4, var_11_13, var_11_1, var_11_13[1], var_11_2, var_11_5, var_11_3)

	return var_11_5
end

LootObjectiveUI._update_animations = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0._animations

	for iter_12_0, iter_12_1 in pairs(var_12_0) do
		UIAnimation.update(iter_12_1, arg_12_1)

		if UIAnimation.completed(iter_12_1) then
			var_12_0[iter_12_0] = nil
		end
	end
end

LootObjectiveUI.draw = function (arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0.ui_renderer
	local var_13_1 = arg_13_0.ui_scenegraph
	local var_13_2 = arg_13_0.input_manager:get_service("ingame_menu")

	UIRenderer.begin_pass(var_13_0, var_13_1, var_13_2, arg_13_1)

	local var_13_3 = arg_13_0._active_presentation_widget

	if var_13_3 then
		UIRenderer.draw_widget(var_13_0, var_13_3)
	end

	UIRenderer.end_pass(var_13_0)
end
