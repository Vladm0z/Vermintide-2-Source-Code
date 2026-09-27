-- chunkname: @scripts/unit_extensions/ai_supplementary/shadow_dagger_spawner_extension.lua

ShadowDaggerSpawnerExtension = class(ShadowDaggerSpawnerExtension)

local num = 12
local num_2 = 1.2
local num_3 = 0.5
local num_4 = 1
local num_5 = 1.5
local num_6 = 4
local str = "filter_in_line_of_sight_no_players_no_enemies"
local str_2 = "units/props/blk/blk_curse_shadow_dagger_01"
local str_3 = "drake_pistols"
local str_4 = "throw_trajectory"
local str_5 = "filter_ray_projectile"
local str_6 = "shadow_dagger_impact"
local num_7 = 300
local num_8 = 0.5
local flag = true

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	local str = "n/a"
	local var_1_1 = str_3
	local var_1_2 = str_4
	local var_1_3 = str_5
	local var_1_4 = num_7
	local var_1_5 = str_2
	local look = Quaternion.look(arg_1_2, Vector3.up())
	local pitch_from_rotation = ActionUtils.pitch_from_rotation(look)
	local var_1_8 = str_6
	local var_1_9 = num_8
	local var_1_10 = flag
	local tbl = {
		projectile_locomotion_system = {
			rotate_around_forward = true,
			rotation_speed = 10,
			angle = pitch_from_rotation,
			speed = var_1_4,
			target_vector = arg_1_2,
			initial_position = arg_1_1,
			trajectory_template_name = var_1_2,
			gravity_settings = var_1_1,
			start_paused_for_time = num_4
		},
		projectile_impact_system = {
			sphere_radius = var_1_9,
			only_one_impact = var_1_10,
			collision_filter = var_1_3,
			owner_unit = arg_1_0
		},
		projectile_system = {
			impact_template_name = "direct_impact",
			damage_source = str,
			owner_unit = arg_1_0,
			explosion_template_name = var_1_8
		}
	}

	return Managers.state.unit_spawner:spawn_network_unit(var_1_5, "shadow_dagger_unit", tbl, arg_1_1)
end

local function fn_2(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local num = arg_2_1 - arg_2_0
	local length = Vector3.length(num)
	local normalize = Vector3.normalize(num)

	if length < 0.001 then
		length = 0.001
	end

	local var_2_3 = num_8
	local num_2 = arg_2_0 + normalize * length * 0.5
	local var_2_5 = length

	PhysicsWorld.prepare_actors_for_overlap(arg_2_2, num_2, var_2_5)

	local num_3 = 1

	return not PhysicsWorld.linear_sphere_sweep(arg_2_2, arg_2_0, arg_2_1, var_2_3, num_3, "collision_filter", arg_2_3, "report_initial_overlap")
end

ShadowDaggerSpawnerExtension.init = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local world = arg_3_1.world

	self.world = world
	self.physics_world = World.get_data(world, "physics_world")
	self.unit = arg_3_2
	self.is_server = Managers.player.is_server
	self._limitted_spawner = arg_3_3.limitted_spawner
end

ShadowDaggerSpawnerExtension.destroy = function (arg_4_0)
	-- function 4
	return
end

ShadowDaggerSpawnerExtension.on_remove_extension = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	return
end

ShadowDaggerSpawnerExtension.update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	if not self._done then
		return
	end

	if not self.is_server then
		return
	end

	if not self._destroy_t then
		if arg_6_5 > self._destroy_t then
			if not Unit.alive(arg_6_1) then
				Managers.state.unit_spawner:mark_for_deletion(arg_6_1)
			end

			self._done = true
		end

		return
	end

	local _next_dagger_t = self._next_dagger_t

	if not (not _next_dagger_t and not (_next_dagger_t < arg_6_5)) then
		local _launched_daggers = self._launched_daggers

		_launched_daggers = _launched_daggers or -1

		local num_4 = _launched_daggers + 1
		local num_7 = Unit.world_position(arg_6_1, 0) + Vector3(0, 0, 1)
		local up = Vector3.up()
		local forward = Quaternion.forward(Quaternion(up, 2 * math.pi * (num_4 / num)))
		local normalize = Vector3.normalize(forward)
		local num_8 = num_7 + normalize * num_3
		local num_9 = num_8 + normalize * num_6

		if not fn_2(num_8, num_9, self.physics_world, str) then
			fn(self.unit, num_8, forward)

			self._next_dagger_t = arg_6_5 + num_2
		end

		self._launched_daggers = num_4

		if not (not self._limitted_spawner and not (num_4 >= num)) then
			self._destroy_t = arg_6_5 + num_5
		end
	end
end
