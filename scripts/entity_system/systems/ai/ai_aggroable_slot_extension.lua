-- chunkname: @scripts/entity_system/systems/ai/ai_aggroable_slot_extension.lua

AIAggroableSlotExtension = class(AIAggroableSlotExtension, AIPlayerSlotExtension)

AIAggroableSlotExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local game_object_or_level_id, var_1_1 = Managers.state.network:game_object_or_level_id(arg_1_2)

	if not var_1_1 then
		POSITION_LOOKUP[arg_1_2] = Unit.world_position(arg_1_2, 0)
	end

	AIAggroableSlotExtension.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
end
