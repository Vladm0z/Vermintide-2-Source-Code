-- chunkname: @scripts/entity_system/systems/sound_environment/sound_environment_system_dummy.lua

require("foundation/scripts/util/api_verification")
require("scripts/entity_system/systems/sound_environment/sound_environment_system")

SoundEnvironmentSystemDummy = class(SoundEnvironmentSystemDummy, ExtensionSystemBase)

local var_0_0 = {}
local var_0_1 = {}

SoundEnvironmentSystemDummy.init = function (arg_1_0, arg_1_1, arg_1_2)
	SoundEnvironmentSystemDummy.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	local var_1_0 = arg_1_0.world

	arg_1_0.wwise_world = Managers.world:wwise_world(var_1_0)
end

SoundEnvironmentSystemDummy.register_sound_environment = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	return
end

SoundEnvironmentSystemDummy.set_source_environment = function (arg_3_0, arg_3_1, arg_3_2)
	return
end

SoundEnvironmentSystemDummy.register_source_environment_update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	return
end

SoundEnvironmentSystemDummy.unregister_source_environment_update = function (arg_5_0, arg_5_1)
	return
end

SoundEnvironmentSystemDummy.local_player_created = function (arg_6_0, arg_6_1)
	return
end

SoundEnvironmentSystemDummy.update = function (arg_7_0, arg_7_1, arg_7_2)
	return
end

SoundEnvironmentSystemDummy.enter_environment = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	return
end

ApiVerification.ensure_public_api(SoundEnvironmentSystem, SoundEnvironmentSystemDummy)
