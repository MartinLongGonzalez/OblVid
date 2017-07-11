package ;
import flixel.addons.nape.FlxNapeSpace;
import flixel.addons.nape.FlxNapeSprite;
import nape.callbacks.CbType;
import Bullet.BulletType;
/**
 * ...
 * @author ...
 */
class ShotgunBullet extends Bullet
{

	
	public static var CB_SHOTGUN_BULLET:CbType = new CbType();
	
	public function new(x, y) 
	{
		super(x, y);
		this.bulletType = BulletType.Shotgun;
		this.speed = 3000;
		this.damage = 35;
		this.explotionRadius = 10; // > Ratio Less explotion radius
		createCircularBody(2);
		body.space = FlxNapeSpace.space;
		body.cbTypes.add(CB_SHOTGUN_BULLET);
	}
	
}