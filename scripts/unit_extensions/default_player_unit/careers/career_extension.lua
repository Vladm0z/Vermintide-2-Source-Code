-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_extension.lua

require("scripts/unit_extensions/default_player_unit/careers/career_utils")

CareerExtension = class(CareerExtension)

local num = 1

CareerExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._unit = arg_1_2
	self.world = arg_1_1.world
	self.is_server = Managers.player.is_server
	self.player = arg_1_3.player
	self.input_manager = Managers.input

	local profile_index = arg_1_3.profile_index
	local career_index = arg_1_3.career_index
	local var_1_2 = SPProfiles[profile_index]
	local var_1_3 = var_1_2.careers[career_index]

	self._profile_index = profile_index
	self._career_index = career_index
	self._career_name = var_1_3.name
	self._profile_name = var_1_2.display_name

	if not (DEDICATED_SERVER or self._profile_name ~= "bright_wizard") then
		GlobalShaderFlags.set_global_shader_flag("NECROMANCER_CAREER_REMAP", self._career_name == "bw_necromancer")
	end

	self._career_data = var_1_3

	local breed = var_1_3.breed

	breed = breed or var_1_2.breed
	self._breed = breed

	local num_abilities = CareerUtils.num_abilities(profile_index, career_index)

	self._num_abilities = num_abilities
	self._abilities = {}
	self._abilities_always_usable_reasons = {}
	self._last_ability_ready_t = 0

	for i = 1, num_abilities do
		local get_ability_data = CareerUtils.get_ability_data(profile_index, career_index, i)
		local ability_class = get_ability_data.ability_class
		local spawn_cooldown_percent = get_ability_data.spawn_cooldown_percent

		spawn_cooldown_percent = spawn_cooldown_percent or 0

		local num = spawn_cooldown_percent * get_ability_data.cooldown
		local ability_cooldown_percent_int = arg_1_3.ability_cooldown_percent_int

		ability_cooldown_percent_int = ability_cooldown_percent_int or 100

		if ability_cooldown_percent_int < 100 then
			num = ability_cooldown_percent_int * 0.01 * get_ability_data.cooldown
		end

		local _abilities = self._abilities
		local tbl = {
			cooldown_anim_started = false,
			is_ready = false,
			name = get_ability_data.name,
			cooldowns = {
				num
			},
			initial_max_cooldown = get_ability_data.cooldown,
			max_cooldown = get_ability_data.cooldown,
			activated_ability = not ability_class and ability_class:new(arg_1_1, arg_1_2, arg_1_3, get_ability_data),
			weapon_name = get_ability_data.weapon_name,
			weapon_names_by_index = get_ability_data.weapon_names_by_index
		}
		local start_paused = get_ability_data.start_paused

		start_paused = start_paused or false
		tbl.cooldown_paused = start_paused
		tbl.cooldown_anim_time = get_ability_data.cooldown_anim_time

		local cost = get_ability_data.cost

		cost = cost or 1
		tbl.cost = cost

		local draw_ui_in_ghost_mode = get_ability_data.draw_ui_in_ghost_mode

		draw_ui_in_ghost_mode = draw_ui_in_ghost_mode or false
		tbl.draw_ui_in_ghost_mode = draw_ui_in_ghost_mode
		_abilities[i] = tbl
	end

	local passive_ability_classes = CareerUtils.get_passive_ability_by_career(var_1_3).passive_ability_classes
	local count

	if not passive_ability_classes then
		count = #passive_ability_classes

		if not count then
			-- Nothing
		end
	end

	count = 0

	::label_1_0::

	self._passive_abilities = {}
	self._passive_abilities_update = {}
	self._passive_abilities_by_name = {}
	self._num_passive_abilities = count

	for j = 1, count do
		local var_1_18 = passive_ability_classes[j]
		local var_1_19 = var_1_18.ability_class:new(arg_1_1, arg_1_2, arg_1_3, var_1_18.init_data)

		self._passive_abilities[j] = var_1_19

		if not var_1_19 and not var_1_19.update then
			self._passive_abilities_update[j] = var_1_19
		end

		self._passive_abilities_by_name[var_1_18.name] = var_1_19
	end

	self._num_passive_abilities_update = #self._passive_abilities_update
	self._ability_always_usable = nil

	self:setup_extra_ability_uses(0, 0, 0, 0)
	Unit.set_data(arg_1_2, "breed", self._breed)
	fassert(self._breed.hit_zones, "Player Breed '%s' is missing a 'hit_zones' table.", var_1_2.display_name)
	DamageUtils.create_hit_zone_lookup(arg_1_2, self._breed)
end

CareerExtension.ability_id = function (self, arg_2_1)
	-- function 2
	for i, v in ipairs(self._abilities) do
		if v.name == arg_2_1 then
			return i
		end
	end

	return nil
end

CareerExtension.ability_was_triggered = function (self, arg_3_1)
	-- function 3
	return self._abilities[arg_3_1].activated_ability:was_triggered()
end

CareerExtension.ability_by_id = function (self, arg_4_1)
	-- function 4
	return self._abilities[arg_4_1].activated_ability
end

CareerExtension.ability_name_by_id = function (self, arg_5_1)
	-- function 5
	return self._abilities[arg_5_1].name
end

CareerExtension.ability_by_name = function (self, arg_6_1)
	-- function 6
	for i = 1, #self._abilities do
		local var_6_0 = self._abilities[i]

		if var_6_0.name == arg_6_1 then
			return var_6_0, i
		end
	end
end

CareerExtension._is_husk = function (self)
	-- function 7
	local player = self.player

	return (not not player.local_player or not self.is_server) and not player.bot_player
end

CareerExtension.extensions_ready = function (self, arg_8_1, arg_8_2)
	-- function 8
	local extension = ScriptUnit.extension(arg_8_2, "buff_system")
	local get_passive_ability_by_career = CareerUtils.get_passive_ability_by_career(self._career_data)
	local buffs = get_passive_ability_by_career.buffs
	local player = self.player

	if not buffs and self.is_server and not player.local_player then
		for i = 1, #buffs do
			local var_8_4 = buffs[i]

			extension:add_buff(var_8_4)
		end
	end

	local husk_buffs = get_passive_ability_by_career.husk_buffs

	if not (not husk_buffs and self.is_server or player.local_player) then
		for j = 1, #husk_buffs do
			local var_8_6 = husk_buffs[j]

			extension:add_buff(var_8_6)
		end
	end

	local mechanism_setting_for_title = Managers.mechanism:mechanism_setting_for_title("base_career_buffs")

	if not mechanism_setting_for_title then
		for k = 1, #mechanism_setting_for_title do
			local var_8_8 = mechanism_setting_for_title[k]

			extension:add_buff(var_8_8)
		end
	end

	self._first_person_extension = ScriptUnit.has_extension(arg_8_2, "first_person_system")
	self._buff_extension = ScriptUnit.extension(arg_8_2, "buff_system")

	local _abilities = self._abilities

	for l = 1, self._num_abilities do
		local activated_ability = _abilities[l].activated_ability

		if not activated_ability then
			activated_ability:extensions_ready(arg_8_1, arg_8_2)
		end
	end

	local _passive_abilities = self._passive_abilities

	for i4 = 1, self._num_passive_abilities do
		_passive_abilities[i4]:extensions_ready(arg_8_1, arg_8_2)
	end

	Managers.state.event:register(self, "ingame_menu_opened", "stop_ability")
	Managers.state.event:register(self, "gm_event_round_started", "on_round_started")
end

CareerExtension.game_object_initialized = function (self, arg_9_1, arg_9_2)
	-- function 9
	local _passive_abilities = self._passive_abilities

	for i = 1, self._num_passive_abilities do
		local var_9_1 = _passive_abilities[i]

		if not var_9_1.game_object_initialized then
			var_9_1:game_object_initialized(arg_9_1, arg_9_2)
		end
	end
end

CareerExtension.force_trigger_active_ability = function (self)
	-- function 10
	local player = self.player
	local _abilities = self._abilities

	for i = 1, self._num_abilities do
		local var_10_2 = _abilities[i]

		if not var_10_2.activated_ability and not var_10_2.activated_ability.force_trigger_ability and not self.is_server and player.bot_player and not player.local_player then
			var_10_2.activated_ability:force_trigger_ability()

			break
		end
	end
end

CareerExtension.update = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	-- function 11
	local _abilities = self._abilities
	local _cooldown_charge_ready = self:_cooldown_charge_ready(1)

	for i = 1, self._num_abilities do
		local var_11_2 = _abilities[i]

		if not var_11_2.cooldown_paused then
			local _cooldown_charge_ready_2 = self:_cooldown_charge_ready(i)
			local apply_buffs_to_value = ScriptUnit.extension(arg_11_1, "buff_system"):apply_buffs_to_value(1, "cooldown_regen")

			self:reduce_activated_ability_cooldown(arg_11_3 * apply_buffs_to_value, i)
			self:check_cooldown_anim(i)

			if _cooldown_charge_ready_2 or not self._abilities_always_usable then
				local player = self.player

				if not var_11_2.activated_ability and not self.is_server and player.bot_player and not player.local_player then
					var_11_2.activated_ability:update(arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
				end
			elseif not self:_cooldown_charge_ready(i) then
				self:_run_ability_ready_feedback(i, arg_11_5)
			end
		end
	end

	local _passive_abilities_update = self._passive_abilities_update

	for j = 1, self._num_passive_abilities_update do
		_passive_abilities_update[j]:update(arg_11_3, arg_11_5)
	end

	local _cooldown_charge_ready_3 = self:_cooldown_charge_ready(1)

	if not (not _cooldown_charge_ready and _cooldown_charge_ready_3) then
		self:_update_game_object_field(arg_11_1)

		if not _cooldown_charge_ready_3 and not self._buff_extension then
			self._buff_extension:trigger_procs("on_ability_recharged")
		end
	end
end

CareerExtension.stop_ability = function (self, arg_12_1, arg_12_2)
	-- function 12
	local is_server = self.is_server
	local player = self.player

	if not is_server and player.bot_player and not player.local_player then
		arg_12_2 = arg_12_2 or 1

		local activated_ability = self._abilities[arg_12_2].activated_ability

		if not activated_ability then
			activated_ability:stop(arg_12_1)
		end
	end
end

CareerExtension._update_game_object_field = function (self, arg_13_1)
	-- function 13
	if not (not self.is_server and self.player.bot_player and self.player.local_player) then
		return
	end

	local current_ability_cooldown, var_13_1 = self:current_ability_cooldown(1)
	local num = 1

	if not current_ability_cooldown then
		num = current_ability_cooldown / var_13_1
	end

	local game = Managers.state.network:game()

	if not game then
		local go_id = Managers.state.unit_storage:go_id(arg_13_1)
		local clamp = math.clamp(num, 0, 1)

		GameSession.set_game_object_field(game, go_id, "ability_percentage", clamp)
	end
end

CareerExtension.destroy = function (self)
	-- function 14
	local _passive_abilities = self._passive_abilities

	for i = 1, self._num_passive_abilities do
		_passive_abilities[i]:destroy()
	end

	local _abilities = self._abilities

	for j = 1, self._num_abilities do
		local activated_ability = _abilities[j].activated_ability

		if not activated_ability and not activated_ability.destroy then
			activated_ability:destroy()
		end
	end
end

CareerExtension.get_activated_ability_data = function (self, arg_15_1)
	-- function 15
	arg_15_1 = arg_15_1 or 1

	return self._career_data.activated_ability[arg_15_1]
end

CareerExtension.start_activated_ability_cooldown = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	-- function 16
	arg_16_1 = arg_16_1 or 1

	local var_16_0 = self._abilities[arg_16_1]
	local num = var_16_0.max_cooldown * (var_16_0.cost * (arg_16_2 or 0))
	local num_2 = var_16_0.max_cooldown * var_16_0.cost

	if not arg_16_3 then
		num_2 = var_16_0.max_cooldown * arg_16_3
	end

	local _unit = self._unit
	local extension = ScriptUnit.extension(_unit, "buff_system")

	if not extension:has_buff_perk("free_ability") then
		num_2 = 0
	end

	if self:_cooldown_charge_ready(arg_16_1) or self._abilities_always_usable or not arg_16_4 then
		local players_at_peer = Managers.player:players_at_peer(Network.peer_id())

		if not players_at_peer and not _unit then
			for k, v in pairs(players_at_peer) do
				local player_unit = v.player_unit

				if not ALIVE[player_unit] then
					local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")

					if not has_extension then
						has_extension:trigger_procs("on_ability_activated", _unit, arg_16_1)

						local player = self.player
						local var_16_9 = v

						Managers.state.achievement:trigger_event("any_ability_used", _unit, arg_16_1, player, var_16_9)
					end

					local has_extension_2 = ScriptUnit.has_extension(player_unit, "cosmetic_system")

					if not has_extension_2 then
						has_extension_2:trigger_ability_activated_events()
					end
				end
			end
		end
	end

	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(_unit)

	if not network:game() then
		if not self.is_server then
			network.network_transmit:send_rpc_clients("rpc_ability_activated", unit_game_object_id, arg_16_1)
		else
			network.network_transmit:send_rpc_server("rpc_ability_activated", unit_game_object_id, arg_16_1)
		end
	end

	local game_mode = Managers.state.game_mode

	game_mode = not game_mode and Managers.state.game_mode:game_mode()

	if not self.player.local_player and not game_mode and not game_mode.activated_ability_telemetry then
		local get_activated_ability_data = self:get_activated_ability_data(arg_16_1)
		local name = get_activated_ability_data.name

		name = name or get_activated_ability_data.display_name

		game_mode:activated_ability_telemetry(name, self.player)
	end

	if not (self:current_ability_cooldown(arg_16_1) <= var_16_0.max_cooldown * (1 - var_16_0.cost) or not (num_2 <= 0)) then
		self:increase_activated_ability_cooldown(num_2 - num, arg_16_1)

		local current_ability_cooldown = self:current_ability_cooldown(arg_16_1)
		local apply_buffs_to_value = extension:apply_buffs_to_value(current_ability_cooldown, "activated_cooldown")

		if current_ability_cooldown < apply_buffs_to_value then
			self:increase_activated_ability_cooldown(apply_buffs_to_value - current_ability_cooldown, arg_16_1)
		elseif apply_buffs_to_value < current_ability_cooldown then
			self:reduce_activated_ability_cooldown(current_ability_cooldown - apply_buffs_to_value, arg_16_1)
		end
	elseif self._extra_ability_uses > 0 then
		self:modify_extra_ability_uses(-1)
		extension:trigger_procs("on_extra_ability_consumed", _unit)
		Managers.state.achievement:trigger_event("free_cast_used", _unit, _unit)
	end

	extension:trigger_procs("on_ability_cooldown_started")

	var_16_0.cooldown_paused = false
	var_16_0.cooldown_anim_started = false
end

CareerExtension.reduce_activated_ability_cooldown_percent = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	arg_17_2 = arg_17_2 or 1

	local var_17_0 = self._abilities[arg_17_2]

	self:reduce_activated_ability_cooldown(var_17_0.max_cooldown * arg_17_1, arg_17_2, arg_17_3)
end

CareerExtension.reduce_activated_ability_cooldown = function (self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	arg_18_2 = arg_18_2 or 1

	local var_18_0 = self._abilities[arg_18_2]

	if not (not var_18_0.cooldown_paused and arg_18_3) then
		return
	end

	if arg_18_1 < 0 then
		return self:increase_activated_ability_cooldown(-arg_18_1, arg_18_2, arg_18_3)
	end

	local _currently_decaying_cooldown = self:_currently_decaying_cooldown(arg_18_2)
	local cooldowns = var_18_0.cooldowns

	for i = _currently_decaying_cooldown, 1, -1 do
		if arg_18_1 < math.epsilon then
			break
		end

		local var_18_3 = cooldowns[i]
		local min = math.min(var_18_3, arg_18_1)

		cooldowns[i] = math.clamp(var_18_3 - min, 0, var_18_0.max_cooldown)
		arg_18_1 = arg_18_1 - min
	end

	local _cooldown_charge_ready = self:_cooldown_charge_ready(arg_18_2)

	if not _cooldown_charge_ready then
		var_18_0.cooldown_paused = false
	end

	if not arg_18_3 and not _cooldown_charge_ready then
		self:set_activated_ability_cooldown_unpaused(arg_18_2)
	end
end

CareerExtension.increase_activated_ability_cooldown = function (self, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	arg_19_2 = arg_19_2 or 1

	local var_19_0 = self._abilities[arg_19_2]

	if not (not var_19_0.cooldown_paused and arg_19_3) then
		return
	end

	if arg_19_1 < 0 then
		return self:reduce_activated_ability_cooldown(-arg_19_1, arg_19_2, arg_19_3)
	end

	local _currently_decaying_cooldown = self:_currently_decaying_cooldown(arg_19_2)
	local cooldowns = var_19_0.cooldowns

	for i = _currently_decaying_cooldown, #cooldowns do
		if arg_19_1 < math.epsilon then
			break
		end

		local var_19_3 = cooldowns[i]
		local min = math.min(var_19_0.max_cooldown - var_19_3, arg_19_1)

		cooldowns[i] = math.clamp(var_19_3 + min, 0, var_19_0.max_cooldown)
		arg_19_1 = arg_19_1 - min
	end

	if not self:_cooldown_charge_ready(arg_19_2) then
		var_19_0.cooldown_paused = false
	end
end

CareerExtension.modify_max_cooldown = function (self, arg_20_1, arg_20_2, arg_20_3)
	-- function 20
	arg_20_1 = arg_20_1 or 1
	arg_20_2 = arg_20_2 or 0
	arg_20_3 = arg_20_3 or 1

	local var_20_0 = self._abilities[arg_20_1]
	local max_cooldown = var_20_0.max_cooldown

	var_20_0.max_cooldown = var_20_0.max_cooldown + var_20_0.initial_max_cooldown * arg_20_3 + arg_20_2

	local cooldowns = var_20_0.cooldowns

	for i = 1, #cooldowns do
		local var_20_3 = cooldowns[i]

		cooldowns[i] = math.clamp(var_20_3 / max_cooldown, 0, 1) * var_20_0.max_cooldown
	end
end

CareerExtension.uses_cooldown = function (self, arg_21_1)
	-- function 21
	arg_21_1 = arg_21_1 or 1

	local max_cooldown = self._abilities[arg_21_1].max_cooldown

	return not max_cooldown and max_cooldown > 0
end

CareerExtension.set_activated_ability_cooldown_paused = function (arg_22_0, arg_22_1)
	-- function 22
	arg_22_1 = arg_22_1 or 1
	arg_22_0._abilities[arg_22_1].cooldown_paused = true
end

CareerExtension.set_activated_ability_cooldown_unpaused = function (arg_23_0, arg_23_1)
	-- function 23
	arg_23_1 = arg_23_1 or 1
	arg_23_0._abilities[arg_23_1].cooldown_paused = false
end

CareerExtension.abilities_always_usable = function (self)
	-- function 24
	return self._abilities_always_usable
end

CareerExtension.set_abilities_always_usable = function (self, arg_25_1, arg_25_2)
	-- function 25
	if not arg_25_1 then
		self._abilities_always_usable_reasons[arg_25_2] = arg_25_1
	else
		self._abilities_always_usable_reasons[arg_25_2] = nil
	end

	self._abilities_always_usable = next(self._abilities_always_usable_reasons) ~= nil
end

CareerExtension.has_abilities_always_usable_reason = function (self, arg_26_1)
	-- function 26
	return self._abilities_always_usable_reasons[arg_26_1] ~= nil
end

CareerExtension.modify_extra_ability_uses = function (self, arg_27_1)
	-- function 27
	self._extra_ability_uses = math.max(self._extra_ability_uses + arg_27_1, 0)

	self:set_abilities_always_usable(self._extra_ability_uses > 0, "extra_ability_uses")
end

CareerExtension.get_extra_ability_uses = function (self)
	-- function 28
	return self._extra_ability_uses, self._extra_ability_uses_max
end

CareerExtension.get_extra_ability_charge = function (self)
	-- function 29
	return self._extra_ability_use_charge, self._extra_ability_use_required_charge
end

CareerExtension.modify_extra_ability_charge = function (self, arg_30_1)
	-- function 30
	local _extra_ability_use_charge = self._extra_ability_use_charge

	if self._extra_ability_uses >= self._extra_ability_uses_max then
		_extra_ability_use_charge = 0
	else
		_extra_ability_use_charge = math.max(_extra_ability_use_charge + arg_30_1, 0)

		if _extra_ability_use_charge >= self._extra_ability_use_required_charge then
			_extra_ability_use_charge = _extra_ability_use_charge - self._extra_ability_use_required_charge

			self:modify_extra_ability_uses(1)
		end
	end

	self._extra_ability_use_charge = _extra_ability_use_charge
end

CareerExtension.update_extra_ability_charge = function (self, arg_31_1)
	-- function 31
	self._extra_ability_use_required_charge = arg_31_1
end

CareerExtension.setup_extra_ability_uses = function (self, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
	-- function 32
	self._extra_ability_use_charge = math.min(arg_32_1, arg_32_2)
	self._extra_ability_use_required_charge = arg_32_2
	self._extra_ability_uses = math.min(arg_32_3, arg_32_4)
	self._extra_ability_uses_max = arg_32_4

	if self._extra_ability_uses == self._extra_ability_uses_max then
		self._extra_ability_use_charge = 0
	end
end

CareerExtension.update_extra_ability_uses_max = function (self, arg_33_1)
	-- function 33
	self._extra_ability_uses = math.min(self._extra_ability_uses, arg_33_1)
	self._extra_ability_uses_max = arg_33_1

	if self._extra_ability_uses == self._extra_ability_uses_max then
		self._extra_ability_use_charge = 0
	end
end

CareerExtension.reset_cooldown = function (self, arg_34_1)
	-- function 34
	arg_34_1 = arg_34_1 or 1

	local var_34_0 = self._abilities[arg_34_1]
	local cooldowns = var_34_0.cooldowns

	for i = 1, #cooldowns do
		cooldowns[i] = var_34_0.max_cooldown
	end
end

CareerExtension.can_use_activated_ability = function (self, arg_35_1)
	-- function 35
	if not Managers.state.network:game() then
		return false
	end

	arg_35_1 = arg_35_1 or 1

	local var_35_0 = self._abilities[arg_35_1]
	local num = 1 - self:current_ability_cooldown_percentage(arg_35_1)
	local _abilities_always_usable

	if not (self:_cooldown_charge_ready(arg_35_1) or num >= var_35_0.cost) then
		_abilities_always_usable = self._abilities_always_usable

		if not _abilities_always_usable then
			-- Nothing
		end
	end

	_abilities_always_usable = not var_35_0.cooldown_paused

	::label_35_0::

	return _abilities_always_usable
end

CareerExtension._cooldown_charge_ready = function (self, arg_36_1)
	-- function 36
	return self:current_ability_cooldown(arg_36_1) == 0
end

CareerExtension.current_ability_cooldown = function (self, arg_37_1)
	-- function 37
	arg_37_1 = arg_37_1 or 1

	local var_37_0 = self._abilities[arg_37_1]
	local cooldowns = var_37_0.cooldowns
	local count = #cooldowns
	local apply_buffs_to_value = self._buff_extension:apply_buffs_to_value(1, "extra_ability_charges")

	for i = count + 1, apply_buffs_to_value do
		self:_add_cooldown_charge(arg_37_1)

		count = count + 1
	end

	for j = apply_buffs_to_value + 1, count do
		self:_remove_cooldown_charge(arg_37_1)

		count = count - 1
	end

	local var_37_4 = cooldowns[count]
	local max_cooldown

	if var_37_0.max_cooldown > 0 then
		max_cooldown = var_37_0.max_cooldown

		if not max_cooldown then
			-- Nothing
		end
	end

	max_cooldown = 1

	::label_37_0::

	return var_37_4, max_cooldown
end

CareerExtension._add_cooldown_charge = function (self, arg_38_1)
	-- function 38
	arg_38_1 = arg_38_1 or 1

	local cooldowns = self._abilities[arg_38_1].cooldowns

	table.insert(cooldowns, 0)
end

CareerExtension._remove_cooldown_charge = function (self, arg_39_1)
	-- function 39
	arg_39_1 = arg_39_1 or 1

	local cooldowns = self._abilities[arg_39_1].cooldowns

	table.remove(cooldowns, 1)
end

CareerExtension._currently_decaying_cooldown = function (self, arg_40_1)
	-- function 40
	arg_40_1 = arg_40_1 or 1

	local cooldowns = self._abilities[arg_40_1].cooldowns

	for i = #cooldowns, 1, -1 do
		if cooldowns[i] ~= 0 then
			return i
		end
	end

	return 1
end

CareerExtension.get_number_of_ability_cooldowns = function (self, arg_41_1)
	-- function 41
	arg_41_1 = arg_41_1 or 1

	local count = #self._abilities[arg_41_1].cooldowns

	count = count or 1

	return count
end

CareerExtension.num_charges_ready = function (self, arg_42_1)
	-- function 42
	arg_42_1 = arg_42_1 or 1

	local cooldowns = self._abilities[arg_42_1].cooldowns
	local count = #cooldowns
	local num = 0

	for i = count, 1, -1 do
		if cooldowns[i] > 0 then
			break
		end

		num = num + 1
	end

	return num, count
end

CareerExtension.current_ability_cooldown_percentage = function (self, arg_43_1)
	-- function 43
	if not self:_is_husk() then
		local network = Managers.state.network
		local flag = not network and network:game()

		if not flag then
			return 0
		end

		local go_id = Managers.state.unit_storage:go_id(self._unit)

		return GameSession.game_object_field(flag, go_id, "ability_percentage")
	else
		arg_43_1 = arg_43_1 or 1

		local current_ability_cooldown, var_43_4 = self:current_ability_cooldown(arg_43_1)

		return current_ability_cooldown / var_43_4
	end
end

CareerExtension.get_max_ability_cooldown = function (self, arg_44_1)
	-- function 44
	arg_44_1 = arg_44_1 or 1

	return self._abilities[arg_44_1].max_cooldown
end

CareerExtension.current_ability_paused = function (self, arg_45_1)
	-- function 45
	arg_45_1 = arg_45_1 or 1

	return self._abilities[arg_45_1].cooldown_paused
end

CareerExtension.profile_index = function (self)
	-- function 46
	return self._profile_index
end

CareerExtension.career_index = function (self)
	-- function 47
	return self._career_index
end

CareerExtension.career_name = function (self)
	-- function 48
	return self._career_name
end

CareerExtension.career_settings = function (self)
	-- function 49
	return self._career_data
end

CareerExtension.career_skill_weapon_name = function (self, arg_50_1, arg_50_2)
	-- function 50
	arg_50_1 = arg_50_1 or 1

	local var_50_0 = self._abilities[arg_50_1]

	if not arg_50_2 then
		local weapon_names_by_index = var_50_0.weapon_names_by_index

		if not weapon_names_by_index and not weapon_names_by_index[arg_50_2] then
			return weapon_names_by_index[arg_50_2]
		end
	end

	return var_50_0.weapon_name
end

CareerExtension.get_base_critical_strike_chance = function (self)
	-- function 51
	local base_critical_strike_chance = self._career_data.attributes.base_critical_strike_chance

	base_critical_strike_chance = base_critical_strike_chance or 0

	return base_critical_strike_chance
end

CareerExtension.has_melee_boost = function (self)
	-- function 52
	local has_buff_perk = self._buff_extension:has_buff_perk("shade_melee_boost")
	local flag = false
	local flag_2

	flag_2 = not has_buff_perk and 4 and not flag or 1 and 0

	return has_buff_perk or flag, flag_2
end

CareerExtension.has_ranged_boost = function (self)
	-- function 53
	local _buff_extension = self._buff_extension
	local has_buff_type = _buff_extension:has_buff_type("markus_huntsman_activated_ability")

	has_buff_type = has_buff_type or _buff_extension:has_buff_type("markus_huntsman_activated_ability_duration")

	local has_buff_type_2 = _buff_extension:has_buff_type("bardin_ranger_activated_ability_buff")
	local flag

	flag = not has_buff_type and 1.5 and not has_buff_type_2 or 1 and 0

	return has_buff_type or has_buff_type_2, flag
end

CareerExtension.get_career_power_level = function (self)
	-- function 54
	local player = self.player
	local _career_name = self._career_name
	local _profile_name = self._profile_name
	local MIN_POWER_LEVEL = MIN_POWER_LEVEL
	local game_mode = Managers.state.game_mode
	local flag = not game_mode and game_mode:game_mode_key()

	if flag ~= "versus" or not player.bot_player then
		local var_54_6 = GameModeSettings[flag]

		if not var_54_6 and not var_54_6.power_level_override then
			MIN_POWER_LEVEL = var_54_6.power_level_override
		end
	else
		if not player.bot_player then
			local party_leader_player = Managers.player:party_leader_player()

			if not party_leader_player then
				player = party_leader_player
				_profile_name = party_leader_player:profile_display_name()
				_career_name = party_leader_player:career_name()
			end
		end

		if not player.remote then
			MIN_POWER_LEVEL = player:get_data("power_level") or MIN_POWER_LEVEL
		else
			MIN_POWER_LEVEL = BackendUtils.get_total_power_level(_profile_name, _career_name)
		end
	end

	local _buff_extension = self._buff_extension

	if not _buff_extension then
		MIN_POWER_LEVEL = _buff_extension:apply_buffs_to_value(MIN_POWER_LEVEL, "flat_power_level")
	end

	return (math.clamp(MIN_POWER_LEVEL, MIN_POWER_LEVEL, MAX_POWER_LEVEL))
end

CareerExtension.set_state = function (self, arg_55_1)
	-- function 55
	self._state = arg_55_1
end

CareerExtension.get_state = function (self)
	-- function 56
	local _state = self._state

	_state = _state or "default"

	return _state
end

CareerExtension.get_breed = function (self)
	-- function 57
	return self._breed
end

CareerExtension.ability_amount = function (self)
	-- function 58
	return self._num_abilities
end

CareerExtension._run_ability_ready_feedback = function (self, arg_59_1, arg_59_2)
	-- function 59
	local var_59_0 = self._abilities[arg_59_1]

	if not var_59_0 and not var_59_0.activated_ability and not var_59_0.activated_ability.ability_ready then
		var_59_0.activated_ability:ability_ready()
	else
		local _first_person_extension = self._first_person_extension

		if not _first_person_extension then
			if arg_59_2 > self._last_ability_ready_t + num then
				_first_person_extension:play_hud_sound_event("Play_hud_ability_ready")
			end

			self._last_ability_ready_t = arg_59_2
		end
	end
end

CareerExtension.check_cooldown_anim = function (self, arg_60_1)
	-- function 60
	local var_60_0 = self._abilities[arg_60_1]

	if not ((var_60_0.cooldown_anim_started or not var_60_0.cooldown_anim_time) and not (self:current_ability_cooldown(arg_60_1) - var_60_0.cooldown_anim_time < 0)) then
		var_60_0.cooldown_anim_started = true

		var_60_0.activated_ability:start_cooldown_anim()
	end
end

CareerExtension.should_reload_career_weapon = function (self)
	-- function 61
	return self._career_data.should_reload_career_weapon
end

CareerExtension.set_career_game_object_id = function (self, arg_62_1)
	-- function 62
	local _passive_abilities = self._passive_abilities

	for i = 1, self._num_passive_abilities do
		local var_62_1 = _passive_abilities[i]

		if not var_62_1 and not var_62_1.set_career_game_object_id then
			var_62_1:set_career_game_object_id(arg_62_1)
		end
	end
end

CareerExtension.get_passive_ability = function (self, arg_63_1)
	-- function 63
	local _passive_abilities = self._passive_abilities

	return not _passive_abilities and _passive_abilities[arg_63_1 or 1]
end

CareerExtension.get_passive_ability_by_name = function (self, arg_64_1)
	-- function 64
	return self._passive_abilities_by_name[arg_64_1]
end

CareerExtension.on_round_started = function (self)
	-- function 65
	self:set_activated_ability_cooldown_unpaused()
end
