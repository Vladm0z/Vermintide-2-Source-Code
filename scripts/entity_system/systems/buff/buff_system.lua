-- chunkname: @scripts/entity_system/systems/buff/buff_system.lua

require("scripts/entity_system/systems/buff/buff_sync_type")
require("scripts/unit_extensions/default_player_unit/buffs/buff_templates")
require("scripts/unit_extensions/default_player_unit/buffs/group_buff_templates")
require("scripts/unit_extensions/default_player_unit/buffs/buff_function_templates")
require("scripts/unit_extensions/default_player_unit/buffs/buff_extension")

BuffSystem = class(BuffSystem, ExtensionSystemBase)
IGNORED_ITEM_TYPES_FOR_BUFFS = {}

local tbl = {
	"rpc_add_buff",
	"rpc_add_volume_buff_multiplier",
	"rpc_remove_volume_buff",
	"rpc_add_group_buff",
	"rpc_remove_group_buff",
	"rpc_buff_on_attack",
	"rpc_remove_server_controlled_buff",
	"rpc_proc_event",
	"rpc_remove_gromril_armour",
	"rpc_add_buff_synced",
	"rpc_add_buff_synced_params",
	"rpc_add_buff_synced_relay",
	"rpc_add_buff_synced_relay_params",
	"rpc_add_buff_synced_response",
	"rpc_remove_buff_synced"
}
local tbl_2 = {
	"BuffExtension"
}

BuffSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	BuffSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))

	self.network_manager = arg_1_1.network_manager
	self.unit_extension_data = {}
	self.frozen_unit_extension_data = {}
	self.player_group_buffs = {}
	self.volume_buffs = {}
	self.server_controlled_buffs = {}

	if not self.is_server then
		self.next_server_buff_id = 1
		self.free_server_buff_ids = {}
	end

	self.active_buff_units = {}
	self._activated_buff_units_during_update = {}
end

BuffSystem.on_add_extension = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	local on_add_extension = BuffSystem.super.on_add_extension(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	arg_2_0.unit_extension_data[arg_2_2] = on_add_extension

	return on_add_extension
end

BuffSystem.hot_join_sync = function (self, arg_3_1)
	-- function 3
	if not self.is_server then
		local count = #self.player_group_buffs
		local network_manager = self.network_manager
		local network_transmit = network_manager.network_transmit

		for i = 1, count do
			local group_buff_template_name = self.player_group_buffs[i].group_buff_template_name
			local var_3_4 = NetworkLookup.group_buff_templates[group_buff_template_name]

			network_transmit:send_rpc("rpc_add_group_buff", arg_3_1, var_3_4, 1)
		end

		for k, v in pairs(self.server_controlled_buffs) do
			for k_2, v_2 in pairs(v) do
				local unit_game_object_id = network_manager:unit_game_object_id(k)

				if not unit_game_object_id then
					local template_name = v_2.template_name
					local attacker_unit = v_2.attacker_unit
					local var_3_8 = NetworkLookup.buff_templates[template_name]
					local unit_game_object_id_2 = network_manager:unit_game_object_id(attacker_unit)

					unit_game_object_id_2 = unit_game_object_id_2 or NetworkConstants.invalid_game_object_id

					network_transmit:send_rpc("rpc_add_buff", arg_3_1, unit_game_object_id, var_3_8, unit_game_object_id_2, k_2, false)
				end
			end
		end

		self:_hot_join_sync_synced_buffs(arg_3_1)
	end
end

BuffSystem._clean_up_server_controller_buffs = function (self, arg_4_1)
	-- function 4
	local var_4_0 = self.server_controlled_buffs[arg_4_1]

	if not var_4_0 then
		for k, v in pairs(var_4_0) do
			var_4_0[k] = nil

			if not self.is_server then
				self.free_server_buff_ids[#self.free_server_buff_ids + 1] = k
			end
		end

		self.server_controlled_buffs[arg_4_1] = nil

		Managers.state.event:trigger("on_clean_up_server_controlled_buffs", arg_4_1)
	end
end

BuffSystem.on_remove_extension = function (self, arg_5_1, arg_5_2)
	-- function 5
	local var_5_0 = self.unit_extension_data[arg_5_1]

	if not var_5_0 then
		var_5_0:clear()
	end

	self.frozen_unit_extension_data[arg_5_1] = nil
	self.unit_extension_data[arg_5_1] = nil
	self.active_buff_units[arg_5_1] = nil

	self:_clean_up_server_controller_buffs(arg_5_1)
	BuffSystem.super.on_remove_extension(self, arg_5_1, arg_5_2)
end

BuffSystem.on_freeze_extension = function (self, arg_6_1, arg_6_2)
	-- function 6
	self:freeze(arg_6_1, arg_6_2)
end

BuffSystem.freeze = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local frozen_unit_extension_data = self.frozen_unit_extension_data

	if not frozen_unit_extension_data[arg_7_1] then
		return
	end

	local var_7_1 = self.unit_extension_data[arg_7_1]

	fassert(var_7_1, "Unit to freeze didn't have unfrozen extension")

	self.unit_extension_data[arg_7_1] = nil
	frozen_unit_extension_data[arg_7_1] = var_7_1

	var_7_1:freeze()
	self:_clean_up_server_controller_buffs(arg_7_1)
	fassert(self.active_buff_units[arg_7_1] == nil, "Unit had active buffs after freeze!")
end

BuffSystem.unfreeze = function (self, arg_8_1)
	-- function 8
	local var_8_0 = self.frozen_unit_extension_data[arg_8_1]

	fassert(var_8_0, "Unit to unfreeze didn't have frozen extension")

	self.frozen_unit_extension_data[arg_8_1] = nil
	self.unit_extension_data[arg_8_1] = var_8_0

	var_8_0:unfreeze()
end

local tbl_3 = {}

BuffSystem.update = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not script_data.buff_no_opt then
		local dt = arg_9_1.dt
		local active_buff_units = self.active_buff_units

		self.in_update = true

		for k, v in pairs(active_buff_units) do
			local var_9_2 = active_buff_units[k]

			assert(#var_9_2._buffs > 0, "Unit was active but didn't have buffs")
			var_9_2:update(k, tbl_3, dt, arg_9_1, arg_9_2)
		end

		for k_2, v_2 in pairs(self._activated_buff_units_during_update) do
			active_buff_units[k_2] = v_2
		end

		table.clear(self._activated_buff_units_during_update)

		self.in_update = false
	else
		BuffSystem.super.update(self, arg_9_1, arg_9_2)
	end
end

BuffSystem.get_player_group_buffs = function (self)
	-- function 10
	return self.player_group_buffs
end

BuffSystem.destroy = function (self)
	-- function 11
	self.network_event_delegate:unregister(self)

	self.network_event_delegate = nil
	self.unit_extension_data = nil
	self.active_buff_units = nil
end

BuffSystem._next_free_server_buff_id = function (self)
	-- function 12
	local free_server_buff_ids = self.free_server_buff_ids
	local count = #free_server_buff_ids
	local var_12_2

	if count > 0 then
		var_12_2 = free_server_buff_ids[count]
		free_server_buff_ids[count] = nil
	else
		var_12_2 = self.next_server_buff_id
		self.next_server_buff_id = self.next_server_buff_id + 1
	end

	if var_12_2 > NetworkConstants.server_controlled_buff_id.max then
		print("===== [BuffSystem] server controlled buffs dump =====")

		local num = 0

		for k, v in pairs(self.server_controlled_buffs) do
			for k_2, v_2 in pairs(v) do
				print(k, k_2, HEALTH_ALIVE[k], v_2.template_name, v_2.attacker_unit)

				num = num + 1
			end
		end

		printf("Found %s buffs", num)
		ferror("[BuffSystem] ERROR! Too many server controlled buffs! (%d/%d)", var_12_2, NetworkConstants.server_controlled_buff_id.max)
	end

	return var_12_2
end

local tbl_4 = {}

BuffSystem._add_buff_helper_function = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6)
	-- function 13
	local extension = ScriptUnit.extension(arg_13_1, "buff_system")

	tbl_4.attacker_unit = arg_13_3
	tbl_4.power_level = arg_13_5
	tbl_4.source_attacker_unit = arg_13_6

	if arg_13_4 > 0 then
		if not self.server_controlled_buffs[arg_13_1] then
			self.server_controlled_buffs[arg_13_1] = {}
		end

		local buffs = BuffUtils.get_buff_template(arg_13_2).buffs

		for i = 1, #buffs do
			local var_13_2 = buffs[i]

			fassert(var_13_2.duration == nil, "[BuffSystem] Error! Cannot use duration for server controlled buffs! (template = %s) Use a normal buff if it should have a duration!", arg_13_2)
		end

		if not self.server_controlled_buffs[arg_13_1][arg_13_4] then
			local add_buff = extension:add_buff(arg_13_2, tbl_4)

			self.server_controlled_buffs[arg_13_1][arg_13_4] = {
				local_buff_id = add_buff,
				template_name = arg_13_2,
				attacker_unit = arg_13_3,
				source_attacker_unit = arg_13_6
			}
		end
	else
		extension:add_buff(arg_13_2, tbl_4)
	end
end

BuffSystem.add_buff = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
	-- function 14
	if not ScriptUnit.has_extension(arg_14_1, "buff_system") then
		return
	end

	local fassert = fassert
	local is_server = self.is_server

	is_server = is_server or not arg_14_4

	fassert(is_server, "[BuffSystem]: Trying to add a server controlled buff from a client!")

	if not (not arg_14_4 and HEALTH_ALIVE[arg_14_1]) then
		return nil
	end

	local _next_free_server_buff_id

	if not arg_14_4 then
		_next_free_server_buff_id = self:_next_free_server_buff_id()

		if not _next_free_server_buff_id then
			-- Nothing
		end
	end

	_next_free_server_buff_id = 0

	::label_14_0::

	if not ScriptUnit.has_extension(arg_14_1, "buff_system") then
		self:_add_buff_helper_function(arg_14_1, arg_14_2, arg_14_3, _next_free_server_buff_id, arg_14_5, arg_14_6)
	end

	local network_manager = self.network_manager
	local game_object_or_level_id = network_manager:game_object_or_level_id(arg_14_1)
	local game_object_or_level_id_2 = network_manager:game_object_or_level_id(arg_14_3)

	if not (not game_object_or_level_id and game_object_or_level_id_2) then
		return _next_free_server_buff_id
	end

	local var_14_6 = NetworkLookup.buff_templates[arg_14_2]

	if not self.is_server then
		network_manager.network_transmit:send_rpc_clients("rpc_add_buff", game_object_or_level_id, var_14_6, game_object_or_level_id_2, _next_free_server_buff_id, false)
	else
		network_manager.network_transmit:send_rpc_server("rpc_add_buff", game_object_or_level_id, var_14_6, game_object_or_level_id_2, 0, false)
	end

	return _next_free_server_buff_id
end

BuffSystem.remove_server_controlled_buff = function (self, arg_15_1, arg_15_2)
	-- function 15
	fassert(self.is_server, "[BuffSystem]: Only the server can explicitly remove server controlled buffs!")

	local num = 0

	if not ALIVE[arg_15_1] and not arg_15_2 then
		local extension = ScriptUnit.extension(arg_15_1, "buff_system")
		local server_controlled_buffs = self.server_controlled_buffs
		local flag = not server_controlled_buffs and server_controlled_buffs[arg_15_1]

		if not flag then
			local var_15_4 = flag[arg_15_2]

			if not var_15_4 then
				flag[arg_15_2] = nil

				local flag_2 = not var_15_4 and var_15_4.local_buff_id

				num = extension:remove_buff(flag_2) or 0
				self.free_server_buff_ids[#self.free_server_buff_ids + 1] = arg_15_2
			end
		end

		local network_manager = self.network_manager
		local game_object_or_level_id = network_manager:game_object_or_level_id(arg_15_1)

		if not game_object_or_level_id then
			network_manager.network_transmit:send_rpc_clients("rpc_remove_server_controlled_buff", game_object_or_level_id, arg_15_2)
		end
	end

	return num
end

BuffSystem.has_server_controlled_buff = function (self, arg_16_1, arg_16_2)
	-- function 16
	fassert(self.is_server, "[BuffSystem]: Only the server can explicitly can check server controlled buffs!")

	local var_16_0 = self.server_controlled_buffs[arg_16_1]

	var_16_0 = not var_16_0 and self.server_controlled_buffs[arg_16_1][arg_16_2]

	return var_16_0
end

BuffSystem.add_volume_buff_multiplier = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	fassert(self.is_server, "[BuffSystem] add_volume_buff_multiplier should only be called on server!")

	local unit_owner = Managers.player:unit_owner(arg_17_1)

	if not unit_owner.remote then
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_17_1)
		local movement_volume_generic_slowdown = NetworkLookup.buff_templates.movement_volume_generic_slowdown

		network.network_transmit:send_rpc("rpc_add_volume_buff_multiplier", unit_owner.peer_id, unit_game_object_id, movement_volume_generic_slowdown, arg_17_3)
	else
		self:add_volume_buff(arg_17_1, arg_17_2, arg_17_3)
	end
end

BuffSystem.add_volume_buff = function (self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	if not Unit.alive(arg_18_1) then
		return
	end

	local extension = ScriptUnit.extension(arg_18_1, "buff_system")
	local tbl = {
		external_optional_multiplier = arg_18_3
	}

	if not self.volume_buffs[arg_18_1] then
		self.volume_buffs[arg_18_1] = {}
	end

	if not self.volume_buffs[arg_18_1][arg_18_2] then
		self.volume_buffs[arg_18_1][arg_18_2] = extension:add_buff(arg_18_2, tbl)
	end
end

BuffSystem.remove_volume_buff_multiplier = function (self, arg_19_1, arg_19_2)
	-- function 19
	fassert(self.is_server, "[BuffSystem] remove_volume_buff should only be called on server!")

	local unit_owner = Managers.player:unit_owner(arg_19_1)

	if not unit_owner.remote then
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_19_1)
		local movement_volume_generic_slowdown = NetworkLookup.buff_templates.movement_volume_generic_slowdown

		network.network_transmit:send_rpc("rpc_remove_volume_buff", unit_owner.peer_id, unit_game_object_id, movement_volume_generic_slowdown)
	else
		self:remove_volume_buff(arg_19_1, arg_19_2)
	end
end

BuffSystem.remove_volume_buff = function (self, arg_20_1, arg_20_2)
	-- function 20
	if not Unit.alive(arg_20_1) then
		return
	end

	local extension = ScriptUnit.extension(arg_20_1, "buff_system")
	local var_20_1 = self.volume_buffs[arg_20_1][arg_20_2]

	extension:remove_buff(var_20_1)

	self.volume_buffs[arg_20_1][arg_20_2] = nil
end

BuffSystem.rpc_add_buff = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6)
	-- function 21
	if not self.is_server then
		if not arg_21_6 then
			self.network_manager.network_transmit:send_rpc_clients("rpc_add_buff", arg_21_2, arg_21_3, arg_21_4, 0, false)
		else
			local var_21_0 = CHANNEL_TO_PEER_ID[arg_21_1]

			self.network_manager.network_transmit:send_rpc_clients_except("rpc_add_buff", var_21_0, arg_21_2, arg_21_3, arg_21_4, 0, false)
		end
	end

	local unit = self.unit_storage:unit(arg_21_2)
	local unit_2 = self.unit_storage:unit(arg_21_4)
	local var_21_3 = NetworkLookup.buff_templates[arg_21_3]

	if not ScriptUnit.has_extension(unit, "buff_system") then
		self:_add_buff_helper_function(unit, var_21_3, unit_2, arg_21_5)
	end
end

BuffSystem.rpc_remove_server_controlled_buff = function (self, arg_22_1, arg_22_2, arg_22_3)
	-- function 22
	local unit = self.unit_storage:unit(arg_22_2)

	if not Unit.alive(unit) then
		local var_22_1 = self.server_controlled_buffs[unit]
		local flag = not var_22_1 and var_22_1[arg_22_3]

		if not flag then
			local local_buff_id = flag.local_buff_id

			if not local_buff_id then
				ScriptUnit.extension(unit, "buff_system"):remove_buff(local_buff_id)
			end

			self.server_controlled_buffs[unit][arg_22_3] = nil
		end
	end
end

BuffSystem.rpc_add_volume_buff_multiplier = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	-- function 23
	local unit = self.unit_storage:unit(arg_23_2)
	local var_23_1 = NetworkLookup.buff_templates[arg_23_3]

	self:add_volume_buff(unit, var_23_1, arg_23_4)
end

BuffSystem.rpc_remove_volume_buff = function (self, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	local unit = self.unit_storage:unit(arg_24_2)
	local var_24_1 = NetworkLookup.buff_templates[arg_24_3]

	self:remove_volume_buff(unit, var_24_1)
end

BuffSystem.rpc_add_group_buff = function (self, arg_25_1, arg_25_2, arg_25_3)
	-- function 25
	if not self.is_server then
		self.network_manager.network_transmit:send_rpc_clients("rpc_add_group_buff", arg_25_2, arg_25_3)
	end

	local var_25_0 = NetworkLookup.group_buff_templates[arg_25_2]
	local var_25_1 = GroupBuffTemplates[var_25_0]
	local buff_per_instance = var_25_1.buff_per_instance
	local side_name = var_25_1.side_name
	local player_units = Managers.state.side:get_side_from_name(side_name):player_units()

	for i = 1, arg_25_3 do
		local tbl = {
			group_buff_template_name = var_25_0,
			recipients = {}
		}

		for i_2, v in ipairs(player_units) do
			if not Unit.alive(v) then
				local add_buff = ScriptUnit.extension(v, "buff_system"):add_buff(buff_per_instance)

				tbl.recipients[v] = add_buff
			end
		end

		self.player_group_buffs[#self.player_group_buffs + 1] = tbl
	end
end

BuffSystem.rpc_remove_group_buff = function (self, arg_26_1, arg_26_2, arg_26_3)
	-- function 26
	local var_26_0 = NetworkLookup.group_buff_templates[arg_26_2]
	local player_group_buffs = self.player_group_buffs

	for i = 1, arg_26_3 do
		local count = #player_group_buffs
		local var_26_3
		local var_26_4

		for j = 1, count do
			var_26_3 = player_group_buffs[j]

			if var_26_3.group_buff_template_name == var_26_0 then
				var_26_4 = j

				break
			end
		end

		fassert(var_26_4, "trying to remove a player group buff that isn't currently applied")
		table.remove(player_group_buffs, var_26_4)

		if not self.is_server then
			self.network_manager.network_transmit:send_rpc_clients("rpc_remove_group_buff", arg_26_2, arg_26_3)
		end

		local recipients = var_26_3.recipients

		for k, v in pairs(recipients) do
			if not Unit.alive(k) then
				ScriptUnit.extension(k, "buff_system"):remove_buff(v)
			end
		end
	end
end

BuffSystem.rpc_buff_on_attack = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6, arg_27_7, arg_27_8, arg_27_9)
	-- function 27
	local unit = self.unit_storage:unit(arg_27_2)

	if not Unit.alive(unit) then
		return
	end

	local unit_2 = self.unit_storage:unit(arg_27_3)
	local var_27_2 = NetworkLookup.buff_attack_types[arg_27_4]
	local var_27_3 = NetworkLookup.hit_zones[arg_27_6]
	local var_27_4 = NetworkLookup.buff_weapon_types[arg_27_8]
	local var_27_5 = NetworkLookup.damage_sources[arg_27_9]
	local flag = false

	DamageUtils.buff_on_attack(unit, unit_2, var_27_2, arg_27_5, var_27_3, arg_27_7, flag, var_27_4, nil, var_27_5)
end

BuffSystem.rpc_proc_event = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	-- function 28
	local player = Managers.player:player(arg_28_2, arg_28_3)
	local var_28_1 = NetworkLookup.proc_events[arg_28_4]
	local player_unit = player.player_unit
	local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")

	if not has_extension then
		has_extension:trigger_procs(var_28_1)
	end
end

BuffSystem.rpc_remove_gromril_armour = function (self, arg_29_1, arg_29_2)
	-- function 29
	local unit = self.unit_storage:unit(arg_29_2)

	if not Unit.alive(unit) then
		return
	end

	local extension = ScriptUnit.extension(unit, "buff_system")

	if not extension:has_buff_type("bardin_ironbreaker_gromril_armour") then
		local id = extension:get_non_stacking_buff("bardin_ironbreaker_gromril_armour").id

		extension:remove_buff(id)
	end

	extension:trigger_procs("on_gromril_armour_removed")
end

BuffSystem.set_buff_ext_active = function (self, arg_30_1, arg_30_2)
	-- function 30
	if not arg_30_2 then
		if not self.in_update then
			self._activated_buff_units_during_update[arg_30_1] = self.unit_extension_data[arg_30_1]
		else
			self.active_buff_units[arg_30_1] = self.unit_extension_data[arg_30_1]
		end
	else
		self.active_buff_units[arg_30_1] = nil
	end
end

local function fn(arg_31_0)
	-- function 31
	return math.floor(arg_31_0 * 100 + 32768)
end

local function fn_2(arg_32_0)
	-- function 32
	return (arg_32_0 - 32768) / 100
end

local function fn_3(arg_33_0)
	-- function 33
	return math.floor(arg_33_0 * 10)
end

local function fn_4(arg_34_0)
	-- function 34
	return arg_34_0 / 10
end

local function fn_5(arg_35_0)
	-- function 35
	return arg_35_0
end

local function fn_6(arg_36_0)
	-- function 36
	return NetworkLookup.damage_sources[arg_36_0]
end

local function fn_7(arg_37_0, arg_37_1)
	-- function 37
	local unit_game_object_id = arg_37_1.network_manager:unit_game_object_id(arg_37_0)

	unit_game_object_id = unit_game_object_id or NetworkConstants.invalid_game_object_id

	return unit_game_object_id
end

local function fn_8(arg_38_0, arg_38_1)
	-- function 38
	return arg_38_1.unit_storage:unit(arg_38_0)
end

local tbl_5 = {
	attacker_unit = {
		pack = fn_7,
		unpack = fn_8
	},
	source_attacker_unit = {
		pack = fn_7,
		unpack = fn_8
	},
	damage_source = {
		pack = fn_6,
		unpack = fn_6
	},
	power_level = {
		pack = fn_5,
		unpack = fn_5
	},
	variable_value = {
		pack = fn,
		unpack = fn_2
	},
	external_optional_bonus = {
		pack = fn,
		unpack = fn_2
	},
	external_optional_multiplier = {
		pack = fn,
		unpack = fn_2
	},
	external_optional_value = {
		pack = fn,
		unpack = fn_2
	},
	external_optional_proc_chance = {
		pack = fn,
		unpack = fn_2
	},
	external_optional_duration = {
		pack = fn,
		unpack = fn_2
	},
	external_optional_range = {
		pack = fn,
		unpack = fn_2
	},
	_hot_join_sync_buff_age = {
		pack = fn_3,
		unpack = fn_4
	},
	_flags = {
		pack = fn_5,
		unpack = fn_5
	}
}
local keys = table.keys(tbl_5)
local mirror_array_inplace = table.mirror_array_inplace(table.keys(tbl_5))
local count = #keys
local tbl_6 = {
	"refresh_duration_only"
}

table.mirror_array_inplace(tbl_6)

local count_2 = #tbl_6
local new_map = Script.new_map(count_2)

for i = 1, count_2 do
	new_map[tbl_6[i]] = bit.rshift(1, i - 1)
end

local new_array = Script.new_array(count)
local new_array_2 = Script.new_array(count)
local new_map_2 = Script.new_map(count)

BuffSystem._pack_buff_params = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
	-- function 39
	table.clear(new_array)
	table.clear(new_array_2)

	local num = 0
	local num_2 = 0

	for k, v in pairs(arg_39_1) do
		if not new_map[k] then
			num = bit.bor(num, new_map[k])
		elseif not mirror_array_inplace[k] then
			num_2 = num_2 + 1
			arg_39_2[num_2] = mirror_array_inplace[k]
			arg_39_3[num_2] = tbl_5[k].pack(v, arg_39_0, arg_39_4)
		end
	end

	if num > 0 then
		local num_3 = num_2 + 1

		arg_39_2[num_3] = mirror_array_inplace._flags
		arg_39_3[num_3] = num
	end

	return arg_39_2, arg_39_3
end

BuffSystem._unpack_buff_params = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
	-- function 40
	table.clear(arg_40_1)

	local count = #arg_40_2
	local var_40_1 = arg_40_2[count]

	if keys[var_40_1] == "_flags" then
		local var_40_2 = arg_40_3[count]

		for i = 1, count_2 do
			local var_40_3 = tbl_6[i]
			local var_40_4 = new_map[var_40_3]

			if bit.band(var_40_2, var_40_4) == var_40_4 then
				arg_40_1[var_40_3] = true
			end
		end

		count = count - 1
	end

	for j = 1, count do
		local var_40_5 = arg_40_2[j]
		local var_40_6 = keys[var_40_5]

		arg_40_1[var_40_6] = tbl_5[var_40_6].unpack(arg_40_3[j], arg_40_0, arg_40_4)
	end

	return arg_40_1
end

local num = 0

BuffSystem._prepare_sync = function (self, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
	-- function 41
	local unit_game_object_id = Managers.state.network:unit_game_object_id(arg_41_1)
	local var_41_1 = NetworkLookup.buff_templates[arg_41_2]
	local var_41_2 = BuffSyncTypeLookup[arg_41_3]
	local str = "rpc_add_buff_synced"
	local var_41_4
	local var_41_5

	if not arg_41_4 then
		str = "rpc_add_buff_synced_params"
		var_41_4, var_41_5 = self:_pack_buff_params(arg_41_4, new_array, new_array_2, arg_41_1)
	end

	return unit_game_object_id, var_41_1, var_41_2, str, var_41_4, var_41_5
end

local function fn_9(...)
	-- function 42
	if not script_data.debug_synced_buffs then
		print(...)
	end
end

local tbl_7 = {
	[BuffSyncType.Local] = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5, arg_43_6)
		-- function 43
		return true
	end,
	[BuffSyncType.Client] = function (self, arg_44_1, arg_44_2, arg_44_3, arg_44_4, arg_44_5, arg_44_6)
		-- function 44
		if arg_44_6 == Network.peer_id() then
			return true
		end

		local _prepare_sync, var_44_1, var_44_2, var_44_3, var_44_4, var_44_5 = self:_prepare_sync(arg_44_1, arg_44_2, arg_44_3, arg_44_5)

		Managers.state.network.network_transmit:send_rpc(var_44_3, arg_44_6, _prepare_sync, var_44_1, arg_44_4, var_44_2, var_44_4, var_44_5)
	end,
	[BuffSyncType.LocalAndServer] = function (self, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6)
		-- function 45
		if not self.is_server then
			return true
		end

		local _prepare_sync, var_45_1, var_45_2, var_45_3, var_45_4, var_45_5 = self:_prepare_sync(arg_45_1, arg_45_2, arg_45_3, arg_45_5)

		Managers.state.network.network_transmit:send_rpc_server(var_45_3, _prepare_sync, var_45_1, arg_45_4, var_45_2, var_45_4, var_45_5)
	end,
	[BuffSyncType.ClientAndServer] = function (self, arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5, arg_46_6)
		-- function 46
		if not (not self.is_server and arg_46_6 ~= Network.peer_id()) then
			return true
		end

		local _prepare_sync, var_46_1, var_46_2, var_46_3, var_46_4, var_46_5 = self:_prepare_sync(arg_46_1, arg_46_2, arg_46_3, arg_46_5)
		local network_transmit = Managers.state.network.network_transmit

		if not self.is_server then
			network_transmit:send_rpc(var_46_3, arg_46_6, _prepare_sync, var_46_1, arg_46_4, var_46_2, var_46_4, var_46_5)
		else
			network_transmit:send_rpc_server(var_46_3, _prepare_sync, var_46_1, arg_46_4, var_46_2, var_46_4, var_46_5)
		end
	end,
	[BuffSyncType.Server] = function (self, arg_47_1, arg_47_2, arg_47_3, arg_47_4, arg_47_5, arg_47_6)
		-- function 47
		if not self.is_server then
			return true
		end

		local _prepare_sync, var_47_1, var_47_2, var_47_3, var_47_4, var_47_5 = self:_prepare_sync(arg_47_1, arg_47_2, arg_47_3, arg_47_5)

		Managers.state.network.network_transmit:send_rpc_server(var_47_3, _prepare_sync, var_47_1, arg_47_4, var_47_2, var_47_4, var_47_5)
	end,
	[BuffSyncType.All] = function (self, arg_48_1, arg_48_2, arg_48_3, arg_48_4, arg_48_5, arg_48_6)
		-- function 48
		local _prepare_sync, var_48_1, var_48_2, var_48_3, var_48_4, var_48_5 = self:_prepare_sync(arg_48_1, arg_48_2, arg_48_3, arg_48_5)
		local network_transmit = Managers.state.network.network_transmit

		if not self.is_server then
			network_transmit:send_rpc_clients(var_48_3, _prepare_sync, var_48_1, arg_48_4, var_48_2, var_48_4, var_48_5)
		else
			network_transmit:send_rpc_server(var_48_3, _prepare_sync, var_48_1, arg_48_4, var_48_2, var_48_4, var_48_5)
		end
	end
}

BuffSystem.add_buff_synced = function (self, arg_49_1, arg_49_2, arg_49_3, arg_49_4, arg_49_5)
	-- function 49
	local num_2 = -1
	local var_49_1
	local var_49_2 = self.unit_extension_data[arg_49_1]

	if not var_49_2 then
		if not ((arg_49_3 ~= BuffSyncType.Client or arg_49_5 == Network.peer_id() or arg_49_3 ~= BuffSyncType.Server) and self.is_server) then
			num_2 = var_49_2:claim_buff_id(arg_49_2)
			var_49_1 = 1
		else
			num_2, var_49_1 = var_49_2:add_buff(arg_49_2, arg_49_4)
		end

		local var_49_3 = num

		if var_49_1 > 0 then
			var_49_3 = var_49_2:generate_sync_id()

			var_49_2:set_pending_sync_id(num_2, var_49_3, arg_49_3)

			if not self.is_server then
				var_49_2:apply_remote_sync_id(num_2, var_49_3, arg_49_3, arg_49_5 or Network.peer_id())
			end
		else
			num_2 = -1
		end

		local var_49_4 = tbl_7[arg_49_3](self, arg_49_1, arg_49_2, arg_49_3, var_49_3, arg_49_4, arg_49_5)
	end

	return num_2
end

BuffSystem.remove_buff_synced = function (self, arg_50_1, arg_50_2)
	-- function 50
	local var_50_0 = self.unit_extension_data[arg_50_1]

	if not var_50_0 and not arg_50_2 then
		var_50_0:remove_buff(arg_50_2)
	end
end

BuffSystem.rpc_add_buff_synced = function (self, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5)
	-- function 51
	local unit = self.unit_storage:unit(arg_51_2)
	local var_51_1 = self.unit_extension_data[unit]

	if not var_51_1 then
		local var_51_2 = NetworkLookup.buff_templates[arg_51_3]
		local add_buff, var_51_4 = var_51_1:add_buff(var_51_2)
		local flag = false
		local var_51_6 = BuffSyncTypeLookup[arg_51_5]
		local var_51_7

		if var_51_4 <= 0 then
			arg_51_4 = num
			var_51_7 = num
			flag = true
		elseif not (not self.is_server and arg_51_4 == num) then
			var_51_7 = var_51_1:generate_sync_id()

			var_51_1:set_pending_sync_id(add_buff, var_51_7, var_51_6)
		else
			var_51_7 = arg_51_4
		end

		local var_51_8 = CHANNEL_TO_PEER_ID[arg_51_1]

		if var_51_7 ~= num then
			var_51_1:apply_remote_sync_id(add_buff, var_51_7, var_51_6, var_51_8)
		end

		local network = Managers.state.network

		if not (not self.is_server and var_51_6 ~= BuffSyncType.All) then
			network.network_transmit:send_rpc_clients_except("rpc_add_buff_synced_relay", var_51_8, arg_51_2, arg_51_3, var_51_7, arg_51_5)
		end

		if var_51_7 == num then
			if not flag then
				fn_9("[BuffSystem] rpc_add_buff_synced, response consumed due to blind fire sync", var_51_8, arg_51_2, var_51_2)
			end

			return
		end

		if not self.is_server then
			network.network_transmit:send_rpc("rpc_add_buff_synced_response", var_51_8, arg_51_2, arg_51_4, var_51_7)
		end
	end
end

BuffSystem.rpc_add_buff_synced_relay = function (self, arg_52_1, arg_52_2, arg_52_3, arg_52_4, arg_52_5)
	-- function 52
	local unit = self.unit_storage:unit(arg_52_2)
	local var_52_1 = self.unit_extension_data[unit]

	if not var_52_1 then
		local var_52_2 = NetworkLookup.buff_templates[arg_52_3]
		local add_buff, var_52_4 = var_52_1:add_buff(var_52_2)

		if not (arg_52_4 == num or not (var_52_4 > 0)) then
			local var_52_5 = BuffSyncTypeLookup[arg_52_5]
			local generate_sync_id = var_52_1:generate_sync_id()

			var_52_1:set_pending_sync_id(add_buff, generate_sync_id, var_52_5)
			var_52_1:apply_remote_sync_id(add_buff, arg_52_4, var_52_5)
		end
	end
end

BuffSystem.rpc_add_buff_synced_params = function (self, arg_53_1, arg_53_2, arg_53_3, arg_53_4, arg_53_5, arg_53_6, arg_53_7)
	-- function 53
	local unit = self.unit_storage:unit(arg_53_2)
	local var_53_1 = self.unit_extension_data[unit]

	if not var_53_1 then
		local var_53_2 = NetworkLookup.buff_templates[arg_53_3]
		local _unpack_buff_params = self:_unpack_buff_params(new_map_2, arg_53_6, arg_53_7, unit)
		local add_buff, var_53_5 = var_53_1:add_buff(var_53_2, _unpack_buff_params)
		local flag = false
		local var_53_7 = BuffSyncTypeLookup[arg_53_5]
		local var_53_8

		if var_53_5 <= 0 then
			arg_53_4 = num
			var_53_8 = num
			flag = true
		elseif not (not self.is_server and arg_53_4 == num) then
			var_53_8 = var_53_1:generate_sync_id()

			var_53_1:set_pending_sync_id(add_buff, var_53_8, var_53_7)
		else
			var_53_8 = arg_53_4
		end

		local var_53_9 = CHANNEL_TO_PEER_ID[arg_53_1]

		if var_53_8 ~= num then
			var_53_1:apply_remote_sync_id(add_buff, var_53_8, var_53_7, var_53_9)
		end

		local network = Managers.state.network

		if not (not self.is_server and var_53_7 ~= BuffSyncType.All) then
			network.network_transmit:send_rpc_clients_except("rpc_add_buff_synced_relay_params", var_53_9, arg_53_2, arg_53_3, var_53_8, arg_53_5, arg_53_6, arg_53_7)
		end

		if var_53_8 == num then
			if not flag then
				fn_9("[BuffSystem] rpc_add_buff_synced_params, response consumed due to blind fire sync", var_53_9, arg_53_2, var_53_2)
			end

			return
		end

		if not self.is_server then
			network.network_transmit:send_rpc("rpc_add_buff_synced_response", var_53_9, arg_53_2, arg_53_4, var_53_8)
		end
	end
end

BuffSystem.rpc_add_buff_synced_relay_params = function (self, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5, arg_54_6, arg_54_7)
	-- function 54
	local unit = self.unit_storage:unit(arg_54_2)
	local var_54_1 = self.unit_extension_data[unit]

	if not var_54_1 then
		local var_54_2 = NetworkLookup.buff_templates[arg_54_3]
		local _unpack_buff_params = self:_unpack_buff_params(new_map_2, arg_54_6, arg_54_7, unit)
		local add_buff, var_54_5 = var_54_1:add_buff(var_54_2, _unpack_buff_params)

		if not (arg_54_4 == num or not (var_54_5 > 0)) then
			local var_54_6 = BuffSyncTypeLookup[arg_54_5]
			local generate_sync_id = var_54_1:generate_sync_id()

			var_54_1:set_pending_sync_id(add_buff, generate_sync_id, var_54_6)
			var_54_1:apply_remote_sync_id(add_buff, arg_54_4, var_54_6)
		end
	end
end

BuffSystem.rpc_add_buff_synced_response = function (self, arg_55_1, arg_55_2, arg_55_3, arg_55_4)
	-- function 55
	local unit = self.unit_storage:unit(arg_55_2)
	local var_55_1 = self.unit_extension_data[unit]

	if not (not var_55_1 and var_55_1:apply_sync_id(arg_55_3, arg_55_4)) then
		local network = Managers.state.network

		if not self.is_server then
			local var_55_3 = CHANNEL_TO_PEER_ID[arg_55_1]

			network.network_transmit:send_rpc("rpc_remove_buff_synced", var_55_3, arg_55_2, arg_55_4)
		else
			network.network_transmit:send_rpc_server("rpc_remove_buff_synced", arg_55_2, arg_55_4)
		end
	end
end

BuffSystem.rpc_remove_buff_synced = function (self, arg_56_1, arg_56_2, arg_56_3)
	-- function 56
	local unit = self.unit_storage:unit(arg_56_2)
	local var_56_1 = self.unit_extension_data[unit]

	if not var_56_1 then
		local sync_id_to_id = var_56_1:sync_id_to_id(arg_56_3)

		if not sync_id_to_id then
			if not (not self.is_server and var_56_1:buff_sync_type(sync_id_to_id) ~= BuffSyncType.All) then
				local var_56_3 = CHANNEL_TO_PEER_ID[arg_56_1]

				Managers.state.network.network_transmit:send_rpc_clients_except("rpc_remove_buff_synced", var_56_3, arg_56_2, arg_56_3)
			end

			var_56_1:remove_buff(sync_id_to_id, true)
		end
	end
end

BuffSystem._hot_join_sync_synced_buffs = function (self, arg_57_1)
	-- function 57
	local time = Managers.time:time("game")
	local network = Managers.state.network
	local network_transmit = network.network_transmit
	local var_57_3 = BuffSyncTypeLookup[BuffSyncType.All]
	local tbl = {}
	local active_buff_units = self.active_buff_units

	for k, v in pairs(active_buff_units) do
		local _buff_to_sync_type = v._buff_to_sync_type

		if not _buff_to_sync_type then
			local unit_game_object_id = network:unit_game_object_id(k)
			local _id_to_server_sync = v._id_to_server_sync

			for k_2, v_2 in pairs(_buff_to_sync_type) do
				if v_2 == BuffSyncType.All then
					local get_buff_by_id = v:get_buff_by_id(k_2)

					if not get_buff_by_id then
						local var_57_10 = NetworkLookup.buff_templates[get_buff_by_id.buff_template_name]
						local var_57_11 = _id_to_server_sync[k_2]

						table.clear(tbl)

						tbl.external_optional_bonus = get_buff_by_id.bonus
						tbl.external_optional_multiplier = get_buff_by_id.multiplier
						tbl.external_optional_value = get_buff_by_id.value
						tbl.external_optional_proc_chance = get_buff_by_id.proc_chance
						tbl.external_optional_range = get_buff_by_id.range
						tbl.damage_source = get_buff_by_id.damage_source
						tbl.power_level = get_buff_by_id.power_level
						tbl.attacker_unit = get_buff_by_id.attacker_unit
						tbl.source_attacker_unit = get_buff_by_id.source_attacker_unit

						local duration = get_buff_by_id.duration

						duration = not duration and math.min(time - get_buff_by_id.start_time, 6550)
						tbl._hot_join_sync_buff_age = duration

						self:_pack_buff_params(tbl, new_array, new_array_2, k)
						network_transmit:send_rpc("rpc_add_buff_synced_relay_params", arg_57_1, unit_game_object_id, var_57_10, var_57_11, var_57_3, new_array, new_array_2)
					else
						if not v.debug_buff_names then
							local var_57_13 = v.debug_buff_names[k_2]

							print("Server would have crashed buff name ", var_57_13)
							Crashify.print_exception("[BuffSystem]", "buff_id points to missing buff: %s", var_57_13)
						end

						_buff_to_sync_type[k_2] = nil
					end
				end
			end
		end
	end
end
