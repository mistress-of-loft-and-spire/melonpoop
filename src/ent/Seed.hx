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
class Seed extends Entity3D
{
	
	private var txt:Text = new Text();
	
	var sprite:Spritemap = new Spritemap("gfx/seed.png", 20, 22);

	public function new(x:Float=10, y:Float=20, z:Float=0) 
	{
		
		super(x, y, z);
		
		addGraphic(sprite);
		
		sprite.centerOrigin();
		sprite.originY = 16;
		
		sprite.add("stand", [0], 5);
		sprite.add("walking", [0, 1, 0, 2], 8);
		sprite.add("walking_up", [5, 6, 5, 7], 8);
		
		sprite.play("stand");
		
		addGraphic(txt);
		txt.size = 8;
		//txt.font = "fnt/twee.ttf";
		txt.color = 0x000000;
		txt.y += 105;
		
		sprite.scaleY = 0.9 + (HXP.rand(2)/10);
		
	}
	
	var walkingSpeed:Float = 0.25;
	
	var movement:Point = new Point(0, 0);
	var direction:Float = 0;
	
	var bubble:EmojiBubble;
	
	override public function update()
	{
		
		movement.x *= 0.8; movement.y *= 0.8;
		
		//going left and right -- X
		if (Input.check(Key.A))  { movement.x -= walkingSpeed; }
		if (Input.check(Key.D)) { movement.x += walkingSpeed; }
		
		//going towards horizon -- Z
		if (Input.check(Key.W))    { movement.y -= walkingSpeed; }
		if (Input.check(Key.S))  { movement.y += walkingSpeed; }
		
		if (Math.abs(movement.x) < 0.1) movement.x = 0;
		if (Math.abs(movement.y) < 0.1) movement.y = 0;
		
		//Zero Cutoff Margin
		if (movement.length > 0)
		{
			direction = HXP.angle(0, 0, movement.x, movement.y);
			
			p.x += Math.cos(direction * HXP.RAD) * HXP.clamp(movement.length, -1.2, 1.2);
			p.y += Math.sin(direction * HXP.RAD) * HXP.clamp(movement.length, -1.2, 1.2);
			
			if (direction < 170 && direction > 10) sprite.play("walking_up");
			else				 sprite.play("walking");
			
			if (direction > 100 && direction < 260) sprite.flipped = true;
			else if (direction > 280 || direction < 80) sprite.flipped = false;
			
		}
		else
		{
			sprite.play("stand");
		}
		
		
		//SPEAK
		if (Input.pressed(Key.F) && bubble == null)
		{
			bubble = new EmojiBubble(p.x + 10, p.y - 10, p.z - 20);
			scene.add(bubble);
		}
		
		
		//CAMERA
		Camera3D.camera.setTo(HXP.lerp(Camera3D.camera.x, p.x + Camera3D.offset.x, 0.05),
		HXP.lerp(Camera3D.camera.y, p.y + Camera3D.offset.y, 0.05),
		HXP.lerp(Camera3D.camera.z, p.z + Camera3D.offset.z, 0.05));
		
		
		//DEBUG
		txt.text = "X: " + p.x + 
		"\nZ: " + p.z + 
		"\nY: " + p.y + 
		"\nspeeeed:  " + movement.length + 
		"\nllllll:" + layer + 
		"\nOffset🍉💩: " + Camera3D.offset + 
		"\nCameraZ" + Camera3D.camera.z;
		"\nHorizony" + Camera3D.horizon_y;
		
		super.update();
	}
	
	override public function render():Void
	{
		super.render();
		sprite.scale = gfxScale;
	}
	
}