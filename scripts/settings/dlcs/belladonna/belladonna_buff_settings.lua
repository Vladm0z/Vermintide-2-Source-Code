-- chunkname: @scripts/settings/dlcs/belladonna/belladonna_buff_settings.lua

local belladonna = DLCSettings.belladonna

belladonna.buff_templates = {
	invincibility_standard = {
		buffs = {
			{
				update_func = "update_invincibility_standard",
				name = "invincibility_standard",
				max_stacks = 1,
				remove_buff_func = "remove_invincibility_standard",
				apply_buff_func = "apply_invincibility_standard"
			}
		}
	},
	healing_standard = {
		buffs = {
			{
				update_func = "update_healing_standard",
				name = "healing_standard",
				max_stacks = 1,
				remove_buff_func = "remove_healing_standard",
				apply_buff_func = "apply_healing_standard",
				heal_amounts = {
					hardest = 8,
					hard = 3,
					harder = 6,
					versus_base = 2,
					cataclysm = 11,
					cataclysm_3 = 15,
					cataclysm_2 = 13,
					normal = 2
				}
			}
		}
	}
}
belladonna.buff_function_templates = {
	apply_invincibility_standard = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
		-- function 1
		return
	end,
	update_invincibility_standard = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		-- function 2
		QuickDrawer:sphere(POSITION_LOOKUP[arg_2_0], 1, Colors.get("cyan"))
	end,
	remove_invincibility_standard = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		-- function 3
		if not Managers.state.network.is_server then
			local stored_damage = arg_3_1.stored_damage
			local standard_is_destroyed = arg_3_1.standard_is_destroyed

			if not stored_damage and not standard_is_destroyed and not HEALTH_ALIVE[arg_3_0] then
				local attacker_unit

				if not ALIVE[arg_3_2.attacker_unit] then
					attacker_unit = arg_3_2.attacker_unit

					if not attacker_unit then
						-- Nothing
					end
				end

				attacker_unit = arg_3_0

				::label_3_0::

				local armor_type = arg_3_1.armor_type
				local str = "buff"
				local var_3_5 = stored_damage
				local damage_source = arg_3_1.damage_source

				arg_3_1.applied_damage = true

				DamageUtils.add_damage_network(arg_3_0, attacker_unit, var_3_5, "torso", str, nil, Vector3(1, 0, 0), damage_source, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
			end
		end
	end,
	apply_healing_standard = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
		-- function 4
		arg_4_1.next_heal_tick_t = arg_4_2.t + 1

		Unit.flow_event(arg_4_0, "vfx_healing_buff")

		if not Managers.state.network.is_server then
			local extension = ScriptUnit.extension(arg_4_0, "health_system")
			local get_max_health = extension:get_max_health()
			local template = arg_4_1.template
			local get_difficulty = Managers.state.difficulty:get_difficulty()
			local num = get_max_health + template.heal_amounts[get_difficulty] * 5

			extension._damage_cap_per_hit = extension:set_max_health(num)
		end
	end,
	update_healing_standard = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		-- function 5
		if arg_5_2.t > arg_5_1.next_heal_tick_t then
			arg_5_1.next_heal_tick_t = arg_5_2.t + 1

			if not Managers.state.network.is_server then
				local has_extension = ScriptUnit.has_extension(arg_5_0, "health_system")

				if not has_extension then
					local template = arg_5_1.template
					local str = "leech"
					local get_difficulty = Managers.state.difficulty:get_difficulty()
					local var_5_4 = template.heal_amounts[get_difficulty]
					local networkify_damage = DamageUtils.networkify_damage(var_5_4)

					has_extension:add_heal(arg_5_0, networkify_damage, nil, str)
				end
			end

			Unit.flow_event(arg_5_0, "vfx_healing_buff_proc")
		end
	end,
	remove_healing_standard = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		-- function 6
		Unit.flow_event(arg_6_0, "vfx_remove_healing_buff")

		if not Managers.state.network.is_server then
			local extension = ScriptUnit.extension(arg_6_0, "health_system")
			local get_max_health = extension:get_max_health()
			local template = arg_6_1.template
			local get_difficulty = Managers.state.difficulty:get_difficulty()
			local num = get_max_health - template.heal_amounts[get_difficulty] * 5

			extension._damage_cap_per_hit = extension:set_max_health(num)

			local attacker_unit

			if not ALIVE[arg_6_2.attacker_unit] then
				attacker_unit = arg_6_2.attacker_unit

				if not attacker_unit then
					-- Nothing
				end
			end

			attacker_unit = arg_6_0

			::label_6_0::

			local str = "buff"
			local num_2 = 1
			local damage_source = arg_6_1.damage_source

			arg_6_1.applied_damage = true

			DamageUtils.add_damage_network(arg_6_0, attacker_unit, num_2, "torso", str, nil, Vector3(1, 0, 0), damage_source, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end
	end
}
