-- chunkname: @scripts/unit_extensions/weapons/actions/action_bow_energy.lua

ActionBowEnergy = class(ActionBowEnergy, ActionBow)

function ActionBowEnergy.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionBowEnergy.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0._energy_extension = ScriptUnit.extension(arg_1_4, "energy_system")
end

function ActionBowEnergy.fire(arg_2_0, arg_2_1, arg_2_2)
	ActionBowEnergy.super.fire(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0:_drain_energy()
end

function ActionBowEnergy._drain_energy(arg_3_0)
	local var_3_0 = arg_3_0.current_action.drain_amount

	if not arg_3_0.extra_buff_shot then
		arg_3_0._energy_extension:drain(var_3_0)
	end
end

function ActionBowEnergy.destroy(arg_4_0)
	return
end
