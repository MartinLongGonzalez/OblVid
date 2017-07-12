package ;
import flixel.FlxG;
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
		this.bulletSizeRadius = 2;
		createCircularBody(this.bulletSizeRadius);
		body.space = FlxNapeSpace.space;
		body.cbTypes.add(CB_SHOTGUN_BULLET);
		//FlxG.sound.play("assets/music/shotgun.WAV", 1, false);
	}
	
}