package screen;

import com.haxepunk.Engine;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.Mask;
import com.haxepunk.RenderMode;
import com.haxepunk.Scene;
import com.haxepunk.Sfx;
import com.haxepunk.Tween;
import com.haxepunk.Tweener;
import com.haxepunk.ds.Either;
import com.haxepunk.graphics.Animation;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.atlas.Atlas;
import com.haxepunk.graphics.atlas.AtlasData;
import com.haxepunk.graphics.atlas.AtlasRegion;
import com.haxepunk.graphics.atlas.TileAtlas;
import com.haxepunk.tweens.misc.Alarm;
import com.haxepunk.tweens.misc.VarTween;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Joystick;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.IBitmapDrawable;
import openfl.display.InteractiveObject;
import openfl.display.Sprite;
import openfl.events.EventDispatcher;
import openfl.events.IEventDispatcher;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import screen.PressA;
import util.Music;

class Endsnake extends Entity
{
	
	var back:Image = new Image(new BitmapData(1,1,false,0xFFFFFFFF));
	
	var eyes:Spritemap = new Spritemap("gfx/snake.png", 56, 56);
	var	endsnake:Image = new Image("gfx/endsnake_rest.png");
	
	var like:Image = new Image("gfx/likemelon" + (HXP.rand(11)+1) + ".png");
	
	var state:Int = 0;
	
	var huh:Sfx = new Sfx("sfx/dog-barking.ogg");

	public function new() 
	{
		
		super(HXP.halfWidth, HXP.halfHeight);
		
		back.color = 0x282f44;
		back.alpha = 0;
		
		back.scaleX = HXP.width;
		back.scaleY = HXP.height;
		
		back.x = -HXP.halfWidth;
		back.y = -HXP.halfHeight;
		
		like.centerOrigin();
		like.y= -40;
		like.visible = false;
		
		addGraphic(back);
		
		addGraphic(like);
		
		layer = -120;
		
		endsnake.x = HXP.halfWidth + 10;
		endsnake.y = 50;
		eyes.y = 70;
		
		eyes.scale = 2;
		eyes.angle = -75;
		
		eyes.add("blink",[6,6,6,6,6,7,0,0,7,6],9,true);
		eyes.play("blink");
		
		addGraphic(endsnake);
		addGraphic(eyes);
		
		var tweeny:VarTween = new VarTween(null, TweenType.OneShot);
		tweeny.tween(endsnake,"x",50,1.4);
		addTween(tweeny, true);
		
		HXP.alarm(5,show1,TweenType.OneShot);
	}

	private function show1(e:Dynamic = null):Void
    {
		scene.add(new PressA(x + 300, y + 200));
		state = 1;
	}

	private function likelike(e:Dynamic = null):Void
    {
		like.visible = true;
		huh.play();
		HXP.alarm(2, reset, TweenType.OneShot);
	}

	function reset(e:Dynamic = null):Void
    {
		Main.restart();
	}

	override public function update():Void
	{
		if (state == 1)
		{
			if (Input.joystick(0).pressed() || Input.joystick(1).pressed() || Input.pressed(Key.SPACE) || Input.pressed(Key.ENTER) || Input.pressed(Key.F) || Input.pressed(Key.A))
			{
				MainScene.music.fadeOut("ending");
				state += 1;
				HXP.alarm(3,likelike,TweenType.OneShot);
			}
		}
		else if (state == 2)
		{
			if (back.alpha < 1)
			{
				back.alpha += 0.02;
            }
        }
		
		eyes.rate = HXP.choose([1, 0.9, 0.8]);
		
		endsnake.color = MainScene.snakeColor;
		
		eyes.x = endsnake.x + 150;
		
		super.update();
	}

}