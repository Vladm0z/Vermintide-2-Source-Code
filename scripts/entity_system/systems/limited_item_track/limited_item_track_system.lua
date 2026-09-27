-- chunkname: @scripts/entity_system/systems/limited_item_track/limited_item_track_system.lua

require("scripts/unit_extensions/limited_item_track/limited_item_track_spawner")

LimitedItemTrackSystem = class(LimitedItemTrackSystem, ExtensionSystemBase)

local tbl = {}
local tbl_2 = {
	"LimitedItemTrackSpawner",
	"HeldLimitedItemExtension",
	"LimitedItemExtension",
	"WeaveLimitedItemTrackSpawner"
}

LimitedItemTrackSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	LimitedItemTrackSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	local network_event_delegate = arg_1_1.network_event_delegate

	network_event_delegate:register(self, unpack(tbl))

	self.network_event_delegate = network_event_delegate
	self.network_manager = Managers.state.network
	self.spawners = {}
	self.active_spawners = {}
	self.active_spawners_n = 0
	self.items = {}
	self.groups = {}
	self.active_groups = {}
	self.active_groups_n = 0
	self.queued_group_spawners = {}
	self.queued_weave_group_spawners = {}
	self.no_group_spawners = {}
	self.marked_items = {}

	self.mark_item_for_transformation = function (self)
		-- function 2
		local unit = self.unit
		local marked_items = self.marked_items
		local id

		if self.id > 0 then
			id = self.id

			if not id then
				-- Nothing
			end
		end

		id = nil

		::label_2_0::

		marked_items[unit] = id
	end

	self.enable_spawner = function (self)
		-- function 3
		local unit = self.unit
		local num = self.active_spawners_n + 1
		local spawners = self.spawners

		fassert(spawners[unit], "Tried enabling spawner that does not exist %q", tostring(unit))

		self.active_spawners[num] = unit
		self.active_spawners_n = num
	end

	self.disable_spawner = function (self)
		-- function 4
		local unit = self.unit
		local find_active_spawner_id = self:find_active_spawner_id(unit)

		if find_active_spawner_id == nil then
			return
		end

		table.remove(self.active_spawners, find_active_spawner_id)

		self.active_spawners_n = self.active_spawners_n - 1
	end
end

LimitedItemTrackSystem.register_group = function (self, arg_5_1, arg_5_2)
	-- function 5
	fassert(self.groups[arg_5_1] == nil, "Limited Item Group with name %q, is already registered", arg_5_1)

	local var_5_0 = self.queued_group_spawners[arg_5_1]

	var_5_0 = var_5_0 or {}

	local count = #var_5_0

	self.queued_group_spawners[arg_5_1] = nil
	self.groups[arg_5_1] = {
		spawners = var_5_0,
		spawners_n = count,
		pool_size = arg_5_2
	}
end

LimitedItemTrackSystem.register_weave_group = function (self, arg_6_1, arg_6_2)
	-- function 6
	fassert(self.groups[arg_6_1] == nil, "Limited Item Group with name %q, is already registered", arg_6_1)

	local var_6_0 = self.queued_weave_group_spawners[arg_6_1]

	var_6_0 = var_6_0 or {}

	local count = #var_6_0

	self.queued_weave_group_spawners[arg_6_1] = nil
	self.groups[arg_6_1] = {
		spawners = var_6_0,
		spawners_n = count,
		pool_size = arg_6_2
	}
end

LimitedItemTrackSystem.decrease_group_pool_size = function (self, arg_7_1)
	-- function 7
	local var_7_0 = self.groups[arg_7_1]
	local max = math.max(var_7_0.pool_size - 1, 0)

	var_7_0.pool_size = max

	if max == 0 then
		self:deactivate_group(arg_7_1)
	end
end

LimitedItemTrackSystem.activate_group = function (self, arg_8_1, arg_8_2)
	-- function 8
	local active_groups = self.active_groups
	local active_groups_n = self.active_groups_n

	for i = 1, active_groups_n do
		if active_groups[i] == arg_8_1 then
			Application.warning(string.format("Limited Item Group %q is already active", arg_8_1))

			return
		end
	end

	self.active_groups_n = active_groups_n + 1
	active_groups[self.active_groups_n] = arg_8_1
	self.groups[arg_8_1].pool_size = arg_8_2
end

LimitedItemTrackSystem.weave_activate_spawner = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not self.groups[arg_9_2] then
		self:register_weave_group(arg_9_2, 0)
	end

	local active_groups = self.active_groups
	local active_groups_n = self.active_groups_n
	local num = active_groups_n + 1

	for i = 1, active_groups_n do
		if active_groups[i] == arg_9_2 then
			num = i

			break
		end
	end

	active_groups[num] = arg_9_2
	self.groups[arg_9_2].pool_size = self.groups[arg_9_2].pool_size + 1
	self.active_groups_n = #active_groups
end

LimitedItemTrackSystem.deactivate_group = function (self, arg_10_1)
	-- function 10
	local active_groups = self.active_groups
	local active_groups_n = self.active_groups_n

	for i = 1, active_groups_n do
		if active_groups[i] == arg_10_1 then
			table.remove(active_groups, i)

			self.active_groups_n = active_groups_n - 1

			break
		end
	end
end

LimitedItemTrackSystem.find_active_spawner_id = function (self, arg_11_1)
	-- function 11
	local active_spawners = self.active_spawners
	local active_spawners_n = self.active_spawners_n

	for i = 1, active_spawners_n do
		if arg_11_1 == active_spawners[i] then
			return i
		end
	end

	return nil
end

LimitedItemTrackSystem.destroy = function (self)
	-- function 12
	self.network_event_delegate:unregister(self)

	self.network_event_delegate = nil
	self.network_manager = nil
end

local tbl_3 = {}
local tbl_4 = {}

LimitedItemTrackSystem.on_add_extension = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	arg_13_4 = next(arg_13_4) ~= nil or not tbl_4 or arg_13_4
	arg_13_4.network_manager = self.network_manager

	if arg_13_3 == "LimitedItemTrackSpawner" then
		local get_data = Unit.get_data(arg_13_2, "pool")

		arg_13_4.template_name, arg_13_4.pool = Unit.get_data(arg_13_2, "template_name"), 1

		local on_add_extension = LimitedItemTrackSystem.super.on_add_extension(self, arg_13_1, arg_13_2, arg_13_3, arg_13_4)

		on_add_extension.enable = self.enable_spawner
		on_add_extension.disable = self.disable_spawner
		self.spawners[arg_13_2] = on_add_extension

		local get_data_2 = Unit.get_data(arg_13_2, "group_name")

		if get_data_2 ~= "" then
			local var_13_3 = self.groups[get_data_2]

			if var_13_3 == nil then
				local var_13_4 = self.queued_group_spawners[get_data_2]

				var_13_4 = var_13_4 or {}
				var_13_4[#var_13_4 + 1] = on_add_extension
				self.queued_group_spawners[get_data_2] = var_13_4
			else
				local spawners = var_13_3.spawners
				local num = var_13_3.spawners_n + 1

				spawners[num] = on_add_extension
				var_13_3.spawners_n = num
			end
		else
			self.no_group_spawners[#self.no_group_spawners + 1] = on_add_extension
		end

		arg_13_4.pool = nil
		arg_13_4.template_name = nil
		arg_13_4.network_manager = nil

		return on_add_extension
	elseif arg_13_3 == "WeaveLimitedItemTrackSpawner" then
		arg_13_4.template_name, arg_13_4.pool = Unit.get_data(arg_13_2, "template_name"), 1

		local on_add_extension_2 = LimitedItemTrackSystem.super.on_add_extension(self, arg_13_1, arg_13_2, "LimitedItemTrackSpawner", arg_13_4)

		on_add_extension_2.enable = self.enable_spawner
		on_add_extension_2.disable = self.disable_spawner
		self.spawners[arg_13_2] = on_add_extension_2

		local get_data_3 = Unit.get_data(arg_13_2, "weave_objective_id")
		local var_13_9 = self.queued_weave_group_spawners[get_data_3]

		var_13_9 = var_13_9 or {}
		var_13_9[#var_13_9 + 1] = on_add_extension_2
		self.queued_weave_group_spawners[get_data_3] = var_13_9
		arg_13_4.pool = nil
		arg_13_4.template_name = nil
		arg_13_4.network_manager = nil

		return on_add_extension_2
	else
		local tbl = {}
		local NAME = self.NAME

		ScriptUnit.set_extension(arg_13_2, NAME, tbl, tbl_3)

		if arg_13_3 == "LimitedItemExtension" then
			tbl.unit = arg_13_2

			local id = arg_13_4.id

			id = id or 0
			tbl.id = id
			tbl.spawner_unit = arg_13_4.spawner_unit
			tbl.mark_for_transformation = self.mark_item_for_transformation

			if not self.is_server then
				local var_13_13 = self.spawners[tbl.spawner_unit]

				if not var_13_13 then
					local var_13_14 = var_13_13.items[tbl.id]

					if not (not var_13_14 and type(var_13_14) == "boolean") then
						Crashify.print_exception("LimitedItemTrackSystem", "Added limited unit with occupied id")
					end

					if not var_13_13:is_transformed(tbl.id) then
						var_13_13.items[tbl.id] = arg_13_2
					end
				end
			end
		elseif arg_13_3 == "HeldLimitedItemExtension" then
			tbl.unit = arg_13_2

			local id_2 = arg_13_4.id

			id_2 = id_2 or 0
			tbl.id = id_2
			tbl.spawner_unit = arg_13_4.spawner_unit
		else
			fassert(false, "Unknown extension name %q", arg_13_3)
		end

		self.items[arg_13_2] = tbl
		arg_13_4.network_manager = nil

		return tbl
	end
end

LimitedItemTrackSystem.on_remove_extension = function (self, arg_14_1, arg_14_2)
	-- function 14
	if not (arg_14_2 == "LimitedItemTrackSpawner" or arg_14_2 ~= "WeaveLimitedItemTrackSpawner") then
		LimitedItemTrackSystem.super.on_remove_extension(self, arg_14_1, arg_14_2)
	elseif arg_14_2 == "LimitedItemExtension" then
		if not self.is_server then
			local var_14_0 = self.items[arg_14_1]
			local spawner_unit = var_14_0.spawner_unit
			local var_14_2 = self.spawners[spawner_unit]

			if not var_14_2 then
				local var_14_3 = self.marked_items[arg_14_1]

				if not var_14_3 then
					var_14_2:transform(var_14_3)
				else
					var_14_2:remove(var_14_0.id)
				end
			end
		end

		self.items[arg_14_1] = nil

		ScriptUnit.remove_extension(arg_14_1, self.NAME)
	elseif arg_14_2 == "HeldLimitedItemExtension" then
		local var_14_4 = self.items[arg_14_1]

		self.items[arg_14_1] = nil

		ScriptUnit.remove_extension(arg_14_1, self.NAME)
	end
end

LimitedItemTrackSystem.spawn_batch = function (arg_15_0, arg_15_1)
	-- function 15
	local spawners = arg_15_1.spawners
	local spawners_n = arg_15_1.spawners_n
	local tbl = {}
	local var_15_3 = spawners_n

	for i = 1, spawners_n do
		tbl[i] = i
	end

	local num = 0
	local pool_size = arg_15_1.pool_size

	for j = 1, pool_size do
		if var_15_3 == 0 then
			break
		end

		local random = math.random(1, var_15_3)
		local var_15_7 = tbl[random]

		table.remove(tbl, random)

		var_15_3 = var_15_3 - 1

		local var_15_8 = spawners[var_15_7]
		local num_items = var_15_8.num_items

		fassert(num_items == 0, "Sanity Check")
		var_15_8:spawn_item()
	end
end

LimitedItemTrackSystem.update = function (self, arg_16_1, arg_16_2)
	-- function 16
	local active_groups_n = self.active_groups_n

	if active_groups_n > 0 then
		local groups = self.groups
		local active_groups = self.active_groups

		for i = 1, active_groups_n do
			local var_16_3 = groups[active_groups[i]]
			local flag = true
			local spawners = var_16_3.spawners
			local spawners_n = var_16_3.spawners_n

			for j = 1, spawners_n do
				if spawners[j].num_items > 0 then
					flag = false
				end
			end

			if not flag then
				self:spawn_batch(var_16_3)
			end
		end
	end

	if not Debug.active then
		if #self.no_group_spawners > 0 then
			Debug.text("There are limited item spawners on this level without a group assigned to!!!!!")
		end

		if table.size(self.queued_group_spawners) > 0 then
			Debug.text("There are limited item spawners assigned to a group that hasn't been registered!!!!!")

			for k, v in pairs(self.queued_group_spawners) do
				Debug.text(k)
			end
		end
	end
end

LimitedItemTrackSystem.held_limited_item_destroyed = function (self, arg_17_1, arg_17_2)
	-- function 17
	assert(self.is_server)
	self.spawners[arg_17_1]:remove(arg_17_2)
end
