package ;

import flixel.addons.nape.FlxNapeSpace;
import flixel.addons.nape.FlxNapeSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import nape.callbacks.CbType;
import Bullet.BulletType;

/**
 * ...
 * @author Martin Long Gonzalez
 */
class BazookaBullet extends Bullet 
{

	public static var CB_BAZOOKA_BULLET:CbType = new CbType();
	
	public function new(x, y) 
	{
		super(x, y);
		this.bulletType = BulletType.Bazooka;
		this.speed = 500;
		this.damage = 50;
		this.explotionRadius = 80;
		this.bulletSizeRadius = 2;
		createCircularBody(this.bulletSizeRadius);
		body.space = FlxNapeSpace.space;
		body.cbTypes.add(CB_BAZOOKA_BULLET);
	}
	
}