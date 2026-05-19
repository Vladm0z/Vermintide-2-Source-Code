-- chunkname: @scripts/settings/dlcs/morris/deus_swap_weapon_interaction_ui.lua

DeusSwapWeaponInteractionUI = class(DeusSwapWeaponInteractionUI)

local var_0_0 = local_require("scripts/settings/dlcs/morris/deus_swap_weapon_interaction_ui_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.widgets
local var_0_3 = var_0_0.animation_definitions

DeusSwapWeaponInteractionUI.TYPE = "swap_melee"

function DeusSwapWeaponInteractionUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0._ingame_ui_context = arg_1_2
	arg_1_0._ui_renderer = arg_1_2.ui_renderer
	arg_1_0._current_interactable_unit = nil
	arg_1_0._render_settings = {
		alpha_multiplier = 0
	}
	arg_1_0._animations = {}
	arg_1_0._type = "melee"
	arg_1_0._soft_currency_amount = nil
	arg_1_0._offset = {
		0,
		0,
		0
	}
	arg_1_0._calculate_offset = false

	arg_1_0:_create_ui_elements()
	Managers.state.event:register(arg_1_0, "chest_unlock_failed", "chest_unlock_failed")
end

function DeusSwapWeaponInteractionUI.destroy(arg_2_0)
	Managers.state.event:unregister("chest_unlock_failed", arg_2_0)
end

function DeusSwapWeaponInteractionUI.chest_unlock_failed(arg_3_0, arg_3_1)
	if arg_3_1 == DeusSwapWeaponInteractionUI.TYPE then
		arg_3_0:_start_animation("chest_unlock_failed")
	end
end

function DeusSwapWeaponInteractionUI._create_ui_elements(arg_4_0)
	UIRenderer.clear_scenegraph_queue(arg_4_0._ui_renderer)

	arg_4_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)
	arg_4_0._widgets_by_name = {}
	arg_4_0._widgets = {}

	for iter_4_0, iter_4_1 in pairs(var_0_2) do
		local var_4_0 = UIWidget.init(iter_4_1)

		arg_4_0._widgets[#arg_4_0._widgets + 1] = var_4_0
		arg_4_0._widgets_by_name[iter_4_0] = var_4_0
	end

	arg_4_0._ui_animator = UIAnimator:new(arg_4_0._ui_scenegraph, var_0_3)
	arg_4_0._current_interactable_unit = nil
end

function DeusSwapWeaponInteractionUI._evaluate_interactable(arg_5_0, arg_5_1)
	local var_5_0 = Managers.mechanism:game_mechanism()
	local var_5_1 = var_5_0.get_deus_run_controller and var_5_0:get_deus_run_controller()

	if not var_5_1 then
		return
	end

	local var_5_2 = ScriptUnit.has_extension(arg_5_1, "inventory_system")
	local var_5_3 = var_5_2 and var_5_2:get_wielded_slot_name()
	local var_5_4 = ScriptUnit.extension(arg_5_1, "interactor_system"):interactable_unit()
	local var_5_5 = Managers.state.network.profile_synchronizer:others_actually_ingame()
	local var_5_6 = arg_5_0._others_actually_ingame

	arg_5_0._others_actually_ingame = var_5_5

	if arg_5_0._current_interactable_unit ~= var_5_4 or var_5_6 ~= var_5_5 then
		arg_5_0:_populate_widget(var_5_4, var_5_3)
		arg_5_0:_start_animation("on_enter")
	else
		local var_5_7, var_5_8 = var_5_1:get_own_loadout()
		local var_5_9 = var_5_3 == "slot_melee" and "slot_melee" or "slot_ranged"
		local var_5_10 = not arg_5_0._weapon_slot_name or var_5_9 ~= arg_5_0._weapon_slot_name

		arg_5_0._weapon_slot_name = var_5_9

		local var_5_11 = var_5_1:get_own_peer_id()
		local var_5_12 = var_5_1:get_player_soft_currency(var_5_11)

		if var_5_10 or var_5_12 ~= arg_5_0._soft_currency_amount then
			arg_5_0:_populate_widget(var_5_4, var_5_3)
		end
	end
end

function DeusSwapWeaponInteractionUI._start_animation(arg_6_0, arg_6_1)
	arg_6_0._render_settings = arg_6_0._render_settings or {
		alpha_multiplier = 0
	}

	local var_6_0 = {
		render_settings = arg_6_0._render_settings
	}

	arg_6_0._animations[arg_6_1] = arg_6_0._ui_animator:start_animation(arg_6_1, arg_6_0._widgets, arg_6_0._ui_scenegraph, var_6_0, nil, 0)
end

function DeusSwapWeaponInteractionUI._populate_widget(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = Managers.mechanism:game_mechanism():get_deus_run_controller()

	if not var_7_0 then
		return
	end

	local var_7_1 = var_7_0:get_own_peer_id()
	local var_7_2 = var_7_0:get_player_soft_currency(var_7_1)
	local var_7_3 = ScriptUnit.extension(arg_7_1, "pickup_system")
	local var_7_4 = var_7_3:get_purchase_cost()
	local var_7_5 = var_7_3:get_stored_purchase()

	if not var_7_5 then
		return
	end

	local var_7_6, var_7_7 = var_7_0:get_own_loadout()
	local var_7_8 = arg_7_0._type == "melee" and var_7_6 or var_7_7
	local var_7_9 = arg_7_0._widgets_by_name.weapon_tooltip

	var_7_9.content.item = var_7_8
	var_7_9.style.item.draw_end_passes = true

	local var_7_10 = arg_7_0._widgets_by_name.chest_content
	local var_7_11 = var_7_5.rarity
	local var_7_12 = Colors.get_table(var_7_11)

	var_7_10.content.rarity_text = RaritySettings[var_7_11].display_name
	var_7_10.style.rarity.text_color = var_7_12
	var_7_10.content.cost_text = var_7_2 .. "/" .. var_7_4
	var_7_10.style.cost_text.text_color = var_7_4 <= var_7_2 and {
		255,
		255,
		255,
		255
	} or {
		255,
		255,
		0,
		0
	}

	local var_7_13 = var_7_5.power_level

	var_7_10.content.reward_info_text = var_7_13 .. " " .. Localize("deus_weapon_chest_" .. arg_7_0._type .. "_weapon_description")
	arg_7_0._current_interactable_unit = arg_7_1
	arg_7_0._soft_currency_amount = var_7_2

	if arg_7_0._others_actually_ingame then
		var_7_10.content.disabled_text = nil
		var_7_10.content.show_coin_icon = true
	else
		var_7_9.content.item = nil
		var_7_10.content.show_coin_icon = false
		var_7_10.content.rarity_text = nil
		var_7_10.content.cost_text = nil
		var_7_10.content.reward_info_text = nil
		var_7_10.content.disabled_text = "reliquary_inactive_due_to_joining_player"
	end

	arg_7_0._calculate_offset = true
end

function DeusSwapWeaponInteractionUI.update(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	arg_8_0:_evaluate_interactable(arg_8_1)
	arg_8_0:_update_animations(arg_8_2, arg_8_3)
	arg_8_0:_draw(arg_8_2, arg_8_3)
	arg_8_0:_update_offset(arg_8_2, arg_8_3)

	return arg_8_0._offset
end

function DeusSwapWeaponInteractionUI._update_offset(arg_9_0, arg_9_1, arg_9_2)
	if not arg_9_0._calculate_offset then
		return
	end

	local var_9_0 = arg_9_0._widgets_by_name.weapon_tooltip

	if not var_9_0 then
		return
	end

	local var_9_1 = var_9_0.style.item.item_presentation_height

	if not var_9_1 then
		print("[DeusSwapWeaponInteractionUI] Tried to calculate the item height to early. We require the tooltip to be rendered at least once before this can be calculated")

		return
	end

	arg_9_0._offset[2] = math.max(var_9_1 - 300, 0)
	arg_9_0._calculate_offset = false
end

function DeusSwapWeaponInteractionUI._update_animations(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0._ui_animator

	var_10_0:update(arg_10_1)

	local var_10_1 = arg_10_0._animations

	for iter_10_0, iter_10_1 in pairs(var_10_1) do
		if var_10_0:is_animation_completed(iter_10_1) then
			var_10_1[iter_10_0] = nil
		end
	end
end

function DeusSwapWeaponInteractionUI._draw(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0._ui_renderer
	local var_11_1 = arg_11_0._ui_scenegraph
	local var_11_2 = Managers.input:get_service("Player")
	local var_11_3 = arg_11_0._render_settings

	var_11_1.pivot.local_position = arg_11_0._offset

	UIRenderer.begin_pass(var_11_0, var_11_1, var_11_2, arg_11_1, nil, var_11_3)

	for iter_11_0 = 1, #arg_11_0._widgets do
		UIRenderer.draw_widget(var_11_0, arg_11_0._widgets[iter_11_0])
	end

	UIRenderer.end_pass(var_11_0)
end
