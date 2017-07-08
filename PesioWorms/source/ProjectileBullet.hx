package;

import flixel.addons.nape.FlxNapeSpace;
import flixel.addons.nape.FlxNapeSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import nape.callbacks.CbType;
import Bullet.BulletType;

/**
 * ...
 * @author Martin Long Gonzalez
 */
class ProjectileBullet extends Bullet 
{

	public static var CB_PROJECTILE_BULLET:CbType = new CbType();
	
	public function new(x, y) 
	{
		super(x, y);
		this.bulletType = BulletType.Projectile;
		this.speed = 500;
		this.damage = 50;
		this.explotionRatio = 2; // > Ratio Less explotion radius
		createCircularBody(2);
		body.space = FlxNapeSpace.space;
		body.cbTypes.add(CB_PROJECTILE_BULLET);
	}
	
}