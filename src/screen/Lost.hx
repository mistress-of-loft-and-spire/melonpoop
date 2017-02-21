package screen;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.Mask;
import com.haxepunk.Tween.TweenType;
import com.haxepunk.graphics.Canvas;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.graphics.TiledImage;
import com.haxepunk.tweens.misc.VarTween;
import com.haxepunk.utils.Ease;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Joystick;
import com.haxepunk.utils.Key;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import util.EaseElastic;

/**
 * ...
 * @author voec
 */
class Lost extends Entity
{
	
	var letterArray = new Array<Dynamic>();
	var letterText:String = "congratulations";
	
	var youlost:Image = new Image("gfx/youlost.png");
	var youlostShadow:Image = new Image("gfx/youlost.png");
	
	var back:Image = new Image(new BitmapData(1, 1, false, 0xFFFFFFFF));
	
	var like:Image = new Image("gfx/likemelon.png");
	
	var state:Int = 0;

	public function new() 
	{
		
		// --------- ---------
		
		back.color = 0x282f44;
		
		back.alpha = 0;
		back.scaleX = HXP.width; back.scaleY = HXP.height;
		
		back.x = -HXP.halfWidth; back.y = -HXP.halfHeight; 
		
		addGraphic(back);
		
		// --------- poopText ---------
		
		like.centerOrigin();
		
		like.visible = false;
		
		addGraphic(like);
		
		// --------- ---------
		
		layer = -10;
		
		super(HXP.halfWidth, HXP.halfHeight);
		
		tright();
		
		HXP.alarm(2, show1, TweenType.OneShot);
		
		var tweeny:VarTween = new VarTween(null, TweenType.Persist);
		tweeny.tween(back, "alpha", 0.3, 2);
		addTween(tweeny, true);
		
	}
	
	override public function added()
	{
		for (i in 0...letterText.length)
		{
			
			var tempY:Int = 0;
			
			if 		(i == 1 || i == 13) tempY = 18;
			else if (i == 2 || i == 12) tempY = 32;
			else if (i == 3 || i == 11) tempY = 38;
			else if (i == 4 || i == 10) tempY = 43;
			else if (i == 5 || i == 9)  tempY = 46;
			else if (i == 6 || i == 8 || i == 7)  tempY = 48;
			
			letterArray.push(new Letter(letterText.charAt(i), x - 280 + (i*40), y - 100 - tempY, -i*2));
			
			scene.add(letterArray[i]);
			
		}
		
		var iconSpacing:Float = HXP.height / 5;
		
		for (i in 0...6)
		{
			scene.add(new Icon(20, i*iconSpacing, "melon", false));
			scene.add(new Icon(HXP.width-20, i*iconSpacing, "poop", false));
		}
		
		// --------- ---------
		
		youlost.centerOrigin(); youlostShadow.centerOrigin();
		youlost.y = youlostShadow.y = -70; 
		
		youlostShadow.x += 3; youlostShadow.y += 3;
		
		youlostShadow.color = 0x7f9ccb;
		
		youlost.scale = 0;
		youlostShadow.scale = 0;
		
		addGraphic(youlostShadow);
		addGraphic(youlost);
		
		// --------- SCORE ---------
		
		scene.add(new ScoreBubble(HXP.halfWidth-50, HXP.halfHeight+30));
		
	}
	
	override public function update()
	{
		
		if (Input.joystick(0).check(XBOX_GAMEPAD.START_BUTTON))
		{
			state += 1;
			
			HXP.screen.color = HXP.choose([0xfce4eb, 0xfce4f9, 0xeae4fc, 0xe4f3fc, 0xe4fcf3, 0xeafce4, 0xfcf7e4]);
		}
		
		youlostShadow.angle = youlost.angle;
		youlostShadow.scale = youlost.scale;
		
		super.update();
		
	}
	
	function show1(e:Dynamic = null):Void
	{
		
		var tweeny:VarTween = new VarTween(null, TweenType.Persist);
		tweeny.tween(youlost, "scale", 1, 0.5, EaseElastic.elasticOut);
		addTween(tweeny, true);
		
		//HXP.alarm(2, show1, TweenType.OneShot);
		
	}
	
	function showPoop(e:Dynamic = null):Void
	{
		
		back.alpha = 1;
		
		like.visible = true;
		
	}
	
	private function tright(e:Dynamic = null):Void
	{		
		var tweenR:VarTween = new VarTween(tleft, TweenType.Persist);
		tweenR.tween(youlost, "angle", -6, 1, Ease.backInOut);
		addTween(tweenR, true);
	}
	
	private function tleft(e:Dynamic = null):Void
	{		
		var tweenL:VarTween = new VarTween(tright, TweenType.Persist);
		tweenL.tween(youlost, "angle", 6, 1, Ease.backInOut);
		addTween(tweenL, true);
	}
	
}