package;

import flixel.addons.nape.FlxNapeSpace;
import flixel.addons.nape.FlxNapeSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import nape.callbacks.CbType;

/**
 * ...
 * @author Martin Long Gonzalez
 */
class ProjectileBullet extends FlxNapeSprite 
{

	public static var CB_PROJECTILE_BULLET:CbType = new CbType();
	
	public function new(x, y) 
	{
		super(x, y, null, false);
		createCircularBody(2);
		body.space = FlxNapeSpace.space;
		body.cbTypes.add(CB_PROJECTILE_BULLET);
	}
	
}