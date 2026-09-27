-- chunkname: @scripts/entity_system/systems/damage/death_system.lua

DeathSystem = class(DeathSystem, ExtensionSystemBase)

local tbl = {
	"rpc_forced_kill"
}
local tbl_2 = {
	"GenericDeathExtension"
}
local BLACKBOARDS = BLACKBOARDS

DeathSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	DeathSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))

	self.unit_extensions = {}
	self.frozen_unit_extensions = {}
	self.death_reactions_to_start = {}
	self.active_reactions = {
		unit = {},
		husk = {}
	}
	self._current_death_reaction_killing_blow = nil
end

DeathSystem.destroy = function (self)
	-- function 2
	self.network_event_delegate:unregister(self)
end

DeathSystem.on_add_extension = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local add_extension = ScriptUnit.add_extension(self.extension_init_context, arg_3_2, arg_3_3, self.NAME, arg_3_4)

	self.unit_extensions[arg_3_2] = add_extension

	local death_reaction_template = arg_3_4.death_reaction_template

	death_reaction_template = death_reaction_template or Unit.get_data(arg_3_2, "death_reaction")

	self:set_death_reaction_template(arg_3_2, death_reaction_template)
	fassert(add_extension.death_reaction_template, "Missing death reaction template in unit data or extension init data.")

	return add_extension
end

DeathSystem.extensions_ready = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	arg_4_0.unit_extensions[arg_4_2].health_extension = ScriptUnit.extension(arg_4_2, "health_system")
end

DeathSystem.on_remove_extension = function (self, arg_5_1, arg_5_2)
	-- function 5
	self.frozen_unit_extensions[arg_5_1] = nil

	self:_cleanup_extension(arg_5_1, arg_5_2)
	ScriptUnit.remove_extension(arg_5_1, self.NAME)
end

DeathSystem.on_freeze_extension = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	ferror("Shouldn't get called, should run during death until unspawned/frozen.")
end

DeathSystem._cleanup_extension = function (self, arg_7_1, arg_7_2)
	-- function 7
	local var_7_0 = self.unit_extensions[arg_7_1]

	if var_7_0 == nil then
		return
	end

	var_7_0.death_has_started = false
	self.unit_extensions[arg_7_1] = nil
	self.death_reactions_to_start[arg_7_1] = nil
	self.active_reactions[var_7_0.network_type][var_7_0.death_reaction_template][arg_7_1] = nil
end

DeathSystem.freeze = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	fassert(self.frozen_unit_extensions[arg_8_1] == nil, "Extension shouldn't be frozen on death")

	local var_8_0 = self.unit_extensions[arg_8_1]

	fassert(var_8_0, "Unit to freeze didn't have unfrozen extension")
	var_8_0:freeze()
	self:_cleanup_extension(arg_8_1, arg_8_2)

	self.unit_extensions[arg_8_1] = nil
	self.frozen_unit_extensions[arg_8_1] = var_8_0
end

DeathSystem.unfreeze = function (self, arg_9_1, arg_9_2)
	-- function 9
	local var_9_0 = self.frozen_unit_extensions[arg_9_1]

	fassert(var_9_0, "Unit to unfreeze didn't have frozen extension")

	self.frozen_unit_extensions[arg_9_1] = nil
	self.unit_extensions[arg_9_1] = var_9_0
end

DeathSystem.hot_join_sync = function (arg_10_0, arg_10_1)
	-- function 10
	return
end

DeathSystem.set_death_reaction_template = function (self, arg_11_1, arg_11_2)
	-- function 11
	local var_11_0 = self.unit_extensions[arg_11_1]

	var_11_0.death_reaction_template = arg_11_2

	local network_type = var_11_0.network_type
	local var_11_2 = self.active_reactions[network_type]
	local var_11_3 = var_11_2[arg_11_2]

	var_11_3 = var_11_3 or {}
	var_11_2[arg_11_2] = var_11_3

	if not (var_11_0.is_alive or var_11_0.death_is_done) then
		self.active_reactions[network_type][arg_11_2][arg_11_1] = var_11_0
	end
end

local function fn(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	-- function 12
	local network_type = arg_12_1.network_type
	local death_reaction_template = arg_12_1.death_reaction_template
	local var_12_2 = DeathReactions.templates[death_reaction_template][network_type]
	local get_data = Unit.get_data(arg_12_0, "breed")

	if not (not get_data and get_data.name ~= "skaven_poison_wind_globadier") then
		printf("[HON-43348] Globadier (%s) starting death reaction. temlate_name: '%s', network_type: '%s', killing_blow:\n%s", Unit.get_data(arg_12_0, "globadier_43348"), death_reaction_template, network_type, table.tostring(arg_12_2))
	end

	local start, var_12_5 = var_12_2.start(arg_12_0, arg_12_5, arg_12_4, arg_12_2, arg_12_6, arg_12_1)

	if var_12_5 == DeathReactions.IS_DONE then
		Unit.flow_event(arg_12_0, "lua_dead")
	else
		arg_12_3[network_type][death_reaction_template][arg_12_0] = arg_12_1
	end

	arg_12_1.death_reaction = var_12_2
	arg_12_1.death_reaction_data = start
	arg_12_1.death_is_done = var_12_5 == DeathReactions.IS_DONE

	local var_12_6 = BLACKBOARDS[arg_12_0]

	if not arg_12_6 and not var_12_6 then
		local breed = var_12_6.breed

		if not breed.run_on_death then
			breed.run_on_death(arg_12_0, var_12_6)
		end
	end
end

DeathSystem.update = function (self, arg_13_1, arg_13_2)
	-- function 13
	local dt = arg_13_1.dt
	local DeathReactions = DeathReactions
	local IS_DONE = DeathReactions.IS_DONE
	local active_reactions = self.active_reactions
	local death_reactions_to_start = self.death_reactions_to_start

	for k, v in pairs(death_reactions_to_start) do
		self._current_death_reaction_killing_blow = v

		local var_13_5 = self.unit_extensions[k]

		fn(k, var_13_5, v, active_reactions, arg_13_2, arg_13_1, self.is_server)

		death_reactions_to_start[k] = nil
	end

	for k_2, v_2 in pairs(active_reactions) do
		for k_3, v_3 in pairs(v_2) do
			local var_13_6 = DeathReactions.templates[k_3][k_2]

			for k_4, v_4 in pairs(v_3) do
				if var_13_6.update(k_4, dt, arg_13_1, arg_13_2, v_4.death_reaction_data) == IS_DONE then
					Unit.flow_event(k_4, "lua_dead")

					v_4.death_is_done = true
					active_reactions[k_2][k_3][k_4] = nil
				end
			end
		end
	end
end

local function fn_2(self)
	-- function 14
	return self[DamageDataIndex.DAMAGE_TYPE] == "sync_health"
end

DeathSystem.kill_unit = function (self, arg_15_1, arg_15_2)
	-- function 15
	self._current_death_reaction_killing_blow = arg_15_2

	local var_15_0 = self.unit_extensions[arg_15_1]
	local get_data = Unit.get_data(arg_15_1, "breed")

	if not (not get_data and get_data.name ~= "skaven_poison_wind_globadier") then
		printf("[HON-43348] Globadier (%s) killing unit. extension: '%s', killing_blow:\n%s", Unit.get_data(arg_15_1, "globadier_43348"), var_15_0, table.tostring(arg_15_2))
	end

	if not var_15_0 then
		return
	end

	if not self.is_server then
		Managers.state.entity:system("ping_system"):remove_ping_from_unit(arg_15_1)
	end

	var_15_0.health_extension:set_dead()

	local has_extension = ScriptUnit.has_extension(arg_15_1, "buff_system")

	if not has_extension then
		has_extension:trigger_procs("on_death", arg_15_1)
	end

	if not fn_2(arg_15_2) then
		var_15_0.death_has_started = true
	end

	if not (not get_data and not get_data.is_player and get_data.keep_weapon_on_death ~= false) then
		local has_extension_2 = ScriptUnit.has_extension(arg_15_1, "inventory_system")

		if not has_extension_2 then
			has_extension_2:drop_equipped_weapons("death")
		end
	end

	local time = Managers.time:time("game")
	local extension_init_context = self.extension_init_context
	local network_type = var_15_0.network_type
	local death_reaction_template = var_15_0.death_reaction_template

	DeathReactions.templates[death_reaction_template][network_type].pre_start(arg_15_1, extension_init_context, time, arg_15_2)

	if not (not get_data and get_data.name ~= "skaven_poison_wind_globadier") then
		printf("[HON-43348] Globadier (%s) pre-starting death reaction. template: '%s', network_type: '%s'", Unit.get_data(arg_15_1, "globadier_43348"), death_reaction_template, network_type)
	end

	self.death_reactions_to_start[arg_15_1] = arg_15_2
end

DeathSystem._create_dummy_killing_blow = function (arg_16_0, arg_16_1, arg_16_2)
	-- function 16
	local alloc_table = FrameTable.alloc_table()
	local world_position = Unit.world_position(arg_16_1, 0)
	local flag = not world_position and Vector3Aux.box(nil, world_position)
	local str = "full"
	local up = Vector3.up()
	local box = Vector3Aux.box(nil, up)

	alloc_table[DamageDataIndex.DAMAGE_AMOUNT] = NetworkConstants.damage.max
	alloc_table[DamageDataIndex.DAMAGE_TYPE] = arg_16_2
	alloc_table[DamageDataIndex.ATTACKER] = arg_16_1
	alloc_table[DamageDataIndex.HIT_ZONE] = str
	alloc_table[DamageDataIndex.POSITION] = flag
	alloc_table[DamageDataIndex.DIRECTION] = box
	alloc_table[DamageDataIndex.DAMAGE_SOURCE_NAME] = "n/a"
	alloc_table[DamageDataIndex.HIT_RAGDOLL_ACTOR_NAME] = "n/a"
	alloc_table[DamageDataIndex.SOURCE_ATTACKER_UNIT] = arg_16_1
	alloc_table[DamageDataIndex.HIT_REACT_TYPE] = "n/a"
	alloc_table[DamageDataIndex.CRITICAL_HIT] = false
	alloc_table[DamageDataIndex.FIRST_HIT] = true
	alloc_table[DamageDataIndex.TOTAL_HITS] = 1
	alloc_table[DamageDataIndex.ATTACK_TYPE] = "n/a"
	alloc_table[DamageDataIndex.BACKSTAB_MULTIPLIER] = 1
	alloc_table[DamageDataIndex.TARGET_INDEX] = 1

	return alloc_table
end

DeathSystem.forced_kill = function (self, arg_17_1, arg_17_2)
	-- function 17
	fassert(Managers.player:is_player_unit(arg_17_1), "Tried to perform forced_kill on non-player unit, ONLY USE THIS FOR PLAYERS!")
	fassert(self.is_server, "Do not call forced_kill on clients. Death should always occur on the server first, so call it on the server and it will sync out to clients.")

	local _create_dummy_killing_blow = self:_create_dummy_killing_blow(arg_17_1, arg_17_2)

	self:kill_unit(arg_17_1, _create_dummy_killing_blow)

	local go_id = self.unit_storage:go_id(arg_17_1)
	local var_17_2 = NetworkLookup.damage_types[arg_17_2]

	self.network_transmit:send_rpc_clients("rpc_forced_kill", go_id, var_17_2)
end

DeathSystem.rpc_forced_kill = function (self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	local unit = self.unit_storage:unit(arg_18_2)
	local var_18_1 = NetworkLookup.damage_types[arg_18_3]

	if not Unit.alive(unit) then
		if not self.is_server then
			self:forced_kill(unit, var_18_1)
		else
			local _create_dummy_killing_blow = self:_create_dummy_killing_blow(unit, var_18_1)

			self:kill_unit(unit, _create_dummy_killing_blow)
		end
	end
end

DeathSystem.get_dead = function (self, arg_19_1)
	-- function 19
	local num = 0
	local active_reactions = self.active_reactions

	for k, v in pairs(active_reactions) do
		for k_2, v_2 in pairs(v) do
			for k_3, v_3 in pairs(v_2) do
				num = num + 1
				arg_19_1[k_3] = true
			end
		end
	end

	return num
end

DeathSystem.flow_get_killing_blow_attacker_unit = function (self)
	-- function 20
	local _current_death_reaction_killing_blow = self._current_death_reaction_killing_blow

	return not _current_death_reaction_killing_blow and _current_death_reaction_killing_blow[DamageDataIndex.ATTACKER]
end
