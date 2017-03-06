package screen;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.Mask;
import com.haxepunk.Tween.TweenType;
import com.haxepunk.graphics.Canvas;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.TiledImage;
import com.haxepunk.tweens.misc.VarTween;
import com.haxepunk.utils.Ease;
import openfl.geom.Rectangle;
import util.EaseElastic;

/**
 * ...
 * @author voec
 */
class Letter extends Entity
{
	
	var sprite:Image;
	var shadow:Image;
	
	public function new(letter:String, x:Float, y:Float, rotation:Float) 
	{
		
		sprite = new Image("gfx/letter/" + letter + ".png");
		shadow = new Image("gfx/letter/"+letter+".png");
			
		shadow.color = 0x7f9ccb;
			
		sprite.angle = shadow.angle = rotation;
		
		sprite.centerOrigin(); shadow.centerOrigin();
			
		shadow.x = shadow.y = 3;
			
		addGraphic(shadow);
		addGraphic(sprite);
		
		shadow.scale = sprite.scale = 0;
		
		shadow.smooth = sprite.smooth = false;
		
		layer = -108;
		
		super(x, y);
		
		HXP.alarm(Math.random()*0.7, show, TweenType.OneShot);
		
	}
	
	private function show(e:Dynamic = null):Void
	{		
		var tweeny:VarTween = new VarTween(null, TweenType.Persist);
		tweeny.tween(sprite, "scale", 1.2, 1, EaseElastic.elasticOut);
		addTween(tweeny, true);
	}
	
	override public function update()
	{
		
		sprite.color = HXP.choose([0xfce4eb, 0xfce4f9, 0xeae4fc, 0xe4f3fc, 0xe4fcf3, 0xeafce4, 0xfcf7e4]);
		
		sprite.angle += 0.1;
		
		sprite.angle %= 360;
		
		shadow.angle = sprite.angle;
		
		shadow.scale = sprite.scale;
		
		super.update();
		
	}
	
}