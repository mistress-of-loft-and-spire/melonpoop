package ent;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.Mask;
import com.haxepunk.RenderMode;
import com.haxepunk.Scene;
import com.haxepunk.Sfx;
import com.haxepunk.Tween;
import com.haxepunk.Tweener;
import com.haxepunk.ds.Either;
import com.haxepunk.graphics.Animation;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.atlas.Atlas;
import com.haxepunk.graphics.atlas.AtlasData;
import com.haxepunk.graphics.atlas.TileAtlas;
import com.haxepunk.masks.Grid;
import com.haxepunk.masks.Hitbox;
import com.haxepunk.tweens.misc.Alarm;
import com.haxepunk.tweens.misc.VarTween;
import com.haxepunk.utils.Ease;
import ent.Spawn;
import openfl.display.BitmapData;
import openfl.display.IBitmapDrawable;
import openfl.events.EventDispatcher;
import openfl.events.IEventDispatcher;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.media.SoundChannel;
import openfl.geom.Vector3D;
import persp.Entity3D;
import screen.Plus;

/**
 * ...
 * @author voec
 */
class Snake extends Entity3D
{
	
	var train:Sfx = new Sfx("sfx/train.ogg");
	var nom:Sfx = new Sfx("sfx/nomnom.ogg");
	
	var eyes:Spritemap = new Spritemap("gfx/snake.png", 56, 56);
	var head:Spritemap = new Spritemap("gfx/snake.png", 56, 56);

	public function new(x:Float = 40, y:Float = 40, z:Float = 0)
	{
		super(x, y, z, -5, true);
		
		head.centerOrigin();
		eyes.centerOrigin();
		
		head.add("nom", [1,2,3,4], 14);
		head.play("nom");
		
		eyes.add("blink", [6,6,6,6,6,7,0,0,7,6], 9, true);
		eyes.play("blink");
		
		addGraphic(head);
		addGraphic(eyes);
		
		setHitbox(40, 40, 20, 20);
		
		type = "snake";
		
		changeDirection();
	}
	
	var fastTimer:Float = 0;
	var fastMode:Bool = false;
	
	var directionDelta:Float = 0;
	
	public var eaten1:Int = 0;
	public var eaten2:Int = 0;
	
	public var layerZ:Int = 0;
	
	var speed:Float = 2;
	var direction:Float = 0;
	
	var timer2:Float = 0;
	var timer3:Float = 0;
	
	var targetColor:Int = 0;
	
	var tau:Float = 6.283;
	
	var sin:Float = 0;
	
	var nextPoop1:Int = -1;
	var nextPoop2:Int = -1;
	
	override public function update():Void
	{
		//DIRECTION
		if (fastMode) direction += directionDelta / 2 * MainScene.elapsed;

		direction += directionDelta * MainScene.elapsed;
		
		sin += 0.1 * MainScene.elapsed;
		sin %= tau;
		
		direction += (Math.sin(sin) * 2);

		if (direction < 0) direction += 360;
		direction %= 360;

		//MOVEMENT
		p.x += Math.cos(direction * (Math.PI / - 180)) * speed * MainScene.elapsed;
		p.y += Math.sin(direction * (Math.PI / - 180)) * speed * MainScene.elapsed;

		head.angle = eyes.angle = (direction + 90) + MainScene.rotationAngle;
		
		//BORDER CLAMP
		if (p.x < -250 || p.x > 250 || p.y < -250 || p.y > 250) direction = HXP.angle(0, 0, p.x, p.y) + 180;
		
		layerZ = Math.floor(p.z / 5);
		
		//TIMER
		timer2 += HXP.elapsed; timer3 += HXP.elapsed;
		
		fastTimer += HXP.elapsed;
		
		if (fastTimer > 50 && fastMode == false)
		{
			train.play(0.6);
			scene.add(new Plus("hot"));
			fastMode = true;
			speed = 3.3;
		}
		
		if (timer2 > 5)
		{
			nextPoop1 = eaten1;
			nextPoop2 = eaten2;
			eaten1 = 0; eaten2 = 0;
			timer2 -= 5;
			
		}
		if (timer3 > 0.1)
		{
			checkNom();
			
			head.color = MainScene.snakeColor;
			
			scene.add(new SnakePart(p.x, p.y, p.z, direction, nextPoop1, nextPoop2));
			nextPoop1 = -1; nextPoop2 = -1;
			
			if (Math.random() > 0.999) scene.add(new Plus("100"));
			else if (Math.random() > 0.999) scene.add(new Plus("rocket"));
			
			eyes.rate = HXP.choose([1, 0.9, 0.8]);
			
			timer3 -= 0.1;
		}
		
		//SNAKE PUFF
		if (MainScene.lost)
		{
			scene.add(new Puff(p.x, p.y, p.z, 3));
			scene.remove(MainScene.snake);
			MainScene.snake = null;
		}
		
		super.update();
	}


	function changeDirection(e:Dynamic = null):Void
	{
		var tweeny:VarTween = new VarTween(changeDirection, TweenType.Persist);
		tweeny.tween(this, "directionDelta", (Math.random() * 2) - 1, Math.random() + 1, Ease.backInOut);
		addTween(tweeny, true);
		
		if (MainScene.seeds.length > 0)
		{
			var targetZ:Float;
			
			if (HXP.rand(2) == 1)
			{
				targetZ = MainScene.seeds[HXP.rand(MainScene.seeds.length)].p.z - (HXP.rand(20) - 8);
			}
			else
			{
				targetZ = MainScene.seeds[HXP.rand(MainScene.seeds.length)].p.z - 15;
			}
			
			if (targetZ < 0) targetZ = 0;
			else if (targetZ > 120) targetZ = 120;
			
			var tweenZ:VarTween = new VarTween(null ,TweenType.Persist);
			tweenZ.tween(p, "z", targetZ, 1);
			addTween(tweenZ, true);
		}
	}

	function checkNom(e:Dynamic = null):Void
	{
		if (layerZ >= 0 && layerZ <= MainScene.maxLayer && collideWith(MainScene.melonSlice[layerZ], p.x + MainScene.melonSlice[layerZ].x, p.y + MainScene.melonSlice[layerZ].y) != null)
		{
			if (!nom.playing) nom.play(0.8);
			
			var nomX:Int = Math.round(((p.x + 195) - 14) / 15);
			var nomY:Int = Math.round(((p.y + 187.5) + 4) / 15);
			
			MainScene.melonSlice[layerZ].grid.setRect(nomX, nomY, 3, 3, false);
			
			if (layerZ < MainScene.maxLayer)
			{
				MainScene.melonSlice[layerZ + 1].grid.setRect(nomX, nomY, 3, 3, false);
			}
			if (layerZ < MainScene.maxLayer-1)
			{
				MainScene.melonSlice[layerZ + 2].grid.setRect(nomX, nomY, 3, 3, false);
			}
			
			if (layerZ < MainScene.maxLayer-1)
			{
				if (fastMode)
				{
					if (HXP.rand(Math.floor(4)) == 0) scene.add(new Spawn(p.x, p.y, (layerZ + 3) * 5));
				}
				else
				{
					if (HXP.rand(Math.floor(11)) == 0) scene.add(new Spawn(p.x, p.y, (layerZ + 3) * 5));
				}
				
			}
			
			nomX = (nomX * 15) + 3;
			nomY = (nomY * 15) + 2;
			
			for (i in 0...3)
			{
				if (layerZ + i <= MainScene.maxLayer)
				{
					MainScene.melonSlice[layerZ + i].bitmap.fillRect(new Rectangle(nomX, nomY + 8, 45, 29), 0);
					MainScene.melonSlice[layerZ + i].bitmap.fillRect(new Rectangle(nomX + 8, nomY, 29, 45), 0);
					MainScene.melonSlice[layerZ + i].bitmap.fillRect(new Rectangle(nomX + 2, nomY + 2, 41, 41), 0);
				}
			}
		}
	}
	
	override public function render():Void
	{
		super.render();
		head.scale = eyes.scale = gfxScale;
	}
}