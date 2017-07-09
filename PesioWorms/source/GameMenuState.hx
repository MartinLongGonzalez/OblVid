package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxRandom;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import nape.geom.AABB;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Martin Long Gonzalez
 */
class GameMenuState extends FlxState
{

	private var terrain:Terrain;
	private var random:FlxRandom;
	private var randomSeed:Int;
	private var w:Int;
	private var h:Int;
	
	override public function create():Void
	{
		init();

		super.create();
	}

	private function init():Void
	{
		random = new FlxRandom();
		randomSeed = random.int();
		w = FlxG.width;
		h = FlxG.height;
		var bit = new BitmapData(w, h, true, 0x00000000);
		bit.perlinNoise(200, 200, 2, randomSeed, false, true, BitmapDataChannel.ALPHA, false);
		terrain = new Terrain(bit, 30, 5);
		terrain.invalidate(new AABB(0, 0, w, h), this);
		terrain.sprite.setGraphicSize(260, 200);
		terrain.sprite.setPosition(0, -100);
		terrain.sprite.screenCenter(FlxAxes.X);
		var generateMapBtn:FlxButton = new FlxButton(0, 0, "", GenerateMap);
		generateMapBtn.loadGraphic("assets/GenerateMapBtn.png");
		generateMapBtn.setGraphicSize(0, 30);
		generateMapBtn.setPosition(0, 250);
		generateMapBtn.screenCenter(FlxAxes.X);
        add(generateMapBtn);
		var startGameBtn:FlxButton = new FlxButton(0, 0, "", StartGame);
		startGameBtn.loadGraphic("assets/StartGameBtn.png");
		startGameBtn.setGraphicSize(0, 50);
		startGameBtn.setPosition(0, 320);
		startGameBtn.screenCenter(FlxAxes.X);
        add(startGameBtn);
		add(terrain.sprite);
	}
	
	private function GenerateMap():Void
    {
		remove(terrain.sprite);
		randomSeed = random.int(); 
		var bit = new BitmapData(w, h, true, 0x00000000);
		bit.perlinNoise(200, 200, 2, randomSeed, false, true, BitmapDataChannel.ALPHA, false);
		terrain = new Terrain(bit, 30, 5);
		terrain.invalidate(new AABB(0, 0, w, h), this);
		terrain.sprite.setGraphicSize(260, 200);
		terrain.sprite.setPosition(0, -100);
		terrain.sprite.screenCenter(FlxAxes.X);
		add(terrain.sprite);
    }
	
	private function StartGame():Void
	{
		var playState = new PlayState();
		playState.setRandomSeed(randomSeed);
		FlxG.switchState(playState);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	override public function destroy():Void
    {
        super.destroy();
    }
	
}