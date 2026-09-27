-- chunkname: @scripts/settings/dlcs/morris/deus_swap_ranged_interaction_ui.lua

require("scripts/settings/dlcs/morris/deus_swap_weapon_interaction_ui")

DeusSwapRangedInteractionUI = class(DeusSwapRangedInteractionUI, DeusSwapWeaponInteractionUI)
DeusSwapRangedInteractionUI.TYPE = "swap_ranged"

DeusSwapRangedInteractionUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	DeusSwapRangedInteractionUI.super.init(self, arg_1_1, arg_1_2)

	self._type = "ranged"
end

DeusSwapRangedInteractionUI.chest_unlock_failed = function (self, arg_2_1)
	-- function 2
	if arg_2_1 == DeusSwapRangedInteractionUI.TYPE then
		self:_start_animation("chest_unlock_failed")
	end
end
