-- chunkname: @scripts/unit_extensions/weaves/weave_target_extension.lua

WeaveTargetExtension = class(WeaveTargetExtension, BaseObjectiveExtension)
WeaveTargetExtension.NAME = "WeaveTargetExtension"

WeaveTargetExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	WeaveTargetExtension.super.init(self, arg_1_1, arg_1_2, arg_1_3)

	self._on_start_func = arg_1_3.on_start_func
	self._on_progress_func = arg_1_3.on_progress_func
	self._on_complete_func = arg_1_3.on_complete_func
	self._audio_system = Managers.state.entity:system("audio_system")
	self.keep_alive = true

	local terror_event_spawner_id = arg_1_3.terror_event_spawner_id

	Unit.set_data(arg_1_2, "terror_event_spawner_id", terror_event_spawner_id)

	local attacks_allowed = arg_1_3.attacks_allowed

	attacks_allowed = attacks_allowed or {
		melee = true,
		ranged = true
	}
	self._attacks_allowed = attacks_allowed

	Unit.set_data(arg_1_2, "allow_melee_damage", self._attacks_allowed.melee)
	Unit.set_data(arg_1_2, "allow_ranged_damage", self._attacks_allowed.ranged)
end

WeaveTargetExtension.extensions_ready = function (self)
	-- function 2
	self._health_extension = ScriptUnit.has_extension(self._unit, "health_system")

	if not self._health_extension then
		self._max_health = self._health_extension:current_health()
		self._health = self._max_health
	end
end

WeaveTargetExtension.display_name = function (arg_3_0)
	-- function 3
	return "objective_targets_name_single"
end

WeaveTargetExtension.is_stacking_objective = function (arg_4_0)
	-- function 4
	return "target"
end

WeaveTargetExtension.initial_sync_data = function (self, arg_5_1)
	-- function 5
	arg_5_1.value = self:get_percentage_done()
end

WeaveTargetExtension._set_objective_data = function (arg_6_0, arg_6_1)
	-- function 6
	return
end

WeaveTargetExtension._activate = function (self)
	-- function 7
	local has_extension = ScriptUnit.has_extension(self._unit, "tutorial_system")

	if not has_extension then
		has_extension:set_active(true)
	end
end

WeaveTargetExtension._deactivate = function (self)
	-- function 8
	Unit.flow_event(self._unit, "target_destroyed")

	ScriptUnit.extension(self._unit, "tutorial_system").active = false

	local local_position = Unit.local_position(self._unit, 0)

	for i = 1, 3 do
		local num = math.random(-10, 10) / 10
		local num_2 = math.random(-10, 10) / 10
		local num_3 = math.random(-10, 10) / 10

		Managers.state.entity:system("objective_system"):weave_essence_handler():spawn_essence_unit(local_position + Vector3(0, 0, 0.5) + Vector3(num, num_2, num_3))
	end
end

WeaveTargetExtension._server_update = function (self, arg_9_1, arg_9_2)
	-- function 9
	local current_health = self._health_extension:current_health()

	if current_health ~= self._health then
		if not self._on_start_func then
			self._on_start_func(self._unit)

			self._on_start_func = nil
		end

		self._audio_system:play_2d_audio_event("hud_text_reveal")

		if not (current_health < self._health) or not self._on_progress_func then
			self._on_progress_func(self._unit, current_health, self._max_health)
		end

		self._health = current_health

		self:server_set_value(self:get_percentage_done())
	end
end

WeaveTargetExtension._client_update = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	return
end

WeaveTargetExtension.is_done = function (self)
	-- function 11
	return self._health_extension:is_dead()
end

WeaveTargetExtension.attacks_allowed = function (self)
	-- function 12
	return self._attacks_allowed
end

WeaveTargetExtension.get_percentage_done = function (self)
	-- function 13
	return math.clamp(1 - self._health / self._max_health, 0, 1)
end
