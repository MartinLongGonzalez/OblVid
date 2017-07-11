package;

import flixel.FlxGame;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

class Main extends Sprite
{
	private var messageField:TextField;
	
	public function new()
	{
		super();
		addChild(new FlxGame(640, 480, MainMenuState));
		//addChild(new FlxGame(1080, 720, MainMenuState));
	}
}