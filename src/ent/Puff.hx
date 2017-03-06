package ent;

import com.haxepunk.HXP;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Text;
import com.haxepunk.tweens.misc.VarTween;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import openfl.geom.Point;
import persp.Camera3D;
import persp.Entity3D;

/**
 * ...
 * @author voec
 */
class Puff extends Entity3D
{
	
	var sprite:Spritemap = new Spritemap("gfx/puff.png", 20, 22);

	public function new(x:Float=0, y:Float=0, z:Float=0, scaleXY:Float=1) 
	{
		
		super(x, y, z, -5, true);
		
		addGraphic(sprite);
		
		sprite.centerOrigin();
		sprite.originY = 12;
		
		sprite.add("idle", [0, 1, 2], 8, false);
		
		sprite.flipped = HXP.choose([true, false]);
		
		sprite.play("idle");
		
		sprite.scaleY = sprite.scaleX = scaleXY;
		
	}
	
	override public function update()
	{
		
		if (sprite.complete)
		{
			scene.remove(this);
		}
		
		super.update();
	}
	
	override public function render():Void
	{
		super.render();
		sprite.scale = gfxScale;
	}
	
}