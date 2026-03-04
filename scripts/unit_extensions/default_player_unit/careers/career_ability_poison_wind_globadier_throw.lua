-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_poison_wind_globadier_throw.lua

CareerAbilityPoisonWindGlobadierThrow = class(CareerAbilityPoisonWindGlobadierThrow, CareerAbilityDarkPactBase)

function CareerAbilityPoisonWindGlobadierThrow.extensions_ready(arg_1_0, arg_1_1, arg_1_2)
	CareerAbilityPoisonWindGlobadierThrow.super.extensions_ready(arg_1_0, arg_1_1, arg_1_2)

	local var_1_0 = arg_1_0._ability_data

	arg_1_0._career_extension:setup_extra_ability_uses(0, var_1_0.cooldown, 0, var_1_0.max_stacks)
	arg_1_0._career_extension:modify_extra_ability_uses(var_1_0.starting_stack_count)
end

function CareerAbilityPoisonWindGlobadierThrow.ability_ready(arg_2_0)
	arg_2_0.super.ability_ready(arg_2_0)

	if not arg_2_0._status_extension:get_in_ghost_mode() then
		local var_2_0 = arg_2_0._unit
		local var_2_1 = ScriptUnit.extension(var_2_0, "inventory_system")

		Unit.flow_event(var_2_0, "reload_finished")
		CharacterStateHelper.show_inventory_3p(var_2_0, true, false, arg_2_0._is_server, var_2_1)
	end
end

function CareerAbilityPoisonWindGlobadierThrow.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	CareerAbilityPoisonWindGlobadierThrow.super.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_0._career_extension:modify_extra_ability_charge(arg_3_3)
end

function CareerAbilityPoisonWindGlobadierThrow.start_cooldown_anim(arg_4_0)
	local var_4_0 = arg_4_0._first_person_extension
	local var_4_1 = arg_4_0._unit

	if var_4_0 then
		CharacterStateHelper.play_animation_event(var_4_1, "reload_start")
		CharacterStateHelper.play_animation_event_first_person(var_4_0, "reload_start")
		Unit.flow_event(var_4_1, "reload_start")
		var_4_0:animation_set_variable("armed", 1)
		var_4_0:unhide_weapons("catapulted")
	end
end
