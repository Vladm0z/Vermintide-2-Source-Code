-- chunkname: @scripts/unit_extensions/default_player_unit/buffs/buff_extension.lua

require("scripts/helpers/pseudo_random_distribution")
dofile("scripts/settings/bpc")

local scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_functions = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_functions")
local scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")
local script_data = script_data
local buff_debug = script_data.buff_debug

buff_debug = buff_debug or Development.parameter("buff_debug")
script_data.buff_debug = buff_debug

local function fn(...)
	-- function 1
	if not script_data.debug_synced_buffs then
		print(...)
	end
end

BuffExtension = class(BuffExtension)

local buff_extension_function_params = buff_extension_function_params

buff_extension_function_params = buff_extension_function_params or Script.new_map(15)
buff_extension_function_params = buff_extension_function_params

local tbl = {
	removed = true
}

BuffExtension.init = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	self._unit = arg_2_2
	self.world = arg_2_1.world
	self._breed = arg_2_3.breed
	self._initial_buff_names = arg_2_3.initial_buff_names
	self._buffs = {}
	self._num_buffs = 0
	self._stat_buffs = {}
	self._event_buffs = {}
	self._event_buffs_index = 1
	self._any_buff_removed = false
	self._deactivation_sounds = {}
	self._deactivation_sounds_3p = {}
	self._continuous_screen_effects = {}
	self._deactivation_screen_effects = {}
	self._vfx = {}
	self._vfx_update = {}

	for k, v in pairs(StatBuffApplicationMethods) do
		self._stat_buffs[k] = {}
	end

	for k_2 = 1, #ProcEvents do
		local var_2_0 = ProcEvents[k_2]

		self._event_buffs[var_2_0] = {}
	end

	self.is_server = Managers.player.is_server

	local breed = arg_2_3.breed

	breed = not breed and arg_2_3.breed.is_player

	local is_server

	if not breed then
		is_server = self.is_server

		if not is_server then
			-- Nothing
		end
	end

	is_server = not breed and not arg_2_3.is_husk

	::label_2_0::

	self.is_local = is_server
	self.is_husk = arg_2_3.is_husk
	self.id = 1
	self.individual_stat_buff_index = 1
	self._prd_states = {}
	self._perks = {}
	self._buff_id_refs = {}
	self._stacking_buffs = {}
	self.reset_material_cache = nil
end

BuffExtension.extensions_ready = function (self, arg_3_1, arg_3_2)
	-- function 3
	self:_activate_initial_buffs()

	local get_data = Unit.get_data(arg_3_2, "breed")

	if not (not get_data and get_data.is_player) then
		return
	end

	if not get_data.is_hero then
		local get_player_group_buffs = Managers.state.entity:system("buff_system"):get_player_group_buffs()
		local count = #get_player_group_buffs

		if count > 0 then
			for i = 1, count do
				local var_3_3 = get_player_group_buffs[i]
				local group_buff_template_name = var_3_3.group_buff_template_name
				local buff_per_instance = GroupBuffTemplates[group_buff_template_name].buff_per_instance

				var_3_3.recipients[arg_3_2] = self:add_buff(buff_per_instance)
			end
		end
	end

	if self._num_buffs > 0 then
		Managers.state.entity:system("buff_system"):set_buff_ext_active(self._unit, true)
	end

	self.debug_buff_names = {}
end

BuffExtension.destroy = function (self)
	-- function 4
	self:clear()
end

BuffExtension.freeze = function (self)
	-- function 5
	self:clear()

	self._ai_frozen = true
end

BuffExtension.unfreeze = function (self)
	-- function 6
	self._ai_frozen = nil
end

BuffExtension.clear = function (self)
	-- function 7
	local _buffs = self._buffs
	local time = Managers.time:time("game")
	local buff_extension_function_params = buff_extension_function_params

	buff_extension_function_params.t = time
	buff_extension_function_params.end_time = time

	for i = 1, self._num_buffs do
		local var_7_3 = _buffs[i]

		if not var_7_3.removed then
			buff_extension_function_params.bonus = var_7_3.bonus
			buff_extension_function_params.multiplier = var_7_3.multiplier
			buff_extension_function_params.value = var_7_3.value
			buff_extension_function_params.attacker_unit = var_7_3.attacker_unit
			buff_extension_function_params.source_attacker_unit = var_7_3.source_attacker_unit

			self:_remove_sub_buff(var_7_3, i, buff_extension_function_params, false)
		end
	end

	table.clear(_buffs)
	table.clear(self._perks)
	table.clear(self._buff_id_refs)
	table.clear(self._stacking_buffs)

	self._num_buffs = 0
	self._id_to_local_sync = nil
	self._local_sync_to_id = nil
	self._synced_buff_owner = nil
	self._buff_to_sync_type = nil
	self._id_to_server_sync = nil
	self._server_sync_to_id = nil
	self._remove_buff_queue = nil

	if not self._shared_buff_units then
		for k, v in pairs(self._shared_buff_units) do
			if not ALIVE[v] then
				Managers.state.unit_spawner:mark_for_deletion(v)
			end
		end

		self._shared_buff_units = nil
	end

	Managers.state.entity:system("buff_system"):set_buff_ext_active(self._unit, false)
end

BuffExtension.add_buff = function (self, arg_8_1, arg_8_2)
	-- function 8
	local _unit = self._unit

	if FROZEN[_unit] or not self._ai_frozen then
		return
	end

	local _buffs = self._buffs
	local get_buff_template = BuffUtils.get_buff_template(arg_8_1)
	local buffs = get_buff_template.buffs
	local _hot_join_sync_buff_age

	if not arg_8_2 then
		_hot_join_sync_buff_age = arg_8_2._hot_join_sync_buff_age

		if not _hot_join_sync_buff_age then
			-- Nothing
		end
	end

	_hot_join_sync_buff_age = 0

	::label_8_0::

	local num = Managers.time:time("game") - _hot_join_sync_buff_age
	local claim_buff_id = self:claim_buff_id(arg_8_1)
	local world = self.world
	local is_server = self.is_server
	local var_8_9
	local create_parent_buff_shared_table = get_buff_template.create_parent_buff_shared_table

	create_parent_buff_shared_table = not create_parent_buff_shared_table and {}

	local num_2 = 0

	for i = 1, #buffs do
		repeat
			local var_8_12 = buffs[i]
			local apply_condition = var_8_12.apply_condition

			if not (not apply_condition and apply_condition(_unit, var_8_12, arg_8_2)) then
				break
			end

			local duration = var_8_12.duration
			local ticks = var_8_12.ticks
			local update_frequency = var_8_12.update_frequency
			local max_stacks_func

			if not var_8_12.max_stacks_func then
				max_stacks_func = var_8_12.max_stacks_func(self._unit, var_8_12)

				if not max_stacks_func then
					-- Nothing
				end
			end

			max_stacks_func = var_8_12.max_stacks

			::label_8_1::

			local var_8_18 = max_stacks_func
			local bonus = var_8_12.bonus
			local value = var_8_12.value
			local multiplier = var_8_12.multiplier
			local proc_chance = var_8_12.proc_chance
			local proc_cooldown = var_8_12.proc_cooldown
			local range = var_8_12.range
			local var_8_25
			local var_8_26
			local var_8_27
			local var_8_28

			if not arg_8_2 then
				local variable_value = arg_8_2.variable_value

				if not variable_value then
					local variable_bonus = var_8_12.variable_bonus

					if not variable_bonus then
						local count

						if variable_value == 1 then
							count = #variable_bonus

							if not count then
								-- Nothing
							end
						end

						count = 1 + math.floor(variable_value / (1 / #variable_bonus))

						::label_8_2::

						bonus = variable_bonus[count]
					end

					local variable_bonus_max = var_8_12.variable_bonus_max

					if not variable_bonus_max then
						bonus = math.lerp(0, variable_bonus_max, variable_value)
					end

					local variable_multiplier = var_8_12.variable_multiplier

					if not variable_multiplier then
						local var_8_34 = variable_multiplier[1]
						local var_8_35 = variable_multiplier[2]

						multiplier = math.lerp(var_8_34, var_8_35, variable_value)
					end

					local variable_multiplier_max = var_8_12.variable_multiplier_max

					if not variable_multiplier_max then
						multiplier = math.lerp(0, variable_multiplier_max, variable_value)
					end
				end

				bonus = arg_8_2.external_optional_bonus or bonus
				multiplier = arg_8_2.external_optional_multiplier or multiplier
				value = arg_8_2.external_optional_value or value
				proc_chance = arg_8_2.external_optional_proc_chance or proc_chance
				duration = arg_8_2.external_optional_duration or duration
				ticks = arg_8_2.external_optional_ticks or ticks
				range = arg_8_2.external_optional_range or range
				var_8_25 = arg_8_2.damage_source or var_8_25
				var_8_26 = arg_8_2.power_level or var_8_26
				var_8_27 = arg_8_2.attacker_unit or var_8_27
				var_8_28 = arg_8_2.source_attacker_unit or var_8_28
			end

			if not var_8_12.duration_modifier_func then
				duration, ticks = var_8_12.duration_modifier_func(_unit, var_8_12, duration, self, arg_8_2)
			end

			local perks = var_8_12.perks

			if not perks and not table.find(perks, scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.burning_balefire) then
				local flag = var_8_28 or var_8_27
				local has_extension = ScriptUnit.has_extension(flag, "buff_system")

				if not (not has_extension and Managers.state.side:is_ally(_unit, flag)) then
					local apply_buffs_to_value = has_extension:apply_buffs_to_value(1, "increased_balefire_dot_duration")

					duration = not duration and duration * apply_buffs_to_value
					ticks = not ticks and math.floor(ticks * apply_buffs_to_value)
					update_frequency = not update_frequency and update_frequency * apply_buffs_to_value
				end
			end

			local flag_2 = not duration and num + duration

			if not (not var_8_18 and self:_add_stacking_buff(var_8_12, max_stacks_func, num, duration, flag_2, arg_8_2)) then
				break
			end

			local refresh_duration_of_buffs_on_apply = var_8_12.refresh_duration_of_buffs_on_apply

			if not refresh_duration_of_buffs_on_apply then
				for j = 1, #refresh_duration_of_buffs_on_apply do
					local var_8_43 = refresh_duration_of_buffs_on_apply[j]
					local get_stacking_buff = self:get_stacking_buff(var_8_43)

					if not get_stacking_buff then
						for k = 1, #get_stacking_buff do
							local var_8_45 = get_stacking_buff[k]

							self:_refresh_duration(var_8_45, num, var_8_45.duration, num + var_8_45.duration, arg_8_2, var_8_45.template)
						end
					else
						local get_buff_type = self:get_buff_type(var_8_43)

						if not get_buff_type then
							self:_refresh_duration(get_buff_type, num, get_buff_type.duration, num + get_buff_type.duration, arg_8_2, get_buff_type.template)
						end
					end
				end
			end

			local tbl = {
				id = claim_buff_id,
				start_time = num,
				template = var_8_12,
				buff_type = var_8_12.name,
				buff_template_name = arg_8_1,
				bonus = bonus,
				multiplier = multiplier,
				value = value,
				proc_chance = proc_chance,
				proc_cooldown = proc_cooldown,
				duration = duration,
				ticks = ticks
			}
			local flag_3

			flag_3 = not ticks and 0 and nil
			tbl.current_ticks = flag_3
			tbl.update_frequency = update_frequency
			tbl.range = range
			tbl.damage_source = var_8_25
			tbl.power_level = var_8_26
			tbl.attacker_unit = var_8_27
			tbl.source_attacker_unit = var_8_28
			tbl.max_stacks = max_stacks_func
			tbl.parent_buff_shared_table = create_parent_buff_shared_table
			var_8_9 = var_8_9 or tbl
			self._num_buffs = self._num_buffs + 1
			_buffs[self._num_buffs] = tbl
			num_2 = num_2 + 1

			if not var_8_18 then
				local var_8_49 = self._stacking_buffs[var_8_12.name]

				if not var_8_49 then
					var_8_49 = {}
					self._stacking_buffs[var_8_12.name] = var_8_49

					local var_8_50 = StackingBuffFunctions[var_8_12.on_stack_buff_first_add]

					if not var_8_50 then
						var_8_50(self._unit, var_8_12, arg_8_2)
					end
				end

				var_8_49[#var_8_49 + 1] = tbl
			end

			if not perks then
				for l = 1, #perks do
					local var_8_51 = perks[l]
					local var_8_52 = self._perks[var_8_51]

					var_8_52 = var_8_52 or 0

					if var_8_52 == 0 then
						local var_8_53 = scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_functions[var_8_51]

						if not var_8_53 and not var_8_53.added then
							var_8_53.added(self, _unit, tbl, is_server)
						end
					end

					self._perks[var_8_51] = var_8_52 + 1
				end
			end

			if not var_8_12.buff_area then
				local unit_spawner = Managers.state.unit_spawner
				local side_by_unit = Managers.state.side.side_by_unit
				local var_8_56 = side_by_unit[var_8_28]

				var_8_56 = var_8_56 or side_by_unit[_unit]

				local tbl_2 = {}
				local tbl_3 = {
					duration = duration,
					radius = var_8_12.area_radius,
					sub_buff_template = var_8_12,
					sub_buff_id = i,
					owner_unit = _unit,
					source_unit = var_8_28
				}
				local side_id

				if not var_8_56 then
					side_id = var_8_56.side_id

					if not side_id then
						-- Nothing
					end
				end

				side_id = 0

				::label_8_3::

				tbl_3.side_id = side_id
				tbl_2.buff_area_system = tbl_3

				local buff_area_position

				if not arg_8_2 then
					buff_area_position = arg_8_2.buff_area_position

					if not buff_area_position then
						-- Nothing
					end
				end

				buff_area_position = POSITION_LOOKUP[self._unit]

				::label_8_4::

				tbl.area_buff_unit = unit_spawner:spawn_network_unit(var_8_12.area_unit_name, "buff_aoe_unit", tbl_2, buff_area_position, Quaternion.identity(), nil)
			end

			if not var_8_12.status_effect then
				Managers.state.status_effect:set_status(_unit, var_8_12.status_effect, tbl, true)
			end

			local apply_buff_func = var_8_12.apply_buff_func

			if not apply_buff_func then
				buff_extension_function_params.bonus = bonus
				buff_extension_function_params.multiplier = multiplier
				buff_extension_function_params.value = value
				buff_extension_function_params.t = num
				buff_extension_function_params.end_time = flag_2
				buff_extension_function_params.attacker_unit = tbl.attacker_unit
				buff_extension_function_params.source_attacker_unit = tbl.source_attacker_unit

				BuffFunctionTemplates.functions[apply_buff_func](_unit, tbl, buff_extension_function_params, world)
			end

			if not var_8_12.delayed_apply_buff_func then
				local _delayed_apply_funcs = self._delayed_apply_funcs

				_delayed_apply_funcs = _delayed_apply_funcs or {}
				_delayed_apply_funcs[#_delayed_apply_funcs + 1] = tbl
				self._delayed_apply_funcs = _delayed_apply_funcs
			end

			if not var_8_12.stat_buff then
				tbl.stat_buff_index = self:_add_stat_buff(var_8_12, tbl)
			end

			local event = var_8_12.event

			if not event then
				tbl.buff_func = var_8_12.buff_func

				local _event_buffs_index = self._event_buffs_index

				tbl.event_buff_index = _event_buffs_index
				self._event_buffs[event][_event_buffs_index] = tbl
				self._event_buffs_index = _event_buffs_index + 1
			end

			if not var_8_12.duration_end_func then
				tbl.delayed_remove_func_name = var_8_12.duration_end_func
			end

			if not var_8_12.continuous_effect then
				self._continuous_screen_effects[claim_buff_id] = self:_play_screen_effect(var_8_12.continuous_effect)
			end

			local particles = var_8_12.particles

			if not particles then
				local var_8_66 = _unit
				local flag_4 = false

				if not (not self.is_local and self.is_husk) then
					local has_extension_2 = ScriptUnit.has_extension(var_8_66, "first_person_system")

					if not has_extension_2 and not has_extension_2.first_person_unit then
						var_8_66 = has_extension_2.first_person_unit
						flag_4 = true
					end
				end

				local create_attached_particles = BuffUtils.create_attached_particles(world, particles, var_8_66, flag_4, _unit, flag_2)

				self._vfx[claim_buff_id] = create_attached_particles

				if not create_attached_particles.update_fx then
					self._vfx_update[claim_buff_id] = create_attached_particles
				end
			end

			local sfx = var_8_12.sfx

			if not sfx then
				local activation_sound = sfx.activation_sound

				if not activation_sound then
					self:_play_buff_sound(activation_sound, sfx.activation_sound_3p)
				end
			end
		until true
	end

	local activation_sound_2 = get_buff_template.activation_sound

	if not activation_sound_2 then
		self:_play_buff_sound(activation_sound_2, get_buff_template.activation_sound_3p)
	end

	local activation_effect = get_buff_template.activation_effect

	if not activation_effect then
		self:_play_screen_effect(activation_effect)
	end

	if num_2 > 0 then
		if self._num_buffs == num_2 then
			Managers.state.entity:system("buff_system"):set_buff_ext_active(_unit, true)
		end

		self._buff_id_refs[claim_buff_id] = num_2

		local deactivation_effect = get_buff_template.deactivation_effect

		if not deactivation_effect then
			self._deactivation_screen_effects[claim_buff_id] = deactivation_effect
		end

		local deactivation_sound = get_buff_template.deactivation_sound

		if not deactivation_sound then
			self._deactivation_sounds[claim_buff_id] = deactivation_sound

			if not get_buff_template.activation_sound_3p then
				self._deactivation_sounds_3p[claim_buff_id] = get_buff_template.activation_sound_3p
			end
		end
	end

	return claim_buff_id, num_2, var_8_9
end

BuffExtension._add_stacking_buff = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6)
	-- function 9
	local var_9_0 = self._stacking_buffs[arg_9_1.name]
	local count

	if not var_9_0 then
		count = #var_9_0

		if not count then
			-- Nothing
		end
	end

	count = 0

	::label_9_0::

	if not arg_9_4 then
		local refresh_durations_func

		if not arg_9_1.refresh_durations_func then
			refresh_durations_func = arg_9_1.refresh_durations_func(self._unit, arg_9_1)

			if not refresh_durations_func then
				-- Nothing
			end
		end

		refresh_durations_func = arg_9_1.refresh_durations

		::label_9_1::

		if not refresh_durations_func then
			for i = 1, count do
				local var_9_3 = var_9_0[i]

				self:_refresh_duration(var_9_3, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_1)
			end
		end
	end

	if not arg_9_1.refresh_buff_area_position then
		for j = 1, count do
			local area_buff_unit = var_9_0[j].area_buff_unit

			if not area_buff_unit then
				local has_extension = ScriptUnit.has_extension(area_buff_unit, "buff_area_system")

				if not has_extension then
					has_extension:set_unit_position(POSITION_LOOKUP[self._unit])
				end
			end
		end
	end

	if not (not arg_9_6 and not arg_9_6.refresh_duration_only and not (count > 0)) then
		return false
	end

	local flag = true

	if arg_9_2 <= count then
		local var_9_7 = StackingBuffFunctions[arg_9_1.on_max_stacks_overflow_func]

		if not var_9_7 then
			local flag_2 = true

			arg_9_6 = arg_9_6 or FrameTable.alloc_table()
			flag = not flag and var_9_7(self._unit, arg_9_1, arg_9_6, flag_2)
		else
			flag = false
		end
	elseif count == arg_9_2 - 1 then
		local var_9_9 = StackingBuffFunctions[arg_9_1.on_max_stacks_func]

		if not var_9_9 then
			var_9_9(self._unit, arg_9_1, arg_9_6)
		end

		local reset_on_max_stacks_func

		if not arg_9_1.reset_on_max_stacks_func then
			reset_on_max_stacks_func = arg_9_1.reset_on_max_stacks_func(self._unit, arg_9_1)

			if not reset_on_max_stacks_func then
				-- Nothing
			end
		end

		reset_on_max_stacks_func = arg_9_1.reset_on_max_stacks

		::label_9_2::

		if not reset_on_max_stacks_func then
			local _buffs = self._buffs

			for k = 1, self._num_buffs do
				local var_9_12 = _buffs[k]

				if var_9_12.buff_type == arg_9_1.name then
					buff_extension_function_params.bonus = var_9_12.bonus
					buff_extension_function_params.multiplier = var_9_12.multiplier
					buff_extension_function_params.value = var_9_12.value
					buff_extension_function_params.t = arg_9_3

					local buff_extension_function_params = buff_extension_function_params
					local duration = var_9_12.duration

					duration = not duration and var_9_12.start_time + var_9_12.duration
					buff_extension_function_params.end_time = duration
					buff_extension_function_params.attacker_unit = var_9_12.attacker_unit
					buff_extension_function_params.source_attacker_unit = var_9_12.source_attacker_unit

					self:_remove_sub_buff(var_9_12, k, buff_extension_function_params, true)
				end
			end

			flag = false
		end
	end

	return flag
end

BuffExtension._refresh_duration = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6)
	-- function 10
	if not arg_10_1.area_buff_unit then
		local has_extension = ScriptUnit.has_extension(arg_10_1.area_buff_unit, "buff_area_system")

		if not has_extension then
			has_extension:set_duration(arg_10_3)
		end
	end

	arg_10_1.start_time = arg_10_2
	arg_10_1.duration = arg_10_3
	arg_10_1.end_time = arg_10_4

	local attacker_unit

	if not arg_10_5 then
		attacker_unit = arg_10_5.attacker_unit

		if not attacker_unit then
			-- Nothing
		end
	end

	attacker_unit = nil

	::label_10_0::

	arg_10_1.attacker_unit = attacker_unit

	local source_attacker_unit

	if not arg_10_5 then
		source_attacker_unit = arg_10_5.source_attacker_unit

		if not source_attacker_unit then
			-- Nothing
		end
	end

	source_attacker_unit = nil

	::label_10_1::

	arg_10_1.source_attacker_unit = source_attacker_unit

	local reapply_buff_func = arg_10_6.reapply_buff_func

	if not reapply_buff_func then
		buff_extension_function_params.bonus = arg_10_1.bonus
		buff_extension_function_params.multiplier = arg_10_1.multiplier
		buff_extension_function_params.value = arg_10_1.value
		buff_extension_function_params.t = arg_10_2
		buff_extension_function_params.end_time = arg_10_4
		buff_extension_function_params.attacker_unit = arg_10_1.attacker_unit
		buff_extension_function_params.source_attacker_unit = arg_10_1.source_attacker_unit

		local world = self.world

		BuffFunctionTemplates.functions[reapply_buff_func](self._unit, arg_10_1, buff_extension_function_params, world)
	end
end

BuffExtension._add_stat_buff = function (self, arg_11_1, arg_11_2)
	-- function 11
	if FROZEN[self._unit] or not self._ai_frozen then
		return
	end

	local bonus = arg_11_2.bonus

	bonus = bonus or 0

	local multiplier = arg_11_2.multiplier

	multiplier = multiplier or 0

	local proc_chance = arg_11_2.proc_chance

	proc_chance = proc_chance or 1

	local value = arg_11_2.value
	local _stat_buffs = self._stat_buffs
	local stat_buff = arg_11_1.stat_buff
	local var_11_6 = _stat_buffs[stat_buff]
	local var_11_7 = StatBuffApplicationMethods[stat_buff]

	if not arg_11_1.wind_mutator then
		local get_wind_strength = Managers.weave:get_wind_strength()
		local get_difficulty = Managers.state.difficulty:get_difficulty()
		local get_active_wind_settings = Managers.weave:get_active_wind_settings()

		if not get_active_wind_settings and not get_difficulty and not get_wind_strength then
			multiplier = get_active_wind_settings[arg_11_1.stat_buff][get_difficulty][get_wind_strength]
		end
	end

	local var_11_11

	if not (var_11_7 == "proc" or type(multiplier) ~= "function") then
		var_11_11 = self.individual_stat_buff_index
		var_11_6[var_11_11] = {
			bonus = bonus,
			multiplier = multiplier,
			proc_chance = proc_chance
		}
		self.individual_stat_buff_index = var_11_11 + 1
	else
		var_11_11 = var_11_7 ~= "stacking_multiplier_multiplicative" or arg_11_1.stacking_name or not arg_11_1.name or 0

		if not var_11_6[var_11_11] then
			var_11_6[var_11_11] = {
				bonus = bonus,
				multiplier = multiplier,
				proc_chance = proc_chance,
				value = value
			}
		elseif var_11_7 == "stacking_bonus" then
			local bonus_2 = var_11_6[var_11_11].bonus

			var_11_6[var_11_11].bonus = bonus_2 + bonus
		elseif not (var_11_7 == "stacking_multiplier" or var_11_7 ~= "stacking_multiplier_multiplicative") then
			local multiplier_2 = var_11_6[var_11_11].multiplier

			var_11_6[var_11_11].multiplier = multiplier_2 + multiplier
		elseif var_11_7 == "stacking_bonus_and_multiplier" then
			local bonus_3 = var_11_6[var_11_11].bonus
			local multiplier_3 = var_11_6[var_11_11].multiplier

			var_11_6[var_11_11].bonus = bonus_3 + bonus
			var_11_6[var_11_11].multiplier = multiplier_3 + multiplier
		elseif var_11_7 == "min" then
			local var_11_16 = var_11_6[var_11_11]

			if not var_11_16.all_values then
				var_11_16.all_values = {
					var_11_16.value
				}
			end

			var_11_16.all_values[#var_11_16.all_values + 1] = value

			local value_2 = var_11_16.value

			value_2 = value_2 or math.huge
			var_11_16.value = math.min(value_2, value)
		end
	end

	return var_11_11
end

BuffExtension.update = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	-- function 12
	local world = self.world
	local _buffs = self._buffs
	local buff_extension_function_params = buff_extension_function_params

	buff_extension_function_params.t = arg_12_5

	local _delayed_apply_funcs = self._delayed_apply_funcs

	if not _delayed_apply_funcs then
		self._delayed_apply_funcs = nil

		for i = 1, #_delayed_apply_funcs do
			local var_12_4 = _delayed_apply_funcs[i]

			if not var_12_4.is_stale then
				local delayed_apply_buff_func = var_12_4.template.delayed_apply_buff_func

				BuffFunctionTemplates.functions[delayed_apply_buff_func](arg_12_1, var_12_4)
			end
		end
	end

	local _remove_buff_queue = self._remove_buff_queue

	if not _remove_buff_queue then
		self._remove_buff_queue = nil

		for j = 1, #_remove_buff_queue do
			self:remove_buff(_remove_buff_queue[j])
		end
	end

	for k = 1, self._num_buffs do
		local var_12_7 = _buffs[k]

		if not var_12_7.removed then
			local template = var_12_7.template
			local duration = var_12_7.duration

			duration = not duration and var_12_7.start_time + var_12_7.duration

			local ticks = var_12_7.ticks
			local current_ticks = var_12_7.current_ticks

			buff_extension_function_params.bonus = var_12_7.bonus
			buff_extension_function_params.multiplier = var_12_7.multiplier
			buff_extension_function_params.value = var_12_7.value
			buff_extension_function_params.end_time = duration
			buff_extension_function_params.attacker_unit = var_12_7.attacker_unit
			buff_extension_function_params.source_attacker_unit = var_12_7.source_attacker_unit

			local flag = not ticks and ticks <= current_ticks

			if not duration and duration <= arg_12_5 and duration or not flag then
				if not template.remove_buff_on_duration_end then
					self:remove_buff(var_12_7.id)
				else
					self:_remove_sub_buff(var_12_7, k, buff_extension_function_params, true)
				end

				local delayed_remove_func_name = var_12_7.delayed_remove_func_name

				if not (not delayed_remove_func_name and var_12_7.aborted) then
					BuffFunctionTemplates.functions[delayed_remove_func_name](arg_12_1, var_12_7, buff_extension_function_params, world)
				end
			elseif not flag then
				local update_func = template.update_func

				if not update_func then
					local _next_update_t = var_12_7._next_update_t

					if not _next_update_t then
						local update_start_delay = var_12_7.template.update_start_delay

						update_start_delay = update_start_delay or 0
						_next_update_t = arg_12_5 + update_start_delay
						var_12_7._next_update_t = _next_update_t
					end

					if _next_update_t <= arg_12_5 then
						buff_extension_function_params.time_into_buff = arg_12_5 - var_12_7.start_time
						buff_extension_function_params.time_left_on_buff = not duration and duration - arg_12_5

						if not BuffFunctionTemplates.functions[update_func](arg_12_1, var_12_7, buff_extension_function_params, world) then
							-- Nothing
						end

						::label_12_0::

						do
							local update_frequency = var_12_7.update_frequency

							update_frequency = update_frequency or 0

							local num = arg_12_5 + update_frequency
						end

						::label_12_1::

						var_12_7._next_update_t = num

						if not current_ticks then
							var_12_7.current_ticks = current_ticks + 1
						end
					end
				end
			end
		end
	end

	for k_2, v in pairs(self._vfx_update) do
		BuffUtils.update_attached_particles(world, v, arg_12_5)
	end

	local num_2 = 1
	local num_3 = 0

	while num_2 <= self._num_buffs - num_3 do
		_buffs[num_2] = _buffs[num_2 + num_3]

		if not _buffs[num_2] then
			break
		elseif not _buffs[num_2].removed then
			num_3 = num_3 + 1
		else
			num_2 = num_2 + 1
		end
	end

	for i5 = num_2, self._num_buffs do
		_buffs[i5] = nil
	end

	self._num_buffs = self._num_buffs - num_3

	if self._num_buffs == 0 then
		Managers.state.entity:system("buff_system"):set_buff_ext_active(arg_12_1, false)
	end
end

BuffExtension.update_stat_buff = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local var_13_0 = self._stat_buffs[arg_13_1]
	local var_13_1 = StatBuffApplicationMethods[arg_13_1]

	arg_13_3 = arg_13_3 or 0

	if var_13_1 == "stacking_bonus" then
		local bonus = var_13_0[arg_13_3].bonus

		var_13_0[arg_13_3].bonus = bonus + arg_13_2

		return var_13_0[arg_13_3].bonus
	elseif not (var_13_1 == "stacking_multiplier" or var_13_1 ~= "stacking_multiplier_multiplicative") then
		local multiplier = var_13_0[arg_13_3].multiplier

		var_13_0[arg_13_3].multiplier = multiplier + arg_13_2

		return var_13_0[arg_13_3].multiplier
	else
		fassert(false, "trying to update a stat with an incompatible application method")
	end
end

BuffExtension.num_sub_buffs = function (self, arg_14_1)
	-- function 14
	local _buffs = self._buffs
	local find_by_key = table.find_by_key(_buffs, "id", arg_14_1)

	if not find_by_key then
		return -1
	end

	local buff_to_add = _buffs[find_by_key].template.buff_to_add

	if not buff_to_add then
		return -1
	end

	local num = 0

	for i = 1, self._num_buffs do
		if _buffs[i].buff_type == buff_to_add then
			num = num + 1
		end
	end

	return num
end

BuffExtension.remove_buff = function (self, arg_15_1, arg_15_2)
	-- function 15
	if not arg_15_1 then
		return 0
	end

	local _buffs = self._buffs
	local time = Managers.time:time("game")
	local buff_extension_function_params = buff_extension_function_params

	buff_extension_function_params.t = time
	buff_extension_function_params.end_time = time

	local num = 0

	for i = 1, self._num_buffs do
		local var_15_4 = _buffs[i]

		if var_15_4.id == arg_15_1 then
			buff_extension_function_params.bonus = var_15_4.bonus
			buff_extension_function_params.multiplier = var_15_4.multiplier
			buff_extension_function_params.value = var_15_4.value
			buff_extension_function_params.attacker_unit = var_15_4.attacker_unit
			buff_extension_function_params.source_attacker_unit = var_15_4.source_attacker_unit

			self:_remove_sub_buff(var_15_4, i, buff_extension_function_params, false)

			num = num + 1
		end
	end

	if self._num_buffs == 0 then
		Managers.state.entity:system("buff_system"):set_buff_ext_active(self._unit, false)
	end

	if not arg_15_2 then
		self:_remove_buff_synced(arg_15_1)
	end

	self:_free_sync_id(arg_15_1)

	return num
end

BuffExtension.queue_remove_buff = function (self, arg_16_1)
	-- function 16
	local _remove_buff_queue = self._remove_buff_queue

	_remove_buff_queue = _remove_buff_queue or {}
	_remove_buff_queue[#_remove_buff_queue + 1] = arg_16_1
	self._remove_buff_queue = _remove_buff_queue
end

BuffExtension._remove_sub_buff = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	-- function 17
	local world = self.world
	local _buffs = self._buffs
	local template = arg_17_1.template
	local remove_buff_func = template.remove_buff_func
	local buffs_to_remove_on_remove = template.buffs_to_remove_on_remove

	if not remove_buff_func then
		BuffFunctionTemplates.functions[remove_buff_func](self._unit, arg_17_1, arg_17_3, world)
	end

	if not template.status_effect then
		Managers.state.status_effect:set_status(self._unit, template.status_effect, arg_17_1, false)
	end

	if not buffs_to_remove_on_remove then
		for i = 1, #buffs_to_remove_on_remove do
			if arg_17_1.buff_type ~= buffs_to_remove_on_remove[i] then
				for j = 1, self._num_buffs do
					local var_17_5 = _buffs[j]

					if not (not var_17_5 and var_17_5.buff_type ~= buffs_to_remove_on_remove[i]) then
						if not var_17_5.delayed_remove_func_name then
							var_17_5.aborted = true
						end

						self:remove_buff(var_17_5.id)
					end
				end
			end
		end
	end

	if not template.stat_buff then
		self:_remove_stat_buff(arg_17_1)
	end

	local buff_to_add = template.buff_to_add

	if not (not buff_to_add and remove_buff_func == "add_buff") then
		for k = 1, self._num_buffs do
			local var_17_7 = _buffs[k]

			if not (var_17_7.buff_type ~= buff_to_add or var_17_7.duration) then
				var_17_7.duration = 0
				var_17_7.is_stale = true
			end
		end
	end

	local event = template.event

	if not event then
		local event_buff_index = arg_17_1.event_buff_index

		self._event_buffs[event][event_buff_index] = nil
	end

	local perks = template.perks

	if not perks then
		for l = 1, #perks do
			local var_17_11 = perks[l]
			local num = self._perks[var_17_11] - 1

			if num == 0 then
				local var_17_13 = scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_functions[var_17_11]

				if not var_17_13 and not var_17_13.removed then
					var_17_13.removed(self, self._unit, arg_17_1, self.is_server)
				end
			end

			self._perks[var_17_11] = num
		end
	end

	_buffs[arg_17_2] = tbl
	self._any_buff_removed = true

	local max_stacks = template.max_stacks

	max_stacks = max_stacks or template.max_stacks_func

	if not max_stacks then
		local var_17_15 = self._stacking_buffs[arg_17_1.template.name]
		local index_of = table.index_of(var_17_15, arg_17_1)

		if index_of > 0 then
			table.swap_delete(var_17_15, index_of)
		end

		if not template.refresh_other_stacks_on_remove then
			local time = Managers.time:time("game")

			for i4 = 1, #var_17_15 do
				local var_17_18 = var_17_15[i4]
				local var_17_19 = time
				local duration = var_17_18.duration
				local flag = not duration and var_17_19 + duration

				self:_refresh_duration(var_17_18, var_17_19, duration, flag, arg_17_3, template)
			end
		end

		if #var_17_15 == 0 then
			local var_17_22 = StackingBuffFunctions[template.on_last_stack_removed]

			if not var_17_22 then
				var_17_22(self._unit, template, arg_17_3)
			end

			self._stacking_buffs[template.name] = nil
		end
	end

	arg_17_1.is_stale = true

	if self._num_buffs == 0 then
		Managers.state.entity:system("buff_system"):set_buff_ext_active(self._unit, false)
	end

	local id = arg_17_1.id
	local var_17_24 = self._buff_id_refs[id]

	var_17_24 = var_17_24 or 0

	local num_2 = var_17_24 - 1

	if num_2 > 0 then
		self._buff_id_refs[id] = num_2
		arg_17_4 = false
	else
		self._buff_id_refs[id] = nil
	end

	if not arg_17_4 and not self._id_to_local_sync then
		if not (not self._buff_to_sync_type and self._buff_to_sync_type[id] == BuffSyncType.Client or template.duration or template.ticks) then
			self:_remove_buff_synced(id)
		end

		self:_free_sync_id(id)
	end

	local var_17_26 = self._deactivation_sounds[id]

	if not var_17_26 then
		self:_play_buff_sound(var_17_26, self._deactivation_sounds_3p[id])

		self._deactivation_sounds[id] = nil
		self._deactivation_sounds_3p[id] = nil
	end

	local var_17_27 = self._continuous_screen_effects[id]

	if not var_17_27 then
		self:_stop_screen_effect(var_17_27)

		self._continuous_screen_effects[id] = nil
	end

	local var_17_28 = self._deactivation_screen_effects[id]

	if not var_17_28 then
		self:_play_screen_effect(var_17_28)

		self._deactivation_screen_effects[id] = nil
	end

	if not (not max_stacks and self._stacking_buffs[arg_17_1.template.name]) then
		local var_17_29 = self._vfx[id]

		if not var_17_29 then
			BuffUtils.destroy_attached_particles(world, var_17_29)

			self._vfx[id] = nil
			self._vfx_update[id] = nil
		end
	end
end

BuffExtension._remove_stat_buff = function (self, arg_18_1)
	-- function 18
	local template = arg_18_1.template
	local bonus = arg_18_1.bonus

	bonus = bonus or 0

	local multiplier = arg_18_1.multiplier

	multiplier = multiplier or 0

	local value = arg_18_1.value
	local stat_buff = template.stat_buff
	local var_18_5 = self._stat_buffs[stat_buff]
	local var_18_6 = StatBuffApplicationMethods[stat_buff]

	if not template.wind_mutator then
		local get_wind_strength = Managers.weave:get_wind_strength()
		local get_difficulty = Managers.state.difficulty:get_difficulty()
		local get_active_wind_settings = Managers.weave:get_active_wind_settings()

		if not get_active_wind_settings and not get_difficulty and not get_wind_strength then
			multiplier = get_active_wind_settings[template.stat_buff][get_difficulty][get_wind_strength]
		end
	end

	local stat_buff_index = arg_18_1.stat_buff_index

	if not (var_18_6 == "proc" or type(var_18_5[stat_buff_index].multiplier) ~= "function") then
		var_18_5[stat_buff_index] = nil
	elseif var_18_6 == "stacking_bonus" then
		local bonus_2 = var_18_5[stat_buff_index].bonus

		var_18_5[stat_buff_index].bonus = bonus_2 - bonus
	elseif not (var_18_6 == "stacking_multiplier" or var_18_6 ~= "stacking_multiplier_multiplicative") then
		local multiplier_2 = var_18_5[stat_buff_index].multiplier

		var_18_5[stat_buff_index].multiplier = multiplier_2 - multiplier
	elseif var_18_6 == "stacking_bonus_and_multiplier" then
		local bonus_3 = var_18_5[stat_buff_index].bonus
		local multiplier_3 = var_18_5[stat_buff_index].multiplier

		var_18_5[stat_buff_index].bonus = bonus_3 - bonus
		var_18_5[stat_buff_index].multiplier = multiplier_3 - multiplier
	elseif var_18_6 == "min" then
		local var_18_15 = var_18_5[stat_buff_index]

		if not var_18_15.all_values then
			local index_of = table.index_of(var_18_15.all_values, value)

			fassert(index_of ~= -1, "buff needs to be there when removed, if it's not then something went wrong")
			table.swap_delete(var_18_15.all_values, index_of)

			if #var_18_15.all_values == 0 then
				var_18_15.value = nil
			else
				var_18_15.value = var_18_15.all_values[1]

				for i, v in ipairs(var_18_15.all_values) do
					var_18_15.value = math.min(var_18_15.value, v)
				end
			end
		else
			fassert(var_18_15.value == value, "buff needs to be there when removed, if it's not then something went wrong")

			var_18_15.value = nil
		end
	end
end

BuffExtension.get_buff_type = function (self, arg_19_1)
	-- function 19
	local _buffs = self._buffs

	for i = 1, self._num_buffs do
		local var_19_1 = _buffs[i]

		if var_19_1.buff_type == arg_19_1 then
			return var_19_1
		end
	end

	return nil
end

BuffExtension.get_buff_by_id = function (self, arg_20_1)
	-- function 20
	if not arg_20_1 then
		return nil
	end

	local _buffs = self._buffs

	for i = 1, self._num_buffs do
		local var_20_1 = _buffs[i]

		if var_20_1.id == arg_20_1 then
			return var_20_1
		end
	end

	return nil
end

BuffExtension.has_buff_type = function (self, arg_21_1)
	-- function 21
	local _buffs = self._buffs

	for i = 1, self._num_buffs do
		if _buffs[i].buff_type == arg_21_1 then
			return true
		end
	end

	return false
end

BuffExtension.has_buff_perk = function (self, arg_22_1)
	-- function 22
	local var_22_0 = self._perks[arg_22_1]

	return not var_22_0 and var_22_0 > 0
end

BuffExtension.num_buff_perk = function (self, arg_23_1)
	-- function 23
	local var_23_0 = self._perks[arg_23_1]

	var_23_0 = var_23_0 or 0

	return var_23_0
end

BuffExtension.get_non_stacking_buff = function (self, arg_24_1)
	-- function 24
	local _buffs = self._buffs

	for i = 1, self._num_buffs do
		local var_24_1 = _buffs[i]

		if var_24_1.buff_type == arg_24_1 then
			fassert(var_24_1.max_stacks == 1, "Tried getting a stacking buff!")

			return var_24_1
		end
	end

	return nil
end

BuffExtension.get_stacking_buff = function (self, arg_25_1)
	-- function 25
	return self._stacking_buffs[arg_25_1]
end

BuffExtension.num_buff_stacks = function (self, arg_26_1)
	-- function 26
	local var_26_0 = self._stacking_buffs[arg_26_1]
	local count

	if not var_26_0 then
		count = #var_26_0

		if not count then
			-- Nothing
		end
	end

	count = 0

	::label_26_0::

	return count
end

BuffExtension.num_buff_type = function (self, arg_27_1)
	-- function 27
	local var_27_0 = self._stacking_buffs[arg_27_1]

	if not var_27_0 then
		return #var_27_0
	end

	local _buffs = self._buffs
	local num = 0

	for i = 1, self._num_buffs do
		if _buffs[i].buff_type == arg_27_1 then
			num = num + 1
		end
	end

	return num
end

BuffExtension.has_procced = function (self, arg_28_1, arg_28_2)
	-- function 28
	local _prd_states = self._prd_states
	local var_28_1
	local var_28_2 = _prd_states[arg_28_2]
	local flip_coin, var_28_4 = PseudoRandomDistribution.flip_coin(var_28_2, arg_28_1)

	_prd_states[arg_28_2] = var_28_4

	return flip_coin
end

local function fn_2(self, arg_29_1)
	-- function 29
	return self.proc_weight > arg_29_1.proc_weight
end

local function fn_3(self, arg_30_1, arg_30_2)
	-- function 30
	local authority = self.template.authority

	return (not authority and authority ~= "server" or not arg_30_1 or authority ~= "client") and arg_30_2
end

BuffExtension.trigger_procs = function (self, arg_31_1, ...)
	-- function 31
	local var_31_0 = self._event_buffs[arg_31_1]

	if table.size(var_31_0) == 0 then
		return
	end

	local is_server = self.is_server
	local is_local = self.is_local
	local world = self.world
	local var_31_4 = select("#", ...)
	local time = Managers.time:time("game")
	local alloc_table = FrameTable.alloc_table()
	local alloc_table_2 = FrameTable.alloc_table()

	for i = 1, var_31_4 do
		alloc_table[i] = select(i, ...)
	end

	local num = 1
	local alloc_table_3 = FrameTable.alloc_table()

	for k, v in pairs(var_31_0) do
		local proc_chance = v.proc_chance

		proc_chance = proc_chance or 1

		if not fn_3(v, is_server, is_local) then
			local _next_proc_t = v._next_proc_t

			_next_proc_t = _next_proc_t or 0

			if not (_next_proc_t < time) or not self:has_procced(proc_chance, v) then
				local proc_cooldown = v.template.proc_cooldown

				proc_cooldown = not proc_cooldown and v.template.proc_cooldown + time
				v._next_proc_t = proc_cooldown

				local proc_weight = v.template.proc_weight

				proc_weight = proc_weight or 0
				alloc_table_3[num] = {
					buff = v,
					proc_weight = proc_weight
				}
				num = num + 1
			end
		end
	end

	table.sort(alloc_table_3, fn_2)

	local _unit = self._unit

	for l = 1, #alloc_table_3 do
		local buff = alloc_table_3[l].buff
		local buff_func = buff.buff_func
		local var_31_17 = ProcFunctions[buff_func]

		if not (not var_31_17 and var_31_17(_unit, buff, alloc_table, world, ProcEventParams[arg_31_1])) and not buff.template.remove_on_proc then
			alloc_table_2[#alloc_table_2 + 1] = buff
		end
	end

	for i4 = 1, #alloc_table_2 do
		local id = alloc_table_2[i4].id

		self:remove_buff(id)
	end
end

BuffExtension.get_buff_value = function (self, arg_32_1)
	-- function 32
	local var_32_0 = self._stat_buffs[arg_32_1]
	local flag = false
	local flag_2 = StatBuffApplicationMethods[arg_32_1] == "proc"
	local var_32_3
	local var_32_4

	for k, v in pairs(var_32_0) do
		if v.proc_chance >= math.random() then
			var_32_3 = v.value

			if not flag_2 then
				flag = true
				var_32_4 = v.id

				break
			end
		end
	end

	return var_32_3, flag, var_32_4
end

BuffExtension.apply_buffs_to_value = function (self, arg_33_1, arg_33_2)
	-- function 33
	local var_33_0 = self._stat_buffs[arg_33_2]
	local var_33_1 = arg_33_1
	local flag = false
	local flag_2 = StatBuffApplicationMethods[arg_33_2] == "proc"
	local var_33_4
	local num = 1
	local num_2 = 0

	for k, v in pairs(var_33_0) do
		local proc_chance = v.proc_chance

		if not self:has_procced(proc_chance, arg_33_2) then
			local bonus = v.bonus
			local multiplier = v.multiplier
			local var_33_10 = type(multiplier)

			if var_33_10 == "function" then
				multiplier = multiplier(self._unit, self)

				local var_33_11 = StatBuffApplicationMethods[arg_33_2]

				if not (var_33_11 == "stacking_multiplier" or var_33_11 ~= "stacking_multiplier_multiplicative") then
					num = num + multiplier
					var_33_1 = var_33_1 + bonus
				elseif var_33_11 == "stacking_bonus_and_multiplier" then
					num_2 = num_2 + bonus
					num = num + multiplier
				end
			else
				if var_33_10 == "table" then
					multiplier = multiplier[Managers.weave:get_wind_strength()]
				end

				if k == 0 then
					num = num + multiplier
					num_2 = num_2 + bonus
				else
					var_33_1 = var_33_1 * (multiplier + 1) + bonus
				end
			end

			if not flag_2 then
				flag = true
				var_33_4 = v.id

				break
			end
		end
	end

	return var_33_1 * num + num_2, flag, var_33_4
end

BuffExtension._play_buff_sound = function (self, arg_34_1, arg_34_2)
	-- function 34
	local _unit = self._unit

	if not arg_34_2 then
		Managers.state.entity:system("audio_system"):play_audio_unit_event(arg_34_1, _unit)
	elseif not ScriptUnit.has_extension(_unit, "first_person_system") then
		ScriptUnit.extension(_unit, "first_person_system"):play_hud_sound_event(arg_34_1)
	end
end

BuffExtension._play_screen_effect = function (self, arg_35_1)
	-- function 35
	local _unit = self._unit

	if not ScriptUnit.has_extension(_unit, "first_person_system") then
		return (ScriptUnit.extension(_unit, "first_person_system"):create_screen_particles(arg_35_1))
	end

	return nil
end

BuffExtension._stop_screen_effect = function (self, arg_36_1)
	-- function 36
	local _unit = self._unit

	if not arg_36_1 and not ScriptUnit.has_extension(_unit, "first_person_system") then
		ScriptUnit.extension(_unit, "first_person_system"):stop_spawning_screen_particles(arg_36_1)
	end
end

BuffExtension.active_buffs = function (self)
	-- function 37
	return self._buffs, self._num_buffs
end

BuffExtension.initial_buff_names = function (self)
	-- function 38
	return self._initial_buff_names
end

BuffExtension.get_persistent_buff_names = function (self)
	-- function 39
	local tbl = {}

	for k, v in pairs(self._buffs) do
		local template = v.template

		if not template.is_persistent then
			table.insert(tbl, template.name)
		end
	end

	return tbl
end

BuffExtension._activate_initial_buffs = function (self)
	-- function 40
	local _initial_buff_names = self._initial_buff_names

	if not _initial_buff_names then
		for i, v in ipairs(_initial_buff_names) do
			self:add_buff(v)
		end
	end
end

BuffExtension.set_pending_sync_id = function (self, arg_41_1, arg_41_2, arg_41_3)
	-- function 41
	self:_initalize_sync_tables()

	self._id_to_local_sync[arg_41_1] = arg_41_2
	self._local_sync_to_id[arg_41_2] = arg_41_1
	self._buff_to_sync_type[arg_41_1] = arg_41_3
end

BuffExtension.apply_sync_id = function (self, arg_42_1, arg_42_2)
	-- function 42
	local _local_sync_to_id = self._local_sync_to_id

	_local_sync_to_id = not _local_sync_to_id and self._local_sync_to_id[arg_42_1]

	if not _local_sync_to_id then
		self:_initalize_sync_tables()

		self._id_to_server_sync[_local_sync_to_id] = arg_42_2
		self._server_sync_to_id[arg_42_2] = _local_sync_to_id

		return true
	end

	return false
end

BuffExtension.apply_remote_sync_id = function (self, arg_43_1, arg_43_2, arg_43_3, arg_43_4)
	-- function 43
	if not arg_43_1 then
		self:_initalize_sync_tables()

		self._id_to_server_sync[arg_43_1] = arg_43_2
		self._server_sync_to_id[arg_43_2] = arg_43_1
		self._buff_to_sync_type[arg_43_1] = arg_43_3
		self._synced_buff_owner[arg_43_1] = arg_43_4
	end
end

BuffExtension.generate_sync_id = function (self)
	-- function 44
	local var_44_0
	local _free_sync_ids = self._free_sync_ids

	if not _free_sync_ids then
		var_44_0 = _free_sync_ids[1]

		if not var_44_0 then
			if not self.debug_buff_names then
				table.dump(table.select_map(self._local_sync_to_id, function (arg_45_0, arg_45_1)
					-- function 45
					return string.format("(id: %s) %s", arg_45_0, self.debug_buff_names[arg_45_1])
				end), "Synced Buffs")
			else
				print("[BuffExtension] Not a player")
			end

			error("[BuffExtension] Too many synced buffs, no free sync ids left!")
		end

		table.swap_delete(_free_sync_ids, 1)
	else
		var_44_0 = self._next_sync_id or 1

		if var_44_0 > NetworkConstants.server_controlled_buff_id.max then
			self:_build_free_sync_ids_array()

			return self:generate_sync_id()
		else
			self._next_sync_id = var_44_0 + 1
		end
	end

	return var_44_0
end

BuffExtension.claim_buff_id = function (self, arg_46_1)
	-- function 46
	local id = self.id

	self.id = id + 1

	if not self.debug_buff_names then
		self.debug_buff_names[id] = arg_46_1
	end

	return id
end

BuffExtension.sync_id_to_id = function (self, arg_47_1)
	-- function 47
	local _server_sync_to_id = self._server_sync_to_id

	_server_sync_to_id = not _server_sync_to_id and self._server_sync_to_id[arg_47_1]

	return _server_sync_to_id
end

BuffExtension.id_to_sync_id = function (self, arg_48_1)
	-- function 48
	local _id_to_server_sync = self._id_to_server_sync

	_id_to_server_sync = not _id_to_server_sync and self._id_to_server_sync[arg_48_1]

	return _id_to_server_sync
end

BuffExtension.buff_sync_type = function (self, arg_49_1)
	-- function 49
	return self._buff_to_sync_type[arg_49_1]
end

BuffExtension._free_sync_id = function (self, arg_50_1)
	-- function 50
	local _buff_to_sync_type = self._buff_to_sync_type

	if not (not _buff_to_sync_type and _buff_to_sync_type[arg_50_1]) then
		return
	end

	local var_50_1 = self._id_to_local_sync[arg_50_1]

	if not var_50_1 then
		self._local_sync_to_id[var_50_1] = nil

		local _free_sync_ids = self._free_sync_ids

		if not _free_sync_ids then
			_free_sync_ids[#_free_sync_ids + 1] = var_50_1
		end
	end

	local var_50_3 = self._id_to_server_sync[arg_50_1]

	if not var_50_3 then
		self._server_sync_to_id[var_50_3] = nil
	end

	self._id_to_local_sync[arg_50_1] = nil
	self._id_to_server_sync[arg_50_1] = nil
	self._buff_to_sync_type[arg_50_1] = nil
	self._synced_buff_owner[arg_50_1] = nil
end

BuffExtension._build_free_sync_ids_array = function (self)
	-- function 51
	local max = NetworkConstants.server_controlled_buff_id.max

	self._free_sync_ids = Script.new_array(max)

	local _local_sync_to_id = self._local_sync_to_id
	local num = 1

	for i = 1, max do
		if not _local_sync_to_id[i] then
			self._free_sync_ids[num] = i
			num = num + 1
		end
	end
end

BuffExtension._initalize_sync_tables = function (self)
	-- function 52
	if not self._id_to_local_sync then
		self._id_to_local_sync = {}
		self._local_sync_to_id = {}
		self._synced_buff_owner = {}
		self._buff_to_sync_type = {}
		self._id_to_server_sync = {}
		self._server_sync_to_id = {}
	end
end

BuffExtension.create_shared_lifetime_buff_unit = function (self, arg_53_1)
	-- function 53
	local _shared_buff_units = self._shared_buff_units

	_shared_buff_units = _shared_buff_units or {}
	self._shared_buff_units = _shared_buff_units
	self._shared_buff_units[#self._shared_buff_units + 1] = Managers.state.unit_spawner:spawn_network_unit("units/hub_elements/empty", "buff_unit", self._buff_unit_params, arg_53_1, Quaternion.identity(), nil)

	return self._shared_buff_units[#self._shared_buff_units]
end

local Managers = Managers

BuffExtension._remove_buff_synced = function (self, arg_54_1)
	-- function 54
	local _id_to_server_sync = self._id_to_server_sync

	if not _id_to_server_sync then
		return
	end

	local var_54_1 = _id_to_server_sync[arg_54_1]

	if not var_54_1 then
		return
	end

	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(self._unit)

	if not unit_game_object_id then
		return
	end

	if not network:game() then
		return
	end

	local network_transmit = network.network_transmit

	if not self.is_server then
		if self._buff_to_sync_type[arg_54_1] == BuffSyncType.All then
			network_transmit:send_rpc_clients("rpc_remove_buff_synced", unit_game_object_id, var_54_1)
		else
			local var_54_5 = self._synced_buff_owner[arg_54_1]

			if not PEER_ID_TO_CHANNEL[var_54_5] then
				network_transmit:send_rpc("rpc_remove_buff_synced", var_54_5, unit_game_object_id, var_54_1)
			end
		end
	else
		network_transmit:send_rpc_server("rpc_remove_buff_synced", unit_game_object_id, var_54_1)
	end
end
