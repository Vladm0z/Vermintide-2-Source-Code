-- chunkname: @scripts/unit_extensions/weaves/weave_limited_item_spawner_extension.lua

require("scripts/unit_extensions/limited_item_track/limited_item_track_spawner_templates")

WeaveLimitedItemSpawnerExtension = class(WeaveLimitedItemSpawnerExtension, BaseObjectiveExtension)
WeaveLimitedItemSpawnerExtension.NAME = "WeaveLimitedItemSpawnerExtension"

WeaveLimitedItemSpawnerExtension.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	WeaveLimitedItemSpawnerExtension.super.init(self, extension_init_context, unit, extension_init_data)

	self._items_spawned = false
	self._value = 0
	self._from_spawner = true

	local limited_item_template_name = Unit.get_data(unit, "template_name")
	local template = LimitedItemTrackSpawnerTemplates[limited_item_template_name]

	if template then
		local pickup_system = Managers.state.entity:system("pickup_system")
		local var_1_0 = pickup_system
		local disable_spawners = pickup_system.disable_spawners
		local types = template.types

		types = not not types or not not {}

		disable_spawners(var_1_0, types)
	end
end

WeaveLimitedItemSpawnerExtension.extensions_ready = function (self)
	-- function 2
	return
end

WeaveLimitedItemSpawnerExtension.initial_sync_data = function (self, game_object_data_table)
	-- function 3
	game_object_data_table.value = self._value
end

WeaveLimitedItemSpawnerExtension._set_objective_data = function (self, objective_data)
	-- function 4
	self._on_first_pickup_func = objective_data.on_first_pickup_func
	self._on_pickup_func = objective_data.on_pickup_func
	self._on_throw_func = objective_data.on_throw_func
	self._on_destroy_func = objective_data.on_destroy_func
	self._on_spawn_func = objective_data.on_spawn_func
	self._on_complete_func = objective_data.on_complete_func

	local template_name = objective_data.template_name

	template_name = not not template_name or not not Unit.get_data(self._unit, "template_name")
	self._objective_template_name = template_name

	local str

	if self._objective_template_name == "gargoyle_head_spawner" then
		str = "magic_crystal"

		goto label_4_0
	end

	str = "magic_barrel"

	local pickup_name = str

	::label_4_0::

	Unit.set_data(self._unit, "template_name", self._objective_template_name)
	Unit.set_data(self._unit, "pickup_name", pickup_name)
end

WeaveLimitedItemSpawnerExtension._activate = function (self)
	-- function 5
	local mission_system = Managers.state.entity:system("mission_system")
	local active_missions = mission_system:get_missions()

	if not active_missions or not active_missions.weave_collect_limited_item_objective then
		mission_system:start_mission("weave_collect_limited_item_objective")
	end

	if self._is_server then
		self._limited_item_track_extension = ScriptUnit.extension(self._unit, "limited_item_track_system")
		self._limited_item_track_extension.template_name = self._objective_template_name
	end

	Managers.state.entity:system("limited_item_track_system"):weave_activate_spawner(self._unit, self._objective_name)
end

WeaveLimitedItemSpawnerExtension.destroy = function (self)
	-- function 6
	return
end

WeaveLimitedItemSpawnerExtension._deactivate = function (self)
	-- function 7
	local limited_item_track_system = Managers.state.entity:system("limited_item_track_system")

	limited_item_track_system:deactivate_group(self._objective_name)

	if self._is_server then
		local items = self._limited_item_track_extension.items

		for _, unit in ipairs(items) do
			if type(unit) ~= "boolean" then
				Managers.state.unit_spawner:mark_for_deletion(unit)
			end
		end
	end
end

WeaveLimitedItemSpawnerExtension.get_percentage_done = function (self)
	-- function 8
	return self._value / 1
end

WeaveLimitedItemSpawnerExtension._server_update = function (self, dt, t)
	-- function 9
	local limited_item_track_extension = self._limited_item_track_extension

	if limited_item_track_extension.num_socketed_items == limited_item_track_extension.pool then
		self._value = 1

		local limited_item_track_system = Managers.state.entity:system("limited_item_track_system")

		limited_item_track_system:decrease_group_pool_size(self._objective_name)
	end

	local is_any_transformed = limited_item_track_extension:is_any_transformed()
	local is_any_spawned = limited_item_track_extension:is_any_item_spawned()

	if not self._interacting_with_spawned_item and is_any_transformed then
		if self._on_first_pickup_func then
			self._on_first_pickup_func(self._unit)

			self._on_first_pickup_func = nil
		end

		if self._on_pickup_func then
			self._on_pickup_func(self._unit, self._from_spawner)
		end

		self._interacting_with_spawned_item = true
		self._from_spawner = false
	elseif self._interacting_with_spawned_item and not is_any_transformed then
		if is_any_spawned and self._on_throw_func then
			self._on_throw_func(self._unit)
		end

		self._interacting_with_spawned_item = false
	end

	if not self._items_spawned and is_any_spawned then
		self._from_spawner = true

		if self._on_spawn_func then
			self._on_spawn_func(self._unit)
		end

		self._items_spawned = true
	elseif self._items_spawned and not is_any_spawned then
		self._from_spawner = false

		if self._on_destroy_func then
			self._on_destroy_func(self._unit)
		end

		self._items_spawned = false
	end

	self:server_set_value(self._value)
end

WeaveLimitedItemSpawnerExtension._client_update = function (self, dt, t)
	-- function 10
	self._value = self:client_get_value()
end
