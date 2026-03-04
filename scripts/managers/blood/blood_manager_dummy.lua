-- chunkname: @scripts/managers/blood/blood_manager_dummy.lua

require("foundation/scripts/util/api_verification")
require("scripts/managers/blood/blood_manager")

BloodManagerDummy = class(BloodManagerDummy)

BloodManagerDummy.init = function (arg_1_0, arg_1_1)
	return
end

BloodManagerDummy.update = function (arg_2_0, arg_2_1, arg_2_2)
	return
end

BloodManagerDummy.get_blood_enabled = function (arg_3_0)
	return
end

BloodManagerDummy.despawn_blood_ball = function (arg_4_0, arg_4_1)
	return
end

BloodManagerDummy.clear_blood_decals = function (arg_5_0)
	return
end

BloodManagerDummy.clear_unit_decals = function (arg_6_0, arg_6_1)
	return
end

BloodManagerDummy.clear_weapon_blood = function (arg_7_0, arg_7_1, arg_7_2)
	return
end

BloodManagerDummy.add_blood_ball = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	return
end

BloodManagerDummy.add_weapon_blood = function (arg_9_0, arg_9_1, arg_9_2)
	return
end

BloodManagerDummy.add_enemy_blood = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	return
end

BloodManagerDummy.play_screen_space_blood = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	return
end

BloodManagerDummy.destroy = function (arg_12_0)
	return
end

BloodManagerDummy.update_blood_enabled = function (arg_13_0, arg_13_1)
	return
end

BloodManagerDummy.update_num_blood_decals = function (arg_14_0, arg_14_1)
	return
end

BloodManagerDummy.update_screen_blood_enabled = function (arg_15_0, arg_15_1)
	return
end

BloodManagerDummy.update_dismemberment_enabled = function (arg_16_0, arg_16_1)
	return
end

BloodManagerDummy.update_ragdoll_enabled = function (arg_17_0, arg_17_1)
	return
end

ApiVerification.ensure_public_api(BloodManager, BloodManagerDummy)
