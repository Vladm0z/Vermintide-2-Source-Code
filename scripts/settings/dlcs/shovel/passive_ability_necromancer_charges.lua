-- chunkname: @scripts/settings/dlcs/shovel/passive_ability_necromancer_charges.lua

local tbl = {
	"rpc_necromancer_passive_spawn_pet",
	"rpc_necromancer_respawn_all_pets",
	"rpc_necromancer_passive_kill_pets"
}
local var_0_1
local var_0_2

NecromancerPositionModes, var_0_2 = table.enum_lookup("Absolute", "Relative")
PassiveAbilityNecromancerCharges = class(PassiveAbilityNecromancerCharges)

PassiveAbilityNecromancerCharges.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	self._player = arg_1_3.player
	self._is_local = arg_1_3.player.local_player
	self._owner_unit = arg_1_2
	self._is_server = arg_1_1.is_server
	self._nav_world = Managers.state.entity:system("ai_system"):nav_world()
	self._army_definition = {}
	self._spawn_queue = {}
	self._queued_pets = {}
	self._spawned_pets = {}
	self._num_queued_pets = 0
	self._pet_respawn_buffs = {}
	self._last_spawn_index = 0
	self._resummon_spawn_data = {}
	self._network_transmit = arg_1_1.network_transmit
	self._network_event_delegate = self._network_transmit.network_event_delegate

	self._network_event_delegate:register(self, unpack(tbl))

	self._unit_storage = arg_1_1.unit_storage
	self._ping_explosion_params = {
		source_attacker_unit = arg_1_2
	}
	self._dual_wield_params = {
		source_attacker_unit = arg_1_2
	}
	self._achv_staff_gandalf_data = {}
end

PassiveAbilityNecromancerCharges.warm_up_skeletons = function (arg_2_0, arg_2_1)
	-- function 2
	print("Necromancer - Warm up skeletons:")

	local enemy_package_loader = Managers.level_transition_handler.enemy_package_loader
	local flag = true

	for i, v in ipairs(arg_2_1) do
		if not enemy_package_loader:is_breed_processed(v) then
			printf("\t -> %s", v)
			enemy_package_loader:request_breed(v, flag)
		end
	end
end

PassiveAbilityNecromancerCharges.extensions_ready = function (self, arg_3_1, arg_3_2)
	-- function 3
	self._buff_system = Managers.state.entity:system("buff_system")
	self._buff_extension = ScriptUnit.extension(arg_3_2, "buff_system")
	self._status_extension = ScriptUnit.extension(arg_3_2, "status_system")
	self._talent_extension = ScriptUnit.extension(arg_3_2, "talent_system")
	self._cutscene_system = Managers.state.entity:system("cutscene_system")

	local has_extension = ScriptUnit.has_extension(arg_3_2, "career_system")

	if not has_extension then
		local ability_id = has_extension:ability_id("bw_necromancer")

		self._career_ability = has_extension:ability_by_id(ability_id)
	end

	if self._is_local or not self._is_server then
		self._commander_extension = ScriptUnit.extension(arg_3_2, "ai_commander_system")
	end

	self:_register_events()
	self:_on_talents_changed(arg_3_2, ScriptUnit.extension(arg_3_2, "talent_system"))

	self._start_update_t = Managers.time:time("game") + 3
end

PassiveAbilityNecromancerCharges._on_talents_changed = function (self, arg_4_1, arg_4_2)
	-- function 4
	if arg_4_1 ~= self._owner_unit then
		return
	end

	self._has_army = arg_4_2:has_talent("sienna_necromancer_6_1")
	self._has_dual_wield = arg_4_2:has_talent("sienna_necromancer_6_2")

	if not arg_4_2:has_talent("sienna_necromancer_6_3") then
		self._army_definition = {
			"pet_skeleton_with_shield",
			"pet_skeleton_with_shield",
			"pet_skeleton_with_shield",
			"pet_skeleton_armored",
			"pet_skeleton_armored",
			"pet_skeleton_armored"
		}
	elseif not self._has_dual_wield then
		self._army_definition = table.fill({}, 6, "pet_skeleton_dual_wield")
	else
		self._army_definition = table.fill({}, 6, "pet_skeleton")
	end

	local _has_army = self._has_army

	_has_army = not _has_army and table.fill({}, 6, "pet_skeleton")
	self._extra_army_skeletons = _has_army

	local in_hub_level = Managers.level_transition_handler:in_hub_level()
	local pets_forbidden_in_hub = script_data.pets_forbidden_in_hub

	pets_forbidden_in_hub = not pets_forbidden_in_hub and in_hub_level
	self._pets_forbidden_in_level = pets_forbidden_in_hub

	if not self._is_server then
		self:warm_up_skeletons(self._army_definition)
	end

	self._force_respawn_pets = true
end

PassiveAbilityNecromancerCharges._register_events = function (arg_5_0)
	-- function 5
	Managers.state.event:register(arg_5_0, "on_talents_changed", "_on_talents_changed")
end

PassiveAbilityNecromancerCharges._unregister_events = function (arg_6_0)
	-- function 6
	if not Managers.state.event then
		Managers.state.event:unregister("on_talents_changed", arg_6_0)
	end
end

PassiveAbilityNecromancerCharges.destroy = function (self)
	-- function 7
	self._network_event_delegate:unregister(self)
	self:_unregister_events()

	if not Managers.state.network:in_game_session() then
		return
	end

	if not Managers.state.network.profile_synchronizer:get_own_actually_ingame() then
		return
	end

	if not self._is_server then
		self:_kill_all_pets_server(true)
	end
end

PassiveAbilityNecromancerCharges.update = function (self, arg_8_1, arg_8_2)
	-- function 8
	if arg_8_2 < self._start_update_t then
		return
	end

	if not self._is_server then
		self:_update_pets_server()
		self:_update_spawning(arg_8_2)
	end

	self:_update_achievements(arg_8_2)
end

local tbl_2 = {}
local num = 4
local num_2 = 10
local num_3 = math.pi * 0.05

for i = 1, num_2 do
	local num_4 = (i - (num_2 * 0.5 - 0.5)) * num_3
	local var_0_8 = Vector3Box(Quaternion.rotate(Quaternion.axis_angle(Vector3.up(), num_4), Vector3.forward()) * num)

	tbl_2[#tbl_2 + 1] = var_0_8
end

PassiveAbilityNecromancerCharges.spawn_army_pet = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local _army_definition = self._army_definition
	local str = "necromancer_pet_charges"
	local var_9_2 = _army_definition[arg_9_1]
	local count = #_army_definition
	local flag = count <= arg_9_1
	local _extra_army_skeletons = self._extra_army_skeletons

	if not flag and not _extra_army_skeletons then
		flag = false

		if not var_9_2 then
			arg_9_1 = arg_9_1 - count
			var_9_2 = _extra_army_skeletons[arg_9_1]
			str = "necromancer_pet_army"
			flag = arg_9_1 >= #_extra_army_skeletons
		end
	end

	if not var_9_2 then
		self:spawn_pet(str, var_9_2, arg_9_2, arg_9_3)
	end

	return flag
end

PassiveAbilityNecromancerCharges.spawn_pet = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	if not self._pets_forbidden_in_level then
		return
	end

	if not arg_10_3 then
		self._last_spawn_index = self._last_spawn_index + 1
		arg_10_3 = tbl_2[self._last_spawn_index % #tbl_2 + 1]:unbox()
		arg_10_4 = NecromancerPositionModes.Relative
	end

	if not self._is_server then
		self:_queue_pet(arg_10_2, arg_10_3, arg_10_4, arg_10_1)
	else
		local _network_transmit = self._network_transmit
		local var_10_1 = NetworkLookup.breeds[arg_10_2]
		local var_10_2 = NetworkLookup.controlled_unit_templates[arg_10_1]
		local var_10_3 = var_0_2[arg_10_4]

		_network_transmit:send_rpc_server("rpc_necromancer_passive_spawn_pet", var_10_2, var_10_1, arg_10_3, var_10_3)
	end
end

PassiveAbilityNecromancerCharges.spawn_pets = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	for i = 1, arg_11_1 do
		self:spawn_pet(arg_11_2, arg_11_3)
	end
end

PassiveAbilityNecromancerCharges._queue_pet = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	-- function 12
	if not self:is_invalid_spawn_position(arg_12_2) then
		arg_12_2 = Vector3.zero()
		arg_12_3 = NecromancerPositionModes.Relative
	end

	self._spawn_queue[#self._spawn_queue + 1] = {
		breed_name = arg_12_1,
		position = Vector3Box(arg_12_2),
		position_mode = arg_12_3,
		template_name = arg_12_4
	}
end

PassiveAbilityNecromancerCharges.store_buff_unit = function (self, arg_13_1)
	-- function 13
	self._buff_unit = arg_13_1
end

PassiveAbilityNecromancerCharges.is_ready = function (self)
	-- function 14
	if not ALIVE[self._buff_unit] then
		return true
	end

	return not ScriptUnit.extension(self._buff_unit, "buff_system"):has_buff_type("raise_dead_ability")
end

PassiveAbilityNecromancerCharges.rpc_necromancer_passive_spawn_pet = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	assert(self._is_server, "[PassiveAbilityNecromancerCharges] 'rpc_necromancer_passive_spawn_pet' is a server only function.")

	if CHANNEL_TO_PEER_ID[arg_15_1] ~= self._player.peer_id then
		return
	end

	local var_15_0 = NetworkLookup.breeds[arg_15_3]
	local var_15_1 = NetworkLookup.controlled_unit_templates[arg_15_2]
	local var_15_2 = var_0_2[arg_15_5]

	self:_queue_pet(var_15_0, arg_15_4, var_15_2, var_15_1)
end

PassiveAbilityNecromancerCharges.kill_pets = function (self, arg_16_1)
	-- function 16
	if not self._is_server then
		self._network_transmit:send_rpc_server("rpc_necromancer_passive_kill_pets")

		return
	end

	if not self._has_army then
		for k, v in pairs(self._spawned_pets) do
			if not (not HEALTH_ALIVE[k] and v == "necromancer_pet_army") then
				self:_remove_unit(k)
				AiUtils.kill_unit(k)
			end
		end
	else
		self:_kill_all_pets_server(false)
	end
end

PassiveAbilityNecromancerCharges.rpc_necromancer_passive_kill_pets = function (self, arg_17_1)
	-- function 17
	assert(self._is_server, "[PassiveAbilityNecromancerCharges] 'rpc_necromancer_passive_kill_pets' is a server only function.")

	local var_17_0 = CHANNEL_TO_PEER_ID[arg_17_1]

	if var_17_0 ~= self._player.peer_id then
		return
	end

	self:kill_pets(var_17_0)
end

PassiveAbilityNecromancerCharges.rpc_necromancer_respawn_all_pets = function (self, arg_18_1)
	-- function 18
	assert(self._is_server, "[PassiveAbilityNecromancerCharges] 'rpc_necromancer_respawn_pets' is a server only function.")

	if CHANNEL_TO_PEER_ID[arg_18_1] ~= self._player.peer_id then
		return
	end

	for k in pairs(self._pet_respawn_buffs) do
		self:consume_pet_charge(k)
	end
end

PassiveAbilityNecromancerCharges._update_pets_server = function (self)
	-- function 19
	if not self._pets_forbidden_in_level then
		return
	end

	local _status_extension = self._status_extension

	if not ((_status_extension:is_dead() or not _status_extension:is_ready_for_assisted_respawn()) and self._was_dead) then
		self._was_dead = true

		self:_kill_all_pets_server()
	end
end

PassiveAbilityNecromancerCharges.invalid_spawn_position = function (arg_20_0)
	-- function 20
	return Vector3(0, 0, -500)
end

PassiveAbilityNecromancerCharges.is_invalid_spawn_position = function (arg_21_0, arg_21_1)
	-- function 21
	return not arg_21_1 and arg_21_1[3] < -400
end

PassiveAbilityNecromancerCharges._spawn_pet_server = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	-- function 22
	local _commander_extension = self._commander_extension
	local _buff_extension = self._buff_extension
	local _owner_unit = self._owner_unit
	local side_id = Managers.state.side.side_by_unit[_owner_unit].side_id
	local str = "resurrected"
	local _queued_pets = self._queued_pets
	local var_22_6 = Breeds[arg_22_1]
	local tbl = {
		ignore_event_counter = true,
		ignore_breed_limits = true,
		side_id = side_id,
		spawned_func = function (arg_23_0, arg_23_1, arg_23_2)
			-- function 23
			if not ALIVE[_owner_unit] then
				self._spawned_pets[arg_23_0] = arg_22_4
				_queued_pets[arg_23_2] = nil
				self._num_queued_pets = self._num_queued_pets - 1

				_buff_extension:trigger_procs("on_pet_spawned", arg_23_0)

				local alloc_table = FrameTable.alloc_table()

				alloc_table.source_attacker_unit = _owner_unit

				self._buff_system:add_buff_synced(arg_23_0, "sienna_necromancer_pet_attack_sfx", BuffSyncType.Local, alloc_table, self._player.peer_id)
				self._buff_system:add_buff_synced(arg_23_0, "update_anim_movespeed", BuffSyncType.All)

				if not self._has_dual_wield then
					self._buff_system:add_buff_synced(arg_23_0, "sienna_necromancer_passive_balefire", BuffSyncType.Local)
				end

				if arg_22_4 == "necromancer_pet_charges" then
					if not self._has_dual_wield then
						self._buff_system:add_buff_synced(arg_23_0, "sienna_necromancer_6_2_pet_buff", BuffSyncType.Local, self._dual_wield_params)
					end
				elseif arg_22_4 == "necromancer_pet_ability" then
					local var_23_1 = BLACKBOARDS[arg_23_0]

					var_23_1.ability_spawned = true
					var_23_1.dont_follow_commander = true

					if not self._talent_extension:has_talent("sienna_necromancer_6_3_2") then
						var_23_1.navigation_extension:add_movement_modifier(0.35 + math.random() * 0.2)
					end
				end

				local time = Managers.time:time("game")

				_commander_extension:add_controlled_unit(arg_23_0, arg_22_4, time)
				self:_extract_resummon_data(arg_23_0, arg_22_4)
			end
		end
	}
	local var_22_8

	if not self._first_person_extension then
		var_22_8 = self._first_person_extension:current_rotation()
		var_22_8 = Quaternion.look(Vector3.flat(Quaternion.forward(var_22_8)), Vector3.up())
	else
		local go_id = self._unit_storage:go_id(_owner_unit)
		local game = Managers.state.network:game()
		local game_object_field = GameSession.game_object_field(game, go_id, "aim_direction")

		var_22_8 = Quaternion.look(Vector3.flat(game_object_field), Vector3.up())
	end

	if arg_22_3 == NecromancerPositionModes.Relative then
		arg_22_2 = POSITION_LOOKUP[_owner_unit] + Quaternion.rotate(var_22_8, arg_22_2)
	end

	local _nav_world = self._nav_world
	local triangle_from_position, var_22_14 = GwNavQueries.triangle_from_position(_nav_world, arg_22_2, 2, 2)

	if not triangle_from_position then
		arg_22_2.z = var_22_14
	else
		arg_22_2 = GwNavQueries.inside_position_from_outside_position(_nav_world, arg_22_2, 2, 2, 5, 1)
	end

	if not arg_22_2 then
		return false
	end

	_queued_pets[tbl] = Managers.state.conflict:spawn_queued_unit(var_22_6, Vector3Box(arg_22_2), QuaternionBox(var_22_8), str, nil, nil, tbl)
	self._num_queued_pets = self._num_queued_pets + 1

	return true
end

PassiveAbilityNecromancerCharges._kill_all_pets_server = function (self, arg_24_1)
	-- function 24
	local _queued_pets = self._queued_pets

	for k, v in pairs(_queued_pets) do
		_queued_pets[k] = nil
		self._num_queued_pets = self._num_queued_pets - 1

		Managers.state.conflict:remove_queued_unit(v)
	end

	self._disable_pet_charges = true

	local _spawned_pets = self._spawned_pets

	for k_2 in pairs(_spawned_pets) do
		self:_remove_unit(k_2)

		if not HEALTH_ALIVE[k_2] then
			AiUtils.kill_unit(k_2)
		end
	end

	self._disable_pet_charges = false

	if not arg_24_1 then
		return
	end

	self:_remove_pet_charges()
end

PassiveAbilityNecromancerCharges.resummon_pet = function (self, arg_25_1)
	-- function 25
	local get_controlled_units = ScriptUnit.extension(self._owner_unit, "ai_commander_system"):get_controlled_units()

	get_controlled_units = get_controlled_units or EMPTY_TABLE

	local template = get_controlled_units[arg_25_1].template
	local name

	if not template then
		name = template.name

		if not name then
			-- Nothing
		end
	end

	name = self._spawned_pets[arg_25_1]

	::label_25_0::

	self:_gather_resummon_data(arg_25_1, name)

	self._disable_pet_charges = true

	self:_remove_unit(arg_25_1)
	AiUtils.kill_unit(arg_25_1)

	local name_2 = BLACKBOARDS[arg_25_1].breed.name

	self:spawn_pets(1, name, name_2)

	self._disable_pet_charges = false
end

local tbl_3 = {}

PassiveAbilityNecromancerCharges._gather_resummon_data = function (self, arg_26_1, arg_26_2)
	-- function 26
	if not self._is_server then
		return
	end

	local get_controlled_units = ScriptUnit.extension(self._owner_unit, "ai_commander_system"):get_controlled_units()

	get_controlled_units = get_controlled_units or tbl_3

	local start_t = get_controlled_units[arg_26_1].start_t
	local get_damage_taken = ScriptUnit.extension(arg_26_1, "health_system"):get_damage_taken()
	local _resummon_spawn_data = self._resummon_spawn_data
	local var_26_4 = self._resummon_spawn_data[arg_26_2]

	var_26_4 = var_26_4 or {}
	_resummon_spawn_data[arg_26_2] = var_26_4
	self._resummon_spawn_data[arg_26_2][#self._resummon_spawn_data[arg_26_2] + 1] = {
		damage_taken = get_damage_taken,
		start_t = start_t
	}
end

PassiveAbilityNecromancerCharges._extract_resummon_data = function (self, arg_27_1, arg_27_2)
	-- function 27
	local var_27_0 = self._resummon_spawn_data[arg_27_2]

	if not var_27_0 then
		return
	end

	local var_27_1 = var_27_0[#var_27_0]
	local damage_taken = var_27_1.damage_taken
	local start_t = var_27_1.start_t

	ScriptUnit.extension(self._owner_unit, "ai_commander_system"):get_controlled_units()[arg_27_1].start_t = start_t

	ScriptUnit.extension(arg_27_1, "health_system"):set_server_damage_taken(var_27_1.damage_taken)

	var_27_0[#var_27_0] = nil

	if #var_27_0 == 0 then
		self._resummon_spawn_data[arg_27_2] = nil
	end
end

PassiveAbilityNecromancerCharges._remove_unit = function (self, arg_28_1)
	-- function 28
	self._spawned_pets[arg_28_1] = nil

	self._commander_extension:remove_controlled_unit(arg_28_1)
end

PassiveAbilityNecromancerCharges.add_pet_charge = function (self, arg_29_1, arg_29_2)
	-- function 29
	assert(self._is_server, "[PassiveAbilityNecromancerCharges] Local only function")
	Managers.state.event:unregister_referenced("on_ai_unit_destroyed", arg_29_1, self)

	if not self._disable_pet_charges then
		return
	end

	local var_29_0

	if not arg_29_2 then
		var_29_0 = FrameTable.alloc_table()
		var_29_0.external_optional_duration = arg_29_2
	end

	local add_buff_synced = self._buff_system:add_buff_synced(self._owner_unit, "sienna_pet_spawn_charge", BuffSyncType.ClientAndServer, var_29_0, self._player.peer_id)

	self._pet_respawn_buffs[add_buff_synced] = true
end

PassiveAbilityNecromancerCharges.consume_pet_charge = function (self, arg_30_1)
	-- function 30
	assert(self._is_server, "[PassiveAbilityNecromancerCharges] Local only function")

	self._pet_respawn_buffs[arg_30_1] = nil

	self._buff_system:remove_buff_synced(self._owner_unit, arg_30_1)
	self:spawn_pets(1, "necromancer_pet_charges")
end

PassiveAbilityNecromancerCharges._remove_pet_charges = function (self)
	-- function 31
	assert(self._is_server, "[PassiveAbilityNecromancerCharges] Local only function")

	local _owner_unit = self._owner_unit
	local _buff_system = self._buff_system

	for k in pairs(self._pet_respawn_buffs) do
		_buff_system:remove_buff_synced(_owner_unit, k)

		self._pet_respawn_buffs[k] = nil
	end
end

PassiveAbilityNecromancerCharges._update_spawning = function (self, arg_32_1)
	-- function 32
	if not self._cutscene_system:is_active() then
		return
	end

	local num = 0
	local _spawn_queue = self._spawn_queue

	for i = 1, #_spawn_queue do
		local var_32_2 = _spawn_queue[i]
		local breed_name = var_32_2.breed_name
		local position = var_32_2.position
		local template_name = var_32_2.template_name
		local position_mode = var_32_2.position_mode
		local _spawn_pet_server = self:_spawn_pet_server(breed_name, position:unbox(), position_mode, template_name)

		_spawn_queue[i] = nil

		if not _spawn_pet_server then
			num = num + 1
			_spawn_queue[num] = var_32_2
		end
	end
end

PassiveAbilityNecromancerCharges._update_achievements = function (self, arg_33_1)
	-- function 33
	if not self._is_local then
		self:_achievement_staff_gandalf_update(arg_33_1)
	end
end

PassiveAbilityNecromancerCharges.achievement_staff_gandalf_trigger = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	-- function 34
	arg_34_0._achv_staff_gandalf_data[arg_34_1] = arg_34_2 + arg_34_3
end

PassiveAbilityNecromancerCharges._achievement_staff_gandalf_update = function (self, arg_35_1)
	-- function 35
	for k, v in pairs(self._achv_staff_gandalf_data) do
		if v < arg_35_1 then
			self._achv_staff_gandalf_data[k] = nil

			Managers.state.achievement:trigger_event("necromancer_staff_gandalf_delayed_check", k)
		end
	end
end
