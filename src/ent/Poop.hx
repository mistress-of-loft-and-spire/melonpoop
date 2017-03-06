package ent;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.RenderMode;
import com.haxepunk.Scene;
import com.haxepunk.Sfx;
import com.haxepunk.Tween;
import com.haxepunk.Tweener;
import com.haxepunk.ds.Either;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.atlas.Atlas;
import com.haxepunk.graphics.atlas.AtlasData;
import com.haxepunk.graphics.atlas.TileAtlas;
import com.haxepunk.tweens.misc.VarTween;
import openfl.display.BitmapData;
import openfl.display.IBitmapDrawable;
import openfl.events.EventDispatcher;
import openfl.events.IEventDispatcher;
import openfl.geom.Point;
import openfl.geom.Vector3D;
import persp.Entity3D;
import screen.Plus;
import util.EaseElastic;
import util.Music;

/**
 * ...
 * @author voec
 */
class Poop extends Entity3D
{
	
	var sprite:Spritemap = new Spritemap("gfx/poop.png",50,50);

	public function new(x:Float = 0, y:Float = 0, z:Float = 0, direction:Float = 0, eaten1:Int = 0, eaten2:Int = 0)
	{
		this.direction = direction;
		this.eaten1 = eaten1; this.eaten2 = eaten2;
		
		super(x, y, z, -6, true);
		
		sprite.centerOrigin();
		sprite.originY = 43;
		
		if (eaten1 >= 3) sprite.frame= 2;
        else if (eaten1 >= 1) sprite.frame= 1;
        else sprite.frame= 0;
        
		sprite.flipped = HXP.choose([true, false]);
		sprite.scaleX = sprite.scaleY = 0;
		
		addGraphic(sprite);
		
		var tweeny:VarTween = new VarTween(TweenType.OneShot);
		tweeny.tween(sprite,"scaleY",1,2,EaseElastic.elasticOut);
		addTween(tweeny,true);
	}
	
	var angChange:Float = HXP.choose([0.5,-0.5]);
	var ang:Float = HXP.rand(30) - 30;
	
	var speed:Float = 2.5;
	
	var layerZ:Int = 0;
	
	var fallSpeed:Float = -0.7;
	var fall:Bool = true;
	
	var direction:Float = 0;
	
	var eaten1:Int = 0;
	var eaten2:Int = 0;
	
	override public function update():Void
	{
        layerZ = Math.floor(p.z / 5);
		
		if (speed != 0)
		{
			var moveX:Float = Math.cos(direction * (Math.PI / - 180)) * speed;
			var moveY:Float = Math.sin(direction * (Math.PI / - 180)) * speed;
			
			if (layerZ > 0)
			{
				if (collideWith(MainScene.melonSlice[layerZ - 1], p.x + moveX + MainScene.melonSlice[layerZ - 1].x, p.y + MainScene.melonSlice[layerZ - 1].y) != null)
				{
					moveX = 0;
					speed = 0;
				}
				if (collideWith(MainScene.melonSlice[layerZ - 1], p.x + MainScene.melonSlice[layerZ - 1].x, p.y + moveY + MainScene.melonSlice[layerZ - 1].y) != null)
				{
					moveX = 0;
					speed = 0;
				}
			}
			
			p.x += moveX;
			p.y += moveY;
			
			if (speed > 0)
			{
				speed -= 0.1 * MainScene.elapsed;
			}
		}
		
		if (fall)
		{
			//FALL THROUGH WORLD
			if (layerZ > MainScene.maxLayer)
			{
				scene.remove(this);
				scene.add(new Puff(p.x, p.y, p.z, 2));
			}
			else
			{
				if (layerZ >= 0 && collideWith(MainScene.melonSlice[layerZ], p.x + MainScene.melonSlice[layerZ].x, p.y + MainScene.melonSlice[layerZ].y) != null)
				{
					fall = false;
					speed = 0;
					sprite.angle = 0;
					ang = 0;
					p.z = layerZ * 5;
				}
				else
				{
					p.z += fallSpeed * MainScene.elapsed;
					
					if (fallSpeed < 1.8) fallSpeed += 0.1 * MainScene.elapsed;
					
					ang += angChange * MainScene.elapsed;
					
					if (ang < 0) ang += 360;
					ang %= 360;
					
					sprite.angle = ang;
				}
			}
		}
		else
		{
			for (i in 0...MainScene.seeds.length)
			{
				if (p.x > MainScene.seeds[i].p.x - 20 && p.x < MainScene.seeds[i].p.x + 20 && p.y > MainScene.seeds[i].p.y - 20 && p.y < MainScene.seeds[i].p.y + 20)
				{
					if (MainScene.seeds[i].layerZ < layerZ + 2 && MainScene.seeds[i].layerZ > layerZ - 2)
					{
						scene.remove(this);
						scene.add(new Puff(p.x, p.y, p.z, 2));
						
						MainScene.seeds[i].fall = true;
						MainScene.seeds[i].fallSpeed = -3;
						MainScene.seeds[i].p.z -= 1;
						
						MainScene.seeds[i].flyMovement.setTo((Math.random() * 4) - 2, ((Math.random() * 4) - 2));
						
						MainScene.music.seed_fly.stop();
						MainScene.music.seed_fly.play(0.7);
						
						if (eaten1 > 0 || eaten2 > 0)
						{
							MainScene.music.greet = new Sfx("sfx/greet0" + (HXP.rand(4) + 1) + ".ogg");
							
							for (j in 0...eaten1)
							{
								MainScene.seeds.push(new Seed(p.x, p.y, p.z, true,MainScene.control1,1));
								scene.add(MainScene.seeds[MainScene.seeds.length - 1]);
								
								MainScene.seeds[MainScene.seeds.length - 1].fall = true;
								
								MainScene.seeds[MainScene.seeds.length - 1].fallSpeed = -3;
								
								MainScene.seeds[MainScene.seeds.length - 1].p.z -= 1;
								
								MainScene.seeds[MainScene.seeds.length - 1].flyMovement.setTo((Math.random() * 4) - 2, ((Math.random() * 4) - 2));
							}
							for (j in 0...eaten2)
							{
								MainScene.seeds.push(new Seed(p.x, p.y, p.z, true,MainScene.control2,2));
								scene.add(MainScene.seeds[MainScene.seeds.length - 1]);
								
								MainScene.seeds[MainScene.seeds.length - 1].fall = true;
								
								MainScene.seeds[MainScene.seeds.length - 1].fallSpeed = -3;
								
								MainScene.seeds[MainScene.seeds.length - 1].p.z -= 1;
								
								MainScene.seeds[MainScene.seeds.length - 1].flyMovement.setTo((Math.random() * 4) - 2, ((Math.random() * 4) - 2));
							}
						}
						scene.add(new Plus("poop"));
						break;
					}
				}
			}
		}
		
		sprite.scaleX = sprite.scaleY;
		
		super.update();
	}
	
	override public function render():Void
	{
		super.render();
		sprite.scale= gfxScale;
	}

}