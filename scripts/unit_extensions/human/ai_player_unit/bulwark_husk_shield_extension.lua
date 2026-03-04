-- chunkname: @scripts/unit_extensions/human/ai_player_unit/bulwark_husk_shield_extension.lua

require("scripts/unit_extensions/human/ai_player_unit/ai_shield_user_husk_extension")

BulwarkHuskShieldExtension = class(BulwarkHuskShieldExtension, AIShieldUserHuskExtension)

function BulwarkHuskShieldExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
end

function BulwarkHuskShieldExtension.destroy(arg_2_0)
	return
end

function BulwarkHuskShieldExtension.can_block_attack(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	return arg_3_0.super.can_block_attack(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
end

function BulwarkHuskShieldExtension.get_is_blocking(arg_4_0)
	return arg_4_0.super.get_is_blocking(arg_4_0)
end
