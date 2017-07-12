package;

import flash.geom.Rectangle;
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
import Bullet;
//import Bullet.BulletType;
class PlayState extends FlxState
{
	private var playersPlaying:Int = 2;
	private var bodyList:BodyList = null;
	private var terrain:Terrain;
	private var bomb:Sprite;
	//private var hand:PivotJoint;
	private var firstTurn:Bool = true;
	private var text_hp_p1:FlxTextField;
	private var text_hp_p2:FlxTextField;
	private var text_time:FlxTextField;
	private var text_weapon:FlxTextField;
	private var text_damage_p1:FlxTextField;
	private var text_damage_p2:FlxTextField;

	private var turnTime = 10;
	private var bullet:Bullet;
	private var turn:Turn;
	private var randomSeed:Int;
	private var playersInMap:Int=0;
	private var turnActive = true;
	var currentShootingTime:Float = 0; // Estas vars son para pausear las acciones de los jugadores despues de que disparan por 5 segundos
	var maxShootingTime:Float = 1.5;

	public function setRandomSeed(randomSeed:Int):Void
	{
		this.randomSeed = randomSeed;
	}

	override public function create():Void
	{
		init();

		super.create();
	}

	private function init():Void
	{
		setTextFields();

		FlxNapeSpace.init();
		Turn.instance();

		FlxNapeSpace.space.gravity = new Vec2(0, 600);

		FlxNapeSpace.createWalls();

		FlxNapeSpace.drawDebug = true;

		init_collisions();
		/*
				hand = new PivotJoint(FlxNapeSpace.space.world, null, Vec2.weak(), Vec2.weak());
				hand.active = false;
				hand.stiff = false;
				hand.maxForce = 1e5;
				hand.space = FlxNapeSpace.space;
		*/
		var w:Int = FlxG.width;
		var h:Int = FlxG.height;

		// Initialise terrain bitmap.
		#if flash
		var bit = new BitmapData(w, h, true, 0x00000000);
		bit.perlinNoise(200, 200, 2, randomSeed, false, true, BitmapDataChannel.ALPHA, false);
		#else
		var bit = Assets.getBitmapData("assets/terrain.png");
		#end

		// Create initial terrain state, invalidating the whole screen.
		terrain = new Terrain(bit, 30, 5);
		terrain.invalidate(new AABB(0, 0, w, h), this);
		terrain.sprite.alpha = 0;
		add(terrain.sprite);

		// Create bomb sprite for destruction
		//player = player1;
		createBomb(40); // Bazooka bomb
	}

	private function createBomb(radius:Float)
	{
		var newBomb = new Sprite();
		newBomb.graphics.beginFill(0xffffff, 1);
		if (radius>0)
			newBomb.graphics.drawCircle(0, 0, radius);
		else
			newBomb.graphics.drawEllipse(-450, 0, 900, 25); // No explosion radius --> space rift (has different dimensions) -400 to center it
		this.bomb = newBomb;
	}

	private function init_collisions() : Void
	{

		FlxNapeSpace.space.listeners.add(
			new InteractionListener(
				CbEvent.BEGIN,
				InteractionType.COLLISION,
				BazookaBullet.CB_BAZOOKA_BULLET,
				CbType.ANY_BODY,
				bulletHitTerrain));

		FlxNapeSpace.space.listeners.add(
			new InteractionListener(
				CbEvent.BEGIN,
				InteractionType.COLLISION,
				BazookaBullet.CB_BAZOOKA_BULLET,
				Player.CB_PLAYER1,
				bulletHitPlayer));

		FlxNapeSpace.space.listeners.add(
			new InteractionListener(
				CbEvent.BEGIN,
				InteractionType.COLLISION,
				BazookaBullet.CB_BAZOOKA_BULLET,
				Player.CB_PLAYER2,
				bulletHitPlayer));

		FlxNapeSpace.space.listeners.add(
			new InteractionListener(
				CbEvent.BEGIN,
				InteractionType.COLLISION,
				ShotgunBullet.CB_SHOTGUN_BULLET,
				CbType.ANY_BODY,
				bulletHitTerrain));

		FlxNapeSpace.space.listeners.add(
			new InteractionListener(
				CbEvent.BEGIN,
				InteractionType.COLLISION,
				ShotgunBullet.CB_SHOTGUN_BULLET,
				Player.CB_PLAYER1,
				bulletHitPlayer));

		FlxNapeSpace.space.listeners.add(
			new InteractionListener(
				CbEvent.BEGIN,
				InteractionType.COLLISION,
				ShotgunBullet.CB_SHOTGUN_BULLET,
				Player.CB_PLAYER2,
				bulletHitPlayer));

		FlxNapeSpace.space.listeners.add(
			new InteractionListener(
				CbEvent.BEGIN,
				InteractionType.COLLISION,
				SpaceRiftBullet.CB_SPACE_RIFT_BULLET,
				CbType.ANY_BODY,
				bulletHitTerrain));

		FlxNapeSpace.space.listeners.add(
			new InteractionListener(
				CbEvent.BEGIN,
				InteractionType.COLLISION,
				SpaceRiftBullet.CB_SPACE_RIFT_BULLET,
				Player.CB_PLAYER1,
				bulletHitPlayer));

		FlxNapeSpace.space.listeners.add(
			new InteractionListener(
				CbEvent.BEGIN,
				InteractionType.COLLISION,
				SpaceRiftBullet.CB_SPACE_RIFT_BULLET,
				Player.CB_PLAYER2,
				bulletHitPlayer));

	}

	private function setTextFields()
	{
		text_hp_p1 = new FlxTextField(10, 10, 100, "Player 1: "+GameConfigurations.instance().getPlayersLife(), 9, true, null);
		text_hp_p2 = new FlxTextField(550, 10, 100, "Player 2: "+GameConfigurations.instance().getPlayersLife(), 9, true, null);
		text_time = new FlxTextField(320, 10, 100, "20", 9, true, null);
		text_weapon = new FlxTextField(320, 20, 100, "BAZOOKA", 9, true, null);
		text_damage_p2 = new FlxTextField(1, 1, 110, "0", 12, true, null);
		text_damage_p1 = new FlxTextField(1, 1, 110, "0", 12, true, null);
		add(text_damage_p1);
		add(text_damage_p2);
		add(text_hp_p1);
		add(text_hp_p2);
		add(text_time);
		add(text_weapon);
		//add(text_explosion_damage);
		//text_direct_hit_damage.color = new FlxColor(0xd82222);
	}

	function explosion(pos:Vec2)
	{
		var region = AABB.fromRect(bomb.getBounds(bomb));
		// Erase bomb graphic out of terrain.
		#if flash
		terrain.bitmap.draw(bomb, new Matrix(1, 0, 0, 1, pos.x, pos.y), null, BlendMode.ERASE);
		#else
		var radius:Int = Std.int(region.width / 2);
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
		CheckGameEnd();
		
		if (playersInMap < playersPlaying && FlxG.mouse.justPressed )
		{
			var mp = Vec2.get(FlxG.mouse.x, FlxG.mouse.y);
			bodyList = FlxNapeSpace.space.bodiesUnderPoint(mp, null, bodyList);
			if (bodyList.empty())
			{
				if (playersInMap == 0)
				{
					var player1 = addPlayer(mp, Player.CB_PLAYER1);
					//player1.state = new StillState(player1);
					//Turn.instance().player = player1;

				}
				else
				{
					var player2= addPlayer(mp, Player.CB_PLAYER2);
					Turn.instance().player = player2;
					//Turn.instance().paused = false;
				}
			}
			// recycle nodes.
			bodyList.clear();
			mp.dispose();
		}
		else{
			if (Turn.instance().paused != true && playersInMap>=playersPlaying )
			{
				for (player in Turn.instance().players) // se debería lamar solo creo
					player.update(elapsed);
				//Turn.instance().player.update(elapsed);

				if (FlxG.keys.pressed.ONE)
				{
					Turn.instance().player.bulletSelected = BulletType.Bazooka;
					text_weapon.text = "BAZOOKA";
				}
				if (FlxG.keys.pressed.TWO)
				{
					Turn.instance().player.bulletSelected = BulletType.Shotgun;
					text_weapon.text = "SHOTGUN";
				}
				if (FlxG.keys.pressed.THREE)
				{
					Turn.instance().player.bulletSelected = BulletType.SpaceRift;
					text_weapon.text = "SPACE RIFT";
				}

				if ( FlxG.mouse.justPressed )
				{
					shootBullet();
					Turn.instance().paused = true;
				}
				updateTimer();

			}
			else if (playersInMap >=2)
			{
				if (this.turnActive)
				{
					Turn.instance().player.state = new WaitingForTurnState(Turn.instance().player);
					this.turnActive = false;
				}
				currentShootingTime += elapsed;
				if (currentShootingTime > maxShootingTime)
				{
					Turn.instance().finish();
					this.turnActive = true;
					//player = Turn.instance().player;
					updateWeaponText();
					currentShootingTime = 0;
					resetDamagesPerTurn();
					text_damage_p1.visible = false;
					text_damage_p2.visible = false;
				}

			}

		}
		super.update(elapsed);

	}

	private function updateTimer()
	{
		var timeElapsed = turnTime - Turn.instance().timer.currentCount / 100;
		if ( timeElapsed < 10)
		{
			log( ("" + timeElapsed).substr(0, 1) ) ;
		}
		else
		{
			log(("" + timeElapsed).substr(0, 2) ) ;
		}
		if (timeElapsed <= 0)
		{
			Turn.instance().player.state = new WaitingForTurnState(Turn.instance().player);
			this.turnActive = false;
			Turn.instance().finish();
			this.turnActive = true;
		}

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
		Turn.instance().players.insert(Turn.instance().players.length, player);
		player.state = new WaitingForTurnState(player);
		playersInMap++;
		add(player);
		return player;
	}

	private function shootBullet()
	{
		var mousePosition = FlxG.mouse.getPosition();
		var playerPosX = Turn.instance().player.body.position.x;
		var playerPosY = Turn.instance().player.body.position.y;
		var gunDistance:Int = 0;
		if (mousePosition.x <= playerPosX){
			gunDistance = -24;
		}else{
			gunDistance = 24;
		}
		switch (Turn.instance().player.bulletSelected)
		{
			case BulletType.Bazooka: { bullet = new BazookaBullet(playerPosX + gunDistance, playerPosY );}
			case BulletType.Shotgun: { bullet = new ShotgunBullet(playerPosX + gunDistance, playerPosY ); }
			case BulletType.SpaceRift: { bullet = new SpaceRiftBullet(playerPosX + gunDistance, playerPosY ); }
		}
		createBomb(bullet.explotionRadius);
		add(bullet);
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
		interactorCbTypes2.foreach(function(obj)
		{
			if (bullet != null)
			{
				if (obj == Player.CB_PLAYER1 || obj == Player.CB_PLAYER2 )
				{

				}
				else
				{
					damageNearByPlayers();  // Explosion damages players depending on distance to them
					explosion(bullet.body.position); /// Explosion's Graphics
					bullet.destroy();
				}
			}
		});

	}

	private function damageNearByPlayers():Void
	{

		for (player in Turn.instance().players)
		{
			if (bullet.bulletType!=BulletType.SpaceRift)
			{
				var bulletPos = bullet.getPosition();
				var playerPos = player.getPosition();
				var distance = bulletPos.distanceTo(playerPos);
				if (distance <= bullet.explotionRadius )
				{
					var damageDone = Std.int(bullet.damage - (distance * bullet.damage / bullet.explotionRadius ) ); // damage = bullet.dmg - (distanc/radius)*bulletDamage
					player.healthPoints -=  damageDone;
					player.damageDone += damageDone;
					damage_text(player);
					updatePlayersTexts(player);
				}

			}
			else
			{
				// SpaceRift makes the same damage in all its rectangle area
				var ellipsesRectangle = new Rectangle(bullet.body.position.x - 450, bullet.body.position.y,900,30);
				var playersRectangle = new Rectangle(player.body.position.x, player.body.position.y,30,30);
				if (ellipsesRectangle.intersects(playersRectangle))
				{
					player.healthPoints -= 20;
					player.damageDone += 20;
					damage_text(player);
					updatePlayersTexts(player);
				}
			}
		}
	}

	public function bulletHitPlayer(callback:InteractionCallback)
	{

		if (bullet!=null)
		{
			var bullet_dmg = bullet.damage;
			var interactorCbTypes2 = callback.int2.cbTypes;
			interactorCbTypes2.foreach(function(obj)
			{
				if (obj == Player.CB_PLAYER1)
				{
					for (player in Turn.instance().players)
					{
						if (player.cbType == obj)
						{
							player.healthPoints -= bullet_dmg;
							updatePlayersTexts(player);
							player.damageDone += bullet_dmg;
							damage_text(player);
						}
					}

				}
				if (obj == Player.CB_PLAYER2)
				{
					for (player in Turn.instance().players)
					{
						if (player.cbType == obj)
						{
							player.healthPoints -= bullet_dmg;
							updatePlayersTexts(player);
							player.damageDone += bullet_dmg;
							damage_text(player);
							//
						}
					}
				}
			});
			bullet.destroy();
		}
	}

	private function resetDamagesPerTurn()
	{
		for (player in Turn.instance().players)
		{
			player.damageDone = 0;
		}
	}

	public function damage_text(player:Player)
	{
		if (player.cbType==Player.CB_PLAYER1)
		{
			text_damage_p1.visible = true;
			//add(text_damage_p1);
			text_damage_p1.text =  Std.string(player.damageDone);
			text_damage_p1.x = player.body.position.x;
			text_damage_p1.y =  player.body.position.y - 30;
		}
		if (player.cbType == Player.CB_PLAYER2)
		{
			text_damage_p2.visible = true;
			//add(text_damage_p2);
			text_damage_p2.text =  Std.string(player.damageDone);
			text_damage_p2.x =  player.body.position.x;
			text_damage_p2.y = player.body.position.y - 30;
		}

	}

	public function log(string)
	{
		text_time.text = string;
	}

	public function updateWeaponText()
	{
		switch (Turn.instance().player.bulletSelected)
		{
			case BulletType.Bazooka: { text_weapon.text = "BAZOOKA"; }
			case BulletType.Shotgun: {  text_weapon.text = "SHOTGUN"; }
			case BulletType.SpaceRift: { text_weapon.text = "SPACE RIFT"; }
		}
	}

	public function updatePlayersTexts(player:Player):Void
	{
		if (player.cbType==Player.CB_PLAYER1)
		{
			text_hp_p1.text = "Player 1: " + player.healthPoints + " HP";
		}
		if (player.cbType == Player.CB_PLAYER2)
		{
			text_hp_p2.text = "Player 2: " + player.healthPoints + " HP";
		}

	}
	
	private function CheckGameEnd()
	{
		for (player in Turn.instance().players) 
		{
			if (player.healthPoints <= 0){
				var gameEndState = new GameEndState();
				gameEndState.setMainText("You Win!");
				Turn.restart();
				FlxG.switchState(gameEndState);
			}
		}
	}

}
