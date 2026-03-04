-- chunkname: @scripts/helpers/talent_utils.lua

TalentUtils = {}
TalentUtils.NIL = {}

TalentUtils.get_talent = function (arg_1_0, arg_1_1)
	local var_1_0 = TalentIDLookup[arg_1_1]

	return TalentUtils.get_talent_by_id(arg_1_0, var_1_0.talent_id)
end

TalentUtils.get_talent_by_id = function (arg_2_0, arg_2_1)
	local var_2_0 = Talents[arg_2_0]

	if not var_2_0 then
		return nil
	end

	local var_2_1 = var_2_0[arg_2_1]

	if not var_2_1 then
		return nil
	end

	if var_2_1.mechanism_overrides then
		local var_2_2 = Managers.mechanism:current_mechanism_name()
		local var_2_3 = var_2_1.mechanism_overrides[var_2_2]

		if var_2_3 then
			var_2_1 = table.shallow_copy(var_2_1)

			for iter_2_0, iter_2_1 in pairs(var_2_3) do
				if iter_2_1 == TalentUtils.NIL then
					var_2_1[iter_2_0] = nil
				else
					var_2_1[iter_2_0] = iter_2_1
				end
			end
		end
	end

	return var_2_1
end

TalentUtils.get_talent_attribute = function (arg_3_0, arg_3_1)
	local var_3_0 = TalentIDLookup[arg_3_0]

	if not var_3_0 then
		return
	end

	local var_3_1 = var_3_0.hero_name
	local var_3_2 = var_3_0.talent_id
	local var_3_3 = Talents[var_3_1][var_3_2]

	if not var_3_3 then
		return nil
	end

	local var_3_4 = var_3_3.mechanism_overrides

	if var_3_4 then
		local var_3_5 = var_3_4[Managers.mechanism:current_mechanism_name()]

		if var_3_5 then
			local var_3_6 = var_3_5.attributes

			if var_3_6 then
				return var_3_6[arg_3_1]
			end
		end
	end

	local var_3_7 = var_3_3.attributes

	if var_3_7 then
		return var_3_7[arg_3_1]
	end
end
