-- chunkname: @scripts/helpers/weapon_utils.lua

WeaponUtils = WeaponUtils or {}

WeaponUtils.add_bot_meta_data_chain_actions = function (arg_1_0, arg_1_1)
	for iter_1_0, iter_1_1 in pairs(arg_1_1) do
		for iter_1_2, iter_1_3 in pairs(iter_1_1) do
			local var_1_0 = iter_1_3.wanted_action_name
			local var_1_1 = iter_1_3.wanted_sub_action_name
			local var_1_2 = arg_1_0[iter_1_0][iter_1_2].allowed_chain_actions

			iter_1_3.chain_action = WeaponUtils.find_allowed_chain_action(var_1_2, iter_1_0, iter_1_2, var_1_0, var_1_1)
		end
	end
end

WeaponUtils.find_allowed_chain_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0
	local var_2_1 = #arg_2_0

	for iter_2_0 = 1, var_2_1 do
		local var_2_2 = arg_2_0[iter_2_0]

		if var_2_2.action == arg_2_3 and var_2_2.sub_action == arg_2_4 then
			var_2_0 = var_2_2

			break
		end
	end

	fassert(var_2_0 ~= nil, "Error: Couldn't find chain action from [%s-%s] to [%s-%s]", arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	return var_2_0
end

WeaponUtils.get_item_state_machine = function (arg_3_0, arg_3_1)
	return arg_3_0.state_machine_career and arg_3_0.state_machine_career[arg_3_1] or arg_3_0.state_machine
end

WeaponUtils.get_weapon_packages = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = {}
	local var_4_1 = arg_4_1.left_hand_unit

	if var_4_1 then
		if arg_4_2 then
			var_4_0[#var_4_0 + 1] = var_4_1
		end

		var_4_0[#var_4_0 + 1] = var_4_1 .. "_3p"

		local var_4_2 = arg_4_0.wwise_dep_left_hand

		if var_4_2 then
			for iter_4_0 = 1, #var_4_2 do
				local var_4_3 = var_4_2[iter_4_0]

				var_4_0[#var_4_0 + 1] = var_4_3
			end
		end
	end

	local var_4_4 = arg_4_1.right_hand_unit

	if var_4_4 then
		if arg_4_2 then
			var_4_0[#var_4_0 + 1] = var_4_4
		end

		var_4_0[#var_4_0 + 1] = var_4_4 .. "_3p"

		local var_4_5 = arg_4_0.wwise_dep_right_hand

		if var_4_5 then
			for iter_4_1 = 1, #var_4_5 do
				local var_4_6 = var_4_5[iter_4_1]

				var_4_0[#var_4_0 + 1] = var_4_6
			end
		end
	end

	local var_4_7 = arg_4_1.ammo_unit

	if var_4_7 then
		if arg_4_2 then
			var_4_0[#var_4_0 + 1] = var_4_7
		end

		var_4_0[#var_4_0 + 1] = arg_4_1.ammo_unit_3p or var_4_7 .. "_3p"

		local var_4_8 = arg_4_0.wwise_dep_ammo

		if var_4_8 then
			for iter_4_2 = 1, #var_4_8 do
				local var_4_9 = var_4_8[iter_4_2]

				var_4_0[#var_4_0 + 1] = var_4_9
			end
		end
	end

	if arg_4_2 and arg_4_0.load_state_machine ~= false then
		local var_4_10 = WeaponUtils.get_item_state_machine(arg_4_0, arg_4_3)

		if var_4_10 then
			var_4_0[#var_4_0 + 1] = var_4_10
		end
	end

	local var_4_11 = arg_4_0.required_projectile_unit_templates

	if var_4_11 then
		for iter_4_3, iter_4_4 in pairs(var_4_11) do
			local var_4_12 = iter_4_4 and ProjectileUnits[arg_4_1.projectile_units_template] or ProjectileUnits[iter_4_3]

			if var_4_12.projectile_unit_name then
				var_4_0[#var_4_0 + 1] = var_4_12.projectile_unit_name
			end

			if var_4_12.dummy_linker_unit_name then
				var_4_0[#var_4_0 + 1] = var_4_12.dummy_linker_unit_name
			end

			local var_4_13 = var_4_12.dummy_linker_broken_units

			if var_4_13 then
				for iter_4_5 = 1, #var_4_13 do
					var_4_0[#var_4_0 + 1] = var_4_13[iter_4_5]
				end
			end
		end
	end

	return var_4_0
end

WeaponUtils.get_used_actions = function (arg_5_0)
	local var_5_0 = {}
	local var_5_1 = {}
	local var_5_2 = {}

	for iter_5_0, iter_5_1 in pairs(arg_5_0.actions) do
		if iter_5_1.default then
			var_5_2[iter_5_0] = {}
			var_5_1[iter_5_0] = {}
			var_5_2[iter_5_0].default = true
		end
	end

	local var_5_3, var_5_4 = next(var_5_2)

	while var_5_3 ~= nil do
		local var_5_5 = next(var_5_4)

		while var_5_5 ~= nil do
			local var_5_6 = ActionUtils.resolve_action_selector(arg_5_0.actions[var_5_3][var_5_5]).allowed_chain_actions

			for iter_5_2 = 1, #var_5_6 do
				local var_5_7 = var_5_6[iter_5_2].action
				local var_5_8 = var_5_6[iter_5_2].sub_action

				if var_5_7 and var_5_8 then
					local var_5_9 = arg_5_0.actions[var_5_7]

					if var_5_9 and var_5_9[var_5_8] then
						if (not var_5_1[var_5_7] or not var_5_1[var_5_7][var_5_8]) and (not var_5_2[var_5_7] or not var_5_2[var_5_7][var_5_8]) then
							if not var_5_2[var_5_7] then
								var_5_2[var_5_7] = {}
							end

							var_5_2[var_5_7][var_5_8] = true
						end
					else
						if not var_5_0[var_5_7] then
							var_5_0[var_5_7] = {}
						end

						var_5_0[var_5_7][var_5_8] = true
					end
				end
			end

			var_5_2[var_5_3][var_5_5] = nil

			if not var_5_1[var_5_3] then
				var_5_1[var_5_3] = {}
			end

			var_5_1[var_5_3][var_5_5] = true
			var_5_5 = next(var_5_4)
		end

		var_5_2[var_5_3] = nil
		var_5_3, var_5_4 = next(var_5_2)
	end

	return var_5_1, var_5_0
end

WeaponUtils.is_valid_weapon_override = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0 and (arg_6_0.item_template_name or arg_6_0.item_template.name)

	return not arg_6_1.valid_templates_to_replace or arg_6_1.valid_templates_to_replace[var_6_0]
end

WeaponUtils.get_weapon_template = function (arg_7_0)
	return MechanismOverrides.get(rawget(Weapons, arg_7_0))
end
