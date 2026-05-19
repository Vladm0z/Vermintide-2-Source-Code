-- chunkname: @scripts/ui/hud_ui/base_component.lua

BaseComponent = class(BaseComponent)

function BaseComponent.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	assert(arg_1_3, "No definitions passed")
	assert(arg_1_3.scenegraph_definition, "No scenegraph in definitions")

	arg_1_0._world = arg_1_2.world
	arg_1_0._ui_renderer = arg_1_2.ui_renderer
	arg_1_0._ui_top_renderer = arg_1_2.ui_top_renderer
	arg_1_0._input_manager = arg_1_2.input_manager
	arg_1_0._ingame_ui_context = arg_1_2
	arg_1_0._definitions = arg_1_3
	arg_1_0._retained_mode = not not arg_1_3.retained_mode
	arg_1_0._dirty = true

	arg_1_0:_create_ui_elements()
end

function BaseComponent._create_ui_elements(arg_2_0)
	local var_2_0 = arg_2_0._definitions
	local var_2_1 = var_2_0.scenegraph_definition

	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_2_1)

	local var_2_2 = {}

	arg_2_0._widgets = UIUtils.create_widgets(var_2_0.widget_definitions, {}, var_2_2)

	local var_2_3 = var_2_0.top_widget_definitions

	if var_2_3 then
		arg_2_0._top_widgets = UIUtils.create_widgets(var_2_3, {}, var_2_2)
	end

	arg_2_0._widgets_by_name = var_2_2
end

function BaseComponent.destroy(arg_3_0)
	arg_3_0:_destroy_ui_elements()
end

function BaseComponent._destroy_ui_elements(arg_4_0)
	if arg_4_0._retained_mode then
		UIUtils.destroy_widgets(arg_4_0._ui_renderer, arg_4_0._widgets_by_name)
	end

	arg_4_0._widgets_by_name = nil
	arg_4_0._top_widgets = nil
	arg_4_0._widgets = nil
	arg_4_0._ui_scenegraph = nil
end

function BaseComponent.set_visible(arg_5_0, arg_5_1)
	if arg_5_0._retained_mode then
		local var_5_0 = arg_5_0._ui_renderer

		for iter_5_0, iter_5_1 in ipairs(arg_5_0._widgets) do
			UIRenderer.set_element_visible(var_5_0, iter_5_1.element, arg_5_1)
		end

		arg_5_0._dirty = true
	end
end

function BaseComponent.debug_set_definitions(arg_6_0, arg_6_1)
	arg_6_0._definitions = arg_6_1
end

function BaseComponent.update(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	return
end

function BaseComponent.post_update(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	if arg_8_0._dirty or not arg_8_0._retained_mode then
		arg_8_0:_draw(arg_8_1, arg_8_0:input_service())

		arg_8_0._dirty = false
	end
end

function BaseComponent._draw_widgets(arg_9_0, arg_9_1, arg_9_2)
	return
end

function BaseComponent._draw_top_widgets(arg_10_0, arg_10_1, arg_10_2)
	return
end

function BaseComponent._draw(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0._ui_renderer
	local var_11_1 = arg_11_0._ui_top_renderer
	local var_11_2 = arg_11_0._ui_scenegraph

	UIRenderer.begin_pass(var_11_0, var_11_2, arg_11_2, arg_11_1)
	UIRenderer.draw_all_widgets(var_11_0, arg_11_0._widgets)
	arg_11_0:_draw_widgets(var_11_0, arg_11_1)
	UIRenderer.end_pass(var_11_0)
	UIRenderer.begin_pass(var_11_1, var_11_2, arg_11_2, arg_11_1)

	if arg_11_0._top_widgets then
		UIRenderer.draw_all_widgets(var_11_1, arg_11_0._top_widgets)
	end

	arg_11_0:_draw_top_widgets(var_11_1, arg_11_1)
	UIRenderer.end_pass(var_11_1)
end

function BaseComponent.input_service(arg_12_0)
	return arg_12_0._input_manager:get_service("Player")
end

function BaseComponent._set_widget_dirty(arg_13_0, arg_13_1)
	arg_13_1.element.dirty = true
end
