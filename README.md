# Space Shooter

2D twin-stick survival shooter in Godot 4. Survive as long as possible against waves of
red square enemies. The longer you last, the faster they spawn.

## How to Run

1. Open Godot 4 (4.2+)
2. Import the project: **Project → Import** → select this folder
3. Press **F5** (or the Play button) to run

## Controls

| Action | Keyboard / Mouse | Controller |
|--------|-----------------|------------|
| Move | WASD | Left stick |
| Aim | Mouse cursor | Right stick |
| Shoot | Left mouse button | Right trigger |
| Restart | Enter (on game over) | Start button |

## Project Structure

```
scenes/      Scene files (.tscn)
scripts/     GDScript source files
ui/          HUD scene
concept.md   Original game concept
PLAN.md      Living development plan
```

## Key Design Notes

- **No pathfinding:** enemies use a direct normalized-vector chase
- **Difficulty:** spawn interval decreases by 0.05s per 10 seconds survived (floor: 0.3s)
- **Collision layers:** Player = layer 1, Enemies = layer 2, Bullets = layer 4
- **Phase 2** will add the body-assimilation mechanic (speed/fire-rate trade-off)
