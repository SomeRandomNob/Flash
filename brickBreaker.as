package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.KeyboardEvent;//only needed if controling paddle with keyboard.
	import flash.media.Sound; //needed for sound
	import flash.geom.ColorTransform;
	public class brickBreaker extends MovieClip
	{

		public function brickBreaker()
		{//keep in mind, stage is 550x400. padd is is on bottom and bricks get laid above
			//variables
			var p:pad = new pad  ;//this is the paddle
			p.y = 385;
			p.width = 80;
			p.height = 12;
			addChild(p);

			var myColorTransform = new ColorTransform();
			var sc:Number = 0;
			var dir1:String = "stop"; //sets default speed of paddles to stopped
			var dir2:String = "stop";
			var wsh:Sound = new woosh();//creates the sounds variable, remember to import sound above
			var bArray:Array = new Array  ;
			var num:Number = 0;

			var t:TextField = new TextField  ;//adds lives to screen
			t.x = 355;
			t.y = 120;
			var tf:TextFormat = new TextFormat  ;
			t.text = String(lives);//the variable lives will be printed to screen
			tf.color = 0xFFFFFF;
			t.setTextFormat(tf);
			addChild(t);
			
			var s:TextField = new TextField  ;//adds score to screen
			s.x = 155;
			s.y = 120;
			var sf:TextFormat = new TextFormat  ;
			s.text = String(sc);
			sf.color = 0xFFFFFF;
			s.setTextFormat(sf);
			addChild(s);
			
			var b:ball = new ball  ;//defines ball, if you dont have the reset ball function you need to set coords.
			b.height = 24;
			b.width = 24;
			addChild(b);

			var lives:Number = 4;//keeps track of lives, start one number above amount of lives you want

			var spdx:Number = 8;
			var spdy:Number = 8;

			function layBrick(){
			for (var i:Number = 0; i < 4; i++)//change the 4 depending on how many rows of blocks you want
			{
				if (i == 1) myColorTransform.color = 0xFF0000;
				if (i == 2) myColorTransform.color = 0xFFFF00;
				if (i == 3) myColorTransform.color = 0x008000;
				if (i == 4) myColorTransform.color = 0x0000FF;
				for (var j:Number = 0; j < 10; j++)//change the 10 for amount of collums
				{
					var br:block = new block  ;
					br.transform.colorTransform = myColorTransform;
					bArray.push(br);
					addChild(br);
					bArray[num].x = j * 55 + 2;//2 is the distance between the first block and side of stage
					bArray[num].y = i * 25 + 5;//25 is distance between the blocks, block is 20 high so 5 apart
					num++;
				}
			}
			}
			function resetBall()
			{//sets the ball back to the paddle
				b.x = p.x;
				b.y = p.y - 5;
				lives -= 1;
			}
			resetBall();//sets the ball up, removes one life.
			function endGame(){//stops the ball and makes it move off screen
				b.x = 1000;
				b.y = 10;
				spdy = 0;
				spdx = 0;
			}
			layBrick();
			addEventListener(Event.ENTER_FRAME,gameLoop);
			function gameLoop(e:Event)
			{
				if (p.x < 40) p.x = 40;//makes sure paddle doesn't go off screen
				if (p.x > 510) p.x = 510;
				b.x +=  spdx;
				b.y +=  spdy;
				if (dir1=="left"  && p.x > 40)  p.x -= 8;//moves paddle (r1) up if direction is up
				if (dir1=="right" && p.x < 510) p.x += 8;
				
				
				
				for (var i:Number = 0; i < num; i++)
				{
					if (b.hitTestObject(bArray[i]))
					{                    //bArray[i].x + (bArray[i].width / 2)
						spdx = 5 * (b.x - (bArray[i].x + 25)) / 25;//angle code for brick, make sure its before code that moves it off screen
						bArray[i].x +=  800;//moves brick off screen
						spdy *=  -1;
						wsh.play();//plays sound effect
						sc += 1;
						trace(i);
						break;//leaves the loop
					}
				}
				if (p.hitTestObject(b))//hitbox for paddle
				{
					spdy *=  -1;//          / (p.width / 2)
					spdx  = 5 * (b.x - p.x) / 40; //angle on paddle
					b.y  -=  6
				}
				if (b.y <= 12)
				{
					spdy *=  -1;
				}
				if (b.y >= 400)//if ball goes offscreen on the bottom
				{
					resetBall();//runs the resetBall function
				}
				if (((spdx < 0) && b.x < 12))
				{
					spdx *=  -1;
				}
				if (b.x >= 538 && spdx > 0)
				{
					spdx *=  -1;
				}
				if (lives <= 0) endGame();//if you run out of lives, run the endGame function
				t.text = String("Lives: " + lives);//refreshes lives
				s.text = String("Score: " + sc);//refreshes lives, places the text on screen
			}
			stage.addEventListener(KeyboardEvent.KEY_DOWN, downkey);
			function downkey(e:KeyboardEvent):void {//when certain keycode is down, change dir to match the direction.
				if (e.keyCode==37) dir1="left"; //'<'
				if (e.keyCode==39) dir1="right";//'>'
				///if (e.keyCode==81) trace(num);
			}
			stage.addEventListener(KeyboardEvent.KEY_UP, upkey);
			function upkey(e:KeyboardEvent):void {
				if (e.keyCode == 37 || e.keyCode == 39) dir1="stop";//when you're not holding any keys, stay in place
			}
		}
	}
}