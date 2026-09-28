-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/ratling_gunner/ratling_gunner_state_walking.lua

RatlingGunnerStateWalking = class(RatlingGunnerStateWalking, EnemyCharacterStateWalking)

RatlingGunnerStateWalking.init = function (self, character_state_init_context)
	-- function 1
	RatlingGunnerStateWalking.super.init(self, character_state_init_context)

	self._fire_ability_id = self._career_extension:ability_id("fire")
	self._reload_ability_id = self._career_extension:ability_id("reload")
end

RatlingGunnerStateWalking.on_enter = function (self, unit, input, dt, context, t, previous_state, params)
	-- function 2
	RatlingGunnerStateWalking.super.on_enter(self, unit, input, dt, context, t, previous_state, params)

	self._left_wpn_particle_node_name = "g_ratlinggun"
	self._left_wpn_particle_name = "fx/wpnfx_gunner_enemy_in_range_1p"
end

RatlingGunnerStateWalking.debug_display_ammo = function (self)
	-- function 3
	local unit = self._unit
	local blackboard = BLACKBOARDS[unit]
	local attack_pattern_data = blackboard.attack_pattern_data

	if not attack_pattern_data then
		-- Nothing
	end

	attack_pattern_data = {}

	local data = attack_pattern_data

	::label_3_0::

	local current_ammo_2 = data.current_ammo

	if not current_ammo_2 then
		-- Nothing
	end

	current_ammo_2 = self._breed.max_ammo

	local current_ammo = current_ammo_2

	::label_3_1::

	local screen_width = RESOLUTION_LOOKUP.res_w
	local screen_height = RESOLUTION_LOOKUP.res_h
	local pos_y = screen_height * 0.85
	local pos_x = screen_width * 0.87
	local color = Color(100, 255, 0)
	local text_pos = Vector3(pos_x, pos_y, 10)
	local font_size = 40
	local string_ammo = string.format("Ammo: %2d", current_ammo)

	Debug.draw_text(string_ammo, text_pos, font_size, color)
end
