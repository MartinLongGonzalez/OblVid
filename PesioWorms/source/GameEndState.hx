package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.text.FlxTextField;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
/**
 * ...
 * @author Martin Long Gonzalez
 */
class GameEndState extends FlxState 
{

	private var mainText:FlxTextField;
	private var winner:Int;
	
	public function setMainText(text:Int):Void
	{
		this.winner = text;
	}

	override public function create():Void
	{
		init();

		super.create();
	}
	
	private function init():Void
	{
		var screenHeight = FlxG.height;
		mainText = new FlxTextField(10, 10, 100, "Player 1: 100 HP", 9, true, null);
		mainText.screenCenter(FlxAxes.X);
        add(mainText);
		var playAgainBtn:FlxButton = new FlxButton(0, screenHeight/5, "", PlayAgainOnClick);
		playAgainBtn.loadGraphic("assets/PlayAgainBtn.png");
		playAgainBtn.screenCenter(FlxAxes.X);
        add(playAgainBtn);
		var mainMenuBtn:FlxButton = new FlxButton(0, screenHeight*3/5, "", MainMenuOnClick);
		mainMenuBtn.loadGraphic("assets/MainMenuBtn.png");
		mainMenuBtn.screenCenter(FlxAxes.X);
        add(mainMenuBtn);
	}
	
	private function PlayAgainOnClick():Void
    {
        FlxG.switchState(new PlayState());
    }
	
	private function MainMenuOnClick():Void
    {
        FlxG.switchState(new MainMenuState());
    }
	
	override public function update(elapsed:Float):Void
	{
		if (mainText != null)
		{
			this.mainText.text = "Player " + Std.string(this.winner) + " won";
		}
		super.update(elapsed);
	}
	
	override public function destroy():Void
    {
        super.destroy();
    }
	
}