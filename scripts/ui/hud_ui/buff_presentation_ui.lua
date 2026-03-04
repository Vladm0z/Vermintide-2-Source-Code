-- chunkname: @scripts/ui/hud_ui/buff_presentation_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/buff_presentation_ui_definitions")
local var_0_1 = var_0_0.animation_definitions
local var_0_2 = var_0_0.scenegraph_definition

BuffPresentationUI = class(BuffPresentationUI)

function BuffPresentationUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0.ui_renderer = arg_1_2.ui_renderer
	arg_1_0.ingame_ui = arg_1_2.ingame_ui
	arg_1_0.input_manager = arg_1_2.input_manager

	local var_1_0 = arg_1_2.world_manager:world("level_world")

	arg_1_0.wwise_world = Managers.world:wwise_world(var_1_0)

	arg_1_0:create_ui_elements()
end

function BuffPresentationUI.create_ui_elements(arg_2_0)
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)
	arg_2_0.presentation_widget = UIWidget.init(var_0_0.widget_definitions.presentation_widget)
	arg_2_0.ui_animator = UIAnimator:new(arg_2_0.ui_scenegraph, var_0_1)
	arg_2_0._animations = {}
	arg_2_0._buffs_to_add = {}
	arg_2_0._added_buff_presentations = {}
	arg_2_0._buffs_presented = {}

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)
end

function BuffPresentationUI.destroy(arg_3_0)
	arg_3_0.ui_animator = nil
end

local var_0_3 = {
	root_scenegraph_id = "presentation_widget",
	label = "Buff",
	registry_key = "buff_present",
	drag_scenegraph_id = "presentation_widget_dragger"
}

function BuffPresentationUI.update(arg_4_0, arg_4_1)
	if HudCustomizer.run(arg_4_0.ui_renderer, arg_4_0.ui_scenegraph, var_0_3) then
		UISceneGraph.update_scenegraph(arg_4_0.ui_scenegraph)
	end

	arg_4_0:_sync_buffs()
	arg_4_0:_next_buff(arg_4_1)

	if arg_4_0._active_buff_name then
		arg_4_0:update_animations(arg_4_1)
		arg_4_0:draw(arg_4_1)
	end
end

function BuffPresentationUI.update_animations(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0._animations
	local var_5_1 = arg_5_0.ui_animator

	var_5_1:update(arg_5_1)

	for iter_5_0, iter_5_1 in pairs(var_5_0) do
		if var_5_1:is_animation_completed(iter_5_1) then
			var_5_1:stop_animation(iter_5_1)

			var_5_0[iter_5_0] = nil
		end
	end
end

function BuffPresentationUI.draw(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.ui_renderer
	local var_6_1 = arg_6_0.ui_scenegraph
	local var_6_2 = arg_6_0.input_manager:get_service("ingame_menu")

	UIRenderer.begin_pass(var_6_0, var_6_1, var_6_2, arg_6_1)
	UIRenderer.draw_widget(var_6_0, arg_6_0.presentation_widget)
	UIRenderer.end_pass(var_6_0)
end

function BuffPresentationUI._clear_animations(arg_7_0)
	for iter_7_0, iter_7_1 in pairs(arg_7_0._animations) do
		arg_7_0.ui_animator:stop_animation(iter_7_1)
	end

	table.clear(arg_7_0._animations)
end

function BuffPresentationUI._start_animation(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = {
		wwise_world = arg_8_0.wwise_world
	}
	local var_8_1 = arg_8_0.ui_animator:start_animation(arg_8_2, arg_8_0.presentation_widget, var_0_2, var_8_0)

	arg_8_0._animations[arg_8_1] = var_8_1
end

function BuffPresentationUI._sync_buffs(arg_9_0)
	local var_9_0 = Development.parameter("debug_player_buffs")
	local var_9_1 = Managers.time:time("game")
	local var_9_2 = Managers.player:local_player(1).player_unit

	if var_9_2 then
		local var_9_3 = arg_9_0._buffs_to_add
		local var_9_4 = arg_9_0._buffs_presented

		table.clear(var_9_3)

		local var_9_5 = ScriptUnit.extension(var_9_2, "buff_system")
		local var_9_6 = var_9_5:active_buffs()
		local var_9_7 = var_9_5._num_buffs

		for iter_9_0 = 1, var_9_7 do
			local var_9_8 = var_9_6[iter_9_0]

			if not var_9_8.removed then
				local var_9_9 = var_9_8.template
				local var_9_10 = var_9_9.name

				if var_9_0 or var_9_9.icon ~= nil and var_9_9.priority_buff and not var_9_3[var_9_10] and not var_9_4[var_9_10] then
					arg_9_0:_add_buff(var_9_8)

					var_9_3[var_9_10] = var_9_8
				end
			end
		end

		for iter_9_1, iter_9_2 in ipairs(arg_9_0._added_buff_presentations) do
			local var_9_11 = iter_9_2.name
			local var_9_12 = true

			for iter_9_3, iter_9_4 in pairs(var_9_3) do
				if iter_9_3 == var_9_11 then
					var_9_12 = false

					break
				end
			end

			if var_9_12 then
				arg_9_0:_remove_buff(var_9_11)
			end
		end

		for iter_9_5, iter_9_6 in pairs(var_9_4) do
			local var_9_13 = true

			for iter_9_7 = 1, var_9_7 do
				local var_9_14 = var_9_6[iter_9_7]

				if not var_9_14.removed and iter_9_5 == var_9_14.template.name then
					var_9_13 = false

					break
				end
			end

			if var_9_13 then
				var_9_4[iter_9_5] = nil
			end
		end
	end
end

function BuffPresentationUI._add_buff(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0._added_buff_presentations
	local var_10_1 = arg_10_1.template
	local var_10_2 = var_10_1.name

	for iter_10_0, iter_10_1 in ipairs(var_10_0) do
		if iter_10_1.name == var_10_2 then
			return
		end
	end

	arg_10_0._added_buff_presentations[#arg_10_0._added_buff_presentations + 1] = var_10_1
end

function BuffPresentationUI._remove_buff(arg_11_0, arg_11_1)
	local var_11_0

	for iter_11_0, iter_11_1 in ipairs(arg_11_0._added_buff_presentations) do
		if iter_11_1.name == arg_11_1 then
			var_11_0 = iter_11_0

			break
		end
	end

	if var_11_0 and arg_11_0._added_buff_presentations[var_11_0] then
		table.remove(arg_11_0._added_buff_presentations, var_11_0)
	end
end

function BuffPresentationUI._next_buff(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0._added_buff_presentations

	if not arg_12_0._active_buff_name or arg_12_0._active_buff_name and not arg_12_0._animations.presentation then
		if arg_12_0._active_buff_name then
			arg_12_0._buffs_presented[arg_12_0._active_buff_name] = true
			arg_12_0._active_buff_name = nil

			table.remove(var_12_0, 1)
		end

		if #var_12_0 > 0 then
			local var_12_1 = var_12_0[1]

			arg_12_0._active_buff_name = var_12_1.name

			arg_12_0:_set_buff_to_present(var_12_1)
			arg_12_0:_start_animation("presentation", "presentation")
		end
	end
end

function BuffPresentationUI._set_buff_to_present(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0.presentation_widget
	local var_13_1 = arg_13_1.icon or "icons_placeholder"

	var_13_0.content.texture_icon = var_13_1
end
