-- chunkname: @scripts/unit_extensions/generic/generic_hit_reaction_extension.lua

require("scripts/unit_extensions/generic/hit_reactions")
require("scripts/settings/breeds")
require("scripts/utils/hit_reactions_template_compiler")
require("scripts/helpers/damage_utils")

local HitTemplates = HitTemplates
local Dismemberments = Dismemberments
local SoundEvents = SoundEvents
local script_data = script_data

GenericHitReactionExtension = class(GenericHitReactionExtension)

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local has_node = Unit.has_node(arg_1_0, "j_spine1")

	has_node = not has_node and Unit.node(arg_1_0, "j_spine1")

	if not has_node then
		local world_rotation = Unit.world_rotation(arg_1_0, has_node)

		if not Quaternion.is_valid(world_rotation) then
			return "front"
		end

		local forward = Quaternion.forward(world_rotation)

		if not Vector3.is_valid(forward) then
			return "front"
		end

		forward.z = 0

		local var_1_3 = Vector3(arg_1_1.x, arg_1_1.y, 0)

		if Vector3.dot(Vector3.normalize(var_1_3), Vector3.normalize(forward)) < 0 then
			return "front"
		end
	end

	return "back"
end

local function fn_2(arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	local var_2_0
	local var_2_1

	if not (not Unit.alive(arg_2_0) and arg_2_2) then
		if not ScriptUnit.has_extension(arg_2_0, "first_person_system") then
			arg_2_0 = ScriptUnit.extension(arg_2_0, "first_person_system"):get_first_person_unit()
		end

		local world_rotation = Unit.world_rotation(arg_2_0, 0)

		var_2_0 = Quaternion.forward(world_rotation)
		var_2_0.z = 0
		var_2_0 = Vector3.normalize(var_2_0)
		var_2_1 = Quaternion.right(world_rotation)
		var_2_1.z = 0
		var_2_1 = Vector3.normalize(var_2_1)
	else
		var_2_0 = arg_2_1
		var_2_1 = Vector3.cross(Vector3(0, 0, 1), var_2_0)
	end

	return var_2_0, var_2_1
end

local function fn_3(arg_3_0, arg_3_1)
	-- function 3
	if type(arg_3_1) == "table" then
		for i = 1, #arg_3_1 do
			if arg_3_1[i] == arg_3_0 then
				return true
			end
		end

		return false
	else
		return arg_3_1 == arg_3_0
	end
end

local function fn_4(self, arg_4_1)
	-- function 4
	local conditions = arg_4_1.conditions

	for k, v in pairs(conditions) do
		if not fn_3(self[k], v) then
			return false
		elseif not (self.death ~= true or conditions.death == true) then
			return false
		end
	end

	return true
end

local function fn_5(self, arg_5_1, ...)
	-- function 5
	if type(self) == "table" then
		local count = #self

		for i = 1, count do
			arg_5_1(self[i], ...)
		end
	else
		arg_5_1(self, ...)
	end
end

local function fn_6(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local look = Quaternion.look(arg_6_2)

	World.create_particles(arg_6_1, arg_6_0, arg_6_3, look)
end

local function fn_7(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7)
	-- function 7
	fassert(SoundEvents[arg_7_0], "Could not find sound event %q in any template", arg_7_0)

	local var_7_0 = SoundEvents[arg_7_0][tostring(arg_7_7)]

	WwiseWorld.trigger_event(arg_7_1, var_7_0, arg_7_2)
end

local function fn_8(arg_8_0, arg_8_1)
	-- function 8
	if not (arg_8_0 ~= "dismember_torso" or Unit.has_animation_state_machine(arg_8_1)) then
		return
	end

	Unit.flow_event(arg_8_1, arg_8_0)
end

local is_player_unit = DamageUtils.is_player_unit

GenericHitReactionExtension.init = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	self.world = arg_9_1.world
	self.is_husk = arg_9_3.is_husk
	self.unit = arg_9_2
	self.is_server = Managers.player.is_server

	if arg_9_3.is_husk == nil then
		self.is_husk = not Managers.player.is_server
	end

	local hit_reaction_template = arg_9_3.hit_reaction_template

	hit_reaction_template = hit_reaction_template or Unit.get_data(arg_9_2, "hit_reaction")
	self.hit_reaction_template = hit_reaction_template

	fassert(self.hit_reaction_template)

	self.hit_effect_template = arg_9_3.hit_effect_template
end

GenericHitReactionExtension.set_hit_effect_template_id = function (self, arg_10_1)
	-- function 10
	self.hit_effect_template = arg_10_1
end

GenericHitReactionExtension.extensions_ready = function (self, arg_11_1, arg_11_2)
	-- function 11
	self.health_extension = ScriptUnit.extension(arg_11_2, "health_system")

	fassert(self.health_extension)

	self.death_extension = ScriptUnit.extension(arg_11_2, "death_system")

	local has_extension = ScriptUnit.has_extension(arg_11_2, "dialogue_system")

	has_extension = not has_extension and ScriptUnit.extension(arg_11_2, "dialogue_system")
	self.dialogue_extension = has_extension

	local has_extension_2 = ScriptUnit.has_extension(arg_11_2, "locomotion_system")

	has_extension_2 = not has_extension_2 and ScriptUnit.extension(arg_11_2, "locomotion_system")
	self.locomotion_extension = has_extension_2

	local has_extension_3 = ScriptUnit.has_extension(arg_11_2, "ai_system")

	has_extension_3 = not has_extension_3 and ScriptUnit.extension(arg_11_2, "ai_system")
	self.ai_extension = has_extension_3

	local breed

	if not BLACKBOARDS[arg_11_2] then
		breed = BLACKBOARDS[arg_11_2].breed

		if not breed then
			-- Nothing
		end
	end

	breed = nil

	::label_11_0::

	self._breed = breed
end

GenericHitReactionExtension.destroy = function (arg_12_0)
	-- function 12
	return
end

GenericHitReactionExtension.unfreeze = function (self)
	-- function 13
	self._delayed_animation = nil
	self._delayed_flow = nil
	self._delayed_push = nil
end

GenericHitReactionExtension.reset = function (arg_14_0)
	-- function 14
	return
end

local STRIDE = DamageDataIndex.STRIDE
local DAMAGE_AMOUNT = DamageDataIndex.DAMAGE_AMOUNT
local DAMAGE_TYPE = DamageDataIndex.DAMAGE_TYPE
local tbl = {}
local tbl_2 = {}
local tbl_3 = {}

GenericHitReactionExtension.update = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	if not self._delayed_flow then
		fn_5(self._delayed_flow, fn_8, arg_15_1)

		self._delayed_flow = nil

		return
	end

	if not self._delayed_animation then
		if not Unit.has_animation_state_machine(arg_15_1) then
			Unit.animation_event(arg_15_1, self._delayed_animation)
		end

		self._delayed_animation = nil

		return
	end

	if not self._delayed_push then
		if not self:_do_push(arg_15_1, arg_15_3) then
			self._delayed_push = nil
		end

		return
	end

	local health_extension = self.health_extension
	local recent_damages, var_15_2 = health_extension:recent_damages()

	if var_15_2 == 0 then
		return
	end

	local num = -1000
	local var_15_4
	local var_15_5 = STRIDE

	for i = 1, var_15_2, var_15_5 do
		local var_15_6 = recent_damages[i + DAMAGE_AMOUNT - 1]
		local var_15_7 = recent_damages[i + DAMAGE_TYPE - 1]

		if self.hit_reaction_template == "player" then
			local tbl_4 = {}

			pack_index[var_15_5](tbl_4, 1, unpack_index[var_15_5](recent_damages, i))

			local var_15_9 = tbl_4[DamageDataIndex.ATTACKER]

			Managers.state.game_mode:player_hit(arg_15_1, var_15_9, tbl_4)
		end

		if not (var_15_7 == "heal" or not (num < var_15_6) or not (var_15_6 >= 0)) then
			num = var_15_6
			var_15_4 = i
		end
	end

	if num < 0 then
		return
	end

	pack_index[var_15_5](tbl, 1, unpack_index[var_15_5](recent_damages, var_15_4))

	local is_alive = health_extension:is_alive()
	local flag = not is_alive

	if not is_alive then
		HitReactions.get_reaction(self.hit_reaction_template, self.is_husk)(arg_15_1, arg_15_3, arg_15_4, arg_15_5, tbl)
	end

	if not self.hit_effect_template then
		return
	end

	local var_15_12 = tbl[DamageDataIndex.DAMAGE_TYPE]
	local unbox = Vector3Aux.unbox(tbl[DamageDataIndex.POSITION])
	local unbox_2 = Vector3Aux.unbox(tbl[DamageDataIndex.DIRECTION])
	local var_15_15 = tbl[DamageDataIndex.HIT_ZONE]
	local var_15_16 = tbl[DamageDataIndex.DAMAGE_AMOUNT]
	local var_15_17 = tbl[DamageDataIndex.ATTACKER]
	local var_15_18 = tbl[DamageDataIndex.CRITICAL_HIT]
	local var_15_19 = is_player_unit(var_15_17)
	local var_15_20 = tbl[DamageDataIndex.DAMAGE_SOURCE_NAME]
	local var_15_21 = fn(arg_15_1, unbox_2)
	local flag_2 = false

	if not var_15_19 then
		flag_2 = NetworkUnit.is_husk_unit(var_15_17)
	end

	tbl_2.damage_type = var_15_12
	tbl_2.hit_zone = var_15_15
	tbl_2.hit_position = unbox
	tbl_2.hit_direction = var_15_21
	tbl_2.death = flag
	tbl_2.weapon_type = var_15_20
	tbl_2.is_husk = flag_2
	tbl_2.damage = var_15_16 > 0
	tbl_2.is_critical_strike = var_15_18

	if not self.ai_extension then
		tbl_2.action = self.ai_extension:current_action_name()
	end

	local _resolve_effects, var_15_24 = self:_resolve_effects(tbl_2, tbl_3)
	local var_15_25 = tbl_2
	local has_extension = ScriptUnit.has_extension(var_15_17, "buff_system")

	var_15_25.force_dismember = not has_extension and has_extension:has_buff_perk("bloody_mess")

	for j = 1, var_15_24 do
		self:_execute_effect(arg_15_1, _resolve_effects[j], tbl, var_15_25, arg_15_5, arg_15_3)
	end
end

GenericHitReactionExtension._resolve_effects = function (self, arg_16_1, arg_16_2)
	-- function 16
	local hit_effect_template = self.hit_effect_template
	local var_16_1 = HitTemplates[hit_effect_template]

	fassert(var_16_1, "Hit effect template %q does not exist", hit_effect_template)

	local num = 0

	for i = 1, #var_16_1 do
		local var_16_3 = var_16_1[i]

		if not fn_4(arg_16_1, var_16_3) then
			num = num + 1
			arg_16_2[num] = var_16_3

			break
		end
	end

	return arg_16_2, num
end

GenericHitReactionExtension._can_wall_nail = function (self, arg_17_1)
	-- function 17
	if not arg_17_1.disable_wall_nail then
		return false
	end

	if arg_17_1.do_dismember or not self._delayed_flow then
		return false
	end

	local flow_event = arg_17_1.flow_event

	if not (not flow_event and type(flow_event) ~= "string") then
		if not DismemberFlowEvents[flow_event] then
			return false
		end
	elseif not (not flow_event and type(flow_event) ~= "table") then
		local count = #flow_event

		for i = 1, count do
			local var_17_2 = flow_event[i]

			if not DismemberFlowEvents[var_17_2] then
				return false
			end
		end
	elseif not flow_event then
		fassert(false, "unhandle flow_event type %s", type(flow_event))
	end

	return true
end

GenericHitReactionExtension.set_death_sound_event_id = function (self, arg_18_1)
	-- function 18
	self._death_sound_event_id = arg_18_1
end

GenericHitReactionExtension.death_sound_event_id = function (self)
	-- function 19
	return self._death_sound_event_id
end

local tbl_4 = {
	left_arm = true,
	right_arm = true,
	torso = true
}

GenericHitReactionExtension._check_for_diagonal_dismemberment = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	-- function 20
	if not Unit.actor(arg_20_1, arg_20_2) then
		return nil, false
	end

	local center_of_mass = Actor.center_of_mass(Unit.actor(arg_20_1, arg_20_2))

	if not Vector3.is_valid(center_of_mass) then
		return nil, false
	end

	local num = center_of_mass + arg_20_3 * 2
	local num_2 = center_of_mass + Vector3(0, 0, -2)
	local dot = Vector3.dot(Vector3.normalize(center_of_mass - num), Vector3.normalize(center_of_mass - num_2))
	local flag = not (dot > 0.51) or dot < 0.7
	local forward = Quaternion.forward(Unit.local_rotation(arg_20_1, 0))
	local flat_angle = Vector3.flat_angle(forward, arg_20_3)
	local var_20_7
	local flag_2

	flag_2 = (flat_angle < -math.pi * 0.75 or flat_angle > math.pi * 0.75 or nil or not (flat_angle < -math.pi * 0.25) or not "right" or not (flat_angle < math.pi * 0.25)) and (not nil or "left")

	local var_20_9
	local flag_3 = true

	if not flag and not flag_2 then
		var_20_9 = "dismember_torso_" .. flag_2

		if not (arg_20_4 == "torso" or not (math.random() > 0.5)) then
			flag_3 = false
		end
	end

	return var_20_9, flag_3
end

local tbl_5 = {
	at = true,
	de = true
}

GenericHitReactionExtension._is_dismembering_allowed = function (arg_21_0, arg_21_1)
	-- function 21
	if not IS_CONSOLE then
		if not (not arg_21_1.is_critical_strike and Managers.account:console_type_setting("allow_dismemberment")) then
			return false
		end

		local region = Managers.account:region()

		if not tbl_5[region] then
			return false
		end
	end

	return BloodSettings.dismemberment.enabled
end

local tbl_6 = {
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
local tbl_7 = {}
local tbl_8 = {}

GenericHitReactionExtension._execute_effect = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6)
	-- function 22
	local world = self.world
	local get_data = Unit.get_data(arg_22_1, "breed")
	local var_22_2 = arg_22_3[DamageDataIndex.ATTACKER]
	local unbox = Vector3Aux.unbox(arg_22_3[DamageDataIndex.DIRECTION])
	local var_22_4 = arg_22_3[DamageDataIndex.DAMAGE_TYPE]
	local hit_zone = arg_22_4.hit_zone

	if not get_data.hit_zones[hit_zone] then
		print("Error no hitzone in breed that matches hitzone:", hit_zone)

		return
	end

	local hit_zones = get_data.hit_zones

	hit_zones = not hit_zones and get_data.hit_zones[hit_zone].actors

	local death_extension = self.death_extension
	local var_22_8 = arg_22_3[DamageDataIndex.HIT_RAGDOLL_ACTOR_NAME]
	local _can_wall_nail = self:_can_wall_nail(arg_22_2)
	local flag = not death_extension and death_extension.death_has_started

	if not arg_22_2.buff then
		Managers.state.entity:system("buff_system"):add_buff(self.unit, arg_22_2.buff, var_22_2)
	end

	local timed_status = arg_22_2.timed_status

	if not timed_status then
		local has_extension = ScriptUnit.has_extension(var_22_2, "career_system")
		local flag_2 = not has_extension and has_extension:career_name()
		local var_22_14 = tbl_6[flag_2]

		if not var_22_14 then
			local var_22_15 = var_22_14[timed_status]

			timed_status = not var_22_15 and not var_22_15.damage_types[var_22_4] and var_22_15.override and timed_status
		end
	end

	if not timed_status then
		Managers.state.status_effect:add_timed_status(arg_22_1, timed_status)
	end

	local flag_3 = false
	local var_22_17 = tbl_7

	table.clear(var_22_17)

	local flow_event = arg_22_2.flow_event

	if not flow_event then
		if type(flow_event) == "table" then
			for i = 1, #flow_event do
				var_22_17[#var_22_17 + 1] = flow_event[i]
			end
		else
			var_22_17[#var_22_17 + 1] = flow_event
		end

		flag_3 = true
	end

	if not self:_is_dismembering_allowed(arg_22_4) then
		-- Nothing
	end

	::label_22_0::

	local do_dismember = arg_22_2.do_dismember

	if not do_dismember then
		do_dismember = arg_22_4.force_dismember
		do_dismember = not do_dismember and arg_22_4.death
	end

	::label_22_1::

	if not (not do_dismember and not death_extension and death_extension:is_wall_nailed()) then
		local var_22_20 = Dismemberments[get_data.name][hit_zone]
		local var_22_21
		local var_22_22

		if not arg_22_2.do_diagonal_dismemberments and not tbl_4[hit_zone] then
			var_22_21, var_22_22 = self:_check_for_diagonal_dismemberment(arg_22_1, hit_zones[1], unbox, hit_zone)
		end

		if var_22_20 or not var_22_21 then
			if not var_22_21 and not var_22_22 then
				table.clear(var_22_17)

				var_22_17[#var_22_17 + 1] = var_22_21
			else
				var_22_17[#var_22_17 + 1] = var_22_20
				var_22_17[#var_22_17 + 1] = var_22_21
			end

			flag_3 = true
		end
	end

	if not flag_3 then
		if not arg_22_4.death and not death_extension then
			if not flag and not table.contains(var_22_17, "dismember_torso") then
				flag_3 = false
			end

			local alloc_table = FrameTable.alloc_table()

			for j = 1, #var_22_17 do
				alloc_table[#alloc_table + 1] = var_22_17[j]
			end

			self._delayed_flow = alloc_table
		elseif not flag then
			flag_3 = false
		else
			fn_5(var_22_17, fn_8, arg_22_1)
		end
	end

	local locomotion_extension = self.locomotion_extension

	locomotion_extension = not locomotion_extension and self.locomotion_extension._is_falling

	if not (not _can_wall_nail and not arg_22_4.death and var_22_8 == "n/a") then
		self._delayed_animation = "ragdoll"
	elseif (self.force_ragdoll_on_death or not locomotion_extension or flag) and not arg_22_4.death then
		self._delayed_animation = "ragdoll"
	elseif not arg_22_2.animations and not Unit.has_animation_state_machine(arg_22_1) then
		local var_22_25 = Vector3(unbox.x, unbox.y, 0)
		local normalize = Vector3.normalize(var_22_25)
		local animations = arg_22_2.animations
		local angles = animations.angles

		if not angles then
			local forward = Quaternion.forward(Unit.local_rotation(arg_22_1, 0))
			local normalize_2 = Vector3.normalize(Vector3.flat(forward))
			local flag_4 = false
			local num = (math.atan2(normalize.y, normalize.x) - math.atan2(normalize_2.y, normalize_2.x)) % (math.pi * 2)

			for k = 1, #angles do
				local var_22_33 = angles[k]

				if num < var_22_33.to then
					animations = var_22_33.animations
					flag_4 = true

					break
				end
			end

			if not flag_4 then
				animations = angles[1].animations
			end
		end

		local var_22_34 = animations[math.random(#animations)]

		if not flag and not death_extension:second_hit_ragdoll_allowed() then
			var_22_34 = "ragdoll"
		elseif not flag then
			var_22_34 = nil
		end

		if not var_22_34 and flag_3 and not arg_22_4.death then
			self._delayed_animation = var_22_34
		end
	end

	local hit_effect_name = arg_22_2.hit_effect_name
	local husk_hit_effect_name = arg_22_2.husk_hit_effect_name
	local var_22_37

	if not BloodSettings.hit_effects.enabled then
		if not husk_hit_effect_name and not Unit.alive(var_22_2) and not NetworkUnit.is_network_unit(var_22_2) and not NetworkUnit.is_husk_unit(var_22_2) then
			var_22_37 = husk_hit_effect_name
		elseif not hit_effect_name then
			var_22_37 = hit_effect_name
		end
	end

	local flag_5 = not (arg_22_3[DamageDataIndex.DAMAGE_AMOUNT] > 0) or not not get_data.no_blood_splatter_on_damage or not arg_22_2.disable_blood
	local sound_event = arg_22_2.sound_event
	local var_22_40

	if var_22_37 or flag_5 or not sound_event then
		if not HEALTH_ALIVE[arg_22_1] then
			var_22_40 = Vector3Aux.unbox(arg_22_3[DamageDataIndex.POSITION])
		else
			local count = #hit_zones

			for l = 1, count do
				local var_22_42 = hit_zones[l]

				if not Unit.has_node(arg_22_1, var_22_42) then
					var_22_40 = Unit.world_position(arg_22_1, Unit.node(arg_22_1, var_22_42))

					break
				elseif not Unit.find_actor(arg_22_1, var_22_42) then
					var_22_40 = Actor.center_of_mass(Unit.actor(arg_22_1, var_22_42))

					break
				end
			end

			if not (not var_22_40 and not var_22_40 and Vector3.is_valid(var_22_40)) then
				if not Unit.has_node(arg_22_1, "c_hips") then
					var_22_40 = Unit.world_position(arg_22_1, Unit.node(arg_22_1, "c_hips"))
				elseif not Unit.find_actor(arg_22_1, "c_hips") then
					var_22_40 = Actor.center_of_mass(Unit.actor(arg_22_1, "c_hips"))
				end
			end

			if not (not var_22_40 and not var_22_40 and Vector3.is_valid(var_22_40)) then
				var_22_37 = nil
				flag_5 = nil
				sound_event = nil
			end
		end
	end

	if not flag_5 then
		Managers.state.blood:add_blood_ball(var_22_40, unbox, var_22_4, arg_22_1)
	end

	if not var_22_37 then
		fn_5(var_22_37, fn_6, world, unbox, var_22_40)
	end

	if not ((BloodSettings.ragdoll_push.enabled or not flag) and arg_22_2.push) then
		local var_22_43 = get_data.hit_zones[hit_zone]

		var_22_43 = not var_22_43 and get_data.hit_zones[hit_zone].push_actors

		if not var_22_43 then
			self._delayed_push = {
				timeout = 0.1,
				push_parameters = arg_22_2.push,
				explosion_push = arg_22_2.explosion_push,
				attacker = var_22_2,
				hit_direction_table = {
					unbox.x,
					unbox.y,
					unbox.z
				},
				push_actors = var_22_43
			}
		end
	end

	if not sound_event then
		local wwise_world = Managers.world:wwise_world(world)
		local make_auto_source = WwiseWorld.make_auto_source(wwise_world, var_22_40)

		table.clear(tbl_8)

		tbl_8.damage_type = arg_22_4.damage_type
		tbl_8.enemy_type = get_data.name
		tbl_8.weapon_type = arg_22_4.weapon_type
		tbl_8.hit_zone = hit_zone
		tbl_8.husk = NetworkUnit.is_husk_unit(arg_22_1)

		local dialogue_extension = self.dialogue_extension

		if not dialogue_extension and not dialogue_extension.wwise_voice_switch_group then
			tbl_8[dialogue_extension.wwise_voice_switch_group] = dialogue_extension.wwise_voice_switch_value
		end

		Managers.state.entity:system("sound_environment_system"):set_source_environment(make_auto_source, var_22_40)

		for k_2, v in pairs(tbl_8) do
			WwiseWorld.set_switch(wwise_world, make_auto_source, k_2, v)
		end

		fn_5(sound_event, fn_7, wwise_world, make_auto_source, tbl_8.damage_type, tbl_8.enemy_type, tbl_8.weapon_type, tbl_8.hit_zone, tbl_8.husk)
	end

	if not (not arg_22_4.death and not death_extension and flag) then
		Unit.flow_event(arg_22_1, "lua_on_death")

		death_extension.death_has_started = true
	end
end

GenericHitReactionExtension._do_push = function (self, arg_23_1, arg_23_2)
	-- function 23
	local _delayed_push = self._delayed_push
	local push_parameters = _delayed_push.push_parameters
	local hit_direction_table = _delayed_push.hit_direction_table
	local attacker = _delayed_push.attacker
	local push_actors = _delayed_push.push_actors
	local num = _delayed_push.timeout - arg_23_2
	local explosion_push = _delayed_push.explosion_push

	_delayed_push.timeout = num

	local count = #push_actors
	local var_23_8

	for i = 1, count do
		local var_23_9 = push_actors[i]

		var_23_8 = Unit.actor(arg_23_1, push_actors[i]) or var_23_8
	end

	if not var_23_8 then
		return num <= 0
	end

	local var_23_10 = Vector3(hit_direction_table[1], hit_direction_table[2], 0)
	local normalize = Vector3.normalize(var_23_10)
	local var_23_12, var_23_13 = fn_2(attacker, normalize, explosion_push or push_parameters.always_use_hit_direction)

	if Vector3.dot(var_23_13, normalize) <= 0 then
		var_23_13 = -var_23_13
	end

	local distal_force = push_parameters.distal_force

	distal_force = distal_force or 0

	local lateral_force = push_parameters.lateral_force

	lateral_force = lateral_force or 0

	local vertical_force = push_parameters.vertical_force

	vertical_force = vertical_force or 0

	local flag = not attacker and ScriptUnit.has_extension(attacker, "buff_system")

	if not flag then
		flag:trigger_procs("on_body_pushed")

		distal_force = flag:apply_buffs_to_value(distal_force, "hit_force")
		lateral_force = flag:apply_buffs_to_value(lateral_force, "hit_force")
		vertical_force = flag:apply_buffs_to_value(vertical_force, "hit_force")
	end

	local num_2 = var_23_12 * distal_force
	local num_3 = var_23_13 * lateral_force
	local var_23_20 = Vector3(0, 0, vertical_force)
	local num_4 = num_2 + num_3 + var_23_20
	local num_5 = 60
	local get_data = Unit.get_data(arg_23_1, "breed")

	if not get_data.scale_death_push then
		num_4 = num_4 * get_data.scale_death_push
	end

	local num_6 = num_4 * 0.25
	local num_7 = Vector3.normalize(num_6) * num_5
	local num_8 = Vector3.length(num_6) * 1 / count

	for j = 1, count do
		local actor = Unit.actor(arg_23_1, push_actors[j])

		if not actor then
			Actor.push(actor, num_7, num_8)
		end
	end

	return true
end
