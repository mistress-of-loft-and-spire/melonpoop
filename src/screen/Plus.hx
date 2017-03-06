package screen;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.Mask;
import com.haxepunk.RenderMode;
import com.haxepunk.Scene;
import com.haxepunk.Tween;
import com.haxepunk.Tweener;
import com.haxepunk.ds.Either;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.atlas.Atlas;
import com.haxepunk.graphics.atlas.AtlasData;
import com.haxepunk.graphics.atlas.AtlasRegion;
import com.haxepunk.tweens.misc.VarTween;
import com.haxepunk.utils.Ease;
import openfl.display.BitmapData;
import openfl.display.IBitmapDrawable;
import openfl.events.EventDispatcher;
import openfl.events.IEventDispatcher;
import openfl.geom.Rectangle;
import util.EaseElastic;

class Plus extends Entity
{

	var sprite:Image;
	var shadow:Image;
	
	var icon:String;

	public function new(icon:String = "melon")
	{
		
		this.icon = icon;
		
		sprite = new Image("gfx/plus_" + icon + ".png");
		shadow = new Image("gfx/plus_" + icon + ".png");
		
		sprite.centerOrigin();
		layer = -100;
		sprite.smooth = false;
		
		shadow.color= 0x7F9CCB;
		shadow.centerOrigin();
		shadow.x = shadow.y = 4;
		shadow.smooth = false;
		
		sprite.angle = shadow.angle = HXP.rand(40) - 30;
		sprite.scale = shadow.scale = 0;
		
		addGraphic(shadow);
		addGraphic(sprite);
		
		var tweenT:VarTween = new VarTween(delete,TweenType.OneShot);
		tweenT.tween(sprite,"scale",1,0.6,EaseElastic.elasticOut);
		addTween(tweenT, true);
		
		super(HXP.halfWidth + (HXP.choose([1, -1]) * (HXP.rand(200) + 100)), HXP.halfHeight + (HXP.choose([1, -1]) * (HXP.rand(100) + 100)));
	}

	override public function update():Void
	{
		sprite.angle= sprite.angle+ 0.4;
		
		if (icon == "hot" || icon == "clock")
		{
			sprite.angle= sprite.angle+ 0.4;
        }
		
		sprite.angle %= 360;
		
		shadow.angle= sprite.angle;
		shadow.scale= sprite.scale;
		
		super.update();
	}
	
	private function delete(e:Dynamic = null):Void
    {
		if (icon == "hot" || icon == "clock")
		{
			var tween2:VarTween = new VarTween(fin,TweenType.OneShot);
			tween2.tween(sprite,"scale",0,3,Ease.expoIn);
			addTween(tween2,true);
        }
        else
		{
			var tween21:VarTween = new VarTween(fin,TweenType.OneShot);
			tween21.tween(sprite,"scale",0,0.6,Ease.expoIn);
			addTween(tween21,true);
        }
	}
	
	private function fin(e:Dynamic = null):Void
	{
        scene.remove(this);
    }
	
}