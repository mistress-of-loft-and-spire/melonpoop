package ent;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.Mask;
import com.haxepunk.graphics.Image;
import persp.Entity3D;

/**
 * ...
 * @author voec
 */
class Layer extends Entity3D
{
	
	var sprite:Image;

	public function new(x:Int = 0, y:Int = 0, z:Int = 0) 
	{
		
		if 		(z == 0) 	sprite = new Image("gfx/melon_top.png");
		else if (z == 1) 	sprite = new Image("gfx/melon_second.png");
		else if (z == 50) 	sprite = new Image("gfx/melon_last.png");
		else 				sprite = new Image("gfx/melon_mid.png");
		
		if (z > 10) sprite.color = HXP.colorLerp(0xffffff, 0xb7e2ae, 0.1);
		if (z > 20) sprite.color = HXP.colorLerp(0xffffff, 0xb7e2ae, 0.2);
		if (z > 30) sprite.color = HXP.colorLerp(0xffffff, 0xb7e2ae, 0.3);
		if (z > 40) sprite.color = HXP.colorLerp(0xffffff, 0xb7e2ae, 0.4);
		
		super(x, y, z * 3);
		
		sprite.centerOrigin();
		sprite.originY = 208;
		
		addGraphic(sprite);
		
		sprite.smooth = false;
			
	}
	
	function renderMelon():Void
	{
		sprite.angle = MainScene.rotationAngle;
	}
		
	override public function added()
	{
		renderMelon();
	}
	
	override public function render():Void
	{
		renderMelon();
		super.render();
		sprite.scale = gfxScale;
	}
	
}