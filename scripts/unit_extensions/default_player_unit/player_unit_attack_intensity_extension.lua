-- chunkname: @scripts/unit_extensions/default_player_unit/player_unit_attack_intensity_extension.lua

require("scripts/settings/attack_intensity_settings")

PlayerUnitAttackIntensityExtension = class(PlayerUnitAttackIntensityExtension)

local var_0_0 = 25

PlayerUnitAttackIntensityExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._network_manager = Managers.state.network
	arg_1_0._world = arg_1_1.world
	arg_1_0._unit = arg_1_2
	arg_1_0._attack_intensity = {}
	arg_1_0._attack_allowed = {}
	arg_1_0._attack_intensity_threshold = {}
	arg_1_0._attack_intensity_decay = {}
	arg_1_0._attack_intensity_decay_grace = {}
	arg_1_0._attack_intensity_reset = {}

	local var_1_0 = Managers.state.difficulty:get_difficulty_settings()
	local var_1_1 = AttackIntensitySettings.difficulty

	arg_1_0._attack_intensity_difficulty = Managers.state.difficulty:get_difficulty_value_from_table(var_1_1)

	arg_1_0:_setup_intensity()
end

PlayerUnitAttackIntensityExtension._setup_intensity = function (arg_2_0)
	for iter_2_0, iter_2_1 in pairs(AttackIntensitySettings.attack_type_intesities) do
		local var_2_0 = arg_2_0._attack_intensity_difficulty[iter_2_0]

		arg_2_0._attack_intensity[iter_2_0] = 0
		arg_2_0._attack_allowed[iter_2_0] = true
		arg_2_0._attack_intensity_threshold[iter_2_0] = var_2_0.threshold
		arg_2_0._attack_intensity_decay[iter_2_0] = var_2_0.decay
		arg_2_0._attack_intensity_decay_grace[iter_2_0] = 0
		arg_2_0._attack_intensity_reset[iter_2_0] = var_2_0.reset
	end
end

PlayerUnitAttackIntensityExtension.extensions_ready = function (arg_3_0, arg_3_1, arg_3_2)
	arg_3_0._buff_extension = ScriptUnit.extension(arg_3_2, "buff_system")
end

PlayerUnitAttackIntensityExtension.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	for iter_4_0, iter_4_1 in pairs(AttackIntensitySettings.attack_type_intesities) do
		local var_4_0 = arg_4_0._attack_intensity_decay_grace[iter_4_0]

		if var_4_0 > 0 then
			local var_4_1 = math.max(var_4_0 - arg_4_3, 0)

			arg_4_0._attack_intensity_decay_grace[iter_4_0] = var_4_1
		else
			local var_4_2 = arg_4_0._attack_intensity[iter_4_0]

			if var_4_2 > 0 then
				local var_4_3 = arg_4_0._attack_allowed[iter_4_0] and arg_4_0._attack_intensity_decay[iter_4_0] * 0.25 or arg_4_0._attack_intensity_decay[iter_4_0]
				local var_4_4 = arg_4_0._attack_intensity_threshold[iter_4_0]
				local var_4_5 = arg_4_0._attack_intensity_reset[iter_4_0]
				local var_4_6 = arg_4_0._buff_extension
				local var_4_7 = var_4_6:apply_buffs_to_value(var_4_3, "attack_intensity_decay")
				local var_4_8 = var_4_6:apply_buffs_to_value(var_4_4, "attack_intensity_threshold")
				local var_4_9 = var_4_6:apply_buffs_to_value(var_4_5, "attack_intensity_reset")
				local var_4_10 = math.max(var_4_2 - arg_4_3 * var_4_7 * var_4_8, 0)

				if var_4_8 < var_4_10 then
					arg_4_0._attack_allowed[iter_4_0] = false
				end

				if var_4_10 <= var_4_9 then
					arg_4_0._attack_allowed[iter_4_0] = true
				end

				arg_4_0._attack_intensity[iter_4_0] = var_4_10
			end
		end
	end
end

PlayerUnitAttackIntensityExtension.add_attack_intensity = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	fassert(AttackIntensitySettings.attack_type_intesities[arg_5_1], "No attack intesity settings defined for attack type \"%s\"", arg_5_1)

	arg_5_0._attack_intensity_decay_grace[arg_5_1] = arg_5_0._attack_intensity_difficulty[arg_5_1].decay_grace
	arg_5_0._attack_intensity[arg_5_1] = math.clamp(arg_5_0._attack_intensity[arg_5_1] + arg_5_2, 0, arg_5_3 or var_0_0)

	if arg_5_0._attack_intensity[arg_5_1] > arg_5_0._attack_intensity_threshold[arg_5_1] then
		arg_5_0._attack_allowed[arg_5_1] = false
	elseif not arg_5_0._attack_allowed[arg_5_1] and arg_5_0._attack_intensity[arg_5_1] < arg_5_0._attack_intensity_reset[arg_5_1] then
		arg_5_0._attack_allowed[arg_5_1] = true
	end
end

PlayerUnitAttackIntensityExtension.want_an_attack = function (arg_6_0, arg_6_1)
	fassert(AttackIntensitySettings.attack_type_intesities[arg_6_1], "No attack intesity settings defined for attack type \"%s\"", arg_6_1)

	return arg_6_0._attack_allowed[arg_6_1]
end
