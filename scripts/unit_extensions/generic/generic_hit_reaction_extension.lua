-- chunkname: @scripts/unit_extensions/generic/generic_hit_reaction_extension.lua

require("scripts/unit_extensions/generic/hit_reactions")
require("scripts/settings/breeds")
require("scripts/utils/hit_reactions_template_compiler")
require("scripts/helpers/damage_utils")

local var_0_0 = HitTemplates
local var_0_1 = Dismemberments
local var_0_2 = SoundEvents
local var_0_3 = script_data

GenericHitReactionExtension = class(GenericHitReactionExtension)

local function var_0_4(arg_1_0, arg_1_1)
	local var_1_0 = Unit.has_node(arg_1_0, "j_spine1") and Unit.node(arg_1_0, "j_spine1")

	if var_1_0 then
		local var_1_1 = Unit.world_rotation(arg_1_0, var_1_0)

		if not Quaternion.is_valid(var_1_1) then
			return "front"
		end

		local var_1_2 = Quaternion.forward(var_1_1)

		if not Vector3.is_valid(var_1_2) then
			return "front"
		end

		var_1_2.z = 0

		local var_1_3 = Vector3(arg_1_1.x, arg_1_1.y, 0)

		if Vector3.dot(Vector3.normalize(var_1_3), Vector3.normalize(var_1_2)) < 0 then
			return "front"
		end
	end

	return "back"
end

local function var_0_5(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0
	local var_2_1

	if Unit.alive(arg_2_0) and not arg_2_2 then
		if ScriptUnit.has_extension(arg_2_0, "first_person_system") then
			arg_2_0 = ScriptUnit.extension(arg_2_0, "first_person_system"):get_first_person_unit()
		end

		local var_2_2 = Unit.world_rotation(arg_2_0, 0)

		var_2_0 = Quaternion.forward(var_2_2)
		var_2_0.z = 0
		var_2_0 = Vector3.normalize(var_2_0)
		var_2_1 = Quaternion.right(var_2_2)
		var_2_1.z = 0
		var_2_1 = Vector3.normalize(var_2_1)
	else
		var_2_0 = arg_2_1
		var_2_1 = Vector3.cross(Vector3(0, 0, 1), var_2_0)
	end

	return var_2_0, var_2_1
end

local function var_0_6(arg_3_0, arg_3_1)
	if type(arg_3_1) == "table" then
		for iter_3_0 = 1, #arg_3_1 do
			if arg_3_1[iter_3_0] == arg_3_0 then
				return true
			end
		end

		return false
	else
		return arg_3_1 == arg_3_0
	end
end

local function var_0_7(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_1.conditions

	for iter_4_0, iter_4_1 in pairs(var_4_0) do
		if not var_0_6(arg_4_0[iter_4_0], iter_4_1) then
			return false
		elseif arg_4_0.death == true and var_4_0.death ~= true then
			return false
		end
	end

	return true
end

local function var_0_8(arg_5_0, arg_5_1, ...)
	if type(arg_5_0) == "table" then
		local var_5_0 = #arg_5_0

		for iter_5_0 = 1, var_5_0 do
			arg_5_1(arg_5_0[iter_5_0], ...)
		end
	else
		arg_5_1(arg_5_0, ...)
	end
end

local function var_0_9(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = Quaternion.look(arg_6_2)

	World.create_particles(arg_6_1, arg_6_0, arg_6_3, var_6_0)
end

local function var_0_10(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7)
	fassert(var_0_2[arg_7_0], "Could not find sound event %q in any template", arg_7_0)

	local var_7_0 = var_0_2[arg_7_0][tostring(arg_7_7)]

	WwiseWorld.trigger_event(arg_7_1, var_7_0, arg_7_2)
end

local function var_0_11(arg_8_0, arg_8_1)
	if arg_8_0 == "dismember_torso" and not Unit.has_animation_state_machine(arg_8_1) then
		return
	end

	Unit.flow_event(arg_8_1, arg_8_0)
end

local var_0_12 = DamageUtils.is_player_unit

function GenericHitReactionExtension.init(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	arg_9_0.world = arg_9_1.world
	arg_9_0.is_husk = arg_9_3.is_husk
	arg_9_0.unit = arg_9_2
	arg_9_0.is_server = Managers.player.is_server

	if arg_9_3.is_husk == nil then
		arg_9_0.is_husk = not Managers.player.is_server
	end

	arg_9_0.hit_reaction_template = arg_9_3.hit_reaction_template or Unit.get_data(arg_9_2, "hit_reaction")

	fassert(arg_9_0.hit_reaction_template)

	arg_9_0.hit_effect_template = arg_9_3.hit_effect_template
end

function GenericHitReactionExtension.set_hit_effect_template_id(arg_10_0, arg_10_1)
	arg_10_0.hit_effect_template = arg_10_1
end

function GenericHitReactionExtension.extensions_ready(arg_11_0, arg_11_1, arg_11_2)
	arg_11_0.health_extension = ScriptUnit.extension(arg_11_2, "health_system")

	fassert(arg_11_0.health_extension)

	arg_11_0.death_extension = ScriptUnit.extension(arg_11_2, "death_system")
	arg_11_0.dialogue_extension = ScriptUnit.has_extension(arg_11_2, "dialogue_system") and ScriptUnit.extension(arg_11_2, "dialogue_system")
	arg_11_0.locomotion_extension = ScriptUnit.has_extension(arg_11_2, "locomotion_system") and ScriptUnit.extension(arg_11_2, "locomotion_system")
	arg_11_0.ai_extension = ScriptUnit.has_extension(arg_11_2, "ai_system") and ScriptUnit.extension(arg_11_2, "ai_system")
	arg_11_0._breed = BLACKBOARDS[arg_11_2] and BLACKBOARDS[arg_11_2].breed or nil
end

function GenericHitReactionExtension.destroy(arg_12_0)
	return
end

function GenericHitReactionExtension.unfreeze(arg_13_0)
	arg_13_0._delayed_animation = nil
	arg_13_0._delayed_flow = nil
	arg_13_0._delayed_push = nil
end

function GenericHitReactionExtension.reset(arg_14_0)
	return
end

local var_0_13 = DamageDataIndex.STRIDE
local var_0_14 = DamageDataIndex.DAMAGE_AMOUNT
local var_0_15 = DamageDataIndex.DAMAGE_TYPE
local var_0_16 = {}
local var_0_17 = {}
local var_0_18 = {}

function GenericHitReactionExtension.update(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	if arg_15_0._delayed_flow then
		var_0_8(arg_15_0._delayed_flow, var_0_11, arg_15_1)

		arg_15_0._delayed_flow = nil

		return
	end

	if arg_15_0._delayed_animation then
		if Unit.has_animation_state_machine(arg_15_1) then
			Unit.animation_event(arg_15_1, arg_15_0._delayed_animation)
		end

		arg_15_0._delayed_animation = nil

		return
	end

	if arg_15_0._delayed_push then
		if arg_15_0:_do_push(arg_15_1, arg_15_3) then
			arg_15_0._delayed_push = nil
		end

		return
	end

	local var_15_0 = arg_15_0.health_extension
	local var_15_1, var_15_2 = var_15_0:recent_damages()

	if var_15_2 == 0 then
		return
	end

	local var_15_3 = -1000
	local var_15_4
	local var_15_5 = var_0_13

	for iter_15_0 = 1, var_15_2, var_15_5 do
		local var_15_6 = var_15_1[iter_15_0 + var_0_14 - 1]
		local var_15_7 = var_15_1[iter_15_0 + var_0_15 - 1]

		if arg_15_0.hit_reaction_template == "player" then
			local var_15_8 = {}

			pack_index[var_15_5](var_15_8, 1, unpack_index[var_15_5](var_15_1, iter_15_0))

			local var_15_9 = var_15_8[DamageDataIndex.ATTACKER]

			Managers.state.game_mode:player_hit(arg_15_1, var_15_9, var_15_8)
		end

		if var_15_7 ~= "heal" and var_15_3 < var_15_6 and var_15_6 >= 0 then
			var_15_3 = var_15_6
			var_15_4 = iter_15_0
		end
	end

	if var_15_3 < 0 then
		return
	end

	pack_index[var_15_5](var_0_16, 1, unpack_index[var_15_5](var_15_1, var_15_4))

	local var_15_10 = var_15_0:is_alive()
	local var_15_11 = not var_15_10

	if var_15_10 then
		HitReactions.get_reaction(arg_15_0.hit_reaction_template, arg_15_0.is_husk)(arg_15_1, arg_15_3, arg_15_4, arg_15_5, var_0_16)
	end

	if not arg_15_0.hit_effect_template then
		return
	end

	local var_15_12 = var_0_16[DamageDataIndex.DAMAGE_TYPE]
	local var_15_13 = Vector3Aux.unbox(var_0_16[DamageDataIndex.POSITION])
	local var_15_14 = Vector3Aux.unbox(var_0_16[DamageDataIndex.DIRECTION])
	local var_15_15 = var_0_16[DamageDataIndex.HIT_ZONE]
	local var_15_16 = var_0_16[DamageDataIndex.DAMAGE_AMOUNT]
	local var_15_17 = var_0_16[DamageDataIndex.ATTACKER]
	local var_15_18 = var_0_16[DamageDataIndex.CRITICAL_HIT]
	local var_15_19 = var_0_12(var_15_17)
	local var_15_20 = var_0_16[DamageDataIndex.DAMAGE_SOURCE_NAME]
	local var_15_21 = var_0_4(arg_15_1, var_15_14)
	local var_15_22 = false

	if var_15_19 then
		var_15_22 = NetworkUnit.is_husk_unit(var_15_17)
	end

	var_0_17.damage_type = var_15_12
	var_0_17.hit_zone = var_15_15
	var_0_17.hit_position = var_15_13
	var_0_17.hit_direction = var_15_21
	var_0_17.death = var_15_11
	var_0_17.weapon_type = var_15_20
	var_0_17.is_husk = var_15_22
	var_0_17.damage = var_15_16 > 0
	var_0_17.is_critical_strike = var_15_18

	if arg_15_0.ai_extension then
		var_0_17.action = arg_15_0.ai_extension:current_action_name()
	end

	local var_15_23, var_15_24 = arg_15_0:_resolve_effects(var_0_17, var_0_18)
	local var_15_25 = var_0_17
	local var_15_26 = ScriptUnit.has_extension(var_15_17, "buff_system")

	var_15_25.force_dismember = var_15_26 and var_15_26:has_buff_perk("bloody_mess")

	for iter_15_1 = 1, var_15_24 do
		arg_15_0:_execute_effect(arg_15_1, var_15_23[iter_15_1], var_0_16, var_15_25, arg_15_5, arg_15_3)
	end
end

function GenericHitReactionExtension._resolve_effects(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0.hit_effect_template
	local var_16_1 = var_0_0[var_16_0]

	fassert(var_16_1, "Hit effect template %q does not exist", var_16_0)

	local var_16_2 = 0

	for iter_16_0 = 1, #var_16_1 do
		local var_16_3 = var_16_1[iter_16_0]

		if var_0_7(arg_16_1, var_16_3) then
			var_16_2 = var_16_2 + 1
			arg_16_2[var_16_2] = var_16_3

			break
		end
	end

	return arg_16_2, var_16_2
end

function GenericHitReactionExtension._can_wall_nail(arg_17_0, arg_17_1)
	if arg_17_1.disable_wall_nail then
		return false
	end

	if arg_17_1.do_dismember or arg_17_0._delayed_flow then
		return false
	end

	local var_17_0 = arg_17_1.flow_event

	if var_17_0 and type(var_17_0) == "string" then
		if DismemberFlowEvents[var_17_0] then
			return false
		end
	elseif var_17_0 and type(var_17_0) == "table" then
		local var_17_1 = #var_17_0

		for iter_17_0 = 1, var_17_1 do
			local var_17_2 = var_17_0[iter_17_0]

			if DismemberFlowEvents[var_17_2] then
				return false
			end
		end
	elseif var_17_0 then
		fassert(false, "unhandle flow_event type %s", type(var_17_0))
	end

	return true
end

function GenericHitReactionExtension.set_death_sound_event_id(arg_18_0, arg_18_1)
	arg_18_0._death_sound_event_id = arg_18_1
end

function GenericHitReactionExtension.death_sound_event_id(arg_19_0)
	return arg_19_0._death_sound_event_id
end

local var_0_19 = {
	left_arm = true,
	right_arm = true,
	torso = true
}

function GenericHitReactionExtension._check_for_diagonal_dismemberment(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	if not Unit.actor(arg_20_1, arg_20_2) then
		return nil, false
	end

	local var_20_0 = Actor.center_of_mass(Unit.actor(arg_20_1, arg_20_2))

	if not Vector3.is_valid(var_20_0) then
		return nil, false
	end

	local var_20_1 = var_20_0 + arg_20_3 * 2
	local var_20_2 = var_20_0 + Vector3(0, 0, -2)
	local var_20_3 = Vector3.dot(Vector3.normalize(var_20_0 - var_20_1), Vector3.normalize(var_20_0 - var_20_2))
	local var_20_4 = var_20_3 > 0.51 and var_20_3 < 0.7
	local var_20_5 = Quaternion.forward(Unit.local_rotation(arg_20_1, 0))
	local var_20_6 = Vector3.flat_angle(var_20_5, arg_20_3)
	local var_20_7
	local var_20_8 = (not (var_20_6 < -math.pi * 0.75) and not (var_20_6 > math.pi * 0.75) or nil) and (var_20_6 < -math.pi * 0.25 and "right" or (not (var_20_6 < math.pi * 0.25) or nil) and "left")
	local var_20_9
	local var_20_10 = true

	if var_20_4 and var_20_8 then
		var_20_9 = "dismember_torso_" .. var_20_8

		if arg_20_4 ~= "torso" and math.random() > 0.5 then
			var_20_10 = false
		end
	end

	return var_20_9, var_20_10
end

local var_0_20 = {
	at = true,
	de = true
}

function GenericHitReactionExtension._is_dismembering_allowed(arg_21_0, arg_21_1)
	if IS_CONSOLE then
		if not arg_21_1.is_critical_strike or not Managers.account:console_type_setting("allow_dismemberment") then
			return false
		end

		local var_21_0 = Managers.account:region()

		if var_0_20[var_21_0] then
			return false
		end
	end

	return BloodSettings.dismemberment.enabled
end

local var_0_21 = {
	bw_necromancer = {
		[StatusEffectNames.burning] = {
			override = StatusEffectNames.burning_balefire,
			damage_types = table.set({
				"burning_stab_fencer",
				"burning_tank",
				"heavy_burning_tank",
				"burn",
				"burn_sniper",
				"burn_shotgun",
				"burn_machinegun",
				"burn_carbine",
				"burning_smiter",
				"light_burning_linesman",
				"burning_linesman",
				"drakegun",
				"drakegun_glance"
			})
		},
		[StatusEffectNames.burning_death_critical] = {
			override = StatusEffectNames.burning_balefire_death_critical,
			damage_types = table.set({
				"burning_stab_fencer",
				"burning_tank",
				"heavy_burning_tank",
				"burn",
				"burn_sniper",
				"burn_shotgun",
				"burn_machinegun",
				"burn_carbine",
				"burning_smiter",
				"light_burning_linesman",
				"burning_linesman",
				"drakegun",
				"drakegun_glance"
			})
		}
	}
}
local var_0_22 = {}
local var_0_23 = {}

function GenericHitReactionExtension._execute_effect(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6)
	local var_22_0 = arg_22_0.world
	local var_22_1 = Unit.get_data(arg_22_1, "breed")
	local var_22_2 = arg_22_3[DamageDataIndex.ATTACKER]
	local var_22_3 = Vector3Aux.unbox(arg_22_3[DamageDataIndex.DIRECTION])
	local var_22_4 = arg_22_3[DamageDataIndex.DAMAGE_TYPE]
	local var_22_5 = arg_22_4.hit_zone

	if not var_22_1.hit_zones[var_22_5] then
		print("Error no hitzone in breed that matches hitzone:", var_22_5)

		return
	end

	local var_22_6 = var_22_1.hit_zones and var_22_1.hit_zones[var_22_5].actors
	local var_22_7 = arg_22_0.death_extension
	local var_22_8 = arg_22_3[DamageDataIndex.HIT_RAGDOLL_ACTOR_NAME]
	local var_22_9 = arg_22_0:_can_wall_nail(arg_22_2)
	local var_22_10 = var_22_7 and var_22_7.death_has_started

	if arg_22_2.buff then
		Managers.state.entity:system("buff_system"):add_buff(arg_22_0.unit, arg_22_2.buff, var_22_2)
	end

	local var_22_11 = arg_22_2.timed_status

	if var_22_11 then
		local var_22_12 = ScriptUnit.has_extension(var_22_2, "career_system")
		local var_22_13 = var_22_12 and var_22_12:career_name()
		local var_22_14 = var_0_21[var_22_13]

		if var_22_14 then
			local var_22_15 = var_22_14[var_22_11]

			var_22_11 = var_22_15 and var_22_15.damage_types[var_22_4] and var_22_15.override or var_22_11
		end
	end

	if var_22_11 then
		Managers.state.status_effect:add_timed_status(arg_22_1, var_22_11)
	end

	local var_22_16 = false
	local var_22_17 = var_0_22

	table.clear(var_22_17)

	local var_22_18 = arg_22_2.flow_event

	if var_22_18 then
		if type(var_22_18) == "table" then
			for iter_22_0 = 1, #var_22_18 do
				var_22_17[#var_22_17 + 1] = var_22_18[iter_22_0]
			end
		else
			var_22_17[#var_22_17 + 1] = var_22_18
		end

		var_22_16 = true
	end

	if arg_22_0:_is_dismembering_allowed(arg_22_4) and (arg_22_2.do_dismember or arg_22_4.force_dismember and arg_22_4.death) and (not var_22_7 or not var_22_7:is_wall_nailed()) then
		local var_22_19 = var_0_1[var_22_1.name][var_22_5]
		local var_22_20
		local var_22_21

		if arg_22_2.do_diagonal_dismemberments and var_0_19[var_22_5] then
			var_22_20, var_22_21 = arg_22_0:_check_for_diagonal_dismemberment(arg_22_1, var_22_6[1], var_22_3, var_22_5)
		end

		if var_22_19 or var_22_20 then
			if var_22_20 and var_22_21 then
				table.clear(var_22_17)

				var_22_17[#var_22_17 + 1] = var_22_20
			else
				var_22_17[#var_22_17 + 1] = var_22_19
				var_22_17[#var_22_17 + 1] = var_22_20
			end

			var_22_16 = true
		end
	end

	if var_22_16 then
		if arg_22_4.death and var_22_7 then
			if var_22_10 and table.contains(var_22_17, "dismember_torso") then
				var_22_16 = false
			end

			local var_22_22 = FrameTable.alloc_table()

			for iter_22_1 = 1, #var_22_17 do
				var_22_22[#var_22_22 + 1] = var_22_17[iter_22_1]
			end

			arg_22_0._delayed_flow = var_22_22
		elseif var_22_10 then
			var_22_16 = false
		else
			var_0_8(var_22_17, var_0_11, arg_22_1)
		end
	end

	local var_22_23 = arg_22_0.locomotion_extension and arg_22_0.locomotion_extension._is_falling

	if var_22_9 and arg_22_4.death and var_22_8 ~= "n/a" then
		arg_22_0._delayed_animation = "ragdoll"
	elseif (arg_22_0.force_ragdoll_on_death or var_22_23) and not var_22_10 and arg_22_4.death then
		arg_22_0._delayed_animation = "ragdoll"
	elseif arg_22_2.animations and Unit.has_animation_state_machine(arg_22_1) then
		local var_22_24 = Vector3(var_22_3.x, var_22_3.y, 0)
		local var_22_25 = Vector3.normalize(var_22_24)
		local var_22_26 = arg_22_2.animations
		local var_22_27 = var_22_26.angles

		if var_22_27 then
			local var_22_28 = Quaternion.forward(Unit.local_rotation(arg_22_1, 0))
			local var_22_29 = Vector3.normalize(Vector3.flat(var_22_28))
			local var_22_30 = false
			local var_22_31 = (math.atan2(var_22_25.y, var_22_25.x) - math.atan2(var_22_29.y, var_22_29.x)) % (math.pi * 2)

			for iter_22_2 = 1, #var_22_27 do
				local var_22_32 = var_22_27[iter_22_2]

				if var_22_31 < var_22_32.to then
					var_22_26 = var_22_32.animations
					var_22_30 = true

					break
				end
			end

			if not var_22_30 then
				var_22_26 = var_22_27[1].animations
			end
		end

		local var_22_33 = var_22_26[math.random(#var_22_26)]

		if var_22_10 and var_22_7:second_hit_ragdoll_allowed() then
			var_22_33 = "ragdoll"
		elseif var_22_10 then
			var_22_33 = nil
		end

		if var_22_33 and (var_22_16 or arg_22_4.death) then
			arg_22_0._delayed_animation = var_22_33
		end
	end

	local var_22_34 = arg_22_2.hit_effect_name
	local var_22_35 = arg_22_2.husk_hit_effect_name
	local var_22_36

	if BloodSettings.hit_effects.enabled then
		if var_22_35 and Unit.alive(var_22_2) and (not NetworkUnit.is_network_unit(var_22_2) or NetworkUnit.is_husk_unit(var_22_2)) then
			var_22_36 = var_22_35
		elseif var_22_34 then
			var_22_36 = var_22_34
		end
	end

	local var_22_37 = arg_22_3[DamageDataIndex.DAMAGE_AMOUNT] > 0 and not var_22_1.no_blood_splatter_on_damage and not arg_22_2.disable_blood
	local var_22_38 = arg_22_2.sound_event
	local var_22_39

	if var_22_36 or var_22_37 or var_22_38 then
		if HEALTH_ALIVE[arg_22_1] then
			var_22_39 = Vector3Aux.unbox(arg_22_3[DamageDataIndex.POSITION])
		else
			local var_22_40 = #var_22_6

			for iter_22_3 = 1, var_22_40 do
				local var_22_41 = var_22_6[iter_22_3]

				if Unit.has_node(arg_22_1, var_22_41) then
					var_22_39 = Unit.world_position(arg_22_1, Unit.node(arg_22_1, var_22_41))

					break
				elseif Unit.find_actor(arg_22_1, var_22_41) then
					var_22_39 = Actor.center_of_mass(Unit.actor(arg_22_1, var_22_41))

					break
				end
			end

			if not var_22_39 or var_22_39 and not Vector3.is_valid(var_22_39) then
				if Unit.has_node(arg_22_1, "c_hips") then
					var_22_39 = Unit.world_position(arg_22_1, Unit.node(arg_22_1, "c_hips"))
				elseif Unit.find_actor(arg_22_1, "c_hips") then
					var_22_39 = Actor.center_of_mass(Unit.actor(arg_22_1, "c_hips"))
				end
			end

			if not var_22_39 or var_22_39 and not Vector3.is_valid(var_22_39) then
				var_22_36 = nil
				var_22_37 = nil
				var_22_38 = nil
			end
		end
	end

	if var_22_37 then
		Managers.state.blood:add_blood_ball(var_22_39, var_22_3, var_22_4, arg_22_1)
	end

	if var_22_36 then
		var_0_8(var_22_36, var_0_9, var_22_0, var_22_3, var_22_39)
	end

	if (BloodSettings.ragdoll_push.enabled or not var_22_10) and arg_22_2.push then
		local var_22_42 = var_22_1.hit_zones[var_22_5] and var_22_1.hit_zones[var_22_5].push_actors

		if var_22_42 then
			arg_22_0._delayed_push = {
				timeout = 0.1,
				push_parameters = arg_22_2.push,
				explosion_push = arg_22_2.explosion_push,
				attacker = var_22_2,
				hit_direction_table = {
					var_22_3.x,
					var_22_3.y,
					var_22_3.z
				},
				push_actors = var_22_42
			}
		end
	end

	if var_22_38 then
		local var_22_43 = Managers.world:wwise_world(var_22_0)
		local var_22_44 = WwiseWorld.make_auto_source(var_22_43, var_22_39)

		table.clear(var_0_23)

		var_0_23.damage_type = arg_22_4.damage_type
		var_0_23.enemy_type = var_22_1.name
		var_0_23.weapon_type = arg_22_4.weapon_type
		var_0_23.hit_zone = var_22_5
		var_0_23.husk = NetworkUnit.is_husk_unit(arg_22_1)

		local var_22_45 = arg_22_0.dialogue_extension

		if var_22_45 and var_22_45.wwise_voice_switch_group then
			var_0_23[var_22_45.wwise_voice_switch_group] = var_22_45.wwise_voice_switch_value
		end

		Managers.state.entity:system("sound_environment_system"):set_source_environment(var_22_44, var_22_39)

		for iter_22_4, iter_22_5 in pairs(var_0_23) do
			WwiseWorld.set_switch(var_22_43, var_22_44, iter_22_4, iter_22_5)
		end

		var_0_8(var_22_38, var_0_10, var_22_43, var_22_44, var_0_23.damage_type, var_0_23.enemy_type, var_0_23.weapon_type, var_0_23.hit_zone, var_0_23.husk)
	end

	if arg_22_4.death and var_22_7 and not var_22_10 then
		Unit.flow_event(arg_22_1, "lua_on_death")

		var_22_7.death_has_started = true
	end
end

function GenericHitReactionExtension._do_push(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = arg_23_0._delayed_push
	local var_23_1 = var_23_0.push_parameters
	local var_23_2 = var_23_0.hit_direction_table
	local var_23_3 = var_23_0.attacker
	local var_23_4 = var_23_0.push_actors
	local var_23_5 = var_23_0.timeout - arg_23_2
	local var_23_6 = var_23_0.explosion_push

	var_23_0.timeout = var_23_5

	local var_23_7 = #var_23_4
	local var_23_8

	for iter_23_0 = 1, var_23_7 do
		local var_23_9 = var_23_4[iter_23_0]

		var_23_8 = Unit.actor(arg_23_1, var_23_4[iter_23_0]) or var_23_8
	end

	if not var_23_8 then
		return var_23_5 <= 0
	end

	local var_23_10 = Vector3(var_23_2[1], var_23_2[2], 0)
	local var_23_11 = Vector3.normalize(var_23_10)
	local var_23_12, var_23_13 = var_0_5(var_23_3, var_23_11, var_23_6 or var_23_1.always_use_hit_direction)

	if Vector3.dot(var_23_13, var_23_11) <= 0 then
		var_23_13 = -var_23_13
	end

	local var_23_14 = var_23_1.distal_force or 0
	local var_23_15 = var_23_1.lateral_force or 0
	local var_23_16 = var_23_1.vertical_force or 0
	local var_23_17 = var_23_3 and ScriptUnit.has_extension(var_23_3, "buff_system")

	if var_23_17 then
		var_23_17:trigger_procs("on_body_pushed")

		var_23_14 = var_23_17:apply_buffs_to_value(var_23_14, "hit_force")
		var_23_15 = var_23_17:apply_buffs_to_value(var_23_15, "hit_force")
		var_23_16 = var_23_17:apply_buffs_to_value(var_23_16, "hit_force")
	end

	local var_23_18 = var_23_12 * var_23_14
	local var_23_19 = var_23_13 * var_23_15
	local var_23_20 = Vector3(0, 0, var_23_16)
	local var_23_21 = var_23_18 + var_23_19 + var_23_20
	local var_23_22 = 60
	local var_23_23 = Unit.get_data(arg_23_1, "breed")

	if var_23_23.scale_death_push then
		var_23_21 = var_23_21 * var_23_23.scale_death_push
	end

	local var_23_24 = var_23_21 * 0.25
	local var_23_25 = Vector3.normalize(var_23_24) * var_23_22
	local var_23_26 = Vector3.length(var_23_24) * 1 / var_23_7

	for iter_23_1 = 1, var_23_7 do
		local var_23_27 = Unit.actor(arg_23_1, var_23_4[iter_23_1])

		if var_23_27 then
			Actor.push(var_23_27, var_23_25, var_23_26)
		end
	end

	return true
end
