-- chunkname: @scripts/unit_extensions/weapons/projectiles/projectile_impact/player_projectile_impact_unit_extension.lua

PlayerProjectileImpactUnitExtension = class(PlayerProjectileImpactUnitExtension, ProjectileBaseImpactUnitExtension)

PlayerProjectileImpactUnitExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	PlayerProjectileImpactUnitExtension.super.init(self, arg_1_1, arg_1_2, arg_1_3)

	self.network_manager = Managers.state.network
	self.is_server = Managers.player.is_server

	local owner_unit = arg_1_3.owner_unit

	self.owner_unit = owner_unit

	local owner = Managers.player:owner(owner_unit)

	self._dont_target_friendly = arg_1_3.dont_target_friendly
	self._dont_target_patrols = arg_1_3.dont_target_patrols

	local item_name = arg_1_3.item_name
	local var_1_3 = ItemMasterList[item_name]
	local get_item_template = BackendUtils.get_item_template(var_1_3)
	local item_template_name = arg_1_3.item_template_name
	local action_name = arg_1_3.action_name
	local sub_action_name = arg_1_3.sub_action_name

	self.action_lookup_data = {
		item_template_name = item_template_name,
		action_name = action_name,
		sub_action_name = sub_action_name
	}

	local projectile_info = get_item_template.actions[action_name][sub_action_name].projectile_info

	self.impact_type = projectile_info.impact_type
	self.static_impact_type = projectile_info.static_impact_type

	local str = "filter_player_ray_projectile_dynamic_only"
	local str_2 = "filter_player_ray_projectile_no_player"
	local str_3 = "filter_player_ray_projectile_static_only"
	local get_difficulty_settings = Managers.state.difficulty:get_difficulty_settings()

	if not DamageUtils.allow_friendly_fire_ranged(get_difficulty_settings, owner) then
		str_2 = "filter_player_ray_projectile"
	end

	local collision_filter = arg_1_3.collision_filter

	collision_filter = collision_filter or str
	self.enemy_collision_filter = collision_filter

	local collision_filter_2 = arg_1_3.collision_filter

	collision_filter_2 = collision_filter_2 or str_3
	self.static_collision_filter = collision_filter_2

	local collision_filter_3 = arg_1_3.collision_filter

	collision_filter_3 = collision_filter_3 or str_2
	self.collision_filter = collision_filter_3
	self.radius = arg_1_3.radius

	local scene_query_height_offset = projectile_info.scene_query_height_offset

	scene_query_height_offset = scene_query_height_offset or 0
	self.scene_query_height_offset = scene_query_height_offset
	self.last_position = nil

	local time = Managers.time:time("game")
	local friendly_fire_grace_period = projectile_info.friendly_fire_grace_period

	friendly_fire_grace_period = friendly_fire_grace_period or 0
	self._friendly_fire_grace_period = time + friendly_fire_grace_period
end

PlayerProjectileImpactUnitExtension.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	self.locomotion_extension = ScriptUnit.extension(arg_2_2, "projectile_locomotion_system")
end

PlayerProjectileImpactUnitExtension.update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	PlayerProjectileImpactUnitExtension.super.update(self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)

	local impact_type = self.impact_type
	local static_impact_type = self.static_impact_type

	if impact_type == "raycast" then
		self:update_raycast(arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	elseif impact_type == "sphere_sweep" then
		if static_impact_type == "sphere_sweep" then
			self:update_sphere_sweep(arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, self.radius, self.enemy_collision_filter)
			self:update_sphere_sweep(arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, self.radius * 0.25, self.static_collision_filter)
		elseif static_impact_type == "raycast" then
			self:update_sphere_sweep(arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, self.radius, self.enemy_collision_filter)
			self:update_raycast(arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, self.static_collision_filter)
		else
			self:update_sphere_sweep(arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, self.radius, self.collision_filter)
		end
	else
		local action_lookup_data = self.action_lookup_data
		local item_template_name = action_lookup_data.item_template_name
		local action_name = action_lookup_data.action_name
		local sub_action_name = action_lookup_data.sub_action_name

		fassert(false, "Unsupported impact type %q in projectile spawned by %q - %q - %q", impact_type, item_template_name, action_name, sub_action_name)
	end
end

local num = 1
local num_2 = 3
local num_3 = 4

PlayerProjectileImpactUnitExtension.update_raycast = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	-- function 4
	local locomotion_extension = self.locomotion_extension

	if not locomotion_extension:moved_this_frame() then
		return
	end

	local last_position = locomotion_extension:last_position()
	local current_position = locomotion_extension:current_position()
	local physics_world = self.physics_world
	local flag = arg_4_6 or self.collision_filter
	local last_position_2 = self.last_position

	if not last_position_2 then
		self:_do_raycast(arg_4_1, last_position_2:unbox(), last_position, physics_world, flag, arg_4_5)
	else
		last_position_2 = Vector3Box()
		self.last_position = last_position_2
	end

	last_position_2:store(last_position)
	self:_do_raycast(arg_4_1, last_position, current_position, physics_world, flag, arg_4_5)
end

PlayerProjectileImpactUnitExtension._do_raycast = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	-- function 5
	local num_4 = arg_5_3 - arg_5_2
	local length = Vector3.length(num_4)
	local normalize = Vector3.normalize(num_4)

	PhysicsWorld.prepare_actors_for_raycast(arg_5_4, arg_5_2, normalize, 0, 1, length * length)

	local var_5_3 = Vector3(0, 0, self.scene_query_height_offset)
	local immediate_raycast = PhysicsWorld.immediate_raycast(arg_5_4, arg_5_2 + var_5_3, normalize, length, "all", "collision_filter", arg_5_5)

	if not immediate_raycast then
		return
	end

	local count = #immediate_raycast

	for i = 1, count do
		local var_5_6 = immediate_raycast[i]
		local var_5_7 = var_5_6[num]
		local var_5_8 = var_5_6[num_2]
		local var_5_9 = var_5_6[num_3]
		local unit = Actor.unit(var_5_9)

		if not self:_valid_target(arg_5_1, unit, self._owner_unit, arg_5_6) then
			local num_actors = Unit.num_actors(unit)
			local var_5_12

			for j = 0, num_actors - 1 do
				if var_5_9 == Unit.actor(unit, j) then
					var_5_12 = j

					break
				end
			end

			fassert(var_5_12, "No actor index found for unit [\"%s\"] that was hit on actor [\"%s\"]", unit, var_5_9)
			self:impact(unit, var_5_7, normalize, var_5_8, var_5_12)
		end
	end
end

PlayerProjectileImpactUnitExtension.update_sphere_sweep = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7)
	-- function 6
	local locomotion_extension = self.locomotion_extension

	if not locomotion_extension:moved_this_frame() then
		return
	end

	local var_6_1 = Vector3(0, 0, self.scene_query_height_offset)
	local num = locomotion_extension:last_position() + var_6_1
	local num_2 = locomotion_extension:current_position() + var_6_1
	local physics_world = self.physics_world

	PhysicsWorld.prepare_actors_for_raycast(physics_world, num, Vector3.normalize(num_2 - num), 0, 1, Vector3.length_squared(num_2 - num))

	local linear_sphere_sweep = PhysicsWorld.linear_sphere_sweep(physics_world, num, num_2, arg_6_6, 100, "collision_filter", arg_6_7, "report_initial_overlap")

	if not linear_sphere_sweep then
		local normalize = Vector3.normalize(num_2 - num)
		local count = #linear_sphere_sweep

		for i = 1, count do
			local var_6_8 = linear_sphere_sweep[i]
			local position = var_6_8.position
			local normal = var_6_8.normal
			local actor = var_6_8.actor
			local unit = Actor.unit(actor)

			if not self:_valid_target(arg_6_1, unit, self.owner_unit, arg_6_5) then
				local num_actors = Unit.num_actors(unit)
				local var_6_14

				for j = 0, num_actors - 1 do
					if actor == Unit.actor(unit, j) then
						var_6_14 = j

						break
					end
				end

				fassert(var_6_14, "No actor index found for unit [\"%s\"] that was hit on actor [\"%s\"]", unit, actor)
				self:impact(unit, position, normalize, normal, var_6_14)
			end
		end
	end
end

PlayerProjectileImpactUnitExtension._valid_target = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	if arg_7_1 == arg_7_2 or arg_7_3 == arg_7_2 or not Unit.is_frozen(arg_7_2) then
		return false
	end

	if not (self._dont_target_friendly or not (arg_7_4 < self._friendly_fire_grace_period)) then
		local side = Managers.state.side

		if not (not side.side_by_unit[arg_7_2] and side:is_enemy(self.owner_unit, arg_7_2)) then
			return false
		end
	end

	if not (not self._dont_target_patrols and not AiUtils.is_part_of_patrol(arg_7_1) and AiUtils.is_aggroed(arg_7_1)) then
		return false
	end

	return true
end
