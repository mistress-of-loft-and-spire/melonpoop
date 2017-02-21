package ent;

import com.haxepunk.HXP;
import com.haxepunk.Tween.TweenType;
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
class Snake extends Entity3D
{
	
	var head:Spritemap = new Spritemap("gfx/snake.png", 56, 56);
	
	var eyes:Spritemap = new Spritemap("gfx/snake.png", 56, 56);

	public function new(x:Float=40, y:Float=40, z:Float=0) 
	{
		
		super(x, y, z);
		
		head.centerOrigin();
		eyes.centerOrigin();
		
		head.add("nom", [1,2,3,4], 11);
		head.play("nom");
		
		eyes.add("blink", [6,6,6,6,6,7,0,0,7,6], 9, false);
		eyes.play("blink");
		
		addGraphic(head);
		addGraphic(eyes);
		
		changeColor();
		
		HXP.alarm(0.3, changeColor, TweenType.Looping);
		
	}
	
	var direction:Float = 0;
	
	var speed:Float = 1.2;
	
	override public function update()
	{
		
		direction += 0.5;
		
		//normalize rotation angle
		if (direction < 0) direction += 360;
		direction = direction % 360;
		
		//-------------
		
		p.x += Math.cos(direction * HXP.RAD) * speed;
		p.y += Math.sin(direction * HXP.RAD) * speed;
		
		head.angle = eyes.angle = direction + 90;
		
		super.update();
	}
	
	function changeColor(e:Dynamic = null):Void
	{
		head.color = HXP.choose([0x5f9f9f, 0x5f6a9f, 0x9f5f9f, 0x9f5f5f, 0x9f955f, 0x739f5f, 0x5f9f7a]);
		//0xfce4eb, 0xfce4f9, 0xeae4fc, 0xe4f3fc, 0xe4fcf3, 0xeafce4, 0xfcf7e4
		
		if (Math.random() > 0.9) eyes.play("blink", true);
	}
	
	override public function render():Void
	{
		super.render();
		head.scale = eyes.scale = gfxScale;
	}
	
}