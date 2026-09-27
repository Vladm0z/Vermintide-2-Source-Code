-- chunkname: @scripts/settings/dlcs/morris/deus_upgrade_weapon_interaction_ui.lua

require("scripts/settings/dlcs/morris/deus_swap_weapon_interaction_ui")

DeusUpgradeWeaponInteractionUI = class(DeusUpgradeWeaponInteractionUI, DeusSwapWeaponInteractionUI)
DeusUpgradeWeaponInteractionUI.TYPE = "upgrade"

DeusUpgradeWeaponInteractionUI.init = function (arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	DeusUpgradeWeaponInteractionUI.super.init(arg_1_0, arg_1_1, arg_1_2)
end

DeusUpgradeWeaponInteractionUI.chest_unlock_failed = function (self, arg_2_1)
	-- function 2
	if arg_2_1 == DeusUpgradeWeaponInteractionUI.TYPE then
		self:_start_animation("chest_unlock_failed")
	end
end

DeusUpgradeWeaponInteractionUI._populate_widget = function (self, arg_3_1, arg_3_2)
	-- function 3
	local get_deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()

	if not get_deus_run_controller then
		return
	end

	local get_own_peer_id = get_deus_run_controller:get_own_peer_id()
	local get_player_soft_currency = get_deus_run_controller:get_player_soft_currency(get_own_peer_id)
	local extension = ScriptUnit.extension(arg_3_1, "pickup_system")

	extension:on_interact()

	local get_purchase_cost = extension:get_purchase_cost()
	local get_stored_purchase = extension:get_stored_purchase()

	if not get_stored_purchase then
		return
	end

	local flag = true
	local get_own_loadout, var_3_8 = get_deus_run_controller:get_own_loadout()
	local flag_2 = arg_3_2 ~= "slot_melee" or not get_own_loadout or var_3_8
	local RaritySettings = RaritySettings
	local flag_3 = RaritySettings[flag_2.rarity].order < RaritySettings[get_stored_purchase.rarity].order
	local weapon_tooltip = self._widgets_by_name.weapon_tooltip
	local chest_content = self._widgets_by_name.chest_content

	if not Managers.state.network.profile_synchronizer:others_actually_ingame() then
		weapon_tooltip.content.item = nil
		chest_content.content.show_coin_icon = false
		chest_content.content.rarity_text = nil
		chest_content.content.cost_text = nil
		chest_content.content.reward_info_text = nil
		chest_content.content.disabled_text = "reliquary_inactive_due_to_joining_player"
		self._calculate_offset = false
	elseif not flag_3 then
		weapon_tooltip.content.item = flag_2
		weapon_tooltip.content.force_equipped = true
		weapon_tooltip.style.item.draw_end_passes = true

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

		::label_3_0::

		cost_text.text_color = tbl

		local power_level = get_stored_purchase.power_level
		local flag_4

		flag_4 = arg_3_2 ~= "slot_melee" or not "melee" or "ranged"
		chest_content.content.reward_info_text = power_level .. " " .. Localize("deus_weapon_chest_" .. flag_4 .. "_weapon_description")
		chest_content.content.show_coin_icon = true
		chest_content.content.disabled_text = nil
		self._calculate_offset = true
	else
		weapon_tooltip.content.item = nil
		chest_content.content.show_coin_icon = false
		chest_content.content.rarity_text = nil
		chest_content.content.cost_text = nil
		chest_content.content.reward_info_text = nil
		chest_content.content.disabled_text = "reliquary_inactive_rarity"
		self._calculate_offset = false
	end

	self._current_interactable_unit = arg_3_1
	self._soft_currency_amount = get_player_soft_currency
	self._offset[1] = 0
	self._offset[2] = 0
	self._offset[3] = 0
end
