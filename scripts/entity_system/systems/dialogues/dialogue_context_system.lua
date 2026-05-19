-- chunkname: @scripts/entity_system/systems/dialogues/dialogue_context_system.lua

local var_0_0 = {
	"GenericDialogueContextExtension"
}

DialogueContextSystem = class(DialogueContextSystem, ExtensionSystemBase)

function DialogueContextSystem.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_1.entity_manager:register_system(arg_1_0, arg_1_2, var_0_0)

	arg_1_0._next_player_key = nil
	arg_1_0._unit_extension_data = {}

	GarbageLeakDetector.register_object(arg_1_0, "dialogue_context_system")
end

function DialogueContextSystem.destroy(arg_2_0)
	arg_2_0._unit_extension_data = nil
end

function DialogueContextSystem.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = ScriptUnit.extension(arg_3_2, "dialogue_system").context

	fassert(arg_3_4.profile, "Missing profile!")

	var_3_0.player_profile = arg_3_4.profile.character_vo

	local var_3_1 = {
		context = var_3_0
	}

	ScriptUnit.set_extension(arg_3_2, "dialogue_context_system", var_3_1, {})

	arg_3_0._unit_extension_data[arg_3_2] = var_3_1

	return var_3_1
end

function DialogueContextSystem.on_remove_extension(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0._unit_extension_data[arg_4_1] = nil

	ScriptUnit.remove_extension(arg_4_1, arg_4_0.NAME)
end

function DialogueContextSystem.extensions_ready(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = ScriptUnit.extension(arg_5_2, "health_system")
	local var_5_1 = ScriptUnit.extension(arg_5_2, "status_system")
	local var_5_2 = ScriptUnit.extension(arg_5_2, "proximity_system")
	local var_5_3 = arg_5_0._unit_extension_data[arg_5_2]

	var_5_3.health_extension = var_5_0
	var_5_3.status_extension = var_5_1
	var_5_3.proximity_extension = var_5_2
end

function DialogueContextSystem.update(arg_6_0, arg_6_1, arg_6_2)
	if arg_6_0._next_player_key and not Unit.alive(arg_6_0._next_player_key) then
		arg_6_0._next_player_key = nil
	end

	local var_6_0, var_6_1 = next(arg_6_0._unit_extension_data, arg_6_0._next_player_key)

	arg_6_0._next_player_key = var_6_0

	if not var_6_0 then
		return
	end

	local var_6_2 = var_6_1.context

	var_6_2.health = var_6_1.health_extension:current_health_percent()

	local var_6_3 = var_6_1.status_extension

	var_6_2.is_pounced_down = not not var_6_3:is_pounced_down()
	var_6_2.is_knocked_down = not not var_6_3:is_knocked_down()
	var_6_2.intensity = var_6_3:get_pacing_intensity()
	var_6_2.pacing_state = Managers.state.conflict.pacing.pacing_state

	local var_6_4 = var_6_1.proximity_extension.proximity_types

	var_6_2.friends_close = var_6_4.friends_close.num
	var_6_2.friends_distant = var_6_4.friends_distant.num
	var_6_2.enemies_close = var_6_4.enemies_close.num
	var_6_2.enemies_distant = var_6_4.enemies_distant.num
end

function DialogueContextSystem.hot_join_sync(arg_7_0, arg_7_1)
	return
end

function DialogueContextSystem.set_context_value(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	arg_8_0._unit_extension_data[arg_8_1].context[arg_8_2] = arg_8_3
end
