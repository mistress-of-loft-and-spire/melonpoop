package ent;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.Mask;
import com.haxepunk.Sfx;
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
	
	var emojiMain:Array<String> = ["1f349","1f4a9","1f47b","1f47e","1f480","1f4a3","1f4a8","2764","1f4a2","1f4a5","1f4a4","1f576","1f525","2728","2b50","1f4a9","1f335","1f33b","1f339","1f331","1f347","1f348","1f34a","1f34b","1f34c","1f34d","1f34e","1f350","1f351","1f352","1f353","1f95d","1f346","1f955","1f336","1f344","1f349","1f30c","1f680","1f308","1f388","1f389","1f3c6","1f3ae","1f579","1f4af","1f41b"];
	
	var index:Int = 1;
	
	var bubbleTween:VarTween = new VarTween(null, TweenType.Persist);
	
	var counter:Float = 3;
	
	var s3:Sfx = new Sfx("sfx/talk03.ogg");
	var s2:Sfx = new Sfx("sfx/talk02.ogg");
	var s1:Sfx = new Sfx("sfx/talk01.ogg");
	
	var number:Int;
	
	public function new(x:Float, y:Float, z:Float, number:Int = 1) 
	{
		
		this.number = number;
		
		//bubble.alpha = 0.8;
		
		bubble.scale = 0;
		connect.scale = 0;
		
		bubble.originY = bubble.height; 
		connect.originY = connect.height;
		
		bubble.x = 20; bubble.y = -35;
		
		connect.x = bubble.x; connect.y = bubble.y + 10;
		
		//------
		
		addGraphic(connect);
		addGraphic(bubble);
		
		super(x, y, z, -30, true);
		
		var tweenStart:VarTween = new VarTween(null, TweenType.OneShot);
		tweenStart.tween(bubble, "scale", 0.2, 1, EaseElastic.elasticOut);
		addTween(tweenStart, true);
		
		addTween(bubbleTween, false);
		
		addChar();
		
		play(HXP.rand(3));
		
	}
	
	var charArray:Array<Image> = new Array<Image>();
	
	var tau:Float = 6.283;
	
	var sin:Float = 0;
	
	override public function update()
	{
		
		counter -= HXP.elapsed;
		
		if (counter <= 0)
		{
			bubble.alpha = connect.alpha -= 0.1;
			if (bubble.alpha <= 0)
			{
				scene.remove(this);
				if (number == 1) MainScene.bubble = null;
				else MainScene.bubble2 = null;
			}
		}
		
		if (charArray.length < 6 && number == 1)
		{
			if (MainScene.control1 == 0)
			{
				if (Input.pressed(Key.SPACE) || Input.pressed(Key.E)) newBubble();
			}
			else if (MainScene.control1 == 1)
			{
				if (Input.joystick(0).pressed(1) || Input.joystick(0).pressed(3) || Input.joystick(0).pressed(2)) newBubble();
			}
			else
			{
				if (Input.joystick(1).pressed(1) || Input.joystick(1).pressed(3) || Input.joystick(1).pressed(2)) newBubble();
			}
		}
		else if (charArray.length < 6 && number == 2)
		{
			if (MainScene.control2 == 0)
			{
				if (Input.pressed(Key.SPACE) || Input.pressed(Key.E)) newBubble();
			}
			else if (MainScene.control2 == 1)
			{
				if (Input.joystick(0).pressed(1) || Input.joystick(0).pressed(3) || Input.joystick(0).pressed(2)) newBubble();
			}
			else
			{
				if (Input.joystick(1).pressed(1) || Input.joystick(1).pressed(3) || Input.joystick(1).pressed(2)) newBubble();
			}
		}
		
		
		sin += 0.1;
		sin %= tau;
			
		for (i in 0...charArray.length)
		{
			charArray[i].y = bubble.y - 43 + (Math.sin(sin + i) * 6);
		}
		
		
		connect.scale = bubble.scale * 5;
		
		super.update();
		
	}
	
	function play(num:Int)
    {
		if (num == 0)
		{
			s1.play();
        }
        else if (num == 1)
		{
			s2.play();
        }
        else if (num == 2)
		{
			s3.play();
        }
	}
	
	function newBubble(e:Dynamic = null):Void
	{
		addChar();
		counter = 3;
		bubble.alpha = connect.alpha = 1;
		play(HXP.rand(3));
	}
	
	private function addChar(e:Dynamic = null):Void
	{
		
		var char:String = emojiMain[HXP.rand(emojiMain.length)];
		
		charArray.push(new Image("gfx/36x36/" + char + ".png"));
		
		charArray[charArray.length-1].centerOrigin();
		
		charArray[charArray.length-1].x = bubble.x + (charArray.length * 40);
		charArray[charArray.length-1].y = bubble.y - 40;
		
		charArray[charArray.length-1].scale = 0;
		
		addGraphic(charArray[charArray.length-1]);
		
		bubbleTween.tween(bubble, "scaleX", 0.5 + (0.5 * charArray.length), 0.4, Ease.backOut);
		bubbleTween.start();
		
		var tweeny:VarTween = new VarTween(null, TweenType.OneShot);
		tweeny.tween(charArray[charArray.length-1], "scale", 1, 1, EaseElastic.elasticOut);
		addTween(tweeny, true);
		
	}
	
}