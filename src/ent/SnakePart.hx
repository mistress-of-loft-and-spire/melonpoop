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
class SnakePart extends Entity3D
{
	
	var body:Spritemap = new Spritemap("gfx/snake.png", 56, 56);

	public function new(x:Float = 40, y:Float = 40, z:Float = 0, direction:Float = 0, eaten1:Int = -1, eaten2:Int = -1)
	{
		
		this.direction = direction;
		this.eaten1 = eaten1; this.eaten2 = eaten2;
		
		super(x, y, z, -4, true);
		
		body.centerOrigin();
		
		if (eaten1 == -1) body.add("idle", [5, 5, 5, 8], 4, false);
		else body.add("idle", [8, 9, 10, 11], 4, false);
		
		body.play("idle");
		
		body.angle = direction + 90;
		
		addGraphic(body);
		
		setHitbox(40, 40, 20, 20);
		
		type = "snakebody";
	}
	
	var eaten1:Int = 0; var eaten2:Int = 0;
	var direction:Float = 0;
	
	override public function update():Void
	{
		body.angle =  direction + MainScene.rotationAngle + 90;
		
		body.color = MainScene.snakeColor;
		
		if (body.complete)
		{
			if (eaten1 != -1) scene.add(new Poop(p.x, p.y, p.z, direction - 180, eaten1, eaten2));
			
			scene.remove(this);
		}
		else if (MainScene.lost)
		{
			scene.remove(this);
			MainScene.snake = null;
			scene.add(new Puff(p.x, p.y, p.z, 3));
		}
		
		super.update();
	}

	override public function render():Void
	{
		super.render();
		body.scale = gfxScale;
	}
}