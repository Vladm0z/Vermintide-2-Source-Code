-- chunkname: @scripts/unit_extensions/default_player_unit/versus_horde_ability_husk_extension.lua

VersusHordeAbilityHuskExtension = class(VersusHordeAbilityHuskExtension)

function VersusHordeAbilityHuskExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._horde_ability_system = Managers.state.entity:system("versus_horde_ability_system")
	arg_1_0._unit = arg_1_2
	arg_1_0.game = Managers.state.network:game()
end

function VersusHordeAbilityHuskExtension.update(arg_2_0)
	return
end

function VersusHordeAbilityHuskExtension.set_ability_game_object_id(arg_3_0, arg_3_1)
	arg_3_0.ability_go_id = arg_3_1
end

function VersusHordeAbilityHuskExtension.get_ability_charge(arg_4_0)
	local var_4_0 = arg_4_0.game
	local var_4_1 = arg_4_0.ability_go_id

	if var_4_0 and var_4_1 then
		return (GameSession.game_object_field(var_4_0, var_4_1, "ability_charge"))
	end

	return 0
end
