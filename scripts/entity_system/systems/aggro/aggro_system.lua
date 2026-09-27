-- chunkname: @scripts/entity_system/systems/aggro/aggro_system.lua

AggroSystem = class(AggroSystem, ExtensionSystemBase)

local tbl = {
	"GenericAggroableExtension"
}

AggroSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	AggroSystem.super.init(self, arg_1_1, arg_1_2, tbl)

	self.aggroable_units = {
		[0] = {}
	}

	local sides = Managers.state.side:sides()

	for i = 1, #sides do
		self.aggroable_units[i] = {}
	end

	self._reverse_lookup = {}
end

AggroSystem.on_add_extension = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	local side = arg_2_4.side

	side = side or Managers.state.side:get_side_from_name("heroes")

	local side_id = side.side_id

	arg_2_0.aggroable_units[side_id][arg_2_2] = true
	arg_2_0._reverse_lookup[arg_2_2] = side_id

	local game_object_or_level_id, var_2_3 = Managers.state.network:game_object_or_level_id(arg_2_2)

	if not var_2_3 then
		POSITION_LOOKUP[arg_2_2] = Unit.world_position(arg_2_2, 0)
	end

	return AggroSystem.super.on_add_extension(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
end

AggroSystem.on_remove_extension = function (self, arg_3_1, arg_3_2)
	-- function 3
	AggroSystem.super.on_remove_extension(self, arg_3_1, arg_3_2)

	local var_3_0 = self._reverse_lookup[arg_3_1]

	self.aggroable_units[var_3_0][arg_3_1] = nil
	self._reverse_lookup[arg_3_1] = nil

	Managers.state.side:remove_aggro_unit(var_3_0, arg_3_1)
end

AggroSystem.destroy = function (self)
	-- function 4
	AggroSystem.super.destroy(self)

	self.aggroable_units = nil
end
