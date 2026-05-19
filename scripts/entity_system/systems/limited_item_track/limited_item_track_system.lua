-- chunkname: @scripts/entity_system/systems/limited_item_track/limited_item_track_system.lua

require("scripts/unit_extensions/limited_item_track/limited_item_track_spawner")

LimitedItemTrackSystem = class(LimitedItemTrackSystem, ExtensionSystemBase)

local var_0_0 = {}
local var_0_1 = {
	"LimitedItemTrackSpawner",
	"HeldLimitedItemExtension",
	"LimitedItemExtension",
	"WeaveLimitedItemTrackSpawner"
}

function LimitedItemTrackSystem.init(arg_1_0, arg_1_1, arg_1_2)
	LimitedItemTrackSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	local var_1_0 = arg_1_1.network_event_delegate

	var_1_0:register(arg_1_0, unpack(var_0_0))

	arg_1_0.network_event_delegate = var_1_0
	arg_1_0.network_manager = Managers.state.network
	arg_1_0.spawners = {}
	arg_1_0.active_spawners = {}
	arg_1_0.active_spawners_n = 0
	arg_1_0.items = {}
	arg_1_0.groups = {}
	arg_1_0.active_groups = {}
	arg_1_0.active_groups_n = 0
	arg_1_0.queued_group_spawners = {}
	arg_1_0.queued_weave_group_spawners = {}
	arg_1_0.no_group_spawners = {}
	arg_1_0.marked_items = {}

	function arg_1_0.mark_item_for_transformation(arg_2_0)
		local var_2_0 = arg_2_0.unit

		arg_1_0.marked_items[var_2_0] = arg_2_0.id > 0 and arg_2_0.id or nil
	end

	function arg_1_0.enable_spawner(arg_3_0)
		local var_3_0 = arg_3_0.unit
		local var_3_1 = arg_1_0.active_spawners_n + 1
		local var_3_2 = arg_1_0.spawners

		fassert(var_3_2[var_3_0], "Tried enabling spawner that does not exist %q", tostring(var_3_0))

		arg_1_0.active_spawners[var_3_1] = var_3_0
		arg_1_0.active_spawners_n = var_3_1
	end

	function arg_1_0.disable_spawner(arg_4_0)
		local var_4_0 = arg_4_0.unit
		local var_4_1 = arg_1_0:find_active_spawner_id(var_4_0)

		if var_4_1 == nil then
			return
		end

		table.remove(arg_1_0.active_spawners, var_4_1)

		arg_1_0.active_spawners_n = arg_1_0.active_spawners_n - 1
	end
end

function LimitedItemTrackSystem.register_group(arg_5_0, arg_5_1, arg_5_2)
	fassert(arg_5_0.groups[arg_5_1] == nil, "Limited Item Group with name %q, is already registered", arg_5_1)

	local var_5_0 = arg_5_0.queued_group_spawners[arg_5_1] or {}
	local var_5_1 = #var_5_0

	arg_5_0.queued_group_spawners[arg_5_1] = nil
	arg_5_0.groups[arg_5_1] = {
		spawners = var_5_0,
		spawners_n = var_5_1,
		pool_size = arg_5_2
	}
end

function LimitedItemTrackSystem.register_weave_group(arg_6_0, arg_6_1, arg_6_2)
	fassert(arg_6_0.groups[arg_6_1] == nil, "Limited Item Group with name %q, is already registered", arg_6_1)

	local var_6_0 = arg_6_0.queued_weave_group_spawners[arg_6_1] or {}
	local var_6_1 = #var_6_0

	arg_6_0.queued_weave_group_spawners[arg_6_1] = nil
	arg_6_0.groups[arg_6_1] = {
		spawners = var_6_0,
		spawners_n = var_6_1,
		pool_size = arg_6_2
	}
end

function LimitedItemTrackSystem.decrease_group_pool_size(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.groups[arg_7_1]
	local var_7_1 = math.max(var_7_0.pool_size - 1, 0)

	var_7_0.pool_size = var_7_1

	if var_7_1 == 0 then
		arg_7_0:deactivate_group(arg_7_1)
	end
end

function LimitedItemTrackSystem.activate_group(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0.active_groups
	local var_8_1 = arg_8_0.active_groups_n

	for iter_8_0 = 1, var_8_1 do
		if var_8_0[iter_8_0] == arg_8_1 then
			Application.warning(string.format("Limited Item Group %q is already active", arg_8_1))

			return
		end
	end

	arg_8_0.active_groups_n = var_8_1 + 1
	var_8_0[arg_8_0.active_groups_n] = arg_8_1
	arg_8_0.groups[arg_8_1].pool_size = arg_8_2
end

function LimitedItemTrackSystem.weave_activate_spawner(arg_9_0, arg_9_1, arg_9_2)
	if not arg_9_0.groups[arg_9_2] then
		arg_9_0:register_weave_group(arg_9_2, 0)
	end

	local var_9_0 = arg_9_0.active_groups
	local var_9_1 = arg_9_0.active_groups_n
	local var_9_2 = var_9_1 + 1

	for iter_9_0 = 1, var_9_1 do
		if var_9_0[iter_9_0] == arg_9_2 then
			var_9_2 = iter_9_0

			break
		end
	end

	var_9_0[var_9_2] = arg_9_2
	arg_9_0.groups[arg_9_2].pool_size = arg_9_0.groups[arg_9_2].pool_size + 1
	arg_9_0.active_groups_n = #var_9_0
end

function LimitedItemTrackSystem.deactivate_group(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.active_groups
	local var_10_1 = arg_10_0.active_groups_n

	for iter_10_0 = 1, var_10_1 do
		if var_10_0[iter_10_0] == arg_10_1 then
			table.remove(var_10_0, iter_10_0)

			arg_10_0.active_groups_n = var_10_1 - 1

			break
		end
	end
end

function LimitedItemTrackSystem.find_active_spawner_id(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0.active_spawners
	local var_11_1 = arg_11_0.active_spawners_n

	for iter_11_0 = 1, var_11_1 do
		if arg_11_1 == var_11_0[iter_11_0] then
			return iter_11_0
		end
	end

	return nil
end

function LimitedItemTrackSystem.destroy(arg_12_0)
	arg_12_0.network_event_delegate:unregister(arg_12_0)

	arg_12_0.network_event_delegate = nil
	arg_12_0.network_manager = nil
end

local var_0_2 = {}
local var_0_3 = {}

function LimitedItemTrackSystem.on_add_extension(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	arg_13_4 = next(arg_13_4) == nil and var_0_3 or arg_13_4
	arg_13_4.network_manager = arg_13_0.network_manager

	if arg_13_3 == "LimitedItemTrackSpawner" then
		local var_13_0 = Unit.get_data(arg_13_2, "pool")

		arg_13_4.template_name, arg_13_4.pool = Unit.get_data(arg_13_2, "template_name"), 1

		local var_13_1 = LimitedItemTrackSystem.super.on_add_extension(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)

		var_13_1.enable = arg_13_0.enable_spawner
		var_13_1.disable = arg_13_0.disable_spawner
		arg_13_0.spawners[arg_13_2] = var_13_1

		local var_13_2 = Unit.get_data(arg_13_2, "group_name")

		if var_13_2 ~= "" then
			local var_13_3 = arg_13_0.groups[var_13_2]

			if var_13_3 == nil then
				local var_13_4 = arg_13_0.queued_group_spawners[var_13_2] or {}

				var_13_4[#var_13_4 + 1] = var_13_1
				arg_13_0.queued_group_spawners[var_13_2] = var_13_4
			else
				local var_13_5 = var_13_3.spawners
				local var_13_6 = var_13_3.spawners_n + 1

				var_13_5[var_13_6] = var_13_1
				var_13_3.spawners_n = var_13_6
			end
		else
			arg_13_0.no_group_spawners[#arg_13_0.no_group_spawners + 1] = var_13_1
		end

		arg_13_4.pool = nil
		arg_13_4.template_name = nil
		arg_13_4.network_manager = nil

		return var_13_1
	elseif arg_13_3 == "WeaveLimitedItemTrackSpawner" then
		arg_13_4.template_name, arg_13_4.pool = Unit.get_data(arg_13_2, "template_name"), 1

		local var_13_7 = LimitedItemTrackSystem.super.on_add_extension(arg_13_0, arg_13_1, arg_13_2, "LimitedItemTrackSpawner", arg_13_4)

		var_13_7.enable = arg_13_0.enable_spawner
		var_13_7.disable = arg_13_0.disable_spawner
		arg_13_0.spawners[arg_13_2] = var_13_7

		local var_13_8 = Unit.get_data(arg_13_2, "weave_objective_id")
		local var_13_9 = arg_13_0.queued_weave_group_spawners[var_13_8] or {}

		var_13_9[#var_13_9 + 1] = var_13_7
		arg_13_0.queued_weave_group_spawners[var_13_8] = var_13_9
		arg_13_4.pool = nil
		arg_13_4.template_name = nil
		arg_13_4.network_manager = nil

		return var_13_7
	else
		local var_13_10 = {}
		local var_13_11 = arg_13_0.NAME

		ScriptUnit.set_extension(arg_13_2, var_13_11, var_13_10, var_0_2)

		if arg_13_3 == "LimitedItemExtension" then
			var_13_10.unit = arg_13_2
			var_13_10.id = arg_13_4.id or 0
			var_13_10.spawner_unit = arg_13_4.spawner_unit
			var_13_10.mark_for_transformation = arg_13_0.mark_item_for_transformation

			if arg_13_0.is_server then
				local var_13_12 = arg_13_0.spawners[var_13_10.spawner_unit]

				if var_13_12 then
					local var_13_13 = var_13_12.items[var_13_10.id]

					if var_13_13 and type(var_13_13) ~= "boolean" then
						Crashify.print_exception("LimitedItemTrackSystem", "Added limited unit with occupied id")
					end

					if var_13_12:is_transformed(var_13_10.id) then
						var_13_12.items[var_13_10.id] = arg_13_2
					end
				end
			end
		elseif arg_13_3 == "HeldLimitedItemExtension" then
			var_13_10.unit = arg_13_2
			var_13_10.id = arg_13_4.id or 0
			var_13_10.spawner_unit = arg_13_4.spawner_unit
		else
			fassert(false, "Unknown extension name %q", arg_13_3)
		end

		arg_13_0.items[arg_13_2] = var_13_10
		arg_13_4.network_manager = nil

		return var_13_10
	end
end

function LimitedItemTrackSystem.on_remove_extension(arg_14_0, arg_14_1, arg_14_2)
	if arg_14_2 == "LimitedItemTrackSpawner" or arg_14_2 == "WeaveLimitedItemTrackSpawner" then
		LimitedItemTrackSystem.super.on_remove_extension(arg_14_0, arg_14_1, arg_14_2)
	elseif arg_14_2 == "LimitedItemExtension" then
		if arg_14_0.is_server then
			local var_14_0 = arg_14_0.items[arg_14_1]
			local var_14_1 = var_14_0.spawner_unit
			local var_14_2 = arg_14_0.spawners[var_14_1]

			if var_14_2 then
				local var_14_3 = arg_14_0.marked_items[arg_14_1]

				if var_14_3 then
					var_14_2:transform(var_14_3)
				else
					var_14_2:remove(var_14_0.id)
				end
			end
		end

		arg_14_0.items[arg_14_1] = nil

		ScriptUnit.remove_extension(arg_14_1, arg_14_0.NAME)
	elseif arg_14_2 == "HeldLimitedItemExtension" then
		local var_14_4 = arg_14_0.items[arg_14_1]

		arg_14_0.items[arg_14_1] = nil

		ScriptUnit.remove_extension(arg_14_1, arg_14_0.NAME)
	end
end

function LimitedItemTrackSystem.spawn_batch(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_1.spawners
	local var_15_1 = arg_15_1.spawners_n
	local var_15_2 = {}
	local var_15_3 = var_15_1

	for iter_15_0 = 1, var_15_1 do
		var_15_2[iter_15_0] = iter_15_0
	end

	local var_15_4 = 0
	local var_15_5 = arg_15_1.pool_size

	for iter_15_1 = 1, var_15_5 do
		if var_15_3 == 0 then
			break
		end

		local var_15_6 = math.random(1, var_15_3)
		local var_15_7 = var_15_2[var_15_6]

		table.remove(var_15_2, var_15_6)

		var_15_3 = var_15_3 - 1

		local var_15_8 = var_15_0[var_15_7]
		local var_15_9 = var_15_8.num_items

		fassert(var_15_9 == 0, "Sanity Check")
		var_15_8:spawn_item()
	end
end

function LimitedItemTrackSystem.update(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0.active_groups_n

	if var_16_0 > 0 then
		local var_16_1 = arg_16_0.groups
		local var_16_2 = arg_16_0.active_groups

		for iter_16_0 = 1, var_16_0 do
			local var_16_3 = var_16_1[var_16_2[iter_16_0]]
			local var_16_4 = true
			local var_16_5 = var_16_3.spawners
			local var_16_6 = var_16_3.spawners_n

			for iter_16_1 = 1, var_16_6 do
				if var_16_5[iter_16_1].num_items > 0 then
					var_16_4 = false
				end
			end

			if var_16_4 then
				arg_16_0:spawn_batch(var_16_3)
			end
		end
	end

	if Debug.active then
		if #arg_16_0.no_group_spawners > 0 then
			Debug.text("There are limited item spawners on this level without a group assigned to!!!!!")
		end

		if table.size(arg_16_0.queued_group_spawners) > 0 then
			Debug.text("There are limited item spawners assigned to a group that hasn't been registered!!!!!")

			for iter_16_2, iter_16_3 in pairs(arg_16_0.queued_group_spawners) do
				Debug.text(iter_16_2)
			end
		end
	end
end

function LimitedItemTrackSystem.held_limited_item_destroyed(arg_17_0, arg_17_1, arg_17_2)
	assert(arg_17_0.is_server)
	arg_17_0.spawners[arg_17_1]:remove(arg_17_2)
end
