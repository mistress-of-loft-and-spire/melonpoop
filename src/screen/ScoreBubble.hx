package screen;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.Mask;
import com.haxepunk.Tween.TweenType;
import com.haxepunk.graphics.Canvas;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Text;
import com.haxepunk.graphics.TiledImage;
import com.haxepunk.tweens.misc.VarTween;
import com.haxepunk.utils.Ease;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import util.EaseElastic;

/**
 * ...
 * @author voec
 */
class ScoreBubble extends Entity
{
	
	var bubble:Image = new Image("gfx/bubble_big.png");
	
	var char1:Spritemap;
	var char2:Spritemap;
	var char3:Spritemap;
	
	public function new(x:Float, y:Float) 
	{
		
		bubble.scale = 0;
		
		bubble.originX = bubble.width; bubble.originY = bubble.height; 
		
		//------
		
		char1 = new Spritemap(fillCharset(),36,36);
		char2 = new Spritemap(fillCharset(),36,36);
		char3 = new Spritemap(fillCharset(), 36, 36);
		
		char1.centerOrigin(); char2.centerOrigin(); char3.centerOrigin();
		
		char1.x = -134; char1.y = -76;
		char2.x = -229; char2.y = -80;
		char3.x = -326; char3.y = -78;
		
		char1.scale = char2.scale = char3.scale = 0;
		
		char1.add("idle", [0, 1, 2, 3, 4, 5], 16); char2.add("idle", [0, 1, 2, 3, 4, 5], 16); char3.add("idle", [0, 1, 2, 3, 4, 5], 16);
		
		char1.play("idle"); char2.play("idle"); char3.play("idle");
		
		//-----
		
		addGraphic(bubble);
		
		addGraphic(char1); addGraphic(char2); addGraphic(char3);
		
		super(x, y);
		
		var tweenb:VarTween = new VarTween(null, TweenType.OneShot);
		tweenb.tween(bubble, "scale", 1, 1, EaseElastic.elasticOut);
		addTween(tweenb, true);
		
		var tweeny:VarTween = new VarTween(next1, TweenType.Persist);
		tweeny.tween(char1, "scale", 2, 0.8, EaseElastic.elasticOut);
		addTween(tweeny, true);
		
		HXP.alarm(1.6, finish1, TweenType.OneShot);
		HXP.alarm(2.9, finish2, TweenType.OneShot);
		HXP.alarm(4.2, finish3, TweenType.OneShot);
		
	}
	
	var sin:Float = 0;
	
	override public function update()
	{
		
		char1.rate -= 0.01;
		
		char2.rate = char1.rate + 0.3;
		char3.rate = char2.rate + 0.3;
		
		sin += 0.1;
		
		char1.y = -70 + Math.sin(sin)*20;
		char2.y = -80 + Math.sin(sin+1)*20;
		char3.y = -72 + Math.sin(sin+2)*20;
		
		super.update();
		
	}
	
	function next1(e:Dynamic = null):Void
	{
		var tweeny:VarTween = new VarTween(next2, TweenType.Persist);
		tweeny.tween(char2, "scale", 2, 0.8, EaseElastic.elasticOut);
		addTween(tweeny, true);
	}
	function next2(e:Dynamic = null):Void
	{
		var tweeny:VarTween = new VarTween(null, TweenType.Persist);
		tweeny.tween(char3, "scale", 2, 0.8, EaseElastic.elasticOut);
		addTween(tweeny, true);
	}
	function finish1(e:Dynamic = null):Void
	{
		char1.stop();
	}
	function finish2(e:Dynamic = null):Void
	{
		char2.stop();
	}
	function finish3(e:Dynamic = null):Void
	{
		char3.stop();
	}
	
	//emojis: fruit & magic
	var emoji:Array<String> = ["1f335","1f33b","1f339","1f331","1f347","1f348","1f34a","1f34b","1f34c","1f34d","1f34e","1f350","1f351","1f352","1f353","1f95d","1f346","1f955","1f336","1f344","1f349","1f30c","1f680","1f308","1f388","1f389","1f3c6","1f3ae","1f579","1f4af","1f41b"];
	
	function fillCharset(e:Dynamic = null):BitmapData
	{
		
		var bitmap:BitmapData = new BitmapData(216, 36);
		
		for (i in 0...6)
		{
			bitmap.copyPixels(HXP.getBitmap("gfx/36x36/" + emoji[HXP.rand(emoji.length)] + ".png"), new Rectangle(0, 0, 36, 36), new Point(i * 36, 0));
			trace("DOEN!");
		}
		
		return bitmap;
		
	}
	
}