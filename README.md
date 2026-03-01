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

- **Speeds:** player 160, enemies 180 — enemies are slightly faster to maintain pressure
- **No pathfinding:** enemies use a direct normalized-vector chase
- **Difficulty:** spawn interval decreases by 0.15s per 10 seconds survived (floor: 0.3s, max rate reached ~11s in)
- **Collision layers:** Player = layer 1, Enemies = layer 2, Bullets = layer 4, Enemy bodies = layer 8
- **Body mechanic:** killing an enemy drops a gray square; walk over it to attach it to the nearest
  free side of your hexagon (max 6). Each body trades movement speed (−15, min 60) for fire rate
  (−0.04s, min 0.05s). Bodies rotate to align with their side and act as a shield — an enemy
  hitting an attached body destroys it and reverses its stat bonus. If a slot is full when you walk
  over a drop, it will auto-assimilate the moment a slot frees while you're still overlapping.
