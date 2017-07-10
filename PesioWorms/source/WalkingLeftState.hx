package;
import flixel.FlxG;

/**
 * ...
 * @author 
 */
class WalkingLeftState implements PlayerState
{

	private var player:Player;
	
	public function update() : Void {
			if (FlxG.keys.pressed.LEFT)     // left
			{
				player.body.velocity.x = -100;
			}	
			if(FlxG.keys.justReleased.LEFT){
				player.state  = new StillState(player);
				//player.state.update();
			}
	}
	public function new(player:Player) 
	{
		this.player = player;
		this.player.body.allowMovement = true;
	}
	
}