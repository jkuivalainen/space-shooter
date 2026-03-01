# Space Shooter — Project Plan

## Concept

2D twin-stick survival shooter. Yellow hexagon player vs. red square enemies. Survive as long as
possible. The core gimmick (Phase 2): destroying enemies leaves bodies you can attach to yourself
to trade movement speed for fire rate.

## Status

**Phase 2 — Body Mechanic: complete**

## Architecture

```
res://
├── scenes/
│   ├── main.tscn          # Root: Player + EnemySpawner + HUD
│   ├── player.tscn        # Yellow hexagon, CharacterBody2D
│   ├── enemy.tscn         # Red square, CharacterBody2D
│   ├── enemy_body.tscn    # Gray square dropped on enemy death, Area2D
│   └── bullet.tscn        # Player projectile, Area2D
├── scripts/
│   ├── game_manager.gd    # Autoload: state, timer, difficulty
│   ├── main.gd
│   ├── player.gd
│   ├── enemy.gd
│   ├── enemy_body.gd      # Assimilation + shield-layer logic
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

### Phase 2 — Body Mechanic ✓
- Enemy death → drops gray body (`enemy_body.tscn`)
- Player touches body → assimilates (snaps to hex orbit, turns yellow)
- Each body: fire_rate -0.04s (min 0.05), speed -15 px/s (min 60)
- Bodies orbit in rings of 6 at radius 40+28×ring px
- Body hit by enemy → stat deltas reversed, body destroyed

### Phase 3 — Polish
- Particle effects, sound, screen shake
- Visual feedback for stat changes
- UI polish and difficulty tuning
