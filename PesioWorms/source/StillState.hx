package;
import flixel.FlxG;

/**
 * ...
 * @author 
 */
class StillState implements PlayerState
{

	private var player:Player;
	private var xPos:Float;
	
	public function update() : Void {
			if (FlxG.keys.pressed.RIGHT)     // left
			{
				//player.state;
				player.state = new WalkingRightState(player);
				//player.state.update();
			}
			else if (FlxG.keys.pressed.LEFT)     // left
			{
				player.state = new WalkingLeftState(player);

			}
			else{
				player.body.velocity.x = 0;
				player.body.velocity.y = 0;

			}
			
	}
	public function new(player:Player) 
	{
		this.player = player;
		//this.xPos = player.body.position.x;
	}
	
}