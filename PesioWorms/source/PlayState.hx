package;

import flixel.addons.nape.FlxNapeSpace;
import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeTilemap;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.text.FlxTextField;
import flixel.graphics.frames.FlxImageFrame;
import flixel.graphics.frames.FlxTileFrames;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.math.FlxVelocity;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.constraint.PivotJoint;
import nape.geom.AABB;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyList;
import nape.phys.BodyType;
import nape.shape.Circle;
import nape.shape.Polygon;
import openfl.Assets;
import openfl.geom.Matrix;
import openfl.display.Sprite;
import openfl.display.BlendMode;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import Bullet.BulletType;
class PlayState extends FlxState
{
	private var bodyList:BodyList = null;
	private var terrain:Terrain;
	private var bomb:Sprite;
	private var hand:PivotJoint;
	private var arrowLeftKeyIsBeingHeld:Bool;
	private var arrowRightKeyIsBeingHeld:Bool;
	private var text1:FlxTextField;
	private var text2:FlxTextField;
	private var text_time:FlxTextField;
	private var text_weapon:FlxTextField;
	private var bullet:Bullet;
	private var turn:Turn;

	var currentShootingTime:Float = 0; // Estas vars son para pausear las acciones de los jugadores despues de que disparan por 5 segundos
	var maxShootingTime:Float = 2;
	
	//public var CB_PROJECTILE_BULLET:CbType = new CbType();
	//public var CB_STRAIGHT_BULLET:CbType = new CbType();
	
	override public function create():Void
	{
		init();

		super.create();
	}
	
	private function init():Void
	{
		setTextFields();
		
		FlxNapeSpace.init();
		turn = new Turn();

		FlxNapeSpace.space.gravity = new Vec2(0, 600);

		FlxNapeSpace.createWalls();

		FlxNapeSpace.drawDebug = true;

		init_collisions();


		hand = new PivotJoint(FlxNapeSpace.space.world, null, Vec2.weak(), Vec2.weak());
		hand.active = false;
		hand.stiff = false;
		hand.maxForce = 1e5;
		hand.space = FlxNapeSpace.space;

		var w:Int = FlxG.width;
		var h:Int = FlxG.height;

		// Initialise terrain bitmap.
		#if flash
		var bit = new BitmapData(w, h, true, 0x00000000);
		bit.perlinNoise(200, 200, 2, 0x3ed, false, true, BitmapDataChannel.ALPHA, false);
		#else
		var bit = Assets.getBitmapData("assets/terrain.png");
		#end

		// Create initial terrain state, invalidating the whole screen.
		terrain = new Terrain(bit, 30, 5);
		terrain.invalidate(new AABB(0, 0, w, h), this);
		terrain.sprite.alpha = 0;
		add(terrain.sprite);
		//add players


		var playerPosition = new Vec2(0, 0);
		var player1 = addPlayer(playerPosition, Player.CB_PLAYER1);
		turn.player = player1;
		var playerPosition = new Vec2(300,300);
		addPlayer(playerPosition, Player.CB_PLAYER2);
		// Create bomb sprite for destruction
		//player = player1;
		bomb = new Sprite();
		bomb.graphics.beginFill(0xffffff, 1);
		bomb.graphics.drawCircle(0, 0, 40);

	}
	
	private function init_collisions() : Void {
		
				
		FlxNapeSpace.space.listeners.add(
			new InteractionListener(
				CbEvent.BEGIN,
				InteractionType.COLLISION,
				ProjectileBullet.CB_PROJECTILE_BULLET,
				CbType.ANY_BODY,
				bulletHitTerrain));
				
		FlxNapeSpace.space.listeners.add(
			new InteractionListener(
				CbEvent.BEGIN,
				InteractionType.COLLISION,
				ProjectileBullet.CB_PROJECTILE_BULLET,
				Player.CB_PLAYER1,
				bulletHitPlayer));
				
		FlxNapeSpace.space.listeners.add(
			new InteractionListener(
				CbEvent.BEGIN,
				InteractionType.COLLISION,
				ProjectileBullet.CB_PROJECTILE_BULLET,
				Player.CB_PLAYER2,
				bulletHitPlayer));
				
		FlxNapeSpace.space.listeners.add(
			new InteractionListener(
				CbEvent.BEGIN,
				InteractionType.COLLISION,
				StraightBullet.CB_STRAIGHT_BULLET,
				CbType.ANY_BODY,
				bulletHitTerrain));
				
		FlxNapeSpace.space.listeners.add(
			new InteractionListener(
				CbEvent.BEGIN,
				InteractionType.COLLISION,
				StraightBullet.CB_STRAIGHT_BULLET,
				Player.CB_PLAYER1,
				bulletHitPlayer));
				
		FlxNapeSpace.space.listeners.add(
			new InteractionListener(
				CbEvent.BEGIN,
				InteractionType.COLLISION,
				StraightBullet.CB_STRAIGHT_BULLET,
				Player.CB_PLAYER2,
				bulletHitPlayer));
		
	}
	
	private function setTextFields()
	{
		text1 = new FlxTextField(550, 10, 100, "Player 1: 100 HP", 9, true, null);
		add(text1);
		text2 = new FlxTextField(10, 10, 100, "Player 2: 100 HP", 9, true, null);
		add(text2);
		text_time = new FlxTextField(320, 10, 100, "20", 9, true, null);
		add(text_time);
		text_weapon = new FlxTextField(320, 20, 100, "BAZOOKA", 9, true, null);
		add(text_weapon);
	}
	
	function explosion(pos:Vec2, explosionRatio:Float = 2)
	{
		var region = AABB.fromRect(bomb.getBounds(bomb));
		// Erase bomb graphic out of terrain.
		#if flash
		terrain.bitmap.draw(bomb, new Matrix(1, 0, 0, 1, pos.x, pos.y), null, BlendMode.ERASE);
		#else
		var radius:Int = Std.int(region.width / explosionRatio);
		var diameter:Int = 2 * radius;
		var radiusSquared:Int = radius * radius;
		var centerX:Int = Std.int(pos.x);
		var centerY:Int = Std.int(pos.y);
		var dx:Int, dy:Int;

		for (x in 0...diameter)
		{
			for (y in 0...diameter)
			{
				dx = radius - x;
				dy = radius - y;
				if ((dx * dx + dy * dy) > radiusSquared)
				{
					continue;
				}
				terrain.bitmap.setPixel32(centerX + dx, centerY + dy, FlxColor.TRANSPARENT);
			}
		}
		#end

		// Invalidate region of terrain effected.
		region.x += pos.x;
		region.y += pos.y;
		terrain.invalidate(region, this);
	}

	override public function update(elapsed:Float):Void
	{
		if (turn.paused!=true){
			/*if (FlxG.keys.pressed.RIGHT)     // left
			{
				player.body.velocity.x = 100;
			}
			if (FlxG.keys.pressed.LEFT)
			{
				player.body.velocity.x = -100;
			}*/
			turn.player.handle();
			if (FlxG.keys.pressed.UP)
			{
				//player.body.velocity.y = -100;
			}
			if (FlxG.keys.pressed.DOWN)
			{
				//player.body.= 1000;
			}
			if (FlxG.keys.pressed.ONE)
			{
					turn.player.bulletSelected = BulletType.Projectile;
					text_weapon.text = "BAZOOKA";
			}
			if (FlxG.keys.pressed.TWO)
			{
					turn.player.bulletSelected = BulletType.Straight;
					text_weapon.text = "SHOTGUN";
			}
			
			log(("" + (20 - turn.timer.currentCount / 100)).substr(0,2) );
			if (20 - turn.timer.currentCount / 100 <= 0){
				turn.finish();
			}
			//if (FlxG.keys.justPressed.SPACE)
			if( FlxG.mouse.justPressed)
			{
				shootBullet();   
				turn.paused = true;
			}
			if (FlxG.keys.justPressed.SPACE){
				//shootBullet2();
				// turn.paused = true;
			}
		}else{
				currentShootingTime += elapsed;
				if (currentShootingTime > maxShootingTime){
					turn.finish();
					//player = turn.player;
					updateWeaponText();
					currentShootingTime = 0;
				}
				 
				
		}
		super.update(elapsed);
	}

	
	
	function createObject(pos:Vec2)
	{
		var sprite = new FlxNapeSprite(pos.x, pos.y, null, false);

		if (FlxG.random.bool(33))
			sprite.createCircularBody(10 + Math.random() * 20);
		else
			sprite.createRectangularBody(10 + Math.random() * 20, 10 + Math.random() * 20);

		sprite.body.space = FlxNapeSpace.space;
		add(sprite);
	}

	private function addPlayer(pos:Vec2, cbType):Player
	{
		var player = new Player(pos.x, pos.y);
		player.addCbType(cbType);
		turn.players.insert(turn.players.length, player);
		return player;
	}

	private function shootBullet()
	{

		//player = turn.player;
		var mousePosition = FlxG.mouse.getPosition();
		var playerPosX = turn.player.body.position.x;
		var playerPosY = turn.player.body.position.y;
		switch (turn.player.bulletSelected){
			case BulletType.Projectile: { bullet = new ProjectileBullet(playerPosX + 30, playerPosY - 30); }
			case BulletType.Straight: { bullet = new StraightBullet(playerPosX + 30, playerPosY - 30); }
		}
		//bullet = new ProjectileBullet(playerPosX + 30, playerPosY + 30);
		add(bullet);
		//bullet.makeGraphic(20, 20, FlxColor.WHITE);
		//bullet.body.position.x = playerPosX;
		//bullet.body.position.y = playerPosY-30;
		var angle = FlxG.mouse.getPosition()
			.angleBetween(FlxPoint.get(bullet.body.position.x, bullet.body.position.y));
		angle += 90;
		bullet.body.velocity.setxy(
			bullet.speed * Math.cos(angle * 3.14 / 180),
			bullet.speed * Math.sin(angle * 3.14 / 180));
		
		bullet.body.angularVel = 30;

	}


	public function bulletHitTerrain(callback:InteractionCallback)
	{
		var interactorCbTypes2 = callback.int2.cbTypes;
		interactorCbTypes2.foreach(function(obj){
			if (bullet != null){
			//if (bullet != null && bullet.had_contact == false){
				if (obj == Player.CB_PLAYER1 || obj == Player.CB_PLAYER2 ){
					
				}else{
					explosion(bullet.body.position, bullet.explotionRatio);
					bullet.had_contact = true;
					bullet.destroy();
					
				}			
			}
		});
		//if (bullet != null && bullet.had_contact == false){
	
	}
	
	public function bulletHitPlayer(callback:InteractionCallback)
	{
		//if(bullet!=null && bullet.had_contact==false){
		if(bullet!=null){
			var bullet_dmg = bullet.damage;
			var interactorCbTypes2 = callback.int2.cbTypes;
			interactorCbTypes2.foreach(function(obj){
				if (obj == Player.CB_PLAYER1)
				{
					for (player in turn.players)
					{
						if (player.cbType == obj)
						{
							player.healthPoints -= bullet_dmg;
							text1.text = "Player 1: " + player.healthPoints + " HP";
						}
					}
					
				}
				if (obj == Player.CB_PLAYER2)
				{
					for (player in turn.players)
					{
						if (player.cbType == obj)
						{
							player.healthPoints -= bullet_dmg;
							text2.text = "Player 2: " + player.healthPoints + " HP";
						}
					}
				}
			});
		bullet.had_contact = true;
		bullet.destroy();
		}
	}

	public function log(string)
	{
		text_time.text = string;
	}
	
	public function updateWeaponText()
	{
		switch(turn.player.bulletSelected){
			case BulletType.Projectile: { text_weapon.text = "BAZOOKA"; }
			case BulletType.Straight: {  text_weapon.text = "SHOTGUN"; }
		}
	}
}