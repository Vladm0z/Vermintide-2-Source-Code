-- chunkname: @scripts/unit_extensions/human/ai_player_unit/bulwark_shield_extension.lua

require("scripts/unit_extensions/human/ai_player_unit/ai_shield_user_extension")

BulwarkShieldExtension = class(BulwarkShieldExtension, AIShieldUserExtension)

BulwarkShieldExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.super.init(self, arg_1_1, arg_1_2, arg_1_3)
end

BulwarkShieldExtension.destroy = function (arg_2_0)
	-- function 2
	return
end

BulwarkShieldExtension.extensions_ready = function (self, arg_3_1, arg_3_2)
	-- function 3
	self.super.extensions_ready(self, arg_3_1, arg_3_2)

	local extension = ScriptUnit.extension(arg_3_2, "ai_inventory_system")

	self._wwise_world = Managers.world:wwise_world(arg_3_1)
	self._world = arg_3_1
	self._shield_unit = extension.inventory_item_shield_unit
	self._audio_system = Managers.state.entity:system("audio_system")
	self._unit = arg_3_2
end

BulwarkShieldExtension.set_is_blocking = function (self, arg_4_1)
	-- function 4
	if not arg_4_1 and not self._blackboard.reset_after_stagger then
		return
	end

	self.super.set_is_blocking(self, arg_4_1)
end

BulwarkShieldExtension.set_is_dodging = function (self, arg_5_1)
	-- function 5
	self.super.set_is_dodging(self, arg_5_1)
end

BulwarkShieldExtension.break_shield = function (arg_6_0)
	-- function 6
	return
end

BulwarkShieldExtension.can_block_attack = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	return self.super.can_block_attack(self, arg_7_1, arg_7_2, arg_7_3)
end

BulwarkShieldExtension.play_shield_hit_sfx = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	if not self.is_blocking then
		return
	end

	arg_8_2 = arg_8_2 ~= 0 or not 0.1 or arg_8_2

	local clamp = math.clamp(arg_8_2 / arg_8_3, 0, 1)
	local flag

	flag = not arg_8_1 and "Play_enemy_chaos_bulwark_stagger_break" and "Play_enemy_chaos_bulwark_stagger"

	local str = "bulwark_stagger_amount"

	self._audio_system:play_audio_unit_param_float_event(flag, str, clamp, self._unit)
end
