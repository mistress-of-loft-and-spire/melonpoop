package ent;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.Mask;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import persp.Entity3D;

/**
 * ...
 * @author voec
 */
class Stem extends Entity3D
{
	
	var sprite:Spritemap = new Spritemap("gfx/melon_stem.png", 30, 11);

	public function new(x:Float=0, y:Float=0, z:Float=0) 
	{
		
		sprite.frame = Math.round(z);
		
		super(x, y, -z * 2);
		
		sprite.centerOrigin();
		sprite.originX = 7;
		
		addGraphic(sprite);
		
		sprite.scaleX = sprite.scaleY = 1.2;
		
		sprite.smooth = false;
		
	}
	
	function renderMelon():Void
	{
		//sprite.frame = 8 - Math.ceil(MainScene.rotationAngle / 45);
		sprite.angle = MainScene.rotationAngle;
	}
	
	override public function added()
	{
		renderMelon();
	}
	
	override public function render()
	{
		renderMelon();
		super.render();
		sprite.scale = gfxScale;
	}
	
}