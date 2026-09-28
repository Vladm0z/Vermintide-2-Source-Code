-- chunkname: @scripts/unit_extensions/human/ai_player_unit/bulwark_husk_shield_extension.lua

require("scripts/unit_extensions/human/ai_player_unit/ai_shield_user_husk_extension")

BulwarkHuskShieldExtension = class(BulwarkHuskShieldExtension, AIShieldUserHuskExtension)

BulwarkHuskShieldExtension.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	self.super.init(self, extension_init_context, unit, extension_init_data)
end

BulwarkHuskShieldExtension.destroy = function (self)
	-- function 2
	return
end

BulwarkHuskShieldExtension.can_block_attack = function (self, attacker_unit, trueflight_blocking, hit_direction)
	-- function 3
	return self.super.can_block_attack(self, attacker_unit, trueflight_blocking, hit_direction)
end

BulwarkHuskShieldExtension.get_is_blocking = function (self)
	-- function 4
	return self.super.get_is_blocking(self)
end
