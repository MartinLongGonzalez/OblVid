package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxSlider;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxSlider;
import flixel.util.FlxAxes;

/**
 * ...
 * @author Martin Long Gonzalez
 */
 
class OptionsState extends FlxState
{

	private var drownInWaterCheckbox:FlxButton;
	private var playersLifeSlider:FlxSlider;
	
	override public function create():Void
	{
		init();
		super.create();
	}

	private function init():Void
	{ 
		var parent = new FlxSprite();
		var screenWidth = FlxG.width;
		playersLifeSlider = new FlxSlider(parent, "x", (screenWidth - 300)/2, 10, 200, 500, 300, 40, 15, 0xFFFF0000, 0xFF00FF00);
		playersLifeSlider.nameLabel.text = "Life";
		playersLifeSlider.minLabel.setFormat("", 20);
		playersLifeSlider.maxLabel.setFormat("", 20);
		playersLifeSlider.valueLabel.setFormat("", 20);
		playersLifeSlider.nameLabel.setFormat("", 20);
		
		var screenHeight = FlxG.height;
		var text = new FlxSprite();
		text.loadGraphic("assets/DrownInWaterText.png");
		text.setGraphicSize(0, 30);
		text.setPosition(0, (screenHeight / 5) + 50);
		text.screenCenter(FlxAxes.X);
		add(text);
        add(playersLifeSlider);
	
		var drownInWater = GameConfigurations.instance().getDrownInWater();
		
		drownInWaterCheckbox = new FlxButton(0, screenHeight*2/5, "", DrownInWaterOnClick);
		if (drownInWater)
		{
			drownInWaterCheckbox.loadGraphic("assets/CheckboxSelected.png", false, 38, 37);
			GameConfigurations.instance().setDrownInWater(false);
		}
		else
		{
			drownInWaterCheckbox.loadGraphic("assets/Checkbox.png", true, 38, 37);
			GameConfigurations.instance().setDrownInWater(true);
		}
		
		drownInWaterCheckbox.screenCenter(FlxAxes.X);
        add(drownInWaterCheckbox);
		
		var mainMenuBtn:FlxButton = new FlxButton(0, screenHeight*3/5, "", MainMenuOnClick);
		mainMenuBtn.loadGraphic("assets/MainMenuBtn.png");
		mainMenuBtn.screenCenter(FlxAxes.X);
        add(mainMenuBtn);
		
	}
	
	private function DrownInWaterOnClick():Void
    {
        if (GameConfigurations.instance().getDrownInWater())
		{
			drownInWaterCheckbox.loadGraphic("assets/Checkbox.png", false, 38, 37);
			GameConfigurations.instance().setDrownInWater(false);
		}
		else
		{
			drownInWaterCheckbox.loadGraphic("assets/CheckboxSelected.png", false, 38, 37);
			GameConfigurations.instance().setDrownInWater(true);
		}
    }
	
	private function MainMenuOnClick():Void
    {
		var life = Std.int(playersLifeSlider.value);
		GameConfigurations.instance().setPlayersLife(life==0?200:life);
        FlxG.switchState(new MainMenuState());
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