-- chunkname: @scripts/helpers/weapon_utils.lua

local WeaponUtils = WeaponUtils

WeaponUtils = WeaponUtils or {}
WeaponUtils = WeaponUtils

WeaponUtils.add_bot_meta_data_chain_actions = function (self, arg_1_1)
	-- function 1
	for k, v in pairs(arg_1_1) do
		for k_2, v_2 in pairs(v) do
			local wanted_action_name = v_2.wanted_action_name
			local wanted_sub_action_name = v_2.wanted_sub_action_name
			local allowed_chain_actions = self[k][k_2].allowed_chain_actions

			v_2.chain_action = WeaponUtils.find_allowed_chain_action(allowed_chain_actions, k, k_2, wanted_action_name, wanted_sub_action_name)
		end
	end
end

WeaponUtils.find_allowed_chain_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	local var_2_0
	local count = #self

	for i = 1, count do
		local var_2_2 = self[i]

		if not (var_2_2.action ~= arg_2_3 or var_2_2.sub_action ~= arg_2_4) then
			var_2_0 = var_2_2

			break
		end
	end

	fassert(var_2_0 ~= nil, "Error: Couldn't find chain action from [%s-%s] to [%s-%s]", arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	return var_2_0
end

WeaponUtils.get_item_state_machine = function (self, arg_3_1)
	-- function 3
	local var_3_0

	if not self.state_machine_career then
		var_3_0 = self.state_machine_career[arg_3_1]

		if not var_3_0 then
			-- Nothing
		end
	end

	var_3_0 = self.state_machine

	::label_3_0::

	return var_3_0
end

WeaponUtils.get_weapon_packages = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local tbl = {}
	local left_hand_unit = arg_4_1.left_hand_unit

	if not left_hand_unit then
		if not arg_4_2 then
			tbl[#tbl + 1] = left_hand_unit
		end

		tbl[#tbl + 1] = left_hand_unit .. "_3p"

		local wwise_dep_left_hand = self.wwise_dep_left_hand

		if not wwise_dep_left_hand then
			for i = 1, #wwise_dep_left_hand do
				local var_4_3 = wwise_dep_left_hand[i]

				tbl[#tbl + 1] = var_4_3
			end
		end
	end

	local right_hand_unit = arg_4_1.right_hand_unit

	if not right_hand_unit then
		if not arg_4_2 then
			tbl[#tbl + 1] = right_hand_unit
		end

		tbl[#tbl + 1] = right_hand_unit .. "_3p"

		local wwise_dep_right_hand = self.wwise_dep_right_hand

		if not wwise_dep_right_hand then
			for j = 1, #wwise_dep_right_hand do
				local var_4_6 = wwise_dep_right_hand[j]

				tbl[#tbl + 1] = var_4_6
			end
		end
	end

	local ammo_unit = arg_4_1.ammo_unit

	if not ammo_unit then
		if not arg_4_2 then
			tbl[#tbl + 1] = ammo_unit
		end

		local num = #tbl + 1
		local ammo_unit_3p = arg_4_1.ammo_unit_3p

		ammo_unit_3p = ammo_unit_3p or ammo_unit .. "_3p"
		tbl[num] = ammo_unit_3p

		local wwise_dep_ammo = self.wwise_dep_ammo

		if not wwise_dep_ammo then
			for k = 1, #wwise_dep_ammo do
				local var_4_11 = wwise_dep_ammo[k]

				tbl[#tbl + 1] = var_4_11
			end
		end
	end

	if not (not arg_4_2 and self.load_state_machine == false) then
		local get_item_state_machine = WeaponUtils.get_item_state_machine(self, arg_4_3)

		if not get_item_state_machine then
			tbl[#tbl + 1] = get_item_state_machine
		end
	end

	local required_projectile_unit_templates = self.required_projectile_unit_templates

	if not required_projectile_unit_templates then
		for k_2, v in pairs(required_projectile_unit_templates) do
			local var_4_14

			if not v then
				var_4_14 = ProjectileUnits[arg_4_1.projectile_units_template]

				if not var_4_14 then
					-- Nothing
				end
			end

			var_4_14 = ProjectileUnits[k_2]

			::label_4_0::

			if not var_4_14.projectile_unit_name then
				tbl[#tbl + 1] = var_4_14.projectile_unit_name
			end

			if not var_4_14.dummy_linker_unit_name then
				tbl[#tbl + 1] = var_4_14.dummy_linker_unit_name
			end

			local dummy_linker_broken_units = var_4_14.dummy_linker_broken_units

			if not dummy_linker_broken_units then
				for i5 = 1, #dummy_linker_broken_units do
					tbl[#tbl + 1] = dummy_linker_broken_units[i5]
				end
			end
		end
	end

	return tbl
end

WeaponUtils.get_used_actions = function (self)
	-- function 5
	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}

	for k, v in pairs(self.actions) do
		if not v.default then
			tbl_3[k] = {}
			tbl_2[k] = {}
			tbl_3[k].default = true
		end
	end

	local var_5_3, var_5_4 = next(tbl_3)

	while var_5_3 ~= nil do
		local var_5_5 = next(var_5_4)

		while var_5_5 ~= nil do
			local allowed_chain_actions = ActionUtils.resolve_action_selector(self.actions[var_5_3][var_5_5]).allowed_chain_actions

			for k_2 = 1, #allowed_chain_actions do
				local action = allowed_chain_actions[k_2].action
				local sub_action = allowed_chain_actions[k_2].sub_action

				if not action and not sub_action then
					local var_5_9 = self.actions[action]

					if not (not var_5_9 and var_5_9[sub_action]) then
						if not (not tbl_2[action] and tbl_2[action][sub_action] and not tbl_3[action] or tbl_3[action][sub_action]) then
							if not tbl_3[action] then
								tbl_3[action] = {}
							end

							tbl_3[action][sub_action] = true
						end
					else
						if not tbl[action] then
							tbl[action] = {}
						end

						tbl[action][sub_action] = true
					end
				end
			end

			tbl_3[var_5_3][var_5_5] = nil

			if not tbl_2[var_5_3] then
				tbl_2[var_5_3] = {}
			end

			tbl_2[var_5_3][var_5_5] = true
			var_5_5 = next(var_5_4)
		end

		tbl_3[var_5_3] = nil
		var_5_3, var_5_4 = next(tbl_3)
	end

	return tbl_2, tbl
end

WeaponUtils.is_valid_weapon_override = function (self, arg_6_1)
	-- function 6
	if not self then
		-- Nothing
	end

	::label_6_0::

	local item_template_name = self.item_template_name

	item_template_name = item_template_name or self.item_template.name

	::label_6_1::

	return not arg_6_1.valid_templates_to_replace and arg_6_1.valid_templates_to_replace[item_template_name]
end

WeaponUtils.get_weapon_template = function (arg_7_0)
	-- function 7
	return MechanismOverrides.get(rawget(Weapons, arg_7_0))
end
