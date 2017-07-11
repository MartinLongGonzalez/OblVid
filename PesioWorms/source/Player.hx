package ;
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
	public var damageDone:Int=0;
	//public var width:Int;
	//public var height:Int;

	public function new(x, y)
	{
		super(x, y, null, false);
		bulletSelected = BulletType.Bazooka;
		//width = 30;
		//height = 30;
		createRectangularBody(30, 30);

		/*
		 * 		//this.loadGraphic("hero.png", true, 45, 60);
				animation.add("run", [2, 3, 4, 5, 6, 7, 8, 9], 30);
				animation.add("stand", [10]);
				animation.add("jump", [1]);
				animation.add("fall", [0]);
				animation.add("wallHang",[11]);
				animation.play("stand");
				*/
		//createRectangularBody(20,40);
		body.space = FlxNapeSpace.space;
		body.allowRotation = false;
		//elasticity = 0;
		setBodyMaterial(0,0.1,0.9,0.3);// Valores default-->  Elasticidad 1, Rozamiento Cinetico 0.2 , Rozamiento Estatico 0.4 , Densidad 1
	}

	public function addCbType(cbType)
	{
		this.cbType = cbType;
		this.body.cbTypes.add(cbType);
	}

	override public function update(elapsed:Float):Void
	{
		state.update();
		//this.updateAnimation(elapsed);
		super.update(elapsed);

	}

}

