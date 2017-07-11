package ;
import flixel.addons.nape.FlxNapeSprite;
/**
 * ...
 * @author 
 */

 enum BulletType { // To keep the value of the weapon choosed by the player
			Bazooka;
			Shotgun;
			SpaceRift;
}
 
class Bullet extends FlxNapeSprite
{
	
	public var bulletType:BulletType; 
	public var speed:Float;
	public var explotionRadius:Int;
	public var damage:Int;
	 	
		public function new(x, y) {
			super(x, y, null, false);
		}
}