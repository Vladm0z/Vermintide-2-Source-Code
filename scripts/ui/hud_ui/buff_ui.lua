-- chunkname: @scripts/ui/hud_ui/buff_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/buff_ui_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.MAX_BUFF_ROWS
local var_0_3 = var_0_0.MAX_BUFF_COLUMNS
local var_0_4 = var_0_0.MAX_NUMBER_OF_BUFFS
local var_0_5 = var_0_0.BUFF_SIZE
local var_0_6 = var_0_0.BUFF_SPACING

local function var_0_7(arg_1_0)
	return not arg_1_0.duration or arg_1_0.duration == math.huge
end

local function var_0_8(arg_2_0, arg_2_1)
	local var_2_0 = arg_2_0.content
	local var_2_1 = arg_2_1.content
	local var_2_2 = var_2_0.buff
	local var_2_3 = var_2_1.buff

	if var_0_7(var_2_2) ~= var_0_7(var_2_3) then
		return var_0_7(var_2_3)
	end

	return var_2_1.static_start_time < var_2_0.static_start_time
end

local function var_0_9(arg_3_0)
	return var_0_7(arg_3_0) and math.huge or arg_3_0.start_time + arg_3_0.duration
end

BuffUI = class(BuffUI)

function BuffUI.init(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0._ui_renderer = arg_4_2.ui_renderer
	arg_4_0._player = arg_4_2.player
	arg_4_0._is_spectator = false
	arg_4_0._spectated_player_unit = nil
	arg_4_0._render_settings = {
		alpha_multiplier = 1
	}

	arg_4_0:_create_ui_elements()
	Managers.state.event:register(arg_4_0, "on_spectator_target_changed", "on_spectator_target_changed")
	Managers.state.event:register(arg_4_0, "on_spectator_target_changed", "on_spectator_target_changed")
	Managers.state.event:register(arg_4_0, "on_game_options_changed", "on_game_options_changed")
end

function BuffUI._set_widget_dirty(arg_5_0, arg_5_1)
	arg_5_1.element.dirty = true
end

function BuffUI.on_game_options_changed(arg_6_0)
	local var_6_0 = arg_6_0._insignia_visibility
	local var_6_1 = Application.user_setting("toggle_versus_level_in_all_game_modes")
	local var_6_2 = Managers.mechanism:current_mechanism_name() == "versus" or var_6_1

	if var_6_0 ~= var_6_2 then
		arg_6_0._ui_scenegraph.pivot_parent.position[1] = var_6_2 and UISettings.INSIGNIA_OFFSET or 0

		for iter_6_0 = 1, #arg_6_0._active_buff_widgets do
			arg_6_0:_set_widget_dirty(arg_6_0._active_buff_widgets[iter_6_0])
		end

		arg_6_0._dirty = true
		arg_6_0._insignia_visibility = var_6_2
	end
end

function BuffUI._create_ui_elements(arg_7_0)
	arg_7_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)

	local var_7_0 = {}

	for iter_7_0 = 1, var_0_4 do
		var_7_0[iter_7_0] = UIWidget.init(var_0_0.buff_widget_definition)
	end

	arg_7_0._unused_buff_widgets = var_7_0
	arg_7_0._active_buff_widgets = {}
	arg_7_0._buff_name_to_widget = {}

	UIRenderer.clear_scenegraph_queue(arg_7_0._ui_renderer)
	arg_7_0:set_visible(true)

	arg_7_0._dirty = true
	arg_7_0._current_career_index = -1

	arg_7_0:on_game_options_changed()
end

function BuffUI.on_spectator_target_changed(arg_8_0, arg_8_1)
	arg_8_0._spectated_player_unit = arg_8_1
	arg_8_0._is_spectator = true

	arg_8_0:set_visible(false)
	arg_8_0:set_visible(true)

	arg_8_0._dirty = true
	arg_8_0._current_career_index = ScriptUnit.extension(arg_8_1, "career_system"):career_index()
end

function BuffUI._sync_buffs(arg_9_0)
	local var_9_0 = arg_9_0._active_buff_widgets
	local var_9_1 = false

	for iter_9_0 = 1, #var_9_0 do
		var_9_0[iter_9_0].content.stack_count = 0
	end

	local var_9_2 = arg_9_0._is_spectator and arg_9_0._spectated_player_unit or arg_9_0._player.player_unit
	local var_9_3 = ScriptUnit.has_extension(var_9_2, "buff_system")

	if var_9_3 then
		local var_9_4, var_9_5 = var_9_3:active_buffs()

		for iter_9_1 = 1, #var_9_4 do
			local var_9_6 = var_9_4[iter_9_1]
			local var_9_7

			if not var_9_6.removed then
				local var_9_8 = var_9_6.template

				var_9_7 = var_9_8.icon

				if var_9_8.icon_modifier_func then
					var_9_7 = var_9_8.icon_modifier_func(var_9_2, var_9_7)
				end
			end

			if var_9_7 and arg_9_0:_add_buff(var_9_6, var_9_7) then
				var_9_1 = true
			end
		end
	end

	if var_9_1 then
		table.sort(var_9_0, var_0_8)
	end

	local var_9_9 = var_0_5[1] + var_0_6
	local var_9_10 = var_0_5[2] + var_0_6
	local var_9_11 = Managers.time:time("game")
	local var_9_12 = -1

	for iter_9_2 = #var_9_0, 1, -1 do
		local var_9_13 = var_9_0[iter_9_2]
		local var_9_14 = var_9_13.content

		if var_9_14.stack_count == 0 or var_9_14.buff.is_stale then
			arg_9_0:_remove_buff(iter_9_2)

			var_9_1 = true
			var_9_13.element.dirty = true
			arg_9_0._dirty = true
		else
			local var_9_15 = var_9_14.buff

			if not var_0_7(var_9_15) then
				local var_9_16 = var_9_15.duration or math.huge

				if var_9_16 == 0 then
					var_9_14.progress = 0
				else
					local var_9_17 = var_0_9(var_9_15)

					var_9_14.progress = 1 - math.clamp((var_9_17 - var_9_11) / var_9_16, 0, 1)
				end

				var_9_13.element.dirty = true
				arg_9_0._dirty = true
			elseif var_9_14.stack_count ~= var_9_14.last_stack_count then
				var_9_14.last_stack_count = var_9_14.stack_count
				var_9_14.progress = var_9_15.template.is_cooldown and 1 or 0
				var_9_13.element.dirty = true
				arg_9_0._dirty = true
			end

			var_9_12 = var_9_12 + 1

			if var_9_1 then
				local var_9_18 = var_9_13.offset
				local var_9_19 = var_9_12 % var_0_3
				local var_9_20 = math.floor(var_9_12 / var_0_3)

				var_9_18[1] = var_9_9 * var_9_19
				var_9_18[2] = var_9_10 * var_9_20
				var_9_13.element.dirty = true
				arg_9_0._dirty = true
			end
		end
	end
end

local var_0_10 = {
	255,
	48,
	255,
	0
}
local var_0_11 = {
	255,
	255,
	30,
	0
}

function BuffUI._add_buff(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_1.template
	local var_10_1 = arg_10_1.start_time
	local var_10_2 = var_0_9(arg_10_1)
	local var_10_3 = var_0_7(arg_10_1)
	local var_10_4 = var_10_0.is_cooldown
	local var_10_5 = arg_10_0._buff_name_to_widget[var_10_0.name]

	if var_10_5 then
		local var_10_6 = var_10_5.content

		var_10_6.stack_count = var_10_6.stack_count + 1

		if var_10_2 < var_0_9(var_10_6.buff) then
			var_10_6.buff = arg_10_1
			var_10_5.style.texture_icon.saturated = var_10_4
			var_10_5.style.texture_icon_bg.saturated = var_10_4 and var_10_3
		end

		return false
	end

	local var_10_7 = arg_10_0._active_buff_widgets
	local var_10_8 = #var_10_7

	if var_10_8 >= var_0_4 then
		return false
	end

	local var_10_9 = table.remove(arg_10_0._unused_buff_widgets)
	local var_10_10 = var_10_9.content

	var_10_10.texture_icon = arg_10_2
	var_10_10.is_cooldown = var_10_4
	var_10_10.buff = arg_10_1
	var_10_10.name = var_10_0.name
	var_10_10.static_start_time = var_10_1
	var_10_10.stack_count = 1
	var_10_10.progress = var_10_4 and 1 or 0

	UIRenderer.set_element_visible(arg_10_0._ui_renderer, var_10_9.element, true)

	local var_10_11 = var_10_9.style
	local var_10_12 = var_10_0.debuff and var_0_11 or var_0_10

	Colors.copy_to(var_10_11.texture_duration.color, var_10_12)

	var_10_11.texture_icon.saturated = var_10_4
	var_10_11.texture_icon_bg.saturated = var_10_4 and var_10_3
	arg_10_0._buff_name_to_widget[var_10_0.name] = var_10_9
	var_10_7[var_10_8 + 1] = var_10_9

	return true
end

function BuffUI._remove_buff(arg_11_0, arg_11_1)
	local var_11_0 = table.remove(arg_11_0._active_buff_widgets, arg_11_1)
	local var_11_1 = arg_11_0._unused_buff_widgets

	var_11_1[#var_11_1 + 1] = var_11_0
	arg_11_0._buff_name_to_widget[var_11_0.content.name] = nil

	UIRenderer.set_element_visible(arg_11_0._ui_renderer, var_11_0.element, false)
end

function BuffUI.destroy(arg_12_0)
	arg_12_0:set_visible(false)
	Managers.state.event:unregister("on_spectator_target_changed", arg_12_0)
	Managers.state.event:unregister("on_game_options_changed", arg_12_0)
end

function BuffUI.set_visible(arg_13_0, arg_13_1)
	arg_13_0._is_visible = arg_13_1

	local var_13_0 = arg_13_0._ui_renderer
	local var_13_1 = arg_13_0._active_buff_widgets

	for iter_13_0 = 1, #var_13_1 do
		local var_13_2 = var_13_1[iter_13_0]

		UIRenderer.set_element_visible(var_13_0, var_13_2.element, arg_13_1)
	end

	arg_13_0._dirty = true
end

local var_0_12 = {
	root_scenegraph_id = "pivot",
	label = "Buff bar",
	registry_key = "buff_ui",
	drag_scenegraph_id = "pivot_dragger"
}

function BuffUI.update(arg_14_0, arg_14_1, arg_14_2)
	if HudCustomizer.run(arg_14_0._ui_renderer, arg_14_0._ui_scenegraph, var_0_12) then
		UIUtils.mark_dirty(arg_14_0._active_buff_widgets)

		arg_14_0._dirty = true
	end

	arg_14_0:_sync_buffs()

	if RESOLUTION_LOOKUP.modified then
		UIUtils.mark_dirty(arg_14_0._active_buff_widgets)

		arg_14_0._dirty = true
	end

	arg_14_0:draw(arg_14_1)
end

function BuffUI.draw(arg_15_0, arg_15_1)
	if not arg_15_0._is_visible or not arg_15_0._dirty then
		return
	end

	local var_15_0 = arg_15_0._ui_renderer

	UIRenderer.begin_pass(var_15_0, arg_15_0._ui_scenegraph, FAKE_INPUT_SERVICE, arg_15_1, nil, arg_15_0._render_settings)

	local var_15_1 = arg_15_0._active_buff_widgets

	for iter_15_0 = #var_15_1, 1, -1 do
		UIRenderer.draw_widget(var_15_0, var_15_1[iter_15_0])
	end

	UIRenderer.end_pass(var_15_0)

	arg_15_0._dirty = false
end

function BuffUI.set_panel_alpha(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0._render_settings

	if var_16_0.alpha_multiplier ~= arg_16_1 then
		var_16_0.alpha_multiplier = arg_16_1

		UIUtils.mark_dirty(arg_16_0._active_buff_widgets)

		arg_16_0._dirty = true
	end
end
