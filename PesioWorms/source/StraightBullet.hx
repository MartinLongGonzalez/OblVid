package;
import flixel.addons.nape.FlxNapeSpace;
import flixel.addons.nape.FlxNapeSprite;
import nape.callbacks.CbType;
import Bullet.BulletType;
/**
 * ...
 * @author ...
 */
class StraightBullet extends Bullet
{

	
	public static var CB_STRAIGHT_BULLET:CbType = new CbType();
	
	public function new(x, y) 
	{
		super(x, y);
		this.bulletType = BulletType.Straight;
		this.speed = 5000;
		this.damage = 35;
		this.explotionRatio = 4; // > Ratio Less explotion radius
		createCircularBody(0.4);
		body.space = FlxNapeSpace.space;
		body.cbTypes.add(CB_STRAIGHT_BULLET);
	}
	
}