-- chunkname: @scripts/ui/hud_ui/deus_soft_currency_indicator_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/deus_soft_currency_indicator_ui_definitions")

DeusSoftCurrencyIndicatorUI = class(DeusSoftCurrencyIndicatorUI)

DeusSoftCurrencyIndicatorUI.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._ui_renderer = arg_1_2.ui_renderer
	arg_1_0._ingame_ui_context = arg_1_2

	arg_1_0:_create_ui_elements()
end

DeusSoftCurrencyIndicatorUI._create_ui_elements = function (arg_2_0)
	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	arg_2_0._cached_coin_count = nil
	arg_2_0._animation_id = nil
	arg_2_0._coin_widget = UIWidget.init(var_0_0.coin_widget_definition)
	arg_2_0._ui_animator = UIAnimator:new(arg_2_0._ui_scenegraph, var_0_0.animation_definitions)

	UIRenderer.clear_scenegraph_queue(arg_2_0._ui_renderer)
end

DeusSoftCurrencyIndicatorUI.play_animation = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = {
		from_coin_count = arg_3_2,
		to_coin_count = arg_3_3,
		coin_delta = arg_3_3 - arg_3_2
	}
	local var_3_1 = 0

	arg_3_0._animation_id = arg_3_0._ui_animator:start_animation(arg_3_1, arg_3_0._coin_widget, var_0_0.scenegraph_definition, var_3_0, nil, var_3_1)
end

DeusSoftCurrencyIndicatorUI._update_animations = function (arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0._ui_animator

	var_4_0:update(arg_4_1)

	local var_4_1 = arg_4_0._animation_id

	if var_4_1 and var_4_0:is_animation_completed(var_4_1) then
		arg_4_0._animation_id = nil
	end
end

DeusSoftCurrencyIndicatorUI.set_visible = function (arg_5_0, arg_5_1)
	return
end

DeusSoftCurrencyIndicatorUI._get_coins = function (arg_6_0)
	local var_6_0 = Managers.mechanism:game_mechanism()

	if not var_6_0 or not var_6_0.get_deus_run_controller then
		return 0
	end

	local var_6_1 = var_6_0:get_deus_run_controller()

	if var_6_1 then
		local var_6_2 = var_6_1:get_own_peer_id()

		return var_6_1:get_player_soft_currency(var_6_2)
	else
		return Managers.backend:get_interface("deus"):get_rolled_over_soft_currency()
	end
end

DeusSoftCurrencyIndicatorUI.update = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0:_get_coins()

	if not arg_7_0._animation_id and arg_7_0._cached_coin_count ~= var_7_0 then
		if arg_7_0._cached_coin_count ~= nil then
			arg_7_0:play_animation("coin_change", arg_7_0._cached_coin_count, var_7_0)
		else
			arg_7_0._coin_widget.content.coin_count_text = math.floor(var_7_0)
		end

		arg_7_0._cached_coin_count = var_7_0
	end

	arg_7_0:_update_animations(arg_7_1)
	arg_7_0:_draw(arg_7_1, arg_7_2)
end

DeusSoftCurrencyIndicatorUI._draw = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0._ui_renderer
	local var_8_1 = arg_8_0._ui_scenegraph
	local var_8_2 = Managers.input:get_service("ingame_menu")

	UIRenderer.begin_pass(var_8_0, arg_8_0._ui_scenegraph, var_8_2, arg_8_1)
	UIRenderer.draw_widget(var_8_0, arg_8_0._coin_widget)
	UIRenderer.end_pass(var_8_0)
end
