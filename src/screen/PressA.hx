package screen;

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
import com.haxepunk.graphics.atlas.TileAtlas;
import com.haxepunk.tweens.misc.VarTween;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Joystick;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import openfl.display.BitmapData;
import openfl.display.IBitmapDrawable;
import openfl.events.EventDispatcher;
import openfl.events.IEventDispatcher;
import util.EaseElastic;


/**
 * ...
 * @author voec
 */
class PressA extends Entity
{

	var klick:Sfx = new Sfx("sfx/menu_pick.ogg");
	
	var shadow:Spritemap = new Spritemap("gfx/pressa.png", 90, 90);
	var sprite:Spritemap = new Spritemap("gfx/pressa.png", 90, 90);
	
	public function new(x:Float, y:Float)
	{
		super(x, y);
		
		shadow.color = 0x7F9CCB;
		sprite.color = 0xB7EAA1;
		
		sprite.centerOrigin();
		shadow.centerOrigin();
		
		shadow.x = shadow.y = 3;
		
		shadow.scale = sprite.scale = 0;
		shadow.smooth = sprite.smooth = false;
		
		layer = -115;
		
		sprite.add("blink",[0,1,2],11);
		sprite.play("blink");
		
		addGraphic(shadow);
		addGraphic(sprite);
		
		var tweeny:VarTween = new VarTween(null, TweenType.Persist);
		tweeny.tween(sprite,"scale",1,1,EaseElastic.elasticOut);
		addTween(tweeny,true);
	}

	override public function update():Void
	{

		if (Input.joystick(0).pressed() || Input.joystick(1).pressed() || Input.pressed(Key.SPACE) || Input.pressed(Key.ENTER) || Input.pressed(Key.F) || Input.pressed(Key.A))
		{
			klick.play();
			scene.remove(this);
            		}
					
		sprite.angle = sprite.angle + 0.1;
		sprite.angle %= 360;
		
		shadow.angle = sprite.angle;
		shadow.scale = sprite.scale;
		
		super.update();
	}

}