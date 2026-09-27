-- chunkname: @scripts/settings/dlcs/belladonna/belladonna_aim_templates.lua

local AimTemplates = AimTemplates

AimTemplates = AimTemplates or {}
AimTemplates = AimTemplates

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	-- function 1
	local is_using_head_constraint = arg_1_1.is_using_head_constraint

	if not (is_using_head_constraint or arg_1_6) then
		arg_1_1.is_using_head_constraint = true

		local animation_event = Unit.animation_event
		local var_1_2 = arg_1_0
		local look_at_on_animation = arg_1_1.look_at_on_animation

		look_at_on_animation = look_at_on_animation or "look_at_on"

		animation_event(var_1_2, look_at_on_animation)
	end

	if not (not arg_1_3 and Unit.alive(arg_1_3)) then
		AiUtils.set_default_anim_constraint(arg_1_0, arg_1_5)

		return
	end

	local var_1_4
	local has_extension = ScriptUnit.has_extension(arg_1_3, "first_person_system")

	if has_extension ~= nil then
		var_1_4 = has_extension:current_position()
	else
		local node = Unit.node(arg_1_3, "j_head")

		var_1_4 = Unit.world_position(arg_1_3, node)
	end

	local world_rotation = Unit.world_rotation(arg_1_0, 0)
	local flat = Vector3.flat(Quaternion.forward(world_rotation))
	local normalize = Vector3.normalize(flat)
	local var_1_10 = POSITION_LOOKUP[arg_1_0]
	local flat_2 = Vector3.flat(var_1_4 - var_1_10)
	local normalize_2 = Vector3.normalize(flat_2)

	if Vector3.dot(normalize_2, normalize) < math.inverse_sqrt_2 then
		local z = var_1_4.z
		local flat_3 = Vector3.flat(Quaternion.right(world_rotation))

		if Vector3.cross(normalize, normalize_2).z > 0 then
			var_1_4 = var_1_10 + (flat - flat_3) * arg_1_4
		else
			var_1_4 = var_1_10 + (flat + flat_3) * arg_1_4
		end

		var_1_4.z = z
	end

	if not (not is_using_head_constraint and arg_1_1.lerp_aiming_disabled) then
		local unbox = arg_1_1.previous_look_target:unbox()
		local min = math.min(arg_1_2 * 5, 1)

		var_1_4 = Vector3.lerp(unbox, var_1_4, min)
	end

	arg_1_1.previous_look_target:store(var_1_4)
	Unit.animation_set_constraint_target(arg_1_0, arg_1_5, var_1_4)
end

AimTemplates.ungor_archer = {
	owner = {
		init = function (arg_2_0, arg_2_1)
			-- function 2
			arg_2_1.blackboard = BLACKBOARDS[arg_2_0]
			arg_2_1.ai_extension = ScriptUnit.extension(arg_2_0, "ai_system")
			arg_2_1.head_constraint_target = Unit.animation_find_constraint_target(arg_2_0, "aim_bow_target")
			arg_2_1.previous_look_target = Vector3Box()
			arg_2_1.look_at_on_animation = "aim_bow_on"
		end,
		update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
			-- function 3
			local blackboard = arg_3_3.blackboard
			local current_action_name = arg_3_3.ai_extension:current_action_name()
			local game = Managers.state.network:game()
			local go_id = Managers.state.unit_storage:go_id(arg_3_0)
			local flag = false
			local target_dist = blackboard.target_dist
			local breed = blackboard.breed
			local target_unit = blackboard.target_unit
			local head_constraint_target = arg_3_3.head_constraint_target

			if not (not target_unit and Unit.alive(target_unit)) then
				AiUtils.set_default_anim_constraint(arg_3_0, head_constraint_target)

				return
			end

			local game_object_or_level_id, var_3_10 = Managers.state.network:game_object_or_level_id(target_unit)
			local flag_2 = current_action_name == "fire_projectile"

			if var_3_10 or not flag_2 then
				local look_at_range = breed.look_at_range

				look_at_range = look_at_range or 30

				if target_dist < look_at_range then
					flag = true
				end
			end

			local has_extension = ScriptUnit.has_extension(arg_3_0, "death_system")

			if not has_extension and not has_extension:has_death_started() then
				flag = false
			end

			if not flag then
				local previous_aim_target_unit = arg_3_3.previous_aim_target_unit

				arg_3_3.lerp_aiming_disabled = true

				if not DEDICATED_SERVER then
					fn(arg_3_0, arg_3_3, arg_3_2, target_unit, target_dist, head_constraint_target)
				end

				if target_unit ~= previous_aim_target_unit then
					local go_id_2 = Managers.state.unit_storage:go_id(target_unit)

					if not game and not go_id and not go_id_2 then
						arg_3_3.previous_aim_target_unit = target_unit
					end
				end
			elseif not arg_3_3.is_using_head_constraint then
				arg_3_3.is_using_head_constraint = false

				Unit.animation_event(arg_3_0, "aim_bow_off")
			end
		end,
		leave = function (arg_4_0, arg_4_1)
			-- function 4
			if not arg_4_1.is_using_head_constraint then
				arg_4_1.is_using_head_constraint = false

				Unit.animation_event(arg_4_0, "aim_bow_off")
			end
		end
	},
	husk = {
		init = function (arg_5_0, arg_5_1)
			-- function 5
			arg_5_1.head_constraint_target = Unit.animation_find_constraint_target(arg_5_0, "aim_bow_target")
			arg_5_1.previous_look_target = Vector3Box()
			arg_5_1.look_at_on_animation = "aim_bow_on"
		end,
		update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
			-- function 6
			local game = Managers.state.network:game()
			local unit_storage = Managers.state.unit_storage
			local go_id = unit_storage:go_id(arg_6_0)

			if not game and not go_id then
				local game_object_field = GameSession.game_object_field(game, go_id, "bt_action_name")
				local var_6_4 = NetworkLookup.bt_action_names[game_object_field]
				local flag = false

				if var_6_4 == "fire_projectile" then
					flag = true
				end

				if not flag then
					local game_object_field_2 = GameSession.game_object_field(game, go_id, "target_unit_id")

					if game_object_field_2 ~= NetworkConstants.invalid_game_object_id then
						local unit = unit_storage:unit(game_object_field_2)
						local flag_2 = not unit and Vector3.distance(POSITION_LOOKUP[arg_6_0], POSITION_LOOKUP[unit])
						local head_constraint_target = arg_6_3.head_constraint_target

						arg_6_3.lerp_aiming_disabled = true

						if not (not unit and Unit.has_node(unit, "j_head")) then
							fn(arg_6_0, arg_6_3, arg_6_2, unit, flag_2, head_constraint_target)
						end
					end
				elseif not arg_6_3.is_using_head_constraint then
					arg_6_3.is_using_head_constraint = false

					Unit.animation_event(arg_6_0, "aim_bow_off")
				end
			end
		end,
		leave = function (arg_7_0, arg_7_1)
			-- function 7
			if not arg_7_1.is_using_head_constraint then
				arg_7_1.is_using_head_constraint = false

				Unit.animation_event(arg_7_0, "aim_bow_off")
			end
		end
	}
}
