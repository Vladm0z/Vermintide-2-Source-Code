-- chunkname: @scripts/settings/dlcs/woods/passive_ability_thornsister.lua

PassiveAbilityThornsister = class(PassiveAbilityThornsister)

PassiveAbilityThornsister.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0._owner_unit = arg_1_2
	arg_1_0._ability_init_data = arg_1_4
	arg_1_0._cooldown_buff = nil
	arg_1_0._stack_buffs = {}
	arg_1_0._num_stack_buffs = 0
end

PassiveAbilityThornsister.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._career_extension = ScriptUnit.has_extension(arg_2_2, "career_system")
	arg_2_0._buff_extension = ScriptUnit.has_extension(arg_2_2, "buff_system")

	local var_2_0 = arg_2_0._ability_init_data

	arg_2_0._career_extension:setup_extra_ability_uses(0, var_2_0.cooldown, var_2_0.starting_stack_count, var_2_0.max_stacks)

	local var_2_1 = ScriptUnit.has_extension(arg_2_2, "talent_system")

	arg_2_0:_update_extra_abilities_info(var_2_1)
	arg_2_0:_register_events()
end

PassiveAbilityThornsister.destroy = function (arg_3_0)
	arg_3_0:_unregister_events()
end

PassiveAbilityThornsister._register_events = function (arg_4_0)
	Managers.state.event:register(arg_4_0, "on_talents_changed", "on_talents_changed")
end

PassiveAbilityThornsister._unregister_events = function (arg_5_0)
	if Managers.state.event then
		Managers.state.event:unregister("on_talents_changed", arg_5_0)
	end
end

PassiveAbilityThornsister.update = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0._career_extension

	if not var_6_0 then
		return
	end

	var_6_0:modify_extra_ability_charge(arg_6_1)

	local var_6_1 = arg_6_0._buff_extension

	if var_6_1 then
		local var_6_2, var_6_3 = var_6_0:get_extra_ability_uses()
		local var_6_4, var_6_5 = var_6_0:get_extra_ability_charge()
		local var_6_6 = arg_6_0._cooldown_buff

		if var_6_6 and var_6_6.is_stale then
			var_6_6 = nil
		end

		if var_6_2 < var_6_3 then
			if not var_6_6 then
				local var_6_7 = var_6_1:add_buff("kerillian_thorn_sister_free_ability_cooldown")

				var_6_6 = var_6_1:get_buff_by_id(var_6_7)
				arg_6_0._cooldown_buff = var_6_6
			end

			var_6_6.start_time = arg_6_2 - var_6_4
			var_6_6.duration = var_6_5
		elseif var_6_6 then
			var_6_1:remove_buff(var_6_6.id)

			arg_6_0._cooldown_buff = nil
		end

		local var_6_8 = arg_6_0._stack_buffs
		local var_6_9 = arg_6_0._num_stack_buffs

		if var_6_9 < var_6_2 then
			for iter_6_0 = 1, var_6_2 - var_6_9 do
				var_6_8[var_6_9 + iter_6_0] = var_6_1:add_buff("kerillian_thorn_sister_free_ability_stack")
			end
		elseif var_6_2 < var_6_9 then
			for iter_6_1 = 1, var_6_9 - var_6_2 do
				local var_6_10 = var_6_9 - iter_6_1 + 1

				var_6_1:remove_buff(var_6_8[var_6_10])

				var_6_8[var_6_10] = nil
			end
		end

		arg_6_0._num_stack_buffs = var_6_2
	end
end

PassiveAbilityThornsister.on_talents_changed = function (arg_7_0, arg_7_1, arg_7_2)
	if arg_7_1 ~= arg_7_0._owner_unit then
		return
	end

	local var_7_0 = arg_7_0._buff_extension

	if var_7_0 then
		local var_7_1 = arg_7_0._cooldown_buff

		if var_7_1 and not var_7_1.is_stale then
			var_7_0:remove_buff(var_7_1.id)
		end

		arg_7_0._cooldown_buff = nil

		local var_7_2 = arg_7_0._stack_buffs
		local var_7_3 = arg_7_0._num_stack_buffs

		for iter_7_0 = 1, var_7_3 do
			local var_7_4 = var_7_3 - iter_7_0 + 1

			var_7_0:remove_buff(var_7_2[var_7_4])

			var_7_2[var_7_4] = nil
		end

		arg_7_0._num_stack_buffs = 0
	end

	arg_7_0:_update_extra_abilities_info(arg_7_2)
end

PassiveAbilityThornsister._update_extra_abilities_info = function (arg_8_0, arg_8_1)
	if not arg_8_1 then
		return
	end

	local var_8_0 = arg_8_0._career_extension

	if not var_8_0 then
		return
	end

	local var_8_1 = arg_8_0._ability_init_data.max_stacks

	if arg_8_1:has_talent("kerillian_double_passive") then
		var_8_1 = var_8_1 + 1
	end

	var_8_0:update_extra_ability_uses_max(var_8_1)

	local var_8_2 = arg_8_0._ability_init_data.cooldown

	if arg_8_1:has_talent("kerillian_thorn_sister_faster_passive") then
		var_8_2 = var_8_2 * 0.5
	end

	var_8_0:update_extra_ability_charge(var_8_2)
end
