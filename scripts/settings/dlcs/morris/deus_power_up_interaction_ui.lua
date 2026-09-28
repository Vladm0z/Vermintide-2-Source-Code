-- chunkname: @scripts/settings/dlcs/morris/deus_power_up_interaction_ui.lua

require("scripts/settings/dlcs/morris/deus_swap_weapon_interaction_ui")

DeusPowerUpInteractionUI = class(DeusPowerUpInteractionUI, DeusSwapWeaponInteractionUI)
DeusPowerUpInteractionUI.TYPE = "power_up"

DeusPowerUpInteractionUI.init = function (self, parent, ingame_ui_context)
	-- function 1
	DeusPowerUpInteractionUI.super.init(self, parent, ingame_ui_context)
end

DeusPowerUpInteractionUI.chest_unlock_failed = function (self, chest_type)
	-- function 2
	if chest_type == DeusPowerUpInteractionUI.TYPE then
		self:_start_animation("chest_unlock_failed")
	end
end

DeusPowerUpInteractionUI._populate_widget = function (self, interactable_unit)
	-- function 3
	local mechanism = Managers.mechanism:game_mechanism()
	local deus_run_controller = mechanism:get_deus_run_controller()

	if not deus_run_controller then
		return
	end

	local peer_id = deus_run_controller:get_own_peer_id()
	local soft_currency_amount = deus_run_controller:get_player_soft_currency(peer_id)
	local pickup_ext = ScriptUnit.extension(interactable_unit, "pickup_system")
	local cost = pickup_ext:get_purchase_cost()
	local stored_purchase = pickup_ext:get_stored_purchase()

	if not stored_purchase then
		return
	end

	local chest_info_widget = self._widgets_by_name.chest_content

	chest_info_widget.content.rarity_text = nil
	chest_info_widget.content.cost_text = soft_currency_amount .. "/" .. cost

	local cost_text = chest_info_widget.style.cost_text
	local tbl

	if cost <= soft_currency_amount then
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

	local power_level = stored_purchase.power_level

	chest_info_widget.content.reward_info_text = Localize("deus_weapon_chest_upgrade_description")
	self._current_interactable_unit = interactable_unit
	self._soft_currency_amount = soft_currency_amount
end
