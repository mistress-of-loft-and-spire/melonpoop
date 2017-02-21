package ent;

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
import com.haxepunk.utils.Key;
import openfl.geom.Rectangle;
import persp.Entity3D;
import util.EaseElastic;

/**
 * ...
 * @author voec
 */
class EmojiBubble extends Entity3D
{
	
/*

🍉💩
👻👾💀💣💨❤💢💥💤🕶🔥✨⭐💩
🌵🌻🌹🌱🍇🍈🍊🍋🍌🍍🍎🍐🍑🍒🍓🥝🍆🥕🌶🍄🍉
🌌🚀🌈🎈🎉🏆🎮🕹💯🐛

"1f349","1f4a9"
"1f47b","1f47e","1f480","1f4a3","1f4a8","2764","1f4a2","1f4a5","1f4a4","1f576","1f525","2728","2b50","1f4a9"
"1f335","1f33b","1f339","1f331","1f347","1f348","1f34a","1f34b","1f34c","1f34d","1f34e","1f350","1f351","1f352","1f353","1f95d","1f346","1f955","1f336","1f344","1f349"
"1f30c","1f680","1f308","1f388","1f389","1f3c6","1f3ae","1f579","1f4af","1f41b"

*/
	
	var bubble:Image = new Image("gfx/bubble_small.png");
	var connect:Image = new Image("gfx/bubble_connect.png");
	
	var emojiMain:Array<String> = ["1f349", "1f4a9", "2728"];
	
	var index:Int = 1;
	
	var bubbleTween:VarTween = new VarTween(null, TweenType.Persist);
	
	var counter:Float = 3;
	
	public function new(x:Float, y:Float, z:Float) 
	{
		
		//bubble.alpha = 0.8;
		
		bubble.scale = 0;
		connect.scale = 0;
		
		bubble.originY = bubble.height; 
		connect.originY = connect.height;
		
		bubble.x = 5; bubble.y = 5;
		
		connect.x = bubble.x; connect.y = bubble.y + 10;
		
		//------
		
		addGraphic(connect);
		addGraphic(bubble);
		
		super(x, y, z);
		
		var tweenStart:VarTween = new VarTween(null, TweenType.OneShot);
		tweenStart.tween(bubble, "scale", 0.2, 1, EaseElastic.elasticOut);
		addTween(tweenStart, true);
		
		addTween(bubbleTween, false);
		
		addChar();
		
	}
	
	override public function update()
	{
		
		counter -= HXP.elapsed;
		
		if (counter <= 0)
		{
			bubble.alpha = connect.alpha -= 0.1;
			if (bubble.alpha <= 0) scene.remove(this);
		}
		
		if (Input.pressed(Key.F) && index <= 10)
		{
			addChar();
			counter = 3;
			bubble.alpha = connect.alpha = 1;
		}
		
		connect.scale = bubble.scale * 5;
		
		super.update();
		
	}
	
	private function addChar(e:Dynamic = null):Void
	{
		
		var char:String = emojiMain[HXP.rand(emojiMain.length)];
		
		var charSprite:Image = new Image("gfx/36x36/" + char + ".png");
		
		charSprite.centerOrigin();
		
		charSprite.x = bubble.x + (index * 40);
		charSprite.y = bubble.y - 40;
		
		charSprite.scale = 0;
		
		addGraphic(charSprite);
		
		bubbleTween.tween(bubble, "scaleX", 0.5 + (0.5 * index), 0.4, Ease.backOut);
		bubbleTween.start();
		
		var tweeny:VarTween = new VarTween(null, TweenType.OneShot);
		tweeny.tween(charSprite, "scale", 1, 1, EaseElastic.elasticOut);
		addTween(tweeny, true);
		
		index += 1;
		
	}
	
}