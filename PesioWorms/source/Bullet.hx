package ;
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
	public var explotionRadius:Int;
	public var damage:Int;
	public var had_contact:Bool;
	 	
		public function new(x, y) {
			super(x, y, null, false);
			had_contact = false;
		}
}