package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.KeyboardEvent;
	import flash.media.Sound;
	import flash.geom.ColorTransform;
	import fl.motion.easing.Back;
	import flash.events.MouseEvent;
	import fl.motion.Color;
	import fl.motion.easing.Linear;
	import flash.geom.ColorTransform;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flashx.textLayout.events.ScrollEvent;
	
	public class gravityDodgeAs extends MovieClip
	{
		public function gravityDodgeAs()
		{
/*
-Variables
-On load
-Event Listeners
	-Enter Frame (gLoop)
	-Key Down(downkey)
	-Key Up(upkey)
	-XML(processXML)
-Functions
	-healthBar
	-movePlayer
	-spawnBubs
	-moveBubs
	-explode
	-explodeBubs
	-changeBubs
	-refreshTxt
	-endGame
*/
			//variables
			var myColorTransform = new ColorTransform();//defines the color transform
			var myLoader:URLLoader = new URLLoader();
			var myXML:XML;
			var music:Sound = new nujabes();//plays "Reflection Eternal" by Nujabes
			music.play();
			//v All three run parellel, make sure to splice them all at the same time v
			var bubArray:Array = new Array();//holds all the bubbles
			var bxArray:Array = new Array();//holds bubbles xspeed
			var byArray:Array = new Array();//holds bubbles xspeed
			
			var exArray:Array = new Array();//holds the exploding bubbles
			
			var nGrav:Boolean = false;//is there gravity pulling north?
			var eGrav:Boolean = false;
			var sGrav:Boolean = false;
			var wGrav:Boolean = false;
			
			var spawnRate:Number = 8;//alters how many ticks inbetween running spawnBubs
			var tickClock:Number = 0;//place holder counter
			var spawnSide:Number = 1;//1 for north, 2 for east ect
			var lives:Number = 5;//start with 5 lives, lose when hitting exploding bubble or evil bubble
			var score:Number = 0;//amount of bubbles absorbed
//onload
			var p:p1 = new p1();//spawns player
			p.x = 275;
			p.y = 200;
			addChild(p);
			//text
			var scoreTxt:TextField = new TextField();//holds score(# of bubA's absorbed)
			scoreTxt.x = 525;
			scoreTxt.y = 10;
			scoreTxt.text = String(score);
			addChild(scoreTxt);
			var sf:TextFormat = new TextFormat();
			sf.bold = true;
			scoreTxt.setTextFormat(sf);
			var xmlTxt:TextField = new TextField();//xml textfield
			xmlTxt.x = 5;
			xmlTxt.y = 30;
			xmlTxt.width = 155;//this and below needed to fit it all onstage
			xmlTxt.multiline = true;
			xmlTxt.wordWrap = true;
			//draws healthbar
			var hBar:bar = new bar();
			hBar.x = 51;
			hBar.y = 13.5;
			addChild(hBar);
			var filler:fill = new fill();//red filler inside bar
			filler.x = 51;
			filler.y = 13.5;
			addChild(filler);
			//loads xml
			myLoader.load(new URLRequest("info.xml"));
//event listeners
			addEventListener(Event.ENTER_FRAME, gLoop);
			function gLoop(e:Event):void
			{//holds game loop
				healthBar();//keeps track of lives, changes filler accordingly
				movePlayer();//moves player, stops them from escaping stage
				tickClock++;//constantly counts up once a tick
				if (tickClock > spawnRate)//lets you control how many ticks inbetween each exicution
				{
					spawnBubs();//spawns bubArray's
					tickClock = 0;//resets counter
				}
				moveBubs();//moves bubbles
				explodeBubs();//hithoxes and removing bubs
				changeBubs();//changes normal bubbles to red evil ones
				refreshTxt();//preforms acrobatics whist on fire
				if (lives <= 0) endGame();//ends everything
			}
			stage.addEventListener(KeyboardEvent.KEY_DOWN, downkey);
			function downkey(e:KeyboardEvent):void
			{//when any of these are true, movePlayer() will pull in corisponding direction
				if (e.keyCode == 37)wGrav = true;
				if (e.keyCode == 38)nGrav = true;
				if (e.keyCode == 39)eGrav = true;
				if (e.keyCode == 40)sGrav = true;
				//when "i" is pressed, display instructions from xml
				if (e.keyCode == 73)addChild(xmlTxt);
			}
			stage.addEventListener(KeyboardEvent.KEY_UP, upkey);
			function upkey(e:KeyboardEvent):void
			{//stops pulling player
				if (e.keyCode == 37)wGrav = false;
				if (e.keyCode == 38)nGrav = false;
				if (e.keyCode == 39)eGrav = false;
				if (e.keyCode == 40)sGrav = false;
				//stop showing instructions when let go
				if (e.keyCode == 73)removeChild(xmlTxt);
			}
			myLoader.addEventListener(Event.COMPLETE, processXML);
			function processXML(e:Event):void
			{
				myXML = new XML(e.target.data);
				xmlTxt.text = String(myXML.howtoplay);//makes xmlTxt = to xml value
			}
//functions
			function healthBar():void
			{//changes the position and width of filler inside of health bar
				filler.width = 20 * lives;
				filler.x = 10 * lives + 1;
				addChild(filler);//keeps filler on top of bubs/explosions so you can see health always
			}
			function movePlayer():void
			{//pulls player in direction, as long as they're not going offscreen
				if (wGrav == true && p.x > 0)p.x -=  10;
				if (nGrav == true && p.y > 0)p.y -=  10;
				if (eGrav == true && p.x < 550)p.x +=  10;
				if (sGrav == true&& p.y < 400)p.y +=  10;
			}
			function spawnBubs():void
			{//spawns bubArrays
				var bub:orb = new orb();//make a bubble
				bub.width = 15;
				bub.height = 15;
				myColorTransform.color = Math.random() * 0xFFFFFF;
				bub.transform.colorTransform = myColorTransform;
				bubArray.push(bub);//add it to the bubArray
				addChild(bub);
				//random number between 0-5, choses what side bubs will spawn. Might not be 25% even chances
				if (spawnSide <= 1)
				{//North
					bubArray[bubArray.length - 1].x = Math.random() * 450 + 50;//bubs dont spawn on outer 50px
					bubArray[bubArray.length - 1].y = 1;
					bxArray.push(Math.random() * 20 - 10);
					byArray.push(Math.random() * 10);
				}
				if (spawnSide == 2)
				{//East
					bubArray[bubArray.length - 1].x = 549;
					bubArray[bubArray.length - 1].y = Math.random() * 300 + 50;
					bxArray.push(Math.random() * -10);
					byArray.push(Math.random() * 20 - 10);
				}
				if (spawnSide == 3)
				{//South
					bubArray[bubArray.length - 1].x = Math.random() * 450 + 50;
					bubArray[bubArray.length - 1].y = 399;
					bxArray.push(Math.random() * 20 - 10);
					byArray.push(Math.random() * -10);
				}
				if (spawnSide >= 4)
				{//WEST SIDE REP!@!@!
					bubArray[bubArray.length - 1].x = 1;
					bubArray[bubArray.length - 1].y = Math.random() * 300 + 50;
					bxArray.push(Math.random() * 10);
					byArray.push(Math.random() * 20 - 10);
				}
				spawnSide = Math.floor(Math.random() * 5);//if its 4, you will VERY rarely get a 4, only 3.x
			}
			function moveBubs():void
			{
				for (var k:Number = 0; k < bubArray.length; k++)
				{//moves bubble array at its speed
					bubArray[k].x +=  bxArray[k];
					bubArray[k].y +=  byArray[k];
					if (bubArray[k].hitTestObject(p)){//when it hits a player
						removeChild(bubArray[k]);//get it offscreen
						if (bubArray[k].width > 15) lives--;//evil bubbles will ALWAYYS be more than 15 in width
						else if(lives > 1) score++;//if you still have lives and the bub wasn't evil, add to score
						bubArray.splice(k, 1);//removes from the array
						bxArray.splice(k, 1);
						byArray.splice(k, 1);
						spawnRate -= Math.random() / 10;
					}	//every score that you get, it lowers the amount of ticks inbetween spawnBubs by 0-0.1
				}
			}
			function explode(bx, by):void
			{//spawns an exploding bubble at the x and y coord passed through function
				var exBub:orb = new orb();
				exArray.push(exBub);
				exArray[exArray.length - 1].width = 15;
				exArray[exArray.length - 1].height = 15;
				exArray[exArray.length - 1].x = bx;
				exArray[exArray.length - 1].y = by;
				addChild(exArray[exArray.length - 1]);
			}
			function explodeBubs():void
			{
				for (var k:Number = 0; k < bubArray.length; k++)
				{
					if (bubArray[k].y > 415 || bubArray[k].y < 0 || bubArray[k].x > 565 || bubArray[k].x < -15)
					{//when bub goes offscreen, remove it
						removeChild(bubArray[k]);
						bubArray.splice(k, 1);
						bxArray.splice(k, 1);
						byArray.splice(k, 1);
						break;
					}
					for (var j:uint = k + 1; j < bubArray.length; j++)
					{
						if (k != j && bubArray[k].hitTestObject(bubArray[j]))
						{//when a bub hits a bub remove them both and run explode, pass through x and y coord
							explode(bubArray[j].x, bubArray[j].y);
							removeChild(bubArray[j]);
							bubArray.splice(j, 1);
							removeChild(bubArray[k]);
							bubArray.splice(k, 1);
							bxArray.splice(j, 1);
							byArray.splice(j, 1);
							bxArray.splice(k, 1);
							byArray.splice(k, 1);
							break;
						}
					}
				}
			}
			function changeBubs():void
			{//creates evil bubbles, makes explosions bigger and removes them when needed
				for (var e:Number = 0; e < bubArray.length; e++)
				{//no difference from normal bubs other than a larger diamiter and a red color
					for (var u:Number = 0; u < exArray.length; u++)
					{
						if (bubArray[e].hitTestObject(exArray[u]))
						{
							myColorTransform.color = 0xFF0000;
							bubArray[e].transform.colorTransform = myColorTransform;
							bxArray[e] *= 1.1;//the longer the bub is in the explosion, the faster/larger itll be
							byArray[e] *= 1.1;
							bubArray[e].width += 1.5;
							bubArray[e].height += 1.5;
						}
					}
				}
				for (var j:Number = 0; j < exArray.length; j++)
				{
					if (exArray[j].hitTestObject(p))
					{//if you hit an exploding bubble, remove it and you lose a life
						lives--;
						removeChild(exArray[j]);
						exArray.splice(j, 1);
						break;
					}
					exArray[j].width +=  .7;
					exArray[j].height +=  .7;
					if (exArray[j].width > 140)
					{//when it reaches maximum diamiter remove it
						removeChild(exArray[j]);
						exArray.splice(j, 1);
						break;
					}
				}
			}
			function refreshTxt():void
			{//keep refreshing text
				scoreTxt.text = String(score);
				scoreTxt.setTextFormat(sf);
			}
			function endGame():void
			{
				spawnRate = 1000000000;
			}
		}
	}
}