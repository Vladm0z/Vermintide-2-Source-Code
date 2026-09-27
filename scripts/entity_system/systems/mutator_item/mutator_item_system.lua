-- chunkname: @scripts/entity_system/systems/mutator_item/mutator_item_system.lua

require("scripts/unit_extensions/mutator_items/mutator_item_spawner_extension")

MutatorItemSystem = class(MutatorItemSystem, ExtensionSystemBase)

local tbl = {}
local tbl_2 = {
	"MutatorItemSpawnerExtension"
}

MutatorItemSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	MutatorItemSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))

	self._spawners = {}
	self._spawners_by_name = {}
end

MutatorItemSystem.on_add_extension = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, ...)
	-- function 2
	if arg_2_3 == "MutatorItemSpawnerExtension" then
		local _spawners = self._spawners

		_spawners[#_spawners + 1] = arg_2_2

		local get_data = Unit.get_data(arg_2_2, "mutator_item_spawner_id")

		self._spawners_by_name[get_data] = arg_2_2
	end

	return MutatorItemSystem.super.on_add_extension(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, ...)
end

local tbl_3 = {}

MutatorItemSystem.spawn_mutator_items = function (self, arg_3_1)
	-- function 3
	local _spawners = self._spawners
	local _spawners_by_name = self._spawners_by_name

	table.clear(tbl_3)

	if not arg_3_1 then
		return
	end

	for k, v in pairs(arg_3_1) do
		local var_3_2 = _spawners_by_name[k]

		if not var_3_2 then
			local unit_name = v.unit_name
			local unit_extension_template = v.unit_extension_template
			local extension_init_data = v.extension_init_data
			local local_position = Unit.local_position(var_3_2, 0)
			local local_rotation = Unit.local_rotation(var_3_2, 0)
			local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_extension_template, extension_init_data, local_position, local_rotation)

			tbl_3[#tbl_3 + 1] = spawn_network_unit
		end
	end

	return tbl_3
end

MutatorItemSystem.on_remove_extension = function (arg_4_0, arg_4_1, arg_4_2, ...)
	-- function 4
	return MutatorItemSystem.super.on_remove_extension(arg_4_0, arg_4_1, arg_4_2, ...)
end

MutatorItemSystem.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not self.is_server then
		-- Nothing
	end
end

MutatorItemSystem.destroy = function (self)
	-- function 6
	self.network_event_delegate:unregister(self)
end

MutatorItemSystem.hot_join_sync = function (arg_7_0, arg_7_1)
	-- function 7
	return
end
