-- chunkname: @scripts/unit_extensions/generic/generic_death_extension.lua

require("scripts/unit_extensions/generic/death_reactions")

GenericDeathExtension = class(GenericDeathExtension)

GenericDeathExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.network_type = arg_1_3.is_husk

	local is_husk = arg_1_3.is_husk

	is_husk = is_husk or not Managers.player.is_server
	self.is_husk = is_husk

	local flag

	flag = not is_husk and "husk" and "unit"
	self.network_type = flag
	self.is_alive = true
	self.unit = arg_1_2
	self.extension_init_data = arg_1_3
	self.wall_nail_data = {}
	self.second_hit_ragdoll = not arg_1_3.disable_second_hit_ragdoll
end

GenericDeathExtension.freeze = function (self)
	-- function 2
	self.play_effect = nil
	self.despawn_after_time = nil
end

GenericDeathExtension.override_death_behavior = function (self, arg_3_1, arg_3_2)
	-- function 3
	self.despawn_after_time = arg_3_1
	self.play_effect = arg_3_2
end

GenericDeathExtension.force_end = function (self)
	-- function 4
	if not ((self.death_is_done or not Unit.alive(self.unit)) and self.is_alive) then
		Managers.state.unit_spawner:mark_for_deletion(self.unit)

		self.death_is_done = true
	end
end

GenericDeathExtension.is_wall_nailed = function (self)
	-- function 5
	local flag

	flag = not next(self.wall_nail_data) and true and false

	return flag
end

GenericDeathExtension.nailing_hit = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	fassert(Vector3.is_valid(arg_6_2), "Attack direction is not valid.")

	local wall_nail_data = self.wall_nail_data
	local var_6_1 = wall_nail_data[arg_6_1]

	var_6_1 = var_6_1 or {
		attack_direction = Vector3Box(arg_6_2),
		hit_speed = arg_6_3
	}
	wall_nail_data[arg_6_1] = var_6_1
end

GenericDeathExtension.enable_second_hit_ragdoll = function (self)
	-- function 7
	self.second_hit_ragdoll = true
end

GenericDeathExtension.second_hit_ragdoll_allowed = function (self)
	-- function 8
	return self.second_hit_ragdoll
end

GenericDeathExtension.has_death_started = function (self)
	-- function 9
	return self.death_has_started
end
