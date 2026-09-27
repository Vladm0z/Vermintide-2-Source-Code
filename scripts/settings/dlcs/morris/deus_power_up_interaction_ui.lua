-- chunkname: @scripts/settings/dlcs/morris/deus_power_up_interaction_ui.lua

require("scripts/settings/dlcs/morris/deus_swap_weapon_interaction_ui")

DeusPowerUpInteractionUI = class(DeusPowerUpInteractionUI, DeusSwapWeaponInteractionUI)
DeusPowerUpInteractionUI.TYPE = "power_up"

DeusPowerUpInteractionUI.init = function (arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	DeusPowerUpInteractionUI.super.init(arg_1_0, arg_1_1, arg_1_2)
end

DeusPowerUpInteractionUI.chest_unlock_failed = function (self, arg_2_1)
	-- function 2
	if arg_2_1 == DeusPowerUpInteractionUI.TYPE then
		self:_start_animation("chest_unlock_failed")
	end
end

DeusPowerUpInteractionUI._populate_widget = function (self, arg_3_1)
	-- function 3
	local get_deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()

	if not get_deus_run_controller then
		return
	end

	local get_own_peer_id = get_deus_run_controller:get_own_peer_id()
	local get_player_soft_currency = get_deus_run_controller:get_player_soft_currency(get_own_peer_id)
	local extension = ScriptUnit.extension(arg_3_1, "pickup_system")
	local get_purchase_cost = extension:get_purchase_cost()
	local get_stored_purchase = extension:get_stored_purchase()

	if not get_stored_purchase then
		return
	end

	local chest_content = self._widgets_by_name.chest_content

	chest_content.content.rarity_text = nil
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

	chest_content.content.reward_info_text = Localize("deus_weapon_chest_upgrade_description")
	self._current_interactable_unit = arg_3_1
	self._soft_currency_amount = get_player_soft_currency
end
