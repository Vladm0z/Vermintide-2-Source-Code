-- chunkname: @scripts/unit_extensions/weapons/projectiles/projectile_impact/projectile_linear_sphere_sweep_impact_unit_extension.lua

local num = 0.01

ProjectileLinearSphereSweepImpactUnitExtension = class(ProjectileLinearSphereSweepImpactUnitExtension, ProjectileBaseImpactUnitExtension)

ProjectileLinearSphereSweepImpactUnitExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	ProjectileLinearSphereSweepImpactUnitExtension.super.init(self, arg_1_1, arg_1_2, arg_1_3)

	local collision_filter = arg_1_3.collision_filter

	collision_filter = collision_filter or "filter_player_ray_projectile"
	self.collision_filter = collision_filter
	self.sphere_radius = arg_1_3.sphere_radius
	self.only_one_impact = arg_1_3.only_one_impact
	self.owner_unit = arg_1_3.owner_unit
	self._dont_target_friendly = arg_1_3.dont_target_friendly
	self._dont_target_patrols = arg_1_3.dont_target_patrols
	self._next_check_t = 0

	local local_position = Unit.local_position(arg_1_2, 0)

	self._last_position = Vector3Box(local_position)
end

ProjectileLinearSphereSweepImpactUnitExtension.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	self.locomotion_extension = ScriptUnit.extension(arg_2_2, "projectile_locomotion_system")
end

ProjectileLinearSphereSweepImpactUnitExtension.update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	ProjectileLinearSphereSweepImpactUnitExtension.super.update(self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)

	if not self.locomotion_extension:moved_this_frame() then
		return
	end

	if arg_3_5 > self._next_check_t then
		local physics_world = self.physics_world
		local collision_filter = self.collision_filter
		local sphere_radius = self.sphere_radius
		local unbox = self._last_position:unbox()
		local local_position = Unit.local_position(arg_3_1, 0)
		local only_one_impact = self.only_one_impact
		local num_2 = unbox - local_position
		local length = Vector3.length(num_2)
		local normalize = Vector3.normalize(num_2)
		local num_3 = unbox + normalize * length * 0.5
		local var_3_10 = length

		PhysicsWorld.prepare_actors_for_overlap(physics_world, num_3, var_3_10)

		local linear_sphere_sweep = PhysicsWorld.linear_sphere_sweep(physics_world, unbox, local_position, sphere_radius, 100, "collision_filter", collision_filter, "report_initial_overlap")

		if not linear_sphere_sweep then
			local count = #linear_sphere_sweep

			for i = 1, count do
				local var_3_13 = linear_sphere_sweep[i]
				local position = var_3_13.position
				local normal = var_3_13.normal
				local actor = var_3_13.actor
				local unit = Actor.unit(actor)

				if not (not self:_valid_target(arg_3_1, unit, actor) and unit == arg_3_1) then
					local num_actors = Unit.num_actors(unit)
					local var_3_19

					for j = 0, num_actors - 1 do
						if actor == Unit.actor(unit, j) then
							var_3_19 = j

							break
						end
					end

					fassert(var_3_19, "No actor index found for unit [\"%s\"] that was hit on actor [\"%s\"]", unit, actor)
					self:impact(unit, position, normalize, normal, var_3_19)

					if not only_one_impact then
						break
					end
				end
			end
		end

		self._last_position:store(local_position)

		self._next_check_t = arg_3_5 + num
	end
end

ProjectileLinearSphereSweepImpactUnitExtension._valid_target = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	if not (arg_4_2 == arg_4_1 or Unit.is_frozen(arg_4_2) or arg_4_3 ~= Unit.actor(arg_4_2, "c_afro")) then
		return false
	end

	if not self._dont_target_friendly then
		local side = Managers.state.side

		if not (not side.side_by_unit[arg_4_2] and side:is_enemy(self.owner_unit, arg_4_2)) then
			return false
		end
	end

	if not (not self._dont_target_patrols and not AiUtils.is_part_of_patrol(arg_4_1) and AiUtils.is_aggroed(arg_4_1)) then
		return false
	end

	return true
end
