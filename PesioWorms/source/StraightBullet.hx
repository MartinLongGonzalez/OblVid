package;
import flixel.addons.nape.FlxNapeSpace;
import flixel.addons.nape.FlxNapeSprite;
import nape.callbacks.CbType;

/**
 * ...
 * @author ...
 */
class StraightBullet extends FlxNapeSprite
{

	
	public static var CB_STRAIGHT_BULLET:CbType = new CbType();
	
	public function new(x, y) 
	{
		super(x, y, null, false);
		createCircularBody(0.2);
		body.space = FlxNapeSpace.space;
		body.cbTypes.add(CB_STRAIGHT_BULLET);
	}
	
}