# Godot AI examples

This is a repo with project for ai course. It should be opened with Godot4.4

## Utility AI

A modular Utility AI framework for Godot 4.4+, designed to empower AI agents with context-aware decision-making using numerical utility scoring. Prioritize flexibility and scalability for dynamic behaviors.


### Core Components

- **UtilityConsideration**: Evaluates a single contextual factor (e.g., hunger, proximity). Can be setup with built in editor for curves for more control options
- **UtilityAction**: Defines an actionable behavior with weighted considerations. Supports adding constans and aggregation functions such as
  - WEIGHTED_SUM: Combine scores multiplicatively with weights.
  - MULTIPLICATIVE: Multiply all scores (requires all conditions).
  - HIGHEST: Use the highest individual score.
- **UtilityReasoner**: Selects and execute the highest-utility action. 

### How to use
 - **Define Context Properties**
Add exported variables/methods to your agent (e.g., hunger, get_distance_to_target()).

- **Create Considerations**
Use context manager to create UtilityConsideration resourse. Configure input axes and curves.

- **Build Actions**
Create UtilityAction resources, assign considerations/weights, and link to agent methods to be called.

- **Attach the Reasoner**
Add a UtilityReasoner node to your agent and populate its action list.

Examples and implementation can be found in /utils/. To run utility example start the /utils/Main.tscn scene

## Pathfinding Example

A grid-based pathfinding demonstration using Dijkstra's algorithm and A* with heuristic optimization. 

### Controls

- **Left Mouse Button**: Set start/end points
- **Right Mouse Button**: Toggle obstacles
- **Interface Buttons**: Create new random map / change algorithm

Examples and implementation can be found in /pathfinding/. To run utility example start the /pathfinding/Main.tscn
scene

## Autonomous Agents - Steering Behaviors

An implementation of steering behaviors, with toggleable AI behaviors for autonomous characters.


### Features

- **Core Behaviors**

  - Seek/Flee
  - Wander
  - Flocking (Cohesion/Separation/Alignment)
  - Obstacle Avoidance

Each behavior is controlled by steering manager, witch can enable/disable and bland steerings. Debug lines for each behavior are provided

Examples and implementation can be found in /boids/. To run utility example start the /boids/Main.tscn
scene
