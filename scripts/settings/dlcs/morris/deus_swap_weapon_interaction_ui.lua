-- chunkname: @scripts/settings/dlcs/morris/deus_swap_weapon_interaction_ui.lua

DeusSwapWeaponInteractionUI = class(DeusSwapWeaponInteractionUI)

local var_0_0 = local_require("scripts/settings/dlcs/morris/deus_swap_weapon_interaction_ui_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local widgets = var_0_0.widgets
local animation_definitions = var_0_0.animation_definitions

DeusSwapWeaponInteractionUI.TYPE = "swap_melee"

DeusSwapWeaponInteractionUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self._ingame_ui_context = arg_1_2
	self._ui_renderer = arg_1_2.ui_renderer
	self._current_interactable_unit = nil
	self._render_settings = {
		alpha_multiplier = 0
	}
	self._animations = {}
	self._type = "melee"
	self._soft_currency_amount = nil
	self._offset = {
		0,
		0,
		0
	}
	self._calculate_offset = false

	self:_create_ui_elements()
	Managers.state.event:register(self, "chest_unlock_failed", "chest_unlock_failed")
end

DeusSwapWeaponInteractionUI.destroy = function (arg_2_0)
	-- function 2
	Managers.state.event:unregister("chest_unlock_failed", arg_2_0)
end

DeusSwapWeaponInteractionUI.chest_unlock_failed = function (self, arg_3_1)
	-- function 3
	if arg_3_1 == DeusSwapWeaponInteractionUI.TYPE then
		self:_start_animation("chest_unlock_failed")
	end
end

DeusSwapWeaponInteractionUI._create_ui_elements = function (self)
	-- function 4
	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._widgets_by_name = {}
	self._widgets = {}

	for k, v in pairs(widgets) do
		local var_4_0 = UIWidget.init(v)

		self._widgets[#self._widgets + 1] = var_4_0
		self._widgets_by_name[k] = var_4_0
	end

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)
	self._current_interactable_unit = nil
end

DeusSwapWeaponInteractionUI._evaluate_interactable = function (self, arg_5_1)
	-- function 5
	local game_mechanism = Managers.mechanism:game_mechanism()
	local get_deus_run_controller = game_mechanism.get_deus_run_controller

	get_deus_run_controller = not get_deus_run_controller and game_mechanism:get_deus_run_controller()

	if not get_deus_run_controller then
		return
	end

	local has_extension = ScriptUnit.has_extension(arg_5_1, "inventory_system")
	local flag = not has_extension and has_extension:get_wielded_slot_name()
	local interactable_unit = ScriptUnit.extension(arg_5_1, "interactor_system"):interactable_unit()
	local others_actually_ingame = Managers.state.network.profile_synchronizer:others_actually_ingame()
	local _others_actually_ingame = self._others_actually_ingame

	self._others_actually_ingame = others_actually_ingame

	if not (self._current_interactable_unit ~= interactable_unit or _others_actually_ingame == others_actually_ingame) then
		self:_populate_widget(interactable_unit, flag)
		self:_start_animation("on_enter")
	else
		local get_own_loadout, var_5_8 = get_deus_run_controller:get_own_loadout()
		local flag_2

		flag_2 = flag ~= "slot_melee" or not "slot_melee" or "slot_ranged"

		local flag_3 = not self._weapon_slot_name and flag_2 ~= self._weapon_slot_name

		self._weapon_slot_name = flag_2

		local get_own_peer_id = get_deus_run_controller:get_own_peer_id()
		local get_player_soft_currency = get_deus_run_controller:get_player_soft_currency(get_own_peer_id)

		if not (flag_3 or get_player_soft_currency == self._soft_currency_amount) then
			self:_populate_widget(interactable_unit, flag)
		end
	end
end

DeusSwapWeaponInteractionUI._start_animation = function (self, arg_6_1)
	-- function 6
	local _render_settings = self._render_settings

	_render_settings = _render_settings or {
		alpha_multiplier = 0
	}
	self._render_settings = _render_settings

	local tbl = {
		render_settings = self._render_settings
	}

	self._animations[arg_6_1] = self._ui_animator:start_animation(arg_6_1, self._widgets, self._ui_scenegraph, tbl, nil, 0)
end

DeusSwapWeaponInteractionUI._populate_widget = function (self, arg_7_1, arg_7_2)
	-- function 7
	local get_deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()

	if not get_deus_run_controller then
		return
	end

	local get_own_peer_id = get_deus_run_controller:get_own_peer_id()
	local get_player_soft_currency = get_deus_run_controller:get_player_soft_currency(get_own_peer_id)
	local extension = ScriptUnit.extension(arg_7_1, "pickup_system")
	local get_purchase_cost = extension:get_purchase_cost()
	local get_stored_purchase = extension:get_stored_purchase()

	if not get_stored_purchase then
		return
	end

	local get_own_loadout, var_7_7 = get_deus_run_controller:get_own_loadout()
	local flag = self._type ~= "melee" or not get_own_loadout or var_7_7
	local weapon_tooltip = self._widgets_by_name.weapon_tooltip

	weapon_tooltip.content.item = flag
	weapon_tooltip.style.item.draw_end_passes = true

	local chest_content = self._widgets_by_name.chest_content
	local rarity = get_stored_purchase.rarity
	local get_table = Colors.get_table(rarity)

	chest_content.content.rarity_text = RaritySettings[rarity].display_name
	chest_content.style.rarity.text_color = get_table
	chest_content.content.cost_text = get_player_soft_currency .. "/" .. get_purchase_cost

	local cost_text = chest_content.style.cost_text
	local tbl

	if get_purchase_cost <= get_player_soft_currency then
		tbl = {
			255,
			255,
			255,
			255
		}

		if not tbl then
			-- Nothing
		end
	end

	tbl = {
		255,
		255,
		0,
		0
	}

	::label_7_0::

	cost_text.text_color = tbl

	local power_level = get_stored_purchase.power_level

	chest_content.content.reward_info_text = power_level .. " " .. Localize("deus_weapon_chest_" .. self._type .. "_weapon_description")
	self._current_interactable_unit = arg_7_1
	self._soft_currency_amount = get_player_soft_currency

	if not self._others_actually_ingame then
		chest_content.content.disabled_text = nil
		chest_content.content.show_coin_icon = true
	else
		weapon_tooltip.content.item = nil
		chest_content.content.show_coin_icon = false
		chest_content.content.rarity_text = nil
		chest_content.content.cost_text = nil
		chest_content.content.reward_info_text = nil
		chest_content.content.disabled_text = "reliquary_inactive_due_to_joining_player"
	end

	self._calculate_offset = true
end

DeusSwapWeaponInteractionUI.update = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	self:_evaluate_interactable(arg_8_1)
	self:_update_animations(arg_8_2, arg_8_3)
	self:_draw(arg_8_2, arg_8_3)
	self:_update_offset(arg_8_2, arg_8_3)

	return self._offset
end

DeusSwapWeaponInteractionUI._update_offset = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not self._calculate_offset then
		return
	end

	local weapon_tooltip = self._widgets_by_name.weapon_tooltip

	if not weapon_tooltip then
		return
	end

	local item_presentation_height = weapon_tooltip.style.item.item_presentation_height

	if not item_presentation_height then
		print("[DeusSwapWeaponInteractionUI] Tried to calculate the item height to early. We require the tooltip to be rendered at least once before this can be calculated")

		return
	end

	self._offset[2] = math.max(item_presentation_height - 300, 0)
	self._calculate_offset = false
end

DeusSwapWeaponInteractionUI._update_animations = function (self, arg_10_1, arg_10_2)
	-- function 10
	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_10_1)

	local _animations = self._animations

	for k, v in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v) then
			_animations[k] = nil
		end
	end
end

DeusSwapWeaponInteractionUI._draw = function (self, arg_11_1, arg_11_2)
	-- function 11
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local get_service = Managers.input:get_service("Player")
	local _render_settings = self._render_settings

	_ui_scenegraph.pivot.local_position = self._offset

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, get_service, arg_11_1, nil, _render_settings)

	for i = 1, #self._widgets do
		UIRenderer.draw_widget(_ui_renderer, self._widgets[i])
	end

	UIRenderer.end_pass(_ui_renderer)
end
