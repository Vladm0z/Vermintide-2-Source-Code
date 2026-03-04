-- chunkname: @scripts/unit_extensions/health/loot_rat_health_extension.lua

LootRatHealthExtension = class(LootRatHealthExtension, GenericHealthExtension)

LootRatHealthExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	LootRatHealthExtension.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
end

LootRatHealthExtension.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = BLACKBOARDS[arg_2_2]

	var_2_0.dodge_damage_points = var_2_0.breed.dodge_damage_points
	var_2_0.dodge_damage_success = false
end

LootRatHealthExtension.destroy = function (arg_3_0)
	LootRatHealthExtension.super.destroy(arg_3_0)

	arg_3_0.blackboard = nil
end

LootRatHealthExtension.apply_client_predicted_damage = function (arg_4_0, arg_4_1)
	return
end

LootRatHealthExtension.add_damage = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9, arg_5_10, arg_5_11, arg_5_12, arg_5_13, arg_5_14, arg_5_15, arg_5_16, arg_5_17)
	local var_5_0 = BLACKBOARDS[arg_5_0.unit]
	local var_5_1 = var_5_0.dodge_damage_points
	local var_5_2 = false

	if var_5_0.is_dodging then
		local var_5_3 = math.max(var_5_1 - arg_5_2, 0)

		if var_5_3 > 0 then
			var_5_2 = true
		end

		var_5_0.dodge_damage_points = var_5_3
	end

	if not var_5_2 then
		LootRatHealthExtension.super.add_damage(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9, arg_5_10, arg_5_11, arg_5_12, arg_5_13, arg_5_14, arg_5_15, arg_5_16, arg_5_17)
	end

	var_5_0.dodge_damage_success = var_5_2
end

LootRatHealthExtension.regen_dodge_damage_points = function (arg_6_0)
	local var_6_0 = BLACKBOARDS[arg_6_0.unit]

	var_6_0.dodge_damage_points = var_6_0.breed.dodge_damage_points
end
