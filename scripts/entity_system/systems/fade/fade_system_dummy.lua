-- chunkname: @scripts/entity_system/systems/fade/fade_system_dummy.lua

require("foundation/scripts/util/api_verification")
require("scripts/entity_system/systems/fade/fade_system")

FadeSystemDummy = class(FadeSystemDummy, ExtensionSystemBase)

local var_0_0 = {
	"PlayerUnitFadeExtension",
	"AIUnitFadeExtension"
}

function FadeSystemDummy.init(arg_1_0, arg_1_1, arg_1_2)
	FadeSystemDummy.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_0)
end

function FadeSystemDummy.destroy(arg_2_0)
	return
end

function FadeSystemDummy.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	return {}
end

function FadeSystemDummy.freeze(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	return
end

function FadeSystemDummy.unfreeze(arg_5_0, arg_5_1)
	return
end

function FadeSystemDummy.set_min_fade(arg_6_0, arg_6_1, arg_6_2)
	return
end

function FadeSystemDummy.new_linked_units(arg_7_0, arg_7_1, arg_7_2)
	return
end

function FadeSystemDummy.on_remove_extension(arg_8_0, arg_8_1, arg_8_2)
	return
end

function FadeSystemDummy.local_player_created(arg_9_0, arg_9_1)
	return
end

function FadeSystemDummy.update(arg_10_0, arg_10_1, arg_10_2)
	return
end

ApiVerification.ensure_public_api(FadeSystem, FadeSystemDummy)
