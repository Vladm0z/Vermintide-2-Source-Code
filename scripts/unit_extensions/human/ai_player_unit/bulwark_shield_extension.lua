-- chunkname: @scripts/unit_extensions/human/ai_player_unit/bulwark_shield_extension.lua

require("scripts/unit_extensions/human/ai_player_unit/ai_shield_user_extension")

BulwarkShieldExtension = class(BulwarkShieldExtension, AIShieldUserExtension)

BulwarkShieldExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
end

BulwarkShieldExtension.destroy = function (arg_2_0)
	return
end

BulwarkShieldExtension.extensions_ready = function (arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.super.extensions_ready(arg_3_0, arg_3_1, arg_3_2)

	local var_3_0 = ScriptUnit.extension(arg_3_2, "ai_inventory_system")

	arg_3_0._wwise_world = Managers.world:wwise_world(arg_3_1)
	arg_3_0._world = arg_3_1
	arg_3_0._shield_unit = var_3_0.inventory_item_shield_unit
	arg_3_0._audio_system = Managers.state.entity:system("audio_system")
	arg_3_0._unit = arg_3_2
end

BulwarkShieldExtension.set_is_blocking = function (arg_4_0, arg_4_1)
	if arg_4_1 and arg_4_0._blackboard.reset_after_stagger then
		return
	end

	arg_4_0.super.set_is_blocking(arg_4_0, arg_4_1)
end

BulwarkShieldExtension.set_is_dodging = function (arg_5_0, arg_5_1)
	arg_5_0.super.set_is_dodging(arg_5_0, arg_5_1)
end

BulwarkShieldExtension.break_shield = function (arg_6_0)
	return
end

BulwarkShieldExtension.can_block_attack = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	return arg_7_0.super.can_block_attack(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
end

BulwarkShieldExtension.play_shield_hit_sfx = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	if not arg_8_0.is_blocking then
		return
	end

	arg_8_2 = arg_8_2 == 0 and 0.1 or arg_8_2

	local var_8_0 = math.clamp(arg_8_2 / arg_8_3, 0, 1)
	local var_8_1 = arg_8_1 and "Play_enemy_chaos_bulwark_stagger_break" or "Play_enemy_chaos_bulwark_stagger"
	local var_8_2 = "bulwark_stagger_amount"

	arg_8_0._audio_system:play_audio_unit_param_float_event(var_8_1, var_8_2, var_8_0, arg_8_0._unit)
end
