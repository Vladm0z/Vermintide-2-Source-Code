-- chunkname: @scripts/ui/hud_ui/gameplay_info_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/gameplay_info_ui_definitions")
local var_0_1 = var_0_0.scenegraph
local var_0_2 = var_0_0.widgets
local var_0_3 = var_0_0.spawn_info_widgets
local var_0_4 = var_0_0.animation_definitions

GameplayInfoUI = class(GameplayInfoUI)

GameplayInfoUI.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0._ui_renderer = arg_1_2.ui_renderer
	arg_1_0._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	arg_1_0._first_time = true
	arg_1_0._world = arg_1_2.world_manager:world("level_world")
	arg_1_0._wwise_world = Managers.world:wwise_world(arg_1_0._world)

	arg_1_0:_create_ui_elements()
	Managers.state.event:register(arg_1_0, "add_gameplay_info_event", "add_gameplay_info_event", "update_range_to_spawn", "on_update_range_to_spawn")
end

GameplayInfoUI.add_gameplay_info_event = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	arg_2_0._active_event = arg_2_1
	arg_2_0._active_reason = arg_2_3
	arg_2_0._show = arg_2_2
	arg_2_0._target_unit = arg_2_4

	arg_2_0:_update_button_prompts()

	if arg_2_0._first_time then
		-- Nothing
	end
end

GameplayInfoUI._update_spawn_info_texts = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_0._widgets_by_name.spawn_text
	local var_3_1 = arg_3_0._widgets_by_name.spawn_reason

	var_3_0.content.text = arg_3_1 and arg_3_1 or ""
	var_3_0.content.visible = arg_3_1 ~= nil
	var_3_1.content.text = arg_3_2 and arg_3_2 or ""
	var_3_1.content.visible = arg_3_2 ~= nil
end

GameplayInfoUI._update_selected_career_data = function (arg_4_0)
	local var_4_0, var_4_1 = arg_4_0:_get_current_selected_career_data()
	local var_4_2 = arg_4_0._widgets_by_name.spawn_help.content

	var_4_2.portrait = var_4_1
	var_4_2.pick_name = Localize(var_4_0)
end

GameplayInfoUI._update_button_prompts = function (arg_5_0)
	local var_5_0 = arg_5_0._active_event
	local var_5_1 = arg_5_0._active_reason

	if not arg_5_0._show then
		return
	end

	if not var_5_0 then
		return
	end

	local var_5_2
	local var_5_3
	local var_5_4
	local var_5_5
	local var_5_6
	local var_5_7
	local var_5_8 = false

	if var_5_0 == "ghost_spawn" then
		local var_5_9 = "Player"
		local var_5_10 = "ghost_mode_exit"
		local var_5_11 = "$KEY;%s__%s:"
		local var_5_12 = Managers.input:get_service(var_5_9)
		local var_5_13, var_5_14, var_5_15 = UISettings.get_gamepad_input_texture_data(var_5_12, var_5_10, arg_5_0._gamepad_active)
		local var_5_16 = ""

		if arg_5_0._gamepad_active then
			var_5_16 = string.format(var_5_11, var_5_9, var_5_10)
		elseif var_5_15 and var_5_15[1] == "mouse" or arg_5_0._gamepad_active then
			var_5_16 = string.format(var_5_11, var_5_9, var_5_10)
		else
			var_5_16 = var_5_14 and "{#color(193,91,36)}[" .. var_5_14 .. "] {#reset()}" or ""
		end

		var_5_4 = string.format(Localize("versus_gameplay_info_spawn_here"), var_5_16)
		var_5_6 = {
			175,
			0,
			255,
			0
		}
	elseif var_5_0 == "ghost_cantspawn" then
		var_5_5 = {
			175,
			141,
			141,
			141
		}
		var_5_6 = {
			175,
			141,
			141,
			141
		}
		var_5_4 = string.format(Localize("versus_gameplay_info_unable_to_spawn"), var_5_5[2], var_5_5[3], var_5_5[4], var_5_5[1])

		if var_5_1 == "range" then
			var_5_7 = Localize("vs_spawning_hero_range")
			var_5_7 = var_5_7 .. arg_5_0._range or 20
		elseif var_5_1 == "los" then
			var_5_7 = Localize("vs_spawning_hero_los")
		elseif var_5_1 == "start_zone" then
			var_5_7 = Localize("vs_spawning_hero_start_zone")
		elseif var_5_1 == "transport" then
			var_5_7 = Localize("vs_spawning_hero_transport")
		elseif var_5_1 == "w8_to_spawn" then
			var_5_7 = Localize("vs_spawning_w8_to_spawn")
		elseif var_5_1 == "in_safe_zone" then
			var_5_7 = "Can't spawn in hero safe zone"
		else
			var_5_7 = Localize("vs_spawning_w8_to_spawn")
		end
	elseif var_5_0 == "ghost_catchup" then
		arg_5_0:_update_catchup_tele_prompt()

		return
	elseif var_5_0 == "hide_teleport" then
		local var_5_17 = true
		local var_5_18 = "Player"
		local var_5_19 = "ghost_mode_enter"
		local var_5_20 = ""

		arg_5_0:_set_tele_prompt(var_5_18, var_5_19, var_5_20, nil, var_5_5, var_5_17)

		return
	elseif var_5_0 == "hide_text" then
		local var_5_21 = true
	end

	arg_5_0:_update_spawn_info_texts(var_5_4, var_5_7, var_5_6)
end

GameplayInfoUI._set_sub_text = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._widgets_by_name.ghost_mode_text_sub

	var_6_0.content.text = arg_6_1 or ""
	var_6_0.content.visible = arg_6_1 ~= nil
end

GameplayInfoUI._create_ui_elements = function (arg_7_0)
	arg_7_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)
	arg_7_0._ui_animator = UIAnimator:new(arg_7_0._ui_scenegraph, var_0_4)
	arg_7_0._animations = {}

	local var_7_0 = {}
	local var_7_1 = {}
	local var_7_2 = {}

	for iter_7_0, iter_7_1 in pairs(var_0_2) do
		local var_7_3 = UIWidget.init(iter_7_1)

		var_7_1[iter_7_0] = var_7_3
		var_7_0[#var_7_0 + 1] = var_7_3
	end

	for iter_7_2, iter_7_3 in pairs(var_0_3) do
		local var_7_4 = UIWidget.init(iter_7_3)

		var_7_1[iter_7_2] = var_7_4
		var_7_2[#var_7_2 + 1] = var_7_4
	end

	arg_7_0._widgets = var_7_0
	arg_7_0._spawn_info_widgets = var_7_2
	arg_7_0._widgets_by_name = var_7_1

	UIRenderer.clear_scenegraph_queue(arg_7_0._ui_renderer)
end

GameplayInfoUI.destroy = function (arg_8_0)
	local var_8_0 = Managers.state.event

	var_8_0:unregister("add_gameplay_info_event", arg_8_0)
	var_8_0:unregister("update_range_to_spawn", arg_8_0)
end

GameplayInfoUI.on_update_range_to_spawn = function (arg_9_0, arg_9_1)
	arg_9_1 = math.max(arg_9_1, 1)
	arg_9_0._range = string.format("%2dm", arg_9_1)

	arg_9_0:_update_button_prompts()
end

GameplayInfoUI.update = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0._animations
	local var_10_1 = arg_10_0._ui_animator
	local var_10_2 = Managers.input:is_device_active("gamepad")

	if var_10_2 ~= arg_10_0._gamepad_active then
		arg_10_0._gamepad_active = var_10_2

		arg_10_0:_update_button_prompts()
		arg_10_0:_update_catchup_tele_prompt()
	end

	var_10_1:update(arg_10_1)

	for iter_10_0, iter_10_1 in pairs(var_10_0) do
		local var_10_3 = iter_10_1.id

		if var_10_1:is_animation_completed(var_10_3) then
			var_10_1:stop_animation(var_10_3)

			arg_10_0._animations[iter_10_0] = nil
		end
	end

	arg_10_0:_draw(arg_10_1)
end

GameplayInfoUI._draw = function (arg_11_0, arg_11_1)
	if not arg_11_0._show then
		return
	end

	local var_11_0 = arg_11_0._ui_renderer
	local var_11_1 = arg_11_0._ui_scenegraph
	local var_11_2 = Managers.input:get_service("ingame_menu")
	local var_11_3 = arg_11_0._render_settings

	UIRenderer.begin_pass(var_11_0, var_11_1, var_11_2, arg_11_1, nil, var_11_3)

	for iter_11_0, iter_11_1 in ipairs(arg_11_0._widgets) do
		UIRenderer.draw_widget(var_11_0, iter_11_1)
	end

	local var_11_4 = Managers.player:local_player().player_unit
	local var_11_5 = var_11_4 and ScriptUnit.has_extension(var_11_4, "ghost_mode_system")

	if var_11_5 and var_11_5:is_in_ghost_mode() then
		for iter_11_2, iter_11_3 in ipairs(arg_11_0._spawn_info_widgets) do
			UIRenderer.draw_widget(var_11_0, iter_11_3)
		end
	end

	UIRenderer.end_pass(var_11_0)
end

GameplayInfoUI._set_tele_prompt = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	local var_12_0 = arg_12_0._widgets_by_name
	local var_12_1 = arg_12_0._ui_scenegraph
	local var_12_2 = Managers.input
	local var_12_3 = arg_12_0._ui_renderer
	local var_12_4 = arg_12_1 and var_12_2:get_service(arg_12_1)
	local var_12_5 = var_12_2:is_device_active("gamepad")
	local var_12_6 = var_12_0.teleport_text
	local var_12_7
	local var_12_8

	if arg_12_2 and not arg_12_6 then
		local var_12_9

		var_12_9, var_12_8 = UISettings.get_gamepad_input_texture_data(var_12_4, arg_12_2, var_12_5)
	end

	local var_12_10 = " %s %s "
	local var_12_11 = ""

	if var_12_5 then
		var_12_11 = "$KEY;" .. arg_12_1 .. "__" .. arg_12_2 .. ":"
	else
		var_12_11 = var_12_8 and "{#color(193,91,36)}[" .. var_12_8 .. "] {#reset()}" or ""
	end

	var_12_6.content.text = string.format(var_12_10, var_12_11, arg_12_3)
	var_12_6.content.visible = not arg_12_6
end

GameplayInfoUI._start_animation = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = {
		wwise_world = arg_13_0._wwise_world,
		render_settings = arg_13_0._render_settings,
		ui_scenegraph = arg_13_0._ui_scenegraph
	}
	local var_13_1 = arg_13_0._ui_animator:start_animation(arg_13_1, arg_13_3, var_0_1, var_13_0)

	arg_13_0._animations[arg_13_2] = {
		id = var_13_1,
		name = arg_13_1
	}
end

GameplayInfoUI._update_catchup_tele_prompt = function (arg_14_0)
	local var_14_0 = "Player"
	local var_14_1 = "ghost_mode_enter"
	local var_14_2 = Localize("vs_spawning_ghost_catchup")

	arg_14_0:_set_tele_prompt(var_14_0, var_14_1, var_14_2)
end
