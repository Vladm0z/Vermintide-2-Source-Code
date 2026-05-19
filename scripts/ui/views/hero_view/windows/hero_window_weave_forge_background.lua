-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_weave_forge_background.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_background_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = false

HeroWindowWeaveForgeBackground = class(HeroWindowWeaveForgeBackground)
HeroWindowWeaveForgeBackground.NAME = "HeroWindowWeaveForgeBackground"

function HeroWindowWeaveForgeBackground.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowWeaveForgeBackground")

	arg_1_0._params = arg_1_1
	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._ingame_ui_context = var_1_0
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)

	local var_1_1 = arg_1_1.hero_name
	local var_1_2 = arg_1_1.career_index
	local var_1_3 = arg_1_1.profile_index

	arg_1_0._career_name = SPProfiles[var_1_3].careers[var_1_2].name
	arg_1_0._hero_name = var_1_1
end

function HeroWindowWeaveForgeBackground._setup_definitions(arg_2_0)
	if arg_2_0._parent:gamepad_style_active() then
		var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_background_console_definitions")
	else
		var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_background_definitions")
	end

	var_0_1 = var_0_0.widgets
	var_0_2 = var_0_0.scenegraph_definition
	var_0_3 = var_0_0.animation_definitions
end

function HeroWindowWeaveForgeBackground.create_ui_elements(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0:_setup_definitions()

	arg_3_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)

	local var_3_0 = {}
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in pairs(var_0_1) do
		local var_3_2 = UIWidget.init(iter_3_1)

		var_3_0[#var_3_0 + 1] = var_3_2
		var_3_1[iter_3_0] = var_3_2
	end

	arg_3_0._widgets = var_3_0
	arg_3_0._widgets_by_name = var_3_1
	arg_3_0._ui_animator = UIAnimator:new(arg_3_0._ui_scenegraph, var_0_3)

	if arg_3_2 then
		local var_3_3 = arg_3_0._ui_scenegraph.window.local_position

		var_3_3[1] = var_3_3[1] + arg_3_2[1]
		var_3_3[2] = var_3_3[2] + arg_3_2[2]
		var_3_3[3] = var_3_3[3] + arg_3_2[3]
	end

	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_renderer)
end

function HeroWindowWeaveForgeBackground.on_exit(arg_4_0, arg_4_1)
	print("[HeroViewWindow] Exit Substate HeroWindowWeaveForgeBackground")

	arg_4_0._ui_animator = nil
end

function HeroWindowWeaveForgeBackground.update(arg_5_0, arg_5_1, arg_5_2)
	if var_0_4 then
		var_0_4 = false

		arg_5_0:create_ui_elements()
	end

	arg_5_0:_update_animations(arg_5_1)
	arg_5_0:_draw(arg_5_1)
end

function HeroWindowWeaveForgeBackground.post_update(arg_6_0, arg_6_1, arg_6_2)
	return
end

function HeroWindowWeaveForgeBackground._update_animations(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._ui_animations
	local var_7_1 = arg_7_0._animations
	local var_7_2 = arg_7_0._ui_animator

	for iter_7_0, iter_7_1 in pairs(arg_7_0._ui_animations) do
		UIAnimation.update(iter_7_1, arg_7_1)

		if UIAnimation.completed(iter_7_1) then
			arg_7_0._ui_animations[iter_7_0] = nil
		end
	end

	var_7_2:update(arg_7_1)

	for iter_7_2, iter_7_3 in pairs(var_7_1) do
		if var_7_2:is_animation_completed(iter_7_3) then
			var_7_2:stop_animation(iter_7_3)

			var_7_1[iter_7_2] = nil
		end
	end
end

function HeroWindowWeaveForgeBackground._draw(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._parent:get_ui_renderer()
	local var_8_1 = arg_8_0._ui_scenegraph
	local var_8_2 = arg_8_0._parent:window_input_service()
	local var_8_3 = arg_8_0._render_settings

	UIRenderer.begin_pass(var_8_0, var_8_1, var_8_2, arg_8_1, nil, var_8_3)

	local var_8_4 = var_8_3.snap_pixel_positions
	local var_8_5 = var_8_3.alpha_multiplier

	for iter_8_0, iter_8_1 in ipairs(arg_8_0._widgets) do
		UIRenderer.draw_widget(var_8_0, iter_8_1)
	end

	UIRenderer.end_pass(var_8_0)
end
