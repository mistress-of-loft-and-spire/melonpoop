package ent;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.Mask;
import com.haxepunk.graphics.Image;
import com.haxepunk.masks.Grid;
import openfl.display.BitmapData;
import persp.Entity3D;

/**
 * ...
 * @author voec
 */
class Layer extends Entity3D
{
	
	public var bitmap:BitmapData;
	
	var sprite:Image;
	
	public var grid:Grid;

	public function new(x:Int = 0, y:Int = 0, z:Int = 0) 
	{
		
		super(x, y, z * 5);
		
		bitmap = new BitmapData(396, 379);
		
		if 		(z == 0) 	bitmap = HXP.getBitmap("gfx/melon_top.png").clone();
		else if (z % 3 != 0) 	bitmap = HXP.getBitmap("gfx/melon_mid.png").clone();
		else 				bitmap = HXP.getBitmap("gfx/melon_second.png").clone();
		
		sprite = new Image(bitmap);
		/*
		if (z > 3) sprite.color = HXP.colorLerp(0xffffff, 0xb7e2ae, 0.15);
		if (z > 6) sprite.color = HXP.colorLerp(0xffffff, 0xb7e2ae, 0.3);
		if (z > 9) sprite.color = HXP.colorLerp(0xffffff, 0xb7e2ae, 0.45);
		if (z > 12) sprite.color = HXP.colorLerp(0xffffff, 0xb7e2ae, 0.6);
		if (z > 15) sprite.color = HXP.colorLerp(0xffffff, 0xb7e2ae, 0.75);
		if (z > 18) sprite.color = HXP.colorLerp(0xffffff, 0xb7e2ae, 0.9);
		if (z > 21) sprite.color = HXP.colorLerp(0xffffff, 0xb7e2ae, 1);*/
		
		sprite.color = HXP.colorLerp(0xffffff, 0xb7e2ae, z / MainScene.maxLayer);
		
		sprite.centerOrigin();
		sprite.originY = 208;
		
		addGraphic(sprite);
		
		sprite.smooth = false;
		
		grid = new Grid(390, 375, 15, 15);
		grid.loadFromString(MainScene.fastXml,"","\n");
		
		mask = grid;
		type = "solid";
		
		grid.x = -195;
		grid.y = -210;
	}
	
	override public function update():Void
	{
		sprite.angle = MainScene.rotationAngle;
		
		if (MainScene.meanZ - 15 > p.z) sprite.alpha -= 0.01;
		else if (sprite.alpha < 1) sprite.alpha += 0.01;
		
		super.update();
	}
	
	override public function render():Void
	{
		super.render();
		sprite.scale = gfxScale;
	}
	
}