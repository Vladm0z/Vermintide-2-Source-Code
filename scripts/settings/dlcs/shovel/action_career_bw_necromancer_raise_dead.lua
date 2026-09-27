-- chunkname: @scripts/settings/dlcs/shovel/action_career_bw_necromancer_raise_dead.lua

local num = 4.5
local num_2 = 9
local num_3 = 0.75
local num_4 = 0.15
local num_5 = 0.1
local degrees_to_radians = math.degrees_to_radians(-60)
local degrees_to_radians_2 = math.degrees_to_radians(60)

ActionCareerBWNecromancerRaiseDead = class(ActionCareerBWNecromancerRaiseDead, ActionBase)

ActionCareerBWNecromancerRaiseDead.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionCareerBWNecromancerRaiseDead.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self._career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	self._passive_ability = self._career_extension:get_passive_ability_by_name("bw_necromancer")
	self._inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	self._first_person_extension = ScriptUnit.has_extension(arg_1_4, "first_person_system")
	self._talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
	self._buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
	self._weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
	self._owner_unit = arg_1_4
	self._is_server = arg_1_3
	self._world = arg_1_1
	self._ai_navigation_system = Managers.state.entity:system("ai_navigation_system")
	self._nav_world = Managers.state.entity:system("ai_system"):nav_world()
	self._traverse_logic = Managers.state.entity:system("ai_slot_system"):traverse_logic()
	self._seed = math.random_seed()
	self.fx_spline_ids = {
		World.find_particles_variable(arg_1_1, "fx/wpnfx_staff_death/curse_spirit", "spline_1"),
		World.find_particles_variable(arg_1_1, "fx/wpnfx_staff_death/curse_spirit", "spline_2"),
		World.find_particles_variable(arg_1_1, "fx/wpnfx_staff_death/curse_spirit", "spline_3")
	}

	self._nav_callback = function ()
		-- function 2
		local time = Managers.time:time("game")

		self:_update_spawning(time)
	end
end

ActionCareerBWNecromancerRaiseDead.client_owner_start_action = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_5 = arg_3_5 or {}

	ActionCareerBWNecromancerRaiseDead.super.client_owner_start_action(self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)

	self._next_spawn_t = arg_3_2

	if not arg_3_3 then
		self:_play_vo()
	end
end

ActionCareerBWNecromancerRaiseDead._trigger_spawn = function (self)
	-- function 4
	local _generate_position = self:_generate_position()

	if not _generate_position then
		World.create_particles(self._world, "fx/necromancer_summon_decal", _generate_position)

		local var_4_1 = NetworkLookup.effects["fx/wpnfx_staff_death/curse_spirit_first"]
		local num = POSITION_LOOKUP[self._owner_unit] + Vector3.up() * 0.5
		local current_rotation = self._first_person_extension:current_rotation()
		local right = Quaternion.right(current_rotation)
		local num_2 = _generate_position - num
		local sign = math.sign(Vector3.dot(num_2, right))
		local num_3 = math.pi * math.random(0.1, 0.25)
		local axis_angle = Quaternion.axis_angle(Vector3.up(), num_3 * sign)
		local num_5 = num + Quaternion.rotate(axis_angle, num_2) * 0.5 + Vector3.up()
		local tbl = {
			num,
			num_5,
			_generate_position
		}

		Managers.state.network:rpc_play_particle_effect_spline(nil, var_4_1, self.fx_spline_ids, tbl)
	end

	self._passive_ability:spawn_pet(self._controlled_unit_template, self._breed_to_spawn, _generate_position, NecromancerPositionModes.Absolute)
	self._career_extension:reduce_activated_ability_cooldown_percent(-num_4)
end

ActionCareerBWNecromancerRaiseDead.client_owner_post_update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	self._ai_navigation_system:add_safe_navigation_callback(self._nav_callback)
end

ActionCareerBWNecromancerRaiseDead._update_spawning = function (self, arg_6_1)
	-- function 6
	if self._career_extension:current_ability_cooldown_percentage() >= 1 - num_5 then
		self._weapon_extension:stop_action("action_complete")
	end

	if arg_6_1 > self._next_spawn_t then
		self._next_spawn_t = self._next_spawn_t + num_3

		self:_trigger_spawn()
	end
end

ActionCareerBWNecromancerRaiseDead._play_vo = function (self)
	-- function 7
	local owner_unit = self.owner_unit
	local extension_input = ScriptUnit.extension_input(owner_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("activate_ability", alloc_table)
end

ActionCareerBWNecromancerRaiseDead._generate_position = function (self)
	-- function 8
	local unbox = self._position:unbox()
	local num_3 = 1
	local num_4 = 3
	local pos_on_mesh = LocomotionUtils.pos_on_mesh(self._nav_world, unbox, num_3, num_4)

	if not pos_on_mesh then
		return nil
	end

	local var_8_4
	local var_8_5
	local var_8_6, var_8_7

	self._seed, var_8_6, var_8_7 = math.get_uniformly_random_point_inside_sector_seeded(self._seed, num, num_2, degrees_to_radians, degrees_to_radians_2)

	local var_8_8 = Vector3(var_8_6, var_8_7, 0)
	local current_rotation = self._first_person_extension:current_rotation()
	local num_5 = pos_on_mesh + Quaternion.rotate(current_rotation, var_8_8)
	local raycast, var_8_12 = GwNavQueries.raycast(self._nav_world, pos_on_mesh, num_5, self._traverse_logic)

	return var_8_12
end
