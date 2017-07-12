package;

/**
 * ...
 * @author Martin Long Gonzalez
 */
class GameConfigurations 
{

	public var playersLife:Int;
	public var drownInWater:Bool;
	
	private static var config:GameConfigurations;
	
	public static function instance():GameConfigurations
	{
		if (config == null){
			config = new GameConfigurations(200, true);
		}
		return config;
	}
	
	private function new(playersLife:Int, drownInWater:Bool)
	{
		this.playersLife = playersLife;
		this.drownInWater = drownInWater;
	}
	
	public function setPlayersLife(playersLife:Int):Void
	{
		this.playersLife = playersLife;
	}
	
	public function setDrownInWater(drownInWater:Bool):Void
	{
		this.drownInWater= drownInWater;
	}
	
	public function getPlayersLife():Int
	{
		return playersLife;
	}
	
	public function getDrownInWater():Bool
	{
		return drownInWater;
	}
}