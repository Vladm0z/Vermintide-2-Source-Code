-- chunkname: @scripts/unit_extensions/default_player_unit/charge/player_husk_overcharge_extension.lua

require("scripts/unit_extensions/default_player_unit/charge/overcharge_data")

PlayerHuskOverchargeExtension = class(PlayerHuskOverchargeExtension)

function PlayerHuskOverchargeExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.network_manager = Managers.state.network
	arg_1_0.unit = arg_1_2

	local var_1_0 = arg_1_3.overcharge_data

	arg_1_0.overcharge_value = 0
	arg_1_0.overcharge_threshold = 0
	arg_1_0.max_value = arg_1_3.overcharge_max_value
	arg_1_0.original_max_value = var_1_0.max_value or 40
	arg_1_0.overcharge_limit = arg_1_0.max_value * 0.65
	arg_1_0.overcharge_critical_limit = arg_1_0.max_value * 0.8
	arg_1_0._lerped_overcharge_fraction = 0
end

function PlayerHuskOverchargeExtension.extensions_ready(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.status_extension = ScriptUnit.extension(arg_2_2, "status_system")
end

function PlayerHuskOverchargeExtension.set_screen_particle_opacity_modifier(arg_3_0)
	return
end

function PlayerHuskOverchargeExtension.reset(arg_4_0)
	return
end

function PlayerHuskOverchargeExtension.destroy(arg_5_0)
	return
end

function PlayerHuskOverchargeExtension.set_animation_variable(arg_6_0)
	return
end

function PlayerHuskOverchargeExtension._update_game_object(arg_7_0)
	local var_7_0 = arg_7_0.network_manager
	local var_7_1 = arg_7_0.unit
	local var_7_2 = var_7_0:game()
	local var_7_3 = Managers.state.unit_storage:go_id(var_7_1)

	if var_7_2 and var_7_3 then
		local var_7_4 = GameSession.game_object_field(var_7_2, var_7_3, "overcharge_percentage")
		local var_7_5 = GameSession.game_object_field(var_7_2, var_7_3, "overcharge_threshold_percentage")
		local var_7_6 = GameSession.game_object_field(var_7_2, var_7_3, "overcharge_max_value")
		local var_7_7 = var_7_4 * var_7_6

		arg_7_0.overcharge_threshold, arg_7_0.overcharge_value = var_7_5 * var_7_6, var_7_7
		arg_7_0.max_value = var_7_6
		arg_7_0.overcharge_limit = var_7_6 * 0.65
		arg_7_0.overcharge_critical_limit = var_7_6 * 0.8
	end
end

function PlayerHuskOverchargeExtension.update(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	arg_8_0:_update_lerped_overcharge(arg_8_3)
	arg_8_0:_update_game_object()
end

function PlayerHuskOverchargeExtension.add_charge(arg_9_0)
	return
end

function PlayerHuskOverchargeExtension.remove_charge(arg_10_0)
	return
end

function PlayerHuskOverchargeExtension.hud_sound(arg_11_0)
	return
end

function PlayerHuskOverchargeExtension.get_overcharge_value(arg_12_0)
	return arg_12_0.overcharge_value
end

function PlayerHuskOverchargeExtension.is_above_critical_limit(arg_13_0)
	return arg_13_0.overcharge_value >= arg_13_0.overcharge_critical_limit
end

function PlayerHuskOverchargeExtension.get_max_value(arg_14_0)
	return arg_14_0.max_value
end

function PlayerHuskOverchargeExtension.get_original_max_value(arg_15_0)
	return arg_15_0.original_max_value
end

function PlayerHuskOverchargeExtension.get_overcharge_threshold(arg_16_0)
	return arg_16_0.overcharge_threshold
end

function PlayerHuskOverchargeExtension.above_overcharge_threshold(arg_17_0)
	return arg_17_0.overcharge_value >= arg_17_0.overcharge_threshold
end

function PlayerHuskOverchargeExtension.overcharge_fraction(arg_18_0)
	return arg_18_0.overcharge_value / arg_18_0.max_value
end

function PlayerHuskOverchargeExtension.lerped_overcharge_fraction(arg_19_0)
	return arg_19_0._lerped_overcharge_fraction
end

function PlayerHuskOverchargeExtension.threshold_fraction(arg_20_0)
	return arg_20_0.overcharge_threshold / arg_20_0.max_value
end

function PlayerHuskOverchargeExtension.current_overcharge_status(arg_21_0)
	local var_21_0 = arg_21_0:get_overcharge_value()
	local var_21_1 = arg_21_0:get_overcharge_threshold()
	local var_21_2 = arg_21_0:get_max_value()

	return var_21_0, var_21_1, var_21_2
end

function PlayerHuskOverchargeExtension.vent_overcharge(arg_22_0)
	return
end

function PlayerHuskOverchargeExtension.vent_overcharge_done(arg_23_0)
	return
end

function PlayerHuskOverchargeExtension.get_anim_blend_overcharge(arg_24_0)
	local var_24_0 = arg_24_0._lerped_overcharge_fraction * arg_24_0:get_max_value()
	local var_24_1 = arg_24_0.overcharge_threshold
	local var_24_2 = arg_24_0.max_value

	return (math.clamp((var_24_0 - var_24_1) / (var_24_2 - var_24_1), 0, 1))
end

function PlayerHuskOverchargeExtension._update_lerped_overcharge(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0:overcharge_fraction()
	local var_25_1 = arg_25_0._lerped_overcharge_fraction

	if var_25_0 == var_25_1 then
		return
	end

	local var_25_2 = 0.1
	local var_25_3 = 0.2
	local var_25_4 = 10
	local var_25_5 = 0.3
	local var_25_6 = math.abs(var_25_1 - var_25_0)

	if var_25_3 < var_25_6 then
		var_25_5 = var_25_5 * var_25_4
	elseif var_25_2 < var_25_6 then
		var_25_5 = var_25_5 * math.remap(var_25_2, var_25_3, 1, var_25_4, var_25_6)
	end

	local var_25_7 = math.min(var_25_1, var_25_0)
	local var_25_8 = math.max(var_25_1, var_25_0)
	local var_25_9 = var_25_1 + math.sign(var_25_0 - var_25_1) * var_25_5 * arg_25_1

	arg_25_0._lerped_overcharge_fraction = math.clamp(var_25_9, var_25_7, var_25_8)
end
