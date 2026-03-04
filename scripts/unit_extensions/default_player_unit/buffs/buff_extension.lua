-- chunkname: @scripts/unit_extensions/default_player_unit/buffs/buff_extension.lua

require("scripts/helpers/pseudo_random_distribution")
dofile("scripts/settings/bpc")

local var_0_0 = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_functions")
local var_0_1 = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")

script_data.buff_debug = script_data.buff_debug or Development.parameter("buff_debug")

local function var_0_2(...)
	if script_data.debug_synced_buffs then
		print(...)
	end
end

BuffExtension = class(BuffExtension)
buff_extension_function_params = buff_extension_function_params or Script.new_map(15)

local var_0_3 = {
	removed = true
}

BuffExtension.init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0._unit = arg_2_2
	arg_2_0.world = arg_2_1.world
	arg_2_0._breed = arg_2_3.breed
	arg_2_0._initial_buff_names = arg_2_3.initial_buff_names
	arg_2_0._buffs = {}
	arg_2_0._num_buffs = 0
	arg_2_0._stat_buffs = {}
	arg_2_0._event_buffs = {}
	arg_2_0._event_buffs_index = 1
	arg_2_0._any_buff_removed = false
	arg_2_0._deactivation_sounds = {}
	arg_2_0._deactivation_sounds_3p = {}
	arg_2_0._continuous_screen_effects = {}
	arg_2_0._deactivation_screen_effects = {}
	arg_2_0._vfx = {}
	arg_2_0._vfx_update = {}

	for iter_2_0, iter_2_1 in pairs(StatBuffApplicationMethods) do
		arg_2_0._stat_buffs[iter_2_0] = {}
	end

	for iter_2_2 = 1, #ProcEvents do
		local var_2_0 = ProcEvents[iter_2_2]

		arg_2_0._event_buffs[var_2_0] = {}
	end

	arg_2_0.is_server = Managers.player.is_server

	local var_2_1 = arg_2_3.breed and arg_2_3.breed.is_player

	arg_2_0.is_local = not var_2_1 and arg_2_0.is_server or var_2_1 and not arg_2_3.is_husk
	arg_2_0.is_husk = arg_2_3.is_husk
	arg_2_0.id = 1
	arg_2_0.individual_stat_buff_index = 1
	arg_2_0._prd_states = {}
	arg_2_0._perks = {}
	arg_2_0._buff_id_refs = {}
	arg_2_0._stacking_buffs = {}
	arg_2_0.reset_material_cache = nil
end

BuffExtension.extensions_ready = function (arg_3_0, arg_3_1, arg_3_2)
	arg_3_0:_activate_initial_buffs()

	local var_3_0 = Unit.get_data(arg_3_2, "breed")

	if not var_3_0 or not var_3_0.is_player then
		return
	end

	if var_3_0.is_hero then
		local var_3_1 = Managers.state.entity:system("buff_system"):get_player_group_buffs()
		local var_3_2 = #var_3_1

		if var_3_2 > 0 then
			for iter_3_0 = 1, var_3_2 do
				local var_3_3 = var_3_1[iter_3_0]
				local var_3_4 = var_3_3.group_buff_template_name
				local var_3_5 = GroupBuffTemplates[var_3_4].buff_per_instance

				var_3_3.recipients[arg_3_2] = arg_3_0:add_buff(var_3_5)
			end
		end
	end

	if arg_3_0._num_buffs > 0 then
		Managers.state.entity:system("buff_system"):set_buff_ext_active(arg_3_0._unit, true)
	end

	arg_3_0.debug_buff_names = {}
end

BuffExtension.destroy = function (arg_4_0)
	arg_4_0:clear()
end

BuffExtension.freeze = function (arg_5_0)
	arg_5_0:clear()

	arg_5_0._ai_frozen = true
end

BuffExtension.unfreeze = function (arg_6_0)
	arg_6_0._ai_frozen = nil
end

BuffExtension.clear = function (arg_7_0)
	local var_7_0 = arg_7_0._buffs
	local var_7_1 = Managers.time:time("game")
	local var_7_2 = buff_extension_function_params

	var_7_2.t = var_7_1
	var_7_2.end_time = var_7_1

	for iter_7_0 = 1, arg_7_0._num_buffs do
		local var_7_3 = var_7_0[iter_7_0]

		if not var_7_3.removed then
			var_7_2.bonus = var_7_3.bonus
			var_7_2.multiplier = var_7_3.multiplier
			var_7_2.value = var_7_3.value
			var_7_2.attacker_unit = var_7_3.attacker_unit
			var_7_2.source_attacker_unit = var_7_3.source_attacker_unit

			arg_7_0:_remove_sub_buff(var_7_3, iter_7_0, var_7_2, false)
		end
	end

	table.clear(var_7_0)
	table.clear(arg_7_0._perks)
	table.clear(arg_7_0._buff_id_refs)
	table.clear(arg_7_0._stacking_buffs)

	arg_7_0._num_buffs = 0
	arg_7_0._id_to_local_sync = nil
	arg_7_0._local_sync_to_id = nil
	arg_7_0._synced_buff_owner = nil
	arg_7_0._buff_to_sync_type = nil
	arg_7_0._id_to_server_sync = nil
	arg_7_0._server_sync_to_id = nil
	arg_7_0._remove_buff_queue = nil

	if arg_7_0._shared_buff_units then
		for iter_7_1, iter_7_2 in pairs(arg_7_0._shared_buff_units) do
			if ALIVE[iter_7_2] then
				Managers.state.unit_spawner:mark_for_deletion(iter_7_2)
			end
		end

		arg_7_0._shared_buff_units = nil
	end

	Managers.state.entity:system("buff_system"):set_buff_ext_active(arg_7_0._unit, false)
end

BuffExtension.add_buff = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0._unit

	if FROZEN[var_8_0] or arg_8_0._ai_frozen then
		return
	end

	local var_8_1 = arg_8_0._buffs
	local var_8_2 = BuffUtils.get_buff_template(arg_8_1)
	local var_8_3 = var_8_2.buffs
	local var_8_4 = arg_8_2 and arg_8_2._hot_join_sync_buff_age or 0
	local var_8_5 = Managers.time:time("game") - var_8_4
	local var_8_6 = arg_8_0:claim_buff_id(arg_8_1)
	local var_8_7 = arg_8_0.world
	local var_8_8 = arg_8_0.is_server
	local var_8_9
	local var_8_10 = var_8_2.create_parent_buff_shared_table and {}
	local var_8_11 = 0

	for iter_8_0 = 1, #var_8_3 do
		local var_8_12 = var_8_3[iter_8_0]
		local var_8_13 = var_8_12.apply_condition

		if var_8_13 and not var_8_13(var_8_0, var_8_12, arg_8_2) then
			-- Nothing
		else
			local var_8_14 = var_8_12.duration
			local var_8_15 = var_8_12.ticks
			local var_8_16 = var_8_12.update_frequency
			local var_8_17 = var_8_12.max_stacks_func and var_8_12.max_stacks_func(arg_8_0._unit, var_8_12) or var_8_12.max_stacks
			local var_8_18 = var_8_17
			local var_8_19 = var_8_12.bonus
			local var_8_20 = var_8_12.value
			local var_8_21 = var_8_12.multiplier
			local var_8_22 = var_8_12.proc_chance
			local var_8_23 = var_8_12.proc_cooldown
			local var_8_24 = var_8_12.range
			local var_8_25
			local var_8_26
			local var_8_27
			local var_8_28

			if arg_8_2 then
				local var_8_29 = arg_8_2.variable_value

				if var_8_29 then
					local var_8_30 = var_8_12.variable_bonus

					if var_8_30 then
						var_8_19 = var_8_30[var_8_29 == 1 and #var_8_30 or 1 + math.floor(var_8_29 / (1 / #var_8_30))]
					end

					local var_8_31 = var_8_12.variable_bonus_max

					if var_8_31 then
						var_8_19 = math.lerp(0, var_8_31, var_8_29)
					end

					local var_8_32 = var_8_12.variable_multiplier

					if var_8_32 then
						local var_8_33 = var_8_32[1]
						local var_8_34 = var_8_32[2]

						var_8_21 = math.lerp(var_8_33, var_8_34, var_8_29)
					end

					local var_8_35 = var_8_12.variable_multiplier_max

					if var_8_35 then
						var_8_21 = math.lerp(0, var_8_35, var_8_29)
					end
				end

				var_8_19 = arg_8_2.external_optional_bonus or var_8_19
				var_8_21 = arg_8_2.external_optional_multiplier or var_8_21
				var_8_20 = arg_8_2.external_optional_value or var_8_20
				var_8_22 = arg_8_2.external_optional_proc_chance or var_8_22
				var_8_14 = arg_8_2.external_optional_duration or var_8_14
				var_8_15 = arg_8_2.external_optional_ticks or var_8_15
				var_8_24 = arg_8_2.external_optional_range or var_8_24
				var_8_25 = arg_8_2.damage_source or var_8_25
				var_8_26 = arg_8_2.power_level or var_8_26
				var_8_27 = arg_8_2.attacker_unit or var_8_27
				var_8_28 = arg_8_2.source_attacker_unit or var_8_28
			end

			if var_8_12.duration_modifier_func then
				var_8_14, var_8_15 = var_8_12.duration_modifier_func(var_8_0, var_8_12, var_8_14, arg_8_0, arg_8_2)
			end

			local var_8_36 = var_8_12.perks

			if var_8_36 and table.find(var_8_36, var_0_1.burning_balefire) then
				local var_8_37 = var_8_28 or var_8_27
				local var_8_38 = ScriptUnit.has_extension(var_8_37, "buff_system")

				if var_8_38 and not Managers.state.side:is_ally(var_8_0, var_8_37) then
					local var_8_39 = var_8_38:apply_buffs_to_value(1, "increased_balefire_dot_duration")

					var_8_14 = var_8_14 and var_8_14 * var_8_39
					var_8_15 = var_8_15 and math.floor(var_8_15 * var_8_39)
					var_8_16 = var_8_16 and var_8_16 * var_8_39
				end
			end

			local var_8_40 = var_8_14 and var_8_5 + var_8_14

			if var_8_18 and not arg_8_0:_add_stacking_buff(var_8_12, var_8_17, var_8_5, var_8_14, var_8_40, arg_8_2) then
				-- Nothing
			else
				local var_8_41 = var_8_12.refresh_duration_of_buffs_on_apply

				if var_8_41 then
					for iter_8_1 = 1, #var_8_41 do
						local var_8_42 = var_8_41[iter_8_1]
						local var_8_43 = arg_8_0:get_stacking_buff(var_8_42)

						if var_8_43 then
							for iter_8_2 = 1, #var_8_43 do
								local var_8_44 = var_8_43[iter_8_2]

								arg_8_0:_refresh_duration(var_8_44, var_8_5, var_8_44.duration, var_8_5 + var_8_44.duration, arg_8_2, var_8_44.template)
							end
						else
							local var_8_45 = arg_8_0:get_buff_type(var_8_42)

							if var_8_45 then
								arg_8_0:_refresh_duration(var_8_45, var_8_5, var_8_45.duration, var_8_5 + var_8_45.duration, arg_8_2, var_8_45.template)
							end
						end
					end
				end

				local var_8_46 = {
					id = var_8_6,
					start_time = var_8_5,
					template = var_8_12,
					buff_type = var_8_12.name,
					buff_template_name = arg_8_1,
					bonus = var_8_19,
					multiplier = var_8_21,
					value = var_8_20,
					proc_chance = var_8_22,
					proc_cooldown = var_8_23,
					duration = var_8_14,
					ticks = var_8_15,
					current_ticks = var_8_15 and 0 or nil,
					update_frequency = var_8_16,
					range = var_8_24,
					damage_source = var_8_25,
					power_level = var_8_26,
					attacker_unit = var_8_27,
					source_attacker_unit = var_8_28,
					max_stacks = var_8_17,
					parent_buff_shared_table = var_8_10
				}

				var_8_9 = var_8_9 or var_8_46
				arg_8_0._num_buffs = arg_8_0._num_buffs + 1
				var_8_1[arg_8_0._num_buffs] = var_8_46
				var_8_11 = var_8_11 + 1

				if var_8_18 then
					local var_8_47 = arg_8_0._stacking_buffs[var_8_12.name]

					if not var_8_47 then
						var_8_47 = {}
						arg_8_0._stacking_buffs[var_8_12.name] = var_8_47

						local var_8_48 = StackingBuffFunctions[var_8_12.on_stack_buff_first_add]

						if var_8_48 then
							var_8_48(arg_8_0._unit, var_8_12, arg_8_2)
						end
					end

					var_8_47[#var_8_47 + 1] = var_8_46
				end

				if var_8_36 then
					for iter_8_3 = 1, #var_8_36 do
						local var_8_49 = var_8_36[iter_8_3]
						local var_8_50 = arg_8_0._perks[var_8_49] or 0

						if var_8_50 == 0 then
							local var_8_51 = var_0_0[var_8_49]

							if var_8_51 and var_8_51.added then
								var_8_51.added(arg_8_0, var_8_0, var_8_46, var_8_8)
							end
						end

						arg_8_0._perks[var_8_49] = var_8_50 + 1
					end
				end

				if var_8_12.buff_area then
					local var_8_52 = Managers.state.unit_spawner
					local var_8_53 = Managers.state.side.side_by_unit
					local var_8_54 = var_8_53[var_8_28] or var_8_53[var_8_0]
					local var_8_55 = {
						buff_area_system = {
							duration = var_8_14,
							radius = var_8_12.area_radius,
							sub_buff_template = var_8_12,
							sub_buff_id = iter_8_0,
							owner_unit = var_8_0,
							source_unit = var_8_28,
							side_id = var_8_54 and var_8_54.side_id or 0
						}
					}
					local var_8_56 = arg_8_2 and arg_8_2.buff_area_position or POSITION_LOOKUP[arg_8_0._unit]
					local var_8_57, var_8_58 = var_8_52:spawn_network_unit(var_8_12.area_unit_name, "buff_aoe_unit", var_8_55, var_8_56, Quaternion.identity(), nil)

					var_8_46.area_buff_unit = var_8_57
				end

				if var_8_12.status_effect then
					Managers.state.status_effect:set_status(var_8_0, var_8_12.status_effect, var_8_46, true)
				end

				local var_8_59 = var_8_12.apply_buff_func

				if var_8_59 then
					buff_extension_function_params.bonus = var_8_19
					buff_extension_function_params.multiplier = var_8_21
					buff_extension_function_params.value = var_8_20
					buff_extension_function_params.t = var_8_5
					buff_extension_function_params.end_time = var_8_40
					buff_extension_function_params.attacker_unit = var_8_46.attacker_unit
					buff_extension_function_params.source_attacker_unit = var_8_46.source_attacker_unit

					BuffFunctionTemplates.functions[var_8_59](var_8_0, var_8_46, buff_extension_function_params, var_8_7)
				end

				if var_8_12.delayed_apply_buff_func then
					local var_8_60 = arg_8_0._delayed_apply_funcs or {}

					var_8_60[#var_8_60 + 1] = var_8_46
					arg_8_0._delayed_apply_funcs = var_8_60
				end

				if var_8_12.stat_buff then
					var_8_46.stat_buff_index = arg_8_0:_add_stat_buff(var_8_12, var_8_46)
				end

				local var_8_61 = var_8_12.event

				if var_8_61 then
					var_8_46.buff_func = var_8_12.buff_func

					local var_8_62 = arg_8_0._event_buffs_index

					var_8_46.event_buff_index = var_8_62
					arg_8_0._event_buffs[var_8_61][var_8_62] = var_8_46
					arg_8_0._event_buffs_index = var_8_62 + 1
				end

				if var_8_12.duration_end_func then
					var_8_46.delayed_remove_func_name = var_8_12.duration_end_func
				end

				if var_8_12.continuous_effect then
					arg_8_0._continuous_screen_effects[var_8_6] = arg_8_0:_play_screen_effect(var_8_12.continuous_effect)
				end

				local var_8_63 = var_8_12.particles

				if var_8_63 then
					local var_8_64 = var_8_0
					local var_8_65 = false

					if arg_8_0.is_local and not arg_8_0.is_husk then
						local var_8_66 = ScriptUnit.has_extension(var_8_64, "first_person_system")

						if var_8_66 and var_8_66.first_person_unit then
							var_8_64 = var_8_66.first_person_unit
							var_8_65 = true
						end
					end

					local var_8_67 = BuffUtils.create_attached_particles(var_8_7, var_8_63, var_8_64, var_8_65, var_8_0, var_8_40)

					arg_8_0._vfx[var_8_6] = var_8_67

					if var_8_67.update_fx then
						arg_8_0._vfx_update[var_8_6] = var_8_67
					end
				end

				local var_8_68 = var_8_12.sfx

				if var_8_68 then
					local var_8_69 = var_8_68.activation_sound

					if var_8_69 then
						arg_8_0:_play_buff_sound(var_8_69, var_8_68.activation_sound_3p)
					end
				end
			end
		end
	end

	local var_8_70 = var_8_2.activation_sound

	if var_8_70 then
		arg_8_0:_play_buff_sound(var_8_70, var_8_2.activation_sound_3p)
	end

	local var_8_71 = var_8_2.activation_effect

	if var_8_71 then
		arg_8_0:_play_screen_effect(var_8_71)
	end

	if var_8_11 > 0 then
		if arg_8_0._num_buffs == var_8_11 then
			Managers.state.entity:system("buff_system"):set_buff_ext_active(var_8_0, true)
		end

		arg_8_0._buff_id_refs[var_8_6] = var_8_11

		local var_8_72 = var_8_2.deactivation_effect

		if var_8_72 then
			arg_8_0._deactivation_screen_effects[var_8_6] = var_8_72
		end

		local var_8_73 = var_8_2.deactivation_sound

		if var_8_73 then
			arg_8_0._deactivation_sounds[var_8_6] = var_8_73

			if var_8_2.activation_sound_3p then
				arg_8_0._deactivation_sounds_3p[var_8_6] = var_8_2.activation_sound_3p
			end
		end
	end

	return var_8_6, var_8_11, var_8_9
end

BuffExtension._add_stacking_buff = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6)
	local var_9_0 = arg_9_0._stacking_buffs[arg_9_1.name]
	local var_9_1 = var_9_0 and #var_9_0 or 0

	if arg_9_4 and (arg_9_1.refresh_durations_func and arg_9_1.refresh_durations_func(arg_9_0._unit, arg_9_1) or arg_9_1.refresh_durations) then
		for iter_9_0 = 1, var_9_1 do
			local var_9_2 = var_9_0[iter_9_0]

			arg_9_0:_refresh_duration(var_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_1)
		end
	end

	if arg_9_1.refresh_buff_area_position then
		for iter_9_1 = 1, var_9_1 do
			local var_9_3 = var_9_0[iter_9_1].area_buff_unit

			if var_9_3 then
				local var_9_4 = ScriptUnit.has_extension(var_9_3, "buff_area_system")

				if var_9_4 then
					var_9_4:set_unit_position(POSITION_LOOKUP[arg_9_0._unit])
				end
			end
		end
	end

	if arg_9_6 and arg_9_6.refresh_duration_only and var_9_1 > 0 then
		return false
	end

	local var_9_5 = true

	if arg_9_2 <= var_9_1 then
		local var_9_6 = StackingBuffFunctions[arg_9_1.on_max_stacks_overflow_func]

		if var_9_6 then
			local var_9_7 = true

			arg_9_6 = arg_9_6 or FrameTable.alloc_table()
			var_9_5 = var_9_5 and var_9_6(arg_9_0._unit, arg_9_1, arg_9_6, var_9_7)
		else
			var_9_5 = false
		end
	elseif var_9_1 == arg_9_2 - 1 then
		local var_9_8 = StackingBuffFunctions[arg_9_1.on_max_stacks_func]

		if var_9_8 then
			var_9_8(arg_9_0._unit, arg_9_1, arg_9_6)
		end

		if arg_9_1.reset_on_max_stacks_func and arg_9_1.reset_on_max_stacks_func(arg_9_0._unit, arg_9_1) or arg_9_1.reset_on_max_stacks then
			local var_9_9 = arg_9_0._buffs

			for iter_9_2 = 1, arg_9_0._num_buffs do
				local var_9_10 = var_9_9[iter_9_2]

				if var_9_10.buff_type == arg_9_1.name then
					buff_extension_function_params.bonus = var_9_10.bonus
					buff_extension_function_params.multiplier = var_9_10.multiplier
					buff_extension_function_params.value = var_9_10.value
					buff_extension_function_params.t = arg_9_3
					buff_extension_function_params.end_time = var_9_10.duration and var_9_10.start_time + var_9_10.duration
					buff_extension_function_params.attacker_unit = var_9_10.attacker_unit
					buff_extension_function_params.source_attacker_unit = var_9_10.source_attacker_unit

					arg_9_0:_remove_sub_buff(var_9_10, iter_9_2, buff_extension_function_params, true)
				end
			end

			var_9_5 = false
		end
	end

	return var_9_5
end

BuffExtension._refresh_duration = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6)
	if arg_10_1.area_buff_unit then
		local var_10_0 = ScriptUnit.has_extension(arg_10_1.area_buff_unit, "buff_area_system")

		if var_10_0 then
			var_10_0:set_duration(arg_10_3)
		end
	end

	arg_10_1.start_time = arg_10_2
	arg_10_1.duration = arg_10_3
	arg_10_1.end_time = arg_10_4
	arg_10_1.attacker_unit = arg_10_5 and arg_10_5.attacker_unit or nil
	arg_10_1.source_attacker_unit = arg_10_5 and arg_10_5.source_attacker_unit or nil

	local var_10_1 = arg_10_6.reapply_buff_func

	if var_10_1 then
		buff_extension_function_params.bonus = arg_10_1.bonus
		buff_extension_function_params.multiplier = arg_10_1.multiplier
		buff_extension_function_params.value = arg_10_1.value
		buff_extension_function_params.t = arg_10_2
		buff_extension_function_params.end_time = arg_10_4
		buff_extension_function_params.attacker_unit = arg_10_1.attacker_unit
		buff_extension_function_params.source_attacker_unit = arg_10_1.source_attacker_unit

		local var_10_2 = arg_10_0.world

		BuffFunctionTemplates.functions[var_10_1](arg_10_0._unit, arg_10_1, buff_extension_function_params, var_10_2)
	end
end

BuffExtension._add_stat_buff = function (arg_11_0, arg_11_1, arg_11_2)
	if FROZEN[arg_11_0._unit] or arg_11_0._ai_frozen then
		return
	end

	local var_11_0 = arg_11_2.bonus or 0
	local var_11_1 = arg_11_2.multiplier or 0
	local var_11_2 = arg_11_2.proc_chance or 1
	local var_11_3 = arg_11_2.value
	local var_11_4 = arg_11_0._stat_buffs
	local var_11_5 = arg_11_1.stat_buff
	local var_11_6 = var_11_4[var_11_5]
	local var_11_7 = StatBuffApplicationMethods[var_11_5]

	if arg_11_1.wind_mutator then
		local var_11_8 = Managers.weave:get_wind_strength()
		local var_11_9 = Managers.state.difficulty:get_difficulty()
		local var_11_10 = Managers.weave:get_active_wind_settings()

		if var_11_10 and var_11_9 and var_11_8 then
			var_11_1 = var_11_10[arg_11_1.stat_buff][var_11_9][var_11_8]
		end
	end

	local var_11_11

	if var_11_7 == "proc" or type(var_11_1) == "function" then
		var_11_11 = arg_11_0.individual_stat_buff_index
		var_11_6[var_11_11] = {
			bonus = var_11_0,
			multiplier = var_11_1,
			proc_chance = var_11_2
		}
		arg_11_0.individual_stat_buff_index = var_11_11 + 1
	else
		var_11_11 = var_11_7 == "stacking_multiplier_multiplicative" and (arg_11_1.stacking_name or arg_11_1.name) or 0

		if not var_11_6[var_11_11] then
			var_11_6[var_11_11] = {
				bonus = var_11_0,
				multiplier = var_11_1,
				proc_chance = var_11_2,
				value = var_11_3
			}
		elseif var_11_7 == "stacking_bonus" then
			local var_11_12 = var_11_6[var_11_11].bonus

			var_11_6[var_11_11].bonus = var_11_12 + var_11_0
		elseif var_11_7 == "stacking_multiplier" or var_11_7 == "stacking_multiplier_multiplicative" then
			local var_11_13 = var_11_6[var_11_11].multiplier

			var_11_6[var_11_11].multiplier = var_11_13 + var_11_1
		elseif var_11_7 == "stacking_bonus_and_multiplier" then
			local var_11_14 = var_11_6[var_11_11].bonus
			local var_11_15 = var_11_6[var_11_11].multiplier

			var_11_6[var_11_11].bonus = var_11_14 + var_11_0
			var_11_6[var_11_11].multiplier = var_11_15 + var_11_1
		elseif var_11_7 == "min" then
			local var_11_16 = var_11_6[var_11_11]

			if not var_11_16.all_values then
				var_11_16.all_values = {
					var_11_16.value
				}
			end

			var_11_16.all_values[#var_11_16.all_values + 1] = var_11_3

			local var_11_17 = var_11_16.value or math.huge

			var_11_16.value = math.min(var_11_17, var_11_3)
		end
	end

	return var_11_11
end

BuffExtension.update = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	local var_12_0 = arg_12_0.world
	local var_12_1 = arg_12_0._buffs
	local var_12_2 = buff_extension_function_params

	var_12_2.t = arg_12_5

	local var_12_3 = arg_12_0._delayed_apply_funcs

	if var_12_3 then
		arg_12_0._delayed_apply_funcs = nil

		for iter_12_0 = 1, #var_12_3 do
			local var_12_4 = var_12_3[iter_12_0]

			if not var_12_4.is_stale then
				local var_12_5 = var_12_4.template.delayed_apply_buff_func

				BuffFunctionTemplates.functions[var_12_5](arg_12_1, var_12_4)
			end
		end
	end

	local var_12_6 = arg_12_0._remove_buff_queue

	if var_12_6 then
		arg_12_0._remove_buff_queue = nil

		for iter_12_1 = 1, #var_12_6 do
			arg_12_0:remove_buff(var_12_6[iter_12_1])
		end
	end

	for iter_12_2 = 1, arg_12_0._num_buffs do
		local var_12_7 = var_12_1[iter_12_2]

		if not var_12_7.removed then
			local var_12_8 = var_12_7.template
			local var_12_9 = var_12_7.duration and var_12_7.start_time + var_12_7.duration
			local var_12_10 = var_12_7.ticks
			local var_12_11 = var_12_7.current_ticks

			var_12_2.bonus = var_12_7.bonus
			var_12_2.multiplier = var_12_7.multiplier
			var_12_2.value = var_12_7.value
			var_12_2.end_time = var_12_9
			var_12_2.attacker_unit = var_12_7.attacker_unit
			var_12_2.source_attacker_unit = var_12_7.source_attacker_unit

			local var_12_12 = var_12_10 and var_12_10 <= var_12_11

			if var_12_9 and var_12_9 <= arg_12_5 or not var_12_9 and var_12_12 then
				if var_12_8.remove_buff_on_duration_end then
					arg_12_0:remove_buff(var_12_7.id)
				else
					arg_12_0:_remove_sub_buff(var_12_7, iter_12_2, var_12_2, true)
				end

				local var_12_13 = var_12_7.delayed_remove_func_name

				if var_12_13 and not var_12_7.aborted then
					BuffFunctionTemplates.functions[var_12_13](arg_12_1, var_12_7, var_12_2, var_12_0)
				end
			elseif not var_12_12 then
				local var_12_14 = var_12_8.update_func

				if var_12_14 then
					local var_12_15 = var_12_7._next_update_t

					if not var_12_15 then
						var_12_15 = arg_12_5 + (var_12_7.template.update_start_delay or 0)
						var_12_7._next_update_t = var_12_15
					end

					if var_12_15 <= arg_12_5 then
						var_12_2.time_into_buff = arg_12_5 - var_12_7.start_time
						var_12_2.time_left_on_buff = var_12_9 and var_12_9 - arg_12_5
						var_12_7._next_update_t = BuffFunctionTemplates.functions[var_12_14](arg_12_1, var_12_7, var_12_2, var_12_0) or arg_12_5 + (var_12_7.update_frequency or 0)

						if var_12_11 then
							var_12_7.current_ticks = var_12_11 + 1
						end
					end
				end
			end
		end
	end

	for iter_12_3, iter_12_4 in pairs(arg_12_0._vfx_update) do
		BuffUtils.update_attached_particles(var_12_0, iter_12_4, arg_12_5)
	end

	local var_12_16 = 1
	local var_12_17 = 0

	while var_12_16 <= arg_12_0._num_buffs - var_12_17 do
		var_12_1[var_12_16] = var_12_1[var_12_16 + var_12_17]

		if not var_12_1[var_12_16] then
			break
		elseif var_12_1[var_12_16].removed then
			var_12_17 = var_12_17 + 1
		else
			var_12_16 = var_12_16 + 1
		end
	end

	for iter_12_5 = var_12_16, arg_12_0._num_buffs do
		var_12_1[iter_12_5] = nil
	end

	arg_12_0._num_buffs = arg_12_0._num_buffs - var_12_17

	if arg_12_0._num_buffs == 0 then
		Managers.state.entity:system("buff_system"):set_buff_ext_active(arg_12_1, false)
	end
end

BuffExtension.update_stat_buff = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = arg_13_0._stat_buffs[arg_13_1]
	local var_13_1 = StatBuffApplicationMethods[arg_13_1]

	arg_13_3 = arg_13_3 or 0

	if var_13_1 == "stacking_bonus" then
		local var_13_2 = var_13_0[arg_13_3].bonus

		var_13_0[arg_13_3].bonus = var_13_2 + arg_13_2

		return var_13_0[arg_13_3].bonus
	elseif var_13_1 == "stacking_multiplier" or var_13_1 == "stacking_multiplier_multiplicative" then
		local var_13_3 = var_13_0[arg_13_3].multiplier

		var_13_0[arg_13_3].multiplier = var_13_3 + arg_13_2

		return var_13_0[arg_13_3].multiplier
	else
		fassert(false, "trying to update a stat with an incompatible application method")
	end
end

BuffExtension.num_sub_buffs = function (arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0._buffs
	local var_14_1 = table.find_by_key(var_14_0, "id", arg_14_1)

	if not var_14_1 then
		return -1
	end

	local var_14_2 = var_14_0[var_14_1].template.buff_to_add

	if not var_14_2 then
		return -1
	end

	local var_14_3 = 0

	for iter_14_0 = 1, arg_14_0._num_buffs do
		if var_14_0[iter_14_0].buff_type == var_14_2 then
			var_14_3 = var_14_3 + 1
		end
	end

	return var_14_3
end

BuffExtension.remove_buff = function (arg_15_0, arg_15_1, arg_15_2)
	if not arg_15_1 then
		return 0
	end

	local var_15_0 = arg_15_0._buffs
	local var_15_1 = Managers.time:time("game")
	local var_15_2 = 0
	local var_15_3 = buff_extension_function_params

	var_15_3.t = var_15_1
	var_15_3.end_time = var_15_1

	local var_15_4 = 0

	for iter_15_0 = 1, arg_15_0._num_buffs do
		local var_15_5 = var_15_0[iter_15_0]

		if var_15_5.id == arg_15_1 then
			var_15_3.bonus = var_15_5.bonus
			var_15_3.multiplier = var_15_5.multiplier
			var_15_3.value = var_15_5.value
			var_15_3.attacker_unit = var_15_5.attacker_unit
			var_15_3.source_attacker_unit = var_15_5.source_attacker_unit

			arg_15_0:_remove_sub_buff(var_15_5, iter_15_0, var_15_3, false)

			var_15_4 = var_15_4 + 1
		end
	end

	if arg_15_0._num_buffs == 0 then
		Managers.state.entity:system("buff_system"):set_buff_ext_active(arg_15_0._unit, false)
	end

	if not arg_15_2 then
		arg_15_0:_remove_buff_synced(arg_15_1)
	end

	arg_15_0:_free_sync_id(arg_15_1)

	return var_15_4
end

BuffExtension.queue_remove_buff = function (arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0._remove_buff_queue or {}

	var_16_0[#var_16_0 + 1] = arg_16_1
	arg_16_0._remove_buff_queue = var_16_0
end

BuffExtension._remove_sub_buff = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	local var_17_0 = arg_17_0.world
	local var_17_1 = arg_17_0._buffs
	local var_17_2 = arg_17_1.template
	local var_17_3 = var_17_2.remove_buff_func
	local var_17_4 = var_17_2.buffs_to_remove_on_remove

	if var_17_3 then
		BuffFunctionTemplates.functions[var_17_3](arg_17_0._unit, arg_17_1, arg_17_3, var_17_0)
	end

	if var_17_2.status_effect then
		Managers.state.status_effect:set_status(arg_17_0._unit, var_17_2.status_effect, arg_17_1, false)
	end

	if var_17_4 then
		for iter_17_0 = 1, #var_17_4 do
			if arg_17_1.buff_type ~= var_17_4[iter_17_0] then
				for iter_17_1 = 1, arg_17_0._num_buffs do
					local var_17_5 = var_17_1[iter_17_1]

					if var_17_5 and var_17_5.buff_type == var_17_4[iter_17_0] then
						if var_17_5.delayed_remove_func_name then
							var_17_5.aborted = true
						end

						arg_17_0:remove_buff(var_17_5.id)
					end
				end
			end
		end
	end

	if var_17_2.stat_buff then
		arg_17_0:_remove_stat_buff(arg_17_1)
	end

	local var_17_6 = var_17_2.buff_to_add

	if var_17_6 and var_17_3 ~= "add_buff" then
		for iter_17_2 = 1, arg_17_0._num_buffs do
			local var_17_7 = var_17_1[iter_17_2]

			if var_17_7.buff_type == var_17_6 and not var_17_7.duration then
				var_17_7.duration = 0
				var_17_7.is_stale = true
			end
		end
	end

	local var_17_8 = var_17_2.event

	if var_17_8 then
		local var_17_9 = arg_17_1.event_buff_index

		arg_17_0._event_buffs[var_17_8][var_17_9] = nil
	end

	local var_17_10 = var_17_2.perks

	if var_17_10 then
		for iter_17_3 = 1, #var_17_10 do
			local var_17_11 = var_17_10[iter_17_3]
			local var_17_12 = arg_17_0._perks[var_17_11] - 1

			if var_17_12 == 0 then
				local var_17_13 = var_0_0[var_17_11]

				if var_17_13 and var_17_13.removed then
					var_17_13.removed(arg_17_0, arg_17_0._unit, arg_17_1, arg_17_0.is_server)
				end
			end

			arg_17_0._perks[var_17_11] = var_17_12
		end
	end

	var_17_1[arg_17_2] = var_0_3
	arg_17_0._any_buff_removed = true

	local var_17_14 = var_17_2.max_stacks or var_17_2.max_stacks_func

	if var_17_14 then
		local var_17_15 = arg_17_0._stacking_buffs[arg_17_1.template.name]
		local var_17_16 = table.index_of(var_17_15, arg_17_1)

		if var_17_16 > 0 then
			table.swap_delete(var_17_15, var_17_16)
		end

		if var_17_2.refresh_other_stacks_on_remove then
			local var_17_17 = Managers.time:time("game")

			for iter_17_4 = 1, #var_17_15 do
				local var_17_18 = var_17_15[iter_17_4]
				local var_17_19 = var_17_17
				local var_17_20 = var_17_18.duration
				local var_17_21 = var_17_20 and var_17_19 + var_17_20

				arg_17_0:_refresh_duration(var_17_18, var_17_19, var_17_20, var_17_21, arg_17_3, var_17_2)
			end
		end

		if #var_17_15 == 0 then
			local var_17_22 = StackingBuffFunctions[var_17_2.on_last_stack_removed]

			if var_17_22 then
				var_17_22(arg_17_0._unit, var_17_2, arg_17_3)
			end

			arg_17_0._stacking_buffs[var_17_2.name] = nil
		end
	end

	arg_17_1.is_stale = true

	if arg_17_0._num_buffs == 0 then
		Managers.state.entity:system("buff_system"):set_buff_ext_active(arg_17_0._unit, false)
	end

	local var_17_23 = arg_17_1.id
	local var_17_24 = (arg_17_0._buff_id_refs[var_17_23] or 0) - 1

	if var_17_24 > 0 then
		arg_17_0._buff_id_refs[var_17_23] = var_17_24
		arg_17_4 = false
	else
		arg_17_0._buff_id_refs[var_17_23] = nil
	end

	if arg_17_4 and arg_17_0._id_to_local_sync then
		if arg_17_0._buff_to_sync_type and arg_17_0._buff_to_sync_type[var_17_23] == BuffSyncType.Client or not var_17_2.duration and not var_17_2.ticks then
			arg_17_0:_remove_buff_synced(var_17_23)
		end

		arg_17_0:_free_sync_id(var_17_23)
	end

	local var_17_25 = arg_17_0._deactivation_sounds[var_17_23]

	if var_17_25 then
		arg_17_0:_play_buff_sound(var_17_25, arg_17_0._deactivation_sounds_3p[var_17_23])

		arg_17_0._deactivation_sounds[var_17_23] = nil
		arg_17_0._deactivation_sounds_3p[var_17_23] = nil
	end

	local var_17_26 = arg_17_0._continuous_screen_effects[var_17_23]

	if var_17_26 then
		arg_17_0:_stop_screen_effect(var_17_26)

		arg_17_0._continuous_screen_effects[var_17_23] = nil
	end

	local var_17_27 = arg_17_0._deactivation_screen_effects[var_17_23]

	if var_17_27 then
		arg_17_0:_play_screen_effect(var_17_27)

		arg_17_0._deactivation_screen_effects[var_17_23] = nil
	end

	if not var_17_14 or not arg_17_0._stacking_buffs[arg_17_1.template.name] then
		local var_17_28 = arg_17_0._vfx[var_17_23]

		if var_17_28 then
			BuffUtils.destroy_attached_particles(var_17_0, var_17_28)

			arg_17_0._vfx[var_17_23] = nil
			arg_17_0._vfx_update[var_17_23] = nil
		end
	end
end

BuffExtension._remove_stat_buff = function (arg_18_0, arg_18_1)
	local var_18_0 = arg_18_1.template
	local var_18_1 = arg_18_1.bonus or 0
	local var_18_2 = arg_18_1.multiplier or 0
	local var_18_3 = arg_18_1.value
	local var_18_4 = var_18_0.stat_buff
	local var_18_5 = arg_18_0._stat_buffs[var_18_4]
	local var_18_6 = StatBuffApplicationMethods[var_18_4]

	if var_18_0.wind_mutator then
		local var_18_7 = Managers.weave:get_wind_strength()
		local var_18_8 = Managers.state.difficulty:get_difficulty()
		local var_18_9 = Managers.weave:get_active_wind_settings()

		if var_18_9 and var_18_8 and var_18_7 then
			var_18_2 = var_18_9[var_18_0.stat_buff][var_18_8][var_18_7]
		end
	end

	local var_18_10 = arg_18_1.stat_buff_index

	if var_18_6 == "proc" or type(var_18_5[var_18_10].multiplier) == "function" then
		var_18_5[var_18_10] = nil
	elseif var_18_6 == "stacking_bonus" then
		local var_18_11 = var_18_5[var_18_10].bonus

		var_18_5[var_18_10].bonus = var_18_11 - var_18_1
	elseif var_18_6 == "stacking_multiplier" or var_18_6 == "stacking_multiplier_multiplicative" then
		local var_18_12 = var_18_5[var_18_10].multiplier

		var_18_5[var_18_10].multiplier = var_18_12 - var_18_2
	elseif var_18_6 == "stacking_bonus_and_multiplier" then
		local var_18_13 = var_18_5[var_18_10].bonus
		local var_18_14 = var_18_5[var_18_10].multiplier

		var_18_5[var_18_10].bonus = var_18_13 - var_18_1
		var_18_5[var_18_10].multiplier = var_18_14 - var_18_2
	elseif var_18_6 == "min" then
		local var_18_15 = var_18_5[var_18_10]

		if var_18_15.all_values then
			local var_18_16 = table.index_of(var_18_15.all_values, var_18_3)

			fassert(var_18_16 ~= -1, "buff needs to be there when removed, if it's not then something went wrong")
			table.swap_delete(var_18_15.all_values, var_18_16)

			if #var_18_15.all_values == 0 then
				var_18_15.value = nil
			else
				var_18_15.value = var_18_15.all_values[1]

				for iter_18_0, iter_18_1 in ipairs(var_18_15.all_values) do
					var_18_15.value = math.min(var_18_15.value, iter_18_1)
				end
			end
		else
			fassert(var_18_15.value == var_18_3, "buff needs to be there when removed, if it's not then something went wrong")

			var_18_15.value = nil
		end
	end
end

BuffExtension.get_buff_type = function (arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0._buffs

	for iter_19_0 = 1, arg_19_0._num_buffs do
		local var_19_1 = var_19_0[iter_19_0]

		if var_19_1.buff_type == arg_19_1 then
			return var_19_1
		end
	end

	return nil
end

BuffExtension.get_buff_by_id = function (arg_20_0, arg_20_1)
	if not arg_20_1 then
		return nil
	end

	local var_20_0 = arg_20_0._buffs

	for iter_20_0 = 1, arg_20_0._num_buffs do
		local var_20_1 = var_20_0[iter_20_0]

		if var_20_1.id == arg_20_1 then
			return var_20_1
		end
	end

	return nil
end

BuffExtension.has_buff_type = function (arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0._buffs

	for iter_21_0 = 1, arg_21_0._num_buffs do
		if var_21_0[iter_21_0].buff_type == arg_21_1 then
			return true
		end
	end

	return false
end

BuffExtension.has_buff_perk = function (arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0._perks[arg_22_1]

	return var_22_0 and var_22_0 > 0
end

BuffExtension.num_buff_perk = function (arg_23_0, arg_23_1)
	return arg_23_0._perks[arg_23_1] or 0
end

BuffExtension.get_non_stacking_buff = function (arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0._buffs

	for iter_24_0 = 1, arg_24_0._num_buffs do
		local var_24_1 = var_24_0[iter_24_0]

		if var_24_1.buff_type == arg_24_1 then
			fassert(var_24_1.max_stacks == 1, "Tried getting a stacking buff!")

			return var_24_1
		end
	end

	return nil
end

BuffExtension.get_stacking_buff = function (arg_25_0, arg_25_1)
	return arg_25_0._stacking_buffs[arg_25_1]
end

BuffExtension.num_buff_stacks = function (arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0._stacking_buffs[arg_26_1]

	return var_26_0 and #var_26_0 or 0
end

BuffExtension.num_buff_type = function (arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0._stacking_buffs[arg_27_1]

	if var_27_0 then
		return #var_27_0
	end

	local var_27_1 = arg_27_0._buffs
	local var_27_2 = 0

	for iter_27_0 = 1, arg_27_0._num_buffs do
		if var_27_1[iter_27_0].buff_type == arg_27_1 then
			var_27_2 = var_27_2 + 1
		end
	end

	return var_27_2
end

BuffExtension.has_procced = function (arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_0._prd_states
	local var_28_1
	local var_28_2 = var_28_0[arg_28_2]
	local var_28_3, var_28_4 = PseudoRandomDistribution.flip_coin(var_28_2, arg_28_1)

	var_28_0[arg_28_2] = var_28_4

	return var_28_3
end

local function var_0_4(arg_29_0, arg_29_1)
	return arg_29_0.proc_weight > arg_29_1.proc_weight
end

local function var_0_5(arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_0.template.authority

	return not var_30_0 or var_30_0 == "server" and arg_30_1 or var_30_0 == "client" and arg_30_2
end

BuffExtension.trigger_procs = function (arg_31_0, arg_31_1, ...)
	local var_31_0 = arg_31_0._event_buffs[arg_31_1]

	if table.size(var_31_0) == 0 then
		return
	end

	local var_31_1 = arg_31_0.is_server
	local var_31_2 = arg_31_0.is_local
	local var_31_3 = arg_31_0.world
	local var_31_4 = select("#", ...)
	local var_31_5 = Managers.time:time("game")
	local var_31_6 = FrameTable.alloc_table()
	local var_31_7 = FrameTable.alloc_table()

	for iter_31_0 = 1, var_31_4 do
		var_31_6[iter_31_0] = select(iter_31_0, ...)
	end

	local var_31_8 = 1
	local var_31_9 = FrameTable.alloc_table()

	for iter_31_1, iter_31_2 in pairs(var_31_0) do
		local var_31_10 = iter_31_2.proc_chance or 1

		if var_0_5(iter_31_2, var_31_1, var_31_2) and var_31_5 > (iter_31_2._next_proc_t or 0) and arg_31_0:has_procced(var_31_10, iter_31_2) then
			iter_31_2._next_proc_t = iter_31_2.template.proc_cooldown and iter_31_2.template.proc_cooldown + var_31_5

			local var_31_11 = iter_31_2.template.proc_weight or 0

			var_31_9[var_31_8] = {
				buff = iter_31_2,
				proc_weight = var_31_11
			}
			var_31_8 = var_31_8 + 1
		end
	end

	table.sort(var_31_9, var_0_4)

	local var_31_12 = arg_31_0._unit

	for iter_31_3 = 1, #var_31_9 do
		local var_31_13 = var_31_9[iter_31_3].buff
		local var_31_14 = var_31_13.buff_func
		local var_31_15 = ProcFunctions[var_31_14]

		if (not var_31_15 or var_31_15(var_31_12, var_31_13, var_31_6, var_31_3, ProcEventParams[arg_31_1])) and var_31_13.template.remove_on_proc then
			var_31_7[#var_31_7 + 1] = var_31_13
		end
	end

	for iter_31_4 = 1, #var_31_7 do
		local var_31_16 = var_31_7[iter_31_4].id

		arg_31_0:remove_buff(var_31_16)
	end
end

BuffExtension.get_buff_value = function (arg_32_0, arg_32_1)
	local var_32_0 = arg_32_0._stat_buffs[arg_32_1]
	local var_32_1 = false
	local var_32_2 = StatBuffApplicationMethods[arg_32_1] == "proc"
	local var_32_3
	local var_32_4

	for iter_32_0, iter_32_1 in pairs(var_32_0) do
		if iter_32_1.proc_chance >= math.random() then
			var_32_3 = iter_32_1.value

			if var_32_2 then
				var_32_1 = true
				var_32_4 = iter_32_1.id

				break
			end
		end
	end

	return var_32_3, var_32_1, var_32_4
end

BuffExtension.apply_buffs_to_value = function (arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = arg_33_0._stat_buffs[arg_33_2]
	local var_33_1 = arg_33_1
	local var_33_2 = false
	local var_33_3 = StatBuffApplicationMethods[arg_33_2] == "proc"
	local var_33_4
	local var_33_5 = 1
	local var_33_6 = 0

	for iter_33_0, iter_33_1 in pairs(var_33_0) do
		local var_33_7 = iter_33_1.proc_chance

		if arg_33_0:has_procced(var_33_7, arg_33_2) then
			local var_33_8 = iter_33_1.bonus
			local var_33_9 = iter_33_1.multiplier
			local var_33_10 = type(var_33_9)

			if var_33_10 == "function" then
				var_33_9 = var_33_9(arg_33_0._unit, arg_33_0)

				local var_33_11 = StatBuffApplicationMethods[arg_33_2]

				if var_33_11 == "stacking_multiplier" or var_33_11 == "stacking_multiplier_multiplicative" then
					var_33_5 = var_33_5 + var_33_9
					var_33_1 = var_33_1 + var_33_8
				elseif var_33_11 == "stacking_bonus_and_multiplier" then
					var_33_6 = var_33_6 + var_33_8
					var_33_5 = var_33_5 + var_33_9
				end
			else
				if var_33_10 == "table" then
					var_33_9 = var_33_9[Managers.weave:get_wind_strength()]
				end

				if iter_33_0 == 0 then
					var_33_5 = var_33_5 + var_33_9
					var_33_6 = var_33_6 + var_33_8
				else
					var_33_1 = var_33_1 * (var_33_9 + 1) + var_33_8
				end
			end

			if var_33_3 then
				var_33_2 = true
				var_33_4 = iter_33_1.id

				break
			end
		end
	end

	return var_33_1 * var_33_5 + var_33_6, var_33_2, var_33_4
end

BuffExtension._play_buff_sound = function (arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = arg_34_0._unit

	if arg_34_2 then
		Managers.state.entity:system("audio_system"):play_audio_unit_event(arg_34_1, var_34_0)
	elseif ScriptUnit.has_extension(var_34_0, "first_person_system") then
		ScriptUnit.extension(var_34_0, "first_person_system"):play_hud_sound_event(arg_34_1)
	end
end

BuffExtension._play_screen_effect = function (arg_35_0, arg_35_1)
	local var_35_0 = arg_35_0._unit

	if ScriptUnit.has_extension(var_35_0, "first_person_system") then
		return (ScriptUnit.extension(var_35_0, "first_person_system"):create_screen_particles(arg_35_1))
	end

	return nil
end

BuffExtension._stop_screen_effect = function (arg_36_0, arg_36_1)
	local var_36_0 = arg_36_0._unit

	if arg_36_1 and ScriptUnit.has_extension(var_36_0, "first_person_system") then
		ScriptUnit.extension(var_36_0, "first_person_system"):stop_spawning_screen_particles(arg_36_1)
	end
end

BuffExtension.active_buffs = function (arg_37_0)
	return arg_37_0._buffs, arg_37_0._num_buffs
end

BuffExtension.initial_buff_names = function (arg_38_0)
	return arg_38_0._initial_buff_names
end

BuffExtension.get_persistent_buff_names = function (arg_39_0)
	local var_39_0 = {}

	for iter_39_0, iter_39_1 in pairs(arg_39_0._buffs) do
		local var_39_1 = iter_39_1.template

		if var_39_1.is_persistent then
			table.insert(var_39_0, var_39_1.name)
		end
	end

	return var_39_0
end

BuffExtension._activate_initial_buffs = function (arg_40_0)
	local var_40_0 = arg_40_0._initial_buff_names

	if var_40_0 then
		for iter_40_0, iter_40_1 in ipairs(var_40_0) do
			arg_40_0:add_buff(iter_40_1)
		end
	end
end

BuffExtension.set_pending_sync_id = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	arg_41_0:_initalize_sync_tables()

	arg_41_0._id_to_local_sync[arg_41_1] = arg_41_2
	arg_41_0._local_sync_to_id[arg_41_2] = arg_41_1
	arg_41_0._buff_to_sync_type[arg_41_1] = arg_41_3
end

BuffExtension.apply_sync_id = function (arg_42_0, arg_42_1, arg_42_2)
	local var_42_0 = arg_42_0._local_sync_to_id and arg_42_0._local_sync_to_id[arg_42_1]

	if var_42_0 then
		arg_42_0:_initalize_sync_tables()

		arg_42_0._id_to_server_sync[var_42_0] = arg_42_2
		arg_42_0._server_sync_to_id[arg_42_2] = var_42_0

		return true
	end

	return false
end

BuffExtension.apply_remote_sync_id = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4)
	if arg_43_1 then
		arg_43_0:_initalize_sync_tables()

		arg_43_0._id_to_server_sync[arg_43_1] = arg_43_2
		arg_43_0._server_sync_to_id[arg_43_2] = arg_43_1
		arg_43_0._buff_to_sync_type[arg_43_1] = arg_43_3
		arg_43_0._synced_buff_owner[arg_43_1] = arg_43_4
	end
end

BuffExtension.generate_sync_id = function (arg_44_0)
	local var_44_0
	local var_44_1 = arg_44_0._free_sync_ids

	if var_44_1 then
		var_44_0 = var_44_1[1]

		if not var_44_0 then
			if arg_44_0.debug_buff_names then
				table.dump(table.select_map(arg_44_0._local_sync_to_id, function (arg_45_0, arg_45_1)
					return string.format("(id: %s) %s", arg_45_0, arg_44_0.debug_buff_names[arg_45_1])
				end), "Synced Buffs")
			else
				print("[BuffExtension] Not a player")
			end

			error("[BuffExtension] Too many synced buffs, no free sync ids left!")
		end

		table.swap_delete(var_44_1, 1)
	else
		var_44_0 = arg_44_0._next_sync_id or 1

		if var_44_0 > NetworkConstants.server_controlled_buff_id.max then
			arg_44_0:_build_free_sync_ids_array()

			return arg_44_0:generate_sync_id()
		else
			arg_44_0._next_sync_id = var_44_0 + 1
		end
	end

	return var_44_0
end

BuffExtension.claim_buff_id = function (arg_46_0, arg_46_1)
	local var_46_0 = arg_46_0.id

	arg_46_0.id = var_46_0 + 1

	if arg_46_0.debug_buff_names then
		arg_46_0.debug_buff_names[var_46_0] = arg_46_1
	end

	return var_46_0
end

BuffExtension.sync_id_to_id = function (arg_47_0, arg_47_1)
	return arg_47_0._server_sync_to_id and arg_47_0._server_sync_to_id[arg_47_1]
end

BuffExtension.id_to_sync_id = function (arg_48_0, arg_48_1)
	return arg_48_0._id_to_server_sync and arg_48_0._id_to_server_sync[arg_48_1]
end

BuffExtension.buff_sync_type = function (arg_49_0, arg_49_1)
	return arg_49_0._buff_to_sync_type[arg_49_1]
end

BuffExtension._free_sync_id = function (arg_50_0, arg_50_1)
	local var_50_0 = arg_50_0._buff_to_sync_type

	if not var_50_0 or not var_50_0[arg_50_1] then
		return
	end

	local var_50_1 = arg_50_0._id_to_local_sync[arg_50_1]

	if var_50_1 then
		arg_50_0._local_sync_to_id[var_50_1] = nil

		local var_50_2 = arg_50_0._free_sync_ids

		if var_50_2 then
			var_50_2[#var_50_2 + 1] = var_50_1
		end
	end

	local var_50_3 = arg_50_0._id_to_server_sync[arg_50_1]

	if var_50_3 then
		arg_50_0._server_sync_to_id[var_50_3] = nil
	end

	arg_50_0._id_to_local_sync[arg_50_1] = nil
	arg_50_0._id_to_server_sync[arg_50_1] = nil
	arg_50_0._buff_to_sync_type[arg_50_1] = nil
	arg_50_0._synced_buff_owner[arg_50_1] = nil
end

BuffExtension._build_free_sync_ids_array = function (arg_51_0)
	local var_51_0 = NetworkConstants.server_controlled_buff_id.max

	arg_51_0._free_sync_ids = Script.new_array(var_51_0)

	local var_51_1 = arg_51_0._local_sync_to_id
	local var_51_2 = 1

	for iter_51_0 = 1, var_51_0 do
		if not var_51_1[iter_51_0] then
			arg_51_0._free_sync_ids[var_51_2] = iter_51_0
			var_51_2 = var_51_2 + 1
		end
	end
end

BuffExtension._initalize_sync_tables = function (arg_52_0)
	if not arg_52_0._id_to_local_sync then
		arg_52_0._id_to_local_sync = {}
		arg_52_0._local_sync_to_id = {}
		arg_52_0._synced_buff_owner = {}
		arg_52_0._buff_to_sync_type = {}
		arg_52_0._id_to_server_sync = {}
		arg_52_0._server_sync_to_id = {}
	end
end

BuffExtension.create_shared_lifetime_buff_unit = function (arg_53_0, arg_53_1)
	arg_53_0._shared_buff_units = arg_53_0._shared_buff_units or {}
	arg_53_0._shared_buff_units[#arg_53_0._shared_buff_units + 1] = Managers.state.unit_spawner:spawn_network_unit("units/hub_elements/empty", "buff_unit", arg_53_0._buff_unit_params, arg_53_1, Quaternion.identity(), nil)

	return arg_53_0._shared_buff_units[#arg_53_0._shared_buff_units]
end

local var_0_6 = Managers

BuffExtension._remove_buff_synced = function (arg_54_0, arg_54_1)
	local var_54_0 = arg_54_0._id_to_server_sync

	if not var_54_0 then
		return
	end

	local var_54_1 = var_54_0[arg_54_1]

	if not var_54_1 then
		return
	end

	local var_54_2 = var_0_6.state.network
	local var_54_3 = var_54_2:unit_game_object_id(arg_54_0._unit)

	if not var_54_3 then
		return
	end

	if not var_54_2:game() then
		return
	end

	local var_54_4 = var_54_2.network_transmit

	if arg_54_0.is_server then
		if arg_54_0._buff_to_sync_type[arg_54_1] == BuffSyncType.All then
			var_54_4:send_rpc_clients("rpc_remove_buff_synced", var_54_3, var_54_1)
		else
			local var_54_5 = arg_54_0._synced_buff_owner[arg_54_1]

			if PEER_ID_TO_CHANNEL[var_54_5] then
				var_54_4:send_rpc("rpc_remove_buff_synced", var_54_5, var_54_3, var_54_1)
			end
		end
	else
		var_54_4:send_rpc_server("rpc_remove_buff_synced", var_54_3, var_54_1)
	end
end
