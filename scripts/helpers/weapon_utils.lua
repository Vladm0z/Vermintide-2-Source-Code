-- chunkname: @scripts/helpers/weapon_utils.lua

local WeaponUtils = WeaponUtils

WeaponUtils = not not WeaponUtils or not not {}
WeaponUtils = WeaponUtils

WeaponUtils.add_bot_meta_data_chain_actions = function (actions, attack_chain_transitions)
	-- function 1
	for action_name, action_data in pairs(attack_chain_transitions) do
		for sub_action_name, sub_action_data in pairs(action_data) do
			local wanted_action_name = sub_action_data.wanted_action_name
			local wanted_sub_action_name = sub_action_data.wanted_sub_action_name
			local current_action_settings = actions[action_name][sub_action_name]
			local allowed_chain_actions = current_action_settings.allowed_chain_actions
			local chain_action = WeaponUtils.find_allowed_chain_action(allowed_chain_actions, action_name, sub_action_name, wanted_action_name, wanted_sub_action_name)

			sub_action_data.chain_action = chain_action
		end
	end
end

WeaponUtils.find_allowed_chain_action = function (allowed_chain_actions, action_name, sub_action_name, wanted_action_name, wanted_sub_action_name)
	-- function 2
	local found_chain_action
	local num_allowed_chain_actions = #allowed_chain_actions

	for i = 1, num_allowed_chain_actions do
		local chain_action = allowed_chain_actions[i]

		if chain_action.action == wanted_action_name and chain_action.sub_action == wanted_sub_action_name then
			found_chain_action = chain_action

			break
		end
	end

	fassert(found_chain_action ~= nil, "Error: Couldn't find chain action from [%s-%s] to [%s-%s]", action_name, sub_action_name, wanted_action_name, wanted_sub_action_name)

	return found_chain_action
end

WeaponUtils.get_item_state_machine = function (item_template, career_name)
	-- function 3
	local var_3_0

	if item_template.state_machine_career then
		var_3_0 = item_template.state_machine_career[career_name]

		if not var_3_0 then
			-- Nothing
		end
	end

	var_3_0 = item_template.state_machine

	::label_3_0::

	return var_3_0
end

WeaponUtils.get_weapon_packages = function (item_template, item_units, first_person, career_name)
	-- function 4
	local packages = {}
	local left_hand_unit_name = item_units.left_hand_unit

	if left_hand_unit_name then
		if first_person then
			packages[#packages + 1] = left_hand_unit_name
		end

		packages[#packages + 1] = left_hand_unit_name .. "_3p"

		local wwise_deps = item_template.wwise_dep_left_hand

		if wwise_deps then
			for i = 1, #wwise_deps do
				local wwise_dep = wwise_deps[i]

				packages[#packages + 1] = wwise_dep
			end
		end
	end

	local right_hand_unit_name = item_units.right_hand_unit

	if right_hand_unit_name then
		if first_person then
			packages[#packages + 1] = right_hand_unit_name
		end

		packages[#packages + 1] = right_hand_unit_name .. "_3p"

		local wwise_deps = item_template.wwise_dep_right_hand

		if wwise_deps then
			for i = 1, #wwise_deps do
				local wwise_dep = wwise_deps[i]

				packages[#packages + 1] = wwise_dep
			end
		end
	end

	local ammo_unit_name = item_units.ammo_unit

	if ammo_unit_name then
		if first_person then
			packages[#packages + 1] = ammo_unit_name
		end

		local num = #packages + 1
		local ammo_unit_3p = item_units.ammo_unit_3p

		ammo_unit_3p = not not ammo_unit_3p or not not (ammo_unit_name .. "_3p")
		packages[num] = ammo_unit_3p

		local wwise_deps = item_template.wwise_dep_ammo

		if wwise_deps then
			for i = 1, #wwise_deps do
				local wwise_dep = wwise_deps[i]

				packages[#packages + 1] = wwise_dep
			end
		end
	end

	if first_person and item_template.load_state_machine ~= false then
		local state_machine_name = WeaponUtils.get_item_state_machine(item_template, career_name)

		if state_machine_name then
			packages[#packages + 1] = state_machine_name
		end
	end

	local required_projectile_unit_templates = item_template.required_projectile_unit_templates

	if required_projectile_unit_templates then
		for projectile_units_template, use_skin in pairs(required_projectile_unit_templates) do
			local var_4_2

			if use_skin then
				var_4_2 = ProjectileUnits[item_units.projectile_units_template]

				if not var_4_2 then
					-- Nothing
				end
			end

			var_4_2 = ProjectileUnits[projectile_units_template]

			local projectile_units = var_4_2

			::label_4_0::

			if projectile_units.projectile_unit_name then
				packages[#packages + 1] = projectile_units.projectile_unit_name
			end

			if projectile_units.dummy_linker_unit_name then
				packages[#packages + 1] = projectile_units.dummy_linker_unit_name
			end

			local dummy_linker_broken_units = projectile_units.dummy_linker_broken_units

			if dummy_linker_broken_units then
				for broken_unit_package_idx = 1, #dummy_linker_broken_units do
					packages[#packages + 1] = dummy_linker_broken_units[broken_unit_package_idx]
				end
			end
		end
	end

	return packages
end

WeaponUtils.get_used_actions = function (template)
	-- function 5
	local missing_actions = {}
	local checked_actions = {}
	local pending_actions = {}

	for name, data in pairs(template.actions) do
		if data.default then
			pending_actions[name] = {}
			checked_actions[name] = {}
			pending_actions[name].default = true
		end
	end

	local action_to_check_n, action_to_check_v = next(pending_actions)

	while action_to_check_n ~= nil do
		local sub_action_to_check_n = next(action_to_check_v)

		while sub_action_to_check_n ~= nil do
			local sub_action = ActionUtils.resolve_action_selector(template.actions[action_to_check_n][sub_action_to_check_n])
			local chain_actions = sub_action.allowed_chain_actions

			for chain_action_id = 1, #chain_actions do
				local chain_action_name = chain_actions[chain_action_id].action
				local chain_sub_action_name = chain_actions[chain_action_id].sub_action

				if chain_action_name and chain_sub_action_name then
					local chain_action = template.actions[chain_action_name]
					local chain_sub_action = not not chain_action and not not chain_action[chain_sub_action_name]

					if chain_sub_action then
						if (not checked_actions[chain_action_name] or not checked_actions[chain_action_name][chain_sub_action_name]) and (not pending_actions[chain_action_name] or not pending_actions[chain_action_name][chain_sub_action_name]) then
							if not pending_actions[chain_action_name] then
								pending_actions[chain_action_name] = {}
							end

							pending_actions[chain_action_name][chain_sub_action_name] = true
						end
					else
						if not missing_actions[chain_action_name] then
							missing_actions[chain_action_name] = {}
						end

						missing_actions[chain_action_name][chain_sub_action_name] = true
					end
				end
			end

			pending_actions[action_to_check_n][sub_action_to_check_n] = nil

			if not checked_actions[action_to_check_n] then
				checked_actions[action_to_check_n] = {}
			end

			checked_actions[action_to_check_n][sub_action_to_check_n] = true
			sub_action_to_check_n = next(action_to_check_v)
		end

		pending_actions[action_to_check_n] = nil
		action_to_check_n, action_to_check_v = next(pending_actions)
	end

	return checked_actions, missing_actions
end

WeaponUtils.is_valid_weapon_override = function (source_slot_data, destination_item_data)
	-- function 6
	if source_slot_data then
		-- Nothing
	end

	::label_6_0::

	local item_template_name = source_slot_data.item_template_name

	if not item_template_name then
		-- Nothing
	end

	item_template_name = source_slot_data.item_template.name

	local source_slot_weapon_template = item_template_name

	::label_6_1::

	return not destination_item_data.valid_templates_to_replace or not not destination_item_data.valid_templates_to_replace[source_slot_weapon_template]
end

WeaponUtils.get_weapon_template = function (weapon_template_name)
	-- function 7
	return MechanismOverrides.get(rawget(Weapons, weapon_template_name))
end
