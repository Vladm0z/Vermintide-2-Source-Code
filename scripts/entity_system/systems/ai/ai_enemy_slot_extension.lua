-- chunkname: @scripts/entity_system/systems/ai/ai_enemy_slot_extension.lua

AIEnemySlotExtension = class(AIEnemySlotExtension)

local SlotTemplates = SlotTemplates
local SlotTypeSettings = SlotTypeSettings
local distance_squared = Vector3.distance_squared
local distance = Vector3.distance
local dot = Vector3.dot
local str = "normal"
local num = 1

AIEnemySlotExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.unit = arg_1_2
	self.target = nil
	self.target_position = Vector3Box()
	self.improve_wait_slot_position_t = 0
	self._debug_id = num
	num = num + 1
	self.belongs_to_ai = true
	self.gathering = Managers.state.conflict.gathering
end

AIEnemySlotExtension.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	local breed = BLACKBOARDS[arg_2_2].breed

	self.breed = breed

	local slot_template = breed.slot_template
	local var_2_2 = Managers.state.difficulty:get_difficulty_value_from_table(SlotTemplates)[slot_template]

	fassert(slot_template, "Breed " .. breed.name .. " that uses slot system does not have a slot_template set in its breed.")
	fassert(var_2_2, "Breed " .. breed.name .. " that uses slot system does not have a slot_template setup in SlotTemplates.")

	self.slot_template = var_2_2
	self.slot_type_settings = SlotTypeSettings[var_2_2.slot_type]
	self.use_slot_type = var_2_2.slot_type
	self._navigation_ext = ScriptUnit.extension(arg_2_2, "ai_navigation_system")
end

AIEnemySlotExtension.cleanup_extension = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	self:_detach_from_slot()
	self:_detach_from_ai_slot("cleanup_extension")

	for i = 1, arg_3_3 do
		if arg_3_2[i] == arg_3_1 then
			arg_3_2[i] = arg_3_2[arg_3_3]
			arg_3_2[arg_3_3] = nil

			break
		end
	end
end

AIEnemySlotExtension._improve_slot_position = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	if not ALIVE[arg_4_1] then
		return
	end

	local get_current_slot, var_4_1 = self:get_current_slot()

	if not get_current_slot then
		return
	end

	if not var_4_1 then
		if arg_4_2 > self.improve_wait_slot_position_t then
			self.improve_wait_slot_position_t = arg_4_2 + Math.random() * 0.4
		else
			return
		end
	end

	local var_4_2
	local owner_extension = get_current_slot.owner_extension

	if not owner_extension then
		var_4_2 = owner_extension:get_destination(self, get_current_slot, var_4_1, arg_4_3, arg_4_2)
	end

	if not var_4_2 then
		return
	end

	local local_position = Unit.local_position(arg_4_1, 0)

	if not var_4_1 then
		local var_4_5 = distance(var_4_2, local_position)

		var_4_5 = var_4_5 or math.huge
		self.wait_slot_distance = var_4_5
	end

	local _navigation_ext = self._navigation_ext
	local destination = _navigation_ext:destination()

	if not (distance_squared(local_position, var_4_2) > 1 or not (dot(var_4_2 - local_position, destination - local_position) < 0)) then
		_navigation_ext:move_to(var_4_2)
	end
end

AIEnemySlotExtension._improve_ai_slot_position = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local local_position = Unit.local_position(arg_5_1, 0)
	local var_5_1

	if not USE_ENGINE_SLOID_SYSTEM then
		if not self.sloid_id then
			return
		end

		local get_sloid_position = EngineOptimized.get_sloid_position(self.sloid_id)

		var_5_1 = Vector3(get_sloid_position[1], get_sloid_position[2], get_sloid_position[3])
	else
		local gathering_ball = self.gathering_ball

		if not gathering_ball then
			return
		end

		local pos = gathering_ball.pos

		var_5_1 = Vector3(pos[1], pos[2], pos[3])
	end

	local _navigation_ext = self._navigation_ext
	local destination = _navigation_ext:destination()

	if not (distance_squared(local_position, var_5_1) > 1 or not (dot(var_5_1 - local_position, destination - local_position) < 0)) then
		_navigation_ext:move_to(var_5_1)
	end
end

AIEnemySlotExtension.freeze = function (self, arg_6_1)
	-- function 6
	self:_detach_from_slot()
	self:_detach_from_ai_slot("freeze")
end

AIEnemySlotExtension.unfreeze = function (self, arg_7_1)
	-- function 7
	self.target = nil
	self.improve_wait_slot_position_t = 0
end

AIEnemySlotExtension.update = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6)
	-- function 8
	local var_8_0 = BLACKBOARDS[arg_8_1]
	local target_unit = var_8_0.target_unit

	if not self.gathering_ball then
		self:_update_ai_target(target_unit)
	elseif not self.sloid_id then
		self:_engine_update_ai_target(target_unit)
	else
		self:_update_target(target_unit)
	end

	if not target_unit then
		return
	end

	local var_8_2 = arg_8_2[target_unit]
	local flag = not var_8_2 and var_8_2.belongs_to_player

	if not (flag or AiUtils.unit_breed(target_unit)) then
		return
	end

	if not flag then
		if not self.do_search and not self.slot_template.disable_slot_search then
			return
		end

		local using_override_target = var_8_0.using_override_target
		local avoid_slots_behind_overwhelmed_target = self.slot_template.avoid_slots_behind_overwhelmed_target

		var_8_2:request_best_slot(self, using_override_target, avoid_slots_behind_overwhelmed_target, arg_8_3, arg_8_5, arg_8_4)

		if not var_8_0.disable_improve_slot_position then
			self:_improve_slot_position(arg_8_1, arg_8_4, arg_8_3)
		end

		local delayed_prioritized_ai_unit_update_time = self.delayed_prioritized_ai_unit_update_time

		if not (not delayed_prioritized_ai_unit_update_time and not (delayed_prioritized_ai_unit_update_time < arg_8_4)) then
			self:_detach_from_slot()
			arg_8_6:register_prioritized_ai_unit_update(arg_8_1)

			self.delayed_prioritized_ai_unit_update_time = nil
		end
	elseif not USE_ENGINE_SLOID_SYSTEM then
		if not self.sloid_id then
			if not self:ai_has_slot(target_unit) then
				self:on_ai_slot_gained(target_unit, arg_8_6)
				self:_improve_ai_slot_position(arg_8_1, arg_8_4, arg_8_3, target_unit)
			end
		else
			self:_improve_ai_slot_position(arg_8_1, arg_8_4, arg_8_3, target_unit)
		end
	elseif not self.gathering_ball then
		if not self:ai_has_slot(target_unit) then
			self:on_ai_slot_gained(target_unit, arg_8_6)
			self:_improve_ai_slot_position(arg_8_1, arg_8_4, arg_8_3, target_unit)
		end
	else
		self:_improve_ai_slot_position(arg_8_1, arg_8_4, arg_8_3, target_unit)
	end
end

AIEnemySlotExtension.ai_has_slot = function (arg_9_0, arg_9_1)
	-- function 9
	local var_9_0 = BLACKBOARDS[arg_9_1]

	return var_9_0.breed.infighting.crowded_slots >= var_9_0.lean_dogpile
end

AIEnemySlotExtension.on_unit_blocked_attack = function (self, arg_10_1, arg_10_2)
	-- function 10
	if not self.waiting_on_slot then
		return
	end

	if not self.slot then
		return nil
	end

	local slot_template = self.slot_template

	if not slot_template.abandon_slot_when_blocked then
		if not slot_template.abandon_slot_when_blocked_time then
			self.delayed_prioritized_ai_unit_update_time = Managers.time:time("game") + slot_template.abandon_slot_when_blocked_time
		else
			self:_detach_from_slot()
			self:_detach_from_ai_slot("on_unit_blocked_attack")
			arg_10_2:register_prioritized_ai_unit_update(arg_10_1)
		end
	end
end

AIEnemySlotExtension.ai_unit_staggered = function (self, arg_11_1, arg_11_2)
	-- function 11
	if not self.waiting_on_slot then
		return
	end

	if not self.slot then
		return nil
	end

	local slot_template = self.slot_template

	if not slot_template.abandon_slot_when_staggered then
		if not slot_template.abandon_slot_when_staggered_time then
			self.delayed_prioritized_ai_unit_update_time = Managers.time:time("game") + slot_template.abandon_slot_when_staggered_time
		else
			self:_detach_from_slot()
			self:_detach_from_ai_slot("ai_unit_staggered")
			arg_11_2:register_prioritized_ai_unit_update(arg_11_1)
		end
	end
end

AIEnemySlotExtension._detach_from_slot = function (self)
	-- function 12
	local slot = self.slot

	slot = slot or self.waiting_on_slot

	local waiting_on_slot = self.waiting_on_slot
	local flag = not slot and slot.owner_extension

	if not flag then
		flag:free_slot(self, slot, waiting_on_slot ~= nil)
	end

	self.waiting_on_slot = nil
	self.slot = nil
end

AIEnemySlotExtension._detach_from_ai_slot = function (self, arg_13_1)
	-- function 13
	local var_13_0

	if not USE_ENGINE_SLOID_SYSTEM then
		if not self.sloid_id then
			return
		end

		var_13_0 = self.target_unit
	else
		local gathering_ball = self.gathering_ball

		if not gathering_ball then
			return
		end

		var_13_0 = gathering_ball.target_unit
	end

	local var_13_2 = BLACKBOARDS[var_13_0]

	if not var_13_2 then
		var_13_2.lean_dogpile = var_13_2.lean_dogpile - 1
	end

	self:on_ai_slot_lost(var_13_0)
end

AIEnemySlotExtension._update_target = function (self, arg_14_1)
	-- function 14
	if not (not self.slot and self.slot.target_unit == arg_14_1) then
		self:_detach_from_slot()
	end

	if not Unit.alive(arg_14_1) then
		self.target = nil

		self.target_position:store(0, 0, 0)

		if not self.slot then
			self:_detach_from_slot()
		end

		return
	end

	local local_position = Unit.local_position(arg_14_1, 0)

	self.target_position:store(local_position)
end

AIEnemySlotExtension._update_ai_target = function (self, arg_15_1)
	-- function 15
	if self.gathering_ball.target_unit ~= arg_15_1 then
		self:_detach_from_ai_slot("new_target_unit")
	end
end

AIEnemySlotExtension._engine_update_ai_target = function (self, arg_16_1)
	-- function 16
	if self.target_unit ~= arg_16_1 then
		self:_detach_from_ai_slot("new_target_unit")
	end
end

AIEnemySlotExtension.on_slot_lost = function (self)
	-- function 17
	local slot = self.slot

	self.waiting_on_slot = nil
	self.slot = nil
end

AIEnemySlotExtension.on_slot_gained = function (self, arg_18_1, arg_18_2)
	-- function 18
	local waiting_on_slot = self.waiting_on_slot
	local slot = self.slot

	if not waiting_on_slot then
		waiting_on_slot.owner_extension:free_slot(self, waiting_on_slot, true)
	end

	if not slot then
		slot.owner_extension:free_slot(self, slot, false)
	end

	self.waiting_on_slot = nil
	self.slot = arg_18_2
end

AIEnemySlotExtension.on_entered_slot_queue = function (self, arg_19_1, arg_19_2)
	-- function 19
	local waiting_on_slot = self.waiting_on_slot
	local slot = self.slot

	if not waiting_on_slot then
		waiting_on_slot.owner_extension:free_slot(self, waiting_on_slot, true)
	end

	if not slot then
		slot.owner_extension:free_slot(self, slot, false)
	end

	self.waiting_on_slot = arg_19_2
	self.slot = nil
end

AIEnemySlotExtension.get_current_slot = function (self)
	-- function 20
	local slot = self.slot

	slot = slot or self.waiting_on_slot

	return slot, self.waiting_on_slot ~= nil
end

AIEnemySlotExtension.get_preferred_slot_type = function (self)
	-- function 21
	local use_slot_type = self.use_slot_type

	use_slot_type = use_slot_type or str

	return use_slot_type
end

AIEnemySlotExtension.on_ai_slot_gained = function (self, arg_22_1, arg_22_2)
	-- function 22
	local var_22_0 = BLACKBOARDS[arg_22_1]

	var_22_0.lean_dogpile = var_22_0.lean_dogpile + 1

	local unit = self.unit
	local var_22_2 = BLACKBOARDS[unit]
	local local_position = Unit.local_position(arg_22_1, 0)
	local local_position_2 = Unit.local_position(unit, 0)
	local infighting = var_22_0.breed.infighting
	local num

	if not USE_ENGINE_SLOID_SYSTEM then
		num = 3
	else
		num = infighting.distance
		num = num or 2
	end

	local boid_radius = var_22_2.breed.infighting.boid_radius

	boid_radius = boid_radius or 0.3

	local num_2 = Vector3.normalize(local_position_2 - local_position) * (num + boid_radius)

	if not USE_ENGINE_SLOID_SYSTEM then
		local add_sloid = EngineOptimized.add_sloid
		local num_3 = local_position + num_2
		local var_22_11 = boid_radius
		local side_id = var_22_2.side.side_id
		local var_22_13 = unit
		local var_22_14 = arg_22_1
		local tonumber = tonumber
		local get_data = Unit.get_data(unit, "unique_id")

		get_data = get_data or "?"
		self.sloid_id = add_sloid(num_3, var_22_11, side_id, var_22_13, var_22_14, tonumber(get_data))

		local var_22_17 = Managers.state.conflict.dogpiled_attackers_on_unit[arg_22_1]

		if not var_22_17 then
			Managers.state.conflict.dogpiled_attackers_on_unit[arg_22_1] = {
				[unit] = self.sloid_id
			}
		else
			var_22_17[unit] = self.sloid_id
		end

		self.target_unit = arg_22_1
	else
		self.gathering_ball = self.gathering:add_ball(local_position + num_2, boid_radius, unit, arg_22_1)
	end
end

AIEnemySlotExtension.on_ai_slot_lost = function (self, arg_23_1)
	-- function 23
	if not USE_ENGINE_SLOID_SYSTEM then
		local var_23_0 = Managers.state.conflict.dogpiled_attackers_on_unit[arg_23_1]

		fassert(var_23_0[self.unit], "missing dogpiled_attackers_on_unit, can't remove", arg_23_1)

		var_23_0[self.unit] = nil

		print("on_ai_slot_lost, sloid_id:", self.sloid_id)

		local remove_sloid, var_23_2 = EngineOptimized.remove_sloid(self.sloid_id, self.unit)

		if not remove_sloid then
			printf("\t-> sloid_id was changed: %s, unit-id: %s, sloid_id: %s", var_23_2, Unit.get_data(var_23_2, "unique_id"), remove_sloid)

			ScriptUnit.has_extension(var_23_2, "ai_slot_system").sloid_id = remove_sloid
		end

		self.sloid_id = nil
	else
		if not self.gathering_ball then
			return
		end

		self.gathering:remove_ball(self.gathering_ball)

		self.gathering_ball = nil
	end
end

AIEnemySlotExtension.free_slot = function (self, arg_24_1)
	-- function 24
	local unit = self.unit
	local var_24_1 = BLACKBOARDS[unit]

	if not var_24_1 then
		var_24_1.lean_dogpile = var_24_1.lean_dogpile - 1
	end

	arg_24_1:on_ai_slot_lost(self)
end
