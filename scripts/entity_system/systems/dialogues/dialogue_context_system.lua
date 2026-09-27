-- chunkname: @scripts/entity_system/systems/dialogues/dialogue_context_system.lua

local tbl = {
	"GenericDialogueContextExtension"
}

DialogueContextSystem = class(DialogueContextSystem, ExtensionSystemBase)

DialogueContextSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	arg_1_1.entity_manager:register_system(self, arg_1_2, tbl)

	self._next_player_key = nil
	self._unit_extension_data = {}

	GarbageLeakDetector.register_object(self, "dialogue_context_system")
end

DialogueContextSystem.destroy = function (self)
	-- function 2
	self._unit_extension_data = nil
end

DialogueContextSystem.on_add_extension = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local context = ScriptUnit.extension(arg_3_2, "dialogue_system").context

	fassert(arg_3_4.profile, "Missing profile!")

	context.player_profile = arg_3_4.profile.character_vo

	local tbl = {
		context = context
	}

	ScriptUnit.set_extension(arg_3_2, "dialogue_context_system", tbl, {})

	arg_3_0._unit_extension_data[arg_3_2] = tbl

	return tbl
end

DialogueContextSystem.on_remove_extension = function (self, arg_4_1, arg_4_2)
	-- function 4
	self._unit_extension_data[arg_4_1] = nil

	ScriptUnit.remove_extension(arg_4_1, self.NAME)
end

DialogueContextSystem.extensions_ready = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local extension = ScriptUnit.extension(arg_5_2, "health_system")
	local extension_2 = ScriptUnit.extension(arg_5_2, "status_system")
	local extension_3 = ScriptUnit.extension(arg_5_2, "proximity_system")
	local var_5_3 = self._unit_extension_data[arg_5_2]

	var_5_3.health_extension = extension
	var_5_3.status_extension = extension_2
	var_5_3.proximity_extension = extension_3
end

DialogueContextSystem.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not (not self._next_player_key and Unit.alive(self._next_player_key)) then
		self._next_player_key = nil
	end

	local var_6_0, var_6_1 = next(self._unit_extension_data, self._next_player_key)

	self._next_player_key = var_6_0

	if not var_6_0 then
		return
	end

	local context = var_6_1.context

	context.health = var_6_1.health_extension:current_health_percent()

	local status_extension = var_6_1.status_extension

	context.is_pounced_down = not not status_extension:is_pounced_down()
	context.is_knocked_down = not not status_extension:is_knocked_down()
	context.intensity = status_extension:get_pacing_intensity()
	context.pacing_state = Managers.state.conflict.pacing.pacing_state

	local proximity_types = var_6_1.proximity_extension.proximity_types

	context.friends_close = proximity_types.friends_close.num
	context.friends_distant = proximity_types.friends_distant.num
	context.enemies_close = proximity_types.enemies_close.num
	context.enemies_distant = proximity_types.enemies_distant.num
end

DialogueContextSystem.hot_join_sync = function (arg_7_0, arg_7_1)
	-- function 7
	return
end

DialogueContextSystem.set_context_value = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	arg_8_0._unit_extension_data[arg_8_1].context[arg_8_2] = arg_8_3
end
