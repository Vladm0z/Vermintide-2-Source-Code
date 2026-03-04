-- chunkname: @scripts/unit_extensions/weaves/weave_limited_item_spawner_extension.lua

require("scripts/unit_extensions/limited_item_track/limited_item_track_spawner_templates")

WeaveLimitedItemSpawnerExtension = class(WeaveLimitedItemSpawnerExtension, BaseObjectiveExtension)
WeaveLimitedItemSpawnerExtension.NAME = "WeaveLimitedItemSpawnerExtension"

WeaveLimitedItemSpawnerExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	WeaveLimitedItemSpawnerExtension.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)

	arg_1_0._items_spawned = false
	arg_1_0._value = 0
	arg_1_0._from_spawner = true

	local var_1_0 = Unit.get_data(arg_1_2, "template_name")
	local var_1_1 = LimitedItemTrackSpawnerTemplates[var_1_0]

	if var_1_1 then
		Managers.state.entity:system("pickup_system"):disable_spawners(var_1_1.types or {})
	end
end

WeaveLimitedItemSpawnerExtension.extensions_ready = function (arg_2_0)
	return
end

WeaveLimitedItemSpawnerExtension.initial_sync_data = function (arg_3_0, arg_3_1)
	arg_3_1.value = arg_3_0._value
end

WeaveLimitedItemSpawnerExtension._set_objective_data = function (arg_4_0, arg_4_1)
	arg_4_0._on_first_pickup_func = arg_4_1.on_first_pickup_func
	arg_4_0._on_pickup_func = arg_4_1.on_pickup_func
	arg_4_0._on_throw_func = arg_4_1.on_throw_func
	arg_4_0._on_destroy_func = arg_4_1.on_destroy_func
	arg_4_0._on_spawn_func = arg_4_1.on_spawn_func
	arg_4_0._on_complete_func = arg_4_1.on_complete_func
	arg_4_0._objective_template_name = arg_4_1.template_name or Unit.get_data(arg_4_0._unit, "template_name")

	local var_4_0 = arg_4_0._objective_template_name == "gargoyle_head_spawner" and "magic_crystal" or "magic_barrel"

	Unit.set_data(arg_4_0._unit, "template_name", arg_4_0._objective_template_name)
	Unit.set_data(arg_4_0._unit, "pickup_name", var_4_0)
end

WeaveLimitedItemSpawnerExtension._activate = function (arg_5_0)
	local var_5_0 = Managers.state.entity:system("mission_system")
	local var_5_1 = var_5_0:get_missions()

	if not var_5_1 or not var_5_1.weave_collect_limited_item_objective then
		var_5_0:start_mission("weave_collect_limited_item_objective")
	end

	if arg_5_0._is_server then
		arg_5_0._limited_item_track_extension = ScriptUnit.extension(arg_5_0._unit, "limited_item_track_system")
		arg_5_0._limited_item_track_extension.template_name = arg_5_0._objective_template_name
	end

	Managers.state.entity:system("limited_item_track_system"):weave_activate_spawner(arg_5_0._unit, arg_5_0._objective_name)
end

WeaveLimitedItemSpawnerExtension.destroy = function (arg_6_0)
	return
end

WeaveLimitedItemSpawnerExtension._deactivate = function (arg_7_0)
	Managers.state.entity:system("limited_item_track_system"):deactivate_group(arg_7_0._objective_name)

	if arg_7_0._is_server then
		local var_7_0 = arg_7_0._limited_item_track_extension.items

		for iter_7_0, iter_7_1 in ipairs(var_7_0) do
			if type(iter_7_1) ~= "boolean" then
				Managers.state.unit_spawner:mark_for_deletion(iter_7_1)
			end
		end
	end
end

WeaveLimitedItemSpawnerExtension.get_percentage_done = function (arg_8_0)
	return arg_8_0._value / 1
end

WeaveLimitedItemSpawnerExtension._server_update = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0._limited_item_track_extension

	if var_9_0.num_socketed_items == var_9_0.pool then
		arg_9_0._value = 1

		Managers.state.entity:system("limited_item_track_system"):decrease_group_pool_size(arg_9_0._objective_name)
	end

	local var_9_1 = var_9_0:is_any_transformed()
	local var_9_2 = var_9_0:is_any_item_spawned()

	if not arg_9_0._interacting_with_spawned_item and var_9_1 then
		if arg_9_0._on_first_pickup_func then
			arg_9_0._on_first_pickup_func(arg_9_0._unit)

			arg_9_0._on_first_pickup_func = nil
		end

		if arg_9_0._on_pickup_func then
			arg_9_0._on_pickup_func(arg_9_0._unit, arg_9_0._from_spawner)
		end

		arg_9_0._interacting_with_spawned_item = true
		arg_9_0._from_spawner = false
	elseif arg_9_0._interacting_with_spawned_item and not var_9_1 then
		if var_9_2 and arg_9_0._on_throw_func then
			arg_9_0._on_throw_func(arg_9_0._unit)
		end

		arg_9_0._interacting_with_spawned_item = false
	end

	if not arg_9_0._items_spawned and var_9_2 then
		arg_9_0._from_spawner = true

		if arg_9_0._on_spawn_func then
			arg_9_0._on_spawn_func(arg_9_0._unit)
		end

		arg_9_0._items_spawned = true
	elseif arg_9_0._items_spawned and not var_9_2 then
		arg_9_0._from_spawner = false

		if arg_9_0._on_destroy_func then
			arg_9_0._on_destroy_func(arg_9_0._unit)
		end

		arg_9_0._items_spawned = false
	end

	arg_9_0:server_set_value(arg_9_0._value)
end

WeaveLimitedItemSpawnerExtension._client_update = function (arg_10_0, arg_10_1, arg_10_2)
	arg_10_0._value = arg_10_0:client_get_value()
end
