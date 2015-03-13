package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.KeyboardEvent;//only needed if controling paddle with keyboard.
	import flash.media.Sound; //needed for sound
	import flash.geom.ColorTransform;//needed for colors
	public class brickBreaker extends MovieClip
	{
		public function brickBreaker()
		{//keep in mind, stage is 550x500. padd is on bottom and bricks get laid above
			//variables
			var myColorTransform = new ColorTransform();//sets up color transform
			var sc:Number = 0;
			var dir1:String = "stop"; //sets default speed of paddles to stopped
			var dir2:String = "stop";
			var wsh:Sound = new woosh();//creates the sounds variable, remember to import sound above
			var bArray:Array = new Array  ;
			var num:Number = 0;
			var lives:Number = 3;//keeps track of lives.
			var spdx:Number = 12;
			var spdy:Number = 12;
			var i:Number = 0;//sets up the increment variables, needed for forloop below
			var j:Number = 0;
			
			var p:pad = new pad  ;//this is the paddle
			p.y = 485;
			p.width = 80;
			p.height = 12;
			addChild(p);
			
			var t:TextField = new TextField  ;//adds lives to screen
			t.x = 5;
			t.y = 20;
			var tf:TextFormat = new TextFormat  ;
			t.text = String(lives);//the variable lives will be printed to screen
			tf.color = 0xFF00FF;
			t.setTextFormat(tf);
			addChild(t);
			
			var s:TextField = new TextField  ;//adds score to screen
			s.x = 502;
			s.y = 20;
			s.textColor = Math.random() * 0xFFFFFF;//because of silly text format req
			var sf:TextFormat = new TextFormat  ;
			s.text = String(sc);
			s.setTextFormat(sf);
			addChild(s);
			
			var b:ball = new ball  ;//defines ball, if you dont have the reset ball function you need to set coords.
			b.height = 24;
			b.width = 24;
			addChild(b);
			
			var hrt1:heart = new heart;//code for hearts
			hrt1.x = 60;
			hrt1.y = 25;
			addChild(hrt1);
			var hrt2:heart = new heart;
			hrt2.x = 72;
			hrt2.y = 25;
			addChild(hrt2);
			var hrt3:heart = new heart;
			hrt3.x = 84;
			hrt3.y = 25;
			addChild(hrt3);
			var bart:pad = new pad;//code for border and progress bar, ignore if not used
			bart.x = 250;
			bart.y = 40;
			bart.width = 1000;
			bart.height = 2;
			myColorTransform.color = 0x000000;
			bart.transform.colorTransform = myColorTransform;
			addChild(bart);
			var bar3:pad = new pad;
			bar3.x = 150;
			bar3.y = 20;
			bar3.width = 2;
			bar3.height = 40;
			bar3.transform.colorTransform = myColorTransform;
			addChild(bar3);
			var bar4:pad = new pad;
			bar4.x = 350;
			bar4.y = 20;
			bar4.width = 2;
			bar4.height = 40;
			bar4.transform.colorTransform = myColorTransform;
			addChild(bar4);
			var pbar:pad = new pad;
			myColorTransform.color = 0x66FF00;
			pbar.transform.colorTransform = myColorTransform;
			pbar.height = 40;
			pbar.y = 20;
			myColorTransform.color = 0x66FF00;
			pbar.transform.colorTransform = myColorTransform;
			
			for (i = 0; i < 4; i++)//change the 4 depending on how many rows of blocks you want
			{
				if (i == 0) myColorTransform.color = 0xFF0000;//sets the first layers color
				if (i == 1) myColorTransform.color = 0xFFFF00;//sets the second
				if (i == 2) myColorTransform.color = 0x008000;//sets the third
				if (i == 3) myColorTransform.color = 0x0000FF;//sets the forth
				for (j = 0; j < 10; j++)//change the 10 for amount of collums
				{
					var br:block = new block  ;
					br.transform.colorTransform = myColorTransform;//sets the block to whatever color is chosen above
					bArray.push(br);//no idea what this does, dont forget it
					addChild(br);
					bArray[num].x = j * 55 + 2;//2 is the distance between the first block and side of stage
					bArray[num].y = i * 25 + 45;//25 is distance between the blocks, block is 20 high so 5 apart
					num++;
				}
			}
			function resetBall()
			{//sets the ball back to the paddle
				b.x = p.x;
				b.y = p.y - 6;
			}
			resetBall();//sets the ball up
			function endGame(){//stops the ball and makes it move off screen
				b.x = 1000;
				spdy = 0;
				spdx = 0;
			}
			addEventListener(Event.ENTER_FRAME,gameLoop);
			function gameLoop(e:Event)
			{
				if (p.x < 40) p.x = 40;//makes sure paddle doesn't go off screen
				if (p.x > 510) p.x = 510;
				b.x +=  spdx;//makes the ball move
				b.y +=  spdy;
				if (dir1=="left"  && p.x > 40)  p.x -= 8;//moves paddle (r1) up if direction is up
				if (dir1=="right" && p.x < 510) p.x += 8;
				
				for (var i:Number = 0; i < num; i++)
				{
					if (b.hitTestObject(bArray[i]))
					{                    //bArray[i].x + (bArray[i].width / 2)
						spdx = 5 * (b.x - (bArray[i].x + 25)) / 25;//angle code for brick, make sure its before code that moves it off screen
						spdy *=  -1;
						bArray[i].x +=  800;//moves brick off screen
						wsh.play();//plays sound effect
						if (bArray[i].y <= 45) sc+= 1;
						if (bArray[i].y <= 70) sc+= 1;
						if (bArray[i].y <= 95) sc+= 1;
						if (bArray[i].y <= 120)sc+= 1;
						break;//leaves the loop
					}
				}
				if (p.hitTestObject(b))//hitbox for paddle
				{
					if (spdy > 0) spdy *= -1;//           / (p.width / 2)
					spdx  = 5 * (b.x - p.x) / 40; //angle on paddle
					b.y  -= 6;
				}
				if (b.y <= 53 && spdy < 0)spdy *=  -1;//&& spdy<0 is vital to stop ball from glitching in wall
				if (b.y >= 500 && spdy > 0)//if ball goes offscreen on the bottom
				{
					resetBall();//runs the resetBall function
					lives -= 1;
				}
				if (spdx < 0 && b.x < 12)spdx *=  -1;
				if (b.x >= 538 && spdx > 0)spdx *=  -1;//makes sure ball doesn't go further than 550-radius
				if (lives <= 0) {//when lives run out, ball no longer respawns
					b.x = 1000;
					spdy = 0;
					spdx = 0;
				}
				if (lives == 2) hrt3.x = 1111;//when lives go down, hearts will move offscreen
				if (lives == 1) hrt2.x = 1111;
				if (lives == 0) {
					hrt1.x = 1111
					myColorTransform.color = 0xCC0000;
					pbar.transform.colorTransform = myColorTransform;//turns prog bar red when you die
				}
				
				if (sc == 100) lives += 1;//when user completes game, they get infinite lives
				pbar.width = 0 + (2 * sc);//width of progress bar filling is constantly added to
				pbar.x = 150 + (sc);//bar is moved over to seem to flow from left side of box
				addChild(pbar);
				t.text = String("Lives: " + lives);//refreshes lives
				s.text = String("Score: " + sc);//refreshes score, places the text on screen
			}
			stage.addEventListener(KeyboardEvent.KEY_DOWN, downkey);
			function downkey(e:KeyboardEvent):void {//when certain keycode is down, change dir to match the direction.
				if (e.keyCode==37) dir1="left"; //'<'
				if (e.keyCode==39) dir1="right";//'>'
				/*if (e.keyCode==81) {//when q is pressed, ball speeds super fast for test purposes only.
					spdy *= 2;
					spdx *= 2;
				}*/
			}
			stage.addEventListener(KeyboardEvent.KEY_UP, upkey);
			function upkey(e:KeyboardEvent):void {
				if (e.keyCode == 37 || e.keyCode == 39) dir1="stop";//when you're not holding any keys, stay in place
			}
		}
	}
}