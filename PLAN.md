# Space Shooter — Project Plan

## Concept

2D twin-stick survival shooter. Yellow hexagon player vs. red square enemies. Survive as long as
possible. The core gimmick (Phase 2): destroying enemies leaves bodies you can attach to yourself
to trade movement speed for fire rate.

## Status

**Phase 1 — Core Game Loop: complete**

## Architecture

```
res://
├── scenes/
│   ├── main.tscn          # Root: Player + EnemySpawner + HUD
│   ├── player.tscn        # Yellow hexagon, CharacterBody2D
│   ├── enemy.tscn         # Red square, CharacterBody2D
│   └── bullet.tscn        # Player projectile, Area2D
├── scripts/
│   ├── game_manager.gd    # Autoload: state, timer, difficulty
│   ├── main.gd
│   ├── player.gd
│   ├── enemy.gd
│   ├── enemy_spawner.gd
│   ├── bullet.gd
│   └── hud.gd
└── ui/
    └── hud.tscn           # Timer + game-over overlay
```

## Phases

### Phase 1 — Core Game Loop ✓
- Player movement, aiming, shooting
- Enemy spawning with increasing difficulty
- Survival timer
- Game over + restart

### Phase 2 — Body Mechanic (next)
- Enemy death → drops gray body (`enemy_body.tscn`)
- Player touches body → assimilates (snaps to hex side, turns yellow)
- Each body: `fire_rate += bonus`, `move_speed -= penalty`
- Body hit by enemy destroys body, not player

### Phase 3 — Polish
- Particle effects, sound, screen shake
- Visual feedback for stat changes
- UI polish and difficulty tuning
