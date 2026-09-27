-- chunkname: @scripts/settings/dlcs/bless/passive_ability_warrior_priest.lua

PassiveAbilityWarriorPriest = class(PassiveAbilityWarriorPriest)

local num = 6
local animation_set_variable = Unit.animation_set_variable
local set_game_object_field = GameSession.set_game_object_field
local game_object_field = GameSession.game_object_field

PassiveAbilityWarriorPriest.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	self._owner_unit = arg_1_2
	self._player = arg_1_3.player
	self._ability_init_data = arg_1_4
	self._is_active = false
	self._not_in_combat = true
	self._current_resource = 0
	self._max_resource = 100
	self._time_to_ooc = 5
	self._activation_time = 0
	self.uses_resource = true
	self._is_local_human = self._player.local_player

	local _is_local_human = self._is_local_human

	_is_local_human = _is_local_human or self._player.bot_player
	self._is_local_player = _is_local_human
	self._game = Managers.state.network:game()
end

PassiveAbilityWarriorPriest.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	self._buff_system = Managers.state.entity:system("buff_system")
	self._talent_extension = ScriptUnit.has_extension(arg_2_2, "talent_system")
	self._first_person_extension = ScriptUnit.has_extension(arg_2_2, "first_person_system")
	self._inventory_extension = ScriptUnit.has_extension(arg_2_2, "inventory_system")

	if not self._first_person_extension then
		self._fp_unit = self._first_person_extension:get_first_person_unit()
		self._anim_var_3p_id = Unit.animation_find_variable(arg_2_2, "talent_anim_type")

		self:on_talents_changed(arg_2_2, self._talent_extension)
	end

	self:_register_events()
end

PassiveAbilityWarriorPriest.destroy = function (self)
	-- function 3
	self:_unregister_events()
end

PassiveAbilityWarriorPriest._register_events = function (arg_4_0)
	-- function 4
	Managers.state.event:register(arg_4_0, "on_player_killed_enemy", "on_player_killed_enemy")
	Managers.state.event:register(arg_4_0, "on_hit", "on_hit")
	Managers.state.event:register(arg_4_0, "on_weapon_wield", "on_weapon_wield")
	Managers.state.event:register(arg_4_0, "level_start_local_player_spawned", "on_level_start_local_player_spawned")
	Managers.state.event:register(arg_4_0, "on_talents_changed", "on_talents_changed")
end

PassiveAbilityWarriorPriest._unregister_events = function (arg_5_0)
	-- function 5
	if not Managers.state.event then
		Managers.state.event:unregister("on_player_killed_enemy", arg_5_0)
		Managers.state.event:unregister("on_hit", arg_5_0)
		Managers.state.event:unregister("on_weapon_wield", arg_5_0)
		Managers.state.event:unregister("level_start_local_player_spawned", arg_5_0)
		Managers.state.event:unregister("on_talents_changed", arg_5_0)
	end
end

PassiveAbilityWarriorPriest.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	local _game_object_id = self._game_object_id
	local _game = self._game

	if not _game and not _game_object_id then
		if not self._is_local_player then
			local _is_active = self._is_active

			if self._prev_is_active ~= _is_active then
				self._prev_is_active = _is_active

				set_game_object_field(_game, _game_object_id, "fury_active", _is_active)
			end
		else
			local _is_active_2 = self._is_active
			local var_6_4 = game_object_field(_game, _game_object_id, "fury_active")

			if _is_active_2 ~= var_6_4 then
				self._is_active = var_6_4

				self:_set_fury_glow_enabled(var_6_4)
			end
		end
	end

	if not self._is_local_player then
		if not ((self._is_active or not self._not_in_combat) and not (self:degenerate_resource(arg_6_1) <= 0)) then
			self:deactivate_buff()
		end

		self:combat_timer_update(arg_6_2)
	end
end

PassiveAbilityWarriorPriest.on_player_killed_enemy = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	if not ScriptUnit.has_extension(self._owner_unit, "status_system"):is_knocked_down() then
		return
	end

	if not self._is_local_player then
		return
	end

	local _owner_unit = self._owner_unit
	local var_7_1 = POSITION_LOOKUP[_owner_unit]
	local var_7_2 = POSITION_LOOKUP[arg_7_3]
	local distance_squared = Vector3.distance_squared(var_7_1, var_7_2)
	local num = 6

	if distance_squared > num * num then
		return
	end

	local resource_per_breed = self._ability_init_data.resource_per_breed
	local on_normal = resource_per_breed.on_normal

	if not arg_7_2 and not arg_7_2.elite then
		on_normal = resource_per_breed.on_elite
	elseif not arg_7_2 and not arg_7_2.special then
		on_normal = resource_per_breed.on_special
	elseif not arg_7_2 and not arg_7_2.boss then
		on_normal = resource_per_breed.on_boss
	end

	if not self._is_local_human then
		Managers.state.event:trigger("glow_feedback")
	end

	self:modify_resource(on_normal)
end

PassiveAbilityWarriorPriest.on_hit = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8)
	-- function 8
	if not (not self._is_local_player and arg_8_8 ~= self._owner_unit) then
		self:set_in_combat()
	end
end

PassiveAbilityWarriorPriest.buff_on_damage_taken = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	self:modify_resource(arg_9_2)
end

PassiveAbilityWarriorPriest.modify_resource = function (self, arg_10_1, arg_10_2)
	-- function 10
	local flag = self._current_resource ~= self._max_resource

	if arg_10_1 > 0 then
		self:set_in_combat()

		local flag_2 = not not arg_10_2 or Managers.state.difficulty:get_difficulty()

		if not flag_2 then
			self._difficulty_rank = DifficultySettings[flag_2].rank - 1
			arg_10_1 = arg_10_1 * ({
				1.5,
				1.2,
				1,
				1,
				1,
				1,
				0.7,
				1.5
			})[self._difficulty_rank]
		end
	end

	self._current_resource = math.clamp(self._current_resource + arg_10_1, 0, self._max_resource)

	if not (self._current_resource >= self._max_resource) or not flag then
		self:activate_buff()
	end

	return self._current_resource
end

PassiveAbilityWarriorPriest.modify_resource_percent = function (self, arg_11_1)
	-- function 11
	local num = self._max_resource * arg_11_1

	return self:modify_resource(num, true)
end

PassiveAbilityWarriorPriest.get_resource_fraction = function (self)
	-- function 12
	return self._current_resource / self._max_resource
end

PassiveAbilityWarriorPriest.is_active = function (self)
	-- function 13
	return self._is_active
end

PassiveAbilityWarriorPriest.degenerate_resource = function (self, arg_14_1)
	-- function 14
	return self:modify_resource(-num * arg_14_1)
end

PassiveAbilityWarriorPriest.set_in_combat = function (self)
	-- function 15
	self._not_in_combat = false
	self._combat_timer = Managers.time:time("game") + self._time_to_ooc
end

PassiveAbilityWarriorPriest.combat_timer_update = function (self, arg_16_1)
	-- function 16
	if not self._combat_timer then
		self._combat_timer = arg_16_1 + self._time_to_ooc
	end

	if arg_16_1 > self._combat_timer then
		self._not_in_combat = true
	end
end

PassiveAbilityWarriorPriest.activate_buff = function (self)
	-- function 17
	if not self._is_active then
		self._is_active = true
		self._activation_time = Managers.time:time("game")

		local _buff_system = self._buff_system
		local _owner_unit = self._owner_unit

		self._buff_id = _buff_system:add_buff_synced(_owner_unit, "victor_priest_passive_aftershock", BuffSyncType.LocalAndServer)

		Unit.flow_event(_owner_unit, "lua_enable_eye_glow")
		self:_set_fury_glow_enabled(true)

		if not self._ability_on_4_1 then
			ActionCareerWHPriestUtility.cast_spell(_owner_unit, _owner_unit)
		end

		if not self._is_local_human then
			self:_play_vo()
			Managers.state.event:trigger("active_passive_feedback", true)
			Managers.state.achievement:trigger_event("righteous_fury_start", self._owner_unit, self._is_local_human)
		end
	end
end

PassiveAbilityWarriorPriest.deactivate_buff = function (self)
	-- function 18
	if not self._is_active then
		self._is_active = false

		local _buff_system = self._buff_system
		local _buff_id = self._buff_id
		local _owner_unit = self._owner_unit

		_buff_system:remove_buff_synced(_owner_unit, _buff_id)
		Unit.flow_event(_owner_unit, "lua_disable_eye_glow")
		self:_set_fury_glow_enabled(false)

		if not self._is_local_human then
			Managers.state.event:trigger("active_passive_feedback", false)
			Managers.state.achievement:trigger_event("righteous_fury_end", self._owner_unit, self._is_local_human)
		end
	end
end

PassiveAbilityWarriorPriest._play_vo = function (self)
	-- function 19
	local _owner_unit = self._owner_unit
	local extension_input = ScriptUnit.extension_input(_owner_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("activate_fury", alloc_table)
end

PassiveAbilityWarriorPriest._set_fury_glow_enabled = function (self, arg_20_1)
	-- function 20
	local flag

	flag = not arg_20_1 and "lua_enable_eye_glow" and "lua_disable_eye_glow"

	local _inventory_extension = self._inventory_extension

	if not self._is_local_human then
		local get_all_weapon_unit, var_20_3 = _inventory_extension:get_all_weapon_unit()

		if not get_all_weapon_unit then
			Unit.flow_event(get_all_weapon_unit, flag)
		end

		if not var_20_3 then
			Unit.flow_event(var_20_3, flag)
		end
	end

	local equipment = _inventory_extension:equipment()

	if not equipment then
		local left_hand_wielded_unit_3p = equipment.left_hand_wielded_unit_3p
		local right_hand_wielded_unit_3p = equipment.right_hand_wielded_unit_3p

		if not left_hand_wielded_unit_3p then
			Unit.flow_event(left_hand_wielded_unit_3p, flag)
		end

		if not right_hand_wielded_unit_3p then
			Unit.flow_event(right_hand_wielded_unit_3p, flag)
		end
	end

	Unit.flow_event(self._owner_unit, flag)
end

PassiveAbilityWarriorPriest.on_weapon_wield = function (self, arg_21_1)
	-- function 21
	self:_set_fury_glow_enabled(self._is_active)
end

PassiveAbilityWarriorPriest.on_level_start_local_player_spawned = function (self, arg_22_1)
	-- function 22
	if not (not self._is_local_player and self._game_object_id) then
		self:create_game_object()
	end
end

PassiveAbilityWarriorPriest.on_talents_changed = function (self, arg_23_1, arg_23_2)
	-- function 23
	if arg_23_1 ~= self._owner_unit then
		return
	end

	local num = 0

	if not arg_23_2 then
		if not arg_23_2:has_talent("victor_priest_6_1") then
			num = 0
		elseif not arg_23_2:has_talent("victor_priest_6_2") then
			num = 1
		elseif not arg_23_2:has_talent("victor_priest_6_3") then
			num = 2
		end
	end

	self._ability_on_4_1 = arg_23_2:has_talent("victor_priest_4_1_new")

	local _fp_unit = self._fp_unit

	if not ALIVE[_fp_unit] then
		self._first_person_extension:animation_set_variable("talent_anim_type", num)
	end

	local var_23_2 = arg_23_1

	if not ALIVE[var_23_2] and not self._anim_var_3p_id then
		animation_set_variable(var_23_2, self._anim_var_3p_id, num)
	end
end

PassiveAbilityWarriorPriest.create_game_object = function (self)
	-- function 24
	local network = Managers.state.network
	local _owner_unit = self._owner_unit
	local unit_game_object_id = network:unit_game_object_id(_owner_unit)
	local tbl = {
		go_type = NetworkLookup.go_types.priest_career_data,
		unit_game_object_id = unit_game_object_id,
		fury_active = self._is_active
	}
	local var_24_4 = callback(self, "cb_game_session_disconnect")

	self._game_object_id = network:create_game_object("priest_career_data", tbl, var_24_4)
end

PassiveAbilityWarriorPriest.set_career_game_object_id = function (self, arg_25_1)
	-- function 25
	self._game_object_id = arg_25_1
end

PassiveAbilityWarriorPriest.cb_game_session_disconnect = function (self)
	-- function 26
	self._game_object_id = nil
end
