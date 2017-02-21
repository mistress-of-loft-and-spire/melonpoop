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
class Icon extends Entity
{
	
	var sprite:Image;
	var shadow:Image;
	
	var enableShadow:Bool;
	var icon:String;
	
	public function new(x:Float, y:Float, icon = "melon", enableShadow = true) 
	{
		this.icon = icon;
		this.enableShadow = enableShadow;
		
		sprite = new Image("gfx/logo_" + icon + ".png");
		
		sprite.angle = 45;
		
		sprite.centerOrigin();
		
		sprite.smooth = false;
		
		if (enableShadow)
		{
			shadow = new Image("gfx/logo_" + icon + ".png");
			
			shadow.color = 0x7f9ccb;
			
			shadow.angle = sprite.angle;
			
			shadow.centerOrigin();
			
			shadow.x = shadow.y = 4;
			
			shadow.smooth = false;
			
			addGraphic(shadow);
		}
		else
		{
			sprite.scale = 0.5;
		}
		
		addGraphic(sprite);
		
		super(x, y);
		
		tright();
		
	}
	
	override public function update()
	{
		if (enableShadow) shadow.angle = sprite.angle;
		else
		{
			
			if (icon == "melon")
			{
				y += 1;
				if (y >= HXP.height + 50) y -= HXP.height + 100;
			}
			else
			{
				y -= 1;
				if (y <= -50) y += HXP.height + 100;
			}
			
		}
		
		super.update();
		
	}
	
	private function tright(e:Dynamic = null):Void
	{		
		var tweenR:VarTween = new VarTween(tleft, TweenType.Persist);
		tweenR.tween(sprite, "angle", 0, 1, Ease.backInOut);
		addTween(tweenR, true);
	}
	
	private function tleft(e:Dynamic = null):Void
	{		
		var tweenL:VarTween = new VarTween(tright, TweenType.Persist);
		tweenL.tween(sprite, "angle", 45, 1, Ease.backInOut);
		addTween(tweenL, true);
	}
	
}