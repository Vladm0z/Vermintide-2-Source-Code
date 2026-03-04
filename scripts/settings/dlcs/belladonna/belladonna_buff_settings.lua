-- chunkname: @scripts/settings/dlcs/belladonna/belladonna_buff_settings.lua

local var_0_0 = DLCSettings.belladonna

var_0_0.buff_templates = {
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
var_0_0.buff_function_templates = {
	apply_invincibility_standard = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
		return
	end,
	update_invincibility_standard = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		QuickDrawer:sphere(POSITION_LOOKUP[arg_2_0], 1, Colors.get("cyan"))
	end,
	remove_invincibility_standard = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		if Managers.state.network.is_server then
			local var_3_0 = arg_3_1.stored_damage
			local var_3_1 = arg_3_1.standard_is_destroyed

			if var_3_0 and var_3_1 and HEALTH_ALIVE[arg_3_0] then
				local var_3_2 = ALIVE[arg_3_2.attacker_unit] and arg_3_2.attacker_unit or arg_3_0
				local var_3_3 = arg_3_1.armor_type
				local var_3_4 = "buff"
				local var_3_5 = var_3_0
				local var_3_6 = arg_3_1.damage_source

				arg_3_1.applied_damage = true

				DamageUtils.add_damage_network(arg_3_0, var_3_2, var_3_5, "torso", var_3_4, nil, Vector3(1, 0, 0), var_3_6, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
			end
		end
	end,
	apply_healing_standard = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
		arg_4_1.next_heal_tick_t = arg_4_2.t + 1

		Unit.flow_event(arg_4_0, "vfx_healing_buff")

		if Managers.state.network.is_server then
			local var_4_0 = ScriptUnit.extension(arg_4_0, "health_system")
			local var_4_1 = var_4_0:get_max_health()
			local var_4_2 = arg_4_1.template
			local var_4_3 = Managers.state.difficulty:get_difficulty()
			local var_4_4 = var_4_1 + var_4_2.heal_amounts[var_4_3] * 5

			var_4_0._damage_cap_per_hit = var_4_0:set_max_health(var_4_4)
		end
	end,
	update_healing_standard = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		if arg_5_2.t > arg_5_1.next_heal_tick_t then
			arg_5_1.next_heal_tick_t = arg_5_2.t + 1

			if Managers.state.network.is_server then
				local var_5_0 = ScriptUnit.has_extension(arg_5_0, "health_system")

				if var_5_0 then
					local var_5_1 = arg_5_1.template
					local var_5_2 = "leech"
					local var_5_3 = Managers.state.difficulty:get_difficulty()
					local var_5_4 = var_5_1.heal_amounts[var_5_3]
					local var_5_5 = DamageUtils.networkify_damage(var_5_4)

					var_5_0:add_heal(arg_5_0, var_5_5, nil, var_5_2)
				end
			end

			Unit.flow_event(arg_5_0, "vfx_healing_buff_proc")
		end
	end,
	remove_healing_standard = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		Unit.flow_event(arg_6_0, "vfx_remove_healing_buff")

		if Managers.state.network.is_server then
			local var_6_0 = ScriptUnit.extension(arg_6_0, "health_system")
			local var_6_1 = var_6_0:get_max_health()
			local var_6_2 = arg_6_1.template
			local var_6_3 = Managers.state.difficulty:get_difficulty()
			local var_6_4 = var_6_1 - var_6_2.heal_amounts[var_6_3] * 5

			var_6_0._damage_cap_per_hit = var_6_0:set_max_health(var_6_4)

			local var_6_5 = ALIVE[arg_6_2.attacker_unit] and arg_6_2.attacker_unit or arg_6_0
			local var_6_6 = "buff"
			local var_6_7 = 1
			local var_6_8 = arg_6_1.damage_source

			arg_6_1.applied_damage = true

			DamageUtils.add_damage_network(arg_6_0, var_6_5, var_6_7, "torso", var_6_6, nil, Vector3(1, 0, 0), var_6_8, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end
	end
}
