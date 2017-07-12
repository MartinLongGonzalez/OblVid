package ;
import flash.geom.Point;
import flixel.FlxG;
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
	public var damageDone:Int = 0;
	
	
	public function new(x, y)
	{
		super(x, y, null, false);
		healthPoints = GameConfigurations.instance().getPlayersLife();
		bulletSelected = BulletType.Bazooka;
	
		createRectangularBody(30, 30);
		loadGraphic("assets/worm_left.png");
		body.space = FlxNapeSpace.space;
		body.allowRotation = false;
		setBodyMaterial(0,0.1,0.9,0.3);// Valores default-->  Elasticidad 1, Rozamiento Cinetico 0.2 , Rozamiento Estatico 0.4 , Densidad 1
	}

	public function addCbType(cbType)
	{
		this.cbType = cbType;
		this.body.cbTypes.add(cbType);
	}

	override public function update(elapsed:Float):Void
	{
		var mp = FlxG.mouse.getPosition().x;
		var playerPosX = body.position.x;
		if (mp > playerPosX)
		{
			loadGraphic("assets/worm_right.png");	
		}
		else 
		{
			loadGraphic("assets/worm_left.png");
		}
		state.update();
		
		super.update(elapsed);

	}

}

