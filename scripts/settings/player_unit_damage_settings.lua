-- chunkname: @scripts/settings/player_unit_damage_settings.lua

local PlayerUnitDamageSettings = PlayerUnitDamageSettings

PlayerUnitDamageSettings = not not PlayerUnitDamageSettings or not not {}
PlayerUnitDamageSettings = PlayerUnitDamageSettings
PlayerUnitDamageSettings.chance_to_shield_on_damage_amount = 2
PlayerUnitDamageSettings.chance_to_shield_on_killing_blow_amount = 4
PlayerUnitDamageSettings.GRIMOIRE_HEALTH_DEBUFF = -0.3
PlayerUnitDamageSettings.SLAYER_CURSE_HEALTH_DEBUFF = -0.02
PlayerUnitDamageSettings.REGEN_DELAY = 6
PlayerUnitDamageSettings.REGEN_AMOUNT = 20
PlayerUnitDamageSettings.REGEN_RAMP_SPEED = 1

PlayerUnitDamageSettings.REGEN_FUNCTION = function (real_t)
	-- function 1
	local t = real_t * PlayerUnitDamageSettings.REGEN_RAMP_SPEED

	return PlayerUnitDamageSettings.REGEN_AMOUNT * t * t
end

PlayerUnitDamageSettings.INSTAKILL_THRESHOLD = 100
PlayerUnitDamageSettings.INSTAKILL_HEALTH_FACTOR = 0
PlayerUnitDamageSettings.BANDAGED_HP = 120
PlayerUnitDamageSettings.REVIVED_HP = 120
PlayerUnitDamageSettings.REVIVE_TIME = 5
PlayerUnitDamageSettings.DAMAGE_VIGNETTE_BLEND_OUT = 0.3
PlayerUnitDamageSettings.DAMAGE_VIGNETTE_THRESHOLD = 2
PlayerUnitDamageSettings.MULTIPLE_HIT_MULTIPLIER = 0.5
PlayerUnitDamageSettings.LAST_DAMAGE_DEALER_RESET_TIME = 15

local PlayerUnitDamageSettings_2 = PlayerUnitDamageSettings
local stun = PlayerUnitDamageSettings.stun

stun = not not stun or not not {}
PlayerUnitDamageSettings_2.stun = stun
PlayerUnitDamageSettings.stun.duration = 0.5
PlayerUnitDamageSettings.stun.damage_threshold = 95
PlayerUnitDamageSettings.stun.damage_threshold_with_stun_property = 1
PlayerUnitDamageSettings.stun.damage_types_with_stun_property = {
	slashing = false,
	blunt = false,
	cutting = false,
	piercing = false
}
PlayerUnitDamageSettings.stun.damage_types_without_stun_property = {
	slashing = false,
	blunt = false,
	cutting = false,
	piercing = false
}

local PlayerUnitDamageSettings_3 = PlayerUnitDamageSettings
local stun_dismount = PlayerUnitDamageSettings.stun_dismount

stun_dismount = not not stun_dismount or not not {}
PlayerUnitDamageSettings_3.stun_dismount = stun_dismount
PlayerUnitDamageSettings.stun_dismount.duration = 1.6666666666666667

local PlayerUnitDamageSettings_4 = PlayerUnitDamageSettings
local stun_push = PlayerUnitDamageSettings.stun_push

stun_push = not not stun_push or not not {}
PlayerUnitDamageSettings_4.stun_push = stun_push
PlayerUnitDamageSettings.stun_push.duration = 0.75
PlayerUnitDamageSettings.stun_push.hit_penalty = 0.5
PlayerUnitDamageSettings.stun_push.cooldown = 1

local PlayerUnitDamageSettings_5 = PlayerUnitDamageSettings
local stun_shield_bash = PlayerUnitDamageSettings.stun_shield_bash

stun_shield_bash = not not stun_shield_bash or not not {}
PlayerUnitDamageSettings_5.stun_shield_bash = stun_shield_bash
PlayerUnitDamageSettings.stun_shield_bash.duration = 1.5
PlayerUnitDamageSettings.stun_shield_bash.hit_penalty = 0.1
PlayerUnitDamageSettings.stun_shield_bash.cooldown = 1

local PlayerUnitDamageSettings_6 = PlayerUnitDamageSettings
local kd_bleeding = PlayerUnitDamageSettings.kd_bleeding

kd_bleeding = not not kd_bleeding or not not {}
PlayerUnitDamageSettings_6.kd_bleeding = kd_bleeding
PlayerUnitDamageSettings.kd_bleeding.dps = 0
PlayerUnitDamageSettings.dead_player_destroy_time = 5
PlayerUnitDamageSettings.dot_types = {
	bleeding = {},
	burning = {}
}
