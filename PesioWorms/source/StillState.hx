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
			if (FlxG.keys.pressed.RIGHT)  
			{
				//player.state;
				player.state = new WalkingRightState(player);
				//player.state.update();
			}
			else if (FlxG.keys.pressed.LEFT)  
			{
				player.state = new WalkingLeftState(player);

			}
			else{
				player.body.velocity.x = 0;
				//player.body.velocity.y = 0;
			}
			if (FlxG.keys.justPressed.UP)     
			{
				player.state = new JumpState(player);
			}
			
	}
	public function new(player:Player) 
	{
		this.player = player;
		//this.player.body.allowMovement = false;
	}
	
}