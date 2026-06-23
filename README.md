# API

```lua
local Zone = require(ReplicatedStorage.Zone)

local ZonePart = workspace.Part

local zone = Zone.new(ZonePart)

-- Fires when a player enters the zone
zone.PlayerAdded:Connect(function(player)
	print(player.Name .. " entered the zone")
end)

-- Fires when a player leaves the zone
zone.PlayerRemoved:Connect(function(player)
	print(player.Name .. " left the zone")
end)

-- Returns all players currently inside the zone
local playersInZone = zone:GetPlayersInZone()
```

## Constructor

### `Zone.new(part: BasePart) -> Zone`

Creates a new zone from the provided `BasePart`.

| Parameter | Type | Description |
|-----------|------|-------------|
| `part` | `BasePart` | The part used as the zone boundary. |

---

## Events

### `Zone.PlayerAdded`

Fires when a player enters the zone.

#### Parameters

| Name | Type |
|------|------|
| `player` | `Player` |

#### Example

```lua
zone.PlayerAdded:Connect(function(player)
	print(player.Name)
end)
```

---

### `Zone.PlayerRemoved`

Fires when a player leaves the zone.

#### Parameters

| Name | Type |
|------|------|
| `player` | `Player` |

#### Example

```lua
zone.PlayerRemoved:Connect(function(player)
	print(player.Name)
end)
```

---

## Methods

### `Zone:GetPlayersInZone() -> {Player}`

Returns an array containing all players currently inside the zone.

#### Example

```lua
local players = zone:GetPlayersInZone()

for _, player in players do
	print(player.Name)
end
```

---

### `Zone:IsPlayerInZone(player: Player) -> boolean`

Returns whether the specified player is currently inside the zone.

#### Parameters

| Name | Type |
|------|------|
| `player` | `Player` |

#### Example

```lua
if zone:IsPlayerInZone(player) then
	print("Player is inside the zone")
end
```

---

## Notes
- Only `Player` instances are tracked.
- `PlayerAdded` fires once when a player enters the zone.
- `PlayerRemoved` fires once when a player leaves the zone.
- `GetPlayersInZone()` returns the current list of players in the zone.
- Zone detection updates automatically while the zone exists.
