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
import openfl.geom.Rectangle;
import openfl.geom.Vector3D;
import persp.Entity3D;
import screen.Plus;
import util.EaseElastic;
import util.Music;

/**
 * ...
 * @author voec
 */
class Dog extends Entity3D
{
	
	var sprite:Spritemap = new Spritemap("gfx/dog.png", 50, 50);
	
	var fly:Sfx = new Sfx("sfx/dogs_can_fly.ogg");

	public function new(x:Float = 0, y:Float = 0, z:Float = 0)
	{
		
		super(x, y, -100, -6, true);
		
		sprite.centerOrigin();
		
		sprite.frame = HXP.choose([0, 0, 0, 1]);
        
		sprite.flipped = HXP.choose([true, false]);
		
		fly.play(0.8);
		
		setHitbox(40, 40, 20, 20);
		
		type = "dog";
		
		addGraphic(sprite);
	}
	
	var angChange:Float = HXP.choose([0.5,-0.5]);
	var ang:Float = HXP.rand(30) - 30;
	
	var layerZ:Int = 0;
	
	var fallSpeed:Float = -0.5;
	
	var timer3:Float = 0;
	
	override public function update():Void
	{
        layerZ = Math.floor(p.z / 5);
		
		timer3 += HXP.elapsed; 
		
		if (timer3 > 0.1)
		{
			checkNom();
			timer3 -= 0.1;
		}
		
		//FALL THROUGH WORLD
		if (layerZ > MainScene.maxLayer)
		{
			scene.remove(this);
			scene.add(new Puff(p.x, p.y, p.z, 2));
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
		
		super.update();
	}
	
	function checkNom(e:Dynamic = null):Void
	{
		if (layerZ >= 0 && layerZ <= MainScene.maxLayer && collideWith(MainScene.melonSlice[layerZ], p.x + MainScene.melonSlice[layerZ].x, p.y + MainScene.melonSlice[layerZ].y) != null)
		{
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
		sprite.scale= gfxScale;
	}

}