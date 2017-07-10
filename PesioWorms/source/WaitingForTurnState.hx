package;

/**
 * ...
 * @author
 */

class WaitingForTurnState implements PlayerState
{

	private var player:Player;
	//private var xPos:Float;

	public function update() : Void
	{

		player.body.velocity.x = 0;
		//player.body.velocity.y = 0;


	}
	public function new(player:Player)
	{
		this.player = player;
		//this.player.body.allowMovement = false;
	}

}