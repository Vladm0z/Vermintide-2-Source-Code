-- chunkname: @scripts/entity_system/systems/doors/door_system.lua

require("scripts/unit_extensions/level/door_extension")
require("scripts/unit_extensions/level/simple_door_extension")
require("scripts/unit_extensions/level/boss_door_extension")
require("scripts/unit_extensions/level/big_boy_destructible_extension")
require("scripts/unit_extensions/level/crawl_space_extension")

DoorSystem = class(DoorSystem, ExtensionSystemBase)

local tbl = {
	"rpc_sync_door_state",
	"rpc_sync_boss_door_state"
}
local tbl_2 = {
	"DoorExtension",
	"SimpleDoorExtension",
	"BossDoorExtension",
	"BigBoyDestructibleExtension",
	"CrawlSpaceExtension"
}

DoorSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	DoorSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))

	self.unit_extension_data = {}
	self._broadphase = Broadphase(127, 1.5)
	self._boss_doors = {}
	self._active_groups = {}
	self._crawl_space_tunnels = {}
	self._crawl_space_spawners = {}
end

DoorSystem.on_add_extension = function (self, arg_2_1, arg_2_2, arg_2_3, ...)
	-- function 2
	local on_add_extension = DoorSystem.super.on_add_extension(self, arg_2_1, arg_2_2, arg_2_3)

	self.unit_extension_data[arg_2_2] = on_add_extension

	local world_position = Unit.world_position(arg_2_2, 0)

	if arg_2_3 ~= "CrawlSpaceExtension" then
		on_add_extension.__broadphase_id = Broadphase.add(self._broadphase, arg_2_2, world_position, 0.5)
	end

	if arg_2_3 == "BossDoorExtension" then
		local _boss_doors = self._boss_doors

		for i = 0, 2 do
			repeat
				local get_data = Unit.get_data(arg_2_2, "map_sections", i)

				if not (not get_data and get_data ~= 0) then
					break
				end

				if not _boss_doors[get_data] then
					_boss_doors[get_data] = {}
				end

				local var_2_4 = _boss_doors[get_data]

				var_2_4[#var_2_4 + 1] = arg_2_2
			until true
		end
	end

	if arg_2_3 == "CrawlSpaceExtension" then
		local get_data_2 = Unit.get_data(arg_2_2, "crawl_space_id")

		if get_data_2 == 0 then
			self._crawl_space_spawners[#self._crawl_space_spawners + 1] = on_add_extension
		elseif not self._crawl_space_tunnels[get_data_2] then
			on_add_extension.partner_unit = self._crawl_space_tunnels[get_data_2].unit
			self._crawl_space_tunnels[get_data_2].partner_unit = arg_2_2
		else
			self._crawl_space_tunnels[get_data_2] = on_add_extension
		end
	end

	return on_add_extension
end

DoorSystem.extensions_ready = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	if arg_3_3 == "CrawlSpaceExtension" then
		self._crawl_spaces_ready = true
	end
end

local tbl_3 = {}

DoorSystem.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	DoorSystem.super.update(self, arg_4_1, arg_4_2)

	if not self.is_server then
		table.clear(tbl_3)

		local _active_groups = self._active_groups
		local system = Managers.state.entity:system("ai_group_system")

		for k, v in pairs(_active_groups) do
			local flag = false

			for k_2 = 1, #v do
				local var_4_3 = v[k_2]
				local group_id = var_4_3.group_id
				local active = var_4_3.active
				local get_ai_group = system:get_ai_group(group_id)

				if not (not get_ai_group and active) then
					var_4_3.active = true
				elseif not (not active and get_ai_group) then
					flag = true
				elseif not active and not get_ai_group then
					local members = get_ai_group.members
					local flag_2 = true

					for k_3, v_2 in pairs(members) do
						if not HEALTH_ALIVE[k_3] then
							local var_4_9 = BLACKBOARDS[k_3]
							local breed = var_4_9.breed

							if not (not breed and breed.boss) then
								local last_damage_t = ScriptUnit.has_extension(k_3, "health_system"):last_damage_t()

								last_damage_t = last_damage_t or arg_4_2

								local flag_3 = arg_4_2 > last_damage_t + 60
								local navigation_extension = var_4_9.navigation_extension
								local flag_4 = not navigation_extension and navigation_extension:is_following_path()

								if not (not flag_3 and flag_4) then
									flag_2 = true
								else
									flag_2 = false

									break
								end
							else
								flag_2 = false

								break
							end
						end
					end

					if not flag_2 then
						flag = true
					end
				end
			end

			if not flag then
				tbl_3[#tbl_3 + 1] = k
			end
		end

		for i5 = 1, #tbl_3 do
			local var_4_15 = tbl_3[i5]

			self:open_boss_doors(var_4_15)

			self._active_groups[var_4_15] = nil
		end
	end
end

DoorSystem.get_doors = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	return Broadphase.query(self._broadphase, arg_5_1, arg_5_2, arg_5_3)
end

DoorSystem.get_boss_door_units = function (self)
	-- function 6
	local _boss_doors = self._boss_doors
	local tbl = {}

	for k, v in pairs(_boss_doors) do
		for k_2 = 1, #v do
			local var_6_2 = v[k_2]

			tbl[#tbl + 1] = var_6_2
		end
	end

	return tbl
end

DoorSystem.on_remove_extension = function (self, arg_7_1, arg_7_2)
	-- function 7
	DoorSystem.super.on_remove_extension(self, arg_7_1, arg_7_2)

	local var_7_0 = self.unit_extension_data[arg_7_1]

	if arg_7_2 ~= "CrawlSpaceExtension" then
		Broadphase.remove(self._broadphase, var_7_0.__broadphase_id)
	end

	self.unit_extension_data[arg_7_1] = nil
end

DoorSystem.destroy = function (self)
	-- function 8
	self.network_event_delegate:unregister(self)

	self.network_event_delegate = nil
	self.unit_extension_data = nil
	self._broadphase = nil
end

DoorSystem.close_boss_doors = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local var_9_0 = self._boss_doors[arg_9_1]
	local network_transmit = Managers.state.network.network_transmit

	if not var_9_0 then
		for i = 1, #var_9_0 do
			local var_9_2 = var_9_0[i]

			ScriptUnit.extension(var_9_2, "door_system"):set_door_state("closed", arg_9_3)

			local current_level = LevelHelper:current_level(self.world)
			local unit_index = Level.unit_index(current_level, var_9_2)
			local closed = NetworkLookup.door_states.closed
			local var_9_6

			if not arg_9_3 then
				var_9_6 = NetworkLookup.breeds[arg_9_3]

				if not var_9_6 then
					-- Nothing
				end
			end

			var_9_6 = NetworkLookup.breeds["n/a"]

			::label_9_0::

			network_transmit:send_rpc_clients("rpc_sync_boss_door_state", unit_index, closed, var_9_6)
		end

		if not self._active_groups[arg_9_1] then
			self._active_groups[arg_9_1] = {}
		end

		local var_9_7 = self._active_groups[arg_9_1]

		var_9_7[#var_9_7 + 1] = {
			active = false,
			group_id = arg_9_2
		}
	end
end

DoorSystem.open_boss_doors = function (self, arg_10_1)
	-- function 10
	local var_10_0 = self._boss_doors[arg_10_1]
	local network_transmit = Managers.state.network.network_transmit

	for i = 1, #var_10_0 do
		local var_10_2 = var_10_0[i]

		ScriptUnit.extension(var_10_2, "door_system"):set_door_state("open")

		local current_level = LevelHelper:current_level(self.world)
		local unit_index = Level.unit_index(current_level, var_10_2)
		local open = NetworkLookup.door_states.open
		local var_10_6 = NetworkLookup.breeds["n/a"]

		network_transmit:send_rpc_clients("rpc_sync_boss_door_state", unit_index, open, var_10_6)
	end
end

DoorSystem.get_boss_door_units = function (self)
	-- function 11
	local tbl = {}

	for k, v in pairs(self._boss_doors) do
		for k_2 = 1, #v do
			local var_11_1 = v[k_2]

			tbl[#tbl + 1] = var_11_1
		end
	end

	return tbl
end

DoorSystem.get_crawl_space_tunnel_units = function (self, arg_12_1)
	-- function 12
	if not self._crawl_spaces_ready then
		return
	end

	local tbl = {}

	for k, v in pairs(self._crawl_space_tunnels) do
		local unit = v.unit
		local partner_unit = v.partner_unit
		local extension = ScriptUnit.extension(unit, "interactable_system")
		local has_extension = ScriptUnit.has_extension(partner_unit, "interactable_system")

		if extension:is_enabled() or not arg_12_1 then
			tbl[#tbl + 1] = unit
		end

		if not partner_unit and has_extension:is_enabled() and not arg_12_1 then
			tbl[#tbl + 1] = partner_unit
		end
	end

	return tbl
end

DoorSystem.get_crawl_space_spawner_units = function (self)
	-- function 13
	if not self._crawl_spaces_ready then
		return
	end

	local tbl = {}

	for k, v in pairs(self._crawl_space_spawners) do
		tbl[#tbl + 1] = v.unit
	end

	return tbl
end

DoorSystem.rpc_sync_door_state = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	local current_level = LevelHelper:current_level(self.world)
	local unit_by_index = Level.unit_by_index(current_level, arg_14_2)
	local has_extension = ScriptUnit.has_extension(unit_by_index, "door_system")

	if not has_extension then
		local var_14_3 = NetworkLookup.door_states[arg_14_3]

		has_extension:set_door_state(var_14_3)
	else
		Application.warning(string.format("[DoorSystem:rpc_sync_door_state] The synced level_object_id (%s) doesn't correspond to a unit with a 'door_system' extension. Unit: %s", arg_14_2, tostring(unit_by_index)))
	end
end

DoorSystem.rpc_sync_boss_door_state = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	-- function 15
	local current_level = LevelHelper:current_level(self.world)
	local unit_by_index = Level.unit_by_index(current_level, arg_15_2)
	local has_extension = ScriptUnit.has_extension(unit_by_index, "door_system")

	if not has_extension then
		local var_15_3 = NetworkLookup.door_states[arg_15_3]
		local var_15_4 = NetworkLookup.breeds[arg_15_4]

		has_extension:set_door_state(var_15_3, var_15_4)
	else
		Application.warning(string.format("[DoorSystem:rpc_sync_boss_door_state] The synced level_object_id (%s) doesn't correspond to a unit with a 'door_system' extension. Unit: %s", arg_15_2, tostring(unit_by_index)))
	end
end
