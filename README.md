# pixelmethod-engine-flash
A 2D game engine for Flash. This project is not being developed anymore.

![Alt text](/Screenshot_2019-10-29_23-40-26?raw=true "Screenshot")

## Current features
- Multiple render targets with asignable cameras (multiple world views)
- XML tilemaps with support for multiple tilesets
- XML tilesets with toggle/animation support (rough)
- Dynamic chunk-based worlds
- XML chunk definition files with cell shapes to correspond with a tilemap, and entity states
- Custom two-phase 2D collision system utilizing separating axis theorem (only dynamic->static at this time)

## Build and Run the demo
On Linux:
1. Download and extract the Adobe Flex SDK somewhere
2. Install the Adobe Flash Player Standalone Debugger, or you can probably just use any flash player binary
3. Build the project with `ant -DFLEX_HOME=<wherever you downloaded the sdk>`. If you are using a different player, you will need to pass `-Ddebug_player` as well

## Instructions
Just use the arrow keys to move, that's it.
