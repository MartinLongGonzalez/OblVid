package;
import flixel.FlxG;
import flixel.addons.nape.FlxNapeSpace;
import nape.callbacks.CbType;
import Bullet.BulletType;
/**
 * ...
 * @author 
*/
class SpaceRiftBullet extends Bullet 
{

	public static var CB_SPACE_RIFT_BULLET:CbType = new CbType();
	
	public function new(x, y) 
	{
		super(x, y);
		this.bulletType = BulletType.SpaceRift;
		this.speed = 600;
		this.damage = 25;
		this.explotionRadius = 0; // Ellipse set later
		createCircularBody(2);
		body.space = FlxNapeSpace.space;
		body.cbTypes.add(CB_SPACE_RIFT_BULLET);
		FlxG.sound.play("assets/music/space_rift.mp3", 1, false);
	}
	
}