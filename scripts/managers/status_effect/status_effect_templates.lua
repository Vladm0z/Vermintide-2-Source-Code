-- chunkname: @scripts/managers/status_effect/status_effect_templates.lua

StatusEffectTemplates = {}

local function var_0_0(arg_1_0)
	local var_1_0 = Managers.player:owner(arg_1_0)

	return var_1_0 and var_1_0.bot_player
end

local var_0_1 = {
	default_timed_duration = 7,
	on_applied = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		local var_2_0 = {}
		local var_2_1 = arg_2_2.link_object
		local var_2_2 = var_2_1 and Unit.has_node(arg_2_0, var_2_1) and Unit.node(arg_2_0, var_2_1) or 0
		local var_2_3 = Unit.get_data(arg_2_0, "breed")
		local var_2_4 = var_2_3 and var_2_3.status_effect_settings

		if not var_2_4 then
			return
		end

		local var_2_5 = var_2_4 and var_2_4.category or "small"
		local var_2_6 = arg_2_2.particle_by_category
		local var_2_7 = var_2_6 and var_2_6[var_2_5]

		if var_2_7 then
			local var_2_8 = arg_2_0
			local var_2_9 = ScriptUnit.has_extension(arg_2_0, "cosmetic_system")

			var_2_8 = var_2_9 and var_2_9:get_third_person_mesh_unit() or var_2_8

			local var_2_10 = ScriptUnit.has_extension(arg_2_0, "ai_inventory_system")

			var_2_8 = var_2_10 and var_2_10:get_skin_unit() or var_2_8

			local var_2_11 = arg_2_2.unit_material_variable

			if var_2_11 then
				ScriptUnit.set_material_variable(var_2_8, var_2_11.variable_name, var_2_11.value, true)
			end

			local var_2_12 = ScriptWorld.create_particles_linked(arg_2_3, var_2_7, var_2_8, var_2_2, "destroy")

			var_2_0.particle_id = var_2_12
			var_2_0.attach_unit = var_2_8

			local var_2_13 = arg_2_2.particle_material_variable

			if arg_2_2.particle_material_variable then
				local var_2_14 = var_2_13.cloud_name
				local var_2_15 = var_2_13.variable_name
				local var_2_16 = var_2_13.value

				ScriptWorld.set_material_variable_for_particles(arg_2_3, var_2_12, var_2_14, var_2_15, var_2_16)
			end

			local var_2_17 = arg_2_2.sfx

			if var_2_17 then
				local var_2_18 = Managers.world:wwise_world(arg_2_3)

				WwiseWorld.trigger_event(var_2_18, var_2_17, arg_2_0)
			end
		end

		local var_2_19 = ScriptUnit.has_extension(arg_2_0, "first_person_system")

		if var_2_19 and not var_0_0(arg_2_0) then
			local var_2_20 = arg_2_2.screen_space_fx

			if var_2_20 then
				var_2_0.screen_space_fx_id = var_2_19:create_screen_particles(var_2_20)
			end

			local var_2_21 = arg_2_2.mood

			if var_2_21 then
				Managers.state.camera:set_mood(var_2_21, arg_2_1, true)
			end

			local var_2_22 = arg_2_2.hud_sound

			if var_2_22 then
				var_2_19:play_hud_sound_event(var_2_22)
			end
		end

		if arg_2_2.career_state then
			ScriptUnit.extension(arg_2_0, "career_system"):set_state(arg_2_2.career_state)
		end

		return var_2_0
	end,
	on_increment = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		if not arg_3_4 then
			return
		end

		if not arg_3_4.death and not HEALTH_ALIVE[arg_3_0] then
			local var_3_0 = arg_3_2.death_unit_material_variable

			if var_3_0 then
				local var_3_1 = var_3_0.variable_name
				local var_3_2 = var_3_0.value
				local var_3_3 = arg_3_4.attach_unit or arg_3_0

				ScriptUnit.set_material_variable(var_3_3, var_3_1, var_3_2, true)
			end

			if arg_3_2.death_flow_event then
				UNIT_FLOW_EVENT(arg_3_0, arg_3_2.death_flow_event)
			end

			arg_3_4.death = true
		end
	end,
	on_removed = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		if not arg_4_4 then
			return
		end

		local var_4_0 = arg_4_4.particle_id

		if var_4_0 then
			World.destroy_particles(arg_4_3, var_4_0)

			if arg_4_4.stop_sfx then
				local var_4_1 = Managers.world:wwise_world(arg_4_3)

				WwiseWorld.trigger_event(var_4_1, arg_4_4.stop_sfx, arg_4_0)
			end
		end

		if arg_4_2.career_state then
			ScriptUnit.extension(arg_4_0, "career_system"):set_state("default")
		end

		local var_4_2 = ScriptUnit.has_extension(arg_4_0, "first_person_system")

		if var_4_2 and not var_0_0(arg_4_0) then
			local var_4_3 = arg_4_4.screen_space_fx_id

			if var_4_3 then
				var_4_2:stop_spawning_screen_particles(var_4_3)
			end

			local var_4_4 = arg_4_2.remove_screen_space_fx

			if var_4_4 then
				var_4_2:create_screen_particles(var_4_4)
			end

			local var_4_5 = arg_4_2.mood

			if var_4_5 then
				Managers.state.camera:set_mood(var_4_5, arg_4_1, false)
			end

			local var_4_6 = arg_4_2.remove_hud_sound

			if var_4_6 then
				var_4_2:play_hud_sound_event(var_4_6)
			end
		end
	end
}

StatusEffectTemplates.burning = table.clone(var_0_1)
StatusEffectTemplates.burning.link_object = "j_hips"
StatusEffectTemplates.burning.unit_material_variable = {
	variable_name = "dissolve_emissive",
	value = {
		7,
		1,
		0.02
	}
}
StatusEffectTemplates.burning.death_unit_material_variable = {
	variable_name = "dissolve_emissive",
	value = {
		7,
		1,
		0.02
	}
}
StatusEffectTemplates.burning.particle_material_variable = {
	variable_name = "remap_index",
	value = 0,
	cloud_name = "fire"
}
StatusEffectTemplates.burning.sfx = "Play_enemy_on_fire_loop"
StatusEffectTemplates.burning.stop_sfx = "Stop_enemy_on_fire_loop"
StatusEffectTemplates.burning.death_flow_event = "burn_death"
StatusEffectTemplates.burning.particle_by_category = {
	small = "fx/chr_impact_fire_small_remap",
	medium = "fx/chr_impact_fire_medium_remap",
	large = "fx/chr_impact_fire_large_remap"
}
StatusEffectTemplates.burning_death_critical = table.clone(StatusEffectTemplates.burning)
StatusEffectTemplates.burning_death_critical.default_timed_duration = 2

StatusEffectTemplates.burning_death_critical.on_applied = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = StatusEffectTemplates.burning.on_applied(arg_5_0, arg_5_1, arg_5_2, arg_5_3)

	UNIT_FLOW_EVENT(arg_5_0, "burn_death_critical")

	return var_5_0
end

StatusEffectTemplates.burning_death_critical.on_decrement = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	if arg_6_4.burning_death_decremented then
		return
	end

	arg_6_4.burning_death_decremented = true

	local var_6_0 = Unit.get_data(arg_6_0, "breed")
	local var_6_1 = var_6_0 and var_6_0.status_effect_settings

	if not var_6_1 or var_6_1.category ~= "small" then
		return
	end

	local var_6_2 = StatusEffectTemplates.burning_death_critical
	local var_6_3 = arg_6_4.attach_unit or arg_6_0
	local var_6_4 = 0
	local var_6_5 = var_6_2.link_object

	if var_6_5 then
		var_6_4 = Unit.has_node(var_6_3, var_6_5) and Unit.node(var_6_3, var_6_5) or 0
	end

	local var_6_6 = ScriptWorld.create_particles_linked(arg_6_3, "fx/chr_impact_burnup_fire_small_remap", var_6_3, var_6_4, "destroy")
	local var_6_7 = arg_6_2.particle_material_variable

	if arg_6_2.particle_material_variable then
		local var_6_8 = var_6_7.value
		local var_6_9 = var_6_7.variable_name

		ScriptWorld.set_material_variable_for_particles(arg_6_3, var_6_6, "remap_fire", var_6_9, var_6_8)
		ScriptWorld.set_material_variable_for_particles(arg_6_3, var_6_6, "remap_fire2", var_6_9, var_6_8)
	end

	Managers.state.status_effect:remove_all_statuses(arg_6_0, true)
end

StatusEffectTemplates.burning_warpfire = table.clone(StatusEffectTemplates.burning)
StatusEffectTemplates.burning_warpfire.particle_by_category = {
	small = "fx/chr_impact_fire_small_remap"
}
StatusEffectTemplates.burning_warpfire.unit_material_variable.value = {
	2,
	5,
	0.02
}
StatusEffectTemplates.burning_warpfire.death_unit_material_variable = nil
StatusEffectTemplates.burning_warpfire.particle_material_variable.value = 2
StatusEffectTemplates.burning_warpfire_death_critical = table.clone(StatusEffectTemplates.burning_death_critical)
StatusEffectTemplates.burning_warpfire_death_critical.unit_material_variable.value = {
	2,
	5,
	0.02
}
StatusEffectTemplates.burning_warpfire_death_critical.death_unit_material_variable = nil
StatusEffectTemplates.burning_warpfire_death_critical.particle_material_variable.value = 2
StatusEffectTemplates.burning_elven_magic = table.clone(StatusEffectTemplates.burning)
StatusEffectTemplates.burning_elven_magic.unit_material_variable.value = {
	0.22,
	0.2,
	3
}
StatusEffectTemplates.burning_elven_magic.death_unit_material_variable = nil
StatusEffectTemplates.burning_elven_magic.particle_material_variable.value = 3
StatusEffectTemplates.burning_elven_magic_death_critical = table.clone(StatusEffectTemplates.burning_death_critical)
StatusEffectTemplates.burning_elven_magic_death_critical.unit_material_variable.value = {
	0.22,
	0.2,
	3
}
StatusEffectTemplates.burning_elven_magic_death_critical.death_unit_material_variable = nil
StatusEffectTemplates.burning_elven_magic_death_critical.particle_material_variable.value = 3
StatusEffectTemplates.burning_balefire = table.clone(StatusEffectTemplates.burning)
StatusEffectTemplates.burning_balefire.unit_material_variable.value = {
	0.02,
	5,
	3
}
StatusEffectTemplates.burning_balefire.death_unit_material_variable = nil
StatusEffectTemplates.burning_balefire.particle_material_variable.value = 1
StatusEffectTemplates.burning_balefire_death_critical = table.clone(StatusEffectTemplates.burning_death_critical)
StatusEffectTemplates.burning_balefire_death_critical.unit_material_variable.value = {
	0.02,
	5,
	3
}
StatusEffectTemplates.burning_balefire_death_critical.death_unit_material_variable = nil
StatusEffectTemplates.burning_balefire_death_critical.particle_material_variable.value = 1
StatusEffectTemplates.poisoned = table.clone(var_0_1)
StatusEffectTemplates.poisoned.particle_by_category = {
	small = "fx/chr_impact_poison_small",
	medium = "fx/chr_impact_poison_medium"
}
StatusEffectTemplates.poisoned.link_object = "root_point"
StatusEffectTemplates.invis_ranger = table.clone(var_0_1)
StatusEffectTemplates.invis_ranger.screen_space_fx = "fx/screenspace_ranger_skill_01"
StatusEffectTemplates.invis_ranger.remove_screen_space_fx = "fx/screenspace_ranger_skill_02"
StatusEffectTemplates.invis_ranger.mood = "skill_ranger"
StatusEffectTemplates.invis_ranger.hud_sound = "Play_career_ability_bardin_ranger_loop"
StatusEffectTemplates.invis_ranger.remove_hud_sound = "Stop_career_ability_bardin_ranger_loop"
StatusEffectTemplates.invis_ranger.career_state = "bardin_activate_ranger"

local var_0_2 = table.keys(StatusEffectTemplates)

StatusEffectNames = table.enum(unpack(var_0_2))
StatusEffectBalefireOverrides = {
	[StatusEffectNames.burning] = StatusEffectNames.burning_balefire,
	[StatusEffectNames.burning_death_critical] = StatusEffectNames.burning_balefire_death_critical
}
