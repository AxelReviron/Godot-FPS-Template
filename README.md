<p align="center">
  <img src="https://img.shields.io/badge/Godot-4.4.1-blue?logo=godot-engine&logoColor=white" alt="godot-badge"/>
  <img src="https://img.shields.io/badge/status-work%20in%20progress-yellow" alt="Status badge" />
  <img src="https://img.shields.io/badge/license-MIT-green" alt="License badge" />
</p>

# Godot FPS Template
A clean and modular First Person Shooter (FPS) template built with **Godot 4.4.1**, featuring a state-driven player system, modular weapons, and a debug interface — designed for rapid prototyping or as a base for FPS games.
> Currently, only the player's movement system is fully implemented using a state machine.

## ✨ Features

- **State Machine Architecture**  
  Each player behavior (idle, walking, sprinting, jumping, falling, crouching, sliding) is handled by its own state class. Transitions are cleanly managed via signals and encapsulated logic.


- **Modular Weapon System**  
  Weapons are defined as custom resources and instantiated dynamically. You can easily add new weapons with their own models, animations, and properties without modifying core logic.


- **Unified Input System**  
  All game inputs are centralized in a shared singleton (`shared/input.gd`). This simplifies management and allows easy key remapping.


- **Debug Panel**  
  A customizable debug UI displays the current player state and runtime stats for easier testing and iteration.


## 🧠 Gameplay States

The player uses a finite state machine (`core/state.gd`) to handle core actions. Each state is implemented in its own script:

- **Idle** – Waiting state when no input is detected.
- **Walking** – Triggered when movement input is detected.
- **Sprinting** – Activated when movement + sprint input is held.
- **Jumping** – Triggered via jump input (supports jump delay and optional double jump).
- **Falling** – Active while in the air and not jumping.
- **Crouching** – Toggles via crouch input (need to maintain the key pressed for now).
- **Sliding** – Triggered when sprinting + crouch input is pressed.

States emit a `transition` signal to request moving from one state to another. Logic is modular and isolated, making behaviors easy to extend or override.


## 📁 Architecture
```
addons/ # Addons or external plugins
core/ # 
└─ state.gd # Base class for the state machine system
entities/
├─ ennemies/ # Placeholder for enemies
├─ npc/ # Placeholder for NPCs
├─ player/
│  ├─ assets/ # Player meshes, animations, sounds
│  ├─ states/ # All individual player states (idle, sprinting...)
│  ├─ player.gd # Main player controller
│  └─ player.tscn # Player scene
levels/
└─ main/ # Sample level and main scene
shared/ # Autoloaded scripts (available from any nodes)
├── constants.gd # Constant values (player speed, jump velocity, etc.)
├── settings.gd # Placeholder for player settings (will change with save system)
├── global.gd # Player and DebugPanel Nodes references
└── input.gd # Centralized inputs
ui/
```

All scripts under `shared/` are automatically loaded via **Autoload** (see `Project Settings → Autoload`).


## 🔫 Weapon System

Weapons are handled via a modular system. Each weapon should have a `.tres` resource that defines:

- Mesh
- Position, Rotation 
- And more to come like damage, recoil...

They are loaded dynamically using `init_weapon.gd` script.

To add a new weapon:

1. Create a new resource file that extends Weapon class.
2. Fill in its configuration in the resource.
3. Add it to the Weapon Type property of the Weapon Node (in Player scene)

The weapon system is designed to be modular, and will later support defining additional properties like damage, rate of fire, recoil...


## 🗒️ TODO
- [ ] Make sliding mechanic optional
- [ ] Finish weapon system
  - [ ] Implement reload mechanic
  - [ ] Add weapon switching
  - [ ] Add aiming and shooting logic
  - [ ] Add recoil system
  - [ ] Visual and sound FX
- [ ] Save user settings and progression system
- [ ] Game menus and user settings
- [ ] Interactable objects (like door or stuff)


- [ ] Add optional wall sliding mechanic
- [ ] Add own 3D Model 


## Credits
### Assets
- [Superior](https://sketchfab.com/SuperiorOne) - Crowbar 3D Model
