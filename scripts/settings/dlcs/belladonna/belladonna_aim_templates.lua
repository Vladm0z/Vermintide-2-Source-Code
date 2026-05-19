-- chunkname: @scripts/settings/dlcs/belladonna/belladonna_aim_templates.lua

AimTemplates = AimTemplates or {}

local function var_0_0(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	local var_1_0 = arg_1_1.is_using_head_constraint

	if not var_1_0 and not arg_1_6 then
		arg_1_1.is_using_head_constraint = true

		Unit.animation_event(arg_1_0, arg_1_1.look_at_on_animation or "look_at_on")
	end

	if not arg_1_3 or not Unit.alive(arg_1_3) then
		AiUtils.set_default_anim_constraint(arg_1_0, arg_1_5)

		return
	end

	local var_1_1
	local var_1_2 = ScriptUnit.has_extension(arg_1_3, "first_person_system")

	if var_1_2 ~= nil then
		var_1_1 = var_1_2:current_position()
	else
		local var_1_3 = Unit.node(arg_1_3, "j_head")

		var_1_1 = Unit.world_position(arg_1_3, var_1_3)
	end

	local var_1_4 = Unit.world_rotation(arg_1_0, 0)
	local var_1_5 = Vector3.flat(Quaternion.forward(var_1_4))
	local var_1_6 = Vector3.normalize(var_1_5)
	local var_1_7 = POSITION_LOOKUP[arg_1_0]
	local var_1_8 = Vector3.flat(var_1_1 - var_1_7)
	local var_1_9 = Vector3.normalize(var_1_8)

	if Vector3.dot(var_1_9, var_1_6) < math.inverse_sqrt_2 then
		local var_1_10 = var_1_1.z
		local var_1_11 = Vector3.flat(Quaternion.right(var_1_4))

		if Vector3.cross(var_1_6, var_1_9).z > 0 then
			var_1_1 = var_1_7 + (var_1_5 - var_1_11) * arg_1_4
		else
			var_1_1 = var_1_7 + (var_1_5 + var_1_11) * arg_1_4
		end

		var_1_1.z = var_1_10
	end

	if var_1_0 and not arg_1_1.lerp_aiming_disabled then
		local var_1_12 = arg_1_1.previous_look_target:unbox()
		local var_1_13 = math.min(arg_1_2 * 5, 1)

		var_1_1 = Vector3.lerp(var_1_12, var_1_1, var_1_13)
	end

	arg_1_1.previous_look_target:store(var_1_1)
	Unit.animation_set_constraint_target(arg_1_0, arg_1_5, var_1_1)
end

AimTemplates.ungor_archer = {
	owner = {
		init = function(arg_2_0, arg_2_1)
			arg_2_1.blackboard = BLACKBOARDS[arg_2_0]
			arg_2_1.ai_extension = ScriptUnit.extension(arg_2_0, "ai_system")
			arg_2_1.head_constraint_target = Unit.animation_find_constraint_target(arg_2_0, "aim_bow_target")
			arg_2_1.previous_look_target = Vector3Box()
			arg_2_1.look_at_on_animation = "aim_bow_on"
		end,
		update = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
			local var_3_0 = arg_3_3.blackboard
			local var_3_1 = arg_3_3.ai_extension:current_action_name()
			local var_3_2 = Managers.state.network:game()
			local var_3_3 = Managers.state.unit_storage:go_id(arg_3_0)
			local var_3_4 = false
			local var_3_5 = var_3_0.target_dist
			local var_3_6 = var_3_0.breed
			local var_3_7 = var_3_0.target_unit
			local var_3_8 = arg_3_3.head_constraint_target

			if not var_3_7 or not Unit.alive(var_3_7) then
				AiUtils.set_default_anim_constraint(arg_3_0, var_3_8)

				return
			end

			local var_3_9, var_3_10 = Managers.state.network:game_object_or_level_id(var_3_7)
			local var_3_11 = var_3_1 == "fire_projectile"

			if not var_3_10 and var_3_11 and var_3_5 < (var_3_6.look_at_range or 30) then
				var_3_4 = true
			end

			local var_3_12 = ScriptUnit.has_extension(arg_3_0, "death_system")

			if var_3_12 and var_3_12:has_death_started() then
				var_3_4 = false
			end

			if var_3_4 then
				local var_3_13 = arg_3_3.previous_aim_target_unit

				arg_3_3.lerp_aiming_disabled = true

				if not DEDICATED_SERVER then
					var_0_0(arg_3_0, arg_3_3, arg_3_2, var_3_7, var_3_5, var_3_8)
				end

				if var_3_7 ~= var_3_13 then
					local var_3_14 = Managers.state.unit_storage:go_id(var_3_7)

					if var_3_2 and var_3_3 and var_3_14 then
						arg_3_3.previous_aim_target_unit = var_3_7
					end
				end
			elseif arg_3_3.is_using_head_constraint then
				arg_3_3.is_using_head_constraint = false

				Unit.animation_event(arg_3_0, "aim_bow_off")
			end
		end,
		leave = function(arg_4_0, arg_4_1)
			if arg_4_1.is_using_head_constraint then
				arg_4_1.is_using_head_constraint = false

				Unit.animation_event(arg_4_0, "aim_bow_off")
			end
		end
	},
	husk = {
		init = function(arg_5_0, arg_5_1)
			arg_5_1.head_constraint_target = Unit.animation_find_constraint_target(arg_5_0, "aim_bow_target")
			arg_5_1.previous_look_target = Vector3Box()
			arg_5_1.look_at_on_animation = "aim_bow_on"
		end,
		update = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
			local var_6_0 = Managers.state.network:game()
			local var_6_1 = Managers.state.unit_storage
			local var_6_2 = var_6_1:go_id(arg_6_0)

			if var_6_0 and var_6_2 then
				local var_6_3 = GameSession.game_object_field(var_6_0, var_6_2, "bt_action_name")
				local var_6_4 = NetworkLookup.bt_action_names[var_6_3]
				local var_6_5 = false

				if var_6_4 == "fire_projectile" then
					var_6_5 = true
				end

				if var_6_5 then
					local var_6_6 = GameSession.game_object_field(var_6_0, var_6_2, "target_unit_id")

					if var_6_6 ~= NetworkConstants.invalid_game_object_id then
						local var_6_7 = var_6_1:unit(var_6_6)
						local var_6_8 = var_6_7 and Vector3.distance(POSITION_LOOKUP[arg_6_0], POSITION_LOOKUP[var_6_7])
						local var_6_9 = arg_6_3.head_constraint_target

						arg_6_3.lerp_aiming_disabled = true

						if var_6_7 and Unit.has_node(var_6_7, "j_head") then
							var_0_0(arg_6_0, arg_6_3, arg_6_2, var_6_7, var_6_8, var_6_9)
						end
					end
				elseif arg_6_3.is_using_head_constraint then
					arg_6_3.is_using_head_constraint = false

					Unit.animation_event(arg_6_0, "aim_bow_off")
				end
			end
		end,
		leave = function(arg_7_0, arg_7_1)
			if arg_7_1.is_using_head_constraint then
				arg_7_1.is_using_head_constraint = false

				Unit.animation_event(arg_7_0, "aim_bow_off")
			end
		end
	}
}
