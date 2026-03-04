-- chunkname: @scripts/managers/blood/blood_manager_dummy.lua

require("foundation/scripts/util/api_verification")
require("scripts/managers/blood/blood_manager")

BloodManagerDummy = class(BloodManagerDummy)

function BloodManagerDummy.init(arg_1_0, arg_1_1)
	return
end

function BloodManagerDummy.update(arg_2_0, arg_2_1, arg_2_2)
	return
end

function BloodManagerDummy.get_blood_enabled(arg_3_0)
	return
end

function BloodManagerDummy.despawn_blood_ball(arg_4_0, arg_4_1)
	return
end

function BloodManagerDummy.clear_blood_decals(arg_5_0)
	return
end

function BloodManagerDummy.clear_unit_decals(arg_6_0, arg_6_1)
	return
end

function BloodManagerDummy.clear_weapon_blood(arg_7_0, arg_7_1, arg_7_2)
	return
end

function BloodManagerDummy.add_blood_ball(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	return
end

function BloodManagerDummy.add_weapon_blood(arg_9_0, arg_9_1, arg_9_2)
	return
end

function BloodManagerDummy.add_enemy_blood(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	return
end

function BloodManagerDummy.play_screen_space_blood(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	return
end

function BloodManagerDummy.destroy(arg_12_0)
	return
end

function BloodManagerDummy.update_blood_enabled(arg_13_0, arg_13_1)
	return
end

function BloodManagerDummy.update_num_blood_decals(arg_14_0, arg_14_1)
	return
end

function BloodManagerDummy.update_screen_blood_enabled(arg_15_0, arg_15_1)
	return
end

function BloodManagerDummy.update_dismemberment_enabled(arg_16_0, arg_16_1)
	return
end

function BloodManagerDummy.update_ragdoll_enabled(arg_17_0, arg_17_1)
	return
end

ApiVerification.ensure_public_api(BloodManager, BloodManagerDummy)
