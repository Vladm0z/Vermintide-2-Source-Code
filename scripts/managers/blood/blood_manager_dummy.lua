-- chunkname: @scripts/managers/blood/blood_manager_dummy.lua

require("foundation/scripts/util/api_verification")
require("scripts/managers/blood/blood_manager")

BloodManagerDummy = class(BloodManagerDummy)

BloodManagerDummy.init = function (self, world)
	-- function 1
	return
end

BloodManagerDummy.update = function (self, dt, t)
	-- function 2
	return
end

BloodManagerDummy.get_blood_enabled = function (self)
	-- function 3
	return
end

BloodManagerDummy.despawn_blood_ball = function (self, unit)
	-- function 4
	return
end

BloodManagerDummy.clear_blood_decals = function (self)
	-- function 5
	return
end

BloodManagerDummy.clear_unit_decals = function (self, unit)
	-- function 6
	return
end

BloodManagerDummy.clear_weapon_blood = function (self, attacker, weapon)
	-- function 7
	return
end

BloodManagerDummy.add_blood_ball = function (self, position, direction, damage_type, hit_unit)
	-- function 8
	return
end

BloodManagerDummy.add_weapon_blood = function (self, attacker, damage_type)
	-- function 9
	return
end

BloodManagerDummy.add_enemy_blood = function (self, position, normal, actor)
	-- function 10
	return
end

BloodManagerDummy.play_screen_space_blood = function (self, particle_name, position, optional_offset, option_rotation_offset, optional_scale)
	-- function 11
	return
end

BloodManagerDummy.destroy = function (self)
	-- function 12
	return
end

BloodManagerDummy.update_blood_enabled = function (self, blood_enabled)
	-- function 13
	return
end

BloodManagerDummy.update_num_blood_decals = function (self, num_blood_decals)
	-- function 14
	return
end

BloodManagerDummy.update_screen_blood_enabled = function (self, screen_blood_enabled)
	-- function 15
	return
end

BloodManagerDummy.update_dismemberment_enabled = function (self, dismemberment_enabled)
	-- function 16
	return
end

BloodManagerDummy.update_ragdoll_enabled = function (self, ragdoll_enabled)
	-- function 17
	return
end

ApiVerification.ensure_public_api(BloodManager, BloodManagerDummy)
