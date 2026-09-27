-- chunkname: @scripts/ui/hud_ui/deus_soft_currency_indicator_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/deus_soft_currency_indicator_ui_definitions")

DeusSoftCurrencyIndicatorUI = class(DeusSoftCurrencyIndicatorUI)

DeusSoftCurrencyIndicatorUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._ui_renderer = arg_1_2.ui_renderer
	self._ingame_ui_context = arg_1_2

	self:_create_ui_elements()
end

DeusSoftCurrencyIndicatorUI._create_ui_elements = function (self)
	-- function 2
	self._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	self._cached_coin_count = nil
	self._animation_id = nil
	self._coin_widget = UIWidget.init(var_0_0.coin_widget_definition)
	self._ui_animator = UIAnimator:new(self._ui_scenegraph, var_0_0.animation_definitions)

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)
end

DeusSoftCurrencyIndicatorUI.play_animation = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local tbl = {
		from_coin_count = arg_3_2,
		to_coin_count = arg_3_3,
		coin_delta = arg_3_3 - arg_3_2
	}
	local num = 0

	self._animation_id = self._ui_animator:start_animation(arg_3_1, self._coin_widget, var_0_0.scenegraph_definition, tbl, nil, num)
end

DeusSoftCurrencyIndicatorUI._update_animations = function (self, arg_4_1)
	-- function 4
	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_4_1)

	local _animation_id = self._animation_id

	if not _animation_id and not _ui_animator:is_animation_completed(_animation_id) then
		self._animation_id = nil
	end
end

DeusSoftCurrencyIndicatorUI.set_visible = function (arg_5_0, arg_5_1)
	-- function 5
	return
end

DeusSoftCurrencyIndicatorUI._get_coins = function (arg_6_0)
	-- function 6
	local game_mechanism = Managers.mechanism:game_mechanism()

	if not (not game_mechanism and game_mechanism.get_deus_run_controller) then
		return 0
	end

	local get_deus_run_controller = game_mechanism:get_deus_run_controller()

	if not get_deus_run_controller then
		local get_own_peer_id = get_deus_run_controller:get_own_peer_id()

		return get_deus_run_controller:get_player_soft_currency(get_own_peer_id)
	else
		return Managers.backend:get_interface("deus"):get_rolled_over_soft_currency()
	end
end

DeusSoftCurrencyIndicatorUI.update = function (self, arg_7_1, arg_7_2)
	-- function 7
	local _get_coins = self:_get_coins()

	if not (self._animation_id or self._cached_coin_count == _get_coins) then
		if self._cached_coin_count ~= nil then
			self:play_animation("coin_change", self._cached_coin_count, _get_coins)
		else
			self._coin_widget.content.coin_count_text = math.floor(_get_coins)
		end

		self._cached_coin_count = _get_coins
	end

	self:_update_animations(arg_7_1)
	self:_draw(arg_7_1, arg_7_2)
end

DeusSoftCurrencyIndicatorUI._draw = function (self, arg_8_1, arg_8_2)
	-- function 8
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local get_service = Managers.input:get_service("ingame_menu")

	UIRenderer.begin_pass(_ui_renderer, self._ui_scenegraph, get_service, arg_8_1)
	UIRenderer.draw_widget(_ui_renderer, self._coin_widget)
	UIRenderer.end_pass(_ui_renderer)
end
