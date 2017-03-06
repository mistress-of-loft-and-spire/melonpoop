package;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Sfx;
import com.haxepunk.Tween.TweenType;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.tweens.misc.VarTween;
import com.haxepunk.utils.Ease;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Joystick;
import com.haxepunk.utils.Key;
import flash.errors.RangeError;
import openfl.display.BitmapData;
import screen.Sky;
import util.EaseElastic;

/**
 * ...
 * @author voec
 */
class Setup extends Scene
{
	
	var youlost:Image = new Image("gfx/setup.png");
	var youlostShadow:Image = new Image("gfx/setup.png");
	
	var nana:Sfx = new Sfx("sfx/music/nana.ogg");
	
	var countI:Spritemap = new Spritemap("gfx/setup_count.png", 70, 40);
	
	var bubbleL:Image = new Image("gfx/setup_bubble.png");
	var bubbleR:Image = new Image("gfx/setup_bubble.png");
	
	var pressanyL:Image = new Image("gfx/setup_press.png");
	var pressanyR:Image = new Image("gfx/setup_press.png");
	
	var controllerL:Spritemap = new Spritemap("gfx/controller.png",180, 180);
	var controllerR:Spritemap = new Spritemap("gfx/controller.png",180, 180);
	var keyboardL:Spritemap = new Spritemap("gfx/keyboard.png",180, 180);
	var keyboardR:Spritemap = new Spritemap("gfx/keyboard.png",180, 180);
	
	var plus:Image = new Image("gfx/setup_plus.png");
	
	var klick:Sfx = new Sfx("sfx/menu_pick.ogg");
	var cancel:Sfx = new Sfx("sfx/menu_cancel.ogg");

	var g1:Sfx = new Sfx("sfx/greet01.ogg");
	var g2:Sfx = new Sfx("sfx/greet02.ogg");
	var g3:Sfx = new Sfx("sfx/tuut.ogg");
	
	var shadow:Spritemap = new Spritemap("gfx/pressa.png", 90, 90);
	var spritey:Spritemap = new Spritemap("gfx/pressa.png", 90, 90);
	
	var back:Image = new Image(new BitmapData(1, 1, false, 0xFFFFFFFF));
	
	public function new() 
	{
		
		super();
		
		HXP.screen.color = 0x282f44;
		
		
		
		add(new Sky(true));
		
		
		
		shadow.color = 0x7F9CCB;
		spritey.color = 0xB7EAA1;
		
		spritey.centerOrigin();
		shadow.centerOrigin();
		
		shadow.x = shadow.y = 3;
		
		shadow.scale = spritey.scale = 0;
		shadow.smooth = spritey.smooth = false;
		countI.visible = false;
		countI.centerOrigin();
		
		
		//SETUP TITLE
		youlost.centerOrigin(); youlostShadow.centerOrigin();
		youlost.y = youlostShadow.y = -170; 
		
		youlostShadow.x += 3; youlostShadow.y += 3;
		
		youlostShadow.color = 0x7f9ccb;
		
		youlost.scale = 0; youlostShadow.scale = 0;
		
		//REST
		bubbleL.centerOrigin(); bubbleR.centerOrigin(); plus.centerOrigin();
		
		bubbleL.color = 0x8092c3;
		bubbleR.color = 0xbd7394;
		bubbleL.visible = bubbleR.visible = false;
		
		controllerL.x = keyboardL.x = bubbleL.x = -250; controllerR.x = keyboardR.x = bubbleR.x = 250;
		controllerL.y = keyboardL.y = controllerR.y = keyboardR.y = bubbleL.y = bubbleR.y = 20;
		
		pressanyL.centerOrigin(); pressanyR.centerOrigin();
		
		pressanyL.x = -250; pressanyR.x = 250;
		pressanyL.y = pressanyR.y = 20;
		
		keyboardL.centerOrigin(); keyboardR.centerOrigin(); controllerL.centerOrigin(); controllerR.centerOrigin();
		controllerR.scale = 0; controllerL.scale = 0;
		controllerL.visible = controllerR.visible = keyboardL.visible = keyboardR.visible = false;
		
		keyboardL.add("blink", [0, 1], 4); keyboardL.play("blink");
		keyboardR.add("blink", [0, 1], 4); keyboardR.play("blink");
		controllerL.add("blink", [0, 1], 4); controllerL.play("blink");
		controllerR.add("blink", [0, 1], 4); controllerR.play("blink");
		
		
		//ADD
		addGraphic(youlostShadow,-50, HXP.halfWidth, HXP.halfHeight);
		addGraphic(youlost, -50, HXP.halfWidth, HXP.halfHeight);
		
		plus.y = 20; plus.scale = 0;
		addGraphic(plus, -10, HXP.halfWidth, HXP.halfHeight);
		
		addGraphic(pressanyL, -10, HXP.halfWidth, HXP.halfHeight);
		addGraphic(pressanyR, -10, HXP.halfWidth, HXP.halfHeight);
		
		addGraphic(bubbleL, -10, HXP.halfWidth, HXP.halfHeight);
		addGraphic(bubbleR, -10, HXP.halfWidth, HXP.halfHeight);
		
		addGraphic(controllerL, -10, HXP.halfWidth, HXP.halfHeight);
		addGraphic(controllerR, -10, HXP.halfWidth, HXP.halfHeight);
		addGraphic(keyboardL, -10, HXP.halfWidth, HXP.halfHeight);
		addGraphic(keyboardR, -10, HXP.halfWidth, HXP.halfHeight);
		
		
		spritey.add("blink",[0,1,2],11);
		spritey.play("blink");
		
		
		
		addGraphic(shadow, -60, HXP.halfWidth + 300, HXP.halfHeight + 200);
		addGraphic(spritey, - 60, HXP.halfWidth + 300, HXP.halfHeight + 200);
		addGraphic(countI, - 60, HXP.halfWidth + 210, HXP.halfHeight + 200);
		
		
		back.color = 0x282f44;
		
		back.alpha = 0;
		back.scaleX = HXP.width; back.scaleY = HXP.height;
		
		addGraphic(back, -120,0,0);
		
		
		
		addTween(tweenPress,false);
		
		
		//MUSIC
		nana.loop(0);
		
		show1();
		tright();
		
		var tween1:VarTween = new VarTween(bub1, TweenType.Persist);
		tween1.tween(plus, "scale", 1, 0.5, Ease.expoOut);
		addTween(tween1, true);
		
		addTween(tweenLy, false);
		addTween(tweenRy, false);
		
	}
	
	var tweenPress:VarTween = new VarTween(null, TweenType.Persist);
	
	var player1:Int = -1;
	var player2:Int = -1;
	// control: 0 = keyboard / 1 = controller 1 / 2 = controller 2
	
	var tau:Float = 6.283;
	
	var sin:Float = 0;
	
	override public function update():Void
	{
		
		if (nana.volume < 0.7) nana.volume += 0.01;
		
		//ANGLES SCALES
		
		youlostShadow.angle = youlost.angle;
		youlostShadow.scale = youlost.scale;
		
		bubbleR.angle += 0.1;
		bubbleR.angle %= 360;
		bubbleL.angle = bubbleR.angle + 150;
		
		pressanyR.scale = bubbleR.scale;
		pressanyL.scale = bubbleL.scale;
		
		keyboardL.scale = controllerL.scale;
		keyboardR.scale = controllerR.scale;
		
		//UP DOWN SINE
		
		sin += 0.1;
		sin %= tau;
		
		keyboardL.y = controllerL.y = pressanyL.y = 15 + (Math.sin(sin) * 10);
		keyboardR.y = controllerR.y = pressanyR.y = 15 + (Math.sin(sin + 2) * 10);
		
		
		
		//READY UP!
		if (player2 == -1) countI.frame = 0;
		else countI.frame = 1;
		
		if (player1 != -1)
		{
			if (!gogo)
			{
			if (spritey.scale == 0)
			{
				tweenPress.tween(spritey, "scale", 1, 0.5, EaseElastic.elasticOut);
				tweenPress.start();
				countI.visible = true;
				
			}
			
			
			if (Input.joystick(0).pressed(XBOX_GAMEPAD.A_BUTTON) && (player1 == 1 || player2 == 1))
			{
				goStart();
			}
			else if (Input.joystick(1).pressed(XBOX_GAMEPAD.A_BUTTON) && (player1 == 2 || player2 == 2))
			{
				goStart();
			}
			else if ((Input.pressed(Key.SPACE) || Input.pressed(Key.ENTER) || Input.pressed(Key.F)) && (player1 == 0 || player2 == 0))
			{
				goStart();
			}
			}
		}
		else
		{
			if (spritey.scale == 1)
			{
				tweenPress.tween(spritey, "scale", 0, 0.5, Ease.expoOut);
				tweenPress.start();
				countI.visible = false;
			}
		}
		
		
		
		if (!gogo)
		{
		
		//PLAYER LEFT?
		
		if (Input.joystick(0).pressed(XBOX_GAMEPAD.B_BUTTON)) 
		{
			if (player1 == 1) { player1 = -1; hideL(); bubbleL.visible = false; left(); }
			else if (player2 == 1) { player2 = -1; hideR(); bubbleR.visible = false; left();}
		}
		if (Input.joystick(1).pressed(XBOX_GAMEPAD.B_BUTTON)) 
		{
			if (player1 == 2) { player1 = -1; hideL(); bubbleL.visible = false; left(); }
			else if (player2 == 2) { player2 = -1; hideR(); bubbleR.visible = false; left();}
		}
		if (Input.pressed(Key.ESCAPE)) 
		{
			if (player1 == 0) { player1 = -1; hideL(); bubbleL.visible = false; left(); }
			else if (player2 == 0) { player2 = -1; hideR(); bubbleR.visible = false; left();}
		}
		
		//NEW PLAYER JOINED!!!
		
		if (Input.joystick(0).pressed() && !Input.joystick(0).pressed(XBOX_GAMEPAD.B_BUTTON)) 
		{
			if (player1 == -1 && player2 != 1) { player1 = 1; displayL(); bubbleL.visible = true; keyboardL.visible = false; controllerL.visible = true; hi(); }
			else if (player2 == -1 && player1 != 1) { player2 = 1; displayR(); bubbleR.visible = true; keyboardR.visible = false;controllerR.visible = true; hi();}
		}
		if (Input.joystick(1).pressed() && !Input.joystick(1).pressed(XBOX_GAMEPAD.B_BUTTON))
		{
			if (player1 == -1 && player2 != 2) { player1 = 2; displayL(); bubbleL.visible = true; keyboardL.visible = false; controllerL.visible = true; hi();}
			else if (player2 == -1 && player1 != 2) { player2 = 2; displayR(); bubbleR.visible = true; keyboardR.visible = false;controllerR.visible = true; hi();}
		}
		if (Input.pressed(Key.W) || Input.pressed(Key.S) || Input.pressed(Key.A) ||
		Input.pressed(Key.D) || Input.pressed(Key.SPACE) || Input.pressed(Key.F) ||
		Input.pressed(Key.E) ||Input.pressed(Key.Q) ||Input.pressed(Key.ENTER)||Input.pressed(Key.NUMPAD_ENTER))
		{
			if (player1 == -1 && player2 != 0) { player1 = 0; displayL(); bubbleL.visible = true; controllerL.visible = false;keyboardL.visible = true; hi();}
			else if (player2 == -1 && player1 != 0) { player2 = 0; displayR(); bubbleR.visible = true; controllerR.visible = false;keyboardR.visible = true; hi();}
		}
		
		
		
		}
		else
		{
			if (nana.volume > 0) nana.volume -= 0.02;
			back.alpha += 0.02;
		}
		
		super.update();
	}
	
	function hi(e:Dynamic = null):Void
	{
		var rnd:Int = HXP.rand(3);
		if (rnd == 0) g1.play();
		else if (rnd == 1) g2.play();
		else if (rnd == 2) g3.play();
		klick.play();
	}
	function left(e:Dynamic = null):Void
	{
		cancel.play();
	}
	
	var gogo:Bool = false;
	
	function goStart(e:Dynamic = null):Void
	{
		gogo = true;
		klick.play();
		hideL();
		hideR();
		tweenPress.tween(spritey, "scale", 0, 0.5, Ease.expoOut);
		tweenPress.start();
		countI.visible = false;
		
		HXP.alarm(1, next, TweenType.OneShot);
		
	}
	
	function next(e:Dynamic = null):Void
	{
		nana.stop();
		HXP.scene = new MainScene();
		
		if (player2 == -1) MainScene.player = 1;
		else MainScene.player = 2;
		
		MainScene.control1 = player1;
		MainScene.control2 = player2;
	}
	
	
	var tweenLy:VarTween = new VarTween(null, TweenType.Persist);
	var tweenRy:VarTween = new VarTween(null, TweenType.Persist);
	
	function displayL(e:Dynamic = null):Void
	{
		tweenLy.tween(controllerL, "scale", 1, 1, EaseElastic.elasticOut);
		tweenLy.start();
	}
	function displayR(e:Dynamic = null):Void
	{
		tweenRy.tween(controllerR, "scale", 1, 1, EaseElastic.elasticOut);
		tweenRy.start();
	}
	function hideL(e:Dynamic = null):Void
	{
		tweenLy.tween(controllerL, "scale", 0, 0.7, Ease.expoOut);
		tweenLy.start();
	}
	function hideR(e:Dynamic = null):Void
	{
		tweenRy.tween(controllerR, "scale", 0, 0.7, Ease.expoOut);
		tweenRy.start();
	}
	
	function show1(e:Dynamic = null):Void
	{
		
		var tweeny:VarTween = new VarTween(null, TweenType.Persist);
		tweeny.tween(youlost, "scale", 1, 1, EaseElastic.elasticOut);
		addTween(tweeny, true);
		
	}
	
	function bub1(e:Dynamic = null):Void
	{
		var tween1:VarTween = new VarTween(bub2, TweenType.Persist);
		tween1.tween(bubbleL, "scale", 1, 0.5, Ease.expoOut);
		addTween(tween1, true);
	}
	function bub2(e:Dynamic = null):Void
	{
		var tween1:VarTween = new VarTween(null, TweenType.Persist);
		tween1.tween(bubbleR, "scale", 1, 0.5, Ease.expoOut);
		addTween(tween1, true);
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