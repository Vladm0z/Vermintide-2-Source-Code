-- chunkname: @scripts/unit_extensions/human/ai_player_unit/bulwark_husk_shield_extension.lua

require("scripts/unit_extensions/human/ai_player_unit/ai_shield_user_husk_extension")

BulwarkHuskShieldExtension = class(BulwarkHuskShieldExtension, AIShieldUserHuskExtension)

BulwarkHuskShieldExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.super.init(self, arg_1_1, arg_1_2, arg_1_3)
end

BulwarkHuskShieldExtension.destroy = function (arg_2_0)
	-- function 2
	return
end

BulwarkHuskShieldExtension.can_block_attack = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	return self.super.can_block_attack(self, arg_3_1, arg_3_2, arg_3_3)
end

BulwarkHuskShieldExtension.get_is_blocking = function (self)
	-- function 4
	return self.super.get_is_blocking(self)
end
