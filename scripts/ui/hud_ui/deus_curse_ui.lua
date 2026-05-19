-- chunkname: @scripts/ui/hud_ui/deus_curse_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/deus_curse_ui_definitions")
local var_0_1 = var_0_0.animation_definitions
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.scenegraph_methods
local var_0_4 = var_0_0.text_background_width
local var_0_5 = -2

DeusCurseUI = class(DeusCurseUI)

function DeusCurseUI.init(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = Managers.mechanism:game_mechanism()

	arg_1_0._curse = var_1_0 and var_1_0:get_current_node_curse()
	arg_1_0._theme = var_1_0 and var_1_0:get_current_node_theme()
	arg_1_0._has_curse = arg_1_0._curse and arg_1_0._theme
	arg_1_0._world = arg_1_2.world_manager:world("level_world")
	arg_1_0._player_unit = arg_1_2.player.player_unit
	arg_1_0._mission_system = Managers.state.entity:system("mission_system")

	Managers.state.event:register(arg_1_0, "gm_event_round_started", "on_round_started")

	arg_1_0._parent = arg_1_1
	arg_1_0.ui_renderer = arg_1_2.ui_renderer
	arg_1_0.ingame_ui = arg_1_2.ingame_ui
	arg_1_0.input_manager = arg_1_2.input_manager
	arg_1_0.wwise_world = Managers.world:wwise_world(arg_1_0._world)
	arg_1_0._animations = {}
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}

	arg_1_0:create_ui_elements()

	if arg_1_0._has_curse then
		arg_1_0:show_curse_info(arg_1_0._theme, arg_1_0._curse)
	end
end

function DeusCurseUI.create_ui_elements(arg_2_0)
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	arg_2_0._description_widget = UIWidget.init(var_0_0.widget_definitions.description_widget)

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)

	arg_2_0.ui_animator = UIAnimator:new(arg_2_0.ui_scenegraph, var_0_1)
end

function DeusCurseUI.destroy(arg_3_0)
	Managers.state.event:unregister("gm_event_round_started", arg_3_0)

	arg_3_0.ui_animator = nil
end

function DeusCurseUI.update(arg_4_0, arg_4_1, arg_4_2)
	if not script_data.debug_enabled and not arg_4_0._has_curse then
		return
	end

	local var_4_0 = arg_4_0._timer

	if var_4_0 then
		local var_4_1 = var_4_0 - arg_4_1

		if var_4_1 > 0 then
			arg_4_0._timer = var_4_1
		else
			arg_4_0._timer = nil

			arg_4_0:on_timer_ended()
		end
	end

	if arg_4_0._has_curse and RESOLUTION_LOOKUP.modified and arg_4_0._timer ~= nil then
		arg_4_0:show_curse_info(arg_4_0._theme, arg_4_0._curse)
	end

	if arg_4_0._has_curse then
		arg_4_0:draw(arg_4_1)
		arg_4_0:update_animations(arg_4_1)
	end
end

function DeusCurseUI.on_timer_ended(arg_5_0)
	arg_5_0:_clear_animations()
	arg_5_0:_start_animation("curse_description_animation", "description_end")

	if not arg_5_0._player_unit then
		return
	end

	ScriptUnit.extension(arg_5_0._player_unit, "hud_system"):block_current_location_ui(false)
	arg_5_0._mission_system:block_mission_ui(false)
end

function DeusCurseUI.show_special_message(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	arg_6_0._timer = arg_6_4

	local var_6_0 = DeusThemeSettings[arg_6_1]
	local var_6_1 = var_6_0.curse_description_color
	local var_6_2 = var_6_0.icon or {
		255,
		255,
		255,
		255
	}
	local var_6_3 = var_6_0.curse_title and Localize(var_6_0.curse_title) or ""

	arg_6_2 = Localize(arg_6_2)
	arg_6_3 = Localize(arg_6_3)

	arg_6_0:_update_description_widget(var_6_3, arg_6_2, arg_6_3, var_6_2, var_6_1)
	arg_6_0:_start_animation("curse_description_animation", "description_start")

	arg_6_0._has_curse = true

	if not arg_6_0._player_unit then
		return
	end

	ScriptUnit.extension(arg_6_0._player_unit, "hud_system"):block_current_location_ui(true)
	arg_6_0._mission_system:block_mission_ui(true)
end

function DeusCurseUI.show_curse_info(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = Managers.state.game_mode:is_round_started()
	local var_7_1 = arg_7_0:_get_display_time()

	arg_7_0._timer = var_7_0 and var_7_1 or math.huge

	local var_7_2 = MutatorTemplates[arg_7_2]
	local var_7_3 = Localize(var_7_2.display_name)
	local var_7_4 = Localize(var_7_2.description)
	local var_7_5 = DeusThemeSettings[arg_7_1]
	local var_7_6 = var_7_5.curse_description_color
	local var_7_7 = var_7_5.icon or {
		255,
		255,
		255,
		255
	}
	local var_7_8 = var_7_5.curse_title and Localize(var_7_5.curse_title) or ""

	arg_7_0:_update_description_widget(var_7_8, var_7_3, var_7_4, var_7_7, var_7_6)
	arg_7_0:_start_animation("curse_description_animation", "description_start")

	arg_7_0._has_curse = true

	if not arg_7_0._player_unit then
		return
	end

	ScriptUnit.extension(arg_7_0._player_unit, "hud_system"):block_current_location_ui(true)
	arg_7_0._mission_system:block_mission_ui(true)
end

function DeusCurseUI._update_description_widget(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	local var_8_0 = arg_8_0._description_widget.content

	var_8_0.theme_icon = arg_8_4
	var_8_0.title_text = arg_8_1
	var_8_0.curse_name = arg_8_2
	var_8_0.area_text_content = arg_8_3

	local var_8_1 = UIUtils.get_text_height(arg_8_0.ui_renderer, {
		var_0_4,
		0
	}, arg_8_0._description_widget.style.area_text_style, arg_8_3)

	var_0_3.change_widget_height(var_8_1)

	local var_8_2 = arg_8_0._description_widget.style

	var_8_2.top_detail_glow.color = arg_8_5
	var_8_2.bottom_glow.color = arg_8_5
	var_8_2.bottom_edge_glow.color = arg_8_5
	var_8_2.top_glow.color = arg_8_5
	var_8_2.top_edge_glow.color = arg_8_5
end

function DeusCurseUI.on_round_started(arg_9_0)
	arg_9_0._timer = arg_9_0:_get_display_time()
end

function DeusCurseUI.draw(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.ui_renderer
	local var_10_1 = arg_10_0.ui_scenegraph
	local var_10_2 = arg_10_0.input_manager:get_service("ingame_menu")
	local var_10_3 = arg_10_0.render_settings

	UIRenderer.begin_pass(var_10_0, var_10_1, var_10_2, arg_10_1, nil, var_10_3)
	UIRenderer.draw_widget(var_10_0, arg_10_0._description_widget)
	UIRenderer.end_pass(var_10_0)
end

function DeusCurseUI._start_animation(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = {
		wwise_world = arg_11_0.wwise_world,
		render_settings = arg_11_0.render_settings
	}
	local var_11_1 = arg_11_0.ui_animator:start_animation(arg_11_2, arg_11_0._description_widget, var_0_2, var_11_0)

	arg_11_0._animations[arg_11_1] = var_11_1
end

function DeusCurseUI.update_animations(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0._animations
	local var_12_1 = arg_12_0.ui_animator

	var_12_1:update(arg_12_1)

	for iter_12_0, iter_12_1 in pairs(var_12_0) do
		if var_12_1:is_animation_completed(iter_12_1) then
			var_12_1:stop_animation(iter_12_1)

			var_12_0[iter_12_0] = nil
		end
	end
end

function DeusCurseUI._get_display_time(arg_13_0)
	return MutatorCommonSettings.deus.initial_activation_delay + var_0_5
end

function DeusCurseUI._clear_animations(arg_14_0)
	for iter_14_0, iter_14_1 in pairs(arg_14_0._animations) do
		arg_14_0.ui_animator:stop_animation(iter_14_1)
	end

	table.clear(arg_14_0._animations)
end
