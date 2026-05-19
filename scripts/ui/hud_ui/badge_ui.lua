-- chunkname: @scripts/ui/hud_ui/badge_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/badge_ui_definitions")
local var_0_1 = var_0_0.badge_widget_definition
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions

BadgeUI = class(BadgeUI)

function BadgeUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0._ui_renderer = arg_1_2.ui_renderer
	arg_1_0._input_manager = arg_1_2.input_manager
	arg_1_0._player_manager = arg_1_2.player_manager
	arg_1_0._local_unique_id = arg_1_2.player:unique_id()
	arg_1_0._world = arg_1_2.world_manager:world("level_world")
	arg_1_0._wwise_world = arg_1_2.world_manager:wwise_world(arg_1_0._world)
	arg_1_0._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	arg_1_0._ingame_ui_context = arg_1_2
	arg_1_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)
	arg_1_0._ui_animator = UIAnimator:new(arg_1_0._ui_scenegraph, var_0_3)
	arg_1_0._has_active_badge = false
	arg_1_0._animations = {}
	arg_1_0._badges_queue = {}

	arg_1_0:_create_ui_elements()
	Managers.state.event:register(arg_1_0, "add_local_badge", "event_add_local_badge")
end

function BadgeUI.destroy(arg_2_0)
	GarbageLeakDetector.register_object(arg_2_0, "badge_ui")
	Managers.state.event:unregister("add_badge", arg_2_0)

	arg_2_0.ui_animator = nil
end

function BadgeUI._create_ui_elements(arg_3_0)
	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_renderer)

	arg_3_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)
	arg_3_0._badge_widget = UIWidget.init(var_0_1)
end

function BadgeUI.update(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0._animations
	local var_4_1 = arg_4_0._ui_animator

	var_4_1:update(arg_4_1)

	for iter_4_0, iter_4_1 in pairs(var_4_0) do
		local var_4_2 = iter_4_1.id

		if var_4_1:is_animation_completed(var_4_2) then
			var_4_1:stop_animation(var_4_2)
			arg_4_0:_remove_active_badge(iter_4_0)
			arg_4_0:_add_badge_from_queue()
		end
	end

	arg_4_0:_draw(arg_4_1)
end

function BadgeUI._draw(arg_5_0, arg_5_1)
	if not arg_5_0._has_active_badge then
		return
	end

	local var_5_0 = arg_5_0._ui_renderer
	local var_5_1 = arg_5_0._ui_scenegraph
	local var_5_2 = arg_5_0._input_manager:get_service("ingame_menu")
	local var_5_3 = arg_5_0._render_settings

	UIRenderer.begin_pass(var_5_0, var_5_1, var_5_2, arg_5_1, nil, var_5_3)
	UIRenderer.draw_widget(var_5_0, arg_5_0._badge_widget)
	UIRenderer.end_pass(var_5_0)
end

function BadgeUI._get_badge(arg_6_0, arg_6_1)
	local var_6_0 = NetworkLookup.badges[arg_6_1]
	local var_6_1 = BadgeDefinitions[var_6_0]

	fassert(var_6_1, "Unknown badge_id '%s'", arg_6_1)

	return var_6_1
end

function BadgeUI.event_add_local_badge(arg_7_0, arg_7_1)
	arg_7_0:add_badge(arg_7_0._local_unique_id .. "_" .. arg_7_1, arg_7_0:_get_badge(arg_7_1))
end

function BadgeUI.event_add_remote_player_badge(arg_8_0, arg_8_1, arg_8_2)
	arg_8_0:add_badge(arg_8_1 .. "_" .. arg_8_2, arg_8_0:_get_badge(arg_8_2))
end

function BadgeUI._add_to_queue(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0._badges_queue

	for iter_9_0, iter_9_1 in ipairs(var_9_0) do
		if iter_9_1.hash == arg_9_1 then
			iter_9_1.amount = iter_9_1.amount + 1

			return
		end
	end

	var_9_0[#var_9_0 + 1] = {
		amount = 1,
		hash = arg_9_1,
		badge = arg_9_2
	}
end

function BadgeUI.add_badge(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	arg_10_3 = arg_10_3 == nil and true or arg_10_3
	arg_10_4 = arg_10_4 == nil and 1 or arg_10_4

	if arg_10_3 and arg_10_0._has_active_badge then
		arg_10_0:_add_to_queue(arg_10_1, arg_10_2)

		return
	end

	arg_10_0._has_active_badge = true

	local var_10_0 = arg_10_0._badge_widget
	local var_10_1 = var_10_0.content
	local var_10_2 = arg_10_0._ui_renderer.gui

	Material.set_texture(Gui.material(var_10_2, "versus_badge_icon"), "diffuse_map", "gui/1080p/single_textures/carousel/badge_icons/" .. arg_10_2.texture_id .. "_icon")
	Material.set_texture(Gui.material(var_10_2, "versus_badge_glow"), "diffuse_map", "gui/1080p/single_textures/carousel/badge_icons/" .. arg_10_2.texture_id .. "_glow")

	var_10_0.style.frame_glow.color = arg_10_2.color
	var_10_0.style.icon_glow.color = arg_10_2.color
	var_10_1.text_name = arg_10_2.text
	var_10_1.text_desc = arg_10_2.description

	if arg_10_4 > 1 then
		var_10_1.text_name = var_10_1.text_name .. " x" .. arg_10_4
	end

	arg_10_0:_start_animation("on_enter", 1, var_10_0)
end

function BadgeUI._start_animation(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = {
		wwise_world = arg_11_0._wwise_world,
		render_settings = arg_11_0._render_settings,
		ui_scenegraph = arg_11_0._ui_scenegraph
	}
	local var_11_1 = arg_11_0._ui_animator:start_animation(arg_11_1, arg_11_3, var_0_2, var_11_0)

	arg_11_0._animations[arg_11_2] = {
		id = var_11_1,
		name = arg_11_1
	}
end

function BadgeUI._remove_active_badge(arg_12_0, arg_12_1)
	arg_12_0._animations[arg_12_1] = nil
	arg_12_0._has_active_badge = false
end

function BadgeUI._add_badge_from_queue(arg_13_0)
	if arg_13_0._has_active_badge then
		return
	end

	local var_13_0 = table.remove(arg_13_0._badges_queue, 1)

	if not var_13_0 then
		return
	end

	local var_13_1 = var_13_0.badge
	local var_13_2 = var_13_0.hash

	arg_13_0:add_badge(var_13_2, var_13_1, false, var_13_0.amount)
end
