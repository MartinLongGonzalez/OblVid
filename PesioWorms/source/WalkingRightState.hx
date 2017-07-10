package;
import flixel.FlxG;

/**
 * ...
 * @author
 */
class WalkingRightState implements PlayerState
{

	private var player:Player;

	public function update() : Void
	{
		if (FlxG.keys.pressed.RIGHT)     // left
		{
			player.body.velocity.x = 100;
		}
		if (FlxG.keys.justReleased.RIGHT)
		{
			player.state  = new StillState(player);
			//player.state.update();
		}
		if (FlxG.keys.justPressed.UP)
		{
			player.state = new JumpState(player);
		}
	}
	public function new(player:Player)
	{
		this.player = player;
		this.player.body.allowMovement = true;
	}

}