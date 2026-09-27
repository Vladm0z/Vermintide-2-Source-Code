-- chunkname: @scripts/entity_system/systems/ai/ai_group_system.lua

require("scripts/entity_system/systems/ai/ai_group_templates/ai_group_templates")
require("scripts/entity_system/systems/ai/ai_group_templates/ai_group_templates_patrol")

AIGroupSystem = class(AIGroupSystem, ExtensionSystemBase)

local AIGroupTemplates = AIGroupTemplates
local tbl = {
	"AIGroupMember"
}

AIGroupSystem.invalid_group_uid = 0

AIGroupSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	local entity_manager = arg_1_1.entity_manager

	entity_manager:register_system(self, arg_1_2, tbl)

	self.entity_manager = entity_manager
	self.is_server = arg_1_1.is_server
	self._world = arg_1_1.world
	self.unit_storage = arg_1_1.unit_storage
	self.nav_world = Managers.state.entity:system("ai_system"):nav_world()
	self.groups = {}
	self.groups_to_initialize = {}
	self.groups_to_update = {}
	self.unit_extension_data = {}
	self.frozen_unit_extension_data = {}
	self.group_uid = AIGroupSystem.invalid_group_uid
	self._spline_properties = {}
	self._spline_lookup = {}
	self._cached_splines = {}
	self._last_recycler_group_id = nil
end

function boxify_table_pos_array(self)
	-- function 2
	for i = 1, #self do
		local var_2_0 = self[i]

		self[i] = Vector3Box(var_2_0[1], var_2_0[2], var_2_0[3])
	end
end

function remove_duplicates(self)
	-- function 3
	local count = #self
	local equal = Vector3.equal

	for i = count, 2, -1 do
		local unbox = self[i]:unbox()
		local unbox_2 = self[i - 1]:unbox()

		if not equal(unbox, unbox_2) then
			table.remove(self, i)
		end
	end
end

AIGroupSystem.add_ready_splines = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not arg_4_1 then
		return
	end

	for i = 1, #arg_4_1 do
		local var_4_0 = arg_4_1[i]
		local astar_points = var_4_0.astar_points

		if not astar_points then
			boxify_table_pos_array(astar_points)
			remove_duplicates(astar_points)

			local var_4_2 = astar_points[1]
			local unbox = var_4_2:unbox()

			if #astar_points == 2 then
				table.insert(astar_points, 2, Vector3Box((unbox + astar_points[2]:unbox()) / 2))
			end

			local normalize = Vector3.normalize(astar_points[3]:unbox() - unbox)
			local tbl = {
				start_position = var_4_2,
				start_direction = Vector3Box(normalize),
				spline_points = astar_points
			}

			self:_add_spline(var_4_0.id, tbl, arg_4_2)
		end
	end
end

AIGroupSystem.destroy = function (arg_5_0)
	-- function 5
	return
end

AIGroupSystem.ai_ready = function (self, arg_6_1)
	-- function 6
	self.patrol_analysis = arg_6_1
end

AIGroupSystem.on_add_extension = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local tbl = {}

	if arg_7_4.id ~= nil then
		self:init_extension(arg_7_2, tbl, arg_7_4)
	end

	ScriptUnit.set_extension(arg_7_2, "ai_group_system", tbl)

	self.unit_extension_data[arg_7_2] = tbl

	return tbl
end

AIGroupSystem.init_extension = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local id = arg_8_3.id
	local template = arg_8_3.template
	local var_8_2 = self.groups[id]
	local formation = arg_8_3.formation
	local settings

	if not formation then
		settings = formation.settings

		if not settings then
			-- Nothing
		end
	end

	settings = PatrolFormationSettings.default_settings

	::label_8_0::

	local despawn_at_end = arg_8_3.despawn_at_end

	if var_8_2 == nil then
		var_8_2 = {
			members_n = 0,
			start_forward = true,
			num_spawned_members = 0,
			id = id,
			members = {},
			size = arg_8_3.size,
			template = template,
			spline_name = arg_8_3.spline_name,
			formation = formation,
			formation_settings = settings,
			group_type = arg_8_3.group_type,
			group_start_position = arg_8_3.group_start_position,
			despawn_at_end = despawn_at_end,
			side_id = arg_8_3.side_id,
			side = arg_8_3.side,
			commanding_player = arg_8_3.commanding_player,
			group_data = arg_8_3.group_data
		}

		local spline_name = var_8_2.spline_name
		local var_8_7 = self._patrol_splines[spline_name]

		if not var_8_7 then
			var_8_7 = self._roaming_splines[spline_name]
			var_8_7 = var_8_7 or self._event_splines[spline_name]
		end

		if not var_8_7 then
			var_8_2.spline_points = var_8_7.spline_points
			var_8_2.cached_splines = self._cached_splines[spline_name]
		end

		fassert(var_8_2.size, "Created group without size!")
		fassert(template, "Created group without template!")

		self.groups[id] = var_8_2
		self.groups_to_initialize[id] = var_8_2

		local setup_group = AIGroupTemplates[template].setup_group

		if not setup_group then
			setup_group(self.world, self.nav_world, var_8_2, arg_8_1)
		end
	elseif not arg_8_3.insert_into_group then
		var_8_2.size = var_8_2.size + 1
	end

	local breed = arg_8_3.breed
	local formation_2 = var_8_2.formation

	if not breed and not formation_2 then
		local group_position = arg_8_3.group_position

		arg_8_2.group_row = group_position.row
		arg_8_2.group_column = group_position.column
	end

	var_8_2.members[arg_8_1] = arg_8_2
	var_8_2.members_n = var_8_2.members_n + 1
	var_8_2.num_spawned_members = var_8_2.num_spawned_members + 1
	arg_8_2.group = var_8_2
	arg_8_2.template = template
	arg_8_2.id = id

	local var_8_12 = AIGroupTemplates[template]

	arg_8_2.in_patrol = var_8_12.in_patrol, var_8_12.use_patrol_perception
	arg_8_2.use_patrol_perception = arg_8_3.group_type == "spline_patrol"

	fassert(var_8_2.num_spawned_members <= var_8_2.size, "An AI group was initialized with size=%d but %d AIs was assigned to it.", var_8_2.size, var_8_2.num_spawned_members)
end

AIGroupSystem.extensions_ready = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local var_9_0 = self.unit_extension_data[arg_9_2]
	local var_9_1 = AIGroupTemplates[var_9_0.template]

	var_9_1 = not var_9_1 and AIGroupTemplates[var_9_0.template].pre_unit_init

	if not var_9_1 then
		var_9_1(arg_9_2, var_9_0.group)
	end
end

AIGroupSystem.on_remove_extension = function (self, arg_10_1, arg_10_2)
	-- function 10
	self.frozen_unit_extension_data[arg_10_1] = nil

	self:_cleanup_extension(arg_10_1, arg_10_2)
	ScriptUnit.remove_extension(arg_10_1, self.NAME)
end

AIGroupSystem.on_freeze_extension = function (self, arg_11_1, arg_11_2)
	-- function 11
	local var_11_0 = self.unit_extension_data[arg_11_1]

	fassert(var_11_0, "Unit was already frozen.")

	if var_11_0 == nil then
		return
	end

	self.frozen_unit_extension_data[arg_11_1] = var_11_0

	self:_cleanup_extension(arg_11_1, arg_11_2)
end

AIGroupSystem.freeze = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local frozen_unit_extension_data = self.frozen_unit_extension_data

	if not frozen_unit_extension_data[arg_12_1] then
		return
	end

	local var_12_1 = self.unit_extension_data[arg_12_1]

	fassert(var_12_1, "Unit to freeze didn't have unfrozen extension")
	self:_cleanup_extension(arg_12_1, arg_12_2)

	self.unit_extension_data[arg_12_1] = nil
	frozen_unit_extension_data[arg_12_1] = var_12_1
end

AIGroupSystem.unfreeze = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local var_13_0 = self.frozen_unit_extension_data[arg_13_1]

	fassert(var_13_0, "Unit to unfreeze didn't have frozen extension")

	self.frozen_unit_extension_data[arg_13_1] = nil
	self.unit_extension_data[arg_13_1] = var_13_0

	local var_13_1 = arg_13_3[8]

	if not var_13_1 and not var_13_1.id then
		self:init_extension(arg_13_1, var_13_0, var_13_1)
	end
end

AIGroupSystem._cleanup_extension = function (self, arg_14_1, arg_14_2)
	-- function 14
	local var_14_0 = self.unit_extension_data[arg_14_1]

	if var_14_0 == nil then
		return
	end

	self.unit_extension_data[arg_14_1] = nil

	local id = var_14_0.id

	if not id then
		return
	end

	local var_14_2 = self.groups[id]

	fassert(var_14_2 ~= nil, "Trying to remove group extension for unit %s that does not belong to a group.", arg_14_1)

	var_14_2.members[arg_14_1] = nil
	var_14_2.members_n = var_14_2.members_n - 1

	if not (var_14_2.members_n ~= 0 or var_14_2.num_spawned_members ~= var_14_2.size) then
		local _world = self._world
		local nav_world = self.nav_world

		if self.groups_to_initialize[id] == nil then
			local template = var_14_2.template

			AIGroupTemplates[template].destroy(_world, nav_world, var_14_2, arg_14_1)
		end

		self.groups[id] = nil
		self.groups_to_initialize[id] = nil
		self.groups_to_update[id] = nil

		if id == self._last_recycler_group_id then
			self._last_recycler_group_id = nil
		end
	end

	var_14_0.id = nil
	var_14_0.group = nil
	var_14_0.template = nil
	var_14_0.in_patrol = nil
	var_14_0.use_patrol_perception = nil
end

local num = 100
local num_2 = 100
local num_3 = 100
local str = "patrol_"
local str_2 = "roaming_"
local str_3 = "event_"

AIGroupSystem.set_level = function (self, arg_15_1)
	-- function 15
	self._level = arg_15_1
	self._patrol_splines = {}
	self._roaming_splines = {}
	self._event_splines = {}

	local _world = self._world

	for i = 1, num do
		repeat
			local str_4 = str .. i
			local spline = Level.spline(arg_15_1, str_4)

			if #spline == 0 then
				break
			end

			local var_15_3 = spline[1]
			local normalize = Vector3.normalize(spline[3] - spline[1])
			local tbl = {
				start_position = Vector3Box(var_15_3),
				start_direction = Vector3Box(normalize)
			}

			self._patrol_splines[str_4] = tbl
			self._spline_lookup[str_4] = tbl
		until true
	end

	for j = 1, num_2 do
		repeat
			local str_5 = str_2 .. j
			local spline_2 = Level.spline(arg_15_1, str_5)

			if #spline_2 == 0 then
				break
			end

			local var_15_8 = spline_2[1]
			local normalize_2 = Vector3.normalize(spline_2[3] - spline_2[1])
			local tbl_2 = {
				start_position = Vector3Box(var_15_8),
				start_direction = Vector3Box(normalize_2)
			}

			self._roaming_splines[str_5] = tbl_2
			self._spline_lookup[str_5] = tbl_2
		until true
	end

	for k = 1, num_3 do
		repeat
			local str_6 = str_3 .. k
			local spline_3 = Level.spline(arg_15_1, str_6)

			if #spline_3 == 0 then
				break
			end

			local var_15_13 = spline_3[1]
			local normalize_3 = Vector3.normalize(spline_3[3] - spline_3[1])
			local tbl_3 = {
				start_position = Vector3Box(var_15_13),
				start_direction = Vector3Box(normalize_3)
			}

			self._event_splines[str_6] = tbl_3
			self._spline_lookup[str_6] = tbl_3
		until true
	end
end

local num_4 = 25
local num_5 = 25

AIGroupSystem.get_best_spline = function (self, arg_16_1, arg_16_2)
	-- function 16
	local var_16_0
	local var_16_1
	local huge = math.huge
	local var_16_3
	local var_16_4

	if arg_16_2 == "patrol" then
		var_16_3 = self._patrol_splines
		var_16_4 = math.huge
	elseif arg_16_2 == "roaming" then
		var_16_3 = self._roaming_splines
		var_16_4 = num_5
	elseif arg_16_2 == "event" then
		var_16_3 = self._event_splines
		var_16_4 = math.huge
	end

	for k, v in pairs(var_16_3) do
		repeat
			local random = math.random(1, num_4)
			local unbox = v.start_position:unbox()
			local distance = Vector3.distance(arg_16_1, unbox)

			if var_16_4 < distance then
				break
			end

			local num = distance - random

			if huge < num then
				break
			end

			huge = num
			var_16_0 = k
			var_16_1 = v
		until true
	end

	return var_16_0, var_16_1
end

AIGroupSystem.spline_start_position = function (self, arg_17_1)
	-- function 17
	return (self._spline_lookup[arg_17_1].start_position:unbox())
end

AIGroupSystem.spline_start_direction = function (self, arg_18_1)
	-- function 18
	return (self._spline_lookup[arg_18_1].start_direction:unbox())
end

AIGroupSystem.spline = function (self, arg_19_1)
	-- function 19
	return self._spline_lookup[arg_19_1]
end

AIGroupSystem.level_has_splines = function (self, arg_20_1)
	-- function 20
	local var_20_0

	if arg_20_1 == "patrol" then
		var_20_0 = self._patrol_splines
	elseif arg_20_1 == "roaming" then
		var_20_0 = self._roaming_splines
	elseif arg_20_1 == "event" then
		var_20_0 = self._event_splines
	else
		error("no such spline_type: " .. arg_20_1)
	end

	return table.size(var_20_0) > 0
end

AIGroupSystem.get_available_spline_type = function (self)
	-- function 21
	local var_21_0

	if not self._patrol_splines then
		local _patrol_splines = self._patrol_splines
	elseif not self._roaming_splines then
		local _roaming_splines = self._roaming_splines
	elseif not self._event_splines then
		local _event_splines = self._event_splines
	end

	local str

	if not next(self._patrol_splines) then
		str = "patrol"
	elseif not next(self._roaming_splines) then
		str = "roaming"
	else
		str = next(self._event_splines)
		str = not str and "event"
	end

	return str
end

AIGroupSystem.hot_join_sync = function (arg_22_0, arg_22_1, arg_22_2)
	-- function 22
	return
end

local POSITION_LOOKUP = POSITION_LOOKUP

AIGroupSystem.check_recycler_despawn = function (self, arg_23_1, arg_23_2, arg_23_3)
	-- function 23
	local groups_to_update = self.groups_to_update
	local var_23_1, var_23_2 = next(groups_to_update, self._last_recycler_group_id)

	self._last_recycler_group_id = var_23_1

	if not var_23_1 and var_23_2.group_type ~= "roaming_patrol" or not var_23_2.patrol_in_combat then
		return
	end

	local var_23_3 = var_23_2.indexed_members[1]
	local var_23_4 = POSITION_LOOKUP[var_23_3]

	if not var_23_4 then
		return
	end

	local conflict = Managers.state.conflict
	local navigation_group_manager = conflict.navigation_group_manager
	local get_group_from_position = navigation_group_manager:get_group_from_position(var_23_4)

	if not get_group_from_position then
		return
	end

	local CurrentRoamingSettings = CurrentRoamingSettings
	local despawn_path_distance = CurrentRoamingSettings.despawn_path_distance
	local num = CurrentRoamingSettings.despawn_distance + 8
	local despawn_distance_z = CurrentRoamingSettings.despawn_distance_z

	despawn_distance_z = despawn_distance_z or 8

	local flag = false
	local count = #arg_23_1
	local abs = math.abs

	if count >= 0 then
		for i = 1, count do
			local num_2 = var_23_4 - arg_23_1[i]
			local z = num_2.z

			Vector3.set_z(num_2, 0)

			if not (not (num > Vector3.length(num_2)) or not (despawn_distance_z > abs(z))) then
				local var_23_17 = arg_23_2[i]

				if not arg_23_3 and not var_23_17 then
					local a_star_cached, var_23_19, var_23_20 = navigation_group_manager:a_star_cached(var_23_17, get_group_from_position)

					if not (not var_23_19 and not (var_23_19 < despawn_path_distance)) then
						flag = true

						break
					end
				else
					flag = true

					break
				end
			end
		end
	else
		flag = true
	end

	if not flag then
		local indexed_members = var_23_2.indexed_members
		local num_indexed_members = var_23_2.num_indexed_members
		local enemy_recycler = conflict.enemy_recycler
		local BLACKBOARDS = BLACKBOARDS

		for j = 1, num_indexed_members do
			local var_23_25 = indexed_members[j]
			local var_23_26 = BLACKBOARDS[var_23_25]
			local var_23_27 = Vector3Box(POSITION_LOOKUP[var_23_25])
			local var_23_28 = QuaternionBox(Unit.local_rotation(var_23_25, 0))

			enemy_recycler:add_breed(var_23_26.breed.name, var_23_27, var_23_28)
			Managers.state.conflict:destroy_unit(var_23_25, var_23_26, "patrol_finished")
		end
	end
end

local tbl_2 = {
	mode = "retained",
	name = "AIGroupTemplates_retained"
}

AIGroupSystem.update = function (self, arg_24_1, arg_24_2)
	-- function 24
	if not self.is_server then
		return
	end

	local _world = self._world
	local nav_world = self.nav_world
	local var_24_2 = AIGroupTemplates

	for k, v in pairs(self.groups_to_initialize) do
		if v.num_spawned_members == v.size then
			if v.members_n > 0 then
				local template = v.template
				local init = var_24_2[template].init

				printf("Init group template: %s", template)
				init(_world, nav_world, v, arg_24_2)

				self.groups_to_initialize[v.id] = nil
				self.groups_to_update[v.id] = v
			else
				self.groups_to_initialize[v.id] = nil
			end
		end
	end

	for k_2, v_2 in pairs(self.groups_to_update) do
		var_24_2[v_2.template].update(_world, nav_world, v_2, arg_24_2, arg_24_1.dt)
	end

	if not self.patrol_analysis and not self._computing_splines then
		self.patrol_analysis:run()

		for k_3, v_3 in pairs(self._computing_splines) do
			repeat
				if not self:_spline_ready(k_3) then
					break
				end

				local spline = self.patrol_analysis:spline(k_3)
				local spline_points = spline.spline_points
				local var_24_7 = spline_points[1]

				fassert(var_24_7, "missing starting spline point, for spline %s", spline.id)

				local unbox = var_24_7:unbox()

				if #spline_points == 2 then
					table.insert(spline_points, 2, Vector3Box((unbox + spline_points[2]:unbox()) / 2))
				end

				local normalize = Vector3.normalize(spline_points[3]:unbox() - unbox)

				for i6 = #spline_points, 2, -1 do
					local unbox_2 = spline_points[i6]:unbox()
					local unbox_3 = spline_points[i6 - 1]:unbox()

					if not Vector3.equal(unbox_2, unbox_3) then
						table.remove(spline_points, i6)
					end
				end

				local tbl = {
					start_position = var_24_7,
					start_direction = Vector3Box(normalize),
					spline_points = spline_points,
					failed = spline.failed
				}

				self:_add_spline(k_3, tbl, v_3)

				self._computing_splines[k_3] = nil
			until true
		end
	end

	local conflict = Managers.state.conflict

	if not self._update_recycler then
		self:check_recycler_despawn(self._player_positions, self._player_areas, self._use_player_areas)
	end

	self._update_recycler = false
end

AIGroupSystem.prepare_update_recycler = function (self, arg_25_1, arg_25_2, arg_25_3)
	-- function 25
	self._update_recycler = true
	self._player_positions = arg_25_1
	self._player_areas = arg_25_2
	self._use_player_areas = arg_25_3
end

AIGroupSystem.get_ai_group = function (self, arg_26_1)
	-- function 26
	return self.groups[arg_26_1]
end

AIGroupSystem.run_func_on_all_members = function (arg_27_0, arg_27_1, arg_27_2, ...)
	-- function 27
	local members = arg_27_1.members

	for k, v in pairs(members) do
		arg_27_2(k, v, ...)
	end
end

AIGroupSystem.generate_group_id = function (self)
	-- function 28
	self.group_uid = self.group_uid + 1

	return self.group_uid
end

AIGroupSystem.set_allowed_layer = function (self, arg_29_1, arg_29_2)
	-- function 29
	local var_29_0 = LAYER_ID_MAPPING[arg_29_1]

	for k, v in pairs(self.groups_to_update) do
		if not v.nav_data and not v.nav_data.navtag_layer_cost_table then
			if not arg_29_2 then
				GwNavTagLayerCostTable.allow_layer(v.nav_data.navtag_layer_cost_table, var_29_0)
			else
				GwNavTagLayerCostTable.forbid_layer(v.nav_data.navtag_layer_cost_table, var_29_0)
			end
		end
	end
end

AIGroupSystem.create_spline_from_way_points = function (self, arg_30_1, arg_30_2, arg_30_3)
	-- function 30
	local flag

	flag = arg_30_3 ~= "roaming" or not "roaming" or "standard"

	self.patrol_analysis:compute_spline_path(arg_30_1, arg_30_2, flag)

	local _computing_splines = self._computing_splines

	_computing_splines = _computing_splines or {}
	self._computing_splines = _computing_splines
	self._computing_splines[arg_30_1] = arg_30_3
end

AIGroupSystem.spline_ready = function (self, arg_31_1)
	-- function 31
	return self._spline_lookup[arg_31_1]
end

AIGroupSystem._spline_ready = function (self, arg_32_1)
	-- function 32
	local patrol_analysis = self.patrol_analysis

	if not patrol_analysis then
		return false
	end

	return (patrol_analysis:spline(arg_32_1))
end

AIGroupSystem._add_spline = function (self, arg_33_1, arg_33_2, arg_33_3)
	-- function 33
	self._spline_lookup[arg_33_1] = arg_33_2

	if not GameSettingsDevelopment.pre_calculate_patrol_splines then
		self._cached_splines[arg_33_1] = self:_calculate_splines(arg_33_1, arg_33_2)
	end

	if not (arg_33_3 == "patrol" or string.find(arg_33_1, str)) then
		self._patrol_splines[arg_33_1] = arg_33_2

		return
	end

	if not (arg_33_3 == "roaming" or string.find(arg_33_1, str_2)) then
		self._roaming_splines[arg_33_1] = arg_33_2

		return
	end

	if not (arg_33_3 == "event" or string.find(arg_33_1, str_3)) then
		self._event_splines[arg_33_1] = arg_33_2

		return
	end

	error("unsupported spline type for spline: " .. arg_33_1 .. ". Spline name should start with 'patrol_', 'roaming_' or 'event_' which defines the spline type")
end

AIGroupSystem._calculate_splines = function (arg_34_0, arg_34_1, arg_34_2)
	-- function 34
	if not arg_34_2.spline_points then
		return
	end

	local tbl = {}
	local spline_points = arg_34_2.spline_points
	local remove_bad_boxed_spline_points = AiUtils.remove_bad_boxed_spline_points(spline_points, arg_34_1)

	return SplineCurve:new(remove_bad_boxed_spline_points, "Hermite", "SplineMovementHermiteInterpolatedMetered", arg_34_1, 3):splines()
end

AIGroupSystem.draw_active_spline_paths = function (self)
	-- function 35
	local QuickDrawerStay = QuickDrawerStay
	local _patrol_splines = self._patrol_splines
	local var_35_2 = Color(255, 255, 0)

	for k, v in pairs(_patrol_splines) do
		self:draw_spline(v.spline_points, QuickDrawerStay, var_35_2)
	end

	local _roaming_splines = self._roaming_splines
	local var_35_4 = Color(255, 255, 0)

	for k_2, v_2 in pairs(_roaming_splines) do
		self:draw_spline(v_2.spline_points, QuickDrawerStay, var_35_4)
	end

	local _event_splines = self._event_splines
	local var_35_6 = Color(255, 255, 0)

	for k_3, v_3 in pairs(_event_splines) do
		self:draw_spline(v_3.spline_points, QuickDrawerStay, var_35_6)
	end
end

AIGroupSystem.draw_spline = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
	-- function 36
	local unbox = arg_36_1[1]:unbox()
	local var_36_1 = Vector3(0, 0, 1)

	for i = 2, #arg_36_1 do
		local var_36_2 = arg_36_1[i]
		local unbox_2 = arg_36_1[i]:unbox()

		arg_36_2:line(unbox + var_36_1, unbox_2 + var_36_1, arg_36_3)

		unbox = unbox_2
	end
end

AIGroupSystem.create_formation_data = function (self, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5)
	-- function 37
	local y = PatrolFormationSettings.default_settings.offsets.ANCHOR_OFFSET.y
	local SPLINE_SPEED = PatrolFormationSettings.default_settings.speeds.SPLINE_SPEED
	local spline_start_direction = self:spline_start_direction(arg_37_3)
	local clone = table.clone(arg_37_2)
	local count = #arg_37_2
	local num = (count - 1) * SPLINE_SPEED
	local num_2 = 0
	local var_37_7 = self._spline_lookup[arg_37_3]
	local var_37_8

	if not var_37_7.spline_points then
		local var_37_9 = self._cached_splines[arg_37_3]
		local spline_points = var_37_7.spline_points
		local remove_bad_boxed_spline_points = AiUtils.remove_bad_boxed_spline_points(spline_points, arg_37_3)

		var_37_8 = SplineCurve:new(remove_bad_boxed_spline_points, "Hermite", "SplineMovementHermiteInterpolatedMetered", arg_37_3, 3, var_37_9)
	else
		local _level = self._level
		local spline = Level.spline(_level, arg_37_3)
		local remove_bad_spline_points = AiUtils.remove_bad_spline_points(spline, arg_37_3)

		var_37_8 = SplineCurve:new(remove_bad_spline_points, "Bezier", "SplineMovementHermiteInterpolatedMetered", arg_37_3, 10)
	end

	local get_closest_index_on_spline = NavigationUtils.get_closest_index_on_spline(var_37_8, arg_37_1)
	local num_3 = 1
	local num_4 = 1
	local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position
	local nav_world = self.nav_world
	local var_37_20
	local var_37_21
	local var_37_22
	local var_37_23

	if not arg_37_4 then
		local var_37_24

		var_37_20, var_37_24 = self:_get_position_on_spline_by_distance(0, var_37_8, get_closest_index_on_spline)

		if var_37_20 == nil then
			var_37_20 = arg_37_1
			var_37_24 = spline_start_direction
		end

		var_37_23 = Vector3(var_37_24.y, -var_37_24.x, 0)
		var_37_22 = Vector3.flat(var_37_24)
	end

	local num_5 = 1

	for i, v in ipairs(arg_37_2) do
		table.clear(clone[i])

		if not arg_37_4 then
			local num_6 = num - (num_5 - 1) * SPLINE_SPEED
			local var_37_27

			var_37_20, var_37_27 = self:_get_position_on_spline_by_distance(num_6, var_37_8, get_closest_index_on_spline)

			if var_37_20 == nil then
				var_37_20 = arg_37_1
				var_37_27 = spline_start_direction
			end

			var_37_23 = Vector3(var_37_27.y, -var_37_27.x, 0)
			var_37_22 = Vector3.flat(var_37_27)
		end

		for i_2, v_2 in ipairs(v) do
			local num_7 = var_37_20 + var_37_23 * (-((#v - 1) * (y * 2)) / 2 + y * 2 * (i_2 - 1))

			if not Breeds[v_2] then
				local pos_on_mesh = LocomotionUtils.pos_on_mesh(nav_world, num_7, num_3, num_4)

				pos_on_mesh = pos_on_mesh or LocomotionUtils.pos_on_mesh(nav_world, var_37_20, num_3, num_4)
				pos_on_mesh = pos_on_mesh or inside_position_from_outside_position(nav_world, num_7, num_3, num_4, 0.5, 0.2)

				if not pos_on_mesh then
					clone[num_5][i_2] = {
						breed_name = v_2,
						start_position = Vector3Box(pos_on_mesh),
						start_direction = Vector3Box(var_37_22)
					}
					num_2 = num_2 + 1
				else
					if not arg_37_5 then
						printf("Patrol formation outside navmesh. template_name: %s, spline_name: %s group_type: %s, wanted_spawn_pos: %s", arg_37_5.template, arg_37_3, arg_37_5.group_type, tostring(num_7))
					end

					clone[num_5][i_2] = {
						start_position = Vector3Box(num_7),
						start_direction = Vector3Box(var_37_22)
					}
				end
			else
				clone[num_5][i_2] = {
					start_position = Vector3Box(num_7),
					start_direction = Vector3Box(var_37_22)
				}
			end
		end

		if #clone[num_5] > 0 then
			num_5 = num_5 + 1
		end
	end

	for i4 = num_5, count do
		local var_37_30 = clone[i4]

		clone[i4] = nil
	end

	clone.group_size = num_2

	return clone
end

AIGroupSystem._get_position_on_spline_by_distance = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	-- function 38
	local num = 0
	local movement = arg_38_2:movement()

	movement:reset_to_start()
	movement:set_speed(2)

	if not arg_38_3 then
		movement:set_spline_index(arg_38_3, 1, 0)
	end

	local current_position, current_spline_curve_distance = movement:current_position(), movement:current_spline_curve_distance()
	local num_2 = 0.1

	while true do
		local temp_count, var_38_6, var_38_7 = Script.temp_count()

		if movement:update(num_2) == "end" then
			return nil
		end

		local current_position_2 = movement:current_position()
		local current_spline_curve_distance_2 = movement:current_spline_curve_distance()
		local abs = math.abs(current_spline_curve_distance_2 - current_spline_curve_distance)

		num = abs + num

		if not (arg_38_1 <= num or not (abs <= 0)) then
			local normalize = Vector3.normalize(current_position_2 - current_position)

			return current_position_2, normalize
		end

		Vector3.set_xyz(current_position, current_position_2.x, current_position_2.y, current_position_2.z)

		current_spline_curve_distance = current_spline_curve_distance_2

		Script.set_temp_count(temp_count, var_38_6, var_38_7)
	end
end

AIGroupSystem.register_spline_properties = function (arg_39_0, arg_39_1, arg_39_2)
	-- function 39
	arg_39_0._spline_properties[arg_39_1] = arg_39_2
end

AIGroupSystem.get_group_id = function (self, arg_40_1)
	-- function 40
	local var_40_0 = self.unit_extension_data[arg_40_1]

	return not var_40_0 and var_40_0.id
end
