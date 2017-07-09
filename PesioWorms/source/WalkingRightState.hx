package;
import flixel.FlxG;

/**
 * ...
 * @author 
 */
class WalkingRightState implements PlayerState
{

	private var player:Player;
	
	public function update() : Void {
			if (FlxG.keys.pressed.RIGHT)     // left
			{
				player.body.velocity.x = 100;
			}	
			if(FlxG.keys.justReleased.RIGHT){
				player.state  = new StillState(player);
				//player.state.update();
			}
	}
	public function new(player:Player) 
	{
		this.player = player;
	}
	
}