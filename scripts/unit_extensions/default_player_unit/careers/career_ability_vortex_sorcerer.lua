-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_vortex_sorcerer.lua

CareerAbilityVortexSorcerer = class(CareerAbilityVortexSorcerer)

local scripts_entity_system_systems_ai_ai_slot_utils = require("scripts/entity_system/systems/ai/ai_slot_utils")

CareerAbilityVortexSorcerer._ballistic_raycast = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7)
	-- function 1
	local num = arg_1_3 / arg_1_2
	local num_2 = 0.85
	local num_3 = 10

	for i = 1, arg_1_2 do
		local num_4 = arg_1_4 + arg_1_5 * num
		local linear_sphere_sweep = PhysicsWorld.linear_sphere_sweep(arg_1_1, arg_1_4, num_4, num_2, num_3, "collision_filter", arg_1_7, "report_initial_overlap")

		if not linear_sphere_sweep then
			local count = #linear_sphere_sweep

			for j = 1, count do
				local var_1_6 = linear_sphere_sweep[j]
				local actor = var_1_6.actor
				local position = var_1_6.position
				local normal = var_1_6.normal
				local distance = var_1_6.distance

				if Actor.unit(actor) ~= self.owner_unit then
					return true, position, distance, normal, actor
				end
			end
		end

		arg_1_5 = arg_1_5 + arg_1_6 * num
		arg_1_4 = num_4
	end

	return false, arg_1_4
end

local function fn(arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	return Vector3.distance(arg_2_1, arg_2_0) / arg_2_2
end

CareerAbilityVortexSorcerer.init = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	self.owner_unit = arg_3_2
	self.world = arg_3_1.world
	self.wwise_world = Managers.world:wwise_world(self.world)

	local player = arg_3_3.player

	self.player = player
	self.is_server = player.is_server
	self.local_player = player.local_player
	self.bot_player = player.bot_player
	self.network_manager = Managers.state.network
	self.input_manager = Managers.input
	self.effect_id = nil
	self.effect_name = "fx/wpnfx_staff_geiser_charge"
	self.effect_id_teleport_exit = nil
end

CareerAbilityVortexSorcerer.extensions_ready = function (self, arg_4_1, arg_4_2)
	-- function 4
	self.first_person_extension = ScriptUnit.has_extension(arg_4_2, "first_person_system")
	self.status_extension = ScriptUnit.extension(arg_4_2, "status_system")
	self.career_extension = ScriptUnit.extension(arg_4_2, "career_system")
	self.ghost_mode_extension = ScriptUnit.extension(arg_4_2, "ghost_mode_system")
	self.buff_extension = ScriptUnit.extension(arg_4_2, "buff_system")
	self.locomotion_extension = ScriptUnit.extension(arg_4_2, "locomotion_system")
	self._input_extension = ScriptUnit.has_extension(arg_4_2, "input_system")
	self._ability_input = self.career_extension:get_activated_ability_data(1).input_action

	if not self.first_person_extension then
		self.first_person_unit = self.first_person_extension:get_first_person_unit()
	end
end

CareerAbilityVortexSorcerer.destroy = function (arg_5_0)
	-- function 5
	return
end

CareerAbilityVortexSorcerer.update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	if not self:_ability_available() then
		return
	end

	local _input_extension = self._input_extension

	if not _input_extension then
		return
	end

	if not self.is_priming then
		if not _input_extension:get(self._ability_input) then
			self:_start_priming()
		end
	elseif not self.is_priming then
		self:_update_priming(arg_6_3, arg_6_5)

		if _input_extension:get("reload") or not _input_extension:get("action_two") then
			self:_stop_priming()
		end

		if not _input_extension:get("action_one_hold") then
			local status_extension = self.status_extension

			status_extension._last_valid_position = self._last_valid_position
			status_extension.do_sorcerer_vortex = true

			if not self.effect_id then
				World.destroy_particles(self.world, self.effect_id)

				self.effect_id = nil
			end

			self.career_extension:start_activated_ability_cooldown()

			self.is_priming = false

			return
		end
	end
end

CareerAbilityVortexSorcerer.stop = function (self, arg_7_1)
	-- function 7
	if not self._is_priming then
		self:_stop_priming()
	end
end

CareerAbilityVortexSorcerer._ability_available = function (self)
	-- function 8
	local career_extension = self.career_extension
	local status_extension = self.status_extension
	local locomotion_extension = self.locomotion_extension
	local is_in_ghost_mode = self.ghost_mode_extension:is_in_ghost_mode()
	local can_use_activated_ability = career_extension:can_use_activated_ability()

	if not can_use_activated_ability then
		if not status_extension:is_disabled() then
			can_use_activated_ability = locomotion_extension:is_on_ground()

			if not can_use_activated_ability then
				can_use_activated_ability = not is_in_ghost_mode
			end
		else
			can_use_activated_ability = false
		end
	end

	if false then
		can_use_activated_ability = true
	end

	return can_use_activated_ability
end

CareerAbilityVortexSorcerer._start_priming = function (self)
	-- function 9
	if not self.local_player then
		local world = self.world
		local effect_name = self.effect_name

		self.effect_id = World.create_particles(world, effect_name, Vector3.zero())
	end

	self._last_valid_position = nil
	self.is_priming = true
end

CareerAbilityVortexSorcerer._landing_postion_valid = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	local flag = false
	local astar = arg_10_3.astar

	if not astar then
		if not GwNavAStar.processing_finished(astar) then
			flag = not GwNavAStar.path_found(astar) and true and flag

			GwNavAStar.destroy(astar)

			arg_10_3.astar = nil
			arg_10_3.astar_timer = arg_10_4 + 0.01
		end
	elseif arg_10_4 > arg_10_3.astar_timer then
		local nav_world = Managers.state.entity:system("ai_system"):nav_world()
		local var_10_3 = GwNavAStar.create(nav_world)
		local box_half_width = arg_10_3.box_half_width
		local traverse_logic = Managers.state.bot_nav_transition:traverse_logic()

		GwNavAStar.start_with_propagation_box(var_10_3, nav_world, arg_10_1, arg_10_2, box_half_width, traverse_logic)

		arg_10_3.astar = var_10_3
		arg_10_3.astar_timer = arg_10_4 + 0.01
	end

	return flag
end

CareerAbilityVortexSorcerer._update_priming = function (self, arg_11_1, arg_11_2)
	-- function 11
	local effect_id = self.effect_id
	local owner_unit = self.owner_unit
	local world = self.world
	local game = Managers.state.network:game()
	local network = Managers.state.network
	local get_data = World.get_data(world, "physics_world")
	local unit_game_object_id = network:unit_game_object_id(owner_unit)
	local var_11_7 = Vector3(0, 0, 1)
	local first_person_extension = self.first_person_extension
	local current_position = first_person_extension:current_position()
	local current_rotation = first_person_extension:current_rotation()
	local num = 10
	local num_2 = 0.9
	local num_3 = 25
	local num_4 = 0
	local num_5 = Quaternion.forward(Quaternion.multiply(current_rotation, Quaternion(Vector3.right(), num_4))) * num_3
	local var_11_16 = Vector3(0, 0, -2)
	local str = "filter_adept_teleport"
	local _ballistic_raycast, var_11_19, var_11_20, var_11_21 = self:_ballistic_raycast(get_data, num, num_2, current_position, num_5, var_11_16, str, false)

	if not (not _ballistic_raycast and not (Vector3.dot(var_11_21, Vector3.up()) < 0.75)) then
		local num_6 = var_11_19 - Vector3.normalize(var_11_19 - current_position) * 1.5
		local immediate_raycast, var_11_24, var_11_25, var_11_26 = PhysicsWorld.immediate_raycast(get_data, num_6, Vector3.down(), 10, "closest", "collision_filter", str)

		if not immediate_raycast then
			var_11_19 = var_11_24
		end
	end

	local nav_world = Managers.state.entity:system("ai_system"):nav_world()

	var_11_19 = scripts_entity_system_systems_ai_ai_slot_utils.get_target_pos_on_navmesh(var_11_19, nav_world) or var_11_19

	local _astar_data = self._astar_data

	if not _astar_data then
		_astar_data = {
			astar_timer = 0,
			box_half_width = 20
		}
		self._astar_data = _astar_data
	end

	if not self:_landing_postion_valid(current_position, var_11_19, _astar_data, arg_11_2) then
		if not effect_id then
			World.move_particles(world, effect_id, var_11_19)
		end

		if not self._last_valid_position then
			self._last_valid_position:store(var_11_19)
		else
			self._last_valid_position = Vector3Box(var_11_19)
		end
	end
end

CareerAbilityVortexSorcerer._stop_priming = function (self)
	-- function 12
	if not self.effect_id then
		World.destroy_particles(self.world, self.effect_id)

		self.effect_id = nil
	end

	if not self._astar_data then
		local astar = self._astar_data.astar

		if not astar then
			GwNavAStar.destroy(astar)
		end

		self._astar_data = nil
	end

	self.is_priming = false
end
