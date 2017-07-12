package;
import flixel.FlxG;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
/**
 * ...
 * @author Martin Long Gonzalez
 */
class MainMenuState extends FlxState
{

	override public function create():Void
	{
		if (FlxG.sound.music == null)
		{
			FlxG.sound.playMusic("assets/music/boris.mp3", 1, true);
		}
		init();
		super.create();
	}

	private function init():Void
	{ 
		var screenHeight = FlxG.height;
		var newGameBtn:FlxButton = new FlxButton(0, screenHeight/5, "", StartGameOnClick);
		newGameBtn.loadGraphic("assets/NewGameBtn.png");
		newGameBtn.screenCenter(FlxAxes.X);
        add(newGameBtn);
		var highscoresBtn:FlxButton = new FlxButton(0, screenHeight*3/5, "", OptionsOnClick);
		highscoresBtn.loadGraphic("assets/OptionsBtn.png");
		highscoresBtn.screenCenter(FlxAxes.X);
        add(highscoresBtn);
	}
	
	private function StartGameOnClick():Void
    {
        FlxG.switchState(new GameMenuState());
    }
	
	private function OptionsOnClick():Void
    {
        FlxG.switchState(new PlayState());
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