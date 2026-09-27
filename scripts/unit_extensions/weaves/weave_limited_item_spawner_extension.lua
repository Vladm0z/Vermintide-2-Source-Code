-- chunkname: @scripts/unit_extensions/weaves/weave_limited_item_spawner_extension.lua

require("scripts/unit_extensions/limited_item_track/limited_item_track_spawner_templates")

WeaveLimitedItemSpawnerExtension = class(WeaveLimitedItemSpawnerExtension, BaseObjectiveExtension)
WeaveLimitedItemSpawnerExtension.NAME = "WeaveLimitedItemSpawnerExtension"

WeaveLimitedItemSpawnerExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	WeaveLimitedItemSpawnerExtension.super.init(self, arg_1_1, arg_1_2, arg_1_3)

	self._items_spawned = false
	self._value = 0
	self._from_spawner = true

	local get_data = Unit.get_data(arg_1_2, "template_name")
	local var_1_1 = LimitedItemTrackSpawnerTemplates[get_data]

	if not var_1_1 then
		local system = Managers.state.entity:system("pickup_system")
		local var_1_3 = system
		local disable_spawners = system.disable_spawners
		local types = var_1_1.types

		types = types or {}

		disable_spawners(var_1_3, types)
	end
end

WeaveLimitedItemSpawnerExtension.extensions_ready = function (arg_2_0)
	-- function 2
	return
end

WeaveLimitedItemSpawnerExtension.initial_sync_data = function (self, arg_3_1)
	-- function 3
	arg_3_1.value = self._value
end

WeaveLimitedItemSpawnerExtension._set_objective_data = function (self, arg_4_1)
	-- function 4
	self._on_first_pickup_func = arg_4_1.on_first_pickup_func
	self._on_pickup_func = arg_4_1.on_pickup_func
	self._on_throw_func = arg_4_1.on_throw_func
	self._on_destroy_func = arg_4_1.on_destroy_func
	self._on_spawn_func = arg_4_1.on_spawn_func
	self._on_complete_func = arg_4_1.on_complete_func

	local template_name = arg_4_1.template_name

	template_name = template_name or Unit.get_data(self._unit, "template_name")
	self._objective_template_name = template_name

	local flag

	flag = self._objective_template_name ~= "gargoyle_head_spawner" or not "magic_crystal" or "magic_barrel"

	Unit.set_data(self._unit, "template_name", self._objective_template_name)
	Unit.set_data(self._unit, "pickup_name", flag)
end

WeaveLimitedItemSpawnerExtension._activate = function (self)
	-- function 5
	local system = Managers.state.entity:system("mission_system")
	local get_missions = system:get_missions()

	if not (not get_missions and get_missions.weave_collect_limited_item_objective) then
		system:start_mission("weave_collect_limited_item_objective")
	end

	if not self._is_server then
		self._limited_item_track_extension = ScriptUnit.extension(self._unit, "limited_item_track_system")
		self._limited_item_track_extension.template_name = self._objective_template_name
	end

	Managers.state.entity:system("limited_item_track_system"):weave_activate_spawner(self._unit, self._objective_name)
end

WeaveLimitedItemSpawnerExtension.destroy = function (arg_6_0)
	-- function 6
	return
end

WeaveLimitedItemSpawnerExtension._deactivate = function (self)
	-- function 7
	Managers.state.entity:system("limited_item_track_system"):deactivate_group(self._objective_name)

	if not self._is_server then
		local items = self._limited_item_track_extension.items

		for i, v in ipairs(items) do
			if type(v) ~= "boolean" then
				Managers.state.unit_spawner:mark_for_deletion(v)
			end
		end
	end
end

WeaveLimitedItemSpawnerExtension.get_percentage_done = function (self)
	-- function 8
	return self._value / 1
end

WeaveLimitedItemSpawnerExtension._server_update = function (self, arg_9_1, arg_9_2)
	-- function 9
	local _limited_item_track_extension = self._limited_item_track_extension

	if _limited_item_track_extension.num_socketed_items == _limited_item_track_extension.pool then
		self._value = 1

		Managers.state.entity:system("limited_item_track_system"):decrease_group_pool_size(self._objective_name)
	end

	local is_any_transformed = _limited_item_track_extension:is_any_transformed()
	local is_any_item_spawned = _limited_item_track_extension:is_any_item_spawned()

	if self._interacting_with_spawned_item or not is_any_transformed then
		if not self._on_first_pickup_func then
			self._on_first_pickup_func(self._unit)

			self._on_first_pickup_func = nil
		end

		if not self._on_pickup_func then
			self._on_pickup_func(self._unit, self._from_spawner)
		end

		self._interacting_with_spawned_item = true
		self._from_spawner = false
	elseif not (not self._interacting_with_spawned_item and is_any_transformed) then
		if not is_any_item_spawned and not self._on_throw_func then
			self._on_throw_func(self._unit)
		end

		self._interacting_with_spawned_item = false
	end

	if self._items_spawned or not is_any_item_spawned then
		self._from_spawner = true

		if not self._on_spawn_func then
			self._on_spawn_func(self._unit)
		end

		self._items_spawned = true
	elseif not (not self._items_spawned and is_any_item_spawned) then
		self._from_spawner = false

		if not self._on_destroy_func then
			self._on_destroy_func(self._unit)
		end

		self._items_spawned = false
	end

	self:server_set_value(self._value)
end

WeaveLimitedItemSpawnerExtension._client_update = function (self, arg_10_1, arg_10_2)
	-- function 10
	self._value = self:client_get_value()
end
