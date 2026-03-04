-- chunkname: @scripts/settings/dlcs/morris/deus_swap_ranged_interaction_ui.lua

require("scripts/settings/dlcs/morris/deus_swap_weapon_interaction_ui")

DeusSwapRangedInteractionUI = class(DeusSwapRangedInteractionUI, DeusSwapWeaponInteractionUI)
DeusSwapRangedInteractionUI.TYPE = "swap_ranged"

function DeusSwapRangedInteractionUI.init(arg_1_0, arg_1_1, arg_1_2)
	DeusSwapRangedInteractionUI.super.init(arg_1_0, arg_1_1, arg_1_2)

	arg_1_0._type = "ranged"
end

function DeusSwapRangedInteractionUI.chest_unlock_failed(arg_2_0, arg_2_1)
	if arg_2_1 == DeusSwapRangedInteractionUI.TYPE then
		arg_2_0:_start_animation("chest_unlock_failed")
	end
end
