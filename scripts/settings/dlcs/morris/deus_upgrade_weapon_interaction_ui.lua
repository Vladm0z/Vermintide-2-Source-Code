-- chunkname: @scripts/settings/dlcs/morris/deus_upgrade_weapon_interaction_ui.lua

require("scripts/settings/dlcs/morris/deus_swap_weapon_interaction_ui")

DeusUpgradeWeaponInteractionUI = class(DeusUpgradeWeaponInteractionUI, DeusSwapWeaponInteractionUI)
DeusUpgradeWeaponInteractionUI.TYPE = "upgrade"

function DeusUpgradeWeaponInteractionUI.init(arg_1_0, arg_1_1, arg_1_2)
	DeusUpgradeWeaponInteractionUI.super.init(arg_1_0, arg_1_1, arg_1_2)
end

function DeusUpgradeWeaponInteractionUI.chest_unlock_failed(arg_2_0, arg_2_1)
	if arg_2_1 == DeusUpgradeWeaponInteractionUI.TYPE then
		arg_2_0:_start_animation("chest_unlock_failed")
	end
end

function DeusUpgradeWeaponInteractionUI._populate_widget(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = Managers.mechanism:game_mechanism():get_deus_run_controller()

	if not var_3_0 then
		return
	end

	local var_3_1 = var_3_0:get_own_peer_id()
	local var_3_2 = var_3_0:get_player_soft_currency(var_3_1)
	local var_3_3 = ScriptUnit.extension(arg_3_1, "pickup_system")

	var_3_3:on_interact()

	local var_3_4 = var_3_3:get_purchase_cost()
	local var_3_5 = var_3_3:get_stored_purchase()

	if not var_3_5 then
		return
	end

	local var_3_6 = true
	local var_3_7, var_3_8 = var_3_0:get_own_loadout()
	local var_3_9 = arg_3_2 == "slot_melee" and var_3_7 or var_3_8
	local var_3_10 = RaritySettings
	local var_3_11 = var_3_10[var_3_9.rarity].order < var_3_10[var_3_5.rarity].order
	local var_3_12 = arg_3_0._widgets_by_name.weapon_tooltip
	local var_3_13 = arg_3_0._widgets_by_name.chest_content

	if not Managers.state.network.profile_synchronizer:others_actually_ingame() then
		var_3_12.content.item = nil
		var_3_13.content.show_coin_icon = false
		var_3_13.content.rarity_text = nil
		var_3_13.content.cost_text = nil
		var_3_13.content.reward_info_text = nil
		var_3_13.content.disabled_text = "reliquary_inactive_due_to_joining_player"
		arg_3_0._calculate_offset = false
	elseif var_3_11 then
		var_3_12.content.item = var_3_9
		var_3_12.content.force_equipped = true
		var_3_12.style.item.draw_end_passes = true

		local var_3_14 = var_3_5.rarity
		local var_3_15 = Colors.get_table(var_3_14)

		var_3_13.content.rarity_text = RaritySettings[var_3_14].display_name
		var_3_13.style.rarity.text_color = var_3_15
		var_3_13.content.cost_text = var_3_2 .. "/" .. var_3_4
		var_3_13.style.cost_text.text_color = var_3_4 <= var_3_2 and {
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

		local var_3_16 = var_3_5.power_level
		local var_3_17 = arg_3_2 == "slot_melee" and "melee" or "ranged"

		var_3_13.content.reward_info_text = var_3_16 .. " " .. Localize("deus_weapon_chest_" .. var_3_17 .. "_weapon_description")
		var_3_13.content.show_coin_icon = true
		var_3_13.content.disabled_text = nil
		arg_3_0._calculate_offset = true
	else
		var_3_12.content.item = nil
		var_3_13.content.show_coin_icon = false
		var_3_13.content.rarity_text = nil
		var_3_13.content.cost_text = nil
		var_3_13.content.reward_info_text = nil
		var_3_13.content.disabled_text = "reliquary_inactive_rarity"
		arg_3_0._calculate_offset = false
	end

	arg_3_0._current_interactable_unit = arg_3_1
	arg_3_0._soft_currency_amount = var_3_2
	arg_3_0._offset[1] = 0
	arg_3_0._offset[2] = 0
	arg_3_0._offset[3] = 0
end
