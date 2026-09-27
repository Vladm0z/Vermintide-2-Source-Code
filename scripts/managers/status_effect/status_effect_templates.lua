-- chunkname: @scripts/managers/status_effect/status_effect_templates.lua

StatusEffectTemplates = {}

local function fn(arg_1_0)
	-- function 1
	local owner = Managers.player:owner(arg_1_0)

	return not owner and owner.bot_player
end

local tbl = {
	default_timed_duration = 7,
	on_applied = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		-- function 2
		local tbl = {}
		local link_object = arg_2_2.link_object
		local node

		if not link_object and not Unit.has_node(arg_2_0, link_object) then
			node = Unit.node(arg_2_0, link_object)

			if not node then
				-- Nothing
			end
		end

		node = 0

		::label_2_0::

		local get_data = Unit.get_data(arg_2_0, "breed")
		local flag = not get_data and get_data.status_effect_settings

		if not flag then
			return
		end

		local category

		if not flag then
			category = flag.category

			if not category then
				-- Nothing
			end
		end

		category = "small"

		::label_2_1::

		local particle_by_category = arg_2_2.particle_by_category
		local flag_2 = not particle_by_category and particle_by_category[category]

		if not flag_2 then
			local var_2_8 = arg_2_0
			local has_extension = ScriptUnit.has_extension(arg_2_0, "cosmetic_system")

			var_2_8 = not has_extension and has_extension:get_third_person_mesh_unit() and var_2_8

			local has_extension_2 = ScriptUnit.has_extension(arg_2_0, "ai_inventory_system")

			var_2_8 = not has_extension_2 and has_extension_2:get_skin_unit() and var_2_8

			local unit_material_variable = arg_2_2.unit_material_variable

			if not unit_material_variable then
				ScriptUnit.set_material_variable(var_2_8, unit_material_variable.variable_name, unit_material_variable.value, true)
			end

			local create_particles_linked = ScriptWorld.create_particles_linked(arg_2_3, flag_2, var_2_8, node, "destroy")

			tbl.particle_id = create_particles_linked
			tbl.attach_unit = var_2_8

			local particle_material_variable = arg_2_2.particle_material_variable

			if not arg_2_2.particle_material_variable then
				local cloud_name = particle_material_variable.cloud_name
				local variable_name = particle_material_variable.variable_name
				local value = particle_material_variable.value

				ScriptWorld.set_material_variable_for_particles(arg_2_3, create_particles_linked, cloud_name, variable_name, value)
			end

			local sfx = arg_2_2.sfx

			if not sfx then
				local wwise_world = Managers.world:wwise_world(arg_2_3)

				WwiseWorld.trigger_event(wwise_world, sfx, arg_2_0)
			end
		end

		local has_extension_3 = ScriptUnit.has_extension(arg_2_0, "first_person_system")

		if not (not has_extension_3 and fn(arg_2_0)) then
			local screen_space_fx = arg_2_2.screen_space_fx

			if not screen_space_fx then
				tbl.screen_space_fx_id = has_extension_3:create_screen_particles(screen_space_fx)
			end

			local mood = arg_2_2.mood

			if not mood then
				Managers.state.camera:set_mood(mood, arg_2_1, true)
			end

			local hud_sound = arg_2_2.hud_sound

			if not hud_sound then
				has_extension_3:play_hud_sound_event(hud_sound)
			end
		end

		if not arg_2_2.career_state then
			ScriptUnit.extension(arg_2_0, "career_system"):set_state(arg_2_2.career_state)
		end

		return tbl
	end,
	on_increment = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		-- function 3
		if not arg_3_4 then
			return
		end

		if not (arg_3_4.death or HEALTH_ALIVE[arg_3_0]) then
			local death_unit_material_variable = arg_3_2.death_unit_material_variable

			if not death_unit_material_variable then
				local variable_name = death_unit_material_variable.variable_name
				local value = death_unit_material_variable.value
				local attach_unit = arg_3_4.attach_unit

				attach_unit = attach_unit or arg_3_0

				ScriptUnit.set_material_variable(attach_unit, variable_name, value, true)
			end

			if not arg_3_2.death_flow_event then
				UNIT_FLOW_EVENT(arg_3_0, arg_3_2.death_flow_event)
			end

			arg_3_4.death = true
		end
	end,
	on_removed = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		-- function 4
		if not arg_4_4 then
			return
		end

		local particle_id = arg_4_4.particle_id

		if not particle_id then
			World.destroy_particles(arg_4_3, particle_id)

			if not arg_4_4.stop_sfx then
				local wwise_world = Managers.world:wwise_world(arg_4_3)

				WwiseWorld.trigger_event(wwise_world, arg_4_4.stop_sfx, arg_4_0)
			end
		end

		if not arg_4_2.career_state then
			ScriptUnit.extension(arg_4_0, "career_system"):set_state("default")
		end

		local has_extension = ScriptUnit.has_extension(arg_4_0, "first_person_system")

		if not (not has_extension and fn(arg_4_0)) then
			local screen_space_fx_id = arg_4_4.screen_space_fx_id

			if not screen_space_fx_id then
				has_extension:stop_spawning_screen_particles(screen_space_fx_id)
			end

			local remove_screen_space_fx = arg_4_2.remove_screen_space_fx

			if not remove_screen_space_fx then
				has_extension:create_screen_particles(remove_screen_space_fx)
			end

			local mood = arg_4_2.mood

			if not mood then
				Managers.state.camera:set_mood(mood, arg_4_1, false)
			end

			local remove_hud_sound = arg_4_2.remove_hud_sound

			if not remove_hud_sound then
				has_extension:play_hud_sound_event(remove_hud_sound)
			end
		end
	end
}

StatusEffectTemplates.burning = table.clone(tbl)
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
	-- function 5
	local on_applied = StatusEffectTemplates.burning.on_applied(arg_5_0, arg_5_1, arg_5_2, arg_5_3)

	UNIT_FLOW_EVENT(arg_5_0, "burn_death_critical")

	return on_applied
end

StatusEffectTemplates.burning_death_critical.on_decrement = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	if not arg_6_4.burning_death_decremented then
		return
	end

	arg_6_4.burning_death_decremented = true

	local get_data = Unit.get_data(arg_6_0, "breed")
	local flag = not get_data and get_data.status_effect_settings

	if not (not flag and flag.category == "small") then
		return
	end

	local burning_death_critical = StatusEffectTemplates.burning_death_critical
	local attach_unit = arg_6_4.attach_unit

	attach_unit = attach_unit or arg_6_0

	local num = 0
	local link_object = burning_death_critical.link_object

	if not link_object then
		num = not Unit.has_node(attach_unit, link_object) and Unit.node(attach_unit, link_object) and 0
	end

	local create_particles_linked = ScriptWorld.create_particles_linked(arg_6_3, "fx/chr_impact_burnup_fire_small_remap", attach_unit, num, "destroy")
	local particle_material_variable = arg_6_2.particle_material_variable

	if not arg_6_2.particle_material_variable then
		local value = particle_material_variable.value
		local variable_name = particle_material_variable.variable_name

		ScriptWorld.set_material_variable_for_particles(arg_6_3, create_particles_linked, "remap_fire", variable_name, value)
		ScriptWorld.set_material_variable_for_particles(arg_6_3, create_particles_linked, "remap_fire2", variable_name, value)
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
StatusEffectTemplates.poisoned = table.clone(tbl)
StatusEffectTemplates.poisoned.particle_by_category = {
	small = "fx/chr_impact_poison_small",
	medium = "fx/chr_impact_poison_medium"
}
StatusEffectTemplates.poisoned.link_object = "root_point"
StatusEffectTemplates.invis_ranger = table.clone(tbl)
StatusEffectTemplates.invis_ranger.screen_space_fx = "fx/screenspace_ranger_skill_01"
StatusEffectTemplates.invis_ranger.remove_screen_space_fx = "fx/screenspace_ranger_skill_02"
StatusEffectTemplates.invis_ranger.mood = "skill_ranger"
StatusEffectTemplates.invis_ranger.hud_sound = "Play_career_ability_bardin_ranger_loop"
StatusEffectTemplates.invis_ranger.remove_hud_sound = "Stop_career_ability_bardin_ranger_loop"
StatusEffectTemplates.invis_ranger.career_state = "bardin_activate_ranger"

local keys = table.keys(StatusEffectTemplates)

StatusEffectNames = table.enum(unpack(keys))
StatusEffectBalefireOverrides = {
	[StatusEffectNames.burning] = StatusEffectNames.burning_balefire,
	[StatusEffectNames.burning_death_critical] = StatusEffectNames.burning_balefire_death_critical
}
