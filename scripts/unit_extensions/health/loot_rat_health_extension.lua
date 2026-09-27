-- chunkname: @scripts/unit_extensions/health/loot_rat_health_extension.lua

LootRatHealthExtension = class(LootRatHealthExtension, GenericHealthExtension)

LootRatHealthExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	LootRatHealthExtension.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
end

LootRatHealthExtension.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local var_2_0 = BLACKBOARDS[arg_2_2]

	var_2_0.dodge_damage_points = var_2_0.breed.dodge_damage_points
	var_2_0.dodge_damage_success = false
end

LootRatHealthExtension.destroy = function (self)
	-- function 3
	LootRatHealthExtension.super.destroy(self)

	self.blackboard = nil
end

LootRatHealthExtension.apply_client_predicted_damage = function (arg_4_0, arg_4_1)
	-- function 4
	return
end

LootRatHealthExtension.add_damage = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9, arg_5_10, arg_5_11, arg_5_12, arg_5_13, arg_5_14, arg_5_15, arg_5_16, arg_5_17)
	-- function 5
	local var_5_0 = BLACKBOARDS[self.unit]
	local dodge_damage_points = var_5_0.dodge_damage_points
	local flag = false

	if not var_5_0.is_dodging then
		local max = math.max(dodge_damage_points - arg_5_2, 0)

		if max > 0 then
			flag = true
		end

		var_5_0.dodge_damage_points = max
	end

	if not flag then
		LootRatHealthExtension.super.add_damage(self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9, arg_5_10, arg_5_11, arg_5_12, arg_5_13, arg_5_14, arg_5_15, arg_5_16, arg_5_17)
	end

	var_5_0.dodge_damage_success = flag
end

LootRatHealthExtension.regen_dodge_damage_points = function (self)
	-- function 6
	local var_6_0 = BLACKBOARDS[self.unit]

	var_6_0.dodge_damage_points = var_6_0.breed.dodge_damage_points
end
