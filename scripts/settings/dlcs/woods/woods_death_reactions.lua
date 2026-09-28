-- chunkname: @scripts/settings/dlcs/woods/woods_death_reactions.lua

local death_reactions = {
	thorn_wall = {
		unit = {
			pre_start = function (unit, context, t, killing_blow)
				-- function 1
				return
			end,
			start = function (unit, context, t, killing_blow, is_server)
				-- function 2
				local door_extension = ScriptUnit.extension(unit, "door_system")

				door_extension.dead = true

				door_extension:update_nav_graphs()

				local thorn_wall_extension = ScriptUnit.has_extension(unit, "props_system")

				if thorn_wall_extension then
					thorn_wall_extension:die()
				end
			end,
			update = function (unit, dt, context, t, data)
				-- function 3
				return DeathReactions.IS_DONE
			end
		},
		husk = {
			pre_start = function (unit, context, t, killing_blow)
				-- function 4
				return
			end,
			start = function (unit, context, t, killing_blow, is_server)
				-- function 5
				local thorn_wall_extension = ScriptUnit.has_extension(unit, "props_system")

				if thorn_wall_extension then
					thorn_wall_extension:die()
				end
			end,
			update = function (unit, dt, context, t, data)
				-- function 6
				return DeathReactions.IS_DONE
			end
		}
	}
}

return death_reactions
