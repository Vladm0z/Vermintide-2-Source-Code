-- chunkname: @scripts/entity_system/systems/ai/ai_enemy_slot_extension.lua

AIEnemySlotExtension = class(AIEnemySlotExtension)

local var_0_0 = SlotTemplates
local var_0_1 = SlotTypeSettings
local var_0_2 = Vector3.distance_squared
local var_0_3 = Vector3.distance
local var_0_4 = Vector3.dot
local var_0_5 = "normal"
local var_0_6 = 1

function AIEnemySlotExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.unit = arg_1_2
	arg_1_0.target = nil
	arg_1_0.target_position = Vector3Box()
	arg_1_0.improve_wait_slot_position_t = 0
	arg_1_0._debug_id = var_0_6
	var_0_6 = var_0_6 + 1
	arg_1_0.belongs_to_ai = true
	arg_1_0.gathering = Managers.state.conflict.gathering
end

function AIEnemySlotExtension.extensions_ready(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = BLACKBOARDS[arg_2_2].breed

	arg_2_0.breed = var_2_0

	local var_2_1 = var_2_0.slot_template
	local var_2_2 = Managers.state.difficulty:get_difficulty_value_from_table(var_0_0)[var_2_1]

	fassert(var_2_1, "Breed " .. var_2_0.name .. " that uses slot system does not have a slot_template set in its breed.")
	fassert(var_2_2, "Breed " .. var_2_0.name .. " that uses slot system does not have a slot_template setup in SlotTemplates.")

	arg_2_0.slot_template = var_2_2
	arg_2_0.slot_type_settings = var_0_1[var_2_2.slot_type]
	arg_2_0.use_slot_type = var_2_2.slot_type
	arg_2_0._navigation_ext = ScriptUnit.extension(arg_2_2, "ai_navigation_system")
end

function AIEnemySlotExtension.cleanup_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_0:_detach_from_slot()
	arg_3_0:_detach_from_ai_slot("cleanup_extension")

	for iter_3_0 = 1, arg_3_3 do
		if arg_3_2[iter_3_0] == arg_3_1 then
			arg_3_2[iter_3_0] = arg_3_2[arg_3_3]
			arg_3_2[arg_3_3] = nil

			break
		end
	end
end

function AIEnemySlotExtension._improve_slot_position(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if not ALIVE[arg_4_1] then
		return
	end

	local var_4_0, var_4_1 = arg_4_0:get_current_slot()

	if not var_4_0 then
		return
	end

	if var_4_1 then
		if arg_4_2 > arg_4_0.improve_wait_slot_position_t then
			arg_4_0.improve_wait_slot_position_t = arg_4_2 + Math.random() * 0.4
		else
			return
		end
	end

	local var_4_2
	local var_4_3 = var_4_0.owner_extension

	if var_4_3 then
		var_4_2 = var_4_3:get_destination(arg_4_0, var_4_0, var_4_1, arg_4_3, arg_4_2)
	end

	if not var_4_2 then
		return
	end

	local var_4_4 = Unit.local_position(arg_4_1, 0)

	if var_4_1 then
		arg_4_0.wait_slot_distance = var_0_3(var_4_2, var_4_4) or math.huge
	end

	local var_4_5 = arg_4_0._navigation_ext
	local var_4_6 = var_4_5:destination()

	if var_0_2(var_4_4, var_4_2) > 1 or var_0_4(var_4_2 - var_4_4, var_4_6 - var_4_4) < 0 then
		var_4_5:move_to(var_4_2)
	end
end

function AIEnemySlotExtension._improve_ai_slot_position(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = Unit.local_position(arg_5_1, 0)
	local var_5_1

	if USE_ENGINE_SLOID_SYSTEM then
		if not arg_5_0.sloid_id then
			return
		end

		local var_5_2 = EngineOptimized.get_sloid_position(arg_5_0.sloid_id)

		var_5_1 = Vector3(var_5_2[1], var_5_2[2], var_5_2[3])
	else
		local var_5_3 = arg_5_0.gathering_ball

		if not var_5_3 then
			return
		end

		local var_5_4 = var_5_3.pos

		var_5_1 = Vector3(var_5_4[1], var_5_4[2], var_5_4[3])
	end

	local var_5_5 = arg_5_0._navigation_ext
	local var_5_6 = var_5_5:destination()

	if var_0_2(var_5_0, var_5_1) > 1 or var_0_4(var_5_1 - var_5_0, var_5_6 - var_5_0) < 0 then
		var_5_5:move_to(var_5_1)
	end
end

function AIEnemySlotExtension.freeze(arg_6_0, arg_6_1)
	arg_6_0:_detach_from_slot()
	arg_6_0:_detach_from_ai_slot("freeze")
end

function AIEnemySlotExtension.unfreeze(arg_7_0, arg_7_1)
	arg_7_0.target = nil
	arg_7_0.improve_wait_slot_position_t = 0
end

function AIEnemySlotExtension.update(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6)
	local var_8_0 = BLACKBOARDS[arg_8_1]
	local var_8_1 = var_8_0.target_unit

	if arg_8_0.gathering_ball then
		arg_8_0:_update_ai_target(var_8_1)
	elseif arg_8_0.sloid_id then
		arg_8_0:_engine_update_ai_target(var_8_1)
	else
		arg_8_0:_update_target(var_8_1)
	end

	if not var_8_1 then
		return
	end

	local var_8_2 = arg_8_2[var_8_1]
	local var_8_3 = var_8_2 and var_8_2.belongs_to_player

	if not var_8_3 and not AiUtils.unit_breed(var_8_1) then
		return
	end

	if var_8_3 then
		if not arg_8_0.do_search or arg_8_0.slot_template.disable_slot_search then
			return
		end

		local var_8_4 = var_8_0.using_override_target
		local var_8_5 = arg_8_0.slot_template.avoid_slots_behind_overwhelmed_target

		var_8_2:request_best_slot(arg_8_0, var_8_4, var_8_5, arg_8_3, arg_8_5, arg_8_4)

		if not var_8_0.disable_improve_slot_position then
			arg_8_0:_improve_slot_position(arg_8_1, arg_8_4, arg_8_3)
		end

		local var_8_6 = arg_8_0.delayed_prioritized_ai_unit_update_time

		if var_8_6 and var_8_6 < arg_8_4 then
			arg_8_0:_detach_from_slot()
			arg_8_6:register_prioritized_ai_unit_update(arg_8_1)

			arg_8_0.delayed_prioritized_ai_unit_update_time = nil
		end
	elseif USE_ENGINE_SLOID_SYSTEM then
		if not arg_8_0.sloid_id then
			if arg_8_0:ai_has_slot(var_8_1) then
				arg_8_0:on_ai_slot_gained(var_8_1, arg_8_6)
				arg_8_0:_improve_ai_slot_position(arg_8_1, arg_8_4, arg_8_3, var_8_1)
			end
		else
			arg_8_0:_improve_ai_slot_position(arg_8_1, arg_8_4, arg_8_3, var_8_1)
		end
	elseif not arg_8_0.gathering_ball then
		if arg_8_0:ai_has_slot(var_8_1) then
			arg_8_0:on_ai_slot_gained(var_8_1, arg_8_6)
			arg_8_0:_improve_ai_slot_position(arg_8_1, arg_8_4, arg_8_3, var_8_1)
		end
	else
		arg_8_0:_improve_ai_slot_position(arg_8_1, arg_8_4, arg_8_3, var_8_1)
	end
end

function AIEnemySlotExtension.ai_has_slot(arg_9_0, arg_9_1)
	local var_9_0 = BLACKBOARDS[arg_9_1]

	return var_9_0.breed.infighting.crowded_slots >= var_9_0.lean_dogpile
end

function AIEnemySlotExtension.on_unit_blocked_attack(arg_10_0, arg_10_1, arg_10_2)
	if arg_10_0.waiting_on_slot then
		return
	end

	if not arg_10_0.slot then
		return nil
	end

	local var_10_0 = arg_10_0.slot_template

	if var_10_0.abandon_slot_when_blocked then
		if var_10_0.abandon_slot_when_blocked_time then
			arg_10_0.delayed_prioritized_ai_unit_update_time = Managers.time:time("game") + var_10_0.abandon_slot_when_blocked_time
		else
			arg_10_0:_detach_from_slot()
			arg_10_0:_detach_from_ai_slot("on_unit_blocked_attack")
			arg_10_2:register_prioritized_ai_unit_update(arg_10_1)
		end
	end
end

function AIEnemySlotExtension.ai_unit_staggered(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_0.waiting_on_slot then
		return
	end

	if not arg_11_0.slot then
		return nil
	end

	local var_11_0 = arg_11_0.slot_template

	if var_11_0.abandon_slot_when_staggered then
		if var_11_0.abandon_slot_when_staggered_time then
			arg_11_0.delayed_prioritized_ai_unit_update_time = Managers.time:time("game") + var_11_0.abandon_slot_when_staggered_time
		else
			arg_11_0:_detach_from_slot()
			arg_11_0:_detach_from_ai_slot("ai_unit_staggered")
			arg_11_2:register_prioritized_ai_unit_update(arg_11_1)
		end
	end
end

function AIEnemySlotExtension._detach_from_slot(arg_12_0)
	local var_12_0 = arg_12_0.slot or arg_12_0.waiting_on_slot
	local var_12_1 = arg_12_0.waiting_on_slot
	local var_12_2 = var_12_0 and var_12_0.owner_extension

	if var_12_2 then
		var_12_2:free_slot(arg_12_0, var_12_0, var_12_1 ~= nil)
	end

	arg_12_0.waiting_on_slot = nil
	arg_12_0.slot = nil
end

function AIEnemySlotExtension._detach_from_ai_slot(arg_13_0, arg_13_1)
	local var_13_0

	if USE_ENGINE_SLOID_SYSTEM then
		if not arg_13_0.sloid_id then
			return
		end

		var_13_0 = arg_13_0.target_unit
	else
		local var_13_1 = arg_13_0.gathering_ball

		if not var_13_1 then
			return
		end

		var_13_0 = var_13_1.target_unit
	end

	local var_13_2 = BLACKBOARDS[var_13_0]

	if var_13_2 then
		var_13_2.lean_dogpile = var_13_2.lean_dogpile - 1
	end

	arg_13_0:on_ai_slot_lost(var_13_0)
end

function AIEnemySlotExtension._update_target(arg_14_0, arg_14_1)
	if arg_14_0.slot and arg_14_0.slot.target_unit ~= arg_14_1 then
		arg_14_0:_detach_from_slot()
	end

	if not Unit.alive(arg_14_1) then
		arg_14_0.target = nil

		arg_14_0.target_position:store(0, 0, 0)

		if arg_14_0.slot then
			arg_14_0:_detach_from_slot()
		end

		return
	end

	local var_14_0 = Unit.local_position(arg_14_1, 0)

	arg_14_0.target_position:store(var_14_0)
end

function AIEnemySlotExtension._update_ai_target(arg_15_0, arg_15_1)
	if arg_15_0.gathering_ball.target_unit ~= arg_15_1 then
		arg_15_0:_detach_from_ai_slot("new_target_unit")
	end
end

function AIEnemySlotExtension._engine_update_ai_target(arg_16_0, arg_16_1)
	if arg_16_0.target_unit ~= arg_16_1 then
		arg_16_0:_detach_from_ai_slot("new_target_unit")
	end
end

function AIEnemySlotExtension.on_slot_lost(arg_17_0)
	local var_17_0 = arg_17_0.slot

	arg_17_0.waiting_on_slot = nil
	arg_17_0.slot = nil
end

function AIEnemySlotExtension.on_slot_gained(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_0.waiting_on_slot
	local var_18_1 = arg_18_0.slot

	if var_18_0 then
		var_18_0.owner_extension:free_slot(arg_18_0, var_18_0, true)
	end

	if var_18_1 then
		var_18_1.owner_extension:free_slot(arg_18_0, var_18_1, false)
	end

	arg_18_0.waiting_on_slot = nil
	arg_18_0.slot = arg_18_2
end

function AIEnemySlotExtension.on_entered_slot_queue(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0.waiting_on_slot
	local var_19_1 = arg_19_0.slot

	if var_19_0 then
		var_19_0.owner_extension:free_slot(arg_19_0, var_19_0, true)
	end

	if var_19_1 then
		var_19_1.owner_extension:free_slot(arg_19_0, var_19_1, false)
	end

	arg_19_0.waiting_on_slot = arg_19_2
	arg_19_0.slot = nil
end

function AIEnemySlotExtension.get_current_slot(arg_20_0)
	return arg_20_0.slot or arg_20_0.waiting_on_slot, arg_20_0.waiting_on_slot ~= nil
end

function AIEnemySlotExtension.get_preferred_slot_type(arg_21_0)
	return arg_21_0.use_slot_type or var_0_5
end

function AIEnemySlotExtension.on_ai_slot_gained(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = BLACKBOARDS[arg_22_1]

	var_22_0.lean_dogpile = var_22_0.lean_dogpile + 1

	local var_22_1 = arg_22_0.unit
	local var_22_2 = BLACKBOARDS[var_22_1]
	local var_22_3 = Unit.local_position(arg_22_1, 0)
	local var_22_4 = Unit.local_position(var_22_1, 0)
	local var_22_5 = var_22_0.breed.infighting
	local var_22_6 = USE_ENGINE_SLOID_SYSTEM and 3 or var_22_5.distance or 2
	local var_22_7 = var_22_2.breed.infighting.boid_radius or 0.3
	local var_22_8 = Vector3.normalize(var_22_4 - var_22_3) * (var_22_6 + var_22_7)

	if USE_ENGINE_SLOID_SYSTEM then
		arg_22_0.sloid_id = EngineOptimized.add_sloid(var_22_3 + var_22_8, var_22_7, var_22_2.side.side_id, var_22_1, arg_22_1, tonumber(Unit.get_data(var_22_1, "unique_id") or "?"))

		local var_22_9 = Managers.state.conflict.dogpiled_attackers_on_unit[arg_22_1]

		if not var_22_9 then
			Managers.state.conflict.dogpiled_attackers_on_unit[arg_22_1] = {
				[var_22_1] = arg_22_0.sloid_id
			}
		else
			var_22_9[var_22_1] = arg_22_0.sloid_id
		end

		arg_22_0.target_unit = arg_22_1
	else
		arg_22_0.gathering_ball = arg_22_0.gathering:add_ball(var_22_3 + var_22_8, var_22_7, var_22_1, arg_22_1)
	end
end

function AIEnemySlotExtension.on_ai_slot_lost(arg_23_0, arg_23_1)
	if USE_ENGINE_SLOID_SYSTEM then
		local var_23_0 = Managers.state.conflict.dogpiled_attackers_on_unit[arg_23_1]

		fassert(var_23_0[arg_23_0.unit], "missing dogpiled_attackers_on_unit, can't remove", arg_23_1)

		var_23_0[arg_23_0.unit] = nil

		print("on_ai_slot_lost, sloid_id:", arg_23_0.sloid_id)

		local var_23_1, var_23_2 = EngineOptimized.remove_sloid(arg_23_0.sloid_id, arg_23_0.unit)

		if var_23_1 then
			printf("\t-> sloid_id was changed: %s, unit-id: %s, sloid_id: %s", var_23_2, Unit.get_data(var_23_2, "unique_id"), var_23_1)

			ScriptUnit.has_extension(var_23_2, "ai_slot_system").sloid_id = var_23_1
		end

		arg_23_0.sloid_id = nil
	else
		if not arg_23_0.gathering_ball then
			return
		end

		arg_23_0.gathering:remove_ball(arg_23_0.gathering_ball)

		arg_23_0.gathering_ball = nil
	end
end

function AIEnemySlotExtension.free_slot(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0.unit
	local var_24_1 = BLACKBOARDS[var_24_0]

	if var_24_1 then
		var_24_1.lean_dogpile = var_24_1.lean_dogpile - 1
	end

	arg_24_1:on_ai_slot_lost(arg_24_0)
end
