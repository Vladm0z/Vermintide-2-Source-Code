-- chunkname: @scripts/entity_system/systems/sound_environment/sound_environment_system_dummy.lua

require("foundation/scripts/util/api_verification")
require("scripts/entity_system/systems/sound_environment/sound_environment_system")

SoundEnvironmentSystemDummy = class(SoundEnvironmentSystemDummy, ExtensionSystemBase)

local RPCS = {}
local extensions = {}

SoundEnvironmentSystemDummy.init = function (self, entity_system_creation_context, system_name)
	-- function 1
	SoundEnvironmentSystemDummy.super.init(self, entity_system_creation_context, system_name, extensions)

	local world = self.world

	self.wwise_world = Managers.world:wwise_world(world)
end

SoundEnvironmentSystemDummy.register_sound_environment = function (self, volume_name, prio, ambient_sound_event, fade_time, aux_bus_name, environment_state)
	-- function 2
	return
end

SoundEnvironmentSystemDummy.set_source_environment = function (self, source, position)
	-- function 3
	return
end

SoundEnvironmentSystemDummy.register_source_environment_update = function (self, source, unit, object)
	-- function 4
	return
end

SoundEnvironmentSystemDummy.unregister_source_environment_update = function (self, source)
	-- function 5
	return
end

SoundEnvironmentSystemDummy.local_player_created = function (self, player)
	-- function 6
	return
end

SoundEnvironmentSystemDummy.update = function (self, context, t)
	-- function 7
	return
end

SoundEnvironmentSystemDummy.enter_environment = function (self, t, volume_name, current_environment_name)
	-- function 8
	return
end

ApiVerification.ensure_public_api(SoundEnvironmentSystem, SoundEnvironmentSystemDummy)
