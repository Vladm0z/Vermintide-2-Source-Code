-- chunkname: @scripts/entity_system/systems/pickups/pickup_system.lua

require("scripts/unit_extensions/pickups/pickup_unit_extension")
require("scripts/unit_extensions/pickups/pickup_spawner_extension")

LifeTimePickupUnitExtension = class(LifeTimePickupUnitExtension, PickupUnitExtension)
LimitedOwnedPickupUnitExtension = class(LimitedOwnedPickupUnitExtension, PickupUnitExtension)
PlayerTeleportingPickupExtension = class(PlayerTeleportingPickupExtension, PickupUnitExtension)
PickupSystem = class(PickupSystem, ExtensionSystemBase)

local tbl = {
	"rpc_spawn_pickup_with_physics",
	"rpc_spawn_pickup",
	"rpc_finalize_consumption",
	"rpc_spawn_linked_pickup",
	"rpc_force_use_pickup",
	"rpc_delete_pickup",
	"rpc_delete_limited_owned_pickup_unit",
	"rpc_delete_limited_owned_pickups",
	"rpc_delete_limited_owned_pickup_type"
}
local tbl_2 = {
	"LifeTimePickupUnitExtension",
	"LimitedOwnedPickupUnitExtension",
	"PlayerTeleportingPickupExtension",
	"PickupUnitExtension",
	"PickupSpawnerExtension"
}

for k, v in pairs(DLCSettings) do
	local additional_system_extensions = v.additional_system_extensions

	additional_system_extensions = not additional_system_extensions and v.additional_system_extensions.pickup_system

	if not additional_system_extensions then
		for i, v_2 in ipairs(additional_system_extensions) do
			require(v_2.require)

			tbl_2[#tbl_2 + 1] = v_2.class
		end
	end
end

local tbl_3 = {}

DLCUtils.append("pickup_system_extension_update", tbl_3)

PickupSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	PickupSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	self._debug_spawned_pickup = {}

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))

	self._network_manager = arg_1_1.network_manager
	self._statistics_db = arg_1_1.statistics_db

	local get_level_seed = Managers.mechanism:get_level_seed("pickups")

	self:set_seed(get_level_seed)

	self.guaranteed_pickup_spawners = {}
	self.triggered_pickup_spawners = {}
	self._next_index = 1
	self._broadphase = Broadphase(255, 15)
	self._broadphase_ids = {}
	self._pickup_units_by_type = {}

	for k, v in pairs(AllPickups) do
		self._pickup_units_by_type[k] = {}
	end

	self.primary_pickup_spawners = {}
	self.secondary_pickup_spawners = {}
	self.specified_pickup_spawners = {}
	self._teleporting_pickups = {}
	self._life_time_pickups = {}
	self._limited_owned_pickups = {}
	self._pickups_marked_for_consumption = {}

	if not DEDICATED_SERVER then
		-- Nothing
	end

	Managers.state.event:register(self, "delete_limited_owned_pickups", "event_delete_limited_owned_pickups")
end

PickupSystem._random = function (self, ...)
	-- function 2
	local next_random, var_2_1 = Math.next_random(self._seed, ...)

	self._seed = next_random

	return var_2_1
end

PickupSystem._shuffle = function (self, arg_3_1)
	-- function 3
	self._seed = table.shuffle(arg_3_1, self._seed)
end

PickupSystem.set_seed = function (self, arg_4_1)
	-- function 4
	fassert(not arg_4_1 and type(arg_4_1) == "number", "Bad seed input!")

	self._seed = arg_4_1
	self._starting_seed = arg_4_1
end

PickupSystem.on_add_extension = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, ...)
	-- function 5
	if arg_5_3 ~= "PickupSpawnerExtension" then
		local var_5_0 = POSITION_LOOKUP[arg_5_2]
		local pickup_name = arg_5_4.pickup_name
		local add = Broadphase.add(self._broadphase, arg_5_2, var_5_0, 0.1)

		self._broadphase_ids[arg_5_2] = add

		if arg_5_3 == "PlayerTeleportingPickupExtension" then
			local time = Managers.time:time("game")
			local var_5_4 = AllPickups[pickup_name]

			self._teleporting_pickups[arg_5_2] = {
				line_of_sight_fails = 0,
				init_data = arg_5_4,
				next_line_of_sight_check = time + var_5_4.teleport_time
			}
		elseif arg_5_3 == "LifeTimePickupUnitExtension" then
			local time_2 = Managers.time:time("game")
			local var_5_6 = AllPickups[pickup_name]

			self._life_time_pickups[arg_5_2] = {
				init_data = arg_5_4,
				pickup_settings = var_5_6,
				life_time = time_2 + var_5_6.life_time
			}
		elseif arg_5_3 == "LimitedOwnedPickupUnitExtension" then
			local owner_peer_id = arg_5_4.owner_peer_id

			if not owner_peer_id then
				local _limited_owned_pickups = self._limited_owned_pickups

				if not _limited_owned_pickups[owner_peer_id] then
					_limited_owned_pickups[owner_peer_id] = {
						spawn_limit = arg_5_4.spawn_limit,
						units = {}
					}
				end

				_limited_owned_pickups[owner_peer_id].units[#_limited_owned_pickups[owner_peer_id].units + 1] = arg_5_2
			end

			if not self.is_server then
				Managers.level_transition_handler.transient_package_loader:add_unit(arg_5_2)
			end
		end

		if not (arg_5_3 == "LifeTimePickupUnitExtension" or arg_5_3 == "LimitedOwnedPickupUnitExtension" or arg_5_3 == "PlayerTeleportingPickupExtension" or arg_5_3 ~= "PickupUnitExtension") then
			local var_5_9 = self._pickup_units_by_type[pickup_name]

			var_5_9[#var_5_9 + 1] = arg_5_2
		end
	end

	return PickupSystem.super.on_add_extension(self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, ...)
end

PickupSystem.game_object_initialized = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	Managers.state.event:trigger("pickup_spawned", arg_6_1)
end

PickupSystem.on_remove_extension = function (self, arg_7_1, arg_7_2, ...)
	-- function 7
	if arg_7_2 ~= "PickupSpawnerExtension" then
		local _broadphase_ids = self._broadphase_ids
		local var_7_1 = _broadphase_ids[arg_7_1]

		Broadphase.remove(self._broadphase, var_7_1)

		_broadphase_ids[arg_7_1] = nil

		if arg_7_2 == "PlayerTeleportingPickupExtension" then
			self._teleporting_pickups[arg_7_1] = nil
		elseif arg_7_2 == "LifeTimePickupUnitExtension" then
			self._life_time_pickups[arg_7_1] = nil
		elseif arg_7_2 ~= "LimitedOwnedPickupUnitExtension" or not self.is_server then
			Managers.level_transition_handler.transient_package_loader:remove_unit(arg_7_1)
		end

		if not (arg_7_2 == "LifeTimePickupUnitExtension" or arg_7_2 == "PlayerTeleportingPickupExtension" or arg_7_2 ~= "PickupUnitExtension") then
			local get_data = Unit.get_data(arg_7_1, "pickup_name")
			local var_7_3 = self._pickup_units_by_type[get_data]
			local var_7_4

			for i = 1, #var_7_3 do
				if var_7_3[i] == arg_7_1 then
					var_7_4 = i

					break
				end
			end

			if not var_7_4 then
				table.remove(var_7_3, var_7_4)
			end
		end
	end

	return PickupSystem.super.on_remove_extension(self, arg_7_1, arg_7_2, ...)
end

PickupSystem.move_pickup_local_pose = function (self, arg_8_1, arg_8_2)
	-- function 8
	Unit.set_local_pose(arg_8_1, 0, arg_8_2)

	for i = 1, Unit.num_actors(arg_8_1) do
		local actor = Unit.actor(arg_8_1, i - 1)

		if not actor then
			Actor.teleport_pose(actor, arg_8_2)
		end
	end

	local var_8_1 = self._broadphase_ids[arg_8_1]
	local translation = Matrix4x4.translation(arg_8_2)

	Broadphase.move(self._broadphase, var_8_1, translation)
end

PickupSystem.get_pickups = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	return Broadphase.query(self._broadphase, arg_9_1, arg_9_2, arg_9_3)
end

PickupSystem.get_pickups_by_type = function (self, arg_10_1)
	-- function 10
	return self._pickup_units_by_type[arg_10_1]
end

PickupSystem.pickup_gizmo_spawned = function (self, arg_11_1)
	-- function 11
	if not (self.is_server or LEVEL_EDITOR_TEST) then
		return
	end

	if not (Unit.is_a(arg_11_1, "units/hub_elements/pickup_spawner") or Unit.is_a(arg_11_1, "units/hub_elements/training_dummy_spawner")) then
		Application.warning("[PickupSystem] Using Old Pickup Spawner at Position %s ", Unit.local_position(arg_11_1, 0))

		return
	end

	local get_data = Unit.get_data(arg_11_1, "guaranteed_spawn")
	local get_data_2 = Unit.get_data(arg_11_1, "triggered_spawn_id")

	if not get_data then
		self.guaranteed_pickup_spawners[#self.guaranteed_pickup_spawners + 1] = arg_11_1

		return
	elseif get_data_2 ~= "" then
		if not self.triggered_pickup_spawners[get_data_2] then
			self.triggered_pickup_spawners[get_data_2] = {}
		end

		local var_11_2 = self.triggered_pickup_spawners[get_data_2]

		var_11_2[#var_11_2 + 1] = arg_11_1

		return
	end

	if not Unit.get_data(arg_11_1, "bonus_spawner") then
		self.secondary_pickup_spawners[#self.secondary_pickup_spawners + 1] = arg_11_1
	else
		self.primary_pickup_spawners[#self.primary_pickup_spawners + 1] = arg_11_1
	end
end

PickupSystem.specific_pickup_gizmo_spawned = function (self, arg_12_1)
	-- function 12
	if not (self.is_server or LEVEL_EDITOR_TEST) then
		return
	end

	self.specified_pickup_spawners[#self.specified_pickup_spawners + 1] = arg_12_1
end

PickupSystem.activate_triggered_pickup_spawners = function (self, arg_13_1)
	-- function 13
	local var_13_0 = self.triggered_pickup_spawners[arg_13_1]

	if not var_13_0 then
		Application.warning("[PickupSystem] Attempted to trigger triggered pickups spawners with event %s but no spawners were registered to the event.", arg_13_1)

		return
	end

	local count = #var_13_0
	local str = "triggered"
	local var_13_3

	for i = 1, count do
		var_13_3 = self:_spawn_guaranteed_pickup(var_13_0[i], str)
	end

	return var_13_3
end

PickupSystem.create_checkpoint_data = function (self)
	-- function 14
	return {
		seed = self._starting_seed,
		taken = table.clone(self._taken)
	}
end

PickupSystem.remove_pickups_due_to_crossroads = function (self, arg_15_1, arg_15_2)
	-- function 15
	local tbl = {}
	local count = #arg_15_1
	local tbl_2 = {
		self.primary_pickup_spawners,
		self.secondary_pickup_spawners,
		self.guaranteed_pickup_spawners,
		self.triggered_pickup_spawners
	}

	for i = 1, #tbl_2 do
		local var_15_3 = tbl_2[i]

		for j = 1, #var_15_3 do
			local var_15_4 = var_15_3[j]
			local num = Unit.get_data(var_15_4, "percentage_through_level") * arg_15_2

			for k = 1, count do
				local var_15_6 = arg_15_1[k]

				if not (not (num > var_15_6[1]) or not (num < var_15_6[2])) then
					tbl[#tbl + 1] = j

					break
				end
			end
		end

		for l = #tbl, 1, -1 do
			table.remove(var_15_3, tbl[l])

			tbl[l] = nil
		end
	end
end

PickupSystem.setup_taken_pickups = function (self, arg_16_1)
	-- function 16
	if not arg_16_1 then
		self._taken = arg_16_1.taken
	else
		self._taken = {}
	end
end

local tbl_4 = {}
local tbl_5 = {}

PickupSystem.disable_spawners = function (self, arg_17_1)
	-- function 17
	table.clear(tbl_4)
	table.clear(tbl_5)

	local _disabled_spawner_types = self._disabled_spawner_types

	_disabled_spawner_types = _disabled_spawner_types or {}
	self._disabled_spawner_types = _disabled_spawner_types

	for i, v in ipairs(arg_17_1) do
		if not self._disabled_spawner_types[v] then
			for k, v_2 in pairs(self.primary_pickup_spawners) do
				if not Unit.get_data(v_2, v) then
					tbl_4[#tbl_4 + 1] = k
				end
			end

			for k_2, v_3 in pairs(self.secondary_pickup_spawners) do
				if not Unit.get_data(v_3, v) then
					tbl_5[#tbl_5 + 1] = k_2
				end
			end
		end

		self._disabled_spawner_types[v] = true
	end

	for i6 = #tbl_4, 1, -1 do
		local var_17_1 = tbl_4[i6]

		table.remove(self.primary_pickup_spawners, var_17_1)
	end

	for i7 = #tbl_5, 1, -1 do
		local var_17_2 = tbl_5[i7]

		table.remove(self.secondary_pickup_spawners, var_17_2)
	end
end

PickupSystem.populate_pickups = function (self, arg_18_1)
	-- function 18
	if not arg_18_1 then
		local seed = arg_18_1.seed

		self:set_seed(seed)
	end

	local current_level_settings = LevelHelper:current_level_settings()
	local pickup_settings = current_level_settings.pickup_settings

	if not pickup_settings then
		Application.warning("[PickupSystem] CURRENT LEVEL HAS NO PICKUP DATA IN ITS SETTINGS, NO PICKUPS WILL SPAWN ")

		return
	end

	local get_difficulty = Managers.state.difficulty:get_difficulty()
	local var_18_4 = pickup_settings[get_difficulty]

	if not var_18_4 then
		Application.warning("[PickupSystem] CURRENT LEVEL HAS NO PICKUP DATA FOR CURRENT DIFFICULTY: %s, USING SETTINGS FOR EASY ", get_difficulty)

		var_18_4 = pickup_settings.default or pickup_settings[1]
	end

	local ignore_sections_in_pickup_spawning = current_level_settings.ignore_sections_in_pickup_spawning

	local function fn(arg_19_0, arg_19_1)
		-- function 19
		local get_data = Unit.get_data(arg_19_0, "percentage_through_level")
		local get_data_2 = Unit.get_data(arg_19_1, "percentage_through_level")

		fassert(get_data, "Level Designer working on %s, You need to rebuild paths (pickup spawners broke)", current_level_settings.display_name)
		fassert(get_data_2, "Level Designer working on %s, You need to rebuild paths (pickup spawners broke)", current_level_settings.display_name)

		return get_data < get_data_2
	end

	self:spawn_guarenteed_pickups()

	local _mutator_handler = Managers.state.game_mode._mutator_handler
	local primary_pickup_spawners = self.primary_pickup_spawners
	local primary = var_18_4.primary

	primary = primary or var_18_4

	local pickup_settings_updated_settings = _mutator_handler:pickup_settings_updated_settings(primary)

	self:_spawn_spread_pickups(primary_pickup_spawners, pickup_settings_updated_settings, fn, 1, ignore_sections_in_pickup_spawning)

	local secondary_pickup_spawners = self.secondary_pickup_spawners
	local secondary = var_18_4.secondary
	local pickup_settings_updated_settings_2 = _mutator_handler:pickup_settings_updated_settings(secondary)

	if not pickup_settings_updated_settings_2 then
		self:_spawn_spread_pickups(secondary_pickup_spawners, pickup_settings_updated_settings_2, fn, 2, ignore_sections_in_pickup_spawning)
	end
end

PickupSystem.populate_specified_pickups = function (self, arg_20_1)
	-- function 20
	if not arg_20_1 then
		local seed = arg_20_1.seed

		self:set_seed(seed)
	end

	self:_spawn_specified_pickups()
end

local tbl_6 = {}
local tbl_7 = {}
local tbl_8 = {}

PickupSystem._spawn_spread_pickups = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	-- function 21
	table.sort(arg_21_1, arg_21_3)

	for k, v in pairs(arg_21_2) do
		table.clear(tbl_6)

		if type(v) == "table" then
			for k_2, v_2 in pairs(v) do
				for i4 = 1, v_2 do
					tbl_6[#tbl_6 + 1] = k_2
				end
			end
		else
			for i5 = 1, v do
				local _random = self:_random()
				local var_21_1 = Pickups[k]
				local num = 0
				local flag = false

				for k_3, v_3 in pairs(var_21_1) do
					num = num + v_3.spawn_weighting

					if _random <= num then
						tbl_6[#tbl_6 + 1] = k_3
						flag = true

						break
					end
				end

				fassert(flag, "Problem selecting a pickup to spawn, spawn_weighting_total = %s, spawn_value = %s", num, _random)
			end
		end

		local count = #tbl_6
		local num_2 = 1 / count
		local num_3 = 0
		local var_21_7
		local num_4 = 0

		if #arg_21_1 >= 2 then
			local get_data = Unit.get_data(arg_21_1[1], "percentage_through_level")
			local get_data_2 = Unit.get_data(arg_21_1[#arg_21_1], "percentage_through_level")
			local num_5 = 1 - get_data - (1 - get_data_2)

			num_3, num_2 = get_data, num_5 / count
		end

		if not arg_21_5 then
			count = 1
		end

		for i8 = 1, count do
			table.clear(tbl_7)
			table.clear(tbl_8)

			local num_6 = num_3 + num_2
			local count_2 = #arg_21_1

			for i9 = 1, count_2 do
				local var_21_14 = arg_21_1[i9]
				local get_data_3 = Unit.get_data(var_21_14, "percentage_through_level")

				if not ((arg_21_5 or not (num_3 <= get_data_3) or not (get_data_3 < num_6) or count ~= i8) and get_data_3 ~= 1) then
					tbl_7[#tbl_7 + 1] = var_21_14
				end
			end

			num_3 = num_6

			local count_3 = #tbl_7

			if not (not (count_3 > 0) or not (num_4 >= 0)) then
				local num_7 = count - i8 + 1
				local min = math.min(1 + math.ceil(num_4 / num_7), count_3)
				local _random_2 = self:_random()
				local flag_2 = num_7 == 1 or min ~= 1 or _random_2 < NearPickupSpawnChance[k]

				if not (not arg_21_5 and #tbl_6) then
					-- Nothing
				end

				do
					local flag_3
				end

				::label_21_0::

				flag_3 = not flag_2 and 1 and 0
				min = min + flag_3

				::label_21_1::

				self:_shuffle(tbl_7)

				local num_8 = 0
				local var_21_23

				for i10 = 1, min do
					local count_4 = #tbl_7
					local var_21_25
					local var_21_26

					if not var_21_23 then
						local get_data_4 = Unit.get_data(var_21_23, "percentage_through_level")

						local function fn(arg_22_0, arg_22_1)
							-- function 22
							local get_data = Unit.get_data(arg_22_0, "percentage_through_level")
							local get_data_2 = Unit.get_data(arg_22_1, "percentage_through_level")

							return math.abs(get_data_4 - get_data) < math.abs(get_data_4 - get_data_2)
						end

						table.sort(tbl_7, fn)
					end

					for i11 = 1, count_4 do
						local count_5 = #tbl_6
						local var_21_30 = tbl_7[i11]

						for i12 = 1, count_5 do
							local var_21_31 = tbl_6[i12]

							if not self:_can_spawn(var_21_30, var_21_31) then
								local var_21_32 = AllPickups[var_21_31]
								local get_spawn_location_data, var_21_34, var_21_35 = ScriptUnit.extension(var_21_30, "pickup_system"):get_spawn_location_data()
								local str = "spawner"
								local _spawn_pickup, var_21_38 = self:_spawn_pickup(var_21_32, var_21_31, get_spawn_location_data, var_21_34, false, str)

								num_8 = num_8 + 1
								var_21_25 = var_21_30
								var_21_26 = i12

								if not var_21_35 then
									tbl_8[#tbl_8 + 1] = var_21_30
								end

								break
							end
						end

						if not var_21_25 then
							break
						end
					end

					if not var_21_25 then
						local find = table.find(tbl_7, var_21_25)

						table.remove(tbl_7, find)
						table.remove(tbl_6, var_21_26)

						var_21_23 = var_21_25
					end
				end

				num_4 = num_4 - (num_8 - 1)
			else
				num_4 = num_4 + 1
			end

			local count_6 = #tbl_8

			for i13 = 1, count_6 do
				local var_21_41 = tbl_8[i13]
				local find_2 = table.find(arg_21_1, var_21_41)

				table.remove(arg_21_1, find_2)
			end
		end

		if num_4 > 1 then
			Application.warning("[PickupSystem] Remaining spawn debt when trying to spawn %s pickups %d", k, num_4)
		end
	end
end

PickupSystem._debug_add_spread_pickup_spawner = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	-- function 23
	local _debug_spread_pickup_spawners = self._debug_spread_pickup_spawners

	if not _debug_spread_pickup_spawners then
		_debug_spread_pickup_spawners = {}
		self._debug_spread_pickup_spawners = _debug_spread_pickup_spawners
	end

	local var_23_1 = _debug_spread_pickup_spawners[arg_23_4]

	if not var_23_1 then
		var_23_1 = {}
		_debug_spread_pickup_spawners[arg_23_4] = var_23_1
	end

	local var_23_2 = var_23_1[arg_23_1]

	if not var_23_2 then
		var_23_2 = {}
		var_23_1[arg_23_1] = var_23_2
	end

	local var_23_3 = var_23_2[arg_23_2]

	if not var_23_3 then
		var_23_3 = {}
		var_23_2[arg_23_2] = var_23_3
	end

	var_23_3[#var_23_3 + 1] = arg_23_3
end

PickupSystem._debug_add_spread_pickup = function (self, arg_24_1, arg_24_2)
	-- function 24
	local _debug_spread_pickups = self._debug_spread_pickups

	if not _debug_spread_pickups then
		_debug_spread_pickups = {}
		self._debug_spread_pickups = _debug_spread_pickups
	end

	_debug_spread_pickups[arg_24_1] = arg_24_2
end

PickupSystem.debug_draw_spread_pickups = function (self)
	-- function 25
	if not script_data.debug_pickup_spawners then
		Application.warning("The debug_pickup_spawners option must be set to true from the debug menu when using this feature")

		return
	end

	local _debug_spread_pickup_spawners = self._debug_spread_pickup_spawners
	local _debug_spread_pickups = self._debug_spread_pickups
	local _debug_spread_pickups_draw_mode = self._debug_spread_pickups_draw_mode

	if not _debug_spread_pickup_spawners then
		return
	end

	if not _debug_spread_pickups_draw_mode then
		_debug_spread_pickups_draw_mode = _debug_spread_pickups_draw_mode + 1
	else
		_debug_spread_pickups_draw_mode = 0
	end

	local tbl = {
		healing = Colors.get("yellow"),
		potions = Colors.get("orange"),
		level_events = Colors.get("red"),
		ammo = Colors.get("green"),
		grenades = Colors.get("blue"),
		improved_grenades = Colors.get("cyan"),
		special = Colors.get("magenta"),
		lorebook_pages = Colors.get("white"),
		undefined = Colors.get("black")
	}
	local tbl_2 = {
		Colors.get("orange"),
		Colors.get("pink"),
		Colors.get("yellow"),
		Colors.get("red"),
		Colors.get("light_green"),
		Colors.get("blue"),
		Colors.get("cyan"),
		Colors.get("magenta"),
		Colors.get("white")
	}
	local drawer = Managers.state.debug:drawer({
		mode = "retained",
		name = "debug_spread_pickups"
	})

	drawer:reset()

	if _debug_spread_pickups_draw_mode > 0 then
		local num = 0
		local flag = false

		for i, v in ipairs(_debug_spread_pickup_spawners) do
			if not flag then
				break
			end

			for k, v_2 in pairs(v) do
				num = num + 1

				if num == _debug_spread_pickups_draw_mode then
					local num_2 = 0

					for k_2, v_3 in pairs(v_2) do
						num_2 = num_2 + 1

						if num_2 > #tbl_2 then
							num_2 = 1
						end

						local var_25_9 = tbl_2[num_2]

						for i_2, v_4 in ipairs(v_3) do
							local get_spawn_location_data, var_25_11, var_25_12 = ScriptUnit.extension(v_4, "pickup_system"):get_spawn_location_data()

							drawer:line(get_spawn_location_data, get_spawn_location_data + Vector3(0, 0, 20), var_25_9)

							if not (not _debug_spread_pickups and _debug_spread_pickups[v_4] ~= k) then
								drawer:sphere(get_spawn_location_data + Vector3(0, 0, 20), 0.6, var_25_9)
							end
						end
					end

					flag = true

					print("Drawing pickup spawner sections for \"" .. k .. "\" of priority " .. i)

					break
				end
			end
		end

		if not flag then
			_debug_spread_pickups_draw_mode = 0
		end
	end

	if _debug_spread_pickups_draw_mode == 0 then
		print("Drawing all spawners colored by pickup type")

		for i_3, v_5 in ipairs(_debug_spread_pickup_spawners) do
			for k_3, v_6 in pairs(v_5) do
				for k_4, v_7 in pairs(v_6) do
					for i_4, v_8 in ipairs(v_7) do
						local get_spawn_location_data_2, var_25_14, var_25_15 = ScriptUnit.extension(v_8, "pickup_system"):get_spawn_location_data()
						local var_25_16 = tbl[k_3]

						var_25_16 = var_25_16 or tbl.undefined

						drawer:line(get_spawn_location_data_2, get_spawn_location_data_2 + Vector3(0, 0, 20), var_25_16)

						if not _debug_spread_pickups and not _debug_spread_pickups[v_8] then
							drawer:sphere(get_spawn_location_data_2 + Vector3(0, 0, 20), 0.6, var_25_16)
						end
					end
				end
			end
		end
	end

	self._debug_spread_pickups_draw_mode = _debug_spread_pickups_draw_mode
end

PickupSystem.disable_teleporting_pickups = function (self)
	-- function 26
	for k, v in pairs(self._teleporting_pickups) do
		self._teleporting_pickups[k] = nil
	end
end

PickupSystem.spawn_guarenteed_pickups = function (self)
	-- function 27
	local guaranteed_pickup_spawners = self.guaranteed_pickup_spawners
	local count = #guaranteed_pickup_spawners
	local str = "guaranteed"

	for i = 1, count do
		self:_spawn_guaranteed_pickup(guaranteed_pickup_spawners[i], str)
	end
end

local tbl_9 = {}

PickupSystem._spawn_guaranteed_pickup = function (self, arg_28_1, arg_28_2)
	-- function 28
	table.clear(tbl_9)

	for k, v in pairs(AllPickups) do
		if not (not self:_can_spawn(arg_28_1, k) and not (v.spawn_weighting > 0)) then
			tbl_9[#tbl_9 + 1] = k
		end
	end

	local count = #tbl_9

	if count > 0 then
		local _random = self:_random(count)
		local var_28_2 = tbl_9[_random]
		local local_position = Unit.local_position(arg_28_1, 0)
		local local_rotation = Unit.local_rotation(arg_28_1, 0)
		local var_28_5 = AllPickups[var_28_2]
		local _spawn_pickup, var_28_7 = self:_spawn_pickup(var_28_5, var_28_2, local_position, local_rotation, false, arg_28_2)

		return _spawn_pickup
	end
end

PickupSystem._spawn_specified_pickups = function (self)
	-- function 29
	local specified_pickup_spawners = self.specified_pickup_spawners
	local count = #specified_pickup_spawners
	local str = "guaranteed"

	for i = 1, count do
		local var_29_3 = specified_pickup_spawners[i]

		table.clear(tbl_9)

		for k, v in pairs(AllPickups) do
			if not self:_can_spawn(var_29_3, k) then
				tbl_9[#tbl_9 + 1] = k
			end
		end

		local count_2 = #tbl_9

		if count_2 > 0 then
			local _random = self:_random(count_2)
			local var_29_6 = tbl_9[_random]
			local local_position = Unit.local_position(var_29_3, 0)
			local local_rotation = Unit.local_rotation(var_29_3, 0)
			local var_29_9 = AllPickups[var_29_6]

			self:_spawn_pickup(var_29_9, var_29_6, local_position, local_rotation, false, str)
		end
	end
end

PickupSystem._safe_to_spawn_pickup = function (arg_30_0, arg_30_1)
	-- function 30
	local var_30_0 = AllPickups[arg_30_1]
	local unit_name = var_30_0.unit_name

	if not Application.can_get("unit", unit_name) then
		return false
	end

	local var_30_2 = rawget(ItemMasterList, var_30_0.item_name)

	if not var_30_2 then
		local temporary_template = var_30_2.temporary_template
		local get_weapon_template = WeaponUtils.get_weapon_template(temporary_template)
		local left_hand_unit = get_weapon_template.left_hand_unit

		if not (not left_hand_unit and not Application.can_get("unit", left_hand_unit) and Application.can_get("unit", left_hand_unit .. "_3p")) then
			return false
		end

		local right_hand_unit = get_weapon_template.right_hand_unit

		if not (not right_hand_unit and not Application.can_get("unit", right_hand_unit) and Application.can_get("unit", right_hand_unit .. "_3p")) then
			return false
		end
	end

	return true
end

PickupSystem.update = function (self, arg_31_1, arg_31_2)
	-- function 31
	local dt = arg_31_1.dt

	if not self.is_server then
		self:_update_life_time_pickups(dt, arg_31_2)
		self:_update_teleporting_pickups(dt, arg_31_2)
	end

	self:_update_pickups_marked_for_consumption()

	local _statistics_db = self._statistics_db
	local update_list = self.update_list

	for i = 1, #tbl_3 do
		local var_31_3 = tbl_3[i]

		self:update_extension(var_31_3, dt, nil, arg_31_2)
	end

	for k, v in pairs(self.extensions) do
		local var_31_4 = self.profiler_names[k]

		for k_2, v_2 in pairs(update_list[k].update) do
			local hide_func = v_2.hide_func

			if not ((DEDICATED_SERVER or not hide_func or not hide_func(_statistics_db)) and v_2.hidden) then
				v_2:hide()
			end
		end
	end
end

PickupSystem.get_and_delete_limited_owned_pickup_with_index = function (self, arg_32_1, arg_32_2)
	-- function 32
	local var_32_0 = self._limited_owned_pickups[arg_32_1]

	if not var_32_0 then
		return nil
	end

	local units = var_32_0.units
	local remove = table.remove(units, arg_32_2)
	local unit_spawner = Managers.state.unit_spawner
	local flag = not remove and Unit.alive(remove)

	if not flag and not flag and not unit_spawner:is_marked_for_deletion(remove) then
		return nil
	end

	if not self.is_server then
		self:_delete_pickup(remove)
	else
		local game_object_or_level_id = Managers.state.network:game_object_or_level_id(remove)

		Managers.state.network.network_transmit:send_rpc_server("rpc_delete_limited_owned_pickup_unit", arg_32_1, game_object_or_level_id)
	end

	return remove
end

PickupSystem.delete_limited_owned_pickup_unit = function (self, arg_33_1, arg_33_2)
	-- function 33
	local var_33_0 = self._limited_owned_pickups[arg_33_1]

	if not var_33_0 then
		return
	end

	local units = var_33_0.units
	local find = table.find(units, arg_33_2)

	if not find then
		table.remove(units, find)
	end

	local unit_spawner = Managers.state.unit_spawner
	local flag = not arg_33_2 and Unit.alive(arg_33_2)

	if not flag and not flag and not unit_spawner:is_marked_for_deletion(arg_33_2) then
		return
	end

	if not self.is_server then
		self:_delete_pickup(arg_33_2)
	else
		local game_object_or_level_id = Managers.state.network:game_object_or_level_id(arg_33_2)

		Managers.state.network.network_transmit:send_rpc_server("rpc_delete_limited_owned_pickup_unit", arg_33_1, game_object_or_level_id)
	end
end

PickupSystem.event_delete_limited_owned_pickups = function (self, arg_34_1)
	-- function 34
	if not self.is_server then
		local var_34_0 = self._limited_owned_pickups[arg_34_1]

		if not var_34_0 then
			return
		end

		local units = var_34_0.units

		if not units then
			for k, v in pairs(units) do
				self:_delete_pickup(v)
			end

			table.clear(units)
		end
	elseif not Managers.state.network:in_game_session() then
		self.network_transmit:send_rpc_server("rpc_delete_limited_owned_pickups", arg_34_1)
	end
end

PickupSystem.delete_limited_owned_pickup_type = function (self, arg_35_1, arg_35_2)
	-- function 35
	if not self.is_server then
		local var_35_0 = self._limited_owned_pickups[arg_35_1]

		if not var_35_0 then
			return
		end

		local units = var_35_0.units
		local var_35_2 = self._pickup_units_by_type[arg_35_2]

		if not units and not var_35_2 then
			for i = 1, #units do
				local var_35_3 = units[i]

				if table.index_of(var_35_2, var_35_3) > 0 then
					self:_delete_pickup(var_35_3)
				end
			end

			table.clear(units)
		end
	elseif not Managers.state.network:in_game_session() then
		local var_35_4 = NetworkLookup.pickup_names[arg_35_2]

		self.network_transmit:send_rpc_server("rpc_delete_limited_owned_pickup_type", arg_35_1, var_35_4)
	end
end

PickupSystem._update_life_time_pickups = function (self, arg_36_1, arg_36_2)
	-- function 36
	for k, v in pairs(self._life_time_pickups) do
		if not (arg_36_2 > v.life_time) or not v.pickup_settings.on_life_over_func then
			v.pickup_settings.on_life_over_func()

			if not Unit.alive(k) then
				Managers.state.unit_spawner:mark_for_deletion(k)
			end
		end
	end
end

local num = 4
local num_2 = -100
local num_3 = 3.5
local num_4 = 0.25

PickupSystem._update_teleporting_pickups = function (self, arg_37_1, arg_37_2)
	-- function 37
	for k, v in pairs(self._teleporting_pickups) do
		if POSITION_LOOKUP[k].z < num_2 then
			v.next_line_of_sight_check = arg_37_2 + num_3
			v.line_of_sight_fails = 0

			self:_teleport_pickup(k)
		elseif arg_37_2 > v.next_line_of_sight_check then
			v.next_line_of_sight_check = arg_37_2 + num_3

			if not self:_check_teleporting_pickup_line_of_sight(k) then
				v.line_of_sight_fails = 0
			else
				local num_4 = v.line_of_sight_fails + 1

				if num_4 > num then
					v.line_of_sight_fails = 0

					self:_teleport_pickup(k, v)
				else
					v.line_of_sight_fails = num_4
				end
			end
		end
	end
end

local num_5 = 1.75
local num_6 = 0.25
local num_7 = 40
local str = "throw"

PickupSystem._check_teleporting_pickup_line_of_sight = function (self, arg_38_1)
	-- function 38
	local position = Actor.position(Unit.actor(arg_38_1, str))
	local physics_world = World.physics_world(self.world)

	for k, v in pairs(Managers.player:players()) do
		local player_unit = v.player_unit

		if not HEALTH_ALIVE[player_unit] then
			local num = POSITION_LOOKUP[player_unit] + Vector3(0, 0, num_5)
			local num_2 = position - num
			local length = Vector3.length(num_2)

			if length > num_7 then
				-- Nothing
			elseif length > num_6 then
				local num_3 = num_2 / length

				if not PhysicsWorld.immediate_raycast(physics_world, num, num_3, length, "closest", "collision_filter", "filter_player_mover") then
					return true
				end
			else
				return true
			end
		end
	end

	return false
end

PickupSystem._teleport_pickup = function (arg_39_0, arg_39_1)
	-- function 39
	local var_39_0

	for k, v in pairs(Managers.player:human_players()) do
		local player_unit = v.player_unit

		if not HEALTH_ALIVE[player_unit] then
			var_39_0 = ScriptUnit.extension(player_unit, "locomotion_system"):last_position_on_navmesh() + Vector3(0, 0, num_4)

			break
		end
	end

	if not var_39_0 then
		Actor.teleport_position(Unit.actor(arg_39_1, str), var_39_0)
	end
end

PickupSystem.destroy = function (self)
	-- function 40
	Managers.state.event:unregister("delete_limited_owned_pickups", self)
	self.network_event_delegate:unregister(self)
end

PickupSystem.hot_join_sync = function (arg_41_0, arg_41_1)
	-- function 41
	return
end

PickupSystem.spawn_pickup = function (self, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6, arg_42_7, arg_42_8)
	-- function 42
	local var_42_0 = AllPickups[arg_42_1]
	local var_42_1
	local var_42_2
	local _spawn_pickup, var_42_4 = self:_spawn_pickup(var_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, var_42_1, var_42_2, arg_42_6, arg_42_7, arg_42_8)

	return _spawn_pickup
end

PickupSystem.spawn_pickup_async = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5, arg_43_6, arg_43_7, arg_43_8)
	-- function 43
	local pickup_package_loader = Managers.level_transition_handler.pickup_package_loader

	arg_43_2 = Vector3Box(arg_43_2)
	arg_43_3 = QuaternionBox(arg_43_3)
	arg_43_6 = not arg_43_6 and Vector3Box(arg_43_6) and nil

	pickup_package_loader:request_pickup(arg_43_1, function ()
		-- function 44
		local var_44_0 = arg_43_0
		local var_44_1 = var_44_0
		local spawn_pickup = var_44_0.spawn_pickup
		local var_44_3 = arg_43_1
		local unbox = arg_43_2:unbox()
		local unbox_2 = arg_43_3:unbox()
		local var_44_6 = arg_43_4
		local var_44_7 = arg_43_5
		local unbox_3

		if not arg_43_6 then
			unbox_3 = arg_43_6:unbox()

			if not unbox_3 then
				-- Nothing
			end
		end

		unbox_3 = nil

		::label_44_0::

		local var_44_9 = spawn_pickup(var_44_1, var_44_3, unbox, unbox_2, var_44_6, var_44_7, unbox_3, arg_43_7, arg_43_8)

		if not arg_43_8 then
			arg_43_8(var_44_9)
		end
	end)
end

PickupSystem.buff_spawn_pickup = function (self, arg_45_1, arg_45_2, arg_45_3)
	-- function 45
	if not arg_45_2 then
		return
	end

	if not arg_45_3 then
		local physics_world = World.physics_world(self.world)
		local down = Vector3.down()
		local num = 40
		local immediate_raycast, var_45_4, var_45_5, var_45_6 = PhysicsWorld.immediate_raycast(physics_world, arg_45_2, down, num, "closest", "collision_filter", "filter_pickup_collision")

		if not immediate_raycast then
			arg_45_2 = var_45_4
		end
	end

	local var_45_7 = Quaternion(Vector3.up(), math.degrees_to_radians(Math.random(1, 360)))
	local flag = false
	local str = "buff"
	local var_45_10 = AllPickups[arg_45_1]
	local _spawn_pickup, var_45_12 = self:_spawn_pickup(var_45_10, arg_45_1, arg_45_2, var_45_7, flag, str)

	if not _spawn_pickup then
		return _spawn_pickup
	end
end

PickupSystem._spawn_pickup = function (self, arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5, arg_46_6, arg_46_7, arg_46_8, arg_46_9, arg_46_10, arg_46_11)
	-- function 46
	if not self.is_server then
		Crashify.print_exception("PickupSystem", "Client tried to spawn a client owned pickup '%s'. Pickups may only be spawned by the server.", arg_46_2)

		return
	end

	local _next_index = self._next_index

	if not self._taken[_next_index] then
		return
	end

	if not Managers.state.network:in_game_session() then
		return
	end

	local can_spawn_func = arg_46_1.can_spawn_func

	if not (not can_spawn_func and can_spawn_func(nil, arg_46_6 == "debug")) then
		return
	end

	local tbl = {
		pickup_system = {
			pickup_name = arg_46_2,
			has_physics = arg_46_5,
			spawn_type = arg_46_6,
			spawn_index = _next_index,
			owner_peer_id = arg_46_7,
			spawn_limit = arg_46_8
		},
		projectile_locomotion_system = {
			network_position = AiAnimUtils.position_network_scale(arg_46_3, true),
			network_rotation = AiAnimUtils.rotation_network_scale(arg_46_4, true),
			network_velocity = AiAnimUtils.velocity_network_scale(arg_46_9 or Vector3.zero(), true),
			network_angular_velocity = AiAnimUtils.velocity_network_scale(Vector3.zero(), true)
		}
	}

	if not arg_46_11 then
		table.merge_recursive(tbl, arg_46_11)
	end

	self._next_index = _next_index + 1

	if not arg_46_10 then
		-- Nothing
	end

	::label_46_0::

	local unit_template_name = arg_46_1.unit_template_name

	unit_template_name = unit_template_name or "pickup_unit"

	::label_46_1::

	local additional_data_func = arg_46_1.additional_data_func

	if not additional_data_func then
		local var_46_5
		local var_46_6 = self[additional_data_func](self, arg_46_1, arg_46_3, arg_46_4)

		table.merge(tbl, var_46_6)
	end

	local additional_data = arg_46_1.additional_data

	if not additional_data then
		table.merge(tbl, additional_data)
	end

	local var_46_8
	local var_46_9
	local unit_name = arg_46_1.unit_name
	local spawn_override_func = arg_46_1.spawn_override_func

	if not spawn_override_func then
		var_46_8, var_46_9 = spawn_override_func(arg_46_1, tbl, arg_46_3, arg_46_4)
	else
		var_46_8, var_46_9 = Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template_name, tbl, arg_46_3, arg_46_4)
	end

	self:_update_limited_limited_owned_pickups(arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5, arg_46_6, arg_46_7)

	return var_46_8, var_46_9
end

PickupSystem._update_limited_limited_owned_pickups = function (self, arg_47_1, arg_47_2, arg_47_3, arg_47_4, arg_47_5, arg_47_6, arg_47_7)
	-- function 47
	local var_47_0 = self._limited_owned_pickups[arg_47_7]

	if not var_47_0 then
		return
	end

	local spawn_limit = var_47_0.spawn_limit
	local units = var_47_0.units

	if spawn_limit < #units then
		local num = 1
		local remove = table.remove(units, num)

		self:_delete_pickup(remove)
	end
end

PickupSystem._can_spawn = function (arg_48_0, arg_48_1, arg_48_2)
	-- function 48
	local get_data = Unit.get_data(arg_48_1, arg_48_2)

	get_data = get_data or Managers.mechanism:can_spawn_pickup(arg_48_1, arg_48_2)

	return get_data
end

PickupSystem.mark_for_consumption = function (arg_49_0, arg_49_1, arg_49_2)
	-- function 49
	if not Unit.get_data(arg_49_1, "interaction_data", "only_once") then
		return
	end

	if not Unit.get_data(arg_49_1, "interaction_data", "individual_pickup") then
		return
	end

	arg_49_0._pickups_marked_for_consumption[arg_49_1] = arg_49_2
end

PickupSystem.marked_for_consumption = function (self, arg_50_1)
	-- function 50
	return self._pickups_marked_for_consumption[arg_50_1]
end

PickupSystem.finalize_consumption = function (self, arg_51_1, arg_51_2, arg_51_3)
	-- function 51
	if not Unit.get_data(arg_51_1, "interaction_data", "only_once") then
		return
	end

	if not Unit.get_data(arg_51_1, "interaction_data", "individual_pickup") then
		return
	end

	if not self.is_server then
		if not arg_51_2 then
			local var_51_0 = BLACKBOARDS[arg_51_1]

			if not var_51_0 then
				Managers.state.conflict:destroy_unit(arg_51_1, var_51_0, "picked_up_interactable")
			else
				Managers.state.unit_spawner:mark_for_deletion(arg_51_1)
			end
		else
			self._pickups_marked_for_consumption[arg_51_1] = nil
		end

		if not (not arg_51_3 and arg_51_3 == "n/a") then
			local local_position = Unit.local_position(arg_51_1, 0)
			local local_rotation = Unit.local_rotation(arg_51_1, 0)
			local var_51_3 = AllPickups[arg_51_3]

			self:_spawn_pickup(var_51_3, arg_51_3, local_position, local_rotation, false, "dropped", Network.peer_id())
		end
	else
		if not arg_51_2 then
			Unit.set_unit_visibility(arg_51_1, false, nil, true)
		end

		local go_id = Managers.state.unit_storage:go_id(arg_51_1)

		if not go_id then
			local var_51_5 = NetworkLookup.pickup_names[arg_51_3 or "n/a"]

			Managers.state.network.network_transmit:send_rpc_server("rpc_finalize_consumption", go_id, arg_51_2, var_51_5)
		end
	end
end

PickupSystem._update_pickups_marked_for_consumption = function (self)
	-- function 52
	for k, v in pairs(self._pickups_marked_for_consumption) do
		if not (not ALIVE[k] and ALIVE[v]) then
			self._pickups_marked_for_consumption[k] = nil
		end
	end
end

PickupSystem.rpc_spawn_pickup_with_physics = function (self, arg_53_1, arg_53_2, arg_53_3, arg_53_4, arg_53_5)
	-- function 53
	local var_53_0 = NetworkLookup.pickup_names[arg_53_2]

	fassert(AllPickups[var_53_0], "pickup name %s does not exist in Pickups table", var_53_0)

	local var_53_1 = AllPickups[var_53_0]
	local var_53_2 = NetworkLookup.pickup_spawn_types[arg_53_5]

	self:_spawn_pickup(var_53_1, var_53_0, arg_53_3, arg_53_4, true, var_53_2)
end

PickupSystem.rpc_spawn_pickup = function (self, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5)
	-- function 54
	local var_54_0 = NetworkLookup.pickup_names[arg_54_2]

	fassert(AllPickups[var_54_0], "pickup name %s does not exist in Pickups table", var_54_0)

	local var_54_1 = CHANNEL_TO_PEER_ID[arg_54_1]

	var_54_1 = var_54_1 or Network.peer_id()

	local var_54_2 = AllPickups[var_54_0]
	local var_54_3 = NetworkLookup.pickup_spawn_types[arg_54_5]

	self:_spawn_pickup(var_54_2, var_54_0, arg_54_3, arg_54_4, false, var_54_3, var_54_1)
end

PickupSystem.rpc_finalize_consumption = function (self, arg_55_1, arg_55_2, arg_55_3, arg_55_4)
	-- function 55
	local unit = Managers.state.unit_storage:unit(arg_55_2)

	if not unit then
		return
	end

	local var_55_1 = NetworkLookup.pickup_names[arg_55_4]

	self:finalize_consumption(unit, arg_55_3, var_55_1)
end

PickupSystem.rpc_spawn_linked_pickup = function (self, arg_56_1, arg_56_2, arg_56_3, arg_56_4, arg_56_5, arg_56_6, arg_56_7, arg_56_8, arg_56_9, arg_56_10)
	-- function 56
	fassert(self.is_server, "Can only spawn linked pickups on the server!")

	local var_56_0 = NetworkLookup.pickup_names[arg_56_2]
	local var_56_1 = NetworkLookup.pickup_spawn_types[arg_56_5]
	local var_56_2 = NetworkLookup.material_settings_templates[arg_56_10]

	fassert(AllPickups[var_56_0], "pickup name %s does not exist in Pickups table", var_56_0)

	local unit_spawner = Managers.state.unit_spawner
	local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(arg_56_6, arg_56_8)
	local flag = false
	local flag_2 = true

	if not (not game_object_or_level_unit and not Unit.alive(game_object_or_level_unit) and unit_spawner:is_marked_for_deletion(game_object_or_level_unit)) then
		flag = true
		flag_2 = false
	end

	local tbl = {
		pickup_system = {
			material_settings_name = var_56_2
		}
	}
	local var_56_8 = CHANNEL_TO_PEER_ID[arg_56_1 or Network.peer_id()]
	local var_56_9 = AllPickups[var_56_0]
	local _spawn_pickup, var_56_11 = self:_spawn_pickup(var_56_9, var_56_0, arg_56_3, arg_56_4, flag_2, var_56_1, var_56_8, arg_56_9, nil, nil, tbl)

	if not flag then
		Managers.state.entity:system("projectile_linker_system"):link_pickup(_spawn_pickup, arg_56_3, arg_56_4, game_object_or_level_unit, arg_56_7)
		self._network_manager.network_transmit:send_rpc_clients("rpc_link_pickup", var_56_11, arg_56_3, arg_56_4, arg_56_6, arg_56_7, arg_56_8)
	end
end

PickupSystem._delete_pickup = function (arg_57_0, arg_57_1)
	-- function 57
	local unit_spawner = Managers.state.unit_spawner

	if not (not arg_57_1 and not Unit.alive(arg_57_1) and unit_spawner:is_marked_for_deletion(arg_57_1)) then
		unit_spawner:mark_for_deletion(arg_57_1)
	end
end

PickupSystem.rpc_delete_pickup = function (self, arg_58_1, arg_58_2)
	-- function 58
	local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(arg_58_2)

	self:_delete_pickup(game_object_or_level_unit)
end

PickupSystem.rpc_delete_limited_owned_pickup_unit = function (self, arg_59_1, arg_59_2, arg_59_3)
	-- function 59
	local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(arg_59_3)

	self:delete_limited_owned_pickup_unit(arg_59_2, game_object_or_level_unit)
end

PickupSystem.rpc_delete_limited_owned_pickups = function (self, arg_60_1, arg_60_2)
	-- function 60
	self:event_delete_limited_owned_pickups(arg_60_2)
end

PickupSystem.rpc_delete_limited_owned_pickup_type = function (self, arg_61_1, arg_61_2, arg_61_3)
	-- function 61
	local var_61_0 = NetworkLookup.pickup_names[arg_61_3]

	self:delete_limited_owned_pickup_type(arg_61_2, var_61_0)
end

PickupSystem.rpc_force_use_pickup = function (self, arg_62_1, arg_62_2)
	-- function 62
	local is_server = Managers.player.is_server

	if not is_server then
		self.network_transmit:send_rpc_clients("rpc_force_use_pickup", arg_62_2)
	end

	local local_player = Managers.player:local_player()

	if not local_player then
		return
	end

	local player_unit = local_player.player_unit

	if not (not player_unit and Unit.alive(player_unit)) then
		return
	end

	if not local_player.bot_player then
		return
	end

	local var_62_3 = NetworkLookup.pickup_names[arg_62_2]
	local var_62_4 = AllPickups[var_62_3]
	local on_pick_up_func = var_62_4.on_pick_up_func

	if not on_pick_up_func then
		local main_world = Application.main_world()

		on_pick_up_func(main_world, player_unit, is_server)
	end

	local extension = ScriptUnit.extension(player_unit, "inventory_system")
	local extension_2 = ScriptUnit.extension(player_unit, "career_system")
	local slot_name = var_62_4.slot_name
	local item_name = var_62_4.item_name
	local get_wielded_slot_name = extension:get_wielded_slot_name()

	if not (var_62_4.wield_on_pickup or get_wielded_slot_name ~= slot_name) then
		CharacterStateHelper.stop_weapon_actions(extension, "picked_up_object")
		CharacterStateHelper.stop_career_abilities(extension_2, "picked_up_object")
	end

	local get_slot_data = extension:get_slot_data(slot_name)
	local var_62_13 = ItemMasterList[item_name]

	if not get_slot_data then
		extension:drop_level_event_item(get_slot_data)
	end

	local var_62_14
	local tbl = {}

	extension:add_equipment(slot_name, var_62_13, var_62_14, tbl)

	if not (var_62_4.wield_on_pickup or get_wielded_slot_name ~= slot_name) then
		local action_on_wield = var_62_4.action_on_wield

		if not action_on_wield then
			BackendUtils.get_item_template(var_62_13).next_action = action_on_wield
		end

		extension:wield(slot_name)
	end
end

PickupSystem.explosive_barrel = function (arg_63_0, arg_63_1, arg_63_2, arg_63_3)
	-- function 63
	local position_network_scale = AiAnimUtils.position_network_scale(arg_63_2, true)
	local rotation_network_scale = AiAnimUtils.rotation_network_scale(arg_63_3, true)
	local velocity_network_scale = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
	local var_63_3 = velocity_network_scale
	local str = "explosive_barrel"

	return {
		projectile_locomotion_system = {
			network_position = position_network_scale,
			network_rotation = rotation_network_scale,
			network_velocity = velocity_network_scale,
			network_angular_velocity = var_63_3
		},
		health_system = {
			in_hand = false,
			item_name = str
		}
	}
end

PickupSystem.wizards_barrel = function (arg_64_0, arg_64_1, arg_64_2, arg_64_3)
	-- function 64
	local position_network_scale = AiAnimUtils.position_network_scale(arg_64_2, true)
	local rotation_network_scale = AiAnimUtils.rotation_network_scale(arg_64_3, true)
	local velocity_network_scale = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
	local var_64_3 = velocity_network_scale
	local str = "wizards_barrel"

	return {
		projectile_locomotion_system = {
			network_position = position_network_scale,
			network_rotation = rotation_network_scale,
			network_velocity = velocity_network_scale,
			network_angular_velocity = var_64_3
		},
		health_system = {
			in_hand = false,
			item_name = str
		}
	}
end

PickupSystem.training_dummy = function (arg_65_0, arg_65_1, arg_65_2, arg_65_3)
	-- function 65
	local position_network_scale = AiAnimUtils.position_network_scale(arg_65_2, true)
	local rotation_network_scale = AiAnimUtils.rotation_network_scale(arg_65_3, true)
	local velocity_network_scale = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
	local var_65_3 = velocity_network_scale
	local str = "training_dummy"

	return {
		projectile_locomotion_system = {
			network_position = position_network_scale,
			network_rotation = rotation_network_scale,
			network_velocity = velocity_network_scale,
			network_angular_velocity = var_65_3
		},
		health_system = {
			in_hand = false,
			item_name = str
		}
	}
end

PickupSystem.set_taken = function (self, arg_66_1)
	-- function 66
	if not self.is_server then
		self._taken[arg_66_1] = true
	end
end
