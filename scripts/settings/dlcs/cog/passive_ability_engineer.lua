-- chunkname: @scripts/settings/dlcs/cog/passive_ability_engineer.lua

PassiveAbilityEngineer = class(PassiveAbilityEngineer)

local alive = Unit.alive
local set_flow_variable = Unit.set_flow_variable
local flow_event = Unit.flow_event
local set_game_object_field = GameSession.set_game_object_field
local game_object_field = GameSession.game_object_field
local num = 1
local num_2 = 0.05
local num_3 = 0.01
local num_4 = 0.2
local num_5 = 5
local num_6 = 10
local num_7 = 0.3
local num_8 = 1

PassiveAbilityEngineer.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	self._owner_unit = arg_1_2
	self._player = arg_1_3.player
	self._is_server = arg_1_1.is_server
	self._player_unique_id = arg_1_3.player:unique_id()
	self._world = arg_1_1.world
	self._heat_cooldown_pause_t = 0
	self._weapon_visual_heat = 0
	self._prev_weapon_visual_heat = 0
	self._visual_heat_cooldown_speed = WeaponUtils.get_weapon_template("bardin_engineer_career_skill_weapon").visual_heat_cooldown_speed
	self._heat_particles_spawned = false
	self._last_ability_charge = 0
	self._wind_down_progress = 0
	self._wind_down_cooldown_pause_t = 0
	self._is_local_player = self._player.local_player
	self._game = Managers.state.network:game()
end

PassiveAbilityEngineer.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	self._inventory_extension = ScriptUnit.has_extension(arg_2_2, "inventory_system")
	self._career_extension = ScriptUnit.has_extension(arg_2_2, "career_system")
	self._first_person_extension = ScriptUnit.has_extension(arg_2_2, "first_person_system")
	self._talent_extension = ScriptUnit.extension(arg_2_2, "talent_system")

	self:_register_events()
end

PassiveAbilityEngineer.destroy = function (self)
	-- function 3
	self:_unregister_events()

	self._game_object_id = nil
end

PassiveAbilityEngineer._register_events = function (arg_4_0)
	-- function 4
	Managers.state.event:register(arg_4_0, "on_engineer_weapon_fire", "on_engineer_weapon_fire")
	Managers.state.event:register(arg_4_0, "on_engineer_weapon_spin_up", "on_engineer_weapon_spin_up")
	Managers.state.event:register(arg_4_0, "level_start_local_player_spawned", "on_level_start_local_player_spawned")
	Managers.state.event:register(arg_4_0, "on_talents_changed", "on_talents_changed")
end

PassiveAbilityEngineer.game_object_initialized = function (self, arg_5_1, arg_5_2)
	-- function 5
	self:on_talents_changed(arg_5_1, self._talent_extension, true)
end

PassiveAbilityEngineer._unregister_events = function (arg_6_0)
	-- function 6
	if not Managers.state.event then
		Managers.state.event:unregister("on_engineer_weapon_fire", arg_6_0)
		Managers.state.event:unregister("on_engineer_weapon_spin_up", arg_6_0)
		Managers.state.event:unregister("level_start_local_player_spawned", arg_6_0)
		Managers.state.event:unregister("on_talents_changed", arg_6_0)
	end
end

PassiveAbilityEngineer.update = function (self, arg_7_1, arg_7_2)
	-- function 7
	local _game_object_id = self._game_object_id
	local _game = self._game

	if not _game and not _game_object_id then
		if not self._is_local_player then
			local _weapon_visual_heat = self._weapon_visual_heat

			if arg_7_2 > self._heat_cooldown_pause_t then
				_weapon_visual_heat = math.clamp(_weapon_visual_heat - self._visual_heat_cooldown_speed * arg_7_1, 0, 1)
			end

			if arg_7_2 > self._wind_down_cooldown_pause_t then
				self._wind_down_progress = math.clamp(math.lerp(self._wind_down_progress, 0, num_8 * arg_7_1), 0, 1)
			end

			if self._prev_weapon_visual_heat ~= _weapon_visual_heat then
				self._prev_weapon_visual_heat = _weapon_visual_heat
				self._weapon_visual_heat = _weapon_visual_heat

				set_game_object_field(_game, _game_object_id, "visual_heat", _weapon_visual_heat)
			end
		elseif not self._game_object_id then
			local var_7_3 = game_object_field(_game, _game_object_id, "visual_heat")

			self._weapon_visual_heat = math.clamp(math.lerp(self._weapon_visual_heat, var_7_3, num_5 * arg_7_1), 0, 1)
		end
	end

	local _inventory_extension = self._inventory_extension
	local get_wielded_slot_data = _inventory_extension:get_wielded_slot_data()

	if not (not get_wielded_slot_data and get_wielded_slot_data.id ~= "slot_career_skill_weapon") then
		local equipment = _inventory_extension:equipment()

		self:_update_career_weapon_particles(_inventory_extension)
		self:_update_career_weapon(equipment.right_hand_wielded_unit)
		self:_update_career_weapon(equipment.right_hand_wielded_unit_3p)
		self:_update_weapon_anim_variables(arg_7_1)
	else
		self._heat_particles_spawned = false
		self._wind_down_progress = 0
	end
end

PassiveAbilityEngineer._update_career_weapon_particles = function (self, arg_8_1)
	-- function 8
	if not (self._heat_particles_spawned or not (self._weapon_visual_heat >= num_2)) then
		arg_8_1:start_weapon_fx("heat_shimmer")

		self._heat_particles_spawned = true
	elseif not (not self._heat_particles_spawned and not (self._weapon_visual_heat <= num_3)) then
		arg_8_1:stop_weapon_fx("heat_shimmer")

		self._heat_particles_spawned = false
	end
end

PassiveAbilityEngineer._update_career_weapon = function (self, arg_9_1)
	-- function 9
	if not (not arg_9_1 and alive(arg_9_1)) then
		return
	end

	set_flow_variable(arg_9_1, "visual_heat", self._weapon_visual_heat)
	flow_event(arg_9_1, "lua_update_visual_heat")
end

PassiveAbilityEngineer._update_weapon_anim_variables = function (self, arg_10_1)
	-- function 10
	local _first_person_extension = self._first_person_extension

	if not _first_person_extension then
		local current_ability_cooldown_percentage = self._career_extension:current_ability_cooldown_percentage()
		local clamp = math.clamp(math.lerp(self._last_ability_charge, current_ability_cooldown_percentage, arg_10_1 * num_6), 0, 1)

		self._last_ability_charge = clamp

		_first_person_extension:animation_set_variable("ammo_count", clamp)
		_first_person_extension:animation_set_variable("wind_down_progress", self._wind_down_progress)
	end
end

PassiveAbilityEngineer.on_engineer_weapon_fire = function (self, arg_11_1)
	-- function 11
	local num_2 = self._weapon_visual_heat + (arg_11_1 or 0)

	self._weapon_visual_heat = math.clamp(num_2, 0, num_4)

	local time = Managers.time:time("game")

	self._heat_cooldown_pause_t = time + num
	self._wind_down_progress = 1
	self._wind_down_cooldown_pause_t = time + num_7
end

PassiveAbilityEngineer.on_engineer_weapon_spin_up = function (self, arg_12_1, arg_12_2)
	-- function 12
	local time = Managers.time:time("game")

	if not arg_12_2 then
		arg_12_1 = (arg_12_1 or 0) / 2 + 0.5
	end

	self._wind_down_progress = math.max(arg_12_1 or 0, self._wind_down_progress)
	self._wind_down_cooldown_pause_t = time + num_7
end

PassiveAbilityEngineer.on_level_start_local_player_spawned = function (self, arg_13_1)
	-- function 13
	if not (not self._is_local_player and self._game_object_id) then
		self:create_game_object()
	end
end

PassiveAbilityEngineer.create_game_object = function (self)
	-- function 14
	local network = Managers.state.network
	local _owner_unit = self._owner_unit
	local unit_game_object_id = network:unit_game_object_id(_owner_unit)
	local tbl = {
		go_type = NetworkLookup.go_types.engineer_career_data,
		unit_game_object_id = unit_game_object_id,
		visual_heat = self._weapon_visual_heat
	}
	local var_14_4 = callback(self, "cb_game_session_disconnect")

	self._game_object_id = network:create_game_object("engineer_career_data", tbl, var_14_4)
end

PassiveAbilityEngineer.on_talents_changed = function (self, arg_15_1, arg_15_2)
	-- function 15
	if arg_15_1 ~= self._owner_unit then
		return
	end

	self:_add_5_2_bombs()
end

PassiveAbilityEngineer._add_5_2_bombs = function (self)
	-- function 16
	if not self._is_server then
		return
	end

	if not self._talent_extension:has_talent("bardin_engineer_upgraded_grenades") then
		return
	end

	local unique_id = self._player:unique_id()
	local get_status_from_unique_id = Managers.party:get_status_from_unique_id(unique_id)

	if not (not not global_is_inside_inn or get_status_from_unique_id.game_mode_data._engineer_upgraded_grenades_added) then
		return
	end

	get_status_from_unique_id.game_mode_data._engineer_upgraded_grenades_added = true

	local str = "grenade_frag_01"
	local str_2 = "slot_grenade"
	local _inventory_extension = self._inventory_extension
	local num_starting_bombs = CareerConstants.dr_engineer.num_starting_bombs

	if Managers.mechanism:current_mechanism_name() == "versus" then
		num_starting_bombs = 1
	end

	for i = _inventory_extension:get_total_item_count(str_2) + 1, num_starting_bombs do
		local invalid_game_object_id = NetworkConstants.invalid_game_object_id
		local go_id = Managers.state.unit_storage:go_id(self._owner_unit)
		local var_16_8 = NetworkLookup.equipment_slots[str_2]
		local var_16_9 = NetworkLookup.item_names[str]

		Managers.state.network.network_transmit:send_rpc_server("rpc_give_equipment", invalid_game_object_id, go_id, var_16_8, var_16_9, Vector3.zero())
	end
end

PassiveAbilityEngineer.set_career_game_object_id = function (self, arg_17_1)
	-- function 17
	self._game_object_id = arg_17_1
end

PassiveAbilityEngineer.cb_game_session_disconnect = function (self)
	-- function 18
	self._game_object_id = nil
end
