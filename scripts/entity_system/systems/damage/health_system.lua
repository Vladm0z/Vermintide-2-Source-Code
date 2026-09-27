-- chunkname: @scripts/entity_system/systems/damage/health_system.lua

require("scripts/unit_extensions/generic/generic_health_extension")
require("scripts/unit_extensions/generic/overpowered_blob_health_extension")
require("scripts/unit_extensions/generic/explosive_barrel_health_extension")
require("scripts/unit_extensions/generic/invincible_health_extension")
require("scripts/unit_extensions/generic/rat_ogre_health_extension")
require("scripts/unit_extensions/generic/chaos_troll_health_extension")
require("scripts/unit_extensions/generic/chaos_troll_husk_health_extension")
require("scripts/unit_extensions/generic/training_dummy_health_extension")
require("scripts/unit_extensions/default_player_unit/player_unit_health_extension")
require("scripts/unit_extensions/health/loot_rat_health_extension")
require("scripts/unit_extensions/health/lure_health_extension")
require("scripts/unit_extensions/health/target_health_extension")

HealthSystem = class(HealthSystem, ExtensionSystemBase)

local script_data = script_data
local tbl = {
	"rpc_add_damage",
	"rpc_add_damage_network",
	"rpc_damage_taken_overcharge",
	"rpc_heal",
	"rpc_remove_assist_shield",
	"rpc_request_heal",
	"rpc_suicide",
	"rpc_sync_damage_taken",
	"rpc_take_falling_damage",
	"rpc_request_knock_down",
	"rpc_request_heal_wounds",
	"rpc_request_revive",
	"rpc_request_insta_kill",
	"rpc_request_convert_temp"
}
local tbl_2 = {
	"ChaosTrollHealthExtension",
	"ChaosTrollHuskHealthExtension",
	"ExplosiveBarrelHealthExtension",
	"GenericHealthExtension",
	"InvincibleHealthExtension",
	"LootRatHealthExtension",
	"PlayerUnitHealthExtension",
	"RatOgreHealthExtension",
	"LureHealthExtension",
	"OverpoweredBlobHealthExtension",
	"TrainingDummyHealthExtension",
	"TargetHealthExtension"
}

DLCUtils.require_list("health_extension_files")
DLCUtils.append("health_extensions", tbl_2)

HealthSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	HealthSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))

	self.unit_extensions = {}
	self.frozen_unit_extensions = {}
	self.player_unit_extensions = {}
	self.updateable_unit_extensions = {}
	self.active_damage_buffer_index = 1
	self.extension_init_context.system_data = self
	self._recent_attackers_free_list = {
		[0] = 0
	}
end

HealthSystem.destroy = function (self)
	-- function 2
	self.network_event_delegate:unregister(self)
	fassert(next(HEALTH_ALIVE) == nil, "global HEALTH_ALIVE table has units that were not cleaned up. Should be empty")
	table.clear(HEALTH_ALIVE)
end

HealthSystem.on_add_extension = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local add_extension = ScriptUnit.add_extension(self.extension_init_context, arg_3_2, arg_3_3, self.NAME, arg_3_4)

	HEALTH_ALIVE[arg_3_2] = true
	self.unit_extensions[arg_3_2] = add_extension

	if arg_3_3 == "PlayerUnitHealthExtension" then
		self.player_unit_extensions[arg_3_2] = add_extension
	end

	if not add_extension.update then
		self.updateable_unit_extensions[arg_3_2] = add_extension
	end

	return add_extension
end

HealthSystem.on_remove_extension = function (self, arg_4_1, arg_4_2)
	-- function 4
	fassert(ScriptUnit.has_extension(arg_4_1, self.NAME), "Trying to remove non-existing extension %q from unit %s", arg_4_2, arg_4_1)
	ScriptUnit.remove_extension(arg_4_1, self.NAME)

	self.unit_extensions[arg_4_1] = nil
	self.frozen_unit_extensions[arg_4_1] = nil
	self.player_unit_extensions[arg_4_1] = nil
	self.updateable_unit_extensions[arg_4_1] = nil
	HEALTH_ALIVE[arg_4_1] = nil
end

HealthSystem.freeze = function (self, arg_5_1, arg_5_2)
	-- function 5
	fassert(self.frozen_unit_extensions[arg_5_1] == nil, "Tried to freeze an already frozen unit.")

	local var_5_0 = self.unit_extensions[arg_5_1]

	fassert(var_5_0, "Unit to freeze didn't have unfrozen extension")

	if not var_5_0.freeze then
		var_5_0:freeze()
	end

	self.unit_extensions[arg_5_1] = nil
	self.frozen_unit_extensions[arg_5_1] = var_5_0

	fassert(var_5_0.unit, "Should this extension have a unit member?")
end

HealthSystem.unfreeze = function (self, arg_6_1)
	-- function 6
	local var_6_0 = self.frozen_unit_extensions[arg_6_1]

	fassert(var_6_0, "Unit to unfreeze didn't have frozen extension")

	self.frozen_unit_extensions[arg_6_1] = nil
	self.unit_extensions[arg_6_1] = var_6_0

	if not var_6_0.unfreeze then
		var_6_0:unfreeze()
	end
end

HealthSystem.hot_join_sync = function (self, arg_7_1)
	-- function 7
	for k, v in pairs(self.unit_extensions) do
		if not v.hot_join_sync then
			v:hot_join_sync(arg_7_1)
		end
	end
end

HealthSystem.update = function (self, arg_8_1, arg_8_2)
	-- function 8
	self.active_damage_buffer_index = 3 - self.active_damage_buffer_index

	local active_damage_buffer_index = self.active_damage_buffer_index
	local set_empty = pdArray.set_empty
	local player_unit_extensions = self.player_unit_extensions

	for k, v in pairs(self.unit_extensions) do
		local var_8_3 = v.damage_buffers[active_damage_buffer_index]

		set_empty(var_8_3)

		v._recent_damage_type = nil
		v._recent_hit_react_type = nil
	end

	local dt = arg_8_1.dt

	for k_2, v_2 in pairs(self.updateable_unit_extensions) do
		v_2:update(dt, arg_8_1, arg_8_2)
	end
end

HealthSystem._assist_shield = function (self, arg_9_1, arg_9_2)
	-- function 9
	local var_9_0 = self.unit_extensions[arg_9_1]
	local extension = ScriptUnit.extension(arg_9_1, "status_system")

	var_9_0:shield(arg_9_2)
	extension:set_shielded(true)
end

HealthSystem.suicide = function (arg_10_0, arg_10_1)
	-- function 10
	if not Unit.alive(arg_10_1) then
		if not arg_10_1 then
			print("Got suicide from deleted player unit")
		else
			print("Trying suicide but already dead")
		end

		return
	end

	ScriptUnit.extension(arg_10_1, "health_system"):die("forced")
end

HealthSystem.rent_recent_attacker = function (self, arg_11_1, arg_11_2)
	-- function 11
	local _recent_attackers_free_list = self._recent_attackers_free_list
	local var_11_1
	local var_11_2 = _recent_attackers_free_list[0]

	if var_11_2 > 0 then
		var_11_1 = _recent_attackers_free_list[var_11_2]
		_recent_attackers_free_list[0] = var_11_2 - 1
	else
		var_11_1 = {}
	end

	self:refresh_recent_attacker(var_11_1, arg_11_1, arg_11_2)

	return var_11_1
end

HealthSystem.refresh_recent_attacker = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	arg_12_1.attacker_breed = arg_12_2
	arg_12_1.t = arg_12_3
end

HealthSystem.return_recent_attacker = function (self, arg_13_1)
	-- function 13
	local _recent_attackers_free_list = self._recent_attackers_free_list
	local num = _recent_attackers_free_list[0] + 1

	_recent_attackers_free_list[num] = arg_13_1
	_recent_attackers_free_list[0] = num
end

local tbl_3 = {}

HealthSystem.update_debug = function (self)
	-- function 14
	if not script_data.damage_debug then
		for k, v in pairs(self.unit_extensions) do
			if not Managers.player:owner(k) then
				local get_damage_taken = v:get_damage_taken()
				local get_max_health = v:get_max_health()
				local has_extension = ScriptUnit.has_extension(k, "dialogue_system")

				if not has_extension then
					Debug.text("Player: %s @ %.2f/%.2f", has_extension.context.player_profile, get_damage_taken, get_max_health)
				else
					Debug.text("Player: @ %.2f/%.2f", get_damage_taken, get_max_health)
				end
			else
				local current_health = v:current_health()
				local get_damage_taken_2 = v:get_damage_taken()
				local flag

				flag = current_health ~= math.huge or not "inf" or string.format("%.2f", current_health)

				local get_data = Unit.get_data(k, "breed")

				if get_data ~= nil then
					Debug.text("Breed %s @ %.2f/%s", get_data.name, get_damage_taken_2, flag)
				else
					Debug.text("%s @ %.2f/%s", Unit.debug_name(k), get_damage_taken_2, flag)
				end
			end
		end
	end

	local show_ai_health = script_data.show_ai_health
	local show_ai_spawn_info = script_data.show_ai_spawn_info

	if show_ai_health or not show_ai_spawn_info then
		local local_player = Managers.player:local_player()

		if local_player == nil then
			return
		end

		local player_unit = local_player.player_unit
		local free_flight = Managers.free_flight
		local active = free_flight:active("global")

		active = not active and free_flight:camera_position_rotation()

		local broadphase = Managers.state.entity:system("ai_system").broadphase
		local flag_2 = active or POSITION_LOOKUP[player_unit]

		if not broadphase and not flag_2 then
			local query = Broadphase.query(broadphase, flag_2, 20, tbl_3)
			local var_14_16 = Vector3(0, 0, 0.5)
			local var_14_17 = Vector3(0, 0, 0.65)
			local var_14_18 = Vector3(0, 0, 0.75)
			local var_14_19 = Vector3(255, 200, 0)
			local var_14_20 = Vector3(255, 0, 200)
			local var_14_21 = Vector3(255, 70, 0)
			local var_14_22 = Vector3(55, 70, 255)
			local var_14_23 = Vector3(0, 175, 75)
			local var_14_24 = Vector3(175, 175, 0)
			local var_14_25 = Vector3(175, 0, 0)
			local var_14_26 = Vector3(100, 0, 0)
			local str = "player_1"
			local debug_text = Managers.state.debug_text

			for k_2 = 1, query do
				local var_14_29 = tbl_3[k_2]
				local has_node = Unit.has_node(var_14_29, "c_head")

				has_node = not has_node and Unit.node(var_14_29, "c_head")

				if not has_node then
					local var_14_31 = self.unit_extensions[var_14_29]

					if not show_ai_health then
						debug_text:clear_unit_text(var_14_29, "health")

						local num = var_14_31.health - var_14_31.damage
						local num_2 = num / var_14_31.health
						local flag_3 = (not (num_2 > 0.99) or not var_14_23 or not (num_2 > 0.25)) and (not var_14_24 or var_14_25)
						local var_14_35 = BLACKBOARDS[var_14_29]
						local lean_dogpile

						if not var_14_35 then
							lean_dogpile = var_14_35.lean_dogpile

							if not lean_dogpile then
								lean_dogpile = 0
							end
						else
							lean_dogpile = "-"
						end

						if num_2 <= 0 then
							local format = string.format("dead, dogpile %s", lean_dogpile)

							debug_text:output_unit_text(format, 0.16, var_14_29, has_node, var_14_16, nil, "health", var_14_26, str)
						else
							local format_2 = string.format("%.2f / %.2f dogpile %s", num, var_14_31.health, lean_dogpile)

							debug_text:output_unit_text(format_2, 0.3, var_14_29, has_node, var_14_16, nil, "health", flag_3, str)
						end

						local has_extension_2 = ScriptUnit.has_extension(var_14_29, "ai_group_system")
						local template

						if not has_extension_2 then
							template = has_extension_2.template

							if not template then
								-- Nothing
							end
						end

						template = ""

						::label_14_0::

						if not template then
							debug_text:output_unit_text(template, 0.15, var_14_29, has_node, var_14_17, nil, "health", var_14_21, str)
						end
					end

					if not show_ai_spawn_info then
						debug_text:clear_unit_text(var_14_29, "spawn_info")

						local zone_data = var_14_31.zone_data

						if not zone_data then
							local hi_data = zone_data.hi_data
							local var_14_43
							local var_14_44

							if not var_14_31.replaced_breed then
								var_14_44 = var_14_22

								local format_3 = string.format
								local str_2 = "%s R>%s"
								local debug_info = var_14_31.debug_info

								debug_info = debug_info or "Roaming"
								var_14_43 = format_3(str_2, debug_info, var_14_31.replaced_breed)
							else
								var_14_44 = var_14_21

								local format_4 = string.format
								local str_3 = "%s SEG=%d"
								local debug_info_2 = var_14_31.debug_info

								debug_info_2 = debug_info_2 or "Roaming"
								var_14_43 = format_4(str_3, debug_info_2, hi_data.id)
							end

							debug_text:output_unit_text(var_14_43, 0.15, var_14_29, has_node, var_14_18, nil, "spawn_info", var_14_44, str)

							local name = BLACKBOARDS[var_14_29].breed.name

							if not hi_data then
								-- Nothing
							end

							::label_14_1::

							local breed_count = hi_data.breed_count

							breed_count = not breed_count and hi_data.breed_count[name]

							do
								local count
							end

							::label_14_2::

							if not breed_count then
								count = breed_count.count

								if not count then
									-- Nothing
								end
							end

							count = " "

							::label_14_3::

							local format_5 = string.format
							local str_4 = "%s %s %q(%s)"
							local flag_4

							flag_4 = not zone_data.island and "island_id:" and "zone_id:"

							local unique_zone_id = zone_data.unique_zone_id
							local pack_type = zone_data.pack_type

							pack_type = pack_type or "?"

							local var_14_59 = format_5(str_4, flag_4, unique_zone_id, pack_type, count)

							if not zone_data.hi then
								var_14_44 = var_14_20
							else
								var_14_44 = var_14_19
							end

							debug_text:output_unit_text(var_14_59, 0.15, var_14_29, has_node, var_14_17, nil, "spawn_info", var_14_44, str)
						else
							local has_extension_3 = ScriptUnit.has_extension(var_14_29, "ai_group_system")
							local template_2

							if not has_extension_3 then
								template_2 = has_extension_3.template

								if not template_2 then
									-- Nothing
								end
							end

							template_2 = ""

							::label_14_4::

							if not template_2 then
								debug_text:output_unit_text(template_2, 0.15, var_14_29, has_node, var_14_17, nil, "spawn_info", var_14_21, str)
							end
						end
					end
				end
			end
		end
	end
end

HealthSystem.rpc_add_damage = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8, arg_15_9, arg_15_10, arg_15_11, arg_15_12, arg_15_13, arg_15_14, arg_15_15, arg_15_16, arg_15_17, arg_15_18, arg_15_19, arg_15_20, arg_15_21, arg_15_22)
	-- function 15
	fassert(not self.is_server, "Tried sending rpc_add_damage to something other than client")

	local var_15_0
	local unit_storage = self.unit_storage

	if not arg_15_3 then
		var_15_0 = LevelHelper:unit_by_index(self.world, arg_15_2)
	else
		var_15_0 = unit_storage:unit(arg_15_2)
	end

	if not Unit.alive(var_15_0) then
		return
	end

	local var_15_2

	if not arg_15_5 then
		var_15_2 = LevelHelper:unit_by_index(self.world, arg_15_4)
	else
		var_15_2 = unit_storage:unit(arg_15_4)
	end

	local unit = unit_storage:unit(arg_15_6)
	local var_15_4 = NetworkLookup.hit_zones[arg_15_8]
	local var_15_5 = NetworkLookup.damage_types[arg_15_9]
	local var_15_6 = NetworkLookup.damage_sources[arg_15_12]
	local var_15_7 = NetworkLookup.hit_ragdoll_actors[arg_15_13]
	local var_15_8 = NetworkLookup.hit_react_types[arg_15_14]
	local var_15_9 = NetworkLookup.buff_attack_types[arg_15_20]
	local alive = Unit.alive(var_15_2)
	local var_15_11 = self.unit_extensions[var_15_0]
	local has_extension = ScriptUnit.has_extension(unit, "buff_system")

	if not (not has_extension and var_15_6 ~= "dot_debuff") then
		has_extension:trigger_procs("on_dot_damage_dealt", var_15_0, unit, var_15_5, var_15_6)
	end

	if var_15_5 ~= "sync_health" then
		var_15_11:add_damage(not alive and var_15_2 and var_15_0, arg_15_7, var_15_4, var_15_5, arg_15_10, arg_15_11, var_15_6, var_15_7, unit, var_15_8, arg_15_16, arg_15_17, arg_15_18, arg_15_19, var_15_9, arg_15_21, arg_15_22)
	end

	if not var_15_11:is_alive() and not arg_15_15 then
		local alloc_table = FrameTable.alloc_table()
		local flag = not arg_15_10 and Vector3Aux.box(nil, arg_15_10)
		local box = Vector3Aux.box(nil, arg_15_11)

		alloc_table[DamageDataIndex.DAMAGE_AMOUNT] = arg_15_7
		alloc_table[DamageDataIndex.DAMAGE_TYPE] = var_15_5
		alloc_table[DamageDataIndex.ATTACKER] = not alive and var_15_2 and var_15_0
		alloc_table[DamageDataIndex.HIT_ZONE] = var_15_4
		alloc_table[DamageDataIndex.POSITION] = flag
		alloc_table[DamageDataIndex.DIRECTION] = box
		alloc_table[DamageDataIndex.DAMAGE_SOURCE_NAME] = var_15_6
		alloc_table[DamageDataIndex.HIT_RAGDOLL_ACTOR_NAME] = var_15_7
		alloc_table[DamageDataIndex.SOURCE_ATTACKER_UNIT] = unit or alloc_table[DamageDataIndex.ATTACKER]
		alloc_table[DamageDataIndex.HIT_REACT_TYPE] = var_15_8
		alloc_table[DamageDataIndex.CRITICAL_HIT] = arg_15_16
		alloc_table[DamageDataIndex.FIRST_HIT] = arg_15_18
		alloc_table[DamageDataIndex.TOTAL_HITS] = arg_15_19
		alloc_table[DamageDataIndex.ATTACK_TYPE] = var_15_9
		alloc_table[DamageDataIndex.BACKSTAB_MULTIPLIER] = arg_15_21
		alloc_table[DamageDataIndex.TARGET_INDEX] = arg_15_22 or 1

		Managers.state.entity:system("death_system"):kill_unit(var_15_0, alloc_table)
	end
end

HealthSystem.rpc_add_damage_network = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8, arg_16_9, arg_16_10, arg_16_11, arg_16_12, arg_16_13, arg_16_14, arg_16_15, arg_16_16, arg_16_17, arg_16_18, arg_16_19)
	-- function 16
	fassert(self.is_server, "Tried sending rpc_add_damage_network to something other than the server")

	local var_16_0
	local unit_storage = self.unit_storage

	if not arg_16_3 then
		var_16_0 = LevelHelper:unit_by_index(self.world, arg_16_2)
	else
		var_16_0 = unit_storage:unit(arg_16_2)
	end

	if not Unit.alive(var_16_0) then
		return
	end

	local var_16_2

	if not arg_16_5 then
		var_16_2 = LevelHelper:unit_by_index(self.world, arg_16_4)
	else
		var_16_2 = unit_storage:unit(arg_16_4)
	end

	local var_16_3

	if arg_16_6 ~= NetworkConstants.invalid_game_object_id then
		local unit = unit_storage:unit(arg_16_6)
	end

	local var_16_5 = NetworkLookup.hit_zones[arg_16_8]
	local var_16_6 = NetworkLookup.damage_types[arg_16_9]
	local var_16_7 = NetworkLookup.damage_sources[arg_16_12]
	local var_16_8 = NetworkLookup.hit_react_types[arg_16_13]
	local var_16_9
	local var_16_10
	local var_16_11

	arg_16_16 = arg_16_16 or false
	arg_16_17 = arg_16_17 or 0

	DamageUtils.add_damage_network(var_16_0, var_16_2, arg_16_7, var_16_5, var_16_6, arg_16_10, arg_16_11, var_16_7, var_16_9, var_16_10, var_16_11, var_16_8, arg_16_14, arg_16_15, arg_16_16, arg_16_17, arg_16_18, nil, arg_16_19)
end

HealthSystem.rpc_damage_taken_overcharge = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	local unit = self.unit_storage:unit(arg_17_2)

	if not unit then
		DamageUtils.apply_damage_to_overcharge(unit, arg_17_3)
	end
end

HealthSystem.rpc_heal = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7)
	-- function 18
	local var_18_0
	local unit_storage = self.unit_storage

	if not arg_18_3 then
		var_18_0 = LevelHelper:unit_by_index(self.world, arg_18_2)
	else
		var_18_0 = unit_storage:unit(arg_18_2)
	end

	if not Unit.alive(var_18_0) then
		return
	end

	local var_18_2

	if not arg_18_5 then
		var_18_2 = LevelHelper:unit_by_index(self.world, arg_18_4)
	else
		var_18_2 = unit_storage:unit(arg_18_4)
	end

	local var_18_3 = NetworkLookup.heal_types[arg_18_7]

	if var_18_3 == "shield_by_assist" then
		self:_assist_shield(var_18_0, arg_18_6)
	else
		self.unit_extensions[var_18_0]:add_heal(var_18_2, arg_18_6, nil, var_18_3)

		local has_extension = ScriptUnit.has_extension(var_18_0, "status_system")

		if not has_extension then
			has_extension:healed(var_18_3)
		end

		local has_extension_2 = ScriptUnit.has_extension(var_18_0, "buff_system")

		if not has_extension_2 then
			has_extension_2:trigger_procs("on_healed", var_18_2, arg_18_6, var_18_3)
		end

		local has_extension_3 = ScriptUnit.has_extension(var_18_2, "buff_system")

		if var_18_0 == var_18_2 or not has_extension_3 then
			has_extension_3:trigger_procs("on_healed_ally", var_18_0, arg_18_6, var_18_3)
		end
	end
end

HealthSystem.rpc_remove_assist_shield = function (self, arg_19_1, arg_19_2)
	-- function 19
	local unit = self.unit_storage:unit(arg_19_2)

	self.unit_extensions[unit]:remove_assist_shield("blocked_damage")
end

HealthSystem.rpc_request_heal = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	-- function 20
	local fassert = fassert
	local is_server = self.is_server

	is_server = is_server or LEVEL_EDITOR_TEST

	fassert(is_server, "Trying to request a heal from a client")

	local unit = self.unit_storage:unit(arg_20_2)

	if not Unit.alive(unit) then
		return
	end

	local has_extension = ScriptUnit.has_extension(unit, "status_system")

	if not has_extension and not has_extension:is_disabled() then
		local var_20_4 = NetworkLookup.heal_types[arg_20_4]

		if not (var_20_4 == "healing_draught" or var_20_4 ~= "healing_draught_temp_health") then
			local var_20_5 = CHANNEL_TO_PEER_ID[arg_20_1]
			local slot_healthkit = NetworkLookup.equipment_slots.slot_healthkit
			local potion_healing_draught_01 = NetworkLookup.item_names.potion_healing_draught_01
			local var_20_8 = NetworkLookup.weapon_skins["n/a"]

			Managers.state.network.network_transmit:send_rpc("rpc_add_inventory_slot_item", var_20_5, arg_20_2, slot_healthkit, potion_healing_draught_01, var_20_8)

			return
		end
	end

	local var_20_9 = NetworkLookup.heal_types[arg_20_4]

	if var_20_9 == "shield_by_assist" then
		DamageUtils.assist_shield_network(unit, unit, arg_20_3)
	else
		DamageUtils.heal_network(unit, unit, arg_20_3, var_20_9)
	end
end

HealthSystem.rpc_request_convert_temp = function (self, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	local fassert = fassert
	local is_server = self.is_server

	is_server = is_server or LEVEL_EDITOR_TEST

	fassert(is_server, "Trying to request a health convert from a client")

	local unit = self.unit_storage:unit(arg_21_2)

	if not ALIVE[unit] then
		return
	end

	self.unit_extensions[unit]:convert_to_temp(arg_21_3)
end

HealthSystem.rpc_suicide = function (self, arg_22_1, arg_22_2)
	-- function 22
	local unit = self.unit_storage:unit(arg_22_2)

	self:suicide(unit)
end

HealthSystem.rpc_sync_damage_taken = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6)
	-- function 23
	fassert(not self.is_server, "rpc_sync_damage_taken was sent to server, only clients should receive this!")

	local var_23_0
	local unit_storage = self.unit_storage

	if not arg_23_3 then
		var_23_0 = LevelHelper:unit_by_index(self.world, arg_23_2)
	else
		var_23_0 = unit_storage:unit(arg_23_2)
	end

	if not Unit.alive(var_23_0) then
		return
	end

	local var_23_2 = self.unit_extensions[var_23_0]
	local var_23_3 = NetworkLookup.health_statuses[arg_23_6]

	if not var_23_2.sync_damage_taken then
		var_23_2:sync_damage_taken(arg_23_5, arg_23_4, var_23_3)
	elseif not arg_23_4 then
		var_23_2:set_max_health(arg_23_5)

		var_23_2.state = var_23_3
	else
		var_23_2.damage = arg_23_5
		var_23_2.state = var_23_3
	end
end

HealthSystem.rpc_take_falling_damage = function (self, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	local unit = self.unit_storage:unit(arg_24_2)

	if not (not unit and Unit.alive(unit)) then
		return
	end

	local var_24_1 = self.player_unit_extensions[unit]

	if not var_24_1 then
		return
	end

	arg_24_3 = arg_24_3 * 0.25

	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(unit)
	local FALL_DAMAGE_MULTIPLIER = get_movement_settings_table.fall.heights.FALL_DAMAGE_MULTIPLIER
	local MIN_FALL_DAMAGE_HEIGHT = get_movement_settings_table.fall.heights.MIN_FALL_DAMAGE_HEIGHT
	local MIN_FALL_DAMAGE_PERCENTAGE = get_movement_settings_table.fall.heights.MIN_FALL_DAMAGE_PERCENTAGE
	local MAX_FALL_DAMAGE_PERCENTAGE = get_movement_settings_table.fall.heights.MAX_FALL_DAMAGE_PERCENTAGE
	local get_max_health = var_24_1:get_max_health()
	local num = get_max_health * MIN_FALL_DAMAGE_PERCENTAGE
	local num_2 = get_max_health * MAX_FALL_DAMAGE_PERCENTAGE

	if MIN_FALL_DAMAGE_HEIGHT < arg_24_3 then
		local num_3 = arg_24_3 - MIN_FALL_DAMAGE_HEIGHT
		local clamp = math.clamp(num_3 * FALL_DAMAGE_MULTIPLIER, num, num_2)
		local up = Vector3.up()
		local str = "full"
		local str_2 = "kinetic"

		DamageUtils.add_damage_network(unit, unit, clamp, str, str_2, nil, up, "ground_impact", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
	end
end

HealthSystem.rpc_request_knock_down = function (self, arg_25_1, arg_25_2)
	-- function 25
	local fassert = fassert
	local is_server = self.is_server

	is_server = is_server or LEVEL_EDITOR_TEST

	fassert(is_server, "Trying to request a knock down from a client")

	local unit = self.unit_storage:unit(arg_25_2)

	ScriptUnit.extension(unit, "health_system"):knock_down(unit)
end

HealthSystem.rpc_request_heal_wounds = function (self, arg_26_1, arg_26_2)
	-- function 26
	local fassert = fassert
	local is_server = self.is_server

	is_server = is_server or LEVEL_EDITOR_TEST

	fassert(is_server, "Trying to request a wound heal from a client")

	local unit = self.unit_storage:unit(arg_26_2)

	StatusUtils.set_wounded_network(unit, false, "healed")
end

HealthSystem.rpc_request_revive = function (self, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
	local fassert = fassert
	local is_server = self.is_server

	is_server = is_server or LEVEL_EDITOR_TEST

	fassert(is_server, "Trying to request a revive from a client")

	local unit = self.unit_storage:unit(arg_27_2)
	local unit_2 = self.unit_storage:unit(arg_27_3)

	StatusUtils.set_revived_network(unit, true, unit_2)

	local player = Managers.player
	local unit_owner = player:unit_owner(unit_2)
	local unit_owner_2 = player:unit_owner(unit)

	if not (not unit_owner and unit_owner_2) then
		return
	end

	local var_27_7 = POSITION_LOOKUP[unit]

	Managers.telemetry_events:player_revived(unit_owner, unit_owner_2, var_27_7)
end

HealthSystem.rpc_request_insta_kill = function (self, arg_28_1, arg_28_2, arg_28_3)
	-- function 28
	local fassert = fassert
	local is_server = self.is_server

	is_server = is_server or LEVEL_EDITOR_TEST

	fassert(is_server, "Trying to request a insta kill from a client")

	local unit = self.unit_storage:unit(arg_28_2)

	if not (not unit and Unit.alive(unit)) then
		return
	end

	local var_28_3 = self.unit_extensions[unit]

	if not var_28_3 then
		return
	end

	local var_28_4 = NetworkLookup.damage_types[arg_28_3]

	var_28_3:die(var_28_4)
end
