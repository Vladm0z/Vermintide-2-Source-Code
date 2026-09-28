-- chunkname: @scripts/settings/payload_speed_settings.lua

local PayloadSpeedSettings = PayloadSpeedSettings

PayloadSpeedSettings = not not PayloadSpeedSettings or not not {}
PayloadSpeedSettings = PayloadSpeedSettings

local PayloadSpeedSettings_2 = PayloadSpeedSettings
local flat = PayloadSpeedSettings.flat

flat = not not flat or not not {}
PayloadSpeedSettings_2.flat = flat

local flat_2 = PayloadSpeedSettings.flat
local pushed = PayloadSpeedSettings.flat.pushed

pushed = not not pushed or not not {}
flat_2.pushed = pushed
PayloadSpeedSettings.flat.pushed.speed = 0.8
PayloadSpeedSettings.flat.pushed.bonus_speed_per_player = 0.05
PayloadSpeedSettings.flat.pushed.acceleration = 0.5

local flat_3 = PayloadSpeedSettings.flat
local not_pushed = PayloadSpeedSettings.flat.not_pushed

not_pushed = not not not_pushed or not not {}
flat_3.not_pushed = not_pushed
PayloadSpeedSettings.flat.not_pushed.speed = 0
PayloadSpeedSettings.flat.not_pushed.acceleration = 0.5

local PayloadSpeedSettings_3 = PayloadSpeedSettings
local uphill = PayloadSpeedSettings.uphill

uphill = not not uphill or not not {}
PayloadSpeedSettings_3.uphill = uphill

local uphill_2 = PayloadSpeedSettings.uphill
local pushed_2 = PayloadSpeedSettings.uphill.pushed

pushed_2 = not not pushed_2 or not not {}
uphill_2.pushed = pushed_2
PayloadSpeedSettings.uphill.pushed.speed = 0.4
PayloadSpeedSettings.uphill.pushed.bonus_speed_per_player = 0.05
PayloadSpeedSettings.uphill.pushed.acceleration = 1.2

local uphill_3 = PayloadSpeedSettings.uphill
local not_pushed_2 = PayloadSpeedSettings.uphill.not_pushed

not_pushed_2 = not not not_pushed_2 or not not {}
uphill_3.not_pushed = not_pushed_2
PayloadSpeedSettings.uphill.not_pushed.speed = -1
PayloadSpeedSettings.uphill.not_pushed.acceleration = 0.3

local PayloadSpeedSettings_4 = PayloadSpeedSettings
local downhill = PayloadSpeedSettings.downhill

downhill = not not downhill or not not {}
PayloadSpeedSettings_4.downhill = downhill

local downhill_2 = PayloadSpeedSettings.downhill
local pushed_3 = PayloadSpeedSettings.downhill.pushed

pushed_3 = not not pushed_3 or not not {}
downhill_2.pushed = pushed_3
PayloadSpeedSettings.downhill.pushed.speed = 1.6
PayloadSpeedSettings.downhill.pushed.bonus_speed_per_player = 0.05
PayloadSpeedSettings.downhill.pushed.acceleration = 0.5

local downhill_3 = PayloadSpeedSettings.downhill
local not_pushed_3 = PayloadSpeedSettings.downhill.not_pushed

not_pushed_3 = not not not_pushed_3 or not not {}
downhill_3.not_pushed = not_pushed_3
PayloadSpeedSettings.downhill.not_pushed.speed = 1.2
PayloadSpeedSettings.downhill.not_pushed.acceleration = 0.2

local PayloadSpeedSettings_5 = PayloadSpeedSettings
local muddy = PayloadSpeedSettings.muddy

muddy = not not muddy or not not {}
PayloadSpeedSettings_5.muddy = muddy

local muddy_2 = PayloadSpeedSettings.muddy
local pushed_4 = PayloadSpeedSettings.muddy.pushed

pushed_4 = not not pushed_4 or not not {}
muddy_2.pushed = pushed_4
PayloadSpeedSettings.muddy.pushed.speed = 0.7
PayloadSpeedSettings.muddy.pushed.bonus_speed_per_player = 0.05
PayloadSpeedSettings.muddy.pushed.acceleration = 0.5

local muddy_3 = PayloadSpeedSettings.muddy
local not_pushed_4 = PayloadSpeedSettings.muddy.not_pushed

not_pushed_4 = not not not_pushed_4 or not not {}
muddy_3.not_pushed = not_pushed_4
PayloadSpeedSettings.muddy.not_pushed.speed = 0
PayloadSpeedSettings.muddy.not_pushed.acceleration = 0.5

local PayloadSpeedSettings_6 = PayloadSpeedSettings
local small_flat = PayloadSpeedSettings.small_flat

small_flat = not not small_flat or not not {}
PayloadSpeedSettings_6.small_flat = small_flat

local small_flat_2 = PayloadSpeedSettings.small_flat
local pushed_5 = PayloadSpeedSettings.small_flat.pushed

pushed_5 = not not pushed_5 or not not {}
small_flat_2.pushed = pushed_5
PayloadSpeedSettings.small_flat.pushed.speed = 1.4
PayloadSpeedSettings.small_flat.pushed.bonus_speed_per_player = 0.05
PayloadSpeedSettings.small_flat.pushed.acceleration = 0.5

local small_flat_3 = PayloadSpeedSettings.small_flat
local not_pushed_5 = PayloadSpeedSettings.small_flat.not_pushed

not_pushed_5 = not not not_pushed_5 or not not {}
small_flat_3.not_pushed = not_pushed_5
PayloadSpeedSettings.small_flat.not_pushed.speed = 0
PayloadSpeedSettings.small_flat.not_pushed.acceleration = 0.5

local PayloadSpeedSettings_7 = PayloadSpeedSettings
local small_slowdown = PayloadSpeedSettings.small_slowdown

small_slowdown = not not small_slowdown or not not {}
PayloadSpeedSettings_7.small_slowdown = small_slowdown

local small_slowdown_2 = PayloadSpeedSettings.small_slowdown
local pushed_6 = PayloadSpeedSettings.small_slowdown.pushed

pushed_6 = not not pushed_6 or not not {}
small_slowdown_2.pushed = pushed_6
PayloadSpeedSettings.small_slowdown.pushed.speed = 0
PayloadSpeedSettings.small_slowdown.pushed.bonus_speed_per_player = 0
PayloadSpeedSettings.small_slowdown.pushed.acceleration = 0.5

local small_slowdown_3 = PayloadSpeedSettings.small_slowdown
local not_pushed_6 = PayloadSpeedSettings.small_slowdown.not_pushed

not_pushed_6 = not not not_pushed_6 or not not {}
small_slowdown_3.not_pushed = not_pushed_6
PayloadSpeedSettings.small_slowdown.not_pushed.speed = 0
PayloadSpeedSettings.small_slowdown.not_pushed.acceleration = 0.5

local PayloadSpeedSettings_8 = PayloadSpeedSettings
local small_uphill = PayloadSpeedSettings.small_uphill

small_uphill = not not small_uphill or not not {}
PayloadSpeedSettings_8.small_uphill = small_uphill

local small_uphill_2 = PayloadSpeedSettings.small_uphill
local pushed_7 = PayloadSpeedSettings.small_uphill.pushed

pushed_7 = not not pushed_7 or not not {}
small_uphill_2.pushed = pushed_7
PayloadSpeedSettings.small_uphill.pushed.speed = 1.3
PayloadSpeedSettings.small_uphill.pushed.bonus_speed_per_player = 0.05
PayloadSpeedSettings.small_uphill.pushed.acceleration = 1.2

local small_uphill_3 = PayloadSpeedSettings.small_uphill
local not_pushed_7 = PayloadSpeedSettings.small_uphill.not_pushed

not_pushed_7 = not not not_pushed_7 or not not {}
small_uphill_3.not_pushed = not_pushed_7
PayloadSpeedSettings.small_uphill.not_pushed.speed = -2.5
PayloadSpeedSettings.small_uphill.not_pushed.acceleration = 0.75

local PayloadSpeedSettings_9 = PayloadSpeedSettings
local small_downhill_slow = PayloadSpeedSettings.small_downhill_slow

small_downhill_slow = not not small_downhill_slow or not not {}
PayloadSpeedSettings_9.small_downhill_slow = small_downhill_slow

local small_downhill_slow_2 = PayloadSpeedSettings.small_downhill_slow
local pushed_8 = PayloadSpeedSettings.small_downhill_slow.pushed

pushed_8 = not not pushed_8 or not not {}
small_downhill_slow_2.pushed = pushed_8
PayloadSpeedSettings.small_downhill_slow.pushed.speed = 2
PayloadSpeedSettings.small_downhill_slow.pushed.bonus_speed_per_player = 0.05
PayloadSpeedSettings.small_downhill_slow.pushed.acceleration = 0.5

local small_downhill_slow_3 = PayloadSpeedSettings.small_downhill_slow
local not_pushed_8 = PayloadSpeedSettings.small_downhill_slow.not_pushed

not_pushed_8 = not not not_pushed_8 or not not {}
small_downhill_slow_3.not_pushed = not_pushed_8
PayloadSpeedSettings.small_downhill_slow.not_pushed.speed = 1
PayloadSpeedSettings.small_downhill_slow.not_pushed.acceleration = 0.2

local PayloadSpeedSettings_10 = PayloadSpeedSettings
local small_downhill = PayloadSpeedSettings.small_downhill

small_downhill = not not small_downhill or not not {}
PayloadSpeedSettings_10.small_downhill = small_downhill

local small_downhill_2 = PayloadSpeedSettings.small_downhill
local pushed_9 = PayloadSpeedSettings.small_downhill.pushed

pushed_9 = not not pushed_9 or not not {}
small_downhill_2.pushed = pushed_9
PayloadSpeedSettings.small_downhill.pushed.speed = 2.5
PayloadSpeedSettings.small_downhill.pushed.bonus_speed_per_player = 0.05
PayloadSpeedSettings.small_downhill.pushed.acceleration = 0.5

local small_downhill_3 = PayloadSpeedSettings.small_downhill
local not_pushed_9 = PayloadSpeedSettings.small_downhill.not_pushed

not_pushed_9 = not not not_pushed_9 or not not {}
small_downhill_3.not_pushed = not_pushed_9
PayloadSpeedSettings.small_downhill.not_pushed.speed = 2
PayloadSpeedSettings.small_downhill.not_pushed.acceleration = 0.2

local PayloadSpeedSettings_11 = PayloadSpeedSettings
local small_downhill_fast = PayloadSpeedSettings.small_downhill_fast

small_downhill_fast = not not small_downhill_fast or not not {}
PayloadSpeedSettings_11.small_downhill_fast = small_downhill_fast

local small_downhill_fast_2 = PayloadSpeedSettings.small_downhill_fast
local pushed_10 = PayloadSpeedSettings.small_downhill_fast.pushed

pushed_10 = not not pushed_10 or not not {}
small_downhill_fast_2.pushed = pushed_10
PayloadSpeedSettings.small_downhill_fast.pushed.speed = 3.5
PayloadSpeedSettings.small_downhill_fast.pushed.bonus_speed_per_player = 0.05
PayloadSpeedSettings.small_downhill_fast.pushed.acceleration = 0.5

local small_downhill_fast_3 = PayloadSpeedSettings.small_downhill_fast
local not_pushed_10 = PayloadSpeedSettings.small_downhill_fast.not_pushed

not_pushed_10 = not not not_pushed_10 or not not {}
small_downhill_fast_3.not_pushed = not_pushed_10
PayloadSpeedSettings.small_downhill_fast.not_pushed.speed = 3
PayloadSpeedSettings.small_downhill_fast.not_pushed.acceleration = 0.2

local PayloadSpeedSettings_12 = PayloadSpeedSettings
local small_downhill_chase_01 = PayloadSpeedSettings.small_downhill_chase_01

small_downhill_chase_01 = not not small_downhill_chase_01 or not not {}
PayloadSpeedSettings_12.small_downhill_chase_01 = small_downhill_chase_01

local small_downhill_chase_01_2 = PayloadSpeedSettings.small_downhill_chase_01
local pushed_11 = PayloadSpeedSettings.small_downhill_chase_01.pushed

pushed_11 = not not pushed_11 or not not {}
small_downhill_chase_01_2.pushed = pushed_11
PayloadSpeedSettings.small_downhill_chase_01.pushed.speed = 7.5
PayloadSpeedSettings.small_downhill_chase_01.pushed.bonus_speed_per_player = 0
PayloadSpeedSettings.small_downhill_chase_01.pushed.acceleration = 4

local small_downhill_chase_01_3 = PayloadSpeedSettings.small_downhill_chase_01
local not_pushed_11 = PayloadSpeedSettings.small_downhill_chase_01.not_pushed

not_pushed_11 = not not not_pushed_11 or not not {}
small_downhill_chase_01_3.not_pushed = not_pushed_11
PayloadSpeedSettings.small_downhill_chase_01.not_pushed.speed = 7.5
PayloadSpeedSettings.small_downhill_chase_01.not_pushed.acceleration = 4

local PayloadSpeedSettings_13 = PayloadSpeedSettings
local small_downhill_chase_02 = PayloadSpeedSettings.small_downhill_chase_02

small_downhill_chase_02 = not not small_downhill_chase_02 or not not {}
PayloadSpeedSettings_13.small_downhill_chase_02 = small_downhill_chase_02

local small_downhill_chase_02_2 = PayloadSpeedSettings.small_downhill_chase_02
local pushed_12 = PayloadSpeedSettings.small_downhill_chase_02.pushed

pushed_12 = not not pushed_12 or not not {}
small_downhill_chase_02_2.pushed = pushed_12
PayloadSpeedSettings.small_downhill_chase_02.pushed.speed = 6.5
PayloadSpeedSettings.small_downhill_chase_02.pushed.bonus_speed_per_player = 0
PayloadSpeedSettings.small_downhill_chase_02.pushed.acceleration = 3

local small_downhill_chase_02_3 = PayloadSpeedSettings.small_downhill_chase_02
local not_pushed_12 = PayloadSpeedSettings.small_downhill_chase_02.not_pushed

not_pushed_12 = not not not_pushed_12 or not not {}
small_downhill_chase_02_3.not_pushed = not_pushed_12
PayloadSpeedSettings.small_downhill_chase_02.not_pushed.speed = 6.5
PayloadSpeedSettings.small_downhill_chase_02.not_pushed.acceleration = 3

local PayloadSpeedSettings_14 = PayloadSpeedSettings
local ussingen_downhill_mansion_01 = PayloadSpeedSettings.ussingen_downhill_mansion_01

ussingen_downhill_mansion_01 = not not ussingen_downhill_mansion_01 or not not {}
PayloadSpeedSettings_14.ussingen_downhill_mansion_01 = ussingen_downhill_mansion_01

local ussingen_downhill_mansion_01_2 = PayloadSpeedSettings.ussingen_downhill_mansion_01
local pushed_13 = PayloadSpeedSettings.ussingen_downhill_mansion_01.pushed

pushed_13 = not not pushed_13 or not not {}
ussingen_downhill_mansion_01_2.pushed = pushed_13
PayloadSpeedSettings.ussingen_downhill_mansion_01.pushed.speed = 6.5
PayloadSpeedSettings.ussingen_downhill_mansion_01.pushed.bonus_speed_per_player = 0
PayloadSpeedSettings.ussingen_downhill_mansion_01.pushed.acceleration = 3

local ussingen_downhill_mansion_01_3 = PayloadSpeedSettings.ussingen_downhill_mansion_01
local not_pushed_13 = PayloadSpeedSettings.ussingen_downhill_mansion_01.not_pushed

not_pushed_13 = not not not_pushed_13 or not not {}
ussingen_downhill_mansion_01_3.not_pushed = not_pushed_13
PayloadSpeedSettings.ussingen_downhill_mansion_01.not_pushed.speed = 6.5
PayloadSpeedSettings.ussingen_downhill_mansion_01.not_pushed.acceleration = 3

local PayloadSpeedSettings_15 = PayloadSpeedSettings
local farmlands_heavy_load_01 = PayloadSpeedSettings.farmlands_heavy_load_01

farmlands_heavy_load_01 = not not farmlands_heavy_load_01 or not not {}
PayloadSpeedSettings_15.farmlands_heavy_load_01 = farmlands_heavy_load_01

local farmlands_heavy_load_01_2 = PayloadSpeedSettings.farmlands_heavy_load_01
local pushed_14 = PayloadSpeedSettings.farmlands_heavy_load_01.pushed

pushed_14 = not not pushed_14 or not not {}
farmlands_heavy_load_01_2.pushed = pushed_14
PayloadSpeedSettings.farmlands_heavy_load_01.pushed.speed = 0.2
PayloadSpeedSettings.farmlands_heavy_load_01.pushed.bonus_speed_per_player = 0.07
PayloadSpeedSettings.farmlands_heavy_load_01.pushed.acceleration = 1

local farmlands_heavy_load_01_3 = PayloadSpeedSettings.farmlands_heavy_load_01
local not_pushed_14 = PayloadSpeedSettings.farmlands_heavy_load_01.not_pushed

not_pushed_14 = not not not_pushed_14 or not not {}
farmlands_heavy_load_01_3.not_pushed = not_pushed_14
PayloadSpeedSettings.farmlands_heavy_load_01.not_pushed.speed = 0
PayloadSpeedSettings.farmlands_heavy_load_01.not_pushed.acceleration = 0.2

local PayloadSpeedSettings_16 = PayloadSpeedSettings
local normal = PayloadSpeedSettings.normal

normal = not not normal or not not {}
PayloadSpeedSettings_16.normal = normal

local normal_2 = PayloadSpeedSettings.normal
local pushed_15 = PayloadSpeedSettings.normal.pushed

pushed_15 = not not pushed_15 or not not {}
normal_2.pushed = pushed_15
PayloadSpeedSettings.normal.pushed.speed = 2.5
PayloadSpeedSettings.normal.pushed.bonus_speed_per_player = 0.25
PayloadSpeedSettings.normal.pushed.acceleration = 0.25

local normal_3 = PayloadSpeedSettings.normal
local not_pushed_15 = PayloadSpeedSettings.normal.not_pushed

not_pushed_15 = not not not_pushed_15 or not not {}
normal_3.not_pushed = not_pushed_15
PayloadSpeedSettings.normal.not_pushed.speed = 0
PayloadSpeedSettings.normal.not_pushed.acceleration = 0.25

local PayloadSpeedSettings_17 = PayloadSpeedSettings
local sled_ice = PayloadSpeedSettings.sled_ice

sled_ice = not not sled_ice or not not {}
PayloadSpeedSettings_17.sled_ice = sled_ice

local sled_ice_2 = PayloadSpeedSettings.sled_ice
local pushed_16 = PayloadSpeedSettings.sled_ice.pushed

pushed_16 = not not pushed_16 or not not {}
sled_ice_2.pushed = pushed_16
PayloadSpeedSettings.sled_ice.pushed.speed = 3
PayloadSpeedSettings.sled_ice.pushed.bonus_speed_per_player = 0.25
PayloadSpeedSettings.sled_ice.pushed.acceleration = 1

local sled_ice_3 = PayloadSpeedSettings.sled_ice
local not_pushed_16 = PayloadSpeedSettings.sled_ice.not_pushed

not_pushed_16 = not not not_pushed_16 or not not {}
sled_ice_3.not_pushed = not_pushed_16
PayloadSpeedSettings.sled_ice.not_pushed.speed = 0
PayloadSpeedSettings.sled_ice.not_pushed.acceleration = 0.5

local PayloadSpeedSettings_18 = PayloadSpeedSettings
local sled_normal = PayloadSpeedSettings.sled_normal

sled_normal = not not sled_normal or not not {}
PayloadSpeedSettings_18.sled_normal = sled_normal

local sled_normal_2 = PayloadSpeedSettings.sled_normal
local pushed_17 = PayloadSpeedSettings.sled_normal.pushed

pushed_17 = not not pushed_17 or not not {}
sled_normal_2.pushed = pushed_17
PayloadSpeedSettings.sled_normal.pushed.speed = 1.85
PayloadSpeedSettings.sled_normal.pushed.bonus_speed_per_player = 0.75
PayloadSpeedSettings.sled_normal.pushed.acceleration = 1.75

local sled_normal_3 = PayloadSpeedSettings.sled_normal
local not_pushed_17 = PayloadSpeedSettings.sled_normal.not_pushed

not_pushed_17 = not not not_pushed_17 or not not {}
sled_normal_3.not_pushed = not_pushed_17
PayloadSpeedSettings.sled_normal.not_pushed.speed = 0
PayloadSpeedSettings.sled_normal.not_pushed.acceleration = 1.75

local PayloadSpeedSettings_19 = PayloadSpeedSettings
local sled_fast = PayloadSpeedSettings.sled_fast

sled_fast = not not sled_fast or not not {}
PayloadSpeedSettings_19.sled_fast = sled_fast

local sled_fast_2 = PayloadSpeedSettings.sled_fast
local pushed_18 = PayloadSpeedSettings.sled_fast.pushed

pushed_18 = not not pushed_18 or not not {}
sled_fast_2.pushed = pushed_18
PayloadSpeedSettings.sled_fast.pushed.speed = 8
PayloadSpeedSettings.sled_fast.pushed.bonus_speed_per_player = 0
PayloadSpeedSettings.sled_fast.pushed.acceleration = 3

local sled_fast_3 = PayloadSpeedSettings.sled_fast
local not_pushed_18 = PayloadSpeedSettings.sled_fast.not_pushed

not_pushed_18 = not not not_pushed_18 or not not {}
sled_fast_3.not_pushed = not_pushed_18
PayloadSpeedSettings.sled_fast.not_pushed.speed = 8
PayloadSpeedSettings.sled_fast.not_pushed.acceleration = 2

local PayloadSpeedSettings_20 = PayloadSpeedSettings
local sled_downhill = PayloadSpeedSettings.sled_downhill

sled_downhill = not not sled_downhill or not not {}
PayloadSpeedSettings_20.sled_downhill = sled_downhill

local sled_downhill_2 = PayloadSpeedSettings.sled_downhill
local pushed_19 = PayloadSpeedSettings.small_downhill.pushed

pushed_19 = not not pushed_19 or not not {}
sled_downhill_2.pushed = pushed_19
PayloadSpeedSettings.sled_downhill.pushed.speed = 5.5
PayloadSpeedSettings.sled_downhill.pushed.bonus_speed_per_player = 0.5
PayloadSpeedSettings.sled_downhill.pushed.acceleration = 2.5

local sled_downhill_3 = PayloadSpeedSettings.sled_downhill
local not_pushed_19 = PayloadSpeedSettings.sled_downhill.not_pushed

not_pushed_19 = not not not_pushed_19 or not not {}
sled_downhill_3.not_pushed = not_pushed_19
PayloadSpeedSettings.sled_downhill.not_pushed.speed = 5
PayloadSpeedSettings.sled_downhill.not_pushed.acceleration = 1.75

local PayloadSpeedSettings_21 = PayloadSpeedSettings
local sled_fast02 = PayloadSpeedSettings.sled_fast02

sled_fast02 = not not sled_fast02 or not not {}
PayloadSpeedSettings_21.sled_fast02 = sled_fast02

local sled_fast02_2 = PayloadSpeedSettings.sled_fast02
local pushed_20 = PayloadSpeedSettings.sled_fast02.pushed

pushed_20 = not not pushed_20 or not not {}
sled_fast02_2.pushed = pushed_20
PayloadSpeedSettings.sled_fast02.pushed.speed = 9
PayloadSpeedSettings.sled_fast02.pushed.bonus_speed_per_player = 0
PayloadSpeedSettings.sled_fast02.pushed.acceleration = 4

local sled_fast02_3 = PayloadSpeedSettings.sled_fast02
local not_pushed_20 = PayloadSpeedSettings.sled_fast02.not_pushed

not_pushed_20 = not not not_pushed_20 or not not {}
sled_fast02_3.not_pushed = not_pushed_20
PayloadSpeedSettings.sled_fast02.not_pushed.speed = 9
PayloadSpeedSettings.sled_fast02.not_pushed.acceleration = 4

local PayloadSpeedSettings_22 = PayloadSpeedSettings
local tiny_uphill = PayloadSpeedSettings.tiny_uphill

tiny_uphill = not not tiny_uphill or not not {}
PayloadSpeedSettings_22.tiny_uphill = tiny_uphill

local tiny_uphill_2 = PayloadSpeedSettings.tiny_uphill
local pushed_21 = PayloadSpeedSettings.tiny_uphill.pushed

pushed_21 = not not pushed_21 or not not {}
tiny_uphill_2.pushed = pushed_21
PayloadSpeedSettings.tiny_uphill.pushed.speed = 1.45
PayloadSpeedSettings.tiny_uphill.pushed.bonus_speed_per_player = 0.25
PayloadSpeedSettings.tiny_uphill.pushed.acceleration = 0.75

local tiny_uphill_3 = PayloadSpeedSettings.tiny_uphill
local not_pushed_21 = PayloadSpeedSettings.tiny_uphill.not_pushed

not_pushed_21 = not not not_pushed_21 or not not {}
tiny_uphill_3.not_pushed = not_pushed_21
PayloadSpeedSettings.tiny_uphill.not_pushed.speed = -1.75
PayloadSpeedSettings.tiny_uphill.not_pushed.acceleration = 1.2
