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

	private var jumping:Bool = false;
	private var bodyList:BodyList = null;
	private var player:Player;
	
	public function update() : Void {
		if (player.body.velocity.y > 0)
			jumping = true;
		else
			jumping = false;
			
			if (FlxG.keys.justPressed.UP)     // left
			{
				if(!jumping){
					player.body.velocity.y += 500;
				}
			}
			if (FlxG.keys.justPressed.RIGHT)
			{
				if(jumping)
					player.body.velocity.x += 100;
			}
	}
	public function new(player:Player) 
	{
		this.player = player;
	}
	
	
}