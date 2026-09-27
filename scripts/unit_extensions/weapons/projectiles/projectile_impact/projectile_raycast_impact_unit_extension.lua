-- chunkname: @scripts/unit_extensions/weapons/projectiles/projectile_impact/projectile_raycast_impact_unit_extension.lua

ProjectileRaycastImpactUnitExtension = class(ProjectileRaycastImpactUnitExtension, ProjectileBaseImpactUnitExtension)

local num = 1
local num_2 = 2
local num_3 = 3
local num_4 = 4

ProjectileRaycastImpactUnitExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	ProjectileRaycastImpactUnitExtension.super.init(self, arg_1_1, arg_1_2, arg_1_3)

	local collision_filter = arg_1_3.collision_filter

	collision_filter = collision_filter or "filter_player_ray_projectile"
	self.collision_filter = collision_filter
	self.network_manager = Managers.state.network
	self.is_server = Managers.player.is_server
	self.owner_unit = arg_1_3.owner_unit

	local owner = Managers.player:owner(self.owner_unit)
	local local_player

	if not owner then
		local_player = owner.local_player

		if not local_player then
			-- Nothing
		end
	end

	if not owner then
		local_player = owner.bot_player

		if not local_player then
			-- Nothing
		end
	end

	local_player = false

	::label_1_0::

	self.owner_is_local = local_player
	self.server_side_raycast = arg_1_3.server_side_raycast
	self.is_server = Managers.player.is_server
	self._dont_target_friendly = arg_1_3.dont_target_friendly
	self._dont_target_patrols = arg_1_3.dont_target_patrols
	self._ignore_dead = arg_1_3.ignore_dead
	self.last_position = nil
end

ProjectileRaycastImpactUnitExtension.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	self.locomotion_extension = ScriptUnit.extension(arg_2_2, "projectile_locomotion_system")
end

ProjectileRaycastImpactUnitExtension.update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	ProjectileRaycastImpactUnitExtension.super.update(self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)

	if not (not self.server_side_raycast and self.is_server) then
		return
	end

	if not (self.server_side_raycast or self.owner_is_local) then
		return
	end

	if not self.locomotion_extension:moved_this_frame() then
		return
	end

	local physics_world = self.physics_world
	local collision_filter = self.collision_filter
	local var_3_2 = POSITION_LOOKUP[arg_3_1]
	local local_position = Unit.local_position(arg_3_1, 0)

	if not self.last_position then
		self:_do_raycast(arg_3_1, self.last_position:unbox(), local_position, physics_world, collision_filter, arg_3_5, arg_3_3)
	else
		self.last_position = Vector3Box()
	end

	self.last_position:store(var_3_2)
	self:_do_raycast(arg_3_1, var_3_2, local_position, physics_world, collision_filter, arg_3_5, arg_3_3)
end

ProjectileRaycastImpactUnitExtension._do_raycast = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7)
	-- function 4
	local direction_length, var_4_1 = Vector3.direction_length(arg_4_3 - arg_4_2)

	if var_4_1 < math.epsilon then
		var_4_1 = math.epsilon
	end

	if not script_data.debug_projectiles then
		QuickDrawerStay:vector(arg_4_2, direction_length, Color(255, 255, 255, 0))
	end

	PhysicsWorld.prepare_actors_for_raycast(arg_4_4, arg_4_2, direction_length, 0.1, 9, var_4_1 * var_4_1)

	local immediate_raycast = PhysicsWorld.immediate_raycast(arg_4_4, arg_4_2, direction_length, var_4_1, "all", "collision_filter", arg_4_5)

	if not immediate_raycast then
		return
	end

	local count = #immediate_raycast

	for i = 1, count do
		local var_4_4 = immediate_raycast[i]
		local var_4_5 = var_4_4[num_4]
		local unit = Actor.unit(var_4_5)

		if not self:_valid_target(arg_4_1, unit, var_4_5) then
			local num_actors = Unit.num_actors(unit)
			local var_4_8

			for j = 0, num_actors - 1 do
				if var_4_5 == Unit.actor(unit, j) then
					var_4_8 = j

					break
				end
			end

			local var_4_9 = var_4_4[num]
			local var_4_10 = var_4_4[num_2]
			local var_4_11 = var_4_4[num_3]

			self:impact(unit, var_4_9, direction_length, var_4_11, var_4_8)
		end
	end
end

ProjectileRaycastImpactUnitExtension._valid_target = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	if not (arg_5_2 == arg_5_1 or arg_5_2 ~= self.owner_unit) then
		return false
	end

	if Unit.actor(arg_5_2, "c_afro") == arg_5_3 then
		return false
	end

	if not self._dont_target_friendly then
		local side = Managers.state.side

		if not (not side.side_by_unit[arg_5_2] and side:is_enemy(self.owner_unit, arg_5_2)) then
			return false
		end
	end

	if not (not self._dont_target_patrols and not AiUtils.is_part_of_patrol(arg_5_2) and AiUtils.is_aggroed(arg_5_2)) then
		return false
	end

	if not (not self._ignore_dead and not ScriptUnit.has_extension(arg_5_2, "health_system") and HEALTH_ALIVE[arg_5_2]) then
		return false
	end

	return true
end
