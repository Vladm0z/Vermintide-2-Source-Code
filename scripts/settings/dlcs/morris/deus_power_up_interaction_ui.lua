-- chunkname: @scripts/settings/dlcs/morris/deus_power_up_interaction_ui.lua

require("scripts/settings/dlcs/morris/deus_swap_weapon_interaction_ui")

DeusPowerUpInteractionUI = class(DeusPowerUpInteractionUI, DeusSwapWeaponInteractionUI)
DeusPowerUpInteractionUI.TYPE = "power_up"

DeusPowerUpInteractionUI.init = function (arg_1_0, arg_1_1, arg_1_2)
	DeusPowerUpInteractionUI.super.init(arg_1_0, arg_1_1, arg_1_2)
end

DeusPowerUpInteractionUI.chest_unlock_failed = function (arg_2_0, arg_2_1)
	if arg_2_1 == DeusPowerUpInteractionUI.TYPE then
		arg_2_0:_start_animation("chest_unlock_failed")
	end
end

DeusPowerUpInteractionUI._populate_widget = function (arg_3_0, arg_3_1)
	local var_3_0 = Managers.mechanism:game_mechanism():get_deus_run_controller()

	if not var_3_0 then
		return
	end

	local var_3_1 = var_3_0:get_own_peer_id()
	local var_3_2 = var_3_0:get_player_soft_currency(var_3_1)
	local var_3_3 = ScriptUnit.extension(arg_3_1, "pickup_system")
	local var_3_4 = var_3_3:get_purchase_cost()
	local var_3_5 = var_3_3:get_stored_purchase()

	if not var_3_5 then
		return
	end

	local var_3_6 = arg_3_0._widgets_by_name.chest_content

	var_3_6.content.rarity_text = nil
	var_3_6.content.cost_text = var_3_2 .. "/" .. var_3_4
	var_3_6.style.cost_text.text_color = var_3_4 <= var_3_2 and {
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

	local var_3_7 = var_3_5.power_level

	var_3_6.content.reward_info_text = Localize("deus_weapon_chest_upgrade_description")
	arg_3_0._current_interactable_unit = arg_3_1
	arg_3_0._soft_currency_amount = var_3_2
end
