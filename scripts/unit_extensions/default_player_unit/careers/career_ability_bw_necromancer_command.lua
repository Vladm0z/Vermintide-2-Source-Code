-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_bw_necromancer_command.lua

local tbl = {
	"rpc_necromancer_command_sacrifice",
	"rpc_necromancer_command_charge"
}
local mirror_array = table.mirror_array({
	"pet",
	"player",
	"enemy"
})

CareerAbilityBWNecromancerCommand = class(CareerAbilityBWNecromancerCommand)

CareerAbilityBWNecromancerCommand.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._owner_unit = arg_1_2
	self._player = arg_1_3.player
	self._is_local = arg_1_3.player.local_player
	self._is_server = arg_1_1.is_server
	self._command_explosion_params = {
		source_attacker_unit = arg_1_2
	}
	self._network_transmit = arg_1_1.network_transmit
	self._network_event_delegate = self._network_transmit.network_event_delegate

	self._network_event_delegate:register(self, unpack(tbl))

	self._unit_storage = arg_1_1.unit_storage
	self._outline_data = nil
	self._target_unit = nil
end

CareerAbilityBWNecromancerCommand.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	self._status_extension = ScriptUnit.extension(arg_2_2, "status_system")
	self._buff_extension = ScriptUnit.extension(arg_2_2, "buff_system")
	self._buff_system = Managers.state.entity:system("buff_system")

	if not self._is_local then
		self._input_extension = ScriptUnit.extension(arg_2_2, "input_system")
		self._fp_extension = ScriptUnit.extension(arg_2_2, "first_person_system")
		self._inventory_extension = ScriptUnit.has_extension(arg_2_2, "inventory_system")
	end

	if self._is_local or not self._is_server then
		self._commander_extension = ScriptUnit.extension(arg_2_2, "ai_commander_system")
	end

	Managers.state.event:register(self, "on_talents_changed", "_on_talents_changed")
	self:_on_talents_changed(arg_2_2, ScriptUnit.extension(arg_2_2, "talent_system"))
end

CareerAbilityBWNecromancerCommand._on_talents_changed = function (self, arg_3_1, arg_3_2)
	-- function 3
	if arg_3_1 ~= self._owner_unit then
		return
	end

	self._has_charge = arg_3_2:has_talent("sienna_necromancer_6_3")

	if not self._is_local then
		self:_cleanup_talent_buffs(arg_3_1)
		self:_add_talent_buffs(arg_3_1)
	end
end

CareerAbilityBWNecromancerCommand.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not (self._is_local or self._is_server) then
		return
	end

	self:_update_outlines(arg_4_2)

	if not self._is_local then
		self:_update_vent_command_target(arg_4_2)
	end
end

CareerAbilityBWNecromancerCommand.destroy = function (self)
	-- function 5
	self._network_event_delegate:unregister(self)

	if not Managers.state.event then
		Managers.state.event:unregister("on_talents_changed", self)
	end
end

CareerAbilityBWNecromancerCommand._update_outlines = function (self, arg_6_1)
	-- function 6
	local _outline_data = self._outline_data

	if not _outline_data then
		local has_extension = ScriptUnit.has_extension(_outline_data.unit, "status_system")

		if not (not HEALTH_ALIVE[_outline_data.unit] and not has_extension and has_extension:is_invisible() or _outline_data.command_type ~= mirror_array.player or has_extension:is_knocked_down()) then
			if not ALIVE[_outline_data.unit] then
				_outline_data.extension:remove_outline(_outline_data.id)
			end

			self._outline_data = nil
		end
	end
end

CareerAbilityBWNecromancerCommand._server_command_sacrifice_pet = function (self, arg_7_1)
	-- function 7
	local node

	if not Unit.has_node(arg_7_1, "j_spine") then
		node = Unit.node(arg_7_1, "j_spine")

		if not node then
			-- Nothing
		end
	end

	node = 0

	::label_7_0::

	local network = Managers.state.network
	local var_7_2 = NetworkLookup.effects["fx/necromancer_skeleton_sacrifice"]
	local unit_game_object_id = network:unit_game_object_id(arg_7_1)

	network:rpc_play_particle_effect(nil, var_7_2, unit_game_object_id, node, Vector3.zero(), Quaternion.identity(), false)

	local locomotion_extension = BLACKBOARDS[arg_7_1].locomotion_extension

	locomotion_extension.death_velocity_boxed = Vector3Box(locomotion_extension:current_velocity())

	AiUtils.kill_unit(arg_7_1)

	if not self._has_explode then
		local var_7_5 = POSITION_LOOKUP[arg_7_1]
		local _owner_unit = self._owner_unit
		local has_extension = ScriptUnit.has_extension(_owner_unit, "career_system")
		local get_career_power_level

		if not has_extension then
			get_career_power_level = has_extension:get_career_power_level()

			if not get_career_power_level then
				-- Nothing
			end
		end

		get_career_power_level = DefaultPowerLevel

		::label_7_1::

		Managers.state.entity:system("area_damage_system"):create_explosion(_owner_unit, var_7_5, Quaternion.identity(), "sienna_necromancer_passive_explosion", 1, "buff", get_career_power_level, false)
	end
end

CareerAbilityBWNecromancerCommand._trigger_charge_sound = function (self)
	-- function 8
	self._fp_extension:play_hud_sound_event("Play_career_necro_skeleton_charge")
end

CareerAbilityBWNecromancerCommand._start_charge_cooldown = function (self)
	-- function 9
	local _buff_extension = self._buff_extension
	local get_buff_type = _buff_extension:get_buff_type("sienna_necromancer_6_3_available_charge")

	self._charge_cooldown_id = _buff_extension:add_buff("sienna_necromancer_6_3_cooldown_charge")

	_buff_extension:remove_buff(get_buff_type.id)
end

CareerAbilityBWNecromancerCommand._add_talent_buffs = function (self, arg_10_1)
	-- function 10
	if not self._has_charge then
		self._buff_extension:add_buff("sienna_necromancer_6_3_available_charge")
	end
end

CareerAbilityBWNecromancerCommand._cleanup_talent_buffs = function (self, arg_11_1)
	-- function 11
	local _buff_extension = self._buff_extension

	if not self._charge_cooldown_id then
		_buff_extension:remove_buff(self._charge_cooldown_id)

		self._charge_cooldown_id = nil
	end

	local get_buff_type = _buff_extension:get_buff_type("sienna_necromancer_6_3_available_charge")

	if not get_buff_type then
		_buff_extension:remove_buff(arg_11_1, get_buff_type.id)
	end
end

CareerAbilityBWNecromancerCommand._add_outline = function (self, arg_12_1, arg_12_2)
	-- function 12
	local has_extension = ScriptUnit.has_extension(arg_12_1, "outline_system")

	if not has_extension then
		local _outline_data = self._outline_data

		if not _outline_data and not ALIVE[_outline_data.unit] then
			_outline_data.extension:remove_outline(_outline_data.id)
		end

		local add_outline = has_extension:add_outline(OutlineSettings.templates.necromancer_command)

		self._outline_data = {
			id = add_outline,
			unit = arg_12_1,
			extension = has_extension,
			command_type = arg_12_2
		}
	end
end

CareerAbilityBWNecromancerCommand.command_attack_enemy = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	if not HEALTH_ALIVE[arg_13_1] then
		return
	end

	if not self._is_local then
		Managers.telemetry_events:necromancer_used_command_item(self._player, "attack")
	end

	local var_13_0 = POSITION_LOOKUP[self._owner_unit]
	local huge = math.huge
	local var_13_2
	local _commander_extension = self._commander_extension
	local get_controlled_units = _commander_extension:get_controlled_units()

	for k in pairs(get_controlled_units) do
		local get_data = Unit.get_data(k, "breed")
		local flag = _commander_extension:command_state(k) == CommandStates.StandingGround

		if not (get_data.name ~= "pet_skeleton_with_shield" or flag) then
			local var_13_7 = POSITION_LOOKUP[k]

			if not var_13_7 then
				_commander_extension:command_attack(k, arg_13_1)

				local distance_squared = Vector3.distance_squared(var_13_7, var_13_0)

				if distance_squared < huge then
					huge = distance_squared
					var_13_2 = k
				end
			end
		end
	end

	self:_play_command_sound()

	if not var_13_2 then
		Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_career_necro_skeleton_charge", var_13_2)
	end

	self:_add_outline(arg_13_1, mirror_array.enemy)

	if not arg_13_2 then
		self:_trigger_charge_sound()
		self:_start_charge_cooldown()

		local go_id = self._unit_storage:go_id(arg_13_1)

		self._network_transmit:send_rpc_server("rpc_necromancer_command_charge", go_id)
	end
end

CareerAbilityBWNecromancerCommand.any_skeleton_targeting_enemy = function (self, arg_14_1)
	-- function 14
	local get_controlled_units = self._commander_extension:get_controlled_units()

	for k in pairs(get_controlled_units) do
		local var_14_1 = BLACKBOARDS[k]

		if not (var_14_1.commander_target == arg_14_1 or var_14_1.target_unit ~= arg_14_1) then
			return true
		end
	end
end

CareerAbilityBWNecromancerCommand.rpc_necromancer_command_charge = function (self, arg_15_1, arg_15_2)
	-- function 15
	if CHANNEL_TO_PEER_ID[arg_15_1] ~= self._player.peer_id then
		return
	end

	local unit = self._unit_storage:unit(arg_15_2)
	local get_controlled_units = self._commander_extension:get_controlled_units()

	for k in pairs(get_controlled_units) do
		local var_15_2 = BLACKBOARDS[k]

		if var_15_2.breed.name == "pet_skeleton_armored" then
			var_15_2.charge_target = unit
		end
	end
end

CareerAbilityBWNecromancerCommand.command_sacrifice = function (self, arg_16_1)
	-- function 16
	if not HEALTH_ALIVE[arg_16_1] then
		return
	end

	if not self._is_local then
		Managers.telemetry_events:necromancer_used_command_item(self._player, "sacrifice")
	end

	if not self._is_server then
		self:_server_command_sacrifice_pet(arg_16_1)
	else
		local go_id = self._unit_storage:go_id(arg_16_1)

		self._network_transmit:send_rpc_server("rpc_necromancer_command_sacrifice", go_id, mirror_array.pet)
		self._commander_extension:remove_controlled_unit(arg_16_1, true)
	end
end

CareerAbilityBWNecromancerCommand.rpc_necromancer_command_sacrifice = function (self, arg_17_1, arg_17_2)
	-- function 17
	if CHANNEL_TO_PEER_ID[arg_17_1] ~= self._player.peer_id then
		return
	end

	local unit = self._unit_storage:unit(arg_17_2)

	self:command_sacrifice(unit)
end

CareerAbilityBWNecromancerCommand._update_vent_command_target = function (self, arg_18_1)
	-- function 18
	local _vent_command_target = self._vent_command_target
	local get_wielded_slot_item_template = self._inventory_extension:get_wielded_slot_item_template()
	local flag = not get_wielded_slot_item_template and get_wielded_slot_item_template.is_command_utility_weapon
	local var_18_3
	local var_18_4

	if not flag then
		local hovered_friendly_unit, var_18_6 = self._commander_extension:hovered_friendly_unit()

		var_18_4 = not not hovered_friendly_unit or not not var_18_6

		if not hovered_friendly_unit then
			local get_controlled_units = self._commander_extension:get_controlled_units()
			local huge = math.huge

			for k, v in pairs(get_controlled_units) do
				local duration = v.template.duration

				if not duration then
					local start_t = v.start_t

					start_t = start_t or math.huge

					local num = start_t + duration - arg_18_1

					if num < huge then
						huge = num
						hovered_friendly_unit = k
					end
				end
			end
		end

		var_18_3 = hovered_friendly_unit or var_18_6
	end

	if not (not self._vent_outline_id and var_18_4 or var_18_3 == _vent_command_target) then
		if not ALIVE[_vent_command_target] then
			local has_extension = ScriptUnit.has_extension(_vent_command_target, "outline_system")

			if not has_extension then
				has_extension:remove_outline(self._vent_outline_id)

				self._vent_outline_id = nil
			end
		end

		if not (not var_18_3 and var_18_4) then
			local game = Managers.state.network:game()
			local go_id = Managers.state.unit_storage:go_id(var_18_3)

			if not go_id then
				local game_object_field = GameSession.game_object_field(game, go_id, "bt_action_name")

				if NetworkLookup.bt_action_names[game_object_field] ~= "spawn" then
					self._vent_outline_id = ScriptUnit.extension(var_18_3, "outline_system"):add_outline(OutlineSettings.templates.necromancer_command)
				end
			end
		end
	end

	self._vent_command_target = var_18_3
end

CareerAbilityBWNecromancerCommand.vent_command_target = function (self)
	-- function 19
	return self._vent_command_target
end

CareerAbilityBWNecromancerCommand.command_stand_ground = function (self, arg_20_1, arg_20_2)
	-- function 20
	local keys = table.keys(self._commander_extension:get_controlled_units(), FrameTable.alloc_table())

	table.array_remove_if(keys, function (arg_21_0)
		-- function 21
		if self._commander_extension:command_state(arg_21_0) == CommandStates.Following then
			return false
		end

		return Unit.get_data(arg_21_0, "breed").name == "pet_skeleton_armored"
	end)
	self:_play_command_sound()

	if not self._is_local then
		Managers.telemetry_events:necromancer_used_command_item(self._player, "defend")
	end

	local system = Managers.state.entity:system("audio_system")

	for i = 1, #keys do
		local var_20_2 = keys[i]

		if not ALIVE[var_20_2] then
			system:play_audio_unit_event("Play_career_necro_skeleton_defend", var_20_2)
		end
	end

	self._commander_extension:command_stand_ground_group(keys, arg_20_1, arg_20_2)
end

CareerAbilityBWNecromancerCommand._play_command_sound = function (self)
	-- function 22
	if not self._fp_extension then
		self._fp_extension:play_hud_sound_event("Play_weapon_necro_command_command")
	end
end
