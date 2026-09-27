-- chunkname: @scripts/unit_extensions/generic/generic_ammo_user_extension.lua

local script_data = script_data
local infinite_ammo = script_data.infinite_ammo

infinite_ammo = infinite_ammo or Development.parameter("infinite_ammo")
script_data.infinite_ammo = infinite_ammo
GenericAmmoUserExtension = class(GenericAmmoUserExtension)

GenericAmmoUserExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.unit = arg_1_2
	self.owner_unit = arg_1_3.owner_unit
	self.item_name = arg_1_3.item_name
	self._is_server = Managers.player.is_server

	local ammo_percent = arg_1_3.ammo_percent

	ammo_percent = ammo_percent or 1

	local ammo_data = arg_1_3.ammo_data

	self._reload_time = ammo_data.reload_time
	self._override_reload_time = nil
	self._override_reload_anim = nil
	self._single_clip = ammo_data.single_clip
	self._infinite_ammo = ammo_data.infinite_ammo

	if not ammo_data.infinite_ammo then
		ammo_percent = 1
	end

	self._max_ammo = ammo_data.max_ammo
	self._start_ammo = math.round(ammo_percent * self._max_ammo)

	local ammo_per_clip = ammo_data.ammo_per_clip

	ammo_per_clip = ammo_per_clip or self._max_ammo
	self._ammo_per_clip = ammo_per_clip
	self._ammo_per_reload = ammo_data.ammo_per_reload
	self._starting_loaded_ammo = ammo_data.starting_loaded_ammo

	local starting_loaded_ammo = ammo_data.starting_loaded_ammo

	starting_loaded_ammo = starting_loaded_ammo or 0
	self._current_ammo = starting_loaded_ammo
	self._starting_reserve_ammo = ammo_data.starting_reserve_ammo
	self._original_max_ammo = self._max_ammo
	self._original_ammo_percent = ammo_percent
	self._original_ammo_per_clip = self._ammo_per_clip

	local ammo_immediately_available = ammo_data.ammo_immediately_available

	ammo_immediately_available = ammo_immediately_available or false
	self._ammo_immediately_available = ammo_immediately_available

	local reload_on_ammo_pickup = ammo_data.reload_on_ammo_pickup

	reload_on_ammo_pickup = reload_on_ammo_pickup or false
	self._reload_on_ammo_pickup = reload_on_ammo_pickup
	self._play_reload_anim_on_wield_reload = ammo_data.play_reload_anim_on_wield_reload
	self._has_wield_reload_anim = ammo_data.has_wield_reload_anim
	self._destroy_when_out_of_ammo = ammo_data.destroy_when_out_of_ammo
	self._unwield_when_out_of_ammo = ammo_data.unwield_when_out_of_ammo

	if ammo_data.force_wield_previous_weapon_when_ammo_given ~= nil then
		self._force_wield_previous_weapon_when_ammo_given = ammo_data.force_wield_previous_weapon_when_ammo_given
	else
		self._force_wield_previous_weapon_when_ammo_given = false
	end

	if ammo_data.wield_previous_weapon_when_destroyed ~= nil then
		self._wield_previous_weapon_when_destroyed = ammo_data.wield_previous_weapon_when_destroyed
	else
		self._wield_previous_weapon_when_destroyed = true
	end

	local ammo_type = ammo_data.ammo_type

	ammo_type = ammo_type or "default"
	self._ammo_type = ammo_type

	local ammo_kind = ammo_data.ammo_kind

	ammo_kind = ammo_kind or "default"
	self._ammo_kind = ammo_kind

	local block_ammo_pickup = ammo_data.block_ammo_pickup

	block_ammo_pickup = block_ammo_pickup or false
	self._block_ammo_pickup = block_ammo_pickup
	self._play_reload_animation = true
	self._reload_event = arg_1_3.reload_event
	self.pickup_reload_event_1p = arg_1_3.pickup_reload_event_1p

	local last_reload_event = arg_1_3.last_reload_event

	last_reload_event = last_reload_event or self._reload_event
	self._last_reload_event = last_reload_event
	self._no_ammo_reload_event = arg_1_3.no_ammo_reload_event
	self.slot_name = arg_1_3.slot_name

	local has_extension = ScriptUnit.has_extension(self.owner_unit, "first_person_system")

	if not has_extension then
		self.first_person_extension = has_extension
		self.first_person_unit = has_extension:get_first_person_unit()

		if not ammo_data.should_update_anim_ammo then
			self._should_update_anim_ammo = true

			assert(self.first_person_unit)
		end
	end
end

GenericAmmoUserExtension.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	self:apply_buffs()
	self:_update_anim_ammo()
end

GenericAmmoUserExtension.apply_buffs = function (self)
	-- function 3
	if not (self.slot_name == "slot_ranged" or self.slot_name ~= "slot_career_skill_weapon") then
		self:_apply_buffs()
	end

	self:reset()
end

GenericAmmoUserExtension._apply_buffs = function (self)
	-- function 4
	local extension = ScriptUnit.extension(self.owner_unit, "buff_system")

	self.owner_buff_extension = extension
	self._ammo_per_clip = math.ceil(extension:apply_buffs_to_value(self._original_ammo_per_clip, "clip_size"))
	self._max_ammo = math.ceil(extension:apply_buffs_to_value(self._original_max_ammo, "total_ammo"))
	self._start_ammo = math.round(self._original_ammo_percent * self._max_ammo)
end

GenericAmmoUserExtension.refresh_buffs = function (self)
	-- function 5
	local total_ammo_fraction = self:total_ammo_fraction()

	self:_apply_buffs()

	local num = self._start_ammo - self._current_ammo
	local _available_ammo = self._available_ammo

	_available_ammo = _available_ammo or math.huge
	self._available_ammo = math.min(num, _available_ammo)

	if total_ammo_fraction == 1 then
		self:reset()
	end
end

GenericAmmoUserExtension.destroy = function (arg_6_0)
	-- function 6
	return
end

GenericAmmoUserExtension.reset = function (self)
	-- function 7
	local _initialized = self._initialized

	_initialized = not _initialized and self:total_remaining_ammo() == 0

	local _starting_loaded_ammo = self._starting_loaded_ammo

	_starting_loaded_ammo = _starting_loaded_ammo or self._start_ammo

	if not self._ammo_immediately_available then
		self._current_ammo = _starting_loaded_ammo
	else
		self._current_ammo = math.min(self._ammo_per_clip, _starting_loaded_ammo)
	end

	local _starting_reserve_ammo = self._starting_reserve_ammo

	_starting_reserve_ammo = _starting_reserve_ammo or self._start_ammo - self._current_ammo
	self._available_ammo = _starting_reserve_ammo
	self._shots_fired = 0

	self:_update_anim_ammo()

	if not _initialized then
		local has_extension = ScriptUnit.has_extension(self.owner_unit, "inventory_system")

		if not (not has_extension and self.slot_name ~= has_extension:get_wielded_slot_name()) then
			self:instant_reload(true, self._no_ammo_reload_event)
		end
	end

	self._initialized = true
end

GenericAmmoUserExtension.update = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	local owner = Managers.player:owner(self.owner_unit)

	if not self._queued_reload then
		if not self:can_reload() then
			self:start_reload(true)
		end

		self._queued_reload = false
	end

	self:_check_ammo()

	if not (not self._next_reload_time and not (arg_8_5 > self._next_reload_time)) then
		if not self._start_reloading then
			local owner_buff_extension = self.owner_buff_extension
			local num = self._ammo_per_clip - self._current_ammo
			local _ammo_per_reload

			if not (not self._ammo_per_reload and not (num >= self._ammo_per_reload)) then
				_ammo_per_reload = self._ammo_per_reload

				if not _ammo_per_reload then
					-- Nothing
				end
			end

			_ammo_per_reload = num

			::label_8_0::

			local min = math.min(_ammo_per_reload, self._available_ammo)

			self._current_ammo = self._current_ammo + min

			if not owner_buff_extension then
				local has_buff_type = owner_buff_extension:has_buff_type("no_ammo_consumed")
				local has_buff_type_2 = owner_buff_extension:has_buff_type("markus_huntsman_activated_ability")

				has_buff_type_2 = has_buff_type_2 or owner_buff_extension:has_buff_type("markus_huntsman_activated_ability_duration")

				local has_buff_type_3 = owner_buff_extension:has_buff_type("twitch_no_overcharge_no_ammo_reloads")

				if not (has_buff_type or has_buff_type_2 or has_buff_type_3) then
					self._available_ammo = self._available_ammo - min
				end

				owner_buff_extension:trigger_procs("on_reload")
				self:_update_anim_ammo()
			end

			if not (LEVEL_EDITOR_TEST or self._is_server) then
				local network_id = owner:network_id()
				local local_player_id = owner:local_player_id()
				local on_reload = NetworkLookup.proc_events.on_reload

				Managers.state.network.network_transmit:send_rpc_server("rpc_proc_event", network_id, local_player_id, on_reload)
			end
		end

		self._start_reloading = nil

		if not (not (self._ammo_per_clip - self._current_ammo > 0) or not (self._available_ammo > 0)) then
			local _override_reload_time = self._override_reload_time

			_override_reload_time = _override_reload_time or self._reload_time
			self._override_reload_time = nil

			local var_8_12 = _override_reload_time

			if not self.owner_buff_extension then
				_override_reload_time = self.owner_buff_extension:apply_buffs_to_value(_override_reload_time, "reload_speed")
			end

			self._next_reload_time = arg_8_5 + _override_reload_time

			if not self._play_reload_animation then
				Unit.set_flow_variable(self.unit, "wwise_reload_speed", var_8_12 / _override_reload_time)
				self:start_reload_animation(_override_reload_time)

				if not owner.bot_player then
					Managers.state.controller_features:add_effect("rumble", {
						rumble_effect = "reload_start"
					})
				end
			end
		else
			self._next_reload_time = nil

			if not owner.bot_player then
				Managers.state.controller_features:add_effect("rumble", {
					rumble_effect = "reload_over"
				})
			end
		end
	end
end

GenericAmmoUserExtension._check_ammo = function (self)
	-- function 9
	if self._shots_fired > 0 then
		self._current_ammo = self._current_ammo - self._shots_fired
		self._shots_fired = 0

		fassert(self._current_ammo >= 0)

		if self._current_ammo == 0 then
			local unit = self.unit
			local owner_unit = self.owner_unit
			local owner = Managers.player:owner(self.owner_unit)
			local owner_buff_extension = self.owner_buff_extension

			if not (not owner and owner.bot_player) then
				Unit.flow_event(unit, "used_last_ammo_clip")

				if not owner_buff_extension then
					owner_buff_extension:trigger_procs("on_ammo_clip_used")
				end
			end

			if self._available_ammo == 0 then
				if not self._destroy_when_out_of_ammo then
					local extension = ScriptUnit.extension(owner_unit, "inventory_system")
					local has_extension = ScriptUnit.has_extension(owner_unit, "status_system")

					extension:destroy_item_by_name(self.slot_name, self.item_name, false, true)

					if not (not self._last_ammo_used_was_given and self._force_wield_previous_weapon_when_ammo_given and not self._wield_previous_weapon_when_destroyed and not has_extension and CharacterStateHelper.pack_master_status(has_extension) or extension:get_wielded_slot_name() ~= self.slot_name) then
						extension:wield_previous_weapon()
					end
				elseif not self._unwield_when_out_of_ammo then
					ScriptUnit.extension(owner_unit, "inventory_system"):wield_previous_weapon()
				else
					local unit_owner = Managers.player:unit_owner(owner_unit)
					local item_name = self.item_name
					local var_9_8 = POSITION_LOOKUP[owner_unit]

					Managers.telemetry_events:player_ammo_depleted(unit_owner, item_name, var_9_8)
				end

				Unit.flow_event(unit, "used_last_ammo")
			end
		end
	end
end

GenericAmmoUserExtension.start_reload_animation = function (self, arg_10_1)
	-- function 10
	if not self.pickup_reload_event_1p then
		local pickup_reload_event_1p = self.pickup_reload_event_1p

		if not self.first_person_extension then
			self.first_person_extension:animation_event(pickup_reload_event_1p)
		end
	end

	local _reload_event = self._reload_event
	local num = self._ammo_per_clip - self._current_ammo

	if not self.reloaded_from_zero_ammo then
		self.reloaded_from_zero_ammo = nil

		if not self._no_ammo_reload_event then
			_reload_event = self._no_ammo_reload_event
		end
	elseif not (num == 1 or self._available_ammo ~= 1) then
		_reload_event = self._last_reload_event
	end

	_reload_event = self._override_reload_anim or _reload_event
	self._override_reload_anim = nil

	if not _reload_event then
		if not self.first_person_extension then
			local first_person_extension = self.first_person_extension

			first_person_extension:animation_set_variable("reload_time", arg_10_1)
			first_person_extension:animation_event(_reload_event)
		end

		local go_id = Managers.state.unit_storage:go_id(self.owner_unit)
		local var_10_5 = NetworkLookup.anims[_reload_event]

		if not LEVEL_EDITOR_TEST then
			if not self._is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_anim_event", var_10_5, go_id)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_anim_event", var_10_5, go_id)
			end
		end
	end
end

GenericAmmoUserExtension.remove_ammo = function (self, arg_11_1)
	-- function 11
	if not (self._available_ammo ~= 0 or self._current_ammo ~= 0) then
		return
	end

	self._available_ammo = math.floor(math.clamp(self._available_ammo - arg_11_1, 0, self._max_ammo))
end

GenericAmmoUserExtension.add_ammo = function (self, arg_12_1)
	-- function 12
	if not self._destroy_when_out_of_ammo then
		return
	end

	if not (self._available_ammo ~= 0 or self._current_ammo ~= 0) then
		self.reloaded_from_zero_ammo = true

		local unit_owner = Managers.player:unit_owner(self.owner_unit)
		local item_name = self.item_name
		local var_12_2 = POSITION_LOOKUP[self.owner_unit]

		Managers.telemetry_events:player_ammo_refilled(unit_owner, item_name, var_12_2)

		local owner_buff_extension = self.owner_buff_extension

		if not owner_buff_extension then
			owner_buff_extension:trigger_procs("on_gained_ammo_from_no_ammo")

			if not (LEVEL_EDITOR_TEST or self._is_server) then
				local owner = Managers.player:owner(self.owner_unit)
				local network_id = owner:network_id()
				local local_player_id = owner:local_player_id()
				local on_gained_ammo_from_no_ammo = NetworkLookup.proc_events.on_gained_ammo_from_no_ammo

				Managers.state.network.network_transmit:send_rpc_server("rpc_proc_event", network_id, local_player_id, on_gained_ammo_from_no_ammo)
			end
		end
	end

	local var_12_8

	if not arg_12_1 and not self._ammo_immediately_available then
		self._current_ammo = math.floor(math.clamp(self._current_ammo + arg_12_1, 0, self._max_ammo))
	elseif not arg_12_1 then
		self._available_ammo = math.floor(math.clamp(self._available_ammo + arg_12_1, 0, self._max_ammo - (self._current_ammo - self._shots_fired)))
	elseif not self._ammo_immediately_available then
		self._current_ammo = self._max_ammo
	else
		self._available_ammo = self._max_ammo - (self._current_ammo - self._shots_fired)
	end

	self:_update_anim_ammo()
end

GenericAmmoUserExtension.add_ammo_to_reserve = function (self, arg_13_1)
	-- function 13
	local _available_ammo = self._available_ammo

	if not self._ammo_immediately_available then
		self._current_ammo = math.min(self._max_ammo, self._current_ammo + arg_13_1)
	else
		local ammo_count = self:ammo_count()

		self._available_ammo = math.min(self._max_ammo - ammo_count, self._available_ammo + arg_13_1)
	end

	self.owner_buff_extension:trigger_procs("on_gained_ammo_from_no_ammo")

	if not (LEVEL_EDITOR_TEST or self._is_server) then
		local owner = Managers.player:owner(self.owner_unit)
		local network_id = owner:network_id()
		local local_player_id = owner:local_player_id()
		local on_gained_ammo_from_no_ammo = NetworkLookup.proc_events.on_gained_ammo_from_no_ammo

		Managers.state.network.network_transmit:send_rpc_server("rpc_proc_event", network_id, local_player_id, on_gained_ammo_from_no_ammo)
	end

	if _available_ammo ~= 0 or self._current_ammo ~= 0 or not self:can_reload() then
		self._queued_reload = true
	end

	self:_update_anim_ammo()
end

GenericAmmoUserExtension.use_ammo = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	local owner_buff_extension = self.owner_buff_extension
	local flag = false

	if not owner_buff_extension then
		local num = math.round(arg_14_1 * owner_buff_extension:apply_buffs_to_value(1, "ammo_used_multiplier")) - arg_14_1

		if arg_14_1 + num > self:ammo_count() then
			local num_2 = arg_14_1 + num - self:ammo_count()

			num = num - num_2

			self:remove_ammo(math.min(num_2), self:remaining_ammo())
		end

		arg_14_1 = arg_14_1 + num
		flag = owner_buff_extension:has_buff_perk("infinite_ammo")
	end

	if not ((flag or not self._infinite_ammo) and self.slot_name ~= "slot_ranged") then
		arg_14_1 = 0
	end

	if not script_data.infinite_ammo then
		arg_14_1 = 0
	end

	self._shots_fired = self._shots_fired + arg_14_1

	if not owner_buff_extension then
		owner_buff_extension:trigger_procs("on_ammo_used", self, arg_14_1)
		Managers.state.achievement:trigger_event("ammo_used", self.owner_unit)

		if self:total_remaining_ammo() == 0 then
			owner_buff_extension:trigger_procs("on_last_ammo_used")
		end

		if not (LEVEL_EDITOR_TEST or self._is_server) then
			local owner = Managers.player:owner(self.owner_unit)
			local network_id = owner:network_id()
			local local_player_id = owner:local_player_id()
			local on_ammo_used = NetworkLookup.proc_events.on_ammo_used

			Managers.state.network.network_transmit:send_rpc_server("rpc_proc_event", network_id, local_player_id, on_ammo_used)

			if self:total_remaining_ammo() == 0 then
				local on_last_ammo_used = NetworkLookup.proc_events.on_last_ammo_used

				Managers.state.network.network_transmit:send_rpc_server("rpc_proc_event", network_id, local_player_id, on_last_ammo_used)
			end
		end
	end

	self:_update_anim_ammo()

	self._last_ammo_used_was_given = arg_14_2

	fassert(self:ammo_count() >= 0, "ammo went below 0")

	if not arg_14_3 then
		self:_check_ammo()
	end
end

GenericAmmoUserExtension.start_reload = function (self, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	fassert(self:can_reload(), "Tried to start reloading without being able to reload")
	fassert(self._next_reload_time == nil, "next_reload_time is nil")

	self._override_reload_time = arg_15_2
	self._start_reloading = true
	self._next_reload_time = 0
	self._play_reload_animation = arg_15_1
	self._override_reload_anim = arg_15_3

	local extension_input = ScriptUnit.extension_input(self.owner_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()
	local item_name = self.item_name

	item_name = item_name or "UNKNOWN ITEM"
	alloc_table.item_name = item_name

	local str = "reload_started"

	extension_input:trigger_dialogue_event(str, alloc_table)
end

GenericAmmoUserExtension.abort_reload = function (self)
	-- function 16
	fassert(self:is_reloading(), "Tried to abort reload while reloading")

	self._start_reloading = nil
	self._next_reload_time = nil

	Unit.flow_event(self.unit, "stop_reload_sound")

	if not self.first_person_extension then
		self.first_person_extension:show_first_person_ammo(false)
	end
end

GenericAmmoUserExtension.ammo_count = function (self)
	-- function 17
	return self._current_ammo - self._shots_fired
end

GenericAmmoUserExtension.clip_size = function (self)
	-- function 18
	return self._ammo_per_clip
end

GenericAmmoUserExtension.clip_full = function (self)
	-- function 19
	return self:ammo_count() == self._ammo_per_clip
end

GenericAmmoUserExtension.remaining_ammo = function (self)
	-- function 20
	return self._available_ammo
end

GenericAmmoUserExtension.ammo_available_immediately = function (self)
	-- function 21
	return self._ammo_immediately_available
end

GenericAmmoUserExtension.can_reload = function (self)
	-- function 22
	if not self:is_reloading() then
		return false
	end

	if not self:clip_full() then
		return false
	end

	if self._infinite_ammo or not script_data.infinite_ammo then
		return true
	end

	return self._available_ammo > 0
end

GenericAmmoUserExtension.total_remaining_ammo = function (self)
	-- function 23
	return self:remaining_ammo() + self:ammo_count()
end

GenericAmmoUserExtension.total_ammo_fraction = function (self)
	-- function 24
	return (self:remaining_ammo() + self:ammo_count()) / self:max_ammo()
end

GenericAmmoUserExtension.max_ammo = function (self)
	-- function 25
	return self._max_ammo
end

GenericAmmoUserExtension.current_ammo = function (self)
	-- function 26
	return self._current_ammo
end

GenericAmmoUserExtension.is_reloading = function (self)
	-- function 27
	return self._next_reload_time ~= nil
end

GenericAmmoUserExtension.full_ammo = function (self)
	-- function 28
	return self:remaining_ammo() + self:ammo_count() == self:max_ammo()
end

GenericAmmoUserExtension.using_single_clip = function (self)
	-- function 29
	return self._single_clip
end

GenericAmmoUserExtension.reload_on_ammo_pickup = function (self)
	-- function 30
	return self._reload_on_ammo_pickup
end

GenericAmmoUserExtension.play_reload_anim_on_wield_reload = function (self)
	-- function 31
	return self._play_reload_anim_on_wield_reload
end

GenericAmmoUserExtension.has_wield_reload_anim = function (self)
	-- function 32
	return self._has_wield_reload_anim
end

GenericAmmoUserExtension.ammo_type = function (self)
	-- function 33
	return self._ammo_type
end

GenericAmmoUserExtension.infinite_ammo = function (self)
	-- function 34
	local _infinite_ammo = self._infinite_ammo

	_infinite_ammo = _infinite_ammo or script_data.infinite_ammo

	return _infinite_ammo
end

GenericAmmoUserExtension.ammo_kind = function (self)
	-- function 35
	return self._ammo_kind
end

GenericAmmoUserExtension.ammo_blocked = function (self)
	-- function 36
	return self._block_ammo_pickup
end

GenericAmmoUserExtension.add_ammo_to_clip = function (self, arg_37_1)
	-- function 37
	self._current_ammo = self._current_ammo + arg_37_1

	self:_update_anim_ammo()
end

GenericAmmoUserExtension.instant_reload = function (self, arg_38_1, arg_38_2)
	-- function 38
	if not arg_38_1 then
		local num = self._ammo_per_clip - self._current_ammo
		local min = math.min(num, self._available_ammo)

		self._current_ammo = self._current_ammo + min
		self._available_ammo = self._available_ammo - min
		self._shots_fired = 0
	else
		self._current_ammo = self._ammo_per_clip
		self._shots_fired = 0
	end

	if not arg_38_2 then
		if not self.first_person_extension then
			local first_person_extension = self.first_person_extension

			first_person_extension:animation_set_variable("reload_time", math.huge)
			first_person_extension:animation_event(arg_38_2)
		end

		if not LEVEL_EDITOR_TEST then
			local go_id = Managers.state.unit_storage:go_id(self.owner_unit)
			local var_38_4 = NetworkLookup.anims[arg_38_2]

			if not self.is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_anim_event", var_38_4, go_id)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_anim_event", var_38_4, go_id)
			end
		end
	end

	self:_update_anim_ammo()
end

GenericAmmoUserExtension._update_anim_ammo = function (self)
	-- function 39
	if not self._should_update_anim_ammo then
		return
	end

	local num = self._current_ammo - self._shots_fired

	self.first_person_extension:animation_set_variable("ammo_count", num, true)
end
