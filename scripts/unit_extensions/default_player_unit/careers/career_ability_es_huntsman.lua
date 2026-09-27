-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_es_huntsman.lua

CareerAbilityESHuntsman = class(CareerAbilityESHuntsman)

CareerAbilityESHuntsman.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.owner_unit = arg_1_2
	self.world = arg_1_1.world
	self.wwise_world = Managers.world:wwise_world(self.world)

	local player = arg_1_3.player

	self.player = player
	self.is_server = player.is_server
	self.local_player = player.local_player
	self.bot_player = player.bot_player
	self.network_manager = Managers.state.network
	self.input_manager = Managers.input
end

CareerAbilityESHuntsman.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	self._status_extension = ScriptUnit.extension(arg_2_2, "status_system")
	self._career_extension = ScriptUnit.extension(arg_2_2, "career_system")
	self._buff_extension = ScriptUnit.extension(arg_2_2, "buff_system")
	self._inventory_extension = ScriptUnit.extension(arg_2_2, "inventory_system")
	self._input_extension = ScriptUnit.has_extension(arg_2_2, "input_system")
	self._first_person_extension = ScriptUnit.has_extension(arg_2_2, "first_person_system")
end

CareerAbilityESHuntsman.destroy = function (arg_3_0)
	-- function 3
	return
end

CareerAbilityESHuntsman.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	if not self:_ability_available() then
		return
	end

	local _input_extension = self._input_extension

	if not _input_extension then
		return
	end

	if not _input_extension:get("action_career") then
		self:_run_ability()
	end
end

CareerAbilityESHuntsman.stop = function (self, arg_5_1)
	-- function 5
	if not self._is_priming then
		self:_stop_priming()
	end
end

CareerAbilityESHuntsman._ability_available = function (self)
	-- function 6
	local _career_extension = self._career_extension
	local _status_extension = self._status_extension
	local can_use_activated_ability = _career_extension:can_use_activated_ability()
	local is_disabled = _status_extension:is_disabled()
	local str = "slot_ranged"
	local flag = self._inventory_extension:get_slot_data(str) ~= nil

	return not can_use_activated_ability and not not is_disabled or flag
end

CareerAbilityESHuntsman.force_trigger_ability = function (self)
	-- function 7
	local flag = true

	self:_run_ability(flag)
end

CareerAbilityESHuntsman._run_ability = function (self, arg_8_1)
	-- function 8
	local owner_unit = self.owner_unit
	local is_server = self.is_server
	local local_player = self.local_player
	local bot_player = self.bot_player
	local network_manager = self.network_manager
	local network_transmit = network_manager.network_transmit
	local _inventory_extension = self._inventory_extension
	local _buff_extension = self._buff_extension
	local _career_extension = self._career_extension
	local extension = ScriptUnit.extension(owner_unit, "talent_system")
	local tbl = {
		"markus_huntsman_activated_ability",
		"markus_huntsman_activated_ability_headshot_multiplier"
	}
	local tbl_2 = {}

	if not extension:has_talent("markus_huntsman_activated_ability_improved_stealth") then
		tbl_2 = {
			"markus_huntsman_activated_ability_increased_reload_speed",
			"markus_huntsman_activated_ability_decrease_move_speed",
			"markus_huntsman_activated_ability_decrease_crouch_move_speed",
			"markus_huntsman_activated_ability_decrease_walk_move_speed",
			"markus_huntsman_activated_ability_decrease_dodge_speed",
			"markus_huntsman_activated_ability_decrease_dodge_distance"
		}
	elseif not extension:has_talent("markus_huntsman_activated_ability_duration") then
		tbl_2 = {
			"markus_huntsman_activated_ability_increased_zoom_duration",
			"markus_huntsman_activated_ability_increased_reload_speed_duration",
			"markus_huntsman_activated_ability_decrease_move_speed_duration",
			"markus_huntsman_activated_ability_decrease_crouch_move_speed_duration",
			"markus_huntsman_activated_ability_decrease_walk_move_speed_duration",
			"markus_huntsman_activated_ability_decrease_dodge_speed_duration",
			"markus_huntsman_activated_ability_decrease_dodge_distance_duration",
			"markus_huntsman_end_activated_on_hit_duration"
		}
		tbl = {
			"markus_huntsman_activated_ability_duration",
			"markus_huntsman_activated_ability_headshot_multiplier_duration"
		}
	else
		tbl_2 = {
			"markus_huntsman_activated_ability_increased_reload_speed",
			"markus_huntsman_activated_ability_decrease_move_speed",
			"markus_huntsman_activated_ability_decrease_crouch_move_speed",
			"markus_huntsman_activated_ability_decrease_walk_move_speed",
			"markus_huntsman_activated_ability_decrease_dodge_speed",
			"markus_huntsman_activated_ability_decrease_dodge_distance",
			"markus_huntsman_end_activated_on_hit"
		}
		tbl = {
			"markus_huntsman_activated_ability",
			"markus_huntsman_activated_ability_headshot_multiplier"
		}
	end

	local unit_game_object_id = network_manager:unit_game_object_id(owner_unit)

	for i, v in ipairs(tbl) do
		local var_8_13 = NetworkLookup.buff_templates[v]

		if not is_server then
			_buff_extension:add_buff(v, {
				attacker_unit = owner_unit
			})
			network_transmit:send_rpc_clients("rpc_add_buff", unit_game_object_id, var_8_13, unit_game_object_id, 0, false)
		else
			network_transmit:send_rpc_server("rpc_add_buff", unit_game_object_id, var_8_13, unit_game_object_id, 0, true)
		end
	end

	for i_2, v_2 in ipairs(tbl_2) do
		_buff_extension:add_buff(v_2, {
			attacker_unit = owner_unit
		})
	end

	if not extension:has_talent("markus_huntsman_activated_ability_cooldown_2") then
		local get_non_stacking_buff = _buff_extension:get_non_stacking_buff("markus_huntsman_passive")
		local max_sub_buff_stacks = get_non_stacking_buff.template.max_sub_buff_stacks

		if not get_non_stacking_buff.buff_list then
			get_non_stacking_buff.buff_list = {}
		end

		for i4 = 1, max_sub_buff_stacks do
			if max_sub_buff_stacks > #get_non_stacking_buff.buff_list then
				table.insert(get_non_stacking_buff.buff_list, _buff_extension:add_buff("markus_huntsman_auto_headshot"))
			end
		end
	end

	local str = "slot_ranged"
	local get_slot_data = _inventory_extension:get_slot_data(str)
	local right_unit_1p = get_slot_data.right_unit_1p
	local left_unit_1p = get_slot_data.left_unit_1p
	local has_extension = ScriptUnit.has_extension(right_unit_1p, "ammo_system")
	local has_extension_2 = ScriptUnit.has_extension(left_unit_1p, "ammo_system")
	local flag = has_extension or has_extension_2

	if not flag then
		local clip_size = flag:clip_size()
		local ammo_count = flag:ammo_count()
		local remaining_ammo = flag:remaining_ammo()
		local flag_2 = ammo_count == 0
		local flag_3 = ammo_count == clip_size
		local num = 0

		if not flag_2 then
			num = clip_size
		elseif not flag_3 then
			if remaining_ammo == 0 then
				num = clip_size
			elseif remaining_ammo < clip_size then
				num = clip_size - remaining_ammo
			end
		elseif remaining_ammo == 0 then
			num = clip_size - ammo_count + clip_size
		elseif remaining_ammo < clip_size then
			num = clip_size - ammo_count + (clip_size - remaining_ammo)
		else
			num = clip_size - ammo_count
		end

		flag:add_ammo_to_reserve(num)

		if not flag:can_reload() then
			if not flag_2 then
				flag:start_reload(true)
			else
				flag:instant_reload(false, "reload")
			end
		end
	end

	local _first_person_extension = self._first_person_extension

	if not local_player then
		_first_person_extension:play_hud_sound_event("Play_career_ability_markus_huntsman_enter", nil, true)
		_first_person_extension:play_hud_sound_event("Play_career_ability_markus_huntsman_loop")
		_first_person_extension:animation_event("shade_stealth_ability")
		_career_extension:set_state("markus_activate_huntsman")
		Managers.state.camera:set_mood("skill_huntsman_surge", "skill_huntsman_surge", false)
		Managers.state.camera:set_mood("skill_huntsman_stealth", "skill_huntsman_stealth", true)
	end

	if not arg_8_1 then
		_career_extension:start_activated_ability_cooldown()
	end

	self:_play_vo()
end

CareerAbilityESHuntsman._play_vo = function (self)
	-- function 9
	local owner_unit = self.owner_unit
	local extension_input = ScriptUnit.extension_input(owner_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("activate_ability", alloc_table)
end
