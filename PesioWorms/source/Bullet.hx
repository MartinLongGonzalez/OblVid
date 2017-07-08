package;
import flixel.addons.nape.FlxNapeSprite;
/**
 * ...
 * @author 
 */

 enum BulletType {
			Projectile;
			Straight;
}
 
class Bullet extends FlxNapeSprite
{
	
	public var bulletType:BulletType; 
	public var speed:Float;
	public var explotionRatio:Float;
	public var damage:Int;
	 	
		public function new(x, y) {
			super(x, y, null, false);
		}
}