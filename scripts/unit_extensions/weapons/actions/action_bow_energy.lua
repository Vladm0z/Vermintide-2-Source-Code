-- chunkname: @scripts/unit_extensions/weapons/actions/action_bow_energy.lua

ActionBowEnergy = class(ActionBowEnergy, ActionBow)

ActionBowEnergy.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionBowEnergy.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self._energy_extension = ScriptUnit.extension(arg_1_4, "energy_system")
end

ActionBowEnergy.fire = function (self, arg_2_1, arg_2_2)
	-- function 2
	ActionBowEnergy.super.fire(self, arg_2_1, arg_2_2)
	self:_drain_energy()
end

ActionBowEnergy._drain_energy = function (self)
	-- function 3
	local drain_amount = self.current_action.drain_amount

	if not self.extra_buff_shot then
		self._energy_extension:drain(drain_amount)
	end
end

ActionBowEnergy.destroy = function (arg_4_0)
	-- function 4
	return
end
