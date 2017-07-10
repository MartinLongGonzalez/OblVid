package;
import flixel.FlxG;
import flixel.addons.nape.FlxNapeSpace;
import nape.phys.BodyList;

/**
 * ...
 * @author Agus
 */
class JumpState implements PlayerState
{

	private var player:Player;
	private var count:Int = 0;

	public function update() : Void
	{

		if (player.body.velocity.y >= -2   && player.body.velocity.y <= 2 )
		{
			if (count>0)
			{
				//jumping = false;
				player.state = new StillState(player);
			}
			else
			{
				count++;
			}

		}
		if (count>0)
		{

		}
		else{
			if (FlxG.keys.pressed.RIGHT)
			{
				player.body.velocity.x = 100;
			}
			if (FlxG.keys.pressed.LEFT)
			{
				player.body.velocity.x = -100;

			}
		}
	}
	public function new(player:Player)
	{
		this.player = player;
		player.body.velocity.y = -400;
	}

}