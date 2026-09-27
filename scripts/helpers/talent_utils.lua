-- chunkname: @scripts/helpers/talent_utils.lua

TalentUtils = {}
TalentUtils.NIL = {}

TalentUtils.get_talent = function (arg_1_0, arg_1_1)
	-- function 1
	local var_1_0 = TalentIDLookup[arg_1_1]

	return TalentUtils.get_talent_by_id(arg_1_0, var_1_0.talent_id)
end

TalentUtils.get_talent_by_id = function (arg_2_0, arg_2_1)
	-- function 2
	local var_2_0 = Talents[arg_2_0]

	if not var_2_0 then
		return nil
	end

	local var_2_1 = var_2_0[arg_2_1]

	if not var_2_1 then
		return nil
	end

	if not var_2_1.mechanism_overrides then
		local current_mechanism_name = Managers.mechanism:current_mechanism_name()
		local var_2_3 = var_2_1.mechanism_overrides[current_mechanism_name]

		if not var_2_3 then
			var_2_1 = table.shallow_copy(var_2_1)

			for k, v in pairs(var_2_3) do
				if v == TalentUtils.NIL then
					var_2_1[k] = nil
				else
					var_2_1[k] = v
				end
			end
		end
	end

	return var_2_1
end

TalentUtils.get_talent_attribute = function (arg_3_0, arg_3_1)
	-- function 3
	local var_3_0 = TalentIDLookup[arg_3_0]

	if not var_3_0 then
		return
	end

	local hero_name = var_3_0.hero_name
	local talent_id = var_3_0.talent_id
	local var_3_3 = Talents[hero_name][talent_id]

	if not var_3_3 then
		return nil
	end

	local mechanism_overrides = var_3_3.mechanism_overrides

	if not mechanism_overrides then
		local var_3_5 = mechanism_overrides[Managers.mechanism:current_mechanism_name()]

		if not var_3_5 then
			local attributes = var_3_5.attributes

			if not attributes then
				return attributes[arg_3_1]
			end
		end
	end

	local attributes_2 = var_3_3.attributes

	if not attributes_2 then
		return attributes_2[arg_3_1]
	end
end
