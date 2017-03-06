package ent;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.RenderMode;
import com.haxepunk.Scene;
import com.haxepunk.Sfx;
import com.haxepunk.Tweener;
import com.haxepunk.ds.Either;
import com.haxepunk.graphics.Animation;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.atlas.Atlas;
import com.haxepunk.graphics.atlas.AtlasData;
import com.haxepunk.graphics.atlas.TileAtlas;
import ent.Layer;
import ent.Seed;
import ent.Spawn;
import openfl.display.BitmapData;
import openfl.display.IBitmapDrawable;
import openfl.geom.Point;
import openfl.geom.Vector3D;
import persp.Entity3D;
import screen.Plus;
import util.Music;

class Spawn extends Entity3D
{
	
	var sprite:Spritemap = new Spritemap("gfx/seed_ground.png",20,22);
	
	var pick:Sfx = new Sfx("sfx/pick.ogg");
	
	var layerZ:Int = 0;

	public function new(x:Float = 10, y:Float = 20, z:Float = 0)
	{
		super(x, y, z, -5, true);
		
		sprite.centerOrigin();
		sprite.originY = 17;
		
		sprite.add("idle", [0, 0, 0, 0, 0, 0, 0, 1, 2, ], (HXP.rand(4) + 8));
		sprite.play("idle");
		
		setHitbox(1, 1, 0, 0);
        
		addGraphic(sprite);
	}

	override public function update():Void
	{
        
		layerZ = Math.floor( p.z / 5);
		
		if (layerZ < 0 || layerZ >= MainScene.maxLayer)
		{
			scene.remove(this);
		}
		else if (collideWith(MainScene.melonSlice[layerZ], p.x + MainScene.melonSlice[layerZ].x, p.y + MainScene.melonSlice[layerZ].y) == null)
		{
			scene.remove(this);
		}
        else
		{
			for (i in 0...MainScene.seeds.length)
			{
				if (p.x > MainScene.seeds[i].p.x - 10 && p.x < MainScene.seeds[i].p.x + 10 && p.y > MainScene.seeds[i].p.y - 10 && p.y < MainScene.seeds[i].p.y + 10)
				{
					if (MainScene.seeds[i].layerZ < layerZ + 1 && MainScene.seeds[i].layerZ > layerZ - 2)
					{
						pick.play(0.6);
						
						scene.remove(this);
						
						MainScene.music.greet = new Sfx("sfx/greet0" + (HXP.rand(4) + 1) + ".ogg");
						
						MainScene.seeds.push(new Seed(p.x, p.y, p.z, true, MainScene.seeds[i].control, MainScene.seeds[i].number));
						scene.add(MainScene.seeds[MainScene.seeds.length - 1]);
						
						MainScene.seeds[MainScene.seeds.length - 1].fall = true;
						
						MainScene.seeds[MainScene.seeds.length - 1].fallSpeed = -1;
						
						MainScene.seeds[MainScene.seeds.length - 1].p.z -= 1;
						
						MainScene.seeds[MainScene.seeds.length-1].flyMovement.setTo((Math.random() * 2) - 1, (Math.random() * 2) - 1);
						
						if (HXP.rand(6) == 0) scene.add(new Plus("melon2"));
            			else scene.add(new Plus("melon"));
						
						break;
            		}
            	}
            }
        }
		super.update();
	}
	
	override public function render():Void
	{
		super.render();
		sprite.scale= gfxScale;
	}

}
