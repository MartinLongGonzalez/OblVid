package;
import flash.utils.Timer;

/**
 * ...
 * @author Martin Long Gonzalez
 */
class Turn 
{

	public var player:Player;
	public var timer:Timer;
	public var position:Int;
	public var players:Array<Player>;
	public var paused:Bool;
	private static var turn:Turn;
	
	
	public static function instance():Turn{
		if (turn == null){
			turn = new Turn();
		}
		return turn;
	}
	
	
	private function new() 
	{
		players = new Array<Player>();
		timer = createTimer();
		position = 0;
		paused = false;
	}
	
	public function createTimer(){
		var timer  = new Timer(0);
		timer.reset();
		timer.start();
		return timer;
	}
	public function finish(){
		
		position = (position + 1) % players.length;
		player = players[position];
		restartTimer();
		paused = false;
	}
	
	public function restartTimer(){
		
		timer.reset();
		timer.start();
	}
	
}