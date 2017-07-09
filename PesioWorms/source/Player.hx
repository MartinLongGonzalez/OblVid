package;
import flash.geom.Point;
import flixel.addons.nape.FlxNapeSpace;
import flixel.addons.nape.FlxNapeSprite;
import nape.callbacks.CbType;
import Bullet.BulletType;

/**
 * ...
 * @author Martin Long Gonzalez
 */


 
 class Player extends FlxNapeSprite
{
	public static var CB_PLAYER1:CbType = new CbType();
	public static var CB_PLAYER2:CbType = new CbType();
	
	public var movement:Point;
	public var healthPoints:Int = 100;
	public var bulletSelected:BulletType; 
	public var cbType:CbType;
	public var state:PlayerState;
	


	
	public function new(x, y) 
	{
		super(x, y, null, false);
		bulletSelected = BulletType.Projectile;
		createCircularBody(20);
		body.space = FlxNapeSpace.space;
		state = new StillState(this);
	}
	
	public function addCbType(cbType)
	{
		this.cbType = cbType;
		this.body.cbTypes.add(cbType);
	}
	public function handle(){
		state.update();
	}
	
}