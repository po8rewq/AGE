AGE
===

Another Game Engine for Haxe js (Haxe 3 only)

AGE is a minimal game engine for making HTML5 games

Version 0.0.1


Feature list
------------

 * A lightweight 2D sprite-based engine for HTML5 canvas
 * Basic text support
 * Mouse support 
 * A simple behavior system
 * Basic sound support **[WIP]**
 * Tilesheet support
 * Animations


Development build
-----------------

Just run this command line into your terminal

```bash
haxelib git AGE https://github.com/po8rewq/AGE src
```

Add the lib to your project

```bash
-lib AGE

# Or just clone the repo and add this :
-cp /age/directory/src/
```


Basic "how to"
--------------

### Start a new project :

Main.hx
```haxe
import age.core.Engine;
class Main extends Engine
{
	public function new() {
		super(800, 600, new MyFirstState(), 60, "#CECECE");
	}

	public static function main() {
		new Main();
	}

	public override function create() {
		trace('Hello world');
	}

	public override function update() {
		trace('main loop');
		super.update();
	}
}
```

MyFirstState.hx
```haxe
import age.display.State;
class MyFirstState extends State
{
	public function new() {
		super();
	}
}
```

### Preloader :

Main.hx
```haxe
public static function main()
{
	Loader.addResource('/path/to/myimg.png', ResourceType.IMAGE, 'img1');
	Loader.addResource('/path/to/mysound.ogg', ResourceType.SOUND, 'snd1');
	Loader.start( function() { new Main(); } );
}
```

### Add an element to the screen :

```haxe
add( new Entity(10, 10, "/path/to/myimg.png") );
```

or if you used the Loader :

```haxe
add( new Entity(10, 10, "img1") );
```


 ### The behavior system :
 
