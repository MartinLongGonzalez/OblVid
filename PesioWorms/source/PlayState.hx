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
import Bullet;
//import Bullet.BulletType;
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
	private var randomSeed:Int;
	private var playersInMap:Int=0;
	private var turnActive = true;
	var currentShootingTime:Float = 0; // Estas vars son para pausear las acciones de los jugadores despues de que disparan por 5 segundos
	var maxShootingTime:Float = 1;

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
			newBomb.graphics.drawEllipse(-400, 0, 800, 25); // No explosion radius --> space rift (has different dimensions) -400 to center it
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
		text1 = new FlxTextField(550, 10, 100, "Player 1: 100 HP", 9, true, null);
		add(text1);
		text2 = new FlxTextField(10, 10, 100, "Player 2: 100 HP", 9, true, null);
		add(text2);
		text_time = new FlxTextField(320, 10, 100, "20", 9, true, null);
		add(text_time);
		text_weapon = new FlxTextField(320, 20, 100, "BAZOOKA", 9, true, null);
		add(text_weapon);
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
		if (playersInMap<2 && FlxG.mouse.justPressed )
		{
			var mp = Vec2.get(FlxG.mouse.x, FlxG.mouse.y);
			bodyList = FlxNapeSpace.space.bodiesUnderPoint(mp, null, bodyList);
			if (bodyList.empty())
			{
				if (playersInMap == 0)
				{
					var player1 = addPlayer(mp, Player.CB_PLAYER1);
					player1.state = new StillState(player1);
					Turn.instance().player = player1;

				}
				else
				{
					addPlayer(mp, Player.CB_PLAYER2);
					//Turn.instance().paused = false;
				}
			}
			// recycle nodes.
			bodyList.clear();
			mp.dispose();
		}

		if (Turn.instance().paused != true && playersInMap>=2 )
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
			}

		}
		super.update(elapsed);
	}

	private function updateTimer()
	{
		var timeElapsed = 20 - Turn.instance().timer.currentCount / 100;
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
		return player;
	}

	private function shootBullet()
	{
		var mousePosition = FlxG.mouse.getPosition();
		var playerPosX = Turn.instance().player.body.position.x;
		var playerPosY = Turn.instance().player.body.position.y;
		switch (Turn.instance().player.bulletSelected)
		{
			case BulletType.Bazooka: { bullet = new BazookaBullet(playerPosX, playerPosY - 30);}
			case BulletType.Shotgun: { bullet = new ShotgunBullet(playerPosX, playerPosY - 30); }
			case BulletType.SpaceRift: { bullet = new SpaceRiftBullet(playerPosX, playerPosY - 30); }
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
					explosion(bullet.body.position);
					bullet.destroy();
				}
			}
		});

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
							text1.text = "Player 1: " + player.healthPoints + " HP";
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
							text2.text = "Player 2: " + player.healthPoints + " HP";
						}
					}
				}
			});
			bullet.destroy();
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
}