-- chunkname: @scripts/unit_extensions/generic/generic_death_extension.lua

require("scripts/unit_extensions/generic/death_reactions")

GenericDeathExtension = class(GenericDeathExtension)

GenericDeathExtension.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	self.network_type = extension_init_data.is_husk

	local is_husk_2 = extension_init_data.is_husk

	if not is_husk_2 then
		-- Nothing
	end

	is_husk_2 = not Managers.player.is_server

	local is_husk = is_husk_2

	::label_1_0::

	self.is_husk = is_husk

	local flag

	flag = (not is_husk or not "husk") and not not "unit"
	self.network_type = flag
	self.is_alive = true
	self.unit = unit
	self.extension_init_data = extension_init_data
	self.wall_nail_data = {}
	self.second_hit_ragdoll = not extension_init_data.disable_second_hit_ragdoll
end

GenericDeathExtension.freeze = function (self)
	-- function 2
	self.play_effect = nil
	self.despawn_after_time = nil
end

GenericDeathExtension.override_death_behavior = function (self, despawn_after_time, play_effect)
	-- function 3
	self.despawn_after_time = despawn_after_time
	self.play_effect = play_effect
end

GenericDeathExtension.force_end = function (self)
	-- function 4
	if not self.death_is_done and Unit.alive(self.unit) and not self.is_alive then
		Managers.state.unit_spawner:mark_for_deletion(self.unit)

		self.death_is_done = true
	end
end

GenericDeathExtension.is_wall_nailed = function (self)
	-- function 5
	local flag

	flag = (not next(self.wall_nail_data) or not true) and not not false

	return flag
end

GenericDeathExtension.nailing_hit = function (self, hit_ragdoll_actor, attack_direction, hit_speed)
	-- function 6
	fassert(Vector3.is_valid(attack_direction), "Attack direction is not valid.")

	local data = self.wall_nail_data
	local var_6_0 = data[hit_ragdoll_actor]

	var_6_0 = not not var_6_0 or not not {
		attack_direction = Vector3Box(attack_direction),
		hit_speed = hit_speed
	}
	data[hit_ragdoll_actor] = var_6_0
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
