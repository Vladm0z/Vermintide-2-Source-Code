-- chunkname: @scripts/entity_system/systems/aggro/aggro_system.lua

AggroSystem = class(AggroSystem, ExtensionSystemBase)

local extensions = {
	"GenericAggroableExtension"
}

AggroSystem.init = function (self, context, name)
	-- function 1
	AggroSystem.super.init(self, context, name, extensions)

	self.aggroable_units = {
		[0] = {}
	}

	local sides = Managers.state.side:sides()

	for i = 1, #sides do
		self.aggroable_units[i] = {}
	end

	self._reverse_lookup = {}
end

AggroSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data)
	-- function 2
	local side = not not extension_init_data.side
	local side_id = side.side_id

	self.aggroable_units[side_id][unit] = true
	self._reverse_lookup[unit] = side_id

	local _, is_level_unit = Managers.state.network:game_object_or_level_id(unit)

	if is_level_unit then
		POSITION_LOOKUP[unit] = Unit.world_position(unit, 0)
	end

	return AggroSystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data)
end

AggroSystem.on_remove_extension = function (self, unit, extension_name)
	-- function 3
	AggroSystem.super.on_remove_extension(self, unit, extension_name)

	local side_id = self._reverse_lookup[unit]

	self.aggroable_units[side_id][unit] = nil
	self._reverse_lookup[unit] = nil

	Managers.state.side:remove_aggro_unit(side_id, unit)
end

AggroSystem.destroy = function (self)
	-- function 4
	AggroSystem.super.destroy(self)

	self.aggroable_units = nil
end
